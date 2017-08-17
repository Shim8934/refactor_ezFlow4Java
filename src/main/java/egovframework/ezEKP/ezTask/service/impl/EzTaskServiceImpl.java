package egovframework.ezEKP.ezTask.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezTask.dao.EzTaskDAO;
import egovframework.ezEKP.ezTask.service.EzTaskService;
import egovframework.ezEKP.ezTask.vo.TaskCommentVO;
import egovframework.ezEKP.ezTask.vo.TaskInfoVO;
import egovframework.ezEKP.ezTask.vo.TaskShareVO;
import egovframework.let.user.login.vo.LoginVO;
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
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
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
	
	@Override
	public List<TaskCommentVO> getCommentList(String taskID, String offset, String primary, int tenantID) throws Exception {
		logger.debug("getCommentList started.");
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		List<TaskCommentVO> list = ezTaskDAO.getCommentList(map);
		
		logger.debug("getCommentList ended.");
		logger.debug("listSize = " + list.size());
		
		return list;
	}
	
	@Override
	public List<TaskShareVO> getShareList(String taskID, String offset, String primary, int tenantID) throws Exception {
		//TaskShareVO 내부에 completeDate 있어서 우선 offset 가져오긴하는데 completeDate 사용안할시 VO에서 삭제 및 offset파라미터 제거. 이효진
		logger.debug("getShareList started.");
		logger.debug("taskID = " + taskID + " || offset = " + offset + " || primary = " + primary + " || tenantID = " + tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("taskID", taskID);
		map.put("offset", commonUtil.getMinuteUTC(offset));
		map.put("primary", primary);
		map.put("tenantID", tenantID);
		
		List<TaskShareVO> list = ezTaskDAO.getShareList(map);
		
		logger.debug("getShareList ended.");
		logger.debug("listSize = " + list.size());
		
		return list;
	}
	

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
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | autoDelete : " + autoDelete);

		Map<String, Object> map = new HashMap<String, Object>();
		
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
		logger.debug("memberID : " + memberID + " | delayColor : " + delayColor + " | autoDelete : " + autoDelete);

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("memberID", memberID);
		map.put("delayColor", delayColor);
		map.put("autoDelete", autoDelete);
		map.put("tenantID", tenantID);

		ezTaskDAO.taskUpdateConfig(map);

		logger.debug("taskUpdateConfig ended.");
	}

	@Override
	public String taskSave(Document doc, String realPath, LoginVO userInfo) throws Exception {
		logger.debug("taskSave started.");
		
		TaskInfoVO taskInfoVO = new TaskInfoVO();
		
		taskInfoVO.setOwnerID(doc.getElementsByTagName("OWNERID").item(0).getTextContent());
		taskInfoVO.setCreatorID(doc.getElementsByTagName("CREATORID").item(0).getTextContent());
		taskInfoVO.setCreatorName(doc.getElementsByTagName("CREATORNAME1").item(0).getTextContent());
		taskInfoVO.setCreatorName2(doc.getElementsByTagName("CREATORNAME2").item(0).getTextContent());
		taskInfoVO.setHasShare(doc.getElementsByTagName("HASSHARE").item(0).getTextContent());
		taskInfoVO.setHasAttach(doc.getElementsByTagName("HASATTACH").item(0).getTextContent());
		taskInfoVO.setTaskStatus(Integer.parseInt(doc.getElementsByTagName("TASKSTATUS").item(0).getTextContent()));
		taskInfoVO.setImportance(Integer.parseInt(doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent()));
		taskInfoVO.setStartDate(doc.getElementsByTagName("STARTDATE").item(0).getTextContent());
		taskInfoVO.setEndDate(doc.getElementsByTagName("ENDDATE").item(0).getTextContent());
		taskInfoVO.setTitle(doc.getElementsByTagName("TITLE").item(0).getTextContent());
		taskInfoVO.setContentPath(commonUtil.getUploadPath("upload_task.ROOT", userInfo.getTenantId()) + commonUtil.separator + userInfo.getTenantId() + commonUtil.separator + "{" + doc.getElementsByTagName("CONTENTPATH").item(0).getTextContent() + "}" + ".mht");
		taskInfoVO.setTaskType(doc.getElementsByTagName("TASKTYPE").item(0).getTextContent());
		taskInfoVO.setUpdateTime(commonUtil.getTodayUTCTime(""));
		taskInfoVO.setNewAnswer("N");
		taskInfoVO.setNewRefer("N");
		taskInfoVO.setPersonID(doc.getElementsByTagName("PERSONID").item(0).getTextContent());
		taskInfoVO.setPersonName(doc.getElementsByTagName("PERSONNAME1").item(0).getTextContent());
		taskInfoVO.setPersonName2(doc.getElementsByTagName("PERSONNAME2").item(0).getTextContent());
		taskInfoVO.setPersonDeptName(doc.getElementsByTagName("PERSONDEPTNAME1").item(0).getTextContent());
		taskInfoVO.setPersonDeptName2(doc.getElementsByTagName("PERSONDEPTNAME2").item(0).getTextContent());
		taskInfoVO.setTaskPersonID(doc.getElementsByTagName("CREATORID").item(0).getTextContent());
		taskInfoVO.setTaskPersonName(doc.getElementsByTagName("CREATORNAME1").item(0).getTextContent());
		taskInfoVO.setTaskPersonName2(doc.getElementsByTagName("CREATORNAME2").item(0).getTextContent());
		taskInfoVO.setTenantID(userInfo.getTenantId());

		int shareLength = Integer.parseInt(doc.getElementsByTagName("SHARELENGTH").item(0).getTextContent());

		logger.debug("OwnerID : " + taskInfoVO.getOwnerID() + " | CreatorName : " + taskInfoVO.getCreatorName() + " | HasShare : " + taskInfoVO.getHasShare() + " | TaskStatus : " + taskInfoVO.getTaskStatus() + " | Importance : " + taskInfoVO.getImportance() + " | ContentPath : " + taskInfoVO.getContentPath());
		logger.debug("HasAttach : " + taskInfoVO.getHasAttach() + " | StartDate : " + taskInfoVO.getStartDate() + " | EndDate : " + taskInfoVO.getEndDate() + " | Title : " + taskInfoVO.getTitle() + " | TaskType : " + taskInfoVO.getTaskType() + " | PersonID : " + taskInfoVO.getPersonID() + " | TaskPersonID : " + taskInfoVO.getTaskPersonID());

		String taskID = ezTaskDAO.taskSave(taskInfoVO);
		
		logger.debug("taskID : " + taskID);

		taskInfoVO.setTaskID(taskID);
		
		for (int i=0; i<shareLength; i++) {
			String shareID = doc.getElementsByTagName("SHAREID").item(i).getTextContent();
			String shareName1 = doc.getElementsByTagName("SHARENAME1").item(i).getTextContent();
			String shareName2 = doc.getElementsByTagName("SHARENAME2").item(i).getTextContent();
			String shareDeptName1 = doc.getElementsByTagName("SHAREDEPTNAME1").item(i).getTextContent();
			String shareDeptName2 = doc.getElementsByTagName("SHAREDEPTNAME2").item(i).getTextContent();

			taskInfoVO.setOwnerID(shareID);
			taskInfoVO.setPersonID(shareID);
			taskInfoVO.setPersonName(shareName1);
			taskInfoVO.setPersonName2(shareName2);
			taskInfoVO.setPersonDeptName(shareDeptName1);
			taskInfoVO.setPersonDeptName2(shareDeptName2);
			
			ezTaskDAO.shareTaskSave(taskInfoVO);			
		}

		logger.debug("taskSave ended.");

		return "OK";
	}

