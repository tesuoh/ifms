package ifms.adm.smc.mnu.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import ifms.adm.smc.mnu.service.CmnMnuPtMenuMngMService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/adm/smc/mnu")
public class CmnMnuPtMenuMngMController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    CmnMnuPtMenuMngMService cmnMnuPtMenuMngMService;

    /**
     * 메뉴관리 목록화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnMnuPtMenuMng.do")
    public void cmnMnuPtMenuMng(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnMnuPtMenuMng] START");

        logger.debug("["+this.getClass().getName()+"][cmnMnuPtMenuMng] END");
    }

    /**
     * 메뉴관리 목록조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectCmnMnuPtMenuMngList.json")
    public void selectCmnMnuPtMenuMngList(Authentication authentication,
                                             @RequestBody Map<String, Object> requestMap,
                                             HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][selectCmnMnuPtMenuMngList] START");

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }
        //requestMap.put("userId", sessionVO.getUserId());

        List<Map<String, Object>> list  = cmnMnuPtMenuMngMService.selectCmnMnuPtMenuMngList(requestMap);

        model.addAttribute("list", list );
        logger.debug("["+this.getClass().getName()+"][selectCmnMnuPtMenuMngList] END");
    }

    /**
     * 최상위 메뉴 추가
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/addTopLevelMenu.json")
    public void insertTopLevelMenu(Authentication authentication,
                                   @RequestBody Map<String, Object> requestMap,
                                   HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][insertTopLevelMenu] START");

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";

        requestMap.put("userId", userId);

        boolean result = cmnMnuPtMenuMngMService.insertTopLevelMenu(authUser, requestMap);

        model.addAttribute("result", result );
        logger.debug("["+this.getClass().getName()+"][insertTopLevelMenu] END");
    }

    /**
     * 메뉴 삭제
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/deleteMenuList.json")
    public void deleteMenuList(Authentication authentication,
                                   @RequestBody Map<String, Object> requestMap,
                                   HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][deleteMenuList] START");

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";

        requestMap.put("userId", userId);

        boolean result = cmnMnuPtMenuMngMService.deleteMenuList(authUser, requestMap);

        model.addAttribute("result", result );
        logger.debug("["+this.getClass().getName()+"][deleteMenuList] END");
    }

    /**
     * 하위 메뉴 추가
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/addSubMenu.json")
    public void addSubMenu(Authentication authentication,
                               @RequestBody Map<String, Object> requestMap,
                               HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][deleteMenuList] START");

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";

        requestMap.put("userId", userId);

        boolean result = cmnMnuPtMenuMngMService.addSubMenu(authUser, requestMap);

        model.addAttribute("result", result );
        logger.debug("["+this.getClass().getName()+"][deleteMenuList] END");
    }

    /**
     * 프로그램목록 조회 팝업 화면
     * @param authentication
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/searchPrgPopup.page")
    public void searchPrgPopup(Authentication authentication,
                               HttpServletRequest request, ModelMap model) throws Exception {
    }

    /**
     * 프로그램목록 조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectPrgList.json")
    public void selectPrgList(Authentication authentication,
                               @RequestBody Map<String, Object> requestMap,
                               HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][selectPrgList] START");

        /* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
        PagingVO pagingVO = new PagingVO(requestMap);
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";

        int totalCount = cmnMnuPtMenuMngMService.selectPrgListCount(requestMap);

        /* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
        pagingVO.setTotalCount(totalCount);

        /* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());

        /* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
        model.addAttribute("pagingVO", pagingVO);

        if (totalCount > 0 ){
            List<Map<String, Object>> list = cmnMnuPtMenuMngMService.selectPrgList(requestMap);
            model.addAttribute("list", list);
        }

        logger.debug("["+this.getClass().getName()+"][selectPrgList] END");
    }


    /**
     * 메뉴 및 연결 프로그램 수정
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/updatePrgMenuDtl.json")
    public void updatePrgMenuDtl(Authentication authentication, @RequestBody Map<String, Object> requestMap,
                                 HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("[" + this.getClass().getName() + "][insertPrgMenuDtl] START");

        /* 세션정보 설정 */
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";

        if (sessionVO == null || userId == null) {
            throw new IllegalStateException("세션 정보가 올바르지 않습니다. 사용자 ID를 확인할 수 없습니다.");
        }

        requestMap.put("rgtrId", userId);
        requestMap.put("mdfrId", userId);

        cmnMnuPtMenuMngMService.updatePrgMenuDtl(requestMap);

        logger.debug("[" + this.getClass().getName() + "][insertPrgMenuDtl] END");
    }



}
