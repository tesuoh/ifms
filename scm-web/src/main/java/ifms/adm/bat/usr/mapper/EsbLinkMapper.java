package ifms.adm.bat.usr.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * ESB Link 모니터링 Mapper
 * @author system
 */
@Mapper
public interface EsbLinkMapper {
	
	/**
	 * ESB Link 테이블에서 성공 상태인 새로운 레코드 조회
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectNewEsbLinkRecords() throws Exception;
	
	/**
	 * if_tb_scm_user_all 인터페이스 테이블에서 동기화할 사용자 데이터 조회
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectUserAllForSync() throws Exception;
	
	/**
	 * tb_scm_user에 사용자 데이터 삽입
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertScmUser(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * tb_scm_user에 사용자 ID 존재 여부 확인
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	boolean existsScmUser(String userId) throws Exception;
	
	/**
	 * tb_scm_user에 사용자 데이터 업데이트
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateScmUser(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * tb_scm_user_parco에 사용자 데이터 삽입
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertScmUserParco(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * tb_scm_user_parco에 사용자 ID 존재 여부 확인
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	boolean existsScmUserParco(String userId) throws Exception;
	
	/**
	 * tb_scm_user_parco에 사용자 데이터 업데이트
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateScmUserParco(Map<String, Object> requestMap) throws Exception;
}

