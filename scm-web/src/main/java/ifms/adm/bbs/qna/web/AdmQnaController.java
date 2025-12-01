package ifms.adm.bbs.qna.web;

import java.sql.SQLException;
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

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.bbs.qna.service.AdmQnaService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;

/**
 * Qna 관리 Controller
 * @author seryeong
 *
 */

@Controller
@RequestMapping("/adm/bbs/qna")
public class AdmQnaController {

	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private AdmQnaService admQnaService;
	
	@PostMapping("/admQnaList.do")
	public void admQnsList(@RequestParam Map<String, Object> searchMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(searchMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 질의 목록 조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectAdmQnaList.json")
	public void selectAdmQnaList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		//페이징
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCount = admQnaService.selectQnaListTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정
		
		model.addAttribute("pagingVO", pagingVO);
		
		//목록 데이터 조회
		if(totalCount > 0) {
			List<Map<String, Object>> qnaList = admQnaService.selectAdmQnaList(requestMap);
			model.addAttribute("list", qnaList);
		}
	}
	
	/**
	 * 질의 상세 
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admQnaDetail.do")
	public void admQnaDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = admQnaService.selectQnaDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 답변 등록
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/qnaAnsCnInsert.json")
	public void qnaAnsCnInsert(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		try {
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			String userId = authUser.getSessionVO().getUserId();
			
			log.debug("================ userId : {}", userId);
			requestMap.put("lastMdfrId", userId);
			
			Map<String, Object> result = admQnaService.qnaAnsCnInsert(requestMap);
			
			if(result.size() > 0) {
				model.addAttribute("success", true);
				model.addAttribute("ansData", result);							
			}
			else {
				model.addAttribute("success", false);
			}
		}
		catch (SQLException e) {
			log.debug("QNA 답변 등록 처리중 에러 발생 - ", requestMap);
		}
		
	}
	
	/**
	 * 질의 글 삭제처리
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deleteQstn.json")
	public void qnaQstnDelete(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		try {
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			String userId = authUser.getSessionVO().getUserId();
			
			log.debug("================ userId : {}", userId);
			requestMap.put("lastMdfrId", userId);
			
			int result = admQnaService.deleteQstn(requestMap);
			
			if(result > 0) {
				model.addAttribute("success", true);
			}
			
		}
		catch(SQLException e) {
			e.printStackTrace();
			log.debug("QNA 질의 삭제 중 에러 발생 - ", e.getMessage());
		}
	}
}
