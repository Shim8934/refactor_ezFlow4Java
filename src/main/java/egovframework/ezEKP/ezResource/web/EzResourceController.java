package egovframework.ezEKP.ezResource.web;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResAdminVO;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
import egovframework.ezEKP.ezResource.vo.ResGetRepDateTimesVO;
import egovframework.ezEKP.ezResource.vo.ResGetScheduleVO;
import egovframework.ezEKP.ezResource.vo.ResGetSendMailToUserVO;
import egovframework.ezEKP.ezResource.vo.ResMakeDupResultVO;
import egovframework.ezEKP.ezResource.vo.ResSelectFormIDVO;
import egovframework.let.user.login.service.LoginService;
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
	
	/**
	 * 자원관리 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/resMain.do")
	public String resMain(HttpServletRequest req, Model model) throws Exception {
		String brdID = "";
		String brdNm = "";
		String brdTopPath = "";
		String pUrl = "";
		String url = "/ezResource/leftResource.do";
		
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
		
		model.addAttribute("pUrl", pUrl);
		
		return "/ezResource/resMain";
	}
	
	/**
	 * 자원관리 좌측메뉴 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/leftResource.do")
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
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String selectFlag = "";
		
		if(req.getParameter("flag") != null) {
			selectFlag = req.getParameter("flag");
		}
		
		String ret = ezResourceService.getSubClsTree(xmlReq, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
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
				
				if(nodes2.item(0).getTextContent().equals("")) {
					nodes2.item(0).setTextContent("<![CDATA[]]>");
				}
				if(nodes5.item(i).getTextContent().equals("")) {
					nodes5.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes6.item(i).getTextContent().equals("")) {
					nodes6.item(i).setTextContent("<![CDATA[]]>");
				}
				if(nodes7.item(i).getTextContent().equals("")) {
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
		return commonUtil.convertDocumentToString(xmlRet).replace("&lt;", "<").replace("&gt;", ">");
	
	}
	
	/**
	 * 스케줄 정보 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleGet.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGet(@RequestBody String xmlStr,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("scheduleGet Start");
		logger.debug("xmlStr="+xmlStr);
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String reVal = "";
		String resID = "";
		String cmd = "";
		String type = "";
		String viewType = "";
		String approveFlag = "";
		String writerName = "";
		String writerDept = "";
		String gubun = "P";
		String groupID = "";
		String startDate = "";
		String endDate = "";
		String resultXML = "";
		String resultXML1 = "";
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
			startDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
			endDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

			if (viewType.equals("list")) {
				approveFlag = xmlDom.getElementsByTagName("APPROVEFLAG").item(0).getTextContent();
				writerName = xmlDom.getElementsByTagName("WRITERNAME").item(0).getTextContent();
				writerDept = xmlDom.getElementsByTagName("WRITERDEPT").item(0).getTextContent();
			}
			
			if (type.equals("") || type == null) {
				xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate.substring(0, 10));
				xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate.substring(0, 10));
			} else {
				if (type.equals("MAIN")) {
					xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate.substring(0, 10));
					xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate.substring(0, 10));
				} else {
					String startDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDate.substring(0,10), -1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss","");
					String endDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(endDate.substring(0,10), 1, "yyyy-MM-dd"), "yyyy-MM-dd", "yyyy-MM-dd HH:mm:ss","");

					xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate1);
					xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate1);
				}
			}
			reVal = ezResourceService.getScheduleXML(commonUtil.convertDocumentToString(xmlDom), resID, userInfo.getCompanyID(), groupID, gubun, type, writerName, writerDept, userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("getScheduleXML=" + reVal);
				
			Document xmlDom2 = commonUtil.convertStringToDocument(reVal);
				
			for (int i=0; i<xmlDom2.getDocumentElement().getChildNodes().getLength(); i++) {
				String sDate = ezResourceService.getLocalTime(xmlDom2.getElementsByTagName("dtstart").item(i).getTextContent().replace("T","").substring(0, 16));
				String eDate = ezResourceService.getLocalTime(xmlDom2.getElementsByTagName("dtend").item(i).getTextContent().replace("T","").substring(0, 16));

				sDate = ezResourceService.convertToUTC(sDate);
				eDate = ezResourceService.convertToUTC(eDate);
					
				xmlDom2.getElementsByTagName("dtstart").item(i).setTextContent(sDate);
				xmlDom2.getElementsByTagName("dtend").item(i).setTextContent(eDate);
			}
				
			reVal = commonUtil.convertDocumentToString(xmlDom2);
				
			Document orderXML = commonUtil.convertStringToDocument(reVal);
			if (viewType.equals("list")) {
				String ownerNm = "owner_nm";
				String deptName = "dept_name";
				if (!userInfo.getLang().equals("1")) {
					ownerNm = "owner_nm2";
					deptName = "dept_name2";
				}
					
				// 승인 or 비승인 보기
				if (!approveFlag.trim().equals("")) {
					resultXML += "<root>";
					for (int i=0; i<orderXML.getElementsByTagName("appointment").getLength(); i++) {
						if (orderXML.getElementsByTagName("approveFlag").item(i).getTextContent().equals(approveFlag)) {
							resultXML += "<appointment>";
							resultXML += "<number>"+orderXML.getElementsByTagName("number").item(i).getTextContent()+"</number>";
							resultXML += "<pnumber>"+orderXML.getElementsByTagName("pnumber").item(i).getTextContent()+"</pnumber>";
							resultXML += "<owner_id>"+orderXML.getElementsByTagName("owner_id").item(i).getTextContent()+"</owner_id>";
							resultXML += "<writer_id>"+orderXML.getElementsByTagName("writer_id").item(i).getTextContent()+"</writer_id>";
							resultXML += "<subject>"+orderXML.getElementsByTagName("subject").item(i).getTextContent()+"</subject>";
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
							resultXML += "<owner_nm>"+orderXML.getElementsByTagName("owner_nm").item(i).getTextContent()+"</owner_nm>";
							resultXML += "<dept_name>"+orderXML.getElementsByTagName("dept_name").item(i).getTextContent()+"</dept_name>";
							resultXML += "<writeDay>"+orderXML.getElementsByTagName("writeDay").item(i).getTextContent()+"</writeDay>";
							resultXML += "<owner_nm2>"+orderXML.getElementsByTagName("owner_nm2").item(i).getTextContent()+"</owner_nm2>";
							resultXML += "<dept_name2>"+orderXML.getElementsByTagName("dept_name2").item(i).getTextContent()+"</dept_name2>";
							resultXML += "<jobtitle>"+orderXML.getElementsByTagName("jobtitle").item(i).getTextContent()+"</jobtitle>";
							resultXML += "<jobtitle2>"+orderXML.getElementsByTagName("jobtitle2").item(i).getTextContent()+"</jobtitle2>";
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
					int startCount = (page -1) * 20;
					int endCount = page * 20;

					if (Integer.parseInt(tempXML.getElementsByTagName("count").item(i).getTextContent()) >= startCount && Integer.parseInt(tempXML.getElementsByTagName("count").item(i).getTextContent())< endCount) {
						resultXML1 += "<appointment>";
						resultXML1 += "<number>"+tempXML.getElementsByTagName("number").item(i).getTextContent()+"</number>";
						resultXML1 += "<pnumber>"+tempXML.getElementsByTagName("pnumber").item(i).getTextContent()+"</pnumber>";
						resultXML1 += "<owner_id>"+tempXML.getElementsByTagName("owner_id").item(i).getTextContent()+"</owner_id>";
						resultXML1 += "<writer_id>"+tempXML.getElementsByTagName("writer_id").item(i).getTextContent()+"</writer_id>";
						resultXML1 += "<subject>"+tempXML.getElementsByTagName("subject").item(i).getTextContent()+"</subject>";
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
						resultXML1 += "<owner_nm>"+tempXML.getElementsByTagName("owner_nm").item(i).getTextContent()+"</owner_nm>";
						resultXML1 += "<dept_name>"+tempXML.getElementsByTagName("dept_name").item(i).getTextContent()+"</dept_name>";
						resultXML1 += "<writeDay>"+tempXML.getElementsByTagName("writeDay").item(i).getTextContent()+"</writeDay>";
						resultXML1 += "<owner_nm2>"+tempXML.getElementsByTagName("owner_nm2").item(i).getTextContent()+"</owner_nm2>";
						resultXML1 += "<dept_name2>"+tempXML.getElementsByTagName("dept_name2").item(i).getTextContent()+"</dept_name2>";
						resultXML1 += "<jobtitle>"+tempXML.getElementsByTagName("jobtitle").item(i).getTextContent()+"</jobtitle>";
						resultXML1 += "<jobtitle2>"+tempXML.getElementsByTagName("jobtitle2").item(i).getTextContent()+"</jobtitle2>";
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
			
		if (!reVal.equals("")) {
			return reVal.toString();
		}
		
		logger.debug("scheduleGet End");
		logger.debug("reVal="+reVal.toString());
		return reVal.toString();
	}
	
	
	/**
	 * 자원관리 리스트2 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewResList2.do")
	public String viewResList2(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		logger.debug("viewResList2 Start");
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String accessCode = "";
		String brdNm = "";
		int brdCount;
		String useEditor = "";
		
		if(req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		
		if(req.getParameter("accessCode") != null) {
			accessCode = req.getParameter("accessCode");
		}
		
		if(req.getParameter("brdNm") != null) {
			brdNm = req.getParameter("brdNm");
		}
		
		String adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId()); 
		logger.debug("adminFg="+adminFg);
		
		//brdNm = brdNm.replace("chr(38)", "&");
		String childBrd = ezResourceService.getItemList(loginCookie,brdID);
		logger.debug("childBrd="+childBrd);
		 
		List<ResGetItemListVO>	list = ezResourceService.getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang(), userInfo.getTenantId());

		brdCount = list.size();
		logger.debug("brdCount="+brdCount);
		for (int i=0; i<brdCount; i++) {
			childBrd += list.get(i).getBrd_ID() + "/" + list.get(i).getBrd_Nm() + "/" + list.get(i).getApproveFlag() + ",";
		}
		
		model.addAttribute("childBrd", childBrd);
		model.addAttribute("brdID", brdID);
		model.addAttribute("brdNm", brdNm);
		model.addAttribute("accessCode", accessCode);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdCount", brdCount);
		model.addAttribute("useEditor", useEditor);
		
		logger.debug("viewResList2 End");
		return "/ezResource/resViewResList2";
	}
	
	/**
	 * 자원관리 리스트 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewResList.do")
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
		adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId());

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

		int topCount = (Integer.parseInt(curPage.trim()) * pageSize);

		String brdNmStr = "";
		String ownDeptNm = "";
		String ownerNm = "";
		String ownerPosition = "";
		
		if (userInfo.getPrimary().equals("1")) {
			brdNmStr = "Brd_NM";
			ownerNm = "OwnerNm";
			ownDeptNm = "OwnDeptNm";
			ownerPosition = "OwnerPosition";
		} else {
			brdNmStr = "Brd_NM" + userInfo.getPrimary();
			ownDeptNm = "OwnDeptNm" + userInfo.getPrimary();
			ownerNm = "OwnerNm" + userInfo.getPrimary();
			ownerPosition = "OwnerPosition" + userInfo.getPrimary();
		}
		
		List<ResBrdListVO> resBrdList =  ezResourceService.getBrdList(topCount, Integer.parseInt(brdID), userInfo.getCompanyID(), ownDeptNm, ownerNm, ownerPosition, brdNmStr, userInfo.getTenantId());
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
		
		return "/ezResource/resViewResList";
	}
	
	/**
	 * 자원관리 자원등록정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewClsItem.do")
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
		
		if (!req.getParameter("brdID").equals("")) {
			brdID = req.getParameter("brdID");
		}
		ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(brdID), userInfo.getCompanyID(), userInfo.getTenantId());
		strBrdID = resBrd.getBrdID();
		strBrdExplain = resBrd.getBrdExplain();
		strResLocation = resBrd.getResLocation();
		strOwnDeptID = resBrd.getOwnDeptID();
		strOwnerID = resBrd.getOwnerID();
		ownerCall = resBrd.getOwnerCall();
		
		if (userInfo.getLang().equals("1")) {
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
		strMakeDate = resBrd.getMakeDate() + " " + ezResourceService.getCurrentDate();
		strApproveFlag = resBrd.getApproveFlag();
		
		/*if (strApproveFlag.equals("1")) {
			resp.getWriter().write("&nbsp;" + egovMessageSource.getMessage("ezQuestion.t161", locale));
		} else {
			resp.getWriter().write("&nbsp;" + egovMessageSource.getMessage("ezQuestion.t162", locale));
		}*/
			
	
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
		model.addAttribute("makeDate", strMakeDate.substring(0, 10));
		model.addAttribute("approveFlag", strApproveFlag);
		
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

		
		if (req.getParameter("brdID") != null && !req.getParameter("brdID").equals("")) {
			brdID = req.getParameter("brdID");
		}
			
		if (ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId()).equals("Y")) {
			boolean returnValue = ezResourceService.multiDelResData(xmlDom, userInfo.getTenantId());
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
	@RequestMapping(value = "/ezResource/modClsItem.do")
	public String modClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String resID = "";
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
		
		if (req.getParameter("brdID") != null) {
			brdID = req.getParameter("brdID");
		}
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		
		if (ezResourceService.getAdminFlag(userInfo.getCompanyID(), resID, userInfo.getId(), userInfo.getTenantId()).equals("Y")) {
			ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(brdID), userInfo.getCompanyID(), userInfo.getTenantId());
			strBrdID = resBrd.getBrdID();
			strBrdExplain = resBrd.getBrdExplain();
			strResLocation = resBrd.getResLocation();
			strOwnDeptID = resBrd.getOwnDeptID();
			strOwnerID = resBrd.getOwnerID();
			ownerCall = resBrd.getOwnerCall();
			
			if (userInfo.getLang().equals("1")) {
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
			strMakeDate = resBrd.getMakeDate() + " " + ezResourceService.getCurrentDate();
			strApproveFlag = resBrd.getApproveFlag();
		}
			
	
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("userName", userInfo.getName());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("deptName", userInfo.getDeptName1());
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
		model.addAttribute("makeDate", strMakeDate.substring(0, 10));
		model.addAttribute("approveFlag", strApproveFlag);
		
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
		
		String strOwnerID = xmlDom.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String propList = "displayName1;displayName2;title1;title2;description1;description2";
		String infoXML = ezOrganService.getPropertyList(strOwnerID, propList, userInfo.getLang(), userInfo.getTenantId());
		
		Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
		String deptName = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		String deptName2 = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		String displayName = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
		String displayName2 = xmlDom2.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		String title = xmlDom2.getElementsByTagName("TITLE1").item(0).getTextContent();
		String title2 = xmlDom2.getElementsByTagName("TITLE2").item(0).getTextContent();
		
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
		
		boolean returnValue = ezResourceService.modifyResData(commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId());
		
		StringBuilder strXML = new StringBuilder();
		strXML.append("<RTN>" + String.valueOf(returnValue) + "</RTN>");
		return strXML.toString();
		
	}
	
	/**
	 * 자원관리 자원 추가 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/addClsItem.do")
	public String addClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		
		if (!req.getParameter("brdID").equals("")) {
			brdID = req.getParameter("brdID");
		}
		
		model.addAttribute("brdID", brdID);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("userName", userInfo.getName());
		model.addAttribute("deptName", userInfo.getDeptName1());
		model.addAttribute("title", userInfo.getTitle1());
		model.addAttribute("displayName", userInfo.getDisplayName1());
		model.addAttribute("ownerCall", userInfo.getPhone());
		model.addAttribute("makeDate", EgovDateUtil.getTodayTime().substring(0, 10));
		model.addAttribute("langPrimary", ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId()));
		model.addAttribute("langSecondary", ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId()));
		
		return "/ezResource/resAddClsItem";
	}
	
	/**
	 * 자원관리 자원 추가 실행 함수
	 */
	@RequestMapping(value = "/ezResource/callAddClsItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callAddClsItem(@CookieValue("loginCookie") String loginCookie, Model model, @RequestBody String xmlStr) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		Locale locale = userInfo.getLocale();
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String strOwnerID = xmlDom.getElementsByTagName("DATA").item(3).getTextContent().trim();
		String propList = "displayName1;displayName2;title1;title2;description1;description2";
		String infoXML = ezOrganService.getPropertyList(strOwnerID, propList, userInfo.getLang(), userInfo.getTenantId());
		
		Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
		String deptName = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		String deptName2 = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
		String displayName = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
		String displayName2 = xmlDom2.getElementsByTagName("DISPLAYNAME2").item(0).getTextContent();
		String title = xmlDom2.getElementsByTagName("TITLE1").item(0).getTextContent();
		String title2 = xmlDom2.getElementsByTagName("TITLE2").item(0).getTextContent();
		
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
		
		boolean returnValue = ezResourceService.addResData(commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId(),locale);
		
		StringBuilder strXML = new StringBuilder();
		strXML.append("<RTN>" + String.valueOf(returnValue) + "</RTN>");
		return strXML.toString();
	
	}
	
	/**
	 * 자원관리 자원 등록 조직도 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/selectPerson.do") 
	public String selectPerson(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String useOCS = "";
		String userLang = "";
		
		//임시
		useOCS = config.getProperty("config.USE_OCS");
		userLang = userInfo.getLang();
		
		model.addAttribute("useOCS", useOCS);
		model.addAttribute("userLang", userLang);
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("serverName", req.getServerName());
		
		return "/ezResource/resSelectPerson";
	}
	
	/**
	 * 자원관리 부서이름 체크 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/checkDeptName.do")
	public String checkDeptName() throws Exception {
		return "/ezResource/resCheckDeptName";
	}
	
	/**
	 * 자원관리 자원 일정 메인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleMain.do")
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
		
		if (userInfo.getLang().equals("1")) {
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
		String strOwnerID = resBrd.getOwnerID();
		//String strOwnerCall = resBrd.getOwnerCall();
		//String strMakeDate = ezResourceService.getLocalTime(resBrd.getMakeDate() + " " + EgovDateUtil.getCurrentDate("HH:mm:ss"));
		String strApproveFlag = resBrd.getApproveFlag();
		String strBrdAccess = resBrd.getBrdAccess();
		String pAdminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "everyone", userInfo.getTenantId());
		StringBuilder iYear = new StringBuilder();
		StringBuilder iMonth = new StringBuilder();
		
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
		
		String pOffset = "+09:00";
		int timeZoneStr = (Integer.parseInt(pOffset.split(":")[0]) * 60) + Integer.parseInt(pOffset.split(":")[1]);
		
		Date date = new Date();
		@SuppressWarnings("deprecation")
		int curYear = date.getYear()-100;

		for (int i=curYear; i>=curYear-6; i--) {
			if((curYear-3) == i) {
				iYear.append("<Option Value=\"" + String.valueOf(i) + "\" selected>" + String.valueOf(i) + "</Option>" );
			} else {
				iYear.append("<Option Value=\"" + String.valueOf(i) + "\">" + String.valueOf(i) + "</Option>" );
			}
		}
		
		
		@SuppressWarnings("deprecation")
		int curMonth = date.getMonth()+1;

		for (int j=1; j<= 12; j++) {
			if (curMonth == j) {
				iMonth.append("<Option Value=\"" + String.valueOf(j) + "\" selected>" + String.valueOf(j) + "</Option>" );
			} else {
				iMonth.append("<Option Value=\"" + String.valueOf(j) + "\">" + String.valueOf(j) + "</Option>" );
			}
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("adminFg", "Y");
		model.addAttribute("resID", resID);
		model.addAttribute("ownerID", strOwnerID);
		model.addAttribute("ownerNm", strOwnerNm);
		model.addAttribute("ownerPosition", strOwnerPosition);
		model.addAttribute("ownerDeptNm", strOwnDeptNm);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("approveFlag", strApproveFlag);
		model.addAttribute("brdNm", strBrdNm);
		model.addAttribute("brdAccess", strBrdAccess);
		model.addAttribute("displaySTime", displaySTime);
		model.addAttribute("displayETime", displayETime);
		model.addAttribute("nonActiveX", "YES");
		model.addAttribute("adminFg", pAdminFg);
		model.addAttribute("resLocation", strResLocation);
		model.addAttribute("brdExplain", strBrdExplain);
		model.addAttribute("timeZoneStr", timeZoneStr);
		
		return "/ezResource/resScheduleMain";
	}
	
	/**
	 * 자원관리 자원 일정 상세정보 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRead.do")
	public String scheduleRead(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		logger.debug("scheduleRead Start");
		userInfo = commonUtil.userInfo(loginCookie);
		
		String useIE11Browser = "";
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
		String startDateTime2 = "";
		String endDateTime2 = "";
		String timeDisplay = "";
		String content = "";
		String ownerID = "";
		String writerID = "";
		String curStartDateTime = "";
		String curEndDateTime = "";
		/*String curStartDateTime2 = "";
		String curEndDateTime2 = "";*/
		String checkSDT = "";
		String checkEDT = "";
		String allDay = "";
		String pNum = "";
		String num = "";
		String saveApproveFlag = "";
		String entryList = "";
		String startDateTimeRepeat = "";
		String endDateTimeRepeat = "";
		
		if (ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
			useIE11Browser = "CK";
		}
		if (req.getParameter("ownerID") != null) {
			resID = req.getParameter("ownerID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}

		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "", userInfo.getTenantId());
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
				getSchedule = ezResourceService.getSchedule(Integer.parseInt(orgNum), orgOwnerID, userInfo.getCompanyID(), userInfo.getTenantId());
			}
			
			num = String.valueOf(getSchedule.getNum());
			pNum = String.valueOf(getSchedule.getpNum());
			ownerID = getSchedule.getOwnerID();
			writerID = getSchedule.getWriterID();
			
			String propList = "displayName;description";
			String infoXML = ezOrganService.getPropertyList(writerID, propList, userInfo.getLang(), userInfo.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
			
			if (userInfo.getLang().equals("1")) {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
			} else {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION" + userInfo.getLang()).item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME" + userInfo.getLang()).item(0).getTextContent();
			}
			title = getSchedule.getTitle();
			
			if (title != null) {
				 title = title.replace("'", "&#39;");
                 title = title.replace("\"", "&quot;");
			}
			loc = getSchedule.getLocation();

			if (loc != null) {
				loc = title.replace("'", "&#39;");
                loc = title.replace("\"", "&quot;");
			}
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
			
			ResGetRepDateTimesVO repDateTimes = ezResourceService.getRepDateTimes(orgOwnerID, userInfo.getCompanyID(), Integer.parseInt(orgNum), userInfo.getTenantId());
			logger.debug("repDateTimes="+repDateTimes);
			
			if (repDateTimes != null) {
				startDateTimeRepeat = ezResourceService.getLocalTime(repDateTimes.getStartDateTime());
				endDateTimeRepeat = ezResourceService.getLocalTime(repDateTimes.getEndDateTime());
			}
		} else {
			importance = "2";
			String selSd = "";
			String selEd = "";
			String cDate = "";
			String cTime = "";
			
			if (req.getParameter("selsd") != null) {
				selSd = req.getParameter("selsd");
			}
			if (req.getParameter("seled") != null) {
				selEd = req.getParameter("seled");
			}
			if (selSd.equals("") || selEd.equals("")) {
				cDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
				cTime = cDate.split(" ")[1].substring(0, 2);
				
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
			} else {
				if (selSd.length() == 10) {
					cDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
					cTime = cDate.split(" ")[1].substring(0, 2);
					cDate = cDate.substring(0, 10);
					startDateTime = selSd + " " + cTime + ":00:00";
					endDateTime = selEd + " " + cTime + ":30:00";

				} else {
					startDateTime = selSd;
					endDateTime = selEd;
				}
			}
			if (req.getParameter("ownerID") != null) {
				ownerID = req.getParameter("ownerID");
			}
		}
		String curDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
		String curTime = curDate.split(" ")[1].substring(0, 2);
			
		if (req.getParameter("startDate") != null) {
			curDate = req.getParameter("startDate");
		}
		if (curDate.length() == 9) {
			curDate = curDate.substring(0, 9);
		} else {
			curDate = curDate.split(" ")[0];
		}
		curStartDateTime = curDate + " " + curTime + ":00:00";
			
		if (req.getParameter("endDate") != null) {
			curDate = req.getParameter("endDate");
		}
		if (curDate.length() == 9) {
			curDate = curDate.substring(0, 9);
		} else {
			curDate = curDate.split(" ")[0];
		}
		curEndDateTime = curDate + " " + curTime + ":30:00";
		
		curStartDateTime = EgovDateUtil.convertDate(curStartDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
		curEndDateTime = EgovDateUtil.convertDate(curEndDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
		
		/*curStartDateTime2 = EgovDateUtil.convertDate(curStartDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-M-d H:mm", "");
		curEndDateTime2 = EgovDateUtil.convertDate(curEndDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-M-d H:mm", "");*/
		
		startDateTime = ezResourceService.convertDate(startDateTime, "", "", "");
		endDateTime = ezResourceService.convertDate(endDateTime, "", "", "");

		startDateTime2 = ezResourceService.isoUTFDate(startDateTime, locale);
		endDateTime2 = ezResourceService.isoUTFDate(endDateTime, locale);

		checkSDT = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-M-d H:mm", "");
		checkEDT = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-M-d H:mm", "");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useIE11Browser", useIE11Browser);
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
		model.addAttribute("startDateTime2", startDateTime2);
		model.addAttribute("endDateTime2", endDateTime2);
		model.addAttribute("startDateTimeRepeat", startDateTimeRepeat);
		model.addAttribute("endDateTimeRepeat", endDateTimeRepeat);
		model.addAttribute("startDateVal", startDateVal);
		model.addAttribute("endDateVal", endDateVal);
		model.addAttribute("typeVal", typeVal);
		model.addAttribute("saveApproveFlag", saveApproveFlag);
		model.addAttribute("entryList", entryList);
		model.addAttribute("checkSDT", checkSDT);
		model.addAttribute("checkEDT", checkEDT);
		
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
		
		return "/ezResource/resScheduleRead";
	}
	
	/**
	 * 자원관리 자원 예약 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleAdd.do")
	public String scheduleAdd(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, HttpServletRequest req, Model model, Locale locale) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String useIE11Browser = "";
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
		String curStartDateTime = "";
		String curEndDateTime = "";
		/*String curStartDateTime2 = "";
		String curEndDateTime2 = "";*/
		String checkSDT = "";
		String checkEDT = "";
		String allDay = "";
		String saveApproveFlag = "";
		String startDateTimeRepeat = "";
		String endDateTimeRepeat = "";
		String entryList = "";
		
		int pNum = 0;
		int num = 0;
		
		if (ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
			useIE11Browser = "CK";
		}
		if (req.getParameter("ownerID") != null) {
			resID = req.getParameter("ownerID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}

		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "", userInfo.getTenantId());
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
				getSchedule = ezResourceService.getSchedule(Integer.parseInt(orgNum), orgOwnerID, userInfo.getCompanyID(), userInfo.getTenantId());
			}
			
			num = getSchedule.getNum();
			pNum = getSchedule.getpNum();
			ownerID = getSchedule.getOwnerID();
			writerID = getSchedule.getWriterID();
	
			String propList = "displayName;description";
			String infoXML = ezOrganService.getPropertyList(writerID, propList, userInfo.getLang(), userInfo.getTenantId());
			
			Document xmlDom2 = commonUtil.convertStringToDocument(infoXML);
			
			if (userInfo.getLang().equals("1")) {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION1").item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME1").item(0).getTextContent();
			} else {
				deptNm = xmlDom2.getElementsByTagName("DESCRIPTION" + userInfo.getLang()).item(0).getTextContent();
				ownerNm = xmlDom2.getElementsByTagName("DISPLAYNAME" + userInfo.getLang()).item(0).getTextContent();
			}
			title = getSchedule.getTitle();
			
			if (title != null) {
				 title = title.replace("'", "&#39;");
                 title = title.replace("\"", "&quot;");
			}
			loc = getSchedule.getLocation();

			if (loc != null) {
				loc = title.replace("'", "&#39;");
                loc = title.replace("\"", "&quot;");
			}
			timeDisplay = getSchedule.getTimeDisplay();
			startDateTime = getSchedule.getStartDate();
			endDateTime = getSchedule.getEndDate();
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
			
			ResGetRepDateTimesVO repDateTimes = ezResourceService.getRepDateTimes(orgOwnerID, userInfo.getCompanyID(), Integer.parseInt(orgNum), userInfo.getTenantId());
			logger.debug("repDateTimes="+repDateTimes);
			
			if (repDateTimes != null) {
				startDateTimeRepeat = ezResourceService.getLocalTime(repDateTimes.getStartDateTime());
				endDateTimeRepeat = ezResourceService.getLocalTime(repDateTimes.getEndDateTime());
			}
		} else {
			importance = "2";
			String selSd = "";
			String selEd = "";
			String cDate = "";
			String cTime = "";
			
			if (req.getParameter("selsd") != null) {
				selSd = req.getParameter("selsd");
			}
			if (req.getParameter("seled") != null) {
				selEd = req.getParameter("seled");
			}
			if (selSd.equals("") || selEd.equals("")) {
				cDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
				cTime = cDate.split(" ")[1].substring(0, 2);
				
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
			} else {
				if (selSd.length() == 10) {
					cDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
					cTime = cDate.split(" ")[1].substring(0, 2);
					cDate = cDate.substring(0, 10);
					startDateTime = selSd + " " + cTime + ":00:00";
					endDateTime = selEd + " " + cTime + ":30:00";

				} else {
					startDateTime = selSd;
					endDateTime = selEd;
				}
			}
			if (req.getParameter("ownerID") != null) {
				ownerID = req.getParameter("ownerID");
			}
		}
		String curDate = ezResourceService.getLocalTime(EgovDateUtil.getToday("time"));
		String curTime = curDate.split(" ")[1].substring(0, 2);
			
		if (req.getParameter("startDate") != null) {
			curDate = req.getParameter("startDate");
		}
		if (curDate.length() == 9) {
			curDate = curDate.substring(0, 9);
		} else {
			curDate = curDate.split(" ")[0];
		}
		curStartDateTime = curDate + " " + curTime + ":00:00";
			
		if (req.getParameter("endDate") != null) {
			curDate = req.getParameter("endDate");
		}
		if (curDate.length() == 9) {
			curDate = curDate.substring(0, 9);
		} else {
			curDate = curDate.split(" ")[0];
		}
		curEndDateTime = curDate + " " + curTime + ":30:00";
		
		curStartDateTime = EgovDateUtil.convertDate(curStartDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
		curEndDateTime = EgovDateUtil.convertDate(curEndDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-MM-dd HH:mm:ss", "");
		
		/*curStartDateTime2 = EgovDateUtil.convertDate(curStartDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-M-d H:mm", "");
		curEndDateTime2 = EgovDateUtil.convertDate(curEndDateTime, "yyyy-MM-dd HH:mm:ss", "yyyy-M-d H:mm", "");*/
		
		startDateTime = ezResourceService.convertDate(startDateTime, "", "", "");
		endDateTime = ezResourceService.convertDate(endDateTime, "", "", "");

		startDateTime2 = ezResourceService.isoUTFDate(startDateTime, locale);
		endDateTime2 = ezResourceService.isoUTFDate(endDateTime, locale);

		checkSDT = EgovDateUtil.convertDate(startDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-M-d H:mm", "");
		checkEDT = EgovDateUtil.convertDate(endDateTime, "yyyy-MM-dd aa h:mm:ss", "yyyy-M-d H:mm", "");
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("editor", editor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdName", brdName);
		model.addAttribute("resID", resID);
		model.addAttribute("num", num);
		model.addAttribute("approveFlag", brdApproveFlag);
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
		model.addAttribute("title", title);
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
		model.addAttribute("checkSDT", checkSDT);
		model.addAttribute("checkEDT", checkEDT);
		
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
		
		return "/ezResource/resScheduleAdd";
	}
	
	/**
	 * 자원관리 자원 양식 등록 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleManageForm.do")
	public String scheduleManageForm(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo,HttpServletRequest req,Model model) throws Exception {
		String resID = "";
		String brdName = "";
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		if (req.getParameter("brdName") != null) {
			brdName = req.getParameter("brdName");
		}
		
		String companyID = userInfo.getCompanyID();
		String adminFg = ezResourceService.getACL(userInfo.getCompanyID(), resID, userInfo.getId(), "everyone", userInfo.getTenantId());
		
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
	@RequestMapping(value = "/ezResource/scheduleRepetition.do")
	public String scheduleRepetition(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo", userInfo);
		return "/ezResource/resScheduleRepetition";
	}
	
	/**
	 * 자원관리 자원 반복 실행 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRepetitionProc.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8") 
	@ResponseBody
	public String scheduleRepetitionProc(@CookieValue("loginCookie") String loginCookie, Model model, HttpServletRequest req,@RequestBody String xmlStr) throws Exception {
		logger.debug("scheduleRepetitionProc started");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String companyID = "";
		String cmd = "";
		
		companyID = userInfo.getCompanyID();
			
		if (req.getParameter("cmd") != null) {
			cmd = req.getParameter("cmd");
		}
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
			
		if (cmd.equals("get")) {
			String ret = ezResourceService.getRepetition(xmlStr, userInfo.getTenantId());
			Document xmlRet = commonUtil.convertStringToDocument(ret);
			logger.debug("startDateTime="+xmlRet.getElementsByTagName("startDateTime").item(0).getTextContent());
			logger.debug("endDateTime="+xmlRet.getElementsByTagName("endDateTime").item(0).getTextContent());
			String startDate = commonUtil.getDateStringInUTC(xmlRet.getElementsByTagName("startDateTime").item(0).getTextContent(), userInfo.getOffset(), false);
			String endDate = commonUtil.getDateStringInUTC(xmlRet.getElementsByTagName("endDateTime").item(0).getTextContent(), userInfo.getOffset(), false);

			xmlRet.getElementsByTagName("startDateTime").item(0).setTextContent(ezResourceService.getLocalTime(EgovDateUtil.convertDate(startDate, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "")));
			xmlRet.getElementsByTagName("endDateTime").item(0).setTextContent(ezResourceService.getLocalTime(EgovDateUtil.convertDate(endDate, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", "")));
				
			return commonUtil.convertDocumentToString(xmlRet);
				
		} else if (cmd.equals("add") || cmd.equals("mod")) {
			String startDate = xmlDom.getElementsByTagName("startDateTime").item(0).getTextContent();
			String endDate = xmlDom.getElementsByTagName("endDateTime").item(0).getTextContent();

			/*xmlDom.getElementsByTagName("startDateTime").item(0).setTextContent(ezResourceService.getDBTime(EgovDateUtil.convertDate(startDate, "", "yyyy-MM-dd HH:mm:ss", "")));
			xmlDom.getElementsByTagName("endDateTime").item(0).setTextContent(ezResourceService.getDBTime(EgovDateUtil.convertDate(endDate, "", "yyyy-MM-dd HH:mm:ss", "")));*/
			xmlDom.getElementsByTagName("startDateTime").item(0).setTextContent(EgovDateUtil.convertDate(startDate, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", ""));
			xmlDom.getElementsByTagName("endDateTime").item(0).setTextContent(EgovDateUtil.convertDate(endDate, "yyyy-MM-dd HH:mm", "yyyy-MM-dd HH:mm:ss", ""));
				
			String num = req.getParameter("num") != null ? req.getParameter("num").trim() : "";
			String ownerID = req.getParameter("ownerID") != null ? req.getParameter("ownerID").trim() : "";
		
			boolean ret = ezResourceService.saveRepetition(companyID, num, ownerID, commonUtil.convertDocumentToString(xmlDom), cmd, userInfo.getTenantId(), userInfo.getOffset());
				
			if (ret == true) {
				return "OK";
			} else {
				return "NO";
			}
		} else if (cmd.equals("del")) {
			boolean ret = ezResourceService.deleteRepetition(commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId());
				
			if (ret == true) {
				return "OK";
			} else {
				return "NO";
			}
		}

		logger.debug("scheduleRepetitionProc ended");
		return "";

	}
	
	/**
	 * 자원관리 ckEditor 호출 Method
	 */
	@RequestMapping(value = "/ezResource/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo",userInfo);
		
		return "/ezResource/resCKEditor";
	}
	
	/**
	 * 자원관리 스케줄 폼 호출 Method
	 */
	@RequestMapping(value = "/ezResource/scheduleGetForm.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleGetForm(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie, LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
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
	@RequestMapping(value = "/ezResource/scheduleApprovList.do")
	public String scheduleApprovList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String resID = "";
		String brdNm = "";
		String startDate = "";
		String endDate = "";
		
		if (req.getParameter("resID") != null) {
			resID = req.getParameter("resID");
		}
		if (req.getParameter("startDate") != null) {
			startDate = req.getParameter("startDate");
		}
		if (req.getParameter("endDate") != null) {
			endDate = req.getParameter("endDate");
		}
		ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(resID), userInfo.getCompanyID(), userInfo.getTenantId());
		if (userInfo.getLang().equals("1")) {
			brdNm = resBrd.getBrdNm();
		} else {
			brdNm = resBrd.getBrdNm2();
		}
	
		model.addAttribute("userInfo",userInfo);
		model.addAttribute("resID",resID);
		model.addAttribute("brdNm",brdNm);
		model.addAttribute("startDate",startDate);
		model.addAttribute("endDate",endDate);
		
		return "/ezResource/resScheduleApprovList";
	}
	
	/**
	 * 자원관리 양식등록 저장 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/apropinion.do")
	public String apropinion() throws Exception {
		
		return "/ezResource/resApropinion";
	}
	
	/**
	 * 자원관리 양식등록 실행  함수
	 */
	@RequestMapping(value = "/ezResource/scheduleSaveForm.do")
	@ResponseBody
	public String scheduleSaveForm(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie,LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		String resID = xmlDom.getDocumentElement().getChildNodes().item(0).getTextContent();
		String brdNm = xmlDom.getDocumentElement().getChildNodes().item(1).getTextContent();
		String formText = xmlDom.getDocumentElement().getChildNodes().item(2).getTextContent();
		try{
			ezResourceService.insertForm(resID, brdNm, formText, userInfo.getTenantId());
			return "OK";
		}catch(Exception e){
			e.printStackTrace();
			return "FALSE";
		}
	}
	
	/**
	 * 자원관리 양식삭제 실행  함수
	 */
	@RequestMapping(value = "/ezResource/scheduleDelForm.do")
	@ResponseBody
	public String scheduleDelForm(@RequestBody String xmlStr, @CookieValue("loginCookie") String loginCookie,LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		try {
			String delCode = xmlDom.getElementsByTagName("RESID").item(0).getTextContent();
			ezResourceService.delFormID(delCode, userInfo.getTenantId());
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "FALSE";
		}
	}
	
	/**
	 * 자원관리 자원예약 자원선택 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleAddSelect.do")
	public String scheduleAddSelect(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo, Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		String brdID = "";
		String brdNm = "";
		String brdGubun = "";
		//String accessCode = "";
		String selectNo = "";
		String useEditor = "";
		String useIE11Browser = "";
		String noneActiveX = "";
		
		noneActiveX = "YES";
		useEditor = config.getProperty("EDITOR");
		useIE11Browser = "CK";
		
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
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
			
	
				
		return "/ezResource/resScheduleAddSelect";
	}
	
	/**
	 * 자원관리 자원예약 자원선택 자원관리 추가시 권한 체크 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleAddGetACL.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleAddGetACL(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo,Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String ret = "";
		
		brdID = req.getParameter("brdID");
		ret = ezResourceService.getACL(userInfo.getCompanyID(), brdID, userInfo.getId(), "everyone", userInfo.getTenantId());
		
		return "<RESULT>"+ret+"</RESULT>";
	}
	
	/**
	 * 자원관리 자원예약 저장 후 닫기 실행 함수
	 */
	@SuppressWarnings("deprecation")
	@RequestMapping(value = "/ezResource/scheduleAddOk.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String scheduleAddOk(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo,Model model, HttpServletRequest req, @RequestBody String xmlStr) throws Exception {
		logger.debug("scheduleAddOk Start");
		userInfo = commonUtil.userInfo(loginCookie);
		String cmd = "";
		String typeVal = "";
		String companyID = "";
		
		if (req.getParameter("cmd") != null && !req.getParameter("cmd").equals("")) {
			cmd = req.getParameter("cmd");
		}
		if (req.getParameter("type") != null && !req.getParameter("type").equals("")) {
			typeVal = req.getParameter("type");
		}
		companyID = userInfo.getCompanyID();
		logger.debug("xmlStr="+xmlStr);
		Document dom = commonUtil.convertStringToDocument(xmlStr);
			
		if (cmd.equals("del")) {
			logger.debug("del Start");
			Node rootNode = dom.getDocumentElement();
			Node objNode = dom.createElement("COMPANYID");
			objNode.setTextContent(companyID);
			rootNode.appendChild(objNode);
				
			boolean reVal = ezResourceService.delResSch(commonUtil.convertDocumentToString(dom), userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("reVal="+reVal);	
			if (reVal == true) {
				return "OK";
			} else {
				return "NO";
			}
		} else if (cmd.equals("add")) {
			logger.debug("add Start");
			String startDate = dom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
			String endDate = dom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
			SimpleDateFormat tempEndDate = new SimpleDateFormat("yyyy-MM-dd HH:mm");
				
			//////////////////////////////추후 수정
			if (String.valueOf(tempEndDate.parse(endDate).getHours()).equals("0") && String.valueOf(tempEndDate.parse(endDate).getMinutes()).equals("0")) {
				endDate = ezResourceService.addMinutes(endDate, -1, "yyyy-MM-dd HH:mm");
			}
			dom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate);
			dom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate);

			String ret = ezResourceService.addResSch(commonUtil.convertDocumentToString(dom), userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("ret="+ret);
			return ret;
		} else if (cmd.equals("mod")) {
			logger.debug("mod Start");
			String startDate = dom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
			String endDate = dom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
			SimpleDateFormat tempEndDate = new SimpleDateFormat("yyyy-MM-dd HH:mm");

			//////////////////////////////추후 수정
			if (String.valueOf(tempEndDate.parse(endDate).getHours()).equals("0") && String.valueOf(tempEndDate.parse(endDate).getMinutes()).equals("0")) {
				endDate = ezResourceService.addMinutes(endDate, -1, "yyyy-MM-dd HH:mm");
			}
			dom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate);
			dom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate);
				
			Node rootNode = dom.getDocumentElement();
			Node objNode = dom.createElement("TYPE_VAL");
			objNode.setTextContent(typeVal);
			rootNode.appendChild(objNode);

			String ret = ezResourceService.modifyResSch(commonUtil.convertDocumentToString(dom), userInfo.getTenantId(), userInfo.getOffset());
			logger.debug("ret="+ret);
			return ret;
		}
		logger.debug("scheduleAddOk End");
		return "";
	}
	
	/**
	 * 자원관리 자원예약 사용자 선택 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleSelectUser.do")
	public String scheduleSelectUser(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo,Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		model.addAttribute("userInfo", userInfo);
		return "/ezResource/resScheduleSelectUser";
	}
	
	/**
	 * 자원관리 자원예약 부서 선택 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleSelectDept.do")
	public String scheduleSelectDept(@CookieValue("loginCookie") String loginCookie,LoginVO userInfo,Model model, HttpServletRequest req) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		return "/ezResource/resScheduleSelectDept";
	}
	
	/**
	 * 자원관리 자원등록 조직도 부서 사원목록 호출 함수
	 */
	@RequestMapping(value = "/ezResource/getDeptMemberList.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String getDeptMemberList(@RequestBody String data, HttpServletRequest request, HttpServletResponse response, @CookieValue("loginCookie") String loginCookie,LoginVO userInfo) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document doc = commonUtil.convertStringToDocument(data);
		
		String deptID = doc.getElementsByTagName("deptID").item(0).getTextContent();
		String cell = doc.getElementsByTagName("cell").item(0).getTextContent();    
        String propList = doc.getElementsByTagName("prop").item(0).getTextContent();
        String listType = doc.getElementsByTagName("type").item(0).getTextContent();
        
        String returnXML = ezOrganService.getDeptMemberList(deptID, cell, propList, listType, userInfo.getLang(), userInfo.getTenantId());
        
		return returnXML;
	}
	
	/**
	 * 자원관리 자원반복 삭제 확인 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/scheduleRepetitionDel.do")
	public String scheduleRepetitionDel() throws Exception {
		return "/ezResource/resScheduleRepetitionDel";
	}
	
	/**
	 * 자원관리 자원사용 승인Flag 저장 실행 함수
	 */
	@RequestMapping(value = "/ezResource/updateApprovalFlag.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String updateApprovalFlag(@RequestBody String xmlStr, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		Document dom = commonUtil.convertStringToDocument(xmlStr);
		try {
			String companyID = dom.getElementsByTagName("COMPANYID").item(0).getTextContent();
			String resID = dom.getElementsByTagName("RESID").item(0).getTextContent();
			String num = dom.getElementsByTagName("NUM").item(0).getTextContent();
			String approve = dom.getElementsByTagName("APPROVE").item(0).getTextContent();
			
			ezResourceService.updateSchedule(Integer.parseInt(num), resID, companyID, approve, userInfo.getTenantId());
			
			return "True";
		} catch (Exception e) {
			e.printStackTrace();
			return "False";
		}
	}
	
	/**
	 * 자원관리 중복체크 실행 함수
	 */
	@RequestMapping(value = "/ezResource/timeDupCheck.do", produces="text/xml;charset=utf-8")
	@ResponseBody
	public String timeDupCheck(@RequestBody String xmlStr, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		logger.debug("timeDupCheck started");

		userInfo = commonUtil.userInfo(loginCookie);
		String ret = "";
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		boolean isRep = xmlDom.getElementsByTagName("recurrence").getLength() != 0;
		String resID = xmlDom.getElementsByTagName("RESID").item(0).getTextContent();
		String sTime = xmlDom.getElementsByTagName("STIME").item(0).getTextContent();
		String eTime = xmlDom.getElementsByTagName("ETIME").item(0).getTextContent();
		String companyID = xmlDom.getElementsByTagName("COMPANYID").item(0).getTextContent();
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String cmd = xmlDom.getElementsByTagName("CMD").item(0).getTextContent();
		String approve = xmlDom.getElementsByTagName("APPROVE").item(0).getTextContent();
		
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
		String allDay = xmlDom.getElementsByTagName("allday").getLength() == 0 ? "" : xmlDom.getElementsByTagName("allday").item(0).getTextContent();
		
		String allDayStime = sTime.split(" ")[0] + " 00:00:00";
		String allDayEtime = eTime.split(" ")[0] + " 23:59:00";
		StringBuilder strSQL = new StringBuilder();
		
		if (cmd.toLowerCase().equals("add")) {
			strSQL.append("SELECT ISNULL(COUNT(ownerID),0) AS cnt");
			strSQL.append("FROM TB_Schedule");
			strSQL.append("WHERE companyID ="+"'"+companyID+"'");
			strSQL.append("AND ownerID ="+"'"+resID+"'");
			strSQL.append("AND reFlag ="+0);
			strSQL.append("AND approveFlag = '1'");
			strSQL.append("AND NOT(  ");
			strSQL.append("                (endDate <=  ");
			strSQL.append("                    (CASE allday WHEN '0' THEN "+"'"+sTime+"'");
			strSQL.append("                     WHEN '1' THEN "+"'"+allDayStime+"'"+ "END)");
			strSQL.append("              ) or (");
			strSQL.append("                      (CASE allday WHEN '0' THEN "+ "'"+eTime+"'");
			strSQL.append("                     WHEN '1' THEN "+"'"+allDayEtime+"'"+ "END) <= startDate)");
			strSQL.append("              )");
		} else {
			strSQL.append("SELECT ISNULL(COUNT(ownerID),0) AS cnt");
			strSQL.append("FROM TB_Schedule");
			strSQL.append("WHERE companyID ="+"'"+companyID+"'");
			strSQL.append("AND ownerID ="+"'"+resID+"'");
			strSQL.append("AND reFlag = 0");
			strSQL.append("AND approveFlag = '1'");
			strSQL.append("AND NOT IN ("+num+")");
			strSQL.append("AND NOT ( ");
			strSQL.append("                 (endDate <=  ");
			strSQL.append("                    (CASE allday WHEN '0' THEN "+"'"+sTime+"'");
			strSQL.append("                     WHEN '1' THEN "+"'"+allDayStime+"'"+ "END)");
			strSQL.append("              ) or (");
			strSQL.append("                      (CASE allday WHEN '0' THEN "+ "'"+eTime+"'");
			strSQL.append("                     WHEN '1' THEN "+"'"+allDayEtime+"'"+ "END) <= startDate)");
			strSQL.append("              )");
		}
		
		boolean isDupRep = false;
		List<ResMakeDupResultVO> dtResult = new ArrayList<ResMakeDupResultVO>();
		//반복예약 데이터가 있을 때
		if (isRep) {
			logger.debug("===반복예약 데이터가 있을 때===");
			if (cmd.equals("add")) {
				num = null;
			}
			isDupRep = ezResourceService.getRepResource(frequency, selType, endRecurType, startDateTime, endDateTime, interval, daysOfWeek, instances, byPosition, daysOfMonth, resID, num, cmd, companyID, dtResult, userInfo.getTenantId(), userInfo.getOffset());
		}
		
		//반복예약 데이터가 없을 때
		if (!isRep) {
			logger.debug("===반복예약 데이터가 없을 때===");
			if (cmd.equals("add")) {
				num = null;
			}
			
			if (!allDay.equals("") && Boolean.parseBoolean(allDay)) {
				isDupRep = ezResourceService.getRepResource(allDayStime, allDayEtime, resID, num, cmd, companyID, dtResult, userInfo.getTenantId(), userInfo.getOffset());
			} else {
				isDupRep = ezResourceService.getRepResource(sTime, eTime, resID, num, cmd, companyID, dtResult, userInfo.getTenantId(), userInfo.getOffset());
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
	@RequestMapping(value = "/ezResource/scheduleRepetitionOpen.do")
	public String scheduleRepetitionOpen() throws Exception {
		return "/ezResource/resScheduleRepetitionOpen";
	}
	
	/**
	 * 자원관리 권한없는 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/nonResList.do")
	public String nonResList(HttpServletRequest req, Model model) throws Exception {
		String accMessage = "";
		if (req.getParameter("msg") != null && !req.getParameter("msg").equals("")) {
			accMessage = req.getParameter("msg");
		}
		model.addAttribute("accMessage", accMessage);
		return "/ezResource/resNonResList";
	}
	
	/**
	 * 자원관리 승인 후 알림 발송 실행 함수
	 */
	@RequestMapping(value = "/ezResource/sendMail.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String sendMail(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, @RequestBody String xmlStr) throws Exception {
		logger.debug("sendMail started");
		
		System.out.println("xmlStr=" + xmlStr);
		
		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String ownerID = xmlDom.getElementsByTagName("OWNERID").item(0).getTextContent();
		String title = xmlDom.getElementsByTagName("TITLE").item(0).getTextContent();
		String startDateTime = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
		String endDateTime = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();
		
		startDateTime = commonUtil.getDateStringInUTC(startDateTime, userInfo.getOffset(), false);
		endDateTime = commonUtil.getDateStringInUTC(endDateTime, userInfo.getOffset(), false);
		
		logger.debug("ownerID=" + ownerID + ",title=" + title + ",startDateTime=" + startDateTime + ",endDateTime=" + endDateTime);
		
		ResAdminVO resInfo = ezResourceService.getResourceAdminInfo(ownerID, userInfo.getTenantId());
        
        StringBuilder bodyContent = new StringBuilder();

        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
        
        if (userInfo.getLang().equals("1")) {
        	bodyContent.append(userInfo.getDisplayName() +"[" + userInfo.getDeptName() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
        } else {
        	bodyContent.append(userInfo.getDisplayName2() +"[" + userInfo.getDeptName2() + "] " + egovMessageSource.getMessage("ezResource.t9900002", userInfo.getLocale()));
        }
        
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900003", userInfo.getLocale()) + " : " +resInfo.getBrdNm()); 
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;" + egovMessageSource.getMessage("ezResource.t9900004", userInfo.getLocale()) + " : " +startDateTime + "&nbsp;~&nbsp;" + endDateTime);
        bodyContent.append("</DIV>");
        
        String subject = "[" + egovMessageSource.getMessage("ezResource.t171", userInfo.getLocale()) + resInfo.getBrdNm() + "] " + title;
        
        
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
    	String emailAddress = resInfo.getMailAddress();
    	String accessName = resInfo.getOwnerNm();
    	
    	if (accessName.indexOf("(") > -1) {
    		accessName = accessName.split("(")[0];
    	}
    	
    	InternetAddress to = new InternetAddress();
    	to.setPersonal(accessName, "UTF-8");
    	to.setAddress(emailAddress);
        	
        
        ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        
        logger.debug("sendMail ended");
        
        return "OK";
	}
	
	/**
	 * 자원관리 승인 후 알림 발송 실행 함수
	 */
	@RequestMapping(value = "/ezResource/sendMailToUser.do")
	public void sendMailToUser(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, @RequestBody String xmlStr) throws Exception {
		logger.debug("sendMailToUser started");

		userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
		String resID = xmlDom.getElementsByTagName("RESID").item(0).getTextContent();
		String num = xmlDom.getElementsByTagName("NUM").item(0).getTextContent();
		String approve = xmlDom.getElementsByTagName("APPROVE").item(0).getTextContent();
		
		logger.debug("resID=" + resID + ",num=" + num + ",approve=" + approve);
		
        ResGetSendMailToUserVO resInfo =  ezResourceService.getSendMailToUser(resID, Integer.parseInt(num), userInfo.getTenantId());
		
        StringBuilder bodyContent = new StringBuilder();

        bodyContent.append("<DIV id=\"msgBody\" style=\"FONT-SIZE: 10pt; FONT-FAMILY: gulim,arial,verdana\" name=\"urn:schemas:httpmail:textdescription\">");
        
        if (approve.equals("1")) {
        	bodyContent.append(resInfo.getOwnerNm() + egovMessageSource.getMessage("ezResource.t9900009", userInfo.getLocale()));
        	bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900008", userInfo.getLocale())+" : " + resInfo.getBrd_Nm());
        } else {
        	bodyContent.append(resInfo.getOwnerNm() + egovMessageSource.getMessage("ezResource.t9900010", userInfo.getLocale()));
        	bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900007", userInfo.getLocale())+" : " + resInfo.getBrd_Nm());
        }
        
        bodyContent.append("<br>&nbsp;&nbsp;&nbsp;-&nbsp;"+egovMessageSource.getMessage("ezResource.t9900004", userInfo.getLocale())+" : " + commonUtil.getDateStringInUTC(resInfo.getStartDate(), userInfo.getOffset(), false) + "&nbsp;~&nbsp;" + commonUtil.getDateStringInUTC(resInfo.getEndDate(), userInfo.getOffset(), false));
        bodyContent.append("</DIV>");
        
        String subject = "";
        if (approve.equals("1")) {
        	subject = "["+egovMessageSource.getMessage("ezResource.t9900010", userInfo.getLocale())+" :" + resInfo.getBrd_Nm() + "] " + resInfo.getTitle();
        } else {
        	subject = "["+egovMessageSource.getMessage("ezResource.t9900011", userInfo.getLocale())+" :" + resInfo.getBrd_Nm() + "] " + resInfo.getTitle();
        }
        
    	InternetAddress from = new InternetAddress();
    	from.setPersonal(userInfo.getDisplayName(), "UTF-8");
    	from.setAddress(userInfo.getEmail());
    	
    	String emailAddress = resInfo.getMail(); 
    	String accessName = resInfo.getOwnerNm(); 
    	
    	if (accessName.indexOf("(") > -1) {
    		accessName = accessName.split("(")[0];
    	}
    	
    	InternetAddress to = new InternetAddress();
    	to.setPersonal(accessName, "UTF-8");
    	to.setAddress(emailAddress);
        	
        
        ezEmailService.sendMail(loginCookie, from, new InternetAddress[]{to}, null, null, subject, bodyContent.toString(), false);
        
        logger.debug("sendMailToUser ended");
	}
}
