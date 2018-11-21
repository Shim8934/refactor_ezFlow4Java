package egovframework.ezEKP.ezPersonal.service.impl;

import java.lang.reflect.Field;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
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
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopopConfigVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalSliderImageVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("EzPersonalAdminService")
public class EzPersonalAdminServiceImpl extends EgovAbstractServiceImpl implements EzPersonalAdminService {
	private static final Logger logger = LoggerFactory.getLogger(EzPersonalAdminServiceImpl.class);
	
	@Autowired
	private Properties globals;
	
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
		logger.debug("getNoticeCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		map.put("tenantID", tenantID);

		logger.debug("getNoticeCount ended");
		return ezPersonalAdminDAO.getNoticeCount(map);
	}
	
	@Override
	public int getNoticeCountUser(String companyID, int tenantID) throws Exception {
		logger.debug("getNoticeCountUser started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "U");
		map.put("tenantID", tenantID);

		logger.debug("getNoticeCountUser ended");
		return ezPersonalAdminDAO.getNoticeCount(map);
	}

	@Override
	public List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart, int tenantID) throws Exception {
		logger.debug("getNoticeList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", pStart);
		map.put("tenantID", tenantID);

		logger.debug("getNoticeList ended");
		return ezPersonalAdminDAO.getNoticeList(map);
	}

	@Override
	public String deleteNotice(String itemSeq, int tenantID) throws Exception {
		logger.debug("deleteNotice started");

		try {
			Map<String, Object> map = new HashMap<String, Object>();
			
			map.put("v_pItemSeq", itemSeq);
			map.put("tenantID", tenantID);
			
			ezPersonalAdminDAO.deleteNotice(map);
			
			logger.debug("deleteNotice ended");
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
	}

	@Override
	public PersonalNoticeVO getNoticeInfo(String itemSeq, int tenantID) throws Exception {
		logger.debug("getNoticeInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getNoticeInfo ended");
		return ezPersonalAdminDAO.getNoticeInfo(map);
	}

	@Override
	public String insertNotice(String companyID, String title, String title2, String content, int tenantID) throws Exception {
		logger.debug("insertNotice started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyID", companyID);
		map.put("v_pTitle", title);
		map.put("v_pTitle2", title2);
		map.put("v_pContent", content.replace("\"", "\'"));
		
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
		logger.debug("updateNotice started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pTitle", title);
		map.put("v_pTitle2", title2);
		map.put("v_pContent", content.replace("\"", "\'"));
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);
		
		try {
			ezPersonalAdminDAO.updateNotice(map);
			
			logger.debug("updateNotice ended");
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
	}

	@Override
	public List<PersonalQuickLinkVO> getQuickLinkList(LoginVO userInfo, String lang) throws Exception {
		logger.debug("getQuickLinkList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		map.put("lang", userInfo.getLang());
		
		List<PersonalQuickLinkVO> list = ezPersonalAdminDAO.getQuickLinkList(map);
		for (PersonalQuickLinkVO vo : list) {
			vo.setRegDate(commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false));
			
			if (vo.getModiDate() != null) {
				vo.setModiDate(commonUtil.getDateStringInUTC(vo.getModiDate(), userInfo.getOffset(), false));
			}
		}
		
		logger.debug("getQuickLinkList ended");
		return list;
	}

	@Override
	public PersonalQuickLinkVO getQuickLink(String quickLinkID, int tenantID) throws Exception {
		logger.debug("getQuickLink started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("tenantID", tenantID);
		
		PersonalQuickLinkVO vo = ezPersonalAdminDAO.getQuickLink(map);
		
		//String result = "<DATA>" + commonUtil.getQueryResult(vo) + "</DATA>";

		logger.debug("getQuickLink ended");
		return vo;
	}

	@Override
	public String getQuickLinkACL(String quickLinkID, int tenantID) throws Exception {
		logger.debug("getQuickLinkACL started");

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
					result.append("<PERMISSIONS>" + commonUtil.cleanValue(String.valueOf(field.get(vo))) + "</PERMISSIONS>");
				} else {
					result.append("<" + field.getName().toUpperCase() + ">" + commonUtil.cleanValue(String.valueOf(field.get(vo))) + "</" + field.getName().toUpperCase() + ">");
				}
			}
			
			result.append("</NODE>");
		}
		
