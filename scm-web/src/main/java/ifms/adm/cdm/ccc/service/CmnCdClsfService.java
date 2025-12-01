package ifms.adm.cdm.ccc.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.cdm.ccc.mapper.CmnCdClsfMapper;

/**
 * 공통코드 분류 관리 Service
 * @author seryeong
 *
 */
@Service
public class CmnCdClsfService {

	@Autowired
	CmnCdClsfMapper cmnCdClsfMapper;
	
	/**
	 * 공통코드 분류 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectCmnCdClsfTotalCount(Map<String, Object> requestMap) throws Exception{
		return cmnCdClsfMapper.selectCmnCdClsfTotalCount(requestMap);
	}
	
	/**
	 * 공통코드 분류 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCmnCdClsfList(Map<String, Object> requestMap) throws Exception{
		return cmnCdClsfMapper.selectCmnCdClsfList(requestMap);
	}
	
	/**
	 * 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectCmnCdClsfDetail(Map<String, Object> requestMap) throws Exception{
		return cmnCdClsfMapper.selectCmnCdClsfDetail(requestMap);
	}
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int insertCmnCdClsf(Map<String, Object> requestMap) throws Exception{
		return cmnCdClsfMapper.insertCmnCdClsf(requestMap);
	}
	
	/**
	 * 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int updateCmnCdClsf(Map<String, Object> requestMap) throws Exception{
		return cmnCdClsfMapper.updateCmnCdClsf(requestMap);
	}
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCmnCdClsf(Map<String, Object> requestMap) throws Exception{
		return cmnCdClsfMapper.deleteCmnCdClsf(requestMap);
	}
}
