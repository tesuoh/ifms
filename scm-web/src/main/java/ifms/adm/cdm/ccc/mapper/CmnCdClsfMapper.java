package ifms.adm.cdm.ccc.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공통코드 분류 관리 Mapper
 * @author seryeong
 *
 */
@Mapper
public interface CmnCdClsfMapper {
	
	/**
	 * 공통코드 분류 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectCmnCdClsfTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공통코드 분류 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCmnCdClsfList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공통코드 분류 상세 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectCmnCdClsfDetail(Map<String, Object> requestMap) throws Exception;

	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertCmnCdClsf(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateCmnCdClsf(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteCmnCdClsf(Map<String, Object> requestMap) throws Exception;
}
