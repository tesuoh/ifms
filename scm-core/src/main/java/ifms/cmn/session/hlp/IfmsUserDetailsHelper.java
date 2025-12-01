package ifms.cmn.session.hlp;

import java.util.List;

import org.springframework.web.context.request.RequestContextHolder;

import ifms.cmn.session.IfmsPtlSessionUtil;
import ifms.cmn.session.IfmsSessionUtil;
import ifms.cmn.session.service.IfmsUserDetailsService;

public class IfmsUserDetailsHelper {

	static IfmsUserDetailsService ifmsUserDetailsService;

	public IfmsUserDetailsService getifmsUserDetailsService() {
		return ifmsUserDetailsService;
	}

	public void setifmsUserDetailsService(IfmsUserDetailsService ifmsUserDetailsService) {
		IfmsUserDetailsHelper.ifmsUserDetailsService = ifmsUserDetailsService;
	}

	/**
	 * 인증된 사용자객체를 VO형식으로 가져온다.
	 * @return Object - 사용자 ValueObject
	 */
	public static Object getAuthenticatedUser() {
		 return IfmsSessionUtil.getAttribute("loginVO");
//		return ifmsUserDetailsService.getAuthenticatedUser();
	}

	/**
	 * 인증된 사용자의 권한 정보를 가져온다.
	 *
	 * @return List - 사용자 권한정보 목록
	 */
	public static List<String> getAuthorities() {
		return ifmsUserDetailsService.getAuthorities();
	}

	/**
	 * 인증된 사용자 여부를 체크한다.
	 * @return Boolean - 인증된 사용자 여부(TRUE / FALSE)
	 */
	public static Boolean isAuthenticated() {
		if (RequestContextHolder.getRequestAttributes() == null) {
			return false;
		} else {
			if (IfmsSessionUtil.getSessionId() != null
					&& RequestContextHolder.getRequestAttributes().getSessionId().equals(IfmsSessionUtil.getSessionId())) {
				return true;
			} else {
				return false;
			}
		}
		//return true; //TODO : 성능테스트 임시 조치
	}
	
	/**
	 * 인증된 사용자 여부를 체크한다.
	 * @return Boolean - 인증된 사용자 여부(TRUE / FALSE)
	 */
	public static Boolean isPtlAuthenticated() {
		if (RequestContextHolder.getRequestAttributes() == null) {
			return false;
	 
		} else {
	 
			if (IfmsPtlSessionUtil.getUserDetail() == null) {
				return false;
			} else {
				return true;
			}
		}
//		return ifmsUserDetailsService.isAuthenticated();
	}
}
