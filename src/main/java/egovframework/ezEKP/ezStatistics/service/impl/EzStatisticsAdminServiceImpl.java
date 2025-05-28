package egovframework.ezEKP.ezStatistics.service.impl;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.Month;
import java.time.Year;
import java.time.YearMonth;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import javax.annotation.Nullable;
import javax.annotation.Resource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezStatistics.vo.StatChartVO;
import egovframework.ezEKP.ezStatistics.vo.StatChartVO.Dataset;
import egovframework.ezEKP.ezStatistics.vo.StatisticVO;
import egovframework.let.user.login.vo.LoginVO;
import org.apache.commons.lang3.StringUtils;
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
import egovframework.let.utl.fcc.service.CommonUtil;

import static egovframework.ezEKP.ezStatistics.vo.StatisticVO.Code.ACCESS;

@Service("EzStatisticsAdminService")
public class EzStatisticsAdminServiceImpl implements EzStatisticsAdminService {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzEmailUtil ezEmailUtil;
	
	@Autowired
	private EzNewPortalService ezNewPortalService;
	
	@Autowired
	private EgovMessageSource egovMessageSource;
	
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
		
		if (statApprVO.getDate() != null && !statApprVO.getDate().equals("")) {
			statApprVO.setStartDate(statApprVO.getDate() + "-01-01");
			statApprVO.setEndDate(statApprVO.getDate() + "-12-31");
		}
		
