package ifms.adm.smc.i18n.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.smc.i18n.service.CmnI18nMsgMngService;
import ifms.common.util.PagingVO;
import ifms.core.security.CurrentUserProvider;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;
import lombok.RequiredArgsConstructor;
import ifms.adm.smc.i18n.service.CmnI18nCodeService;

/**
 * 다국어 메세지 관리 Controller
 * @author yangcheolseung
 * 
 */

@RequiredArgsConstructor
@Controller
@RequestMapping("/adm/smc/i18n")
public class CmnI18nMngController {
	
	public final Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired CmnI18nMsgMngService cmnI18nMsgMngService;
	@Autowired CmnI18nCodeService cmnI18nCodeService;
	
	private final CurrentUserProvider currentUser;
	
	/**
     * 다국어 메세지 관리 목록화면
     * @param requestMap
     * @param model
     * @throws Exception
     */
	@PostMapping("/cmnI18nList.do")
	public void cmnI18nMsg(Authentication authentication,
			 @RequestParam Map<String, Object> requestMap,
			 ModelMap model) throws Exception {
		
		logger.debug("===========================");
		logger.debug("id=" + requestMap.get("id"));
		logger.debug(currentUser.getCurrentUserId());
		logger.debug("===========================");
		
        List<Map<String, Object>> typCode = cmnI18nCodeService.selectI18nTypCd();
        model.addAttribute("typCode", typCode);
        
        List<Map<String, Object>> bisCode = cmnI18nCodeService.selectI18nBisCd();
        model.addAttribute("bisCode", bisCode);
        
        List<Map<String, Object>> locCode = cmnI18nCodeService.selectI18nLocCd();
        model.addAttribute("locCode", locCode);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
		logger.debug(currentUser.getCurrentUserId());
	}
	
	/**
     * 다국어 메세지 관리 목록조회
     * @param authentication
     * @param requestMap
     * @param model
     * @throws Exception
     */
	@PostMapping(value = "/selectI18nMsgList.json")
    public void selectCmnI18nMsgList(Authentication authentication,
                                             @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][selectCmnI18nMsgList] START");
        
        /* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
        PagingVO pagingVO = new PagingVO(requestMap);

        AuthUser authUser = (AuthUser) authentication.getPrincipal();
        SessionVO sessionVO = null;
        if (authUser != null) {
            sessionVO = authUser.getSessionVO();
        }
        //requestMap.put("userId", sessionVO.getUserId());
        
        

        int totalCount = cmnI18nMsgMngService.selectI18nMsgListTotalCnt(requestMap);

        /* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
        pagingVO.setTotalCount(totalCount);

        /* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
        requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정

        /* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
        model.addAttribute("pagingVO", pagingVO);

        if(totalCount > 0) {
            List<Map<String, Object>> list = cmnI18nMsgMngService.selectI18nMsgList(requestMap);
            model.addAttribute("list", list);
        }
        
        logger.debug("["+this.getClass().getName()+"][selectCmnI18nMsgList] END");
    }
	
	/**
	 * 다국어 메세지 상세 조회
     * @param authentication
     * @param requestMap
     * @param model
     * @throws Exception
	 */ 
	@PostMapping(value="/cmnI18nDetail.do")
	public void selectI18nMsgDetail(Authentication authentication,
			 @RequestParam	Map<String, Object> requestMap,
			 ModelMap model) throws Exception {
		
        List<Map<String, Object>> typCode = cmnI18nCodeService.selectI18nTypCd();
        model.addAttribute("typCode", typCode);
        
        List<Map<String, Object>> bisCode = cmnI18nCodeService.selectI18nBisCd();
        model.addAttribute("bisCode", bisCode);
        
        List<Map<String, Object>> locCode = cmnI18nCodeService.selectI18nLocCd();
        model.addAttribute("locCode", locCode);
		
		Map<String, Object> detail = cmnI18nMsgMngService.selectI18nMsgDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
	}
	
	/**
	 * 다국어 메세지 등록 페이지 이동
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnI18nCreate.do")
	public void goI18nMsgCreate(Authentication authentication, @RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		logger.debug("["+this.getClass().getName()+"][cmnI18nMsgCreate] START");
		
        List<Map<String, Object>> typCode = cmnI18nCodeService.selectI18nTypCd();
        model.addAttribute("typCode", typCode);
        
        List<Map<String, Object>> bisCode = cmnI18nCodeService.selectI18nBisCd();
        model.addAttribute("bisCode", bisCode);
        
        List<Map<String, Object>> locCode = cmnI18nCodeService.selectI18nLocCd();
        model.addAttribute("locCode", locCode);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);

        logger.debug("["+this.getClass().getName()+"][cmnI18nMsgCreate] END");
	}
	
	/**
	 * 다국어 메세지 등록
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/insertI18nMsg.json")
	public void insertI18nMsg(Authentication authentication, 
			@RequestBody Map<String, Object> requestMap, 
			ModelMap model) throws Exception{
		
		int result = cmnI18nMsgMngService.insertI18nMsg(requestMap);
		
		if(result == 1) {
			model.addAttribute("result", "success");
		}
		else {
			model.addAttribute("result", "fail");			
		}
		
	}
	
	/**
	 * 다국어 메세지 삭제
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/deleteI18nMsg.json")
	public void deleteI18nMsg(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		int result = cmnI18nMsgMngService.deleteI18nMsg(requestMap);
		
		if (result == 1) {
			model.addAttribute("result", "success");
		}
	}
	
	/**
	 * 다국어 메세지 수정 페이지 이동
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnI18nUpdate.do")
	public void goI18nMsgUpdate(Authentication authentication, @RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception {
		
        List<Map<String, Object>> typCode = cmnI18nCodeService.selectI18nTypCd();
        model.addAttribute("typCode", typCode);
        
        List<Map<String, Object>> bisCode = cmnI18nCodeService.selectI18nBisCd();
        model.addAttribute("bisCode", bisCode);
        
        List<Map<String, Object>> locCode = cmnI18nCodeService.selectI18nLocCd();
        model.addAttribute("locCode", locCode);
        
		Map<String, Object> detail = cmnI18nMsgMngService.selectI18nMsgDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 다국어 메세지 수정
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/updateI18nMsg.json")
	public void updateI18nMsg(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		int result = cmnI18nMsgMngService.updateI18nMsg(requestMap);
		
		if(result == 1) {
			model.addAttribute("success", true);
			model.addAttribute("message", "수정되었습니다.");
		}
		else {
			model.addAttribute("success", false);				
		}
	}
}
