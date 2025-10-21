package egovframework.ezEKP.ezEmail.vo;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.Property;
import net.fortuna.ical4j.model.PropertyList;
import net.fortuna.ical4j.model.Recur;
import net.fortuna.ical4j.model.property.*;

public class IcalVO {
	
	// 제목
	private Summary summary;
	private String summaryStr;
	
	// 본문     : X-ALT-DESC
	private Property altDesc;
	private String altDescStr;
	
	// 본문     : X-ALT-DESC;FMTTYPE
	private Parameter fmType;
	
	// 본문     : DESCRIPTION
	private Description description;
	private String descriptionStr;

	// 하루종일
	private boolean dtAllDay;
	
	// 시작 Date
	private DtStart dtStart;
	private Date dtStartDate;
	private String startDtStr;
	
	// 종료 Date
	private DtEnd dtEnd;
	private Date dtEndDate;
	private String endDtStr;
	
	// 장소
	private Location location;
	private String locationStr;
	
	// 참석자
	private PropertyList<Attendee> attendee;
	
	// 주최자
	private Organizer organizer;
	private String organizerCn;
	private String organizerMailTo;
	
	// 반복일정
	private RRule rRule;
	private Recur recur;
	
	// uid
	private Uid uid;
	private String uidStr;
	
	// 로케일
	private Locale locale = Locale.KOREA;

	// 일정 초대 응답 상태 (ACCEPTED, TENTATIVE, DECLINED)
	private String status;

	// 일정 시간 (전체)
	private String period;

	// 일정 초대 응답 시간
	private Date responseDt;

	// 일정 초대 응답한 참석자 주소
	private String attendeeStr;

	private String method;

