package ifms.adm.bbs.faq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.bbs.faq.mapper.AdmFaqMapper;

/**
 * FAQ 관리 Service
 * @author seryeong
 *
 */

@Service
public class AdmFaqService {

	@Autowired
	private AdmFaqMapper admFaqMapper;
	
	/**
	 * FAQ 전체 목록 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectFaqList(Map<String, Object> requestMap) throws Exception{
		return admFaqMapper.selectFaqList(requestMap);
	};
	
	/**
	 * FAQ 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int selectFaqListTotalCnt(Map<String, Object> requestMap) throws Exception{
		return admFaqMapper.selectFaqListTotalCnt(requestMap);
	}
	
	/**
	 * FAQ 분류 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectFaqCategory() throws Exception{
		return admFaqMapper.selectFaqCategory();
	};

	/**
	 * FAQ 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int insertFaq(Map<String, Object> requestMap) throws Exception{
		return admFaqMapper.insertFaq(requestMap);
		
	}
	
	/**
	 * FAQ 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int deleteFaq(Map<String, Object> requestMap) throws Exception{
		return admFaqMapper.deleteFaq(requestMap);
	}
	
	/**
	 * FAQ 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int updateFaq(Map<String, Object> requestMap) throws Exception{
		return admFaqMapper.updateFaq(requestMap);
	}

	/**
	 * FAQ 상세조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectFaqDetail(Map<String, Object> requestMap) throws Exception{
		return admFaqMapper.selectFaqDetail(requestMap);
	}
}
