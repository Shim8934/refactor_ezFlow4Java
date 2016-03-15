package egovframework.ezEKP.ezEmail.service;

import java.util.List;

import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;

public interface EzEmailService {

	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception;

}
