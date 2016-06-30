package egovframework.ezEKP.ezCommunity.vo;

public class CommunityClubVO {
	/** 커뮤니티ID*/
	String c_ClubNo;
	/** 커뮤니티 등록 시각*/
	String c_RegDate;
	/** 커뮤니티 이름*/
	String c_ClubName;
	/** 커뮤니티 이름(다국어)*/
	String c_ClubName2;
	/** 커뮤니티 카테고리1*/
	String c_Cate_A;
	/** 커뮤니티 카테고리2*/
	String c_Cate_B;
	/** 커뮤니티 카테고리3*/
	String c_Cate_C;
	/** 커뮤니티 공개 여부*/
	String c_ClubGubun;
	/** 마스터 커뮤니티 승인여부*/
	String c_ClubConfirmType;
	/** 관리자 커뮤니티 승인여부*/
	String c_AdminConfirm;
	/** 커뮤니티 개설자 ID*/
	String c_Maker;
	/** 커뮤니티 마스터 ID*/
	String c_SysopID;
	/** 커뮤니티 회원 수 */
	int c_MemberCnt;
	/** 커뮤니티 홈 로고  실제 파일 이름*/
	String c_Logo;
	/** 커뮤니티 홈 로고 (썸네일용)*/
	String c_Logo_Thumbnail;
	/** 커뮤니티 백그라운드  실제 파일 이름*/
	String c_BgImage;
	/** 커뮤니티 글씨 색*/
	String c_FontColor;
	/** 커뮤니티 백그라운드 색*/
	String c_BgColor;
	/** 커뮤니티 타이틀  글씨 색*/
	String c_TitleFontColor;
	/** clob커뮤니티 소개 */
	String c_ClubDesc;
	/** 커뮤니티 배너  실제 파일 이름*/
	String c_ClubBanner;
	/** 커뮤니티 오픈 시각*/
	String c_OpenDate;
	/** <공지사항> 게시판명*/
	String c_ClubNoticeTitle;
	/** <공지사항> 게시판  제목 색*/
	String c_NoticeTitleColor;
	/** <공지사항> 게시판  글씨 색*/
	String c_NoticeFontColor;
	/** 커뮤니티 왼쪽 메뉴 <공지사항> 게시판 순서*/
	int c_ClubNotice_OrderBy;
	/** <공지사항> 게시판 사용유무*/
	String c_ClubNotice_Exist;
	/** <게시판> 게시판명*/
	String c_ClubBoardTitle;
	/** <게시판> 게시판  제목 색*/
	String c_BoardTitleColor;
	/** <게시판> 게시판  글씨 색*/
	String c_BoardFontColor;
	/** <게시판> 왼쪽 메뉴 공시사항 게시판 순서*/
	int c_ClubBoard_OrderBy;
	/** <게시판> 게시판 사용유무*/
	String c_ClubBoard_Exist;
	/** <자료실> 게시판명*/
	String c_ClubPdsTitle;
	/** <자료실> 게시판  제목 색*/
	String c_PdsTitleColor;
	/** <자료실> 게시판  글씨 색*/
	String c_PdsFontColor;
	/** <자료실> 왼쪽 메뉴 공시사항 게시판 순서*/
	int c_ClubPds_OrderBy;
	/** <자료실> 게시판 사용유무*/
	String c_ClubPds_Exist;
	/** <게시판1> 게시판명*/
	String c_ClubBoard1Title;
	/** <게시판1> 게시판  제목 색*/
	String c_Board1TitleColor;
	/** <게시판1> 게시판 글씨 색*/
	String c_Board1FontColor;
	/** <게시판1 > 왼쪽 메뉴 공시사항 게시판 순서*/
	String c_ClubBoard1_Exist;
	/** <게시판1 > 게시판 사용유무*/
	int c_ClubBoard1_OrderBy;
	/** <게시판2 > 게시판명*/
	String c_ClubBoard2Title;
	/** <게시판2 > 게시판  제목 색*/
	String c_Board2TitleColor;
	/** <게시판2 > 게시판  글씨 색*/
	String c_Board2FontColor;
	/** <게시판2 > 게시판 사용유무*/
	String c_ClubBoard2_Exist;
	/** <게시판2 > 왼쪽 메뉴 공시사항 게시판 순서*/
	int c_ClubBoard2_OrderBy;
	/** <자료실> 게시판명*/
	String c_ClubPds1Title;
	/** <자료실> 게시판  제목 색*/
	String c_Pds1TitleColor;
	/** <자료실> 게시판  글씨 색*/
	String c_Pds1FontColor;
	/** <자료실> 게시판 사용유무*/
	String c_ClubPds1_Exist;
	/** <자료실> 왼쪽 메뉴 공시사항 게시판 순서*/
	int c_ClubPds1_OrderBy;
	/** 커뮤니티 점수*/
	String score;
	/** 회사내외여부*/
	int isIn;
	/** 회사ID*/
	String companyID;
	/** 사용Disk용량*/
	int usingDiskSize;
	/** 메일 발송 여부*/
	String sendMail;
	/** 메일 발송 횟수 */
	String sendMailCnt;
	/** 할당Disk용량*/
	String assignDiskSize;
	/** 커뮤니티 타입*/
	String c_Type;
	/** 게시판 글 수*/
	int itemCnt;
	/** 마스터 ID*/
	String displayName;
	/** 마스터 ID(다국어)*/
	String displayName2;
	/** 마스터 부서명*/
	String description;
	/** 마스터 부서명(다국어)*/
	String description2;
	/** 커뮤니티 검색시 커뮤니티수*/
	int copCnt;
	/** 마스터 이름 */
	String userName;
	/** 마스터 이름(다국어) */
	String userName2;
	/** 권한*/
	String permit;
	
