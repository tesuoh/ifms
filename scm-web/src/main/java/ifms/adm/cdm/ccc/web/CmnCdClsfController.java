package ifms.adm.cdm.ccc.web;

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

import ifms.adm.cdm.ccc.service.CmnCdClsfService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;
/**
 * 공통코드 분류 관리 Controller
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/cdm/ccc")
public class CmnCdClsfController {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private CmnCdClsfService cmnCdClsfService;

	/**
	 * 목록 조회 이동
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnCdClsfList.do")
	public void cmnCdClsfList(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 목록조회 json
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectCmnCdClsfList.json")
	public void selectCmnCdClsfList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		PagingVO pagingVO = new PagingVO(requestMap);
		
		//공통코드 분류 검색 팝업 시 사이즈 5
		int listCount = Integer.parseInt(requestMap.get("listCount").toString());
		if(listCount == 5) {
			pagingVO.setListCount(5);
			pagingVO.setPageSize(5);
			
			requestMap.put("pageSize", 5);
		}
		else {
		}
		requestMap.put("listCount", pagingVO.getListCount());
		
		
		int totalCount = cmnCdClsfService.selectCmnCdClsfTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		
		model.addAttribute("pagingVO", pagingVO);
		
		if(totalCount > 0) {
			List<Map<String, Object>> list = cmnCdClsfService.selectCmnCdClsfList(requestMap);
			model.addAttribute("list", list);
		}
		
	}
	
	/**
	 * 상세 페이지
	 * @throws Exception
	 */
	@PostMapping("/cmnCdClsfDetail.do")
	public void cmnCdClsfDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = cmnCdClsfService.selectCmnCdClsfDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 등록 페이지
	 * @throws Exception
	 */
	@PostMapping("/cmnCdClsfCreate.do")
	public void cmnCdClsfCreate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 등록 json
	 * @param requestMap
	 * @throws Exception
	 */
	@PostMapping("/createCmnCdClsf.json")
	public ResponseEntity<?> createcmnCdClsf(Authentication authentication, @RequestBody Map<String, Object> requestMap) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnCdClsfService.insertCmnCdClsf(requestMap);
			
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
	 * 수정 화면 이동
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnCdClsfUpdate.do")
	public void comCodeupdate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = cmnCdClsfService.selectCmnCdClsfDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	

	/**
	 * 수정 json
	 * @param requestMap
	 * @throws Exception
	 */
	@PostMapping("/updateCmnCdClsf.json")
	public ResponseEntity<?> updatecmnCdClsf(Authentication authentication, @RequestBody Map<String, Object> requestMap) throws Exception{
		log.debug("=========== ccm update.json > requestMap : {}", requestMap);
		
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnCdClsfService.updateCmnCdClsf(requestMap);
			
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
	 * @param authentication
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/deleteCmnCdClsf.json")
	public ResponseEntity<?> deleteCmnCdClsf(Authentication authentication, @RequestBody Map<String, Object> requestMap) throws Exception{
		log.debug("=========== ccm update.json > requestMap : {}", requestMap);
		
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("userId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnCdClsfService.deleteCmnCdClsf(requestMap);
			
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
