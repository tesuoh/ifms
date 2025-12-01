package ifms.adm.sos.sds.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 시스템 장애 관리
 * @author seryeong
 *
 */

@Mapper
public interface SysDsbltvSrMapper {

	/**
	 * 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int sysDsbltvSrTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> sysDsbltvSrList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> sysDsbltvSrDetail(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 처리 코멘트 작성
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> insertPrcsCn(Map<String, Object> requestMap) throws Exception;
	
	int updateInqCnt(Map<String, Object> requestMap) throws Exception;
	
	int deleteSysDsbltvPst(Map<String, Object> requestMap) throws Exception;
}
