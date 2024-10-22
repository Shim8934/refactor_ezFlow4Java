package egovframework.ezEKP.ezNotification.vo;

import java.util.Objects;

public class NotiRecipientVO {
	private String cn;
	private String companyId;
	private String mail;
	
	public String getCn() {
		return cn;
	}
	public void setCn(String cn) {
		this.cn = cn;
	}
	public String getCompanyId() {
		return companyId;
	}
	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}
	public String getMail() {
		return mail;
	}
	public void setMail(String mail) {
		this.mail = mail;
	}
	
	@Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        NotiRecipientVO notiRecipientVO = (NotiRecipientVO) o;
        return Objects.equals(cn, notiRecipientVO.cn) && Objects.equals(companyId, notiRecipientVO.companyId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(cn, companyId);
    }
	
}
