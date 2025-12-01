package ifms.common.util;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import ifms.cmn.util.IfmsGlobalsUtil;
import ifms.common.file.vo.FileVO;

import java.util.UUID;

@Component
public class FileUtil {

    public final static Log logger = LogFactory.getLog(FileUtil.class);

    @Autowired
    private IfmsGlobalsUtil ifmsGlobalsUtil;

    /**
     * 파일명 추출하기
     *
     * @param originalFilename 원본파일명
     * @return
     */
    public static String getFilename(String originalFilename) {
        int lastIndex = originalFilename.lastIndexOf(".");
        String newFilename = lastIndex >= 0 ? originalFilename.substring(0, lastIndex) : originalFilename;

        return newFilename;
    }

    /**
     * 파일확장자 추출하기 - 구분자 [.] 포함
     *
     * @param originalFilename 원본파일명
     * @return
     */
    public String getFilenameExtension(String originalFilename) {
        return FileUtil.getFilenameExtension(originalFilename, true);
    }

    /**
     * 파일확장자 추출하기
     *
     * @param originalFilename 원본파일명
     * @param b                구분자 [.] 포함 여부
     * @return
     */
    public static String getFilenameExtension(String originalFilename, boolean b) {
        String extension = null;

        int lastIndex = originalFilename.lastIndexOf(".");
        if (b) { // 구분자 [.] 포함
            extension = lastIndex >= 0 ? originalFilename.substring(lastIndex) : "";
        } else { // 구분자 [.] 미포함
            extension = lastIndex >= 0 ? originalFilename.substring(lastIndex + 1) : "";
        }

        return extension;
    }

    /**
     * 파일업로드용 파일명 생성하기 - UUID
     *
     * @param originalFilename 원본파일명
     * @return
     */
    public static String getTempFilename(String originalFilename) {
        return UUID.randomUUID().toString().replace("-", "");
    }


    /**
     * 파일업로드 FileVO 정보 생성하기 - 임시파일 업로드
     *
     * @param multipartFile
     * @param repository
     * @return
     * @throws Exception
     */
    public FileVO getFileVO(MultipartFile multipartFile, String repository) throws Exception {
        String originalFilename = multipartFile.getOriginalFilename();

        String filename = FileUtil.getFilename(originalFilename); // 원본파일명
        String tempFilename = FileUtil.getTempFilename(originalFilename); // 임시파일명
        String extension = FileUtil.getFilenameExtension(originalFilename, false);
        //String filePath = FilePath.getFilePath(repository); // 파일경로

        String filePath = "";
        if (repository == null) {
            filePath = ifmsGlobalsUtil.getProperties("TEMP_PATH");
        } else if (repository.equals("adm")){
            filePath = ifmsGlobalsUtil.getProperties("REAL_PATH");
        } else if (repository.equals("gov")) {
            filePath = ifmsGlobalsUtil.getProperties("REAL_PATH");
        } else if (repository.equals("biz")) {
            filePath = ifmsGlobalsUtil.getProperties("REAL_PATH");
        }

        /* 파일정보 생성하기 */
        FileVO vo = new FileVO();
        vo.setOrgnlFileNm(filename); // 원본파일명
        vo.setFilePath(filePath); // 파일 경로
        vo.setFileNm(tempFilename); // 파일 명
        vo.setFileSz(String.valueOf(multipartFile.getSize())); // 파일 크기
        vo.setFileExtnNm(extension); // 파일확장자명

        return vo;
    }

}
