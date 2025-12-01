package ifms.adm.mod.web;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import ifms.adm.mod.service.CmnModSrcGenService;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

@Controller
@RequestMapping(value="/adm/mod")
public class CmnModSrcGenController {

    @Autowired
    CmnModSrcGenService cmnModSrcGenService;


    public final Log logger = LogFactory.getLog(this.getClass());

    @RequestMapping(value = "/cmnModSrcGen.do", method = {RequestMethod.GET, RequestMethod.POST})
    public void cmnModSrcGen(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("[" + this.getClass().getName() + "][cmnModSrcGen] START");

        // 처리 로직

        logger.debug("[" + this.getClass().getName() + "][cmnModSrcGen] END");
    }


    @PostMapping("/cmnModSrcGenerate.json")
    public String generateSource(@RequestBody Map<String,Object> params, HttpServletRequest request, Model model) {
        String packagePath = (String) params.get("packagePath");
        String entityName = (String) params.get("entityName");
        String comment = (String) params.get("comment");
        String tableName = (String) params.get("tableName");

        // Service를 통해 코드 생성
        Map<String, String> resultMap = cmnModSrcGenService.generateCode(packagePath, entityName, comment, tableName);

        // JSP에 생성된 코드 출력
        model.addAttribute("controllerCode", resultMap.get("controller"));
        model.addAttribute("serviceCode", resultMap.get("service"));
        model.addAttribute("mapperCode", resultMap.get("mapper"));
        model.addAttribute("xmlCode", resultMap.get("xml"));
        model.addAttribute("jspListCode", resultMap.get("jspList"));

        return "cmnModSrcGen"; // 기존 JSP 페이지로 Forward 또는 별도의 결과 페이지
    }




    @GetMapping(value = "/cmnModSrcGenHistList.do")
    public void cmnModSrcGenHistList(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnModSrcGenHistList] START");

        logger.debug("["+this.getClass().getName()+"][cmnModSrcGenHistList] END");
    }

    @GetMapping(value = "/cmnModSrcGenHistDtl.do")
    public void cmnModSrcGenHistDtl(HttpServletRequest request, ModelMap model) throws Exception {
        logger.debug("["+this.getClass().getName()+"][cmnModSrcGenHistDtl] START");

        logger.debug("["+this.getClass().getName()+"][cmnModSrcGenHistDtl] END");
    }

}
