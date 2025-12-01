package ifms.adm.sos.uah.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CmnUahPtUsrAcsHstMapper {

    /**
     * 사용자접속이력관리 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    int selectCmnUahPtUsrAcsHstListCnt(Map<String, Object> requestMap) throws Exception;

    /**
     * 사용자접속이력관리 목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectCmnUahPtUsrAcsHstList(Map<String, Object> requestMap) throws Exception;
}
