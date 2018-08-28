package egovframework.ezEKP.ezMemo.vo;

public class MemoFolderVO {
	
	/** 메모함 아이디*/
	private int folder_id;
	/** 메모함 이름*/
	private String folder_name;
	/** 사용자 아이디*/
	private String user_id;
	/** 메모함 생성 날짜*/
	private String reg_date;
	/** 메모함 삭제 날짜*/
	private String delete_date;
	/** 메모함 순서*/
	private int orders;
	/** 메모함 아이콘 아이디*/
	private String icon_id;
	/** 메모 갯수*/
	private int count;
	/** 메모 삭제 플래그*/
	private int delete_flag;
	/** UTC offset*/
	private String offset;
	/** 컴퍼너 아이디*/
	private String company_id;
	/** 테넌트 아이디*/
	private int tenant_id;
	
	
	public int getFolder_id() {
		return folder_id;
	}
	public void setFolder_id(int folder_id) {
		this.folder_id = folder_id;
	}
	public String getFolder_name() {
		return folder_name;
	}
	public void setFolder_name(String folder_name) {
		this.folder_name = folder_name;
	}
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public String getReg_date() {
		return reg_date;
	}
	public void setReg_date(String reg_date) {
		this.reg_date = reg_date;
	}
	public String getDelete_date() {
		return delete_date;
	}
	public void setDelete_date(String delete_date) {
		this.delete_date = delete_date;
	}
	public int getOrders() {
		return orders;
	}
	public void setOrders(int orders) {
		this.orders = orders;
	}
	public String getIcon_id() {
		return icon_id;
	}
	public void setIcon_id(String icon_id) {
		this.icon_id = icon_id;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	public int getDelete_flag() {
		return delete_flag;
	}
	public void setDelete_flag(int delete_flag) {
		this.delete_flag = delete_flag;
	}
	public String getOffset() {
		return offset;
	}
	public void setOffset(String offset) {
		this.offset = offset;
	}
	public String getCompany_id() {
		return company_id;
	}
	public void setCompany_id(String company_id) {
		this.company_id = company_id;
	}
	public int getTenant_id() {
		return tenant_id;
	}
	public void setTenant_id(int tenant_id) {
		this.tenant_id = tenant_id;
	}
}
