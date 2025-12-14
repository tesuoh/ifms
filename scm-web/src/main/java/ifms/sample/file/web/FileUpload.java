package ifms.sample.file.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import ifms.common.file.service.FileService;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;
import ifms.cmn.util.IfmsGlobalsUtil;

@Controller
@RequestMapping("/adm/sample")
public class FileUpload {
	
	public Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private FileService fileService;
	
	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
	@PostMapping("/UpDownloadSample.do")
	public String uploadFile(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception {
		Map<String, Object> detail = new HashMap<>();

        detail.put("popupSn", 129);
        detail.put("popupTtl", "테스트1");
        detail.put("popupBgngDt", "2025-09-26");
        detail.put("popupEndDt", "2025-09-26");
        detail.put("popupSzSeCd", "Basic");
        detail.put("frstRegDt", "2025-09-26");
        detail.put("fileGroupSn", 20479);
        detail.put("atchFileUrlAddr", "/Users/yangcheolseung/data/file/real/adm/202509");
        detail.put("orgnlFileNm", "233D5D3952CF365C21");
        detail.put("orgnlFileExtnNm", "jpeg");
        detail.put("atchFileSz", 149699);
        detail.put("fileDtlSn", 1);
        detail.put("srvrFileNm", "ffe5ea3231c2461f961a0a672f3e125b");
        detail.put("fileFullPath", "/Users/yangcheolseung/data/file/real/adm/202509/233D5D3952CF365C21.jpeg");
        detail.put("sysClsfCd", "ptl");
        
        model.addAttribute("detail", detail);
        
        return "adm/sample/UpDownloadSample2.do";
	}
	
	/**
	 * 파일 저장 (Single/Multi)
	 * @param authentication
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@PostMapping(value="/saveUpDownloadSample.json")
	public ResponseEntity<Map<String, Object>> saveUpDownloadSample(
			Authentication authentication,
			@RequestBody Map<String, Object> requestMap) throws Exception {
		
		Map<String, Object> response = new HashMap<>();
		
		try {
			// 사용자 ID 가져오기
			String userId = "SYSTEM";
			if (authentication != null && authentication.getPrincipal() instanceof AuthUser) {
				AuthUser authUser = (AuthUser) authentication.getPrincipal();
				SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
				userId = (sessionVO != null) ? sessionVO.getUserId() : "SYSTEM";
			}
			
			// 실제 파일 저장 경로 가져오기
			String realPath = ifmsGlobalsUtil.getProperties("REAL_PATH");
			
			// Single 파일 저장
			if (requestMap.containsKey("singleFileData")) {
				@SuppressWarnings("unchecked")
				Map<String, Object> singleFileData = (Map<String, Object>) requestMap.get("singleFileData");
				if (singleFileData != null) {
					fileService.saveSingleFile(userId, singleFileData, realPath);
				}
			}
			
			// Multi 파일 저장
			if (requestMap.containsKey("multiFileData")) {
				@SuppressWarnings("unchecked")
				Map<String, Object> multiFileData = (Map<String, Object>) requestMap.get("multiFileData");
				if (multiFileData != null) {
					fileService.saveMultiFile(userId, multiFileData, realPath);
				}
			}
			
			response.put("result", "success");
			return ResponseEntity.ok(response);
			
		} catch (Exception e) {
			logger.error("파일 저장 중 오류 발생", e);
			response.put("result", "error");
			response.put("message", "파일 저장 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
}
