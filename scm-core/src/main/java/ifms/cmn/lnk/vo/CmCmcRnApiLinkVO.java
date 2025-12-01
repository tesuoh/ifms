package ifms.cmn.lnk.vo;                                  
                                                                                                                                             
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.Getter;
import lombok.Setter;                                                                                                       
                                                                                                                                                 
/**                                                                                                                                              
 * 차세대 부동산거래관리시스템 2차년도                                                                                                                           
 * 도로명주소 api 연계  VO                                                                                                                      
 */                                                                                                                                              
@Getter
@Setter 
@JsonIgnoreProperties("no")
public class CmCmcRnApiLinkVO {

	/* 도로명주소 json 2건으로 조회된 데이터 규격
	{"results":
		{"common":
			{"errorMessage":"정상","countPerPage":"2","totalCount":"10","errorCode":"0","currentPage":"1"}
		    ,"juso":[
		             {"detBdNmList":"상가","engAddr":"6, Saimdang-ro 19-gil, Seocho-gu, Seoul","rn":"사임당로19길","emdNm":"서초동","zipNo":"06637","roadAddrPart2":"(서초동, 서초현대아파트)","emdNo":"01","sggNm":"서초구","jibunAddr":"서울특별시 서초구 서초동 1648-2 서초현대아파트","siNm":"서울특별시","roadAddrPart1":"서울특별시 서초구 사임당로19길 6","bdNm":"서초현대아파트","admCd":"1165010800","udrtYn":"0","lnbrMnnm":"1648","roadAddr":"서울특별시 서초구 사임당로19길 6(서초동, 서초현대아파트)","lnbrSlno":"2","buldMnnm":"6","bdKdcd":"1","liNm":"","rnMgtSn":"116504163315","mtYn":"0","bdMgtSn":"1165010800116480003023584","buldSlno":"0"}
		            ,{"detBdNmList":"102동, 경비실, 101동, 경비실, 노인정,관리실","engAddr":"10, Saimdang-ro 19-gil, Seocho-gu, Seoul","rn":"사임당로19길","emdNm":"서초동","zipNo":"06637","roadAddrPart2":"(서초동, 서초현대아파트)","emdNo":"01","sggNm":"서초구","jibunAddr":"서울특별시 서초구 서초동 1648-2 서초현대아파트","siNm":"서울특별시","roadAddrPart1":"서울특별시 서초구 사임당로19길 10","bdNm":"서초현대아파트","admCd":"1165010800","udrtYn":"0","lnbrMnnm":"1648","roadAddr":"서울특별시 서초구 사임당로19길 10(서초동, 서초현대아파트)","lnbrSlno":"2","buldMnnm":"10","bdKdcd":"1","liNm":"","rnMgtSn":"116504163315","mtYn":"0","bdMgtSn":"1165010800116480002023607","buldSlno":"0"}
		            ]
		}
	}
    */
	String siNm;          //(명칭)시도명          
	String sggNm;         //(명칭)시군구명
	String emdNm;         //(명칭)읍면동명
	String liNm;          //(명칭)리명
	
	String rn;            //(명칭)도로명	
	String roadAddr;      //(명칭)전체 도로명주소
	String roadAddrPart1; //(명칭)도로명주소(참고항목제외)
	String roadAddrPart2; //(명칭)도로명주소 참고항목
	String rnMgtSn;       //(코드)도로명코드(12자리)
	String emdNo;         //(코드)읍면동일련번호(2)
	String udrtYn;        //(코드)지하여부 0:지상 1:지하
	String buldMnnm;      //(코드)건물본번(5)
	String buldSlno;      //(코드)건물부번(5)
	String engAddr;       //(명칭)도로명주소(영문)

	String jibunAddr;     //(명칭)지번주소
	String admCd;         //(코드)법정동코드(10) (도로명사업단에는 행정구역코드라고 되어있음. 행정동코드 아님) 
	String mtYn;          //(코드)산여부(1) 0:대지 1:산
	String lnbrMnnm;      //(코드)지번본번(4)
	String lnbrSlno;      //(코드)지번부번(4)

	String zipNo;         //(코드)우편번호

	String bdMgtSn;       //건물관리번호 (19~20자리 확인됨. 더 늘어날수 있음)
	
	String detBdNmList;   //(명칭)상세건물명
	String bdNm;          //(명칭)건물명
	String bdKdcd;        //(코드)공동주택여부 1:공동주택, 0:비공동주택
	
	
	int no;
	String hstryYn;       //(코드)2020년 12월 추가항목 - 변동이력여부 0:현행주소정보 1:요청변수의 키워드 기준으로 변동된 주소정보검색내역
	String relJibun;     //(명칭)2020년 12월 추가항목 - 관계지번 텍스트
	String hemdNm;        //(명칭)2020년 12월 추가항목 - 관할주민센터명
	
	
}                                                                                                                                                
                                                                                                                                                 
