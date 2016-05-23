package egovframework.ezEKP.ezResource.service.impl;


import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.xml.parsers.DocumentBuilderFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CookieValue;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.dao.EzResourceDAO;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdmSubClsTreeVO;
import egovframework.ezEKP.ezResource.vo.ResGetAdminFlagVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListMainVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListTermVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleListVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;

@Service("EzResourceService")
public class EzResourceServiceImpl implements EzResourceService{
	@Resource(name="EzResourceDAO")
	private EzResourceDAO ezResourceDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Override
	public List<ResGetAdmSubClsTreeVO> getAdmSubClsTree(String parentID,String companyID, String treeType) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		return ezResourceDAO.getAdmSubClsTree(map);
	}

	@Override
	public List<ResGetAdmSubClsTreeVO> getSubClsTree(String parentID, String companyID, String treeType, String pUserID, String comID, String deptID, String userID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ParentID", parentID);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_TreeType", treeType);
		map.put("v_P_USERID", pUserID);
		map.put("v_PCOMID", comID);
		map.put("v_PDEPTID", deptID);
		map.put("v_PUSERID", userID);
		return ezResourceDAO.getSubClsTree(map);
	}
	
	@Override
	public ResGetAdminFlagVO getAdmFlag(String companyID, String resID,String memberID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("companyID", companyID);
		map.put("resID", resID);
		map.put("memberID", memberID);
		return ezResourceDAO.getAdmFlag(map);
	}

	@Override
	public List<ResGetItemListVO> getBrdMainList(String brdID,String companyID, String lang) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_BRD_ID", brdID);
		map.put("v_COMPANY", companyID);
		map.put("v_LANG", lang);
		return ezResourceDAO.getBrdMainList(map);
	}

	@Override
	public List<ResGetScheduleListVO> getScheduleList(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		return ezResourceDAO.getScheduleList(map);
	}

	@Override
	public List<ResGetScheduleListMainVO> getScheduleListMain(String ownerID, String companyID, String startDate, String endDate) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		return ezResourceDAO.getScheduleListMain(map);
	}

	@Override
	public List<ResGetScheduleListVO> getScheduleListRepetiti(String ownerID, String companyID, String startDate, String endDate, String writerName, String writerDept) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		return ezResourceDAO.getScheduleListRepetiti(map);
	}

	@Override
	public List<ResGetScheduleListMainVO> getScheduleListRepetitim( String ownerID, String companyID, String startDate) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_POWNERID", ownerID);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_PSTARTDATE", startDate);
		return ezResourceDAO.getScheduleListRepetitim(map);
	}

	@Override
	public ResGetRepDateTimesVO getRepDateTimes(String ownerID, String companyID, int num) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pNum", num);
		return ezResourceDAO.getRepDateTimes(map);
	}

	@Override
	public ResGetScheduleListTermVO getScheduleListTerm(int num, String companyID, String ownerID, String startDate, String endDate, String writerName, String writerDept) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PNUM", num);
		map.put("v_PCOMPANYID", companyID);
		map.put("v_POWNERID", ownerID);
		map.put("v_PSTARTDATE", startDate);
		map.put("v_PENDDATE", endDate);
		map.put("v_WRITERNAME", writerName);
		map.put("v_WRITERDEPT", writerDept);
		return ezResourceDAO.getScheduleListTerm(map);
	}

	@Override
	public List<ResBrdListVO> getBrdList(int topCnt, int brdID, String CompanyID, String ownDeptNm, String ownerNm, String ownerPosition, String brdNm) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PTOPCNT", topCnt);
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", CompanyID);
		map.put("v_POWNDEPTNM", ownDeptNm);
		map.put("v_POWNERNM", ownerNm);
		map.put("v_POWNERPOSITION", ownerPosition);
		map.put("v_PBRDNM", brdNm);
		return ezResourceDAO.getBrdList(map);
	}

	@Override
	public int getBrdCnt(int brdID, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_PBRDID", brdID);
		map.put("v_PCOMPANYID", companyID);
		return ezResourceDAO.getBrdCnt(map);
	}

	@Override
	public ResBrdVO getBrd(int brdID, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pBrdID", brdID);
		map.put("v_pCompanyID", companyID);
		return ezResourceDAO.getBrd(map);
	}
	
	@Override
	public void delResData(String brdID, String companyID) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_CompanyID", companyID);
		ezResourceDAO.delResData(map);
	}
	
	@Override
	public void modifyResData(String brdID, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
	String brdExplain,String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_Brd_ID", brdID);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_ResLocation", resLocation);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Approve", approve);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_ODeptNm2", deptNm2);
		map.put("v_P_OwnerNm2", ownerNm2);
		map.put("v_P_OwnerPos2", ownerPos2);
		ezResourceDAO.modifyResData(map);
	}
	
	@Override
	public void addResData(String classGB, String deptID, String deptNm, String ownerID, String ownerNm, String ownerPos, String ownerCall, String brdNm, String resLocation,
	String brdExplain, String companyID, String approve, String brdNm2, String deptNm2, String ownerNm2, String ownerPos2) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_P_ClassGB", classGB);
		map.put("v_P_ODeptID", deptID);
		map.put("v_P_ODeptNm", deptNm);
		map.put("v_P_OwnerID", ownerID);
		map.put("v_P_OwnerNm", ownerNm);
		map.put("v_P_OwnerPos", ownerPos);
		map.put("v_P_OwnerCall", ownerCall);
		map.put("v_P_Brd_NM", brdNm);
		map.put("v_P_ResLocation", resLocation);
		map.put("v_P_Brd_Explain", brdExplain);
		map.put("v_P_CompanyID", companyID);
		map.put("v_P_Approve", approve);
		map.put("v_P_Brd_NM2", brdNm2);
		map.put("v_P_ODeptNm2", deptNm2);
		map.put("v_P_OwnerNm2", ownerNm2);
		map.put("v_P_OwnerPos2", ownerPos2);
		ezResourceDAO.addResData(map);
		
	}
	
	@Override
	public void updateScheduleDateTime(int num, String ownerID, String companyID, String startDate, String endDate) throws Exception {
		Map<String,Object> map = new HashMap<String, Object>();
		map.put("v_pNum", num);
		map.put("v_pOwnerID", ownerID);
		map.put("v_pCompanyID", companyID);
		map.put("v_pStartDate", startDate);
		map.put("v_pEndDate", endDate);
		ezResourceDAO.updateScheduleDateTime(map);
	}

	@SuppressWarnings("deprecation")
	public String getScheduleXML(String xmlStr, String ownerID, String companyID, String groupID, String gubun, String pType, String pWriterName, String pWriterDept) throws Exception {
		StringBuilder returnStr = new StringBuilder();
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			String sDate = xmlRes.getElementsByTagName("STARTDATETIME").item(0).getTextContent().trim();
			String eDate = xmlRes.getElementsByTagName("ENDDATETIME").item(0).getTextContent().trim();
			String app = xmlRes.getElementsByTagName("APP").item(0).getTextContent().trim();
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			String scheRs = getScheduleList(ownerID, companyID, groupID, gubun, sDate, eDate, pType, pWriterName, pWriterDept);
			Document scheRSDom = commonUtil.convertStringToDocument(scheRs);

			returnStr.append("<root>");
			
			for (int i=0; i<scheRSDom.getElementsByTagName("ROW").getLength(); i++) {
				String num = scheRSDom.getElementsByTagName("num").item(i).getTextContent();
				String pNum = scheRSDom.getElementsByTagName("pnum").item(i).getTextContent();
				String ownerIDStr = scheRSDom.getElementsByTagName("ownerID").item(i).getTextContent();
				String writerIDStr = scheRSDom.getElementsByTagName("writerID").item(i).getTextContent();
				String title = scheRSDom.getElementsByTagName("title").item(i).getTextContent();
				String loc = scheRSDom.getElementsByTagName("location").item(i).getTextContent();
				String startDateTime = scheRSDom.getElementsByTagName("startDate").item(i).getTextContent();
				String endDateTime = scheRSDom.getElementsByTagName("endDate").item(i).getTextContent();
				String reFlag = scheRSDom.getElementsByTagName("reFlag").item(i).getTextContent();
				String gresFlag = scheRSDom.getElementsByTagName("gresFlag").item(i).getTextContent();
				String allDay = scheRSDom.getElementsByTagName("allDay").item(i).getTextContent();
				String writeDay = scheRSDom.getElementsByTagName("writeDay").item(i).getTextContent();
				String jobTitle = "";
				String jobTitle2 = "";
				
				if (pType.equals("") || pType == null) {
					 jobTitle = scheRSDom.getElementsByTagName("jobtitle").item(i).getTextContent();
					 jobTitle2 = scheRSDom.getElementsByTagName("jobtitle2").item(i).getTextContent();
				}
				if (app.equals("0")) {
					returnStr.append("<appointment>");
					
					returnStr.append("<dtstart>"+EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtstart>");
					returnStr.append("<dtend>"+EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtend>");
					returnStr.append("<alldayevent>"+allDay+"</alldayevent>");
					
					String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent(); 
					if (timeDisplay.equals("1")) {
						timeDisplay = "Busy";
					} else if (timeDisplay.equals("2")) {
						timeDisplay = "Tentative";
					} else if (timeDisplay.equals("3")) {
						timeDisplay = "OOF";
					} else if (timeDisplay.equals("4")) {
						timeDisplay = "Free";
					} else {
						timeDisplay = "";
					}
					returnStr.append("<busystatus>"+timeDisplay+"</busystatus>");
					returnStr.append("</appointment>");
				} else {
					returnStr.append("<appointment>");
					returnStr.append("<number>" + num + "</number>");
					
					if (pNum.equals("Null") || pNum.equals("NULL")) {
						pNum = "";
					}
					returnStr.append("<pnumber>" + pNum + "</pnumber>");
					returnStr.append("<owner_id>" + ownerIDStr + "</owner_id>");
					
					if (writerIDStr.equals("Null") || writerIDStr.equals("NULL")) {
						writerIDStr = "";
					}
					returnStr.append("<writer_id>" + writerIDStr + "</writer_id>");
					
					if (title.equals("Null") || title.equals("NULL")) {
						title = "";
					}
					returnStr.append("<subject><![CDATA[" + title + "]]></subject>");
					returnStr.append("<instancetype>" + reFlag + "</instancetype>");
					
					if (loc.equals("Null") || loc.equals("NULL")) {
						loc = "";
					}
					returnStr.append("<location><![CDATA[" + loc + "]]></location>");
					returnStr.append("<dtstart>"+EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtstart>");
					returnStr.append("<dtend>"+EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss","")+"</dtend>");
					returnStr.append("<dstartTime>"+(format.parse(startDateTime).getHours()*60 +format.parse(startDateTime).getMinutes())+"</dstartTime>");
					returnStr.append("<dendTime>"+(format.parse(endDateTime).getHours()*60 +format.parse(endDateTime).getMinutes())+"</dendTime>");
					returnStr.append("<dsDaytype>"+(int)format.parse(startDateTime).getDay()+"</dsDaytype>");
					returnStr.append("<deDaytype>"+(int)format.parse(endDateTime).getDay()+"</deDaytype>");
					returnStr.append("<alldayevent>"+ allDay +"</alldayevent>");
					
					String timeDisplay = scheRSDom.getElementsByTagName("timeDisplay").item(i).getTextContent();
					
					if (timeDisplay.equals("1")) {
						timeDisplay = "Busy";
					} else if (timeDisplay.equals("2")) {
						timeDisplay = "Tentative";
					} else if (timeDisplay.equals("3")) {
						timeDisplay = "OOF";
					} else if (timeDisplay.equals("4")) {
						timeDisplay = "Free";
					} else {
						timeDisplay = "";
					}
					returnStr.append("<busystatus>"+ timeDisplay +"</busystatus>");
					if (gresFlag.equals("Null") || gresFlag.equals("NULL")) {
						gresFlag = "";
					}
					returnStr.append("<groupflag>"+ gresFlag +"</groupflag>");
					returnStr.append("<gubunFlag>"+ gubun +"</gubunFlag>");
					returnStr.append("<importance>"+ scheRSDom.getElementsByTagName("importance").item(i).getTextContent() +"</importance>");
					returnStr.append("<approveFlag>"+ scheRSDom.getElementsByTagName("approveFlag").item(i).getTextContent() +"</approveFlag>");
					returnStr.append("<owner_nm><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm").item(i).getTextContent() + "]]></owner_nm>");
					returnStr.append("<dept_name><![CDATA[" + scheRSDom.getElementsByTagName("dept_name").item(i).getTextContent() + "]]></dept_name>");
					returnStr.append("<writeDay>"+ writeDay +"</writeDay>");
					
					if (pType.equals("") || pType == null) {
						returnStr.append("<owner_nm2><![CDATA[" + scheRSDom.getElementsByTagName("owner_nm2").item(i).getTextContent() + "]]></owner_nm2>");
						returnStr.append("<dept_name2><![CDATA[" + scheRSDom.getElementsByTagName("dept_name2").item(i).getTextContent() + "]]></dept_name2>");
						returnStr.append("<jobtitle><![CDATA[" +jobTitle + "]]></jobtitle>");
						returnStr.append("<jobtitle2><![CDATA[" + jobTitle2 + "]]></jobtitle2>");
					}
					returnStr.append("</appointment>");
				}
			}
			returnStr.append("</root>");

		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnStr.toString();
	}
	
	public String getScheduleList(String ownerID, String companyID, String groupID, String gubun, String sDate, String eDate, String pType, String pWriterName, String pWriterDept) throws Exception {
		StringBuilder returnStr = new StringBuilder();
		String reCompanyID = "";
		String reOwnerID = "";
		String reNum = "";
		try {
			returnStr.append("<DATA>");
			String todayStartStr = "";
			String todayEndStr = "";
			if (pType.equals("MAIN")) {
				todayStartStr = eDate + " 23:59:59";
				todayEndStr = sDate + " 00:00:01";
			} else {
				todayStartStr = eDate + " 00:00:01";
				todayEndStr = sDate;
			}
			String returnSchedule = "";
			try {
				if (pType.equals("")) {
					List<ResGetScheduleListVO> getScheduleList = getScheduleList(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept);
					for (int i=0; i<getScheduleList.size(); i++) {
						returnSchedule += commonUtil.getQueryResult(getScheduleList.get(i));
					}
					
				} else if (pType.equals("MAIN")) {
	
					List<ResGetScheduleListMainVO> getScheduleListMain = getScheduleListMain(ownerID, companyID, todayStartStr, todayEndStr);

					for (int i=0; i<getScheduleListMain.size(); i++) {
						returnSchedule += commonUtil.getQueryResult(getScheduleListMain.get(i));
					}
				}
			
				Document returnDom1 = commonUtil.convertStringToDocument(returnSchedule);
				
				if (returnDom1 != null) {
					for (int m=0; m<returnDom1.getElementsByTagName("ROW").getLength(); m++) {
						returnStr.append("<ROW>");
						returnStr.append("<num>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(0).getTextContent()+"</num>");
						returnStr.append("<pnum>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(1).getTextContent()+"</pnum>");
						returnStr.append("<ownerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(2).getTextContent()+"</ownerID>");
						returnStr.append("<title><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(3).getTextContent()+"]]></title>");
						returnStr.append("<location><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(4).getTextContent()+"]]></location>");
						returnStr.append("<timeDisplay><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(5).getTextContent()+"]]></timeDisplay>");
						returnStr.append("<startDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(6).getTextContent()+"</startDate>");
						returnStr.append("<endDate>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(7).getTextContent()+"</endDate>");
						returnStr.append("<alertTime>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(8).getTextContent()+"</alertTime>");
						returnStr.append("<reFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(9).getTextContent()+"</reFlag>");
						returnStr.append("<gresFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(10).getTextContent()+"</gresFlag>");
						returnStr.append("<writerID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(11).getTextContent()+"</writerID>");
						returnStr.append("<content><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(12).getTextContent()+"]]></content>");
						returnStr.append("<importance>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(13).getTextContent()+"</importance>");
						returnStr.append("<entryList>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(14).getTextContent()+"</entryList>");
						returnStr.append("<allDay>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(15).getTextContent()+"</allDay>");
						returnStr.append("<writeDay>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(16).getTextContent()+"</writeDay>");
						returnStr.append("<attachFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(17).getTextContent()+"</attachFlag>");
						returnStr.append("<characterID>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(18).getTextContent()+"</characterID>");
						returnStr.append("<approveFlag>"+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(19).getTextContent()+"</approveFlag>");
						returnStr.append("<owner_nm><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(20).getTextContent()+"]]></owner_nm>");
						returnStr.append("<dept_name><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(21).getTextContent()+"]]></dept_name>");
						if (pType.equals("")) {
							returnStr.append("<owner_nm2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(21).getTextContent()+"]]></owner_nm2>");
							returnStr.append("<dept_name2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(22).getTextContent()+"]]></dept_name2>");
							returnStr.append("<jobtitle><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(23).getTextContent()+"]]></jobtitle>");
							returnStr.append("<jobtitle2><![CDATA["+returnDom1.getElementsByTagName("ROW").item(m).getChildNodes().item(24).getTextContent()+"]]></jobtitle2>");
						}
						returnStr.append("</ROW>");
					}
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String returnRepetition = "";
			
			if (pType.equals("")) {
				List<ResGetScheduleListVO> getScheduleListRept= getScheduleListRepetiti(ownerID, companyID, todayStartStr, todayEndStr, pWriterName, pWriterDept);
				returnRepetition += commonUtil.getQueryResult(getScheduleListRept);
			} else {
				List<ResGetScheduleListMainVO> getScheduleListReptMain = getScheduleListRepetitim(ownerID, companyID, todayStartStr);

				returnRepetition = "<DATA>";
				for(int j=0; j<getScheduleListReptMain.size(); j++) {
					returnRepetition += commonUtil.getQueryResult(getScheduleListReptMain.get(j));
				}
				returnRepetition += "</DATA>";
			}
			
			Document returnRepetitionDom = commonUtil.convertStringToDocument(returnRepetition);

			if (returnRepetitionDom != null) {
				for (int i=0; i<returnRepetitionDom.getElementsByTagName("ROW").getLength(); i++) {
					 reCompanyID = returnRepetitionDom.getElementsByTagName("COMPANYID").item(i).getTextContent();
					 reNum = returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent();
					 reOwnerID = returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent();
					
					String returnRepDateTimes = getRepDeteTimes(reCompanyID, reNum, reOwnerID, sDate, eDate);
	
					if (!returnRepDateTimes.trim().equals("")) {
						Document returnRepDateTimesDom = commonUtil.convertStringToDocument(returnRepDateTimes);

						for (int j=0; j<returnRepDateTimesDom.getElementsByTagName("f_sDate").getLength(); j++) {
							String fSDate = returnRepDateTimesDom.getElementsByTagName("f_sDate").item(j).getTextContent().substring(0, 8);
							String fEDate = returnRepDateTimesDom.getElementsByTagName("f_eDate").item(j).getTextContent().substring(0, 8);
							
							ResGetScheduleListTermVO getScheduleListTerm = getScheduleListTerm(Integer.parseInt(reNum), companyID, reOwnerID, fSDate.substring(0,  8)+" 23:59:59", fEDate, pWriterName, pWriterDept);
							
							if (getScheduleListTerm != null) {
								if (!getScheduleListTerm.getReFlag().equals("4")) {
									String reStartDate = getScheduleListTerm.getStartDate().substring(11, 19);
									String reEndDate = getScheduleListTerm.getEndDate().substring(11, 19);
									
									String reSDate = fSDate + reStartDate;
									String reEDate = fEDate + reEndDate;
									
									returnStr.append("<ROW>");
									returnStr.append("<num>" + getScheduleListTerm.getNum() + "</num>");
									returnStr.append("<pnum>" + getScheduleListTerm.getpNum() + "</pnum>");
									returnStr.append("<ownerID>" + getScheduleListTerm.getOwnerID() + "</ownerID>");
									returnStr.append("<title>" + getScheduleListTerm.getTitle() + "</title>");
									returnStr.append("<location>" + getScheduleListTerm.getLocation() + "</location>");
									returnStr.append("<timeDisplay>" + getScheduleListTerm.getTimeDisplay() + "</timeDisplay>");
									returnStr.append("<startDate>" + reSDate + "</startDate>");
									returnStr.append("<endDate>" + reEDate + "</endDate>");
									returnStr.append("<alertTime>" + getScheduleListTerm.getAlertTime() + "</alertTime>");
									returnStr.append("<reFlag>" + getScheduleListTerm.getReFlag() + "</reFlag>");
									returnStr.append("<gresFlag>" + getScheduleListTerm.getgResFlag() + "</gresFlag>");
									returnStr.append("<writerID>" + getScheduleListTerm.getWriterID() + "</writerID>");
									returnStr.append("<content>" + getScheduleListTerm.getContent() + "</content>");
									returnStr.append("<importance>" + getScheduleListTerm.getImportance() + "</importance>");
									returnStr.append("<entryList>" + getScheduleListTerm.getEntryList() + "</entryList>");
									returnStr.append("<allDay>" + getScheduleListTerm.getAllDay() + "</allDay>");
									returnStr.append("<writeDay>" + getScheduleListTerm.getWriteDay() + "</writeDay>");
									returnStr.append("<attachFlag>" + getScheduleListTerm.getAttachFlag() + "</attachFlag>");
									returnStr.append("<characterID>" + getScheduleListTerm.getCharacterID() + "</characterID>");
									returnStr.append("<approveFlag>" + getScheduleListTerm.getApproveFlag() + "</approveFlag>");
									returnStr.append("<owner_nm>" + getScheduleListTerm.getOwnerNm() + "</owner_nm>");
									returnStr.append("<dept_name>" + getScheduleListTerm.getDeptNm() + "</dept_name>");
									
									if (pType.equals("") || pType == null) {
										returnStr.append("<jobtitle>" + getScheduleListTerm.getJobTitle() + "</jobtitle>");
										returnStr.append("<jobtitle2>" + getScheduleListTerm.getJobTitle2() + "</jobtitle2>");
									}
									returnStr.append("</ROW>");
								}
							} else {
								returnStr.append("<ROW>");
								returnStr.append("<num>" + returnRepetitionDom.getElementsByTagName("NUM").item(i).getTextContent() + "</num>");
								returnStr.append("<pnum>" + returnRepetitionDom.getElementsByTagName("PNUM").item(i).getTextContent() + "</pnum>");
								returnStr.append("<ownerID>" + returnRepetitionDom.getElementsByTagName("OWNERID").item(i).getTextContent() + "</ownerID>");
								returnStr.append("<title>" + returnRepetitionDom.getElementsByTagName("TITLE").item(i).getTextContent() + "</title>");
								returnStr.append("<location>" + returnRepetitionDom.getElementsByTagName("LOCATION").item(i).getTextContent() + "</location>");
								returnStr.append("<timeDisplay>" + returnRepetitionDom.getElementsByTagName("TIMEDISPLAY").item(i).getTextContent() + "</timeDisplay>");
								returnStr.append("<startDate>" + returnRepetitionDom.getElementsByTagName("STARTDATE").item(i).getTextContent() + "</startDate>");
System.out.println(returnRepetitionDom.getElementsByTagName("STARTDATE").item(i).getTextContent());
System.out.println(returnRepetitionDom.getElementsByTagName("ENDDATE").item(i).getTextContent());
								returnStr.append("<endDate>" + returnRepetitionDom.getElementsByTagName("ENDDATE").item(i).getTextContent() + "</endDate>");
								returnStr.append("<alertTime>" + returnRepetitionDom.getElementsByTagName("ALERTTIME").item(i).getTextContent() + "</alertTime>");
								returnStr.append("<reFlag>" + returnRepetitionDom.getElementsByTagName("REFLAG").item(i).getTextContent() + "</reFlag>");
								returnStr.append("<gresFlag>" + returnRepetitionDom.getElementsByTagName("GRESFLAG").item(i).getTextContent() + "</gresFlag>");
								returnStr.append("<writerID>" + returnRepetitionDom.getElementsByTagName("WRITERID").item(i).getTextContent() + "</writerID>");
								returnStr.append("<content>" + returnRepetitionDom.getElementsByTagName("CONTENT").item(i).getTextContent() + "</content>");
								returnStr.append("<importance>" + returnRepetitionDom.getElementsByTagName("IMPORTANCE").item(i).getTextContent() + "</importance>");
								returnStr.append("<entryList>" + returnRepetitionDom.getElementsByTagName("ENTRYLIST").item(i).getTextContent() + "</entryList>");
								returnStr.append("<allDay>" + returnRepetitionDom.getElementsByTagName("ALLDAY").item(i).getTextContent() + "</allDay>");
								returnStr.append("<writeDay>" + returnRepetitionDom.getElementsByTagName("WRITEDAY").item(i).getTextContent() + "</writeDay>");
								returnStr.append("<attachFlag>" + returnRepetitionDom.getElementsByTagName("ATTACHFLAG").item(i).getTextContent() + "</attachFlag>");
								returnStr.append("<characterID>" + returnRepetitionDom.getElementsByTagName("CHARACTERID").item(i).getTextContent() + "</characterID>");
								returnStr.append("<approveFlag>" + returnRepetitionDom.getElementsByTagName("APPROVEFLAG").item(i).getTextContent() + "</approveFlag>");
								returnStr.append("<owner_nm>" + returnRepetitionDom.getElementsByTagName("OWNERNM").item(i).getTextContent() + "</owner_nm>");
								returnStr.append("<dept_name>" + returnRepetitionDom.getElementsByTagName("DEPTNM").item(i).getTextContent() + "</dept_name>");
								if (pType.equals("") || pType == null) {
									returnStr.append("<owner_nm2>" + returnRepetitionDom.getElementsByTagName("OWNERNM2").item(i).getTextContent() + "</owner_nm2>");
									returnStr.append("<dept_name2>" + returnRepetitionDom.getElementsByTagName("DEPTNM2").item(i).getTextContent() + "</dept_name2>");
									returnStr.append("<jobtitle>" + returnRepetitionDom.getElementsByTagName("JOBTITLE").item(i).getTextContent() + "</jobtitle>");
									returnStr.append("<jobtitle2>" + returnRepetitionDom.getElementsByTagName("JOBTITLE2").item(i).getTextContent() + "</jobtitle2>");
								}
								returnStr.append("</ROW>");
							}
						}
					}
				}
			}
			returnStr.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnStr.toString();
	}
	
	public String getRepDeteTimes(String companyID, String num, String ownerID, String sDate, String eDate) throws Exception {
		String returnStr = "";
		try {
			ResGetRepDateTimesVO getRepDateTimes = getRepDateTimes(ownerID, companyID, Integer.parseInt(num));
			if (getRepDateTimes != null) {
				String startDateTime = getRepDateTimes.getStartDateTime();
				String endDateTime = getRepDateTimes.getEndDateTime();

				startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "", "");
				endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "", "");

				String reWay = getRepDateTimes.getReWay();
				String reDay = getRepDateTimes.getReDay();
				String reNum = getRepDateTimes.getReNum();
				String reYoil = getRepDateTimes.getReYoil();
				String reMonth = getRepDateTimes.getReMonth();
				String reOrd = getRepDateTimes.getReOrd();
				String endFlag = getRepDateTimes.getEndFlag();
				String reCount = getRepDateTimes.getReCount();
				String freq = reWay.substring(0, 1);
				String sel = reWay.substring(reWay.length()-1, 1);
				
				if (reNum.equals("Null") || reNum.equals("NULL")) {
					reNum = "";
				}
				if (reYoil.equals("Null") || reYoil.equals("NULL")) {
					reYoil = "";
				}
				if (reDay.equals("Null") || reDay.equals("NULL")) {
					reDay = "";
				}
				if (reMonth.equals("Null") || reMonth.equals("NULL")) {
					reMonth = "";
				}
				if (reCount.equals("Null") || reCount.equals("NULL")) {
					reCount = "";
				}
				
				StringBuilder reXMLStr = new StringBuilder();
				reXMLStr.append("<recurrence>");
				reXMLStr.append("<frequency>"+freq+"</frequency>");
				reXMLStr.append("<selType>"+sel+"</selType>");
				reXMLStr.append("<endRecurType>"+endFlag+"</endRecurType>");
				reXMLStr.append("<startDateTime>"+startDateTime+"</startDateTime>");
				reXMLStr.append("<endDateTime>"+endDateTime+"</endDateTime>");
				reXMLStr.append("<interval>"+reNum+"</interval>");
				reXMLStr.append("<daysOfWeek>"+reYoil+"</daysOfWeek>");
				reXMLStr.append("<daysOfMonth>"+reDay+"</daysOfMonth>");
				reXMLStr.append("<byPosition>"+reOrd+"</byPosition>");
				reXMLStr.append("<monthsOfYear>"+reMonth+"</monthsOfYear>");
				reXMLStr.append("<instances>"+reCount+"</instances>");
				reXMLStr.append("</recurrence>");
	
				if (freq.equals("4")) {
					returnStr = getDailyRepDateTimes(reXMLStr.toString(), sDate, eDate); 
				} else if (freq.equals("5")) {
					returnStr = getWeeklyRepDateTime(reXMLStr.toString(), sDate, eDate);
				} else if (freq.equals("6")) {
					returnStr = getMonthlyRepDateTimes(reXMLStr.toString(), sDate, eDate);
				} else if (freq.equals("7")) {
					returnStr = getYearlyRepDateTimes(reXMLStr.toString(), sDate, eDate);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnStr.toString();
	}
	
	public String getDailyRepDateTimes(String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
			int interval = Integer.parseInt(interval2);
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = startDateTime.substring(0, 10);
			
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "yyyy-MM-dd HH:mm:ss", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			
			String orgTmpDTStr = tmpDTStr;
			int n = 1;
			
			returnXML.append("<DATA>");
			
			int temp = 0;
			boolean whileFlag = true;
			while (whileFlag) {
				if (selType.equals("0")) {
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
							
							if (number(tmpDTStr) >= number(orgTmpDTStr)) {
								n = n+1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, interval, ""), "", "", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, interval, ""), "", "", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, interval, ""), "", "", "");
				} else {
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
							
							if (number(tmpDTStr) >= number(orgTmpDTStr)) {
								n = n+1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
							break;
						} else if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7) {
							if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
								returnXML.append("<ROW>");
								returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
								returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
								returnXML.append("</ROW>");
							}
						}
					}
					
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				}
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	public String getWeeklyRepDateTime (String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String interval2 = xmlRes.getElementsByTagName("interval").item(0).getTextContent().trim();
			int interval = Integer.parseInt(interval2);
			String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = endDateTime.substring(0, 10);
			
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			
			boolean isFirst = true;
			String orgTmpDTStr = tmpDTStr;
			String selDTStr = "";
			int temp = 0;
			int temp2 = 0;
			int n = 1;
			String[] wDay;
			wDay = daysOfWeek.split(",");
			int wDayCnt = wDay.length;
			
			returnXML.append("<DATA>");
			
			boolean whileFlag = true;
			while (whileFlag) {
				selDTStr = tmpDTStr;
				boolean secondWhileFlag = true;
				while (secondWhileFlag == true) {
					for (int i=0; i<wDayCnt; i++) {
						if (wDay[i].equals("")) {
							wDay[i] = "0";
						}
						if (orgTmpDTStr.equals(selDTStr) && weekDay(tmpDTStr) == Integer.parseInt(wDay[i] + 1) && isFirst == true) {
							isFirst = false;
							secondWhileFlag = false;
							break;
						} else if (weekDay(tmpDTStr) < Integer.parseInt(wDay[i]) + 1 || !selDTStr.equals(tmpDTStr)) {
							int tmpWeekDay = weekDay(tmpDTStr);
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr), ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
							
							secondWhileFlag = false;
							break;
						}
					}
					if (secondWhileFlag == false) {
						break;
					}
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (interval * 7), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (interval * 7), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (interval * 7), ""), "yyyyMMdd", "yyyyMMdd", "");
					
					if (weekDay(tmpDTStr) != 1) {
						int tmpWeekDay = weekDay(tmpDTStr);
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (1- weekDay(tmpDTStr)), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (1 - tmpWeekDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (1 - tmpWeekDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					}
					for (int i=0; i<wDayCnt; i++) {
						if (wDay[i].equals("")) {
							wDay[i] = "0";
						}
						if (weekDay(tmpDTStr) != (Integer.parseInt(wDay[i]) + 1)) {
							int tmpWeekDay = weekDay(tmpDTStr);
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(wDay[i]) + 1 - weekDay(tmpDTStr), ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(wDay[i]) + 1 - tmpWeekDay, ""), "yyyyMMdd", "yyyyMMdd", "");
						}
					}
					temp2 ++;
					if (temp2 > 1000) {
						break;
					}
				}
				
				if (endRecurType.equals("0")) {
					if (number(tmpDTStr) > number(eDate)) {
						break;
					} else {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				} else if (endRecurType.equals("1")) {
					if (number(tmpDTStr) > number(eDate) || n > number(instances) * (wDayCnt-1)) {
						break;
					} else {
						if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgTmpDTStr)) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
						
						if (number(tmpDTStr) >= number(orgTmpDTStr)) {
							n = n +1;
						}
					}
				} else if (endRecurType.equals("2")) {
					if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
						break;
					} else  {
						if ((number(tmpDTStr) > number(eDate) || number(tmpDTStr) >= number(orgTmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1))) {
							returnXML.append("<ROW>");
							returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
							returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
							returnXML.append("</ROW>");
						}
					}
				}
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	@SuppressWarnings("deprecation")
	public String getMonthlyRepDateTimes(String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
			String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
			if (daysOfWeek.equals("")) {
				daysOfWeek = "0";
			}
			String daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent().trim();
			String byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent().trim();
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			String[] wDay = daysOfWeek.split(",");
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = startDateTime.substring(0, 10);
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			String orgtmpDTStr = tmpDTStr;
			int n = 1;
			returnXML.append("<DATA>");
			
			int temp = 0;
			boolean whileFlag = true;
			while(whileFlag) {
				int wDayCnt = wDay.length;
				if (wDayCnt != 0) {
					wDayCnt = wDayCnt - 1;
				}
				if (daysOfWeek.indexOf(",") < 0) {
					wDayCnt = 0;
				}
				if (selType.equals("0")) {
					int datePartDay = format.parse(tmpDTStr).getDate();
					int datePartMonth = format.parse(tmpDTStr).getMonth();
					int datePartYear = format.parse(tmpDTStr).getYear();
					boolean checkLastDate = true;
					
					if (daysOfMonth.equals("31") && (datePartMonth == 2 || datePartMonth == 4 || datePartMonth == 6 || datePartMonth == 9 || datePartMonth == 11)) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("30") && datePartMonth == 2) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("29") && datePartMonth == 2 && !(datePartYear % 4 == 0 && datePartYear % 100 != 0 || datePartYear % 400 == 0)) {
						checkLastDate = false;
					}
					
					if (checkLastDate) {
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, Integer.parseInt(daysOfMonth) - datePartDay, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, Integer.parseInt(daysOfMonth) - datePartDay, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, Integer.parseInt(daysOfMonth) - datePartDay, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						
						if (endRecurType.equals("0")) {
							if (number(tmpDTStr) > number(eDate)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else if (endRecurType.equals("1")) {
							if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
								
								if (number(tmpDTStr) >= number(orgtmpDTStr)) {
									n = n+1;
								}
							}
						} else if (endRecurType.equals("2")) {
							if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				} else {
					int count = 1;
					int datePartDay = format.parse(tmpDTStr).getDate();
					
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1 - datePartDay, ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1 - datePartDay, ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1 - datePartDay, ""), "yyyyMMdd", "yyyyMMdd", "");
					
					String sTmpDTStr = tmpDTStr;
					
					if (!byPosition.equals("-1")) {
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7) {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 6) {
										break;
									}
								} else {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
										break;
									}
								}
							}
							count ++;
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							
						}
						if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7 && wDayCnt == 5) {
							tmpDTStr = sTmpDTStr;
							wDayCnt = count;
						}
						
						if (!byPosition.equals("1")) {
							if (wDayCnt == 5) {
								if (format.parse(tmpDTStr).getDate() == 1) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
								} else {
									if (weekDay(sTmpDTStr) == 1 || weekDay(sTmpDTStr) == 7) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									} else {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -2) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
								}
							} 
						} else {
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						}
					} else {
						int count1 = 1;
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						
						int tmpWeekDay = weekDay(tmpDTStr);
						
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
									break;
								}
							}
							count1++;
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
						}
						if (wDayCnt == 2) {
							if (tmpWeekDay == 7) {
								wDayCnt = 0;
							}
						} else if (wDayCnt == 5) {
							if (tmpWeekDay == 1 || tmpWeekDay == 7) {
								wDayCnt = 5;
							} else {
								wDayCnt = count1;
							}
						}
					}
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
							if (number(tmpDTStr) >= number(orgtmpDTStr)) {
								n = n + 1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr1)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyy-MM-dd", "yyyy-MM-dd", "");
									}
									
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
									
									if (tmpDTStr.equals(tmpEDTStr1)) {
										break;
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				}
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	@SuppressWarnings("deprecation")
	public String getYearlyRepDateTimes (String xmlStr, String sDate, String eDate) {
		StringBuilder returnXML = new StringBuilder();
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			
			String selType = xmlRes.getElementsByTagName("selType").item(0).getTextContent().trim();
			String startDateTime = xmlRes.getElementsByTagName("startDateTime").item(0).getTextContent().trim();
			String endDateTime = xmlRes.getElementsByTagName("endDateTime").item(0).getTextContent().trim();
			String daysOfWeek = xmlRes.getElementsByTagName("daysOfWeek").item(0).getTextContent().trim();
			String daysOfMonth = xmlRes.getElementsByTagName("daysOfMonth").item(0).getTextContent().trim();
			String byPosition = xmlRes.getElementsByTagName("byPosition").item(0).getTextContent().trim();
			String monthsOfYear = xmlRes.getElementsByTagName("monthsOfYear").item(0).getTextContent().trim();
			String endRecurType = xmlRes.getElementsByTagName("endRecurType").item(0).getTextContent().trim();
			String instances = xmlRes.getElementsByTagName("instances").item(0).getTextContent().trim();
			String[] wDay = daysOfWeek.split(",");
			String tmpSTime = startDateTime.substring(11, 19);
			String tmpETime = endDateTime.substring(11, 19);
			String tmpDTStr = startDateTime.substring(0, 10);
			String tmpEDTStr = startDateTime.substring(0, 10);
			String tmpSDTStr = tmpDTStr;
			String tmpEDTStr1 = tmpEDTStr;
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			
			if (number(tmpSTime) > number(tmpETime)) {
				startDateTime = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDateTime, 1, ""), "", "", "");
				tmpSDTStr = startDateTime.substring(0, 10);
			}
			String orgtmpDTStr = tmpDTStr;
			int n = 1;
			returnXML.append("<DATA>");
			
			int temp = 0;
			boolean whileFlag = true;
			while(whileFlag) {
				int wDayCnt = wDay.length;
				if (wDayCnt != 0) {
					wDayCnt = wDayCnt - 1;
				}
				if (daysOfWeek.indexOf(",") < 0) {
					wDayCnt = 0;
				}
				
				int datePartMonth = format.parse(tmpDTStr).getMonth();
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpEDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpSDTStr,(Integer.parseInt(monthsOfYear) - datePartMonth), ""), "yyyyMMdd", "yyyyMMdd", "");
				
				if (selType.equals("0")) {
					int datePartDay = format.parse(tmpDTStr).getDate();
					int datePartYear = format.parse(tmpDTStr).getYear();
					int tmpDatePartMonth = format.parse(tmpDTStr).getMonth();
					boolean checkLastDate = true;
					
					if (daysOfMonth.equals("31") && (tmpDatePartMonth == 2 || tmpDatePartMonth == 4 || tmpDatePartMonth == 6 || tmpDatePartMonth == 9 || tmpDatePartMonth == 11)) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("30") && tmpDatePartMonth == 2) {
						checkLastDate = false;
					} else if (daysOfMonth.equals("29") && tmpDatePartMonth == 2 && !(datePartYear % 4 == 0 && datePartYear % 100 != 0 || datePartYear % 400 == 0)) {
						checkLastDate = false;
					}
					
					if (checkLastDate) {
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(daysOfMonth) - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
						
						if (endRecurType.equals("0")) {
							if (number(tmpDTStr) > number(eDate)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						} else if (endRecurType.equals("1")) {
							if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
								
								if (number(tmpDTStr) >= number(orgtmpDTStr)) {
									n = n+1;
								}
							}
						} else if (endRecurType.equals("2")) {
							if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr)) {
								break;
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpSDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpSDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				} else {
					int count = 1;
					int datePartDay = format.parse(tmpDTStr).getDate();
					
					tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (1 - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (1 - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (1 - datePartDay), ""), "yyyyMMdd", "yyyyMMdd", "");
					
					String sTmpDTStr = tmpDTStr;
					
					if (!byPosition.equals("-1")) {
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7) {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 6) {
										break;
									}
								} else {
									if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
										break;
									}
								}
							}
							count ++;
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
						}
						if (byPosition.equals("1") && weekDay(tmpDTStr) > 2 && weekDay(tmpDTStr) < 7 && wDayCnt == 5) {
							tmpDTStr = sTmpDTStr;
							wDayCnt = count;
						}
						
						if (!byPosition.equals("1")) {
							if (wDayCnt == 5) {
								if (format.parse(tmpDTStr).getDate() == 1) {
									tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyyMMdd", "yyyyMMdd", "");
								} else {
									if (weekDay(sTmpDTStr) == 1 || weekDay(sTmpDTStr) == 7) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyyMMdd", "yyyyMMdd", "");
									} else {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -2) * 7, ""), "yyyyMMdd", "yyyyMMdd", "");
									}
								}
							} 
						} else {
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpEDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpSDTStr, (Integer.parseInt(byPosition) -1) * 7, ""), "yyyyMMdd", "yyyyMMdd", "");
						}
					} else {
						int count1 = 1;
						
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addMonth(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
						tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
						
						int tmpWeekDay = weekDay(tmpDTStr);
						
						while (true) {
							if (wDayCnt == 0) {
								if (weekDay(tmpDTStr) == Integer.parseInt(daysOfWeek) + 1) {
									break;
								}
							} else if (wDayCnt == 2) {
								if (weekDay(tmpDTStr) == 7) {
									break;
								}
							} else {
								if (weekDay(tmpDTStr) > 1 && weekDay(tmpDTStr) < 7 && weekDay(tmpDTStr) == 2) {
									break;
								}
							}
							count1++;
							
							tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
							tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
						}
						if (wDayCnt == 2) {
							if (tmpWeekDay == 7) {
								wDayCnt = 0;
							}
						} else if (wDayCnt == 5) {
							if (tmpWeekDay == 1 || tmpWeekDay == 7) {
								wDayCnt = 5;
							} else {
								wDayCnt = count1;
							}
						}
					}
					if (endRecurType.equals("0")) {
						if (number(tmpDTStr) > number(eDate)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					} else if (endRecurType.equals("1")) {
						if (number(tmpDTStr) > number(eDate) || n > number(instances)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
									}
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
							if (number(tmpDTStr) >= number(orgtmpDTStr)) {
								n = n + 1;
							}
						}
					} else if (endRecurType.equals("2")) {
						if (number(tmpDTStr) > number(eDate) || number(tmpDTStr) > number(tmpEDTStr1)) {
							break;
						} else {
							if (wDayCnt != 0) {
								for (int i=0; i<wDayCnt; i++) {
									if (i>0) {
										tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addDay(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
									}
									
									if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
										returnXML.append("<ROW>");
										returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
										returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
										returnXML.append("</ROW>");
									}
									
									if (tmpDTStr.equals(tmpEDTStr1)) {
										break;
									}
								}
							} else {
								if (number(tmpDTStr) >= number(sDate) && number(tmpDTStr) >= number(orgtmpDTStr) && number(tmpDTStr) <= number(tmpEDTStr1)) {
									returnXML.append("<ROW>");
									returnXML.append("<f_sDate>" + tmpDTStr + " " + tmpSTime + "</f_sDate>");
									returnXML.append("<f_eDate>" + tmpDTStr + " " + tmpETime + "</f_eDate>");
									returnXML.append("</ROW>");
								}
							}
						}
					}
				}
				tmpDTStr = EgovDateUtil.convertDate(EgovDateUtil.addYear(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpEDTStr = EgovDateUtil.convertDate(EgovDateUtil.addYear(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				tmpSDTStr = EgovDateUtil.convertDate(EgovDateUtil.addYear(tmpDTStr, 1, ""), "yyyyMMdd", "yyyyMMdd", "");
				
				temp++;
				if (temp > 1000) {
					break;
				}
			}
			returnXML.append("</DATA>");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnXML.toString();
	}
	
	public int number(String inputStr) {
		try {
			return Integer.parseInt(inputStr.replace("-", "").replace(" ", "").replace(":", "").trim());
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	
	@SuppressWarnings("deprecation")
	public int weekDay(String inputStr) {
		int returnValue = 0;
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		
		try {
				if (format.parse(inputStr).getDay() == 0) {
					returnValue = 1;
				}
				
				if (format.parse(inputStr).getDay() == 1) {
					returnValue = 2;
				}
				
				if (format.parse(inputStr).getDay() == 2) {
					returnValue = 3;
				}
				
				if (format.parse(inputStr).getDay() == 3) {
					returnValue = 4;
				}
				
				if (format.parse(inputStr).getDay() == 4) {
					returnValue = 5;
				}
				
				if (format.parse(inputStr).getDay() == 5) {
					returnValue = 6;
				}
				
				if (format.parse(inputStr).getDay() == 6) {
					returnValue = 7;
				}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnValue;
	}
	
	public String getLocalTime(String pDateTime) {
		String strDateTime = "";
		if (pDateTime.equals("")) {
			return strDateTime;
		}
		
		try {
			//TODO userInfo.Offset
			//String pOffset = "+09:00";
			strDateTime = EgovDateUtil.convertDate(addHours(pDateTime, 0, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm", "");
			strDateTime = EgovDateUtil.convertDate(addMinutes(pDateTime, 0, "yyyy-MM-dd HH:mm"), "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm", "");
	
			if (pDateTime.length() < 19) {
				strDateTime = strDateTime.substring(0, pDateTime.length());
			}
System.out.println("pDateTime:"+pDateTime);
System.out.println("strDateTime:"+strDateTime);
			return strDateTime;
		} catch (Exception e) {
			e.printStackTrace();
			return pDateTime;
		}
	}
	
	public static String addHours(String sDate, int hour, String dateFormat) {		
		Calendar cal = Calendar.getInstance();
		
		if(dateFormat.equals("")){
			dateFormat = "yyyyMMdd";
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat, Locale.getDefault());		
		
		try {
			cal.setTime(sdf.parse(sDate));
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: " + sDate);
		}

		if (hour != 0) {
			cal.add(Calendar.HOUR, hour);
		}
		return sdf.format(cal.getTime());
	}
	
	public static String addMinutes(String sDate, int minute, String dateFormat) {		
		Calendar cal = Calendar.getInstance();
		
		if(dateFormat.equals("")){
			dateFormat = "yyyyMMdd";
		}
		
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat, Locale.getDefault());		
		
		try {
			cal.setTime(sdf.parse(sDate));
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: " + sDate);
		}

		if (minute != 0) {
			cal.add(Calendar.MINUTE, minute);
		}
		return sdf.format(cal.getTime());
	}
	
	@SuppressWarnings("deprecation")
	public String convertToUTC(String pDate) {
		try {
			SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			String utcDate = (date.parse(pDate).getYear()+1900) + "-" + fedLeft(date.parse(pDate).getMonth()+1) + "-" + fedLeft(date.parse(pDate).getDate()) + "T" + fedLeft(date.parse(pDate).getHours()) + ":" + fedLeft(date.parse(pDate).getMinutes()) + ":01.000Z";
System.out.println("pDate:"+pDate);
System.out.println("utcDate:"+utcDate);
			return utcDate;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String fedLeft(int pDatePart) {
		try {
			String datePart = String.valueOf(pDatePart);
			if (datePart.length() == 1) {
				datePart = "0" + datePart;
			}
			return datePart;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	//TODO HH:mm:ss 형식의 현재시간 출력 
	public String getCurrentDate() {
		Calendar aCalendar = Calendar.getInstance();
		String strDate = "";
		
		int hour = aCalendar.get(Calendar.HOUR_OF_DAY);
		int min = aCalendar.get(Calendar.MINUTE);
		int sec = aCalendar.get(Calendar.SECOND);
		
		strDate = hour + ":" + min + ":" + sec;
		return strDate;
	}
	
	public String getAdminFlag(String companyID, String brdID, String userID) throws Exception {
		String accessLvl = "";

		try {
			ResGetAdminFlagVO resGetAdminFlag = getAdmFlag(companyID, brdID, userID);

			String strXML = commonUtil.getQueryResult(resGetAdminFlag);
			Document xmlDom = commonUtil.convertStringToDocument(strXML);
		
			if(xmlDom.getElementsByTagName("ROW") != null) {
				for(int i=0; i<xmlDom.getElementsByTagName("ROW").getLength(); i++) {
					accessLvl = xmlDom.getElementsByTagName("ACCESSLVL").item(i).getTextContent().trim();
				}
			}
		
			if(accessLvl.trim().equals("1")) {
				return "Y";
			} else if(accessLvl.trim().equals("2")) {
				return "U";
			} else {
				return "";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getItemList(@CookieValue("loginCookie") String loginCookie,String brdID) throws Exception {
		String childBrd = "";
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		List<ResGetItemListVO> list = getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang());
		
		for(int i=0; i<list.size(); i++) {
			childBrd += list.get(i).getBrdID()+"/"+list.get(i).getBrdNm()+"/"+list.get(i).getApproveFlag()+",";
		}
		
		return childBrd;
	}
	
	public String getSubClsTree(String xmlStr, String langStr, String pComID, String pDeptID, String pUserID) throws Exception {
        String strUserID = "";
        String strDeptPath = "";
        String returnXML = "";
   
        Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strParentID = xmlRes.getElementsByTagName("PARENT_ID").item(0).getTextContent().trim();
        String strCompanyID = xmlRes.getElementsByTagName("COMPANY_ID").item(0).getTextContent().trim();
        String strAccessFlag = xmlRes.getElementsByTagName("ACCESS_FLAG").item(0).getTextContent().trim();
        String strFirstNode = xmlRes.getElementsByTagName("FIRST_NODE").item(0).getTextContent().trim();
        String strTreeType = xmlRes.getElementsByTagName("TREE_TYPE").item(0).getTextContent().trim();

        if(xmlRes.getElementsByTagName("BRDLIST").getLength() > 5) {
        	strUserID = xmlRes.getElementById("BRDLIST").getChildNodes().item(5).getTextContent().trim();
        	strDeptPath = xmlRes.getElementById("BRDLIST").getChildNodes().item(6).getTextContent().trim();
        	strDeptPath = "'" + strDeptPath.replace("," , "', '")+ "'";
        }
        
        List<ResGetAdmSubClsTreeVO> resGetAdmSubClsTree = new ArrayList<ResGetAdmSubClsTreeVO>();
        if(strAccessFlag.equals("0")) {
        	resGetAdmSubClsTree = getAdmSubClsTree(strParentID, strCompanyID, strTreeType);
        } else {
        	resGetAdmSubClsTree = getSubClsTree(strParentID, strCompanyID, strTreeType, strUserID, pComID, pDeptID, pUserID);
        }

        StringBuilder strTreeStyle = new StringBuilder();
        if(strFirstNode.equals("Y")) {
        	strTreeStyle.append("<TREEVIEWDATA>");
        	strTreeStyle.append("<TEXTCOLOR>");
        	strTreeStyle.append("<NAME>ENTUMTEXTCOLOR</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<DEFAULTTEXTCOLOR>black</DEFAULTTEXTCOLOR>");					
        	strTreeStyle.append("<DEFAULTBGCOLOR>ffffff</DEFAULTBGCOLOR>");
        	strTreeStyle.append("<SELECTEDTEXTCOLOR>164AAD</SELECTEDTEXTCOLOR>");
        	strTreeStyle.append("<SELECTEDBGCOLOR>ffffff</SELECTEDBGCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGTEXTCOLOR>164AAD</HOTTRACKINGTEXTCOLOR>");
        	strTreeStyle.append("<HOTTRACKINGBGCOLOR>ffffff</HOTTRACKINGBGCOLOR>");
        	strTreeStyle.append("</TEXTCOLOR>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESCLASS</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_01.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_01.gif</LEAFSELECTEDICON>");
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_01.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_01.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<NODEICONIMAGE>");
        	strTreeStyle.append("<NAME>RESOURCE</NAME>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<LEAFDEFAULTICON>/images/left/tree_02.gif</LEAFDEFAULTICON>");
        	strTreeStyle.append("<LEAFSELECTEDICON>/images/left/tree_02.gif</LEAFSELECTEDICON>");
        	
        	strTreeStyle.append("<BRANCHDEFAULTICON>/images/left/tree_02.gif</BRANCHDEFAULTICON>");
        	strTreeStyle.append("<BRANCHSELECTEDICON>/images/left/tree_02.gif</BRANCHSELECTEDICON>");
        	strTreeStyle.append("</NODEICONIMAGE>");
        	strTreeStyle.append("<HERITAGEICONIMAGE>");
        	strTreeStyle.append("<DEFAULT></DEFAULT>");
        	strTreeStyle.append("<BLANKICON>/images/left/blank.gif</BLANKICON>");
        	strTreeStyle.append("<VERTICALLINEICON>/images/left/vline.gif</VERTICALLINEICON>");
        	strTreeStyle.append("<NODEICON>/images/left/02.gif</NODEICON>");
        	strTreeStyle.append("<MNODEICON>/images/left/02_minus.gif</MNODEICON>");
        	strTreeStyle.append("<PNODEICON>/images/left/02_plus.gif</PNODEICON>");
        	strTreeStyle.append("<ROOTNODEICON>/images/left/03.gif</ROOTNODEICON>");
        	strTreeStyle.append("<MROOTNODEICON>/images/left/03_minus.gif</MROOTNODEICON>");
        	strTreeStyle.append("<PROOTNODEICON>/images/left/03_plus.gif</PROOTNODEICON>");
        	strTreeStyle.append("<LASTNODEICON>/images/left/03.gif</LASTNODEICON>");
        	strTreeStyle.append("<MLASTNODEICON>/images/left/03_minus.gif</MLASTNODEICON>");
        	strTreeStyle.append("<FIRSTROOTNODEICON>/images/left/02.gif</FIRSTROOTNODEICON>");
        	strTreeStyle.append("<MFIRSTROOTNODEICON>/images/left/02_minus.gif</MFIRSTROOTNODEICON>");
        	strTreeStyle.append("<PFIRSTROOTNODEICON>/images/left/02_plus.gif</PFIRSTROOTNODEICON>");
        	strTreeStyle.append("</HERITAGEICONIMAGE>");
        
        	returnXML = strTreeStyle.toString();
        } else {
        	strTreeStyle.append("<NODES>");
        	returnXML = strTreeStyle.toString();
        }
        
        if(strFirstNode.equals("Y")) {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		if(i == 0) {
        			 returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), true, langStr);
        		} else {
        			returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr);
        		}
        	}
        	returnXML += "</TREEVIEWDATA>";
        } else {
        	for(int i=0; i<resGetAdmSubClsTree.size(); i++) {
        		returnXML += makeNodesFromADOFlds(commonUtil.getQueryResult(resGetAdmSubClsTree.get(i)), false, langStr);

        	}

        	returnXML += "</NODES>";
        }
		return returnXML;
	}
	
	public String makeNodesFromADOFlds(String xmlStr, boolean blnFirstNode, String langStr) throws Exception{
		String returnXML = "";
        String strData2 = "";
        int intSubCnt = 0;
        String strIsLeaf = "";
        String strSetNodeIconByName = "";
        
        Document xmlRes = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        xmlRes = commonUtil.convertStringToDocument(xmlStr);
        String strData1 = xmlRes.getElementsByTagName("BRDID").item(0).getTextContent();
        
        if(langStr.equals("1")) {
        	strData2 = xmlRes.getElementsByTagName("BRDNM").item(0).getTextContent();
        } else {
        	strData2 = xmlRes.getElementsByTagName("BRDNM"+langStr).item(0).getTextContent();
        }
        String strData3 = xmlRes.getElementsByTagName("BRDLEVEL").item(0).getTextContent();
        String strData4 = xmlRes.getElementsByTagName("BRDSTEP").item(0).getTextContent();
        String strData5 = xmlRes.getElementsByTagName("BRDPOSTTERM").item(0).getTextContent();
        String strData6 = xmlRes.getElementsByTagName("BRDUPPER").item(0).getTextContent();
        String strData7 = xmlRes.getElementsByTagName("BRDGB").item(0).getTextContent();
        String strData8 = xmlRes.getElementsByTagName("BRDURL").item(0).getTextContent();
        String strData9 = xmlRes.getElementsByTagName("BRDEXPLAIN").item(0).getTextContent();
        String strData10 = xmlRes.getElementsByTagName("BRDACCESS").item(0).getTextContent();
        String strData11 = xmlRes.getElementsByTagName("ATTACHSIZE").item(0).getTextContent();
        String strData12 = xmlRes.getElementsByTagName("SUBCLSCNT").item(0).getTextContent();
        String strData13 = xmlRes.getElementsByTagName("SUBRESCNT").item(0).getTextContent();
        String strData14 = xmlRes.getElementsByTagName("ACCESSLVL").item(0).getTextContent();
        String strData15 = xmlRes.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
  
        intSubCnt = Integer.parseInt(strData12.trim()) + Integer.parseInt(strData13.trim());
        
        String strValue = strData2;
        String strStyle = "font-weight:normal;height:10px;";
        
        returnXML += "<NODE>";
        returnXML += makeXMLElement(strValue, "VALUE", true);
        returnXML += makeXMLElement(strStyle, "STYLE");
        returnXML += makeXMLElement(strData1, "DATA1");
        returnXML += makeXMLElement(strData2, "DATA2", true);
        returnXML += makeXMLElement(strData3, "DATA3");
        returnXML += makeXMLElement(strData4, "DATA4");
        returnXML += makeXMLElement(strData5, "DATA5");
        returnXML += makeXMLElement(strData6, "DATA6");
        returnXML += makeXMLElement(strData7, "DATA7");
        returnXML += makeXMLElement(strData8, "DATA8", true);
        returnXML += makeXMLElement(strData9, "DATA9", true);
        returnXML += makeXMLElement(strData10, "DATA10", true);
        returnXML += makeXMLElement(strData11, "DATA11");
        returnXML += makeXMLElement(strData12, "DATA12");
        returnXML += makeXMLElement(strData13, "DATA13");
        returnXML += makeXMLElement(strData14, "DATA14");
        returnXML += makeXMLElement(strData15, "DATA15");
        
        if(intSubCnt == 0) {
        	strIsLeaf = "TRUE";
        } else {
        	strIsLeaf = "FALSE";
        }
        
        if(strData7.equals("1")) {
        	strSetNodeIconByName = "RESCLASS";
        } else {
        	strSetNodeIconByName = "RESOURCE";
        }
        
        returnXML += makeXMLElement(strIsLeaf, "ISLEAF");
        returnXML += makeXMLElement(strSetNodeIconByName, "SETNODEICONBYNAME");
        returnXML += makeXMLElement("FALSE", "EXPANDED");
        
        if(blnFirstNode == true) {
        	returnXML += makeXMLElement("", "SELECT", true);
        }
        returnXML += "</NODE>";
		return returnXML;
	}
	
	public String makeXMLElement(String strElementText, String strElementName, boolean blnCData) {
		if(blnCData == true) {
			return "<"+strElementName+"><![CDATA["+strElementText+"]]></"+strElementName+">";
		} else {
			return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
		}
	}
	
	public String makeXMLElement(String strElementText, String strElementName) {
		return "<"+strElementName+">"+strElementText+"</"+strElementName+">";
	}
	
	public boolean multiDelResData(String xmlStr) {
		String brdID = "";
		String companyID = "";
		
		try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			brdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
			companyID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();

			for (int i=0; i<brdID.split(",").length; i++) {
				delResData(brdID.split(",")[i], companyID);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean modifyResData(String xmlStr) {
		String strBrdID = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    
	    try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			strBrdID = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
			strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
			strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
			strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
			strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
			strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
			strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
			strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
			strResLocation = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
			strBrdExplain = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
			strCompanyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
			strApprove = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
			strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
			strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(13).getTextContent().trim();
			strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(14).getTextContent().trim();
			strOwnerPos2 = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
			
			modifyResData(strBrdID, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public boolean addResData(String xmlStr) {
		String strClassGB = "";
		String strODeptID = "";
		String strODeptNm = "";
		String strOwnerID = "";
		String strOwnerNm = "";
		String strOwnerPos = "";
	    String strOwnerCall = "";
	    String strBrdNm = "";
	    String strResLocation = "";
	    String strBrdExplain = "";
	    String strCompanyID = "";
	    String strApprove = "";
	    String strBrdNm2 = "";
	    String strODeptNm2 = "";
	    String strOwnerNm2 = "";
	    String strOwnerPos2 = "";
	    
	    try {
			Document xmlRes = commonUtil.convertStringToDocument(xmlStr);
			strClassGB = xmlRes.getElementsByTagName("DATA").item(0).getTextContent().trim();
			strODeptID = xmlRes.getElementsByTagName("DATA").item(1).getTextContent().trim();
			strODeptNm = xmlRes.getElementsByTagName("DATA").item(2).getTextContent().trim();
			strOwnerID = xmlRes.getElementsByTagName("DATA").item(3).getTextContent().trim();
			strOwnerNm = xmlRes.getElementsByTagName("DATA").item(4).getTextContent().trim();
			strOwnerPos = xmlRes.getElementsByTagName("DATA").item(5).getTextContent().trim();
			strOwnerCall = xmlRes.getElementsByTagName("DATA").item(6).getTextContent().trim();
			strBrdNm = xmlRes.getElementsByTagName("DATA").item(7).getTextContent().trim();
			strResLocation = xmlRes.getElementsByTagName("DATA").item(8).getTextContent().trim();
			strBrdExplain = xmlRes.getElementsByTagName("DATA").item(9).getTextContent().trim();
			strCompanyID = xmlRes.getElementsByTagName("DATA").item(10).getTextContent().trim();
			strApprove = xmlRes.getElementsByTagName("DATA").item(11).getTextContent().trim();
			strBrdNm2 = xmlRes.getElementsByTagName("DATA").item(12).getTextContent().trim();
			strODeptNm2 = xmlRes.getElementsByTagName("DATA").item(13).getTextContent().trim();
			strOwnerNm2 = xmlRes.getElementsByTagName("DATA").item(14).getTextContent().trim();
			strOwnerPos2 = xmlRes.getElementsByTagName("DATA").item(15).getTextContent().trim();
			
			addResData(strClassGB, strODeptID, strODeptNm, strOwnerID, strOwnerNm, strOwnerPos, strOwnerCall, strBrdNm, strResLocation, strBrdExplain, strCompanyID, strApprove, strBrdNm2, strODeptNm2, strOwnerNm2, strOwnerPos2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return true;
	}

	public String updateScheduleDateTime(String xmlStr, String companyID) throws Exception {
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String ownerID = xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent();
		String sDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String eDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

		updateScheduleDateTime(Integer.parseInt(num), ownerID, companyID, sDate, eDate);
		return xmlStr;
	}
}

