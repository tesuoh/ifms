package ifms.core.env;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;
import ifms.core.aop.CoreException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class CoreControllerAdvice {

    public final Log logger = LogFactory.getLog(this.getClass());

    public final static String ERROR_PAGE_500 = "cmn/error/code500";

    public final static String ERROR_PAGE_404 = "cmn/error/code404";

    public final static String ERROR_PAGE_AUTH = "redirect:/cmn/error/errorPage.do";

    /**
     * 500 처리 - Runtime
     * @param ex
     * @param request
     * @return
     * @throws UnsupportedEncodingException
     */
    /*@ExceptionHandler(CoreException.class)
    public Object handleCoreException(Exception ex, Model m, HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException {
        logger.debug("["+this.getClass().getName()+"][handleCoreException] START");

        ModelAndView mv = new ModelAndView(ERROR_PAGE_AUTH);
        mv.addObject("message", URLEncoder.encode("정상이 아닙니다.", "UTF-8"));

        logger.debug("["+this.getClass().getName()+"][handleCoreException] END");
        return mv;
    }*/
    @ExceptionHandler(CoreException.class)
    public ModelAndView handleCoreException(CoreException ex, HttpServletRequest request) {
        logger.error("CoreException caught: " + ex.getMessage(), ex);

        ModelAndView mv = new ModelAndView(ERROR_PAGE_AUTH);
        mv.addObject("message", "잘못된 접근입니다.");
        mv.addObject("detail", ex.getMessage());
        mv.setStatus(HttpStatus.FORBIDDEN); // 403 Forbidden 상태 설정
        return mv;
    }
    /**
     * 500 처리 - Runtime
     * @param ex
     * @param request
     * @return
     */
    @ExceptionHandler(RuntimeException.class)
    public Object handleRuntimeException(Exception ex, Model m, HttpServletRequest request, HttpServletResponse response) {

        String uri = request.getRequestURI().substring(request.getContextPath().length());

        /* uri 확장자 */
        int lastIndex = uri.lastIndexOf(".");
        String ext = lastIndex >= 0 ? uri.substring(lastIndex+1) : "";

        Map<String, Object> resultMap = new HashMap<String, Object>();
        //resultMap.put("log", ex.getMessage());
        resultMap.put("message", HttpStatus.INTERNAL_SERVER_ERROR);
        resultMap.put("status", HttpStatus.INTERNAL_SERVER_ERROR.value());

        /* .page로 호출한 경우 json으로 리턴 후 common.js 에서 처리한다. */
        if("page".equals(ext)) {

            return new ResponseEntity<Map<String, Object>>(resultMap, new HttpHeaders(), HttpStatus.INTERNAL_SERVER_ERROR);
        } else {

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            m.addAllAttributes(resultMap);

            if("file".equals(ext)) {
                return "";
                //return ERROR_FILE_500;  파일다운로드 개발 후
            } else {
                return ERROR_PAGE_500;
            }
        }

    }



    /**
     * 404 처리 - URI 없음 AND 확장자 일치
     * @param e
     * @return
     */
    @ExceptionHandler(NoHandlerFoundException.class)
    public Object noHandlerFoundException(NoHandlerFoundException ex, Model m, HttpServletRequest request, HttpServletResponse response) {

        String uri = request.getRequestURI().substring(request.getContextPath().length());

        /* uri 확장자 */
        int lastIndex = uri.lastIndexOf(".");
        String ext = lastIndex >= 0 ? uri.substring(lastIndex+1) : "";

        //logger.error(ex);

        Map<String, Object> resultMap = new HashMap<String, Object>();
        resultMap.put("log", ex.getMessage());
        resultMap.put("message", HttpStatus.INTERNAL_SERVER_ERROR);
        resultMap.put("status", HttpStatus.INTERNAL_SERVER_ERROR.value());

        /* .page로 호출한 경우 json으로 리턴 후 common.js 에서 처리한다. */
        if("page".equals(ext)) {

            return new ResponseEntity<Map<String, Object>>(resultMap, new HttpHeaders(), HttpStatus.NOT_FOUND);
        } else {

            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            m.addAllAttributes(resultMap);

            return ERROR_PAGE_404;
        }
    }


}
