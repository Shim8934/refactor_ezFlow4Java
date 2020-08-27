package egovframework.ezEKP.ezEmail.service;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import egovframework.ezEKP.ezEmail.vo.MailWriteProcessVO;
import egovframework.let.user.login.vo.LoginVO;

public interface EzEmailWriteService {

    public String isValidReserve(HttpServletRequest request, MailWriteProcessVO writevo, LoginVO loginInfo) throws Exception;
    public void setGeneral(HttpServletRequest request, MailWriteProcessVO writevo, Locale locale);
    public boolean isValidShareId(MailWriteProcessVO writevo, String loginId, String shareId, int tenantId) throws Exception;
    public void loadFromOrigin(MailWriteProcessVO writevo, LoginVO loginInfo, String userAccount, String password, Locale locale, String orgAccount);
    public void setDefaultMailOptions(HttpServletRequest request, MailWriteProcessVO writevo, LoginVO loginInfo, String userName, Locale locale) throws Exception;
    public void setOverwriteMailOptions(MailWriteProcessVO writevo, String userMail, int tenantId, String company) throws Exception;
}
