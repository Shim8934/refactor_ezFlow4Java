package egovframework.ezEKP.ezQuestion.vo;

public class QstPollItemACLVO {
	int brdID;
	int itemNo;
	String gubun;
	String gubunID;
	String gubunNM;
	String gubunNM2;
	String condition;
	int tenant_id;
	public int getBrdID() {
		return brdID;
	}
	public void setBrdID(int brdID) {
		this.brdID = brdID;
	}
	public int getItemNo() {
		return itemNo;
	}
	public void setItemNo(int itemNo) {
		this.itemNo = itemNo;
	}
	public String getGubun() {
		return gubun;
	}
	public void setGubun(String gubun) {
		this.gubun = gubun;
	}
	public String getGubunID() {
		return gubunID;
	}
	public void setGubunID(String gubunID) {
		this.gubunID = gubunID;
	}
	public String getGubunNM() {
		return gubunNM;
	}
	public void setGubunNM(String gubunNM) {
		this.gubunNM = gubunNM;
	}
	public String getGubunNM2() {
		return gubunNM2;
	}
	public void setGubunNM2(String gubunNM2) {
		this.gubunNM2 = gubunNM2;
	}
	public String getCondition() {
		return condition;
	}
	public void setCondition(String condition) {
		this.condition = condition;
	}
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
}
