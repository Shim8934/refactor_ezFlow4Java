package egovframework.ezEKP.ezApprovalG.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

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
import egovframework.ezEKP.ezApprovalG.vo.ApprGDeptTempletVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocAttachInfoVO;
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
	
	@Resource(name = "egovMessageSource")
    private EgovMessageSource messageSource;
	
	// DocType
	public String staDTDraftDoc = "001";		// 기안문
	public String staDTReportDoc = "002";	  // 보고문
	public String staDTReceiptDoc = "003";		// 수신문
	public String staDTExcuteDoc = "004";	  // 시행문
	public String staDTHabyuiDoc = "005";	  // 합의문
	public String staDTGamsaDoc = "006";		// 감사문
	public String staDTApplyDoc = "007";		// 신청서

	// DocState
	public String staDSPumYui = "001";			// 품의
	public String staDSHyubJo = "002";			// 협조
	public String staDSGamSa = "003";		  // 감사
	public String staDSSimSa = "004";		  // 심사
	public String staDSSuSin = "011";		  // 수신
	public String staDSHabYui = "012";			// 합의
	public String staDSSiHang = "013";			// 시행
	public String staDSGamSaBu = "014";		// 검사부 감사
	public String staDSGongRam = "015";		// 공람
	public String staDSHoiRam = "016";			// 회람
	public String staDSChamJo = "017";			// 참조
	public String staDSWhokyul = "018";		// 후결
	public String staDSBalsin = "019";			// 발신
	public String staDSApply = "020";		  // 신청
	public String staDSBansong = "031";		// 반송
	public String StaDSHesong = "032";			// 회송

	// AprType
	public String staATYilBan = "001";         // 일반
	public String staATGyulJe = "001";         // 결재
	public String staatwhoakin = "002";        // 확인
	public String staATAnHam = "003";         // 결재안함
	public String staATJunGyul = "004";        // 전결
	public String staATGamSa = "005";         // 감사
	public String staATSimSa = "006";         // 심사
	public String staATChamJo = "007";         // 참조
	public String staATSoonChaHyubJo = "008";     // 개인순차협조
	public String staATHapYu = "008";					// 개인 합의
	public String staATByungRyulHyubJo = "009";		// 개인병렬협조
	public String staATBuSeuSoonChaHyubJo = "011";		// 부서순차협조
	public String staATBuSeuByungRyulHyubJo = "012";	// 부서병렬협조
	public String staATGamSaBu = "013";				// 감사
	public String staATSuSin = "014";					// 수신
	public String staATWhokyul = "015";				// 후열
	public String staATGongram = "017";				// 공람
	public String staATDekyul = "016";					// 대결
	public String staATgian = "018";					// 기안
	public String staATgumto = "019";					// 검토

	// AprState
	public String staASmikyul = "000";					// 미결
	public String staASDaeGi = "001";					// 대기
	public String staASJinHang = "002";					// 진행
	public String staASSungIn = "003";					// 승인
	public String staASBanSong = "004";					// 반송
	public String staASBoRyu = "005";					// 보류
	public String staASWheSu = "006";					// 회수
	public String staASAprEND = "010";					// 완료
	public String staASDoJak = "011";					// 도착
	public String staASJiJung = "012";					// 지정
	public String staASJubSu = "013";					// 접수
	public String staASBaeBu = "014";					// 배부
	public String staASWheSong = "015";					// 회송
	public String staASSusinJinHang = "016";			// 수신진행
	public String staASSusinSungIn = "017";				// 수신완료
	public String staASSusinJiJung = "018";				// 수신지정
	
	// OpinionType
	public String staIlBan = "001";			// 일반의견
	public String staBanSong = "002";		// 반송의견
	public String staBoRyu = "003";			// 보류의견
	public String staWheSong = "004";		// 회송의견

	@Override
	// 해당 부서에서 볼 수 있는 문서함의 리스트를 가져온다.
	// OwnFlag : "0"-자기 부서의 문서함, "1"-타부서의 문서함, "2"-전부
	public List<ApprGLeftVO> getUseContInfo(LoginVO userInfo, String ownFlag) throws Exception{
		String listHeader = getListHeader("106", userInfo.getCompanyID(), userInfo.getLang());
		List<ApprGLeftVO> apprGLeftVOList = new ArrayList<ApprGLeftVO>();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("deptID", userInfo.getDeptID());
		map.put("companyID", userInfo.getCompanyID());
		
		if (ownFlag.equals("1")) {
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo2(map);
		} else if (ownFlag.equals("2")) {
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo3(map);
		} else {
			apprGLeftVOList = ezApprovalGDAO.getUseContInfo1(map);
		}
		
		Document doc = commonUtil.convertStringToDocument(listHeader);
		apprGLeftVOList.get(0).setName(doc.getElementsByTagName("NAME").item(0).getTextContent());
		apprGLeftVOList.get(0).setWidth(Integer.parseInt(doc.getElementsByTagName("WIDTH").item(0).getTextContent()));
		
		return apprGLeftVOList;
	}

	public String getListHeader(String listCode, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(map);
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListHeaderVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListHeaderVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getOptionInfo(String code1, String code2, LoginVO userInfo, String mode) throws Exception {
		String resultString = "";
		if (mode.equals("NAME")) {
			resultString = getName2Code(code1, code2, userInfo.getCompanyID(), userInfo.getLang());
		} else {
			resultString = getCode2Name(code1, code2, userInfo.getCompanyID(), userInfo.getLang());
		}
		
		return resultString;
	}

	@Override
	public String getCode2Name(String code1, String code2, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		return ezApprovalGDAO.getCode2Name(map);
	}

	@Override
	public String getAccessYNG(String docID, String userID, String mode, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
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
			publicityCode = makeListField(ezApprovalGDAO.getAccessYNG(map));

			if (publicityCode.length() <= 0) {
				publicityCode = "1";
			} else {
				publicityCode = publicityCode.substring(0, 1);
			}
			
			publicityFlag = getCode2Name("A50", publicityCode, companyID, lang);
			
			switch (publicityFlag) {
			case "ALL":
				rtnVal = true;
				break;
				
			case "DEPT":
				map.put("v_FLAG", "002");
				String isLineInfo3 = makeListField(ezApprovalGDAO.getAccessYNG(map));
				
				if (isLineInfo3.equals("Y")) {
					rtnVal = true;
				} else {
					map.put("v_FLAG", "003");
					String drafterDeptID = makeListField(ezApprovalGDAO.getAccessYNG(map));
					String result = ezOrganService.getPropertyList(userID, "extensionAttribute4;department", lang);
					
					if (result.toLowerCase().lastIndexOf(drafterDeptID.toLowerCase()) >= 0 && drafterDeptID.trim().length() > 0) {
						rtnVal = true;
					} else {
						rtnVal = false;
					}
				}
				break;
				
			case "LINE":
				map.put("v_FLAG", "002");
				String isLineInfo2 = makeListField(ezApprovalGDAO.getAccessYNG(map));
				
				if (isLineInfo2.equals("Y")) {
					rtnVal = true;
				} else {
					rtnVal = false;
				}
				break;
				
			case "DRAFT":
				map.put("v_FLAG", "004");
				String drafterYN = makeListField(ezApprovalGDAO.getAccessYNG(map));
				
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
		
		if (publicityFlag.equals("ALL") && mode.substring(1, 1).equals("Y")) {
			String userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6");
			
			if (userSecurityCode.trim().equals("")) {
				userSecurityCode = "0";
				map.put("v_FLAG", "005");
				
				String docSecurityCode = makeListField(ezApprovalGDAO.getAccessYNG(map));
				
				if (docSecurityCode.trim().equals("")) {
					docSecurityCode = "999";
				}
				
				if (Integer.parseInt(userSecurityCode) <= Integer.parseInt(docSecurityCode)) {
					rtnVal = true;
				} else {
					rtnVal = false;
				}
				
				if (getIsUse("A22", "005", companyID, lang).equals("1")) {
					map.put("v_FLAG", "002");
					String isLineInfo = makeListField(ezApprovalGDAO.getAccessYNG(map));
					
					if (isLineInfo.equals("Y")) {
						rtnVal = true;
					}
				}
			}
		}
		
		if (!rtnVal && mode.substring(2, 1).equals("Y")) {
			map.put("v_FLAG", "006");
			String allUserRight = ezApprovalGDAO.getAccessYNG(map);
			
			if (allUserRight.length() <= 0) {
				allUserRight = "0";
			}
			
			if (Integer.parseInt(allUserRight) > 0) {
				rtnVal = true;
			}
		}
		
		if (rtnVal) {
			return "<RESULT>TRUE</RESULT>";
		} else{
			return "<RESULT>FALSE</RESULT>";
		}
	}

	public String getName2Code(String code1, String code2, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_NAME", code2);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		return ezApprovalGDAO.getName2Code(map);
	}

	@Override
	public String getLineInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		if (mode.equals("APR")) {
			//결재할문서
			listString = getListHeader("011", companyID, lang);
		} else if (mode.equals("END")) {
			//기안할문서
			listString = getListHeader("012", companyID, lang);
		} else if (mode.equals("COD")) {
			//결재진행문서
			listString = getListHeader("013", companyID, lang);
		} else {
			listString = getListHeader("011", companyID, lang);
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
		
		String docList = getLineInfo(docID, mode, orderOption1, companyID);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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

	public String getLineInfo(String docID, String mode, String orderOption1, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("companyID", companyID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getLineInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String getAttachInfo(String docID, String flag, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("043", companyID, lang);
		
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
		
		String strLangFile = getCode2Name("L01", "001", companyID, lang);
		String strLangDocument = getCode2Name("L01", "002", companyID, lang);
		String docList = getAttachInfoDB(docID, flag, commonUtil.getMultiData(lang), strLangFile, strLangDocument, orderOption1, companyID);
		
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
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
		
		return resultXML.toString();
	}

	@Override
	public String getReceiptInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		if (mode.equals("APR")) {
			//결재할문서
			listString = getListHeader("021", companyID, lang);
		} else if (mode.equals("END")) {
			//기안할문서
			listString = getListHeader("022", companyID, lang);
		} else if (mode.equals("COD")) {
			//결재진행문서
			listString = getListHeader("023", companyID, lang);
		} else if (mode.equals("TMP")) {
			//임시보관함문서
			listString = getListHeader("023", companyID, lang);
		} else if (mode.equals("RES")) {
			//재발송 기능
			listString = getListHeader("024", companyID, lang);
		} else {
			listString = getListHeader("021", companyID, lang);
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
		
		String docList = getReceiptInfo(docID, mode, orderOption1, companyID);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
		
		return resultXML.toString();
	}

	@Override
	public String getOpinionInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		if (mode.equals("APR")) {
			//결재할문서
			listString = getListHeader("031", companyID, lang);
		} else if (mode.equals("END")) {
			//기안한문서
			listString = getListHeader("032", companyID, lang);
		} else if (mode.equals("CAPR")) {
			//결재진행문서
			listString = getListHeader("033", companyID, lang);
		} else if (mode.equals("CEND")) {
			//결재진행문서
			listString = getListHeader("034", companyID, lang);
		} else {
			listString = getListHeader("031", companyID, lang);
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
		
		String docList = getOpinionInfo(docID, mode, orderOption1, companyID);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
		
		return resultXML.toString();
	}

	@Override
	public String getWebPartList(String listType, String userID, String deptID, String listCount, String mode, String userFlag, String companyID, String lang) throws Exception {
		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = "";
		String result = "";
		
		if (listType.equals("1")) {
			proxyOption = getIsUse("A23", "001", companyID, lang);
			
			if (proxyOption.equals("1")) {
				userIDs = getProxyUser(userID, lang);
			}
		}
		
		String basicOrder = getCode2Name("A18", "001", companyID, lang);
		String strMultiData = commonUtil.getMultiData(lang);
		
		if (mode.equals("COUNT")) {
			int totalCount = getWebPartListCount(listType, userID, deptID, userIDs, getDocManageDeptInfo(deptID), userFlag.toLowerCase().trim(), companyID);
			result = "<RESULT>" + totalCount + "</RESULT>";
		} else if (mode.equals("LEFT")) {
			String leftCount = getLeftDocCount(userID, deptID, userIDs, getDocManageDeptInfo(deptID), userFlag.toLowerCase(), companyID);
			result = leftCount;
		} else {
			String webList = getWebPartList(listType, userID, deptID, userIDs, getDocManageDeptInfo(deptID), userFlag.toLowerCase(), listCount, basicOrder, strMultiData, companyID);
			result = webList;
		}
		
		return result;
	}

	@Override
	public String getDocType(String selected, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", commonUtil.getMultiData(lang));
		map.put("companyID", companyID);
		
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
	
		return sb.toString();
	}

	@Override
	public String getFormInfo(String formContID, String kind, String searchType, String searchName, String userID, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("109", companyID, lang);
		
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
		
		String strMultiData = commonUtil.getMultiData(lang);
		String docList = getFormInfoDB(formContID, userID, kind, strMultiData, searchType, searchName, companyID);
		
		Document docXML = commonUtil.convertStringToDocument(docList);
		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		resultXML.append("<ROWS>");
		
		for (int k = 0; k < dlength; k++) {
			resultXML.append("<ROW>");
			for (int p = 0; p < hlength; p++) {
				resultXML.append("<CELL>");
				
				if (p == 0) {
					if (lang.equals("1")) {
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
		
		return resultXML.toString();
	}

	@Override
	public String getFormContainerInfo(String id, String deptID, String companyID) throws Exception {
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DEPTID", deptID);
		map.put("v_ID", id);
		map.put("companyID", companyID);
		
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
            int childCnt = getCountChildFormCont(docXML.getElementsByTagName("FORMCONTID").item(k).getTextContent(), deptID, companyID);
            String ISLEAF = "FALSE";
            
            if (childCnt < 1) {
            	ISLEAF = "TRUE";
            }
            rtnXML.append("<EXPANDED>FALSE</EXPANDED><ISLEAF>" + ISLEAF + "</ISLEAF>");
            rtnXML.append("<VALUE>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME").item(k).getTextContent())) + "</VALUE>");

			
            if (deptID.trim().equals("")) {
				rtnXML.append("<DATA1>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTID").item(k).getTextContent())) + "</DATA1>");
				rtnXML.append("<DATA2>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTNAME").item(k).getTextContent())) + "</DATA2>");
				rtnXML.append("<DATA3>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTOWNDEPID").item(k).getTextContent())) + "</DATA3>");
				rtnXML.append("<DATA4>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTPARENTS").item(k).getTextContent())) + "</DATA4>");
				rtnXML.append("<DATA5>" + commonUtil.cleanValue(makeListField(docXML.getElementsByTagName("FORMCONTDESCRIPTION").item(k).getTextContent())) + "</DATA5>");
				
                if (docXML.getElementsByTagName("FORMCONTOWNDEPID").item(k).getTextContent() == "ALL") {
                	rtnXML.append("<DATA6>ALL</DATA6>");
                } else {
					rtnXML.append("<DATA6>" + commonUtil.cleanValue(makeListField(ezOrganService.getPropertyValue(docXML.getElementsByTagName("FORMCONTOWNDEPID").item(k).getTextContent(), "DisplayName").toString())) + "</DATA6>");
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

		return rtnXML.toString();
	}

	@Override
	public String setUserFormInfo(String formID, String userID, String companyID){
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("companyID", companyID);
		
		try {
			ezApprovalGDAO.setUserFormInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		return rtnVal;
	}

	@Override
	public String delUserFormInfo(String formID, String userID, String companyID){
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("companyID", companyID);
		
		try {
			ezApprovalGDAO.delUserFormInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		return rtnVal;
	}

	@Override
	public String getApprovalPWD(String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);

		return ezApprovalGDAO.getApprovalPWD(map);
	}

	@Override
	public String getSecurityType(String selected, String companyID, String lang) throws Exception {
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
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
	public String getAprType(String companyID, String lang) throws Exception {
		StringBuilder rtnXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
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
	public String getAprLineInfo(String docID, String userID, String formID, String companyID, String lang) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String listString = getListHeader("013", companyID, lang);
		
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
		
		String docList = getAprLineInfoDB(docID, "1", userID, formID, companyID);
		Document docXML = commonUtil.convertStringToDocument(docList);

		int dlength = docXML.getElementsByTagName("ROW").getLength();
		
		if (dlength <= 0) {
			String isLastAprLine = getCode2Name("A44", "001", companyID, lang);
			
			if (isLastAprLine.equals("1")) {
				docList = getAprLineInfoDB(docID, "2", userID, formID, companyID);
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
				
				if (!lang.equals("1")) {
					if (fieldName.equals("APRMEMBERNAME") || fieldName.equals("APRMEMBERJOBTITLE") || fieldName.equals("APRMEMBERDEPTNAME")
							|| fieldName.equals("PROXYUSERNAME") || fieldName.equals("PROXYUSERJOBTITLE") || fieldName.equals("PROXYUSERDEPTNAME")) {
						fieldName = fieldName + "2";
					}
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String getTempList(String userID, String formID, String companyID, String lang) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		
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

	@Override
	public String updateLineInfo(String ret, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		Document docXML = commonUtil.convertStringToDocument(ret);
		NodeList nList = docXML.getElementsByTagName("ROW");
		String strDocID = nList.item(0).getChildNodes().item(8).getTextContent();
		String rtnVal = "";
		
		strSQL.append("DELETE FROM TBEXPAPRLINE WHERE DocID = '" + strDocID + "';\n");
		strSQL.append("DELETE FROM TBAPRLINEINFO WHERE DocID = '" + strDocID + "';\n");
		
		String recDate = "";
		String procDate = "";
		
		for (int k = 0; k < nList.getLength(); k++) {
			if (nList.item(k).getChildNodes().item(7).getTextContent().trim().equals("")) {
				recDate = "NULL";
			} else {
				if (nList.item(k).getChildNodes().item(7).getTextContent().replace("오전", "").trim() != nList.item(k).getChildNodes().item(7).getTextContent().trim()) {
					recDate = "'" + nList.item(k).getChildNodes().item(7).getTextContent().replace("오전", "").trim() + "AM'";
				} else if (nList.item(k).getChildNodes().item(7).getTextContent().replace("오후", "").trim() != nList.item(k).getChildNodes().item(7).getTextContent().trim()) {
					recDate = "'" + nList.item(k).getChildNodes().item(7).getTextContent().replace("오후", "").trim() + "PM'";
				} else {
					recDate = "'" + nList.item(k).getChildNodes().item(7).getTextContent().trim() + "'";
				}
			}
			
			if (nList.item(k).getChildNodes().item(6).getTextContent().trim().equals("")) {
				procDate = "NULL";
			} else {
				if (nList.item(k).getChildNodes().item(6).getTextContent().replace("오전", "").trim() != nList.item(k).getChildNodes().item(6).getTextContent().trim()) {
					procDate = "'" + nList.item(k).getChildNodes().item(6).getTextContent().replace("오전", "").trim() + "AM'";
				} else if (nList.item(k).getChildNodes().item(6).getTextContent().replace("오전", "").trim() != nList.item(k).getChildNodes().item(6).getTextContent().trim()) {
					procDate = "'" + nList.item(k).getChildNodes().item(6).getTextContent().replace("오후", "").trim() + "PM'";
				} else {
					procDate = "'" + nList.item(k).getChildNodes().item(6).getTextContent().trim() + "'";
				}
			}
			
			strSQL.append("INSERT INTO TBAPRLINEINFO (DocID, AprMemberSN, AprType, AprState, ");
            strSQL.append("AprMemberID, AprMemberIsDeptYN, AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, ");
            strSQL.append("AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, AprMemberLDAPPath, ReceivedDate, ");
			strSQL.append("ProcessDate, ReasonDoNotApprov, isProposerYN, isBriefUserYN) VALUES ('");
			strSQL.append(strDocID + "', '" + nList.item(k).getChildNodes().item(0).getTextContent() + "', '");
            strSQL.append(nList.item(k).getChildNodes().item(16).getTextContent() + "', '");          //AprType
            strSQL.append(nList.item(k).getChildNodes().item(17).getTextContent() + "', '");          //AprState
			strSQL.append(makeRightField(nList.item(k).getChildNodes().item(9).getTextContent()) + "', '");
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(10).getTextContent()) + "', N'");//AprMemberIsDeptYN
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(18).getTextContent()) + "', N'");//AprMemberName
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(19).getTextContent()) + "', N'");//AprMemberName2
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(22).getTextContent()) + "', N'"); //AprMemberJobTitle
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(23).getTextContent()) + "', N'");//AprMemberJobTitle2
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(11).getTextContent()) + "', N'");
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(20).getTextContent()) + "', '");
            strSQL.append(makeRightField(nList.item(k).getChildNodes().item(21).getTextContent()) + "', '"); 
			strSQL.append(makeRightField(nList.item(k).getChildNodes().item(15).getTextContent()) + "', ");
			strSQL.append(recDate + ", " + procDate + ", '");
			strSQL.append(makeRightField(nList.item(k).getChildNodes().item(12).getTextContent()) + "', '");
			strSQL.append(makeRightField(nList.item(k).getChildNodes().item(13).getTextContent()) + "', '");
			strSQL.append(makeRightField(nList.item(k).getChildNodes().item(14).getTextContent()) + "');\n");

			strSQL.append("INSERT INTO TBEXPAPRLINE (docid, aprmemberSN, orguserid, proxyuserid, ");
            strSQL.append("proxyusername, proxyusername2, proxyuserjobtitle, proxyuserjobtitle2, proxyuserdeptid, proxyuserdeptname, proxyuserdeptname2) ");
			strSQL.append("VALUES ('" + strDocID + "', '" + makeRightField(nList.item(k).getChildNodes().item(0).getTextContent()));
			strSQL.append("', '" + makeRightField(nList.item(k).getChildNodes().item(9).getTextContent()));
            strSQL.append("', '', '', '', '', '', '', '', '');\n");
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
	public String updateReceiptInfo(String ret2, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		Document docXML = commonUtil.convertStringToDocument(ret2);
		String susinGroupIcon = getCode2Name("A53", "001", companyID, lang);
		String susinGroupUseFlag = getCode2Name("A53", "002", companyID, lang);
		
		NodeList rowNode = docXML.getElementsByTagName("ROW");
		
		String strDocID = rowNode.item(0).getChildNodes().item(2).getTextContent();
		String rtnVal = deleteReceiptInfo(strDocID, companyID);
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			String receiptPointID = "";
			int j = 1;
			
			for (int k = rowNode.getLength() - 1; k >= 0; k--) {
				receiptPointID = rowNode.item(k).getChildNodes().item(3).getTextContent();
				
				if (!receiptPointID.substring(0, susinGroupIcon.length()).equals(susinGroupIcon) || !susinGroupUseFlag.equals("Y")) {
					strSQL.append("INSERT INTO TBRECEIPTPOINTINFO (DocID, ReceiptPointID, ReceiptPointName, ReceiptPointName2, ");
                    strSQL.append("ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ExtReceptEmail, ReceiptMemberID, ");
                    strSQL.append("ReceiptMemberName, ReceiptMemberName2, ProcessDate, ReceiptMemberJobTitle, ReceiptMemberJobTitle2, DeptMemberSN) VALUES ('");
					strSQL.append(strDocID + "', '" + rowNode.item(k).getChildNodes().item(3).getTextContent() + "', N'");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(11).getTextContent()) + "', N'");
                    // ReceiptPointName2
                    strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(12).getTextContent()) + "', '");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(4).getTextContent()) + "', '");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(5).getTextContent()) + "', '1', '");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(6).getTextContent()) + "', '");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(7).getTextContent()) + "', '");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(8).getTextContent()) + "', N'");
                    strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(9).getTextContent()) + "', N'");
                    // ReceiptMemberName2
                    strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(9).getTextContent()) + "', NULL, N'");
					strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(13).getTextContent()) + "', N'");
                    // ReceiptMemberJobTitle2
                    strSQL.append(makeRightField(rowNode.item(k).getChildNodes().item(14).getTextContent()) + "', '");
					strSQL.append(j + "');\n");
					
					j += 1;
				} else {
					Map<String, Object> map = new HashMap<String, Object>();
					map.put("v_MAINID", receiptPointID.substring(susinGroupIcon.length()));
					map.put("companyID", companyID);
					
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
						strSQL.append("INSERT INTO TBRECEIPTPOINTINFO (DocID, ReceiptPointID, ReceiptPointName, ReceiptPointName2, ");
						strSQL.append("ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ExtReceptEmail, ReceiptMemberID, ");
                        strSQL.append("ReceiptMemberName, ReceiptMemberName2, ProcessDate, ReceiptMemberJobTitle, ReceiptMemberJobTitle2, DeptMemberSN) VALUES ('");
						strSQL.append(strDocID + "', '" + receiptGroupXML.getElementsByTagName("DEPTID").item(p).getTextContent() + "', N'");
						strSQL.append(makeRightField(receiptGroupXML.getElementsByTagName("DEPTNAME").item(p).getTextContent()) + "', N'");
                        strSQL.append(makeRightField(receiptGroupXML.getElementsByTagName("DEPTNAME2").item(p).getTextContent()) + "', '");
						strSQL.append("N', 'N', '1', 'N', '");
						strSQL.append(makeRightField(receiptGroupXML.getElementsByTagName("COMPANYID").item(p).getTextContent()) + "', '");
						strSQL.append("', N'', N'', NULL, N'', N'', '" + j + "');\n");

						j += 1;
					}
				}
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
		}
		
		return rtnVal;
	}

	@Override
	public String getLineTempletInfo(String formID, String userID, String companyID) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("companyID", companyID);
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getLineTempletInfo(map);
		
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
	public String getLineTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("100", companyID, lang);
		
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
		map.put("companyID", companyID);
		
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
			resultXML.append("<DATA4>" + getCode2Name("A04", docXML.getElementsByTagName("APRSTATE").item(k).getTextContent(), companyID, lang) + "</DATA4>");
			resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("APRMEMBERID").item(k).getTextContent()) + "</DATA5>");
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("APRMEMBERISDEPTYN").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("<DATA7>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE").item(k).getTextContent()) + "</DATA7>");
			resultXML.append("<DATA8>" + makeListField(docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent()) + "</DATA8>");
			resultXML.append("<DATA9>" + makeListField(docXML.getElementsByTagName("MEMBERDEPTNAME").item(k).getTextContent()) + "</DATA9>");
			resultXML.append("<DATA10>" + makeListField(docXML.getElementsByTagName("APRMEMBERJOBTITLE2").item(k).getTextContent()) + "</DATA10>");
			resultXML.append("<DATA11>" + makeListField(docXML.getElementsByTagName("MEMBERDEPTNAME2").item(k).getTextContent()) + "</DATA11>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(getCode2Name("A03", docXML.getElementsByTagName("APRTYPE").item(k).getTextContent(), companyID, lang)) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			if (lang.equals("1")) {
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
	public String getFormInfoDetail(String formID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		
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
	public String getFormRecvApr(String docID, String formID, String userID, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
        StringBuilder rtnXML = new StringBuilder();
        String subSQL = "";
        String rtnVal = "";
        
        strSQL.append("DELETE FROM TBRECEIPTPOINTINFO WHERE DocID = '" + docID.trim() + "';\n");
        
        String docList = getFormRecvAprDB(formID.trim(), userID.trim(), "1", companyID);
        Document docXML = commonUtil.convertStringToDocument(docList);
        Document deptXML = null;

        int dlength = docXML.getElementsByTagName("ROW").getLength();
        String extYN = "";
        
        rtnXML.append("<ROWS>");
        
        for (int k = 0; k < dlength; k++) {
        	subSQL = ezOrganService.getPropertyList(docXML.getElementsByTagName("DEPTID").item(k).getTextContent().trim(), "displayName;extensionAttribute2", lang);
        	
        	deptXML = commonUtil.convertStringToDocument(subSQL);
        	
        	if (deptXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().toLowerCase().equals(companyID.toLowerCase())) {
        		extYN = "N";
        	} else {
        		extYN = "Y";
        	}
        	
        	strSQL.append("INSERT INTO TBRECEIPTPOINTINFO (DocID, ReceiptPointID, ");
            strSQL.append("ReceiptPointName, ReceiptPointName2, ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ");
            strSQL.append("ExtReceptEmail, ReceiptMemberID, ReceiptMemberName, ReceiptMemberName2, ProcessDate, ");
            strSQL.append("ReceiptMemberJobTitle, ReceiptMemberJobTitle2, DeptMemberSN) VALUES ('" + docID.trim());
			strSQL.append("', '" + docXML.getElementsByTagName("DEPTID").item(k).getTextContent().trim());
			strSQL.append("', N'" + makeRightField(deptXML.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent()));
            strSQL.append("', N'" + makeRightField(deptXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent()));
			strSQL.append("', '" + extYN + "', 'N', '1', 'N', '" + deptXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent());
            strSQL.append("', '', '', '', NULL, '', '', '" + docXML.getElementsByTagName("DEPTSN").item(k).getTextContent().trim() + "');\n");

            rtnXML.append("<ROW><NAME>" + commonUtil.cleanValue(deptXML.getElementsByTagName("DISPLAYNAME" + commonUtil.getMultiData(lang)).item(0).getTextContent()));
            rtnXML.append("</NAME><DEPTID>" + docXML.getElementsByTagName("DEPTID").item(k).getTextContent().trim());
            rtnXML.append("</DEPTID><DEPTNAME>" + docID + "</DEPTNAME><EXTRECEPTYN>" + extYN);
			rtnXML.append("</EXTRECEPTYN><PROCESSYN>N</PROCESSYN><CANEDITYN>N</CANEDITYN><EMAIL>");
            rtnXML.append(deptXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "</EMAIL>");
            rtnXML.append("<DISPLAYNAME>" + commonUtil.cleanValue(deptXML.getElementsByTagName("DISPLAYNAME" + commonUtil.getMultiData(lang)).item(0).getTextContent()) + "</DISPLAYNAME>");
            rtnXML.append("<JOBTITLE></JOBTITLE><JOBTITLE2></JOBTITLE2></ROW>");
        }
        if (rtnXML.toString().trim().equals("<ROWS>") && !userID.trim().equals("")) {
        	String isUse = getCode2Name("A44", "002", companyID, lang);
        	
        	if (isUse.equals("1")) {
        		docList = getFormRecvAprDB(formID, userID, "2", companyID);
        		docXML = commonUtil.convertStringToDocument(docList);
        		dlength = docXML.getElementsByTagName("ROW").getLength();
        		
        		for (int p = 0; p < dlength; p++) {
        			strSQL.append("INSERT INTO TBRECEIPTPOINTINFO (DocID, ReceiptPointID, ");
                    strSQL.append("ReceiptPointName, ReceiptPointName2, ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ");
                    strSQL.append("ExtReceptEmail, ReceiptMemberID, ReceiptMemberName, ReceiptMemberName2, ProcessDate, ");
                    strSQL.append("ReceiptMemberJobTitle, ReceiptMemberJobTitle2, DeptMemberSN) VALUES ('" + docID);
					strSQL.append("', '" + docXML.getElementsByTagName("RECEIPTPOINTID").item(p).getTextContent());
					strSQL.append("', N'" + makeRightField(docXML.getElementsByTagName("RECEIPTPOINTNAME").item(p).getTextContent()));
                    strSQL.append("', N'" + makeRightField(docXML.getElementsByTagName("RECEIPTPOINTNAME2").item(p).getTextContent()));
					strSQL.append("', '" + makeRightField(docXML.getElementsByTagName("EXTRECEPTYN").item(p).getTextContent()));
					strSQL.append("', 'N', '" + makeRightField(docXML.getElementsByTagName("PROCESSSN").item(p).getTextContent()));
					strSQL.append("', '" + makeRightField(docXML.getElementsByTagName("CANEDITYN").item(p).getTextContent()));
					strSQL.append("', '" + makeRightField(docXML.getElementsByTagName("EXTRECEPTEMAIL").item(p).getTextContent()));
					strSQL.append("', '" + makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERID").item(p).getTextContent()));
					strSQL.append("', N'" + makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERNAME").item(p).getTextContent()));
                    strSQL.append("', N'" + makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERNAME2").item(p).getTextContent()));
					strSQL.append("', NULL, N'" + makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE").item(p).getTextContent()));
                    strSQL.append("', N'" + makeRightField(docXML.getElementsByTagName("RECEIPTMEMBERJOBTITLE2").item(p).getTextContent()));
                    strSQL.append("', '" + makeRightField(docXML.getElementsByTagName("DEPTMEMBERSN").item(p).getTextContent()) + "');\n");

                    rtnXML.append("<ROW><NAME>" + commonUtil.cleanValue(docXML.getElementsByTagName("RECEIPTPOINTNAME" + commonUtil.getMultiData(lang)).item(p).getTextContent()));
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
        
        try {
        	Map<String, Object> map = new HashMap<String, Object>();
        	map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
        	map.put("companyID", companyID);
        	
        	ezApprovalGDAO.transactionSQL(map);
        	
        	rtnVal = rtnXML.toString();;
        } catch (Exception e) {
        	rtnVal = "<ROWS/>";
        }
        
		return rtnVal;
	}

	@Override
	public String createNewDoc(String formID, String companyID) throws Exception {
		String tmpDocID = getNewID(companyID);
		String returnVal = "";

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", tmpDocID.trim());
		map.put("v_FORMID", formID);
		map.put("v_COMPANYID", companyID);
		map.put("companyID", companyID);
		
		try {
			ezApprovalGDAO.createNewDoc(map);
			returnVal = tmpDocID.trim();
		} catch (Exception e) {
			returnVal = "";
		}
		
		return returnVal;
	}

	@Override
	public String deleteDocInfo(String docID, String mode, String companyID) throws Exception {
		String strSQL = "";
		String rtnVal = "";
		
		strSQL = "APRDeleteDocInfo('" + docID + "', '" + mode.toUpperCase() + "');\n";
		
		if (!mode.toUpperCase().equals("QUERY")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map.put("companyID", companyID);
			try {
				ezApprovalGDAO.transactionSQL(map);
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		} else {
			rtnVal = strSQL;
		}
		
		return rtnVal;
	}

	@Override
	public String updateLineTempletDetailInfo(Document xmlDom, String companyID, String lang) throws Exception {
		StringBuffer strSQL = new StringBuffer();
		String rtnVal = "<RESULT>TRUE</RESULT>";
		
		NodeList docNode = xmlDom.getElementsByTagName("APRTEMP");
		NodeList rowNode = xmlDom.getElementsByTagName("ROW");
		
		String strUserID = docNode.item(0).getChildNodes().item(0).getTextContent();
		String strFormID = docNode.item(0).getChildNodes().item(1).getTextContent();
		String strAprlineSN = docNode.item(0).getChildNodes().item(2).getTextContent();
		String strAprTempletName = docNode.item(0).getChildNodes().item(3).getTextContent();
		
		if (strAprlineSN.trim().equals("")) {
			strAprlineSN = String.valueOf(getLineTempletSN(strFormID, strUserID, companyID));
		} else {
			rtnVal = deleteLineTempletDetailInfo(strFormID, strUserID, strAprlineSN, companyID);
		}
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			strSQL.append("INSERT INTO TBLINTEMPLET (UserID, FormID, AprLineSN, AprTempletName) ");
            strSQL.append("VALUES ('" + strUserID + "', '" + strFormID + "', '" + strAprlineSN);
			strSQL.append("', N'" + makeRightField(strAprTempletName) + "');\n");

			int i = 0;

			for (i = 0; i < rowNode.getLength(); i++) {
				strSQL.append("INSERT INTO TBLINTEMPLETDETAIL (UserID, FormID, AprLineSN, ");
				strSQL.append("AprMemberSN, AprType, AprState, AprMemberID, AprMemberIsDeptYN, ");
                strSQL.append("AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, AprMemberDeptID, MemberDeptName, MemberDeptName2)");
				strSQL.append(" VALUES ('" + strUserID + "', '" + strFormID);
				strSQL.append("', '" + strAprlineSN + "', '");
				strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(0).getTextContent()) + "', '");
				strSQL.append(getName2Code("A03", rowNode.item(i).getChildNodes().item(4).getTextContent(), companyID, lang).trim() + "', '");
				strSQL.append(getName2Code("A04", rowNode.item(i).getChildNodes().item(5).getTextContent(), companyID, lang).trim() + "', '");
				strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(9).getTextContent().trim()) + "', N'");
				strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(10).getTextContent().trim()) + "', N'");
				strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(18).getTextContent().trim()) + "', '");
				strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(19).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(22).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(23).getTextContent().trim()) + "', '");
				strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(11).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(20).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(rowNode.item(i).getChildNodes().item(21).getTextContent().trim()) + "');\n");
			}
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
	public String deleteLineTempletDetailInfo(String strFormID, String strUserID, String strAprlineSN, String companyID) throws Exception{
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", strFormID);
		map.put("v_USERID", strUserID);
		map.put("v_APRLINESN", strAprlineSN);
		
		try {
			ezApprovalGDAO.deleteLineTempletDetailInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String addToAprLine(String userID, String formID, String aprSN, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		listString = getListHeader("013", companyID, lang);
		
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
		
		String docList = addToAprLineDB(formID, userID, aprSN, companyID);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String getReceiptTempletInfo(String formID, String userID, String companyID) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		
		List<ApprGDeptTempletVO> apprGDeptTempletVOList = ezApprovalGDAO.getReceiptTempletInfo(map);
		
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
	public String getReceiptTempletDetailInfo(String formID, String userID, String aprSN, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("105", companyID, lang);
		
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
		map.put("companyID", companyID);
		
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
			if (lang.equals("1")) {
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
	public String getTempList(String companyID, String lang) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", "GROUP");
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
	public String getListXML(String groupID, String lang, String companyID) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		listString = getListHeader("023", companyID, lang);
		
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
			if (lang.equals("1")) {
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
	public String getTempList2(String groupID, String companyID, String lang) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", "ITEM");
		map.put("v_MAINID", groupID);
		
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
            if (lang.equals("1")) {
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
	public String getTempList3(String userID, String formID, String companyID, String lang) throws Exception {
		StringBuilder returnValue = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
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
	public String addToAprDept(String userID, String formID, String aprDeptSN, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		listString = getListHeader("023", companyID, lang);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String deleteReceiptTempletDetailInfo(String formID, String userID, String aprDeptSN, String companyID) throws Exception {
		String rtnValue = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_APRDEPTSN", aprDeptSN);
		
		try {
			ezApprovalGDAO.deleteReceiptTempletDetailInfo(map);
			rtnValue = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnValue = "<RESULT>FALSE</RESULT>";
		}
		return rtnValue;
	}

	@Override
	public String updateReceiptTempletDetailInfo(Document doc, String companyID) throws Exception {
		StringBuilder strSQL = new StringBuilder();

		String rtnVal = "<RESULT>TRUE</RESULT>";
		String strUserID = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(0).getTextContent();
		String strFormID = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(1).getTextContent();
		String strAprDeptSN = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(2).getTextContent();
		String strAprDeptTempletName = doc.getElementsByTagName("APRDEPT").item(0).getChildNodes().item(3).getTextContent();
		
		if (strAprDeptSN.trim().equals("")) {
			strAprDeptSN = getReceiptTempletSN(strFormID, strUserID, companyID);
		} else {
			rtnVal = deleteReceiptTempletDetailInfo(strFormID, strUserID, strAprDeptSN, companyID);
		}
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			strSQL.append("INSERT INTO TBDEPTTEMPLET (UserID, FormID, AprDeptSN, AprDeptTempletName) ");
            strSQL.append("VALUES ('" + strUserID + "', '" + strFormID + "', '" + strAprDeptSN);
			strSQL.append("', N'" + makeRightField(strAprDeptTempletName) + "');\n");

			for (int i = 0; i < doc.getElementsByTagName("ROW").getLength(); i++) {
                strSQL.append("INSERT INTO TBDEPTTEMPLETDETAIL (UserID, FormID, AprDeptSN, ");
                strSQL.append("AprDeptMemberSN, AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, ExtReceptYN, ");
                strSQL.append("ProcessYN, CanEditYN, ExtReceptEmail, AprMemberID, AprMemberName, AprMemberName2, ");
                strSQL.append("AprMemberJobTitle, AprMemberJobTitle2) VALUES ('" + strUserID + "', '" + strFormID);
				strSQL.append("', '" + strAprDeptSN + "', '");
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(0).getTextContent()) + "', '");
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(3).getTextContent()) + "', N'"); 
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getTextContent()) + "', N'");
                strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(12).getTextContent()) + "', '"); 
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(4).getTextContent()) + "', '");  
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(5).getTextContent()) + "', '");  
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(6).getTextContent()) + "', '");  
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(7).getTextContent()) + "', '");  
				strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(8).getTextContent()) + "', N'"); 
                strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(11).getTextContent()) + "', N'");
                strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(12).getTextContent()) + "', N'");
                strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(13).getTextContent()) + "', N'");
                strSQL.append(makeRightField(doc.getElementsByTagName("ROW").item(i).getChildNodes().item(14).getTextContent()) + "');\n");
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
		}
		
		return rtnVal;
	}

	@Override
	public String getTaskCategory(String deptCode, String companyID, String type) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTCODE", deptCode.trim());
		
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
	public String getTaskMiddleCategory(String deptCode, String companyID, String cateCode) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTCODE", deptCode.trim());
		map.put("v_CATECODE", cateCode.trim());
		
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
	public String getTaskSubCategory(String deptCode, String companyID, String cateCode, String strType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTCODE", deptCode.trim());
		map.put("v_CATECODE", cateCode.trim());
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
		
		listString = getListHeader("101", companyID, strType);
		
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
	public String getTaskInSubCategory(String deptCode, String companyID, String cateCode, String strType) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_SUBCATECODE", cateCode.trim());
		map.put("v_DEPTCODE", deptCode.trim());
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getTaskInSubCategory(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		String resultXML = makeTaskListXml(docXML, companyID, strType);
		
		return resultXML;
	}

	@Override
	public String getSimpleCabinetList(String companyID, String processDeptCode, String productionYear, String taskCode, String flag, String langType) throws Exception{
		String accountYear = getAccountingYear(EgovDateUtil.getToday(""), companyID, langType);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDEPTCODE", processDeptCode);
		map.put("v_PYEAR", productionYear);
		map.put("v_PACCOUNTPYEAR", accountYear);
		map.put("v_TASKCODE", taskCode);
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
		
		listString = getListHeader("095", companyID, langType);
		
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
			if (langType.equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TITLE2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("<DATA1>" + makeListField(docXML.getElementsByTagName("CABINETID").item(k).getTextContent()) + "</DATA1>");
			resultXML.append("<DATA2>" + makeListField(docXML.getElementsByTagName("TASKCODE").item(k).getTextContent()) + "</DATA2>");
			resultXML.append("<DATA3>" + makeListField(docXML.getElementsByTagName("CABINETCLASSNO").item(k).getTextContent()) + "</DATA3>");
			resultXML.append("<DATA4>" + makeListField(docXML.getElementsByTagName("OWNERID").item(k).getTextContent()) + "</DATA4>");
			resultXML.append("<DATA5>" + makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent()) + "</DATA5>");
			resultXML.append("<DATA6>" + makeListField(docXML.getElementsByTagName("TITLE2").item(k).getTextContent()) + "</DATA6>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, langType) + "</VALUE>");
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
	public String findTask(String deptCode, String title, String code, String flag, String companyID, String langType, String pageSize, String pageNO) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTCODE", deptCode.trim());
		map.put("v_TITLE", title.trim());
		map.put("v_TASKCODE", code.trim());
		map.put("v_LANGTYPE", commonUtil.getMultiData(langType));
		
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
			resultXML = makeTaskFullListXml(docXML, companyID, pageSize, pageNO, langType);
		} else if (flag.equals("2")) {
			resultXML = makeTaskListXmlAll(docXML, companyID, langType);
		} else {
			resultXML = makeTaskListXml(docXML, companyID, langType);
		}
		
		return resultXML;
	}

	@Override
	public String makeTaskFullListXml(Document docXML, String companyID, String pageSize, String pageNO, String langType) throws Exception{
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("098", companyID, langType);
		
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
			
			if (langType.equals("1")) {
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
			
			if (langType.equals("1")) {
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
			
			if (langType.equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("CNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("CNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (langType.equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MCNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("MCNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			
			if (langType.equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("SCNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPeriodString(makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()), companyID, langType) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepMethodString(makeListField(docXML.getElementsByTagName("KEEPINGMETHOD").item(k).getTextContent()), companyID, langType) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPlaceString(makeListField(docXML.getElementsByTagName("KEEPINGPLACE").item(k).getTextContent()), companyID, langType) + "</VALUE>");
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
	public String deleteOpinionInfo(String docID, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		String rtnVal = "";
		
		try {
			ezApprovalGDAO.deleteOpinionInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String updateOpinionInfo(Document docXML, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String docID = docXML.getElementsByTagName("ROW").item(0).getChildNodes().item(4).getTextContent();
		String rtnVal = deleteOpinionInfo(docID, companyID, lang);
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
				strSQL.append("INSERT INTO TBAPROPINIONINFO (DocID, UserID, OpinionGB, ");
                strSQL.append("Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
                strSQL.append("UserDeptName, UserDeptName2, OpinionSN) VALUES ('");
                strSQL.append(docID + "', '" + docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(5).getTextContent() + "', '");
                strSQL.append(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent() + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(10).getTextContent()) + "',N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(12).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(13).getTextContent()) + "', '");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(7).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(14).getTextContent()) + "', N'");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent()) + "', '");
                strSQL.append(makeRightField(docXML.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getTextContent()) + "');");
			}
			strSQL.append("UPDATE TBAPRDOCINFO SET HasOpinionYN = 'Y' WHERE DocID = '" + docID + "';");
			
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
	public String getDocHrefYear(String docID, String companyID) throws Exception {
		String rtnValue = EgovDateUtil.getTodayTime().substring(0, 4);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
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
	public String getAttachFileInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		String listString = "";
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		
		listString = getListHeader("041", companyID, lang);
		
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
		map.put("v_ORDERBY", orderOption1);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
			String tempUserDeptID, String tempUserDeptName, String tempUserDeptName2, String modifyFlag, String dirPath, String companyID) throws Exception {
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_ATTACHFILESN", attachSN.trim());
		
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
			String oldYear = getDocHrefYear(docID, companyID);
			String source = convWebToPath(docXML.getElementsByTagName("ATTACHFILEHREF").item(0).getTextContent(), dirPath);
			String target = dirPath + commonUtil.separator + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + "history" + commonUtil.separator +
							getDocDir(docID) + commonUtil.separator + docID.trim() + getNDigitNum(attachSN, 4) + getNDigitNum(String.valueOf(strSN), 4) + docXML.getElementsByTagName("ATTACHFILENAME").item(0).getTextContent();
			
			FileUtils.copyFile(new File(source), new File(target));
			
			target = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + companyID + commonUtil.separator + "uploadFile" + commonUtil.separator + oldYear + commonUtil.separator + "history" + commonUtil.separator +
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
		
			try {
				ezApprovalGDAO.updateHistoryForAttach(map1);
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}

		return rtnVal;
	}

	@Override
	public String updateAttachFileInfo(Document xmlDom, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String docID = xmlDom.getElementsByTagName("ROW").item(0).getChildNodes().item(3).getTextContent();
		String rtnVal = deleteAttachFileInfo(docID, companyID, lang);
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			String size = "";
			for (int k = 0; k < xmlDom.getElementsByTagName("ROW").getLength(); k++) {
				size = xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(8).getTextContent().replace("bytes", "").trim();
				
				strSQL.append("INSERT INTO TBAPRATTACHINFO (DocID, AttachFileSN, AttachFileName, ");
                strSQL.append("AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
                strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2,");
				strSQL.append("PageNum, DisplayName, BodyAttach) VALUES ('");
				strSQL.append(docID + "', '" + xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(2).getTextContent() + "', N'");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(10).getTextContent()) + "', N'");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent()) + "', '");
				strSQL.append(size + "', '" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(4).getTextContent()));
				strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(13).getTextContent()));
                strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(14).getTextContent()));
				strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent()));
                strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(16).getTextContent()));
				strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent()));
				strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(17).getTextContent()));
                strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(18).getTextContent()));
				strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent()));
				strSQL.append("', N'" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(12).getTextContent()));
                strSQL.append("', '" + makeRightField(xmlDom.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent()) + "');\n");
			}

			strSQL.append("UPDATE TBAPRDOCINFO SET HasAttachYN = 'Y' WHERE DocID = '" + docID + "';");
			
			try {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
				map.put("companyID", companyID);
				
				ezApprovalGDAO.transactionSQL(map);
				
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}
		
		return rtnVal;
	}

	@Override
	public String deleteAttachFileInfo(String docID, String companyID, String lang) {
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		try {
			ezApprovalGDAO.deleteAttachFileInfo(map);
			rtnVal = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			rtnVal = "<RESULT>FALSE</RESULT>";
		}
		
		return rtnVal;
	}

	@Override
	public String getListInfoXml(String listFlag, String listType, String companyID, String lang) throws Exception {
		String typeCode = getListTypeCode(listFlag, listType);
		String szListXml = getListInfo(typeCode, companyID, lang);
		
		return szListXml;
	}

	@Override
	public String getRecordList(Document doc, String lang) throws Exception {
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
				"And TBRECORD.DocID IS NOT NULL And SeperateAttachNo='00' ";
			break;

		case "5" :	// 이관목록
			listType = "005";
			strWhereClause = " And DocTransferFlag='1' And " +
                "DocTransferYear=(Select Max(DocTransferYear) From TBSEPERATEATTACH)  ";
			break;

		case "6" :	// 연기신청목록
			listType = "007";
			break;

		case "7" :	// 폐기대상 기록물
			listType = "001";

			String DFlag = getCode2Name("A35", "003", companyID, lang).toUpperCase().trim();
			if (DFlag == "Y")
			{
				// 사학 G버전. 폐기 대상은 완료 연도부터 보존기간 경과한 기록물.
				strWhereClause = " AND TBCABINET.TerminateFlag = '1' AND " + 
					EgovDateUtil.getTodayTime().substring(0, 4) + " - TBCABINET.ExpirationYear > TBCABINET.KeepingPeriod ";
			}
			else
			{
				// 일반 G버전. 폐기 대상은 이관된 기록물.
				strWhereClause = " And DocTransferFlag='1' ";
			}
			break;

		case "9" :	// 첨부대상 기록물
			listType = "001";
			usePublicFlag = true;
			strWhereClause = " And (TBRECORD.DocID IS NOT NULL And TBCABINET.OwnerDeptID='" +
				deptCode + "' And SeperateAttachNo='00') ";
			break;

		case "10" :	// 접수목록
			listType = "001";
			usePublicFlag = true;
			strWhereClause = " And (TBENDAPRDOCINFO.DocState='011' OR TBRECORD.DocType ='2') ";
			break;

		case "11" :	// 발송목록
			listType = "001";
			usePublicFlag = true;
			strWhereClause = " And (TBENDAPRDOCINFO.DocState='014' OR TBRECORD.DocType ='1') ";
			break;
		}
		
		if (usePublicFlag) {
			if (getIsUse("A22", "001", companyID, lang).equals("1")) {
				usePublicFlag = true; //보안등급 사용여부
			} else {
				usePublicFlag = false;
			}
		}
		if (orderBy.equals("")) {
			orderBy = " Order By CreateDate DESC, RecordID DESC, SEPERATEATTACHNO ASC ";
		}
		
		selectClause = "SELECT ROW_NUMBER() OVER( " + orderBy + " ) AS ROWNUM_,  N.* FROM ( "+
                " SELECT TBRECORD.RecordID, TBRECORD.DocID, TBRECORD.RegisterNo, TBSEPERATEATTACH.CreateDate, " +
                "TBENDAPRDOCINFO.DocType, TBSEPERATEATTACH.RegisterType, TBENDAPRDOCINFO.DocState," +   // 2011.04.06 수신문서 공람지정할수 있도록 DocState 추가
                "TBSEPERATEATTACH.CabinetID, TBSEPERATEATTACH.SeperateAttachNo , " + 
				"TBENDAPRDOCINFO.Href, TBENDAPRDOCINFO.ContainerID, TBENDAPRDOCINFO.FormID, " + 
				"TBENDAPRDOCINFO.WriterID, TBCABINET.ConfirmFlag, TBCABINET.CabinetClassNo, " + 
				"TBCABINET.ProcessDeptCode AS CabDeptCode, TBCABINET.OwnerDeptID, " + 
                "TBRECORD.RegisterDate, TBRECORD.AprMemberTitle, TBRECORD.DrafterName, TBRECORD.AttachFlag, " +
				"TBCABINET.OwnerTask, TBRECORD.RejectFlag ";

        fromClause = " FROM TBRECORD Left Join TBENDAPRDOCINFO " + 
			"On TBRECORD.DocID=TBENDAPRDOCINFO.DocID Inner Join TBSEPERATEATTACH " +
            "On TBRECORD.RecordID=TBSEPERATEATTACH.RecordID ";

		if (usePublicFlag) {
            fromClause += " Left Join TBEXPENDAPRDOCINFO " + 
				"On TBRECORD.DocID=TBEXPENDAPRDOCINFO.DocID ";

			selectClause += ", TBEXPENDAPRDOCINFO.SecurityApproval ";
		}
		
		String arrListInfo = getLVFieldInfo(listType, companyID, lang);
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
		
		cabJoinClause = getCabJoinClause(doc, deptCode, transFlag, listFlag, companyID);
		
		if (doc.getElementsByTagName("RECDEPTCODE").item(0) != null && doc.getElementsByTagName("RECDEPTCODE").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBRECORD.ProcessDeptCode = '" + makeRightField(doc.getElementsByTagName("RECDEPTCODE").item(0).getTextContent().trim()) + "' ";
		}

		if (doc.getElementsByTagName("TITLE").item(0) != null && doc.getElementsByTagName("TITLE").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBSEPERATEATTACH.Title Like N'%" + makeSearchField(doc.getElementsByTagName("TITLE").item(0).getTextContent().trim()) + "%' ";
		}

		if (doc.getElementsByTagName("REGTYPE").item(0) != null && doc.getElementsByTagName("REGTYPE").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBSEPERATEATTACH.RegisterType = '" + makeRightField(doc.getElementsByTagName("REGTYPE").item(0).getTextContent().trim()) + "' ";
		}
		if (doc.getElementsByTagName("SREGDATE").item(0) != null && doc.getElementsByTagName("SREGDATE").item(0).getTextContent().length() > 0) {
            strWhereClause += " AND TBRECORD.RegisterDate >= TO_DATE('" + makeRightField(doc.getElementsByTagName("SREGDATE").item(0).getTextContent().trim().substring(0, 19)) + "','YYYY.MM.DD HH24:MI:SS') ";
		}
		
		if (doc.getElementsByTagName("EREGDATE").item(0) != null && doc.getElementsByTagName("EREGDATE").item(0).getTextContent().length() > 0) {
            strWhereClause += " AND TBRECORD.RegisterDate <= TO_DATE('" + makeRightField(doc.getElementsByTagName("EREGDATE").item(0).getTextContent().trim().substring(0, 19)) + "','YYYY.MM.DD HH24:MI:SS') ";
		}
		
		if (doc.getElementsByTagName("SC").item(0) != null && doc.getElementsByTagName("SC").item(0).getTextContent().length() > 0) {
			strWhereClause += " AND TBRECORD.RecordID IN (Select RecordID " +
                "From TBSPECIALCATALOGINFO_REC Where SC1 Like N'%" +
				makeSearchField(doc.getElementsByTagName("SC").item(0).getTextContent().trim()) + "%' OR SC2 Like N'%" +
				makeSearchField(doc.getElementsByTagName("SC").item(0).getTextContent().trim()) + "%' OR SC3 Like N'%" + 
				makeSearchField(doc.getElementsByTagName("SC").item(0).getTextContent().trim()) + "%') ";
		}
		
        if (doc.getElementsByTagName("DRAFTER").item(0) != null && doc.getElementsByTagName("DRAFTER").item(0).getTextContent().length() > 0) {
            strWhereClause += " AND (TBENDAPRDOCINFO.WriterName Like N'%" + makeSearchField(doc.getElementsByTagName("DRAFTER").item(0).getTextContent().trim()) + "%' ";
            strWhereClause += " OR TBENDAPRDOCINFO.WriterName2 Like N'%" + makeSearchField(doc.getElementsByTagName("DRAFTER").item(0).getTextContent().trim()) + "%') ";
        }
        
        if (usePublicFlag) {
        	String userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6");
        	
        	if (userSecurityCode == null || userSecurityCode.equals(" ") || userSecurityCode.equals("")) {
        		userSecurityCode = "0";
        	}
        	
        	if (getIsUse("A22", "005", companyID, lang).equals("1")) {
        		strWhereClause += " AND (TBEXPENDAPRDOCINFO.SecurityCode >= '" + userSecurityCode + "' OR TBEXPENDAPRDOCINFO.SecurityCode IS NULL or GetIsLineInfo(TBRECORD.DocID, '" + userID + "') = 'Y') ";
        	} else {
        		strWhereClause += " AND (TBEXPENDAPRDOCINFO.SecurityCode >= '" + userSecurityCode + "' OR TBEXPENDAPRDOCINFO.SecurityCode IS NULL) ";
        	}
        }
        
        strSQL.append(selectClause);
        strSQL.append(extraSelectClause);
        strSQL.append(fromClause);
        strSQL.append(cabJoinClause);
        strSQL.append(" Where TBRECORD.DelFlag='0' AND TBSEPERATEATTACH.DelFlag='0' ");
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
        strSQLCnt.append(" Where TBRECORD.DelFlag='0' AND TBSEPERATEATTACH.DelFlag='0' ");
        strSQLCnt.append(strWhereClause);
        
        Map<String, Object> map = new HashMap<String, Object>();
		map.put("sqlString", "SELECT * FROM ( " + strSQL.toString());
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
		map1.put("sqlString", "SELECT COUNT(TBRECORD.RecordID) " + strSQLCnt.toString());
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
			
			if (arrList.getElementsByTagName("COLNAME").item(k).getTextContent().trim().toUpperCase().equals("TBRECORD.ATTACHFLAG")) {
				resultXML.append("<COLNAME>" + "HASATTACHYN" + "</COLNAME>");
			}
			if (arrList.getElementsByTagName("COLNAME").item(k).getTextContent().trim().toUpperCase().equals("TBRECORD.REJECTFLAG")) {
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
					resultXML.append(getRegTypeString(makeListField(docXML.getElementsByTagName("REGISTERTYPE").item(k).getTextContent()), companyID, lang));
					break;

				case "dtBool" :								// Y/N 형식의 데이터 타입
					String tempValue = makeListField(docXML.getElementsByTagName(fieldName).item(k).getTextContent().trim());
					if (tempValue == "1") {
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
				resultXML.append("</CELL>");
				
				if (fieldName.toUpperCase().equals("ATTACHFLAG")) {
					resultXML.append("<HASATTACHYN>" + docXML.getElementsByTagName("ATTACHFLAG").item(k).getTextContent() + "</HASATTACHYN>");
				}
				
				if (fieldName.toUpperCase().equals("REJECTFLAG")) {
					resultXML.append("<REJECTFLAG>" + docXML.getElementsByTagName("REJECTFLAG").item(k).getTextContent() + "</REJECTFLAG>");
				}
				
			}
			resultXML.append("</ROW>");
		}
		resultXML.append("</ROWS>");
		resultXML.append("</LISTVIEWDATA>");
		resultXML.append("</DOCLIST>");
		
		return resultXML.toString();
	}

	@Override
	public String getCodeInfo(String companyID, String lang) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
				
				if (lang.equals("1")) {
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
	public String getAttachDocInfo(String docID, String mode, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("042", companyID, lang);
		
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
		map.put("v_ORDERBY", orderOption1);
		
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
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String isCabCharger(String companyID, String cabClassNo, String userID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CabClassNo", cabClassNo);
		map.put("v_UserID", userID);
		
		int result = ezApprovalGDAO.isCabCharger(map);
		
		return "<RESULT>" + result + "</RESULT>";
	}

	@Override
	public String updateAttachDocInfo(Document docXML, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String docID = "";
		
		if (docXML.getElementsByTagName("DATA3").item(0) != null) {
			docID = docXML.getElementsByTagName("DATA3").item(0).getTextContent();
		}
		String rtnVal = deleteAttachDocInfo(docID, companyID, lang);
		int tempSN = 0;
		
		if (rtnVal.equals("<RESULT>TRUE</RESULT>")) {
			for (int k = 0; k < docXML.getElementsByTagName("DATA1").getLength(); k++) {
				tempSN = docXML.getElementsByTagName("DATA1").getLength() - k;
				
				strSQL.append("INSERT INTO TBAPRDOCATTACHINFO (DocID, AttachSN, AttachDocName, ");
                strSQL.append("AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
                strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2) VALUES ('");
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
				strSQL.append(makeRightField(docXML.getElementsByTagName("DATA16").item(k).getTextContent()) + "');\n");    //DEPTNAME2
			}
			strSQL.append("UPDATE TBAPRDOCINFO SET HasAttachYN = 'Y' WHERE DocID = '" + docID + "';");
			
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
	public String deleteAttachDocInfo(String docID, String companyID, String lang) throws Exception{
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		try {
			ezApprovalGDAO.deleteAttachDocInfo(map);
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String getDocInfo(String docID, String mode, String selected, String companyID) throws Exception {
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
						selectSQL = ", " + selecteds[k];
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

		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getDocInfo(map);
		
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
			rtnXML.append("<SPECIALRECORDCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent())) + "</SPECIALRECORDCODE>");
			rtnXML.append("<PUBLICITYCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent())) + "</PUBLICITYCODE>");
			rtnXML.append("<LIMITRANGE>" + makeXMLString(makeListField(docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent())) + "</LIMITRANGE>");
			rtnXML.append("<PAGENUM>" + makeXMLString(makeListField(docXML.getElementsByTagName("PAGENUM").item(0).getTextContent())) + "</PAGENUM>");
			rtnXML.append("<CABINETID>" + makeXMLString(makeListField(docXML.getElementsByTagName("CABINETID").item(0).getTextContent())) + "</CABINETID>");
			rtnXML.append("<TASKCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("TASKCODE").item(0).getTextContent())) + "</TASKCODE>");
			rtnXML.append("<DOCNUMCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent())) + "</DOCNUMCODE>");
			rtnXML.append("<ORGDOCNUMCODE>" + makeXMLString(makeListField(docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent())) + "</ORGDOCNUMCODE>");
			rtnXML.append("<SEPERATEATTACHXML>" + makeXMLString(makeListField(docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent())) + "</SEPERATEATTACHXML>");
			rtnXML.append("<SUMMARY>" + makeXMLString(makeListField(docXML.getElementsByTagName("SUMMARY").item(0).getTextContent())) + "</SUMMARY>");
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
	public String saveRecReadHist(String readRecXML) throws Exception {
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
		
		try {
			ezApprovalGDAO.saveRecReadHist(map);
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String receiverChk(String deptID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTID", deptID);
		
		int rtnVal = ezApprovalGDAO.receiverChk(map);
		
		if (rtnVal == 0) {
			return "false";
		} else {
			return "true";
		}
	}

	@Override
	public String getEA5Value(String msg) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CNVALUE", msg);
		
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
	public String getMyTaskCode(String userID, String deptID, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		
		List<ApprGTaskVO> apprGTaskVOList = ezApprovalGDAO.getMyTaskCode(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGTaskVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGTaskVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		for (int k = 0; k < docXML.getElementsByTagName("ROW").getLength(); k++) {
			docXML.getElementsByTagName("RECTYPECODE").item(k).setTextContent(getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, lang));
		}
		
		return commonUtil.convertDocumentToString(docXML);
	}

	@Override
	public String setMyTaskCode(String userID, String deptID, String cabinetID, String taskCode, String type, String companyID) throws Exception {
		String result = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_CABINETID", cabinetID);
		map.put("v_TASKCODE", taskCode);
		map.put("v_TYPE", type);
		
		try {
			ezApprovalGDAO.setMyTaskCode(map);
			result = "OK";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	@Override
	public String getCabinetInfo(String cabinetID, String companyID, String strType) throws Exception {
		StringBuilder strXML = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabinetID.trim());
		
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
		strXML.append("<CABCLASSNO>" + docXML.getElementsByTagName("CABINETCLASSNO").item(0).getTextContent() + "</CABCLASSNO>");
		strXML.append("<TITLE>" + docXML.getElementsByTagName("TITLE").item(0).getTextContent() + "</TITLE>");
		strXML.append("<TITLE2>" + docXML.getElementsByTagName("TITLE2").item(0).getTextContent() + "</TITLE2>");
		strXML.append("<DEPTCODE>" + docXML.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent() + "</DEPTCODE>");
		strXML.append("<VOLNO>" + docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent() + "</VOLNO>");
		strXML.append("<TASKCODE>" + docXML.getElementsByTagName("TASKCODE").item(0).getTextContent() + "</TASKCODE>");
		strXML.append("<CATECODE>" + docXML.getElementsByTagName("CATEGORYCODE").item(0).getTextContent() + "</CATECODE>");
		strXML.append("<MCATECODE>" + docXML.getElementsByTagName("MCATEGORYCODE").item(0).getTextContent() + "</MCATECODE>");
		strXML.append("<SCATECODE>" + docXML.getElementsByTagName("SUBCATEGORYCODE").item(0).getTextContent() + "</SCATECODE>");
		strXML.append("<REGSN>" + docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent() + "</REGSN>");
		strXML.append("<DISPCABCLASSNO>" + getCabinetNo(docXML.getElementsByTagName("PROCESSDEPTCODE").item(0).getTextContent(), docXML.getElementsByTagName("TASKCODE").item(0).getTextContent(), docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent(), docXML.getElementsByTagName("REGSERIALNO").item(0).getTextContent(), docXML.getElementsByTagName("VOLUMENO").item(0).getTextContent()) + "</DISPCABCLASSNO>");
		strXML.append("<RECTYPE>" + docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent() + "</RECTYPE>");
		strXML.append("<PRODUCEYEAR>" + docXML.getElementsByTagName("PRODUCTIONYEAR").item(0).getTextContent() + "</PRODUCEYEAR>");
		strXML.append("<RECTYPEDES>" + getRecordTypeString(docXML.getElementsByTagName("RECTYPECODE").item(0).getTextContent(), companyID, strType) + "</RECTYPEDES>");
		strXML.append("<DISPFLAG>" + docXML.getElementsByTagName("DISPLAYRECFLAG").item(0).getTextContent() + "</DISPFLAG>");
		strXML.append("<DISPENDDATE>" + convertDate(docXML.getElementsByTagName("DISPLAYENDDATE").item(0).getTextContent()) + "</DISPENDDATE>");
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
	public String registerSepAttach(Document doc) throws Exception {
		String strSQL = "";
		
		String recID = doc.getElementsByTagName("RECORDID").item(0).getTextContent();
		String cabID = doc.getElementsByTagName("CABINETID").item(0).getTextContent();
		String title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
		String numOfPage = doc.getElementsByTagName("NUMOFPAGE").item(0).getTextContent();
		String regType = doc.getElementsByTagName("REGTYPE").item(0).getTextContent();
		String summary = doc.getElementsByTagName("SUMMARY").item(0).getTextContent();
		String recType = doc.getElementsByTagName("AVTYPE").item(0).getTextContent();
		String companyID = doc.getElementsByTagName("COMPANYID").item(0).getTextContent();
		
		strSQL = registerSepAttachEx(recID, cabID, title, numOfPage, regType, summary, recType, companyID, "");
		
		if (strSQL.equals("FALSE")) {
			return "<RESULT>FALSE</RESULT>";
		} else {
			try {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
				map.put("companyID", companyID);
				
				ezApprovalGDAO.transactionSQL(map);
				
				return "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				return "<RESULT>FALSE</RESULT>";
			}
		}
	}

	@Override
	public String getHistoryForDoc(String docID, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("064", companyID, lang);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String getHistoryForLine(String docID, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("062", companyID, lang);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String getHistoryForAttach(String docID, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("061", companyID, lang);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String getHistoryForLineDetail(String docID, String modifySN, String sortHeader, String sortOption, String companyID, String lang) throws Exception {
		StringBuffer resultXML = new StringBuffer();
		String orderOption1 = "";
		String listString = "";
		listString = getListHeader("063", companyID, lang);
		
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
		map.put("v_MODIFYSN", modifySN.trim());
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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
	public String deleteTmpDocInfo(String userID, String sn, String path, String companyID, String lang) throws Exception {
		String rtnVal = "";
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PUSERID", userID.trim());
		map.put("v_PSN", sn);
		
		try {
			String href = ezApprovalGDAO.deleteTmpDocInfo(map);
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
			String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		String result = "";
		boolean rtnVal = true;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_USERID", userID.trim());
		
		int aprCount = ezApprovalGDAO.doProcessCount(map);
		
		if (aprCount < 1 && !aprState.equals(staASmikyul)) {
			rtnVal = false;
		} else {
			switch (aprState) {
			case "000":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				break;
				
			case "003":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = doApprove(docID, userID, aprState, userName, userName2, dirPath, deptID, proxyUserID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				break;
				
			case "004":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = doBansong(docID, userID, aprState, dirPath, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				break;
				
			case "005":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = doBoryu(docID, userID, aprState, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				break;
				
			case "001":
				if (rtnVal) {
					subSQL = updateDocInfo(strXML, userID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}

				if (rtnVal) {
					subSQL = makeTmpDocInfo(userID, docID, proxyUserID, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				break;
			}
			
			if (rtnVal) {
				try {
					Map<String, Object> map1 = new HashMap<String, Object>();
					map1.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
					map1.put("companyID", companyID);
					
					ezApprovalGDAO.transactionSQL(map1);
					
					rtnVal = true;
					result = "<RESULT>TRUE</RESULT>";
				} catch (Exception e) {
					rtnVal = false;
					result = "<RESULT>FALSE</RESULT>";
				}
			}
		}
		
		chkDocDelete(docID, docID, rtnVal, userID, deptID, dirPath, companyID);
		
		return result;
	}

	@Override
	public String getTotalAttachSize(String docID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
	public String chkAprLines(Document resultXML, String lang) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<RESULT>");
		for (int k = 0; k < resultXML.getElementsByTagName("ROW").getLength(); k++) {
			rtnVal.append(chkAprLine(resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(9).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(18).getTextContent().trim(), 
					resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(19).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(22).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(23).getTextContent().trim(), 
					resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(11).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(20).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(21).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(15).getTextContent().trim(), lang));
		}
		
		rtnVal.append("</RESULT>");
		
		return rtnVal.toString();
	}

	@Override
	public String chkDeptLines(Document resultXML, String companyID, String lang) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		String susinGroupIcon = getCode2Name("A53", "001", companyID, lang);
		
		rtnVal.append("<RESULT>");
		
		for (int k = 0; k < resultXML.getElementsByTagName("ROW").getLength(); k++) {
			if (!resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent().trim().substring(0, susinGroupIcon.length()).equals(susinGroupIcon)) {
				if (resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(3).getTextContent().trim().equals("N")) {
					rtnVal.append(chkAprLine(resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent().trim(), "", 
							resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent().trim(), "", resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(1).getTextContent().trim(), resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(0).getTextContent().trim(), "", 
							resultXML.getElementsByTagName("ROW").item(k).getChildNodes().item(6).getTextContent().trim(), lang));
				}
			}
		}
		
		rtnVal.append("</RESULT>");
		
		return rtnVal.toString();
	}

	@Override
	public String getOpinionCount(String docID, String userID, String ingFlag, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_USERID", userID);
		map.put("v_INGFLAG", ingFlag.trim().toUpperCase());
		
		int result = ezApprovalGDAO.getOpinionCount(map);
		
		return String.valueOf(result);
	}

	@Override
	public String updateHistoryForLine(String docID, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName,
			String userDeptName2, String chkFlag, String companyID) throws Exception{
		boolean addFlag = true;
		
		if (!chkFlag.equals("MUST")) {
			addFlag = compareLineHistory(docID, companyID);
		}
		
		boolean rtn = true;
		
		if (addFlag) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_USERID", userID.trim());
			map.put("v_USERNAME", userName.trim());
			map.put("v_USERNAME2", userName2.trim());
			map.put("v_USERJOBTITLE", userJobTitle.trim());
			map.put("v_USERJOBTITLE2", userJobTitle2.trim());
			map.put("v_DEPTID", userDeptID.trim());
			map.put("v_DEPTNAME", userDeptName.trim());
			map.put("v_DEPTNAME2", userDeptName2.trim());
			
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
	public String getApprovalPWD1(String dUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", dUserID);
		
		return ezApprovalGDAO.getApprovalPWD1(map);
	}

	@Override
	public String getApproveDocInfo(String docID, String companyID, String lang) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<APROVEDATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
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
		rtnVal.append(getDocInfo(docID, "APR", "ALL", companyID));
		rtnVal.append("</DOCINFO>");
		rtnVal.append("<ATTACHINFO>");
		rtnVal.append(getAttachInfo(docID, "APR", "", "", companyID, lang));
		rtnVal.append("</ATTACHINFO>");
		rtnVal.append("<APRLINEINFO>");
		rtnVal.append(getAprLineInfo(docID, "", "", companyID, lang));
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
	public String getSignInfo(String docID, String companyID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<SIGNINFOS>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
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
	public String getCabinetNum(String deptID, String subID, String companyID, String docID, String lang) throws Exception {
		String strXML = "";
		
		strXML = "<PARAMETERS><TYPE1>002</TYPE1><TYPE2>" + deptID.trim() +
                "</TYPE2><TYPE3>" + subID.trim() + "</TYPE3><COMPANYID>" +
                companyID.trim() + "</COMPANYID><DOCID>" + docID + "</DOCID><LANGTYPE>" + lang + "</LANGTYPE></PARAMETERS>";
		
		String rtnVal = getRegSN(strXML);
		
		return "<REGNUM>" + rtnVal + "</REGNUM>";
	}

	@Override
	public String rollbackCabinetNum(String deptID, String subID, String sn, String companyID, String docID, String lang) throws Exception {
		String strXML = "";
		
		strXML = "<PARAMETERS><TYPE1>002</TYPE1><TYPE2>" + deptID.trim() + 
				"</TYPE2><TYPE3>" + subID.trim() + "</TYPE3><SN>" + sn.trim() +
                "</SN><COMPANYID>" + companyID.trim() + "</COMPANYID><DOCID>" + docID.trim() + "</DOCID><LANGTYPE>" + lang + "</LANGTYPE></PARAMETERS>";
		
		String rtnVal = rollbackRegSN(strXML);
		
		return rtnVal;
	}

	@Override
	public String updateSignInfo(Document xmlDom, String companyID, String mode) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "";
		String docID = xmlDom.getElementsByTagName("DOCID").item(0).getTextContent().trim();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		int aprSN = ezApprovalGDAO.updateSignInfoAprSN(map);
		int signLength = xmlDom.getElementsByTagName("SIGNINFO").getLength();
		int maxAprSN = 0;
		
		for (int k = 0; k < signLength; k++) {
			maxAprSN = aprSN + k + 1;
			
			strSQL.append("INSERT INTO TBSIGNINFO (DocID, AprSN, SignType, SignName, Content) ");
            strSQL.append("VALUES ('" + docID + "', '" + maxAprSN + "', '");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("SIGNTYPE").item(k).getTextContent().trim()) + "', N'");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("SIGNNAME").item(k).getTextContent().trim()) + "', N'");
			strSQL.append(makeRightField(xmlDom.getElementsByTagName("CONTENT").item(k).getTextContent().trim()) + "');\n");
		}
		
		if (mode.toUpperCase().equals("QUERY")) {
			return strSQL.toString();
		} else {
			try {
				Map<String, Object> map2 = new HashMap<String, Object>();
				map2.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
				map2.put("companyID", companyID);
				
				ezApprovalGDAO.transactionSQL(map2);
				
				rtnVal = "<RESULT>TRUE</RESULT>";
			} catch (Exception e) {
				rtnVal = "<RESULT>FALSE</RESULT>";
			}
		}
		
		return rtnVal;
	}

	@Override
	public String getCallBackYN(String docID, String tempUserID, String companyID) throws Exception {
		boolean rtnVal = true;
		String rtnXML = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_USERID", tempUserID);
		
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
	public String getCallBackYNForceLine(String docID, String tempUserID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_USERID", tempUserID.trim());
		
		List<ApprGLineTempletVO> apprGLineTempletVOList = ezApprovalGDAO.getCallBackYNForceLine(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGLineTempletVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGLineTempletVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return null;
	}

	@Override
	public String getTotalDownload(String docID, String mode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID.trim());
		map.put("v_PMODE", mode);
		
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
	public String getReceiveDocList(String userID, String deptID, String mode, String pageSize, String pageNum, String sortHeader, String sortOption, String companyID, String userLang,
			String searchQuery, Document xmlDomSub) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		String basicOrder = getCode2Name("A18", "001", companyID, userLang);
		String basicOrderReverse = "desc";
		
		if (basicOrder.toLowerCase().equals("desc")) {
			basicOrderReverse = "";
		} else {
			basicOrder = "";
		}
		
		String listString = "";
		
		if (mode.equals("simsa")) {
			listString = getListHeader("005", companyID, userLang);
		} else {
			listString = getListHeader("004", companyID, userLang);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getReceiveDocListCount(mode, userID, deptID, getDocManageDeptInfo(deptID), searchQuery.trim(), companyID, xmlDomSub);
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
						orderOption1 = "TBAPRRECEIPTPROCESSINFO." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " ";
						orderOption2 = "a." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
					} else {
						orderOption1 = "TBAPRRECEIPTPROCESSINFO." + listXML.getElementsByTagName("COLNAME").item(k).getTextContent() + " desc ";
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
		
		String docList = getReceiveDocList(mode, userID, deptID, getDocManageDeptInfo(deptID), querySize, querySize2, orderOption1, orderOption2, basicOrder, basicOrderReverse, searchQuery, xmlDomSub, companyID);
		
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
						fieldName = fieldName + commonUtil.getMultiData(userLang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, userLang) + "</VALUE>");
				
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
	public String gongRamDocInfo(String docID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_ORGDOCID", docID.trim());
		
		String gongRamDocID = makeListField(ezApprovalGDAO.gongRamDocInfo(map));
		
		if (gongRamDocID.equals("")) {
			gongRamDocID = "NONE";
		}
		
		return gongRamDocID;
	}

	@Override
	public String getOrgDocInfo(String docID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		
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
	public String getReceivedDocInfo(String docID, String companyID, String lang) throws Exception {
		StringBuilder rtnVal = new StringBuilder();
		
		rtnVal.append("<RECEIVEDATA>");
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
		rtnVal.append(getDocInfo(docID, "APR", "ALL", companyID));
		rtnVal.append("</DOCINFO>");
		rtnVal.append("<ATTACHINFO>");
		rtnVal.append(getAttachInfo(docID, "APR", "", "", companyID, lang));
		rtnVal.append("</ATTACHINFO>");
		rtnVal.append("<CONVDOCINFO>");
		rtnVal.append("<HAPYUI>" + makeXMLString(getCode2Name("A36", "001", companyID, lang)) + "</HAPYUI>");
		rtnVal.append("<GAMSA>" + makeXMLString(getCode2Name("A36", "002", companyID, lang)) + "</GAMSA>");
		rtnVal.append("<RELAY>" + makeXMLString(getCode2Name("A36", "003", companyID, lang)) + "</RELAY>");
		rtnVal.append("<EXCHANGE>" + makeXMLString(getCode2Name("A36", "004", companyID, lang)) + "</EXCHANGE>");
		rtnVal.append("<RELAY2>" + makeXMLString(getCode2Name("A36", "005", companyID, lang)) + "</RELAY2>");
		rtnVal.append("</CONVDOCINFO><DELIVERYNO>");
        rtnVal.append(sn);
		rtnVal.append("</DELIVERYNO></RECEIVEDATA>");
		
		return rtnVal.toString();
	}

	@Override
	public String getDocRecvState(String docID, String deptID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_DEPTID", deptID);
		
		String result = ezApprovalGDAO.getDocRecvState(map);
		
		return result;
	}

	@Override
	public String setJijung(String docID, String receiveSN, String processorID, String processorName, String processorJobTitle, String receivedDeptID, String receivedDeptName, String docState,
			String processorName2, String processorJobTitle2, String receivedDeptName2, String companyID, String lang) throws Exception {
		String flag = getCode2Name("A35", "002", companyID, lang).toUpperCase().trim();
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
		
		try {
			ezApprovalGDAO.setJijung(map);
			sendMsg(docID, processorID, "JIJUNG", companyID, lang);
			
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String updateSusinDocInfo(String orgDocID, String docID, String deptID, String userID, String displayName1, String displayName2, String companyID) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String rtnVal = "";
		
        strSQL.append("Update TBAPRRECEIPTPROCESSINFO SET ProcessDocID = '" + docID);
		strSQL.append("' , AprState = '" + staASJubSu + "' Where DocID = '" + docID);
		strSQL.append("' AND ReceivedDeptID = '" + deptID + "';\n");

		strSQL.append("UPDATE TBDOCDELIVERY SET ChargeID = '");
		strSQL.append(makeRightField(userID));
		strSQL.append("', ChargeName = N'" + makeRightField(displayName1));
        strSQL.append("', ChargeName2 = N'" + makeRightField(displayName2));
		strSQL.append("' WHERE DocID = '" + docID + "' AND ManageDeptID = '");
		strSQL.append(makeRightField(deptID) + "';\n");
		
		strSQL.append(updateSusinResult(orgDocID, deptID, userID, "I", displayName1, displayName2, companyID));
		
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
	public String getNextDocInfo(String docID, String userID, String userDeptID, String companyID, String lang) throws Exception {
		String strXML = "";
		String basicOrder = getCode2Name("A18", "001", companyID, lang);
		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = getIsUse("A23", "001", companyID, lang);
		
		if (proxyOption.equals("1")) {
			userIDs = getProxyUser(userID, lang);
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
	public String registerCabinet(Document xmlDom, String strLang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String createDate = EgovDateUtil.getTodayTime();
		String deptCode = xmlDom.getElementsByTagName("DEPTCODE").item(0).getTextContent();
		String taskCode = xmlDom.getElementsByTagName("TASKCODE").item(0).getTextContent();
		String regSN = formatSerialNum(getSerialNum("001", deptCode, taskCode, companyID, strLang));
		String produceY = getAccountingYear(createDate, companyID, strLang);
		String cabinetClassNO = deptCode + taskCode + produceY + regSN;
		String specialFlag = xmlDom.getElementsByTagName("SPECIALFLAG").item(0).getTextContent();
		
		strSQL.append("Insert Into TBCABINETCLASS (CabinetClassNo, ProductionYear, ");
        strSQL.append("RegSerialNo, TerminateFlag, Title, Title2, RecTypeCode, ExpirationYear, ");
        strSQL.append("KeepingMethod, KeepingPlace, DisplayEndDate, DisplayReason, OwnerName, OwnerName2, ");
		strSQL.append("OwnerID, OldCabinetFlag, ModifyFlag, SpecialCatalogFlag, ConfirmFlag, ");
        strSQL.append("CreateDate, KeepingPeriod, DisplayRecFlag, ProcessDeptCode, ProcessDeptName, ProcessDeptName2, ");
        strSQL.append("TaskCode, TaskName, TaskName2, TransDelayFlag, OwnerDeptID, OwnerTask, DelayEndYFlag, ");
		strSQL.append("DelFlag) VALUES ('" + makeRightField(cabinetClassNO) + "', '" + makeRightField(produceY));
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
		strSQL.append("', '" + makeRightField("0") + "', " + makeRightField("SYSDATE"));
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
		strSQL.append("', '" + makeRightField("0") + "');\n");
		
		if (!specialFlag.equals("0")) {
			subSQL = saveSpecialInfoCab(specialFlag, cabinetClassNO, xmlDom);
			
			if (subSQL.equals("FALSE")) {
				return "<RESULT>FALSE</RESULT>";
			} else {
				strSQL.append(subSQL);
			}
		}

		try {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map1.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map1);
			
			return "<RESULT>" + cabinetClassNO + "001" + "</RESULT>";
		} catch (Exception e) {
			rollbackSN("001", deptCode, taskCode, regSN, companyID, strLang);
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String getNewVolumeNo(String cabClassNO, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABCLASSNO", cabClassNO.trim());
		
		String result = ezApprovalGDAO.getNewVolumeNo(map);
		
		if (result.length() > 0) {
			return "<RESULT>" + result + "</RESULT>";
		} else {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	@Override
	public String addNewVolume(String cabClassNO, String newVolNO, String companyID) throws Exception {
		String createDate = EgovDateUtil.getTodayTime();
		String cabID = cabClassNO + formatVolNum(newVolNO);
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabID);
		map.put("v_VOLUMENO", formatVolNum(newVolNO));
		map.put("v_CABCLASSNO", cabClassNO);
		map.put("v_CREATEDATE", createDate);
		
		try {
			ezApprovalGDAO.addNewVolume(map);
			result = "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			result = "<RESULT>FALSE</RESULT>";
		}
		
		return result;
	}

	@Override
	public String getFindSimpleCabinetList(String processDeptCode, String productionYear, String searchKeyword, String flag, String companyID, String langType) throws Exception {
		String strMultiData = commonUtil.getMultiData(langType);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDEPTCODE", processDeptCode);
		map.put("v_PYEAR", productionYear);
		map.put("v_SEARCHNAME", searchKeyword);
		map.put("v_FLAG", flag);
		map.put("v_LANGTYPE", strMultiData);
		
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
		
		listString = getListHeader("096", companyID, langType);
		
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
			resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TITLE").item(k).getTextContent()) + "</VALUE>");
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getRecordTypeString(makeListField(docXML.getElementsByTagName("RECTYPECODE").item(k).getTextContent()), companyID, langType) + "</VALUE>");
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
	public String setBebu(Document xmlDom, String dirPath, String companyID, String lang) throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String docID = xmlDom.getDocumentElement().getAttribute("DocID").trim();
		String receiveSN = xmlDom.getDocumentElement().getAttribute("ReceiveSN").trim();
		String sentDeptID = xmlDom.getDocumentElement().getAttribute("SendDeptID").trim();
		String receiveDeptID = xmlDom.getDocumentElement().getAttribute("ReceivedDeptID").trim();
		
		NodeList objRows = xmlDom.getDocumentElement().getChildNodes().item(0).getChildNodes();
		
		String subSQL = "";
		String gFlag = getCode2Name("A35", "002", companyID, lang).toUpperCase().trim();
		
		if (!gFlag.equals("G")) {
			strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, ");
            strSQL.append("SentDeptID, SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, ");
			strSQL.append("DocState, AprState, ProcessDate, ProcessYN, ProcessDocID, ");
            strSQL.append("ProcessorID, ProcessorName, ProcessorName2, ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) ");
			strSQL.append("SELECT '" + receiveSN + "', '" + docID + "', ReceivedDeptID, ");
            strSQL.append("ReceivedDeptName, ReceivedDeptName2, '" + makeRightField(objRows.item(0).getTextContent()));
			strSQL.append("', '" + makeRightField(objRows.item(1).getTextContent()) + "', '"+ makeRightField(objRows.item(2).getTextContent()) + "', DocState, '");
			strSQL.append(staASBaeBu + "', SYSDATE");
            strSQL.append(", '1', ProcessDocID, NULL, NULL, NULL, NULL, NULL, ParentsDocID FROM ");
            strSQL.append("TBAPRRECEIPTPROCESSINFO WHERE DocID ='" + docID);
			strSQL.append("' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N';\n");

			strSQL.append("UPDATE TBAPRRECEIPTPROCESSINFO SET ProcessDate = ");
			strSQL.append("SYSDATE, ProcessYN = 'Y' WHERE DocID ='");
			strSQL.append(docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N';\n");

			strSQL.append("UPDATE TBAPRRECEIPTPROCESSINFO SET ProcessYN = 'N' ");
			strSQL.append("WHERE DocID ='" + docID + "' AND ReceiveSN = '" + receiveSN);
			strSQL.append("' AND ProcessYN = '1';\n");

			// 수정(2006.06.13) : 배부 시 현재 부서의 결재선 정보는 삭제하도록 수정
			strSQL.append("DELETE FROM TBEXPAPRLINE WHERE DocID = '" + docID + "';\n");
            strSQL.append("DELETE FROM TBAPRLINEINFO WHERE DocID = '" + docID + "';\n");
            
            subSQL = updateDeliveryList(docID, sentDeptID, ezOrganService.getPropertyValue(sentDeptID, "displayName"), ezOrganService.getPropertyValue(sentDeptID, "displayName2"), objRows.item(0).getTextContent(),
            		objRows.item(1).getTextContent(), objRows.item(2).getTextContent(), "", "", "", sentDeptID, "", companyID, "QUERY", lang);
            
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
 					strSQL.append("UPDATE TBAPRRECEIPTPROCESSINFO SET AprState = '" + staASBaeBu);
                    strSQL.append("', ProcessDate = SYSDATE" );
                    strSQL.append(", ReceivedDeptID = '" + makeRightField(objRows.item(0).getTextContent()));
                    strSQL.append("', ReceivedDeptName = N'" + makeRightField(objRows.item(1).getTextContent()));
                    // 2010.08.03 다국어 
                    strSQL.append("', ReceivedDeptName2 = N'" + makeRightField(objRows.item(2).getTextContent()));
                    strSQL.append("' WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "'");
                    strSQL.append("AND ReceivedDeptID IN (" + getDocManageDeptInfo(sentDeptID) + ");\n");
 				} else {
 					subSQL = doBebuDoc(docID, xmlDom.getDocumentElement().getChildNodes().item(k).getChildNodes().item(0).getTextContent(),
 							xmlDom.getDocumentElement().getChildNodes().item(k).getChildNodes().item(1).getTextContent(), xmlDom.getDocumentElement().getChildNodes().item(k).getChildNodes().item(2).getTextContent(),
 							dirPath, sentDeptID, companyID, lang);
 					
 					if (subSQL.toUpperCase().equals("FALSE")) {
 						return "<RESULT>FALSE</RESULT>";
 					} else {
 						strSQL.append(subSQL);
 					}
 				}
 			}
 			strSQL.append("DELETE FROM TBEXPAPRLINE WHERE DocID = '" + docID + "';\n");
            strSQL.append("DELETE FROM TBAPRLINEINFO WHERE DocID = '" + docID + "';\n");
            
            subSQL = updateDeliveryList(docID, sentDeptID, ezOrganService.getPropertyValue(sentDeptID, "displayName"), ezOrganService.getPropertyValue(sentDeptID, "displayName2"), objRows.item(0).getTextContent(),
            		objRows.item(1).getTextContent(), objRows.item(2).getTextContent(), "", "", "", sentDeptID, "", companyID, "QUERY", lang);
            
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
			
			sendRecvMsg(receiveDeptID, docID, "BEBU", companyID, lang);
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	private String doBebuDoc(String docID, String deptID, String deptName, String deptName2, String dirPath, String docState, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		String newID = getNewID(companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", "APR");
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String url = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + companyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator +
				"1000" + commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		String fileURL = dirPath + commonUtil.separator + fileName.replace(config.getProperty("upload_approvalG.ROOT"), "");
		
		boolean rtnVal = copyFile(fileURL, dirPath + companyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" +
				commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName, dirPath + companyID + commonUtil.separator + "Doc" + commonUtil.separator + 
				EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID));
		
		if (rtnVal) {
			strSQL.append("INSERT INTO TBAPRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
			strSQL.append("isPublic) SELECT '" + newID + "', FormID, OrgDocID, DocType, '011', '" + staASDoJak + "', '" + url + "', DocTitle, DocNo, HasAttachYN, HasOpinionYN, SYSDATE");
            strSQL.append(", NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic FROM TBAPRDOCINFO WHERE DocID = '" + docID + "';\n");

			// 수정(2005.09.29) : 보안결재 필드 추가
			strSQL.append("INSERT INTO TBEXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval) ");
            strSQL.append("SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
            strSQL.append("ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval FROM TBEXPAPRDOCINFO ");
			strSQL.append("WHERE DocID = '" + docID + "'; \n");

			strSQL.append("INSERT INTO TBAPRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach) SELECT '" + newID);
			strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach FROM ");
            strSQL.append("TBAPRATTACHINFO WHERE DocID = '" + docID + "';\n");

			strSQL.append("INSERT INTO TBAPRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2) SELECT '" + newID);
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2 FROM ");
            strSQL.append("TBAPRDOCATTACHINFO WHERE DocID = '" + docID + "';\n");

			strSQL.append("INSERT INTO TBAPROPINIONINFO (DocID, UserID, OpinionGB, Content, ");
            strSQL.append("UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN) SELECT '");
            strSQL.append(newID + "', UserID, OpinionGB, Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN FROM TBAPROPINIONINFO  WHERE DocID = '" + docID + "';\n");


            //##################################################################다중배부####################################################
            strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT '1', '");
            strSQL.append(newID + "', WriterDeptID, WriterDeptName, WriterDeptName2, '" + deptID + "', N'" + deptName + "', N'" + deptName2);
            strSQL.append("', '011', '" + staASBaeBu + "', SYSDATE"  );
            strSQL.append(", 'N', '', '', '', '', '', '', DocID FROM TBAPRDOCINFO WHERE DocID = '");
            strSQL.append(docID + "';\n");
            
            String subSQL = updateDeliveryList(newID, docState, ezOrganService.getPropertyValue(docState, "displayName"), ezOrganService.getPropertyValue(docState, "displayName2"), deptID, 
            		deptName, deptName2, "", "", "", docState, "", companyID, "QUERY", lang);
            
            if (subSQL.equals("<RESULT>FALSE</RESULT>")) {
            	return "FALSE";
            } else if (subSQL.equals("<RESULT>TRUE</RESULT>")) {
            	return "TRUE";
            } else {
            	strSQL.append(subSQL + "\n");
            }
            
            sendRecvMsg(deptID, newID, "SUSIN", companyID, lang);
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	private String updateDeliveryList(String docID, String organID, String organ, String organ2, String manageDeptID, String manageDept, String manageDept2, String chargeID,
			String chargeName, String chargeName2, String deptID, String remark, String companyID, String mode, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		String deliveryOption = getCode2Name("A54", "001", companyID, lang);
		boolean duplicateFlag = false;
		
		if (deliveryOption.trim().toUpperCase().equals("Y")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_DEPTID", deptID.trim());
			
			int resultCnt = ezApprovalGDAO.updateDeliveryListCount(map);
			
			if (resultCnt > 0) {
				duplicateFlag = true;
			}
		}
		
		if (duplicateFlag) {
			strSQL.append("UPDATE TBDOCDELIVERY SET OrganID = '" + makeRightField(organID));
			strSQL.append("', Organ = N'" + makeRightField(organ));
            strSQL.append("', Organ2 = N'" + makeRightField(organ2));
			strSQL.append("', ManageDeptID = '" + makeRightField(manageDeptID));
            strSQL.append("', ManageDept = N'" + makeRightField(manageDept));
            strSQL.append("', ManageDept2 = N'" + makeRightField(manageDept2));
			strSQL.append("', ChargeID = '" + makeRightField(chargeID));
            strSQL.append("', ChargeName = N'" + makeRightField(chargeName));
            strSQL.append("', ChargeName2 = N'" + makeRightField(chargeName2));
			strSQL.append("', Remark = N'" + makeRightField(remark));
            strSQL.append("' WHERE DocID = '" + docID + "' AND DeptID = '" + makeRightField(deptID) + "';");
		} else {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_YEAR", EgovDateUtil.getTodayTime().subSequence(0, 4));
			map.put("v_DEPTID", deptID.trim());
			
			int maxSN = ezApprovalGDAO.updateDeliveryListSNMax(map);
			
            strSQL.append("INSERT INTO TBDOCDELIVERY (sn, DocID, Href, ReceiptDate, ");
            strSQL.append("OrganID, Organ, Organ2, DocNumber, ManageDeptID, ManageDept, ManageDept2, ChargeID, ");
            strSQL.append("ChargeName, ChargeName2, DeptID, Remark, OrgDocNumCode, DocTitle) SELECT '");
			strSQL.append(maxSN + "', a.DocID, a.Href, SYSDATE");
            strSQL.append(", '" + makeRightField(organID) + "', N'" + makeRightField(organ) + "', N'" + makeRightField(organ2));
			strSQL.append("', a.DocNo, '" + makeRightField(manageDeptID) + "', N'");
			strSQL.append(makeRightField(manageDept) + "', N'" + makeRightField(manageDept2) + "', '" + makeRightField(chargeID));
            strSQL.append("', N'" + makeRightField(chargeName) + "', N'" + makeRightField(chargeName2) + "', '" + makeRightField(deptID));
		    strSQL.append("', N'" + makeRightField(remark) + "', b.DocNumCode, a.DocTitle ");
            strSQL.append("FROM TBAPRDOCINFO a INNER JOIN TBEXPAPRDOCINFO b on a.DocID = b.DocID ");
            strSQL.append("WHERE a.DocID = '" + docID.trim() + "';");
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

	private String rollbackSN(String snType1, String snType2, String snType3, String toSN, String companyID, String strLang) throws Exception{
		String accountYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, strLang);
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("iv_Type1", snType1);
		map.put("iv_Type2", snType2);
		map.put("iv_Type3", snType3);
		map.put("v_CurSN", toSN);
		map.put("v_AccountYear", accountYear);
		
		try {
			ezApprovalGDAO.spRollbackSN(map);
			result = "TRUE";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	private String saveSpecialInfoCab(String specialFlag, String cabinetClassNO, Document xmlDom) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		String sc1 = xmlDom.getElementsByTagName("LIST1").item(0).getTextContent().trim();
		String sc2 = xmlDom.getElementsByTagName("LIST2").item(0).getTextContent().trim();
		String sc3 = xmlDom.getElementsByTagName("LIST3").item(0).getTextContent().trim();
		
        strSQL.append("INSERT INTO TBSPECIALCATALOGINFO_CAB (CabinetClassNo, SerialNo, SC1, ");
		strSQL.append("SC2, SC3) VALUES ('" + makeRightField(cabinetClassNO) + "', '000', N'");
		strSQL.append(makeRightField(sc1) + "', N'" + makeRightField(sc2) + "', N'" + makeRightField(sc3) + "');\n");
		if (specialFlag.equals("1")) {
			for (int k = 0; k < xmlDom.getElementsByTagName("SCDATA").getLength(); k++) {
				strSQL.append("INSERT INTO TBSPECIALCATALOGINFO_CAB (CabinetClassNo, SerialNo, SC1, SC2, SC3) Values ('");
				strSQL.append(makeRightField(cabinetClassNO) + "', '");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("SN").item(k).getTextContent().trim()) + "', N'");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("LIST1").item(k).getTextContent().trim()) + "', N'");
				strSQL.append(makeRightField(xmlDom.getElementsByTagName("LIST2").item(k).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(xmlDom.getElementsByTagName("LIST3").item(k).getTextContent().trim()) + "');\n");
			}
		}
		
		return strSQL.toString();
	}

	@Override
	public List<ApprGSecondApprVO> getSecondApprovalInfo(String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		
		List<ApprGSecondApprVO> apprGSecondApprVOList = ezApprovalGDAO.getSecondApprovalInfo(map);
		
		return apprGSecondApprVOList;
	}

	private String getReceiveDocList(String mode, String userID, String deptID, String docManageDeptInfo, int querySize, int querySize2, String orderOption1, String orderOption2, String basicOrder,
			String basicOrderReverse, String searchQuery, Document xmlDomSub, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", mode);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTIDS", docManageDeptInfo);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_BASICORDER", basicOrder);
		map.put("v_BASICORDER2", basicOrderReverse);
		map.put("v_SPSUBQUERY", searchQuery.trim());
		
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

	private int getReceiveDocListCount(String mode, String userID, String deptID, String docManageDeptInfo, String subQuery, String companyID, Document xmlDomSub) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_MODE", mode);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_DEPTIDS", docManageDeptInfo);
		map.put("v_SPSUBQUERY", subQuery);
		
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

	public String rollbackRegSN(String strXML) throws Exception{
		Document objParam = commonUtil.convertStringToDocument(strXML);
		
		String type1 = objParam.getElementsByTagName("TYPE1").item(0).getTextContent();
		String type2 = objParam.getElementsByTagName("TYPE2").item(0).getTextContent();
		String type3 = objParam.getElementsByTagName("TYPE3").item(0).getTextContent();
		long sn = Long.parseLong(objParam.getElementsByTagName("SN").item(0).getTextContent());
		String docID = objParam.getElementsByTagName("DOCID").item(0).getTextContent();
		String companyID = objParam.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String lang = objParam.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		
		return "<RESULT>" + rollbackSN(type1, type2, type3, sn, companyID, docID, lang) + "</RESULT>";
	}

	public String rollbackSN(String type1, String type2, String type3, long sn, String companyID, String docID, String langType) throws Exception{
		String accountYear = "";
		String result = "";
		
		if (!docID.trim().equals("")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			
			String processDate = ezApprovalGDAO.getDraftDate(map);
			
			if (!processDate.equals("")) {
				accountYear = getAccountingYear(processDate, companyID, langType);
			} else {
				accountYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, langType);
			}
		} else {
			accountYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, langType);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("iv_Type1", type1);
		map.put("iv_Type2", type2);
		map.put("iv_Type3", type3);
		map.put("v_CurSN", sn);
		map.put("v_AccountYear", accountYear);
		
		try {
			ezApprovalGDAO.spRollbackSN(map);
			result = "TRUE";
		} catch (Exception e) {
			result = "FALSE";
		}
		
		return result;
	}

	public String getRegSN(String strXML) throws Exception{
		Document objParam = commonUtil.convertStringToDocument(strXML);
		
		String type1 = objParam.getElementsByTagName("TYPE1").item(0).getTextContent();
		String type2 = objParam.getElementsByTagName("TYPE2").item(0).getTextContent();
		String type3 = objParam.getElementsByTagName("TYPE3").item(0).getTextContent();
		String companyID = objParam.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String docID = objParam.getElementsByTagName("DOCID").item(0).getTextContent();
		String langType = objParam.getElementsByTagName("LANGTYPE").item(0).getTextContent();
		
		return "<RESULT>" + getSerialNum(type1, type2, type3, companyID, docID, langType) + "</RESULT>";
	}

	public String getSerialNum(String type1, String type2, String type3, String companyID, String docID, String langType) throws Exception{
		String accountYear = "";
		
		if (!docID.trim().equals("")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			
			String processDate = ezApprovalGDAO.getDraftDate(map);
			
			if (processDate != null && !processDate.equals("")) {
				accountYear = getAccountingYear(processDate, companyID, langType);
			} else {
				accountYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, langType);
			}
		} else {
			accountYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, langType);
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("iv_Type1", type1);
		map.put("iv_Type2", type2);
		map.put("iv_Type3", type3);
		map.put("v_AccountYear", accountYear);
		
		int result = ezApprovalGDAO.spGetSerialNo(map);
		
		return String.valueOf(result);
	}

	public boolean compareLineHistory(String docID, String companyID) throws Exception{
		int modifySN = 0;

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
		map.put("v_FLAG", "1");
		map.put("v_MODIFYSN", modifySN);
		
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

	public String chkAprLine(String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String userDeptID, String userDeptName, String userDeptName2, String userCompanyID, String strLang) throws Exception{
		//TODO: 한글 코드화 
		Document resultXML = null;
		StringBuilder rtnVal = new StringBuilder();
		String strXML = "";
		
		if (userID.trim().toUpperCase().equals(userDeptID.trim().toUpperCase())) {
			if (userID.toLowerCase().indexOf("address") == -1) {
				strXML = ezOrganService.getPropertyList(userID, "displayName;extensionAttribute2", commonUtil.getPrimaryData(strLang));
				resultXML = commonUtil.convertStringToDocument(strXML);
				
				String tempDeptName = userDeptName.trim();
				
				if (!strLang.equals("1")) {
					tempDeptName = userDeptName2;
				}
				
				if (resultXML.getDocumentElement().getChildNodes().getLength() > 0) {
					if (resultXML.getElementsByTagName("DISPLAYNAME").item(0) != null) {
						
					} else {
						rtnVal.append("- " + tempDeptName + "의 이름 정보를 찾을 수 없습니다.<br>");
					}
					
					if (resultXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0) != null) {
						if (!userCompanyID.trim().equals(resultXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tempDeptName + "의 회사 아이디는 [" + userCompanyID);
							rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() + "] 입니다.<br>");
						}
					} else {
						rtnVal.append("- " + tempDeptName + "의 회사 정보를 찾을 수 없습니다.<br>");
					}
				} else {
					rtnVal.append("- " + tempDeptName + " 부서에 대한 정보가 없습니다. 부서가 삭제되었는지 확인하시기 바랍니다.<br>");
				}
			}
		} else {
			String tmpUserName = "";
			
			strXML = ezOrganService.getPropertyList(userID, "displayName;department;description;physicalDeliveryOfficeName;title;extensionAttribute4", strLang);
			resultXML = commonUtil.convertStringToDocument(strXML);
			
			if (resultXML.getElementsByTagName("DISPLAYNAME").item(0) != null) {
				tmpUserName = resultXML.getElementsByTagName("DISPLAYNAME").item(0).getTextContent().trim();
			}
			
			if (resultXML.getDocumentElement().getChildNodes().getLength() > 0) {
				if (resultXML.getElementsByTagName("DISPLAYNAME1").item(0) != null) {
					if (!userName.trim().equals(resultXML.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent().trim())) {
						rtnVal.append("- " + userName + "의 이름은 [" + userName);
						rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent());
						rtnVal.append("] 입니다.<br>");
					} else if (resultXML.getElementsByTagName("DISPLAYNAME2").item(0) != null) {
						if (!userName2.trim().equals(resultXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent().trim())) {
							rtnVal.append("- " + userName2 + "의 이름은 [" + userName2);
                            rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent());
                            rtnVal.append("] 입니다.<br>");
						}
					} else {
						rtnVal.append("- " + tmpUserName + "의 이름 정보를 찾을 수 없습니다.<br>");
					}
				} else {
					rtnVal.append("- " + tmpUserName + "의 이름 정보를 찾을 수 없습니다.<br>");
				}
				
				if (resultXML.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0) != null) {
					if (!userCompanyID.trim().equals(resultXML.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0).getTextContent().trim())) {
						rtnVal.append("- " + tmpUserName + "의 회사 아이디는 [" + userCompanyID);
						rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("PHYSICALDELIVERYOFFICENAME").item(0).getTextContent());
						rtnVal.append("] 입니다.<br>");
					}
				} else {
					rtnVal.append("- " + tmpUserName + "의 회사 정보를 찾을 수 없습니다.<br>");
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
							userDNames[k + 1] = ezOrganService.getPropertyValue(arr2[0], "displayName");
							userDNames[k + 1] = ezOrganService.getPropertyValue(arr2[0], "displayName2");
							
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
							rtnVal.append("- " + tmpUserName + "의 직위, 부서 정보는 [");
                            rtnVal.append(userDeptID + ", " + userDeptName + "(" + userDeptName2 + "), ");
                            rtnVal.append(userJobTitle + "(" + userJobTitle2 + ")]이(가) 아닌 [");
                            
                            for (int k = 0; k < userDIDs.length; k++) {
                            	if (!userDIDs[k].trim().equals("")) {
                            		if (k == 0) {
                            			 rtnVal.append("<" + userDIDs[k] + ", " + userDNames[k] + "(" + userDNames2[k] + "), " + userTitles[k] + "(" + userTitles2[k] + ")>");
									} else {
                                        rtnVal.append(", <" + userDIDs[k] + ", " + userDNames[k] + "(" + userDNames2[k] + "), " + userTitles[k] + "(" + userTitles2[k] + ")>");
                            		}
                            	}
                            }
                            
                            rtnVal.append("] 중 하나여야 합니다.<br>");
						}
					} else {
						rtnVal.append("- " + tmpUserName + "의 직위, 부서 정보를 찾을 수 없습니다.<br>");
					}
				} else {
					if (resultXML.getElementsByTagName("DEPARTMENT").item(0) != null) {
						if (!userDeptID.trim().equals(resultXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tmpUserName + "의 부서아이디는 [" + userDeptID);
							rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent() + "] 입니다.<br>");
						}
					} else {
						rtnVal.append("- " + tmpUserName + "의 부서 정보를 찾을 수 없습니다.<br>");
					}
					
					if (resultXML.getElementsByTagName("DESCRIPTION1").item(0) != null) {
						if (!userDeptName.trim().equals(resultXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tmpUserName + "의 부서명은 [" + userDeptName);
							rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("DESCRIPTION1").item(0).getTextContent() + "] 입니다.<br>");
						} else if (resultXML.getElementsByTagName("DESCRIPTION2").item(0) != null) {
							if (!userDeptName2.trim().equals(resultXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent().trim())) {
								rtnVal.append("- " + tmpUserName + "의 부서명은 [" + userDeptName2);
                                rtnVal.append("]이(가) 아닌 [" + resultXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent() + "] 입니다.<br>");
							}
						} else {
							rtnVal.append("- " + tmpUserName + "의 부서 정보를 찾을 수 없습니다.<br>");
						}
					} else {
						rtnVal.append("- " + tmpUserName + "의 부서 정보를 찾을 수 없습니다.<br>");
					}
					
					if (resultXML.getElementsByTagName("TITLE1").item(0) != null) {
						if (!userJobTitle.trim().equals(resultXML.getElementsByTagName("TITLE1").item(0).getTextContent().trim())) {
							rtnVal.append("- " + tmpUserName + "의 직위는 [" + userJobTitle + "]이(가) 아닌 [");
							rtnVal.append(resultXML.getElementsByTagName("TITLE1").item(0).getTextContent() + "] 입니다.<br>");
						} else if (resultXML.getElementsByTagName("TITLE2").item(0) != null) {
							if (!userJobTitle2.trim().equals(resultXML.getElementsByTagName("TITLE2").item(0).getTextContent().trim())) {
								rtnVal.append("- " + tmpUserName + "의 직위는 [" + userJobTitle2 + "]이(가) 아닌 [");
                                rtnVal.append(resultXML.getElementsByTagName("TITLE2").item(0).getTextContent() + "] 입니다.<br>");
							}
						} else {
							rtnVal.append("- " + tmpUserName + "의 직위 정보를 찾을 수 없습니다.<br>");
						}
					} else {
						rtnVal.append("- " + tmpUserName + "의 직위 정보를 찾을 수 없습니다.<br>");
					}
				}
			} else {
				rtnVal.append("- " + tmpUserName + "에 대한 정보가 없습니다. 조직도에 존재하는지 확인하시기 바랍니다. <br>");
			}
		}
		
		return makeXMLString(rtnVal.toString());
	}

	public boolean chkDocDelete(String docID, String orgDocID, boolean chkFlag, String userID, String deptID, String dirPath, String companyID) throws Exception{
		boolean rtnVal = true;
		
		if (chkFlag) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", orgDocID);
			
			String fileName = makeListField(ezApprovalGDAO.chkDocDelete(map));
			String oldYear = getDocHrefYear(orgDocID, companyID);
			
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
			
			String fileName = makeListField(ezApprovalGDAO.getDocInfoHref(map));
			String oldYear = getDocHrefYear(docID, companyID);
			
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

	public String makeTmpDocInfo(String userID, String docID, String updateFlag, String companyID, String lang) throws Exception{
		String strSQL = "";
		
		if (updateFlag.equals("UPDATE")) {
			strSQL = "EZSP_APRUPDATETMP ('" + docID + "', '" + makeRightField(userID) + "');\n";
		} else {
			String sn = getMaxTMPDocSN(userID, companyID, lang);
			
			strSQL = "EZSP_APRMAKEING2TMP ('" + docID + "', '" + makeRightField(userID) + "', '" + sn + "');\n";
		}
		
		return strSQL;
	}

	public String getMaxTMPDocSN(String userID, String companyID, String lang) throws Exception{
		int maxCnt = 1;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PUSERID", makeRightField(userID.trim()));
		
		maxCnt = ezApprovalGDAO.getMaxTmpDocSN(map);
		
		return String.valueOf(maxCnt);
	}

	public String doBoryu(String docID, String userID, String aprState, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + aprState + "', ProcessDate = SYSDATE");
        strSQL.append(" WHERE DocID = '");
		strSQL.append(docID + "' AND AprMemberID = '" + userID + "' AND AprState = '" + staASJinHang + "';\n");

		strSQL.append("UPDATE TBAPRDOCINFO SET FunctionType = '" + aprState + "' WHERE DocID = '" + docID + "';\n");
		
		sendMsg(docID, "", "BOR", companyID, lang);
		
		return strSQL.toString();
	}

	public String doBansong(String docID, String userID, String aprState, String dirPath, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_APRMEMBERID", userID);
		
		String aprType = makeListField(ezApprovalGDAO.doBanSongAprType(map));
		
		if (aprType.equals(staATByungRyulHyubJo)) {
			strSQL.append(doApprove(docID, userID, aprState, ezOrganService.getPropertyValue(userID, "displayName"), ezOrganService.getPropertyValue(userID, "displayName2"), dirPath, ezOrganService.getPropertyValue(userID, "department"), "", companyID, lang));
			sendMsg(docID, "", "BAN", companyID, lang);
			
			if (strSQL.toString().toUpperCase().equals("FALSE")) {
				return "FALSE";
			} else {
				return strSQL.toString();
			}
		} else {
			strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + aprState + "', ProcessDate = SYSDATE");
			strSQL.append(" WHERE DocID = '");
			strSQL.append(docID + "' AND AprMemberID = '" + userID + "' AND (AprState = '" + staASJinHang);
            strSQL.append("' OR AprState = '" + staASBoRyu + "');\n");
			
            strSQL.append("UPDATE TBAPRDOCINFO SET FunctionType = '" + aprState + "' WHERE DocID = '" + docID + "';\n");
			
            strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang + "' WHERE DocID = '" + docID + "' AND AprMemberSN = '1';\n");
            
            sendMsg(docID, "", "BAN", companyID, lang);
            
            return strSQL.toString();
		}
	}

	public String doApprove(String docID, String userID, String aprState, String userName, String userName2, String dirPath, String deptID, String proxyUserID, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		boolean rtnVal = false;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID.trim());
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
			
			strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + aprState + "', ProcessDate = SYSDATE ");
			
			if (beforeAprMemberSN.equals("1")) {
				strSQL.append(", ReceivedDate = SYSDATE ");
			}
			
			strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberID = '" + userID + "' AND AprMemberSN = '" + curAprMemberSN + "';\n");
		}
		//TODO 통계부분인데 사용안하는 코드인듯
//		if (curAprMemberSN.equals("1")) {
//			Map<String, Object> map1 = new HashMap<String, Object>();
//			map1.put("companyID", companyID);
//			map1.put("v_DOCID", docID.trim());
//			
//			String tempDocState = ezApprovalGDAO.doApproveDocState(map1);
//		}
		
		if (proxyUserID.equals(userID) && !proxyUserID.trim().equals("")) {
			subSQL = insertProxyUserInfo(docID, curAprMemberSN, userID, proxyUserID, companyID, lang);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
				
				return "FALSE";
			} else {
				strSQL.append(subSQL);
			}
		}
		
		if (curAprType.equals(staATByungRyulHyubJo) || curAprType.equals(staATBuSeuByungRyulHyubJo)) {
			Map<String, Object> map1 = new HashMap<String, Object>();
			map1.put("companyID", companyID);
			map1.put("v_DOCID", docID);
			map1.put("v_APRTYPE", curAprType);
			
			int subCount = ezApprovalGDAO.doApproveLineCnt(map1);
			
			if (subCount > 1) {
				return strSQL.toString();
			}
		}
		
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.put("companyID", companyID);
		map2.put("v_DOCID", docID);
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
		
		while (k < dlength && whileFlag) {
			switch (docXML2.getElementsByTagName("APRTYPE").item(k).getTextContent().trim()) {
			case "001":
				lastState = staATYilBan;

				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
				sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
				
				whileFlag = false;
				
				break;

			case "002":
				lastState = staatwhoakin;
		
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");

                sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
				
                whileFlag = false;
                
                break;
                
			case "003":
				lastState = staATAnHam;

                strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASSungIn);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(", ProcessDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
                k += 1;				
				
                break;
			case "004":
				if (!curAprType.equals("016")) {
					lastState = staATJunGyul;
					
					strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
					strSQL.append("', ReceivedDate = SYSDATE");
					strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
					strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");

                    sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
					
                    whileFlag = false;
				} else {
					lastState = "003";
					
					strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + aprState);
					strSQL.append("', ReceivedDate = SYSDATE");
					strSQL.append(", ProcessDate = SYSDATE");
					strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
					strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");

					k += 1;
				}
				
				break;
			case "007":
				lastState = staATChamJo;
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASAprEND);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(", ProcessDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");


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
					dirPath, staDSChamJo, companyID);

				if (subSQL.toUpperCase() == "FALSE") {
					rtnVal = false;
					whileFlag = false;							
				} else {
					strSQL.append(subSQL);

                    sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
					
                    k += 1;
				}

				break;
			case "008":
				lastState = staATSoonChaHyubJo;
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");

				absentReason = getBujaeInfo(docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent());
				
				if (absentReason.trim().equals("")) {
					sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
					whileFlag = false;
				} else {
					subSQL = setBujaeInfo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), absentReason, "AST", companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
						whileFlag = false;
					} else {
						strSQL.append(subSQL);
						strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '");
						strSQL.append(staASSungIn + "', ProcessDate = SYSDATE");
						strSQL.append(", ReasonDoNotApprov = N'" + makeXMLString(absentReason));
						strSQL.append("' WHERE DocID = '" + docID + "' AND AprMemberSN = '");
						strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
						
                        k += 1;
					}
				}
				
				break;
			case "009":
				lastState = staATByungRyulHyubJo;
				
				if (!curAprType.equals(staATByungRyulHyubJo)) {
					while (k < dlength && docXML2.getElementsByTagName("APRTYPE").item(k).getTextContent().equals(staATByungRyulHyubJo)) {
						strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
						strSQL.append("', ReceivedDate = SYSDATE");
						strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
						strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
						
						absentReason = getBujaeInfo(docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent());
						
						if (absentReason.trim().equals("")) {
							sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
						} else {
							subSQL = setBujaeInfo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), absentReason, "AST", companyID, lang);
							
							if (subSQL.toUpperCase().equals("FALSE")) {
								rtnVal = false;
								whileFlag = false;
							} else {
								strSQL.append(subSQL);
								strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '");
								strSQL.append(staASSungIn + "', ProcessDate = SYSDATE");
								strSQL.append(", ReasonDoNotApprov = N'" + makeXMLString(absentReason));
								strSQL.append("' WHERE DocID = '" + docID + "' AND AprMemberSN = '");
								strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
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
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
                subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), 
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
					dirPath, staATBuSeuSoonChaHyubJo, staDSHabYui, 
					docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID);
                
                if (subSQL.toUpperCase().equals("FALSE")) {
                	rtnVal = false;
                } else {
                	strSQL.append(subSQL);
                }
                
                whileFlag = false;
                
                break;
			case "012":
				lastState = staATBuSeuByungRyulHyubJo;
				
				if (!curAprType.equals(staATBuSeuByungRyulHyubJo)) {
					while (k < dlength && docXML2.getElementsByTagName("APRTYPE").item(k).getTextContent().equals(staATBuSeuByungRyulHyubJo) && whileFlag) {
						strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
						strSQL.append("', ReceivedDate = SYSDATE");
						strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
						strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
						
                        subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), 
                        		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                        		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
							dirPath, staATBuSeuByungRyulHyubJo, staDSHabYui, 
							docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID);
                        
                        if (subSQL.toUpperCase().equals("FALSE")) {
                        	rtnVal = false;
                        	whileFlag = false;
                        } else {
                        	strSQL.append(subSQL);
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
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
                subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
					dirPath, staATGamSa, staDSGamSa, docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID);
                
                if (subSQL.toUpperCase().equals("FALSE")) {
                	rtnVal = false;
                } else {
                	strSQL.append(subSQL);
                }
                
                whileFlag = false;
                
                break;
			case "013":
				lastState = staATGamSaBu;
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
                subSQL = doDeptAssist(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME").item(k).getTextContent(),
                		docXML2.getElementsByTagName("APRMEMBERDEPTNAME2").item(k).getTextContent(), 
					dirPath, staATGamSaBu, staDSGamSaBu, docXML2.getElementsByTagName("APRMEMBERLDAPPATH").item(k).getTextContent(), companyID);
                
                if (subSQL.toUpperCase().equals("FALSE")) {
                	rtnVal = false;
                } else {
                	strSQL.append(subSQL);
                }
                
                whileFlag = false;
                
                break;
			case "017":
				lastState = staATGongram;
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASmikyul);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(", ProcessDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");

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
					dirPath, staDSGongRam, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
					whileFlag = false;
				} else {
					strSQL.append(subSQL);
					sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
					k += 1;
				}
				
				break;
			case "018":
				lastState = "018";
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
                sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID,lang);
				
                whileFlag = false;		
				
                break;
			case "019":
				lastState = "019";
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
				absentReason = getBujaeInfo(docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent());
				
				if (absentReason.trim().equals("")) {
					sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
					whileFlag = false;
				} else {
					subSQL = setBujaeInfo(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), docXML2.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), absentReason, "APR", companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
						whileFlag = false;
					} else {
						strSQL.append(subSQL);
						strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '");
						strSQL.append(staASSungIn + "', ProcessDate = SYSDATE");
						strSQL.append(", ReasonDoNotApprov = N'" + makeXMLString(absentReason));
						strSQL.append("' WHERE DocID = '" + docID + "' AND AprMemberSN = '");
						strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
						
                        k += 1;
					}
				}
				
				break;
			case "016":
				lastState = "016";
				
				strSQL.append("UPDATE TBAPRLINEINFO SET AprState = '" + staASJinHang);
				strSQL.append("', ReceivedDate = SYSDATE");
				strSQL.append(" WHERE DocID = '" + docID + "' AND AprMemberSN = '");
				strSQL.append(docXML2.getElementsByTagName("APRMEMBERSN").item(k).getTextContent() + "';\n");
				
				sendMsg(docID, docXML2.getElementsByTagName("APRMEMBERID").item(k).getTextContent(), "ING", companyID, lang);
				
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
			subSQL = doDocComplete(docID, userID, userName, userName2, dirPath, deptID, proxyUserID, companyID, lang);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	public String doDocComplete(String docID, String userID, String userName, String userName2, String dirPath, String deptID, String proxyUserID, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		boolean rtnVal = true;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
		
		String flag = getCode2Name("A35", "002", companyID, lang).toUpperCase().trim();
		
		switch (docType) {
		case "001":
			if (!realDocType.equals("001")) {
				subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			} else {
				String autoDeptID = getCode2Name("A55", "001", companyID, lang).trim();
				
				if (!autoDeptID.equals("")) {
					int addressCount = ezApprovalGDAO.doDocCompleteReceiptCnt(map);
					
					if (addressCount > 0) {
						strSQL.append("UPDATE TBRECEIPTPOINTINFO SET ProcessYN = 'O' WHERE DocID = '" + docID + "';\n");
					}
				}
			}
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = setCabinetRec(docID, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang);
			}
			
			break;
			
		case "004":
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				strSQL.append("APRDeleteDocInfo( '" + docID + "', 'MUST');\n");
				sendMsg(docID, "", "BAL", companyID, lang);
			}

			break;
			
		case "011":
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = updateSusinResult(orgDocID, aprLinersDeptID, aprLinersID, "Y", aprLinersName, aprLinersName2, orgCompanyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = setCabinetRecv(docID, userID, userName, userName2, deptID, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang);
			}
			
			break;
			
		case "012":
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = updateHabyuiResult(docID, companyID, orgDocID, orgCompanyID, aprLinersDeptID, aprLinersDeptName, aprLinersDeptName2, "Y", lang);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = doApprove(orgDocID, aprLinersDeptID, staASSungIn, aprLinersDeptName, aprLinersDeptName2, dirPath, deptID, "", orgCompanyID, lang);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = setCabinetRec(docID, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang);
			}
			
			break;
			
		case "014":
			if (!flag.equals("G")) {
				if (!realDocType.equals("001")) {
					subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						sendFlag = false;
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = setCabinetRec(docID, companyID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = deleteDocInfo(docID, "QUERY", companyID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					sendMsg(docID, "", "END", companyID, lang);
				}
			} else {
				subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
				
				if (rtnVal) {
					subSQL = updateGamsaResult(docID, companyID, orgDocID, orgCompanyID, aprLinersDeptID, aprLinersDeptName, aprLinersDeptName2, "Y", lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = doApprove(orgDocID, aprLinersDeptID, staASSungIn, aprLinersDeptName, aprLinersDeptName2, dirPath, deptID, "", orgCompanyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					subSQL = deleteDocInfo(docID, "QUERY", companyID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				if (rtnVal) {
					sendMsg(docID, "", "END", companyID, lang);
				}
			}
			
			break;
			
		case "017":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = updateChamjoResult(orgDocID, deptID, userID, orgCompanyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			break;
			
		case "015":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = updateChamjoResult(orgDocID, deptID, userID, orgCompanyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			break;
			
		case "003":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = updateGamsaResult(docID, companyID, orgDocID, orgCompanyID, aprLinersDeptID, aprLinersDeptName, aprLinersDeptName2, "Y", lang);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = doApprove(orgDocID, aprLinersDeptID, staASSungIn, aprLinersDeptName, aprLinersDeptName2, dirPath, deptID, "", orgCompanyID, lang);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang);
			}
			
			break;
			
		case "024":
			subSQL = doApproveEnd(docID, dirPath, deptID, false, companyID);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			break;
			
		default:
			subSQL = doSendDoc(docID, deptID, dirPath, staDSSuSin, companyID, lang);
			
			if (subSQL.toUpperCase().equals("FALSE")) {
				rtnVal = false;
			} else {
				strSQL.append(subSQL);
			}
			
			if (rtnVal) {
				subSQL = doApproveEnd(docID, dirPath, deptID, sendFlag, companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				subSQL = deleteDocInfo(docID, "QUERY", companyID);
				
				if (subSQL.toUpperCase().equals("FALSE")) {
					rtnVal = false;
				} else {
					strSQL.append(subSQL);
				}
			}
			
			if (rtnVal) {
				sendMsg(docID, "", "END", companyID, lang);
			}
			
			break;
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	public String updateChamjoResult(String orgDocID, String deptID, String userID, String orgCompanyID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		strSQL.append("UPDATE TBAPRLINEINFO SET ProcessDate = SYSDATE");
		strSQL.append(", AprState = '" + staASSungIn + "' WHERE DocID = '" + orgDocID);
		strSQL.append("' AND AprMemberDeptID = '" + deptID + "' AND AprMemberID = '" + userID);
		strSQL.append("' AND AprState = '" + staASmikyul + "';\n");

		strSQL.append("UPDATE TBENDAPRLINEINFO SET ProcessDate = SYSDATE");
		strSQL.append(", AprState = '" + staASSungIn + "' WHERE DocID = '" + orgDocID);
		strSQL.append("' AND AprMemberDeptID = '" + deptID + "' AND AprMemberID = '" + userID);
        strSQL.append("' AND AprState = '" + staASmikyul + "';\n");
        
		return strSQL.toString();
	}

	public String updateGamsaResult(String docID, String companyID, String orgDocID, String orgCompanyID, String aprLinersDeptID, String aprLinersDeptName, String aprLinersDeptName2, String mode,
			String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		
		subSQL = setLastOpinionToOrgDoc(docID, orgDocID, companyID, orgCompanyID, "QUERY", lang);
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		String signType = "TEXT";
		String signTitle = "";
		String signCont = "";
		
		if (mode.toUpperCase().equals("H")) {
			signCont = messageSource.getMessage("ezApprovalG.t1434", new Locale(globals.getProperty("Globals.language")));
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
		
		subSQL += updateSignInfo(resultXML, orgCompanyID, "QUERY");
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		return strSQL.toString();
	}

	public String updateHabyuiResult(String docID, String companyID, String orgDocID, String orgCompanyID, String deptID, String deptName, String deptName2, String mode, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String subSQL = "";
		
		subSQL = setLastOpinionToOrgDoc(docID, orgDocID, companyID, orgCompanyID, "QUERY", lang);
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		String signType = "TEXT";
		String signTitle = "";
		String signCont = "";
		
		if (mode.toUpperCase().equals("H")) {
			signCont = messageSource.getMessage("ezApprovalG.t1434", new Locale(globals.getProperty("Globals.language")));
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
		
		String susinSN = getSusinSNInside(orgDocID, orgCompanyID);
		
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
		resultXML.append("<CONTENT>" + EgovDateUtil.getTodayTime().substring(6, 10) + "</CONTENT>");
		resultXML.append("</SIGNINFO>");
		resultXML.append("</SIGNINFOS>");
		
		subSQL = updateSignInfo(resultXML, orgCompanyID, "QUERY");
		
		if (subSQL.toUpperCase().equals("FALSE")) {
			return "FALSE";
		} else {
			strSQL.append(subSQL);
		}
		
		return strSQL.toString();
	}

	public String setLastOpinionToOrgDoc(String docID, String orgDocID, String companyID, String orgCompanyID, String mode, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		boolean rtnVal = true;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
			
			int nextSN = ezApprovalGDAO.setLastOpinionToOrgDocOpinionSN(map1);
			
			nextSN += 1;
			
            strSQL.append("INSERT INTO TBAPROPINIONINFO (DocID, UserID, OpinionGB, ");
            strSQL.append("Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN) VALUES ('" + orgDocID + "', '");
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
			strSQL.append(makeRightField(String.valueOf(nextSN)) + "')\n");
			
			strSQL.append("UPDATE TBAPRDOCINFO SET HasOpinionYN = 'Y' WHERE DocID = '" + orgDocID + "'\n");
			
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

	public String setCabinetRecv(String docID, String userID, String userName, String userName2, String deptID, String companyID) throws Exception{
		String strSQL = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		String writerDeptID = ezApprovalGDAO.setCabinetRecvAprMemdtID(map);
		
		if (writerDeptID.trim().equals("")) {
			writerDeptID = deptID;
		}
		
		String writerDeptName = ezOrganService.getPropertyValue(writerDeptID, "displayName");
		String writerDeptName2 = ezOrganService.getPropertyValue(writerDeptID, "displayName2");
		
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
                    writerDeptID, writerDeptName, writerDeptName2, "2", ezOrganService.getPropertyValue(userID, "title"), ezOrganService.getPropertyValue(userID, "title2"),
                    docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim(),
                    EgovDateUtil.getTodayTime().substring(0, 10), userName, userName2, deliverySN, "1", 
					docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim(), 
					"0", numOfPage, hasAttach, seperateAttachXML, companyID);
		} else {
			return "FALSE";
		}
		
		return strSQL;
	}

	public String updateSusinResult(String orgDocID, String deptID, String userID, String mode, String userName, String userName2, String companyID) throws Exception{
		String strSQL = "";
		String processFlag = mode.toUpperCase();
		
		if (!userID.trim().equals("")) {
			userName = ezOrganService.getPropertyValue(userID, "displayName");
			userName2 = ezOrganService.getPropertyValue(userID, "displayName2");
		}
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", orgDocID);
		map.put("v_DEPTID", deptID);
		
		String receiptUserID = makeListField(ezApprovalGDAO.updateSusinResultReceipt(map));
		
		if (receiptUserID.toUpperCase().equals(userID.toUpperCase())) {
			strSQL = "UPDATE TBENDRECEIPTPOINTINFO SET ProcessYN = '" + processFlag + "', ProcessDate = SYSDATE" + 
					" WHERE DocID = '" + orgDocID + 
					"' AND ReceiptPointID = '" + deptID + "' AND ReceiptMemberID = '" + userID + "';\n";
		} else {
			strSQL = "UPDATE TBENDRECEIPTPOINTINFO SET ProcessYN = '" + processFlag + "', ProcessDate = SYSDATE" + 
				", ReceiptMemberID = '" + userID +
                "', ReceiptMemberName = '" + userName + "', ReceiptMemberName2 = '" + userName2 + "' WHERE DocID = '" + orgDocID + 
				"' AND ReceiptPointID = '" + deptID + "' AND ProcessYN <> '" + processFlag + "';\n";
		}
	
		return strSQL;
	}

	public String setCabinetRec(String docID, String companyID) throws Exception{
		String strSQL = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
					EgovDateUtil.getTodayTime().substring(0, 10),
                    docXML.getElementsByTagName("WRITERNAME").item(0).getTextContent().trim(),
                    docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim(), "", "1", 
					docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim(), 
					docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim(), 
					"0", numOfPage, hasAttach, seperateAttachXML, companyID);
		} else {
			return "FALSE";
		}
		
		return strSQL;
	}

	private String regDocToCabinet(String manualFlag, String docID, String regSN, String cabinetID, String title, String deptCode, String deptName, String deptName2, String registerType, String aprMemberTitle, String aprMemberTitle2,
			String drafterName, String drafterName2, String executeDate, String receiptMember, String receiptMember2, String deleveryNo, String electronic, String sourceDocID, String specialRec, String publicCode, String limitRange, String rejectFlag,
			String numOfPage, String attachFlag, String seperateAttachXML, String companyID) throws Exception{
		String strSQL = "";
		StringBuilder resultXML = new StringBuilder();
		
		resultXML.append("<PARAMETERS>");
		resultXML.append("<MANUALFLAG>" + manualFlag + "</MANUALFLAG>");
		resultXML.append("<DOCID>" + docID + "</DOCID>");
		resultXML.append("<REGSN>" + regSN + "</REGSN>");
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
		resultXML.append("<DELEVERYNO>" + deleveryNo + "</DELEVERYNO>");
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
		resultXML.append("<COMPANYID>" + companyID + "</COMPANYID>");
		resultXML.append("</PARAMETERS>");
		
		strSQL = registerRecordOfQuery(resultXML.toString());
		
		return strSQL;
	}

	public String registerRecordOfQuery(String strXML) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		Document objParam = commonUtil.convertStringToDocument(strXML);
		String subSQL = "";
		
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
			regSN = getSerialNum("002", deptCode, "", companyID, langType);
			
			if (regSN.equals("")) {
				return "FALSE";
			}
		} else {
			registerDate = EgovDateUtil.getTodayTime();
			specialCatalogFlag = getRecordSCFlag(cabID, companyID);
			regSN = objParam.getElementsByTagName("REGSN").item(0).getTextContent();
			rejectFlag = objParam.getElementsByTagName("REJECTFLAG").item(0).getTextContent();
			attachFlag = objParam.getElementsByTagName("ATTACHFLAG").item(0).getTextContent();
			docID = objParam.getElementsByTagName("DOCID").item(0).getTextContent();
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			
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
		
		String regYear = getAccountingYear(processDate, companyID, langType);
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
		String docType = objParam.getElementsByTagName("DOCTYPE").item(0).getTextContent();
		String visualAudioDesc = objParam.getElementsByTagName("VISUALAUDIODESC").item(0).getTextContent();
		String visualAudioType = objParam.getElementsByTagName("VISUALAUDIOTYPE").item(0).getTextContent();
		String originRegSN = objParam.getElementsByTagName("ORIGINREGSN").item(0).getTextContent();
		String oldFlag = "1";
		String recordID = deptCode + regYear + regSN;
		String registerSN = deptCode + regSN;
		
		strSQL.append("Insert Into TBRECORD(RecordID, DocID, ProcessDeptName, ProcessDeptName2, ProcessDeptCode, ");
        strSQL.append("RegisterYear, RegisterDate, RegisterNo, AprMemberTitle, AprMemberTitle2, DrafterName, DrafterName2, ExecuteDate, ");
        strSQL.append("ReceiptMemberName, ReceiptMemberName2, SendingMemberName, SendingMemberName2, DeliveryNo, ProduceDeptRegNo, ElectronicRecFlag, ");
		strSQL.append("SpecialRecordCode, PublicityCode, LimitRange, OldRecordFlag, DeleteDate, ");
		strSQL.append("DelFlag, SpecialCatalogFlag, AttachFlag, CreateDate, RejectFlag, ManualRegFlag, ");
		strSQL.append("DocType) VALUES ('" + makeRightField(recordID) + "', '" + makeRightField(docID));
        strSQL.append("', N'" + makeRightField(deptName) + "', N'" + makeRightField(deptName2) + "', '" + makeRightField(deptCode));
		strSQL.append("', '" + makeRightField(regYear) + "', SYSDATE");
        strSQL.append(", '" + makeRightField(registerSN) + "', N'" + makeRightField(aprMemberTitle) + "', N'" + makeRightField(aprMemberTitle2));
        strSQL.append("', N'" + makeRightField(drafterName) + "', N'" + makeRightField(drafterName2) + "', TO_DATE('" + makeRightField(executeDate));
        strSQL.append("','YYYY-MM-DD HH24:MI:SS'), N'" + makeRightField(receiptMember) + "', N'" + makeRightField(receiptMember2) + "', NULL, NULL, '" + makeRightField(deliveryNo));
		strSQL.append("', '" + makeRightField(originRegSN) + "', '" + makeRightField(electronicRecFlag));
		strSQL.append("', '" + makeRightField(specialRec) + "', '" + makeRightField(publicCode));
		strSQL.append("', '" + makeRightField(limitRange) + "', '" + makeRightField(oldFlag));
		strSQL.append("', NULL, '" + makeRightField("0") + "', '" + makeRightField(specialCatalogFlag));
		strSQL.append("', '" + makeRightField(attachFlag) + "', SYSDATE" );
		strSQL.append(", '" + makeRightField(rejectFlag) + "', '" + makeRightField(manualFlag));
        strSQL.append("', '" + makeRightField(docType) + "');\n");
        
        subSQL = registerSepAttachEx(recordID, cabID, title, numOfPage, registerType, visualAudioDesc, visualAudioType, companyID, formatSepSerialNum("00"));
        
        if (subSQL.equals("FALSE")) {
        	return "FALSE";
        } else {
        	strSQL.append(subSQL);
        }
        
        if (objParam.getElementsByTagName("SEPATTACH").getLength() > 0) {
        	for (int k = 0; k < objParam.getElementsByTagName("SEPATTACH").getLength(); k++) {
        		int tempValue = k + 1;
        		subSQL = registerSepAttachEx(recordID, objParam.getElementsByTagName("CABINETID").item(k).getTextContent(), objParam.getElementsByTagName("TITLE").item(k).getTextContent(), objParam.getElementsByTagName("NUMOFPAGE").item(k).getTextContent(), objParam.getElementsByTagName("REGTYPE").item(k).getTextContent(), objParam.getElementsByTagName("SUMMARY").item(k).getTextContent(), objParam.getElementsByTagName("AVTYPE").item(k).getTextContent(), companyID, formatSepSerialNum(String.valueOf(tempValue)));
        		
        		if (subSQL.equals("FALSE")) {
        			return "FALSE";
        		} else {
        			strSQL.append(subSQL);
        		}
        	}
        }
        NodeList nodeSL = objParam.getDocumentElement().getElementsByTagName("SPECIALCATALOGINFO");
        
        if (specialCatalogFlag.equals("2") && nodeSL != null) {
        	subSQL = saveSpecialInfoRec(recordID, cabID, objParam);
        	
        	if (subSQL.equals("FALSE")) {
        		return "FALSE";
        	} else {
        		strSQL.append(subSQL);
        	}
        }
        
		return strSQL.toString();
	}

	public String saveSpecialInfoRec(String recordID, String cabID, Document objParam) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		
		strSQL.append("INSERT INTO TBSPECIALCATALOGINFO_REC (RecordID, SerialNo, SC1, ");
        strSQL.append("SC2, SC3) SELECT '" + makeRightField(recordID) + "', SerialNo, SC1, SC2, SC3 ");
        strSQL.append("FROM TBSPECIALCATALOGINFO_CAB INNER JOIN (Select CabinetClassNo ");
        strSQL.append("From TBCABINET Where TBCABINET.CabinetID = '" + makeRightField(cabID));
        strSQL.append("') TBCABINET ON TBSPECIALCATALOGINFO_CAB.CabinetClassNo=TBCABINET.CabinetClassNo ");
        strSQL.append(" Where SerialNo='000' ;\n");
        
        if (objParam.getElementsByTagName("SCDATA").getLength() > 0) {
        	for (int k = 0; k < objParam.getElementsByTagName("SCDATA").getLength(); k++) {
        		strSQL.append("INSERT INTO TBSPECIALCATALOGINFO_REC (RecordID, SerialNo, SC1, SC2, SC3) Values ('");
                strSQL.append(makeRightField(recordID) + "', '");
                strSQL.append(makeRightField(objParam.getElementsByTagName("SN").item(k).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(objParam.getElementsByTagName("LIST1").item(k).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(objParam.getElementsByTagName("LIST2").item(k).getTextContent().trim()) + "', N'");
                strSQL.append(makeRightField(objParam.getElementsByTagName("LIST3").item(k).getTextContent().trim()) + "');\n");
        	}
        }
        
		return strSQL.toString();
	}

	private String formatSerialNum(String strValue) throws Exception{
		return getNDigitNum(strValue, 6);
	}

	public String getRecordSCFlag(String cabID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CABINETID", cabID);
		
		return ezApprovalGDAO.getRecordSCFlag(map);
	}

	public String getSerialNum(String snType1, String snType2, String snType3, String companyID, String langType) throws Exception{
		String accountYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, langType);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("iv_Type1", snType1);
		map.put("iv_Type2", snType2);
		map.put("iv_Type3", snType3);
		map.put("v_AccountYear", accountYear);
		
		int result = ezApprovalGDAO.spGetSerialNo(map);
		
		return String.valueOf(result);
	}

	public String doApproveEnd(String docID, String dirPath, String deptID, boolean sendFlag, String companyID) throws Exception{
		String strSQL = "";
		boolean rtnVal = true;
		String docState = "";
		String href = "";
		String orgDeptID = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
				String containerID = returnContainerID(orgDeptID, docState, companyID);
				String extFileName = getExtendedFileName(href);
				String oldYear = getDocHrefYear(docID, companyID);
				String endURL = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + companyID + commonUtil.separator + "Doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName;
				String source = dirPath + commonUtil.separator + href.replace(config.getProperty("upload_approvalG.ROOT"), "");
				
				rtnVal = copyFile(source, dirPath + commonUtil.separator + companyID + commonUtil.separator + "Doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName, dirPath + commonUtil.separator + companyID + commonUtil.separator + "Doc" + commonUtil.separator + oldYear + commonUtil.separator + getDocDir(docID));

				if (rtnVal) {
					strSQL = "APRApproveEnd ('" + docID + "', '" + endURL + "','" + containerID + "');\n";
				}
				
				break;
			}
		}
		
		if (rtnVal) {
			return strSQL;
		} else {
			return "FALSE";
		}
	}

	public String returnContainerID(String deptID, String docState, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DEPTID", deptID);
		map.put("v_DOCSTATE", docState);
		
		String containerID = ezApprovalGDAO.returnContainerID(map);
		String containerType = containerID.split(":")[1];
		
		containerID = containerID.split(":")[0];
		
		if (containerID.trim().equals("")) {
			containerID = makeContainer(deptID, makeListField(containerType), companyID);
		}
 		
		return containerID;
	}

	public String makeContainer(String deptID, String containerType, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CONTAINERTYPE", containerType);
		map.put("v_DEPTID", deptID);
		
		String maxContainerID = ezApprovalGDAO.makeContainer(map);
		
		return maxContainerID;
	}

	public String doSendDoc(String docID, String deptID, String dirPath, String docState, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		boolean rtnVal = true;
		String subSQL = "";
		Document receiptXML = null;
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
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
		String susinGroupIcon = getCode2Name("A53", "001", companyID, lang);
		String flag = getCode2Name("A35", "002", companyID, lang).toUpperCase().trim();
		String orgDocID = docID;
		String tempOrgDocID = "";
		
		Map<String, Object> map1 = new HashMap<String, Object>();
		map1.put("companyID", companyID);
		map1.put("v_DOCID", docID);
		
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
					subSQL = updateProcessYN(tempOrgDocID, "", "S", "QUERY", companyID, lang);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
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
						subSQL = updateProcessYN(docID, receiptPointID, "S", "QUERY", companyID, lang);
						
						if (subSQL.toUpperCase().equals("FALSE")) {
							rtnVal = false;
						} else {
							strSQL.append(subSQL);
						}
						
						if (!tempOrgDocID.trim().equals("")) {
							subSQL = updateProcessYN(tempOrgDocID, receiptPointID, "S", "QUERY", companyID, lang);
							
							if (subSQL.toUpperCase().equals("FALSE")) {
								rtnVal = false;
							} else {
								strSQL.append(subSQL);
							}
						}
					} else {
						String newID = getNewID(receiptCompanyID);
						
						Map<String, Object> map3 = new HashMap<String, Object>();
						map3.put("companyID", companyID);
						map3.put("v_DOCID", docID);
						map3.put("v_FLAG", "APR");
						
						String fileName = ezApprovalGDAO.getDocInfoHref(map3);
						String extFileName = getExtendedFileName(fileName);
						String url = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + receiptCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
						
						if (rtnVal) {
							strSQL.append("INSERT INTO TBAPRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
                            strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
                            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
                            strSQL.append("isPublic) SELECT '" + newID + "', FormID, '" + orgDocID + "', DocType, '" + docState);
                            strSQL.append("', '" + staASDoJak + "', '" + url + "', DocTitle, DocNo, HasAttachYN, ");
                            strSQL.append("'N', NULL, NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
                            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic FROM TBAPRDOCINFO WHERE DocID = '" + docID + "';\n");

                            strSQL.append("INSERT INTO TBEXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
                            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval) ");
                            strSQL.append("SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
                            strSQL.append("ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval FROM TBEXPAPRDOCINFO ");
                            strSQL.append("WHERE DocID = '" + docID + "'; \n");

                            strSQL.append("INSERT INTO TBAPRATTACHINFO (DocID, AttachFileSN, ");
                            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
                            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach) SELECT '" + newID);
                            strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
                            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach FROM ");
                            strSQL.append("TBAPRATTACHINFO WHERE DocID = '" + docID + "';\n");

                            strSQL.append("INSERT INTO TBAPRDOCATTACHINFO (DocID, AttachSN, ");
                            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
                            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2) SELECT '" + newID);
                            strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
                            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2 FROM ");
                            strSQL.append("TBAPRDOCATTACHINFO WHERE DocID = '" + docID + "';\n");
                            
                            int susinSN = ezApprovalGDAO.getReceiptProcessInfoRec(map3);
                            
                            susinSN += 1;
                            
                            strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
                            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
                            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
                            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT '" + susinSN + "', '" + newID);
                            strSQL.append("', WriterDeptID, WriterDeptName, WriterDeptName2, '" + receiptPointID + "', N'" + receiptPointName + "', N'" + receiptPointName2);
							strSQL.append("', '" + docState + "', '" + staASDoJak + "', SYSDATE, 'N', '', '" + receiptMemberID);
                            strSQL.append("', N'" + receiptMemberName + "', N'" + receiptMemberName2 + "', N'" + receiptMemberJobTitle + "', N'" + receiptMemberJobTitle2 + "', '" + orgDocID + "' FROM TBAPRDOCINFO ");
							strSQL.append("WHERE DocID = '" + docID + "';\n");
							
							if (!flag.equals("G")) {
								strSQL.append("UPDATE TBAPRDOCINFO SET DocState = '014' WHERE DocID = '" + docID + "';\n");
								
								subSQL = updateProcessYN(docID, receiptPointID, "S", "QUERY", companyID, lang);
								
								if (subSQL.toUpperCase().equals("FALSE")) {
									rtnVal = false;
								} else {
									strSQL.append(subSQL);
								}
								
								if (!tempOrgDocID.trim().equals("")) {
									subSQL = updateProcessYN(tempOrgDocID, receiptPointID, "S", "QUERY", companyID, lang);
									
									if (subSQL.toUpperCase().equals("FALSE")) {
										rtnVal = false;
									} else {
										strSQL.append(subSQL);
									}
								}
							} else {
								if (!tempOrgDocID.trim().equals("")) {
									subSQL = updateProcessYN(tempOrgDocID, receiptPointID, "S", "QUERY", companyID, lang);
									
									if (subSQL.toUpperCase().equals("FALSE")) {
										rtnVal = false;
									} else {
										strSQL.append(subSQL);
									}
								}
							}
							
							if (receiptMemberID.trim().equals("")) {
								sendRecvMsg(receiptPointID, docID, "SUSIN", receiptCompanyID, lang);
							} else {
								sendMsg(docID, receiptMemberID, "SUSIN", receiptCompanyID, lang);
							}
						}
					}
				}
			}
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	public String sendRecvMsg(String deptID, String docID, String mode, String companyID, String lang) throws Exception{
		String rtnXML = ezOrganService.getSearchList("EXACT_Department::" + deptID + ";;extensionAttribute1::a=1", "displayName", "department", "user", 50, commonUtil.getPrimaryData(lang));
		Document docXML = commonUtil.convertStringToDocument(rtnXML);
		
		for (int k = 0; k < docXML.getElementsByTagName("DATA2").getLength(); k++) {
			if (deptID.equals(docXML.getElementsByTagName("DATA3").item(k).getTextContent())) {
				sendMsg(docID, docXML.getElementsByTagName("DATA2").item(k).getTextContent(), mode, companyID, lang);
			}
		}
		
		return "TRUE";
	}

	public String updateProcessYN(String docID, String deptID, String processYN, String mode, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String flag = getCode2Name("A35", "002", companyID, lang).toUpperCase().trim();
		String deptName = "";
		String deptName2 = "";
		
		if (!flag.equals("G")) {
			strSQL.append("UPDATE TBENDRECEIPTPOINTINFO SET ProcessYN = '" + processYN);
            strSQL.append("', ProcessDate = SYSDATE");
            strSQL.append(" WHERE DocID = '" + docID.trim() + "' AND ReceiptPointID = '");
            strSQL.append(makeRightField(deptID.trim()) + "';\n");
            
            Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID.trim());
			map.put("v_RECEIPTPOINTID", deptID.trim());
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
				 strSQL.append("UPDATE TBENDRECEIPTPOINTINFO SET ProcessYN = '" + processYN);
                 strSQL.append("', ProcessDate = SYSDATE");
                 strSQL.append(" WHERE DocID = '" + docID.trim() + "' AND ProcessYN = 'O';\n");
			} else {
				strSQL.append("UPDATE TBENDRECEIPTPOINTINFO SET ProcessYN = '" + processYN);
                strSQL.append("', ProcessDate = SYSDATE");
                strSQL.append(" WHERE DocID = '" + docID.trim() + "' AND ReceiptPointID = '");
                strSQL.append(makeRightField(deptID.trim()) + "';\n");
                
                Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("companyID", companyID);
				map1.put("v_DOCID", docID.trim());
				map1.put("v_RECEIPTPOINTID", deptID.trim());
				map1.put("v_FLAG", "END");
				
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
			strSQL.append("INSERT INTO TBHISTORYRECEIPTINFO (DocID, ReceiptDeptID, ReceiptDeptName, ReceiptDeptName2, Status, StatusDate) ");
            strSQL.append("SELECT DocID, ReceiptPointID, ReceiptPointName, ReceiptPointName2, ProcessYN, ProcessDate ");
			strSQL.append("FROM TBENDRECEIPTPOINTINFO  ");
			strSQL.append("WHERE DocID = '" + docID.trim() + "';\n");
		} else {
			if (deptName.trim().equals("")) {
				deptName = deptID;
			}

            strSQL.append("INSERT INTO TBHISTORYRECEIPTINFO (DocID, ReceiptDeptID, ");
            strSQL.append("ReceiptDeptName, ReceiptDeptName2, Status, StatusDate) VALUES ('" + docID.trim());
			strSQL.append("', '" + makeRightField(deptID.trim()) + "', N'");
			strSQL.append(makeRightField(deptName.trim()) + "', N'" + makeRightField(deptName2.trim()) + "', '" + processYN + "', SYSDATE");
			strSQL.append(");\n");
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

	public String doDeptAssist(String docID, String deptID, String deptName, String deptName2, String dirPath, String aprState, String docState, String pCompanyID, String companyID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String newID = getNewID(pCompanyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", "APR");
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String fileURL = dirPath + commonUtil.separator + fileName.replace(config.getProperty("upload_approvalG.ROOT"), "");
		String url = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + pCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime() + commonUtil.separator + 
				"1000" + commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		
		boolean rtnVal = copyFile(fileURL, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime() + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID) +
				commonUtil.separator + newID + "." + extFileName, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime() + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID)); 
		
		if (rtnVal) {
			// 2010.08.03 다국어
            strSQL.append("INSERT INTO TBAPRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
			strSQL.append("isPublic) SELECT '" + newID + "', FormID, '" + docID + "', DocType, '" + docState);
			strSQL.append("', '" + staASDoJak + "', '" + url + "', DocTitle, DocNo, HasAttachYN, ");
            strSQL.append("'N', NULL, NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic FROM TBAPRDOCINFO WHERE DocID = '" + docID + "';\n");

			// 수정(2005.08.29) : 보안결재 필드(SecurityApproval) 추가
            // 2010.08.03 다국어
            strSQL.append("INSERT INTO TBEXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, ItemName2, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval) ");
            strSQL.append("SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
            strSQL.append("ItemCode, ItemName, ItemName2, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval FROM TBEXPAPRDOCINFO ");
			strSQL.append("WHERE DocID = '" + docID + "' ;\n");

            // 2010.08.03 다국어
            strSQL.append("INSERT INTO TBAPRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach) SELECT '" + newID);
			strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach FROM ");
            strSQL.append("TBAPRATTACHINFO WHERE DocID = '" + docID + "';\n");

            // 2010.08.03 다국어
            strSQL.append("INSERT INTO TBAPRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2) SELECT '" + newID);
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2 FROM ");
            strSQL.append("TBAPRDOCATTACHINFO WHERE DocID = '" + docID + "';\n");

            // 2010.08.03 다국어
            strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT 1, '" + newID + "', WriterDeptID, ");
            strSQL.append("WriterDeptName, WriterDeptName2, '" + deptID + "', N'" + deptName + "', N'" + deptName2 + "', '" + docState);
            strSQL.append("', '" + staASDoJak + "', SYSDATE, 'N', '', '', '', '', '', '', DocID FROM TBAPRDOCINFO ");
            strSQL.append("WHERE DocID = '" + docID + "';\n");
		} else {
			strSQL.append("FALSE");
		}
		
		return strSQL.toString();
	}

	public String setBujaeInfo(String docID, String aprMemberID, String aprMemberDeptID, String absentReason, String aprType, String companyID, String lang) throws Exception{
		String strSQL = "";
		StringBuilder resultXML = new StringBuilder();
		String susinSN = getSusinSNInside(docID, companyID);
		int cnt = 1;
		String aprSN = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
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
			resultXML.append("<CONTENT>" + EgovDateUtil.getTodayTime().substring(6, 10) + "</CONTENT>");
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
			resultXML.append("<CONTENT>" + EgovDateUtil.getTodayTime().substring(6, 10) + "</CONTENT>");
			resultXML.append("</SIGNINFO>");
		}
		
		resultXML.append("</SIGNINFOS>");
		
		strSQL = updateSignInfo(resultXML, companyID, "QUERY");
		
		return strSQL;
	}

	public String updateSignInfo(StringBuilder resultXML, String companyID, String mode) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		Document docXML = commonUtil.convertStringToDocument(strSQL.toString());
		String strDocID = docXML.getElementsByTagName("DOCID").item(0).getTextContent();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", strDocID);
		
		int aprSN = ezApprovalGDAO.updateSignInfoAprSN(map);
		int signLength = docXML.getElementsByTagName("SIGNINFO").getLength();
		int maxAprSN = 0;
		
		for (int k = 0; k < signLength; k++) {
			maxAprSN = aprSN + k + 1;
			
			strSQL.append("INSERT INTO TBSIGNINFO (DocID, AprSN, SignType, SignName, Content) ");
            strSQL.append("VALUES ('" + strDocID + "', '" + maxAprSN + "', '");
			strSQL.append(makeRightField(docXML.getElementsByTagName("SIGNTYPE").item(k).getTextContent()) + "', N'");
			strSQL.append(makeRightField(docXML.getElementsByTagName("SIGNNAME").item(k).getTextContent()) + "', N'");
			strSQL.append(makeRightField(docXML.getElementsByTagName("CONTENT").item(k).getTextContent()) + "');\n");
		}
		
		if (mode.toUpperCase().equals("QUERY")) {
			return strSQL.toString();
		} else {
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
	}

	public String getSusinSNInside(String docID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		String rtnVal = makeListField(ezApprovalGDAO.getSusinSNInside(map));
		
		return rtnVal;
	}

	public String getBujaeInfo(String userID) throws Exception{
		String absentReason = ezOrganService.getPropertyValue(userID, "extensionAttribute5");
		String rtnVal = "";
		
		if (absentReason != null && !absentReason.trim().equals("")) {
			String[] reasons = absentReason.split(":");
			if (reasons[0].trim().equals("") && reasons.length >= 5) {
				String now = EgovDateUtil.getTodayTime();
				
				if (now.compareTo(reasons[3].replace("/", ":")) >= 0 && now.compareTo(reasons[4].replace("/", ":")) <= 0) {
					rtnVal = reasons[5];
				}
			}
		}
		
		return rtnVal;
	}

	public String doChamjo(String docID, String userID, String userName, String userName2, String userJobTitle, String userJobTitle2, String deptID, String deptName,
			String deptName2, String deptYN, String pCompanyID, String dirPath, String docState, String companyID) throws Exception{
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
		
		String newID = getNewID(companyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", "APR");
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String fileURL = dirPath + commonUtil.separator + fileName.replace(config.getProperty("upload_approvalG.ROOT") + commonUtil.separator, "");
		String url = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + pCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator +
				getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		boolean rtnVal = copyFile(fileURL, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator +
				getDocDir(newID) + commonUtil.separator + newID + "." + extFileName, dirPath + commonUtil.separator + pCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator +
				"1000" + commonUtil.separator + getDocDir(newID));
		
		if (rtnVal) {
			strSQL.append("INSERT INTO TBAPRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
			strSQL.append("isPublic) SELECT '" + newID + "', FormID, '" + docID + "', DocType, '" + docState);
			strSQL.append("', '" + aprState + "', '" + url + "', DocTitle, DocNo, HasAttachYN, ");
            strSQL.append("HasOpinionYN, SYSDATE, NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic FROM TBAPRDOCINFO WHERE DocID = '" + docID + "';\n");

			// 수정(2005.08.29) : 보안결재 필드(SecurityApproval) 추가
			strSQL.append("INSERT INTO TBEXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, ItemName2, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval) ");
            strSQL.append("SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
            strSQL.append("ItemCode, ItemName, ItemName2, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval FROM TBEXPAPRDOCINFO ");
			strSQL.append("WHERE DocID = '" + docID + "' ;\n");

			strSQL.append("INSERT INTO TBAPRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach) SELECT '" + newID);
			strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach FROM ");
            strSQL.append("TBAPRATTACHINFO WHERE DocID = '" + docID + "';\n");

			strSQL.append("INSERT INTO TBAPRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2) SELECT '" + newID);
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2 FROM ");
            strSQL.append("TBAPRDOCATTACHINFO WHERE DocID = '" + docID + "';\n");

			strSQL.append("INSERT INTO TBAPROPINIONINFO (DocID, UserID, ");
            strSQL.append("OpinionGB, Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, ");
            strSQL.append("OpinionSN) SELECT '" + newID + "', UserID, OpinionGB, Content, UserName, UserName2, ");
            strSQL.append("UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN FROM TBAPROPINIONINFO ");
			strSQL.append("WHERE DocID = '" + docID + "';\n");

			if (deptYN.toUpperCase().equals("Y")) {
				strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
                strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
                strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
                strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT 1, '" + newID + "', WriterDeptID, ");
                strSQL.append("WriterDeptName, WriterDeptName2, '" + deptID + "', N'" + deptName + "', N'" + deptName2 + "', '" + docState);
                strSQL.append("', '" + staASDoJak + "', NULL, 'N', '', '', '', '', '', '', DocID FROM TBAPRDOCINFO ");
				strSQL.append("WHERE DocID = '" + docID + "';\n");
			} else {
				strSQL.append("INSERT INTO TBAPRLINEINFO (DocID, AprMemberSN, AprType, AprState, ");
                strSQL.append("AprMemberID, AprMemberIsDeptYN, AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, ");
                strSQL.append("AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, AprMemberLDAPPath, ReceivedDate, ");
				strSQL.append("ProcessDate, ReasonDoNotApprov, isProposerYN, isBriefUserYN) VALUES ('");
				strSQL.append(newID + "', 1, '" + aprType + "', '" + aprState + "', '" + userID);
                strSQL.append("', 'N', N'" + userName + "', N'" + userName2 + "', N'" + userJobTitle + "', N'" + userJobTitle2 + "', '" + deptID);
                strSQL.append("', '" + deptName + "', N'" + deptName2 + "', '" + pCompanyID + "', SYSDATE");
				strSQL.append(", NULL, '', 'N', 'N');\n");
				strSQL.append("INSERT INTO TBEXPAPRLINE (docid, aprmemberSN, orguserid, ");
                strSQL.append("proxyuserid, proxyusername, proxyusername2, proxyuserjobtitle, proxyuserjobtitle2, proxyuserdeptid, ");
                strSQL.append("proxyuserdeptname, proxyuserdeptname2) VALUES ('" + newID + "', 1, '" + userID);
                strSQL.append("', '', '', '', '', '', '', '', '');\n");
			}
		} else {
			strSQL.append("FALSE");
		}
		
		return strSQL.toString();
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

	public String sendMsg(String docID, String nextUserID, String mode, String companyID, String lang) throws Exception{
		boolean notiFlag = false;
		
		if (getCode2Name("A43", "001", companyID, lang).equals("Y")) {
			notiFlag = true;
		}
		
		if (notiFlag) {
			String docTitle = "";
			
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_FLAG", "ING");
			
			docTitle = makeListField(ezApprovalGDAO.getDocTitle(map));
			
			if (docTitle.trim().equals("")) {
				Map<String, Object> map1 = new HashMap<String, Object>();
				map1.put("companyID", companyID);
				map1.put("v_DOCID", docID);
				map1.put("v_FLAG", "END");
				
				docTitle = makeListField(ezApprovalGDAO.getDocTitle(map1));
				
				if (docTitle.trim().equals("")) {
					docTitle = getCode2Name("L06", "001", companyID, lang);
				} else {
					if (nextUserID.trim().equals("")) {
						Map<String, Object> map2 = new HashMap<String, Object>();
						map2.put("companyID", companyID);
						map2.put("v_DOCID", docID);
						map2.put("v_FLAG", "END");
						
						nextUserID = makeListField(ezApprovalGDAO.getDraftUserID(map2));
					}
				}
			} else {
				if (nextUserID.trim().equals("")) {
					Map<String, Object> map3 = new HashMap<String, Object>();
					map3.put("companyID", companyID);
					map3.put("v_DOCID", docID);
					map3.put("v_FLAG", "ING");
					
					nextUserID = makeListField(ezApprovalGDAO.getDraftUserID(map3));
				}
			}
			
			String notyStr = "";
			
			switch (mode.toUpperCase()) {
			case "ING" :
                notyStr = getCode2Name("L06", "002", companyID, lang); //"문서도착";
				break;
			case "END" :
                notyStr = getCode2Name("L06", "003", companyID, lang); //"문서완료";
				break;
			case "BAN" :
                notyStr = getCode2Name("L06", "004", companyID, lang); //"문서반송";
				break;
			case "BOR" :
                notyStr = getCode2Name("L06", "005", companyID, lang); //"문서보류";
				break;
			case "BAL" :
                notyStr = getCode2Name("L06", "006", companyID, lang); //"문서발송";
				break;
			case "SUSIN" :
                notyStr = getCode2Name("L06", "007", companyID, lang); //"수신문서";
				break;
			case "JIJUNG" :
                notyStr = getCode2Name("L06", "008", companyID, lang); //"지정문서";
				break;
			case "BEBU" :
                notyStr = getCode2Name("L06", "012", companyID, lang); //"배부문서"; //012
				break;
			case "HESONG" :
                notyStr = getCode2Name("L06", "009", companyID, lang); //"회송문서";
				break;
			case "HESU" :
                notyStr = getCode2Name("L06", "010", companyID, lang); //"문서회수";
				break;
			case "REJIJUNG" :
                notyStr = getCode2Name("L06", "013", companyID, lang); //"재지정요청"; //013
				break;
			case "REBEBU" :
                notyStr = getCode2Name("L06", "014", companyID, lang); //"재배부요청"; //014
				break;
			default :
                notyStr = getCode2Name("L06", "011", companyID, lang); //"결재노티";
				break;
			}
			insertNotifyItem(nextUserID, notyStr, docTitle, "2", docID);
		}
		
		return "TRUE";
	}

	public String insertNotifyItem(String userID, String notyStr, String subject, String type, String etcData) throws Exception{
		String result = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUSERID", userID);
		map.put("v_PSENDER", notyStr);
		map.put("v_PSUBJECT", subject);
		map.put("v_PTYPE", type);
		map.put("v_PETCDATA", etcData);
		
		try {
			ezApprovalGDAO.insertNotifyItem(map);
			
			result = "OK";
		} catch (Exception e) {
			result = "ERROR";
		}
		
		return result;
	}

	public String insertProxyUserInfo(String docID, String curAprMemberSN, String userID, String proxyUserID, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String isUse = getIsUse("A23", "001", companyID, lang);
		
		if (isUse.equals("1")) {
			String rtnXML = ezOrganService.getPropertyList(proxyUserID, "displayName;title;department;description", commonUtil.getPrimaryData(lang));
			
			Document docXML = commonUtil.convertStringToDocument(rtnXML);
			
			if (docXML.getDocumentElement().getChildNodes().getLength() > 0) {
				strSQL.append("UPDATE TBEXPAPRLINE SET proxyuserid = '" + proxyUserID);
                strSQL.append("', proxyusername = N'" + docXML.getElementsByTagName("DISPLAYNAME").item(0).getTextContent());
                strSQL.append("', proxyusername2 = N'" + docXML.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent());
                strSQL.append("', proxyuserjobtitle = N'" + docXML.getElementsByTagName("TITLE").item(0).getTextContent());
                strSQL.append("', proxyuserjobtitle2 = N'" + docXML.getElementsByTagName("TITLE2").item(0).getTextContent());
				strSQL.append("', proxyuserdeptid = '" + docXML.getElementsByTagName("DEPARTMENT").item(0).getTextContent());
                strSQL.append("', proxyuserdeptname = N'" + docXML.getElementsByTagName("DESCRIPTION").item(0).getTextContent());
                strSQL.append("', proxyuserdeptname2 = N'" + docXML.getElementsByTagName("DESCRIPTION2").item(0).getTextContent());
				strSQL.append("' WHERE DocID = '" + docID + "' AND AprMemberSN = '");
                strSQL.append(curAprMemberSN + "' and orguserid = '" + userID + "';\n");
			}
		}
		
		return strSQL.toString();
	}

	public String updateDocInfo(Document docXML, String userID, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		StringBuilder subSQL = new StringBuilder();
		boolean firstFlag = true;
		
		String docID = docXML.getDocumentElement().getChildNodes().item(0).getTextContent();
		String tempValue = "";
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(7).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_DOCTITLE", tempValue);
			
			ezApprovalGDAO.updateDocInfoDocTitle(map);
		}
		
		strSQL.append("UPDATE TBAPRDOCINFO SET ");
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(1).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" FormID = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", FormID = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(2).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" OrgDocID = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", OrgDocID = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(3).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" DocType = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", DocType = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(4).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" DocState = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", DocState = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(5).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" FunctionType = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", FunctionType = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(6).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" Href = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", Href = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(7).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" DocTitle = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", DocTitle = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(8).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" DocNo = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", DocNo = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(9).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" HasAttachYN = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", HasAttachYN = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(10).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" HasOpinionYN = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", HasOpinionYN = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(11).getTextContent().trim();
		
		if (tempValue.equals("DRAFT")) {
			if (firstFlag) {
				strSQL.append(" StartDate = SYSDATE ");
				firstFlag = false;
			} else {
				strSQL.append(", StartDate = SYSDATE ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(12).getTextContent().trim();
		
		if (tempValue.equals("DRAFT")) {
			if (firstFlag) {
				strSQL.append(" EndDate = NULL ");
				firstFlag = false;
			} else {
				strSQL.append(", EndDate = NULL ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(13).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" WriterID = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", WriterID = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(14).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" WriterName = N'" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", WriterName = N'" + makeRightField(tempValue) + "' ");
			}
		}

		if (docXML.getElementsByTagName("WRITERNAME2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("WRITERNAME2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					strSQL.append(" WriterName2 = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					strSQL.append(", WriterName2 = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(15).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" WriterJobTitle = N'" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", WriterJobTitle = N'" + makeRightField(tempValue) + "' ");
			}
		}
		
		if (docXML.getElementsByTagName("WRITERJOBTITLE2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("WRITERJOBTITLE2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					strSQL.append(" WriterJobTitle2 = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					strSQL.append(", WriterJobTitle2 = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(16).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" WriterDeptID = N'" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", WriterDeptID = N'" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(17).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" WriterDeptName = N'" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", WriterDeptName = N'" + makeRightField(tempValue) + "' ");
			}
		}
		
		if (docXML.getElementsByTagName("WRITERDEPTNAME2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					strSQL.append(" WriterDeptName2 = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					strSQL.append(", WriterDeptName2 = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(25).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				strSQL.append(" isPublic = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				strSQL.append(", isPublic = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		strSQL.append(" WHERE DocID = '" + docID + "';\n");
		
		if (firstFlag) {
			strSQL.delete(0, strSQL.length());
		}
		
		firstFlag = true;
		
		subSQL.append("UPDATE TBEXPAPRDOCINFO SET ");

		tempValue = docXML.getDocumentElement().getChildNodes().item(23).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				subSQL.append(" Securitycode = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				subSQL.append(", Securitycode = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(24).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				subSQL.append(" StoragePeriod = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				subSQL.append(", StoragePeriod = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(27).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				subSQL.append(" ItemCode = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				subSQL.append(", ItemCode = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(28).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				subSQL.append(" ItemName = N'" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				subSQL.append(", ItemName = N'" + makeRightField(tempValue) + "' ");
			}
		}
		
		if (docXML.getElementsByTagName("ITEMNAME2").item(0) != null) {
			tempValue = docXML.getElementsByTagName("ITEMNAME2").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" ItemName2 = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", ItemName2 = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(29).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				subSQL.append(" UrgentApproval = '" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				subSQL.append(", UrgentApproval = '" + makeRightField(tempValue) + "' ");
			}
		}
		
		tempValue = docXML.getDocumentElement().getChildNodes().item(30).getTextContent().trim();
		
		if (!tempValue.equals("")) {
			if (firstFlag) {
				subSQL.append(" KeyWord = N'" + makeRightField(tempValue) + "' ");
				firstFlag = false;
			} else {
				subSQL.append(", KeyWord = N'" + makeRightField(tempValue) + "' ");
			}
		}

		if (docXML.getElementsByTagName("SPECIALRECORDCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SPECIALRECORDCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" SpecialRecordCode = '" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", SpecialRecordCode = '" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("PUBLICITYCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("PUBLICITYCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" PublicityCode = '" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", PublicityCode = '" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("LIMITRANGE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("LIMITRANGE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" LimitRange = '" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", LimitRange = '" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("PAGENUM").item(0) != null) {
			tempValue = docXML.getElementsByTagName("PAGENUM").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" PageNum = '" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", PageNum = '" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("CABINETID").item(0) != null) {
			tempValue = docXML.getElementsByTagName("CABINETID").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" CabinetID = '" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", CabinetID = '" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("TASKCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("TASKCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" TaskCode = '" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", TaskCode = '" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("DOCNUMCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("DOCNUMCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" DocNumCode = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", DocNumCode = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("ORGDOCNUMCODE").item(0) != null) {
			tempValue = docXML.getElementsByTagName("ORGDOCNUMCODE").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" OrgDocNumCode = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", OrgDocNumCode = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("SEPERATEATTACHXML").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SEPERATEATTACHXML").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" SeperateAttachXML = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", SeperateAttachXML = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("SUMMARY").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SUMMARY").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" Summary = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", Summary = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		if (docXML.getElementsByTagName("SECURITYAPPROVAL").item(0) != null) {
			tempValue = docXML.getElementsByTagName("SECURITYAPPROVAL").item(0).getTextContent().trim();
			
			if (!tempValue.equals("")) {
				if (firstFlag) {
					subSQL.append(" SecurityApproval = N'" + makeRightField(tempValue) + "' ");
					firstFlag = false;
				} else {
					subSQL.append(", SecurityApproval = N'" + makeRightField(tempValue) + "' ");
				}
			}
		}
		
		subSQL.append(" WHERE DocID = '" + docID + "' " + ";\n");
		
		if (firstFlag) {
			subSQL.delete(0, subSQL.length());
		}
		
		strSQL.append(subSQL.toString());
		String rtnVal = "";
		
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("sqlString", "BEGIN " + strSQL.toString() + " END; ");
			map.put("companyID", companyID);
			
			ezApprovalGDAO.transactionSQL(map);
			
			rtnVal = "TRUE";
		} catch (Exception e) {
			rtnVal = "FALSE";
		}
		if (rtnVal.equals("TRUE")) {
			if (docXML.getDocumentElement().getChildNodes().item(11).getTextContent().trim().equals("DRAFT")) {
				strSQL.append("\n" + insLastAprLine(docID, docXML.getDocumentElement().getChildNodes().item(1).getTextContent().trim(), userID, companyID, lang) + "\n");
				strSQL.append("\n" + insLastAprReceipt(docID, docXML.getDocumentElement().getChildNodes().item(1).getTextContent().trim(), userID, companyID, lang) + "\n");
			}
			
			return strSQL.toString();
		} else {
			return rtnVal;
		}
	}

	public String insLastAprReceipt(String docID, String formID, String userID, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String isUse = getCode2Name("A44", "002", companyID, lang);
		
		if (isUse.equals("1")) {
			strSQL.append("DELETE FROM TBLASTDEPTLINE WHERE UserID = '" + userID);
			strSQL.append("' AND FormID = '" + formID + "'\n");
            strSQL.append("INSERT INTO TBLASTDEPTLINE (UserID, FormID, ReceiptPointID, ReceiptPointName, ReceiptPointName2, ");
			strSQL.append("ExtReceptYN, ProcessYN, ProcessSN, CanEditYN, ExtReceptEmail, ReceiptMemberID, ");
            strSQL.append("ReceiptMemberName, ReceiptMemberName2, ProcessDate, ReceiptMemberJobTitle, ReceiptMemberJobTitle2, DeptMemberSN) SELECT '");
            strSQL.append(userID + "','" + formID + "', ReceiptPointID, ReceiptPointName, ReceiptPointName2, ExtReceptYN, ");
			strSQL.append("'N', ProcessSN, CanEditYN, ExtReceptEmail, ReceiptMemberID, ");
            strSQL.append("ReceiptMemberName, ReceiptMemberName2, NULL, ReceiptMemberJobTitle, ReceiptMemberJobTitle2, DeptMemberSN ");
			strSQL.append("FROM TBRECEIPTPOINTINFO WHERE DOCID = '" + docID + "';\n");
			
            return strSQL.toString();
		} else {
			return "";
		}
	}

	public String insLastAprLine(String docID, String formID, String userID, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String isUse = getCode2Name("A44", "001", companyID, lang);
		
		if (isUse.equals("1")) {
			strSQL.append("DELETE FROM TBLASTAPRLINE WHERE UserID = '" + userID);
            strSQL.append("' AND FormID = '" + formID + "';\n");
			strSQL.append("INSERT INTO TBLASTAPRLINE (UserID, FormID, AprMemberSN, AprType, ");
            // 2010.08.03 다국어
            strSQL.append("AprState, AprMemberID, AprMemberIsDeptYN, AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, ");
            strSQL.append("AprMemberDeptID, AprMemberDeptName, AprMemberDeptName2, AprMemberLDAPPath, ReceivedDate, ");
			strSQL.append("ProcessDate, ReasonDoNotApprov, isProposerYN, isBriefUserYN) SELECT '");
			strSQL.append(userID + "','" + formID + "', AprMemberSN, AprType, '001', AprMemberID, ");
            strSQL.append("AprMemberIsDeptYN, AprMemberName, AprMemberName2, AprMemberJobTitle, AprMemberJobTitle2, AprMemberDeptID, ");
            strSQL.append("AprMemberDeptName, AprMemberDeptName2, AprMemberLDAPPath, NULL, NULL, ReasonDoNotApprov, ");
            strSQL.append("isProposerYN, isBriefUserYN FROM TBAPRLINEINFO WHERE DOCID = '" + docID + "';\n");
			
            return strSQL.toString();
		} else {
			return "";
		}
	}

	public String registerSepAttachEx(String recID, String cabID, String title, String numOfPage, String regType, String summary, String recType, String companyID, String tempSepAttSN) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String sepAttSN = tempSepAttSN;
		
		if (sepAttSN.trim().equals("")) {
			sepAttSN = formatSepSerialNum(getSepAttachSN(recID, companyID));
			if (sepAttSN.trim().equals("")) {
				return "FALSE";
			}
		}
		
		strSQL.append("Insert Into TBSEPERATEATTACH (RecordID, SeperateAttachNo, CabinetID, ");
		strSQL.append("RegisterType, Title, NumOfPage, DelFlag, CreateDate, ModifyFlag, ");
		strSQL.append("CatalogTransferFlag, DocTransferFlag) Values ('" + makeRightField(recID));
		strSQL.append("', '" + makeRightField(sepAttSN) + "', '" + makeRightField(cabID) + "', '");
		strSQL.append(makeRightField(regType) + "', N'" + makeRightField(title) + "', '");
		strSQL.append(makeRightField(numOfPage) + "', '0', SYSDATE");
        strSQL.append(", '0', '0', '0');\n");
        
        if (regType.equals("5") || regType.equals("6")) {
        	String subSQL = saveAudioVisualExtraInfo(recID, sepAttSN, summary, recType);
        	
        	if (subSQL.equals("FALSE")) {
        		strSQL.delete(0, strSQL.length());
        		strSQL.append("FALSE");
        	} else {
        		strSQL.append(subSQL);
        	}
        }
        
		return strSQL.toString();
	}

	public String saveAudioVisualExtraInfo(String recID, String sepAttSN, String summary, String recType) throws Exception{
		return "INSERT INTO TBAUDIO_VISUALRECEXTRAINFO (RecordID, SeperateAttachNo, " +
                "Summary, RecordType) VALUES ('" + makeRightField(recID) + "', '" +
                makeRightField(sepAttSN) + "', N'" + makeRightField(summary) + "', N'" +
                makeRightField(recType) + "');\n";
	}

	public String getSepAttachSN(String recID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_RECORDID", recID);
		
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

	public String getRegTypeString(String pCode, String companyID, String lang) throws Exception{
		return getCabinetCode2Name("003", pCode, companyID, lang);
	}

	public String getRecRegSNToName(String deptName, String regNo) {
		return deptName + "-" + regNo;
	}

	public String getCabinetNo(String strDeptCode, String strTaskCode, String strPYear, String strRegSerialNo, String strVolNo) {
		return strDeptCode + "-" + strTaskCode + "-" + strPYear + "-" + strRegSerialNo + "(" + strVolNo + ")";
	}

	public String getCabJoinClause(Document doc, String deptCode, String transFlag, String listFlag, String companyID) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		String cabWhere = "";
		String tempDeptCode = deptCode;
		String g_Const_CabinetWhereClause = " Where TBCABINET.DelFlag = '0' " + 
				"AND TBCABINETCLASS.DelFlag = '0' AND NOT (TBCABINET.CabinetTransferFlag = '2' And ConfirmFlag = '0') ";

		if (doc.getElementsByTagName("DEPTCODE").item(0) != null && doc.getElementsByTagName("DEPTCODE").item(0).getTextContent().length() > 0) {
			tempDeptCode = doc.getElementsByTagName("DEPTCODE").item(0).getTextContent();
		}
		
		strSQL.append("Inner Join ( Select ProcessDeptCode, ProcessDeptName, ProcessDeptName2, TaskCode, ");
        strSQL.append("TaskName, TaskName2, VolumeNo, CabinetID, TCabinetID, TBCABINET.CabinetClassNo, ");
		strSQL.append("DisplayEndDate, DisplayReason, ConfirmFlag, ProductionYear, RegSerialNo, ");
		strSQL.append("DisplayRecFlag, ExTransYear, TransDelayReason, TransDelayFlag, OwnerDeptID, ");
        strSQL.append("OwnerTask, TerminateFlag, ExpirationYear, KeepingPeriod " + " From TBCABINETCLASS  Inner Join " +
                "TBCABINET  On TBCABINETCLASS.CabinetClassNo = TBCABINET.CabinetClassNo ");
        
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
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + " And TBCABINETCLASS.TerminateFlag='1' And TBCABINETCLASS.ConfirmFlag='0'";
			break;

		case "2" :		// 기록물 생산 현황
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + " And TBCABINETCLASS.ConfirmYear=EXTRACT(YEAR FROM SYSDATE)";
			break;

		case "3" :		// 목록이관 대상
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + " And TBCABINETCLASS.ConfirmFlag='1' " + 
					"And ( ( TBCABINETCLASS.DisplayRecFlag='2' And TBCABINETCLASS.TransDelayFlag='0' " +
		            " And TBCABINETCLASS.ConfirmYear Between EXTRACT(YEAR FROM SYSDATE - (INTERVAL '1' YEAR)) And EXTRACT(YEAR FROM SYSDATE) " +
		            ") OR( ( TBCABINETCLASS.DisplayRecFlag='1' And TBCABINETCLASS.DisplayEndDate<CAST(EXTRACT(YEAR FROM SYSDATE) AS char(4)) ) " +
		            " OR ( TBCABINETCLASS.TransDelayFlag='1' And TBCABINETCLASS.ExTransYear=EXTRACT(YEAR FROM SYSDATE) ) " + 
					") ) And CatalogTransferFlag='0' ";
			break;

		case "6" :		// 연기신청목록
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' " + "And TBCABINETCLASS.KeepingPlace='1' " +
		            "And ( (TBCABINETCLASS.DisplayRecFlag='1' And TBCABINETCLASS.DisplayEndDate>=CAST(EXTRACT(YEAR FROM SYSDATE) AS char(4)) ) " +
		            " OR (TBCABINETCLASS.TransDelayFlag='1' And TBCABINETCLASS.ExTransYear>EXTRACT(YEAR FROM SYSDATE) ) " +
		            " ) And ( ( TBCABINETCLASS.ConfirmYear = EXTRACT(YEAR FROM SYSDATE) ) OR " +
		            " ( TBCABINETCLASS.ConfirmYear > (Select Max(DocTransferYear) From TBCABINET ) ) ) ";
			break;

		default : 
			cabWhere = g_Const_CabinetWhereClause + "And OwnerDeptID= '" + tempDeptCode + "' ";
			break;
		}

        if (doc.getElementsByTagName("CHARGER").item(0) != null && doc.getElementsByTagName("CHARGER").item(0).getTextContent().length() > 0) {
        	cabWhere += "AND TBCABINETCLASS.CabinetClassNo IN ( Select CabinetClassNo " + 
        			"From TBCABROLEINFO Where User_ID IN (" + doc.getElementsByTagName("CHARGER").item(0).getTextContent().trim() + ") ) ";	
        }

		if (doc.getElementsByTagName("TRANSEXPIRE").item(0) != null && doc.getElementsByTagName("TRANSEXPIRE").item(0).getTextContent().length() > 0) {
			cabWhere += g_Const_TransExpCabConst_Function(companyID);
		}

		if (doc.getElementsByTagName("CABTITLE").item(0) != null && doc.getElementsByTagName("CABTITLE").item(0).getTextContent().length() > 0) {
			cabWhere += "AND TBCABINETCLASS.Title Like N'%" + makeSearchField(doc.getElementsByTagName("CABTITLE").item(0).getTextContent().trim()) + "%' ";
		}
		
		strSQL.append(cabWhere + ") TBCABINET On TBSEPERATEATTACH.CabinetID=TBCABINET.CabinetID ");

		if (transFlag == "1") {
			strSQL.append("OR TBSEPERATEATTACH.CabinetID=TBCABINET.TCabinetID ");
		}

		return strSQL.toString();
	}

	public String makeSearchField(String orgStr) {
		return orgStr.replace("'", "''").replace("\0", "").replace("[", "[[]").replace("%", "[%]").replace("_", "[_]");
	}

	public String g_Const_TransExpCabConst_Function(String companyID) throws Exception{
		String strSQL = "";
		String accountingYear = getAccountingYear(EgovDateUtil.getTodayTime(), companyID, "1");
		
		if (!accountingYear.trim().equals("")) {
			strSQL = " And ( TBCABINETCLASS.ConfirmFlag='1' And " +
                    "( TBCABINETCLASS.DisplayRecFlag='2' And TBCABINETCLASS.TransDelayFlag='0' " +
                    " And TBCABINETCLASS.ConfirmYear < '" + (Integer.parseInt(accountingYear) - 1) + "'" +
                    " ) OR ( ( TBCABINETCLASS.DisplayRecFlag='1' And RTRIM(DISPLAYENDDATE) <> '' AND TBCABINETCLASS.DisplayEndDate<'" + accountingYear + "') " +
                    " OR ( TBCABINETCLASS.TransDelayFlag='1' And TBCABINETCLASS.ExTransYear<'" + (Integer.parseInt(accountingYear) - 1) + "') " +
                    " ) ) And TBCABINETCLASS.KeepingPlace='1' And DocTransferFlag='0'";
	    } else {
	        strSQL = " And ( TBCABINETCLASS.ConfirmFlag='1' And " +
	                "( TBCABINETCLASS.DisplayRecFlag='2' And TBCABINETCLASS.TransDelayFlag='0' " +
	                " And TBCABINETCLASS.ConfirmYear < EXTRACT(YEAR FROM SYSDATE-(INTERVAL '1' YEAR)) " +
	                " ) OR ( ( TBCABINETCLASS.DisplayRecFlag='1' And TBCABINETCLASS.DisplayEndDate<CAST(EXTRACT(YEAR FROM SYSDATE) AS char(4)) ) " +
	                " OR ( TBCABINETCLASS.TransDelayFlag='1' And TBCABINETCLASS.ExTransYear<EXTRACT(YEAR FROM SYSDATE - (INTERVAL '1' YEAR)) ) " +
	                " ) ) And TBCABINETCLASS.KeepingPlace='1' And DocTransferFlag='0'";
	
	    }
		
		return strSQL;
	}

	public String getLVFieldInfo(String listType, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_LISTTYPE", listType);
		map.put("v_LANGTYPE", lang);
		
		List<ApprGListInfoVO> apprGListInfoVOList = ezApprovalGDAO.getLVFieldInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListInfoVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListInfoVOList.get(i)));
		}
		sb.append("</DATA>");

		return sb.toString();
	}

	public String getListInfo(String typeCode, String companyID, String lang) throws Exception{
		StringBuilder strSQL = new StringBuilder();
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_LISTTYPE", typeCode);
		map.put("v_LANGTYPE", lang);
		
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
	public String getListTypeCode(String listFlag, String listType) {
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
            typeCode = messageSource.getMessage("ezApprovalG.t96", new Locale(globals.getProperty("Globals.language")));
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

	public String convWebToPath(String href, String dirPath) throws Exception{
		String tempPath = href.toLowerCase();
		tempPath = tempPath.replace("/files/upload_approvalg/", dirPath);
		
		return tempPath;
	}

	public String makeTaskListXmlAll(Document docXML, String companyID, String langType) throws Exception{
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("097", companyID, langType);
		
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
			if (langType.equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPeriodString(makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()), companyID, langType) + "</VALUE>");
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

	public String getRecordTypeString(String code, String companyID, String langType) throws Exception{
		return getCabinetCode2Name("000", code, companyID, langType);
	}

	public String getAccountingYear(String todayTime, String companyID, String langType) throws Exception{
		String accountYear = todayTime.substring(0, 4);
		int month = 0;
		String accountLastMonth = getCode2Name("A30", "003", companyID, langType);
		
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
	public String makeTaskListXml(Document docXML, String companyID, String strType) throws Exception{
		StringBuffer resultXML = new StringBuffer();
		String listString = "";
		
		listString = getListHeader("097", companyID, strType);
		
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
			if (strType.equals("1")) {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME").item(k).getTextContent()) + "</VALUE>");
			} else {
				resultXML.append("<VALUE>" + makeListField(docXML.getElementsByTagName("TASKNAME2").item(k).getTextContent()) + "</VALUE>");
			}
			resultXML.append("</CELL>");
			resultXML.append("<CELL>");
			resultXML.append("<VALUE>" + getKeepPeriodString(makeListField(docXML.getElementsByTagName("KEEPINGPERIOD").item(k).getTextContent()), companyID, strType) + "</VALUE>");
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
	public String doSusinHesong(String docID, String receiveSN, String deptID, String docState, String userID, String userName, String userName2, String dirPath, String companyID, String lang)
			throws Exception {
		StringBuilder strSQL = new StringBuilder();
		
		String subSQL = "";
		boolean rtnVal = true;
		String hesongType = getCode2Name("A25", "001", companyID, lang);
		String orgDocID = "";
		String orgCompanyID = "";
		
		if (hesongType.trim().equals("") || hesongType.trim().equals("0") || receiveSN.equals("1")) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			
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
				
				String fileName = ezApprovalGDAO.getDocInfoHref(map1);
				String extFileName = getExtendedFileName(fileName);
				String fileURL = dirPath + commonUtil.separator + fileName.replace(config.getProperty("upload_approvalG.ROOT") + commonUtil.separator, "");
				
				File file = new File(dirPath + companyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID));
				
				if (!file.exists()) {
					copyFile(fileURL, dirPath + orgCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID) + commonUtil.separator + docID + "." + extFileName,
							dirPath + orgCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(docID));
				}
				
				if (companyID.toUpperCase().equals(orgCompanyID.toUpperCase())) {
					strSQL.append("UPDATE TBAPRRECEIPTPROCESSINFO SET AprState = '" + staASWheSong);
					strSQL.append("', ProcessYN = 'Y', ProcessDate = SYSDATE");
					strSQL.append(" WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N';\n");
					
					int pSN = Integer.parseInt(receiveSN) + 1;
					
					strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
					strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
					strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
					strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT '" + pSN);
					strSQL.append("', DocID, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, '");
					strSQL.append(makeListField(signXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent()) + "', N'");
					strSQL.append(makeListField(signXML.getElementsByTagName("WRITERDEPTNAME").item(0).getTextContent()) + "', N'");
					strSQL.append(makeListField(signXML.getElementsByTagName("WRITERDEPTNAME2").item(0).getTextContent()));
					strSQL.append("', DocState, '" + staASWheSong + "', SYSDATE" );
					strSQL.append(", 'N', '', '', '', '', '', '', DocID FROM TBAPRRECEIPTPROCESSINFO " + " WHERE ROWNUM <= 1 AND DocID = '");
					strSQL.append(docID + "' AND ReceiveSN = '" + receiveSN + "' order by ProcessDate desc;\n");
				} else {
					strSQL.append("UPDATE TBAPRRECEIPTPROCESSINFO SET AprState = '" + staASWheSong);
					strSQL.append("', ProcessYN = 'Y', ProcessDate = SYSDATE");
					strSQL.append(" WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N'\n");
					
					subSQL = doSendHesongDoc(docID, dirPath, companyID, orgCompanyID);
					
					if (subSQL.toUpperCase().equals("FALSE")) {
						rtnVal = false;
					} else {
						strSQL.append(subSQL);
					}
				}
				
				strSQL.append("Delete TBEXPAPRLINE where DocID = '" + docID + "';\n");
				strSQL.append("Delete TBAPRLINEINFO where DocID = '" + docID + "';\n");
				
				subSQL = updateSusinResult(orgDocID, deptID, userID, "H", userName, userName2, orgCompanyID);
				
				if (subSQL == null || subSQL.equals("")) {
					rtnVal= false;
				} else {
					strSQL.append(subSQL);
				}
				
				if (rtnVal) {
					sendRecvMsg(makeListField(signXML.getElementsByTagName("WRITERDEPTID").item(0).getTextContent()), orgDocID, "HESONG", orgCompanyID, lang);
				}
			} else {
				rtnVal = false;
			}
		} else {
			strSQL.append("UPDATE TBAPRRECEIPTPROCESSINFO SET AprState = '" + staASWheSong);
			strSQL.append("', ProcessYN = 'Y', ProcessDate = SYSDATE");
			strSQL.append(" WHERE DocID = '" + docID + "' AND ReceiveSN = '" + receiveSN + "' AND ProcessYN = 'N'\n");
			
            int pSN = Integer.parseInt(receiveSN) + 1;

            strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, SentDeptID, ");
            strSQL.append("SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, AprState, ");
            strSQL.append("ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT '" + pSN);
            strSQL.append("', DocID, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, SentDeptID, SentDeptName, SentDeptName2, DocState, '");
			strSQL.append(staASWheSong + "', SYSDATE");
            strSQL.append(", 'N', '', '', '', '', '', '', DocID FROM TBAPRRECEIPTPROCESSINFO " + "WHERE ROWNUM <= 1 AND DocID = '");
			strSQL.append(docID + "' AND ReceiveSN = '" + receiveSN + "' order by ProcessDate desc;\n");

			strSQL.append("Delete TBEXPAPRLINE where DocID = '" + docID + "';\n");
            strSQL.append("Delete TBAPRLINEINFO where DocID = '" + docID + "';\n");
            
            subSQL = updateSusinResult(orgDocID, deptID, userID, "H", userName, userName2, orgCompanyID);
            
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
        		
        		String sentDeptID = ezApprovalGDAO.doSusinHesongSentDeptID(map);
        		
        		sendRecvMsg(sentDeptID, docID, "HESONG", orgCompanyID, lang);
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
	public String getAprType_AprState(String docID, String userID, String companyID) throws Exception {
		String sbVal = "NO/NO";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_PDOCID", docID);
		map.put("v_PUSERID", userID);
		
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
	public String doCallBack(String docID, String userID, String companyID) throws Exception {
		String rtnXML = getCallBackYN(docID, userID, companyID);
		boolean rtnVal = true;
		
		if (!rtnXML.equals("<RESULT>CALLBACK</RESULT>") && !rtnXML.equals("<RESULT>CANCEL</RESULT>")) {
			rtnVal = false;
		}
		
		if (rtnVal) {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("companyID", companyID);
			map.put("v_DOCID", docID);
			map.put("v_USERID", userID);
			
			try {
				ezApprovalGDAO.doCallBack(map);
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
	public String getFormConnFlag(String docID, String companyID) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		
		String strResult = ezApprovalGDAO.getFormConnFlag(map);
		
		resultXML.append("<RESULT>");
		
		if (strResult != null && !strResult.equals("")) {
			resultXML.append(strResult);
		}
		resultXML.append("</RESULT>");
		
		return resultXML.toString();
	}

	@Override
	public String getInnerLineInfo(String docID, String deptID, String docState, String companyID) throws Exception {
		String rtnXML = "";
		String rtnDocID = "";
		String rtnDocFlag = "";
		String rtnGDocID = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_DOCSTATE", docState);
		map.put("v_DEPTID", deptID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getInnerLineInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		Document docXML = commonUtil.convertStringToDocument(sb.toString());
		
		if (docXML.getElementsByTagName("DOCID").item(0) != null) {
			docXML.getElementsByTagName("DOCID").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("FLAG").item(0) != null) {
			docXML.getElementsByTagName("FLAG").item(0).getTextContent();
		}
		
		if (docXML.getElementsByTagName("GDOCID").item(0) != null) {
			docXML.getElementsByTagName("GDOCID").item(0).getTextContent();
		}
		
		rtnXML = "<RESULT><DOCID>" + rtnDocID + "</DOCID><FLAG>" + rtnDocFlag + "</FLAG><GDOCID>" + rtnGDocID + "</GDOCID></RESULT>"; 
		
		return rtnXML;
	}

	@Override
	public String getSearchDocList(String containerID, String userID, String subQuery, String docNumber, String docTitle, String drafter, String formID, String draftFromYEAR, String draftFromMONTH,
			String draftFromDAY, String draftToYEAR, String draftToMONTH, String draftToDAY, String apprFromYEAR, String apprFromMONTH, String apprFromDAY, String apprToYEAR, String apprToMONTH,
			String apprToDAY, String myApprFromYEAR, String myApprFromMONTH, String myApprFromDAY, String myApprToYEAR, String myApprToMONTH, String myApprToDAY, String draftDeptName,
			String docState, String aprFlag, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String lang, String approvUser) throws Exception {
		StringBuilder resultXML = new StringBuilder();
		String orderOption1 = "";
		String orderOption2 = "";
		boolean publicFlag = false;
		boolean securityFlag = false;
		String userSecurityCode = "";
		
		if (getIsUse("A22", "001", companyID, lang).equals("1")) {
			securityFlag = true;
		}
		
		if (getIsUse("A22", "004", companyID, lang).equals("1")) {
			publicFlag = true;
		}
		
		if (securityFlag) {
			userSecurityCode = ezOrganService.getPropertyValue(userID, "extensionAttribute6");
		}
		
		if (userSecurityCode == null || userSecurityCode.equals("")) {
			userSecurityCode = "0";
		}
		
		String listString = "";
		
		if (containerID.equals("ADMIN")) {
			listString = getListHeader("082", companyID, lang);
		} else {
			listString = getListHeader("006", companyID, lang);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		String tmpStartDate1 = makeDate(draftFromYEAR, draftFromMONTH, draftFromDAY, true).trim();
		String tmpStartDate2 = makeDate(draftToYEAR, draftToMONTH, draftToDAY, true).trim();
		String tmpEndDate1 = makeDate(apprFromYEAR, apprFromMONTH, apprFromDAY, true).trim();
		String tmpEndDate2 = makeDate(apprToYEAR, apprToMONTH, apprToDAY, true).trim();
		String tmpProcessDate1 = makeDate(myApprFromYEAR, myApprFromMONTH, myApprFromDAY, true).trim();
		String tmpProcessDate2 = makeDate(myApprToYEAR, myApprToMONTH, myApprToDAY, true).trim();
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getSearchDocListCount(containerID, userID, userSecurityCode, publicFlag, subQuery, docNumber, docTitle, drafter, draftDeptName, formID, tmpStartDate1, tmpStartDate2, tmpEndDate1, tmpEndDate2,
				tmpProcessDate1, tmpProcessDate2, aprFlag, docState, commonUtil.getMultiData(lang), approvUser, companyID);
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
				tmpProcessDate1, tmpProcessDate2, aprFlag, docState, querySize, querySize2, orderOption1, orderOption2, commonUtil.getMultiData(lang), approvUser, companyID);
		
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
					fieldName = fieldName + commonUtil.getMultiData(lang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, lang) + "</VALUE>");
				
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

	private String getSearchDocList(String containerID, String userID, String userSecurityCode, boolean publicFlag, String subQuery, String docNumber, String docTitle, String drafter,
			String draftDeptName, String formID, String tmpStartDate1, String tmpStartDate2, String tmpEndDate1, String tmpEndDate2, String tmpProcessDate1, String tmpProcessDate2, String aprFlag,
			String docState, int querySize, int querySize2, String orderOption1, String orderOption2, String langType, String approvUser, String companyID) throws Exception{
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
		map.put("iv_APRFLAG", aprFlag);
		map.put("v_DOCSTATE", docState.trim());
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("v_ORDEROPTION2", orderOption2);
		map.put("v_LANGTYPE", langType);
		map.put("v_APPROVUSER", approvUser.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		
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
			String docState, String langType, String approvUser, String companyID) throws Exception{
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
		map.put("iv_APRFLAG", aprFlag);
		map.put("v_DOCSTATE", docState.trim());
		map.put("v_LANGTYPE", langType);
		map.put("v_APPROVUSER", approvUser.trim().replace("[", "[[]").replace("%", "[%]").replace("_", "[_]"));
		
		int resultCnt = ezApprovalGDAO.getSearchDocListCount(map);
		
		return resultCnt;
	}

	private String makeDate(String year, String month, String day, boolean startFlag) throws Exception{
		String rtnVal = "";
		
		if (!year.trim().equals("") && !month.trim().equals("") && !day.trim().equals("")) {
			rtnVal = year.trim() + "-" + month.trim() + "-" + day.trim();
			
			if (startFlag) {
				rtnVal += " 00:00:00";
			} else {
				rtnVal += " 23:59:59";
			}
		}
		
		return rtnVal;
	}

	private String doSendHesongDoc(String docID, String dirPath, String companyID, String orgCompanyID) throws Exception{
		// TODO 테스트를 꼮 해봐야함
		StringBuilder strSQL = new StringBuilder();
		
		String newID = getNewID(orgCompanyID);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_DOCID", docID);
		map.put("v_FLAG", "APR");
		
		String fileName = ezApprovalGDAO.getDocInfoHref(map);
		String extFileName = getExtendedFileName(fileName);
		String url = config.getProperty("upload_approvalG.ROOT") + commonUtil.separator + orgCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" +
				commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName;
		String fileURL = dirPath + commonUtil.separator + fileName.replace(config.getProperty("upload_approvalG.ROOT") + commonUtil.separator, "");
		
		boolean rtnVal = copyFile(fileURL, dirPath + orgCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" +
				commonUtil.separator + getDocDir(newID) + commonUtil.separator + newID + "." + extFileName, dirPath + orgCompanyID + commonUtil.separator + "Doc" + commonUtil.separator + 
				EgovDateUtil.getTodayTime().substring(0, 4) + commonUtil.separator + "1000" + commonUtil.separator + getDocDir(newID));
		
		if (rtnVal) {
			strSQL.append("INSERT INTO TBAPRDOCINFO (DocID, FormID, OrgDocID, DocType, ");
			strSQL.append("DocState, FunctionType, Href, DocTitle, DocNo, HasAttachYN, HasOpinionYN, StartDate, ");
            strSQL.append("EndDate, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, WriterDeptID, WriterDeptName, WriterDeptName2, ");
			strSQL.append("isPublic) SELECT '" + newID + "', FormID, OrgDocID, DocType, DocState, '");
			strSQL.append(staASWheSong + "', '" + url + "', DocTitle, DocNo, HasAttachYN, HasOpinionYN, SYSDATE");
            strSQL.append(", NULL, WriterID, WriterName, WriterName2, WriterJobTitle, WriterJobTitle2, ");
            strSQL.append("WriterDeptID, WriterDeptName, WriterDeptName2, isPublic FROM TBAPRDOCINFO  WHERE DocID = '" + docID + "';\n");

			// 수정(2005.09.29) : 보안결재 필드 추가
			strSQL.append("INSERT INTO TBEXPAPRDOCINFO (DocID, SecurityCode, StoragePeriod, ");
            strSQL.append("KeyWord, FormName, FormName2, companyID, ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval) ");
            strSQL.append("SELECT '" + newID + "', SecurityCode, storagePeriod, KeyWord, FormName, FormName2, companyID, ");
            strSQL.append("ItemCode, ItemName, UrgentApproval, TempAttribute, SpecialRecordCode, PublicityCode, LimitRange, PageNum,  CabinetID, TaskCode, DocNumCode, OrgDocNumCode, SeperateAttachXML, Summary, SecurityApproval FROM TBEXPAPRDOCINFO  ");
			strSQL.append("WHERE DocID = '" + docID + "' ;\n");

			strSQL.append("INSERT INTO TBAPRATTACHINFO (DocID, AttachFileSN, ");
            strSQL.append("AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach) SELECT '" + newID);
            strSQL.append("', AttachFileSN, AttachFileName, AttachFileHref, AttachFileSize, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2, PageNum, DisplayName, BodyAttach FROM ");
            strSQL.append("TBAPRATTACHINFO  WHERE DocID = '" + docID + "';\n");

			strSQL.append("INSERT INTO TBAPRDOCATTACHINFO (DocID, AttachSN, ");
            strSQL.append("AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, AttachUserName, AttachUserName2, ");
            strSQL.append("AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2) SELECT '" + newID);
			strSQL.append("', AttachSN, AttachDocName, AttachDocURL, SubAttachYN, AttachUserID, ");
            strSQL.append("AttachUserName, AttachUserName2, AttachUserJobTitle, AttachUserJobTitle2, AttachUserDeptID, AttachUserDeptName, AttachUserDeptName2 FROM ");
            strSQL.append("TBAPRDOCATTACHINFO  WHERE DocID = '" + docID + "';\n");

			strSQL.append("INSERT INTO TBAPROPINIONINFO (DocID, UserID, OpinionGB, Content, ");
            strSQL.append("UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, UserDeptName, UserDeptName2, OpinionSN) SELECT '");
            strSQL.append(newID + "', UserID, OpinionGB, Content, UserName, UserName2, UserJobTitle, UserJobTitle2, UserDeptID, ");
            strSQL.append("UserDeptName, UserDeptName2, OpinionSN FROM TBAPROPINIONINFO  WHERE DocID = '" + docID + "';\n");
            // 2010.08.03 다국어
			strSQL.append("INSERT INTO TBAPRRECEIPTPROCESSINFO (ReceiveSN, DocID, ");
            strSQL.append("SentDeptID, SentDeptName, SentDeptName2, ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, DocState, ");
            strSQL.append("AprState, ProcessDate, ProcessYN, ProcessDocID, ProcessorID, ProcessorName, ProcessorName2, ");
            strSQL.append("ProcessorJobTitle, ProcessorJobTitle2, ParentsDocID) SELECT '1', '" + newID);
            strSQL.append("', ReceivedDeptID, ReceivedDeptName, ReceivedDeptName2, SentDeptID, SentDeptName, SentDeptName2, DocState, '");
            strSQL.append(staASWheSong + "', SYSDATE, 'N', '', '','', '', '', '', DocID ");
            strSQL.append("FROM TBAPRRECEIPTPROCESSINFO  WHERE DocID = '" + docID + "' AND ReceiveSN = '1';\n");
		}
		
		if (rtnVal) {
			return strSQL.toString();
		} else {
			return "FALSE";
		}
	}

	public String getKeepPeriodString(String code, String companyID, String strType) throws Exception{
		return getCabinetCode2Name("004", code, companyID, strType);
	}
	
	public String getKeepMethodString(String code, String companyID, String strType) throws Exception{
		return getCabinetCode2Name("001", code, companyID, strType);
	}
	
	public String getKeepPlaceString(String code, String companyID, String strType) throws Exception{
		return getCabinetCode2Name("002", code, companyID, strType);
	}

	public String getCabinetCode2Name(String codeType, String code, String companyID, String strType) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_CODETYPE", codeType);
		map.put("v_CODE", code);
		map.put("v_LANGTYPE", strType);
		
		String result = ezApprovalGDAO.getCabinetCode2Name(map);
		
		return result;
	}

	public String getReceiptTempletSN(String strFormID, String strUserID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", strFormID);
		map.put("v_USERID", strUserID);
		
		int receiptSN = ezApprovalGDAO.getReceiptTempletSN(map);
		
		receiptSN += 1;
		
		return String.valueOf(receiptSN);
	}

	public String addToAprLineDB(String formID, String userID, String aprSN, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_APRLINESN", aprSN);
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

	public int getLineTempletSN(String strFormID, String strUserID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("v_FORMID", strFormID);
		map.put("v_USERID", strUserID);
		
		int receiptSN = ezApprovalGDAO.getLineTempletSN(map);
		
		return receiptSN;
	}

	public String getNewID(String companyID) throws Exception{
		String rtnVal = "";
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		
		rtnVal = ezApprovalGDAO.aprGetNewID(map);
		rtnVal = String.format("%020d", Integer.parseInt(rtnVal.trim()));
		
		return rtnVal;
	}

	public String getFormRecvAprDB(String formID, String userID, String flag, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMID", formID);
		map.put("v_USERID", userID);
		map.put("v_FLAG", flag);
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

	public String deleteReceiptInfo(String strDocID, String companyID) {
		try {
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("v_DOCID", strDocID);
			map.put("companyID", companyID);
			
			ezApprovalGDAO.deleteReceiptInfo(map);
			
			return "<RESULT>TRUE</RESULT>";
		} catch (Exception e) {
			return "<RESULT>FALSE</RESULT>";
		}
	}

	public int getCountChildFormCont(String id, String deptID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PID", id);
		map.put("v_PDEPTID", deptID);
		map.put("companyID", companyID);
		
		return ezApprovalGDAO.getCountChildFormCont(map);
	}

	public String getFormInfoDB(String formContID, String userID, String kind, String strMultiData, String searchType, String searchName, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", formContID);
		map.put("v_USERID", userID);
		map.put("v_FORMKIND", kind);
		map.put("v_LANGTYPE", strMultiData);
		map.put("v_SEARCHTYPE", searchType);
		map.put("v_SEARCHNAME", searchName);
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

	public String getWebPartList(String listType, String userID, String deptID, String userIDs, String deptIDs, String userFlag, String listCount, String basicOrder, String lang, String companyID) throws Exception{
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

	public String getLeftDocCount(String userID, String deptID, String userIDs, String deptIDs, String userFlag, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERIDS", userIDs);
		map.put("v_DEPTIDS", deptIDs);
		map.put("v_USERFLAG", userFlag);
		map.put("companyID", companyID);
		
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

	public int getWebPartListCount(String listType, String userID, String deptID, String userIDs, String deptIDs, String userFlag, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_DEPTID", deptID);
		map.put("v_USERIDS", userIDs);
		map.put("v_DEPTIDS", deptIDs);
		map.put("v_USERFLAG", userFlag);
		map.put("companyID", companyID);
		
		return ezApprovalGDAO.getWebPartListCount(map);
	}

	public String getDocManageDeptInfo(String deptID) throws Exception{
		StringBuilder rtnVal = new StringBuilder();
		String deptInfo = ezOrganService.getPropertyValue(deptID, "extensionAttribute4");
		
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

	public String getOpinionInfo(String docID, String mode, String orderOption1, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("companyID", companyID);
		
		List<ApprGOpinionVO> apprGAprLineVOList = ezApprovalGDAO.getOpinionInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getReceiptInfo(String docID, String mode, String orderOption1, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", mode);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("companyID", companyID);
		
		List<ApprGReceiptVO> apprGAprLineVOList = ezApprovalGDAO.getReceiptInfo(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public String getAttachInfoDB(String docID, String flag, String strLang, String strLangFile, String strLangDocument, String orderOption1, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_MODE", flag);
		map.put("v_STRLANG", strLang);
		map.put("v_LANGFILE", strLangFile);
		map.put("v_LANGDOCUMENT", strLangDocument);
		map.put("v_ORDERBY", orderOption1);
		map.put("companyID", companyID);
		
		List<ApprGAttachInfoVO> apprGAprLineVOList = ezApprovalGDAO.getAttachInfoDB(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGAprLineVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGAprLineVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	@Override
	public String aprDocList(String listType, String userID, String deptID, String pageSize, String pageNum, String orderCell, String orderOption, String companyID, String userLang, String searchQuery, Document dueryData) throws Exception {
		String orderOption1 = "";
		String orderOption2 = "";
		String userIDs = "'" + makeRightField(userID) + "'";
		String proxyOption = getIsUse("A23", "001", companyID, userLang);
		StringBuffer resultXML = new StringBuffer();
		
		if (proxyOption.equals("1")) {
			userIDs = getProxyUser(userID, userLang);
		}
		
		String basicOrder = getCode2Name("A18", "001", companyID, userLang);
		String basicOrderReverse = "desc";
		
		if (basicOrder.toLowerCase().equals("desc")) {
			basicOrderReverse = "";
		} else {
			basicOrder = "";
		}
		
		String listString = "";
		
		if (listType.equals("1")) {
			//결재할 문서
			listString = getListHeader("001", companyID, userLang);
		} else if (listType.equals("2")) {
			//기안한 문서
			listString = getListHeader("002", companyID, userLang);
		} else if (listType.equals("3")) {
			//결재진행 문서
			listString = getListHeader("003", companyID, userLang);
		} else if (listType.equals("21")) {
			//서버저장 문서
			listString = getListHeader("009", companyID, userLang);
		} else {
			listString = getListHeader("001", companyID, userLang);
		}
		
		Document listXML = commonUtil.convertStringToDocument(listString);
		
		int hlength = listXML.getElementsByTagName("NAME").getLength();
		int totalCount = getAprDocListCount(listType, userID, userIDs, searchQuery, dueryData, companyID);
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
		
		String docList = getAprDocList(listType, userID, userIDs, querySize, querySize2, orderOption1, orderOption2, basicOrder, basicOrderReverse, searchQuery, dueryData, companyID);
		
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
					fieldName = fieldName + commonUtil.getMultiData(userLang);
				}
				fieldValue = docXML.getElementsByTagName(fieldName).item(k).getTextContent();
				resultXML.append("<VALUE>" + getListField(fieldName, fieldValue, companyID, userLang) + "</VALUE>");
				
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
						resultXML.append("<DATA9>" + getAprDocListReceiveSN(docXML.getElementsByTagName("DOCID").item(k).getTextContent(), docXML.getElementsByTagName("APRMEMBERDEPTID").item(k).getTextContent(), companyID) + "</DATA9>");
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
		
		return resultXML.toString();
	}

	public String getAprDocListReceiveSN(String docID, String receivedDeptID, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_RECEIVEDDEPTID", receivedDeptID);
		map.put("companyID", companyID);
		return ezApprovalGDAO.getAprDocListReceiveSN(map);
	}

	public String getListField(String fieldName, String fieldValue, String companyID, String userLang) throws Exception{
		String rtnVal = "";
		
		switch (fieldName) {
			case "DOCTYPE" : 
				rtnVal = getCode2Name("A01", fieldValue, companyID, userLang);
				break;

			case "DOCSTATE" :
                rtnVal = getCode2Name("A02", fieldValue, companyID, userLang);
				break;

			case "APRTYPE" :
                rtnVal = getCode2Name("A03", fieldValue, companyID, userLang);
				break;

			case "APRSTATE" :
                rtnVal = getCode2Name("A04", fieldValue, companyID, userLang);
				break;

			case "FUNCTIONTYPE" :
                rtnVal = getCode2Name("A04", fieldValue, companyID, userLang);
				break;

			case "PROCESSYN" :
                rtnVal = getStatusName(fieldValue, companyID, userLang);
				break;

			case "OPINIONGB" :
                rtnVal = getCode2Name("A17", fieldValue, companyID, userLang);
				break;

			case "ATTACHFILESIZE" :
				rtnVal = fieldValue + " bytes";
				break;

			default : 
                if(fieldName.indexOf("DATE") > -1) {
                	fieldValue = convertDate(fieldValue);
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

	public String convertDate(String date) {
		if (date.trim().equals("")) {
			return date;
		}
		
		return date.substring(0, 19);
	}

	public String getStatusName(String fieldValue, String companyID, String userLang) throws Exception{
		return getCode2Name("A60", fieldValue.toUpperCase(), companyID, userLang);
	}

	public String getAprDocList(String listType, String userID, String userIDs, int querySize, int querySize2, String orderOption1, String orderOption2, String basicOrder, String basicOrderReverse, String subQuery, Document dueryData, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_USERIDS", userIDs);
		map.put("v_PAGESIZE", querySize);
		map.put("v_PAGESIZE2", querySize2);
		map.put("v_ORDEROPTION", orderOption1);
		map.put("iv_ORDEROPTION2", orderOption2);
		map.put("v_BASICORDER", basicOrder);
		map.put("v_BASICORDER2", basicOrderReverse);
		map.put("v_SPSUBQUERY", subQuery.trim());
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
		
		List<ApprGDocListVO> apprGDocListVOList = ezApprovalGDAO.getAprDocList(map);
		
		StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGDocListVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGDocListVOList.get(i)));
		}
		sb.append("</DATA>");
		
		return sb.toString();
	}

	public int getAprDocListCount(String listType, String userID, String userIDs, String searchQuery, Document dueryData, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listType);
		map.put("v_USERID", userID);
		map.put("v_USERIDS", userIDs);
		map.put("v_SPSUBQUERY", searchQuery.trim());
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
		
		return ezApprovalGDAO.getAprDocListCount(map);
	}

	@Override
	public String getProxyUser(String userID, String userLang) throws Exception{
		String rtnXML = ezOrganService.getSearchList("LEFT_extensionAttribute5::" + userID + ":", "displayname", "displayname;extensionAttribute5", "user", 50, userLang);
		Document doc = commonUtil.convertStringToDocument(rtnXML);
		int nodeLength = doc.getElementsByTagName("DATA2").getLength();
		boolean chkFirst = false;
		String rtnVal = "";
		String nowDate = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "").substring(0, 16);
		
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
							rtnVal = ", '" + makeRightField(doc.getElementsByTagName("DATA2").item(k).getTextContent()) + "'";
						}
					}
				}
			}
			
			if (!chkFirst) {
				rtnVal = "'" + makeRightField(userID) + "'";
			} else {
				rtnVal = ", '" + makeRightField(userID) + "'";
			}
		} else {
			rtnVal = "'" + makeRightField(userID) + "'";
		}
		
		return rtnVal;
	}

	public String getIsUse(String code1, String code2, String companyID, String userLang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("companyID", companyID);
		return ezApprovalGDAO.getIsUse(map);
	}

	public String makeRightField(String userID) {
		return userID.replace("'", "''").replace("\0", "");
	}

	@Override
	public String getAprLineInfoDB(String docID, String flag, String userID, String formID, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCID", docID);
		map.put("v_FLAG", flag);
		map.put("v_USERID", userID);
		map.put("v_FORMID", formID);
		map.put("companyID", companyID);
		
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
	public Document checkPermission(String docID, String userID, String deptID, String checkMode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PDOCID", docID);
		map.put("v_PAPRUSERID", userID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PMODE", checkMode);
		map.put("companyID", companyID);
		
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

}
