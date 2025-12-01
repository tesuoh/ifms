package ifms.adm.lnk.mng.mapper;

import java.util.List;
import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 연계 관리 Mapper
 * @author ohsejun
 *
 */
@Mapper
public interface LnkMngMapper {
	
	/**
	 * 기관별데이터연계현황 연계기관, 연계명 selectBox 불러오기
	 * @return
	 * @throws Exception
	 */
	List<Map<String, String>> selectLnkHistInstAndNm() throws Exception;
	
	/**
	 * 기관별데이터연계현황 총개수 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectLnkHistListCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 기관별데이터연계현황 목록조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLnkHistList(Map<String, Object> requestMap) throws Exception;
	/**
	 * 데이터 연계현황 총 건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	
	/**
	 * 데이터 연계통계 총 건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectLnkStatTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 데이터 연계통계 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLnkStatList(Map<String, Object> requestMap) throws Exception;

	/**
	 * 데이터 연계통계 연계기관목록조회
	 * @param 
	 * @return list String
	 * @throws Exception
	 */
	List<String> selectLnkInstList() throws Exception;

	
	
	/**
	 * 데이터 개방현황 총 건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	int selectLnkApiStaTotalCount(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 데이터 개방현황 목록 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectLnkApiStaList(Map<String, Object> requestMap) throws Exception;
	
	
	/**
	 * 개방 오퍼레이션 목록조회
	 * @return list
	 * @throws Exception
	 */
	List<String> selectOpnList() throws Exception;
	
}
