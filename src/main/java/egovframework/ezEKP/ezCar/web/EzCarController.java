package egovframework.ezEKP.ezCar.web;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
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
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EzFileMngUtil;
import egovframework.ezEKP.ezCabinet.service.EzCabinetAdminService;
import egovframework.ezEKP.ezCar.service.EzCarService;
import egovframework.ezEKP.ezCar.vo.CarBrdListVO;
import egovframework.ezEKP.ezCar.vo.CarBrdVO;
import egovframework.ezEKP.ezCar.vo.CarFormListVO;
import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezEmail.service.EzEmailService;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.ezEKP.ezOrgan.vo.OrganUserVO;
import egovframework.ezEKP.ezResource.service.EzResourceAdminService;
import egovframework.ezEKP.ezResource.service.EzResourceService;
import egovframework.ezEKP.ezSchedule.service.EzScheduleService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginSimpleVO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;


@Controller
public class EzCarController extends EzFileMngUtil {
   
   private static final Logger logger = LoggerFactory.getLogger(EzCarController.class);
   
   @Autowired
   private CommonUtil commonUtil;

   @Autowired
   private Properties config;
   
   @Resource(name="EzResourceService")
   private EzResourceService ezResourceService;
   
   @Resource(name="EzCarService")
   private EzCarService ezCarService;
   
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
   
   /**
    * 자원관리 메인 화면 호출 함수
    */
   @RequestMapping(value = "/ezCar/resCar.do", method = RequestMethod.GET)
   public String carMain(HttpServletRequest req, Model model) throws Exception {

      String url = "/ezCar/leftCar.do";
      model.addAttribute("pUrl", url);
            
      
      return "/ezCar/carMain";
   }
   
   /**
    *  메인 화면 호출 함수
    */
   @RequestMapping(value = "/ezCar/carFormList.do", method = RequestMethod.GET)
   public String carFormList(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
         logger.debug("carFormList Start");
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         String carID = "";
         String accessCode = "";
         String lang = userInfo.getLang();
         
         if(req.getParameter("carID") != null) {
            carID = req.getParameter("carID");
         }
         
         if(req.getParameter("accessCode") != null) {
            accessCode = req.getParameter("accessCode");
         }
         
         String adminFg = ezCarService.getAdminFlagForm(userInfo.getCompanyID(), carID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()); 

         logger.debug("adminFg="+adminFg);
         
         //필요한 정보 (오늘 년월일, carFormList(오늘 년월에 해당하는 list조회), car_Id, carName(carId로 조회해오기))
         String currentDate = commonUtil.getTodayUTCTime("yyyy-MM"); //오늘날짜
         
         if(req.getParameter("date") != null){
            currentDate = req.getParameter("date");
         }
         
         currentDate = currentDate.replace("-", "");
         currentDate = currentDate.replace(" ", "");
         
           CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
         String carName = carBrd.getCarName();
         String car_nm = carBrd.getCar_nm();
         //List<CarBrdListVO> carBrdList =  ezCarService.getCarList(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
         List<CarFormListVO> carFormList = ezCarService.getCarFormList(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId(), currentDate);
         
         String[] strOwnerID = carBrd.getOwnerID().split(",");
         
 		 for(int i=0; i<strOwnerID.length; i++) {
 			if(strOwnerID[i].equals(userInfo.getId())) {
 				adminFg = "Y";
 			}
 		 }
 		
         model.addAttribute("carID", carID);
         model.addAttribute("carFormList", carFormList);
         //model.addAttribute("TotalCnt", totalCnt);
         model.addAttribute("carName", carName);
         model.addAttribute("car_nm", car_nm);
         model.addAttribute("accessCode", accessCode);
         model.addAttribute("companyID", userInfo.getCompanyID());
         model.addAttribute("userID", userInfo.getId());
         model.addAttribute("deptID", userInfo.getDeptID());
         model.addAttribute("adminFg", adminFg);
         model.addAttribute("lang", lang);
         
         logger.debug("carFormList End");
         return "/ezCar/carFormList";
   }
   
