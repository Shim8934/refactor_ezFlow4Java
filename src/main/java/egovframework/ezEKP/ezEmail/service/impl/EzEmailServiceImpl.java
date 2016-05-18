package egovframework.ezEKP.ezEmail.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
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

	@Override
	public List<MailDeleteVO> getMailDelete(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userId);
		return ezEmailDAO.getMailDelete(map);
	}

	@Override
	public void setMailDelete(String pUserID, String pPath, int pExpireTime, int pDeleteUnread, String pFolderName)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserID);
		map.put("v_PPATH", pPath);
		map.put("v_PEXPIRETIME", pExpireTime);
		map.put("v_PDELETEUNREAD", pDeleteUnread);
		map.put("v_PFOLDERNAME", pFolderName);
		ezEmailDAO.setMailDelete(map);
	}

	@Override
	public void deleteMailDelete(String pUserID, int pItemSeq) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserID);
		map.put("v_PITEMSEQ", pItemSeq);
		ezEmailDAO.deleteMailDelete(map);
	}

	@Override
	public List<MailDeleteVO> getMailDeleteList() throws Exception {
		return ezEmailDAO.getMailDeleteList();
	}
	
}
