package ifms.common.file.service;

import org.apache.commons.lang3.math.NumberUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ifms.common.file.mapper.FileMapper;
import ifms.common.file.vo.FileDownloadVO;
import ifms.common.file.vo.FileGroupVO;
import ifms.common.file.vo.FileVO;
import ifms.common.util.DateUtil;
import ifms.core.security.service.AuthUser;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
public class FileService {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private FileMapper fileMapper;

    /**
     * upload single/upload multi 파일 업로드정보 생성하기
     * @param fileVO
     * @return
     * @throws Exception
     */
    public FileVO saveFile(FileVO fileVO) throws Exception {

    	logger.debug("saveFile fileVO: " + fileVO.getFileNm() + fileVO.getOrgnlFileNm() + fileVO.getFileTypeSeCd());

    	/* 화면에서 넘어온 파일그룹정보 가 존재하지 않으면 파일그룹정보 생성하기 */
        if(fileVO.getFileGroupSn()==0) {
        	FileGroupVO fileGroupVO = new FileGroupVO(fileVO);
/*
            FileGroupVO fileGroupVO = new FileGroupVO();
            fileGroupVO.setFileTypeSeCd(fileVO.getFileTypeSeCd());
            fileGroupVO.setRgtrId(fileVO.getRgtrId());
            fileGroupVO.setMdfrId(fileVO.getRgtrId());
*/
            fileMapper.insertFileGroup(fileGroupVO);

            /* 파일그룹 PK 세팅 */
            fileVO.setFileGroupSn(fileGroupVO.getFileGroupSn());

        }

        /*
    	 * if(fileVO.getFileTypeSeCd().equals("N") &&
    	 * fileVO.getFileChangeYn().equals("Y")) { //single 파일교체
    	 * logger.debug("filePath"+ fileVO.getFilePath());
    	 * fileMapper.updateFile(fileVO); } else {
    	 *
    	 * }
    	 */
    	/* 파일상세정보 생성하기 */
    	fileMapper.insertFileDetail(fileVO);

        return fileVO;
    }

    /**
     * upload single/upload multi 개별삭제시 파일정보 삭제하기 - UPDATE처리
     * 		- 필수파라미터 : fileGroupSn, fileDtlSn
     * @param fileVO
     * @return
     * @throws Exception
     */
    public int deleteFile(FileVO fileVO) throws Exception {
        return fileMapper.deleteFile(fileVO);
    }
    
    /**
     * upload single 개별삭제시 파일정보 삭제하기 - DELETE처리
     * 		- 필수파라미터 : fileGroupSn, fileDtlSn
     * @param fileVO
     * @return
     * @throws Exception
     */
    public int deleteFileInfo(FileVO fileVO) throws Exception {
    	return fileMapper.deleteFileInfo(fileVO);
    }
    
    /**
     * upload single 개별삭제시 파일그룹정보 삭제하기 - DELETE처리
     * 		- 필수파라미터 : fileGroupSn, fileDtlSn
     * @param fileVO
     * @return
     * @throws Exception
     */
    public int deleteFileInfoGroup(FileVO fileVO) throws Exception {
    	return fileMapper.deleteFileInfoGroup(fileVO);
    }

    /**
     * upload single 파일정보 불러오기
     * @param fileVO
     * @return
     * @throws Exception
     */
    public FileVO selectFileDtl(FileVO fileVO) throws Exception {
        return fileMapper.selectFileDtl(fileVO);
    }

    /**
     * upload multi 파일목록 불러오기
     * 		- 필수파라미터 : fileGroupSn
     * @param fileVO
     * @return
     * @throws Exception
     */
    public List<FileVO> selectFileList(FileVO fileVO) throws Exception {
        return fileMapper.selectFileList(fileVO);
    }

    /**
     * upload single 파일정보저장 - 최종저장처리 - 인증사용자
     * @param authUser
     * @param uploadMap - fileGroupSn - 필수값, fileDtlSn - 필수값
     * @param realPath - 필수값, 업로드시 임시경로에서 최종 이동될 파일경로
     * @return
     * @throws Exception
     */
/* 중복 삭제 - 2024.11.20 김정구
    public boolean saveSingleFile1(AuthUser authUser, Map<String, Object> uploadMap, String realPath) throws Exception {

        // 월별 저장소
        String yyyyMM = DateUtil.getDate("yyyyMM");
        realPath = realPath + "/" + yyyyMM;

        int fileGroupSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileGroupSn")));
        int fileDtlSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileDtlSn")));

        FileVO fileVO = new FileVO();
        fileVO.setFileGroupSn(fileGroupSn);														//화면에서 넘어온 파일그룹 KEY
        fileVO.setFileDtlSn(fileDtlSn);															//화면에서 넘어온 파일상세 KEY
        fileVO.setMdfrId(authUser.getSessionVO().getUserId());

        if(fileVO.getFileDtlSn()!=0) {
            fileVO.setFileTypeSeCd("N");
            fileVO.setDelYn("Y");											//저장시에는 임시저장[DEL_YN = 'Y' 인것]된것만 처리
            FileVO vo = fileMapper.selectFileDtl(fileVO);

            if(vo != null) {
                Path oldPath = Paths.get(vo.getFilePath(), vo.getFileNmWithExt());
                Path newPath = Paths.get(realPath, vo.getFileNmWithExt());

                File file = new File(realPath);
                if(!file.exists()) {
                    file.mkdirs();
                }

                Files.move(oldPath, newPath);

                // 이동할 경로
                fileVO.setFilePath(realPath);

                int result = fileMapper.saveSingleFile(fileVO);
                if(result > 0) {
                    //이전 첨부파일 물리적 삭제처리 : N 싱글파일
                    deleteRealFile(fileGroupSn, "N", null);
                }
            }
        } else {
            // 빈값으로 넘어온 경우 이전파일 삭제처리
            //이전 첨부파일 물리적 삭제처리 : N 싱글파일
            int result = fileMapper.saveSingleFile(fileVO);
            if(result > 0) {
                deleteRealFile(fileGroupSn, "N", "Y");
            }
        }

        return true;
    }
*/    

