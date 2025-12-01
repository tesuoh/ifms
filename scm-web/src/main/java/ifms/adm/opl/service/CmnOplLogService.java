package ifms.adm.opl.service;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.adm.opl.mapper.CmnOplLogMapper;

@Service
public class CmnOplLogService {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private CmnOplLogMapper cmnOplLogMapper;

    /**
     * 사용자일일작업현황 목록 조회
     * @param requestMap
     * @throws Exception
     */
    public List<Map<String, Object>> selectCmnUahPtUsrAcsHstList(Map<String, Object> requestMap) throws Exception{
    	return cmnOplLogMapper.selectCmnUahPtUsrAcsHstList(requestMap);
    }

}
