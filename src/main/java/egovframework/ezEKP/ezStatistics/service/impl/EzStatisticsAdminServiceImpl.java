package egovframework.ezEKP.ezStatistics.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezStatistics.dao.EzStatisticsAdminDAO;
import egovframework.ezEKP.ezStatistics.service.EzStatisticsAdminService;
import egovframework.ezEKP.ezStatistics.vo.StatApprVO;
import egovframework.ezEKP.ezStatistics.vo.StatDailyDocCountLogVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzStatisticsAdminService")
public class EzStatisticsAdminServiceImpl implements EzStatisticsAdminService {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name="EzStatisticsAdminDAO")
	private EzStatisticsAdminDAO ezStatisticsAdminDAO;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzStatisticsAdminServiceImpl.class);
	
	@Override
	public String getTimeList(String date, String company, int tenantID) {
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("startDate", date + "-01-01");
		map.put("endDate", date + "-13-31");
		map.put("companyID", company);
		map.put("tenantID", tenantID);
		
		try {
			List<StatDailyDocCountLogVO> docCountLogVOs = ezStatisticsAdminDAO.getTimeList(map);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<DATA>");
			
			for (int i = 0; i < docCountLogVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(docCountLogVOs.get(i)));
			}
			sb.append("</DATA>");
			
			rtnValue = sb.toString();
		} catch (Exception e) {
			LOGGER.error("EzStatisticsAdminDAO :: getTimeList :: " + e.getMessage());
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
			List<StatDailyDocCountLogVO> docCountLogVOs = ezStatisticsAdminDAO.getCountList(statApprVO);
			
			StringBuffer sb = new StringBuffer();
			sb.append("<DATA>");
			
			for (int i = 0; i < docCountLogVOs.size(); i++) {
				sb.append(commonUtil.getQueryResult(docCountLogVOs.get(i)));
			}
			sb.append("</DATA>");
			
			rtnValue = sb.toString();
		} catch (Exception e) {
			LOGGER.error("EzStatisticsAdminDAO :: getCountList :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}

	@Override
	public String getFormInfo(StatApprVO statApprVO) {
		String rtnValue = "";
		String subQuery = "";
		
		statApprVO.setStartDate(statApprVO.getDate() + "-01-01");
		statApprVO.setEndDate(statApprVO.getDate() + "-12-31");
		
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
			LOGGER.error("EzStatisticsAdminDAO :: getFormInfo :: " + e.getMessage());
			rtnValue = "ERROR";
		}
		
		return rtnValue;
	}
	
}
