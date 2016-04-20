package egovframework.ezEKP.ezCommunity.vo;

public class CommunityClubVO {
	/** 커뮤니티ID*/
	String cClubNo;
	/** 커뮤니티 등록 시각*/
	String cRegDate;
	/** 커뮤니티 이름*/
	String cClubName;
	/** 커뮤니티 이름(다국어)*/
	String cClubName2;
	/** 커뮤니티 카테고리1*/
	String cCateA;
	/** 커뮤니티 카테고리2*/
	String cCateB;
	/** 커뮤니티 카테고리3*/
	String cCateC;
	/** 커뮤니티 공개 여부*/
	String cClubGubun;
	/** 마스터 커뮤니티 승인여부*/
	String cClubConfirmType;
	/** 관리자 커뮤니티 승인여부*/
	String cAdminConfirm;
	/** 커뮤니티 개설자 ID*/
	String cMaker;
	/** 커뮤니티 마스터 ID*/
	String cSysopID;
	/** 커뮤니티 회원 수 */
	int cMemberCnt;
	/** 커뮤니티 홈 로고  실제 파일 이름*/
	String cLogo;
	/** 커뮤니티 홈 로고 (썸네일용)*/
	String cLogoThumbnail;
	/** 커뮤니티 백그라운드  실제 파일 이름*/
	String cBgImage;
	/** 커뮤니티 글씨 색*/
	String cFontColor;
	/** 커뮤니티 백그라운드 색*/
	String cBgColor;
	/** 커뮤니티 타이틀  글씨 색*/
	String cTitleFontColor;
	/** clob커뮤니티 소개 */
	String cClubDesc;
	/** 커뮤니티 배너  실제 파일 이름*/
	String cClubBanner;
	/** 커뮤니티 오픈 시각*/
	String cOpenDate;
	/** <공지사항> 게시판명*/
	String cClubNoticeTitle;
	/** <공지사항> 게시판  제목 색*/
	String cNoticeTitleColor;
	/** <공지사항> 게시판  글씨 색*/
	String cNoticeFontColor;
	/** 커뮤니티 왼쪽 메뉴 <공지사항> 게시판 순서*/
	int cClubNoticeOrderBy;
	/** <공지사항> 게시판 사용유무*/
	String cClubNoticeExist;
	/** <게시판> 게시판명*/
	String cClubBoardTitle;
	/** <게시판> 게시판  제목 색*/
	String cBoardTitleColor;
	/** <게시판> 게시판  글씨 색*/
	String cBoardFontColor;
	/** <게시판> 왼쪽 메뉴 공시사항 게시판 순서*/
	int cClubBoardOrderBy;
	/** <게시판> 게시판 사용유무*/
	String cClubBoardExist;
	/** <자료실> 게시판명*/
	String cClubPdsTitle;
	/** <자료실> 게시판  제목 색*/
	String cPdsTitleColor;
	/** <자료실> 게시판  글씨 색*/
	String cPdsFontColor;
	/** <자료실> 왼쪽 메뉴 공시사항 게시판 순서*/
	int cClubPdsOrderBy;
	/** <자료실> 게시판 사용유무*/
	String cClubPdsExist;
	/** <게시판1> 게시판명*/
	String cClubBoard1Title;
	/** <게시판1> 게시판  제목 색*/
	String cBoard1TitleColor;
	/** <게시판1> 게시판 글씨 색*/
	String cBoard1FontColor;
	/** <게시판1 > 왼쪽 메뉴 공시사항 게시판 순서*/
	String cClubBoard1Exist;
	/** <게시판1 > 게시판 사용유무*/
	int cClubBoard1OrderBy;
	/** <게시판2 > 게시판명*/
	String cClubBoard2Title;
	/** <게시판2 > 게시판  제목 색*/
	String cBoard2TitleColor;
	/** <게시판2 > 게시판  글씨 색*/
	String cBoard2FontColor;
	/** <게시판2 > 게시판 사용유무*/
	String cClubBoard2Exist;
	/** <게시판2 > 왼쪽 메뉴 공시사항 게시판 순서*/
	int cClubBoard2OrderBy;
	/** <자료실> 게시판명*/
	String cClubPds1Title;
	/** <자료실> 게시판  제목 색*/
	String cPds1TitleColor;
	/** <자료실> 게시판  글씨 색*/
	String cPds1FontColor;
	/** <자료실> 게시판 사용유무*/
	String cClubPds1Exist;
	/** <자료실> 왼쪽 메뉴 공시사항 게시판 순서*/
	int cClubPds1OrderBy;
	/** 커뮤니티 점수*/
	int score;
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
	String cType;
	public String getcClubNo() {
		return cClubNo;
	}
	public void setcClubNo(String cClubNo) {
		this.cClubNo = cClubNo;
	}
	public String getcRegDate() {
		return cRegDate;
	}
	public void setcRegDate(String cRegDate) {
		this.cRegDate = cRegDate;
	}
	public String getcClubName() {
		return cClubName;
	}
	public void setcClubName(String cClubName) {
		this.cClubName = cClubName;
	}
	public String getcClubName2() {
		return cClubName2;
	}
	public void setcClubName2(String cClubName2) {
		this.cClubName2 = cClubName2;
	}
	public String getcCateA() {
		return cCateA;
	}
	public void setcCateA(String cCateA) {
		this.cCateA = cCateA;
	}
	public String getcCateB() {
		return cCateB;
	}
	public void setcCateB(String cCateB) {
		this.cCateB = cCateB;
	}
	public String getcCateC() {
		return cCateC;
	}
	public void setcCateC(String cCateC) {
		this.cCateC = cCateC;
	}
	public String getcClubGubun() {
		return cClubGubun;
	}
	public void setcClubGubun(String cClubGubun) {
		this.cClubGubun = cClubGubun;
	}
	public String getcClubConfirmType() {
		return cClubConfirmType;
	}
	public void setcClubConfirmType(String cClubConfirmType) {
		this.cClubConfirmType = cClubConfirmType;
	}
	public String getcAdminConfirm() {
		return cAdminConfirm;
	}
	public void setcAdminConfirm(String cAdminConfirm) {
		this.cAdminConfirm = cAdminConfirm;
	}
	public String getcMaker() {
		return cMaker;
	}
	public void setcMaker(String cMaker) {
		this.cMaker = cMaker;
	}
	public String getcSysopID() {
		return cSysopID;
	}
	public void setcSysopID(String cSysopID) {
		this.cSysopID = cSysopID;
	}
	public int getcMemberCnt() {
		return cMemberCnt;
	}
	public void setcMemberCnt(int cMemberCnt) {
		this.cMemberCnt = cMemberCnt;
	}
	public String getcLogo() {
		return cLogo;
	}
	public void setcLogo(String cLogo) {
		this.cLogo = cLogo;
	}
	public String getcLogoThumbnail() {
		return cLogoThumbnail;
	}
	public void setcLogoThumbnail(String cLogoThumbnail) {
		this.cLogoThumbnail = cLogoThumbnail;
	}
	public String getcBgImage() {
		return cBgImage;
	}
	public void setcBgImage(String cBgImage) {
		this.cBgImage = cBgImage;
	}
	public String getcFontColor() {
		return cFontColor;
	}
	public void setcFontColor(String cFontColor) {
		this.cFontColor = cFontColor;
	}
	public String getcBgColor() {
		return cBgColor;
	}
	public void setcBgColor(String cBgColor) {
		this.cBgColor = cBgColor;
	}
	public String getcTitleFontColor() {
		return cTitleFontColor;
	}
	public void setcTitleFontColor(String cTitleFontColor) {
		this.cTitleFontColor = cTitleFontColor;
	}
	public String getcClubDesc() {
		return cClubDesc;
	}
	public void setcClubDesc(String cClubDesc) {
		this.cClubDesc = cClubDesc;
	}
	public String getcClubBanner() {
		return cClubBanner;
	}
	public void setcClubBanner(String cClubBanner) {
		this.cClubBanner = cClubBanner;
	}
	public String getcOpenDate() {
		return cOpenDate;
	}
	public void setcOpenDate(String cOpenDate) {
		this.cOpenDate = cOpenDate;
	}
	public String getcClubNoticeTitle() {
		return cClubNoticeTitle;
	}
	public void setcClubNoticeTitle(String cClubNoticeTitle) {
		this.cClubNoticeTitle = cClubNoticeTitle;
	}
	public String getcNoticeTitleColor() {
		return cNoticeTitleColor;
	}
	public void setcNoticeTitleColor(String cNoticeTitleColor) {
		this.cNoticeTitleColor = cNoticeTitleColor;
	}
	public String getcNoticeFontColor() {
		return cNoticeFontColor;
	}
	public void setcNoticeFontColor(String cNoticeFontColor) {
		this.cNoticeFontColor = cNoticeFontColor;
	}
	public int getcClubNoticeOrderBy() {
		return cClubNoticeOrderBy;
	}
	public void setcClubNoticeOrderBy(int cClubNoticeOrderBy) {
		this.cClubNoticeOrderBy = cClubNoticeOrderBy;
	}
	public String getcClubNoticeExist() {
		return cClubNoticeExist;
	}
	public void setcClubNoticeExist(String cClubNoticeExist) {
		this.cClubNoticeExist = cClubNoticeExist;
	}
	public String getcClubBoardTitle() {
		return cClubBoardTitle;
	}
	public void setcClubBoardTitle(String cClubBoardTitle) {
		this.cClubBoardTitle = cClubBoardTitle;
	}
	public String getcBoardTitleColor() {
		return cBoardTitleColor;
	}
	public void setcBoardTitleColor(String cBoardTitleColor) {
		this.cBoardTitleColor = cBoardTitleColor;
	}
	public String getcBoardFontColor() {
		return cBoardFontColor;
	}
	public void setcBoardFontColor(String cBoardFontColor) {
		this.cBoardFontColor = cBoardFontColor;
	}
	public int getcClubBoardOrderBy() {
		return cClubBoardOrderBy;
	}
	public void setcClubBoardOrderBy(int cClubBoardOrderBy) {
		this.cClubBoardOrderBy = cClubBoardOrderBy;
	}
	public String getcClubBoardExist() {
		return cClubBoardExist;
	}
	public void setcClubBoardExist(String cClubBoardExist) {
		this.cClubBoardExist = cClubBoardExist;
	}
	public String getcClubPdsTitle() {
		return cClubPdsTitle;
	}
	public void setcClubPdsTitle(String cClubPdsTitle) {
		this.cClubPdsTitle = cClubPdsTitle;
	}
	public String getcPdsTitleColor() {
		return cPdsTitleColor;
	}
	public void setcPdsTitleColor(String cPdsTitleColor) {
		this.cPdsTitleColor = cPdsTitleColor;
	}
	public String getcPdsFontColor() {
		return cPdsFontColor;
	}
	public void setcPdsFontColor(String cPdsFontColor) {
		this.cPdsFontColor = cPdsFontColor;
	}
	public int getcClubPdsOrderBy() {
		return cClubPdsOrderBy;
	}
	public void setcClubPdsOrderBy(int cClubPdsOrderBy) {
		this.cClubPdsOrderBy = cClubPdsOrderBy;
	}
	public String getcClubPdsExist() {
		return cClubPdsExist;
	}
	public void setcClubPdsExist(String cClubPdsExist) {
		this.cClubPdsExist = cClubPdsExist;
	}
	public String getcClubBoard1Title() {
		return cClubBoard1Title;
	}
	public void setcClubBoard1Title(String cClubBoard1Title) {
		this.cClubBoard1Title = cClubBoard1Title;
	}
	public String getcBoard1TitleColor() {
		return cBoard1TitleColor;
	}
	public void setcBoard1TitleColor(String cBoard1TitleColor) {
		this.cBoard1TitleColor = cBoard1TitleColor;
	}
	public String getcBoard1FontColor() {
		return cBoard1FontColor;
	}
	public void setcBoard1FontColor(String cBoard1FontColor) {
		this.cBoard1FontColor = cBoard1FontColor;
	}
	public String getcClubBoard1Exist() {
		return cClubBoard1Exist;
	}
	public void setcClubBoard1Exist(String cClubBoard1Exist) {
		this.cClubBoard1Exist = cClubBoard1Exist;
	}
	public int getcClubBoard1OrderBy() {
		return cClubBoard1OrderBy;
	}
	public void setcClubBoard1OrderBy(int cClubBoard1OrderBy) {
		this.cClubBoard1OrderBy = cClubBoard1OrderBy;
	}
	public String getcClubBoard2Title() {
		return cClubBoard2Title;
	}
	public void setcClubBoard2Title(String cClubBoard2Title) {
		this.cClubBoard2Title = cClubBoard2Title;
	}
	public String getcBoard2TitleColor() {
		return cBoard2TitleColor;
	}
	public void setcBoard2TitleColor(String cBoard2TitleColor) {
		this.cBoard2TitleColor = cBoard2TitleColor;
	}
	public String getcBoard2FontColor() {
		return cBoard2FontColor;
	}
	public void setcBoard2FontColor(String cBoard2FontColor) {
		this.cBoard2FontColor = cBoard2FontColor;
	}
	public String getcClubBoard2Exist() {
		return cClubBoard2Exist;
	}
	public void setcClubBoard2Exist(String cClubBoard2Exist) {
		this.cClubBoard2Exist = cClubBoard2Exist;
	}
	public int getcClubBoard2OrderBy() {
		return cClubBoard2OrderBy;
	}
	public void setcClubBoard2OrderBy(int cClubBoard2OrderBy) {
		this.cClubBoard2OrderBy = cClubBoard2OrderBy;
	}
	public String getcClubPds1Title() {
		return cClubPds1Title;
	}
	public void setcClubPds1Title(String cClubPds1Title) {
		this.cClubPds1Title = cClubPds1Title;
	}
	public String getcPds1TitleColor() {
		return cPds1TitleColor;
	}
	public void setcPds1TitleColor(String cPds1TitleColor) {
		this.cPds1TitleColor = cPds1TitleColor;
	}
	public String getcPds1FontColor() {
		return cPds1FontColor;
	}
	public void setcPds1FontColor(String cPds1FontColor) {
		this.cPds1FontColor = cPds1FontColor;
	}
	public String getcClubPds1Exist() {
		return cClubPds1Exist;
	}
	public void setcClubPds1Exist(String cClubPds1Exist) {
		this.cClubPds1Exist = cClubPds1Exist;
	}
	public int getcClubPds1OrderBy() {
		return cClubPds1OrderBy;
	}
	public void setcClubPds1OrderBy(int cClubPds1OrderBy) {
		this.cClubPds1OrderBy = cClubPds1OrderBy;
	}
	public int getScore() {
		return score;
	}
	public void setScore(int score) {
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
	public String getcType() {
		return cType;
	}
	public void setcType(String cType) {
		this.cType = cType;
	}	
}
