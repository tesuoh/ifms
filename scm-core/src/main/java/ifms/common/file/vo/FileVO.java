package ifms.common.file.vo;

import java.util.List;

import org.springframework.util.StringUtils;


public class FileVO {
    private int fileGroupSn;           //파일 ID
    private String ptznTaskSeCd;       //보호구역업무 구분 코드
    private String lgnYn;              //로그인 여부
    private String stdgCtpvCd;         //법정동 시도 코드
    private String stdgSggCd;          //법정동 시군구 코드
    private String instCertYn;         //기관 인증 여부
    private int fileDtlSn;             //파일 일련번호
    private String orgnlFileNm;        //원본파일명
    private String filePath;           //파일 경로
    private String fileNm;             //파일 명
    private String fileSz;             //파일 크기
    private String fileExtnNm;         //파일확장자명
    private String dwnldCnt;           //다운로드 수
    private String delYn;              //삭제 여부
    private String rgtrId;             //등록 ID
    private String regDt;              //등록 일시
    private String mdfrId;             //변경 ID
    private String mdfcnDt;            //변경 일시

    private String fileTypeSeCd;			//파일 유형

    private boolean error;				//Multi 업로드 에러여부
    private String errorCode;				//Multi 업로드 에러코드
    private String errorMessage;		//Multi 업로드 에러메시지

    private List<String> fileDtlSnArray;					//Multi 업로드 대상 파일상세정보
    private List<String> fileStatusArray	;			//Multi 업로드 파일상태

    private String fileChangeYn;
    
    /**
     * 파일 전체 경로 - 확장자 포함된 파일명
     * @return
     */
    public String getFileFullPath() {
        String fileFullPath = filePath+"/"+fileNm;
        if(!StringUtils.isEmpty(fileExtnNm)) {
            fileFullPath+="."+fileExtnNm;
        }
        return fileFullPath;
    }

    /**
     * 확장자 포함된 파일명 - 저장된 파일명
     * @return
     */
    public String getFileNmWithExt() {
        String fileNmExt = fileNm;
        if(!StringUtils.isEmpty(fileExtnNm)) {
            fileNmExt+="."+fileExtnNm;
        }
        return fileNmExt;

    }

    /**
     * 확장자 포함된 파일명 - 원본 파일명
     * @return
     */
    public String getOrgnlFileNmWithExt() {
        String fileNmExt = orgnlFileNm;
        if(!StringUtils.isEmpty(fileExtnNm)) {
            fileNmExt+="."+fileExtnNm;
        }
        return fileNmExt;

    }

    public int getFileGroupSn() {
        return fileGroupSn;
    }

    public void setFileGroupSn(int fileGroupSn) {
        this.fileGroupSn = fileGroupSn;
    }

    public String getPtznTaskSeCd() {
		return ptznTaskSeCd;
	}

	public void setPtznTaskSeCd(String ptznTaskSeCd) {
		this.ptznTaskSeCd = ptznTaskSeCd;
	}

	public String getLgnYn() {
		return lgnYn;
	}

	public void setLgnYn(String lgnYn) {
		this.lgnYn = lgnYn;
	}

	public String getStdgCtpvCd() {
		return stdgCtpvCd;
	}

	public void setStdgCtpvCd(String stdgCtpvCd) {
		this.stdgCtpvCd = stdgCtpvCd;
	}

	public String getStdgSggCd() {
		return stdgSggCd;
	}

	public void setStdgSggCd(String stdgSggCd) {
		this.stdgSggCd = stdgSggCd;
	}

	public String getInstCertYn() {
		return instCertYn;
	}

	public void setInstCertYn(String instCertYn) {
		this.instCertYn = instCertYn;
	}

	public int getFileDtlSn() {
        return fileDtlSn;
    }

    public void setFileDtlSn(int fileDtlSn) {
        this.fileDtlSn = fileDtlSn;
    }

    public String getOrgnlFileNm() {
        return orgnlFileNm;
    }

    public void setOrgnlFileNm(String orgnlFileNm) {
        this.orgnlFileNm = orgnlFileNm;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileNm() {
        return fileNm;
    }

    public void setFileNm(String fileNm) {
        this.fileNm = fileNm;
    }

    public String getFileSz() {
        return fileSz;
    }

    public void setFileSz(String fileSz) {
        this.fileSz = fileSz;
    }

    public String getFileExtnNm() {
        return fileExtnNm;
    }

    public void setFileExtnNm(String fileExtnNm) {
        this.fileExtnNm = fileExtnNm;
    }

    public String getDwnldCnt() {
        return dwnldCnt;
    }

    public void setDwnldCnt(String dwnldCnt) {
        this.dwnldCnt = dwnldCnt;
    }

    public String getDelYn() {
        return delYn;
    }

    public void setDelYn(String delYn) {
        this.delYn = delYn;
    }

    public String getRgtrId() {
        return rgtrId;
    }

    public void setRgtrId(String rgtrId) {
        this.rgtrId = rgtrId;
    }

    public String getRegDt() {
        return regDt;
    }

    public void setRegDt(String regDt) {
        this.regDt = regDt;
    }

    public String getMdfrId() {
        return mdfrId;
    }

    public void setMdfrId(String mdfrId) {
        this.mdfrId = mdfrId;
    }

    public String getMdfcnDt() {
        return mdfcnDt;
    }

    public void setMdfcnDt(String mdfcnDt) {
        this.mdfcnDt = mdfcnDt;
    }

    public String getFileTypeSeCd() {
        return fileTypeSeCd;
    }

    public void setFileTypeSeCd(String fileTypeSeCd) {
        this.fileTypeSeCd = fileTypeSeCd;
    }

    public boolean isError() {
        return error;
    }

    public void setError(boolean error) {
        this.error = error;
    }

    public String getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(String errorCode) {
        this.errorCode = errorCode;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public List<String> getFileStatusArray() {
        return fileStatusArray;
    }

    public void setFileStatusArray(List<String> fileStatusArray) {
        this.fileStatusArray = fileStatusArray;
    }

    public List<String> getFileDtlSnArray() {
        return fileDtlSnArray;
    }

    public void setFileDtlSnArray(List<String> fileDtlSnArray) {
        this.fileDtlSnArray = fileDtlSnArray;
    }

	public String getFileChangeYn() {
		return fileChangeYn;
	}

	public void setFileChangeYn(String fileChangeYn) {
		this.fileChangeYn = fileChangeYn;
	}

}
