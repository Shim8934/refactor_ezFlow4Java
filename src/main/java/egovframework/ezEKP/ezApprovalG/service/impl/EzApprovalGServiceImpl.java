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
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGLeftVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
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

	public String getCode2Name(String code1, String code2, String companyID, String lang) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		
		return ezApprovalGDAO.getCode2Name(map);
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
		if (orgStr.equals("NULL")) {
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

}
