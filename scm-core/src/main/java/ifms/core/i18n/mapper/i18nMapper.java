package ifms.core.i18n.mapper;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import java.util.List;
import java.util.Map;

@Mapper
public interface i18nMapper {
	
	/**
	 * 다국어 메세지 조회
	 * @return
	 * @throws Exception
	 * 
	 */
	
	String getMessage(@Param("code") String code, @Param("locale") String locale);
	
	/**
	 * 다국어 메세지 조회
	 * @return
	 * @throws Exception
	 * 
	 */
	
	String getTooltip(@Param("code") String code, @Param("locale") String locale);
	
	/**
	 * 다국어 메세지 조회
	 * @return
	 * @throws Exception
	 * 
	 */
	List<Map<String, Object>> selectI18nMsgList(Map<String,Object> requestMap) throws Exception;
	
	
	/**
	 * 다국어 메세지 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	int selectI18nMsgTotalCnt(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 다국어 메세지 타입유형 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	List<Map<String, Object>> selectI18nTypCd() throws Exception; 
	
	/**
	 * 다국어 메세지 사업유형 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	List<Map<String, Object>> selectI18nBisCd() throws Exception;
	
	/**
	 * 다국어 메세지 언어구분 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	List<Map<String, Object>> selectI18nLocCd() throws Exception;
	
	/**
	 * 다국어 메세지 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	int insertI18nMsg(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 다국어 메세지 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	int deleteI18nMsg(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 다국어 메세지 수정
	 * @param
	 * @return
	 * @throws Exception
	 * 
	 */
	int updateI18nMsg(Map<String, Object> requestMap) throws Exception;
	
	/**
	 * 다국어 메세지 상세조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	Map<String, Object> selectI18nMsgDetail(Map<String, Object> requestMap) throws Exception;
	
}