package egovframework.ezEKP.ezMemo.vo;

public class MemoVO {
	
	/** 메모 아이디*/
	private int memo_id;
	/** 메모 내용*/
	private String contents;
	/** 사용자 아이디*/
	private String userId;
	/** 메모 hide&show 플래그*/
	private int display_flag;
	/** 메모 삭제 플래그*/
	private int delete_flag;
	/** 메모 작성(수정)일*/
	private String write_date;
	/** 메모 삭제일*/
	private String delete_date;
	/** 메모 정렬 순서*/
	private int order;
	/** 메모함 아이디*/
	private int folder_id;
	/** 메모지 색상 아이디*/
	private int color_id;
	/** UTC offset*/
	private String offset;
	/** 컴퍼니 아이디*/
	private String company_id;
	/** 테넌트 아이디*/
	private int tenant_id;
	
	
	public int getMemo_id() {
		return memo_id;
	}
	public void setMemo_id(int memo_id) {
		this.memo_id = memo_id;
	}
	public String getContents() {
		return contents;
	}
	public void setContents(String contents) {
		this.contents = contents;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getDisplay_flag() {
		return display_flag;
	}
	public void setDisplay_flag(int display_flag) {
		this.display_flag = display_flag;
	}
	public int getDelete_flag() {
		return delete_flag;
	}
	public void setDelete_flag(int delete_flag) {
		this.delete_flag = delete_flag;
	}
	public String getWrite_date() {
		return write_date;
	}
	public void setWrite_date(String write_date) {
		this.write_date = write_date;
	}
	public String getDelete_date() {
		return delete_date;
	}
	public void setDelete_date(String delete_date) {
		this.delete_date = delete_date;
	}
	public int getOrder() {
		return order;
	}
	public void setOrder(int order) {
		this.order = order;
	}
	public int getFolder_id() {
		return folder_id;
	}
	public void setFolder_id(int folder_id) {
		this.folder_id = folder_id;
	}
	public int getColor_id() {
		return color_id;
	}
	public void setColor_id(int color_id) {
		this.color_id = color_id;
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
