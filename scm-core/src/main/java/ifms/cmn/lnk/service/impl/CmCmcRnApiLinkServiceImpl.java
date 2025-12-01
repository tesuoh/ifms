package ifms.cmn.lnk.service.impl;                        
                                                                                                                                                 
import java.util.ArrayList;
import java.util.List;                                                                                                                           
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
                                                                                                                                                                                                                                          
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.cmn.lnk.service.CmCmcRnApiLinkService;
import ifms.cmn.util.IfmsGlobalsUtil;

import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**                                                                                                                                              
 * 차세대 부동산거래관리시스템 2차년도                                                                                                                           
 * 도로명주소 api 연계  ServiceImpl                                                                                                                 
 */                                                                                                                                              
                                                                                                                                                 
@Service("cmCmcRnApiLinkService")                                                                                                                   
public class CmCmcRnApiLinkServiceImpl implements CmCmcRnApiLinkService                                                                                
{                                                                                                                                                
                                                                                                                                                 
    private static final Logger LOGGER = LoggerFactory.getLogger(CmCmcRnApiLinkServiceImpl.class);         
    
	@Autowired
	private IfmsGlobalsUtil ifmsGlobalsUtil;       
             
    /** 
     *[[[[[[[[[[[[[[[[[[[[[[[[[[[[   운영 환경 배포시 주의사항   ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]] 
     *도로명주소API 연계시 HTTPS 를 활용하여 통신할 경우 TLS 1.2 이상으로 서버설정을 맞춰야함. (최근 주소사업단에서 정책을 바꾸었음)
     *rtms-ex의 경우 운영환경이 인터넷망이기 때문에 자동으로 인증서 설정이 되나, 
     *rtms-in의 경우 운영환경이 행정망이기 때문에 gpki 인증서를 구하여 우리쪽 서버에 설정 필요함. (도로명주소사업단에서 구하면됨 : 공통 조선형부장)
     *관련 오류로는 IOException ca cert handshake 문제 발생함
     *개발서버의 경우 서버둘다 행정망에 있기 때문에 둘다 각각 적용되어있음
     *이도저도 안된다면, apiUrl을 HTTP로 바꿔서 통신하면됨. 행안부 도로명사업단도 힘들면 그냥 쓰라고 함. (2021년 11월 응답 내용이며, 나중에 운영시 다시 상황 판단 요망)    
    **/
             
    //도로명 api 연계  [개발서버 -> 도로명주소사업단 통신용]       
	@Override
	public String selectCmCmcRnApiLink(String currentPage, String countPerPage, String keyword) throws Exception {
		if(currentPage.indexOf("/") != -1) { throw new Exception("selectCmCmcRnApiLink currentPage ssrf"); }
		if(currentPage.indexOf("http") != -1) { throw new Exception("selectCmCmcRnApiLink currentPage ssrf"); }
		if(countPerPage.indexOf("/") != -1) { throw new Exception("selectCmCmcRnApiLink countPerPage ssrf"); }
		if(countPerPage.indexOf("http") != -1) { throw new Exception("selectCmCmcRnApiLink countPerPage ssrf"); }
		if(keyword.indexOf("/") != -1) { throw new Exception("selectCmCmcRnApiLink keyword ssrf"); }
		if(keyword.indexOf("http") != -1) { throw new Exception("selectCmCmcRnApiLink keyword ssrf"); }
		
		//10.47.33.111 api key
		//devU01TX0FVVEgyMDIxMTAyNTE3MzkwOTExMTc5NzU=
		//개발 ( 사용기간 : 2021-10-25 ~ 2022-01-23 )
		//10.47.33.112 api key
		//devU01TX0FVVEgyMDIxMTAyNTE3NDAxOTExMTc5NzY=
		//개발 ( 사용기간 : 2021-10-25 ~ 2022-01-23 )		
		
		//요청변수 설정
	    //String currentPage  = "1"; //요청 변수 설정 (현재 페이지. currentPage : n > 0)
		//String countPerPage = "20"; //요청 변수 설정 (페이지당 출력 개수. countPerPage 범위 : 0 < n <= 100)
		//String keyword      = "서초현대아파트"; //요청 변수 설정 (키워드)
		String resultType   = "json"; //요청 변수 설정 (검색결과형식 설정, json)
		String confmKey     = ifmsGlobalsUtil.getProperties("RN_API_KEY"); //요청 변수 설정 (도로명사업단발급 승인키)
		String apiUrl       = ifmsGlobalsUtil.getProperties("RN_API_URL"); //요청 변수 설정 (도로명사업단발급 호출url)
		
		
		//String hstryYn; //2020년 12월 추가항목 - 변동된 주소정보 포함 여부 (굳이 쓸필요 없는듯?)
		//String firstSort; //2020년 12월 추가항목 - 정확도순정렬(none) 우선정렬(road:도로명, location:지번포함) (굳이 쓸필요 없는듯?)
		String addInfoYn = "Y"; //2020년 12월 추가항목 - 추가항목제공여부 (관계지번, 주민센터명, 변동이력, 주민센터명) (일단 쓰는데, 경고문이 있음... 추가항목은 갑자기 제거될지 모른다고 되어있음...) 
		
		// OPEN API 호출 URL 정보 설정
		apiUrl = apiUrl + "?currentPage="+currentPage+"&countPerPage="+countPerPage+"&keyword="+URLEncoder.encode(keyword,"UTF-8")+"&confmKey="+confmKey+"&resultType="+resultType +"&addInfoYn="+addInfoYn;
		BufferedReader br = null;
		StringBuffer   sb = null; 
		String resultStr = "";
		try {
			URL url = new URL(apiUrl);
			br = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
			sb = new StringBuffer();
			String tempStr = null;
			while(true){
				tempStr = br.readLine();
				if(tempStr == null) break;
				sb.append(tempStr); //응답결과 JSON 저장
			}
			br.close();
		} catch (MalformedURLException e) {
			LOGGER.error("selectCmCmcRnApiLink MalformedURLException");
		} catch (UnsupportedEncodingException e) {
			LOGGER.error("selectCmCmcRnApiLink UnsupportedEncodingException");
		} catch (IOException e) {
			LOGGER.error("selectCmCmcRnApiLink IOException");
		} finally {
			if(br != null) br.close();
		}
		if(sb != null){resultStr = sb.toString();}
		
		return resultStr;
	}		
	
