package egovframework.ezEKP.ezPersonal.service.impl;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TimeZone;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalAdminDAO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.vo.PersonalEmpMonthVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.ezEKP.ezPortal.service.impl.EzPortalAdminServiceImpl;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPersonalAdminService")
public class EzPersonalAdminServiceImpl extends EgovAbstractServiceImpl implements EzPersonalAdminService {
	private static final Logger logger = LoggerFactory.getLogger(EzPersonalAdminServiceImpl.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzPersonalAdminDAO")
	private EzPersonalAdminDAO ezPersonalAdminDAO;
	
	@Resource(name="EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Override
	public int getNoticeCount(String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getNoticeCount(map);
	}

	@Override
	public List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", pStart);
		map.put("tenantID", tenantID);
		
		return ezPersonalAdminDAO.getNoticeList(map);
	}

	@Override
	public String deleteNotice(String itemSeq, int tenantID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pItemSeq", itemSeq);
			map.put("tenantID", tenantID);
			ezPersonalAdminDAO.deleteNotice(map);
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
	}

	@Override
	public PersonalNoticeVO getNoticeInfo(String itemSeq, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getNoticeInfo(map);
	}

	@Override
	public String insertNotice(String companyID, String title, String title2, String content, int tenantID) throws Exception {
		logger.debug("insertNotice started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_pTitle", title);
		map.put("v_pTitle2", title2);
		map.put("v_pContent", content);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		try {
			ezPersonalAdminDAO.insertNotice(map);
			logger.debug("insertNotice ended");
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}

		
		
	}

	@Override
	public String updateNotice(String companyID, String title, String title2, String content, Integer itemSeq, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pTitle", title);
		map.put("v_pTitle2", title2);
		map.put("v_pContent", content);
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		
		try {
			ezPersonalAdminDAO.updateNotice(map);
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
	}

	@Override
	public String getQuickLinkList(LoginVO userInfo) throws Exception {
		StringBuilder result = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantID", userInfo.getTenantId());
		List<PersonalQuickLinkVO> list = ezPersonalAdminDAO.getQuickLinkList(map);
		
		result.append("<LISTVIEWDATA>");
		result.append("<ROWS>");
		
		for(PersonalQuickLinkVO vo : list) {
			result.append("<ROW>");
			result.append("<CELL><VALUE>" + vo.getQuickLinkName() + "</VALUE>");
			result.append("<DATA1>" + vo.getQuickLinkID() + "</DATA1></CELL>");
			
			result.append("<CELL><VALUE>" + vo.getQuickLinkName2() + "</VALUE></CELL>");
			result.append("<CELL><VALUE>" + vo.getQuickLinkName3() + "</VALUE></CELL>");
			result.append("<CELL><VALUE>" + vo.getQuickLinkName4() + "</VALUE></CELL>");
			result.append("<CELL><VALUE>" + vo.getLinkType() + "</VALUE></CELL>");
			result.append("<CELL><VALUE><![CDATA[" + vo.getUrl() + "]]></VALUE></CELL>");
			result.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false) + "</VALUE></CELL>");
			
			if (vo.getModiDate() == null) {
				result.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				result.append("<CELL><VALUE>" + commonUtil.getDateStringInUTC(vo.getModiDate(), userInfo.getOffset(), false) + "</VALUE></CELL>");
			}
			
			result.append("<CELL><VALUE>" + vo.getDisplayName() + "</VALUE></CELL>");
			result.append("</ROW>");
		}
		
		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");
		
		return result.toString();
	}

	@Override
	public String getQuickLink(String quickLinkID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("tenantID", tenantID);
		PersonalQuickLinkVO vo = ezPersonalAdminDAO.getQuickLink(map);
		
		String result = "<DATA>" + commonUtil.getQueryResult(vo) + "</DATA>";
		
		return result;
	}

