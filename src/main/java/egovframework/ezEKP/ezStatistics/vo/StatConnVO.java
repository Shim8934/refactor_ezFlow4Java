package egovframework.ezEKP.ezStatistics.vo;

public class StatConnVO {
	private String day;
	
	private String connectCnt;
	
	private String date;
	
	private String total;
	
	private String connectBrowser;
	
	private String type;
	
	private String connectOS;

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getConnectOS() {
		return connectOS;
	}

	public void setConnectOS(String connectOS) {
		this.connectOS = connectOS;
	}

	public String getDay() {
		return day;
	}

	public void setDay(String day) {
		this.day = day;
	}

	public String getConnectCnt() {
		return connectCnt;
	}

	public void setConnectCnt(String connctCnt) {
		this.connectCnt = connctCnt;
	}

	public String getDate() {
		return date;
	}

	public void setDate(String date) {
		this.date = date;
	}

	public String getTotal() {
		return total;
	}

	public void setTotal(String total) {
		this.total = total;
	}

	public String getConnectBrowser() {
		return connectBrowser;
	}

	public void setConnectBrowser(String connectBrowser) {
		this.connectBrowser = connectBrowser;
	}
	
}
