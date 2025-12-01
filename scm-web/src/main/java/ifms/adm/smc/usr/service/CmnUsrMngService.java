package ifms.adm.smc.usr.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.smc.usr.mapper.CmnUsrMngMapper;
/**
 * 사용자 관리
 * @author seryeong
 *
 */
@Service
public class CmnUsrMngService {
	
	private final Logger log = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private CmnUsrMngMapper cmnUsrMngMapper;
	
	/**
	 * 사용자 관리 목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int usrMngTotalCount(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.usrMngTotalCount(requestMap);
	}
	
	/**
	 * 기관목록 총건수
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int instTotalCount(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.instTotalCount(requestMap);
	}
	
	/**
	 * 사용자 관리 목록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectUsrMngList(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.selectUsrMngList(requestMap);
	}
	
	/**
	 * 사용자 관리 상세
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public Map<String, Object> selectUsrMngDetail(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.selectUsrMngDetail(requestMap);
	}
	
	/**
	 * 기관 검색
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>> selectInstList(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.selectInstList(requestMap);
	}
	
	/**
	 * 아이디 중복 확인
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public boolean validDuplicatedId(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.validDuplicatedId(requestMap);
	}
	
	/**
	 * 권한그룹 조회
	 * @return
	 * @throws Exception
	 */
	public List<Map<String, Object>>  selectAuthrtInfo() throws Exception{
		return cmnUsrMngMapper.selectAuthrtInfo();
	}
	
	/**
	 * 사용자 등록
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public int insertUsrInfo(Map<String, Object> requestMap) throws Exception{
		String userPswd = requestMap.get("userPswd").toString().trim();
		
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        String encodedPassword = passwordEncoder.encode(userPswd);
		
        log.debug("사용자 정보 생성 service > encodedPassword: {}", encodedPassword);
        
        requestMap.put("userPswd", encodedPassword);
        
		return cmnUsrMngMapper.insertUsrInfo(requestMap);
	}
	
	/**
	 * 사용자 정보 변경
	 * @param requestMap
	 * @return
	 * @throws Exception
	 */
	public boolean updateUsrInfo(Map<String, Object> requestMap) throws Exception{
		int result = 0;
		
		
		Map<String, Object> orgnlUserInfo = (Map<String, Object>) requestMap.get("orgnlUserInfo");
		Map<String, Object> newUserInfo = (Map<String, Object>) requestMap.get("newUserInfo");
		String lgnId = requestMap.get("lastMdfrId").toString();
		
		newUserInfo.put("lastMdfrId", lgnId);
		
		//변경 전 이력 생성
		result += cmnUsrMngMapper.insertUserChgHistory(orgnlUserInfo);
		
		String type = newUserInfo.get("type").toString();
		if(type.equals("others")) {
			//비밀번호 제외 정보 변경
			result +=  cmnUsrMngMapper.updateOthers(newUserInfo);
		}
		else {
			//비밀번호 변경
			//비밀번호 변경
			String userPswd = newUserInfo.get("userPswd").toString();
			
			BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	        String encodedPassword = passwordEncoder.encode(userPswd);
			
	        log.debug("비밀번호 변경 service > encodedPassword: {}", encodedPassword);
	        
	        newUserInfo.put("userPswd", encodedPassword);
	        result +=  cmnUsrMngMapper.updatePswd(newUserInfo);
		}

		return result == 2 ? true : false;
	}
	
	/**
	 * 비밀번호 오류 초기화
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public int resetUserPswd(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.resetUserPswd(requestMap);
	}
	
	/**
	 * 사용자 사용정지
	 * @param userId
	 * @return
	 * @throws Exception
	 */
	public int suspendedUser(Map<String, Object> requestMap) throws Exception{
		return cmnUsrMngMapper.suspendedUser(requestMap);
	}
	
}
