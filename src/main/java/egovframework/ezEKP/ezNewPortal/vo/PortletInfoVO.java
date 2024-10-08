package egovframework.ezEKP.ezNewPortal.vo;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
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
	private int boardGubun;	// 게시판 구분
	private String menuName;
	private String userAuth;
	private String deptAuth;
	private String comAuth;
	private boolean accessYN;
	private boolean isFixed; // 관리자가 포틀릿을 끌 수 없도록 지정 : 
							//포틀릿 미사용 불가(true), 포틀릿 미사용 가능(false)
	//2019.07.15 유은정 : 포틀릿 및 메뉴 코드 개선 작업
	private String portletCode;
	private String menuCode;
	private String classSize = "one_by_one";	// 포틀릿 사이즈
	
	private String portletConnectionId; // 포틀릿 연계(SystemConfig) id
	private String connectionName; // 포틀릿 연계 포틀릿 코드 이름
	
	private List<String> listPortletSize = new ArrayList<>(Collections.singletonList("one_by_one"));

	public boolean isFixBoard() {
		for (FixBoardCode code : FixBoardCode.values()) {
			if (code.getCode().equalsIgnoreCase(this.getPortletCode())) {
				return true;
			}
		}
		return false;
	}

	public enum FixBoardCode {
		FIX_LEFT("fixLeft"), FIX_RIGHT("fixRight");

		private String code;

		FixBoardCode(String code) {
			this.code = code;
		}

		public String getCode() {
			return code;
		}
	}

	public String getPortletCode() {
		return portletCode;
	}
	public void setPortletCode(String portletCode) {
		this.portletCode = portletCode;
	}
	public String getMenuCode() {
		return menuCode;
	}
	public void setMenuCode(String menuCode) {
		this.menuCode = menuCode;
	}
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
	public boolean isFixed() {
		return isFixed;
	}
	public void setFixed(boolean isFixed) {
		this.isFixed = isFixed;
	}

	public String getClassSize() {
		return classSize;
	}

	public void setClassSize(String classSize) {
		this.classSize = classSize != null ? classSize : "one_by_one";
	}

	public List<String> getListPortletSize() {
		return listPortletSize;
	}

	public void setListPortletSize(List<String> listPortletSize) {
		this.listPortletSize = listPortletSize;
	}

	public void addListPortletSize(String size) {
		this.listPortletSize.add(size);
	}

	public int getBoardGubun() {
		return boardGubun;
	}

	public void setBoardGubun(int boardGubun) {
		this.boardGubun = boardGubun;
	}
	
	public String getPortletConnectionId() {
		return portletConnectionId;
	}
	
	public void setPortletConnectionId(String portletConnectionId) {
		this.portletConnectionId = portletConnectionId;
	}
	
	public String getConnectionName() {
		return connectionName;
	}
	
	public void setConnectionName(String connectionName) {
		this.connectionName = connectionName;
	}
	
	@Override
	public String toString() {
		return "[portletId=" + portletId + " portletName=" + portletName + "]"; // 로그정리
	}
}