//	@Override
//	public void taskSave(LoginVO userInfo, String regDate, int taskStatus, int importance, String fileList, String title, int taskType, 
//			String sdate, String edate, String[] shareID, String[] shareName, String[] shareName2, String[] shareDepts, String[] shareDepts2) throws Exception {
//		logger.debug("taskSave started.");
//		logger.debug("taskStatus : " + taskStatus + " | importance : " + importance + " | title : " + title + " | taskType : " + taskType);
//
//		String hasShare = "";
//		String hasAttach = "";
//
//		if (shareID.length > 0) {
//			hasShare = "Y";
//		} else {
//			hasShare = "N";
//		}
//
//		if (fileList.split(",").length > 0) {
//			hasAttach = "Y";
//		} else {
//			hasAttach = "N";
//		}
//		
//		Map<String, Object> map = new HashMap<String, Object>();
//
//		map.put("ownerID", userInfo.getId());
//		map.put("ownerName", userInfo.getDisplayName());
//		map.put("ownerName2", userInfo.getDisplayName1());
//		map.put("regDate", regDate);
//		map.put("taskStatus", taskStatus);
//		map.put("importance", importance);
//		map.put("hasShare", hasShare);
//		map.put("hasAttach", hasAttach);
//		map.put("sdate", sdate);
//		map.put("edate", edate);
//		map.put("title", title);
//		map.put("taskType", taskType);
//		map.put("personDeptName", userInfo.getDeptName());
//		map.put("personDeptName2", userInfo.getDeptName2());
//		map.put("tenantID", userInfo.getTenantId());
//
//		int taskID = ezTaskDAO.taskSave(map);
//
//		if (hasShare.equals("Y")) {
//			map.put("taskID", taskID);
//
//			for (int i=0; i<shareID.length; i++) {
//				map.put("shareID", shareID[i].trim());
//				map.put("shareName", shareName[i].trim());
//				map.put("shareName2", shareName2[i].trim());
//				map.put("shareDept", shareDepts[i].trim());
//				map.put("shareDept2", shareDepts2[i].trim());
//
//				ezTaskDAO.shareTaskSave(map);
//			}
//		}
//
//		logger.debug("taskSave ended.");
//	}
}
