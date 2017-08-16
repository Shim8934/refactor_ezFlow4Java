package egovframework.ezEKP.ezTask.service.impl;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCircular.service.impl.EzCircularServiceImpl;
import egovframework.ezEKP.ezTask.dao.EzTaskDAO;
import egovframework.ezEKP.ezTask.service.EzTaskService;

@Service("EzTaskService")
public class EzTaskServiceImpl implements EzTaskService{
	
	private static final Logger logger = LoggerFactory.getLogger(EzCircularServiceImpl.class);

	@Resource(name="EzTaskDAO")
	private EzTaskDAO ezTaskDAO;
	
	/* 이효진*/
	
	/* 정수현*/
	@Override
	public String getDelayColor(String memberID, int tenantID) throws Exception {
		logger.debug("getDelayColor started.");
		
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("tenantID", tenantID);

		String _delayColor = ezTaskDAO.getDelayColor(map);

		logger.debug("_delayColor : " + _delayColor);
		logger.debug("getDelayColor ended.");
		
		return _delayColor;
	}

	@Override
	public void taskSaveConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception {
		logger.debug("taskSaveConfig started.");

		Map<String, Object> map = new HashMap<String, Object>();

		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | autoDelete : " + autoDelete);
		
		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("autoDelete", autoDelete);
		map.put("tenantID", tenantID);
		
		ezTaskDAO.taskSaveConfig(map);
		
		logger.debug("taskSaveConfig ended.");
	}

	@Override
	public void taskUpdateConfig(String memberID, String delayColor, int autoDelete, int tenantID) throws Exception {
		logger.debug("taskUpdateConfig started.");

		Map<String, Object> map = new HashMap<String, Object>();

		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | autoDelete : " + autoDelete);

		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("autoDelete", autoDelete);
		map.put("tenantID", tenantID);

		ezTaskDAO.taskUpdateConfig(map);

		logger.debug("taskUpdateConfig ended.");
	}
}
