package egovframework.ezEKP.ezEmail.vo;

import java.util.List;

public class MailDistributionVO {
	
	private String name;
	private String id;
	private String mail;
	private List<String> member;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	public List<String> getMember() {
		return member;
	}
	public void setMember(List<String> member) {
		this.member = member;
	}
	
	@Override
	public String toString() {
		return "MailDistributionVO [name=" + name + ", id=" + id + ", mail=" + mail + "]";
	}
	
}
