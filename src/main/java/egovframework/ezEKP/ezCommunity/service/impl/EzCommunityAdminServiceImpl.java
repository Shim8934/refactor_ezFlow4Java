package egovframework.ezEKP.ezCommunity.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

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

	@Override
	public String aspCloseComGet2(String keyword, String sRadio) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_KEYWORD",  keyword);
		map.put("v_S_RADIO",  sRadio);
		
		return ezCommunityAdminDAO.aspCloseComGet2(map);
	}

	@Override
	public List<CommunityCComCloseVO> aspCloseGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		map.put("v_S", s);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_SORT1", sort1);
		map.put("v_SORT2", sort2);
		
		return ezCommunityAdminDAO.aspCloseGet1(map);
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
	public String aspCommInfoGet3(String code) throws Exception {
		return ezCommunityAdminDAO.aspCommInfoGet3(code);
	}

	@Override
	public String aspCommInfoGet4(String code) throws Exception {
		return ezCommunityAdminDAO.aspCommInfoGet4(code);
	}

	@Override
	public void commCloseAll(String code, LoginVO userInfo) throws Exception {
		aspCommCloseAllDel(code);
		aspCommCloseAllUpdate(code, userInfo);
	}

	@Override
	public String aspAdmitComGet2(String keyword, String sRadio) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		
		return ezCommunityAdminDAO.aspAdmitComGet2(map);
	}

	@Override
	public List<CommunityClubVO> aspAdmitComGet1(String keyword, String sRadio, String s, String lang, String sort1, String sort2) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_KEYWORD", keyword);
		map.put("v_S_RADIO", sRadio);
		map.put("v_S", s);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_SORT1", sort1);
		map.put("v_SORT2", sort2);
		
		return ezCommunityAdminDAO.aspAdmitComGet1(map);
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
	public void aspCommAdmitOkSet1(String code, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		
		ezCommunityAdminDAO.aspCommAdmitOkSet1(map);
	}

	@Override
	public void aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_USE_EZKMS", useEzKMS);
		map.put("v_COMNAME", comName);
		
		ezCommunityAdminDAO.aspCommAdmitokSet2(map);
	}

	private void aspCommCloseAllDel(String code) throws Exception {
		ezCommunityAdminDAO.aspCommCloseAllDel(code);
	}
	
	private void aspCommCloseAllUpdate(String code, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_CODE", code);
		map.put("v_PCLOSESTATE", egovMessageSource.getMessage("ezCommunity.t38", userInfo.getLocale()));
		
		ezCommunityAdminDAO.aspCommCloseAllUpdate(map);
	}

	@Override
	public Integer aspSearchKeyGet2(String lang, String select, String query) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_STRSELECT", select.toUpperCase());
		map.put("v_STRQUERY", query);
		
		return ezCommunityAdminDAO.aspSearchKeyGet2(map);
	}

	@Override
	public List<CommunityClubVO> aspSearchKeyGet1(String lang, int iQueryCount, String select, String query) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_IQUERYCOUNT", iQueryCount);
		map.put("v_STRSELECT", select.toUpperCase());
		map.put("v_STRQUERY", query);
		
		return ezCommunityAdminDAO.aspSearchKeyGet1(map);
	}

	@Override
	public String getUserName(String id) throws Exception {
		return ezCommunityAdminDAO.getUserName(id);
	}

	@Override
	public CommunityClubVO admCommunityInfoEdit(String lang, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_CODE", code);
		
		return ezCommunityAdminDAO.admCommunityInfoEdit(map);
	}

	@Override
	public void admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String code) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_USERINFO_LANG", lang);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_C_CLUBNAME", clubName);
		map.put("v_CODE", code);
		
		ezCommunityAdminDAO.admCommunityInfoEditOk(map);
	}
	
}
