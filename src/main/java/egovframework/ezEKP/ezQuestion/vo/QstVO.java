package egovframework.ezEKP.ezQuestion.vo;

public class QstVO {
	/** 게시판ID*/
	int brdId;
	/** 글 번호*/
	int itemNo;
	/** 질문 번호*/
	int questionNo;
	/** 질문 내용*/
	String quesContent;
	/** 답변타입*/
	int answerType;
	/** 답변보기타입?*/
	int answerViewType;
	/** 다중선택가능*/
	String multiSelect;
	/** ??*/
	int quesSn;
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
	public int getQuesSn() {
		return quesSn;
	}
	public void setQuesSn(int quesSn) {
		this.quesSn = quesSn;
	}
}
