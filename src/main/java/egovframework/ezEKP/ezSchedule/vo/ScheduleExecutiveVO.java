package egovframework.ezEKP.ezSchedule.vo;

import java.util.Date;
public class ScheduleExecutiveVO {
	/** 사용자아이디*/
	private String cn;
	/** 사용자이름*/
	private String displayName; 
	/** 부서이름*/
	private String deptName;
	/** 순서*/
	private int priority; 
	/** 사용여부*/
	private String usage; 
	/** 등록자아이디*/
	private String createUser; 
	/** 등록자이름*/
	private String createUserName; 
	/** 수정일자*/
	private String lastUpdate;

	public String getCn() {
		return cn;
	}

	public void setCn(String cn) {
		this.cn = cn;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public int getPriority() {
		return priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public String getUsage() {
		return usage;
	}

	public void setUsage(String usage) {
		this.usage = usage;
	}

	public String getCreateUser() {
		return createUser;
	}

	public void setCreateUser(String createUser) {
		this.createUser = createUser;
	}

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getLastUpdate() {
		return lastUpdate;
	}

	public void setLastUpdate(String lastUpdate) {
		this.lastUpdate = lastUpdate;
	}
}
