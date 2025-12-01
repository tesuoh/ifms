package ifms.adm.bbs.pop.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 공지 팝업 관리 Mapper
 * @author seryeong
 *
 */
@Mapper
public interface AdmNtcPopMapper {

	/**
	 * 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectPopListTotalCount(Map<String, Object> requestMap) throws Exception;

	/**
	 * 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectPopList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertPop(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 상세
	 * @param popupSn
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectPopDetail(String popupSn) throws Exception;
	
	/**
	 * 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deletePop(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 파일 삭제를 위한 파일 정보 가져오기
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> getFileInfo(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updatePop(Map<String, Object> requestMap) throws Exception;
}
