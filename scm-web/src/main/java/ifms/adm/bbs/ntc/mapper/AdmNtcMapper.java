package ifms.adm.bbs.ntc.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface AdmNtcMapper {


	/**
	 * 공지사항 목록 총건수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectAdminNtcListCnt(Map<String,Object> requestMap) throws Exception;

	/**
	 * 공지사항 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectAdmNtcList(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공지사항 상세 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	Map<String, Object> selectAdminNtcDetail(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공지사항 조회수 증가
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int addNtcInqCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공지사항 수정
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int updateNtc(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 공지사항 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int insertNtc(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 신규 공지사항 일련번호 채번
	 * @return
	 * @throws Exception
	 */
	int selectNextNtcMttrSn() throws Exception;
	
	
	/**
	 * 공지사항 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int deleteNtc(Map<String, Object> requestMap) throws Exception;

}
