package ifms.adm.sos.usr.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.sos.usr.service.LgnUsrService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;

/**
 * 로그인 아이디 관리 Controller
 * @author yangcheolseung
 * 
 */

@Controller
@RequestMapping("/adm/sos/usr")
public class LgnUsrListController {
	
	public Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private SessionRegistry sessionRegistry;
	
	@Autowired
	private LgnUsrService lgnUsrService;
	
	/**
     * 로그인 사용자 관리 목록화면
     * @param requestMap
     * @param model
     * @throws Exception
     */
	@PostMapping("/lgnUsrList.do")
	public void lgnUsrList(Authentication authentication,
			@RequestParam Map<String, Object> requestMap,
			ModelMap model) throws Exception {
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
	}
	
	/**
     * 로그인 사용자 관리 조회 
     * @param requestMap
     * @param model
     * @throws Exception
     */
	@PostMapping("/getUserList.json")
	public void getUserList(Authentication authentication,
			@RequestParam Map<String, Object> requestMap,
			ModelMap model) throws Exception {
		
		PagingVO pagingVO = new PagingVO(requestMap);
		
		List<Map<String, Object>> list = lgnUsrService.getLoggedInUsers();

		int totalCount = list.size();
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		model.addAttribute("pagingVO", pagingVO);
		
		if(totalCount > 0) {
			model.addAttribute("list", list);
		}
	}
	
	/**
	 * 로그인 사용자 관리 로그아웃 
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/forceLogout.json")
	public void forceLogout(Authentication authentication,
			@RequestBody Map<String, Object> requestMap,
			ModelMap model) throws Exception {
		
		String userId = (String) requestMap.get("userId");
		boolean result = false;
		
		if (userId != null && !userId.isEmpty()) {		
			result = lgnUsrService.logoutUser(userId);			
		}
		
		if (result) {
			model.addAttribute("result", "success");
		} else {
			model.addAttribute("result", "fail");			
		}
		
	}

	public List<String> getLoggedInUserIds() {

	    List<String> userIds = new ArrayList<>();
	    for (Object principal : sessionRegistry.getAllPrincipals()) {
	        if (principal instanceof AuthUser au) {
	            userIds.add(au.getUsername());
	        }
	    }
	    return userIds;

	}
}
