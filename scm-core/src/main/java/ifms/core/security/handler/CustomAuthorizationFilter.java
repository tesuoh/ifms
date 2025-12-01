package ifms.core.security.handler;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import ifms.cmn.session.service.SessionService;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

@Component
public class CustomAuthorizationFilter extends OncePerRequestFilter {

    private AntPathMatcher pathMatcher = new AntPathMatcher();

    @Autowired
    private SessionService sessionService;

    // 공개적으로 접근 가능한 URL 목록
    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/index.jsp",
            "/cmn/app/login.do",
            "/loginAction.do",
            "/logout.do",
            "/common/**",
            "/cmn/**",
            "/com/**",
            "/js/**",
            "/ClipReport5/**",
            "/**/*.report",
            /*"/adm/main/admMain.do",
            "/adm/main/siteMap.do",*/
            /*"/**",*/
            "none\n"
    );

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {

        String url = request.getRequestURI();
        String contextPath = request.getContextPath();
        String processedUrl = url.substring(contextPath.length());

        List<String> excludePaths = Arrays.asList(
                contextPath + "/cmn/app/login.do",
                contextPath + "/loginAction.do",
                contextPath + "/logout.do"
        );

        if (contextPath.equals(url) || "/".equals(url) && !excludePaths.contains(url)) {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

            if (authentication != null && authentication.isAuthenticated() && !(authentication instanceof AnonymousAuthenticationToken)) {
                logger.debug("사용자가 인증되었으므로 admMain.do로 리다이렉트합니다.");
                response.sendRedirect(contextPath + "/adm/main/admMain.do");
            } else {
                response.sendRedirect(contextPath + "/cmn/app/login.do");
            }
            return;
        }

        // 공개 URL인지 확인
        boolean isPublicUrl = PUBLIC_URLS.stream()
                .anyMatch(pattern -> pathMatcher.match(pattern, processedUrl));

        if (isPublicUrl) {
            // 공개 URL은 권한 검사 없이 필터 체인 진행
            filterChain.doFilter(request, response);
            return;
        }

        // 현재 인증된 사용자 정보 가져오기
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // 익명 사용자 또는 인증되지 않은 경우 필터 체인 진행
        if (authentication == null || !authentication.isAuthenticated() || authentication instanceof AnonymousAuthenticationToken) {
            filterChain.doFilter(request, response);
            return;
        }

        // 사용자 객체 가져오기
        if (!(authentication.getPrincipal() instanceof AuthUser)) {
            // 인증된 사용자 정보가 아니므로 필터 체인 진행
            filterChain.doFilter(request, response);
            return;
        }

        // 사용자 객체 가져오기
        AuthUser authUser = (AuthUser) authentication.getPrincipal();

        // 사용자 세션 정보 가져오기 (조회 및 업데이트 수행)
        // 사용자의 권한조회 후 사용자의 url 수정 권한 여부 정보 저장함
        SessionVO sessionVO = authUser.getSessionVO();
        String authrtId = (String)sessionVO.getUserMap().get("authrtId");

        try {
            Map<String, Map<String, Object>> authrtIdUrlMap = sessionService.getAuthrtUrlMap(authrtId);

            // 권한이 없는 경우
            if (authrtIdUrlMap == null || !authrtIdUrlMap.containsKey(processedUrl)) {
                sessionVO.setCrtMdfcnAuthrtYn("N");
            }
            else {
                // 현재 URL에 대한 수정권한 저장
                Map<String, Object> authrtIdUrl = authrtIdUrlMap.get(processedUrl);
                sessionVO.setCrtMdfcnAuthrtYn("Y".equals(authrtIdUrl.get("mdfcnAuthrtYn"))?"Y":"N");
            }

        } catch (NullPointerException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Null Pointer Exception 발생: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 인자가 전달되었습니다: " + e.getMessage());
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 내부 오류 발생: " + e.getMessage());
        }

        // 메뉴에 대한 처리
        try {
            // 권한에 대한 메뉴 조회
            String menuJson = sessionService.getMenuJsonList(authrtId);
            // 권한에 대한 메뉴 저장
            request.setAttribute("menuJson", menuJson);
            request.setAttribute("processedUrl", processedUrl);

        } catch (NullPointerException | SQLException e) {
            logger.error("예외 발생: " + e.getClass().getSimpleName(), e);
        } catch (RuntimeException e) {
            throw new RuntimeException(e);
        }

        // url 접속이력 저장
        try {
        	String srvrNm = request.getServerName();
        	String userId = sessionVO.getUserId();
        	
        	Map<String, Object> requestMap = new HashMap<>();
        	requestMap.put("srvrNm", srvrNm);
        	requestMap.put("userId", userId);
        	requestMap.put("cntnUrlAddr", processedUrl);
        	
			sessionService.insertUrlCntnHstry(requestMap);
		} catch (NullPointerException e) {
            // NullPointerException 발생 시 처리
            logger.error("[NullPointerException 발생] - 서버명 또는 사용자 ID가 null입니다.", e);
        } catch (IllegalArgumentException e) {
            // IllegalArgumentException 발생 시 처리
            logger.error("[IllegalArgumentException 발생] - 입력값이 올바르지 않습니다: " + processedUrl, e);
        } catch (RuntimeException | SQLException e) {
            // 기타 런타임 예외 처리
            logger.error("[RuntimeException 발생] - 예기치 못한 런타임 오류 발생", e);
        }


        // 권한이 있거나, 보호되지 않은 URL인 경우 필터 체인 진행
        filterChain.doFilter(request, response);
    }
}
