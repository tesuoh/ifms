package ifms.adm.smc.ath.mapper;

import org.apache.ibatis.annotations.Param;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CmnAthPtAuthrtInfoMMapper {

    /**
     * 권한관리 목록 총건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    int selectCmnAthPtAuthrtInfoListCnt(Map<String, Object> requestMap) throws Exception;

    /**
     * 권한관리 목록조회
     * @param requestMap
     * @return
     */
    List<Map<String, Object>> selectCmnAthPtAuthrtInfoList(Map<String, Object> requestMap) throws Exception;

    /**
     * 권한관리 상세 조회
     * @param paramMap
     * @return
     * @throws Exception
     */
    Map<String, Object> selectAuthrtInfoDetail(Map<String, Object> paramMap) throws Exception;

    /**
     * 프로그램 목록 조회
     * @param paramMap
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectPrgAuthrtList(Map<String, Object> paramMap) throws Exception;

    /**
     * 권한관리 상세 권한 정보 업데이트
     * @param requestMap
     * @throws Exception
     */
    void updateAuthrtInfoDetail(Map<String, Object> requestMap) throws Exception;

    /**
     * 권한관리 상세 프로그램 권한 정보 업데이트
     * @param requestMap
     * @throws Exception
     */
    void updatePrgAuthrtInfoDetail(Map<String, Object> requestMap) throws Exception;

    void insertPrgAuthrtInfoNewDetail(Map<String, Object> requestMap) throws Exception;

    void deletePrgAuthrtInfoDetail(Map<String, Object> requestMap) throws Exception;

    /**
     * 권한 신규 등록
     * @param requestMap
     * @throws Exception
     */
    void insertAuthrtInfoDetail(Map<String, Object> requestMap) throws Exception;

    /**
     * 권한 신규 등록 프로그램 권한 정보 삽입
     * @param prgAuthrt
     * @throws Exception
     */
    void insertPrgAuthrtInfoDetail(Map<String, Object> prgAuthrt) throws Exception;

    /**
     * 새로운 authrt_mng_no 생성
     * @param prefix
     * @return
     * @throws Exception
     */
    String getMaxAuthrtMngNo(@Param("prefix") String prefix) throws Exception;

    int checkPrgAuthrtInfo(Map<String, Object> prgAuthrt) throws Exception;

}
