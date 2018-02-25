package egovframework.ezEKP.ezWebFolder.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezWebFolder.dao.EzWebFolderDAO_m;
import egovframework.ezEKP.ezWebFolder.service.EzWebFolderService_m;
import egovframework.ezEKP.ezWebFolder.vo.FolderFileVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzWebFolderService_m")
public class EzWebFolderServiceimpl_m implements EzWebFolderService_m {

	private static final Logger LOGGER = LoggerFactory.getLogger(EzWebFolderServiceimpl_m.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzWebFolderDAO_m")
	private EzWebFolderDAO_m ezWebFolderDAO;

	@Override
	public List<FolderFileVO> getShares(String companyId, String deptId, String userId, String startDate, String endDate, String fileExt, String fileName, String createName, String pageSize, String pageNum, String fileType, int tenantId, String type) throws Exception {
		
		LOGGER.debug("getShares in service");
		
		Map<String, Object> map = new HashMap<String, Object>(); 
		
		map.put("companyId", companyId);
		map.put("deptId", deptId);
		map.put("userId", userId);
		map.put("startDate", startDate);
		map.put("endDate", endDate);
		map.put("fileExt", fileExt);
		map.put("fileName", fileName);
		map.put("createName", createName);
		map.put("pageSize", pageSize);
		map.put("pageNum", pageNum);
		map.put("fileType", fileType);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("map: " + map);
		
		if(type.equals("GET")) {
			return ezWebFolderDAO.getShareGet(map);
		} else {
			return ezWebFolderDAO.getShareGive(map);
		}
		
	}
	
	@Override
	public int getShareSeq(int tenantId) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		return ezWebFolderDAO.getShareSeq(map);
	}

	@Override
	public void insertShare(int seqId, String companyId, String userId,
			String userType, String folderFileId, String folderFileType,
			String createId, int tenantId) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("seqId", seqId);
		map.put("companyId", companyId);
		map.put("userId", userId);
		map.put("userType", userType);
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("createId", createId);
		map.put("tenantId", tenantId);
				
		LOGGER.debug("map: " + map);

		ezWebFolderDAO.insertShare(map);
	}

	@Override
	public void delShare(String companyId, String folderFileId, String folderFileType, String createId,
			int tenantId) throws Exception {
		
		Map<String,Object> map = new HashMap<String, Object>();

		map.put("companyId", companyId);
		map.put("folderFileId", folderFileId);
		map.put("folderFileType", folderFileType);
		map.put("createId", createId);
		map.put("tenantId", tenantId);
		
		ezWebFolderDAO.delShare(map);
		
		
	}

	public List<String> userDeptList(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = chiefDeptList(userId, tenantId);
		
		LOGGER.debug("result of chiefDeptList in userDeplist: " + result);
		
		if(result.size() >0) {
			notInDept = makeDeptString(result);
			
			LOGGER.debug("notInDept in userDeptList: " + notInDept);
			
			map.put("notInDept", notInDept);
		}
		
		temp = ezWebFolderDAO.userDeptList(map);
		result.addAll(temp);
		
		LOGGER.debug("userDeptList result: " + result);
		
		return result;
	}

	public List<String> chiefDeptPath(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		result = ezWebFolderDAO.chiefDeptPath(map);
		
		LOGGER.debug("chiefDeptPath result: " + result);
		
		return result;
	}
	
	public List<String> chiefDeptList(String userId, int tenantId)
			throws Exception {
		
		List<String> result = new ArrayList<String>();
		List<String> temp = new ArrayList<String>();
		List<String> path = new ArrayList<String>();
		Map<String,Object> map = new HashMap<String, Object>();
		String notInDept = "";
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		path = chiefDeptPath(userId, tenantId);
		
		if(path.size() >0) {
		
			for (int i = 0; i < path.size(); i++) {
				map.put("deptCdPath", path.get(i));
				map.put("notInDept", notInDept);
				
				LOGGER.debug("chiefDeptList map : " + map);
				
				temp = ezWebFolderDAO.chiefDeptList(map);
				
				LOGGER.debug("chiefDeptList temp: " + temp);
				
				if(temp.size() >0) {
					
					if(notInDept.isEmpty()) {
						notInDept = notInDept + makeDeptString(temp);
					} else {
						notInDept = notInDept + "," + makeDeptString(temp);
					}
				
				}
				
				result.addAll(temp);
			}

		}
				
		LOGGER.debug("chiefDeptList result: " + result);
		
		return result;
	}

	public String makeDeptString(List<String> deptList) {
		
		String result = "";
		
		for (int i = 0; i < deptList.size(); i++) {
			
			result = result + ",'" + deptList.get(i) + "'";
			
		}
		
		result = result.substring(1);
		
		LOGGER.debug("makeDeptString result: " + result);
		
		return result;
	}
	
}
