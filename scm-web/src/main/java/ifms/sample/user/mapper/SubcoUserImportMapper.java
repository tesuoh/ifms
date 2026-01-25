package ifms.sample.user.mapper;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SubcoUserImportMapper {
	int existsScmUser(@Param("lgnId") String lgnId) throws Exception;
	String selectUserIdByLgnId(@Param("lgnId") String lgnId) throws Exception;
	String selectUserId() throws Exception;
	int insertScmUser(Map<String, Object> paramMap) throws Exception;
	int updateScmUser(Map<String, Object> paramMap) throws Exception;
	int existsScmUserSubco(@Param("lgnId") String lgnId) throws Exception;
	Map<String, Object> selectScmUserSubcoPrtc(@Param("lgnId") String lgnId) throws Exception;
	int insertScmUserSubco(Map<String, Object> paramMap) throws Exception;
	int updateScmUserSubco(Map<String, Object> paramMap) throws Exception;
	int insertUserPrtc(Map<String, Object> paramMap) throws Exception;
	int updateUserPrtc(Map<String, Object> paramMap) throws Exception;
	int insertUserContact(Map<String, Object> paramMap) throws Exception;
	Map<String, Object> selectCoopPrtlUserPrtc(@Param("userId") String userId, @Param("encryptKey") String encryptKey) throws Exception;
	Map<String, Object> selectMblTelUserPrtc(@Param("userId") String userId, @Param("encryptKey") String encryptKey) throws Exception;
	Map<String, Object> selectUserContact(@Param("userId") String userId, @Param("encryptKey") String encryptKey) throws Exception;
}
