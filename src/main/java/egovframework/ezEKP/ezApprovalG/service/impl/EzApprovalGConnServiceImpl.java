package egovframework.ezEKP.ezApprovalG.service.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGConnDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGConnService;

@Service("EzApprovalGConnService")
public class EzApprovalGConnServiceImpl extends EgovFileMngUtil implements EzApprovalGConnService {
    private static final Logger logger = LoggerFactory.getLogger(EzApprovalGConnServiceImpl.class);
    
    @Autowired
    EzApprovalGConnDAO ezApprovalGConnDao;

}
