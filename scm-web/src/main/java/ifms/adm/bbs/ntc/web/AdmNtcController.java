package ifms.adm.bbs.ntc.web;

import egovframework.context.EgovWebServletContextListener;
import egovframework.util.EgovMessageSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.bbs.ntc.service.AdmNtcService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 경찰청 보호구역통합관리시스템 구축사업 (2024) 
 * 공지사항 Controller
 */


@Controller
@RequestMapping(value="/adm/bbs/ntc")
public class AdmNtcController {

	private static final Logger LOGGER = LoggerFactory.getLogger(EgovWebServletContextListener.class);
	
	@Autowired
	private AdmNtcService adminNtcService;
		
	EgovMessageSource egovMessageSource;
	
	@GetMapping("/admNtcList.do")
	public void admNtcListGet(ModelMap model) throws Exception{
		String savedParams = "{}";
		model.addAttribute("savedParams", savedParams);
	}

	/**
	 * 공지사항 목록 조회 (관리자)
	 * @param adminNtcVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@PostMapping(value = "/admNtcList.do")
	public void adminNtcList(Authentication authentication,
							 HttpServletRequest request,
							 @RequestParam Map<String, Object> requestMap,
							 ModelMap model) throws Exception {
		
		requestMap.remove("_csrf");

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}

	@PostMapping(value = "/selectAdminNtcList.json")
	public void selectAdminNtcList(Authentication authentication, @RequestBody Map<String, Object> requestMap,
												  HttpServletRequest request, ModelMap model) throws Exception{

		/* 세션정보 설정 */
		// Authentication 객체에서 AuthUser 가져오기
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		requestMap.put("userId", userId);
		Map<String, Object> response = new HashMap<>();

		/* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
		PagingVO pagingVO = new PagingVO(requestMap);

		// 세령 작성 필요
		int totalCount = adminNtcService.selectAdminNtcListCnt(requestMap);
		LOGGER.debug("========== totalCount : " + totalCount);

		/* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
		pagingVO.setTotalCount(totalCount);

		/* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
		requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정

		/* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
		model.addAttribute("pagingVO", pagingVO);

		/* ■■■■ PageNavigation 영역처리 - 5. 총건수에 대한 선택적 조회 ■■■■ */
		if (totalCount > 0) {
			List<Map<String, Object>> list = adminNtcService.selectAdminNtcList(requestMap);
			model.addAttribute("list", list);					//메뉴목록
		}
	}

	
	/**
	 * 공지사항 상세 조회 (관리자)
	 * @param PortalNtcVO
	 * @return "selectAdminNtcDetail page"
	 */ 
	@PostMapping(value="/admNtcDetail.do")
	public void selectAdminNtcDetail(Authentication authentication,
			 HttpServletRequest request,
			 @RequestParam	Map<String, Object> requestMap,
			 ModelMap model) throws Exception {	
		
		adminNtcService.addNtcInqCnt(requestMap); //조회수
		
		Map<String, Object> detail = adminNtcService.selectAdminNtc(requestMap);
		model.addAttribute("detail", detail);
		
		requestMap.remove("_csrf");

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
	}
	
	
	
	/**
	 * 공지사항 등록 페이지 (관리자)
	 * @return "adminNtcCreate page"
	 */
	@PostMapping(value="/admNtcCreate.do")
	public void createNtcPage(@RequestParam Map<String, String> requestMap, ModelMap model) throws Exception {
		String sysClsfCd = requestMap.get("sysClsfCd").toString();
		model.addAttribute("sysClsfCd", sysClsfCd);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}

	/**
	 * 공지사항 등록 (관리자)
	 * @param AdminNtcVO
	 * @return "insertAdminNtc page"
	 */
	@PostMapping(value="/insertNtc.json")
	public ResponseEntity<Map<String, Object>> insertAdminNtc(Authentication authentication, HttpServletRequest request,
															  ModelMap model, @RequestBody Map<String, Object> requestMap) throws Exception {

		Map<String, Object> response = new HashMap<>();
		try {
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			requestMap.put("frstRgtrId", userId);

			// 서비스 호출
			adminNtcService.insertNtc(requestMap);

			// 성공 시 응답에 result 추가
			response.put("result", "success");

		} catch (SQLException e) {
			response.put("result", "error");
			response.put("message", "서버 오류가 발생했습니다.");
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
		return ResponseEntity.ok(response);
	}

	
	/**
	 * 공지사항 수정 페이지 (관리자)
	 * @param AdminNtcVO
	 * @return "AdminNtcUpdate page"
	 */ 
	@PostMapping(value="/admNtcUpdate.do")
	public void updateNtcPage(Authentication authentication,
			 HttpServletRequest request,
			 @RequestParam	Map<String, Object> requestMap,
			 ModelMap model) throws Exception {
		
		Map<String, Object> detail = adminNtcService.selectAdminNtc(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	@PostMapping(value="/updateNtc.json")
	public void updateNtc(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception {
				
		try {
			/* 세션정보 설정 */
			// Authentication 객체에서 AuthUser 가져오기
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			SessionVO sessionVO = null;
			String lastMdfrId = null;
			
			if (authUser != null) {
				sessionVO = authUser.getSessionVO();
				lastMdfrId = sessionVO != null ? sessionVO.getUserId() : null;
			}

			requestMap.put("lastMdfrId", lastMdfrId);

			int result = adminNtcService.updateNtc(requestMap);
			if(result == 1) {
				model.addAttribute("success", true);
				model.addAttribute("message", "수정되었습니다.");
			}
			else {
				model.addAttribute("success", false);				
			}
		}
		catch (SQLException e){
			LOGGER.debug("================= error exception : " + e);
		}
	}
	
	/**
	 * 공지사항 삭제
	 * @param authentication
	 * @param requestMap
	 * @param request
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@PostMapping(value="/deleteNtc.json")
	public void deleteNtc(Authentication authentication, @RequestBody Map<String, Object> requestMap,
			  HttpServletRequest request, ModelMap model) throws Exception{
		
		/* 세션정보 설정 */
		// Authentication 객체에서 AuthUser 가져오기
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		requestMap.put("lastMdfrId", userId);
		
		int result = adminNtcService.deleteNtc(requestMap);
		
		if(result == 1) {
			model.addAttribute("result", "success");
		}
	}

}
