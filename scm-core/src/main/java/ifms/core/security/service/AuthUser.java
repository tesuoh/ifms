package ifms.core.security.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;
import ifms.core.security.vo.AccessibleUrl;
import ifms.core.security.vo.SessionVO;

import java.util.Collection;
import java.util.List;

public class AuthUser extends User {

    public final Log logger = LogFactory.getLog(this.getClass());

    private static final long serialVersionUID = 950926958647038606L;

    private SessionVO sessionVO;

    /*private List<AccessibleUrl> accessibleUrls;

    public AuthUser(SessionVO sessionVO, Collection<? extends GrantedAuthority> authorities, List<AccessibleUrl> accessibleUrls) {
        super(sessionVO.getUserId(), sessionVO.getUserPswd(), authorities);
        this.sessionVO = sessionVO;
        this.accessibleUrls = accessibleUrls;

    }

    public List<AccessibleUrl> getAccessibleUrls() {
        return accessibleUrls;
    }

    public void setAccessibleUrls(List<AccessibleUrl> accessibleUrls) {
        this.accessibleUrls = accessibleUrls;
    }*/

    public AuthUser(SessionVO sessionVO, Collection<? extends GrantedAuthority> authorities) {
        super(sessionVO.getUserId(), sessionVO.getUserPswd(), authorities);
        this.sessionVO = sessionVO;
    }

    public SessionVO getSessionVO() {
        if(sessionVO == null) {
            throw new IllegalStateException("sessionVO is null");
        }
        return sessionVO;
    }
}
