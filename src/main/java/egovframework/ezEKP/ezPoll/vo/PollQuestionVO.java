package egovframework.ezEKP.ezPoll.vo;

import java.io.Serializable;


public class PollQuestionVO implements Serializable {
	private static final long serialVersionUID = 120L;	
	private int qstId;
	private String userId;
	private int tenantId;
	private String content;
	private int multiSelect;
	private String startDate;
	private String endDate;
	private int target;
	private String title;
	private int secretVote;
	private String creator;
	private String creatorName;
	private String creatorImage;
	private int status;	
	private String receiverType;
	private String filePath;
	private int resultFirst;
	private int isHidden;
	private int isMofifying;
	
	public int getQstId() {
		return qstId;
	}
	
	public void setQstId(int qstId) {
		this.qstId = qstId;
	}	
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public int getTenantId() {
		return tenantId;
	}
	
	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}
	
	public String getContent() {
		return content;
	}
	
	public void setContent(String content) {
		this.content = content;
	}
	
	public int getMultiSelect() {
		return multiSelect;
	}
	
	public void setMultiSelect(int multiSelect) {
		this.multiSelect = multiSelect;
	}
	
	public String getStartDate() {
		return startDate;
	}
	
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	
	public String getEndDate() {
		return endDate;
	}
	
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	
	public int getTarget() {
		return target;
	}
	
	public void setTarget(int target) {
		this.target = target;
	}
	
	public String getTitle() {
		return title;
	}
	
	public void setTitle(String title) {
		this.title = title;
	}
	
	public int getSecretVote() {
		return secretVote;
	}
	
	public void setSecretVote(int secretVote) {
		this.secretVote = secretVote;
	}
	
	public String getCreator() {
		return creator;
	}
	
	public void setCreator(String creator) {
		this.creator = creator;
	}
	
	public String getCreatorName() {
		return creatorName;
	}
	
	public void setCreatorName(String creatorName) {
		this.creatorName = creatorName;
	}		
	
	public String getCreatorImage() {
		return creatorImage;
	}

	public void setCreatorImage(String creatorImage) {
		this.creatorImage = creatorImage;
	}

	public int getStatus() {
		return status;
	}
	
	public void setStatus(int status) {
		this.status = status;
	}	
	
	public String getFilePath() {
		return filePath;
	}
	
	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}	
	
	public int getResultFirst() {
		return resultFirst;
	}
	
	public void setResultFirst(int resultFirst) {
		this.resultFirst = resultFirst;
	}
	
	public int getIsHidden() {
		return isHidden;
	}
	
	public void setIsHidden(int isHidden) {
		this.isHidden = isHidden;
	}	
	
	public int getIsMofifying() {
		return isMofifying;
	}
	
	public void setIsMofifying(int isMofifying) {
		this.isMofifying = isMofifying;
	}
	
	public String getReceiverType() {
		return receiverType;
	}
	
	public void setReceiverType(String receiverType) {
		this.receiverType = receiverType;
	}		
	
	public boolean equals(Object object) {
		if (object instanceof PollQuestionVO) {
			PollQuestionVO obj = (PollQuestionVO) object;
			return qstId == obj.qstId && tenantId == obj.tenantId;
		}
		else {
			return false;
		}
	}
	
	public int hashCode() {
		return 100 + qstId + tenantId;
	}	
}
