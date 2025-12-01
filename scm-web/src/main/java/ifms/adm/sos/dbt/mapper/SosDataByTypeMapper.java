package ifms.adm.sos.dbt.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
/**
 * 유형별 데이터 조회
 * @author seryeong
 *
 */
@Mapper
public interface SosDataByTypeMapper {

	/**
	 * 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectDbtListTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectDbtList(Map<String, Object> requestMap) throws Exception;
}
