package ifms.adm.sos.usr.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.session.SessionInformation;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.stereotype.Service;

import ifms.core.security.service.AuthUser;

@Service
public class LgnUsrService {
	@Autowired
    private SessionRegistry sessionRegistry;

    /**
     * 로그인된 사용자 목록 조회
     */
    public List<Map<String, Object>> getLoggedInUsers() {
        List<Map<String, Object>> result = new ArrayList<>();

        int i = 0;
        for (Object principal : sessionRegistry.getAllPrincipals()) {
        	
            if (!(principal instanceof AuthUser)) continue;
            AuthUser au = (AuthUser) principal;

            List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
            if (sessions == null || sessions.isEmpty()) continue;

            for (SessionInformation sessionInfo : sessions) {
                Map<String, Object> map = new HashMap<>();
                map.put("rowNum", ++i);
                map.put("userId", au.getUsername());
                map.put("lastReq", dateTimeString(sessionInfo.getLastRequest()));
                result.add(map);
            }
        }

        return result;
    }

    /**
     * 특정 사용자 ID에 대한 모든 세션 무효화
     */
    public boolean logoutUser(String targetUserId) {
        for (Object principal : sessionRegistry.getAllPrincipals()) {
            if (!(principal instanceof AuthUser)) continue;
            AuthUser au = (AuthUser) principal;

            if (targetUserId.equals(au.getUsername())) { // 필요 시 au.getUserId()로 변경
                List<SessionInformation> sessions = sessionRegistry.getAllSessions(principal, false);
                if (sessions == null || sessions.isEmpty()) continue;

                for (SessionInformation session : sessions) {
                    session.expireNow(); // 다음 요청 시 즉시 만료 처리
                    return true;
                }
            }
        }
        
        return false;
    }
    
    private String dateTimeString(Date date) {
    	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        return sdf.format(date);
    }
}
