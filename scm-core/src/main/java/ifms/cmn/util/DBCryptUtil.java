package ifms.cmn.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

//hsh import com.ksign.securedb.api.SDBCrypto;
//hsh import com.ksign.securedb.api.util.SDBException;
@Repository
public class DBCryptUtil {
	private Logger logger = LoggerFactory.getLogger(DBCryptUtil.class);
	
	/*@Value("#{globalProps['Globals.SdbDomainName']}")
	public  String SDB_DOMAIN_NAME;
	@Value("#{globalProps['Globals.SdbIp']}")
	public  String SDB_IP; 
	@Value("#{globalProps['Globals.SdbPort']}")
	public  int SDB_PORT;
	@Value("#{globalProps['Globals.SdbSchema']}")
	private  String SCHEMA;
	@Value("#{globalProps['Globals.SdbTable']}")
	private  String TABLE;
	@Value("#{globalProps['Globals.SdbColumnArea']}")
	private  String ARIA_COLUMN;
	@Value("#{globalProps['Globals.SdbColumnSha']}")
	private  String SHA_COLUMN;*/
	
//hsh    @SuppressWarnings("static-access")
//hsh	public  String encryptAria(String pData) { 
//hsh    	String encData = "";
//hsh    	try {
//hsh    		//logger.info("====Logger.info============");
//hsh    		logger.info(SDB_DOMAIN_NAME);
//hsh    		logger.info(SDB_IP);
//hsh    		logger.info(SDB_PORT+"");
//hsh    		SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh    		encData = sdbCrypto.encryptCEV(SCHEMA, TABLE, ARIA_COLUMN, pData);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptAria Error");
//hsh		}
//hsh    	return encData;
//hsh    }
//hsh    
//hsh    public  String decryptArea(String encData) { 
//hsh    	String decData = "";
//hsh    	try {
//hsh    		SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh    		decData = sdbCrypto.decryptDP(SCHEMA, TABLE, ARIA_COLUMN, encData, null,0);
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptArea Error");
//hsh		}
//hsh    	return decData;
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  String encryptSha(String pData) { 
//hsh    	String encData = "";
//hsh    	try {
//hsh    		SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh    		encData = sdbCrypto.encryptCEV(SCHEMA, TABLE, SHA_COLUMN, pData);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptSha Error");
//hsh		}
//hsh    	return encData;
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  String decryptSha(String encData) { 
//hsh    	String decData = "";
//hsh    	try {
//hsh    		SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh    		decData = sdbCrypto.decryptDP(SCHEMA, TABLE, SHA_COLUMN, encData, null,0);
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptSha Error");
//hsh		}
//hsh    	return decData;
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] encryptLobArea(byte[] pData){ 
//hsh    	ByteArrayInputStream input = new ByteArrayInputStream(pData);
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.encryptBlobCEV(SCHEMA, TABLE, ARIA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptLobArea Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] decryptLobArea(byte[] pData) { 
//hsh    	
//hsh    	ByteArrayInputStream input = new ByteArrayInputStream(pData);
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.decryptBlobCEV(SCHEMA, TABLE, ARIA_COLUMN, input, out);
//hsh
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptLobArea Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] encryptLobSha(byte[] pData){ 
//hsh    	ByteArrayInputStream input = new ByteArrayInputStream(pData);
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.encryptBlobCEV(SCHEMA, TABLE, SHA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptLobSha Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] decryptLobSha(byte[] pData) { 
//hsh    	
//hsh    	ByteArrayInputStream input = new ByteArrayInputStream(pData);
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.decryptBlobCEV(SCHEMA, TABLE, SHA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptLobSha Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] encryptLobArea(InputStream input){ 
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.encryptBlobCEV(SCHEMA, TABLE, ARIA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptLobArea Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] decryptLobArea(InputStream input){ 
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.decryptBlobCEV(SCHEMA, TABLE, ARIA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptLobArea Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh   
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] encryptLobSha(InputStream input){ 
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.encryptBlobCEV(SCHEMA, TABLE, SHA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptLobSha Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    @SuppressWarnings("static-access")
//hsh    public  byte[] decryptLobSha(InputStream input){ 
//hsh    	ByteArrayOutputStream out = new ByteArrayOutputStream();
//hsh		try {
//hsh			SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh			sdbCrypto.decryptBlobCEV(SCHEMA, TABLE, SHA_COLUMN, input, out);
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptLobSha Error");
//hsh		}
//hsh    	return out.toByteArray();
//hsh    }
//hsh    
//hsh    public  boolean encryptFile(String filePath, String pData) { 
//hsh		StringBuffer objName = new StringBuffer();
//hsh		objName.append(SCHEMA);
//hsh		objName.append(".");
//hsh 		objName.append(TABLE);
//hsh		objName.append(".");
//hsh 		objName.append(ARIA_COLUMN);
//hsh    	boolean ret = false;
//hsh    	try {
//hsh    		SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh    		ret = sdbCrypto.encryptFile(filePath, objName.toString(), false);
//hsh		} catch (SDBException e) {
//hsh			logger.error("encryptFile Error");
//hsh		}
//hsh    	return ret;
//hsh    }
//hsh    
//hsh    public  boolean decryptFile(String filePath, String pData) { 
//hsh		StringBuffer objName = new StringBuffer();
//hsh		objName.append(SCHEMA);
//hsh		objName.append(".");
//hsh 		objName.append(TABLE);
//hsh		objName.append(".");
//hsh 		objName.append(ARIA_COLUMN);
//hsh    	boolean ret = false;
//hsh    	try {
//hsh    		SDBCrypto sdbCrypto = SDBCrypto.getInstanceDomain(SDB_DOMAIN_NAME,SDB_IP,SDB_PORT);
//hsh    		ret = sdbCrypto.decryptFile(filePath, objName.toString(), false);
//hsh		} catch (SDBException e) {
//hsh			logger.error("decryptFile Error");
//hsh		}
//hsh    	return ret;
//hsh    }
   
}
