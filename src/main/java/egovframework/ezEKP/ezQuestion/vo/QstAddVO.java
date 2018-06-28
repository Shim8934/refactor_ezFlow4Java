package egovframework.ezEKP.ezQuestion.vo;

import java.util.List;

public class QstAddVO {
	/** 질문번호*/
	private int questionNo;
	/** 질문내용*/
	private String questionContent;
	/** 질문유형*/
	private int answerType;
	/** 보기유형*/
	private int answerViewType;
	/** 다답형*/
	private String pMultiSel;
	/** */
	private int quesSN;
	/** */
	private int selViewStart;
	/** */
	private int selViewEnd;
	/** 질문제목*/
	private String txtQuestion;
	/** */
	private String title;
	/** */
	private List<String> answer;
	/** */
	private List<String> attach;
	/** */
	private String href;
	
	private String pSelectOption;
	
	private String pQstAnsInfo;
	
	private String pQstAttach;
	
	
	public String getpQstAttach() {
		return pQstAttach;
	}
	public void setpQstAttach(String pQstAttach) {
		this.pQstAttach = pQstAttach;
	}
	public String getpQstAnsInfo() {
		return pQstAnsInfo;
	}
	public void setpQstAnsInfo(String pQstAnsInfo) {
		this.pQstAnsInfo = pQstAnsInfo;
	}
	public String getpSelectOption() {
		return pSelectOption;
	}
	public void setpSelectOption(String pSelectOption) {
		this.pSelectOption = pSelectOption;
	}
	public List<String> getAttach() {
		return attach;
	}
	public void setAttach(List<String> attach) {
		this.attach = attach;
	}
	public String getHref() {
		return href;
	}
	public void setHref(String href) {
		this.href = href;
	}
	public List<String> getAnswer() {
		return answer;
	}
	public void setAnswer(List<String> answer) {
		this.answer = answer;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getTxtQuestion() {
		return txtQuestion;
	}
	public void setTxtQuestion(String txtQuestion) {
		this.txtQuestion = txtQuestion;
	}
	public int getSelViewStart() {
		return selViewStart;
	}
	public void setSelViewStart(int selViewStart) {
		this.selViewStart = selViewStart;
	}
	public int getSelViewEnd() {
		return selViewEnd;
	}
	public void setSelViewEnd(int selViewEnd) {
		this.selViewEnd = selViewEnd;
	}
	/*public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}*/
	/*public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}*/
	public int getQuestionNo() {
		return questionNo;
	}
	public void setQuestionNo(int questionNo) {
		this.questionNo = questionNo;
	}
	public String getQuestionContent() {
		return questionContent;
	}
	public void setQuestionContent(String questionContent) {
		this.questionContent = questionContent;
	}
	public int getAnswerType() {
		return answerType;
	}
	public void setAnswerType(int answerType) {
		this.answerType = answerType;
	}
	public String getpMultiSel() {
		return pMultiSel;
	}
	public void setpMultiSel(String pMultiSel) {
		this.pMultiSel = pMultiSel;
	}
	public int getAnswerViewType() {
		return answerViewType;
	}
	public void setAnswerViewType(int answerViewType) {
		this.answerViewType = answerViewType;
	}

	public int getQuesSN() {
		return quesSN;
	}
	public void setQuesSN(int quesSN) {
		this.quesSN = quesSN;
	}
}
