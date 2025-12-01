package ifms.cmn.session;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;

import ifms.cmn.session.hlp.IfmsUserDetailsHelper;
import ifms.cmn.session.vo.IfmsPtlUserDetail;

public class IfmsPtlSessionUtil {

    public static Object getAttribute(String key) {
        return RequestContextHolder.getRequestAttributes().getAttribute(key, RequestAttributes.SCOPE_SESSION);
    }

    public static void setAttribute(String key, Object obj) {
        RequestContextHolder.getRequestAttributes().setAttribute(key, obj, RequestAttributes.SCOPE_SESSION);
    }

    public static void removeAttribute(String key) {
        RequestContextHolder.getRequestAttributes().removeAttribute(key, RequestAttributes.SCOPE_SESSION);
    }
    
    public static IfmsPtlUserDetail getUserDetail() {
        return (IfmsPtlUserDetail)RequestContextHolder.getRequestAttributes().getAttribute("ifmsPtlUserDetail", RequestAttributes.SCOPE_SESSION);
    }
    
    public static void setPtlUserDetail(IfmsPtlUserDetail obj) {
        RequestContextHolder.getRequestAttributes().setAttribute("ifmsPtlUserDetail", obj, RequestAttributes.SCOPE_SESSION);
    }
    
    public static boolean isAuthenticated() {
        return IfmsUserDetailsHelper.isPtlAuthenticated();
    }
    
    public static void removeSession() {
    	RequestContextHolder.getRequestAttributes().removeAttribute("ifmsPtlUserDetail", RequestAttributes.SCOPE_SESSION);
    }    
    
    public static String getUserIp() {
    	if(isAuthenticated()) return getUserDetail().getUserIp();
    	else return null;
	}
    
    public static String getPtlAuth() {
    	if(isAuthenticated()) return getUserDetail().getPtlAuth();
    	else return null;
	}
    
    public static String getResdNo() {
    	if(isAuthenticated()) return getUserDetail().getResdNo();
    	else return null;
	}
    
    public static String getCorpNo() {
    	if(isAuthenticated()) return getUserDetail().getCorpNo();
    	else return null;
	} 
    
    public static String getUserNm() {
    	if(isAuthenticated()) return getUserDetail().getUserNm();
    	else return null;
	}
    
    public static String getUserDn() {
    	if(isAuthenticated()) return getUserDetail().getUserDn();
    	else return null;
	}   
    
    public static String getCaptchaWord() {
    	if(isAuthenticated()) return getUserDetail().getCaptchaWord();
    	else return null;
	}  
    
    public static void setCaptchaWord(String captchaWord) {
    	getUserDetail().setCaptchaWord(captchaWord);
    }    
}