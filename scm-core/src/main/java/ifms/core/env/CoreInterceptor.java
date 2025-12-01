package ifms.core.env;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import ifms.core.util.CoreUtil;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;


public class CoreInterceptor extends HandlerInterceptorAdapter {

    private final Log logger = LogFactory.getLog(this.getClass());

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        Map<String, String[]> requestMap = request.getParameterMap();

        logger.debug("[IN] ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■▶ START");
        logger.debug("[Request URI]["+request.getRequestURI()+"]");
        logger.debug("[parameters size]["+requestMap.size()+"]");
        for (Entry<String, String[]> e : requestMap.entrySet()) {
            String key = e.getKey();

            String value[] = e.getValue();
            List<String> valueList = null;
            if(value!=null&&value.length>0) {
                valueList = Arrays.asList(value);
            }

        }

        return super.preHandle(request, response, handler);
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

        /* 메뉴진입시 szms.js 설정에 의해 처리되는 구간 - LEFT 메뉴 ID */
        if(!StringUtils.isEmpty(request.getParameter("LEFT_MENU_ID"))) {
            String LEFT_MENU_ID = request.getParameter("LEFT_MENU_ID");
            modelAndView.addObject("LEFT_MENU_ID", LEFT_MENU_ID);
        }
        /* 메뉴진입시 szms.js 설정에 의해 처리되는 구간 - POPUP ID */
        if(!StringUtils.isEmpty(request.getParameter("POPUP_ID"))) {
            String popupId = request.getParameter("POPUP_ID");
            modelAndView.addObject("POPUP_ID", popupId);
        }

        String uri = request.getRequestURI().substring(request.getContextPath().length());
        int lastIndex = uri.lastIndexOf(".");
        String ext = lastIndex >= 0 ? uri.substring(lastIndex+1) : "";

        /* [**.do|**.pop] 형식인 경우만 공통 메시지정보를 화면에 전송 */
        if("do".equals(ext) || "pop".equals(ext)) {
            //modelAndView.addObject("COMMON_MESSAGE_LIST", new Gson().toJson(CommonMessage.COMMON_MESSAGE_LIST));
        }

        /* 타일즈 뷰 이름 Default 설정 */
        CoreUtil.convertTilesViewName(request, modelAndView);

        logger.debug("[OUT] ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■▶ END");

    }

}
