package egovframework.ezEKP.ezQuestion.vo;

public class QstTempSaveVO {
	//게시판아이디
	private int brdId;
	//아이템번호
	private int itemNo;
	//질문번호
	private int questionNo;
	//질문내용
	private String quesContent;
	//질문타입
	private int answerType;
	//질문보기타입
	private int answerViewType;
	//중복응답
	private String multiSelect;
	//질문순서
	private int quesSN;
	//답변번호
	private int answerNo;
	//답변내용
	private String answerContent;
	
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
	public String getQuesContent() {
		return quesContent;
	}
	public void setQuesContent(String quesContent) {
		this.quesContent = quesContent;
	}
	public int getAnswerType() {
		return answerType;
	}
	public void setAnswerType(int answerType) {
		this.answerType = answerType;
	}
	public int getAnswerViewType() {
		return answerViewType;
	}
	public void setAnswerViewType(int answerViewType) {
		this.answerViewType = answerViewType;
	}
	public String getMultiSelect() {
		return multiSelect;
	}
	public void setMultiSelect(String multiSelect) {
		this.multiSelect = multiSelect;
	}
	public int getQuesSN() {
		return quesSN;
	}
	public void setQuesSN(int quesSN) {
		this.quesSN = quesSN;
	}
	public int getAnswerNo() {
		return answerNo;
	}
	public void setAnswerNo(int answerNo) {
		this.answerNo = answerNo;
	}
	public String getAnswerContent() {
		return answerContent;
	}
	public void setAnswerContent(String answerContent) {
		this.answerContent = answerContent;
	}
}
