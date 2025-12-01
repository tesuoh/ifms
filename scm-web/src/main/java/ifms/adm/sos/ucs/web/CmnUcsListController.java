package ifms.adm.sos.ucs.web;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
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

import ifms.adm.sos.ucs.service.CmnUcsListService;

@Controller
@RequestMapping(value="/adm/sos/ucs")
public class CmnUcsListController {
	
    public final Log logger = LogFactory.getLog(this.getClass());
    
	@Autowired
	private CmnUcsListService cmnUcsListService;

    /**
     * 사용자일일작업현황 화면
     * @param request
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/admUcsList.do")
    public void admUcsList(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][admUcsList] START");

        logger.debug("["+this.getClass().getName()+"][admUcsList] END");
    }
    
    /**
     * 사용자일일작업현황 목록 조회
     * @param requestMap
     * @param model
     * @throws Exception
     */
    @PostMapping(value = "/selectUcsList.json") 
    public void selectAdmUcsList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception {
    	logger.debug("["+this.getClass().getName()+"][selectAdmUcsList] START");

    	requestMap.get("srchBgngDt");
    	requestMap.get("srchEndDt");
    	
    	
		List<Map<String, Object>> list = cmnUcsListService.selectUcsList(requestMap);
		model.addAttribute("list", list);
		
    	logger.debug("["+this.getClass().getName()+"][selectAdmUcsList] END");
    }

}
