package ifms.adm.lnk.mng.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.lnk.mng.mapper.LnkMngMapper;

/**
 * 연계 관리 Service
 * @author ohsejun
 *
 */
@Service
public class LnkMngService {

	@Autowired
	LnkMngMapper lnkMngMapper;
	
	/**
	 * 기관별데이터연계현황 연계기관, 연계명 selectBox 불러오기
	 * @return list
	 */
	public List<Map<String, String>> selectLnkHistInstAndNm() throws Exception{
		return lnkMngMapper.selectLnkHistInstAndNm();
	}
	
	
	/**
	 * 데이터 연계 현황 목록 총개수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectLnkHistListTotalCount(Map<String, Object> requestMap) throws Exception{
		return lnkMngMapper.selectLnkHistListCount(requestMap);
	}
	
	/**
	 * 데이터 연계 현황 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectLnkHistList(Map<String, Object> requestMap) throws Exception{
		return lnkMngMapper.selectLnkHistList(requestMap);
	}
	
	
	/**
	 * 데이터 연계 통계 총개수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectLnkStatTotalCount(Map<String, Object> requestMap) throws Exception{
		return lnkMngMapper.selectLnkStatTotalCount(requestMap);
	}
	
	/**
	 * 데이터 연계 통계 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectLnkStatList(Map<String, Object> requestMap) throws Exception{
		return lnkMngMapper.selectLnkStatList(requestMap);
	}
	
	/**
	 * 데이터 연계통계 연계기관목록조회
	 * @param 
	 * @return list String
	 * @throws Exception
	 */
	public List<String> selectLnkInstList() throws Exception{
		return lnkMngMapper.selectLnkInstList();
	}
	
	/**
	 * 데이터 개방 현황 목록 총개수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectLnkApiStaTotalCount(Map<String, Object> requestMap) throws Exception{
		return lnkMngMapper.selectLnkApiStaTotalCount(requestMap);
	}
	
	/**
	 * 데이터 개방 현황 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectLnkApiStaList(Map<String, Object> requestMap) throws Exception{
		return lnkMngMapper.selectLnkApiStaList(requestMap);
	}
	
	/**
	 * 데이터개방현황 - 개방 오퍼레이션 목록조회
	 * @return
	 * @throws Exception
	 */
	public List<String> selectOpnList() throws Exception{
		return lnkMngMapper.selectOpnList();
	}
}
