package ifms.report.core;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping("/ClipReport5")
public class ReportController {

    public final Log logger = LogFactory.getLog(this.getClass());

    @PostMapping(value = "/reportMain.report")
    public void reportMain(HttpServletRequest request, ModelMap model) throws Exception{
        logger.debug("["+this.getClass().getName()+"][ReportController.reportMain] START");

        logger.debug("["+this.getClass().getName()+"][ReportController.reportMain] END");
    }

}
