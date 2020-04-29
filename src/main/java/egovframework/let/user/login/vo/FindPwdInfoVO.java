package egovframework.let.user.login.vo;

import java.sql.Date;
import java.sql.Timestamp;

import net.fortuna.ical4j.model.DateTime;

public class FindPwdInfoVO {

	private String sabun;
	private Timestamp req_Date;
	private String certification_Num;
	private String certification;
	private String phone_Num;
	
	public String getSabun() {
		return sabun;
	}
	public void setSabun(String sabun) {
		this.sabun = sabun;
	}
	public Timestamp getReq_Date() {
		return req_Date;
	}
	public void setReq_Date(Timestamp req_Date) {
		this.req_Date = req_Date;
	}
	public String getCertification_Num() {
		return certification_Num;
	}
	public void setCertification_Num(String certification_Num) {
		this.certification_Num = certification_Num;
	}
	public String getCertification() {
		return certification;
	}
	public void setCertification(String certification) {
		this.certification = certification;
	}
	public String getPhone_Num() {
		return phone_Num;
	}
	public void setPhone_Num(String phone_Num) {
		this.phone_Num = phone_Num;
	}
	

}
