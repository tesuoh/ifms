package ifms.mybatis.typehandler;

import org.apache.ibatis.type.BaseTypeHandler;
import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.MappedJdbcTypes;
import org.apache.ibatis.type.MappedTypes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.ByteBuffer;
import java.nio.charset.StandardCharsets;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

/**
 * 전화번호 암복호화 TypeHandler
 * DB 저장 시 암호화, 조회 시 복호화를 자동으로 처리합니다.
 */
@Component
@MappedTypes(String.class)
@MappedJdbcTypes(JdbcType.VARCHAR)
public class CryptTypeHandler extends BaseTypeHandler<String> {

    private static final Logger logger = LoggerFactory.getLogger(CryptTypeHandler.class);
    
    // AES-256-GCM 알고리즘 사용
    private static final String ALGORITHM = "AES/GCM/NoPadding";
    private static final String KEY_ALGORITHM = "AES";
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 16;
    
    // 암호화 키 (실제 운영 환경에서는 설정 파일에서 주입받아야 함)
    @Value("${encryption.phone.key:#{null}}")
    private String encryptionKey;
    
    // 기본 키 (설정이 없을 경우 사용, 실제 운영에서는 반드시 변경 필요)
    private static final String DEFAULT_KEY = "MySecretKey123456789012345678901234"; // 32 bytes for AES-256
    
    /**
     * 암호화 키 가져오기
     */
    private byte[] getKey() {
        String key = encryptionKey != null && !encryptionKey.isEmpty() 
            ? encryptionKey 
            : DEFAULT_KEY;
        
        // 키가 32바이트가 되도록 조정
        if (key.length() < 32) {
            key = String.format("%-32s", key).substring(0, 32);
        } else if (key.length() > 32) {
            key = key.substring(0, 32);
        }
        
        return key.getBytes(StandardCharsets.UTF_8);
    }
    
    /**
     * 전화번호 암호화
     */
    private String encrypt(String plainText) {
        if (plainText == null || plainText.isEmpty()) {
            return plainText;
        }
        
        try {
            byte[] key = getKey();
            SecretKeySpec secretKey = new SecretKeySpec(key, KEY_ALGORITHM);
            
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            cipher.init(Cipher.ENCRYPT_MODE, secretKey);
            
            byte[] iv = cipher.getIV();
            byte[] encryptedData = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));
            
            // IV + 암호화된 데이터를 함께 저장
            ByteBuffer byteBuffer = ByteBuffer.allocate(iv.length + encryptedData.length);
            byteBuffer.put(iv);
            byteBuffer.put(encryptedData);
            
            return Base64.getEncoder().encodeToString(byteBuffer.array());
        } catch (Exception e) {
            logger.error("전화번호 암호화 실패", e);
            // 암호화 실패 시 원본 반환 (또는 예외 발생)
            return plainText;
        }
    }
    
    /**
     * 전화번호 복호화
     */
    private String decrypt(String encryptedText) {
        if (encryptedText == null || encryptedText.isEmpty()) {
            return encryptedText;
        }
        
        try {
            byte[] key = getKey();
            SecretKeySpec secretKey = new SecretKeySpec(key, KEY_ALGORITHM);
            
            byte[] decodedData = Base64.getDecoder().decode(encryptedText);
            
            // IV와 암호화된 데이터 분리
            ByteBuffer byteBuffer = ByteBuffer.wrap(decodedData);
            byte[] iv = new byte[GCM_IV_LENGTH];
            byteBuffer.get(iv);
            byte[] encryptedData = new byte[byteBuffer.remaining()];
            byteBuffer.get(encryptedData);
            
            Cipher cipher = Cipher.getInstance(ALGORITHM);
            GCMParameterSpec parameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
            cipher.init(Cipher.DECRYPT_MODE, secretKey, parameterSpec);
            
            byte[] decryptedData = cipher.doFinal(encryptedData);
            return new String(decryptedData, StandardCharsets.UTF_8);
        } catch (Exception e) {
            logger.error("전화번호 복호화 실패", e);
            // 복호화 실패 시 원본 반환 (이미 암호화되지 않은 데이터일 수 있음)
            return encryptedText;
        }
    }
    
    @Override
    public void setNonNullParameter(PreparedStatement ps, int i, String parameter, JdbcType jdbcType) throws SQLException {
        // DB에 저장할 때 암호화
        String encrypted = encrypt(parameter);
        ps.setString(i, encrypted);
    }
    
    @Override
    public String getNullableResult(ResultSet rs, String columnName) throws SQLException {
        // DB에서 조회할 때 복호화
        String encrypted = rs.getString(columnName);
        return decrypt(encrypted);
    }
    
    @Override
    public String getNullableResult(ResultSet rs, int columnIndex) throws SQLException {
        // DB에서 조회할 때 복호화
        String encrypted = rs.getString(columnIndex);
        return decrypt(encrypted);
    }
    
    @Override
    public String getNullableResult(CallableStatement cs, int columnIndex) throws SQLException {
        // DB에서 조회할 때 복호화
        String encrypted = cs.getString(columnIndex);
        return decrypt(encrypted);
    }
}
