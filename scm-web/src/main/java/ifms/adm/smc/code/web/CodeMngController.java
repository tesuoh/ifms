package ifms.adm.smc.code.web;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.collections4.MapUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;

import ifms.adm.smc.code.service.CodeMngService;
import ifms.adm.smc.code.vo.CodeDtlMngVO;
import ifms.adm.smc.code.vo.CodeMngVO;
import ifms.cmn.support.Create;
import ifms.common.constants.Const;
import ifms.common.util.CommonUtils;
import ifms.common.util.PagingVO;
import ifms.core.aop.CoreException;


@Controller
@RequestMapping(value = "/adm/smc/code")
public class CodeMngController {
	
	public final Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private CodeMngService codeMngService;
	
	@Resource(name="messageSource")
	MessageSource messageSource;
	
	/**
	 * 공통코드 관리 메인
	 * @param modelMap
	 * @throws Exception
	 */
	@RequestMapping("/codeMng.do")
	public void selectCodeMng(ModelMap modelMap) throws Exception {
		modelMap.addAttribute(Const.DYNAMIC_ID_1, CommonUtils.generateDynamicId());
		modelMap.addAttribute(Const.DYNAMIC_ID_2, CommonUtils.generateDynamicId());
		modelMap.addAttribute(Const.DYNAMIC_ID_3, CommonUtils.generateDynamicId());
		modelMap.addAttribute(Const.DYNAMIC_ID_4, CommonUtils.generateDynamicId());
		modelMap.addAttribute("dynamicId5", CommonUtils.generateDynamicId());
		modelMap.addAttribute("dynamicId6", CommonUtils.generateDynamicId());
	}
	
	/**
	 * 공통코드 목롲 조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeMng_list.viw")
	public void selectCodeMng(@RequestBody Map<String, Object> requestMap, ModelMap model) throws Exception {
		Map<String, Object> _requestMap = MapUtils.emptyIfNull(requestMap);
		
		PagingVO pagingVO = new PagingVO(_requestMap);
		int totCnt = codeMngService.selectCodeListTotCnt(_requestMap);
		pagingVO.setTotalCount(totCnt);
		model.addAttribute(Const.PAGING_VO, pagingVO);
		List<Map<String, Object>> codeList = codeMngService.selectCodeList(_requestMap);
		model.addAttribute(Const.RESULT_LIST, (codeList == null) ? Collections.emptyList() : codeList);
	}
	
	/**
	 * 공통코드 등록
	 * @param codeMngVO
	 * @throws Exception
	 */
	@PostMapping("/codeMng.add")
	public void inserCode(@Validated({Create.class}) @RequestBody CodeMngVO codeMngVO) throws Exception {
		
		int existCode = codeMngService.selectExistCode(codeMngVO);
		
		if (existCode > 0) {
			throw new CoreException(messageSource.getMessage("message.warning.code.exstMsg", null, LocaleContextHolder.getLocale()));
		}
		
		codeMngService.insertCodeMng(codeMngVO);
	}
	
	/**
	 * 공통코드 상세조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeMng_detail.viw")
	public void selectCodeDetail(@RequestBody(required = false) Map<String, Object> requestMap, ModelMap model) throws Exception {
		
		List<Map<String, Object>> detail = codeMngService.selectCodeDetail(requestMap);
		
		model.addAttribute(Const.RESULT_DETAIL, detail);
	}
	
	/**
	 * 공통코드 삭제
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeMng.del")
	public void deleteCodeMngDetail(@RequestBody(required = false) Map<String, Object> requestMap, ModelMap model) throws Exception {
		
		codeMngService.deleteCodeDetail(requestMap);
		
		model.addAllAttributes(Const.RESULT_DETAIL);
	}
	
	/**
	 * 공통코드 수정
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeMng.edt")
	public void editCodeMngDetail(@RequestBody(required = false) Map<String, Object> requestMap, ModelMap model) throws Exception {
		
		codeMngService.editCodeDetail(requestMap);
		
		model.addAllAttributes(Const.RESULT_DETAIL);
	}
	
	/**
	 * 상세코드 관리 메인
	 * @param modelMap
	 * @throws Exception
	 */
	@RequestMapping("/codeDtlMng.do")
	public void selectCodeDtlMng(ModelMap modelMap) throws Exception {
		modelMap.addAttribute(Const.DYNAMIC_ID_1, CommonUtils.generateDynamicId());
		modelMap.addAttribute(Const.DYNAMIC_ID_2, CommonUtils.generateDynamicId());
	}
	
	/**
	 * 상세코드 등록
	 * @param codeMngVO
	 * @throws Exception
	 */
	@PostMapping("/codeDtlMng.add")
	public void inserCodeDtl(@Validated({Create.class}) @RequestBody CodeDtlMngVO codeDtlMngVO) throws Exception {
		
		int existCode = codeMngService.selectExistCodeDtl(codeDtlMngVO);
		
		if (existCode > 0) {
			throw new CoreException(messageSource.getMessage("message.warning.code.existDtlMsg", null, LocaleContextHolder.getLocale()));
		}
		
		codeMngService.insertCodeDtlMng(codeMngVO);
	}
	
	/**
	 * 상세코드 상세조회
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeDtlMng_detail.viw")
	public void selectCodeDtlDetail(@RequestBody(required = false) Map<String, Object> requestMap, ModelMap model) throws Exception {
		
		List<Map<String, Object>> detail = codeMngService.selectCodeDtlDetail(requestMap);
		
		model.addAttribute(Const.RESULT_DETAIL, detail);
	}
	
	/**
	 * 상세코드 삭제
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeDelMng.del")
	public void deleteCodeDtlDetail(@RequestBody(required = false) Map<String, Object> requestMap, ModelMap model) throws Exception {
		
		codeMngService.deleteCodeDtlDetail(requestMap);
		
		model.addAllAttributes(Const.RESULT_DETAIL);
	}
	
	/**
	 * 상세코드 수정
	 * @param requestMap
	 * @param model
	 * @throws Exception
	 */
	@PostMapping("/codeDtlMng.edt")
	public void editCodeDtlDetail(@RequestBody(required = false) Map<String, Object> requestMap, ModelMap model) throws Exception {
		
		codeMngService.editCodeDtlDetail(requestMap);
		
		model.addAllAttributes(Const.RESULT_DETAIL);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	
	
	

}
