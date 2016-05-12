package egovframework.ezEKP.ezEmail.service;

import java.util.List;

import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;

public interface EzEmailService {

	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception;
	public MailSignatureVO getMailSignature(String pUserID, String pIsUse) throws Exception;
	public void setMailSignature(String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3) throws Exception;
}
