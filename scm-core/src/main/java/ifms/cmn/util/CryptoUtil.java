package ifms.cmn.util;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

@Component
public class CryptoUtil {

    private static final Logger logger = LoggerFactory.getLogger(CryptoUtil.class);

    private static final String TRANSFORMATION = "AES/CBC/PKCS5Padding";
    private static final String KEY_ALGORITHM   = "AES";

    private static final int KEY_LENGTH = 32; // 32 bytes = 256 bit
    private static final int IV_LENGTH  = 16; // 16 bytes

    @Value("#{globalProps['Globals.encryption.key'] ?: ''}")
    private String encryptionKey;

    private static final SecureRandom secureRandom = new SecureRandom();

    @PostConstruct
    public void validateKey() {
        if (encryptionKey == null || encryptionKey.isEmpty()) {
            throw new IllegalStateException("암호화 키(Globals.encryption.key)가 설정되어 있지 않습니다.");
        } else {
        	logger.debug(encryptionKey);
        }
    }

    private byte[] getKey() {
        byte[] raw = encryptionKey.getBytes(StandardCharsets.UTF_8);
        if (raw.length == KEY_LENGTH) {
            return raw;
        }
        byte[] adjusted = new byte[KEY_LENGTH];
        System.arraycopy(raw, 0, adjusted, 0, Math.min(raw.length, KEY_LENGTH));
        return adjusted;
    }

    public String encrypt(String plainText) {
        if (plainText == null || plainText.isEmpty()) {
            return plainText;
        }

        try {
            byte[] keyBytes = getKey();
            SecretKeySpec keySpec = new SecretKeySpec(keyBytes, KEY_ALGORITHM);

            byte[] iv = new byte[IV_LENGTH];
            secureRandom.nextBytes(iv);
            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.ENCRYPT_MODE, keySpec, ivSpec);

            byte[] encrypted = cipher.doFinal(plainText.getBytes(StandardCharsets.UTF_8));

            byte[] ivAndCipher = new byte[IV_LENGTH + encrypted.length];
            System.arraycopy(iv, 0, ivAndCipher, 0, IV_LENGTH);
            System.arraycopy(encrypted, 0, ivAndCipher, IV_LENGTH, encrypted.length);

            return Base64.getEncoder().encodeToString(ivAndCipher);
        } catch (Exception e) {
            logger.error("암호화 중 오류 발생", e);
            throw new RuntimeException("암호화에 실패했습니다.", e);
        }
    }

    public String decrypt(String encryptedText) {
        if (encryptedText == null || encryptedText.isEmpty()) {
            return encryptedText;
        }

        try {
            byte[] keyBytes = getKey();
            SecretKeySpec keySpec = new SecretKeySpec(keyBytes, KEY_ALGORITHM);

            byte[] ivAndCipher = Base64.getDecoder().decode(encryptedText);
            if (ivAndCipher.length <= IV_LENGTH) {
                logger.warn("복호화 대상 데이터 길이가 IV보다 짧습니다. 원본을 그대로 반환합니다.");
                return encryptedText;
            }

            byte[] iv = Arrays.copyOfRange(ivAndCipher, 0, IV_LENGTH);
            byte[] cipherBytes = Arrays.copyOfRange(ivAndCipher, IV_LENGTH, ivAndCipher.length);

            IvParameterSpec ivSpec = new IvParameterSpec(iv);

            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.DECRYPT_MODE, keySpec, ivSpec);

            byte[] decrypted = cipher.doFinal(cipherBytes);
            return new String(decrypted, StandardCharsets.UTF_8);
        } catch (Exception e) {
            logger.error("복호화 중 오류 발생. value={}", encryptedText, e);
            // 정책에 따라 예외를 던지거나, 원문을 그대로 돌려줄지 선택
            return encryptedText;
        }
    }
}