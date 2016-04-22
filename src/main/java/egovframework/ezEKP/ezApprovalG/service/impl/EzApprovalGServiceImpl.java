package egovframework.ezEKP.ezApprovalG.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;

@Service("EzApprovalGService")
public class EzApprovalGServiceImpl implements EzApprovalGService {

	@Resource(name = "EzApprovalGDAO")
	EzApprovalGDAO ezApprovalGDAO;
	

}
