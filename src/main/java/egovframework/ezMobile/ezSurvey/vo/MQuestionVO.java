package egovframework.ezMobile.ezSurvey.vo;

import java.util.List;

public class MQuestionVO {
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
	private List<MOptionVO> option;
	private MAttachVO attach;
	private MAttachVO imgTitle;
	private List<MResponseVO> responses;
	private int resOpenFlag;
	
	public List<MResponseVO> getResponses() {
		return responses;
	}
	
	public void setResponses(List<MResponseVO> responses) {
		this.responses = responses;
	}
	
	public MAttachVO getAttach() {
		return attach;
	}
	
	public void setAttach(MAttachVO attach) {
		this.attach = attach;
	}
	
	public List<MOptionVO> getOption() {
		return option;
	}
	
	public void setOption(List<MOptionVO> option) {
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

	public MAttachVO getImgTitle() {
		return imgTitle;
	}

	public void setImgTitle(MAttachVO imgTitle) {
		this.imgTitle = imgTitle;
	}
	
	public int getResOpenFlag() {
		return resOpenFlag;
	}

	public void setResOpenFlag(int resOpenFlag) {
		this.resOpenFlag = resOpenFlag;
	}
}