		/* 2024-07-05 홍승비 - SQL Injection 수정 > 검색 조건은 문자열로 전달하지 않고 쿼리 내부에서 분기처리하도록 수정 */
		try {
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
			logger.error(e.getMessage(), e);
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
			logger.error(e.getMessage(), e);
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
			String searchEndTime, String searchField, String searchValue, String isPrimaryLang, String companyId) throws Exception {
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
		String companyIdParam = "companyId=" + companyId;
		
		String inputParams = tenantIdParam + "&" + pageNoParam + "&" + pageSizeParam + "&" + mailLogTypeParam + "&" +
							 searchStartTimeParam + "&" + searchEndTimeParam + "&" + searchFieldParam + "&" +
							 searchValueParam + "&" + isPrimaryLangParam + "&" + companyIdParam;
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
						SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						dateStr = newFormat.format(dbDate);
					} else {
						SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", new Locale("en","US"));
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
					// 2020-09-04 김은실-(빗썸코리아)메일삭제를 위한 messageId 추가
					map.put("messageId", obj.get("messageId"));
					map.put("isNullInSearchId", obj.get("isNullInSearchId"));
					map.put("isBlocked", obj.get("isBlocked"));
					
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
	@Override
	public void customApprStatisticsBatch() throws Exception {
		logger.debug("customApprStatisticsBatch started");
		
		ezStatisticsAdminDAO.deleteCustomDocBatch();
		ezStatisticsAdminDAO.insertCustomDocBatch();
		
		ezStatisticsAdminDAO.deleteCustomFormBatch();
		ezStatisticsAdminDAO.insertCustomFormBatch();
		
		logger.debug("customApprStatisticsBatch ended");
		
		
	}

	@Override
	public void yearlyDocCount(StatApprVO statApprVO) throws Exception {
		logger.debug("yearlyDocCount started");

		ezStatisticsAdminDAO.deleteYearlyDocCount(statApprVO);
		ezStatisticsAdminDAO.insertYearlyDocCount(statApprVO);

		logger.debug("yearlyDocCount ended");
	}

	// 2021-02-23 박기범-chartportlet
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getYearlyDocCount(int tenantID, String companyID) {
		logger.debug("getYearlyDocCount started");

		JSONObject result = new JSONObject();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", tenantID);
		map.put("companyID", "Top");	// data에 Top일괄적으로 들어가므로 임시적으로 top해놓음

		try {
			List<HashMap<String, Object>> statisticsList = ezStatisticsAdminDAO.getYearlyDocCount(map);

			if (statisticsList.size() > 0) {
				result.put("result", "true");

				for (HashMap<String, Object> item : statisticsList) {
					result.put(item.get("DOC_TYPE").toString() + ":" + item.get("MONTH_TYPE").toString(), item.get("DOC_COUNT"));
				}
			} else {
				result.put("result", "false");
			}

		} catch (Exception e) {
			result.put("result", "error");
			logger.error(e.getMessage(), e);
		}

		logger.debug("getYearlyDocCount ended/result : " + result.get("result").toString());
		return result;
	}

	@Override
	public void collectAccessEvent(StatisticVO statisticVO) {
		try {
			statisticVO.setCode(ACCESS);
			statisticVO.setTimeNow();
			ezStatisticsAdminDAO.upsertStatMenuUser(statisticVO);
			ezStatisticsAdminDAO.upsertStatMenuUserMonth(statisticVO);
			if (StringUtils.isNotBlank(statisticVO.getDeptId())) {
				ezStatisticsAdminDAO.upsertStatMenuDept(statisticVO);
				ezStatisticsAdminDAO.upsertStatMenuDeptMonth(statisticVO);
			}
		} catch (RuntimeException e) {
			logger.error(e.getMessage(), e);
		}
	}

	@Override
	public StatChartVO getStatMenuUserMonthly(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, @Nullable String menuId) throws Exception {
		logger.info("getStatMenuUserMonthly start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> monthList = CommonUtil.getMonthList(userInfo.getLocale(), TextStyle.SHORT);
		chartData.setLabels(monthList);
		
		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("userId", targetUserId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + "01");
		map.put("endTime", year.getValue() + "13");

		
		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuUserMonth(map);
		List<Dataset> datasets = new ArrayList<>();
		
		String label = StringUtils.isBlank(menuId) ? egovMessageSource.getMessage("ezStatistics.pgb01", userInfo.getLocale()) : menuNames.get(Integer.parseInt(menuId));
		
		List<Integer> data = IntStream.rangeClosed(1, 12).boxed()
				.map(month -> statMenuUser.stream()
						.filter(m -> menuNames.containsKey(m.getMenuId()) 
								&& (StringUtils.isBlank(menuId) || m.getMenuId() == Integer.parseInt(menuId)))
						.collect(Collectors.groupingBy(
								StatisticVO::getMonth,
								Collectors.summingInt(StatisticVO::getStatCount)
						)).getOrDefault(month, 0))
				.collect(Collectors.toList());
		datasets.add(new Dataset(label, data, "bar"));
		
		if (!StringUtils.isBlank(menuId)) {
			List<Double> listAvg = IntStream.rangeClosed(1, 12).boxed()
					.map(month -> statMenuUser.stream()
							.filter(m -> menuNames.containsKey(m.getMenuId()))
							.collect(Collectors.groupingBy(
									StatisticVO::getMonth,
									Collectors.summingDouble(StatisticVO::getStatCount)))
							.getOrDefault(month, 0D))
					.map(sum -> new BigDecimal(new BigDecimal(sum / menuNames.size()).setScale(2, RoundingMode.HALF_UP).doubleValue()).setScale(2, RoundingMode.HALF_UP).doubleValue())
					.collect(Collectors.toList());
			datasets.add(new Dataset(egovMessageSource.getMessage("ezStatistics.pgb03", userInfo.getLocale()), listAvg,"line"));
		}
		
		chartData.setDatasets(datasets);

		logger.info("getStatMenuUserMonthly ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuUserDaily(LoginVO userInfo, String targetCompanyId, String targetUserId,
											Year year, Month month, @Nullable String menuId) throws Exception {
		logger.info("getStatMenuUserDaily start");
		
		StatChartVO chartData = new StatChartVO();
		int monthLength = YearMonth.of(year.getValue(), month).lengthOfMonth();
		List<Integer> dayList = IntStream.rangeClosed(1, monthLength).boxed().collect(Collectors.toList());
		chartData.setLabels(dayList);

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("userId", targetUserId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + "0100");
		map.put("endTime", year.getValue() + String.format("%02d",month.getValue()) + "3200");
		
		if (!StringUtils.isBlank(menuId)) {
			map.put("menuId", menuId);
		}
		
		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);
		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuUserDay(map);
		List<Dataset> datasets = new ArrayList<>();
		String label = StringUtils.isBlank(menuId) ? egovMessageSource.getMessage("ezStatistics.pgb01", userInfo.getLocale()) : menuNames.get(Integer.parseInt(menuId));

		List<Integer> data = dayList.stream()
				.map(day -> statMenuUser.stream()
						.filter(m -> menuNames.containsKey(m.getMenuId())
								&& (StringUtils.isBlank(menuId) || m.getMenuId() == Integer.parseInt(menuId)))
						.collect(Collectors.groupingBy(
								StatisticVO::getDay,
								Collectors.summingInt(StatisticVO::getStatCount)
						)).getOrDefault(day, 0))
				.collect(Collectors.toList());
		datasets.add(new Dataset(label, data, "bar"));

		if (!StringUtils.isBlank(menuId)) {
			List<Double> listAvg = dayList.stream().parallel()
					.map(day -> statMenuUser.stream().parallel()
							.filter(m -> menuNames.containsKey(m.getMenuId()))
							.collect(Collectors.groupingBy(
									StatisticVO::getDay,
									Collectors.summingDouble(StatisticVO::getStatCount)
							)).getOrDefault(day, 0D))
					.map(sum -> new BigDecimal(sum / menuNames.size()).setScale(2, RoundingMode.HALF_UP).doubleValue())
					.collect(Collectors.toList());
			datasets.add(new Dataset(egovMessageSource.getMessage("ezStatistics.pgb03", userInfo.getLocale()), listAvg,"line"));
		}

		chartData.setDatasets(datasets);

		logger.info("getStatMenuUserDaily ended");
		return chartData;
	}
	
	@Override
	public StatChartVO getStatMenuUserHourly(LoginVO userInfo, String targetCompanyId, String targetUserId,
									  Year year, Month month, int day, @Nullable String menuId) throws Exception {
		logger.info("getStatMenuUserHourly start");
		
		StatChartVO chartData = new StatChartVO();
		List<Integer> hourList = IntStream.rangeClosed(0, 23).boxed().collect(Collectors.toList());
		
		chartData.setLabels(hourList.stream()
				.map(h -> h + "~" + (h + 1))
				.collect(Collectors.toList()));

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("userId", targetUserId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + String.format("%02d",day) + "00");
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()) + String.format("%02d",day) + "25");

		if (!StringUtils.isBlank(menuId)) {
			map.put("menuId", menuId);
		}

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);
		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuUser(map);
		List<Dataset> datasets = new ArrayList<>();
		String label = StringUtils.isBlank(menuId) ? egovMessageSource.getMessage("ezStatistics.pgb01", userInfo.getLocale()) : menuNames.get(Integer.parseInt(menuId));

