package egovframework.ezEKP.ezMemo.vo;

public class MemoConfigVO {
	

	/** 사용자 아이디 */
	private String user_id;
	/** 폰트 사이즈 */
	private int font_size;
	/** 날짜 표시 여부 */
	private int use_date;
	/** 메모 가젯 표시 여부*/
	private int use_gadget;
	/** 메모지 초기 색상 */
	private int default_color;
	/** 퀵메모 x좌표*/
	private int gadget_right;
	/** 퀵메모 y좌표*/
	private int gadget_bottom;
	/** 레이어 팝업 x 좌표*/
	private int layer_left;
	/** 레이어 팝업 y 좌표*/
	private int layer_top;
	/** 레이어 팝업 너비*/
	private int layer_width;
	/** 레이어 팝업 높이*/
	private int layer_height;
	/** 컴퍼니 아이디*/
	private String company_id;
	/** 테넌트 아이디*/
	private int tenant_id;
	/** 레이어 창 전체화면 모드 */
	private int full_mode;
	
	/*큰 메모 left*/
	private int b_memo_left;
	/*큰 메모 top*/
	private int b_memo_top;
	/*큰 메모 width*/
	private int b_memo_width;
	/*큰 메모 height*/
	private int b_memo_height;
	/*큰 메모 오픈 상태*/
	private int b_memo_status;
	/*가장 최근에 큰 메모로 오픈한 메모 아이디*/
	private int memo_id;
	
	public String getUser_id() {
		return user_id;
	}
	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}
	public int getFont_size() {
		return font_size;
	}
	public void setFont_size(int font_size) {
		this.font_size = font_size;
	}
	public int getUse_date() {
		return use_date;
	}
	public void setUse_date(int use_date) {
		this.use_date = use_date;
	}
	public int getUse_gadget() {
		return use_gadget;
	}
	public void setUse_gadget(int use_gadget) {
		this.use_gadget = use_gadget;
	}
	public int getDefault_color() {
		return default_color;
	}
	public void setDefault_color(int default_color) {
		this.default_color = default_color;
	}
	public int getGadget_right() {
		return gadget_right;
	}
	public void setGadget_right(int gadget_right) {
		this.gadget_right = gadget_right;
	}
	public int getGadget_bottom() {
		return gadget_bottom;
	}
	public void setGadget_bottom(int gadget_bottom) {
		this.gadget_bottom = gadget_bottom;
	}
	public int getLayer_left() {
		return layer_left;
	}
	public void setLayer_left(int layer_left) {
		this.layer_left = layer_left;
	}
	public int getLayer_top() {
		return layer_top;
	}
	public void setLayer_top(int layer_top) {
		this.layer_top = layer_top;
	}
	public int getLayer_width() {
		return layer_width;
	}
	public void setLayer_width(int layer_width) {
		this.layer_width = layer_width;
	}
	public int getLayer_height() {
		return layer_height;
	}
	public void setLayer_height(int layer_height) {
		this.layer_height = layer_height;
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
	public int getFull_mode() {
		return full_mode;
	}
	public void setFull_mode(int full_mode) {
		this.full_mode = full_mode;
	}
	public int getB_memo_left() {
		return b_memo_left;
	}
	public void setB_memo_left(int b_memo_left) {
		this.b_memo_left = b_memo_left;
	}
	public int getB_memo_top() {
		return b_memo_top;
	}
	public void setB_memo_top(int b_memo_top) {
		this.b_memo_top = b_memo_top;
	}
	public int getB_memo_width() {
		return b_memo_width;
	}
	public void setB_memo_width(int b_memo_width) {
		this.b_memo_width = b_memo_width;
	}
	public int getB_memo_height() {
		return b_memo_height;
	}
	public void setB_memo_height(int b_memo_height) {
		this.b_memo_height = b_memo_height;
	}
	public int getB_memo_status() {
		return b_memo_status;
	}
	public void setB_memo_status(int b_memo_status) {
		this.b_memo_status = b_memo_status;
	}
	public int getMemo_id() {
		return memo_id;
	}
	public void setMemo_id(int memo_id) {
		this.memo_id = memo_id;
	}
}
