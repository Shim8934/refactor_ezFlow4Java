package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCPollResponseVO {
	/** 응답일련번호*/
	int responseID;
	/** 질문일련번호*/
	int questionID;
	/** 선택보기일련번호*/
	int answerID;
	/** 선택보기번호*/
	int answerNo;
	/** 기타선택답변*/
	String answerETC;
	/** 응답자아이디*/
	String userID;
	/** 응답자회사아이디*/
	String companyID;
	
	public int getResponseID() {
		return responseID;
	}
	public void setResponseID(int responseID) {
		this.responseID = responseID;
	}
	public int getQuestionID() {
		return questionID;
	}
	public void setQuestionID(int questionID) {
		this.questionID = questionID;
	}
	public int getAnswerID() {
		return answerID;
	}
	public void setAnswerID(int answerID) {
		this.answerID = answerID;
	}
	public int getAnswerNo() {
		return answerNo;
	}
	public void setAnswerNo(int answerNo) {
		this.answerNo = answerNo;
	}
	public String getAnswerETC() {
		return answerETC;
	}
	public void setAnswerETC(String answerETC) {
		this.answerETC = answerETC;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getCompanyID() {
		return companyID;
	}
	public void setCompanyID(String companyID) {
		this.companyID = companyID;
	}
	
	
}
