package ifms.adm.cdm.ccm.web;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.cdm.ccm.service.CmnCdMngService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;
/**
 * 공통코드 관리 Controller
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/cdm/ccm")
public class CmnCdMngController {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private CmnCdMngService cmnCdMngService;

	/**
	 * 목록 조회 이동
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnCdMngList.do")
	public void cmnCdMngList(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 목록조회 json
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectCmnCdMngList.json")
	public void selectCmnCdMngList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		log.debug("============ /selectCmnCdMngList.json > requestMap: {}", requestMap);
		
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCount = cmnCdMngService.selectCmnCdMngTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		model.addAttribute("pagingVO", pagingVO);
		
		if(totalCount > 0) {
			List<Map<String, Object>> list = cmnCdMngService.selectCmnCdMngList(requestMap);
			model.addAttribute("list", list);
		}
		
	}
	
	/**
	 * 등록 화면 이동
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	
	@PostMapping("/cmnCdMngCreate.do")
	public void cmnCdMngCreate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 마지막 정렬 순서 조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectLastSortSeq.json")
	public void selectLastSortSeq(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		int lastSortSeq = cmnCdMngService.selectLastSortSeq(requestMap);
		model.addAttribute("lastSortSeq", lastSortSeq);
	}
	
	/**
	 * 아이디 중복 확인
	 * @param requestMap
	 * @param authentication
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/duplicateId.json")
	public ResponseEntity<?> duplicateId(@RequestBody Map<String, Object> requestMap, Authentication authentication) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			boolean result = cmnCdMngService.duplicateId(requestMap);
			responseMap.put("success", result);
				
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
	 * 등록 json
	 * @param requestMap
	 * @param authentication
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/createCmnCdMng.json")
	public ResponseEntity<?> createCmnCdMng(@RequestBody Map<String, Object> requestMap, Authentication authentication) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnCdMngService.insertCmnCdMng(requestMap);
			
			if(result == 1) {
				responseMap.put("success", true);
				responseMap.put("message", "등록되었습니다.");
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
	 * 공통코드 관리 상세
	 * @param requestMap
	 * @throws Exception
	 */
	@PostMapping("/cmnCdMngDetail.do")
	public void cmnCdMngDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = cmnCdMngService.selectCmnCdMngDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 수정 화면 
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnCdMngUpdate.do")
	public void cmnCdMngUpdate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = cmnCdMngService.selectCmnCdMngDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 수정 json
	 * @param requestMap
	 * @param authentication
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/updateCmnCdMng.json")
	public ResponseEntity<?> updateCmnCdMng(@RequestBody Map<String, Object> requestMap, Authentication authentication) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnCdMngService.updateCmnCdMng(requestMap);
			
			if(result == 1) {
				responseMap.put("success", true);
				responseMap.put("message", "수정되었습니다.");
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
	 * @param requestMap
	 * @param authentication
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/deleteCmnCdMng.json")
	public ResponseEntity<?> deleteCmnCdMng(@RequestBody Map<String, Object> requestMap, Authentication authentication) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";

			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnCdMngService.deleteCmnCdMng(requestMap);
			
			if(result == 1) {
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
	
}
