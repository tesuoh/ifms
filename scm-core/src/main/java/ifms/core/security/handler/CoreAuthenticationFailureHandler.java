package ifms.core.security.handler;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import ifms.cmn.session.service.SessionService;
import ifms.core.security.vo.ClientVO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

public class CoreAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private SessionService sessionService;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response, AuthenticationException exception) throws IOException, ServletException {

        logger.debug("로그인 실패");
        Map<String, Object> map = null;
        String roleType = "";
        String allowURL[] = { request.getContextPath() + "/cmn/app/login.do?status=locked&inquiry=",
                request.getContextPath() + "/cmn/app/login.do?status=alreadylocked&inquiry=",
                request.getContextPath() + "/cmn/app/login.do?status=loginfailure&inquiry=",
                request.getContextPath() + "/cmn/app/login.do?status=sleeperAccount&inquiry=",
                request.getContextPath() + "/cmn/app/login.do?status=loginfailure",
        };
        String roleTypes[] = { "biz", "ptl", "adm" };	// 문의처

        try {
            map = sessionService.updateLgnFailureCountInc(request.getParameter("username"));

            if(map == null){
                throw new RuntimeException("로그인 실패횟수 증가 실패");
            } else if(!map.get("msgType").equals("completeCountInc")) {
                roleType = (String) map.get("roleType");
            }
            logger.debug("사용자 로그인 실패 처리 완료");
        } catch (SQLException e) {
            logger.debug("SQLException");
        } catch (IOException e) {
            logger.debug("IOException");
        } catch(NullPointerException e) {
            logger.debug("NullPointerException");
        } catch (Exception e){
            logger.error("사용자 로그인 실패처리 작업 도중 오류 발생");
            logger.error(e);
        }

        /* ############################## CLIENT 정보 START ############################## */
        final ClientVO vo = new ClientVO(request, "N");
        try {
            String result = sessionService.insertClientDtl(vo);
        } catch (IllegalArgumentException e) {
            // 입력값이 올바르지 않을 경우 발생할 수 있는 예외 처리
            logger.error("유효하지 않은 클라이언트 데이터입니다: " + e.getMessage(), e);
            // 필요 시 클라이언트에게 에러 메시지를 전달하거나, 추가 처리를 수행합니다.
        } catch (DataAccessException e) {
            // 데이터베이스 접근 중 발생하는 예외 처리
            logger.error("클라이언트 데이터 저장 중 데이터베이스 에러가 발생했습니다: " + e.getMessage(), e);
            // 예를 들어, 트랜잭션 롤백 처리 또는 사용자에게 DB 오류 메시지 반환
        } catch (Exception e) {
            // 그 외 예상치 못한 예외에 대한 처리
            logger.error("클라이언트 데이터 저장 중 알 수 없는 에러가 발생했습니다: " + e.getMessage(), e);
            // 필요 시 일반 에러 처리
        }
        /* ############################## CLIENT 정보 END ############################## */

        logger.error("사용자 로그인 실패");
        String url = "";		// 검증 URL

        if(map != null){

            String msgType = (String) map.get("msgType");

            switch (msgType) {	// 현재 계정이 어떤상태인지에 대한 정보
                case "locked":					// 5회 이상 실패하여 잠김 처리 당한경우
                    url += allowURL[0]; break;
                case "alreadylocked":			// 이미 잠겨있던 경우
                    url += allowURL[1]; break;
                case "completeCountInc":		// 성공적으로 카운트가 증가된경우
                    url += allowURL[2]; break;
                case "sleeperAccount":			// 장기간 미접속 휴면 계정인경우
                    url += allowURL[3]; break;
            }

            response.sendRedirect(url);
        } else {
            response.sendRedirect(allowURL[4]);
        }
    }
}
