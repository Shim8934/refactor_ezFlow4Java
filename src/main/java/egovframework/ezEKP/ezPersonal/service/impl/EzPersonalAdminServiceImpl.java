package egovframework.ezEKP.ezPersonal.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalAdminDAO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.vo.PersonalLightPollVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalPopupVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLinkVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("EzPersonalAdminService")
public class EzPersonalAdminServiceImpl implements EzPersonalAdminService {
	@Resource(name="EzPersonalAdminDAO")
	private EzPersonalAdminDAO ezPersonalAdminDAO;
	
	@Resource(name="EzOrganDAO")
	private EzOrganDAO ezOrganDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;

	@Override
	public int getNoticeCount(String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		
		return ezPersonalAdminDAO.getNoticeCount(map);
	}

	@Override
	public List<PersonalNoticeVO> getNoticeList(String companyID, int totalCount, int pageSize, int pStart) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", pStart);
		
		return ezPersonalAdminDAO.getNoticeList(map);
	}

	@Override
	public String deleteNotice(String itemSeq) throws Exception {
		try {
			ezPersonalAdminDAO.deleteNotice(itemSeq);
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
	}

	@Override
	public PersonalNoticeVO getNoticeInfo(String itemSeq) throws Exception {
		return ezPersonalAdminDAO.getNoticeInfo(itemSeq);
	}

	@Override
	public String insertNotice(String companyID, String title, String title2, String content) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pTitle", title);
		map.put("v_pTitle2", title2);
		map.put("v_pContent", content);
		
		try {
			ezPersonalAdminDAO.insertNotice(map);
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
		
	}

	@Override
	public String updateNotice(String companyID, String title, String title2, String content, Integer itemSeq) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pTitle", title);
		map.put("v_pTitle2", title2);
		map.put("v_pContent", content);
		map.put("v_pItemSeq", itemSeq);
		
		try {
			ezPersonalAdminDAO.updateNotice(map);
			return "OK";
		} catch (Exception e) {
			return "Error" + e.getMessage();
		}
	}

	@Override
	public String getQuickLinkList() throws Exception {
		StringBuilder result = new StringBuilder();
		List<PersonalQuickLinkVO> list = ezPersonalAdminDAO.getQuickLinkList();
		
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
			result.append("<CELL><VALUE>" + vo.getRegDate() + "</VALUE></CELL>");
			
			if (vo.getModiDate() == null) {
				result.append("<CELL><VALUE>" + " " + "</VALUE></CELL>");
			} else {
				result.append("<CELL><VALUE>" + vo.getModiDate() + "</VALUE></CELL>");
			}
			
			result.append("<CELL><VALUE>" + vo.getDisplayName() + "</VALUE></CELL>");
			result.append("</ROW>");
		}
		
		result.append("</ROWS>");
		result.append("</LISTVIEWDATA>");
		
		return result.toString();
	}

	@Override
	public String getQuickLink(String quickLinkID) throws Exception {
		PersonalQuickLinkVO vo = ezPersonalAdminDAO.getQuickLink(quickLinkID);
		
		String result = "<DATA>" + commonUtil.getQueryResult(vo) + "</DATA>";
		
		return result;
	}

	@Override
	public String getQuickLinkACL(String quickLinkID) throws Exception {
		StringBuilder result = new StringBuilder();
		List<PersonalQuickLinkVO> list = ezPersonalAdminDAO.getQuickLinkACL(quickLinkID);
		
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
		
		setQuickLinkListXML(pQuickLinkID, pQuickLinkName, pQuickLinkName2, pQuickLinkName3, pQuickLinkName4, pLinkType, pLinkTypeURL, pMode, pUrl, pSize, userInfo.getId());
		
		if (doc.getElementsByTagName("node").getLength() == 0) {
			setQuickLinkACL(pQuickLinkID, "", "", "", "", "DEL"); 
		}
		
		for (int i = 0; i < doc.getElementsByTagName("node").getLength(); i++) {
			String accessName = doc.getElementsByTagName("node").item(i).getChildNodes().item(0).getTextContent();
			String accessID = doc.getElementsByTagName("node").item(i).getChildNodes().item(1).getTextContent();
			String accessName2 = doc.getElementsByTagName("node").item(i).getChildNodes().item(2).getTextContent();
			String viewFlag = doc.getElementsByTagName("node").item(i).getChildNodes().item(3).getTextContent();
			String quickLinkID = doc.getElementsByTagName("node").item(i).getChildNodes().item(4).getTextContent();
			String mode = doc.getElementsByTagName("node").item(i).getChildNodes().item(6).getTextContent();
			
			setQuickLinkACL(quickLinkID, accessID, accessName, accessName2, viewFlag, mode);
		}
	}

	@Override
	public int getPollCount(String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID);
		map.put("v_pMode", "A");
		
		return ezPersonalAdminDAO.getPollCount(map);
	}

	@Override
	public List<PersonalLightPollVO> getPollList(String companyID, int totalCount, int pageSize, int start) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", companyID.toUpperCase());
		map.put("v_pTotal", totalCount);
		map.put("v_pCount", pageSize);
		map.put("v_pStart", start);
		
		return ezPersonalAdminDAO.getPollList(map);
	}

	@Override
	public String insertPoll(Document doc) throws Exception {
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
		
		for (int i = 0; i < Integer.parseInt(selectCount); i++) {
			map.put("v_pAnswer" + (i + 1), doc.getElementsByTagName("ANSWER").item(i).getTextContent());
		}
		
		for (int i = Integer.parseInt(selectCount); i < 10; i++) {
			map.put("v_pAnswer" + (i + 1), " ");
		}
		
		try {
			ezPersonalAdminDAO.insertPoll(map);
			return "OK";
		} catch (Exception e) {
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public String deletePoll(String itemSeq) throws Exception {
		try {
			ezPersonalAdminDAO.deletePoll(itemSeq);
			
			return "OK";
		} catch (Exception e) {
			return "ERROR : " + e.getMessage();
		}
	}

	@Override
	public List<PersonalPopupVO> getPopupList(String companyID) throws Exception {
		return ezPersonalAdminDAO.getPopupList(companyID);
	}

	@Override
	public PersonalPopupVO getPopupInfo(String itemSeq) throws Exception {
		return ezPersonalAdminDAO.getPopupInfo(itemSeq);
	}

	@Override
	public void insertPopup(PersonalPopupVO vo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCompanyID", vo.getCompanyID());
		map.put("v_pStartDate", vo.getStartDate());
		map.put("v_pEndDate", vo.getEndDate());
		map.put("v_pWidth", vo.getWidth());
		map.put("v_pHeight", vo.getHeight());
		map.put("v_pPosition", vo.getPosition());
		map.put("v_pTitle", vo.getTitle());
		map.put("v_pTitle2", vo.getTitle2());
		map.put("v_pContent", vo.getContent());
		
		ezPersonalAdminDAO.insertPopup(map);
	}

	@Override
	public void updatePopup(PersonalPopupVO vo) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pItemSeq", vo.getItemSeq());
		map.put("v_pStartDate", vo.getStartDate());
		map.put("v_pEndDate", vo.getEndDate());
		map.put("v_pWidth", vo.getWidth());
		map.put("v_pHeight", vo.getHeight());
		map.put("v_pPosition", vo.getPosition());
		map.put("v_pTitle", vo.getTitle());
		map.put("v_pTitle2", vo.getTitle2());
		map.put("v_pContent", vo.getContent());
		
		ezPersonalAdminDAO.updatePopup(map);
	}

	@Override
	public void deletePopup(String itemSeq) throws Exception {
		ezPersonalAdminDAO.deletePopup(itemSeq);
	}

	private void setQuickLinkListXML(String quickLinkID, String quickLinkName, String quickLinkName2, String quickLinkName3, String quickLinkName4, String linkType, String linkTypeURL, String mode, String url, String size, String userID) throws Exception {
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
		map.put("v_NOWDATE", EgovDateUtil.getToday("-"));
		map.put("v_REGUSERID", userID);
		map.put("v_SIZE", size);

		ezPersonalAdminDAO.setQuickLinkItem(map);
	}
	
	private void setQuickLinkACL(String quickLinkID, String accessID, String accessName, String accessName2, String viewFlag, String mode) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PMODE", mode);
		map.put("v_QUICKLINKID", quickLinkID);
		map.put("v_ACCESSID", accessID);
		map.put("v_ACCESSNAME", accessName);
		map.put("v_ACCESSNAME2", accessName2);
		map.put("v_VIEW_FLAG", viewFlag);
		
		ezPersonalAdminDAO.setQuickLinkACL(map);
	}
}
