package ifms.adm.sos.sds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.sos.sds.mapper.SysDsbltvSrMapper;

/**
 * 시스템 장애 관리
 * @author seryeong
 *
 */

@Service
public class SysDsbltvService {

	@Autowired
	SysDsbltvSrMapper sysDsbltvSrMapper;
	
	/**
	 * 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int sysDsbltvSrTotalCount(Map<String, Object> requestMap) throws Exception{
		return sysDsbltvSrMapper.sysDsbltvSrTotalCount(requestMap);
	}
	
	/**
	 * 시스템 장애 신고 목록조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> sysDsbltvSrList(Map<String, Object> requestMap) throws Exception{
		return sysDsbltvSrMapper.sysDsbltvSrList(requestMap);
	}
	
	/**
	 * 시스템 장애 신고 상세조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> sysDsbltvSrDetail(Map<String, Object> requestMap) throws Exception{
		sysDsbltvSrMapper.updateInqCnt(requestMap);
		
		return sysDsbltvSrMapper.sysDsbltvSrDetail(requestMap);
	}
	
	/**
	 * 시스템 장애 신고 코멘트 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> insertPrcsCn(Map<String, Object> requestMap) throws Exception{
		return sysDsbltvSrMapper.insertPrcsCn(requestMap);
	}
	
	/**
	 * 시스템 장애 신고 게시글 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteSysDsbltvPst(Map<String, Object> requestMap) throws Exception{
		return sysDsbltvSrMapper.deleteSysDsbltvPst(requestMap);
	}
}
