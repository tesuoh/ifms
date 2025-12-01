package ifms.common.util;

import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.util.StringUtils;


public class PagingUtil {

    public final Log logger = LogFactory.getLog(this.getClass());

    /**
     * 페이징 건수 조회
     * @param 공통페이징 총건수
     * @return
     */
    public final static int getPagingCount(List<Map<String, Object>> list) {
        int count = 0;
        if (StringUtils.isEmpty(list) == false && list.size() > 0) {
            count = Integer.parseInt(String.valueOf(list.get(0).get("ttcn")));
        }

        return count;
    }

    /**
     * 리스트 건수 조회
     * @param list 건수
     * @return
     */
    public final static int getListCount(List<?> list) {
        int count = 0;

        if (StringUtils.isEmpty(list) == false) {
            count = list.size();
        }

        return count;
    }


}