		result.append("</NODES>");

		logger.debug("getQuickLinkACL ended");
		return result.toString();
	}

	@Override
	public void saveQuickLink(LoginVO userInfo, Document doc) throws Exception {
		logger.debug("saveQuickLink started");

		String pQuickLinkID = doc.getElementsByTagName("pQuickLinkID").item(0).getTextContent();
		String pQuickLinkName = doc.getElementsByTagName("pQuickLinkName").item(0).getTextContent();
		String pQuickLinkName2 = doc.getElementsByTagName("pQuickLinkName2").item(0).getTextContent();
		String pQuickLinkName3 = doc.getElementsByTagName("pQuickLinkName3").item(0).getTextContent();
		String pLinkType= doc.getElementsByTagName("pLinkType").item(0).getTextContent();
		String pLinkTypeURL = doc.getElementsByTagName("pLinkTypeURL").item(0).getTextContent();
		String pMode = doc.getElementsByTagName("pMode").item(0).getTextContent();
		String pUrl= doc.getElementsByTagName("pURL").item(0).getTextContent();
		String pSize= doc.getElementsByTagName("pSize").item(0).getTextContent();
		
		setQuickLinkListXML(pQuickLinkID, pQuickLinkName, pQuickLinkName2, pQuickLinkName3, pLinkType, pLinkTypeURL, pMode, pUrl, pSize, userInfo.getId(), userInfo.getTenantId());
		
		if (doc.getElementsByTagName("node").getLength() == 0) {
			setQuickLinkACL(pQuickLinkID, "", "", "", "", "DEL", userInfo.getTenantId()); 
		}
		
		if (pMode.equals("modify")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("quickLinkID", pQuickLinkID);
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

		logger.debug("saveQuickLink ended");
	}

	@Override
	public int getPollCount(String companyID, int tenantID) throws Exception {
		logger.debug("getPollCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		map.put("tenantID", tenantID);

		logger.debug("getPollCount ended");
		return ezPersonalAdminDAO.getPollCount(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollList(String companyID, int totalCount, int pageSize, int start, int tenantID) throws Exception {
		logger.debug("getPollList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", start);
		map.put("tenantID", tenantID);

		logger.debug("getPollList ended");
		return ezPersonalAdminDAO.getPollList(map);
	}

	@Override
	public String insertPoll(Document doc, int tenantID) throws Exception {
		logger.debug("insertPoll started");

		String companyID = doc.getElementsByTagName("COMPID").item(0).getTextContent();
		String selectCount = doc.getElementsByTagName("NUM").item(0).getTextContent();
		String pollTitle = doc.getElementsByTagName("TITLE").item(0).getTextContent();
		String pollTitle2 = doc.getElementsByTagName("TITLE2").item(0).getTextContent();
		// 2018-11-19 로직 수정 보류
		//String startDate = doc.getElementsByTagName("STARTDATE").item(0).getTextContent();
		//String endDate = doc.getElementsByTagName("ENDDATE").item(0).getTextContent();
		
		if (pollTitle2.equals("")) {
			pollTitle2 = pollTitle;
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID.toUpperCase());
		map.put("v_pSelectionCount", selectCount);
		map.put("v_pPollTitle", pollTitle);
		map.put("v_pPollTitle2", pollTitle2);
		// 2018-11-19 로직 수정 보류
		//map.put("startDate", startDate);
		//map.put("endDate", endDate);
		
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
			
			logger.debug("insertPoll ended");
			return "OK";
		} catch (Exception e) {
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public String deletePoll(String pollList, int tenantID) throws Exception {
		logger.debug("deletePoll started");
		
		try {
			for (String itemSeq : pollList.split(";")) {
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("v_pItemSeq", itemSeq);
				map.put("tenantID", tenantID);
				
				ezPersonalAdminDAO.deletePoll_D(map);
				ezPersonalAdminDAO.deletePoll(map);
			}
			
			logger.debug("deletePoll ended");
			return "OK";
		} catch (Exception e) {
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public PersonalLightPollVO getPollInfo(String itemSeq, int tenantID) throws Exception {
		logger.debug("getPollInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getPollInfo ended");
		return ezPersonalAdminDAO.getPollInfo(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollResult(String itemSeq, int tenantID) throws Exception {
		logger.debug("getPollResult started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getPollResult ended");
		return ezPersonalAdminDAO.getPollResult(map);
	}

	@Override
	public List<PersonalPopupVO> getPopupList(String companyID, int totalCount, int pageSize, int start, int tenantID) throws Exception {
		logger.debug("getPopupList started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", start);
		map.put("tenantID", tenantID);
		
		logger.debug("getPopupList ended");
		return ezPersonalAdminDAO.getPopupList(map);
	}

	@Override
	public PersonalPopupVO getPopupInfo(String itemSeq, int tenantID) throws Exception {
		logger.debug("getPopupInfo started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", itemSeq);
		map.put("tenantID", tenantID);

		logger.debug("getPopupInfo ended");
		return ezPersonalAdminDAO.getPopupInfo(map);
	}

	@Override
	public void insertPopup(PersonalPopupVO vo, int tenantID, String offset) throws Exception {
		logger.debug("insertPopup started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", vo.getCompanyID());
		map.put("v_pStartDate", vo.getStartDate());
		map.put("v_pEndDate", vo.getEndDate());
		map.put("v_pWidth", vo.getWidth());
		map.put("v_pHeight", vo.getHeight());
		map.put("v_pPosition", vo.getPosition());
		map.put("v_pTitle", vo.getTitle());
		map.put("v_pTitle2", vo.getTitle2());
		map.put("v_pContent", vo.getContent().replace("\"", "\'"));
		map.put("tenantID", tenantID);

		ezPersonalAdminDAO.insertPopup(map);
		logger.debug("insertPopup ended");
	}

	@Override
	public void updatePopup(PersonalPopupVO vo, int tenantID, String offset) throws Exception {
		logger.debug("updatePopup started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pItemSeq", vo.getItemSeq());
		map.put("v_pStartDate", vo.getStartDate());
		map.put("v_pEndDate", vo.getEndDate());
		map.put("v_pWidth", vo.getWidth());
		map.put("v_pHeight", vo.getHeight());
		map.put("v_pPosition", vo.getPosition());
		map.put("v_pTitle", vo.getTitle());
		map.put("v_pTitle2", vo.getTitle2());
		map.put("v_pContent", vo.getContent().replace("\"", "\'"));
		map.put("tenantID", tenantID);

		ezPersonalAdminDAO.updatePopup(map);
		logger.debug("updatePopup ended");
	}

	@Override
	public void deletePopup(String popupList, int tenantID) throws Exception {
		logger.debug("deletePopup started");

		Map<String, Object> map = new HashMap<String, Object>();
		for(String itemSeq : popupList.split(";")) {
			map.put("v_pItemSeq", itemSeq);
			map.put("tenantID", tenantID);
			ezPersonalAdminDAO.deletePopup(map);
		}
		logger.debug("deletePopup ended");
	}

	@Override
	public List<PersonalEmpMonthVO> getEmpMonth(String companyID, int tenantID) throws Exception {
		logger.debug("getEmpMonth started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("tenantID", tenantID);

		logger.debug("getEmpMonth ended");
		return ezPersonalAdminDAO.getEmployeeMonth(map);
	}

	@Override
	public void setEmpMonth(String type, String userID, String deptID, String term, LoginVO userInfo) throws Exception {
		logger.debug("setEmpMonth started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pType", type);
		map.put("v_pUserID", userID);
		map.put("v_pDeptID", deptID);
		map.put("v_pTerm", term);
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		
		if (type != null && type.equals("INS")) {
			ezPersonalAdminDAO.setEmployeeMonth_I(map);
		} else {
			ezPersonalAdminDAO.setEmployeeMonth_D(map);
		}

		logger.debug("setEmpMonth ended");
	}

	@Override
	public List<PersonalSliderImageVO> getSlider(String sliderID, LoginVO userInfo) throws Exception {
		logger.debug("getSlider started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_MODE", "ADMIN");
		map.put("sliderID", sliderID);
		map.put("tenantID", userInfo.getTenantId());
		
		List<PersonalSliderImageVO> list = ezPersonalAdminDAO.getSliderList(map);
		/*// 18-05-10 김민성 - 관리자 > 슬라이드 이미지 url 추가
		if (sliderID.equals(" ")) {
			result.append("<LISTVIEWDATA>");
			result.append("<HEADERS>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.t937", userInfo.getLocale()) + "</NAME><WIDTH>30</WIDTH><COLNAME>ISUSE</COLNAME></HEADER>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.t9", userInfo.getLocale()) + "</NAME><WIDTH>200</WIDTH><COLNAME>SLIDERNAME</COLNAME></HEADER>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.t1024", userInfo.getLocale()) + "</NAME><WIDTH>130</WIDTH><COLNAME>REGDATE</COLNAME></HEADER>");
			result.append("<HEADER><NAME>" + egovMessageSource.getMessage("ezPersonal.kmsp01", userInfo.getLocale()) + "</NAME><WIDTH>200</WIDTH><COLNAME>URL</COLNAME></HEADER>");
			result.append("</HEADERS>");
			result.append("<ROWS>");
			
			for (PersonalSliderImageVO vo : list) {
				result.append("<ROW>");
				result.append("<CELL>");
				result.append("<VALUE>" + vo.getIsUse() + "</VALUE>");
				result.append("<DATA1>" + commonUtil.cleanValue(vo.getSliderID()) + "</DATA1>");
				result.append("<DATA2>" + commonUtil.cleanValue(vo.getImagePath().trim()) + "</DATA2>");
				result.append("<DATA3>" + commonUtil.cleanValue(vo.getRegUserID()) + "</DATA3>");
				result.append("<DATA4>" + commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false) + "</DATA4>");
				result.append("<DATA5>" + vo.getSn() + "</DATA5>");
				result.append("</CELL>");
				
				logger.debug("resulttest: "+commonUtil.cleanValue(vo.getSliderID())+"||"+commonUtil.cleanValue(vo.getImagePath().trim())+"||"+commonUtil.cleanValue(vo.getRegUserID())+"||"+commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false)+"||"+vo.getSn());
				if (userInfo.getPrimary().equals("1")) {
					result.append("<CELL>");
					result.append("<VALUE>" + commonUtil.cleanValue(vo.getSliderName()) + "</VALUE>");
					result.append("</CELL>");
				} else {
					result.append("<CELL>");
					result.append("<VALUE>" + commonUtil.cleanValue(vo.getSliderName2()) + "</VALUE>");
					result.append("</CELL>");
				}
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false) + "</VALUE>");
				result.append("</CELL>");
				// 18-05-18 김민성 - URL 탭 null일때 처리
				result.append("<CELL>");
				result.append("<VALUE>" + commonUtil.cleanValue(vo.getUrl()) + "</VALUE>");
				result.append("</CELL>");
				result.append("</ROW>");
				logger.debug("resulttest2: "+commonUtil.cleanValue(vo.getSliderName())+"||"+commonUtil.cleanValue(vo.getSliderName2())+"||"+commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false)+"||"+commonUtil.cleanValue(vo.getUrl()));
			}
			
			result.append("</ROWS>");
			result.append("</LISTVIEWDATA>");
		} else {
			for (PersonalSliderImageVO vo : list) {
				if (vo.getSliderID().equals(sliderID)) {
					vo.setImagePath(vo.getImagePath());
					result.append("<DATA>");
					result.append(commonUtil.getQueryResult(vo));
					result.append("</DATA>");
				}
			}
		}*/
		// 2018-11-14 문성업 - 데이터 그대로 전달 가능하게 수정
			for (PersonalSliderImageVO vo : list) {
				vo.setRegDate(commonUtil.getDateStringInUTC(vo.getRegDate(), userInfo.getOffset(), false));
			
				if (userInfo.getPrimary().equals("1")) {
					vo.setSliderName(commonUtil.cleanValue(vo.getSliderName()) );
				} else {
					vo.setSliderName2(commonUtil.cleanValue(vo.getSliderName2()) );
				}
			}
		logger.debug("Objects"+list);
		logger.debug("getSlider ended");
		return list;
	}

	// 18-05-10 김민성 - 슬라이드 이미지 등록 URL 컬럼 추가
	@Override
	public void setSliderImage(String sliderID, String displayName, String displayName2, String sliderPath, String fileName, String mode, LoginVO userInfo, String url) throws Exception {
		logger.debug("setSliderImage started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SLIDERID", sliderID);
		map.put("v_SLIDERNAME", displayName);
		map.put("v_SLIDERNAME2", displayName2);
		map.put("v_FILENAME", fileName);
		map.put("v_IMAGEPATH", sliderPath);
		map.put("v_REGUSERID", userInfo.getId());
		map.put("v_URL", url);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String regDate = date.format(new Date());
		
		map.put("v_REGDATE", regDate);
		map.put("v_COMPANYID", userInfo.getCompanyID());
		map.put("v_MODE", mode);
		map.put("tenantID", userInfo.getTenantId());
		
		int count = ezPersonalAdminDAO.setSliderImage_S(map);
		
		map.put("count", count);
		
		if (mode != null && mode.equals("NEW")) {
			ezPersonalAdminDAO.setSliderImage_I(map);
		} else {
			ezPersonalAdminDAO.setSliderImage_U(map);
		}

		logger.debug("setSliderImage ended");
	}

	@Override
	public String statusChangeSlider1(String sliderID, String isUse, String mode, int tenantID) throws Exception {
		logger.debug("statusChangeSlider1 started");

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

		logger.debug("statusChangeSlider1 ended");
		return result;
	}

	@Override
	public String statusChangeSlider2(String aRuleID, String aPriority, String bRuleID, String bPriority, String mode, int tenantID) throws Exception {
		logger.debug("statusChangeSlider2 started");

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

		logger.debug("statusChangeSlider2 ended");
		return result;
	}
	
	@Override
	public void deleteSlider(String sliderID, int tenantID) throws Exception {
		logger.debug("deleteSlider started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_SLIDERID", sliderID);
		map.put("tenantID", tenantID);
		
		ezPersonalAdminDAO.delSliderImage_D(map);
		
		if (globals.getProperty("Globals.DbType").equals("oracle")) {
			ezPersonalAdminDAO.delSliderImage();
		} else if (globals.getProperty("Globals.DbType").equals("mysql")) {
			List<PersonalSliderImageVO> list = ezPersonalAdminDAO.delSliderImage_S(map);
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			
			for (int i=0; i<list.size(); i++) {
				map1.put("sliderID", list.get(i).getSliderID());
				map1.put("sn", list.get(i).getSn());
				map1.put("tenantID", tenantID);
				
				ezPersonalAdminDAO.delSliderImage_U(map1);
			}
		}

		logger.debug("deleteSlider ended");
	}
	
	@Override
	public void delQuickLink(String quickLinkID, int tenantID) throws Exception {
		logger.debug("delQuickLink started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("tenantID", tenantID);
		
		ezPersonalAdminDAO.delQuickLink_D(map);
		ezPersonalAdminDAO.delQuickLink(map);

		logger.debug("delQuickLink ended");
	}

	private void setQuickLinkListXML(String quickLinkID, String quickLinkName, String quickLinkName2, String quickLinkName3, String linkType, String linkTypeURL, String mode, String url, String size, String userID, int tenantID) throws Exception {
		logger.debug("setQuickLinkListXML started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_PMODE", mode);
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("v_QUICKLINKNAME", quickLinkName);
		map.put("v_QUICKLINKNAME2", quickLinkName2);
		map.put("v_QUICKLINKNAME3", quickLinkName3);
		map.put("v_LINKTYPE", linkType);
		map.put("v_LINKTYPEURL", linkTypeURL);
		map.put("v_URL", url);
		
		SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		date.setTimeZone(TimeZone.getTimeZone("GMT"));
		String nowDate = date.format(new Date());
		
		map.put("v_NOWDATE", nowDate);
		map.put("v_REGUSERID", userID);
		map.put("v_SIZE", size);
		map.put("tenantID", tenantID);
		
		if (mode != null && mode.equals("new")) {
			ezPersonalAdminDAO.setQuickLinkItem_I(map);
		} else {
			ezPersonalAdminDAO.setQuickLinkItem_U(map);
		}

		logger.debug("setQuickLinkListXML ended");
	}
	
	private void setQuickLinkACL(String quickLinkID, String accessID, String accessName, String accessName2, String viewFlag, String mode, int tenantID) throws Exception {
		logger.debug("setQuickLinkACL started");

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

		logger.debug("setQuickLinkACL ended");
	}

	@Override
	public PersonalLightPollConfigVO getLightPollConfig(String userId, int tenantId) throws Exception {
		logger.debug("getLightPollConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		PersonalLightPollConfigVO configVO = ezPersonalAdminDAO.getLightPollConfig(map);
		if(configVO == null) {
			// insert 후 다시 조회
			logger.debug("insertLightPollConfig started");
			ezPersonalAdminDAO.insertLightPollConfig(map);
			configVO = ezPersonalAdminDAO.getLightPollConfig(map);
			logger.debug("insertLightPollConfig ended");
		}		
		logger.debug("getLightPollConfig ended");
		return configVO;
	}
	
	@Override
	public void setLightPollConfig(String userId, String isPreview, int tenantId) throws Exception {
		logger.debug("setLightPollConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("isPreview", isPreview);
		map.put("tenantId", tenantId);
		
		ezPersonalAdminDAO.setLightPollConfig(map);
		logger.debug("setLightPollConfig ended");
	}

	@Override
	public PersonalPopopConfigVO getPopupConfig(String userId, int tenantId) throws Exception {
		logger.debug("getPopupConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		
		PersonalPopopConfigVO configVO = ezPersonalAdminDAO.getPopupConfig(map);
		if(configVO == null) {
			// insert 후 다시 조회
			logger.debug("insertPopupConfig started");
			ezPersonalAdminDAO.insertPopupConfig(map);
			configVO = ezPersonalAdminDAO.getPopupConfig(map);
			logger.debug("insertPopupConfig ended");
		}
		logger.debug("getPopupConfig ended");
		return configVO;
	}

	@Override
	public void setPopupConfig(String userId, String isPreview, int tenantId) throws Exception {
		logger.debug("setPopupConfig started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("isPreview", isPreview);
		map.put("tenantId", tenantId);
		
		ezPersonalAdminDAO.setPopupConfig(map);
		logger.debug("setPopupConfig ended");
	}
	
	@Override
	public int getPopupCount(String companyID, int tenantID) throws Exception {
		logger.debug("getPopupCount started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		map.put("tenantID", tenantID);

		logger.debug("getPopupCount ended");
		return ezPersonalAdminDAO.getPopupCount(map);
	}
}