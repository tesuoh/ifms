package ifms.adm.cdm.ccm.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공통코드 분류 관리 Mapper
 * @author seryeong
 *
 */
@Mapper
public interface CmnCdMngMapper {
	
	/**
	 * 공통코드 분류 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectCmnCdMngTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공통코드 분류 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCmnCdMngList(Map<String, Object> requestMap) throws Exception;

	/**
	 * 마지막 정렬 순서 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectLastSortSeq(Map<String, Object> requestMap) throws Exception;
	
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertCmnCdMng(Map<String, Object> requestMap) throws Exception;
	

	/**
	 * 아이디 중복 확인
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	boolean duplicateId(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectCmnCdMngDetail(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateCmnCdMng(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteCmnCdMng(Map<String, Object> requestMap) throws Exception;
}
