package ifms.cmn.util;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component("IfmsGlobalsUtil")
public class IfmsGlobalsUtil {

	//파일구분자
	final static String FILE_SEPARATOR = System.getProperty("file.separator");

	@Value("#{globalProps['file.root.path']}") //루트경로
	public String ROOT_PATH;

	@Value("#{globalProps['file.temp.path']}") //임시경로
	public String TEMP_PATH;

	@Value("#{globalProps['file.real.path']}") //실제경로
	public String REAL_PATH;

	//서버유형
	@Value("#{globalProps['Globals.ServerType']}")
	public String SERVER_TYPE;

	//시스템유형
	@Value("#{globalProps['Globals.systemTy']}")
	public String SYSTEM_TY;

	//클립레포트 명칭
	@Value("#{globalProps['Globals.clipReportNm']}")
	public String CLIP_REPORT_NM;

	//SSL/TSL 인증서 정보 (ROOT CA)
	@Value("#{globalProps['Globals.RootCa']}")
	public String ROOT_CA;

	//도로명 연계 api URL
	@Value("#{globalProps['Globals.RnApiUrl']}")
	public String RN_API_URL;
	//도로명 연계 api 키
	@Value("#{globalProps['Globals.RnApiKey']}")
	public String RN_API_KEY;

	//서버용 GPIK 관련 경로
	@Value("#{globalProps['Globals.ServerGpkiModPath']}")
	public String SERVER_GPKI_MOD_PATH;          //서버용 GPKI 모듈 경로
	public String SERVER_GPKI_CERT_PATH;         //서버용 GPKI 인증서(/cert) 경로
	public String SERVER_GPKI_ENV_CER_PATH;      //서버용 GPKI 암호화용 인증서 경로
	public String SERVER_GPKI_ENV_KEY_PATH;      //서버용 GPKI 암호화용 인증서 키 경로
	public String SERVER_GPKI_SIG_CER_PATH;      //서버용 GPKI 서명용 인증서 경로
	public String SERVER_GPKI_SIG_KEY_PATH;      //서버용 GPKI 서명용 인증서 키 경로
	//서버용 GPKI ID
	@Value("#{globalProps['Globals.ServerGpkiId']}")
	public String SERVER_GPKI_ID;
	//서버용 GPKI PASSWORD
	@Value("#{globalProps['Globals.ServerGpkiPasswd']}")
	public String SERVER_GPKI_PASSWD;

	//geoserver proxy url
	@Value("#{globalProps['Globals.geoserverURL']}")
	public String GEOSERVER_URL;

	//geoserver proxy url
	@Value("#{globalProps['Globals.fcltyImgPath']}")
	public String FCLTY_IMG_PATH;
	@Value("#{globalProps['Globals.fcltyDefaultImgFile']}")
	public String FCLTY_DEFAULT_IMG_FILE;

	// resources path
	@Value("#{globalProps['Globals.resourcesPath']}")
	public String RESOURCES_PATH;

	// vworld api key
	@Value("#{globalProps['Globals.vworldKey']}")
	public String VWORLD_KEY;

	// vworld api url
	@Value("#{globalProps['Globals.vworldURL']}")
	public String VWORLD_URL;

	// resources path
	@Value("#{globalProps['Globals.pythonPath']}")
	public String PYTHON_PATH;

	// resources path
	@Value("#{globalProps['Globals.pythonScriptPath']}")
	public String PYTHON_SCRIPT_PATH;
	
	
	@Value("#{globalProps['Globals.encryption.key']}")
	public String ENCRYPT_KEY;

	public String getProperties(String req) {
		String res = "";
		switch (req) {
			case "SERVER_TYPE"               	 : res = SERVER_TYPE; break;
			case "SYSTEM_TY"               	     : res = SYSTEM_TY; break;
			case "CLIP_REPORT_NM"                : res = CLIP_REPORT_NM; break;
			case "RN_API_URL"                    : res = RN_API_URL; break;
			case "RN_API_KEY"                    : res = RN_API_KEY; break;
			case "ROOT_CA"                       : res = ROOT_CA; break;
			case "SERVER_GPKI_PASSWD"            : res = SERVER_GPKI_PASSWD; break;
			case "SERVER_GPKI_MOD_PATH"          : res = SERVER_GPKI_MOD_PATH; break;
			case "SERVER_GPKI_CERT_PATH"         : res = SERVER_GPKI_MOD_PATH + FILE_SEPARATOR + "certs"; break;
			case "SERVER_GPKI_ENV_CER_PATH"      : res = SERVER_GPKI_MOD_PATH + FILE_SEPARATOR + "certs" + FILE_SEPARATOR + SERVER_GPKI_ID + "_env.cer"; break; //예시 C:/ifms/workspace/ifms/AuthServer/SVR1500000003_env.cer
			case "SERVER_GPKI_ENV_KEY_PATH"      : res = SERVER_GPKI_MOD_PATH + FILE_SEPARATOR + "certs" + FILE_SEPARATOR + SERVER_GPKI_ID + "_env.key"; break; //예시 C:/gpki2/gpkisecureweb/certs
			case "SERVER_GPKI_SIG_CER_PATH"      : res = SERVER_GPKI_MOD_PATH + FILE_SEPARATOR + "certs" + FILE_SEPARATOR + SERVER_GPKI_ID + "_sig.cer"; break;
			case "SERVER_GPKI_SIG_KEY_PATH"      : res = SERVER_GPKI_MOD_PATH + FILE_SEPARATOR + "certs" + FILE_SEPARATOR + SERVER_GPKI_ID + "_sig.key"; break;
			case "GEOSERVER_URL"                 : res = GEOSERVER_URL; break;
			case "FCLTY_IMG_PATH"                : res = FCLTY_IMG_PATH; break;
			case "FCLTY_DEFAULT_IMG_FILE"        : res = FCLTY_DEFAULT_IMG_FILE; break;
			case "RESOURCES_PATH"                : res =  RESOURCES_PATH; break;
			case "VWORLD_KEY"                    : res = VWORLD_KEY; break;
			case "VWORLD_URL"                    : res = VWORLD_URL; break;
			case "PYTHON_PATH"                   : res =  PYTHON_PATH; break;
			case "PYTHON_SCRIPT_PATH"            : res =  PYTHON_SCRIPT_PATH; break;
			case "ROOT_PATH"                	 : res =  ROOT_PATH; break;
			case "TEMP_PATH"                	 : res =  TEMP_PATH; break;
			case "REAL_PATH_ADM", "REAL_PATH"    : res =  REAL_PATH; break;
			case "ENCRYPT_KEY"					 : res = ENCRYPT_KEY; break;

			default: break;
		}
		return res;
	}

}