package egovframework.ezEKP.ezApprovalG.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAttachInfoVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGFormVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGOpinionVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGReceiptVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGWebPartVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("EzApprovalGService")
public class EzApprovalGServiceImpl implements EzApprovalGService {

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzApprovalGDAO")
	private EzApprovalGDAO ezApprovalGDAO;
	
	@Resource(name = "EzOrganService")
	private EzOrganService ezOrganService;
	
	// DocType
	public  String staDTDraftDoc = "001";		// 기안문
	public  String staDTReportDoc = "002";	    // 보고문
	public  String staDTReceiptDoc = "003";		// 수신문
	public  String staDTExcuteDoc = "004";	    // 시행문
	public  String staDTHabyuiDoc = "005";	    // 합의문
	public  String staDTGamsaDoc = "006";		// 감사문
	public  String staDTApplyDoc = "007";		// 신청서

	// DocState
	public  String staDSPumYui = "001";			// 품의
	public  String staDSHyubJo = "002";			// 협조
	public  String staDSGamSa = "003";		    // 감사
	public  String staDSSimSa = "004";		    // 심사
	public  String staDSSuSin = "011";		    // 수신
	public  String staDSHabYui = "012";			// 합의
	public  String staDSSiHang = "013";			// 시행
	public  String staDSGamSaBu = "014";		// 검사부 감사
	public  String staDSGongRam = "015";		// 공람
	public  String staDSHoiRam = "016";			// 회람
	public  String staDSChamJo = "017";			// 참조
	public  String staDSWhokyul = "018";		// 후결
	public  String staDSBalsin = "019";			// 발신
	public  String staDSApply = "020";		    // 신청
	public  String staDSBansong = "031";		// 반송
	public  String StaDSHesong = "032";			// 회송

	// AprType
	public  String staATYilBan = "001";                 // 일반
	public  String staATGyulJe = "001";                 // 결재
	public  String staatwhoakin = "002";                // 확인
	public  String staATAnHam = "003";                  // 결재안함
	public  String staATJunGyul = "004";                // 전결
	public  String staATGamSa = "005";                  // 감사
	public  String staATSimSa = "006";                  // 심사
	public  String staATChamJo = "007";                 // 참조
	public  String staATSoonChaHyubJo = "008";          // 개인순차협조
	public  String staATHapYu = "008";					// 개인 합의
	public  String staATByungRyulHyubJo = "009";		// 개인병렬협조
	public  String staATBuSeuSoonChaHyubJo = "011";		// 부서순차협조
	public  String staATBuSeuByungRyulHyubJo = "012";	// 부서병렬협조
	public  String staATGamSaBu = "013";				// 감사
	public  String staATSuSin = "014";					// 수신
	public  String staATWhokyul = "015";				// 후열
	public  String staATGongram = "017";				// 공람
	public  String staATDekyul = "016";					// 대결
	public  String staATgian = "018";					// 기안
	public  String staATgumto = "019";					// 검토

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
		
		for (int k = dlength - 1; k >= 0; k--) {
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
		
		for (int k = dlength - 1; k >= 0; k--) {
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
		
		for (int k = dlength - 1; k >= 0; k--) {
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
		
		for (int k = dlength - 1; k >= 0; k--) {
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
		
		for (int k = dlength - 1; k >= 0; k--) {
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

	public String getFormInfoDB(String formContID, String userID, String kind, String strMultiData, String searchType, String searchName, String companyID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_FORMCONTID", formContID);
		map.put("v_USERID", userID);
		map.put("v_FORMKIND", kind);
		map.put("v_LANGTYPE", strMultiData);
		map.put("v_SEARCHTYPE", searchType);
		map.put("v_SEARCHNAME", searchName);
		
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
		if (orgStr.equals("NULL") || orgStr == null) {
			return "";
		} else {
			return orgStr;
		}
	}

	public String convertDate(String date) {
		if (date.trim().equals("")) {
			return date;
		}
		
		return EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
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
	public String getAprLineInfo(String docID, String flag, String userID, String formID, String companyID) throws Exception {
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
	public int checkPermission(String docID, String userID, String deptID, String checkMode, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PDOCID", docID);
		map.put("v_PAPRUSERID", userID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PMODE", checkMode);
		map.put("companyID", companyID);
		
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.checkPermission(map);
		
		return apprGAprLineVOList.size();
	}

}
