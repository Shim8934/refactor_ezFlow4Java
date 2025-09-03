package egovframework.ezEKP.ezAddress.web;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;
import java.util.regex.PatternSyntaxException;

import javax.annotation.Resource;
import javax.mail.internet.InternetAddress;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import egovframework.ezEKP.ezOrgan.vo.OrganAuth;
import egovframework.ezEKP.ezOrgan.vo.OrganAuth.AdminAuth;
import org.apache.commons.lang3.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
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
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.w3c.dom.DOMException;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.opencsv.CSVReader;
import com.opencsv.CSVWriter;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezAddress.service.EzAddressService;
import egovframework.ezEKP.ezAddress.vo.AddressFolderVO;
import egovframework.ezEKP.ezAddress.vo.AddressVO;
import egovframework.ezEKP.ezAddress.vo.AddressZipCodeVO;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.ClientUtil;
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
	
	@Resource(name="EzCabinetAdminService")
	private EzCabinetAdminService cabinetAdminService;
	
	/**
	 * 도로명 주소 팝업창 호출 함수 (Open API)
	 */
	@RequestMapping(value = "/ezAddress/addressZipCodePopUpOpen.do")
	public String addressZipCodePopupOpen(Model model) throws Exception {
		logger.debug("addressZipCodePopupOpen started.");
		
		// ※ 행정망 내에서 운영되는 시스템도 이용 가능합니다. 행정망 서비스를 위한 API 요청URL은 별도로 문의 주시기 바랍니다.(1588-0061)
		model.addAttribute("resultType", "4"); // 검색결과 화면 출력유형 (1 : 도로명, 2 : 도로명+지번, 3 : 도로명+상세건물명, 4 : 도로명+지번+상세건물명)
		
		logger.debug("addressZipCodePopupOpen ended.");
		
		return "ezAddress/addressZipSelectInternet";
	}

	/**
	 * 도로명 주소 검색 실행 함수 (Open API)
	 * (참고) 어플리케이션 호출 소스 보기 -> https://business.juso.go.kr/addrlink/openApi/searchApi.do
	 */
	@RequestMapping(value = "/ezAddress/addressZipCodeListOpen.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	public void addressZipCodeListOpen(HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("addressZipCodeListOpen started.");

		String currentPage = request.getParameter("currentPage");
		String countPerPage = request.getParameter("countPerPage");
		String confmKey = config.getProperty("config.ConfirmKey");
		String jusoDomain = config.getProperty("config.jusoDomain", "business.juso.go.kr");
		String keyword = request.getParameter("keyword");

		logger.debug("currentPage: {} || countPerPage: {} || keyword: {}", currentPage, countPerPage, keyword);

		String isSecure = request.isSecure()? "https" : "http";
		String apiUrl = isSecure + "://" + jusoDomain + "/addrlink/addrLinkApi.do?currentPage=" + currentPage
				+ "&countPerPage=" + countPerPage + "&keyword=" + URLEncoder.encode(keyword, "UTF-8") + "&confmKey=" + confmKey;

		URL url = new URL(apiUrl);
		//BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"));
		
		// 2023-06-01 이사라 : 시큐어코딩 리소스 close
		try (BufferedReader br = new BufferedReader(new InputStreamReader(url.openStream(), "UTF-8"))) {
			StringBuffer sb = new StringBuffer();
			String tempStr = null;
			while (true) {
				tempStr = br.readLine();
				if (tempStr == null)
					break;
				sb.append(tempStr);
			}

			// br.close();
			response.setCharacterEncoding("UTF-8");
			response.setContentType("text/xml");
			response.getWriter().write(sb.toString());
		} catch (IOException e) {
			logger.error(e.getMessage(), e);
		}

		logger.debug("addressZipCodeListOpen ended.");
	}
	
	/**
	 * 도로명 주소 팝업창 호출 함수 (Local)
	 */
	@RequestMapping(value = "/ezAddress/addressZipCodePopUp.do", method = RequestMethod.GET)
	public String addressZipCodePopup(Model model) throws Exception {
		return "ezAddress/addressZipSelect";
	}
	
	/**
	 * 도로명 주소 검색 실행 함수 (Local)
	 */
	@RequestMapping(value = "/ezAddress/addressZipCodeList.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressZipCodeList(HttpServletRequest request) throws Exception {
		Document xmldom = commonUtil.convertRequestToDocument(request);
		StringBuilder sb = new StringBuilder();
		if (xmldom != null){
			String sido = xmldom.getElementsByTagName("SIDO").item(0).getTextContent();
			String keyword = xmldom.getElementsByTagName("KEYWORD").item(0).getTextContent();
			String page = xmldom.getElementsByTagName("PAGE").item(0).getTextContent();

			sb.append("<DATA>");

			Map<String, Object> resultMap = ezAddressService.getAddressZipCodeList(sido, keyword, Integer.parseInt(page));

			int totalCount = (Integer)resultMap.get("totalCount");
			sb.append("<TOTALCOUNT>" + totalCount + "</TOTALCOUNT>");

			@SuppressWarnings("unchecked")
			List<AddressZipCodeVO> list = (List<AddressZipCodeVO>)resultMap.get("list");

			for (AddressZipCodeVO vo : list) {
				sb.append("<ROW>");
				sb.append("<ZIPCODE>" + vo.getZipCode() + "</ZIPCODE>");
				sb.append("<DORO>" + vo.getDoro() + "</DORO>");
				sb.append("<JIBUN>" + vo.getJibun() + "</JIBUN>");
				sb.append("</ROW>");
			}

			sb.append("</DATA>");
		}
		
		return sb.toString();
	}
	
	/**
	 * 주소록 서브 폴더 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSubTree.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetSubTree(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetSubTree started.");
		logger.debug("bodyData=" + bodyData);
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		StringBuilder sb = new StringBuilder();
		if (xmldom != null){
			String parentId = xmldom.getElementsByTagName("PARENTID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
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
		}
		
		logger.debug("addressGetSubTree ended.");
		
		return sb.toString();
	}
	
	/**
	 * 주소록 메인화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMainList.do", method = RequestMethod.GET)
	public String addressMainList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressMainList started.");
		logger.debug("folderid=" + request.getParameter("folderid") + ",type=" + request.getParameter("type"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String compAdmin = "";
		String deptAdmin = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		
		String pFolderId = request.getParameter("folderid") == null ? "normal" : request.getParameter("folderid");
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());
		
		if (organAuth.isAuth(AdminAuth.DEPT_MANAGER, userInfo.getDeptID())) {
			deptAdmin = "Y";
		}
		
		if (organAuth.isAuth(AdminAuth.COMPANY_MANAGER, userInfo.getCompanyID()) || organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			compAdmin = "Y";
			deptAdmin = "Y";
		}
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
		
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
		
		String useAddrDupliCheck = ezCommonService.getTenantConfig("useAddrDupliCheck", userInfo.getTenantId());
		
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("pFolderId", pFolderId);
		model.addAttribute("pFolderType", pFolderType);
		model.addAttribute("pOwerId", pOwerId);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pListType", pListType);
		model.addAttribute("useAddrDupliCheck", useAddrDupliCheck);
		
		logger.debug("addressMainList ended.");
		logger.debug("userInfo=" + userInfo + ",pFolderId=" + pFolderId + ",pFolderType=" + pFolderType + ",pOwerId=" + pOwerId
				 + ",compAdmin=" + compAdmin + ",deptAdmin=" + deptAdmin + ",useEditor=" + useEditor
				 + ",noneActiveX=" + noneActiveX + ",pListType=" + pListType + ",useAddrDupliCheck=" + useAddrDupliCheck);
		
		return "ezAddress/addressMainList";
	}
	
	/**
	 * 주소록 리스트 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressList.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
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
			// String pFolderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			String pFolderName = "";
			
			String addressType = xmldom.getElementsByTagName("ADDRTYPE").item(0) != null ? 
					StringUtils.defaultIfBlank(xmldom.getElementsByTagName("ADDRTYPE").item(0).getTextContent(), "ALL") : "ALL"; // ALL||GROUP||PERSONAL
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
			
			int pFolderMaxCount = ezAddressService.getAddressCount(userInfo.getTenantId(), pFolderID, pOwnerID, pFilter, addressType);
			
			List<AddressVO> addressList = ezAddressService.getAddressList(userInfo.getTenantId(), pFolderID, pOwnerID, pOrderOption, pFilter, pListPageSize, start, addressType);
			
			StringBuilder sb = new StringBuilder();
			
			sb.append("<DATA>");
			sb.append("<TOTALCNT>" + pFolderMaxCount + "</TOTALCNT>");
			sb.append("<PAGESIZE>" + pListPageSize + "</PAGESIZE>");
			sb.append("<CURPAGE>" + pCurrentPage + "</CURPAGE>");
			sb.append("<DISPLAYNAME>" + pFolderName + "</DISPLAYNAME>");
			
			for (AddressVO vo : addressList) {
				String sType = vo.getsType();
				String sEmail = sType.equals("G") ? egovMessageSource.getMessage("ezBoard.t18", userInfo.getLocale()) : commonUtil.cleanValue(vo.getsEmail());
				
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
				sb.append("<SEMAIL>" + sEmail + "</SEMAIL>");
				sb.append("<STYPE>" + sType + "</STYPE>");
				sb.append("</ROW>");				
			}
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressList ended.");
		
		return returnValue;
	}
	
	/**
	 * 주소록 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressWrite.do", method = RequestMethod.GET)
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
		String compAdmin = "";
		String deptAdmin = "";

		OrganAuth organAuth = commonUtil.makeOrganAuth(userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID(), userInfo.getJobId());

		if (organAuth.isAuth(AdminAuth.DEPT_MANAGER, userInfo.getDeptID())) {
			deptAdmin = "Y";
		}

		if (organAuth.isAuth(AdminAuth.COMPANY_MANAGER, userInfo.getCompanyID()) || organAuth.isAuth(AdminAuth.ADMIN_MASTER)) {
			compAdmin = "Y";
			deptAdmin = "Y";
		}		
		
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
			} else {
				AddressFolderVO folderInfo = ezAddressService.getFolderInfo(folderId);
				ownerId = folderInfo.getOwnerId();
			}
		} else { // 20190523 조진호 - 사용자가 url을 바꾸어 접근 한 경우 ownerId와 실제 사용자가 다르더라도 다른 사용자의 주소록에 등록이 가능한 오류 수정
			if (folderType.equals("P") && !ownerId.equalsIgnoreCase(userInfo.getId())) {
				ownerId = userInfo.getId();
			} else if (folderType.equals("D") && !ownerId.equalsIgnoreCase(userInfo.getDeptID())) {
				ownerId = userInfo.getDeptID();
			} else if (folderType.equals("C") && !ownerId.equalsIgnoreCase(userInfo.getCompanyID())) {
				ownerId = userInfo.getCompanyID();
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
		
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String useZipCodeSearch = ezCommonService.getTenantConfig("useZipCodeSearch", userInfo.getTenantId());
		
		if (useZipCodeSearch == null || useZipCodeSearch.equals("")) {
			useZipCodeSearch = "YES";
		}
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
		boolean useOnlyInnerMail = "yes".equalsIgnoreCase(ezCommonService.getTenantConfig("UseOnlyInnerMail", userInfo.getTenantId()));
		
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
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useZipCodeSearch", useZipCodeSearch);
		model.addAttribute("userLang", userInfo.getLang());
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
		model.addAttribute("useOnlyInnerMail", useOnlyInnerMail);
		
		logger.debug("addressWrite ended.");
		logger.debug("addressId=" + addressId + ",folderId=" + folderId + ",folderType=" + folderType + ",ownerId=" + ownerId
				 + ",changeKey=" + changeKey + ",photoUrl=" + photoUrl + ",textEmail=" + textEmail + ",userNM=" + userNM
				 + ",userNM2=" + userNM2 + ",rootAddressSelection=" + rootAddressSelection + ",useAddressOpenAPI=" + useAddressOpenAPI
				 + ",primaryLang=" + primaryLang + ",useZipCodeSearch=" + useZipCodeSearch + ",deptAdmin=" + deptAdmin + ",compAdmin=" + compAdmin);
		
		return "ezAddress/addressWrite";
	}
	
	/**
	 * 주소록 중복검사 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSearchCnt.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressGetSearchCnt(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetSearchCnt started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnData = "";
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
		if (xmldom != null){
			String ownerId = xmldom.getElementsByTagName("IDLIST").item(0).getTextContent();
			String sEmail = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();

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

			boolean isDuplicate = ezAddressService.checkDuplicateAddress(userInfo.getTenantId(), ownerId, sEmail.trim());
			if (isDuplicate) {
				returnData = "1";
			} else {
				returnData = "0";
			}
		}

		logger.debug("addressGetSearchCnt ended.");
		logger.debug("returnData=" + returnData);
		
		return returnData;
	}
	
	/**
	 * 주소록 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressSave started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnVaule = "OK";
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom == null){
				throw new Exception("xmldom is null");
			}
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			String addressId = xmldom.getElementsByTagName("ADDRESSID").item(0).getTextContent();
			// String photoPath = xmldom.getElementsByTagName("PHOTOPATH").item(0).getTextContent();
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
			// String sUserNM = xmldom.getElementsByTagName("USERNM").item(0).getTextContent();
			// String sUserNM2 = xmldom.getElementsByTagName("USERNM2").item(0).getTextContent();
			String sFurigana = xmldom.getElementsByTagName("FURIGANA").item(0).getTextContent();
			
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
			
			if (addressId.equals("")) { //주소록 생성
				String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
				logger.debug("useAnyoneEdit="+ useAnyoneEdit);
				
				// UseAnyoneEdit이 YES가 아닐 경우 관리자인지 체크
				if (!useAnyoneEdit.equals("YES")) {
					if (folderType.equals("C")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
							return "NO_AUTHORITY_C";
						}
					} else if (folderType.equals("D")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
							return "NO_AUTHORITY_D";
						}
					}
				}
				
				ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), 
						sName, sEmail, sCompany, sDept, sTitle, 
						sCompanyPhone, sFax, sMobile, sHomePage, 
						sCompanyZip, sCompanyAddr, sHomeZip, sHomeAddr, sMemo, sType, sFurigana);
			} else { //주소록 수정
				AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), addressId);
				
				if (!addressInfo.getCreatorId().equals(userInfo.getId()) && !addressInfo.getModifierId().equals(userInfo.getId())) { //작성자나 최종편집인이 아닐 경우
					//관리자인지 체크
					if (folderType.equals("C")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
							return "NO_AUTHORITY_C";
						}
					} else if (folderType.equals("D")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
							return "NO_AUTHORITY_D";
						}
					}
				}
				
				ezAddressService.updateAddress(userInfo.getTenantId(), addressId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(),
						sName, sEmail, sCompany, sDept, sTitle, 
						sCompanyPhone, sFax, sMobile, sHomePage, 
						sCompanyZip, sCompanyAddr, sHomeZip, sHomeAddr, sMemo, sFurigana);
			}
		} catch (DOMException e) {
			returnVaule = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnVaule = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressSave ended. returnVaule=" + returnVaule);
		return returnVaule;
	}
	
	/**
	 * 주소록 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressRead.do", method = RequestMethod.GET)
	public String addressRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressRead started.");
		logger.debug("addressid=" + request.getParameter("addressid") + ",folderid=" + request.getParameter("folderid")
			+ ",type=" + request.getParameter("type"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		String compAdmin = "";
		String deptAdmin = "";
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("addrs", userInfo);
		}
		
		String pAddressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String pFolderId = request.getParameter("folderid") == null ? "" : request.getParameter("folderid");
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		
		boolean gyumJikChk = true;
		boolean checkAddressAccessPermission = ezAddressService.checkAddressAccessPermission(pAddressId, loginCookie);
		
		// 2023.05.08 한슬기 : 주소록 url의 addressId를 임의로 수정하여 타 사용자의 주소록을 열람할 수 없도록 검증하는 코드 추가
		if(!checkAddressAccessPermission) {
			return "ezAddress/addressRead";
		}

        /*
		if (userInfo.getGyumJik() != null) {
			if (userInfo.getGyumJik().indexOf(userInfo.getCompanyID()) != -1) {
				gyumJikChk = false;
			}
		}
         */
		
		if (gyumJikChk) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
				compAdmin = "Y";
				deptAdmin = "Y";
			} else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
				deptAdmin = "Y";
			}
		}
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
		
		AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);
		String dateInUserTimeZone = commonUtil.getDateStringInUTC(addressInfo.getCreateDate(), userInfo.getOffset(), false);
		dateInUserTimeZone = dateInUserTimeZone.substring(0, dateInUserTimeZone.indexOf(" "));
		addressInfo.setCreateDate(dateInUserTimeZone);
		
		dateInUserTimeZone = commonUtil.getDateStringInUTC(addressInfo.getModifyDate(), userInfo.getOffset(), false);
		dateInUserTimeZone = dateInUserTimeZone.substring(0, dateInUserTimeZone.indexOf(" "));
		addressInfo.setModifyDate(dateInUserTimeZone);
		
		String replaceMemo = addressInfo.getsMemo();
		
		if (replaceMemo != null) {
			replaceMemo = replaceMemo.replace("\\", "\\\\").replaceAll("\"", "\\\\\"").replace("\'", "\\\'").replaceAll("\n", "&#92;n").replaceAll("/", "\\\\/");
		}
		
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("addressInfo", addressInfo);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
		model.addAttribute("pAddressId", pAddressId);
		model.addAttribute("pFolderId", pFolderId);
		model.addAttribute("pFolderType", pFolderType);
		model.addAttribute("getsMemo", replaceMemo);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		model.addAttribute("primaryLang", primaryLang);
		
		logger.debug("addressRead ended.");
		logger.debug("useEditor=" + useEditor + ",noneActiveX=" + noneActiveX + ",userInfo=" + userInfo
				 + ",addressInfo=" + addressInfo + ",compAdmin=" + compAdmin + ",deptAdmin=" + deptAdmin + ",pAddressId=" + pAddressId
				 + ",pFolderId=" + pFolderId + ",pFolderType=" + pFolderType + ",primaryLang=" + primaryLang);
		
		return "ezAddress/addressRead";
	}
	
	/**
	 * 그룹주소록 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressWriteGroup.do", method = RequestMethod.GET)
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
		String mailMaxReceiverCount = ezCommonService.getTenantConfig("mailMaxReceiverCount", userInfo.getTenantId());
		String primaryLang = ezCommonService.getTenantConfig("PrimaryLang", userInfo.getTenantId());
		String useOrgListCheckBox = ezCommonService.getTenantConfig("useOrgListCheckBox", userInfo.getTenantId()); // 조직도 체크박스 사용여부
		useOrgListCheckBox = (useOrgListCheckBox != null && useOrgListCheckBox.equalsIgnoreCase("YES")) ? "true" : "false";
		
		if (mailMaxReceiverCount.equals("")) {
			mailMaxReceiverCount = "200";
		}
		
		if (ownerId.trim().equals("")) {
			if (folderId.equals("0")) {
				if (folderType.equals("C")) {
					ownerId = userInfo.getCompanyID();
				} else if (folderType.equals("D")) {
					ownerId = userInfo.getDeptID();
				} else {
					ownerId = userInfo.getId();
				}
			} else {
				AddressFolderVO folderInfo = ezAddressService.getFolderInfo(folderId);
				ownerId = folderInfo.getOwnerId();
			}
		} else { // 20190523 조진호 - 사용자가 url을 바꾸어 접근 한 경우 ownerId와 실제 사용자가 다르더라도 다른 사용자의 주소록에 등록이
					// 가능한 오류 수정
			if (folderType.equals("P") && !ownerId.equalsIgnoreCase(userInfo.getId())) {
				ownerId = userInfo.getId();
			} else if (folderType.equals("D") && !ownerId.equalsIgnoreCase(userInfo.getDeptID())) {
				ownerId = userInfo.getDeptID();
			} else if (folderType.equals("C") && !ownerId.equalsIgnoreCase(userInfo.getCompanyID())) {
				ownerId = userInfo.getCompanyID();
			}
		}
		
		model.addAttribute("addressId", addressId);
		model.addAttribute("folderId", folderId);
		model.addAttribute("ownerId", ownerId);
		model.addAttribute("folderType", folderType);
		model.addAttribute("changeKey", changeKey);
		model.addAttribute("userNM", userNM);
		model.addAttribute("userNM2", userNM2);
		model.addAttribute("useOcs", useOcs);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("mailMaxReceiverCount", mailMaxReceiverCount);
		model.addAttribute("primaryLang", primaryLang);
		model.addAttribute("useOrgListCheckBox", useOrgListCheckBox);
		
		String useShowAllCompanies = ezCommonService.getTenantConfig("useShowAllCompanies", userInfo.getTenantId());
		model.addAttribute("useShowAllCompanies", useShowAllCompanies);
		
		logger.debug("addressWriteGroup ended.");
		logger.debug("addressId=" + addressId + ",folderId=" + folderId + ",ownerId=" + ownerId + ",folderType=" + folderType
				 + ",changeKey=" + changeKey + ",userNM=" + userNM + ",userNM2=" + userNM2 + ",useOcs=" + useOcs
				 + ",userInfo=" + userInfo + ",mailMaxReceiverCount=" + mailMaxReceiverCount + ",useOrgListCheckBox=" + useOrgListCheckBox);
		
		return "ezAddress/addressWriteGroup";
	}
	
	/**
	 * 그룹주소록 추가/수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGroupSave.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressGroupSave(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {		
		logger.debug("addressGroupSave started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom == null){
				throw new Exception("xmldom is null");
			}
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
			
			if (addressId.equals("")) { //주소록 생성
				String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
				logger.debug("useAnyoneEdit="+ useAnyoneEdit);
				
				// UseAnyoneEdit이 YES가 아닐 경우 관리자인지 체크
				if (!useAnyoneEdit.equals("YES")) {
					if (folderType.equals("C")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
							return "NO_AUTHORITY";
						}
					} else if (folderType.equals("D")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
							return "NO_AUTHORITY";
						}
					}
				}
				
				ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(),
						sGroupName, sEmail, "", "", "", 
						"", "", "", "", 
						"", "", "", "", sMemo, sType, "");
			} else { //주소록 수정
				AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), addressId);
				
				if (!addressInfo.getCreatorId().equals(userInfo.getId()) && !addressInfo.getModifierId().equals(userInfo.getId())) { //작성자나 최종편집인이 아닐 경우
					//관리자인지 체크
					if (folderType.equals("C")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1)) {
							return "NO_AUTHORITY";
						}
					} else if (folderType.equals("D")) {
						if (!(userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1)) {
							return "NO_AUTHORITY";
						}
					}
				}
				
				ezAddressService.updateAddress(userInfo.getTenantId(), addressId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(), 
						sGroupName, sEmail, "", "", "", 
						"", "", "", "", 
						"", "", "", "", sMemo, "");
			}
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGroupSave ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 그룹주소록 상세보기 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressReadGroup.do", method = RequestMethod.GET)
	public String addressReadGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception {		
		logger.debug("addressReadGroup started.");
		logger.debug("type=" + request.getParameter("type") + ",addressid=" + request.getParameter("addressid"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String pFolderType = request.getParameter("type") == null ? "" : request.getParameter("type");
		String pAddressId = request.getParameter("addressid") == null ? "" : request.getParameter("addressid");
		String compAdmin = "";
		String deptAdmin = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		
		//baonk 추가 2018-08-08
		String use_cabinet = ezCommonService.getTenantConfig("useCabinet", userInfo.getTenantId());
		if (use_cabinet.equals("YES")) {
			use_cabinet = cabinetAdminService.checkModuleActive("addrs", userInfo);
		}
		
		if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
			compAdmin = "Y";
			deptAdmin = "Y";
		} else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
			deptAdmin = "Y";
		}
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
		
		AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);
		String address = addressInfo.getsMemo();
		
		List<String> listMember = new ArrayList<String>();
		int listMemberSize = 0;
		
        if (address != null && !address.trim().equals("")) {
	        	String[] addressArr = address.split(";");
	        	
	        	for (String addr : addressArr) {
	        		addr = EgovStringUtil.getSpclStrCnvr(addr).replaceAll("\"", "");
	        		listMember.add(addr);
	        	}
	        	
	        	listMemberSize = listMember.size();
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
		model.addAttribute("listMember", listMember);
		model.addAttribute("listMemberSize", listMemberSize);
		model.addAttribute("compAdmin", compAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("useCabinet", use_cabinet); // 캐비넷 추가 baonk 2018-08-08
		
		logger.debug("addressReadGroup ended.");
		logger.debug("pFolderType=" + pFolderType + ",pAddressId=" + pAddressId + ",userInfo=" + userInfo + ",addressInfo=" + addressInfo
				 + ",listMemberSize=" + listMemberSize + ",compAdmin=" + compAdmin + ",deptAdmin=" + deptAdmin
				 + ",useEditor=" + useEditor + ",noneActiveX=" + noneActiveX);
		
		return "ezAddress/addressReadGroup";
	}
	
	/**
	 * 주소록 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressDelete.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressDelete(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressDelete started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
	        Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
				NodeList ids = xmldom.getElementsByTagName("ID");

				String[] addressIds = new String[ids.getLength()];
				for (int i=0; i<ids.getLength(); i++) {
					addressIds[i] = ids.item(i).getTextContent();
				}

				ezAddressService.deleteAddress(addressIds);
			}
	    } catch (DOMException e) {
	        returnValue = "ERROR";
		} catch (Exception e) {
	        returnValue = "ERROR";
	    }
		
		logger.debug("addressDelete ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소록 이동/복사 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMoveCopy.do", method = RequestMethod.GET)
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
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
        
        StringBuilder rootAddressXML = new StringBuilder();
        
        Map<String, String> map = ezAddressService.getTopFolderSubCount(userInfo.getTenantId(), userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		
        String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "hassub=\"1\"";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "hassub=\"1\"";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "hassub=\"1\"";
			}
		}
        
        rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" %s nodelevel='Y'></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t145", locale), userInfo.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t146", locale), userInfo.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t147", locale), userInfo.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
		
        String browser = ClientUtil.getClientInfo(request, "browser");
		
		model.addAttribute("checkAdmin", checkAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("companyAdmin", companyAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
		model.addAttribute("rootAddressXML", rootAddressXML.toString());
		model.addAttribute("browser", browser);
		
		logger.debug("addressMoveCopy ended.");
		logger.debug("checkAdmin=" + checkAdmin + ",deptAdmin=" + deptAdmin + ",companyAdmin=" + companyAdmin);
		
		return "ezAddress/addressMoveCopy";
	}
	
	/**
	 * 주소록 이동/복사 저장 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressSaveMoveCopy.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressSaveMoveCopy(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressSaveMoveCopy started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue="OK";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
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
					ezAddressService.copyAddress(userInfo.getTenantId(), addressIds, folderId, ownerId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2());
				}
			}
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressSaveMoveCopy ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소록 환경설정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressConfig.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezAddress/addressSaveConfig.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressSaveConfig(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressSaveConfig started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");

			if (xmldom != null){
				LoginVO userInfo = commonUtil.userInfo(loginCookie);

				String pUserID = userInfo.getId();
				String pListCnt = xmldom.getElementsByTagName("LISTCNT").item(0).getTextContent();
				String pListType = xmldom.getElementsByTagName("LISTTYPE").item(0).getTextContent();

				ezAddressService.setAddressConfig(userInfo.getTenantId(), pUserID, pListCnt, pListType);
			}
		
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressSaveConfig ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	
	/**
	 * 그룹주소록 정보 호출 함수(그룹주소록 수정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetCurrentData.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetCurrentData(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetCurrentData started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
				// String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
				// String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
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
			}
			
		} catch (DOMException e) {
			returnValue = "<NewDataSet>" + e.getMessage() + "</NewDataSet>";
		} catch (Exception e) {
			returnValue = "<NewDataSet>" + e.getMessage() + "</NewDataSet>";
		}
		
		logger.debug("addressGetCurrentData ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 그룹주소록 정보 호출 함수 (그룹메일 쓰기)
	 */
	@RequestMapping(value = "/ezAddress/addressGetGroupEmail.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetGroupEmail(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetGroupEmail started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue="";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
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
			}
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGetGroupEmail ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	
	/**
	 * 그룹주소록 정보 호출 함수 (메일 쓰기)
	 */
	@RequestMapping(value = "/ezAddress/addressGetGroupEmailList.do", method = RequestMethod.GET, produces="text/xml; charset=utf-8")
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

		} catch (PatternSyntaxException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGetGroupEmailList ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 그룹주소 멤버 수 구하기
	 */
	@RequestMapping(value = "/ezAddress/getGroupAddressMemberCount.do", method = RequestMethod.GET, produces="text/plain; charset=utf-8")
	@ResponseBody
	public String getGroupAddressMemberCount(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request) throws Exception {		
		logger.debug("getGroupAddressMemberCount started.");
		logger.debug("itemId=" + request.getParameter("itemId"));
		logger.debug("folderPath=" + request.getParameter("folderPath"));
		
		int result = 0;
		
		try {
			String pAddressId = request.getParameter("id");
			
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			AddressVO addressInfo = ezAddressService.getAddressInfo(userInfo.getTenantId(), userInfo.getPrimary(), pAddressId);
			String address = addressInfo.getsMemo();
			
			if (address != null && !address.trim().equals("")) {
				String[] addressRows = address.split(";");
				result = addressRows.length;
			}

		} catch (PatternSyntaxException e) {
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("getGroupAddressMemberCount ended. result=" + result);
		return String.valueOf(result);
	}
	
	/**
	 * 주소함관리 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressFolderManage.do", method = RequestMethod.GET)
	public String addressFolderManage(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressFolderManage started. mode=" + request.getParameter("mode"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String companyAdmin = "";
		String deptAdmin = "";
		String noneActiveX = "YES";
		String show = "N";
		String title = egovMessageSource.getMessage("ezAddress.t144", locale);
		
		boolean gyumJikChk = true;

        /*
        if (userInfo.getGyumJik() != null) {
			if (userInfo.getGyumJik().indexOf(userInfo.getCompanyID()) != -1) {
				gyumJikChk = false;
			}
		}
         */
		
		if (gyumJikChk) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
				companyAdmin = "Y";
				deptAdmin = "Y";
			}
			else if (userInfo.getRollInfo().indexOf("g=1") > -1) {
				deptAdmin = "Y";
			}
		}
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
		
		if (request.getParameter("mode") != null) {
			show = "Y";
			title = egovMessageSource.getMessage("ezAddress.t319", locale);
		}
		
		StringBuilder rootAddressXML = new StringBuilder();
        
		Map<String, String> map = ezAddressService.getTopFolderSubCount(userInfo.getTenantId(), userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		
		String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "hassub=\"1\"";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "hassub=\"1\"";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "hassub=\"1\"";
			}
		}
		
        rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" %s nodelevel='Y'></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t145", locale), userInfo.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t146", locale), userInfo.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t147", locale), userInfo.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
		
		model.addAttribute("companyAdmin", companyAdmin);
		model.addAttribute("deptAdmin", deptAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
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
	 * 최상위 주소록 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/getRootAddressXML.do", method = RequestMethod.GET, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String getRootAddressXML(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale) throws Exception {		
		logger.debug("getRootAddressXML started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		StringBuilder rootAddressXML = new StringBuilder();
        
		Map<String, String> map = ezAddressService.getTopFolderSubCount(userInfo.getTenantId(), userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		
		String pHasSub = "";
		String dHasSub = "";
		String cHasSub = "";
		
		if (map != null) {
			if (map.get("P") != null && !map.get("P").equals("0")) {
				pHasSub = "hassub=\"1\"";
			}
			if (map.get("D") != null && !map.get("D").equals("0")) {
				dHasSub = "hassub=\"1\"";
			}
			if (map.get("C") != null && !map.get("C").equals("0")) {
				cHasSub = "hassub=\"1\"";
			}
		}
		
        rootAddressXML.append("<tree>");
		rootAddressXML.append("<nodes>");
        String xmlFormat = "<node imgidx=\"%s\" caption=\"%s\" ownerid=\"%s\" type=\"%s\" folderid=\"%s\" changekey=\"%s\" %s nodelevel='Y'></node>";
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t145", locale), userInfo.getId(), "P", "0", "", pHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t146", locale), userInfo.getDeptID(), "D", "0", "", dHasSub));
        rootAddressXML.append(String.format(xmlFormat, "1", egovMessageSource.getMessage("ezAddress.t147", locale), userInfo.getCompanyID(), "C", "0", "", cHasSub));
        rootAddressXML.append("</nodes>");
        rootAddressXML.append("</tree>");
        
        logger.debug("getRootAddressXML ended.");
        return rootAddressXML.toString();
	}
	
	/**
	 * 주소함 추가/수정 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressInputNameDlg.do", method = RequestMethod.GET)
	public String addressInputNameDlg(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		return "ezAddress/addressInputNameDlg";
	}
	
	/**
	 * 주소함 추가 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressAddFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressAddFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressAddFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
				String parentId = xmldom.getElementsByTagName("PARENTID").item(0).getTextContent();
				String folderName = xmldom.getElementsByTagName("NAME").item(0).getTextContent();
				String folderType = xmldom.getElementsByTagName("TYPE").item(0).getTextContent();
				String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();

				LoginVO userInfo = commonUtil.userInfo(loginCookie);

				ezAddressService.insertFolder(userInfo.getTenantId(), parentId, ownerId, folderType, folderName);
			}
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);	
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressAddFolder ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함 수정 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressModFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressModFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressModFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
				String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
				String folderName = xmldom.getElementsByTagName("FOLDERNAME").item(0).getTextContent();

				ezAddressService.updateFolder(folderId, folderName);
			}
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressModFolder ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressDelFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressDelFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressDelFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData);
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			
			ezAddressService.deleteFolder(folderId);
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressDelFolder ended. returnVaule=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소함 이동/복사 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMoveCopyFolder.do", method = RequestMethod.POST)
	@ResponseBody
	public String addressMoveCopyFolder(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressMoveCopyFolder started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "OK";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom != null){
				String cmd = xmldom.getElementsByTagName("CMD").item(0).getTextContent();
				String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
				String newParentId = xmldom.getElementsByTagName("NEWPARENTID").item(0).getTextContent();
				String newOwnerId = xmldom.getElementsByTagName("NEWOWNERID").item(0).getTextContent();
				String newFolderType = xmldom.getElementsByTagName("NEWFOLDERTYPE").item(0).getTextContent();

				LoginVO userInfo = commonUtil.userInfo(loginCookie);

				if (cmd.equals("MOVE")) {
					ezAddressService.moveFolder(userInfo.getTenantId(), folderId, newParentId, newOwnerId, newFolderType);
				} else if (cmd.equals("COPY")) {
					ezAddressService.copyFolder(userInfo.getTenantId(), folderId, newParentId, newOwnerId, newFolderType, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2());
				}
			}
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressMoveCopyFolder ended. returnValue=" + returnValue);
		
		return returnValue;
	}
	
	/**
	 * 주소록 검색 화면 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressMainSearch.do", method = RequestMethod.GET)
	public String addressMainSearch(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressMainSearch started.");
		logger.debug("orderby=" + request.getParameter("orderby") + ",filter=" + request.getParameter("filter"));
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String orderBy = "SNAME:0";
		String filter = "";
		String bAdmin = "";
		String cAdmin = "";
		String useEditor = ezCommonService.getTenantConfig("EDITOR", userInfo.getTenantId());
		String noneActiveX = "YES";
		String pListType = "";
		
		if (request.getParameter("orderby") != null && !request.getParameter("orderby").equals("")) {
			orderBy = request.getParameter("orderby");
		}
		
		if (request.getParameter("filter") != null) {
			filter = request.getParameter("filter");
		}
		
		boolean gyumJikChk = true;
		/*
        if (userInfo.getGyumJik() != null) {
			if (userInfo.getGyumJik().indexOf(userInfo.getCompanyID()) != -1) {
				gyumJikChk = false;
			}
		}
		 */
		
		if (gyumJikChk) {
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1 || userInfo.getRollInfo().indexOf("g=1") > -1) {
				bAdmin = "Y";
			}
			if (userInfo.getRollInfo().indexOf("c=1") > -1 || userInfo.getRollInfo().indexOf("k=1") > -1) {
				cAdmin = "Y";
			}
		}
		
		String useAnyoneEdit = ezCommonService.getTenantConfig("UseAnyoneEdit", userInfo.getTenantId());
		
        pListType = ezAddressService.getListType(userInfo.getTenantId(), userInfo.getId());
        if (pListType == null) {
			pListType = "card";
		}
        
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("orderBy", orderBy);
		model.addAttribute("filter", filter);
		model.addAttribute("bAdmin", bAdmin);
		model.addAttribute("cAdmin", cAdmin);
		model.addAttribute("useAnyoneEdit", useAnyoneEdit);
		model.addAttribute("useEditor", useEditor);
		model.addAttribute("noneActiveX", noneActiveX);
		model.addAttribute("pListType", pListType);
		
		logger.debug("addressMainSearch ended.");
		logger.debug("userInfo=" + userInfo + ",orderBy=" + orderBy + ",filter=" + filter + ",bAdmin=" + bAdmin
				 + ",cAdmin=" + cAdmin + ",useEditor=" + useEditor + ",noneActiveX=" + noneActiveX
				 + ",pListType=" + pListType);
		
		return "ezAddress/addressMainSearch";
	}
	
	/**
	 * 주소록 리스트 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetSearchList.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetSearchList(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Model model) throws Exception {		
		logger.debug("addressGetSearchList started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String strListPageSize = ezAddressService.getListCnt(userInfo.getTenantId(), userInfo.getId());
			if (strListPageSize == null || strListPageSize.trim().equals("")) {
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


			String addressType = xmldom.getElementsByTagName("ADDRTYPE").item(0) != null ? 
					StringUtils.defaultIfBlank(xmldom.getElementsByTagName("ADDRTYPE").item(0).getTextContent(), "ALL") : "ALL"; // ALL||GROUP||PERSONAL
			String pOrderOption = "";
			String pFilter = "";
			String strCurrentPage = "";
			
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

			int pFolderMaxCount = ezAddressService.getSearchCount(userInfo.getTenantId(), pIdLists, pFilter, addressType);
			List<AddressVO> addressList = ezAddressService.getSearchList(userInfo.getTenantId(), pIdLists, pOrderOption, pFilter, pListPageSize, start, addressType);
			
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

				String sType = vo.getsType();
				String sEmail = sType.equals("G") ? egovMessageSource.getMessage("ezBoard.t18", userInfo.getLocale()) : commonUtil.cleanValue(vo.getsEmail());

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
				sb.append("<SEMAIL>" + sEmail + "</SEMAIL>");
				sb.append("<STYPE>" + sType + "</STYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGetSearchList ended.");
		
		return returnValue;
	}
	
	/**
	 * root 주소함 정보 호출 함수
	 */
	@RequestMapping(value = "/ezAddress/addressGetFullTree.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetFullTree(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressGetFullTree started.");
		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Map<String, String> map = ezAddressService.getTopFolderSubCount(userInfo.getTenantId(), userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
			
			String pHasSub = "0";
			String dHasSub = "0";
			String cHasSub = "0";
			
			if (map != null) {
				if (map.get("P") != null && !map.get("P").equals("0")) {
					pHasSub = "1";
				}
				if (map.get("D") != null && !map.get("D").equals("0")) {
					dHasSub = "1";
				}
				if (map.get("C") != null && !map.get("C").equals("0")) {
					cHasSub = "1";
				}
			}
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			sb.append("<ROW>");
			sb.append("<FOLDERTYPE>P</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + egovMessageSource.getMessage("ezAddress.t145", locale) + "</FOLDERNAME>");
			sb.append("<FOLDERID><![CDATA[0]]></FOLDERID>");
			sb.append("<CHANGEKEY><![CDATA[]]></CHANGEKEY>");
			sb.append("<OWNERID><![CDATA[" + userInfo.getId() + "]]></OWNERID>");
			sb.append("<CHILDCOUNT><![CDATA[" + pHasSub + "]]></CHILDCOUNT>");
			sb.append("<PARENTFOLDERID><![CDATA[]]></PARENTFOLDERID>");
			sb.append("</ROW>");
			
			sb.append("<ROW>");
			sb.append("<FOLDERTYPE>D</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + egovMessageSource.getMessage("ezAddress.t146", locale) + "</FOLDERNAME>");
			sb.append("<FOLDERID><![CDATA[0]]></FOLDERID>");
			sb.append("<CHANGEKEY><![CDATA[]]></CHANGEKEY>");
			sb.append("<OWNERID><![CDATA[" + userInfo.getDeptID() + "]]></OWNERID>");
			sb.append("<CHILDCOUNT><![CDATA[" + dHasSub + "]]></CHILDCOUNT>");
			sb.append("<PARENTFOLDERID><![CDATA[]]></PARENTFOLDERID>");
			sb.append("</ROW>");
			
			sb.append("<ROW>");
			sb.append("<FOLDERTYPE>C</FOLDERTYPE>");
			sb.append("<FOLDERNAME>" + egovMessageSource.getMessage("ezAddress.t147", locale) + "</FOLDERNAME>");
			sb.append("<FOLDERID><![CDATA[0]]></FOLDERID>");
			sb.append("<CHANGEKEY><![CDATA[]]></CHANGEKEY>");
			sb.append("<OWNERID><![CDATA[" + userInfo.getCompanyID() + "]]></OWNERID>");
			sb.append("<CHILDCOUNT><![CDATA[" + cHasSub + "]]></CHILDCOUNT>");
			sb.append("<PARENTFOLDERID><![CDATA[]]></PARENTFOLDERID>");
			sb.append("</ROW>");
			
			sb.append("</DATA>");
			
			returnValue = sb.toString();
			
		} catch (NullPointerException e) {
			returnValue = "<DATA>" + e.getMessage() + "</DATA>";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "<DATA>" + e.getMessage() + "</DATA>";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGetFullTree ended.");
		
		return returnValue;
		
	}
	
	/**
	 * 주소록 정보 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressGetListMailCall.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetListMailCall(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {		
		logger.debug("addressGetListMailCall started.");
		logger.debug("bodyData=" + bodyData);
		
		String returnValue = "";
		
		try {
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom == null){
				throw new Exception("xmldom is null");
			}
			String folderId = xmldom.getElementsByTagName("FOLDERID").item(0).getTextContent();
			String ownerId = xmldom.getElementsByTagName("OWNERID").item(0).getTextContent();
			// String field = xmldom.getElementsByTagName("FIELD").item(0).getTextContent();
			int pageSize = Integer.parseInt(xmldom.getElementsByTagName("PAGESIZE").item(0).getTextContent());
			// String filter = xmldom.getElementsByTagName("FILTER").item(0).getTextContent();
			int currentPage = Integer.parseInt(xmldom.getElementsByTagName("PAGE").item(0).getTextContent());
			String searchGubun = xmldom.getElementsByTagName("SEARCHGUBUN").item(0).getTextContent();
			String folderType = xmldom.getElementsByTagName("FOLDERTYPE").item(0).getTextContent();
			
			String orderBy = "S_NAME:0";
			
			List<AddressVO> addressList = null;
			int totalCount = 0;

			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			if (searchGubun.equals("Y")) {
				//TODO: Y로 올 경우가 없는 것 같음.
				// 여기로 넘어오는지 테스트해보고 안넘어오면 지우기. 넘어오면 코딩하기.
				logger.error("searchGubun=Y. Need more code. Location:EzAddressController 1367");
			} else {
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
			
			if (addressList != null) {
				for (AddressVO addressInfo : addressList) {
					String sType = addressInfo.getsType();
					String sEmail = sType.equals("G") ? egovMessageSource.getMessage("ezBoard.t18", userInfo.getLocale()) : commonUtil.cleanValue(addressInfo.getsEmail());
					
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
					sb.append("<SEMAIL>" + sEmail + "</SEMAIL>");
					sb.append("<STYPE>" + sType + "</STYPE>");
					sb.append("<FOLDERTYPE>" + folderType + "</FOLDERTYPE>");
					sb.append("</ROW>");
				}
			}
			
			sb.append("</DATA>");
			sb.append("</RTNDATA>");
			
			returnValue = sb.toString();
			
		} catch (DOMException e) {
			returnValue = "<DATA>" + e.getMessage() + "</DATA>";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "<DATA>" + e.getMessage() + "</DATA>";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGetListMailCall ended.");
		
		return returnValue;
	}
	
	/**
	 * 주소록 구성원 보기 및 선택 화면 호출 함수 (수신자 설정)
	 */
	@RequestMapping(value = "/ezAddress/addressSelectGroupMailList.do", method = RequestMethod.GET)
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
	@RequestMapping(value = "/ezAddress/addressGetListMailSearchCall.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
	@ResponseBody
	public String addressGetListMailSearchCall(@CookieValue("loginCookie") String loginCookie, @RequestBody String bodyData, Locale locale, Model model) throws Exception {		
		logger.debug("addressGetListMailSearchCall started.");
		
		String returnValue = "";
		
		try {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			Document xmldom = commonUtil.convertStringToDocument(bodyData != null ? bodyData : "");
			if (xmldom == null){
				throw new Exception("xmldom is null");
			}
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
				String sType = addressInfo.getsType();
				String sEmail = sType.equals("G") ? egovMessageSource.getMessage("ezBoard.t18", userInfo.getLocale()) : commonUtil.cleanValue(addressInfo.getsEmail());
				
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
				sb.append("<SEMAIL>" + sEmail + "</SEMAIL>");
				sb.append("<STYPE>" + sType + "</STYPE>");
				sb.append("<FOLDERTYPE>" + pFolderType + "</FOLDERTYPE>");
				sb.append("</ROW>");
			}
			
			sb.append("</DATA>");
			sb.append("</RTNDATA>");
			
			returnValue = sb.toString();
			
		} catch (DOMException e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		} catch (Exception e) {
			returnValue = "ERROR";
			logger.error(e.getMessage(), e);
		}
		
		logger.debug("addressGetListMailSearchCall ended.");
		
		return returnValue;
	}
	
	/**
	 * 주소록 내보내기 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/excelExport.do", method = RequestMethod.GET)
	@ResponseBody
	public void addressExport(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model, HttpServletResponse response) throws Exception {		
		logger.debug("addressExport started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		
		String folderId = request.getParameter("folderid");
		String folderType = request.getParameter("foldertype");
		String ownerId = request.getParameter("ownerid");
		String format = request.getParameter("format");
		
        logger.debug("folderId=" + folderId + ",folderType=" + folderType + ",ownerId=" + ownerId + ",format=" + format);
        
        String fileName = null;
        
		switch (format) {
			case "outlookCSV" :
				fileName = "outlook.csv";
				break;
			case "thunderbirdCSV" :
				fileName = "thunderbird.csv";
				break;
			case "googleCSV" :
				fileName = "google.csv";
				break;
			default : 
				format = "outlookCSV";
				fileName = "outlook.csv";
				break;
		}
		
		response.setContentType("application/x-msexcel; charset=utf-8");
		String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"%s\"", fileName);
        response.setHeader(headerKey, headerValue);
		
        OutputStreamWriter writer = null;
		CSVWriter csvWriter = null;
		
		try {
//			String charset = "euc-kr";
//			
//			if (userInfo.getLang().equals("3")) {
//				charset = "shift-jis";
//			}
//			
//			if (format.equals("googleCSV")) {
//				charset = "utf-8";
//			}
//			
//			logger.debug("charset=" + charset);
			
			writer = new OutputStreamWriter(response.getOutputStream(), "UTF-8");
			writer.write('\uFEFF');
			csvWriter = new CSVWriter(writer, CSVWriter.DEFAULT_SEPARATOR, CSVWriter.DEFAULT_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, "\r\n");
			
	        String[] headerArray = egovMessageSource.getMessage("ezAddress." + format, locale).split(";");
	        int headerLength = headerArray.length;
	        
	        csvWriter.writeNext(headerArray);
	        csvWriter.flush();
	        
	        List<AddressVO> addressList = ezAddressService.getAllAddressList(userInfo.getTenantId(), folderId, ownerId, "", null);
	        
	        for (AddressVO address : addressList) {
	        	String[] valueArray = new String[headerLength];
	        	Arrays.fill(valueArray, "");
	        	
	        	if (format.equals("outlookCSV")) {
	        		valueArray[1] = address.getsName();
		        	valueArray[5] = address.getsCompany();
		        	valueArray[6] = address.getsDept();
		        	valueArray[7] = address.getsTitle();
		        	valueArray[31] = address.getsCompanyPhone();
		        	valueArray[30] = address.getsFax();
		        	valueArray[40] = address.getsMobile();
		        	valueArray[77] = address.getsEmail();
		        	valueArray[79] = address.getsName();
		        	valueArray[74] = address.getsHomePage();
		        	valueArray[13] = address.getsCompanyZip();
		        	valueArray[8] = address.getsCompanyAddr();
		        	valueArray[20] = address.getsHomeZip();
		        	valueArray[15] = address.getsHomeAddr();
		        	valueArray[58] = address.getsMemo();
	        	} else if (format.equals("thunderbirdCSV")) {
	        		valueArray[0] = address.getsName();
	        		valueArray[2] = address.getsName();
		        	valueArray[26] = address.getsCompany();
		        	valueArray[25] = address.getsDept();
		        	valueArray[24] = address.getsTitle();
		        	valueArray[7] = address.getsCompanyPhone();
		        	valueArray[9] = address.getsFax();
		        	valueArray[11] = address.getsMobile();
		        	valueArray[4] = address.getsEmail();
		        	valueArray[27] = address.getsHomePage();
		        	valueArray[22] = address.getsCompanyZip();
		        	valueArray[18] = address.getsCompanyAddr();
		        	valueArray[16] = address.getsHomeZip();
		        	valueArray[12] = address.getsHomeAddr();
		        	valueArray[36] = address.getsMemo();
	        	} else if (format.equals("googleCSV")) {
	        		valueArray[0] = address.getsName();
		        	valueArray[43] = address.getsCompany();
		        	valueArray[46] = address.getsDept();
		        	valueArray[45] = address.getsTitle();
		        	valueArray[32] = address.getsMobile();
		        	valueArray[30] = address.getsEmail();
		        	valueArray[51] = address.getsHomePage();
		        	valueArray[34] = address.getsHomeAddr();
		        	valueArray[25] = address.getsMemo();
	        	}
	        	
	        	csvWriter.writeNext(valueArray);
		        csvWriter.flush();
	        }
	        
		} catch(IOException e) {
			logger.error(e.getMessage(), e);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (csvWriter != null) {
				try {
					csvWriter.close();
				} catch(IOException e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (writer != null) {
				writer.close();
			}
		}
	    
		logger.debug("addressExport ended.");
	}
	
	/**
	 * 주소록 가져오기 중복체크 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/excelImportDuplicationCheck.do", method = RequestMethod.POST)
	@SuppressWarnings("unchecked")
	public String excelImportDuplicationCheck(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Locale locale, Model model) throws Exception {
		logger.debug("excelImportDuplicationCheck started.");
		
		String result = "OK";
		String folderId = request.getParameter("folderid");
        String folderType = request.getParameter("foldertype");
        String ownerId = request.getParameter("ownerid");
        String format = request.getParameter("format");
        logger.debug("folderId={}, folderType={}, ownerId={}, format={}", folderId, folderType, ownerId, format);

        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantId = userInfo.getTenantId();
        
		List<MultipartFile> multiFile = request.getFiles("file1");
		
        if (multiFile == null || multiFile.get(0) == null) {
        	logger.error("cannot find file.");
        	model.addAttribute("result", "ERROR");
            return "ezAddress/addressImportDuplicationCheckComplete";
        }
        
        if (!format.equals("outlookCSV") && !format.equals("thunderbirdCSV") && !format.equals("googleCSV")) {
        	format = "outlookCSV";
        }
        
        String[] headerArray = egovMessageSource.getMessage("ezAddress." + format, locale).split(";");
        String[] usedHeaderArray = null;
        
        if (format.equals("outlookCSV")) {
        	usedHeaderArray = new String[]{
    			// name, lastName, company, dept, title
        		headerArray[1], headerArray[3], headerArray[5], headerArray[6], headerArray[7], headerArray[31],
        		// fax, mobile, email, homePage, companyZip
        		headerArray[30], headerArray[40], headerArray[77], headerArray[74], headerArray[13],
        		// companyAddr, homeZip, homeAddr, memo
        		headerArray[8], headerArray[20], headerArray[15], headerArray[58]     
        	};
        } else if (format.equals("thunderbirdCSV")) {
        	usedHeaderArray = new String[]{
        		headerArray[0], headerArray[1], headerArray[26], headerArray[25], headerArray[24],       
        		headerArray[7], headerArray[9], headerArray[11], headerArray[4],  headerArray[27], headerArray[22],  
        		headerArray[18], headerArray[16], headerArray[12], headerArray[36]       
        	};
    	} else if (format.equals("googleCSV")) {
    		usedHeaderArray = new String[]{
        		headerArray[0], "", headerArray[43], headerArray[46], headerArray[45], 
        		"", "", headerArray[32], headerArray[30], headerArray[51],    
        		"", "", "", headerArray[34], headerArray[25]   
        	};
    	}
        
        InputStream stream = null;
        InputStreamReader reader = null;
        CSVReader csvReader = null;
        List<String[]> csvList = null;
        
        try {
	        stream = multiFile.get(0).getInputStream();
	        
	        String charset = (userInfo.getLang().equals("3")) ? "shift-jis" : (format.equals("googleCSV") || format.equals("outlookCSV")) ? "utf-8" : "euc-kr";
			logger.debug("charset=" + charset);
			
	        reader = new InputStreamReader(stream, charset);
	        csvReader = new CSVReader(reader);
	        csvList = csvReader.readAll();
        } catch (IOException e) {
        	logger.error(e.getMessage());
        	logger.error(e.getMessage(), e);
        } finally {
        	if (csvReader != null) {
        		try {
        			csvReader.close();
        		} catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
        	}
        	
        	if (reader != null) {
        		try {
        			reader.close();
        		} catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
        	}
        	
        	if (stream != null) {
        		try {
        			stream.close();
        		} catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
        	}
		}
        
        if (csvList == null || csvList.get(0) == null || csvList.get(0).length == 0) {
        	logger.error("Check CSV file format.");
        	model.addAttribute("result", "ERROR");
        	
            return "ezAddress/addressImportDuplicationCheckComplete";
        }

        String groupMailStr = egovMessageSource.getMessage("ezAddress.t180", locale);
        String[] csvHeader = csvList.get(0);
        String[] csvBody = null;
        Map<String, String> csvBodyMap = null;
        
        // CSV 헤더에 필수 헤더들이 들어있는지 확인 (구글CSV 제외 - 구글CSV는 값을 입력하지 않은 필드의 경우 헤더가 없을 수 있음)
        if (!format.equals("googleCSV") && !Arrays.asList(csvHeader).containsAll(Arrays.asList(usedHeaderArray))) {
        	logger.error("Check CSV file format.");
        	model.addAttribute("result", "FORMAT_ERROR");
        	
            return "ezAddress/addressImportDuplicationCheckComplete";
        }

        // 기존 주소록 목록
    	List<AddressVO> originalAddr = ezAddressService.getAddressList(tenantId, folderId, ownerId, "", "", 0, 1);
    	JSONArray duplicateAddr = new JSONArray();
    	
        for (int i = 1; i < csvList.size(); i++) {
        	try {
        		csvBody = csvList.get(i);
        		csvBodyMap = new HashMap<String, String>();
        		
	        	for (int j = 0; j < csvBody.length; j++) {
	        		csvBodyMap.put(csvHeader[j], csvBody[j]);
	        	}
	        	
	        	csvBody = new String[usedHeaderArray.length];
	        	Arrays.fill(csvBody, "");
	        	
	        	for (int j = 0; j < usedHeaderArray.length; j++) {
	        		if (csvBodyMap.get(usedHeaderArray[j]) != null) {
	        			csvBody[j] = csvBodyMap.get(usedHeaderArray[j]);
	            	}
	        	}
	        	
	        	// 영어권이 아니면 이름 필드에 성+이름, 영어권이면 이름만
	        	if (!userInfo.getLang().equals("2")) {
	        		csvBody[0] = csvBody[1] + " " + csvBody[0];
	        		csvBody[0] = csvBody[0].trim();
	        	}
	        	
	        	String sName = csvBody[0];
	        	if (sName.contains("\'") || sName.contains("<") || sName.contains(">") || sName.contains("\"") || sName.contains("&") || sName.contains(";")) {
	        		sName = csvBody[0].replaceAll("\'", "").replaceAll("<", "").replaceAll(">", "").replaceAll("\"", "").replaceAll("&", "").replaceAll(";", "");

    			}
	    		
	        	// 기존 주소록에 등록된 이메일과 동일한 경우 체크
	        	String newAddrEmail = csvBody[8];
	        	if (newAddrEmail != null && !"".equals(newAddrEmail.trim()) && !newAddrEmail.equals(groupMailStr)) {
	        		for (AddressVO vo : originalAddr) {
		        		if (newAddrEmail.equalsIgnoreCase(vo.getsEmail())) {
		    	        	JSONObject oriAddr = new JSONObject();
		    	        	oriAddr.put("name", vo.getsName());
		    	        	oriAddr.put("email", vo.getsEmail());
		    	        	
		    	        	JSONObject newAddr = new JSONObject();
		    	        	newAddr.put("name", sName);
		    	        	newAddr.put("email", csvBody[8]);
		    	        	
		    	        	JSONObject obj = new JSONObject();
		            		obj.put("oriAddr", oriAddr);
		            		obj.put("newAddr", newAddr);
		            		duplicateAddr.add(obj);
		        		}
		        	}
	        	} // if END
        	} catch (PatternSyntaxException e) {
        		result = "ERROR";
        		logger.error("Import address fail. CSV " + i + "th line.");
        		
        		try {
	        		csvHeader = csvList.get(0);
	        		csvBody = csvList.get(i);
	        		
	        		if (csvHeader != null) {
	        			String csvHeaderStr = "";
	        			
	        			for (int j = 0; j < csvHeader.length; j++) {
	        				csvHeaderStr += csvHeader[j] + ", ";
	            		}
	        			
	        			logger.error("header line=" + csvHeaderStr);
	        		} else {
	        			logger.error("header line is null.");
	        		}
	        		
	        		if (csvBody != null) {
	        			String csvBodyStr = "";
	        			
	        			for (int j=0; j<csvBody.length; j++) {
	        				csvBodyStr += csvBody[j] + ", ";
	            		}
	        			
	        			logger.error(i + "th line=" + csvBodyStr);
	        		} else {
	        			logger.error(i + "th line is null.");
	        		}
        		} catch (IndexOutOfBoundsException ex) {logger.debug("e.message=" + ex.getMessage());
        		} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
        		
        		logger.error(e.getMessage(), e);
			} catch (Exception e) {
        		result = "ERROR";
        		logger.error("Import address fail. CSV " + i + "th line.");
        		
        		try {
	        		csvHeader = csvList.get(0);
	        		csvBody = csvList.get(i);
	        		
	        		if (csvHeader != null) {
	        			String csvHeaderStr = "";
	        			
	        			for (int j = 0; j < csvHeader.length; j++) {
	        				csvHeaderStr += csvHeader[j] + ", ";
	            		}
	        			
	        			logger.error("header line=" + csvHeaderStr);
	        		} else {
	        			logger.error("header line is null.");
	        		}
	        		
	        		if (csvBody != null) {
	        			String csvBodyStr = "";
	        			
	        			for (int j=0; j<csvBody.length; j++) {
	        				csvBodyStr += csvBody[j] + ", ";
	            		}
	        			
	        			logger.error(i + "th line=" + csvBodyStr);
	        		} else {
	        			logger.error(i + "th line is null.");
	        		}
        		} catch (IndexOutOfBoundsException ex) {logger.debug("e.message=" + ex.getMessage());
        		} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
        		
        		logger.error(e.getMessage(), e);
        	}
        }
        
        String state = "OK";
        if ("OK".equals(result) && duplicateAddr.size() > 0) {
        	state = "DUPLICATE";
        }
        
        model.addAttribute("result", result);
        model.addAttribute("state", state);
        model.addAttribute("duplicateAddr", duplicateAddr);
        
        logger.debug("excelImportDuplicationCheck ended.");
        return "ezAddress/addressImportDuplicationCheckComplete";
	}
	
	/**
	 * 주소록 가져오기 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/excelImport.do", method = RequestMethod.POST)
	public String addressImport(@CookieValue("loginCookie") String loginCookie, MultipartHttpServletRequest request, Locale locale, Model model) throws Exception {		
		logger.debug("addressImport started.");
		
		String result = "OK";
		String folderId = request.getParameter("folderid");
        String folderType = request.getParameter("foldertype");
        String ownerId = request.getParameter("ownerid");
        String format = request.getParameter("format");
		
        logger.debug("folderId=" + folderId + ",folderType=" + folderType + ",ownerId=" + ownerId + ",format=" + format);
        
		List<MultipartFile> multiFile = request.getFiles("file1");
		
        if (multiFile == null || multiFile.get(0) == null) {
        	logger.error("cannot find file.");
        	model.addAttribute("result", "ERROR");
            return "ezAddress/addressImportComplete";
        }
        
        LoginVO userInfo = commonUtil.userInfo(loginCookie);
        int tenantId = userInfo.getTenantId();

		String useAddrDupliCheck = ezCommonService.getTenantConfig("useAddrDupliCheck", tenantId);
        
        if (!format.equals("outlookCSV") && !format.equals("thunderbirdCSV") && !format.equals("googleCSV")) {
        	format = "outlookCSV";
        }
        
        String[] headerArray = egovMessageSource.getMessage("ezAddress." + format, locale).split(";");
        String[] usedHeaderArray = null;
        
        if (format.equals("outlookCSV")) {
        	usedHeaderArray = new String[]{
        		headerArray[1],  //name        
        		headerArray[3],  //lastName    
        		headerArray[5],  //company     
        		headerArray[6],  //dept        
        		headerArray[7],  //title       
        		headerArray[31], //companyPhone
        		headerArray[30], //fax         
        		headerArray[40], //mobile      
        		headerArray[77], //email       
        		headerArray[74], //homePage    
        		headerArray[13], //companyZip  
        		headerArray[8],  //companyAddr 
        		headerArray[20], //homeZip     
        		headerArray[15], //homeAddr    
        		headerArray[58]  //memo        
        	};
        } else if (format.equals("thunderbirdCSV")) {
        	usedHeaderArray = new String[]{
        		headerArray[0],  //name        
        		headerArray[1],  //lastName    
        		headerArray[26], //company     
        		headerArray[25], //dept        
        		headerArray[24], //title       
        		headerArray[7],  //companyPhone
        		headerArray[9],  //fax         
        		headerArray[11], //mobile      
        		headerArray[4],  //email       
        		headerArray[27], //homePage    
        		headerArray[22], //companyZip  
        		headerArray[18], //companyAddr 
        		headerArray[16], //homeZip     
        		headerArray[12], //homeAddr    
        		headerArray[36]  //memo        
        	};
    	} else if (format.equals("googleCSV")) {
    		usedHeaderArray = new String[]{
        		headerArray[0],  //name        
        		"",              //lastName    
        		headerArray[43], //company     
        		headerArray[46], //dept        
        		headerArray[45], //title       
        		"",              //companyPhone
        		"",              //fax         
        		headerArray[32], //mobile      
        		headerArray[30], //email       
        		headerArray[51], //homePage    
        		"",              //companyZip  
        		"",              //companyAddr 
        		"",              //homeZip     
        		headerArray[34], //homeAddr    
        		headerArray[25]  //memo        
        	};
    	}
        
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
			
			if (format.equals("googleCSV") || format.equals("outlookCSV")) {
				charset = "utf-8";
			}
			
			logger.debug("charset=" + charset);
			
	        reader = new InputStreamReader(stream, charset);
	        csvReader = new CSVReader(reader);
	        csvList = csvReader.readAll();
	        
	        
        } catch (IOException e) {
        	logger.error(e.getMessage());
        	logger.error(e.getMessage(), e);
        } finally {
        	if (csvReader != null) {
        		try {
        			csvReader.close();
        		} catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
        	}
        	
        	if (reader != null) {
        		try {
        			reader.close();
        		} catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
        	}
        	
        	if (stream != null) {
        		try {
        			stream.close();
        		} catch (IOException e) {logger.debug("e.message=" + e.getMessage());}
        	}
		}
        
        if (csvList == null || csvList.get(0) == null || csvList.get(0).length == 0) {
        	logger.error("Check CSV file format.");
        	model.addAttribute("result", "ERROR");
        	
            return "ezAddress/addressImportComplete";
        }
        
        String groupMailStr = egovMessageSource.getMessage("ezAddress.t180", locale);
        String[] csvHeader = csvList.get(0);
        String[] csvBody = null;
        Map<String, String> csvBodyMap = null;
        
        // CSV 헤더에 필수 헤더들이 들어있는지 확인 (구글CSV 제외 - 구글CSV는 값을 입력하지 않은 필드의 경우 헤더가 없을 수 있음)
        if (!format.equals("googleCSV") && !Arrays.asList(csvHeader).containsAll(Arrays.asList(usedHeaderArray))) {
        	logger.error("Check CSV file format.");
        	model.addAttribute("result", "FORMAT_ERROR");
        	
            return "ezAddress/addressImportComplete";
        }

        // 기존 주소록 목록
    	List<AddressVO> originalAddr = ezAddressService.getAddressList(tenantId, folderId, ownerId, "", "", 0, 1);
    	
        loop1:
        for (int i = 1; i < csvList.size(); i++) {
        	try {
        		csvBody = csvList.get(i);
        		csvBodyMap = new HashMap<String, String>();
        		
	        	for (int j = 0; j < csvBody.length; j++) {
	        		csvBodyMap.put(csvHeader[j], csvBody[j]);
	        	}
	        	
	        	csvBody = new String[usedHeaderArray.length];
	        	Arrays.fill(csvBody, "");
	        	
	        	for (int j = 0; j < usedHeaderArray.length; j++) {
	        		if (csvBodyMap.get(usedHeaderArray[j]) != null) {
	        			csvBody[j] = csvBodyMap.get(usedHeaderArray[j]);
	            	}
	        	}
	        	
	        	// 영어권이 아니면 이름 필드에 성+이름, 영어권이면 이름만
	        	if (!userInfo.getLang().equals("2")) {
	        		csvBody[0] = csvBody[1] + " " + csvBody[0];
	        		csvBody[0] = csvBody[0].trim();
	        	}
	        	
	        	// 가져오기 시 메모에 줄바꿈이 있을 경우 치환
	        	/*if (csvBody[14].contains("\n")) {
	        		csvBody[14] = csvBody[14].replaceAll("\n", "<br>");
	        	}*/
	        	
	        	String sName = csvBody[0];
	        	if (sName.contains("\'") || sName.contains("<") || sName.contains(">") || sName.contains("\"") || sName.contains("&") || sName.contains(";")) {
	        		sName = csvBody[0].replaceAll("\'", "").replaceAll("<", "").replaceAll(">", "").replaceAll("\"", "").replaceAll("&", "").replaceAll(";", "");

    			}
	        	
	        	// 기존 주소록에 등록된 이메일과 동일한 경우 체크
	        	if ("YES".equalsIgnoreCase(useAddrDupliCheck)) {
	        		String newAddrEmail = csvBody[8];
		        	if (newAddrEmail != null && !"".equals(newAddrEmail.trim()) && !newAddrEmail.equals(groupMailStr)) {
		        		for (AddressVO vo : originalAddr) {
			        		if (newAddrEmail.equalsIgnoreCase(vo.getsEmail())) {
			    	        	continue loop1;
			        		}
		        		} // for END
		        	}
	        	}
	        	
        		if (csvBody[8].equals(groupMailStr)) {
        			ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), userInfo.getDisplayName1(), userInfo.getDisplayName2(),
        					sName, csvBody[8], csvBody[2], csvBody[3], csvBody[4], 
        					csvBody[5], csvBody[6], csvBody[7], csvBody[9], 
        					csvBody[10], csvBody[11], csvBody[12], csvBody[13], csvBody[14], "G", "");
        		} else {
        			ezAddressService.insertAddress(userInfo.getTenantId(), ownerId, folderId, userInfo.getId(), userInfo.getDisplayName(), userInfo.getDisplayName2(),
        					sName, csvBody[8], csvBody[2], csvBody[3], csvBody[4], 
        					csvBody[5], csvBody[6], csvBody[7], csvBody[9], 
        					csvBody[10], csvBody[11], csvBody[12], csvBody[13], csvBody[14], "P", "");
        		}
        	} catch (IndexOutOfBoundsException e) {
        		result = "ERROR";
        		logger.error("Import address fail. CSV " + i + "th line.");
        		
        		try {
	        		csvHeader = csvList.get(0);
	        		csvBody = csvList.get(i);
	        		
	        		if (csvHeader != null) {
	        			String csvHeaderStr = "";
	        			
	        			for (int j = 0; j < csvHeader.length; j++) {
	        				csvHeaderStr += csvHeader[j] + ", ";
	            		}
	        			
	        			logger.error("header line=" + csvHeaderStr);
	        		} else {
	        			logger.error("header line is null.");
	        		}
	        		
	        		if (csvBody != null) {
	        			String csvBodyStr = "";
	        			
	        			for (int j=0; j<csvBody.length; j++) {
	        				csvBodyStr += csvBody[j] + ", ";
	            		}
	        			
	        			logger.error(i + "th line=" + csvBodyStr);
	        		} else {
	        			logger.error(i + "th line is null.");
	        		}
        		} catch (IndexOutOfBoundsException ex) {logger.debug("e.message=" + ex.getMessage());
        		} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
        		
        		logger.error(e.getMessage(), e);
			} catch (Exception e) {
        		result = "ERROR";
        		logger.error("Import address fail. CSV " + i + "th line.");
        		
        		try {
	        		csvHeader = csvList.get(0);
	        		csvBody = csvList.get(i);
	        		
	        		if (csvHeader != null) {
	        			String csvHeaderStr = "";
	        			
	        			for (int j = 0; j < csvHeader.length; j++) {
	        				csvHeaderStr += csvHeader[j] + ", ";
	            		}
	        			
	        			logger.error("header line=" + csvHeaderStr);
	        		} else {
	        			logger.error("header line is null.");
	        		}
	        		
	        		if (csvBody != null) {
	        			String csvBodyStr = "";
	        			
	        			for (int j=0; j<csvBody.length; j++) {
	        				csvBodyStr += csvBody[j] + ", ";
	            		}
	        			
	        			logger.error(i + "th line=" + csvBodyStr);
	        		} else {
	        			logger.error(i + "th line is null.");
	        		}
        		} catch (IndexOutOfBoundsException ex) {logger.debug("e.message=" + ex.getMessage());
        		} catch (Exception ex) {logger.debug("e.message=" + ex.getMessage());}
        		
        		logger.error(e.getMessage(), e);
        	}
        }
        
        model.addAttribute("result", result);
        
        logger.debug("addressImport ended.");
        return "ezAddress/addressImportComplete";
	}
	
	/**
	 * 주소록 양식 다운로드 함수
	 */
	@RequestMapping(value = "/ezAddress/addressFormatDownload.do", method = RequestMethod.GET)
	@ResponseBody
	public void addressFormatDownload(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Locale locale, Model model, HttpServletResponse response) throws Exception {		
		logger.debug("addressFormatDownload started.");
		
		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String format = request.getParameter("format");
        logger.debug("format=" + format);
        
        if (format == null) {
        	return;
        }
        
        String fileName = null;
        
		switch (format) {
			case "outlookCSV" :
				fileName = "outlook.csv";
				break;
			case "thunderbirdCSV" :
				fileName = "thunderbird.csv";
				break;
			case "googleCSV" :
				fileName = "google.csv";
				break;
			default : 
				format = "outlookCSV";
				fileName = "outlook.csv";
				break;
		}
		
		response.setContentType("application/x-msexcel; charset=utf-8");
		String headerKey = "Content-Disposition";
        String headerValue = String.format("attachment; filename=\"%s\"", fileName);
        response.setHeader(headerKey, headerValue);
		
        OutputStreamWriter writer = null;
		CSVWriter csvWriter = null;
		
		try {
//			String charset = "euc-kr";
//			
//			if (userInfo.getLang().equals("3")) {
//				charset = "shift-jis";
//			}
//			
//			if (format.equals("googleCSV")) {
//				charset = "utf-8";
//			}
//			logger.debug("charset=" + charset);
			writer = new OutputStreamWriter(response.getOutputStream(), "UTF-8");

			writer.write('\uFEFF');
			
			csvWriter = new CSVWriter(writer, CSVWriter.DEFAULT_SEPARATOR, CSVWriter.DEFAULT_QUOTE_CHARACTER, CSVWriter.DEFAULT_ESCAPE_CHARACTER, "\r\n");
			
	        String[] headArray = egovMessageSource.getMessage("ezAddress." + format, locale).split(";");
	        
	        csvWriter.writeNext(headArray);
	        csvWriter.flush();
	        
		} catch(IOException e) {
			logger.error(e.getMessage(), e);
		} catch(Exception e) {
			logger.error(e.getMessage(), e);
		} finally {
			if (csvWriter != null) {
				try {
					csvWriter.close();
				} catch(IOException e) {logger.debug("e.message=" + e.getMessage());}
			}
			if (writer != null) {
				writer.close();
			}
		}
	    
		logger.debug("addressFormatDownload ended.");
	}

	/**
	 * 최근 사용 주소 삭제 실행 함수
	 */
	@RequestMapping(value = "/ezAddress/deleteLastSentEmailAddress.do", produces = "application/json; charset=utf-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteLastSentEmailAddress(@CookieValue("loginCookie") String loginCookie, @RequestBody Map<String, Object> requestBody, HttpServletRequest request) throws Exception {
		logger.debug("deleteLastSentEmailAddress controller started.");

		LoginVO userInfo = commonUtil.userInfo(loginCookie);
		String cn = StringUtils.defaultIfBlank((String) requestBody.get("shareId"), userInfo.getId());
		String email = StringUtils.defaultIfBlank((String) requestBody.get("email"), "");
		String returnValue = "OK";

		try {
			ezAddressService.deleteLastSentEmailAddress(userInfo.getTenantId(), cn, email);
	    } catch (DOMException e) {
	        returnValue = "ERROR";
		} catch (Exception e) {
	        returnValue = "ERROR";
	    }

		logger.debug("deleteLastSentEmailAddress controller ended. returnValue=" + returnValue);
		return returnValue;
	}
}