package egovframework.ezEKP.ezAddress.web;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;
import egovframework.ezEKP.ezAddress.vo.AddressOldZipCodeVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.AddressZipCodeVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
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
	
	private static final Logger logger = LoggerFactory.getLogger(EzAddressController.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private EzAddressService ezAddressService;
	
	@Resource(name="egovMessageSource")
	private EgovMessageSource egovMessageSource;  
	
	@Resource(name = "EzCommonService")
    private EzCommonService ezCommonService;
	
	/**
	 * 도로명 주소 팝업창 호출 함수 (Open API)
	 */
	@RequestMapping(value = "/ezAddress/addressZipCodePopUp.do")
	public String addressZipCodePopup(Model model) throws Exception {
		logger.debug("addressZipCodePopup(Open API) started.");
		
		String confirmKey = config.getProperty("config.ConfirmKey");
		
		model.addAttribute("confirmKey", confirmKey);
		
		logger.debug("addressZipCodePopup(Open API) ended.");
		
		return "ezAddress/addressZipCodePopUp";
	}
	
	/**
	 * 주소록 우편번호 팝업 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/address_zip_select.do")
	public String address_zip_select(Model model) throws Exception {
		List<String> sidoList = ezAddressService.getZipCodeSido();
		
		StringBuilder sb = new StringBuilder();
		for (String str : sidoList) {
			sb.append("<option value='" + str + "'>" + str + "</option>");
		}
		
		model.addAttribute("sido", sb.toString());
		
		return "ezAddress/addressZipSelect";
	}
	
	/**
	 * 도로명 주소 검색 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressZipCodeList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressZipCodeList(HttpServletRequest request) throws Exception {
		Document xmldom = commonUtil.convertRequestToDocument(request);
		String sido = xmldom.getElementsByTagName("SIDO").item(0).getTextContent();
		String keyword = xmldom.getElementsByTagName("KEYWORD").item(0).getTextContent();
		String page = xmldom.getElementsByTagName("PAGE").item(0).getTextContent();
		
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		List<AddressZipCodeVO> ZipCodeList = ezAddressService.getAddressZipCodeList(sido, keyword, Integer.parseInt(page));
		int totalCount = ezAddressService.getAddressZipCodeCount(sido, keyword);
		
		for (AddressZipCodeVO vo : ZipCodeList) {
			sb.append("<ROW>");
			sb.append("<ZIPCODE>" + vo.getZipCode() + "</ZIPCODE>");
			sb.append("<DORO>" + vo.getDoro() + "</DORO>");
			sb.append("<JIBUN>" + vo.getJibun() + "</JIBUN>");
			sb.append("<ROWNUM>" + vo.getRnum() + "</ROWNUM>");
			sb.append("</ROW>");
		}
		
		sb.append("<TOTALCOUNT>" + totalCount + "</TOTALCOUNT>");
		
		sb.append("</DATA>");
		
		return sb.toString();
	}
	
	/**
	 * 주소록 우편번호 검색 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/address_zip_iframe.do")
	public String address_zip_iframe(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {		
		String dong = request.getParameter("dong");

		if (dong != null) {
			if (!dong.equals("")) {
				List<AddressOldZipCodeVO> list = ezAddressService.getZipCodeInfo(dong);
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
	public String addressGetSubTree(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetSubTree started.");
		logger.debug("bodyData=" + bodyData);
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String parentId = xmldom.getElementsByTagName("PARENTID").item(0).getTextContent();
		String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
		StringBuilder sb = new StringBuilder();
		sb.append("<DATA>");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		List<AddressFolderVO> subTreeList = ezAddressService.getSubTreeInfo(userInfo.getTenantId(), parentId, ownerId);
		
		for (AddressFolderVO vo : subTreeList) {
			sb.append("<ROW>");
			sb.append("<FOLDERID>" + vo.getFolderId() + "</FOLDERID>");
			sb.append("<OWNERID>" + vo.getOwnerId() + "</OWNERID>");
			sb.append("<FOLDERTYPE>" + vo.getFolderType() + "</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + commonUtil.cleanValue(vo.getFolderName()) + "</FOLDERNAME>");
			sb.append("<CHILDCOUNT>" + vo.getChildCount() + "</CHILDCOUNT>");
			sb.append("</ROW>");
		}
		
		sb.append("</DATA>");
		
		logger.debug("addressGetSubTree ended.");
		
		return sb.toString();
	}
	
	/**
	 * 주소록 메인화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMainList.do")
	public String addressMainList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressMainList started.");
		logger.debug("folderid=" + request.getParameter("folderid") + ",type=" + request.getParameter("type"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String compAdmin = "";
		String deptAdmin = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useIE11Browser = "";
		String noneActiveX = "YES";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		String pFolderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
        	compAdmin = "Y";
        	deptAdmin = "Y";
        } else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
        	deptAdmin = "Y";
        }
		
		String pOwerId = "";
		if (pFolderType.equals("D")) {
			pOwerId = userInfo.getDeptID();
		} else if (pFolderType.equals("C")) {
			pOwerId = userInfo.getCompanyID();
		} else {
			pOwerId = userInfo.getId();
		}
		
		String pListType = ezAddressService.getListType(userInfo.getTenantId(), userInfo.getId());
		if (pListType == null) {
			pListType = "card";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pFolderId", pFolderId);
		model.addAttribute("pFolderType", pFolderType);
		model.addAttribute("pOwerId", pOwerId);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pListType", pListType);
		
		logger.debug("addressMainList ended.");
		logger.debug("userInfo=" + userInfo + ",pFolderId=" + pFolderId + ",pFolderType=" + pFolderType + ",pOwerId=" + pOwerId
				 + ",compAdmin=" + compAdmin + ",deptAdmin=" + deptAdmin + ",useEditor=" + useEditor + ",useIE11Browser=" + useIE11Browser
				 + ",noneActiveX=" + noneActiveX + ",pListType=" + pListType);
		
		return "ezAddress/addressMainList";
	}
	
	/**
	 * 주소록 리스트 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressList started.");
		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String strListPageSize = ezAddressService.getListCnt(userInfo.getTenantId(), userInfo.getId());
			
			if (strListPageSize == null) {
				strListPageSize = "20";
			}
			
			Document xmldom = commonUtil.convertRequestToDocument(request);
			String pFolderID = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String pOwnerID = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String pFolderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			String pFolderName = ""; //TODO: folderName setting 안해도 되나?
			
			String pOrderOption = "";
			String pFilter = "";
			String strCurrentPage = "1";
			
			if (xmldom.getElementsByTagName("ORDERBY").item(0) != null) {
				pOrderOption = xmldom.getElementsByTagName("ORDERBY").item(0).getTextContent();
			}
			if (xmldom.getElementsByTagName("FILTER").item(0) != null) {
				pFilter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			}
			if (xmldom.getElementsByTagName("PAGE").item(0) != null) {
				strCurrentPage = xmldom.getElementsByTagName("PAGE").item(0).getTextContent();
			}
			
			int pListPageSize = Integer.parseInt(strListPageSize);
			int pCurrentPage = Integer.parseInt(strCurrentPage);
			
			int start = pListPageSize * (pCurrentPage - 1);
			
			int pFolderMaxCount = ezAddressService.getAddressCount(userInfo.getTenantId(), pFolderID, pOwnerID, pFilter);
			
			List<AddressVO> addressList = ezAddressService.getAddressList(userInfo.getTenantId(), pFolderID, pOwnerID, pOrderOption, pFilter, pListPageSize, start);
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<DATA>");
			sb.append("<TOTALCNT>" + pFolderMaxCount + "</TOTALCNT>");
			sb.append("<PAGESIZE>" + pListPageSize + "</PAGESIZE>");
			sb.append("<CURPAGE>" + pCurrentPage + "</CURPAGE>");
			sb.append("<DISPLAYNAME>" + pFolderName + "</DISPLAYNAME>");
			
			for (AddressVO vo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + vo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + vo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + vo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + vo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + vo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + commonUtil.cleanValue(vo.getsName()) + "</SNAME>");
				sb.append("<SCOMPANY>" + commonUtil.cleanValue(vo.getsCompany()) + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + commonUtil.cleanValue(vo.getsCompanyPhone()) + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + commonUtil.cleanValue(vo.getsMobile()) + "</SMOBILE>");
				sb.append("<SEMAIL>" + commonUtil.cleanValue(vo.getsEmail()) + "</SEMAIL>");
				sb.append("<STYPE>" + vo.getsType() + "</STYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressList ended.");
		
		return returnValue;
	}
	
	/**
	 * 주소록 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressWrite.do")
	public String addressWrite(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressWrite started.");
		logger.debug("addressid=" + request.getParameter("addressid") + ",folderid=" + request.getParameter("folderid")
				+ ",foldertype=" + request.getParameter("foldertype") + ",ownerid=" + request.getParameter("ownerid"));
		
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
		String useAddressOpenAPI = config.getProperty("config.USE_AddressOpenAPI");
		
		// ownerId가 없으면 디비에서 구하기(주소록수정 시 ownerId가 null이기 때문에)
		if (ownerId.trim().equals("")) {
			if (folderId.equals("0")) {
				if (folderType.equals("C")) {
					ownerId = userInfo.getCompanyID();
				} else if (folderType.equals("D")) {
					ownerId = userInfo.getDeptID();
				} else {
					ownerId = userInfo.getId();
				}
			}
			else {
				AddressFolderVO folderInfo = ezAddressService.getFolderInfo(folderId);
				ownerId = folderInfo.getOwnerId();
			}
		}
		
		if (!addressId.equals("")) {
			AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), addressId);
			model.addAttribute("addressInfo", addressInfo);
			
			textEmail = addressInfo.getsEmail();
		}
		
		if (folderId == null || folderId.equals("")) {
			rootAddressSelection = "<option id='P' value='0' ownerid='" + userInfo.getId() + "'>" + egovMessageSource.getMessage("ezAddress.t145", userInfo.getLocale()) + "</option>"
					+ "<option id='D' value='0' ownerid='" + userInfo.getDeptID() +  "'>" + egovMessageSource.getMessage("ezAddress.t146", userInfo.getLocale()) + "</option>"
					+ "<option id='C' value='0' ownerid='" + userInfo.getCompanyID() + "'>" + egovMessageSource.getMessage("ezAddress.t147", userInfo.getLocale()) + "</option>";
		}
		
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
		model.addAttribute("useAddressOpenAPI", useAddressOpenAPI);
		model.addAttribute("userLang", userInfo.getLang());
		
		logger.debug("addressWrite ended.");
		logger.debug("addressId=" + addressId + ",folderId=" + folderId + ",folderType=" + folderType + ",ownerId=" + ownerId
				 + ",changeKey=" + changeKey + ",photoUrl=" + photoUrl + ",textEmail=" + textEmail + ",userNM=" + userNM
				 + ",userNM2=" + userNM2 + ",rootAddressSelection=" + rootAddressSelection + ",useAddressOpenAPI=" + useAddressOpenAPI);
		
		return "ezAddress/addressWrite";
	}
	
	/**
	 * 주소록 중복검사 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSearchCnt.do")
	@ResponseBody
	public String addressGetSearchCnt(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetSearchCnt started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "";
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData);
		String ownerId = xmldom.getElementsByTagName("IDLIST").item(0).getTextContent();
		String sEmail = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		boolean isDuplicate = ezAddressService.checkDuplicateAddress(userInfo.getTenantId(), ownerId, sEmail.trim());
		if (isDuplicate) {
			returnData = "1";
		} else {
			returnData = "0";
		}
		
		logger.debug("addressGetSearchCnt ended.");
		logger.debug("returnData=" + returnData);
		
		return returnData;
	}
	
	/**
	 * 주소록 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSave.do")
	@ResponseBody
	public String addressSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressSave started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnVaule = "OK";
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
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
			
			// ownerId가 없으면 디비에서 구하기.
			if (ownerId.trim().equals("")) {
				if (folderId.equals("0")) {
					if (folderType.equals("C")) {
						ownerId = userInfo.getCompanyID();
					} else if (folderType.equals("D")) {
						ownerId = userInfo.getDeptID();
					} else {
						ownerId = userInfo.getId();
					}
				}
				else {
					AddressFolderVO folderInfo = ezAddressService.getFolderInfo(folderId);
					ownerId = folderInfo.getOwnerId();
				}
			}
			
			// 주소록을 추가/수정 할 권한이 있는지 체크.
			if (folderType.equals("C")) {
				if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
					return "NO_AUTHORITY";
				}
			} else if (folderType.equals("D")) {
				if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
					return "NO_AUTHORITY";
				}
			}
			
			if (addressId.equals("")) { //주소록 생성
				ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), 
						sName, sEmail, sCompany, sDept, sTitle, 
						sCompanyPhone, sFax, sMobile, sHomePage, 
						sCompanyZip, sCompanyAddr, sHomeZip, sHomeAddr, sMemo, sType);
			} else { //주소록 수정
				ezAddressService.updateAddress(userInfo.getTenantId(), addressId, userInfo.getId(),
						sName, sEmail, sCompany, sDept, sTitle, 
						sCompanyPhone, sFax, sMobile, sHomePage, 
						sCompanyZip, sCompanyAddr, sHomeZip, sHomeAddr, sMemo);
			}
		} catch (Exception e) {
			returnVaule = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressSave ended. returnVaule=" + returnVaule);
		
		return returnVaule;
	}
	
	/**
	 * 주소록 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressRead.do")
	public String addressRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressRead started.");
		logger.debug("addressid=" + request.getParameter("addressid") + ",folderid=" + request.getParameter("folderid")
			+ ",type=" + request.getParameter("type"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useIE11Browser = "";
		String noneActiveX = "YES";
		String compAdmin = "";
		String deptAdmin = "";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		String pAddressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String pFolderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		
		AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
        	compAdmin = "Y";
        	deptAdmin = "Y";
        } else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
        	deptAdmin = "Y";
        }
		
		String dateInUserTimeZone = commonUtil.getDateStringInUTC(addressInfo.getCreateDate(), userInfo.getOffset(), false);
		dateInUserTimeZone = dateInUserTimeZone.substring(0, dateInUserTimeZone.indexOf(" "));
		addressInfo.setCreateDate(dateInUserTimeZone);
		
		dateInUserTimeZone = commonUtil.getDateStringInUTC(addressInfo.getModifyDate(), userInfo.getOffset(), false);
		dateInUserTimeZone = dateInUserTimeZone.substring(0, dateInUserTimeZone.indexOf(" "));
		addressInfo.setModifyDate(dateInUserTimeZone);
				
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("addressInfo", addressInfo);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("pAddressId", pAddressId);
		model.addAttribute("pFolderId", pFolderId);
		model.addAttribute("pFolderType", pFolderType);
		
		logger.debug("addressRead ended.");
		logger.debug("useEditor=" + useEditor + ",useIE11Browser=" + useIE11Browser + ",noneActiveX=" + noneActiveX + ",userInfo=" + userInfo
				 + ",addressInfo=" + addressInfo + ",compAdmin=" + compAdmin + ",deptAdmin=" + deptAdmin + ",pAddressId=" + pAddressId
				 + ",pFolderId=" + pFolderId + ",pFolderType=" + pFolderType);
		
		return "ezAddress/addressRead";
	}
	
	/**
	 * 그룹주소록 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressWriteGroup.do")
	public String addressWriteGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressWriteGroup started.");
		logger.debug("addressid=" + request.getParameter("addressid") + ",folderid=" + request.getParameter("folderid")
				+ ",ownerid=" + request.getParameter("ownerid") + ",foldertype=" + request.getParameter("foldertype"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String addressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String folderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String ownerId = request.getParameter("ownerid") == null ? "" : request.getParameter("ownerid");
		String folderType = request.getParameter("foldertype") == null ? "" : request.getParameter("foldertype");
		String changeKey = "";
		String userNM = userInfo.getDisplayName1();
		String userNM2 = userInfo.getDisplayName2();
		String useOcs = config.getProperty("config.USE_OCS");
		
		model.addAttribute("addressId", addressId);
		model.addAttribute("folderId", folderId);
		model.addAttribute("ownerId", ownerId);
		model.addAttribute("folderType", folderType);
		model.addAttribute("changeKey", changeKey);
		model.addAttribute("userNM", userNM);
		model.addAttribute("userNM2", userNM2);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userInfo", userInfo);
		
		logger.debug("addressWriteGroup ended.");
		logger.debug("addressId=" + addressId + ",folderId=" + folderId + ",ownerId=" + ownerId + ",folderType=" + folderType
				 + ",changeKey=" + changeKey + ",userNM=" + userNM + ",userNM2=" + userNM2 + ",useOcs=" + useOcs
				 + ",userInfo=" + userInfo);
		
		return "ezAddress/addressWriteGroup";
	}
	
	/**
	 * 그룹주소록 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGroupSave.do")
	@ResponseBody
	public String addressGroupSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {		
		logger.debug("addressGroupSave started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
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
				ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), 
						sGroupName, sEmail, "", "", "", 
						"", "", "", "", 
						"", "", "", "", sMemo, sType);
			} else {
				ezAddressService.updateAddress(userInfo.getTenantId(), addressId, userInfo.getId(), 
						sGroupName, sEmail, "", "", "", 
						"", "", "", "", 
						"", "", "", "", sMemo);
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressGroupSave ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 그룹주소록 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressReadGroup.do")
	public String addressReadGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressReadGroup started.");
		logger.debug("type=" + request.getParameter("type") + ",addressid=" + request.getParameter("addressid"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		String pAddressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String compAdmin = "";
		String deptAdmin = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useIE11Browser = "";
		String noneActiveX = "YES";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
        	useIE11Browser = "CK";
        }
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
        	compAdmin = "Y";
        	deptAdmin = "Y";
        } else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
        	deptAdmin = "Y";
        }
		
		AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);
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
        
		String dateInUserTimeZone = commonUtil.getDateStringInUTC(addressInfo.getCreateDate(), userInfo.getOffset(), false);
		dateInUserTimeZone = dateInUserTimeZone.substring(0, dateInUserTimeZone.indexOf(" "));
		addressInfo.setCreateDate(dateInUserTimeZone);
		
		dateInUserTimeZone = commonUtil.getDateStringInUTC(addressInfo.getModifyDate(), userInfo.getOffset(), false);
		dateInUserTimeZone = dateInUserTimeZone.substring(0, dateInUserTimeZone.indexOf(" "));
		addressInfo.setModifyDate(dateInUserTimeZone);
                
        model.addAttribute("pFolderType", pFolderType);
        model.addAttribute("pAddressId", pAddressId);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("addressInfo", addressInfo);
		model.addAttribute("listMember", listMember.toString());
		model.addAttribute("listMemberSize", listMemberSize);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("useIE11Browser", useIE11Browser);
		model.addAttribute("noneActiveX", noneActiveX);
		
		logger.debug("addressReadGroup ended.");
		logger.debug("pFolderType=" + pFolderType + ",pAddressId=" + pAddressId + ",userInfo=" + userInfo + ",addressInfo=" + addressInfo
				 + ",listMember=" + listMember.toString() + ",listMemberSize=" + listMemberSize + ",compAdmin=" + compAdmin + ",deptAdmin=" + deptAdmin
				 + ",useEditor=" + useEditor + ",useIE11Browser=" + useIE11Browser + ",noneActiveX=" + noneActiveX);
		
		return "ezAddress/addressReadGroup";
	}
	
	/**
	 * 주소록 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressDelete.do")
	@ResponseBody
	public String addressDelete(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressDelete started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
	        Document xmldom = commonUtil.convertStringToDocument(bodyData);
			NodeList ids = xmldom.getElementsByTagName("ID");
	        
			String[] addressIds = new String[ids.getLength()];
			for (int i=0; i<ids.getLength(); i++) {
				addressIds[i] = ids.item(i).getTextContent();
			}
			
			ezAddressService.deleteAddress(addressIds);
	    } catch (Exception e) {
	        returnValue = "ERROR";
	    }
		
		logger.debug("addressDelete ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소록 이동/복사 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMoveCopy.do")
	public String addressMoveCopy(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressMoveCopy started.");
		
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
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\" nodelevel='Y'></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t145", locale), userInfo.getId(), "P", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t146", locale), userInfo.getDeptID(), "D", "0", "", "1"));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t147", locale), userInfo.getCompanyID(), "C", "0", "", "1"));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
		
		
		model.addAttribute("checkAdmin", checkAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("companyAdmin", companyAdmin);
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		
		logger.debug("addressMoveCopy ended.");
		logger.debug("checkAdmin=" + checkAdmin + ",deptAdmin=" + deptAdmin + ",companyAdmin=" + companyAdmin);
		
		return "ezAddress/addressMoveCopy";
	}
	
	/**
	 * 주소록 이동/복사 저장 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSaveMoveCopy.do")
	@ResponseBody
	public String addressSaveMoveCopy(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressSaveMoveCopy started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue="OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String folderId = xmldom.getElementsByTagName("NEWFOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			
			NodeList addressIdList = xmldom.getElementsByTagName("ID");
			String[] addressIds = new String[addressIdList.getLength()];
			
			for (int i=0; i<addressIdList.getLength(); i++) {
				addressIds[i] = addressIdList.item(i).getTextContent();
			}
			
			if (cmd.equals("MOVE")) {
				ezAddressService.moveAddress(userInfo.getTenantId(), addressIds, folderId, ownerId);
			} else if (cmd.equals("COPY")) {
				ezAddressService.copyAddress(userInfo.getTenantId(), addressIds, folderId, ownerId, userInfo.getId());
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressSaveMoveCopy ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소록 환경설정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressConfig.do")
	public String addressConfig(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressConfig started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pListType = ezAddressService.getListType(userInfo.getTenantId(), userInfo.getId());
		if (pListType == null) {
			pListType = "card";
		}
		
		String listCount = ezAddressService.getListCnt(userInfo.getTenantId(), userInfo.getId());
		if (listCount == null) {
			listCount = "20";
		}
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pListType", pListType);
		model.addAttribute("listCount", listCount);
		
		logger.debug("addressConfig ended.");
		logger.debug("userInfo=" + userInfo + ",pListType=" + pListType + ",listCount=" + listCount);
		
		return "ezAddress/addressConfig";
	}
	
	/**
	 * 주소록 환경설정 저장 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSaveConfig.do")
	@ResponseBody
	public String addressSaveConfig(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressSaveConfig started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String pUserID = xmldom.getElementsByTagName("USERID").item(0).getTextContent();
			String pListCnt = xmldom.getElementsByTagName("LISTCNT").item(0).getTextContent();
			String pListType = xmldom.getElementsByTagName("LISTTYPE").item(0).getTextContent();
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			ezAddressService.setAddressConfig(userInfo.getTenantId(), pUserID, pListCnt, pListType);
		
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressSaveConfig ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	
	/**
	 * 그룹주소록 정보 호출 함수(그룹주소록 수정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetCurrentData.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetCurrentData(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetCurrentData started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String addressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			
			StringBuilder sb = new StringBuilder();
			
			AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), addressId);
			
			sb.append("<NewDataSet>");
			sb.append("<SNAME>" + commonUtil.cleanValue(addressInfo.getsName()) + "</SNAME>");
			sb.append("<CHANGEKEY></CHANGEKEY>");
			sb.append("<OWNERID>" + (folderType.equals("P") ? userInfo.getDeptID() : userInfo.getCompanyID()) + "</OWNERID>");
			
			String address = addressInfo.getsMemo();
			if (address != null && !address.trim().equals("")) {
				String[] addressRows = address.split(";");
				
				for (String addr : addressRows) {
					InternetAddress internetAddress = new InternetAddress(addr);
					
					sb.append("<Table>");
					sb.append("<NAME>" + commonUtil.cleanValue(internetAddress.getPersonal()) + "</NAME>");
					sb.append("<EMAIL>" + commonUtil.cleanValue(internetAddress.getAddress()) + "</EMAIL>");
					sb.append("<DLKEY>" + commonUtil.cleanValue(internetAddress.getAddress()) + "</DLKEY>");
					sb.append("<TYPE>email</TYPE>");
					sb.append("</Table>");
					
				}
			}
			sb.append("</NewDataSet>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "<NewDataSet>" + e.getMessage() + "</NewDataSet>";
		}
		
		logger.debug("addressGetCurrentData ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 그룹주소록 정보 호출 함수 (그룹메일 쓰기)
	 */
	@RequestMapping(value = "/ezAddress/addressGetGroupEmail.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetGroupEmail(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetGroupEmail started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue="";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String pAddressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);
			
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
		
		logger.debug("addressGetGroupEmail ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	
	/**
	 * 그룹주소록 정보 호출 함수 (메일 쓰기)
	 */
	@RequestMapping(value = "/ezAddress/addressGetGroupEmailList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetGroupEmailList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressGetGroupEmailList started.");
		logger.debug("id=" + request.getParameter("id"));
		
		String returnValue="";

		try {
			String pAddressId = request.getParameter("id");
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);

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
		
		logger.debug("addressGetGroupEmailList ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함관리 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressFolderManage.do")
	public String addressFolderManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressFolderManage started. mode=" + request.getParameter("mode"));
		
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
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" hassub=\"%s\" nodelevel='Y'></node>";
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
		
		logger.debug("addressFolderManage ended.");
		logger.debug("companyAdmin=" + companyAdmin + ",deptAdmin=" + deptAdmin + ",noneActiveX=" + noneActiveX + ",show=" + show
				 + ",title=" + title);
		
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
	public String addressAddFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressAddFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String parentId = xmldom.getElementsByTagName("PARENTID").item(0).getTextContent();
			String folderName = xmldom.getElementsByTagName("NAME").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			ezAddressService.insertFolder(userInfo.getTenantId(), parentId, ownerId, folderType, folderName);
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressAddFolder ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함 수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressModFolder.do")
	@ResponseBody
	public String addressModFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressModFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String folderName = xmldom.getElementsByTagName("FOLDERNAME").item(0).getTextContent();
			
			ezAddressService.updateFolder(folderId, folderName);
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressModFolder ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressDelFolder.do")
	@ResponseBody
	public String addressDelFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressDelFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			
			ezAddressService.deleteFolder(folderId);
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressDelFolder ended. returnVaule=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함 이동/복사 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMoveCopyFolder.do")
	@ResponseBody
	public String addressMoveCopyFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressMoveCopyFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String newParentId = xmldom.getElementsByTagName("NEWPARENTID").item(0).getTextContent();
			String newOwnerId = xmldom.getElementsByTagName("NEWOWNERID").item(0).getTextContent();
			String newFolderType = xmldom.getElementsByTagName("NEWFOLDERTYPE").item(0).getTextContent();
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			if (cmd.equals("MOVE")) {
				ezAddressService.moveFolder(userInfo.getTenantId(), folderId, newParentId, newOwnerId, newFolderType);
			} else if (cmd.equals("COPY")) {
				ezAddressService.copyFolder(userInfo.getTenantId(), folderId, newParentId, newOwnerId, newFolderType, userInfo.getId());
			}
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressMoveCopyFolder ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소록 검색 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMainSearch.do")
	public String addressMainSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressMainSearch started.");
		logger.debug("orderby=" + request.getParameter("orderby") + ",filter=" + request.getParameter("filter"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String orderBy = "SNAME:0";
		String filter = "";
		String bAdmin = "";
		String cAdmin = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String useIE11Browser = "";
		String noneActiveX = "YES";
		String pListType = "";
		
		if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && ezCommonService.getTenantConfig("IE11EDITOR", userInfo.getTenantId()).equals("CK")) {
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
		
        pListType = ezAddressService.getListType(userInfo.getTenantId(), userInfo.getId());
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
		
		logger.debug("addressMainSearch ended.");
		logger.debug("userInfo=" + userInfo + ",orderBy=" + orderBy + ",filter=" + filter + ",bAdmin=" + bAdmin
				 + ",cAdmin=" + cAdmin + ",useEditor=" + useEditor + ",useIE11Browser=" + useIE11Browser + ",noneActiveX=" + noneActiveX
				 + ",pListType=" + pListType);
		
		return "ezAddress/addressMainSearch";
	}
	
	/**
	 * 주소록 리스트 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSearchList.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetSearchList(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetSearchList started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String strListPageSize = ezAddressService.getListCnt(userInfo.getTenantId(), userInfo.getId());
			if (strListPageSize == null) {
				strListPageSize = "20";
			}
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String pIdList = xmldom.getElementsByTagName("IDLIST").item(0).getTextContent().trim();
			
			String[] tempIdArr = pIdList.split(",");
			
			String[] pIdLists = new String[tempIdArr.length];
			for (int i=0; i<tempIdArr.length; i++) {
				if (tempIdArr[i].equals("P")) {
					pIdLists[i] = userInfo.getId();
				} else if (tempIdArr[i].equals("D")) {
					pIdLists[i] = userInfo.getDeptID();
				} else if (tempIdArr[i].equals("C")) {
					pIdLists[i] = userInfo.getCompanyID();
				}
			}
			
			String pOrderOption = "";
			String pFilter = "";
			String strCurrentPage = "1";
			
			if (xmldom.getElementsByTagName("ORDERBY").item(0) != null) {
				pOrderOption = xmldom.getElementsByTagName("ORDERBY").item(0).getTextContent().trim();
			}
			if (xmldom.getElementsByTagName("FILTER").item(0) != null) {
				pFilter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent().trim();
			}
			if (xmldom.getElementsByTagName("PAGE").item(0) != null) {
				strCurrentPage = xmldom.getElementsByTagName("PAGE").item(0).getTextContent().trim();
			}
			
			int pListPageSize = Integer.parseInt(strListPageSize);
			int pCurrentPage = Integer.parseInt(strCurrentPage);
			
			int start = pListPageSize * (pCurrentPage - 1);
			
			//TODO: pFilter가 항상 a,b 형식인지 확인하기
			logger.debug("pFilter=" + pFilter);
			
			int pFolderMaxCount = ezAddressService.getSearchCount(userInfo.getTenantId(), pIdLists, pFilter);
			List<AddressVO> addressList = ezAddressService.getSearchList(userInfo.getTenantId(), pIdLists, pOrderOption, pFilter, pListPageSize, start);
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<DATA>");
			sb.append("<TOTALCNT>" + pFolderMaxCount + "</TOTALCNT>");
			sb.append("<PAGESIZE>" + pListPageSize + "</PAGESIZE>");
			sb.append("<CURPAGE>" + pCurrentPage + "</CURPAGE>");
			sb.append("<DISPLAYNAME></DISPLAYNAME>");
			
			for (AddressVO vo : addressList) {
				
				//set folderType
				String folderType = "";
				if (vo.getOwnerId().equals(userInfo.getId())) {
					folderType = "P";
				} else if (vo.getOwnerId().equals(userInfo.getDeptID())) {
					folderType = "D";
				} else if (vo.getOwnerId().equals(userInfo.getCompanyID())) {
					folderType = "C";
				}
				
				sb.append("<ROW>");
				sb.append("<FOLDERID>" + vo.getFolderId() + "</FOLDERID>");
				sb.append("<FOLDERTYPE>" + folderType + "</FOLDERTYPE>");
				sb.append("<ADDRESSID>" + vo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + vo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + vo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + vo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + vo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + commonUtil.cleanValue(vo.getsName()) + "</SNAME>");
				sb.append("<SCOMPANY>" + commonUtil.cleanValue(vo.getsCompany()) + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + commonUtil.cleanValue(vo.getsCompanyPhone()) + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + commonUtil.cleanValue(vo.getsMobile()) + "</SMOBILE>");
				sb.append("<SEMAIL>" + commonUtil.cleanValue(vo.getsEmail()) + "</SEMAIL>");
				sb.append("<STYPE>" + vo.getsType() + "</STYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (Exception e) {
			returnValue = "ERROR";
			e.printStackTrace();
		}
		
		logger.debug("addressGetSearchList ended.");
		
		return returnValue;
	}
	
	/**
	 * root 주소함 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetFullTree.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetFullTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressGetFullTree started.");
		
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
		
		logger.debug("addressGetFullTree ended.");
		
		return returnValue;
		
	}
	
	/**
	 * 주소록 정보 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetListMailCall.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetListMailCall(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {		
		logger.debug("addressGetListMailCall started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String field = xmldom.getElementsByTagName("FIELD").item(0).getTextContent();
			int pageSize = Integer.parseInt(xmldom.getElementsByTagName("PAGESIZE").item(0).getTextContent());
			String filter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			int currentPage = Integer.parseInt(xmldom.getElementsByTagName("PAGE").item(0).getTextContent());
			String searchGubun = xmldom.getElementsByTagName("SEARCHGUBUN").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			
			String orderBy = "S_NAME:0";
			
			List<AddressVO> addressList = null;
			int totalCount = 0;
			
			if (searchGubun.equals("Y")) {
				//TODO: Y로 올 경우가 없는 것 같음.
				// 여기로 넘어오는지 테스트해보고 안넘어오면 지우기. 넘어오면 코딩하기.
				logger.error("searchGubun=Y. Need more code. Location:EzAddressController 1367");
			} else {
				LoginVO userInfo = commonUtil.userInfo(loginCookie);
				
				totalCount = ezAddressService.getAddressCount(userInfo.getTenantId(), folderId, ownerId, "");
				addressList = ezAddressService.getAddressList(userInfo.getTenantId(), folderId, ownerId, orderBy, "", pageSize, (currentPage - 1) * pageSize);
			}
			
			int pageCount = ((totalCount + pageSize - 1) / pageSize);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<RTNDATA>");
			sb.append("<TOTALCN>" + totalCount + "</TOTALCN>");
			sb.append("<CURRENTPAGE>" + currentPage + "</CURRENTPAGE>");
			sb.append("<PAGECOUNT>" + pageCount + "</PAGECOUNT>");
			sb.append("<DATA>");
			
			for (AddressVO addressInfo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + addressInfo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + addressInfo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + addressInfo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + addressInfo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + addressInfo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + commonUtil.cleanValue(addressInfo.getsName()) + "</SNAME>");
				sb.append("<SCOMPANY>" + commonUtil.cleanValue(addressInfo.getsCompany()) + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + commonUtil.cleanValue(addressInfo.getsCompanyPhone()) + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + commonUtil.cleanValue(addressInfo.getsMobile()) + "</SMOBILE>");
				sb.append("<SEMAIL>" + commonUtil.cleanValue(addressInfo.getsEmail()) + "</SEMAIL>");
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
		
		logger.debug("addressGetListMailCall ended.");
		
		return returnValue;
	}
	
	/**
	 * 주소록 구성원 보기 및 선택 화면 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressSelectGroupMailList.do")
	public String addressSelectGroupMailList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressSelectGroupMailList started. id=" + request.getParameter("id"));
		
		String addressId = request.getParameter("id") == null ? "" : request.getParameter("id");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		AddressVO addressInfo =  ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), addressId);
		String address = addressInfo.getsMemo();
		
		List<InternetAddress> list = new ArrayList<InternetAddress>();
		if (address != null && !address.trim().equals("")) {
			String[] addressRows = address.split(";");
			
			for (String addr : addressRows) {
				list.add(new InternetAddress(addr));
			}
		}
		
		model.addAttribute("list", list);
		
		logger.debug("addressSelectGroupMailList ended.");
		
		return "ezAddress/addressSelectGroupMailList";
	}
	
	/**
	 * 주소록 검색 정보 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetListMailSearchCall.do", produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetListMailSearchCall(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {		
		logger.debug("addressGetListMailSearchCall started.");
		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String pFolderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			int pListPageSize = Integer.parseInt(xmldom.getElementsByTagName("PAGESIZE").item(0).getTextContent());
			int pCurrentPage = Integer.parseInt(xmldom.getElementsByTagName("PAGE").item(0).getTextContent());
			String pFolderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			String pSearchText = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			String pSearchCase = xmldom.getElementsByTagName("CASE").item(0).getTextContent();
			
			int start = (pListPageSize * (pCurrentPage - 1));
			
			String pOwnerId = userInfo.getCompanyID();
			if (pFolderType.equals("P")) {
				pOwnerId = userInfo.getId();
			} else if (pFolderType.equals("D")) {
				pOwnerId = userInfo.getDeptID();
			}
			
			String pFilter = "";
			if (pSearchCase != null && !pSearchCase.trim().equals("")) {
				pFilter = pSearchCase + "," + pSearchText.trim();
			}
			
			int totalCount = ezAddressService.getAddressCount(userInfo.getTenantId(), pFolderId, pOwnerId, pFilter);
			List<AddressVO> addressList = ezAddressService.getAddressList(userInfo.getTenantId(), pFolderId, pOwnerId, "", pFilter, pListPageSize, start);
			
			int pageCount = ((totalCount + pListPageSize - 1) / pListPageSize);
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<RTNDATA>");
			sb.append("<TOTALCN>" + totalCount + "</TOTALCN>");
			sb.append("<CURRENTPAGE>" + pCurrentPage + "</CURRENTPAGE>");
			sb.append("<PAGECOUNT>" + pageCount + "</PAGECOUNT>");
			sb.append("<DATA>");
			
			for (AddressVO addressInfo : addressList) {
				sb.append("<ROW>");
				sb.append("<ADDRESSID>" + addressInfo.getAddressId() + "</ADDRESSID>");
				sb.append("<CREATORID>" + addressInfo.getCreatorId() + "</CREATORID>");
				sb.append("<MODIFIERID>" + addressInfo.getModifierId() + "</MODIFIERID>");
				sb.append("<HASATTACH>" + addressInfo.getHasAttach() + "</HASATTACH>");
				sb.append("<HASCOMMENT>" + addressInfo.getHasComment() + "</HASCOMMENT>");
				sb.append("<SNAME>" + commonUtil.cleanValue(addressInfo.getsName()) + "</SNAME>");
				sb.append("<SCOMPANY>" + commonUtil.cleanValue(addressInfo.getsCompany()) + "</SCOMPANY>");
				sb.append("<SCOMPANYPHONE>" + commonUtil.cleanValue(addressInfo.getsCompanyPhone()) + "</SCOMPANYPHONE>");
				sb.append("<SMOBILE>" + commonUtil.cleanValue(addressInfo.getsMobile()) + "</SMOBILE>");
				sb.append("<SEMAIL>" + commonUtil.cleanValue(addressInfo.getsEmail()) + "</SEMAIL>");
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
		
		logger.debug("addressGetListMailSearchCall ended.");
		
		return returnValue;
	}
	
	/**
	 * 주소록 내보내기 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/excelExport.do")
	public void addressExport(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model, HttpServletResponse response) throws Exception {		
		logger.debug("addressExport started.");
		logger.debug("folderid=" + request.getParameter("folderid") + ",foldertype=" + request.getParameter("foldertype") + ",ownerid=" + request.getParameter("ownerid"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String folderId = request.getParameter("folderid");
		String folderType = request.getParameter("foldertype");
		String ownerId = request.getParameter("ownerid");
		
        logger.debug("folderId=" + folderId + ",folderType=" + folderType + ",ownerId=" + ownerId);
        
		String fileName = "excelExport.csv";
		
		response.setContentType("application/x-msexcel; charset=utf-8");
		String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"%s\"", fileName);
        response.setHeader(headerKey, headerValue);
		
        OutputStreamWriter writer = null;
		CSVWriter csvWriter = null;
		
		try {
			String charset = "euc-kr";
			
			if (userInfo.getLang().equals("3")) {
				charset = "shift-jis";
			}
			
			writer = new OutputStreamWriter(response.getOutputStream(), charset);
			
			csvWriter = new CSVWriter(writer, CSVWriter.DEFAULT_SEPARATOR, CSVWriter.DEFAULT_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, "\r\n");
			
	        String[] headArray = new String[87];
	        headArray[0] = egovMessageSource.getMessage("ezAddress.t123", locale); headArray[1] = egovMessageSource.getMessage("ezAddress.x0001", locale);
	        headArray[2] = egovMessageSource.getMessage("ezAddress.t125", locale); headArray[3] = egovMessageSource.getMessage("ezAddress.t126", locale);
	        headArray[4] = egovMessageSource.getMessage("ezAddress.t127", locale); headArray[5] = egovMessageSource.getMessage("ezAddress.x0002", locale);
	        headArray[6] = egovMessageSource.getMessage("ezAddress.t54", locale); headArray[7] = egovMessageSource.getMessage("ezAddress.t52", locale);
	        headArray[8] = egovMessageSource.getMessage("ezAddress.t203", locale); headArray[9] = egovMessageSource.getMessage("ezAddress.t130", locale);
	        headArray[10] = egovMessageSource.getMessage("ezAddress.t131", locale); headArray[11] = egovMessageSource.getMessage("ezAddress.t202", locale);
	        headArray[12] = egovMessageSource.getMessage("ezAddress.t133", locale); headArray[13] = egovMessageSource.getMessage("ezAddress.t134", locale);
	        headArray[14] = egovMessageSource.getMessage("ezAddress.t135", locale); headArray[15] = egovMessageSource.getMessage("ezAddress.t136", locale);
	        headArray[16] = egovMessageSource.getMessage("ezAddress.t53", locale); headArray[17] = egovMessageSource.getMessage("ezAddress.t137", locale);
	        headArray[18] = egovMessageSource.getMessage("ezAddress.t55", locale); headArray[19] = egovMessageSource.getMessage("ezAddress.t56", locale);
	        headArray[20] = egovMessageSource.getMessage("ezAddress.t57", locale); headArray[21] = egovMessageSource.getMessage("ezAddress.t58", locale);
	        headArray[22] = egovMessageSource.getMessage("ezAddress.t59", locale); headArray[23] = egovMessageSource.getMessage("ezAddress.t60", locale);
	        headArray[24] = egovMessageSource.getMessage("ezAddress.t61", locale); headArray[25] = egovMessageSource.getMessage("ezAddress.t62", locale);
	        headArray[26] = egovMessageSource.getMessage("ezAddress.t63", locale); headArray[27] = egovMessageSource.getMessage("ezAddress.t64", locale);
	        headArray[28] = egovMessageSource.getMessage("ezAddress.t65", locale); headArray[29] = egovMessageSource.getMessage("ezAddress.t66", locale);
	        headArray[30] = egovMessageSource.getMessage("ezAddress.t207", locale); headArray[31] = egovMessageSource.getMessage("ezAddress.t68", locale);
	        headArray[32] = egovMessageSource.getMessage("ezAddress.t69", locale); headArray[33] = egovMessageSource.getMessage("ezAddress.t70", locale);
	        headArray[34] = egovMessageSource.getMessage("ezAddress.t71", locale); headArray[35] = egovMessageSource.getMessage("ezAddress.t72", locale);
	        headArray[36] = egovMessageSource.getMessage("ezAddress.t73", locale); headArray[37] = egovMessageSource.getMessage("ezAddress.t74", locale);
	        headArray[38] = egovMessageSource.getMessage("ezAddress.t75", locale); headArray[39] = "ISDN"; headArray[40] = egovMessageSource.getMessage("ezAddress.t189", locale);
	        headArray[41] = egovMessageSource.getMessage("ezAddress.t77", locale); headArray[42] = egovMessageSource.getMessage("ezAddress.t78", locale);
	        headArray[43] = egovMessageSource.getMessage("ezAddress.t79", locale); headArray[44] = egovMessageSource.getMessage("ezAddress.t80", locale);
	        headArray[45] = egovMessageSource.getMessage("ezAddress.t81", locale); headArray[46] = "TDD/TTY " + egovMessageSource.getMessage("ezAddress.t82", locale);
	        headArray[47] = egovMessageSource.getMessage("ezAddress.t83", locale); headArray[48] = egovMessageSource.getMessage("ezAddress.t84", locale);
	        headArray[49] = egovMessageSource.getMessage("ezAddress.t85", locale); headArray[50] = egovMessageSource.getMessage("ezAddress.t86", locale);
	        headArray[51] = egovMessageSource.getMessage("ezAddress.t87", locale); headArray[52] = egovMessageSource.getMessage("ezAddress.t88", locale);
	        headArray[53] = egovMessageSource.getMessage("ezAddress.t89", locale); headArray[54] = egovMessageSource.getMessage("ezAddress.t90", locale);
	        headArray[55] = egovMessageSource.getMessage("ezAddress.t91", locale); headArray[56] = egovMessageSource.getMessage("ezAddress.t92", locale);
	        headArray[57] = egovMessageSource.getMessage("ezAddress.t93", locale); headArray[58] = egovMessageSource.getMessage("ezAddress.t94", locale);
	        headArray[59] = egovMessageSource.getMessage("ezAddress.t95", locale); headArray[60] = egovMessageSource.getMessage("ezAddress.t96", locale);
	        headArray[61] = egovMessageSource.getMessage("ezAddress.t97", locale); headArray[62] = egovMessageSource.getMessage("ezAddress.t98", locale);
	        headArray[63] = egovMessageSource.getMessage("ezAddress.t99", locale); headArray[64] = egovMessageSource.getMessage("ezAddress.t100", locale);
	        headArray[65] = egovMessageSource.getMessage("ezAddress.t101", locale); headArray[66] = egovMessageSource.getMessage("ezAddress.t102", locale);
	        headArray[67] = egovMessageSource.getMessage("ezAddress.t103", locale); headArray[68] = egovMessageSource.getMessage("ezAddress.t104", locale);
	        headArray[69] = egovMessageSource.getMessage("ezAddress.t105", locale); headArray[70] = egovMessageSource.getMessage("ezAddress.t106", locale);
	        headArray[71] = egovMessageSource.getMessage("ezAddress.t107", locale); headArray[72] = egovMessageSource.getMessage("ezAddress.t108", locale);
	        headArray[73] = egovMessageSource.getMessage("ezAddress.t109", locale); headArray[74] = egovMessageSource.getMessage("ezAddress.t110", locale);
	        headArray[75] = egovMessageSource.getMessage("ezAddress.t38", locale); headArray[76] = egovMessageSource.getMessage("ezAddress.t112", locale);
	        headArray[77] = egovMessageSource.getMessage("ezAddress.t113", locale); headArray[78] = egovMessageSource.getMessage("ezAddress.t114", locale);
	        headArray[79] = egovMessageSource.getMessage("ezAddress.t115", locale); headArray[80] = egovMessageSource.getMessage("ezAddress.t116", locale);
	        headArray[81] = egovMessageSource.getMessage("ezAddress.t117", locale); headArray[82] = egovMessageSource.getMessage("ezAddress.t118", locale);
	        headArray[83] = egovMessageSource.getMessage("ezAddress.t119", locale); headArray[84] = egovMessageSource.getMessage("ezAddress.t120", locale);
	        headArray[85] = egovMessageSource.getMessage("ezAddress.t121", locale); headArray[86] = egovMessageSource.getMessage("ezAddress.t122", locale);
	        
	        csvWriter.writeNext(headArray);
	        csvWriter.flush();
	        
	        List<AddressVO> addressList = ezAddressService.getAllAddressList(userInfo.getTenantId(), folderId, ownerId, "", null);
	        
	        for (AddressVO address : addressList) {
	        	String[] valueArray = new String[87];
	        	Arrays.fill(valueArray, "");
	        	
	        	valueArray[1] = address.getsName();
	        	valueArray[5] = address.getsCompany();
	        	valueArray[6] = address.getsDept();
	        	valueArray[7] = address.getsTitle();
	        	valueArray[13] = address.getsCompanyZip();
	        	valueArray[20] = address.getsHomeZip();
	        	valueArray[30] = address.getsFax();
	        	valueArray[31] = address.getsCompanyPhone();
	        	valueArray[40] = address.getsMobile();
	        	valueArray[72] = address.getsHomePage();
	        	valueArray[75] = address.getsEmail();
	        	valueArray[76] = address.getsName();
	        	valueArray[55] = address.getsMemo();
	        	
	        	valueArray[8] = address.getsCompanyAddr();
	        	valueArray[15] = address.getsHomeAddr();
	        	/*if (xmldomInfo.GetElementsByTagName("SCOMPANYSTREET").Count > 0)
                {
                    valueList_Array[8] = xmldomInfo.GetElementsByTagName("SCOMPANYSTREET").Item(i).InnerText;
                    valueList_Array[11] = xmldomInfo.GetElementsByTagName("SCOMPANYCITY").Item(i).InnerText;
                    valueList_Array[12] = xmldomInfo.GetElementsByTagName("SCOMPANYSTATE").Item(i).InnerText;
                }
                else
                {
                    valueList_Array[8] = xmldomInfo.GetElementsByTagName("SCOMPANYADDR").Item(i).InnerText;
                    valueList_Array[11] = "";
                    valueList_Array[12] = "";
                }
                
                if (xmldomInfo.GetElementsByTagName("SHOMESTREET").Count > 0)
                {
                    valueList_Array[15] = xmldomInfo.GetElementsByTagName("SHOMESTREET").Item(i).InnerText;
                    valueList_Array[18] = xmldomInfo.GetElementsByTagName("SHOMECITY").Item(i).InnerText;
                    valueList_Array[19] = xmldomInfo.GetElementsByTagName("SHOMESTATE").Item(i).InnerText;
                }
                else
                {
                    valueList_Array[15] = xmldomInfo.GetElementsByTagName("SHOMEADDR").Item(i).InnerText;
                    valueList_Array[18] = "";
                    valueList_Array[19] = "";
                }*/
	        	
	        	csvWriter.writeNext(valueArray);
		        csvWriter.flush();
	        }
	        
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			if (csvWriter != null) {
				try {
					csvWriter.close();
				} catch(IOException e) {}
			}
			if (writer != null) {
				writer.close();
			}
		}
	    
		logger.debug("addressExport ended.");
	}
	
	/**
	 * 주소록 가져오기 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/excelImport.do")
	public String addressImport(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressImport started.");
		
		String result = "OK";
		String folderId = request.getParameter("folderid");
        String folderType = request.getParameter("foldertype");
        String ownerId = request.getParameter("ownerid");
		
        logger.debug("folderId=" + folderId + ",folderType=" + folderType + ",ownerId=" + ownerId);
        
		List<MultipartFile> multiFile = request.getFiles("file1");
		
        if (multiFile == null || multiFile.get(0) == null) {
        	logger.error("cannot find file.");
        	model.addAttribute("result", "ERROR");
            return "ezAddress/addressImportComplete";
        }
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        
        InputStream stream = null;
        InputStreamReader reader = null;
        CSVReader csvReader = null;
        List<String[]> csvList = null;
        
        try {
	        stream = multiFile.get(0).getInputStream();
	        
	        String charset = "euc-kr";
	        
			if (userInfo.getLang().equals("3")) {
				charset = "shift-jis";
			}
			
			logger.debug("charset=" + charset);
			
	        reader = new InputStreamReader(stream, charset);
	        csvReader = new CSVReader(reader);
	        csvList = csvReader.readAll();
        } catch (IOException e) {
        	logger.error(e.getMessage());
        	e.printStackTrace();
        } finally {
        	if (csvReader != null) {
        		try {
        			csvReader.close();
        		} catch (IOException e) {}
        	}
        	
        	if (reader != null) {
        		try {
        			reader.close();
        		} catch (IOException e) {}
        	}
        	
        	if (stream != null) {
        		try {
        			stream.close();
        		} catch (IOException e) {}
        	}
		}
        
        if (csvList == null || csvList.get(0) == null || csvList.get(0).length == 0) {
        	logger.error("Check CSV file format.");
        	model.addAttribute("result", "ERROR");
        	
            return "ezAddress/addressImportComplete";
        }
        
        String[] headerArr = new String[]{
        		egovMessageSource.getMessage("ezAddress.x0001", locale), //name
        		egovMessageSource.getMessage("ezAddress.t126", locale), //lastName
        		egovMessageSource.getMessage("ezAddress.x0002", locale), //company
        		egovMessageSource.getMessage("ezAddress.t54", locale), //dept
        		egovMessageSource.getMessage("ezAddress.t52", locale), //title
        		egovMessageSource.getMessage("ezAddress.t68", locale), //companyPhone
        		egovMessageSource.getMessage("ezAddress.t207", locale), //fax
        		egovMessageSource.getMessage("ezAddress.t189", locale), //mobile
        		egovMessageSource.getMessage("ezAddress.t38", locale), //email
        		egovMessageSource.getMessage("ezAddress.t108", locale), //homePage
        		egovMessageSource.getMessage("ezAddress.t134", locale), //companyZip
        		egovMessageSource.getMessage("ezAddress.t203", locale), //companyAddr
        		egovMessageSource.getMessage("ezAddress.t57", locale), //homeZip
        		egovMessageSource.getMessage("ezAddress.t136", locale), //homeAddr
        		egovMessageSource.getMessage("ezAddress.t91", locale) //memo
        	};
        
        String groupMailStr = egovMessageSource.getMessage("ezAddress.t180", locale);
        String[] csvHeader = csvList.get(0);
        String[] csvBody = null;
        Map<String, String> csvBodyMap = null;
        
        for (int i = 1; i < csvList.size(); i++) {
        	try {
        		csvBody = csvList.get(i);
	        	
        		csvBodyMap = new HashMap<String, String>();
        		
	        	for (int j=0; j<csvBody.length; j++) {
	        		csvBodyMap.put(csvHeader[j], csvBody[j]);
	        	}
	        	
	        	csvBody = new String[headerArr.length];
	        	Arrays.fill(csvBody, "");
	        	
	        	for (int j=0; j<headerArr.length; j++) {
	        		if (csvBodyMap.get(headerArr[j]) != null) {
	        			csvBody[j] = csvBodyMap.get(headerArr[j]);
	            	}
	        	}
	        	
	        	// 영어권이 아니면 이름 필드에 성+이름, 영어권이면 이름만
	        	if (!userInfo.getLang().equals("2")) {
	        		csvBody[0] = csvBody[1] + " " + csvBody[0];
	        		csvBody[0] = csvBody[0].trim();
	        	}
	        	
        		if (csvBody[8].equals(groupMailStr)) {
        			ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), 
        					csvBody[0], csvBody[8], csvBody[2], csvBody[3], csvBody[4], 
        					csvBody[5], csvBody[6], csvBody[7], csvBody[9], 
        					csvBody[10], csvBody[11], csvBody[12], csvBody[13], csvBody[14], "G");
        		} else {
        			ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), 
        					csvBody[0], csvBody[8], csvBody[2], csvBody[3], csvBody[4], 
        					csvBody[5], csvBody[6], csvBody[7], csvBody[9], 
        					csvBody[10], csvBody[11], csvBody[12], csvBody[13], csvBody[14], "P");
        		}
        	} catch (Exception e) {
        		result = "ERROR";
        		logger.error("Import address fail. CSV " + i + "th line.");
        		e.printStackTrace();
        	}
        }
        
        model.addAttribute("result", result);
        
        logger.debug("addressImport ended.");
        return "ezAddress/addressImportComplete";
	}
	
}