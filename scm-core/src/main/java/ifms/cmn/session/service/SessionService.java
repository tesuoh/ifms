package ifms.cmn.session.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.AuthenticationCredentialsNotFoundException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import ifms.cmn.session.mapper.SessionMapper;
import ifms.common.constants.Const;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.AccessibleUrl;
import ifms.core.security.vo.ClientVO;
import ifms.core.security.vo.SessionVO;

import javax.servlet.ServletException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class SessionService {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private SessionMapper sessionMapper;

    @Value("${systemType.type}")
    private String systemType;

    /**
     * 권한정보 획득
     * @param requestMap
     * @throws ServletException
     */
    public void loadSession(Map<String, Object> requestMap) throws ServletException {
        try {
            /* #################### 1. 기존 인증정보 불러오기 #################### */
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            if (authentication == null || !(authentication.getPrincipal() instanceof AuthUser)) {
                throw new AuthenticationCredentialsNotFoundException("인증 정보가 유효하지 않습니다.");
            }
            AuthUser principal = (AuthUser) authentication.getPrincipal();
            SessionVO newSessionVO = principal.getSessionVO();
            Map<String, Object> userParamMap = new HashMap<>();
            userParamMap.put("userId", newSessionVO.getUserId());
            userParamMap.put("siteClsfCd", systemType);

            /* #################### 2. 현재사용자의 세션정보 - userId에 대한 사용자정보 #################### */
            Map<String, Object> mainUserMap;
            try {
                mainUserMap = sessionMapper.selectMainUserMap(userParamMap);
            } catch (DataAccessException dae) {
                logger.error("데이터베이스 접근 오류 (selectMainUserMap): ", dae);
                throw new ServletException("사용자 정보를 불러오는 중 오류가 발생했습니다.");
            }
            newSessionVO.setMainUserMap(mainUserMap);

            Map<String, Object> paramMap = new HashMap<>();
            paramMap.put("ifmsId", newSessionVO.getIfmsId());
            paramMap.put("siteClsfCd", systemType);

            /* #################### 3. 현재사용자의 세션정보 - ifmsId에 대한 사용자정보 #################### */
            Map<String, Object> userMap = sessionMapper.selectUserMap(paramMap);
            newSessionVO.setUserMap(userMap);

            /* #################### 4. 세션사용자의 역할목록 - userMap의 권한이 부여된 역할목록 #################### */
            List<Map<String, Object>> roleList = sessionMapper.selectRoleList(paramMap);
            newSessionVO.setRoleList(roleList);

            /* #################### 5. 메뉴 리스트 조회 #################### */

            /* #################### 99. 인증정보 변경 #################### */
            AuthUser authUser = new AuthUser(newSessionVO, authentication.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(new UsernamePasswordAuthenticationToken(authUser, null, authentication.getAuthorities()));

        } catch (AuthenticationCredentialsNotFoundException acnfe) {
            logger.error("인증 정보 오류: ", acnfe);
            throw new ServletException("사용자 인증 정보가 유효하지 않습니다.");
        } catch (ServletException se) {
            throw se; // 이미 처리된 ServletException은 그대로 던짐
        } catch (MenuRetrievalException mre) {
            logger.error("메뉴 정보 오류: ", mre);
            throw new ServletException(mre.getMessage());
        }
    }

    public class MenuRetrievalException extends RuntimeException {
        public MenuRetrievalException(String message) {
            super(message);
        }
    }


    public String insertClientDtl(ClientVO vo) throws RuntimeException {

        int resultCount = sessionMapper.insertClientDtl(vo); // 접속정보 이력등록

        // 로그인에 성공 한 경우 사용자 로그인 실패 횟수와 잠금 여부와 휴면계정 상태 조회
        if(vo.getLgnYn().equals("Y")) {
            Map<String, Object> map = sessionMapper.selectLgnFailureCount(vo.getUsername());

            Object obj = map.get("lgnFailNmtm");
            int lgnFailLckYn;

            try {
                lgnFailLckYn = (obj instanceof Number) ? ((Number) obj).intValue() : Integer.parseInt(obj.toString());
            } catch (RuntimeException e) {
                throw new RuntimeException("LGN_FAIL_NMTM 값이 유효한 정수가 아닙니다.");
            }

            // 이미 잠긴계정인 경우
            if(lgnFailLckYn >= 5){
                return "alreadylocked";
            } else {	// 계정이 잠겨있지 않다면
                // 최종 로그인 일자 갱신
                int updateResultLastLgnYmd = sessionMapper.updateResultLastLgnYmd(vo);
                // 로그인 실패 횟수 초기화
                int updateInitLgnFailLckYn = sessionMapper.updateInitLgnFailLckYn(vo);
                // 수정 처리 실패 및 사용자 이력 정보 등록 실패시 RuntimeException Throws
                if(updateResultLastLgnYmd == 0){
                    throw new RuntimeException("최종 로그인 일자 갱신에 실패하였습니다.");
                } else if(updateInitLgnFailLckYn == 0) {
                    throw new RuntimeException("로그인 실패 횟수 초기화에 실패하였습니다.");
                } else if(resultCount == 0) {
                    throw new RuntimeException("접속정보 이력 등록에 실패하였습니다.");
                }
            }
        }
        // 사용자 이력 정보 등록 성공 반환
        return "success";
    }


    /**
     * 로그인 실패시 계정 실패횟수 증가 및 잠그기
     * @param username
     * @return
     * @throws Exception
     */
    public Map<String, Object> updateLgnFailureCountInc(String username) throws Exception {
        Map<String, Object> map = sessionMapper.selectLgnFailureCount(username);
        if(map != null){	// 로그인 실패 횟수 작업이 가능한 경우 (아이디만 맞은 경우)
            Object obj = map.get("lgnFailNmtm"); // 올바른 키 사용
            int lgnFailNmtm;

            try {
                lgnFailNmtm = (obj instanceof Number) ? ((Number) obj).intValue() : Integer.parseInt(obj.toString());
            } catch (NumberFormatException e) {
                throw new RuntimeException("lgnFailNmtm 값이 유효한 정수가 아닙니다.");
            }

            String aprvYn = (String) map.get("aprv_yn"); // 승인 여부
            String roleId = (String) map.get("authrt_id"); // 권한 ID 키

            if(lgnFailNmtm >= 5 && "Y".equals(aprvYn)) {    // 사용자 로그인 실패횟수 체크 (5회 이상)
                sessionMapper.updateLgnFailLckYn(username);       // 5회 이상 실패 시 계정 잠금
                map.put("roleType", setLgnFailureMsg(roleId));  // 사용자 역할에 따른 안내메시지 받기
                map.put("msgType","locked");
            } else if("N".equals(aprvYn)){
                map.put("roleType", setLgnFailureMsg(roleId));  // 사용자 역할에 따른 안내메시지 받기
                map.put("msgType","alreadylocked");
            } else {
                sessionMapper.updateLgnFailureCountInc(username);    // 사용자 로그인 실패횟수 1회 증가
                map.put("msgType", "completeCountInc");
            }

            return map;
        } else {			// 로그인 실패 횟수 작업이 불가능한 경우 (존재하지 않는 아이디로 로그인 시도한 경우)
            return null;
        }
    }

    /**
     * 로그인 계정 잠긴 경우 사용자 역할에 따른 메시지 반환 함수
     * @param userRole
     * @return
     * @throws Exception
     */
    public String setLgnFailureMsg(String userRole) throws Exception{
        // 해당 사업장 관리자에게 문의해주세요.
        if(userRole.equals(Const.USER_ROLE_CD_URC101) || userRole.equals(Const.USER_ROLE_CD_URC102) || userRole.equals(Const.USER_ROLE_CD_URC103)
                || userRole.equals(Const.USER_ROLE_CD_URC104) || userRole.equals(Const.USER_ROLE_CD_URC105) || userRole.equals(Const.USER_ROLE_CD_URC106))
        {
            return "biz";
        }
        // 해당 관리기관에 문의해주세요.
        else {
            return "adm";
        }
    }

    /**
     * 권한에 대한 접근가능URL 조회 (Local cache 처리 전제로 구현됨)
     * @authrtId 권한 ID
     * @return 권한에 대해 접근가능한 URL 목록
     * <br/>Map{authrt_id(권한아이디), Map{authrt_id(권한아이디), authrt_nm(권한이름), mdfcn_authrt_yn(수정권한여부), url_addr(url 주소)}}
     * @throws Exception
     */
    @Cacheable(cacheNames = "authrtUrlCache", key = "#authrtId")
    public Map<String, Map<String, Object>> getAuthrtUrlMap(String authrtId) throws RuntimeException {

        List<Map<String, Object>> authrtUrlList = sessionMapper.selectAuthrtUrlList(authrtId);
        Map<String, Map<String, Object>> authrtUrlMap = new HashMap<String, Map<String, Object>>();

        if (authrtUrlList != null && authrtUrlList.size() > 0) {
            for (int i = 0; i < authrtUrlList.size(); ++i) {
                String urlAddr = (String)authrtUrlList.get(i).get("urlAddr");

                // List를 검색이 빠른 Map으로 변환
                if (urlAddr != null && !authrtUrlMap.containsKey(urlAddr)) {
                    authrtUrlMap.put(urlAddr, authrtUrlList.get(i));
                }
            }
        }

        return authrtUrlMap;
    }


    /**
     * 권한에 대한 메뉴(json구조) 조회 (Local cache 처리 전제로 구현됨)
     * 화면단에서 다중 처리하는 로직
     * @param authrtId
     * @return
     * @throws Exception
     */
    @Cacheable(cacheNames = "authrtMenuCache", key = "#authrtId")
    public String getMenuJsonList(String authrtId) throws SQLException, NullPointerException  {

        Map<String, Object> requestMap = new HashMap<String, Object>();
        requestMap.put("authrtId", authrtId);
        requestMap.put("siteClsfCd", systemType);

        String menuJson = sessionMapper.selectMenuJson(requestMap);

        if (menuJson == null) {
            throw new NullPointerException("Menu JSON 데이터가 null입니다.");
        }

        return menuJson;
    }

    /**
     * url 접속이력 저장
     * @param requestMap
     * @return
     * @throws Exception
     */
    public int insertUrlCntnHstry(Map <String, Object> requestMap) throws SQLException, IllegalArgumentException {
    	return sessionMapper.insertUrlCntnHstry(requestMap);
    }
}
