package ifms.core.security.password;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;

public class IfmsPasswordEncoder implements PasswordEncoder {


    private final BCryptPasswordEncoder bCryptPasswordEncoder;

    // 기본 생성자에서 BCryptPasswordEncoder를 사용
    public IfmsPasswordEncoder() {
        this.bCryptPasswordEncoder = new BCryptPasswordEncoder();
    }

    @Override
    public String encode(CharSequence rawPassword) {
        return bCryptPasswordEncoder.encode(rawPassword);
    }

    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        // 입력된 비밀번호와 암호화된 비밀번호를 비교
        return bCryptPasswordEncoder.matches(rawPassword, encodedPassword);
    }


}
