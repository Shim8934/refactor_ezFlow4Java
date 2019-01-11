package egovframework.ezEKP.ezSurvey.vo;

public class ResponseVO {
	private long responseId;
	private long surveyId;
	private long questionLevel;
	private int questionType;
	private String responsorId;
	private long optionId;
	private String texts;
	private int rowLevel;
	private int columnLevel;
	private int sliderValue;
	private int rankingLevel;
	private int rankingOptionLevel;
	private String companyId;
	private int tenantId;
	
	public long getResponseId() {
		return responseId;
	}
	
	public void setResponseId(long responseId) {
		this.responseId = responseId;
	}
	
	public long getSurveyId() {
		return surveyId;
	}
	
	public void setSurveyId(long surveyId) {
		this.surveyId = surveyId;
	}
	
	public long getQuestionLevel() {
		return questionLevel;
	}
	
	public void setQuestionLevel(long questionLevel) {
		this.questionLevel = questionLevel;
	}
	
	public int getQuestionType() {
		return questionType;
	}
	
	public void setQuestionType(int questionType) {
		this.questionType = questionType;
	}
	
	public String getResponsorId() {
		return responsorId;
	}
	
	public void setResponsorId(String responsorId) {
		this.responsorId = responsorId;
	}
	
	public long getOptionId() {
		return optionId;
	}
	
	public void setOptionId(long optionId) {
		this.optionId = optionId;
	}
	
	public String getTexts() {
		return texts;
	}
	
	public void setTexts(String texts) {
		this.texts = texts;
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
	
	public int getSliderValue() {
		return sliderValue;
	}
	
	public void setSliderValue(int sliderValue) {
		this.sliderValue = sliderValue;
	}
	
	public int getRankingLevel() {
		return rankingLevel;
	}
	
	public void setRankingLevel(int rankingLevel) {
		this.rankingLevel = rankingLevel;
	}
	
	public int getRankingOptionLevel() {
		return rankingOptionLevel;
	}
	
	public void setRankingOptionLevel(int rankingOptionLevel) {
		this.rankingOptionLevel = rankingOptionLevel;
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
}
