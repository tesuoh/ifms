package ifms.adm.bbs.qna.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * Qna 관리 Mapper
 * @author seryeong
 *
 */
@Mapper
public interface AdmQnaMapper {
	/**
	 * 질의 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAdmQnaList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 질의 목록 총건수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectQnaListTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * Qna 상세 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectQnaDetail(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 조회수 증가
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateInqCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 답변 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> qnaAnsCnInsert(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 질의 글 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteQstn(Map<String, Object> requestMap) throws Exception;
}
