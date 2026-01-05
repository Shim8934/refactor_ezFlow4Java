package egovframework.ezEKP.ezCommunity.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringEscapeUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityAdminDAO;
import egovframework.ezEKP.ezCommunity.service.EzCommunityAdminService;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCComCloseVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityClubVO;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzCommunityAdminService")
public class EzCommunityAdminServiceImpl extends EgovAbstractServiceImpl implements EzCommunityAdminService{
	@Resource(name="EzCommunityAdminDAO")
	private EzCommunityAdminDAO ezCommunityAdminDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzEmailService ezEmailService;
	
	@Autowired
	private EzNotificationService ezNotificationService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzCommunityAdminServiceImpl.class);

	/* 2020-01-06 홍승비 - 관리자 > 폐쇄승인 커뮤니티 카운트 (폐쇄사유 검색옵션 추가) */
	@Override
	public int aspCloseComGet2(String searchValue, String searchType, String searchType2, String lang, String companyID, int tenantID) throws Exception {
		logger.debug("aspCloseComGet2 started.");
		//logger.debug("v_S_RADIO=" + searchType + ", v_SEARCHTYPE2=" + searchType2);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", searchValue);
		map.put("v_S_RADIO", searchType);
		map.put("v_SEARCHTYPE2", searchType2);
		map.put("v_USERINFO_LANG", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int result = 0;
		
		// 2024-07-16 기준으로 searchType의 디폴트 값은 항상 "0"으로 전달됨 (aspCloseComGet2Select2 쿼리를 타지 않음)
		if (!searchValue.equals("") || !searchType.equals("")) {
			result = ezCommunityAdminDAO.aspCloseComGet2Select1(map);
		} else {
			result = ezCommunityAdminDAO.aspCloseComGet2Select2(map);
		}
		
		logger.debug("aspCloseComGet2 ended.");
		
		return result;
	}

	/* 2018-06-21 홍승비 - 관리자 > 폐쇄승인 커뮤니티 표출(리스트) */
	@Override
	public List<CommunityCComCloseVO> aspCloseComGet1(String searchValue, String searchType, String searchType2, String lang, int pageNum, String offSetMin, String companyID, int tenantID) throws Exception {
		logger.debug("aspCloseGet1 started.");
		//logger.debug("keyword=" + searchValue + ", sRadio=" + searchType + ", searchType2=" + searchType2);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", searchValue);
		map.put("v_S_RADIO", searchType);
		map.put("v_SEARCHTYPE2", searchType2);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_STARTROW", 10 * (pageNum - 1));
		map.put("v_OFFSETMIN", offSetMin);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<CommunityCComCloseVO> list = null;
		
		if (!searchValue.equals("") || !searchType.equals("")) {
			list = ezCommunityAdminDAO.aspCloseComGet1Select1(map);
		} else {
			list = ezCommunityAdminDAO.aspCloseComGet1Select2(map);
		}
		
		logger.debug("aspCloseGet1 ended.");
		
		return list;
	}

	@Override
	public String communityCloseCom(List<CommunityCComCloseVO> clubList, int curPage, int comNoPerPage, LoginVO userInfo) throws Exception {
		StringBuilder sb = new StringBuilder();
		int iOutputCount = 0, iList = 0;
		
		for (CommunityCComCloseVO cComClose : clubList) {
			iList++;
			
			if (iList <= (curPage - 1) * comNoPerPage) {
				continue;
			}
			
			if (iOutputCount + 1 > comNoPerPage) {
				break;
			}
			
			sb.append("<tr>");
			sb.append("<td>" + (clubList.size() - ((curPage - 1) * comNoPerPage) - iOutputCount) + "</td>");
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

				/* 2018-06-22 홍승비 - b_clubname 필드 제거, c_clubname 사용 */
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
		logger.debug("aspCommInfoGet3 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityAdminDAO.aspCommInfoGet3(map);
		
		logger.debug("aspCommInfoGet3 ended.");
		
		return result;
	}

	@Override
	public String aspCommInfoGet4(String code, int tenantID) throws Exception {
		logger.debug("aspCommInfoGet4 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityAdminDAO.aspCommInfoGet4(map);
		
		logger.debug("aspCommInfoGet3 ended.");
		
		return result;
	}

	@Override
	public void commCloseAll(String code, Locale locale, int tenantID) throws Exception {
		logger.debug("commCloseAll started.");
		
		aspCommCloseAllDel(code, tenantID);
		aspCommCloseAllUpdate(code, locale, tenantID);
		
		logger.debug("commCloseAll ended.");
	}

	/* 2020-01-06 홍승비 - 커뮤니티소개 검색옵션 추가 */
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(총 n개 카운트) */
	@Override
	public int aspAdmitComGet2(String searchValue, String searchType, String searchType2, String lang, String companyID, int tenantID) throws Exception {
		logger.debug("aspAdmitComGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", searchValue);
		map.put("v_S_RADIO", searchType);
		map.put("v_SEARCHTYPE2", searchType2);
		map.put("v_USERINFO_LANG", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int result = 0;
		
		// 2024-07-16 기준으로 searchType의 디폴트 값은 항상 "0"으로 전달됨 (aspAdmitComGet2Select2 쿼리를 타지 않음)
		if (!searchValue.equals("") || !searchType.equals("")) { // 검색어 또는 검색용 카테고리 존재
			result = ezCommunityAdminDAO.aspAdmitComGet2Select1(map);
		} else { // 검색어 없음
			result = ezCommunityAdminDAO.aspAdmitComGet2Select2(map);
		}
		
		logger.debug("aspAdmitComGet2 ended.");
		
		return result;
	}

	/* 2020-01-06 홍승비 - 커뮤니티소개 검색옵션 추가 */
	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 신청승인 표출(리스트) */
	@Override
	public List<CommunityClubVO> aspAdmitComGet1(String searchValue, String searchType, String searchType2, String lang, int pageNum, String offSetMin, String companyID, int tenantID) throws Exception {
		logger.debug("aspAdmitComGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_KEYWORD", searchValue);
		map.put("v_S_RADIO", searchType);
		map.put("v_SEARCHTYPE2", searchType2);
		map.put("v_USERINFO_LANG", lang);
		map.put("v_STARTROW", 10 * (pageNum - 1));
		map.put("v_OFFSETMIN", offSetMin);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = null;
		
		if (!searchValue.equals("") || !searchType.equals("")) { // 검색어 또는 검색용 카테고리 존재
			list = ezCommunityAdminDAO.aspAdmitComGet1Select1(map);
		} else { // 검색어 없음
			list = ezCommunityAdminDAO.aspAdmitComGet1Select2(map);
		}
		
		logger.debug("aspAdmitComGet1 ended.");
		
		return list;
	}
	
	@Override
	public String admitCom(List<CommunityClubVO> clubList, int curPage, int comNoPerPage) throws Exception {
		StringBuilder sb = new StringBuilder();
		int iOutputCount = 0, iList = 0;
		
		for (CommunityClubVO club : clubList) {
			iList++;
			
			if (iList <= (curPage - 1) * comNoPerPage) {
				continue;
			}
			
			if (iOutputCount + 1 > comNoPerPage) {
				break;
			}
			
			sb.append("<tr>");
			sb.append("<td width='35px;'>" + (clubList.size() - ((curPage - 1) * comNoPerPage) - iOutputCount) + "</td>");
			sb.append("<td style='width: 50%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;><nobr style='width:400px;overflow:hidden;text-overflow:ellipsis;'>");
			sb.append("<a href=\"javascript:open_info('" + club.getC_ClubNo().trim() + "')\">" + commonUtil.cleanValue(club.getC_ClubName()) + "</a>");
			sb.append("</nobr></td>");
			sb.append("<td style='width: 10%;'>" + commonUtil.cleanValue(club.getUserName()) + "(");
			sb.append(commonUtil.cleanValue(club.getC_SysopID().trim()) + ")");
			sb.append("<td style='width: 10%;'>" + club.getC_RegDate().substring(0, 10) + "</td>");
			sb.append("</tr>");
			
			iOutputCount++;
		}
		
		return sb.toString();
	}

	@Override
	public List<HashMap<String, Object>> aspCommAdmitOkSet1(String code, String lang, int tenantID) throws Exception {
		logger.debug("aspCommAdmitOkSet1 started.");
		
		List<HashMap<String, Object>> result = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_LANG", lang);
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommAdmitOkSet1Update(map);
		result = ezCommunityAdminDAO.aspCommAdmitokSet2Select(map);
		ezCommunityAdminDAO.aspCommAdmitOkSet1Delete(map);
		
		logger.debug("aspCommAdmitOkSet1 ended.");
		return result;
	}

	@Override
	public List<HashMap<String, Object>> aspCommAdmitOkSet2(String code, String lang, String useEzKMS, String comName, int tenantID) throws Exception {
		logger.debug("aspCommAdmitOkSet2 started.");
		//logger.debug("useEzKMS=" + useEzKMS);
		
		List<HashMap<String, Object>> result = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_pNow", commonUtil.getTodayUTCTime(""));
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommAdmitokSet2Update(map);
		
		map.put("v_COMNAME", comName);
		
		if (useEzKMS.equals("YES")) {
			ezCommunityAdminDAO.aspCommAdmitokSet2Insert1(map);
			ezCommunityAdminDAO.aspCommAdmitokSet2Insert2(map);
		}
		
		map.put("v_USERINFO_LANG", lang);
		result = ezCommunityAdminDAO.aspCommAdmitokSet2Select(map);
		
		logger.debug("aspCommAdmitOkSet2 ended.");
		return result;
	}

	@Override
	public void aspCommCloseAllDel(String code, int tenantID) throws Exception {
		logger.debug("aspCommCloseAllDel started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommCloseAllDel(map);
		
		logger.debug("aspCommCloseAllDel ended.");
	}
	
	private void aspCommCloseAllUpdate(String code, Locale locale, int tenantID) throws Exception {
		logger.debug("aspCommCloseAllUpdate started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_PCLOSESTATE", "1");
		map.put("tenantID", tenantID);
		
		ezCommunityAdminDAO.aspCommCloseAllUpdate(map);
		
		logger.debug("aspCommCloseAllUpdate ended.");
	}

	/* 2020-01-03 홍승비 - 커뮤니티 검색 시 커뮤니티소개 검색옵션 다시 추가 */
	/* 관리자 > 커뮤니티검색화면 표출(총 n개 keywordCount) 시 companyID 조건 추가 */
	@Override
	public int aspSearchKeyGet2(String lang, String searchType, String searchType2, String searchValue, String companyID, int tenantID) throws Exception {
		logger.debug("aspSearchKeyGet2 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_STRSELECT", searchType);
		map.put("v_STRSELECT2", searchType2);
		map.put("v_STRQUERY", searchValue);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		int result = ezCommunityAdminDAO.aspSearchKeyGet2(map);
		
		logger.debug("aspSearchKeyGet2 ended.");
		
		return result;
	}

	/* 2020-01-03 홍승비 - 커뮤니티 검색 시 커뮤니티소개 검색옵션 다시 추가 */
	/* 관리자 > 커뮤니티검색화면 표출(하단 리스트) 시 companyID 조건 추가, deptID 가져오기 */
	@Override
	public List<CommunityClubVO> aspSearchKeyGet1(String primary, int pageNum, String searchType, String searchType2, String searchValue, String offSetMin, String companyID, int tenantID) throws Exception {
		logger.debug("aspSearchKeyGet1 started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", primary);
		map.put("v_STARTROW", 10 * (pageNum - 1));
		map.put("v_STRSELECT", searchType);
		map.put("v_STRSELECT2", searchType2);
		map.put("v_STRQUERY", searchValue);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<CommunityClubVO> list = ezCommunityAdminDAO.aspSearchKeyGet1(map);
		
		logger.debug("aspSearchKeyGet1 ended.");
		
		return list;
	}

	/* 2018-06-21 홍승비 - 관리자 > 커뮤니티 겸직하는 userID 가져올때 companyID로 조건 추가 */
	@Override
	public String getUserName(String id, String primary, String companyID, int tenantID) throws Exception {
		logger.debug("getUserName started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_ID", id);
		map.put("primary", primary);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		String result = ezCommunityAdminDAO.getUserName(map);
		
		logger.debug("getUserName ended.");
		
		return result;
	}

	@Override
	public CommunityClubVO admCommunityInfoEdit(String lang, String code, int tenantID) throws Exception {
		logger.debug("admCommunityInfoEdit started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		CommunityClubVO vo = ezCommunityAdminDAO.admCommunityInfoEdit(map);
		
		logger.debug("admCommunityInfoEdit ended.");
		//logger.debug("sysID="+vo.getC_SysopID());
		return vo;
	}

	@Override
	public String admCommunityInfoEditOk(String lang, String cCateA, String cCateB, String cCateC, String clubName, String clubDesc, String code, int tenantID) throws Exception {
		logger.debug("admCommunityInfoEditOk started.");
		//logger.debug("clubDesc=" + clubDesc);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_C_CATE_A", cCateA);
		map.put("v_C_CATE_B", cCateB);
		map.put("v_C_CATE_C", cCateC);
		map.put("v_C_CLUBNAME", clubName);
		map.put("v_C_CLUBDESC", clubDesc);
		map.put("v_CODE", code);
		map.put("tenantID", tenantID);
		
		try {
			ezCommunityAdminDAO.admCommunityInfoEditOk(map);
			
			logger.debug("admCommunityInfoEditOk ended.");
			
			return "OK";
		} catch (Exception e) {
			logger.debug("admCommunityInfoEditOk ERROR.");
			logger.debug(e.getMessage());
			
			return e.getMessage();
		}
	}

	@Override
	public void createCommunityAdmitSendMail(HttpServletRequest request, String loginCookie, LoginVO userInfo, List<HashMap<String, Object>> recipientList,
			boolean isAdmit) throws Exception {
		logger.debug("createCommunityAdmitSendMail started.");
		//logger.debug("isAdmit=" + isAdmit);
		
		if (recipientList != null) {
			Locale locale = userInfo.getLocale();
			/* 2018-02-08 장진혁 - 아랫쪽 소스에 누가 주석처리 했기때문에 위쪽도 마저 주석처리함 */
			//String pDivi = (isAdmit ? egovMessageSource.getMessage("ezCommunity.t46", locale) : egovMessageSource.getMessage("ezCommunity.t44", locale));
			
			InternetAddress from = new InternetAddress();
        	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
        	from.setAddress(userInfo.getEmail());
			
			for (HashMap<String, Object> recipient : recipientList) {
				List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
				Map<String, Object> recipientMap = new HashMap<String, Object>();
				recipientMap.put("userType", "PERSON");
				recipientMap.put("companyId", userInfo.getCompanyID());
				recipientMap.put("cn", (String) recipient.get("USERID"));
				notiRecipientList.add(recipientMap);
				
				String notiContent = (String)recipient.get("C_CLUBNAME");
				String c_clubno = (String)recipient.get("C_CLUBNO");
				String notiSubType = isAdmit ? "CREATE_ADMIT" : "CREATE_REJECT";
				String linkUrl = isAdmit ? "/ezCommunity/checkCommHome.do?communityCD=" + c_clubno : "";
				//logger.debug("recipient=" + (String)recipient.get("USERNAME") + ", " + (String)recipient.get("C_CLUBNAME") + ", " + (String)recipient.get("EMAIL"));
				
				InternetAddress to = new InternetAddress();
				to.setPersonal((String)recipient.get("USERNAME"), "UTF-8");
				to.setAddress((String)recipient.get("EMAIL"));

				StringBuilder subject = buildMessage("ezCommunity.t51", "ezCommunity.lhj09", "ezCommunity.lhj10",
						(String) recipient.get("C_CLUBNAME"), isAdmit, locale);

				/*String subject = egovMessageSource.getMessage("ezCommunity.t51", locale)
						+ "[\"" + (String)recipient.get("C_CLUBNAME") + "\"] "
						+ egovMessageSource.getMessage("ezCommunity.t52", locale) 
						+ pDivi 
						+ egovMessageSource.getMessage("ezCommunity.t54", locale);*/

				StringBuilder mailBody = buildMessage("ezCommunity.t51", "ezCommunity.lhj09", "ezCommunity.lhj10",
						StringEscapeUtils.escapeHtml4((String) recipient.get("C_CLUBNAME")), isAdmit, locale);

				// 2018-11-07 김민성 - 커뮤니티 승인 메일 폰트 수정
				String content = commonUtil.createNotiMailContent(mailBody.toString(), userInfo.getTenantId(), userInfo.getLocale());
				
				ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject.toString(), content, false);
				
				String linkUrlMobile = "";
				String notiStatus = ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "COMMUNITY", notiSubType, notiContent, "popup", "1300", "900", linkUrl, linkUrlMobile, "notChkSetting");
				logger.debug("community " +  notiSubType + " noti status : " + notiStatus);
			}
		}
		
		logger.debug("createCommunityAdmitSendMail ended.");
	}

	private StringBuilder buildMessage(String prefixMessage, String admitMessage, String rejectMessage,
									   String clubName, boolean isAdmit, Locale locale) {
		StringBuilder message = new StringBuilder();
		message.append(egovMessageSource.getMessage(prefixMessage, locale));
		message.append("[\"");
		message.append(clubName);
		message.append("\"] ");

		if (isAdmit) {
			message.append(egovMessageSource.getMessage(admitMessage, locale));
		} else {
			message.append(egovMessageSource.getMessage(rejectMessage, locale));
		}

		return message;
	}

	@Override
	public String adminBbsList(LoginVO userInfo, List<CommunityCBoardVO> cBoardList, String code, int curPage, String bName, int comNoPerPage) throws Exception {
		StringBuilder strHTML = new StringBuilder();
		int iColSpan = 5;
		
		if (bName.equals("tbl_c_clubpds") || bName.equals("tbl_c_clubpds1")) {
			iColSpan = 6;
		}
		
		strHTML.append("<tr>");
		strHTML.append("<th width=\"60px\" >" + egovMessageSource.getMessage("ezCommunity.t32", userInfo.getLocale()) + "</th>");
		strHTML.append("<th>" + egovMessageSource.getMessage("ezCommunity.t170", userInfo.getLocale()) + "</th>");
		strHTML.append("<th width=\"70px\">" + egovMessageSource.getMessage("ezCommunity.t138", userInfo.getLocale()) + "</th>");
		strHTML.append("<th width=\"90px\">" +  egovMessageSource.getMessage("ezCommunity.t171", userInfo.getLocale()) + "</th>");
		
		if (iColSpan == 6) {
			strHTML.append("<th width=\"45px\">" + egovMessageSource.getMessage("ezCommunity.t172", userInfo.getLocale()) + "</th>");
		}
		
		strHTML.append("<th width=\"60px\">" + egovMessageSource.getMessage("ezCommunity.t173", userInfo.getLocale()) + "</th>");
		strHTML.append("</tr>");
		
		int iOutputCount = 1;
		int iList = 0;
		int itemNum = ((curPage - 1) * 10) + 1;
//		String pURL = "";
		
		for (CommunityCBoardVO cBoard : cBoardList) {
			iList++;
			
			if (iList <= (curPage - 1) * comNoPerPage) {
				continue;
			}
			if ( iOutputCount > comNoPerPage) {
				break;
			}
			
			strHTML.append("<tr ondblclick=btn_bbsView('" + cBoard.getNo() + "','" + bName + "')>");
			strHTML.append("<td width=\"60px\">");
			
			if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
				if (cBoard.getRe_Level() > 0) {
					strHTML.append("<font color=\"#A4A4A4\">" + itemNum + "</font>");
				} else {
					strHTML.append(itemNum);
				}
			} else {
				strHTML.append(itemNum);
			}
			
			strHTML.append("</td>");
			strHTML.append("<td class=\"t2\" style=\"overflow: hidden; cursor: pointer; text-overflow: ellipsis;\" >");
			strHTML.append("<div style='display:flex;align-items:center'><span style='overflow: hidden;cursor: pointer;text-overflow: ellipsis;white-space: nowrap;'>");
			
			if (!bName.equals("tbl_c_clubnotice") && !bName.equals("tbl_c_notice")) {
				if (cBoard.getRe_Level() > 0) {
					 int wid = 10 * cBoard.getRe_Level();
					 
					 /* 2020-01-20 홍승비 - 아이콘 정렬 수정 */
                     strHTML.append("<img src=\"/images/dum.gif\" width=\"" + wid + "\" height=\"1\" border=\"0\">"); 
                     strHTML.append("<img src=\"/images/i_rep.gif\" alt border=\"0\" style=\"vertical-align:middle;\">&nbsp;"); 
				}
			}
			
			String nowDate = commonUtil.getTodayUTCTime("");
			nowDate = EgovDateUtil.addDay(nowDate, -1, "yyyy-MM-dd HH:mm:ss");
			
			strHTML.append(commonUtil.cleanValue(cBoard.getTitle().trim())+"</span>");

			if (cBoard.getWriteDay().compareTo(nowDate) >= 0) {
				strHTML.append("<span class='board_new'></span>");
			}

			strHTML.append("</div></td>");

			if (userInfo.getPrimary().equals("1")) {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName().trim() + "</td>");
			} else {
				strHTML.append("<td class=\"t1\" width=\"70px\" >" + cBoard.getUserName2().trim() + "</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"90px\" >" + cBoard.getWriteDay().substring(0, 10) + "</td>");
			 
			if (iColSpan == 6) {
				strHTML.append("<td class=\"t1\" >");
				
				if (cBoard.getCharFileName().equals("")) {
					strHTML.append("<img src=\"/images/i_save01.gif\" width=\"12\" height=\"12\" border=\"0\">");
				}
				
				strHTML.append("</td>");
			}
			
			strHTML.append("<td class=\"t1\" width=\"60px\" >" + cBoard.getReadNum() + "</td>");
			strHTML.append("</tr>");
			
			iOutputCount++;
			itemNum++;
		}
		
		if (cBoardList.size() == 0) {
			strHTML.append("<tr>");
			strHTML.append("<td colspan='5' style='text-align:center;'>" + egovMessageSource.getMessage("main.t00026", userInfo.getLocale()) + "</td>");
			strHTML.append("</tr>");
		}
		
		return strHTML.toString();
	}
	
	/* 2020-01-06 홍승비 - 폐쇄한 커뮤니티 검색 시 폐쇄사유 추가 */
	//2018-02-06 김혜정 - 폐쇄된 커뮤니티 갯수
	@Override
	public int getClosedCommuListCount(String lang, Locale locale, String searchType2, String searchValue, String companyId, int tenantId) throws Exception {
		logger.debug("getClosedCommuListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_PCLOSESTATE", "1");
		map.put("v_SEARCHTYPE2", searchType2);
		map.put("v_STRQUERY", searchValue);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int result = ezCommunityAdminDAO.getClosedCommuListCount(map);
		
		logger.debug("getClosedCommuListCount ended.");
		
		return result;
	}

	/* 2020-01-06 홍승비 - 폐쇄한 커뮤니티 검색 시 폐쇄사유 추가 */
	//2018-02-06 김혜정 - 폐쇄된 커뮤니티 리스트
	@Override
	public List<CommunityCComCloseVO> getClosedCommuList(String primary, Locale locale, int pageNum, String searchType2, String searchValue, String offSetMin, String companyId, int tenantId) throws Exception {
		logger.debug("getClosedCommuList started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("primary", primary);
		map.put("v_PCLOSESTATE", "1");
		map.put("v_SEARCHTYPE2", searchType2);
		map.put("v_STRQUERY", searchValue);
		map.put("v_STARTROW", 10 * (pageNum - 1));
		map.put("v_OFFSETMIN", offSetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<CommunityCComCloseVO> list = ezCommunityAdminDAO.getClosedCommuList(map);
		
		logger.debug("getClosedCommuList ended.");
		
		return list;
	}

	//2019-01-17 김헤정 - 폐쇄된 커뮤니티 리스트 상세정보
	@Override
	public CommunityCComCloseVO closeCommunityInfo(String lang, String code, String offSetMin, String companyId, int tenantId) throws Exception {
		logger.debug("closeCommunityInfo ended.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERINFO_LANG", lang);
		map.put("v_CODE", code);
		map.put("v_OFFSETMIN", offSetMin);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		CommunityCComCloseVO vo = ezCommunityAdminDAO.closeCommunityInfo(map);
		
		logger.debug("closeCommunityInfo ended.");
		return vo;
	}
	
	//2019-01-18 김혜정 - 커뮤니티 관리자 > 폐쇄 실행
	@Override
	public void adminCommCloseAll(String code, String reason, Locale locale, int tenantId) throws Exception {
		logger.debug("adminCommCloseAll started.");
		
		aspCommCloseAllDel(code, tenantId);
		aspAdminCommCloseAllUpdate(code, locale, reason, tenantId);
		
		logger.debug("adminCommCloseAll ended.");
	}
	
	private void aspAdminCommCloseAllUpdate(String code, Locale locale, String reason, int tenantId) throws Exception {
		logger.debug("aspAdminCommCloseAllUpdate started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_REASON", reason);
		map.put("v_PCLOSESTATE", "1");
		map.put("tenantID", tenantId);
		
		ezCommunityAdminDAO.aspAdminCommCloseAllUpdate(map);
		
		logger.debug("aspAdminCommCloseAllUpdate ended.");
	}
}
