package egovframework.ezEKP.ezPersonal.vo;

public class PersonalApprovMailVO {
	/** 도착알림*/
	private String alert;
	/** 완료알림*/
	private String complete;
	/** 반송알림*/
	private String bansong;
	/** 회수알림*/
	private String callBack;
	/** 회송알림*/
	private String hesong;
	/** 보낸편지함저장*/
	private String saveMailFlag;
	
	public String getAlert() {
		return alert;
	}
	public void setAlert(String alert) {
		this.alert = alert;
	}
	public String getComplete() {
		return complete;
	}
	public void setComplete(String complete) {
		this.complete = complete;
	}
	public String getBansong() {
		return bansong;
	}
	public void setBansong(String bansong) {
		this.bansong = bansong;
	}
	public String getCallBack() {
		return callBack;
	}
	public void setCallBack(String callBack) {
		this.callBack = callBack;
	}
	public String getHesong() {
		return hesong;
	}
	public void setHesong(String hesong) {
		this.hesong = hesong;
	}
	public String getSaveMailFlag() {
		return saveMailFlag;
	}
	public void setSaveMailFlag(String saveMailFlag) {
		this.saveMailFlag = saveMailFlag;
	}

}
