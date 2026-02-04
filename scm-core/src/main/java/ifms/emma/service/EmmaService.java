package ifms.emma.service;

import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.emma.mapper.EmmaMapper;

/**
 * EMMA SMS 발송 서비스
 * @author yangcheolseung
 * 
 */

@Service
public class EmmaService {
	
	@Autowired
	EmmaMapper emmaMapper;
	
	// SMS 메시지 최대 길이 (바이트 단위, 한글 기준 약 40자)
	private static final int SMS_MAX_BYTE_LENGTH = 80;
	
	// 전화번호 패턴 (일반 전화번호: 02, 031 등 지역번호 포함) - 숫자만
	private static final Pattern PHONE_NUMBER_PATTERN = Pattern.compile("^0[2-6][0-9]?[0-9]{7,8}$");
	
	// 휴대폰 번호 패턴 (010, 011, 016, 017, 018, 019) - 숫자만
	private static final Pattern MOBILE_NUMBER_PATTERN = Pattern.compile("^01[016789][0-9]{7,8}$");
	
	/**
	 * SMS 메시지 발송
	 * @param orgNum 발신 전화번호
	 * @param dstNum 수신 휴대폰 번호
	 * @param message SMS 메시지
	 * @return 결과 Map (success: 성공여부, message: 결과메시지)
	 */
	public Map<String, Object> sendSmsMessage(String orgNum, String dstNum, String message) {
		
		Map<String, Object> result = new HashMap<>();
		
		// 유효성 검사
		String validationError = validateAll(orgNum, dstNum, message);
		if (validationError != null) {
			result.put("success", false);
			result.put("message", validationError);
			return result;
		}
		
		Map<Object, String> paramMap = new HashMap<>();
		
		paramMap.put("callback", orgNum);
		paramMap.put("recepientNum", dstNum);
		paramMap.put("content", message);
		
		emmaMapper.insertEmSmtTran(paramMap);
		
		result.put("success", true);
		result.put("message", "SMS 발송 요청이 완료되었습니다.");
		return result;
	}
	
	/**
	 * 모든 유효성 검사 수행
	 * @param orgNum 발신 전화번호
	 * @param dstNum 수신 휴대폰 번호
	 * @param message SMS 메시지
	 * @return 오류 메시지 (유효하면 null)
	 */
	private String validateAll(String orgNum, String dstNum, String message) {
		String error;
		
		error = validateOrgNum(orgNum);
		if (error != null) return error;
		
		error = validateDstNum(dstNum);
		if (error != null) return error;
		
		error = validateMessage(message);
		if (error != null) return error;
		
		return null;
	}
	
	/**
	 * 발신 전화번호 유효성 검사
	 * @param orgNum 발신 전화번호
	 * @return 오류 메시지 (유효하면 null)
	 */
	private String validateOrgNum(String orgNum) {
		if (orgNum == null || orgNum.trim().isEmpty()) {
			return "발신 전화번호는 필수 입력값입니다.";
		}
		
		// 하이픈 제거 후 검증
		String cleanedNum = orgNum.replaceAll("-", "");
		
		// 전화번호 또는 휴대폰 번호 형식 모두 허용
		if (!PHONE_NUMBER_PATTERN.matcher(cleanedNum).matches() && 
			!MOBILE_NUMBER_PATTERN.matcher(cleanedNum).matches()) {
			return "발신 전화번호 형식이 올바르지 않습니다. (예: 02-1234-5678, 0212345678, 010-1234-5678, 01012345678)";
		}
		
		return null;
	}
	
	/**
	 * 수신 휴대폰 번호 유효성 검사
	 * @param dstNum 수신 휴대폰 번호
	 * @return 오류 메시지 (유효하면 null)
	 */
	private String validateDstNum(String dstNum) {
		if (dstNum == null || dstNum.trim().isEmpty()) {
			return "수신 휴대폰 번호는 필수 입력값입니다.";
		}
		
		// 하이픈 제거 후 검증
		String cleanedNum = dstNum.replaceAll("-", "");
		
		if (!MOBILE_NUMBER_PATTERN.matcher(cleanedNum).matches()) {
			return "수신 휴대폰 번호 형식이 올바르지 않습니다. (예: 010-1234-5678, 01012345678)";
		}
		
		return null;
	}
	
	/**
	 * SMS 메시지 유효성 검사
	 * @param message SMS 메시지
	 * @return 오류 메시지 (유효하면 null)
	 */
	private String validateMessage(String message) {
		if (message == null || message.trim().isEmpty()) {
			return "메시지 내용은 필수 입력값입니다.";
		}
		
		int byteLength = getByteLength(message);
		if (byteLength > SMS_MAX_BYTE_LENGTH) {
			return String.format("메시지 길이가 초과되었습니다. (현재: %d바이트, 최대: %d바이트)", byteLength, SMS_MAX_BYTE_LENGTH);
		}
		
		return null;
	}
	
	/**
	 * 문자열의 바이트 길이 계산 (EUC-KR 기준: 한글 2바이트, 영문/숫자 1바이트)
	 * @param str 문자열
	 * @return 바이트 길이
	 */
	private int getByteLength(String str) {
		int byteLength = 0;
		for (char c : str.toCharArray()) {
			if (c >= 0x0000 && c <= 0x007F) {
				// ASCII (영문, 숫자, 특수문자)
				byteLength += 1;
			} else {
				// 한글 및 기타 문자
				byteLength += 2;
			}
		}
		return byteLength;
	}
}
