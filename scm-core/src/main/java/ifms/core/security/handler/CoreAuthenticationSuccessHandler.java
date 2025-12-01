package ifms.core.security.handler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import ifms.cmn.session.service.SessionService;
import ifms.core.security.vo.ClientVO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CoreAuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private SessionService sessionService;

    @Value("${session.time}")
    private int sessionTime;

    @Value("${systemType.type}")
    private String systemType;

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException, ServletException {

        // 테이블에 유저 이름과 로그인한 시간, ip, agent 저장하기
        final ClientVO vo = new ClientVO(request, "Y");
        String result = "";
        try {
            result = sessionService.insertClientDtl(vo);
            if(result.equals("alreadylocked")){	// 로그인에 성공 했지만 계정이 잠겨있는 경우: 계정 잠겨있음을 알리는 팝업 호출
                response.sendRedirect(request.getContextPath()+"/cmn/app/login.do?status=alreadylocked".replaceAll("\r", "").replaceAll("\n", ""));
            } else if(result.equals("sleeperAccount")){
                response.sendRedirect(request.getContextPath()+"/cmn/app/login.do?status=sleeperAccount".replaceAll("\r", "").replaceAll("\n", ""));
            }
        } catch (IOException e) {
            logger.debug("IOException");
        } catch(NullPointerException e) {
            logger.debug("NullPointerException");
        }catch (Exception e) {
            logger.error(e);
        }

        sessionService.loadSession(null);

        String targetUrl = "/";
        if (systemType.equals("SYS020") ) {
            targetUrl = "/biz/main/bizMain.do";
        } else if(systemType.equals("SYS030")){
            /*targetUrl = "/adm/main/admMain.do";*/
            targetUrl = "/adm/bbs/ntc/admNtcList.do";
        } else {
            targetUrl = "/";
        }
        this.setDefaultTargetUrl(targetUrl);
        request.getSession().setMaxInactiveInterval(sessionTime);
        super.onAuthenticationSuccess(request, response, authentication);
    }

}
