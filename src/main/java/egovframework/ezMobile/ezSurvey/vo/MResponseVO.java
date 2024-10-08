package egovframework.ezMobile.ezSurvey.vo;

public class MResponseVO {
	private long responseId;
	private long surveyId;
	private long questionLevel;
	private int questionType;
	private String responsorId;
	private long optionId;
	private String texts;
	private int rowId;
	private int columnId;
	private int sliderValue;
	private int rankingLevel;
	private int rankingOptionLevel;
	private String responseDate;
	private String image;
	private String userName;
	private String deptName;
	private String companyId;
	private int tenantId;
	private String imageFilePath;
	
	public String getDeptName() {
		return deptName;
	}
	
	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}
	
	public String getUserName() {
		return userName;
	}
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	
	public String getResponseDate() {
		return responseDate;
	}
	
	public void setResponseDate(String responseDate) {
		this.responseDate = responseDate;
	}
	
	public String getImage() {
		return image;
	}
	
	public void setImage(String image) {
		this.image = image;
	}
	
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
	
	public int getRowId() {
		return rowId;
	}

	public void setRowId(int rowId) {
		this.rowId = rowId;
	}

	public int getColumnId() {
		return columnId;
	}

	public void setColumnId(int columnId) {
		this.columnId = columnId;
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

	public String getImageFilePath() {
		return imageFilePath;
	}

	public void setImageFilePath(String imageFilePath) {
		this.imageFilePath = imageFilePath;
	}
	
}
