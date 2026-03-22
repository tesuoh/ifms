package ifms.adm.bat.usr.dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CommonDao {

    @Autowired
    private SqlSession sqlSession;

    public int update(String mapperId, Object param) {
        return sqlSession.update(mapperId, param);
    }

    public <E> List<E> selectList(String mapperId, Object param) {
        return sqlSession.selectList(mapperId, param);
    }

    public <T> T selectOne(String mapperId, Object param) {
        return sqlSession.selectOne(mapperId, param);
    }
}