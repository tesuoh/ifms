package ifms.adm.smc.i18n.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.core.i18n.mapper.i18nMapper;

/**
 * 다국어 메세지 관리
 * @author yangcheolseung
 * 
 */

@Service
public class CmnI18nMsgMngService {
	
	@Autowired
	private i18nMapper i18nMapper;
	
	/**
	 * 다국어 메세지 전체 목록 조회
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nMsgList(Map<String, Object> requestMap) throws Exception {
		return i18nMapper.selectI18nMsgList(requestMap);
	}
	
	/**
	 * 다국어 메세지 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public int selectI18nMsgListTotalCnt(Map<String, Object> requestMap) throws Exception {
		return i18nMapper.selectI18nMsgTotalCnt(requestMap);
	}
	
	/**
	 * 다국어 메세지 타입유형 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nTypCd() throws Exception {
		return i18nMapper.selectI18nTypCd();
	}
	
	/**
	 * 다국어 메세지 사업유형 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nBisCd() throws Exception {
		return i18nMapper.selectI18nBisCd();
	}
	
	/**
	 * 다국어 메세지 언어구분 조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public List<Map<String, Object>> selectI18nLocCd() throws Exception {
		return i18nMapper.selectI18nLocCd();
	}
	
	/**
	 * 다국어 메세지 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public int insertI18nMsg(Map<String, Object> requestMap) throws Exception {
		return i18nMapper.insertI18nMsg(requestMap);
	}
	
	/**
	 * 다국어 메세지 삭제
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public int deleteI18nMsg(Map<String, Object> requestMap) throws Exception {
		return i18nMapper.deleteI18nMsg(requestMap);
	}
	
	/**
	 * 다국어 메세지 수정
	 * @param
	 * @return
	 * @throws Exception
	 * 
	 */
	public int updateI18nMsg(Map<String, Object> requestMap) throws Exception {
		return i18nMapper.updateI18nMsg(requestMap);
	}
	
	/**
	 * 다국어 메세지 상세조회
	 * @param requestMap
	 * @return
	 * @throws Exception
	 * 
	 */
	public Map<String, Object> selectI18nMsgDetail(Map<String, Object> requestMap) throws Exception {
		return i18nMapper.selectI18nMsgDetail(requestMap);
	}
}
