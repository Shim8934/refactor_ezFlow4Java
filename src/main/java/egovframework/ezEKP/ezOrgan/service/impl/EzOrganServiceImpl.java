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
	public String getPropertyValue(String userid, String propName) {
		return ezOrganDAO.getPropertyValue(userid,propName);
	}

	@Override
	public String getSIPUriList(String pCNList, String eMailList) {
		return ezOrganDAO.getSIPUriList(pCNList,eMailList);
	}

}
