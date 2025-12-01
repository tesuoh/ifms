package ifms.core.security.vo;

import java.io.Serializable;

public class AccessibleUrl implements Serializable {
    private static final long serialVersionUID = 1L;
    private String url;
    private boolean modificationAuthority;

    // 기본 생성자
    public AccessibleUrl() {
    }

    // 매개변수가 있는 생성자
    public AccessibleUrl(String url, boolean modificationAuthority) {
        this.url = url;
        this.modificationAuthority = modificationAuthority;
    }

    // Getter 및 Setter 메서드
    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public boolean isModificationAuthority() {
        return modificationAuthority;
    }

    public void setModificationAuthority(boolean modificationAuthority) {
        this.modificationAuthority = modificationAuthority;
    }


}
