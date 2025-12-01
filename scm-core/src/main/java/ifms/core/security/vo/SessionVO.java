package ifms.core.security.vo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 세션 VO
 * @author HJSeo
 *
 */
public final class SessionVO implements Serializable {
    private static final long serialVersionUID = 1L;
    /* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ [userId] 세션정보 START ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */
    private String userId;								/* [userId] - Spring Security 에서 예약된 영역 아님 */
    private String userPswd;
    private String pswdEncpt;							/* [userId] - Spring Security 에서 예약된 영역 */
    private String lgnId;								/* [userId] - Spring Security 에서 예약된 영역 */
    private String userGroupCd;							/* [userId] - 사용자그룹코드 - [] */
    private Map<String, Object> mainUserMap;			/* [userId] - 현재사용자의 세션정보 - userId에 대한 사용자정보*/
    private String ifmsGubun;							/* 망구분 : SYE010(포탈), SYE020(행정), SYE020(관리자) */
    private String aprvYn;
    /* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ [userId] 세션정보 END ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */

    /* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ [szmsId] 세션정보 START ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */
    private String crtMdfcnAuthrtYn = "Y";				/* 현재 접속 program url 수정 권한 (Y/N) - 2024.11.28 */
    private String ifmsId;								/* [szmsId] - 서비스 대상 */
    private Map<String, Object> userMap;				/* [szmsId] - 서비스 대상 사용자의 세션정보 */
    private List<Map<String, Object>> roleList;			/* [szmsId] - 서비스 대상 사용자의 역할목록 */
    private List<Map<String, Object>> menuList;			/* [szmsId] - 서비스 대상 사용자의 메뉴목록 */
    private String menuJson;
    private Map<String, Object> ifmsMap;				/* [szmsId] - 서비스 대상 사업장ID의 사업장정보 - bplcId 정보 */
    private int lgnFailLckYn;						/* 로그인 과다실패로 인한 정지여부 */

    private String isMobile;
    /* ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ [szmsId] 세션정보 END ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ */


    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getUserPswd() {
        return userPswd;
    }

    public void setUserPswd(String userPswd) {
        this.userPswd = userPswd;
    }

    public String getPswdEncpt() {
        return pswdEncpt;
    }

    public void setPswdEncpt(String pswdEncpt) {
        this.pswdEncpt = pswdEncpt;
    }

    public String getLgnId() {
        return lgnId;
    }

    public void setLgnId(String lgnId) {
        this.lgnId = lgnId;
    }

    public String getUserGroupCd() {
        return userGroupCd;
    }

    public void setUserGroupCd(String userGroupCd) {
        this.userGroupCd = userGroupCd;
    }

    public Map<String, Object> getMainUserMap() {
        return new HashMap<>(this.mainUserMap);
    }

    public void setMainUserMap(Map<String, Object> mainUserMap) {
        this.mainUserMap = new HashMap<>(mainUserMap);
    }

    public String getIfmsGubun() {
        return ifmsGubun;
    }

    public void setIfmsGubun(String ifmsGubun) {
        this.ifmsGubun = ifmsGubun;
    }

    public String getAprvYn() {
        return aprvYn;
    }

    public void setAprvYn(String aprvYn) {
        this.aprvYn = aprvYn;
    }

    public String getIfmsId() {
        return ifmsId;
    }

    public void setIfmsId(String ifmsId) {
        this.ifmsId = ifmsId;
    }

    public Map<String, Object> getUserMap() {
        return new HashMap<>(this.userMap);
    }

    public void setUserMap(Map<String, Object> userMap) {
        this.userMap = new HashMap<>(userMap);
    }

    public List<Map<String, Object>> getRoleList() {
        List<Map<String, Object>> copy = new ArrayList<>();
        for (Map<String, Object> map : this.roleList) {
            copy.add(new HashMap<>(map));
        }
        return copy;
    }

    public void setRoleList(List<Map<String, Object>> roleList) {
        this.roleList = new ArrayList<>();
        for (Map<String, Object> map : roleList) {
            this.roleList.add(new HashMap<>(map));
        }
    }

    public List<Map<String, Object>> getMenuList() {
        return menuList;
    }

    public void setMenuList(List<Map<String, Object>> menuList) {
        this.menuList = new ArrayList<>();
        for (Map<String, Object> map : menuList) {
            this.menuList.add(new HashMap<>(map));
        }
    }

    public String getMenuJson() {
        return menuJson;
    }

    public void setMenuJson(String menuJson) {
        this.menuJson = menuJson;
    }

    public Map<String, Object> getIfmsMap() {
        return new HashMap<>(this.ifmsMap);
    }

    public void setIfmsMap(Map<String, Object> ifmsMap) {
        if (ifmsMap == null) {
            this.ifmsMap = null;
        } else {
            this.ifmsMap = new HashMap<>(ifmsMap);
        }
    }

    public int getLgnFailLckYn() {
        return lgnFailLckYn;
    }

    public void setLgnFailLckYn(int lgnFailLckYn) {
        this.lgnFailLckYn = lgnFailLckYn;
    }

    public void setIsMobile(String isMobile) { this.isMobile = isMobile; }

    public String getIsMobile() { return isMobile; }

    public String getCrtMdfcnAuthrtYn() {
        return crtMdfcnAuthrtYn;
    }

    public void setCrtMdfcnAuthrtYn(String crtMdfcnAuthrtYn) {
        this.crtMdfcnAuthrtYn = crtMdfcnAuthrtYn;
    }
}