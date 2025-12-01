package ifms.adm.smc.mnu.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import ifms.adm.smc.ath.mapper.CmnAthPtAuthrtInfoMMapper;
import ifms.adm.smc.mnu.mapper.CmnMnuPtMenuMngMMapper;
import ifms.core.security.service.AuthUser;

import java.util.List;
import java.util.Map;

@Service
public class CmnMnuPtMenuMngMService {

    @Autowired
    private CmnMnuPtMenuMngMMapper cmnMnuPtMenuMngMMapper;


    public int selectCmnMnuPtMenuMngListCnt(Map<String, Object> requestMap) throws Exception {
        return cmnMnuPtMenuMngMMapper.selectCmnMnuPtMenuMngListCnt(requestMap);
    }

    /**
     * 메뉴관리 목록조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> selectCmnMnuPtMenuMngList(Map<String, Object> requestMap) throws Exception{
        return cmnMnuPtMenuMngMMapper.selectCmnMnuPtMenuMngList(requestMap);
    }

    /**
     * 최상위 메뉴 추가
     * @param authUser
     * @param requestMap
     * @return
     * @throws Exception
     */
    public boolean insertTopLevelMenu(AuthUser authUser, Map<String, Object> requestMap) throws Exception{
        int insertResult = cmnMnuPtMenuMngMMapper.insertTopLevelMenu(requestMap);
        return insertResult > 0;
    }

    /**
     * 메뉴 삭제
     * @param authUser
     * @param requestMap
     * @return
     * @throws Exception
     */
    public boolean deleteMenuList(AuthUser authUser, Map<String, Object> requestMap) throws Exception{
        int deleteResult = cmnMnuPtMenuMngMMapper.deleteMenuList(requestMap);
        return deleteResult > 0; 
    }

    /**
     * 하위 메뉴 추가
     * @param authUser
     * @param requestMap
     * @return
     * @throws Exception
     */
    public boolean addSubMenu(AuthUser authUser, Map<String, Object> requestMap) throws Exception{
        int insertResult = cmnMnuPtMenuMngMMapper.addSubMenu(requestMap);
        return insertResult > 0;
    }

    /**
     * 프로그램목록 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public int selectPrgListCount(Map<String, Object> requestMap) throws Exception{
        return cmnMnuPtMenuMngMMapper.selectPrgListCount(requestMap);
    }

    /**
     * 프로그램목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> selectPrgList(Map<String, Object> requestMap) throws Exception{
        return cmnMnuPtMenuMngMMapper.selectPrgList(requestMap);
    }

    /**
     * 메뉴 및 연결 프로그램 수정
     * @param requestMap
     * @throws Exception
     */
    public void updatePrgMenuDtl(Map<String, Object> requestMap) throws Exception{
        cmnMnuPtMenuMngMMapper.updatePrgMenuDtl(requestMap);
        int resultCount = cmnMnuPtMenuMngMMapper.checkUrlMngDtl(requestMap);
        if(resultCount > 0) {
            cmnMnuPtMenuMngMMapper.updateUrlMngDtl(requestMap);
        } else {
            cmnMnuPtMenuMngMMapper.insertUrlMngDtl(requestMap);
        }
        //ifms.pt_authrt_prgrm_mpng_r update Insert 로직 필요

    }
}
