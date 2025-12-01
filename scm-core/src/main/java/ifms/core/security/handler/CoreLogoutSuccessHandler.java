package ifms.core.security.handler;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.SimpleUrlLogoutSuccessHandler;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CoreLogoutSuccessHandler extends SimpleUrlLogoutSuccessHandler {

    public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException , ServletException {

        String status = request.getParameter("status") != null ? request.getParameter("status") : "logout";

        this.setDefaultTargetUrl("/cmn/app/login.do?status=" + status);

        super.onLogoutSuccess(request, response, authentication);
    }
}
