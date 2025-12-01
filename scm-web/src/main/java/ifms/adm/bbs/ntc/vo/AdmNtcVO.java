package ifms.adm.bbs.ntc.vo;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class AdmNtcVO {
	private int totalCnt; /** 목록 조회용 총 건수 */
	private int rnum; /* 목록조회 시 순번 */
		
	private int pageIndex = 1; /** 현재페이지 */
	private int pageUnit = 10; /** 페이지갯수 */
	private int pageSize = 10; /** 페이지사이즈 */
	private int firstIndex = 1; /** 최초 번호 */
	private int lastIndex = 1; /** 마지막 번호 */
	private int recordCountPerPage = 10; /** 페이지당 조회 건수 */
	
	private String returnMessage; /** 화면 리턴 메세지 */
	
	/*********** 이하 검색조건 등 화면에 필요한 항목 직접 추가 ***********/
	
	private String searchCondition;
	private String searchKeyword;
	private int ntcMttrSn;
	private String ntcMttrTtl;
	private String bbsTemaCd;
	private String ntcMttrCn;
	private String ntcMttrPstgYn;
	private String hghrkNtcYn;
	private String inqCnt;
	private long ahflId;
	private String frstRegDt;
	private String frstRgtrId;
	private String lastMdfcnDt;
	private String lastMdfrId;
}
