package egovframework.ezEKP.ezOrgan.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;

@Service("EzOrganService")
public class EzOrganServiceImpl implements EzOrganService {
	
	@Resource(name = "EzOrganDAO")
	EzOrganDAO ezOrganDAO;

	@Override
	public String getPropertyValue(String userid, String propName) throws Exception{
		return ezOrganDAO.getPropertyValue(userid,propName);
	}

	@Override
	public String getSIPUriList(String pCNList, String eMailList) throws Exception{
		return ezOrganDAO.getSIPUriList(pCNList,eMailList);
	}

	@Override
	public String getDeptFullPath(String deptID) throws Exception {
		return ezOrganDAO.getDeptFullPath(deptID);
	}

	@Override
	public String getPropertyList(String userID,  String primary) throws Exception {
		return ezOrganDAO.getPropertyList(userID,primary);
	}
	
}
