package egovframework.ezEKP.ezPoll.vo;

import java.io.Serializable;


public class PollQuestionVO implements Serializable {
	private static final long serialVersionUID = 120L;	
	private int qstId;
	private String userId;
	private int tenantId;
	private String content;
	private int multiSelect;
	private String createDate; //20180109
	private String startDate;
	private String endDate;
	private int target;
	private String title;
	private int secretVote;
	private String creator;
	private String creatorName1;
	private String creatorName2;
	private String creatorDept;
	private String creatorImage;
	private int status;	
	private String receiverType;
	private String filePath;
	private int resultFirst;
	private int isHidden;
	private int isModifying;
	private int setDate;
	private int isSorting;
	private int isSelOnlyOnce;
	private int sendPostNotice;
	private int openToAll;
	private int cmtCnt;
	private String companyId;
	private String userDeptId;
	
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
	
	public String getCreatorName1() {
		return creatorName1;
	}

	public void setCreatorName1(String creatorName1) {
		this.creatorName1 = creatorName1;
	}

	public String getCreatorName2() {
		return creatorName2;
	}

	public void setCreatorName2(String creatorName2) {
		this.creatorName2 = creatorName2;
	}

	public String getCreatorDept() {
		return creatorDept;
	}

	public void setCreatorDept(String creatorDept) {
		this.creatorDept = creatorDept;
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
	
	public int getIsModifying() {
		return isModifying;
	}
	
	public void setIsModifying(int isModifying) {
		this.isModifying = isModifying;
	}
	
	public String getReceiverType() {
		return receiverType;
	}
	
	public void setReceiverType(String receiverType) {
		this.receiverType = receiverType;
	}	
	
	public int getSetDate() {
		return setDate;
	}

	public void setSetDate(int setDate) {
		this.setDate = setDate;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public int getIsSorting() {
		return isSorting;
	}

	public void setIsSorting(int isSorting) {
		this.isSorting = isSorting;
	}

	public int getIsSelOnlyOnce() {
		return isSelOnlyOnce;
	}

	public void setIsSelOnlyOnce(int isSelOnlyOnce) {
		this.isSelOnlyOnce = isSelOnlyOnce;
	}

	public int getSendPostNotice() {
		return sendPostNotice;
	}

	public void setSendPostNotice(int sendPostNotice) {
		this.sendPostNotice = sendPostNotice;
	}

	public int getOpenToAll() {
		return openToAll;
	}

	public void setOpenToAll(int openToAll) {
		this.openToAll = openToAll;
	}

	public int getCmtCnt() {
		return cmtCnt;
	}

	public void setCmtCnt(int cmtCnt) {
		this.cmtCnt = cmtCnt;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
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

	public String getUserDeptId() {
		return userDeptId;
	}

	public void setUserDeptId(String userDeptId) {
		this.userDeptId = userDeptId;
	}	
}
