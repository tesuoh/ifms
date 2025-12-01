package ifms.sample.file.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/adm/sample")
public class FileUpload {
	
	public Log logger = LogFactory.getLog(this.getClass());
	
	@PostMapping("/UpDownloadSample.do")
	public void uploadFile(@RequestParam Map<String, Object> requestMap, ModelMap model) throws Exception {
		Map<String, Object> detail = new HashMap<>();

        detail.put("popupSn", 129);
        detail.put("popupTtl", "테스트1");
        detail.put("popupBgngDt", "2025-09-26");
        detail.put("popupEndDt", "2025-09-26");
        detail.put("popupSzSeCd", "Basic");
        detail.put("frstRegDt", "2025-09-26");
        detail.put("fileGroupSn", 20479);
        detail.put("atchFileUrlAddr", "/Users/yangcheolseung/data/file/real/adm/202509");
        detail.put("orgnlFileNm", "233D5D3952CF365C21");
        detail.put("orgnlFileExtnNm", "jpeg");
        detail.put("atchFileSz", 149699);
        detail.put("fileDtlSn", 1);
        detail.put("srvrFileNm", "ffe5ea3231c2461f961a0a672f3e125b");
        detail.put("fileFullPath", "/Users/yangcheolseung/data/file/real/adm/202509/233D5D3952CF365C21.jpeg");
        detail.put("sysClsfCd", "ptl");
        
        model.addAttribute("detail", detail);
	}
}
