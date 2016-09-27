package egovframework.ezEKP.ezPersonal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalDAO")
public class EzPersonalDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<PersonalSliderImageVO> getSilderList (Map<String, Object> map) {
		return (List<PersonalSliderImageVO>) list("EzPersonalDAO.getSliderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollListUser(Map<String, Object> map) throws Exception{
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResultOrderResult (int pItemSeq) {
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollResultOrderResult", pItemSeq);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalLightPollVO> getPollResult (int pItemSeq) {
		return (List<PersonalLightPollVO>) list("EzPersonalDAO.getPollResult", pItemSeq);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetPopUpListUserVO> getPopUpListUser (String pComapnyID) {
		return (List<PersonalGetPopUpListUserVO>) list("EzPersonalDAO.getPopUpListUser", pComapnyID);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartGroupVO> getWebPartGroup (Map<String, Object> map) {
		return (List<PersonalGetWebPartGroupVO>) list("EzPersonalDAO.getWebPartGroup", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetWebPartVO> getUserWebPart (Map<String, Object> map) {
		return (List<PersonalGetWebPartVO>) list("EzPersonalDAO.getUserWebPart", map);
	}
	
	public PersonalGetEmpOfMonthVO getEmpOfMonth (String pTerm) {
		return (PersonalGetEmpOfMonthVO) select("EzPersonalDAO.getEmpOfMonth", pTerm);
	}
	
	public PersonalLightPollVO getCurrentPoll (Map<String, Object> map) {
		return (PersonalLightPollVO) select("EzPersonalDAO.getCurrentPoll", map);
	}
	
	public PersonalLightPollVO getPollInfo (int pItemSeq) {
		return (PersonalLightPollVO) select("EzPersonalDAO.getPollInfo", pItemSeq);
	}
	
	public PersonalGetQuickLinkMenuVO getQuickLinkMenu (String accessID) {
		return (PersonalGetQuickLinkMenuVO) select("EzPersonalDAO.getQuickLinkMenu", accessID);
	}
	
	public String getPassword (String cn) {
		return (String) select("EzPersonalDAO.getPassword", cn);
	}
	
	public int getPollCount(Map<String, Object> map) {
		select("EzPersonalDAO.getPollCount", map);
		return (int) map.get("v_pCount");
	}

	public void setApprovalPwd(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovalPwd", map);
	}

	public void setApprovNotiMail(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.setApprovNotiMail", map);
	}
	
	public void insertResult(Map<String, Object> map) throws Exception{
		insert("EzPersonalDAO.insertResult", map);
	}
	
}
