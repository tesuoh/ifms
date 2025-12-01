package ifms.adm.cdm.fcm.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공통코드 분류 관리 Mapper
 * @author seryeong
 *
 */
@Mapper
public interface FcltyCdMngMapper {
	
	/**
	 * 시설물코드 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectFcltyCdMngTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 시설물코드 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectFcltyCdMngList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 시설물코드 분류 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectFcltyCdClsfList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 코드 중복 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectFcltyCdCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertFcltyCdMng(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 코드 삭제가능여부 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	String selectFcltyCdDelYn(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 첨부파일 삭제를 위한 정보 가져오기(리스트)
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> getFileInfoList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteFcltyCdMng(Map<String, Object> requestMap) throws Exception;
}