	public String getMethod() {
		return method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getAttendeeStr() {
		return attendeeStr;
	}

	public void setAttendeeStr(String attendeeStr) {
		this.attendeeStr = attendeeStr;
	}

	public Date getResponseDt() {
		return responseDt;
	}

	public void setResponseDt(Date responseDt) {
		this.responseDt = responseDt;
	}
	
	public String getPeriod() {
		return period;
	}

	public void setPeriod(String period) {
		this.period = period;
	}
	
	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

    public Summary getSummary() {
		return summary;
	}
	public void setSummary(Summary summary) {
		this.summary = summary;
		
		summaryStr = (summary != null) ? summary.getValue() : "";
	}
	public String getSummaryStr() {
		return summaryStr;
	}
	public void setSummaryStr(String summaryStr) {
		this.summaryStr = summaryStr;
	}
	public Property getAltDesc() {
		return altDesc;
	}
	public void setAltDesc(Property altDesc) {
		this.altDesc = altDesc;
		
		if (altDesc != null) {
			fmType = altDesc.getParameter(Parameter.FMTTYPE);
			altDescStr = altDesc.getValue().replaceAll("\\;", ";");
		}
	}
	public String getAltDescStr() {
		return altDescStr;
	}
	public void setAltDescStr(String altDescStr) {
		this.altDescStr = altDescStr;
	}
	public Description getDescription() {
		return description;
	}
	public void setDescription(Description description) {
		this.description = description;
		
		descriptionStr = (description != null) ? description.getValue() : "";
	}
	public String getDescriptionStr() {
		return descriptionStr;
	}
	public void setDescriptionStr(String descriptionStr) {
		this.descriptionStr = descriptionStr;
	}
	public boolean isDtAllDay() {
		return dtAllDay;
	}
	public DtStart getDtStart() {
		return dtStart;
	}
	public void setDtStart(DtStart dtStart) {
		this.dtStart = dtStart;
		
		dtStartDate = dtStart.getDate();
		if (dtStart.getParameter(Parameter.VALUE) != null) {
			dtAllDay = dtStart.getParameter(Parameter.VALUE).getValue().equals("DATE") ? true : false;
		}
	}
	public Date getDtStartDate() {
		return dtStartDate;
	}
	public void setDtStartDate(Date dtStartDate) {
		this.dtStartDate = dtStartDate;
	}
	public String getStartDtStr() {
		return startDtStr;
	}
	public void setStartDtStr(String startDtStr) {
		this.startDtStr = startDtStr;
	}
	public Date toStartDate() throws ParseException {
		try {
			if (startDtStr.matches("\\d{8}T\\d{6}")) { // 시간 포함 일정
				return new SimpleDateFormat("yyyyMMdd'T'HHmmss").parse(startDtStr);
			} else if (startDtStr.matches("\\d{8}")) { // 온종일 일정
				return new SimpleDateFormat("yyyyMMdd").parse(startDtStr);
			} else {
				throw new IllegalArgumentException("지원되지 않는 날짜 포맷: " + startDtStr);
			}
		} catch (ParseException e) {
			throw e;
		}
	}
	public DtEnd getDtEnd() {
		return dtEnd;
	}
	public void setDtEnd(DtEnd dtEnd) {
		this.dtEnd = dtEnd;
		
		dtEndDate = dtEnd.getDate();
	}
	public Date getDtEndDate() {
		return dtEndDate;
	}
	public void setDtEndDate(Date dtEndDate) {
		this.dtEndDate = dtEndDate;
	}
	public String getEndDtStr() {
		return endDtStr;
	}
	public void setEndDtStr(String endDtStr) {
		this.endDtStr = endDtStr;
	}
	public Date toEndDate() throws ParseException {
		try {
			if (endDtStr.matches("\\d{8}T\\d{6}")) { // 시간 포함 일정
				return new SimpleDateFormat("yyyyMMdd'T'HHmmss").parse(endDtStr);
			} else if (endDtStr.matches("\\d{8}")) { // 온종일 일정
				return new SimpleDateFormat("yyyyMMdd").parse(endDtStr);
			} else {
				throw new IllegalArgumentException("지원되지 않는 날짜 포맷: " + endDtStr);
			}
		} catch (ParseException e) {
			throw e;
		}
	}
	public Location getLocation() {
		return location;
	}
	public void setLocation(Location location) {
		this.location = location;
		
		locationStr = (location != null) ? location.getValue() : "";
	}
	public String getLocationStr() {
		return locationStr;
	}
	public void setLocationStr(String locationStr) {
		this.locationStr = locationStr;
	}
	public PropertyList<Attendee> getAttendee() {
		return attendee;
	}
	public void setAttendee(PropertyList<Attendee> attendee) {
		this.attendee = attendee;
	}
	public Organizer getOrganizer() {
		return organizer;
	}
	public void setOrganizer(Organizer organizer) {
		this.organizer = organizer;
		
		if (organizer != null) {
			Parameter cn = organizer.getParameter(Parameter.CN);
			String organizerCn = (cn == null) ? "" : cn.getValue().toString();
			organizerMailTo = organizer.getCalAddress().getSchemeSpecificPart().toString();
		}
	}
	public String getOrganizerCn() {
		return organizerCn;
	}
	public void setOrganizerCn(String organizerCn) {
		this.organizerCn = organizerCn;
	}
	public String getOrganizerMailTo() {
		return organizerMailTo;
	}
	public void setOrganizerMailTo(String organizerMailTo) {
		this.organizerMailTo = organizerMailTo;
	}
	public RRule getrRule() {
		return rRule;
	}
	public void setrRule(RRule rRule) {
		this.rRule = rRule;
		
		if (rRule != null) {
			recur = rRule.getRecur();
		}
	}
	public Recur getRecur() {
		return recur;
	}
	public void setRecur(Recur recur) {
		this.recur = recur;
	}
	public Uid getUid() {
		return uid;
	}
	public void setUid(Uid uid) {
		this.uid = uid;
		
		if (uid != null) {
			uidStr = uid.getValue();
		}
	}
	public String getUidStr() {
		return uidStr;
	}
	public void setUidStr(String uidStr) {
		this.uidStr = uidStr;
	}
	public Locale getLocale() {
		return locale;
	}
	public void setLocale(Locale locale) {
		this.locale = locale;
	}
}
