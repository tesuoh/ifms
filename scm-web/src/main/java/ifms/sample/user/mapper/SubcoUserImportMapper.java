package ifms.sample.user.mapper;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface SubcoUserImportMapper {
	boolean existsScmUser(@Param("lgnId") String lgnId) throws Exception;
	String selectUserIdByLgnId(@Param("lgnId") String lgnId) throws Exception;
	String selectUserId() throws Exception;
	int insertScmUser(Map<String, Object> paramMap) throws Exception;
	int updateScmUser(Map<String, Object> paramMap) throws Exception;
	boolean existsScmUserParco(@Param("parcoUserId") String parcoUserId) throws Exception;
	int insertScmUserParco(Map<String, Object> paramMap) throws Exception;
	int updateScmUserParco(Map<String, Object> paramMap) throws Exception;
	int insertUserContact(Map<String, Object> paramMap) throws Exception;
	Map<String, Object> selectUserContact(@Param("userId") String userId, @Param("encryptKey") String encryptKey) throws Exception;
}
