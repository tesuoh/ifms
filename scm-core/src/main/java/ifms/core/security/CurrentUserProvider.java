package ifms.core.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import ifms.core.security.service.AuthUser;

@Component
public class CurrentUserProvider {
	
	public String getCurrentUserId() {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth == null || !auth.isAuthenticated()) return null;
		
		Object principal = auth.getPrincipal();
		
		if (principal instanceof AuthUser au) {
			return au.getUsername();
		}
		
		return auth.getName();
	}
}
