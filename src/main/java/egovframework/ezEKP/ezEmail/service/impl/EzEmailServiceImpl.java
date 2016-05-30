package egovframework.ezEKP.ezEmail.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;

@Service("EzEmailService")
public class EzEmailServiceImpl implements EzEmailService {

	@Resource(name="EzEmailDAO")
	private EzEmailDAO ezEmailDAO;

	@Override
	public List<MailGeneralVO> getMailGeneral(String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();		
		map.put("v_PUSERID", userId);
		
		List<MailGeneralVO> mailGeneralList = ezEmailDAO.getMailGeneral(map);
		
		// set the defaults if there is no record in DB.
		if (mailGeneralList.size() == 0) {
			MailGeneralVO mailGeneral = new MailGeneralVO();
			mailGeneral.setListCount("30");
			mailGeneral.setRefreshInterval("300");
			mailGeneral.setKeepDeleteLength("0");
			mailGeneral.setPreviewMode("OFF");
			mailGeneral.setPreviewWList("50");
			mailGeneral.setPreviewWContent("50");
			mailGeneral.setPreviewHList("50");
			mailGeneral.setPreviewHContent("50");	
			mailGeneral.setMailSenderNm("");
			
			mailGeneralList.add(mailGeneral);
		}
		
		return mailGeneralList;
	}

	@Override
	public void setMailGeneral(String userId, MailGeneralVO mailGeneral) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PUSERID", userId);
		map.put("v_PLISTCNT", mailGeneral.getListCount());
		map.put("v_PREFRESHINTERVAL", mailGeneral.getRefreshInterval());
		map.put("v_PKEEPDELETELENGTH", mailGeneral.getKeepDeleteLength());
		map.put("v_PREVIEWMODE", mailGeneral.getPreviewMode());
		map.put("v_PREVIEWWLIST", mailGeneral.getPreviewWList());
		map.put("v_PREVIEWWCONTENT", mailGeneral.getPreviewWContent());
		map.put("v_PREVIEWHLIST", mailGeneral.getPreviewHList());
		map.put("v_PREVIEWHCONTENT", mailGeneral.getPreviewHContent());
		
		ezEmailDAO.setMailGeneral(map);		
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

	@Override
	public List<MailReservationVO> getMailReserved(String pEmail) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PURL", pEmail);
		return ezEmailDAO.getMailReserved(map);
	}
	
	@Override
	public List<MailReservationVO> getMailReserved2() throws Exception {
		return ezEmailDAO.getMailReserved2();
	}
	
	@Override
	public void setMailReserved(String pMessageId, String pSubject, String pSendDate, String pConnUrl)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMESSAGEID", pMessageId);
		map.put("v_PSUBJECT", pSubject);
		map.put("v_PSENDDATE", pSendDate);
		map.put("v_PCONNURL", pConnUrl);
		ezEmailDAO.setMailReserved(map);
	}

	@Override
	public void deleteMailReserved(String pMessageId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMESSAGEID", pMessageId);
		ezEmailDAO.deleteMailReserved(map);
	}

	@Override
	public MailReservationVO getMailReservedTime(String pMessageId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MESSAGEID", pMessageId);
		return ezEmailDAO.getMailReservedTime(map);
	}

	@Override
	public MailColorVO getMailColor() throws Exception {
		return ezEmailDAO.getMailColor();
	}

	@Override
	public MailReservationVO checkReservedMail(String pMessageId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MESSAGEID", pMessageId);
		return ezEmailDAO.checkReservedMail(map);
	}

	@Override
	public void updateReservedMail(String pMessageId, String pSubject, String pSendDate) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MESSAGEID", pMessageId);
		map.put("v_SUBJECT", pSubject);
		map.put("v_SENDDATE", pSendDate);
		ezEmailDAO.updateReservedMail(map);
	}

	@Override
	public List<MailReadVO> getMailReadList(String pUserId, String pUserId2, String pMessageId, String pMessageId2)
			throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		map.put("v_PUSERID2", pUserId2);
		map.put("v_PMESSAGEID", pMessageId);
		map.put("v_PMESSAGEID2", pMessageId2);
		return ezEmailDAO.getMailReadList(map);
	}

	@Override
	public List<MailCancelVO> getMailCancelList(String pMessage) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMESSAGE", pMessage);
		return ezEmailDAO.getMailCancelList(map);
	}
	
}
