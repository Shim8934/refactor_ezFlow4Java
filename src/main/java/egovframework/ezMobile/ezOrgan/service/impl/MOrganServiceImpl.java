package egovframework.ezMobile.ezOrgan.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezMobile.ezOrgan.dao.MOrganDAO;
import egovframework.ezMobile.ezOrgan.service.MOrganService;
import egovframework.ezMobile.ezOrgan.vo.MOrganListVO;
import egovframework.ezMobile.ezOrgan.vo.MPersonListVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("MOrganService")
public class MOrganServiceImpl implements MOrganService {
	private static final Logger LOGGER = LoggerFactory.getLogger(MOrganServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "MOrganDAO")
	private MOrganDAO mOrganDAO;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;

	@Override
	public List<MPersonListVO> getPersonList(String companyID, int tenantID, String pSearchText, String rowNum) throws Exception {
		LOGGER.debug("getPersonList started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText);
		map.put("rowNum", rowNum);
		map.put("listSize", 30);

		LOGGER.debug("getPersonList ended");
		
		return mOrganDAO.getPersonList(map);
	}

	@Override
	public int getPersonListCount(String companyID, int tenantID, String pSearchText) throws Exception {
		LOGGER.debug("getPersonListCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText);
		
		LOGGER.debug("getPersonListCount ended");
		
		return mOrganDAO.getPersonListCount(map);
	}

	@Override
	public MPersonListVO getPersonInfo(String userID, int tenantID) throws Exception {
		LOGGER.debug("getPersonInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);

		LOGGER.debug("getPersonInfo ended");
		
		return mOrganDAO.getPersonInfo(map);
	}

	@Override
	public List<MOrganListVO> getDeptInfo(String deptId, String lang, int tenantId) throws Exception {
		LOGGER.debug("getDeptInfo started");

		//결과 조직도 리스트
		List<MOrganListVO> resultOrganListVOs = new ArrayList<MOrganListVO>();
		String orgDeptId = deptId;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptId);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		
		//유저부서의 하위한개만
		List<MOrganListVO> lowOrganListVOs = mOrganDAO.getLowOrganList(map);
		
		do {
			//유저와 같은레벨의 조직들
			List<MOrganListVO> sameOrganListVOs = mOrganDAO.getSameOrganList(map);
			
			int sameSize = sameOrganListVOs.size();
			
			if (sameSize > 0) {
				if (resultOrganListVOs.size() > 0) {
					for (int i = 0; i < sameSize; i++) {
						if (sameOrganListVOs.get(i).getDeptID().equals(deptId)) {
							deptId = sameOrganListVOs.get(0).getHighDeptID();
							
							map.put("deptID", deptId);
							
							sameOrganListVOs.addAll(i + 1, resultOrganListVOs);
							resultOrganListVOs.clear();
							resultOrganListVOs.addAll(sameOrganListVOs);
							
							break;
						}
					}
				} else {
					resultOrganListVOs.addAll(sameOrganListVOs);
					deptId = sameOrganListVOs.get(0).getHighDeptID();
					
					map.put("deptID", deptId);
				}
			}
		} while(deptId != null && !deptId.equals(""));

		int resultSize = resultOrganListVOs.size();
		
		for (int i = 0; i < resultSize; i++) {
			if (resultOrganListVOs.get(i).getDeptID().equals(orgDeptId)) {
				resultOrganListVOs.addAll(i + 1, lowOrganListVOs);
				
				break;
			}
		}
		
		LOGGER.debug("getDeptInfo ended");
		
		return resultOrganListVOs;
	}

	@Override
	public List<MOrganListVO> getDeptMemberList(String deptID, String searchFlag, String lang, int tenantId) throws Exception {
		LOGGER.debug("getDeptMemberList started");
		
		//single, multi
		String orgType = "multi";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", orgType);
		map.put("searchFlag", searchFlag);
		map.put("deptID", deptID);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		
		List<MOrganListVO> mOrganListVOs = mOrganDAO.getDeptMemberList(map);

		LOGGER.debug("getDeptMemberList ended");
		
		return mOrganListVOs;
	}
	
}
