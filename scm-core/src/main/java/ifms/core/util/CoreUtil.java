package ifms.core.util;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.ObjectUtils;
import org.springframework.web.servlet.ModelAndView;
import ifms.core.env.CoreControllerAdvice;

import java.util.Locale;

public class CoreUtil {

    private final static Log logger = LogFactory.getLog(CoreUtil.class);

    /**
     * 타일즈 뷰 이름 Default 설정
     * @param request
     * @param modelAndView
     */
    public final static void convertTilesViewName(HttpServletRequest request, ModelAndView modelAndView) {

        String uri = request.getRequestURI().substring(request.getContextPath().length());
        /* @ExceptionHandler 에 의해서 전달된 경우 ModelAndView가 null 이다 */
        if(modelAndView == null) {
            logger.debug("[CoreUtil.getTilesViewName][if(modelAndView == null) {}]");

            modelAndView = new ModelAndView(CoreControllerAdvice.ERROR_PAGE_404);
        }
        String viewName = modelAndView.getViewName();
        if(uri.contains(viewName)) {
            if(uri.startsWith("/")) {
                uri = uri.substring(1);
            }
            modelAndView.setViewName(uri);
        }
    }

    /**
     * request ip 조회
     * @param request
     * @return
     */
    public final static String getIp(HttpServletRequest request) {
        /* 접속자 IP 조회 */
        String ip = request.getHeader("X-Forwarded-For");

        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("HTTP_CLIENT_IP");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("HTTP_X_FORWARDED_FOR");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("X-RealIP");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getHeader("REMOTE_ADDR");
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = request.getRemoteAddr();
        }
        if (ObjectUtils.isEmpty(ip)) {
            ip = "Unknown";
        }

        return ip;
    }

    /**
     * request browser 조회
     * @param request
     * @return
     */
    public final static String getBrowser(HttpServletRequest request) {
        /* 접속자 browser 조회 */
        String browser = "Unknown";
        String agent = request.getHeader("User-Agent");

        if (agent != null) {
            if (agent.indexOf("Trident") > -1) {										//1. IE
                browser = "MSIE";
            } else if (agent.indexOf("Whale") > -1) {									//2. Whale
                browser = "Whale";
            } else if (agent.indexOf("Opera") > -1 || agent.indexOf("OPR") > -1) {		//3. Opera
                browser = "Opera";
            } else if (agent.indexOf("Edg") > -1) {										//4. Edg
                browser = "Edg";
            } else if (agent.indexOf("Chrome") > -1) { 									//5. Chrome
                browser = "Chrome";
            } else if (agent.indexOf("Safari") > -1) {									//6. Safari
                browser = "Safari";
            } else if (agent.indexOf("iPhone") > -1 && agent.indexOf("Mobile") > -1) {	//7. ETC
                browser = "iPhone";
            } else if (agent.indexOf("Android") > -1 && agent.indexOf("Mobile") > -1) {	//8. ETC
                browser = "Android";
            }
        }

        logger.debug("[CLIENT BROWSER]["+browser+"]");

        return browser;
    }

    /**
     * request os 조회
     * @param request
     * @return
     */
    public final static String getOs(HttpServletRequest request) {
        /* 접속자 OS 조회 */
        String os = "Other";
        String agent = request.getHeader("User-Agent");

        if (agent != null) {
            agent = agent.toLowerCase(Locale.ROOT); // 로캘 독립적인 변환 적용

            if (agent.contains("windows nt 10.0")) {
                os = "Windows10";
            } else if (agent.contains("windows nt 6.1")) {
                os = "Windows7";
            } else if (agent.contains("windows nt 6.2") || agent.contains("windows nt 6.3")) {
                os = "Windows8";
            } else if (agent.contains("windows nt 6.0")) {
                os = "WindowsVista";
            } else if (agent.contains("windows nt 5.1")) {
                os = "WindowsXP";
            } else if (agent.contains("windows nt 5.0")) {
                os = "Windows2000";
            } else if (agent.contains("windows nt 4.0")) {
                os = "WindowsNT";
            } else if (agent.contains("windows 98")) {
                os = "Windows98";
            } else if (agent.contains("windows 95")) {
                os = "Windows95";
            } else if (agent.contains("iphone")) {
                os = "iPhone";
            } else if (agent.contains("ipad")) {
                os = "iPad";
            } else if (agent.contains("android")) {
                os = "Android";
            } else if (agent.contains("mac")) {
                os = "Mac OS";
            } else if (agent.contains("linux")) {
                os = "Linux";
            }
        }
        return os;
    }
}
