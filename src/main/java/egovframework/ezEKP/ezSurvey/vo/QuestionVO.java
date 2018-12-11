package egovframework.ezEKP.ezSurvey.vo;

public class QuestionVO {
	private long questionId;
	private long surveyId;
	private String companyId;
	private int tenantId;
	private int questionType;
	private String tittle;
	private int levels;
	private int useStatus;
	private int requiredFlag;
	private int logicFlag;
	private int sliderLogicPoint;
	
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
	
	public String getTittle() {
		return tittle;
	}
	
	public void setTittle(String tittle) {
		this.tittle = tittle;
	}
	
	public int getLevels() {
		return levels;
	}
	
	public void setLevels(int levels) {
		this.levels = levels;
	}
	
	public int getUseStatus() {
		return useStatus;
	}
	
	public void setUseStatus(int useStatus) {
		this.useStatus = useStatus;
	}
	
	public int getRequiredFlag() {
		return requiredFlag;
	}
	
	public void setRequiredFlag(int requiredFlag) {
		this.requiredFlag = requiredFlag;
	}
	
	public int getLogicFlag() {
		return logicFlag;
	}
	
	public void setLogicFlag(int logicFlag) {
		this.logicFlag = logicFlag;
	}
	
	public int getSliderLogicPoint() {
		return sliderLogicPoint;
	}
	
	public void setSliderLogicPoint(int sliderLogicPoint) {
		this.sliderLogicPoint = sliderLogicPoint;
	}
}
