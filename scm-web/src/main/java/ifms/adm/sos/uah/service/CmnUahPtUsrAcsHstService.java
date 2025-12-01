package ifms.adm.sos.uah.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ifms.adm.sos.uah.mapper.CmnUahPtUsrAcsHstMapper;

import java.util.List;
import java.util.Map;

@Service
public class CmnUahPtUsrAcsHstService {
    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private CmnUahPtUsrAcsHstMapper cmnUahPtUsrAcsHstMapper;


    /**
     * 사용자접속이력관리 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public int selectCmnUahPtUsrAcsHstListCnt(Map<String, Object> requestMap) throws Exception {
        return cmnUahPtUsrAcsHstMapper.selectCmnUahPtUsrAcsHstListCnt(requestMap);
    }

    /**
     * 사용자접속이력관리 목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> selectCmnUahPtUsrAcsHstList(Map<String, Object> requestMap) throws Exception {
        return cmnUahPtUsrAcsHstMapper.selectCmnUahPtUsrAcsHstList(requestMap);
    }
}
