package ifms.emma.web;

import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import ifms.emma.service.EmmaService;

/**
 * EMMA 문자 전송 테스트 Controller
 */
@Controller
public class EmmaSmsController {

	private final Log logger = LogFactory.getLog(this.getClass());

	@Autowired(required = false)
	private EmmaService emmaService;

	/**
	 * 문자 전송 테스트 화면
	 */
	@RequestMapping(value = "/cmn/app/sms/smssendtest.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String smsSendTest(ModelMap model) {
		return "cmn/app/sms/smsrsendtest";
	}

	/**
	 * 문자 발송 API
	 */
	@PostMapping(value = "/cmn/app/sms/send.json")
	public ResponseEntity<Map<String, Object>> sendSms(@RequestBody Map<String, Object> requestMap) {
		try {
			String orgNum = (String) requestMap.get("orgNum");
			String dstNum = (String) requestMap.get("dstNum");
			String message = (String) requestMap.get("message");

			Map<String, Object> result = emmaService.sendSmsMessage(orgNum, dstNum, message);
			return ResponseEntity.ok(result);
		} catch (Exception e) {
			logger.error("문자 발송 중 오류 발생", e);
			Map<String, Object> errorResult = new HashMap<>();
			errorResult.put("success", false);
			errorResult.put("message", "문자 발송 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.ok(errorResult);
		}
	}
}
