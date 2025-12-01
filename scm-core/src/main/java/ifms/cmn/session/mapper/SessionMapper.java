package ifms.cmn.session.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.springframework.dao.DataAccessException;
import ifms.core.security.vo.AccessibleUrl;
import ifms.core.security.vo.ClientVO;
import ifms.core.security.vo.SessionVO;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Mapper
public interface SessionMapper {

    /**
     * 사용자정보 조회
     * @param requestMap
     * @return
     */
    SessionVO findBy(Map<String, Object> requestMap);

    /**
     * 사용자 역할 조회
     * @param username
     * @return
     */
    List<String> findRolesByUsername(String username);

    /**
     * 사용자 권한 조회
     * @param username
     * @return
     */
    List<String> findPermissionsByUsername(String username);

    /**
     * 사용자 접속 URL 조회
     * @param username
     * @return
     * @throws DataAccessException
     */
    List<AccessibleUrl> findUrlsByUserId(String username) throws DataAccessException;

    /**
     * 현재사용자 세션정보 - userId에 대한 사용자정보
     * @param userParamMap
     * @return
     * @throws Exception
     */
    Map<String, Object> selectMainUserMap(Map<String, Object> userParamMap) throws DataAccessException;

    /**
     * 현재사용자의 세션정보 - ifmsId에 대한 사용자정보
     * @param paramMap
     * @return
     */
    Map<String, Object> selectUserMap(Map<String, Object> paramMap);

    /**
     * 세션사용자의 역할목록 - sessionMap의 권한이 부여된 역할목록
     * @param paramMap
     * @return
     */
    List<Map<String, Object>> selectRoleList(Map<String, Object> paramMap);

    /**
     * 세션사용자의 메뉴목록 - sessionMap의 권한이 부여된 메뉴목록
     * @param username
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectMenuList(Map<String, Object> requestMap) throws DataAccessException;

    /**
     * 사이트 권한별 메뉴를 json으로 조회
     * @param requestMap { authrtId, siteClsfCd }
     * @return menu json string
     */
    String selectMenuJson(Map<String, Object> requestMap) throws DataAccessException;

    /**
     * 권한에 대한 접근가능한 URL 조회 (수정권한없는 경우 수정 URL 제외됨)
     * @param requestMap
     * @return
     * @throws DataAccessException
     */
    List<Map<String, Object>> selectAuthrtUrlList(String authrtId) throws DataAccessException;

    /**
     * 로그인실패 횟수 증가
     * @param username
     * @return
     * @throws Exception
     */
    int updateLgnFailureCountInc(String username) throws Exception;

    /**
     * 로그인 계정 사용자 실패 횟수 조회
     * @param username
     * @return
     * @throws Exception
     */
    Map<String, Object> selectLgnFailureCount(String username) throws RuntimeException;

    /**
     * 최초 로그인 실패 5회이상이면 로그인실패 잠금처리
     * @param username
     * @throws Exception
     */
    void updateLgnFailLckYn(String username) throws Exception;

    /**
     * 사용자 접속정보 저장
     * @param vo
     * @return
     * @throws RuntimeException
     */
    int insertClientDtl(ClientVO vo) throws RuntimeException;

    /**
     * 로그인 성공시 최종 로그인 일자 갱신
     * @param vo
     * @return
     * @throws RuntimeException
     */
    int updateResultLastLgnYmd(ClientVO vo) throws RuntimeException;

    /**
     * 로그인 성공시 로그인 실패 횟수 초기화
     * @param vo
     * @return
     * @throws RuntimeException
     */
    int updateInitLgnFailLckYn(ClientVO vo) throws RuntimeException;

    /**
     * url 접속이력 저장
     * @param requestMap
     * @return
     * @throws Exception
     */
    int insertUrlCntnHstry(Map<String, Object> requestMap) throws SQLException, IllegalArgumentException;
}
