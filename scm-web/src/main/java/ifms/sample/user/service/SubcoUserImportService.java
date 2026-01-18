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
	
	public boolean existsScmUser(@Param("lgnId") String lgnId) throws Exception {
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
	
	public boolean existsScmUserParco(@Param("parcoUserId") String parcoUserId) throws Exception {
		return subcoUserImportMapper.existsScmUserParco(parcoUserId);
	}
	
	public int insertScmUserParco(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.insertScmUserParco(paramMap);
	}
	
	public int updateScmUserParco(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.updateScmUserParco(paramMap);
	}
	
	public int insertUserContact(Map<String, Object> paramMap) throws Exception {
		return subcoUserImportMapper.insertUserContact(paramMap);
	}
	
	public Map<String, Object> selectUserContact(String userId, String encryptKey) throws Exception {
		return subcoUserImportMapper.selectUserContact(userId, encryptKey);
	}

}
