package egovframework.ezEKP.ezQuestion.vo;

import java.sql.Date;

public class QuestionListVO {
	/** 설문번호*/
	public int itemNo;
	/** 유저아이디*/
	public String userID;
	/** 제목*/
	public String title;
	/** 이라ㅓㅁㄴ이ㅏㅓㄹ 주소값*/
	public String receve;
	/** 기명여부*/
	public String publicFlg;
	/** 유효일*/
	public Date pollEndDate;
	/** 대상자*/
	public String responsRange;
	/** 유저이름*/
	public String userName;
	/** 결과공개*/
	public String resultFlg;
	
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getReceve() {
		return receve;
	}
	public void setReceve(String receve) {
		this.receve = receve;
	}
	public String getPublicFlg() {
		return publicFlg;
	}
	public void setPublicFlg(String publicFlg) {
		this.publicFlg = publicFlg;
	}
	public Date getPollEndDate() {
		return pollEndDate;
	}
	public void setPollEndDate(Date pollEndDate) {
		this.pollEndDate = pollEndDate;
	}
	public String getResponsRange() {
		return responsRange;
	}
	public void setResponsRange(String responsRange) {
		this.responsRange = responsRange;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getResultFlg() {
		return resultFlg;
	}
	public void setResultFlg(String resultFlg) {
		this.resultFlg = resultFlg;
	}
	
}
