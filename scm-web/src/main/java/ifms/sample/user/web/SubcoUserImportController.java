package ifms.sample.user.web;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.sample.user.service.SubcoUserImportService;

@Controller
public class SubcoUserImportController {
	
	public Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private SubcoUserImportService subcoUserImportService;
	
	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;
	
	@RequestMapping(value="/cmn/app/user/parcouserimport.do", method = {RequestMethod.GET, RequestMethod.POST})
	public String parcoUserImport(ModelMap model) {
		return "cmn/app/user/parcoruserimport";
	}
	
	@PostMapping(value="/cmn/app/user/searchusercontact.json")
	public ResponseEntity<Map<String, Object>> searchUserContact(@RequestBody Map<String, Object> requestMap) {
		Map<String, Object> response = new HashMap<>();
		
		try {
			String userId = (String) requestMap.get("userId");
			if (userId == null || userId.trim().isEmpty()) {
				response.put("result", "error");
				response.put("message", "사용자 아이디를 입력해주세요.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
			
			String encryptKey = ifmsGlobalsUtil.getProperties("ENCRYPT_KEY");
			if (encryptKey == null || encryptKey.getBytes(StandardCharsets.UTF_8).length != 32) {
				response.put("result", "error");
				response.put("message", "암호화 키가 올바르지 않습니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
			
			Map<String, Object> userContact = subcoUserImportService.selectUserContact(userId, encryptKey);
			
			if (userContact == null || userContact.isEmpty()) {
				response.put("result", "error");
				response.put("message", "해당 사용자의 연락처 정보를 찾을 수 없습니다.");
				return ResponseEntity.status(HttpStatus.NOT_FOUND).body(response);
			}
			
			response.put("result", "success");
			response.put("email", userContact.get("email"));
			response.put("mobilephone", userContact.get("mobilephone"));
			return ResponseEntity.ok(response);
			
		} catch (Exception e) {
			logger.error("사용자 연락처 조회 중 오류 발생", e);
			response.put("result", "error");
			response.put("message", "사용자 연락처 조회 중 오류가 발생했습니다: " + e.getMessage());
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
		}
	}
	
	@PostMapping(value="/cmn/app/user/insertsubcouser.json")
	@Transactional(rollbackFor = Exception.class)
	public ResponseEntity<Map<String, Object>> insertUserData() {
		
		Map<String, Object> response = new HashMap<>();
		
		try {
			
			List<String[]> csvRows = readCsvRows("ifms/sample/user_data.csv");
			if (csvRows.size() <= 1) {
				response.put("result", "error");
				response.put("message", "CSV 데이터가 비어 있습니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
			
			String encryptKey = ifmsGlobalsUtil.getProperties("ENCRYPT_KEY");
			
			System.out.println("ENCRYPT_KEY raw=[" + encryptKey + "]");
			System.out.println("length(chars)=" + (encryptKey == null ? -1 : encryptKey.length()));
			System.out.println("length(bytes)=" + (encryptKey == null ? -1 : encryptKey.getBytes(StandardCharsets.UTF_8).length));
			
			if (encryptKey == null || encryptKey.getBytes(StandardCharsets.UTF_8).length != 32) {
				response.put("result", "error");
				response.put("message", "암호화 키가 32바이트가 아닙니다.");
				return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
			}
			
			BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
			
			int insertCount = 0;
			int updateCount = 0;
			
			for (int i = 1; i < csvRows.size(); i++) {
				String[] row = csvRows.get(i);
				if (row.length == 0) {
					continue;
				}
				
				String deptNm = getCell(row, 0);
				String deptCd = getCell(row, 1);
				String empNo = getCell(row, 2);
				String userNm = getCell(row, 3);
				String lgnId = getCell(row, 4);
				String mobile = getCell(row, 5);
				String portalId = getCell(row, 6);
				
				if (lgnId.isEmpty()) {
					continue;
				}
				
				boolean existsUser = subcoUserImportService.existsScmUser(lgnId);
				String userId = existsUser ? subcoUserImportService.selectUserIdByLgnId(lgnId) : "";
				
				Map<String, Object> userMap = new HashMap<>();
				userMap.put("userId", userId);
				userMap.put("userClsfCd", "PAR");
				userMap.put("lgnId", lgnId);
				userMap.put("userNm", userNm);
				userMap.put("empNo", empNo);
				userMap.put("crtUserId", "system");
				userMap.put("updtUserId", "system");
				
				if (existsUser) {
					subcoUserImportService.updateScmUser(userMap);
				} else {
					subcoUserImportService.insertScmUser(userMap);
					userId = userMap.get("userId") != null ? userMap.get("userId").toString() : "";
				}
				
				if (userId == null || userId.trim().isEmpty()) {
					response.put("result", "error");
					response.put("message", "user_id 생성에 실패했습니다.");
					return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
				}
				
				String mobileForPassword = mobile.replace("-", "");
				
				Long userContactId = null;
				
				if (!mobile.isEmpty() || !portalId.isEmpty()) {
					Map<String, Object> contactMap = new HashMap<>();
					contactMap.put("email", portalId);
					contactMap.put("mobilephone", mobile);
					contactMap.put("encryptKey", encryptKey);
					subcoUserImportService.insertUserContact(contactMap);
					
				    Object seqidObj = contactMap.get("seqid");
				    if (seqidObj instanceof Number) {
				        userContactId = ((Number) seqidObj).longValue();
				    }
				}
				
				Map<String, Object> parcoMap = new HashMap<>();
				parcoMap.put("userId", userId);
				parcoMap.put("parcoUserId", lgnId);
				parcoMap.put("userPswd", passwordEncoder.encode(mobileForPassword));
				parcoMap.put("userOrgnlId", lgnId);
				parcoMap.put("userNm", userNm);
				parcoMap.put("empNo", empNo);
				parcoMap.put("deptCd", deptCd);
				parcoMap.put("deptNm", deptNm);
				parcoMap.put("mblTelno", mobile);
				parcoMap.put("crtUserId", "system");
				parcoMap.put("updtUserId", "system");
				
				if (userContactId != null) {
				    parcoMap.put("userContactId", userContactId);
				}
				
				boolean existsParco = subcoUserImportService.existsScmUserParco(lgnId);
				if (existsParco) {
					subcoUserImportService.updateScmUserParco(parcoMap);
					updateCount++;
				} else {
					subcoUserImportService.insertScmUserParco(parcoMap);
					insertCount++;
				}
			}
			
			response.put("insertCount", insertCount);
			response.put("updateCount", updateCount);
			response.put("result", "success");
			return ResponseEntity.ok(response); 
			
		} catch (Exception e) {
			logger.error("사용자 데이터 처리 중 오류 발생", e);
			response.put("result", "error");
			response.put("message", "사용자 데이터 처리 중 오류가 발생했습니다: " + e.getMessage());
			
			throw new RuntimeException("사용자 데이터 처리 중 오류가 발생했습니다: " + e.getMessage(), e);
		}
	}
	
	private List<String[]> readCsvRows(String filePath) throws Exception {
		List<String[]> rows = new ArrayList<>();
		
		Path path = Paths.get(filePath);
		boolean isAbsolutePath = path.isAbsolute();
		
		if (isAbsolutePath || Files.exists(path)) {
			if (!Files.exists(path)) {
				throw new FileNotFoundException("파일을 찾을 수 없습니다: " + filePath);
			}
			
			try (BufferedReader reader = Files.newBufferedReader(path, StandardCharsets.UTF_8)) {
				String line;
				while ((line = reader.readLine()) != null) {
					line = line.trim();
					if (line.isEmpty()) {
						continue;
					}
					rows.add(parseCsvLine(line));
				}
			}
		} else {
			try (InputStream inputStream = this.getClass().getClassLoader().getResourceAsStream(filePath)) {
				if (inputStream == null) {
					throw new FileNotFoundException("클래스패스에서 리소스를 찾을 수 없습니다: " + filePath);
				}
				
				try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream, StandardCharsets.UTF_8))) {
					String line;
					while ((line = reader.readLine()) != null) {
						line = line.trim();
						if (line.isEmpty()) {
							continue;
						}
						rows.add(parseCsvLine(line));
					}
				}
			}
		}
		
		return rows;
	}
	
	private String[] parseCsvLine(String line) {
		String[] raw = line.split(",", -1);
		String[] cleaned = new String[raw.length];
		for (int i = 0; i < raw.length; i++) {
			cleaned[i] = normalizeCell(raw[i]);
		}
		return cleaned;
	}
	
	private String normalizeCell(String value) {
		if (value == null) {
			return "";
		}
		String trimmed = value.trim();
		if (!trimmed.isEmpty() && trimmed.charAt(0) == '\uFEFF') {
			trimmed = trimmed.substring(1);
		}
		return trimmed;
	}
	
	private String getCell(String[] row, int index) {
		if (row == null || row.length <= index) {
			return "";
		}
		return row[index] == null ? "" : row[index].trim();
	}
}
