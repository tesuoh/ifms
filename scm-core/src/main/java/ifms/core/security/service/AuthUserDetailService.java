package ifms.core.security.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.authentication.LockedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import ifms.cmn.session.mapper.SessionMapper;
import ifms.core.security.vo.AccessibleUrl;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AuthUserDetailService implements UserDetailsService {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private SessionMapper sessionMapper;
    
    @Autowired
    private HttpServletRequest request;

    @Value("${systemType.type}")
    private String systemType;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {

        /* 0. 로그인구분 */
        String type = request.getParameter("type");
        String loginMenu = request.getParameter("loginMenu");
        String isMobile = request.getParameter("isMobile");

        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("username", username);
        paramMap.put("type", type);
        paramMap.put("loginMenu", loginMenu);
        paramMap.put("siteClsfCd", systemType);
        
        // 사용자 정보를 조회
        SessionVO sessionVO = null;
        try {
            sessionVO = sessionMapper.findBy(paramMap);
        } catch (NullPointerException e) {
            logger.error("사용자 정보를 조회하는 중 NullPointerException 발생: ", e);
            throw new UsernameNotFoundException("사용자 정보가 존재하지 않습니다.");
        } catch (RuntimeException e) {
            logger.error("사용자 정보를 조회하는 중 RuntimeException 발생: ", e);
            throw new UsernameNotFoundException("RuntimeException 발생으로 사용자 정보를 조회할 수 없습니다.");
        }

        if (sessionVO == null) {
            logger.debug("사용자 없음: " + username);
            throw new UsernameNotFoundException("사용자를 찾을 수 없습니다.");
        }

        // 계정 잠금 여부 확인
        boolean isLockedUser = sessionVO.getLgnFailLckYn() >= 5;
        if (isLockedUser) {
            logger.debug("로그인 5회 이상 실패하여 잠긴 사용자: " + username);
            throw new LockedException("계정이 잠겨 있습니다.");
        }

        /* 인증정보 생성하기 */
        List<GrantedAuthority> authorities = new ArrayList<>();

        // 기본 역할 추가
        String defaultRolName = "ROLE_MEMBER";
        authorities.add(new SimpleGrantedAuthority(defaultRolName));

        // 1. 사용자 역할 및 권한을 데이터베이스에서 로드
        //List<String> roleList = sessionMapper.findRolesByUsername(username); // 역할 목록 조회
        List<String> permissionList = sessionMapper.findPermissionsByUsername(username); // 권한 목록 조회

        // 2. 역할과 권한을 GrantedAuthority로 변환하여 추가
        /*for (String role : roleList) {
            authorities.add(new SimpleGrantedAuthority(role));
        }*/
        for (String permission : permissionList) {
            authorities.add(new SimpleGrantedAuthority(permission));
        }

        // 3. 사용자별 접근 가능한 URL 목록을 가져옴
        //List<AccessibleUrl> accessibleUrls = sessionMapper.findUrlsByUserId(username);

        // 4. AuthUser 객체 생성 및 반환
        //return new AuthUser(sessionVO, authorities, accessibleUrls);
        return new AuthUser(sessionVO, authorities);
    }
}
