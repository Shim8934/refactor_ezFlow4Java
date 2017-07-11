package egovframework.ezEKP.ezSystem.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezSystem.dao.EzSystemAdminDAO;
import egovframework.ezEKP.ezSystem.service.EzSystemAdminService;
import egovframework.ezEKP.ezSystem.vo.CheckName;
import egovframework.ezEKP.ezSystem.vo.ConnectionInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysParamVO;

@Service("EzSystemAdminService")
public class EzSystemAdminServiceImpl implements EzSystemAdminService {
	
	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	
	@Resource(name="EzSystemAdminDAO")
	EzSystemAdminDAO ezSystemAdminDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public List<SysParamVO> getSysParam(int tenantID) throws Exception {	
		logger.debug("getSysParam started. tenantID=" + tenantID);
		
		List<SysParamVO> list = ezSystemAdminDAO.getSysParam(tenantID);
		List<SysParamVO> afterList = new ArrayList<SysParamVO>();
		
		for (int i = 0; i < list.size(); i++) {
			try {
				CheckName.valueOf(list.get(i).getName());
				afterList.add(list.get(i));
			} catch (IllegalArgumentException e){}
		}

		logger.debug("getSysParam ended");
		
		return afterList;
	}

	@Override
	public void updateSysParam(int tenantID, List<Map<String, String>> list, Locale locale) throws Exception {
		logger.debug("updateSysParam started. tenantID=" + tenantID);
		
		SysParamVO sysParamVO = new SysParamVO();
		sysParamVO.setTenantID(tenantID);		
		
		for (int i = 0; i < list.size(); i++) {					
			String paramName = list.get(i).get("name");
			String paramValue = list.get(i).get("value");
			
			sysParamVO.setName(paramName);
			sysParamVO.setValue(paramValue);
			
			ezSystemAdminDAO.updateSysParam(sysParamVO);
			
			if (paramName.equals("MailAttachLimit")) {
				sysParamVO.setName("BigSizeMailAttachLimit");
				sysParamVO.setValue(paramValue);				
				ezSystemAdminDAO.updateSysParam(sysParamVO);				
			} else if (paramName.equals("PrimaryLang")) {
				if (paramValue.equals("1")) {
					sysParamVO.setName("LangPrimary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
										
					sysParamVO.setName("LangPrimary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.korean4", locale));			
					ezSystemAdminDAO.updateSysParam(sysParamVO);
					
					sysParamVO.setName("LangSecondary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);	
					
					sysParamVO.setName("LangSecondary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english4", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);															
				} else if (paramValue.equals("3")) {
					sysParamVO.setName("LangPrimary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
										
					sysParamVO.setName("LangPrimary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);					
					
					sysParamVO.setName("LangPrimary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.japanese4", locale));			
					ezSystemAdminDAO.updateSysParam(sysParamVO);
					
					sysParamVO.setName("LangSecondary1");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english1", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);	
					
					sysParamVO.setName("LangSecondary2");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english2", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary3");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english3", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);										

					sysParamVO.setName("LangSecondary4");
					sysParamVO.setValue(egovMessageSource.getMessage("ezSystem.english4", locale));
					ezSystemAdminDAO.updateSysParam(sysParamVO);															
				}				
			}
		}
		
		logger.debug("updateSysParam ended");
	}

	@Override
	public List<ConnectionInfoVO> getLoginHist(int tenantID, String offset, int startPage, int maxItemPerPage, String keycode, 
			String keyword, String lang, String startDate, String endDate) throws Exception {

		logger.debug("getLoginHist started. tenantID : " + tenantID);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("v_start", startPage);
		params.put("pageCount", maxItemPerPage);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
		
		List<ConnectionInfoVO> list = ezSystemAdminDAO.getLoginHist(params);
		
		logger.debug("getLoginHist ended.");
		
		return list;
	}

	@Override
	public int getLoginHistCount(int tenantID, String offset, String keycode, String keyword, String lang, String startDate, String endDate) throws Exception {
		
		logger.debug("getLoginHistCount started. tenantID : " + tenantID);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("v_tenantID", tenantID);
		params.put("offset", offset);
		params.put("search_keycode", keycode);
		params.put("search_keyword", keyword);
		params.put("lang", lang);
		params.put("startDate", startDate);
		params.put("endDate", endDate);
				
		logger.debug("getLoginHistCount ended.");
		
		return ezSystemAdminDAO.getLoginHistCount(params);
	}

}
