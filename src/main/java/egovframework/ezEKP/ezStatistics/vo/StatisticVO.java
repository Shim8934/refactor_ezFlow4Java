package egovframework.ezEKP.ezStatistics.vo;

import egovframework.let.user.login.vo.LoginVO;

import java.time.LocalDateTime;

public class StatisticVO {
    private LoginVO userInfo;
    private String ip;
    private String userId;
    private int tenantId;
    private String companyId;
    private String deptId;
    private LocalDateTime time;  // 원본 시간 데이터
    private int year;           // 변환된 연도
    private int month;          // 변환된 월
    private int day;            // 변환된 일
    private int hour;           // 변환된 시간
    private long timeCode;     // 변환된 시간 숫자열
    private int monthCode;     // 변환된 시간 숫자열
    private int menuId;
    private Code code;
    private int statCount;

    public void setTimeNow() {
        setTime(LocalDateTime.now());
    }

    public void setUserInfo(LoginVO userInfo) {
        this.userInfo = userInfo;
        setTenantId(userInfo.getTenantId());
        setCompanyId(userInfo.getCompanyID());
        setDeptId(userInfo.getDeptID());
        setUserId(userInfo.getId());
        setIp(userInfo.getIp());
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }

    public void setTime(LocalDateTime time) {
        this.time = time;
        if (this.time != null) {
            this.year = time.getYear();
            this.month = time.getMonthValue();
            this.day = time.getDayOfMonth();
            this.hour = time.getHour();
            this.timeCode = this.year * 1_000_000L + this.month * 10_000 + this.day * 100 + this.hour;
            this.monthCode = this.year * 100 + this.month;
        }
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public LoginVO getUserInfo() {
        return userInfo;
    }

    public String getIp() {
        return ip;
    }

    public String getUserId() {
        return userId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public LocalDateTime getTime() {
        return time;
    }

    public int getYear() {
        return year;
    }

    public int getMonth() {
        return month;
    }

    public int getDay() {
        return day;
    }

    public int getHour() {
        return hour;
    }

    public long getTimeCode() {
        return timeCode;
    }

    public int getMenuId() {
        return menuId;
    }

    public Code getCode() {
        return code;
    }

    public void setCode(Code code) {
        this.code = code;
    }

    public int getStatCount() {
        return statCount;
    }

    public void setStatCount(int statCount) {
        this.statCount = statCount;
    }

    public String getCompanyId() {
        return companyId;
    }

    public void setCompanyId(String companyId) {
        this.companyId = companyId;
    }

    public String getDeptId() {
        return deptId;
    }

    public void setDeptId(String deptId) {
        this.deptId = deptId;
    }

    public int getMonthCode() {
        return monthCode;
    }

    @Override
    public String toString() {
        return "StatisticVO{" +
                "ip='" + ip + '\'' +
                ", userId='" + userId + '\'' +
                ", tenantId=" + tenantId +
                ", time=" + time +
                ", year=" + year +
                ", month=" + month +
                ", day=" + day +
                ", hour=" + hour +
                ", timeCode=" + timeCode +
                ", menuId='" + menuId + '\'' +
                ", code=" + code +
                ", statCount=" + statCount +
                '}';
    }

    public enum Code {ACCESS}
}
