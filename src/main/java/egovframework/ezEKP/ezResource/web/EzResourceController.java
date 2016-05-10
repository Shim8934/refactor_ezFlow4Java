package egovframework.ezEKP.ezResource.web;

import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResBrdListVO;
import egovframework.ezEKP.ezResource.vo.ResBrdVO;
import egovframework.ezEKP.ezResource.vo.ResGetItemListVO;
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
		
		String ret = ezResourceService.getSubClsTree(xmlReq, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId());
		Document xmlRet = commonUtil.convertStringToDocument(ret);
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
		NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
		NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
		NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
		NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA8", xmlRet, XPathConstants.NODESET);
		NodeList nodes6 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA9", xmlRet, XPathConstants.NODESET);
		NodeList nodes7 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA10", xmlRet, XPathConstants.NODESET);
		
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
					if(nodes2.getLength() > 0) {
						NodeList nodes3 = (NodeList) xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);  
						nodes3.item(i).removeChild((Node)nodes2.item(0));
					}
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
		//int page = 0;
		
		try {
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
				//page = Integer.parseInt(req.getParameter("page"));
			}
			
			Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
		
			if (cmd.equals("get")) {
				String startDate = xmlDom.getElementsByTagName("STARTDATETIME").item(0).getTextContent();
				String endDate = xmlDom.getElementsByTagName("ENDDATETIME").item(0).getTextContent();

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
						String startDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(startDate.substring(0,10), -1, ""), "yyyyMMdd", "yyyy-MM-dd","");
						String endDate1 = EgovDateUtil.convertDate(EgovDateUtil.addDay(endDate.substring(0,10), 1, ""), "yyyyMMdd", "yyyy-MM-dd","");
						
						xmlDom.getElementsByTagName("STARTDATETIME").item(0).setTextContent(startDate1);
						xmlDom.getElementsByTagName("ENDDATETIME").item(0).setTextContent(endDate1);
					}
				}
				reVal = ezResourceService.getScheduleXML(xmlStr, resID, userInfo.getCompanyID(), groupID, gubun, type, writerName, writerDept);

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
			
				if (viewType.equals("list")) {
					String ownerNm = "owner_nm";
					String deptName = "dept_name";
					if (!userInfo.getLang().equals("1")) {
						ownerNm = "owner_nm2";
						deptName = "dept_name2";
					}
					if (!approveFlag.trim().equals("")) {
						// orderXML
					}
					
					int listCnt = xmlDom2.getElementsByTagName("appointment").getLength();
					
				}
			}
		} catch (Exception e) {
			 e.printStackTrace();
		}
			return reVal.toString();
		}
	
	
	/**
	 * 자원관리 리스트2 화면 호출 함수
	 */
	@RequestMapping(value = "/ezResource/viewResList2.do")
	public String viewResList2(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
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
		
		String adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId()); 
		brdNm = brdNm.replace("chr(38)", "&");
		String childBrd = ezResourceService.getItemList(loginCookie,brdID);
		
		List<ResGetItemListVO> list = ezResourceService.getBrdMainList(brdID, userInfo.getCompanyID(), userInfo.getLang());
		brdCount = list.size();
		
		for (int i=0; i<brdCount; i++) {
			childBrd += list.get(i).getBrdID() + "/" + list.get(i).getBrdNm() + "/" + list.get(i).getApproveFlag() + ",";
		}
		
		model.addAttribute("childBrd", childBrd);
		model.addAttribute("brdID", brdID);
		model.addAttribute("accessCode", accessCode);
		model.addAttribute("companyID", userInfo.getCompanyID());
		model.addAttribute("userID", userInfo.getId());
		model.addAttribute("deptID", userInfo.getDeptID());
		model.addAttribute("adminFg", adminFg);
		model.addAttribute("brdCount", brdCount);
		model.addAttribute("useEditor", useEditor);
		
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
		adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId());
		brdNm = brdNm.replace(String.valueOf(38), "&");
		
		if (curPage.equals("") || Integer.parseInt(curPage.trim()) < 1) {
			curPage = "1";
		} else {
			curPage = curPage;
		}
		
		totalCnt = ezResourceService.getBrdCnt(Integer.parseInt(brdID), userInfo.getCompanyID());

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
		if (userInfo.getLang().equals("1")) {
			brdNmStr = "Brd_NM";
			ownerNm = "OwnerNm";
			ownDeptNm = "OwnDeptNm";
			ownerPosition = "OwnerPosition";
		} else {
			brdNmStr = "Brd_NM" + userInfo.getLang();
			ownDeptNm = "OwnDeptNm" + userInfo.getLang();
			ownerNm = "OwnerNm" + userInfo.getLang();
			ownerPosition = "OwnerPosition" + userInfo.getLang();
		}
		
		List<ResBrdListVO> resBrdList =  ezResourceService.getBrdList(topCount, Integer.parseInt(brdID), userInfo.getCompanyID(), ownDeptNm, ownerNm, ownerPosition, brdNmStr);
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
		
		try {
			if (!req.getParameter("brdID").equals("")) {
				brdID = req.getParameter("brdID");
			}
			ResBrdVO resBrd = ezResourceService.getBrd(Integer.parseInt(brdID), userInfo.getCompanyID());
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
			
		} catch (Exception e) {
			e.printStackTrace();
		}
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
		model.addAttribute("makeDate", strMakeDate.subSequence(0, 10));
		model.addAttribute("approveFlag", strApproveFlag);
		
		return "/ezResource/viewClsItem";
	}
}
