package ifms.adm.smc.ath.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import ifms.adm.smc.ath.service.CmnAthPtAuthrtInfoMService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.naming.ServiceUnavailableException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.ValidationException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/adm/smc/ath")
public class CmnAthPtAuthrtInfoMController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    CmnAthPtAuthrtInfoMService cmnAthPtAuthrtInfoMService;

    /**
     * 권한관리 목록화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnAthPtAuthrtInfo.do")
    public void cmnAthPtAuthrtInfo(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnAthPtAuthrtInfo] START");

        logger.debug("["+this.getClass().getName()+"][cmnAthPtAuthrtInfo] END");

    }

    /**
     * 권한관리 목록 조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectCmnAthPtAuthrtInfoList.json")
    public void selectCmnAthPtAuthrtInfoList(Authentication authentication,
                                             @RequestBody Map<String, Object> requestMap,
                                             HttpServletRequest request, ModelMap model) throws Exception {

        /* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
        PagingVO pagingVO = new PagingVO(requestMap);

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }

        // 건수 조회
        int totalCount = cmnAthPtAuthrtInfoMService.selectCmnAthPtAuthrtInfoListCnt(requestMap);

        /* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
        pagingVO.setTotalCount(totalCount);

        /* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());

        /* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
        model.addAttribute("pagingVO", pagingVO);

        if(totalCount > 0) {
            // 목록 조회
            List<Map<String, Object>> list = cmnAthPtAuthrtInfoMService.selectCmnAthPtAuthrtInfoList(requestMap);
            model.addAttribute("list", list);
        }
    }

    /**
     * 권한관리 상세 조회
     * @param authentication
     * @param paramMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnAthPtAuthrtInfoDetail.do")
    public void cmnAthPtAuthrtInfoDetail(Authentication authentication,
                                         @RequestParam Map<String,Object> paramMap,
                                         HttpServletRequest request, ModelMap model) throws Exception {

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
        paramMap.put("userId", userId);

        Map<String, Object> authrtInfoDetail = cmnAthPtAuthrtInfoMService.selectAuthrtInfoDetail(paramMap);
        List<Map<String, Object>> prgAuthrtList = cmnAthPtAuthrtInfoMService.selectPrgAuthrtList(paramMap);
        model.addAttribute("authrtInfoDetail", authrtInfoDetail);
        model.addAttribute("prgAuthrtList", prgAuthrtList);
    }

    /**
     * 권한관리 상세 수정
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/updateAuthrtInfoDetail.json")
    @ResponseBody
    public Map<String, Object> updateAuthrtInfoDetail(Authentication authentication, @RequestBody Map<String, Object> requestMap,
                                 HttpServletRequest request, ModelMap model) throws Exception {
        /* 세션정보 설정 */
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
        requestMap.put("lastMdfrId", userId);
        requestMap.put("frstRgtrId", userId);

        cmnAthPtAuthrtInfoMService.updateAuthrtInfoDetail(requestMap);

        Map<String, Object> resultMap = new HashMap<>();
        resultMap.put("result", true); // 성공 여부를 JSON 형태로 반환
        return resultMap;
    }


    /**
     * 권한관리 신규등록 화면 조회
     * @param authentication
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnAthPtAuthrtInfoInsertView.do")
    public void cmnAthPtAuthrtInfoInsertView(Authentication authentication,
                                             @RequestParam Map<String,Object> paramMap,
                                             HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnAthPtAuthrtInfoInsertView] START");
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }

        List<Map<String, Object>> prgAuthrtList = cmnAthPtAuthrtInfoMService.selectPrgAuthrtList(paramMap);
        model.addAttribute("prgAuthrtList", prgAuthrtList);
        logger.debug("["+this.getClass().getName()+"][cmnAthPtAuthrtInfoInsertView] END");
    }

    @PostMapping(value = "/insertAuthrtInfoDetail.json")
    public ResponseEntity<Map<String, Object>> insertAuthrtInfoDetail(Authentication authentication, @RequestBody Map<String, Object> requestMap,
                                                                      HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("[" + this.getClass().getName() + "][insertAuthrtInfoDetail] START");

        /* 세션정보 설정 */
        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
        String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
        requestMap.put("frstRgtrId", userId );

        try {
            cmnAthPtAuthrtInfoMService.insertAuthrtInfoDetail(requestMap);

            Map<String, Object> response = new HashMap<>();
            response.put("result", true);
            response.put("message", "성공적으로 등록되었습니다.");

            return ResponseEntity.ok(response);
        } catch (DataIntegrityViolationException e) {
            logger.error("데이터 무결성 위반: ", e);
            return buildErrorResponse("데이터 무결성 위반으로 등록에 실패했습니다.", HttpStatus.BAD_REQUEST);
        } catch (ValidationException e) {
            logger.error("유효성 검사 실패: ", e);
            return buildErrorResponse("입력값 유효성 검사에 실패했습니다.", HttpStatus.BAD_REQUEST);
        } catch (ServiceUnavailableException e) {
            logger.error("서비스 사용 불가: ", e);
            return buildErrorResponse("서비스가 현재 사용 불가능합니다. 잠시 후 다시 시도해주세요.", HttpStatus.SERVICE_UNAVAILABLE);
        } catch (Exception e) {
            logger.error("권한 정보 등록 중 알 수 없는 오류 발생: ", e);
            return buildErrorResponse("등록에 실패했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 에러 응답을 생성하는 헬퍼 메서드
     */
    private ResponseEntity<Map<String, Object>> buildErrorResponse(String message, HttpStatus status) {
        Map<String, Object> response = new HashMap<>();
        response.put("result", false);
        response.put("message", message);
        return ResponseEntity.status(status).body(response);
    }

}