		List<Integer> data = hourList.stream()
				.map(h -> statMenuUser.stream()
						.filter(m -> menuNames.containsKey(m.getMenuId())
								&& (StringUtils.isBlank(menuId) || m.getMenuId() == Integer.parseInt(menuId)))
						.collect(Collectors.groupingBy(
								StatisticVO::getHour,
								Collectors.summingInt(StatisticVO::getStatCount)
						)).getOrDefault(h, 0))
				.collect(Collectors.toList());
		datasets.add(new Dataset(label, data, "bar"));

		if (!StringUtils.isBlank(menuId)) {
			List<Double> listAvg = hourList.stream().parallel()
					.map(h -> statMenuUser.stream().parallel()
							.filter(m -> menuNames.containsKey(m.getMenuId()))
							.collect(Collectors.groupingBy(
									StatisticVO::getHour,
									Collectors.summingDouble(StatisticVO::getStatCount)
							)).getOrDefault(h, 0D))
					.map(sum -> new BigDecimal(sum / menuNames.size()).setScale(2, RoundingMode.HALF_UP).doubleValue())
					.collect(Collectors.toList());
			datasets.add(new Dataset(egovMessageSource.getMessage("ezStatistics.pgb03", userInfo.getLocale()), listAvg,"line"));
		}

		chartData.setDatasets(datasets);

