package egovframework.ezMobile.ezSurvey.vo;

import java.util.List;

public class MSimpleDeptVO {
	private String deptId;
	private String deptName;
	private String deptName1;
	private String deptName2;
	private String hasSub;
	private String level;
	private String mail;
	private List<MSimpleDeptVO> subDepts;
	
	public String getDeptId() {
		return deptId;
	}
	
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	
	public String getDeptName() {
		return deptName;
	}
	
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	
	public String getHasSub() {
		return hasSub;
	}
	
	public void setHasSub(String hasSub) {
		this.hasSub = hasSub;
	}
	
	public List<MSimpleDeptVO> getSubDepts() {
		return subDepts;
	}
	
	public void setSubDepts(List<MSimpleDeptVO> subDepts) {
		this.subDepts = subDepts;
	}
	
	public String getLevel() {
		return level;
	}
	
	public void setLevel(String level) {
		this.level = level;
	}
	
	public String getDeptName1() {
		return deptName1;
	}
	
	public void setDeptName1(String deptName1) {
		this.deptName1 = deptName1;
	}
	
	public String getDeptName2() {
		return deptName2;
	}
	
	public void setDeptName2(String deptName2) {
		this.deptName2 = deptName2;
	}
	
	public String getMail() {
		return mail;
	}
	
	public void setMail(String mail) {
		this.mail = mail;
	}
}
