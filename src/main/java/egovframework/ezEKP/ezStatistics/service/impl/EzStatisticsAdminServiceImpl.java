package egovframework.ezEKP.ezStatistics.service.impl;

import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezEmail.util.EzEmailUtil;
import egovframework.ezEKP.ezStatistics.dao.EzStatisticsAdminDAO;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.ezEKP.ezStatistics.vo.StatConnVO;
import egovframework.ezEKP.ezStatistics.vo.StatDailyDocCountLogVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzStatisticsAdminService")
public class EzStatisticsAdminServiceImpl implements EzStatisticsAdminService {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Resource(name="EzStatisticsAdminDAO")
	private EzStatisticsAdminDAO ezStatisticsAdminDAO;
	
	private static final Logger logger = LoggerFactory.getLogger(EzStatisticsAdminServiceImpl.class);
	
	@Override
	public String getTimeList(StatApprVO statApprVO) {
		String rtnValue = "";
		
		statApprVO.setStartDate(statApprVO.getDate() + "-01-01");
		statApprVO.setEndDate(statApprVO.getDate() + "-12-31");
		
		try {
			List<StatDailyDocCountLogVO> docCountLogVOs = new ArrayList<StatDailyDocCountLogVO>();
			
			if (statApprVO.getType().equals("FORM")) {
				docCountLogVOs = ezStatisticsAdminDAO.getTimeList_F(statApprVO);
			} else if (statApprVO.getType().equals("DEPT")) {
				docCountLogVOs = ezStatisticsAdminDAO.getTimeList_D(statApprVO);
			} else if (statApprVO.getType().equals("USER")) {
				docCountLogVOs = ezStatisticsAdminDAO.getTimeList_U(statApprVO);
			}

			for (int i=0; i<docCountLogVOs.size(); i++) {
				if (docCountLogVOs.get(i).getdTime() < 0.01) {
					docCountLogVOs.get(i).setdTime((float) 0.01);
				}
			}

			StringBuffer sb = new StringBuffer();
			sb.append("<DATA>");
			
			for (int i = 0; i < docCountLogVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(docCountLogVOs.get(i)));
			}
			sb.append("</DATA>");
			
			rtnValue = sb.toString();
		} catch (Exception e) {
			logger.error("EzStatisticsAdminDAO :: getTimeList :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}

	@Override
	public String getCountList(StatApprVO statApprVO) {
		String rtnValue = "";
		
		statApprVO.setStartDate(statApprVO.getDate() + "-01-01");
		statApprVO.setEndDate(statApprVO.getDate() + "-12-31");
		
		try {
			List<StatDailyDocCountLogVO> docCountLogVOs = new ArrayList<StatDailyDocCountLogVO>();
			
			if (statApprVO.getType().equals("FORM")) {
				docCountLogVOs = ezStatisticsAdminDAO.getCountList_F(statApprVO);
			} else if (statApprVO.getType().equals("USER")) {
				docCountLogVOs = ezStatisticsAdminDAO.getCountList_U(statApprVO);
			} else if (statApprVO.getType().equals("DEPT")) {
				docCountLogVOs = ezStatisticsAdminDAO.getCountList_D(statApprVO);
			}
			
			StringBuffer sb = new StringBuffer();
			sb.append("<DATA>");
			
			for (int i = 0; i < docCountLogVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(docCountLogVOs.get(i)));
			}
			sb.append("</DATA>");
			
			rtnValue = sb.toString();
		} catch (Exception e) {
			logger.error("EzStatisticsAdminDAO :: getCountList :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}

	@Override
	public String getFormInfo(StatApprVO statApprVO) {
		String rtnValue = "";
		String subQuery = "";
		
		if (statApprVO.getDate() != null && !statApprVO.getDate().equals("")) {
			statApprVO.setStartDate(statApprVO.getDate() + "-01-01");
			statApprVO.setEndDate(statApprVO.getDate() + "-12-31");
		}
		
		try {
			if (statApprVO.getType().equals("1")) {
				subQuery = " AND (DRAFTINGCNT != 0 OR DRAFTENDCNT != 0 OR SUSININGCNT != 0 OR SUSINENDCNT != 0 OR RETURNCNT != 0) ";
			} else {
				subQuery = " AND (DRAFTTIME != 0) ";
			}
			
			if (statApprVO.getSearchList() != null && !statApprVO.getSearchList().equals("")) {
				subQuery += " AND A.FORMNAME LIKE '%" + statApprVO.getSearchList() + "%'";
			}
			
			statApprVO.setSearchList(subQuery);
			
			List<StatDailyDocCountLogVO> docCountLogVOs = ezStatisticsAdminDAO.getFormInfo(statApprVO);
			StringBuilder memberlist2 = new StringBuilder("<LISTVIEWDATA><ROWS>");
			
			for (int k = 0; k < docCountLogVOs.size(); k++) {
				memberlist2.append("<ROW><CELL><VALUE>" + docCountLogVOs.get(k).getFormInfo() + "</VALUE>");
                memberlist2.append("<DATA1>" + docCountLogVOs.get(k).getFormID() + "</DATA1></CELL></ROW>");
			}
			
			memberlist2.append("</ROWS></LISTVIEWDATA>");
			
			rtnValue = memberlist2.toString();
		} catch (Exception e) {
			logger.error("EzStatisticsAdminDAO :: getFormInfo :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}

	@Override
	public String getSearchList(StatApprVO statApprVO) {
		String rtnValue = "";
		
		try {
			List<StatDailyDocCountLogVO> docCountLogVOs = new ArrayList<StatDailyDocCountLogVO>();
			
			if (statApprVO.getType().equals("FORM")) {
				docCountLogVOs = ezStatisticsAdminDAO.getSearchList_F(statApprVO);
			} else if (statApprVO.getType().equals("DEPT")) {
				docCountLogVOs = ezStatisticsAdminDAO.getSearchList_D(statApprVO);
			} else if (statApprVO.getType().equals("USER")) {
				docCountLogVOs = ezStatisticsAdminDAO.getSearchList_U(statApprVO);
			}
			
			for (int i=0; i<docCountLogVOs.size(); i++) {
				if (docCountLogVOs.get(i).getdTime() < 0.01) {
					docCountLogVOs.get(i).setdTime((float) 0.01);
				}
			}
			
			StringBuffer sb = new StringBuffer();
			sb.append("<DATA>");
			
			for (int i = 0; i < docCountLogVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(docCountLogVOs.get(i)));
			}
			sb.append("</DATA>");
			
			rtnValue = sb.toString();
		} catch (Exception e) {
			logger.error("EzStatisticsAdminDAO :: getSearchList :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}

	@Override
	public String getMainList(StatApprVO statApprVO) {
		String rtnValue = "";
		
		statApprVO.setStartDate(statApprVO.getDate() + "-01-01");
		statApprVO.setEndDate(statApprVO.getDate() + "-12-31");
		
		try {
			List<StatDailyDocCountLogVO> docCountLogVOs = ezStatisticsAdminDAO.getMainList(statApprVO);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<DATA>");
			
			for (int i = 0; i < docCountLogVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(docCountLogVOs.get(i)));
			}
			sb.append("</DATA>");
			
			rtnValue = sb.toString();
		} catch (Exception e) {
			logger.error("EzStatisticsAdminDAO :: getMainList :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}

	@Override
	public void dailyDocCountLog(StatApprVO statApprVO) throws Exception {
		logger.debug("dailyDocCountLog started");

		ezStatisticsAdminDAO.deleteDailyDocCountLog(statApprVO);
		ezStatisticsAdminDAO.insertDailyDocCountLog(statApprVO);

		logger.debug("dailyDocCountLog ended");
	}

	@Override
	public void dailyFormCountLog(StatApprVO statApprVO) throws Exception {
		logger.debug("dailyFormCountLog started");

		ezStatisticsAdminDAO.deleteDailyFormCountLog(statApprVO);
		ezStatisticsAdminDAO.insertDailyFormCountLog(statApprVO);

		logger.debug("dailyFormCountLog ended");
		
	}

	@Override
	public String getConnInfo(StatApprVO statApprVO) {
		
		statApprVO.setOffSet(statApprVO.getOffSet().substring(6,7));
		
		String rtnValue = "";
		
		StringBuffer sb = new StringBuffer();
		sb.append("<DATA>");
		try {
			List<StatConnVO> statConnVOs = ezStatisticsAdminDAO.getConnInfo(statApprVO);
			for (int i = 0; i < statConnVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(statConnVOs.get(i)));
			}
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		sb.append("</DATA>");
		
		rtnValue=sb.toString();
		
		return rtnValue;
	}

	@Override
	public String getStatConnBrowser(StatApprVO statApprVO) {
		String rtnValue = "";
		
		StringBuffer sb = new StringBuffer();
		sb.append("<DATA>");
		try {
			List<StatConnVO> connVo = ezStatisticsAdminDAO.getConnBrowser(statApprVO);
			for (int i = 0; i < connVo.size(); i++) {
				sb.append(commonUtil.getQueryResult(connVo.get(i)));
			}
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		sb.append("</DATA>");
		
		rtnValue=sb.toString();
		
		return rtnValue;
	}
	
	@Override
	public String getStatConnOS(StatApprVO statApprVO) throws Exception {
		String rtnValue = "";
		StringBuffer sb = new StringBuffer();
		
		List<StatConnVO> list = ezStatisticsAdminDAO.getConnOS(statApprVO);
		
		sb.append("<DATA>");
		
		for (StatConnVO vo : list) {
			sb.append(commonUtil.getQueryResult(vo));
		}
		
		sb.append("</DATA>");
		
		rtnValue=sb.toString();
		
		return rtnValue;
	}

	@Override
	public Map<String, Object> getMailLogList(String tenantId, String pageNo, String pageSize, String mailLogType, String searchStartTime,
			String searchEndTime, String searchField, String searchValue, String isPrimaryLang) throws Exception {
		logger.debug("getMailLogList started.");
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> mailLogList = new ArrayList<Map<String,Object>>();
		int totalCount = 0;
		String resultCode = "ERROR";
		
		String tenantIdParam = "tenantId=" + tenantId;
		String pageNoParam = "pageNo=" + pageNo;
		String pageSizeParam = "pageSize=" + pageSize;
		String mailLogTypeParam = "mailLogType=" + mailLogType;
		String searchStartTimeParam = "searchStartTime=" + searchStartTime;
		String searchEndTimeParam = "searchEndTime=" + searchEndTime;
		String searchFieldParam = "searchField=" + searchField;
		String searchValueParam = "searchValue=" + URLEncoder.encode(searchValue, "UTF-8");
		String isPrimaryLangParam = "isPrimaryLang=" + isPrimaryLang;
		
		String inputParams = tenantIdParam + "&" + pageNoParam + "&" + pageSizeParam + "&" + mailLogTypeParam + "&" +
							 searchStartTimeParam + "&" + searchEndTimeParam + "&" + searchFieldParam + "&" +
							 searchValueParam + "&" + isPrimaryLangParam ;
		logger.debug("inputParmas=" + inputParams);
		
		String requestURL = config.getProperty("config.JGwServerURL") + "/ezEmailAccess/getMailLogList";
		String response = ezEmailUtil.getWebServiceResult(requestURL, inputParams); 
		//logger.debug("response=" + response);		
		
		if (response != null) {
			JSONParser jsonParser = new JSONParser();
			JSONObject responseObj = (JSONObject) jsonParser.parse(response);
			
			if (responseObj.get("resultCode").equals("OK") && ((Long)responseObj.get("reasonCode")).intValue() == 0) {
				JSONObject resultObj = (JSONObject) responseObj.get("result");
				totalCount = ((Long)resultObj.get("totalCount")).intValue(); 
					
				JSONArray jsonArr = (JSONArray) resultObj.get("mailLogList");
					
				for (int i = 0; i < jsonArr.size(); i++) {
					JSONObject obj = (JSONObject) jsonArr.get(i);
					
					Map<String, Object> map = new HashMap<String, Object>();
					
					String logTime = (String) obj.get("LogTime");
					logTime = logTime.substring(0, 19);
					
					SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date dbDate = format.parse(logTime);
					String dateStr = "";
					
					if (isPrimaryLang.equals("1")) {
						SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd a hh:mm:ss");
						dateStr = newFormat.format(dbDate);
					} else {
						SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd a hh:mm:ss", new Locale("en","US"));
						dateStr = newFormat.format(dbDate);
					}
					
					map.put("LogTime", dateStr);
					map.put("senderName", obj.get("senderName"));
					map.put("senderEmail", obj.get("senderEmail"));
					map.put("senderDeptName", obj.get("senderDeptName"));
					map.put("recipientName", obj.get("recipientName"));
					map.put("recipientEmail", obj.get("recipientEmail"));
					map.put("recipientDeptName", obj.get("recipientDeptName"));
					map.put("attachedFileName", obj.get("attachedFileName"));
					map.put("subject", obj.get("subject"));
					map.put("mailSize", obj.get("mailSize"));
					
					mailLogList.add(map);
					
				}
				
				resultCode = "OK";
			}
		}

		resultMap.put("totalCount", totalCount);
		resultMap.put("mailLogList", mailLogList);
		
		logger.debug("getMailLogList ended. resultCode=" + resultCode);
		
		return resultMap;
	}
}