	public String getC_ClubNo() {
		return c_ClubNo;
	}
	public void setC_ClubNo(String c_ClubNo) {
		this.c_ClubNo = c_ClubNo;
	}
	public String getC_RegDate() {
		return c_RegDate;
	}
	public void setC_RegDate(String c_RegDate) {
		this.c_RegDate = c_RegDate;
	}
	public String getC_ClubName() {
		return c_ClubName;
	}
	public void setC_ClubName(String c_ClubName) {
		this.c_ClubName = c_ClubName;
	}
	public String getC_ClubName2() {
		return c_ClubName2;
	}
	public void setC_ClubName2(String c_ClubName2) {
		this.c_ClubName2 = c_ClubName2;
	}
	public String getC_Cate_A() {
		return c_Cate_A;
	}
	public void setC_Cate_A(String c_Cate_A) {
		this.c_Cate_A = c_Cate_A;
	}
	public String getC_Cate_B() {
		return c_Cate_B;
	}
	public void setC_Cate_B(String c_Cate_B) {
		this.c_Cate_B = c_Cate_B;
	}
	public String getC_Cate_C() {
		return c_Cate_C;
	}
	public void setC_Cate_C(String c_Cate_C) {
		this.c_Cate_C = c_Cate_C;
	}
	public String getC_ClubGubun() {
		return c_ClubGubun;
	}
	public void setC_ClubGubun(String c_ClubGubun) {
		this.c_ClubGubun = c_ClubGubun;
	}
	public String getC_ClubConfirmType() {
		return c_ClubConfirmType;
	}
	public void setC_ClubConfirmType(String c_ClubConfirmType) {
		this.c_ClubConfirmType = c_ClubConfirmType;
	}
	public String getC_AdminConfirm() {
		return c_AdminConfirm;
	}
	public void setC_AdminConfirm(String c_AdminConfirm) {
		this.c_AdminConfirm = c_AdminConfirm;
	}
	public String getC_Maker() {
		return c_Maker;
	}
	public void setC_Maker(String c_Maker) {
		this.c_Maker = c_Maker;
	}
	public String getC_SysopID() {
		return c_SysopID;
	}
	public void setC_SysopID(String c_SysopID) {
		this.c_SysopID = c_SysopID;
	}
	public int getC_MemberCnt() {
		return c_MemberCnt;
	}
	public void setC_MemberCnt(int c_MemberCnt) {
		this.c_MemberCnt = c_MemberCnt;
	}
	public String getC_Logo() {
		return c_Logo;
	}
	public void setC_Logo(String c_Logo) {
		this.c_Logo = c_Logo;
	}
	public String getC_Logo_Thumbnail() {
		return c_Logo_Thumbnail;
	}
	public void setC_Logo_Thumbnail(String c_Logo_Thumbnail) {
		this.c_Logo_Thumbnail = c_Logo_Thumbnail;
	}
	public String getC_BgImage() {
		return c_BgImage;
	}
	public void setC_BgImage(String c_BgImage) {
		this.c_BgImage = c_BgImage;
	}
	public String getC_FontColor() {
		return c_FontColor;
	}
	public void setC_FontColor(String c_FontColor) {
		this.c_FontColor = c_FontColor;
	}
	public String getC_BgColor() {
		return c_BgColor;
	}
	public void setC_BgColor(String c_BgColor) {
		this.c_BgColor = c_BgColor;
	}
	public String getC_TitleFontColor() {
		return c_TitleFontColor;
	}
	public void setC_TitleFontColor(String c_TitleFontColor) {
		this.c_TitleFontColor = c_TitleFontColor;
	}
	public String getC_ClubDesc() {
		return c_ClubDesc;
	}
	public void setC_ClubDesc(String c_ClubDesc) {
		this.c_ClubDesc = c_ClubDesc;
	}
	public String getC_ClubBanner() {
		return c_ClubBanner;
	}
	public void setC_ClubBanner(String c_ClubBanner) {
		this.c_ClubBanner = c_ClubBanner;
	}
	public String getC_OpenDate() {
		return c_OpenDate;
	}
	public void setC_OpenDate(String c_OpenDate) {
		this.c_OpenDate = c_OpenDate;
	}
	public String getC_ClubNoticeTitle() {
		return c_ClubNoticeTitle;
	}
	public void setC_ClubNoticeTitle(String c_ClubNoticeTitle) {
		this.c_ClubNoticeTitle = c_ClubNoticeTitle;
	}
	public String getC_NoticeTitleColor() {
		return c_NoticeTitleColor;
	}
	public void setC_NoticeTitleColor(String c_NoticeTitleColor) {
		this.c_NoticeTitleColor = c_NoticeTitleColor;
	}
	public String getC_NoticeFontColor() {
		return c_NoticeFontColor;
	}
	public void setC_NoticeFontColor(String c_NoticeFontColor) {
		this.c_NoticeFontColor = c_NoticeFontColor;
	}
	public int getC_ClubNotice_OrderBy() {
		return c_ClubNotice_OrderBy;
	}
	public void setC_ClubNotice_OrderBy(int c_ClubNotice_OrderBy) {
		this.c_ClubNotice_OrderBy = c_ClubNotice_OrderBy;
	}
	public String getC_ClubNotice_Exist() {
		return c_ClubNotice_Exist;
	}
	public void setC_ClubNotice_Exist(String c_ClubNotice_Exist) {
		this.c_ClubNotice_Exist = c_ClubNotice_Exist;
	}
	public String getC_ClubBoardTitle() {
		return c_ClubBoardTitle;
	}
	public void setC_ClubBoardTitle(String c_ClubBoardTitle) {
		this.c_ClubBoardTitle = c_ClubBoardTitle;
	}
	public String getC_BoardTitleColor() {
		return c_BoardTitleColor;
	}
	public void setC_BoardTitleColor(String c_BoardTitleColor) {
		this.c_BoardTitleColor = c_BoardTitleColor;
	}
	public String getC_BoardFontColor() {
		return c_BoardFontColor;
	}
	public void setC_BoardFontColor(String c_BoardFontColor) {
		this.c_BoardFontColor = c_BoardFontColor;
	}
	public int getC_ClubBoard_OrderBy() {
		return c_ClubBoard_OrderBy;
	}
	public void setC_ClubBoard_OrderBy(int c_ClubBoard_OrderBy) {
		this.c_ClubBoard_OrderBy = c_ClubBoard_OrderBy;
	}
	public String getC_ClubBoard_Exist() {
		return c_ClubBoard_Exist;
	}
	public void setC_ClubBoard_Exist(String c_ClubBoard_Exist) {
		this.c_ClubBoard_Exist = c_ClubBoard_Exist;
	}
	public String getC_ClubPdsTitle() {
		return c_ClubPdsTitle;
	}
	public void setC_ClubPdsTitle(String c_ClubPdsTitle) {
		this.c_ClubPdsTitle = c_ClubPdsTitle;
	}
	public String getC_PdsTitleColor() {
		return c_PdsTitleColor;
	}
	public void setC_PdsTitleColor(String c_PdsTitleColor) {
		this.c_PdsTitleColor = c_PdsTitleColor;
	}
	public String getC_PdsFontColor() {
		return c_PdsFontColor;
	}
	public void setC_PdsFontColor(String c_PdsFontColor) {
		this.c_PdsFontColor = c_PdsFontColor;
	}
	public int getC_ClubPds_OrderBy() {
		return c_ClubPds_OrderBy;
	}
	public void setC_ClubPds_OrderBy(int c_ClubPds_OrderBy) {
		this.c_ClubPds_OrderBy = c_ClubPds_OrderBy;
	}
	public String getC_ClubPds_Exist() {
		return c_ClubPds_Exist;
	}
	public void setC_ClubPds_Exist(String c_ClubPds_Exist) {
		this.c_ClubPds_Exist = c_ClubPds_Exist;
	}
	public String getC_ClubBoard1Title() {
		return c_ClubBoard1Title;
	}
	public void setC_ClubBoard1Title(String c_ClubBoard1Title) {
		this.c_ClubBoard1Title = c_ClubBoard1Title;
	}
	public String getC_Board1TitleColor() {
		return c_Board1TitleColor;
	}
	public void setC_Board1TitleColor(String c_Board1TitleColor) {
		this.c_Board1TitleColor = c_Board1TitleColor;
	}
	public String getC_Board1FontColor() {
		return c_Board1FontColor;
	}
	public void setC_Board1FontColor(String c_Board1FontColor) {
		this.c_Board1FontColor = c_Board1FontColor;
	}
	public String getC_ClubBoard1_Exist() {
		return c_ClubBoard1_Exist;
	}
	public void setC_ClubBoard1_Exist(String c_ClubBoard1_Exist) {
		this.c_ClubBoard1_Exist = c_ClubBoard1_Exist;
	}
	public int getC_ClubBoard1_OrderBy() {
		return c_ClubBoard1_OrderBy;
	}
	public void setC_ClubBoard1_OrderBy(int c_ClubBoard1_OrderBy) {
		this.c_ClubBoard1_OrderBy = c_ClubBoard1_OrderBy;
	}
	public String getC_ClubBoard2Title() {
		return c_ClubBoard2Title;
	}
	public void setC_ClubBoard2Title(String c_ClubBoard2Title) {
		this.c_ClubBoard2Title = c_ClubBoard2Title;
	}
	public String getC_Board2TitleColor() {
		return c_Board2TitleColor;
	}
	public void setC_Board2TitleColor(String c_Board2TitleColor) {
		this.c_Board2TitleColor = c_Board2TitleColor;
	}
	public String getC_Board2FontColor() {
		return c_Board2FontColor;
	}
	public void setC_Board2FontColor(String c_Board2FontColor) {
		this.c_Board2FontColor = c_Board2FontColor;
	}
	public String getC_ClubBoard2_Exist() {
		return c_ClubBoard2_Exist;
	}
	public void setC_ClubBoard2_Exist(String c_ClubBoard2_Exist) {
		this.c_ClubBoard2_Exist = c_ClubBoard2_Exist;
	}
	public int getC_ClubBoard2_OrderBy() {
		return c_ClubBoard2_OrderBy;
	}
	public void setC_ClubBoard2_OrderBy(int c_ClubBoard2_OrderBy) {
		this.c_ClubBoard2_OrderBy = c_ClubBoard2_OrderBy;
	}
	public String getC_ClubPds1Title() {
		return c_ClubPds1Title;
	}
	public void setC_ClubPds1Title(String c_ClubPds1Title) {
		this.c_ClubPds1Title = c_ClubPds1Title;
	}
	public String getC_Pds1TitleColor() {
		return c_Pds1TitleColor;
	}
	public void setC_Pds1TitleColor(String c_Pds1TitleColor) {
		this.c_Pds1TitleColor = c_Pds1TitleColor;
	}
	public String getC_Pds1FontColor() {
		return c_Pds1FontColor;
	}
	public void setC_Pds1FontColor(String c_Pds1FontColor) {
		this.c_Pds1FontColor = c_Pds1FontColor;
	}
	public String getC_ClubPds1_Exist() {
		return c_ClubPds1_Exist;
	}
	public void setC_ClubPds1_Exist(String c_ClubPds1_Exist) {
		this.c_ClubPds1_Exist = c_ClubPds1_Exist;
	}
	public int getC_ClubPds1_OrderBy() {
		return c_ClubPds1_OrderBy;
	}
	public void setC_ClubPds1_OrderBy(int c_ClubPds1_OrderBy) {
		this.c_ClubPds1_OrderBy = c_ClubPds1_OrderBy;
	}
	public String getScore() {
		return score;
	}
	public void setScore(String score) {
		this.score = score;
	}
	public int getIsIn() {
		return isIn;
	}
	public void setIsIn(int isIn) {
		this.isIn = isIn;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	public int getUsingDiskSize() {
		return usingDiskSize;
	}
	public void setUsingDiskSize(int usingDiskSize) {
		this.usingDiskSize = usingDiskSize;
	}
	public String getSendMail() {
		return sendMail;
	}
	public void setSendMail(String sendMail) {
		this.sendMail = sendMail;
	}
	public String getSendMailCnt() {
		return sendMailCnt;
	}
	public void setSendMailCnt(String sendMailCnt) {
		this.sendMailCnt = sendMailCnt;
	}
	public String getAssignDiskSize() {
		return assignDiskSize;
	}
	public void setAssignDiskSize(String assignDiskSize) {
		this.assignDiskSize = assignDiskSize;
	}
	public String getC_Type() {
		return c_Type;
	}
	public void setC_Type(String c_Type) {
		this.c_Type = c_Type;
	}
	public int getItemCnt() {
		return itemCnt;
	}
	public void setItemCnt(int itemCnt) {
		this.itemCnt = itemCnt;
	}
	public String getDisplayName() {
		return displayName;
	}
	public void setDisplayName(String displayName) {
		this.displayName = displayName;
	}
	public String getDisplayName2() {
		return displayName2;
	}
	public void setDisplayName2(String displayName2) {
		this.displayName2 = displayName2;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getDescription2() {
		return description2;
	}
	public void setDescription2(String description2) {
		this.description2 = description2;
	}
	public int getCopCnt() {
		return copCnt;
	}
	public void setCopCnt(int copCnt) {
		this.copCnt = copCnt;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getUserName2() {
		return userName2;
	}
	public void setUserName2(String userName2) {
		this.userName2 = userName2;
	}
	public String getPermit() {
		return permit;
	}
	public void setPermit(String permit) {
		this.permit = permit;
	}
	
	
}
