package egovframework.ezEKP.ezWebFolder.vo;

import java.sql.Date;

public class MeetingPeriod {
	public static final MeetingPeriod EMPTY;

	static {
		EMPTY = new MeetingPeriod();
		EMPTY.startDate = new Date(0);
		EMPTY.endDate = new Date(0);
	}

	private Date startDate;
	private Date endDate;

	public Date getStartDate() {
		return startDate;
	}

	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}

	public Date getEndDate() {
		return endDate;
	}

	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
}
