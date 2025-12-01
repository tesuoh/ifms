package ifms.adm.cdm.fcm.web;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FilenameUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import ifms.adm.cdm.fcm.service.FcltyCdMngService;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Locale;
import org.apache.commons.io.FilenameUtils;


/**
 * 시설물 코드 관리 Controller
 * @author seongwook
 *
 */
@Controller
public class FcltyCdMngController {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private FcltyCdMngService fcltyCdMngService;

	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
	/**
	 * 목록 조회 이동
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/adm/cdm/fcm/fcltyCdMngList.do")
	public void fcmCdMngList(Authentication authentication) throws Exception{}
	
	/**
	 * 목록조회 json
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/adm/cdm/fcm/selectFcltyCdMngList.json")
	public void selectFcltyCdMngList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		log.debug("/selectFcltyCdMngList.json > requestMap: {}", requestMap);
		
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCount = fcltyCdMngService.selectFcltyCdMngTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
        if(requestMap.get("pageSize") != null) {
        	pagingVO.setListCount(Integer.parseInt(requestMap.get("pageSize").toString()));
        }
        
		log.debug("/selectFcltyCdMngList.json > pagingVO: {}", pagingVO);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		model.addAttribute("pagingVO", pagingVO);
		
		if(totalCount > 0) {
			List<Map<String, Object>> list = fcltyCdMngService.selectFcltyCdMngList(requestMap);
			model.addAttribute("list", list);
		}
		
	}
	
	/**
	 * 시설물코드 분류 목록조회 json
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/adm/cdm/fcm/selectFcltyCdClsfList.json")
	public void selectFcltyCdClsfList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		log.debug("/selectFcltyCdClsfList.json > requestMap: {}", requestMap);
		
		List<Map<String, Object>> list = fcltyCdMngService.selectFcltyCdClsfList(requestMap);
		model.addAttribute("list", list);
		
	}
	
	/**
	 * 등록 json
	 * @param requestMap
	 * @throws Exception
	 */
	@PostMapping("/adm/cdm/fcm/createFcltyCdMng.json")
	public ResponseEntity<?> createFcltyCdMng(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId );
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = fcltyCdMngService.insertFcltyCdMng(requestMap);
			
			if(result > 0) {
				responseMap.put("success", true);
				responseMap.put("message", "등록되었습니다.");
			}
			else if(result == -1){
				responseMap.put("success", false);
				responseMap.put("message", "이미 등록된 시스템코드가 존재합니다.");				
			}
			else if(result == -2){
				responseMap.put("success", false);
				responseMap.put("message", "유효하지 않은 코드분류입니다.");				
			}
			else {
				responseMap.put("success", false);
				responseMap.put("message", "실패 하였습니다.");				
			}
			
			return ResponseEntity.ok(responseMap);
		}
		catch(SQLException e) {
			throw new ResponseStatusException(
			        HttpStatus.INTERNAL_SERVER_ERROR, 
			        "서버 오류가 발생했습니다."
			    );
		}
		catch (NullPointerException e) {
			throw new ResponseStatusException(
					HttpStatus.INTERNAL_SERVER_ERROR, 
					"서버 오류가 발생했습니다."
					);
		}
	}
	
	/**
	 * 삭제
	 * @param authentication
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/adm/cdm/fcm/deleteFcltyCdMng.json")
	public ResponseEntity<?> deleteFcltyCdMng(Authentication authentication, @RequestBody Map<String, Object> requestMap) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = fcltyCdMngService.deleteFcltyCdMng(requestMap);
			
			if(result > 0) {
				responseMap.put("success", true);
				responseMap.put("message", "삭제되었습니다.");
			}
			else {
				responseMap.put("success", false);
				responseMap.put("message", "실패 하였습니다.");
			}
				
			return ResponseEntity.ok(responseMap);
		}
		catch(SQLException e) {
			throw new ResponseStatusException(
			        HttpStatus.INTERNAL_SERVER_ERROR, 
			        "서버 오류가 발생했습니다."
			    );
		}
		catch (NullPointerException e) {
			throw new ResponseStatusException(
					HttpStatus.INTERNAL_SERVER_ERROR, 
					"서버 오류가 발생했습니다."
					);
		}
	}
	
    // 시설물 이미지 불러오기 - 수정중
    @GetMapping(value="/adm/cdm/fcm/getImg.json")
    public void getImg(@RequestParam(value="fileNM") String fileNM, HttpServletResponse response) throws Exception{

    	String imgPath = ifmsGlobalsUtil.getProperties("FCLTY_IMG_PATH");
    	String filePath = imgPath + "/" +fileNM;

    	File file = new File(filePath);

    	// 시설물 이미지가 없을 경우 임시 이미지로 표출
    	if(!file.isFile()){
    		String defaultImg = imgPath + "/" +ifmsGlobalsUtil.getProperties("FCLTY_DEFAULT_IMG_FILE");
    		file = new File(defaultImg);
    	}
    	
    	try (FileInputStream fis = new FileInputStream(file);
	         BufferedInputStream in = new BufferedInputStream(fis);
	         ByteArrayOutputStream bStream = new ByteArrayOutputStream()){
    		
			int imgByte;
			while ((imgByte = in.read()) != -1) {
				bStream.write(imgByte);
			}

			Locale.setDefault(Locale.ENGLISH);

			String type = "";
			String ext = FilenameUtils.getExtension(file.getName());
			if (ext != null && !"".equals(ext)) {
				String lowerExt = ext.toLowerCase(Locale.ROOT);
				if ("jpg".equals(lowerExt)) {
					type = "image/jpeg";
				} else if ("svg".equals(lowerExt)) {
			        type = "image/svg+xml";
			    }else {
					type = "image/" + lowerExt;
				}
			} else {
				log.debug("Image fileType is null.");
			}

			if (type != null) {
				type = type.replace("\n", "").replace("\r", "");
			}

			response.setHeader("Content-Type", type);
			response.setContentLength(bStream.size());
			
			bStream.writeTo(response.getOutputStream());
			
			response.getOutputStream().flush();
			response.getOutputStream().close();

		} catch (FileNotFoundException e) {
			log.error("File not found: {}", e);
	        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
	    } catch (IOException e) {
	    	log.error("IO error while processing image file: {}", e);
	        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	    }
    }
}
