package ifms.adm.lnk.mng.web;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import ifms.adm.lnk.mng.service.LnkMngService;
import ifms.common.util.PagingVO;
/**
 * 연계 관리 Controller
 * @author 오세준
 *
 */
@Controller
@RequestMapping("/adm/lnk/mng")
public class LnkMngController {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	@Autowired
	private LnkMngService lnkMngService;

	/**
	 * 연계관리 각각 목록 조회 이동
	 * @param authentication
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/lnkHistList.do")
	public void lnkHistList(Authentication authentication, ModelMap model) throws Exception{
		
	}
	@PostMapping("/lnkStatList.do")
	public void lnkStatList(Authentication authentication, ModelMap model) throws Exception{
		
	}
	@PostMapping("/lnkApiStaList.do")
	public void lnkApiStaList(Authentication authentication, ModelMap model) throws Exception{
		
	}
	/**
	 * 개방현황 목록조회 json
	  * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping(value = "/selectLnkApiStaList.json")
	public void selectLnkApiStaList(Authentication authentication, @RequestBody Map<String, Object> requestMap, HttpServletRequest request, ModelMap model) throws Exception{
		log.debug("============ /selectLnkApiStaList.json > requestMap: {}", requestMap);
		
		
		/* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
		PagingVO pagingVO = new PagingVO(requestMap);

		int totalCount = lnkMngService.selectLnkApiStaTotalCount(requestMap);
		model.addAttribute("operList", lnkMngService.selectOpnList());
	
		/* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
		pagingVO.setTotalCount(totalCount);

		/* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
		requestMap.put("startNo", pagingVO.getStartNo());
        requestMap.put("endNo", pagingVO.getEndNo());
        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정

		/* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
		model.addAttribute("pagingVO", pagingVO);

		/* ■■■■ PageNavigation 영역처리 - 5. 총건수에 대한 선택적 조회 ■■■■ */
		if (totalCount > 0) {
			List<Map<String, Object>> list = lnkMngService.selectLnkApiStaList(requestMap);
			model.addAttribute("list", list);					//메뉴목록
		}
	}
	
	/**
	 * 연계현황 목록조회 json
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectLnkHistList.json")
	public void selectLnkMngList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		log.debug("============ /selectLnkHistList.json > requestMap: {}", requestMap);
			
			//검색조건에 쓰일 연계기관, 연계명 정보
			model.addAttribute("instList", lnkMngService.selectLnkHistInstAndNm());
			
			/* ■■■■ PageNavigation 영역처리 - 1. 객체생성 ■■■■ */
			PagingVO pagingVO = new PagingVO(requestMap);

			int totalCount = lnkMngService.selectLnkHistListTotalCount(requestMap);
		
			/* ■■■■ PageNavigation 영역처리 - 2. 총건수 설정 ■■■■ */
			pagingVO.setTotalCount(totalCount);

			/* ■■■■ PageNavigation 영역처리 - 3. 페이징구간 설정 ■■■■ */
			requestMap.put("startNo", pagingVO.getStartNo());
	        requestMap.put("endNo", pagingVO.getEndNo());
	        requestMap.put("listCount", pagingVO.getListCount()); // pageSize 대신 사용하여 페이징 구간 설정

			/* ■■■■ PageNavigation 영역처리 - 4. 페이징정보 반환 ■■■■ */
			model.addAttribute("pagingVO", pagingVO);

			/* ■■■■ PageNavigation 영역처리 - 5. 총건수에 대한 선택적 조회 ■■■■ */
			if (totalCount > 0) {
				List<Map<String, Object>> list = lnkMngService.selectLnkHistList(requestMap);
				model.addAttribute("list", list);					//메뉴목록
			}
		
	}
	
	/**
	 * 연계 통계 목록조회 json
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectlnkStatList.json")
	public void selectlnkStatList(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception{
		log.debug("============ /selectlnkStatList.json > requestMap: {}", requestMap);
		
		
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCount = lnkMngService.selectLnkStatTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);
		
		
		model.addAttribute("pagingVO", pagingVO);
		model.addAttribute("instList",lnkMngService.selectLnkInstList());
		
		if(totalCount > 0) {
			List<Map<String, Object>> list = lnkMngService.selectLnkStatList(requestMap);
			model.addAttribute("list", list);
		}
		
	}
	
	
	
	
}
