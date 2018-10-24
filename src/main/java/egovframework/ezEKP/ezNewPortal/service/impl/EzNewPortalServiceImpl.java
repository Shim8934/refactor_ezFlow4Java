package egovframework.ezEKP.ezNewPortal.service.impl;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.codehaus.jackson.map.ObjectMapper;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.icu.text.SimpleDateFormat;
import com.ibm.icu.util.Calendar;
import com.ibm.icu.util.ChineseCalendar;

import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezBoard.vo.BoardItemVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCClubUserVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityMyCommunityVO;
import egovframework.ezEKP.ezNewPortal.dao.EzNewPortalDAO;
import egovframework.ezEKP.ezNewPortal.service.EzNewPortalService;
import egovframework.ezEKP.ezNewPortal.vo.FavoriteBoardVO;
import egovframework.ezEKP.ezNewPortal.vo.FrameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuAuthVO;
import egovframework.ezEKP.ezNewPortal.vo.MenuInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalUserInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.PortletNameInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.ThemeInfoVO;
import egovframework.ezEKP.ezNewPortal.vo.UserPortalSettingVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPoll.vo.PollAnswerVO;
import egovframework.ezEKP.ezPoll.vo.PollQuestionVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzNewPortalService")
public class EzNewPortalServiceImpl implements EzNewPortalService {
	private static final Logger LOGGER = LoggerFactory.getLogger(EzNewPortalServiceImpl.class);
	
	@Resource(name = "EzNewPortalDAO")
	private EzNewPortalDAO ezNewPortalDAO;
	
	@Autowired
	private CommonUtil commonUtil;
	
	public List<BoardListVO> getNoticePortletList(String companyId, int tenantId, int limit) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("portletId", 2); // 공지사항 포틀릿 ID 는 2
		
