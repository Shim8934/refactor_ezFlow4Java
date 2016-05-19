package egovframework.ezEKP.ezEmail.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezEmail.vo.MailDeleteVO;
import egovframework.ezEKP.ezEmail.vo.MailGeneralVO;
import egovframework.ezEKP.ezEmail.vo.MailReservationVO;
import egovframework.ezEKP.ezEmail.vo.MailSignatureVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzEmailDAO")
public class EzEmailDAO extends EgovAbstractDAO {

	@SuppressWarnings("unchecked")
	public List<MailGeneralVO> getMailGeneral(Map<String, Object> map) throws Exception {
		return (List<MailGeneralVO>)list("EzEmailDAO.getMailGeneral", map);
	}	
	
	public void setMailGeneral(Map<String, Object> map) throws Exception {
		update("EzEmailDAO.setMailGeneral", map);
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
	
}