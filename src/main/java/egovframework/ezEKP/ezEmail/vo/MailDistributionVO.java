package egovframework.ezEKP.ezEmail.vo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;

public class MailDistributionVO {
	
	private String name;
	private String id;
	private String mail;
	private List<String> member;
	private String ownerId;
	private String disclosurePolicy;
	private String explaination;
	private String endDate;
	private String companyId;
	private String domain;
	
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
	public String getOwnerId() {
		return ownerId;
	}
	public void setOwnerId(String ownerId) {
		this.ownerId = ownerId;
	}
	public String getDisclosurePolicy() {
		return disclosurePolicy;
	}
	public void setDisclosurePolicy(String disclosurePolicy) {
		this.disclosurePolicy = disclosurePolicy;
	}
	public String getExplaination() {
		return explaination;
	}
	public void setExplaination(String explaination) {
		this.explaination = explaination;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getDomain() {
		return domain;
	}
	public void setDomain(String domain) {
		this.domain = domain;
	}
	
	@Override
	public String toString() {
		return "MailDistributionVO [name=" + name + ", id=" + id + ", mail=" + mail + ", companyId=" + companyId + "]";
	}
	
	public JSONObject getJsonObj() {
		Map<String, String> map = new HashMap<String, String>();
		map.put("name", name);
		map.put("id", id);
		map.put("mail", mail);
		map.put("ownerId", ownerId);
		map.put("disclosurePolicy", disclosurePolicy);
		map.put("explaination", explaination);
		map.put("endDate", endDate);
		
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}
	
}
