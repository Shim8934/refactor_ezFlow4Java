package egovframework.ezEKP.ezTask.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezTask.dao.EzTaskDAO;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzTaskService")
public class EzTaskServiceImpl implements EzTaskService{
	private static final Logger logger = LoggerFactory.getLogger(EzTaskServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzTaskDAO ezTaskDAO;
	
	/* 이효진*/
	@Override
	public TaskInfoVO getTaskInfo(String taskID, String offset, String primary, int tenantID) throws Exception {
		logger.debug("getTaskInfo started.");
		logger.debug("taskID = " + taskID + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		TaskInfoVO vo = ezTaskDAO.getTaskInfo(map);
		
		logger.debug("getTaskInfo ended.");
		logger.debug(vo.toString());
		
		return vo;
	}
	
	/* 정수현*/
}
