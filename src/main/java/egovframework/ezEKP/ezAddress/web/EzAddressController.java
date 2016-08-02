package egovframework.ezEKP.ezAddress.web;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressInfoVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.SubTreeInfoVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovStringUtil;

/** 
 * @Description [Controller] 사용자 - 주소록 
 * @author 오픈솔루션팀 장진혁
 * @Modification Information
 *
 *    수정일        수정자         수정내용
 *    ----------    ------    -------------------
 *    2016.04.18    장진혁    신규작성
 *
 * @see
 */
@Controller
public class EzAddressController{
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;  
	
	/**
	 * 주소록 우편번호 팝업 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/address_zip_select.do")
	public String address_zip_select(Model model) throws Exception {		
		String lang = config.getProperty("config.primary");
		
		model.addAttribute("lang", lang);
		
		return "ezAddress/addressZipSelect";
	}
	
	/**
	 * 주소록 우편번호 검색 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/address_zip_iframe.do")
	public String address_zip_iframe(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {		
		String dong = request.getParameter("dong");

		if (dong != null) {
			if (!dong.equals("")) {
				List<AddressVO> list = ezAddressService.getAddressInfo(dong);
				model.addAttribute("list", list);
			}
		}		
		
		return "ezAddress/addressZipIframe";
	}
	
	/**
	 * 주소록 서브 폴더 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSubTree.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetSubTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String parentId = xmldom.getElementsByTagName("PARENTID").item(0).getTextContent();
		String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		List<SubTreeInfoVO> subTreeList = ezAddressService.getSubTreeInfo(parentId, ownerId);
		
		for (SubTreeInfoVO vo : subTreeList) {
			sb.append("<ROW>");
			sb.append("<FOLDERID>" + vo.getFolderId() + "</FOLDERID>");
			sb.append("<OWNERID>" + vo.getOwnerId() + "</OWNERID>");
			sb.append("<FOLDERTYPE>" + vo.getFolderType() + "</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + vo.getFolderName() + "</FOLDERNAME>");
			sb.append("<CHILDCOUNT>" + vo.getChildCount() + "</CHILDCOUNT>");
			sb.append("</ROW>");
		}
		
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	/**
	 * 주소록 메인화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMainList.do")
	public String addressMainList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pAdmin = "";
		String useEditor = config.getProperty("config.EDITOR");
		String useIE11Browser = "";
		String noneActiveX = "YES";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		
		String pFolderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String pOwerId = request.getParameter("ownerid") == null ? "" : request.getParameter("ownerid");
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1) {
			pAdmin = "Y";
		}
		
		String pListType = ezAddressService.getListType(userInfo.getId());
		if (pListType == null) {
			pListType = "card";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pFolderId", pFolderId);
		model.addAttribute("pFolderType", pFolderType);
		model.addAttribute("pOwerId", pOwerId);
		model.addAttribute("pAdmin", pAdmin);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pListType", pListType);
		
		return "ezAddress/addressMainList";
	}
	
	/**
	 * 주소록 리스트 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String strListPageSize = ezAddressService.getListCnt(userInfo.getId());
			
			if (strListPageSize == null) {
				strListPageSize = "20";
			}
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String pFolderID = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String pOwnerID = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String pFolderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			String pFolderName = "";
			
			String pOrderOption = "";
			String pFolderFilter = "";
			String strCurrentPage = "1";
			
			if (xmldom.getElementsByTagName("ORDERBY").item(0) != null) {
				pOrderOption = xmldom.getElementsByTagName("ORDERBY").item(0).getTextContent();
			}
			if (xmldom.getElementsByTagName("FILTER").item(0) != null) {
				pFolderFilter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			}
			if (xmldom.getElementsByTagName("PAGE").item(0) != null) {
				strCurrentPage = xmldom.getElementsByTagName("PAGE").item(0).getTextContent();
			}
			
			int pListPageSize = Integer.parseInt(strListPageSize);
			int pCurrentPage = Integer.parseInt(strCurrentPage);
			
			int start = pListPageSize * (pCurrentPage - 1);
			
			String strFolderMaxCount = ezAddressService.getAddressCount(pFolderID, pOwnerID, pFolderFilter);
			int pFolderMaxCount = 0;
			if (strFolderMaxCount != null) {
				pFolderMaxCount = Integer.parseInt(strFolderMaxCount);
			}
			
			List<AddressInfoVO> addressList = ezAddressService.getAddressList(pFolderID, pOwnerID, pOrderOption, pFolderFilter, "", pFolderMaxCount, pListPageSize, start);
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<DATA>");
			sb.append("<TOTALCNT>" + pFolderMaxCount + "</TOTALCNT>");
			sb.append("<PAGESIZE>" + pListPageSize + "</PAGESIZE>");
			sb.append("<CURPAGE>" + pCurrentPage + "</CURPAGE>");
			sb.append("<DISPLAYNAME>" + pFolderName + "</DISPLAYNAME>");
			
			for (AddressInfoVO vo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + vo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + vo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + vo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + vo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + vo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + vo.getsName() + "</SNAME>");
				sb.append("<SCOMPANY>" + vo.getsCompany() + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + vo.getsCompanyPhone() + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + vo.getsMobile() + "</SMOBILE>");
				sb.append("<SEMAIL>" + vo.getsEmail() + "</SEMAIL>");
				sb.append("<STYPE>" + vo.getsType() + "</STYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소록 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressWrite.do")
	public String addressWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String addressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String folderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String folderType = request.getParameter("foldertype") == null ? "" : request.getParameter("foldertype");
		String ownerId = request.getParameter("ownerid") == null ? "" : request.getParameter("ownerid");
		
		String changeKey = "";
		String photoUrl = "";
		String textEmail = "";
		String userNM = userInfo.getDisplayName1();
		String userNM2 = userInfo.getDisplayName2();
		String rootAddressSelection = "";
		
		if (!addressId.equals("")) {
			AddressInfoVO addressInfo = ezAddressService.getAddressInfo2(addressId);
			model.addAttribute("addressInfo", addressInfo);
			
			textEmail = addressInfo.getsEmail();
		}
		
		//2016-07-21 이효민사원 -- LiteralPhoto가 주석처리 되어있어서 구현안함.
//		if (LiteralPhoto.Text.equals("")) {
//      	LiteralPhoto.Text = "<IMG " + RM.GetString("i1") + ">";
//		}
		
		//TODO : GetRootAddressList() 구현(필요한 경우)
//		if (folderId.equals("")) {
//			GetRootAddressList();
//		}
		
		model.addAttribute("addressId", addressId);
		model.addAttribute("folderId", folderId);
		model.addAttribute("folderType", folderType);
		model.addAttribute("ownerId", ownerId);
		model.addAttribute("changeKey", changeKey);
		model.addAttribute("photoUrl", photoUrl);
		model.addAttribute("textEmail", textEmail);
		model.addAttribute("userNM", userNM);
		model.addAttribute("userNM2", userNM2);
		model.addAttribute("rootAddressSelection", rootAddressSelection);
		
		return "ezAddress/addressWrite";
	}
	
	/**
	 * 주소록 중복검사 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSearchCnt.do")
	@ResponseBody
	public String addressGetSearchCnt(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String idList = xmldom.getElementsByTagName("IDLIST").item(0).getTextContent();
		String filter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
		
		filter = " SEMAIL Like '%" + filter.trim() + "%'";
		idList = "'" + idList + "'" ;
		int totalCount = ezAddressService.getSearchCount(idList, filter);
		
		return totalCount + "";
	}
	
	/**
	 * 주소록 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSave.do")
	@ResponseBody
	public String addressSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnVaule = "OK";
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String addressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			String photoPath = xmldom.getElementsByTagName("PHOTOPATH").item(0).getTextContent();
			String sName = xmldom.getElementsByTagName("SNAME").item(0).getTextContent();
			String sCompany = xmldom.getElementsByTagName("SCOMPANY").item(0).getTextContent();
			String sDept = xmldom.getElementsByTagName("SDEPT").item(0).getTextContent();
			String sTitle = xmldom.getElementsByTagName("STITLE").item(0).getTextContent();
			String sCompanyPhone = xmldom.getElementsByTagName("SCOMPANYPHONE").item(0).getTextContent();
			String sFax = xmldom.getElementsByTagName("SFAX").item(0).getTextContent();
			String sMobile = xmldom.getElementsByTagName("SMOBILE").item(0).getTextContent();
			String sEmail = xmldom.getElementsByTagName("SEMAIL").item(0).getTextContent();
			String sHomePage = xmldom.getElementsByTagName("SHOMEPAGE").item(0).getTextContent();
			String sCompanyZip = xmldom.getElementsByTagName("SCOMPANYZIP").item(0).getTextContent();
			String sCompanyAddr = xmldom.getElementsByTagName("SCOMPANYADDR").item(0).getTextContent();
			String sHomeZip = xmldom.getElementsByTagName("SHOMEZIP").item(0).getTextContent();
			String sHomeAddr = xmldom.getElementsByTagName("SHOMEADDR").item(0).getTextContent();
			String sMemo = xmldom.getElementsByTagName("SMEMO").item(0).getTextContent();
			String sType = xmldom.getElementsByTagName("STYPE").item(0).getTextContent();
			String sUserNM = xmldom.getElementsByTagName("USERNM").item(0).getTextContent();
			String sUserNM2 = xmldom.getElementsByTagName("USERNM2").item(0).getTextContent();
			
			if (addressId.equals("")) {
				//주소록 추가
				//TODO : 첨부파일(필요시) (마지막 파라미터 : xmldom.SelectSingleNode("DATA/ATTACHLIST").OuterXml)
				ezAddressService.insertAddress(ownerId, folderId, userInfo.getId(), sUserNM, sUserNM2, photoPath, sName,
						sCompany, sDept, sTitle, sCompanyPhone, sFax, sMobile, sEmail, sHomePage, sCompanyZip,
						sCompanyAddr, sHomeZip, sHomeAddr, sMemo, sType, "");
			} else {
				//주소록 수정
				//TODO : 첨부파일(필요시) (마지막 파라미터 : xmldom.SelectSingleNode("DATA/ATTACHLIST").OuterXml)
				ezAddressService.updateAddress(addressId, userInfo.getId(), sUserNM, sUserNM2, photoPath, sName, sCompany, sDept,
						sTitle, sCompanyPhone, sFax, sMobile, sEmail, sHomePage, sCompanyZip, sCompanyAddr, sHomeZip, sHomeAddr,
						sMemo, "");
			}
		} catch (Exception e) {
			returnVaule = "ERROR";
			e.printStackTrace();
		}
		
		return returnVaule;
	}
	
	/**
	 * 주소록 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressRead.do")
	public String addressRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = config.getProperty("config.EDITOR");
		String useIE11Browser = "";
		String noneActiveX = "YES";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		String pAddressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String pFolderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		
		AddressInfoVO addressInfo = ezAddressService.getAddressInfo2(pAddressId);
		
		String pAdmin = "";
		if (addressInfo.getOwnerId().equals("TOP") && (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
			pAdmin = "Y";
		} else {
            if (!addressInfo.getOwnerId().equals(addressInfo.getCreatorId()) && (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
            	pAdmin = "Y";
            }
        }
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("addressInfo", addressInfo);
		model.addAttribute("pAdmin", pAdmin);
		model.addAttribute("pAddressId", pAddressId);
		model.addAttribute("pFolderId", pFolderId);
		model.addAttribute("pFolderType", pFolderType);
		
		return "ezAddress/addressRead";
	}
	
	/**
	 * 그룹주소록 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressWriteGroup.do")
	public String addressWriteGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String addressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String folderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String ownerId = request.getParameter("ownerid") == null ? "" : request.getParameter("ownerid");
		String folderType = request.getParameter("foldertype") == null ? "" : request.getParameter("foldertype");
		String changeKey = "";
		String userNM = userInfo.getDisplayName1();
		String userNM2 = userInfo.getDeptName2();
		String useOcs = config.getProperty("config.USE_OCS");
		
		//TODO : delete
		String domainName = config.getProperty("config.DomainName");
		model.addAttribute("domainName", domainName);
		
		model.addAttribute("addressId", addressId);
		model.addAttribute("folderId", folderId);
		model.addAttribute("ownerId", ownerId);
		model.addAttribute("folderType", folderType);
		model.addAttribute("changeKey", changeKey);
		model.addAttribute("userNM", userNM);
		model.addAttribute("userNM2", userNM2);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userInfo", userInfo);
		
		return "ezAddress/addressWriteGroup";
	}
	
	/**
	 * 그룹주소록 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGroupSave.do")
	@ResponseBody
	public String addressGroupSave(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		String returnValue = "OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
			String addressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			String sGroupName = xmldom.getElementsByTagName("SNAME").item(0).getTextContent();
			
			NodeList groupList = xmldom.getElementsByTagName("ROW");
			
			String sMemo = "";
			for (int i=0; i<groupList.getLength(); i++) {
				NodeList children = groupList.item(i).getChildNodes();
				String sDisplayName = children.item(0).getTextContent();
				String sKey = children.item(1).getTextContent();
				
				if (sMemo.equals("")) {
					sMemo += "\"" + sDisplayName + "\" <" + sKey + ">";
				} else {
					sMemo += ";\"" + sDisplayName + "\" <" + sKey + ">";
				}
			}
			
			String ownerId = folderType.equals("D") ? userInfo.getDeptID() : folderType.equals("C") ? userInfo.getCompanyID() : userInfo.getId();
			String sEmail = egovMessageSource.getMessage("ezAddress.t180", locale);
			String sType = "G";
			
			if (addressId.equals("")) {
				ezAddressService.insertAddress(ownerId, folderId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), "", sGroupName,
						"", "", "", "", "", "", sEmail, "", "",
						"", "", "", sMemo, sType, "");
			} else {
				ezAddressService.updateAddress(addressId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), "", sGroupName, 
						"", "", "", "", "", "", sEmail, "", "", 
						"", "", "", sMemo, "");
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 그룹주소록 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressReadGroup.do")
	public String addressReadGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		String pAddressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String pAdmin = "";
		String useEditor = config.getProperty("config.EDITOR");
		String useIE11Browser = "";
		String noneActiveX = "YES";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		if (pFolderType.equals("D") && (userInfo.getRollInfo().indexOf("c=1") > -1 ||
				userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
			pAdmin = "Y";
		}
        if (pFolderType.equals("C") && (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
        	pAdmin = "Y";
        }
		
        AddressInfoVO addressInfo = ezAddressService.getAddressInfo2(pAddressId);
		String address = addressInfo.getsMemo();
		StringBuilder listMember = new StringBuilder();
		
		int listMemberSize = 0;
        if (address != null && !address.trim().equals("")) {
        	String[] addrList = address.split(";");
        	listMemberSize = addrList.length;
        	
        	for (String addr : addrList) {
        		addr = EgovStringUtil.getSpclStrCnvr(addr);
        		listMember.append("<option>" + addr + "</option>");
        	}
        }
        
        model.addAttribute("pFolderType", pFolderType);
        model.addAttribute("pAddressId", pAddressId);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("addressInfo", addressInfo);
		model.addAttribute("listMember", listMember.toString());
		model.addAttribute("listMemberSize", listMemberSize);
		model.addAttribute("pAdmin", pAdmin);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		
		
		
		return "ezAddress/addressReadGroup";
	}
	
	/**
	 * 주소록 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressDelete.do")
	@ResponseBody
	public String addressDelete(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "OK";
		
		try {
	        String pType = request.getParameter("pType") == null ? "" : request.getParameter("pType");
	        
	        Document xmldom = commonUtil.convertRequestToDocument(request);
			NodeList ids = xmldom.getElementsByTagName("ID");
	        
            for (int i=0; i<ids.getLength(); i++) {
                ezAddressService.deleteAddress(ids.item(i).getTextContent());
            }
            
	    } catch (Exception e) {
	        returnValue = "ERROR";
	    }
		
		return returnValue;
	}
	
	/**
	 * 주소록 이동/복사 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMoveCopy.do")
	public String addressMoveCopy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String checkAdmin = "";
		String deptAdmin = "";
		String companyAdmin = "";
		
        if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
        	companyAdmin = "Y";
        	deptAdmin = "Y";
        } else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
        	deptAdmin = "Y";
        }
        
        StringBuilder rootAddressXML = new StringBuilder();
        
        rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t145", locale), userInfo.getId(), "P", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t146", locale), userInfo.getDeptID(), "D", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t147", locale), userInfo.getCompanyID(), "C", "0", "", "1"));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
		
		
		model.addAttribute("checkAdmin", checkAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("companyAdmin", companyAdmin);
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		
		return "ezAddress/addressMoveCopy";
	}
	
	/**
	 * 주소록 이동/복사 저장 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSaveMoveCopy.do")
	@ResponseBody
	public String addressSaveMoveCopy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue="OK";
		
		try {
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String folderId = xmldom.getElementsByTagName("NEWFOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			
			NodeList addressIdList = xmldom.getElementsByTagName("ID");
			if (cmd.equals("MOVE")) {
				
				for (int i=0; i<addressIdList.getLength(); i++) {
					String addressId = addressIdList.item(i).getTextContent();
					ezAddressService.moveAddress(addressId, folderId, ownerId);
				}
				
			} else if (cmd.equals("COPY")) {
				
				for (int i=0; i<addressIdList.getLength(); i++) {
					String addressId = addressIdList.item(i).getTextContent();
					ezAddressService.copyAddress(addressId, folderId, ownerId);
				}
				
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소록 환경설정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressConfig.do")
	public String addressConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		System.out.println(userInfo.getId());
		String pListType = ezAddressService.getListType(userInfo.getId());
		if (pListType == null) {
			pListType = "card";
		}
		
		String listCount = ezAddressService.getListCnt(userInfo.getId());
		if (listCount == null) {
			listCount = "20";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pListType", pListType);
		model.addAttribute("listCount", listCount);
		
		return "ezAddress/addressConfig";
	}
	
	/**
	 * 주소록 환경설정 저장 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSaveConfig.do")
	@ResponseBody
	public String addressSaveConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String pUserID = xmldom.getElementsByTagName("USERID").item(0).getTextContent();
			String pListCnt = xmldom.getElementsByTagName("LISTCNT").item(0).getTextContent();
			String pListType = xmldom.getElementsByTagName("LISTTYPE").item(0).getTextContent();
			
			ezAddressService.setAddressConfig(pUserID, pListCnt, pListType);
		
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	
	/**
	 * 그룹주소록 정보 호출 함수(그룹주소록 수정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetCurrentData.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetCurrentData(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "";
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String addressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			
			StringBuilder sb = new StringBuilder();
			
			AddressInfoVO addressInfo = ezAddressService.getAddressInfo2(addressId);
			
			sb.append("<NewDataSet>");
			sb.append("<SNAME>" + addressInfo.getsName() + "</SNAME>");
			sb.append("<CHANGEKEY></CHANGEKEY>");
			sb.append("<OWNERID>" + (folderType.equals("P") ? userInfo.getDeptID() : userInfo.getCompanyID()) + "</OWNERID>");
			
			String address = addressInfo.getsMemo();
			if (address != null && !address.trim().equals("")) {
				String[] addressRows = address.split(";");
				
				for (String addr : addressRows) {
					InternetAddress internetAddress = new InternetAddress(addr);
					
					sb.append("<Table>");
					sb.append("<NAME>" + internetAddress.getPersonal() + "</NAME>");
					sb.append("<EMAIL>" + internetAddress.getAddress() + "</EMAIL>");
					sb.append("<DLKEY>" + internetAddress.getAddress() + "</DLKEY>");
					sb.append("<TYPE>email</TYPE>");
					sb.append("</Table>");
					
				}
			}
			sb.append("</NewDataSet>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "<NewDataSet>" + e.getMessage() + "</NewDataSet>";
		}
		return returnValue;
	}
	
	/**
	 * 그룹주소록 정보 호출 함수 (그룹메일 쓰기)
	 */
	@RequestMapping(value = "/ezAddress/addressGetGroupEmail.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetGroupEmail(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue="";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String pAddressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			
			AddressInfoVO addressInfo = ezAddressService.getAddressInfo2(pAddressId);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			String address = addressInfo.getsMemo();
			if (address != null && !address.trim().equals("")) {
				String[] addressRows = address.split(";");
				
				for (String addr : addressRows) {
					InternetAddress internetAddress = new InternetAddress(addr);
					
					sb.append("<ROW>");
					sb.append("<NAME><![CDATA[" + internetAddress.getPersonal() + "]]></NAME>");
					sb.append("<EMAIL><![CDATA[" + internetAddress.getAddress() + "]]></EMAIL>");
					sb.append("</ROW>");
					
				}
			}
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	
	/**
	 * 그룹주소록 정보 호출 함수 (메일 쓰기)
	 */
	@RequestMapping(value = "/ezAddress/addressGetGroupEmailList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetGroupEmailList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue="";

		try {
			String pAddressId = request.getParameter("id");

			AddressInfoVO addressInfo = ezAddressService.getAddressInfo2(pAddressId);

			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");

			String address = addressInfo.getsMemo();
			if (address != null && !address.trim().equals("")) {
				String[] addressRows = address.split(";");

				for (String addr : addressRows) {
					sb.append("<![CDATA[" + addr + ";]]>");
				}
			}
			sb.append("</DATA>");

			returnValue = sb.toString();

		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}

		return returnValue;
	}
	
	/**
	 * 주소함관리 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressFolderManage.do")
	public String addressFolderManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String companyAdmin = "";
		String deptAdmin = "";
		String noneActiveX = "YES";
		String show = "N";
		String title = egovMessageSource.getMessage("ezAddress.t144", locale);
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			companyAdmin = "Y";
			deptAdmin = "Y";
		}
		else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
			deptAdmin = "Y";
		}

		if (request.getParameter("mode") != null) {
			show = "Y";
			title = egovMessageSource.getMessage("ezAddress.t319", locale);
		}
		
		StringBuilder rootAddressXML = new StringBuilder();
        
        rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\"></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t145", locale), userInfo.getId(), "P", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t146", locale), userInfo.getDeptID(), "D", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t147", locale), userInfo.getCompanyID(), "C", "0", "", "1"));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
		
		model.addAttribute("companyAdmin", companyAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("show", show);
		model.addAttribute("title", title);
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		
		return "ezAddress/addressFolderManage";
	}
	
	/**
	 * 주소함 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressInputNameDlg.do")
	public String addressInputNameDlg(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		return "ezAddress/addressInputNameDlg";
	}
	
	/**
	 * 주소함 추가 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressAddFolder.do")
	@ResponseBody
	public String addressAddFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String parentId = xmldom.getElementsByTagName("PARENTID").item(0).getTextContent();
			String folderName = xmldom.getElementsByTagName("NAME").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			
			String folderName2 = folderName;
			int maxSeq = ezAddressService.getMaxSeq(parentId, ownerId) + 1;
			
			returnValue = ezAddressService.insertFolder(parentId, ownerId, folderType, folderName, folderName2, maxSeq);
			
			if (returnValue == null || returnValue.trim().equals("")) {
				returnValue = "ERROR";
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소함 수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressModFolder.do")
	@ResponseBody
	public String addressModFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String folderName = xmldom.getElementsByTagName("FOLDERNAME").item(0).getTextContent();
			
			String folderName2 = folderName;
			
			ezAddressService.updateFolder(folderId, folderName, folderName2);
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소함 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressDelFolder.do")
	@ResponseBody
	public String addressDelFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			
			ezAddressService.deleteFolder(folderId);
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소함 이동/복사 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMoveCopyFolder.do")
	@ResponseBody
	public String addressMoveCopyFolder(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String newParentId = xmldom.getElementsByTagName("NEWPARENTID").item(0).getTextContent();
			String newOwnerId = xmldom.getElementsByTagName("NEWOWNERID").item(0).getTextContent();
			String newFolderType = xmldom.getElementsByTagName("NEWFOLDERTYPE").item(0).getTextContent();
			
			if (cmd.equals("MOVE")) {
				ezAddressService.moveFolder(folderId, newParentId, newOwnerId, newFolderType);
			} else if (cmd.equals("COPY")) {
				ezAddressService.copyFolder(folderId, newParentId, newOwnerId, newFolderType);
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소록 검색 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMainSearch.do")
	public String addressMainSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String orderBy = "SNAME:0";
		String filter = "";
		String bAdmin = "";
		String cAdmin = "";
		String useEditor = config.getProperty("config.EDITOR");
		String useIE11Browser = "";
		String noneActiveX = "YES";
		String pListType = "";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && config.getProperty("config.IE11EDITOR").equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		if (request.getParameter("orderby") != null && !request.getParameter("orderby").equals("")) {
			orderBy = request.getParameter("orderby");
		}
		
		if (request.getParameter("filter") != null) {
			filter = request.getParameter("filter");
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1) {
			bAdmin = "Y";
		}

        if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
        	cAdmin = "Y";
        }
		
        pListType = ezAddressService.getListType(userInfo.getId());
        if (pListType == null) {
			pListType = "card";
		}
        
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("filter", filter);
		model.addAttribute("bAdmin", bAdmin);
		model.addAttribute("cAdmin", cAdmin);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pListType", pListType);
		
		return "ezAddress/addressMainSearch";
	}
	
	/**
	 * 주소록 리스트 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSearchList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetSearchList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String strListPageSize = ezAddressService.getListCnt(userInfo.getId());
			if (strListPageSize == null) {
				strListPageSize = "20";
			}
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String pIdList = xmldom.getElementsByTagName("IDLIST").item(0).getTextContent().trim();
			
			String[] tempIdArr = pIdList.split(",");
			
			pIdList = "";
			for (int i=0; i<tempIdArr.length; i++) {
				if (pIdList.equals("")) {
					if (tempIdArr[i].equals("P")) {
						pIdList += "'" + userInfo.getId() + "'";
					} else if (tempIdArr[i].equals("D")) {
						pIdList += "'" + userInfo.getDeptID() + "'";
					} else if (tempIdArr[i].equals("C")) {
						pIdList += "'" + userInfo.getCompanyID() + "'";
					}
				} else {
					if (tempIdArr[i].equals("P")) {
						pIdList += ", '" + userInfo.getId() + "'";
					} else if (tempIdArr[i].equals("D")) {
						pIdList += ", '" + userInfo.getDeptID() + "'";
					} else if (tempIdArr[i].equals("C")) {
						pIdList += ", '" + userInfo.getCompanyID() + "'";
					}
				}
			}
			
			String pOrderOption = "";
			String pFolderFilter = "";
			String strCurrentPage = "1";
			
			if (xmldom.getElementsByTagName("ORDERBY").item(0) != null) {
				pOrderOption = xmldom.getElementsByTagName("ORDERBY").item(0).getTextContent().trim();
			}
			if (xmldom.getElementsByTagName("FILTER").item(0) != null) {
				pFolderFilter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent().trim();
			}
			if (xmldom.getElementsByTagName("PAGE").item(0) != null) {
				strCurrentPage = xmldom.getElementsByTagName("PAGE").item(0).getTextContent().trim();
			}
			
			pFolderFilter = pFolderFilter.split(",")[0] + " Like '%" + pFolderFilter.split(",")[1] + "%'";
			
			int pListPageSize = Integer.parseInt(strListPageSize);
			int pCurrentPage = Integer.parseInt(strCurrentPage);
			
			int start = pListPageSize * (pCurrentPage - 1);
			
			int pFolderMaxCount = ezAddressService.getSearchCount(pIdList, pFolderFilter);
			
			List<AddressInfoVO> addressList = ezAddressService.getSearchList(pIdList, pOrderOption, pFolderFilter, "", pFolderMaxCount, pListPageSize, start);
			
			for (AddressInfoVO vo : addressList) {
				System.out.println(vo);
			}
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<DATA>");
			sb.append("<TOTALCNT>" + pFolderMaxCount + "</TOTALCNT>");
			sb.append("<PAGESIZE>" + pListPageSize + "</PAGESIZE>");
			sb.append("<CURPAGE>" + pCurrentPage + "</CURPAGE>");
			sb.append("<DISPLAYNAME></DISPLAYNAME>");
			
			for (AddressInfoVO vo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + vo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + vo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + vo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + vo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + vo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + vo.getsName() + "</SNAME>");
				sb.append("<SCOMPANY>" + vo.getsCompany() + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + vo.getsCompanyPhone() + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + vo.getsMobile() + "</SMOBILE>");
				sb.append("<SEMAIL>" + vo.getsEmail() + "</SEMAIL>");
				sb.append("<STYPE>" + vo.getsType() + "</STYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * root 주소함 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetFullTree.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetFullTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			sb.append("<ROW>");
			sb.append("<FOLDERTYPE>P</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + egovMessageSource.getMessage("ezAddress.t145", locale) + "</FOLDERNAME>");
			sb.append("<FOLDERID><![CDATA[0]]></FOLDERID>");
			sb.append("<CHANGEKEY><![CDATA[]]></CHANGEKEY>");
			sb.append("<OWNERID><![CDATA[" + userInfo.getId() + "]]></OWNERID>");
			sb.append("<CHILDCOUNT><![CDATA[1]]></CHILDCOUNT>");
			sb.append("<PARENTFOLDERID><![CDATA[]]></PARENTFOLDERID>");
			sb.append("</ROW>");
			
			sb.append("<ROW>");
			sb.append("<FOLDERTYPE>D</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + egovMessageSource.getMessage("ezAddress.t146", locale) + "</FOLDERNAME>");
			sb.append("<FOLDERID><![CDATA[0]]></FOLDERID>");
			sb.append("<CHANGEKEY><![CDATA[]]></CHANGEKEY>");
			sb.append("<OWNERID><![CDATA[" + userInfo.getDeptID() + "]]></OWNERID>");
			sb.append("<CHILDCOUNT><![CDATA[1]]></CHILDCOUNT>");
			sb.append("<PARENTFOLDERID><![CDATA[]]></PARENTFOLDERID>");
			sb.append("</ROW>");
			
			sb.append("<ROW>");
			sb.append("<FOLDERTYPE>C</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + egovMessageSource.getMessage("ezAddress.t147", locale) + "</FOLDERNAME>");
			sb.append("<FOLDERID><![CDATA[0]]></FOLDERID>");
			sb.append("<CHANGEKEY><![CDATA[]]></CHANGEKEY>");
			sb.append("<OWNERID><![CDATA[" + userInfo.getCompanyID() + "]]></OWNERID>");
			sb.append("<CHILDCOUNT><![CDATA[1]]></CHILDCOUNT>");
			sb.append("<PARENTFOLDERID><![CDATA[]]></PARENTFOLDERID>");
			sb.append("</ROW>");
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "<DATA>" + e.getMessage() + "</DATA>";
			e.printStackTrace();
		}
		
		return returnValue;
		
	}
	
	/**
	 * 주소록 정보 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetListMailCall.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetListMailCall(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		String returnValue = "";
		
		try {
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String field = xmldom.getElementsByTagName("FIELD").item(0).getTextContent();
			int pageSize = Integer.parseInt(xmldom.getElementsByTagName("PAGESIZE").item(0).getTextContent());
			String filter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			int currentPage = Integer.parseInt(xmldom.getElementsByTagName("PAGE").item(0).getTextContent());
			String searchGubun = xmldom.getElementsByTagName("SEARCHGUBUN").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			
			String orderBy = "SNAME:0";
			
			List<AddressInfoVO> addressList = null;
			int totalCount = 0;
			
			if (searchGubun.equals("Y")) {
				
			} else {
				filter = "";
				field = "AddressID, CreatorID, ModifierID, HasAttach, HasComment, SNAME, SCOMPANY, SCOMPANYPHONE, SMOBILE, SEMAIL, STYPE,'" + folderType + "' AS FOLDERTYPE";
				String strTotalCount = ezAddressService.getAddressCount(folderId, ownerId, filter);
				if (strTotalCount != null && !strTotalCount.equals("")) {
					totalCount = Integer.parseInt(strTotalCount);
				}
				
				addressList = ezAddressService.getAddressList(folderId, ownerId, orderBy, filter, field, totalCount, pageSize, (currentPage - 1) * pageSize);
			}
			
			int pageCount = ((totalCount + pageSize - 1) / pageSize);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<RTNDATA>");
			sb.append("<TOTALCN>" + totalCount + "</TOTALCN>");
			sb.append("<CURRENTPAGE>" + currentPage + "</CURRENTPAGE>");
			sb.append("<PAGECOUNT>" + pageCount + "</PAGECOUNT>");
			sb.append("<DATA>");
			
			for (AddressInfoVO addressInfo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + addressInfo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + addressInfo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + addressInfo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + addressInfo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + addressInfo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + addressInfo.getsName() + "</SNAME>");
				sb.append("<SCOMPANY>" + addressInfo.getsCompany() + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + addressInfo.getsCompanyPhone() + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + addressInfo.getsMobile() + "</SMOBILE>");
				sb.append("<SEMAIL>" + addressInfo.getsEmail() + "</SEMAIL>");
				sb.append("<STYPE>" + addressInfo.getsType() + "</STYPE>");
				sb.append("<FOLDERTYPE>" + folderType + "</FOLDERTYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			sb.append("</RTNDATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "<DATA>" + e.getMessage() + "</DATA>";
			e.printStackTrace();
		}
		
		return returnValue;
	}
	
	/**
	 * 주소록 구성원 보기 및 선택 화면 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressSelectGroupMailList.do")
	public String addressSelectGroupMailList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		
		String addressId = request.getParameter("id") == null ? "" : request.getParameter("id");
		
		
		AddressInfoVO addressInfo =  ezAddressService.getAddressInfo2(addressId);
		String address = addressInfo.getsMemo();
		
		List<InternetAddress> list = new ArrayList<InternetAddress>();
		if (address != null && !address.trim().equals("")) {
			String[] addressRows = address.split(";");
			
			for (String addr : addressRows) {
				list.add(new InternetAddress(addr));
			}
		}
		
		model.addAttribute("list", list);
		
		return "ezAddress/addressSelectGroupMailList";
	}
	
	/**
	 * 주소록 검색 정보 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetListMailSearchCall.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetListMailSearchCall(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String pFolderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			int pListPageSize = Integer.parseInt(xmldom.getElementsByTagName("PAGESIZE").item(0).getTextContent());
			int pCurrentPage = Integer.parseInt(xmldom.getElementsByTagName("PAGE").item(0).getTextContent());
			String pFolderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			String pSearchText = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			String pSearCase = xmldom.getElementsByTagName("CASE").item(0).getTextContent();
			
			int start = (pListPageSize * (pCurrentPage - 1));
			
			String pOwnerId = userInfo.getCompanyID();
			if (pFolderType.equals("P")) {
				pOwnerId = userInfo.getId();
			} else if (pFolderType.equals("D")) {
				pOwnerId = userInfo.getDeptID();
			}
			
			String field = "AddressID, CreatorID, ModifierID, HasAttach, HasComment, SNAME, SCOMPANY, SCOMPANYPHONE, SMOBILE, SEMAIL, STYPE";
			
			String pFilter = "";
			switch (pSearCase) {
                case "SNAME":
                    pFilter = " SNAME Like '%" + pSearchText.trim() + "%'";
                    break;

                case "SCOMPANY":
                    pFilter = " SCOMPANY Like '%" + pSearchText.trim() + "%'";
                    break;

                case "SEMAIL":
                    pFilter = " SEMAIL Like '%" + pSearchText.trim() + "%'";
                    break;

                default:
                    pFilter = " SNAME Like '%" + pSearchText.trim() + "%'";
                    break;
            }
			
			String totalCount = ezAddressService.getAddressCount(pFolderId, pOwnerId, pFilter);
			List<AddressInfoVO> addressList = ezAddressService.getAddressList(pFolderId, pOwnerId, "", pFilter, field, Integer.parseInt(totalCount), pListPageSize, start);
			
			int pageCount = ((Integer.parseInt(totalCount) + pListPageSize - 1) / pListPageSize);
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<RTNDATA>");
			sb.append("<TOTALCN>" + totalCount + "</TOTALCN>");
			sb.append("<CURRENTPAGE>" + pCurrentPage + "</CURRENTPAGE>");
			sb.append("<PAGECOUNT>" + pageCount + "</PAGECOUNT>");
			sb.append("<DATA>");
			
			for (AddressInfoVO addressInfo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + addressInfo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + addressInfo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + addressInfo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + addressInfo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + addressInfo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + addressInfo.getsName() + "</SNAME>");
				sb.append("<SCOMPANY>" + addressInfo.getsCompany() + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + addressInfo.getsCompanyPhone() + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + addressInfo.getsMobile() + "</SMOBILE>");
				sb.append("<SEMAIL>" + addressInfo.getsEmail() + "</SEMAIL>");
				sb.append("<STYPE>" + addressInfo.getsType() + "</STYPE>");
				sb.append("<FOLDERTYPE>" + pFolderType + "</FOLDERTYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			sb.append("</RTNDATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		return returnValue;
	}
}