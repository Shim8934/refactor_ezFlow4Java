package egovframework.ezEKP.ezCommunity.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezCommunity.dao.EzCommunityDAO;
import egovframework.ezEKP.ezCommunity.service.EzCommunityService;
import egovframework.ezEKP.ezCommunity.vo.CommunityCBoardVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityCCategoryVO;
import egovframework.ezEKP.ezCommunity.vo.CommunityLeftCommunityVO;

@Service("EzCommunityService")
public class EzCommunityServiceImpl implements EzCommunityService{
	@Resource(name="EzCommunityDAO")
	private EzCommunityDAO ezCommunityDAO;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Override
	public String leftCommunityGet1(String code, String userInfoUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE", code);
		map.put("v_USERINFO_USERID", userInfoUserID);
		
		return ezCommunityDAO.leftCommunityGet1(map);
	}

	@Override
	public String leftCommunityGet2(String code) throws Exception {
		return ezCommunityDAO.leftCommunityGet2(code);
	}

	@Override
	public List<CommunityLeftCommunityVO> leftCommunityGet3(String userId) throws Exception {
		return ezCommunityDAO.leftCommunityGet3(userId);
	}

	@Override
	public String leftCommunityGet4(String code) throws Exception {
		return ezCommunityDAO.leftCommunityGet4(code);
	}

	@Override
	public String checkIfBoardGroupAdmin(String pRootBoardID, String id, String deptID, String companyID) throws Exception {
		return "";
	}

	/** 나중에도안쓰면 삭제*/
	@Override
	public String getBoardTree(String pRootBoardID, String id, String deptID, String companyID, int pMode, int parseInt, int pSelectBy, String pExcludeBoardID, String code, String multiData) throws Exception {
		return "";
	}
	
	/** 나중에도안쓰면 삭제*/
	@Override
	public List<CommunityCBoardVO> getLeftBoardList() throws Exception {
		return ezCommunityDAO.getLeftBoardList();
	}

	@Override
	public String getCategoryValueA(String strSelCateA, Locale locale) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueA();
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getcCode());
			sb.append("\" ");
			
			if(strSelCateA.equals(category.getcCode())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getcName();
			sb.append(egovMessageSource.getMessage(code, locale));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getCategoryValueB(String strSelCateB, Locale locale) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueB();
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getcCode());
			sb.append("\" ");
			
			if(strSelCateB.equals(category.getcCode())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getcName();
			sb.append(egovMessageSource.getMessage(code, locale));
			sb.append("</Option>");
		}
		return sb.toString();
	}

	@Override
	public String getCategoryValueC(String strSelCateC, Locale locale) throws Exception {
		StringBuilder sb = new StringBuilder();
		List<CommunityCCategoryVO> categoryList = ezCommunityDAO.getCategoryValueC();
		for(CommunityCCategoryVO category : categoryList){
			sb.append("<Option Value=\"");
			sb.append(category.getcCode());
			sb.append("\" ");
			
			if(strSelCateC.equals(category.getcCode())){
				sb.append("selected");
			}
			
			sb.append(">");
			String code = "ezCommunity."+category.getcName();
			sb.append(egovMessageSource.getMessage(code, locale));
			sb.append("</Option>");
		}
		return sb.toString();
	}
	
	
	
	
	
	
}
