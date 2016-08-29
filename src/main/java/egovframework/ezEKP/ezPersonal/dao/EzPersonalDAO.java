package egovframework.ezEKP.ezPersonal.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetCurrentPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollResultOrderResultVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPopUpListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetQuickLinkMenuVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartGroupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetWebPartVO;
import egovframework.rte.psl.dataaccess.EgovAbstractDAO;

@Repository("EzPersonalDAO")
public class EzPersonalDAO extends EgovAbstractDAO{
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetSliderListVO> getSilderList (Map<String, Object> map) {
		return (List<PersonalGetSliderListVO>) list("EzPersonalDAO.getSliderList", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalApprovMailVO> getApprovNotiConfig(Map<String, Object> map) throws Exception{
		return (List<PersonalApprovMailVO>) list("EzPersonalDAO.getApprovNotiConfig", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetPollListUserVO> getPollListUser(Map<String, Object> map) throws Exception{
		return (List<PersonalGetPollListUserVO>) list("EzPersonalDAO.getPollListUser", map);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetPollResultOrderResultVO> getPollResultOrderResult (int pItemSeq) {
		return (List<PersonalGetPollResultOrderResultVO>) list("EzPersonalDAO.getPollResultOrderResult", pItemSeq);
	}
	
	@SuppressWarnings("unchecked")
	public List<PersonalGetPollResultOrderResultVO> getPollResult (int pItemSeq) {
		return (List<PersonalGetPollResultOrderResultVO>) list("EzPersonalDAO.getPollResult", pItemSeq);
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
	
	public PersonalGetCurrentPollVO getCurrentPoll (Map<String, Object> map) {
		return (PersonalGetCurrentPollVO) select("EzPersonalDAO.getCurrentPoll", map);
	}
	
	public PersonalGetCurrentPollVO getPollInfo (int pItemSeq) {
		return (PersonalGetCurrentPollVO) select("EzPersonalDAO.getPollInfo", pItemSeq);
	}
	
	public PersonalGetQuickLinkMenuVO getQuickLinkMenu (String accessID) {
		return (PersonalGetQuickLinkMenuVO) select("EzPersonalDAO.getQuickLinkMenu", accessID);
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
