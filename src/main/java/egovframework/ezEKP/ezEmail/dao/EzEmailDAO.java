package egovframework.ezEKP.ezEmail.dao;

import java.io.File;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezEmail.vo.MailBlobVO;
import egovframework.ezEKP.ezEmail.vo.MailCancelVO;
import egovframework.ezEKP.ezEmail.vo.MailColorVO;
import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailDeletedIdVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailPOP3VO;
import egovframework.ezEKP.ezEmail.vo.MailReadVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import org.egovframe.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzEmailDAO")
public class EzEmailDAO extends EgovAbstractDAO {

	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@SuppressWarnings("unchecked")
	public List<MailGeneralVO> getMailGeneral(Map<String, Object> map) throws Exception {
		return (List<MailGeneralVO>)list("EzEmailDAO.getMailGeneral", map);
	}	
	
	public void setMailGeneral(Map<String, Object> map) throws Exception {
		update("EzEmailDAO.setMailGeneral", map);
	}
	
	public void setMailGeneral2(Map<String, Object> map) throws Exception {
		update("EzEmailDAO.setMailGeneral2", map);
	}
	
	public MailSignatureVO getMailSignature(Map<String, Object> map) throws Exception {
		return (MailSignatureVO)select("EzEmailDAO.getMailSignature", map);
	}
	
