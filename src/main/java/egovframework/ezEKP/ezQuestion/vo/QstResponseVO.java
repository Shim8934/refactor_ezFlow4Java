package egovframework.ezEKP.ezQuestion.vo;


public class QstResponseVO {
	/** 게시판아이디*/
	int brdId;
	/** 설문아이디*/
	int itemNo;
	/** 질문번호(아이디)*/
	int questionNo;
	/** 응갑일련번호*/
	int responseNo;
	/** 객관식보기선택번호(다답형은복수ROW생성)*/
	int answerObjectivity;
	/** 주관식응답내용,우선순위선택순서*/
	String answerSubjectivity;
	/** (사용안함)*/
	int answerViewSelect;
	/** 응답자아이디(무기명,기명)*/
	String responseUserId;
	/** 응답자이름(기명일때만)*/
	String responseUserName;
	/** 응답자이름(기명일때만)(다국어)*/
	String responseUserName2="";
	/** 응답자이메일(기명일때만)*/
	String responseUserEmail;
	/** 응답자부서아이디(기명일때만)*/
	String responseUserDeptId;
	/** 응답자부서이름(기명일때만)*/
	String responseUserDeptName;
	/** 응답자부서이름(기명일때만)(다국어)*/
	String responseUserDeptName2="";
	/** 응답자직위(기명일때만)*/
	String responseUserPosition;
	/** 응답자직위(기명일때만)(다국어)*/
	String responseUserPosition2="";
	/** 응답자직책(기명일때만)*/
	String responseUserJikgub;
	/** 응답자직책(기명일때만)(다국어)*/
	String responseUserJikgub2="";
	/** 응답자성별(남:1,여:2)(기명일때만)*/
	String responseUserGender = "1";
	/** 응답자나이(기명일때만)*/
	int responseUserAge = 29;
	/** 응답일시*/
	String responseDate;
	/** 응답IP주소*/
	String responseUserIp;
	
	public int getBrdId() {
		return brdId;
	}
	public void setBrdId(int brdId) {
		this.brdId = brdId;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public int getQuestionNo() {
		return questionNo;
	}
	public void setQuestionNo(int questionNo) {
		this.questionNo = questionNo;
	}
	public int getResponseNo() {
		return responseNo;
	}
	public void setResponseNo(int responseNo) {
		this.responseNo = responseNo;
	}
	public int getAnswerObjectivity() {
		return answerObjectivity;
	}
	public void setAnswerObjectivity(int answerObjectivity) {
		this.answerObjectivity = answerObjectivity;
	}
	public String getAnswerSubjectivity() {
		return answerSubjectivity;
	}
	public void setAnswerSubjectivity(String answerSubjectivity) {
		this.answerSubjectivity = answerSubjectivity;
	}
	public int getAnswerViewSelect() {
		return answerViewSelect;
	}
	public void setAnswerViewSelect(int answerViewSelect) {
		this.answerViewSelect = answerViewSelect;
	}
	public String getResponseUserId() {
		return responseUserId;
	}
	public void setResponseUserId(String responseUserId) {
		this.responseUserId = responseUserId;
	}
	public String getResponseUserName() {
		return responseUserName;
	}
	public void setResponseUserName(String responseUserName) {
		this.responseUserName = responseUserName;
	}
	public String getResponseUserName2() {
		return responseUserName2;
	}
	public void setResponseUserName2(String responseUserName2) {
		this.responseUserName2 = responseUserName2;
	}
	public String getResponseUserEmail() {
		return responseUserEmail;
	}
	public void setResponseUserEmail(String responseUserEmail) {
		this.responseUserEmail = responseUserEmail;
	}
	public String getResponseUserDeptId() {
		return responseUserDeptId;
	}
	public void setResponseUserDeptId(String responseUserDeptId) {
		this.responseUserDeptId = responseUserDeptId;
	}
	public String getResponseUserDeptName() {
		return responseUserDeptName;
	}
	public void setResponseUserDeptName(String responseUserDeptName) {
		this.responseUserDeptName = responseUserDeptName;
	}
	public String getResponseUserDeptName2() {
		return responseUserDeptName2;
	}
	public void setResponseUserDeptName2(String responseUserDeptName2) {
		this.responseUserDeptName2 = responseUserDeptName2;
	}
	public String getResponseUserPosition() {
		return responseUserPosition;
	}
	public void setResponseUserPosition(String responseUserPosition) {
		this.responseUserPosition = responseUserPosition;
	}
	public String getResponseUserPosition2() {
		return responseUserPosition2;
	}
	public void setResponseUserPosition2(String responseUserPosition2) {
		this.responseUserPosition2 = responseUserPosition2;
	}
	public String getResponseUserJikgub() {
		return responseUserJikgub;
	}
	public void setResponseUserJikgub(String responseUserJikgub) {
		this.responseUserJikgub = responseUserJikgub;
	}
	public String getResponseUserJikgub2() {
		return responseUserJikgub2;
	}
	public void setResponseUserJikgub2(String responseUserJikgub2) {
		this.responseUserJikgub2 = responseUserJikgub2;
	}
	public String getResponseUserGender() {
		return responseUserGender;
	}
	public void setResponseUserGender(String responseUserGender) {
		this.responseUserGender = responseUserGender;
	}
	public int getResponseUserAge() {
		return responseUserAge;
	}
	public void setResponseUserAge(int responseUserAge) {
		this.responseUserAge = responseUserAge;
	}
	public String getResponseDate() {
		return responseDate;
	}
	public void setResponseDate(String responseDate) {
		this.responseDate = responseDate;
	}
	public String getResponseUserIp() {
		return responseUserIp;
	}
	public void setResponseUserIp(String responseUserIp) {
		this.responseUserIp = responseUserIp;
	}
}
