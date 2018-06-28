package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCPollManagerVO {
	/** 설문일련번호*/
	String managerID;
	/** 커뮤니티번호*/
	String c_clubNo;
	/** 설문그룹번호*/
	String pollGroupNo;
	/** 설문제목(질문)*/
	String pollSubject;
	/** 질문수*/
	String questionCount;
	/** 설문등록일*/
	String pollRegDate;
	/** 설문접수시작일*/
	String pollStartDate;
	/** 설문접수종료일*/
	String pollEndDate;
	/** 설문등록자아이디*/
	String pollRegUser;
	public String getManagerID() {
		return managerID;
	}
	public void setManagerID(String managerID) {
		this.managerID = managerID;
	}
	public String getC_clubNo() {
		return c_clubNo;
	}
	public void setC_clubNo(String c_clubNo) {
		this.c_clubNo = c_clubNo;
	}
	public String getPollGroupNo() {
		return pollGroupNo;
	}
	public void setPollGroupNo(String pollGroupNo) {
		this.pollGroupNo = pollGroupNo;
	}
	public String getPollSubject() {
		return pollSubject;
	}
	public void setPollSubject(String pollSubject) {
		this.pollSubject = pollSubject;
	}
	public String getQuestionCount() {
		return questionCount;
	}
	public void setQuestionCount(String questionCount) {
		this.questionCount = questionCount;
	}
	public String getPollRegDate() {
		return pollRegDate;
	}
	public void setPollRegDate(String pollRegDate) {
		this.pollRegDate = pollRegDate;
	}
	public String getPollStartDate() {
		return pollStartDate;
	}
	public void setPollStartDate(String pollStartDate) {
		this.pollStartDate = pollStartDate;
	}
	public String getPollEndDate() {
		return pollEndDate;
	}
	public void setPollEndDate(String pollEndDate) {
		this.pollEndDate = pollEndDate;
	}
	public String getPollRegUser() {
		return pollRegUser;
	}
	public void setPollRegUser(String pollRegUser) {
		this.pollRegUser = pollRegUser;
	}
}
