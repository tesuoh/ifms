package ifms.cmn.session.web;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import ifms.cmn.session.service.SessionService;
import ifms.core.security.service.AuthUser;

import java.util.Map;

@Controller
@RequestMapping(value="/common/session")
public class SessionController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private SessionService sessionService;

    @Value("4200")
    private int sessionTime;


    /**
     * 사용자 권한메뉴 목록 조회
     * @param authUser
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectAuthMenuList.json")
    public void selectAuthMenuList(@AuthenticationPrincipal AuthUser authUser
            , @RequestBody Map<String, Object> requestMap
            , HttpServletRequest request, ModelMap model) throws Exception{
        logger.debug("["+this.getClass().getName()+"][selectAuthMenuList] START");

        model.addAttribute("authMenuList", authUser.getSessionVO().getMenuList());					//메뉴목록

        logger.debug("["+this.getClass().getName()+"][selectAuthMenuList] END");
    }

    /**
     * 세션 연장
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/extendTime.json")
    public void extendTime(@RequestBody Map<String, Object> requestMap
            , HttpServletRequest request, Model model) throws Exception{
        logger.debug("["+this.getClass().getName()+"][extendTime] START");

        request.getSession().setMaxInactiveInterval(sessionTime);

        logger.debug("["+this.getClass().getName()+"][extendTime] END");
    }


    /**
     * 세션 갱신
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/updateSession.json")
    public void updateSession(@RequestBody Map<String, Object> requestMap
            , HttpServletRequest request, Model model) throws Exception{
        logger.debug("["+this.getClass().getName()+"][updateSession] START");

        try {
            sessionService.loadSession(requestMap);

            request.getSession().setMaxInactiveInterval(sessionTime);

            model.addAttribute("result", true);
            model.addAttribute("resultMap", requestMap);
        } catch (ServletException e) {

            model.addAttribute("result", false);
        } finally {
            logger.debug("["+this.getClass().getName()+"][updateSession] END");
        }

    }



}
