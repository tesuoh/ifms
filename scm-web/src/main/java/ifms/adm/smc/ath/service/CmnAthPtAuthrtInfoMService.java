package ifms.adm.smc.ath.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import ifms.adm.smc.ath.mapper.CmnAthPtAuthrtInfoMMapper;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

@Service
public class CmnAthPtAuthrtInfoMService {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    private CmnAthPtAuthrtInfoMMapper cmnAthPtAuthrtInfoMMapper;

    /**
     * 권한관리 목록 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    public int selectCmnAthPtAuthrtInfoListCnt(Map<String, Object> requestMap) throws Exception {
        return cmnAthPtAuthrtInfoMMapper.selectCmnAthPtAuthrtInfoListCnt(requestMap);
    }

    /**
     * 권한관리 목록 조회
     * @param requestMap
     * @return
     */
    public List<Map<String, Object>> selectCmnAthPtAuthrtInfoList(Map<String, Object> requestMap) throws Exception {
        return cmnAthPtAuthrtInfoMMapper.selectCmnAthPtAuthrtInfoList(requestMap);
    }

    /**
     * 권한관리 상세 조회
     * @param paramMap
     * @return
     * @throws Exception
     */
    public Map<String, Object> selectAuthrtInfoDetail(Map<String, Object> paramMap) throws Exception{
        return cmnAthPtAuthrtInfoMMapper.selectAuthrtInfoDetail(paramMap);
    }

    /**
     * 권한관리 프로그램 목록 조회
     * @param paramMap
     * @return
     * @throws Exception
     */
    public List<Map<String, Object>> selectPrgAuthrtList(Map<String, Object> paramMap) throws Exception{
        return cmnAthPtAuthrtInfoMMapper.selectPrgAuthrtList(paramMap);
    }

    /**
     * 권한관리 상세 수정
     * @param requestMap
     * @throws Exception
     */
    @Transactional
    public void updateAuthrtInfoDetail(Map<String, Object> requestMap) throws Exception{
        if (requestMap == null || !requestMap.containsKey("authrtId")) {
            throw new IllegalArgumentException("필수 데이터가 누락되었습니다: authrtId");
        }

        String authrtId = (String) requestMap.get("authrtId");
        List<Map<String, Object>> prgAuthrtList = (List<Map<String, Object>>) requestMap.get("prgAuthrtList");

        try {
            // 권한 정보 업데이트
            cmnAthPtAuthrtInfoMMapper.updateAuthrtInfoDetail(requestMap);

            // 프로그램 권한 정보 업데이트
            for (Map<String, Object> prgAuthrt : prgAuthrtList) {
                prgAuthrt.put("authrtId", authrtId);  // authrtId 추가
                prgAuthrt.put("lastMdfrId", (String) requestMap.get("lastMdfrId"));  // lastMdfrId 추가
                prgAuthrt.put("frstRgtrId", (String) requestMap.get("frstRgtrId"));  // lastMdfrId 추가


                int checkPrgAuthrtInfo = cmnAthPtAuthrtInfoMMapper.checkPrgAuthrtInfo(prgAuthrt);
                if (checkPrgAuthrtInfo > 0) {
                    // 존재하는 경우: update 또는 delete 로직 수행
                    if ("N".equals(prgAuthrt.get("viewAuthrtYn"))) {
                        cmnAthPtAuthrtInfoMMapper.deletePrgAuthrtInfoDetail(prgAuthrt);
                    } else {
                        cmnAthPtAuthrtInfoMMapper.updatePrgAuthrtInfoDetail(prgAuthrt);
                    }
                } else {
                    if("Y".equals(prgAuthrt.get("viewAuthrtYn"))) {
                        cmnAthPtAuthrtInfoMMapper.insertPrgAuthrtInfoNewDetail(prgAuthrt);
                    }
                }
            }

        } catch (SQLException e) {
            logger.error("권한 정보 업데이트 중 오류 발생: ", e);
            throw e; // 예외를 다시 던져 트랜잭션을 롤백하도록 함
        }

    }

    /**
     * 권한 신규 등록
     * @param requestMap
     * @return
     * @throws Exception
     */
    @Transactional
    public void  insertAuthrtInfoDetail(Map<String, Object> requestMap) throws Exception{
        if (requestMap == null || !requestMap.containsKey("siteClsfCd")) {
            throw new IllegalArgumentException("필수 데이터가 누락되었습니다: siteClsfCd");
        }

        String siteClsfCd  = (String) requestMap.get("siteClsfCd");
        String authrtCodePrefix;
        // siteClsfCd 값에 따라 authrtCodePrefix를 설정합니다.
        if ("SYS010".equals(siteClsfCd)) {
            authrtCodePrefix = "ROL_PTL";
        } else if ("SYS020".equals(siteClsfCd)) {
            authrtCodePrefix = "ROL_BIZ";
        } else if ("SYS030".equals(siteClsfCd)) {
            authrtCodePrefix = "ROL_ADM";
        } else {
            // 기본값 또는 예외 처리
            authrtCodePrefix = "ROL_DEF";
        }

        // 새로운 authrt_mng_no 생성
        String newAuthrtId = generateNextAuthrtMngNo(authrtCodePrefix);
        requestMap.put("authrtId", newAuthrtId);

        List<Map<String, Object>> prgAuthrtList = (List<Map<String, Object>>) requestMap.get("prgAuthrtList");

        try {
            // 권한 정보 삽입
            cmnAthPtAuthrtInfoMMapper.insertAuthrtInfoDetail(requestMap);

            // 프로그램 권한 정보 삽입
            if (prgAuthrtList != null) {
                for (Map<String, Object> prgAuthrt : prgAuthrtList) {
                    prgAuthrt.put("authrtId", newAuthrtId);  // authrtMngNo 추가
                    prgAuthrt.put("frstRgtrId", (String) requestMap.get("frstRgtrId"));  // frstRgtrId 추가
                    cmnAthPtAuthrtInfoMMapper.insertPrgAuthrtInfoDetail(prgAuthrt);
                }
            }

        } catch (SQLException e) {
            logger.error("권한 정보 등록 중 오류 발생: ", e);
            throw e; // 예외를 다시 던져 트랜잭션을 롤백하도록 함
        }

    }

    /**
     * 새로운 authrt_mng_no 생성
     * @param prefix
     * @return
     * @throws Exception
     */
    public String generateNextAuthrtMngNo(String prefix) throws Exception {
        String maxAuthrtMngNo = cmnAthPtAuthrtInfoMMapper.getMaxAuthrtMngNo(prefix);

        // 최대 번호에서 숫자 부분을 추출하고 증가
        int nextNumber = 1;
        if (maxAuthrtMngNo != null) {
            String numberPart = maxAuthrtMngNo.substring(maxAuthrtMngNo.lastIndexOf('_') + 1);
            nextNumber = Integer.parseInt(numberPart) + 1;
        }
        // 새로운 authrt_mng_no를 생성
        String nextAuthrtMngNo = String.format("%s_%04d", prefix, nextNumber);
        return nextAuthrtMngNo;
    }
}