	@Override
	public String getQuickLinkACL(String quickLinkID, int tenantID) throws Exception {
		StringBuilder result = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("tenantID", tenantID);
		List<PersonalQuickLinkVO> list = ezPersonalAdminDAO.getQuickLinkACL(map);
		
		result.append("<NODES>");
		for (PersonalQuickLinkVO vo : list) {
			result.append("<NODE>");
			
			for (Field field : vo.getClass().getDeclaredFields()) {
		        field.setAccessible(true);
									
				if (field.getName().toUpperCase().equals("VIEW_FLAG")) {
					result.append("<PERMISSIONS>" + String.valueOf(field.get(vo)) + "</PERMISSIONS>");
				} else {
					result.append("<" + field.getName().toUpperCase() + ">" + String.valueOf(field.get(vo)) + "</" + field.getName().toUpperCase() + ">");
				}
		    }
			result.append("</NODE>");
		}
		result.append("</NODES>");
		
		return result.toString();
	}

	@Override
	public void saveQuickLink(LoginVO userInfo, Document doc) throws Exception {
		String pQuickLinkID = doc.getElementsByTagName("pQuickLinkID").item(0).getTextContent();
		String pQuickLinkName = doc.getElementsByTagName("pQuickLinkName").item(0).getTextContent();
		String pQuickLinkName2 = doc.getElementsByTagName("pQuickLinkName2").item(0).getTextContent();
		String pQuickLinkName3 = doc.getElementsByTagName("pQuickLinkName3").item(0).getTextContent();
		String pQuickLinkName4 = doc.getElementsByTagName("pQuickLinkName4").item(0).getTextContent();
		String pLinkType= doc.getElementsByTagName("pLinkType").item(0).getTextContent();
		String pLinkTypeURL = doc.getElementsByTagName("pLinkTypeURL").item(0).getTextContent();
		String pMode = doc.getElementsByTagName("pMode").item(0).getTextContent();
		String pUrl= doc.getElementsByTagName("pURL").item(0).getTextContent();
		String pSize= doc.getElementsByTagName("pSize").item(0).getTextContent();
		
		setQuickLinkListXML(pQuickLinkID, pQuickLinkName, pQuickLinkName2, pQuickLinkName3, pQuickLinkName4, pLinkType, pLinkTypeURL, pMode, pUrl, pSize, userInfo.getId(), userInfo.getTenantId());
		
		if (doc.getElementsByTagName("node").getLength() == 0) {
			setQuickLinkACL(pQuickLinkID, "", "", "", "", "DEL", userInfo.getTenantId()); 
		}
		
		if (pMode.equals("modify")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_QUICKLINKID", pQuickLinkID);
			map.put("tenantID", userInfo.getTenantId());
			ezPersonalAdminDAO.deleteQuickLinkID(map);
		}
		
		for (int i = 0; i < doc.getElementsByTagName("node").getLength(); i++) {
			String accessName = doc.getElementsByTagName("node").item(i).getChildNodes().item(0).getTextContent();
			String accessID = doc.getElementsByTagName("node").item(i).getChildNodes().item(1).getTextContent();
			String accessName2 = doc.getElementsByTagName("node").item(i).getChildNodes().item(2).getTextContent();
			String viewFlag = doc.getElementsByTagName("node").item(i).getChildNodes().item(3).getTextContent();
			String quickLinkID = doc.getElementsByTagName("node").item(i).getChildNodes().item(4).getTextContent();
			String mode = doc.getElementsByTagName("node").item(i).getChildNodes().item(6).getTextContent();
			
			setQuickLinkACL(quickLinkID, accessID, accessName, accessName2, viewFlag, mode, userInfo.getTenantId());
		}
	}

