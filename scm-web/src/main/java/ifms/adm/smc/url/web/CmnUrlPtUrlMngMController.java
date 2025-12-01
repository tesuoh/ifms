package ifms.adm.smc.url.web;

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
import ifms.adm.smc.url.service.CmnUrlPtUrlMngMService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/adm/smc/url")
public class CmnUrlPtUrlMngMController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    CmnUrlPtUrlMngMService cmnUrlPtUrlMngMService;

    /**
     * URL관리 목록화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnUrlPtUrlMng.do")
    public void cmnUrlPtUrlMng(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnUrlPtUrlMng] START");

        logger.debug("["+this.getClass().getName()+"][cmnUrlPtUrlMng] END");

    }

    /**
     * URL관리 목록 조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectCmnUrlPtUrlMngList.json")
    public void selectCmnUrlPtUrlMngList(Authentication authentication,
                                         @RequestBody Map<String, Object> requestMap,
                                         HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][selectCmnUrlPtUrlMngList] START");

        /* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
        PagingVO pagingVO = new PagingVO(requestMap);

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }

        // 건수 조회
        int totalCount = cmnUrlPtUrlMngMService.selectCmnUrlPtUrlMngListCnt(requestMap);

        /* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
        pagingVO.setTotalCount(totalCount);

        /* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정


        /* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
        model.addAttribute("pagingVO", pagingVO);

        if (totalCount > 0) {
            List<Map<String, Object>> result = cmnUrlPtUrlMngMService.selectCmnUrlPtUrlMngList(requestMap);
            model.addAttribute("result", result);
        }
        logger.debug("["+this.getClass().getName()+"][selectCmnUrlPtUrlMngList] END");
    }

    /**
     * URL관리 상세 조회
     * @param authentication
     * @param paramMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnUrlPtUrlMngDetail.do")
    public void cmnUrlPtUrlMngDetail(Authentication authentication,
                                     @RequestParam Map<String,Object> paramMap,
                                     HttpServletRequest request,
                                     ModelMap model) throws Exception {
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
        paramMap.put("userId", userId);

        Map<String, Object> resultMap = cmnUrlPtUrlMngMService.selectUrlMngDetail(paramMap);
        model.addAttribute("resultMap", resultMap);
    }

    @PostMapping(value = "/updateCmnUrlPtUrlMngDetail.json")
    public ResponseEntity<Map<String, Object>> updateCmnUrlPtUrlMngDetail(Authentication authentication,
                                                                          @RequestBody Map<String, Object> requestMap,
                                                                          HttpServletRequest request) {

        try {
            // 세션정보 설정
            AuthUser authUser = (AuthUser) authentication.getPrincipal();
            SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
            String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
            requestMap.put("lastMdfrId", userId);

            cmnUrlPtUrlMngMService.updateCmnUrlPtUrlMngDetail(requestMap);

            Map<String, Object> response = new HashMap<>();
            response.put("result", true);
            response.put("message", "업데이트 성공");

            return ResponseEntity.ok(response);
        } catch (SQLException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("result", false);
            errorResponse.put("message", "업데이트 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @PostMapping(value = "/deleteCmnUrlPtUrlMngDetail.json")
    public ResponseEntity<Map<String, Object>> deleteCmnUrlPtUrlMngDetail(Authentication authentication,
                                                                          @RequestBody Map<String, Object> requestMap,
                                                                          HttpServletRequest request) {
        try {
            AuthUser authUser = (AuthUser) authentication.getPrincipal();
            SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
            String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
            requestMap.put("lastMdfrId", userId);

            cmnUrlPtUrlMngMService.deleteCmnUrlPtUrlMngDetail(requestMap);

            Map<String, Object> response = new HashMap<>();
            response.put("result", true);
            response.put("message", "삭제 성공");

            return ResponseEntity.ok(response);
        } catch(SQLException e) {
            Map<String, Object> errorResponse = new HashMap<>();
            errorResponse.put("result", false);
            errorResponse.put("message", "삭제 실패: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);

        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }



    /**
     * 신규등록 화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnUrlPtUrlMngInsertView.do")
    public void cmnUrlPtUrlMngInsertView(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnUrlPtUrlMngInsertView] START");

        logger.debug("["+this.getClass().getName()+"][cmnUrlPtUrlMngInsertView] END");

    }


    @PostMapping(value = "/insertCmnUrlPtUrlMngDetail.json")
    public ResponseEntity<Map<String, Object>> insertCmnUrlPtUrlMngDetail(Authentication authentication,
                                                                          @RequestBody Map<String, Object> requestMap) throws Exception {
        /* 세션정보 설정 */
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
        requestMap.put("frstRgtrId", userId);

        Map<String, Object> response = new HashMap<>();

        // URL 중복 여부 체크
        String urladdr = (String) requestMap.get("urlAddr");
        boolean isDuplicate = cmnUrlPtUrlMngMService.checkUrlExists(urladdr);

        if (isDuplicate) {
            // URL이 이미 존재하는 경우
            response.put("result", false);
            response.put("message", "URL이 이미 존재합니다.");
            response.put("duplicate", true);
            response.put("urladdr", urladdr);
            return ResponseEntity.ok(response); // 409 Conflict
        }

        // Insert URL Management Detail
        int insertCount = cmnUrlPtUrlMngMService.insertCmnUrlPtUrlMngDetail(requestMap);

        if (insertCount > 0) {
            response.put("result", true);
            response.put("message", "성공적으로 등록되었습니다.");
        } else {
            response.put("result", false);
            response.put("message", "등록에 실패했습니다.");
        }

        return ResponseEntity.ok(response);
    }


}
