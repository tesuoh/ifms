package ifms.cmn.session;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import ifms.cmn.session.hlp.IfmsUserDetailsHelper;
import ifms.cmn.session.vo.IfmsUserDetail;

public class IfmsSessionUtil {

    public static Object getAttribute(String key) {
        return RequestContextHolder.getRequestAttributes().getAttribute(key, RequestAttributes.SCOPE_SESSION);
    }

    public static void setAttribute(String key, Object obj) {
        RequestContextHolder.getRequestAttributes().setAttribute(key, obj, RequestAttributes.SCOPE_SESSION);
    }

    public static void removeAttribute(String key) {
        RequestContextHolder.getRequestAttributes().removeAttribute(key, RequestAttributes.SCOPE_SESSION);
    }

    public static IfmsUserDetail getUserDetail() {
        return (IfmsUserDetail)RequestContextHolder.getRequestAttributes().getAttribute("ifmsUserDetail", RequestAttributes.SCOPE_SESSION);
    }
    
    public static void setUserDetail(IfmsUserDetail obj) {
        RequestContextHolder.getRequestAttributes().setAttribute("ifmsUserDetail", obj, RequestAttributes.SCOPE_SESSION);
    }
    
    public static boolean isAuthenticated() {
        return IfmsUserDetailsHelper.isAuthenticated();
    }
    
    public static void removeSession() {
    	RequestContextHolder.getRequestAttributes().removeAttribute("id", RequestAttributes.SCOPE_SESSION);
    	RequestContextHolder.getRequestAttributes().removeAttribute("ifmsUserDetail", RequestAttributes.SCOPE_SESSION);
    }
    
    public static String getUserIp() {
    	if(isAuthenticated()) return getUserDetail().getUserIp();
    	else return null;
	}
    public static String getOrgCd() {
    	if(isAuthenticated()) return getUserDetail().getOrgCd();
    	else return null;
	}
    public static String getSggCd() {
    	if(isAuthenticated()) return getUserDetail().getSggCd();
    	else return null;
	}
    public static String getAuth() {
    	if(isAuthenticated()) return getUserDetail().getAuth();
    	else return null;
	}
    public static String getUserId() {
    	if(isAuthenticated()) return getUserDetail().getUserId();
    	else return null;
	}
    public static String getUserNm() {
    	if(isAuthenticated()) return getUserDetail().getUserNm();
    	else return null;
	}
    public static String getTelno() {
    	if(isAuthenticated()) return getUserDetail().getTelno();
    	else return null;
	}
    public static void setSessionId() {
    	 RequestContextHolder.getRequestAttributes().setAttribute("id", RequestContextHolder.getRequestAttributes().getSessionId(), RequestAttributes.SCOPE_SESSION);
    }
    public static String getSessionId() {
    	return (String)RequestContextHolder.getRequestAttributes().getAttribute("id", RequestAttributes.SCOPE_SESSION);
    }    
    public static String getCaptchaWord() {
    	if(isAuthenticated()) return getUserDetail().getCaptchaWord();
    	else return null;
	}   
    public static void setCaptchaWord(String captchaWord) {
    	getUserDetail().setCaptchaWord(captchaWord);
    }      
}