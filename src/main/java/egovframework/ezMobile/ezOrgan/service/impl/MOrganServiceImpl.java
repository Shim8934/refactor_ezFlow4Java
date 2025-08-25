package egovframework.ezMobile.ezOrgan.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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
public class MOrganServiceImpl extends EgovAbstractServiceImpl implements MOrganService {
	private static final Logger logger = LoggerFactory.getLogger(MOrganServiceImpl.class);
	
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
		logger.debug("getPersonList started");
		
		// oracle List Size
		int oracleListSize = 50;
		
		if (rowNum != null && !rowNum.equals("")) {
			oracleListSize += Integer.parseInt(rowNum);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText);
		map.put("rowNum", rowNum);
		map.put("listSize", 50);
		map.put("oracleListSize", oracleListSize);
		
		logger.debug("getPersonList ended");
		return mOrganDAO.getPersonList(map);
	}

	@Override
	public int getPersonListCount(String companyID, int tenantID, String pSearchText) throws Exception {
		logger.debug("getPersonListCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("pSearchText", pSearchText);

		logger.debug("getPersonListCount ended");
		return mOrganDAO.getPersonListCount(map);
	}

	@Override
	public MPersonListVO getPersonInfo(String userID, int tenantID) throws Exception {
		logger.debug("getPersonInfo started");
		return getPersonInfo(userID, tenantID, "1");
	}
	
	@Override
	public MPersonListVO getPersonInfo(String userID, int tenantID, String lang) throws Exception {
		logger.debug("getPersonInfo started lang=" + lang);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		map.put("lang", lang);

		logger.debug("getPersonInfo ended");
		
		return mOrganDAO.getPersonInfo(map);
	}

	@Override
	public List<MOrganListVO> getDeptInfo(String organType, String companyID, String deptId, String lang, int tenantId, String userSearch) throws Exception {
		logger.debug("getDeptInfo started");

		//결과 조직도 리스트
		List<MOrganListVO> resultOrganListVOs = new ArrayList<MOrganListVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		
		switch (organType) {
		case "top":
			//top일때는 deptlevel 1만 가져오기
			
			map.put("deptID", deptId);
			map.put("organType", "top");
			map.put("lang", commonUtil.getMultiData(lang, tenantId));
			map.put("tenantID", tenantId);
			map.put("useOrganHideFlag", ezCommonService.getTenantConfig("useOrganHideFlag", tenantId));
			
			resultOrganListVOs = mOrganDAO.getOrganList(map);
			break;
			/*		case "top/selected":
			String orgDeptId = deptId;
			
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
			
			break;*/
		case "company":
			map.put("deptID", deptId);
			map.put("companyID", companyID);
			map.put("organType", "company");
			map.put("lang", commonUtil.getMultiData(lang, tenantId));
			map.put("tenantID", tenantId);
			map.put("userSearch", userSearch);
			map.put("useOrganHideFlag", ezCommonService.getTenantConfig("useOrganHideFlag", tenantId));
			
			resultOrganListVOs = mOrganDAO.getOrganList(map);
			
			break;
		default:
			break;
		}
		
		logger.debug("getDeptInfo ended");
		
		return resultOrganListVOs;
	}

	@Override
	public List<MOrganListVO> getDeptMemberList(String deptID, String searchFlag, String selectType, String lang, int tenantId, String companyId, String userSearch) throws Exception {
		logger.debug("getDeptMemberList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("type", selectType);
		map.put("searchFlag", searchFlag);
		map.put("deptIDEscape", deptID.replace("%", "\\%").replace("_", "\\_"));
		map.put("deptID", deptID);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		map.put("companyId", companyId);
		map.put("userSearch", userSearch);

		if(userSearch.equals("userSearch")){
			map.put("useShowAllCompanies", "false");
		}else{
			map.put("useShowAllCompanies", "YES".equalsIgnoreCase(ezCommonService.getTenantConfig("useShowAllCompanies", tenantId)));
		}
		map.put("useOrganHideFlag", ezCommonService.getTenantConfig("useOrganHideFlag", tenantId));
		
		logger.debug("deptId : " + deptID.replace("%", "\\%").replace("_", "\\_"));
		logger.debug("lang : " + commonUtil.getMultiData(lang, tenantId));
		
		List<MOrganListVO> deptMemeberList = mOrganDAO.getDeptMemberList(map);
		List<MOrganListVO> mOrganListVOs = new ArrayList<MOrganListVO>();
		
		for(MOrganListVO organM : deptMemeberList) {
			String mType = organM.getType();
			String mDeptId = organM.getDeptID();
			
			if (mDeptId != null && mType.equalsIgnoreCase("addJobUser")){
				MOrganListVO mDeptVo = getOneDeptInfo(mDeptId, lang, tenantId);
				logger.debug("addJob :: userId= " + organM.getUserName() + " ,deptId=" + mDeptVo.getDeptID() + ",deptName=" + mDeptVo.getDeptName());
				
				organM.setDeptName(mDeptVo.getDeptName());
			}
			
			mOrganListVOs.add(organM);
		}
		
		logger.debug("getDeptMemberList ended");
		
		return mOrganListVOs;
	}

	@Override
	public List<MOrganListVO> getLowDeptInfo(String deptID, String lang, int tenantId, String userSearch) throws Exception {
		logger.debug("getLowDeptInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptID);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		map.put("userSearch", userSearch);
		map.put("useOrganHideFlag", ezCommonService.getTenantConfig("useOrganHideFlag", tenantId));

		List<MOrganListVO> resultOrganListVOs = mOrganDAO.getLowDeptInfo(map);
		
		logger.debug("getLowDeptInfo ended");
		
		return resultOrganListVOs;
	}

	@Override
	public List<MOrganListVO> getHighDeptInfo(String deptID, String deptType, String organType, String lang, String companyID, int tenantId, String userSearch) throws Exception {
		logger.debug("getHighDeptInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptID);
		map.put("deptType", deptType);
		map.put("organType", organType);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("companyID", companyID);
		map.put("tenantID", tenantId);
		map.put("userSearch", userSearch);
		map.put("useOrganHideFlag", ezCommonService.getTenantConfig("useOrganHideFlag", tenantId));
		
		List<MOrganListVO> resultOrganListVOs = mOrganDAO.getHighDeptInfo(map);

		logger.debug("getHighDeptInfo ended");
		
		return resultOrganListVOs;
	}

	@Override
	public MOrganListVO getOneDeptInfo(String deptID, String lang, int tenantId) throws Exception {
		logger.debug("getOneDeptInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptID);
		map.put("lang", commonUtil.getMultiData(lang, tenantId));
		map.put("tenantID", tenantId);
		
		MOrganListVO resultDeptVo = mOrganDAO.getOneDeptInfo(map);

		logger.debug("getOneDeptInfo ended");
		return resultDeptVo;
	}

	@Override
	public MPersonListVO getUserAddjobInfo(String userID, String deptID, String lang, int tenantId, String jobID) throws Exception {
		logger.debug("getUserAddjobInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", deptID);
		map.put("lang", lang);
		map.put("tenantID", tenantId);
		map.put("userID", userID);
		map.put("jobID", jobID);
		
		MPersonListVO resultDeptVo = mOrganDAO.getUserAddjobInfo(map);
		logger.debug("getUserAddjobInfo ended");
		return resultDeptVo;
	}	
}
