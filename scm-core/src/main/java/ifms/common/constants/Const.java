package ifms.common.constants;

import java.lang.reflect.Field;
import java.nio.ByteBuffer;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class Const {

    public final static Log logger = LogFactory.getLog(Const.class);

    public final static String SYS_SE_CD_SYE010 = "SYE010";			// PTL
    public final static String SYS_SE_CD_SYE020 = "SYE020";			// BIZ
    public final static String SYS_SE_CD_SYE030 = "SYE030";			// ADM

    public final static String USER_GROUP_CD_UGC010 = "UGC010";		// 대민
    public final static String USER_GROUP_CD_UGC020 = "UGC020";		// 지자체
    public final static String USER_GROUP_CD_UGC030 = "UGC030";		// 사업체
    public final static String USER_GROUP_CD_UGC040 = "UGC040";		// 행정
    public final static String USER_GROUP_CD_UGC050 = "UGC050";		// 행정청
    public final static String USER_GROUP_CD_UGC060 = "UGC060";		// 행정부


    public final static String USER_ROLE_CD_URC101 = "ROL_PTL_0101";        //[PTL] 대국민
    public final static String USER_ROLE_CD_URC102 = "ROL_BIZ_0201";        //[BIZ] 경찰청
    public final static String USER_ROLE_CD_URC103 = "ROL_BIZ_0202";        //[BIZ] 지방경찰청
    public final static String USER_ROLE_CD_URC104 = "ROL_BIZ_0203";        //[BIZ] 경찰서
    public final static String USER_ROLE_CD_URC105 = "ROL_BIZ_0301";        //[BIZ] 시도
    public final static String USER_ROLE_CD_URC106 = "ROL_BIZ_0302";        //[BIZ] 시군구
    public final static String USER_ROLE_CD_URC107 = "ROL_BIZ_0303";        //[BIZ] 실태조사
    public final static String USER_ROLE_CD_URC108 = "ROL_BIZ_0401";        //[BIZ] 행안부
    public final static String USER_ROLE_CD_URC109 = "ROL_BIZ_0402";        //[BIZ] 행정개발용

    public final static String USER_ROLE_CD_URC301 = "ROL_ADM_0101";        //[ADM] 보호구역 시스템 관리자
    public final static String USER_ROLE_CD_URC302 = "ROL_ADM_0102";        //[ADM] 경찰청 시스템 관리자


    public final static Map<String, Object> constMap() {
        final Map<String, Object> fieldsMap = new HashMap<String, Object>();
        final Field[] fields = Const.class.getFields(); // the Constants class.

        int i = 0;
        try {
            for (i = 0; i < fields.length; i++) {
                fieldsMap.put(fields[i].getName(), fields[i].get(null));
            }
        } catch (final IllegalAccessException ex) {
            logger.debug("IllegalAccessException");
        }

        return fieldsMap;
    }
}
