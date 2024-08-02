package egovframework.ezEKP.ezEmail.vo;

import java.util.Arrays;

public class MailApprVO {

	private String[] hrefArray;
	private String memo;
	private int pageStartNum;
	private int pageEndNum;

	public String[] getHrefArray() {
		return hrefArray;
	}

	public void setHrefArray(String[] hrefArray) {
		this.hrefArray = hrefArray;
	}

	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public int getPageStartNum() {
		return pageStartNum;
	}

	public void setPageStartNum(int pageStartNum) {
		this.pageStartNum = pageStartNum;
	}

	public int getPageEndNum() {
		return pageEndNum;
	}

	public void setPageEndNum(int pageEndNum) {
		this.pageEndNum = pageEndNum;
	}

	@Override
	public String toString() {
		return "MailApprVO [hrefArray=" + Arrays.toString(hrefArray) + ", memo=" + memo + ", pageStartNum="
				+ pageStartNum + ", pageEndNum=" + pageEndNum + "]";
	}
}
