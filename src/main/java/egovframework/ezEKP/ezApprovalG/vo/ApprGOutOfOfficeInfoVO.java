package egovframework.ezEKP.ezApprovalG.vo;

import org.apache.commons.lang3.StringUtils;

import java.text.ParseException;
import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ApprGOutOfOfficeInfoVO {
    /** 테넌트 아이디*/
    private int tenantID;
    /** 유저 아이디*/
    private String userID;
    /** 부재중인 부서아이디*/
    private String deptID;
    /** 부재중 정보*/
    private String proxy;
    /** 부재중인 부서명*/
    private String displayname;
    /** 부재중인 부서명(다국어)*/
    private String displayname2;
    /** 직위명*/
    private String title;
    /** 직위명(다국어)*/
    private String title2;
    /** 직위 아이디(본직은 -1)*/
    private String jobID;

    /** 시작 시간*/
    private ZonedDateTime startTime;
    /** 종료 시간*/
    private ZonedDateTime endTime;
    /** 사유*/
    private String reason;
    /** 대결자 ID*/
    private String substituteID;
    /** 대결자 이름*/
    private String substituteName;
    /** 대결자 부서*/
    private String substituteDepartment;

    public boolean isOutOfOffice() throws ParseException {
        if (StringUtils.isBlank(this.proxy)) {
            return false;
        }

        if (startTime == null || endTime == null) {
            this.setInfo();
        }

        if (startTime == null || endTime == null) {
            return false;
        }

        ZonedDateTime now = OffsetDateTime.now().toZonedDateTime();
        return startTime.isBefore(now) && endTime.isAfter(now);
    }

    public static void main(String[] args) {
        String[] testStrings = {"gbp todo", "todo-gbp", "gbp hello", "hello todo"};

        for (String test : testStrings) {
            if (test.matches("(?=.*gbp)(?=.*todo).*")) {
                System.out.println(test + " matches!");
            } else {
                System.out.println(test + " does not match.");
            }
        }
    }

    public void setInfo() throws ParseException {
        // todo-gbp 현재 유저가 저장할 당시에 offset 기준... 일단 서버기준으로 해놓고 utc로 변경 예정
        ZoneOffset defaultOffset = OffsetDateTime.now().getOffset();

        if (StringUtils.isBlank(this.proxy)) {
            return;
        }

        boolean isMainJob = this.jobID.equals("-1");
        int length = StringUtils.countMatches(this.proxy, ":");
        boolean hasReason = length == 7;
        String temp = this.proxy;

        // 끝에 사유가 있는 경우 만 길이가 달라 지므로 먼저 처리
        if (hasReason) {
            this.reason = StringUtils.substringAfterLast(this.proxy, ":");
            temp = StringUtils.substringBeforeLast(this.proxy, ":");
        }

        // 본직은 대리자id:대리자명:대리자부서:시간
        // 겸직은 대리자id:대리자명:??:시간
        String[] absenteeInfoArr = temp.split(":",-1);
        String[] copied = Arrays.copyOfRange(absenteeInfoArr, 3, 7);
        String wholeTime = String.join(":", copied);

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        Pattern pattern = Pattern.compile("\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}");
        Matcher matcher = pattern.matcher(wholeTime);

        if (matcher.find()) {
            LocalDateTime startLocal = LocalDateTime.parse(matcher.group(), formatter);
            startTime = startLocal.atZone(defaultOffset);
        } else {
            return;
        }

        if (matcher.find()) {
            LocalDateTime endLocal = LocalDateTime.parse(matcher.group(), formatter);
            endTime = endLocal.atZone(defaultOffset);
        }

        this.substituteID = absenteeInfoArr[0];
        this.substituteName = absenteeInfoArr[1];
        this.substituteDepartment = isMainJob ? absenteeInfoArr[2] : null;
    }

    public int getTenantID() {
        return tenantID;
    }

    public String getUserID() {
        return userID;
    }

    public String getDeptID() {
        return deptID;
    }

    public String getProxy() {
        return proxy;
    }

    public String getDisplayname() {
        return displayname;
    }

    public String getDisplayname2() {
        return displayname2;
    }

    public String getTitle() {
        return title;
    }

    public String getTitle2() {
        return title2;
    }

    public String getJobID() {
        return jobID;
    }

    public ZonedDateTime getStartTime() {
        return startTime;
    }

    public ZonedDateTime getEndTime() {
        return endTime;
    }

    public String getReason() {
        return reason;
    }

    public String getSubstituteID() {
        return substituteID;
    }

    public String getSubstituteName() {
        return substituteName;
    }

    public String getSubstituteDepartment() {
        return substituteDepartment;
    }

    @Override
    public String toString() {
        return "ApprGOutOfOfficeInfoVO{" +
                "tenantID=" + tenantID +
                ", userID='" + userID + '\'' +
                ", deptID='" + deptID + '\'' +
                ", proxy='" + proxy + '\'' +
                ", displayname='" + displayname + '\'' +
                ", displayname2='" + displayname2 + '\'' +
                ", title='" + title + '\'' +
                ", title2='" + title2 + '\'' +
                ", jobID='" + jobID + '\'' +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", reason='" + reason + '\'' +
                ", substituteID='" + substituteID + '\'' +
                ", substituteName='" + substituteName + '\'' +
                ", substituteDepartment='" + substituteDepartment + '\'' +
                '}';
    }
}
