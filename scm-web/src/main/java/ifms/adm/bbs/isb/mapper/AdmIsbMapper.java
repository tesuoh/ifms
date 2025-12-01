package ifms.adm.bbs.isb.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 정보공유게시판 관리
 * @author seryeong
 *
 */
@Mapper
public interface AdmIsbMapper {

	/**
	 * 정보공유게시글 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectIsbTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 정보공유게시글 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAdmIsbList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 게시글 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectIsbPstDetail(Map<String, Object> requestMap) throws Exception;
	int updateInqCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 댓글 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectIsbCmntList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 댓글 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectCmntTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 댓글 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteCmnt(Map<String, Object> requestMap) throws Exception;

	/**
	 * 게시글 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deletePst(Map<String, Object> requestMap) throws Exception;
	int deleteCmntInPst(Map<String, Object> requestMap) throws Exception;

	Map<String, Object> selectVideoFile(Map<String, Object> requestMap) throws Exception;
}
