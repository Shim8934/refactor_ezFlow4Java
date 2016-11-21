package egovframework.ezEKP.ezEmail.service.impl;

import java.security.PrivateKey;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.ezEKP.ezEmail.dao.EzEmailDAO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Service("EzEmailService")
public class EzEmailServiceImpl implements EzEmailService {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzEmailDAO")
	private EzEmailDAO ezEmailDAO;
	
	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
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
	public void setMailGeneral2(String userId, MailGeneralVO mailGeneral) throws Exception {
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
		map.put("v_MAILSENDERNM", mailGeneral.getMailSenderNm());
		
		ezEmailDAO.setMailGeneral2(map);	
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

	@Override
	public String checkDoubleMailReceive(String pSenderEmail, String pSubject, String pRecDate, String pMessageId,
			String pServerName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SENDEREMAIL", pSenderEmail);
		map.put("v_SUBJECT", pSubject);
		map.put("v_RECDATE", pRecDate);
		map.put("v_MESSAGEID", pMessageId);
		map.put("v_SERVERNAME", pServerName);
		return ezEmailDAO.checkDoubleMailReceive(map);
	}

	@Override
	public String insertMailReceiveInfo(String pSenderEmail, String pSubject, String pRecDate, String pMessageId,
			String pServerName, String pRecAllKey) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SENDEREMAIL", pSenderEmail);
		map.put("v_SUBJECT", pSubject);
		map.put("v_RECDATE", pRecDate);
		map.put("v_MESSAGEID", pMessageId);
		map.put("v_SERVERNAME", pServerName);
		map.put("v_RECALLKEY", pRecAllKey);
		return ezEmailDAO.insertMailReceiveInfo(map);
	}

	@Override
	public void insertMailReceiveDetailInfo(int pNum, String pReceiveId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NUM", pNum);
		map.put("v_RECEIVEID", pReceiveId);
		ezEmailDAO.insertMailReceiveDetailInfo(map);
	}

	@Override
	public String getMailReceiveMessageId(String pNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NUM", pNum);
		return ezEmailDAO.getMailReceiveMessageId(map);
	}

	@Override
	public void updateMailReceiveDetailInfo(String pNum, String pEmail, String pCode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NUM", pNum);
		map.put("v_EMAIL", pEmail);
		map.put("v_CODE", pCode);
		ezEmailDAO.updateMailReceiveDetailInfo(map);
	}

	@Override
	public List<String> getMailReceiveAddress(String pNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_NUM", pNum);
		return ezEmailDAO.getMailReceiveAddress(map);
	}

	@Override
	public List<MailPOP3VO> getMailPOP3(String pUserId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		return ezEmailDAO.getMailPOP3(map);
	}
	
	@Override
	public void savePop3(String pUserId, String pRet) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		
		//DB에서 해당 user의 pop3 정보들을 지우기 전에 가져온다.
		List<MailPOP3VO> pop3OldVoList = ezEmailDAO.getMailPOP3(map);
		
		//pop3OldVoList와 같은 list를 하나 더 만든다.
		//사용하지 않는 pop3 정보로 가져온 DB에 저장된 메일들의 정보를 삭제하기 위함이다.
		List<MailPOP3VO> pop3OldVoToDeleteList = new ArrayList<MailPOP3VO>();
		pop3OldVoToDeleteList.addAll(pop3OldVoList);
		
		map = new HashMap<String, Object>();
		map.put("v_USERID", pUserId);
		
		//DB에서 해당 user의 pop3 정보들을 지운다.
		ezEmailDAO.deletePop3ByUserId(map);
		
		Document doc = commonUtil.convertStringToDocument(pRet);
		NodeList rows = doc.getElementsByTagName("ROW");
		
		String prm = egovFileScrty.getPrm();
		String pre = egovFileScrty.getPre();
		PrivateKey pk = EgovFileScrty.getPrivateKey(prm, pre);
		
		for (int i=0; i<rows.getLength(); i++) {
			NodeList children = rows.item(i).getChildNodes();
			String server = children.item(0).getTextContent();
			String port = children.item(1).getTextContent();
			String id = children.item(2).getTextContent();
			String deleteYN = children.item(3).getTextContent();
			String pw = children.item(4).getTextContent();
			String saveTo = children.item(5).getTextContent();
			String saveToFolder = children.item(6).getTextContent();
			String useSsl = children.item(7).getTextContent().equals("true") ? "1" : "0";

			map = new HashMap<String, Object>();
			map.put("v_USERID", pUserId);
			map.put("v_POP3SERVER", server);
			map.put("v_POP3PORTNO", port);
			map.put("v_POP3USERID", id);
			map.put("v_POP3PW", pw);
			map.put("v_SAVETO", saveTo);
			map.put("v_DELETEYN", deleteYN);
			map.put("v_POP3SSLYN", useSsl);
			map.put("v_SAVETOFOLDER", saveToFolder);
			
			for (MailPOP3VO vo : pop3OldVoList) {
				//DB에 원래 들어있던 pop3 정보인지 체크한다.
				if (vo.getPop3Server().toLowerCase().equals(server.toLowerCase())
						&& EgovFileScrty.decryptRsa(pk, vo.getPop3UserId()).equals(EgovFileScrty.decryptRsa(pk, id))) {
					
					//id와 vo.getPop3UserId()가 복호화했을 때에는 같지만 암호화 된 상태에서는 두 값이 다르기 때문에, 두 값을 비교할 때에는 복호화해서 비교해야 한다.
					//DB에 넣을 때에는 원래 DB에 들어있던 vo.getPop3UserId() 값을 넣는다.
					map.put("v_POP3USERID", vo.getPop3UserId());
					
					//원래 있던 pop3 정보로 가져온 메일들의 정보는 지울 필요가 없기 때문에, pop3OldVoToDeleteList에서 뺀다.
					pop3OldVoToDeleteList.remove(vo);
					
					break;
				}
			}
			
			ezEmailDAO.insertPop3(map);
		}

		for (MailPOP3VO vo : pop3OldVoToDeleteList) {
			map = new HashMap<String, Object>();
			map.put("v_USERID", pUserId);
			map.put("v_POP3SERVER", vo.getPop3Server());
			map.put("v_POP3USERID", vo.getPop3UserId());
			
			ezEmailDAO.deletePop3List(map);
		}
			
	}

	@Override
	public void setMailPOP3(String pUserId, String pPop3Server, String pPop3UserId, String pMessageId,
			String pPop3DupMsg) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		map.put("v_PPOP3SERVER", pPop3Server);
		map.put("v_PPOP3USERID", pPop3UserId);
		map.put("v_PMESSAGEID", pMessageId);
		map.put("v_PPOP3DUPMSG", pPop3DupMsg);
		
		ezEmailDAO.setMailPOP3(map);
	}

	@Override
	public List<String> getMailPOP3List(String pUserId, String pPop3Server, String pPop3UserId) throws Exception {
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", pUserId);
		map.put("v_PPOP3SERVER", pPop3Server);
		map.put("v_PPOP3USERID", pPop3UserId);
		
		return ezEmailDAO.getMailPOP3List(map);
	}

	@Override
	public void setMailColor(String pImportanceColor, String pInColor, String pOutColor) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_IMPORTANCE", pImportanceColor);
		map.put("v_INMAIL", pInColor);
		map.put("v_OUTMAIL", pOutColor);
		
		ezEmailDAO.setMailColor(map);
	}
	
}
