package egovframework.ezEKP.ezEmail.vo;

import java.util.Date;
import java.util.Locale;

import net.fortuna.ical4j.model.Parameter;
import net.fortuna.ical4j.model.PropertyList;
import net.fortuna.ical4j.model.Recur;
import net.fortuna.ical4j.model.property.*;

public class IcalVO {
	
	// 제목
	private Summary summary;
	private String summaryStr;

	// 하루종일
	private boolean dtAllDay;
	
	// 시작 Date
	private DtStart dtStart;
	private Date dtStartDate;
	
	// 종료 Date
	private DtEnd dtEnd;
	private Date dtEndDate;
	
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
			organizerCn = organizer.getParameter(Parameter.CN).getValue().toString();
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