   /**
    * 메인 화면 호출 함수
    */
   @RequestMapping(value = "/ezCar/carFormListAjax.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")
   public String carFormListAjax(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
      logger.debug("carFormList Start");
      LoginVO userInfo = commonUtil.userInfo(loginCookie);
      String carID = "";
      String accessCode = "";
      String lang = userInfo.getLang();
      
      if(req.getParameter("carID") != null) {
         carID = req.getParameter("carID");
      }
      if(req.getParameter("accessCode") != null) {
         accessCode = req.getParameter("accessCode");
      }
      
      //String adminFg = ezResourceService.getAdminFlag(userInfo.getCompanyID(), carID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()); 
      String adminFg = "Y";
      logger.debug("adminFg="+adminFg);
      
      //필요한 정보 (오늘 년월일, carFormList(오늘 년월에 해당하는 list조회), car_Id, carName(carId로 조회해오기))
      String currentDate = commonUtil.getTodayUTCTime("yyyy-MM"); //오늘날짜
      
      if(req.getParameter("date") != null){
         currentDate = req.getParameter("date");
      }
      
      currentDate = currentDate.replace("-", "");
      currentDate = currentDate.replace(" ", "");
      
      CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
      String carName = carBrd.getCarName();
      String car_nm = carBrd.getCar_nm();
      List<CarFormListVO> carFormList = ezCarService.getCarFormList(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId(), currentDate);
      
      model.addAttribute("carID", carID);
      model.addAttribute("carFormList", carFormList);
      String count = String.valueOf(carFormList.size());
      //model.addAttribute("TotalCnt", totalCnt);
      model.addAttribute("carName", carName);
      model.addAttribute("car_nm", car_nm);
      model.addAttribute("accessCode", accessCode);
      model.addAttribute("companyID", userInfo.getCompanyID());
      model.addAttribute("userID", userInfo.getId());
      model.addAttribute("deptID", userInfo.getDeptID());
      model.addAttribute("adminFg", adminFg);
      model.addAttribute("lang", lang);
      
      logger.debug("carFormList End");
      return "json";
   }
   
   
   /**
    * 좌측메뉴 화면 호출 함수
    */
   @RequestMapping(value = "/ezCar/leftCar.do", method = RequestMethod.GET)
   public String resLeftResource(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
      
      LoginVO userInfo = commonUtil.userInfo(loginCookie);
      String carID = "";
       String carNm = "";
       String brdGubun = "";
       //String brdGbn = "";
       String strAccessCode = "";
       String selectNo = "";
       
      if(req.getParameter("carID") != null) {
         carID = req.getParameter("carID");
      }
      
      if(req.getParameter("brdNm") != null) {
         carNm = req.getParameter("carNm");
      }
      
      if(req.getParameter("boardGbn") != null) {
         brdGubun = req.getParameter("boardGbn");
      }
      
      /*if(req.getParameter("boardGbn") != null) {
         brdGbn = req.getParameter("boardGbn");
      }*/
      
      //관리자체크
     // if(userInfo.get) {
     // }
      //관리자면 0
      strAccessCode = "0";
      //사용자면 2
      //strAccessCode = "2";
      
      if(req.getParameter("flag") != null) {
         selectNo = req.getParameter("flag");
      }
      
      model.addAttribute("carID", carID);
      model.addAttribute("carNm", carNm);
      model.addAttribute("brdGubun", brdGubun);
      model.addAttribute("userID", userInfo.getId());
      model.addAttribute("deptID", userInfo.getDeptID());
      model.addAttribute("deptPathCode", userInfo.getDeptPathCode());
      model.addAttribute("companyID", userInfo.getCompanyID());
      model.addAttribute("strAccessCode", strAccessCode);
      model.addAttribute("selectNo", selectNo);
      model.addAttribute("serverName", req.getServerName());
      
      
      
      return "/ezCar/carLeftCar";
   }
   
   
   /**
    * 차량관리 정보 호출 함수
    */
   @RequestMapping(value = "/ezCar/callNodeTreeData.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
   @ResponseBody
   public String callNodeTreeData(@RequestBody String xmlReq,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
      logger.debug("callNodeTreeData started");

      LoginVO userInfo = commonUtil.userInfo(loginCookie);
      String selectFlag = "";
      
      if(req.getParameter("flag") != null) {
         selectFlag = req.getParameter("flag");
      }
      
      String ret = ezCarService.getSubClsTreeUser(xmlReq, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
     // String ret = ezCarService.getSubClsTree(xmlReq, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
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
            if(nodes5.item(i).getTextContent() == null || nodes5.item(i).getTextContent().equals("") || nodes5.item(i) == null ) {
               nodes5.item(i).setTextContent("<![CDATA[]]>");
            }
            if(nodes6.item(i).getTextContent() == null || nodes6.item(i).getTextContent().equals("") || nodes6.item(i) == null ) {
               nodes6.item(i).setTextContent("<![CDATA[]]>");
            }
            if(nodes7.item(i).getTextContent() == null || nodes7.item(i).getTextContent().equals("") || nodes7.item(i) == null ) {
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
    * 차량관리 정보 호출 함수
    */
   @RequestMapping(value = "/ezCar/callNodeTreeDataAdmin.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
   @ResponseBody
   public String callNodeTreeDataAdmin(@RequestBody String xmlReq,HttpServletRequest req, Model model, @CookieValue("loginCookie") String loginCookie) throws Exception {
	   logger.debug("callNodeTreeData started");
	   
	   LoginVO userInfo = commonUtil.userInfo(loginCookie);
	   String selectFlag = "";
	   
	   if(req.getParameter("flag") != null) {
		   selectFlag = req.getParameter("flag");
	   }
	   
	   String ret = ezCarService.getSubClsTree(xmlReq, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
	   // String ret = ezCarService.getSubClsTree(xmlReq, userInfo.getPrimary(), userInfo.getCompanyID(), userInfo.getDeptID(), userInfo.getId(), userInfo.getTenantId());
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
			   if(nodes5.item(i).getTextContent() == null || nodes5.item(i).getTextContent().equals("") || nodes5.item(i) == null ) {
				   nodes5.item(i).setTextContent("<![CDATA[]]>");
			   }
			   if(nodes6.item(i).getTextContent() == null || nodes6.item(i).getTextContent().equals("") || nodes6.item(i) == null ) {
				   nodes6.item(i).setTextContent("<![CDATA[]]>");
			   }
			   if(nodes7.item(i).getTextContent() == null || nodes7.item(i).getTextContent().equals("") || nodes7.item(i) == null ) {
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
    * 차량리스트2 화면 호출 함수
    */
   @RequestMapping(value = "/ezCar/viewCarList2.do", method = RequestMethod.GET)
   public String viewCarList2(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
      logger.debug("viewCarList2 Start");
      LoginVO userInfo = commonUtil.userInfo(loginCookie);
      String carID = "";
      String accessCode = "";
      String carName = "";
      //int brdCount;
      String useEditor = "";
      String lang = userInfo.getLang();
      int totalCnt;
      
      if(req.getParameter("carID") != null) {
         carID = req.getParameter("carID");
      }
      
      if(req.getParameter("accessCode") != null) {
         accessCode = req.getParameter("accessCode");
      }
      
      if(req.getParameter("carName") != null) {
         carName = req.getParameter("carName");
      }
      
      String adminFg = ezCarService.getAdminFlag(userInfo.getCompanyID(), carID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()); 
 
      logger.debug("adminFg="+adminFg);
      totalCnt = ezCarService.getTotalCnt(carID, userInfo.getCompanyID());
      List<CarBrdListVO> carBrdList =  ezCarService.getCarList(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
      /*StringBuilder childBrdBld = new StringBuilder();
      childBrdBld.append(ezResourceService.getItemList(loginCookie,carID));
      logger.debug("childBrd=" + childBrdBld.toString());
       
      List<ResGetItemListVO>   list = ezResourceService.getBrdMainList(carID, userInfo.getCompanyID(), userInfo.getPrimary(), userInfo.getTenantId());
      
      brdCount = list.size();
      
      logger.debug("brdCount=" + brdCount);
      
      for (int i = 0; i < brdCount; i++) {
         childBrdBld.append(list.get(i).getBrd_ID() + "/" + list.get(i).getBrd_Nm() + "/" + list.get(i).getApproveFlag() + "|");
      }
      
      ScheduleConfigVO scheduleConfigVO = ezScheduleService.getScheduleConfig(userInfo.getId(), userInfo.getTenantId());
      int startDay = scheduleConfigVO != null ? scheduleConfigVO.getStartDay() : 7;
      
      String lunarUse = ezScheduleService.scheduleGetLunarUse(userInfo.getCompanyID(), userInfo.getTenantId()); */
      
      //model.addAttribute("childBrd", childBrdBld.toString());
      model.addAttribute("carID", carID);
      model.addAttribute("carBrdList", carBrdList);
      model.addAttribute("TotalCnt", totalCnt);
      model.addAttribute("carName", carName);
      model.addAttribute("accessCode", accessCode);
      model.addAttribute("companyID", userInfo.getCompanyID());
      model.addAttribute("userID", userInfo.getId());
      model.addAttribute("deptID", userInfo.getDeptID());
      model.addAttribute("adminFg", adminFg);
      //model.addAttribute("brdCount", brdCount);
      model.addAttribute("useEditor", useEditor);
      //model.addAttribute("startDay", startDay);
      model.addAttribute("lang", lang);
      //model.addAttribute("lunarUse", lunarUse);
      
      logger.debug("viewResList2 End");
      return "/ezCar/carViewCarList2";
   }
   
      /**
       * 차량 리스트 삭제
       */
      @RequestMapping(value="/ezCar/deleteCar.do", method = RequestMethod.POST)   
  	  @ResponseBody
      public void scheduleDelGroup(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO) throws Exception {
         
         logger.debug("============ scheduleDelGroup started ============");
         
         loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
         
         String carID = request.getParameter("carID");
         String cIDs[] = carID.split(";");
         
         for (int i = 0; i < cIDs.length; i++) {
            ezCarService.deleteCar(cIDs[i], loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
         }      
      }
      
      
      /**
       * 차량 추가 화면 호출 함수
       */
      @RequestMapping(value = "/ezCar/addClsItem.do", method = RequestMethod.GET)
      public String addClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         String carID = "";
         
         if (!req.getParameter("carID").equals("")) {
            carID = req.getParameter("carID");
         }

         String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
         
         if (attachFileNameMaxLength.equals("")) {
            attachFileNameMaxLength = "100";
         }
         
         model.addAttribute("carID", carID);
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
         model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
         
         return "/ezCar/resAddClsItem";
      }
      
      /**
       *  조직도 화면 호출 함수
       */
      @RequestMapping(value = "/ezCar/selectPerson.do", method = RequestMethod.GET) 
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
         
         return "/ezCar/carSelectPerson";
      }
      
      
      @RequestMapping(value = "/ezCar/uploadItemAttach.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
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
           
           String pDirPath = commonUtil.getUploadPath("upload_car.ROOT", userInfo.getTenantId());

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
           
           writeUploadedFile(multiFile, newFileName + pFileName, pDirPath + "tempUploadFile");                  
              
         strXML.append("<DATA><![CDATA[" + newFileName + "]]></DATA>");
         strXML.append("<DATA2><![CDATA[" + pFileName + "]]></DATA2>");
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
      @RequestMapping(value = "/ezCar/getCarThumbnailInfo.do", method = RequestMethod.GET)
      @ResponseBody
      public void getCarThumbnailInfo(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response) throws Exception {
         logger.debug("getCarThumbnailInfo started");
         
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         
         String fileName = request.getParameter("fileName");
         String mode = "";
         
         if(request.getParameter("mode") != null) {
            mode = request.getParameter("mode");
         }
         String filePath = "";
         
         if(mode.equals("temp")) {
            String pSignatureDir = commonUtil.getUploadPath("upload_car.TEMPUPLOAD", userInfo.getTenantId());
            
            filePath = pSignatureDir + commonUtil.separator + fileName;
         }
         else {
            String pSignatureDir = commonUtil.getUploadPath("upload_car.ROOT", userInfo.getTenantId()) + commonUtil.separator + "uploadFile";
            
            filePath = pSignatureDir + fileName;
         }
         
         if (filePath != null && !filePath.equals("")) {
            logger.debug("filePath : " + filePath + "|| fileName : " + fileName);
            downImage(filePath, request, response);
         }
         
         logger.debug("getCarThumbnailInfo end");
      }
      
      /**
       *  임시첨부파일 삭제
       */
      @RequestMapping(value = "/ezCar/tempUploadFileDelete.do", method = RequestMethod.POST)
      public String tempUploadFileDelete(HttpServletRequest request, @CookieValue("loginCookie") String loginCookie, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
         
         logger.debug("tempUploadFileDelete started");
         
         LoginVO userInfo = commonUtil.userInfo(loginCookie);

         String fileName = request.getParameter("fileName");
         String pDirPath = commonUtil.getRealPath(request) + commonUtil.getUploadPath("upload_car.TEMPUPLOAD", userInfo.getTenantId());
         
         logger.debug("fileName : " + fileName + ", pDirPath : " + pDirPath);
         
         File file = new File(pDirPath + commonUtil.separator + fileName);
         file.delete();

           logger.debug("tempUploadFileDelete ended");
           
           return "json";
       }
      
      
      /**
       * 차량 추가 실행 함수
       */
      @RequestMapping(value = "/ezCar/callAddClsItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
      @ResponseBody
      public String callAddClsItem(@CookieValue("loginCookie") String loginCookie, Model model, @RequestBody String xmlStr, HttpServletRequest request) throws Exception {
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         Locale locale = userInfo.getLocale();
         Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
         
         String ownerList = xmlDom.getElementsByTagName("DATA").item(3).getTextContent().trim();
         String strOwnerID = ownerList.split(",")[0];
         String deptID = xmlDom.getElementsByTagName("DATA").item(1).getTextContent().trim();      // 부서ID
         
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
         
         boolean returnValue = ezCarService.addCarData(request, commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId(),locale);
         
         StringBuilder strXML = new StringBuilder();
         strXML.append("<RTN>" + String.valueOf(returnValue) + "</RTN>");
         return strXML.toString();
      
      }
      
      /**
       * 차량등록정보 화면 호출 함수
       */
      @RequestMapping(value = "/ezCar/viewClsItem.do", method = RequestMethod.GET)
      public String viewClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, HttpServletResponse resp, Model model, Locale locale) throws Exception {
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         String carID = "";
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
         String car_nm = "";
         
         if (!req.getParameter("carID").equals("")) {
            carID = req.getParameter("carID");
         }
         CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
         
         // 2018-10-30 김민성 - 자원 멀티관리자 데이터 처리
         String[] ownerList = carBrd.getOwnerID().split(",");
         List<OrganUserVO> ownerInfoList = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
         car_nm = carBrd.getCar_nm();
         strBrdID = carBrd.getCarID();
         strOwnDeptID = carBrd.getOwnDeptID();
         strOwnerID = ownerList[0];
         ownerCall = carBrd.getOwnerCall();
         
         if (userInfo.getPrimary().equals("1")) {
            strBrdNm = carBrd.getCarName();
            strOwnDeptNm = carBrd.getOwnDeptNm();
            strOwnerNm = carBrd.getOwnerNm();
            strOwnerPosition = carBrd.getOwnerPosition();
         } else {
            strBrdNm = carBrd.getCarName2();
            strOwnDeptNm = carBrd.getOwnDeptNm2();
            strOwnerNm = carBrd.getOwnerNm2();
            strOwnerPosition = carBrd.getOwnerPosition2();
         }
         strMakeDate = carBrd.getCar_register_date();
         
         List<String> attachList = ezCarService.getAttachList(carID, userInfo.getCompanyID(), userInfo.getTenantId());

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
         model.addAttribute("car_nm", car_nm);
         
         return "/ezCar/carViewClsItem";
      }
      
      /**
       * 차량정보 수정 화면 호출 함수
       */
      @SuppressWarnings("unchecked")
      @RequestMapping(value = "/ezCar/modClsItem.do", method = RequestMethod.GET)
      public String modClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         String carID = "";
         String brdID = "";
         String strBrdNm = "";
         String strBrdNm2 = "";
         String strOwnDeptNm = "";
         String strOwnerNm = "";
         String strOwnerPosition = "";
         String strBrdID = "";
         String strOwnDeptID = "";
         String ownerCall = "";
         String strOwnerID = "";
         String strMakeDate = "";
         List<OrganUserVO> ownerListVO;
         String car_nm = "";

         
         if (req.getParameter("carID") != null) {
            carID = req.getParameter("carID");
         }
         if (req.getParameter("resID") != null) {
            brdID = req.getParameter("brdID");
         }
         
         String attachFileNameMaxLength = ezCommonService.getTenantConfig("attachFileNameMaxLength", userInfo.getTenantId());
         
         if (attachFileNameMaxLength.equals("")) {
            attachFileNameMaxLength = "100";
         }
         
         //if (ezResourceService.getAdminFlag(userInfo.getCompanyID(), brdID, userInfo.getId(), userInfo.getTenantId(), userInfo.getDeptID()).equals("Y")) {
            CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
            
            // 2018-10-24 김민성 - 자원관리 관리자 조회
            String[] ownerList = carBrd.getOwnerID().split(",");
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
            car_nm = carBrd.getCar_nm();
            strBrdID = carBrd.getCarID();
            strOwnDeptID = carBrd.getOwnDeptID();
            strOwnerID = ownerList[0];
            ownerCall = carBrd.getOwnerCall();
            
            strBrdNm = carBrd.getCarName();
            strBrdNm2 = carBrd.getCarName2();
            
            if (userInfo.getPrimary().equals("1")) {
               strOwnDeptNm = carBrd.getOwnDeptNm();
               strOwnerNm = carBrd.getOwnerNm();
               strOwnerPosition = carBrd.getOwnerPosition();
            } else {
               strOwnDeptNm = carBrd.getOwnDeptNm2();
               strOwnerNm = carBrd.getOwnerNm2();
               strOwnerPosition = carBrd.getOwnerPosition2();
            }
            
            strMakeDate = carBrd.getCar_register_date();
            
            List<String> attachList = ezCarService.getAttachList(carID, userInfo.getCompanyID(), userInfo.getTenantId());

            for(int i=0; i<attachList.size(); i++) {
               model.addAttribute("attachList"+(i+1), attachList.get(i));
            }
         //}
         
         model.addAttribute("companyID", userInfo.getCompanyID());
         model.addAttribute("userID", userInfo.getId());
         model.addAttribute("userName", userInfo.getName());
         model.addAttribute("deptID", userInfo.getDeptID());
         model.addAttribute("deptName", userInfo.getDeptName1());
         model.addAttribute("strBrdID", strBrdID); //carid
         model.addAttribute("strBrdNm", strBrdNm);
         model.addAttribute("strBrdNm2", strBrdNm2);
         model.addAttribute("ownDeptNm", strOwnDeptNm);
         model.addAttribute("ownDeptID", strOwnDeptID);
         model.addAttribute("ownerID", strOwnerID);
         model.addAttribute("ownerNm", strOwnerNm);
         model.addAttribute("ownerPosition", strOwnerPosition);
         model.addAttribute("ownerCall", ownerCall);
         model.addAttribute("makeDate", strMakeDate);
         model.addAttribute("langPrimary", ezCommonService.getTenantConfig("LangPrimary" + userInfo.getLang(), userInfo.getTenantId()));
         model.addAttribute("langSecondary", ezCommonService.getTenantConfig("LangSecondary" + userInfo.getLang(), userInfo.getTenantId()));
         model.addAttribute("strResID", brdID);  //upperid
         model.addAttribute("attachFileNameMaxLength", attachFileNameMaxLength);
         model.addAttribute("car_nm", car_nm);

         
         return "/ezCar/carModClsItem";
      }
      
      /**
       * 차량 수정 실행 함수
       */
      @RequestMapping(value = "/ezCar/callModClsItem.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
      @ResponseBody
      public String callModClsItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model, @RequestBody String xmlStr) throws Exception {
         LoginVO userInfo = commonUtil.userInfo(loginCookie);
         
         Document xmlDom = commonUtil.convertStringToDocument(xmlStr);
         
         String ownerList = xmlDom.getElementsByTagName("DATA").item(3).getTextContent().trim();
         String strOwnerID = ownerList.split(",")[0];
         String propList = "displayName1;displayName2;title1;title2;description1;description2";
         String infoXML = ezOrganService.getPropertyList(strOwnerID, propList, userInfo.getPrimary(), userInfo.getTenantId());
         String car_nm = xmlDom.getElementsByTagName("DATA").item(11).getTextContent().trim();
         String ownerCall = xmlDom.getElementsByTagName("DATA").item(6).getTextContent().trim();
         
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
         xmlDom.getElementsByTagName("DATA").item(6).setTextContent(car_nm);
         xmlDom.getElementsByTagName("DATA").item(11).setTextContent(ownerCall);
         
         Node data1 = xmlDom.createElement("DATA");
         data1.setTextContent(deptName2);
         
         Node data2 = xmlDom.createElement("DATA");
         data2.setTextContent(displayName2);
         
         Node data3 = xmlDom.createElement("DATA");
         data3.setTextContent(title2);
         
         Node data5 = xmlDom.createElement("DATA");
         data5.setTextContent(car_nm);
         
         xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data1);
         xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data2);
         xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data3);
         
         
         // 자원 이미지 조회 추가
         Node data4 = xmlDom.createElement("DATA");
         data4.setTextContent(realPath);
         
         xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data4);
         xmlDom.getElementsByTagName("PARADATA").item(0).appendChild(data5);
         boolean returnValue = ezCarService.modifyCarData(commonUtil.convertDocumentToString(xmlDom), userInfo.getTenantId());
         
         StringBuilder strXML = new StringBuilder();
         strXML.append("<RTN>" + String.valueOf(returnValue) + "</RTN>");
         return strXML.toString();
         
      }
      
      /**
		 * 차량등록일지 추가 화면 호출 함수
		 */
		@RequestMapping(value = "/ezCar/carDiary.do", method = RequestMethod.GET)
		public String carDiary(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
	         String carID = "";
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
	         String car_nm = "";
	         String ownerName ="";
	         
	         if (!req.getParameter("carID").equals("")) {
	            carID = req.getParameter("carID");
	         }
	         CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
	         
	         // 2018-10-30 김민성 - 자원 멀티관리자 데이터 처리
	         String[] ownerList = carBrd.getOwnerID().split(",");
	         List<OrganUserVO> ownerInfoList = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
	         car_nm = carBrd.getCar_nm();
	         strBrdID = carBrd.getCarID();
	         strOwnDeptID = carBrd.getOwnDeptID();
	         strOwnerID = ownerList[0];
	         
	         for(int i=0; i<ownerInfoList.size(); i++){ //관리자 이름 받아오기
	        	 ownerName += ownerInfoList.get(i).getDisplayName() + ',';
	         }
	         ownerName = ownerName.substring(0, ownerName.length()-1); //마지막 , 지우기
	         
	         ownerCall = carBrd.getOwnerCall();
	         
	         
	         if (userInfo.getPrimary().equals("1")) {
	            strBrdNm = carBrd.getCarName();
	            strOwnDeptNm = carBrd.getOwnDeptNm();
	            strOwnerNm = carBrd.getOwnerNm();
	            strOwnerPosition = carBrd.getOwnerPosition();
	         } else {
	            strBrdNm = carBrd.getCarName2();
	            strOwnDeptNm = carBrd.getOwnDeptNm2();
	            strOwnerNm = carBrd.getOwnerNm2();
	            strOwnerPosition = carBrd.getOwnerPosition2();
	         }
	         strMakeDate = carBrd.getCar_register_date();
	         
	         List<String> attachList = ezCarService.getAttachList(carID, userInfo.getCompanyID(), userInfo.getTenantId());

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
	         model.addAttribute("car_nm", car_nm);
	         model.addAttribute("ownerName", ownerName);
	         
			
			return "/ezCar/carDiary";
		}
        
	
		/*차량등록일지 추가*/

		@RequestMapping(value = "/ezCar/addCarForm.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
		public String addCarForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
			logger.debug("addCarForm started");
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			int count = Math.subtractExact(Integer.parseInt(request.getParameter("count")), 1);
			
			String[] sdatepicker = request.getParameterValues("Sdatepicker");
			String[] stimepicker = request.getParameterValues("Stimepicker");
			String[] etimepicker = request.getParameterValues("Etimepicker");
			String[] driverdeptname = request.getParameterValues("driverdeptname");
			String[] dirvername = request.getParameterValues("dirvername");
			String[] s2timepicker = request.getParameterValues("S2timepicker");
			String[] bdistance = request.getParameterValues("bdistance");
			String[] drivepurpose = request.getParameterValues("drivepurpose");
			String[] drivepoint = request.getParameterValues("drivepoint");
			String[] s3timepicker = request.getParameterValues("S3timepicker");
			String[] adistance = request.getParameterValues("adistance");
			String[] adistanceauto = request.getParameterValues("adistanceauto");
			String[] adistancecommute = request.getParameterValues("adistancecommute");
			String[] adistancework = request.getParameterValues("adistancework");
			String[] adistanceetc = request.getParameterValues("adistanceetc");
			
			ArrayList<String> control = new ArrayList<String>();
			
			String indexing = request.getParameter("indexing"); //'1,11,'
			String index[] = indexing.split(",");	//[1,11]
			
			for(int i=0; i<count; i++){
				control.add(request.getParameter("control_"+index[i]));
			}
			
			String[] controla = new String[count];
			
			//CAR_FORM_ID의 최대값을 받아온다.
			String carID = request.getParameter("carID");
			int car_form_id;
			car_form_id = ezCarService.getMaxCarFormId(carID, userInfo.getTenantId(), userInfo.getCompanyID());

			for(int j=0; j<count; j++){
					if(control.get(j)==null){
						controla[j] = "0";
					}else if(control.get(j).equals("Yselect")){
						controla[j] = "1";
					}else if(control.get(j).equals("Nselect")){
						controla[j] = "0";
					}
				
					if(StringUtils.isNotEmpty(sdatepicker[j])){
						ezCarService.addCarForm(userInfo.getCompanyID(), userInfo.getId(), userInfo.getTenantId(),commonUtil.getTodayUTCTime("yyyy-MM-dd"),carID, car_form_id, 
						sdatepicker[j],stimepicker[j],etimepicker[j], driverdeptname[j], dirvername[j], s2timepicker[j], bdistance[j], drivepurpose[j], 
						drivepoint[j],s3timepicker[j],adistance[j],adistanceauto[j], adistancecommute[j], adistancework[j],adistanceetc[j],j, controla[j]);
					}
			}
			
			model.addAttribute("complete","1");
			
			logger.debug("upload ended");
			return "/ezCar/carDiary";
		}
		
		/**
		 * 차량등록일지 수정화면 조회
		 */
		@RequestMapping(value = "/ezCar/modifycarDiary.do", method = RequestMethod.GET)
		public String modifycarDiary(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String carID = "";
			String car_form_id = "";
			String car_name = "";
			String car_nm = "";
			int startNum = 0;
			String ownerName = "";
			
			if (!req.getParameter("carID").equals("")) {
				carID = req.getParameter("carID");
			}
			if (!req.getParameter("car_form_id").equals("")) {
				car_form_id = req.getParameter("car_form_id");
			}
		    
			CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
			
			String[] ownerList = carBrd.getOwnerID().split(",");
			
			List<OrganUserVO> ownerInfoList = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
			for(int i=0; i<ownerInfoList.size(); i++){ //관리자 이름 받아오기
				        	 ownerName += ownerInfoList.get(i).getDisplayName() + ',';
			}
			ownerName = ownerName.substring(0, ownerName.length()-1); //마지막 , 지우기
			
			car_name = carBrd.getCarName();
			car_nm = carBrd.getCar_nm();
			String ownerNm = carBrd.getOwnerNm();
			String ownerCall = carBrd.getOwnerCall();
			
			List<CarFormListVO> carFormList = ezCarService.getCarForm(carID, Integer.parseInt(car_form_id), userInfo.getCompanyID(), userInfo.getTenantId());
			
			startNum = carFormList.size()+1;
			
			model.addAttribute("carFormList", carFormList);
			model.addAttribute("car_name", car_name);
			model.addAttribute("car_nm", car_nm);
			model.addAttribute("startNum", startNum);
			model.addAttribute("carID", carID);
			model.addAttribute("ownerNm", ownerNm);
			model.addAttribute("ownerCall", ownerCall);
			model.addAttribute("car_form_id", car_form_id);
			model.addAttribute("ownerName", ownerName);
			
			return "/ezCar/modifycarDiary";
		}
		
		/**
		 * 차량등록일지 조회
		 */
		@RequestMapping(value = "/ezCar/viewFormItem.do", method = RequestMethod.GET)
		public String viewFormItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String carID = "";
			String car_form_id = "";
			String car_name = "";
			String car_nm = "";
			int startNum = 0;
			String ownerName ="";
			
			if (!req.getParameter("carID").equals("")) {
				carID = req.getParameter("carID");
			}
			if (!req.getParameter("car_form_id").equals("")) {
				car_form_id = req.getParameter("car_form_id");
			}
			
			CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
			String[] ownerList = carBrd.getOwnerID().split(",");
			
			List<OrganUserVO> ownerInfoList = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
			
			for(int i=0; i<ownerInfoList.size(); i++){ //관리자 이름 받아오기
				        	 ownerName += ownerInfoList.get(i).getDisplayName() + ',';
			}
			ownerName = ownerName.substring(0, ownerName.length()-1); //마지막 , 지우기
			
			car_name = carBrd.getCarName();
			car_nm = carBrd.getCar_nm();
			String ownerNm = carBrd.getOwnerNm();
			String ownerCall = carBrd.getOwnerCall();
			
			List<CarFormListVO> carFormList = ezCarService.getCarForm(carID, Integer.parseInt(car_form_id), userInfo.getCompanyID(), userInfo.getTenantId());
			
				startNum = carFormList.size()+1;
			
			model.addAttribute("carFormList", carFormList);
			model.addAttribute("car_name", car_name);
			model.addAttribute("car_nm", car_nm);
			model.addAttribute("startNum", startNum);
			model.addAttribute("carID", carID);
			model.addAttribute("ownerNm", ownerNm);
			model.addAttribute("ownerCall", ownerCall);
			model.addAttribute("ownerName", ownerName);
			
			return "/ezCar/viewFormItem";
		}
		
		/*차량등록일지 추가*/
		@RequestMapping(value = "/ezCar/modifyCarForm.do", method = RequestMethod.POST, produces="text/xml; charset=utf-8")
		public String modifyCarForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, Model model) throws Exception{
			logger.debug("modifyCarForm started");
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			String carID = "";
			int car_form_id = 0;
			
			int count = Math.subtractExact(Integer.parseInt(request.getParameter("count")), 1);
			String[] sdatepicker = request.getParameterValues("Sdatepicker");
			String[] stimepicker = request.getParameterValues("Stimepicker");
			String[] etimepicker = request.getParameterValues("Etimepicker");
			String[] driverdeptname = request.getParameterValues("driverdeptname");
			String[] dirvername = request.getParameterValues("dirvername");
			String[] s2timepicker = request.getParameterValues("S2timepicker");
			String[] bdistance = request.getParameterValues("bdistance");
			String[] drivepurpose = request.getParameterValues("drivepurpose");
			String[] drivepoint = request.getParameterValues("drivepoint");
			String[] s3timepicker = request.getParameterValues("S3timepicker");
			String[] adistance = request.getParameterValues("adistance");
			String[] adistanceauto = request.getParameterValues("adistanceauto");
			String[] adistancecommute = request.getParameterValues("adistancecommute");
			String[] adistancework = request.getParameterValues("adistancework");
			String[] adistanceetc = request.getParameterValues("adistanceetc");
			
			/*String[] control = new String[count];
			
			
			
			for(int i=1; i<=count; i++){
				String controli = "control_";
				controli = controli+Integer.toString(i);
				control[i-1]= request.getParameter(controli);
			}
			
			
			int totalCount = 0; //리스트들의 최대값을 가져옴
			//car_register_no 는 잘라서 가져와야한다.
			for(int i=0; i<count; i++){
				if(sdatepicker[i] == "" || sdatepicker[i] == null){
					totalCount = i;
					break;
				}else{
					totalCount = count;
				}
			}*/
			
			ArrayList<String> control = new ArrayList<String>();
		
			
			String indexing = request.getParameter("indexing"); //'1,11,'
			String index[] = indexing.split(",");	//[1,11]
			
			for(int i=0; i<count; i++){
				control.add(request.getParameter("control_"+index[i]));
			}
		
			
			String[] controla = new String[count];
			
			if (!request.getParameter("carID").equals("")) {
				carID = request.getParameter("carID");
			}
			if (!request.getParameter("car_form_id").equals("")) {
				car_form_id = Integer.parseInt(request.getParameter("car_form_id"));
			}
		
			List<CarFormListVO> carFormList = ezCarService.getCarForm(carID, car_form_id, userInfo.getCompanyID(), userInfo.getTenantId());
			String register_id = carFormList.get(0).getRegister_id();
			String register_date = carFormList.get(0).getRegister_date();
			
			int car_form_id2 = ezCarService.getMaxCarFormId(carID, userInfo.getTenantId(), userInfo.getCompanyID());
			//id MAX값 받아서 update하고, delflag를 1으로 바꾸어준다.
				ezCarService.modifyCarForm(car_form_id, car_form_id2, carID, userInfo.getCompanyID(),userInfo.getTenantId(),commonUtil.getTodayUTCTime("yyyy-MM-dd"));
			
			/*//이전 id값으로(car_form_id)
			for(int j=0; j<totalCount; j++){
				if(control[j]==null){
					control[j] = "0";
				}else{
					if(control[j].equals("Yselect")){
						control[j] = "1";
					}else if(control[j].equals("Nselect")){
						control[j] = "0";
					}
				}*/
				
				
				for(int j=0; j<count; j++){
				
					
					if(control.get(j)==null){
						controla[j] = "0";
					}else if(control.get(j).equals("Yselect")){
						controla[j] = "1";
					}else if(control.get(j).equals("Nselect")){
						controla[j] = "0";
					}
				
				if(StringUtils.isNotEmpty(sdatepicker[j])){
					ezCarService.addCarForm(userInfo.getCompanyID(), register_id, userInfo.getTenantId(),register_date,carID, car_form_id, 
							sdatepicker[j],stimepicker[j],etimepicker[j], driverdeptname[j], dirvername[j], s2timepicker[j], bdistance[j], drivepurpose[j], 
							drivepoint[j],s3timepicker[j],adistance[j],adistanceauto[j], adistancecommute[j], adistancework[j],adistanceetc[j],j, controla[j]);
				}
			}
			
			model.addAttribute("complete","1");
			
			logger.debug("upload ended");
			return "/ezCar/carDiary";
		}
		
		/**
		 * 차량 일지 삭제
		 */
		@RequestMapping(value="/ezCar/deleteCarForm.do", method = RequestMethod.POST)   
		@ResponseBody
		public void deleteCarForm(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO) throws Exception {
			
			logger.debug("============ scheduleDelGroup started ============");
			
			loginSimpleVO = commonUtil.userInfoSimple(loginCookie);
			
			String carID = request.getParameter("carID");
			String car_form_id = request.getParameter("car_form_id");
			String car_form_ids[] = car_form_id.split(";");
			
			for (int i = 0; i < car_form_ids.length; i++) {
				ezCarService.deleteCarForm(car_form_ids[i], carID, loginSimpleVO.getTenantId(), loginSimpleVO.getCompanyID());
			}      
		}
		
		
		/**
		 * 차량일지 엑셀 다운
		 */
		@SuppressWarnings("deprecation")
		@RequestMapping(value = "/ezCar/excelExportOut.do", method = {RequestMethod.POST, RequestMethod.GET})
		//2018-10-16 김보미 - 전자결재 엑셀출력 workBook 이용해서 출력하도록 변경
		@ResponseBody
		public void excelExportOut(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, HttpServletRequest request, HttpServletResponse response, Locale locale) throws Exception{
			logger.debug("excelExportOut started"); 
			userInfo = commonUtil.aprUserInfo(loginCookie);
			
			String carID = "";
			String yearMonth = "";
			String ownerName ="";
			
			carID = request.getParameter("carID");
			yearMonth = request.getParameter("yearMonth");

			// 엑셀시작
			try (HSSFWorkbook workbook = new HSSFWorkbook()) {
				HSSFSheet sheet;
	
				// 헤더 폰트 굵게
				HSSFFont headerFont = workbook.createFont();
				headerFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				
				HSSFFont headerFont2 = workbook.createFont();
				headerFont2.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				headerFont2.setFontHeight((short) 600);
				headerFont2.setBold(true);
				
				HSSFCellStyle headerStyle= workbook.createCellStyle();
				HSSFCellStyle headerStyle2= workbook.createCellStyle();
				headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
				headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
				headerStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
				headerStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
				headerStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
				headerStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
				headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				headerStyle2.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				headerStyle2.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				headerStyle.setFont(headerFont);
				headerStyle2.setFont(headerFont2);
				
				HSSFCellStyle bodyStyle= workbook.createCellStyle();
				bodyStyle.setBorderBottom(HSSFCellStyle.BORDER_THIN);
				bodyStyle.setBorderTop(HSSFCellStyle.BORDER_THIN);
				bodyStyle.setBorderRight(HSSFCellStyle.BORDER_THIN);
				bodyStyle.setBorderLeft(HSSFCellStyle.BORDER_THIN);
				bodyStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
				bodyStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
				
				CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
				
				String[] ownerList = carBrd.getOwnerID().split(",");
				
				List<OrganUserVO> ownerInfoList = ezResourceService.getOwnerInfo(ownerList, userInfo.getTenantId(), userInfo.getCompanyID(), userInfo.getLang());
				for(int i=0; i<ownerInfoList.size(); i++){ // 관리자 이름 받아오기
					        	 ownerName += ownerInfoList.get(i).getDisplayName() + ',';
				}
				ownerName = ownerName.substring(0, ownerName.length()-1); // 마지막 , 지우기
				
				// 헤더만들기
				Row row;
				Cell cell;
				      
				sheet = workbook.createSheet("report");
				
				row = sheet.createRow(0);
					cell = row.createCell(2);
					cell.setCellValue("차 량 운 행 기 록 일 지 (차종  : " + carBrd.getCarName() + ", 차량번호 : " + carBrd.getCar_nm() + ")");
					cell.setCellStyle(headerStyle2);
					row.setHeight((short)700);
					sheet.autoSizeColumn(2);
					sheet.setColumnWidth(2, (sheet.getColumnWidth(2)) + 512);
				row = sheet.createRow(1);
				
				row = sheet.createRow(2);
					cell = row.createCell(0);
					cell.setCellValue("차 량 담당자 : " + ownerName + " (" + carBrd.getOwnerCall() + ")");
					row.setHeight((short)512);
					sheet.autoSizeColumn(0);
					sheet.setColumnWidth(0, (sheet.getColumnWidth(2)) + 512);
					
					cell = row.createCell(11);
					cell.setCellValue("예약은 운행전 30분전 예약 후 차량스케줄 협의");
					row.setHeight((short)512);
					sheet.autoSizeColumn(0);
					sheet.setColumnWidth(0, (sheet.getColumnWidth(2)) + 512);
				
				row = sheet.createRow(3);
					cell = row.createCell(0);
					cell.setCellValue("운행 전 작성");
					cell.setCellStyle(headerStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(0);
					sheet.setColumnWidth(0, (sheet.getColumnWidth(0)) + 512);
					
					cell = row.createCell(6);
					cell.setCellValue("운행 후 작성");
					cell.setCellStyle(headerStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(6);
					sheet.setColumnWidth(6, (sheet.getColumnWidth(6)) + 512);
					
					cell = row.createCell(14);
					cell.setCellValue("출장승인서 제출여부");
					cell.setCellStyle(headerStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(14);
					sheet.setColumnWidth(14, (sheet.getColumnWidth(14)) + 512);
					
					for(int i=1; i<=5; i++){
						cell = row.createCell(i);
						cell.setCellStyle(headerStyle);
					}
					for(int i=7; i<=13; i++){
						cell = row.createCell(i);
						cell.setCellStyle(headerStyle);
					}
					
				row = sheet.createRow(4);
					cell = row.createCell(11);
					cell.setCellValue("업무용사용거리");
					cell.setCellStyle(headerStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(11);
					sheet.setColumnWidth(11, (sheet.getColumnWidth(11)) + 512);
					
					String[] headerName1 = {"운행일자", "예약시간", "부서", "사용자", "회사 출발시간", "출발시 누적거리", "주행목적*", "행선지*", "회사 도착시간", "도착시 누적거리(km)", "주행거리(km)"};
					
					for(int i=0; i<headerName1.length; i++){
						cell = row.createCell(i);
						cell.setCellValue(headerName1[i]);
						cell.setCellStyle(headerStyle);
						row.setHeight((short)512);
						sheet.autoSizeColumn(i);
						sheet.setColumnWidth(i, (sheet.getColumnWidth(i)) + 512); // 헤더명 길이는 headerName1 배열 내부 문자열으로 고정된 상태
					}
						cell = row.createCell(13);
						cell.setCellValue("업무 외 이용(km)");
						cell.setCellStyle(headerStyle);
						row.setHeight((short)512);
						sheet.autoSizeColumn(13);
						sheet.setColumnWidth(13, (sheet.getColumnWidth(13)) + 512);
					
						cell = row.createCell(14);
						cell.setCellStyle(headerStyle);
						sheet.autoSizeColumn(14);
						sheet.setColumnWidth(14, (sheet.getColumnWidth(14)) + 512);
					
				row = sheet.createRow(5);
					cell = row.createCell(11);
					cell.setCellValue("출퇴근용");
					cell.setCellStyle(headerStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(11);
					sheet.setColumnWidth(11, (sheet.getColumnWidth(11)) + 512);
					
					cell = row.createCell(12);
					cell.setCellValue("일반업무용");
					cell.setCellStyle(headerStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(12);
					sheet.setColumnWidth(12, (sheet.getColumnWidth(12)) + 512);
	
					for(int i=0; i<11; i++){
						cell = row.createCell(i);
						cell.setCellStyle(headerStyle);
					}
					cell = row.createCell(13);
					cell.setCellStyle(headerStyle);
					sheet.autoSizeColumn(13);
					sheet.setColumnWidth(13, (sheet.getColumnWidth(13)) + 512);
	
					cell = row.createCell(14);
					cell.setCellStyle(headerStyle);
					sheet.autoSizeColumn(14);
					sheet.setColumnWidth(14, (sheet.getColumnWidth(14)) + 512);
					
				sheet.addMergedRegion(new CellRangeAddress(0, 0, 2, 10));
				sheet.addMergedRegion(new CellRangeAddress(2, 2, 11, 14));
				sheet.addMergedRegion(new CellRangeAddress(2, 2, 0, 10));
				sheet.addMergedRegion(new CellRangeAddress(3, 3, 0, 5));
				sheet.addMergedRegion(new CellRangeAddress(3, 3, 6, 13));
				sheet.addMergedRegion(new CellRangeAddress(4, 4, 11, 12));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 0, 0));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 1, 1));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 2, 2));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 3, 3));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 4, 4));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 5, 5));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 6, 6));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 7, 7));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 8, 8));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 9, 9));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 10, 10));
				sheet.addMergedRegion(new CellRangeAddress(4, 5, 13, 13));
				sheet.addMergedRegion(new CellRangeAddress(3, 5, 14, 14));
	
				yearMonth = yearMonth.replace("-",""); // 2021-06 -> 202106
				// body만들기
				List<CarFormListVO> carFormList = ezCarService.getCarFormList2(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId(), yearMonth);
				for(int j=0; j<carFormList.size(); j++){
					row = sheet.createRow(j+6); // 7번째행부터 입력되어야한다
					
					for(int k=0; k<15; k++){
						cell = row.createCell(k);
						if(k==0){
							cell.setCellValue(carFormList.get(j).getRev_date());
						}else if(k==1){
							cell.setCellValue(carFormList.get(j).getRev_time()+"~"+carFormList.get(j).getRev_time2());
						}else if(k==2){
							cell.setCellValue(carFormList.get(j).getDriver_deptname());
						}else if(k==3){
							cell.setCellValue(carFormList.get(j).getDriver_name());
						}else if(k==4){
							cell.setCellValue(carFormList.get(j).getB_depart_time());
						}else if(k==5){
							cell.setCellValue(carFormList.get(j).getB_distance());
						}else if(k==6){
							cell.setCellValue(carFormList.get(j).getDrive_purpose());
						}else if(k==7){
							cell.setCellValue(carFormList.get(j).getDrive_point());
						}else if(k==8){
							cell.setCellValue(carFormList.get(j).getA_arrive_time());
						}else if(k==9){
							cell.setCellValue(carFormList.get(j).getA_distance());
						}else if(k==10){
							cell.setCellValue(carFormList.get(j).getA_distance_auto());
						}else if(k==11){
							cell.setCellValue(carFormList.get(j).getA_distance_commute());
						}else if(k==12){
							cell.setCellValue(carFormList.get(j).getA_distance_work());
						}else if(k==13){
							cell.setCellValue("       " + carFormList.get(j).getA_distance_etc() + "       ");
						}else if(k==14){
							if(carFormList.get(j).getA_submit_flag().equals("1")){
								cell.setCellValue("  YES  ");
							}else if(carFormList.get(j).getA_submit_flag().equals("0")){
								cell.setCellValue("  NO  ");
							}
						}
						cell.setCellStyle(bodyStyle);
						row.setHeight((short)384);
						sheet.autoSizeColumn(k);
						
						/* 2024-11-05 홍승비 - 엑셀 파일 저장 시 동적인 너비 계산이 setColumnWidth()에서 허용하는 최대 제한을 넘지 않도록 수정 (255 * 256 = 65280) */
					    sheet.setColumnWidth(k, Math.min(65280, sheet.getColumnWidth(k) + 3000));
					}
				}
				
				int lastrow =carFormList.size()+6+2; // 마지막 row +2
				int sum_commute = 0; // 주행거리합계_출퇴근
				int sum_work = 0; // 주행거리함계_일반업무
				int sum_worketc = 0; // 주행거리합계_업무외이용
				
				for(int i=0; i<carFormList.size(); i++){
						if(carFormList.get(i).getA_distance_commute()!= null && !carFormList.get(i).getA_distance_commute().equals("")){
							sum_commute = sum_commute + Integer.parseInt(carFormList.get(i).getA_distance_commute());
						}
						if(carFormList.get(i).getA_distance_work() != null && !carFormList.get(i).getA_distance_work().equals("")){
							sum_work = sum_work + Integer.parseInt(carFormList.get(i).getA_distance_work());
						}
						if(carFormList.get(i).getA_distance_etc() != null && !carFormList.get(i).getA_distance_etc().equals("")){
							sum_worketc = sum_worketc + Integer.parseInt(carFormList.get(i).getA_distance_etc());
						}
				}
				
				int a_distance = 0;
				int b_distance = 0;
				
				if(carFormList.get(carFormList.size()-1).getA_distance() != null && !carFormList.get(carFormList.size()-1).getA_distance().equals("")){
						a_distance = Integer.parseInt(carFormList.get(carFormList.size()-1).getA_distance());
				}else{
					 for(int i=carFormList.size()-1; i>=0; i--){
						     if(carFormList.get(i).getA_distance()!= null && !carFormList.get(i).getA_distance().equals("")){
						           a_distance = Integer.parseInt(carFormList.get(i).getA_distance());
						           break;
						     }
					}
				}
				if(carFormList.get(0).getB_distance() != null && !carFormList.get(0).getB_distance().equals("")){
						b_distance = Integer.parseInt(carFormList.get(0).getB_distance());
				}
				int errorRange = a_distance - b_distance - (sum_commute + sum_work);
				
				
				row = sheet.createRow(lastrow);
					cell = row.createCell(10);
					cell.setCellValue("주행거리합계");
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(10);
					sheet.setColumnWidth(10, (sheet.getColumnWidth(10)) + 512);
					
					cell = row.createCell(11);
					cell.setCellValue(sum_commute);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(11);
					sheet.setColumnWidth(11, (sheet.getColumnWidth(11)) + 512);
					
					cell = row.createCell(12);
					cell.setCellValue(sum_work);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(12);
					sheet.setColumnWidth(12, (sheet.getColumnWidth(12)) + 512);
					
					cell = row.createCell(13);
					cell.setCellValue(sum_worketc);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(13);
					sheet.setColumnWidth(13, (sheet.getColumnWidth(13)) + 512);
					
					
				row = sheet.createRow(lastrow+1);
					cell = row.createCell(10);
					cell.setCellValue("주행거리합계");
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(10);
					sheet.setColumnWidth(10, (sheet.getColumnWidth(10)) + 512);
					
					cell = row.createCell(11);
					cell.setCellValue(sum_commute+sum_work);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(11);
					sheet.setColumnWidth(11, (sheet.getColumnWidth(11)) + 512);
					
					cell = row.createCell(12);
					cell.setCellStyle(bodyStyle);
					
					cell = row.createCell(13);
					cell.setCellValue(" ");
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(13);
					sheet.setColumnWidth(13, (sheet.getColumnWidth(13)) + 512);
				
				
				row = sheet.createRow(lastrow+2);
					cell = row.createCell(10);
					cell.setCellValue("총 이용거리");
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(10);
					sheet.setColumnWidth(10, (sheet.getColumnWidth(10)) + 512);
					
					cell = row.createCell(11);
					cell.setCellValue(sum_commute+sum_work);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(11);
					sheet.setColumnWidth(11, (sheet.getColumnWidth(11)) + 512);
					
					cell = row.createCell(12);
					cell.setCellStyle(bodyStyle);
					
					cell = row.createCell(13);
					cell.setCellStyle(bodyStyle);
				
				row = sheet.createRow(lastrow+3);
					cell = row.createCell(10);
					cell.setCellValue("오차");
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(10);
					sheet.setColumnWidth(10, (sheet.getColumnWidth(10)) + 512);
					
					cell = row.createCell(11);
					cell.setCellValue(errorRange);
					cell.setCellStyle(bodyStyle);
					row.setHeight((short)512);
					sheet.autoSizeColumn(11);
					sheet.setColumnWidth(11, (sheet.getColumnWidth(11)) + 512);
					
					cell = row.createCell(12);
					cell.setCellStyle(bodyStyle);
					
					cell = row.createCell(13);
					cell.setCellStyle(bodyStyle);
				
				
				
				sheet.addMergedRegion(new CellRangeAddress(lastrow+1, lastrow+1, 11, 12));
				sheet.addMergedRegion(new CellRangeAddress(lastrow+2, lastrow+2, 11, 13));
				sheet.addMergedRegion(new CellRangeAddress(lastrow+3, lastrow+3, 11, 13));
			
				/* 2019-11-18 홍승비 - 전자결재문서 엑셀 저장 시 부서ID 대신 부서명을 파일명에 사용하도록 수정 */
				// 2020-10-08 김민성- 크롬에서 다운로드시 확장자 사라지는 오류 수정
				String pFileName = EgovDateUtil.getTodayTime().substring(0, 10) +"_"+carBrd.getCarName() +"_차량등록일지" + ".xls";
				response.setContentType("application/ms-excel");
				response.setCharacterEncoding("utf-8");
				response.setHeader("Content-Disposition", "attachment; filename=\"" + CommonUtil.getEncodedFileNameForDownload(request.getHeader("User-Agent"), pFileName) + "\"");
				
				workbook.write(response.getOutputStream());
				  
				//workbook.close();
			}
			
			logger.debug("excelExportOut ended"); 
		}
		
		/**
		 * 자원관리 권한없는 화면 호출 함수
		 */
		@RequestMapping(value = "/ezCar/nonResList.do", method = RequestMethod.GET)
		public String nonResList(@CookieValue("loginCookie") String loginCookie, HttpServletRequest req, Model model) throws Exception {
			LoginVO userInfo = commonUtil.userInfo(loginCookie);
			
			String accMessage = "";
			if (req.getParameter("msg") != null && !req.getParameter("msg").equals("")) {
				accMessage = req.getParameter("msg");
			}
			model.addAttribute("accMessage", commonUtil.cleanScriptValue(accMessage));
			model.addAttribute("userInfo", userInfo); 
			return "/ezCar/carNonResList";
		}
		
		 /**
	       * 차량 예약현황 조회 함수
	       */
	      @RequestMapping(value = "/ezCar/carRevItem.do", method = RequestMethod.GET)
	      public String carRevItem(@CookieValue("loginCookie") String loginCookie,HttpServletRequest req, Model model) throws Exception {
	    	  LoginVO userInfo = commonUtil.userInfo(loginCookie);
	          String carID = "";
	          
	          if(req.getParameter("carID") != null) {
	             carID = req.getParameter("carID");
	          }
	          
	          //필요한 정보 (오늘 년월일, carFormList(오늘 년월에 해당하는 list조회), car_Id, carName(carId로 조회해오기))
	          String currentDate = commonUtil.getTodayUTCTime("yyyy-MM"); //오늘날짜
	          
	          if(req.getParameter("date") != null){
	              currentDate = req.getParameter("date");
	           }
	          
	          currentDate = currentDate.replace("-", "");
	          currentDate = currentDate.replace(" ", "");
	          
	            CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
	          String carName = carBrd.getCarName();
	          String car_nm = carBrd.getCar_nm();
	          List<CarFormListVO> carFormList = ezCarService.getCarFormList2(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId(), currentDate);
	          
	  		
	          model.addAttribute("carID", carID);
	          model.addAttribute("carFormList", carFormList);
	          model.addAttribute("carName", carName);
	          model.addAttribute("car_nm", car_nm);
	          model.addAttribute("companyID", userInfo.getCompanyID());
	          model.addAttribute("userID", userInfo.getId());
	          model.addAttribute("deptID", userInfo.getDeptID());
	          
	          logger.debug("carFormList End");
	         
	         return "/ezCar/carRevItem";
	      }
	      
	      
	      
	      /**
	       * 차량 예약현황 ajax
	       */
	      @RequestMapping(value="/ezCar/carRevItemAjax.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")   
	      public String carRevItemAjax(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
	    	  
	    	  LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    	  String carID = "";
	    	  
	    	  if(request.getParameter("carID") != null) {
	    		  carID = request.getParameter("carID");
	    	  }
	    	  
	    	  //필요한 정보 (오늘 년월일, carFormList(오늘 년월에 해당하는 list조회), car_Id, carName(carId로 조회해오기))
	    	  String currentDate = commonUtil.getTodayUTCTime("yyyy-MM"); //오늘날짜
	    	  
	    	  if(request.getParameter("date") != null){
	    		  currentDate = request.getParameter("date");
	    	  }
	    	  
	    	  currentDate = currentDate.replace("-", "");
	    	  currentDate = currentDate.replace(" ", "");
	    	  
	    	  CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
	    	  String carName = carBrd.getCarName();
	    	  String car_nm = carBrd.getCar_nm();
	    	  List<CarFormListVO> carFormList = ezCarService.getCarFormList2(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId(), currentDate);
	    	  
	   
	    	  model.addAttribute("carID", carID);
		      model.addAttribute("carFormList", carFormList);
		      String count = String.valueOf(carFormList.size());
		      model.addAttribute("carName", carName);
		      model.addAttribute("car_nm", car_nm);
		      model.addAttribute("companyID", userInfo.getCompanyID());
		      model.addAttribute("userID", userInfo.getId());
		      model.addAttribute("deptID", userInfo.getDeptID());
		         
		      logger.debug("carFormList End");
		      return "json";
	      }
	      
	      /**
	       * 차량 예약현황 ajax
	       */
	      @RequestMapping(value="/ezCar/carRevItemExceptcarFormIdAjax.do", method = RequestMethod.GET, produces = "text/xml; charset=utf-8")   
	      public String carRevItemExceptcarFormIdAjax(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, HttpServletResponse response, LoginSimpleVO loginSimpleVO, Model model) throws Exception {
	    	  
	    	  LoginVO userInfo = commonUtil.userInfo(loginCookie);
	    	  String carID = "";
	    	  String carFormID = "";
	    	  
	    	  if(request.getParameter("carID") != null) {
	    		  carID = request.getParameter("carID");
	    	  }
	    	  
	    	  //필요한 정보 (오늘 년월일, carFormList(오늘 년월에 해당하는 list조회), car_Id, carName(carId로 조회해오기))
	    	  String currentDate = commonUtil.getTodayUTCTime("yyyy-MM"); //오늘날짜
	    	  
	    	  if(request.getParameter("date") != null){
	    		  currentDate = request.getParameter("date");
	    	  }
	    	  if(request.getParameter("carFormID") != null){
	    		  carFormID = request.getParameter("carFormID");
	    	  }
	    	  
	    	  currentDate = currentDate.replace("-", "");
	    	  currentDate = currentDate.replace(" ", "");
	    	  
	    	  CarBrdVO carBrd = ezCarService.getBrd(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId());
	    	  String carName = carBrd.getCarName();
	    	  String car_nm = carBrd.getCar_nm();
	    	  List<CarFormListVO> carFormList = ezCarService.getCarFormList3(Integer.parseInt(carID), userInfo.getCompanyID(), userInfo.getTenantId(), currentDate, carFormID); //현재formid에있는 시간정보들빼고 가져옴
	    	  
	    	  
	    	  model.addAttribute("carID", carID);
	    	  model.addAttribute("carFormList", carFormList);
	    	  String count = String.valueOf(carFormList.size());
	    	  model.addAttribute("carName", carName);
	    	  model.addAttribute("car_nm", car_nm);
	    	  model.addAttribute("companyID", userInfo.getCompanyID());
	    	  model.addAttribute("userID", userInfo.getId());
	    	  model.addAttribute("deptID", userInfo.getDeptID());
	    	  
	    	  logger.debug("carFormList End");
	    	  return "json";
	      }
	      
	      
	     
	     
}