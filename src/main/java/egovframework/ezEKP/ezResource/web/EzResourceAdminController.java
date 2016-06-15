package egovframework.ezEKP.ezResource.web;

import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.xml.parsers.DocumentBuilderFactory;
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
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezResource.vo.ResGetSubClsListVO;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

/** 
 * @Description [Controller] 자원관리 관리자
 * @author 오픈솔루션팀 지정석
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.06.10    지정석    신규작성
 *
 * @see
 */

@Controller
public class EzResourceAdminController extends EgovFileMngUtil {
	@Autowired
	private CommonUtil commonUtil;

	@Autowired
	private Properties config;
	
	@Resource(name="EzResourceService")
	private EzResourceService ezResourceService;
	
	@Resource(name="EzResourceAdminService")
	private EzResourceAdminService ezResourceAdminService;
	
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
	
	/**
	 * 자원관리 메인화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/resourceMain.do")
	public String resourceMain(Model model) throws Exception {
		String crossPage = "/admin/ezResource/gwBoardListManagelistLeft.do";
		model.addAttribute("crossPage", crossPage);
		return "admin/ezResource/resMain";
	}
	
	/**
	 * 자원관리 좌측화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListManagelistLeft.do")
	public String gwBoardListManagelistLeft(LoginVO userInfo, @CookieValue("loginCookie") String loginCookie, HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String selectNo = "";
		String adminYN = "";
		
		if (req.getParameter("flag") != null) {
			selectNo = req.getParameter("selectNo");
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			adminYN = "YES";
		}
		
		model.addAttribute("adminYN", adminYN);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("selectNo", selectNo);
		return "admin/ezResource/resGwBoardListManageListLeft";
	}
	
	/**
	 * 자원관리 센터화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListManagelistCenter.do")
	public String gwBoardListManagelistCenter(Model model) throws Exception {
		
		return "admin/ezResource/resGwBoardListManageListCenter";
	}
	
	/**
	 * 자원관리 관리자 정보 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callManagerDepthNode.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callManagerDepthNode(@RequestBody String xmlStr,HttpServletRequest req,Model model, LoginVO userInfo, @CookieValue("loginCookie") String loginCookie) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String selectFlag = "";
		StringBuilder strXML = new StringBuilder();
		Document xmlRet = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
		try {
			if (req.getParameter("flag") != null) {
				selectFlag = req.getParameter("flag");
			}
			
			String ret = ezResourceService.getSubClsTree(xmlStr, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId());
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
				
				boolean returnValue = ezResourceAdminService.addClsData(strXML.toString());
				
				ret = ezResourceService.getSubClsTree(xmlStr, userInfo.getLang(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId());
				
				xmlRet = commonUtil.convertStringToDocument(ret);
				
			}
			
			XPath xpath = XPathFactory.newInstance().newXPath();
			NodeList nodes = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
			NodeList nodes1 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE", xmlRet, XPathConstants.NODESET);
			NodeList nodes2 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
			NodeList nodes3 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/DATA12", xmlRet, XPathConstants.NODESET);
			NodeList nodes4 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/ISLEAF", xmlRet, XPathConstants.NODESET);
			NodeList nodes5 = (NodeList)xpath.evaluate("TREEVIEWDATA/NODE/SELECT", xmlRet, XPathConstants.NODESET);
				
			NodeList nodes6 = (NodeList)xpath.evaluate("NODES/NODE/SELECT", xmlRet, XPathConstants.NODESET);
			NodeList nodes7 = (NodeList)xpath.evaluate("NODES/NODE/EXPANDED", xmlRet, XPathConstants.NODESET);
			NodeList nodes8 = (NodeList)xpath.evaluate("NODES/NODE", xmlRet, XPathConstants.NODESET);
			NodeList nodes9 = (NodeList)xpath.evaluate("NODES/NODE/DATA12", xmlRet, XPathConstants.NODESET);
			NodeList nodes10 = (NodeList)xpath.evaluate("NODES/NODE/ISLEAF", xmlRet, XPathConstants.NODESET);
			NodeList nodes11 = (NodeList)xpath.evaluate("NODES/NODE/SETNODEICONBYNAME", xmlRet, XPathConstants.NODESET);
				
			if (nodes.getLength() != 0) {
				for (int i=0; i<nodes.getLength(); i++) {
					nodes1.item(i).removeChild((Node) nodes2.item(i));
					
					if (nodes3.item(i).getTextContent().equals("0")) {
						nodes4.item(i).setTextContent("TRUE");
					}
					
					if(nodes5.item(0).getTextContent().equals("")) {
						nodes5.item(0).setTextContent("<![CDATA[]]>");
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
					
					if(nodes6.item(0).getTextContent().equals("")) {
						nodes6.item(0).setTextContent("<![CDATA[]]>");
					}
				}
			}
		} catch (Exception e) {
		}
		return commonUtil.convertDocumentToString(xmlRet);
	}
	
	/**
	 * 자원관리 일반설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListRegComBoard.do")
	public String gwBoardListRegComBoard(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String companyID = "";
		ResGetSubClsListVO getBrdInfo = new ResGetSubClsListVO();
		String langPrimary = "";
		String langSecondary = "";
		
		try {
			langPrimary = config.getProperty("config.lang_Primary1");
			langSecondary = config.getProperty("config.lang_Secondary1");
				
			if (req.getParameter("brdID") != null) {
				brdID = req.getParameter("brdID");
			}
			if (req.getParameter("selCompanyID") != null) {
				companyID = req.getParameter("selCompanyID");
			}
				
			getBrdInfo = ezResourceAdminService.getBrdInfo(Integer.parseInt(brdID), companyID);
				
		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("getBrdInfo", getBrdInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("selCompanyID", companyID);
		model.addAttribute("adminFg", "YES");
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		return "admin/ezResource/resGwBoardListRegComBoard";
	}
	
	/**
	 * 자원관리 일반설정 저장 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdMod.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdMod(@RequestBody String xmlStr) throws Exception {
		try {
			boolean returnValue = ezResourceAdminService.modifyClsData(xmlStr);
			return String.valueOf(returnValue);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 자원관리 하위분류등록 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardListRegSubBoard.do")
	public String gwBoardListRegSubBoard(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String brdID = "";
		String brdNm = "";
		String brdLevel = "";
		String brdStep = "";
		String brdGroup = "";
		String selCompanyID = "";
		String langPrimary = "";
		String langSecondary = "";
		
		try {
			langPrimary = config.getProperty("config.lang_Primary1");
			langSecondary = config.getProperty("config.lang_Secondary1");
				
			if (req.getParameter("brdID") != null) {
				brdID = req.getParameter("brdID");
			}
			if (req.getParameter("brdNm") != null) {
				brdNm = req.getParameter("brdNm");
			}
			if (req.getParameter("brdLevel") != null) {
				brdLevel = req.getParameter("brdLevel");
			}
			if (req.getParameter("brdStep") != null) {
				brdStep = req.getParameter("brdStep");
			}
			if (req.getParameter("brdGroup") != null) {
				brdGroup = req.getParameter("brdGroup");
			}
			if (req.getParameter("selCompanyID") != null) {
				selCompanyID = req.getParameter("selCompanyID");
			}
		} catch (Exception e) {
			
		}

		model.addAttribute("userInfo", userInfo);
		model.addAttribute("brdID", brdID);
		model.addAttribute("upNm", brdNm);
		model.addAttribute("upLevel", brdLevel);
		model.addAttribute("upStep", brdStep);
		model.addAttribute("brdGroup", brdGroup);
		model.addAttribute("selCompanyID", selCompanyID);
		model.addAttribute("adminFg", "YES");
		model.addAttribute("langPrimary", langPrimary);
		model.addAttribute("langSecondary", langSecondary);
		return "admin/ezResource/resGwBoardListRegSubBoard";
	}
	
	/**
	 * 자원관리 하위분류 등록 실행 함수
	 */
	@RequestMapping(value = "/admin/ezResource/callBrdNew.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String callBrdNew(@RequestBody String xmlStr) throws Exception {
		try {
			boolean returnValue = ezResourceAdminService.addClsData(xmlStr);
			return String.valueOf(returnValue);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	/**
	 * 자원관리 권한설정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostRegBoardRightMain.do")
	public String gwBoardPostRegRightMain(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		return "admin/ezResource/resGwBoardPostRegBoardRightMain";
	}
	
	/**
	 * 자원관리 권한설정 - 사용자추가 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/popup/gwBoardPostRegBoardRight.do")
	public String gwBoardPostRegRight(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		String useOCS = config.getProperty("config.USE_OCS");
		model.addAttribute("useOCS", useOCS);
		return "admin/ezResource/popup/resGwBoardPostRegBoardRight";
	}
	
	/**
	 * 자원관리 분류순서조정 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostRegBoardOrder.do")
	public String gwBoardPostRegBoardOrder(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		
		return "admin/ezResource/resGwBoardPostRegBoardOrder";
	}
	
	/**
	 * 자원관리 분류이동 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostBoardMove.do")
	public String gwBoardPostBoardMove(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		
		return "admin/ezResource/resGwBoardPostBoardMove";
	}
	
	/**
	 * 자원관리 분류삭제 화면 호출 함수
	 */
	@RequestMapping(value = "/admin/ezResource/gwBoardPostBoardDel.do")
	public String gwBoardPostBoardDel(LoginVO userInfo,@CookieValue("loginCookie") String loginCookie,HttpServletRequest req,Model model) throws Exception {
		userInfo = commonUtil.userInfo(loginCookie);
		
		
		return "admin/ezResource/resGwBoardPostBoardDel";
	}
}
