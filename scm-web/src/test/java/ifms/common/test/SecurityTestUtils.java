package ifms.common.test;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.web.servlet.request.RequestPostProcessor;

import java.util.List;
import java.util.Map;

import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

public class SecurityTestUtils {

    public static RequestPostProcessor customAuthUser(final String userId, final String userPwd) {
        return request -> {
            SessionVO sessionVO = new SessionVO();
            sessionVO.setUserId(userId);
            sessionVO.setUserPswd(userPwd);
            sessionVO.setUserMap(Map.of("authrtId", "ROL_BIZ_0404"));
            
            List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority("ROLE_ADMIN"));

            AuthUser authUser = new AuthUser(sessionVO, authorities);

            Authentication authentication =
                    new UsernamePasswordAuthenticationToken(
                            authUser, null, authorities);

            SecurityContextHolder.getContext().setAuthentication(authentication);

            return SecurityMockMvcRequestPostProcessors.authentication(authentication)
                    .postProcessRequest(request);
        };
    }
}