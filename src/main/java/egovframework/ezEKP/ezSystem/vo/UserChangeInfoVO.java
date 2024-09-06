package egovframework.ezEKP.ezSystem.vo;

import java.util.List;

import egovframework.let.user.login.vo.LoginVO;

public class UserChangeInfoVO {

	private int seq;
	private String userId;
	private String userNm;
	private String userNm2;
	private String deptId;
	private String deptNm;
	private String deptNm2;
	private String companyId;
	private String companyNm;
	private String companyNm2;
	private String updatedt;
	private String targetDeptId;
	private String targetDeptNm;
	private String targetDeptNm2;
	private String updateType;
	private String executorId;
	private String executorNm;
	private String executorNm2;
	private String executorIp;
	private int tenantId;
	
	private LoginVO userInfo;
	private String lang;
	private String manualFlag;
	private String targetType;
	private String countryName;

	private UserChangeInfoVO userChVo;
	
	public UserChangeInfoVO getUserChVo() {
		return userChVo;
	}
	public void setUserChVo(UserChangeInfoVO userChVo, String userID, String deptId, String deptNm, String deptNm2, String updateType) {
		userChVo.setUserId(userID);
		userChVo.setTargetDeptId(deptId);
		userChVo.setTargetDeptNm(deptNm);
		userChVo.setTargetDeptNm2(deptNm2);
		userChVo.setUpdateType(updateType);
		this.userChVo = userChVo;
	}
	public int getSeq() {
		return seq;
	}
	public void setSeq(int seq) {
		this.seq = seq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserNm() {
		return userNm;
	}
	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
	public String getUserNm2() {
		return userNm2;
	}
	public void setUserNm2(String userNm2) {
		this.userNm2 = userNm2;
	}
	public String getDeptId() {
		return deptId;
	}
	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}
	public String getDeptNm() {
		return deptNm;
	}
	public void setDeptNm(String deptNm) {
		this.deptNm = deptNm;
	}
	public String getDeptNm2() {
		return deptNm2;
	}
	public void setDeptNm2(String deptNm2) {
		this.deptNm2 = deptNm2;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getCompanyNm() {
		return companyNm;
	}
	public void setCompanyNm(String companyNm) {
		this.companyNm = companyNm;
	}
	public String getCompanyNm2() {
		return companyNm2;
	}
	public void setCompanyNm2(String companyNm2) {
		this.companyNm2 = companyNm2;
	}
	public String getUpdatedt() {
		return updatedt;
	}
	public void setUpdatedt(String updatedt) {
		this.updatedt = updatedt;
	}
	public String getTargetDeptId() {
		return targetDeptId;
	}
	public void setTargetDeptId(String targetDeptId) {
		this.targetDeptId = targetDeptId;
	}
	public String getTargetDeptNm() {
		return targetDeptNm;
	}
	public void setTargetDeptNm(String targetDeptNm) {
		this.targetDeptNm = targetDeptNm;
	}
	public String getTargetDeptNm2() {
		return targetDeptNm2;
	}
	public void setTargetDeptNm2(String targetDeptNm2) {
		this.targetDeptNm2 = targetDeptNm2;
	}
	public String getUpdateType() {
		return updateType;
	}
	public void setUpdateType(String updateType) {
		this.updateType = updateType;
	}
	public String getExecutorId() {
		return executorId;
	}
	public void setExecutorId(String executorId) {
		this.executorId = executorId;
	}
	public String getExecutorNm() {
		return executorNm;
	}
	public void setExecutorNm(String executorNm) {
		this.executorNm = executorNm;
	}
	public String getExecutorNm2() {
		return executorNm2;
	}
	public void setExecutorNm2(String executorNm2) {
		this.executorNm2 = executorNm2;
	}
	public String getExecutorIp() {
		return executorIp;
	}
	public void setExecutorIp(String executorIp) {
		this.executorIp = executorIp;
	}
	public int getTenantId() {
		return tenantId;
	}
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	public String getLang() {
		return lang;
	}
	public void setLang(String lang) {
		this.lang = lang;
	}
	public String getManualFlag() {
		return manualFlag;
	}
	public void setManualFlag(String manualFlag) {
		this.manualFlag = manualFlag;
	}
	public String getTargetType() {
		return targetType;
	}
	public void setTargetType(String targetType) {
		this.targetType = targetType;
	}
	public String getCountryName() {
		return countryName;
	}
	public void setCountryName(String countryName) {
		this.countryName = countryName;
	}
	public LoginVO getUserInfo() {
		return userInfo;
	}
	public void setUserInfo(LoginVO userInfo) {
		this.userInfo = userInfo;
	}

}