    public void deleteRealFile(int fileGroupSn, String fileTypeSeCd, String delYn) throws Exception {
        FileVO selectVO = new FileVO();
        selectVO.setFileGroupSn(fileGroupSn);
        selectVO.setFileTypeSeCd(fileTypeSeCd);  // 단일파일
        selectVO.setDelYn( delYn!= null ?  delYn : "Y" );  			 // 삭제된건
        List<FileVO> fileList = fileMapper.selectFileList(selectVO);

        // 물리적 파일삭제
        for(int i=0;i < fileList.size(); i++) {
            String fileFullPath = fileList.get(i).getFileFullPath();

            File deleteFile = new File(fileFullPath);
            if(deleteFile.exists()) {
                deleteFile.delete();
            }
        }
    }


    /**
     * upload single 파일정보저장 - 최종저장처리 - 비인증사용자
     * @param userId
     * @param uploadMap - fileGroupSn - 필수값, fileDtlSn - 필수값
     * @param realPath - 필수값, 업로드시 임시경로에서 최종 이동될 파일경로
     * @return
     * @throws Exception
     */
    public boolean saveSingleFile(String userId, Map<String, Object> uploadMap, String realPath) throws Exception {
    	
        /* 월별 저장소 */
        String yyyyMM = DateUtil.getDate("yyyyMM");
        realPath = realPath + "/" + yyyyMM;

        int fileGroupSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileGroupSn")));
        int fileDtlSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileDtlSn")));

        if(fileDtlSn != 0) {
        	saveFile(userId, fileGroupSn, "N", fileDtlSn, realPath);
        }

        return true;
    }
    
    /**
     * upload single 파일정보저장(시설물아이콘) - 최종저장처리 - 비인증사용자
     * @param userId
     * @param uploadMap - fileGroupSn - 필수값, fileDtlSn - 필수값
     * @param realPath - 필수값, 업로드시 임시경로에서 최종 이동될 파일경로
     * @param saveNm - 필수값, 업로드시 임시경로에서 최종 이동 후 저장될 파일명
     * @return
     * @throws Exception
     */
    public boolean saveSingleFileFclty(String userId, Map<String, Object> uploadMap, String realPath, String saveNm) throws Exception {
    	
    	int fileGroupSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileGroupSn")));
    	int fileDtlSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileDtlSn")));
    	
    	if(fileDtlSn != 0) {
    		saveFileFclty(userId, fileGroupSn, "N", fileDtlSn, realPath, saveNm);
    	}
    	
    	return true;
    }
    

    /**
     * upload multi 파일정보저장 - 최종저장처리 - 비인증사용자
     * @param userId
     * @param uploadMap - fileGroupSn - 필수값, fileDtlSnArray - 필수값
     * @param realPath - 필수값, 업로드시 임시경로에서 최종 이동될 파일경로
     * @return
     * @throws Exception
     */
    public boolean saveMultiFile(String userId, Map<String, Object> uploadMap, String realPath) throws Exception {
    	
        /* 월별 저장소 */
        String yyyyMM = DateUtil.getDate("yyyyMM");
        realPath = realPath + "/" + yyyyMM;

        int fileGroupSn = NumberUtils.toInt(String.valueOf(uploadMap.get("fileGroupSn")));
        List<String> fileDtlSnArray = (List<String>) uploadMap.get("fileDtlSnArray");
        
        if(fileGroupSn > 0 && fileDtlSnArray != null) {

            for (int i = 0; i < fileDtlSnArray.size(); ++i) {

                int fileDtlSn = NumberUtils.toInt(fileDtlSnArray.get(i));
                
                if(fileDtlSn != 0) {
                	saveFile(userId, fileGroupSn, "Y", fileDtlSn, realPath);
                }
            };
        }

        return true;
    }


