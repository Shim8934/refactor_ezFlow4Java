package egovframework.ezEKP.ezApproval.service.impl;

import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezApproval.dao.EzApprovalAdminDAO;
import egovframework.ezEKP.ezApproval.service.EzApprovalAdminService;
import egovframework.ezEKP.ezApproval.vo.ApprAutoRuleVO;
import egovframework.ezEKP.ezApproval.vo.ApprCodeVO;
import egovframework.ezEKP.ezApproval.vo.ApprConnInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprContInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprDocItemVO;
import egovframework.ezEKP.ezApproval.vo.ApprExcelOutVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormContVO;
import egovframework.ezEKP.ezApproval.vo.ApprFormInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprLineInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprReceiptInfoVO;
import egovframework.ezEKP.ezApproval.vo.ApprReceiveGroupVO;
import egovframework.ezEKP.ezApproval.vo.ApprSealInfoVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
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
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
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
		String strLangDeptDocFolder = getCode2Name("L03", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
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

	public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getCode2Name started");
		logger.debug("code1 :: " + code1 + "|| code2 :: " + code2);
		
		if (code1.length() > 3) {
			return code2;
		}
		
		ApprCodeVO apprCodeVO = new ApprCodeVO();
		apprCodeVO.setCode1(code1);
		apprCodeVO.setCode2(code2);
		apprCodeVO.setLang(lang);
		apprCodeVO.setCompanyID(companyID);
		apprCodeVO.setTenantID(tenantID);
		
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
		String strLangDeptDocFolder = getCode2Name("L03", "002", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
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

	@Override
	public String getContainerInfoManage(String deptID, String mode, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("getContainerInfoManage started");
		
		StringBuilder resultXML = new StringBuilder();
		
		if (mode.equals("LIST")) {
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + getCode2Name("L02", "001", companyID, userInfo.getLang(), userInfo.getTenantId()) + "</NAME>");
			resultXML.append("<WIDTH>" + "250" + "</WIDTH>");
			resultXML.append("</HEADER>");
			resultXML.append("</HEADERS>");
			
			userInfo.setCompanyID(companyID);
			userInfo.setDeptID(deptID);
			
			List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getContainerInfoManage(userInfo);
			
			for (int k = 0; k < apprContInfoVOs.size(); k++) {
				resultXML.append("<ROW>");
				resultXML.append("<CELL>");
				
				if (userInfo.getPrimary().equals("1")) {
					resultXML.append("<VALUE>" + apprContInfoVOs.get(k).getContainerTypeName() + "</VALUE>");
				} else {
					resultXML.append("<VALUE>" + apprContInfoVOs.get(k).getContainerTypeName2() + "</VALUE>");
				}
				resultXML.append("<DATA1>" + apprContInfoVOs.get(k).getContainerID() + "</DATA1>");
				resultXML.append("<DATA2>" + apprContInfoVOs.get(k).getContainerTypeID() + "</DATA2>");
				
				if (userInfo.getPrimary().equals("1")) {
					resultXML.append("<DATA3>" + apprContInfoVOs.get(k).getContainerTypeName() + "</DATA3>");
				} else {
					resultXML.append("<DATA3>" + apprContInfoVOs.get(k).getContainerTypeName2() + "</DATA3>");
				}
				resultXML.append("<DATA4>" + apprContInfoVOs.get(k).getContainerOwnDepID() + "</DATA4>");
				resultXML.append("</CELL>");
				resultXML.append("</ROW>");
			}
			
			resultXML.append("</LISTVIEWDATA>");
		} else {
			resultXML.append("<PARAMETER>");
			
			userInfo.setCompanyID(companyID);
			userInfo.setDeptID(deptID);
			
			List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getContainerInfoManage(userInfo);
			
			for (int k = 0; k < apprContInfoVOs.size(); k++) {
				resultXML.append("<CONTID" + k + ">");
				resultXML.append(apprContInfoVOs.get(k).getContainerID());
				resultXML.append("</CONTID" + k + ">");
				
				if (userInfo.getPrimary().equals("1")) {
					resultXML.append("<NAME" + k + ">");
					resultXML.append(apprContInfoVOs.get(k).getContainerTypeName());
					resultXML.append("</NAME" + k + ">");
				} else {
					resultXML.append("<NAME" + k + ">");
					resultXML.append(apprContInfoVOs.get(k).getContainerTypeName2());
					resultXML.append("</NAME" + k + ">");
				}
			}
			resultXML.append("</PARAMETER>");
			
		}
		
		logger.debug("getContainerInfoManage ended");
		
		return resultXML.toString();
	}

	@Override
	public String getContTypeInfo(String mode, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("getContTypeInfo started");
		
		StringBuilder rtnXML = new StringBuilder();
		
		userInfo.setCompanyID(companyID);
		userInfo.setPrimary(commonUtil.getMultiData(userInfo.getLang()));
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getContTypeInfo(userInfo);
		
		if (mode.equals("LIST")) {
			rtnXML.append("<LISTVIEWDATA><HEADERS><HEADER>");
			rtnXML.append("<NAME>" + getCode2Name("L02", "001", companyID, userInfo.getLang(), userInfo.getTenantId()) + "</NAME><WIDTH>250</WIDTH></HEADER></HEADERS><ROWS>");
			
			for (int k = 0; k < apprContInfoVOs.size(); k++) {
				rtnXML.append("<ROW><CELL><VALUE>");
				rtnXML.append(commonUtil.cleanValue(apprContInfoVOs.get(k).getContainerTypeName()));
				rtnXML.append("</VALUE><DATA1>");
				rtnXML.append(commonUtil.cleanValue(apprContInfoVOs.get(k).getContainerTypeID()));
				rtnXML.append("</DATA1></CELL></ROW>");
			}
			
			rtnXML.append("</ROWS></LISTVIEWDATA>");
		} else {
			rtnXML.append("<PARAMETER>");
			
			for (int k = 0; k < apprContInfoVOs.size(); k++) {
				rtnXML.append("<ID" + k + ">");
				rtnXML.append(commonUtil.cleanValue(apprContInfoVOs.get(k).getContainerTypeID()));
				rtnXML.append("</ID" + k + ">");
				rtnXML.append("<NAME" + k + ">");
				rtnXML.append(commonUtil.cleanValue(ezOrganService.getPropertyValue(apprContInfoVOs.get(k).getContainerTypeName(), "displayName" + commonUtil.getMultiData(userInfo.getLang()), userInfo.getTenantId())));
				rtnXML.append("</NAME" + k + ">");
			}
			rtnXML.append("</PARAMETER>");
		}
		
		logger.debug("getContTypeInfo ended");
		
		return rtnXML.toString();
	}

	@Override
	public String insertContainerType(String docTypeName, String docTypeName2, String companyID, int tenantID) throws Exception {
		logger.debug("insertContainerType started");

		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("docTypeName", docTypeName);
		map.put("docTypeName2", docTypeName2);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("maxID", "");
		
		try {
			ezApprovalAdminDAO.insertContainerType(map);
			
			rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}
		
		logger.debug("insertContainerType ended");
		
		return rtnValue;
	}

	@Override
	public String deleteContainerType(String codeID, String companyID, int tenantID) throws Exception{
		logger.debug("deleteContainerType started");
		
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("codeID", codeID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			int contCnt = ezApprovalAdminDAO.getContCount(map); 
					
			if (contCnt <= 0) {
				ezApprovalAdminDAO.deleteContDocState(map);
				ezApprovalAdminDAO.deleteContainerType(map);
				
				rtnValue = "TRUE";
			} else {
				rtnValue = "USE";
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "FALSE";
		}
		
		logger.debug("deleteContainerType ended");
		
		return rtnValue;
	}

	@Override
	public String getContainerToDocStateInfo(String companyID, Locale locale, String lang, int tenantID) throws Exception {
		logger.debug("getContainerToDocStateInfo started");
		
		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = getListHeader("108", lang, companyID, tenantID);
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getContainerToDocStateInfo(map);
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < apprContInfoVOs.size(); k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + egovMessageSource.getMessage("ezApproval." + apprContInfoVOs.get(k).getDocumentStateName(), locale) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(apprContInfoVOs.get(k).getDocumentState()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(apprContInfoVOs.get(k).getDocumentCode()) + "</DATA2>");
			resultXML.append("</CELL>");
			
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(lang).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(apprContInfoVOs.get(k).getContainerTypeName()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(apprContInfoVOs.get(k).getContainerTypeName2()) + "</VALUE>");
			}
			resultXML.append("<DATA1>" + apprContInfoVOs.get(k).getContainerTypeID() + "</DATA1>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getContainerToDocStateInfo ended");
		
		return resultXML.toString();
	}

	private List<ApprCodeVO> getListHeader(String listCode, String lang, String companyID, int tenantID) throws Exception{
		logger.debug("getListHeader started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("listCode", listCode);
		map.put("lang", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getListHeader(map);
		
		logger.debug("getListHeader ended");
		
		return apprCodeVOs;
	}

	@Override
	public String updateContainerToDocStateInfo(Document doc, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("updateContainerToDocStateInfo started");
		
		StringBuilder insString = new StringBuilder();
		String delString = "";
		String rtnValue = "";
		NodeList nList = doc.getElementsByTagName("CONTTYPE");
		
		for (int k = 0; k < nList.getLength(); k++) {
			if (k == 0) {
				delString += "'" + nList.item(k).getChildNodes().item(0).getTextContent() + "'";
			} else {
				delString += ", '" + nList.item(k).getChildNodes().item(0).getTextContent() + "'";
			}
			
			if (nList.item(k).getChildNodes().item(1).getTextContent() != null && !nList.item(k).getChildNodes().item(1).getTextContent().equals("")) {
				insString.append("INTO TBCONTAINERTODOCSTATE ( CONTAINERTYPEID, DOCUMENTSTATE, COMPANYID, TENANT_ID ) VALUES ('" + nList.item(k).getChildNodes().item(1).getTextContent() + "', '");
				insString.append(nList.item(k).getChildNodes().item(0).getTextContent() + "', '" + companyID + "', '" + tenantID + "')");
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("delString", delString);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			ezApprovalAdminDAO.deleteContainerToDocStateInfo(map);
			ezApprovalAdminDAO.insertContainerToDocStateInfo(insString.toString());

			rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}
 		
		logger.debug("updateContainerToDocStateInfo ended");
		
		return rtnValue;
	}

	@Override
	public String getContainerUseDeptInfo(String contID, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getContainerUseDeptInfo started");
		
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<String> userDeptIDs = ezApprovalAdminDAO.getContainerUseDeptInfo(map);
		
		rtnXML.append("<PARAMETER>");
		
		if (userDeptIDs.size() > 0) {
			for (int k = 0; k < userDeptIDs.size(); k++) {
				rtnXML.append("<ID" + k + ">");
				rtnXML.append(commonUtil.cleanValue(userDeptIDs.get(k)));
				rtnXML.append("</ID" + k + ">");
				rtnXML.append("<NAME" + k + ">");
				rtnXML.append(commonUtil.cleanValue(ezOrganService.getPropertyValue(userDeptIDs.get(k), "displayName" + commonUtil.getMultiData(lang), tenantID)));
				rtnXML.append("</NAME" + k + ">");
			}
		} else {
			rtnXML.append("<ID0>FALSE</ID0><NAME0></NAME0>");
		}
		
		rtnXML.append("</PARAMETER>");
		
		logger.debug("getContainerUseDeptInfo ended");
		
		return rtnXML.toString();
	}

	@Override
	public String insertContainer(String contType, String contOwnDeptID, String selUseDept, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("insertContainer started");
		
		StringBuilder insString = new StringBuilder();
		String[] selUseDepts = selUseDept.split(",");
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contOwnDeptID", contOwnDeptID);
		map.put("contType", contType);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		map.put("maxContID", "");
		
		try {
			ezApprovalAdminDAO.insertContainer(map);
			
			if (selUseDepts.length > 0) {
				for (int k = 0; k < selUseDepts.length; k++) {
					insString.append("INTO TBCONTAINERUSEDEP ( CONTAINERID, USEDEPID, COMPANYID, TENANT_ID ) ");
					insString.append("VALUES ('" + map.get("maxContID") + "', '" + selUseDepts[k] + "', '" + companyID + "', '" + tenantID + "')");
				}
			}
			
			ezApprovalAdminDAO.insertContainerUseDept(insString.toString());
			
			rtnValue = "<PARAMETER><RtnVal>TRUE</RtnVal></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RtnVal>FALSE</RtnVal></PARAMETER>";
		}
		
		logger.debug("insertContainer ended");
		
		return rtnValue;
	}

	@Override
	public String updateContainer(String contType, String contID, String contOwnDeptID, String selUseDept, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("updateContainer started");
		
		StringBuilder insString = new StringBuilder();
		String[] selUseDepts = selUseDept.split(",");
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contOwnDeptID", contOwnDeptID);
		map.put("contType", contType);
		map.put("contID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			ezApprovalAdminDAO.updateContainer(map);
			ezApprovalAdminDAO.deleteContainerUseDept(map);
			
			if (selUseDepts.length > 0) {
				for (int k = 0; k < selUseDepts.length; k++) {
					insString.append("INTO TBCONTAINERUSEDEP ( CONTAINERID, USEDEPID, COMPANYID, TENANT_ID ) ");
					insString.append("VALUES ('" + map.get("maxContID") + "', '" + selUseDepts[k] + "', '" + companyID + "', '" + tenantID + "')");
				}
			}
			
			ezApprovalAdminDAO.insertContainerUseDept(insString.toString());
			
			rtnValue = "<PARAMETER><RTNVALUE>TRUE</RTNVALUE></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RTNVALUE>FALSE</RTNVALUE></PARAMETER>";
		}
		
		logger.debug("updateContainer ended");
		
		return rtnValue;
	}

	@Override
	public String deleteContainer(String contID, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("deleteContainer started");
		
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contID", contID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			ezApprovalAdminDAO.deleteContainerUseDept(map);
			ezApprovalAdminDAO.deleteContainer(map);
			
			rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}
		
		logger.debug("deleteContainer ended");
		
		return rtnValue;
	}

	@Override
	public String getSpecialContList(String deptID, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getSpecialContList started");
		
		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = getListHeader("109", lang, companyID, tenantID);
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getSpecialContList(map);
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < apprContInfoVOs.size(); k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>");
			
			String contType = apprContInfoVOs.get(k).getContType();
			
			if (Integer.parseInt(contType) >= 100) {
				map.put("lang", commonUtil.getMultiData(lang));
				map.put("contType", contType);
				
				String contTypeName = ezApprovalAdminDAO.getSpecialContInfoContTypeName(map);
				
				resultXML.append(contTypeName);
			} else {
				resultXML.append(getCode2Name("A60", contType, companyID, lang, tenantID));
			}
			resultXML.append("</VALUE>");
			resultXML.append("<DATA1>" + apprContInfoVOs.get(k).getDeptID() + "</DATA1>");
			resultXML.append("<DATA2>" + contType + "</DATA2>");
			resultXML.append("<DATA3>" + apprContInfoVOs.get(k).getSn() + "</DATA3>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + apprContInfoVOs.get(k).getContName() + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + apprContInfoVOs.get(k).getSubQuery() + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getSpecialContList ended");
		
		return resultXML.toString();
	}

	@Override
	public String getSpecialContCode(String contType, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getSpecialContCode started");
		
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("code1", "A60");
		map.put("companyID", companyID);
		map.put("lang", lang);
		map.put("tenantID", tenantID);
		
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getCodeType(map);
		
		for (int k = 0; k < apprCodeVOs.size(); k++) {
			String code = apprCodeVOs.get(k).getCode2();
			
			if (code.equals(contType)) {
				rtnXML.append("<OPTION value=" + code + " selected>" + apprCodeVOs.get(k).getName() + "</OPTION>");
			} else {
				rtnXML.append("<OPTION value=" + code + ">" + apprCodeVOs.get(k).getName() + "</OPTION>");
			}
		}
		
		LoginVO userInfo = new LoginVO();
		
		userInfo.setCompanyID(companyID);
		userInfo.setTenantId(tenantID);
		userInfo.setPrimary(commonUtil.getMultiData(lang));
		
		List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getContTypeInfo(userInfo);
		
		for (int k = 0; k < apprContInfoVOs.size(); k++) {
			String typeID = apprContInfoVOs.get(k).getContainerTypeID();
			
			if (typeID.equals(contType)) {
				rtnXML.append("<OPTION value =" + typeID + " selected>" + apprContInfoVOs.get(k).getContainerTypeName() + "</OPTION>");
			} else {
				rtnXML.append("<OPTION value =" + typeID + ">" + apprContInfoVOs.get(k).getContainerTypeName() + "</OPTION>");
			}
		}
		
		logger.debug("getSpecialContCode ended");
		
		return rtnXML.toString();
	}

	@Override
	public String getSpecialContInfo(String deptID, String contType, String sn, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getSpecialContInfo started");
		
		StringBuilder resultXML = new StringBuilder();
		ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
		
		apprContInfoVO.setDeptID(deptID);
		apprContInfoVO.setContType(contType);
		apprContInfoVO.setSn(sn);
		apprContInfoVO.setCompanyID(companyID);
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			List<ApprContInfoVO> apprContInfoVOs = ezApprovalAdminDAO.getSpecialContInfo(apprContInfoVO);
			
			resultXML.append("<CONTINFO>");
			resultXML.append("<DEPTID>" + apprContInfoVOs.get(0).getDeptID() + "</DEPTID>");
			resultXML.append("<CONTTYPE>" + apprContInfoVOs.get(0).getContType() + "</CONTTYPE>");
			resultXML.append("<SN>" + apprContInfoVOs.get(0).getSn() + "</SN>");
			resultXML.append("<CONTNAME>" + apprContInfoVOs.get(0).getContName() + "</CONTNAME>");
			
			String subQuery = apprContInfoVOs.get(0).getSubQuery();
			
			if (subQuery != null && subQuery.indexOf("NOT") > 0) {
				resultXML.append("<CONTYN>N</CONTYN>");
			} else {
				resultXML.append("<CONTYN>Y</CONTYN>");
			}
			resultXML.append("<FORMIDS>");
			
			if (subQuery != null && subQuery.length() > 0) {
				Map<String, Object> map = new HashMap<String, Object>();
				
				map.put("lang", commonUtil.getMultiData(lang));
				map.put("subQuery", subQuery);
				map.put("companyID", companyID);
				map.put("tenantID", tenantID);
				
				List<String> formIDName = ezApprovalAdminDAO.getSpecialContInfoFormName(map);
				
				for (int k = 0; k < formIDName.size(); k++) {
					resultXML.append("<FORMID>" + formIDName.get(k) + "</FORMID>");
				}
			}
			resultXML.append("</FORMIDS>");
			resultXML.append("</CONTINFO>");
		} catch (Exception e) {
			logger.error(e.getMessage());
			resultXML.append("<CONTINFO><DEPTID></DEPTID><CONTTYPE></CONTTYPE><SN></SN><CONTNAME></CONTNAME><CONTYN></CONTYN><FORMIDS></FORMIDS></CONTINFO>");
		}
		
		logger.debug("getSpecialContInfo ended");
		
		return resultXML.toString();
	}

	@Override
	public String getFormContainerInfo(String id, String deptID, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getFormContainerInfo started");
		
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("id", id);
		map.put("lang", commonUtil.getMultiData(lang));
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprFormContVO> apprFormContVOs = ezApprovalAdminDAO.getFormContainerInfo(map);
		
		rtnXML.append("<NODES>");
		
		for (int k = 0; k < apprFormContVOs.size(); k++) {
			rtnXML.append("<NODE>");
			
			if (k == 0) {
				rtnXML.append("<SELECT></SELECT>");
			}
			
			int childCnt = getCountChildFormCont(apprFormContVOs.get(k).getFormContID(), deptID, companyID, tenantID);
			String isLeaf = "FALSE";
			
			if (childCnt < 1) {
				isLeaf = "TRUE";
			}
			
			rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
			rtnXML.append("<ISLEAF>" + isLeaf + "</ISLEAF>");
			rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContName()) + "</VALUE>");
			
			if (deptID == null || deptID.equals("")) {
				rtnXML.append("<DATA1>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContID()) + "</DATA1>");
				rtnXML.append("<DATA2>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContName()) + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContOwnDepID()) + "</DATA3>");
				rtnXML.append("<DATA4>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContParents()) + "</DATA4>");
				rtnXML.append("<DATA5>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContDescription()) + "</DATA5>");
				
				if (apprFormContVOs.get(k).getFormContOwnDepID().equals("ALL")) {
					rtnXML.append("<DATA6>ALL</DATA6>");
				} else {
					rtnXML.append("<DATA6>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(apprFormContVOs.get(k).getFormContOwnDepID(), "displayName" + commonUtil.getMultiData(lang), tenantID)) + "</DATA6>");
				}
				
				rtnXML.append("<DATA7>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContName2()) + "</DATA7>");
			} else {
				rtnXML.append("<DATA1>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContID()) + "</DATA1>");
				rtnXML.append("<DATA2>" + commonUtil.cleanValue(deptID) + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(apprFormContVOs.get(k).getFormContDescription()) + "</DATA3>");
			}
			
			rtnXML.append("</NODE>");
		}
		
		rtnXML.append("</NODES>");
		
		logger.debug("getFormContainerInfo ended");
		
		return rtnXML.toString();
	}

	private int getCountChildFormCont(String formContID, String deptID, String companyID, int tenantID) throws Exception{
		logger.debug("getCountChildFormCont started");
		
		int rtnVal = 1;
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("formContID", formContID);
		map.put("deptID", deptID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		rtnVal = ezApprovalAdminDAO.getFormContainerCntChild(map);
		
		logger.debug("getCountChildFormCont ended");
		
		return rtnVal;
	}

	@Override
	public String getFormInfo(ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("getFormInfo started");
		
		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = getListHeader("101", apprFormInfoVO.getLang(), apprFormInfoVO.getCompanyID(), apprFormInfoVO.getTenantID());
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		List<ApprFormInfoVO> apprFormInfoVOs = ezApprovalAdminDAO.getFormInfo(apprFormInfoVO);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprFormInfoVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprFormInfoVOs.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int h = 0; h < headerList.size(); h++) {
				resultXML.append("<CELL>");
				
				fieldName = headerList.get(h).getColName().toUpperCase();
				
				if (fieldName.equals("FORMNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(apprFormInfoVO.getLang());
				}
				
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(fieldValue)) + "</VALUE>");
				
				if (h == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("FORMDESCRIPTION").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("FORMDOCTYPE").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("FORMFILELOCATION").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("FORMNAME").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("FORMNAME2").item(k).getTextContent()) + "</DATA6>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
				
		logger.debug("getFormInfo ended");
		
		return resultXML.toString();
	}

	@Override
	public String addSpecialCont(ApprContInfoVO apprContInfoVO, int tenantID) throws Exception {
		logger.debug("addSpecialCont started");

		String rtnValue = "";
		
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			if (apprContInfoVO.getSn() == null || apprContInfoVO.getSn().equals("") || apprContInfoVO.getSn().equals("0")) {
				apprContInfoVO.setSn("new");
			} else {
				ezApprovalAdminDAO.deleteSpecialContInfo(apprContInfoVO);
			}
			
			String subQuery = "";
			
			if (apprContInfoVO.getFormIDs() != null && !apprContInfoVO.getFormIDs().equals("")) {
				if (apprContInfoVO.getContYN().equals("Y")) {
					subQuery = " formID IN (" + apprContInfoVO.getFormIDs() + ")"; 
				} else {
					subQuery = " formID NOT IN (" + apprContInfoVO.getFormIDs() + ")"; 
				}
			}
			
			apprContInfoVO.setSubQuery(subQuery);
			
			ezApprovalAdminDAO.insertSpecialContInfo(apprContInfoVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("addSpecialCont ended");
		
		return rtnValue;
	}

	@Override
	public String delSpecialCont(ApprContInfoVO apprContInfoVO, int tenantID) throws Exception {
		logger.debug("delSpecialCont started");

		String rtnValue = "";
		
		apprContInfoVO.setTenantID(tenantID);
		
		try {
			ezApprovalAdminDAO.deleteSpecialContInfo(apprContInfoVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("delSpecialCont ended");
		
		return rtnValue;
	}

	@Override
	public String changeSpecialContSN(String deptID, String sContType, String sSn, String tContType, String tSn, String companyID, int tenantID) throws Exception {
		logger.debug("changeSpecialContSN started");
		
		String rtnValue = "";
		
		try {
			ApprContInfoVO apprContInfoVO = new ApprContInfoVO();
			
			apprContInfoVO.setDeptID(deptID);
			apprContInfoVO.setContType(sContType);
			apprContInfoVO.setContType2(tContType);
			apprContInfoVO.setSn(sSn);
			apprContInfoVO.setSn2(tSn);
			apprContInfoVO.setCompanyID(companyID);
			apprContInfoVO.setTenantID(tenantID);
			
			ezApprovalAdminDAO.changeSpecialContSN1(apprContInfoVO);
			ezApprovalAdminDAO.changeSpecialContSN2(apprContInfoVO);
			ezApprovalAdminDAO.changeSpecialContSN3(apprContInfoVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("changeSpecialContSN ended");
		
		return rtnValue;
	}

	@Override
	public String getContDocList(String contID, String userID, StringBuilder subQuery, int pageSize, int pageNum, String sortHeader, String sortOption, String companyID, LoginVO userInfo) throws Exception {
		logger.debug("getContDocList started");
		
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		String userSecurityCode = ""; 
		String securityFlag = "";
		String securityLineFlag = "";
		String isUse = "";
		String publicFlag = "";
		String strSubQuery = "";
		int querySizeSub = 0;
		int querySizeMain = 0;
		
		List<ApprCodeVO> headerList = new ArrayList<ApprCodeVO>();
		
		if (contID != null && contID.equals("ADMIN"))	{
			headerList = getListHeader("082", userInfo.getLang(), companyID, userInfo.getTenantId());
		} else {
			headerList = getListHeader("006", userInfo.getLang(), companyID, userInfo.getTenantId());
		}
		
		resultXML.append("<DOCLIST>");
		
		//보안등급사용여부
		isUse = getCodeIsUse("A22", "001", companyID, userInfo.getTenantId());
		
		if (isUse.equals("1")) {
			securityFlag = "Y";
			
			isUse = getCodeIsUse("A22", "005", companyID, userInfo.getTenantId());
			
			if (isUse.equals("1")) {
				securityLineFlag = "Y";
			}
			
			if (userID != null && !userID.equals("")) {
				userSecurityCode = getUserSecurityCode(userID, userInfo.getTenantId());
			}
		}
		
		if (userSecurityCode == null || userSecurityCode.equals("")) {
			userSecurityCode = "0";
		}
		//공개/비공개 사용여부
		isUse = getCodeIsUse("A22", "004", companyID, userInfo.getTenantId());
		
		if (isUse.equals("1")) {
			publicFlag = "Y";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contID", contID);
		map.put("userID", userID);
		map.put("userSecurityCode", userSecurityCode);
		map.put("publicFlag", publicFlag);
		map.put("securityFlag", securityFlag);
		map.put("subQuery", subQuery);
		map.put("companyID", companyID);
		map.put("userInfo.getTenantId()", userInfo.getTenantId());
		
		int totalCount = ezApprovalAdminDAO.getContDocListCount(map);
		
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + headerList.get(k).getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
			
			if (sortHeader != null && sortHeader.equals(headerList.get(k).getName())) {
				if (sortOption == null || sortOption.equals("")) {
					orderOption1 = headerList.get(k).getColName() + " ";
					orderOption2 = headerList.get(k).getColName() + " desc ";
				} else {
					orderOption1 = headerList.get(k).getColName() + " desc ";
					orderOption2 = headerList.get(k).getColName() + " ";
				}
			}
		}
		resultXML.append("</HEADERS>");
		
		querySizeSub = pageSize * pageNum;
		querySizeMain = totalCount - (pageSize * (pageNum - 1));
		
		if (querySizeMain >= pageSize) {
			querySizeMain = pageSize;
		}
		
		if (orderOption1.indexOf("SendFlag") > 0) {
			orderOption1 = " ";
		}
		
		if (orderOption2.indexOf("SendFlag") > 0) {
			orderOption2 = " ";
		}
		
		if (orderOption1.indexOf("DocStateName") > 0) {
			orderOption1 = orderOption1.replace("DocStateName", "DOCSTATE");
		}
		
		if (orderOption2.indexOf("DocStateName") > 0) {
			orderOption2 = orderOption2.replace("DocStateName", "DOCSTATE");
		}
		
		if (orderOption1.length() > 0) {
			if (orderOption1.length() >= 7) {
				if (orderOption1.substring(0, 7).toLowerCase().equals("enddate")) {
					orderOption1 = " ORDER BY '" + orderOption1 + "' ";
				} else {
					orderOption1 = " ORDER BY '" + orderOption1 + "', ENDDATE DESC ";
				}
			} else {
				orderOption1 = " ORDER BY '" + orderOption1 + "', ENDDATE DESC ";
			}
		} else {
			orderOption1 = " ORDER BY ENDDATE DESC ";
		}
		
		if (orderOption2.length() > 0) {
			if (orderOption2.length() >= 7) {
				if (orderOption2.substring(0, 7).toLowerCase().equals("enddate")) {
					orderOption2 = " ORDER BY '" + orderOption2 + "' ";
				} else {
					orderOption2 = " ORDER BY '" + orderOption2 + "', ENDDATE DESC ";
				}
			} else {
				orderOption2 = " ORDER BY '" + orderOption2 + "', ENDDATE DESC ";
			}
		} else {
			orderOption2 = " ORDER BY ENDDATE DESC ";
		}
		
		strSubQuery = "SELECT * FROM (SELECT DISTINCT A.DOCID, A.DOCTYPE, A.DOCSTATE, A.FUNCTIONTYPE, A.HREF, "
				+ "A.DOCTITLE, A.DOCNO, A.HASATTACHYN, A.HASOPINIONYN, A.STARTDATE, A.ENDDATE, A.WRITERID, A.WRITERNAME , "
				+ "A.WRITERNAME2, A.WRITERJOBTITLE, A.WRITERJOBTITLE2, A.WRITERDEPTID, A.WRITERDEPTNAME, A.WRITERDEPTNAME2, "
				+ "A.FORMID, A.CONTAINERID, TBEXPENDAPRDOCINFO.FORMNAME, TBEXPENDAPRDOCINFO.FORMNAME2, TBEXPENDAPRDOCINFO.STATUS, "
				+ "A.ORGDOCID, A.ISPUBLIC, TBEXPENDAPRDOCINFO.EDMSYN, A.TENANT_ID, A.COMPANYID "
				+ "FROM TBENDAPRDOCINFO A  LEFT OUTER JOIN TBENDAPRLINEINFO ON A.TENANT_ID = TBENDAPRLINEINFO.TENANT_ID AND A.COMPANYID = TBENDAPRLINEINFO.COMPANYID AND A.DOCID = TBENDAPRLINEINFO.DOCID  "
				+ "LEFT OUTER JOIN TBEXPENDAPRLINE ON A.TENANT_ID = TBEXPENDAPRLINE.TENANT_ID AND A.COMPANYID = TBEXPENDAPRLINE.COMPANYID AND A.DOCID = TBEXPENDAPRLINE.DOCID "
				+ "INNER JOIN TBEXPENDAPRDOCINFO ON A.TENANT_ID = TBEXPENDAPRDOCINFO.TENANT_ID AND A.COMPANYID = TBEXPENDAPRDOCINFO.COMPANYID AND A.DOCID = TBEXPENDAPRDOCINFO.DOCID "
				+ "WHERE A.TENANT_ID = '" + userInfo.getTenantId() + "' AND A.COMPANYID = '" + companyID + "' AND TBEXPENDAPRDOCINFO.DELFLAG IS NULL ";
		
		if (contID == null || contID.equals("")) {
			strSubQuery += " AND TBENDAPRLINEINFO.APRMEMBERID = '" + userID + "' ";
		} else if (contID.equals("ADMIN")){
			strSubQuery += " AND CONTAINERID IS NOT NULL ";
		} else {
			strSubQuery += " AND CONTAINERID IN ('" + contID + "') ";
		}
		
		if (!userSecurityCode.equals("0") && contID != null && !contID.equals("ADMIN")) {
			if (securityLineFlag.equals("Y")) {
				strSubQuery += " AND ( '" + userSecurityCode + "' <= TBEXPENDAPRDOCINFO.SECURITYCODE OR " + getIsLineInfo("A.DOCID", userID, companyID, userInfo.getTenantId()) + ") = 'Y') ";
			} else {
				strSubQuery += " AND ( '" + userSecurityCode + "' <= TBEXPENDAPRDOCINFO.SECURITYCODE ";
			}
		}
		
		if (publicFlag.equals("Y") && contID != null && !contID.equals("")) {
			strSubQuery += " AND ( (A.ISPUBLIC <> 'N' OR A.ISPUBLIC IS NULL) OR (A.ISPUBLIC = 'N' AND TBENDAPRLINEINFO.APRMEMBERID = '" + userID + "')) ";
		}
		
		if (subQuery.length() > 0) {
			strSubQuery += " AND " + subQuery + " ";
		}
		
		
		map.put("strSubQuery", strSubQuery + orderOption1);
		map.put("orderByMain", orderOption2);
		map.put("querySizeSub", querySizeSub);
		map.put("querySizeMain", querySizeMain);
		
		List<ApprDocInfoVO> apprDocInfoVOs = ezApprovalAdminDAO.getContDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprDocInfoVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprDocInfoVOs.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			
			for (int h = 0; h < headerList.size(); h++) {
				resultXML.append("<CELL>");
				
				fieldName = headerList.get(h).getColName().toUpperCase();
				
				if (fieldName.equals("FORMNAME") || fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(userInfo.getLang());
				}
				
				if (fieldName.equals("DOCSTATENAME") && docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent().equals(staDTExcuteDoc)) {
					fieldValue = egovMessageSource.getMessage("ezApproval.t885", userInfo.getLocale());
				} else if (fieldName.equals("SENDFLAG")) {
					fieldValue = getSendStatus(docXML.getElementsByTagName("SENDFLAG").item(k).getTextContent(), userInfo.getLocale());
				} else if (fieldName.equals("STARTDATE")) {
					fieldValue = commonUtil.getDateStringInUTC(docXML.getElementsByTagName("STARTDATE").item(k).getTextContent(), userInfo.getOffset(), false);
				} else if (fieldName.equals("ENDDATE")) {
					fieldValue = commonUtil.getDateStringInUTC(docXML.getElementsByTagName("ENDDATE").item(k).getTextContent(), userInfo.getOffset(), false);
				} else {
					fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				}
				
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(fieldValue)) + "</VALUE>");
				
				if (h == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("WRITERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + docXML.getElementsByTagName("FORMID").item(k).getTextContent() + "</DATA6>");
					resultXML.append("<DATA7>" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + docXML.getElementsByTagName("FUNCTIONTYPE").item(k).getTextContent() + "</DATA10>");
				}
				
				if (fieldName.equals("HASATTACHYN")) {
					resultXML.append("<HASATTACHYN>" + docXML.getElementsByTagName("HASATTACHYN").item(k).getTextContent() + "</HASATTACHYN>");
				}
				
				if (fieldName.equals("ISPUBLIC")) {
					resultXML.append("<ISPUBLIC>" + docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent() + "</ISPUBLIC>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		logger.debug("getContDocList ended");
		
		return resultXML.toString();
	}
	
	private String getSendStatus(String sendFlag, Locale locale) throws Exception {
		logger.debug("getSendStatus started");
		
		String rtnValue = "";
		
		if (sendFlag != null) {
			if (sendFlag.equals("H")) {
				rtnValue = egovMessageSource.getMessage("ezApproval.t497", locale);
			} else if (sendFlag.equals("I")) {
				rtnValue = egovMessageSource.getMessage("ezApproval.t856", locale);
			} else if (sendFlag.equals("N")) {
				rtnValue = egovMessageSource.getMessage("ezApproval.t859", locale);
			} else if (sendFlag.equals("Y")) {
				rtnValue = egovMessageSource.getMessage("ezApproval.t854", locale);
			}
		} else {
			rtnValue = egovMessageSource.getMessage("ezApproval.t854", locale);
		}
		
		logger.debug("getSendStatus ended");
		
		return rtnValue;
	}
	
	private String getIsLineInfo(String docID, String userID, String companyID, int tenantID) throws Exception {
		logger.debug("getIsLineInfo started");
		
		String strSQL = "SELECT "
						+ "CASE WHEN COUNT(DocID) > 0 THEN 'Y' ELSE 'N' END getIsLineInfo "
						+ "FROM TBENDAPRLINEINFO "
						+ "WHERE tenant_id = '" + tenantID + "' AND companyid = '" + companyID + "' AND DocID = " + docID + " AND AprMemberID = '" + userID + "' ";
		
		logger.debug("getIsLineInfo ended");
		
		return strSQL;
	}

	private String getCodeIsUse(String code1, String code2, String companyID, int tenantID) throws Exception {
		logger.debug("getCodeIsUse started");
		
		ApprCodeVO apprCodeVO = new ApprCodeVO();
		apprCodeVO.setCode1(code1);
		apprCodeVO.setCode2(code2);
		apprCodeVO.setCompanyID(companyID);
		apprCodeVO.setTenantID(tenantID);
		
		String rtnValue = ezApprovalAdminDAO.getCodeIsUse(apprCodeVO);
		
		logger.debug("getCodeIsUse ended");
		
		return rtnValue;
	}

	private String getUserSecurityCode(String userID, int tenantID) throws Exception {
		logger.debug("getUserSecurityCode started");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("userID", userID);
		map.put("tenantID", tenantID);
		
		String userSecurityCode = ezApprovalAdminDAO.getUserSecurityCode(map);
		
		logger.debug("getUserSecurityCode ended");
		
		return userSecurityCode;
	}

	@Override
	public String moveDocList(String xmlPara, String companyID, int tenantID) throws Exception {
		logger.debug("moveDocList started");
		
		String rtnValue = "";
		Document docXML = commonUtil.convertStringToDocument(xmlPara);
		
		String sourceContID = docXML.getDocumentElement().getChildNodes().item(0).getTextContent();
		String targetContID = docXML.getDocumentElement().getChildNodes().item(1).getTextContent();
		String moveAll = docXML.getDocumentElement().getChildNodes().item(2).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("sourceContID", sourceContID);
		map.put("targetContID", targetContID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		try {
			if (moveAll.toLowerCase().equals("true")) {
				ezApprovalAdminDAO.moveAllDocList1(map);
				ezApprovalAdminDAO.moveAllDocList2(map);
			} else {
				String subQuery = "";
				
				for (int k = 3; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (k == 3) {
						subQuery += " '" + docXML.getDocumentElement().getChildNodes().item(k).getTextContent() + "' ";
					} else {
						subQuery += ", '" + docXML.getDocumentElement().getChildNodes().item(k).getTextContent() + "' ";
					}
				}
				
				map.put("subQuery", subQuery);
				
				ezApprovalAdminDAO.moveDocList1(map);
				ezApprovalAdminDAO.moveDocList2(map);
			}
			
			rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}
		
		logger.debug("moveDocList ended");
		
		return rtnValue;
	}

	@Override
	public String getKeepType(String selected, LoginVO userInfo) throws Exception {
		logger.debug("getKeepType started");
		
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("code1", "A52");
		map.put("lang", userInfo.getLang());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getCodeType(map);
		
		for (int k = 0; k < apprCodeVOs.size(); k++) {
			String[] colOption = apprCodeVOs.get(k).getName().split(";");
			
			if (colOption[1].equals(selected)) {
				rtnXML.append("<OPTION value=" + colOption[2] + " selected>" + colOption[1] + "</OPTION>");
			} else {
				rtnXML.append("<OPTION value=" + colOption[2] + ">" + colOption[1] + "</OPTION>");
			}
		}
		
		logger.debug("getKeepType ended");
		
		return rtnXML.toString();
	}

	@Override
	public String deleteDocList(String xmlPara, String offset, String companyID, int tenantID) throws Exception {
		logger.debug("deleteDocList started");
		
		String rtnValue = "";
		Document docXML = commonUtil.convertStringToDocument(xmlPara);
		
		String contID = docXML.getDocumentElement().getChildNodes().item(0).getTextContent();
		String startPeriod = docXML.getDocumentElement().getChildNodes().item(1).getTextContent();
		String storagePeriod = docXML.getDocumentElement().getChildNodes().item(2).getTextContent();
		String deleteAll = docXML.getDocumentElement().getChildNodes().item(3).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("contID", contID);
		map.put("storagePeriod", storagePeriod);
		map.put("startPeriod", startPeriod);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		if (startPeriod != null && !startPeriod.equals("")) {
			map.put("startDate", commonUtil.getDateStringInUTC(commonUtil.makeDate(startPeriod, "1", "1", true), offset, true));
			map.put("endDate", commonUtil.getDateStringInUTC(commonUtil.makeDate(startPeriod, "12", "31", false), offset, true));
		}
		
		try {
			if (deleteAll.equals("true")) {
				ezApprovalAdminDAO.deleteAllDocList(map);
			} else {
				String subQuery = "";
				for (int k = 4; k < docXML.getDocumentElement().getChildNodes().getLength(); k++) {
					if (k == 4) {
						subQuery += " '" + docXML.getDocumentElement().getChildNodes().item(k).getTextContent() + "' ";
					} else {
						subQuery += ", '" + docXML.getDocumentElement().getChildNodes().item(k).getTextContent() + "' ";
					}
				}
				
				map.put("subQuery", subQuery);
				
				ezApprovalAdminDAO.deleteDocList(map);
			}
			
			rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}
		
		logger.debug("deleteDocList ended");
		
		return rtnValue;
	}

	@Override
	public String getReceiveGroupInfo(String groupID, String mode, String companyID, String lang, int tenantID) throws Exception {
		logger.debug("getReceiveGroupInfo started");
		
		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = new ArrayList<ApprCodeVO>();
		
		if (mode.equals("ITEM")) {
			headerList = getListHeader("092", lang, companyID, tenantID);
		} else {
			headerList = getListHeader("091", lang, companyID, tenantID);
		}
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("<COLNAME>" + headerList.get(k).getColName() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("groupID", groupID);
		map.put("lang", commonUtil.getMultiData(lang));
		map.put("mode", mode);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprReceiveGroupVO> apprReceiveGroupVOs = ezApprovalAdminDAO.getReceiveGroupInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprReceiveGroupVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprReceiveGroupVOs.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int h = 0; h < headerList.size(); h++) {
				resultXML.append("<CELL>");
				
				fieldName = headerList.get(h).getColName().toUpperCase();
				
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(fieldValue)) + "</VALUE>");
				
				if (h == 0) {
					if (mode.equals("GROUP") || mode.equals("JOIN")) {
						resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("MAINID").item(k).getTextContent()) + "</DATA1>");
					} else {
						resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("SUBID").item(k).getTextContent()) + "</DATA1>");
						resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("MAINID").item(k).getTextContent()) + "</DATA2>");
						resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("DEPTID").item(k).getTextContent()) + "</DATA3>");
						resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("COMPANYID").item(k).getTextContent()) + "</DATA4>");
					}
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getReceiveGroupInfo ended");
		
		return resultXML.toString();
	}

	@Override
	public String insertReceiveGroupInfo(ApprReceiveGroupVO apprReceiveGroupVO) {
		logger.debug("insertReceiveGroupInfo started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.insertReceiveGroupInfo(apprReceiveGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("insertReceiveGroupInfo ended");
		
		return rtnValue;
	}

	@Override
	public String insertReceiveGroupItemInfo(ApprReceiveGroupVO apprReceiveGroupVO) {
		logger.debug("insertReceiveGroupItemInfo started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.insertReceiveGroupItemInfo(apprReceiveGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("insertReceiveGroupItemInfo ended");
		
		return rtnValue;
	}

	@Override
	public String updateGroupMainInfo(ApprReceiveGroupVO apprReceiveGroupVO) {
		logger.debug("updateGroupMainInfo started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.updateGroupMainInfo(apprReceiveGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("updateGroupMainInfo ended");
		
		return rtnValue;
	}

	@Override
	public String deleteGroupMainInfo(ApprReceiveGroupVO apprReceiveGroupVO) {
		logger.debug("deleteGroupMainInfo started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.deleteGroupMainInfo(apprReceiveGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("deleteGroupMainInfo ended");
		
		return rtnValue;
	}

	@Override
	public String deleteGroupSubItemInfo(ApprReceiveGroupVO apprReceiveGroupVO) {
		logger.debug("deleteGroupSubItemInfo started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.deleteGroupSubItemInfo(apprReceiveGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("deleteGroupSubItemInfo ended");
		
		return rtnValue;
	}

	@Override
	public String getItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("getItemCodeGroup started");
		
		StringBuilder rtnXML = new StringBuilder();
		
		List<ApprDocGroupVO> apprDocGroupVOs = ezApprovalAdminDAO.getItemCodeGroup(apprDocGroupVO);
		
		rtnXML.append("<NODES>");
		
		if (apprDocGroupVOs != null) {
			for (int k = 0; k < apprDocGroupVOs.size(); k++) {
				if (commonUtil.getPrimaryData(apprDocGroupVO.getLang()).equals("1")) {
					rtnXML.append("<NODE>");
					rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("<ISLEAF>" + getItemCodeGroupLeaf(apprDocGroupVOs.get(k).getGroupID(), apprDocGroupVO) + "</ISLEAF>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprDocGroupVOs.get(k).getGroupName()) + "</VALUE>");
					rtnXML.append("<DATA1>" + apprDocGroupVOs.get(k).getGroupID() + "</DATA1>");
					rtnXML.append("<DATA2>" + apprDocGroupVOs.get(k).getG_upperID() + "</DATA2>");
					rtnXML.append("<DATA3>" + apprDocGroupVOs.get(k).getG_level() + "</DATA3>");
					rtnXML.append("<DATA4>" + commonUtil.cleanValue(apprDocGroupVOs.get(k).getGroupName2()) + "</DATA4>");
					rtnXML.append("</NODE>");
				} else {
					rtnXML.append("<NODE>");
					rtnXML.append("<EXPANDED>FALSE</EXPANDED>");
					rtnXML.append("<ISLEAF>" + getItemCodeGroupLeaf(apprDocGroupVOs.get(k).getGroupID(), apprDocGroupVO) + "</ISLEAF>");
					rtnXML.append("<VALUE>" + commonUtil.cleanValue(apprDocGroupVOs.get(k).getGroupName2()) + "</VALUE>");
					rtnXML.append("<DATA1>" + apprDocGroupVOs.get(k).getGroupID() + "</DATA1>");
					rtnXML.append("<DATA2>" + apprDocGroupVOs.get(k).getG_upperID() + "</DATA2>");
					rtnXML.append("<DATA3>" + apprDocGroupVOs.get(k).getG_level() + "</DATA3>");
					rtnXML.append("<DATA4>" + commonUtil.cleanValue(apprDocGroupVOs.get(k).getGroupName()) + "</DATA4>");
					rtnXML.append("</NODE>");
				}
			}
		}
			
		rtnXML.append("</NODES>");
		
		logger.debug("getItemCodeGroup ended");
		
		return rtnXML.toString();
	}

	private String getItemCodeGroupLeaf(int groupID, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("getItemCodeGroupLeaf started");
		
		String rtnValue = "";
		
		apprDocGroupVO.setGroupID(groupID);
		
		int tempCount = ezApprovalAdminDAO.getItemCodeGroupLeaf(apprDocGroupVO);
		
		if (tempCount > 0) {
			rtnValue = "FALSE";
		} else {
			rtnValue = "TRUE";
		}
		
		logger.debug("getItemCodeGroupLeaf ended");
		
		return rtnValue;
	}

	@Override
	public int insertItemCodeGroup(ApprDocGroupVO apprDocGroupVO) {
		logger.debug("insertItemCodeGroup started");
		
		int groupID = 0;
		
		try {
			groupID = ezApprovalAdminDAO.insertItemCodeGroup(apprDocGroupVO);
		} catch (Exception e) {
			logger.error(e.getMessage());
			groupID = 0;
		}
		
		logger.debug("insertItemCodeGroup ended");
		
		return groupID;
	}

	@Override
	public String deleteItemCodeGroup(ApprDocGroupVO apprDocGroupVO) {
		logger.debug("deleteItemCodeGroup started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.deleteItemCodeGroup(apprDocGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("deleteItemCodeGroup ended");
		
		return rtnValue;
	}

	@Override
	public String updateItemCodeGroup(ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("updateItemCodeGroup started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.updateItemCodeGroup(apprDocGroupVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		
		logger.debug("updateItemCodeGroup ended");
		
		return rtnValue;
	}

	@Override
	public String getItemCodeItem(ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("getItemCodeItem started");
		
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		resultXML.append("<HEADER>");
		resultXML.append("<NAME>" + getCode2Name("L05", "001", apprDocGroupVO.getCompanyID(), apprDocGroupVO.getLang(), apprDocGroupVO.getTenantID()) + "</NAME>");
		resultXML.append("<WIDTH>50</WIDTH>");
		resultXML.append("</HEADER>");
		resultXML.append("<HEADER>");
		resultXML.append("<NAME>" + getCode2Name("L05", "002", apprDocGroupVO.getCompanyID(), apprDocGroupVO.getLang(), apprDocGroupVO.getTenantID()) + "</NAME>");
		resultXML.append("<WIDTH>290</WIDTH>");
		resultXML.append("</HEADER>");
		resultXML.append("<HEADER>");
		resultXML.append("<NAME>" + getCode2Name("L05", "003", apprDocGroupVO.getCompanyID(), apprDocGroupVO.getLang(), apprDocGroupVO.getTenantID()) + "</NAME>");
		resultXML.append("<WIDTH>90</WIDTH>");
		resultXML.append("</HEADER>");
		resultXML.append("<HEADER>");
		resultXML.append("<NAME>" + getCode2Name("L05", "004", apprDocGroupVO.getCompanyID(), apprDocGroupVO.getLang(), apprDocGroupVO.getTenantID()) + "</NAME>");
		resultXML.append("<WIDTH>80</WIDTH>");
		resultXML.append("</HEADER>");
		resultXML.append("<HEADER>");
		resultXML.append("<NAME>" + getCode2Name("L05", "005", apprDocGroupVO.getCompanyID(), apprDocGroupVO.getLang(), apprDocGroupVO.getTenantID()) + "</NAME>");
		resultXML.append("<WIDTH>80</WIDTH>");
		resultXML.append("</HEADER>");
		resultXML.append("</HEADERS>");
		
		List<ApprDocItemVO> apprDocItemVOs = ezApprovalAdminDAO.getItemCodeItem(apprDocGroupVO);
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < apprDocItemVOs.size(); k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + apprDocItemVOs.get(k).getItemCode() + "</VALUE>");
			resultXML.append("<DATA1>" + apprDocItemVOs.get(k).getGroupID() + "</DATA1>");
			resultXML.append("<DATA2>" + apprDocItemVOs.get(k).getItemLimit() + "</DATA2>");
			resultXML.append("<DATA3>" + apprDocItemVOs.get(k).getItemSecurity() + "</DATA3>");
			resultXML.append("<DATA4>" + apprDocItemVOs.get(k).getItemPublic() + "</DATA4>");
			
			if (commonUtil.getPrimaryData(apprDocGroupVO.getLang()).equals("1")) {
				resultXML.append("<DATA5>" + apprDocItemVOs.get(k).getItemName2() + "</DATA5>");
				resultXML.append("</CELL>");
				resultXML.append("<CELL>");
				resultXML.append("<VALUE>" + apprDocItemVOs.get(k).getItemName() + "</VALUE>");
				resultXML.append("</CELL>");
			} else {
				resultXML.append("<DATA5>" + apprDocItemVOs.get(k).getItemName() + "</DATA5>");
				resultXML.append("</CELL>");
				resultXML.append("<CELL>");
				resultXML.append("<VALUE>" + apprDocItemVOs.get(k).getItemName2() + "</VALUE>");
				resultXML.append("</CELL>");
			}
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getEtcName("A52", ";" + apprDocItemVOs.get(k).getItemLimit(), apprDocGroupVO) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getEtcName("A51", ";" + apprDocItemVOs.get(k).getItemSecurity(), apprDocGroupVO) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + apprDocItemVOs.get(k).getItemPublic() + "</VALUE>");
			resultXML.append("</CELL>");
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getItemCodeItem ended");
		
		return resultXML.toString();
	}

	private String getEtcName(String code1, String code2, ApprDocGroupVO apprDocGroupVO) throws Exception {
		logger.debug("getEtcName started");
		
		String etcName = "";
		ApprCodeVO apprCodeVO = new ApprCodeVO();
		
		apprCodeVO.setCode1(code1);
		apprCodeVO.setCode2(code2);
		apprCodeVO.setLang(apprDocGroupVO.getLang());
		apprCodeVO.setTenantID(apprDocGroupVO.getTenantID());
		apprCodeVO.setCompanyID(apprDocGroupVO.getCompanyID());
		
		String nameResult = ezApprovalAdminDAO.getEtcName(apprCodeVO);
		
		String[] tempResult = nameResult.split(";");
		
		if (tempResult.length >= 2) {
			etcName = tempResult[1];
		} else {
			etcName = "";
		}
		
		logger.debug("getEtcName ended");
		
		return etcName;
	}

	@Override
	public String getSecurityType(String selected, LoginVO userInfo) throws Exception {
		logger.debug("getSecurityType started");
		
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("code1", "A51");
		map.put("lang", userInfo.getLang());
		map.put("tenantID", userInfo.getTenantId());
		map.put("companyID", userInfo.getCompanyID());
		
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getCodeType(map);
		
		for (int k = 0; k < apprCodeVOs.size(); k++) {
			String[] colOption = apprCodeVOs.get(k).getName().split(";");
			
			if (colOption[1].equals(selected)) {
				rtnXML.append("<OPTION value=" + colOption[2] + " selected>" + colOption[1] + "</OPTION>");
			} else {
				rtnXML.append("<OPTION value=" + colOption[2] + ">" + colOption[1] + "</OPTION>");
			}
		}
		
		logger.debug("getSecurityType ended");
		
		return rtnXML.toString();
	}

	@Override
	public int getMaxItemCode(LoginVO userInfo) throws Exception {
		logger.debug("getMaxItemCode started");
		
		int maxItemCode = ezApprovalAdminDAO.getMaxItemCode(userInfo);
		
		logger.debug("getMaxItemCode ended");
		
		return maxItemCode;
	}

	@Override
	public String insertItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception {
		logger.debug("insertItemCodeItem started");

		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.insertItemCodeItem(apprDocItemVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}

		logger.debug("insertItemCodeItem ended");
		
		return rtnValue;
	}

	@Override
	public String updateItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception {
		logger.debug("updateItemCodeItem started");
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.updateItemCodeItem(apprDocItemVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}

		logger.debug("updateItemCodeItem ended");
		
		return rtnValue;
	}

	@Override
	public String deleteItemCodeItem(ApprDocItemVO apprDocItemVO) throws Exception {
		logger.debug("deleteItemCodeItem started");

		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.deleteItemCodeItem(apprDocItemVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}

		logger.debug("deleteItemCodeItem ended");
		
		return rtnValue;
	}

	@Override
	public String getSealList(ApprSealInfoVO apprSealInfoVO) throws Exception {
		logger.debug("getSealList started");
		
		StringBuilder resultXML = new StringBuilder();
		
		apprSealInfoVO.setLang(commonUtil.getMultiData(apprSealInfoVO.getLang()));

		List<ApprSealInfoVO> apprSealInfoVOs = ezApprovalAdminDAO.getSealList(apprSealInfoVO);
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < apprSealInfoVOs.size(); k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + commonUtil.cleanValue(apprSealInfoVOs.get(k).getSealName()) + "</VALUE>");
			resultXML.append("<DATA1>" + apprSealInfoVOs.get(k).getSealNum() + "</DATA1>");
			resultXML.append("<DATA2>" + apprSealInfoVOs.get(k).getSealPath() + "</DATA2>");
			resultXML.append("<DATA3>" + apprSealInfoVOs.get(k).getRegUserID() + "</DATA3>");
			resultXML.append("</CELL>");
			
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + apprSealInfoVOs.get(k).getSealWidth() + "</VALUE>");
			resultXML.append("</CELL>");
			
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + apprSealInfoVOs.get(k).getSealHeight() + "</VALUE>");
			resultXML.append("</CELL>");
			
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + commonUtil.getDateStringInUTC(apprSealInfoVOs.get(k).getRegDate(), apprSealInfoVO.getOffSet(), false) + "</VALUE>");
			resultXML.append("</CELL>");
			
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(commonUtil.getDateStringInUTC(apprSealInfoVOs.get(k).getDelDate(), apprSealInfoVO.getOffSet(), false)) + "</VALUE>");
			resultXML.append("</CELL>");
			
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + commonUtil.cleanValue(apprSealInfoVOs.get(k).getRegUserName()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
			
		}
		
		resultXML.append("</ROWS>");

		logger.debug("getSealList ended");
		
		return resultXML.toString();
	}

	@Override
	public String insertSealInfo(ApprSealInfoVO apprSealInfoVO) throws Exception {
		logger.debug("insertSealInfo started");

		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.deleteSealInfo(apprSealInfoVO);
			ezApprovalAdminDAO.insertSealInfo(apprSealInfoVO);
			
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<RESULT>FALSE</RESULT>";
		}

		logger.debug("insertSealInfo ended");
		
		return rtnValue;
	}

	@Override
	public String getUserDocCount(ApprExcelOutVO apprExcelOutVO, Locale locale, String offset) throws Exception {
		logger.debug("getUserDocCount started");

		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = getListHeader("104", apprExcelOutVO.getLang(), apprExcelOutVO.getCompanyID(), apprExcelOutVO.getTenantID());

		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String fromDate = apprExcelOutVO.getStartYear() + "-" + apprExcelOutVO.getStartMonth() + "-01 00:00";
		int tempMonth = Integer.parseInt(apprExcelOutVO.getEndMonth()) + 1;
		String toDate = apprExcelOutVO.getEndYear() + "-" + String.valueOf(tempMonth) + "-01 00:00";
		
		if (tempMonth > 12) {
			int tempYear = Integer.parseInt(apprExcelOutVO.getEndYear()) + 1;
			toDate = String.valueOf(tempYear) + "-01-01 00:00";
		}
		
		apprExcelOutVO.setToDate(commonUtil.getDateStringInUTC(toDate, offset, true));
		apprExcelOutVO.setFromDate(commonUtil.getDateStringInUTC(fromDate, offset, true));
		apprExcelOutVO.setMultiLang(commonUtil.getMultiData(apprExcelOutVO.getLang()));
		
		List<ApprLineInfoVO> apprLineInfoVOs = ezApprovalAdminDAO.getUserDocCount(apprExcelOutVO);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprLineInfoVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprLineInfoVOs.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int h = 0; h < headerList.size(); h++) {
				resultXML.append("<CELL>");
				
				fieldName = headerList.get(h).getColName().toUpperCase();
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				if (fieldName.equals("NAME1")) {
					fieldValue = egovMessageSource.getMessage("ezApproval." + docXML.getElementsByTagName(fieldName).item(k).getTextContent(), locale);
				}
				
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(fieldValue)) + "</VALUE>");
				
				if (h == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA2>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getUserDocCount ended");
		
		return resultXML.toString();
	}

	@Override
	public String getDeptTranSendDocCount(ApprExcelOutVO apprExcelOutVO, String offset) throws Exception {
		logger.debug("getDeptTranSendDocCount started");
		
		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = new ArrayList<ApprCodeVO>();
		
		if (apprExcelOutVO.getMode() == null) {
			headerList = getListHeader("107", apprExcelOutVO.getLang(), apprExcelOutVO.getCompanyID(), apprExcelOutVO.getTenantID());
		} else if (apprExcelOutVO.getMode().equals("SEND")) {
			headerList = getListHeader("105", apprExcelOutVO.getLang(), apprExcelOutVO.getCompanyID(), apprExcelOutVO.getTenantID());
		} else if (apprExcelOutVO.getMode().equals("RECV")) {
			headerList = getListHeader("106", apprExcelOutVO.getLang(), apprExcelOutVO.getCompanyID(), apprExcelOutVO.getTenantID());
		} else {
			headerList = getListHeader("107", apprExcelOutVO.getLang(), apprExcelOutVO.getCompanyID(), apprExcelOutVO.getTenantID());
		}
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String fromDate = apprExcelOutVO.getStartYear() + "-" + apprExcelOutVO.getStartMonth() + "-01 00:00";
		int tempMonth = Integer.parseInt(apprExcelOutVO.getEndMonth()) + 1;
		String toDate = apprExcelOutVO.getEndYear() + "-" + String.valueOf(tempMonth) + "-01 00:00";
		
		if (tempMonth > 12) {
			int tempYear = Integer.parseInt(apprExcelOutVO.getEndYear()) + 1;
			toDate = String.valueOf(tempYear) + "-01-01 00:00";
		}
		
		apprExcelOutVO.setToDate(commonUtil.getDateStringInUTC(toDate, offset, true));
		apprExcelOutVO.setFromDate(commonUtil.getDateStringInUTC(fromDate, offset, true));
		apprExcelOutVO.setMultiLang(commonUtil.getMultiData(apprExcelOutVO.getLang()));
		
		List<ApprReceiptInfoVO> apprReceiptInfoVOs = ezApprovalAdminDAO.getDeptTranSendDocCount(apprExcelOutVO);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprReceiptInfoVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprReceiptInfoVOs.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int h = 0; h < headerList.size(); h++) {
				resultXML.append("<CELL>");
				
				fieldName = headerList.get(h).getColName().toUpperCase();
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(fieldValue)) + "</VALUE>");
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getDeptTranSendDocCount ended");
		
		return resultXML.toString();
	}

	@Override
	public String insertFormContainer(ApprFormContVO apprFormContVO, String offset) throws Exception {
		logger.debug("insertFormContainer started");
		
		String rtnValue = "";

		try {
			StringBuilder insString = new StringBuilder();
			apprFormContVO.setId(Integer.parseInt(commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offset, false).substring(0, 4) + "000001"));
			
			int id = ezApprovalAdminDAO.insertFormContainer(apprFormContVO);
			
			if (!apprFormContVO.getFormContDept().equals("ALL")) {
				String[] userDeptIDs = apprFormContVO.getFormContDepts().split(";");
				
				if (userDeptIDs.length > 0) {
					for (int k = 0; k < userDeptIDs.length; k++) {
						insString.append("INTO TBFORMCONTUSERGROUP ( FORMCONTID, FORMCONTUSERDEPID, COMPANYID, TENANT_ID ) ");
						insString.append("VALUES ('" + id + "', '" + userDeptIDs[k] + "', '" + apprFormContVO.getCompanyID() + "', '" + apprFormContVO.getTenantID() + "')");
					}
				}
				ezApprovalAdminDAO.insertFormContainerUserGroup(insString.toString());
			}
			
			rtnValue = "<PARAMETER><FContID>" + id + "</FContID></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><FContID>FALSE</FContID></PARAMETER>";
		}

		logger.debug("insertFormContainer ended");
		
		return rtnValue;
	}

	@Override
	public String deleteFormContainer(String formContID, String companyID, int tenantID) throws Exception {
		logger.debug("deleteFormContainer started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("formContID", formContID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		String rtnValue = "";
		
		try {
			ezApprovalAdminDAO.deleteFormContUserGroup(map);
			ezApprovalAdminDAO.deleteFormContainer(map);
			
			rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}

		logger.debug("deleteFormContainer ended");
		
		return rtnValue;
	}

	@Override
	public String getListHeader(String code, LoginVO userInfo) throws Exception {
		logger.debug("getListHeader started");

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("listCode", code);
		map.put("lang", userInfo.getLang());
		map.put("companyID", userInfo.getCompanyID());
		map.put("tenantID", userInfo.getTenantId());
		
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getListHeader(map);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprCodeVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprCodeVOs.get(i)));
		}
		sb.append("</DATA>");
		
		logger.debug("getListHeader ended");
		
		return sb.toString();
	}

	@Override
	public String getAprType(LoginVO userInfo) throws Exception {
		logger.debug("getAprType started");

		StringBuilder rtnXML = new StringBuilder();
		List<ApprCodeVO> apprCodeVOs = ezApprovalAdminDAO.getAprType(userInfo);
		
		rtnXML.append("<APRTYPES>");
		rtnXML.append("<USERTYPES>");
		
		if (apprCodeVOs != null) {
			for (int k = 0; k < apprCodeVOs.size(); k++) {
				if (!apprCodeVOs.get(k).getCode().equals(staATBuSeuSoonChaHyubJo) && !apprCodeVOs.get(k).getCode().equals(staATBuSeuByungRyulHyubJo) && !apprCodeVOs.get(k).getCode().equals(staATGamSaBu)) {
					rtnXML.append("<APRTYPE>");
					rtnXML.append("<CODE>" + apprCodeVOs.get(k).getCode() + "</CODE>");
					rtnXML.append("<NAME>" + egovMessageSource.getMessage("ezApproval." + apprCodeVOs.get(k).getName(), userInfo.getLocale()) + "</NAME>");
					rtnXML.append("</APRTYPE>");
				}
			}
		}
		
		rtnXML.append("</USERTYPES>");
		rtnXML.append("<DEPTTYPES>");
		
		if (apprCodeVOs != null) {
			for (int k = 0; k < apprCodeVOs.size(); k++) {
				if (apprCodeVOs.get(k).getCode().equals(staATBuSeuSoonChaHyubJo) || apprCodeVOs.get(k).getCode().equals(staATBuSeuByungRyulHyubJo) || apprCodeVOs.get(k).getCode().equals(staATGamSaBu)) {
					rtnXML.append("<APRTYPE>");
					rtnXML.append("<CODE>" + apprCodeVOs.get(k).getCode() + "</CODE>");
					rtnXML.append("<NAME>" + egovMessageSource.getMessage("ezApproval." + apprCodeVOs.get(k).getName(), userInfo.getLocale()) + "</NAME>");
					rtnXML.append("</APRTYPE>");
				}
			}
		}
		
		rtnXML.append("</DEPTTYPES>");
		rtnXML.append("</APRTYPES>");

		logger.debug("getAprType ended");
		
		return rtnXML.toString();
	}

	@Override
	public String getFormAprRule(String formID, String companyID, int tenantID) throws Exception {
		logger.debug("getFormAprRule started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("formID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprAutoRuleVO> apprAutoRuleVOs = ezApprovalAdminDAO.getFormAprRule(map);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprAutoRuleVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprAutoRuleVOs.get(i)));
		}
		sb.append("</DATA>");
		
		logger.debug("getFormAprRule ended");
		
		return sb.toString();
	}

	@Override
	public String getFormAprRuleLine(String formID, String companyID, int tenantID) throws Exception {
		logger.debug("getFormAprRuleLine started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("formID", formID);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);
		
		List<ApprAutoRuleVO> apprAutoRuleVOs = ezApprovalAdminDAO.getFormAprRuleLine(map);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprAutoRuleVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprAutoRuleVOs.get(i)));
		}
		sb.append("</DATA>");

		logger.debug("getFormAprRuleLine ended");
		
		return sb.toString();
	}

	@Override
	public String getFormContentReform(String formID, String lang, String companyID, int tenantID) throws Exception {
		logger.debug("getFormContentReform started");

		Map<String, Object> map = new HashMap<String, Object>();

		map.put("formID", formID);
		map.put("lang", lang);
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);		
		
		String reformJSURL = ezApprovalAdminDAO.getFormContentReform(map);

		logger.debug("getFormContentReform ended");
		
		return reformJSURL;
	}

	@Override
	public String getFormRecvAdmin(ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("getFormRecvAdmin started");

		StringBuilder resultXML = new StringBuilder();
		List<ApprCodeVO> headerList = getListHeader("103", apprFormInfoVO.getLang(), apprFormInfoVO.getCompanyID(), apprFormInfoVO.getTenantID());
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < headerList.size(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + headerList.get(k).getName() + "</NAME>");
			resultXML.append("<WIDTH>" + headerList.get(k).getWidth() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		List<ApprReceiveGroupVO> apprReceiveGroupVOs = ezApprovalAdminDAO.getFormRecvAdmin(apprFormInfoVO);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprReceiveGroupVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprReceiveGroupVOs.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int h = 0; h < headerList.size(); h++) {
				resultXML.append("<CELL>");
				
				if (h == 0) {
					resultXML.append("<VALUE>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(docXML.getElementsByTagName("DEPTID").item(k).getTextContent(), "displayName" + commonUtil.getMultiData(apprFormInfoVO.getLang()), apprFormInfoVO.getTenantID())) + "</VALUE>");
					resultXML.append("<DATA1>" + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + commonUtil.cleanValue(docXML.getElementsByTagName("USERID").item(k).getTextContent()) + "</DATA2>");
				} else {
					resultXML.append("<VALUE>" + commonUtil.cleanValue(ezOrganService.getPropertyValue(docXML.getElementsByTagName("USERID").item(k).getTextContent(), "displayName" + commonUtil.getMultiData(apprFormInfoVO.getLang()), apprFormInfoVO.getTenantID())) + "</VALUE>");
				}
				
				resultXML.append("</CELL>");
			}
			
			resultXML.append("</ROW>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		logger.debug("getFormRecvAdmin ended");
		
		return resultXML.toString();
	}

	@Override
	public String getFormProperty(Locale locale, String companyID, int tenantID) throws Exception {
		logger.debug("getFormProperty started");
		
		StringBuilder resultXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();

		map.put("upperCode", "ROOT");
		map.put("companyID", companyID);
		map.put("tenantID", tenantID);

		List<ApprFormInfoVO> apprFormInfoVOs = ezApprovalAdminDAO.getFormProperty(map);
		
		resultXML.append("<GROUP>");
		
		for (int k = 0; k < apprFormInfoVOs.size(); k++) {
			resultXML.append("<PROPERTY ID = \"" + apprFormInfoVOs.get(k).getId() + "\" NAME = \"" + egovMessageSource.getMessage("ezApproval." + apprFormInfoVOs.get(k).getName(), locale) + "\">");
			
			map.put("upperCode", apprFormInfoVOs.get(k).getCode());
			
			List<ApprFormInfoVO> apprFormInfoVOs2 = ezApprovalAdminDAO.getFormProperty(map);
			
			for (int h = 0; h < apprFormInfoVOs2.size(); h++) {
				resultXML.append("<ROW>");
				resultXML.append("<ID>" + makeListField(apprFormInfoVOs2.get(h).getId()) + "</ID>");
				resultXML.append("<NAME>" + egovMessageSource.getMessage("ezApproval." + apprFormInfoVOs2.get(h).getName(), locale) + "</NAME>");
				resultXML.append("</ROW>");
			}
			
			resultXML.append("</PROPERTY>");
		}
		
		resultXML.append("</GROUP>");

		logger.debug("getFormProperty ended");
		
		return resultXML.toString();
	}

	@Override
	public String saveFormInfo(ApprFormInfoVO apprFormInfoVO, String realPath, Locale locale) throws Exception {
		logger.debug("saveFormInfo started");

		String path = realPath + commonUtil.separator + "fileroot" + commonUtil.separator + apprFormInfoVO.getTenantID() + config.getProperty("upload_approval.ROOT");
		Document xmlDom = commonUtil.convertStringToDocument(apprFormInfoVO.getFormInfo());

		apprFormInfoVO.setFormName(xmlDom.getElementsByTagName("FormName").item(0).getTextContent());
		apprFormInfoVO.setFormName2(xmlDom.getElementsByTagName("FormName2").item(0).getTextContent());
		apprFormInfoVO.setFormDescription(xmlDom.getElementsByTagName("FormDescript").item(0).getTextContent());
		apprFormInfoVO.setFormKind(xmlDom.getElementsByTagName("FormKind").item(0).getTextContent());
		apprFormInfoVO.setUseFlag(xmlDom.getElementsByTagName("USEFLAG").item(0).getTextContent());
		apprFormInfoVO.setKeepPeriod(xmlDom.getElementsByTagName("KEEPPERIOD").item(0).getTextContent());
		apprFormInfoVO.setSecurityLevel(xmlDom.getElementsByTagName("SECURITYLEVEL").item(0).getTextContent());
		apprFormInfoVO.setIsPublic(xmlDom.getElementsByTagName("ISPUBLIC").item(0).getTextContent());
		apprFormInfoVO.setTbItemCode(xmlDom.getElementsByTagName("TBITEMCODE").item(0).getTextContent());
		apprFormInfoVO.setTbItemName(xmlDom.getElementsByTagName("TBITEMNAME").item(0).getTextContent());
		apprFormInfoVO.setTbItemName2(xmlDom.getElementsByTagName("TBITEMNAME2").item(0).getTextContent());
		apprFormInfoVO.setKeepPeriodCode(xmlDom.getElementsByTagName("KEEPPERIODCODE").item(0).getTextContent());
		
		if (apprFormInfoVO.getFormConn() != null && !apprFormInfoVO.getFormConn().equals("")) {
			xmlDom = commonUtil.convertStringToDocument(apprFormInfoVO.getFormConn());
			
			apprFormInfoVO.setFormConnXML(xmlDom.getElementsByTagName("CONNXML").item(0).getTextContent());
		}
		
		if (apprFormInfoVO.getFormWorkFlow() != null && !apprFormInfoVO.getFormWorkFlow().equals("")) {
			xmlDom = commonUtil.convertStringToDocument(apprFormInfoVO.getFormWorkFlow());
			
			apprFormInfoVO.setValidations(xmlDom.getElementsByTagName("VALIDATIONS").item(0).getTextContent());
			apprFormInfoVO.setStatus(xmlDom.getElementsByTagName("STATUS").item(0).getTextContent());
		}
		
		boolean isUpdate = false;
		String isUpdateFormVersion = "N";
		String strBeforeMHT = "";
		String saveFileName = "";
		
		if (!apprFormInfoVO.getFormID().equals("") && !apprFormInfoVO.getFormMHT().equals("")) {
			isUpdate = true;
			
			saveFileName = path + commonUtil.separator + apprFormInfoVO.getCompanyID() + commonUtil.separator + "Form" + commonUtil.separator + apprFormInfoVO.getFormID() + ".mht";
			
			try {
				File file = new File(saveFileName);
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				} else {
					new File(saveFileName.substring(0, saveFileName.lastIndexOf(commonUtil.separator))).mkdirs();
				}
				
				FileWriter fw = new FileWriter(file);
				fw.append(apprFormInfoVO.getFormMHT());
				fw.close();
				
				isUpdateFormVersion = "Y";
			} catch (Exception e) {
				isUpdateFormVersion = "N";
				
				return egovMessageSource.getMessage("ezApproval.hyj13", locale) + e.getMessage();
			}
		} else {
			isUpdateFormVersion = "N";
		}
		
		apprFormInfoVO.setYear(commonUtil.getTodayUTCTime("yyyy"));
		
		String url = commonUtil.separator + "fileroot" + commonUtil.separator + apprFormInfoVO.getTenantID() + config.getProperty("upload_approval.ROOT") + commonUtil.separator + apprFormInfoVO.getCompanyID() + commonUtil.separator + "Form" + commonUtil.separator;
		apprFormInfoVO.setUrl(url);
		
		
		//formID가 비어있으면 추가 존재하면 수정
		if (apprFormInfoVO.getFormID() == null || apprFormInfoVO.getFormID().equals("")) {
			String formID = ezApprovalAdminDAO.insertFormData(apprFormInfoVO);
			
			apprFormInfoVO.setFormID(formID);
			
			ezApprovalAdminDAO.setAutoDocNum(apprFormInfoVO);
			
			if (apprFormInfoVO.getFormAutoRule() != null && !apprFormInfoVO.getFormAutoRule().equals("") && !apprFormInfoVO.getFormAutoRule().equals("<DATA></DATA>")) {
				Document doc = commonUtil.convertStringToDocument(apprFormInfoVO.getFormAutoRule());
				List<ApprAutoRuleVO> apprAutoRuleVOs = new ArrayList<ApprAutoRuleVO>();
				ApprAutoRuleVO apprAutoRuleVO = null;
				
				for (int k = 0; k < doc.getElementsByTagName("ROW").getLength(); k++) {
					apprAutoRuleVO = new ApprAutoRuleVO();
					
					apprAutoRuleVO.setFormID(apprFormInfoVO.getFormID());
					apprAutoRuleVO.setAutoRuleSN(doc.getElementsByTagName("AUTORULESN").item(k).getTextContent());
					apprAutoRuleVO.setAutoRuleGUID(doc.getElementsByTagName("AUTORULEGUID").item(k).getTextContent());
					apprAutoRuleVO.setCheckFieldType(doc.getElementsByTagName("CHECKFIELDTYPE").item(k).getTextContent());
					apprAutoRuleVO.setCheckField(doc.getElementsByTagName("CHECKFIELD").item(k).getTextContent());
					apprAutoRuleVO.setOperatorType(doc.getElementsByTagName("OPERATORTYPE").item(k).getTextContent());
					apprAutoRuleVO.setOperator(doc.getElementsByTagName("OPERATOR").item(k).getTextContent());
					apprAutoRuleVO.setCondType(doc.getElementsByTagName("CONDTYPE").item(k).getTextContent());
					apprAutoRuleVO.setCondValue(doc.getElementsByTagName("CONDVALUE").item(k).getTextContent());
					apprAutoRuleVO.setCondValueDeptID(doc.getElementsByTagName("CONDVALUEDEPTID").item(k).getTextContent());
					apprAutoRuleVO.setDocType(doc.getElementsByTagName("DOCTYPE").item(k).getTextContent());
					apprAutoRuleVO.setTenantID(apprFormInfoVO.getTenantID());
					apprAutoRuleVO.setCompanyID(apprFormInfoVO.getCompanyID());
					
					apprAutoRuleVOs.add(k, apprAutoRuleVO);
				}
				
				ezApprovalAdminDAO.insertAutoRule(apprAutoRuleVOs);
			}
			
			if (apprFormInfoVO.getFormAutoRuleLine() != null && !apprFormInfoVO.getFormAutoRuleLine().equals("") && !apprFormInfoVO.getFormAutoRuleLine().equals("<DATA></DATA>")) {
				Document doc = commonUtil.convertStringToDocument(apprFormInfoVO.getFormAutoRuleLine());
				List<ApprAutoRuleVO> apprAutoRuleVOs = new ArrayList<ApprAutoRuleVO>();
				ApprAutoRuleVO apprAutoRuleVO = null;
				
				for (int k = 0; k < doc.getElementsByTagName("ROW").getLength(); k++) {
					apprAutoRuleVO = new ApprAutoRuleVO();
					
					apprAutoRuleVO.setFormID(apprFormInfoVO.getFormID());
					apprAutoRuleVO.setAutoRuleGUID(doc.getElementsByTagName("AUTORULEGUID").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberSN(doc.getElementsByTagName("APRMEMBERSN").item(k).getTextContent());
					apprAutoRuleVO.setAprType(doc.getElementsByTagName("APRTYPE").item(k).getTextContent());
					apprAutoRuleVO.setAprState(doc.getElementsByTagName("APRSTATE").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberID(doc.getElementsByTagName("APRMEMBERID").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberIsDeptYN(doc.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberName(doc.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberName2(doc.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberJobTitle(doc.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberJobTitle2(doc.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberDeptID(doc.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberDeptName(doc.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberDeptName2(doc.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberLdapPath(doc.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent());
					apprAutoRuleVO.setReasonDoNotApprov(doc.getElementsByTagName("REASONDONOTAPPROV").item(k).getTextContent());
					apprAutoRuleVO.setIsProposerYN(doc.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent());
					apprAutoRuleVO.setIsBriefUserYN(doc.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent());
					apprAutoRuleVO.setTenantID(apprFormInfoVO.getTenantID());
					apprAutoRuleVO.setCompanyID(apprFormInfoVO.getCompanyID());
					
					apprAutoRuleVOs.add(k, apprAutoRuleVO);
				}
				
				ezApprovalAdminDAO.insertAutoRuleLine(apprAutoRuleVOs);
			}
			
			if (apprFormInfoVO.getFormRecevGroup() != null && !apprFormInfoVO.getFormRecevGroup().equals("")) {
				Document doc = commonUtil.convertStringToDocument(apprFormInfoVO.getFormRecevGroup());
				List<ApprReceiveGroupVO> apprReceiveGroupVOs = new ArrayList<ApprReceiveGroupVO>();
				ApprReceiveGroupVO apprReceiveGroupVO = null;
				
				for (int k = 0; k < doc.getElementsByTagName("DATA").getLength(); k++) {
					apprReceiveGroupVO = new ApprReceiveGroupVO();
					
					apprReceiveGroupVO.setFormID(apprFormInfoVO.getFormID());
					apprReceiveGroupVO.setDeptID(doc.getElementsByTagName("DEPTID").item(0).getTextContent());
					apprReceiveGroupVO.setDeptSN(doc.getElementsByTagName("DEPTSN").item(0).getTextContent());
					apprReceiveGroupVO.setUserID(doc.getElementsByTagName("USERID").item(0).getTextContent());
					apprReceiveGroupVO.setTenantID(apprFormInfoVO.getTenantID());
					apprReceiveGroupVO.setCompanyID(apprFormInfoVO.getCompanyID());
					
					apprReceiveGroupVOs.add(k, apprReceiveGroupVO);
				}
				
				ezApprovalAdminDAO.insertFormRecv(apprReceiveGroupVOs);
			}
			
			if (isUpdateFormVersion.equals("Y")) {
				ezApprovalAdminDAO.updateFormVersion(apprFormInfoVO);
			}
		} else {
			ezApprovalAdminDAO.updateFormData(apprFormInfoVO);
			ezApprovalAdminDAO.setAutoDocNum(apprFormInfoVO);
			
			if (apprFormInfoVO.getFormAutoRule() != null && !apprFormInfoVO.getFormAutoRule().equals("") && !apprFormInfoVO.getFormAutoRule().equals("<DATA></DATA>")) {
				Document doc = commonUtil.convertStringToDocument(apprFormInfoVO.getFormAutoRule());
				List<ApprAutoRuleVO> apprAutoRuleVOs = new ArrayList<ApprAutoRuleVO>();
				ApprAutoRuleVO apprAutoRuleVO = null;
				
				for (int k = 0; k < doc.getElementsByTagName("ROW").getLength(); k++) {
					apprAutoRuleVO = new ApprAutoRuleVO();
					
					apprAutoRuleVO.setFormID(apprFormInfoVO.getFormID());
					apprAutoRuleVO.setAutoRuleSN(doc.getElementsByTagName("AUTORULESN").item(k).getTextContent());
					apprAutoRuleVO.setAutoRuleGUID(doc.getElementsByTagName("AUTORULEGUID").item(k).getTextContent());
					apprAutoRuleVO.setCheckFieldType(doc.getElementsByTagName("CHECKFIELDTYPE").item(k).getTextContent());
					apprAutoRuleVO.setCheckField(doc.getElementsByTagName("CHECKFIELD").item(k).getTextContent());
					apprAutoRuleVO.setOperatorType(doc.getElementsByTagName("OPERATORTYPE").item(k).getTextContent());
					apprAutoRuleVO.setOperator(doc.getElementsByTagName("OPERATOR").item(k).getTextContent());
					apprAutoRuleVO.setCondType(doc.getElementsByTagName("CONDTYPE").item(k).getTextContent());
					apprAutoRuleVO.setCondValue(doc.getElementsByTagName("CONDVALUE").item(k).getTextContent());
					apprAutoRuleVO.setCondValueDeptID(doc.getElementsByTagName("CONDVALUEDEPTID").item(k).getTextContent());
					apprAutoRuleVO.setDocType(doc.getElementsByTagName("DOCTYPE").item(k).getTextContent());
					apprAutoRuleVO.setTenantID(apprFormInfoVO.getTenantID());
					apprAutoRuleVO.setCompanyID(apprFormInfoVO.getCompanyID());
					
					apprAutoRuleVOs.add(k, apprAutoRuleVO);
				}
				
				ezApprovalAdminDAO.deleteAutoRule(apprAutoRuleVO);
				ezApprovalAdminDAO.insertAutoRule(apprAutoRuleVOs);
			}
			
			if (apprFormInfoVO.getFormAutoRuleLine() != null && !apprFormInfoVO.getFormAutoRuleLine().equals("") && !apprFormInfoVO.getFormAutoRuleLine().equals("<DATA></DATA>")) {
				Document doc = commonUtil.convertStringToDocument(apprFormInfoVO.getFormAutoRuleLine());
				List<ApprAutoRuleVO> apprAutoRuleVOs = new ArrayList<ApprAutoRuleVO>();
				ApprAutoRuleVO apprAutoRuleVO = null;
				
				for (int k = 0; k < doc.getElementsByTagName("ROW").getLength(); k++) {
					apprAutoRuleVO = new ApprAutoRuleVO();
					
					apprAutoRuleVO.setFormID(apprFormInfoVO.getFormID());
					apprAutoRuleVO.setAutoRuleGUID(doc.getElementsByTagName("AUTORULEGUID").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberSN(doc.getElementsByTagName("APRMEMBERSN").item(k).getTextContent());
					apprAutoRuleVO.setAprType(doc.getElementsByTagName("APRTYPE").item(k).getTextContent());
					apprAutoRuleVO.setAprState(doc.getElementsByTagName("APRSTATE").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberID(doc.getElementsByTagName("APRMEMBERID").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberIsDeptYN(doc.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberName(doc.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberName2(doc.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberJobTitle(doc.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberJobTitle2(doc.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberDeptID(doc.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberDeptName(doc.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberDeptName2(doc.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent());
					apprAutoRuleVO.setAprMemberLdapPath(doc.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent());
					apprAutoRuleVO.setReasonDoNotApprov(doc.getElementsByTagName("REASONDONOTAPPROV").item(k).getTextContent());
					apprAutoRuleVO.setIsProposerYN(doc.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent());
					apprAutoRuleVO.setIsBriefUserYN(doc.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent());
					apprAutoRuleVO.setTenantID(apprFormInfoVO.getTenantID());
					apprAutoRuleVO.setCompanyID(apprFormInfoVO.getCompanyID());
					
					apprAutoRuleVOs.add(k, apprAutoRuleVO);
				}
				
				ezApprovalAdminDAO.deleteAutoRuleLine(apprAutoRuleVO);
				ezApprovalAdminDAO.insertAutoRuleLine(apprAutoRuleVOs);
			}
			
			if (apprFormInfoVO.getFormRecevGroup() != null && !apprFormInfoVO.getFormRecevGroup().equals("")) {
				Document doc = commonUtil.convertStringToDocument(apprFormInfoVO.getFormRecevGroup());
				List<ApprReceiveGroupVO> apprReceiveGroupVOs = new ArrayList<ApprReceiveGroupVO>();
				ApprReceiveGroupVO apprReceiveGroupVO = null;
				
				for (int k = 0; k < doc.getElementsByTagName("DATA").getLength(); k++) {
					apprReceiveGroupVO = new ApprReceiveGroupVO();
					
					apprReceiveGroupVO.setFormID(apprFormInfoVO.getFormID());
					apprReceiveGroupVO.setDeptID(doc.getElementsByTagName("DEPTID").item(k).getTextContent());
					apprReceiveGroupVO.setDeptSN(doc.getElementsByTagName("DEPTSN").item(k).getTextContent());
					apprReceiveGroupVO.setUserID(doc.getElementsByTagName("USERID").item(k).getTextContent());
					apprReceiveGroupVO.setTenantID(apprFormInfoVO.getTenantID());
					apprReceiveGroupVO.setCompanyID(apprFormInfoVO.getCompanyID());
					
					apprReceiveGroupVOs.add(k, apprReceiveGroupVO);
				}
				
				
				ezApprovalAdminDAO.deleteFormRecv(apprReceiveGroupVO);
				ezApprovalAdminDAO.insertFormRecv(apprReceiveGroupVOs);
			}
			
			if (isUpdateFormVersion.equals("Y")) {
				ezApprovalAdminDAO.updateFormVersion(apprFormInfoVO);
			}
		}
		
		if (!isUpdate) {
			if (!apprFormInfoVO.getFormMHT().equals(""))	 {
				saveFileName = path + commonUtil.separator + apprFormInfoVO.getCompanyID() + commonUtil.separator + "Form" + commonUtil.separator + apprFormInfoVO.getFormID() + ".mht";
				
				File file = new File(saveFileName);
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				} else {
					new File(saveFileName.substring(0, saveFileName.lastIndexOf(commonUtil.separator))).mkdirs();
				}
				
				FileWriter fw = new FileWriter(file);
				fw.append(apprFormInfoVO.getFormMHT());
				fw.close();
			}
		}
		
		logger.debug("saveFormInfo ended");
		
		return apprFormInfoVO.getFormID();
	}

	private void mhtToHtmlReform(String saveReFileName, String formID, String companyID, String realPath, int tenantID, Locale locale) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("mhtToHtmlReform started");

		String mhtImagePath = realPath + commonUtil.separator + "fileroot" + commonUtil.separator + tenantID + config.getProperty("upload_common.MHTIMAGE");
		File mhtFile = new File(mhtImagePath);
		
		if (!mhtFile.exists()) {
			mhtFile.mkdirs();
		}
		
		String strHTML = ezCommonService.startMHT2HTML(mhtImagePath, ezCommonService.loadMHTFile(saveReFileName), mhtImagePath, realPath, locale);

		logger.debug("mhtToHtmlReform ended");
	}

	@Override
	public String saveFormInfoReform(ApprFormInfoVO apprFormInfoVO, String realPath, Locale locale) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("saveFormInfoReform started");

		String path = realPath + commonUtil.separator + "fileroot" + commonUtil.separator + apprFormInfoVO.getTenantID() + config.getProperty("upload_approval.ROOT");
		Document xmlDom = commonUtil.convertStringToDocument(apprFormInfoVO.getFormInfo());

		apprFormInfoVO.setFormName(xmlDom.getElementsByTagName("FormName").item(0).getTextContent());
		apprFormInfoVO.setFormName2(xmlDom.getElementsByTagName("FormName2").item(0).getTextContent());
		apprFormInfoVO.setFormDescription(xmlDom.getElementsByTagName("FormDescript").item(0).getTextContent());
		apprFormInfoVO.setFormKind(xmlDom.getElementsByTagName("FormKind").item(0).getTextContent());
		apprFormInfoVO.setUseFlag(xmlDom.getElementsByTagName("USEFLAG").item(0).getTextContent());
		apprFormInfoVO.setKeepPeriod(xmlDom.getElementsByTagName("KEEPPERIOD").item(0).getTextContent());
		apprFormInfoVO.setSecurityLevel(xmlDom.getElementsByTagName("SECURITYLEVEL").item(0).getTextContent());
		apprFormInfoVO.setIsPublic(xmlDom.getElementsByTagName("ISPUBLIC").item(0).getTextContent());
		apprFormInfoVO.setTbItemCode(xmlDom.getElementsByTagName("TBITEMCODE").item(0).getTextContent());
		apprFormInfoVO.setTbItemName(xmlDom.getElementsByTagName("TBITEMNAME").item(0).getTextContent());
		apprFormInfoVO.setTbItemName2(xmlDom.getElementsByTagName("TBITEMNAME2").item(0).getTextContent());
		apprFormInfoVO.setKeepPeriodCode(xmlDom.getElementsByTagName("KEEPPERIODCODE").item(0).getTextContent());
		
		if (apprFormInfoVO.getFormConn() != null && !apprFormInfoVO.getFormConn().equals("")) {
			xmlDom = commonUtil.convertStringToDocument(apprFormInfoVO.getFormConn());
			
			apprFormInfoVO.setFormConnXML(xmlDom.getElementsByTagName("CONNXML").item(0).getTextContent());
		}
		
		if (apprFormInfoVO.getFormWorkFlow() != null && !apprFormInfoVO.getFormWorkFlow().equals("")) {
			xmlDom = commonUtil.convertStringToDocument(apprFormInfoVO.getFormWorkFlow());
			
			apprFormInfoVO.setValidations(xmlDom.getElementsByTagName("VALIDATIONS").item(0).getTextContent());
			apprFormInfoVO.setStatus(xmlDom.getElementsByTagName("STATUS").item(0).getTextContent());
		}
		
		boolean isUpdate = false;
		String isUpdateFormVersion = "N";
		String strBeforeMHT = "";
		String saveFileName = "";
		
		if (!apprFormInfoVO.getFormID().equals("") && !apprFormInfoVO.getFormMHT().equals("")) {
			isUpdate = true;
			
			saveFileName = path + commonUtil.separator + apprFormInfoVO.getCompanyID() + commonUtil.separator + "Form" + commonUtil.separator + apprFormInfoVO.getFormID() + ".mht";
			
			try {
				File file = new File(saveFileName);
				
				if (file.exists()) {
					strBeforeMHT = FileUtils.readFileToString(file);
				}
				
				FileWriter fw = new FileWriter(file);
				fw.append(apprFormInfoVO.getFormMHT());
				fw.close();
				
				isUpdateFormVersion = "Y";
			} catch (Exception e) {
				isUpdateFormVersion = "N";
				
				return egovMessageSource.getMessage("ezApproval.hyj13", locale) + e.getMessage();
			}
		} else {
			isUpdateFormVersion = "N";
		}
		
		String strBeforeReMHT ="";
		String isUpdateReformVersion = "N";
		boolean isUpdateReform = false;
		String saveReFileName = "";
		
		if (!apprFormInfoVO.getFormID().equals("") && !apprFormInfoVO.getReformMHT().equals("")) {
			if (apprFormInfoVO.getFormBuilder().equals("Y")) {
				isUpdateReform = true;
				
				saveReFileName = path + commonUtil.separator + apprFormInfoVO.getCompanyID() + commonUtil.separator + "Form" + commonUtil.separator + apprFormInfoVO.getFormID() + "._FORMBuilder.mht";
				
				try {
					File file = new File(saveReFileName);
					
					if (file.exists()) {
						strBeforeReMHT = FileUtils.readFileToString(file);
					}
					
					FileWriter fw = new FileWriter(file);
					fw.append(apprFormInfoVO.getReformMHT());
					fw.close();
					
					isUpdateReformVersion = "Y";
					
					mhtToHtmlReform(saveReFileName, apprFormInfoVO.getFormID(), apprFormInfoVO.getCompanyID(), realPath, apprFormInfoVO.getTenantID(), locale);
				} catch (Exception e) {
					// TODO: handle exception
				}
			}
		}

		logger.debug("saveFormInfoReform ended");
		
		return null;
	}

	@Override
	public List<ApprConnInfoVO> getFormConnInfo(LoginVO userInfo) throws Exception {
		logger.debug("getFormConnInfo started");
		logger.debug("getFormConnInfo ended");
		
		return ezApprovalAdminDAO.getFormConnInfo(userInfo);
	}

	@Override
	public String getFormContent(ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("getFormContent started");

		List<ApprFormInfoVO> apprFormInfoVOs = ezApprovalAdminDAO.getFormContent(apprFormInfoVO);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprFormInfoVOs.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprFormInfoVOs.get(i)));
		}
		sb.append("</DATA>");

		logger.debug("getFormContent ended");
		
		return sb.toString();
	}

	@Override
	public String deleteForm(ApprFormInfoVO apprFormInfoVO) throws Exception {
		logger.debug("deleteForm started");
		
		String rtnValue = "";
		
		try {
			int tempDel = ezApprovalAdminDAO.deleteForm(apprFormInfoVO);
			ezApprovalAdminDAO.deleteFavoriteForm(apprFormInfoVO);
			
			if (tempDel == 1) {
				rtnValue = "<PARAMETER><RESULT>TRUE</RESULT></PARAMETER>";
			} else {
				rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
			}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			logger.error(e.getMessage());
			rtnValue = "<PARAMETER><RESULT>FALSE</RESULT></PARAMETER>";
		}

		logger.debug("deleteForm ended");
		
		return rtnValue;
	}

	@Override
	public String formMove(ApprFormContVO apprFormContVO) throws Exception {
		logger.debug("formMove started");

		String rtnValue = "";
		
		try {
			int upTemp = ezApprovalAdminDAO.formMove(apprFormContVO);
			
			if (upTemp > 0) {
				rtnValue = "OK";
			} else {
				rtnValue = "ERROR Not Update";
			}
		} catch (Exception e) {
			logger.error(e.getMessage());
			rtnValue = "ERROR" + e.getMessage();
		}

		logger.debug("formMove ended");
		
		return rtnValue;
	}

	@Override
	public String setFormOrder(ApprFormContVO apprFormContVO) throws Exception {
		logger.debug("setFormOrder started");

		String rtnValue = "";
		String[] formIDs = apprFormContVO.getFormIDList().split(";");
		
		try {
			for (int k = 0; k < formIDs.length; k++) {
				apprFormContVO.setFormID(formIDs[k]);
				apprFormContVO.setFormOrder(k);
				
				int upTemp = ezApprovalAdminDAO.setFormOrder(apprFormContVO);
				
				if (upTemp > 0) {
					rtnValue = "OK";
				} else {
					rtnValue = "ERROR Not Update";
					break;
				}
			}
		} catch (Exception e) {
			rtnValue = "ERROR";
		}
		
		rtnValue = "<RESULT>" + rtnValue + "</RESULT>";

		logger.debug("setFormOrder ended");
		
		return rtnValue;
	}
	
}
