package ifms.adm.sos.uah.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import ifms.adm.sos.uah.service.CmnUahPtUsrAcsHstService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping(value="/adm/sos/uah")
public class CmnUahPtUsrAcsHstController {
    public final Log logger = LogFactory.getLog(this.getClass());

    @Autowired
    CmnUahPtUsrAcsHstService cmnUahPtUsrAcsHstService;

    /**
     * 사용자접속이력관리 화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnUahPtUsrAcsHst.do")
    public void cmnUahPtUsrAcsHst(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnUahPtUsrAcsHst] START");

        logger.debug("["+this.getClass().getName()+"][cmnUahPtUsrAcsHst] END");
    }

    /**
     * 사용자접속이력관리 목록 조회
     * @param authentication
     * @param requestMap
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectCmnUahPtUsrAcsHstList.json")
    public void selectCmnUahPtUsrAcsHstList(Authentication authentication,
                                             @RequestBody Map<String, Object> requestMap,
                                             HttpServletRequest request, ModelMap model) throws Exception {

        PagingVO pagingVO = new PagingVO(requestMap);

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }

        int totalCount = cmnUahPtUsrAcsHstService.selectCmnUahPtUsrAcsHstListCnt(requestMap);

        pagingVO.setTotalCount(totalCount);
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        model.addAttribute("pagingVO", pagingVO);

        if(totalCount > 0) {
            List<Map<String, Object>> list = cmnUahPtUsrAcsHstService.selectCmnUahPtUsrAcsHstList(requestMap);
            model.addAttribute("list", list);
        }
    }


}
