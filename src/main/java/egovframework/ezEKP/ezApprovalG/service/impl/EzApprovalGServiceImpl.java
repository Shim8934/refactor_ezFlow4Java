package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.stringtemplate.v4.compiler.STParser.mapExpr_return;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.html.HTMLCollection;
import org.w3c.dom.html.HTMLElement;
import org.w3c.dom.html.HTMLTableElement;
import org.w3c.dom.html.HTMLTableRowElement;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAdminReceiveVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprDocInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabCodeVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabinetRecVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGCabinetVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeliveryListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeptTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocInfoWebSrvVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryAttachVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGHistoryLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLineTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpinionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiptVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiveDocVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGRecordVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSecondApprVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGSignInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGTaskVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGWebPartVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGgetDeptStacticsVO;
import egovframework.ezEKP.ezApprovalG.web.EzApprovalGAdminController;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("EzApprovalGService")
public class EzApprovalGServiceImpl extends EgovFileMngUtil implements EzApprovalGService {

	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;

	@Autowired
	private Properties globals;
	
	@Resource(name = "EzApprovalGDAO")
	private EzApprovalGDAO ezApprovalGDAO;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource messageSource;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EzApprovalGAdminController.class);
	
	// DocType
	final public String staDTDraftDoc = "001";		// 기안문
	final public String staDTReportDoc = "002";	  // 보고문
	final public String staDTReceiptDoc = "003";		// 수신문
	final public String staDTExcuteDoc = "004";	  // 시행문
	final public String staDTHabyuiDoc = "005";	  // 합의문
	final public String staDTGamsaDoc = "006";		// 감사문
	final public String staDTApplyDoc = "007";		// 신청서

	// DocState
	final public String staDSPumYui = "001";			// 품의
	final public String staDSHyubJo = "002";			// 협조
	final public String staDSGamSa = "003";		  // 감사
	final public String staDSSimSa = "004";		  // 심사
	final public String staDSSuSin = "011";		  // 수신
	final public String staDSHabYui = "012";			// 합의
	final public String staDSSiHang = "013";			// 시행
	final public String staDSGamSaBu = "014";		// 검사부 감사
	final public String staDSGongRam = "015";		// 공람
	final public String staDSHoiRam = "016";			// 회람
	final public String staDSChamJo = "017";			// 참조
	final public String staDSWhokyul = "018";		// 후결
	final public String staDSBalsin = "019";			// 발신
	final public String staDSApply = "020";		  // 신청
	final public String staDSBansong = "031";		// 반송
	final public String StaDSHesong = "032";			// 회송

	// AprType
	final public String staATYilBan = "001";         // 일반
	final public String staATGyulJe = "001";         // 결재
	final public String staatwhoakin = "002";        // 확인
	final public String staATAnHam = "003";         // 결재안함
	final public String staATJunGyul = "004";        // 전결
	final public String staATGamSa = "005";         // 감사
	final public String staATSimSa = "006";         // 심사
	final public String staATChamJo = "007";         // 참조
	final public String staATSoonChaHyubJo = "008";     // 개인순차협조
	final public String staATHapYu = "008";					// 개인 합의
	final public String staATByungRyulHyubJo = "009";		// 개인병렬협조
	final public String staATBuSeuSoonChaHyubJo = "011";		// 부서순차협조
	final public String staATBuSeuByungRyulHyubJo = "012";	// 부서병렬협조
	final public String staATGamSaBu = "013";				// 감사
	final public String staATSuSin = "014";					// 수신
	final public String staATWhokyul = "015";				// 후열
	final public String staATGongram = "017";				// 공람
	final public String staATDekyul = "016";					// 대결
	final public String staATgian = "018";					// 기안
	final public String staATgumto = "019";					// 검토

	// AprState
	final public String staASmikyul = "000";					// 미결
	final public String staASDaeGi = "001";					// 대기
	final public String staASJinHang = "002";					// 진행
	final public String staASSungIn = "003";					// 승인
	final public String staASBanSong = "004";					// 반송
	final public String staASBoRyu = "005";					// 보류
	final public String staASWheSu = "006";					// 회수
	final public String staASAprEND = "010";					// 완료
	final public String staASDoJak = "011";					// 도착
	final public String staASJiJung = "012";					// 지정
	final public String staASJubSu = "013";					// 접수
	final public String staASBaeBu = "014";					// 배부
	final public String staASWheSong = "015";					// 회송
	final public String staASSusinJinHang = "016";			// 수신진행
	final public String staASSusinSungIn = "017";				// 수신완료
	final public String staASSusinJiJung = "018";				// 수신지정
	
	// OpinionType
	final public String staIlBan = "001";			// 일반의견
	final public String staBanSong = "002";		// 반송의견
	final public String staBoRyu = "003";			// 보류의견
	final public String staWheSong = "004";		// 회송의견

	@Override
	// 해당 부서에서 볼 수 있는 문서함의 리스트를 가져온다.
	// OwnFlag : "0"-자기 부서의 문서함, "1"-타부서의 문서함, "2"-전부
	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception{
		LOGGER.debug("getUseContInfo started.");

		String listHeader = getListHeader("106", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		List<ApprGLeftVO> apprGLeftVOList = new ArrayList<ApprGLeftVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", userInfo.getDeptID());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		if (ownFlag.equals("1")) {
			LOGGER.debug("getUseContInfo2 Param : ownFlag="+ ownFlag + " deptID = " +userInfo.getDeptID() +" v_TENANTID =" + userInfo.getTenantId());
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo2(map);
		} else {
			LOGGER.debug("getUseContInfo1 Param : ownFlag="+ ownFlag + " deptID = " +userInfo.getDeptID() +" v_TENANTID =" + userInfo.getTenantId());
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo1(map);
		}
		
		if (ownFlag.equals("2")) {
			List<ApprGLeftVO> apprGLeftVOListTemp = new ArrayList<ApprGLeftVO>();
			LOGGER.debug("getUseContInfo3 Param : ownFlag="+ ownFlag + " deptID = " +userInfo.getDeptID() +" v_TENANTID =" + userInfo.getTenantId());
			apprGLeftVOListTemp = ezApprovalGDAO.getUseContInfo3(map);
			
			for (int k = 0; k < apprGLeftVOListTemp.size(); k++) {
				apprGLeftVOListTemp.get(k).setContainerTypeName(makeListField(ezOrganService.getPropertyValue(apprGLeftVOListTemp.get(k).getContainerOwnDepID(), "displayName", userInfo.getTenantId())) + "_" + makeListField(apprGLeftVOListTemp.get(k).getContainerTypeName()));
				apprGLeftVOListTemp.get(k).setContainerTypeName2(makeListField(ezOrganService.getPropertyValue(apprGLeftVOListTemp.get(k).getContainerOwnDepID(), "displayName2", userInfo.getTenantId())) + "_" + makeListField(apprGLeftVOListTemp.get(k).getContainerTypeName2()));
				
				apprGLeftVOList.add(apprGLeftVOListTemp.get(k));
			}
		}
		
		Document doc = commonUtil.convertStringToDocument(listHeader);
		
		if (apprGLeftVOList.size() > 0) {
			if (doc.getElementsByTagName("NAME").getLength() > 0) {
				apprGLeftVOList.get(0).setName(doc.getElementsByTagName("NAME").item(0).getTextContent());
				apprGLeftVOList.get(0).setWidth(Integer.parseInt(doc.getElementsByTagName("WIDTH").item(0).getTextContent()));
			} else {
				apprGLeftVOList.get(0).setName(messageSource.getMessage("ezApprovalG.t1548", userInfo.getLocale()));
				apprGLeftVOList.get(0).setWidth(250);
			}
		}
		LOGGER.debug("getUseContInfo ended.");

		return apprGLeftVOList;
	}

	public String getListHeader(String listCode, String companyID, String lang, int tenantID) throws Exception{
		LOGGER.debug("getListHeader started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		LOGGER.debug("getListHeader Param : v_LISTTYPE="+ listCode + " v_LANGTYPE = " +lang +" v_TENANTID =" + tenantID);
		List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(map);
		
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListHeaderVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListHeaderVOList.get(i)));
		}
		sb.append("</DATA>");
		LOGGER.debug("getListHeader ended.");

		return sb.toString();
	}

	@Override
	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception {
		LOGGER.debug("getOptionInfo started.");

		String resultString = "";
		if (mode.equals("NAME")) {
			resultString = getName2Code(code1, code2, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			LOGGER.debug("getName2Code ended.");
		} else {
			resultString = getCode2Name(code1, code2, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
			LOGGER.debug("getCode2Name ended.");
		}
		LOGGER.debug("getOptionInfo Value: resultString= " +resultString);

		LOGGER.debug("getOptionInfo ended.");

		return resultString;
	}
	
	@Override
	public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception{
		LOGGER.debug("getCode2Name started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		LOGGER.debug("getOptionInfo Param : v_CODE1=" + code1 + " v_CODE2=" + code2 + " v_LANGTYPE=" + lang + " v_TENANTID= " + tenantID);

		return ezApprovalGDAO.getCode2Name(map);
	}

	@Override
	public String getAccessYNG(String docID, String userID, String mode, String companyID, String lang, int tenantID) throws Exception {
		LOGGER.debug("getAccessYNG started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERID", userID);
		boolean rtnVal = true;
		
		mode = mode.trim().toUpperCase();
		
		if (mode.length() != 3) {
			mode = "NNN";
		}
		String publicityCode = "1";
		String publicityFlag = "ALL";
		
		if (mode.substring(0, 1).equals("Y")) {
			map.put("v_FLAG", "001");
			LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + "v_TENANTID =" + tenantID + "v_USERID=" + userID + "v_FLAG=" +  "001");

			publicityCode = makeListField(ezApprovalGDAO.getAccessYNG(map));
			LOGGER.debug("getAccessYNG Value : publicityCode =" + publicityCode);

			if (publicityCode.length() <= 0) {
				publicityCode = "1";
			} else {
				publicityCode = publicityCode.substring(0, 1);
			}
			publicityFlag = getCode2Name("A50", publicityCode, companyID, lang, tenantID);
			LOGGER.debug("getCode2Name ended.");

			switch (publicityFlag) {
			case "ALL":
				rtnVal = true;
				break;
				
			case "DEPT":
				map.put("v_FLAG", "002");
				LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "002");

				String isLineInfo3 = makeListField(ezApprovalGDAO.getAccessYNG(map));
				LOGGER.debug("getAccessYNG Value : isLineInfo3 =" + isLineInfo3);

				if (isLineInfo3.equals("Y")) {
					rtnVal = true;
				} else {
					map.put("v_FLAG", "003");
					LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "003");

					String drafterDeptID = makeListField(ezApprovalGDAO.getAccessYNG(map));
					LOGGER.debug("getAccessYNG Value : drafterDeptID =" + drafterDeptID);

					String result = ezOrganService.getPropertyList(userID, "extensionAttribute4;department", commonUtil.getPrimaryData(lang, tenantID), tenantID);
					
					if (result.toLowerCase().lastIndexOf(drafterDeptID.toLowerCase()) >= 0 && drafterDeptID.trim().length() > 0) {
						rtnVal = true;
					} else {
						rtnVal = false;
					}
				}
				break;
				
			case "LINE":
				map.put("v_FLAG", "002");
				LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "002");

				String isLineInfo2 = makeListField(ezApprovalGDAO.getAccessYNG(map));
				LOGGER.debug("getAccessYNG Value : isLineInfo2 =" + isLineInfo2);

				if (isLineInfo2.equals("Y")) {
					rtnVal = true;
				} else {
					rtnVal = false;
				}
				break;
				
			case "DRAFT":
				map.put("v_FLAG", "004");
				LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "004");

				String drafterYN = makeListField(ezApprovalGDAO.getAccessYNG(map));
				LOGGER.debug("getAccessYNG Value : drafterYN =" + drafterYN);

				if (drafterYN.trim().equals("")) {
					rtnVal = false;
				} else {
					rtnVal = true;
				}
				break;
				
			default:
				break;
			}
		}
		try{
		if (publicityFlag.equals("ALL") && mode.substring(1, 2).equals("Y")) {
			String userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6", tenantID);
			
			if (userSecurityCode == null || userSecurityCode.trim().equals("")) {
				userSecurityCode = "0";
				map.put("v_FLAG", "005");
				LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "005");

				String docSecurityCode = makeListField(ezApprovalGDAO.getAccessYNG(map));
				LOGGER.debug("getAccessYNG Value : docSecurityCode =" + docSecurityCode);

				if (docSecurityCode.trim().equals("")) {
					docSecurityCode = "999";
				}
				
				if (Integer.parseInt(userSecurityCode) <= Integer.parseInt(docSecurityCode)) {
					rtnVal = true;
				} else {
					rtnVal = false;
				}
				
				if (getIsUse("A22", "005", companyID, lang, tenantID).equals("1")) {
					map.put("v_FLAG", "002");
					LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "002");

					String isLineInfo = makeListField(ezApprovalGDAO.getAccessYNG(map));
					LOGGER.debug("getAccessYNG Value : isLineInfo =" + isLineInfo);

					if (isLineInfo.equals("Y")) {
						rtnVal = true;
					}
				}
			}
		}
		}
		catch (Exception e){
		}
		
		if (!rtnVal && mode.substring(2).equals("Y")) {
			map.put("v_FLAG", "006");
			LOGGER.debug("getAccessYNG Param : v_DOCID =" + docID + " v_TENANTID =" + tenantID + " v_USERID=" + userID + " v_FLAG=" +  "006");

			String allUserRight = ezApprovalGDAO.getAccessYNG(map);
			LOGGER.debug("getAccessYNG Value : allUserRight =" + allUserRight);

			if (allUserRight.length() <= 0) {
				allUserRight = "0";
			}
			
			if (Integer.parseInt(allUserRight) > 0) {
				rtnVal = true;
			}
		}
		LOGGER.debug("getAccessYNG ended.");

		if (rtnVal) {
			return "<RESULT>TRUE</RESULT>";
		} else{
			return "<RESULT>FALSE</RESULT>";
		}
	}

	public String getName2Code(String code1, String code2, String companyID, String lang, int tenantID) throws Exception{
		LOGGER.debug("getName2Code started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_NAME", code2);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		LOGGER.debug("getName2Code Param: v_CODE1=" + code1 + " v_NAME =" + code2 + " v_LANGTYPE=" +lang + " v_TENANTID=" + tenantID);

		return ezApprovalGDAO.getName2Code(map);
	}

	@Override
	public String getLineInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		LOGGER.debug("getLineInfo started.");

		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		if (mode.equals("APR")) {
			//결재할문서
			listString = getListHeader("011", companyID, lang, tenantID);
		} else if (mode.equals("END")) {
			//기안할문서
			listString = getListHeader("012", companyID, lang, tenantID);
		} else if (mode.equals("COD")) {
			//결재진행문서
			listString = getListHeader("013", companyID, lang, tenantID);
		} else {
			listString = getListHeader("011", companyID, lang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getLineInfo(docID, mode, orderOption1, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("APRMEMBERNAME") || fieldName.equals("APRMEMBERJOBTITLE") || fieldName.equals("APRMEMBERDEPTNAME") || fieldName.equals("PROXYUSERNAME") || fieldName.equals("PROXYUSERJOBTITLE") || fieldName.equals("PROXYUSERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(convertDate(docXML.getElementsByTagName("PROCESSDATE").item(k).getTextContent())) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(convertDate(docXML.getElementsByTagName("RECEIVEDDATE").item(k).getTextContent())) + "</DATA2>");
					resultXML.append("<DATA3>" + docID + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + docXML.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent() + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("REASONDONOTAPPROV").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + docXML.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent() + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("APRTYPE").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("APRSTATE").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent()) + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent()) + "</DATA15>");
					resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA16>");
					resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA17>");
					resultXML.append("<DATA18>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA18>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		LOGGER.debug("getLineInfo ended.");

		return resultXML.toString();
	}

	public String getLineInfo(String docID, String mode, String orderOption1, String companyID, int tenantID) throws Exception {
		LOGGER.debug("getLineInfo started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_TENANTID", tenantID);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if (orderOption1.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0,10).toLowerCase());
		}
		
		LOGGER.debug("getLineInfo Param : v_DOCID= " + docID + " v_MODE=" + mode + " v_ORDEROPTION=" + orderOption1 + " v_TENANTID="+ tenantID);

		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getLineInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		LOGGER.debug("getLineInfo ended.");

		return sb.toString();
	}

	@Override
	public String getAttachInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		LOGGER.debug("getAttachInfo started.");

		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("043", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String strLangFile = getCode2Name("L01", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String strLangDocument = getCode2Name("L01", "002", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String docList = getAttachInfoDB(docID, flag, commonUtil.getMultiData(lang, tenantID), strLangFile, strLangDocument, orderOption1, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("ATTACHHREF").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("ATTACHSN").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("ATTACHTYPE").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("REALATTACHNAME").item(k).getTextContent()) + "</DATA5>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		LOGGER.debug("getAttachInfo ended.");

		return resultXML.toString();
	}

	@Override
	public String getReceiptInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		LOGGER.debug("getReceiptInfo started.");
		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		if (mode.equals("APR")) {
			//결재할문서
			listString = getListHeader("021", companyID, lang, tenantID);
		} else if (mode.equals("END")) {
			//기안할문서
			listString = getListHeader("022", companyID, lang, tenantID);
		} else if (mode.equals("COD")) {
			//결재진행문서
			listString = getListHeader("023", companyID, lang, tenantID);
		} else if (mode.equals("TMP")) {
			//임시보관함문서
			listString = getListHeader("023", companyID, lang, tenantID);
		} else if (mode.equals("RES")) {
			//재발송 기능
			listString = getListHeader("024", companyID, lang, tenantID);
		} else {
			listString = getListHeader("021", companyID, lang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getReceiptInfo(docID, mode, orderOption1, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("RECEIPTPOINTNAME") || fieldName.equals("RECEIPTMEMBERNAME") || fieldName.equals("PROCESSDEPTNAME") || fieldName.equals("APRMEMBERTITLE") || fieldName.equals("DRAFTERNAME") || fieldName.equals("CREATEORGANNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("RECEIPTPOINTID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + docID + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("EXTRECEPTYN").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("PROCESSYN").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("CANEDITYN").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERID").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME2").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME2").item(k).getTextContent()) + "</DATA13>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		LOGGER.debug("getReceiptInfo ended.");
		return resultXML.toString();
	}

	@Override
	public String getOpinionInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		LOGGER.debug("getOpinionInfo started.");

		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		if (mode.equals("APR")) {
			//결재할문서
			listString = getListHeader("031", companyID, lang, tenantID);
		} else if (mode.equals("END")) {
			//기안한문서
			listString = getListHeader("032", companyID, lang, tenantID);
		} else if (mode.equals("CAPR")) {
			//결재진행문서
			listString = getListHeader("033", companyID, lang, tenantID);
		} else if (mode.equals("CEND")) {
			//결재진행문서
			listString = getListHeader("034", companyID, lang, tenantID);
		} else {
			listString = getListHeader("031", companyID, lang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getOpinionInfo(docID, mode, orderOption1, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("USERNAME") || fieldName.equals("USERJOBTITLE") || fieldName.equals("USERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("USERID").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("CONTENT").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("USERDEPTID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("OPINIONSN").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("OPINIONGB").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("USERNAME").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("USERNAME2").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("USERJOBTITLE").item(k).getTextContent()) + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("USERJOBTITLE2").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("USERDEPTNAME").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("USERDEPTNAME2").item(k).getTextContent()) + "</DATA12>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		LOGGER.debug("getOpinionInfo ended.");

		return resultXML.toString();
	}

	@Override
	public String getWebPartList(String listType, String userID, String deptID, String listCount, String mode, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception {
		LOGGER.debug("getWebPartList started.");

		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = "";
		String result = "";
		
		if (listType.equals("1")) {
			proxyOption = getIsUse("A23", "001", companyID, lang, tenantID);
			LOGGER.debug("getIsUse ended");
			if (proxyOption.equals("1")) {
				userIDs = getProxyUser(userID, lang, tenantID, offset);
			}
		}
		
		String basicOrder = getCode2Name("A18", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		
		if (mode.equals("COUNT")) {
			int totalCount = getWebPartListCount(listType, userID, deptID, userIDs, getDocManageDeptInfo(deptID, tenantID), userFlag.toLowerCase().trim(), companyID, tenantID);
			result = "<RESULT>" + totalCount + "</RESULT>";
		} else if (mode.equals("LEFT")) {
			String leftCount = getLeftDocCount(userID, deptID, userIDs, getDocManageDeptInfo(deptID, tenantID), userFlag.toLowerCase(), companyID, tenantID);
			result = leftCount;
		} else {
			String webList = getWebPartList(listType, userID, deptID, userIDs, getDocManageDeptInfo(deptID, tenantID), userFlag.toLowerCase(), listCount, basicOrder, strMultiData, companyID, tenantID);
			result = webList;
		}
		
		LOGGER.debug("getWebPartList ended.");

		return result;
	}

	@Override
	public String getDocType(String selected, String companyID, String lang, int tenantID) throws Exception {
		LOGGER.debug("getDocType started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", commonUtil.getMultiData(lang, tenantID));
		map.put("v_TENANTID", tenantID);
		
		List<HashMap<String, Object>> docTypes = ezApprovalGDAO.getDocType(map);
		
		int dlength = docTypes.size();
		StringBuilder sb = new StringBuilder();
		
		for (int k = 0; k < dlength; k++) {
			String code2 = (String) docTypes.get(k).get("CODE2");
			String name = (String) docTypes.get(k).get("NAME");
			
			if (code2.equals(selected)) {
				sb.append("<OPTION value=" + code2 + " selected>" + name + "</OPTION>");
			} else {
				sb.append("<OPTION value=" + code2 + ">" + name + "</OPTION>");
			}
		}
		
		LOGGER.debug("stringBuiler : " + sb.toString());
		LOGGER.debug("getDocType ended.");
		
		return sb.toString();
	}

	@Override
	public String getFormInfo(String formContID, String kind, String searchType, String searchName, String userID, String companyID, String lang, int tenantID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("109", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		String docList = getFormInfoDB(formContID, userID, kind, strMultiData, searchType, searchName, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				
				if (p == 0) {
					if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
						resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("FORMNAME").item(k).getTextContent()) + "</VALUE>");
					} else {
						resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("FORMNAME2").item(k).getTextContent()) + "</VALUE>");
					}
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("FORMDESCRIPTION").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("FORMDOCTYPE").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("FORMFILELOCATION").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("FORMCONNFLAG").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("FORMNAME").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("FORMNAME2").item(k).getTextContent()) + "</DATA7>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		LOGGER.debug("resultXML : " + resultXML);
		
		return resultXML.toString();
	}

	@Override
	public String getFormContainerInfo(String id, String deptID, String companyID, String primary, int tenantID) throws Exception {
		LOGGER.debug("getFormContainerInfo started");
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTID", deptID);
		map.put("v_ID", id);
		map.put("v_TENANTID", tenantID);
		
		LOGGER.debug("getFormContainerInfo param : v_DEPTID= " + deptID +" v_ID=" + id + " v_TENANTID" + tenantID);
		List<ApprGFormVO> apprGFormVOList = ezApprovalGDAO.getFormContainerInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGFormVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGFormVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		rtnXML.append("<NODES>");
		
        for (int k = 0; k < dlength; k++) {
            rtnXML.append("<NODE>");
            
            if (k == 0) {
            	rtnXML.append("<SELECT></SELECT>");
            }
            int childCnt = getCountChildFormCont(docXML.getElementsByTagName("FORMCONTID").item(k).getTextContent(), deptID, companyID, tenantID);
            
    		LOGGER.debug("getCountChildFormCont value : " + childCnt);

            String ISLEAF = "FALSE";
            
            if (childCnt < 1) {
            	ISLEAF = "TRUE";
            }
            rtnXML.append("<EXPANDED>FALSE</EXPANDED><ISLEAF>" + ISLEAF + "</ISLEAF>");
            
            if (primary.equals("1")) {
            	rtnXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME").item(k).getTextContent())) + "</VALUE>");
            } else {
            	rtnXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME2").item(k).getTextContent())) + "</VALUE>");
            }

            if (deptID.trim().equals("")) {
				rtnXML.append("<DATA1>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTID").item(k).getTextContent())) + "</DATA1>");
				rtnXML.append("<DATA2>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME").item(k).getTextContent())) + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTOWNDEPID").item(k).getTextContent())) + "</DATA3>");
				rtnXML.append("<DATA4>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTPARENTS").item(k).getTextContent())) + "</DATA4>");
				rtnXML.append("<DATA5>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTDESCRIPTION").item(k).getTextContent())) + "</DATA5>");
				
                if (docXML.getElementsByTagName("FORMCONTOWNDEPID").item(k).getTextContent().equals("ALL")) {
                	rtnXML.append("<DATA6>ALL</DATA6>");
                } else {
					rtnXML.append("<DATA6>" + commonUtil.cleanValue(makeListField(ezOrganService.getPropertyValue(docXML.getElementsByTagName("FORMCONTOWNDEPID").item(k).getTextContent().toUpperCase(), "DisplayName", tenantID).toString())) + "</DATA6>");
				}
                rtnXML.append("<DATA7>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME2").item(k).getTextContent())) + "</DATA7>");
			} else {
				rtnXML.append("<DATA1>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTID").item(k).getTextContent())) + "</DATA1>");
				rtnXML.append("<DATA2>" + commonUtil.cleanValue(makeListField(deptID)) + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTDESCRIPTION").item(k).getTextContent())) + "</DATA3>");
                rtnXML.append("<DATA7>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME2").item(k).getTextContent())) + "</DATA7>");
			}
			rtnXML.append("</NODE>");
		}
		rtnXML.append("</NODES>");
		
		LOGGER.debug("getFormContainerInfo ended");

		return rtnXML.toString();
	}

	@Override
	public String setUserFormInfo(String formID, String userID, String companyID, int tenantID){
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		
		try {
			String setUserFormYN = ezApprovalGDAO.setUserFormInfoYN(map);
			if(setUserFormYN == null) {
				ezApprovalGDAO.setUserFormInfo(map);
			}
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		return rtnVal;
	}

	@Override
	public String delUserFormInfo(String formID, String userID, String companyID, int tenantID){
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		
		try {
			ezApprovalGDAO.delUserFormInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		return rtnVal;
	}

	@Override
	public String getApprovalPWD(String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_TENANTID", tenantID);
		return ezApprovalGDAO.getApprovalPWD(map);
	}

	@Override
	public String getApprovalPWD2(String dUserID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", dUserID);
		map.put("v_TENANTID", tenantID);
		return ezApprovalGDAO.getApprovalPWD2(map);
	}

	@Override
	public String getUserRecRight(String recID, String sepAttNo, String userID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RecID", recID);
		map.put("v_SepAttNo", sepAttNo);
		map.put("v_UserID", userID);
		map.put("v_TENANTID", tenantID);

		String result = ezApprovalGDAO.getUserRecRight(map);
		if(result == null || result.equals("0")){
			result = ezApprovalGDAO.getUserRecRightCount(map);
			if(result == null || result.equals("0")) {
				result = ezApprovalGDAO.getUserRecRightCount2(map);
				if(result == null) {
					result = "0";
				}
			}
		}
		
		return "<RESULT>" + result + "</RESULT>";
	}

	@Override
	public String setCabinetReject(String docID, String deptID, String deptName, String deptName2, String dirPath, String hesongFlag, String companyID, String lang, int tenantID, String offSet) throws Exception {
		LOGGER.debug("setCabinetReject Started");

		StringBuilder strSQL = new StringBuilder();
		String rtnVal ="TRUE";
		String sn = "";
		String docSN = "";
		String newDocID = "";
		String gFlag = getCode2Name("A35", "002", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String docNo = "";
		String orgDocNumCode = "";
		String docNumCode = "";
		String extFileName = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		ApprGDocListVO apprGDocListVO = ezApprovalGDAO.setCabinetReject1(map);
		
		if (apprGDocListVO != null) {
			orgDocNumCode = apprGDocListVO.getOrgDocNumCode();
			sn = getCabinetNum(deptID, "", companyID, tenantID);
			sn = sn.replace("<REGNUM>", "").replace("</REGNUM>", "");
			sn = sn.replace("<RESULT>", "").replace("</RESULT>", "");
			
			if (!sn.trim().equals("")) {
				newDocID = getNewID(companyID, tenantID);
				
				extFileName = getExtendedFileName(apprGDocListVO.getHref());
				docNumCode = deptID + getNDigitNum(sn, 6);
				
				if (orgDocNumCode.trim().equals("") || !gFlag.equals("G")) {
					docNo = commonUtil.cleanValue(deptName) + "-" + sn;
					
					String strXML = "<SIGNINFOS><SIGNINFO><DOCID>" + newDocID + 
							"</DOCID><SIGNTYPE>TEXT</SIGNTYPE><SIGNNAME>docnumber" + 
							"</SIGNNAME><CONTENT>" + docNo + "</CONTENT></SIGNINFO></SIGNINFOS>";
					
					Document xmlDom = commonUtil.convertStringToDocument(strXML);
					
					rtnVal = updateSignInfo(xmlDom, companyID, "QUERY", tenantID);
					
					if(rtnVal.equals("FALSE")){
						return "<RESULT>FALSE</RESULT>";
					}
				} else {
					docNo = "";
				}
			}
		}
		
		if (strSQL.toString().equals("FALSE") || newDocID.trim().equals("")) {
			if (!sn.trim().equals("")) {
				rollbackCabinetNum(deptID, "", sn, companyID, "", lang, tenantID);
			}
			
			return "<RESULT>FALSE</RESULT>";
		}
		
		String oldYear = getDocHrefYear(docID, companyID, tenantID);
		String endURL = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator +
				getDocDir(newDocID) + commonUtil.separator + newDocID + "." + extFileName;
		
		String docState = StaDSHesong;
		
		if (hesongFlag.trim().equals("")) {
			docState = staDSBansong;
		}
		
		String containerID = returnContainerID(deptID, docState, companyID, tenantID);
		
		copyFile(dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName,
				dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + getDocDir(newDocID) + commonUtil.separator + newDocID + "." + extFileName,
				dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + getDocDir(newDocID));
		
		map.put("v_NEWDOCID", newDocID);
		map.put("v_DOCID", docID);
		map.put("v_ENDURL", endURL);
		map.put("v_DOCSTATE", docState);
		map.put("v_DOCNO", docNo);
		map.put("v_DOCNUMCODE", docNumCode);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_CONTAINERID", containerID);
		map.put("v_TENANTID", tenantID);
		
		try {
			if(docNo.equals("")){
				ezApprovalGDAO.insertRejectEndAprDocInfo(map);
			} else {
				ezApprovalGDAO.insertRejectEndAprDocInfo2(map);
				ezApprovalGDAO.insertRejectEndAprLineInfo(map);
				ezApprovalGDAO.insertRejectEndAttachInfo(map);
				ezApprovalGDAO.insertRejectEndDocAttachInfo(map);
				ezApprovalGDAO.insertRejectEndAprOpinionInfo(map);
				ezApprovalGDAO.insertRejectEndReceiptPointInfo(map);
				ezApprovalGDAO.insertRejectEndAprReceiptProcessInfo(map);
				ezApprovalGDAO.insertRejectExpendAprDocInfo(map);
				ezApprovalGDAO.insertRejectExpendAprLine(map);
			} 
		} catch(Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			System.out.println(e.getMessage());
			return "<RESULT>FALSE</RESULT>";
		}
		
        map.put("v_HESONGFLAG", hesongFlag.trim());
        
        ApprGDocListVO apprGDocListVO2 = ezApprovalGDAO.setCabinetReject2(map);
        
        if (apprGDocListVO2 != null) {
        	if (!docNumCode.trim().equals("")) {
        		docSN = docNumCode.trim();
        	} else {
        		docSN = apprGDocListVO2.getDocNumCode();
        	}
        	
        	docSN = docSN.substring(docSN.length() - 6);
        	
        	String hasAttach = "0";
        	
        	if (apprGDocListVO2.getHasAttachYn().equals("Y")) {
        		hasAttach = "1";
        	}
        	
        	String seperateAttachXML = makeListField(apprGDocListVO2.getSeperateAttachXML().trim());
        	String numOfPage = makeListField(apprGDocListVO2.getPageNum().trim());
        	
        	if (numOfPage.equals("")) {
        		numOfPage = "1";
        	}
        	
        	rtnVal = regDocToCabinet("0", newDocID, docSN, apprGDocListVO2.getCabinetID(), apprGDocListVO2.getDocTitle(), apprGDocListVO2.getWriterDeptID(), apprGDocListVO2.getWriterDeptName(), apprGDocListVO2.getWriterDeptName2(),
        			"1", apprGDocListVO2.getAprMemberJobTitle(), apprGDocListVO2.getAprMemberJobTitle2(), apprGDocListVO2.getWriterName(), apprGDocListVO2.getWriterName2(), EgovDateUtil.getTodayTime().substring(0, 10),
        			"", "", "", "1", apprGDocListVO2.getOrgDocNumCode(), apprGDocListVO2.getSpecialRecordCode(), apprGDocListVO2.getPublicityCode(), apprGDocListVO2.getLimitRange(), "1", numOfPage, hasAttach, seperateAttachXML, companyID, lang, tenantID, offSet);

        } else {
        	if (!sn.trim().equals("")) {
        		rollbackCabinetNum(deptID, "", sn, companyID, "", lang, tenantID);
        	}
        	
        	return "<RESULT>FALSE</RESULT>";
        }
        
		
		if (!rtnVal.equals("FALSE")) {
			LOGGER.debug("setCabinetReject ended");
			return "<RESULT>TRUE</RESULT>";
		} else {
        	return "<RESULT>FALSE</RESULT>," + sn;
		}
	}

	@Override
	public String gongRamSave(Document xmlDom, String dirPath, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String docID = xmlDom.getElementsByTagName("ROW").item(0).getChildNodes().item(8).getTextContent().trim();
		String gongRamDocID = gongRamDocInfo(docID, companyID, tenantID);
		
		if (gongRamDocID == null || gongRamDocID.equals("") || gongRamDocID.equals("NONE")) {
			gongRamDocID = getNewID(companyID, tenantID);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_FLAG", "APR");
			map.put("v_TENANTID", tenantID);
			
			String href = ezApprovalGDAO.getDocInfoHref(map);
			String extFileName = getExtendedFileName(href);
			String susinDocURL = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + 
					commonUtil.separator + "1000" + commonUtil.separator + getDocDir(gongRamDocID) + commonUtil.separator + gongRamDocID + "." + extFileName;
			String fileURL = dirPath + href.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID), "");
			String target = dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator +
					getDocDir(gongRamDocID) + commonUtil.separator + gongRamDocID + "." + extFileName;
			
			copyFile(fileURL, target, dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(gongRamDocID));
			
			strSQL.append("INSERT INTO TBL_APRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, ");
            strSQL.append("HasOpinionYN, StartDate, EndDate, WriterID, WriterName, WriterName2, ");
            strSQL.append("WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID) (SELECT '");
			strSQL.append(gongRamDocID.trim() + "', FormID, '" + docID.trim());
			strSQL.append("', DocType, '" + staDSGongRam + "', '" + staASJinHang + "', '");
            strSQL.append(susinDocURL.trim() + "', DocTitle, DocNo, HasAttachYN, HasOpinionYN, ");
            strSQL.append("TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), NULL, WriterID, WriterName, WriterName2, ");
            strSQL.append("WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID ");
            strSQL.append("FROM TBL_APRDOCINFO WHERE DocID = '" + docID.trim() + "' AND TENANT_ID =" + tenantID + ");\n");

			strSQL.append("INSERT INTO TBL_EXPAPRDOCINFO (DocID, SecurityCode, ");
            strSQL.append("StoragePeriod, KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, ItemName2, ");
			strSQL.append("UrgentApproval, TempAttribute, Status, SpecialRecordCode, ");
			strSQL.append("PublicityCode, LimitRange, PageNum, CabinetID, TaskCode, ");
			strSQL.append("DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID) (SELECT '");
			strSQL.append(gongRamDocID.trim() + "', SecurityCode, StoragePeriod, KeyWord, ");
            strSQL.append("FormName, FormName2, companyID, ItemCode, ItemName, ItemName2, UrgentApproval, ");
			strSQL.append("TempAttribute, Status, SpecialRecordCode, PublicityCode, ");
			strSQL.append("LimitRange, PageNum, CabinetID, TaskCode, DocNumCode, ");
            strSQL.append("OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID FROM TBL_EXPAPRDOCINFO ");
			strSQL.append("WHERE DocID = '" + docID.trim() + "' AND TENANT_ID = " + tenantID + ");\n");

			strSQL.append("INSERT INTO TBL_APROPINIONINFO (DocID, UserID, OpinionGB, ");
            strSQL.append("Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, ");
			strSQL.append("OpinionSN, TENANT_ID) (SELECT '" + gongRamDocID.trim() + "', UserID, ");
            strSQL.append("OpinionGB, Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN, TENANT_ID FROM TBL_APROPINIONINFO WHERE DocID = '");
			strSQL.append(docID.trim() + "' AND TENANT_ID = " + tenantID + ");\n");

			strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, TENANT_ID) (SELECT '" + gongRamDocID.trim());
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, ");
            strSQL.append("AttachUserID, AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, TENANT_ID FROM TBL_APRDOCATTACHINFO WHERE DocID = '");
			strSQL.append(docID.trim() + "' AND TENANT_ID = " + tenantID + ");\n");

			strSQL.append("INSERT INTO TBL_APRATTACHINFO (DocID, AttachFileSN, ");
			strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, PageNum, DisplayName, BodyAttach, TENANT_ID) (SELECT '");
            strSQL.append(gongRamDocID.trim() + "', AttachFileSN, AttachFileName, ");
            strSQL.append("AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, AttachUserJobTitle, AttachUserJobTitle2, ");
            strSQL.append("PageNum, DisplayName, BodyAttach, TENANT_ID FROM TBL_APRATTACHINFO WHERE ");
			strSQL.append("DocID = '" + docID.trim() + "' AND TENANT_ID = " + tenantID + ");\n");
		}
		
		strSQL.append("UPDATE TBL_APRDOCINFO SET StartDate = EndDate WHERE DocID = '" + gongRamDocID.trim() + "' AND StartDate IS NULL AND TENANT_ID = " + tenantID + " ;\n");
		strSQL.append("UPDATE TBL_APRDOCINFO SET EndDate = NULL WHERE DocID = '" + gongRamDocID.trim() + "' AND StartDate IS NOT NULL  AND TENANT_ID = " + tenantID + ";\n");

		strSQL.append("DELETE FROM TBL_APRLINEINFO WHERE DocID = '" + gongRamDocID.trim() + "' AND TENANT_ID = " + tenantID + ";\n");
		strSQL.append("DELETE FROM TBL_EXPAPRLINE WHERE DocID = '" + gongRamDocID.trim() + "' AND TENANT_ID = " + tenantID + ";\n");
		
		String recDate = "";
		String processDate = "";
		
		for (int k = 0; k < xmlDom.getElementsByTagName("ROW").getLength(); k++) {
			if (xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(7).getTextContent().trim().equals("")) {
				recDate = "NULL";
			} else {
				recDate = "'" + makeRightField(makeListField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(7).getTextContent().trim())) + "'";
			}
			
			if (xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent().trim().equals("")) {
				processDate = "NULL";
			} else {
				processDate = "'" + makeRightField(makeListField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent().trim())) + "'";
			}
			
			strSQL.append("INSERT INTO TBL_APRLINEINFO (DocID, AprMemberSN, AprType, ");
            strSQL.append("AprState, AprMemberID, AprMemberIsDeptYN, AprMemberName, AprMemberName2, ");
            strSQL.append("AprMemberJobTitle, AprMemberJobTitle2, AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, ");
			strSQL.append("AprMemberLDAPPath, ReceivedDate, ProcessDate, ReasonDoNotApprov, ");
			strSQL.append("isProposerYN, isBriefUserYN, TENANT_ID) VALUES ('" + gongRamDocID + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(22).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(23).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(10).getTextContent()) + "', N'");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(16).getTextContent()) + "', N'");
            // AprMemberName2
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(17).getTextContent()) + "', N'");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(20).getTextContent()) + "', N'");
            // AprMemberJobTitle2
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(21).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent()) + "', N'");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(18).getTextContent()) + "', N'");
            // AprMemberDeptName2
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(19).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent()) + "', ");
			strSQL.append(recDate + ", " + processDate + ", N'");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(12).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(13).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(14).getTextContent()) + "'," +tenantID +"); \n");

			strSQL.append("INSERT INTO TBL_EXPAPRLINE (DocID, AprMemberSN, OrgUserID, ");
            strSQL.append("ProxyUserID, proxyusername, proxyusername2, proxyuserjobtitle, proxyuserjobtitle2, proxyuserdeptid, ");
            strSQL.append("proxyuserdeptname, proxyuserdeptname2, TENANT_ID) VALUES ('" + gongRamDocID.trim() + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent()) + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent()));
            strSQL.append("', '', '', '', '', '', '', '',''," + tenantID +");\n");
		}
		String rtnVal = "";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map);
			
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		if (gongRamActivate(gongRamDocID, companyID, lang, tenantID)) {
			rtnVal = "<RESULT>TRUE</RESULT>";
		} else {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String gongRamSaveEnd(Document xmlDom, String dirPath, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String docID = xmlDom.getElementsByTagName("ROW").item(0).getChildNodes().item(8).getTextContent().trim();
		String gongRamDocID = gongRamDocInfo(docID, companyID, tenantID);
		
		if (gongRamDocID == null || gongRamDocID.equals("") || gongRamDocID.equals("NONE")) {
			gongRamDocID = getNewID(companyID, tenantID);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_FLAG", "END");
			map.put("v_TENANTID", tenantID);
			
			String href = ezApprovalGDAO.getDocInfoHref(map);
			String extFileName = getExtendedFileName(href);
			String susinDocURL = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + 
					commonUtil.separator + "1000" + commonUtil.separator + getDocDir(gongRamDocID) + commonUtil.separator + gongRamDocID + "." + extFileName;
			String fileURL = dirPath + href.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID), "");
			String target = dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator +
					getDocDir(gongRamDocID) + commonUtil.separator + gongRamDocID + "." + extFileName;
			
			copyFile(fileURL, target, dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(gongRamDocID));
			
			strSQL.append("INSERT INTO TBL_APRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
            strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, ");
            strSQL.append("HasOpinionYN, StartDate, EndDate, WriterID, WriterName, WriterName2,");
            strSQL.append("WriterJobTitle,WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID) (SELECT '");
            strSQL.append(gongRamDocID.trim() + "', FormID, '" + docID.trim());
            strSQL.append("', DocType, '" + staDSGongRam + "', '" + staASJinHang + "', '");
            strSQL.append(susinDocURL.trim() + "', DocTitle, DocNo, HasAttachYN, HasOpinionYN, TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
            strSQL.append(", NULL, WriterID, WriterName, WriterName2, ");
            strSQL.append("WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID ");
            strSQL.append("FROM TBL_ENDAPRDOCINFO WHERE DocID = '" + docID.trim() + "' AND TENANT_ID= " + tenantID +");\n");

            // 수정(2005.09.29) : 보안결재 필드 추가
            strSQL.append("INSERT INTO TBL_EXPAPRDOCINFO (DocID, SecurityCode, ");
            strSQL.append("StoragePeriod, KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, ItemName2, ");
            strSQL.append("UrgentApproval, TempAttribute, Status, SpecialRecordCode, ");
            strSQL.append("PublicityCode, LimitRange, PageNum, CabinetID, TaskCode, ");
            strSQL.append("DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID) (SELECT '");
            strSQL.append(gongRamDocID.trim() + "', SecurityCode, StoragePeriod, KeyWord, ");
            strSQL.append("FormName, FormName2, companyID, ItemCode, ItemName, ItemName2, UrgentApproval, ");
            strSQL.append("TempAttribute, Status, SpecialRecordCode, PublicityCode, ");
            strSQL.append("LimitRange, PageNum, CabinetID, TaskCode, DocNumCode, ");
            strSQL.append("OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID FROM TBL_EXPENDAPRDOCINFO ");
            strSQL.append("WHERE DocID = '" + docID.trim() + "' AND TENANT_ID = " + tenantID +");\n");

            strSQL.append("INSERT INTO TBL_APROPINIONINFO (DocID, UserID, OpinionGB, ");
            strSQL.append("Content, UserName,  UserName2,  UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, ");
            strSQL.append("OpinionSN, TENANT_ID) (SELECT '" + gongRamDocID.trim() + "', UserID, ");
            strSQL.append("OpinionGB, Content, UserName,  UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN, TENANT_ID FROM TBL_ENDAPROPINIONINFO WHERE DocID = '");
            strSQL.append(docID.trim() + "' AND TENANT_ID = " + tenantID +");\n");

            strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2,  AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2,");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, TENANT_ID) (SELECT '" + gongRamDocID.trim());
            strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, ");
            strSQL.append("AttachUserID, AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, TENANT_ID FROM TBL_ENDAPRDOCATTACHINFO WHERE DocID = '");
            strSQL.append(docID.trim() + "' AND TENANT_ID = " + tenantID +");\n");

            strSQL.append("INSERT INTO TBL_APRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, ");
            strSQL.append("AttachUserJobTitle,  AttachUserJobTitle2, PageNum, DisplayName, BodyAttach, TENANT_ID) (SELECT '");
            strSQL.append(gongRamDocID.trim() + "', AttachFileSN, AttachFileName, ");
            strSQL.append("AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2,");
            strSQL.append("AttachUserDeptID, AttachUserDeptName,AttachUserDeptName2,  AttachUserJobTitle,  AttachUserJobTitle2,");
            strSQL.append("PageNum, DisplayName, BodyAttach, TENANT_ID FROM TBL_ENDATTACHINFO WHERE ");
            strSQL.append("DocID = '" + docID.trim() + "' AND TENANT_ID = " + tenantID +");\n");
		}
		
		strSQL.append("UPDATE TBL_APRDOCINFO SET StartDate = EndDate WHERE DocID = '" + gongRamDocID.trim() + "' AND StartDate IS NULL  AND TENANT_ID = " + tenantID +";\n");
        strSQL.append("UPDATE TBL_APRDOCINFO SET EndDate = NULL WHERE DocID = '" + gongRamDocID.trim() + "' AND StartDate IS NOT NULL  AND TENANT_ID = " + tenantID +";\n");

        strSQL.append("DELETE FROM TBL_APRLINEINFO WHERE DocID = '" + gongRamDocID.trim() + "' AND TENANT_ID = " + tenantID +";\n");
        strSQL.append("DELETE FROM TBL_EXPAPRLINE WHERE DocID = '" + gongRamDocID.trim() + "' AND TENANT_ID = " + tenantID +";\n");
        
        String recDate = "";
		String processDate = "";
		
		for (int k = 0; k < xmlDom.getElementsByTagName("ROW").getLength(); k++) {
			if (xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(7).getTextContent().trim().equals("")) {
				recDate = "NULL";
			} else {
				recDate = "'" + makeRightField(makeListField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(7).getTextContent().trim())) + "'";
			}
			
			if (xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent().trim().equals("")) {
				processDate = "NULL";
			} else {
				processDate = "'" + makeRightField(makeListField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent().trim())) + "'";
			}
			
			strSQL.append("INSERT INTO TBL_APRLINEINFO (DocID, AprMemberSN, AprType, ");
            strSQL.append("AprState, AprMemberID, AprMemberIsDeptYN, AprMemberName,  AprMemberName2, ");
            strSQL.append("AprMemberJobTitle,  AprMemberJobTitle2, AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, ");
            strSQL.append("AprMemberLDAPPath, ReceivedDate, ProcessDate, ReasonDoNotApprov, ");
            strSQL.append("isProposerYN, isBriefUserYN, TENANT_ID) VALUES ('" + gongRamDocID + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(22).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(23).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent()) + "', '");  // aprmemberID
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(10).getTextContent()) + "', N'");  //name="AprmemberIsDeptYN"
            // AprMemberName2
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(16).getTextContent()) + "', N'"); //name="PMemberName"
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(17).getTextContent()) + "', N'"); //name="SMemberName"
            //AprMemberJobTitle
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(20).getTextContent()) + "', N'"); //name="PMemberJobTitle"
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(21).getTextContent()) + "', N'"); //name="SMemberJobTitle"
            //AprMemberDeptID
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent()) + "', N'");
            //AprMemberDeptName
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(18).getTextContent()) + "', '"); //name="SMemberJobTitle"
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(19).getTextContent()) + "', N'"); //name="SMemberJobTitle"

            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent()) + "', "); 
            strSQL.append(recDate + ", " + processDate + ", N'");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(12).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(13).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(14).getTextContent()) + "'," + tenantID +") ;\n");

            strSQL.append("INSERT INTO TBL_EXPAPRLINE (DocID, AprMemberSN, OrgUserID, ");
            strSQL.append("ProxyUserID, proxyusername, proxyusername2, proxyuserjobtitle, proxyuserjobtitle2, proxyuserdeptid, ");
            strSQL.append("proxyuserdeptname, proxyuserdeptname2, TENANT_ID) VALUES ('" + gongRamDocID.trim() + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent()) + "', '");
            strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent()));
            strSQL.append("', '', '', '', '', '', '', '','',"+ tenantID +");\n");
		}
		String rtnVal = "";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map);
			
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		if (gongRamActivate(gongRamDocID, companyID, lang, tenantID)) {
			rtnVal = "<RESULT>TRUE</RESULT>";
		} else {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String makeTmp2IngDocInfo(String userID, String sn, String companyID, String lang, int tenantID) throws Exception {
 		String docID = getNewID(companyID, tenantID);
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", makeRightField(userID.trim()));
		map.put("v_PDOCID", docID);
		map.put("v_PSN", sn);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		try {
			//수신정보
			ezApprovalGDAO.aprMakeTmp2Ing(map);
			//의견 정보
			ezApprovalGDAO.aprMakeTmp2Ing2(map);
			//문서첨부 정보
			ezApprovalGDAO.aprMakeTmp2Ing3(map);
			//첨부 정보
			ezApprovalGDAO.aprMakeTmp2Ing4(map);
			//결재선 확장 정보
			ezApprovalGDAO.aprMakeTmp2Ing5(map);
			// 결재선  정보
			ezApprovalGDAO.aprMakeTmp2Ing6(map);
			//문서 확장 정보
			ezApprovalGDAO.aprMakeTmp2Ing7(map);
			// 문서 정보
			ezApprovalGDAO.aprMakeTmp2Ing8(map);

			
			rtnVal = "<RESULT>" + docID + "</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String checkAprLine(String docID, String mode, String userID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		
		String result = "";
		int tempCount = ezApprovalGDAO.checkAprLine(map);
		
		if (tempCount > 0) {
			result = "<RESULT>TRUE</RESULT>";
		} else {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String getSusinSN(String docID, String companyID, int tenantID) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_TENANTID", tenantID);
		map.put("v_DOCID", docID);
		
		String rtnVal = ezApprovalGDAO.getSusinSN(map);
		
		return "<DATA>" + rtnVal + "</DATA>";
	}

	@Override
	public String getSecurityType(String selected, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", commonUtil.getMultiData(lang, tenantID));
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLeftVO> apprGLeftVOlist = ezApprovalGDAO.getSecurityType(map); 
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLeftVOlist.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLeftVOlist.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < dlength; k++) {
			String[] colOption = docXML.getElementsByTagName("NAME").item(k).getTextContent().split(";");
			
			if (colOption[2].equals(selected)) {
				rtnXML.append("<OPTION value=" + colOption[2] + " selected>" + colOption[1] + "</OPTION>");
			} else {
				rtnXML.append("<OPTION value=" + colOption[2] + ">" + colOption[1] + "</OPTION>");
			}
		}
		
		return rtnXML.toString();
	}

	@Override
	public String getAprType(String companyID, String lang, int tenantID) throws Exception {
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLeftVO> apprGLeftVOlist = ezApprovalGDAO.getAprType(map); 
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLeftVOlist.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLeftVOlist.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		rtnXML.append("<APRTYPES>");
		rtnXML.append("<USERTYPES>");

		for (int k = 0; k < dlength; k++) {
            if (!docXML.getElementsByTagName("CODE2").item(k).getTextContent().trim().equals(staATBuSeuSoonChaHyubJo) && !docXML.getElementsByTagName("CODE2").item(k).getTextContent().trim().equals(staATBuSeuByungRyulHyubJo)) {
                rtnXML.append("<APRTYPE><CODE>" + commonUtil.cleanValue(docXML.getElementsByTagName("CODE2").item(k).getTextContent().trim()));
                rtnXML.append("</CODE><NAME>" + commonUtil.cleanValue(docXML.getElementsByTagName("NAME").item(k).getTextContent()));
                rtnXML.append("</NAME></APRTYPE>");
            }
		}

		rtnXML.append("</USERTYPES>");
		rtnXML.append("<DEPTTYPES>");
		
        for (int k = 0; k < dlength; k++) {
            if (docXML.getElementsByTagName("CODE2").item(k).getTextContent().trim().equals(staATBuSeuSoonChaHyubJo) || docXML.getElementsByTagName("CODE2").item(k).getTextContent().trim().equals(staATBuSeuByungRyulHyubJo)) {
                rtnXML.append("<APRTYPE><CODE>" + commonUtil.cleanValue(docXML.getElementsByTagName("CODE2").item(k).getTextContent().trim()));
                rtnXML.append("</CODE><NAME>" + commonUtil.cleanValue(docXML.getElementsByTagName("NAME").item(k).getTextContent()));
                rtnXML.append("</NAME></APRTYPE>");
            }
		}

		rtnXML.append("</DEPTTYPES>");
		rtnXML.append("</APRTYPES>");
		
        return rtnXML.toString();
	}

	@Override
	public String getAprLineInfo(String docID, String userID, String formID, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String listString = getListHeader("013", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getAprLineInfoDB(docID, "1", userID, formID, companyID, tenantID);
		Document docXML = commonUtil.convertStringToDocument(docList);

		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		if (dlength <= 0) {
			String isLastAprLine = getCode2Name("A44", "001", companyID, lang, tenantID);
			LOGGER.debug("getCode2Name ended.");

			if (isLastAprLine.equals("1")) {
				docList = getAprLineInfoDB(docID, "2", userID, formID, companyID, tenantID);
				docXML = commonUtil.convertStringToDocument(docList);
				dlength = docXML.getElementsByTagName("ROW").getLength();
			}
		}
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (!commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					if (fieldName.equals("APRMEMBERNAME") || fieldName.equals("APRMEMBERJOBTITLE") || fieldName.equals("APRMEMBERDEPTNAME")
							|| fieldName.equals("PROXYUSERNAME") || fieldName.equals("PROXYUSERJOBTITLE") || fieldName.equals("PROXYUSERDEPTNAME")) {
						fieldName = fieldName + "2";
					}
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(convertDate(docXML.getElementsByTagName("PROCESSDATE").item(k).getTextContent())) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(convertDate(docXML.getElementsByTagName("RECEIVEDDATE").item(k).getTextContent())) + "</DATA2>");
					resultXML.append("<DATA3>" + docID + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + docXML.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent() + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("REASONDONOTAPPROV").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + docXML.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent() + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("APRTYPE").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("APRSTATE").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent()) + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent()) + "</DATA15>");
					resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA16>");
					resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA17>");
					resultXML.append("<DATA18>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA18>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getTempList(String userID, String formID, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_FORMID", formID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getTempList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
			 returnValue.append("<ROW>");
             returnValue.append("<CELL>");
             returnValue.append("<VALUE> " + commonUtil.cleanValue(docXML.getElementsByTagName("APRTEMPLETNAME").item(k).getTextContent()) + "</VALUE>");
             returnValue.append("<DATA1>" + docXML.getElementsByTagName("APRLINESN").item(k).getTextContent() + "</DATA1>");
             returnValue.append("<DATA2>" + commonUtil.cleanValue(docXML.getElementsByTagName("APRTEMPLETNAME").item(k).getTextContent()) + "</DATA2>");
             returnValue.append("</CELL>");
             returnValue.append("</ROW>");
		}
		
		return returnValue.toString();
	}

	//수정하기
	@Override
	public String updateLineInfo(String ret, String companyID, String lang, LoginVO userInfo) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		Document docXML = commonUtil.convertStringToDocument(ret);
		NodeList nList = docXML.getElementsByTagName("ROW");
		String strDocID = nList.item(0).getChildNodes().item(8).getTextContent();
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", strDocID);
		map.put("v_TENANTID", userInfo.getTenantId());
		
		try {
			ezApprovalGDAO.deleteExApprLine(map);
			ezApprovalGDAO.deleteApprLineInfo(map);
		} catch(Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return rtnVal = "<RESULT>FALSE</RESULT>";
		}

		String recDate = "";
		String procDate = "";
		
		for (int k = 0; k < nList.getLength(); k++) {
			if (nList.item(k).getChildNodes().item(7).getTextContent().trim().equals("")) {
				recDate = "NULL";
			} else {
				if (nList.item(k).getChildNodes().item(7).getTextContent().replace(messageSource.getMessage("ezApprovalG.t971", userInfo.getLocale()), "").trim() != nList.item(k).getChildNodes().item(7).getTextContent().trim()) {
					recDate = "'" + nList.item(k).getChildNodes().item(7).getTextContent().replace(messageSource.getMessage("ezApprovalG.t971", userInfo.getLocale()), "").trim() + "AM'";
				} else if (nList.item(k).getChildNodes().item(7).getTextContent().replace(messageSource.getMessage("ezApprovalG.t972", userInfo.getLocale()), "").trim() != nList.item(k).getChildNodes().item(7).getTextContent().trim()) {
					recDate = "'" + nList.item(k).getChildNodes().item(7).getTextContent().replace(messageSource.getMessage("ezApprovalG.t972", userInfo.getLocale()), "").trim() + "PM'";
				} else {
					recDate = "'" + nList.item(k).getChildNodes().item(7).getTextContent().trim() + "'";
				}
			}
			
			if (nList.item(k).getChildNodes().item(6).getTextContent().trim().equals("")) {
				procDate = "NULL";
			} else {
				if (nList.item(k).getChildNodes().item(6).getTextContent().replace(messageSource.getMessage("ezApprovalG.t971", userInfo.getLocale()), "").trim() != nList.item(k).getChildNodes().item(6).getTextContent().trim()) {
					procDate = "'" + nList.item(k).getChildNodes().item(6).getTextContent().replace(messageSource.getMessage("ezApprovalG.t971", userInfo.getLocale()), "").trim() + "AM'";
				} else if (nList.item(k).getChildNodes().item(6).getTextContent().replace(messageSource.getMessage("ezApprovalG.t972", userInfo.getLocale()), "").trim() != nList.item(k).getChildNodes().item(6).getTextContent().trim()) {
					procDate = "'" + nList.item(k).getChildNodes().item(6).getTextContent().replace(messageSource.getMessage("ezApprovalG.t972", userInfo.getLocale()), "").trim() + "PM'";
				} else {
					procDate = "'" + nList.item(k).getChildNodes().item(6).getTextContent().trim() + "'";
				}
			}
			
			try{
				
				map.put("v_DOCID", strDocID);
				map.put("v_APRMEMSN", nList.item(k).getChildNodes().item(0).getTextContent());
				map.put("v_APRTYPE", nList.item(k).getChildNodes().item(16).getTextContent()); //AprType
				map.put("v_APRSTATE", nList.item(k).getChildNodes().item(17).getTextContent()); //AprState
				map.put("v_APRMEMID", makeRightField(nList.item(k).getChildNodes().item(9).getTextContent()));
				map.put("v_APRMEMDEPTYN", makeRightField(nList.item(k).getChildNodes().item(10).getTextContent()));//AprMemberIsDeptYN
				map.put("v_APRMEMNM", makeRightField(nList.item(k).getChildNodes().item(18).getTextContent()));//AprMemberName
				map.put("v_APRMEMNM2", makeRightField(nList.item(k).getChildNodes().item(19).getTextContent()));//AprMemberName2
				map.put("v_APRMEMJOBTITLE", makeRightField(nList.item(k).getChildNodes().item(22).getTextContent()));//AprMemberJobTitle
				map.put("v_APRMEMJOBTITLE2", makeRightField(nList.item(k).getChildNodes().item(23).getTextContent()));//AprMemberJobTitle2
				map.put("v_APRMEMBERDEPTID", makeRightField(nList.item(k).getChildNodes().item(11).getTextContent()));
				map.put("v_APRMEMBERDEPTNAME", makeRightField(nList.item(k).getChildNodes().item(20).getTextContent()));
				map.put("v_APRMEMBERDEPTNAME2", makeRightField(nList.item(k).getChildNodes().item(21).getTextContent()));
				map.put("v_APRMEMBERLDAPPATH", makeRightField(nList.item(k).getChildNodes().item(15).getTextContent()));
				map.put("v_RECEIVEDDATE", recDate);
				map.put("v_PROCESSDATE", procDate);
				map.put("v_REASONDONOTAPPROV", makeRightField(nList.item(k).getChildNodes().item(12).getTextContent()));
				map.put("v_ISPROPOSERYN", makeRightField(nList.item(k).getChildNodes().item(13).getTextContent()));
				map.put("v_ISBRIEFUSERYN", makeRightField(nList.item(k).getChildNodes().item(14).getTextContent()));

			
				ezApprovalGDAO.insertApprLine(map);
				map.put("v_ORGUSERID", makeRightField(nList.item(k).getChildNodes().item(9).getTextContent()));

				ezApprovalGDAO.insertExApprLine(map);
			} catch(Exception e) {
				System.out.println();
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}
		
		rtnVal = "<RESULT>TRUE</RESULT>";
		LOGGER.debug("updateLineInfo ended");
		return rtnVal;
	}

	@Override
	public String updateReceiptInfo(String ret2, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		Document docXML = commonUtil.convertStringToDocument(ret2);
		String susinGroupIcon = getCode2Name("A53", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String susinGroupUseFlag = getCode2Name("A53", "002", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");
		
		NodeList rowNode = docXML.getElementsByTagName("ROW");
		
		String strDocID = rowNode.item(0).getChildNodes().item(2).getTextContent();
		String rtnVal = deleteReceiptInfo(strDocID, companyID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			String receiptPointID = "";
			int j = 1;
			
			for (int k = rowNode.getLength() - 1; k >= 0; k--) {
				receiptPointID = rowNode.item(k).getChildNodes().item(3).getTextContent();
				
				if (!receiptPointID.substring(0, susinGroupIcon.length()).equals(susinGroupIcon) || !susinGroupUseFlag.equals("Y")) {
					map.put("v_DOCID", strDocID);
					map.put("v_ReceiptPointID", rowNode.item(k).getChildNodes().item(3).getTextContent());
					map.put("v_ReceiptPointName", makeRightField(rowNode.item(k).getChildNodes().item(11).getTextContent()));
					map.put("v_ReceiptPointName2", makeRightField(rowNode.item(k).getChildNodes().item(12).getTextContent()));
					map.put("v_ExtReceptYN", makeRightField(rowNode.item(k).getChildNodes().item(4).getTextContent()));
					map.put("v_ProcessYN", makeRightField(rowNode.item(k).getChildNodes().item(5).getTextContent()));
					map.put("v_ProcessSN", "1");
					map.put("v_CanEditYN", makeRightField(rowNode.item(k).getChildNodes().item(6).getTextContent()));
					map.put("v_ExtReceptEmail", makeRightField(rowNode.item(k).getChildNodes().item(7).getTextContent()));
					map.put("v_ReceiptMemberID", makeRightField(rowNode.item(k).getChildNodes().item(8).getTextContent()));
					map.put("v_ReceiptMemberName", makeRightField(rowNode.item(k).getChildNodes().item(9).getTextContent()));
					map.put("v_ReceiptMemberName2", makeRightField(rowNode.item(k).getChildNodes().item(9).getTextContent()));
					map.put("v_ProcessDate", "''");
					map.put("v_ReceiptMemberJobTitle", makeRightField(rowNode.item(k).getChildNodes().item(13).getTextContent()));
					map.put("v_ReceiptMemberJobTitle2", makeRightField(rowNode.item(k).getChildNodes().item(14).getTextContent()));
					map.put("v_DeptMemberSN", j);
					map.put("v_TENANTID", tenantID);
					
					try {
						ezApprovalGDAO.insertReciptInfo(map);
						rtnVal = "<RESULT>TRUE</RESULT>";
					} catch (Exception e) {
						TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						System.out.println(e.getMessage());
						rtnVal = "<RESULT>FALSE</RESULT>";
					}
					
					j += 1;
				} else {
					map.put("v_MAINID", receiptPointID.substring(susinGroupIcon.length()));
					map.put("v_TENANTID", tenantID);
					
					List<ApprGAdminReceiveVO> apprGAdminReceiveVOList = ezApprovalGDAO.getReceiptGroupInfo(map);
					
					StringBuffer sb = new StringBuffer();
			        sb.append("<DATA>");
			        
			        for (int i = 0; i < apprGAdminReceiveVOList.size(); i++) {
						sb.append(commonUtil.getQueryResult(apprGAdminReceiveVOList.get(i)));
					}
					sb.append("</DATA>");
					
					Document receiptGroupXML = commonUtil.convertStringToDocument(sb.toString());
					int dlength = receiptGroupXML.getElementsByTagName("ROW").getLength();
					
					for (int p = 0; p < dlength; p++) {
						
						map.put("v_DOCID", strDocID);
						map.put("v_ReceiptPointID", receiptGroupXML.getElementsByTagName("DEPTID").item(p).getTextContent());
						map.put("v_ReceiptPointName", makeRightField(receiptGroupXML.getElementsByTagName("DEPTNAME").item(p).getTextContent()));
						map.put("v_ReceiptPointName2", makeRightField(receiptGroupXML.getElementsByTagName("DEPTNAME2").item(p).getTextContent()));
						map.put("v_ExtReceptYN", "N");
						map.put("v_ProcessYN", "N");
						map.put("v_ProcessSN", "1");
						map.put("v_CanEditYN", "N");
						map.put("v_ExtReceptEmail", makeRightField(receiptGroupXML.getElementsByTagName("COMPANYID").item(p).getTextContent()));
						map.put("v_ReceiptMemberID", "");
						map.put("v_ReceiptMemberName", "");
						map.put("v_ReceiptMemberName2", "");
						map.put("v_ProcessDate", "NULL");
						map.put("v_ReceiptMemberJobTitle", "");
						map.put("v_ReceiptMemberJobTitle", "");
						map.put("v_DeptMemberSN", j);
						map.put("v_TENANTID", tenantID);
						
						try {
							
							ezApprovalGDAO.insertReciptInfo(map);
							rtnVal = "<RESULT>TRUE</RESULT>";
						} catch (Exception e) {
							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
							System.out.println(e.getMessage());
							rtnVal = "<RESULT>FALSE</RESULT>";
						}

						j += 1;
					}
				}
			}
		}
		
		return rtnVal;
	}

	@Override
	public String getLineTempletInfo(String formID, String userID, String companyID, int tenantID) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getLineTempletInfo(map);
		rtnVal.append("<APRTEMP>");
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < dlength; k++) {
			rtnVal.append("<DATA>");
			rtnVal.append("<COLUMN>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("APRTEMPLETNAME").item(k).getTextContent())) + "</COLUMN>");
			rtnVal.append("<COLUMN>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("APRLINESN").item(k).getTextContent())) + "</COLUMN>");
			rtnVal.append("</DATA>");
		}
		
		  rtnVal.append("</APRTEMP>");
        
		return rtnVal.toString();
	}

	@Override
	public String getLineTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang, int tenantID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("100", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		if (aprSN.trim().equals("")) {
			aprSN = "0";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_APRLINESN", aprSN);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getLineTempletDetailInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("APRMEMBERSN").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("USERID").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("APRLINESN").item(k).getTextContent()) + "</DATA3>");
			resultXML.append("<DATA4>" + getCode2Name("A04", docXML.getElementsByTagName("APRSTATE").item(k).getTextContent(), companyID, lang, tenantID) + "</DATA4>");
			LOGGER.debug("getCode2Name ended.");
			resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA5>");
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA7>");
			resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA8>");
			resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("MEMBERDEPTNAME").item(k).getTextContent()) + "</DATA9>");
			resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA10>");
			resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("MEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA11>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(getCode2Name("A03", docXML.getElementsByTagName("APRTYPE").item(k).getTextContent(), companyID, lang, tenantID)) + "</VALUE>");
			LOGGER.debug("getCode2Name ended.");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getFormInfoDetail(String formID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGFormVO> apprGFormVOList = ezApprovalGDAO.getFormInfoDetail(map);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGFormVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGFormVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getFormRecvApr(String docID, String formID, String userID, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
        StringBuilder rtnXML = new StringBuilder();
        String subSQL = "";
        String rtnVal = "";
        
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("v_DOCID", docID.trim());
    	map.put("v_TENANTID", tenantID);
    	
    	try {
    		ezApprovalGDAO.deleteFormRecvTB(map);
    	} catch(Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    	}
    	
        String docList = getFormRecvAprDB(formID.trim(), userID.trim(), "1", companyID, tenantID);
        Document docXML = commonUtil.convertStringToDocument(docList);
        Document deptXML = null;

        int dlength = docXML.getElementsByTagName("ROW").getLength();
        String extYN = "";
        
        rtnXML.append("<ROWS>");
        
        for (int k = 0; k < dlength; k++) {
        	subSQL = ezOrganService.getPropertyList(docXML.getElementsByTagName("DEPTID").item(k).getTextContent().trim(), "displayName;extensionAttribute2", commonUtil.getPrimaryData(lang, tenantID),tenantID);
        	
        	deptXML = commonUtil.convertStringToDocument(subSQL);
        	
        	if (deptXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().toLowerCase().equals(companyID.toLowerCase())) {
        		extYN = "N";
        	} else {
        		extYN = "Y";
        	}
        	
            map.put("v_DOCID", docID.trim());
            map.put("v_DEPTID", docXML.getElementsByTagName("DEPTID").item(k).getTextContent().trim());
            map.put("v_RECNM1", makeRightField(deptXML.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent()));
            map.put("v_RECNM2", makeRightField(deptXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent()));
            map.put("v_ExtRecYN", extYN);
            map.put("v_ProcessYN", "N");
            map.put("v_ProcessSN", "1");
            map.put("v_CanEditYN", "N");
            map.put("v_EXTATTR2", deptXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent());
            map.put("v_RECMEMID", "");
            map.put("v_RECMEMNM", "");
            map.put("v_RECMEMNM2", "");
            map.put("v_RECMEMJOBTITLE", "");
            map.put("v_RECMEMJOBTITLE2", "");
            map.put("v_DEPTSN", docXML.getElementsByTagName("DEPTSN").item(k).getTextContent().trim());
        	
            try {
        		ezApprovalGDAO.insertFormRecvTB(map);
        	} catch(Exception e) {
        		System.out.println(e.getMessage());
    			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    			rtnVal = "<ROWS/>";
        	}

            rtnXML.append("<ROW><NAME>" + commonUtil.cleanValue(deptXML.getElementsByTagName("DISPLAYNAME" + commonUtil.getMultiData(lang, tenantID)).item(0).getTextContent()));
            rtnXML.append("</NAME><DEPTID>" + docXML.getElementsByTagName("DEPTID").item(k).getTextContent().trim());
            rtnXML.append("</DEPTID><DEPTNAME>" + docID + "</DEPTNAME><EXTRECEPTYN>" + extYN);
			rtnXML.append("</EXTRECEPTYN><PROCESSYN>N</PROCESSYN><CANEDITYN>N</CANEDITYN><EMAIL>");
            rtnXML.append(deptXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "</EMAIL>");
            rtnXML.append("<DISPLAYNAME>" + commonUtil.cleanValue(deptXML.getElementsByTagName("DISPLAYNAME" + commonUtil.getMultiData(lang, tenantID)).item(0).getTextContent()) + "</DISPLAYNAME>");
            rtnXML.append("<JOBTITLE></JOBTITLE><JOBTITLE2></JOBTITLE2></ROW>");
        }
        
        if (rtnXML.toString().trim().equals("<ROWS>") && !userID.trim().equals("")) {
        	String isUse = getCode2Name("A44", "002", companyID, lang, tenantID);
			LOGGER.debug("getCode2Name ended.");

        	if (isUse.equals("1")) {
        		docList = getFormRecvAprDB(formID, userID, "2", companyID, tenantID);
        		docXML = commonUtil.convertStringToDocument(docList);
        		dlength = docXML.getElementsByTagName("ROW").getLength();
        		
        		for (int p = 0; p < dlength; p++) {
                    map.put("v_DOCID", docID.trim());
                    map.put("v_DEPTID", docXML.getElementsByTagName("RECEIPTPOINTID").item(p).getTextContent());
                    map.put("v_RECNM1", makeRightField(docXML.getElementsByTagName("RECEIPTPOINTNAME").item(p).getTextContent()));
                    map.put("v_RECNM2", makeRightField(docXML.getElementsByTagName("RECEIPTPOINTNAME2").item(p).getTextContent()));
                    map.put("v_ExtRecYN", makeRightField(docXML.getElementsByTagName("EXTRECEPTYN").item(p).getTextContent()));
                    map.put("v_ProcessYN", "N");
                    map.put("v_ProcessSN", makeRightField(docXML.getElementsByTagName("PROCESSSN").item(p).getTextContent()));
                    map.put("v_CanEditYN", makeRightField(docXML.getElementsByTagName("CANEDITYN").item(p).getTextContent()));
                    map.put("v_EXTATTR2", makeRightField(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(p).getTextContent()));
                    map.put("v_RECMEMID", makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERID").item(p).getTextContent()));
                    map.put("v_RECMEMNM",  makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(p).getTextContent()));
                    map.put("v_RECMEMNM2", makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERNAME2").item(p).getTextContent()));
                    map.put("v_RECMEMJOBTITLE", makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(p).getTextContent()));
                    map.put("v_RECMEMJOBTITLE2", makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(p).getTextContent()));
                    map.put("v_DEPTSN", makeRightField(docXML.getElementsByTagName("DEPTMEMBERSN").item(p).getTextContent()));
                	
                    try {
                		ezApprovalGDAO.insertFormRecvTB(map);
                	} catch(Exception e) {
                		System.out.println(e.getMessage());
            			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
            			rtnVal = "<ROWS/>";
                	}
                    
                    rtnXML.append("<ROW><NAME>" + commonUtil.cleanValue(docXML.getElementsByTagName("RECEIPTPOINTNAME" + commonUtil.getMultiData(lang, tenantID)).item(p).getTextContent()));
                    rtnXML.append("</NAME><DEPTID>" + docXML.getElementsByTagName("RECEIPTPOINTID").item(p).getTextContent().trim());
                    rtnXML.append("</DEPTID><DEPTNAME>" + docID + "</DEPTNAME><EXTRECEPTYN>" + docXML.getElementsByTagName("EXTRECEPTYN").item(p).getTextContent().trim());
					rtnXML.append("</EXTRECEPTYN><PROCESSYN>N</PROCESSYN><CANEDITYN>N</CANEDITYN><EMAIL>");
					rtnXML.append(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(p).getTextContent().trim() + "</EMAIL>");
//                    rtnXML.append("</DISPLAYNAME>" + commonUtil.cleanValue(deptXML.getElementsByTagName("DISPLAYNAME" + commonUtil.getMultiData(lang)).item(0).getTextContent()) + "</DISPLAYNAME><JOBTITLE>");
                    rtnXML.append("</DISPLAYNAME>" + "" + "</DISPLAYNAME><JOBTITLE>");
                    rtnXML.append(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(p).getTextContent().trim() + "</JOBTITLE><JOBTITLE2>");
                    rtnXML.append(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(p).getTextContent().trim() + "</JOBTITLE2></ROW>");
        		}
        	}
        }
        rtnXML.append("</ROWS>");
        
        rtnVal = rtnXML.toString();
		return rtnVal;
	}

	@Override
	public String createNewDoc(String formID, String companyID, int tenantID) throws Exception {
		String tmpDocID = getNewID(companyID,tenantID);
		String returnVal = "";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", tmpDocID.trim());
		map.put("v_FORMID", formID);
		map.put("v_COMPANYID", companyID);
		map.put("v_TENANTID", tenantID);
		
		try {
			ezApprovalGDAO.createNewDoc(map);
			ezApprovalGDAO.createNewDoc2(map);
			returnVal = tmpDocID.trim();
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			returnVal = "";
		}
		
		return returnVal;
	}

	@Override
	public String deleteDocInfo(String docID, String mode, String companyID, int tenantID) throws Exception {
		String strSQL = "";
		String rtnVal = "";
	//마리아 디비할때 프로시저 제거	
		Map<String, Object> map	= new HashMap<>();
		map.put("v_DocID", docID);
		map.put("v_TENANTID", tenantID);
		map.put("v_MODE", mode);
		
		String delFlag = ezApprovalGDAO.aprDeleteDocInfoFlag(map);

		if (delFlag.equals("Y") || mode.toUpperCase().equals("MUST")) {
			try {
				ezApprovalGDAO.aprDeleteDocInfo(map);
				rtnVal="TRUE";
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				rtnVal = "FALSE";
		}
		} 
//		strSQL = "APRDeleteDocInfo('" + docID + "', '" + mode.toUpperCase() + "');\n";
		
//		if (!mode.toUpperCase().equals("QUERY")) {
//			Map<String, Object> map = new HashMap<String, Object>();
//			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
//			map.put("companyID", companyID);
//			try {s
//				ezApprovalGDAO.transactionSQL(map);
//				rtnVal = "<RESULT>TRUE</RESULT>";
//			} catch (Exception e) {
//				rtnVal = "<RESULT>FALSE</RESULT>";
//			}
//		} else {
//			rtnVal = strSQL;
//		}
		return rtnVal;
	}

	@Override
	public String updateLineTempletDetailInfo(Document xmlDom, String companyID, String lang, int tenantID) throws Exception {
		StringBuffer strSQL = new StringBuffer();
		String rtnVal = "<RESULT>TRUE</RESULT>";
		
		NodeList docNode = xmlDom.getElementsByTagName("APRTEMP");
		NodeList rowNode = xmlDom.getElementsByTagName("ROW");
		String strUserID = docNode.item(0).getChildNodes().item(0).getTextContent();
		String strFormID = docNode.item(0).getChildNodes().item(1).getTextContent();
		String strAprlineSN = docNode.item(0).getChildNodes().item(2).getTextContent();
		String strAprTempletName = docNode.item(0).getChildNodes().item(3).getTextContent();
		
		if (strAprlineSN.trim().equals("")) {
			strAprlineSN = String.valueOf(getLineTempletSN(strFormID, strUserID, companyID, tenantID));
		} else {
			rtnVal = deleteLineTempletDetailInfo(strFormID, strUserID, strAprlineSN, companyID, tenantID);
		}
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			
			Map<String, Object> map	= new HashMap<>();
			map.put("v_UserID", strUserID);
			map.put("v_FormID", strFormID);
			map.put("v_AprLineSN", strAprlineSN);
			map.put("v_AprTempletName", makeRightField(strAprTempletName));
			map.put("v_TENANTID", tenantID);
			
			try {
				ezApprovalGDAO.insertLinTemplet(map);
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return rtnVal = "<RESULT>FALSE</RESULT>";
			}

			int i = 0;

			for (i = 0; i < rowNode.getLength(); i++) {
				
				map.put("v_AprMemberSN", makeRightField(rowNode.item(i).getChildNodes().item(0).getTextContent()));
				map.put("v_AprType", getName2Code("A03", rowNode.item(i).getChildNodes().item(4).getTextContent(), companyID, lang, tenantID).trim());
				map.put("v_AprState", getName2Code("A04", rowNode.item(i).getChildNodes().item(5).getTextContent(), companyID, lang, tenantID).trim());
				map.put("v_AprMemberID", makeRightField(rowNode.item(i).getChildNodes().item(9).getTextContent().trim()));
				map.put("v_AprMemberIsDeptYN", makeRightField(rowNode.item(i).getChildNodes().item(10).getTextContent().trim()));
				map.put("v_AprMemberName", makeRightField(rowNode.item(i).getChildNodes().item(18).getTextContent().trim()));
				map.put("v_AprMemberName2", makeRightField(rowNode.item(i).getChildNodes().item(19).getTextContent().trim()));
				map.put("v_AprMemberJobTitle", makeRightField(rowNode.item(i).getChildNodes().item(22).getTextContent().trim()));
				map.put("v_AprMemberJobTitle2", makeRightField(rowNode.item(i).getChildNodes().item(23).getTextContent().trim()));
				map.put("v_AprMemberDeptID", makeRightField(rowNode.item(i).getChildNodes().item(11).getTextContent().trim()));
				map.put("v_MemberDeptName", makeRightField(rowNode.item(i).getChildNodes().item(20).getTextContent().trim()));
				map.put("v_MemberDeptName2", makeRightField(rowNode.item(i).getChildNodes().item(21).getTextContent().trim()));

				try {
					ezApprovalGDAO.insertLinTempletDetail(map);
					rtnVal = "<RESULT>TRUE</RESULT>";
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					System.out.println(e.getMessage());
					return rtnVal = "<RESULT>FALSE</RESULT>";
				}
			}
		}
		return rtnVal;
	}

	@Override
	public String deleteLineTempletDetailInfo(String strFormID, String strUserID, String strAprlineSN, String companyID, int tenantID) throws Exception{
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", strFormID);
		map.put("v_USERID", strUserID);
		map.put("v_TENANTID", tenantID);
		map.put("v_APRLINESN", strAprlineSN);
		
		try {
			ezApprovalGDAO.deleteLineTempletDetailInfo(map);
			ezApprovalGDAO.deleteLineTempletDetailInfo2(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String addToAprLine(String userID, String formID, String aprSN, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		listString = getListHeader("013", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = addToAprLineDB(formID, userID, aprSN, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("APRMEMBERNAME") || fieldName.equals("APRMEMBERJOBTITLE") || fieldName.equals("APRMEMBERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(convertDate(docXML.getElementsByTagName("PROCESSDATE").item(k).getTextContent())) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(convertDate(docXML.getElementsByTagName("RECEIVEDDATE").item(k).getTextContent())) + "</DATA2>");
					resultXML.append("<DATA3>" + "" + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + docXML.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent() + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("REASONDONOTAPPROV").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + docXML.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent() + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("APRTYPE").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("APRSTATE").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent()) + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent()) + "</DATA15>");
					resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA16>");
					resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA17>");
					resultXML.append("<DATA18>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA18>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getReceiptTempletInfo(String formID, String userID, String companyID, int tenantID) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERID", userID);
		
		List<ApprGDeptTempletVO> apprGDeptTempletVOList = ezApprovalGDAO.getReceiptTempletInfo(map);
		rtnVal.append("<APRTEMP>");
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDeptTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDeptTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < dlength; k++)
		{
			rtnVal.append("<DATA>");
			rtnVal.append("<COLUMN>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("APRDEPTTEMPLETNAME").item(k).getTextContent())) + "</COLUMN>");
			rtnVal.append("<COLUMN>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("APRDEPTSN").item(k).getTextContent())) + "</COLUMN>");
			rtnVal.append("</DATA>");
		}

		rtnVal.append("</APRTEMP>");
		
		return rtnVal.toString();
	}

	@Override
	public String getReceiptTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang, int tenantID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("105", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		if (aprSN.trim().equals("")) {
			aprSN = "0";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_APRDEPTSN", aprSN);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGDeptTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getReceiptTempletDetailInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("USERID").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA3>");
			resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("APRDEPTSN").item(k).getTextContent()) + "</DATA4>");
			resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("APRDEPTMEMBERSN").item(k).getTextContent()) + "</DATA5>");
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getTempList(String companyID, String lang, int tenantID) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_MODE", "GROUP");
		map.put("v_TENANTID", tenantID);
		map.put("v_MAINID", "1");
		
		List<ApprGAdminReceiveVO> adminReceiveVOList = ezApprovalGDAO.getTempListDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < adminReceiveVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(adminReceiveVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < dlength; k++) {
			
            returnValue.append("<ROW>");
            returnValue.append("<CELL>");
            returnValue.append("<VALUE> " + commonUtil.cleanValue(docXML.getElementsByTagName("MAINNAME").item(k).getTextContent()) + "</VALUE>");
            returnValue.append("<DATA1>" + docXML.getElementsByTagName("MAINID").item(k).getTextContent() + "</DATA1>");
            returnValue.append("<DATA2>" + commonUtil.cleanValue(docXML.getElementsByTagName("MAINNAME").item(k).getTextContent()) + "</DATA2>");
            returnValue.append("</CELL>");
            returnValue.append("</ROW>");
        }
		
		return returnValue.toString();
	}

	@Override
	public String getListXML(String groupID, String lang, String companyID, int tenantID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		listString = getListHeader("023", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", "ITEM");
		map.put("v_MAINID", groupID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAdminReceiveVO> adminReceiveVOList = ezApprovalGDAO.getTempListDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < adminReceiveVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(adminReceiveVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + (dlength - k) + "</VALUE>");
			resultXML.append("<DATA1>" + docXML.getElementsByTagName("DEPTID").item(k).getTextContent() + "</DATA1>");
			resultXML.append("<DATA2>" + "" + "</DATA2>");
			resultXML.append("<DATA3>" + "N" + "</DATA3>");
			resultXML.append("<DATA4>" + "N" + "</DATA4>");
			resultXML.append("<DATA5>" + "N" + "</DATA5>");
			resultXML.append("<DATA6>" + commonUtil.cleanValue(docXML.getElementsByTagName("COMPANYID").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("<DATA7>" + "" + "</DATA7>");
			resultXML.append("<DATA8>" + "" + "</DATA8>");
			resultXML.append("<DATA9>" + "" + "</DATA9>");
			resultXML.append("<DATA10>" + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTNAME").item(k).getTextContent()) + "</DATA10>");
			resultXML.append("<DATA11>" + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTNAME2").item(k).getTextContent()) + "</DATA11>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("DEPTNAME").item(k).getTextContent())) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("DEPTNAME2").item(k).getTextContent())) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getTempList2(String groupID, String companyID, String primary, int tenantID) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", "ITEM");
		map.put("v_MAINID", groupID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAdminReceiveVO> adminReceiveVOList = ezApprovalGDAO.getTempListDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < adminReceiveVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(adminReceiveVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < dlength; k++) {
			
            returnValue.append("<ROW>");
            returnValue.append("<CELL>");
            if (primary.equals("1")) {
            	returnValue.append("<VALUE> " + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTNAME").item(k).getTextContent()) + "</VALUE>");
            } else {
            	returnValue.append("<VALUE> " + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTNAME2").item(k).getTextContent()) + "</VALUE>");
            }
            returnValue.append("<DATA1>" + docXML.getElementsByTagName("DEPTID").item(k).getTextContent() + "</DATA1>");
            returnValue.append("<DATA2>" + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTNAME").item(k).getTextContent()) + "</DATA2>");
            returnValue.append("<DATA3>" + commonUtil.cleanValue(docXML.getElementsByTagName("DEPTNAME2").item(k).getTextContent()) + "</DATA3>");
            returnValue.append("<DATA4>" + commonUtil.cleanValue(docXML.getElementsByTagName("COMPANYID").item(k).getTextContent()) + "</DATA4>");
            returnValue.append("<DATA5>" + commonUtil.cleanValue(docXML.getElementsByTagName("SUBID").item(k).getTextContent()) + "</DATA5>");
            returnValue.append("</CELL>");
            returnValue.append("</ROW>");
        }
		
		return returnValue.toString();
	}

	@Override
	public String getTempList3(String userID, String formID, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_FORMID", formID);
		
		List<ApprGDeptTempletVO> apprGDeptTempletVOList = ezApprovalGDAO.getReceiptTempletInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDeptTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDeptTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		for (int k = 0; k < dlength; k++) {
			
            returnValue.append("<ROW>");
            returnValue.append("<CELL>");
            returnValue.append("<VALUE> " + commonUtil.cleanValue(docXML.getElementsByTagName("APRDEPTTEMPLETNAME").item(k).getTextContent()) + "</VALUE>");
            returnValue.append("<DATA1>" + docXML.getElementsByTagName("APRDEPTSN").item(k).getTextContent() + "</DATA1>");
            returnValue.append("<DATA2>" + commonUtil.cleanValue(docXML.getElementsByTagName("APRDEPTTEMPLETNAME").item(k).getTextContent()) + "</DATA2>");
            returnValue.append("</CELL>");
            returnValue.append("</ROW>");
        }
		
		return returnValue.toString();
	}

	@Override
	public String addToAprDept(String userID, String formID, String aprDeptSN, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		listString = getListHeader("023", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_APRDEPTSN", aprDeptSN);
		
		List<ApprGReceiptVO> apprGReceiptVOList = ezApprovalGDAO.addToAprDept(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGReceiptVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGReceiptVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("RECEIPTPOINTNAME") || fieldName.equals("RECEIPTMEMBERNAME") || fieldName.equals("RECEIPTMEMBERJOBTITLE")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("RECEIPTPOINTID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + "" + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("EXTRECEPTYN").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("PROCESSYN").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("CANEDITYN").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERID").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME2").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA13>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String deleteReceiptTempletDetailInfo(String formID, String userID, String aprDeptSN, String companyID, int tenantID) throws Exception {
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_APRDEPTSN", aprDeptSN);
		
		try {
			ezApprovalGDAO.deleteReceiptTempletDetailInfo(map);
			ezApprovalGDAO.deleteReceiptTempletDetailInfo2(map);

			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		return rtnValue;
	}

	@Override
	public String updateReceiptTempletDetailInfo(Document doc, String companyID, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();

		String rtnVal = "<RESULT>TRUE</RESULT>";
		String strUserID = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(0).getTextContent();
		String strFormID = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(1).getTextContent();
		String strAprDeptSN = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(2).getTextContent();
		String strAprDeptTempletName = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(3).getTextContent();
		
		if (strAprDeptSN.trim().equals("")) {
			strAprDeptSN = getReceiptTempletSN(strFormID, strUserID, companyID, tenantID);
		} else {
			rtnVal = deleteReceiptTempletDetailInfo(strFormID, strUserID, strAprDeptSN, companyID, tenantID);
		}
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_UserID", strUserID);
			map.put("v_FormID", strFormID);
			map.put("v_AprDeptSN", strAprDeptSN);
			map.put("v_AprDeptTempletName", makeRightField(strAprDeptTempletName));
			map.put("v_TENANTID", tenantID);
			
			
			try {
				ezApprovalGDAO.insertDeptTemplet(map);
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return rtnVal = "<RESULT>FALSE</RESULT>";
			}

			for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
				
				map.put("v_AprDeptMemberSN", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(0).getTextContent()));
				map.put("v_AprMemberDeptID", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(3).getTextContent()));
				map.put("v_AprMemberDeptName", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getTextContent()));
				map.put("v_AprMemberDeptName2", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(12).getTextContent()));
				map.put("v_ExtReceptYN", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(4).getTextContent()));
				map.put("v_ProcessYN", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(5).getTextContent()));
				map.put("v_CanEditYN", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(6).getTextContent()));
				map.put("v_ExtReceptEmail", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(7).getTextContent()));
				map.put("v_AprMemberID", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(8).getTextContent()));
				map.put("v_AprMemberName", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getTextContent()));
				map.put("v_AprMemberName2", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(12).getTextContent()));
				map.put("v_AprMemberJobTitle", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(13).getTextContent()));
				map.put("v_AprMemberJobTitle2", makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(14).getTextContent()));

				try {
					ezApprovalGDAO.insertDeptTempletDetail(map);
					rtnVal = "<RESULT>TRUE</RESULT>";
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return rtnVal = "<RESULT>FALSE</RESULT>";
				}
			}

		}
		
		return rtnVal;
	}

	@Override
	public String getTaskCategory(String deptCode, String companyID, String type, int tenantID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", deptCode.trim());
		map.put("v_TENANTID", tenantID);
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getTaskCategory(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		resultXML.append("<TASKCATEGORY>");
		
		for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
			resultXML.append("<CATEGORY>");
			resultXML.append("<CODE>" + makeListField(docXML.getElementsByTagName("CATEGORYCODE").item(k).getTextContent()) + "</CODE>");
			resultXML.append("<NAME>" + makeListField(docXML.getElementsByTagName("CNAME").item(k).getTextContent()) + "</NAME>");
			resultXML.append("<NAME2>" + makeListField(docXML.getElementsByTagName("CNAME2").item(k).getTextContent()) + "</NAME2>");
			resultXML.append("</CATEGORY>");
		}
		resultXML.append("</TASKCATEGORY>");
		
		return resultXML.toString();
	}

	@Override
	public String getTaskMiddleCategory(String deptCode, String companyID, String cateCode, int tenantID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", deptCode.trim());
		map.put("v_CATECODE", cateCode.trim());
		map.put("v_TENANTID", tenantID);

		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getTaskMiddleCategory(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		resultXML.append("<TASKMCATEGORY>");
		
		for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
			resultXML.append("<MCATEGORY>");
			resultXML.append("<CODE>" + makeListField(docXML.getElementsByTagName("MCATEGORYCODE").item(k).getTextContent()) + "</CODE>");
			resultXML.append("<NAME>" + makeListField(docXML.getElementsByTagName("MCNAME").item(k).getTextContent()) + "</NAME>");
			resultXML.append("<NAME2>" + makeListField(docXML.getElementsByTagName("MCNAME2").item(k).getTextContent()) + "</NAME2>");
			resultXML.append("</MCATEGORY>");
		}
		resultXML.append("</TASKMCATEGORY>");
		
		return resultXML.toString();
	}

	@Override
	public String getTaskSubCategory(String deptCode, String companyID, String cateCode, String strType, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTCODE", deptCode.trim());
		map.put("v_CATECODE", cateCode.trim());
		map.put("v_TENANTID", tenantID);
		map.put("v_STRLANG", strType.trim());
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getTaskSubCategory(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("101", companyID, strType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SUBCATEGORYCODE").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("SUBCATEGORYCODE").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getTaskInSubCategory(String deptCode, String companyID, String cateCode, String strType, String langType, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_SUBCATECODE", cateCode.trim());
		map.put("v_TENANTID", tenantID);
		map.put("v_DEPTCODE", deptCode.trim());
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getTaskInSubCategory(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String resultXML = makeTaskListXml(docXML, companyID, langType, tenantID);
		
		return resultXML;
	}

	@Override
	public String getSimpleCabinetList(String companyID, String processDeptCode, String productionYear, String taskCode, String flag, String langType, int tenantID) throws Exception{
		String accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, langType, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PDEPTCODE", processDeptCode);
		map.put("v_PYEAR", productionYear);
		map.put("v_PACCOUNTPYEAR", accountYear);
		map.put("v_TASKCODE", taskCode);
		map.put("v_TENANTID", tenantID);
		map.put("v_FLAG", flag);
		
		List<ApprGCabinetVO> apprGCabinetVOList = ezApprovalGDAO.getSimpleCabinetList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGCabinetVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGCabinetVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("095", companyID, langType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent())) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("TITLE2").item(k).getTextContent())) + "</VALUE>");
			}
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("CABINETID").item(k).getTextContent().trim()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(k).getTextContent().trim()) + "</DATA3>");
			resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("OWNERID").item(k).getTextContent().trim()) + "</DATA4>");
			resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent()) + "</DATA5>");
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("TITLE2").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, langType, tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("REGSERIALNO").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("VOLUMENO").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String findTask(String deptCode, String title, String code, String flag, String companyID, String langType, String pageSize, String pageNO, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		
		StringBuffer subQuery = new StringBuffer();
		
		if(deptCode.trim() != null) {
			subQuery.append("(PROCESSDEPTCODE = '"+deptCode.trim()+"' OR TASKCODE LIKE 'ZZ%' OR TASKCODE='99999999')");
		}
		if(!title.trim().equals("")) {
			if(subQuery.length() > 0) {
				subQuery.append("AND ");
			} 
				subQuery.append("TASKNAME"+commonUtil.getMultiData(langType, tenantID)+" LIKE '%"+title.trim()+"%'");
		}
		if(!code.trim().equals("")) {
			if(subQuery.length() > 0) {
				subQuery.append("AND ");
			}
				subQuery.append("TASKCODE = '"+code.trim()+"'");
		}
		if(subQuery.length() > 0 ){
			map.put("v_subQuery", "WHERE " + subQuery.toString());
		}
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.findTask(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String resultXML = "";
		
		if (flag.equals("1")) {
			resultXML = makeTaskFullListXml(docXML, companyID, pageSize, pageNO, langType, tenantID);
		} else if (flag.equals("2")) {
			resultXML = makeTaskListXmlAll(docXML, companyID, langType, tenantID);
		} else {
			resultXML = makeTaskListXml(docXML, companyID, langType, tenantID);
		}
		
		return resultXML;
	}

	@Override
	public String makeTaskFullListXml(Document docXML, String companyID, String pageSize, String pageNO, String langType, int tenantID) throws Exception{
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("098", companyID, langType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML != null ? docXML.getElementsByTagName("ROW").getLength() : 0;
		int startNum = 0;
		int endNum = dlength;
		
		if (Integer.parseInt(pageSize) > 0) {
			startNum = Integer.parseInt(pageSize) * (Integer.parseInt(pageNO) - 1);
			endNum = Integer.parseInt(pageSize) * Integer.parseInt(pageNO);
			
			if (endNum > dlength) {
				endNum = dlength;
			}
		}
		
		resultXML.append("<ROWS>");

		for (int k = startNum; k < endNum; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("PROCESSDEPTNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("PROCESSDEPTNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("CATEGORYCODE").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("MCATEGORYCODE").item(k).getTextContent()) + "</DATA3>");
			resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("SUBCATEGORYCODE").item(k).getTextContent()) + "</DATA4>");
			resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("PROCESSDEPTCODE").item(k).getTextContent()) + "</DATA5>");
			
			if (makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA6>0</DATA6>");
			} else {
				resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()) + "</DATA6>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()).equals("1")) {
				resultXML.append("<VALUE>" + "Y" + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + "N" + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("CNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("CNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MCNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MCNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPeriodString(makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()), companyID, commonUtil.getPrimaryData(langType, tenantID), tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepMethodString(makeListField(docXML.getElementsByTagName("KEEPINGMETHOD").item(k).getTextContent()), companyID, commonUtil.getPrimaryData(langType, tenantID), tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPlaceString(makeListField(docXML.getElementsByTagName("KEEPINGPLACE").item(k).getTextContent()), companyID, commonUtil.getPrimaryData(langType, tenantID), tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (makeListField(docXML.getElementsByTagName("DISPLAYRECFLAG").item(k).getTextContent()).equals("1")) {
				resultXML.append("<VALUE>" + "Y" + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + "N" + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()).equals("1")) {
				resultXML.append("<VALUE>" + "t1782" + "</VALUE>");
			} else if (makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()).equals("2")) {
				resultXML.append("<VALUE>" + "t1702" + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + "t606" + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getContDocList(String containerID, String userID, String subQuery, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		boolean publicFlag = false;
		boolean securityFlag = false;
		String userSecurityCode = "";
		
		if (getIsUse("A22", "001", companyID, lang, tenantID).equals("1")) {
			securityFlag = true;
		}
		
		if (getIsUse("A22", "004", companyID, lang, tenantID).equals("1")) {
			publicFlag = true;
		}
		
		if (securityFlag) {
			userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6", tenantID);
		}
		
		if (userSecurityCode == null || userSecurityCode.equals("")) {
			userSecurityCode = "0";
		}
		
		String listString = "";
		
		if (containerID.equals("ADMIN")) {
			listString = getListHeader("082", companyID, lang, tenantID);
		} else {
			listString = getListHeader("006", companyID, lang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getContDocListCount(containerID, userID, userSecurityCode, publicFlag, subQuery, companyID, tenantID);
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);

        if (querySize2 >= Integer.parseInt(pageSize)) {
        	querySize2 = Integer.parseInt(pageSize);
        }
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!orderCell.equals("") && orderCell.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (orderOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getContDocList(containerID, userID, userSecurityCode, publicFlag, subQuery, querySize, querySize2, orderOption1, orderOption2, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("FORMNAME") || fieldName.equals("WRITERJOBTITLE")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("WRITERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + docXML.getElementsByTagName("FORMID").item(k).getTextContent() + "</DATA6>");
					resultXML.append("<DATA7>" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + docXML.getElementsByTagName("SECURITYAPPROVAL").item(k).getTextContent() + "</DATA10>");
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
		
		return resultXML.toString();
	}

	@Override
	public String getGamSaSearchDocList(String containerID, String userID, String deptID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR,
			String draftFromMONTH, String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR,
			String apprToMONTH, String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY,
			String draftDeptName, String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, LoginVO userInfo) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		boolean publicFlag = false;
		boolean securityFlag = false;
		String userSecurityCode = "";
		
		if (getIsUse("A22", "001", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			securityFlag = true;
		}
		
		if (getIsUse("A22", "004", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId()).equals("1")) {
			publicFlag = true;
		}
		
		if (securityFlag) {
			userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6", userInfo.getTenantId());
		}
		
		if (userSecurityCode == null || userSecurityCode.equals("")) {
			userSecurityCode = "0";
		}
		
		String listString = "";
		
		listString = getListHeader("006", userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		String tmpStartDate1 = commonUtil.makeDate(draftFromYEAR, draftFromMONTH, draftFromDAY, true).trim();
		String tmpStartDate2 = commonUtil.makeDate(draftToYEAR, draftToMONTH, draftToDAY, false).trim();
		String tmpEndDate1 = commonUtil.makeDate(apprFromYEAR, apprFromMONTH, apprFromDAY, true).trim();
		String tmpEndDate2 = commonUtil.makeDate(apprToYEAR, apprToMONTH, apprToDAY, false).trim();
		String tmpProcessDate1 = commonUtil.makeDate(myApprFromYEAR, myApprFromMONTH, myApprFromDAY, true).trim();
		String tmpProcessDate2 = commonUtil.makeDate(myApprToYEAR, myApprToMONTH, myApprToDAY, false).trim();
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getGamSaSearchDocListCount(containerID, userID, deptID, userSecurityCode, publicFlag, subQuery, makeSearchField(docNumber.trim()), makeSearchField(docTitle.trim()), makeSearchField(drafter.trim()), makeSearchField(draftDeptName.trim()), formID, tmpStartDate1, tmpStartDate2, tmpEndDate1, tmpEndDate2,
				tmpProcessDate1, tmpProcessDate2, aprFlag, docState, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getCompanyID());
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);

        if (querySize2 >= Integer.parseInt(pageSize)) {
        	querySize2 = Integer.parseInt(pageSize);
        }
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		resultXML.append("<HEADER>");
		resultXML.append("<NAME>" + messageSource.getMessage("ezApprovalG.t439", userInfo.getLocale()) + "</NAME>");
		resultXML.append("<WIDTH>40</WIDTH>");
		resultXML.append("<COLNAME></COLNAME>");
		resultXML.append("</HEADER>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!orderCell.equals("") && orderCell.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (orderOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getGamSaSearchDocList(containerID, userID, deptID, userSecurityCode, publicFlag, subQuery, makeSearchField(docNumber.trim()), makeSearchField(docTitle.trim()), makeSearchField(drafter.trim()), makeSearchField(draftDeptName.trim()), formID, tmpStartDate1, tmpStartDate2, tmpEndDate1, tmpEndDate2,
				tmpProcessDate1, tmpProcessDate2, aprFlag, docState.trim(), querySize, querySize2, orderOption1, orderOption2, commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()), userInfo.getCompanyID());
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("FORMNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId());
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId(), userInfo.getOffset())) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("WRITERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + docXML.getElementsByTagName("FORMID").item(k).getTextContent() + "</DATA6>");
					resultXML.append("<DATA7>" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + docXML.getElementsByTagName("SECURITYAPPROVAL").item(k).getTextContent() + "</DATA10>");
					resultXML.append("<DATA11>" + docXML.getElementsByTagName("EDMSYN").item(k).getTextContent() + "</DATA11>");
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
		
		return resultXML.toString();
	}

	@Override
	public String getUncompleteDocCount(String deptID, String companyID, String cabinetID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabinetID);
		map.put("v_TENANTID", tenantID);

		
		int resultApr = ezApprovalGDAO.getUncompleteDocCount(map);
		
		return "<RESULT>" + resultApr + "</RESULT>";
	}

	@Override
	public String transferCabinet(Document xmlDom, int tenantID) throws Exception {
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String deptCode = xmlDom.getElementsByTagName("DDEPTCODE").item(0).getTextContent();
		String deptName = xmlDom.getElementsByTagName("DDEPTNAME").item(0).getTextContent();
		String deptName2 = xmlDom.getElementsByTagName("DDEPTNAME").item(0).getTextContent();
		String taskCode = xmlDom.getElementsByTagName("DTASKCODE").item(0).getTextContent();
		String taskName = xmlDom.getElementsByTagName("DTASKNAME").item(0).getTextContent();
		String taskName2 = xmlDom.getElementsByTagName("DTASKNAME2").item(0).getTextContent();
		String deptMID = xmlDom.getElementsByTagName("DDEPTMID").item(0).getTextContent();
		String deptMName = xmlDom.getElementsByTagName("DDEPTMNAME").item(0).getTextContent();
		String deptMName2 = xmlDom.getElementsByTagName("DDEPTMNAME2").item(0).getTextContent();
		
		String cabIDList = "";
		
		for (int k = 0; k < xmlDom.getElementsByTagName("ID").getLength(); k++) {
			if (k == 0) {
				cabIDList += "'" + xmlDom.getElementsByTagName("ID").item(k).getTextContent().trim() + "' ";
			} else {
				cabIDList += ", '" + xmlDom.getElementsByTagName("ID").item(k).getTextContent().trim() + "' ";
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DDeptCode", deptCode);
		map.put("v_DDeptName", deptName);
		map.put("v_DDeptName2", deptName2);
		map.put("v_DTaskCode", taskCode);
		map.put("v_DTaskName", taskName);
		map.put("v_DTaskName2", taskName2);
		map.put("v_CabIDList", cabIDList);
		map.put("v_DeptMID", deptMID);
		map.put("v_DeptMName", deptMName);
		map.put("v_DeptMName2", deptMName2);
		map.put("v_TENANTID", tenantID);

		String rtnVal = "";
		
		try {
			int numRows = ezApprovalGDAO.transferCabinet(map);
			map.put("v_numRows", numRows);
			
			int type2Sn = ezApprovalGDAO.transferCabinetType2(map);
			if ( type2Sn == 0) {
				deptCode = "0";
				map.put("v_DDeptCode", deptCode);
			} 
				
			map.put("v_YEAR", commonUtil.getTodayUTCTime("yyyy"));
			map.put("v_MONTH", String.format("%03d",Integer.parseInt(commonUtil.getTodayUTCTime("").substring(6,7))).toString());
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));

			String curSN = ezApprovalGDAO.transferCabinetSn(map);
			
			if(curSN == null) {
				curSN = "1";
			}
				map.put("v_RtnSN", curSN);
				ezApprovalGDAO.insertTbSerialNumGen(map);
			
				ezApprovalGDAO.updateTbSerialNumGen(map);
				
				StringBuffer rowID = new StringBuffer();

//				 인수기록물철 분류정보(TBCABINETCLASS)를 생성한다.
				for (int j=0; j<numRows; j++) {
					String cabList[] =cabIDList.split(",");
					map.put("v_cabList",cabList[j]);
					map.put("v_SN", j);
					map.put("v_CNT", String.format("%06d",Integer.parseInt(curSN+Integer.toString(j))));
					map.put("v_CABINETCLASSNO", deptCode + taskCode + commonUtil.getTodayUTCTime("").substring(0,4) + String.format("%06d",Integer.parseInt(curSN+Integer.toString(j))));
					ezApprovalGDAO.insertTbCabinetClass(map);
					ezApprovalGDAO.trigerTbCabinet(map);
					ezApprovalGDAO.trigerTbCabRoleInfo(map);
				
				List<ApprGCabinetVO> apprExistUnitList = ezApprovalGDAO.selectExistUnit(map);
				if(apprExistUnitList.size() > 0) {
						rowID.append(apprExistUnitList.get(0).getCabinetClassNo().trim());
						map.put("v_rowID", rowID.toString());
						map.put("KeepingPeriod", apprExistUnitList.get(0).getKeepingPeriod());
						map.put("KeepingMethod", apprExistUnitList.get(0).getKeepingPlace());
						map.put("KeepingPlace", apprExistUnitList.get(0).getKeepingMethod());
						map.put("DisplayRecFlag", apprExistUnitList.get(0).getDiplayRecFlag());
						map.put("SpecialCatalogFlag", apprExistUnitList.get(0).getSpecialCatalogFlag());
						ezApprovalGDAO.updateExistUnit(map);
					}
				
				//특수목록 입력
				String spFlag = ezApprovalGDAO.selectTbSpecialCatalogInfo(map);
				if(spFlag == null) {
					map.put("v_NewSCFlag", 0);
				} else if (!spFlag.equals("0")){
					map.put("v_NewSCFlag", spFlag);

					ezApprovalGDAO.insertTbSpecialCatalogInfo(map);
					//특수목록 플래그가 같고 특수목록 이름이 같으면 데이터를 복사한다.
					ezApprovalGDAO.insertTbSpecialCatalogInfo2(map);
				}
				//구기록물철 정보 저장
				ezApprovalGDAO.insertTbOldCabinetExtraInfo(map);
				//인수 기록물철 테이블(TBCABINET)에 생성한다.
			    //권호수가 1권이 아닐경우-> 기록물철을 생성
				ezApprovalGDAO.insertTbCabinetInfo(map);
				List<ApprGCabinetVO> apprCabinetTransferList = ezApprovalGDAO.selectCabinetTransfer(map);
				StringBuffer rowID2 = new StringBuffer();
				if(apprCabinetTransferList.size() > 0) {
						rowID2.append(apprCabinetTransferList.get(0).getCabinetID().trim());
						map.put("v_rowID2", rowID2.toString());
						map.put("ProcessDeptCode", apprCabinetTransferList.get(0).getProcessDeptCode());
						map.put("TaskCode", apprCabinetTransferList.get(0).getTaskCode());
						map.put("ProductionYear", apprCabinetTransferList.get(0).getProductionYear());
						map.put("RegSerialNo", apprCabinetTransferList.get(0).getRegSerialNo());
						map.put("VolumeNo", apprCabinetTransferList.get(0).getVolumeNo());
						map.put("CabinetID", apprCabinetTransferList.get(0).getCabinetID());
						map.put("Title", apprCabinetTransferList.get(0).getTitle());
						map.put("Title2", apprCabinetTransferList.get(0).getTitle2());
						map.put("ProcessDeptName", apprCabinetTransferList.get(0).getProcessDeptName());
						map.put("ProcessDeptName2", apprCabinetTransferList.get(0).getProcessDeptName2());
						map.put("TaskName", apprCabinetTransferList.get(0).getTaskName());;
						map.put("TaskName2", apprCabinetTransferList.get(0).getTaskName2());
						map.put("CatalogTransferFlag", apprCabinetTransferList.get(0).getCatalogTransferFlag());
						map.put("CatalogTransferYear", apprCabinetTransferList.get(0).getCatalogTransferYear());
						map.put("DocTransferFlag", apprCabinetTransferList.get(0).getDocTransferFlag());
						map.put("DocTransferYear", apprCabinetTransferList.get(0).getDocTransferYear());
						map.put("ProdReportFlag", apprCabinetTransferList.get(0).getProdReportFlag());
						
						ezApprovalGDAO.updateTbCabinetInfo(map);
				}
				ezApprovalGDAO.updateTbCabinetInfo2(map);
				ezApprovalGDAO.updateTbCabinetInfo3(map);
				ezApprovalGDAO.updateTbCabinetClass(map);
				
				List<ApprGCabinetVO> apprTbSeperateAttachList = ezApprovalGDAO.selectTbSeperateAttach(map);
				StringBuffer rowID3 = new StringBuffer();

				if(apprTbSeperateAttachList.size() > 0) {
				
						rowID.append(apprTbSeperateAttachList.get(0).getRecordID().trim());
						map.put("v_rowID3", rowID3.toString());
						map.put("v_CABINETID", apprTbSeperateAttachList.get(0).getCabinetID());

						ezApprovalGDAO.updateTbSeperateAttach(map);
					}
				
				ezApprovalGDAO.insertTbCabinetHistory(map);
				}
				
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String gongRamUpdate(String docID, String userID, String companyID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_USERID", userID);
		map.put("v_FLAG", "1");
		map.put("v_TENANTID", tenantID);
		boolean rtnVal = false;
		
		try {
			ezApprovalGDAO.gongRamUpdate(map);
			
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
		
		rtnVal = gongRamActivate(docID, companyID, lang, tenantID);
		
		if (!rtnVal) {
			map.put("v_FLAG", "2");
			
			try {
				ezApprovalGDAO.gongRamUpdate(map);
				
				rtnVal = true;
			} catch (Exception e) {
				rtnVal = false;
			}
			
			return "<RESULT>FALSE</RESULT>";
		}
		
		map.put("v_FLAG", "3");
		
		try {
			String grDocID = ezApprovalGDAO.selectGongRamDocID(map);
			if(grDocID != null){
				ezApprovalGDAO.gongRamUpdate(map);
			}
			
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String delayCabEndY(String deptCode, String flag, String cabClassList, String companyID, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "";
		String tempStr = "";
		String[] tempAry = cabClassList.split(",");
		
		for (int k = 0; k < tempAry.length; k++) {
			tempStr += "'" + tempAry[k] + "',";
		}
		
		cabClassList = tempStr.substring(0, tempStr.length() - 1);

        if (flag.equals("1")) { 				// 모두 연기일 경우
			strSQL.append("Update TBL_CABINETCLASS Set DelayEndYFlag = 'N', ");
			strSQL.append("ExpirationYear = CAST((CAST(ExpirationYear AS int)+1) AS char(4)) ");
			strSQL.append("Where OwnerDeptID = '" + makeRightField(deptCode) + "' " + " And TBL_CABINETCLASS.DelayEndYFlag = 'Y' " + 
					"And TBL_CABINETCLASS.TerminateFlag = '0' And TBL_CABINETCLASS.ConfirmFlag = '0'" + "AND TENANT_ID="+ tenantID +";");
		} else if (flag.equals("0")) { 			// 선택된 철만 연기일 경우
			strSQL.append("Update TBL_CABINETCLASS Set DelayEndYFlag = 'N', ");
			strSQL.append("ExpirationYear = CAST((CAST(ExpirationYear AS int)+1) AS char(4)) ");
			strSQL.append("Where CabinetClassNo IN (" + cabClassList + ") AND TENANT_ID ="+ tenantID +";");
		} else if (flag.equals("2")) {  		// 연기취소일 경우
			strSQL.append("Update TBL_CABINETCLASS Set DelayEndYFlag = 'N' Where ");
			strSQL.append("CabinetClassNo IN (" + cabClassList + ") AND TENANT_ID ="+ tenantID +";");
		}
        
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map);
			
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String getUncabinetedDocCount(String deptID, String confirmYN, String companyID, int tenantID) throws Exception {
		String deptInfos = ezOrganService.getPropertyValue(deptID, "extensionAttribute4", tenantID);
		String deptInfo = deptID.trim();
		
		if (deptInfos != null) {
			String[] deptList = deptInfos.split(";");
			
			for (int k = 0; k < deptList.length; k++) {
				deptInfo += ", " + deptList[k].trim();
			}
		}
		
		if (confirmYN.trim().equals("")) {
			confirmYN = commonUtil.getTodayUTCTime("yyyy");
		}
		
		confirmYN += "-12-31 23:59:59";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTINFO", deptInfo);
		map.put("v_UNTILYEAR", confirmYN);
		map.put("v_TENANTID", tenantID);

		int result = ezApprovalGDAO.getUncabinetedDocCount(map);
		
		return "<RESULT>" + result + "</RESULT>";
	}

	@Override
	public String chkIfNotArrangedCabExist(String deptID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		String utcYear = commonUtil.getTodayUTCTime("yyyy");
		map.put("companyID", companyID);
		map.put("v_DEPTCODE", deptID);
		map.put("v_TENANTID", tenantID);
		map.put("v_UTCYEAR", utcYear);
		int result = ezApprovalGDAO.chkIfNotArrangedCabExist(map);
		
		return "<RESULT>" + result + "</RESULT>";
	}

	@Override
	public String confirmClassify(String deptID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTCODE", deptID);
		map.put("v_TENANTID", tenantID);
		
		try {
			ezApprovalGDAO.confirmClassify(map);
			
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			System.out.println(e.getMessage());
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getSendOutDocList(String userID, String deptID, String mode, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String userLang, int tenantID, String offset) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		String basicOrder = getCode2Name("A18", "001", companyID, userLang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String basicOrderReverse = "desc";
		
		if (basicOrder.toLowerCase().equals("desc")) {
			basicOrderReverse = "";
		} else {
			basicOrder = "";
		}
		
		String listString = "";
		
		listString = getListHeader("007", companyID, userLang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getSendOutDocListCount(mode, companyID, tenantID);
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);

        if (querySize2 >= Integer.parseInt(pageSize)) {
        	querySize2 = Integer.parseInt(pageSize);
        }
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getSendOutDocList(mode, querySize, querySize2, orderOption1, orderOption2, basicOrder, basicOrderReverse, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("WRITERDEPTNAME") || fieldName.equals("WRITERNAME") || fieldName.equals("FORMNAME")) {
						fieldName = fieldName + commonUtil.getMultiData(userLang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, userLang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + "" + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + docXML.getElementsByTagName("PROCESSYN").item(k).getTextContent() + "</DATA5>");
					resultXML.append("<DATA6>" + "" + "</DATA6>");
					resultXML.append("<DATA7>" + "" + "</DATA7>");
					resultXML.append("<DATA8>" + "" + "</DATA8>");
					resultXML.append("<DATA9>" + "" + "</DATA9>");
					resultXML.append("<DATA10>" + "" + "</DATA10>");
					resultXML.append("<DATA11>" + "" + "</DATA11>");
					resultXML.append("<DATA12>" + "" + "</DATA12>");
					resultXML.append("<DATA13>" + "" + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("URGENTAPPROVAL").item(k).getTextContent()) + "</DATA14>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		return resultXML.toString();
	}

	@Override
	public String endCabProduce(String cabClassNo, String flag, String companyID, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "";
		String tempStr = "";
		String[] tempAry = cabClassNo.split(",");
		
		for (int k = 0; k < tempAry.length; k++) {
			tempStr += "'" + tempAry[k] + "',";
		}
		
		cabClassNo = tempStr.substring(0, tempStr.length() - 1);
		
		if (flag.equals("0")) {
			strSQL.append("Update TBL_CABINETCLASS Set TerminateFlag = '1' Where ");
			strSQL.append("ConfirmFlag = '0' And CabinetClassNo IN (" + cabClassNo + ") AND TENANT_ID = " + tenantID +";\n");
        } else {
			strSQL.append("Update TBL_CABINETCLASS Set TerminateFlag = '0' Where ");
			strSQL.append("ConfirmFlag = '0' And CabinetClassNo IN (" + cabClassNo + ") AND TENANT_ID = " + tenantID +";\n");
        }
		//쿼리 이상해서 수정
//		if (flag.equals("0")) {
//			strSQL.append("Update TBCABINETCLASS Set TerminateFlag = '1' Where ");
//			strSQL.append("ConfirmFlag = '0' And CabinetClassNo IN (Select Value ");
//			strSQL.append("From TABLE(fn_StringToTable('" + cabClassNo + "', ',')));\n");
//		} else {
//			strSQL.append("Update TBCABINETCLASS Set TerminateFlag = '0' Where ");
//			strSQL.append("ConfirmFlag = '0' And CabinetClassNo IN (Select Value ");
//			strSQL.append("From TABLE(fn_StringToTable('" + cabClassNo + "', ',')));\n");
//		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
		
		try {
			ezApprovalGDAO.transactionSQL(map);
			
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}
	
	@Override
	public String mobileSrvConn(String userID, String result, String formID, String keyVal, String docID, String orgUID, String strLang, String companyID, String passWord, HttpServletRequest request, LoginVO userInfo) throws Exception {
		if (userID.equals("") || result.equals("") || formID.equals("") || docID.equals("") || orgUID.equals("") || companyID.equals("")) {
			return "ERROR";
		}
		
		String docState = getDocAprState(docID, userID, companyID, userInfo.getTenantId());
		String docType = getDocInfo(docID, "APR", "FUNCTIONTYPE", companyID, userInfo.getTenantId());
		
		if (docType.equals("004") || docType.equals("015")) {
			return messageSource.getMessage("ezApprovalG.t2104", userInfo.getLocale());
		}
		
		if (docState.equals("004") || docState.equals("015")) {
			return messageSource.getMessage("ezApprovalG.t2104", userInfo.getLocale());
		}
		
		String rValue = getDocAprLine(docID, userID, docState, companyID,userInfo.getTenantId());
		Document xmlDom = commonUtil.convertStringToDocument(rValue);
		
		String signNum = xmlDom.getElementsByTagName("APRMEMBERSN").item(0).getTextContent();
		String aprState = xmlDom.getElementsByTagName("APRSTATE").item(0).getTextContent();
		String aprType = xmlDom.getElementsByTagName("APRTYPE").item(0).getTextContent();
		
		String resultVal = createMhtFile(formID, userID, signNum, docID, aprState, aprType, result, orgUID, strLang, companyID, passWord, request, userInfo);
		
		return resultVal;
	}

	@Override
	public String reqDelayCabEndY(String cabClassList, String flag, String companyID, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "";
		String tempStr = "";
		String[] tempAry = cabClassList.split(",");
		
		for (int k = 0; k < tempAry.length; k++) {
			tempStr += "'" + tempAry[k] + "',";
		}
		
		cabClassList = tempStr.substring(0, tempStr.length() - 1);
		
		strSQL.append("Update TBL_CABINETCLASS Set DelayEndYFlag = '" + flag);
		strSQL.append("' Where TBL_CABINETCLASS.CabinetClassNo IN (" + cabClassList + ") AND TBL_CABINETCLASS.TENANT_ID=" + tenantID +";\n");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
		
		try {
			ezApprovalGDAO.transactionSQL(map);
			
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String doSendOfferApprove(String docID, String orgDocID, String userID, String userName, String userName2, String deptID, String dirPath, String proxyUserID, String companyID, String lang, LoginVO userInfo)
			throws Exception {
		StringBuilder strSQL = new StringBuilder();
		boolean rtn = true;
		String gFlag = getCode2Name("A35", "002", companyID, lang, userInfo.getTenantId()).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_ORGDOCID", orgDocID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));

		try {
			ezApprovalGDAO.doSendOfferApprove1(map);
			if(gFlag.equals("G")) {
				ezApprovalGDAO.deleteTbAprAttachInfo(map);
				ezApprovalGDAO.insertTbAprAttachInfo(map);
				
				ezApprovalGDAO.deleteTbAprDocAttachInfo(map);
				ezApprovalGDAO.insertTbAprDocAttachInfo(map);
			}
				ezApprovalGDAO.deleteTbAprLineInfo(map);
				ezApprovalGDAO.insertTbAprLineInfo(map);
				
				ezApprovalGDAO.deleteTbExpAprLine(map);
				ezApprovalGDAO.insertTbExpAprLine(map);
			
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "<RESULT>FALSE</RESULT>";
		}
		
		strSQL.append(doDocComplete(docID, userID, userName, userName2, dirPath, deptID, proxyUserID, companyID, lang, userInfo));
		
		if (!strSQL.toString().toUpperCase().equals("FALSE")) {
			
			try {
				map.put("v_DOCID", docID);
				ezApprovalGDAO.updateProEndAprDocInfo(map);  
				
				map.put("v_DOCID", orgDocID);
				ezApprovalGDAO.updateProEndAprDocInfo(map);	
    			rtn = true;
    		} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    			System.out.println(e.getMessage());
    			rtn = false;
    		}
    		
		} else {
			rtn = false;
		}
		
		if (rtn) {
			chkDocDelete(docID, orgDocID, rtn, userID, deptID, dirPath, companyID, userInfo.getTenantId());
			
			return "<RESULT>TRUE</RESULT>";
		} else {
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
			ezApprovalGDAO.doSendOfferApprove2(map);
			
			chkDocDelete(docID, orgDocID, rtn, userID, deptID, dirPath, companyID, userInfo.getTenantId());
			
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String doSendOfferReject(String docID, String userID, String companyID, int tenantID) throws Exception {
		LOGGER.debug("doSendOfferReject started");
		StringBuilder strSQL = new StringBuilder();
		StringBuilder strSQL2 = new StringBuilder();

		int receivedSN = 1;
		
		strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET ProcessDate = ");
        strSQL.append("TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), AprState = '");
        strSQL.append(staASBanSong + "', ProcessYN = 'Y' WHERE DocID = '" + docID);
        strSQL.append("' AND ProcessorID = '" + userID + "' AND AprState = '" + staASJinHang + "' AND TENANT_ID =" + tenantID +"\n");
    	
        Map<String, Object> map1 = new HashMap<String, Object>();
    	
		map1.put("companyID", companyID);
		map1.put("sqlString", strSQL.toString());
		
        ezApprovalGDAO.updateTbAprReceiptProcessInfo(map1);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		LOGGER.debug("doSendOfferReject Param : v_DOCID =" + docID + "v_TENANTID=" + tenantID);

		ApprGDocListVO signList = ezApprovalGDAO.doSendOfferRejectAprDoc(map);
		
		if (signList == null) {
			return "<RESULT>FALSE</RESULT>";
		}
		
		ApprGReceiveDocVO signList2 = ezApprovalGDAO.doSendOfferRejectReceipt(map);
        
		if (signList2 != null) {
			receivedSN = Integer.parseInt(signList2.getReceiveSN() + 1);
		}
		
		strSQL2.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
        strSQL2.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ProcessDate, ");
        strSQL2.append("ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) ");
		strSQL2.append("VALUES (" + receivedSN + ", '" + docID + "', '" + signList2.getSendDeptID() + "', N'");
        strSQL2.append(signList2.getSentDeptName() + "', N'" + signList2.getSentDeptName2() + "', '" + signList2.getReceivedDeptID() + "', N'" + signList2.getReceivedDeptName() + "', N'" + signList2.getReceivedDeptName2() + "', '" + staDSSimSa);
		strSQL2.append("', '" + staASBanSong + "'," +"TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
        strSQL2.append(", 'N', NULL, '" + signList.getWriterID() + "', N'" + signList.getWriterName() + "', N'" + signList.getWriterName2() + "', N'" + signList.getWriterJobTitle() + "', N'" + signList.getWriterJobTitle2());
		strSQL2.append("', '" + signList.getOrgDocID() + "'," + tenantID +")\n");
		
		String retValue = "";
		
		map1.put("companyID", companyID);
		map1.put("sqlString", strSQL2.toString());
		
		try {
			ezApprovalGDAO.insertTbAprReceiptProcessInfo(map1);
			
			retValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			retValue = "<RESULT>FALSE</RESULT>";
		}
		
		LOGGER.debug("doSendOfferReject ended");

		return retValue;
	}

	public String createMhtFile(String formID, String userID, String signNum, String docID, String aprState, String aprType, String result, String orgUID, String strLang, String companyID,
			String passWord, HttpServletRequest request,LoginVO userInfo) throws Exception{
		String realPath = commonUtil.getRealPath(request);
		String updAprNum = signNum;
		String content = "";
		String pTitle = "";
		String jikwe = "";
		String jikwe2 = "";
		String displayName = "";
		String displayName2 = "";
		String department = "";
		String description = "";
		String description2 = "";
		String convertedMHT = "";
		String docState = "";
		String proxySign = "";
		String empNo = "";
		String retNum = "";
		String imageM = "";
		String orgName = "";
		String orgName2 = "";
		String orgDeptID = "";
		String cabinetSN = "";
		String docNO = "";
		
		boolean docNumFlag = false;
		boolean mhtSaveFlag = false;
		boolean signSaveFlag = false;
		boolean linkCheck = true;
		
		String formURL = "";
		String tempMht = "";
		String drafterDept = "";
		String receiveDept = "";
		String fileForder1 = "";
		String strDeptID = "";
		
		boolean hukyulDoc = false;
		String currentAprType = "";
		String currentNum = "";
		int lastAprLineSN = 0;
		int totalLineSN = 0;
		
		String signInfo = "";
		String signText = "";
		String signInfo2 = "";
		String signText2 = "";
		String signAdd = "";
		//TODO 代 코드화?
		if (!userID.equals(orgUID)) {
			proxySign = "代 ";
		}
		
		String aprStateSign = getDocInfo(docID, "APR", "DOCSTATE", companyID, userInfo.getTenantId());
		
		if (aprStateSign.equals("011") || aprStateSign.equals("012")) {
			String receiveRet = getReceivedDocInfo(docID, companyID, strLang, userInfo.getTenantId(), userInfo.getOffset());
			Document aprXML = commonUtil.convertStringToDocument(receiveRet);
			
			receiveDept = aprXML.getElementsByTagName("RECEIPTDEPTID").item(0).getTextContent();
			fileForder1 = aprXML.getElementsByTagName("HREF").item(0).getTextContent();
		} else {
			String approveRet = getApproveDocInfo(docID, companyID, strLang, userInfo.getTenantId(), userInfo.getOffset());
			Document aprXML = commonUtil.convertStringToDocument(approveRet);
			
			drafterDept = aprXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent();
			fileForder1 = aprXML.getElementsByTagName("HREF").item(0).getTextContent();
		}
		
		formURL = realPath + fileForder1;
		
		String loadMht = ezCommonService.loadMHTFile(formURL);
		
		content = ezCommonService.startMHT2HTML(realPath + config.getProperty("config.LocalPath"), loadMht, realPath + config.getProperty("config.LocalPath"), realPath, userInfo.getLocale());

		//HTML 파싱 document 클래스 겹쳐서 임포트 못함
		org.jsoup.nodes.Document doc = Jsoup.parse(content);
		
		if (aprStateSign.equals("011")) {
			signAdd = "1";
		} else {
			signAdd = "";
		}
		
		String signCnt = signNum;
		String signImage = "";
		String propList = "extensionAttribute3;title;title2;displayName;displayName2;department;description;description2;extensionAttribute14";
		String results = ezOrganService.getPropertyList(userID, propList, strLang, userInfo.getTenantId());
		
		Document xmlDoc = commonUtil.convertStringToDocument(results);
		
		signImage = xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE3").item(0).getTextContent();
		pTitle = xmlDoc.getElementsByTagName("TITLE").item(0).getTextContent();
		jikwe = pTitle;
		jikwe2 = xmlDoc.getElementsByTagName("TITLE2").item(0).getTextContent();
		displayName = xmlDoc.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		displayName2 = xmlDoc.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		department = xmlDoc.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
		description = xmlDoc.getElementsByTagName("DESCRIPTION").item(0).getTextContent();
		description2 = xmlDoc.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
		empNo = xmlDoc.getElementsByTagName("EXTENSIONATTRIBUTE14").item(0).getTextContent();
		
		results = ezOrganService.getPropertyList(orgUID, propList, strLang, userInfo.getTenantId());
		
		xmlDoc = commonUtil.convertStringToDocument(results);
		
		orgName = xmlDoc.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
		orgName2 = xmlDoc.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		orgDeptID = xmlDoc.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
		
		String chkFlag = "CHECK";
		
		if (pTitle.equals("")) {
			pTitle = "&nbsp;";
		}
		
		String[] signTextArray = null;
		
		if (!signImage.equals("")) {
			signTextArray = signImage.split(";");
		} else {
			signTextArray = new String[1];
			signTextArray[0] = "defaultsign.gif";
		}
		
		int tempLength = signTextArray.length;
		int pCnt = getDocAprCnt(docID, companyID, userInfo.getTenantId());
		int refResult = getDocInfoRef(docID, orgUID, aprState, companyID, userInfo.getTenantId());
		int habResult = getDocInfoHab(docID, orgUID, aprState, companyID, userInfo.getTenantId());
		
		String strSign = "";
		String strJikwe = "";
		String strSeumyungDate = "";
		String strSql = "TRUE";
		
		String lineResult = getAprLineInfo(docID, orgUID, formID, companyID, strLang, userInfo.getTenantId(), userInfo.getOffset());
		
		Document lineXml = commonUtil.convertStringToDocument(lineResult);
		NodeList docListNode = lineXml.getElementsByTagName("ROW");

		if (docListNode.getLength() > 0) {
			totalLineSN = docListNode.getLength();
			
			for (int k = 0; k < docListNode.getLength(); k++) {
				String pType = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(11).getTextContent();
				
				if (pType.equals("003") || pType.equals("007")) {
					totalLineSN = totalLineSN - 1;
				} else {
					break;
				}
			}
			
			for (int k = docListNode.getLength() -1; k >= 0; k--) {
				currentNum = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(0).getTextContent();
				currentAprType = docListNode.item(k).getChildNodes().item(0).getChildNodes().item(11).getTextContent();
				
				switch (currentAprType) {
                case "001": //"결재";
                    lastAprLineSN = lastAprLineSN + 1;
                    break;

                case "019": //"검토";
                    lastAprLineSN = lastAprLineSN + 1;
                    break;

                case "004": //"전결";
                    lastAprLineSN = lastAprLineSN + 1;
                    break;

                case "003": //"결재안함";
                    lastAprLineSN = lastAprLineSN + 1;
                    break;
                }
			}
		}
		
		int LSignNum = 0;
		String lastSignNum = "";
		
		if (!signAdd.equals("")) {
			for (int k = 1; k < 10; k++) {
				if (!doc.body().html().contains(signAdd + "sign" + k)) {
					LSignNum = k - 1;
					lastSignNum = String.valueOf(LSignNum);
					break;
				}
			}
		} else {
			for (int k = 1; k < 10; k++) {
				if (!doc.body().html().contains("=sign" + k)) {
					LSignNum = k - 1;
					lastSignNum = String.valueOf(LSignNum);
					break;
				}
			}
		}
		
		if (result.equals("A")) {
			docState = "003";
			
			if (aprType.equals("016")) {
				int tmps = Integer.parseInt(signCnt) - refResult;
				String tempSign = signAdd + "sign" + tmps;
				String tempJik = signAdd + "jikwe" + tmps;
				String tempSem = signAdd + "seumyungdate" + tmps;
				
				doc.getElementById(tempSign).html(messageSource.getMessage("ezApprovalG.t26", userInfo.getLocale()) + commonUtil.getTodayUTCTime("MM") + "/" + commonUtil.getTodayUTCTime("dd") + "<BR/><P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>");
				
				int jeonKyul = getDocInfoJeonKyul(docID, orgUID, aprState, companyID, userInfo.getTenantId());
				
				if (jeonKyul > 0) {
					strSign = "sign" + (tmps + 1);
					doc.getElementById(strSign).html(messageSource.getMessage("ezApprovalG.t25", userInfo.getLocale()));
				}
				
				signInfo = tempSign;
				signText = messageSource.getMessage("ezApprovalG.t26", userInfo.getLocale()) + commonUtil.getTodayUTCTime("MM") + "/" + commonUtil.getTodayUTCTime("dd") + "<BR/><P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>";
			} else if (aprType.equals("001") || aprType.equals("019")) {
				String lastCnt = "";
				
				if (totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("001")) {
					lastCnt = commonUtil.getTodayUTCTime("MM") + "/" + commonUtil.getTodayUTCTime("dd");
				}
				
				if (refResult > 0) {
					int tmps = Integer.parseInt(signCnt) - refResult;
					strSign = signAdd + "sign" + tmps;
					strJikwe = signAdd + "jikew" + tmps;
					
					doc.getElementById(strSign).html(lastCnt + "<P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>");
				} else {
					int tmps = Integer.parseInt(signCnt) - refResult;
					strSign = signAdd + "sign" + tmps;
					strSeumyungDate = signAdd + "seumyungdate" + tmps;
					strJikwe = signAdd + "jikwe" + tmps;
					
					doc.getElementById(strSign).html(lastCnt + "<P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>");
				}
				
				signInfo = strSign;
				signText = lastCnt + "<P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>";
			} else if (aprType.equals("008") || aprType.equals("009")) {
				int tmps = Integer.parseInt(signCnt) - habResult;
				String habSign = signAdd + "habyuisign" + tmps;
				String habSem = signAdd + "habyuidate" + tmps;
				
				doc.getElementById(habSign).html("<P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>");
				
				signInfo = habSign;
				signText = "<P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>";
				signInfo2 = habSem;
				signText2 = commonUtil.getTodayUTCTime("").substring(6,10).replace("/", ".");
			} else if (aprType.equals("004")) {
				int tmps = Integer.parseInt(signCnt) - refResult;
				String tempSign = signAdd + "sign" + tmps;
				
				doc.getElementById(tempSign).html(messageSource.getMessage("ezApprovalG.t25", userInfo.getLocale()) + commonUtil.getTodayUTCTime("MM") + "/" + commonUtil.getTodayUTCTime("dd") + "<BR/><P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>");
				
				signInfo = tempSign;
				signText = messageSource.getMessage("ezApprovalG.t25", userInfo.getLocale()) + commonUtil.getTodayUTCTime("MM") + "/" + commonUtil.getTodayUTCTime("dd") + "<BR/><P style=\"FONT-FAMILY: " + messageSource.getMessage("ezApprovalG.t2105", userInfo.getLocale()) + "; FONT-SIZE: 10pt; FONT-WEIGHT: 900\">" + proxySign + displayName + "</P>";
			} else if (aprType.equals("015")) {
				gongRamUpdate(docID, userID, companyID, strLang, userInfo.getTenantId());
				
				return "001";
			}
			
			String tmpYear = getDocInfoDState(docID, "STARTDATE", companyID, userInfo.getTenantId());
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Calendar cal = Calendar.getInstance();
			
			cal.setTime(format.parse(tmpYear));
			tmpYear = String.valueOf(cal.get(Calendar.YEAR));
			
			if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007") && !aprStateSign.equals("011")) {
				if (aprStateSign.equals("012")) {
					strDeptID = receiveDept;
				} else {
					strDeptID = drafterDept;
				}
				
				if (!excuteInfo("DOCNUM_BEFORE", "DRAFT", doc, docID, userID, passWord, formURL)) {
					return "Link ERROR";
				}
				
				String ret = getCabinetNum(strDeptID, "", companyID, userInfo.getTenantId());
				
				docNumFlag = true;
				
				Document docXML = commonUtil.convertStringToDocument(ret);
				cabinetSN = docXML.getElementsByTagName("RESULT").item(0).getTextContent();
				
				if (ret != "" && doc.getElementById("docnumber") != null) {
					docNO = doc.getElementById("docnumber").text() + cabinetSN;
					doc.getElementById("docnumber").text(docNO);
					
					if (doc.getElementById("enforcedate") != null) {
						doc.getElementById("enforcedate").text(commonUtil.getTodayUTCTime("yyyy").replace("-", "."));
					}
					
					retNum = getNDigitNum(cabinetSN, 6);
					
					doc.body().attr("regnumbercode", retNum);
					doc.body().attr("deptid", strDeptID);
				}
				
				linkCheck = excuteInfo("DOCNUM_AFTER", "DRAFT", doc, docID, userID, passWord, formURL);
				
				if (!linkCheck) {
					if (docNumFlag) {
						rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
					}
					
					return "Link ERROR";
				}
			}
		} else if (result.equals("B")) { // 반송
			docState = "004";
		} else if (result.equals("BR")) { // 보류
			docState = "005";
		}
		
		if (result.equals("A")) {
			if (aprStateSign.equals("011")) {
				if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
					linkCheck = excuteInfo("LAST_SIGN_BEFORE", "SUSIN", doc, docID, userID, passWord, formURL);
				} else {
					linkCheck = excuteInfo("MIDDLE_SIGN_BEFORE", "SUSIN", doc, docID, userID, passWord, formURL);
				}
			} else {
				if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
					linkCheck = excuteInfo("LAST_SIGN_BEFORE", "DRAFT", doc, docID, userID, passWord, formURL);
				} else {
					linkCheck = excuteInfo("MIDDLE_SIGN_BEFORE", "DRAFT", doc, docID, userID, passWord, formURL);
				}
			}
		} else if (result.equals("B")) {
			if (aprStateSign.equals("011")) {
				linkCheck = excuteInfo("BANSONG_BEFORE", "SUSIN", doc, docID, userID, passWord, formURL);
			} else {
				linkCheck = excuteInfo("BANSONG_BEFORE", "DRAFT", doc, docID, userID, passWord, formURL);
			}
		}
		
		if (!linkCheck) {
			if (docNumFlag) {
				rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
			}
			
			if (mhtSaveFlag) {
				rollBackMHT(formURL, tempMht);
			}
			
			return "Link ERROR";
		}
		
		String result2 = updateHistoryForLine(docID, orgUID, displayName, displayName2, pTitle, pTitle, department, description, description2, chkFlag, companyID, userInfo.getTenantId());
		
		Document xmlResult = commonUtil.convertStringToDocument(result2);
		
		if (!xmlResult.getElementsByTagName("RESULT").item(0).getTextContent().equals("TRUE")) {
			if (docNumFlag) {
				rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
			}
			
			return "ERROR";
		}
		
		String tempHtml = doc.outerHtml();
		
		convertedMHT = ezCommonService.startHtml2Mht(tempHtml, realPath, userInfo.getLocale());
		tempMht = new File(formURL).getParentFile() + commonUtil.separator + docID + "_backup.mht";
		FileUtils.copyFile(new File(formURL), new File(tempMht));
		
		OutputStream outputStream = new FileOutputStream(new File(formURL));
		OutputStreamWriter output = new OutputStreamWriter(outputStream);
		
		output.write(convertedMHT);
		output.close();
		
		mhtSaveFlag = true;
		
		if (docNO.equals("") && doc.getElementById("docnumber") != null) {
			docNO = doc.getElementById("docnumber").text();
		}
		
		String docResult = getDocInfoSP(orgUID, docID, docNO, companyID, result, retNum, strLang, userID, orgDeptID, orgName, orgName2, userInfo.getTenantId());
		
		docResult = "<PARAMETER>" + docResult + "</PARAMETER>";
		
		if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007") && result.equals("A")) {
			Document paramXML = commonUtil.convertStringToDocument(docResult);
			String docNumCode = paramXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent();
			
			if (aprStateSign.equals("011")) {
				paramXML.getElementsByTagName("DOCNUMCODE").item(0).setTextContent("");
				paramXML.getElementsByTagName("ORGDOCNUMCODE").item(0).setTextContent("");
			} else {
				paramXML.getElementsByTagName("DOCNUMCODE").item(0).setTextContent(docNumCode + retNum);
			}
			
			docResult = commonUtil.convertDocumentToString(paramXML);
		}
		
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<SIGNINFOS>");
		
		if ((aprType.equals("008") || aprType.equals("009")) && result.equals("A")) {
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "HTML" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + signInfo + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + commonUtil.cleanValue(signText) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
			
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + signInfo2 + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + commonUtil.cleanValue(signText2) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
		} else {
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "HTML" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + signInfo + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + commonUtil.cleanValue(signText) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
		}
		
		resultXML.append("</SIGNINFOS>");
		
		if (result.equals("BR")) {
			strSql = "<RESULT>TRUE</RESULT>";
		} else if (result.equals("B") && !aprType.equals("009")) {
			strSql = "<RESULT>TRUE</RESULT>";
		} else if (result.equals("A") && (aprType.equals("002") || aprType.equals("007"))) {
			strSql = "<RESULT>TRUE</RESULT>";
		} else {
			strSql = updateSignInfo(resultXML, companyID, "SET", userInfo.getTenantId());
			signSaveFlag = true;
		}
		
		if (strSql.toUpperCase().equals("FALSE") || strSql.toUpperCase().equals("<RESULT>FALSE</RESULT>")) {
			if (signSaveFlag) {
				rollBackSignInfo(signNum, docID, companyID, signAdd, userInfo.getTenantId());
			}
			
			if (docNumFlag) {
				rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
			}
			
			if (mhtSaveFlag) {
				rollBackMHT(formURL, tempMht);
			}
			
			return "ERROR";
		} else {
			signSaveFlag = true;
			linkCheck = true;
			
			if (result.equals("A")) {
				if (aprStateSign.equals("011")) {
					if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
						linkCheck = excuteInfo("LAST_SIGN_AFTER", "SUSIN", doc, docID, userID, passWord, formURL);
					} else {
						linkCheck = excuteInfo("MIDDLE_SIGN_AFTER", "SUSIN", doc, docID, userID, passWord, formURL);
					}
				} else {
					if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
						linkCheck = excuteInfo("LAST_SIGN_AFTER", "DRAFT", doc, docID, userID, passWord, formURL);
					} else {
						linkCheck = excuteInfo("MIDDLE_SIGN_AFTER", "DRAFT", doc, docID, userID, passWord, formURL);
					}
				}
			}
			
			if (!linkCheck) {
				if (docNumFlag) {
					rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
				}
				
				if (mhtSaveFlag) {
					rollBackMHT(formURL, tempMht);
				}
				
				if (signSaveFlag) {
					rollBackSignInfo(signCnt, docID, companyID, signAdd, userInfo.getTenantId());
				}
				
				return "Link ERROR";
			}
			
			Document tempXmlDom = commonUtil.convertStringToDocument(docResult);
			
			String pDocResult = doProcess(docState, docID, orgUID, displayName, displayName2, realPath + commonUtil.getUploadPath("upload_approvalG.ROOT", userInfo.getTenantId()), department, "", tempXmlDom, userID, companyID, strLang, userInfo);
			
			Document xmlResult2 = commonUtil.convertStringToDocument(pDocResult);
			
			if (!xmlResult2.getElementsByTagName("RESULT").item(0).getTextContent().equals("TRUE")) {
				linkCheck = true;
				
				if (result.equals("A")) {
					if (aprStateSign.equals("011")) {
						if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
							linkCheck = excuteInfo("END_FAIL", "SUSIN", doc, docID, userID, passWord, formURL);
						} else {
							linkCheck = excuteInfo("MIDDLE_END_FAIL", "SUSIN", doc, docID, userID, passWord, formURL);
						}
					} else {
						if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
							linkCheck = excuteInfo("END_FAIL", "DRAFT", doc, docID, userID, passWord, formURL);
						} else {
							linkCheck = excuteInfo("MIDDLE_END_FAIL", "DRAFT", doc, docID, userID, passWord, formURL);
						}
					}
				} else if (result.equals("B")) {
					if (aprStateSign.equals("011")) {
						linkCheck = excuteInfo("BANSONG_FAIL", "SUSIN", doc, docID, userID, passWord, formURL);
					} else {
						linkCheck = excuteInfo("BANSONG_FAIL", "DRAFT", doc, docID, userID, passWord, formURL);
					}
				}
				
				if (!linkCheck) {
					if (docNumFlag) {
						rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
					} 
					
					if (mhtSaveFlag) {
						rollBackMHT(formURL, tempMht);
					}
					
					if (signSaveFlag) {
						rollBackSignInfo(signCnt, docID, companyID, signAdd, userInfo.getTenantId());
					}
					
					return "Link ERROR";
				}
				
				if (signSaveFlag) {
					rollBackSignInfo(signNum, docID, companyID, signAdd, userInfo.getTenantId());
				}
				
				if (docNumFlag) {
					rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
				} 
				
				if (mhtSaveFlag) {
					rollBackMHT(formURL, tempMht);
				}
				
				return "ERROR";
			} else {
				linkCheck = true;
				
				if (result.equals("A")) {
					if (aprStateSign.equals("011")) {
						if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
							linkCheck = excuteInfo("LAST_END_AFTER", "SUSIN", doc, docID, userID, passWord, formURL);
						} else {
							linkCheck = excuteInfo("MIDDLE_END_AFTER", "SUSIN", doc, docID, userID, passWord, formURL);
						}
					} else {
						if ((totalLineSN == Integer.parseInt(signNum.trim()) || aprType.equals("016") || aprType.equals("001")) && !aprType.equals("007")) {
							linkCheck = excuteInfo("LAST_END_AFTER", "DRAFT", doc, docID, userID, passWord, formURL);
						} else {
							linkCheck = excuteInfo("MIDDLE_END_AFTER", "DRAFT", doc, docID, userID, passWord, formURL);
						}
					}
				} else if (result.equals("B")) {
					if (aprStateSign.equals("011")) {
						linkCheck = excuteInfo("BANSONG_AFTER", "SUSIN", doc, docID, userID, passWord, formURL);
					} else {
						linkCheck = excuteInfo("BANSONG_AFTER", "DRAFT", doc, docID, userID, passWord, formURL);
					}
				}
				
				if (!linkCheck) {
					if (docNumFlag) {
						rollBackDocNumber(strDeptID, companyID, cabinetSN, docID, strLang, userInfo.getTenantId());
					} 
					
					if (mhtSaveFlag) {
						rollBackMHT(formURL, tempMht);
					}
					
					if (signSaveFlag) {
						rollBackSignInfo(signCnt, docID, companyID, signAdd, userInfo.getTenantId());
					}
					
					return "Link ERROR";
				}
				
				return "001";
			}
		}
	}

	private boolean rollBackSignInfo(String signNum, String docID, String companyID, String signAdd, int tenantID) throws Exception{
		boolean result = false;
		
		StringBuilder strQuery = new StringBuilder();
		
        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = '" + signAdd + "sign" + signNum + "' AND TENANT_ID =" + tenantID +"; ");
        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = '" + signAdd + "seumyung" + signNum + "' AND TENANT_ID =" + tenantID +"; ");
        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = '" + signAdd + "seumyungdate" + signNum + "' AND TENANT_ID =" + tenantID +"; ");

        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = 'habyui" + signNum + "' AND TENANT_ID =" + tenantID +"; ");
        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = 'habyuipositon" + signNum + "' AND TENANT_ID =" + tenantID +"; ");
        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = 'habyuisign" + signNum + "' AND TENANT_ID =" + tenantID +"; ");
        strQuery.append("DELETE FROM TBL_SIGNINFO WHERE DocID = '" + docID + "' ");
        strQuery.append("   AND SIGNNAME = 'habyuidate" + signNum + "' AND TENANT_ID =" + tenantID +"; ");
        
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("sqlString", "BEGIN " + strQuery.toString() + " END; ");
		
		try {
			ezApprovalGDAO.transactionSQL(map);
			
			result = true;
		} catch (Exception e) {
			result = false;
		}
		
		return result;
	}

	private String getDocInfoSP(String orgUID, String docID, String docNO, String companyID, String result, String retNum, String strLang, String userID, String orgDeptID, String orgName,	String orgName2, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PDOCNO", docNO.equals("") || docNO == null ? "" : docNO);
		map.put("v_TENANTID", tenantID);

		List<ApprGDocInfoWebSrvVO> apprGDocInfoWebSrvVOList = ezApprovalGDAO.getDocInfoSP(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocInfoWebSrvVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocInfoWebSrvVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document xmlDom = commonUtil.convertStringToDocument(sb.toString());
		
		String functionType = "";
		
		if (result.equals("A")) {
			functionType = "002";
		}
		
		xmlDom.getElementsByTagName("FUNCTIONTYPE").item(0).setTextContent(functionType);
		xmlDom.getElementsByTagName("PROXYUSERID").item(0).setTextContent(userID);
		xmlDom.getElementsByTagName("PUSERID").item(0).setTextContent(orgUID);
		xmlDom.getElementsByTagName("PDEPTID").item(0).setTextContent(orgDeptID);
		xmlDom.getElementsByTagName("PUSERNAME").item(0).setTextContent(orgName);
		xmlDom.getElementsByTagName("PUSERNAME2").item(0).setTextContent(orgName2);
		
		return commonUtil.convertDocumentToString(xmlDom);
	}

	private void rollBackMHT(String formURL, String tempMht) throws Exception{
		FileUtils.copyFile(new File(tempMht), new File(formURL));
		deleteFile(tempMht);
	}

	private void rollBackDocNumber(String strDeptID, String companyID, String cabinetSN, String docID, String lang, int tenantID) throws Exception{
		rollbackCabinetNum(strDeptID, "", cabinetSN, companyID, docID, lang, tenantID);
	}

	public boolean excuteInfo(String pProcessIdx, String draftFlag, org.jsoup.nodes.Document doc, String docID, String userID, String passWord, String formURL) throws Exception{
		boolean rtnVal = true;
		boolean findFlag;
		
		String connString = "";
		String connFlag = "";
		String queryString = "";
		String queryType = "";
		String processIdx, processTime;
		
		Document xmlData = null;
		NodeList connNodes = null;
		NodeList keyNodes = null;
		NodeList listKeyRow = null;
		Node connNode = null;
		Node tblInfoRow = null;
		
		Element htmlConn = doc.getElementById("conn");
		
		if (htmlConn != null && htmlConn.outerHtml().contains("CONNINFO")) {
			xmlData = commonUtil.convertStringToDocument(htmlConn.html());
			connNodes = xmlData.getFirstChild().getChildNodes();
		} else {
			return true;
		}
		
		findFlag = false;
		
		for (int cnt = 0; cnt < connNodes.getLength(); cnt++) {
			//확인해야됨 문법 제대로 검증안됨
			processIdx = connNodes.item(cnt).getAttributes().getNamedItem("processidx").getNodeValue();
			processTime = connNodes.item(cnt).getAttributes().getNamedItem("processtime").getNodeValue();
			
			if (processIdx.equals(pProcessIdx) && processTime.equals(draftFlag)) {
				findFlag = true;
				connNode = connNodes.item(cnt);
				break;
			}
		}
		
		if (findFlag) {
			connFlag = connNode.getChildNodes().item(0).getAttributes().getNamedItem("flag").getNodeValue();
			connString = connNode.getChildNodes().item(0).getTextContent();
			
			queryType = connNode.getChildNodes().item(1).getAttributes().getNamedItem("qtype").getNodeValue();
			queryString = connNode.getChildNodes().item(1).getTextContent();
			
			if (queryType.equals("UA") || queryType.equals("UA_EX") || connFlag.equals("UI")) {
				return false;
			}
			
			String strItemNames = "SA_draftUserID,SA_draftUserName,SA_draftDeptID,SA_draftDeptName,SA_draftPosition,SA_DocID,SA_OrgDocID,SYSTEM_ID,FORMID,HELPPATH";
			String[] arrItemNames = strItemNames.split(",");
			
			for (int k = 0; k < arrItemNames.length; k++) {
				Node root = connNode.getChildNodes().item(2);
				org.w3c.dom.Element ele = connNode.getChildNodes().item(2).getOwnerDocument().createElement("key");
				
				ele.setAttribute("kind", "single");
				ele.setTextContent(arrItemNames[k]);
				root.appendChild(ele);
				
				root = null;
				ele = null;
			}
			
			keyNodes = connNode.getChildNodes().item(2).getChildNodes();
			
			String keyValue = "";
			String[] arrKeys = null;
			
			switch (queryType) {
			case "Q":
				for (int cnt = 0; cnt < keyNodes.getLength(); cnt++) {
					String keys = keyNodes.item(cnt).getTextContent();
					Element keyHtml = doc.getElementById(keys);
					keyValue = "";
					
					if (keyHtml != null) {
						keyValue = keyHtml.html();
					}
				}
				break;
			case "NA":
				arrKeys = new String[keyNodes.getLength()];
				
				StringBuilder sb = new StringBuilder("<PARAMETER>");
				
				for (int cnt = 0; cnt < keyNodes.getLength(); cnt++) {
					if (keyNodes.item(cnt).getAttributes().getNamedItem("kind").getNodeValue().equals("single")) {
						String keys = keyNodes.item(cnt).getTextContent();
						Element keyHtml = doc.getElementById(keys);
						keyValue = "";
						
						sb.append("<" + keys + ">");
						
						String keyTagName = "";
						
						if (keyHtml != null) {
							keyTagName = keyHtml.tagName().toString();
						}
						
						if (keyTagName.equals("TD")) {
							sb.append(keyHtml.text());
						} else if (keyTagName.equals("SELECT")) {
							Elements selectEle = keyHtml.getElementsByTag("SELECT");
							sb.append(selectEle.val());
						} else {
							if (doc.body().getElementsByAttribute(keys).get(0) != null) {
								sb.append(doc.body().getElementsByAttribute(keys).get(0).toString());
							}
						}
						
						sb.append("</" + keys + ">");
					} else if (keyNodes.item(cnt).getAttributes().getNamedItem("kind").getNodeValue().equals("list")) {
						Document xmlTbl = null;
						Element htmlTbl = doc.getElementById("tblinfo");
						
						if (htmlTbl != null) {
							xmlTbl = commonUtil.convertStringToDocument(htmlTbl.text());
							
							String tblID = keyNodes.item(cnt).getAttributes().getNamedItem("tableid").getNodeValue();
							
							listKeyRow = keyNodes.item(cnt).getChildNodes();
							
							HTMLTableElement table = (HTMLTableElement) doc.getElementById(tblID);
							
							if (table != null) {
								sb.append("<RECORDROOT>");
								
								HTMLCollection trs = table.getRows();
								
								int tagIdx = 0;
								int offSet = 0;
								
								for (int j = 0; j < trs.getLength(); j++) {
									if (!trs.item(j).getAttributes().getNamedItem("header").toString().equals("") || !trs.item(j).getAttributes().getNamedItem("tail").toString().equals("")) {
										continue;
									}
									
									sb.append("<R" + tagIdx + " ");
									
									for (int k = 0; k < listKeyRow.getLength(); k++) {
										String fieldName = listKeyRow.item(k).getTextContent();
										
										tblInfoRow = (Node) xmlTbl.getElementsByTagName("/TableInfo/" + tblID);
										offSet = tblInfoRow.getChildNodes().getLength();
										
										String colIdx = "";
										int rowCnt = 0;
										
										for (rowCnt = 0; rowCnt < offSet; rowCnt++) {
											if (tblInfoRow.getChildNodes().item(rowCnt).getAttributes().getNamedItem(fieldName) != null) {
												colIdx = tblInfoRow.getChildNodes().item(rowCnt).getAttributes().getNamedItem(fieldName).getNodeValue();
												break;
											}
										}
										
										HTMLTableRowElement row = (HTMLTableRowElement) trs.item(j + rowCnt);
										HTMLElement cel = (HTMLElement) row.getCells().item(Integer.parseInt(colIdx));
										
										String cellValue = makeXMLString(cel.getTextContent());
										
										sb.append(fieldName + "=\"" + cellValue + "\" ");
										
									}
									
									sb.append("/>");
									
									j = j + (offSet - 1);
									tagIdx = tagIdx + 1;
								}
								
								sb.append("</RECORDROOT>");
							}
						}
					}
				}
				
				sb.append("<processTime>" + draftFlag + "</processTime>");
				sb.append("<processidx>" + pProcessIdx + "</processidx>");
				sb.append("</PARAMETER>");
				
				//그룹웨어 연동 페이지 인증 및 호출 함수 일단 생략 (추가여부는 추후 고려)
				break;
			}
		}
		
		return rtnVal;
	}

	public String getDocInfoDState(String docID, String col, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_COL", col);
		map.put("v_TENANTID", tenantID);
		
		return ezApprovalGDAO.getDocInfoDState(map);
	}

	public int getDocInfoJeonKyul(String docID, String orgUID, String aprState, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", orgUID);
		map.put("v_PAPRSTATE", aprState);
		map.put("v_TENANTID", tenantID);
		
		return ezApprovalGDAO.getDocInfoJeonKyul(map);
	}

	public int getDocInfoHab(String docID, String orgUID, String aprState, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", orgUID);
		map.put("v_PAPRSTATE", aprState);
		map.put("v_TENANTID", tenantID);

		return ezApprovalGDAO.getDocInfoHab(map);
	}

	public int getDocInfoRef(String docID, String orgUID, String aprState, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", orgUID);
		map.put("v_PAPRSTATE", aprState);
		map.put("v_TENANTID", tenantID);
		
		return ezApprovalGDAO.getDocInfoRef(map);
	}

	public int getDocAprCnt(String docID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		return ezApprovalGDAO.getDocAprCnt(map);
	}

	public String getDocAprLine(String docID, String userID, String docState, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", userID);
		map.put("v_PAPRSTATE", docState);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getDocAprLine(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getDocAprState(String docID, String userID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", userID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getAprLineInfoAprState(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document xmlDom = commonUtil.convertStringToDocument(sb.toString());
		
		String state = xmlDom.getElementsByTagName("APRSTATE").item(0).getTextContent();
		
		return state;
	}

	@Override
	public List<ApprGgetDeptStacticsVO> getDeptStactics(String pStartDate, String pEndDate, String pLang ,String  companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pStartDate", pStartDate);
		map.put("v_pEndDate", pEndDate);
		map.put("iv_pLang", pLang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		if(pLang.equals("1")){
			map.put("v_pLang", "");
		} else{
			map.put("v_pLang", pLang);
		}
		
		return ezApprovalGDAO.getDeptStactics(map);
	}

	private String getSendOutDocList(String mode, int querySize, int querySize2, String orderOption1, String orderOption2, String basicOrder, String basicOrderReverse, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", mode);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		if(orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0,7).toLowerCase());
		}
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_ORDEROPTION2LENGTH", orderOption2.length());
		if(orderOption2.length() > 0) {
			map.put("v_ORDEROPTION2VALUE", orderOption2.substring(0,7).toLowerCase());
		}
		map.put("v_BASICORDER", basicOrder);
		map.put("v_BASICORDER2", basicOrderReverse);
		map.put("v_TENANTID", tenantID);
		map.put("v_MODELENGTH", mode.trim().length());

		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getSendOutDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	private int getSendOutDocListCount(String mode, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", mode);
		map.put("v_TENANTID", tenantID);
		map.put("v_MODELENGTH", mode.trim().length());

		int totalCount = ezApprovalGDAO.getSendOutDocListCount(map);
		
		return totalCount;
	}

	private boolean gongRamActivate(String docID, String companyID, String lang, int tenantID) throws Exception{
		String gongRamOption = getCode2Name("A56", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		boolean rtnVal = true;
		
		if (gongRamOption.toUpperCase().trim().equals("Y")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_APRMEMBERSN", 0);
			map.put("v_FLAG", "1");
			map.put("v_TENANTID",tenantID);
			
			try {
				ezApprovalGDAO.gongRamActivateAprState(map);
				
				rtnVal = true;
			} catch (Exception e) {
				rtnVal = false;
			}
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_TENANTID", tenantID);
			
			int gongRamCount = ezApprovalGDAO.gongRamActivateCount(map);
			
			if (gongRamCount == 0) {
				ApprGLineTempletVO apprGLineTempletVOList = ezApprovalGDAO.gongRamActivateLineInfo(map);
				
				if (apprGLineTempletVOList != null) {
					sendMsg(docID, apprGLineTempletVOList.getAprMemberID(), "ING", companyID, lang, tenantID);
					
					map.put("v_APRMEMBERSN", apprGLineTempletVOList.getAprMemberSN());
					map.put("v_FLAG", "2");
					
					try {
						ezApprovalGDAO.gongRamActivateAprState(map);
						
						rtnVal = true;
					} catch (Exception e) {
						rtnVal = false;
					}
				}
			}
		}
		
		return rtnVal;
	}

	private String getGamSaSearchDocList(String containerID, String userID, String deptID, String userSecurityCode, boolean publicFlag, String subQuery, String docNumber, String docTitle,
			String drafter, String draftDeptName, String formID, String tmpStartDate1, String tmpStartDate2, String tmpEndDate1, String tmpEndDate2, String tmpProcessDate1,
			String tmpProcessDate2, String aprFlag, String docState, int querySize, int querySize2, String orderOption1, String orderOption2, String langType, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERSECCODE", userSecurityCode);
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		map.put("v_DOCNUMBER", docNumber);
		map.put("v_DOCTITLE", docTitle);
		map.put("v_DRAFTER", drafter);
		map.put("v_DEPTNAME", draftDeptName);
		map.put("v_FORMID", formID.trim());
		map.put("v_STARTDATE1", tmpStartDate1);
		map.put("v_STARTDATE2", tmpStartDate2);
		map.put("v_ENDDATE1", tmpEndDate1);
		map.put("v_ENDDATE2", tmpEndDate2);
		map.put("v_PROCESSDATE1", tmpProcessDate1);
		map.put("v_PROCESSDATE2", tmpProcessDate2);
		map.put("iv_APRFLAG", aprFlag);
		map.put("v_DOCSTATE", docState);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_LANGTYPE", langType);
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getGamSaSearchDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();		
	}

	private int getGamSaSearchDocListCount(String containerID, String userID, String deptID, String userSecurityCode, boolean publicFlag, String subQuery, String docNumber, String docTitle,
			String drafter, String draftDeptName, String formID, String tmpStartDate1, String tmpStartDate2, String tmpEndDate1, String tmpEndDate2, String tmpProcessDate1,
			String tmpProcessDate2, String aprFlag, String docState, String langType, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERSECCODE", userSecurityCode);
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		map.put("v_DOCNUMBER", docNumber);
		map.put("v_DOCTITLE", docTitle);
		map.put("v_DRAFTER", drafter);
		map.put("v_DEPTNAME", draftDeptName);
		map.put("v_FORMID", formID.trim());
		map.put("v_STARTDATE1", tmpStartDate1);
		map.put("v_STARTDATE2", tmpStartDate2);
		map.put("v_ENDDATE1", tmpEndDate1);
		map.put("v_ENDDATE2", tmpEndDate2);
		map.put("v_PROCESSDATE1", tmpProcessDate1);
		map.put("v_PROCESSDATE2", tmpProcessDate2);
		map.put("iv_APRFLAG", aprFlag);
		map.put("v_DOCSTATE", docState.trim());
		map.put("v_LANGTYPE", langType);
		
		int resultCnt = ezApprovalGDAO.getGamSaSearchDocListCount(map);
		
		return resultCnt;
	}

	private String getContDocList(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, int querySize, int querySize2, String orderOption1,
			String orderOption2, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if(orderOption1.length() > 0){
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0,7).toLowerCase());
		}
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_ORDEROPTION2LENGTH", orderOption2.length());
		
		if(orderOption2.length() > 0){
			map.put("v_ORDEROPTION2VALUE", orderOption2.substring(0,7).toLowerCase());
		}
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getContDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	private int getContDocListCount(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERSECCODE", userSecurityCode);
		
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		
		int totalCount = ezApprovalGDAO.getContDocListCount(map);
		
		return totalCount;
	}

	@Override
	public String deleteOpinionInfo(String docID, String companyID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		String rtnVal = "";
		
		try {
			ezApprovalGDAO.deleteOpinionInfo(map);
			ezApprovalGDAO.updateOpinionInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String updateOpinionInfo(Document docXML, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String docID = docXML.getElementsByTagName("ROW").item(0).getChildNodes().item(4).getTextContent();
		String rtnVal = deleteOpinionInfo(docID, companyID, lang, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
				
				map.put("v_DOCID", docID);
				map.put("v_USERID", docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(5).getTextContent());
				map.put("v_OPINIONGB", docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent());
				map.put("v_CONTENT", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent()));
				map.put("v_USERNAME", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(10).getTextContent()));
				map.put("v_USERNAME2", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent()));
				map.put("v_USERJOBTITLE", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(12).getTextContent()));
				map.put("v_USERJOBTITLE2", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(13).getTextContent()));
				map.put("v_USERDEPTID", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(7).getTextContent()));
				map.put("v_USERDEPTNAME", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(14).getTextContent()));
				map.put("v_USERDEPTNAME2", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent()));
				map.put("v_OPINIONSN", makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getTextContent()));
				map.put("v_TENANTID", tenantID);

				
				try {
					ezApprovalGDAO.insertOptionInfo(map);
					
					rtnVal = "<RESULT>TRUE</RESULT>";
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return rtnVal = "<RESULT>FALSE</RESULT>";
				}

			}
			
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);

			try {
				ezApprovalGDAO.updateAprDocOptionInfo(map);
				
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

				return rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}
		
		return rtnVal;
	}

	@Override
	public String getDocHrefYear(String docID, String companyID, int tenantID) throws Exception {
		String rtnValue = commonUtil.getTodayUTCTime("yyyy");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_PDOCID", docID);
		
		String href = ezApprovalGDAO.getDocHrefYear(map);
		
		if (href != null) {
			String[] arry = href.split("/");
			
			if (arry.length >= 7 && arry[4].length() == 4) {
				rtnValue = arry[4];
			}
		}
		
		return rtnValue;
	}

	@Override
	public String getDocDir(String docID) throws Exception {
		String tempHref = "";

		if (docID.length() == 0) {
			tempHref = docID;
		} else {
			tempHref = String.valueOf((Integer.parseInt(docID.substring(docID.length() - 3, docID.length())) % 1000));
		}
		
		return tempHref;
	}

	@Override
	public String getAttachFileInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		listString = getListHeader("041", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_TENANTID", tenantID);
		map.put("v_ORDERBY", orderOption1);
		map.put("v_ORDERBYLENGTH", orderOption1.length());
		
		if (orderOption1.length() > 0){
			map.put("v_ORDERBYVALUE", orderOption1.trim().toLowerCase().substring(0, 12));
		}
		List<ApprGAttachInfoVO> apprGAttachInfoVOList = ezApprovalGDAO.getAttachFileInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAttachInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAttachInfoVOList.get(i)));
		}
		sb.append("</DATA>");

		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.toUpperCase().equals("ATTACHUSERNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("ATTACHFILEHREF").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("ATTACHFILESN").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("ATTACHUSERID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ATTACHUSERJOBTITLE").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTNAME").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("ATTACHFILESIZE").item(k).getTextContent() + "bytes") + "</DATA8>");
					resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("PAGENUM").item(k).getTextContent()) + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("ATTACHFILENAME").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("BODYATTACH").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("DISPLAYNAME").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("ATTACHUSERNAME").item(k).getTextContent()) + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("ATTACHUSERNAME2").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("ATTACHUSERJOBTITLE").item(k).getTextContent()) + "</DATA15>");
					resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("ATTACHUSERJOBTITLE2").item(k).getTextContent()) + "</DATA16>");
					resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTNAME").item(k).getTextContent()) + "</DATA17>");
					resultXML.append("<DATA18>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTNAME2").item(k).getTextContent()) + "</DATA18>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String updateHistoryForAttach(String docID, String attachSN, String tempUserID, String tempUserName, String tempUserName2, String tempUserJobTitle, String tempUserJobTitle2,
			String tempUserDeptID, String tempUserDeptName, String tempUserDeptName2, String modifyFlag, String dirPath, String companyID, int tenantID) throws Exception {
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID.trim());
		map.put("v_ATTACHFILESN", attachSN.trim());
		map.put("v_TENANTID", tenantID);
		int strSN = ezApprovalGDAO.updateHistoryForAttach_M(map) + 1;
		List<ApprGAttachInfoVO> apprGAttachInfoVOList = ezApprovalGDAO.updateHistoryForAttach_I(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAttachInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAttachInfoVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("ATTACHFILENAME").getLength() > 0) {
			String oldYear = getDocHrefYear(docID, companyID, tenantID);
			String source = convWebToPath(docXML.getElementsByTagName("ATTACHFILEHREF").item(0).getTextContent(), dirPath, tenantID);
			String target = dirPath + commonUtil.separator + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + "history" + commonUtil.separator +
							getDocDir(docID) + commonUtil.separator + docID.trim() + getNDigitNum(attachSN, 4) + getNDigitNum(String.valueOf(strSN), 4) + docXML.getElementsByTagName("ATTACHFILENAME").item(0).getTextContent();
			
			FileUtils.copyFile(new File(source), new File(target));
			
			target = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + "history" + commonUtil.separator +
					 getDocDir(docID) + commonUtil.separator + docID.trim() + getNDigitNum(attachSN, 4) + getNDigitNum(String.valueOf(strSN), 4) + docXML.getElementsByTagName("ATTACHFILENAME").item(0).getTextContent();
		
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("companyID", companyID);
			map1.put("v_DOCID", docID.trim());
			map1.put("v_ATTACHSN", attachSN.trim());
			map1.put("v_ATTACHNAME", docXML.getElementsByTagName("ATTACHFILENAME").item(0).getTextContent());
			map1.put("v_ATTACHDISPNAME", docXML.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
			map1.put("v_ATTACHHREF", target);
			map1.put("v_ATTACHSIZE", docXML.getElementsByTagName("ATTACHFILESIZE").item(0).getTextContent());
			map1.put("v_USERID", tempUserID);
			map1.put("v_USERNAME", tempUserName);
			map1.put("v_USERNAME2", tempUserName2);
			map1.put("v_USERJOBTITLE", tempUserJobTitle);
			map1.put("v_USERJOBTITLE2", tempUserJobTitle2);
			map1.put("v_USERDEPTID", tempUserDeptID);
			map1.put("v_USERDEPTNAME", tempUserDeptName);
			map1.put("v_USERDEPTNAME2", tempUserDeptName2);
			map1.put("v_MODIFYSN", String.valueOf(strSN));
			map1.put("v_MODIFYFLAG", modifyFlag.trim());
			map1.put("v_PAGENUM", docXML.getElementsByTagName("PAGENUM").item(0).getTextContent());
			map1.put("v_TENANTID", tenantID);
			map1.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));

		
			try {
				ezApprovalGDAO.updateHistoryForAttach(map1);
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				System.out.println(e.getMessage());
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}

		return rtnVal;
	}

	@Override
	public String updateAttachFileInfo(Document xmlDom, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String docID = xmlDom.getElementsByTagName("ROW").item(0).getChildNodes().item(3).getTextContent();
		String rtnVal = deleteAttachFileInfo(docID, companyID, lang, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();

		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			String size = "";
			for (int k = 0; k < xmlDom.getElementsByTagName("ROW").getLength(); k++) {
				size = xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getTextContent().replace("bytes", "").trim();
				
				map.put("v_DOCID", docID);
				map.put("v_ATTACHFILESN", xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(2).getTextContent());
				map.put("v_ATTACHFILENAME", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(10).getTextContent()));
				map.put("v_ATTACHFILEHREF", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent()));
				map.put("v_ATTACHFILESIZE", size);
				map.put("v_ATTACHUSERID", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(4).getTextContent()));
				map.put("v_ATTACHUSERNAME", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(13).getTextContent()));
				map.put("v_ATTACHUSERNAME2", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(14).getTextContent()));
				map.put("v_ATTACHUSERJOBTITLE", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent()));
				map.put("v_ATTACHUSERJOBTITLE2", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(16).getTextContent()));
				map.put("v_ATTACHUSERDEPTID", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent()));
				map.put("v_ATTACHUSERDEPTNAME", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(17).getTextContent()));
				map.put("v_ATTACHUSERDEPTNAME2", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(18).getTextContent()));
				map.put("v_PAGENUM", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent()));
				map.put("v_DISPLAYNAME", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(12).getTextContent()));
				map.put("v_BODYATTACH", makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent()));
				map.put("v_TENANTID", tenantID);
				
				try {
					ezApprovalGDAO.insertAprAttachInfo(map);
					
					ezApprovalGDAO.updateAprDocAttachInfo(map);
					rtnVal = "<RESULT>TRUE</RESULT>";
				} catch (Exception e) {
					rtnVal = "<RESULT>FALSE</RESULT>";
				}
			}
		}
		
		return rtnVal;
	}

	@Override
	public String deleteAttachFileInfo(String docID, String companyID, String lang, int tenantID) {
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		try {
			ezApprovalGDAO.deleteAttachFileInfo(map);
			int attachFile = ezApprovalGDAO.countAttachFile(map);
			if (attachFile > 0) {
				map.put("FLAG", "Y");
				ezApprovalGDAO.updateAttachFileInfo(map);
			} else {
				map.put("FLAG", "N");
				ezApprovalGDAO.updateAttachFileInfo(map);
			}
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String getListInfoXml(String listFlag, String listType, String companyID, String lang,LoginVO userInfo) throws Exception {
		String typeCode = getListTypeCode(listFlag, listType, userInfo);
		String szListXml = getListInfo(typeCode, companyID, lang, userInfo.getTenantId());
		
		return szListXml;
	}

	@Override
	public String getRecordList(Document doc, String lang, int tenantID, String offset) throws Exception {
		LOGGER.debug("getRecordList started.");

		StringBuilder strSQL = new StringBuilder();
		StringBuilder strSQLCnt = new StringBuilder();
		StringBuilder resultXML = new StringBuilder();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String deptCode = doc.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent().trim();
		String userID = doc.getElementsByTagName("USERID").item(0).getTextContent().trim();
		String transFlag = doc.getElementsByTagName("TRANSFLAG").item(0).getTextContent().trim();
		String listFlag = doc.getElementsByTagName("LISTFLAG").item(0).getTextContent().trim();
		String orderBy = doc.getElementsByTagName("ORDERBY").item(0).getTextContent().trim();
		String pageSize = doc.getElementsByTagName("PAGESIZE").item(0).getTextContent().trim();
		String pageNo = doc.getElementsByTagName("PAGENO").item(0).getTextContent().trim();
		String selectClause = "";
		String extraSelectClause = "";
		String fromClause = "";
		String cabJoinClause = "";
		String strWhereClause = "";
		String listType = "001";
		boolean usePublicFlag = false;
		String multiLang = commonUtil.getMultiData(lang, tenantID);
		String offSetMin = commonUtil.getMinuteUTC(offset);

		switch (listFlag) {
		case "0" :	// 기록물 대장
			listType = "001";
			usePublicFlag = true;
			break;

		case "1" :	// 편철확정대상 기록물
			listType = "001";
			break;

		case "2" :	// 기록물 생산현황
			listType = "003";
			break;

		case "3" :	// 목록이관 대상
			listType = "005";
			break;

		case "4" :	// 파일이관 대상
			listType = "005";
			strWhereClause = " And CatalogTransferFlag='1' And " + 
				"(DocTransferFlag='0' OR DocTransferFlag IS NULL) " + 
				"And TBL_RECORD.DocID IS NOT NULL And SeperateAttachNo='00' ";
			break;

		case "5" :	// 이관목록
			listType = "005";
			strWhereClause = " And DocTransferFlag='1' And " +
                "DocTransferYear=(Select Max(DocTransferYear) From TBL_SEPERATEATTACH)  ";
			break;

		case "6" :	// 연기신청목록
			listType = "007";
			break;

		case "7" :	// 폐기대상 기록물
			listType = "001";

			String DFlag = getCode2Name("A35", "003", companyID, lang, tenantID).toUpperCase().trim();
			LOGGER.debug("getCode2Name ended.");

			if (DFlag == "Y") {
				// 사학 G버전. 폐기 대상은 완료 연도부터 보존기간 경과한 기록물.
				strWhereClause = " AND TBL_CABINET.TerminateFlag = '1' AND " + 
						commonUtil.getTodayUTCTime("yyyy") + " - TBL_CABINET.ExpirationYear > TBL_CABINET.KeepingPeriod ";
			} else {
				// 일반 G버전. 폐기 대상은 이관된 기록물.
				strWhereClause = " And DocTransferFlag='1' ";
			}
			break;

		case "9" :	// 첨부대상 기록물
			listType = "001";
			usePublicFlag = true;
			strWhereClause = " And (TBL_RECORD.DocID IS NOT NULL And TBL_CABINET.OwnerDeptID='" +
				deptCode + "' And SeperateAttachNo='00') ";
			break;

		case "10" :	// 접수목록
			listType = "001";
			usePublicFlag = true;
			strWhereClause = " And (TBL_ENDAPRDOCINFO.DocState='011' OR TBL_RECORD.DocType ='2') ";
			break;

		case "11" :	// 발송목록
			listType = "001";
			usePublicFlag = true;
			strWhereClause = " And (TBL_ENDAPRDOCINFO.DocState='014' OR TBL_RECORD.DocType ='1') ";
			break;
		}
		
		if (usePublicFlag) {
			if (getIsUse("A22", "001", companyID, lang, tenantID).equals("1")) {
				usePublicFlag = true; //보안등급 사용여부
			} else {
				usePublicFlag = false;
			}
		}
		if (orderBy.equals("")) {
			orderBy = " Order By CreateDate DESC, RecordID DESC, SEPERATEATTACHNO ASC ";
		}
		//다국어 추가 소스 수정
		selectClause = "SELECT ROW_NUMBER() OVER( " + orderBy + " ) AS ROWNUM_,  N.* FROM ( "+
                " SELECT TBL_RECORD.RecordID, TBL_RECORD.DocID, TBL_RECORD.RegisterNo, TBL_SEPERATEATTACH.CreateDate+ '" + offSetMin +"'/(24*60) as CreateDate, " +
                "TBL_ENDAPRDOCINFO.DocType, TBL_SEPERATEATTACH.RegisterType, TBL_ENDAPRDOCINFO.DocState," +   // 2011.04.06 수신문서 공람지정할수 있도록 DocState 추가
                "TBL_SEPERATEATTACH.CabinetID, TBL_SEPERATEATTACH.SeperateAttachNo , " + 
				"TBL_ENDAPRDOCINFO.Href, TBL_ENDAPRDOCINFO.ContainerID, TBL_ENDAPRDOCINFO.FormID, " + 
				"TBL_ENDAPRDOCINFO.WriterID, TBL_CABINET.ConfirmFlag, TBL_CABINET.CabinetClassNo, " + 
				"TBL_CABINET.ProcessDeptCode AS CabDeptCode, TBL_CABINET.OwnerDeptID, " + 
                "TBL_RECORD.RegisterDate + '" + offSetMin +"'/(24*60) as RegisterDate, TBL_RECORD.AprMemberTitle" + multiLang + " as AprMemberTitle, TBL_RECORD.DrafterName" + multiLang + " as DrafterName, TBL_RECORD.AttachFlag, " +
				"TBL_CABINET.OwnerTask, TBL_RECORD.RejectFlag , TBL_RECORD.ReceiptMemberName" + multiLang + " as ReceiptName ";
		
        fromClause = " FROM TBL_RECORD Left Join TBL_ENDAPRDOCINFO " + 
			"On TBL_RECORD.DocID=TBL_ENDAPRDOCINFO.DocID AND TBL_RECORD.TENANT_ID=TBL_ENDAPRDOCINFO.TENANT_ID Inner Join TBL_SEPERATEATTACH " +
            "On TBL_RECORD.RecordID=TBL_SEPERATEATTACH.RecordID AND TBL_RECORD.TENANT_ID=TBL_SEPERATEATTACH.TENANT_ID ";

		if (usePublicFlag) {
            fromClause += " Left Join TBL_EXPENDAPRDOCINFO " + 
				"On TBL_RECORD.DocID=TBL_EXPENDAPRDOCINFO.DocID AND TBL_RECORD.TENANT_ID=TBL_EXPENDAPRDOCINFO.TENANT_ID";

			selectClause += ", TBL_EXPENDAPRDOCINFO.SecurityApproval ";
		}
		
		String arrListInfo = getLVFieldInfo(listType, companyID, lang, tenantID);
		Document arrList = commonUtil.convertStringToDocument(arrListInfo);
		
		for (int k = 0; k < arrList.getElementsByTagName("SELECTFIELD").getLength(); k++) {
			if (!makeListField(arrList.getElementsByTagName("COLNAME").item(k).getTextContent()).equals("")) {
				if (selectClause.toUpperCase().indexOf(arrList.getElementsByTagName("COLNAME").item(k).getTextContent().toUpperCase().trim()) < 0) {
					extraSelectClause += ", " + arrList.getElementsByTagName("SELECTFIELD").item(k).getTextContent().trim();
				} else if (selectClause.toUpperCase().indexOf(arrList.getElementsByTagName("COLALIAS").item(k).getTextContent().toUpperCase().trim()) < 0) {
					extraSelectClause += ", " + arrList.getElementsByTagName("SELECTFIELD").item(k).getTextContent().trim();
				}
			}
		}
		
		cabJoinClause = getCabJoinClause(doc, deptCode, transFlag, listFlag, companyID, tenantID);
		
		if (doc.getElementsByTagName("RECDEPTCODE").item(0) != null && doc.getElementsByTagName("RECDEPTCODE").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBL_RECORD.ProcessDeptCode = '" + makeRightField(doc.getElementsByTagName("RECDEPTCODE").item(0).getTextContent().trim()) + "' ";
		}

		if (doc.getElementsByTagName("TITLE").item(0) != null && doc.getElementsByTagName("TITLE").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBL_SEPERATEATTACH.Title Like N'%" + makeSearchField(doc.getElementsByTagName("TITLE").item(0).getTextContent().trim()) + "%' ";
		}

		if (doc.getElementsByTagName("REGTYPE").item(0) != null && doc.getElementsByTagName("REGTYPE").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBL_SEPERATEATTACH.RegisterType = '" + makeRightField(doc.getElementsByTagName("REGTYPE").item(0).getTextContent().trim()) + "' ";
		}
		if (doc.getElementsByTagName("SREGDATE").item(0) != null && doc.getElementsByTagName("SREGDATE").item(0).getTextContent().length() > 0) {
            strWhereClause += " AND TBL_RECORD.RegisterDate >= TO_DATE('" + commonUtil.getDateStringInUTC(makeRightField(doc.getElementsByTagName("SREGDATE").item(0).getTextContent().trim().substring(0, 19)), offset , false) + "','YYYY.MM.DD HH24:MI:SS') ";
		}
		
		if (doc.getElementsByTagName("EREGDATE").item(0) != null && doc.getElementsByTagName("EREGDATE").item(0).getTextContent().length() > 0) {
            strWhereClause += " AND TBL_RECORD.RegisterDate <= TO_DATE('" + commonUtil.getDateStringInUTC(makeRightField(doc.getElementsByTagName("EREGDATE").item(0).getTextContent().trim().substring(0, 19)), offset , false) + "','YYYY.MM.DD HH24:MI:SS') ";
		}
		
		if (doc.getElementsByTagName("SC").item(0) != null && doc.getElementsByTagName("SC").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBL_RECORD.RecordID IN (Select RecordID " +
                "From TBL_SPECIALCATALOGINFO_REC Where SC1 Like N'%" +
				makeSearchField(doc.getElementsByTagName("SC").item(0).getTextContent().trim()) + "%' OR SC2 Like N'%" +
				makeSearchField(doc.getElementsByTagName("SC").item(0).getTextContent().trim()) + "%' OR SC3 Like N'%" + 
				makeSearchField(doc.getElementsByTagName("SC").item(0).getTextContent().trim()) + "%') ";
		}
		
        if (doc.getElementsByTagName("DRAFTER").item(0) != null && doc.getElementsByTagName("DRAFTER").item(0).getTextContent().length() > 0) {
            strWhereClause += " AND (TBL_RECORD.DrafterName Like N'%" + makeSearchField(doc.getElementsByTagName("DRAFTER").item(0).getTextContent().trim()) + "%' ";
            strWhereClause += " OR TBL_RECORD.DrafterName2 Like N'%" + makeSearchField(doc.getElementsByTagName("DRAFTER").item(0).getTextContent().trim()) + "%') ";
        }
        
        if (usePublicFlag) {
        	String userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6", tenantID);
        	
        	if (userSecurityCode == null || userSecurityCode.equals(" ") || userSecurityCode.equals("")) {
        		userSecurityCode = "0";
        	}
        	
        	if (getIsUse("A22", "005", companyID, lang, tenantID).equals("1")) {
        		strWhereClause += " AND (TBL_EXPENDAPRDOCINFO.SecurityCode >= '" + userSecurityCode + "' OR TBL_EXPENDAPRDOCINFO.SecurityCode IS NULL or ( SELECT 'Y' FROM DUAL WHERE 0 < (" +
                                 "SELECT COUNT(DocID) FROM TBL_ENDAPRLINEINFO WHERE  DocID = TBL_RECORD.DocID  AND AprMemberID = '"+ userID +"' AND TENANT_ID = "+tenantID+") OR TBL_RECORD.DocID = NULL ) = 'Y') AND TBL_RECORD.TENANT_ID= "+ tenantID;
        	} else {
        		strWhereClause += " AND (TBL_EXPENDAPRDOCINFO.SecurityCode >= '" + userSecurityCode + "' OR TBL_EXPENDAPRDOCINFO.SecurityCode IS NULL) AND TBL_RECORD.TENANT_ID= "+ tenantID;
        	}
        }
        
        strSQL.append(selectClause);
        strSQL.append(extraSelectClause);
        strSQL.append(fromClause);
        strSQL.append(cabJoinClause);
        strSQL.append(" Where TBL_RECORD.DelFlag='0' AND TBL_SEPERATEATTACH.DelFlag='0' AND TBL_RECORD.TENANT_ID =" + tenantID);
        strSQL.append(strWhereClause);
        
        int start = 0, end = 0;
        
        if (doc.getElementsByTagName("ISDOCPRINT").item(0) != null && doc.getElementsByTagName("ISDOCPRINT").item(0).getTextContent().length() > 0 && doc.getElementsByTagName("ISDOCPRINT").item(0).getTextContent().trim().equals("TRUE")) {
        	end = Integer.parseInt(doc.getElementsByTagName("PAGENO").item(0).getTextContent().trim());
        	start = Integer.parseInt(doc.getElementsByTagName("PAGESIZE").item(0).getTextContent().trim());
        } else {
        	end = Integer.parseInt(pageSize) * Integer.parseInt(pageNo);
        	start = end - Integer.parseInt(pageSize) + 1;
        }
        
        if (doc.getElementsByTagName("ISDOCPRINT").item(0) != null && doc.getElementsByTagName("ISDOCPRINT").item(0).getTextContent().length() > 0 && doc.getElementsByTagName("ISDOCPRINT").item(0).getTextContent().trim().equals("TRUE") && start < 0) {
        	strSQL.append(" ) N ) A ");
        } else {
        	strSQL.append(" ) N ) A WHERE ROWNUM_ BETWEEN " + start + " AND " + end);
        }
        
        strSQLCnt.append(fromClause);
        strSQLCnt.append(cabJoinClause);
        strSQLCnt.append(" Where TBL_RECORD.DelFlag='0' AND TBL_SEPERATEATTACH.DelFlag='0' AND TBL_RECORD.TENANT_ID =" + tenantID);
        strSQLCnt.append(strWhereClause);
        
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("sqlString", strSQL.toString());
		map.put("companyID", companyID);

        List<ApprGRecordVO> apprGRecordVOList = ezApprovalGDAO.getRecordList(map);
        
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGRecordVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGRecordVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("sqlString", strSQLCnt.toString());
		map1.put("companyID", companyID);
		
		int docCnt = ezApprovalGDAO.getRecordListCount(map1);
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALDOCCOUNT>" + docCnt + "</TOTALDOCCOUNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < arrList.getElementsByTagName("ROW").getLength(); k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + arrList.getElementsByTagName("NAME").item(k).getTextContent().trim() + "</NAME>");
			resultXML.append("<WIDTH>" + arrList.getElementsByTagName("WIDTH").item(k).getTextContent().trim() + "</WIDTH>");
			
			if (arrList.getElementsByTagName("COLNAME").item(k).getTextContent().trim().toUpperCase().equals("TBL_RECORD.ATTACHFLAG")) {
				resultXML.append("<COLNAME>" + "HASATTACHYN" + "</COLNAME>");
			}
			if (arrList.getElementsByTagName("COLNAME").item(k).getTextContent().trim().toUpperCase().equals("TBL_RECORD.REJECTFLAG")) {
				resultXML.append("<COLNAME>" + "REJECTFLAG" + "</COLNAME>");
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		resultXML.append("<ROWS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int p = 0; p < arrList.getElementsByTagName("COLALIAS").getLength(); p++) {
				String fieldName = arrList.getElementsByTagName("COLALIAS").item(p).getTextContent().trim().toUpperCase();
				
				resultXML.append("<CELL>");
				resultXML.append("<VALUE>");
				
				switch (arrList.getElementsByTagName("DTYPE").item(p).getTextContent().trim()) {
				case "dtSerialNum" :						// 순번
                    resultXML.append(docXML.getElementsByTagName("ROWNUM_").item(k).getTextContent());
					break;

				case "dtCabClassNo" :						// 기록물철 분류번호
					//분류번호(처리과기관코드+단위업무번호+생산년도+기록물철등록연번+권호수)
					resultXML.append(getCabinetNo(makeListField(docXML.getElementsByTagName("CABDEPTCODE").item(k).getTextContent()),
							makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()),
							makeListField(docXML.getElementsByTagName("PRODUCTIONYEAR").item(k).getTextContent()),
							makeListField(docXML.getElementsByTagName("REGSERIALNO").item(k).getTextContent()),
							makeListField(docXML.getElementsByTagName("VOLUMENO").item(k).getTextContent())));
					break;

				case "dtRegisterNo" :						// 기록물 등록번호
					//기록물 등록번호(처리과기관코드+기록물등록연번)
					resultXML.append(getRecRegSNToName(makeListField(docXML.getElementsByTagName("RECDEPTNAME").item(k).getTextContent()),
						makeListField(docXML.getElementsByTagName("RECREGSN").item(k).getTextContent())));
					break;

				case "dtRegisterType" :						// 등록구분
					resultXML.append(getRegTypeString(makeListField(docXML.getElementsByTagName("REGISTERTYPE").item(k).getTextContent()), companyID, commonUtil.getPrimaryData(lang, tenantID), tenantID));
					break;

				case "dtBool" :								// Y/N 형식의 데이터 타입
					String tempValue = makeListField(docXML.getElementsByTagName(fieldName).item(k).getTextContent().trim());
					if (tempValue.equals("1")) {
						resultXML.append("Y");
					} else {
						resultXML.append("N");
					}
					break;

				case "dtDate" :								// 날짜 타입(시간제외)
					resultXML.append(formatDateForView(makeListField(docXML.getElementsByTagName(fieldName).item(k).getTextContent()), 1));
					break;

				case "dtDateTime" :								// 날짜 타입(시간포함)
					resultXML.append(formatDateForView(makeListField(docXML.getElementsByTagName(fieldName).item(k).getTextContent()), 0));
					break;

				default:
					resultXML.append(makeListField(docXML.getElementsByTagName(fieldName).item(k).getTextContent()));
					break;
				}
				
				resultXML.append("</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("WRITERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("RECORDID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("CABINETID").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("SEPERATEATTACHNO").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("CONFIRMFLAG").item(k).getTextContent()) + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("OWNERDEPTID").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("REGISTERTYPE").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("REJECTFLAG").item(k).getTextContent()) + "</DATA13>");
					
					if (usePublicFlag) {
						resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("SECURITYAPPROVAL").item(k).getTextContent()) + "</DATA14>");
					}
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent()) + "</DATA15>");
				}
				
				
				if (fieldName.toUpperCase().equals("ATTACHFLAG")) {
					resultXML.append("<HASATTACHYN>" + docXML.getElementsByTagName("ATTACHFLAG").item(k).getTextContent() + "</HASATTACHYN>");
				}
				
				if (fieldName.toUpperCase().equals("REJECTFLAG")) {
					resultXML.append("<REJECTFLAG>" + docXML.getElementsByTagName("REJECTFLAG").item(k).getTextContent() + "</REJECTFLAG>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>"); 
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		LOGGER.debug("getRecordList ended.");

 		return resultXML.toString();
	}

	@Override
	public String getCodeInfo(String companyID, String lang, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGCabCodeVO> apprGCabCodeVOList = ezApprovalGDAO.getCodeInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGCabCodeVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGCabCodeVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		resultXML.append("<CODELIST>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<RECORDTYPE>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("000")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</RECORDTYPE>");
		
		resultXML.append("<KEEPINGMETHOD>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("001")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</KEEPINGMETHOD>");
			
		resultXML.append("<KEEPINGPLACE>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("002")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</KEEPINGPLACE>");
		
		resultXML.append("<REGISTERTYPE>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("003")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</REGISTERTYPE>");
		
		resultXML.append("<KEEPINGPERIOD>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("004")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</KEEPINGPERIOD>");
		
		resultXML.append("<SPECIALRECORD>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("005")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</SPECIALRECORD>");
		
		resultXML.append("<SECURITYLEVEL>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("006")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</SECURITYLEVEL>");
		
		resultXML.append("<RECORDINGAVTYPE>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("008")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</RECORDINGAVTYPE>");
		
		resultXML.append("<PHOTOAVTYPE>");
		for (int k = 0; k < dlength; k++) {
			String strCodeType = docXML.getElementsByTagName("CODETYPE").item(k).getTextContent();
			if (strCodeType.equals("009")) {
				resultXML.append("<CODE>");
				resultXML.append("<CODENUM>" + makeListField(docXML.getElementsByTagName("CODE").item(k).getTextContent()) + "</CODENUM>");
				
				if (commonUtil.getPrimaryData(lang, tenantID).equals("1")) {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent()) + "</DESCRIPTION>");
				} else {
					resultXML.append("<DESCRIPTION>" + makeListField(docXML.getElementsByTagName("NAME2").item(k).getTextContent()) + "</DESCRIPTION>");
				}
				resultXML.append("</CODE>");
			}
		}
		resultXML.append("</PHOTOAVTYPE>");
		
		resultXML.append("</CODELIST>");
		
		return resultXML.toString();
	}

	@Override
	public String getAttachDocInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("042", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_TENANTID", tenantID);
		map.put("v_ORDERBY", orderOption1);
		map.put("v_ORDERBYLENGTH", orderOption1.length());
		
		if ( orderOption1.length() >0) {
			map.put("v_ORDERBYVALUE", orderOption1.trim().toLowerCase().substring(0, 8));
		}
		
		List<ApprGDocAttachInfoVO> apprGDocAttachInfoVOList = ezApprovalGDAO.getAttachDocInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocAttachInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocAttachInfoVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("ATTACHDOCURL").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("ATTACHSN").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("ATTACHUSERID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ATTACHUSERJOBTITLE").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTNAME").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("ATTACHUSERNAME").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("SUBATTACHYN").item(k).getTextContent()) + "</DATA9>");
					resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("ATTACHDOCNAME").item(k).getTextContent()) + "</DATA10>");
					resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("ATTACHUSERNAME2").item(k).getTextContent()) + "</DATA11>");
					resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("ATTACHUSERJOBTITLE2").item(k).getTextContent()) + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTNAME2").item(k).getTextContent()) + "</DATA13>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String isCabCharger(String companyID, String cabClassNo, String userID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CabClassNo", cabClassNo);
		map.put("v_UserID", userID);
		map.put("v_TENANTID", tenantID);
		
		int result = ezApprovalGDAO.isCabCharger(map);
		
		return "<RESULT>" + result + "</RESULT>";
	}

	@Override
	public String updateAttachDocInfo(Document docXML, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String docID = "";
		
		if (docXML.getElementsByTagName("DATA3").item(0) != null) {
			docID = docXML.getElementsByTagName("DATA3").item(0).getTextContent();
		}
		String rtnVal = deleteAttachDocInfo(docID, companyID, lang, tenantID);
		int tempSN = 0;
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			for (int k = 0; k < docXML.getElementsByTagName("DATA1").getLength(); k++) {
				tempSN = docXML.getElementsByTagName("DATA1").getLength() - k;
				
				strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, AttachDocName, ");
                strSQL.append("AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
                strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID) VALUES ('");
				strSQL.append(docID + "', '" + tempSN + "', N'");
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA10").item(k).getTextContent()) + "', N'");
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA1").item(k).getTextContent()) + "', '");
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA9").item(k).getTextContent()) + "', '");
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA4").item(k).getTextContent()) + "', N'");
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA11").item(k).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("DATA12").item(k).getTextContent()) + "', N'");    //USERNAME2
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA13").item(k).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("DATA14").item(k).getTextContent()) + "', '");     //JOBTITLE
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA6").item(k).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("DATA15").item(k).getTextContent()) + "', N'");
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA16").item(k).getTextContent()) + "',"+ tenantID +");\n");    //DEPTNAME2
			}
			strSQL.append("UPDATE TBL_APRDOCINFO SET HasAttachYN = 'Y' WHERE DocID = '" + docID + "'"+"AND TENANT_ID =" + tenantID +";");
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			
			try {
				ezApprovalGDAO.transactionSQL(map);
				
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}
		
		return rtnVal;
	}

	@Override
	public String deleteAttachDocInfo(String docID, String companyID, String lang, int tenantID) throws Exception{
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		try {
			ezApprovalGDAO.deleteAttachDocInfo(map);
			int countAttachDoc = ezApprovalGDAO.countAttachDocInfo(map);
			
			if(countAttachDoc > 0 ){
				map.put("FLAG", "Y");
				ezApprovalGDAO.updateAttachDocInfo(map);
			} else {
				map.put("FLAG", "N");
				ezApprovalGDAO.updateAttachDocInfo(map);
			}
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String getDocInfo(String docID, String mode, String selected, String companyID, int tenantID) throws Exception {
		StringBuilder rtnXML = new StringBuilder();
		String selectSQL = "";
		
		if (selected.substring(0, 1).equals(";")) {
			selected = "";
		}
		
		String[] selecteds = selected.split(";");
	
		if (selected.toUpperCase().equals("ALL")) {
			selectSQL = "*";
		} else {
			for (int k = 0; k < selecteds.length; k++) {
				if (!selecteds[k].trim().equals("")) {
					if (k == 0) {
						selectSQL = selecteds[k];
					} else {
						selectSQL += ", " + selecteds[k];
					}
				}
			}
		}
		
		if (docID == null || docID.equals("")) {
			return "<DATA></DATA>";
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode.toUpperCase());
		map.put("v_COLS", selectSQL);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getDocInfo(map);
		
		if (apprGDocListVOList.size() == 0) {
			return "<DATA></DATA>";
		}
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		rtnXML.append("<DATA>");
		
		if (selected.toUpperCase().equals("ALL")) {
			rtnXML.append("<DOCID>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCID").item(0).getTextContent())) + "</DOCID>");
			rtnXML.append("<FORMID>" + makeXMLString(makeListField(docXML.getElementsByTagName("FORMID").item(0).getTextContent())) + "</FORMID>");
			rtnXML.append("<ORGDOCID>" + makeXMLString(makeListField(docXML.getElementsByTagName("ORGDOCID").item(0).getTextContent())) + "</ORGDOCID>");
			rtnXML.append("<DOCTYPE>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCTYPE").item(0).getTextContent())) + "</DOCTYPE>");
			rtnXML.append("<DOCSTATE>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent())) + "</DOCSTATE>");
			rtnXML.append("<FUNCTIONTYPE>" + makeXMLString(makeListField(docXML.getElementsByTagName("FUNCTIONTYPE").item(0).getTextContent())) + "</FUNCTIONTYPE>");
			rtnXML.append("<HREF>" + makeXMLString(makeListField(docXML.getElementsByTagName("HREF").item(0).getTextContent())) + "</HREF>");
			rtnXML.append("<DOCTITLE>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCTITLE").item(0).getTextContent())) + "</DOCTITLE>");
			rtnXML.append("<DOCNO>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCNO").item(0).getTextContent())) + "</DOCNO>");
			rtnXML.append("<HASATTACHYN>" + makeXMLString(makeListField(docXML.getElementsByTagName("HASATTACHYN").item(0).getTextContent())) + "</HASATTACHYN>");
			rtnXML.append("<HASOPINIONYN>" + makeXMLString(makeListField(docXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent())) + "</HASOPINIONYN>");
            rtnXML.append("<STARTDATE>" + makeXMLString(makeListField(convertDate(docXML.getElementsByTagName("STARTDATE").item(0).getTextContent()))) + "</STARTDATE>");
            rtnXML.append("<ENDDATE>" + makeXMLString(makeListField(convertDate(docXML.getElementsByTagName("ENDDATE").item(0).getTextContent()))) + "</ENDDATE>");
			rtnXML.append("<WRITERID>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERID").item(0).getTextContent())) + "</WRITERID>");
			rtnXML.append("<WRITERNAME>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent())) + "</WRITERNAME>");
            rtnXML.append("<WRITERJOBTITLE>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERJOBTITLE").item(0).getTextContent())) + "</WRITERJOBTITLE>");
			rtnXML.append("<WRITERDEPTID>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent())) + "</WRITERDEPTID>");
            rtnXML.append("<WRITERDEPTNAME>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent())) + "</WRITERDEPTNAME>");
			rtnXML.append("<ISPUBLIC>" + makeXMLString(makeListField(docXML.getElementsByTagName("ISPUBLIC").item(0).getTextContent())) + "</ISPUBLIC>");
			rtnXML.append("<SECURITYCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("SECURITYCODE").item(0).getTextContent())) + "</SECURITYCODE>");
			rtnXML.append("<STORAGEPERIOD>" + makeXMLString(makeListField(docXML.getElementsByTagName("STORAGEPERIOD").item(0).getTextContent())) + "</STORAGEPERIOD>");
			rtnXML.append("<URGENTAPPROVAL>" + makeXMLString(makeListField(docXML.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent())) + "</URGENTAPPROVAL>");
			rtnXML.append("<TEMPATTRIBUTE>" + makeXMLString(makeListField(docXML.getElementsByTagName("TEMPATTRIBUTE").item(0).getTextContent())) + "</TEMPATTRIBUTE>");
			rtnXML.append("<ITEMCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("ITEMCODE").item(0).getTextContent())) + "</ITEMCODE>");
			rtnXML.append("<ITEMNAME>" + makeXMLString(makeListField(docXML.getElementsByTagName("ITEMNAME").item(0).getTextContent())) + "</ITEMNAME>");
			rtnXML.append("<KEYWORD>" + makeXMLString(makeListField(docXML.getElementsByTagName("KEYWORD").item(0).getTextContent())) + "</KEYWORD>");
			rtnXML.append("<SPECIALRECORDCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim())) + "</SPECIALRECORDCODE>");
			rtnXML.append("<PUBLICITYCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim())) + "</PUBLICITYCODE>");
			rtnXML.append("<LIMITRANGE>" + makeXMLString(makeListField(docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim())) + "</LIMITRANGE>");
			rtnXML.append("<PAGENUM>" + makeXMLString(makeListField(docXML.getElementsByTagName("PAGENUM").item(0).getTextContent())) + "</PAGENUM>");
			rtnXML.append("<CABINETID>" + makeXMLString(makeListField(docXML.getElementsByTagName("CABINETID").item(0).getTextContent().trim())) + "</CABINETID>");
			rtnXML.append("<TASKCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("TASKCODE").item(0).getTextContent().trim())) + "</TASKCODE>");
			rtnXML.append("<DOCNUMCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent().trim())) + "</DOCNUMCODE>");
			rtnXML.append("<ORGDOCNUMCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim())) + "</ORGDOCNUMCODE>");
			rtnXML.append("<SEPERATEATTACHXML>" + makeXMLString(makeListField(docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent().trim())) + "</SEPERATEATTACHXML>");
			rtnXML.append("<SUMMARY>" + makeXMLString(makeListField(docXML.getElementsByTagName("SUMMARY").item(0).getTextContent().trim())) + "</SUMMARY>");
			rtnXML.append("<SECURITYAPPROVAL>" + makeXMLString(makeListField(docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent())) + "</SECURITYAPPROVAL>");
            rtnXML.append("<ITEMNAME2>" + makeXMLString(makeListField(docXML.getElementsByTagName("ITEMNAME2").item(0).getTextContent())) + "</ITEMNAME2>");
            rtnXML.append("<WRITERNAME2>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent())) + "</WRITERNAME2>");
            rtnXML.append("<WRITERJOBTITLE2>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERJOBTITLE2").item(0).getTextContent())) + "</WRITERJOBTITLE2>");
            rtnXML.append("<WRITERDEPTNAME2>" + makeXMLString(makeListField(docXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent())) + "</WRITERDEPTNAME2>");
		} else {
			for (int k = 0; k < selecteds.length; k++) {
				if (!selecteds[k].trim().equals("")) {
					rtnXML.append("<" + selecteds[k].toUpperCase() + ">");
					rtnXML.append(makeXMLString(makeListField(docXML.getElementsByTagName(selecteds[k].toUpperCase()).item(0).getTextContent())));
					rtnXML.append("</" + selecteds[k].toUpperCase() + ">");
				}
			}
		}
		
		rtnXML.append("</DATA>");
		
		return rtnXML.toString();
	}

	@Override
	public String saveRecReadHist(String readRecXML, int tenantID) throws Exception {
		Document doc = commonUtil.convertStringToDocument(readRecXML);
		
		String result = "";
		String docID = doc.getElementsByTagName("DOCID").item(0).getTextContent();
		String userID = doc.getElementsByTagName("USERID").item(0).getTextContent();
		String userName = doc.getElementsByTagName("USERNAME").item(0).getTextContent();
		String userName2 = doc.getElementsByTagName("USERNAME2").item(0).getTextContent();
		String userTitle = doc.getElementsByTagName("USERTITLE").item(0).getTextContent();
		String userTitle2 = doc.getElementsByTagName("USERTITLE2").item(0).getTextContent();
		String deptCode = doc.getElementsByTagName("DEPTCODE").item(0).getTextContent();
		String deptName = doc.getElementsByTagName("DEPTNAME").item(0).getTextContent();
		String deptName2 = doc.getElementsByTagName("DEPTNAME2").item(0).getTextContent();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DocID", docID);
		map.put("v_UserID", userID);
		map.put("v_UserName", userName);
		map.put("v_UserName2", userName2);
		map.put("v_UserTitle", userTitle);
		map.put("v_UserTitle2", userTitle2);
		map.put("v_DeptCode", deptCode);
		map.put("v_DeptName", deptName);
		map.put("v_DeptName2", deptName2);
		map.put("v_TENANTID", tenantID);
		
		try {
			ezApprovalGDAO.saveRecReadHist(map);
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String receiverChk(String deptID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		int rtnVal = ezApprovalGDAO.receiverChk(map);
		
		if (rtnVal == 0) {
			return "false";
		} else {
			return "true";
		}
	}

	@Override
	public String getEA5Value(String msg,int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CNVALUE", msg);
		map.put("v_TENANTID", tenantID);
		
		List<OrganUserVO> organUserVOList = ezApprovalGDAO.getEA5Value(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < organUserVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(organUserVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getMyTaskCode(String userID, String deptID, String companyID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getMyTaskCode(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
			docXML.getElementsByTagName("RECTYPECODE").item(k).setTextContent(getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, lang, tenantID));
		}
		
		return commonUtil.convertDocumentToString(docXML);
	}

	@Override
	public String setMyTaskCode(String userID, String deptID, String cabinetID, String taskCode, String type, String companyID, int tenantID) throws Exception {
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_CABINETID", cabinetID);
		map.put("v_TASKCODE", taskCode);
		map.put("v_TYPE", type);
		map.put("v_TENANTID", tenantID);

		try {
			ezApprovalGDAO.setMyTaskCode(map);
			result = "OK";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	@Override
	public String getCabinetInfo(String cabinetID, String companyID, String strType, int tenantID) throws Exception {
		StringBuilder strXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CABINETID", cabinetID.trim());
		map.put("v_TENANTID", tenantID);
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getCabinetInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("ROW").getLength() <= 0) {
			return "<RESULT>NORECORD</RESULT>";
		}
		
		strXML.append("<RESULT>");
		strXML.append("<CABCLASSNO>" + docXML.getElementsByTagName("CABINETCLASSNO").item(0).getTextContent().trim() + "</CABCLASSNO>");
		strXML.append("<TITLE>" + docXML.getElementsByTagName("TITLE").item(0).getTextContent() + "</TITLE>");
		strXML.append("<TITLE2>" + docXML.getElementsByTagName("TITLE2").item(0).getTextContent() + "</TITLE2>");
		strXML.append("<DEPTCODE>" + docXML.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent().trim() + "</DEPTCODE>");
		strXML.append("<VOLNO>" + docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent() + "</VOLNO>");
		strXML.append("<TASKCODE>" + docXML.getElementsByTagName("TASKCODE").item(0).getTextContent() + "</TASKCODE>");
		strXML.append("<CATECODE>" + docXML.getElementsByTagName("CATEGORYCODE").item(0).getTextContent() + "</CATECODE>");
		strXML.append("<MCATECODE>" + docXML.getElementsByTagName("MCATEGORYCODE").item(0).getTextContent() + "</MCATECODE>");
		strXML.append("<SCATECODE>" + docXML.getElementsByTagName("SUBCATEGORYCODE").item(0).getTextContent() + "</SCATECODE>");
		strXML.append("<REGSN>" + docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent() + "</REGSN>");
		strXML.append("<DISPCABCLASSNO>" + getCabinetNo(docXML.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent(), docXML.getElementsByTagName("TASKCODE").item(0).getTextContent(), docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent(), docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent(), docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent()) + "</DISPCABCLASSNO>");
		strXML.append("<RECTYPE>" + docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent() + "</RECTYPE>");
		strXML.append("<PRODUCEYEAR>" + docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent() + "</PRODUCEYEAR>");
		strXML.append("<RECTYPEDES>" + getRecordTypeString(docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent(), companyID, strType, tenantID) + "</RECTYPEDES>");
		strXML.append("<DISPFLAG>" + docXML.getElementsByTagName("DISPLAYRECFLAG").item(0).getTextContent() + "</DISPFLAG>");
		strXML.append("<DISPENDDATE>" + docXML.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent().trim() + "</DISPENDDATE>");
		strXML.append("<CABTRANSFLAG>" + docXML.getElementsByTagName("CABINETTRANSFERFLAG").item(0).getTextContent() + "</CABTRANSFLAG>");
		strXML.append("<TCABID>" + docXML.getElementsByTagName("TCABINETID").item(0).getTextContent() + "</TCABID>");
		strXML.append("<TDEPTCODE>" + docXML.getElementsByTagName("TDEPTCODE").item(0).getTextContent() + "</TDEPTCODE>");
		strXML.append("<SCFLAG>" + docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent() + "</SCFLAG>");
		strXML.append("<SCINFO>");
		strXML.append("<LIST1>" + docXML.getElementsByTagName("SC1").item(0).getTextContent() + "</LIST1>");
		strXML.append("<LIST2>" + docXML.getElementsByTagName("SC2").item(0).getTextContent() + "</LIST2>");
		strXML.append("<LIST3>" + docXML.getElementsByTagName("SC3").item(0).getTextContent() + "</LIST3>");
		strXML.append("</SCINFO>");
		strXML.append("</RESULT>");
		
		return strXML.toString();
	}

	@Override
	public String registerSepAttach(Document doc, int tenantID) throws Exception {
		String strSQL = "";
		
		String recID = doc.getElementsByTagName("RECORDID").item(0).getTextContent();
		String cabID = doc.getElementsByTagName("CABINETID").item(0).getTextContent();
		String title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
		String numOfPage = doc.getElementsByTagName("NUMOFPAGE").item(0).getTextContent();
		String regType = doc.getElementsByTagName("REGTYPE").item(0).getTextContent();
		String summary = doc.getElementsByTagName("SUMMARY").item(0).getTextContent();
		String recType = doc.getElementsByTagName("AVTYPE").item(0).getTextContent();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		strSQL = registerSepAttachEx(recID, cabID, title, numOfPage, regType, summary, recType, companyID, "", tenantID);
		
		if (strSQL.equals("FALSE")) {
			return "<RESULT>FALSE</RESULT>";
		} else {
				return "<RESULT>TRUE</RESULT>";
		}
	}

	@Override
	public String getHistoryForDoc(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("064", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if (orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.toLowerCase().substring(0,10));
		}
		map.put("v_TENANTID", tenantID);
		
		List<ApprGHistoryDocVO> apprGHistoryDocVOList = ezApprovalGDAO.getHistoryForDoc(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGHistoryDocVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGHistoryDocVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("CHANGEUSERNAME") || fieldName.equals("CHANGEUSERJOBTITLE") || fieldName.equals("CHANGEUSERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("URL").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("CHANGEUSERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("CHANGEUSERDEPTID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("CHKFLAG").item(k).getTextContent()) + "</DATA5>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getHistoryForLine(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("062", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if(orderOption1.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.toLowerCase().substring(0,10));
		}
		
		List<ApprGHistoryLineVO> apprGHistoryLineVOList = ezApprovalGDAO.getHistoryForLine(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGHistoryLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGHistoryLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("MODIFYUSERNAME") || fieldName.equals("MODIFYUSERJOBTITLE") || fieldName.equals("MODIFYUSERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("MODIFYSN").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("MODIFYUSERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("MODIFYUSERDEPTID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("CHKFLAG").item(k).getTextContent()) + "</DATA5>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getHistoryForAttach(String docID, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("061", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if(orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.toLowerCase().substring(0, 10));
		}
		map.put("v_TENANTID", tenantID);

		List<ApprGHistoryAttachVO> apprGHistoryAttachVOList = ezApprovalGDAO.getHistoryForAttach(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGHistoryAttachVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGHistoryAttachVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("ATTACHUSERNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("ATTACHFILENAME").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("ATTACHFILEDISPLAYNAME").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("ATTACHFILEHREF").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ATTACHUSERID").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("ATTACHUSERDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("MODIFYFLAG").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("CHKFLAG").item(k).getTextContent()) + "</DATA8>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getHistoryForLineDetail(String docID, String modifySN, String sortHeader, String sortOption, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("063", companyID, lang, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (sortOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if(orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.toLowerCase().substring(0, 10));
		}
		map.put("v_MODIFYSN", modifySN.trim());
		map.put("v_TENANTID", tenantID);
		List<ApprGHistoryLineVO> apprGHistoryLineVOList = ezApprovalGDAO.getHistoryForLineDetail(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGHistoryLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGHistoryLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("APRMEMBERNAME") || fieldName.equals("APRMEMBERJOBTITLE") || fieldName.equals("APRMEMBERDEPTNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(k).getTextContent()) + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("APRMEMBERSN").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("CHKFLAG").item(k).getTextContent()) + "</DATA5>");
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String deleteTmpDocInfo(String userID, String sn, String path, String companyID, String lang, int tenantID) throws Exception {
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PUSERID", userID.trim());
		map.put("v_PSN", sn);
		map.put("v_TENANTID", tenantID);
		
		try {
			String href = ezApprovalGDAO.selectHrefDocInfo(map); 
			ezApprovalGDAO.deleteTmpDocInfo(map);
			
			File file = new File(path + href);
			file.delete();
			
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String doProcess(String aprState, String docID, String userID, String userName, String userName2, String dirPath, String deptID, String html, Document strXML, String proxyUserID,
			String companyID, String lang, LoginVO userInfo) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		String result = "";
		boolean rtnVal = true;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_USERID", userID.trim());
		LOGGER.debug("doProcess param : v_DOCID =" + docID.trim() + " v_TENANTID =" + userInfo.getTenantId() + " v_USERID =" + userID.trim());

		try{
		int aprCount = ezApprovalGDAO.doProcessCount(map);
		
		LOGGER.debug("doProcess value : aprCount =" + aprCount);
		LOGGER.debug("doProcess aprState =" + aprState);

		if (aprCount < 1 && !aprState.equals(staASmikyul)) {
			rtnVal = false;
		} else {
			switch (aprState) {
			case "000":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				break;
				
			case "003":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				if (rtnVal) {
					subSQL = doApprove(docID, userID, aprState, userName, userName2, dirPath, deptID, proxyUserID, companyID, lang, userInfo);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				break;
				
			case "004":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				if (rtnVal) {
					subSQL = doBansong(docID, userID, aprState, dirPath, companyID, lang, userInfo);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				break;
				
			case "005":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				if (rtnVal) {
					subSQL = doBoryu(docID, userID, aprState, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				break;
				
			case "001":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}

				if (rtnVal) {
					subSQL = makeTmpDocInfo(userID, docID, proxyUserID, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				break;
			}
		}
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return result = "<RESULT>FALSE</RESULT>";
		}
		
		chkDocDelete(docID, docID, rtnVal, userID, deptID, dirPath, companyID, userInfo.getTenantId());
		
		if (rtnVal) {
			result = "<RESULT>TRUE</RESULT>";
		} else {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String getTotalAttachSize(String docID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		int temp = ezApprovalGDAO.getTotalAttachSizeTemp(map);
		if ( temp > 0 ) {
			map.put("v_temp" , "1");
		} else {
			map.put("v_temp" , "0");
		}
		List<ApprGAttachInfoVO> apprGAttachInfoVOList = ezApprovalGDAO.getTotalAttachSize(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAttachInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAttachInfoVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String chkAprLines(Document resultXML, String lang, LoginVO userInfo) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<RESULT>");
		for (int k = 0; k < resultXML.getElementsByTagName("ROW").getLength(); k++) {
			rtnVal.append(chkAprLine(resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(18).getTextContent().trim(), 
					resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(19).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(22).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(23).getTextContent().trim(), 
					resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(20).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(21).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent().trim(), lang, userInfo));
		}
		
		rtnVal.append("</RESULT>");

		return rtnVal.toString();
	}

	@Override
	public String chkDeptLines(Document resultXML, String companyID, String lang, LoginVO userInfo) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		String susinGroupIcon = getCode2Name("A53", "001", companyID, lang, userInfo.getTenantId());
		LOGGER.debug("getCode2Name ended.");

		rtnVal.append("<RESULT>");
		
		for (int k = 0; k < resultXML.getElementsByTagName("ROW").getLength(); k++) {
			if (!resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent().trim().substring(0, susinGroupIcon.length()).equals(susinGroupIcon)) {
				if (resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(3).getTextContent().trim().equals("N")) {
					rtnVal.append(chkAprLine(resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent().trim(), "", 
							resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent().trim(), "", resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent().trim(), "", 
							resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent().trim(), lang, userInfo));
				}
			}
		}
		
		rtnVal.append("</RESULT>");
		
		return rtnVal.toString();
	}

	@Override
	public String getOpinionCount(String docID, String userID, String ingFlag, String companyID, String lang, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_USERID", userID);
		map.put("v_INGFLAG", ingFlag.trim().toUpperCase());
		map.put("v_TENANTID", tenantID);
		
		int result = ezApprovalGDAO.getOpinionCount(map);
		
		return String.valueOf(result);
	}

	@Override
	public String updateHistoryForLine(String docID, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName,
			String userDeptName2, String chkFlag, String companyID, int tenantID) throws Exception{
		boolean addFlag = true;
		
		if (!chkFlag.equals("MUST")) {
			addFlag = compareLineHistory(docID, companyID, tenantID);
		}
		
		boolean rtn = true;
		
		if (addFlag) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", docID.trim());
			map.put("v_USERID", userID.trim());
			map.put("v_USERNAME", userName.trim());
			map.put("v_USERNAME2", userName2.trim());
			map.put("v_USERJOBTITLE", userJobTitle.trim());
			map.put("v_USERJOBTITLE2", userJobTitle2.trim());
			map.put("v_DEPTID", userDeptID.trim());
			map.put("v_DEPTNAME", userDeptName.trim());
			map.put("v_DEPTNAME2", userDeptName2.trim());
			map.put("v_TENANTID", tenantID);

			try {
				ezApprovalGDAO.updateHistoryForLine(map);
				rtn = true;
			} catch (Exception e) {
				rtn = false;
			}
		}
		
		if (rtn) {
			return "<RESULT>TRUE</RESULT>";
		} else {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getApprovalPWD1(String dUserID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", dUserID);
		map.put("v_TENANTID", tenantID);

		return ezApprovalGDAO.getApprovalPWD1(map);
	}

	@Override
	public String getApproveDocInfo(String docID, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<APROVEDATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_DOCID", docID.trim());
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getApproveDocInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document signXML = commonUtil.convertStringToDocument(sb.toString());
		
		String docState = "";
		String docType = "";
		String orgDocID = "";
		String href = "";
		
		if (signXML.getDocumentElement().getChildNodes().getLength() > 0) {
			docState = makeXMLString(makeListField(signXML.getElementsByTagName("DOCSTATE").item(0).getTextContent()));
			docType = makeXMLString(makeListField(signXML.getElementsByTagName("DOCTYPE").item(0).getTextContent()));
			orgDocID = makeXMLString(makeListField(signXML.getElementsByTagName("ORGDOCID").item(0).getTextContent()));
			href = makeListField(signXML.getElementsByTagName("HREF").item(0).getTextContent());
		}
		
		rtnVal.append("<DOCFLAGINFO>");
		
		if (!docState.trim().equals("")) {
			switch (docState) {
			case "001" :	// staDSPumYui 
				rtnVal.append("<DocFlag>DRAFT</DocFlag>");
				rtnVal.append("<DocFlagValue>" + docType + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;

			case "015" :		// staDSGongRam
				rtnVal.append("<DocFlag>GONGRAM</DocFlag>");
				rtnVal.append("<DocFlagValue>" + orgDocID + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;

			case "017" :			// staDSChamJo
				rtnVal.append("<DocFlag>CHAMJO</DocFlag>");
				rtnVal.append("<DocFlagValue>" + orgDocID + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;

			case "011" :			// staDSSuSin
				rtnVal.append("<DocFlag>SUSIN</DocFlag>");
				rtnVal.append("<DocFlagValue>" + orgDocID + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;

			case "012" :			// staDSHabYui
				rtnVal.append("<DocFlag>HABYUI</DocFlag>");
				rtnVal.append("<DocFlagValue>" + docType + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;

			case "014" :			// staDSGamSaBu
				rtnVal.append("<DocFlag>B_GAMSA</DocFlag>");
				rtnVal.append("<DocFlagValue>" + docType + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;
           
			case "003" :			// staDSGamSa
				rtnVal.append("<DocFlag>GAMSA</DocFlag>");
				rtnVal.append("<DocFlagValue>" + docType + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;

			case "018" :			// staDSWhokyul
				rtnVal.append("<DocFlag>A_GAMSA</DocFlag>");
				rtnVal.append("<DocFlagValue>" + docType + "</DocFlagValue>");
				rtnVal.append("<DocHref>" + href + "</DocHref>");
				break;
			}
		}
		
		rtnVal.append("</DOCFLAGINFO>");
		rtnVal.append("<DOCINFO>");
		rtnVal.append(getDocInfo(docID, "APR", "ALL", companyID, tenantID));
		rtnVal.append("</DOCINFO>");
		rtnVal.append("<ATTACHINFO>");
		rtnVal.append(getAttachInfo(docID, "APR", "", "", companyID, lang, tenantID, offset));
		rtnVal.append("</ATTACHINFO>");
		rtnVal.append("<APRLINEINFO>");
		rtnVal.append(getAprLineInfo(docID, "", "", companyID, lang, tenantID, offset));
		rtnVal.append("</APRLINEINFO></APROVEDATA>");
		
		return rtnVal.toString();
	}

	@Override
	public String getLastOpinionContent(String docID, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		
		String rtnXML = makeListField(ezApprovalGDAO.getLastOpinionContent(map));
		
		return rtnXML;
	}

	@Override
	public String getSignInfo(String docID, String companyID, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<SIGNINFOS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		map.put("v_DOCID", docID.trim());
		
		List<ApprGSignInfoVO> apprGSignInfoVOList = ezApprovalGDAO.getSignInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGSignInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGSignInfoVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<APRSN>" + makeListField(docXML.getElementsByTagName("APRSN").item(k).getTextContent()) + "</APRSN>");
			resultXML.append("<SIGNTYPE>" + makeListField(docXML.getElementsByTagName("SIGNTYPE").item(k).getTextContent()) + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + makeListField(docXML.getElementsByTagName("SIGNNAME").item(k).getTextContent()) + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + makeXMLString(makeListField(docXML.getElementsByTagName("CONTENT").item(k).getTextContent())) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
		}
		
		resultXML.append("</SIGNINFOS>");
		
		return resultXML.toString();
	}

	@Override
	public String getCabinetNum(String deptID, String subID, String companyID, String docID, String lang, int tenantID) throws Exception {
		String strXML = "";
		
		strXML = "<PARAMETERS><TYPE1>002</TYPE1><TYPE2>" + deptID.trim() +
                "</TYPE2><TYPE3>" + subID.trim() + "</TYPE3><COMPANYID>" +
                companyID.trim() + "</COMPANYID><DOCID>" + docID + "</DOCID><LANGTYPE>" + lang + "</LANGTYPE></PARAMETERS>";
		
		String rtnVal = getRegSN(strXML, tenantID);
		
		return "<REGNUM>" + rtnVal + "</REGNUM>";
	}
	
	
	public String getCabinetNum(String deptID, String subID, String companyID, int tenantID) throws Exception {
		String strXML = "";
		
		strXML = "<PARAMETERS><TYPE1>002</TYPE1><TYPE2>" + deptID.trim() +
				"</TYPE2><TYPE3>" + subID.trim() + "</TYPE3><COMPANYID>" +
				companyID.trim() + "</COMPANYID></PARAMETERS>";
		
		String rtnVal = getRegSN(strXML, tenantID);
		
		return "<REGNUM>" + rtnVal + "</REGNUM>";
	}

	@Override
	public String rollbackCabinetNum(String deptID, String subID, String sn, String companyID, String docID, String lang, int tenantID) throws Exception {
		String strXML = "";
		
		strXML = "<PARAMETERS><TYPE1>002</TYPE1><TYPE2>" + deptID.trim() + 
				"</TYPE2><TYPE3>" + subID.trim() + "</TYPE3><SN>" + sn.trim() +
                "</SN><COMPANYID>" + companyID.trim() + "</COMPANYID><DOCID>" + docID.trim() + "</DOCID><LANGTYPE>" + lang + "</LANGTYPE></PARAMETERS>";
		
		String rtnVal = rollbackRegSN(strXML, tenantID);
		
		return rtnVal;
	}

	@Override
	public String updateSignInfo(Document xmlDom, String companyID, String mode, int tenantID) throws Exception {
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		int aprSN = ezApprovalGDAO.updateSignInfoAprSN(map);
		int signLength = xmlDom.getElementsByTagName("SIGNINFO").getLength();
		int maxAprSN = 0;
		
		for (int k = 0; k < signLength; k++) {
			maxAprSN = aprSN + k + 1;
			
			map.put("v_MAXAPRSN", maxAprSN);
			map.put("v_SIGNTYPE", makeRightField(xmlDom.getElementsByTagName("SIGNTYPE").item(k).getTextContent()));
			map.put("v_SIGNNAME", makeRightField(xmlDom.getElementsByTagName("SIGNNAME").item(k).getTextContent()));
			map.put("v_CONTENT", makeRightField(xmlDom.getElementsByTagName("CONTENT").item(k).getTextContent()));
			
			try {
				ezApprovalGDAO.insertSignInfo(map);
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				System.out.println(e.getMessage());
				return "FALSE";
			}
		}
		
//		if (mode.toUpperCase().equals("QUERY")) {
//			return strSQL.toString();
//		} else {
//			try {
//				Map<String, Object> map2 = new HashMap<String, Object>();
//				map2.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
//				map2.put("companyID", companyID);
//				
//				ezApprovalGDAO.transactionSQL(map2);
//				
//				rtnVal = "<RESULT>TRUE</RESULT>";
//			} catch (Exception e) {
//				System.out.println(e.getMessage());
//				rtnVal = "<RESULT>FALSE</RESULT>";
//			}
//		}
		
		
		return "TRUE";
	}

	@Override
	public String getCallBackYN(String docID, String tempUserID, String companyID, int tenantID) throws Exception {
		boolean rtnVal = true;
		String rtnXML = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_USERID", tempUserID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getCallBackYNLineList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		if (dlength >= 2) {
			String aprType = makeListField(docXML.getElementsByTagName("APRTYPE").item(0).getTextContent());
			
			if (!(aprType.equals(staATYilBan) || aprType.equals(staatwhoakin) || aprType.equals(staATSoonChaHyubJo) || aprType.equals(staATgian))) {
				rtnVal = false;
			}
			
			aprType = makeListField(docXML.getElementsByTagName("APRTYPE").item(1).getTextContent());
			
			if (!(aprType.equals(staATGamSaBu) || aprType.equals(staATDekyul) || aprType.equals(staATgumto) || aprType.equals(staATYilBan) || aprType.equals(staatwhoakin) || aprType.equals(staATSoonChaHyubJo) || aprType.equals(staATJunGyul))) {
				rtnVal = false;
			}
			
			aprType = makeListField(docXML.getElementsByTagName("APRSTATE").item(1).getTextContent());
			
			if (!aprType.equals(staASJinHang)) {
				rtnVal = false;
			}
			
			if (rtnVal) {
				if (makeListField(docXML.getElementsByTagName("APRMEMBERSN").item(0).getTextContent()).equals("1")) {
					rtnXML = "<RESULT>CALLBACK</RESULT>";
				} else {
					rtnXML = "<RESULT>CANCEL</RESULT>";
				}
			}
		} else {
			rtnVal = false;
		}
		
		if (rtnXML.equals("")) {
			return "<RESULT>FALSE</RESULT>";
		} else {
			return rtnXML;
		}
	}

	@Override
	public String getCallBackYNForceLine(String docID, String tempUserID, String companyID, int tenantID) throws Exception {
	
		String docList = getCallBackYNForceLineList(docID, companyID, tempUserID, tenantID);
		Document docXML = commonUtil.convertStringToDocument(docList);

		 String result = "<RESULT>TRUE</RESULT>";
		 System.out.println(docXML.getElementsByTagName("ROW").getLength());
		 
		    if (docXML.getElementsByTagName("ROW").getLength() > 1)
            {
                boolean NextLineCheck = false;
                for (int i = 0; i < docXML.getElementsByTagName("ROW").getLength(); i++)
                {
                    String aprtype = docXML.getElementsByTagName("APRTYPE").item(i).getTextContent();
                    String aprstate = docXML.getElementsByTagName("APRSTATE").item(i).getTextContent();
                    String aprmenberid = docXML.getElementsByTagName("APRMEMBERID").item(i).getTextContent();

                    if (NextLineCheck == false && tempUserID.trim() == aprmenberid.trim())
                    {
                        NextLineCheck = true;
                        if (!(aprtype == "001" || aprtype == "002" || aprtype == "008" || aprtype == "018"))
                        {
                            result = "<RESULT>FALSE</RESULT>";
                            break;
                        }
                        if (i == 0 && docXML.getElementsByTagName("APRSTATE").item(0).getTextContent() == "002")
                        {
                            result = "<RESULT>FALSE</RESULT>";
                            break;
                        }
                        continue;
                    }
                    if (NextLineCheck)
                    {
                        if (!(aprtype == "001" || aprtype == "002" || aprtype == "004" || aprtype == "008" || aprtype == "013" || aprtype == "016" || aprtype == "019"))
                        {
                            result = "<RESULT>FALSE</RESULT>";
                            break;
                        }

                        if (aprstate == "002")
                        {
                            break;
                        }
                    }
                } 
            } else {
                result = "<RESULT>FALSE</RESULT>";
       }
		return result;
	}

	private String getCallBackYNForceLineList(String docID, String companyID, String tempUserID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_USERID", tempUserID.trim());
		map.put("v_TENANTID", tenantID);
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getCallBackYNForceLine(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		return sb.toString();
	}

	@Override
	public String getTotalDownload(String docID, String mode, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID.trim());
		map.put("v_PMODE", mode);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAttachInfoVO> apprGAttachInfoVOList = ezApprovalGDAO.getTotalDownload(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAttachInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAttachInfoVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	// 수신 문서와 심사 문서를 같이 가져온다. admin, user = 수신문서, simsa = 심사문서
	public String getReceiveDocList(String userID, String deptID, String mode, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String userLang,
			String searchQuery, Document xmlDomSub, int tenantID, String offset) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		String basicOrder = getCode2Name("A18", "001", companyID, userLang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String basicOrderReverse = "desc";
		
		if (basicOrder.toLowerCase().equals("desc")) {
			basicOrderReverse = "";
		} else {
			basicOrder = "";
		}
		
		String listString = "";
		
		if (mode.equals("simsa")) {
			listString = getListHeader("005", companyID, userLang, tenantID);
		} else {
			listString = getListHeader("004", companyID, userLang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getReceiveDocListCount(mode, userID, deptID, getDocManageDeptInfo(deptID, tenantID), searchQuery.trim(), companyID, xmlDomSub, tenantID);
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);

        if (querySize2 >= Integer.parseInt(pageSize)) {
        	querySize2 = Integer.parseInt(pageSize);
        }
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!sortHeader.equals("") && sortHeader.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (listXML.getElementsByTagName("COLNAME").item(k).getTextContent().toLowerCase().equals("docstate")) {
					if (sortOption.equals("")) {
						orderOption1 = "TBL_APRRECEIPTPROCESSINFO." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
						orderOption2 = "a." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					} else {
						orderOption1 = "TBL_APRRECEIPTPROCESSINFO." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
						orderOption2 = "a." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					}
				} else {
					if (sortOption.equals("")) {
						orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
						orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					} else {
						orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
						orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					}
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getReceiveDocList(mode, userID, deptID, getDocManageDeptInfo(deptID, tenantID), querySize, querySize2, orderOption1, orderOption2, basicOrder, basicOrderReverse, searchQuery, xmlDomSub, companyID, tenantID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("FORMNAME") || fieldName.equals("SENTDEPTNAME") || fieldName.equals("RECEIVEDDEPTNAME")) {
						fieldName = fieldName + commonUtil.getMultiData(userLang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, userLang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + docXML.getElementsByTagName("RECEIVESN").item(k).getTextContent() + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("HASATTACHYN").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + docXML.getElementsByTagName("HASOPINIONYN").item(k).getTextContent() + "</DATA5>");
					resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("RECEIVEDDEPTID").item(k).getTextContent()) + "</DATA6>");
					resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent()) + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("PROCESSORID").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + docXML.getElementsByTagName("APRSTATE").item(k).getTextContent() + "</DATA10>");
					resultXML.append("<DATA11>" + "" + "</DATA11>");
					resultXML.append("<DATA12>" + "" + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("WRITERDEPTID").item(k).getTextContent()) + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("URGENTAPPROVAL").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent()) + "</DATA15>");
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
		
		return resultXML.toString();
	}

	@Override
	public String gongRamDocInfo(String docID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_ORGDOCID", docID.trim());
		map.put("v_TENANTID", tenantID);
		
		String gongRamDocID = makeListField(ezApprovalGDAO.gongRamDocInfo(map));
		
		if (gongRamDocID.equals("")) {
			gongRamDocID = "NONE";
		}
		
		return gongRamDocID;
	}

	@Override
	public String getOrgDocInfo(String docID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGReceiveDocVO> apprGReceiveDocVOList = ezApprovalGDAO.getOrgDocInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGReceiveDocVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGReceiveDocVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getReceivedDocInfo(String docID, String companyID, String lang, int tenantID, String offset) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<RECEIVEDATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		List<ApprGReceiveDocVO> apprGReceiveDocVOList = ezApprovalGDAO.getReceivedDocInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGReceiveDocVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGReceiveDocVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document signXML = commonUtil.convertStringToDocument(sb.toString());
		
		String href = "";
		String docType = "";
		String docState = "";
		String aprState = "";
		String receivedSN = "";
		String receivedDeptID = "";
		String sn = "";
		
		if (signXML.getDocumentElement().getChildNodes().getLength() > 0) {
			href = makeXMLString(makeListField(signXML.getElementsByTagName("HREF").item(0).getTextContent()));
			docType = makeXMLString(makeListField(signXML.getElementsByTagName("DOCTYPE").item(0).getTextContent()));
			docState = makeXMLString(makeListField(signXML.getElementsByTagName("DOCSTATE").item(0).getTextContent()));
			aprState = makeXMLString(makeListField(signXML.getElementsByTagName("APRSTATE").item(0).getTextContent()));
			receivedSN = makeXMLString(makeListField(signXML.getElementsByTagName("RECEIVESN").item(0).getTextContent()));
			receivedDeptID = makeXMLString(makeListField(signXML.getElementsByTagName("RECEIVEDDEPTID").item(0).getTextContent()));
			sn = makeXMLString(makeListField(signXML.getElementsByTagName("SN").item(0).getTextContent()));
		}
		
		rtnVal.append("<DOCFLAGINFO>");
		
		if (!docState.trim().equals("")) {
			switch (docState) {
			case "011" :			// staDSSuSin
				rtnVal.append("<DocFlag>SUSIN</DocFlag>");
				rtnVal.append("<RecieveSN>" + receivedSN + "</RecieveSN>");
				rtnVal.append("<DocType>" + docType + "</DocType>");
				rtnVal.append("<DocState>" + docState + "</DocState>");
				rtnVal.append("<Href>" + href + "</Href>");
				rtnVal.append("<AprState>" + aprState + "</AprState>");
				break;

			case "012" :			// staDSHabYui
				rtnVal.append("<DocFlag>HAPYUI</DocFlag>");
				rtnVal.append("<RecieveSN>" + receivedSN + "</RecieveSN>");
				rtnVal.append("<DocType>" + docType + "</DocType>");
				rtnVal.append("<DocState>" + docState + "</DocState>");
				rtnVal.append("<Href>" + href + "</Href>");
				rtnVal.append("<AprState>" + aprState + "</AprState>");
				break;

			case "015" :			// staDSGongRam
				rtnVal.append("<DocFlag>GONGRAM</DocFlag>");
				rtnVal.append("<RecieveSN>" + receivedSN + "</RecieveSN>");
				rtnVal.append("<DocType>" + docType + "</DocType>");
				rtnVal.append("<DocState>" + docState + "</DocState>");
				rtnVal.append("<Href>" + href + "</Href>");
				rtnVal.append("<AprState>" + aprState + "</AprState>");
				break;

			case "014" :				// staDSGamSaBu
				rtnVal.append("<DocFlag>GAMSABU</DocFlag>");
				rtnVal.append("<RecieveSN>" + receivedSN + "</RecieveSN>");
				rtnVal.append("<DocType>" + docType + "</DocType>");
				rtnVal.append("<DocState>" + docState + "</DocState>");
				rtnVal.append("<Href>" + href + "</Href>");
				rtnVal.append("<AprState>" + aprState + "</AprState>");
				break;

			case "003" :				// staDSGamSa
				rtnVal.append("<DocFlag>GAMSABU</DocFlag>");
				rtnVal.append("<RecieveSN>" + receivedSN + "</RecieveSN>");
				rtnVal.append("<DocType>" + docType + "</DocType>");
				rtnVal.append("<DocState>" + docState + "</DocState>");
				rtnVal.append("<Href>" + href + "</Href>");
				rtnVal.append("<AprState>" + aprState + "</AprState>");
				break;

			case "018" :					// staDSWhokyul
				rtnVal.append("<DocFlag>WHOKYUL</DocFlag>");
				rtnVal.append("<RecieveSN>" + receivedSN + "</RecieveSN>");
				rtnVal.append("<DocType>" + docType + "</DocType>");
				rtnVal.append("<DocState>" + docState + "</DocState>");
				rtnVal.append("<Href>" + href + "</Href>");
				rtnVal.append("<AprState>" + aprState + "</AprState>");
				break;
			}
		}
		
		rtnVal.append("</DOCFLAGINFO>");
		rtnVal.append("<RECEIPTDEPTID>");
		rtnVal.append(receivedDeptID);				
        rtnVal.append("</RECEIPTDEPTID>");
		rtnVal.append("<DOCINFO>");
		rtnVal.append(getDocInfo(docID, "APR", "ALL", companyID, tenantID));
		rtnVal.append("</DOCINFO>");
		rtnVal.append("<ATTACHINFO>");
		rtnVal.append(getAttachInfo(docID, "APR", "", "", companyID, lang, tenantID, offset));
		rtnVal.append("</ATTACHINFO>");
		rtnVal.append("<CONVDOCINFO>");
		rtnVal.append("<HAPYUI>" + makeXMLString(getCode2Name("A36", "001", companyID, lang, tenantID)) + "</HAPYUI>");
		LOGGER.debug("getCode2Name ended.");

		rtnVal.append("<GAMSA>" + makeXMLString(getCode2Name("A36", "002", companyID, lang, tenantID)) + "</GAMSA>");
		LOGGER.debug("getCode2Name ended.");

		rtnVal.append("<RELAY>" + makeXMLString(getCode2Name("A36", "003", companyID, lang, tenantID)) + "</RELAY>");
		LOGGER.debug("getCode2Name ended.");

		rtnVal.append("<EXCHANGE>" + makeXMLString(getCode2Name("A36", "004", companyID, lang, tenantID)) + "</EXCHANGE>");
		LOGGER.debug("getCode2Name ended.");

		rtnVal.append("<RELAY2>" + makeXMLString(getCode2Name("A36", "005", companyID, lang, tenantID)) + "</RELAY2>");
		LOGGER.debug("getCode2Name ended.");

		rtnVal.append("</CONVDOCINFO><DELIVERYNO>");
        rtnVal.append(sn);
		rtnVal.append("</DELIVERYNO></RECEIVEDATA>");
		
		return rtnVal.toString();
	}

	@Override
	public String getDocRecvState(String docID, String deptID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		String result = ezApprovalGDAO.getDocRecvState(map);
		
		return result;
	}

	@Override
	public String setJijung(String docID, String receiveSN, String processorID, String processorName, String processorJobTitle, String receivedDeptID, String receivedDeptName, String docState,
			String processorName2, String processorJobTitle2, String receivedDeptName2, String companyID, String lang, int tenantID) throws Exception {
		String flag = getCode2Name("A35", "002", companyID, lang, tenantID).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");

		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_RECEIVESN", receiveSN);
		map.put("v_DOCSTATE", docState);
		map.put("v_PROCESSORID", processorID);
		map.put("v_PROCESSORNAME", processorName);
		map.put("v_PROCESSORNAME2", processorName2);
		map.put("v_PROCESSORJOBTITLE", processorJobTitle);
		map.put("v_PROCESSORJOBTITLE2", processorJobTitle2);
		map.put("v_RECEIVEDDEPTID", receivedDeptID);
		map.put("v_RECEIVEDDEPTNAME", receivedDeptName);
		map.put("v_RECEIVEDDEPTNAME2", receivedDeptName2);
		map.put("v_CHARGEID", processorID);
		map.put("v_CHARGENAME", processorName);
		map.put("v_CHARGENAME2", processorName2);
		map.put("v_MANAGEDEPTID", receivedDeptID);
		map.put("v_GFLAG", flag);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		
		try {
			if ( !flag.equals("G")) {
				ezApprovalGDAO.jiJungInsertReceiptProInfo(map);
				ezApprovalGDAO.jiJungUpdateReceiptProInfo(map);
				ezApprovalGDAO.jiJungUpdateReceiptProInfo2(map);
				ezApprovalGDAO.jiJungDeleteReceiptProInfo(map);
				ezApprovalGDAO.jiJungDeleteReceiptProInfo2(map);
				ezApprovalGDAO.jiJungUpdateTbDocDelivery(map);
			} else {
				String code = ezApprovalGDAO.selectCodeValue(map);
				if (code == null ) {
					code = "";
				}
				 if(docState.equals("015") || code.equals("015")) {
					 ezApprovalGDAO.jiJungUpdateReceiptProInfo3(map);
				 } else {
					 ezApprovalGDAO.jiJungUpdateReceiptProInfo4(map);
				 }
				 ezApprovalGDAO.jiJungDeleteReceiptProInfo(map);
				 ezApprovalGDAO.jiJungDeleteReceiptProInfo2(map);
			}
			sendMsg(docID, processorID, "JIJUNG", companyID, lang, tenantID);
			
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String updateSusinDocInfo(String orgDocID, String docID, String deptID, String userID, String displayName1, String displayName2, String companyID, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "";
		
        strSQL.append("Update TBL_APRRECEIPTPROCESSINFO SET ProcessDocID = '" + docID);
		strSQL.append("' , AprState = '" + staASJubSu + "' Where DocID = '" + docID);
		strSQL.append("' AND ReceivedDeptID = '" + deptID + "' AND TENANT_ID = " + tenantID +";\n");

		strSQL.append("UPDATE TBL_DOCDELIVERY SET ChargeID = '");
		strSQL.append(makeRightField(userID));
		strSQL.append("', ChargeName = N'" + makeRightField(displayName1));
        strSQL.append("', ChargeName2 = N'" + makeRightField(displayName2));
		strSQL.append("' WHERE DocID = '" + docID + "' AND ManageDeptID = '");
		strSQL.append(makeRightField(deptID) + "' AND TENANT_ID = " + tenantID +";\n");
		
		strSQL.append(updateSusinResult(orgDocID, deptID, userID, "I", displayName1, displayName2, companyID, tenantID));
		
		try {
			Map<String, Object> map2 = new HashMap<String, Object>();
			map2.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map2.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map2);
			
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String getNextDocInfo(String docID, String userID, String userDeptID, String companyID, String lang, int tenantID, String offset) throws Exception {
		String strXML = "";
		String basicOrder = getCode2Name("A18", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = getIsUse("A23", "001", companyID, lang, tenantID);
		
		if (proxyOption.equals("1")) {
			userIDs = getProxyUser(userID, lang, tenantID, offset);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERIDS", userIDs);
		map.put("v_BASICORDER", basicOrder);
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getNextDocInfo(map); 
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("DOCID").getLength() > 0) {
			strXML = "<NEXTDOCINFO><DOCID>" + 
					makeListField(docXML.getElementsByTagName("DOCID").item(0).getTextContent()) + "</DOCID><USERID>" + 
					makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERID").item(0).getTextContent())) + "</USERID><USERNAME>" +
                    makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(0).getTextContent())) + "</USERNAME><USERDEPTID>" +
					makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(0).getTextContent())) + "</USERDEPTID><DOCTYPE>" + 
					makeXMLString(makeListField(docXML.getElementsByTagName("DOCTYPE").item(0).getTextContent())) + "</DOCTYPE><DOCSTATE>" + 
					makeXMLString(makeListField(docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent())) + "</DOCSTATE><WRITERID>" + 
					makeXMLString(makeListField(docXML.getElementsByTagName("WRITERID").item(0).getTextContent())) + "</WRITERID><APRTYPE>" + 
					makeXMLString(makeListField(docXML.getElementsByTagName("APRTYPE").item(0).getTextContent())) + "</APRTYPE><HREF>" + 
					makeXMLString(makeListField(docXML.getElementsByTagName("HREF").item(0).getTextContent())) + "</HREF><EXTENDEDNAME>" + 
					makeXMLString(getExtendedFileName(makeListField(docXML.getElementsByTagName("HREF").item(0).getTextContent()))) + "</EXTENDEDNAME><USERNAME2>" + 
                    makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(0).getTextContent())) + "</USERNAME2></NEXTDOCINFO>";
			
			boolean breakFlag = false;
			int breakPoint = 0;
			
			for (int k = 0; k < docXML.getElementsByTagName("DOCID").getLength(); k++) {
				if (!breakFlag) {
					if (docXML.getElementsByTagName("DOCID").item(k).getTextContent().equals(docID)) {
						breakFlag = true;
						breakPoint = k + 1;
					}
				}
			}
			
			if (breakFlag && breakPoint < docXML.getElementsByTagName("DOCID").getLength()) {
				strXML = "<NEXTDOCINFO><DOCID>" + 
						makeListField(docXML.getElementsByTagName("DOCID").item(breakPoint).getTextContent()) + "</DOCID><USERID>" + 
						makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERID").item(breakPoint).getTextContent())) + "</USERID><USERNAME>" +
                        makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(breakPoint).getTextContent())) + "</USERNAME><USERNAME2>" +
                        makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(breakPoint).getTextContent())) + "</USERNAME2><USERDEPTID>" +
						makeXMLString(makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(breakPoint).getTextContent())) + "</USERDEPTID><DOCTYPE>" + 
						makeXMLString(makeListField(docXML.getElementsByTagName("DOCTYPE").item(breakPoint).getTextContent())) + "</DOCTYPE><DOCSTATE>" + 
						makeXMLString(makeListField(docXML.getElementsByTagName("DOCSTATE").item(breakPoint).getTextContent())) + "</DOCSTATE><WRITERID>" + 
						makeXMLString(makeListField(docXML.getElementsByTagName("WRITERID").item(breakPoint).getTextContent())) + "</WRITERID><APRTYPE>" + 
						makeXMLString(makeListField(docXML.getElementsByTagName("APRTYPE").item(breakPoint).getTextContent())) + "</APRTYPE><HREF>" + 
						makeXMLString(makeListField(docXML.getElementsByTagName("HREF").item(breakPoint).getTextContent())) + "</HREF><EXTENDEDNAME>" + 
						makeXMLString(getExtendedFileName(makeListField(docXML.getElementsByTagName("HREF").item(breakPoint).getTextContent()))) + "</EXTENDEDNAME></NEXTDOCINFO>";
			}
		} else {
			strXML = "<NEXTDOCINFO><DOCID></DOCID><USERID></USERID><USERNAME></USERNAME><USERNAME2></USERNAME2><USERDEPTID></USERDEPTID><DOCTYPE></DOCTYPE><DOCSTATE></DOCSTATE><WRITERID></WRITERID><APRTYPE></APRTYPE><HREF></HREF><EXTENDEDNAME></EXTENDEDNAME></NEXTDOCINFO>";
		}
		
		return strXML;
	}

	@Override
	public String registerCabinet(Document xmlDom, String strLang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String createDate = commonUtil.getTodayUTCTime("");
		String deptCode = xmlDom.getElementsByTagName("DEPTCODE").item(0).getTextContent().trim();
		String taskCode = xmlDom.getElementsByTagName("TASKCODE").item(0).getTextContent();
		//'기록물철 분류번호: 처리과기관코드+단위업무코드+생산년도+등록일련번호
        //수정(2007.07.26 김상건) : 회계년도가 3월 ~ 익년 2월까지이므로 RegYear 년도는 회계년도 값을 가져야 한다.
		String regSN = formatSerialNum(getSerialNum("001", deptCode, taskCode, companyID, strLang, tenantID));
		String produceY = getAccountingYear(createDate, companyID, strLang,tenantID);
		String cabinetClassNO = deptCode + taskCode + produceY + regSN;
		String specialFlag = xmlDom.getElementsByTagName("SPECIALFLAG").item(0).getTextContent();
		
		strSQL.append("Insert Into TBL_CABINETCLASS (CabinetClassNo, ProductionYear, ");
        strSQL.append("RegSerialNo, TerminateFlag, Title, Title2, RecTypeCode, ExpirationYear, ");
        strSQL.append("KeepingMethod, KeepingPlace, DisplayEndDate, DisplayReason, OwnerName, OwnerName2, ");
		strSQL.append("OwnerID, OldCabinetFlag, ModifyFlag, SpecialCatalogFlag, ConfirmFlag, ");
        strSQL.append("CreateDate, KeepingPeriod, DisplayRecFlag, ProcessDeptCode, ProcessDeptName, ProcessDeptName2, ");
        strSQL.append("TaskCode, TaskName, TaskName2, TransDelayFlag, OwnerDeptID, OwnerTask, DelayEndYFlag, ");
		strSQL.append("DelFlag, TENANT_ID) VALUES ('" + makeRightField(cabinetClassNO) + "', '" + makeRightField(produceY));
		strSQL.append("', '" + makeRightField(regSN) + "', '" + makeRightField("0"));
		strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("TITLE").item(0).getTextContent()));
        strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("TITLE2").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("RECTYPE").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(produceY));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("KEEPMETHOD").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("KEEPPLACE").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("DISPLAYREASON").item(0).getTextContent()));
		strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("OWNERNAME").item(0).getTextContent()));
        strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("OWNERNAME2").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField("1") + "', '0', '" + makeRightField(specialFlag));
		strSQL.append("', '" + makeRightField("0") + "', " + "TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
		strSQL.append(", '" + makeRightField(xmlDom.getElementsByTagName("KEEPPERIOD").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("DISPLAYFLAG").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(deptCode));
		strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("DEPTNAME").item(0).getTextContent()));
        strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("DEPTNAME2").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField(taskCode));
		strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("TASKNAME").item(0).getTextContent()));
        strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("TASKNAME2").item(0).getTextContent()));
		strSQL.append("', '" + makeRightField("0") + "', '" + makeRightField(deptCode));
		strSQL.append("', '" + makeRightField(taskCode) +	"', '" + makeRightField("N"));
		strSQL.append("', '" + makeRightField("0") + "'," +tenantID +");\n");
		
		try {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map1.put("v_CABINETCLASSNO",  makeRightField(cabinetClassNO));
			map1.put("v_DeptMID",  makeRightField(xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent()));
			map1.put("v_DeptMName",  makeRightField(xmlDom.getElementsByTagName("OWNERNAME").item(0).getTextContent()));
			map1.put("v_DeptMName2",  makeRightField(xmlDom.getElementsByTagName("OWNERNAME2").item(0).getTextContent()));
			map1.put("v_TENANTID",  tenantID);
			map1.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));

			map1.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map1);
			
			ezApprovalGDAO.trigerTbCabinet(map1);
			ezApprovalGDAO.trigerTbCabRoleInfo(map1);
			
			if (!specialFlag.equals("0")) {
				subSQL = saveSpecialInfoCab(specialFlag, cabinetClassNO, xmlDom, tenantID);
				
				if (subSQL.equals("FALSE")) {
					return "<RESULT>FALSE</RESULT>";
				} 
			}
			
			return "<RESULT>" + cabinetClassNO + "001" + "</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			rollbackSN("001", deptCode, taskCode, regSN, companyID, strLang, tenantID);
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getNewVolumeNo(String cabClassNO, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CABCLASSNO", cabClassNO.trim());
		map.put("v_TENANTID", tenantID);

		
		String result = ezApprovalGDAO.getNewVolumeNo(map);
		
		if (result.length() > 0) {
			return "<RESULT>" + result + "</RESULT>";
		} else {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String addNewVolume(String cabClassNO, String newVolNO, String companyID, int tenantID) throws Exception {
		String createDate = commonUtil.getTodayUTCTime("");
		String cabID = cabClassNO + formatVolNum(newVolNO);
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CABINETID", cabID);
		map.put("v_VOLUMENO", formatVolNum(newVolNO));
		map.put("v_CABCLASSNO", cabClassNO);
		map.put("v_CREATEDATE", createDate);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));

		try {
			ezApprovalGDAO.addNewVolume(map);
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String getFindSimpleCabinetList(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType, int tenantID) throws Exception {
		String strMultiData = commonUtil.getMultiData(langType, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDEPTCODE", processDeptCode);
		map.put("v_PYEAR", productionYear);
		map.put("v_SEARCHNAME", searchKeyword);
		map.put("v_FLAG", flag);
		map.put("v_LANGTYPE", strMultiData);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGCabinetVO> apprGCabinetVOList = ezApprovalGDAO.getFindSimpleCabinetList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGCabinetVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGCabinetVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("096", companyID, langType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("CNAME").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("CABINETID").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(k).getTextContent()) + "</DATA3>");
			resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("OWNERID").item(k).getTextContent()) + "</DATA4>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MCNAME").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent())) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, langType, tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("REGSERIALNO").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("VOLUMENO").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String getFindSimpleCabinetListAll(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType, int tenantID) throws Exception {
		String strMultiData = commonUtil.getMultiData(langType, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PDEPTCODE", processDeptCode);
		map.put("v_PYEAR", productionYear);
		map.put("v_SEARCHNAME", searchKeyword);
		map.put("v_FLAG", flag);
		map.put("v_LANGTYPE", strMultiData);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGCabinetVO> apprGCabinetVOList = ezApprovalGDAO.getFindSimpleCabinetList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGCabinetVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGCabinetVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("096", companyID, langType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent())) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("CABINETID").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(k).getTextContent()) + "</DATA3>");
			resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("OWNERID").item(k).getTextContent()) + "</DATA4>");
			resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA7>");
			resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()) + "</DATA8>");
			resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()) + "</DATA9>");
			resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("DISPLAYRECFLAG").item(k).getTextContent()) + "</DATA10>");
			resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()) + "</DATA11>");
			resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("SC1").item(k).getTextContent()) + "</DATA12>");
			resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("SC2").item(k).getTextContent()) + "</DATA13>");
			resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("SC3").item(k).getTextContent()) + "</DATA14>");
			resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("KEEPINGMETHOD").item(k).getTextContent()) + "</DATA15>");
			resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("KEEPINGPLACE").item(k).getTextContent()) + "</DATA16>");
			resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</DATA17>");
			resultXML.append("<DATA18>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</DATA18>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME").item(k).getTextContent() + "(" + makeListField(docXML.getElementsByTagName("SUBCATEGORYCODE").item(k).getTextContent()) + ")") + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent() + "(" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + ")") + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("SUBCATEGORYCODE").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, langType, tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("REGSERIALNO").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("VOLUMENO").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String setBebu(Document xmlDom, String dirPath, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String docID = xmlDom.getDocumentElement().getAttribute("DocID").trim();
		String receiveSN = xmlDom.getDocumentElement().getAttribute("ReceiveSN").trim();
		String sentDeptID = xmlDom.getDocumentElement().getAttribute("SendDeptID").trim();
		String receiveDeptID = xmlDom.getDocumentElement().getAttribute("ReceivedDeptID").trim();
		
		NodeList objRows = xmlDom.getDocumentElement().getChildNodes().item(0).getChildNodes();
		
		String subSQL = "";
		String gFlag = getCode2Name("A35", "002", companyID, lang, tenantID).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");

		if (!gFlag.equals("G")) {
			strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, ");
            strSQL.append("SentDeptID, SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, ");
			strSQL.append("DocState, AprState, ProcessDate, ProcessYN, ProcessDocID, ");
            strSQL.append("ProcessorID, ProcessorName, ProcessorName2, ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) ");
			strSQL.append("(SELECT '" + receiveSN + "', '" + docID + "', ReceivedDeptID, ");
            strSQL.append("ReceivedDeptName, ReceivedDeptName2, '" + makeRightField(objRows.item(0).getTextContent()));
			strSQL.append("', '" + makeRightField(objRows.item(1).getTextContent()) + "', '"+ makeRightField(objRows.item(2).getTextContent()) + "', DocState, '");
			strSQL.append(staASBaeBu + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
            strSQL.append(", '1', ProcessDocID, NULL, NULL, NULL, NULL, NULL, ParentsDocID FROM ");
            strSQL.append("TBL_APRRECEIPTPROCESSINFO WHERE DocID ='" + docID);
			strSQL.append("' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N' AND TENANT_ID = " + tenantID +");\n");

			strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET ProcessDate = ");
			strSQL.append("TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), ProcessYN = 'Y' WHERE DocID ='");
			strSQL.append(docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N' AND TENANT_ID = " + tenantID +";\n");

			strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET ProcessYN = 'N' ");
			strSQL.append("WHERE DocID ='" + docID + "' AND ReceiveSN = '" + receiveSN);
			strSQL.append("' AND ProcessYN = '1' AND TENANT_ID = " + tenantID +";\n");

			// 수정(2006.06.13) : 배부 시 현재 부서의 결재선 정보는 삭제하도록 수정
			strSQL.append("DELETE FROM TBL_EXPAPRLINE WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID +";\n");
            strSQL.append("DELETE FROM TBL_APRLINEINFO WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID +";\n");
            
            subSQL = updateDeliveryList(docID, sentDeptID, ezOrganService.getPropertyValue(sentDeptID, "displayName", tenantID), ezOrganService.getPropertyValue(sentDeptID, "displayName2", tenantID), objRows.item(0).getTextContent(),
            		objRows.item(1).getTextContent(), objRows.item(2).getTextContent(), "", "", "", sentDeptID, "", companyID, "QUERY", lang, tenantID);
            
            if (subSQL.equals("<RESULT>FALSE</RESULT>")) {
            	return "<RESULT>FALSE</RESULT>";
            } else if (subSQL.equals("<RESULT>TRUE</RESULT>")) {
            	return "<RESULT>TRUE</RESULT>";
            } else {
            	strSQL.append(subSQL);
            }
 		} else {
 			for (int k = 0; k < xmlDom.getDocumentElement().getChildNodes().getLength(); k++) {
 				if (k == 0) {
 					strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET AprState = '" + staASBaeBu);
                    strSQL.append("', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')" );
                    strSQL.append(", ReceivedDeptID = '" + makeRightField(objRows.item(0).getTextContent()));
                    strSQL.append("', ReceivedDeptName = N'" + makeRightField(objRows.item(1).getTextContent()));
                    // 2010.08.03 다국어 
                    strSQL.append("', ReceivedDeptName2 = N'" + makeRightField(objRows.item(2).getTextContent()));
                    strSQL.append("' WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "'");
                    strSQL.append("AND ReceivedDeptID IN (" + getDocManageDeptInfo(sentDeptID, tenantID) + ") AND TENANT_ID = " + tenantID +";\n");
 				} else {
 					subSQL = doBebuDoc(docID, xmlDom.getDocumentElement().getChildNodes().item(k).getChildNodes().item(0).getTextContent(),
 							xmlDom.getDocumentElement().getChildNodes().item(k).getChildNodes().item(1).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(k).getChildNodes().item(2).getTextContent(),
 							dirPath, sentDeptID, companyID, lang, tenantID);
 					
 					if (subSQL.toUpperCase().equals("FALSE")) {
 						return "<RESULT>FALSE</RESULT>";
 					} else {
 						strSQL.append(subSQL);
 					}
 				}
 			}
 			strSQL.append("DELETE FROM TBL_EXPAPRLINE WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID + ";\n");
            strSQL.append("DELETE FROM TBL_APRLINEINFO WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID + ";\n");
            
            subSQL = updateDeliveryList(docID, sentDeptID, ezOrganService.getPropertyValue(sentDeptID, "displayName", tenantID), ezOrganService.getPropertyValue(sentDeptID, "displayName2", tenantID), objRows.item(0).getTextContent(),
            		objRows.item(1).getTextContent(), objRows.item(2).getTextContent(), "", "", "", sentDeptID, "", companyID, "QUERY", lang, tenantID);
            
            if (subSQL.equals("<RESULT>FALSE</RESULT>")) {
            	return "<RESULT>FALSE</RESULT>";
            } else if (subSQL.equals("<RESULT>TRUE</RESULT>")) {
            	return "<RESULT>TRUE</RESULT>";
            } else {
            	strSQL.append(subSQL);
            }
 		}
		
		try {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map1.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map1);
			
			sendRecvMsg(receiveDeptID, docID, "BEBU", companyID, lang, tenantID);
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	private String doBebuDoc(String docID, String deptID, String deptName, String deptName2, String dirPath, String docState, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		String newID = getNewID(companyID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", "APR");
		map.put("v_TENANTID", tenantID);
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String url = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator +
				"1000" + commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		String fileURL = dirPath + commonUtil.separator + fileName.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID), "");
		
		boolean rtnVal = copyFile(fileURL, dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" +
				commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName, dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + 
				commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID));
		
		if (rtnVal) {
			strSQL.append("INSERT INTO TBL_APRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
			strSQL.append("isPublic, TENANT_ID) SELECT '" + newID + "', FormID, OrgDocID, DocType, '011', '" + staASDoJak + "', '" + url + "', DocTitle, DocNo, HasAttachYN, HasOpinionYN, TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
            strSQL.append(", NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID FROM TBL_APRDOCINFO WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID + ";\n");

			// 수정(2005.09.29) : 보안결재 필드 추가
			strSQL.append("INSERT INTO TBL_EXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID) ");
            strSQL.append("(SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
            strSQL.append("ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID FROM TBL_EXPAPRDOCINFO ");
			strSQL.append("WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID + "); \n");

			strSQL.append("INSERT INTO TBL_APRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID) (SELECT '" + newID);
			strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID FROM ");
            strSQL.append("TBL_APRATTACHINFO WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID + ");\n");

			strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID) (SELECT '" + newID);
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID FROM ");
            strSQL.append("TBL_APRDOCATTACHINFO WHERE DocID = '" + docID + "'  AND TENANT_ID = " + tenantID + ";)\n");

			strSQL.append("INSERT INTO TBL_APROPINIONINFO (DocID, UserID, OpinionGB, Content, ");
            strSQL.append("UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN, TENANT_ID) (SELECT '");
            strSQL.append(newID + "', UserID, OpinionGB, Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN, TENANT_ID FROM TBL_APROPINIONINFO  WHERE DocID = '" + docID + "'  AND TENANT_ID = " + tenantID + ");\n");


            //##################################################################다중배부####################################################
            strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) (SELECT '1', '");
            strSQL.append(newID + "', WriterDeptID, WriterDeptName, WriterDeptName2, '" + deptID + "', N'" + deptName + "', N'" + deptName2);
            strSQL.append("', '011', '" + staASBaeBu + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')"  );
            strSQL.append(", 'N', '', '', '', '', '', '', DocID, TENANT_ID FROM TBL_APRDOCINFO WHERE DocID = '");
            strSQL.append(docID + "' AND TENANT_ID = " + tenantID + ");\n");
            
            String subSQL = updateDeliveryList(newID, docState, ezOrganService.getPropertyValue(docState, "displayName", tenantID), ezOrganService.getPropertyValue(docState, "displayName2", tenantID), deptID, 
            		deptName, deptName2, "", "", "", docState, "", companyID, "QUERY", lang, tenantID);
            
            if (subSQL.equals("<RESULT>FALSE</RESULT>")) {
            	return "FALSE";
            } else if (subSQL.equals("<RESULT>TRUE</RESULT>")) {
            	return "TRUE";
            } else {
            	strSQL.append(subSQL + "\n");
            }
            
            sendRecvMsg(deptID, newID, "SUSIN", companyID, lang, tenantID);
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	private String updateDeliveryList(String docID, String organID, String organ, String organ2, String manageDeptID, String manageDept, String manageDept2, String chargeID,
			String chargeName, String chargeName2, String deptID, String remark, String companyID, String mode, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		String deliveryOption = getCode2Name("A54", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		boolean duplicateFlag = false;
		
		if (deliveryOption.trim().toUpperCase().equals("Y")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_DEPTID", deptID.trim());
			map.put("v_TENANTID", tenantID);
			
			int resultCnt = ezApprovalGDAO.updateDeliveryListCount(map);
			
			if (resultCnt > 0) {
				duplicateFlag = true;
			}
		}
		
		if (duplicateFlag) {
			strSQL.append("UPDATE TBL_DOCDELIVERY SET OrganID = '" + makeRightField(organID));
			strSQL.append("', Organ = N'" + makeRightField(organ));
            strSQL.append("', Organ2 = N'" + makeRightField(organ2));
			strSQL.append("', ManageDeptID = '" + makeRightField(manageDeptID));
            strSQL.append("', ManageDept = N'" + makeRightField(manageDept));
            strSQL.append("', ManageDept2 = N'" + makeRightField(manageDept2));
			strSQL.append("', ChargeID = '" + makeRightField(chargeID));
            strSQL.append("', ChargeName = N'" + makeRightField(chargeName));
            strSQL.append("', ChargeName2 = N'" + makeRightField(chargeName2));
			strSQL.append("', Remark = N'" + makeRightField(remark));
            strSQL.append("' WHERE DocID = '" + docID + "' AND DeptID = '" + makeRightField(deptID) + "' AND TENANT_ID = " + tenantID +";");
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_YEAR", commonUtil.getTodayUTCTime("yyyy"));
			map.put("v_DEPTID", deptID.trim());
			map.put("v_TENANTID", tenantID);
			
			int maxSN = ezApprovalGDAO.updateDeliveryListSNMax(map) + 1;
            strSQL.append("INSERT INTO TBL_DOCDELIVERY (sn, DocID, Href, ReceiptDate, ");
            strSQL.append("OrganID, Organ, Organ2, DocNumber, ManageDeptID, ManageDept, ManageDept2, ChargeID, ");
            strSQL.append("ChargeName, ChargeName2, DeptID, Remark, OrgDocNumCode, DocTitle, TENANT_ID) (SELECT '");
			strSQL.append(maxSN + "', a.DocID, a.Href, TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
            strSQL.append(", '" + makeRightField(organID) + "', N'" + makeRightField(organ) + "', N'" + makeRightField(organ2));
			strSQL.append("', a.DocNo, '" + makeRightField(manageDeptID) + "', N'");
			strSQL.append(makeRightField(manageDept) + "', N'" + makeRightField(manageDept2) + "', '" + makeRightField(chargeID));
            strSQL.append("', N'" + makeRightField(chargeName) + "', N'" + makeRightField(chargeName2) + "', '" + makeRightField(deptID));
		    strSQL.append("', N'" + makeRightField(remark) + "', b.DocNumCode, a.DocTitle , a.TENANT_ID ");
            strSQL.append("FROM TBL_APRDOCINFO a INNER JOIN TBL_EXPAPRDOCINFO b on a.DocID = b.DocID AND a.TENANT_ID = b.TENANT_ID ");
            strSQL.append("WHERE a.DocID = '" + docID.trim() + "'  AND a.TENANT_ID = " + tenantID +");");
		}
		
		if (mode.toUpperCase().equals("QUERY")) {
			return strSQL.toString();
		}
		
		try {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map1.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map1);
			
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	private String formatVolNum(String strVolNO) {
		return getNDigitNum(strVolNO, 3);
	}
	private String formatDateForTrans(String pDate, int iFlag) {
		String rtnVal="";
		if(pDate.length()>0){
			rtnVal=getNDigitNum(pDate.substring(0,4),4) + getNDigitNum(pDate.substring(5,7),2) + getNDigitNum(pDate.substring(8,10), 2);
			if(iFlag==1){
				rtnVal += getNDigitNum(pDate,2) + getNDigitNum(pDate, 2);
			}
		    return rtnVal;
		    }
			else{
				return "";
			}
		}
	private String getAVTypeString(String pCode, String companyID, String LangType, int tenantID) {
		try{
			String [] pCodes = pCode.split(",");
			String rtnVal="";
			for(int i = 0; i < pCodes.length; i++){
				if(pCodes[i].trim().length() >= 1){
					if(rtnVal.trim() != ""){
						rtnVal += ",";
					}
					if(pCodes[i].substring(0,1).toUpperCase().equals("C")){
						rtnVal += getCabinetCode2Name("009", pCodes[i].toString(), companyID, LangType, tenantID);
					}
					else{
						rtnVal += getCabinetCode2Name("008", pCodes[i].toString(), companyID, LangType, tenantID);
					}
				}
			}
			return rtnVal;
		}catch(Exception e){	
			return null;
		}
	}
	private String rollbackSN(String snType1, String snType2, String snType3, String toSN, String companyID, String strLang, int tenantID) throws Exception{
		String accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, strLang, tenantID);
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_Type1", snType1);
		map.put("iv_Type2", snType2);
		map.put("iv_Type3", snType3);
		map.put("v_CurSN", toSN);
		map.put("v_AccountYear", accountYear);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));
		
		try {
			ezApprovalGDAO.spRollbackSN(map);
			result = "TRUE";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	private String saveSpecialInfoCab(String specialFlag, String cabinetClassNO, Document xmlDom, int tenantID) throws Exception{
		LOGGER.debug("saveSpecialInfoCab started.");

		String rtn = null;
		
		String sc1 = xmlDom.getElementsByTagName("LIST1").item(0).getTextContent().trim();
		String sc2 = xmlDom.getElementsByTagName("LIST2").item(0).getTextContent().trim();
		String sc3 = xmlDom.getElementsByTagName("LIST3").item(0).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CABINETCLASSNO", makeRightField(cabinetClassNO));
		map.put("v_SC1", makeRightField(sc1));
		map.put("v_SC2", makeRightField(sc2));
		map.put("v_SC3", makeRightField(sc3));
		map.put("v_TENANTID", tenantID);
		try{
	 	LOGGER.debug("insertTbSpecialCatalogInfo_Cab param = v_CABINETCLASSNO =" + makeRightField(cabinetClassNO) + "v_SC1=" +makeRightField(sc1)+ "v_SC2=" +makeRightField(sc2)+ "v_SC3=" +makeRightField(sc3)+"v_TENANTID ="+tenantID);

		ezApprovalGDAO.insertTbSpecialCatalogInfo_Cab(map);
		
		NodeList nodeList=xmlDom.getElementsByTagName("SCDATA");
 		if (specialFlag.equals("1")) {
			for (int k = 0; k < xmlDom.getElementsByTagName("SCDATA").getLength(); k++) {
				
				map.put("v_CABINETCLASSNO", makeRightField(cabinetClassNO));
				map.put("v_SERIALNO", makeRightField(nodeList.item(k).getChildNodes().item(0).getTextContent().trim()));
				map.put("v_SC1", makeRightField(nodeList.item(k).getChildNodes().item(1).getTextContent().trim()));
				map.put("v_SC2", makeRightField(nodeList.item(k).getChildNodes().item(2).getTextContent().trim()));
				map.put("v_SC3", makeRightField(nodeList.item(k).getChildNodes().item(3).getTextContent().trim()));
				map.put("v_TENANTID", tenantID);
			 	LOGGER.debug("insertTbSpecialCatalogInfo_Cab2 param = v_CABINETCLASSNO =" + makeRightField(cabinetClassNO) + "v_SERIALNO=" + makeRightField(nodeList.item(k).getChildNodes().item(0).getTextContent().trim())+ "v_SC1=" + makeRightField(nodeList.item(k).getChildNodes().item(1).getTextContent().trim()) + "v_SC2=" + makeRightField(nodeList.item(k).getChildNodes().item(2).getTextContent().trim()) + "v_SC3=" + makeRightField(nodeList.item(k).getChildNodes().item(3).getTextContent().trim()) +"v_TENANTID ="+tenantID);

				ezApprovalGDAO.insertTbSpecialCatalogInfo_Cab2(map);

			}
		}
 		rtn = "TURE";
 		LOGGER.debug("saveSpecialInfoCab ended.");
		}
		catch(Exception e){
			rtn = "FALSE";
		}
		return rtn;
	}

	@Override
	public List<ApprGSecondApprVO> getSecondApprovalInfo(String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGSecondApprVO> apprGSecondApprVOList = ezApprovalGDAO.getSecondApprovalInfo(map);
		
		return apprGSecondApprVOList;
	}

	private String getReceiveDocList(String mode, String userID, String deptID, String docManageDeptInfo, int querySize, int querySize2, String orderOption1, String orderOption2, String basicOrder,
			String basicOrderReverse, String searchQuery, Document xmlDomSub, String companyID ,int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", mode.toLowerCase());
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTIDS", docManageDeptInfo);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if(orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0, 11).toLowerCase());
		}
		
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_ORDEROPTION2LENGTH", orderOption2.length());
		
		if(orderOption2.length() > 0) {
			map.put("v_ORDEROPTION2VALUE", orderOption2.substring(0, 11).toLowerCase());
		}
		
		map.put("v_BASICORDER", basicOrder);
		map.put("v_BASICORDER2", basicOrderReverse);
		map.put("v_SPSUBQUERY", searchQuery.trim());
		map.put("v_SPSUBQUERYLENGTH", searchQuery.trim().length());
		map.put("v_TENANTID", tenantID);

		
		if (xmlDomSub.getElementsByTagName("DOCNO").item(0) != null) {
			map.put("v_SDOCNO", xmlDomSub.getElementsByTagName("DOCNO").item(0).getTextContent());
		} else {
			map.put("v_SDOCNO", "");
		}
		if (xmlDomSub.getElementsByTagName("DOCTITLE").item(0) != null) {
			map.put("v_SDOCTITLE", xmlDomSub.getElementsByTagName("DOCTITLE").item(0).getTextContent());
		} else {
			map.put("v_SDOCTITLE", "");
		}
		if (xmlDomSub.getElementsByTagName("WRITERNAME").item(0) != null) {
			map.put("v_SWRITERNAME", xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERNAME", "");
		}
		if (xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0) != null) {
			map.put("v_SWRITERDEPTNAME", xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERDEPTNAME", "");
		}
		
		List<ApprGReceiveDocVO> apprGReceiveDocVOList = ezApprovalGDAO.getReceiveDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGReceiveDocVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGReceiveDocVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	private int getReceiveDocListCount(String mode, String userID, String deptID, String docManageDeptInfo, String subQuery, String companyID, Document xmlDomSub, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", mode.toLowerCase());
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTIDS", docManageDeptInfo);
		map.put("v_SPSUBQUERY", subQuery);
		map.put("v_SPSUBQUERYLENGTH", subQuery.length());
		map.put("v_TENANTID", tenantID);


		
		if (xmlDomSub.getElementsByTagName("DOCNO").item(0) != null) {
			map.put("v_SDOCNO", xmlDomSub.getElementsByTagName("DOCNO").item(0).getTextContent());
		} else {
			map.put("v_SDOCNO", "");
		}
		if (xmlDomSub.getElementsByTagName("DOCTITLE").item(0) != null) {
			map.put("v_SDOCTITLE", xmlDomSub.getElementsByTagName("DOCTITLE").item(0).getTextContent());
		} else {
			map.put("v_SDOCTITLE", "");
		}
		if (xmlDomSub.getElementsByTagName("WRITERNAME").item(0) != null) {
			map.put("v_SWRITERNAME", xmlDomSub.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERNAME", "");
		}
		if (xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0) != null) {
			map.put("v_SWRITERDEPTNAME", xmlDomSub.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERDEPTNAME", "");
		}
		
		int totalCnt = ezApprovalGDAO.getReceiveDocListCount(map);
		
		return totalCnt;
	}

	public String rollbackRegSN(String strXML, int tenantID) throws Exception{
		Document objParam = commonUtil.convertStringToDocument(strXML);
		
		String type1 = objParam.getElementsByTagName("TYPE1").item(0).getTextContent();
		String type2 = objParam.getElementsByTagName("TYPE2").item(0).getTextContent();
		String type3 = objParam.getElementsByTagName("TYPE3").item(0).getTextContent();
		long sn = Long.parseLong(objParam.getElementsByTagName("SN").item(0).getTextContent());
		String docID = objParam.getElementsByTagName("DOCID").item(0).getTextContent();
		String companyID = objParam.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String lang = objParam.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		
		return "<RESULT>" + rollbackSN(type1, type2, type3, sn, companyID, docID, lang, tenantID) + "</RESULT>";
	}

	public String rollbackSN(String type1, String type2, String type3, long sn, String companyID, String docID, String langType, int tenantID) throws Exception{
		String accountYear = "";
		String result = "";
		
		if (!docID.trim().equals("")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			
			String processDate = ezApprovalGDAO.getDraftDate(map);
			
			if (processDate != null && !processDate.equals("")) {
				accountYear = getAccountingYear(processDate, companyID, langType, tenantID);
			} else {
				accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, langType, tenantID);
			}
		} else {
			accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, langType, tenantID);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_Type1", type1);
		map.put("iv_Type2", type2);
		map.put("iv_Type3", type3);
		map.put("v_CurSN", sn);
		map.put("v_AccountYear", accountYear);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));
		
		try {
			ezApprovalGDAO.spRollbackSN(map);
			result = "TRUE";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	public String getRegSN(String strXML, int tenantID) throws Exception{
		Document objParam = commonUtil.convertStringToDocument(strXML);
		
		String type1 = objParam.getElementsByTagName("TYPE1").item(0).getTextContent();
		String type2 = objParam.getElementsByTagName("TYPE2").item(0).getTextContent();
		String type3 = objParam.getElementsByTagName("TYPE3").item(0).getTextContent();
		String companyID = objParam.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String docID = "";
		
		if (objParam.getElementsByTagName("DOCID").item(0) != null) {
			docID = objParam.getElementsByTagName("DOCID").item(0).getTextContent();
		}
		String langType = "";
		
		if (objParam.getElementsByTagName("LANGTYPE").item(0) != null) {
			langType = objParam.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		}
		
		return "<RESULT>" + getSerialNum(type1, type2, type3, companyID, docID, langType, tenantID) + "</RESULT>";
	}

	public String getSerialNum(String type1, String type2, String type3, String companyID, String docID, String langType, int tenantID) throws Exception{
		String accountYear = "";
		
		if (!docID.trim().equals("")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", docID.trim());
			map.put("v_TENANTID", tenantID);
			
			String processDate = ezApprovalGDAO.getDraftDate(map);
			
			if (processDate != null && !processDate.equals("")) {
				accountYear = getAccountingYear(processDate, companyID, langType, tenantID);
			} else {
				accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, langType, tenantID);
			}
		} else {
			accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, langType, tenantID);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_Type1", type1);
		map.put("iv_Type2", type2);
		map.put("iv_Type3", type3);
		map.put("v_AccountYear", accountYear);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));

		String result = ezApprovalGDAO.spGetSerialNo(map);
		map.put("v_CurSN", result);
		if (result == null) {
			map.put("v_CurSN", "1");
			ezApprovalGDAO.insertSerialNo(map);
			result = "1";
		}
		
		int rollBackFlag =  ezApprovalGDAO.rollBackFlag(map);
		
		if (rollBackFlag == 1) {
			 ezApprovalGDAO.deleteSerialNo(map);
		} else {
			ezApprovalGDAO.updateSerialNo(map);
			result = Integer.toString((Integer.parseInt(result) + 1));
		}
		
		return result;
	}

	public boolean compareLineHistory(String docID, String companyID, int tenantID) throws Exception{
		int modifySN = 0;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_FLAG", "1");
		map.put("v_MODIFYSN", modifySN);
		map.put("v_TENANTID", tenantID);
		
		modifySN = ezApprovalGDAO.compareLineHistory(map);
		
		if (modifySN == 0 || String.valueOf(modifySN).equals("")) {
			return true;
		}
		map.remove("v_FLAG");
		map.put("v_FLAG", "2");
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.compareLineHistory1(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document historyXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (historyXML.getElementsByTagName("ROW").getLength() <= 0) {
			return false;
		}
		
		map.remove("v_FLAG");
		map.put("v_FLAG", "3");
		
		List<ApprGAprLineVO> apprGAprLineVOList1 = ezApprovalGDAO.compareLineHistory1(map);
		
		StringBuffer sb1 = new StringBuffer();
        sb1.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList1.size(); i++) {
			sb1.append(commonUtil.getQueryResult(apprGAprLineVOList1.get(i)));
		}
		sb1.append("</DATA>");
		
		Document lineXML = commonUtil.convertStringToDocument(sb1.toString());
		
		if (lineXML.getElementsByTagName("ROW").getLength() <= 0) {
			return true;
		}
		
		if (historyXML.getElementsByTagName("ROW").getLength() != lineXML.getElementsByTagName("ROW").getLength()) {
			return true;
		}
		
		boolean rtnVal = false;
		
		for (int k = 0; k < historyXML.getElementsByTagName("ROW").getLength(); k++) {
			if (!historyXML.getElementsByTagName("APRMEMBERSN").item(k).getTextContent().equals(lineXML.getElementsByTagName("APRMEMBERSN").item(k).getTextContent())) {
				rtnVal = true;
			}
			if (!historyXML.getElementsByTagName("APRTYPE").item(k).getTextContent().equals(lineXML.getElementsByTagName("APRTYPE").item(k).getTextContent())) {
				rtnVal = true;
			}
			if (!historyXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent().equals(lineXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent())) {
				rtnVal = true;
			}
			if (!historyXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent().equals(lineXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent())) {
				rtnVal = true;
			}
			if (!historyXML.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent().equals(lineXML.getElementsByTagName("ISPROPOSERYN").item(k).getTextContent())) {
				rtnVal = true;
			}
			if (!historyXML.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent().equals(lineXML.getElementsByTagName("ISBRIEFUSERYN").item(k).getTextContent())) {
				rtnVal = true;
			}
		}
		
		return rtnVal;
	}

	public String chkAprLine(String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName, String userDeptName2, String userCompanyID, String strLang, LoginVO userInfo) throws Exception{
		Document resultXML = null;
		StringBuilder rtnVal = new StringBuilder();
		String strXML = "";
		
		if (userID.trim().toUpperCase().equals(userDeptID.trim().toUpperCase())) {
			if (userID.toLowerCase().indexOf("address") == -1) {
				strXML = ezOrganService.getPropertyList(userID, "displayName;extensionAttribute2", commonUtil.getPrimaryData(strLang, userInfo.getTenantId()), userInfo.getTenantId());
				resultXML = commonUtil.convertStringToDocument(strXML);
				
				String tempDeptName = userDeptName.trim();
				
				if (!commonUtil.getPrimaryData(strLang, userInfo.getTenantId()).equals("1")) {
					tempDeptName = userDeptName2;
				}
				
				if (resultXML.getDocumentElement().getChildNodes().getLength() > 0) {
					if (resultXML.getElementsByTagName("DISPLAYNAME").item(0) != null) {
						
					} else {
						rtnVal.append("- " + tempDeptName + messageSource.getMessage("ezApprovalG.pjj08", userInfo.getLocale()));
					}
					
					if (resultXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0) != null) {
						if (!userCompanyID.trim().equals(resultXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tempDeptName + messageSource.getMessage("ezApprovalG.pjj09", userInfo.getLocale()) + userCompanyID);
							rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()) + resultXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
						}
					} else {
						rtnVal.append("- " + tempDeptName + messageSource.getMessage("ezApprovalG.pjj12", userInfo.getLocale()));
					}
				} else {
					rtnVal.append("- " + tempDeptName +  messageSource.getMessage("ezApprovalG.pjj13", userInfo.getLocale()));
				}
			}
		} else {
			String tmpUserName = "";
			
			strXML = ezOrganService.getPropertyList(userID, "displayName;department;description;physicalDeliveryOfficeName;title;extensionAttribute4", strLang, userInfo.getTenantId());
			resultXML = commonUtil.convertStringToDocument(strXML);
			
			if (resultXML.getElementsByTagName("DISPLAYNAME").item(0) != null) {
				tmpUserName = resultXML.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
			}
			
			if (resultXML.getDocumentElement().getChildNodes().getLength() > 0) {
				if (resultXML.getElementsByTagName("DISPLAYNAME1").item(0) != null) {
					if (!userName.trim().equals(resultXML.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent().trim())) {
						rtnVal.append("- " + userName + messageSource.getMessage("ezApprovalG.pjj14", userInfo.getLocale())+ userName);
						rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale())+ resultXML.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent());
						rtnVal.append(messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
					} else if (resultXML.getElementsByTagName("DISPLAYNAME2").item(0) != null) {
						if (!userName2.trim().equals(resultXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim())) {
							rtnVal.append("- " + userName2 + messageSource.getMessage("ezApprovalG.pjj14", userInfo.getLocale()) + userName2);
                            rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()) + resultXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent());
                            rtnVal.append(messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
						}
					} else {
						rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj08", userInfo.getLocale()));
					}
				} else {
					rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj08", userInfo.getLocale()));
				}
				
				if (resultXML.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0) != null) {
					if (!userCompanyID.trim().equals(resultXML.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0).getTextContent().trim())) {
						rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj09", userInfo.getLocale()) + userCompanyID);
						rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()) + resultXML.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0).getTextContent());
						rtnVal.append(messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
					}
				} else {
					rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj12", userInfo.getLocale()));
				}
				
				boolean subTitleFlag = false;
				
				if (resultXML.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0) != null) {
					if (!resultXML.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent().trim().equals("")) {
						subTitleFlag = true;
					}
				}
				
				if (subTitleFlag) {
					if (resultXML.getElementsByTagName("DEPARTMENT").item(0) != null && resultXML.getElementsByTagName("DESCRIPTION").item(0) != null && resultXML.getElementsByTagName("TITLE").item(0) != null) {
						String[] arr1 = resultXML.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent().trim().split(";");
						String[] userDIDs = new String[arr1.length +1];
						String[] userDNames = new String[arr1.length +1];
						String[] userDNames2 = new String[arr1.length +1];
						String[] userTitles = new String[arr1.length +1];
						String[] userTitles2 = new String[arr1.length +1];
						
						for (int k = 0; k < arr1.length; k++) {
							String[] arr2 = arr1[k].split(":");
							userDIDs[k + 1] = arr2[0].trim();
							userDNames[k + 1] = ezOrganService.getPropertyValue(arr2[0], "displayName", userInfo.getTenantId());
							userDNames2[k + 1] = ezOrganService.getPropertyValue(arr2[0], "displayName2", userInfo.getTenantId());
							
							if (arr2[1].trim().equals("")) {
								userTitles[k + 1] = userJobTitle;
								userTitles2[k + 1] = userJobTitle2;
							} else {
								userTitles[k + 1] = arr2[1].trim();
								userTitles2[k + 1] = arr2[2].trim();
							}
						}
						
						userDIDs[0] = resultXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent().trim();
						userDNames[0] = resultXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent().trim();
						userDNames2[0] = resultXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent().trim();
						userTitles[0] = resultXML.getElementsByTagName("TITLE1").item(0).getTextContent().trim();
						userTitles2[0] = resultXML.getElementsByTagName("TITLE2").item(0).getTextContent().trim();
						
						subTitleFlag = false;
						
						for (int k = 0; k < userDIDs.length; k++) {
							if (userDIDs[k].trim().equals(userDeptID.trim()) && userDNames[k].trim().equals(userDeptName.trim()) && userDNames2[k].trim().equals(userDeptName2.trim()) 
									&& userTitles[k].trim().equals(userJobTitle.trim()) && userTitles2[k].trim().equals(userJobTitle2.trim())){
								subTitleFlag = true;
							}
						}
						
						if (!subTitleFlag) {
							rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj15", userInfo.getLocale()));
                            rtnVal.append(userDeptID + ", " + userDeptName + "(" + userDeptName2 + "), ");
                            rtnVal.append(userJobTitle + "(" + userJobTitle2 + ")"+ messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()));
                            
                            for (int k = 0; k < userDIDs.length; k++) {
                            	if (!userDIDs[k].trim().equals("")) {
                            		if (k == 0) {
                            			 rtnVal.append("<" + userDIDs[k] + ", " + userDNames[k] + "(" + userDNames2[k] + "), " + userTitles[k] + "(" + userTitles2[k] + ")>");
									} else {
                                        rtnVal.append(", <" + userDIDs[k] + ", " + userDNames[k] + "(" + userDNames2[k] + "), " + userTitles[k] + "(" + userTitles2[k] + ")>");
                            		}
                            	}
                            }
                            
                            rtnVal.append(messageSource.getMessage("ezApprovalG.pjj16", userInfo.getLocale()));
						}
					} else {
						rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj17", userInfo.getLocale()));
					}
				} else {
					if (resultXML.getElementsByTagName("DEPARTMENT").item(0) != null) {
						if (!userDeptID.trim().equals(resultXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj15", userInfo.getLocale()) + userDeptID);
							rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()) + resultXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent() + messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
						}
					} else {
						rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj18", userInfo.getLocale()));
					}
					
					if (resultXML.getElementsByTagName("DESCRIPTION1").item(0) != null) {
						if (!userDeptName.trim().equals(resultXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj19", userInfo.getLocale()) + userDeptName);
							rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale())+ resultXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent() + messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
						} else if (resultXML.getElementsByTagName("DESCRIPTION2").item(0) != null) {
							if (!userDeptName2.trim().equals(resultXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent().trim())) {
								rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj19", userInfo.getLocale()) + userDeptName2);
                                rtnVal.append(messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()) + resultXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent() + messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
							}
						} else {
							rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj18", userInfo.getLocale()));
						}
					} else {
						rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj18", userInfo.getLocale()));
					}
					
					if (resultXML.getElementsByTagName("TITLE1").item(0) != null) {
						if (!userJobTitle.trim().equals(resultXML.getElementsByTagName("TITLE1").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj20", userInfo.getLocale()) + userJobTitle + messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()));
							rtnVal.append(resultXML.getElementsByTagName("TITLE1").item(0).getTextContent() + messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
						} else if (resultXML.getElementsByTagName("TITLE2").item(0) != null) {
							if (!userJobTitle2.trim().equals(resultXML.getElementsByTagName("TITLE2").item(0).getTextContent().trim())) {
								rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj20", userInfo.getLocale()) + userJobTitle2 + messageSource.getMessage("ezApprovalG.pjj10", userInfo.getLocale()));
                                rtnVal.append(resultXML.getElementsByTagName("TITLE2").item(0).getTextContent() + messageSource.getMessage("ezApprovalG.pjj11", userInfo.getLocale()));
							}
						} else {
							rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj21", userInfo.getLocale()));
						}
					} else {
						rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj21", userInfo.getLocale()));
					}
				}
			} else {
				rtnVal.append("- " + tmpUserName + messageSource.getMessage("ezApprovalG.pjj22", userInfo.getLocale()));
			}
		}
		
		return makeXMLString(rtnVal.toString());
	}

	public boolean chkDocDelete(String docID, String orgDocID, boolean chkFlag, String userID, String deptID, String dirPath, String companyID, int tenantID) throws Exception{
		boolean rtnVal = true;
		
		if (chkFlag) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", orgDocID);
			map.put("v_TENANTID", tenantID);
			String temp =ezApprovalGDAO.chkDocDeleteTemp(map);
			
			if(temp!=null){
				map.put("v_temp", "1");
			} else {
				map.put("v_temp", "0");
			}
			String fileName = makeListField(ezApprovalGDAO.chkDocDelete(map));
			String oldYear = getDocHrefYear(orgDocID, companyID, tenantID);
			
			if (!fileName.trim().equals("")) {
				String extFileName = getExtendedFileName(fileName);
				
				try {
					deleteFile(dirPath + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName);
					rtnVal = true;
				} catch (Exception e) {
					rtnVal = false;
				}
				  
			}
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", orgDocID);
			map.put("v_FLAG", "APR");
			map.put("v_TENANTID", tenantID);
			
			String fileName = makeListField(ezApprovalGDAO.getDocInfoHref(map));
			String oldYear = getDocHrefYear(docID, companyID, tenantID);
			
			if (!fileName.trim().equals("")) {
				String extFileName = getExtendedFileName(fileName);
				
				try {
					deleteFile(dirPath + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName); 
					rtnVal = true;
				} catch (Exception e) {
					rtnVal = false;
				}
			}
		}
		
		return rtnVal;
	}

	public String makeTmpDocInfo(String userID, String docID, String updateFlag, String companyID, String lang, int tenantID) throws Exception{
		String strSQL = "";
		StringBuilder appendSql = new StringBuilder();
		//아직 테넌트 안함
		if (updateFlag.equals("UPDATE")) {
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_USERID", userID);
			map.put("v_TENANTID", tenantID);
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
			
			String sn = ezApprovalGDAO.maxTmpDocSn(map);
			map.put("v_PSN", sn);
			
			try{
				ezApprovalGDAO.deleteTmpReceiptPointInfo(map);
				ezApprovalGDAO.deleteTmpAprOpinionInfo(map);
				ezApprovalGDAO.deleteTmpAprDocAttachInfo(map);
				ezApprovalGDAO.deleteTmpAttachInfo(map);
				ezApprovalGDAO.deleteTmpExpAprLine(map);
				ezApprovalGDAO.deleteTmpAprLineInfo(map);
				ezApprovalGDAO.deleteTmpExpAprDocInfo(map);
				ezApprovalGDAO.deleteTmpAprDocInfo(map);
				
				ezApprovalGDAO.insertTmpReceiptPointInfo(map);
				ezApprovalGDAO.insertTmpAprOpinionInfo(map);
				ezApprovalGDAO.insertTmpAprDocAttachInfo(map);
				ezApprovalGDAO.insertTmpAttachInfo(map);
				ezApprovalGDAO.insertTmpExpAprLine(map);
				ezApprovalGDAO.insertTmpAprLineInfo(map);
				ezApprovalGDAO.insertTmpExpAprDocInfo(map);
				ezApprovalGDAO.insertTmpAprDocInfo(map);
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}

		} else {
			String sn = getMaxTMPDocSN(userID, companyID, lang, tenantID);
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_USERID", userID);
			map.put("v_SN", sn);
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));

			try{
				ezApprovalGDAO.insertTmpReceiptPointInfo(map);
				ezApprovalGDAO.insertTmpAprOpinionInfo(map);
				ezApprovalGDAO.insertTmpAprDocAttachInfo(map);
				ezApprovalGDAO.insertTmpAttachInfo(map);
				ezApprovalGDAO.insertTmpExpAprLine(map);
				ezApprovalGDAO.insertTmpAprLineInfo(map);
				ezApprovalGDAO.insertTmpExpAprDocInfo(map);
				ezApprovalGDAO.insertTmpAprDocInfo(map);
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}
		}
		
		return "TRUE";
	}

	public String getMaxTMPDocSN(String userID, String companyID, String lang, int tenantID) throws Exception{
		int maxCnt = 1;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PUSERID", makeRightField(userID.trim()));
		map.put("v_TENANTID", tenantID);

		maxCnt = ezApprovalGDAO.getMaxTmpDocSN(map);
		
		return String.valueOf(maxCnt);
	}

	public String doBoryu(String docID, String userID, String aprState, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_APRSTATE", aprState);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_DOCID", docID);
		map.put("v_USERID", userID);
		map.put("v_STAASJINHANG", staASJinHang);
		map.put("v_TENANTID", tenantID);
		
		try{
			ezApprovalGDAO.updateBoryuAprLineInfo(map);
			ezApprovalGDAO.updateBoryuAprDocInfo(map);
		} catch(Exception e){
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "FALSE";
		}
		
		sendMsg(docID, "", "BOR", companyID, lang, tenantID);
		
		return "TRUE";
	}

	public String doBansong(String docID, String userID, String aprState, String dirPath, String companyID, String lang, LoginVO userInfo) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		//아직 테넌트 안함
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_APRMEMBERID", userID);
		
		List<ApprGDocListVO> aprTypeList = ezApprovalGDAO.doBanSongAprType(map);
	
		
		if (aprTypeList.get(0).getAprType().equals(staATByungRyulHyubJo)) {
			strSQL.append(doApprove(docID, userID, aprState, ezOrganService.getPropertyValue(userID, "displayName", userInfo.getTenantId()), ezOrganService.getPropertyValue(userID, "displayName2", userInfo.getTenantId()), dirPath, ezOrganService.getPropertyValue(userID, "department", userInfo.getTenantId()), "", companyID, lang, userInfo));
			sendMsg(docID, "", "BAN", companyID, lang, userInfo.getTenantId());
			
			if (strSQL.toString().toUpperCase().equals("FALSE")) {
				return "FALSE";
			} else {
				return strSQL.toString();
			}
		} else {
			strSQL.append("UPDATE TBL_APRLINEINFO SET AprState = '" + aprState + "', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
			strSQL.append(" WHERE DocID = '");
			strSQL.append(docID + "' AND AprMemberID = '" + userID + "' AND (AprState = '" + staASJinHang);
            strSQL.append("' OR AprState = '" + staASBoRyu + "') AND TENANT_ID =" + userInfo.getTenantId() +";\n");
			
            strSQL.append("UPDATE TBL_APRDOCINFO SET FunctionType = '" + aprState + "' WHERE DocID = '" + docID + "' AND TENANT_ID =" + userInfo.getTenantId() +";\n");
			
            strSQL.append("UPDATE TBL_APRLINEINFO SET AprState = '" + staASJinHang + "' WHERE DocID = '" + docID + "' AND AprMemberSN = '1' AND TENANT_ID =" + userInfo.getTenantId() +";\n");
            
            sendMsg(docID, "", "BAN", companyID, lang, userInfo.getTenantId());
            
            return strSQL.toString();
		}
	}

	public String doApprove(String docID, String userID, String aprState, String userName, String userName2, String dirPath, String deptID, String proxyUserID, String companyID, String lang, LoginVO userInfo) throws Exception{
		LOGGER.debug("doApprove started");
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		boolean rtnVal = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID.trim());
		map.put("v_TENANTID", userInfo.getTenantId());
		map.put("v_USERID", userID.trim());
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.doApproveLineInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		String curAprMemberSN = "";
		String curAprType = "";
		String beforeAprMemberSN = "";
		
		if (docXML.getDocumentElement().getChildNodes().getLength() < 1) {
			rtnVal = false;
			
			return "FALSE";
		} else {
			rtnVal = true;
			curAprMemberSN = makeListField(docXML.getElementsByTagName("APRMEMBERSN").item(0).getTextContent());
			curAprType = makeListField(docXML.getElementsByTagName("APRTYPE").item(0).getTextContent());
			beforeAprMemberSN = makeListField(docXML.getElementsByTagName("APRMEMBERSN").item(0).getTextContent());
			
			Map<String, Object> updateAprLineInfo1 = new HashMap<String, Object>();
			updateAprLineInfo1.put("aprState", aprState);
			updateAprLineInfo1.put("nowDate", commonUtil.getTodayUTCTime(""));
			updateAprLineInfo1.put("docID", docID);
			updateAprLineInfo1.put("userID", userID);
			updateAprLineInfo1.put("curAprMemberSN", curAprMemberSN);
			updateAprLineInfo1.put("beforeAprMemberSN", beforeAprMemberSN);
			updateAprLineInfo1.put("tenantID", userInfo.getTenantId());
			
			try{
				ezApprovalGDAO.updateAprLineInfo1(updateAprLineInfo1);
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}
		}
		
		if (!proxyUserID.equals(userID) && !proxyUserID.trim().equals("")) {
			LOGGER.debug("insertProxyUserInfo started");
			subSQL = insertProxyUserInfo(docID, curAprMemberSN, userID, proxyUserID, companyID, lang, userInfo.getTenantId());
			LOGGER.debug("insertProxyUserInfo subSQL = " + subSQL);

			LOGGER.debug("insertProxyUserInfo ended");
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
				return "FALSE";
			} 
		}
		
		if (curAprType.equals(staATByungRyulHyubJo) || curAprType.equals(staATBuSeuByungRyulHyubJo)) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("v_DOCID", docID);
			map1.put("v_TENANTID", userInfo.getTenantId());
			map1.put("v_APRTYPE", curAprType);
			LOGGER.debug("doApproveLineCnt started");

			int subCount = ezApprovalGDAO.doApproveLineCnt(map1);
			LOGGER.debug("doApproveLineCnt subCount = " +subCount);

			LOGGER.debug("doApproveLineCnt ended");

			if (subCount > 1) {
				return strSQL.toString();
			}
		}
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("v_DOCID", docID);
		map2.put("v_TENANTID", userInfo.getTenantId());
		map2.put("v_APRMEMBERSN", curAprMemberSN);
		
		List<ApprGAprLineVO> apprGAprLineVOList2 = ezApprovalGDAO.doApproveLineList(map2);
		
		StringBuffer sb2 = new StringBuffer();
        sb2.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList2.size(); i++) {
			sb2.append(commonUtil.getQueryResult(apprGAprLineVOList2.get(i)));
		}
		sb2.append("</DATA>");
		
		Document docXML2 = commonUtil.convertStringToDocument(sb2.toString());
		
		int k = 0;
		int dlength = docXML2.getElementsByTagName("ROW").getLength();
		String lastState = "";
		boolean whileFlag = true;
		String absentReason = "";
		
		Map<String, Object> map3 = new HashMap<String, Object>();
		map3.put("v_DOCID", docID.trim());
		map3.put("v_TENANTID", userInfo.getTenantId());
		map3.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		
		while (k < dlength && whileFlag) {
		map3.put("v_APRMEMBERSN", docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent());
			switch (docXML2.getElementsByTagName("APRTYPE").item(k).getTextContent().trim()) {
			case "001":
				lastState = staATYilBan;
				
				map3.put("v_APRSTATE", staASJinHang);
				try{
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

					return "FALSE";
				}
				sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());

				whileFlag = false;
				
				break;

			case "002":
				lastState = staatwhoakin;
				
				map3.put("v_APRSTATE", staASJinHang);
				try{
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

					return "FALSE";
				}				
                sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
				
                whileFlag = false;
                
                break;
                
			case "003":
				lastState = staATAnHam;
				
				map3.put("v_APRSTATE", staASSungIn);
				try{
					ezApprovalGDAO.updateAprLineInfo2(map3);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FALSE";
				}				
                k += 1;				
				
                break;
			case "004":
				if (!curAprType.equals("016")) {
					lastState = staATJunGyul;
					
					map3.put("v_APRSTATE", staASJinHang);
					try{
						ezApprovalGDAO.updateAprLineInfo(map3);
					} catch (Exception e) {
						TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						return "FALSE";
					}					
                    sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
					
                    whileFlag = false;
				} else {
					lastState = "003";
					
					map3.put("v_APRSTATE", aprState);

					try{
						ezApprovalGDAO.updateAprLineInfo2(map3);
					} catch (Exception e) {
						TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						return "FALSE";
					}					
					k += 1;
				}
				
				break;
			case "007":
				lastState = staATChamJo;
				
				map3.put("v_APRSTATE", staASAprEND);
				
				try{
					ezApprovalGDAO.updateAprLineInfo2(map3);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FALSE";
				}				
				subSQL = doChamjo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), 
					dirPath, staDSChamJo, companyID, userInfo.getTenantId());

				if (subSQL.toUpperCase() == "FALSE") {
					rtnVal = false;
					whileFlag = false;							
				} else {
                    sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
					
                    k += 1;
				}

				break;
			case "008":
				lastState = staATSoonChaHyubJo;
				
				map3.put("v_APRSTATE", staASJinHang);
				try{
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FALSE";
				}				
				absentReason = getBujaeInfo(docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), userInfo.getTenantId());
				
				if (absentReason.trim().equals("")) {
					sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
					whileFlag = false;
				} else {
					subSQL = setBujaeInfo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), absentReason, "AST", companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
						whileFlag = false;
					} else {
						
						map3.put("v_APRSTATE", staASSungIn);
						map3.put("v_REASONDONOTAPPROV", makeXMLString(absentReason));
						try {
							ezApprovalGDAO.updateAprLineInfo3(map3);
						} catch(Exception e) {
							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
							return "FLASE";
						}
                        k += 1;
					}
				}
				
				break;
			case "009":
				lastState = staATByungRyulHyubJo;
				
				if (!curAprType.equals(staATByungRyulHyubJo)) {
					while (k < dlength && docXML2.getElementsByTagName("APRTYPE").item(k).getTextContent().equals(staATByungRyulHyubJo)) {
						
						map3.put("v_APRSTATE", staASJinHang);
						ezApprovalGDAO.updateAprLineInfo(map3);
						
						absentReason = getBujaeInfo(docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), userInfo.getTenantId());
						
						if (absentReason.trim().equals("")) {
							sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
						} else {
							subSQL = setBujaeInfo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), absentReason, "AST", companyID, lang, userInfo.getTenantId());
							
							if (subSQL.toUpperCase().equals("FALSE")) {
								rtnVal = false;
								whileFlag = false;
							} else {
								map3.put("v_APRSTATE", staASSungIn);
								try {
									ezApprovalGDAO.updateAprLineInfo3(map3);
								} catch(Exception e) {
									TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
									return "FLASE";
								}
							}
						}
						k += 1;
					}
					
					whileFlag = false;
				} else {
					k += 1;
				}
				
				break;
			case "011":
				lastState = staATBuSeuSoonChaHyubJo;
				
				map3.put("v_APRSTATE", staASJinHang);
				try {
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
                subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), 
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
					dirPath, staATBuSeuSoonChaHyubJo, staDSHabYui, 
					docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID, userInfo.getTenantId());
                
                if (subSQL.toUpperCase().equals("FALSE")) {
                	rtnVal = false;
                } 
                
                whileFlag = false;
                
                break;
			case "012":
				lastState = staATBuSeuByungRyulHyubJo;
				
				if (!curAprType.equals(staATBuSeuByungRyulHyubJo)) {
					while (k < dlength && docXML2.getElementsByTagName("APRTYPE").item(k).getTextContent().equals(staATBuSeuByungRyulHyubJo) && whileFlag) {
						
						map3.put("v_APRSTATE", staASJinHang);
						try {
							ezApprovalGDAO.updateAprLineInfo(map3);
						} catch(Exception e) {
							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
							return "FLASE";
						}
						
                        subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), 
                        		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                        		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
							dirPath, staATBuSeuByungRyulHyubJo, staDSHabYui, 
							docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID, userInfo.getTenantId());
                        
                        if (subSQL.toUpperCase().equals("FALSE")) {
                        	rtnVal = false;
                        	whileFlag = false;
                        } else {
                        	k += 1;
                        }
					}
					
					whileFlag = false;
				} else {
					k += 1;
				}
				
				break;
			case "005":
				lastState = staATGamSa;
				
				map3.put("v_APRSTATE", staASJinHang);
				try {
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
				
                subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
					dirPath, staATGamSa, staDSGamSa, docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID, userInfo.getTenantId());
                
                if (subSQL.toUpperCase().equals("FALSE")) {
                	rtnVal = false;
                } 
                
                whileFlag = false;
                
                break;
			case "013":
				lastState = staATGamSaBu;
				
				map3.put("v_APRSTATE", staASJinHang);
				try {
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
				
                subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
					dirPath, staATGamSaBu, staDSGamSaBu, docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID, userInfo.getTenantId());
                
                if (subSQL.toUpperCase().equals("FALSE")) {
                	rtnVal = false;
                } 
                
                whileFlag = false;
                
                break;
			case "017":
				lastState = staATGongram;
				
				map3.put("v_APRSTATE", staASmikyul);
				try {
					ezApprovalGDAO.updateAprLineInfo2(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
				
				subSQL = doChamjo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
						docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent(), 
						docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), 
					dirPath, staDSGongRam, companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
					whileFlag = false;
				} else {
					sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
					k += 1;
				}
				
				break;
			case "018":
				lastState = "018";
				
				map3.put("v_APRSTATE", staASJinHang);
				try {
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
				
                sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID,lang, userInfo.getTenantId());
				
                whileFlag = false;		
				
                break;
			case "019":
				lastState = "019";
				
				map3.put("v_APRSTATE", staASJinHang);
				try {
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
				
				absentReason = getBujaeInfo(docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), userInfo.getTenantId());
				
				if (absentReason.trim().equals("")) {
					sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
					whileFlag = false;
				} else {
					subSQL = setBujaeInfo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), absentReason, "APR", companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
						whileFlag = false;
					} else {
						
						map3.put("v_APRSTATE", staASSungIn);

						try {
							ezApprovalGDAO.updateAprLineInfo3(map3);
						} catch(Exception e) {
							TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
							return "FLASE";
						}
						
                        k += 1;
					}
				}
				
				break;
			case "016":
				lastState = "016";
				
				map3.put("v_APRSTATE", staASJinHang);
				try {
					ezApprovalGDAO.updateAprLineInfo(map3);
				} catch(Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FLASE";
				}
				
				sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang, userInfo.getTenantId());
				
				whileFlag = false;
				
				break;
			default:
				k += 1;
				
				break;
			}
			
			if (k > 1000) {
				whileFlag = false;
				rtnVal = false;
			}
		}
		
		if (dlength < 1 || lastState.equals(staATAnHam) || lastState.equals(staATChamJo) || lastState.equals(staATGongram)) {
			subSQL = doDocComplete(docID, userID, userName, userName2, dirPath, deptID, proxyUserID, companyID, lang, userInfo);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} 
		}
		
		if (rtnVal) {
			LOGGER.debug("doApprove return = " + strSQL.toString() );
			LOGGER.debug("doApprove ended");
			return "TRUE";
		} else {
			return "FALSE";
		}
		
	}

	public String doDocComplete(String docID, String userID, String userName, String userName2, String dirPath, String deptID, String proxyUserID, String companyID, String lang, LoginVO userInfo) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		boolean rtnVal = true;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", userInfo.getTenantId());
		
		List<ApprGAprLineVO> apprGAprLineVOList =  ezApprovalGDAO.doDocCompleteDocInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		String realDocType = "";
		String docType = "";
		String orgDocID = "";
		String orgCompanyID = "";
		String aprLinersID = "";
        String aprLinersName = "";
        String aprLinersName2 = "";
		String aprLinersDeptID = "";
        String aprLinersDeptName = "";
        String aprLinersDeptName2 = "";
		boolean sendFlag = false;
		
		if (docXML.getElementsByTagName("DOCTYPE").item(0) != null) {
			realDocType = makeListField(docXML.getElementsByTagName("DOCTYPE").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("DOCSTATE").item(0) != null) {
			docType = makeListField(docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("ORGDOCID").item(0) != null) {
			orgDocID = makeListField(docXML.getElementsByTagName("ORGDOCID").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("COMPANYID").item(0) != null) {
			orgCompanyID = makeListField(docXML.getElementsByTagName("COMPANYID").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERID").item(0) != null) {
			aprLinersID = makeListField(docXML.getElementsByTagName("APRMEMBERID").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERNAME").item(0) != null) {
			aprLinersName = makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERNAME2").item(0) != null) {
			aprLinersName2 = makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERDEPTID").item(0) != null) {
			aprLinersDeptID = makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(0) != null) {
			aprLinersDeptName = makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(0) != null) {
			aprLinersDeptName2 = makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(0).getTextContent());
		}
		
		String flag = getCode2Name("A35", "002", companyID, lang, userInfo.getTenantId()).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");
		
		switch (docType) {
		case "001":
			if (!realDocType.equals("001")) {
				subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			} else {
				String autoDeptID = getCode2Name("A55", "001", companyID, lang,userInfo.getTenantId()).trim();
				LOGGER.debug("getCode2Name ended.");

				if (!autoDeptID.equals("")) {
					int addressCount = ezApprovalGDAO.doDocCompleteReceiptCnt(map);
					
					if (addressCount > 0) {
						strSQL.append("UPDATE TBL_RECEIPTPOINTINFO SET ProcessYN = 'O' WHERE DocID = '" + docID + "'" + " AND TENANT_ID="+userInfo.getTenantId()+" ;\n");
					}
				}
			}
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				subSQL = setCabinetRec(docID, companyID, lang , userInfo.getTenantId(), userInfo.getOffset());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang , userInfo.getTenantId());
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID , userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
		
			
			break;
			
		case "004":
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} 
			
			if (rtnVal) {
				sendMsg(docID, "", "BAL", companyID, lang, userInfo.getTenantId());
				subSQL = deleteDocInfo(docID, "MUST", companyID , userInfo.getTenantId());
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
				
			}

			break;
			
		case "011":
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} 
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				subSQL = updateSusinResult(orgDocID, aprLinersDeptID, aprLinersID, "Y", aprLinersName, aprLinersName2, orgCompanyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = setCabinetRecv(docID, userID, userName, userName2, deptID, companyID, lang, userInfo.getTenantId(), userInfo.getOffset());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang, userInfo.getTenantId());
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
	
			
			break;
			
		case "012":
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} 
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				subSQL = updateHabyuiResult(docID, companyID, orgDocID, orgCompanyID, aprLinersDeptID, aprLinersDeptName, aprLinersDeptName2, "Y", lang, userInfo);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = doApprove(orgDocID, aprLinersDeptID, staASSungIn, aprLinersDeptName, aprLinersDeptName2, dirPath, deptID, "", orgCompanyID, lang, userInfo);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				subSQL = setCabinetRec(docID, companyID, lang, userInfo.getTenantId(), userInfo.getOffset());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang, userInfo.getTenantId());
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
		
			
			break;
			
		case "014":
			if (!flag.equals("G")) {
				if (!realDocType.equals("001")) {
					subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						sendFlag = false;
					}
				}
				
				if (rtnVal) {
					subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}

				if (rtnVal) {
					subSQL = setCabinetRec(docID, companyID, lang, userInfo.getTenantId(), userInfo.getOffset());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				if (rtnVal) {
					sendMsg(docID, "", "END", companyID, lang, userInfo.getTenantId());
				}
				
				if (rtnVal) {
					subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
			
			} else {
				subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				}
				
				if (rtnVal) {
					subSQL = updateGamsaResult(docID, companyID, orgDocID, orgCompanyID, aprLinersDeptID, aprLinersDeptName, aprLinersDeptName2, "Y", lang, userInfo);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = doApprove(orgDocID, aprLinersDeptID, staASSungIn, aprLinersDeptName, aprLinersDeptName2, dirPath, deptID, "", orgCompanyID, lang, userInfo);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
				if (rtnVal) {
					sendMsg(docID, "", "END", companyID, lang, userInfo.getTenantId());
				}
				
				if (rtnVal) {
					subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} 
				}
				
			
			}
			
			break;
			
		case "017":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			}
			
			if (rtnVal) {
				subSQL = updateChamjoResult(orgDocID, deptID, userID, orgCompanyID,  userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			break;
			
		case "015":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			}
			
			if (rtnVal) {
				subSQL = updateChamjoResult(orgDocID, deptID, userID, orgCompanyID ,userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			break;
			
		case "003":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			}
			
			if (rtnVal) {
				subSQL = updateGamsaResult(docID, companyID, orgDocID, orgCompanyID, aprLinersDeptID, aprLinersDeptName, aprLinersDeptName2, "Y", lang, userInfo);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = doApprove(orgDocID, aprLinersDeptID, staASSungIn, aprLinersDeptName, aprLinersDeptName2, dirPath, deptID, "", orgCompanyID, lang, userInfo);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang, userInfo.getTenantId());
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 

			}
			
			break;
			
		case "024":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} 
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 

			}
			
			break;
			
		default:
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, userInfo.getTenantId());
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} 
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang, userInfo.getTenantId());
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID, userInfo.getTenantId());
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} 

			}
			
			break;
		}
		
		if (rtnVal) {
			return "TRUE";
		} else {
			return "FALSE";
		}
	}

	public String updateChamjoResult(String orgDocID, String deptID, String userID, String orgCompanyID, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		strSQL.append("UPDATE TBL_APRLINEINFO SET ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
		strSQL.append(", AprState = '" + staASSungIn + "' WHERE DocID = '" + orgDocID);
		strSQL.append("' AND AprMemberDeptID = '" + deptID + "' AND AprMemberID = '" + userID);
		strSQL.append("' AND AprState = '" + staASmikyul + "' AND TENANT_ID = " + tenantID + ";\n");

		strSQL.append("UPDATE TBL_ENDAPRLINEINFO SET ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
		strSQL.append(", AprState = '" + staASSungIn + "' WHERE DocID = '" + orgDocID);
		strSQL.append("' AND AprMemberDeptID = '" + deptID + "' AND AprMemberID = '" + userID);
        strSQL.append("' AND AprState = '" + staASmikyul + "' AND TENANT_ID = " + tenantID + ";\n");
        
		return strSQL.toString();
	}

	public String updateGamsaResult(String docID, String companyID, String orgDocID, String orgCompanyID, String aprLinersDeptID, String aprLinersDeptName, String aprLinersDeptName2, String mode,
			String lang, LoginVO userInfo) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		
		subSQL = setLastOpinionToOrgDoc(docID, orgDocID, companyID, orgCompanyID, "QUERY", lang, userInfo.getTenantId());
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		String signType = "TEXT";
		String signTitle = "";
		String signCont = "";
		
		if (mode.toUpperCase().equals("H")) {
			signCont = messageSource.getMessage("ezApprovalG.t1434",userInfo.getLocale());
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_LANGTYPE", lang);
			
			List<ApprGSignInfoVO> apprGSignInfoVOList = ezApprovalGDAO.updateHabyuiResultSignInfo(map);
			
			StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < apprGSignInfoVOList.size(); i++) {
				sb.append(commonUtil.getQueryResult(apprGSignInfoVOList.get(i)));
			}
			sb.append("</DATA>");
			
			Document signXML = commonUtil.convertStringToDocument(sb.toString());
			
			if (signXML.getDocumentElement().getChildNodes().getLength() > 0) {
				signType = makeListField(signXML.getElementsByTagName("SIGNTYPE").item(0).getTextContent());
				signCont = makeListField(signXML.getElementsByTagName("CONTENT").item(0).getTextContent());
			} else {
				signCont = makeListField(ezApprovalGDAO.updateHabyuiResultAprMemberNM(map));
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_LANGTYPE", lang);
		
		signTitle = makeListField(ezApprovalGDAO.updateHabyuiResultAprMemberJobTitle(map));
		
		if (signTitle.trim().equals("")) {
			signTitle = "-";
		}
		
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<SIGNINFOS>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + "examposition" + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + signTitle + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + signType + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + "examnaja" + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + signCont + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + "examdate" + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + signCont + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("</SIGNINFOS>");
		
		subSQL += updateSignInfo(resultXML, orgCompanyID, "QUERY", userInfo.getTenantId());
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		return strSQL.toString();
	}

	public String updateHabyuiResult(String docID, String companyID, String orgDocID, String orgCompanyID, String deptID, String deptName, String deptName2, String mode, String lang, LoginVO userInfo) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		
		subSQL = setLastOpinionToOrgDoc(docID, orgDocID, companyID, orgCompanyID, "QUERY", lang, userInfo.getTenantId());
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		String signType = "TEXT";
		String signTitle = "";
		String signCont = "";
		
		if (mode.toUpperCase().equals("H")) {
			signCont = messageSource.getMessage("ezApprovalG.t1434", userInfo.getLocale());
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_LANGTYPE", lang);
			map.put("v_TENANTID", userInfo.getTenantId());
			
			List<ApprGSignInfoVO> apprGSignInfoVOList = ezApprovalGDAO.updateHabyuiResultSignInfo(map);
			
			StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < apprGSignInfoVOList.size(); i++) {
				sb.append(commonUtil.getQueryResult(apprGSignInfoVOList.get(i)));
			}
			sb.append("</DATA>");
			
			Document signXML = commonUtil.convertStringToDocument(sb.toString());
			
			if (signXML.getDocumentElement().getChildNodes().getLength() > 0) {
				signType = makeListField(signXML.getElementsByTagName("SIGNTYPE").item(0).getTextContent());
				signCont = makeListField(signXML.getElementsByTagName("CONTENT").item(0).getTextContent());
			} else {
				signCont = makeListField(ezApprovalGDAO.updateHabyuiResultAprMemberNM(map));
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", userInfo.getTenantId());
		
		signTitle = makeListField(ezApprovalGDAO.updateHabyuiResultAprMemberJobTitle(map));
		
		if (signTitle.trim().equals("")) {
			signTitle = "-";
		}
		
		String susinSN = getSusinSNInside(orgDocID, orgCompanyID, userInfo.getTenantId());
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.updateHabyuiResultAprMember(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		int aprSN = 0;
		
		for (int k = 0; k < dlength; k++) {
			if (docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent().toLowerCase().equals(deptID.toLowerCase()) && docXML.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent().toUpperCase().equals("Y")) {
				aprSN = k + 1;
				k = dlength;
			}
		}
		
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<SIGNINFOS>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + susinSN + "habyui" + aprSN + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + deptName + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + susinSN + "habyuipositon" + aprSN + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + signTitle + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + signType + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + susinSN + "habyuisign" + aprSN + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + signCont + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("<SIGNINFO>");
		resultXML.append("<DOCID>" + orgDocID + "</DOCID>");
		resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
		resultXML.append("<SIGNNAME>" + susinSN + "habyuidate" + aprSN + "</SIGNNAME>");
		resultXML.append("<CONTENT>" + commonUtil.getTodayUTCTime("").substring(6, 10) + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("</SIGNINFOS>");
		
		subSQL = updateSignInfo(resultXML, orgCompanyID, "QUERY", userInfo.getTenantId());
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		return strSQL.toString();
	}

	public String setLastOpinionToOrgDoc(String docID, String orgDocID, String companyID, String orgCompanyID, String mode, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		boolean rtnVal = true;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGOpinionVO> apprGOpinionVOList = ezApprovalGDAO.setLastOpinionToOrgDoc(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGOpinionVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGOpinionVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		if (dlength > 0) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("companyID", companyID);
			map1.put("v_ORGDOCID", orgDocID);
			map1.put("v_TENANTID", tenantID);
			
			int nextSN = ezApprovalGDAO.setLastOpinionToOrgDocOpinionSN(map1);
			
			nextSN += 1;
			
            strSQL.append("INSERT INTO TBL_APROPINIONINFO (DocID, UserID, OpinionGB, ");
            strSQL.append("Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN, TENANT_ID) VALUES ('" + orgDocID + "', '");
			strSQL.append(makeRightField(docXML.getElementsByTagName("USERID").item(0).getTextContent()) + "', '");
			strSQL.append(makeRightField(docXML.getElementsByTagName("OPINIONGB").item(0).getTextContent()) + "', '");
			strSQL.append(makeRightField(docXML.getElementsByTagName("CONTENT").item(0).getTextContent()) + "', N'");
			strSQL.append(makeRightField(docXML.getElementsByTagName("USERNAME").item(0).getTextContent()) + "', N'");
            strSQL.append(makeRightField(docXML.getElementsByTagName("USERNAME2").item(0).getTextContent()) + "', N'");
			strSQL.append(makeRightField(docXML.getElementsByTagName("USERJOBTITLE").item(0).getTextContent()) + "', N'");
            strSQL.append(makeRightField(docXML.getElementsByTagName("USERJOBTITLE2").item(0).getTextContent()) + "', '");
			strSQL.append(makeRightField(docXML.getElementsByTagName("USERDEPTID").item(0).getTextContent()) + "', N'");
			strSQL.append(makeRightField(docXML.getElementsByTagName("USERDEPTNAME").item(0).getTextContent()) + "', N'");
            strSQL.append(makeRightField(docXML.getElementsByTagName("USERDEPTNAME2").item(0).getTextContent()) + "', '");
			strSQL.append(makeRightField(String.valueOf(nextSN)) + "'," + tenantID +");\n");
			
			strSQL.append("UPDATE TBL_APRDOCINFO SET HasOpinionYN = 'Y' WHERE DocID = '" + orgDocID + "' AND TENANT_ID = " + tenantID +";\n");
			
			if (mode.toUpperCase().equals("QUERY")) {
				rtnVal = true;
			} else {
				try {
					Map<String, Object> map2 = new HashMap<String, Object>();
					map2.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
					map2.put("companyID", orgCompanyID);
					
					ezApprovalGDAO.transactionSQL(map2);
					
					rtnVal = true;
				} catch (Exception e) {
					rtnVal = false;
				}
			}
		}
		
		if (mode.toUpperCase().equals("QUERY")) {
			if (rtnVal) {
				return strSQL.toString();
			} else {
				return "FALSE";
			}
		} else {
			if (rtnVal) {
				return "<RESULT>TRUE</RESULT>";
			} else {
				return "<RESULT>FALSE</RESULT>";
			}
		}
	}

	public String setCabinetRecv(String docID, String userID, String userName, String userName2, String deptID, String companyID, String lang, int tenantID, String offSet) throws Exception{
		String strSQL = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		String writerDeptID = ezApprovalGDAO.setCabinetRecvAprMemdtID(map);
		
		if (writerDeptID.trim().equals("")) {
			writerDeptID = deptID;
		}
		
		String writerDeptName = ezOrganService.getPropertyValue(writerDeptID, "displayName", tenantID);
		String writerDeptName2 = ezOrganService.getPropertyValue(writerDeptID, "displayName2", tenantID);
		
		List<ApprGCabinetRecVO> apprGCabinetRecVOList = ezApprovalGDAO.setCabinetRecvList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGCabinetRecVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGCabinetRecVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("DOCNO").getLength() > 0) {
			String docSN = docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent().trim();
			docSN = docSN.substring(docSN.length() - 6);
			
			String hasAttach = "0";
			
			if (docXML.getElementsByTagName("HASATTACHYN").item(0).getTextContent().trim().toUpperCase().equals("Y")) {
				hasAttach = "1";
			}
			
			String seperateAttachXML = makeListField(docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent().trim());
			String numOfPage = makeListField(docXML.getElementsByTagName("PAGENUM").item(0).getTextContent().trim());
			
			if (numOfPage.trim().equals("")) {
				numOfPage = "1";
			}
			
			String deliverySN = makeListField(docXML.getElementsByTagName("SN").item(0).getTextContent().trim());
			
			strSQL = regDocToCabinet("0", docID, docSN, 
					docXML.getElementsByTagName("CABINETID").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("DOCTITLE").item(0).getTextContent().trim(),
                    writerDeptID, writerDeptName, writerDeptName2, "2", ezOrganService.getPropertyValue(userID, "title", tenantID), ezOrganService.getPropertyValue(userID, "title2", tenantID),
                    docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim(),
                    commonUtil.getTodayUTCTime("yyyy-MM-dd"), userName, userName2, deliverySN, "1", 
					docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim(), 
					"0", numOfPage, hasAttach, seperateAttachXML, companyID, lang, tenantID, offSet);
		} else {
			return "FALSE";
		}
		
		return strSQL;
	}

	public String updateSusinResult(String orgDocID, String deptID, String userID, String mode, String userName, String userName2, String companyID, int tenantID) throws Exception{
		String strSQL = "";
		String processFlag = mode.toUpperCase();
		
		if (!userID.trim().equals("")) {
			userName = ezOrganService.getPropertyValue(userID, "displayName", tenantID);
			userName2 = ezOrganService.getPropertyValue(userID, "displayName2", tenantID);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", orgDocID);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		String receiptUserID = makeListField(ezApprovalGDAO.updateSusinResultReceipt(map));
		
		if (receiptUserID.toUpperCase().equals(userID.toUpperCase())) {
			strSQL = "UPDATE TBL_ENDRECEIPTPOINTINFO SET ProcessYN = '" + processFlag + "', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')" + 
					" WHERE DocID = '" + orgDocID + 
					"' AND ReceiptPointID = '" + deptID + "' AND ReceiptMemberID = '" + userID + "' AND TENANT_ID =" + tenantID +";\n";
		} else {
			strSQL = "UPDATE TBL_ENDRECEIPTPOINTINFO SET ProcessYN = '" + processFlag + "', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')" + 
				", ReceiptMemberID = '" + userID +
                "', ReceiptMemberName = '" + userName + "', ReceiptMemberName2 = '" + userName2 + "' WHERE DocID = '" + orgDocID + 
				"' AND ReceiptPointID = '" + deptID + "' AND ProcessYN <> '" + processFlag + "' AND TENANT_ID =" + tenantID +";\n";
		}
	
		return strSQL;
	}

	public String setCabinetRec(String docID, String companyID, String lang, int tenantID, String offSet) throws Exception{
		String strSQL = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGCabinetRecVO> apprGCabinetRecVOList = ezApprovalGDAO.setCabinetRecList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGCabinetRecVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGCabinetRecVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("DOCNO").getLength() > 0) {
			String docSN = docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent().trim();
			
			docSN = docSN.substring(docSN.length() - 6);
			
			int pDocSN = Integer.parseInt(docSN);
			
			docSN = String.valueOf(pDocSN);
			
			String hasAttach = "0";
			
			if (docXML.getElementsByTagName("HASATTACHYN").item(0).getTextContent().trim().toUpperCase().equals("Y")) {
				hasAttach = "1";
			}
			
			String seperateAttachXML = makeListField(docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent().trim());
			String numOfPage = makeListField(docXML.getElementsByTagName("PAGENUM").item(0).getTextContent().trim());
			
			if (numOfPage.trim().equals("")) {
				numOfPage = "1";
			}
			
			strSQL = regDocToCabinet("0", docID, docSN, 
					docXML.getElementsByTagName("CABINETID").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("DOCTITLE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent().trim(),
                    "1", docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim(), 
					commonUtil.getTodayUTCTime("").substring(0, 10),
                    docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim(), "", "1", 
					docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim(), 
					"0", numOfPage, hasAttach, seperateAttachXML, companyID, lang, tenantID, offSet);
		} else {
			return "FALSE";
		}
		
		return strSQL;
	}

	private String regDocToCabinet(String manualFlag, String docID, String regSN, String cabinetID, String title, String deptCode, String deptName, String deptName2, String registerType, String aprMemberTitle, String aprMemberTitle2,
			String drafterName, String drafterName2, String executeDate, String receiptMember, String receiptMember2, String deleveryNo, String electronic, String sourceDocID, String specialRec, String publicCode, String limitRange, String rejectFlag,
			String numOfPage, String attachFlag, String seperateAttachXML, String companyID, String lang, int tenantID, String offSet) throws Exception{
		String strSQL = "";
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<PARAMETERS>");
		resultXML.append("<MANUALFLAG>" + manualFlag + "</MANUALFLAG>");
		resultXML.append("<DOCID>" + docID + "</DOCID>");
		resultXML.append("<REGSN>" + regSN + "</REGSN>");
		resultXML.append("<CABINETID>" + cabinetID + "</CABINETID>");
		if (title.length() > 50) {
			resultXML.append("<TITLE>" + title.substring(0, 50) + "</TITLE>");
		} else {
			resultXML.append("<TITLE>" + title + "</TITLE>");
		}
		resultXML.append("<DEPTCODE>" + deptCode + "</DEPTCODE>");
		resultXML.append("<DEPTNAME>" + deptName + "</DEPTNAME>");
		resultXML.append("<DEPTNAME2>" + deptName2 + "</DEPTNAME2>");
		resultXML.append("<REGISTERTYPE>" + registerType + "</REGISTERTYPE>");
		resultXML.append("<APRMEMBERTITLE>" + aprMemberTitle + "</APRMEMBERTITLE>");
		resultXML.append("<APRMEMBERTITLE2>" + aprMemberTitle2 + "</APRMEMBERTITLE2>");
		resultXML.append("<DRAFTERNAME>" + drafterName + "</DRAFTERNAME>");
		resultXML.append("<DRAFTERNAME2>" + drafterName2 + "</DRAFTERNAME2>");
		resultXML.append("<EXECUTEDATE>" + executeDate + "</EXECUTEDATE>");
		resultXML.append("<RECEIPTMEMBER>" + receiptMember + "</RECEIPTMEMBER>");
		resultXML.append("<RECEIPTMEMBER2>" + receiptMember2 + "</RECEIPTMEMBER2>");
		resultXML.append("<DELIVERYNO>" + deleveryNo + "</DELIVERYNO>");
		resultXML.append("<ELECTRONICRECFLAG>" + electronic + "</ELECTRONICRECFLAG>");
		resultXML.append("<ORIGINREGSN>" + sourceDocID + "</ORIGINREGSN>");
		resultXML.append("<SPECIALREC>" + specialRec + "</SPECIALREC>");
		resultXML.append("<PUBLICCODE>" + publicCode + "</PUBLICCODE>");
		resultXML.append("<LIMITRANGE>" + limitRange + "</LIMITRANGE>");
		resultXML.append("<NUMOFPAGE>" + numOfPage + "</NUMOFPAGE>");
		resultXML.append("<REJECTFLAG>" + rejectFlag + "</REJECTFLAG>");
		resultXML.append("<ATTACHFLAG>" + attachFlag + "</ATTACHFLAG>");
		resultXML.append("<SEPATTACHINFO>");
		if (!seperateAttachXML.trim().equals("")) {
			Document seperateXML = commonUtil.convertStringToDocument(seperateAttachXML);
			
			for (int k = 0; k < seperateXML.getDocumentElement().getChildNodes().getLength(); k++) {
				resultXML.append("<SEPATTACH>");
				resultXML.append("<CABINETID>" + seperateXML.getDocumentElement().getChildNodes().item(k).getChildNodes().item(0).getTextContent().trim() + "</CABINETID>");
				resultXML.append("<TITLE>" + seperateXML.getDocumentElement().getChildNodes().item(k).getChildNodes().item(1).getTextContent().trim() + "</TITLE>");
				resultXML.append("<NUMOFPAGE>" + seperateXML.getDocumentElement().getChildNodes().item(k).getChildNodes().item(2).getTextContent().trim() + "</NUMOFPAGE>");
				resultXML.append("<REGTYPE>" + seperateXML.getDocumentElement().getChildNodes().item(k).getChildNodes().item(3).getTextContent().trim() + "</REGTYPE>");
				resultXML.append("<SUMMARY>" + seperateXML.getDocumentElement().getChildNodes().item(k).getChildNodes().item(4).getTextContent().trim() + "</SUMMARY>");
				resultXML.append("<AVTYPE>" + seperateXML.getDocumentElement().getChildNodes().item(k).getChildNodes().item(5).getTextContent().trim() + "</AVTYPE>");
				resultXML.append("</SEPATTACH>");
			}
		}
		resultXML.append("</SEPATTACHINFO>");
		resultXML.append("<LANGTYPE>" + lang + "</LANGTYPE>");
		resultXML.append("<COMPANYID>" + companyID + "</COMPANYID>");
		resultXML.append("</PARAMETERS>");
		
		strSQL = registerRecordOfQuery(resultXML.toString(), tenantID, offSet);
		
		return strSQL;
	}

	public String registerRecordOfQuery(String strXML, int tenantID, String offSet) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		Document objParam = commonUtil.convertStringToDocument(strXML);
		String subSQL = "";
		String rtnVal = "TRUE";
		
		String companyID = objParam.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String cabID = objParam.getElementsByTagName("CABINETID").item(0).getTextContent();
		String manualFlag = objParam.getElementsByTagName("MANUALFLAG").item(0).getTextContent();
		String deptCode = objParam.getElementsByTagName("DEPTCODE").item(0).getTextContent();
		String deptName = objParam.getElementsByTagName("DEPTNAME").item(0).getTextContent();
		String deptName2 = objParam.getElementsByTagName("DEPTNAME2").item(0).getTextContent();
		String registerType = objParam.getElementsByTagName("REGISTERTYPE").item(0).getTextContent();
		String langType = objParam.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		String registerDate = "";
		String specialCatalogFlag = "";
		String regSN = "";
		String rejectFlag = "0";
		String attachFlag = "0";
		String docID = "";
		String processDate = "";
		
		if (manualFlag.equals("1")) {
			registerDate = objParam.getElementsByTagName("REGISTERDATE").item(0).getTextContent();
			specialCatalogFlag = objParam.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent();
			regSN = getSerialNum("002", deptCode, "", companyID, langType, tenantID);
			
			if (regSN.equals("")) {
				return "FALSE";
			}
		} else {
			registerDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime(""), offSet , false);
			specialCatalogFlag = getRecordSCFlag(cabID, companyID, tenantID);
			regSN = objParam.getElementsByTagName("REGSN").item(0).getTextContent();
			rejectFlag = objParam.getElementsByTagName("REJECTFLAG").item(0).getTextContent();
			attachFlag = objParam.getElementsByTagName("ATTACHFLAG").item(0).getTextContent();
			docID = objParam.getElementsByTagName("DOCID").item(0).getTextContent();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_TENANTID", tenantID);

			
			processDate = ezApprovalGDAO.getDraftDate(map);
			
			if (processDate != null && !processDate.equals("")) {
				if (registerType.equals("2")) {
					registerDate = processDate;
				}
			} else {
				processDate = registerDate;
			}
		}
		
		if (!regSN.trim().equals("")) {
			regSN = formatSerialNum(regSN);
		}
		
		String regYear = getAccountingYear(processDate, companyID, langType, tenantID);
		String title = objParam.getElementsByTagName("TITLE").item(0).getTextContent();
		String numOfPage = objParam.getElementsByTagName("NUMOFPAGE").item(0).getTextContent();
		String aprMemberTitle = objParam.getElementsByTagName("APRMEMBERTITLE").item(0).getTextContent();
		String aprMemberTitle2 = objParam.getElementsByTagName("APRMEMBERTITLE2").item(0).getTextContent();
		String drafterName = objParam.getElementsByTagName("DRAFTERNAME").item(0).getTextContent();
		String drafterName2 = objParam.getElementsByTagName("DRAFTERNAME2").item(0).getTextContent();
		String executeDate = objParam.getElementsByTagName("EXECUTEDATE").item(0).getTextContent();
		String receiptMember = objParam.getElementsByTagName("RECEIPTMEMBER").item(0).getTextContent();
		String receiptMember2 = objParam.getElementsByTagName("RECEIPTMEMBER2").item(0).getTextContent();
		String deliveryNo = objParam.getElementsByTagName("DELIVERYNO").item(0).getTextContent();
		String electronicRecFlag = objParam.getElementsByTagName("ELECTRONICRECFLAG").item(0).getTextContent();
		String specialRec = objParam.getElementsByTagName("SPECIALREC").item(0).getTextContent();
		String publicCode = objParam.getElementsByTagName("PUBLICCODE").item(0).getTextContent();
		String limitRange = objParam.getElementsByTagName("LIMITRANGE").item(0).getTextContent();
		String docType = "";
		String visualAudioDesc = "";
		String visualAudioType = "";
		String originRegSN = objParam.getElementsByTagName("ORIGINREGSN").item(0).getTextContent();
		String oldFlag = "1";
		String recordID = deptCode + regYear + regSN;
		String registerSN = deptCode + regSN;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_RECORDID", makeRightField(recordID));
		map.put("v_DOCID", makeRightField(docID));
		map.put("v_DEPTNAME", makeRightField(deptName));
		map.put("v_DEPTNAME2", makeRightField(deptName2));
		map.put("v_DEPTCODE", makeRightField(deptCode));
		map.put("v_REGYEAR", makeRightField(regYear));
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_REGISTERSN", makeRightField(registerSN));
		map.put("v_APRMEMBERTITLE", makeRightField(aprMemberTitle));
		map.put("v_APRMEMBERTITLE2", makeRightField(aprMemberTitle2));
		map.put("v_DRAFTERNAME", makeRightField(drafterName));
		map.put("v_DRAFTERNAME2", makeRightField(drafterName2));
		map.put("v_EXECUTEDATE", makeRightField(executeDate));
		map.put("v_RECEIPTMEMBER", makeRightField(receiptMember));
		map.put("v_RECEIPTMEMBER2", makeRightField(receiptMember2));
		map.put("v_DELIVERYNO", makeRightField(deliveryNo));
		map.put("v_ORIGINREGSN", makeRightField(originRegSN));
		map.put("v_ELECTRONICRECFLAG", makeRightField(electronicRecFlag));
		map.put("v_SPECIALREC", makeRightField(specialRec));
		map.put("v_PUBLICCODE", makeRightField(publicCode));
		map.put("v_LIMITRANGE", makeRightField(limitRange));
		map.put("v_OLDFLAG", makeRightField(oldFlag));
		map.put("v_DELFLAG", makeRightField("0"));
		map.put("v_SPECIALCATALOGFLAG", makeRightField(specialCatalogFlag));
		map.put("v_LIMITRANGE", makeRightField(limitRange));
		map.put("v_OLDFLAG", makeRightField(oldFlag));
		map.put("v_SPECIALCATALOGFLAG", makeRightField(specialCatalogFlag));
		map.put("v_ATTACHFLAG", makeRightField(attachFlag));
		map.put("v_REJECTFLAG", makeRightField(rejectFlag));
		map.put("v_MANUALFLAG", makeRightField(manualFlag));
		map.put("v_DOCTYPE", makeRightField(docType));
		map.put("v_TENANTID",  tenantID);
		
		try{
			ezApprovalGDAO.insertRecord(map);
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "FALSE";
		}
        
        subSQL = registerSepAttachEx(recordID, cabID, title, numOfPage, registerType, visualAudioDesc, visualAudioType, companyID, formatSepSerialNum("00"), tenantID);
        
        if (subSQL.equals("FALSE")) {
        	return "FALSE";
        } else {
        	rtnVal ="TRUE";
        }
        
        if (objParam.getElementsByTagName("SEPATTACH").getLength() > 0) {
        	for (int k = 0; k < objParam.getElementsByTagName("SEPATTACH").getLength(); k++) {
        		int tempValue = k + 1;
        		subSQL = registerSepAttachEx(recordID, objParam.getElementsByTagName("CABINETID").item(k).getTextContent(), objParam.getElementsByTagName("TITLE").item(k).getTextContent(), objParam.getElementsByTagName("NUMOFPAGE").item(k).getTextContent(), objParam.getElementsByTagName("REGTYPE").item(k).getTextContent(), objParam.getElementsByTagName("SUMMARY").item(k).getTextContent(), objParam.getElementsByTagName("AVTYPE").item(k).getTextContent(), companyID, formatSepSerialNum(String.valueOf(tempValue)), tenantID);
        		
        		if (subSQL.equals("FALSE")) {
        			return "FALSE";
        		} else {
        			rtnVal = "TRUE";
        		}
        	}
        }
        NodeList nodeSL = objParam.getDocumentElement().getElementsByTagName("SPECIALCATALOGINFO");
        
        if (specialCatalogFlag != null && nodeSL != null && specialCatalogFlag.equals("2")) {
        	subSQL = saveSpecialInfoRec(recordID, cabID, objParam, tenantID);
        	
        	if (subSQL.equals("FALSE")) {
        		return "FALSE";
        	} 
        }
        
		return rtnVal;
	}

	public String saveSpecialInfoRec(String recordID, String cabID, Document objParam, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_RECORDID",  makeRightField(recordID));
		map.put("v_CABID",  makeRightField(cabID));
		map.put("v_TENANTID",  tenantID);
		
		try {
			ezApprovalGDAO.insertSpecialCatalogInfo_Rec(map);
		} catch(Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "FALSE";
		}
		
        NodeList nodeData = objParam.getElementsByTagName("SCDATA");
        if (nodeData.getLength() > 0) {
        	for (int k = 0; k < nodeData.getLength(); k++) {
        		
        		map.put("v_SERIALNO",  makeRightField(nodeData.item(k).getChildNodes().item(0).getTextContent().trim()));
        		map.put("v_SC1",  makeRightField(nodeData.item(k).getChildNodes().item(1).getTextContent().trim()));
        		map.put("v_SC2",  makeRightField(nodeData.item(k).getChildNodes().item(2).getTextContent().trim()));
        		map.put("v_SC3",  makeRightField(nodeData.item(k).getChildNodes().item(3).getTextContent().trim()));

        		try {
        			ezApprovalGDAO.insertSpecialCatalogInfo_Rec2(map);
        		} catch(Exception e) {
        			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
        			return "FALSE";
        		}
        	}
        }
        
		return "TRUE";
	}

	private String formatSerialNum(String strValue) throws Exception{
		return getNDigitNum(strValue, 6);
	}

	public String getRecordSCFlag(String cabID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabID);
		map.put("v_TENANTID", tenantID);

		return ezApprovalGDAO.getRecordSCFlag(map);
	}

	public String getSerialNum(String snType1, String snType2, String snType3, String companyID, String langType, int tenantID) throws Exception{
		String accountYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, langType ,tenantID);
		
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("iv_Type1", snType1);
		map.put("iv_Type2", snType2);
		map.put("iv_Type3", snType3);
		map.put("v_AccountYear", accountYear);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE",commonUtil.getTodayUTCTime(""));
		
		String result = ezApprovalGDAO.spGetSerialNo(map);
		map.put("v_CurSN", result);
		if (result == null) {
			map.put("v_CurSN", "1");
			ezApprovalGDAO.insertSerialNo(map);
			result = "1";
		}
		
		int rollBackFlag =  ezApprovalGDAO.rollBackFlag(map);
		
		if (rollBackFlag == 1) {
			 ezApprovalGDAO.deleteSerialNo(map);
		} else {
			ezApprovalGDAO.updateSerialNo(map);
			result = Integer.toString((Integer.parseInt(result) + 1));
		}
		return String.valueOf(result);
	}

	public String doApproveEnd(String docID, String dirPath, String deptID, boolean sendFlag, String companyID, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		boolean rtnVal = true;
		String docState = "";
		String href = "";
		String orgDeptID = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.doApproveEndDocInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("DOCSTATE").item(0) != null) {
			docState = makeListField(docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("HREF").item(0) != null) {
			href = makeListField(docXML.getElementsByTagName("HREF").item(0).getTextContent());
		}
		if (docXML.getElementsByTagName("APRMEMBERDEPTID").item(0) != null) {
			orgDeptID = makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(0).getTextContent());
		}
		if (orgDeptID.trim().equals("")) {
			orgDeptID = deptID;
		}
		
		if (docState.trim().equals("") && !sendFlag) {
			rtnVal = false;
		} else {
			switch (docState) {
			case "017":
				break;

			default:
				if (sendFlag) {
					docState = staDSBalsin;
				}
				
				if (docState.equals(staDSGongRam)) {
					orgDeptID = deptID;
				}
				
				String containerID = returnContainerID(orgDeptID, docState, companyID, tenantID);
				String extFileName = getExtendedFileName(href);
				String oldYear = getDocHrefYear(docID, companyID, tenantID);
				String endURL = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName;
				String source = dirPath + commonUtil.separator + href.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator, "");
				
				rtnVal = copyFile(source, dirPath + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName, dirPath + commonUtil.separator + companyID + commonUtil.separator + "doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID));
				if (rtnVal) {
					strSQL.append( " INSERT INTO TBL_ENDAPRDOCINFO ( DocID, FormID, OrgDocID, DocType, DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, WriterID, EndDate, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ContainerID, isPublic, TENANT_ID )" +
							"( SELECT '" + docID +"', FormID, OrgDocID, DocType, DocState, '003','" + endURL +"', DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, WriterID, TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, '"+ containerID + "', isPublic, TENANT_ID  FROM TBL_APRDOCINFO  WHERE  DocID = '" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);
					strSQL.setLength(0);
					
					strSQL.append( " INSERT INTO TBL_ENDAPRLINEINFO ( DocID, AprMemberSN, AprType, AprState, AprMemberID, AprMemberIsDeptYN, AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, AprMemberLDAPPath, ReceivedDate, ReasonDoNotApproval, ProcessDate, isProposerYN, isBriefUserYN, TENANT_ID )"+
							"(SELECT '" + docID +"', AprMemberSN, AprType, AprState, AprMemberID, AprMemberIsDeptYN, AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, AprMemberLDAPPath, ReceivedDate, ReasonDoNotApprov, ProcessDate, isProposerYN, isBriefUserYN, TENANT_ID FROM TBL_APRLINEINFO  WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);
					strSQL.setLength(0);
					
					strSQL.append( "INSERT INTO TBL_ENDATTACHINFO ( DocID, AttachFileSN, AttachFileName, AttachFileHref, AttachUserJobTitle, AttachUserJobTitle2, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID )"+
							"(SELECT '" + docID +"', AttachFileSN, AttachFileName, AttachFileHref, AttachUserJobTitle, AttachUserJobTitle2, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID  FROM TBL_APRATTACHINFO  WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);		
					strSQL.setLength(0);
					
					strSQL.append( "INSERT INTO TBL_ENDAPRDOCATTACHINFO ( DocID, AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, AttachUserJobTitle, AttachUserJobTitle2, TENANT_ID )"+
							"(SELECT '" + docID +"', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, AttachUserJobTitle, AttachUserJobTitle2, TENANT_ID FROM TBL_APRDOCATTACHINFO  WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);	
					strSQL.setLength(0);
					
					strSQL.append( "INSERT INTO TBL_ENDAPROPINIONINFO ( DocID, UserID, OpinionGB, CONTENT, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN, TENANT_ID )" +
							"(SELECT '" + docID +"', UserID, OpinionGB, CONTENT, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN, TENANT_ID  FROM TBL_APROPINIONINFO  WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);			
					strSQL.setLength(0);
					
					strSQL.append( " INSERT INTO TBL_ENDRECEIPTPOINTINFO ( DocID, ReceiptPointID, ReceiptPointName, ReceiptPointName2, ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ExtReceptEmail, ReceiptMemberID, ReceiptMemberName, ReceiptMemberName2, ProcessDate, DeptMemberSN, ReceiptMemberJobTitle, ReceiptMemberJobTitle2, TENANT_ID )"+
							"(SELECT '" + docID +"', ReceiptPointID, ReceiptPointName, ReceiptPointName2, ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ExtReceptEmail, ReceiptMemberID, ReceiptMemberName, ReceiptMemberName2, ProcessDate, DeptMemberSN, ReceiptMemberJobTitle, ReceiptMemberJobTitle2, TENANT_ID FROM TBL_RECEIPTPOINTINFO   WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);
					strSQL.setLength(0);
					
					strSQL.append( "INSERT INTO TBL_ENDRECEIPTPROCESSINFO ( DocID, ReceiveSN, SentDeptID, SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ProcessorJobTitle, ProcessorJobTitle2, TENANT_ID )"+
							"(SELECT '" + docID +"', ReceiveSN, SentDeptID, SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ProcessorJobTitle, ProcessorJobTitle2, TENANT_ID   FROM TBL_APRRECEIPTPROCESSINFO     WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);
					strSQL.setLength(0);
					
					strSQL.append( " INSERT INTO TBL_EXPENDAPRDOCINFO ( DocID, SecurityCode, StoragePeriod, FormName, FormName2, companyID, keyword, ItemCode, ItemName, ItemName2, UrgentApproval, TempAttribute, STATUS, SpecialRecordCode, PublicityCode, LimitRange, PageNum, CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID )"+
							" (SELECT '" + docID +"', SecurityCode, storagePeriod, FormName, FormName2, companyID, keyword, ItemCode, ItemName, ItemName2, UrgentApproval, TempAttribute, STATUS, SpecialRecordCode, PublicityCode, LimitRange, PageNum, CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID   FROM TBL_EXPAPRDOCINFO   WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);
					strSQL.setLength(0);
					
					strSQL.append( "INSERT INTO TBL_EXPENDAPRLINE ( docid, aprmemberSN, orguserid, proxyuserid, proxyusername, proxyusername2, proxyuserjobtitle, proxyuserjobtitle2, proxyuserdeptid, proxyuserdeptname, proxyuserdeptname2, TENANT_ID )"+
							"(SELECT '" + docID +"', aprmemberSN, orguserid, proxyuserid, proxyusername, proxyusername2, proxyuserjobtitle, proxyuserjobtitle2, proxyuserdeptid, proxyuserdeptname, proxyuserdeptname2 , TENANT_ID   FROM TBL_EXPAPRLINE   WHERE  DOCID ='" + docID+"'"+ "AND TENANT_ID='" + tenantID +"')\n");
					map.put("sqlString", strSQL.toString());
					ezApprovalGDAO.insertStrSql(map);
					strSQL.setLength(0);
					//							"	"APRApproveEnd('" + docID + "', '" + endURL + "','" + containerID + "');\n";
				break;
			}
			}
		}
		if (rtnVal) {
			return "TRUE";
		} else {
			return "FALSE";
		}
	}

	public String returnContainerID(String deptID, String docState, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTID", deptID);
		map.put("v_DOCSTATE", docState);
		map.put("v_TENANTID", tenantID);
		
		String containerID = ezApprovalGDAO.returnContainerID(map);
		
		if(containerID == null) {
			containerID = "";
		}
		
		String containerID2 = "";
		
		if(containerID.equals("")) {
			 containerID2 = ezApprovalGDAO.returnContainerID2(map);
		}
		
		if(containerID2 == null){
			containerID2 = "";
		}
		map.put("v_CONTAINERID", containerID);
		map.put("v_CONTAINERTYPEID", containerID2);
		
		String containerID3 = ezApprovalGDAO.returnContainerID3(map);
		String containerType ="";
		
		if(!containerID2.equals("")){
			containerType = containerID3.split(":")[1];
		}
		
		if(containerID3.equals(":")){
			containerID3 = "";
		}else{
			containerID3 = containerID3.split(":")[0];
		}
			
		if (containerID3.trim().equals("")) {
			containerID3 = makeContainer(deptID, makeListField(containerType), companyID, tenantID);
		}
 		
		return containerID3;
	}

	public String doSendDoc(String docID, String deptID, String dirPath, String docState, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		boolean rtnVal = true;
		String subSQL = "";
		Document receiptXML = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		List<ApprGReceiptVO> apprGReceiptVOList = ezApprovalGDAO.doSendDocReceiptInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGReceiptVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGReceiptVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		boolean isGroup = false;
		int groupCount = 0;
		String receiptPointID = "";
		String receiptPointName = "";
		String receiptPointName2 = "";
		String receiptMemberID = "";
		String receiptMemberName = "";
		String receiptMemberName2 = "";
		String receiptMemberJobTitle = "";
		String receiptMemberJobTitle2 = "";
		String receiptCompanyID = "";
		String susinGroupIcon = getCode2Name("A53", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");

		String flag = getCode2Name("A35", "002", companyID, lang, tenantID).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");

		String orgDocID = docID;
		String tempOrgDocID = "";
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("companyID", companyID);
		map1.put("v_DOCID", docID);
		map1.put("v_TENANTID", tenantID);
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.doSendDocAprDocInfo(map1);
		
		StringBuffer sb1 = new StringBuffer();
        sb1.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb1.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb1.append("</DATA>");
		
		Document tempXML = commonUtil.convertStringToDocument(sb1.toString());
		
		if (tempXML.getElementsByTagName("ORGDOCID").getLength() > 0) {
			tempOrgDocID = makeListField(tempXML.getElementsByTagName("ORGDOCID").item(0).getTextContent());
			String tempDocState = makeListField(tempXML.getElementsByTagName("DOCSTATE").item(0).getTextContent());
			
			if (!tempOrgDocID.trim().equals("") && (flag.equals("G") || tempDocState.equals("004"))) {
				orgDocID = tempOrgDocID;
				
				if (dlength == 0) {
					subSQL = updateProcessYN(tempOrgDocID, "", "S", "QUERY", companyID, lang, tenantID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					}
				} else {
					orgDocID = docID;
				}
			}
		}
		
		for (int j = 0; j < dlength; j++) {
			receiptPointID = makeListField(docXML.getElementsByTagName("RECEIPTPOINTID").item(j).getTextContent());
			receiptPointName = makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME").item(j).getTextContent());
			receiptPointName2 = makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME2").item(j).getTextContent());
			receiptMemberID = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERID").item(j).getTextContent());
			receiptMemberName = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(j).getTextContent());
			receiptMemberName2 = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME2").item(j).getTextContent());
			receiptMemberJobTitle = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(j).getTextContent());
			receiptMemberJobTitle2 = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(j).getTextContent());
			receiptCompanyID = makeListField(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(j).getTextContent());
			isGroup = false;
			groupCount = 1;
			
			if (receiptPointID.subSequence(0, susinGroupIcon.length()).equals(susinGroupIcon)) {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("companyID", companyID);
				map2.put("v_MAINID", receiptPointID.substring(susinGroupIcon.length()));
				map2.put("v_TENANTID" , tenantID);
				List<ApprGReceiptVO> apprGReceiptVOList2 = ezApprovalGDAO.doSendDocReceiptGroupSub(map2);
				
				StringBuffer sb2 = new StringBuffer();
		        sb2.append("<DATA>");
		        
		        for (int i = 0; i < apprGReceiptVOList2.size(); i++) {
					sb2.append(commonUtil.getQueryResult(apprGReceiptVOList2.get(i)));
				}
				sb2.append("</DATA>");
				
				receiptXML = commonUtil.convertStringToDocument(sb2.toString());
				
				if (receiptXML.getElementsByTagName("ROW").getLength() > 0) {
					isGroup = true;
					groupCount = receiptXML.getElementsByTagName("ROW").getLength();
				}
			}
			
			for (int k = 0; k < groupCount; k++) {
				if (rtnVal) {
					if (isGroup) {
						receiptPointID = makeListField(receiptXML.getElementsByTagName("DEPTID").item(k).getTextContent());
						receiptPointName = makeListField(receiptXML.getElementsByTagName("DEPTNAME").item(k).getTextContent());
						receiptPointName2 = makeListField(receiptXML.getElementsByTagName("DEPTNAME2").item(k).getTextContent());
						receiptMemberID = "";
						receiptMemberName = "";
						receiptMemberJobTitle = "";
						receiptCompanyID = makeListField(receiptXML.getElementsByTagName("COMPANYID").item(k).getTextContent());
					}
					
					if (receiptPointID.indexOf("Address") > -1 && receiptCompanyID.equals("")) {
						subSQL = updateProcessYN(docID, receiptPointID, "S", "QUERY", companyID, lang, tenantID);
						
						if (subSQL.toUpperCase().equals("FALSE")) {
							rtnVal = false;
						} 
						
						if (!tempOrgDocID.trim().equals("")) {
							subSQL = updateProcessYN(tempOrgDocID, receiptPointID, "S", "QUERY", companyID, lang, tenantID);
							
							if (subSQL.toUpperCase().equals("FALSE")) {
								rtnVal = false;
							} 
						}
					} else {
						String newID = getNewID(receiptCompanyID, tenantID);
						
						Map<String, Object> map3 = new HashMap<String, Object>();
						map3.put("companyID", companyID);
						map3.put("v_DOCID", docID);
						map3.put("v_TENANTID", tenantID);
						map3.put("v_FLAG", "APR");
						
						String fileName = ezApprovalGDAO.getDocInfoHref(map3);
						String extFileName = getExtendedFileName(fileName);
						String url = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + receiptCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
						
						if (rtnVal) {
							try{
							strSQL.append("INSERT INTO TBL_APRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
                            strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
                            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
                            strSQL.append("isPublic, TENANT_ID) (SELECT '" + newID + "', FormID, '" + orgDocID + "', DocType, '" + docState);
                            strSQL.append("', '" + staASDoJak + "', '" + url + "', DocTitle, DocNo, HasAttachYN, ");
                            strSQL.append("'N', NULL, NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
                            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID FROM TBL_APRDOCINFO WHERE DocID = '" + docID + "' AND TENANT_ID =" +tenantID +")");
                            
    						map.put("sqlString", strSQL.toString());
    						ezApprovalGDAO.insertStringSql(map);
    						strSQL.setLength(0);

                            strSQL.append("INSERT INTO TBL_EXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
                            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID) ");
                            strSQL.append("(SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
                            strSQL.append("ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID FROM TBL_EXPAPRDOCINFO ");
                            strSQL.append("WHERE DocID = '" + docID + "' AND TENANT_ID =" +tenantID +")");
                            
                            map.put("sqlString", strSQL.toString());
    						ezApprovalGDAO.insertStringSql(map);
    						strSQL.setLength(0);
    						
                            strSQL.append("INSERT INTO TBL_APRATTACHINFO (DocID, AttachFileSN, ");
                            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
                            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID) (SELECT '" + newID);
                            strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
                            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID FROM ");
                            strSQL.append("TBL_APRATTACHINFO WHERE DocID = '" + docID + "' AND TENANT_ID =" +tenantID +")");

                            map.put("sqlString", strSQL.toString());
    						ezApprovalGDAO.insertStringSql(map);
    						strSQL.setLength(0);
    						
                            strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, ");
                            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
                            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID) (SELECT '" + newID);
                            strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
                            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID FROM ");
                            strSQL.append("TBL_APRDOCATTACHINFO WHERE DocID = '" + docID + " AND TENANT_ID =" +tenantID +"')");
                            
                            map.put("sqlString", strSQL.toString());
    						ezApprovalGDAO.insertStringSql(map);
    						strSQL.setLength(0);
    						
                            int susinSN = ezApprovalGDAO.getReceiptProcessInfoRec(map3);
                            
                            susinSN += 1;
                            
                            strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
                            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
                            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
                            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) (SELECT '" + susinSN + "', '" + newID);
                            strSQL.append("', WriterDeptID, WriterDeptName, WriterDeptName2, '" + receiptPointID + "', N'" + receiptPointName + "', N'" + receiptPointName2);
							strSQL.append("', '" + docState + "', '" + staASDoJak + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), 'N', '', '" + receiptMemberID);
                            strSQL.append("', N'" + receiptMemberName + "', N'" + receiptMemberName2 + "', N'" + receiptMemberJobTitle + "', N'" + receiptMemberJobTitle2 + "', '" + orgDocID + "', TENANT_ID FROM TBL_APRDOCINFO ");
							strSQL.append("WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID + ")");
							
							map.put("sqlString", strSQL.toString());
    						ezApprovalGDAO.insertStringSql(map);
    						strSQL.setLength(0);
							} catch(Exception e){
								TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
								return "FALSE";
							}
							if (!flag.equals("G")) {
								strSQL.append("UPDATE TBL_APRDOCINFO SET DocState = '014' WHERE DocID = '" + docID + "'"+ "AND TENANT_ID="+ tenantID +";\n");
								
								subSQL = updateProcessYN(docID, receiptPointID, "S", "QUERY", companyID, lang, tenantID);
								
								if (subSQL.toUpperCase().equals("FALSE")) {
									rtnVal = false;
								} 
								
								if (!tempOrgDocID.trim().equals("")) {
									subSQL = updateProcessYN(tempOrgDocID, receiptPointID, "S", "QUERY", companyID, lang, tenantID);
									
									if (subSQL.toUpperCase().equals("FALSE")) {
										rtnVal = false;
									} 
								}
							} else {
								if (!tempOrgDocID.trim().equals("")) {
									subSQL = updateProcessYN(tempOrgDocID, receiptPointID, "S", "QUERY", companyID, lang, tenantID);
									
									if (subSQL.toUpperCase().equals("FALSE")) {
										rtnVal = false;
									} 
								}
							}
							
							if (receiptMemberID.trim().equals("")) {
								sendRecvMsg(receiptPointID, docID, "SUSIN", receiptCompanyID, lang, tenantID);
							} else {
								sendMsg(docID, receiptMemberID, "SUSIN", receiptCompanyID, lang, tenantID);
							}
						}
					}
				}
			}
		}
		
		if (rtnVal) {
			return "TRUE";
		} else {
			return "FALSE";
		}
	}

	public String sendRecvMsg(String deptID, String docID, String mode, String companyID, String lang, int tenantID) throws Exception{
		String rtnXML = ezOrganService.getSearchList("EXACT_Department::" + deptID + ";;extensionAttribute1::a=1", "displayName", "department", "user", 50, commonUtil.getPrimaryData(lang, tenantID), tenantID);
		Document docXML = commonUtil.convertStringToDocument(rtnXML);
		
		for (int k = 0; k < docXML.getElementsByTagName("DATA2").getLength(); k++) {
			if (deptID.equals(docXML.getElementsByTagName("DATA3").item(k).getTextContent())) {
				sendMsg(docID, docXML.getElementsByTagName("DATA2").item(k).getTextContent(), mode, companyID, lang, tenantID);
			}
		}
		
		return "TRUE";
	}

	public String updateProcessYN(String docID, String deptID, String processYN, String mode, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String flag = getCode2Name("A35", "002", companyID, lang, tenantID).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PROCESSYN", processYN);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_DOCID", docID.trim());
		map.put("v_DEPTID", makeRightField(deptID.trim()));
		map.put("v_TENANTID", tenantID);
		
		
		String deptName = "";
		String deptName2 = "";
		
		if (!flag.equals("G")) {
			
			ezApprovalGDAO.updateProEndReceiptPointInfo(map);
            
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_RECEIPTPOINTID", deptID.trim());
			map.put("v_TENANTID", tenantID);
			map.put("v_FLAG", "APR");
			
			List<ApprGReceiptVO> apprGReceiptVOList = ezApprovalGDAO.updateProcessYNReceipt(map);
			
			StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < apprGReceiptVOList.size(); i++) {
				sb.append(commonUtil.getQueryResult(apprGReceiptVOList.get(i)));
			}
			sb.append("</DATA>");
			
			Document signXML = commonUtil.convertStringToDocument(sb.toString());
			
			if (signXML.getDocumentElement().getChildNodes().getLength() > 0) {
				deptName = makeListField(signXML.getElementsByTagName("RECEIPTPOINTNAME").item(0).getTextContent());
				deptName2 = makeListField(signXML.getElementsByTagName("RECEIPTPOINTNAME2").item(0).getTextContent());
			}
			
			if (deptName.trim().equals("")) {
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("companyID", companyID);
				map1.put("v_DOCID", docID.trim());
				map1.put("v_RECEIPTPOINTID", deptID.trim());
				map1.put("v_FLAG", "END");
				map1.put("v_TENANTID", "tenantID");
				
				List<ApprGReceiptVO> apprGReceiptVOList1 = ezApprovalGDAO.updateProcessYNReceipt(map1);
				
				StringBuffer sb1 = new StringBuffer();
		        sb1.append("<DATA>");
		        
		        for (int i = 0; i < apprGReceiptVOList1.size(); i++) {
					sb1.append(commonUtil.getQueryResult(apprGReceiptVOList1.get(i)));
				}
				sb1.append("</DATA>");
				
				Document signXML2 = commonUtil.convertStringToDocument(sb1.toString());
				
				if (signXML2.getDocumentElement().getChildNodes().getLength() > 0) {
					deptName = makeListField(signXML2.getElementsByTagName("RECEIPTPOINTNAME").item(0).getTextContent());
					deptName2 = makeListField(signXML2.getElementsByTagName("RECEIPTPOINTNAME2").item(0).getTextContent());
				}
			}
		} else {
			if (deptID.equals("")) {
				ezApprovalGDAO.updateProEndReceiptPointInfo2(map);
			} else {
				ezApprovalGDAO.updateProEndReceiptPointInfo(map);
                
                Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("companyID", companyID);
				map1.put("v_DOCID", docID.trim());
				map1.put("v_RECEIPTPOINTID", deptID.trim());
				map1.put("v_FLAG", "END");
				map1.put("v_TENANTID", tenantID);

				List<ApprGReceiptVO> apprGReceiptVOList1 = ezApprovalGDAO.updateProcessYNReceipt(map1);
				
				StringBuffer sb1 = new StringBuffer();
		        sb1.append("<DATA>");
		        
		        for (int i = 0; i < apprGReceiptVOList1.size(); i++) {
					sb1.append(commonUtil.getQueryResult(apprGReceiptVOList1.get(i)));
				}
				sb1.append("</DATA>");
				
				Document signXML2 = commonUtil.convertStringToDocument(sb1.toString());
				
				if (signXML2.getDocumentElement().getChildNodes().getLength() > 0) {
					deptName = makeListField(signXML2.getElementsByTagName("RECEIPTPOINTNAME").item(0).getTextContent());
					deptName2 = makeListField(signXML2.getElementsByTagName("RECEIPTPOINTNAME2").item(0).getTextContent());
				}
			}
		}
		
		if (deptID.equals("")) {
			
			try{
				ezApprovalGDAO.insertProHistoryReceiptInfo(map);
				return "TRUE";
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}
			
		} else {
			if (deptName.trim().equals("")) {
				deptName = deptID;
			}
			map.put("v_DEPTID", makeRightField(deptID.trim()));
			map.put("v_DEPTNAME", makeRightField(deptName.trim()));
			map.put("v_DEPTNAME2", makeRightField(deptName2.trim()));
			map.put("v_PROCESSYN", processYN);
			
			try{
				ezApprovalGDAO.insertProHistoryReceiptInfo2(map);
				return "TRUE";
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}
          
		}
		
	}

	public String doDeptAssist(String docID, String deptID, String deptName, String deptName2, String dirPath, String aprState, String docState, String pCompanyID, String companyID, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String newID = getNewID(pCompanyID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		map.put("v_FLAG", "APR");
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String fileURL = dirPath + commonUtil.separator + fileName.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator, "");
		String url = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + pCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + 
				"1000" + commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;

		boolean rtnVal = copyFile(fileURL, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID) +
				commonUtil.separator + newID + "." + extFileName, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID)); 
		
		if (rtnVal) {
			
			map.put("v_NEWID", newID);
			map.put("v_DOCSTATE", docState);
			map.put("v_STAASDOJAK", staASDoJak);
			map.put("v_URL", url);
			map.put("v_DEPTID", deptID);
			map.put("v_DEPTNAME", deptName);
			map.put("v_DEPTNAME2", deptName2);
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
			
			try{
			ezApprovalGDAO.insertDeptAssistAprDocInfo(map);

            ezApprovalGDAO.insertDeptAssistExAprDocInfo(map);

			ezApprovalGDAO.insertDeptAssistAprAttachInfo(map);

			ezApprovalGDAO.insertDeptAssistAprDocAttachInfo(map);

			ezApprovalGDAO.insertDeptAssistAprReceiptProcessInfo(map);
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

				return "FALSE";
			}
		
		} else {
			return "FALSE";
		}
		
		return "TRUE";
	}

	public String setBujaeInfo(String docID, String aprMemberID, String aprMemberDeptID, String absentReason, String aprType, String companyID, String lang, int tenantID) throws Exception{
		String strSQL = "";
		StringBuilder resultXML = new StringBuilder();
		String susinSN = getSusinSNInside(docID, companyID, tenantID);
		int cnt = 1;
		String aprSN = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		map.put("v_APRTYPE", aprType.toUpperCase().trim());
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.setBujaeInfoList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		for (int k = 0; k < docXML.getElementsByTagName("APRMEMBERSN").getLength(); k++) {
			if (aprSN.equals("")) {
				if (docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent().toUpperCase().equals(aprMemberID.toUpperCase()) && 
					docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent().toUpperCase().equals(aprMemberDeptID.toUpperCase()) &&
					!docXML.getElementsByTagName("APRSTATE").item(k).getTextContent().toUpperCase().equals(staASSungIn)) {
					aprSN = String.valueOf(cnt);
				} else {
					cnt += 1;
				}
			}
		}
		
		resultXML.append("<SIGNINFOS>");
		
		if (aprType.toUpperCase().equals("APR")) {
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + susinSN + "sign" + aprSN + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + absentReason + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + susinSN + "seumyungdate" + aprSN + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + commonUtil.getTodayUTCTime("").substring(6, 10) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
		} else {
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + susinSN + "habyuisign" + aprSN + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + absentReason + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
			resultXML.append("<SIGNINFO>");
			resultXML.append("<DOCID>" + docID + "</DOCID>");
			resultXML.append("<SIGNTYPE>" + "TEXT" + "</SIGNTYPE>");
			resultXML.append("<SIGNNAME>" + susinSN + "habyuidate" + aprSN + "</SIGNNAME>");
			resultXML.append("<CONTENT>" + commonUtil.getTodayUTCTime("").substring(6, 10) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
		}
		
		resultXML.append("</SIGNINFOS>");
		
		
			strSQL = updateSignInfo(resultXML, companyID, "QUERY", tenantID);
		
		return strSQL;
	}

	public String updateSignInfo(StringBuilder resultXML, String companyID, String mode, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		Document docXML = commonUtil.convertStringToDocument(resultXML.toString());
		String strDocID = docXML.getElementsByTagName("DOCID").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", strDocID);
		map.put("v_TENANTID", tenantID);
		
		int aprSN = ezApprovalGDAO.updateSignInfoAprSN(map);
		int signLength = docXML.getElementsByTagName("SIGNINFO").getLength();
		int maxAprSN = 0;
		
		for (int k = 0; k < signLength; k++) {
			maxAprSN = aprSN + k + 1;
			
			map.put("v_MAXAPRSN", maxAprSN);
			map.put("v_SIGNTYPE", makeRightField(docXML.getElementsByTagName("SIGNTYPE").item(k).getTextContent()));
			map.put("v_SIGNNAME", makeRightField(docXML.getElementsByTagName("SIGNNAME").item(k).getTextContent()));
			map.put("v_CONTENT", makeRightField(docXML.getElementsByTagName("CONTENT").item(k).getTextContent()));
			try {
				ezApprovalGDAO.insertSignInfo(map);
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				System.out.println(e.getMessage());
				return "FALSE";
			}
		}
		
//		if (mode.toUpperCase().equals("QUERY")) {
//			return strSQL.toString();
//		} else {
//			try {
//				Map<String, Object> map1 = new HashMap<String, Object>();
//				map1.put("sqlString", strSQL.toString().substring(0, strSQL.length()-2));
//				map1.put("companyID", companyID);
//				
//				ezApprovalGDAO.insertSignInfoAprSN(map1);
//				
//				return "<RESULT>TRUE</RESULT>";
//			} catch (Exception e) {
//				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
//				System.out.println(e.getMessage());
//				return "<RESULT>FALSE</RESULT>";
//			}
//		}
		return "TRUE";
	}

	public String getSusinSNInside(String docID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		String rtnVal = makeListField(ezApprovalGDAO.getSusinSNInside(map));
		
		return rtnVal;
	}

	public String getBujaeInfo(String userID, int tenantID) throws Exception{
		String absentReason = ezOrganService.getPropertyValue(userID, "extensionAttribute5", tenantID);
		String rtnVal = "";
		
		if (absentReason != null && !absentReason.trim().equals("")) {
			String[] reasons = absentReason.split(":");
			if (reasons[0].trim().equals("") && reasons.length >= 5) {
				String now = commonUtil.getTodayUTCTime("");
				
				if (now.compareTo(reasons[3].replace("/", ":")) >= 0 && now.compareTo(reasons[4].replace("/", ":")) <= 0) {
					rtnVal = reasons[5];
				}
			}
		}
		
		return rtnVal;
	}

	public String doChamjo(String docID, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String deptID, String deptName,
			String deptName2, String deptYN, String pCompanyID, String dirPath, String docState, String companyID, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String aprState = "";
		String aprType = "";
		
		if (deptYN.toUpperCase().equals("Y")) {
			aprState = staASDoJak;
		} else {
			aprState = staASJinHang;
		}
		
		if (docState.equals(staDSChamJo)) {
			aprType = staATChamJo;
		} else {
			aprType = staATGongram;
		}
		
		String newID = getNewID(companyID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		map.put("v_FLAG", "APR");
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String fileURL = dirPath + commonUtil.separator + fileName.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator, "");
		String url = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + pCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator +
				getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		boolean rtnVal = copyFile(fileURL, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator +
				getDocDir(newID) + commonUtil.separator + newID + "." + extFileName, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator +
				"1000" + commonUtil.separator + getDocDir(newID));
		
		if (rtnVal) {
			
			map.put("v_NEWID", newID);
			map.put("v_DOCID", docID);
			map.put("v_DOCSTATE", docState);
			map.put("v_APRSTATE", aprState);
			map.put("v_URL", url);
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
			map.put("v_TENANTID", tenantID);
			
			try{
				ezApprovalGDAO.insertCamjoAPrDocInfo(map);
				ezApprovalGDAO.insertCamjoExAPrDocInfo(map);
				ezApprovalGDAO.insertCamjoAprAttachInfo(map);
				ezApprovalGDAO.insertCamjoAprDocAttachInfo(map);
				ezApprovalGDAO.insertCamjoAprOpinionInfo(map);
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}
			

			if (deptYN.toUpperCase().equals("Y")) {
				map.put("v_DEPTID", deptID);
				map.put("v_DEPTNAME", deptName);
				map.put("v_DEPTNAME2", deptName2);
				map.put("v_STAASDOJAK", staASDoJak);
				
				try{
					ezApprovalGDAO.insertCamjoAprReceiptProcessInfo(map);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FALSE";
				}
				
			} else {
				
				map.put("v_APRTYPE", aprType);
				map.put("v_USERID", userID);
				map.put("v_USERNAME", userName);
				map.put("v_USERNAME2", userName2);
				map.put("v_USERJOBTITLE", userJobTitle);
				map.put("v_USERJOBTITLE2", userJobTitle2);
				map.put("v_DEPTID", deptID);
				map.put("v_DEPTNAME2", deptName);
				map.put("v_DEPTNAME2", deptName2);
				map.put("v_PCOMPANYID", pCompanyID);
				
				try{
					ezApprovalGDAO.insertCamjoAprLineInfo(map);
					ezApprovalGDAO.insertCamjoExAprLine(map);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FALSE";
				}
			}
		} else {
			return "FALSE";
		}
		
		return "TURE";
	}

	public boolean copyFile(String source, String target, String dirPath) throws Exception{
		if (!dirPath.trim().equals("")) {
			File file = new File(dirPath);
			
			if (!file.exists()) {
				file.mkdirs();
			}
		}
		try {
			File src = new File(source);
			File des = new File(target);
			
			FileUtils.copyFile(src, des);
			
			return true;
		} catch (Exception e) {
			return false;
		}
		
	}

	public String getExtendedFileName(String href) {
		String[] tempHref = href.split("\\.");
		
		return tempHref[tempHref.length - 1];
	}

	public String sendMsg(String docID, String nextUserID, String mode, String companyID, String lang, int tenantID) throws Exception{
		boolean notiFlag = false;
		LOGGER.debug("sendMsg started");

		if (getCode2Name("A43", "001", companyID, lang, tenantID).equals("Y")) {
			LOGGER.debug("getCode2Name ended.");
			notiFlag = true;
		}
		
		if (notiFlag) {
			String docTitle = "";
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_TENANTID", tenantID);
			map.put("v_DOCID", docID);
			map.put("v_FLAG", "ING");
			
			docTitle = makeListField(ezApprovalGDAO.getDocTitle(map));
			
			if (docTitle.trim().equals("")) {
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("v_DOCID", docID);
				map1.put("v_TENANTID", tenantID);
				map1.put("v_FLAG", "END");
				
				docTitle = makeListField(ezApprovalGDAO.getDocTitle(map1));
				
				if (docTitle.trim().equals("")) {
					docTitle = getCode2Name("L06", "001", companyID, lang, tenantID);
					LOGGER.debug("getCode2Name ended.");

				} else {
					if (nextUserID.trim().equals("")) {
						Map<String, Object> map2 = new HashMap<String, Object>();
						map2.put("v_DOCID", docID);
						map2.put("v_TENANTID", tenantID);
						map2.put("v_FLAG", "END");
						
						nextUserID = makeListField(ezApprovalGDAO.getDraftUserID(map2));
					}
				}
			} else {
				if (nextUserID.trim().equals("")) {
					Map<String, Object> map3 = new HashMap<String, Object>();
					map3.put("v_DOCID", docID);
					map3.put("v_TENANTID", tenantID);
					map3.put("v_FLAG", "ING");
					
					nextUserID = makeListField(ezApprovalGDAO.getDraftUserID(map3));
				}
			}
			
			String notyStr = "";
			
			switch (mode.toUpperCase()) {
			case "ING" :
                notyStr = getCode2Name("L06", "002", companyID, lang, tenantID); //"문서도착";
    			LOGGER.debug("getCode2Name ended.");
				break;
			case "END" :
                notyStr = getCode2Name("L06", "003", companyID, lang, tenantID); //"문서완료";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "BAN" :
                notyStr = getCode2Name("L06", "004", companyID, lang, tenantID); //"문서반송";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "BOR" :
                notyStr = getCode2Name("L06", "005", companyID, lang, tenantID); //"문서보류";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "BAL" :
                notyStr = getCode2Name("L06", "006", companyID, lang, tenantID); //"문서발송";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "SUSIN" :
                notyStr = getCode2Name("L06", "007", companyID, lang, tenantID); //"수신문서";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "JIJUNG" :
                notyStr = getCode2Name("L06", "008", companyID, lang, tenantID); //"지정문서";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "BEBU" :
                notyStr = getCode2Name("L06", "012", companyID, lang, tenantID); //"배부문서"; //012
                LOGGER.debug("getCode2Name ended.");
				break;
			case "HESONG" :
                notyStr = getCode2Name("L06", "009", companyID, lang, tenantID); //"회송문서";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "HESU" :
                notyStr = getCode2Name("L06", "010", companyID, lang, tenantID); //"문서회수";
                LOGGER.debug("getCode2Name ended.");
				break;
			case "REJIJUNG" :
                notyStr = getCode2Name("L06", "013", companyID, lang, tenantID); //"재지정요청"; //013
                LOGGER.debug("getCode2Name ended.");
				break;
			case "REBEBU" :
                notyStr = getCode2Name("L06", "014", companyID, lang, tenantID); //"재배부요청"; //014
                LOGGER.debug("getCode2Name ended.");
				break;
			default :
                notyStr = getCode2Name("L06", "011", companyID, lang, tenantID); //"결재노티";
                LOGGER.debug("getCode2Name ended.");
				break;
			}
			try {
				String itemSeq = ezApprovalGDAO.notifiCationSeq(map);
				if(itemSeq == null){
					itemSeq = "0";
					map.put("v_itemSeq", itemSeq);

					ezApprovalGDAO.insertNotifyItem(map);
				} else {
					insertNotifyItem(nextUserID, notyStr, docTitle, "2", docID, tenantID);
				}
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FALSE";
			}
		}
		LOGGER.debug("sendMsg ended");

		return "TRUE";
	}

	public String insertNotifyItem(String userID, String notyStr, String subject, String type, String etcData, int tenantID) throws Exception{
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PSENDER", notyStr);
		map.put("v_PSUBJECT", subject);
		map.put("v_PTYPE", type);
		map.put("v_PETCDATA", etcData);
		map.put("v_TENANTID", tenantID);
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		
		try {
			String itemSeq = ezApprovalGDAO.notifiCationSeq(map);
			if(itemSeq == null){
				itemSeq = "0";
				map.put("v_itemSeq", itemSeq);

				ezApprovalGDAO.insertNotifyItem(map);
			} else {
				map.put("v_itemSeq", Integer.parseInt(itemSeq) +1);
				ezApprovalGDAO.insertNotifyItem(map);
			}
			result = "OK";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

			result = "ERROR";
		}
		
		return result;
	}

	public String insertProxyUserInfo(String docID, String curAprMemberSN, String userID, String proxyUserID, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String isUse = getIsUse("A23", "001", companyID, lang, tenantID);
		
		if (isUse.equals("1")) {
			String rtnXML = ezOrganService.getPropertyList(proxyUserID, "displayName;title;department;description", commonUtil.getPrimaryData(lang, tenantID), tenantID);
			
			Document docXML = commonUtil.convertStringToDocument(rtnXML);
			
			if (docXML.getDocumentElement().getChildNodes().getLength() > 0) {
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("v_PROXYUSERID", proxyUserID);
				map.put("v_PROXYUSERNAME", docXML.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
				map.put("v_PROXYUSERNAME2", docXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent());
				map.put("v_PROXYUSERJOBTITLE", docXML.getElementsByTagName("TITLE").item(0).getTextContent());
				map.put("v_PROXYUSERJOBTITLE2", docXML.getElementsByTagName("TITLE2").item(0).getTextContent());
				map.put("v_PROXYUSERDEPTID", docXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent());
				map.put("v_PROXYUSERDEPTNAME", docXML.getElementsByTagName("DESCRIPTION").item(0).getTextContent());
				map.put("v_PROXYUSERDEPTNAME2", docXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent());
				map.put("v_DOCID", docID);
				map.put("v_CURAPRMEMBERSN", curAprMemberSN);
				map.put("v_USERID", userID);
				map.put("v_TENANTID", tenantID);

				try {
					ezApprovalGDAO.updateProxyExpAprLine(map);
				} catch (Exception e) {
					TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
					return "FALSE";
				}
			}
		}
		
		return "TRUE";
	}

	public String updateDocInfo(Document docXML, String userID, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		StringBuilder subSQL = new StringBuilder();
		boolean firstFlag = true;
		LOGGER.debug("updateDocInfo started");
		String docID = docXML.getElementsByTagName("DOCID").item(0).getTextContent();
		String tempValue = "";
		String rtnVal = "TRUE";
		
		Map<String, Object> map = new HashMap<String, Object>();
		tempValue = docXML.getElementsByTagName("DOCTITLE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			map.put("v_DOCTITLE", tempValue.trim());
			try {
				ezApprovalGDAO.updateDocInfoDocTitle(map);
			} catch (Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

				return "FALSE";
			}
		}
		
		
		tempValue = docXML.getElementsByTagName("FORMID").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_FORMID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_FORMID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("ORGDOCID").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_ORGDOCID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG2", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_ORGDOCID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG2", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("DOCTYPE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_DOCTYPE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG3", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_DOCTYPE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG3", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("DOCSTATE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_DOCSTATE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG4", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_DOCSTATE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG4", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("FUNCTIONTYPE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_FUNCTIONTYPE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG5", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_FUNCTIONTYPE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG5", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("HREF").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_HREF", makeRightField(tempValue));
				map.put("v_FIRSTFLAG6", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_HREF", makeRightField(tempValue));
				map.put("v_FIRSTFLAG6", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("DOCTITLE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_DOCTITLE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG7", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_DOCTITLE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG7", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("DOCNO").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_DOCNO", makeRightField(tempValue));
				map.put("v_FIRSTFLAG8", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_DOCNO", makeRightField(tempValue));
				map.put("v_FIRSTFLAG8", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("HASATTACHYN").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_HASATTACHYN", makeRightField(tempValue));
				map.put("v_FIRSTFLAG9", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_HASATTACHYN", makeRightField(tempValue));
				map.put("v_FIRSTFLAG9", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("HASOPINIONYN").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_HASOPINIONYN", makeRightField(tempValue));
				map.put("v_FIRSTFLAG10", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_HASOPINIONYN", makeRightField(tempValue));
				map.put("v_FIRSTFLAG10", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("STARTDATE").item(0).getTextContent().trim();
		
		if (tempValue.equals("DRAFT")) {
			if (firstFlag) {
				map.put("v_STARTDATE", commonUtil.getTodayUTCTime(""));
				map.put("v_FIRSTFLAG11", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_STARTDATE", commonUtil.getTodayUTCTime(""));
				map.put("v_FIRSTFLAG11", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("ENDDATE").item(0).getTextContent().trim();
		
		if (tempValue.equals("DRAFT")) {
			if (firstFlag) {
				map.put("v_ENDDATE", "NULL");
				map.put("v_FIRSTFLAG12", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_ENDDATE", "NULL");
				map.put("v_FIRSTFLAG12", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("WRITERID").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_WRITERID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG13", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_WRITERID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG13", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_WRITERNAME", makeRightField(tempValue));
				map.put("v_FIRSTFLAG14", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_WRITERNAME", makeRightField(tempValue));
				map.put("v_FIRSTFLAG14", firstFlag);
			}
		}

		if (docXML.getElementsByTagName("WRITERNAME2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_WRITERNAME2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG15", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_WRITERNAME2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG15", firstFlag);
				}
			}
		}
		
		tempValue = docXML.getElementsByTagName("WRITERJOBTITLE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_WRITERJOBTITLE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG16", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_WRITERJOBTITLE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG16", firstFlag);
			}
		}
		
		if (docXML.getElementsByTagName("WRITERJOBTITLE2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("WRITERJOBTITLE2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_WRITERJOBTITLE2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG17", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_WRITERJOBTITLE2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG17", firstFlag);
				}
			}
		}
		
		tempValue = docXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_WRITERDEPTID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG18", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_WRITERDEPTID", makeRightField(tempValue));
				map.put("v_FIRSTFLAG18", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_WRITERDEPTNAME", makeRightField(tempValue));
				map.put("v_FIRSTFLAG19", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_WRITERDEPTNAME", makeRightField(tempValue));
				map.put("v_FIRSTFLAG19", firstFlag);
			}
		}
		
		if (docXML.getElementsByTagName("WRITERDEPTNAME2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_WRITERDEPTNAME2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG20", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_WRITERDEPTNAME2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG20", firstFlag);
				}
			}
		}
		
		tempValue = docXML.getElementsByTagName("PUBLICATION").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_ISPUBLIC", makeRightField(tempValue));
				map.put("v_FIRSTFLAG21", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_ISPUBLIC", makeRightField(tempValue));
				map.put("v_FIRSTFLAG21", firstFlag);
			}
		}
		
		try {
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			ezApprovalGDAO.updateAprDocInfo(map);
			
			rtnVal = "TRUE";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			System.out.println(e.getMessage());
			return rtnVal = "FALSE";
		}
		
		firstFlag = true;
		

		tempValue = docXML.getElementsByTagName("SECURITY").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_SECURITYCODE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_SECURITYCODE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_STORAGEPERIOD", makeRightField(tempValue));
				map.put("v_FIRSTFLAG2", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_STORAGEPERIOD", makeRightField(tempValue));
				map.put("v_FIRSTFLAG2", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("ITEMCODE").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_ITEMCODE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG3", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_ITEMCODE", makeRightField(tempValue));
				map.put("v_FIRSTFLAG3", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("ITEMNAME").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_ITEMNAME", makeRightField(tempValue));
				map.put("v_FIRSTFLAG4", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_ITEMNAME", makeRightField(tempValue));
				map.put("v_FIRSTFLAG4", firstFlag);
			}
		}
		
		if (docXML.getElementsByTagName("ITEMNAME2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("ITEMNAME2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_ITEMNAME2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG5", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_ITEMNAME2", makeRightField(tempValue));
					map.put("v_FIRSTFLAG5", firstFlag);
				}
			}
		}
		
		tempValue = docXML.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_URGENTAPPROVAL", makeRightField(tempValue));
				map.put("v_FIRSTFLAG6", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_URGENTAPPROVAL", makeRightField(tempValue));
				map.put("v_FIRSTFLAG6", firstFlag);
			}
		}
		
		tempValue = docXML.getElementsByTagName("KEYWORD").item(0).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				map.put("v_KEYWORD", makeRightField(tempValue));
				map.put("v_FIRSTFLAG7", firstFlag);
				firstFlag = false;
			} else {
				map.put("v_KEYWORD", makeRightField(tempValue));
				map.put("v_FIRSTFLAG7", firstFlag);
			}
		}

		if (docXML.getElementsByTagName("SPECIALRECORDCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_SPECIALRECORDCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG8", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_SPECIALRECORDCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG8", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("PUBLICITYCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_PUBLICITYCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG9", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_PUBLICITYCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG9", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("LIMITRANGE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_LIMITRANGE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG10", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_LIMITRANGE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG10", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("PAGENUM").item(0) != null) {
			tempValue = docXML.getElementsByTagName("PAGENUM").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_PAGENUM", makeRightField(tempValue));
					map.put("v_FIRSTFLAG11", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_PAGENUM", makeRightField(tempValue));
					map.put("v_FIRSTFLAG11", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("CABINETID").item(0) != null) {
			tempValue = docXML.getElementsByTagName("CABINETID").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_CABINETID", makeRightField(tempValue));
					map.put("v_FIRSTFLAG12", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_CABINETID", makeRightField(tempValue));
					map.put("v_FIRSTFLAG12", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("TASKCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("TASKCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_TASKCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG13", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_TASKCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG13", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("DOCNUMCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_DOCNUMCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG14", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_DOCNUMCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG14", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("ORGDOCNUMCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_ORGDOCNUMCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG15", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_ORGDOCNUMCODE", makeRightField(tempValue));
					map.put("v_FIRSTFLAG15", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("SEPERATEATTACHXML").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_SEPERATEATTACHXML", makeRightField(tempValue));
					map.put("v_FIRSTFLAG16", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_SEPERATEATTACHXML", makeRightField(tempValue));
					map.put("v_FIRSTFLAG16", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("SUMMARY").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SUMMARY").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_SUMMARY", makeRightField(tempValue));
					map.put("v_FIRSTFLAG17", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_SUMMARY", makeRightField(tempValue));
					map.put("v_FIRSTFLAG17", firstFlag);
				}
			}
		}
		
		if (docXML.getElementsByTagName("SECURITYAPPROVAL").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					map.put("v_SECURITYAPPROVAL", makeRightField(tempValue));
					map.put("v_FIRSTFLAG18", firstFlag);
					firstFlag = false;
				} else {
					map.put("v_SECURITYAPPROVAL", makeRightField(tempValue));
					map.put("v_FIRSTFLAG18", firstFlag);
				}
			}
		}
		
		
		try {
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			ezApprovalGDAO.updateExpAprDocInfo(map);
			
			rtnVal = "TRUE";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();

			System.out.println(e.getMessage());
			return rtnVal = "FALSE";
		}
		
		if (rtnVal.equals("TRUE")) {
			if (docXML.getElementsByTagName("STARTDATE").item(0).getTextContent().trim().equals("DRAFT")) {
				rtnVal = insLastAprLine(docID, docXML.getElementsByTagName("FORMID").item(0).getTextContent().trim(), userID, companyID, lang, tenantID);
				if (rtnVal.equals("TRUE")) {
					rtnVal = insLastAprReceipt(docID, docXML.getElementsByTagName("FORMID").item(0).getTextContent().trim(), userID, companyID, lang, tenantID);
				if (!rtnVal.equals("TRUE")) {
					return rtnVal;
				}
				} else {
					return rtnVal;
				}
			}
			LOGGER.debug("updateDocInfo ended");

			return rtnVal;
		} else {
			return rtnVal;
		}
	}

	public String insLastAprReceipt(String docID, String formID, String userID, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String isUse = getCode2Name("A44", "002", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");
		if (isUse.equals("1")) {
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_USERID", userID);
			map.put("v_FORMID", formID);
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			
			try {
			ezApprovalGDAO.deleteLastDeptLine(map);
			
			ezApprovalGDAO.insertLastDeptLine(map);
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FLASE";
			}
            return "TRUE";
		} else {
			return "TRUE";
		}
	}

	public String insLastAprLine(String docID, String formID, String userID, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String isUse = getCode2Name("A44", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");
		if (isUse.equals("1")) {
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_USERID", userID);
			map.put("v_FORMID", formID);
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			
			try {
				ezApprovalGDAO.deleteLastAprLine(map);
			
				ezApprovalGDAO.insertLastAprLine(map);
			} catch(Exception e) {
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return "FLASE";
			}
            return "TRUE";
		} else {
			return "TRUE";
		}
	}

	public String registerSepAttachEx(String recID, String cabID, String title, String numOfPage, String regType, String summary, String recType, String companyID, String tempSepAttSN,int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "TRUE";
		String sepAttSN = tempSepAttSN;
		
		if (sepAttSN.trim().equals("")) {
			sepAttSN = formatSepSerialNum(getSepAttachSN(recID, companyID, tenantID));
			if (sepAttSN.trim().equals("")) {
				return "FALSE";
			}
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_RECID", makeRightField(recID));
		map.put("v_SEPATTSN", makeRightField(sepAttSN));
		map.put("v_CABID", makeRightField(cabID));
		map.put("v_REGTYPE", makeRightField(regType));
		map.put("v_TITLE", makeRightField(title));
		map.put("v_NUMOFPAGE", makeRightField(numOfPage));
		map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
		map.put("v_TENANTID", tenantID);
		
		try{
			ezApprovalGDAO.insertRegSeperateAttach(map);
			ezApprovalGDAO.insertRegRecRoleInfo(map);
		} catch(Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			System.out.println(e.getMessage());
			return "FALSE";
		}
        if (regType.equals("5") || regType.equals("6")) {
        	String subSQL = saveAudioVisualExtraInfo(recID, sepAttSN, summary, recType, tenantID);
        	
        	if (subSQL.equals("FALSE")) {
        		rtnVal = "FALSE";
        	} else {
        		rtnVal = "TRUE";
        	}
        }
        
		return rtnVal;
	}

	public String saveAudioVisualExtraInfo(String recID, String sepAttSN, String summary, String recType, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_RECID", makeRightField(recID));
		map.put("v_SEPATTSN", makeRightField(sepAttSN));
		map.put("v_SUMMARY", makeRightField(summary));
		map.put("v_RECTYPE", makeRightField(recType));
		map.put("v_TENANTID", tenantID);
		
		try{
			ezApprovalGDAO.insertRegAudioVisualExInfo(map);
		} catch(Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "FALSE";
		}
		return "TRUE";
	}

	public String getSepAttachSN(String recID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RECORDID", recID);
		map.put("v_TENANTID", tenantID);
		
		String pSN = ezApprovalGDAO.getSepAttachSN(map);
		
		if (pSN.trim().equals("")) {
			return formatSepSerialNum("00");
		} else {
			int tValue = Integer.parseInt(pSN) + 1;
			return String.valueOf(tValue);
		}
	}

	public String formatSepSerialNum(String strValue) throws Exception{
		return getNDigitNum(strValue, 2);
	}

	public String makeXMLString(String orgString) throws Exception{
		return orgString.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
	}

	public String formatDateForView(String pDate, int iFlag) throws Exception{
		if (pDate.length() > 0) {
			if (iFlag == 0) {
				return pDate.substring(0, 16);
			} else {
				return pDate.substring(0, 10);
			}
		} else {
			return "";
		}
	}

	public String getRegTypeString(String pCode, String companyID, String lang, int tenantID) throws Exception{
		return getCabinetCode2Name("003", pCode, companyID, lang, tenantID);
	}

	public String getRecRegSNToName(String deptName, String regNo) {
		return deptName + "-" + regNo;
	}

	public String getCabinetNo(String strDeptCode, String strTaskCode, String strPYear, String strRegSerialNo, String strVolNo) {
		return strDeptCode + "-" + strTaskCode + "-" + strPYear + "-" + strRegSerialNo + "(" + strVolNo + ")";
	}

	public String getCabJoinClause(Document doc, String deptCode, String transFlag, String listFlag, String companyID, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String cabWhere = "";
		String tempDeptCode = deptCode;
		String g_Const_CabinetWhereClause = " Where TBL_CABINET.DelFlag = '0' " + 
				"AND TBL_CABINETCLASS.DelFlag = '0' AND NOT (TBL_CABINET.CabinetTransferFlag = '2' And ConfirmFlag = '0') ";

		if (doc.getElementsByTagName("DEPTCODE").item(0) != null && doc.getElementsByTagName("DEPTCODE").item(0).getTextContent().length() > 0) {
			tempDeptCode = doc.getElementsByTagName("DEPTCODE").item(0).getTextContent();
		}
		
		strSQL.append(" Inner Join ( Select ProcessDeptCode, ProcessDeptName, ProcessDeptName2, TaskCode, ");
        strSQL.append("TaskName, TaskName2, VolumeNo, CabinetID, TCabinetID, TBL_CABINET.CabinetClassNo, ");
		strSQL.append("DisplayEndDate, DisplayReason, ConfirmFlag, ProductionYear, RegSerialNo, ");
		strSQL.append("DisplayRecFlag, ExTransYear, TransDelayReason, TransDelayFlag, OwnerDeptID, ");
        strSQL.append("OwnerTask, TerminateFlag, ExpirationYear, KeepingPeriod ,TBL_CABINETCLASS.TENANT_ID" + " From TBL_CABINETCLASS  Inner Join " +
                "TBL_CABINET  On TBL_CABINETCLASS.CabinetClassNo = TBL_CABINET.CabinetClassNo AND TBL_CABINETCLASS.TENANT_ID = TBL_CABINET.TENANT_ID ");
        
        switch (listFlag) {
		case "0" :		// 기록물 대장
			if (doc.getElementsByTagName("CABINETID").item(0) != null && doc.getElementsByTagName("CABINETID").getLength() > 0) {
				cabWhere = "WHERE CabinetID IN (";
				for (int k = 0; k < doc.getElementsByTagName("CABINETID").getLength(); k++) {
					if (k == 0) {
						cabWhere += "'" + doc.getElementsByTagName("CABINETID").item(k).getTextContent().trim() + "'";
					} else {
						cabWhere += ", '" + doc.getElementsByTagName("CABINETID").item(k).getTextContent().trim() + "'";
					}
				}
				cabWhere += ")";
			} else {
				cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' ";
			}
			break;

		case "1" :		// 편철확정대상 기록물
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + " And TBL_CABINETCLASS.TerminateFlag='1' And TBL_CABINETCLASS.ConfirmFlag='0'";
			break;

		case "2" :		// 기록물 생산 현황
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + " And TBL_CABINETCLASS.ConfirmYear=EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'))";
			break;

		case "3" :		// 목록이관 대상
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + " And TBL_CABINETCLASS.ConfirmFlag='1' " + 
					"And ( ( TBL_CABINETCLASS.DisplayRecFlag='2' And TBL_CABINETCLASS.TransDelayFlag='0' " +
		            " And TBL_CABINETCLASS.ConfirmYear Between EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS') - (INTERVAL '1' YEAR)) And EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) " +
		            ") OR( ( TBL_CABINETCLASS.DisplayRecFlag='1' And TBL_CABINETCLASS.DisplayEndDate<CAST(EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) AS char(4)) ) " +
		            " OR ( TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear=EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ) " + 
					") ) And CatalogTransferFlag='0' ";
			break;

		case "6" :		// 연기신청목록
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + "And TBL_CABINETCLASS.KeepingPlace='1' " +
		            "And ( (TBL_CABINETCLASS.DisplayRecFlag='1' And TBL_CABINETCLASS.DisplayEndDate>=CAST(EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) AS char(4)) ) " +
		            " OR (TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear>EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ) " +
		            " ) And ( ( TBL_CABINETCLASS.ConfirmYear = EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ) OR " +
		            " ( TBL_CABINETCLASS.ConfirmYear > (Select Max(DocTransferYear) From TBL_CABINET ) ) ) ";
			break;

		default : 
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' ";
			break;
		}

        if (doc.getElementsByTagName("CHARGER").item(0) != null && doc.getElementsByTagName("CHARGER").item(0).getTextContent().length() > 0) {
        	cabWhere += "AND TBL_CABINETCLASS.CabinetClassNo IN ( Select CabinetClassNo " + 
        			"From TBL_CABROLEINFO Where User_ID IN (" + doc.getElementsByTagName("CHARGER").item(0).getTextContent().trim() + ") ) ";	
        }

		if (doc.getElementsByTagName("TRANSEXPIRE").item(0) != null && doc.getElementsByTagName("TRANSEXPIRE").item(0).getTextContent().length() > 0) {
			cabWhere += g_Const_TransExpCabConst_Function(companyID, tenantID);
		}

		if (doc.getElementsByTagName("CABTITLE").item(0) != null && doc.getElementsByTagName("CABTITLE").item(0).getTextContent().length() > 0) {
			cabWhere += "AND TBL_CABINETCLASS.Title Like N'%" + makeSearchField(doc.getElementsByTagName("CABTITLE").item(0).getTextContent().trim()) + "%' ";
		}
		
		strSQL.append(cabWhere + ") TBL_CABINET On TBL_SEPERATEATTACH.CabinetID=TBL_CABINET.CabinetID  AND  TBL_SEPERATEATTACH.TENANT_ID=TBL_CABINET.TENANT_ID ");

		if (transFlag.equals("1")) {
			strSQL.append("OR TBL_SEPERATEATTACH.CabinetID=TBL_CABINET.TCabinetID ");
		}

		return strSQL.toString();
	}

	public String makeSearchField(String orgStr) {
		return orgStr.replace("'", "''").replace("\0", "").replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
	}

	public String g_Const_TransExpCabConst_Function(String companyID, int tenantID) throws Exception{
		String strSQL = "";
		String accountingYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, "1", tenantID);
		
		if (!accountingYear.trim().equals("")) {
			strSQL = " And ( TBL_CABINETCLASS.ConfirmFlag='1' And " +
                    "( TBL_CABINETCLASS.DisplayRecFlag='2' And TBL_CABINETCLASS.TransDelayFlag='0' " +
                    " And TBL_CABINETCLASS.ConfirmYear < '" + (Integer.parseInt(accountingYear) - 1) + "'" +
                    " ) OR ( ( TBL_CABINETCLASS.DisplayRecFlag='1' And RTRIM(DISPLAYENDDATE) <> '' AND TBL_CABINETCLASS.DisplayEndDate<'" + accountingYear + "') " +
                    " OR ( TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear<'" + (Integer.parseInt(accountingYear) - 1) + "') " +
                    " ) ) And TBL_CABINETCLASS.KeepingPlace='1' And DocTransferFlag='0'";
	    } else {
	        strSQL = " And ( TBL_CABINETCLASS.ConfirmFlag='1' And " +
	                "( TBL_CABINETCLASS.DisplayRecFlag='2' And TBL_CABINETCLASS.TransDelayFlag='0' " +
	                " And TBL_CABINETCLASS.ConfirmYear < EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')-(INTERVAL '1' YEAR)) " +
	                " ) OR ( ( TBL_CABINETCLASS.DisplayRecFlag='1' And TBL_CABINETCLASS.DisplayEndDate<CAST(EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) AS char(4)) ) " +
	                " OR ( TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear<EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS') - (INTERVAL '1' YEAR)) ) " +
	                " ) ) And TBL_CABINETCLASS.KeepingPlace='1' And DocTransferFlag='0'";
	
	    }
		
		return strSQL;
	}

	public String getLVFieldInfo(String listType, String companyID, String lang, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_LISTTYPE", listType);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGListInfoVO> apprGListInfoVOList = ezApprovalGDAO.getLVFieldInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListInfoVOList.get(i)));
		}
		sb.append("</DATA>");

		return sb.toString();
	}

	public String getListInfo(String typeCode, String companyID, String lang, int tenantID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_LISTTYPE", typeCode);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGListInfoVO> apprGListInfoVOList = ezApprovalGDAO.getListInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListInfoVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		long width = 0;
		
		strSQL.append("<LISTINFO>");
		
		for (int k = 0; k < dlength; k++) {
			strSQL.append("<CELL>");
			strSQL.append("<SN>" + makeListField(docXML.getElementsByTagName("SN").item(k).getTextContent().trim()) + "</SN>");
			strSQL.append("<NAME>" + makeListField(docXML.getElementsByTagName("NAME").item(k).getTextContent().trim()) + "</NAME>");
			strSQL.append("<WIDTH>" + makeListField(docXML.getElementsByTagName("WIDTH").item(k).getTextContent().trim()) + "</WIDTH>");
			
			if (!docXML.getElementsByTagName("WIDTH").item(k).getTextContent().trim().equals("")) {
				width += Long.parseLong(docXML.getElementsByTagName("WIDTH").item(k).getTextContent().trim());
			}
			strSQL.append("<TABLENAME>" + makeListField(docXML.getElementsByTagName("TABLENAME").item(k).getTextContent().trim()) + "</TABLENAME>");
			strSQL.append("<COLNAME>" + makeListField(docXML.getElementsByTagName("COLNAME").item(k).getTextContent().trim()) + "</COLNAME>");
			strSQL.append("<COLALIAS>" + makeListField(docXML.getElementsByTagName("COLALIAS").item(k).getTextContent().trim()) + "</COLALIAS>");
			strSQL.append("<DTYPE>" + makeListField(docXML.getElementsByTagName("DTYPE").item(k).getTextContent().trim()) + "</DTYPE>");
			strSQL.append("</CELL>");
		}
		strSQL.append("<TWIDTH>" + width + "</TWIDTH>");
		strSQL.append("</LISTINFO>");
		
		return strSQL.toString();
	}

	//DocList_Flag- "RECORD":기록물 리스트, "CABINET":기록물철 리스트
	//ListTypeFlag- 0:대장목록, 1:편철확정, 2:생산현황고보, 3:목록이관대상, 4:파일이관대상, 5:이관목록, 6:연기신청목록
	public String getListTypeCode(String listFlag, String listType, LoginVO userInfo) {
		String typeCode = "";
        switch (listFlag.toUpperCase()) {
        case "CABINET":
            switch (listType.toUpperCase()) {
            case "0":	// 기록물철 대장
                typeCode = "002";
                break;

            case "1":	// 편철확정 대상 기록물철
                typeCode = "002";
                break;

            case "2":	// 기록물철 생산현황보고
                typeCode = "P01";
                break;

            case "3":	// 목록 이관대상
                typeCode = "P01";
                break;

            case "4":	// 파일 이관대상
                typeCode = "P01";
                break;

            case "5":	// 이관목록
                typeCode = "P01";
                break;

            case "6":	// 연기신청 목록
                typeCode = "008";
                break;

            case "7":	// 연기신청 목록
                typeCode = "002";
                break;

            case "8":	// 연기신청 목록
                typeCode = "009";
                break;

            case "9":	// 인계기록물철
                typeCode = "002";
                break;

            case "10":	// 종료연도 연기의뢰 기록물철(업무담당자)
                typeCode = "010";
                break;

            case "11":	// 종료연도 연기확인 기록물철(기록물 관리책임자)
                typeCode = "010";
                break;

            default:
                typeCode = "002";
                break;
            }
            break;

        case "RECORD":
            switch (listType.toUpperCase()) {
            case "0":	// 기록물 대장
                typeCode = "001";
                break;

            case "1":	// 편철확정 대상 기록물
                typeCode = "001";
                break;

            case "2":	// 기록물 생산현황보고
                typeCode = "P02";
                break;

            case "3":	// 목록이관대상
                typeCode = "P02";
                break;

            case "4":	// 파일이관대상
                typeCode = "P02";
                break;

            case "5":	// 이관목록
                typeCode = "P02";
                break;

            case "6":	// 연기신청 목록
                typeCode = "007";
                break;

            case "7":	// 폐기대상 기록물
                typeCode = "001";
                break;

            case "9":	// 완료첨부
                typeCode = "001";
                break;

            case "10":	// 접수목록
                typeCode = "001";
                break;

            case "11":	// 발송목록
                typeCode = "001";
                break;

            default:
                typeCode = "001";
                break;
            }
            break;

        case "CABHIST":		// 기록물철등록부 변경이력
            typeCode = "P03";
            break;

        case "RECHIST":		// 기록물등록대장 변경이력
            typeCode = "P04";
            break;

        case "SCLIST":			// 특수목록 리스트
            typeCode = "P05";
            break;

        case "ATTACH":			// 첨부리스트
            typeCode = "P06";
            break;

        case "DISTLIST":		// 배부대장
            typeCode = "P07";
            break;

        case "Delivery":		// 배부대장
            typeCode = messageSource.getMessage("ezApprovalG.t96", userInfo.getLocale());
            break;
        }
        
        return typeCode;
	}

	public String getNDigitNum(String strValue, int numDigits) {
		int valueLen = strValue.length();
		String tempDigit = "";
		
		while (valueLen < numDigits) {
			tempDigit = "0" + "" + tempDigit;
			valueLen++;
		}
		
		return tempDigit + strValue;
	}

	public String convWebToPath(String href, String dirPath, int tenantID) throws Exception{
//		String tempPath = href.toLowerCase();
		href = href.replace("/fileroot"+ commonUtil.separator + tenantID +"/files/upload_approvalG/", dirPath);
//		tempPath = tempPath.replace("/files/upload_approvalg/", dirPath);

		return href;
	}

	public String makeTaskListXmlAll(Document docXML, String companyID, String langType, int tenantID) throws Exception{
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("097", companyID, langType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");

		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()) + "</DATA2>");
			if (makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA3>" + "0" + "</DATA3>");
			} else {
				resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()) + "</DATA3>");
			}
			
			if (makeListField(docXML.getElementsByTagName("DISPLAYRECFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA4>" + "0" + "</DATA4>");
			} else {
				resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("DISPLAYRECFLAG").item(k).getTextContent()) + "</DATA4>");
			}
			
			if (makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA5>" + "0" + "</DATA5>");
			} else {
				resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()) + "</DATA5>");
			}
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("SC1").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("SC2").item(k).getTextContent()) + "</DATA7>");
			resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("SC3").item(k).getTextContent()) + "</DATA8>");
			resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("KEEPINGMETHOD").item(k).getTextContent()) + "</DATA9>");
			resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("KEEPINGPLACE").item(k).getTextContent()) + "</DATA10>");
			resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</DATA11>");
			resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</DATA12>");
			resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("SCNAME").item(k).getTextContent()) + "</DATA13>");
			resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("SCNAME2").item(k).getTextContent()) + "</DATA14>");
			resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("SUBCATEGORYCODE").item(k).getTextContent()) + "</DATA15>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			if (commonUtil.getPrimaryData(langType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPeriodString(makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()), companyID, langType, tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			if (makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()).equals("1")) {
				resultXML.append("<VALUE>" + "Y" + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + "N" + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	public String getRecordTypeString(String code, String companyID, String langType, int tenantID) throws Exception{
		return getCabinetCode2Name("000", code, companyID, langType, tenantID);
	}

	public String getAccountingYear(String todayTime, String companyID, String langType, int tenantID) throws Exception{
		String accountYear = todayTime.substring(0, 4);
		int month = 0;
		String accountLastMonth = getCode2Name("A30", "003", companyID, langType, tenantID);
		LOGGER.debug("getCode2Name ended.");
		/// 사립대나 특정회사에서는 회계년도를 1월~12월이 아닌 3월~익년2월인 경우가 있어서 회계년도를 반환
		if (!accountLastMonth.equals("0") || !accountLastMonth.equals("")) {
			accountLastMonth = "-" + accountLastMonth;
			month = Integer.parseInt(accountLastMonth);
		}
		
		if (todayTime.length() > 10) {
			accountYear = EgovDateUtil.addMonth(todayTime.substring(0, 10).replace("-", ""), month, "").substring(0, 4);
		} else {
			accountYear = EgovDateUtil.addMonth(todayTime, month, "").substring(0, 4);
		}

		return accountYear;
	}

	@Override
	public String makeTaskListXml(Document docXML, String companyID, String strType, int tenantID) throws Exception{
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("097", companyID, strType, tenantID);
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()) + "</DATA2>");
			if (makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA3>" + "0" + "</DATA3>");
			} else {
				resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()) + "</DATA3>");
			}
			
			if (makeListField(docXML.getElementsByTagName("DISPLAYRECFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA4>" + "0" + "</DATA4>");
			} else {
				resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("DISPLAYRECFLAG").item(k).getTextContent()) + "</DATA4>");
			}
			
			if (makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()).length() <= 0) {
				resultXML.append("<DATA5>" + "0" + "</DATA5>");
			} else {
				resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(k).getTextContent()) + "</DATA5>");
			}
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("SC1").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("SC2").item(k).getTextContent()) + "</DATA7>");
			resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("SC3").item(k).getTextContent()) + "</DATA8>");
			resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("KEEPINGMETHOD").item(k).getTextContent()) + "</DATA9>");
			resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("KEEPINGPLACE").item(k).getTextContent()) + "</DATA10>");
			resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</DATA11>");
			resultXML.append("<DATA12>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</DATA12>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			if (commonUtil.getPrimaryData(strType, tenantID).equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPeriodString(makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()), companyID, strType, tenantID) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			if (makeListField(docXML.getElementsByTagName("TEMPFLAG").item(k).getTextContent()).equals("1")) {
				resultXML.append("<VALUE>" + "Y" + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + "N" + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("</ROW>");
        }
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		
		return resultXML.toString();
	}

	@Override
	public String doSusinHesong(String docID, String receiveSN, String deptID, String docState, String userID, String userName, String userName2, String dirPath, String companyID, String lang, int tenantID)
			throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String subSQL = "";
		boolean rtnVal = true;
		String hesongType = getCode2Name("A25", "001", companyID, lang, tenantID);
		LOGGER.debug("getCode2Name ended.");
		String orgDocID = "";
		String orgCompanyID = "";
		
		if (hesongType.trim().equals("") || hesongType.trim().equals("0") || receiveSN.equals("1")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_TENANTID", tenantID);
			
			List<ApprGAprDocInfoVO> apprGAprDocInfoVOList = ezApprovalGDAO.doSusinHesongAprDocInfo(map);
			
			StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < apprGAprDocInfoVOList.size(); i++) {
				sb.append(commonUtil.getQueryResult(apprGAprDocInfoVOList.get(i)));
			}
			sb.append("</DATA>");
			
			Document signXML = commonUtil.convertStringToDocument(sb.toString());
			
			if (signXML.getDocumentElement().getChildNodes().getLength() > 0) {
				orgDocID = makeListField(signXML.getElementsByTagName("ORGDOCID").item(0).getTextContent());
				orgCompanyID = makeListField(signXML.getElementsByTagName("COMPANYID").item(0).getTextContent());
				
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("companyID", companyID);
				map1.put("v_DOCID", orgDocID);
				map1.put("v_FLAG", "END");
				map1.put("v_TENANTID", tenantID);

				
				String fileName = ezApprovalGDAO.getDocInfoHref(map1);
				String extFileName = getExtendedFileName(fileName);
				String fileURL = dirPath + commonUtil.separator + fileName.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator, "");
				
				File file = new File(dirPath + companyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID));
				
				if (!file.exists()) {
					copyFile(fileURL, dirPath + orgCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName,
							dirPath + orgCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID));
				}
				
				if (companyID.toUpperCase().equals(orgCompanyID.toUpperCase())) {
					strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET AprState = '" + staASWheSong);
					strSQL.append("', ProcessYN = 'Y', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
					strSQL.append(" WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N' AND TENANT_ID=" + tenantID +";\n");
					
					int pSN = Integer.parseInt(receiveSN) + 1;
					
					strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
					strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
					strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
					strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) SELECT '" + pSN);
					strSQL.append("', DocID, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, '");
					strSQL.append(makeListField(signXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent()) + "', N'");
					strSQL.append(makeListField(signXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent()) + "', N'");
					strSQL.append(makeListField(signXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent()));
					strSQL.append("', DocState, '" + staASWheSong + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')" );
					strSQL.append(", 'N', '', '', '', '', '', '', DocID, TENANT_ID FROM TBL_APRRECEIPTPROCESSINFO " + " WHERE ROWNUM <= 1 AND DocID = '");
					strSQL.append(docID + "' AND ReceiveSN = '" + receiveSN + "' AND TENANT_ID = " + tenantID +" order by ProcessDate desc;\n");
				} else {
					strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET AprState = '" + staASWheSong);
					strSQL.append("', ProcessYN = 'Y', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
					strSQL.append(" WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N' AND TENANT_ID =" + tenantID +"\n");
					
					subSQL = doSendHesongDoc(docID, dirPath, companyID, orgCompanyID, tenantID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				strSQL.append("Delete TBL_EXPAPRLINE where DocID = '" + docID + "' AND TENANT_ID=" + tenantID +";\n");
				strSQL.append("Delete TBL_APRLINEINFO where DocID = '" + docID + "' AND TENANT_ID =" + tenantID +";\n");
				
				subSQL = updateSusinResult(orgDocID, deptID, userID, "H", userName, userName2, orgCompanyID, tenantID);
				
				if (subSQL == null || subSQL.equals("")) {
					rtnVal= false;
				} else {
					strSQL.append(subSQL);
				}
				
				if (rtnVal) {
					sendRecvMsg(makeListField(signXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent()), orgDocID, "HESONG", orgCompanyID, lang, tenantID);
				}
			} else {
				rtnVal = false;
			}
		} else {
			strSQL.append("UPDATE TBL_APRRECEIPTPROCESSINFO SET AprState = '" + staASWheSong);
			strSQL.append("', ProcessYN = 'Y', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
			strSQL.append(" WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N' AND TENANT_ID ="+ tenantID +"\n");
			
            int pSN = Integer.parseInt(receiveSN) + 1;

            strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) SELECT '" + pSN);
            strSQL.append("', DocID, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, SentDeptID, SentDeptName, SentDeptName2, DocState, '");
			strSQL.append(staASWheSong + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
            strSQL.append(", 'N', '', '', '', '', '', '', DocID , TENANT_ID FROM TBL_APRRECEIPTPROCESSINFO " + "WHERE ROWNUM <= 1 AND DocID = '");
			strSQL.append(docID + "' AND ReceiveSN = '" + receiveSN + "' AND TENANT_ID="+ tenantID +" order by ProcessDate desc;\n");

			strSQL.append("Delete TBL_EXPAPRLINE where DocID = '" + docID + "' AND TENANT_ID=" + tenantID +";\n");
            strSQL.append("Delete TBL_APRLINEINFO where DocID = '" + docID + "' AND TENANT_ID=" + tenantID +";\n");
            
            subSQL = updateSusinResult(orgDocID, deptID, userID, "H", userName, userName2, orgCompanyID, tenantID);
            
            if (subSQL == null || subSQL.equals("")) {
				rtnVal= false;
			} else {
				strSQL.append(subSQL);
			}
            
            if (rtnVal) {
            	Map<String, Object> map = new HashMap<String, Object>();
        		map.put("companyID", companyID);
        		map.put("v_DOCID", docID);
        		map.put("v_RECEIVESN", receiveSN);
        		map.put("v_TENANTID", tenantID);

        		String sentDeptID = ezApprovalGDAO.doSusinHesongSentDeptID(map);
        		
        		sendRecvMsg(sentDeptID, docID, "HESONG", orgCompanyID, lang, tenantID);
            }
		}
		
		if (rtnVal) {
			try {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
				map2.put("companyID", companyID);
				
				ezApprovalGDAO.transactionSQL(map2);
				
				rtnVal = true;
			} catch (Exception e) {
				rtnVal = false;
			}
		}
		
		if (rtnVal) {
			return "<RESULT>TRUE</RESULT>";
		} else {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getAprType_AprState(String docID, String userID, String companyID, int tenantID) throws Exception {
		String sbVal = "NO/NO";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", userID);
		map.put("v_TENANTID", tenantID);

		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getAprLineInfoAprState(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document infoXml = commonUtil.convertStringToDocument(sb.toString());
		
		if (infoXml.getElementsByTagName("APRTYPE").getLength() > 0) {
			sbVal = infoXml.getElementsByTagName("APRTYPE").item(0).getTextContent() + "/" + infoXml.getElementsByTagName("APRSTATE").item(0).getTextContent();
		} else {
			sbVal = "NO/NO";
		}
		
		return sbVal;
	}

	@Override
	public String doCallBack(String docID, String userID, String companyID, int tenantID) throws Exception {
		String rtnXML = getCallBackYN(docID, userID, companyID, tenantID);
		boolean rtnVal = true;
		
		if (!rtnXML.equals("<RESULT>CALLBACK</RESULT>") && !rtnXML.equals("<RESULT>CANCEL</RESULT>")) {
			rtnVal = false;
		}
		
		if (rtnVal) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_USERID", userID);
			map.put("v_TENANTID", tenantID);
			
			try {
				int aprMemberSn = ezApprovalGDAO.selectDoCallBack(map);
				if(aprMemberSn > 0) {
					if(aprMemberSn == 1) {
						ezApprovalGDAO.updateDoCallBack(map);
					}
					map.put("v_APRMEMBERSN", aprMemberSn);
					ezApprovalGDAO.updateDoCallBack2(map);
					
					map.put("v_APRMEMBERSN", aprMemberSn + 1);
					ezApprovalGDAO.updateDoCallBack3(map);
				}
				rtnVal = true;
			} catch (Exception e) {
				rtnVal = false;
			}
		}
		
		if (rtnVal) {
			return "<RESULT>TRUE</RESULT>";
		} else {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getFormConnFlag(String docID, String companyID, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);

		String strResult = ezApprovalGDAO.getFormConnFlag(map);
		
		resultXML.append("<RESULT>");
		
		if (strResult != null && !strResult.equals("")) {
			resultXML.append(strResult);
		}
		resultXML.append("</RESULT>");
		
		return resultXML.toString();
	}

	@Override
	public String getInnerLineInfo(String docID, String deptID, String docState, String companyID, int tenantID) throws Exception {
		String rtnXML = "";
		String rtnDocID = "";
		String rtnDocFlag = "";
		String rtnGDocID = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_DOCSTATE", docState);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getInnerLineInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("DOCID").item(0) != null) {
			rtnDocID = docXML.getElementsByTagName("DOCID").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("FLAG").item(0) != null) {
			rtnDocFlag = docXML.getElementsByTagName("FLAG").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("GDOCID").item(0) != null) {
			rtnGDocID = docXML.getElementsByTagName("GDOCID").item(0).getTextContent();
		}
		
		rtnXML = "<RESULT><DOCID>" + rtnDocID + "</DOCID><FLAG>" + rtnDocFlag + "</FLAG><GDOCID>" + rtnGDocID + "</GDOCID></RESULT>"; 
		
		return rtnXML;
	}

	@Override
	public String getSearchDocList(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR, String draftFromMONTH,
			String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR, String apprToMONTH,
			String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY, String draftDeptName,
			String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, String approvUser, int tenantID, String offset) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		boolean publicFlag = false;
		boolean securityFlag = false;
		String userSecurityCode = "";
		
		if (getIsUse("A22", "001", companyID, lang, tenantID).equals("1")) {
			securityFlag = true;
		}
		
		if (getIsUse("A22", "004", companyID, lang, tenantID).equals("1")) {
			publicFlag = true;
		}
		
		if (securityFlag) {
			userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6", tenantID);
		}
		
		if (userSecurityCode == null || userSecurityCode.equals("")) {
			userSecurityCode = "0";
		}
		
		String listString = "";
		
		if (containerID.equals("ADMIN")) {
			listString = getListHeader("082", companyID, lang, tenantID);
		} else {
			listString = getListHeader("006", companyID, lang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		String tmpStartDate1 = commonUtil.getDateStringInUTC(commonUtil.makeDate(draftFromYEAR, draftFromMONTH, draftFromDAY, true), offset, false).trim();
		String tmpStartDate2 = commonUtil.getDateStringInUTC(commonUtil.makeDate(draftToYEAR, draftToMONTH, draftToDAY, false), offset, false).trim();
		String tmpEndDate1 = commonUtil.getDateStringInUTC(commonUtil.makeDate(apprFromYEAR, apprFromMONTH, apprFromDAY, true), offset, false).trim();
		String tmpEndDate2 = commonUtil.getDateStringInUTC(commonUtil.makeDate(apprToYEAR, apprToMONTH, apprToDAY, false), offset, false).trim();
		String tmpProcessDate1 = commonUtil.getDateStringInUTC(commonUtil.makeDate(myApprFromYEAR, myApprFromMONTH, myApprFromDAY, true), offset, false).trim();
		String tmpProcessDate2 = commonUtil.getDateStringInUTC(commonUtil.makeDate(myApprToYEAR, myApprToMONTH, myApprToDAY, false), offset, false).trim();
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getSearchDocListCount(containerID, userID, userSecurityCode, publicFlag, subQuery, docNumber, docTitle, drafter, draftDeptName, formID, tmpStartDate1, tmpStartDate2, tmpEndDate1, tmpEndDate2,
				tmpProcessDate1, tmpProcessDate2, aprFlag, docState, commonUtil.getMultiData(lang, tenantID), approvUser, companyID, tenantID);
		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);

        if (querySize2 >= Integer.parseInt(pageSize)) {
        	querySize2 = Integer.parseInt(pageSize);
        }
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!orderCell.equals("") && orderCell.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (orderOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getSearchDocList(containerID, userID, userSecurityCode, publicFlag, subQuery, docNumber, docTitle, drafter, draftDeptName, formID, tmpStartDate1, tmpStartDate2, tmpEndDate1, tmpEndDate2,
				tmpProcessDate1, tmpProcessDate2, aprFlag, docState, querySize, querySize2, orderOption1, orderOption2, commonUtil.getMultiData(lang, tenantID), approvUser, companyID, tenantID, offset);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("FORMNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("WRITERID").item(k).getTextContent()) + "</DATA3>");
					resultXML.append("<DATA4>" + docXML.getElementsByTagName("CONTAINERID").item(k).getTextContent() + "</DATA4>");
					resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent()) + "</DATA5>");
					resultXML.append("<DATA6>" + docXML.getElementsByTagName("FORMID").item(k).getTextContent() + "</DATA6>");
					resultXML.append("<DATA7>" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "</DATA7>");
					resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("ISPUBLIC").item(k).getTextContent()) + "</DATA8>");
					resultXML.append("<DATA9>" + docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent() + "</DATA9>");
					resultXML.append("<DATA10>" + docXML.getElementsByTagName("SECURITYAPPROVAL").item(k).getTextContent() + "</DATA10>");
					resultXML.append("<DATA11>" + docXML.getElementsByTagName("EDMSYN").item(k).getTextContent() + "</DATA11>");
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
		
		return resultXML.toString();
	}

	@Override
	public String updateSignCheck(String strSQL, String companyID) throws Exception {
		String rtnVal = "";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", strSQL);
			map.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map);
			
			rtnVal = "TRUE";
		} catch (Exception e) {
			rtnVal = "FALSE";
		}
		
		return rtnVal;
	}

	@Override
	public String aprAttachMail(String docID, String flag, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", flag);
		map.put("v_TENANTID", tenantID);
		LOGGER.debug("aprAttachMail Param: v_DOCID=" + docID + "v_FLAG=" + "v_TENANTID=" + tenantID); 

		List<ApprGAttachInfoVO> apprGAttachInfoVOList = ezApprovalGDAO.aprAttachMail(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAttachInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAttachInfoVOList.get(i)));
		}
		sb.append("</DATA>");

		return sb.toString();
	}

	private String getSearchDocList(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, String docNumber, String docTitle, String drafter,
			String draftDeptName, String formID, String tmpStartDate1, String tmpStartDate2, String tmpEndDate1, String tmpEndDate2, String tmpProcessDate1, String tmpProcessDate2, String aprFlag,
			String docState, int querySize, int querySize2, String orderOption1, String orderOption2, String langType, String approvUser, String companyID, int tenantID, String offset) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_USERSECCODE", userSecurityCode);
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		map.put("v_DOCNUMBER", docNumber.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_DOCTITLE", docTitle.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_DRAFTER", drafter.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_DEPTNAME", draftDeptName.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_FORMID", formID.trim());
		map.put("v_STARTDATE1", tmpStartDate1);
		map.put("v_STARTDATE2", tmpStartDate2);
		map.put("v_ENDDATE1", tmpEndDate1);
		map.put("v_ENDDATE2", tmpEndDate2);
		map.put("v_PROCESSDATE1", tmpProcessDate1);
		map.put("iv_APRFLAG", aprFlag);
		if(tmpProcessDate1.length() > 0 ) {
			map.put("iv_APRFLAG", "INMYAPPRSEARCH");
		}
		map.put("v_PROCESSDATE2", tmpProcessDate2);
		
		if(tmpProcessDate2.length() > 0 ) {
			map.put("iv_APRFLAG", "INMYAPPRSEARCH");
		}
		
		if(containerID.length() == 0 ) {
			map.put("iv_APRFLAG", "");
		}
		
		map.put("v_DOCSTATE", docState.trim());
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if(orderOption1.length() > 0 ) {
		map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0, 7).toLowerCase());
			if(orderOption1.length() >= 7 ) {
				if(orderOption1.substring(0, 7).toLowerCase().equals("enddate")) {
					map.put("v_tmp", "ORDER BY "+ orderOption1 +" DESC");
				} else {
					map.put("v_tmp", "ORDER BY "+ orderOption1 +" DESC , ENDDATE ASC");
				}
			} else {
				map.put("v_tmp", "ORDER BY "+ orderOption1 +" DESC , ENDDATE ASC ");
			}
		} else {
			map.put("v_tmp", "ORDER BY ENDDATE ASC");
		}
		
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_ORDEROPTION2LENGTH", orderOption2.length());
		if(orderOption2.length() > 0 ) {
			map.put("v_ORDEROPTION2VALUE", orderOption2.substring(0, 7).toLowerCase());
		}
		map.put("v_LANGTYPE", langType);
		map.put("v_APPROVUSER", approvUser.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("offset", commonUtil.getMinuteUTC(offset));
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getSearchDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	private int getSearchDocListCount(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, String docNumber, String docTitle, String drafter,
			String draftDeptName, String formID, String tmpStartDate1, String tmpStartDate2, String tmpEndDate1, String tmpEndDate2, String tmpProcessDate1, String tmpProcessDate2, String aprFlag,
			String docState, String langType, String approvUser, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTID", containerID);
		map.put("v_USERID", userID);
		map.put("v_USERSECCODE", userSecurityCode);
		if (publicFlag) {
			map.put("v_PUBFLAG", "Y");
		} else {
			map.put("v_PUBFLAG", "N");
		}
		map.put("v_SUBQUERY", subQuery);
		map.put("v_DOCNUMBER", docNumber.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_DOCTITLE", docTitle.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_DRAFTER", drafter.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_DEPTNAME", draftDeptName.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		map.put("v_FORMID", formID.trim());
		map.put("v_STARTDATE1", tmpStartDate1);
		map.put("v_STARTDATE2", tmpStartDate2);
		map.put("v_ENDDATE1", tmpEndDate1);
		map.put("v_ENDDATE2", tmpEndDate2);
		map.put("v_PROCESSDATE1", tmpProcessDate1);
		map.put("v_PROCESSDATE2", tmpProcessDate2);
		if(tmpProcessDate1.length() > 0) {
			aprFlag = "INMYAPPRSEARCH";
		}
		if(tmpProcessDate2.length() > 0) {
			aprFlag = "INMYAPPRSEARCH";
		}
		if(containerID.length() == 0) {
			aprFlag = "";
		}
		map.put("v_APRFLAG", aprFlag.toUpperCase());
		map.put("v_DOCSTATE", docState.trim());
		map.put("v_LANGTYPE", langType);
		map.put("v_TENANTID", tenantID);
		map.put("v_APPROVUSER", approvUser.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		
		int resultCnt = ezApprovalGDAO.getSearchDocListCount(map);
		
		return resultCnt;
	}

	private String doSendHesongDoc(String docID, String dirPath, String companyID, String orgCompanyID, int tenantID) throws Exception{
		// TODO 테스트를 꼮 해봐야함
		StringBuilder strSQL = new StringBuilder();
		
		String newID = getNewID(orgCompanyID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", "APR");
		map.put("v_TENANTID", tenantID);

		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String url = commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator + orgCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" +
				commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		String fileURL = dirPath + commonUtil.separator + fileName.replace(commonUtil.getUploadPath("upload_approvalG.ROOT", tenantID) + commonUtil.separator, "");
		
		boolean rtnVal = copyFile(fileURL, dirPath + orgCompanyID + commonUtil.separator + "doc" + commonUtil.separator + commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" +
				commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName, dirPath + orgCompanyID + commonUtil.separator + "doc" + commonUtil.separator + 
				commonUtil.getTodayUTCTime("yyyy") + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID));
		
		if (rtnVal) {
			strSQL.append("INSERT INTO TBL_APRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
			strSQL.append("isPublic, TENANT_ID) SELECT '" + newID + "', FormID, OrgDocID, DocType, DocState, '");
			strSQL.append(staASWheSong + "', '" + url + "', DocTitle, DocNo, HasAttachYN, HasOpinionYN, TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
            strSQL.append(", NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic, TENANT_ID FROM TBL_APRDOCINFO  WHERE DocID = '" + docID + "' AND TENANT_ID =" +tenantID +";\n");

			// 수정(2005.09.29) : 보안결재 필드 추가
			strSQL.append("INSERT INTO TBL_EXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID) ");
            strSQL.append("SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
            strSQL.append("ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval, TENANT_ID FROM TBL_EXPAPRDOCINFO  ");
			strSQL.append("WHERE DocID = '" + docID + "' AND TENANT_ID = "+ tenantID +" ;\n");

			strSQL.append("INSERT INTO TBL_APRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID) SELECT '" + newID);
            strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach,TENANT_ID FROM ");
            strSQL.append("TBL_APRATTACHINFO  WHERE DocID = '" + docID + "' AND TENANT_ID =" + tenantID +";\n");

			strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID) SELECT '" + newID);
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID FROM ");
            strSQL.append("TBL_APRDOCATTACHINFO  WHERE DocID = '" + docID + "' AND TENANT_ID =" + tenantID +";\n");

			strSQL.append("INSERT INTO TBL_APROPINIONINFO (DocID, UserID, OpinionGB, Content, ");
            strSQL.append("UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN, TENANT_ID) SELECT '");
            strSQL.append(newID + "', UserID, OpinionGB, Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN, TENANT_ID FROM TBL_APROPINIONINFO  WHERE DocID = '" + docID + "' AND TENANT_ID ="+ tenantID +";\n");
            // 2010.08.03 다국어
			strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, ");
            strSQL.append("SentDeptID, SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, ");
            strSQL.append("AprState, ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) SELECT '1', '" + newID);
            strSQL.append("', ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, SentDeptID, SentDeptName, SentDeptName2, DocState, '");
            strSQL.append(staASWheSong + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), 'N', '', '','', '', '', '', DocID , TENANT_ID");
            strSQL.append("FROM TBL_APRRECEIPTPROCESSINFO  WHERE DocID = '" + docID + "' AND ReceiveSN = '1' AND TENANT_ID ="+tenantID +";\n");
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	public String getKeepPeriodString(String code, String companyID, String strType, int tenantID) throws Exception{
		return getCabinetCode2Name("004", code, companyID, strType, tenantID);
	}
	
	public String getKeepMethodString(String code, String companyID, String strType, int tenantID) throws Exception{
		return getCabinetCode2Name("001", code, companyID, strType, tenantID);
	}
	
	public String getKeepPlaceString(String code, String companyID, String strType,int tenantID) throws Exception{
		return getCabinetCode2Name("002", code, companyID, strType, tenantID);
	}

	public String getCabinetCode2Name(String codeType, String code, String companyID, String strType, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODETYPE", codeType);
		map.put("v_CODE", code);
		map.put("v_LANGTYPE", strType);
		map.put("v_TENANTID", tenantID);
		
		String result = ezApprovalGDAO.getCabinetCode2Name(map);
		
		return result;
	}

	public String getReceiptTempletSN(String strFormID, String strUserID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", strFormID);
		map.put("v_TENANTID", tenantID);
		map.put("v_USERID", strUserID);
		
		int receiptSN = ezApprovalGDAO.getReceiptTempletSN(map);
		
		receiptSN += 1;
		
		return String.valueOf(receiptSN);
	}

	public String addToAprLineDB(String formID, String userID, String aprSN, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_APRLINESN", aprSN);
		map.put("v_TENANTID", tenantID);
		map.put("v_COMPANYID", companyID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.addToAprLineDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public int getLineTempletSN(String strFormID, String strUserID, String companyID,int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", strFormID);
		map.put("v_USERID", strUserID);
		map.put("v_TENANTID", tenantID);
		int receiptSN = ezApprovalGDAO.getLineTempletSN(map);
		
		return receiptSN;
	}

	public String getNewID(String companyID, int tenantID) throws Exception{
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		rtnVal= ezApprovalGDAO.selectAprGetNewID(map);
		if(rtnVal == null) {
			ezApprovalGDAO.insertAprGetNewID(map);
		}
		
		ezApprovalGDAO.aprGetNewID(map);
		rtnVal = ezApprovalGDAO.selectAprGetNewID(map);
		rtnVal = String.format("%020d", Integer.parseInt(rtnVal.trim()));
		
		return rtnVal;
	}

	public String getFormRecvAprDB(String formID, String userID, String flag, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_FLAG", flag);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		List<ApprGReceiptVO> apprGReceiptVOList = ezApprovalGDAO.getFormRecvAprDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGReceiptVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGReceiptVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String deleteReceiptInfo(String strDocID, String companyID, int tenantID) {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", strDocID);
			map.put("v_TENANTID", tenantID);
			map.put("companyID", companyID);
			
			ezApprovalGDAO.deleteReceiptInfo(map);
			
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return "<RESULT>FALSE</RESULT>";
		}
	}

	public int getCountChildFormCont(String id, String deptID, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PID", id);
		map.put("v_PDEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		LOGGER.debug("getCountChildFormCont param : v_PID= " + id +" v_PDEPTID=" + deptID + " v_TENANTID" + tenantID);

		return ezApprovalGDAO.getCountChildFormCont(map);
	}

	public String getFormInfoDB(String formContID, String userID, String kind, String strMultiData, String searchType, String searchName, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", formContID);
		map.put("v_USERID", userID);
		map.put("v_FORMKIND", kind);
		map.put("v_LANGTYPE", strMultiData);
		map.put("v_SEARCHTYPE", searchType);
		map.put("v_SEARCHNAME", searchName);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		List<ApprGFormVO> apprGFormVOlist = ezApprovalGDAO.getFormInfo(map); 
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGFormVOlist.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGFormVOlist.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getWebPartList(String listType, String userID, String deptID, String userIDs, String deptIDs, String userFlag, String listCount, String basicOrder, String lang, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERIDS", userIDs);
		map.put("v_DEPTIDS", deptIDs);
		map.put("v_USERFLAG", userFlag);
		map.put("v_LISTCOUNT", listCount);
		map.put("v_BASICORDER", basicOrder);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		List<ApprGWebPartVO> apprGWebPartVOList = ezApprovalGDAO.getWebPartList(map); 
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGWebPartVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGWebPartVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getLeftDocCount(String userID, String deptID, String userIDs, String deptIDs, String userFlag, String companyID , int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERIDS", userIDs);
		map.put("v_DEPTIDS", deptIDs);
		map.put("v_USERFLAG", userFlag.trim().toLowerCase());
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		map.put("companyID", companyID);
		map.put("v_STARTDATE", "TO_DATE('" + Integer.toString(Integer.parseInt(commonUtil.getTodayUTCTime("yyyy-MM-dd").substring(0,4))-1) + commonUtil.getTodayUTCTime("yyyy-MM-dd").substring(4,commonUtil.getTodayUTCTime("yyyy-MM-dd").length())  + " 00:00:01','YYYY-MM-DD HH24:MI:SS')"); 
		map.put("v_ENDDATE", "TO_DATE('" + commonUtil.getTodayUTCTime("yyyy-MM-dd") + " 23:59:59','YYYY-MM-DD HH24:MI:SS') "); 

		List<String> leftCounts = ezApprovalGDAO.getLeftDocCount(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < leftCounts.size(); i++) {
        	sb.append("<ROW>");
        	sb.append("<COUNT>"+ leftCounts.get(i) +"</COUNT>");
        	sb.append("</ROW>");
		}
        sb.append("</DATA>");
        
		return sb.toString();
	}

	public int getWebPartListCount(String listType, String userID, String deptID, String userIDs, String deptIDs, String userFlag, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERIDS", userIDs);
		map.put("v_DEPTIDS", deptIDs);
		map.put("v_USERFLAG", userFlag);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		return ezApprovalGDAO.getWebPartListCount(map);
	}

	public String getDocManageDeptInfo(String deptID, int tenantID) throws Exception{
		StringBuilder rtnVal = new StringBuilder();
		String deptInfo = ezOrganService.getPropertyValue(deptID, "extensionAttribute4", tenantID);
		
		if (deptInfo != null) {
			String[] dept = deptInfo.split(";");
			
			rtnVal.append("'" + makeRightField(deptID) + "'");
			
			for (int k = 0; k < dept.length; k++) {
				if (!dept[k].trim().equals("")) {
					rtnVal.append(", '" + makeRightField(dept[k].trim()) + "'");
				}
			}
			
			return rtnVal.toString();
		} else {
			return "'" + deptID + "'";
		}
	}

	public String getOpinionInfo(String docID, String mode, String orderOption1, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		
		if (orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0, 9).toLowerCase());
		}
		
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		List<ApprGOpinionVO> apprGAprLineVOList = ezApprovalGDAO.getOpinionInfo(map);
		LOGGER.debug("apprGAprLineVOList param : v_DOCID =" + docID + "v_MODE =" + mode + "v_ORDEROPTION =" + orderOption1 + "v_TENANTID=" + tenantID);

		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getReceiptInfo(String docID, String mode, String orderOption1, String companyID, int tenantID) throws Exception{
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		if (orderOption1.length() > 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0, 11).toLowerCase());
		}
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		List<ApprGReceiptVO> apprGAprLineVOList = ezApprovalGDAO.getReceiptInfo(map);
		
		LOGGER.debug("apprGAprLineVOList param : v_DOCID=" + docID + "v_MODE=" + mode + "v_ORDEROPTION=" + orderOption1 + "v_TENANTID=" + tenantID);
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getAttachInfoDB(String docID, String flag, String strLang, String strLangFile, String strLangDocument, String orderOption1, String companyID, int tenantID) throws Exception{
		LOGGER.debug("getAttachInfoDB started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", flag);
		map.put("v_STRLANG", strLang);
		map.put("v_LANGFILE", strLangFile);
		map.put("v_LANGDOCUMENT", strLangDocument);
		map.put("v_ORDERBY", orderOption1);
		map.put("v_ORDERBYLENGHT", orderOption1.length());
		
		if (orderOption1.length() > 0) {
			map.put("v_ORDERBYVALUE", orderOption1.substring(0, 10).toLowerCase());
		}
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		LOGGER.debug("getAttachInfoDB Param : v_DOCID=" + docID +"v_MODE=" + flag + "v_STRLANG=" + strLang + "v_LANGFILE=" +strLangFile + "v_LANGDOCUMENT =" + strLangDocument + "v_ORDERBY=" + orderOption1 + "v_TENANTID=" + tenantID);

		List<ApprGAttachInfoVO> apprGAprLineVOList = ezApprovalGDAO.getAttachInfoDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		LOGGER.debug("getAttachInfoDB ended.");

		return sb.toString();
	}

	@Override
	public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData, int tenantID, String offSet) throws Exception {
		LOGGER.debug("aprDocList started.");

		String orderOption1 = "";
		String orderOption2 = "";
		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = getIsUse("A23", "001", companyID, userLang, tenantID);
		StringBuffer resultXML = new StringBuffer();
		
		if (proxyOption.equals("1")) {
			userIDs = getProxyUser(userID, userLang, tenantID, offSet);
		}
		
		String basicOrder = getCode2Name("A18", "001", companyID, userLang, tenantID);
		LOGGER.debug("getCode2Name ended.");
		String basicOrderReverse = "desc";
		
		if (basicOrder.toLowerCase().equals("desc")) {
			basicOrderReverse = "";
		} else {
			basicOrder = "";
		}
		
		String listString = "";
		
		if (listType.equals("1")) {
			//결재할 문서
			listString = getListHeader("001", companyID, userLang, tenantID);
		} else if (listType.equals("2")) {
			//기안한 문서
			listString = getListHeader("002", companyID, userLang, tenantID);
		} else if (listType.equals("3")) {
			//결재진행 문서
			listString = getListHeader("003", companyID, userLang, tenantID);
		} else if (listType.equals("21")) {
			//서버저장 문서
			listString = getListHeader("009", companyID, userLang, tenantID);
		} else {
			listString = getListHeader("001", companyID, userLang, tenantID);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getAprDocListCount(listType, userID, userIDs, searchQuery, dueryData, companyID, tenantID);
		
		LOGGER.debug("getAprDocListCount ended.");

		int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) - 1);

        if (querySize2 >= Integer.parseInt(pageSize)) {
        	querySize2 = Integer.parseInt(pageSize);
        }
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALCNT>" + totalCount + "</TOTALCNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		for (int k = 0; k < hlength; k++) {
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(k).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(k).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + "</COLNAME>");
			
			if (!orderCell.equals("") && orderCell.equals(listXML.getElementsByTagName("NAME").item(k).getTextContent())) {
				if (orderOption.equals("")) {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
				} else {
					orderOption1 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					orderOption2 = listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
		String docList = getAprDocList(listType, userID, userIDs, querySize, querySize2, orderOption1, orderOption2, basicOrder, basicOrderReverse, searchQuery, dueryData, companyID, tenantID);
	
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		String fieldName = "";
		String fieldValue = "";
		
		resultXML.append("<ROWS>");
		
		for (int k = dlength - 1; k >= 0; k--) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				fieldName = listXML.getElementsByTagName("COLNAME").item(p).getTextContent().toUpperCase();
				
				if (fieldName.equals("FORMNAME") || fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("SENDERNAME")) {
					fieldName = fieldName + commonUtil.getMultiData(userLang, tenantID);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				resultXML.append("<VALUE>" + commonUtil.cleanValue(getListField(fieldName, fieldValue, companyID, userLang, tenantID, offSet)) + "</VALUE>");
				
				if (p == 0) {
					resultXML.append("<DATA1>" + docXML.getElementsByTagName("DOCID").item(k).getTextContent() + "</DATA1>");
					resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("ORGDOCID").item(k).getTextContent()) + "</DATA2>");
					resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("HREF").item(k).getTextContent()) + "</DATA3>");
					
					if (!listType.equals("3") && !listType.equals("21")) {
						resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA4>");
						resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME").item(k).getTextContent()) + "</DATA5>");
						resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA6>");
						resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA7>");
						resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent()) + "</DATA8>");
						resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("APRMEMBERNAME2").item(k).getTextContent()) + "</DATA17>");
						resultXML.append("<DATA18>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA18>");
						resultXML.append("<DATA19>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA19>");
					} else {
						resultXML.append("<DATA4>" + "" + "</DATA4>");
						resultXML.append("<DATA5>" + "" + "</DATA5>");
						resultXML.append("<DATA6>" + "" + "</DATA6>");
						resultXML.append("<DATA7>" + "" + "</DATA7>");
						resultXML.append("<DATA8>" + "" + "</DATA8>");
					}
					
					if (docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent().equals(staDSSuSin) && !listType.equals("3")) {
						resultXML.append("<DATA9>" + getAprDocListReceiveSN(docXML.getElementsByTagName("DOCID").item(k).getTextContent(), docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), companyID, tenantID) + "</DATA9>");
					} else {
						resultXML.append("<DATA9>" + "0" + "</DATA9>");
					}
					
					resultXML.append("<DATA10>" + docXML.getElementsByTagName("FUNCTIONTYPE").item(k).getTextContent() + "</DATA10>");
					resultXML.append("<DATA11>" + docXML.getElementsByTagName("HASOPINIONYN").item(k).getTextContent() + "</DATA11>");
					resultXML.append("<DATA12>" + docXML.getElementsByTagName("DOCSTATE").item(k).getTextContent() + "</DATA12>");
					resultXML.append("<DATA13>" + makeListField(docXML.getElementsByTagName("WRITERDEPTID").item(k).getTextContent()) + "</DATA13>");
					resultXML.append("<DATA14>" + makeListField(docXML.getElementsByTagName("URGENTAPPROVAL").item(k).getTextContent()) + "</DATA14>");
					resultXML.append("<DATA15>" + makeListField(docXML.getElementsByTagName("DOCTYPE").item(k).getTextContent()) + "</DATA15>");
					resultXML.append("<DATA16>" + makeListField(docXML.getElementsByTagName("WRITERID").item(k).getTextContent()) + "</DATA16>");
					resultXML.append("<DATA17>" + makeListField(docXML.getElementsByTagName("FORMID").item(k).getTextContent()) + "</DATA17>");
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
		
		LOGGER.debug("aprDocList ended.");

		return resultXML.toString();
	}

	public String getAprDocListReceiveSN(String docID, String receivedDeptID, String companyID, int tenantID) throws Exception{
		LOGGER.debug("getAprDocListReceiveSN started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_RECEIVEDDEPTID", receivedDeptID);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		LOGGER.debug("getAprDocListReceiveSN param : v_DOCID=" + docID + " v_RECEIVEDDEPTID=" + receivedDeptID + " v_TENANTID=" + tenantID );
		return ezApprovalGDAO.getAprDocListReceiveSN(map);
	}

	public String getListField(String fieldName, String fieldValue, String companyID, String userLang, int tenantID, String offSet) throws Exception{
		String rtnVal = "";
		
		switch (fieldName) {
			case "DOCTYPE" : 
				rtnVal = getCode2Name("A01", fieldValue, companyID, userLang, tenantID);
				LOGGER.debug("getCode2Name ended.");
				break;

			case "DOCSTATE" :
                rtnVal = getCode2Name("A02", fieldValue, companyID, userLang, tenantID);
                LOGGER.debug("getCode2Name ended.");
				break;

			case "APRTYPE" :
                rtnVal = getCode2Name("A03", fieldValue, companyID, userLang, tenantID);
                LOGGER.debug("getCode2Name ended.");
				break;

			case "APRSTATE" :
                rtnVal = getCode2Name("A04", fieldValue, companyID, userLang, tenantID);
                LOGGER.debug("getCode2Name ended.");
				break;

			case "FUNCTIONTYPE" :
                rtnVal = getCode2Name("A04", fieldValue, companyID, userLang, tenantID);
                LOGGER.debug("getCode2Name ended.");
				break;

			case "PROCESSYN" :
                rtnVal = getStatusName(fieldValue, companyID, userLang, tenantID);
                LOGGER.debug("getCode2Name ended.");
				break;

			case "OPINIONGB" :
                rtnVal = getCode2Name("A17", fieldValue, companyID, userLang, tenantID);
                LOGGER.debug("getCode2Name ended.");
				break;

			case "ATTACHFILESIZE" :
				rtnVal = fieldValue + " bytes";
				break;

			default : 
                if(fieldName.indexOf("DATE") > -1) {
                	fieldValue = commonUtil.getDateStringInUTC(convertDate(fieldValue), offSet, false);
                }
				rtnVal = fieldValue;
				break;
		}

		return makeListField(rtnVal);
	}

	public String makeListField(String orgStr) {
		if (orgStr == null || orgStr.equals("NULL")) {
			return "";
		} else {
			return orgStr;
		}
	}
	
   public String getSpecialRecString(String pCode, String companyID, String lang, int tenantID){
	   String rtnVal = "";
	   try{
		   int j=0;
	   for(int i=1; i<=pCode.length(); i++){
		   if(pCode.substring(j,i).equals("Y")){
			   if (!rtnVal.trim().equals("")){
				   rtnVal += ",";   
			   }
			   rtnVal += getCabinetCode2Name("005", Integer.toString(i), companyID, lang, tenantID);
			   j=j+i;
		   }
	   }
	   return rtnVal;
	   }
	   catch(Exception e){
	   }
	   return rtnVal;		   
	   }
   
   public String getPublicCodeString(String pCode, String companyID, String lang, int tenantID) throws Exception{
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("pCode", pCode);
			map.put("companyID", companyID);
			map.put("lang", lang);
			
			String rtn = null;
			String codeName = null;
			if(pCode.substring(0,1).equals("1")) {
				rtn = getCode2Name("A50", "1", companyID, lang, tenantID);
			} else if(pCode.substring(0,1).equals("2")) {
				rtn = getCode2Name("A50", "2", companyID, lang, tenantID);
			} else if(pCode.substring(0,1).equals("3")) {
				rtn = getCode2Name("A50", "3", companyID, lang, tenantID);
			}
			
			if(pCode.substring(0,1) == "2") {
				rtn = rtn + "(";
				
				if(pCode.substring(1,2).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "1");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(2,3).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "2");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(3,4).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "3");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(4,5).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "4");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(5,6).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "5");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(6,7).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "6");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(7,8).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "7");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				} if(pCode.substring(8,9).equals("Y")) {
					map.put("v_CodeType", "006");
					map.put("v_Code", "8");
					codeName = ezApprovalGDAO.getCabCodeList(map);
					rtn = rtn + codeName + "u','";
				}
				
				rtn = rtn + "u')'";
				rtn.replace("u',)'", ")");
			}
			
			if(rtn == null) {
				rtn = pCode;
			}
			
			return rtn;
   } 
	public String convertDate(String date) {
		if (date.trim().equals("")) {
			return date;
		}
		
		return date.substring(0, 19);
	}

	public String getStatusName(String fieldValue, String companyID, String userLang, int tenantID) throws Exception{
		return getCode2Name("A60", fieldValue.toUpperCase(), companyID, userLang, tenantID);
	}

	public String getAprDocList(String listType, String userID, String userIDs, int querySize, int querySize2, String orderOption1, String orderOption2, String basicOrder, String basicOrderReverse, String subQuery, Document dueryData, String companyID, int tenantID) throws Exception{
		LOGGER.debug("getAprDocList started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_USERIDS", userIDs);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_BASICORDER", basicOrder);
		map.put("v_BASICORDER2", basicOrderReverse);
		map.put("v_SPSUBQUERY", subQuery.trim());
		map.put("v_SPSUBQUERYLENGTH", subQuery.trim().length());
		map.put("v_ORDEROPTIONLENGTH", orderOption1.length());
		if (orderOption1 != null && orderOption1.length() != 0) {
			map.put("v_ORDEROPTIONVALUE", orderOption1.substring(0,9).toLowerCase());
		}
		map.put("v_ORDEROPTION2LENGTH", orderOption2.length());
		if (orderOption2 != null && orderOption2.length()!= 0) {
			map.put("v_ORDEROPTION2VALUE", orderOption2.substring(0,9).toLowerCase());
		}
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		if (dueryData.getElementsByTagName("DOCNO").item(0) != null) {
			map.put("v_SDOCNO", dueryData.getElementsByTagName("DOCNO").item(0).getTextContent());
		} else {
			map.put("v_SDOCNO", "");
		}
		
		if (dueryData.getElementsByTagName("DOCTITLE").item(0) != null) {
			map.put("v_SDOCTITLE", dueryData.getElementsByTagName("DOCTITLE").item(0).getTextContent());
		} else {
			map.put("v_SDOCTITLE", "");
		}
		
		if (dueryData.getElementsByTagName("WRITERNAME").item(0) != null) {
			map.put("v_SWRITERNAME", dueryData.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERNAME", "");
		}
		
		if (dueryData.getElementsByTagName("WRITERDEPTNAME").item(0) != null) {
			map.put("v_SWRITERDEPTNAME", dueryData.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERDEPTNAME", "");
		}
		if(listType.equals("21")){
			orderOption2 = "SN";
			map.put("v_ORDEROPTION2", orderOption2);
		}
		
		LOGGER.debug("getAprDocList Param : v_LISTTYPE =" + listType + "v_USERID=" + userID + "v_USERIDS=" + userIDs + "v_PAGESIZE=" + querySize + "v_PAGESIZE2=" + querySize2 +"v_ORDEROPTION=" + orderOption1 +"v_ORDEROPTION2=" + orderOption2 +"v_BASICORDER=" + basicOrder +"v_BASICORDER2=" + basicOrderReverse +"v_SPSUBQUERY=" + subQuery.trim() + "v_TENANTID=" + tenantID);
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getAprDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		LOGGER.debug("getAprDocList ended.");

		return sb.toString();
	}

	public int getAprDocListCount(String listType, String userID, String userIDs, String searchQuery, Document dueryData, String companyID, int tenantID) throws Exception{
		LOGGER.debug("getAprDocListCount started.");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_USERIDS", userIDs);
		map.put("v_SPSUBQUERY", searchQuery.trim());
		map.put("v_SPSUBQUERYLENGTH", searchQuery.trim().length());
		map.put("v_TENANTID", tenantID);
		if (dueryData.getElementsByTagName("DOCNO").item(0) != null) {
			map.put("v_SDOCNO", dueryData.getElementsByTagName("DOCNO").item(0).getTextContent());
		} else {
			map.put("v_SDOCNO", "");
		}
		
		if (dueryData.getElementsByTagName("DOCTITLE").item(0) != null) {
			map.put("v_SDOCTITLE", dueryData.getElementsByTagName("DOCTITLE").item(0).getTextContent());
		} else {
			map.put("v_SDOCTITLE", "");
		}
		
		if (dueryData.getElementsByTagName("WRITERNAME").item(0) != null) {
			map.put("v_SWRITERNAME", dueryData.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERNAME", "");
		}
		
		if (dueryData.getElementsByTagName("WRITERDEPTNAME").item(0) != null) {
			map.put("v_SWRITERDEPTNAME", dueryData.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
		} else {
			map.put("v_SWRITERDEPTNAME", "");
		}
		
		LOGGER.debug("getAprDocListCount param : v_LISTTYPE=" + listType + "v_USERID=" + userID + "v_USERIDS=" + userIDs + "v_SPSUBQUERY=" + searchQuery + "v_TENANTID=" + tenantID);

		return ezApprovalGDAO.getAprDocListCount(map);
	}
	@Override
	public String getProxyUser(String userID, String userLang, int tenantID ,String offset) throws Exception{
		LOGGER.debug("getProxyUser started");
		String rtnXML = ezOrganService.getSearchList("LEFT_extensionAttribute5::" + userID + ":", "displayname", "displayname;extensionAttribute5", "user", 50, commonUtil.getPrimaryData(userLang, tenantID), tenantID);
		Document doc = commonUtil.convertStringToDocument(rtnXML);
		int nodeLength = doc.getElementsByTagName("DATA2").getLength();
		boolean chkFirst = false;
		String rtnVal = "";
		String nowDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("") ,offset, false);
		if (nodeLength > 0) {
			for (int k = 0; k < nodeLength; k++) {
				String bujaeInfo = doc.getElementsByTagName("DATA4").item(k).getTextContent();
				String[] bujae = bujaeInfo.split(":");
				
				if (bujae.length >= 5) {
					if (nowDate.compareTo(bujae[3].replace("/", ":").substring(0, 16)) >= 0 && nowDate.compareTo(bujae[4].replace("/", ":").substring(0, 16)) <= 0) {
						if (!chkFirst) {
							rtnVal = "'" + makeRightField(doc.getElementsByTagName("DATA2").item(k).getTextContent()) + "'";
							chkFirst = true;
						} else {
							rtnVal += ", '" + makeRightField(doc.getElementsByTagName("DATA2").item(k).getTextContent()) + "'";
						}
					}
				}
			}
			
			if (!chkFirst) {
				rtnVal = "'" + makeRightField(userID) + "'";
			} else {
				rtnVal += ", '" + makeRightField(userID) + "'";
			}
		} else {
			rtnVal = "'" + makeRightField(userID) + "'";
		}
		LOGGER.debug("getProxyUser ended");
		return rtnVal;
	}

	public String getIsUse(String code1, String code2, String companyID, String userLang, int tenantID) throws Exception{
		LOGGER.debug("getIsUse started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		LOGGER.debug("getIsUse param : v_CODE1=" + code1 + " v_CODE2=" + code2 + " v_TENANTID=" + tenantID);

		return ezApprovalGDAO.getIsUse(map);
	}

	public String makeRightField(String userID) {
		if (userID != null) {
			return userID.replace("'", "''").replace("\0", "");
		} else {
			return userID;
		}
		
	}

	@Override
	public String getAprLineInfoDB(String docID, String flag, String userID, String formID, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_FLAG", flag);
		map.put("v_USERID", userID);
		map.put("v_FORMID", formID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getAprLineInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public Document checkPermission(String docID, String userID, String deptID, String checkMode, String companyID, int tenantID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PDOCID", docID);
		map.put("v_PAPRUSERID", userID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PMODE", checkMode);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		map.put("v_temp3", "");
		map.put("v_temp4", "");
		if (checkMode.equals("VIE")){
			int v_temp  = ezApprovalGDAO.countVieTempDocID(map);
			map.put("v_temp", v_temp);
			
			if (v_temp != 1) {
				int v_temp2  = ezApprovalGDAO.countVieTempDocID2(map);
				map.put("v_temp2", v_temp2);
			}
		} else if(checkMode.equals("REC")) {
			int v_temp  = ezApprovalGDAO.countRecTempDocID(map);
			map.put("v_temp", v_temp);
			
			if(v_temp == 1 ) {
				int v_temp2  = ezApprovalGDAO.countRecTempDocID2(map);
				map.put("v_temp2", v_temp2);
			} else {
				int v_temp3 = ezApprovalGDAO.countVieTempDocID(map);
				map.put("v_temp3", v_temp3);
				if( v_temp3 == 0 ) {
					List<ApprGAprLineVO> tempList = ezApprovalGDAO.countRecTempDocID3(map);
					map.put("v_temp4", tempList.size());
				}
			}
			
		}
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.checkPermission(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document doc = commonUtil.convertStringToDocument(sb.toString());
		
		return doc;
	}
	
	@Override
	public String sendOfferCheck(String docID, String userID, String string, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder rtnVal = new StringBuilder("");
		Map<String, Object> map = new HashMap<String, Object>();
		String GFlag = getCode2Name("A35", "002", companyID, lang, tenantID).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");
		map.put("v_DOCID", docID.trim());
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGDocListVO> sendoffercheck_enddocinfo = ezApprovalGDAO.sendoffercheck_enddocinfo(map);
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < sendoffercheck_enddocinfo.size(); i++) {
			sb.append(commonUtil.getQueryResult(sendoffercheck_enddocinfo.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("WRITERID").getLength()>0){
			String tempUserID = makeListField(docXML.getElementsByTagName("WRITERID").item(0).getTextContent());
			String tempDocType = makeListField(docXML.getElementsByTagName("DOCTYPE").item(0).getTextContent());
			
			if(tempUserID.trim().equals("")){
				rtnVal.append("<RESULT>NOUSER</RESULT>");
			}
			else if(!tempUserID.trim().toUpperCase().equals(userID.trim().toUpperCase()) && string.equals("MUST")){
				rtnVal.append("<RESULT>OTHERUSER</RESULT>");
			}
			else if(!staDTDraftDoc.equals(tempDocType)){
				rtnVal.append("<RESULT>NODOC</RESULT>");
			}
		}
		else{
			rtnVal.append("<RESULT>NOUSER</RESULT>");
		}
		if(rtnVal.toString().equals("")){
			map.put("v_DOCID", docID.trim());
			map.put("v_FLAG", "1");
			map.put("companyID", companyID);
			map.put("v_TENANTID", tenantID);

			int tempCount = ezApprovalGDAO.sendOfferCheck_EndReceipt(map);
			if(tempCount <= 0){
				rtnVal.append("<RESULT>NODEPT</RESULT>");
			}
		}
		if(rtnVal.toString().equals("")){
			map.put("v_FLAG", "2");
			int tempCount2 = ezApprovalGDAO.sendOfferCheck_EndReceipt(map);

			if(tempCount2 <= 0){
				rtnVal.append("<RESULT>NORECEIPT</RESULT>");
			}
		}
		if(rtnVal.toString().equals("")){
			rtnVal.append("<RESULT>TRUE</RESULT>");
		}
		
		return rtnVal.toString();
	}

	@Override
	public String GetRecordInfo(Document xmlDom, String lang, int tenantID)throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		try{

            String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
			String SepAttachNo =xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
			String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_RECORDID",RecID);
			map.put("v_SEPATTNO",SepAttachNo);
			map.put("companyID", companyID);
			map.put("v_LANGTYPE",lang);
			map.put("v_TENANTID",tenantID);

			List<ApprGRecordVO> docList = ezApprovalGDAO.getRecordInfo(map);
			
			StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < docList.size(); i++) {
				sb.append(commonUtil.getQueryResult(docList.get(i)));
			}
			sb.append("</DATA>");
			
			Document docXML = commonUtil.convertStringToDocument(sb.toString());
			
			if (docXML.getElementsByTagName("ROW").getLength() <= 0) {
				return "<RESULT>NORECORD</RESULT>";
			}
			System.out.println("-------------------"+docXML.getElementsByTagName("EXECUTEDATE").item(0).getTextContent());
			resultXML.append("<RECINFO>");
			resultXML.append("<BASICINFO>");
			resultXML.append("<RECORDID>" + makeListField(docXML.getElementsByTagName("RECORDID").item(0).getTextContent()) + "</RECORDID>");
			resultXML.append("<SEPATTACHNO>" + makeListField(docXML.getElementsByTagName("SEPERATEATTACHNO").item(0).getTextContent()) + "</SEPATTACHNO>");
			resultXML.append("<TITLE>" + makeListField(docXML.getElementsByTagName("RECTITLE").item(0).getTextContent()) + "</TITLE>");
			resultXML.append("<REGTYPE>" + getRegTypeString(makeListField(docXML.getElementsByTagName("REGISTERTYPE").item(0).getTextContent()),companyID, lang, tenantID) + "</REGTYPE>");
			resultXML.append("<DEPTCODE>" + makeListField(docXML.getElementsByTagName("RECDEPTCODE").item(0).getTextContent()) + "</DEPTCODE>");
			resultXML.append("<DEPTNAME>" + makeListField(docXML.getElementsByTagName("RECDEPTNAME").item(0).getTextContent()) + "</DEPTNAME>");
			
			resultXML.append("<REGNO>" + getRecRegSNToName(makeListField(docXML.getElementsByTagName("RECDEPTNAME").item(0).getTextContent()),makeListField(docXML.getElementsByTagName("RECREGSN").item(0).getTextContent())) + "</REGNO>");
			
			resultXML.append("<APRMEMBER>" + makeListField(docXML.getElementsByTagName("APRMEMBERTITLE").item(0).getTextContent()) + "</APRMEMBER>");
			resultXML.append("<DRAFTER>" + makeListField(docXML.getElementsByTagName("DRAFTERNAME").item(0).getTextContent()) + "</DRAFTER>");
			resultXML.append("<REGDATE>" + formatDateForView(makeListField(docXML.getElementsByTagName("REGISTERDATE").item(0).getTextContent()),0) + "</REGDATE>");
			resultXML.append("<SPECIALFLAG>" + makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent()) + "</SPECIALFLAG>");
			resultXML.append("</BASICINFO>");

			resultXML.append("<EXTRAINFO>");
			resultXML.append("<EXECUTEDATE>" + makeListField(docXML.getElementsByTagName("EXECUTEDATE").item(0).getTextContent()) + "</EXECUTEDATE>");
			resultXML.append("<RECEIPTMEMBER>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(0).getTextContent()) + "</RECEIPTMEMBER>");
			resultXML.append("<DELIVERYNO>" + makeListField(docXML.getElementsByTagName("DELIVERYNO").item(0).getTextContent()) + "</DELIVERYNO>");
			resultXML.append("<PRODUCEDEPTSN>" + makeListField(docXML.getElementsByTagName("PRODUCEDEPTREGNO").item(0).getTextContent()) + "</PRODUCEDEPTSN>");
			resultXML.append("<MODIFYFLAG>" + makeListField(docXML.getElementsByTagName("MODIFYFLAG").item(0).getTextContent()) + "</MODIFYFLAG>");
			resultXML.append("<REJECTFLAG>" + makeListField(docXML.getElementsByTagName("REJECTFLAG").item(0).getTextContent()) + "</REJECTFLAG>");
			resultXML.append("<ELECTRONICFLAG>" + makeListField(docXML.getElementsByTagName("ELECTRONICRECFLAG").item(0).getTextContent()) + "</ELECTRONICFLAG>");
			resultXML.append("<OLDFLAG>" + makeListField(docXML.getElementsByTagName("OLDRECORDFLAG").item(0).getTextContent()) + "</OLDFLAG>");
			resultXML.append("<OLDPRODUCEDEPT>" + makeListField(docXML.getElementsByTagName("CREATEORGANNAME").item(0).getTextContent()) + "</OLDPRODUCEDEPT>");
			resultXML.append("<OLDRECNO>" + makeListField(docXML.getElementsByTagName("RECORDNO").item(0).getTextContent()) + "</OLDRECNO>");
			
			resultXML.append("<OLDRECKP>" + makeListField(docXML.getElementsByTagName("RECKP").item(0).getTextContent()) + "</OLDRECKP>");
			resultXML.append("<AVSUMMARY>" +  makeListField(docXML.getElementsByTagName("SUMMARY").item(0).getTextContent()) + "</AVSUMMARY>");
			resultXML.append("<AVTYPE>" + getAVTypeString(makeListField(docXML.getElementsByTagName("RECORDTYPE").item(0).getTextContent()), companyID, lang, tenantID) + "</AVTYPE>");
			resultXML.append("<NUMOFPAGE>" +makeListField(docXML.getElementsByTagName("NUMOFPAGE").item(0).getTextContent()) + "</NUMOFPAGE>");
			resultXML.append("</EXTRAINFO>");
			resultXML.append("</RECINFO>");
		}catch(Exception e){
			e.printStackTrace();
		}
		return resultXML.toString();
	}

	@Override
	public String getRecViewer(Document xmlDom, String lang, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String SepAttachNo = xmlDom.getElementsByTagName("SEPATTNO").item(0).getTextContent().trim();
		String RecID = xmlDom.getElementsByTagName("RECID").item(0).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_RECORDID",RecID);
		map.put("v_SEPATTNO",SepAttachNo);
		map.put("v_TENANTID",tenantID);
		map.put("companyID", companyID);
		
		int getUserRight = ezApprovalGDAO.getUserRight(map);
		
		if (getUserRight <=0 ){
		    getUserRight = 0;	
		}
		
		 List<ApprGRecordVO> docList =ezApprovalGDAO.getRecViewer(map);  
		 
	     StringBuffer sb = new StringBuffer();
	     sb.append("<DATA>");
	        
	     for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		 }
			sb.append("</DATA>");
			
		 Document docXML = commonUtil.convertStringToDocument(sb.toString());
		 int dlength = docXML.getElementsByTagName("ROW").getLength();
		 resultXML.append("<ROLEINFO>");
		 resultXML.append("<ALLALLOWED>"+ getUserRight + "</ALLALLOWED>");
		 resultXML.append("<LISTVIEWDATA>");
		 resultXML.append("<HEADERS>");
		 resultXML.append("<HEADER>");
		 resultXML.append("<NAME>");
		 String name="";
		 String dept="";
		 String title="";
		 if(lang.equals("1")){
			 name="성명";
			 dept="부서";
			 title="직위";
		 }else{
			 name="NAME";
			 dept="Dept";
			 title="Title";
		 }
		 resultXML.append(name);
		 resultXML.append("</NAME>");
		 resultXML.append("<WIDTH>" + "70" + "</WIDTH>");
		 resultXML.append("</HEADER>");
		 resultXML.append("<HEADER>");
		 resultXML.append("<NAME>");
		 resultXML.append(dept);
		 resultXML.append("</NAME>");
		 resultXML.append("<WIDTH>" + "100" + "</WIDTH>");
		 resultXML.append("</HEADER>");
		 resultXML.append("<HEADER>");
		 resultXML.append("<NAME>");
		 resultXML.append(title);
		 resultXML.append("</NAME>");
		 resultXML.append("<WIDTH>" + "100" + "</WIDTH>");
		 resultXML.append("</HEADER>");
		 resultXML.append("</HEADERS>");
		 for (int j=0; j<dlength; j++){
			 resultXML.append("<ROWS>");
			 resultXML.append("<ROW>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("USERNAME"+commonUtil.getMultiData(lang, tenantID)).item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DEPTCODE").item(j).getTextContent()) + "</DATA1>");
			 resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("USERID").item(j).getTextContent()) + "</DATA2>");
			 resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("USERNAME").item(j).getTextContent()) + "</DATA3>");
			 resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("USERNAME2").item(j).getTextContent()) + "</DATA4>");
			 resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("USERTITLE").item(j).getTextContent()) + "</DATA5>");
			 resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("USERTITLE2").item(j).getTextContent()) + "</DATA6>");
			 resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("DEPTNAME").item(j).getTextContent()) + "</DATA7>");
			 resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("DEPTNAME2").item(j).getTextContent()) + "</DATA8>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("DEPTNAME" + commonUtil.getMultiData(lang, tenantID)).item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("USERTITLE" + commonUtil.getMultiData(lang, tenantID)).item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("</ROW>");
			 resultXML.append("</ROWS>");
			
		 }
		
		 
		 resultXML.append("</LISTVIEWDATA>");
		 resultXML.append("</ROLEINFO>");
			
		return resultXML.toString();
	}

	@Override
	public String saveRecUserRoleInfo(Document xmlDom, String lang, int tenantID) throws Exception {
			StringBuilder strSQL = new StringBuilder();
			String rtnVal = "<RESULT>TRUE</RESULT>";
		    String Flag	= "0";
			String SepAttachNo =xmlDom.getElementsByTagName("SEPATTNO").item(0).getTextContent().trim();
			String RecID = xmlDom.getElementsByTagName("RECID").item(0).getTextContent().trim();
			String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
			strSQL.append("Delete TBL_RECROLEINFO WHERE RecordID = '" + RecID);
            strSQL.append("' And SeperateAttachNo = '" + SepAttachNo + "' AND TENANT_ID = "+ tenantID + ";\n");
			if(Flag.equals("0")){
				 strSQL.append("Insert Into TBL_RECROLEINFO (RecordID, SeperateAttachNo, UserID, ");
                 strSQL.append("UserRight, UserName, UserName2, TENANT_ID) Values ('"+RecID + "', '");
				 strSQL.append(SepAttachNo + "', 'All_User', 1, '모든 이용자', 'All User', "+ tenantID +") ;\n");
			}else{
				strSQL.append("Insert Into TBL_RECROLEINFO (RecordID, SeperateAttachNo, UserID, ");
                strSQL.append("UserRight, UserName, UserName2) Values ('" + RecID + "', '");
				strSQL.append(SepAttachNo + "', 'All_User', 0, '모든 이용자', 'All User');\n");
			}
			for( int i=0; i<xmlDom.getElementsByTagName("USER").getLength(); i++){
				strSQL.append("Insert Into TBL_RECROLEINFO (RecordID, SeperateAttachNo, ");
                strSQL.append("UserID, UserRight, UserName, UserName2, UserTitle, UserTitle2, DeptCode, DeptName, DeptName2, TENANT_ID) Values ('");
				strSQL.append(RecID + "', '" + SepAttachNo + "', '");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("ID").item(i).getTextContent()) + "', 1, '");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("NAME").item(i).getTextContent())+ "', '");
                strSQL.append(makeRightField(xmlDom.getElementsByTagName("NAME2").item(i).getTextContent())+ "', '");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("TITLE").item(i).getTextContent()) + "', '");
                strSQL.append(makeRightField(xmlDom.getElementsByTagName("TITLE2").item(i).getTextContent()) + "', '");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("DEPTCODE").item(i).getTextContent().trim()) + "', '");
                strSQL.append(makeRightField(xmlDom.getElementsByTagName("DEPTNAME").item(i).getTextContent()) + "', '");
                strSQL.append(makeRightField(xmlDom.getElementsByTagName("DEPTNAME2").item(i).getTextContent())  + "'," + tenantID +");\n");
			}
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			
			try {
				ezApprovalGDAO.transactionSQL(map);
				
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		return rtnVal;
	}

	@Override
	public String getRecReadHistory(Document xmlDom, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String lang = xmlDom.getElementsByTagName("LANGTYPE").item(0).getTextContent().trim();
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent().trim();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_TENANTID", tenantID);
		
		 List<ApprGHistoryDocVO> docList =ezApprovalGDAO.getRecReadHistory(map); 
		 StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < docList.size(); i++) {
				sb.append(commonUtil.getQueryResult(docList.get(i)));
			}
			sb.append("</DATA>");
		 Document docXML = commonUtil.convertStringToDocument(sb.toString());
		 String listHeader = getListHeader("104", companyID, lang, tenantID);
		 Document listXML = commonUtil.convertStringToDocument(listHeader);
		 resultXML.append("<LISTVIEWDATA>");
		 resultXML.append("<HEADERS>");
		 int hlength = listXML.getElementsByTagName("NAME").getLength();
		 for ( int i = 0; i < hlength; i++){
			 resultXML.append("<HEADER>");
			 resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(i).getTextContent() +"</NAME>");
			 resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(i).getTextContent() +"</WIDTH>");
			 resultXML.append("</HEADER>");
		 }
		 resultXML.append("</HEADERS>");
		 resultXML.append("<ROWS>");
		 int dlength = docXML.getElementsByTagName("ROW").getLength();
		 for(int j=0; j<dlength; j++){
			 resultXML.append("<ROW>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(convertDate(docXML.getElementsByTagName("READDATE").item(j).getTextContent())) + "</VALUE>");
			 resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("DOCID").item(j).getTextContent())+ "</DATA1>");
			 resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("USERID").item(j).getTextContent())+ "</DATA2>");
			 resultXML.append("</CELL>");  
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("USERNAME" + commonUtil.getMultiData(lang, tenantID)).item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("DEPTNAME" + commonUtil.getMultiData(lang, tenantID)).item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("USERTITLE" + commonUtil.getMultiData(lang, tenantID)).item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("</ROW>");
		 }
		 resultXML.append("</ROWS>");
		
		 resultXML.append("</LISTVIEWDATA>");
		 
		return resultXML.toString();
	}

	@Override
	public String getRecordClassInfo(Document xmlDom, int tenantID) throws Exception {
		try{
		StringBuilder resultXML = new StringBuilder();
		String rtnVal = "<RESULT>NORECORD</RESULT>";
		String SepAttachNo = xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
		String lang = xmlDom.getElementsByTagName("STRLANG").item(0).getTextContent().trim();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RECORDID", RecID);
		map.put("v_SEPATTNO", SepAttachNo);
		map.put("v_TENANTID", tenantID);
		
		 List<ApprGCabinetVO> docList =ezApprovalGDAO.getRecordClassInfo(map);
	     StringBuffer sb = new StringBuffer();
	     sb.append("<DATA>");
	        
	     for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		 }
			sb.append("</DATA>");
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		if(docXML.getElementsByTagName("ROW").getLength() <=0 ){
			 return rtnVal;
		 }
		resultXML.append("<RECINFO>");
		resultXML.append("<CLASSINFO>");
		resultXML.append("<CABCLASSID>" + getCabinetNo(makeListField(docXML.getElementsByTagName("CABDEPTCODE").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("TASKCODE").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent())) + "</CABCLASSID>");
		resultXML.append("<CABTITLE>" + makeListField(docXML.getElementsByTagName("CABTITLE").item(0).getTextContent()) + "</CABTITLE>");
		resultXML.append("<SPECIALRECCODE>" + getSpecialRecString(makeListField(docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent()), companyID, lang, tenantID) + "</SPECIALRECCODE>");
		resultXML.append("<PUBLICCODE>" + getPublicCodeString((docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent()), companyID, lang, tenantID) + "</PUBLICCODE>");
		resultXML.append("<LIMITRANGE>" + makeListField(docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent()) + "</LIMITRANGE>");
		resultXML.append("<CONFIRMFLAG>" + makeListField(docXML.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent()) + "</CONFIRMFLAG>");
		resultXML.append("<CATATRANSFLAG>" + makeListField(docXML.getElementsByTagName("CATALOGTRANSFERFLAG").item(0).getTextContent()) + "</CATATRANSFLAG>");
		resultXML.append("<CATATRANSYEAR>" + makeListField(docXML.getElementsByTagName("CATALOGTRANSFERYEAR").item(0).getTextContent()) + "</CATATRANSYEAR>");
		resultXML.append("<DOCTRANSFLAG>" + makeListField(docXML.getElementsByTagName("DOCTRANSFERFLAG").item(0).getTextContent()) + "</DOCTRANSFLAG>");
		resultXML.append("<DOCTRANSYEAR>" + makeListField(docXML.getElementsByTagName("DOCTRANSFERYEAR").item(0).getTextContent()) + "</DOCTRANSYEAR>");
		resultXML.append("</CLASSINFO>");
		resultXML.append("</RECINFO>");
		
		return resultXML.toString();
		}
		catch(Exception e){
			return "<RESULT>NORECORD</RESULT>";
		}
	}
	public String getAprDocList (String pListType, String userID, String userDeptID, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String pSubQuery, String strLang, int tenantID, String offset) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		String orderOption1 = "";
		String orderOption2 = "";
		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = getIsUse("A23", "001", companyID, strLang, tenantID);
		
		if (proxyOption.equals("1")) {
			userIDs = getProxyUser(userID, strLang, tenantID, offset);
		}
		
		resultXML.append("<DOCLIST>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<ROWS>");
		
		if (pListType.equals("1")) {
			resultXML.append("<TOTALCNT1>" + getAprPortletDocCount("1", userDeptID, userID, userIDs, "", pSubQuery, companyID, tenantID) + "</TOTALCNT1>");
			resultXML.append("<TOTALCNT2>" + getAprPortletDocCount("2", userDeptID, userID, userIDs, "", pSubQuery, companyID, tenantID) + "</TOTALCNT2>");
			resultXML.append("<TOTALCNT3>" + getAprPortletDocCount("4", userDeptID, userID, userIDs, "", pSubQuery, companyID, tenantID) + "</TOTALCNT3>");
		}
		
		int totalCount = getAprPortletDocCount(pListType, userDeptID, userID, userIDs, "", pSubQuery, companyID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		int pQuerySizeMain = totalCount - (Integer.parseInt(pageSize) * (Integer.parseInt(pageNum) -1));
		String pOrderBySub = orderOption1.trim();
		String pOrderByMain = orderOption2.trim();
		
		if (pQuerySizeMain >= Integer.parseInt(pageSize)) {
			pQuerySizeMain = Integer.parseInt(pageSize);
		} 
		
		if (pOrderBySub.equals("functiontypename")) {
			pOrderBySub = "functiontype";
		} else if (pOrderBySub.equals("functiontypename desc")) {
			pOrderBySub = "functiontype desc";
		}
		
		if (pOrderBySub.length() > 0) {
			if (pOrderBySub.length() >= 9) {
				if (pOrderBySub.substring(0, 9).toLowerCase().equals("STARTDATE")) {
					pOrderBySub = "ORDER BY RTRIM(LTRIM(" + pOrderBySub + "))";
				} else {
					pOrderBySub =  "ORDER BY "+ pOrderBySub.trim() +", A.STARTDATE DESC";
				}
			} else {
				pOrderBySub= "ORDER BY "+ pOrderBySub.trim() +", A.STARTDATE DESC";  
			}
		} else {
			pOrderBySub= "ORDER BY A.STARTDATE DESC";   
		}
				
		if (pOrderByMain.equals("functiontypename")) {
			pOrderByMain = "functiontype";
		} else if (pOrderByMain.equals("functiontypename desc")) {
			pOrderByMain = "functiontype desc";
		}
		
		if (pOrderByMain.length() > 0) {
			if (pOrderByMain.length() >= 9) {
				if (pOrderByMain.substring(0, 9).toLowerCase().equals("STARTDATE")) {
					pOrderByMain = "ORDER BY RTRIM(LTRIM(" + pOrderByMain + "))";
				} else {
					pOrderByMain =  "ORDER BY "+ pOrderByMain.trim() +", A.STARTDATE";
				}
			} else {
				pOrderByMain= "ORDER BY "+ pOrderBySub.trim() +", A.STARTDATE ";  
			}
		} else {
			pOrderByMain= "ORDER BY A.STARTDATE";   
		}
				
		map.put("v_PLISTTYPE", pListType.trim());
		map.put("v_PUSERDEPTID", userDeptID.trim());
		map.put("v_PUSERID", userID.trim());
		map.put("v_PUSERIDS", userIDs.trim());
		map.put("v_PLISTCOUNT", Integer.parseInt(pageSize));
		map.put("v_PPAGECOUNT", Integer.parseInt(pageNum));
		map.put("v_PTOTALCOUNT", totalCount);
		map.put("v_PORDERBYSUB", pOrderBySub);
		map.put("v_PORDERBYMAIN", pOrderByMain);
		map.put("v_PORDERBYMAINLENGHT", pOrderByMain.length());
		map.put("v_PSUBQUERY", pSubQuery.trim());
		map.put("v_PQUERYSIZESUB", Integer.parseInt(pageSize) * Integer.parseInt(pageNum));
		map.put("v_PQUERYSIZEMAIN", pQuerySizeMain);
		map.put("v_PSUBQUERYLENGHT", pSubQuery.trim().length());
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		List<ApprGDocListVO> docList = ezApprovalGDAO.getAprPortletDocList(map);
		
		int dLength = docList.size();
		if (!pListType.equals("") && dLength > 7) {
			dLength = 7;
		}
		
		resultXML.append("<ROW>");
		int docCnt = 0, sixHgap = 0, oneDgap = 0, sevenDgap = 0, oneMgap = 0, other = 0;
		for (int j=dLength-1; j>=0; j--) {
			docCnt += 1;
			if (docCnt <= 7) {
				resultXML.append("<CELL>");
				resultXML.append("<DOCTITLE>"+docList.get(j).getDocTitle()+"</DOCTITLE>");
				resultXML.append("<WRITERNAME>"+docList.get(j).getWriterName()+"</WRITERNAME>");
				resultXML.append("<STARTDATE>"+docList.get(j).getStartDate()+"</STARTDATE>");
				resultXML.append("<DOCID>"+docList.get(j).getDocID()+"</DOCID>");
				resultXML.append("<HREF>"+docList.get(j).getHref()+"</HREF>");
				resultXML.append("<APRMEMBERID>"+docList.get(j).getAprMemberID()+"</APRMEMBERID>");
				resultXML.append("<APRMEMBERNAME>"+docList.get(j).getAprMemberName()+"</APRMEMBERNAME>");
				resultXML.append("<APRMEMBERDEPTID>"+docList.get(j).getAprMemberDeptID()+"</APRMEMBERDEPTID>");
				resultXML.append("<DOCSTATE>"+docList.get(j).getDocState()+"</DOCSTATE>");
				resultXML.append("<FUNCTIONTYPE>"+docList.get(j).getFunctionType()+"</FUNCTIONTYPE>");
				resultXML.append("</CELL>");
			}
			
			if (pListType.equals("1")) {
				String pReceivedDate = docList.get(j).getReceivedDate();
				if (pReceivedDate == null || pReceivedDate.equals("")) {
					pReceivedDate = docList.get(j).getStartDate();
				}

				// hourGap
				SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				String now = date.format(new Date());
				
				Date nowDate = date.parse(now);
				Date endDate = date.parse(pReceivedDate);
				
				long diff = nowDate.getTime() - endDate.getTime();
				
				// 시간단위로 현재시간 - 받은시간
				long hourGap = diff / (60 * 60 * 1000);

				if (hourGap <= 6) {
					sixHgap += 1;
				} else if (hourGap <= 24) {
					oneDgap += 1;
				} else if(hourGap <= 168) {
					sevenDgap += 1;
				} else if (hourGap <= 720) {
					oneMgap += 1;
				} else {
					other += 1;
				}
			}
		}
		resultXML.append("</ROW>");
		if (pListType.equals("1")) {
			resultXML.append("<SIXHGAP>"+sixHgap+"</SIXHGAP>");
			resultXML.append("<ONEDGAP>"+oneDgap+"</ONEDGAP>");
			resultXML.append("<SEVENDGAP>"+sevenDgap+"</SEVENDGAP>");
			resultXML.append("<ONEMGAP>"+oneMgap+"</ONEMGAP>");
			resultXML.append("<OTHER>"+other+"</OTHER>");
		}
		
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		return resultXML.toString();
	}
	
	private int getAprPortletDocCount (String pListType, String pUserDeptID, String pUserID, String pUserIDs, String pUserFlag, String pSubQuery, String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PLISTTYPE", pListType);
		map.put("v_PUSERDEPTID", pUserDeptID);
		map.put("v_PUSERID", pUserID);
		map.put("v_PUSERIDS", pUserIDs);
		map.put("v_PUSERFLAG", pUserFlag);
		map.put("v_PSUBQUERYLENGHT", pSubQuery.length());
		map.put("v_PSUBQUERY", pSubQuery);
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		
		int rtnValue = ezApprovalGDAO.getAprPortletDocCount(map);
		
		return rtnValue;
	}

	@Override
	public String getRecordHistory(Document xmlDom, LoginVO userInfo) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String SepAttachNo = xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
		String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		
		if(userInfo.getPrimary().equals("1")){
			userInfo.setPrimary("");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RECORDID", RecID);
		map.put("v_SEPATTNO", SepAttachNo);
		map.put("v_TENANTID", userInfo.getTenantId());
		List<ApprGRecordVO> docList =ezApprovalGDAO.getRecordHistory(map);
		 StringBuffer sb = new StringBuffer();
	     sb.append("<DATA>");
	        
	     for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		 }
			sb.append("</DATA>");
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
	
		 resultXML.append("<LISTVIEWDATA>");
		 resultXML.append("<HEADERS>");
		 String listHeader = getListHeader("103", companyID, userInfo.getLang(), userInfo.getTenantId());
		 Document listXML = commonUtil.convertStringToDocument(listHeader);
		 for ( int i=0; i<listXML.getElementsByTagName("NAME").getLength(); i++){
			 resultXML.append("<HEADER>");
			 resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(i).getTextContent() +"</NAME>");
			 resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(i).getTextContent() +"</WIDTH>");
			 resultXML.append("</HEADER>");
		 }
		 resultXML.append("</HEADERS>");
		 resultXML.append("<ROWS>");
		 
		 for (int j=0; j<docXML.getElementsByTagName("ROW").getLength(); j++){
			 resultXML.append("<ROW>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("VERSION").item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("RECORDID").item(j).getTextContent()) + "</DATA1>");
			 resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("SEPERATEATTACHNO").item(j).getTextContent()) + "</DATA2>");
			 resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("MODIFYREASON").item(j).getTextContent()) + "</DATA3>");
			 resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("VERSION").item(j).getTextContent()) + "</DATA4>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TITLE").item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + formatDateForView(makeListField(docXML.getElementsByTagName("REGISTERDATE").item(j).getTextContent()),1) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("NUMOFPAGE").item(j).getTextContent()) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("APRMEMBERTITLE"+ userInfo.getPrimary()).item(j).getTextContent() ) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("DRAFTER"+ userInfo.getPrimary()).item(j).getTextContent() ) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + formatDateForView(makeListField(docXML.getElementsByTagName("EXECUTEDATE").item(j).getTextContent()),1) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME"+ userInfo.getPrimary()).item(j).getTextContent() ) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 if( makeListField(docXML.getElementsByTagName("MODIFYFLAG").item(j).getTextContent()).equals("0")){
				 resultXML.append("<VALUE>" + "t1783" + "</VALUE>");
			 }
			 else if(makeListField(docXML.getElementsByTagName("MODIFYFLAG").item(j).getTextContent()).equals("")){
				 resultXML.append("<VALUE>" + "" + "</VALUE>");
			 }else{
				 resultXML.append("<VALUE>" + "t1784" + "</VALUE>");
			 }
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MODIFIERNAME"+ userInfo.getPrimary()).item(j).getTextContent() ) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("<CELL>");
			 resultXML.append("<VALUE>" + formatDateForView(makeListField(docXML.getElementsByTagName("MODIFYDATE").item(j).getTextContent()),1) + "</VALUE>");
			 resultXML.append("</CELL>");
			 resultXML.append("</ROW>");
		 }
		 resultXML.append("</ROWS>");
		 resultXML.append("</LISTVIEWDATA>");
		return resultXML.toString();
	}

	@Override
	public String moveRecord(Document xmlDom, String lang) throws Exception {
		String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
		String SepAttachNo = xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
		String NewCabID = xmlDom.getElementsByTagName("NEWCABID").item(0).getTextContent().trim();
		String Flag = xmlDom.getElementsByTagName("FLAG").item(0).getTextContent().trim();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String rtnVal="";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RECORDID", RecID);
		map.put("v_SEPATTNO", SepAttachNo);
		map.put("v_CABINETID", NewCabID);
		map.put("v_FLAG", Flag);
		try {
		 ezApprovalGDAO.moveRecord(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			e.getStackTrace();
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String getRecordSimpleInfo(Document xmlDom , String lang, int tenantID) throws Exception {
		StringBuilder resultXML = new StringBuilder();

		String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
		String SepAttachNo = xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RECORDID", RecID);
		map.put("v_SEPATTNO", SepAttachNo);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGRecordVO> docList =ezApprovalGDAO.getRecordSimpleInfo(map);
		 StringBuffer sb = new StringBuffer();
	     sb.append("<DATA>");
	        
	     for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		 }
			sb.append("</DATA>");
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if(docXML.getElementsByTagName("ROW").getLength()<=0){
			return "<RESULT>NORECORD</RESULT>";
		}
		resultXML.append("<RESULT>");
		resultXML.append("<RECORDID>" + makeListField(docXML.getElementsByTagName("RECORDID").item(0).getTextContent()) + "</RECORDID>");
		resultXML.append("<TITLE>"  + makeListField(docXML.getElementsByTagName("TITLE").item(0).getTextContent()) + "</TITLE>");
		resultXML.append("<NUMOFPAGE>" + makeListField(docXML.getElementsByTagName("NUMOFPAGE").item(0).getTextContent()) + "</NUMOFPAGE>");
		resultXML.append("<REGISTERTYPE>" + makeListField(docXML.getElementsByTagName("REGISTERTYPE").item(0).getTextContent()) + "</REGISTERTYPE>");
		resultXML.append("<REGISTERDATE>" + formatDateForView(makeListField(docXML.getElementsByTagName("REGISTERDATE").item(0).getTextContent()),1) + "</REGISTERDATE>");
		resultXML.append("<REGISTERDATERAW>" + formatDateForView(makeListField(docXML.getElementsByTagName("REGISTERDATE").item(0).getTextContent()),0) + "</REGISTERDATERAW>");
		resultXML.append("<APRMEMBER>" + makeListField(docXML.getElementsByTagName("APRMEMBERTITLE").item(0).getTextContent()) + "</APRMEMBER>");
		resultXML.append("<DRAFTER>" + makeListField(docXML.getElementsByTagName("DRAFTERNAME").item(0).getTextContent()) + "</DRAFTER>");
		resultXML.append("<EXECUTEDATE>" + formatDateForTrans(makeListField(docXML.getElementsByTagName("EXECUTEDATE").item(0).getTextContent()),0) + "</EXECUTEDATE>");
		resultXML.append("<RECEIPTMEMBER>" + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(0).getTextContent()) + "</RECEIPTMEMBER>");
		resultXML.append("<ELECTRONICRECFLAG>" + makeListField(docXML.getElementsByTagName("ELECTRONICRECFLAG").item(0).getTextContent()) + "</ELECTRONICRECFLAG>");
		resultXML.append("<SPECIALRECCODE>" + makeListField(docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent()) + "</SPECIALRECCODE>");
		resultXML.append("<PUBLICCODE>" + makeListField(docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent()) + "</PUBLICCODE>");
		resultXML.append("<LIMITRANGE>" + makeListField(docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent()) + "</LIMITRANGE>");
		resultXML.append("<MANUALREGFLAG>" + makeListField(docXML.getElementsByTagName("MANUALREGFLAG").item(0).getTextContent()) + "</MANUALREGFLAG>");
		resultXML.append("<SEPATTACHNO>" + makeListField(docXML.getElementsByTagName("SEPERATEATTACHNO").item(0).getTextContent()) + "</SEPATTACHNO>");
		String SCFlag =makeListField(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent());
		resultXML.append("<SPECIALFLAG>" + SCFlag + "</SPECIALFLAG>");
		resultXML.append("<SCINFO>");
		
		if(SCFlag.equals("2")){
		List<ApprGCabinetVO> docList2 =ezApprovalGDAO.getRecScInfo(map);
		
		 StringBuffer sb2 = new StringBuffer();
	     sb2.append("<DATA>");
	        
	     for (int i = 0; i < docList2.size(); i++) {
			sb2.append(commonUtil.getQueryResult(docList2.get(i)));
		 }
			sb2.append("</DATA>");
		Document docXML2 = commonUtil.convertStringToDocument(sb2.toString());
		
		if(docXML2.getElementsByTagName("ROW").getLength()<=0){
			return "<RESULT>FALSE</RESULT>";
		}
		
		
		
		
		for (int k=0; k<docXML2.getElementsByTagName("ROW").getLength(); k++){
			String SepAttSN = makeListField(docXML2.getElementsByTagName("SERIALNO").item(k).getTextContent().trim());
		
			if(SepAttSN.equals("000")){
				resultXML.append("<NAME>");
				resultXML.append("<SN>" + SepAttSN + "</SN>");
				resultXML.append("<LIST1>" + makeListField(docXML2.getElementsByTagName("SC1").item(k).getTextContent()) + "</LIST1>");
				resultXML.append("<LIST2>" + makeListField(docXML2.getElementsByTagName("SC2").item(k).getTextContent()) + "</LIST2>");
				resultXML.append("<LIST3>" + makeListField(docXML2.getElementsByTagName("SC3").item(k).getTextContent()) + "</LIST3>");
				resultXML.append("</NAME>");
			}
			else{
				resultXML.append("<DATALIST>");
				resultXML.append("<DATA>");
				resultXML.append("<SN>" + SepAttSN + "</SN>");
				resultXML.append("<LIST1>" + makeListField(docXML2.getElementsByTagName("SC1").item(k).getTextContent()) + "</LIST1>");
				resultXML.append("<LIST2>" + makeListField(docXML2.getElementsByTagName("SC2").item(k).getTextContent()) + "</LIST2>");
				resultXML.append("<LIST3>" + makeListField(docXML2.getElementsByTagName("SC3").item(k).getTextContent()) + "</LIST3>");
				resultXML.append("</DATA>");
				resultXML.append("</DATALIST>");
			}
		}
		}
		resultXML.append("<APRMEMBER2>"  + makeListField(docXML.getElementsByTagName("APRMEMBERTITLE2").item(0).getTextContent()) + "</APRMEMBER2>" );
		resultXML.append("<DRAFTER2>"  + makeListField(docXML.getElementsByTagName("DRAFTERNAME2").item(0).getTextContent()) + "</DRAFTER2>" );
		resultXML.append("<RECEIPTMEMBER2>"  + makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME2").item(0).getTextContent()) + "</RECEIPTMEMBER2>" );
		resultXML.append("</SCINFO>");                                                          
		resultXML.append("</RESULT>");
		
		return resultXML.toString();
	}

	@Override
	public String changeRecordInfo(Document xmlDom, String lang, int tenantID) throws Exception {
		String pChangeType = xmlDom.getElementsByTagName("MODIFYFLAG").item(0).getTextContent().trim();
		StringBuilder strSQL = new StringBuilder("");
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		if(pChangeType.equals("0")){
			try{
				String RecType = xmlDom.getElementsByTagName("RECORDTYPE").item(0).getTextContent().trim();
				String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
				String SepAttNo = xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
				String UserID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
				String UserName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent().trim();
				String UserName2 = xmlDom.getElementsByTagName("USERNAME2").item(0).getTextContent().trim();
				String Title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent().trim();
				String RegDate = xmlDom.getElementsByTagName("REGISTERDATE").item(0).getTextContent().trim();
				String NumOfPage = xmlDom.getElementsByTagName("NUMOFPAGE").item(0).getTextContent().trim();
				String AprMember = xmlDom.getElementsByTagName("APRMEMBER").item(0).getTextContent().trim();
				String AprMember2 = xmlDom.getElementsByTagName("APRMEMBER2").item(0).getTextContent().trim();
				String Drafter = xmlDom.getElementsByTagName("DRAFTER").item(0).getTextContent().trim();
				String Drafter2 = xmlDom.getElementsByTagName("DRAFTER2").item(0).getTextContent().trim();
				String ExeDate = xmlDom.getElementsByTagName("EXECUTEDATE").item(0).getTextContent().trim();
				String ReceiptMember = xmlDom.getElementsByTagName("RECEIPTMEMBER").item(0).getTextContent().trim();
				String ReceiptMember2 = xmlDom.getElementsByTagName("RECEIPTMEMBER2").item(0).getTextContent().trim();
				String SendingMember = xmlDom.getElementsByTagName("SENDINGMEMBER").item(0).getTextContent().trim();
				String SendingMember2 = xmlDom.getElementsByTagName("SENDINGMEMBER2").item(0).getTextContent().trim();
				String ElecFlag = xmlDom.getElementsByTagName("ELECTRONICFLAG").item(0).getTextContent().trim();
				String ChangeReason = xmlDom.getElementsByTagName("CHANGEREASON").item(0).getTextContent().trim();
				
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("companyID", companyID);
				map.put("v_RECORDID", RecID);
				map.put("v_SEPATTNO", SepAttNo);
				map.put("v_RECTYPE", RecType);
				map.put("v_NUMOFPAGE", NumOfPage);
				map.put("v_TITLE", Title);
				map.put("v_REGDATE", RegDate);
				map.put("v_APRMEMTITLE", AprMember);
				map.put("v_APRMEMTITLE2", AprMember2);
				map.put("v_DRAFTER", Drafter);
				map.put("v_DRAFTER2", Drafter2);
				map.put("v_EXEDATE", ExeDate);
				map.put("v_RECEIPTMEM", ReceiptMember);
				map.put("v_RECEIPTMEM2", ReceiptMember2);
				map.put("v_ELECFLAG", ElecFlag);
				map.put("v_CHANGEREASON", ChangeReason);
				map.put("v_USERID", UserID);
				map.put("v_USERNAME", UserName);
				map.put("v_USERNAME2", UserName2);
				map.put("v_TENANTID", tenantID);
				map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
				map.put("v_DATE", commonUtil.getTodayUTCTime("").substring(0, 10).replace("-", ""));
				int newVersion = ezApprovalGDAO.newRecordVersion(map);
				
				if( newVersion < 2) {
					map.put("v_newVersion", newVersion);
					ezApprovalGDAO.insertRecordHistory(map);
				}
					ezApprovalGDAO.changeRecordInfo(map);
					
					if(RecType.equals("1")) {
						ezApprovalGDAO.changeRecordInfo2(map);
				}
					newVersion = ezApprovalGDAO.newRecordVersion(map);
					map.put("v_newVersion", newVersion);
					ezApprovalGDAO.insertRecordHistory2(map);

			}
			catch(Exception e){
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				return  "<RESULT>FALSE</RESULT>";
			}
			return "<RESULT>TRUE</RESULT>";
		}
		else{
			try{
			String RecType = xmlDom.getElementsByTagName("RECORDTYPE").item(0).getTextContent().trim();
			String RecID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
			String SepAttNo = xmlDom.getElementsByTagName("SEPATTACHNO").item(0).getTextContent().trim();
			String UserID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
			String UserName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent().trim();
			String UserName2 = xmlDom.getElementsByTagName("USERNAME2").item(0).getTextContent().trim();
			String SpecialRec = xmlDom.getElementsByTagName("SPECIALRECCODE").item(0).getTextContent().trim();
			String PubCode = xmlDom.getElementsByTagName("PUBLICCODE").item(0).getTextContent().trim();
			String LimitRange = xmlDom.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();
			String ChangeReason = xmlDom.getElementsByTagName("CHANGEREASON").item(0).getTextContent().trim();
			String SCFlag = xmlDom.getElementsByTagName("SCFLAG").item(0).getTextContent().trim();
			
			NodeList nodeSC = xmlDom.getElementsByTagName("SCINFO");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_RECORDID", RecID);
			map.put("v_SEPATTNO", SepAttNo);
			map.put("v_TENANTID", tenantID);
			map.put("v_LIMITRANGE", LimitRange);
			map.put("v_PUBCODE", PubCode);
			map.put("v_SPECIALREC", SpecialRec);

			int historyCnt = ezApprovalGDAO.selectHistoryCnt(map);
			
			if(historyCnt < 2) {
				map.put("v_HISTORYCNT", historyCnt);
				ezApprovalGDAO.insertHistory(map);
			}
            
			// '분리첨부 테이블의 ModifyFlag를 1로 설정
			ezApprovalGDAO.updateModifyFlag(map);
           
			//    '## 기록물 테이블을 업데이트 한다.
			//    '## RecType
			//    '0:전자결재문서- 모든 분류등록항목 수정가능
			//    '1:수기등록문서- 모든 분류등록항목 수정가능
			//    '2:분리첨부- 분류등록 항목은 수정 불가

			ezApprovalGDAO.updateTbRecord(map);	
			ezApprovalGDAO.updateTbExpendAprDocInfo(map);	
			
			historyCnt = ezApprovalGDAO.selectHistoryCnt(map);
			
			map.put("v_HISTORYCNT", historyCnt);
			map.put("v_CHANGEREASON", ChangeReason);
			map.put("v_USERID", UserID);
			map.put("v_USERNAME", UserName);
			map.put("v_USERNAME2", UserName2);
			map.put("v_SYSDATE", commonUtil.getTodayUTCTime("yyyyMMdd"));
			
			ezApprovalGDAO.insertHistory2(map);

			if(SCFlag.equals("2")){
				String result= ChangeSpecialInfo_Rec(RecID,xmlDom, tenantID);
			
				if (result == "FALSE"){
					 return "<RESULT>FALSE</RESULT>";
			    }
			}
			return "<RESULT>TRUE</RESULT>";
			
			}catch(Exception e){
				TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
				System.out.println(e.getMessage());
				 return "<RESULT>FALSE</RESULT>";
			}
		}
	}

	private Boolean ExecuteTransactionSQL(StringBuilder strSQL, String companyID) {
		StringBuilder pSQL = new StringBuilder("");
		try
		{
            pSQL.append("BEGIN DECLARE CNT Number := 0; BEGIN  BEGIN " + strSQL + " EXCEPTION WHEN OTHERS THEN CNT := SQLCODE; END; IF CNT <> 0 THEN BEGIN ROLLBACK;  END; ELSE BEGIN COMMIT; END; END IF; CNT :=0; END; END;");
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString",pSQL.toString());
			map.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map);
			
			return true;
		}
		catch (Exception e)
		{
			System.out.println(e.getMessage());
			return false;
		}
	}

	private String ChangeSpecialInfo_Rec(String RecID, Document xmlDom, int tenantID) {
		try{
			StringBuilder subSQL = new StringBuilder();
			String result ="TURE";
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_RECID", RecID);
			map.put("v_TENANTID", tenantID);

			ezApprovalGDAO.deleteTbSpecialCatalogInfo(map);
			if(xmlDom.getElementsByTagName("SCDATA").getLength() >0){
				for(int i=0; i<xmlDom.getElementsByTagName("SCDATA").getLength(); i++){
					subSQL.append("INSERT INTO TBL_SPECIALCATALOGINFO_REC (RECORDID, SERIALNO, SC1, SC2, SC3, TENANT_ID) VALUES ('");
					subSQL.append(makeRightField(RecID) + "', '");
					subSQL.append(makeRightField(xmlDom.getElementsByTagName("SN").item(0).getTextContent().trim()) + "', '");
					subSQL.append(makeRightField(xmlDom.getElementsByTagName("LIST1").item(0).getTextContent().trim()) + "', '");
					subSQL.append(makeRightField(xmlDom.getElementsByTagName("LIST2").item(0).getTextContent().trim()) + "', '");
					subSQL.append(makeRightField(xmlDom.getElementsByTagName("LIST3").item(0).getTextContent().trim()) + "'," + tenantID +")\n");
					map.put("sqlString", subSQL.toString());
					ezApprovalGDAO.insertTbSpecialCatalogInfoRec(map);
				}
			}
			return result;
			}
			catch(Exception e){
				return "FALSE";
			}
	}
	
	@Override
	public String getDeliveryList(String p_DeptID, String pageSize, String pageNum, String SortHeader, String SortOption, String pQuery, String companyID, String lang, String deptcode, String deptcode2, String title, String sregdate, String eregdate, String debenturer, String isdocprint, int tenantID, String offset) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String OrderOption1 = "";
		String OrderOption2 = "";
		
		String listString = getListHeader("067", companyID, lang, tenantID);
		Document listXML = commonUtil.convertStringToDocument(listString);
		
 		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTID", p_DeptID);
		map.put("v_SUBQUERY", pQuery);
		map.put("v_MANAGEDEPTID", deptcode);
		map.put("v_ORGANID", deptcode2);
		map.put("v_DOCTITLE", title);
		map.put("v_CHARGENAME", debenturer);
		map.put("v_SREGDATE", sregdate);
		map.put("v_EREGDATE", eregdate);
		map.put("v_TENANTID", tenantID);
		
		int totalCount = ezApprovalGDAO.getDeliveryListCount(map);
        int querySize = Integer.parseInt(pageSize) * Integer.parseInt(pageNum);
        int querySize2 = totalCount - Integer.parseInt(pageSize) * (Integer.parseInt(pageNum)-1);
		
        if(querySize2 >= Integer.parseInt(pageSize)){
        	querySize2 = Integer.parseInt(pageSize);
        }
        
		resultXML.append("<DOCLIST>");
		resultXML.append("<TOTALDOCCOUNT>" + totalCount + "</TOTALDOCCOUNT>");
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		
		
		int i=0;
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		
		for(i=0; i<hlength; i++){
			resultXML.append("<HEADER>");
			resultXML.append("<NAME>" + listXML.getElementsByTagName("NAME").item(i).getTextContent() + "</NAME>");
			resultXML.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(i).getTextContent() + "</WIDTH>");
			resultXML.append("<COLNAME>" + listXML.getElementsByTagName("COLNAME").item(i).getTextContent() + "</COLNAME>");
			
			if(!SortHeader.equals("") && SortHeader.equals(listXML.getElementsByTagName("NAME").item(i).getTextContent())){
				if(SortOption.equals("")){
					OrderOption1 = listXML.getElementsByTagName("COLNAME").item(i).getTextContent() +" ";
					OrderOption2 = listXML.getElementsByTagName("COLNAME").item(i).getTextContent() + " desc ";
				}
				else{
					OrderOption1 = listXML.getElementsByTagName("COLNAME").item(i).getTextContent() +" desc ";
					OrderOption2 = listXML.getElementsByTagName("COLNAME").item(i).getTextContent() + " ";
				}
			}
			resultXML.append("</HEADER>");
		}
		resultXML.append("</HEADERS>");
		
        if(isdocprint.equals("TRUE")){
        	map.put("iv_PAGESIZE", pageNum);
    		map.put("iv_PAGESIZE2", pageSize);
    		map.put("v_PAGESIZE", Integer.parseInt(pageNum)-Integer.parseInt(pageSize)+1);
    		map.put("v_PAGESIZE2", Integer.parseInt(pageNum)-Integer.parseInt(pageSize)+1);

        }
        else{
        	map.put("iv_PAGESIZE", querySize);
    		map.put("iv_PAGESIZE2", querySize2);
    		map.put("v_PAGESIZE", querySize);
    		map.put("v_PAGESIZE2", querySize2);

        }
        
    	map.put("v_ORDEROPTION", OrderOption1);
    	map.put("v_ORDEROPTIONLENGTH", OrderOption1.length());
    	if(OrderOption1.length() > 0) {
    		map.put("v_ORDEROPTIONVALUE", OrderOption1.substring(0,11).toLowerCase());
    	}
		map.put("v_ORDEROPTION2", OrderOption2);
		map.put("v_ORDEROPTION2LENGTH", OrderOption2.length());
    	if(OrderOption2.length() > 0) {
    		map.put("v_ORDEROPTION2VALUE", OrderOption2.substring(0,11).toLowerCase());
    	}
		map.put("v_ISDOCPRINT", isdocprint);
		
        List<ApprGDeliveryListVO> docList =ezApprovalGDAO.getDeliveryList(map);
 	   StringBuffer sb = new StringBuffer();
       sb.append("<DATA>");
    
       for (int j = 0; j < docList.size(); j++) {
    	   sb.append(commonUtil.getQueryResult(docList.get(j)));
	   }
	   sb.append("</DATA>");
	
	   Document docXML = commonUtil.convertStringToDocument(sb.toString());
	   
    	String fieldName = "";
		String fieldValue = "";
		resultXML.append("<ROWS>");
		for(int j=docXML.getElementsByTagName("ROW").getLength()-1; j>=0; j--){
			resultXML.append("<ROW>");
			
			for(i=0; i<hlength; i++){
				resultXML.append("<CELL>");
				resultXML.append("<VALUE>");
			   
				fieldName = listXML.getElementsByTagName("COLNAME").item(i).getTextContent().toUpperCase();
				
				if(fieldName.toUpperCase().equals("ORGAN") || fieldName.toUpperCase().equals("MANAGEDEPT") || fieldName.toUpperCase().equals("CHARGENAME")){
					fieldName=fieldName + commonUtil.getMultiData(lang, tenantID);
				}
				
				fieldValue = docXML.getElementsByTagName(fieldName).item(j).getTextContent();
				resultXML.append(getListField(fieldName, fieldValue, companyID, lang, tenantID, offset) + "</VALUE>");
				
				if(i==0){
					resultXML.append("<DATA1>" + makeRightField(docXML.getElementsByTagName("DOCID").item(j).getTextContent().trim())+ "</DATA1>");
					resultXML.append("<DATA2>" + makeRightField(docXML.getElementsByTagName("HREF").item(j).getTextContent().trim())+ "</DATA2>");
					resultXML.append("<DATA3>" + makeRightField(docXML.getElementsByTagName("SN").item(j).getTextContent().trim())+ "</DATA3>");
					resultXML.append("<DATA4>" + makeRightField(docXML.getElementsByTagName("MANAGEDEPTID").item(j).getTextContent().trim())+ "</DATA4>");
					resultXML.append("<DATA5>" + makeRightField(docXML.getElementsByTagName("CHARGEID").item(j).getTextContent().trim())+ "</DATA5>");
					resultXML.append("<DATA6>" + makeRightField(docXML.getElementsByTagName("DEPTID").item(j).getTextContent().trim())+ "</DATA6>");
					resultXML.append("<DATA7>" + makeRightField(docXML.getElementsByTagName("ORGDOCNUMCODE").item(j).getTextContent().trim())+ "</DATA7>");
					
				}
				resultXML.append("</CELL>");
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		return resultXML.toString();
	}

	@Override
	public String registerRecord(Document xmlDom, int tenantID, String offset) throws Exception {
		StringBuilder strSQL = new StringBuilder("");
		StringBuilder subSQL2 = new StringBuilder();
		String subSQL= "";
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String cabID = xmlDom.getElementsByTagName("CABINETID").item(0).getTextContent().trim();
		String manualFlag = xmlDom.getElementsByTagName("MANUALFLAG").item(0).getTextContent().trim();
		String deptCode = xmlDom.getElementsByTagName("DEPTCODE").item(0).getTextContent().trim();
		String deptName = xmlDom.getElementsByTagName("DEPTNAME").item(0).getTextContent().trim();
		String deptName2 = xmlDom.getElementsByTagName("DEPTNAME2").item(0).getTextContent().trim();
		String registerType = xmlDom.getElementsByTagName("REGISTERTYPE").item(0).getTextContent().trim();
		String langType = xmlDom.getElementsByTagName("LANGTYPE").item(0).getTextContent().trim();
		
		String registerDate; // 4
		String specialCatalogFlag; // 21
		String regSn; // 22
		String rejectFlag = "0"; // 24
		String attachFlag = "0"; // 25
		String docID = ""; // 26
		
		if(manualFlag.equals("1")){// 수기등록 문서이면
			//(2007.08.10 김상건) : 수기기록물이고 첨부파일이 있을 경우 docid 필요
			docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent().trim();
			registerDate = xmlDom.getElementsByTagName("REGISTERDATE").item(0).getTextContent().trim();
			specialCatalogFlag = xmlDom.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent().trim();
			
			// 2011.04.04 수기등록시 첨부등록 추가
			attachFlag = xmlDom.getElementsByTagName("ATTACHFLAG").item(0).getTextContent().trim();
			regSn = getSerialNum("002", deptCode, "", companyID, langType, tenantID);
			if(regSn.equals("")){
				return "<RESULT>FALSE</RESULT>";
			}
		}
		else{
			registerDate = commonUtil.getTodayUTCTime("");
			specialCatalogFlag = getRecordSCFlag(cabID, companyID, tenantID);
			regSn = xmlDom.getElementsByTagName("REGSN").item(0).getTextContent().trim();
			rejectFlag = xmlDom.getElementsByTagName("REJECTFLAG").item(0).getTextContent().trim();
			attachFlag = xmlDom.getElementsByTagName("ATTACHFLAG").item(0).getTextContent().trim();
			docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent().trim();
		}
		
		if(!regSn.trim().equals("")){
			regSn=formatSerialNum(regSn);
		}
		
		//동국대학교 수정(2007.07.26 김상건) : 회계년도가 3월 ~ 익년 2월까지이므로 RegYear 년도는 회계년도 값을 가져야 한다.
        //string RegYear = DateTime.Parse(REGISTERDATE).Year.ToString();	// 5 -- 원본
        String regYear = getAccountingYear(registerDate, companyID, langType, tenantID);    // -- 수정           
        
        String title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent().trim(); // 6
        String numOfPage = xmlDom.getElementsByTagName("NUMOFPAGE").item(0).getTextContent().trim();	// 7
        String aprMemberTitle = xmlDom.getElementsByTagName("APRMEMBERTITLE").item(0).getTextContent().trim();	// 8
        // 2010.08.03 다국어
        String aprMemberTitle2 = xmlDom.getElementsByTagName("APRMEMBERTITLE2").item(0).getTextContent().trim();	// 8
        String drafterName = xmlDom.getElementsByTagName("DRAFTERNAME").item(0).getTextContent().trim();	// 9
        // 2010.08.03 다국어
        String drafterName2 = xmlDom.getElementsByTagName("DRAFTERNAME2").item(0).getTextContent().trim();	// 9
        String executeDate = xmlDom.getElementsByTagName("EXECUTEDATE").item(0).getTextContent().trim();// 10
        String receiptMember = xmlDom.getElementsByTagName("RECEIPTMEMBER").item(0).getTextContent().trim();	// 11
        // 2010.08.03 다국어
        String receiptMember2 = xmlDom.getElementsByTagName("RECEIPTMEMBER2").item(0).getTextContent().trim();	// 11
        String deliveryNo = xmlDom.getElementsByTagName("DELIVERYNO").item(0).getTextContent().trim();	// 12
		if (deliveryNo.trim() != "")
			deliveryNo = formatSerialNum(deliveryNo);

		String electronicRecFlag = xmlDom.getElementsByTagName("ELECTRONICRECFLAG").item(0).getTextContent().trim();	// 13
		String specialRec = xmlDom.getElementsByTagName("SPECIALREC").item(0).getTextContent().trim();	// 15
		String publicCode = xmlDom.getElementsByTagName("PUBLICCODE").item(0).getTextContent().trim();	// 16
		String limiTrange = xmlDom.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();	// 17
		String docType = "";
		String visualAudioDesc= "";
		String visualAudioType ="";
		try{
			//등록대장 : listType=0일때는 들어갈 필요가 없다.NullPointException 무시하려고 try..catch
			docType = xmlDom.getElementsByTagName("DOCTYPE").item(0).getTextContent().trim();	// 18
		}
		catch(Exception e){
		}
	    try{
	    	visualAudioDesc = xmlDom.getElementsByTagName("VISUALAUDIODESC").item(0).getTextContent().trim();	// 19
			visualAudioType = xmlDom.getElementsByTagName("VISUALAUDIOTYPE").item(0).getTextContent().trim();	// 20
	    }
	    catch(Exception e){
	    }
		String originRegSn = xmlDom.getElementsByTagName("ORIGINREGSN").item(0).getTextContent().trim();	// 23

		// 특수목록 정보 노드
		NodeList nodeSL = xmlDom.getElementsByTagName("SPECIALCATALOGINFO");
		// 분리첨부 정보 노드
		String nodeSepAtta = xmlDom.getElementsByTagName("SEPATTACHINFO").item(0).getTextContent();

		String OldFlag = "1";
		String CreateDate = commonUtil.getTodayUTCTime("");

		//'기록물 ID=처리과기관코드+생산년도+등록일련번호
		String recordID = deptCode + regYear + regSn;
		//'생산등록번호(처리과기관코드+등록일련번호)
		String registerSN = deptCode + regSn;
		
		 // 기록물 테이블에 저장하는 쿼리.
        strSQL.append("Insert Into TBL_RECORD(RecordID, DocID, ProcessDeptName, ProcessDeptName2, ProcessDeptCode, ");
        strSQL.append("RegisterYear, RegisterDate, RegisterNo, AprMemberTitle, AprMemberTitle2, DrafterName, DrafterName2, ExecuteDate, ");
        strSQL.append("ReceiptMemberName, ReceiptMemberName2, SendingMemberName, SendingMemberName2, DeliveryNo, ProduceDeptRegNo, ElectronicRecFlag, ");
		strSQL.append("SpecialRecordCode, PublicityCode, LimitRange, OldRecordFlag, DeleteDate, ");
		strSQL.append("DelFlag, SpecialCatalogFlag, AttachFlag, CreateDate, RejectFlag, ManualRegFlag, ");
		strSQL.append("DocType, TENANT_ID) VALUES ('" + makeRightField(recordID) + "', '" + makeRightField(docID));
		strSQL.append("', N'" + makeRightField(deptName) + "', N'" + makeRightField(deptName2) + "', '" + makeRightField(deptCode));
		strSQL.append("', '" + makeRightField(regYear) + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')" );
        strSQL.append(", '" + makeRightField(registerSN) + "', N'" + makeRightField(aprMemberTitle) + "', N'" + makeRightField(aprMemberTitle2));
		strSQL.append("', N'" + makeRightField(drafterName) + "', N'" + makeRightField(drafterName2) + "', TO_DATE('" + makeRightField(executeDate));
		strSQL.append("','YYYY-MM-DD HH24:MI:SS'), N'" + makeRightField(receiptMember) + "', N'" + makeRightField(receiptMember2) + "', NULL, NULL, '" + makeRightField(deliveryNo));
		strSQL.append("', '" + makeRightField(originRegSn) + "', '" + makeRightField(electronicRecFlag));
		strSQL.append("', '" + makeRightField(specialRec) + "', '" + makeRightField(publicCode));
		strSQL.append("', '" + makeRightField(limiTrange) + "', '" + makeRightField(OldFlag));
		strSQL.append("', NULL, '" + makeRightField("0") + "', '" + makeRightField(specialCatalogFlag));
		strSQL.append("', '" + makeRightField(attachFlag) + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
		strSQL.append(", '" + makeRightField(rejectFlag) + "', '" + makeRightField(manualFlag));
		strSQL.append("', '" + makeRightField(docType) + "'," + tenantID + ");\n");
        // '## 기록물 분리첨부 테이블에 저장
		subSQL = registerSepAttachEx(recordID, cabID, title, numOfPage, registerType, visualAudioDesc, visualAudioType, companyID, formatSepSerialNum("00"), tenantID);
		
        if (subSQL.equals("FALSE")){
        	return "<RESULT>FALSE</RESULT>";
        }
		
        // 2011.04.04 수기등록시 첨부등록 추가
        
        // 수기기록물이면서 첨부파일이 있다면 APR->END 로 복사한다.
        if (manualFlag == "1")
        {
            if (docID != "")
            {
                subSQL2.append(" INSERT INTO TBL_ENDATTACHINFO (DocID, AttachFileSN, AttachFileName, AttachFileHref, AttachUserJobTitle, AttachFileSize, ");
                subSQL2.append("	AttachUserID , AttachUserName, AttachUserDeptID, AttachUserDeptName, PageNum, DisplayName, BodyAttach, AttachUserName2, AttachUserJobTitle2, AttachUserDeptName2, TENANT_ID) ");
                subSQL2.append(" SELECT '" + docID + "', AttachFileSN,AttachFileName, AttachFileHref, AttachUserJobTitle, AttachFileSize ,AttachUserID , ");
                subSQL2.append(" AttachUserName, AttachUserDeptID, AttachUserDeptName, PageNum, DisplayName, BodyAttach, AttachUserName2, AttachUserJobTitle2, AttachUserDeptName2, TENANT_ID");
                subSQL2.append(" FROM TBL_APRATTACHINFO WHERE DOCID = '" + docID + "',"+tenantID+" ;\n");

                subSQL2.append(" DELETE FROM TBL_APRATTACHINFO WHERE DOCID = '" + docID + "' AND TENANT_ID=" + tenantID +";\n");

                strSQL.append(subSQL2.toString());
            }
        }
        
        // '## 분리첨부 추가저장
		if (nodeSepAtta != null)
		{
//			<SEPATTACHINFO>
//				<SEPATTACH>
//					<CABINETID>S907001e00000052004000013001</CABINETID>
//					<TITLE>분리첨부1</TITLE>
//					<NUMOFPAGE>123</NUMOFPAGE>
//					<REGTYPE>1</REGTYPE>
//					<SUMMARY></SUMMARY>
//					<SUMMARY></SUMMARY>
//				</SEPATTACH>
//			</SEPATTACHINFO>
			NodeList nodeSepAtt = xmlDom.getElementsByTagName("SEPATTACH");
	        if (xmlDom.getElementsByTagName("SEPATTACH").getLength() > 0) {
	        	for (int k = 0; k < xmlDom.getElementsByTagName("SEPATTACH").getLength(); k++) {
	        		int tempValue = k + 1;
	        		subSQL = registerSepAttachEx(recordID, xmlDom.getElementsByTagName("CABINETID").item(k).getTextContent(), xmlDom.getElementsByTagName("TITLE").item(k).getTextContent(), xmlDom.getElementsByTagName("NUMOFPAGE").item(k).getTextContent(), xmlDom.getElementsByTagName("REGTYPE").item(k).getTextContent(), xmlDom.getElementsByTagName("SUMMARY").item(k).getTextContent(), xmlDom.getElementsByTagName("AVTYPE").item(k).getTextContent(), companyID, formatSepSerialNum(String.valueOf(tempValue)), tenantID);
	        		
	        		if (subSQL.equals("FALSE")) {
	        			return "FALSE";
	        		} else {
	        			strSQL.append(subSQL);
	        		}
	        	}
	        }
		}
		// '특수목록 정보 저장
		if (specialCatalogFlag.equals("1") && nodeSL != null)
		{
			subSQL = saveSpecialInfoRec(recordID, cabID, xmlDom, tenantID);
			if (subSQL == "FALSE"){
				return "<RESULT>FALSE</RESULT>";
			}
		}

		Boolean result = ExecuteTransactionSQL(strSQL, companyID);

		if (result)
			return "<RESULT>TRUE</RESULT>";
		else
			return "<RESULT>FALSE</RESULT>";
	}

	@Override
	public String getCabinetList(Document xmlDom, LoginVO userInfo) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		StringBuilder strSQL2 = new StringBuilder();
		StringBuilder resultXML = new StringBuilder();
		
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
 		String deptCode = xmlDom.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent().trim();
 		String listFlag = xmlDom.getElementsByTagName("LISTFLAG").item(0).getTextContent().trim();
 		String orderBy = xmlDom.getElementsByTagName("ORDERBY").item(0).getTextContent().trim();
 		String pageSize = xmlDom.getElementsByTagName("PAGESIZE").item(0).getTextContent().trim();
 		String pageNo = xmlDom.getElementsByTagName("PAGENO").item(0).getTextContent().trim();
 		
 		String listType = "001";
 		String listTypeConst = "";
	    String constraint = "";
		String offSetMin = commonUtil.getMinuteUTC(userInfo.getOffset());

		switch(listFlag)
		{
		case "0" :	// 기록물철 대장
			listType = "002";
			break;
		case "1" :	// 편철확정대상 기록물철
			listTypeConst =" And TBL_CABINETCLASS.TerminateFlag='1' And TBL_CABINETCLASS.ConfirmFlag='0'";

			listType = "002";
			break;

		case "2" :	// 기록물철 생산현황
				listTypeConst = " And TBL_CABINETCLASS.ConfirmYear=EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'))";
				listType = "004";
				break;

			case "3" :	// 목록이관 대상
				listTypeConst = " And TBL_CABINETCLASS.ConfirmFlag='1' " + 
						"And ( ( TBL_CABINETCLASS.DisplayRecFlag='2' And TBL_CABINETCLASS.TransDelayFlag='0' " +
			            " And TBL_CABINETCLASS.ConfirmYear Between EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS') - (INTERVAL '1' YEAR)) And EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) " +
			            ") OR( ( TBL_CABINETCLASS.DisplayRecFlag='1' And TBL_CABINETCLASS.DisplayEndDate<CAST(EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) AS char(4)) ) " +
			            " OR ( TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear=EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ) " + 
						") ) And CatalogTransferFlag='0' ";
				listType = "006";
				break;

			case "4" :	// ?뚯씪?닿? ???
				listTypeConst = " And CatalogTransferFlag='1' " +
			            "And DocTransferFlag='0' And CatalogTransferYear=(Select Max(CatalogTransferYear) From TBL_CABINET ) ";
				listType = "006";
				break;

			case "5" :	// 이관목록
				listTypeConst =  " And DocTransferFlag='1' " +
			            "And DocTransferYear=EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ";

				listType = "006";
				break;
    
			case "6" :	// 연기신청목록
				listTypeConst = "And TBL_CABINETCLASS.KeepingPlace='1' " +
			            "And ( (TBL_CABINETCLASS.DisplayRecFlag='1' And TBL_CABINETCLASS.DisplayEndDate>=CAST(EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) AS char(4)) ) " +
			            " OR (TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear>EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ) " +
			            " ) And ( ( TBL_CABINETCLASS.ConfirmYear = EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) ) OR " +
			            " ( TBL_CABINETCLASS.ConfirmYear > (Select Max(DocTransferYear) From TBL_CABINET ) ) ) ";
				listType = "008";
				break;
    
			case "7" :	// 폐기대상 기록물철

				String DFlag = getCode2Name("A35", "003", companyID,  userInfo.getLang(), userInfo.getTenantId()).toUpperCase().trim();
				LOGGER.debug("getCode2Name ended.");
				if (DFlag == "Y")
				{
					// 사학 G버전. 폐기 대상은 완료 연도부터 보존기간 경과한 기록물.
					listTypeConst = " AND TBL_CABINETCLASS.TerminateFlag = '1' " + 
							"AND @YEAR - TBL_CABINETCLASS.ExpirationYear > TBL_CABINETCLASS.KeepingPeriod ".replace("@YEAR", commonUtil.getTodayUTCTime("yyyy"));
				}
				else
				{
					// 일반 G버전. 폐기 대상은 이관된 기록물.
					listTypeConst =  " And DocTransferFlag='1' ";
				}

				listType = "002";
				break;
    
			case "8" :	// 정리대상 기록물철
                //동국대학교 수정 (2007.07.30) : 회계년도가 3월 ~ 익년 2월까지이므로 회계년도 값을 보정한다.//////////////
                //원본
                //ListTypeConst = g_Const_ArrangeTargetCabConst;
				listTypeConst = " And TBL_CABINETCLASS.ConfirmFlag='0' " +
	                    "And TBL_CABINETCLASS.ExpirationYear<'" + getAccountingYear(commonUtil.getTodayUTCTime(""), companyID,  userInfo.getLang(), userInfo.getTenantId())+ "'" ;
				
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                listType = "009";
				break;
    
			case "9" :	// 인계기록물철
				listType = "002";
				break;
    
			case "10" :	// 종료연기 신청 대상 기록물철(업무담당자)
                //동국대학교 수정 (2007.07.30) : 회계년도가 3월 ~ 익년 2월까지이므로 회계년도 값을 보정한다.//////////////
                //ListTypeConst = "And TBCABINETCLASS.ExpirationYear=Cast(DatePart(yyyy,GetDate()) AS char(4)) "; 
                String regYear = getAccountingYear(commonUtil.getTodayUTCTime(""), companyID,  userInfo.getLang(), userInfo.getTenantId());
                listTypeConst = "And TBL_CABINETCLASS.ExpirationYear='" + regYear + "'  ";
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                listType = "010";
				break;
    
			case "11" :	// 종료연기 확인 대상 기록물철(기록물 관리 책임자)
				listTypeConst = " And TBL_CABINETCLASS.DelayEndYFlag = 'Y' " + 
						"And TBL_CABINETCLASS.TerminateFlag = '0' And TBL_CABINETCLASS.ConfirmFlag = '0'";;
				listType = "010";
				break;

			case "12" :	// 미정리 기록물철
                //동국대학교 수정 (2007.07.30) : 회계년도가 3월 ~ 익년 2월까지이므로 회계년도 값을 보정한다.//////////////
                //ListTypeConst = g_Const_NotArrangedCabConst;
				listTypeConst = " And TBL_CABINETCLASS.ConfirmFlag='0' " +
	                    "And TBL_CABINETCLASS.ExpirationYear<'" + getAccountingYear(commonUtil.getTodayUTCTime(""), companyID,  userInfo.getLang(), userInfo.getTenantId()) + "' And TBL_CABINETCLASS.TerminateFlag='0' ";
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                listType = "009";
				break;

			default : 
				listType = "002";
				break;
		}
		
		String arrListInfo = getLVFieldInfo(listType, companyID, userInfo.getLang(), userInfo.getTenantId());
		Document arrList = commonUtil.convertStringToDocument(arrListInfo);
		String extraSelectClause = "";
		String  selectClause =" SELECT TBL_CABINET.CabinetID, " + 
				"TBL_CABINETCLASS.RegSerialNo, TBL_CABINETCLASS.ProductionYear, TBL_CABINET.VolumeNo, " +
				"TBL_CABINETCLASS.ModifyFlag, TBL_CABINET.CabinetTransferFlag, TBL_CABINETCLASS.ConfirmFlag, " +
	            "TBL_CABINETCLASS.TaskCode, TBL_CABINETCLASS.TaskName, TBL_CABINETCLASS.TaskName2, TBL_CABINETCLASS.ProcessDeptCode, " + 
				"TBL_CABINETCLASS.ProcessDeptName,TBL_CABINETCLASS.ProcessDeptName2, TBL_CABINET.CabinetClassNo, TBL_CABINETCLASS.RecTypeCode as RecTypeCode, " + 
				"TBL_CABINETCLASS.CreateDate+ '" + offSetMin +"'/(24*60) AS ClassCreateDate, TBL_CABINETCLASS.OwnerID, " + 
				"TBL_CABINETCLASS.SpecialCatalogFlag, TBL_CABINETCLASS.TerminateFlag, " + 
				"TBL_CABINETCLASS.OwnerDeptID, TBL_CABINETCLASS.OwnerTask, TBL_CABINETCLASS.TransDelayFlag ";
		for (int i = 0; i < arrList.getElementsByTagName("SELECTFIELD").getLength(); i++) {
			if (!makeListField(arrList.getElementsByTagName("COLNAME").item(i).getTextContent()).equals("")) {
				if (selectClause.toUpperCase().indexOf(arrList.getElementsByTagName("COLNAME").item(i).getTextContent().toUpperCase().trim()) < 0) {
					if(arrList.getElementsByTagName("COLNAME").item(i).getTextContent().toUpperCase().trim().indexOf("DATE")>-1){
						String utcDate[] = arrList.getElementsByTagName("SELECTFIELD").item(i).getTextContent().trim().split("AS");
						extraSelectClause += "," + utcDate[0] +"+ '"+ offSetMin +"'/(12*60) AS" + utcDate[1] ;
					} else{
						extraSelectClause += ", " + arrList.getElementsByTagName("SELECTFIELD").item(i).getTextContent().trim();
					}
				} else if (selectClause.toUpperCase().indexOf(arrList.getElementsByTagName("COLALIAS").item(i).getTextContent().toUpperCase().trim()) < 0) {
					extraSelectClause += ", " + arrList.getElementsByTagName("SELECTFIELD").item(i).getTextContent().trim();
				}
			}
		}
		if (listFlag == "9")		// 인계 기록물철 조회 시
		{
			constraint += " AND ((OwnerDeptID = '" + deptCode + 
				"' And ConfirmFlag = '0') OR (TBL_CABINETCLASS.ProcessDeptCode = '" +
				deptCode + "' AND ConfirmFlag='1') ) ";
		}
		else
		{
			if (xmlDom.getElementsByTagName("DEPTCODE").item(0) != null && xmlDom.getElementsByTagName("DEPTCODE").item(0).getTextContent().length() > 0){
				constraint += " AND TBL_CABINETCLASS.OwnerDeptID = '" + xmlDom.getElementsByTagName("DEPTCODE").item(0).getTextContent().trim() + "' ";

			}
			else if (deptCode.length() > 0) {
				constraint += " AND TBL_CABINETCLASS.OwnerDeptID = '" + deptCode + "' ";
			}
		}

		//    '검색조건
		//    'SParamRec(0)  '제목
		//    'SParamRec(1)  '단위업무코드
		//    'SParamRec(2)  '생산연도 시작
		//    'SParamRec(3)  '생산연도 끝
		//    'SParamRec(4)  '종료연도 시작
		//    'SParamRec(5)  '종료연도 끝
		//    'SParamRec(6)  '기록물 형태
		//    'SParamRec(7)  '보존연한
		//    'SParamRec(8)  '보존방법
		//    'SParamRec(9)  '보존장소
		//    'SParamRec(10)  '업무담당자
		//    'SParamRec(11)  '처리과코드
		//    'SParamRec(12)  '보존기간경과

         if (xmlDom.getElementsByTagName("TITLE").item(0) != null && xmlDom.getElementsByTagName("TITLE").item(0).getTextContent().length() > 0)
        {
            if( userInfo.getLang().equals("1"))
                constraint += " AND TBL_CABINETCLASS.Title Like '%" + makeSearchField(xmlDom.getElementsByTagName("TITLE").item(0).getTextContent().trim()) + "%' ";
            else
                constraint += " AND TBL_CABINETCLASS.Title2 Like '%" + makeSearchField(xmlDom.getElementsByTagName("TITLE").item(0).getTextContent().trim()) + "%' ";
        }

		if (xmlDom.getElementsByTagName("TASKCODE").item(0) != null && xmlDom.getElementsByTagName("TASKCODE").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.TaskCode IN (" + xmlDom.getElementsByTagName("TASKCODE").item(0).getTextContent() + ")";
		}
		if (xmlDom.getElementsByTagName("SPRODUCEY").item(0) != null && xmlDom.getElementsByTagName("SPRODUCEY").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.ProductionYear >= '" + makeRightField(xmlDom.getElementsByTagName("SPRODUCEY").item(0).getTextContent().trim()).substring(0, 4) + "' ";
		}
		if (xmlDom.getElementsByTagName("EPRODUCEY").item(0) != null && xmlDom.getElementsByTagName("EPRODUCEY").item(0).getTextContent().length() > 0){
            constraint += " AND TBL_CABINETCLASS.ProductionYear <= '" + makeRightField(xmlDom.getElementsByTagName("EPRODUCEY").item(0).getTextContent().trim()).substring(0, 4) + "' ";
		}
		if (xmlDom.getElementsByTagName("SENDY").item(0) != null && xmlDom.getElementsByTagName("SENDY").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.ExpirationYear >= '" + makeRightField(xmlDom.getElementsByTagName("SENDY").item(0).getTextContent().trim()).substring(0, 4) + "' ";
		}
		if (xmlDom.getElementsByTagName("EENDY").item(0) != null && xmlDom.getElementsByTagName("EENDY").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.ExpirationYear <= '" + makeRightField( xmlDom.getElementsByTagName("EENDY").item(0).getTextContent().trim()).substring(0, 4) + "' ";
		}
		if (xmlDom.getElementsByTagName("RECTYPECODE").item(0) != null && xmlDom.getElementsByTagName("RECTYPECODE").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.RecTypeCode = '" + makeRightField(xmlDom.getElementsByTagName("RECTYPECODE").item(0).getTextContent().trim()) + "' ";
		}
		if (xmlDom.getElementsByTagName("KEEPPERIOD").item(0) != null && xmlDom.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.KeepingPeriod = '" + makeRightField(xmlDom.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().trim()) + "' ";
		}
		
		if (xmlDom.getElementsByTagName("KEEPMETHOD").item(0) != null && xmlDom.getElementsByTagName("KEEPMETHOD").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.KeepingMethod = '" + makeRightField(xmlDom.getElementsByTagName("KEEPMETHOD").item(0).getTextContent().trim()) + "' ";
		}
		
		if (xmlDom.getElementsByTagName("KEEPPLACE").item(0) != null && xmlDom.getElementsByTagName("KEEPPLACE").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.KeepingPlace = '" + makeRightField(xmlDom.getElementsByTagName("KEEPPLACE").item(0).getTextContent().trim()) + "' ";
		}
		
		if (xmlDom.getElementsByTagName("CHARGER").item(0) != null && xmlDom.getElementsByTagName("CHARGER").item(0).getTextContent().length() > 0){
			constraint += " AND TBL_CABINETCLASS.CabinetClassNo IN (select CabinetClassNo " +
                    "From TBL_CABROLEINFO WHERE User_ID IN (" + xmlDom.getElementsByTagName("CHARGER").item(0).getTextContent().trim() + ") ) ";		
		}
		
		if (xmlDom.getElementsByTagName("TRANSEXPIRE").item(0) != null && xmlDom.getElementsByTagName("TRANSEXPIRE").item(0).getTextContent().length() > 0){
		   
			 if(!(getAccountingYear(commonUtil.getTodayUTCTime(""), companyID, userInfo.getLang(), userInfo.getTenantId()).equals(""))){
				 constraint = " And ( TBL_CABINETCLASS.ConfirmFlag='1' And " +
                         "( TBL_CABINETCLASS.DisplayRecFlag='2' And TBL_CABINETCLASS.TransDelayFlag='0' " +
                         " And TBL_CABINETCLASS.ConfirmYear < '" + (Integer.parseInt(getAccountingYear(commonUtil.getTodayUTCTime(""), companyID,  userInfo.getLang(), userInfo.getTenantId())) - 1) + "'" +
                         " ) OR ( ( TBL_CABINETCLASS.DisplayRecFlag='1' And RTRIM(DISPLAYENDDATE) <> '' AND TBL_CABINETCLASS.DisplayEndDate<'" + getAccountingYear(commonUtil.getTodayUTCTime(""), companyID,  userInfo.getLang(), userInfo.getTenantId()) + "') " +
                         " OR ( TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear<'" + (Integer.parseInt(getAccountingYear(commonUtil.getTodayUTCTime(""), companyID,  userInfo.getLang(), userInfo.getTenantId())) - 1) + "') " +
                         " ) ) And TBL_CABINETCLASS.KeepingPlace='1' And DocTransferFlag='0'";
			 }
			 else{
				 constraint =  " And ( TBL_CABINETCLASS.ConfirmFlag='1' And " +
                         "( TBL_CABINETCLASS.DisplayRecFlag='2' And TBL_CABINETCLASS.TransDelayFlag='0' " +
                         " And TBL_CABINETCLASS.ConfirmYear < EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')-(INTERVAL '1' YEAR)) " +
                         " ) OR ( ( TBL_CABINETCLASS.DisplayRecFlag='1' And TBL_CABINETCLASS.DisplayEndDate<CAST(EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')) AS char(4)) ) " +
                         " OR ( TBL_CABINETCLASS.TransDelayFlag='1' And TBL_CABINETCLASS.ExTransYear<EXTRACT(YEAR FROM TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS') - (INTERVAL '1' YEAR)) ) " +
                         " ) ) And TBL_CABINETCLASS.KeepingPlace='1' And DocTransferFlag='0'";
			 }
		}
		
		if(orderBy.equals("")){
			orderBy = " Order By CreateDate DESC, CabinetID DESC ";
		}
		

        // 수정(2008.03.03) : 기록물철 목록 쿼리 시 Top으로 가져오도록 수정
        /*int iTopCnt = 0;
        if (GetParamText(objParam.DocumentElement, "ISDOCPRINT") == "TRUE")
            iTopCnt = int.Parse(PageNo);
        else
            iTopCnt = int.Parse(PageSize) * int.Parse(PageNo);
         * */

        //2011.05.11  기록물등록부 페이징 오류 처리
        //strSQL.Append(g_Const_CabinetSelectClause.Replace("SELECT ", "SELECT TOP " + iTopCnt.ToString() + " ") + ExtraSelectClause + g_Const_CabinetFromClause);
		
		strSQL.append(" SELECT * FROM ( SELECT ROW_NUMBER() OVER( " + orderBy + " ) AS ROWNUM_, N.*  FROM ( SELECT "+ "TBL_CABINET.CabinetID, "+ 
				"TBL_CABINETCLASS.RegSerialNo, TBL_CABINETCLASS.ProductionYear, TBL_CABINET.VolumeNo, " +
				"TBL_CABINETCLASS.ModifyFlag, TBL_CABINET.CabinetTransferFlag, TBL_CABINETCLASS.ConfirmFlag, " +
	            "TBL_CABINETCLASS.TaskCode, TBL_CABINETCLASS.TaskName, TBL_CABINETCLASS.TaskName2, TBL_CABINETCLASS.ProcessDeptCode, " + 
				"TBL_CABINETCLASS.ProcessDeptName,TBL_CABINETCLASS.ProcessDeptName2, TBL_CABINET.CabinetClassNo, TBL_CABINETCLASS.RecTypeCode as RecTypeCode, " + 
				"TBL_CABINETCLASS.CreateDate + '" + offSetMin +"'/(24*60) AS ClassCreateDate, TBL_CABINETCLASS.OwnerID, " + 
				"TBL_CABINETCLASS.SpecialCatalogFlag, TBL_CABINETCLASS.TerminateFlag, " + 
				"TBL_CABINETCLASS.OwnerDeptID, TBL_CABINETCLASS.OwnerTask, TBL_CABINETCLASS.TransDelayFlag " + extraSelectClause + " From  TBL_CABINETCLASS  Inner Join " +
	            "TBL_CABINET  On TBL_CABINETCLASS.CabinetClassNo = TBL_CABINET.CabinetClassNo AND TBL_CABINETCLASS.TENANT_ID = TBL_CABINET.TENANT_ID " );
		
		 strSQL2.append("SELECT COUNT(*) " + " From  TBL_CABINETCLASS  Inner Join " +
		            "TBL_CABINET  On TBL_CABINETCLASS.CabinetClassNo = TBL_CABINET.CabinetClassNo AND TBL_CABINETCLASS.TENANT_ID = TBL_CABINET.TENANT_ID ");
		 
		 if(listFlag.equals("9")){
			 strSQL.append( " Where TBL_CABINET.DelFlag = '0' " +
						"AND TBL_CABINETCLASS.DelFlag = '0' AND TBL_CABINET.CabinetTransferFlag = '2'" + constraint + listTypeConst + "AND TBL_CABINETCLASS.TENANT_ID="+ userInfo.getTenantId());
			 strSQL2.append( " Where TBL_CABINET.DelFlag = '0' " +
						"AND TBL_CABINETCLASS.DelFlag = '0' AND TBL_CABINET.CabinetTransferFlag = '2'" + constraint + listTypeConst + "AND TBL_CABINETCLASS.TENANT_ID="+ userInfo.getTenantId());
		 }
		 else{
			 strSQL.append(  " Where TBL_CABINET.DelFlag = '0' " + 
						"AND TBL_CABINETCLASS.DelFlag = '0' AND NOT (TBL_CABINET.CabinetTransferFlag = '2' And ConfirmFlag = '0') " + constraint + listTypeConst + "AND TBL_CABINETCLASS.TENANT_ID="+ userInfo.getTenantId());
			 strSQL2.append(  " Where TBL_CABINET.DelFlag = '0' " + 
						"AND TBL_CABINETCLASS.DelFlag = '0' AND NOT (TBL_CABINET.CabinetTransferFlag = '2' And ConfirmFlag = '0') " + constraint + listTypeConst + "AND TBL_CABINETCLASS.TENANT_ID="+ userInfo.getTenantId());
		 }
		 
		 int start = 0;
 		 int end = 0;
		 
 		 if(xmlDom.getElementsByTagName("ISDOCPRINT").item(0)!=null && xmlDom.getElementsByTagName("ISDOCPRINT").item(0).getTextContent().equals("TRUE") ){
			 end = Integer.parseInt(xmlDom.getElementsByTagName("PAGENO").item(0).getTextContent());
			 start = Integer.parseInt(xmlDom.getElementsByTagName("PAGESIZE").item(0).getTextContent());
		 }
		 else{
			 end = Integer.parseInt(pageSize)* Integer.parseInt(pageNo);
		     start = end - Integer.parseInt(pageSize) + 1;
		 }
		 
		 
		 if (xmlDom.getElementsByTagName("ISDOCPRINT").item(0)!=null && xmlDom.getElementsByTagName("ISDOCPRINT").item(0).getTextContent().equals("TRUE") && start < 0){
             strSQL.append(" ) N ) A ");  //PageSize를 음수를 주면 모든 페이지를 가져온다.
		 }
         else{
             strSQL.append(" ) N ) A WHERE ROWNUM_ BETWEEN " + start + " AND " + end);
         }
		 
	        Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", strSQL.toString());
 			map.put("companyID", companyID);

	        List<ApprGCabinetVO> apprGCabinetList = ezApprovalGDAO.getCabinetList(map);
	        
 	        StringBuffer sb = new StringBuffer();
	        sb.append("<DATA>");
	        
	        for (int i = 0; i < apprGCabinetList.size(); i++) {
				sb.append(commonUtil.getQueryResult(apprGCabinetList.get(i)));
			}
			sb.append("</DATA>");
			
			Document docXML = commonUtil.convertStringToDocument(sb.toString());
			
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("sqlString", strSQL2.toString());
			map1.put("companyID", companyID);
			
 			int docCount = ezApprovalGDAO.getCabinetListCount(map1);
			
			resultXML.append("<DOCLIST>");
			resultXML.append("<TOTALDOCCOUNT>" + docCount + "</TOTALDOCCOUNT>");
			resultXML.append("<LISTVIEWDATA>");
			resultXML.append("<HEADERS>");
			for(int j = 0; j< arrList.getElementsByTagName("ROW").getLength(); j++){
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>" + arrList.getElementsByTagName("NAME").item(j).getTextContent().trim()+"</NAME>");
				resultXML.append("<WIDTH>" + arrList.getElementsByTagName("WIDTH").item(j).getTextContent().trim()+"</WIDTH>");
				resultXML.append("</HEADER>");
			}
			resultXML.append("</HEADERS>");
			resultXML.append("<ROWS>");
			for(int j=0; j<docXML.getElementsByTagName("ROW").getLength(); j++){
				resultXML.append("<ROW>");
				for (int k=0; k< arrList.getElementsByTagName("COLALIAS").getLength(); k++){
					String fieldName = arrList.getElementsByTagName("COLALIAS").item(k).getTextContent().trim().toUpperCase();
					
					if(fieldName.toUpperCase().equals("DREFTNAME") || fieldName.toUpperCase().equals("RECIVENAME") || fieldName.toUpperCase().equals("SENDDEPTNAME") || fieldName.toUpperCase().equals("RECIVEDEPTNAME")){
						fieldName = fieldName + commonUtil.getMultiData( userInfo.getLang(), userInfo.getTenantId());
					}
					resultXML.append("<CELL>");
					resultXML.append("<VALUE>");
					
					switch(arrList.getElementsByTagName("DTYPE").item(k).getTextContent().trim()){
					
						case "dtSerialNum" :
       							System.out.println(docXML.getTextContent());
							resultXML.append(docXML.getElementsByTagName("ROWNUM_").item(j).getTextContent());
						break;
							
						case "dtCabClassNo" :
							resultXML.append(getCabinetNo(docXML.getElementsByTagName("PROCESSDEPTCODE").item(j).getTextContent(),makeListField(docXML.getElementsByTagName("TASKCODE").item(j).getTextContent()),
									makeListField(docXML.getElementsByTagName("PRODUCTIONYEAR").item(j).getTextContent()),makeListField(docXML.getElementsByTagName("REGSERIALNO").item(j).getTextContent()),makeListField(docXML.getElementsByTagName("VOLUMENO").item(j).getTextContent())));
								break;
						case "dtRecTypeCode" :						// 기록물 형태
							resultXML.append(getRecordTypeString(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()),companyID, userInfo.getLang(), userInfo.getTenantId()));
							break;

						case "dtKeepPeriod" :						// 보존년한
							resultXML.append(getKeepPeriodString(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()), companyID, userInfo.getLang(), userInfo.getTenantId()));
							break;

						case "dtKeepMethod" :						// 보존방법
							resultXML.append(getKeepMethodString(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()), companyID, userInfo.getLang(), userInfo.getTenantId()));
							break;

						case "dtKeepPlace" :						// 보존장소
							resultXML.append(getKeepPlaceString(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()), companyID, userInfo.getLang(), userInfo.getTenantId()));
							break;

						case "dtBool" :								// Y/N 형식의 데이터 타입
 							String tempValue = makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent().trim());
							if (tempValue.equals("1"))
								resultXML.append("Y");
							else
								resultXML.append("N");
							break;

						case "dtDate" :								// 날짜 타입(시간제외)
							resultXML.append(formatDateForView(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()), 1));
							break;

						case "dtDateTime" :								// 날짜 타입(시간포함)
							resultXML.append(formatDateForView(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()), 0));
							break;
		
						default:
							resultXML.append(makeListField(docXML.getElementsByTagName(fieldName).item(j).getTextContent()));
							break;
					}		
					resultXML.append("</VALUE>");
					
					if (k == 0)
					{
						resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("CABINETID").item(j).getTextContent().trim()) + "</DATA1>");
						resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(j).getTextContent().trim()) + "</DATA2>");
						resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("OWNERID").item(j).getTextContent().trim()) + "</DATA3>");
						resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("CONFIRMFLAG").item(j).getTextContent().trim()) + "</DATA4>");
						resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("OWNERDEPTID").item(j).getTextContent().trim()) + "</DATA5>");
						resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("TERMINATEFLAG").item(j).getTextContent().trim()) + "</DATA6>");
						resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("TRANSDELAYFLAG").item(j).getTextContent().trim()) + "</DATA7>");
					}
					resultXML.append("</CELL>");
				}
				resultXML.append("</ROW>");
			}		
			resultXML.append("</ROWS>");
			resultXML.append("</LISTVIEWDATA>");
			resultXML.append("</DOCLIST>");
		return resultXML.toString();
	}

	@Override
	public String getCabinetDetailInfo(Document xmlDom, int tenantID) throws Exception {
		
		StringBuilder strXML = new StringBuilder();
		String cabinetID = xmlDom.getElementsByTagName("CABINETID").item(0).getTextContent();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String strType = xmlDom.getElementsByTagName("STRTYPE").item(0).getTextContent();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabinetID.trim());
		map.put("v_CABINETCLASSNO", cabinetID.substring(0, cabinetID.trim().length()-3));
		map.put("v_TENANTID", tenantID);
		StringBuilder userName = new StringBuilder() ;
		List<ApprGRecordVO> userNameList = ezApprovalGDAO.selectUserName(map);
		if ( userNameList.size() > 0 ) {
			for(int j=0; j<userNameList.size(); j++ ) {
				userName.append(userNameList.get(j).getUserName() + ",");
			}
		}
		map.put("v_userName", userName.toString().substring(0, userName.length()-1));
		int cabID = ezApprovalGDAO.selectCabID(map);
		int cabID2 = ezApprovalGDAO.selectCabID2(map);
		map.put("v_cabID", cabID + cabID2);

		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getCabinetDetailInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("ROW").getLength() <= 0) {
			return "<RESULT>NORECORD</RESULT>";
		}
		
		strXML.append("<CABINFO>");
		strXML.append("<BASICINFO>");
		strXML.append("<CABINETID>" + docXML.getElementsByTagName("CABINETID").item(0).getTextContent() + "</CABINETID>");
		strXML.append("<CABCLASSNO>" + docXML.getElementsByTagName("CABINETCLASSNO").item(0).getTextContent() + "</CABCLASSNO>");
		strXML.append("<TITLE>" + docXML.getElementsByTagName("TITLE").item(0).getTextContent() + "</TITLE>");
		strXML.append("<CABCLASSID>" + getCabinetNo(docXML.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent(), docXML.getElementsByTagName("TASKCODE").item(0).getTextContent(), docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent(), docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent(), docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent()) + "</CABCLASSID>");
		strXML.append("<RECTYPE>" + getRecordTypeString(docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent(),companyID , strType, tenantID) + "</RECTYPE>");
		strXML.append("<DEPTNAME>" + docXML.getElementsByTagName("PROCESSDEPTNAME" + commonUtil.getMultiData(strType, tenantID)).item(0).getTextContent() + "</DEPTNAME>");
		strXML.append("<TASKNAME>" + docXML.getElementsByTagName("TASKNAME" + commonUtil.getMultiData(strType, tenantID)).item(0).getTextContent() + "</TASKNAME>");
		strXML.append("<PRODUCEY>" + docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent() + "</PRODUCEY>");
		strXML.append("<REGSN>" + docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent() + "</REGSN>");
		strXML.append("<VOLNO>" + docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent() + "</VOLNO>");
		strXML.append("<REGDATE>" + formatDateForView(docXML.getElementsByTagName("CREATEDATE").item(0).getTextContent(),0) + "</REGDATE>");
		strXML.append("<SCFLAG>" + docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent() + "</SCFLAG>");
		strXML.append("</BASICINFO>");
		strXML.append("<EXTRAINFO>");
		strXML.append("<NUMOFREC>" + docXML.getElementsByTagName("NUMOFREC").item(0).getTextContent() + "</NUMOFREC>");
		strXML.append("<NUMOFPAGE>" + docXML.getElementsByTagName("NUMOFPAGE").item(0).getTextContent() + "</NUMOFPAGE>");
		strXML.append("<NUMOFFILE>" + docXML.getElementsByTagName("NUMOFFILE").item(0).getTextContent() + "</NUMOFFILE>");
		strXML.append("<MODIFYFLAG>" + docXML.getElementsByTagName("MODIFYFLAG").item(0).getTextContent() + "</MODIFYFLAG>");
		strXML.append("<OLDFLAG>" + docXML.getElementsByTagName("OLDCABINETFLAG").item(0).getTextContent() + "</OLDFLAG>");
		strXML.append("<OLDCREATEORGAN>" + (docXML.getElementsByTagName("CREATEORGANNAME").item(0).getTextContent()== null ? "":docXML.getElementsByTagName("CREATEORGANNAME").item(0).getTextContent()) + "</OLDCREATEORGAN>");
		strXML.append("<OLDCLASSNO>" + docXML.getElementsByTagName("CLASSIFICATIONNO").item(0).getTextContent() + "</OLDCLASSNO>");
		strXML.append("</EXTRAINFO>");
		strXML.append("<CLASSINFO>");
		strXML.append("<ENDY>" + (docXML.getElementsByTagName("EXPIRATIONYEAR").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("EXPIRATIONYEAR").item(0).getTextContent()) + "</ENDY>");
		strXML.append("<KEEPPERIOD>" + getKeepPeriodString(docXML.getElementsByTagName("KEEPINGPERIOD").item(0).getTextContent(),companyID,strType, tenantID) + "</KEEPPERIOD>");
		strXML.append("<KEEPMETHOD>" + getKeepMethodString(docXML.getElementsByTagName("KEEPINGMETHOD").item(0).getTextContent(),companyID,strType, tenantID) + "</KEEPMETHOD>");
		strXML.append("<KEEPPLACE>" + getKeepPlaceString(docXML.getElementsByTagName("KEEPINGPLACE").item(0).getTextContent(),companyID,strType, tenantID) + "</KEEPPLACE>");
		strXML.append("<DISPENDDATE>" + (docXML.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent()) + "</DISPENDDATE>");
		strXML.append("<DISPREASON>" + (docXML.getElementsByTagName("DISPLAYREASON").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("DISPLAYREASON").item(0).getTextContent())  + "</DISPREASON>");
		strXML.append("<CABCHARGER>" + docXML.getElementsByTagName("CABCHARGER").item(0).getTextContent() + "</CABCHARGER>");
		strXML.append("<CONFIRMFLAG>" + docXML.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent() + "</CONFIRMFLAG>");
		strXML.append("<CATATRANSFLAG>" + docXML.getElementsByTagName("CATALOGTRANSFERFLAG").item(0).getTextContent() + "</CATATRANSFLAG>");
		strXML.append("<CATATRANSYEAR>" + docXML.getElementsByTagName("CATALOGTRANSFERYEAR").item(0).getTextContent() + "</CATATRANSYEAR>");
		strXML.append("<DOCTRANSFLAG>" + docXML.getElementsByTagName("DOCTRANSFERFLAG").item(0).getTextContent() + "</DOCTRANSFLAG>");
		strXML.append("<DOCTRANSYEAR>" + docXML.getElementsByTagName("DOCTRANSFERYEAR").item(0).getTextContent() + "</DOCTRANSYEAR>");
		strXML.append("</CLASSINFO>");
		
		strXML.append("<TRANSINFO>");
		strXML.append("<CABTRANSFLAG>" + docXML.getElementsByTagName("CABINETTRANSFERFLAG").item(0).getTextContent() + "</CABTRANSFLAG>");
		strXML.append("<TCABID>" + docXML.getElementsByTagName("TCABINETID").item(0).getTextContent() + "</TCABID>");
		strXML.append("<TCABNAME>" + (docXML.getElementsByTagName("TCABINETNAME" + commonUtil.getMultiData(strType, tenantID)).item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TCABINETNAME" + commonUtil.getMultiData(strType, tenantID)).item(0).getTextContent())+ "</TCABNAME>");
		strXML.append("<TDEPTNAME>" + (docXML.getElementsByTagName("TDEPTNAME" + commonUtil.getMultiData(strType, tenantID)).item(0).getTextContent() ==null ? "" : docXML.getElementsByTagName("TDEPTNAME" + commonUtil.getMultiData(strType, tenantID)).item(0).getTextContent())+ "</TDEPTNAME>");
		strXML.append("<TDEPTCODE>" + (docXML.getElementsByTagName("TDEPTCODE").item(0).getTextContent() == null ? "" :  docXML.getElementsByTagName("TDEPTCODE").item(0).getTextContent()) + "</TDEPTCODE>");
		strXML.append("<TTASKNAME>" + (docXML.getElementsByTagName("TTASKNAME").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TTASKNAME").item(0).getTextContent() ) + "</TTASKNAME>");
		strXML.append("<TTASKCODE>" + (docXML.getElementsByTagName("TTASKCODE").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TTASKCODE").item(0).getTextContent()) + "</TTASKCODE>");
		strXML.append("<TPRODUCEY>" + (docXML.getElementsByTagName("TPRODUCEYEAR").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TPRODUCEYEAR").item(0).getTextContent())+ "</TPRODUCEY>");
		strXML.append("<TREGSN>" + (docXML.getElementsByTagName("TREGSERIALNO").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TREGSERIALNO").item(0).getTextContent()) + "</TREGSN>");
		strXML.append("<TVOLNO>" + docXML.getElementsByTagName("TVOLUMENO").item(0).getTextContent() + "</TVOLNO>");
		strXML.append("<TRANSDATE>" + formatDateForView(docXML.getElementsByTagName("TRANSFERDATE").item(0).getTextContent(),1) + "</TRANSDATE>");
		strXML.append("</TRANSINFO>");
		strXML.append("</CABINFO>");
		return strXML.toString();
	}

	@Override
	public String getCabScInfo(Document xmlDom, int tenantID) throws Exception {
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String cabinetID = xmlDom.getElementsByTagName("CABINETID").item(0).getTextContent();
		StringBuilder strXML = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabinetID.trim());
		map.put("v_TENANTID", tenantID);
		
		List<ApprGTaskVO> docList = ezApprovalGDAO.getCabScInfo(map);
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("ROW").getLength() <= 0) {
			return "<RESULT>NORECORD</RESULT>";
		}
		
		strXML.append("<LISTVIEWDATA>");
		strXML.append("<HEADERS>");
		strXML.append("<ROWS>");
		boolean[] scYn = new boolean[3];
		for(int j=0; j < docXML.getElementsByTagName("ROW").getLength(); j++){
			String scSn = docXML.getElementsByTagName("SERIALNO").item(j).getTextContent().trim();
			
			if(scSn.equals("000")){
				strXML.append("<HEADER>");
				strXML.append("<NAME>" + "Serial NO." +"</NAME>");
				strXML.append("<WIDTH>" + "100" + "</WIDTH>");
				strXML.append("</HEADER>");
				
				// '제 1 특수목록
				if(makeListField(docXML.getElementsByTagName("SC1").item(j).getTextContent()).equals("")){
				   scYn[0]=false;
				}
				else{
					scYn[0]=true;
					strXML.append("<HEADER>");
					strXML.append("<NAME>" + makeListField(docXML.getElementsByTagName("SC1").item(j).getTextContent()) +"</NAME>");
					strXML.append("<WIDTH>" + "250" + "</WIDTH>");
					strXML.append("</HEADER>");
				}
				// '제 2 특수목록
				if(makeListField(docXML.getElementsByTagName("SC2").item(j).getTextContent()).equals("")){
				   scYn[1]=false;
				}
				else{
					scYn[1]=true;
					strXML.append("<HEADER>");
					strXML.append("<NAME>" + makeListField(docXML.getElementsByTagName("SC2").item(j).getTextContent()) +"</NAME>");
					strXML.append("<WIDTH>" + "250" + "</WIDTH>");
					strXML.append("</HEADER>");
				}
				// '제 3 특수목록
				if(makeListField(docXML.getElementsByTagName("SC3").item(j).getTextContent()).equals("")){
				   scYn[2]=false;
				}
				else{
					scYn[2]=true;
					strXML.append("<HEADER>");
					strXML.append("<NAME>" + makeListField(docXML.getElementsByTagName("SC3").item(j).getTextContent()) +"</NAME>");
					strXML.append("<WIDTH>" + "250" + "</WIDTH>");
					strXML.append("</HEADER>");
				}	
			}
			else{ // 리스트뷰 Rows 부분이다.
				strXML.append("<ROW>");
				strXML.append("<CELL>");
				strXML.append("<VALUE>" + scSn + "</VALUE>");
				strXML.append("</CELL>");
				if(scYn[0]){
					strXML.append("<CELL>");
					strXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SC1").item(j).getTextContent()) + "</VALUE>");
					strXML.append("</CELL>");
				}
				if(scYn[1]){
					strXML.append("<CELL>");
					strXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SC2").item(j).getTextContent()) + "</VALUE>");
					strXML.append("</CELL>");
				}
				if(scYn[2]){
					strXML.append("<CELL>");
					strXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SC3").item(j).getTextContent()) + "</VALUE>");
					strXML.append("</CELL>");
				}
				strXML.append("</ROW>");
			}
			
		}
		strXML.append("</ROWS>");
		strXML.append("</HEADERS>");
		strXML.append("</LISTVIEWDATA>");
		
		
		return strXML.toString();
	}

	@Override
	public String getCabinetPrintInfo(Document xmlDom, String lang, int tenantID)	throws Exception {
		StringBuilder strXML = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String cabinetID = xmlDom.getElementsByTagName("CABINETID").item(0).getTextContent().trim();
		String langType = xmlDom.getElementsByTagName("STRTYPE").item(0).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabinetID.trim());
		map.put("v_TENANTID", tenantID);

		String userName = null;
		List<ApprGRecordVO> userNameList = ezApprovalGDAO.selectUserName(map);
		if ( userNameList.size() > 0 ) {
			for(int j=0; j<userNameList.size(); j++ ) {
				userName += userNameList.get(j).getUserName() + ",";
			}
		}
		map.put("v_userName", userName);
		int cabID = ezApprovalGDAO.selectCabID(map);
		int cabID2 = ezApprovalGDAO.selectCabID2(map);
		map.put("v_cabID", cabID + cabID2);
		
		List<ApprGTaskVO> docList = ezApprovalGDAO.getCabinetDetailInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("ROW").getLength() <= 0) {
			return "<RESULT>NORECORD</RESULT>";
		}
		
		strXML.append("<CABINFO>");
		strXML.append("<BASICINFO>");
		strXML.append("<CABINETID>" + docXML.getElementsByTagName("CABINETID").item(0).getTextContent() + "</CABINETID>");  // '기록물철 아이디
		strXML.append("<CABCLASSNO>" + docXML.getElementsByTagName("CABINETCLASSNO").item(0).getTextContent() + "</CABCLASSNO>");  // '기록물철 분류번호
		strXML.append("<TITLE>" + docXML.getElementsByTagName("TITLE").item(0).getTextContent() + "</TITLE>"); // '제목
		strXML.append("<CABCLASSID>" + getCabinetNo(docXML.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent(), // '기록물철 분류기호
				makeListField(docXML.getElementsByTagName("TASKCODE").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent()),
				makeListField(docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent())) + "</CABCLASSID>");
		strXML.append("<RECTYPE>" + getRecordTypeString(docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent(),companyID,langType, tenantID) + "</RECTYPE>");// '기록물형태
		strXML.append("<DEPTNAME>" + docXML.getElementsByTagName("PROCESSDEPTNAME" + commonUtil.getMultiData(langType, tenantID)).item(0).getTextContent() + "</DEPTNAME>"); // '처리과 이름
		strXML.append("<TASKNAME>" + docXML.getElementsByTagName("TASKNAME" + commonUtil.getMultiData(langType, tenantID)).item(0).getTextContent() + "</TASKNAME>"); // '단위업무 이름
		strXML.append("<PRODUCEY>" + docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent() + "</PRODUCEY>"); // '생산년도
		strXML.append("<REGSN>" + docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent() + "</REGSN>"); 	// '등록연번
		strXML.append("<VOLNO>" + docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent() + "</VOLNO>"); // '권호수
		strXML.append("<REGDATE>" + formatDateForView(docXML.getElementsByTagName("CREATEDATE").item(0).getTextContent(),0) + "</REGDATE>"); // '등록일자
		strXML.append("<SCFLAG>" + docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent() + "</SCFLAG>"); // '특수목록 플래그
		strXML.append("</BASICINFO>");
		
		strXML.append("<EXTRAINFO>");
		strXML.append("<NUMOFREC>" + docXML.getElementsByTagName("NUMOFREC").item(0).getTextContent() + "</NUMOFREC>"); // '기록물등록건수
		strXML.append("<NUMOFPAGE>" + docXML.getElementsByTagName("NUMOFPAGE").item(0).getTextContent() + "</NUMOFPAGE>"); // '기록물쪽수
		strXML.append("<NUMOFFILE>" + docXML.getElementsByTagName("NUMOFFILE").item(0).getTextContent() + "</NUMOFFILE>"); // ''전자파일갯수
		strXML.append("<MODIFYFLAG>" + docXML.getElementsByTagName("MODIFYFLAG").item(0).getTextContent() + "</MODIFYFLAG>"); // '수정여부
		strXML.append("<OLDFLAG>" + docXML.getElementsByTagName("OLDCABINETFLAG").item(0).getTextContent() + "</OLDFLAG>"); // '구기록물 여부
		strXML.append("<OLDCREATEORGAN>" + docXML.getElementsByTagName("CREATEORGANNAME").item(0).getTextContent() + "</OLDCREATEORGAN>");// '구기록물철 생산기관
		strXML.append("<OLDCLASSNO>" + docXML.getElementsByTagName("CLASSIFICATIONNO").item(0).getTextContent() + "</OLDCLASSNO>"); // '구기록물 여부
		strXML.append("</EXTRAINFO>");
		
		strXML.append("<CLASSINFO>");
		strXML.append("<ENDY>" + docXML.getElementsByTagName("EXPIRATIONYEAR").item(0).getTextContent() + "</ENDY>"); // 종료년도
		strXML.append("<KEEPPERIOD>" + getKeepPeriodString(docXML.getElementsByTagName("KEEPINGPERIOD").item(0).getTextContent(),companyID,langType, tenantID) + "</KEEPPERIOD>"); // 보존기간
		strXML.append("<KEEPMETHOD>" + getKeepMethodString(docXML.getElementsByTagName("KEEPINGMETHOD").item(0).getTextContent(),companyID,langType, tenantID) + "</KEEPMETHOD>"); // 보존방법
		strXML.append("<KEEPPLACE>" + getKeepPlaceString(docXML.getElementsByTagName("KEEPINGPLACE").item(0).getTextContent(),companyID,langType, tenantID) + "</KEEPPLACE>"); // 보존장소
		strXML.append("<DISPENDDATE>" + docXML.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent() + "</DISPENDDATE>"); 	// 비치종결일자
		strXML.append("<DISPREASON>" + docXML.getElementsByTagName("DISPLAYREASON").item(0).getTextContent() + "</DISPREASON>"); // 비치사유
		strXML.append("<CABCHARGER>" + docXML.getElementsByTagName("CABCHARGER").item(0).getTextContent() + "</CABCHARGER>");// 업무담당자
		strXML.append("<CONFIRMFLAG>" + docXML.getElementsByTagName("CONFIRMFLAG").item(0).getTextContent() + "</CONFIRMFLAG>"); // 편철확정여부
		strXML.append("<CATATRANSFLAG>" + docXML.getElementsByTagName("CATALOGTRANSFERFLAG").item(0).getTextContent() + "</CATATRANSFLAG>"); // 목록이관여부
		strXML.append("<CATATRANSYEAR>" + docXML.getElementsByTagName("CATALOGTRANSFERYEAR").item(0).getTextContent() + "</CATATRANSYEAR>"); // 목록이관연도
		strXML.append("<DOCTRANSFLAG>" + docXML.getElementsByTagName("DOCTRANSFERFLAG").item(0).getTextContent() + "</DOCTRANSFLAG>"); // 파일이관여부
		strXML.append("<DOCTRANSYEAR>" + docXML.getElementsByTagName("DOCTRANSFERYEAR").item(0).getTextContent() + "</DOCTRANSYEAR>"); // 파일이관연도
		strXML.append("</CLASSINFO>");
		
		strXML.append("<TRANSINFO>");
		strXML.append("<CABTRANSFLAG>" + docXML.getElementsByTagName("CABINETTRANSFERFLAG").item(0).getTextContent() + "</CABTRANSFLAG>"); // 인수인계 구분
		strXML.append("<TCABID>" + docXML.getElementsByTagName("TCABINETID").item(0).getTextContent() + "</TCABID>"); // 인수 기록물철 아이디
		strXML.append("<TCABNAME>" + docXML.getElementsByTagName("TCABINETNAME" + commonUtil.getMultiData(langType, tenantID)).item(0).getTextContent() + "</TCABNAME>"); // 인수 기록물철 이름
		strXML.append("<TDEPTNAME>" + docXML.getElementsByTagName("TDEPTNAME"+ commonUtil.getMultiData(langType, tenantID)).item(0).getTextContent() + "</TDEPTNAME>"); // 인수 기록물철 처리과명
		strXML.append("<TDEPTCODE>" + docXML.getElementsByTagName("TDEPTCODE").item(0).getTextContent() + "</TDEPTCODE>"); // 인수 기록물철 처리과 코드
		strXML.append("<TTASKNAME>" + docXML.getElementsByTagName("TASKNAME").item(0).getTextContent() + "</TTASKNAME>"); // 인수기록물철 단위업무명
		strXML.append("<TTASKCODE>" + (docXML.getElementsByTagName("TASKCODE").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TASKCODE").item(0).getTextContent()) + "</TTASKCODE>");// 인수기록물철 단위업무 코드
		strXML.append("<TPRODUCEY>" + (docXML.getElementsByTagName("TPRODUCEYEAR").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("TPRODUCEYEAR").item(0).getTextContent())+ "</TPRODUCEY>");// 인수기록물철 생산연도
		strXML.append("<TREGSN>" + (docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent() == null ? "" : docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent()) + "</TREGSN>");// 인수기록물철 등록연번
		strXML.append("<TVOLNO>" + docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent() + "</TVOLNO>");// 인수기록물철 권호수
		strXML.append("<TRANSDATE>" + formatDateForView(docXML.getElementsByTagName("TRANSFERDATE").item(0).getTextContent(),1) + "</TRANSDATE>");// 인수/인계일자
		strXML.append("</TRANSINFO>");
		strXML.append("</CABINFO>");
		return strXML.toString();
	}

	@Override
	public String getCabinetSimpleInfo(Document xmlDom, int tenantID) throws Exception {
		StringBuilder strXML = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String cabinetID = xmlDom.getElementsByTagName("CABINETID").item(0).getTextContent();
		String langType = xmlDom.getElementsByTagName("STRTYPE").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabinetID.trim());
		map.put("v_TENANTID", tenantID);

		List<ApprGTaskVO> docList = ezApprovalGDAO.getCabinetSimpleInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("ROW").getLength() <= 0) {
			return "<RESULT>NORECORD</RESULT>";
		}
		strXML.append("<RESULT>");
		strXML.append("<CABINETID>" + docXML.getElementsByTagName("CABINETID").item(0).getTextContent() + "</CABINETID>");  
		strXML.append("<CABCLASSNO>" + docXML.getElementsByTagName("CABINETCLASSNO").item(0).getTextContent() + "</CABCLASSNO>");  
		strXML.append("<TASKCODE>" + docXML.getElementsByTagName("TASKCODE").item(0).getTextContent() + "</TASKCODE>"); 
		strXML.append("<TITLE>" + docXML.getElementsByTagName("TITLE").item(0).getTextContent() + "</TITLE>"); 
		strXML.append("<RECTYPECODE>" + docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent() + "</RECTYPECODE>"); 
		strXML.append("<RECTYPEDES>" + getRecordTypeString(docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent(),companyID,langType, tenantID) + "</RECTYPEDES>"); 	
		strXML.append("<KEEPPERIOD>" + docXML.getElementsByTagName("KEEPINGPERIOD").item(0).getTextContent() + "</KEEPPERIOD>"); 
		strXML.append("<DISPLAYFLAG>" + (docXML.getElementsByTagName("DISPLAYRECFLAG").getLength() <= 0 ? "2" : docXML.getElementsByTagName("DISPLAYRECFLAG").item(0).getTextContent().trim()) + "</DISPLAYFLAG>"); 
		strXML.append("<DISPLAYENDDATE>" + docXML.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent().trim() + "</DISPLAYENDDATE>");
		strXML.append("<DISPLAYREASON>" + docXML.getElementsByTagName("DISPLAYREASON").item(0).getTextContent() + "</DISPLAYREASON>"); 
		strXML.append("<SPECIALFLAG>" + docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent() + "</SPECIALFLAG>"); 
		strXML.append("<SCINFO>"); 
		if(docXML.getElementsByTagName("SPECIALCATALOGFLAG").item(0).getTextContent().equals("1")){
			map.put("v_CABCLASSNO", docXML.getElementsByTagName("CABINETCLASSNO").item(0).getTextContent());
			
			List<ApprGTaskVO> docList2 = ezApprovalGDAO.getCabinetSimpleInfo2(map);
			StringBuffer sb2 = new StringBuffer();
	        sb2.append("<DATA>");
	        
	        for (int i = 0; i < docList2.size(); i++) {
				sb2.append(commonUtil.getQueryResult(docList2.get(i)));
			}
			sb2.append("</DATA>");
			
			Document docXML2 = commonUtil.convertStringToDocument(sb2.toString());
			
			for(int j=0; j<docXML2.getElementsByTagName("ROW").getLength();j++){
				String sepAttSN = makeListField(docXML2.getElementsByTagName("SERIALNO").item(j).getTextContent().trim());
			
				if(sepAttSN.trim().equals("000")){
					strXML.append("<NAME>");
					strXML.append("<SN>" + sepAttSN + "</SN>");
					strXML.append("<LIST1>" + makeListField(docXML2.getElementsByTagName("SC1").item(j).getTextContent()) +"</LIST1>");
					strXML.append("<LIST2>" + makeListField(docXML2.getElementsByTagName("SC2").item(j).getTextContent()) +"</LIST2>");
					strXML.append("<LIST3>" + makeListField(docXML2.getElementsByTagName("SC3").item(j).getTextContent()) +"</LIST3>");
					strXML.append("</NAME>");
				}
				else{
					strXML.append("<DATALIST>");
					strXML.append("<DATA>");
					strXML.append("<SN>" + sepAttSN + "</SN>");
					strXML.append("<LIST1>" + makeListField(docXML2.getElementsByTagName("SC1").item(j).getTextContent()) +"</LIST1>");
					strXML.append("<LIST2>" + makeListField(docXML2.getElementsByTagName("SC2").item(j).getTextContent()) +"</LIST2>");
					strXML.append("<LIST3>" + makeListField(docXML2.getElementsByTagName("SC3").item(j).getTextContent()) +"</LIST3>");
					strXML.append("</DATA>");
					strXML.append("</DATALIST>");
				}
			}
		}
		strXML.append("</SCINFO>");
		strXML.append("</RESULT>");
		return strXML.toString();
	}

	@Override
	public String changeCabinetInfo(Document xmlDom, int tenantID) throws Exception {
 		StringBuilder strSQL = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
 		String changeType = xmlDom.getElementsByTagName("MODIFYFLAG").item(0).getTextContent();
		
		if(changeType.equals("0")){ // 기본등록사항 변경 시
			strSQL = ChangeCabBasicInfo(xmlDom, tenantID);
		}
		else{
			strSQL = ChangeCabExtraInfo(xmlDom);
		}
		if(strSQL.equals("FALSE")){
			return "<RESULT>FALSE</RESULT>";
		}
		Boolean result = ExecuteTransactionSQL(strSQL, companyID);
		
		if(result){
			return "<RESULT>TRUE</RESULT>";
		}
		else{
			return "<RESULT>FALSE</RESULT>";
		}
	}

	private StringBuilder ChangeCabExtraInfo(Document xmlDom) {
		StringBuilder strSQL = new StringBuilder();
		String cabClassNo = xmlDom.getElementsByTagName("CABCLASSNO").item(0).getTextContent();
		String userID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent();
		String usreName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent();
		String usreName2 = xmlDom.getElementsByTagName("USERNAME2").item(0).getTextContent();
		String keepPeriod = xmlDom.getElementsByTagName("KEEPPERIOD").item(0).getTextContent().trim();
		String displayEndDate = xmlDom.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent().trim();
		String displayReason = xmlDom.getElementsByTagName("DISPLAYREASON").item(0).getTextContent();
		String changeReason = xmlDom.getElementsByTagName("CHANGEREASON").item(0).getTextContent();
		
		NodeList nodeSC = xmlDom.getElementsByTagName("SCINFO");
		
		 strSQL.append("Declare v_NewVersion Number := 0;\n BEGIN \n ");
         strSQL.append("Select NVL(max(Version), 0)+1 INTO v_NewVersion From TBL_CABINETHISTORY  ");
		 strSQL.append("Where CabinetClassNo = '" + makeRightField(cabClassNo) + "';\n");
		 strSQL.append("IF v_NewVersion < 2 THEN\n");
		 strSQL.append("BEGIN \n ");
		 strSQL.append("Insert Into TBL_CABINETHISTORY (Version, CabinetClassNo, Title, RecTypeCode, ");
		 strSQL.append("ModifyDate, KeepingPeriod, DisplayEndDate, DisplayReason, ModifyReason, ");
		 
         // 2010.08.02 다국어 
         strSQL.append("ModifierID, ModifierName, ModifierName2, ModifyFlag, DelFlag) ");
		 strSQL.append("Select v_NewVersion, CabinetClassNo, Title, RecTypeCode, ");
         strSQL.append("UTILS.CONVERT_TO_CHAR(CreateDate,8,p_style=>112), KeepingPeriod, DisplayEndDate, ");
         // 2010.08.02 다국어 
         strSQL.append("DisplayReason, NULL, OwnerID, OwnerName, OwnerName2, '1', '0' ");
         strSQL.append("From TBL_CABINETCLASS  Where TBL_CABINETCLASS.CabinetClassNo = '");
		 strSQL.append(makeRightField(cabClassNo) + "'; \n END; \n END IF; \n");

			// '기록물철 분류정보 테이블을 업데이트 한다.
		strSQL.append("Update TBL_CABINETCLASS Set KeepingPeriod = '");
		strSQL.append(makeRightField(keepPeriod) + "', DisplayEndDate = '");
		strSQL.append(makeRightField(displayEndDate) + "', DisplayReason='");
		strSQL.append(makeRightField(displayReason) + "', ModifyFlag = '1' ");
		strSQL.append("Where CabinetClassNo = '" + makeRightField(cabClassNo) + "';\n ");

		strSQL.append("Insert Into TBL_CABINETHISTORY (Version, CabinetClassNo, Title, ");
		strSQL.append("RecTypeCode, ModifyDate, KeepingPeriod, DisplayEndDate, DisplayReason, ");
        strSQL.append("ModifyReason, ModifierID, ModifierName, ModifierName2, ModifyFlag, DelFlag) Select ");
        strSQL.append("(Select NVL(MAX(version), 0)+1 From TBL_CABINETHISTORY  Where ");
		strSQL.append("CabinetClassNo = '" + makeRightField(cabClassNo) + "'), CabinetClassNo, ");
        strSQL.append("Title, RecTypeCode, UTILS.CONVERT_TO_CHAR(SYSDATE,8,p_style=>112), KeepingPeriod, ");
		strSQL.append("DisplayEndDate, DisplayReason, N'" + makeRightField(changeReason) + "', '");
        // 2010.08.02 다국어 
        strSQL.append(makeRightField(userID) + "', N'" + makeRightField(usreName) + "', N'" + makeRightField(usreName2));
        strSQL.append("', '1', '0' From TBL_CABINETCLASS  Where TBL_CABINETCLASS.CabinetClassNo = '" + makeRightField(cabClassNo) + "';\n END; \n ");
			
         return strSQL;
	}

private StringBuilder ChangeCabBasicInfo(Document xmlDom, int tenantID) {
		
		StringBuilder strSQL = new StringBuilder();
		StringBuilder subSQL = new StringBuilder();
		String cabClassNo = xmlDom.getElementsByTagName("CABCLASSNO").item(0).getTextContent();
		String userID = xmlDom.getElementsByTagName("USERID").item(0).getTextContent().trim();
		String usreName = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent().trim();
		String usreName2 = xmlDom.getElementsByTagName("USERNAME2").item(0).getTextContent().trim();
		String title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent();
		String recTypeCode = xmlDom.getElementsByTagName("RECTYPECODE").item(0).getTextContent();
		String changeReason = xmlDom.getElementsByTagName("CHANGEREASON").item(0).getTextContent();
		String SCFlag = xmlDom.getElementsByTagName("SCFLAG").item(0).getTextContent().trim();
		
		strSQL.append("Declare v_NewVersion Number := 0; \n BEGIN \n");
        strSQL.append("Select NVL(max(Version), 0)+1 INTO v_NewVersion From TBL_CABINETHISTORY  ");
		strSQL.append("Where CabinetClassNo = '" + makeRightField(cabClassNo) + "';\n");
		strSQL.append("IF v_NewVersion < 2 THEN\n");
		strSQL.append("BEGIN \n");
		strSQL.append("Insert Into TBL_CABINETHISTORY (Version, CabinetClassNo, Title, RecTypeCode, ");
		strSQL.append("ModifyDate, KeepingPeriod, DisplayEndDate, DisplayReason, ModifyReason, ");
        strSQL.append("ModifierID, ModifierName, ModifierName2, ModifyFlag, DelFlag, TENANT_ID) Select v_NewVersion, ");
        strSQL.append("CabinetClassNo, Title, RecTypeCode, UTILS.CONVERT_TO_CHAR(CreateDate,8,p_style=>112), ");
        // 2010.08.02 다국어 
        strSQL.append("KeepingPeriod, DisplayEndDate, DisplayReason, NULL, OwnerID, OwnerName, OwnerName2, ");
        strSQL.append("'0','0',TENANT_ID From TBL_CABINETCLASS  Where TBL_CABINETCLASS.CabinetClassNo = '");
		strSQL.append(makeRightField(cabClassNo) + "' AND TENANT_ID =" +tenantID +"; \n");

		if (SCFlag.equals("1"))
        {
			strSQL.append("Insert Into TBL_SCHISTORY_CAB (Version, CabinetClassNo, SerialNo, ");
			strSQL.append("SC1, SC2, SC3, TENANT_ID) Select v_NewVersion, CabinetClassNo, SerialNo, SC1, ");
            strSQL.append("SC2, SC3, TENANT_ID From TBL_SPECIALCATALOGINFO_CAB  Where CabinetClassNo = '"  );
			strSQL.append(makeRightField(cabClassNo) + "' AND TENANT_ID="+tenantID +";\n ");
        }

		strSQL.append("END; \n END IF; \n");

		strSQL.append("Update TBL_CABINETCLASS Set Title = '" + makeRightField(title));
		strSQL.append("', RecTypeCode = '" + makeRightField(recTypeCode) + "', ModifyFlag = '1' ");
		strSQL.append("Where CabinetClassNo = '" + makeRightField(cabClassNo) + "' AND TENANT_ID =" + tenantID +" ;\n");

		strSQL.append("Insert Into TBL_CABINETHISTORY (Version, CabinetClassNo, Title, ");
		strSQL.append("RecTypeCode, ModifyDate, KeepingPeriod, DisplayEndDate, DisplayReason, ");
        strSQL.append("ModifyReason, ModifierID, ModifierName, ModifierName2, ModifyFlag, DelFlag, TENANT_ID) Select ");
        strSQL.append("(Select NVL(MAX(version), 0)+1 From TBL_CABINETHISTORY  Where ");
		strSQL.append("CabinetClassNo = '" + makeRightField(cabClassNo) + "'), CabinetClassNo, ");
        strSQL.append("Title, RecTypeCode, UTILS.CONVERT_TO_CHAR(SYSDATE,8,p_style=>112), KeepingPeriod, ");
		strSQL.append("DisplayEndDate, DisplayReason, N'" + makeRightField(changeReason) + "', '");
        // 2010.08.02 다국어 
        strSQL.append(makeRightField(userID) + "', N'" + makeRightField(usreName) + "', N'" + makeRightField(usreName2));
        strSQL.append("', '0', '0' , TENANT_ID From TBL_CABINETCLASS  Where TBL_CABINETCLASS.CabinetClassNo = '" );
		strSQL.append(makeRightField(cabClassNo) + "' AND TENANT_ID = " + tenantID+";\n  END;");

		subSQL = ChangeSpecialInfo_Cab(cabClassNo, xmlDom, tenantID);

		if (subSQL.equals("FALSE")){
			return subSQL;
		}
		else{
			strSQL.append(subSQL);
		}

		return strSQL;
	}

private StringBuilder ChangeSpecialInfo_Cab(String cabClassNo, Document xmlDom, int tenantID) {
	StringBuilder strSQL = new StringBuilder();
	// '## 기존의 특수목록을 모두 지운다.
    strSQL.append("Delete From TBL_SPECIALCATALOGINFO_CAB Where CabinetClassNo = '");
	strSQL.append(makeRightField(cabClassNo) + "' And SerialNo != '000' AND TENANT_ID = " + tenantID +";\n");

	// '## 특수목록 데이터 입력
	NodeList nodesData = xmlDom.getElementsByTagName("SCDATA");

	if (nodesData.getLength() > 0)
	{
		for (int i=0; i<nodesData.getLength(); i++)
		{
			strSQL.append("INSERT INTO TBL_SPECIALCATALOGINFO_CAB (CabinetClassNo, SerialNo, SC1, SC2, SC3, TENANT_ID) Values ('");
			strSQL.append(makeRightField(cabClassNo) + "', '");
			strSQL.append(makeRightField(nodesData.item(i).getChildNodes().item(0).getTextContent().trim()) + "', N'");
			strSQL.append(makeRightField(nodesData.item(i).getChildNodes().item(1).getTextContent().trim()) + "', N'");
			strSQL.append(makeRightField(nodesData.item(i).getChildNodes().item(2).getTextContent().trim()) + "', N'");
            strSQL.append(makeRightField(nodesData.item(i).getChildNodes().item(3).getTextContent().trim()) + "'," + tenantID +");\n");
		}
	}
	  strSQL.append("Declare v_NewVersion2 Number :=0; \n BEGIN \n");
      strSQL.append("Select NVL(max(Version), 0) INTO v_NewVersion2 From TBL_CABINETHISTORY ");
	  strSQL.append("Where CabinetClassNo = '" + makeRightField(cabClassNo) + "';\n");
	  strSQL.append("Insert Into TBL_SCHISTORY_CAB (Version, CabinetClassNo, SerialNo, SC1, SC2, SC3 ,TENANT_ID) ");
	  strSQL.append("Select v_NewVersion2, CabinetClassNo, SerialNo, SC1, SC2, SC3, TENANT_ID ");
      strSQL.append("From TBL_SPECIALCATALOGINFO_CAB  Where CabinetClassNo = '" );
      strSQL.append(makeRightField(cabClassNo) + "' AND TENANT_ID = " + tenantID +";\n END; \n ");
      return strSQL;
}

	@Override
	public String getCabinetHistory(Document xmlDom, LoginVO userInfo) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String cabClassNo = xmlDom.getElementsByTagName("CABCLASSNO").item(0).getTextContent();
		String langType = xmlDom.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABCLASSNO", cabClassNo.trim());
		map.put("v_TENANTID", userInfo.getTenantId());
		
		List<ApprGCabinetVO> docList = ezApprovalGDAO.getCabinetHistory(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		strSQL.append("<LISTVIEWDATA>");
		strSQL.append("<HEADERS>");
		
		String listString = "";
		listString = getListHeader("099", companyID, langType, userInfo.getTenantId());
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		for(int i=0; i<listXML.getElementsByTagName("NAME").getLength(); i++){
			strSQL.append("<HEADER>");
			strSQL.append("<NAME>" + listXML.getElementsByTagName("NAME").item(i).getTextContent() + "</NAME>");
			strSQL.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(i).getTextContent() + "</WIDTH>");
			strSQL.append("</HEADER>");
		}
		strSQL.append("</HEADERS>");
		strSQL.append("<ROWS>");
		
		for(int j=0; j<docXML.getElementsByTagName("ROW").getLength(); j++){
			strSQL.append("<ROW>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + makeListField(docXML.getElementsByTagName("VERSION").item(j).getTextContent()) + "</VALUE>");
			strSQL.append("<DATA1>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(j).getTextContent()) + "</DATA1>");
			strSQL.append("<DATA2>" + makeListField(docXML.getElementsByTagName("VERSION").item(j).getTextContent()) + "</DATA2>");
			strSQL.append("<DATA3>" + makeListField(docXML.getElementsByTagName("MODIFYREASON").item(j).getTextContent()) + "</DATA3>");
			strSQL.append("</CELL>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TITLE").item(j).getTextContent()) + "</VALUE>");
			strSQL.append("</CELL>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(j).getTextContent()),companyID,langType, userInfo.getTenantId()) + "</VALUE>");
			strSQL.append("</CELL>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>"); 
			if(makeListField(docXML.getElementsByTagName("MODIFYFLAG").item(j).getTextContent()).equals("0")){
				strSQL.append(langType.equals("1")? messageSource.getMessage("ezApprovalG.pjj23", userInfo.getLocale()) : "BasicRegItems");
			}
			else{
				strSQL.append(langType.equals("1")? messageSource.getMessage("ezApprovalG.pjj24", userInfo.getLocale()) : "PreClassitems");
			}
			strSQL.append("</VALUE>") ;
			strSQL.append("</CELL>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MODIFIERNAME").item(j).getTextContent()) + "</VALUE>");
			strSQL.append("</CELL>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MODIFYDATE").item(j).getTextContent()) + "</VALUE>");
			strSQL.append("</CELL>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MODIFIERNAME2").item(j).getTextContent()) + "</VALUE>");
			strSQL.append("</CELL>");
			strSQL.append("</ROW>");
		}
		strSQL.append("</ROWS>");
		
		strSQL.append("</LISTVIEWDATA>");
		return strSQL.toString();
	}

	@Override
	public String getTaskCharger(Document xmlDom, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String cabClassNo = xmlDom.getElementsByTagName("CABCLASSNO").item(0).getTextContent();
		String deptCode = xmlDom.getElementsByTagName("DEPTCODE").item(0).getTextContent();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		 //2010.07.30 Header로 변경
		String listString = "";
		listString = getListHeader("110", companyID, lang, tenantID);
		String strMultiData = commonUtil.getMultiData(lang, tenantID);
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		strSQL.append("<LISTVIEWDATA>");
		strSQL.append("<HEADERS>");
		strSQL.append("<ROWS>");
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		for(int i=0; i<hlength; i++){
			strSQL.append("<HEADER>");
			strSQL.append("<NAME>" + listXML.getElementsByTagName("NAME").item(0).getTextContent() + "</NAME>");
			strSQL.append("<WIDTH>" + listXML.getElementsByTagName("WIDTH").item(0).getTextContent() + "</WIDTH>");
			strSQL.append("</HEADER>");
		}
		
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABCLASSNO", cabClassNo.trim());
		map.put("v_TENANTID", tenantID);
		
		List<ApprGRecordVO> docList = ezApprovalGDAO.getTaskCharger(map);
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		for(int j = 0; j< docXML.getElementsByTagName("ROW").getLength(); j++){
			strSQL.append("<ROW>");
			strSQL.append("<CELL>");
			strSQL.append("<VALUE>" + makeListField(docXML.getElementsByTagName("USERNAME" + strMultiData).item(j).getTextContent()) + "</VALUE>");
			strSQL.append("<DATA1>" + makeListField(docXML.getElementsByTagName("USER_ID").item(j).getTextContent()) + "</DATA1>");
			strSQL.append("<DATA2>" + makeListField(docXML.getElementsByTagName("USERNAME" + strMultiData).item(j).getTextContent()) + "</DATA2>");
			strSQL.append("<DATA3>" + makeListField(docXML.getElementsByTagName("USERNAME" + strMultiData).item(j).getTextContent()) + "</DATA3>");
			strSQL.append("</CELL>");
			strSQL.append("</ROW>");
		}
		strSQL.append("</ROWS>");
		strSQL.append("</HEADERS>");
		strSQL.append("</LISTVIEWDATA>");
		return strSQL.toString();
	}

	@Override
	public String saveCabRoleInfo(Document xmlDom, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder("");
		String cabClassNo = xmlDom.getElementsByTagName("CABCLASSNO").item(0).getTextContent();
		String idList = xmlDom.getElementsByTagName("USERID").item(0).getTextContent();
		String nameList = xmlDom.getElementsByTagName("USERNAME").item(0).getTextContent();
		String nameList2 = xmlDom.getElementsByTagName("USERNAME2").item(0).getTextContent();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();

		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_CABCLASSNO", cabClassNo);
		map.put("v_TENANTID", tenantID);

		ezApprovalGDAO.deleteTbCabRoleInfo(map);

		String idListIndex[] = idList.split(",");
		String nameListIndex[] = nameList.split(",");
		String nameList2Index[] = nameList2.split(",");
		
		int end = idList.indexOf(",");
		int end2 = idList.indexOf(",");
		int end3 = idList.indexOf(",");
		
		for(int i=0; i<idListIndex.length; i++) {
			if(end <= 0) {
				end = idList.length()+1;
			} 
			
			if(end2 <= 0) {
				end2 = nameList.length()+1;
			} 
			
			if(end3 <= 0) {
				end3 = nameList2.length()+1;
			} 
			
			map.put("v_ArrayString", idListIndex[i]);
			map.put("v_ArrayString1", nameListIndex[i]);
			map.put("v_ArrayString2", nameList2Index[i]);
			
			ezApprovalGDAO.insertTbCabRoleInfo(map);
		}
		
		return "<RESULT>TRUE</RESULT>";
	}

	@Override
	public String updateReceiptOffer(String docID, String orgDocID,	String companyID, int tenantID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_ORGDOCID", orgDocID.trim());
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		try{
	    ezApprovalGDAO.updateReceiptOffer(map);
	    return "<RESULT>TRUE</RESULT>";
		}
		catch(Exception e){
			System.out.println(e.getMessage());
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String doSendOffer(Document xmlDom, String dirPath,	String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder("");
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String orgDocID = xmlDom.getElementsByTagName("ORGDOCID").item(0).getTextContent();
		String docTitle = xmlDom.getElementsByTagName("DOCTITLE").item(0).getTextContent();
		String html = xmlDom.getElementsByTagName("HTML").item(0).getTextContent();
		String href = xmlDom.getElementsByTagName("HREF").item(0).getTextContent();
		String userID = xmlDom.getElementsByTagName("SIMSAUSERID").item(0).getTextContent();
		String userName = xmlDom.getElementsByTagName("SIMSAUSERNAME").item(0).getTextContent();
		String userJobTitle = xmlDom.getElementsByTagName("SIMSAUSERJOBTITLE").item(0).getTextContent();
		
		String deptID = xmlDom.getElementsByTagName("SIMSAUSERDEPTID").item(0).getTextContent();
		String deptName = xmlDom.getElementsByTagName("SIMSAUSERDEPTNAME").item(0).getTextContent();
		String userName2 = xmlDom.getElementsByTagName("SIMSAUSERNAME2").item(0).getTextContent();
		String deptName2 = xmlDom.getElementsByTagName("SIMSAUSERDEPTNAME2").item(0).getTextContent();
		String userJobTitle2 = xmlDom.getElementsByTagName("SIMSAUSERJOBTITLE2").item(0).getTextContent();
		String gFlag = getCode2Name("A35", "002", companyID, lang, tenantID).toUpperCase().trim();
		LOGGER.debug("getCode2Name ended.");
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", orgDocID);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		List<ApprGDocListVO> signList = ezApprovalGDAO.doSendOffer_endDocInfo(map);
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < signList.size(); i++) {
			sb.append(commonUtil.getQueryResult(signList.get(i)));
		}
		sb.append("</DATA>");
		
		Document signXML = commonUtil.convertStringToDocument(sb.toString());
		
		String sentDeptID="";
		String sentDeptName="";
		String sentDeptName2="";
		
		if(signXML.getDocumentElement().getChildNodes().getLength()>0){
			if(docTitle.trim().equals("")){
				docTitle = makeListField(signXML.getElementsByTagName("DOCTITLE").item(0).getTextContent());
			}
			 strSQL.append("UPDATE TBL_APRDOCINFO SET OrgDocID = '" + makeRightField(orgDocID));
             strSQL.append("', DocType = '" + makeRightField(makeListField(signXML.getElementsByTagName("DOCTYPE").item(0).getTextContent())));
             strSQL.append("', DocState = '" + staDSSimSa + "', FunctionType = '" + staASJinHang);
             strSQL.append("', Href = '" + makeRightField(href));
             strSQL.append("', DocTitle = N'" + makeRightField(docTitle));
             strSQL.append("', DocNo = N'" + makeRightField(makeListField(signXML.getElementsByTagName("DOCNO").item(0).getTextContent())));
             strSQL.append("', HasAttachYN = '" + makeRightField(makeListField(signXML.getElementsByTagName("HASATTACHYN").item(0).getTextContent())));
             strSQL.append("', HasOpinionYN = 'N");
             
             String startDate = ezApprovalGDAO.getStartDateTime(map);
             String endDate = ezApprovalGDAO.getEndDateTime(map);
             
             
             strSQL.append("', StartDate = TO_Date('" + startDate.substring(0, startDate.length()-2) + "', 'YYYY-MM-DD HH24:MI:SS'), EndDate = TO_DATE('" + endDate.substring(0, endDate.length()-2) + "', 'YYYY-MM-DD HH24:MI:SS')");
             strSQL.append(", WriterID = '" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERID").item(0).getTextContent())));
             strSQL.append("', WriterName = N'" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERNAME").item(0).getTextContent())));
             strSQL.append("', WriterName2 = N'" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent())));
             strSQL.append("', WriterJobTitle = N'" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERJOBTITLE").item(0).getTextContent())));
             strSQL.append("', WriterJobTitle2 = N'" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERJOBTITLE2").item(0).getTextContent())));
             strSQL.append("', WriterDeptID = '" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent())));
             strSQL.append("', WriterDeptName = N'" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent())));
             strSQL.append("', WriterDeptName2 = N'" + makeRightField(makeListField(signXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent())));
             
             if(makeListField(signXML.getElementsByTagName("ISPUBLIC").item(0).getTextContent().trim()).equals("")){
            	 strSQL.append("' WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID +";\n");
             }
             else{
            	   strSQL.append("', isPublic = '" + makeRightField(makeListField(signXML.getElementsByTagName("ISPUBLIC").item(0).getTextContent())));
                   strSQL.append("' WHERE DocID = '" + docID + "' AND TENANT_ID = " + tenantID +";\n");
             }
         	sentDeptID = makeListField(signXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent());
            sentDeptName = makeListField(signXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent());
            sentDeptName2 = makeListField(signXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent());
		}
	
		List<ApprGDocListVO> signList2 = ezApprovalGDAO.doSendOffer_expendDocInfo(map);
		StringBuffer sb2 = new StringBuffer();
        sb2.append("<DATA>");
        
        for (int i = 0; i < signList2.size(); i++) {
			sb2.append(commonUtil.getQueryResult(signList2.get(i)));
		}
		sb2.append("</DATA>");
		
		Document signXML2 = commonUtil.convertStringToDocument(sb2.toString());
		
		if(signXML2.getDocumentElement().getChildNodes().getLength()>0){
			strSQL.append("UPDATE TBL_EXPAPRDOCINFO SET FormName = N'");
			strSQL.append(makeRightField(makeListField(signXML2.getElementsByTagName("FORMNAME").item(0).getTextContent())) + "', FormName2 = N'");
            strSQL.append(makeRightField(makeListField(signXML2.getElementsByTagName("FORMNAME2").item(0).getTextContent())) + "' ");

			if (!makeListField(signXML2.getElementsByTagName("SECURITYCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", SecurityCode = '" + makeRightField(makeListField(signXML2.getElementsByTagName("SECURITYCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("STORAGEPERIOD").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", StoragePeriod = '" + makeRightField(makeListField(signXML2.getElementsByTagName("STORAGEPERIOD").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("KEYWORD").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", KeyWord = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("KEYWORD").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("COMPANYID").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", companyID = '" + makeRightField(makeListField(signXML2.getElementsByTagName("COMPANYID").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("ITEMCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", ItemCode = '" + makeRightField(makeListField(signXML2.getElementsByTagName("ITEMCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("ITEMNAME").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", ItemName = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("ITEMNAME").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("ITEMNAME2").item(0).getTextContent()).trim().equals("")){
                strSQL.append(", ItemName = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("ITEMNAME2").item(0).getTextContent())) + "' ");
            }
            if (!makeListField(signXML2.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", UrgentApproval = '" + makeRightField(makeListField(signXML2.getElementsByTagName("URGENTAPPROVAL").item(0).getTextContent())) + "' ");
            }
			if (!makeListField(signXML2.getElementsByTagName("TEMPATTRIBUTE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", TempAttribute = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("TEMPATTRIBUTE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("STATUS").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", Status = '" + makeRightField(makeListField(signXML2.getElementsByTagName("STATUS").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", SpecialRecordCode = '" + makeRightField(makeListField(signXML2.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", PublicityCode = '" + makeRightField(makeListField(signXML2.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("LIMITRANGE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", LimitRange = '" + makeRightField(makeListField(signXML2.getElementsByTagName("LIMITRANGE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("PAGENUM").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", PageNum = '" + makeRightField(makeListField(signXML2.getElementsByTagName("PAGENUM").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("CABINETID").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", CabinetID = '" + makeRightField(makeListField(signXML2.getElementsByTagName("CABINETID").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("TASKCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", TaskCode = '" + makeRightField(makeListField(signXML2.getElementsByTagName("TASKCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("DOCNUMCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", DocNumCode = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("DOCNUMCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", OrgDocNumCode = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", SeperateAttachXML =N'" + makeRightField(makeListField(signXML2.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent())) + "' ");
			}
			if (!makeListField(signXML2.getElementsByTagName("SUMMARY").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", Summary = N'" + makeRightField(makeListField(signXML2.getElementsByTagName("SUMMARY").item(0).getTextContent())) + "' ");
			}
			// 수정(2005.09.29) : 보안결재 필드 추가
			if (!makeListField(signXML2.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent()).trim().equals("")){
				strSQL.append(", SecurityApproval = '" + makeRightField(makeListField(signXML2.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent())) + "' ");
			}
			strSQL.append(" WHERE DocID = '" + docID + "'  AND TENANT_ID = " + tenantID +";\n");
		}

		   int receivedSn = ezApprovalGDAO.getReceiptInfo_receivesNm(map);
		   receivedSn += 1;
		   if(!gFlag.equals("G")){
			   receivedSn = 0;
		   }
		   
		   strSQL.append("INSERT INTO TBL_APRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
           strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ProcessDate, ");
           strSQL.append("ProcessYN, ProcessDocID, ProcessorID, ProcessorName,ProcessorName2, ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID, TENANT_ID) ");
           strSQL.append("VALUES (" + Integer.toString(receivedSn) + ", '" + docID + "', '" + sentDeptID + "', N'");
           strSQL.append(sentDeptName + "', N'" + sentDeptName2 + "', '" + deptID + "', N'" + deptName + "', N'" + deptName2 + "', '" + staDSSimSa);
           strSQL.append("', '" + staASJinHang + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')");
           strSQL.append(", 'N', NULL, '" + userID + "', N'" + userName + "', N'" + userName2 + "', N'" + userJobTitle + "', N'" + userJobTitle2);
           strSQL.append("', '" + orgDocID + "'," + tenantID +");\n");
           
       	   map.put("v_DOCID", docID);
       	   map.put("companyID", companyID);
       	   map.put("v_TENANTID", tenantID);
       	   
       	   List<ApprGReceiptVO> signList3 = ezApprovalGDAO.doSendOffer_receiptId(map);
		   StringBuffer sb3 = new StringBuffer();
           sb3.append("<DATA>");
        
           for (int i = 0; i < signList3.size(); i++) {
        	   sb3.append(commonUtil.getQueryResult(signList3.get(i)));
		   }
		   sb3.append("</DATA>");
		
		   Document signXML3 = commonUtil.convertStringToDocument(sb3.toString());
		   String subSQL="";
		   for(int k=0; k<signXML3.getElementsByTagName("RECEIPTPOINTID").getLength(); k++){
			   subSQL = updateProcessYN(orgDocID, signXML3.getElementsByTagName("RECEIPTPOINTID").item(k).getTextContent().toString() , "0" , "QUERY", companyID, lang, tenantID );
			   if(subSQL.equals("FALSE")){
				   return "<RESULT>FALSE</RESULT>";
			   }
			   
		   }
		   if(gFlag.equals("G")){
			   strSQL.append("DELETE FROM TBL_APRATTACHINFO WHERE DocID = '" + docID + "' AND TENANT_ID =" + tenantID +";\n");
		       strSQL.append("INSERT INTO TBL_APRATTACHINFO (DocID, AttachFileSN, ");
               strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
               strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID) SELECT '" + docID);
			   strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
               strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach, TENANT_ID FROM ");
               strSQL.append("TBL_ENDATTACHINFO WHERE DocID = '" + orgDocID + "' AND TENANT_ID ="+ tenantID +";\n");
			   strSQL.append("DELETE FROM TBL_APRDOCATTACHINFO WHERE DocID = '" + docID + "' AND TENANT_ID ="+ tenantID +";\n");
			   strSQL.append("INSERT INTO TBL_APRDOCATTACHINFO (DocID, AttachSN, ");
               strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
               strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID) SELECT '" + docID);
			   strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
               strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, TENANT_ID FROM ");
               strSQL.append("TBL_ENDAPRDOCATTACHINFO WHERE DocID = '" + orgDocID + "' AND TENANT_ID= " +tenantID+";\n");
		   }
		   
			Boolean result = ExecuteTransactionSQL(strSQL, companyID);
			if(result){
				return "<RESULT>TRUE</RESULT>";
			}
			else{
				return "<RESULT>FALSE</RESULT>";
			}
	}

	@Override
	public String addBebu(Document xmlDom, String dirpath, String companyID, String lang, int tenantID) throws Exception {
 		StringBuilder strSQL = new StringBuilder("");
		String docID = xmlDom.getDocumentElement().getAttribute("DocID").trim();
		String receiveSN = xmlDom.getDocumentElement().getAttribute("ReceiveSN").trim();
		String sentDeptID = xmlDom.getDocumentElement().getAttribute("SendDeptID").trim();
		String receiveDeptID = xmlDom.getDocumentElement().getAttribute("ReceivedDeptID").trim();
		NodeList objRows = xmlDom.getDocumentElement().getChildNodes().item(0).getChildNodes();
		String subSQL ="";
		
		for(int i = 0; i<xmlDom.getDocumentElement().getChildNodes().getLength(); i++){
			subSQL = doBebuDoc(docID, xmlDom.getDocumentElement().getChildNodes().item(i).getChildNodes().item(0).getTextContent(),xmlDom.getDocumentElement().getChildNodes().item(i).getChildNodes().item(1).getTextContent(),xmlDom.getDocumentElement().getChildNodes().item(i).getChildNodes().item(2).getTextContent(),dirpath,sentDeptID,companyID,lang, tenantID);
		
			if(subSQL.toUpperCase().equals("FALSE")){
				return "<RESULT>FALSE</RESULT>";
			}
			else{
				strSQL.append(subSQL);
			}
		}
		
		Boolean rtn = ExecuteTransactionSQL(strSQL, companyID);
		if(rtn){
			sendRecvMsg(receiveDeptID,docID, "BEBU", companyID, lang, tenantID);
			return "<RESULT>TRUE</RESULT>";
		}else{
			return "<RESLUT>FALSE</RESULT>";
		}
	}

	@Override
	public String updateProcessYN2(String docID, String deptID, String deptName, String deptName2, String processYN, String mode, String companyID, String lang, int tenantID) throws Exception {
		StringBuilder strSQL = new StringBuilder("");
		String gFlag = getCode2Name("A35", "002", companyID , lang, tenantID);
		LOGGER.debug("getCode2Name ended.");
		if(!gFlag.equals("G")){
			strSQL.append("UPDATE TBL_ENDRECEIPTPOINTINFO SET ProcessYN = '" + processYN);
            strSQL.append("', ProcessDate = TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS')" );
            strSQL.append(" WHERE DocID = '" + docID.trim() + "' AND ReceiptPointID = '");
            strSQL.append(makeRightField(deptID.trim()) + "'," + tenantID + ";\n");
            
            Map<String , Object> map = new HashMap<String, Object>();
        	map.put("companyID", companyID);
            map.put("v_DOCID",docID.trim());
            map.put("v_RECEIPTPOINTID", deptID.trim());
            map.put("v_FLAG", "APR");
            map.put("v_TENANTID", tenantID);
            
			List<ApprGReceiptVO> signList = ezApprovalGDAO.updateProcessYNReceipt(map);
            StringBuffer sb = new StringBuffer();
            sb.append("<DATA>");
         
            for (int i = 0; i < signList.size(); i++) {
         	   sb.append(commonUtil.getQueryResult(signList.get(i)));
 		   }
 		   sb.append("</DATA>");
 		
 		   Document signXML = commonUtil.convertStringToDocument(sb.toString());
 		   if(signXML.getDocumentElement().getChildNodes().getLength()>0){
 			   deptName = makeListField(signXML.getElementsByTagName("RECEIPTPOINTNAME").item(0).getTextContent());
               deptName2 = makeListField(signXML.getElementsByTagName("RECEIPTPOINTNAME2").item(0).getTextContent());
 		   }
 		   if(deptName.trim().equals("")){
 			   map.put("v_DOCID", docID.trim());
 			   map.put("v_RECEIPTPOINTID", deptID.trim());
 			   map.put("v_FLAG", "END");
 	           map.put("companyID", companyID);
 	           map.put("v_TENANTID", tenantID);
 	          
 				List<ApprGReceiptVO> signList2 = ezApprovalGDAO.updateProcessYNReceipt(map);
 	           StringBuffer sb2 = new StringBuffer();
 	           sb2.append("<DATA>");
 	         
 	            for (int i = 0; i < signList2.size(); i++) {
 	         	   sb2.append(commonUtil.getQueryResult(signList2.get(i)));
 	 		   }
 	 		   sb2.append("</DATA>");
 	 		
 	 		   Document signXML2 = commonUtil.convertStringToDocument(sb2.toString());
 	 		   if(signXML.getDocumentElement().getChildNodes().getLength()>0){
 	 			  deptName = makeListField(signXML2.getElementsByTagName("RECEIPTPOINTNAME").item(0).getTextContent());
 	              deptName2 = makeListField(signXML2.getElementsByTagName("RECEIPTPOINTNAME2").item(0).getTextContent());
 	 		   }
 		   }
		}
		else{
			// 수정(2006.01.10) : 발송한 유통문서인 경우 발송 플래그(S) 업데이트 하도록 수정
		    if( deptID.equals("")){
		                    // 2010.08.03 다국어 
		         strSQL.append("INSERT INTO TBL_HISTORYRECEIPTINFO (DocID, ReceiptDeptID, ReceiptDeptName, ReceiptDeptName2, Status, StatusDate, TENANT_ID) ");
	             strSQL.append("SELECT DocID, ReceiptPointID, ReceiptPointName, ReceiptPointName2, ProcessYN, ProcessDate ");
			     strSQL.append("FROM TBL_ENDRECEIPTPOINTINFO ");
				 strSQL.append("WHERE DocID = '" + docID.trim() + "' AND TENANT_ID = " + tenantID + ";\n");
			}
			else{
	 			 if (deptName.trim().equals("")){
					deptName = docID;
	 			 }
		            strSQL.append("INSERT INTO TBL_HISTORYRECEIPTINFO (DocID, ReceiptDeptID, ");
		            strSQL.append("ReceiptDeptName, ReceiptDeptName2, Status, StatusDate, TENANT_ID) VALUES ('" + docID.trim());
					strSQL.append("', '" + makeRightField(docID.trim()) + "', N'");
					strSQL.append(makeRightField(deptName.trim()) + "', N'" + makeRightField(deptName2.trim()) + "', '" + processYN + "', TO_DATE('"+ commonUtil.getTodayUTCTime("") +"','YYYY-MM-DD HH24:MI:SS'), " +tenantID);
					strSQL.append(");\n");
				 
		}
		    if (mode.toUpperCase().equals("QUERY")){
		    	return strSQL.toString();
		    }
            boolean rtn = ExecuteTransactionSQL(strSQL, companyID);

			if (rtn){
				return "<RESULT>TRUE</RESULT>";
			}
			else{
				return "<RESULT>FALSE</RESULT>";
			}
		}
		return  "<RESULT>TRUE</RESULT>";
    }

	@Override
	public String doReSendDoc(Document xmlDom, String dirPath, String lang, int tenantID)	throws Exception {
		String strSQL="";
		StringBuilder strSQL2 = new StringBuilder("");
		StringBuilder tempSQL = new StringBuilder();

		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent();
		String deptID = xmlDom.getElementsByTagName("DEPTID").item(0).getTextContent();
		String companyID =xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		int WCount = 0;
		boolean rtn = true;
		for( int i=0; i<xmlDom.getElementsByTagName("RECEIPTPOINTID").getLength(); i++ )
		{
			if( xmlDom.getElementsByTagName("PROCESSYN").item(i).getTextContent().toUpperCase().trim().equals("W"))
			{
				Map<String , Object> map = new HashMap<String, Object>();
	        	map.put("v_DOCID", docID);
	        	map.put("v_TENANTID", tenantID);
	        	map.put("v_RECEIPTPOINTID", makeRightField(xmlDom.getElementsByTagName("RECEIPTPOINTID").item(i).getTextContent()));
	        	map.put("v_RECEIPTPOINTNAME", makeRightField(xmlDom.getElementsByTagName("RECEIPTPOINTNAME").item(i).getTextContent()));
	        	map.put("v_RECEIPTPOINTNAME2", makeRightField(xmlDom.getElementsByTagName("RECEIPTPOINTNAME2").item(i).getTextContent()));
	        	map.put("v_EXTRECEPTYN", makeRightField(xmlDom.getElementsByTagName("EXTRECEPTYN").item(i).getTextContent()));
	        	map.put("v_PROCESSYN", makeRightField(xmlDom.getElementsByTagName("PROCESSYN").item(i).getTextContent()));
	        	map.put("v_PROCESSSN", makeRightField(xmlDom.getElementsByTagName("PROCESSSN").item(i).getTextContent()));
	        	map.put("v_CANEDITYN", makeRightField(xmlDom.getElementsByTagName("CANEDITYN").item(i).getTextContent()));
	        	map.put("v_EXTRECEPTEMAIL", makeRightField(xmlDom.getElementsByTagName("EXTRECEPTEMAIL").item(i).getTextContent()));
	        	map.put("v_RECEIPTMEMBERID", makeRightField(xmlDom.getElementsByTagName("RECEIPTMEMBERID").item(i).getTextContent()));
	        	map.put("v_RECEIPTMEMBERNAME", makeRightField(xmlDom.getElementsByTagName("RECEIPTMEMBERNAME").item(i).getTextContent()));
	        	map.put("v_RECEIPTMEMBERNAME2", makeRightField(xmlDom.getElementsByTagName("RECEIPTMEMBERNAME2").item(i).getTextContent()));
	        	map.put("v_SYSDATE", commonUtil.getTodayUTCTime(""));
	        	map.put("v_RECEIPTMEMBERJOBTITLE", makeRightField(xmlDom.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(i).getTextContent()));
	        	map.put("v_RECEIPTMEMBERJOBTITLE2", makeRightField(xmlDom.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(i).getTextContent()));
	        	map.put("v_DEPTMEMBERSN", makeRightField(xmlDom.getElementsByTagName("DEPTMEMBERSN").item(i).getTextContent()));

	        	try{
					ezApprovalGDAO.deleteReSendEndReceiptPointInfo(map);
					ezApprovalGDAO.insertReSendEndReceiptPointInfo(map);
//				strSQL2.append(makeRightField(xmlDom.getElementsByTagName("RECEIPTPOINTID").item(i).getTextContent()) + ";'\n");
	        	} catch(Exception e) {
	    			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
	        		rtn = false;
	        	}
				WCount++;
			}
		}
		
		if( WCount <= 0 ){
			return "<RESULT>TRUE</RESULT>";
		}
		
		
		if( rtn ){
			strSQL = doReSendEndDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang, tenantID);
		}
		else{
			return "<RESULT>FALSE</RESULT>";
		}

		if( strSQL == "FALSE" ){
			return "<RESULT>FALSE</RESULT>";
		} else {
			return "<RESULT>TRUE</RESULT>";
		}

	}

	// 완료문서 Table을 가지고 재발송하는 함수. 발송 부분의 쿼리만 리턴한다.
	// pDeptID : 보내는 부서, pDocState 문서의 DocState.
	private String doReSendEndDoc(String docID, String deptID, String dirPath, String docState, String companyID, String lang, int tenantID) throws Exception {
        StringBuilder strSQL = new StringBuilder("");
        boolean rtnVal = true;
        Document receiptXML =null;
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("v_DOCID", docID);
        map.put("companyID", companyID);
        map.put("v_TENANTID", tenantID);

        List<ApprGReceiptVO> docList2 = ezApprovalGDAO.doResendEndDoc1(map);
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
       
        for (int i = 0; i < docList2.size(); i++) {
       	   sb.append(commonUtil.getQueryResult(docList2.get(i)));
		}
		   sb.append("</DATA>");
		
		   Document docXML2 = commonUtil.convertStringToDocument(sb.toString());
		   
		for(int k=0; k<docXML2.getElementsByTagName("ROW").getLength(); k++){
			map.put("v_DOCID", docID);
	        map.put("companyID", companyID);
			map.put("v_RECEIPTPOINTID", docXML2.getElementsByTagName("RECEIPTPOINTID").item(k).getTextContent());
			map.put("v_DEPTMEMBERSN", k+1 );
			
	        ezApprovalGDAO.doResendEndDoc2(map);
		}
		
        List<ApprGReceiptVO> docList = ezApprovalGDAO.doResendEndDoc3(map);
        StringBuffer sb2 = new StringBuffer();
        sb2.append("<DATA>");
       
        for (int i = 0; i < docList.size(); i++) {
       	   sb2.append(commonUtil.getQueryResult(docList.get(i)));
		}
		   sb2.append("</DATA>");
		
		   Document docXML = commonUtil.convertStringToDocument(sb2.toString());
		   
		   boolean isGroup = false;
		   int GroupCount = 0;
		   
		   String strReceiptPointID = "";
		   String strReceiptPointName = "";
           // 2010.08.03 다국어 
		   String strReceiptPointName2 = "";
		   String strReceiptMemberID = "";
		   String strReceiptMemberName = "";
           // 2010.08.03 다국어 
		   String strReceiptMemberName2 = "";
		   String strReceiptMemberJobTitle = "";
           // 2010.08.03 다국어 
		   String strReceiptMemberJobTitle2 = "";
		   String strReceiptCompanyID = "";
		   String SusinGroupIcon = getCode2Name("A53", "001", companyID, lang, tenantID);
		   LOGGER.debug("getCode2Name ended.");
		   for(int j=0; j<docXML.getElementsByTagName("ROW").getLength(); j++){
			   strReceiptPointID = makeListField(docXML.getElementsByTagName("RECEIPTPOINTID").item(j).getTextContent());
               strReceiptPointName = makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME").item(j).getTextContent());
               strReceiptPointName2 = makeListField(docXML.getElementsByTagName("RECEIPTPOINTNAME2").item(j).getTextContent());
			   strReceiptMemberID = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERID").item(j).getTextContent());
               strReceiptMemberName = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(j).getTextContent());
               strReceiptMemberName2 = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERNAME2").item(j).getTextContent());
               strReceiptMemberJobTitle = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(j).getTextContent());
               strReceiptMemberJobTitle2 = makeListField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(j).getTextContent());
			   strReceiptCompanyID = makeListField(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(j).getTextContent());
			   isGroup = false;
			   GroupCount = 1;
				if( strReceiptPointID.substring(0, SusinGroupIcon.length()).equals(SusinGroupIcon)){
					map.put("v_MAINID", strReceiptPointID.substring(SusinGroupIcon.length() , strReceiptPointID.length() - SusinGroupIcon.length()));
                    List<ApprGRecordVO> rList = ezApprovalGDAO.doSendDoc_ReceiptGroupSub(map);

                    StringBuffer sb3 = new StringBuffer();
                    sb3.append("<DATA>");
                   
                    for (int i = 0; i < rList.size(); i++) {
                   	   sb3.append(commonUtil.getQueryResult(rList.get(i)));
            		}
            		   sb3.append("</DATA>");
            		
            		    receiptXML = commonUtil.convertStringToDocument(sb3.toString());

						if (receiptXML.getElementsByTagName("ROW").getLength() > 0)
						{
							isGroup = true;
							GroupCount = receiptXML.getElementsByTagName("ROW").getLength();
						}
				}
				for( int i = 0 ; i < GroupCount ; i++ )
				{
					if( rtnVal )
					{
						if( isGroup )
						{
							strReceiptPointID = makeListField(receiptXML.getElementsByTagName("DEPTID").item(i).getTextContent());
                            strReceiptPointName = makeListField(receiptXML.getElementsByTagName("DEPTNAME").item(i).getTextContent());
                            strReceiptPointName2 = makeListField(receiptXML.getElementsByTagName("DEPTNAME2").item(i).getTextContent());
							strReceiptMemberID = "";
                            strReceiptMemberName = "";
                            strReceiptMemberName2 = "";
                            strReceiptMemberJobTitle = "";
                            strReceiptMemberJobTitle2 = "";
							strReceiptCompanyID = makeListField(receiptXML.getElementsByTagName("COMPANYID").item(i).getTextContent());
						}
						
						map.put("company", strReceiptCompanyID);
						String maxDoc = ezApprovalGDAO.selectAprGetNewID(map);
						ezApprovalGDAO.aprGetNewID(map);
						String newID = ezApprovalGDAO.selectAprGetNewID(map);
						int tmplen=20;
						int strlen = tmplen - newID.trim().length();
						for(int k = 0; k< strlen; k++){
							newID = "0" + newID.trim();
						}
						
						map.put("v_DOCID",docID);
						map.put("v_FLAG", "END");
						map.put("v_TENANTID",tenantID);

						String fileName = ezApprovalGDAO.getDocInfoHref(map);
						String extFileName = getExtendedFileName(fileName);
                        
                        // 2011.03.29 년도별 폴더 변경 
                        String[] arry = fileName.split(extFileName, '/');
                        String oldyear = commonUtil.getTodayUTCTime("").substring(0, 4);
                        if (arry.length >= 7 && arry[4].length() == 4)
                        {
                            oldyear = arry[4];
                        }

						String pUrl = "/files/upload_approvalG/" + strReceiptCompanyID + "/doc/" + oldyear + "/1000/" + getDocDir(newID) + "/" + newID + "." + extFileName;
				
                        //2011.04.04  수신부서가 많을 경우 속도 개선을 위해 접수기에서 문서 copy되도록 수정
                        //rtnVal = copyFile(pDirPath + companyID + "\\Doc\\" + oldyear + "\\" + getDocDir(pDocID) + "\\" + pDocID + "." + pExtFileName, pDirPath + strReceiptCompanyID + "\\Doc\\" + DateTime.Now.Year.ToString() + "\\1000\\" + getDocDir(newID) + "\\" + newID + "." + pExtFileName, pDirPath + strReceiptCompanyID + "\\Doc\\" + DateTime.Now.Year.ToString() + "\\1000\\" + getDocDir(newID));
						
						if( rtnVal )
						{
						    map.put("v_NEWID", newID);
						    map.put("v_DOCID", docID);
						    map.put("v_DOCSTATE", docState);
						    map.put("v_STAASDOJAK", staASDoJak);
						    map.put("v_URL", pUrl);
						    map.put("v_TENANTID", tenantID);
						    
						    try{
						    	ezApprovalGDAO.insertReSendAprDocInfo(map);
						    	ezApprovalGDAO.insertReSendExpAprDocInfo(map);
						    	ezApprovalGDAO.insertReSendAprAttachInfo(map);
						    	ezApprovalGDAO.insertReSendAprDocAttachInfo(map);
						    } catch(Exception e) {
								TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						    	rtnVal = false;
						    }
                            map.put("v_DOCID", docID);
                            map.put("v_FLAG", "END");
                            map.put("v_TENANTID", tenantID);
                            
                            int pSusinSN = ezApprovalGDAO.getReceiptProcessInfoRec(map);

							pSusinSN += 1;

							// 사람에게 보낼때는 staASJiJung 으로 해야 한다.
                            if (strReceiptMemberID.trim().equals(""))
                            {
                            	map.put("v_ReceiveSN", Integer.toString(pSusinSN));
                            	map.put("v_NEWID", newID);
                            	map.put("v_ReceivedDeptID", strReceiptPointID);
                            	map.put("v_strReceiptPointName", strReceiptPointName);
                            	map.put("v_DocState", docState);
                            	map.put("v_AprState", staASDoJak);
                            	map.put("v_DOCID", commonUtil.getTodayUTCTime(""));
                            	map.put("v_ProcessorID", strReceiptMemberID);
                            	map.put("v_ProcessorName", strReceiptMemberName);
                            	map.put("v_ProcessorJobTitle", strReceiptMemberJobTitle);

                            	try {
                            		ezApprovalGDAO.insertReSendAprReceiptProcessInfo(map);
                            	}catch(Exception e) {
    								TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    						    	rtnVal = false;
    						    }
                            }
                            else
                            {
                            	map.put("v_ReceiveSN", Integer.toString(pSusinSN));
                            	map.put("v_NEWID", newID);
                            	map.put("v_ReceivedDeptID", strReceiptPointID);
                            	map.put("v_strReceiptPointName", strReceiptPointName);
                            	map.put("v_DocState", docState);
                            	map.put("v_AprState", staASJiJung);
                            	map.put("v_DOCID", commonUtil.getTodayUTCTime(""));
                            	map.put("v_ProcessorID", strReceiptMemberID);
                            	map.put("v_ProcessorName", strReceiptMemberName);
                            	map.put("v_ProcessorJobTitle", strReceiptMemberJobTitle);
                            	try {
                            		ezApprovalGDAO.insertReSendAprReceiptProcessInfo(map);
                            	}catch(Exception e) {
    								TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    						    	rtnVal = false;
    						    }
                            	
                            }
                        	map.put("v_RECEIPTPOINTID",  makeRightField(strReceiptPointID));

                        	try {
                        		ezApprovalGDAO.updateReSendEndReceiptPointInfo(map);
                        	}catch(Exception e) {
								TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
						    	rtnVal = false;
						    }

							if( strReceiptMemberID.trim().equals("") ){
								sendRecvMsg(strReceiptPointID, newID, "SUSIN", strReceiptCompanyID, lang, tenantID);
							}
							else{
								sendMsg(newID, strReceiptMemberID, "SUSIN", strReceiptCompanyID, lang, tenantID);
							}
						}
					}
				}

				if( rtnVal ){
					return "TRUE";
				}
				else{
					return "FALSE";
				}
		   }
		 return "TRUE";
	}
	@Override
	public String getRecSCInfo(Document xmlDom,String langType,LoginVO userInfo) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent().trim();
		String recID = xmlDom.getElementsByTagName("RECORDID").item(0).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_RECORDID", recID);
		map.put("companyID", companyID);
		map.put("v_TENANTID", userInfo.getTenantId());

		List<ApprGCabinetVO> docList = ezApprovalGDAO.getRecScInfo(map);
		 StringBuffer sb = new StringBuffer();
	     sb.append("<DATA>");
	        
	     for (int i = 0; i < docList.size(); i++) {
			sb.append(commonUtil.getQueryResult(docList.get(i)));
		 }
			sb.append("</DATA>");
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		if(docXML.getElementsByTagName("ROW").getLength()<=0){
			return "<RESULT>NORECORD</RESULT>";
		}
		resultXML.append("<LISTVIEWDATA>");
		resultXML.append("<HEADERS>");
		boolean[] SCYN = new boolean[3];
		for (int k=0; k<docXML.getElementsByTagName("ROW").getLength(); k++){
			String SepAttSN = makeListField(docXML.getElementsByTagName("SERIALNO").item(k).getTextContent().trim());
		
			if(SepAttSN.equals("000")){ // 리스트뷰 헤더 부분이다.
				resultXML.append("<HEADER>");
				resultXML.append("<NAME>" + (langType.equals("1") ? messageSource.getMessage("ezApprovalG.pjj25", userInfo.getLocale()) : "SN") + "</NAME>");
				resultXML.append("<WIDTH>" + 100 + "</WIDTH>");
				resultXML.append("</HEADER>");
				
				//제 1 특수목록
				if(makeListField(docXML.getElementsByTagName("SC1").item(k).getTextContent()).equals("")){
					SCYN[0] = false;
				}
				else{
					SCYN[0] = true;
					
					resultXML.append("<HEADER>");
					resultXML.append("<NAME>"  + makeListField(docXML.getElementsByTagName("SC1").item(k).getTextContent()) + "</NAME>");
					resultXML.append("<WIDTH>" + 250 + "</WIDTH>");
					resultXML.append("</HEADER>");
				}
				
				//제 2 특수목록
				if(makeListField(docXML.getElementsByTagName("SC2").item(k).getTextContent()).equals("")){
					SCYN[1] = false;
				}
				else{
					SCYN[1] = true;
					
					resultXML.append("<HEADER>");
					resultXML.append("<NAME>"  + makeListField(docXML.getElementsByTagName("SC2").item(k).getTextContent()) + "</NAME>");
					resultXML.append("<WIDTH>" + 250 + "</WIDTH>");
					resultXML.append("</HEADER>");
				}
				
				//제 3특수목록
				if(makeListField(docXML.getElementsByTagName("SC3").item(k).getTextContent()).equals("")){
					SCYN[2] = false;
				}
				else{
					SCYN[2] = true;
					
					resultXML.append("<HEADER>");
					resultXML.append("<NAME>"  + makeListField(docXML.getElementsByTagName("SC3").item(k).getTextContent()) + "</NAME>");
					resultXML.append("<WIDTH>" + 250 + "</WIDTH>");
					resultXML.append("</HEADER>");
				}
				resultXML.append("</HEADERS>");
			}
			else{ //리스트뷰 Rows 부분이다.
				resultXML.append("<ROWS>");
				resultXML.append("<ROW>");
				resultXML.append("<CELL>");
				resultXML.append("<VALUE>" + SepAttSN + "</VALUE>");
				resultXML.append("</CELL>");
				
				if(SCYN[0]){
					resultXML.append("<CELL>");
					resultXML.append("<VALUE>"+makeListField(docXML.getElementsByTagName("SC1").item(k).getTextContent())+"</VALUE>");
					resultXML.append("</CELL>");
					
				}
				
				if(SCYN[1]){
					resultXML.append("<CELL>");
					resultXML.append("<VALUE>"+makeListField(docXML.getElementsByTagName("SC2").item(k).getTextContent())+"</VALUE>");
					resultXML.append("</CELL>");
				}
				
				if(SCYN[2]){
					resultXML.append("<CELL>");
					resultXML.append("<VALUE>"+makeListField(docXML.getElementsByTagName("SC3").item(k).getTextContent())+"</VALUE>");
					resultXML.append("</CELL>");
				}
				resultXML.append("</ROW>");
			}
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		return resultXML.toString();
	}
	
	@Override
	public String makeContainer(String deptID, String containerType, String companyID, int tenantID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTAINERTYPE", containerType);
		map.put("v_DEPTID", deptID);
		map.put("v_TENANTID", tenantID);
		
		String maxContainerID = ezApprovalGDAO.makeContainer(map);
		map.put("v_MAXCONTAINERID", maxContainerID);

		ezApprovalGDAO.insertTbContainer(map);

		return maxContainerID;
	}

	@Override
	public int getWebPartListCount(String listType, String userID, String deptID, String userIDS, String deptIDS, String userFlag, String companyID, String lang, int tenantID, String offset) throws Exception {
		userIDS = "'" + makeRightField(userID) + "'";
		String proxyOption = "";
		
		if (listType.equals("1")) {
			proxyOption = getIsUse("A23", "001", companyID, lang, tenantID);
			if (proxyOption.equals("1")) {
				userIDS = getProxyUser(userID, lang, tenantID, offset);
			}
		}
		
		deptIDS = getDocManageDeptInfo(deptID, tenantID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		userFlag.trim().toLowerCase();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERIDS", userIDS);
		map.put("v_DEPTIDS", deptIDS);
		map.put("v_USERFLAG", userFlag.trim().toLowerCase());
		map.put("v_TENANTID", tenantID);
		map.put("companyID", companyID);
		return ezApprovalGDAO.getWebPartListCount(map);
	}

	@Override
	public String doCancelForce(String docID, String userID, String companyID,	int tenantId) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_USERID", userID);
		map.put("v_TENANTID", tenantId);
		
		String rtnVal = "OK";
		try {
			int aprMemberSn = ezApprovalGDAO.selectDoCallBack(map);
			if(aprMemberSn > 0) {
				if(aprMemberSn == 1) {
					ezApprovalGDAO.updateDoCallBack(map);
				}
				map.put("v_APRMEMBERSN", aprMemberSn);
				ezApprovalGDAO.updateDoCallBack2(map);
				
				map.put("v_APRMEMBERSN", aprMemberSn + 1);
				ezApprovalGDAO.updateDoCallBack3(map);
			}
			
		} catch (Exception e) {
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
			return rtnVal = "FALSE";
		}
		
		return rtnVal;
	}


}
