package egovframework.ezEKP.ezSurvey.vo;

public class SurveyVO {

	private int survey_id;
	private String title;
	private String purpose;
	private String user_id;
	private String create_date;
	private String survey_start_date;
	private String survey_end_date;
	private String user_name1;
	private String user_name2;
	private int use_status;
	private int open_days;
	private int result_public_flag;
	private int anonymous_flag;
	private int multi_answer_flag;
	private int participate_flag;
	private String delete_user;
	private String update_user;
	private String udpate_date;
	private String company_id;
	private String tenant_id;
	
	public int getSurvey_id() {
		return survey_id;
	}
	public void setSurvey_id(int survey_id) {
		this.survey_id = survey_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPurpose() {
		return purpose;
	}
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getCreate_date() {
		return create_date;
	}
	public void setCreate_date(String create_date) {
		this.create_date = create_date;
	}
	public String getSurvey_start_date() {
		return survey_start_date;
	}
	public void setSurvey_start_date(String survey_start_date) {
		this.survey_start_date = survey_start_date;
	}
	public String getSurvey_end_date() {
		return survey_end_date;
	}
	public void setSurvey_end_date(String survey_end_date) {
		this.survey_end_date = survey_end_date;
	}
	public String getUser_name1() {
		return user_name1;
	}
	public void setUser_name1(String user_name1) {
		this.user_name1 = user_name1;
	}
	public String getUser_name2() {
		return user_name2;
	}
	public void setUser_name2(String user_name2) {
		this.user_name2 = user_name2;
	}
	public int getUse_status() {
		return use_status;
	}
	public void setUse_status(int use_status) {
		this.use_status = use_status;
	}
	public int getOpen_days() {
		return open_days;
	}
	public void setOpen_days(int open_days) {
		this.open_days = open_days;
	}
	public int getResult_public_flag() {
		return result_public_flag;
	}
	public void setResult_public_flag(int result_public_flag) {
		this.result_public_flag = result_public_flag;
	}
	public int getAnonymous_flag() {
		return anonymous_flag;
	}
	public void setAnonymous_flag(int anonymous_flag) {
		this.anonymous_flag = anonymous_flag;
	}
	public int getMulti_answer_flag() {
		return multi_answer_flag;
	}
	public void setMulti_answer_flag(int multi_answer_flag) {
		this.multi_answer_flag = multi_answer_flag;
	}
	public int getParticipate_flag() {
		return participate_flag;
	}
	public void setParticipate_flag(int participate_flag) {
		this.participate_flag = participate_flag;
	}
	public String getDelete_user() {
		return delete_user;
	}
	public void setDelete_user(String delete_user) {
		this.delete_user = delete_user;
	}
	public String getUpdate_user() {
		return update_user;
	}
	public void setUpdate_user(String update_user) {
		this.update_user = update_user;
	}
	public String getUdpate_date() {
		return udpate_date;
	}
	public void setUdpate_date(String udpate_date) {
		this.udpate_date = udpate_date;
	}
	public String getCompany_id() {
		return company_id;
	}
	public void setCompany_id(String company_id) {
		this.company_id = company_id;
	}
	public String getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(String tenant_id) {
		this.tenant_id = tenant_id;
	}
	@Override
	public String toString() {
		return "SurveyVO [survey_id=" + survey_id + ", title=" + title
				+ ", purpose=" + purpose + ", user_id=" + user_id
				+ ", create_date=" + create_date + ", survey_start_date="
				+ survey_start_date + ", survey_end_date=" + survey_end_date
				+ ", user_name1=" + user_name1 + ", user_name2=" + user_name2
				+ ", use_status=" + use_status + ", open_days=" + open_days
				+ ", result_public_flag=" + result_public_flag
				+ ", anonymous_flag=" + anonymous_flag + ", multi_answer_flag="
				+ multi_answer_flag + ", participate_flag=" + participate_flag
				+ ", delete_user=" + delete_user + ", update_user="
				+ update_user + ", udpate_date=" + udpate_date
				+ ", company_id=" + company_id + ", tenant_id=" + tenant_id
				+ "]";
	}
}
