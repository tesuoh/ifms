package ifms.adm.opl.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import ifms.adm.opl.service.CmnOplLogService;

@Controller
@RequestMapping(value="/adm/sos/opl")
public class cmnOplLogController {
	
    public final Log logger = LogFactory.getLog(this.getClass());
    
	@Autowired
	private CmnOplLogService cmnOplLogService;

    /**
     * 사용자일일작업현황 화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnOplLog.do")
    public void cmnOplLogList(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnUahPtUsrAcsHst] START");

        logger.debug("["+this.getClass().getName()+"][cmnUahPtUsrAcsHst] END");
    }
    
    /**
     * 사용자일일작업현황 목록 조회
     * @param requestMap
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/cmnOplLogList.json")
    public void selectCmnOplLogList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception {
    	logger.debug("["+this.getClass().getName()+"][selectCmnUahPtUsrAcsHstList] START");
    	
		List<Map<String, Object>> list = cmnOplLogService.selectCmnUahPtUsrAcsHstList(requestMap);
		model.addAttribute("list", list);
		
    	logger.debug("["+this.getClass().getName()+"][selectCmnUahPtUsrAcsHstList] END");
    }

}
