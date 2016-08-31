package egovframework.ezEKP.ezPersonal.service.impl;

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
	
	
}
