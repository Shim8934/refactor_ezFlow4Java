package egovframework.ezEKP.ezSystem.vo;

public class AccessIdVO {
	String accessNo;
	String cn;
	String department;
	String name;
	
	public String getAccessNo() {
		return accessNo;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public void setAccessNo(String accessNo) {
		this.accessNo = accessNo;
	}
	
	public String getCn() {
		return cn;
	}
	
	public void setCn(String cn) {
		this.cn = cn;
	}
	
	public String getDepartment() {
		return department;
	}
	
	public void setDepartment(String department) {
		this.department = department;
	}
}
