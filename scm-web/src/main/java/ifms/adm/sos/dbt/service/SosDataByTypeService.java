package ifms.adm.sos.dbt.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.sos.dbt.mapper.SosDataByTypeMapper;

/**
 * 유형별 데이터 조회
 * @author seryeong
 *
 */
@Service
public class SosDataByTypeService {

	@Autowired
	private SosDataByTypeMapper sosDataByTypeMapper;
	
	/**
	 * 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectDbtListTotalCount(Map<String, Object> requestMap) throws Exception{
		return sosDataByTypeMapper.selectDbtListTotalCount(requestMap);
	};
	
	/**
	 * 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectDbtList(Map<String, Object> requestMap) throws Exception{
		return sosDataByTypeMapper.selectDbtList(requestMap);
	}
}
