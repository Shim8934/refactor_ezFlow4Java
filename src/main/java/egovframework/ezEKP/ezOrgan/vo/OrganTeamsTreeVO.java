package egovframework.ezEKP.ezOrgan.vo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrganTeamsTreeVO {

	private String data1;              // "USER" or "DEPT"
	private String data2;              // CN
	private String nodeLevel;          // 부서 레벨
	private String department;         // 상위 부서
	private String title;              // 사용자 직위
	private String description;        // 사용자 설명
	private String levelName;          // 사용자 직급 (LEVELNAME)
	private String value;              // 트리뷰 value, 보통 displayname + (title)
	private String displayName;        // 이름 또는 부서명
	private String isLeaf;            // 부서 여부 ("TRUE" or "FALSE")
	private String hasDeptUser;       // 하위 사용자 존재 여부
	private String hasDept;           // 하위 부서 존재 여부
	private String icon;              // 아이콘 클래스 (예: "i_company")
	private String mail;
	private String presence;
	private String upnName;
	private String mobile;
	private String telephoneNumber;
	private String teamsId;
	private String extensionAttribute1;
	private String extensionAttribute2;
	private String extensionAttribute10;
	private String chargeBusiness;
	private String physicalDeliveryOfficeName;
	private String addJob;
	private String textColor;      // TEXTCOLOR
	private String nodeIcon;       // NODEICON
	private String sortOrder;
	
	private Map<String, String> dynamicData = new HashMap<>();

	private List<OrganTeamsTreeVO> nodes; // 하위 노드들

	// 선택 상태 등 UI 구성용 state
	private Map<String, Object> state = new HashMap<>();

	public OrganTeamsTreeVO() {
	}

	public String getData1() {
		return data1;
	}

	public void setData1(String data1) {
		this.data1 = data1;
	}

	public String getData2() {
		return data2;
	}

	public void setData2(String data2) {
		this.data2 = data2;
	}

	public String getNodeLevel() {
		return nodeLevel;
	}

	public void setNodeLevel(String nodeLevel) {
		this.nodeLevel = nodeLevel;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getLevelName() {
		return levelName;
	}

	public void setLevelName(String levelName) {
		this.levelName = levelName;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getDisplayName() {
		return displayName;
	}

	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}

	public String getIsLeaf() {
		return isLeaf;
	}

	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}

	public String getHasDeptUser() {
		return hasDeptUser;
	}

	public void setHasDeptUser(String hasDeptUser) {
		this.hasDeptUser = hasDeptUser;
	}

	public String getHasDept() {
		return hasDept;
	}

	public void setHasDept(String hasDept) {
		this.hasDept = hasDept;
	}

	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public String getMail() {
		return mail;
	}

	public void setMail(String mail) {
		this.mail = mail;
	}

	public String getPresence() {
		return presence;
	}

	public void setPresence(String presence) {
		this.presence = presence;
	}

	public String getUpnName() {
		return upnName;
	}

	public void setUpnName(String upnName) {
		this.upnName = upnName;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public String getTelephoneNumber() {
		return telephoneNumber;
	}

	public void setTelephoneNumber(String telephoneNumber) {
		this.telephoneNumber = telephoneNumber;
	}

	public String getTeamsId() {
		return teamsId;
	}

	public void setTeamsId(String teamsId) {
		this.teamsId = teamsId;
	}

	public String getExtensionAttribute1() {
		return extensionAttribute1;
	}

	public void setExtensionAttribute1(String extensionAttribute1) {
		this.extensionAttribute1 = extensionAttribute1;
	}

	public String getExtensionAttribute2() {
		return extensionAttribute2;
	}

	public void setExtensionAttribute2(String extensionAttribute2) {
		this.extensionAttribute2 = extensionAttribute2;
	}

	public String getExtensionAttribute10() {
		return extensionAttribute10;
	}

	public void setExtensionAttribute10(String extensionAttribute10) {
		this.extensionAttribute10 = extensionAttribute10;
	}

	public String getChargeBusiness() {
		return chargeBusiness;
	}

	public void setChargeBusiness(String chargeBusiness) {
		this.chargeBusiness = chargeBusiness;
	}

	public String getPhysicalDeliveryOfficeName() {
		return physicalDeliveryOfficeName;
	}

	public void setPhysicalDeliveryOfficeName(String physicalDeliveryOfficeName) {
		this.physicalDeliveryOfficeName = physicalDeliveryOfficeName;
	}

	public String getAddJob() {
		return addJob;
	}

	public void setAddJob(String addJob) {
		this.addJob = addJob;
	}

	public String getTextColor() {
		return textColor;
	}

	public void setTextColor(String textColor) {
		this.textColor = textColor;
	}

	public String getNodeIcon() {
		return nodeIcon;
	}

	public void setNodeIcon(String nodeIcon) {
		this.nodeIcon = nodeIcon;
	}

	public String getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}

	public Map<String, String> getDynamicData() {
		return dynamicData;
	}

	public void setDynamicData(Map<String, String> dynamicData) {
		this.dynamicData = dynamicData;
	}

	public List<OrganTeamsTreeVO> getNodes() {
		return nodes;
	}

	public void setNodes(List<OrganTeamsTreeVO> nodes) {
		this.nodes = nodes;
	}

	public Map<String, Object> getState() {
		return state;
	}

	public void setState(Map<String, Object> state) {
		this.state = state;
	}
}