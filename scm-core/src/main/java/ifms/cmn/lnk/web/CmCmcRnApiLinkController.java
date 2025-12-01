package ifms.cmn.lnk.web;                                  
                                                                                                                                                 
import javax.annotation.Resource;
                                                                                                                
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import ifms.cmn.lnk.service.CmCmcRnApiLinkService;
                                                                                                                                                 
/**                                                                                                                                              
 * 차세대 부동산거래관리시스템 2차년도                                                                                                                           
 * 도로명주소 api 연계 Controller                                                                                                                       
 */                                
                                                                                                                                                 
@Controller                                                                                                                                      
public class CmCmcRnApiLinkController {                                                                                                             

    /** CmCmcCodeService */                                                                                                                    
    @Resource(name = "cmCmcRnApiLinkService")                                                                                                       
    private CmCmcRnApiLinkService cmCmcRnApiLinkService;       
      	
    /**                                                                                                                                        
     * 도로명 api 연계  [개발서버 -> 도로명주소사업단 통신용] (json 데이터 확인 test 컨트롤러)         
     * http://10.10.33.111/cm/cmc/selectCmCmcRnApiLink.do?currentPage=1&countPerPage=5&keyword=서초현대아파트                                                                                                   
     * @param Stirng currentPage, Stirng countPerPage, Stirng keyword                                                                                          
     * @return @ResponseBody json                                                                                                                  
     */                                                                                                                                        
    @RequestMapping(value="/cm/cmc/selectCmCmcRnApiLink.do", produces="application/json; charset=utf8")                                                                             
    public @ResponseBody String selectCmCmcRnApiLink(@RequestParam("currentPage") String currentPage, @RequestParam("countPerPage") String countPerPage, @RequestParam("keyword") String keyword) throws Exception {    	  
    	return cmCmcRnApiLinkService.selectCmCmcRnApiLink(currentPage, countPerPage, keyword);  	                                                                                                                         
    }     
    
    /**                                                                                                                                        
     * 도로명 api 연계 (개발자 로컬PC 개발용) [개발자로컬PC -> 개발서버 -> 도로명주소사업단 통신용] (json 데이터 확인 test 컨트롤러)  
     * http://localhost:8080/cm/cmc/selectCmCmcRnApiLinkLocalDev.do?currentPage=1&countPerPage=5&keyword=서초현대아파트                                                                                                          
     * @param Stirng currentPage, Stirng countPerPage, Stirng keyword                                                                                               
     * @return @ResponseBody json                                                                                                                
     */                                                                                                                                        
    @RequestMapping(value="/cm/cmc/selectCmCmcRnApiLinkLocalDev.do", produces="application/json; charset=utf8") 
    public @ResponseBody String selectCmCmcRnApiLinkLocalDev(@RequestParam("currentPage") String currentPage, @RequestParam("countPerPage") String countPerPage, @RequestParam("keyword") String keyword) throws Exception {
    	return cmCmcRnApiLinkService.selectCmCmcRnApiLinkLocalDev(currentPage, countPerPage, keyword);  	                                                                                                                        
    }       
}                                                                                                                                                
                                                                                                                                                 
