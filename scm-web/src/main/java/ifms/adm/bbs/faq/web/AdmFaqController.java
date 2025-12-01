package ifms.adm.bbs.faq.web;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.context.EgovWebServletContextListener;
import ifms.adm.bbs.faq.service.AdmFaqService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

/**
 * FAQ 관리 Controller
 * @author seryeong
 *
 */

@Controller
@RequestMapping("/adm/bbs/faq")
public class AdmFaqController {

	private static final Logger log = LoggerFactory.getLogger(EgovWebServletContextListener.class);
	
	@Autowired
	private AdmFaqService admFaqService;
	
	/**
	 * FAQ 관리 목록 페이지 이동
	 * @throws Exception
	 */
	@PostMapping("/admFaqList.do")
	public void selectAdmFaqList(Authentication authentication, @RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		//카테고리 조회
		List<Map<String, Object>> faqCategory = admFaqService.selectFaqCategory();
		model.addAttribute("faqCategory", faqCategory);
	}
	
	/**
	 * FAQ 관리 목록 조회
	 * @param model
	 * @param requestMap
	 * @throws Exception
	 */
	@PostMapping("/selectFaqList.json")
	public void selectAdmFaqListJson(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		log.debug("=================== selectFaqList.json :: requestMap > " + requestMap);
		
		/* 세션정보 설정 */
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = null;
		if (authUser != null) {
			sessionVO = authUser.getSessionVO();
		}
		
		/* PageNavigation */
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCnt = admFaqService.selectFaqListTotalCnt(requestMap);
		pagingVO.setTotalCount(totalCnt);

		requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정
		
		model.addAttribute("pagingVO", pagingVO);
		
		//목록 데이터 조회
		if(totalCnt > 0) {
			List<Map<String, Object>> faqList = admFaqService.selectFaqList(requestMap);
			model.addAttribute("list", faqList);
		}
	}
	
	
	/**
	 * FAQ 등록 페이지 이동
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admFaqCreate.do")
	public void goFaqCreate(Authentication authentication, @RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		
		List<Map<String, Object>> faqCategory = admFaqService.selectFaqCategory();
		model.addAttribute("faqCategory", faqCategory);
	}
	
	/**
	 * FAQ 등록
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/createFaq.json")
	public void createFaq(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		/* 세션정보 설정 */
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		requestMap.put("frstRgtrId", userId);
		
		int result = admFaqService.insertFaq(requestMap);
		
		if(result == 1) {
			model.addAttribute("result", "success");
		}
		else {
			model.addAttribute("result", "fail");			
		}
		
	}
	
	/**
	 * FAQ 삭제
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deleteFaq.json")
	public void deleteFaq(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		int result = admFaqService.deleteFaq(requestMap);
		if(result == 1) {
			model.addAttribute("result", "success");
		}
	}
	
	/**
	 * FAQ 수정 페이지 이동
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admFaqUpdate.do")
	public void goFaqUpdate(Authentication authentication, @RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		List<Map<String, Object>> faqCategory = admFaqService.selectFaqCategory();
		model.addAttribute("faqCategory", faqCategory);
		model.addAttribute("detail", admFaqService.selectFaqDetail(requestMap));
	}
	
	/**
	 * FAQ 수정
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/updateFaq.json")
	public void updateFaq(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		/* 세션정보 설정 */
		// Authentication 객체에서 AuthUser 가져오기
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		requestMap.put("lastMdfcnDt", userId);
		
		int result = admFaqService.updateFaq(requestMap);
		if(result == 1) {
			model.addAttribute("result", "success");
		}
	}
	
}
