package egovframework.ezMobile.ezSurvey.vo;

import java.util.List;

public class MOptionVO {
	private long optionId;
	private long questionId;
	private long surveyId;
	private String companyId;
	private int tenantId;
	private int questionType;
	private long questionLevel;
	private String content;
	private int level;
	private int otherFlag;
	private long logic;
	private int rowLevel;
	private int colLevel;
	private MAttachVO attach;
	private List<MResponseVO> responses;
	
	public List<MResponseVO> getResponses() {
		return responses;
	}
	
	public void setResponses(List<MResponseVO> responses) {
		this.responses = responses;
	}
	
	public long getQuestionLevel() {
		return questionLevel;
	}
	
	public void setQuestionLevel(long questionLevel) {
		this.questionLevel = questionLevel;
	}
	
	public MAttachVO getAttach() {
		return attach;
	}
	
	public void setAttach(MAttachVO attach) {
		this.attach = attach;
	}
	
	public long getOptionId() {
		return optionId;
	}
	
	public void setOptionId(long optionId) {
		this.optionId = optionId;
	}
	
	public long getQuestionId() {
		return questionId;
	}
	public void setQuestionId(long questionId) {
		this.questionId = questionId;
	}
	
	public long getSurveyId() {
		return surveyId;
	}
	
	public void setSurveyId(long surveyId) {
		this.surveyId = surveyId;
	}
	
	public String getCompanyId() {
		return companyId;
	}
	
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public int getQuestionType() {
		return questionType;
	}
	
	public void setQuestionType(int questionType) {
		this.questionType = questionType;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public int getLevel() {
		return level;
	}
	
	public void setLevel(int levels) {
		this.level = levels;
	}
	
	public int getOtherFlag() {
		return otherFlag;
	}
	
	public void setOtherFlag(int otherFlag) {
		this.otherFlag = otherFlag;
	}
	
	public long getLogic() {
		return logic;
	}
	
	public void setLogic(long logicNum) {
		this.logic = logicNum;
	}
	
	public int getRowLevel() {
		return rowLevel;
	}
	
	public void setRowLevel(int rowLevel) {
		this.rowLevel = rowLevel;
	}
	
	public int getColLevel() {
		return colLevel;
	}
	
	public void setColLevel(int columnLevel) {
		this.colLevel = columnLevel;
	}
}
