package egovframework.ezEKP.ezSurvey.vo;

import java.util.List;

public class SimpleDeptVO {
	private String deptId;
	private String deptName;
	private String hasSub;
	private String level;
	private List<SimpleDeptVO> subDepts;
	
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
	
	public List<SimpleDeptVO> getSubDepts() {
		return subDepts;
	}
	
	public void setSubDepts(List<SimpleDeptVO> subDepts) {
		this.subDepts = subDepts;
	}
	
	public String getLevel() {
		return level;
	}
	
	public void setLevel(String level) {
		this.level = level;
	}
}
