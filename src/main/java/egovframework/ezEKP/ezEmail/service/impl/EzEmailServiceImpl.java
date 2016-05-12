package egovframework.ezEKP.ezEmail.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;

@Service("EzEmailService")
public class EzEmailServiceImpl implements EzEmailService {

	@Resource(name="EzEmailDAO")
	private EzEmailDAO ezEmailDAO;

	@Override
	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userId);
		return ezEmailDAO.getMailGeneral(map);
	}

	@Override
	public MailSignatureVO getMailSignature(String pUserID, String pIsUse) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserID);
		map.put("v_ISUSE", pIsUse);
		return ezEmailDAO.getMailSignature(map);
	}

	@Override
	public void setMailSignature(String pUserID, String pUseFlag, String pContent1, String pContent2, String pContent3)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", pUserID);
		map.put("v_USEFLAG", pUseFlag);
		map.put("v_CONTENT1", pContent1);
		map.put("v_CONTENT2", pContent2);
		map.put("v_CONTENT3", pContent3);
		ezEmailDAO.setMailSignature(map);
	}
	
}
