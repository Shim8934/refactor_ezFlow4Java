package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCCategoryVO {
	/** 카테고리코드*/
	String c_Code;
	/** 카테고리종류*/
	String c_Cat;
	/** 카테고리이름(코드화 함)*/
	String c_Name;
	/** 표시정렬순서*/
	int c_Order;
	public String getC_Code() {
		return c_Code;
	}
	public void setC_Code(String c_Code) {
		this.c_Code = c_Code;
	}
	public String getC_Cat() {
		return c_Cat;
	}
	public void setC_Cat(String c_Cat) {
		this.c_Cat = c_Cat;
	}
	public String getC_Name() {
		return c_Name;
	}
	public void setC_Name(String c_Name) {
		this.c_Name = c_Name;
	}
	public int getC_Order() {
		return c_Order;
	}
	public void setC_Order(int c_Order) {
		this.c_Order = c_Order;
	}
}
