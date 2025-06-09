package egovframework.ezEKP.ezResource.web;

import java.awt.image.BufferedImage;
import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.imageio.ImageIO;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.util.CellRangeAddress;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezNotification.service.EzNotificationService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezPersonal.service.EzPersonalService;
import egovframework.ezEKP.ezPersonal.type.NotiPlatform;
import egovframework.ezEKP.ezPersonal.type.NotiType;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResFavoriteCategoryVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleRepetitionVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResOccuVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.ezEKP.ezSchedule.vo.ScheduleConfigVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 자원관리
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.19    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzResourceController extends EgovFileMngUtil {
	
	private static final Logger logger = LoggerFactory.getLogger(EzResourceController.class);
	
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="loginService")
	private LoginService loginService;

	@Resource(name="crypto") 
	private EgovFileScrty egovFileScrty;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="EzEmailService")
	private EzEmailService ezEmailService;
	
	@Resource(name="EzScheduleService")
	private EzScheduleService ezScheduleService;
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;
	
	@Resource(name="EzResourceAdminService")
	private EzResourceAdminService ezResourceAdminService;
	
	@Resource(name="EzNotificationService")
	private EzNotificationService ezNotificationService;
	
	@Resource(name="EzPersonalService")
	private EzPersonalService ezPersonalService;
	
	/**
	 * 자원관리 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/resMain.do", method = RequestMethod.GET)
	public String resMain(HttpServletRequest req, Model model) throws Exception {
		String brdID = "";
		String brdNm = "";
		String brdTopPath = "";
		String pUrl = "";
		String url = "/ezResource/leftResource.do";
		String leftFrameWidth = "220";
		int width = 0;
		
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if(req.getParameter("brdNm") != null) {
			 brdNm = req.getParameter("brdnm");
		}
		if(req.getParameter("brdPath") != null) {
			brdTopPath = req.getParameter("brdpath");
		}
		
		if(brdID.equals("")) {
			if(brdTopPath.equals("B")) {
				pUrl = url + "?boardGbn=" + brdTopPath;
			} else {
				pUrl = url;
			} 
		} else {
			pUrl = url + "?brdID=" + brdID + "&brdNm=" + brdNm + "&boardGbn=M";
		}

		if (req.getParameter("__wwidth") != null) {
			String widthParam = req.getParameter("__wwidth");

			try {
				width = Integer.parseInt(widthParam);

				leftFrameWidth = width < 1180 ? "0" : "220";
			} catch (NumberFormatException e) {
				width = 0;
			}
		}
		
		model.addAttribute("pUrl", pUrl);
		model.addAttribute("leftFrameWidth", leftFrameWidth);
		
		return "/ezResource/resMain";
	}
	
	/**
	 * 자원관리 좌측메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/leftResource.do", method = RequestMethod.GET)
	public String resLeftResource(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
	    String brdNm = "";
	    String brdGubun = "";
	    //String brdGbn = "";
	    String strAccessCode = "";
	    String selectNo = "";
	    
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if(req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		
		if(req.getParameter("boardGbn") != null) {
			brdGubun = req.getParameter("boardGbn");
		}
		
		/*if(req.getParameter("boardGbn") != null) {
			brdGbn = req.getParameter("boardGbn");
		}*/
		
		//관리자체크
		//if(userInfo.get) {
		//}
		//관리자면 0
		strAccessCode = "0";
		//사용자면 2
		//strAccessCode = "2";
		
		if(req.getParameter("flag") != null) {
			selectNo = req.getParameter("flag");
		}
		
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdGubun", brdGubun);
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("deptPathCode", userInfo.getDeptPathCode());
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("strAccessCode", strAccessCode);
		model.addAttribute("selectNo", selectNo);
		model.addAttribute("serverName", req.getServerName());
		
		return "/ezResource/resLeftResource";
	}
	
	/**
	 * 자원관리 정보 호출 함수
	 */
	@RequestMapping(value = "/ezResource/callNodeTreeData.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callNodeTreeData(@RequestBody String xmlReq,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("callNodeTreeData started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String selectFlag = "";
		
		if(req.getParameter("flag") != null) {
			selectFlag = req.getParameter("flag");
		}
		
		String ret = ezResourceService.getSubClsTree(xmlReq, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
		Document xmlRet = commonUtil.convertStringToDocument(ret);
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes6 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes7 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA10", xmlRet, XPathConstants.NODESET);
		
		NodeList nodes8 = (NodeList)xpath.evaluate("NODES/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes9 = (NodeList)xpath.evaluate("NODES/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes10 = (NodeList)xpath.evaluate("NODES/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes11 = (NodeList)xpath.evaluate("NODES/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes12 = (NodeList)xpath.evaluate("NODES/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes13 = (NodeList)xpath.evaluate("NODES/NODE/DATA10", xmlRet, XPathConstants.NODESET);
		
		if(nodes.getLength() != 0) {
			for(int i=0; i<nodes.getLength(); i++) {
				nodes.item(i).setTextContent("TRUE");
				nodes1.item(i).removeChild((Node) nodes4.item(i));
				
				if(nodes2.item(0).getTextContent() == null || nodes2.item(0).getTextContent().equals("")) {
					nodes2.item(0).setTextContent("<![CDATA[]]>");
				}
				if(nodes5.item(i).getTextContent() == null || nodes5.item(i).getTextContent().equals("")) {
					nodes5.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes6.item(i).getTextContent() == null || nodes6.item(i).getTextContent().equals("")) {
					nodes6.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes7.item(i).getTextContent() == null || nodes7.item(i).getTextContent().equals("")) {
					nodes7.item(i).setTextContent("<![CDATA[]]>");
				}
				
				
				if(selectFlag.equals("SELECT_NO")) {
					if(nodes2.item(i) != null) {
						//NodeList nodes3 = (NodeList) xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);  
						nodes1.item(i).removeChild((Node)nodes2.item(0));
					}
				}
			}
		}
		
		
		if (nodes8 != null && nodes10 != null) {
			for (int i=0; i<nodes8.getLength(); i++) {
				nodes8.item(i).setTextContent("TRUE");
				nodes9.item(i).removeChild((Node)nodes10.item(i));
				if(nodes11.item(i).getTextContent().equals("")) {
					nodes11.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes12.item(i).getTextContent().equals("")) {
					nodes12.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes13.item(i).getTextContent().equals("")) {
					nodes13.item(i).setTextContent("<![CDATA[]]>");
				}
			}
		}
		

		logger.debug("callNodeTreeData ended");
		return commonUtil.convertDocumentToString(xmlRet).replace("&lt;", "<").replace("&gt;", ">");
	
	}
	
	/**
	 * 스케줄 정보 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleGet.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGet(@RequestBody String xmlStr, HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("scheduleGet Start");
		logger.debug("xmlStr=" + xmlStr);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String reVal = "";
		String resID = "";
		String cmd = "";
		String type = "";
		String viewType = "";
		String approveFlag = "";
		String returnFlag = "";
		String writerName = "";
		String writerDept = "";
		String gubun = "P";
		String groupID = "";
		String resultXML = "";
		String resultXML1 = "";
		String title = "";
		int page = 0;
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		if (req.getParameter("cmd") != null) {
			cmd = req.getParameter("cmd");
		}
		if (req.getParameter("pType") != null) {
			type = req.getParameter("pType");
		}
		if (req.getParameter("viewType") != null) {
			viewType = req.getParameter("viewType");
		}
		if (req.getParameter("page") != null) {
			page = Integer.parseInt(req.getParameter("page"));
		}
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		if (cmd.equals("get")) {
			
			// 승인요청 목록으로 볼 때
			if (viewType.equals("list")) {
				approveFlag = xmlDom.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
				writerName = xmlDom.getElementsByTagName("WRITERNAME").item(0).getTextContent();
				writerDept = xmlDom.getElementsByTagName("WRITERDEPT").item(0).getTextContent();
				returnFlag = xmlDom.getElementsByTagName("RETURNFLAG").item(0).getTextContent();
				title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent();
			}
			
			// 시분초 버림.
			// 2023-05-25 이사라 : 시큐어코딩 문자열 비교 오류 수정
			if(StringUtils.isEmpty(xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent())) {
				return "";
			} else if(StringUtils.isEmpty(xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent())) {
				return "";
			}
			
			xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent().substring(0, 10));
			xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent().substring(0, 10));

			String lang = commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId());
			//스케줄 정보 가져옴
			reVal = ezResourceService.getScheduleXML(commonUtil.convertDocumentToString(xmlDom), resID, userInfo.getCompanyID(), groupID, gubun, type, title, writerName, writerDept, userInfo.getTenantId(), userInfo.getOffset(), lang);
			logger.debug("getScheduleXML=" + reVal);
			
			// date타입 변경
			Document xmlDom2 = commonUtil.convertStringToDocument(reVal);
				
			for (int i=0; i<xmlDom2.getDocumentElement().getChildNodes().getLength(); i++) {
				
				String sDate = EgovDateUtil.convertDate(xmlDom2.getElementsByTagName("dtstart").item(i).getTextContent(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd'T'HH:mm:ss.000'Z'", "");
				String eDate = EgovDateUtil.convertDate(xmlDom2.getElementsByTagName("dtend").item(i).getTextContent(), "yyyy-MM-dd HH:mm", "yyyy-MM-dd'T'HH:mm:ss.000'Z'", "");

				xmlDom2.getElementsByTagName("dtstart").item(i).setTextContent(sDate);
				xmlDom2.getElementsByTagName("dtend").item(i).setTextContent(eDate);
			}
				
			reVal = commonUtil.convertDocumentToString(xmlDom2);
			
			
			// 승인요청 목록으로 볼 때
			if (viewType.equals("list")) {
				Document orderXML = commonUtil.convertStringToDocument(reVal);
					
				// 승인 or 비승인 보기 => 승인 / 승인대기 / 승인거부 / 반납 / 미반납 으로 분류하기
				if (!approveFlag.trim().equals("")) {
					resultXML += "<root>";
					for (int i=0; i<orderXML.getElementsByTagName("appointment").getLength(); i++) {
						if (orderXML.getElementsByTagName("approveFlag").item(i).getTextContent().equals(approveFlag)) {
							resultXML += "<appointment>";
							resultXML += "<number>"+orderXML.getElementsByTagName("number").item(i).getTextContent()+"</number>";
							resultXML += "<pnumber>"+orderXML.getElementsByTagName("pnumber").item(i).getTextContent()+"</pnumber>";
							resultXML += "<owner_id>"+orderXML.getElementsByTagName("owner_id").item(i).getTextContent()+"</owner_id>";
							resultXML += "<writer_id>"+orderXML.getElementsByTagName("writer_id").item(i).getTextContent()+"</writer_id>";
							resultXML += "<subject>"+"<![CDATA["+orderXML.getElementsByTagName("subject").item(i).getTextContent()+"]]></subject>";
							resultXML += "<instancetype>"+orderXML.getElementsByTagName("instancetype").item(i).getTextContent()+"</instancetype>";
							resultXML += "<location>"+orderXML.getElementsByTagName("location").item(i).getTextContent()+"</location>";
							resultXML += "<dtstart>"+orderXML.getElementsByTagName("dtstart").item(i).getTextContent()+"</dtstart>";
							resultXML += "<dtend>"+orderXML.getElementsByTagName("dtend").item(i).getTextContent()+"</dtend>";
							resultXML += "<dstartTime>"+orderXML.getElementsByTagName("dstartTime").item(i).getTextContent()+"</dstartTime>";
							resultXML += "<dendTime>"+orderXML.getElementsByTagName("dendTime").item(i).getTextContent()+"</dendTime>";
							resultXML += "<dsDaytype>"+orderXML.getElementsByTagName("dsDaytype").item(i).getTextContent()+"</dsDaytype>";
							resultXML += "<deDaytype>"+orderXML.getElementsByTagName("deDaytype").item(i).getTextContent()+"</deDaytype>";
							resultXML += "<alldayevent>"+orderXML.getElementsByTagName("alldayevent").item(i).getTextContent()+"</alldayevent>";
							resultXML += "<busystatus>"+orderXML.getElementsByTagName("busystatus").item(i).getTextContent()+"</busystatus>";
							resultXML += "<groupflag>"+orderXML.getElementsByTagName("groupflag").item(i).getTextContent()+"</groupflag>";
							resultXML += "<gubunFlag>"+orderXML.getElementsByTagName("gubunFlag").item(i).getTextContent()+"</gubunFlag>";
							resultXML += "<importance>"+orderXML.getElementsByTagName("importance").item(i).getTextContent()+"</importance>";
							resultXML += "<approveFlag>"+orderXML.getElementsByTagName("approveFlag").item(i).getTextContent()+"</approveFlag>";
							resultXML += "<returnFlag>"+orderXML.getElementsByTagName("returnFlag").item(i).getTextContent()+"</returnFlag>";
							resultXML += "<owner_nm>"+orderXML.getElementsByTagName("owner_nm").item(i).getTextContent()+"</owner_nm>";
							resultXML += "<dept_name>"+"<![CDATA["+ orderXML.getElementsByTagName("dept_name").item(i).getTextContent()+"]]></dept_name>";
							resultXML += "<writeDay>"+orderXML.getElementsByTagName("writeDay").item(i).getTextContent()+"</writeDay>";
							resultXML += "<owner_nm2>"+"</owner_nm2>";
							resultXML += "<dept_name2>"+"</dept_name2>";
							resultXML += "<jobtitle>"+"</jobtitle>";
							resultXML += "<jobtitle2>"+"</jobtitle2>";
							resultXML += "</appointment>";
						} 
					}
					resultXML += "</root>";
				} else if(!returnFlag.trim().equals("")) {
					resultXML += "<root>";
					for (int i=0; i<orderXML.getElementsByTagName("appointment").getLength(); i++) {
						if (orderXML.getElementsByTagName("returnFlag").item(i).getTextContent().equals(returnFlag)
								&& orderXML.getElementsByTagName("approveFlag").item(i).getTextContent().equals("1")) {
							resultXML += "<appointment>";
							resultXML += "<number>"+orderXML.getElementsByTagName("number").item(i).getTextContent()+"</number>";
							resultXML += "<pnumber>"+orderXML.getElementsByTagName("pnumber").item(i).getTextContent()+"</pnumber>";
							resultXML += "<owner_id>"+orderXML.getElementsByTagName("owner_id").item(i).getTextContent()+"</owner_id>";
							resultXML += "<writer_id>"+orderXML.getElementsByTagName("writer_id").item(i).getTextContent()+"</writer_id>";
							resultXML += "<subject>"+"<![CDATA["+orderXML.getElementsByTagName("subject").item(i).getTextContent()+"]]></subject>";
							resultXML += "<instancetype>"+orderXML.getElementsByTagName("instancetype").item(i).getTextContent()+"</instancetype>";
							resultXML += "<location>"+orderXML.getElementsByTagName("location").item(i).getTextContent()+"</location>";
							resultXML += "<dtstart>"+orderXML.getElementsByTagName("dtstart").item(i).getTextContent()+"</dtstart>";
							resultXML += "<dtend>"+orderXML.getElementsByTagName("dtend").item(i).getTextContent()+"</dtend>";
							resultXML += "<dstartTime>"+orderXML.getElementsByTagName("dstartTime").item(i).getTextContent()+"</dstartTime>";
							resultXML += "<dendTime>"+orderXML.getElementsByTagName("dendTime").item(i).getTextContent()+"</dendTime>";
							resultXML += "<dsDaytype>"+orderXML.getElementsByTagName("dsDaytype").item(i).getTextContent()+"</dsDaytype>";
							resultXML += "<deDaytype>"+orderXML.getElementsByTagName("deDaytype").item(i).getTextContent()+"</deDaytype>";
							resultXML += "<alldayevent>"+orderXML.getElementsByTagName("alldayevent").item(i).getTextContent()+"</alldayevent>";
							resultXML += "<busystatus>"+orderXML.getElementsByTagName("busystatus").item(i).getTextContent()+"</busystatus>";
							resultXML += "<groupflag>"+orderXML.getElementsByTagName("groupflag").item(i).getTextContent()+"</groupflag>";
							resultXML += "<gubunFlag>"+orderXML.getElementsByTagName("gubunFlag").item(i).getTextContent()+"</gubunFlag>";
							resultXML += "<importance>"+orderXML.getElementsByTagName("importance").item(i).getTextContent()+"</importance>";
							resultXML += "<approveFlag>"+orderXML.getElementsByTagName("approveFlag").item(i).getTextContent()+"</approveFlag>";
							resultXML += "<returnFlag>"+orderXML.getElementsByTagName("returnFlag").item(i).getTextContent()+"</returnFlag>";
							resultXML += "<owner_nm>"+orderXML.getElementsByTagName("owner_nm").item(i).getTextContent()+"</owner_nm>";
							resultXML += "<dept_name>"+"<![CDATA["+ orderXML.getElementsByTagName("dept_name").item(i).getTextContent()+"]]></dept_name>";
							resultXML += "<writeDay>"+orderXML.getElementsByTagName("writeDay").item(i).getTextContent()+"</writeDay>";
							resultXML += "<owner_nm2>"+"</owner_nm2>";
							resultXML += "<dept_name2>"+"</dept_name2>";
							resultXML += "<jobtitle>"+"</jobtitle>";
							resultXML += "<jobtitle2>"+"</jobtitle2>";
							resultXML += "</appointment>";
						} 
					}
					resultXML += "</root>";
				
				// 전체 보기
				} else {
					resultXML = commonUtil.convertDocumentToString(orderXML);
				}
					
					
				Document tempXML = commonUtil.convertStringToDocument(resultXML);
					
				for (int i=0; i<tempXML.getElementsByTagName("appointment").getLength(); i++) {
					Element count = tempXML.createElement("count");
					count.setTextContent(i + "");
					tempXML.getElementsByTagName("appointment").item(i).appendChild(count);
					
				}
//					for (int i=1; i<tempXML.getElementsByTagName("appointment").getLength(); i++) {
//							for (int j=1; j<tempXML.getElementsByTagName("appointment").getLength(); j++) {
								
//								String startTemp = tempXML.getElementsByTagName("dtstart").item(j-1).getTextContent().substring(0,4)+tempXML.getElementsByTagName("dtstart").item(j-1).getTextContent().substring(5,7)+tempXML.getElementsByTagName("dtstart").item(j-1).getTextContent().substring(8,10);
//								String endTemp = tempXML.getElementsByTagName("dtstart").item(j).getTextContent().substring(0,4)+tempXML.getElementsByTagName("dtstart").item(j).getTextContent().substring(5,7)+tempXML.getElementsByTagName("dtstart").item(j).getTextContent().substring(8,10);
//								int countArray[] = null;
//								String temp;
//	
//								if (Integer.parseInt(startTemp) > Integer.parseInt(endTemp)) {
									//tempXML.getElementsByTagName("appointment").item(j).appendChild(count);
//									temp = tempXML.getElementsByTagName("appointment").item(j).getTextContent();
//									tempXML.getElementsByTagName("appointment").item(j).setTextContent(tempXML.getElementsByTagName("appointment").item(j-1).getTextContent());
//									tempXML.getElementsByTagName("appointment").item(j-1).setTextContent(temp);
//								}
//							}
							//tempXML.getElementsByTagName("appointment").item(i).appendChild(count);	
//					}
					
					/*for (int i=0; i<tempXML.getElementsByTagName("appointment").getLength(); i++) {
						Element count = tempXML.createElement("count");
						count.setTextContent(i + "");
						
						
						}*/
						//tempXML.getElementsByTagName("appointment").item(i).appendChild(count);
					//}
					
					//tempXML = commonUtil.convertDocumentToString(orderXML);
					
					
				reVal = commonUtil.convertDocumentToString(tempXML);
					
				resultXML1 += "<root>";
				for (int i=0; i<tempXML.getElementsByTagName("appointment").getLength(); i++) {
					int startCount = Math.multiplyExact(Math.subtractExact(page, 1), 20);
					int endCount = Math.multiplyExact(page, 20);

					if (Integer.parseInt(tempXML.getElementsByTagName("count").item(i).getTextContent()) >= startCount && Integer.parseInt(tempXML.getElementsByTagName("count").item(i).getTextContent())< endCount) {
						resultXML1 += "<appointment>";
						resultXML1 += "<number>"+tempXML.getElementsByTagName("number").item(i).getTextContent()+"</number>";
						resultXML1 += "<pnumber>"+tempXML.getElementsByTagName("pnumber").item(i).getTextContent()+"</pnumber>";
						resultXML1 += "<owner_id>"+tempXML.getElementsByTagName("owner_id").item(i).getTextContent()+"</owner_id>";
						resultXML1 += "<writer_id>"+tempXML.getElementsByTagName("writer_id").item(i).getTextContent()+"</writer_id>";
						resultXML1 += "<subject>"+"<![CDATA["+tempXML.getElementsByTagName("subject").item(i).getTextContent()+"]]></subject>";
						resultXML1 += "<instancetype>"+tempXML.getElementsByTagName("instancetype").item(i).getTextContent()+"</instancetype>";
						resultXML1 += "<location>"+tempXML.getElementsByTagName("location").item(i).getTextContent()+"</location>";
						resultXML1 += "<dtstart>"+tempXML.getElementsByTagName("dtstart").item(i).getTextContent()+"</dtstart>";
						resultXML1 += "<dtend>"+tempXML.getElementsByTagName("dtend").item(i).getTextContent()+"</dtend>";
						resultXML1 += "<dstartTime>"+tempXML.getElementsByTagName("dstartTime").item(i).getTextContent()+"</dstartTime>";
						resultXML1 += "<dendTime>"+tempXML.getElementsByTagName("dendTime").item(i).getTextContent()+"</dendTime>";
						resultXML1 += "<dsDaytype>"+tempXML.getElementsByTagName("dsDaytype").item(i).getTextContent()+"</dsDaytype>";
						resultXML1 += "<deDaytype>"+tempXML.getElementsByTagName("deDaytype").item(i).getTextContent()+"</deDaytype>";
						resultXML1 += "<alldayevent>"+tempXML.getElementsByTagName("alldayevent").item(i).getTextContent()+"</alldayevent>";
						resultXML1 += "<busystatus>"+tempXML.getElementsByTagName("busystatus").item(i).getTextContent()+"</busystatus>";
						resultXML1 += "<groupflag>"+tempXML.getElementsByTagName("groupflag").item(i).getTextContent()+"</groupflag>";
						resultXML1 += "<gubunFlag>"+tempXML.getElementsByTagName("gubunFlag").item(i).getTextContent()+"</gubunFlag>";
						resultXML1 += "<importance>"+tempXML.getElementsByTagName("importance").item(i).getTextContent()+"</importance>";
						resultXML1 += "<approveFlag>"+tempXML.getElementsByTagName("approveFlag").item(i).getTextContent()+"</approveFlag>";
						resultXML1 += "<returnFlag>"+tempXML.getElementsByTagName("returnFlag").item(i).getTextContent()+"</returnFlag>";
						resultXML1 += "<owner_nm>"+tempXML.getElementsByTagName("owner_nm").item(i).getTextContent()+"</owner_nm>";
						resultXML1 += "<dept_name>"+"<![CDATA[" +tempXML.getElementsByTagName("dept_name").item(i).getTextContent()+"]]></dept_name>";
						resultXML1 += "<writeDay>"+tempXML.getElementsByTagName("writeDay").item(i).getTextContent()+"</writeDay>";
						resultXML1 += "<owner_nm2>"+"</owner_nm2>";
						resultXML1 += "<dept_name2>"+"</dept_name2>";
						resultXML1 += "<jobtitle>"+"</jobtitle>";
						resultXML1 += "<jobtitle2>"+"</jobtitle2>";
						/*resultXML1 += "<owner_nm2>"+tempXML.getElementsByTagName("owner_nm2").item(i).getTextContent()+"</owner_nm2>";
						resultXML1 += "<dept_name2>"+"<![CDATA["+tempXML.getElementsByTagName("dept_name2").item(i).getTextContent()+"]]></dept_name2>";
						resultXML1 += "<jobtitle>"+"<![CDATA["+tempXML.getElementsByTagName("jobtitle").item(i).getTextContent()+"]]></jobtitle>";
						resultXML1 += "<jobtitle2>"+"<![CDATA["+tempXML.getElementsByTagName("jobtitle2").item(i).getTextContent()+"]]></jobtitle2>";*/
						resultXML1 += "<count>"+tempXML.getElementsByTagName("count").item(i).getTextContent()+"</count>";
						resultXML1 += "</appointment>";
					}
				}
				resultXML1 += "<totalcount>"+tempXML.getElementsByTagName("appointment").getLength()+"</totalcount>";
				resultXML1 += "</root>";
				reVal = resultXML1;
			} else {
					
			}
				
		} else if (cmd.equals("update")) {
			reVal = ezResourceService.updateScheduleDateTime(commonUtil.convertDocumentToString(xmlDom), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		logger.debug("scheduleGet End");
		return reVal;
	}
	
	
	/**
	 * 자원관리 리스트2 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewResList2.do", method = RequestMethod.GET)
	public String viewResList2(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		logger.debug("viewResList2 Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String accessCode = "";
		String brdNm = "";
		int brdCount;
		String useEditor = "";
		String lang = userInfo.getLang();
		
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if(req.getParameter("accessCode") != null) {
			accessCode = req.getParameter("accessCode");
		}
		
		if(req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		
		String adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()); 
		logger.debug("adminFg="+adminFg);
		
		String adminCKFlag = "";
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k")) {
			adminCKFlag = "Y";
		}
		
		//brdNm = brdNm.replace("chr(38)", "&");
		StringBuilder childBrdBld = new StringBuilder();
		childBrdBld.append(ezResourceService.getItemList(loginCookie,brdID));
		logger.debug("childBrd=" + childBrdBld.toString());
		 
		List<ResGetItemListVO>	list = ezResourceService.getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		
		brdCount = list.size();
		
		logger.debug("brdCount=" + brdCount);
		
		for (int i = 0; i < brdCount; i++) {
			childBrdBld.append(list.get(i).getBrd_ID() + "/" + list.get(i).getBrd_Nm() + "/" + list.get(i).getApproveFlag() + "|");
		}
		
		ScheduleConfigVO scheduleConfigVO = ezScheduleService.getScheduleConfig(userInfo.getId(), userInfo.getTenantId());
		int startDay = scheduleConfigVO != null ? scheduleConfigVO.getStartDay() : 7;
		
		String lunarUse = ezScheduleService.scheduleGetLunarUse(userInfo.getCompanyID(), userInfo.getTenantId());
		
		model.addAttribute("childBrd", childBrdBld.toString());
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("accessCode", accessCode);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdCount", brdCount);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("startDay", startDay);
		model.addAttribute("lang", lang);
		model.addAttribute("lunarUse", lunarUse);
		model.addAttribute("adminCKFlag", adminCKFlag);
		
		logger.debug("viewResList2 End");
		return "/ezResource/resViewResList2";
	}
	
	/**
	 * 자원관리 리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewResList.do", method = RequestMethod.GET)
	public String viewResList(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		//String strXML = "";
		String brdID = "";
		String accessCode = "";
		String brdNm = "";
		String sortGbn = "";
		String curPage = "";
		String adminFg = "";
		//String chkCtrl = "";
		String selectedResourceId = "";
		int pageSize = 15;
		int totalCnt = 0;
		int totalPage = 0;
		int limitLine = 0;
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("accessCode") != null) {
			accessCode = req.getParameter("accessCode");
		}
		if (req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		if (req.getParameter("sortGbn") != null) {
			sortGbn = req.getParameter("sortGbn");
		}
		if (req.getParameter("goToPage") != null) {
			curPage = req.getParameter("goToPage");
		}
		if (req.getParameter("selectedResourceId") != null) {
			selectedResourceId = req.getParameter("selectedResourceId");
		}
		adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID());

		//brdNm = brdNm.replace(String.valueOf(38), "&");
		
		if (curPage.equals("") || Integer.parseInt(curPage.trim()) < 1) {
			curPage = "1";
		} 
		
		totalCnt = ezResourceService.getBrdCnt(Integer.parseInt(brdID), userInfo.getCompanyID(), userInfo.getTenantId());

		if (totalCnt > 0) {
			totalPage = totalCnt / pageSize;
		}
		if (totalCnt == pageSize) {
			limitLine = 15;
		} else {
			limitLine = totalCnt % pageSize;
			if (totalPage > 1 && limitLine == 0) {
				limitLine = 15;
			}
		}
		
		if (((totalPage * pageSize) != totalCnt) && ((totalCnt % pageSize) != 0)) {
			totalPage = totalPage + 1;
		}
		
		if (Integer.parseInt(curPage.trim()) > totalPage) {
			curPage = String.valueOf(totalPage);
		}
		if (Integer.parseInt(curPage.trim()) != totalPage) {
			limitLine = 15;
		} else if (totalCnt == 0) {
			curPage = "1";
			totalPage = 1;
		}
		
		int topCount = Math.multiplyExact(Integer.parseInt(curPage.trim()), pageSize);
		int start = Math.multiplyExact(Math.subtractExact(Integer.parseInt(curPage.trim()), 1), pageSize);
		
		/* 2024-07-05 홍승비 - SQL Injection 수정 > 다국어 칼럼은 쿼리 내부 분기로 처리 */
		List<ResBrdListVO> resBrdList =  ezResourceService.getBrdList(topCount, Integer.parseInt(brdID), userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
		
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdID", brdID);
		model.addAttribute("accessCode", accessCode);
		model.addAttribute("resBrdList", resBrdList);
		model.addAttribute("curPage", curPage);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("sortGbn", sortGbn);
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("start", start);
		model.addAttribute("selectedResourceId", selectedResourceId);
		
		return "/ezResource/resViewResList";
	}
	
	/**
	 * 자원관리 자원등록정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewClsItem.do", method = RequestMethod.GET)
	public String viewClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, HttpServletResponse resp, Model model, Locale locale) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String strBrdNm = "";
		String strOwnDeptNm = "";
		String strOwnerNm = "";
		String strOwnerPosition = "";
		String strBrdID = "";
		String strBrdExplain = "";
		String strResLocation = "";
		String strOwnDeptID = "";
		String ownerCall = "";
		String strOwnerID = "";
		String strMakeDate = "";
		String strApproveFlag = "";
		String strReturnFlag = "";
		// 반복예약허용 flag
		String strRepeatFlag = "";
		
		if (!req.getParameter("brdID").equals("")) {
			brdID = req.getParameter("brdID");
		}
		ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(brdID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		// 2018-10-30 김민성 - 자원 멀티관리자 데이터 처리
		String[] ownerList = resBrd.getOwnerID().split(",");
		List<OrganUserVO> ownerInfoList = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
		
		strBrdID = resBrd.getBrdID();
		strBrdExplain = resBrd.getBrdExplain();
		strResLocation = commonUtil.cleanValue(resBrd.getResLocation());		// 2018-11-16 김민성 - 자원위치 특수문자, 태그 처리
		strOwnDeptID = resBrd.getOwnDeptID();
		strOwnerID = ownerList[0];
		ownerCall = resBrd.getOwnerCall();
		
		if (userInfo.getPrimary().equals("1")) {
			strBrdNm = resBrd.getBrdNm();
			strOwnDeptNm = resBrd.getOwnDeptNm();
			strOwnerNm = resBrd.getOwnerNm();
			strOwnerPosition = resBrd.getOwnerPosition();
		} else {
			strBrdNm = resBrd.getBrdNm2();
			strOwnDeptNm = resBrd.getOwnDeptNm2();
			strOwnerNm = resBrd.getOwnerNm2();
			strOwnerPosition = resBrd.getOwnerPosition2();
		}
		strMakeDate = resBrd.getMakeDate();
		strApproveFlag = resBrd.getApproveFlag();
		strReturnFlag = resBrd.getReturnFlag();
		strRepeatFlag = resBrd.getRepeatFlag();
		
		List<String> attachList = ezResourceService.getAttachList(brdID, userInfo.getCompanyID(), userInfo.getTenantId());

		for(int i=0; i<attachList.size(); i++) {
			model.addAttribute("attachList"+(i+1), attachList.get(i));
		}
		
		/*if (strApproveFlag.equals("1")) {
			resp.getWriter().write("&nbsp;" + egovMessageSource.getMessage("ezQuestion.t161", locale));
		} else {
			resp.getWriter().write("&nbsp;" + egovMessageSource.getMessage("ezQuestion.t162", locale));
		}*/
			
	
		model.addAttribute("ownerList", ownerInfoList);
		model.addAttribute("strBrdID", strBrdID); 
		model.addAttribute("strBrdNm", strBrdNm);
		model.addAttribute("brdExplain", strBrdExplain);
		model.addAttribute("ownDeptNm", strOwnDeptNm);
		model.addAttribute("ownDeptID", strOwnDeptID);
		model.addAttribute("ownerID", strOwnerID);
		model.addAttribute("ownerNm", strOwnerNm);
		model.addAttribute("ownerPosition", strOwnerPosition);
		model.addAttribute("ownerCall", ownerCall);
		model.addAttribute("resLocation", strResLocation);
		model.addAttribute("makeDate", strMakeDate);
		model.addAttribute("approveFlag", strApproveFlag);
		model.addAttribute("returnFlag", strReturnFlag);
		model.addAttribute("repeatFlag", strRepeatFlag);
		
		return "/ezResource/resViewClsItem";
	}
	
	/**
	 * 자원관리 자원정보 삭제 호출 함수
	 */
	@RequestMapping(value = "/ezResource/callDelClsItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callDelClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, HttpServletResponse resp, Model model, @RequestBody String xmlDom) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String brdID = "";
		StringBuilder strXML = new StringBuilder();
		StringBuilder returnXML = new StringBuilder();
		String realPath = commonUtil.getRealPath(req);

		
		if (req.getParameter("brdID") != null && !req.getParameter("brdID").equals("")) {
			brdID = req.getParameter("brdID");
		}
			
		if (ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()).equals("Y")) {
			boolean returnValue = ezResourceService.multiDelResData(xmlDom, userInfo.getTenantId(), realPath);
			strXML.append("<RTN>"+ String.valueOf(returnValue) + "</RTN>");
			return strXML.toString();
		} else {
			returnXML.append("<RTN>False</RTN>");
			return returnXML.toString();
		}
	}
	
	/**
	 * 자원관리 자원정보 수정 화면 호출 함수
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezResource/modClsItem.do", method = RequestMethod.GET)
	public String modClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String resID = "";
		String strBrdNm = "";
		String strBrdNm2 = "";
		String strOwnDeptNm = "";
		String strOwnerNm = "";
		String strOwnerPosition = "";
		String strBrdID = "";
		String strBrdExplain = "";
		String strResLocation = "";
		String strOwnDeptID = "";
		String ownerCall = "";
		String strOwnerID = "";
		String strMakeDate = "";
		String strApproveFlag = "";
		String strReturnFlag = "";
		// 반복예약허용 flag
		String strRepeatFlag = "";
		List<OrganUserVO> ownerListVO;
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		
		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		if (ezResourceService.getAdminFlag(userInfo.getCompanyID(), resID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()).equals("Y")) {
			ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(brdID), userInfo.getCompanyID(), userInfo.getTenantId());
			
			// 2018-10-24 김민성 - 자원관리 관리자 조회
			String[] ownerList = resBrd.getOwnerID().split(",");
			if(ownerList.length != 0) {
				ownerListVO = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
				
				JSONArray jArray = new JSONArray();

				for (int i = 0; i < ownerListVO.size(); i++) {
			        JSONObject data= new JSONObject();
			        
			        data.put("ownerId", ownerListVO.get(i).getCn());
			        data.put("ownerDept", ownerListVO.get(i).getDepartment());
			        data.put("ownerName", ownerListVO.get(i).getDisplayName());
			        data.put("ownerName1", ownerListVO.get(i).getTitle());
			        data.put("ownerDeptName", ownerListVO.get(i).getDescription());
			        
			        jArray.add(i, data);
				}
				model.addAttribute("ownerList", jArray);
			}
			strBrdID = resBrd.getBrdID();
			strBrdExplain = resBrd.getBrdExplain();
			strResLocation = resBrd.getResLocation();
			strOwnDeptID = resBrd.getOwnDeptID();
			strOwnerID = ownerList[0];
			ownerCall = resBrd.getOwnerCall();
			
			strBrdNm = resBrd.getBrdNm();
			strBrdNm2 = resBrd.getBrdNm2();
			
			if (userInfo.getPrimary().equals("1")) {
				strOwnDeptNm = resBrd.getOwnDeptNm();
				strOwnerNm = resBrd.getOwnerNm();
				strOwnerPosition = resBrd.getOwnerPosition();
			} else {
				strOwnDeptNm = resBrd.getOwnDeptNm2();
				strOwnerNm = resBrd.getOwnerNm2();
				strOwnerPosition = resBrd.getOwnerPosition2();
			}
			
			strMakeDate = resBrd.getMakeDate();
			strApproveFlag = resBrd.getApproveFlag();
			strReturnFlag = resBrd.getReturnFlag();
			strRepeatFlag = resBrd.getRepeatFlag();
			
			List<String> attachList = ezResourceService.getAttachList(brdID, userInfo.getCompanyID(), userInfo.getTenantId());

			for(int i=0; i<attachList.size(); i++) {
				model.addAttribute("attachList"+(i+1), attachList.get(i));
			}
		}
		
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("userName", userInfo.getName());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("deptName", userInfo.getDeptName1());
		model.addAttribute("strBrdID", strBrdID); 
		model.addAttribute("strBrdNm", strBrdNm);
		model.addAttribute("strBrdNm2", strBrdNm2);
		model.addAttribute("brdExplain", strBrdExplain);
		model.addAttribute("ownDeptNm", strOwnDeptNm);
		model.addAttribute("ownDeptID", strOwnDeptID);
		model.addAttribute("ownerID", strOwnerID);
		model.addAttribute("ownerNm", strOwnerNm);
		model.addAttribute("ownerPosition", strOwnerPosition);
		model.addAttribute("ownerCall", ownerCall);
		model.addAttribute("resLocation", strResLocation);
		model.addAttribute("makeDate", strMakeDate);
		model.addAttribute("approveFlag", strApproveFlag);
		model.addAttribute("langPrimary", ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("langSecondary", ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("strResID", resID); 
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		model.addAttribute("returnFlag", strReturnFlag);
		model.addAttribute("repeatFlag", strRepeatFlag);
		
		return "/ezResource/resModClsItem";
	}
	
	/**
	 * 자원관리 자원정보 수정 실행 함수
	 */
	@RequestMapping(value = "/ezResource/callModClsItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callModClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model, @RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String ownerList = xmlDom.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String strOwnerID = ownerList.split(",")[0];
		String propList = "displayName1;displayName2;title1;title2;description1;description2";
		String infoXML = ezOrganService.getPropertyList(strOwnerID, propList, userInfo.getPrimary(), userInfo.getTenantId());
		
		Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
		String deptName = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		String deptName2 = xmlDom2.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
		String displayName = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
		String displayName2 = xmlDom2.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		String title = xmlDom2.getElementsByTagName("TITLE1").item(0).getTextContent();
		String title2 = xmlDom2.getElementsByTagName("TITLE2").item(0).getTextContent();
		
		String realPath = commonUtil.getRealPath(req);
		
		xmlDom.getElementsByTagName("DATA").item(2).setTextContent(deptName);
		xmlDom.getElementsByTagName("DATA").item(4).setTextContent(displayName);
		xmlDom.getElementsByTagName("DATA").item(5).setTextContent(title);
		
		Node data1 = xmlDom.createElement("DATA");
		data1.setTextContent(deptName2);
		
		Node data2 = xmlDom.createElement("DATA");
		data2.setTextContent(displayName2);
		
		Node data3 = xmlDom.createElement("DATA");
		data3.setTextContent(title2);
		
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data1);
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data2);
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data3);
		
		// 자원 이미지 조회 추가
		Node data4 = xmlDom.createElement("DATA");
		data4.setTextContent(realPath);
		
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data4);
		
		boolean returnValue = ezResourceService.modifyResData(commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId());
		
		StringBuilder strXML = new StringBuilder();
		strXML.append("<RTN>" + String.valueOf(returnValue) + "</RTN>");
		return strXML.toString();
		
	}
	
	/**
	 * 자원관리 자원 추가 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/addClsItem.do", method = RequestMethod.GET)
	public String addClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		
		if (!req.getParameter("brdID").equals("")) {
			brdID = req.getParameter("brdID");
		}

		String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
		
		String lang = userInfo.getLang();
		
		if (attachFileNameMaxLength.equals("")) {
			attachFileNameMaxLength = "100";
		}
		
		model.addAttribute("brdID", brdID);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("userName", userInfo.getName());
		
		if (lang.equals("1")) {
			model.addAttribute("displayName", userInfo.getDisplayName1());
			model.addAttribute("deptName", userInfo.getDeptName1());
			model.addAttribute("title", userInfo.getTitle1());
		} else {
			model.addAttribute("displayName", userInfo.getDisplayName2());
			model.addAttribute("deptName", userInfo.getDeptName2());
			model.addAttribute("title", userInfo.getTitle2());
		}
		
		model.addAttribute("ownerCall", userInfo.getPhone());
		model.addAttribute("makeDate", EgovDateUtil.getTodayTime().substring(0, 10));
		model.addAttribute("langPrimary", ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("langSecondary", ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
		
		return "/ezResource/resAddClsItem";
	}
	
	/**
	 * 자원관리 자원 추가 실행 함수
	 */
	@RequestMapping(value = "/ezResource/callAddClsItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callAddClsItem(@CookieValue("loginCookie") String loginCookie, Model model, @RequestBody String xmlStr, HttpServletRequest request) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Locale locale = userInfo.getLocale();
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);

		String ownerList = xmlDom.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String strOwnerID = ownerList.split(",")[0];
		String deptID = xmlDom.getElementsByTagName("DATA").item(1).getTextContent().trim();		// 부서ID
		
		String propList = "displayName1;displayName2;title1;title2;description1;description2;department";
		String infoXML = ezOrganService.getPropertyList(strOwnerID, propList, userInfo.getPrimary(), userInfo.getTenantId());
		
		String deptName = "";
		String deptName2 = "";
		String displayName = "";
		String displayName2 = "";
		String title = "";
		String title2 = "";
		
		String realPath = commonUtil.getRealPath(request);
		
		// 2018-07-09 김민성 자원 등록시 사간 겸직 구분
		Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
		displayName = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
		displayName2 = xmlDom2.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		
		if(deptID.equals(xmlDom2.getElementsByTagName("DEPARTMENT").item(0).getTextContent())) {
			deptName = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
			deptName2 = xmlDom2.getElementsByTagName("DESCRIPTION2").item(0).getTextContent();
			title = xmlDom2.getElementsByTagName("TITLE1").item(0).getTextContent();
			title2 = xmlDom2.getElementsByTagName("TITLE2").item(0).getTextContent();
		}
		else {
			String infoXML2 = ezOrganService.getUserAddjobInfo(strOwnerID, deptID, userInfo.getPrimary(), userInfo.getTenantId());
			Document xmlDom3 = commonUtil.convertStringToDocument(infoXML2);
			deptName = xmlDom3.getElementsByTagName("DISPLAYNAME").item(0).getTextContent();
			title = xmlDom3.getElementsByTagName("TITLE").item(0).getTextContent();
		}
		
		xmlDom.getElementsByTagName("DATA").item(2).setTextContent(deptName);
		xmlDom.getElementsByTagName("DATA").item(4).setTextContent(displayName);
		xmlDom.getElementsByTagName("DATA").item(5).setTextContent(title);
		
		Node data1 = xmlDom.createElement("DATA");
		data1.setTextContent(deptName2);
		
		Node data2 = xmlDom.createElement("DATA");
		data2.setTextContent(displayName2);
		
		Node data3 = xmlDom.createElement("DATA");
		data3.setTextContent(title2);
		
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data1);
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data2);
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data3);
		
		// 자원 이미지 조회 추가
		Node data4 = xmlDom.createElement("DATA");
		data4.setTextContent(realPath);
		
		xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data4);
		
		boolean returnValue = ezResourceService.addResData(commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId(),locale);
		
		StringBuilder strXML = new StringBuilder();
		strXML.append("<RTN>" + String.valueOf(returnValue) + "</RTN>");
		return strXML.toString();
	
	}
	
	/**
	 * 자원관리 자원 등록 조직도 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/selectPerson.do", method = RequestMethod.GET) 
	public String selectPerson(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useOCS = "";
		String userLang = "";
		
		//임시
		useOCS = config.getProperty("config.USE_OCS");
		userLang = userInfo.getPrimary();
		
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("userLang", userLang);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("serverName", req.getServerName());
		
		return "/ezResource/resSelectPerson";
	}
	
	/**
	 * 자원관리 부서이름 체크 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/checkDeptName.do", method = RequestMethod.GET)
	public String checkDeptName() throws Exception {
		return "/ezResource/resCheckDeptName";
	}
	
	/**
	 * 자원관리 메인화면 자원정보 레이어팝업 2017-12-13 장진혁
	 */
	@RequestMapping(value = "/ezResource/scheduleResourceData.do", method = RequestMethod.GET)
	public String scheduleResourceData(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String resID = req.getParameter("resourceId");

		// 2018-10-23 김민성 - 자원 관리자 정보 처리
		ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		String[] ownerList = resBrd.getOwnerID().split(",");
		
		List<OrganUserVO> ownerListVO = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
		
		resBrd.setOwnerID(ownerList[0]);
		
		model.addAttribute("ownerList", ownerListVO);
		model.addAttribute("primary", userInfo.getPrimary());
		model.addAttribute("resBrd", resBrd);
		
		// 첨부파일 리스트
		List<String> attachList = ezResourceService.getAttachList(resID, userInfo.getCompanyID(), userInfo.getTenantId());

		for(int i=0; i<attachList.size(); i++) {
			model.addAttribute("attachList"+(i+1), attachList.get(i));
		}
		return "json";
	}	
	
	/**
	 * 자원관리 자원 일정 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleMain.do", method = RequestMethod.GET)
	public String scheduleMain(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String resID = "";
		String strBrdNm = "";
		String strOwnDeptNm = "";
		String strOwnerNm = "";
		String strOwnerPosition = "";
		//String cUserIDStr = "";
		//String currentUserID = "";
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		
		ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("1")) {
			strBrdNm = resBrd.getBrdNm().trim();
			strOwnDeptNm = resBrd.getOwnDeptNm();
			strOwnerNm = resBrd.getOwnerNm();
			strOwnerPosition = resBrd.getOwnerPosition();
		} else {
			strBrdNm = resBrd.getBrdNm2().trim();
			strOwnDeptNm = resBrd.getOwnDeptNm2();
			strOwnerNm = resBrd.getOwnerNm2();
			strOwnerPosition = resBrd.getOwnerPosition2();
		}
		
		//String strBrdID = resBrd.getBrdID();
		String strBrdExplain = resBrd.getBrdExplain();
		String strResLocation = resBrd.getResLocation();
		//String strOwnDeptID = resBrd.getOwnDeptID();
		String strOwnerID = resBrd.getOwnerID().split(",")[0];
		//String strOwnerCall = resBrd.getOwnerCall();
		//String strMakeDate = ezResourceService.getLocalTime(resBrd.getMakeDate() + " " + EgovDateUtil.getCurrentDate("HH:mm:ss"));
		String strApproveFlag = resBrd.getApproveFlag();
		String strOwnerCall = resBrd.getOwnerCall();
		String strBrdAccess = resBrd.getBrdAccess();
		String strReturnFlag = resBrd.getReturnFlag();
		String pAdminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "everyone", userInfo.getTenantId(), userInfo.getDeptID());
		
		String[] OwnerList = strOwnerID.split(",");
		for(int i=1; i<OwnerList.length; i++) {
			if(OwnerList[i].equals(userInfo.getId())) {
				pAdminFg = "Y";
			}
		}
		
		String adminCKFlag = "";
		if (commonUtil.isAdmin(userInfo.getId(), userInfo.getTenantId(), userInfo.getRollInfo(), "c;k")) {
			adminCKFlag = "Y";
		}
		
		/*if (req.getParameter("cuid") != null) {
			cUserIDStr = req.getParameter("cuid");
		}*/
		
		/*if (cUserIDStr.equals("")) {
			currentUserID = userInfo.getId();
		} else {
			currentUserID = cUserIDStr;
		}*/
		
		String displaySTime = "9";
		String displayETime = "18";
		
		String pOffset = userInfo.getOffset().split("\\|")[1];
		int timeZoneStr = (Integer.parseInt(pOffset.split(":")[0]) * 60) + Integer.parseInt(pOffset.split(":")[1]);
		
		ScheduleConfigVO scheduleConfigVO = ezScheduleService.getScheduleConfig(userInfo.getId(), userInfo.getTenantId());
		int startDay = 0;
		
		if (scheduleConfigVO != null) {
			startDay = scheduleConfigVO.getStartDay();
		} else {
			startDay = 7;
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("resID", resID);
		model.addAttribute("ownerID", strOwnerID);
		model.addAttribute("ownerNm", strOwnerNm);
		model.addAttribute("ownerPosition", strOwnerPosition);
		model.addAttribute("ownerDeptNm", strOwnDeptNm);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("approveFlag", strApproveFlag);
		model.addAttribute("returnFlag", strReturnFlag);
		model.addAttribute("brdNm", strBrdNm);
		model.addAttribute("brdAccess", strBrdAccess);
		model.addAttribute("displaySTime", displaySTime);
		model.addAttribute("displayETime", displayETime);
		model.addAttribute("nonActiveX", "YES");
		model.addAttribute("adminFg", pAdminFg);
		model.addAttribute("resLocation", strResLocation);
		model.addAttribute("ownerCall", strOwnerCall);
		model.addAttribute("brdExplain", strBrdExplain);
		model.addAttribute("timeZoneStr", timeZoneStr);
		model.addAttribute("startDay", startDay);
		model.addAttribute("adminCKFlag", adminCKFlag);
		
		return "/ezResource/resScheduleMain";
	}
	
	/**
	 * 자원관리 자원 일정 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/portletResourceInfo.do", method = RequestMethod.GET)
	public String portletResourceInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model, Locale locale) throws Exception {
		logger.debug("portletResourceInfo Start");
		String ownerID = req.getParameter("ownerID");
		
		model.addAttribute("ownerID", ownerID);
		logger.debug("portletResourceInfo Start");
		return "/ezResource/resPortletInfo";
	}
	
	/**
	 * 자원관리 자원 일정 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = {"/ezResource/scheduleRead.do", "/ezResource/persPortletRead.do"}, method = RequestMethod.GET)
	public String scheduleRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model, Locale locale) throws Exception {
		logger.debug("scheduleRead Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String editor = config.getProperty("EDITOR");
		String nonActiveX = "YES";
		String resID = "";
		String brdName = "";
		String cmdStr = "";
		String fromStr = "";
		String dayView = "";
		String orgNum = "";
		String orgOwnerID = "";
		String typeVal = "";
		String startDateVal = "";
		String endDateVal = "";
		String deptNm = "";
		String ownerNm = "";
		String title = "";
		String loc = "";
		String importance = "";
		String gresFlag = "0";
		String reFlag = "";
		String startDateTime = "";
		String endDateTime = "";
		String timeDisplay = "";
		String content = "";
		String ownerID = "";
		String writerID = "";
		String checkSDT = "";
		String checkEDT = "";
		String allDay = "";
		String pNum = "";
		String num = "";
		String saveApproveFlag = "";
		String entryList = "";
		String startDateTimeRepeat = "";
		String endDateTimeRepeat = "";
		String deptID = "";
		String brdReturnFlag = "";
		String returnFlag = "";
		
		if (req.getParameter("ownerID") != null) {
			resID = req.getParameter("ownerID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("resrc", userInfo);
		}

		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "", userInfo.getTenantId(), userInfo.getDeptID());

		String brdApproveFlag = ezResourceService.getBrdApproveFlag(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (req.getParameter("cmd") != null) {
			cmdStr = req.getParameter("cmd");
		}
		if (req.getParameter("from") != null) {
			fromStr = req.getParameter("from");
		}
		if (req.getParameter("dayView") != null) {
			dayView = req.getParameter("dayView");
		}
		if (cmdStr.equals("mod")) {
			if (req.getParameter("num") != null) {
				orgNum = req.getParameter("num").trim();
			}
			if (req.getParameter("ownerID") != null) {
				orgOwnerID = req.getParameter("ownerID").trim();
			}
			if (req.getParameter("type") != null) {
				typeVal = req.getParameter("type").trim();
			}
			if (req.getParameter("startDate") != null) {
				startDateVal = req.getParameter("startDate").trim();
			}
			if (req.getParameter("endDate") != null) {
				endDateVal = req.getParameter("endDate").trim();
			}
			ResGetScheduleVO getSchedule = new ResGetScheduleVO();
			
			if (typeVal.equals("Master") || typeVal.equals("Readonly")) {
				getSchedule = ezResourceService.getSchedule(Integer.parseInt(orgNum), orgOwnerID, userInfo.getCompanyID(), userInfo.getTenantId(), commonUtil.getPrimaryData(userInfo.getLang(), userInfo.getTenantId()));
			}

			if (getSchedule == null) {
				return "cmm/error/noData";
			}
			
			num = String.valueOf(getSchedule.getNum());
			pNum = String.valueOf(getSchedule.getpNum());
			ownerID = getSchedule.getOwnerID();
			writerID = getSchedule.getWriterID();
			
			// 2018-07-09 김민성 - 겸직 정보 처리
			deptNm = getSchedule.getDeptNm();
			ownerNm = getSchedule.getOwnerNm();
			deptID = ezResourceService.getDeptID(writerID, deptNm, userInfo.getTenantId(), userInfo.getCompanyID());
			
			/*String propList = "displayName;description";
			String infoXML = ezOrganService.getPropertyList(writerID, propList, userInfo.getPrimary(), userInfo.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
			
			if (userInfo.getPrimary().equals("1")) {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
			} else {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION" + userInfo.getPrimary()).item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME" + userInfo.getPrimary()).item(0).getTextContent();
			}*/
			
			title = getSchedule.getTitle();
			loc = getSchedule.getLocation();
			
			startDateTime = commonUtil.getDateStringInUTC(getSchedule.getStartDate(), userInfo.getOffset(), false);
			endDateTime = commonUtil.getDateStringInUTC(getSchedule.getEndDate(), userInfo.getOffset(), false);
			
			timeDisplay = getSchedule.getTimeDisplay();
			reFlag = getSchedule.getReFlag();
			gresFlag = getSchedule.getGresFlag();
			content = getSchedule.getContent();
			importance = getSchedule.getImportance();
			
			if (importance.equals("")) {
				importance = "2";
			}
			
			entryList = getSchedule.getEntryList();
			allDay = getSchedule.getAllDay();
			saveApproveFlag = getSchedule.getApproveFlag();
			returnFlag = getSchedule.getReturnFlag();
			
			ResGetScheduleRepetitionVO repDateTimes = ezResourceService.getRepDateTimes(orgOwnerID, userInfo.getCompanyID(), Integer.parseInt(orgNum), userInfo.getTenantId());
			if (repDateTimes != null) {
				startDateTimeRepeat = commonUtil.getDateStringInUTC(repDateTimes.getStartDateTime(), userInfo.getOffset(), false);
				endDateTimeRepeat = commonUtil.getDateStringInUTC(repDateTimes.getEndDateTime(), userInfo.getOffset(), false);
			}
			
		} else {
			importance = "2";
			
			String cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
			String cTime = cDate.split(" ")[1].substring(0, 2);
			
			if (req.getParameter("startDate") != null) {
				cDate = req.getParameter("startDate");
			}
			cDate = cDate.substring(0, 10);
			startDateTime = cDate + " " + cTime + ":00:00";
			
			if (req.getParameter("endDate") != null) {
				cDate = req.getParameter("endDate");
			}
			cDate = cDate.substring(0, 10);
			endDateTime = cDate + " " + cTime + ":30:00";
			
			if (req.getParameter("ownerID") != null) {
				ownerID = req.getParameter("ownerID");
			}
		}
		
		ResBrdVO resBrdVO = ezResourceService.getBrd(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("1")) {
			brdName = resBrdVO.getBrdNm();
		} else { 
			brdName = resBrdVO.getBrdNm2();
		}
		
		brdReturnFlag = resBrdVO.getReturnFlag();
		
		// 2019-01-15 김민성 - 자원관리 - 자원관리 예약 시간 조회 12시간->24시간제로 변경
		//startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd hh:mm:ss", "");
		//endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd hh:mm:ss", "");
		
		/* 2023-09-14 홍승비 - 예약시간 중복체크를 위한 시간 포맷에서 오후 12시를 0시로 인식하는 잘못된 포맷 수정 (hh -> HH) */
		checkSDT = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "");
		checkEDT = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm", "");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editor", editor);
		model.addAttribute("nonActiveX", nonActiveX);
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdName", brdName);
		model.addAttribute("resID", resID);
		model.addAttribute("num", num);
		model.addAttribute("approveFlag", brdApproveFlag);
		model.addAttribute("cmdStr", cmdStr.toLowerCase());
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("dayView", dayView);
		model.addAttribute("pNum", pNum);
		model.addAttribute("ownerNm", ownerNm);
		model.addAttribute("ownerID", ownerID);
		model.addAttribute("gresFlag", gresFlag);
		model.addAttribute("reFlag", reFlag);
		model.addAttribute("deptNm", deptNm);
		model.addAttribute("content", content);
		model.addAttribute("importance", importance);
		model.addAttribute("loc", loc);
		model.addAttribute("timeDisplay", timeDisplay);
		model.addAttribute("title", title);
		model.addAttribute("writerID", writerID);
		model.addAttribute("allDay", allDay);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("startDateTimeRepeat", startDateTimeRepeat);
		model.addAttribute("endDateTimeRepeat", endDateTimeRepeat);
		model.addAttribute("startDateVal", startDateVal);
		model.addAttribute("endDateVal", endDateVal);
		model.addAttribute("typeVal", typeVal);
		model.addAttribute("saveApproveFlag", saveApproveFlag);
		model.addAttribute("resReturnFlag", brdReturnFlag);
		model.addAttribute("returnFlag", returnFlag);
		model.addAttribute("entryList", entryList);
		model.addAttribute("checkSDT", checkSDT);
		model.addAttribute("checkEDT", checkEDT);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		model.addAttribute("deptID", deptID);
		
		if (reFlag.equals("1")) {
			model.addAttribute("strTmpReFlagVal", "2");
			model.addAttribute("strDspMod1", "style='display:none'");
			model.addAttribute("strDspMod2", "");
		} else {
			model.addAttribute("strTmpReFlagVal", "0");
			model.addAttribute("strDspMod1", "");
			model.addAttribute("strDspMod2", "style='display:none'");
		}
		
		if (reFlag.equals("")) {
			model.addAttribute("strIReFlagVal", "0");
		} else {
			model.addAttribute("strIReFlagVal", reFlag);
		}
		
		String requestURL = (String) req.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		//뷰만 다르고 cs가 같은 경우여서 requestURL 사용해서 다이나믹뷰
		requestURL = requestURL.substring(1, requestURL.length() - 3);
		
		if(requestURL.contains("persPortletRead"))	return "/ezResource/resPortletRead";
		return "/ezResource/resScheduleRead";
	}
	
	/**
	 * 자원관리 자원 예약 화면 호출 함수
	 */
	@RequestMapping(value = {"/ezResource/scheduleAdd.do", "/ezResource/persPortletAdd.do" }, method = RequestMethod.GET)
	public String scheduleAdd(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model, Locale locale) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String editor = config.getProperty("EDITOR");
		String noneActiveX = "YES";
		String resID = "";
		String brdName = "";
		String cmdStr = "";
		String fromStr = "";
		String dayView = "";
		String orgNum = "";
		String orgOwnerID = "";
		String typeVal = "";
		String startDateVal = "";
		String endDateVal = "";
		String deptNm = "";
		String ownerNm = "";
		String title = "";
		String loc = "";
		String importance = "";
		String gresFlag = "0";
		String reFlag = "";
		String startDateTime = "";
		String endDateTime = "";
		String startDateTime2 = "";
		String endDateTime2 = "";
		String timeDisplay = "";
		String content = "";
		String ownerID = "";
		String writerID = "";
		String allDay = "";
		String saveApproveFlag = "";
		String startDateTimeRepeat = "";
		String endDateTimeRepeat = "";
		String entryList = "";
		
		int pNum = 0;
		int num = 0;
		
		if (req.getParameter("ownerID") != null) {
			resID = req.getParameter("ownerID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}

		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "", userInfo.getTenantId(), userInfo.getDeptID());
		String brdApproveFlag = ezResourceService.getBrdApproveFlag(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());

		// 반복예약허용 Flag
		String brdRepeatFlag = ezResourceService.getBrdRepeatFlag(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (req.getParameter("cmd") != null) {
			cmdStr = req.getParameter("cmd");
		}
		if (req.getParameter("from") != null) {
			fromStr = req.getParameter("from");
		}
		if (req.getParameter("dayView") != null) {
			dayView = req.getParameter("dayView");
		}
		if (cmdStr.equals("mod")) {
			if (req.getParameter("num") != null) {
				orgNum = req.getParameter("num").trim();
			}

			if (req.getParameter("ownerID") != null) {
				orgOwnerID = req.getParameter("ownerID").trim();
			}
			if (req.getParameter("type") != null) {
				typeVal = req.getParameter("type").trim();
			}
			if (req.getParameter("startDate") != null) {
				startDateVal = req.getParameter("startDate").trim();
			}
			if (req.getParameter("endDate") != null) {
				endDateVal = req.getParameter("endDate").trim();
			}
			ResGetScheduleVO getSchedule = new ResGetScheduleVO();
			if (typeVal.equals("Master") || typeVal.equals("Readonly")) {
				getSchedule = ezResourceService.getSchedule(Integer.parseInt(orgNum), orgOwnerID, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang());
			}
			
			num = getSchedule.getNum();
			pNum = getSchedule.getpNum();
			ownerID = getSchedule.getOwnerID();
			writerID = getSchedule.getWriterID();
	
			String propList = "displayName;description";
			String infoXML = ezOrganService.getPropertyList(writerID, propList, userInfo.getPrimary(), userInfo.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
			
			if (userInfo.getPrimary().equals("1")) {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
			} else {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION" + userInfo.getPrimary()).item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME" + userInfo.getPrimary()).item(0).getTextContent();
			}
			title = getSchedule.getTitle();
			loc = getSchedule.getLocation();
			timeDisplay = getSchedule.getTimeDisplay();
			
			startDateTime = commonUtil.getDateStringInUTC(getSchedule.getStartDate(), userInfo.getOffset(), false);
			endDateTime = commonUtil.getDateStringInUTC(getSchedule.getEndDate(), userInfo.getOffset(), false);
			
			reFlag = getSchedule.getReFlag();
			gresFlag = getSchedule.getGresFlag();
			content = getSchedule.getContent();
			importance = getSchedule.getImportance();
			
			if (importance.equals("")) {
				importance = "2";
			}
			
			entryList = getSchedule.getEntryList();
			allDay = getSchedule.getAllDay();
			saveApproveFlag = getSchedule.getApproveFlag();
			
			ResGetScheduleRepetitionVO repDateTimes = ezResourceService.getRepDateTimes(orgOwnerID, userInfo.getCompanyID(), Integer.parseInt(orgNum), userInfo.getTenantId());
			if (repDateTimes != null) {
				startDateTimeRepeat = commonUtil.getDateStringInUTC(repDateTimes.getStartDateTime(), userInfo.getOffset(), false);
				endDateTimeRepeat = commonUtil.getDateStringInUTC(repDateTimes.getEndDateTime(), userInfo.getOffset(), false);
			}
		} else {
			importance = "2";
			String selSd = "";
			String selEd = "";
			String cDate = "";
			String cTime = "";
			String cTime2 = "";
			
			if (req.getParameter("selsd") != null) {
				selSd = req.getParameter("selsd");
			}
			if (req.getParameter("seled") != null) {
				selEd = req.getParameter("seled");
			}
			if (selSd.equals("") || selEd.equals("")) {
				cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
				cTime = cDate.split(" ")[1].substring(0, 2);
				cTime2 = cDate.split(" ")[1].substring(3, 5);
				
				if (req.getParameter("startDate") != null && !req.getParameter("startDate").equals("")) {
					cDate = req.getParameter("startDate");
				}
				cDate = cDate.substring(0, 10);
				if(Integer.parseInt(cTime2) < 30) {
					startDateTime = cDate + " " + cTime + ":00:00";
				} else {
					startDateTime = cDate + " " + cTime + ":30:00";
				}
					
				if (req.getParameter("endDate") != null) {
					cDate = req.getParameter("endDate");
				}
				cDate = cDate.substring(0, 10);
				if(Integer.parseInt(cTime2) < 30) {
					endDateTime = cDate + " " + cTime + ":30:00";
				} else {
					endDateTime = cDate + " " + cTime + ":60:00";
				}
			} else {
				if (selSd.length() == 10) {
					cDate = commonUtil.getDateStringInUTC(commonUtil.getTodayUTCTime("yyyy-MM-dd HH:mm:ss"), userInfo.getOffset(), false);
					cTime = cDate.split(" ")[1].substring(0, 2);
					cTime2 = cDate.split(" ")[1].substring(3, 5);
					cDate = cDate.substring(0, 10);
					if(Integer.parseInt(cTime2) < 30) {
						startDateTime = selSd + " " + cTime + ":00:00";
						endDateTime = selEd + " " + cTime + ":30:00";
					} else {
						startDateTime = selSd + " " + cTime + ":30:00";
						endDateTime = selEd + " " + cTime + ":60:00";
					}
					allDay = "1"; // 2018-08-06 김민성 - 종일일정 클릭 시 기간 하루종일로 변경
				} else {
					startDateTime = selSd;
					endDateTime = selEd;
				}
			}
			
			if (req.getParameter("ownerID") != null) {
				ownerID = req.getParameter("ownerID");
			}
		}
		
		ResBrdVO resBrdVO = ezResourceService.getBrd(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		if (userInfo.getPrimary().equals("1")) {
			brdName = resBrdVO.getBrdNm();
		} else { 
			brdName = resBrdVO.getBrdNm2();
		}
		
		startDateTime2 = startDateTime;
		endDateTime2 = endDateTime;
		
		startDateTime = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		endDateTime = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd aa h:mm:ss", "");
		
		Map<String, Boolean> menuAccessMap = commonUtil.checkMenuAccess(Arrays.asList(new String[] {"schedule"}), userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getLang(), userInfo.getId(), userInfo.getDeptID());
		boolean useSchedule = menuAccessMap.get("schedule");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("editor", editor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdName", brdName);
		model.addAttribute("resID", resID);
		model.addAttribute("num", num);
		model.addAttribute("approveFlag", brdApproveFlag);
		model.addAttribute("repeatFlag", brdRepeatFlag);
		model.addAttribute("cmdStr", cmdStr.toLowerCase());
		model.addAttribute("fromStr", fromStr);
		model.addAttribute("dayView", dayView);
		model.addAttribute("pNum", pNum);
		model.addAttribute("gresFlag", gresFlag);
		model.addAttribute("reFlag", reFlag);
		model.addAttribute("content", content);
		model.addAttribute("ownerID", ownerID);
		model.addAttribute("ownerNm", ownerNm);
		model.addAttribute("importance", importance);
		model.addAttribute("loc", loc);
		model.addAttribute("timeDisplay", timeDisplay);
		model.addAttribute("writerID", writerID);
		model.addAttribute("deptNm", deptNm);
		model.addAttribute("title", title.replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\"", "&quot;").replaceAll("'", "&apos;").replaceAll("\\\\", "&#92;"));
		model.addAttribute("allDay", allDay);
		model.addAttribute("entryList", entryList);
		model.addAttribute("startDateTime", startDateTime);
		model.addAttribute("endDateTime", endDateTime);
		model.addAttribute("startDateTime2", startDateTime2);
		model.addAttribute("endDateTime2", endDateTime2);
		model.addAttribute("startDateVal", startDateVal);
		model.addAttribute("endDateVal", endDateVal);
		model.addAttribute("typeVal", typeVal);
		model.addAttribute("saveApproveFlag", saveApproveFlag);
		model.addAttribute("startDateTimeRepeat", startDateTimeRepeat);
		model.addAttribute("endDateTimeRepeat", endDateTimeRepeat);
		model.addAttribute("useSchedule", useSchedule);
		
		if (reFlag.equals("1")) {
			model.addAttribute("strTmpReFlagVal", "2");
			model.addAttribute("strDspMod1", "style='display:none'");
			model.addAttribute("strDspMod2", "");
		} else {
			model.addAttribute("strTmpReFlagVal", "0");
			model.addAttribute("strDspMod1", "");
			model.addAttribute("strDspMod2", "style='display:none'");
		}
		
		if (reFlag.equals("")) {
			model.addAttribute("strIReFlagVal", "0");
		} else {
			model.addAttribute("strIReFlagVal", reFlag);
		}
		
		
		String requestURL = (String) req.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		//뷰만 다르고 cs가 같은 경우여서 requestURL 사용해서 다이나믹뷰
		requestURL = requestURL.substring(1, requestURL.length() - 3);
		
		if(requestURL.contains("persPortletAdd"))	return "/ezResource/resPortletAdd";
		return "/ezResource/resScheduleAdd";
	}
	
	/**
	 * 자원관리 자원 양식 등록 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleManageForm.do", method = RequestMethod.GET)
	public String scheduleManageForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req,Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String resID = "";
		String brdName = "";
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}
		
		String companyID = userInfo.getCompanyID();
		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "everyone", userInfo.getTenantId(), userInfo.getDeptID());
		
		model.addAttribute("resID", resID);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdName", brdName);
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("companyID", companyID);
		return "/ezResource/resScheduleManageForm";
	}
	
	/**
	 * 자원관리 자원 반복 등록 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRepetition.do", method = RequestMethod.GET)
	public String scheduleRepetition(@CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		return "/ezResource/resScheduleRepetition";
	}
	
	/**
	 * 자원관리 자원 예약 반복정보 CRUD 실행 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRepetitionProc.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8") 
	@ResponseBody
	public String scheduleRepetitionProc(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,@RequestBody String xmlStr) throws Exception {
		logger.debug("scheduleRepetitionProc started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = "";
		String cmd = "";
		String returnValue = "";
		
		companyID = userInfo.getCompanyID();
		
		if (req.getParameter("cmd") != null) {
			cmd = req.getParameter("cmd");
		}
			
		if (cmd.equals("get")) {
			returnValue = ezResourceService.getRepetition(xmlStr, userInfo.getTenantId(), userInfo.getOffset());
		
		} else if (cmd.equals("add") || cmd.equals("mod")) {
			String num = req.getParameter("num") != null ? req.getParameter("num").trim() : "";
			String ownerID = req.getParameter("ownerID") != null ? req.getParameter("ownerID").trim() : "";
		
			boolean ret = ezResourceService.saveRepetition(companyID, num, ownerID, xmlStr, cmd, userInfo.getTenantId(), userInfo.getOffset(), userInfo.getLang());
				
			if (ret == true) {
				returnValue = "OK";
			} else {
				returnValue = "NO";
			}
		} else if (cmd.equals("del")) {
			boolean ret = ezResourceService.deleteRepetition(xmlStr, userInfo.getCompanyID(), userInfo.getTenantId());
				
			if (ret == true) {
				returnValue = "OK";
			} else {
				returnValue = "NO";
			}
		}
		
		logger.debug("returnValue=" + returnValue);
		logger.debug("scheduleRepetitionProc ended");
		
		return returnValue;
	}
	
	/**
	 * 자원관리 스케줄 폼 호출 Method
	 */
	@RequestMapping(value = "/ezResource/scheduleGetForm.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetForm(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String resID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		ResSelectFormIDVO selectFormID = ezResourceService.selectFormID(resID, userInfo.getTenantId());

		if (selectFormID == null) {
			return "FALSE";
		} else {
			return selectFormID.getFormText();
		}
	}
	
	/**
	 * 자원관리 승인요청 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleApprovList.do", method = RequestMethod.GET)
	public String scheduleApprovList(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String resID = "";
		String brdNm = "";
		String startDate = "";
		String endDate = "";
		String type = "";
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		if (req.getParameter("startDate") != null) {
			startDate = req.getParameter("startDate");
		}
		if (req.getParameter("endDate") != null) {
			endDate = req.getParameter("endDate");
		}
		if (req.getParameter("type") != null) {
			type = req.getParameter("type");
		}
		ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		if (userInfo.getPrimary().equals("1")) {
			brdNm = resBrd.getBrdNm();
		} else {
			brdNm = resBrd.getBrdNm2();
		}

		model.addAttribute("userInfo",userInfo);
		model.addAttribute("resID",resID);
		model.addAttribute("brdNm",brdNm);
		model.addAttribute("startDate",startDate);
		model.addAttribute("endDate",endDate);
		model.addAttribute("approveFlag",resBrd.getApproveFlag());
		model.addAttribute("returnFlag",resBrd.getReturnFlag());
		model.addAttribute("pType", type);
		
		return "/ezResource/resScheduleApprovList";
	}
	
	/**
	 * 자원관리 양식등록 저장 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/apropinion.do", method = RequestMethod.GET)
	public String apropinion() throws Exception {
		
		return "/ezResource/resApropinion";
	}
	
	/**
	 * 자원관리 양식등록 실행  함수
	 */
	@RequestMapping(value = "/ezResource/scheduleSaveForm.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleSaveForm(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String resID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String brdNm = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String formText = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		try{
			ezResourceService.insertForm(resID, brdNm, formText, userInfo.getTenantId());
			return "OK";
		}catch(Exception e){
			logger.error(e.getMessage(), e);
			return "FALSE";
		}
	}
	
	/**
	 * 자원관리 양식삭제 실행  함수
	 */
	@RequestMapping(value = "/ezResource/scheduleDelForm.do", method = RequestMethod.POST)
	@ResponseBody
	public String scheduleDelForm(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		try {
			String delCode = xmlDom.getElementsByTagName("RESID").item(0).getTextContent();
			ezResourceService.delFormID(delCode, userInfo.getTenantId());
			return "OK";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "FALSE";
		}
	}
	
	/**
	 * 자원관리 자원예약 자원선택 화면 호출 함수
	 */
	@RequestMapping(value = {"/ezResource/scheduleAddSelect.do", "/ezResource/resPersPortlet.do"}, method = RequestMethod.GET)
	public String scheduleAddSelect(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String brdID = "";
		String brdNm = "";
		String brdGubun = "";
		//String accessCode = "";
		String selectNo = "";
		String useEditor = "";
		String noneActiveX = "";
		
		noneActiveX = "YES";
		useEditor = config.getProperty("EDITOR");
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		if (req.getParameter("pbrdGubun") != null) {
			brdGubun = req.getParameter("pbrdGubun");
		}
		
		//관리자체크
		/*if (ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId()).equals("Y")) {
			accessCode = "0";
		} else {
			accessCode = "2";
		}*/
		if (req.getParameter("flag") != null) {
			selectNo = req.getParameter("flag");
		}
		
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("brdGubun", brdGubun);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", req.getServerName());
		model.addAttribute("selectNo", selectNo);
		model.addAttribute("accessCode", "0");
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
				
		String requestURL = (String) req.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		//뷰만 다르고 cs가 같은 경우여서 requestURL 사용해서 다이나믹뷰
		requestURL = requestURL.substring(1, requestURL.length() - 3);
		
		if(requestURL.contains("resPersPortlet"))	return "/ezResource/resPersPortlet";
		return "/ezResource/resScheduleAddSelect";
	}
	
	/**
	 * 자원관리 자원예약 자원선택 자원관리 추가시 권한 체크 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleAddGetACL.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleAddGetACL(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String ret = "";
		
		brdID = req.getParameter("brdID");
		ret = ezResourceService.getACL(userInfo.getCompanyID(), brdID, userInfo.getId(), "everyone", userInfo.getTenantId(), userInfo.getDeptID());
		
		return "<RESULT>"+ret+"</RESULT>";
	}
	
	/**
	 * 자원관리 자원예약 저장 후 닫기 실행 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleAddOk.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleAddOk(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req, @RequestBody String xmlStr) throws Exception {
		logger.debug("scheduleAddOk Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String cmd = "";
		String typeVal = "";
		String companyID = "";
		String ret = "";
		
		if (req.getParameter("cmd") != null && !req.getParameter("cmd").equals("")) {
			cmd = req.getParameter("cmd");
		}
		if (req.getParameter("type") != null && !req.getParameter("type").equals("")) {
			typeVal = req.getParameter("type");
		}
		companyID = userInfo.getCompanyID();
		logger.debug("xmlStr=" + xmlStr);
		Document dom = commonUtil.convertStringToDocument(commonUtil.detectPathTraversal(xmlStr));
	
		if (cmd.equals("del")) {
			logger.debug("del Start");
			Node rootNode = dom.getDocumentElement();
			Node objNode = dom.createElement("COMPANYID");
			objNode.setTextContent(companyID);
			rootNode.appendChild(objNode);
				
			boolean reVal = ezResourceService.delResSch(commonUtil.convertDocumentToString(dom), userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("reVal=" + reVal);	
			
			if (reVal == true) {
				ret = "OK";
			} else {
				ret = "NO";
			}
		} else if (cmd.equals("add")) {
			logger.debug("add Start");
			
			String endDate = dom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			cal.setTime(dateFormat.parse(endDate));
			
			if (cal.get(Calendar.HOUR_OF_DAY) == 0 && cal.get(Calendar.MINUTE) == 0) {
				cal.add(Calendar.MINUTE, -1);
				endDate = dateFormat.format(cal.getTime());
				dom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate);
			}
			
			Element elementDept = dom.createElement("DEPTID");
			elementDept.setTextContent(userInfo.getDeptID());
			dom.getDocumentElement().appendChild(elementDept);

			ret = ezResourceService.addResSch(commonUtil.convertDocumentToString(dom), userInfo.getTenantId(), userInfo.getOffset());
		} else if (cmd.equals("mod")) {
			logger.debug("mod Start");
			
			String endDate = dom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
			Calendar cal = Calendar.getInstance();
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			cal.setTime(dateFormat.parse(endDate));

			if (cal.get(Calendar.HOUR_OF_DAY) == 0 && cal.get(Calendar.MINUTE) == 0) {
				cal.add(Calendar.MINUTE, -1);
				endDate = dateFormat.format(cal.getTime());
				dom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate);
			}
			
			Node rootNode = dom.getDocumentElement();
			Node objNode = dom.createElement("TYPE_VAL");
			objNode.setTextContent(typeVal);
			rootNode.appendChild(objNode);

			ret = ezResourceService.modifyResSch(commonUtil.convertDocumentToString(dom), userInfo.getTenantId(), userInfo.getOffset());
		}
		
		logger.debug("ret=" + ret);
		logger.debug("scheduleAddOk End.");
		return commonUtil.stripScriptTags(ret).replaceAll("onerror=alert", "");
	}
	
	/**
	 * 자원관리 자원예약 사용자 선택 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleSelectUser.do", method = RequestMethod.GET)
	public String scheduleSelectUser(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezResource/resScheduleSelectUser";
	}
	
	/**
	 * 자원관리 자원예약 부서 선택 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleSelectDept.do", method = RequestMethod.GET)
	public String scheduleSelectDept(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req) {
		return "/ezResource/resScheduleSelectDept";
	}
	
	/**
	 * 자원관리 자원등록 조직도 부서 사원목록 호출 함수
	 */
	@RequestMapping(value = "/ezResource/getDeptMemberList.do", method = RequestMethod.GET, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptMemberList(@RequestBody String data, HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String deptID = doc.getElementsByTagName("deptID").item(0).getTextContent();
		String cell = doc.getElementsByTagName("cell").item(0).getTextContent();    
        String propList = doc.getElementsByTagName("prop").item(0).getTextContent();
        String listType = doc.getElementsByTagName("type").item(0).getTextContent();
        
        String returnXML = ezOrganService.getDeptMemberList(deptID, cell, propList, listType, userInfo.getPrimary(), userInfo.getTenantId(), null);
        
		return returnXML;
	}
	
	/**
	 * 자원관리 자원반복 삭제 확인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRepetitionDel.do", method = RequestMethod.GET)
	public String scheduleRepetitionDel() throws Exception {
		return "/ezResource/resScheduleRepetitionDel";
	}
	
	/**
	 * 자원관리 자원사용 승인Flag 저장 실행 함수
	 */
	@RequestMapping(value = "/ezResource/updateApprovalFlag.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String updateApprovalFlag(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Document dom = commonUtil.convertStringToDocument(xmlStr);
		try {
			String companyID = dom.getElementsByTagName("COMPANYID").item(0).getTextContent();
			String resID = dom.getElementsByTagName("RESID").item(0).getTextContent();
			String num = dom.getElementsByTagName("NUM").item(0).getTextContent();
			String approve = dom.getElementsByTagName("APPROVE").item(0).getTextContent();
			
			ezResourceService.updateSchedule(Integer.parseInt(num), resID, companyID, approve, userInfo.getTenantId());
			
			return "True";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "False";
		}
	}
	
	/**
	 * 자원관리 자원사용 반납Flag 저장 실행 함수
	 */
	@RequestMapping(value = "/ezResource/updateReturnFlag.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String updateReturnFlag(@RequestBody String xmlStr, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document dom = commonUtil.convertStringToDocument(xmlStr);
		try {
			String companyID = dom.getElementsByTagName("COMPANYID").item(0).getTextContent();
			String resID = dom.getElementsByTagName("RESID").item(0).getTextContent();
			String num = dom.getElementsByTagName("NUM").item(0).getTextContent();
			String returnFlag = dom.getElementsByTagName("RETURN").item(0).getTextContent();
			
			ezResourceService.updateSchedule2(Integer.parseInt(num), resID, companyID, returnFlag, userInfo.getTenantId());
			
			return "True";
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
			return "False";
		}
	}
	
	/**
	 * 자원관리 중복체크 실행 함수
	 */
	@RequestMapping(value = "/ezResource/timeDupCheck.do", method = RequestMethod.POST, produces="text/xml;charset=utf-8")
	@ResponseBody
	public String timeDupCheck(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("timeDupCheck started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String ret = "";
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		boolean isRep = xmlDom.getElementsByTagName("recurrence").getLength() != 0;
		String resID = xmlDom.getElementsByTagName("RESID").item(0).getTextContent();
		String sTime = xmlDom.getElementsByTagName("STIME").item(0).getTextContent();
		String eTime = xmlDom.getElementsByTagName("ETIME").item(0).getTextContent();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String cmd = xmlDom.getElementsByTagName("CMD").item(0).getTextContent();
		/*String approve = xmlDom.getElementsByTagName("APPROVE").item(0).getTextContent();*/
		String allDay = xmlDom.getElementsByTagName("allday").getLength() == 0 ? "" : xmlDom.getElementsByTagName("allday").item(0).getTextContent();
		
		//반복예약시
		String frequency = xmlDom.getElementsByTagName("frequency").getLength() == 0 ? "" : xmlDom.getElementsByTagName("frequency").item(0).getTextContent();
		String selType = xmlDom.getElementsByTagName("selType").getLength() == 0 ? "" : xmlDom.getElementsByTagName("selType").item(0).getTextContent();
		String endRecurType = xmlDom.getElementsByTagName("endRecurType").getLength() == 0 ? "" : xmlDom.getElementsByTagName("endRecurType").item(0).getTextContent();
		String startDateTime = xmlDom.getElementsByTagName("startDateTime").getLength() == 0 ? "" : xmlDom.getElementsByTagName("startDateTime").item(0).getTextContent();
		String endDateTime = xmlDom.getElementsByTagName("endDateTime").getLength() == 0 ? "" : xmlDom.getElementsByTagName("endDateTime").item(0).getTextContent();
		String interval = xmlDom.getElementsByTagName("interval").getLength() == 0 ? "" : xmlDom.getElementsByTagName("interval").item(0).getTextContent();
		String instances = xmlDom.getElementsByTagName("instances").getLength() == 0 ? "" : xmlDom.getElementsByTagName("instances").item(0).getTextContent();
		String daysOfWeek = xmlDom.getElementsByTagName("daysOfWeek").getLength() == 0 ? "" : xmlDom.getElementsByTagName("daysOfWeek").item(0).getTextContent();
		String byPosition = xmlDom.getElementsByTagName("byPosition").getLength() == 0 ? "" : xmlDom.getElementsByTagName("byPosition").item(0).getTextContent();
		String daysOfMonth = xmlDom.getElementsByTagName("daysOfMonth").getLength() == 0 ? "" : xmlDom.getElementsByTagName("daysOfMonth").item(0).getTextContent();
		String monthsOfYear = xmlDom.getElementsByTagName("monthsOfYear").getLength() == 0 ? "" : xmlDom.getElementsByTagName("monthsOfYear").item(0).getTextContent();
		
		String allDayStime = sTime.split(" ")[0] + " 00:00:00";
		String allDayEtime = eTime.split(" ")[0] + " 23:59:00";
		
		boolean isDupRep = false;
		List<ResMakeDupResultVO> dtResult = new ArrayList<ResMakeDupResultVO>();
		
		if (cmd.equals("add")) {
			num = "-1";
		}
		
		logger.debug("frequency : " + frequency);
		logger.debug("selType : " + selType);
		logger.debug("endRecurType : " + endRecurType);
		logger.debug("startDateTime : " + startDateTime);
		logger.debug("endDateTime : " + endDateTime);
		logger.debug("interval : " + interval);
		logger.debug("instances : " + instances);
		logger.debug("daysOfWeek : " + daysOfWeek);
		logger.debug("byPosition : " + byPosition);
		logger.debug("daysOfMonth : " + daysOfMonth);
		logger.debug("monthsOfYear : " + monthsOfYear);
		
		if (isRep) {
			logger.debug("===반복예약일 때===");
			
			isDupRep = ezResourceService.getRepResource(frequency, selType, endRecurType, startDateTime, endDateTime, interval, daysOfWeek, instances, byPosition, daysOfMonth, monthsOfYear, resID, num, companyID, dtResult, userInfo.getTenantId(), userInfo.getOffset());
		} else {
			logger.debug("===일반예약일 때===");
			
			if (!allDay.equals("") && Boolean.parseBoolean(allDay)) {
				isDupRep = ezResourceService.getRepResource(allDayStime, allDayEtime, resID, num, companyID, dtResult, userInfo.getTenantId(), userInfo.getOffset());
			} else {
				isDupRep = ezResourceService.getRepResource(sTime, eTime, resID, num, companyID, dtResult, userInfo.getTenantId(), userInfo.getOffset());
			}
		}
		
		if (isDupRep) {
			ret = "True";
		} else {
			ret = "False";
		}

		logger.debug("timeDupCheck ended");
		return ret;
	}
	
	/**
	 * 자원관리 자원반복 오픈 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRepetitionOpen.do", method = RequestMethod.GET)
	public String scheduleRepetitionOpen() throws Exception {
		return "/ezResource/resScheduleRepetitionOpen";
	}
	
	/**
	 * 자원관리 권한없는 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/nonResList.do", method = RequestMethod.GET)
	public String nonResList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String accMessage = "";
		if (req.getParameter("msg") != null && !req.getParameter("msg").equals("")) {
			accMessage = req.getParameter("msg");
		}
		model.addAttribute("accMessage", commonUtil.cleanScriptValue(accMessage));
		model.addAttribute("userInfo", userInfo); 
		return "/ezResource/resNonResList";
	}
	
	/**
	 * 자원관리 승인 후 알림 발송 실행 함수
	 */
	@RequestMapping(value = "/ezResource/sendMail.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String sendMail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, @RequestBody String xmlStr) throws Exception {
		logger.debug("sendMail started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String ownerID = xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent();
		String title = StringEscapeUtils.unescapeHtml4(xmlDom.getElementsByTagName("TITLE").item(0).getTextContent());
		String startDateTime = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String endDateTime = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
		String num = xmlDom.getElementsByTagName("RSSCHEDULENUM").item(0).getTextContent();
		
		//startDateTime = commonUtil.getDateStringInUTC(startDateTime, userInfo.getOffset(), false);
		//endDateTime = commonUtil.getDateStringInUTC(endDateTime, userInfo.getOffset(), false);
		
		logger.debug("ownerID=" + ownerID + ",title=" + title + ",startDateTime=" + startDateTime + ",endDateTime=" + endDateTime);
		
		// 2018-10-26 김민성 - 자원관리 예약시 관리자들에게 메일 발송 처리
		ResBrdVO resbrd = ezResourceService.getBrd(Integer.parseInt(ownerID), userInfo.getCompanyID(), userInfo.getTenantId());
		String[] ownerList = resbrd.getOwnerID().split(",");
		
		List<ResAdminVO> resInfo = ezResourceService.getResourceAdminInfo(ownerID, userInfo.getTenantId(), ownerList);
        
        StringBuilder bodyContent = new StringBuilder();

        if (userInfo.getPrimary().equals("1")) {
        	bodyContent.append(userInfo.getDisplayName() +"[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
        } else {
        	bodyContent.append(userInfo.getDisplayName2() +"[" + userInfo.getDeptName2() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
        }
        
        // 2023-08-02 황인경 - 자원관리 > 예약시 관리자들에게 메일 발송 처리 > 메일 제목, 본문 실자원명 다국어 지원
        String brdNm;

		if (userInfo.getPrimary().equals("1")) {
			brdNm = resInfo.get(0).getBrdNm();
		} else {
			brdNm = resInfo.get(0).getBrdNm2();
		}

		bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900003", userInfo.getLocale()) + " : " + brdNm);
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900004", userInfo.getLocale()) + " : " +startDateTime + "&nbsp;~&nbsp;" + endDateTime);
        
        String subject = "[" + egovMessageSource.getMessage("ezResource.t171", userInfo.getLocale()) + " : " + brdNm + "] " + title;
        String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
        
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
    	for(int i=0; i<resInfo.size(); i++) {
	    	String emailAddress = resInfo.get(i).getMailAddress();
	    	String accessName = resInfo.get(i).getOwnerNm();
	    	
	    	InternetAddress to = new InternetAddress();
	    	to.setPersonal(accessName, "UTF-8");
	    	to.setAddress(emailAddress);
	        	
	        ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
    	}
    	
    	if (startDateTime.length() == 16) {
    		startDateTime = startDateTime + ":00";
    	}
    	if (endDateTime.length() == 16) {
    		endDateTime = endDateTime + ":00";
    	}
    	
    	String linkUrl = "/ezResource/scheduleRead.do?cmd=mod&from=schedule&num=" + num + "&ownerID=" + ownerID + "&type=Master&startDate=" + startDateTime.substring(0,10) + "&endDate=" + endDateTime.substring(0,10);
    	String linkUrlMobile = "/mobile/ezResource/SearchResSchDetail.do?ownerId=" + ownerID + "&num=" + num + "&startDate=" + startDateTime.substring(0,19) + "&endDate=" + endDateTime.substring(0,19) + "&type=" + "res";
    	
    	List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();
    	for (String cn : ownerList) {
    		Map<String, Object> recipientMap = new HashMap<String, Object>();
    		recipientMap.put("userType", "PERSON");
    		recipientMap.put("companyId", userInfo.getCompanyID());
    		recipientMap.put("cn", cn);
    		notiRecipientList.add(recipientMap);
    	}
    	
    	if (notiRecipientList != null && notiRecipientList.size() > 0) {
    		ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "RESOURCE", "RESERVE", brdNm + " - " + title, "popup", "760", "750", linkUrl, linkUrlMobile, "notChkSetting");
    	}
    	
        logger.debug("sendMail ended");
        
        return "OK";
	}
	
	/**
	 * 자원관리 승인 후 알림 발송 실행 함수
	 */
	@RequestMapping(value = "/ezResource/sendMailToUser.do", method = RequestMethod.POST)
	@ResponseBody
	public void sendMailToUser(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, @RequestBody String xmlStr) throws Exception {
		logger.debug("sendMailToUser started");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String resID = xmlDom.getElementsByTagName("RESID").item(0).getTextContent();
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String approve = xmlDom.getElementsByTagName("APPROVE").item(0).getTextContent();
		String startDateTime = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String endDateTime = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
		
		logger.debug("resID=" + resID + ",num=" + num + ",approve=" + approve);
		
        ResGetSendMailToUserVO resInfo =  ezResourceService.getSendMailToUser(resID, Integer.parseInt(num), userInfo.getTenantId());
		
        StringBuilder bodyContent = new StringBuilder();
        
        // 2023-08-02 황인경 - 자원관리 > 예약 승인/거절시 작성자들에게 메일 발송 처리 > 메일 제목, 본문 실자원명 다국어 지원
     	String brdNm;
     	
     	if (userInfo.getPrimary().equals("1")) {
     		brdNm = StringEscapeUtils.unescapeHtml4(resInfo.getBrd_Nm());
     	} else {
     		brdNm = StringEscapeUtils.unescapeHtml4(resInfo.getBrd_Nm2());
     	}
     	
     	String subject = "";
        String notiSubType = "";
        if (approve.equals("1")) {
        	subject = "["+egovMessageSource.getMessage("ezResource.t9900011", userInfo.getLocale()) + " : " + brdNm + "] " + StringEscapeUtils.unescapeHtml4(resInfo.getTitle());
        	notiSubType = "APPROVE";
        } else if (approve.equals("0")){
        	subject = "["+egovMessageSource.getMessage("ezResource.t9900012", userInfo.getLocale()) + " : " + brdNm + "] " + StringEscapeUtils.unescapeHtml4(resInfo.getTitle());
        	notiSubType = "CANCEL";
        } else {
        	subject = "["+egovMessageSource.getMessage("ezResource.t9900017", userInfo.getLocale()) + " : " + brdNm + "] " + StringEscapeUtils.unescapeHtml4(resInfo.getTitle());
        	notiSubType = "REJECT";
        }

     	if (!ezPersonalService.hasNotiDiableItem(resInfo.getWriterID(), NotiType.fromString("RESOURCE_" + notiSubType), NotiPlatform.MAIL, userInfo.getTenantId())) {
	        if (approve.equals("1")) {
	           	bodyContent.append(resInfo.getOwnerNm() + egovMessageSource.getMessage("ezResource.t9900007", userInfo.getLocale()));
	           	bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900008", userInfo.getLocale()) + " : " + brdNm);
	        } else if (approve.equals("0")) {
	           	bodyContent.append(resInfo.getOwnerNm() + egovMessageSource.getMessage("ezResource.t9900009", userInfo.getLocale()));
	           	bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900010", userInfo.getLocale()) + " : " + brdNm);
	        } else {
	           	bodyContent.append(resInfo.getOwnerNm() + egovMessageSource.getMessage("ezResource.t9900015", userInfo.getLocale()));
	           	bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900016", userInfo.getLocale()) + " : " + brdNm);
	        }
	        
	        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900004", userInfo.getLocale()) + " : " 
	        		+ commonUtil.getDateStringInUTC(resInfo.getStartDate().substring(0, 16), userInfo.getOffset(), false) + "&nbsp;~&nbsp;" 
	        		+ commonUtil.getDateStringInUTC(resInfo.getEndDate().substring(0, 16), userInfo.getOffset(), false));
	        
	        String content = commonUtil.createNotiMailContent(bodyContent.toString(), userInfo.getTenantId(), userInfo.getLocale());
	        
	    	InternetAddress from = new InternetAddress();
	    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
	    	from.setAddress(userInfo.getEmail());
	    	
	    	String emailAddress = resInfo.getMail(); 
	    	String accessName = resInfo.getOwnerNm(); 
	    	
	    	if (accessName.indexOf("(") > -1) {
	    		accessName = accessName.split("\\(")[0];
	    	}
	    	
	    	InternetAddress to = new InternetAddress();
	    	to.setPersonal(accessName, "UTF-8");
	    	to.setAddress(emailAddress);
	        
	        ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, content, false);
     	}
     	
        String linkUrl = "/ezResource/scheduleRead.do?cmd=mod&from=schedule&num=" + num + "&ownerID=" + resID + "&type=Master&startDate=" + startDateTime.substring(0,10) + "&endDate=" + endDateTime.substring(0,10);
        String linkUrlMobile = "/mobile/ezResource/SearchResSchDetail.do?ownerId=" + resID + "&num=" + num + "&startDate=" + startDateTime.substring(0,19) + "&endDate=" + endDateTime.substring(0,19) + "&type=" + "res";
        
        List<Map<String,Object>> notiRecipientList = new ArrayList<Map<String, Object>> ();

        Map<String, Object> recipientMap = new HashMap<String, Object>();
        recipientMap.put("userType", "PERSON");
        recipientMap.put("companyId", userInfo.getCompanyID());
        recipientMap.put("cn", resInfo.getWriterID());
        notiRecipientList.add(recipientMap);

        
    	ezNotificationService.sendNoti(request, userInfo.getId(), userInfo.getDisplayName(), notiRecipientList, "RESOURCE", notiSubType, brdNm + " - " + StringEscapeUtils.unescapeHtml4(resInfo.getTitle()), "popup", "760", "750", linkUrl, linkUrlMobile, "");
        logger.debug("sendMailToUser ended");
	}
	

	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezResource/getResourcePortlet.do", method = RequestMethod.GET, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject getResoucePortlet(@CookieValue("loginCookie") String loginCookie, String date) throws Exception {
		logger.debug("============ getResoucePortlet started ============");
		
		if(date == null) {
			JSONObject err = new JSONObject();
			return err;
		}
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
    
		List<ResBrdVO> list = ezResourceService.getResourcePortlet(userInfo, date);
		JSONObject jObject = new JSONObject();
		jObject.put("status", "ok");
		jObject.put("list", list);
		logger.debug("============ getResoucePortlet ended ============");
		return jObject;
	}
	
	/**
	 * 포틀릿 자원 목록 저장
	 * @param loginCookie
	 * @param request
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value = "/ezResource/saveResourcePortlet.do", method = RequestMethod.POST, produces = "application/json;charset=utf-8")
	@ResponseBody
	public JSONObject saveResoucePortlet(@CookieValue("loginCookie") String loginCookie, String resources) throws Exception {
		logger.debug("============ saveResourcePortlet started ============");
		
		String result = ezResourceService.saveResourcePortlet(loginCookie, resources);

		JSONObject jObject = new JSONObject();
		jObject.put("status", result);
		logger.debug("============ saveResourcePortlet ended ============");
		return jObject;
	}

	@RequestMapping(value = "/ezResource/changeResourceOrder.do", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void changeResourceOrder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		logger.debug("============ changeResourceOrder started ============");
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String selectedResourceId = request.getParameter("selectedResourceId");
		String targetResourceId = request.getParameter("targetResourceId");
		String upperResourceId = request.getParameter("upperResourceId");
			
		ezResourceService.changeResourceOrder(selectedResourceId, targetResourceId, loginVO.getTenantId(), loginVO.getCompanyID(), upperResourceId);
		logger.debug("============ changeResourceOrder ended ============");
	}
	
	@RequestMapping(value = "ezResource/resOrganToMoveResource.do", method = RequestMethod.GET)
	public String resOrganToMoveResource(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		logger.debug("============ resOrganToMoveResource ended ============");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("serverName", req.getServerName());
		
		logger.debug("============ resOrganToMoveResource ended ============");
		return "ezResource/resOrganToMoveResource";
	}
	
	@RequestMapping(value = "/ezResource/moveResourceToOtherResourceGroup.do", method = RequestMethod.POST, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public void moveResourceToOtherResourceGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		logger.debug("============ moveResourceToOtherResourceGroup started ============");
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String originResourceGroupId = request.getParameter("originResourceGroupId");
		String selectedResourceGroupId = request.getParameter("selectedResourceGroupId");
			
		ezResourceService.moveResourceToOtherResourceGroup(originResourceGroupId, selectedResourceGroupId, loginVO.getTenantId(), loginVO.getCompanyID());
		logger.debug("============ moveResourceToOtherResourceGroup ended ============");
	}
	
	@RequestMapping(value = "/ezResource/isResourceGroupManager.do", method = RequestMethod.GET, produces = "text/html;charset=UTF-8")
	@ResponseBody
	public String isResourceGroupManager(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {
		
		logger.debug("============ moveResourceToOtherResourceGroup started ============");
		
		LoginVO loginVO = commonUtil.userInfo(loginCookie);
		
		String selectedResourceGroupId = request.getParameter("selectedResourceGroupId");
			
		String[] ownerLists = request.getParameter("ownerID").split(",");			
		String isManger = ezResourceService.isResourceGroupManager(selectedResourceGroupId, loginVO.getId(),loginVO.getTenantId(), loginVO.getCompanyID(), loginVO.getDeptID());
		
		// 2020-06-24 김민성 - 자원 이동시 자원관리자의 자원 권한도 체크하도록 추가
		for(String owner : ownerLists) {
			String propList = "department";
			String infoXML = ezOrganService.getPropertyList(owner, propList, loginVO.getPrimary(), loginVO.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
			String ownerDeptID = xmlDom2.getElementsByTagName("DEPARTMENT").item(0).getTextContent();
			
			String result = ezResourceService.userResPermissionCheck(owner, loginVO.getCompanyID(), loginVO.getTenantId(), selectedResourceGroupId, ownerDeptID);
			if(result.equals("0"))
				return "2";
		}
		
		logger.debug("============ moveResourceToOtherResourceGroup ended ============");
		return isManger;
	}
	
	/**
	 * 자원관리 관리자 정보 실행 함수
	 */
	@RequestMapping(value = "/ezResource/callManagerDepthNodeForMoveResource.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callManagerDepthNode(@RequestBody String xmlStr,HttpServletRequest req,Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("callManagerDepthNode Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String selectFlag = "";
		StringBuilder strXML = new StringBuilder();
		Document xmlRet = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		
		if (req.getParameter("flag") != null) {
			selectFlag = req.getParameter("flag");
		}
		logger.debug("xmlStr="+xmlStr);
		String ret = ezResourceService.getSubClsTree(xmlStr, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
		xmlRet = commonUtil.convertStringToDocument(ret);
		
		if (xmlRet.getElementsByTagName("EXPANDED").getLength() <= 0) {
			strXML.append("<PARADATA>");
			strXML.append("<DATA>0</DATA>");
			strXML.append("<DATA>"+userInfo.getDeptID()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getDeptName1()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getId()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getDisplayName1()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getTitle1()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getPhone()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getCompanyName1()+"</DATA>");
			strXML.append("<DATA></DATA>");
			strXML.append("<DATA></DATA>");
			strXML.append("<DATA>"+userInfo.getCompanyID()+"</DATA>");
			strXML.append("<DATA>"+userInfo.getCompanyName2()+"</DATA>");
			strXML.append("<ISCOMPANY>Y</ISCOMPANY>");
			strXML.append("</PARADATA>");
			
			ezResourceAdminService.addClsData(strXML.toString(), userInfo.getTenantId());
			
			ret = ezResourceService.getSubClsTree(xmlStr, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
			
			xmlRet = commonUtil.convertStringToDocument(ret);
		}
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes3 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA12", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/ISLEAF", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
		NodeList nodes16 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes17 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes18 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA10", xmlRet, XPathConstants.NODESET);
			
		NodeList nodes7 = (NodeList)xpath.evaluate("NODES/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes8 = (NodeList)xpath.evaluate("NODES/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes9 = (NodeList)xpath.evaluate("NODES/NODE/DATA12", xmlRet, XPathConstants.NODESET);
		NodeList nodes10 = (NodeList)xpath.evaluate("NODES/NODE/ISLEAF", xmlRet, XPathConstants.NODESET);
		NodeList nodes11 = (NodeList)xpath.evaluate("NODES/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes13 = (NodeList)xpath.evaluate("NODES/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes14 = (NodeList)xpath.evaluate("NODES/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes15 = (NodeList)xpath.evaluate("NODES/NODE/DATA10", xmlRet, XPathConstants.NODESET);
			
		if (nodes.getLength() != 0) {
			for (int i=0; i<nodes.getLength(); i++) {
				nodes1.item(i).removeChild((Node) nodes2.item(i));
				
				if (nodes3.item(i).getTextContent().equals("0")) {
					nodes4.item(i).setTextContent("TRUE");
				}
				
				if(nodes5.item(i).getTextContent().equals("")) {
					nodes5.item(i).setTextContent(" ");
				}
				
				if(nodes16.item(i).getTextContent().equals("")) {
					nodes16.item(i).setTextContent(" ");
				}
				if(nodes17.item(i).getTextContent().equals("")) {
					nodes17.item(i).setTextContent(" ");
				}
				if(nodes18.item(i).getTextContent().equals("")) {
					nodes18.item(i).setTextContent(" ");
				}
					
				//좌측 리로드할때는 선택 안되도록
				if (selectFlag.equals("SELECT_NO")) {
					if (nodes5.getLength() != 0) {
						nodes1.item(i).removeChild((Node) nodes5.item(i));
					}
				}
			}
		}
		if (nodes7.getLength() != 0) {
			for (int i=0; i<nodes7.getLength(); i++) {
				nodes8.item(i).removeChild((Node) nodes11.item(i));
				
				if (nodes9.item(i).getTextContent().equals("0")) {
					nodes10.item(i).setTextContent("TRUE");
				}
				if(nodes13.item(i).getTextContent().equals("")) {
					nodes13.item(i).setTextContent(" ");
				}
				if(nodes14.item(i).getTextContent().equals("")) {
					nodes14.item(i).setTextContent(" ");
				}
				if(nodes15.item(i).getTextContent() == null || nodes15.item(i).getTextContent().equals("")) {
					nodes15.item(i).setTextContent(" ");
				}
				
			}
		}
		
		logger.debug("xmlRet="+commonUtil.convertDocumentToString(xmlRet));
		logger.debug("callManagerDepthNode End");
		return commonUtil.convertDocumentToString(xmlRet);
	}
	
	@RequestMapping(value = "/ezResource/userResPermissionCheck.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String userResPermission(HttpServletRequest request, Model model, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("userResPermissionCheck Start");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		String userID = "";
		if(request.getParameter("userID") != null) {
			userID = request.getParameter("userID");
		}
		
		String deptID = "";
		if(request.getParameter("deptID") != null) {
			deptID = request.getParameter("deptID");
		}

		String brdID = "";
		if(request.getParameter("brdID") != null) {
			brdID = request.getParameter("brdID");
		}

		String result = ezResourceService.userResPermissionCheck(userID, userInfo.getCompanyID(), userInfo.getTenantId(), brdID, deptID);
		
		logger.debug("result : " + result);
		logger.debug("userResPermissionCheck end");
		if(result.equals("1")) {
			return "Y";
		}
		else {
			return "N";
		}
	}
	
	@RequestMapping(value = "/ezResource/uploadItemAttach.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String uploadItemAttach(MultipartHttpServletRequest request, Model model, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("uploadItemAttach Start");
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		MultipartFile multiFile = request.getFile("fileToUpload"); 
		
		String realPath = request.getServletContext().getRealPath("");
		String pFileName = "";
        long fileSize = 0;     
        String sGUID = "";
        String pUploadSN = "";
        
        sGUID = UUID.randomUUID().toString();
        pUploadSN = "{" + sGUID + "}";
        
        if (StringUtils.isNotEmpty(multiFile.getOriginalFilename()) && StringUtils.isNotBlank(multiFile.getOriginalFilename())) {   
        	String _pFileName = multiFile.getOriginalFilename();
            if (_pFileName.indexOf(commonUtil.separator) > 0) {
                _pFileName = _pFileName.split("/")[_pFileName.split("/").length - 1];
            }
            pFileName = _pFileName;
        }
        
        pFileName = pFileName.replace("%2b", "+");
        pFileName = pFileName.replace("%3b", ";");
        
        String extension = pFileName.substring(pFileName.lastIndexOf(".") + 1, pFileName.length());
        String pFileNameOnly = pFileName.substring(0, pFileName.lastIndexOf("."));
        String pDirPath = commonUtil.getUploadPath("upload_resource.ROOT", userInfo.getTenantId());

        pDirPath = realPath + pDirPath;
        if (!pDirPath.substring(pDirPath.length() - 1).equals(commonUtil.separator)) {
        	pDirPath = pDirPath + commonUtil.separator;
        }
        File file = new File(pDirPath + "uploadFile");
        File tempFile = new File(pDirPath + "tempUploadFile");
        
        logger.debug("pDirPath : " + pDirPath);
        
        if (!file.exists()) {
        	file.mkdirs();
        }
        
        if (!tempFile.exists()) {
        	tempFile.mkdirs();
        }

        StringBuffer strXML = new StringBuffer();
        strXML.append("<ROOT><NODES>");
        
    	fileSize = multiFile.getSize();
        String newFileName = pUploadSN;
        
        writeUploadedFile(multiFile, newFileName + pFileName, pDirPath + "tempUploadFile"); // 원본 파일을 업로드한 뒤, 아래 코드에서 이미지 형식으로 변환함
        
        /* 2021-10-26 홍승비 - 자원등록 시 TIF, TIFF 이미지 제대로 표출되지 않는 오류 수정 (PNG로 치환) */
        File imageFile = new File(commonUtil.detectPathTraversal(pDirPath + "tempUploadFile" + commonUtil.separator + newFileName + pFileName));
        
		if (imageFile.exists()) {
			BufferedImage bi = ImageIO.read(imageFile);		
			BufferedImage bufferedImage = null;
			
			if (extension.toUpperCase().equals("TIF") || extension.toUpperCase().equals("TIFF")) {
				extension = "png";
			}
			
			// 기존 이미지가 파일 형태로 업로드되었으므로, 다시 이미지 형태로 저장
			if (bi.getType() == 0 || extension.equals("png")) { // 일부 png 파일의 경우, type값이 0으로 넘어오거나 검은색으로 저장되는 것을 방지
				bufferedImage = new BufferedImage(bi.getWidth(), bi.getHeight(), BufferedImage.TYPE_4BYTE_ABGR);
			} else {
				bufferedImage = new BufferedImage(bi.getWidth(), bi.getHeight(), bi.getType());
			}
			bufferedImage.createGraphics().drawImage(bi, 0, 0, bi.getWidth(), bi.getHeight(), null);
			ImageIO.write(bufferedImage, extension, new File(commonUtil.detectPathTraversal(pDirPath + "tempUploadFile" + commonUtil.separator + newFileName + pFileNameOnly + "." + extension)));
			
			bi.flush();
			bi = null;
			bufferedImage.flush();
			bufferedImage = null;
		}
		
		strXML.append("<DATA><![CDATA[" + newFileName + "]]></DATA>");
		strXML.append("<DATA2><![CDATA[" + pFileNameOnly + "." + extension + "]]></DATA2>");
		strXML.append("<DATA3><![CDATA[" + fileSize + "]]></DATA3>");
		strXML.append("<DATA4><![CDATA[" + "]]></DATA4>");
		strXML.append("<DATA5><![CDATA[OK]]></DATA5>");
        strXML.append("</NODES></ROOT>");
        
		logger.debug("uploadItemAttach End");
		
		return strXML.toString();
	}
	
	/**
	 *  썸네일정보 실행 Method
	 */
	@RequestMapping(value = "/ezResource/getResourceThumbnailInfo.do", method = RequestMethod.GET)
	@ResponseBody
	public void getBoardThumbnailInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("getResourceThumbnailInfo started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String fileName = request.getParameter("fileName");
		String mode = "";
		
		if(request.getParameter("mode") != null) {
			mode = request.getParameter("mode");
		}
		String filePath = "";
		
		if(mode.equals("temp")) {
			String pSignatureDir = commonUtil.getUploadPath("upload_resource.TEMPUPLOAD", userInfo.getTenantId());
			
			filePath = pSignatureDir + commonUtil.separator + fileName;
		}
		else {
			String pSignatureDir = commonUtil.getUploadPath("upload_resource.ROOT", userInfo.getTenantId()) + commonUtil.separator + "uploadFile";
			
			filePath = pSignatureDir + fileName;
		}
		
		if (filePath != null && !filePath.equals("")) {
			logger.debug("filePath : " + filePath + "|| fileName : " + fileName);
			downImage(filePath, request, response);
		}
		
		logger.debug("getResourceThumbnailInfo end");
	}
	
	/**
	 *  임시첨부파일 삭제
	 */
	@RequestMapping(value = "/ezResource/tempUploadFileDelete.do", method = RequestMethod.POST)
	public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
		
		logger.debug("tempUploadFileDelete started");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);

		String fileName = request.getParameter("fileName");
		String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_resource.TEMPUPLOAD", userInfo.getTenantId());
		
		logger.debug("fileName : " + fileName + ", pDirPath : " + pDirPath);
		
		File file = new File(pDirPath + commonUtil.separator + fileName);
		file.delete();

        logger.debug("tempUploadFileDelete ended");
        
        return "json";
    }
	
	@RequestMapping(value = "/ezResource/checkApprovalFlag.do", method = RequestMethod.GET, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String checkApprovalFlag(HttpServletRequest request, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("checkApprovalFlag Start");
		
		userInfo = commonUtil.userInfo(loginCookie);

		String resID = "";
		if(request.getParameter("resID") != null) {
			resID = request.getParameter("resID");
		}
		
		String brdApproveFlag = ezResourceService.getBrdApproveFlag(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		
		logger.debug("checkApprovalFlag end");
		return brdApproveFlag;
	}
	
	@RequestMapping(value = "/ezResource/resourceOccupancy.do", method = RequestMethod.GET)
	public String resourceOccupancy(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		logger.debug("resourceOccupancy Start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		int tenantId = userInfo.getTenantId();
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("tenantId", tenantId);
		
		logger.debug("resourceOccupancy End");
		return "ezResource/resOccupancy";
	}
	
	@RequestMapping(value = "/ezResource/getResOccuList.do", method = RequestMethod.GET)
	public String getResOccuList(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception {
		
		String searchStartTime = request.getParameter("searchStartTime").substring(0, 10);
		String searchEndTime = request.getParameter("searchEndTime").substring(0, 10);
		int tenantID = commonUtil.userInfo(loginCookie).getTenantId();
		String companyID = request.getParameter("pCompanyID");
		String companyName = request.getParameter("pCompanyName");
		String offset = commonUtil.userInfo(loginCookie).getOffset();
		
		List<ResOccuVO> getResOccuList = ezResourceService.getResOccuList(companyID, tenantID, searchStartTime, searchEndTime, offset);
		long totalTime = 0;
		if (getResOccuList.size() > 0) {
			for (int i = 0; i < getResOccuList.size(); i++) {
				totalTime += getResOccuList.get(i).getUsageTime();
			}
			
			for (int i = 0; i < getResOccuList.size(); i++) {
				double occu = (getResOccuList.get(i).getUsageTime() / (double)totalTime) * 100;
				String occupancy = String.format("%.2f", occu) + "%";
				getResOccuList.get(i).setOccupancy(occupancy);
				getResOccuList.get(i).setCompanyName(companyName);
			}
		}
		
		model.addAttribute("getResOccuList", getResOccuList);
		model.addAttribute("totalTime", totalTime);
		return "json";
	}
	
	@RequestMapping(value = "/ezResource/excelExportOut.do", method = {RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public void excelExportOut(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception {
		logger.debug("excelExportOut started");
		
		String searchStartTime = request.getParameter("searchStartTime").substring(0, 10);
		String searchEndTime = request.getParameter("searchEndTime").substring(0, 10);
		int tenantID = commonUtil.userInfo(loginCookie).getTenantId();
		String companyID = request.getParameter("pCompanyID");
		String companyName = request.getParameter("pCompanyName");
		String offset = commonUtil.userInfo(loginCookie).getOffset();
		
		List<ResOccuVO> getResOccuList = ezResourceService.getResOccuList(companyID, tenantID, searchStartTime, searchEndTime, offset);
		long totalTime = 0;
		if (getResOccuList.size() > 0) {
			for (int i = 0; i < getResOccuList.size(); i++) {
				totalTime += getResOccuList.get(i).getUsageTime();
			}
			
			for (int i = 0; i < getResOccuList.size(); i++) {
				double occu = (getResOccuList.get(i).getUsageTime() / (double)totalTime) * 100;
				String occupancy = String.format("%.2f", occu) + "%";
				getResOccuList.get(i).setOccupancy(occupancy);
				getResOccuList.get(i).setCompanyName(companyName);
			}
		}
		
		try (HSSFWorkbook workbook = new HSSFWorkbook()) {
			HSSFSheet sheet;
			HSSFCellStyle headerStyle= workbook.createCellStyle();
		    headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		    headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		    headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    headerStyle.setAlignment(CellStyle.ALIGN_CENTER);
		      
		    HSSFCellStyle bodyStyle= workbook.createCellStyle();
		    bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		    bodyStyle.setAlignment(CellStyle.ALIGN_CENTER);
		    bodyStyle.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
		    
		    Row row;
		    Cell cell;
		    
		    String pFileName = searchStartTime.replace("-", ".") + "~" + searchEndTime.replace("-", ".") + "_resList";
			
			sheet = workbook.createSheet("resList");
			row = sheet.createRow(0);
			
			for (int i = 0; i < 6; i++) {
				cell = row.createCell(i);
				cell.setCellStyle(headerStyle);
				cell.setCellValue(egovMessageSource.getMessage("ezResource.header.kwc" + (i + 1), locale));
				sheet.autoSizeColumn(i);
				sheet.setColumnWidth(i, Math.min(65280, sheet.getColumnWidth(i) + 4096));
			}
			
			for (int i = 0; i < getResOccuList.size(); i++) {
				row = sheet.createRow(i + 1);
				cell = row.createCell(0);
				cell.setCellStyle(bodyStyle);
				cell.setCellValue(getResOccuList.get(i).getCompanyName());
				cell = row.createCell(1);
				cell.setCellStyle(bodyStyle);
				cell.setCellValue(getResOccuList.get(i).getBrdNm());
				cell = row.createCell(2);
				cell.setCellStyle(bodyStyle);
				cell.setCellValue(getResOccuList.get(i).getCount());
				cell = row.createCell(3);
				cell.setCellStyle(bodyStyle);
				cell.setCellValue(getResOccuList.get(i).getUsageTime());
				cell = row.createCell(4);
				cell.setCellStyle(bodyStyle);
				cell.setCellValue(totalTime);
				cell = row.createCell(5);
				cell.setCellStyle(bodyStyle);
				cell.setCellValue(getResOccuList.get(i).getOccupancy());
				if (i == (getResOccuList.size() - 1) && getResOccuList.size() > 1) {
					sheet.addMergedRegion(new CellRangeAddress(1, getResOccuList.size(), 4, 4));
				}
			}
			
			response.setContentType("application/ms-excel");
			response.setCharacterEncoding("utf-8");
			response.setHeader("Content-Disposition", "attachment; fileName=\"" + pFileName + ".xls\"");
		    workbook.write(response.getOutputStream());
		}
		
		logger.debug("excelExportOut ended");
	}
	
	/**
	 * 즐겨찾기 관리창 호출 Method
	 */
	@RequestMapping(value = "/ezResource/resFavoriteManage.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
	public String favoriteManage(@CookieValue("loginCookie") String loginCookie, @RequestParam(required = false) String brdId, Model model) throws Exception {
		logger.debug("favoriteManage start, brdId=" + brdId);

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("brdId", brdId);
		model.addAttribute("lang", commonUtil.getMultiData(userInfo.getLang(), userInfo.getTenantId()));
		
		logger.debug("favoriteManage end");
		
		return "/ezResource/resFavoriteManage";
	}

	/**
	 * 즐겨찾기 카테고리(분류) 추가 Method
	 */
	@RequestMapping(value = "/ezResource/addFavoriteCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addFavoriteCategory(@CookieValue("loginCookie") String loginCookie, @RequestParam String catName, @RequestParam(required = false) String catId) throws Exception {
		logger.debug("addFavoriteCategory start, catName=" + catName + " catId=" + catId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		ezResourceService.addFavoriteCategory(catName, catId, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("type", "C");
		
		logger.debug("addFavoriteCategory end");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 카테고리(분류) 수정 Method
	 */
	@RequestMapping(value = "/ezResource/modFavoriteCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> modFavoriteCategory(@CookieValue("loginCookie") String loginCookie, @RequestParam String catName, @RequestParam String catId) throws Exception {
		logger.debug("modFavoriteCategory start, catName=" + catName, "catId=" + catId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		ezResourceService.modFavoriteCategory(catName, catId, userInfo.getId());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("type", "U");
		
		logger.debug("modFavoriteCategory end");
		
		return result;
	}
	
	/**
	 * 즐겨찾기 카테고리(분류) 삭제 Method
	 */
	@RequestMapping(value = "/ezResource/delFavoriteCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delFavoriteCategory(@CookieValue("loginCookie") String loginCookie, @RequestParam String catId) throws Exception {
		logger.debug("delFavoriteCategory start, catId=" + catId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		ezResourceService.delFavoriteCategory(catId, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("type", "D");
		
		logger.debug("delFavoriteCategory end");
		return result;
	}
	
	/**
	 * 상위로 부터 하위 카테고리(분류) 조회 Method
	 */
	@RequestMapping(value = "/ezResource/getFavoriteCategoryList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getFavoriteCategoryList(@CookieValue("loginCookie") String loginCookie, @RequestParam(required = false) String topId) throws Exception {
		logger.debug("getFavoriteCategoryList start, topId=" + topId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ResFavoriteCategoryVO> list = ezResourceService.getFavoriteCategoryList(topId, userInfo.getId());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("list", list);
		
		logger.debug("getFavoriteCategoryList end");
		return result;
	}
	
	/**
	 * 자원을 카테고리(분류) 에 추가히기 위한  Method
	 */
	@RequestMapping(value = "/ezResource/addBrdFavoriteCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> addBrdFavoriteCategory(@CookieValue("loginCookie") String loginCookie, @RequestParam String brdId, @RequestParam String catId) throws Exception {
		logger.debug("addBrdFavoriteCategory start, brdId=" + brdId + ", catId=" + catId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String res = ezResourceService.addBrdFavoriteCategory(brdId, catId, userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId());
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", res);
		
		logger.debug("addBrdFavoriteCategory end, result=" + res);
		
		return result;
	}
	
	/**
	 * 카테고리(분류)에 존재하는 자원 목록 조회
	 */
	@RequestMapping(value = "/ezResource/getBrdFavoriteList.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> getBrdFavoriteList(@CookieValue("loginCookie") String loginCookie, @RequestParam String catId) throws Exception {
		logger.debug("getBrdFavoriteList start, catId=", catId);
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<ResBrdVO> list = ezResourceService.getFavoriteBrdList(catId, userInfo.getCompanyID(), userInfo.getTenantId(), userInfo.getId());

		Map<String, Object> result = new HashMap<String, Object>();
		result.put("list", list);
		result.put("userLang", userInfo.getLang());
		
		logger.debug("getBrdFavoriteList end");
		
		return result;
	}
	
	/**
	 * 자원, 카테고리(분류) 아동 Method
	 * @param loginCookie 
	 * @param requestBody => catId, brdId, topId 세 값을 파라미터로 받음
	 * brdId (자원 이동시 이동할 자원의 분류ID) = > 자원 이동시에만 자원의 brdId값이 넘어오고 해당 값의 유무로 카테고리 이동인지 자원 이동인지 구분됨
	 * catId (카테고리 이동시 이동될 카테고리 ID or 자원 이동 시 현재 속한 카테고리 ID) = > 카테고리 이동 시엔 이동할 카테고리(분류) ID가 넘어오고 자원 이동시엔 이동할 자원이 속한 카테고리(분류) ID가 넘어옴
	 * topId (최종 이동 카테고리 ID) = > 최종적으로 이동되어질 카테고리(분류) ID
	 * @return 결과 문자열 
	 * "equalfail" - 현재 위치로 이동 시도 했을 경우
	 * "fail" - 분류 이동 시 하위로 이동 시도 했을 경우
	 * "true" - 이동 성공 
	 */
	@RequestMapping(value = "/ezResource/moveCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> moveCategory(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> requestBody) throws Exception {
		logger.debug("moveCategory start");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String catId = requestBody.get("catId") != null ? (String) requestBody.get("catId") : null;
		String topId = requestBody.get("topId") != null ? (String) requestBody.get("topId") : null;
		String brdId = requestBody.get("brdId") != null ? (String) requestBody.get("brdId") : null;
		logger.debug("resquestBody : catId=" + catId + ", topId=" + topId + ", brdId=" + brdId);
		
		String resultStr="";
		if (brdId != null) {
			//자원을 다른 카테고리로 이동
			resultStr = ezResourceService.moveResource(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId(), catId, brdId, topId);
		} else {
			if (catId.equals(topId)) {
				//현재 카테고리
				resultStr = "equalfail";
			}
			//카테고리를 다른 카테고리 이동
			resultStr = ezResourceService.moveCategory(userInfo.getId(), userInfo.getCompanyID(), userInfo.getTenantId(), catId, topId);
		}
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("result", resultStr);
		
		logger.debug("moveCategory end, result=" + resultStr);
		
		return result;
	}
	
	/**
	 * 즐겨찾기 카테고리(분류)의 자원 정보 삭제
	 */
	@RequestMapping(value = "/ezResource/delBrdFavoriteCategory.do", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> delBrdFavoriteCategory(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> resquestBody) throws Exception {
		logger.debug("delBrdFavoriteCategory start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String delBrdId = resquestBody.get("delBrdId") != null ? (String) resquestBody.get("delBrdId") : null;
		String delTopId = resquestBody.get("delTopId") != null ? (String) resquestBody.get("delTopId") : null;
		logger.debug("resquestBody : delBrdId=" + delBrdId + ", delTopId=" + delTopId);
		
		ezResourceService.delBrdFavoriteCategory(userInfo.getId(), userInfo.getTenantId(), userInfo.getCompanyID(), delBrdId, delTopId);
		
		Map<String, Object> result = new HashMap<String, Object>();
		result.put("type", "BD");
		
		logger.debug("delBrdFavoriteCategory end");
		
		return result;
	}
	
	/**
	 * 자원 즐겨찾기 관리 "자원 즐겨찾기 분류 추가/수정" 창 호출
	 */
	@RequestMapping(value = "/ezResource/inputNameDlg.do", method = RequestMethod.GET)
	public String delBrdFavoriteCategory() throws Exception {
		return "/ezResource/resInputNameDlg";
	}
	
	/**
	 * 즐겨찾기 관리 "이동" 창 호출
	 */
	@RequestMapping(value = "/ezResource/resFavoriteMove.do", method = RequestMethod.GET)
	public String resFavoriteMove() throws Exception {
		return "/ezResource/resFavoriteMove";
	}

    /**
     * 자원반복설정 값 확인 
     */
    @RequestMapping(value = "/ezResource/repeatFlagCheck.do", method = RequestMethod.GET)
    @ResponseBody
    public Map<String, Object> repeatFlagCheck(HttpServletRequest request, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
        logger.debug("repeatFlagCheck start");
        userInfo = commonUtil.userInfo(loginCookie);
        String[] resIDArray = request.getParameterValues("resIDArray[]");
        List<String> repeatCheckList = new ArrayList<>();
        String repeatResult = "true";

        try{
            if (resIDArray != null && resIDArray.length > 0){
                for (String resID : resIDArray) {
                    String brdRepeatFlag = ezResourceService.getBrdRepeatFlag(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
                    if (!brdRepeatFlag.equals("1")) {
                        repeatCheckList.add(resID);
                        repeatResult = "false";
                    }
                }
            }
        }catch(Exception e){
            logger.error(e.getMessage(), e);
            repeatResult = "error";
        }

        Map<String, Object> result = new HashMap<String, Object>();
        result.put("repeatCheckList", repeatCheckList);
        result.put("repeatResult", repeatResult);

        logger.debug("repeatFlagCheck end");
        return result;
    }
}