		logger.info("getStatMenuUserHourly ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuDeptMonthly(LoginVO userInfo, String targetCompanyId, String targetDeptId, Year year, @Nullable String menuId) throws Exception {
		logger.info("getStatMenuDeptMonthly start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> monthList = CommonUtil.getMonthList(userInfo.getLocale(), TextStyle.SHORT);
		chartData.setLabels(monthList);

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", targetDeptId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + "01");
		map.put("endTime", year.getValue() + "13");


		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuDeptMonth(map);
		List<Dataset> datasets = new ArrayList<>();

		String label = StringUtils.isBlank(menuId) ? egovMessageSource.getMessage("ezStatistics.pgb01", userInfo.getLocale()) : menuNames.get(Integer.parseInt(menuId));

		List<Integer> data = IntStream.rangeClosed(1, 12).boxed()
				.map(month -> statMenuUser.stream()
						.filter(m -> menuNames.containsKey(m.getMenuId())
								&& (StringUtils.isBlank(menuId) || m.getMenuId() == Integer.parseInt(menuId)))
						.collect(Collectors.groupingBy(
								StatisticVO::getMonth,
								Collectors.summingInt(StatisticVO::getStatCount)
						)).getOrDefault(month, 0))
				.collect(Collectors.toList());
		datasets.add(new Dataset(label, data, "bar"));

		if (!StringUtils.isBlank(menuId)) {
			List<Double> listAvg = IntStream.rangeClosed(1, 12).boxed()
					.map(month -> statMenuUser.stream()
							.filter(m -> menuNames.containsKey(m.getMenuId()))
							.collect(Collectors.groupingBy(
									StatisticVO::getMonth,
									Collectors.summingDouble(StatisticVO::getStatCount)
							)).getOrDefault(month, 0D))
					.map(sum -> new BigDecimal(sum / menuNames.size()).setScale(2, RoundingMode.HALF_UP).doubleValue())
					.collect(Collectors.toList());
			datasets.add(new Dataset(egovMessageSource.getMessage("ezStatistics.pgb03", userInfo.getLocale()), listAvg,"line"));
		}

		chartData.setDatasets(datasets);

		logger.info("getStatMenuDeptMonthly ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuDeptDaily(LoginVO userInfo, String targetCompanyId, String targetDeptId,
											Year year, Month month, @Nullable String menuId) throws Exception {
		logger.info("getStatMenuDeptDaily start");
		
		StatChartVO chartData = new StatChartVO();
		int monthLength = YearMonth.of(year.getValue(), month).lengthOfMonth();
		List<Integer> dayList = IntStream.rangeClosed(1, monthLength).boxed().collect(Collectors.toList());
		chartData.setLabels(dayList);

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", targetDeptId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + "0100");
		map.put("endTime", year.getValue() + String.format("%02d",month.getValue()) + "3200");

		if (!StringUtils.isBlank(menuId)) {
			map.put("menuId", menuId);
		}

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);
		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuDeptDay(map);
		List<Dataset> datasets = new ArrayList<>();
		String label = StringUtils.isBlank(menuId) ? egovMessageSource.getMessage("ezStatistics.pgb01", userInfo.getLocale()) : menuNames.get(Integer.parseInt(menuId));

		List<Integer> data = dayList.stream()
				.map(day -> statMenuUser.stream()
						.filter(m -> menuNames.containsKey(m.getMenuId())
								&& (StringUtils.isBlank(menuId) || m.getMenuId() == Integer.parseInt(menuId)))
						.collect(Collectors.groupingBy(
								StatisticVO::getDay,
								Collectors.summingInt(StatisticVO::getStatCount)
						)).getOrDefault(day, 0))
				.collect(Collectors.toList());
		datasets.add(new Dataset(label, data, "bar"));

		if (!StringUtils.isBlank(menuId)) {
			List<Double> listAvg = dayList.stream().parallel()
					.map(day -> statMenuUser.stream().parallel()
							.filter(m -> menuNames.containsKey(m.getMenuId()))
							.collect(Collectors.groupingBy(
									StatisticVO::getDay,
									Collectors.summingDouble(StatisticVO::getStatCount)
							)).getOrDefault(day, 0D))
					.map(sum -> new BigDecimal(sum / menuNames.size()).setScale(2, RoundingMode.HALF_UP).doubleValue())
					.collect(Collectors.toList());
			datasets.add(new Dataset(egovMessageSource.getMessage("ezStatistics.pgb03", userInfo.getLocale()), listAvg,"line"));
		}

		chartData.setDatasets(datasets);

		logger.info("getStatMenuDeptDaily ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuDeptHourly(LoginVO userInfo, String targetCompanyId, String targetDeptId,
											 Year year, Month month, int day, @Nullable String menuId) throws Exception {
		logger.info("getStatMenuDeptHourly start");
		
		StatChartVO chartData = new StatChartVO();
		List<Integer> hourList = IntStream.rangeClosed(0, 23).boxed().collect(Collectors.toList());

		chartData.setLabels(hourList.stream()
				.map(h -> h + "~" + (h + 1))
				.collect(Collectors.toList()));

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", targetDeptId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + String.format("%02d",day) + "00");
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()) + String.format("%02d",day) + "25");

		if (!StringUtils.isBlank(menuId)) {
			map.put("menuId", menuId);
		}

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);
		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuDept(map);
		List<Dataset> datasets = new ArrayList<>();
		String label = StringUtils.isBlank(menuId) ? egovMessageSource.getMessage("ezStatistics.pgb01", userInfo.getLocale()) : menuNames.get(Integer.parseInt(menuId));

