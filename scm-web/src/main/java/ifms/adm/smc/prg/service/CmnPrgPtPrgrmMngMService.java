package ifms.adm.smc.prg.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ifms.adm.smc.prg.mapper.CmnPrgPtPrgrmMngMMapper;
import ifms.adm.smc.prg.web.CmnPrgPtPrgrmMngMController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
public class CmnPrgPtPrgrmMngMService {

    @Autowired
    private CmnPrgPtPrgrmMngMMapper cmnPrgPtPrgrmMngMMapper;


    /**
     * 프로그램관리 화면 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public int selectCmnPrgPtPrgrmMngListCnt(Map<String, Object> requestMap) throws Exception {
        return cmnPrgPtPrgrmMngMMapper.selectCmnPrgPtPrgrmMngListCnt(requestMap);
    }

    /**
     * 프로그램관리 목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> selectCmnPrgPtPrgrmMngList(Map<String, Object> requestMap) throws Exception {
        return cmnPrgPtPrgrmMngMMapper.selectCmnPrgPtPrgrmMngList(requestMap);
    }

    /**
     * 프로그램관리 상세 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public Map<String, Object> selectCmnPrgPtPrgrmMngDtl(Map<String, Object> requestMap) throws Exception {
        Map<String, Object> detail = cmnPrgPtPrgrmMngMMapper.selectCmnPrgPtPrgrmMngDtl(requestMap);
        List<Map<String, Object>> linkedUrls = cmnPrgPtPrgrmMngMMapper.selectLinkedUrlsList(requestMap);
        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("detail", detail);
        resultMap.put("linkedUrls", linkedUrls);

        return resultMap;
    }

    public int selectUrlListCount(Map<String, Object> requestMap) throws Exception {
        return cmnPrgPtPrgrmMngMMapper.selectUrlListCount(requestMap);
    }

    public List<Map<String, Object>> selectUrlList(Map<String, Object> requestMap) throws Exception {
        return cmnPrgPtPrgrmMngMMapper.selectUrlList(requestMap);
    }

    public Map<String, Object> getUrlDetails(Map<String, Object> requestMap) throws Exception {
        Map<String, Object> urlDetails = cmnPrgPtPrgrmMngMMapper.selectUrlDetails(requestMap);
        return urlDetails;
    }

    @Transactional
    public void insertProgram(Map<String, Object> requestMap) throws Exception {
        // 대표 URL 저장
        String rprsUrl = (String) requestMap.get("rprsUrl");
        if (rprsUrl == null) {
            throw new IllegalArgumentException("대표 URL 정보가 누락되었습니다.");
        }

        String updatePrg = (String) requestMap.get("updatePrg");


        Map<String, Object> ptUrlMngMap = new HashMap<>();
        ptUrlMngMap.put("rprsUrl", rprsUrl);
        ptUrlMngMap.put("siteClsfCd", (String) requestMap.get("siteClsfCd"));
        ptUrlMngMap.put("lastMdfrId", (String) requestMap.get("lastMdfrId"));

        if (Objects.equals(updatePrg, "Y")) {
            cmnPrgPtPrgrmMngMMapper.updateRprsPrgrmMng(ptUrlMngMap);

        } else {
            // 중복 체크
            int existingCount = cmnPrgPtPrgrmMngMMapper.countRprsPrgrmMngByUrl(requestMap);
            if (existingCount > 0) {
                throw new CmnPrgPtPrgrmMngMController.DuplicateUrlException("이미 등록된 대표 URL 입니다.");
            }
            cmnPrgPtPrgrmMngMMapper.insertRprsPrgrmMng(ptUrlMngMap);
        }

        List<Map<String, Object>> connectedUrls = (List<Map<String, Object>>) requestMap.get("connectedUrls");
        if (connectedUrls != null) {
            for (Map<String, Object> urlMap : connectedUrls) {
                String connectedUrlAddr = (String) urlMap.get("urlAddr");
                if (connectedUrlAddr == null || connectedUrlAddr.isEmpty()) {
                    throw new IllegalArgumentException("연결된 URL이 누락되었습니다.");
                }
                urlMap.put("rprsUrlAddr" , rprsUrl);
                urlMap.put("urlAddr" , connectedUrlAddr);
                urlMap.put("frstRgtrId" , requestMap.get("frstRgtrId"));
                urlMap.put("lastMdfrId" , requestMap.get("lastMdfrId"));

                if (rprsUrl.equals(connectedUrlAddr) ) {
                    urlMap.put("rprsPrgrmYn", "Y");
                } else {
                    urlMap.put("rprsPrgrmYn", "N");
                }

                cmnPrgPtPrgrmMngMMapper.updateRprsUrlMng(urlMap);

                int count = cmnPrgPtPrgrmMngMMapper.countConnectedProgramByUrlMngNo(urlMap);

                if (count > 0 ) {
                    cmnPrgPtPrgrmMngMMapper.updateConnectProgram(urlMap);
                } else {
                    cmnPrgPtPrgrmMngMMapper.insertConnectProgram(urlMap);
                }

            }
        }
    }
}


