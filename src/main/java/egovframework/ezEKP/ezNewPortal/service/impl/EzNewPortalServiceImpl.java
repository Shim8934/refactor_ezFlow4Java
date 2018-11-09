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
import egovframework.ezEKP.ezNewPortal.vo.MenuNameVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalBoardTreeVO;
import egovframework.ezEKP.ezNewPortal.vo.PortalLogoVO;
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
	
	public List<MenuInfoVO> getUserMenuList(String companyId, int tenantId, String langType, String userId, String deptId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("langType", langType);
		map.put("userId", userId);
		map.put("deptId", deptId);
		return ezNewPortalDAO.getUserMenuList(map);
	}
	
	public List<MenuInfoVO> getCompanyMenuList(String companyId, int tenantId, String langType, String userId, String deptId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("langType", langType);
		map.put("userId", userId);
		map.put("deptId", deptId);		
		return ezNewPortalDAO.getCompanyMenuList(map);
	}
	
	// 사용자 메뉴 순서 변경
	@SuppressWarnings("unchecked")
	public void updateUserMenuOrder(String companyId, int tenantId, String userId, JSONObject jObj) throws Exception {
		LOGGER.debug("[Serivce] updateUserMenuOrder Started");

		// 사용자 메뉴가 존재할 경우, 존재하지 않을 경우로 분기
		Map<String, Object> cntMap = new HashMap<String, Object>();
		cntMap.put("companyId", companyId);
		cntMap.put("tenantId", tenantId);
		cntMap.put("userId", userId);
		
		int cnt = ezNewPortalDAO.getUserMenuOrderCnt(cntMap);
		
		List<Map<String, Object>> list = (ArrayList<Map<String, Object>>) jObj.get("data");

		for(int i=0; i<list.size(); i++) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyId", companyId);
			map.put("tenantId", tenantId);
			map.put("userId", userId);			
				map.put("menuId", list.get(i).get("menuId"));
			map.put("order", list.get(i).get("order"));
			
			if (cnt < 1) {
				ezNewPortalDAO.insertUserMenuOrder(map);
			} else {
				ezNewPortalDAO.updateUserMenuOrder(map);
			}
		}
		LOGGER.debug("[Serivce] updateUserMenuOrder Ended");
	}
	
	// 사용자 메뉴 순서 삭제
	public void deleteUserMenuOrder(String companyId, int tenantId, String userId) throws Exception {
		LOGGER.debug("[Serivce] deleteUserMenuOrder Started");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		ezNewPortalDAO.deleteUserMenuOrder(map);
		
		LOGGER.debug("[Serivce] deleteUserMenuOrder Ended");
	}
	
	// 퀵링크 가져오기
	public List<?> getQuickLinkList(String companyId, int tenantId, int page, int limit) throws Exception {
		LOGGER.debug("[Serivce] getQuickLinkList Started");
		
		int offset = (page-1) * limit;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("limit", limit);
		map.put("offset", offset);
		
		LOGGER.debug("[Serivce] getQuickLinkList Ended");
		return ezNewPortalDAO.getQuickLinkList(map);
	}
	// 퀵링크 전체 페이지 개수 가져오기
	public int getQuickLinkTotalPageCnt(String companyId, int tenantId, int limit) throws Exception {
		LOGGER.debug("[Serivce] getQuickLinkTotalPageCnt Started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		int totalCnt = ezNewPortalDAO.getQuickLinkTotalCnt(map);
		
		float pageCnt = (float)totalCnt / (float)limit;
		
		LOGGER.debug("[Serivce] getQuickLinkTotalPageCnt Ended");
		return (int) Math.ceil(pageCnt);
	}
	
	public List<?> getUserFrameListAndSelectedFrame(String companyId, int tenantId, String userId) throws Exception {
		LOGGER.debug("[Serivce] getUserFrameListAndSelectedFrame Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("userId", userId);
		
		List<FrameInfoVO> frameList = new ArrayList<FrameInfoVO>();
		/**
		 * 1. 회사 프레임리스트 가져오기
		 * 2. 유저 프레임 정보 가져오기
		 * 3. 유저 프레임 정보가 없을 경우 회사에서 선택된 프레임 정보 사용
		 * 4. 유저 프레임 정보가 있을 경우 그대로 사용
		 */
		
		// 1. 유저 프레임 정보 가져오기
		List<FrameInfoVO> userFrame = ezNewPortalDAO.getUserUsableFrameList(map);
		// 유저가 설정한 적이 없을 경우 회사 정보 가져오기
		if(userFrame.size() < 1) {
			List<FrameInfoVO> compFrame = ezNewPortalDAO.getCompUsableFrameList(map);
			frameList = compFrame;
		} else {
			frameList = userFrame;
		}

		LOGGER.debug("[Serivce] getUserFrameListAndSelectedFrame Ended");
		return frameList;
	}
	
	@SuppressWarnings("unchecked")
	public void updateUserUsedFrame(String userId, int tenantId, String companyId, JSONObject jObj) throws Exception {
		LOGGER.debug("[Serivce] updateUserUsedFrame Started");
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> param = (Map<String, Object>) jObj.get("param");
		
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("frameId", param.get("frameId"));
		map.put("themeId", param.get("themeId"));
		
		LOGGER.debug("map.toString() : " + map.toString());
		
		ezNewPortalDAO.updateUserUsedFrame(map);
		
		LOGGER.debug("[Serivce] updateUserUsedFrame Ended");
	}
	
	@SuppressWarnings("unchecked")
	public void updateUserUsedPortlet(String userId, int tenantId, String companyId, JSONObject jObj) throws Exception {
		LOGGER.debug("[Serivce] updateUserUsedPortlet Started");
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> param = (Map<String, Object>) jObj.get("param");
		// 유저 포틀릿은 delete & insert로 진행
		map.put("userId", userId);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);		
		
		// 삭제할 때 
		ezNewPortalDAO.deleteUserUsedPortlet(map);
		
		List<Map<String, Object>> portletList = (List<Map<String, Object>>) param.get("portletList");
		for (int i=0; i<portletList.size(); i++) {
			LOGGER.debug(portletList.get(i).toString());
			Map<String, Object> portletMap = new HashMap<String, Object>();
			portletMap.put("userId", userId);
			portletMap.put("tenantId", tenantId);
			portletMap.put("companyId", companyId);				
			portletMap.put("portletId", portletList.get(i).get("portletId"));
			portletMap.put("portletOrder", portletList.get(i).get("portletOrder"));
			portletMap.put("menuId", portletList.get(i).get("menuId"));
			
			LOGGER.debug("portletMap:" + portletMap.toString());
			ezNewPortalDAO.insertUserUsedPortlet(portletMap);
		}
		
		
		LOGGER.debug("[Serivce] updateUserUsedPortlet Ended");
	}
	
	public List<PortletInfoVO> getPortletOrderCompForUser(String portletLang, int tenantId, String companyId, String deptId, String userId) throws Exception {
		LOGGER.debug("[Serivce] getPortletOrderCompForUser Started");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletLang", portletLang);
		map.put("tenantId", tenantId);
		map.put("companyId", companyId);
		map.put("deptId", deptId);
		map.put("userId", userId);
		
		List<PortletInfoVO> portletOrderComp = ezNewPortalDAO.getPortletOrderCompForUser(map);

		LOGGER.debug("[Serivce] getPortletOrderCompForUser Ended");
		return portletOrderComp;		
	}
	
	// 사용자 포틀릿 리스트 가져오기
	public List<?> getUserPortletList(String portletLang, String userId, int tenantId, String companyId, String deptId) throws Exception {
		LOGGER.debug("[Serivce] getUserPortletList Started");
		List<Map<?, ?>> resultList = new ArrayList<>();
		/** 
		 * tbl_portal_portlet_user에 해당 유저 관련 정보가 없으면?
		 * -> 회사 포틀릿 전체를 쓰는 것으로 판단
		 * tbl_portal_portlet_user에 해당 유저 정보가 존재하면?
		 * -> 그 안에 있는 포틀릿만 쓰는 것으로 판단
		*/
		List<PortletInfoVO> compPortletList = getPortletOrderCompForUser(portletLang, tenantId, companyId, deptId, userId);
		List<PortletInfoVO> userPortletList = getPortletOrderUser(portletLang, userId, tenantId, companyId);		

		if(userPortletList.size() < 1) {
			Iterator<PortletInfoVO> it = compPortletList.iterator();
			while (it.hasNext()) {
				Map<String, Object> map = commonUtil.transBean2Map(it.next());
				map.put("use", "on");
				resultList.add(map);
			}
		} else {
			Iterator<PortletInfoVO> comp = compPortletList.iterator();
			while (comp.hasNext()) {
				PortletInfoVO compVO = comp.next();
				Map<String, Object> map = commonUtil.transBean2Map(compVO);
				Iterator<PortletInfoVO> user = userPortletList.iterator();
				while (user.hasNext()) {
					PortletInfoVO userVO = user.next();
					if(compVO.getPortletId() == userVO.getPortletId()) {
						map.put("use", "on");
						break;
					} else {
						map.put("use", "off");
					}
				}
				resultList.add(map);
			}	
		}
		LOGGER.debug("[Serivce] getUserPortletList Ended");
		return resultList;
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
			
		} else {//있으면 delete 후 insert
			LOGGER.debug("DAO deletePortletOrderUser started.");
			ezNewPortalDAO.deletePortletOrderUser(map);
			
			LOGGER.debug("DAO insertPortletOrderUser started.");
			for (int i = 0; i < portletOrderCount; i++) {
				map.put("portletOrder", portletOrder.get(i).get("portletOrder"));
				map.put("portletId", portletOrder.get(i).get("portletId"));
				ezNewPortalDAO.insertPortletOrderUser(map);
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
	
	//관리자부분!! ------ boardtree가져오기
	@Override
	public List<PortalBoardTreeVO> getBoardTree(String parentBoardId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getBoardTree started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentBoardId", parentBoardId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		LOGGER.debug("getBoardTree ended.");
		return ezNewPortalDAO.getBoardTree(map);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void insertPortlet(JSONObject portletInfo, JSONArray portletNames, String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("insertPortlet started.");
		Map<String, Object> map = new HashMap<>();
		
		//메뉴
		map = new ObjectMapper().readValue(portletInfo.toJSONString(), Map.class);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		//포틀릿 insert 후에 아이디 가져옴
		int portletId = ezNewPortalDAO.insertPortlet(map);
		
		map.put("portletId", portletId);
		map.put("companyLang", 1);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.insertPortletComp(map);
		
		String menuId = portletInfo.get("menuId").toString();
		
		//포틀릿이름
		for (Object item : portletNames) {
			if (item instanceof JSONObject) {
				JSONObject portletNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(portletNameInfo.toJSONString(), Map.class);
				map.put("menuId", menuId);
				map.put("portletId", portletId);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyPortletNameInfo(map);
			}
		}
		LOGGER.debug("insertPortlet ended.");
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updateCompanyPortletInfo(JSONObject portletInfo, JSONArray portletNames, String companyId, int tenantId)
			throws Exception {
		LOGGER.debug("updateCompanyPortletInfo started.");
		Map<String, Object> map = new HashMap<>();
		
		//메뉴
		map = new ObjectMapper().readValue(portletInfo.toJSONString(), Map.class);
		map.put("companyLang", 1);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.updateCompanyPortletInfo(map);
		
		String menuId = map.get("menuId").toString();
		
		//포틀릿이름
		for (Object item : portletNames) {
			if (item instanceof JSONObject) {
				JSONObject portletNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(portletNameInfo.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				map.put("menuId", menuId);
				
				ezNewPortalDAO.updateCompanyPortletNameInfo(map);
			}
		}
		LOGGER.debug("updateCompanyPortletInfo ended.");
		
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updateCompanyPortletOrder(JSONArray portletList, int tenantId, String companyId) throws Exception {
		LOGGER.debug("updateCompanyPortletOrder started.");
		Map<String, Object> map = new HashMap<String, Object>();
		
		//포틀릿 순서
		for (Object item : portletList) {
			if (item instanceof JSONObject) {
				JSONObject portletOrder = (JSONObject) item;
				map = new ObjectMapper().readValue(portletOrder.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyPortletOrder(map);
			}
		}
		LOGGER.debug("updateCompanyPortletOrder ended.");
		
	}
	@Override
	public void deletePortlet(int portletId, int menuId, String companyId, int tenantId) {
		LOGGER.debug("deletePortlet started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("portletId", portletId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		
		//tbl_portal_portlet_user 지우기
		ezNewPortalDAO.deletePortletUser(map);
		
		//tbl_portal_portlet_name 지우기
		ezNewPortalDAO.deletePortletName(map);
		
		//tbl_portal_portlet_comp 지우기
		ezNewPortalDAO.deletePortletComp(map);
		
		//tbl_portal_portlet 지우기
		ezNewPortalDAO.deletePortlet(map);
		
		LOGGER.debug("deletePortlet ended.");
	}
	
	@Override
	public void updateCompanyLogo(String companyId, int tenantId, String logoType, String logoUrl) {
		LOGGER.debug("updateCompanyLogo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("logoType", logoType);
		map.put("logoUrl", logoUrl);
		
		ezNewPortalDAO.updateCompanyLogo(map);
		LOGGER.debug("updateCompanyLogo ended.");
	}
	
	@Override
	public List<PortalLogoVO> getCompanyLogoList(String companyId, int tenantId) {
		LOGGER.debug("getCompanyLogoList started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		List<PortalLogoVO> companyLogoList = ezNewPortalDAO.getCompanyLogoList(map);
		LOGGER.debug("getCompanyLogoList ended.");
		return companyLogoList;
	}
	
	@Override
	public int getTnenantIdByServerName(String serverName) {
		LOGGER.debug("getTnenantIdByServerName started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("serverName", serverName);
		
		int tenantId = ezNewPortalDAO.getTenantIdByServerName(map);
		LOGGER.debug("getTnenantIdByServerName ended.");
		return tenantId;
	}
	
	@Override
	public void updateCompanyDefaultTheme(int themeId, String companyId, int tenantId) {
		LOGGER.debug("updateCompanyDefaultTheme started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("themeId", themeId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.updateCompanyDefaultTheme(map);
		LOGGER.debug("updateCompanyDefaultTheme ended.");
	}
	
	@Override
	public void deleteCompanyLogo(String companyId, int tenantId, String logoType) {
		LOGGER.debug("deleteCompanyLogo started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("logoType", logoType);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.deleteCompanyLogo(map);
		LOGGER.debug("deleteCompanyLogo ended.");
	}
	/**
	 * 이효진
	 */
	@SuppressWarnings("unchecked")
	@Override
	public JSONObject getApprovalList(String userId, String companyId, int tenantId, String offset, String type, String approvalFlag, String lang) throws Exception {
		LOGGER.debug("getApprovalList started.");
		LOGGER.debug("userId = " + userId + " || companyId = " + companyId + " || tenantId = " + tenantId + " || type = " + type);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("userId", userId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("offset",commonUtil.getMinuteUTC(offset));
		
		List<ApprGDocListVO> list = null;
		JSONObject result = new JSONObject();
		
		switch (type) {
		case "doing":
			//결재할
			list = ezNewPortalDAO.getApprovalDoingList(map);
			result.put("list", list);
			
			if (list != null) {
				if (approvalFlag.equalsIgnoreCase("G")) {
					map.put("code1", "A04");
				} else {
					map.put("code1", "SA04");
				}
				
				map.put("docId", list.get(0).getDocID());
				map.put("lang", lang.equals("1") ? "" : lang);
				
				//결재선 정보
				list = assembleApprPortletList(map);
				result.put("aprLines", list);
			}
			
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
	
	private List<ApprGDocListVO> assembleApprPortletList(Map<String, Object> param) throws Exception {
		LOGGER.debug("assembleApprPortletList started.");
		
		List<ApprGDocListVO> ret = new ArrayList<ApprGDocListVO>();
		int index = 0;
		boolean isUser = false;
		
		Iterator<ApprGDocListVO> it = ezNewPortalDAO.getApprovalDoingLines(param).iterator();
		while(it.hasNext() && index < 3) {
			ApprGDocListVO vo = it.next();
			if (index == 0 && vo.getAprMemberSN().equalsIgnoreCase("1")) {
				ret.add(vo);
			} else {
				if(isUser && ret.size() < 3) {
					ret.add(vo);
				}
				// 현재 유저 결재선 정보와 바로 뒷 사람 정보까지 넣고 while문 종료!
				if(param.get("userId").toString().equalsIgnoreCase(vo.getAprMemberID())) {
					ret.add(vo);
					isUser = true;
				}
			}
			
			index++;
		}
		
		LOGGER.debug("assembleApprPortletList ended.");
		
		return ret;
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
	
	private List<ThemeInfoVO> getCompanyThemes(String companyId, int tenantId) throws Exception {
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
	public MenuInfoVO getMenuInfo(int menuId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getMenuInfo started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		
		MenuInfoVO vo = ezNewPortalDAO.getMenuInfo(map);
		
		LOGGER.debug("getMenuInfo ended.");
		
		return vo;
	}
	
	public List<MenuNameVO> getMenuNames(int menuId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("getMenuNames started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuId", menuId);
		
		List<MenuNameVO> list = ezNewPortalDAO.getMenuNames(map);
		
		LOGGER.debug("getMenuNames ended.");
		
		return list;
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
		map.put("accessType", "1");
		List<MenuAuthVO> menuAuthsY = ezNewPortalDAO.getMenuAuth(map);
		
		map.put("accessType", "0");		
		List<MenuAuthVO> menuAuthsN = ezNewPortalDAO.getMenuAuth(map);
		
		Map<String, Object> resultMap = new HashMap<>();
		resultMap.put("menuAuthsY", menuAuthsY);
		resultMap.put("menuAuthsN", menuAuthsN);
		
		LOGGER.debug("getMenuAuth ended.");
		
		return resultMap;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateCompanyMenuInfo(int menuId, JSONObject menuInfo, JSONArray menuNames, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateCompanyMenuInfo started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		LOGGER.debug("menuInfo = " + menuInfo.toString());
		LOGGER.debug("menuNames = " + menuNames.toString());
		
		boolean menuUsed = (boolean) menuInfo.get("menuUsed");
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("menuUrl", menuInfo.get("menuUrl"));
		map.put("menuType", menuInfo.get("menuType"));
		map.put("iconUrl", menuInfo.get("iconUrl"));
		map.put("menuUsed", menuUsed);
		map.put("companyLang", menuInfo.get("companyLang"));
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.updateCompanyMenuInfo(map);
		
		for (Object item : menuNames) {
			if (item instanceof JSONObject) {
				JSONObject menuNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(menuNameInfo.toJSONString(), Map.class);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyMenuNameInfo(map);
			}
		}
		
		if (!menuUsed) {
			//portlet used -> false
			updateMenuPortletUsed(menuId, menuUsed, companyId, tenantId);
		}
		
		LOGGER.debug("updateCompanyMenuInfo ended.");
	}
	
	//메뉴사용여부에 따라 관련포틀릿 사용여부 수정
	private void updateMenuPortletUsed(int menuId, boolean portletUsed, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateMenuPortletUsed started. menuId = " + menuId + " || menuUsed = " + portletUsed + " || companyId = " + companyId + " || tenantId = " + tenantId);
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("portletUsed", portletUsed);
		map.put("companyId", companyId);
		map.put("tenantId",  tenantId);
		
		ezNewPortalDAO.updateMenuPortletUsed(map);
		
		LOGGER.debug("updateMenuPortletUsed ended.");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void updateMenuAuth(JSONObject menuAuths, int menuId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateMenuAuth started. menuId = " + menuId + " || companyId = " + companyId + " || tenantId = " + tenantId);
		LOGGER.debug("menuAuths = " + menuAuths.toString());
		
		Map<String, Object> map = new HashMap<>();
		
		//이걸 구분해서 넣을 필요가잇나 받을때 accessYN이 같이들어오면 그냥 for 하나에 다때려박아도되는데?
		for (Object item : (JSONArray) menuAuths.get("menuAuthsY")) {
			if (item instanceof JSONObject) {
				JSONObject menuAuthsY = (JSONObject) item;
				
				map = new ObjectMapper().readValue(menuAuthsY.toJSONString(), Map.class);
				map.put("menuId", menuId);
				map.put("accessYN", true);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateMenuAuth(map);
			}
		}
		
		for (Object item : (JSONArray) menuAuths.get("menuAuthsN")) {
			if (item instanceof JSONObject) {
				JSONObject menuAuthsY = (JSONObject) item;
				
				map = new ObjectMapper().readValue(menuAuthsY.toJSONString(), Map.class);
				map.put("menuId", menuId);
				map.put("accessYN", true);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateMenuAuth(map);
			}
		}
		
		LOGGER.debug("updateMenuAuth ended.");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void insertMenu(JSONObject menuInfo, JSONArray menuNames, JSONObject menuAuths, String companyId, int tenantId) throws Exception {
		LOGGER.debug("insertMenu started.");
		
		Map<String, Object> map = new HashMap<>();
		
		//메뉴
		map = new ObjectMapper().readValue(menuInfo.toJSONString(), Map.class);
		
		//tbl_portal_menu
		int menuId = ezNewPortalDAO.insertMenu(map);
		
		map.put("menuId", menuId);
		//TODO 이효진 companyLang 만들고 나면 하드코딩한거 지우고 DB에서 get
		map.put("companyLang", 1);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		ezNewPortalDAO.insertMenuComp(map);
		
		//메뉴이름
		for (Object item : menuNames) {
			if (item instanceof JSONObject) {
				JSONObject menuNameInfo = (JSONObject) item;
				
				map = new ObjectMapper().readValue(menuNameInfo.toJSONString(), Map.class);
				map.put("menuId", menuId);
				map.put("companyId", companyId);
				map.put("tenantId", tenantId);
				
				ezNewPortalDAO.updateCompanyMenuNameInfo(map);
			}
		}
		
		//권한은 셀렉트키로 받아서 ezNewPortal.updateCompanyMenuNameInfo
		//지금 권한 안들어오지 조직도없지 선택못하지
		if (menuAuths != null) {
			for (Object item : (JSONArray) menuAuths.get("menuAuthsY")) {
				if (item instanceof JSONObject) {
					JSONObject menuAuthsY = (JSONObject) item;
					
					map = new ObjectMapper().readValue(menuAuthsY.toJSONString(), Map.class);
					map.put("menuId", menuId);
					map.put("accessYN", true);
					map.put("companyId", companyId);
					map.put("tenantId", tenantId);
					
					ezNewPortalDAO.updateMenuAuth(map);
				}
			}
			
			for (Object item : (JSONArray) menuAuths.get("menuAuthsN")) {
				if (item instanceof JSONObject) {
					JSONObject menuAuthsY = (JSONObject) item;
					
					map = new ObjectMapper().readValue(menuAuthsY.toJSONString(), Map.class);
					map.put("menuId", menuId);
					map.put("accessYN", true);
					map.put("companyId", companyId);
					map.put("tenantId", tenantId);
					
					ezNewPortalDAO.updateMenuAuth(map);
				}
			}
		}
		
		LOGGER.debug("insertMenu ended.");
	}
	
	@Override
	public void deleteMenu(int menuId, String companyId, int tenantId) throws Exception {
		LOGGER.debug("deleteMenu started.");
		
		Map<String, Object> map = new HashMap<>();
		map.put("menuId", menuId);
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		//TODO 2018-11-06 이효진 포틀릿 삭제로직 포함시켜라
		//deletePortlet ---- 2018-11-07 유은정 개발
		//메뉴아이디에 포함되어있는 포틀릿 아이디 목록 가져오기
		List<Integer> portletList = ezNewPortalDAO.getPortletIdsByMenuId(map);
		int portletListCount = portletList.size();
		
		for (int i = 0; i < portletListCount; i++) {
			int portletId = portletList.get(i);
			map.put("portletId", portletId);
			
			ezNewPortalDAO.deletePortletUser(map);
			ezNewPortalDAO.deletePortletName(map);
			ezNewPortalDAO.deletePortletComp(map);
			ezNewPortalDAO.deletePortlet(map);
		}
		
		ezNewPortalDAO.deleteMenuUser(map);
		ezNewPortalDAO.deleteMenuAuth(map);
		ezNewPortalDAO.deleteMenuNames(map);
		ezNewPortalDAO.deleteMenuComp(map);
		ezNewPortalDAO.deleteMenu(map);
		
		LOGGER.debug("deleteMenu ended.");
	}
	
	@Override
	public void udpateMenuOrder(JSONArray menus, String companyId, int tenantId) throws Exception {
		LOGGER.debug("updateMenuOrder started. companyId = " + companyId + " || tenantId = " + tenantId);
		LOGGER.debug("menus = " + menus.toString());
		
		Map<String, Object> map = new HashMap<>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		
		for (Object item : menus) {
			if (item instanceof JSONObject) {
				JSONObject menuInfo = (JSONObject) item;
				map.put("menuId", menuInfo.get("menuId"));
				map.put("companyOrder", menuInfo.get("companyOrder"));
				
				ezNewPortalDAO.updateMenuOrder(map);
			}
		}
		
		LOGGER.debug("updateMenuOrder ended.");
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
	public List<PortletInfoVO> getPortletList(String companyId, int tenantId, int menuLang) {
		LOGGER.debug("getPortletList started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyId", companyId);
		map.put("tenantId", tenantId);
		map.put("menuLang", menuLang);
		
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