		List<Integer> data = hourList.stream()
				.map(h -> statMenuUser.stream()
						.filter(m -> menuNames.containsKey(m.getMenuId())
								&& (StringUtils.isBlank(menuId) || m.getMenuId() == Integer.parseInt(menuId)))
						.collect(Collectors.groupingBy(
								StatisticVO::getHour,
								Collectors.summingInt(StatisticVO::getStatCount)
						)).getOrDefault(h, 0))
				.collect(Collectors.toList());
		datasets.add(new Dataset(label, data, "bar"));

		if (!StringUtils.isBlank(menuId)) {
			List<Double> listAvg = hourList.stream().parallel()
					.map(h -> statMenuUser.stream().parallel()
							.filter(m -> menuNames.containsKey(m.getMenuId()))
							.collect(Collectors.groupingBy(
									StatisticVO::getHour,
									Collectors.summingDouble(StatisticVO::getStatCount)
							)).getOrDefault(h, 0D))
					.map(sum -> new BigDecimal(sum / menuNames.size()).setScale(2, RoundingMode.HALF_UP).doubleValue())
					.collect(Collectors.toList());
			datasets.add(new Dataset(egovMessageSource.getMessage("ezStatistics.pgb03", userInfo.getLocale()), listAvg,"line"));
		}

		chartData.setDatasets(datasets);
		
		logger.info("getStatMenuDeptHourly ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuUserForMonth(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, Month month) throws Exception {
		logger.info("getStatMenuUserForMonth start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> labels = new ArrayList<>();

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("userId", targetUserId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()));
		map.put("endTime", year.getValue() + String.format("%02d",month.getValue()));

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuUserMonth(map);
		List<Integer> data = new ArrayList<>();

		statMenuUser.forEach(vo -> {
			int id = vo.getMenuId();
			if (menuNames.containsKey(id)) {
				labels.add(menuNames.get(id));
				data.add(vo.getStatCount());
			}
		});
		
		chartData.setLabels(labels);
		List<Dataset> datasets = new ArrayList<>();
		datasets.add(new Dataset(data));
		chartData.setDatasets(datasets);
		
		logger.info("getStatMenuUserForMonth ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuUserForDay(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, Month month, int day) throws Exception {
		logger.info("getStatMenuUserForMonth start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> labels = new ArrayList<>();

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("userId", targetUserId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + String.format("%02d",day) + "00");
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()) + String.format("%02d",day) + "25");

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuUserDay(map);
		List<Integer> data = new ArrayList<>();

		statMenuUser.forEach(vo -> {
			int id = vo.getMenuId();
			if (menuNames.containsKey(id)) {
				labels.add(menuNames.get(id));
				data.add(vo.getStatCount());
			}
		});

		chartData.setLabels(labels);
		List<Dataset> datasets = new ArrayList<>();
		datasets.add(new Dataset(data));
		chartData.setDatasets(datasets);

		logger.info("getStatMenuUserForMonth ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuUserForHour(LoginVO userInfo, String targetCompanyId, String targetUserId, Year year, Month month, int day, int hour) throws Exception {
		logger.info("getStatMenuUserForHour start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> labels = new ArrayList<>();

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("userId", targetUserId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + String.format("%02d",day) + String.format("%02d",hour));
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()) + String.format("%02d",day) + String.format("%02d",hour));

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuUserDay(map);
		List<Integer> data = new ArrayList<>();

		statMenuUser.forEach(vo -> {
			int id = vo.getMenuId();
			if (menuNames.containsKey(id)) {
				labels.add(menuNames.get(id));
				data.add(vo.getStatCount());
			}
		});

		chartData.setLabels(labels);
		List<Dataset> datasets = new ArrayList<>();
		datasets.add(new Dataset(data));
		chartData.setDatasets(datasets);

		logger.info("getStatMenuUserForHour ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuDeptForMonth(LoginVO userInfo, String targetCompanyId, String targetDeptId, Year year, Month month) throws Exception {
		logger.info("getStatMenuDeptForMonth start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> labels = new ArrayList<>();

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", targetDeptId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()));
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()));

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuDeptMonth(map);
		List<Integer> data = new ArrayList<>();

		statMenuUser.forEach(vo -> {
			int id = vo.getMenuId();
			if (menuNames.containsKey(id)) {
				labels.add(menuNames.get(id));
				data.add(vo.getStatCount());
			}
		});

		chartData.setLabels(labels);
		List<Dataset> datasets = new ArrayList<>();
		datasets.add(new Dataset(data));
		chartData.setDatasets(datasets);

		logger.info("getStatMenuDeptForMonth ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuDeptForDay(LoginVO userInfo, String targetCompanyId, String targetDeptId, Year year, Month month, int day) throws Exception {
		logger.info("getStatMenuDeptForDay start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> labels = new ArrayList<>();

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", targetDeptId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + String.format("%02d",day) + "00");
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()) + String.format("%02d",day) + "25");

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuDeptDay(map);
		List<Integer> data = new ArrayList<>();

		statMenuUser.forEach(vo -> {
			int id = vo.getMenuId();
			if (menuNames.containsKey(id)) {
				labels.add(menuNames.get(id));
				data.add(vo.getStatCount());
			}
		});

		chartData.setLabels(labels);
		List<Dataset> datasets = new ArrayList<>();
		datasets.add(new Dataset(data));
		chartData.setDatasets(datasets);

		logger.info("getStatMenuDeptForDay ended");
		return chartData;
	}

