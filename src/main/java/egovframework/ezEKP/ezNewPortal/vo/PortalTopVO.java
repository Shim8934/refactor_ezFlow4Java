package egovframework.ezEKP.ezNewPortal.vo;

import java.util.Objects;

public class PortalTopVO {
    private int tenantID;
    private String companyID;
    private String userID;
    private int type = 0;
    
    @Override
    public String toString() {
        return "PortalTopVO{" +
                "tenantID=" + tenantID +
                ", companyID='" + companyID + '\'' +
                ", userID='" + userID + '\'' +
                ", type=" + type +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        PortalTopVO that = (PortalTopVO) o;
        return tenantID == that.tenantID && type == that.type && Objects.equals(companyID, that.companyID) && Objects.equals(userID, that.userID);
    }

    @Override
    public int hashCode() {
        return Objects.hash(tenantID, companyID, userID, type);
    }

    public boolean isTop() {
        return type == TopFrameType.TOP.getCode();
    }

    public boolean isLeft() {
        return type == TopFrameType.LEFT.getCode();
    }

    public TopFrameType getTypeEnum() {
        return type == TopFrameType.LEFT.getCode() ? TopFrameType.LEFT : TopFrameType.TOP;
    }

    public int getTenantID() {
        return tenantID;
    }

    public void setTenantID(int tenantID) {
        this.tenantID = tenantID;
    }

    public String getCompanyID() {
        return companyID;
    }

    public void setCompanyID(String companyID) {
        this.companyID = companyID;
    }

    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public enum TopFrameType {
        TOP(0), LEFT(1);

        TopFrameType(int code) {
            this.code = code;
        }

        private final int code;

        public int getCode() {
            return code;
        }
        
        public static TopFrameType fromCode(int code) {
            for (TopFrameType type : TopFrameType.values()) {
                if (type.getCode() == code) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Invalid code: " + code);
        }
    }
}
