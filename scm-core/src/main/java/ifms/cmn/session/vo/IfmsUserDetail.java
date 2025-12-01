package ifms.cmn.session.vo;

import java.io.Serializable;

public class IfmsUserDetail implements Serializable {
	
	private static final long serialVersionUID = -1L;
				
	//현재 접속IP
	private String userIp; 
	
	//경제자유구역여부 (매매담당자 전용)
	private String ifezaYn; 
	
	//공무원용 권한 
	//AD : 관리자
	//OM : 실거래 공무원 (대표)
	//OD : 실거래공무원
	//LD : 전월세공무원
	private String auth;
	
	//시군구코드 (매매담당자, 임대차담당자 활용)
	private String sggCd; 
	
	//주민센터기관코드
	private String orgCd;

	//로그인ID
	private String userId;
	
	//로그인 유저 성명
	private String userNm;
	
	//로그인 유저 전화번호
	private String telno;
	
	//캡챠 이미지 문자열 저장
	private String captchaWord;	

	//사용자권한
	private String authorCode;	
	
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	public String getUserIp() {
		return userIp;
	}

	public void setUserIp(String userIp) {
		this.userIp = userIp;
	}

	public String getIfezaYn() {
		return ifezaYn;
	}

	public void setIfezaYn(String ifezaYn) {
		this.ifezaYn = ifezaYn;
	}
	
	public String getAuth() {
		return auth;
	}

	public void setAuth(String auth) {
		this.auth = auth;
	}

	public String getSggCd() {
		return sggCd;
	}

	public void setSggCd(String sggCd) {
		this.sggCd = sggCd;
	}

	public String getOrgCd() {
		return orgCd;
	}

	public void setOrgCd(String orgCd) {
		this.orgCd = orgCd;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	
	public String getTelno() {
		return telno;
	}

	public void setTelno(String telno) {
		this.telno = telno;
	}

	public String getCaptchaWord() {
		return captchaWord;
	}

	public void setCaptchaWord(String captchaWord) {
		this.captchaWord = captchaWord;
	}

	public String getAuthorCode() {
		return authorCode;
	}

	public void setAuthorCode(String authorCode) {
		this.authorCode = authorCode;
	}
}
