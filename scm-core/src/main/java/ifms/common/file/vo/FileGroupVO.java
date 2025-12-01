package ifms.common.file.vo;

public class FileGroupVO {

    private int fileGroupSn;        //파일 ID
    private String ptznTaskSeCd;       //보호구역업무 구분 코드
    private String lgnYn;              //로그인 여부
    private String stdgCtpvCd;         //법정동 시도 코드
    private String stdgSggCd;          //법정동 시군구 코드
    private String instCertYn;         //기관 인증 여부
    private String fileTypeSeCd;      //파일 유형
    private String delYn;         //삭제 여부
    private String rgtrId;         //등록 일시
    private String regDt;         //등록 ID
    private String mdfrId;         //변경 ID
    private String mdfcnDt;         //변경 일시

    public FileGroupVO() {
    }

    // FileVO를 이용한 FileGroupVO 생성
    public FileGroupVO(FileVO fileVO) {
    	this.ptznTaskSeCd = fileVO.getPtznTaskSeCd();
    	this.lgnYn = fileVO.getLgnYn();
    	this.stdgCtpvCd = fileVO.getStdgCtpvCd();
    	this.stdgSggCd = fileVO.getStdgSggCd();
    	this.instCertYn = fileVO.getInstCertYn();
        this.fileTypeSeCd = fileVO.getFileTypeSeCd();
        this.rgtrId = fileVO.getRgtrId();
        this.mdfrId = fileVO.getRgtrId();
    }
    
    public int getFileGroupSn() {
        return fileGroupSn;
    }
    public void setFileGroupSn(int fileGroupSn) {
        this.fileGroupSn = fileGroupSn;
    }
    public String getFileTypeSeCd() {
        return fileTypeSeCd;
    }
    public void setFileTypeSeCd(String fileTypeSeCd) {
        this.fileTypeSeCd = fileTypeSeCd;
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

}
