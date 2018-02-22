package egovframework.ezEKP.ezWebFolder.service.impl;

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

}
