package ifms.adm.smc.mnu.mapper;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;
import java.util.Map;

@Mapper
public interface CmnMnuPtMenuMngMMapper {

    int selectCmnMnuPtMenuMngListCnt(Map<String, Object> requestMap) throws Exception;

    /**
     * 메뉴관리 목록조회
     * @param requestMap
     * @return
     */
    List<Map<String, Object>> selectCmnMnuPtMenuMngList(Map<String, Object> requestMap) ;

    /**
     * 최상위 메뉴 추가
     * @param requestMap
     * @return
     * @throws Exception
     */
    int insertTopLevelMenu(Map<String, Object> requestMap) throws Exception;

    /**
     * 메뉴 삭제
     * @param requestMap
     * @return
     * @throws Exception
     */
    int deleteMenuList(Map<String, Object> requestMap) throws Exception;

    /**
     * 하위 메뉴 추가
     * @param requestMap
     * @return
     * @throws Exception
     */
    int addSubMenu(Map<String, Object> requestMap) throws Exception;

    /**
     * 프로그램목록 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    int selectPrgListCount(Map<String, Object> requestMap) throws Exception;

    /**
     * 프로그램목록 건수 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    List<Map<String, Object>> selectPrgList(Map<String, Object> requestMap) throws Exception;

    /**
     * 메뉴 및 연결 프로그램 수정
     * @param requestMap
     * @throws Exception
     */
    void updatePrgMenuDtl(Map<String, Object> requestMap) throws Exception;

    /**
     * URL관리 기등록 여부 확인
     * @param requestMap
     * @return
     * @throws Exception
     */
    int checkUrlMngDtl(Map<String, Object> requestMap) throws Exception;

    /**
     * URL관리 테이블 Insert
     * @param requestMap
     * @throws Exception
     */
    void insertUrlMngDtl(Map<String, Object> requestMap) throws Exception;

    /**
     * URL관리 테이블 Update
     * @param requestMap
     * @throws Exception
     */
    void updateUrlMngDtl(Map<String, Object> requestMap) throws Exception;
}
