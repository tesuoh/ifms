package ifms.cmn.lnk.service;

/**                                                                                                                                              
 * 차세대 부동산거래관리시스템 2차년도                                                                                                                           
 * 도로명주소 api 연계  Service                                                                                                                 
 */                                                                                                                                          
                                                                                                                                                 
public interface CmCmcRnApiLinkService {                                                                                                            
   
    /**                                                                                                                                        
     * 도로명 api 연계  [개발서버 -> 도로명주소사업단 통신용] (테스트 컨트롤러)         
     * http://10.10.33.111/cm/cmc/selectCmCmcRnApiLink.do?currentPage=1&countPerPage=5&keyword=서초현대아파트                                                                                                   
     * @param Stirng currentPage, Stirng countPerPage, Stirng keyword                                                                                          
     * @return json Stirng                                                                                                               
     */       
	public String selectCmCmcRnApiLink(String currentPage, String countPerPage, String keyword) throws Exception; 
    /**                                                                                                                                        
     * 도로명 api 연계 (개발자 로컬PC 개발용) [개발자로컬PC -> 개발서버 -> 도로명주소사업단 통신용] (테스트 컨트롤러)    
     * http://localhost:8080/cm/cmc/selectCmCmcRnApiLinkLocalDev.do?currentPage=1&countPerPage=5&keyword=서초현대아파트                                                                                                          
     * @param Stirng currentPage, Stirng countPerPage, Stirng keyword                                                                                               
     * @return json Stirng                                                                                                                
     */      
	public String selectCmCmcRnApiLinkLocalDev(String currentPage, String countPerPage, String keyword) throws Exception; 

}                                                                                                                                                
