package egovframework.ezEKP.ezNotification.vo;

import java.util.List;
import java.util.Map;

public class NotificationVO {
	/** 알림id **/
	private int notiSeq;
	/** 알림 수신자 id **/
	private String userId;
	/** 알림 메인type **/
	private String mainType;
	/** 알림 서브type **/
	private String subType;
	/** 알림 내용 **/
	private String notiContent;
	/** 알림 발송자 id **/
	private String senderId;
	/** 알림 발송자 이름 **/
	private String senderName;
	/** 알림 발송일 **/
	private String regDate;
	/** 읽음 여부(Y/N) **/
	private String isRead;
	/** 읽은 날짜 **/
	private String readDate;
	/** 기타 데이터 **/
	private String etcData;
	/** 삭제 여부(Y/N) **/
	private String isDelete;
	/** 삭제 날짜 **/
	private String deleteDate;
	/** 알림 웹 링크 url **/
	private String linkUrl;
	/** 알림 모바일 링크 url **/
	private String linkUrlMobile;
	/** 알림 링크 클릭시 화면 표시 타입 (popup/layer) **/
	private String viewType;
	/** 알림 링크 클릭시 화면 너비 **/
	private String viewWidth;
	/** 알림 링크 클릭시 화면 높이 **/
	private String viewHeight;
	/** 테넌트 아이디 **/
	private String tenantId;
	/** 회사 아이디 **/
	private String companyId;
	
	private List<Map<String, Object>> recipient;
	
	private String notiBody;
	
	public int getNotiSeq() {
		return notiSeq;
	}
	public void setNotiSeq(int notiSeq) {
		this.notiSeq = notiSeq;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getMainType() {
		return mainType;
	}
	public void setMainType(String mainType) {
		this.mainType = mainType;
	}
	public String getSubType() {
		return subType;
	}
	public void setSubType(String subType) {
		this.subType = subType;
	}
	public String getNotiContent() {
		return notiContent;
	}
	public void setNotiContent(String notiContent) {
		this.notiContent = notiContent;
	}
	public String getSenderId() {
		return senderId;
	}
	public void setSenderId(String senderId) {
		this.senderId = senderId;
	}
	public String getSenderName() {
		return senderName;
	}
	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}
	public String getRegDate() {
		return regDate;
	}
	public void setRegDate(String regDate) {
		this.regDate = regDate;
	}
	public String getIsRead() {
		return isRead;
	}
	public void setIsRead(String isRead) {
		this.isRead = isRead;
	}
	public String getReadDate() {
		return readDate;
	}
	public void setReadDate(String readDate) {
		this.readDate = readDate;
	}
	public String getEtcData() {
		return etcData;
	}
	public void setEtcData(String etcData) {
		this.etcData = etcData;
	}
	public String getIsDelete() {
		return isDelete;
	}
	public void setIsDelete(String isDelete) {
		this.isDelete = isDelete;
	}
	public String getDeleteDate() {
		return deleteDate;
	}
	public void setDeleteDate(String deleteDate) {
		this.deleteDate = deleteDate;
	}
	public String getLinkUrl() {
		return linkUrl;
	}
	public void setLinkUrl(String linkUrl) {
		this.linkUrl = linkUrl;
	}
	public String getLinkUrlMobile() {
		return linkUrlMobile;
	}
	public void setLinkUrlMobile(String linkUrlMobile) {
		this.linkUrlMobile = linkUrlMobile;
	}
	public String getViewType() {
		return viewType;
	}
	public void setViewType(String viewType) {
		this.viewType = viewType;
	}
	public String getViewWidth() {
		return viewWidth;
	}
	public void setViewWidth(String viewWidth) {
		this.viewWidth = viewWidth;
	}
	public String getViewHeight() {
		return viewHeight;
	}
	public void setViewHeight(String viewHeight) {
		this.viewHeight = viewHeight;
	}
	public String getTenantId() {
		return tenantId;
	}
	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	
	public List<Map<String, Object>> getRecipient() {
		return recipient;
	}
	public void setRecipient(List<Map<String, Object>> recipient) {
		this.recipient = recipient;
	}
	public String getNotiBody() {
		return notiBody;
	}
	public void setNotiBody(String notiBody) {
		this.notiBody = notiBody;
	}
	
	@Override
	public String toString() {
		return "NotificationVO [notiSeq=" + notiSeq + ", userId=" + userId + ", mainType=" + mainType + ", subType="
				+ subType + ", notiContent=" + notiContent + ", senderId=" + senderId + ", senderName=" + senderName
				+ ", regDate=" + regDate + ", isRead=" + isRead + ", readDate=" + readDate + ", etcData=" + etcData
				+ ", isDelete=" + isDelete + ", deleteDate=" + deleteDate + ", linkUrl=" + linkUrl + ", linkUrlMobile="
				+ linkUrlMobile + ", viewType=" + viewType + ", viewWidth=" + viewWidth + ", viewHeight=" + viewHeight
				+ ", tenantId=" + tenantId + ", companyId=" + companyId + "]";
	}
	
}
