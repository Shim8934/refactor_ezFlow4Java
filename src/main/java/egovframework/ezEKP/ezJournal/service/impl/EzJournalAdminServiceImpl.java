package egovframework.ezEKP.ezJournal.service.impl;

import java.util.ArrayList;
import java.util.Properties;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezJournal.dao.EzJournalAdminDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalAdminService;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzJournalAdminService")
public class EzJournalAdminServiceImpl implements EzJournalAdminService{

	private static final Logger logger = LoggerFactory.getLogger(EzJournalAdminServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Autowired
	private Properties globals;
	
	@Autowired
	private EzJournalAdminDAO ezJournalAdminDAO;
	
	@Override
	public ArrayList<JournaltypeVO> getJournaltypeList(String companyId,
			int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String updateJournaltype(ArrayList<JournaltypeVO> journaltypeList,
			String companyId, int tenantId) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String insertJournaltype(String companyId, int tenantId,
			ArrayList<JournaltypeVO> journaltypeList) {
		// TODO Auto-generated method stub
		return null;
	}

}
