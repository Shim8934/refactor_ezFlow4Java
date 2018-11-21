package egovframework.ezEKP.ezNewPortal.vo;

import java.util.List;

public class PortletInfoVO {

	private int portletId; //포틀릿 아이디
	private int portletOrder; //포틀릿 순서
	private String portletName; //포틀릿명
	private int menuId; //포틀릿과 연결된 메뉴 아이디
	private String portletUrl; //포틀릿 경로
	private boolean isGeneral; //포틀릿 타입 : 기본(true), 추가(false)
	private int defaultOrder; //제공된 포틀릿 기본 순서
	private String portletCategory; //게시판(0), 메일(1), 결재(2), 외부링크(3)
	private String connectionUrl; //포틀릿 연결 url
	private boolean portletUsed; //포틀릿 사용 여부 : 사용(true), 사용안함(false)
	private String portletBoardId; // 포틀릿 연결 게시판 id
	private List<PortletNameInfoVO> portletNameList; // 포틀릿명 리스트
	private String boardName1;
	private String boardName2;
	private String menuName;
	private boolean accessYN;
	
	//이거 필요한가
	private String userAuth;
	//이거 필요한가
	private String deptAuth;
	//이거 필요한가
	private String comAuth;
	
	public String getUserAuth() {
		return userAuth;
	}
	public void setUserAuth(String userAuth) {
		this.userAuth = userAuth;
	}
	public String getDeptAuth() {
		return deptAuth;
	}
	public void setDeptAuth(String deptAuth) {
		this.deptAuth = deptAuth;
	}
	public String getComAuth() {
		return comAuth;
	}
	public void setComAuth(String comAuth) {
		this.comAuth = comAuth;
	}
	public List<PortletNameInfoVO> getPortletNameList() {
		return portletNameList;
	}
	public void setPortletNameList(List<PortletNameInfoVO> portletNameList) {
		this.portletNameList = portletNameList;
	}
	public int getPortletId() {
		return portletId;
	}
	public void setPortletId(int portletId) {
		this.portletId = portletId;
	}
	public int getPortletOrder() {
		return portletOrder;
	}
	public void setPortletOrder(int portletOrder) {
		this.portletOrder = portletOrder;
	}
	public String getPortletName() {
		return portletName;
	}
	public void setPortletName(String portletName) {
		this.portletName = portletName;
	}
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public String getPortletUrl() {
		return portletUrl;
	}
	public void setPortletUrl(String portletUrl) {
		this.portletUrl = portletUrl;
	}
	public boolean isGeneral() {
		return isGeneral;
	}
	public void setGeneral(boolean isGeneral) {
		this.isGeneral = isGeneral;
	}
	public int getDefaultOrder() {
		return defaultOrder;
	}
	public void setDefaultOrder(int defaultOrder) {
		this.defaultOrder = defaultOrder;
	}
	public String getPortletCategory() {
		return portletCategory;
	}
	public void setPortletCategory(String portletCategory) {
		this.portletCategory = portletCategory;
	}
	public String getConnectionUrl() {
		return connectionUrl;
	}
	public void setConnectionUrl(String connectionUrl) {
		this.connectionUrl = connectionUrl;
	}
	public boolean isPortletUsed() {
		return portletUsed;
	}
	public void setPortletUsed(boolean portletUsed) {
		this.portletUsed = portletUsed;
	}
	public String getPortletBoardId() {
		return portletBoardId;
	}
	public void setPortletBoardId(String portletBoardId) {
		this.portletBoardId = portletBoardId;
	}

	public String getBoardName1() {
		return boardName1;
	}
	public void setBoardName1(String boardName1) {
		this.boardName1 = boardName1;
	}
	public String getBoardName2() {
		return boardName2;
	}
	public void setBoardName2(String boardName2) {
		this.boardName2 = boardName2;
	}
	public String getMenuName() {
		return menuName;
	}
	public void setMenuName(String menuName) {
		this.menuName = menuName;
	}
	public boolean isAccessYN() {
		return accessYN;
	}
	public void setAccessYN(boolean accessYN) {
		this.accessYN = accessYN;
	}
	@Override
	public String toString() {
		return "PortletInfoVO [portletId=" + portletId + ", portletOrder=" + portletOrder + ", portletName=" + portletName + ", menuId=" + menuId + ", portletUrl=" + portletUrl + ", isGeneral="
				+ isGeneral + ", defaultOrder=" + defaultOrder + ", portletCategory=" + portletCategory + ", connectionUrl=" + connectionUrl + ", portletUsed=" + portletUsed + ", portletBoardId="
				+ portletBoardId + ", portletNameList=" + portletNameList + ", boardName1=" + boardName1 + ", boardName2=" + boardName2 + ", menuName=" + menuName + ", accessYN=" + accessYN
				+ ", userAuth=" + userAuth + ", deptAuth=" + deptAuth + ", comAuth=" + comAuth + "]";
	}
}
