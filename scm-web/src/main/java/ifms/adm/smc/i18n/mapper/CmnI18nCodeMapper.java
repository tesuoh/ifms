package ifms.adm.smc.i18n.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

/**
 * 다국어 메세지 아이디 관리 Mapper
 * @author yangcheolseung
 * 
 */
@Mapper
public interface CmnI18nCodeMapper {
	
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

}
