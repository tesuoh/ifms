package ifms.common.util;

import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

@Component
public class FilePath {

    public final static String ROOT_PATH = "/data/file";										//File Repository Root

    public final static String TEMP_PATH = ROOT_PATH + "/temporary";							//파일업로드 Temp 경로
    public final static String REAL_PATH_BIZ = ROOT_PATH + "/real/biz";							//파일업로드 Real 경로
    public final static String REAL_PATH_GOV = ROOT_PATH + "/real/gov";							//파일업로드 Real 경로
    public final static String REAL_PATH_ADM = ROOT_PATH + "/real/adm";							//파일업로드 Real 경로

    public final static String getFilePath(String repository) throws Exception {
        String filePath = null;									//파일경로

        if(StringUtils.isEmpty(repository)) {
            filePath = FilePath.TEMP_PATH;						/* 임시저장 경로 */
        } else if("biz".equals(repository)) {
            filePath = FilePath.REAL_PATH_BIZ;
        } else if("gov".equals(repository)) {
            filePath = FilePath.REAL_PATH_GOV;
        } else if("adm".equals(repository)) {
            filePath = FilePath.REAL_PATH_ADM;
        } else {
            throw new Exception("Not Found Repository");
        }

        return filePath;
    }
}

