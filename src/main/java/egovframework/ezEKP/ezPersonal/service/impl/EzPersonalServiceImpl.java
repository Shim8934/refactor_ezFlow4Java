package egovframework.ezEKP.ezPersonal.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalDAO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.vo.PersonalApprovMailVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetCurrentPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetEmpOfMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetPollListUserVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalGetSliderListVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzPersonalService")
public class EzPersonalServiceImpl implements EzPersonalService{
	@Resource(name="EzPersonalDAO")
	private EzPersonalDAO ezPersonalDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<PersonalGetSliderListVO> getSilderList(String companyID, String mode, String sliderID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", companyID);
		map.put("v_MODE", mode);
		map.put("v_SLIDERID", sliderID);
		return ezPersonalDAO.getSilderList(map);
	}

	@Override
	public String setApprovalPwd(String userID, String flag, String newPWD, String pwdType) throws Exception {
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PFLAG", flag);
		map.put("v_PPWD", newPWD);
		map.put("v_PPWDTYPE", pwdType);
		
		try {
			ezPersonalDAO.setApprovalPwd(map);
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR " + e.getMessage();
		}
		
		return result;
	}

	@Override
	public String getApprovNotiConfig(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		
		List<PersonalApprovMailVO> approvMailVOList = ezPersonalDAO.getApprovNotiConfig(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < approvMailVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(approvMailVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String setApprovNotiMail(String userID, String alert, String complete, String bansong, String callBack, String hesong, String saveMailFlag) throws Exception {
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PALERT", alert);
		map.put("v_PCOMPLETE", complete);
		map.put("v_PBANSONG", bansong);
		map.put("v_PCALLBACK", callBack);
		map.put("v_PHESONG", hesong);
		map.put("v_PSAVEMAILFLAG", saveMailFlag);
		
		try {
			ezPersonalDAO.setApprovNotiMail(map);
			
			result = "OK";
		} catch (Exception e) {
			result = e.getMessage();
		}
		
		return result;
	}

	@Override
	public PersonalGetEmpOfMonthVO getEmpOfMonth(String pTerm) throws Exception {
		return ezPersonalDAO.getEmpOfMonth(pTerm);
	}

	@Override
	public int getPollCount(String pComapnyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", pComapnyID);
		map.put("v_pMode", "U");
		return ezPersonalDAO.getPollCount(map);
	}

	@Override
	public List<PersonalGetPollListUserVO> getPollListUser(String pComapnyID, int pTotal, int pCount, int pStart) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", pComapnyID);
		map.put("v_pTotal", pTotal);
		map.put("v_pCount", pCount);
		map.put("v_pStart", pStart);
		return ezPersonalDAO.getPollListUser(map);
	}

	@Override
	public PersonalGetCurrentPollVO getCurrentPoll(String pUserID, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUserID", pUserID);
		map.put("v_pCompanyID", pCompanyID);
		return ezPersonalDAO.getCurrentPoll(map);
	}
}
