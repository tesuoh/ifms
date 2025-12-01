package ifms.adm.smc.prg.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CmnPrgPtPrgrmMngMMapper {

    /**
     * 프로그램 관리 목록 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    int selectCmnPrgPtPrgrmMngListCnt(Map<String, Object> requestMap) throws Exception;

    /**
     * 프로그램 관리 목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectCmnPrgPtPrgrmMngList(Map<String, Object> requestMap) throws Exception;

    /**
     * 프로그램 관리 상세 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    Map<String, Object> selectCmnPrgPtPrgrmMngDtl(Map<String, Object> requestMap) throws Exception;

    List<Map<String, Object>> selectLinkedUrlsList(Map<String, Object> requestMap) throws Exception;

    int selectUrlListCount(Map<String, Object> requestMap) throws Exception;

    List<Map<String, Object>> selectUrlList(Map<String, Object> requestMap) throws Exception;

    Map<String, Object> selectUrlDetails(Map<String, Object> requestMap) throws Exception;

    void insertRprsProgram(Map<String, Object> requestMap) throws Exception;

    void insertConnectProgram(Map<String, Object> urlMap) throws Exception;

    int countConnectedProgramByUrlMngNo(Map<String, Object> urlMap) throws Exception;

    void updateConnectProgram(Map<String, Object> urlMap) throws Exception;

    void updateRprsUrlMng(Map<String, Object> urlMap) throws Exception;

    void insertRprsPrgrmMng(Map<String, Object> ptUrlMngMap) throws Exception;

    /**
     * 대표프로그램 중복확인용 카운트
     * @param requestMap
     * @return
     * @throws Exception
     */
    int countRprsPrgrmMngByUrl(Map<String, Object> requestMap) throws Exception;

    void updateRprsPrgrmMng(Map<String, Object> ptUrlMngMap) throws Exception;
}
