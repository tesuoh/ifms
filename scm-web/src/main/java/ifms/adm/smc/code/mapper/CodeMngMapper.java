package ifms.adm.smc.code.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import ifms.adm.smc.code.vo.CodeDtlMngVO;
import ifms.adm.smc.code.vo.CodeMngVO;

@Mapper
public interface CodeMngMapper {
	
	/**
	 * 공통코드 목록 조회
	 * @param requestMap
	 * @return 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCodeList(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 공통코드 목록 건수 조회
	 * @param requestMap
	 * @return int
	 * @throws Exception
	 */
	int selectCodeListTotCnt(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 공통코드 중복조회
	 * @param CodeMngVO
	 * @return 
	 * @throws Exception
	 */
	int selectExistCode(CodeMngVO codeMngVO) throws Exception;
	
	/**
	 * 공통코드 등록
	 * @param CodeMngVO
	 * @return
	 * @throws Exception
	 */
	int insertCodeMng(CodeMngVO codeMngVO) throws Exception;

	/**
	 * 공통코드 다국어 등록 (KO, EN, ZH)
	 * @param CodeMngVO
	 * @return
	 * @throws Exception
	 */
	int insertCodeMngMlng(CodeMngVO codeMngVO) throws Exception;
	
	/**
	 * 공통코드 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCodeDetail(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 공통코드 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteCodeDetail(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 공통코드 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateCodeDetail(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 상세코드 목록 조회
	 * @param requestMap
	 * @return 
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCodeDtlList(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 상세코드 목록 건수 조회
	 * @param requestMap
	 * @return int
	 * @throws Exception
	 */
	int selectCodeDtlListTotCnt(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 상세코드 중복조회
	 * @param CodeDtlMngVO
	 * @return 
	 * @throws Exception
	 */
	int selectExistCodeDtl(CodeDtlMngVO codeDtlMngVO) throws Exception;
	
	/**
	 * 상세코드 등록
	 * @param CodeDtlMngVO
	 * @return
	 * @throws Exception
	 */
	int insertCodeDtlMng(CodeDtlMngVO codeDtlMngVO) throws Exception;

	/**
	 * 상세코드 다국어 등록 (KO, EN, ZH)
	 * @param CodeDtlMngVO
	 * @return
	 * @throws Exception
	 */
	int insertCodeDtlMngMlng(CodeDtlMngVO codeDtlMngVO) throws Exception;
	
	/**
	 * 상세코드 상세조회
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	List<Map<String, Object>> selectCodeDtlDetail(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 상세코드 삭제
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int deleteCodeDtlDetail(Map<String, Object> paramMap) throws Exception;
	
	/**
	 * 상세코드 수정
	 * @param paramMap
	 * @return
	 * @throws Exception
	 */
	int updateCodeDtlDetail(Map<String, Object> paramMap) throws Exception;
}
