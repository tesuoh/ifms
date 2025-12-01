package ifms.adm.cdm.ccm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.cdm.ccm.mapper.CmnCdMngMapper;

/**
 * 공통코드 분류 관리 Service
 * @author seryeong
 *
 */
@Service
public class CmnCdMngService {

	@Autowired
	CmnCdMngMapper cmnCdMngMapper;
	
	/**
	 * 공통코드 분류 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectCmnCdMngTotalCount(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.selectCmnCdMngTotalCount(requestMap);
	}
	
	/**
	 * 공통코드 분류 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCmnCdMngList(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.selectCmnCdMngList(requestMap);
	}
	
	/**
	 * 마지막 정렬 순서 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectLastSortSeq(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.selectLastSortSeq(requestMap);
	}
	
	/**
	 * 아이디 중복 확인
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public boolean duplicateId(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.duplicateId(requestMap);
	}
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int insertCmnCdMng(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.insertCmnCdMng(requestMap);
	}
	
	/**
	 * 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectCmnCdMngDetail(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.selectCmnCdMngDetail(requestMap);
	}

	/**
	 * 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int updateCmnCdMng(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.updateCmnCdMng(requestMap);
	}
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCmnCdMng(Map<String, Object> requestMap) throws Exception{
		return cmnCdMngMapper.deleteCmnCdMng(requestMap);
	}
	
}
