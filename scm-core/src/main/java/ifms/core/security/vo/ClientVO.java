package ifms.core.security.vo;
import ifms.core.util.CoreUtil;

import javax.servlet.http.HttpServletRequest;


public class ClientVO {

    private String username;
    private String ip;
    private String browser;
    private String os;
    private String lgnYn;

    public ClientVO(HttpServletRequest request, String lgnYn) {

        // 지역 변수로 먼저 저장
        String userId = request.getParameter("username");
        String userIp = CoreUtil.getIp(request);
        String userBrowser = CoreUtil.getBrowser(request);
        String userOs = CoreUtil.getOs(request);

        // 유효성 검증 후 멤버 변수에 할당
        if (userId == null || userId.trim().isEmpty()) {
            throw new IllegalArgumentException("유효하지 않은 사용자 ID입니다.");
        }

        this.username = userId.trim();
        this.ip = userIp;
        this.browser = userBrowser;
        this.os = userOs;
        this.lgnYn = lgnYn;
    }

    // Getter 메서드
    public String getUsername() {
        return username;
    }

    public String getIp() {
        return ip;
    }

    public String getBrowser() {
        return browser;
    }

    public String getOs() {
        return os;
    }

    public String getLgnYn() {
        return lgnYn;
    }

}
