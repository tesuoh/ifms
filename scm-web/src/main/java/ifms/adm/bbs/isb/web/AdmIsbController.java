package ifms.adm.bbs.isb.web;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.bbs.isb.service.AdmIsbService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

/**
 * 정보공유게시판 관리
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/bbs/isb")
public class AdmIsbController {

	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	AdmIsbService admIsbService;
	
	/*
	 * @GetMapping("/admIsbList.do") public void tempAdmIsbList(ModelMap model)
	 * throws Exception { model.addAttribute("savedParams", "{}"); }
	 */
	
	
	/**
	 * 정보공유게시판 관리 목록 이동
	 * @throws Exception
	 */
	@PostMapping("/admIsbList.do")
	public void admIsbList(@RequestParam Map<String, Object> searchMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(searchMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 정보공유 게시판 목록 조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectBizIsbList.json")
	public void selectBizIsBbsList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		try {
			//페이징
			PagingVO pagingVO = new PagingVO(requestMap);
			
			int totalCount = admIsbService.selectIsbTotalCount(requestMap);
			pagingVO.setTotalCount(totalCount);
			
			requestMap.put("startNo", pagingVO.getStartNo());
			requestMap.put("endNo", pagingVO.getEndNo());
			requestMap.put("listCount", pagingVO.getListCount());
			
			model.addAttribute("pagingVO", pagingVO);
			
			//게시글 
			if(totalCount > 0) {
				List<Map<String, Object>> isbList = admIsbService.selectAdmIsbList(requestMap);
				model.addAttribute("list", isbList);
			}
		}
		catch(NullPointerException e) {
			log.debug("========== null exception, {}", e.getMessage());
			
		}
	}
	
	/**
	 * 게시글 상세
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admIsbDetail.do")
	public void bizIsbDetail(Authentication authentication, @RequestParam Map<String, Object> requestMap
			, ModelMap model) throws Exception{
		
		//게시글 상세
		Map<String, Object> detail = admIsbService.selectIsbPstDetail(requestMap); 
		model.addAttribute("detail", detail);

		//비디오 정보
		Map<String, Object> videoInfo = admIsbService.selectVideoFile(requestMap);
		model.addAttribute("videoInfo", videoInfo);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
			
	}
	
	/**
	 * 댓글 목록 가져오기
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectIsbCmntList.json")
	public void selectIsbCmntList(Authentication authentication, @RequestBody Map<String, Object> requestMap
			, ModelMap model) throws Exception{
		
		//세션 ID
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		requestMap.put("userId", userId);
		
		//페이징
		PagingVO pagingVO = new PagingVO(requestMap);
		int totalCount = admIsbService.selectCmntTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		log.debug("=============== requestMap : {}", requestMap);
		model.addAttribute("pagingVO", pagingVO);
		
		//댓글 목록
		if(totalCount > 0) {
			List<Map<String, Object>> cmntList = admIsbService.selectIsbCmntList(requestMap);
			log.debug("=============== cmntList : {}", cmntList);
			
			model.addAttribute("list", cmntList);
		}
			
			
	}
	
	/**
	 * 댓글 삭제
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deleteCmnt.json")
	public void deleteCmnt(Authentication authentication, @RequestBody Map<String, Object> requestMap
			, ModelMap model) throws Exception{
		
		try {
			//세션 ID
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;

			Map<String, Object> userMap = (sessionVO != null) ? sessionVO.getUserMap() : new HashMap<>();

			String userId = (userMap != null && userMap.containsKey("userId")) ? (String) userMap.get("userId") : "";
			String authrtId = (userMap != null && userMap.containsKey("authrtId")) ? (String) userMap.get("authrtId") : "";
			
			if(authrtId.equals("ROL_BIZ_0404")) {
				requestMap.put("userId", userId);
				
				int result = admIsbService.deleteCmnt(requestMap);
				model.addAttribute("result", result);
			}
			else {
				model.addAttribute("result", "noAuth");
			}
			
			//페이징
			PagingVO pagingVO = new PagingVO(requestMap);
			int totalCount = admIsbService.selectCmntTotalCount(requestMap);
			pagingVO.setTotalCount(totalCount);
			
			requestMap.put("startNo", pagingVO.getStartNo());
			requestMap.put("endNo", pagingVO.getEndNo());
			requestMap.put("listCount", pagingVO.getListCount());
			
			model.addAttribute("pagingVO", pagingVO);
			
		}
		catch (NullPointerException e) {
			log.debug("======= NullPointerException: {}", e.getMessage());
			model.addAttribute("error", "로그인 후 이용하세요.");
		}
	}
	
	
	/**
	 * 게시글 삭제
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deletePst.json")
	public void deletePst(Authentication authentication, @RequestBody Map<String, Object> requestMap
			, ModelMap model) throws Exception{
		
		try {
			if (authentication == null || authentication.getPrincipal() == null) {
				throw new IllegalStateException("인증 정보가 없습니다. 로그인 후 이용하세요.");
			}
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			SessionVO sessionVO = null;
			if(authUser != null) {
				sessionVO = authUser.getSessionVO();
			}

			if (sessionVO == null) {
				throw new IllegalStateException("세션 정보가 없습니다. 로그인 후 이용하세요.");
			}
			
			Map<String, Object> userMap = sessionVO.getUserMap();
			if (userMap == null) {
				throw new IllegalStateException("사용자 정보가 없습니다. 로그인 후 이용하세요.");
			}
			
			String userId = (String) userMap.get("userId");
			if (userId == null || userId.isEmpty()) {
				throw new IllegalStateException("사용자 ID를 확인할 수 없습니다.");
			}
			requestMap.put("userId", userId);
			
			String authrtId = (String) userMap.get("authrtId");
			if(authrtId.equals("ROL_BIZ_0404")) {
				int result = admIsbService.deletePst(requestMap);
				model.addAttribute("result", result);
			}
			else {
				model.addAttribute("result", "noAuth");
			}
			
		}
		catch (NullPointerException e) {
			model.addAttribute("error", "로그인 후 이용하세요.");
		}
		 
	}
}
