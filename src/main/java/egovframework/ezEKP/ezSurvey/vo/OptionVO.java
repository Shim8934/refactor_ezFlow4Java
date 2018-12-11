package egovframework.ezEKP.ezSurvey.vo;

public class OptionVO {
	private long optionId;
	private long questionId;
	private long surveyId;
	private String companyId;
	private int tenantId;
	private int questionType;
	private String content;
	private int levels;
	private int otherFlag;
	private int logicNum;
	private int rowLevel;
	private int columnLevel;
	
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
	
	public int getLevels() {
		return levels;
	}
	
	public void setLevels(int levels) {
		this.levels = levels;
	}
	
	public int getOtherFlag() {
		return otherFlag;
	}
	
	public void setOtherFlag(int otherFlag) {
		this.otherFlag = otherFlag;
	}
	
	public int getLogicNum() {
		return logicNum;
	}
	
	public void setLogicNum(int logicNum) {
		this.logicNum = logicNum;
	}
	
	public int getRowLevel() {
		return rowLevel;
	}
	
	public void setRowLevel(int rowLevel) {
		this.rowLevel = rowLevel;
	}
	
	public int getColumnLevel() {
		return columnLevel;
	}
	
	public void setColumnLevel(int columnLevel) {
		this.columnLevel = columnLevel;
	}
}
