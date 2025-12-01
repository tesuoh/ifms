package ifms.adm.bbs.faq.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;


/**
 * FAQ 관리 Mapper
 * @author seryeong
 *
 */
@Mapper
public interface AdmFaqMapper {

	/**
	 * FAQ 목록 조회
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectFaqList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * FAQ 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectFaqListTotalCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * FAQ 카테고리 조회
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectFaqCategory() throws Exception;
	
	/**
	 * FAQ 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertFaq(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * FAQ 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteFaq(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * FAQ 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateFaq(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * FAQ 상세조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectFaqDetail(Map<String, Object> requestMap) throws Exception;
}
