package egovframework.ezEKP.ezPersonal.service.impl;

import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.dao.EzOrganDAO;
import egovframework.ezEKP.ezPersonal.dao.EzPersonalAdminDAO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalAdminService;
import egovframework.ezEKP.ezPersonal.vo.PersonalNoticeVO;
import egovframework.ezEKP.ezPersonal.vo.PersonalQuickLickVO;
import egovframework.let.utl.fcc.service.CommonUtil;

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
		map.put("v_pCount", 0);
		
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
		List<PersonalQuickLickVO> list = ezPersonalAdminDAO.getQuickLinkList();
		
		result.append("<LISTVIEWDATA>");
		result.append("<ROWS>");
		
		for(PersonalQuickLickVO vo : list) {
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
		PersonalQuickLickVO vo = ezPersonalAdminDAO.getQuickLink(quickLinkID);
		
		String result = "<DATA>" + commonUtil.getQueryResult(vo) + "</DATA>";
		
		return result;
	}

	@Override
	public String getQuickLinkACL(String quickLinkID) throws Exception {
		StringBuilder result = new StringBuilder();
		List<PersonalQuickLickVO> list = ezPersonalAdminDAO.getQuickLinkACL(quickLinkID);
		
		result.append("<NODES>");
		for (PersonalQuickLickVO vo : list) {
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
	
	
}
