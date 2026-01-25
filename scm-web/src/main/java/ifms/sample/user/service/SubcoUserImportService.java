package ifms.sample.user.service;

import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import ifms.sample.user.mapper.SubcoUserImportMapper;

@Service
public class SubcoUserImportService {
	
	public final Log logger = LogFactory.getLog(this.getClass());
	
	@Autowired
	private SubcoUserImportMapper subcoUserImportMapper;
	
	public int existsScmUser(@Param("lgnId") String lgnId) throws Exception {
		return subcoUserImportMapper.existsScmUser(lgnId);
	}
	
	public String selectUserIdByLgnId(@Param("lgnId") String lgnId) throws Exception {
		return subcoUserImportMapper.selectUserIdByLgnId(lgnId);
	}
	
	public String selectUserId() throws Exception {
		return subcoUserImportMapper.selectUserId();
	}
	
	public int insertScmUser(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.insertScmUser(paramMap);
		
	}
	
	public int updateScmUser(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.updateScmUser(paramMap);
	}
	
	public int existsScmUserSubco(@Param("lgnId") String lgnId) throws Exception {
		return subcoUserImportMapper.existsScmUserSubco(lgnId);
	}
	
	public Map<String, Object> selectScmUserSubcoPrtc(@Param("lgnId") String lgnId) throws Exception {
		return subcoUserImportMapper.selectScmUserSubcoPrtc(lgnId);
	}
	
	public int insertScmUserSubco(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.insertScmUserSubco(paramMap);
	}
	
	public int updateScmUserSubco(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.updateScmUserSubco(paramMap);
	}
	
	public int insertUserPrtc(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.insertUserPrtc(paramMap);
	}
	
	public int updateUserPrtc(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.updateUserPrtc(paramMap);
	}
	
	public Map<String, Object> selectCoopPrtlUserPrtc(String userId, String encryptKey) throws Exception {
		return subcoUserImportMapper.selectCoopPrtlUserPrtc(userId, encryptKey);
	}
	
	public Map<String, Object> selectMblTelUserPrtc(String userId, String encryptKey) throws Exception {
		return subcoUserImportMapper.selectMblTelUserPrtc(userId, encryptKey);
	}
	
	public Map<String, Object> selectUserContact(String userId, String encryptKey) throws Exception {
		return subcoUserImportMapper.selectUserContact(userId, encryptKey);
	}

}
