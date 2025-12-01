package ifms.adm.main.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping(value = "/adm/main")
public class AdmMainController {

    public final Log logger = LogFactory.getLog(this.getClass());


    /**
     * 관리자 메인
     * @param authentication
     * @param requestMap
     * @param model
     * @throws Exception
     */
    @GetMapping(value = "/admMain.do")
    public void  admMain(Authentication authentication,
                        Map<String, Object> requestMap,
                        ModelMap model) throws Exception {

        // Authentication 객체에서 AuthUser 가져오기
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        if (authUser != null) {
            SessionVO sessionVO = authUser.getSessionVO();
            if (sessionVO != null) {
                // 필요한 로직 처리
            } else {
                logger.error("sessionVO is null");
                // 예외 처리 또는 로그인 페이지로 리다이렉트
            }
        } else {
            logger.error("authUser is null");
            // 인증되지 않은 사용자 처리
        }
    }

    /**
     * 사이트맵
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/siteMap.do")
    public String siteMap(HttpServletRequest request, ModelMap model) throws Exception {
        return "adm/main/siteMap";
    }

    /**
     * 개인정보처리방침
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/privacyPolicy.do")
    public String privacyPolicy(HttpServletRequest request, ModelMap model) throws Exception {
        return "adm/main/privacyPolicy";
    }

    /**
     * 공공데이터이용정책
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/publicDataUsagePolicy.do")
    public String publicDataUsagePolicy(HttpServletRequest request, ModelMap model) throws Exception {
        return "adm/main/publicDataUsagePolicy";
    }

    /**
     * 이용안내
     * @param request
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value="/serviceGuide.do")
    public String serviceGuide(HttpServletRequest request, ModelMap model) throws Exception {
        return "adm/main/serviceGuide";
    }


}
