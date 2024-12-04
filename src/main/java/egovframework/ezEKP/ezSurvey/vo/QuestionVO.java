package egovframework.ezEKP.ezSurvey.vo;

import java.util.List;

public class QuestionVO {
	private long questionId;
	private long surveyId;
	private String companyId;
	private int tenantId;
	private int type;
	private String content;
	private long level;
	private int useStatus;
	private int required;
	private int logicFlag;
	private int sliderLogicPoint;
	private long skip;
	private long unit;
	private int skipFlag;
	private List<OptionVO> option;
	private AttachVO attach;
	private AttachVO imgTitle;
	private List<ResponseVO> responses;
	
	public List<ResponseVO> getResponses() {
		return responses;
	}
	
	public void setResponses(List<ResponseVO> responses) {
		this.responses = responses;
	}
	
	public AttachVO getAttach() {
		return attach;
	}
	
	public void setAttach(AttachVO attach) {
		this.attach = attach;
	}
	
	public List<OptionVO> getOption() {
		return option;
	}
	
	public void setOption(List<OptionVO> option) {
		this.option = option;
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
	
	public int getType() {
		return type;
	}
	
	public void setType(int type) {
		this.type = type;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public long getLevel() {
		return level;
	}
	
	public void setLevel(long level) {
		this.level = level;
	}
	
	public int getUseStatus() {
		return useStatus;
	}
	
	public void setUseStatus(int useStatus) {
		this.useStatus = useStatus;
	}
	
	public int getRequired() {
		return required;
	}
	
	public void setRequired(int required) {
		this.required = required;
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
	
	public long getSkip() {
		return skip;
	}
	
	public void setSkip(long skip) {
		this.skip = skip;
	}
	
	public int getSkipFlag() {
		return skipFlag;
	}
	
	public void setSkipFlag(int skipFlag) {
		this.skipFlag = skipFlag;
	}
	
	public long getUnit() {
		return unit;
	}
	
	public void setUnit(long unit) {
		this.unit = unit;
	}

	public AttachVO getImgTitle() {
		return imgTitle;
	}

	public void setImgTitle(AttachVO imgTitle) {
		this.imgTitle = imgTitle;
	}
	
}
