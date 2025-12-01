package ifms.adm.smc.url.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ifms.adm.smc.url.mapper.CmnUrlPtUrlMngMMapper;

import java.util.List;
import java.util.Map;

@Service
public class CmnUrlPtUrlMngMService {

    @Autowired
    private CmnUrlPtUrlMngMMapper cmnUrlPtUrlMngMMapper;

    /**
     * URL관리 목록 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public int selectCmnUrlPtUrlMngListCnt(Map<String, Object> requestMap) throws Exception {
        return cmnUrlPtUrlMngMMapper.selectCmnUrlPtUrlMngListCnt(requestMap);
    }

    /**
     * URL관리 목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> selectCmnUrlPtUrlMngList(Map<String, Object> requestMap) throws Exception {
        return cmnUrlPtUrlMngMMapper.selectCmnUrlPtUrlMngList(requestMap);
    }

    /**
     * URL관리 상세 조회
     * @param paramMap
     * @return
     */
    public Map<String, Object> selectUrlMngDetail(Map<String, Object> paramMap) throws Exception{
        return cmnUrlPtUrlMngMMapper.selectUrlMngDetail(paramMap);
    }

    @Transactional
    public void updateCmnUrlPtUrlMngDetail(Map<String, Object> requestMap) throws Exception {
        if (requestMap == null || !requestMap.containsKey("urlAddr")) {
            throw new IllegalArgumentException("필수 데이터가 누락되었습니다: urlMngNo");
        }
        cmnUrlPtUrlMngMMapper.updateCmnUrlPtUrlMngDetail(requestMap);
    }

    public void deleteCmnUrlPtUrlMngDetail(Map<String, Object> requestMap) throws Exception{
        cmnUrlPtUrlMngMMapper.deleteCmnUrlPtUrlMngDetail(requestMap);
    }


    public int insertCmnUrlPtUrlMngDetail(Map<String, Object> requestMap) throws Exception{
        return cmnUrlPtUrlMngMMapper.insertUrlMngDetail(requestMap);
    }

    public boolean checkUrlExists(String urladdr) throws Exception{
        int count = cmnUrlPtUrlMngMMapper.checkUrlExists(urladdr);
        return count > 0; // 존재하면 true 반환
    }


}
