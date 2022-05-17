package egovframework.ezMobile.ezTalk.vo;

import java.util.Collections;

public class MTalkNotification {

	private int id;
	private String userId;
	private String senderName;
	private String subject;
	private String type;
	private String etcData;
	private String link;
	private Object mgwDeviceInfo;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getSenderName() {
		return senderName;
	}

	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getEtcData() {
		return etcData;
	}

	public void setEtcData(String etcData) {
		this.etcData = etcData;
	}

	public String getLink() {
		return link == null ? "" : link;
	}

	public void setLink(String link) {
		this.link = link;
	}

	public Object getMgwDeviceInfo() {
		// 기기 정보가 비어있으면 {} 으로 표시해주기 위해 빈 맵을 리턴
		return mgwDeviceInfo == null ? Collections.emptyMap() : mgwDeviceInfo;
	}

	public void setMgwDeviceInfo(Object mgwDeviceInfo) {
		this.mgwDeviceInfo = mgwDeviceInfo;
	}

}
