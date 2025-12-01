package ifms.adm.sos.sds.web;

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

import ifms.adm.sos.sds.service.SysDsbltvService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

/**
 * 시스템 장애 관리
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/sos/sds")
public class SysDsbltvSrController {

	@Autowired
	SysDsbltvService sysDsbltvService;
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	/**
	 * 시스템 장애 신고 관리 목록 이동
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/sysDsbltvSrList.do")
	public void sysDsbltvList(@RequestParam Map<String, Object> requestMap,  ModelMap model) throws Exception{
		requestMap.remove("_csrf");

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	};
	
	/**
	 * 시스템 장애 신고 관리 목록 조회
	 * @param requestMap
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectSysDsbltvSrList.json")
	public void selectSysDsbltvList(@RequestBody Map<String, Object> requestMap, 
			Authentication authentication, ModelMap model) throws Exception{
		
		PagingVO pagingVO = new PagingVO(requestMap);

		int totalCount = sysDsbltvService.sysDsbltvSrTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		model.addAttribute("pagingVO", pagingVO);
		
		if(totalCount > 0) {
			List<Map<String, Object>> list = sysDsbltvService.sysDsbltvSrList(requestMap);
			model.addAttribute("list", list);
		}
	};
	
	/**
	 * 시스템 장애 신고 관리 상세조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/sysDsbltvSrDetail.do")
	public void sysDsbltvDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		requestMap.remove("_csrf");

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
		Map<String, Object> detail = sysDsbltvService.sysDsbltvSrDetail(requestMap);
		model.addAttribute("detail", detail);
	};
	
	/**
	 * 코멘트 작성
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/insertPrcsCn.json")
	public void insertPrcsCn(@RequestBody  Map<String, Object> requestMap, ModelMap model, Authentication authentication) throws Exception{
		AuthUser authUser = (AuthUser)authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		
		requestMap.put("lastMdfrId", userId);
		
		Map<String, Object> comment = sysDsbltvService.insertPrcsCn(requestMap);
		model.addAttribute("comment", comment);
		
	}
	
	/**
	 * 시스템 장애 신고 게시글 삭제
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deletePst.json")
	public void deleteSysDsbltvPst(@RequestBody Map<String, Object> requestMap, ModelMap model, Authentication authentication) throws Exception{
		AuthUser authUser = (AuthUser)authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		
		requestMap.put("userId", userId);
		
		int result = sysDsbltvService.deleteSysDsbltvPst(requestMap);
		if(result > 0) {
			model.addAttribute("success", true);
		}
		else {
			model.addAttribute("success", false);			
		}
		
	}
}
