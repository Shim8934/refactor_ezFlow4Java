package egovframework.ezEKP.ezCommunity.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityAdminDAO;
import egovframework.ezEKP.ezCommunity.service.EzCommunityAdminService;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzCommunityAdminService")
public class EzCommunityAdminServiceImpl extends EgovAbstractServiceImpl implements EzCommunityAdminService{
	@Resource(name="EzCommunityAdminDAO")
	private EzCommunityAdminDAO ezCommunityAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties globals;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzCommunityAdminServiceImpl.class);

	@Override
	public int aspCloseComGet2(String keyword, String sRadio, int tenantID) throws Exception {
		LOGGER.debug("aspCloseComGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD",  keyword);
		map.put("v_S_RADIO",  sRadio);
		map.put("tenantID", tenantID);
		
		int result = 0;
		
		if (!keyword.equals("") || !sRadio.equals("")) {
			result = ezCommunityAdminDAO.aspCloseComGet2Select1(map);
		} else {
			result = ezCommunityAdminDAO.aspCloseComGet2Select2(map);
		}
		
		LOGGER.debug("aspCloseComGet2 ended.");
		
		return result;
	}

	@Override
	public List<CommunityCComCloseVO> aspCloseComGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2, int tenantID) throws Exception {
		LOGGER.debug("aspCloseGet1 started.");
		LOGGER.debug("keyword=" + keyword + ", sRadio=" + sRadio);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		map.put("v_S", s);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_SORT1", sort1);
		map.put("v_SORT2", sort2);
		map.put("tenantID", tenantID);
		
		List<CommunityCComCloseVO> list = null;
		
		if (!keyword.equals("") || !sRadio.equals("")) {
			list = ezCommunityAdminDAO.aspCloseComGet1Select1(map);
		} else {
			list = ezCommunityAdminDAO.aspCloseComGet1Select2(map);
		}
		
		LOGGER.debug("aspCloseGet1 ended.");
		
		return list;
	}

	@Override
	public String communityCloseCom(List<CommunityCComCloseVO> clubList, int curPage, int comNoPerPage, LoginVO userInfo) throws Exception {
		StringBuilder sb = new StringBuilder();
		int iOutputCount = 1, iList = 0;
		
		for (CommunityCComCloseVO cComClose : clubList) {
			iList++;
			
			if (iList <= (curPage - 1) * comNoPerPage) {
				break;
			}
			
			sb.append("<tr>");
			sb.append("<td>" + (iOutputCount + (curPage - 1) * comNoPerPage) + "</td>");
			sb.append("<td style='width:400px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;><nobr style='width:400px;overflow:hidden;text-overflow:ellipsis;'>");
			
			String[] compare = egovMessageSource.getMessage("ezCommunity.st1", userInfo.getLocale()).split(";");
			String process = egovMessageSource.getMessage("ezCommunity.t38", userInfo.getLocale());
			String temp = "NO";
			
			for (int c = 1; c <= Integer.parseInt(compare[0]); c++) {
				if (cComClose.getCloseState().trim().equals(compare[c])) {
					temp = "OK";
				}
			}
			
			if (temp.equals("OK")) {
				sb.append(commonUtil.cleanValue(cComClose.getC_ClubName().trim()));
				process = egovMessageSource.getMessage("ezCommunity.t38", userInfo.getLocale());
			} else {
				sb.append("<a href=\"javascript:open_info('" + cComClose.getC_ClubNo().trim() + "')\">");
				sb.append(commonUtil.cleanValue(cComClose.getC_ClubName().trim()));
				sb.append("</a>");
				process = egovMessageSource.getMessage("ezCommunity.t483", userInfo.getLocale());
			}
			
			sb.append("</nobr></td>");
			sb.append("<td>" + commonUtil.cleanValue(cComClose.getUserName()) + "(");
			sb.append(commonUtil.cleanValue(cComClose.getC_SysopID().trim()) + ")");
			sb.append("<td>" + cComClose.getApplicationDate().substring(0, 10) + "</td>");
			sb.append("<td>" + process + "</td>");
			sb.append("</tr>");
			
			iOutputCount++;
		}
		
		return sb.toString();
	}

	@Override
	public String aspCommInfoGet3(String code, int tenantID) throws Exception {
		LOGGER.debug("aspCommInfoGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityAdminDAO.aspCommInfoGet3(map);
		
		LOGGER.debug("aspCommInfoGet3 ended.");
		
		return result;
	}

	@Override
	public String aspCommInfoGet4(String code, int tenantID) throws Exception {
		LOGGER.debug("aspCommInfoGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityAdminDAO.aspCommInfoGet4(map);
		
		LOGGER.debug("aspCommInfoGet3 ended.");
		
		return result;
	}

	@Override
	public void commCloseAll(String code, Locale locale, int tenantID) throws Exception {
		LOGGER.debug("commCloseAll started.");
		
		aspCommCloseAllDel(code, tenantID);
		aspCommCloseAllUpdate(code, locale, tenantID);
		
		LOGGER.debug("commCloseAll ended.");
	}

	@Override
	public int aspAdmitComGet2(String keyword, String sRadio, int tenantID) throws Exception {
		LOGGER.debug("aspAdmitComGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		map.put("tenantID", tenantID);
		
		int result = 0;
		
		if (!keyword.equals("") || !sRadio.equals("")) {
			result = ezCommunityAdminDAO.aspAdmitComGet2Select1(map);
		} else {
			result = ezCommunityAdminDAO.aspAdmitComGet2Select2(map);
		}
		
		LOGGER.debug("aspAdmitComGet2 ended.");
		
		return result;
	}

	@Override
	public List<CommunityClubVO> aspAdmitComGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2, int tenantID) throws Exception {
		LOGGER.debug("aspAdmitComGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		map.put("v_S", s);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_SORT1", sort1);
		map.put("v_SORT2", sort2);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = null;
		
		if (!keyword.equals("") || !sRadio.equals("")) {
			list = ezCommunityAdminDAO.aspAdmitComGet1Select1(map);
		} else {
			list = ezCommunityAdminDAO.aspAdmitComGet1Select2(map);
		}
		
		LOGGER.debug("aspAdmitComGet1 ended.");
		
		return list;
	}
	
	@Override
	public String admitCom(List<CommunityClubVO> clubList, int curPage, int comNoPerPage) throws Exception {
		StringBuilder sb = new StringBuilder();
		int iOutputCount = 1, iList = 0;
		
		for (CommunityClubVO club : clubList) {
			iList++;
			
			if (iList <= (curPage - 1) * comNoPerPage) {
				break;
			}
			
			sb.append("<tr>");
			sb.append("<td>" + (iOutputCount + (curPage - 1) * comNoPerPage) + "</td>");
			sb.append("<td style='width:400px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;><nobr style='width:400px;overflow:hidden;text-overflow:ellipsis;'>");
			sb.append("<a href=\"javascript:open_info('" + club.getC_ClubNo().trim() + "')\">" + club.getC_ClubName() + "</a>");
			sb.append("</nobr></td>");
			sb.append("<td>" + commonUtil.cleanValue(club.getUserName()) + "(");
			sb.append(commonUtil.cleanValue(club.getC_SysopID().trim()) + ")");
			sb.append("<td>" + club.getC_RegDate().substring(0, 10) + "</td>");
			sb.append("</tr>");
			
			iOutputCount++;
		}
		
		return sb.toString();
	}

	@Override
	public void aspCommAdmitOkSet1(String code, String lang, int tenantID) throws Exception {
		LOGGER.debug("aspCommAdmitOkSet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommAdmitOkSet1Update(map);
		ezCommunityAdminDAO.aspCommAdmitOkSet1Delete(map);
		
		LOGGER.debug("aspCommAdmitOkSet1 ended.");
	}

	@Override
	public void aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName, int tenantID) throws Exception {
		LOGGER.debug("aspCommAdmitOkSet2 started.");
		LOGGER.debug("useEzKMS=" + useEzKMS);
		
		String result = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommAdmitokSet2Update(map);
		
		map.put("v_COMNAME", comName);
		
		if (useEzKMS.equals("YES")) {
			ezCommunityAdminDAO.aspCommAdmitokSet2Insert1(map);
			ezCommunityAdminDAO.aspCommAdmitokSet2Insert2(map);
		} else {
			map.put("v_USERINFO_LANG", lang);
			
			result = ezCommunityAdminDAO.aspCommAdmitokSet2Select(map);
			LOGGER.debug(result);
		}
		
		LOGGER.debug("aspCommAdmitOkSet2 ended.");
	}

	private void aspCommCloseAllDel(String code, int tenantID) throws Exception {
		LOGGER.debug("aspCommCloseAllDel started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommCloseAllDel(map);
		
		LOGGER.debug("aspCommCloseAllDel ended.");
	}
	
	private void aspCommCloseAllUpdate(String code, Locale locale, int tenantID) throws Exception {
		LOGGER.debug("aspCommCloseAllUpdate started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_PCLOSESTATE", egovMessageSource.getMessage("ezCommunity.t38", locale));
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommCloseAllUpdate(map);
		
		LOGGER.debug("aspCommCloseAllUpdate ended.");
	}

	@Override
	public int aspSearchKeyGet2(String lang, String select, String query, int tenantID) throws Exception {
		LOGGER.debug("aspSearchKeyGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_STRSELECT", select.toUpperCase());
		map.put("v_STRQUERY", query);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityAdminDAO.aspSearchKeyGet2(map);
		
		LOGGER.debug("aspSearchKeyGet2 ended.");
		
		return result;
	}

	@Override
	public List<CommunityClubVO> aspSearchKeyGet1(String lang, int iQueryCount, String select, String query, int tenantID) throws Exception {
		LOGGER.debug("aspSearchKeyGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_IQUERYCOUNT", iQueryCount);
		map.put("v_STRSELECT", select.toUpperCase());
		map.put("v_STRQUERY", query);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityAdminDAO.aspSearchKeyGet1(map);
		
		LOGGER.debug("aspSearchKeyGet1 ended.");
		
		return list;
	}

	@Override
	public String getUserName(String id, int tenantID) throws Exception {
		LOGGER.debug("getUserName started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ID", id);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityAdminDAO.getUserName(map);
		
		LOGGER.debug("getUserName ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO admCommunityInfoEdit(String lang, String code, int tenantID) throws Exception {
		LOGGER.debug("admCommunityInfoEdit started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityAdminDAO.admCommunityInfoEdit(map);
		
		LOGGER.debug("admCommunityInfoEdit ended.");
		LOGGER.debug("sysID="+vo.getC_SysopID());
		return vo;
	}

	@Override
	public String admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String code, int tenantID) throws Exception {
		LOGGER.debug("admCommunityInfoEditOk started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_C_CLUBNAME", clubName);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		try {
			ezCommunityAdminDAO.admCommunityInfoEditOk(map);
			
			LOGGER.debug("admCommunityInfoEditOk ended.");
			
			return "OK";
		} catch (Exception e) {
			LOGGER.debug("admCommunityInfoEditOk ERROR.");
			LOGGER.debug(e.getMessage());
			
			return e.getMessage();
		}
	}
}
