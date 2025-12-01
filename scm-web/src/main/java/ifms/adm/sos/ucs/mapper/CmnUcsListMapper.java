package ifms.adm.sos.ucs.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

@Mapper
public interface CmnUcsListMapper {
	
    /**
     * 사용자일일작업현황 목록 조회
     * @param requestMap
     * @throws Exception
     */
	List<Map<String, Object>> selectUcsList(Map<String, Object> requestMap) throws Exception;
}