		return ezNewPortalDAO.getNoticePortletList(map);
	}
	@Override
	public PersonalLightPollVO getPollPortlet(String companyId, int tenantId, String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		return ezNewPortalDAO.getPollPortlet(map);
	}
	
	public List<PersonalLightPollVO> getPollPortletResult(String companyId, int tenantId, int itemSeq) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("itemSeq", itemSeq);
		
		return ezNewPortalDAO.getPollPortletResult(map);
	}
	
	public List<Map<String, Object>> getAssemblePollData(PersonalLightPollVO poll, List<PersonalLightPollVO> pollResult) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> answerList = new ArrayList<Map<String, Object>>();
		
		Field[] fields = poll.getClass().getDeclaredFields();
		for(int i=0; i<fields.length; i++) {
			fields[i].setAccessible(true);
			try {
				if (fields[i].getName().contains("answer")) {;
					map.put(fields[i].getName(), fields[i].get(poll));
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		for(int i=1; i<map.size(); i++) {
			Map<String, Object> answerMap = new HashMap<String, Object>();
			answerMap.put("result", i);
			answerMap.put("answer", map.get("answer"+(i)));
			
			Iterator<PersonalLightPollVO> it = pollResult.iterator();
			while (it.hasNext()) {
				PersonalLightPollVO vo = it.next();
				int result = vo.getResult();
				if(result == i) {
					answerMap.put("count", vo.getCount());
				}
			}
			
			answerList.add(answerMap);								
		}
		
		return answerList;
	}
	
	public String getPortalLogoInfo(String companyId, int tenantId, String logoType) throws Exception {
		LOGGER.debug("[Service] getPortalLogoInfo started");
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("logoType", logoType);
		LOGGER.debug("[Service] getPortalLogoInfo ended");
		return ezNewPortalDAO.getPortalLogoInfo(map);
	}
	
	public List<MenuInfoVO> getUserMenuList(String companyId, int tenantId, String langType, String userId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("langType", langType);
		map.put("userId", userId);
		return ezNewPortalDAO.getUserMenuList(map);
	}
	
	public List<MenuInfoVO> getCompanyMenuList(String companyId, int tenantId, String langType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("langType", langType);
		return ezNewPortalDAO.getCompanyMenuList(map);
	}
	
	@Override
	public int getVotePortletCount(String userId, String companyId, String deptPath, int tenantId) {
		LOGGER.debug("[Serivce] getVotePortletCount Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("[Serivce] getVotePortletCount Ended");
		return ezNewPortalDAO.getVotePortletCount(map);
	}

	@Override
	public PollQuestionVO getVotePortletInfo(String userId, String companyId, String deptPath, int tenantId) {
		LOGGER.debug("[Serivce] getVotePortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("deptPath", deptPath);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("[Serivce] getVotePortletInfo Ended");
		return ezNewPortalDAO.getVotePortletInfo(map);
	}

	@Override
	public List<PollAnswerVO> getVotePortletAnswer(int qstId, int tenantId) {
		LOGGER.debug("[Serivce] getVotePortletAnswer Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("qstId", qstId);
		map.put("tenantId", tenantId);

		LOGGER.debug("[Serivce] getVotePortletAnswer Ended");
		return ezNewPortalDAO.getVotePortletAnswer(map);
	}

	@Override
	public List<BoardItemVO> getPhotoBoardPortletInfo(int tenantId, String boardId, int startRow, int photoCount) {
		LOGGER.debug("[Serivce] getPhotoBoardPortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("startRow", startRow);
		map.put("photoCount", photoCount);

		LOGGER.debug("[Serivce] getPhotoBoardPortletInfo Ended");
		return ezNewPortalDAO.getphotoBoardPortletInfo(map);
	}

	@Override
	public PortletInfoVO getCompanyPortletInfo(String companyId, int tenantId, int portletId, String portletLang) {
		LOGGER.debug("[Serivce] getCompanyPortletInfo Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		map.put("portletLang", portletLang);

		LOGGER.debug("[Serivce] getCompanyPortletInfo Ended");
		return ezNewPortalDAO.getCompanyPortletInfo(map);
	}

	@Override
	public String getBoardAuthCheck(String boardId, String accessId, int tenantId, String companyId) {
		LOGGER.debug("[Serivce] getBoardAuthCheck Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("boardId", boardId);
		map.put("accessId", accessId);

		LOGGER.debug("[Serivce] getBoardAuthCheck Ended");
		return ezNewPortalDAO.getBoardAuthCheck(map);
	}

	@Override
	public List<PortletInfoVO> getPortletOrderUser(String portletLang, String userId, int tenantId, String companyId) {
		LOGGER.debug("[Serivce] getPortletOrderUser Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);

		LOGGER.debug("[Serivce] getPortletOrderUser Ended");
		return ezNewPortalDAO.getPortletOrderUser(map);
	}

	@Override
	public List<PortletInfoVO> getPortletOrderComp(String portletLang, int tenantId, String companyId) {
		LOGGER.debug("[Serivce] getPortletOrderComp Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<PortletInfoVO> portletOrderComp = ezNewPortalDAO.getPortletOrderComp(map);
		
		if (portletOrderComp == null || portletOrderComp.size() == 0) {
			map.put("order", "default");
			portletOrderComp = ezNewPortalDAO.getPortletOrderComp(map);
		}

		LOGGER.debug("[Serivce] getPortletOrderComp Ended");
		return portletOrderComp;
	}
	
	@Override
	public UserPortalSettingVO getUserPortalSetting(String userId, String companyId, int tenantId) {
		LOGGER.debug("[Serivce] getUserPortalSetting Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		UserPortalSettingVO userPortalSetting = ezNewPortalDAO.getUserPortalSetting(map);
		
		if (userPortalSetting == null) {
			userPortalSetting = ezNewPortalDAO.getCompPortalSetting(map);
			
			if (userPortalSetting == null) {
				UserPortalSettingVO tempSetting = new UserPortalSettingVO();
				tempSetting.setUsedFrame("Frame1");
				tempSetting.setUsedTheme(1);
				
				userPortalSetting = tempSetting;
			}
		}
		System.out.println(userPortalSetting.toString());
		LOGGER.debug("[Serivce] getUserPortalSetting Ended");
		return userPortalSetting;
	}
	
	@Override
	public void updatePortletOrderUser(String userId, String companyId, int tenantId,
			List<Map<String, Integer>> portletOrder, String portletLang) {
		LOGGER.debug("updatePortletOrderUser started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletLang", portletLang);

		int portletOrderCount = portletOrder.size();
		
		//portletOrder를 사용자가 설정한 정보가 있는지 확인
		List<PortletInfoVO> userPortletOrder = ezNewPortalDAO.getPortletOrderUser(map);

		if (userPortletOrder == null || userPortletOrder.isEmpty()) {//없으면 insert
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.insertPortletOrderUser(map);
			}
			
		} else {//있으면 update
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.updatePortletOrderUser(map);
			}
		}
		
		LOGGER.debug("updatePortletOrderUser ended.");
	}
	
	@Override
	public int getMonthlyBirthdayEmployeesCount(String companyId, int tenantId, int month) {
		LOGGER.debug("getMonthlyBirthdayEmployeesCount started.");
		String monthStr = "";
		
		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = String.valueOf(month);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("month", monthStr);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<PortalUserInfoVO> tempList = ezNewPortalDAO.getMonthlyBirthdayEmployees(map);
		int birthdayListCount = tempList.size();
		List<PortalUserInfoVO> birthdayList = new ArrayList<PortalUserInfoVO>();
		
		for (int i = 0; i < birthdayListCount; i++) {
			PortalUserInfoVO portalUserInfo = tempList.get(i);
			String imgPath = "";
			
			if (portalUserInfo.isSolar()) {
				if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
					imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
				} else {
					imgPath = "/images/default_pic.gif";
				}
				
				portalUserInfo.setUserImg(imgPath);
				birthdayList.add(portalUserInfo);
			} else {
				String toSolarDate = convertLunarToSolar(portalUserInfo.getUserBirthday(), month);
				
				if (!toSolarDate.equals("")) {
					if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
						imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
					} else {
						imgPath = "/images/default_pic.gif";
					}
					
					portalUserInfo.setUserBirthday(toSolarDate);
					portalUserInfo.setUserImg(imgPath);
					birthdayList.add(portalUserInfo);
				}
			}
		}
		
		int birthCount = 0;
		
		if (birthdayList.isEmpty() || birthdayList == null) {
			birthCount = 0;
		} else {
			birthCount = birthdayList.size();
		}

		LOGGER.debug("getMonthlyBirthdayEmployeesCount ended.");
		return birthCount;
	}
	
	@Override
	public List<PortalUserInfoVO> getMonthlyBirthdayEmployees(String companyId, int tenantId, int month, int count, int startRow) {
		LOGGER.debug("getMonthlyBirthdayEmployees started.");
		String monthStr = "";
		
		if (month < 10) {
			monthStr = "0" + month;
		} else {
			monthStr = String.valueOf(month);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("month", monthStr);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		List<PortalUserInfoVO> tempList = ezNewPortalDAO.getMonthlyBirthdayEmployees(map);
		int birthdayListCount = tempList.size();
		List<PortalUserInfoVO> birthdayList = new ArrayList<PortalUserInfoVO>();
		
		for (int i = 0; i < birthdayListCount; i++) {
			PortalUserInfoVO portalUserInfo = tempList.get(i);
			String imgPath = "";
			
			if (portalUserInfo.isSolar()) {
				if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
					imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
				} else {
					imgPath = "/images/default_pic.gif";
				}
				
				portalUserInfo.setUserImg(imgPath);
				birthdayList.add(portalUserInfo);
			} else {
				String toSolarDate = convertLunarToSolar(portalUserInfo.getUserBirthday(), month);
				
				if (!toSolarDate.equals("")) {
					if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
						imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
					} else {
						imgPath = "/images/default_pic.gif";
					}
					
					portalUserInfo.setUserBirthday(toSolarDate);
					portalUserInfo.setUserImg(imgPath);
					birthdayList.add(portalUserInfo);
				}
			}
		}
		
		int birthCount = birthdayList.size();
		
		//오름차순 정렬
		Collections.sort(birthdayList, new Comparator<PortalUserInfoVO>() {
			@Override
			public int compare(PortalUserInfoVO o1, PortalUserInfoVO o2) {
				return o1.getUserBirthday().split("-")[2].compareTo(o2.getUserBirthday().split("-")[2]);
			}
		});
		
		if (startRow > birthCount) {
			startRow = 0;
		}
		
		List<PortalUserInfoVO> birthdayListLmit = new ArrayList<PortalUserInfoVO>();
		
		for (int i = startRow; i < startRow + count; i++) {
			if (i < birthCount) {
				birthdayListLmit.add(birthdayList.get(i));
			}
		}
		
		LOGGER.debug("getMonthlyBirthdayEmployees ended.");
		return birthdayListLmit;
	}
	
	public String convertLunarToSolar (String birthday, int compMonth) {
		LOGGER.debug("convertLunarToSolar started.");
		String result = "";
		ChineseCalendar cc = new ChineseCalendar();
		Calendar cal = Calendar.getInstance();
		
		cc.set(ChineseCalendar.EXTENDED_YEAR, Integer.parseInt(birthday.substring(0, 4)) + 2637);
		cc.set(ChineseCalendar.MONTH, Integer.parseInt(birthday.substring(4, 6)) - 1);
		cc.set(ChineseCalendar.DAY_OF_MONTH, Integer.parseInt(birthday.substring(6)));

		cal.setTimeInMillis(cc.getTimeInMillis());

		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		result = sdf.format(cal.getTime());
		
		if (result.contains("-" + compMonth + "-")) {
			result = "";
		}
		
		LOGGER.debug("convertLunarToSolar ended.");
		return result;
	}
	
	@Override
	public PortalUserInfoVO getMonthlyBestEmployee(String yearAndMonth, String companyId, int tenantId ) {
		LOGGER.debug("getMonthlyBestEmployee started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("yearAndMonth", yearAndMonth);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		String imgPath = "";
		PortalUserInfoVO portalUserInfo = ezNewPortalDAO.getMonthlyBestEmployee(map);
		
		if (portalUserInfo.getUserImg() != null && !portalUserInfo.getUserImg().equals("")) {
			imgPath = "/ezCommon/downloadAttach.do?&filePath="+ commonUtil.getUploadPath("upload_personal.PHOTO", tenantId) + commonUtil.separator + portalUserInfo.getUserImg();
		} else {
			imgPath = "/images/default_pic.gif";
		}
		
		portalUserInfo.setUserImg(imgPath);
		
		LOGGER.debug("getMonthlyBestEmployee ended.");
		return portalUserInfo;
	}

	@Override
	public List<ThemeInfoVO> getUserThemeList(String companyId, int tenantId) {
		LOGGER.debug("getUserThemeList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		LOGGER.debug("getUserThemeList ended.");
		return ezNewPortalDAO.getUserThemeList(map);
	}
	

	public MenuInfoVO getUserStartPage (String userId, int tenantId, String companyId) {
		LOGGER.debug("getUserStartPage started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		LOGGER.debug("getUserStartPage ended.");
		return ezNewPortalDAO.getUserStartPage(map);
	}
	
	public void updateUserStartPage(int menuId, String userId, int tenantId, String companyId) {
		LOGGER.debug("updateUserStartPage started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("menuId", menuId);
		
		MenuInfoVO userStartPage = ezNewPortalDAO.getUserStartPage(map);
		
		if (userStartPage == null) {
			LOGGER.debug("DAO insertUserStartPage started.");
			ezNewPortalDAO.insertUserStartPage(map);
		} else {
			LOGGER.debug("DAO updateUserStartPage started.");
			ezNewPortalDAO.updateUserStartPage(map);
		}
		
		
		LOGGER.debug("updateUserStartPage ended.");
	}
	
	public void deleteUserThemeSetting(String userId, int tenantId, String companyId) { 
		LOGGER.debug("deleteUserThemeSetting started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		ezNewPortalDAO.deleteUserThemeSetting(map);
		LOGGER.debug("deleteUserThemeSetting ended.");
	}
	
	public void updateUserThemeSetting(int usedTheme, int usedFrame, String userId, int tenantId, String companyId) {
		LOGGER.debug("updateUserThemeSetting started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("usedTheme", usedTheme);
		map.put("usedFrame", usedFrame);
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		
		UserPortalSettingVO portalSetting = ezNewPortalDAO.getUserPortalSetting(map);
		
		if (portalSetting == null) {
			LOGGER.debug("DAO insertUserThemeSetting started.");
			ezNewPortalDAO.insertUserThemeSetting(map);
		} else {
			LOGGER.debug("DAO updateUserThemeSetting started.");
			ezNewPortalDAO.updateUserThemeSetting(map);
		}
		
		LOGGER.debug("updateUserThemeSetting ended.");
	}
	
	/**
	 * 이효진
	 */
	@Override
	public Map<String, Object> getApprovalList(String userId, String companyId, int tenantId, String offset, String type) throws Exception {
		LOGGER.debug("getApprovalList started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || type = " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offset",commonUtil.getMinuteUTC(offset));
		
		List<ApprGDocListVO> list = null;
		Map<String, Object> result = new HashMap<String, Object>();
		
		
		
		switch (type) {
		case "doing":
			//결재할
			list = ezNewPortalDAO.getApprovalDoingList(map);
			result.put("list", list);
			
			break;
		case "reject":
			//반송
			list = ezNewPortalDAO.getApprovalRejectList(map);
			result.put("list", list);
			
			break;
		case "draft":
			//기안
			list = ezNewPortalDAO.getApprovalDraftList(map);
			result.put("list", list);
			
			break;

		default:
			break;
		}
		
		LOGGER.debug("getApprovalList ended.");
		
		return result;
	}
	
	@Override
	public List<ThemeInfoVO> getThemes(boolean admin, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getThemes started. admin = " + admin + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		List<ThemeInfoVO> list = null;
		
		if (admin) {
			list = getCompanyThemes(companyId, tenantId);
		} else {
			list = getUserThemeList(companyId, tenantId);
		}
		
		LOGGER.debug("getThemes ended.");
		
		return list;
	}
	
	public List<ThemeInfoVO> getCompanyThemes(String companyId, int tenantId) throws Exception {
		LOGGER.debug("getComapnyThemes started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<ThemeInfoVO> list = ezNewPortalDAO.getCompanyThemes(map);
		
		LOGGER.debug("getComapnyThemes ended.");
		
		return list;
	}
	
	@Override
	public ThemeInfoVO getThemeInfo(int themeId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getThemeInfo started. themeId = " + themeId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("themeId", themeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ThemeInfoVO vo = ezNewPortalDAO.getThemeInfo(map);
		
		LOGGER.debug("getThemeInfo ended.");
		
		return vo;
	}
	
	@Override
	public List<FrameInfoVO> getFrames(int themeId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getFrames started. themeId = " + themeId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("themeId", themeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<FrameInfoVO> list = ezNewPortalDAO.getFrames(map);
		
		LOGGER.debug("getFrames ended.");
		
		return list;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateThemeInfo(JSONObject themeInfo, JSONArray frameInfos, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateThemeInfo started. themeId = " + themeInfo.get("themeId") + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map = new ObjectMapper().readValue(themeInfo.toJSONString(), Map.class);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.updateThemeInfo(map);
		
		for (Object item : frameInfos) {
			if (item instanceof JSONObject) {
				JSONObject frameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(frameInfo.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateFrameInfo(map);
			}
		}
		
		LOGGER.debug("updateThemeInfo ended.");
	}
	
	@Override
	public List<MenuInfoVO> getMenus(String companyId, int tenantId) throws Exception {
		LOGGER.debug("getMenus started. companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<MenuInfoVO> list = ezNewPortalDAO.getMenus(map);
		
		LOGGER.debug("getMenus ended.");
		
		return list;
	}
	
	@Override
	public MenuInfoVO getMenuInfo(String companyId, int tenantId) throws Exception {
		LOGGER.debug("getMenuInfo started. companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		MenuInfoVO vo = ezNewPortalDAO.getMenuInfo(map);
		
		LOGGER.debug("getMenuInfo ended.");
		
		return vo;
	}
	
	@Override
	public Map<String, Object> getMenuAuth(int menuId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getMenuAuth started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
//		나중에 쪼갤수도 rest 호출할때 arg받아서 처리해야할수도잇을거같은데
//		map.put("accessType", "Y","N","TOTAL")
		map.put("accessType", "Y");
		List<MenuAuthVO> menuAuthsY = ezNewPortalDAO.getMenuAuth(map);
		
		map.put("accessType", "N");		
		List<MenuAuthVO> menuAuthsN = ezNewPortalDAO.getMenuAuth(map);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("menuAuthsY", menuAuthsY);
		resultMap.put("menuAuthsY", menuAuthsN);
		
		LOGGER.debug("getMenuAuth ended.");
		
		return resultMap;
	}
	
	@Override
	public List<ApprGFormVO> getFavoriteForms(String userId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getFavoriteForms started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<ApprGFormVO> list = ezNewPortalDAO.getFavoriteForms(map);
		
		LOGGER.debug("getFavoriteForms ended.");
		
		return list;
	}
	
	@Override
	public Map<String, Object> getApprovalStatistics(String userId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getApprovalStatistics started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId);		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		Map<String, Object> result = ezNewPortalDAO.getApprovalStatistics(map);
		
		LOGGER.debug("getApprovalStatistics ended.");
		
		return result;
	}
	
	/** -------------------- */
	
	/**
	 * 구해안
	 */

	@Override
	public List<FavoriteBoardVO> getFavNewItemList(String userId, int tenantId, String companyId, String nowDate, int limit) {
		LOGGER.debug("getFavNewItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("nowDate", nowDate);
		map.put("limit", limit);
		
		List<FavoriteBoardVO> favNewItemList = ezNewPortalDAO.getFavNewItemList(map);
		
		LOGGER.debug("getFavNewItemList ended.");
		return favNewItemList;
	}
	
	@Override
	public List<FavoriteBoardVO> getFavItemList(String boardId, int tenantId, String companyId, int limit) {
		LOGGER.debug("getFavItemList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("boardId", boardId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("limit", limit);
		
		List<FavoriteBoardVO> FavItemList = ezNewPortalDAO.getFavItemList(map);
		
		LOGGER.debug("getFavItemList ended.");
		return FavItemList;
	}
	
	@Override
	public List<CommunityMyCommunityVO> getCommunityList(String lang, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getCommunityList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANG", commonUtil.getMultiData(lang, tenantId));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<CommunityMyCommunityVO> CommunityList = ezNewPortalDAO.getCommunityList(map);
		
		LOGGER.debug("getCommunityList ended.");
		return CommunityList;
	}
	
	@Override
	public String getCommunityPermit(String cNo, String userId, int tenantId) {
		LOGGER.debug("getCommunityPermit started");

		String ret = "1";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("clubNo", cNo);
		map.put("tenantId", tenantId);
		
		CommunityCClubUserVO result = ezNewPortalDAO.getCommunityPermit(map);
		
		if (result != null) {
			ret = "1";
		} else {
			ret = "0";
		}

		LOGGER.debug("getCommunityPermit ended");
		return ret;
	}
	
	@Override
	public List<PortletInfoVO> getPortletList(String companyId, int tenantId) {
		LOGGER.debug("getPortletList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<PortletInfoVO> portetList = ezNewPortalDAO.getPortletList(map);
		
		LOGGER.debug("getPortletList started");
		return portetList;
	}
	
	@Override
	public List<PortletNameInfoVO> getPortletNameList(String companyId, int tenantId, int portletId) {
		LOGGER.debug("getPortletList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("portletId", portletId);
		
		List<PortletNameInfoVO> portetList = ezNewPortalDAO.getPortletNameList(map);
		
		LOGGER.debug("getPortletList started");
		return portetList;
	}
}
