package ifms.adm.smc.usr.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
/**
 * 사용자 관리
 * @author seryeong
 *
 */
@Mapper
public interface CmnUsrMngMapper {

	/**
	 * 사용자 관리 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int usrMngTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 기관 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int instTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용자 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectUsrMngList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용자 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectUsrMngDetail(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용자 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertUsrInfo(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용자 정보 변경
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateOthers(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 비밀번호 변경
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updatePswd(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 기관 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectInstList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용자 ID 중복 확인
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	boolean validDuplicatedId(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용 권한 그룹 정보 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAuthrtInfo() throws Exception;
	
	/**
	 * 변경이력 테이블에 삽입
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertUserChgHistory(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 비밀번호 오류 초기화
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	int resetUserPswd(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 사용자 사용정지
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	int suspendedUser(Map<String, Object> requestMap) throws Exception;
}
