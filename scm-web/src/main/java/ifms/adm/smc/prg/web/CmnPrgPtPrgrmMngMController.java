package ifms.adm.smc.prg.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import ifms.adm.smc.prg.service.CmnPrgPtPrgrmMngMService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Controller
@RequestMapping(value="/adm/smc/prg")
public class CmnPrgPtPrgrmMngMController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    CmnPrgPtPrgrmMngMService cmnPrgPtPrgrmMngMService;

    /**
     * 프로그램 관리 목록화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnPrgPtPrgrmMng.do")
    public void cmnPrgPtPrgrmMng(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnPrgPtPrgrmMng] START");

        logger.debug("["+this.getClass().getName()+"][cmnPrgPtPrgrmMng] END");

    }

    /**
     * 프로그램 관리 목록조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectCmnPrgPtPrgrmMngList.json")
    public void selectCmnPrgPtPrgrmMngList(Authentication authentication,
                                             @RequestBody Map<String, Object> requestMap,
                                             HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][selectCmnPrgPtPrgrmMngList] START");

        /* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
        PagingVO pagingVO = new PagingVO(requestMap);

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }
        //requestMap.put("userId", sessionVO.getUserId());

        int totalCount = cmnPrgPtPrgrmMngMService.selectCmnPrgPtPrgrmMngListCnt(requestMap);

        /* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
        pagingVO.setTotalCount(totalCount);

        /* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정

        /* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
        model.addAttribute("pagingVO", pagingVO);

        if(totalCount > 0) {
            List<Map<String, Object>> list = cmnPrgPtPrgrmMngMService.selectCmnPrgPtPrgrmMngList(requestMap);
            model.addAttribute("list", list);
        }
        logger.debug("["+this.getClass().getName()+"][selectCmnPrgPtPrgrmMngList] END");
    }


    /**
     * 프로그램 관리 상세조회
     * @param authentication
     * @param request
     * @param requestMap
     * @param model
     * @throws Exception
     */
    @PostMapping(value="/cmnPrgPtPrgrmMngDetail.do")
    public void cmnPrgPtPrgrmMngDetail(Authentication authentication,
                                     HttpServletRequest request,
                                     @RequestParam Map<String, Object> requestMap,
                                     ModelMap model) throws Exception {

        String rprsUrlAddr = (String) requestMap.get("rprsUrlAddr");
        String siteClsfCd = (String) requestMap.get("siteClsfCd");
        String prgrmNm = (String) requestMap.get("prgrmNm");

        model.addAttribute("rprsUrlAddr", rprsUrlAddr);
        model.addAttribute("siteClsfCd", siteClsfCd);
        model.addAttribute("prgrmNm", prgrmNm);

        Map<String, Object> resultMap = cmnPrgPtPrgrmMngMService.selectCmnPrgPtPrgrmMngDtl(requestMap);

        model.addAttribute("resultMap", resultMap);
        //model.addAttribute("detail", detail);
    }

    /**
     * URL검색 팝업 화면
     * @param authentication
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/searchUrlPopup.page")
    public void searchUrlPopup(Authentication authentication,
                               HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][searchUrlPopup] END");

    }

    /**
     * URL목록 조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectUrlList.json")
    public void selectUrlList(Authentication authentication,
                              @RequestBody Map<String, Object> requestMap,
                              HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][selectUrlList] START");

        /* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
        PagingVO pagingVO = new PagingVO(requestMap);
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }

        int totalCount = cmnPrgPtPrgrmMngMService.selectUrlListCount(requestMap);

        /* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
        pagingVO.setTotalCount(totalCount);

        /* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정

        /* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
        model.addAttribute("pagingVO", pagingVO);

        if (totalCount > 0 ){
            List<Map<String, Object>> list = cmnPrgPtPrgrmMngMService.selectUrlList(requestMap);
            model.addAttribute("list", list);
        }

        logger.debug("["+this.getClass().getName()+"][selectUrlList] END");
    }


    /**
     * 프로그램 상세조회 URL 정보 조회
     * @param requestMap
     * @return
     * @throws Exception
     */
    @PostMapping(value="/getUrlDetails.json")
    public ResponseEntity<Map<String, Object>> getUrlDetails(@RequestBody Map<String, Object> requestMap) throws Exception {

        String rprsUrlMngNo = (String) requestMap.get("rprsUrlMngNo");
        String siteClsfCd = (String) requestMap.get("siteClsfCd");

        Map<String, Object> urlDetails = cmnPrgPtPrgrmMngMService.getUrlDetails(requestMap);

        Map<String, Object> response = new HashMap<>();
        if (urlDetails != null) {
            response.put("success", true);
            response.put("data", urlDetails);
        } else {
            response.put("success", false);
            response.put("message", "URL 정보를 찾을 수 없습니다.");
        }

        return ResponseEntity.ok(response);
    }

    @PostMapping("/insertProgram.json")
    public ResponseEntity<?> insertProgram(Authentication authentication,
                                           @RequestBody Map<String, Object> requestMap) {

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
        requestMap.put("frstRgtrId", userId);
        requestMap.put("lastMdfrId",userId);
        try {
            cmnPrgPtPrgrmMngMService.insertProgram(requestMap);
            return ResponseEntity.ok(Map.of("success", true, "message", "등록 성공"));
        } catch (DuplicateUrlException e) {
            // 중복된 URL에 대해서만 별도의 응답 처리
            return ResponseEntity
                    .status(HttpStatus.CONFLICT) // 409 Conflict
                    .body(Map.of("success", false, "message", e.getMessage()));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "등록 실패"));
        }
    }

    public static class DuplicateUrlException extends RuntimeException {
        public DuplicateUrlException(String message) {
            super(message);
        }
    }


    @PostMapping(value="/cmnPrgPtPrgrmMngInsertView.do")
    public void cmnPrgPtPrgrmMngInsertView(Authentication authentication,
                                       HttpServletRequest request,
                                       @RequestParam Map<String, Object> requestMap,
                                       ModelMap model) throws Exception {

    }


}
