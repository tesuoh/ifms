package ifms.adm.smc.url.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CmnUrlPtUrlMngMMapper {

    /**
     * URL관리 목록 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    int selectCmnUrlPtUrlMngListCnt(Map<String, Object> requestMap) throws Exception;

    /**
     * URL관리 목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectCmnUrlPtUrlMngList(Map<String, Object> requestMap) throws Exception;

    /**
     * URL관리 상세 조회
     * @param paramMap
     * @return
     * @throws Exception
     */
    Map<String, Object> selectUrlMngDetail(Map<String, Object> paramMap) throws Exception;

    void updateCmnUrlPtUrlMngDetail(Map<String, Object> requestMap) throws Exception;

    int insertUrlMngDetail(Map<String, Object> requestMap) throws Exception;

    int checkUrlExists(String urladdr) throws Exception;

    void deleteCmnUrlPtUrlMngDetail(Map<String, Object> requestMap) throws Exception;
}
