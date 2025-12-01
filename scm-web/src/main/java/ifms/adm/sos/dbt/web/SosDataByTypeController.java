package ifms.adm.sos.dbt.web;

import java.util.List;
import java.util.Map;

import org.apache.commons.compress.harmony.unpack200.bytecode.forms.ThisFieldRefForm;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import ifms.adm.sos.dbt.service.SosDataByTypeService;
import ifms.common.util.PagingVO;

/**
 * 유형별 데이터 조회
 * @author seryeong
 *
 */
@Controller
@RequestMapping("/adm/sos/dbt")
public class SosDataByTypeController {

	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private SosDataByTypeService sosDataByTypeService;
	
	@PostMapping("/dataByTypeList.do")
	public void dataByTypeList() {}
	
	/**
	 * 목록 조회
	 * @param authentication
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/selectDataByTypeList.json")
	public void selectDataByTypeList(Authentication authentication, @RequestBody Map<String, Object> requestMap
				, ModelMap model) throws Exception{
		
		//페이징
		PagingVO pagingVO = new PagingVO(requestMap);
		
		int totalCount = sosDataByTypeService.selectDbtListTotalCount(requestMap);
		pagingVO.setTotalCount(totalCount);

		requestMap.put("startNo", pagingVO.getStartNo());
		requestMap.put("endNo", pagingVO.getEndNo());
		requestMap.put("listCount", pagingVO.getListCount());
		
		log.debug("======================== pagingVO : {}", pagingVO);
		model.addAttribute("pagingVO", pagingVO);
		
		//테이블 목록
		if(totalCount > 0) {
			List<Map<String, Object>> selectDbtList = sosDataByTypeService.selectDbtList(requestMap);
			log.debug("======================== selectDbtList : {}", selectDbtList);
			
			model.addAttribute("list", selectDbtList);
		}
	}
}