	public void setMailSignature(Map<String, Object> map) throws Exception {
		update("EzEmailDAO.setMailSignature", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailDeleteVO> getMailDelete(Map<String, Object> map) throws Exception {
		return (List<MailDeleteVO>)list("EzEmailDAO.getMailDelete", map);
	}
	
	public void setMailDelete(Map<String, Object> map) throws Exception {
		insert("EzEmailDAO.setMailDelete", map);
	}
	
	public void deleteMailDelete(Map<String, Object> map) throws Exception {
		delete("EzEmailDAO.deleteMailDelete", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailBlobVO> getOrphanedMailBlobList() throws Exception {
		return (List<MailBlobVO>)list("EzEmailDAO.getOrphanedMailBlobList");
	}
	
	public long deleteOrphanedMailBlob(MailBlobVO mailBlobVO) throws Exception {
		delete("EzEmailDAO.deleteOrphanedMailBlob", mailBlobVO);
		
		long sleepTime = 500;
		
		if (mailBlobVO.getMailBoxId() != null && mailBlobVO.getMailUid() != null) {
			long mailboxId = mailBlobVO.getMailBoxId();
			long mailUid = mailBlobVO.getMailUid();
			String headerPath = ezEmailUtil.getMailHeaderPath(mailboxId, mailUid);
			String bodyPath = ezEmailUtil.getMailBodyPath(mailboxId, mailUid);
			File headerFile = new File(headerPath);
			File bodyFile = new File(bodyPath);
			
			if (headerFile.exists()) {
				headerFile.delete();
				
				sleepTime = 0;
			}
			
			if (bodyFile.exists()) {
				bodyFile.delete();
				
				sleepTime = 0;
			}		
		} else {
			logger.debug("deleteOrphanedMailBlob mailboxId=" + mailBlobVO.getMailBoxId() + ",mailUid=" + mailBlobVO.getMailUid());
			
			sleepTime = 0;
		}
		
		return sleepTime;
	}
	
	@SuppressWarnings("unchecked")
	public List<MailDeletedIdVO> getMailDeletedIdList() throws Exception {
		return (List<MailDeletedIdVO>)list("EzEmailDAO.getMailDeletedIdList");
	}
	
	public void deleteMailBlobWithDeletedId(MailDeletedIdVO mailDeletedIdVO) throws Exception {
		delete("EzEmailDAO.deleteMailBlobWithDeletedId", mailDeletedIdVO);
		
		long mailboxId = mailDeletedIdVO.getMailBoxId();
		long mailUid = mailDeletedIdVO.getMailUid();
		String headerPath = ezEmailUtil.getMailHeaderPath(mailboxId, mailUid);
		String bodyPath = ezEmailUtil.getMailBodyPath(mailboxId, mailUid);
		File headerFile = new File(headerPath);
		File bodyFile = new File(bodyPath);
		
		if (headerFile.exists()) {
			headerFile.delete();
		}
		
		if (bodyFile.exists()) {
			bodyFile.delete();
		}				
	}

	public void deleteMailDeletedId(MailDeletedIdVO mailDeletedIdVO) throws Exception {
		delete("EzEmailDAO.deleteMailDeletedId", mailDeletedIdVO);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailDeleteVO> getMailDeleteList() throws Exception {
		return (List<MailDeleteVO>)list("EzEmailDAO.getMailDeleteList");
	}

	@SuppressWarnings("unchecked")
	public List<MailReservationVO> getMailReserved(Map<String, Object> map) throws Exception {
		return (List<MailReservationVO>)list("EzEmailDAO.getMailReserved", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailReservationVO> getMailReserved2() throws Exception {
		return (List<MailReservationVO>)list("EzEmailDAO.getMailReserved2");
	}
	
	public void setMailReserved(Map<String, Object> map) throws Exception {
		insert("EzEmailDAO.setMailReserved", map);
	}
	
	public void deleteMailReserved(Map<String, Object> map) throws Exception {
		delete("EzEmailDAO.deleteMailReserved", map);
	}
	
	public String getMailReservedTime(Map<String, Object> map) throws Exception {
		return (String)select("EzEmailDAO.getMailReservedTime", map);
	}
	
	public MailColorVO getMailColor() throws Exception {
		return (MailColorVO)select("EzEmailDAO.getMailColor");
	}
	
	public MailReservationVO checkReservedMail(Map<String, Object> map) throws Exception {
		return (MailReservationVO)select("EzEmailDAO.checkReservedMail", map);
	}
	
	public void updateReservedMail(Map<String, Object> map) throws Exception {
		update("EzEmailDAO.updateReservedMail", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailReadVO> getMailReadList(Map<String, Object> map) throws Exception {
		return (List<MailReadVO>)list("EzEmailDAO.getMailReadList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailCancelVO> getMailCancelList(Map<String, Object> map) throws Exception {
		return (List<MailCancelVO>)list("EzEmailDAO.getMailCancelList", map);
	}
	
	public String checkDoubleMailReceive(Map<String, Object> map) throws Exception {
		return (String)select("EzEmailDAO.checkDoubleMailReceive", map);
	}
	
	public String insertMailReceiveInfo(Map<String, Object> map) throws Exception {
		return (String)select("EzEmailDAO.insertMailReceiveInfo", map);
	}
	
	public void insertMailReceiveDetailInfo(Map<String, Object> map) throws Exception {
		insert("EzEmailDAO.insertMailReceiveDetailInfo", map);
	}
	
	public String getMailReceiveMessageId(Map<String, Object> map) throws Exception {
		return (String)select("EzEmailDAO.getMailReceiveMessageId", map);
	}
	
	public void updateMailReceiveDetailInfo(Map<String, Object> map) throws Exception {
		insert("EzEmailDAO.updateMailReceiveDetailInfo", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getMailReceiveAddress(Map<String, Object> map) throws Exception {
		return (List<String>)list("EzEmailDAO.getMailReceiveAddress", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<MailPOP3VO> getMailPOP3(Map<String, Object> map) throws Exception {
		return (List<MailPOP3VO>)list("EzEmailDAO.getMailPOP3", map);
	}
	
	public void deletePop3ByUserId(Map<String, Object> map) throws Exception {
		delete("EzEmailDAO.deletePop3ByUserId", map);
	}
	
	public void insertPop3(Map<String, Object> map) throws Exception {
		insert("EzEmailDAO.insertPop3", map);
	}
	
	public void deletePop3List(Map<String, Object> map) throws Exception {
		delete("EzEmailDAO.deletePop3List", map);
	}
	
	public void setMailPOP3(Map<String, Object> map) throws Exception {
		insert("EzEmailDAO.setMailPOP3", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<String> getMailPOP3List(Map<String, Object> map) throws Exception {
		return (List<String>)list("EzEmailDAO.getMailPOP3List", map);
	}
	
	public void setMailColor(Map<String, Object> map) throws Exception{
		insert("EzEmailDAO.setMailColor", map);
	}
	
	public void setBigAttachCountInfo(Map<String, Object> map) throws Exception{
		insert("EzEmailDAO.setBigAttachCountInfo", map);
	}
	
	public String checkBigAttachDownloadCount(Map<String, Object> map) throws Exception{
		return (String)select("EzEmailDAO.checkBigAttachDownloadCount", map);
	}
	
	public void updateBigAttachDownloadCount(Map<String, Object> map) throws Exception{
		update("EzEmailDAO.updateBigAttachDownloadCount", map);
	}

	public void deleteBigAttachCountInfo(Map<String, Object> map) {
		delete("EzEmailDAO.deleteBigAttachCountInfo", map);
	}
	
	public void setMailboxProgress(Map<String, Object> map) {
		insert("EzEmailDAO.setMailboxProgress", map);
	}
	
	public int updateMailboxProgress(Map<String, Object> map) {
		return update("EzEmailDAO.updateMailboxProgress", map);
	}
	
	public String getMailboxProgress(Map<String, Object> map) {
		return (String) select("EzEmailDAO.getMailboxProgress", map);
	}
	
	public int deleteMailboxProgress(Map<String, Object> map) {
		return delete("EzEmailDAO.deleteMailboxProgress", map);
	}

	// 승인메일
	public int checkApprMailApprover(Map<String, Object> map) {
		return (int) select("EzEmailDAO.checkApprMailApprover", map);
	}
	
	public void cancelMailByMailUid(MailDeletedIdVO mailDeletedIdVO) {
		delete("EzEmailDAO.cancelMailByMailUid", mailDeletedIdVO);
	}
}