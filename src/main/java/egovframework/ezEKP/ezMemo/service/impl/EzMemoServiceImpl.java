package egovframework.ezEKP.ezMemo.service.impl;


import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezMemo.dao.EzMemoDAO;
import egovframework.ezEKP.ezMemo.service.EzMemoService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezOrgan.service.EzOrganAdminService;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzMemoService")
public class EzMemoServiceImpl implements EzMemoService {
private static final Logger logger = LoggerFactory.getLogger(EzMemoServiceImpl.class);
	
	@Resource(name="EzMemoDAO")
	private EzMemoDAO ezMemoDAO;
	
	@Resource(name = "EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Autowired
	private EzOrganAdminService ezOrganAdminService;
}