	@Override
	public int getPollCount(String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getPollCount(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollList(String companyID, int totalCount, int pageSize, int start, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID.toUpperCase());
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", start);
		map.put("tenantID", tenantID);
		
		return ezPersonalAdminDAO.getPollList(map);
	}

	@Override
	public String insertPoll(Document doc, int tenantID) throws Exception {
		String companyID = doc.getElementsByTagName("COMPID").item(0).getTextContent();
		String selectCount = doc.getElementsByTagName("NUM").item(0).getTextContent();
		String pollTitle = doc.getElementsByTagName("TITLE").item(0).getTextContent();
		String pollTitle2 = doc.getElementsByTagName("TITLE2").item(0).getTextContent();
		
		if (pollTitle2.equals("")) {
			pollTitle2 = pollTitle;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID.toUpperCase());
		map.put("v_pSelectionCount", selectCount);
		map.put("v_pPollTitle", pollTitle);
		map.put("v_pPollTitle2", pollTitle2);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		map.put("nowDate", nowDate);
		map.put("tenantID", tenantID);
		
		for (int i = 0; i < Integer.parseInt(selectCount); i++) {
			map.put("v_pAnswer" + (i + 1), doc.getElementsByTagName("ANSWER").item(i).getTextContent());
		}
		
		for (int i = Integer.parseInt(selectCount); i < 10; i++) {
			map.put("v_pAnswer" + (i + 1), " ");
		}
		
		try {
			if (companyID != null && companyID.equals("Top")) {
				ezPersonalAdminDAO.insertPoll_U1(map);
			} else {
				ezPersonalAdminDAO.insertPoll_U2(map);
			}
			
			if (companyID != null && companyID.equals("Top")) {
				ezPersonalAdminDAO.insertPoll_I1(map);
			} else {
				ezPersonalAdminDAO.insertPoll_I2(map);
			}
			
			//ezPersonalAdminDAO.insertPoll(map);
			return "OK";
		} catch (Exception e) {
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public String deletePoll(String itemSeq, int tenantID) throws Exception {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_pItemSeq", itemSeq);
			map.put("tenantID", tenantID);
			ezPersonalAdminDAO.deletePoll_D(map);
			ezPersonalAdminDAO.deletePoll(map);
			return "OK";
		} catch (Exception e) {
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public PersonalLightPollVO getPollInfo(String itemSeq, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getPollInfo(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollResult(String itemSeq, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getPollResult(map);
	}

	@Override
	public List<PersonalPopupVO> getPopupList(String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);	
		return ezPersonalAdminDAO.getPopupList(map);
	}

	@Override
	public PersonalPopupVO getPopupInfo(String itemSeq, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getPopupInfo(map);
	}

	@Override
	public void insertPopup(PersonalPopupVO vo, int tenantID, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", vo.getCompanyID());
		map.put("v_pStartDate", commonUtil.getDateStringInUTC(vo.getStartDate(), offset, true));
		map.put("v_pEndDate", commonUtil.getDateStringInUTC(vo.getEndDate(), offset, true));
		map.put("v_pWidth", vo.getWidth());
		map.put("v_pHeight", vo.getHeight());
		map.put("v_pPosition", vo.getPosition());
		map.put("v_pTitle", vo.getTitle());
		map.put("v_pTitle2", vo.getTitle2());
		map.put("v_pContent", vo.getContent());
		map.put("tenantID", tenantID);
		
		ezPersonalAdminDAO.insertPopup(map);
	}

	@Override
	public void updatePopup(PersonalPopupVO vo, int tenantID, String offset) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", vo.getItemSeq());
		map.put("v_pStartDate", commonUtil.getDateStringInUTC(vo.getStartDate(), offset, true));
		map.put("v_pEndDate", commonUtil.getDateStringInUTC(vo.getEndDate(), offset, true));
		map.put("v_pWidth", vo.getWidth());
		map.put("v_pHeight", vo.getHeight());
		map.put("v_pPosition", vo.getPosition());
		map.put("v_pTitle", vo.getTitle());
		map.put("v_pTitle2", vo.getTitle2());
		map.put("v_pContent", vo.getContent());
		map.put("tenantID", tenantID);
		
		ezPersonalAdminDAO.updatePopup(map);
	}

	@Override
	public void deletePopup(String itemSeq, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		ezPersonalAdminDAO.deletePopup(map);
	}
	

	@Override
	public List<PersonalEmpMonthVO> getEmpMonth(String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);
		return ezPersonalAdminDAO.getEmployeeMonth(map);
	}

	@Override
	public void setEmpMonth(String type, String userID, String deptID, String term, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pType", type);
		map.put("v_pUserID", userID);
		map.put("v_pDeptID", deptID);
		map.put("v_pTerm", term);
		map.put("tenantID", tenantID);
		
		if (type != null && type.equals("INS")) {
			ezPersonalAdminDAO.setEmployeeMonth_I(map);
		} else {
			ezPersonalAdminDAO.setEmployeeMonth_D(map);
		}
		
	}

	@Override
	public String getSlider(String sliderID, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_MODE", "ADMIN");
		map.put("sliderID", sliderID);
		map.put("tenantID", userInfo.getTenantId());
		
		List<PersonalSliderImageVO> list = ezPersonalAdminDAO.getSliderList(map);
		
		StringBuilder result = new StringBuilder();
		
		if (sliderID.equals(" ")) {
			result.append("<LISTVIEWDATA>");
			result.append("<HEADERS>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.t937", userInfo.getLocale()) + "</NAME><WIDTH>30</WIDTH><COLNAME>ISUSE</COLNAME></HEADER>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.t9", userInfo.getLocale()) + "</NAME><WIDTH>250</WIDTH><COLNAME>SLIDERNAME</COLNAME></HEADER>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.t1024", userInfo.getLocale()) + "</NAME><WIDTH>130</WIDTH><COLNAME>REGDATE</COLNAME></HEADER>");
			result.append("</HEADERS>");
			
			result.append("<ROWS>");
			for (PersonalSliderImageVO vo : list) {
				result.append("<ROW>");
				result.append("<CELL>");
				result.append("<VALUE>" + vo.getIsUse() + "</VALUE>");
				result.append("<DATA1>" + vo.getSliderID() + "</DATA1>");
				result.append("<DATA2>" + vo.getImagePath().trim() + "</DATA2>");
				result.append("<DATA3>" + vo.getRegUserID() + "</DATA3>");
				result.append("<DATA4>" + commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false) + "</DATA4>");
				result.append("<DATA5>" + vo.getSn() + "</DATA5>");
				result.append("</CELL>");
				
				if (userInfo.getLang().equals("1")) {
					result.append("<CELL>");
					result.append("<VALUE>" + vo.getSliderName() + "</VALUE>");
					result.append("</CELL>");
				} else {
					result.append("<CELL>");
					result.append("<VALUE>" + vo.getSliderName2() + "</VALUE>");
					result.append("</CELL>");
				}
				
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false) + "</VALUE>");
				result.append("</CELL>");
				
