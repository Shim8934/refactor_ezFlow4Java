package egovframework.ezEKP.ezApproval.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApproval.dao.EzApprovalAdminDAO;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.vo.ApprCodeVO;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service
public class EzApprovalAdminServiceImpl implements EzApprovalAdminService {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Autowired
	private EzApprovalAdminDAO ezApprovalAdminDAO;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalAdminServiceImpl.class);
	
	//전역 변수 정의
    protected final String staDTDraftDoc   = "A01001";		// 기안문
    protected final String staDTReportDoc  = "A01002";		// 보고문
    protected final String staDTReceiptDoc = "A01003";		// 수신문
    protected final String staDTExcuteDoc  = "A01004";		// 시행문
    protected final String staDTHabyuiDoc  = "A01005";		// 합의문
    protected final String staDTGamsaDoc   = "A01006";		// 감사문
    protected final String staDTApplyDoc   = "A01007";		// 신청서
    protected final String staDSPumYui = "A02001";		// 품의
    protected final String staDSHyubJo = "A02002";		// 협조
    protected final String staDSGamSa  = "A02003";		// 감사
    protected final String staDSSimSa  = "A02004";		// 심사

    protected final String staDSSuSin   = "A02011";		// 수신
    protected final String staDSHabYui  = "A02012";		// 합의
    protected final String staDSSiHang  = "A02013";		// 시행
    protected final String staDSGamSaBu = "A02014";		// 검사부 감사
    protected final String staDSGongRam = "A02015";		// 공람
    protected final String staDSHoiRam  = "A02016";		// 회람
    protected final String staDSChamJo  = "A02017";		// 참조
    protected final String staDSWhokyul = "A02018";		// 후결
    protected final String staDSBalsin  = "A02019";		// 발신
    protected final String staDSApply   = "A02020";		// 신청

    protected final String staDSBansong = "A02031";		// 반송
    protected final String StaDSHesong  = "A02032";		// 회송

	// AprType
    protected final String staATYilBan  = "A03001";		// 일반
    protected final String staATGyulJe  = "A03001";		// 결재
    protected final String staatwhoakin = "A03002";		// 확인
    protected final String staATAnHam   = "A03003";		// 결재안함
    protected final String staATJunGyul = "A03004";		// 전결
    protected final String staATGamSa   = "A03005";		// 감사
    protected final String staATSimSa   = "A03006";		// 심사
    protected final String staATChamJo  = "A03007";		// 참조
    protected final String staATSoonChaHyubJo   = "A03008";		// 개인순차협조
    protected final String staATHapYu           = "A03008";		// 개인 합의
    protected final String staATByungRyulHyubJo = "A03009";		// 개인병렬협조
    protected final String staATBuSeuSoonChaHyubJo   = "A03011";		// 부서순차협조
    protected final String staATBuSeuByungRyulHyubJo = "A03012";		// 부서병렬협조
    protected final String staATGamSaBu     = "A03013";		// 감사(부서감사)
    protected final String staATSuSin       = "A03014";		// 수신
    protected final String staATWhokyul     = "A03015";		// 후열
    protected final String staATGongram     = "A03017";		// 공람

    protected final String staATTongje      = "A03031";		// 통제. 031~039는 확인과 동일.

	protected final String staATReserved2	= "A03032";		// 031~035는 확인과 동일.
	protected final String staATReserved3	= "A03033";		// 031~035는 확인과 동일.
	protected final String staATReserved4	= "A03034";		// 031~035는 확인과 동일.
	protected final String staATReserved5	= "A03035";		// 031~035는 확인과 동일.
	protected final String staATWhokyul2	= "A03040";		// 후결
	
	// AprState
    protected final String staASmikyul  = "A04000";		// 미결
    protected final String staASDaeGi   = "A04001";		// 대기
    protected final String staASJinHang = "A04002";		// 진행
    protected final String staASSungIn  = "A04003";		// 승인
    protected final String staASBanSong = "A04004";		// 반송
    protected final String staASBoRyu   = "A04005";		// 보류
    protected final String staASWheSu   = "A04006";		// 회수

    protected final String staASAprEND          = "A04010";		// 완료
    protected final String staASDoJak           = "A04011";		// 도착
    protected final String staASJiJung          = "A04012";		// 지정
    protected final String staASJubSu           = "A04013";		// 접수
    protected final String staASBaeBu           = "A04014";		// 배부
    protected final String staASWheSong         = "A04015";		// 회송
    protected final String staASSusinJinHang    = "A04016";		// 수신진행
    protected final String staASSusinSungIn     = "A04017";		// 수신완료
    protected final String staASSusinJiJung     = "A04018";		// 수신지정

	// OpinionType
    protected final String staIlBan     = "A17001";			// 일반의견
    protected final String staBanSong   = "A17002";			// 반송의견
    protected final String staBoRyu     = "A17003";			// 보류의견
    protected final String staWheSong   = "A17004";			// 회송의견
	
	public String makeListField(String orgStr) {
		if (orgStr == null || orgStr.equals("NULL")) {
			return "";
		} else {
			return orgStr;
		}
	}
	
	@Override
	public List<ApprContInfoVO> getUseContInfo(ApprContInfoVO apprContInfoVO) throws Exception{
		logger.debug("getUseContInfo started");
		// OwnFlag :  0 -자기 부서의 문서함,  1 -타부서의 문서함,  2 -전부 
		logger.debug("ownFlag = " + apprContInfoVO.getOwnFlag());
		
		List<ApprContInfoVO> apprContInfoVOs = new ArrayList<ApprContInfoVO>();
		
		if (apprContInfoVO.getOwnFlag().equals("1")) {
			apprContInfoVOs = ezApprovalAdminDAO.getUserContInfo(apprContInfoVO); 
		} else {
			apprContInfoVOs = ezApprovalAdminDAO.getUserContInfo1(apprContInfoVO); 
		}
		
		if (apprContInfoVO.getOwnFlag().equals("2")) {
			List<ApprContInfoVO> tempApprContInfoVOs = ezApprovalAdminDAO.getUserContInfo(apprContInfoVO);
			
			for (int k = 0; k < tempApprContInfoVOs.size(); k++) {
				tempApprContInfoVOs.get(k).setContainerTypeName(makeListField(ezOrganService.getPropertyValue(tempApprContInfoVOs.get(k).getContainerOwnDepID(), "displayName", apprContInfoVO.getTenantID())) + "_" + makeListField(tempApprContInfoVOs.get(k).getContainerTypeName()));
				tempApprContInfoVOs.get(k).setContainerTypeName2(makeListField(ezOrganService.getPropertyValue(tempApprContInfoVOs.get(k).getContainerOwnDepID(), "displayName2", apprContInfoVO.getTenantID())) + "_" + makeListField(tempApprContInfoVOs.get(k).getContainerTypeName2()));
				
				apprContInfoVOs.add(tempApprContInfoVOs.get(k));
			}
		}
		
		logger.debug("getUseContInfo ended");
		
		return apprContInfoVOs;
	}

	@Override
	public List<ApprDocInfoVO> getCodeContainer(LoginVO userInfo) throws Exception {
		logger.debug("getCodeContainer started");
		
		List<ApprDocInfoVO> apprDocInfoVOs = ezApprovalAdminDAO.getCodeContainer(userInfo);
		
		for (int k = 0; k < apprDocInfoVOs.size(); k++) {
			apprDocInfoVOs.get(k).setItemName(commonUtil.cleanValue(apprDocInfoVOs.get(k).getItemName()));
		}
		logger.debug("getCodeContainer ended");
		
		return apprDocInfoVOs;
	}

	@Override
	public String getUserContTree(LoginVO userInfo, String parentContID) throws Exception {
		logger.debug("getUserContTree started");
		logger.debug("parentContID :: " + parentContID);
		
		StringBuilder rtnXML = new StringBuilder();
		String strLangDeptDocFolder = getCode2Name("L03", "001", userInfo.getTenantId(), userInfo.getLang());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentContID", parentContID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("userID", userInfo.getId());
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getUserContTree(map);
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("<TREEVIEWDATA>");
		} else {
			rtnXML.append("<NODES>");
		}
		
		if (apprContInfoVOs.size() > 0) {
			if (parentContID.equals("ROOT")) {
				rtnXML.append("<NODE>");
				rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getUserContName()) + "</VALUE>");
				rtnXML.append("<DATA1>" + apprContInfoVOs.get(0).getUserContID() + "</DATA1>");
				rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getDescription()) + "</DATA3>");
				rtnXML.append("<DATA4>" + userInfo.getId() + "</DATA4>");
				rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(apprContInfoVOs.get(0).getUserContID(), userInfo.getTenantId()) + "</ISLEAF>");
				rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
				rtnXML.append(getUserContTree(userInfo, apprContInfoVOs.get(0).getUserContID()));
				rtnXML.append("</NODE>");
			} else {
				for (int k = 0; k < apprContInfoVOs.size(); k++) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getUserContName()) + "</VALUE>");
					rtnXML.append("<DATA1>" + apprContInfoVOs.get(k).getUserContID() + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
					rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getDescription()) + "</DATA3>");
					rtnXML.append("<DATA4>" + userInfo.getId() + "</DATA4>");
					rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(apprContInfoVOs.get(k).getUserContID(), userInfo.getTenantId()) + "</ISLEAF>");
					rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		} else {
			if (parentContID.equals("ROOT")) {
				String newContID = createUserCont(userInfo, parentContID, strLangDeptDocFolder);
				
				if (!newContID.equals("")) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + userInfo.getDisplayName() + "</VALUE>");
					rtnXML.append("<DATA1>" + newContID + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID+ "</DATA2>");
                    rtnXML.append("<DATA3>" + strLangDeptDocFolder + "</DATA3>");
                    rtnXML.append("<DATA4>" + userInfo.getId() + "</DATA4>");
                    rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(newContID, userInfo.getTenantId()) + "</ISLEAF>");
                    rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		}
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("</TREEVIEWDATA>");
		} else {
			rtnXML.append("</NODE>");
		}
		
		logger.debug("getUserContTree ended");
		
		return rtnXML.toString();
	}

	private String createUserCont(LoginVO userInfo, String parentContID, String description) {
		logger.debug("createUserCont started");
		
		String rtnValue = "";
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		
		apprContInfoVO.setUserContName(userInfo.getDisplayName());
		apprContInfoVO.setParentContID(parentContID);
		apprContInfoVO.setDescription(description);
		apprContInfoVO.setUserID(userInfo.getId());
		apprContInfoVO.setTenantID(userInfo.getTenantId());
		
		try {
			String maxContainerID = ezApprovalAdminDAO.createUserCont(apprContInfoVO);
			
			rtnValue = maxContainerID;
		} catch (Exception e) {
			rtnValue = "";
		}
		
		logger.debug("createUserCont ended");
		
		return rtnValue;
	}

	private String getUserContTreeLeaf(String userContID, int tenantID) {
		logger.debug("getUserContTreeLeaf started");
		
		String isLeaf = "FALSE";
		
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		apprContInfoVO.setUserContID(userContID);
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			int leafCount = ezApprovalAdminDAO.getUserContTreeLeaf(apprContInfoVO);
			
			if (leafCount > 0) {
				isLeaf = "FALSE";
			} else {
				isLeaf = "TRUE";
			}
			
		} catch (Exception e) {
			return "FALSE";
		}
		
		logger.debug("getUserContTreeLeaf ended");
		
		return isLeaf;
	}

	public String getCode2Name(String code1, String code2, int tenantId, String lang) throws Exception{
		logger.debug("getCode2Name started");
		logger.debug("code1 :: " + code1 + "|| code2 :: " + code2);
		
		if (code1.length() > 3) {
			return code2;
		}
		
		ApprCodeVO apprCodeVO = new ApprCodeVO();
		apprCodeVO.setCode1(code1);
		apprCodeVO.setCode2(code2);
		apprCodeVO.setLang(lang);
		apprCodeVO.setTenantID(tenantId);
		
		String rtnValue = ezApprovalAdminDAO.getCode2Name(apprCodeVO);
		
		logger.debug("getCode2Name ended");
		
		return rtnValue;
	}

	@Override
	public String getListContainer(LoginVO userInfo) throws Exception {
		logger.debug("getListContainer started");
		
		String apprCont = "";
		String retCont  = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("staDSPumYui", staDSPumYui);
		map.put("staDSBalsin", staDSBalsin);
		map.put("deptID", userInfo.getDeptID());
		map.put("tenantID", userInfo.getTenantId());
		
		List<String> containerIDList = ezApprovalAdminDAO.getListContainerCont(map);
		
		for (int k = 0; k < containerIDList.size(); k++) {
			if (k == 0) {
				apprCont += "'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			} else {
				apprCont += ",'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			}
		}
		
		map.put("staDSBansong", staDSBansong);
		
		containerIDList = ezApprovalAdminDAO.getListContainer(map);
		
		for (int k = 0; k < containerIDList.size(); k++) {
			if (k == 0) {
				retCont += "'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			} else {
				retCont += ",'" + commonUtil.cleanValue(containerIDList.get(k)) + "'";
			}
		}
		
		logger.debug("getListContainer ended");
		
		return "<CONTAINER><APPRCONT>" + apprCont + "</APPRCONT><RETNCONT>" + retCont + "</RETNCONT></CONTAINER>";
	}

	@Override
	public String getDeptContTree(LoginVO userInfo, String parentContID) throws Exception {
		logger.debug("getDeptContTree started");
		logger.debug("parentContID :: " + parentContID);
		
		StringBuilder rtnXML = new StringBuilder();
		String strLangDeptDocFolder = getCode2Name("L03", "002", userInfo.getTenantId(), userInfo.getLang());
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("parentContID", parentContID);
		map.put("tenantID", userInfo.getTenantId());
		map.put("deptID", userInfo.getDeptID());
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getDeptContTree(map);
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("<TREEVIEWDATA>");
		} else {
			rtnXML.append("<NODES>");
		}
		
		if (apprContInfoVOs.size() > 0) {
			if (parentContID.equals("ROOT")) {
				rtnXML.append("<NODE>");
				rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getDeptContName()) + "</VALUE>");
				rtnXML.append("<DATA1>" + apprContInfoVOs.get(0).getDeptContID() + "</DATA1>");
				rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(0).getDescription()) + "</DATA3>");
				rtnXML.append("<DATA4>" + userInfo.getDeptID() + "</DATA4>");
				rtnXML.append("<DATA5>" + apprContInfoVOs.get(0).getSn() + "</DATA5>");
				rtnXML.append("<DATA6>" + apprContInfoVOs.get(0).getManageUserID() + "</DATA6>");
				rtnXML.append("<ISLEAF>" + getDeptContTreeLeaf(apprContInfoVOs.get(0).getDeptContID(), userInfo.getTenantId()) + "</ISLEAF>");
				rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
				rtnXML.append(getDeptContTree(userInfo, apprContInfoVOs.get(0).getDeptContID()));
				rtnXML.append("</NODE>");
			} else {
				for (int k = 0; k < apprContInfoVOs.size(); k++) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getDeptContName()) + "</VALUE>");
					rtnXML.append("<DATA1>" + apprContInfoVOs.get(k).getDeptContID() + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID + "</DATA2>");
					rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprContInfoVOs.get(k).getDescription()) + "</DATA3>");
					rtnXML.append("<DATA4>" + userInfo.getDeptID() + "</DATA4>");
					rtnXML.append("<DATA5>" + apprContInfoVOs.get(k).getSn() + "</DATA5>");
					rtnXML.append("<DATA6>" + apprContInfoVOs.get(k).getManageUserID() + "</DATA6>");
					rtnXML.append("<ISLEAF>" + getUserContTreeLeaf(apprContInfoVOs.get(k).getUserContID(), userInfo.getTenantId()) + "</ISLEAF>");
					rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		} else {
			if (parentContID.equals("ROOT")) {
				String newContID = createDeptCont(userInfo, parentContID, "1", strLangDeptDocFolder, "");
				
				if (!newContID.equals("")) {
					rtnXML.append("<NODE>");
					rtnXML.append("<VALUE>" + userInfo.getDisplayName() + "</VALUE>");
					rtnXML.append("<DATA1>" + newContID + "</DATA1>");
					rtnXML.append("<DATA2>" + parentContID+ "</DATA2>");
                    rtnXML.append("<DATA3>" + strLangDeptDocFolder + "</DATA3>");
                    rtnXML.append("<DATA4>" + userInfo.getDeptID() + "</DATA4>");
                    rtnXML.append("<ISLEAF>" + getDeptContTreeLeaf(newContID, userInfo.getTenantId()) + "</ISLEAF>");
                    rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("</NODE>");
				}
			}
		}
		
		if (parentContID.equals("ROOT")) {
			rtnXML.append("</TREEVIEWDATA>");
		} else {
			rtnXML.append("</NODE>");
		}
		
		logger.debug("getDeptContTree ended");
		
		return rtnXML.toString();
	}

	private String createDeptCont(LoginVO userInfo, String parentContID, String sn, String description, String manageUserID) {
		logger.debug("createDeptCont started");
		
		String rtnValue = "";
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		
		apprContInfoVO.setDeptContName(userInfo.getDeptName());
		apprContInfoVO.setParentContID(parentContID);
		apprContInfoVO.setSn(sn);
		apprContInfoVO.setDescription(description);
		apprContInfoVO.setDeptID(userInfo.getDeptID());
		apprContInfoVO.setManageUserID(manageUserID);
		apprContInfoVO.setTenantID(userInfo.getTenantId());
		
		try {
			String maxContainerID = ezApprovalAdminDAO.createDeptCont(apprContInfoVO);
			
			rtnValue = maxContainerID;
		} catch (Exception e) {
			rtnValue = "";
		}
		
		logger.debug("createDeptCont ended");
		
		return rtnValue;
	}

	private String getDeptContTreeLeaf(String deptContID, int tenantID) {
		logger.debug("getDeptContTreeLeaf started");
		
		String isLeaf = "FALSE";
		
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		apprContInfoVO.setDeptContID(deptContID);
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			int leafCount = ezApprovalAdminDAO.getDeptContTreeLeaf(apprContInfoVO);
			
			if (leafCount > 0) {
				isLeaf = "FALSE";
			} else {
				isLeaf = "TRUE";
			}
			
		} catch (Exception e) {
			return "FALSE";
		}
		
		logger.debug("getDeptContTreeLeaf ended");
		
		return isLeaf;
	}

	@Override
	public List<ApprContInfoVO> getSpecialContTree(LoginVO userInfo) throws Exception {
		logger.debug("getSpecialContTree started");
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getSpecialContTree(userInfo);
		
//		for (int k = 0; k < apprContInfoVOs.size(); k++) {
//			apprContInfoVOs.get(k).setContType("SC" + apprContInfoVOs.get(k).getContType());
//		}
		
		logger.debug("getSpecialContTree ended");
		
		return apprContInfoVOs;
	}

	@Override
	public String getDocType(String selected, LoginVO userInfo) throws Exception {
		logger.debug("getDocType started");
		
		StringBuilder selOption = new StringBuilder();
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getDocType(userInfo.getTenantId());
		
		for (int k = 0; k < apprCodeVOs.size(); k++) {
			if (apprCodeVOs.get(k).getCode().equals(selected)) {
				selOption.append("<OPTION value=" + apprCodeVOs.get(k).getCode() + " selected>" + apprCodeVOs.get(k).getName() + "</OPTION>");
			} else {
				selOption.append("<OPTION value=" + apprCodeVOs.get(k).getCode() + ">" + apprCodeVOs.get(k).getName() + "</OPTION>");
			}
		}
		
		logger.debug("getDocType ended");
		
		return selOption.toString();
	}
	
}
