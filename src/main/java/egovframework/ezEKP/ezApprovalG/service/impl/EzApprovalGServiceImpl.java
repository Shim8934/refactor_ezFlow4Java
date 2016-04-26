package egovframework.ezEKP.ezApprovalG.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.let.user.login.vo.LoginVO;

@Service("EzApprovalGService")
public class EzApprovalGServiceImpl implements EzApprovalGService {

	@Resource(name = "EzApprovalGDAO")
	private EzApprovalGDAO ezApprovalGDAO;

	@Override
	// 해당 부서에서 볼 수 있는 문서함의 리스트를 가져온다.
	// OwnFlag : "0"-자기 부서의 문서함, "1"-타부서의 문서함, "2"-전부
	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception{
		ApprGLeftVO apprGLeftVO = getListHeader("106", userInfo.getLang());
		List<ApprGLeftVO> apprGLeftVOList = new ArrayList<ApprGLeftVO>();
		
		if (ownFlag.equals("1")) {
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo2(userInfo.getDeptID());
		} else if (ownFlag.equals("2")) {
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo3(userInfo.getDeptID());
		} else {
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo1(userInfo.getDeptID());
		}
		
		apprGLeftVOList.get(0).setName(apprGLeftVO.getName());
		apprGLeftVOList.get(0).setWidth(apprGLeftVO.getWidth());
		
		return apprGLeftVOList;
	}

	public ApprGLeftVO getListHeader(String listCode, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		
		return ezApprovalGDAO.getListHeader(map);
	}

	@Override
	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception {
		ApprGLeftVO apprGLeftVO = new ApprGLeftVO();
		String resultString = "";
		if (mode.equals("NAME")) {
			apprGLeftVO = getName2Code(code1, code2, userInfo.getCompanyID(), userInfo.getLang());
			resultString = apprGLeftVO.getCode2();
		} else {
			apprGLeftVO = getCode2Name(code1, code2, userInfo.getCompanyID(), userInfo.getLang());
			resultString = apprGLeftVO.getName();
		}
		
		return resultString;
	}

	public ApprGLeftVO getCode2Name(String code1, String code2, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("v_LANGTYPE", lang);
		
		return ezApprovalGDAO.getCode2Name(map);
	}

	public ApprGLeftVO getName2Code(String code1, String code2, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_NAME", code2);
		map.put("v_LANGTYPE", lang);
		
		return ezApprovalGDAO.getName2Code(map);
	}
	

}
