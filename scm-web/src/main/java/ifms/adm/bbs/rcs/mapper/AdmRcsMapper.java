package ifms.adm.bbs.rcs.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 자료실 관리 
 * @author seryeong
 *
 */

@Mapper
public interface AdmRcsMapper {

	/**
	 * 자료실 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectRcsTotalCount (Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 자료실 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAdmRcsList (Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 자료실 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertRcs(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 상세 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectRcsDetail(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 조회수 증가
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateInqCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 자료실 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteRcs(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 자료실 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateRcs(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 동영상 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectVideoFile(Map<String, Object> requestMap) throws Exception;
}