				result.append("</ROW>");
			}
			result.append("</ROWS>");
			result.append("</LISTVIEWDATA>");
		} else {
			if (list.size() == 1) {
				list.get(0).setImagePath(list.get(0).getImagePath());
				result.append("<DATA>");
				result.append(commonUtil.getQueryResult(list.get(0)));
				result.append("</DATA>");
			}
		}
		
		return result.toString();
	}

	@Override
	public void setSliderImage(String sliderID, String displayName, String displayName2, String sliderPath, String fileName, String mode, LoginVO userInfo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SLIDERID", sliderID);
		map.put("v_SLIDERNAME", displayName);
		map.put("v_SLIDERNAME2", displayName2);
		map.put("v_FILENAME", fileName);
		map.put("v_IMAGEPATH", sliderPath);
		map.put("v_REGUSERID", userInfo.getId());
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String regDate = date.format(new Date());
		
		//map.put("v_REGDATE", EgovDateUtil.getTodayTime());
		map.put("v_REGDATE", regDate);
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_MODE", mode);
		
		int count = ezPersonalAdminDAO.setSliderImage_S(map);
		
		map.put("count", count);
		map.put("tenantID", userInfo.getTenantId());
		
		if (mode != null && mode.equals("NEW")) {
			ezPersonalAdminDAO.setSliderImage_I(map);
		} else {
			ezPersonalAdminDAO.setSliderImage_U(map);
		}
		
		//ezPersonalAdminDAO.setSliderImage(map);
	}

	@Override
	public String statusChangeSlider1(String sliderID, String isUse, String mode, int tenantID) throws Exception {
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SLIDERID", sliderID);
		map.put("v_VALUE", isUse);
		map.put("v_MODE", mode);
		map.put("tenantID", tenantID);
		
		try {
			ezPersonalAdminDAO.statusChangeSlider(map);
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR";
		}
		
		return result;
	}

	@Override
	public String statusChangeSlider2(String aRuleID, String aPriority, String bRuleID, String bPriority, String mode, int tenantID) throws Exception {
		String result = "";
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("v_SLIDERID", aRuleID);
		map1.put("v_VALUE", aPriority);
		map1.put("v_MODE", mode);
		map1.put("tenantID", tenantID);
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("v_SLIDERID", bRuleID);
		map2.put("v_VALUE", bPriority);
		map2.put("v_MODE", mode);
		map2.put("tenantID", tenantID);
		
		try {
			ezPersonalAdminDAO.statusChangeSlider(map1);
			ezPersonalAdminDAO.statusChangeSlider(map2);
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR";
		}
		
		return result;
	}
	
	@Override
	public void deleteSlider(String sliderID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SLIDERID", sliderID);
		map.put("tenantID", tenantID);
		ezPersonalAdminDAO.delSliderImage_D(map);
		ezPersonalAdminDAO.delSliderImage();
	}
	
	@Override
	public void delQuickLink(String quickLinkID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("tenantID", tenantID);
		ezPersonalAdminDAO.delQuickLink_D(map);
		ezPersonalAdminDAO.delQuickLink(map);
	}

	private void setQuickLinkListXML(String quickLinkID, String quickLinkName, String quickLinkName2, String quickLinkName3, String quickLinkName4, String linkType, String linkTypeURL, String mode, String url, String size, String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMODE", mode);
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("v_QUICKLINKNAME", quickLinkName);
		map.put("v_QUICKLINKNAME2", quickLinkName2);
		map.put("v_QUICKLINKNAME3", quickLinkName3);
		map.put("v_QUICKLINKNAME4", quickLinkName4);
		map.put("v_LINKTYPE", linkType);
		map.put("v_LINKTYPEURL", linkTypeURL);
		map.put("v_URL", url);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		//map.put("v_NOWDATE", EgovDateUtil.getToday("-"));
		map.put("v_NOWDATE", nowDate);
		map.put("v_REGUSERID", userID);
		map.put("v_SIZE", size);
		map.put("tenantID", tenantID);
		
		if (mode != null && mode.equals("new")) {
			ezPersonalAdminDAO.setQuickLinkItem_I(map);
		} else {
			ezPersonalAdminDAO.setQuickLinkItem_U(map);
		}
	}
	
	private void setQuickLinkACL(String quickLinkID, String accessID, String accessName, String accessName2, String viewFlag, String mode, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMODE", mode);
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("v_ACCESSID", accessID);
		map.put("v_ACCESSNAME", accessName);
		map.put("v_ACCESSNAME2", accessName2);
		map.put("v_VIEW_FLAG", viewFlag);
		map.put("tenantID", tenantID);
		
		if (mode != null && mode.equals("DEL")) {
			ezPersonalAdminDAO.setQuickLink_D(map);
		} else {
			ezPersonalAdminDAO.setQuickLink_I(map);
		}
		
	}
}
