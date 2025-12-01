package ifms.adm.bbs.pop.web;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.databind.ObjectMapper;

import egovframework.util.EgovMessageSource;
import ifms.adm.bbs.pop.service.AdmNtcPopService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;
/**
 * 공지 팝업 관리 Controller
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/bbs/pop")
public class AdmNtcPopController {

	@Autowired
	AdmNtcPopService admNtcPopService;
	
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	//세션 가져오기
	public SessionVO getSessionVO(Authentication authentication) throws Exception{
		if (authentication == null || authentication.getPrincipal() == null) {
	        return null;
	    }
		
		//세션 ID
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = null;
		
		if(authUser != null) {
			sessionVO = authUser.getSessionVO();
		}
		return sessionVO;
	}
	
	//목록 페이지 이동
	/*
	 * @GetMapping("/admNtcPopList.do") public void getAdmNtcPopList(ModelMap model)
	 * throws Exception{ model.addAttribute("savedParams", "{}"); }
	 */
		
	//목록 페이지 이동
	@PostMapping("/admNtcPopList.do")
	public void admNtcPopList(@RequestParam Map<String, Object> searchMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(searchMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 팝업관리 목록 조회
	 * @param requestMap
	 * @param model
	 * @param authentication
	 * @throws Exception
	 */
	@PostMapping("/selectNtcPopList.json")
	public void selectNtcPopList(@RequestBody Map<String, Object> requestMap, ModelMap model
			, Authentication authentication) throws Exception{
		
		//페이징
		PagingVO pagingVO = new PagingVO(requestMap);

		int totalCount = admNtcPopService.selectPopListTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		log.debug("========================== admNtcPopList.json" + pagingVO.toString());
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		model.addAttribute("pagingVO", pagingVO);
		
		//목록
		if(totalCount > 0) {
			List<Map<String, Object>> list = admNtcPopService.selectPopList(requestMap);
			model.addAttribute("list", list);
		}
		
	}
	
	/**
	 * 등록 페이지 이동
	 * @param response
	 * @param authentication
	 * @throws Exception
	 */
	@PostMapping("/admNtcPopCreate.do")
	public void admNtcPopCreate(@RequestParam Map<String, String> requestMap, ModelMap model) throws Exception{
		String sysClsfCd = requestMap.get("sysClsfCd").toString();
		model.addAttribute("sysClsfCd", sysClsfCd);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
	}
	
	/**
	 * 등록
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/createPop.json")
	public ResponseEntity<?> createPop(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		try {
			SessionVO sessionVO = this.getSessionVO(authentication);
			String userId = sessionVO.getUserId();
			
			requestMap.put("frstRgtrId", userId);
			
	
			Map<String, Object> responseMap = new HashMap<>();
		
			int res = admNtcPopService.insertPop(requestMap);
			
			if(res == 1) {
				responseMap.put("success", true);
				responseMap.put("message", "등록되었습니다.");
			}
				
			return ResponseEntity.ok(responseMap);
		}
		catch (SQLException e){
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
	 * 상세
	 * @param popupSn
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admNtcPopDetail.do")
	public void admNtcPopDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		String popupSn = requestMap.get("popupSn").toString();

		Map<String, Object> detail = admNtcPopService.selectPopDetail(popupSn);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 수정 화면 이동
	 * @param popupSn
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admNtcPopUpdate.do")
	public void admNtcPopUpdate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		String popupSn = requestMap.get("popupSn").toString();
		
		Map<String, Object> detail = admNtcPopService.selectPopDetail(popupSn);
		model.addAttribute("detail", detail);

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 수정 로직
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/updatePop.json")
	public ResponseEntity<?> updatePop(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		try {
			SessionVO sessionVO = this.getSessionVO(authentication);
			String userId = sessionVO.getUserId();
			
			Map<String, Object> responseMap = new HashMap<>();
		
			int res = admNtcPopService.updatePop(requestMap, userId);
			
			if(res == 1) {
				responseMap.put("success", true);
				responseMap.put("message", "수정되었습니다.");
			}
			else {
				responseMap.put("success", false);
				responseMap.put("message", "수정 실패되었습니다.");				
			}
				
			return ResponseEntity.ok(responseMap);
		}
		catch (SQLException e){
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
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deletePop.json")
	public ResponseEntity<?> deletePop(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		try {
			SessionVO sessionVO = this.getSessionVO(authentication);
			String userId = sessionVO.getUserId();
			
			Map<String, Object> responseMap = new HashMap<>();
		
			int res = admNtcPopService.deletePop(requestMap, userId);
			
			if(res == 1) {
				responseMap.put("success", true);
				responseMap.put("message", "삭제되었습니다.");
			}
				
			return ResponseEntity.ok(responseMap);
		}
		catch (SQLException e){
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
