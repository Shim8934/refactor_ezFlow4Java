package egovframework.ezEKP.ezJournal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezJournal.dao.EzJournalDAO;
import egovframework.ezEKP.ezJournal.service.EzJournalService;
import egovframework.ezEKP.ezJournal.vo.JournaltypeVO;

@Service("EzJournalService")
public class EzJournalServiceImpl implements EzJournalService{

	private static final Logger logger = LoggerFactory.getLogger(EzJournalServiceImpl.class);
	
	@Autowired
	private EzJournalDAO ezJournalDAO;
	
	@Override
	public List<JournaltypeVO> getJournaltypeList(String companyId,String tenantId) throws Exception {
		logger.debug("getJournaltypeList started");
		
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("companyId", companyId);
		param.put("tenantId", tenantId);
		
		List<JournaltypeVO> list = ezJournalDAO.getJournaltypeList(param);
		
		logger.debug("getJournaltypeList ended");
		
		return list;
	}

	@Override
	public void updateJournaltype(ArrayList<Map<String, String>> journaltypeList,String companyId, String tenantId) {
		logger.debug("updateJournaltype started");
		for (int i = 0; i < journaltypeList.size(); i++) {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("typeId", journaltypeList.get(i).get("journaltypeId"));
			param.put("used", journaltypeList.get(i).get("journalUse"));
			param.put("companyId", companyId);
			param.put("tenantId", tenantId);
			logger.debug("typeId : "+param.get("typeId"));
			logger.debug("used : "+param.get("used"));
			logger.debug("companyId : "+param.get("companyId"));
			logger.debug("tenantId : "+param.get("tenantId"));
			ezJournalDAO.updateJournaltype(param);
		}
		logger.debug("updateJournaltype ended");
	}

	@Override
	public void insertJournaltype(String companyId, String tenantId,ArrayList<JournaltypeVO> journaltypeList) {
		
	}
}