	@Override
	public StatChartVO getStatMenuDeptForHour(LoginVO userInfo, String targetCompanyId, String targetDeptId, Year year, Month month, int day, int hour) throws Exception {
		logger.info("getStatMenuDeptForHour start");
		
		StatChartVO chartData = new StatChartVO();
		List<String> labels = new ArrayList<>();

		HashMap<String, Object> map = new HashMap<>();
		map.put("tenantId", userInfo.getTenantId());
		map.put("deptId", targetDeptId);
		map.put("companyId", targetCompanyId);
		map.put("startTime", year.getValue() + String.format("%02d",month.getValue()) + String.format("%02d",day) + String.format("%02d",hour));
		map.put("endTime", year.getValue() + String.format("%02d", month.getValue()) + String.format("%02d",day) + String.format("%02d",hour));

		Map<Integer, String> menuNames = getMenuNameUsed(userInfo, targetCompanyId);

		List<StatisticVO> statMenuUser = ezStatisticsAdminDAO.getStatMenuDeptDay(map);
		List<Integer> data = new ArrayList<>();

		statMenuUser.forEach(vo -> {
			int id = vo.getMenuId();
			if (menuNames.containsKey(id)) {
				labels.add(menuNames.get(id));
				data.add(vo.getStatCount());
			}
		});

		chartData.setLabels(labels);
		List<Dataset> datasets = new ArrayList<>();
		datasets.add(new Dataset(data));
		chartData.setDatasets(datasets);

		logger.info("getStatMenuDeptForHour ended");
		return chartData;
	}

	private Map<Integer, String> getMenuNameUsed(LoginVO userInfo, String targetCompanyId) throws Exception {
		logger.info("getMenuNameUsed start");
		
		List<MenuInfoVO> menuInfos = ezNewPortalService.getMenus(targetCompanyId, userInfo.getTenantId(), userInfo.getLang(), "");

		logger.info("getMenuNameUsed ended");
		return menuInfos.stream()
				// 사용중인 메뉴중 메뉴id가 양수인 것만 집계. 변경시 필터만 변경.
				.filter(m -> m.getMenuId() > 0 && m.isMenuUsed())
				.collect(Collectors.toMap(
						MenuInfoVO::getMenuId, MenuInfoVO::getMenuName
				));
	}
	
	public void deleteStatMenuBeforeTime(LocalDateTime time) {
		logger.debug("deleteStatMenuBeforeTime start");
		
		try {
			StatisticVO vo = new StatisticVO();
			vo.setTime(time);
			ezStatisticsAdminDAO.deleteStatMenuUser(vo);
			ezStatisticsAdminDAO.deleteStatMenuDept(vo);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("deleteStatMenuBeforeTime ended");
	}
}
