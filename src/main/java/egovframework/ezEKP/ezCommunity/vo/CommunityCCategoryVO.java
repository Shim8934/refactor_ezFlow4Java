package egovframework.ezEKP.ezCommunity.vo;

public class CommunityCCategoryVO {
	/** 카테고리코드*/
	String cCode;
	/** 카테고리종류*/
	String cCat;
	/** 카테고리이름(코드화 함)*/
	String cName;
	/** 표시정렬순서*/
	int cOrder;
	public String getcCode() {
		return cCode;
	}
	public void setcCode(String cCode) {
		this.cCode = cCode;
	}
	public String getcCat() {
		return cCat;
	}
	public void setcCat(String cCat) {
		this.cCat = cCat;
	}
	public String getcName() {
		return cName;
	}
	public void setcName(String cName) {
		this.cName = cName;
	}
	public int getcOrder() {
		return cOrder;
	}
	public void setcOrder(int cOrder) {
		this.cOrder = cOrder;
	}
	
}