	//도로명 api 연계 (개발자 로컬PC 개발용) [개발자로컬PC -> 개발서버 -> 도로명주소사업단 통신용]        
	@Override
	public String selectCmCmcRnApiLinkLocalDev(String currentPage, String countPerPage, String keyword) throws Exception {

		if(currentPage.indexOf("/") != -1) { throw new Exception("selectCmCmcRnApiLinkLocalDev currentPage ssrf"); }
		if(currentPage.indexOf("http") != -1) { throw new Exception("selectCmCmcRnApiLinkLocalDev currentPage ssrf"); }
		if(countPerPage.indexOf("/") != -1) { throw new Exception("selectCmCmcRnApiLinkLocalDev countPerPage ssrf"); }
		if(countPerPage.indexOf("http") != -1) { throw new Exception("selectCmCmcRnApiLinkLocalDev countPerPage ssrf"); }
		if(keyword.indexOf("/") != -1) { throw new Exception("selectCmCmcRnApiLinkLocalDev keyword ssrf"); }
		if(keyword.indexOf("http") != -1) { throw new Exception("selectCmCmcRnApiLinkLocalDev keyword ssrf"); }		
		
		//현재의 로컬개발환경은 111, 112 개발서버 둘다 붙을 수 있으므로 111서버로 in, ex 둘다 활용가능함. (나중에 필요하면 변경)
		String apiUrl = "http://10.10.33.111/cm/cmc/selectCmCmcRnApiLink.do?currentPage="+currentPage+"&countPerPage="+countPerPage+"&keyword="+URLEncoder.encode(keyword,"UTF-8");
		BufferedReader br = null;
		StringBuffer   sb = null; 
		String resultStr = "";
		try {
			URL url = new URL(apiUrl);
			br = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));
			sb = new StringBuffer();
			String tempStr = null;
			while(true){
				tempStr = br.readLine();
				if(tempStr == null) break;
				sb.append(tempStr); //응답결과 JSON 저장
			}
			br.close();
		} catch (MalformedURLException e) {
			LOGGER.error("selectCmCmcRnApiLinkLocalDev MalformedURLException");
		} catch (UnsupportedEncodingException e) {
			LOGGER.error("selectCmCmcRnApiLinkLocalDev UnsupportedEncodingException");
		} catch (IOException e) {
			LOGGER.error("selectCmCmcRnApiLinkLocalDev IOException");
		} finally {
			if(br != null) br.close();
		}
		if(sb != null){resultStr = sb.toString();}
		return resultStr;
	}		
                                                                                                                                                                                                                                                                                            
}                                                                                                                                                
