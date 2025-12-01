package ifms.cmn.session.vo;

import java.io.Serializable;

public class IfmsPtlUserDetail implements Serializable {
	
	private static final long serialVersionUID = -1L;
				
	/*************대국민**************/
	//현재 접속IP
	private String userIp;
	
	//대국민 권한
	//1:개인 
	//2:법인 
	//3:외국인 
	//4:외국법인 - 사업자등록번호
	//8:재외국인 - 주민등록번호
	//9 기타 기타  (AS-IS는 세션에서 미사용이나, 공통코드에는 남아있음.)
	//A 국가등 국가등 (AS-IS는 세션에서 미사용이나, 공통코드에는 남아있음.)
	private String ptlAuth;
	
	//TODO : [공통] ksign 암호화 적용 예정임.
	//주민등록번호 또는 외국인등록번호 암호화 정보
	private String resdNo;
	
	//사업자번호 (암호화 적용 대상 아님)
	private String corpNo;
	
	//로그인 유저 성명 (사용자가 직업 입력한 정보로 실명여부와는 관계 없으며, 법인명이 들어올 수도 있음.)
	private String userNm;
	
	//로그인 유저 인증서 Dn (파일업로드 이력 정보 및 기타 로그에 Dn 정보를 저장함.)
	private String userDn;
	
	//캡챠 이미지 문자열 저장
	private String captchaWord;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public String getUserIp() {
		return userIp;
	}
	
	public void setUserIp(String userIp) {
		this.userIp = userIp;
	}
	
	public String getPtlAuth() {
		return ptlAuth;
	}

	public void setPtlAuth(String ptlAuth) {
		this.ptlAuth = ptlAuth;
	}

	public String getResdNo() {
		return resdNo;
	}

	public void setResdNo(String resdNo) {
		this.resdNo = resdNo;
	}

	public String getCorpNo() {
		return corpNo;
	}

	public void setCorpNo(String corpNo) {
		this.corpNo = corpNo;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	
	public String getUserDn() {
		return userDn;
	}

	public void setUserDn(String userDn) {
		this.userDn = userDn;
	}
	
	public String getCaptchaWord() {
		return captchaWord;
	}

	public void setCaptchaWord(String captchaWord) {
		this.captchaWord = captchaWord;
	}

	@Override
	public String toString() {
		return "[userIp=" + userIp + ", ptlAuth=" + ptlAuth + ", resdNo=" + resdNo + ", corpNo=" + corpNo + ", userNm=" + userNm + ", captchaWord=" + captchaWord + "]";
	}
}