    /**
     * 파일정보저장 - 파일단위 최종저장처리
     * @param userId
     * @param fileGroupSn
     * @param fileTypeSeCd
     * @param fileDtlSn
     * @param realPath
     * @throws Exception
     */
    private void saveFile(String userId, int fileGroupSn, String fileTypeSeCd, int fileDtlSn, String realPath) throws Exception {

        FileVO fileVO = new FileVO();
        fileVO.setFileGroupSn(fileGroupSn);									//화면에서 넘어온 파일그룹 KEY
        fileVO.setFileDtlSn(fileDtlSn);										//화면에서 넘어온 파일상세 KEY
        fileVO.setMdfrId(userId);
        fileVO.setFileTypeSeCd(fileTypeSeCd);
        fileVO.setDelYn("Y");											//저장시에는 임시저장[DEL_YN = 'Y' 인것]된것만 처리
        
        FileVO vo = fileMapper.selectFileDtl(fileVO);

        if(vo != null) {
            Path oldPath = Paths.get(vo.getFilePath(), vo.getFileNmWithExt());
            Path newPath = Paths.get(realPath, vo.getFileNmWithExt());

            File file = new File(realPath);
            if(!file.exists()) {
                file.mkdirs();
            }

            Files.move(oldPath, newPath);

            /* 이동할 경로 */
            fileVO.setFilePath(realPath);

            fileMapper.saveSingleFile(fileVO);
        }
    }
    
    /**
     * 파일정보저장(시설물아이콘) - 파일단위 최종저장처리
     * @param userId
     * @param fileGroupSn
     * @param fileTypeSeCd
     * @param fileDtlSn
     * @param realPath
     * @param saveNm
     * @throws Exception
     */
    private void saveFileFclty(String userId, int fileGroupSn, String fileTypeSeCd, int fileDtlSn, String realPath, String saveNm) throws Exception {
    	
    	FileVO fileVO = new FileVO();
    	fileVO.setFileGroupSn(fileGroupSn);									//화면에서 넘어온 파일그룹 KEY
    	fileVO.setFileDtlSn(fileDtlSn);										//화면에서 넘어온 파일상세 KEY
    	fileVO.setMdfrId(userId);
    	fileVO.setFileTypeSeCd(fileTypeSeCd);
    	fileVO.setDelYn("Y");											//저장시에는 임시저장[DEL_YN = 'Y' 인것]된것만 처리
    	
    	FileVO vo = fileMapper.selectFileDtl(fileVO);
    	
    	if(vo != null) {
    		Path oldPath = Paths.get(vo.getFilePath(), vo.getFileNmWithExt());
            Path tempPath = Paths.get(realPath, vo.getFileNmWithExt());

    		File file = new File(realPath);
    		if(!file.exists()) {
    			file.mkdirs();
    		}

    		Files.move(oldPath, tempPath);

            String newFileName = saveNm + "." + vo.getFileExtnNm();
            Path newPath = Paths.get(realPath, newFileName);

            Files.move(tempPath, newPath);

    		/* 이동할 경로 */
    		fileVO.setFilePath(realPath);
    		fileVO.setFileNm(saveNm);

    		fileMapper.saveSingleFile(fileVO);
    	}
    }



    /**
     * 다운로드 VO 생성하기
     * @param fileVO
     * @return
     */
    public FileDownloadVO download(FileVO vo, HttpServletRequest request) throws Exception {

        FileVO fileVO = this.selectFileDtl(vo);

        FileDownloadVO fileDownloadVO = new FileDownloadVO();

        File file = new File(fileVO.getFileFullPath());			//저장된 파일명으로 File 객체 생성

        /* 파일시스템상에 물리파일정보가 있으면 - 다운로드 가능한 경우 */
        if(file.exists()) {
            logger.debug("Physical File Not Found!");
            /* 원본파일명 */
            String orgnlFileNm = fileVO.getOrgnlFileNmWithExt();

            /* 다운로드 파일명 */
            String downloadFileNm = URLEncoder.encode(orgnlFileNm, "UTF-8");

            Path path = file.toPath();
            String mimeType = Files.probeContentType(path);

            fileDownloadVO.setContentType(mimeType);
            fileDownloadVO.setFileFullPath(fileVO.getFileFullPath());
            fileDownloadVO.setOrgnlFileNm(orgnlFileNm);
            fileDownloadVO.setDownloadFileNm(downloadFileNm);
            fileDownloadVO.setFileLength(file.length());
            fileDownloadVO.setAvailable(true);
        }else {
            fileDownloadVO.setAvailable(false);
        }

        return fileDownloadVO;
    }

    /**
     * 다운로드수 UPDATE 처리
     * @param authUser
     * @param requestMap
     * @return
     * @throws Exception
     */
    public boolean updateDwldCount(FileVO vo) throws Exception {
        int updateCount = fileMapper.updateDwldCount(vo);
        return (updateCount == 1) ? true : false;
    }



}
