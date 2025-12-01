package ifms.adm.smc.usr.web;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.json.JsonObject;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
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
import org.springframework.web.server.ResponseStatusException;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.smc.usr.service.CmnUsrMngService;
import ifms.common.util.PagingVO;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

/**
 * 사용자 관리
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/smc/usr")
public class CmnUsrMngController {

	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private CmnUsrMngService cmnUsrMngService;
	
	/**
	 * 사용자 관리 화면 이동
	 * @throws Exception
	 */
	@PostMapping("/cmnUsrMngList.do")
	public void cmnUsrMngList(@RequestParam Map<String, Object> searchMap, ModelMap model) throws Exception{
		String savedParams = new ObjectMapper().writeValueAsString(searchMap);
		model.addAttribute("savedParams", savedParams);
	}
	
	/**
	 * 사용자 관리 목록 조회
	 * @param requestMap
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectUsrMngList.json")
	public void selectUsrMngList(@RequestBody Map<String, Object> requestMap, Authentication authentication, ModelMap model) throws Exception{
		
		PagingVO pagingVO = new PagingVO(requestMap);

		int totalCount = cmnUsrMngService.usrMngTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		model.addAttribute("pagingVO", pagingVO);
		
		if(totalCount > 0) {
			List<Map<String, Object>> list = cmnUsrMngService.selectUsrMngList(requestMap);
			model.addAttribute("list", list);
		}
	}
	
	/**
	 * 상세 페이지 이동
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnUsrMngDetail.do")
	public void cmnUsrMngDetail(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = cmnUsrMngService.selectUsrMngDetail(requestMap);
		model.addAttribute("detail", detail);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
	}

	/**
	 * 기관 목록 조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectInstList.json")
	   public void selectInstList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
	      PagingVO pagingVO = new PagingVO(requestMap);

	      // 기관 검색 시 5개씩 페이징 처리하도록 강제로 설정
	      pagingVO.setListCount(5);
	      pagingVO.setPageSize(5);

	      int totalCount = cmnUsrMngService.instTotalCount(requestMap);
	      pagingVO.setTotalCount(totalCount);
	      
	      requestMap.put("startNo", pagingVO.getStartNo());
	      requestMap.put("endNo", pagingVO.getEndNo());
	      requestMap.put("listCount", 5);
	      requestMap.put("pageSize", 5);


	      model.addAttribute("pagingVO", pagingVO);
	      
	      if(totalCount > 0) {
	         List<Map<String, Object>> instList = cmnUsrMngService.selectInstList(requestMap);
	         model.addAttribute("list", instList);
	      }
	      
	   }
	
	/**
	 * 아이디 중복 확인
	 * @param requestMap
	 * @param model
	 * @param authentication
	 * @throws Exception
	 */
	@PostMapping("/duplicateId.json")
	public void validDuplicatedId(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		boolean valify = cmnUsrMngService.validDuplicatedId(requestMap);
		model.addAttribute("success", valify);
	}
	
	/**
	 * 등록페이지 이동
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnUsrMngCreate.do")
	public void cmnUsrMngCreate(ModelMap model) throws Exception{
		List<Map<String, Object>>  authrtInfo = cmnUsrMngService.selectAuthrtInfo();
		model.addAttribute("authrtInfo", authrtInfo);		
		
	}

	/**
	 * 등록
	 * @param authentication
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/createUsrMng.json")
	public ResponseEntity<?> insert(Authentication authentication, @RequestBody Map<String, Object> requestMap) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
			
			requestMap.put("frstRgtrId", userId);
			
			Map<String, Object> responseMap = new HashMap<>();
			int result = cmnUsrMngService.insertUsrInfo(requestMap);
			
			if(result == 1) {
				responseMap.put("success", true);
				responseMap.put("message", "등록되었습니다.");
			}
			else {
				responseMap.put("success", false);
				responseMap.put("message", "실패 하였습니다.");				
			}
				
			return ResponseEntity.ok(responseMap);
		}
		catch(SQLException e) {
			throw new ResponseStatusException(
			        HttpStatus.INTERNAL_SERVER_ERROR, 
			        "서버 오류가 발생했습니다."
			    );
		}
		catch (NullPointerException e) {
			throw new ResponseStatusException(
					HttpStatus.INTERNAL_SERVER_ERROR, 
					"서버 오류가 발생했습니다."
					);
		}
	}
	

	/**
	 * 수정 화면 이동
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/cmnUsrMngUpdate.do")
	public void cmnUsrMngUpdate(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception{
		Map<String, Object> detail = cmnUsrMngService.selectUsrMngDetail(requestMap);
		model.addAttribute("detail", detail);	
		
		
		String detailJson = new ObjectMapper().writeValueAsString(detail);
		log.debug("detailJson: {}", detailJson);
		
		model.addAttribute("orgnlUser", detailJson);
		
		String savedParams = new ObjectMapper().writeValueAsString(requestMap);
		model.addAttribute("savedParams", savedParams);
		
		List<Map<String, Object>>  authrtInfo = cmnUsrMngService.selectAuthrtInfo();
		model.addAttribute("authrtInfo", authrtInfo);		
	}
	
	/**
	 * 수정
	 * @param authentication
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	@PostMapping("/updateUsrMng.json")
	public ResponseEntity<?> update(Authentication authentication, @RequestBody Map<String, Object> requestMap) throws Exception{
		try {
			AuthUser authUser = (AuthUser)authentication.getPrincipal();
			SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
			String lgnId = (sessionVO != null) ? sessionVO.getUserId().trim() : "";
			requestMap.put("lastMdfrId", lgnId);
			
			Map<String, Object> responseMap = new HashMap<>();
			boolean result = cmnUsrMngService.updateUsrInfo(requestMap);
			
			if(result) {
				responseMap.put("success", true);
				responseMap.put("message", "변경되었습니다.");
			}
			else {
				responseMap.put("success", false);
				responseMap.put("message", "서버 오류가 발생했습니다.");				
			}
				
			return ResponseEntity.ok(responseMap);
		}
		catch(SQLException e) {
			throw new ResponseStatusException(
			        HttpStatus.INTERNAL_SERVER_ERROR, 
			        "서버 오류가 발생했습니다."
			    );
		}
		catch (NullPointerException e) {
			throw new ResponseStatusException(
					HttpStatus.INTERNAL_SERVER_ERROR, 
					"서버 오류가 발생했습니다."
					);
		}
	}
	
	/**
	 * 비밀번호 오류 초기화
	 * @param userId
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/resetUserPswd.json")
	public void resetUserPswd(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		AuthUser authUser = (AuthUser)authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		
		requestMap.put("lastMdfrId", userId);
		
		int result = cmnUsrMngService.resetUserPswd(requestMap);
		
		if(result == 1) {
			model.addAttribute("success", true);
		}
		else {
			model.addAttribute("success", false);
			
		}
	}
	
	/**
	 * 사용자 관리 사용 정지
	 * @param userId
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/suspendedUser.json")
	public void suspendedUser(Authentication authentication, @RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		
		AuthUser authUser = (AuthUser)authentication.getPrincipal();
		SessionVO sessionVO = (authUser != null) ? authUser.getSessionVO() : null;
		String userId = (sessionVO != null) ? sessionVO.getUserId() : "";
		
		requestMap.put("lastMdfrId", userId);
		
		int result = cmnUsrMngService.suspendedUser(requestMap);
		
		if(result == 1) {
			model.addAttribute("success", true);
		}
		else {
			model.addAttribute("success", false);
			
		}
	}
}
