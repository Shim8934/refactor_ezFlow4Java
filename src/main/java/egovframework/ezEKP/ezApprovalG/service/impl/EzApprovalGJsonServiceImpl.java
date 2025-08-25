package egovframework.ezEKP.ezApprovalG.service.impl;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGAdminDAO;
import egovframework.ezEKP.ezApprovalG.dao.EzApprovalGDAO;
import egovframework.ezEKP.ezApprovalG.service.EzApprovalGJsonService;
import egovframework.ezEKP.ezApprovalG.vo.ApprGAprLineVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGDocListVO;
import egovframework.ezEKP.ezApprovalG.vo.ApprGListHeaderVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzApprovalGJsonService")
public class EzApprovalGJsonServiceImpl extends EzFileMngUtil implements EzApprovalGJsonService{

	@Autowired
	private CommonUtil commonUtil;
	
	@Resource(name = "EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name = "EzApprovalGDAO")
	private EzApprovalGDAO ezApprovalGDAO;
	
	@Resource(name = "EzApprovalGAdminDAO")
	private EzApprovalGAdminDAO ezApprovalGAdminDao;
	
	private static final Logger logger = LoggerFactory.getLogger(EzApprovalGJsonServiceImpl.class);
	
	@Override
	public Map<String, Object> getAprLineInfo(String docID, String userID, String formID, String companyID, String lang, int tenantID, String offset, String reDraftFlag, String isUsed, String beforeDocID, String mode, String docState) throws Exception {
		logger.debug("getAprLineInfo started.");
		logger.debug("docID = " + docID + " || userID = " + userID + " || formID = " + formID + " || reDraftFlag = " + reDraftFlag + " || lang = " + lang + " || offset = " + offset + " docState = " + docState);
		

		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> dataRowMap = new HashMap<String, Object>();
		List<Map<String, Object>> dataList = new ArrayList<>();
		
		String listCode = "013";
		
		String flag = "1";
		
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader Param : v_LISTTYPE="+ listCode + " v_LANGTYPE = " +lang +" companyID = " + companyID + " v_TENANTID =" + tenantID);
		List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(map);
		
		if (mode.equals("CHAMJOAPR")) {
			mode = "APR";
		} else if (mode.equals("CHAMJOEND")){
			mode = "END";
		}
		
		map.put("v_DOCID", docID);
		map.put("v_FLAG", flag);
		map.put("v_USERID", userID);
		map.put("v_FORMID", formID);
		map.put("isUsed", isUsed);
		map.put("beforeDocID", beforeDocID);
		map.put("v_MODE", mode);
		map.put("docState", docState);
		// 진행중인 결재 리스트 추출
		List<ApprGAprLineVO> apprGAprLineVOList = ezApprovalGDAO.getAprLineInfo(map);
		
		int dlength = apprGAprLineVOList.size();
				
		if (isUsed.equals("reuse")) {
			
			flag = "3";
			map.put("v_FLAG", flag);
			// 진행중인 결재 리스트 추출
			apprGAprLineVOList = ezApprovalGDAO.getAprLineInfo(map);
			dlength = apprGAprLineVOList.size();
			
		} else {
			if (dlength == 0) { //dlength가 0인 경우(즉, 처음 시작하는 문서일 때만 LastAprLine 정보 가져오도록 수정
				String isLastAprLine = getCode2Name("A44", "001", companyID, lang, tenantID);

				if (isLastAprLine != null && isLastAprLine.equals("1")) {
					
					flag = "2";
					map.put("v_FLAG", flag);
					
					apprGAprLineVOList = ezApprovalGDAO.getAprLineInfo(map);
					dlength = apprGAprLineVOList.size();
				}
			}
		}
		
		String resetDateFlag = "N";
		String fieldName = "";
		String fieldValue = "";
		String primaryData = commonUtil.getPrimaryData(lang, tenantID);
		
		for (int i = 0; i < apprGAprLineVOList.size(); i++) {

			//다국어 분기를 데이터 매핑 시점으로 바꿀지 고려 필요
			if (!primaryData.equals("1")) {
				apprGAprLineVOList.get(i).setAprMemberName(apprGAprLineVOList.get(i).getAprMemberName2());
				apprGAprLineVOList.get(i).setAprMemberJobTitle(apprGAprLineVOList.get(i).getAprMemberJobTitle2());
				apprGAprLineVOList.get(i).setAprMemberDeptName(apprGAprLineVOList.get(i).getAprMemberDeptName2());
				apprGAprLineVOList.get(i).setProxyUserName(apprGAprLineVOList.get(i).getProxyUserName2());
				apprGAprLineVOList.get(i).setProxyUserJobTitle(apprGAprLineVOList.get(i).getProxyUserJobTitle2());
				apprGAprLineVOList.get(i).setProxyUserDeptName(apprGAprLineVOList.get(i).getProxyUserDeptName2());
			}	
				
			
			Map<String, String> voToMap = BeanUtils.describe(apprGAprLineVOList.get(i));
			
			logger.debug("voToMap: " + voToMap.toString());
			
			for (int j = 0; j < apprGListHeaderVOList.size() ; j++) {
				
				//vo 는 첫번째 문자가 소문자이나 header의 경우 첫번째 문자가 대문자이므로 변환 필요
				dataRowMap.put(apprGListHeaderVOList.get(j).getColName(), voToMap.get(apprGListHeaderVOList.get(j).getColName().substring(0,1).toLowerCase() + apprGListHeaderVOList.get(j).getColName().substring(1)));
				
			}
			
				dataRowMap.put("DATA1", makeListField(convertDate((apprGAprLineVOList.get(i).getProcessDate() == null) ? "" : apprGAprLineVOList.get(i).getProcessDate())));
				dataRowMap.put("DATA2", makeListField(convertDate((apprGAprLineVOList.get(i).getReceivedDate() == null) ? "" : apprGAprLineVOList.get(i).getReceivedDate())));
				dataRowMap.put("DATA3", docID);
				dataRowMap.put("DATA4", makeListField(apprGAprLineVOList.get(i).getAprMemberID()));
				dataRowMap.put("DATA5", apprGAprLineVOList.get(i).getAprMemberIsDeptYN());
				dataRowMap.put("DATA6", makeListField(apprGAprLineVOList.get(i).getAprMemberDeptID()));
				dataRowMap.put("DATA7", makeListField(apprGAprLineVOList.get(i).getReasonDoNotApprov()));
				dataRowMap.put("DATA8", apprGAprLineVOList.get(i).getIsProposerYN());
				dataRowMap.put("DATA9", apprGAprLineVOList.get(i).getIsBriefUserYN());
				dataRowMap.put("DATA10", makeListField(apprGAprLineVOList.get(i).getAprMemberLdapPath()));
				dataRowMap.put("DATA11", makeListField(apprGAprLineVOList.get(i).getAprType()));
				dataRowMap.put("DATA12", makeListField(apprGAprLineVOList.get(i).getAprState()));
				dataRowMap.put("DATA13", makeListField(apprGAprLineVOList.get(i).getAprMemberName()));
				dataRowMap.put("DATA14", makeListField(apprGAprLineVOList.get(i).getAprMemberName2()));
				dataRowMap.put("DATA15", makeListField(apprGAprLineVOList.get(i).getAprMemberDeptName()));
				dataRowMap.put("DATA16", makeListField(apprGAprLineVOList.get(i).getAprMemberDeptName2()));
				dataRowMap.put("DATA17", makeListField(apprGAprLineVOList.get(i).getAprMemberJobTitle()));
				dataRowMap.put("DATA18", makeListField(apprGAprLineVOList.get(i).getAprMemberJobTitle2()));
				dataList.add(dataRowMap);
				
		}
		
		logger.debug("getAprLineInfo ended.");

		resultMap.put("headerList", apprGListHeaderVOList);
		resultMap.put("dataList", dataList);
		
		return resultMap;
	}
	
	@Override
	public Map<String, Object> getAdminSearchDocList(
			String formID,
			String formName,
			String docNumber,
			String docTitle, 
			String drafter, 
			String approvUser, 
			String draftDeptName, 
			String draftfrom, 
			String draftto, 
			String apprfrom,
			String apprto, 
			String pageSize, 
			String pageNum, 
			String orderCell, 
			String orderOption, 
			String companyID,  
			int tenantID, 
			String lang, 
			String offSet, 
			String approvalFlag,
			String keyword,
			String itemcode,
			Locale locale
			) throws Exception {
		
		Map<String, Object> resultMap = new HashMap<String, Object>();
		List<Map<String, Object>> headerList = new ArrayList<>();
		List<Map<String, Object>> dataRowList = new ArrayList<>();
		
		String OrderOption1 = "";
		String OrderOption2 = "";
		String OrderOptionValue = "";
		boolean docAttachFlag = false; //2019-03-28 천성준 - 문서첨부 리스트 검색인지 체크 Flag. true:기안>문서첨부>검색, false:다른리스트들 검색(추후 문서첨부 리스트 재개발되면 지울예정)
		
		 // 수정(2007.06.18) : multidata 기능추가 
		String strMultiData = commonUtil.getMultiData(lang, tenantID);

		List<ApprGListHeaderVO> listVO = new ArrayList<ApprGListHeaderVO>();
		
		// 표준모듈 (2007.05.07) : 다국어
		if (approvalFlag.equals("G")) {
			listVO = getListHeaderVO("082", companyID, lang, tenantID);
		} else {
			listVO = getListHeaderVO("S082", companyID, lang, tenantID);
		}
	
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_DOCNUMBER", docNumber);
		map.put("v_DOCTITLE", docTitle);
		map.put("v_DRAFTER" + strMultiData, drafter);
		map.put("v_DEPTNAME" + strMultiData, draftDeptName);
		map.put("v_FORMID", formID);
		map.put("v_FORMNAME", formName);
		map.put("v_STARTDATE1", draftfrom );
		map.put("v_STARTDATE2", draftto);
		map.put("v_ENDDATE1", apprfrom);
		map.put("v_ENDDATE2", apprto);
		map.put("v_APPROVUSER", approvUser);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		/* 2024-03-20 홍승비 - SQL Injection 제거 > 검색 쿼리를 subQuery 문자열이 아닌 개별 파라미터로 전달 */
		map.put("v_KEYWORD", keyword);
		map.put("v_ITEMCODE", itemcode);

		map.put("approvalFlag", approvalFlag);		
		
		/* 2024-03-20 기준, 해당 메서드의 호출 시 orderCell과 orderOption은 반드시 공백으로 전달됨. 차후 정렬 적용되도록 수정할 가능성이 있어 코드는 유지함. */
		/*
		map.put("v_ORDEROPTION", OrderOption1);
		map.put("v_ORDEROPTIONLENGTH", OrderOption1.length());
		
		if (OrderOption1.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE", OrderOption1.substring(0,OrderOption1.trim().length()).toLowerCase());
		}
		
		map.put("v_ORDEROPTION2", OrderOption2);
		map.put("v_ORDEROPTIONLENGTH2", OrderOption2.length());
		
		if (OrderOption2.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE2", OrderOption2.substring(0,OrderOption2.trim().length()).toLowerCase());
		}
		*/
		
		int totalCount = ezApprovalGAdminDao.getSearchDocListCount(map);
		
		resultMap.put("totalCount", totalCount);
		
		int hlength = listVO.size();
		
		for (int k = 0; k < hlength; k++) {
			// 2019-03-28 천성준 - 기안 > 문서첨부 > 문서리스트에서 보여줄 헤더만 보이게 필요없는건 빼는로직 추가(추후 문서첨부 로직 재개발 예정)
			if (docAttachFlag) {
				String tmpStr = listVO.get(k).getColName();
				if (tmpStr.equals("FORMNAME") || tmpStr.equals("EDMSYN") || tmpStr.equals("DOCSTATENAME") || tmpStr.equals("SENDFLAG") || tmpStr.equals("HASATTACHYN") || tmpStr.equals("ISPUBLIC")) {
					continue;
				}
			}
			
			Map<String, Object> headerMap = new HashMap<String, Object>();
			headerMap.put("name", listVO.get(k).getName());
			headerMap.put("width", listVO.get(k).getWidth());
			headerMap.put("colName", listVO.get(k).getColName());
			
			if (!orderCell.equals("") && orderCell.equals(listVO.get(k).getName())) {
				if (orderOption.equals("")) {
					OrderOption1 = listVO.get(k).getColName() + " ";
					OrderOption2 = listVO.get(k).getColName() + " desc ";
				} else {
					OrderOption1 = listVO.get(k).getColName() + " desc ";
					OrderOption2 = listVO.get(k).getColName() + " ";
				}
				OrderOptionValue = listVO.get(k).getColName();
			}
			
			headerList.add(headerMap);
			
		}
		
		/*
		map.put("v_ORDEROPTION", OrderOption1);
		map.put("v_ORDEROPTIONLENGTH", OrderOption1.length());
		
		if (OrderOption1.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE", OrderOptionValue.toLowerCase());
		}
		map.put("v_ORDEROPTION2", OrderOption2);
		map.put("v_ORDEROPTIONLENGTH2", OrderOption2.length());
		
		if (OrderOption2.length() > 0 ) {
			map.put("v_ORDEROPTIONVALUE2", OrderOptionValue.toLowerCase());
		}
		*/
		
		map.put("v_PAGESIZE2", totalCount - (Integer.parseInt(pageSize)*(Integer.parseInt(pageNum)-1)));
		map.put("v_PAGESIZE", Integer.parseInt(pageSize)*Integer.parseInt(pageNum));
		map.put("v_PAGESIZE3", Integer.parseInt(pageSize) * Integer.parseInt(pageNum) - Integer.parseInt(pageSize));

        map.put("alFlag", "");

		List <ApprGDocListVO> searchDocList = ezApprovalGAdminDao.getSearchDocList(map);
		
		List<Map<String, Object>> searchDocListMap = new ArrayList<Map<String, Object>>();
		
        for (int j = 0; j < searchDocList.size(); j++) {
			
        	Map<String, Object> voToMap = new HashMap<String, Object>();
        	
        	voToMap = convertVoToMap(searchDocList.get(j));

        	searchDocListMap.add(voToMap);
		}

		String FieldName = "";
		String FieldValue = "";
		
		int dlength = searchDocListMap.size();
		
		for (int k = dlength-1; k >=0; k-- ) {
				
			List<Map<String, Object>> dataCellList = new ArrayList<>();
			
			for (int i=0; i<hlength; i++) {
				
				Map<String, Object> dataRowMap = new HashMap<String, Object>();
				
				FieldName = listVO.get(i).getColName().toUpperCase();
				// 2019-03-28 천성준 - 기안 > 문서첨부 > 문서리스트에서 보여줄 데이터만 보이게 필요없는건 빼는로직 추가(추후 문서첨부 로직 재개발 예정)
				if (docAttachFlag) {
					if (FieldName.equals("FORMNAME") || FieldName.equals("EDMSYN") || FieldName.equals("DOCSTATENAME") || FieldName.equals("SENDFLAG") || FieldName.equals("HASATTACHYN") || FieldName.equals("ISPUBLIC")) {
						continue;
					}
				}
				
        		FieldValue = (String) searchDocListMap.get(k).get(FieldName);
 				
        		dataRowMap.put("value", getListField(FieldName, FieldValue, companyID, lang, tenantID, offSet));
			
				if (i == 0) {
					dataRowMap.put("data1", searchDocListMap.get(k).get("DOCID"));
					dataRowMap.put("data2", searchDocListMap.get(k).get("HREF"));
					dataRowMap.put("data3", searchDocListMap.get(k).get("WRITERID"));
					dataRowMap.put("data4", searchDocListMap.get(k).get("CONTAINERID"));
					dataRowMap.put("data5", searchDocListMap.get(k).get("ORGDOCID"));
					dataRowMap.put("data6", searchDocListMap.get(k).get("FORMID"));
					dataRowMap.put("data7", searchDocListMap.get(k).get("DOCSTATENAME"));
					dataRowMap.put("data8", searchDocListMap.get(k).get("ISPUBLIC"));
					dataRowMap.put("data9", searchDocListMap.get(k).get("DOCTYPE"));
					dataRowMap.put("data10", searchDocListMap.get(k).get("SECURITYAPPROVAL"));
					dataRowMap.put("data11", searchDocListMap.get(k).get("EDMSYN"));
					dataRowMap.put("data12", searchDocListMap.get(k).get("DOCSTATE"));
					dataRowMap.put("data99", searchDocListMap.get(k).get("FROMANME"));
					dataRowMap.put("orgcompanyid", searchDocListMap.get(k).get("COMPANYID"));
					dataRowMap.put("hasopinionyn", searchDocListMap.get(k).get("HASOPINIONYN"));
					dataRowMap.put("delflag", searchDocListMap.get(k).get("DELFLAG"));
				}
				
				if (listVO.get(i).getColName().equals("HASATTACHYN")) {
					dataRowMap.put("HASATTACHYN", searchDocListMap.get(k).get("HASATTACHYN"));
				}
				
				if (listVO.get(i).getColName().equals("ISPUBLIC")) {
					dataRowMap.put("ISPUBLIC", searchDocListMap.get(k).get("ISPUBLIC"));
				}
				
				dataCellList.add(dataRowMap);
			}
			
			Map<String, Object> dataCellMap = new HashMap<String, Object>();
			
			dataCellMap.put("cell", dataCellList);
			
			dataRowList.add(dataCellMap);
		}
		
		resultMap.put("headers", headerList);
		resultMap.put("rows", dataRowList);
		
 		return resultMap;
	}
	
	public Map<String, Object> convertVoToMap(Object voObject) throws IllegalArgumentException, IllegalAccessException {
		
		Map<String, Object> result = new HashMap<String, Object>();
		
    	for (Field field : voObject.getClass().getDeclaredFields()) {
    		field.setAccessible(true);
    		Object value = field.get(voObject);
    		result.put(field.getName().toUpperCase(), value);
		}
		
		return result;
		
	}
	
	public String getListHeader(String listCode, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getListHeader started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeader Param : v_LISTTYPE="+ listCode + " v_LANGTYPE = " +lang +" companyID = " + companyID + " v_TENANTID =" + tenantID);
		List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(map);
		
        StringBuffer sb = new StringBuffer();
        sb.append("<DATA>");
        
        for (int i = 0; i < apprGListHeaderVOList.size(); i++) {
			sb.append(commonUtil.getQueryResult(apprGListHeaderVOList.get(i)));
		}
		sb.append("</DATA>");
		logger.debug("getListHeader ended.");

		return sb.toString();
	}
	
	public List<ApprGListHeaderVO> getListHeaderVO(String listCode, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getListHeaderVO started.");
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_LISTTYPE", listCode);
		map.put("v_LANGTYPE", lang);
		map.put("companyID", companyID);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getListHeaderVO Param : v_LISTTYPE="+ listCode + " v_LANGTYPE = " +lang +" companyID = " + companyID + " v_TENANTID =" + tenantID);
		List<ApprGListHeaderVO> apprGListHeaderVOList = ezApprovalGDAO.getListHeader(map);

		logger.debug("getListHeaderVO ended.");

		return apprGListHeaderVOList;
	}
	
	public String getCode2Name(String code1, String code2, String companyID, String lang, int tenantID) throws Exception{
		logger.debug("getCode2Name started.");

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_CODE1", code1);
		map.put("v_CODE2", code2);
		map.put("companyID", companyID);
		map.put("v_LANGTYPE", lang);
		map.put("v_TENANTID", tenantID);
		
		logger.debug("getOptionInfo Param : v_CODE1=" + code1 + " v_CODE2=" + code2 + " v_LANGTYPE=" + lang +" companyID = " + companyID +  " v_TENANTID= " + tenantID);

		String rtnValue = ezApprovalGDAO.getCode2Name(map);
		
		logger.debug("getCode2Name ended.");
		
		return rtnValue;
	}
	
	public String getListField(String fieldName, String fieldValue, String companyID, String userLang, int tenantID, String offSet) throws Exception {
		logger.debug("getListField started");

		String rtnVal = "";
		String approvalFlag = ezCommonService.getTenantConfig("ApprovalFlag", tenantID);
		
		switch (fieldName) {
		case "DOCTYPE" : 
			rtnVal = getCode2Name("A01", fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "DOCSTATE" :
			rtnVal = getCode2Name("A02", fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "APRTYPE" :
			
			if (approvalFlag.equals("G")) {
				rtnVal = getCode2Name("A03", fieldValue, companyID, userLang, tenantID);
			} else {
				rtnVal = getCode2Name("SA03", fieldValue, companyID, userLang, tenantID);
			}
			
			break;
			
		case "APRSTATE" :
			if (approvalFlag.equals("G")) {
				rtnVal = getCode2Name("A04", fieldValue, companyID, userLang, tenantID);
			} else {
				rtnVal = getCode2Name("SA04", fieldValue, companyID, userLang, tenantID);
			}
			
			break;
			
		case "FUNCTIONTYPE" :
			if (approvalFlag.equals("G")) {
				rtnVal = getCode2Name("A04", fieldValue, companyID, userLang, tenantID);
			} else {
				rtnVal = getCode2Name("SA04", fieldValue, companyID, userLang, tenantID);
			}
			
			break;
			
		case "PROCESSYN" :
			rtnVal = getStatusName(fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "OPINIONGB" :
			rtnVal = getCode2Name("A17", fieldValue, companyID, userLang, tenantID);
			
			break;
			
		case "ATTACHFILESIZE" :
			/**
			 * log를 이용한 첨부파일 단위 변환.
			 * cnt값이 0인경우 바이트, 1인경우 KB...
			 * Math.pow를 통해 1024의 cnt승을 구한 뒤 최초 fieldValue를 나누는데 사용.
			 * */
			int cnt = (int) (Math.log10(Double.parseDouble(fieldValue)) / Math.log10(1024));
			String[] unit = {" bytes", " KB", " MB", " GB"};
			
			double filesize = Double.parseDouble(fieldValue) / Math.pow(1024, cnt);
			fieldValue = String.format("%.1f",filesize);
			//rtnVal = fieldValue + " bytes";
			rtnVal = fieldValue + unit[cnt];
			break;
			
		default : 
			if(fieldName.indexOf("DATE") > -1) {
				fieldValue = commonUtil.getDateStringInUTC(convertDate(fieldValue), offSet, false);
			}
			rtnVal = fieldValue;
			break;
		}

		logger.debug("getListField ended");

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
	
	public String getStatusName(String fieldValue, String companyID, String userLang, int tenantID) throws Exception{
		return getCode2Name("A60", fieldValue.toUpperCase(), companyID, userLang, tenantID);
	}

	
	public String listToString(List paramList) {

		String result = "[";
		
		for (Object object : paramList) {
			
			result = result + object.toString();
			
		}
		
		result = result + "]";
		
		return result;
		
	}
	
}
