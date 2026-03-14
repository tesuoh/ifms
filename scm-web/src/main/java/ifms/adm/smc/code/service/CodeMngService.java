package ifms.adm.smc.code.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

import ifms.adm.smc.code.mapper.CodeMngMapper;
import ifms.adm.smc.code.vo.CodeMngVO;
import ifms.cmn.session.hlp.IfmsUserDetailsHelper;
import ifms.core.security.vo.SessionVO;


@Service
public class CodeMngService  {
	
	@Autowired 
	CodeMngMapper codeMngMapper;
	
	@Autowired
	private CodeMngService self;
	
	@Resource(name="messageSource")
	MessageSource messageSource;
	
	/**
	 * 공통코드 목록 조회
	 * @param requestMap
	 * @return 
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCodeList(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.selectCodeList(paramMap);
	}
	
	/**
	 * 공통코드 목록 건수 조회
	 * @param requestMap
	 * @return int
	 * @throws Exception
	 */
	public int selectCodeListTotCnt(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.selectCodeListTotCnt(paramMap);
	}
	
	/**
	 * 공통코드 중복조회
	 * @param CodeMngVO
	 * @return 
	 * @throws Exception
	 */
	public int selectExistCode(CodeMngVO codeMngVO) throws Exception {
		return codeMngMapper.selectExistCode(codeMngVO);
	}
	
	/**
	 * 공통코드 등록
	 * @param CodeMngVO
	 * @return
	 * @throws Exception
	 */
	public int insertCodeMng(CodeMngVO codeMngVO) throws Exception {
		return codeMngMapper.insertCodeMng(codeMngVO);
	}
	
	/**
	 * 공통코드 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCodeDetail(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.selectCodeDetail(paramMap);
	}
	
	/**
	 * 공통코드 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCodeDetail(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.deleteCodeDetail(paramMap);
	}
	
	/**
	 * 공통코드 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int editCodeDetail(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.updateCodeDetail(paramMap);
	}
	
	/**
	 * 상세코드 목록 조회
	 * @param requestMap
	 * @return 
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCodeDtlList(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.selectCodeDtlList(paramMap);
	}
	
	/**
	 * 상세코드 목록 건수 조회
	 * @param requestMap
	 * @return int
	 * @throws Exception
	 */
	public int selectCodeDtlListTotCnt(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.selectCodeListTotCnt(paramMap);
	}
	
	/**
	 * 상세코드 중복조회
	 * @param CodeMngVO
	 * @return 
	 * @throws Exception
	 */
	public int selectExistCodeDtl(CodeMngVO codeMngVO) throws Exception {
		return codeMngMapper.selectExistCodeDtl(codeMngVO);
	}
	
	/**
	 * 상세코드 등록
	 * @param CodeMngVO
	 * @return
	 * @throws Exception
	 */
	public int insertCodeDtlMng(CodeMngVO codeMngVO) throws Exception {
		return codeMngMapper.insertCodeDtlMng(codeMngVO);
	}
	
	/**
	 * 상세코드 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectCodeDtlDetail(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.selectCodeDtlDetail(paramMap);
	}
	
	/**
	 * 상세코드 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int deleteCodeDtlDetail(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.deleteCodeDtlDetail(paramMap);
	}
	
	/**
	 * 상세코드 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	public int editCodeDtlDetail(Map<String, Object> paramMap) throws Exception {
		return codeMngMapper.updateCodeDtlDetail(paramMap);
	}
}
