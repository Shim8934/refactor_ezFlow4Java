package egovframework.ezEKP.ezBoard.vo;

public class BoardMyFavoriteVO {
	
	/**게시판아이디	 */
	private String boardId;
	/**게시판명	 */
	private String boardName;
	/**게시판명(영어)	 */
	private String boardName2;
	/**게시판명(일본어)  */
	private String boardName3;
	/**게시판명(중국어)	 */
	private String boardName4;
	/**게시판명(인니어)	 */
	private String boardName6;
	/**탭번호	 */
	private String tabUsed;
	/** 구분	 */
	private String guBun;
	/**트리아이디	 */
	private String treeId;
	/**유저아이디	 */
	private String userId;
	/**트리명	 */
	private String treeName;
	/**트리명(영어)  */
	private String treeName2;
	/**트리명(일본어) */
	private String treeName3;
	/**트리명(중국어) */
	private String treeName4;
	/**트리명(인니어) */
	private String treeName6;
	/**트리 레벨	 */
	private String treeLevel;
	/**  트리 단계	*/
	private int treeStep;
	/**  트리어퍼	*/
	private String treeUpper;
	/**  자식갯수	*/
	private int childCnt;
	/**  트리게시판아이디	*/
	private String treeBoardId;
	/**뭐뭐여부 */
	private String isLeaf;
	/** 선택여부*/
	private String select;
	/**확정여부 */
	private String expended;
	/** xml대타*/
	private String data4;
	/** 현재 날짜및 시간*/
	private String nowDate;
	/** 현재시간 -5*/
	private String fromNow;
	/** 리스트 타입 (1: 일반보기, 2: 안읽은 게시물 보기, 3: 완료게시물 보기) */
	private String type;
	/** */
	private String boardAdmin_FG;
	/** */
	private String mode;
	/** 선택한 트리아이디*/
	private String selTreeID;
	/** 옮겨질 트리아이디*/
	private String moveTreeID;
	/** 보는 순서*/
	private String viewOrder;
	/** 테넌트아이디*/
	private int tenantID;
	/** 2018-06-26 홍승비 - companyID 추가*/
	private String companyID;
	
	private String useVersion;
	
	public String getBoardId() {
		return boardId;
	}
	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}
	public String getBoardName() {
		return boardName;
	}
	public void setBoardName(String boardName) {
		this.boardName = boardName;
	}
	public String getBoardName2() {
		return boardName2;
	}
	public void setBoardName2(String boardName2) {
		this.boardName2 = boardName2;
	}
	public String getBoardName3() {
		return boardName3;
	}
	public void setBoardName3(String boardName3) {
		this.boardName3 = boardName3;
	}
	public String getBoardName4() {
		return boardName4;
	}
	public void setBoardName4(String boardName4) {
		this.boardName4 = boardName4;
	}
	public String getBoardName6() {
		return boardName6;
	}
	public void setBoardName6(String boardName6) {
		this.boardName6 = boardName6;
	}
	public String getTabUsed() {
		return tabUsed;
	}
	public void setTabUsed(String tabUsed) {
		this.tabUsed = tabUsed;
	}
	public String getGuBun() {
		return guBun;
	}
	public void setGuBun(String guBun) {
		this.guBun = guBun;
	}
	public String getTreeId() {
		return treeId;
	}
	public void setTreeId(String treeId) {
		this.treeId = treeId;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getTreeName() {
		return treeName;
	}
	public void setTreeName(String treeName) {
		this.treeName = treeName;
	}
	public String getTreeName2() {
		return treeName2;
	}
	public void setTreeName2(String treeName2) {
		this.treeName2 = treeName2;
	}
	public String getTreeName3() {
		return treeName3;
	}
	public void setTreeName3(String treeName3) {
		this.treeName3 = treeName3;
	}
	public String getTreeName4() {
		return treeName4;
	}
	public String getTreeName6() {
		return treeName6;
	}
	public void setTreeName6(String treeName6) {
		this.treeName6 = treeName6;
	}
	public void setTreeName4(String treeName4) {
		this.treeName4 = treeName4;
	}
	public String getTreeLevel() {
		return treeLevel;
	}
	public void setTreeLevel(String treeLevel) {
		this.treeLevel = treeLevel;
	}
	public int getTreeStep() {
		return treeStep;
	}
	public void setTreeStep(int treeStep) {
		this.treeStep = treeStep;
	}
	public String getTreeUpper() {
		return treeUpper;
	}
	public void setTreeUpper(String treeUpper) {
		this.treeUpper = treeUpper;
	}
	public int getChildCnt() {
		return childCnt;
	}
	public void setChildCnt(int childCnt) {
		this.childCnt = childCnt;
	}
	public String getTreeBoardId() {
		return treeBoardId;
	}
	public void setTreeBoardId(String treeBoardId) {
		this.treeBoardId = treeBoardId;
	}
	public String getIsLeaf() {
		return isLeaf;
	}
	public void setIsLeaf(String isLeaf) {
		this.isLeaf = isLeaf;
	}
	public String getSelect() {
		return select;
	}
	public void setSelect(String select) {
		this.select = select;
	}
	public String getExpended() {
		return expended;
	}
	public void setExpended(String expended) {
		this.expended = expended;
	}
	public String getData4() {
		return data4;
	}
	public void setData4(String data4) {
		this.data4 = data4;
	}
	public String getNowDate() {
		return nowDate;
	}
	public void setNowDate(String nowDate) {
		this.nowDate = nowDate;
	}
	public String getFromNow() {
		return fromNow;
	}
	public void setFromNow(String fromNow) {
		this.fromNow = fromNow;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getBoardAdmin_FG() {
		return boardAdmin_FG;
	}
	public void setBoardAdmin_FG(String boardAdmin_FG) {
		this.boardAdmin_FG = boardAdmin_FG;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
	public String getSelTreeID() {
		return selTreeID;
	}
	public void setSelTreeID(String selTreeID) {
		this.selTreeID = selTreeID;
	}
	public String getMoveTreeID() {
		return moveTreeID;
	}
	public void setMoveTreeID(String moveTreeID) {
		this.moveTreeID = moveTreeID;
	}
	public String getViewOrder() {
		return viewOrder;
	}
	public void setViewOrder(String viewOrder) {
		this.viewOrder = viewOrder;
	}
	public int getTenantID() {
		return tenantID;
	}
	public void setTenantID(int tenantID) {
		this.tenantID = tenantID;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}

	public String getUseVersion() {
		return useVersion;
	}

	public void setUseVersion(String useVersion) {
		this.useVersion = useVersion;
	}
}
