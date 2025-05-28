package egovframework.ezEKP.ezEmail.vo;

import java.util.Arrays;

public class MailSignatureVO {
	private String useFlag = "0"; // default
	private String content1 = "";
	private String content2 = "";
	private String content3 = "";

	public String getUseFlag() {
		return useFlag;
	}
	public void setUseFlag(String useFlag) {
		useFlag = useFlag.trim();

		if (Arrays.asList("0", "1", "2", "3").contains(useFlag)) { // content{n} 늘어나면 추가해줄것.
			this.useFlag = useFlag;
		}
	}
	public String getContent1() {
		return content1;
	}
	public void setContent1(String content1) {
		this.content1 = content1;
	}
	public String getContent2() {
		return content2;
	}
	public void setContent2(String content2) {
		this.content2 = content2;
	}
	public String getContent3() {
		return content3;
	}
	public void setContent3(String content3) {
		this.content3 = content3;
	}
	
	@Override
	public String toString() {
		return "MailSignatureVO [useFlag=" + useFlag + ", content1=" + content1 + ", content2=" + content2
				+ ", content3=" + content3 + "]";
	}
}
