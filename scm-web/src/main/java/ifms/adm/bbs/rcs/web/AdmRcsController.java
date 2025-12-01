package ifms.adm.bbs.rcs.web;

import java.util.List;
import java.util.Map;

import javax.persistence.PersistenceException;
import javax.servlet.http.HttpServletRequest;

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

import ifms.adm.bbs.rcs.service.AdmRcsService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

/**
 * 자료실 관리
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/bbs/rcs")
public class AdmRcsController {

	private final Logger log = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private AdmRcsService admRcsService;
	
	/**
	 * 자료실 목록 페이지 이동
	 */
	@PostMapping("/admRcsList.do")
	public void admRcsList(Authentication authentication,
			 HttpServletRequest request,
			 @RequestParam Map<String, Object> requestMap,
			 ModelMap model) throws Exception{
		
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		SessionVO sessionVO = null;
		
		log.debug("=========== authUser : {}", authUser);
		if(authUser != null) {
			sessionVO = authUser.getSessionVO();
		}
		//requestMap.remove("_csrf");

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 자료실 목록 조회
	 * @param requestMap
	 * @param model
	 */
	@PostMapping("/selectAdmRcsList.json")
	public void selectAdmRcsListJson(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		//페이징
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCount = admRcsService.selectRcsTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		
		requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정
		
        log.debug("===== adm rcs list pagingVO : {}", pagingVO);
        model.addAttribute("pagingVO", pagingVO);

        //목록 데이터 조회
        if(totalCount > 0) {
			List<Map<String, Object>> list = admRcsService.selectAdmRcsList(requestMap);
			model.addAttribute("result", list);
		}
		
	}
	
	/**
	 * 자료실 등록 페이지 이동
	 * @throws Exception
	 */
	@PostMapping("/admRcsCreate.do")
	public void admRcsCreate(@RequestParam Map<String, String> requestMap, ModelMap model) throws Exception {
		String sysClsfCd = requestMap.get("sysClsfCd").toString();
		model.addAttribute("sysClsfCd", sysClsfCd);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 자료실 등록
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/insertRcs.json")
	public void insertRcsJson(
			Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		
		try {
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			if(authUser != null) {
				SessionVO sessionVO = authUser.getSessionVO();
				requestMap.put("frstRgtrId", sessionVO.getUserId());
			}

			int result = admRcsService.insertRcs(requestMap);
			if(result == 1) {
				model.addAttribute("result", "success");
			}
			else {
				model.addAttribute("result", "fail");
			}
				
		}
		catch (PersistenceException e){
			model.addAttribute("result", "serverError");
		}
		
	}
	
	/**
	 * 자료실 상세 조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admRcsDetail.do")
	public void admRcsDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = admRcsService.selectRcsDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
		Map<String, Object> videoInfo = admRcsService.selectVideoFile(requestMap);
		model.addAttribute("videoInfo", videoInfo);
	}
	
	/**
	 * 자료실 삭제
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deleteRcs.json")
	public void deleteRcsJson(
			Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		try {
			AuthUser authUser = (AuthUser) authentication.getPrincipal();
			if(authUser == null) {
				model.addAttribute("result", "unauthorized");
			}
			SessionVO sessionVO = authUser.getSessionVO();
			requestMap.put("userId", sessionVO.getUserId());
			
			int result = admRcsService.deleteRcs(requestMap);
			if(result == 1) {
				model.addAttribute("result", "success");
			}
			else {
				model.addAttribute("result", "fail");
			}
		}
		catch (PersistenceException e){
			model.addAttribute("result", "serverError");
		}
	}
	
	/**
	 * 수정 페이지 이동
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/admRcsUpdate.do")
	public void admRcsUpdate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception {
		Map<String, Object> detail = admRcsService.selectRcsDetail(requestMap);
		model.addAttribute("detail", detail);

		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 수정
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/updateRcs.json")
	public void updateRcsJson(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		AuthUser authUser = (AuthUser) authentication.getPrincipal();
		if(authUser == null) {
			model.addAttribute("result", "unauthorized");
		}
		SessionVO sessionVO = authUser.getSessionVO();
		requestMap.put("lastMdfrId", sessionVO.getUserId());
		
		int result = admRcsService.updateRcs(requestMap);
		if(result == 1) {
			model.addAttribute("result", "success");
		}
	}
	
	
}
