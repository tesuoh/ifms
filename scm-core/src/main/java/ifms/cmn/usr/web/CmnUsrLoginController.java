package ifms.cmn.usr.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.ObjectUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ifms.cmn.session.IfmsSessionUtil;
import ifms.cmn.session.service.SessionService;
import ifms.cmn.util.IfmsGlobalsUtil;

import javax.servlet.http.HttpSession;

/**
 * 경찰청 보호구역통합관리시스템 구축사업 (2024) 
 * 사용자로그인 Controller
 */

@Controller

public class CmnUsrLoginController {
	 
	public final Log logger = LogFactory.getLog(getClass());
	
	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
    @Autowired
    private SessionService sessionService;

	/**
	 * 로그인 처리
	 * @param status
	 * @param inquiry
	 * @param id
	 * @param pwd
	 * @param error
	 * @param logout
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/cmn/app/login.do")
	public String login(@RequestParam(required = true, value="status", defaultValue = "") String status
			, @RequestParam(required = false, value="inquiry", defaultValue ="") String inquiry	/* 로그인 잠겼을 경우 안내 메시지 */
			, @RequestParam(required = true, value = "id", defaultValue = "") String id
			, @RequestParam(required = true, value = "pwd", defaultValue = "") String pwd
			, String error
			, String logout
			, Model model) throws Exception {

		logger.debug("========================================================================");
		String systemTy = ifmsGlobalsUtil.getProperties("SYSTEM_TY");

		/* 로그아웃 성공시 상태값 화면에 전달 */
		if(!ObjectUtils.isEmpty(status)) {

			model.addAttribute("status", status);
			model.addAttribute("inquiry", inquiry);	// 잠긴 계정 문의 해야하는 기관 안내

			/* 로그인 실패시 [ 5회 실패로 잠긴 경우 | 기존에 잠겨있던 경우 | 단순 로그인 실패의 경우 | 장기간 미접속 휴면 계정의 경우 ]*/
			if("loginfailure".equals(status) || "alreadylocked".equals(status) || "locked".equals(status) || "sleeperAccount".equals(status)) {
				model.addAttribute("id", id);
				model.addAttribute("pwd", pwd);
			}
		}

		if(error != null) {
			model.addAttribute("error", "잘못된 요청입니다.");
		}
		if(logout != null) {
			model.addAttribute("logout", "로그아웃 했습니다.");
		}

		logger.debug("[CmnUsrLoginController.login][login.do] 진입");
		model.addAttribute("mainYn", "Y");
		if("adm".equals(systemTy)) {
			return "cmn/usr/lgn/login.tiles";
		}
		if("biz".equals(systemTy)) {
			return "cmn/usr/lgn/login.tiles";
		}
		if("ptl".equals(systemTy)) {
			return "/ptl/app/mainLogin.tiles";
		}
        return null;
    }

	/**
	 * 로그아웃 처리한다.
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/cm/usr/actionLogout.do")
	public String actionLogout(HttpSession session){
		//중복로그인 처리 시작
        IfmsSessionUtil.removeSession();
        session.invalidate(); 
        //중복로그인 처리 시작
        
        return "/cmn/app/main";            
	}		
	
	
	/**
	 * 로그아웃 처리한다.
	 * @return result - 로그인결과(세션정보)
	 * @exception Exception
	 */
	@RequestMapping(value = "/cm/usr/checkSession.do")
	public void checkSession(HttpSession session){
		/*LOGGER.info("========================================================================");
		LOGGER.info("=================[ifmsSessionUtil.isAuthenticated();] " + ifmsSessionUtil.isAuthenticated() + "================");
		LOGGER.info("=================[사용자ID:" +ifmsSessionUtil.getUserId()+ "] ifmsSessionUtil.getUserId(); ================");
		LOGGER.info("=================[사용자성명:" +ifmsSessionUtil.getUserNm()+ "] ifmsSessionUtil.getUserNm(); ================");
		LOGGER.info("=================[사용자권한코드:" +ifmsSessionUtil.getAuth()+ "] ifmsSessionUtil.getAuth(); ================");
		LOGGER.info("========================================================================");		*/
	}		
}
