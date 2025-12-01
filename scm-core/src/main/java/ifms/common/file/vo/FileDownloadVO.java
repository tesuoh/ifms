package ifms.common.file.vo;

public class FileDownloadVO {

    private String contentType;
    private String fileFullPath;
    private String orgnlFileNm;
    private String userAgent;
    private String downloadFileNm;
    private long fileLength;
    private boolean isAvailable;
    private FileVO fileVO;


    public String getContentType() {
        return contentType;
    }

    public void setContentType(String contentType) {
        this.contentType = contentType;
    }

    public String getFileFullPath() {
        return fileFullPath;
    }

    public void setFileFullPath(String fileFullPath) {
        this.fileFullPath = fileFullPath;
    }

    public String getOrgnlFileNm() {
        return orgnlFileNm;
    }

    public void setOrgnlFileNm(String orgnlFileNm) {
        this.orgnlFileNm = orgnlFileNm;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public String getDownloadFileNm() {
        return downloadFileNm;
    }

    public void setDownloadFileNm(String downloadFileNm) {
        this.downloadFileNm = downloadFileNm;
    }

    public long getFileLength() {
        return fileLength;
    }

    public void setFileLength(long fileLength) {
        this.fileLength = fileLength;
    }

    public boolean isAvailable() {
        return isAvailable;
    }

    public void setAvailable(boolean available) {
        isAvailable = available;
    }

    public FileVO getFileVO() {
        return fileVO;
    }

    public void setFileVO(FileVO fileVO) {
        this.fileVO = fileVO;
    }
}
