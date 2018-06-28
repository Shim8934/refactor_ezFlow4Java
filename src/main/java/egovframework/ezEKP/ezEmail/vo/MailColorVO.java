package egovframework.ezEKP.ezEmail.vo;

public class MailColorVO {
	
	private String importanceColor;
	private String inmailColor;
	private String outmailColor;
	
	public String getImportanceColor() {
		return importanceColor;
	}
	public void setImportanceColor(String importanceColor) {
		this.importanceColor = importanceColor;
	}
	public String getInmailColor() {
		return inmailColor;
	}
	public void setInmailColor(String inmailColor) {
		this.inmailColor = inmailColor;
	}
	public String getOutmailColor() {
		return outmailColor;
	}
	public void setOutmailColor(String outmailColor) {
		this.outmailColor = outmailColor;
	}
	
	@Override
	public String toString() {
		return "MailColorVO [importanceColor=" + importanceColor + ", inmailColor=" + inmailColor + ", outmailColor="
				+ outmailColor + "]";
	}
	
}
