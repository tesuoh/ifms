package ifms.common.file.web;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.egovframe.rte.fdl.security.userdetails.util.EgovUserDetailsHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import ifms.common.file.service.FileService;
import ifms.common.file.vo.FileDownloadVO;
import ifms.common.file.vo.FileVO;
import ifms.common.util.FileUtil;
import ifms.core.security.service.AuthUser;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


@Controller
@RequestMapping("/common/file")
public class FileController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private FileService fileService;

    @Autowired
    private FileUtil fileUtil;

    @PostMapping(value = "/single/upload.json")
    public void singleUpload(HttpServletRequest request, ModelMap model
            , @RequestParam("_file") MultipartFile multipartFile
            , @RequestParam("_key") String _key
            //, @RequestParam("_mId") String _mId
            , @RequestParam(required=true, value="fileGroupSn", defaultValue="0" ) int fileGroupSn								/* 파일그룹 KEY */
            , @RequestParam(required=false, value="fileTypeSeCd", defaultValue="N" ) String fileTypeSeCd
            , @RequestParam(required=false, value="fileChangeYn", defaultValue="") String fileChangeYn
    ) throws Exception{

        String userId = "SYSTEM";				// 비로그인 상태 Default 설정

        if(EgovUserDetailsHelper.isAuthenticated()) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            AuthUser principal = (AuthUser) authentication.getPrincipal();
            userId = principal.getSessionVO().getUserId();
        }

        /* 필수값 */
        model.addAttribute("_key", _key);
        //model.addAttribute("_mId", _mId);

        /** 서버상의 업로드경로가 포함된 업로드 파일 */
        FileVO vo = fileUtil.getFileVO(multipartFile, null);
        vo.setFileGroupSn(fileGroupSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileTypeSeCd(fileTypeSeCd);
        //vo.setMenuId(_mId);
        vo.setRgtrId(userId);
        vo.setMdfrId(userId);
        vo.setFileChangeYn(fileChangeYn);
        model.addAttribute("fileChangeYn", fileChangeYn);


        File uploadFile = new File(vo.getFileFullPath());

        try {
            InputStream fileStream = multipartFile.getInputStream();
            FileUtils.copyInputStreamToFile(fileStream, uploadFile);

            /* 파일 업로드정보 생성하기 */
            FileVO fileVO = fileService.saveFile(vo);

            model.addAttribute("file", fileVO);

        } catch (IOException e) {
            FileUtils.deleteQuietly(uploadFile);
            logger.error("파일업로드 실패", e);
            throw e;
        }

    }


    /**
     * upload single 파일삭제
     * @param authUser
     * @param _key
     * @param fileGroupSn
     * @param fileDtlSn
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/single/delete.json")
    public void delete(HttpServletRequest request, ModelMap model
            , @RequestParam("_key") String _key
            , @RequestParam(required=true, value="fileGroupSn", defaultValue="0" ) int fileGroupSn								/* 파일그룹 KEY */
            , @RequestParam(required=true, value="fileDtlSn", defaultValue="0" ) int fileDtlSn							/* 파일상세 KEY */
    ) throws Exception{

        String userId = "SYSTEM";				// 비로그인 상태 Default 설정

        if(EgovUserDetailsHelper.isAuthenticated()) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            AuthUser principal = (AuthUser) authentication.getPrincipal();
            userId = principal.getSessionVO().getUserId();
        }

        /* 필수값 */
        model.addAttribute("_key", _key);
        model.addAttribute("fileDtlSn", fileDtlSn);

        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileDtlSn(fileDtlSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setMdfrId(userId);
        vo.setDelYn("N");  // 삭제 전 파일 정보 조회를 위해 DEL_YN = 'N' 설정

        /* 삭제할 파일 정보 조회 */
        FileVO fileInfo = fileService.selectFileDtl(vo);
        
        /* 파일정보 삭제하기 - UPDATE처리 */
        vo.setMdfrId(userId);
		int result = fileService.deleteFile(vo);
		
		/* 물리적 파일 삭제 */
		if (result > 0 && fileInfo != null) {
			String fileFullPath = fileInfo.getFileFullPath();
			if (fileFullPath != null && !fileFullPath.isEmpty()) {
				File physicalFile = new File(fileFullPath);
				if (physicalFile.exists()) {
					boolean deleted = physicalFile.delete();
					if (!deleted) {
						logger.warn("물리적 파일 삭제 실패: " + fileFullPath);
					} else {
						logger.debug("물리적 파일 삭제 성공: " + fileFullPath);
					}
				}
			}
		}
		
		model.addAttribute("result", result);
    }

    /**
     * upload single 파일정보 불러오기
     * @param authUser
     * @param fileGroupSn
     * @param fileDtlSn
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/single/detail.json")
    public void singleDetail(HttpServletRequest request, ModelMap model
            , @RequestParam("_key") String _key
            , @RequestParam(required=true, value="fileGroupSn") int fileGroupSn								/* 파일그룹 KEY - 필수값 */
    ) throws Exception{

        /* 필수값 */
        model.addAttribute("_key", _key);

        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileTypeSeCd("N");
        vo.setDelYn("N");

        FileVO fileVO = fileService.selectFileDtl(vo);

        model.addAttribute("file", fileVO);

    }


    /**
     * uplaod multi 파일업로드
     * @param authUser
     * @param multipartFile
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/multi/upload.json")
    public void multiUpload(HttpServletRequest request, ModelMap model
            , @RequestParam("_file") MultipartFile multipartFile[]
            , @RequestParam("_key") String _key
            /*, @RequestParam("_mId") String _mId*/
            , @RequestParam(required=true, value="fileGroupSn", defaultValue="0" ) int fileGroupSn	/* 파일그룹 KEY */
            , @RequestParam(required=false, value="fileTypeSeCd", defaultValue="Y" ) String fileTypeSeCd
    ) throws Exception{

        String userId = "SYSTEM";				// 비로그인 상태 Default 설정

        if(EgovUserDetailsHelper.isAuthenticated()) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            AuthUser principal = (AuthUser) authentication.getPrincipal();
            userId = principal.getSessionVO().getUserId();
        }

        /* 필수값 */
        model.addAttribute("_key", _key);
        /*model.addAttribute("_mId", _mId);*/

        List<FileVO> resultList = new ArrayList<FileVO>(multipartFile.length);

        for(int i=0;i<multipartFile.length;i++) {

            FileVO fileVO = null;

            /** 서버상의 업로드경로가 포함된 업로드 파일 */
            FileVO vo = fileUtil.getFileVO(multipartFile[i], null);
            vo.setFileGroupSn(fileGroupSn);																	//화면에서 넘어온 파일그룹 KEY
            vo.setFileTypeSeCd(fileTypeSeCd);
            /*vo.setMenuId(_mId);*/
            vo.setRgtrId(userId);
            vo.setMdfrId(userId);

            File uploadFile = new File(vo.getFileFullPath());

            try {

                InputStream fileStream = multipartFile[i].getInputStream();
                FileUtils.copyInputStreamToFile(fileStream, uploadFile);

                /* 파일 업로드정보 생성하기 */
                fileVO = fileService.saveFile(vo);

                /* 생성된 파일그룹 KEY 받아서 세팅하기 */
                fileGroupSn = fileVO.getFileGroupSn();

                model.addAttribute("file", fileVO);

            } catch (IOException e) {											//예외처리 - 에러가 발생해도 에러정보만 저장 후 다음파일 업로드처리
                fileVO = vo;

                logger.error("파일업로드 실패", e);

                FileUtils.deleteQuietly(uploadFile);

            } finally {
                resultList.add(fileVO);
            }

        }

        model.addAttribute("fileGroupSn", fileGroupSn);
        model.addAttribute("list", resultList);

    }

    /**
     * upload multi 파일목록 불러오기
     * @param authUser
     * @param fileGroupSn
     * @param fileDtlSn
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/multi/list.json")
    public void multiList(HttpServletRequest request, ModelMap model
            , @RequestParam("_key") String _key
            , @RequestParam(required=true, value="fileGroupSn") int fileGroupSn								/* 파일그룹 KEY - 필수값 */
    ) throws Exception{

        /* 필수값 */
        model.addAttribute("_key", _key);

        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setDelYn("N");

        List<FileVO> list = fileService.selectFileList(vo);

        model.addAttribute("list", list);

    }

    /**
     * 파일 다운로드
     * @param model
     * @param fileGroupSn
     * @param fileDtlSn
     * @param fileTypeSeCd
     * @return
     * @throws Exception
     */
    @PostMapping(value = "/download.file")
    public ModelAndView download(HttpServletRequest request, ModelMap model
            , @RequestParam(required=true, value="fileGroupSn") int fileGroupSn								/* 파일그룹 KEY */
            , @RequestParam(required=true, value="fileDtlSn") int fileDtlSn									/* 파일상세 KEY */
            , @RequestParam(required=true, value="fileTypeSeCd") String fileTypeSeCd						/* 파일유형 */
            , @RequestParam(required=true, value="fileNm") String fileNm									/* 서버파일명 */
    ) throws Exception{

        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);																//화면에서 넘어온 파일그룹 KEY
        vo.setFileDtlSn(fileDtlSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileTypeSeCd(fileTypeSeCd);															
        vo.setFileNm(fileNm);																		//서버 파일 명

        /* 다운로드 가능여부 체크 및 다운로드 대상 파일정보 생성 */
        FileDownloadVO fileDownloadVO = fileService.download(vo, request);

        /* 다운로드수 UPDATE 처리 */
        fileService.updateDwldCount(vo);

        return new ModelAndView("fileDownloadView", "fileDownloadVO", fileDownloadVO);

    }


    /**
     * 다운로드 실행전에 다운로드가 가능한지 체크한다 - iframe 우회처리
     * @param model
     * @param requestMap
     * @param request
     * @return
     * @throws Exception
     */
    @PostMapping(value = "/checkDownloadFile.json")
    public void checkDownloadFile(HttpServletRequest request, ModelMap model
            , @RequestBody Map<String, Object> requestMap
    ) throws Exception{

        int fileGroupSn = NumberUtils.toInt(String.valueOf(requestMap.get("fileGroupSn")));
        int fileDtlSn = NumberUtils.toInt(String.valueOf(requestMap.get("fileDtlSn")));
        String fileTypeSeCd = String.valueOf(requestMap.get("fileTypeSeCd"));
        String fileNm = String.valueOf(requestMap.get("fileNm"));
        
        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileDtlSn(fileDtlSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileTypeSeCd(fileTypeSeCd);
        vo.setFileNm(fileNm);

        /* 다운로드 가능여부 체크 및 다운로드 대상 파일정보 생성 */
        FileDownloadVO fileDownloadVO = fileService.download(vo, request);

        boolean result = fileDownloadVO.isAvailable();

        model.addAttribute("result", result);					//다운로드가능여부
        model.addAttribute("vo", fileDownloadVO);

    }

    
    /**
     * 파일 다운로드
     * @param model
     * @param fileGroupSn
     * @param fileDtlSn
     * @param fileTypeSeCd
     * @return
     * @throws Exception
     */
    @GetMapping(value = "/image.file")
    public ModelAndView viewImage(HttpServletRequest request, ModelMap model
            , @RequestParam(required=true, value="fileGroupSn") int fileGroupSn								/* 파일그룹 KEY */
            , @RequestParam(required=true, value="fileDtlSn") int fileDtlSn									/* 파일상세 KEY */
            , @RequestParam(required=true, value="fileNm") String fileNm									/* 서버파일명 */
    ) throws Exception{

        System.out.println("image.file : start");
        
        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);																//화면에서 넘어온 파일그룹 KEY
        vo.setFileDtlSn(fileDtlSn);																	//화면에서 넘어온 파일그룹 KEY
        vo.setFileNm(fileNm);																		//서버 파일 명

        /* 다운로드 가능여부 체크 및 다운로드 대상 파일정보 생성 */
        FileDownloadVO fileDownloadVO = fileService.download(vo, request);

        /* 다운로드수 UPDATE 처리 */
        fileService.updateDwldCount(vo);

        return new ModelAndView("fileDownloadView", "fileDownloadVO", fileDownloadVO);
    }

    @GetMapping(value = "/video.file")
    public ResponseEntity<Resource> viewVideo(HttpServletRequest request,
                                              @RequestParam(required = true, value = "fileGroupSn") int fileGroupSn,
                                              @RequestParam(required = true, value = "fileDtlSn") int fileDtlSn,
                                              @RequestParam(required = true, value = "fileTypeSeCd") String fileTypeSeCd,
                                              @RequestParam(required = true, value = "fileNm") String fileNm) throws Exception {

        FileVO vo = new FileVO();
        vo.setFileGroupSn(fileGroupSn);
        vo.setFileDtlSn(fileDtlSn);
        vo.setFileNm(fileNm);
        vo.setFileTypeSeCd(fileTypeSeCd);

        // 파일 다운로드 대상 정보 가져오기
        FileDownloadVO fileDownloadVO = fileService.download(vo, request);

        // 실제 파일 객체 가져오기
        File file = new File(fileDownloadVO.getFileFullPath());

        if (!file.exists()) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("status", HttpStatus.NOT_FOUND.value());
            errorResponse.put("error", "File Not Found");
            errorResponse.put("message", "파일을 찾을 수 없습니다: " + file.getAbsolutePath());

            return ResponseEntity.notFound().build();
        }


        // 비디오 파일을 스트리밍 가능한 형태로 반환
        Resource resource = new UrlResource(file.toURI());

        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType("video/mp4")) // 비디오 파일 MIME 타입 설정
                .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileNm + "\"")
                .body(resource);

    }



}
