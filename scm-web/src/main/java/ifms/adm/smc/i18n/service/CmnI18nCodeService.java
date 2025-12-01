package ifms.adm.smc.i18n.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.smc.i18n.mapper.CmnI18nCodeMapper;

/**
 * 다국어 메세지 관리
 * @author yangcheolseung
 * 
 */

@Service
public class CmnI18nCodeService {
	
	@Autowired
	private CmnI18nCodeMapper codeMapper;
	
	/**
	 * 다국어 메세지 타입유형 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nTypCd() throws Exception {
		return codeMapper.selectI18nTypCd();
	}
	
	/**
	 * 다국어 메세지 사업유형 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nBisCd() throws Exception {
		return codeMapper.selectI18nBisCd();
	}
	
	/**
	 * 다국어 메세지 언어구분 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nLocCd() throws Exception {
		return codeMapper.selectI18nLocCd();
	}
}
