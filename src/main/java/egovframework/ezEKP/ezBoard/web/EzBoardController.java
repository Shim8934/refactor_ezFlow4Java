package egovframework.ezEKP.ezBoard.web;

import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzBoardController {
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Autowired
	private Properties config;
	
	@Resource(name="loginService")
	private LoginService loginService;
	
	@Resource(name="crypto") 
    private EgovFileScrty egovFileScrty;
 
	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;

	@Resource(name="EzOrganService")
	private EzOrganService ezOrganService;
	
	@Resource(name="egovMessageSource")
    private EgovMessageSource egovMessageSource;
	
	@RequestMapping(value="/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("userID") String userID, HttpServletRequest request, ModelMap modelMap, LoginVO loginVO) throws Exception{
		String redirectBoardID = "";
        String redirectBoardGroupID = "";
        String func = "";
        String subFunc = "";
        String photoType = "";
        String applyFlag = "";
        //유저정보 가져오기 아직 미구현이므로 고정값으로 테스트 @수정요망@
        loginVO = commonUtil.userInfo(userID);
        
        String strLang = "1";
		String pUserID = loginVO.getId();
		String pDeptID = loginVO.getDeptID();
		String pCompanyID = loginVO.getCompanyID();
		String pRollInfo = "c=1;k=1;g=1;a=1;i=1;n=1;l=1;w=1;m=1;";
		
		if(request.getParameter("PhotoType") != null){
			photoType  = request.getParameter("PhotoType");
		}
		
		if(request.getParameter("BoardID") != null){
			redirectBoardID  = request.getParameter("BoardID");
			
			List<EzBoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID);
			for(EzBoardVO i :  leftBoardList){
				redirectBoardGroupID += i.getBoardGroupId()+",";
			}
			if(redirectBoardGroupID.length() != 0)
				redirectBoardGroupID = redirectBoardGroupID.substring(0, redirectBoardGroupID.length()-1);
		}
		
		if(request.getParameter("Func") != null){
			func = request.getParameter("Func");
		}
		
		if(request.getParameter("subFunc") != null){
			subFunc = request.getParameter("subFunc");
		}
		
		String pRootBoardID = "top";
		String pSubFlag = "0";
        int pSelectBy = 0;
        String pExcludeBoardID = " ";
//     String BoardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID,pUserID,pDeptID,pCompanyID);
        String BoardGroupAdmin_FG = "OK";
        List<EzBoardVO> ApplyUserList = ezBoardAdminService.checkApplyUser();
        
        for(EzBoardVO vo: ApplyUserList){
        	if(vo.getApprUserId().toLowerCase().indexOf(pUserID.toLowerCase()) > -1){
        		applyFlag = "OK";
        	}
        }
        int pMode = 0;
        if (BoardGroupAdmin_FG == "OK" || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("k=1") > -1 || pRollInfo.toLowerCase().indexOf("n=1") > -1){
        	pMode = 0;
        }else{
        	pMode = 1;
        }
        //Library 연결 부분 Method화
        List<BoardTreeVO> boardTreeVOList = getBoardTree(pRootBoardID,pUserID,pDeptID,pCompanyID,pMode,Integer.parseInt(pSubFlag),pSelectBy,pExcludeBoardID,getMultiData(strLang));
        
        modelMap.addAttribute("boardTreeVOList", boardTreeVOList);
        modelMap.addAttribute("userInfo", loginVO);
        
		return "ezBoard/boardLeft";
	}
	
	private LoginVO createUserInfo(LoginVO loginVO) throws Exception{
		String userId = egovFileScrty.getUserID(loginVO.getId());
		loginVO.setId(userId);
		loginVO.setPassword("LOGIN");		
		LoginVO user = loginService.selectUser(loginVO);
		
		return user;
	}

	private List<BoardTreeVO> getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pStrLang) throws Exception{
		String strXML = "";
        String strForbiddenBoardIDList = "";
		int count = 0;
		//EZSP_GETBOARDTREE_GET1 프로시져
        String retValue = ezBoardAdminService.getBoardTree_Get1(pStrLang,pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID);
        //DB에 XML 형식으로 박혀있어서 XML로 할지 VO로 할지 고민중 @수정요망@
//        if (retValue.length() > 30)
//        {
//        		map.addAttribute("retValue", retValue);
//          	return "ezBoard/left_boardStd";
//        }
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID) + ",everyone";
        //ActiveDirectory 부분 삭제해야할듯? @수정요망@ 
//        String strRollInfo = getPropertyValue(pUserID, "extensionattribute1");
        
        List<BoardTreeVO> brdBoardTreeList = new ArrayList<BoardTreeVO>();
        for (int i = 0; i < pAccessID.split(",").length; i++)
        {
            String temp1 = "";
            String temp2 = "";
            String temp3 = "1";
            brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID,pAccessID.split(",")[i].trim(),pMode,pSelectBy,pExcludeBoardID);
            
            List<EzBoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(pAccessID.split(",")[i].trim(),pRootBoardID);
            String tempstr = ""; 
            for(EzBoardVO j :  boardTreeList){
            	tempstr += j.getBoardGroupId() + ",";
			}
            if(tempstr.length() != 0)
            	tempstr = tempstr.substring(0, tempstr.length()-1);
            
            if (tempstr.indexOf(";") > -1){
                for (int r = 0; r < tempstr.split(";").length - 1; r++){
                   strForbiddenBoardIDList += tempstr.split(";")[r].trim() + ";";
                }
            }
            if(brdBoardTreeList.get(0).getBoardGroupAcl() != null){
            	if (pAccessID.split(";")[i].trim() != pUserID && pAccessID.split(";")[i].trim() != pCompanyID && pAccessID.split(";")[i].trim() != pDeptID){
            		for (int j = 0; j < brdBoardTreeList.size(); j++){
            			if (pAccessID.split(",")[i].trim() != "top"){
            				if (brdBoardTreeList.get(j).getBoardGroupAcl().toUpperCase() == "N"){
            					brdBoardTreeList.remove(j);
            					j--;
            				}
            			}
            		}
            	}
            }
        }

        for (int i = 0; i < brdBoardTreeList.size(); i++)
        {
        	brdBoardTreeList.get(i).setExpanded("FALSE");
        	brdBoardTreeList.get(i).setIsLeaf(checkIfLeafBoard(brdBoardTreeList.get(i).getBoardId()));
            if (count == 0 && pSubFlag != 1)    //게시판그룹을 클릭했을 때 첫번째 게시판을 자동선택 되게함
            	brdBoardTreeList.get(i).setSelect("TRUE");
            count++;
        }
        ezBoardAdminService.getBoardTree_Set(pStrLang.trim(),pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID,brdBoardTreeList.toString());
		return brdBoardTreeList;
	}

	public String getMultiData(String strLang){
		//web.config 부분이라 차후 @수정요망@
//        if (strLang != GetSystemConfigValue("primary").ToString())
		if(strLang != "1")
            return "2";
        else
            return "";
    }
	
	public String checkIfLeafBoard(String pBoardID) throws Exception{
		try
		{
	        int ret = ezBoardAdminService.checkIfLeafBoard(pBoardID);
	        if (ret > 0) 
	        	return "FALSE";
			else 
				return "TRUE";
		}
		catch(Exception Ex)
		{
			return "FALSE";
		}
	}
	
	@RequestMapping(value="/ezBoard/boardItemList_favorite.do")
	public String boardItemList_favorite() throws Exception{
    	return "ezBoard/boardItemList_favorite";
	}
	
	@RequestMapping(value="/ezBoard/get_favoriteList.do")
	public String get_favoriteList(@CookieValue("userID") String userID, ModelMap modelMap,HttpServletRequest request,LoginVO loginVO) throws Exception{
		loginVO.setId(userID);
		loginVO = createUserInfo(loginVO);
		List<MyFavoriteVO> resultList = new ArrayList<MyFavoriteVO>();
        String pMode = request.getParameter("MODE");
        String pUserID = loginVO.getId();
        //즐겨찾기 리스트
        resultList = ezBoardService.get_favoriteList(pUserID,pMode);
        String parentName = parentBoardName(resultList);
        
        modelMap.addAttribute("parentName", parentName);
        modelMap.addAttribute("resultList", resultList);
        
		return "json";
	}
	
	
	@RequestMapping(value="/ezBoard/boardConfig.do")
	public String boardConfig() throws Exception {
		return "ezBoard/boardConfig";
	}
	
	@RequestMapping(value="/ezBoard/boardGeneral.do")
	public String boardGeneral() throws Exception {
		return "ezBoard/boardGeneral";
	}
	
	@RequestMapping(value="/ezBoard/boardFavorite.do")
	public String boardFavorite() throws Exception {
		return "ezBoard/boardFavorite";
	}
	
	private String parentBoardName(List<MyFavoriteVO> resultList) throws Exception
    {
        String rtv = "";
        String BoardIdList = "";
        int BoardIdListCount = 0;
        for (int i = 0; i < resultList.size(); i++)
        {
            BoardIdList += resultList.get(i).getBoardId().trim();
            if (i != resultList.size() - 1)
                BoardIdList += ";";
        }
        BoardIdListCount = BoardIdList.split(";").length - 1;
        rtv = ezBoardService.get_parentBoardName(BoardIdList.trim(),BoardIdListCount);
        
        return rtv;
    }
	
   @RequestMapping(value="/ezBoard/getMyBoards_Config.do")
   public void getMyBoards_Config(HttpServletRequest req){
	   String UserID = "yoonz44";
	   String lang = "";
	   try
       {
           String pRootTreeID = "";
           String pCountFlag = "";
           String USE_BOARD_LEFTMENU_COUNT = "YES";
           if(req.getParameter("RootTreeID") != null)
               pRootTreeID = req.getParameter("RootTreeID");
           if(req.getParameter("COUNTFLAG") != null)
               pCountFlag = req.getParameter("COUNTFLAG");

           String strXML = getMyBoardTreeConfig(UserID, pRootTreeID, lang);
//	           strXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"+strXML;
System.out.println("@@@@@@@@@@@@@@@"+strXML);
           
           DocumentBuilderFactory docBuildFact = DocumentBuilderFactory.newInstance();
           DocumentBuilder docBuilder = docBuildFact.newDocumentBuilder();
           Document doc = docBuilder.parse(new InputSource(new StringReader(strXML)));
           Element element = doc.getDocumentElement();
           NodeList list = element.getChildNodes();

System.out.println(list.item(0).getChildNodes().item(4).getFirstChild().getNodeValue());
//	           if (strXML.substring(0, 5).toUpperCase() != "ERROR")
//	           {
//	               if(USE_BOARD_LEFTMENU_COUNT.toString() == "YES" && pCountFlag == "YES")
//	               {
//	                   NodeList docListNode = element.getElementsByTagName("NODE");
//	                   if (docListNode != null)
//	                   {
//	                       try
//	                       {
//
//	                           String strName = "";
//	                           int intCount;
//	                           for (int i = 0; i < docListNode.getLength(); i++)
//	                           {
//	                               if (docListNode.item(i).getChildNodes().item(4).getFirstChild().getNodeValue().trim() == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")
//	                               {
//	                                   cmd1 = new OracleCommand("ezSp_BrdNewItemCount");
//	                                   cmd1.CommandType = CommandType.StoredProcedure;
//	                                   cmd1.Parameters.Add("v_pUserID", OracleType.NVarChar, 20).Value = userinfo.UserID;
//	                                   cmd1.Parameters.Add("v_pNow", OracleType.NVarChar, 20).Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
//	                                   cmd1.Parameters.Add("v_pFromNow", OracleType.NVarChar, 20).Value = DateTime.Now.AddDays(-5).ToString("yyyy-MM-dd HH:mm:ss");
//	                                   cmd1.Parameters.Add("v_pCount", OracleType.Number).Direction = ParameterDirection.Output;
//	                                   intCount = GetQueryValueSP(ref cmd1);
//
//	                                   if (intCount != 0)
//	                                       strName = "(" + intCount.ToString() + ")";
//	                                   docListNode.Item(i).ChildNodes.Item(0).InnerText = docListNode.Item(i).ChildNodes.Item(0).InnerText + strName;
//
//	                               }
//	                               else
//	                               {
//	                                   if (docListNode.Item(i).ChildNodes.Item(5).InnerText.Trim() == "BOARD")
//	                                   {
//	                                       GetBoardInfo(docListNode.Item(i).ChildNodes.Item(4).InnerText.Trim());
//	                                       if (boardinfo.gubun == "4")
//	                                       {
//	                                           cmd1 = new OracleCommand("EZSP_GETTHUMBNAILCOUNT");
//	                                       }
//	                                       else
//	                                       {
//	                                           cmd1 = new OracleCommand("ezSp_BrdTotalItemCount");
//	                                       }
//	                                       cmd1.CommandType = CommandType.StoredProcedure;
//	                                       cmd1.Parameters.Add("v_pBoardID", OracleType.NChar, 38).Value = docListNode.Item(i).ChildNodes.Item(4).InnerText;
//	                                       cmd1.Parameters.Add("v_pNow", OracleType.NVarChar, 20).Value = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
//	                                       cmd1.Parameters.Add("v_pUserid", OracleType.NVarChar, 50).Value = userinfo.UserID;
//	                                       cmd1.Parameters.Add("v_pType", OracleType.Char, 1).Value = "1";
//	                                       cmd1.Parameters.Add("v_pCount", OracleType.Number).Direction = ParameterDirection.Output;
//	                                       intCount = GetQueryValueSP(ref cmd1);
//	                                       strName = "";
//	                                       if (intCount != 0)
//	                                           strName = "(" + intCount.ToString() + ")";
//	                                       docListNode.Item(i).ChildNodes.Item(0).InnerText = docListNode.Item(i).ChildNodes.Item(0).InnerText + strName;
//	                                   }
//	                               }
//	                           }
//	                       }
//	                       finally
//	                       {
//	                           if (cmd1 != null)
//	                               cmd1.Dispose();
//	                       }
//	                   }
//	               }
//	           }
//	           else
//	               xmlret = GetXmlReaderString("<RESULT>ERROR</RESULT>");
//
//	           Response.ContentType = "text/xml";
//	           xmlret.Save(Response.OutputStream);
//	           xmlret = null;

       }
       catch (Exception ex)
       {
    	   ex.printStackTrace();
       }
   }
	
	public String getMyBoardTreeConfig(String userID,String pRootTreeID,String lang) throws Exception{
        List<MyFavoriteVO> resultList  = ezBoardAdminService.getMyBoardTree_get3(userID,pRootTreeID.trim());
        StringBuilder sb = new StringBuilder();

        sb.append("<TREEVIEWDATA>");

        for (int i = 0; i < resultList.size(); i++)
        {
            sb.append("<NODE>");
            sb.append("<VALUE><![CDATA[" + resultList.get(i).getTreeName().trim() + "]]></VALUE>");
            sb.append("<STYLE><![CDATA[]]></STYLE>");
            sb.append("<DATA1>" + resultList.get(i).getTreeId() + "</DATA1>");
            sb.append("<DATA2><![CDATA[" + resultList.get(i).getTreeName().trim() + "]]></DATA2>");
            sb.append("<DATA3><![CDATA[" + resultList.get(i).getTreeBoardId() + "]]></DATA3>");
        	if(resultList.get(i).getTreeBoardId() == "")
                sb.append("<DATA4>TREE</DATA4>");
            else
                sb.append("<DATA4>BOARD</DATA4>");
            sb.append("<DATA5></DATA5>");

            sb.append("<EXPANDED>FALSE</EXPANDED>");

            if(resultList.get(i).getChildCnt() > 0)
                sb.append("<ISLEAF>FALSE</ISLEAF>");
            else
                sb.append("<ISLEAF>TRUE</ISLEAF>");

            if (resultList.get(i).getTreeBoardId() == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")	//새 게시판 자동선택
                sb.append("<SELECT>TRUE</SELECT>");
            sb.append("</NODE>");
        }

        sb.append("</TREEVIEWDATA>");

        return sb.toString();
	}
	@RequestMapping(value="/ezBoard/boardItemList_new.do")
	public String boardItemList_new(HttpServletRequest request, HttpServletResponse response, LoginVO loginVO,BoardPropertyVO boardPropertyVO, @CookieValue("userID") String userID, Model model) throws Exception{
		String pBoardID = boardPropertyVO.getBoardID();
        String use_ocs = config.getProperty("config.Use_OCS");; 
        String use_Editor = config.getProperty("config.editor");; 
        String use_IE11Browser = config.getProperty("config.IE11editor");;
        String use_oneLineCount = "";
        
        loginVO = commonUtil.userInfo(userID);
        if ((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && use_IE11Browser.equals("CK"))
            use_IE11Browser = "CK";
        
//            response.Buffer = true;
//            if (vpnLogin != null)
//                isVPN = vpnLogin;
        boardPropertyVO = getBoardInfo(pBoardID,loginVO);
        boardPropertyVO = getBoardProperty(pBoardID);
        if (boardPropertyVO != null)
            use_oneLineCount = "YES";
        else
            use_oneLineCount = "NO";
        
        if (boardPropertyVO.getListViewFG()== "true")
        {
            if (request.getParameter("Page") == null)
            	boardPropertyVO.setPage(1);
        }
        model.addAttribute("boardInfo", boardPropertyVO);
        model.addAttribute("userInfo", loginVO);
        model.addAttribute("use_ocs", use_ocs);
        model.addAttribute("use_Editor", use_Editor);
        model.addAttribute("use_IE11Browser", use_IE11Browser);
        model.addAttribute("use_oneLineCount", use_oneLineCount);
        
        return "ezBoard/boardItemList_new";
	}

	// OCS Presence
    public String getEmail(String userid)
    {
        String email = "";
        try
        {
            email = ezOrganService.getPropertyValue(userid, "mail");
            return email;
        }
        catch (Exception ex)
        {
            return email;
        }
    }

    // OCS Presence
    public String getSIPListByCNList(String[] pCNList)
    {
        String strRet = "";
        try
        {
            if (pCNList == null || pCNList.length == 0)
            {
                return null;
            }
            strRet = ezOrganService.getSIPUriList(StringUtils.join(pCNList, ";"), "");

            return strRet;
        }
        catch (Exception ex)
        {
            return strRet;
        }
    }
    
    public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception
    {
        BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(pBoardID);
        return boardPropertyVO;
    }
    
    // 게시판의 정보를 가져오는 함수
	protected BoardPropertyVO getBoardInfo(String pBoardID, LoginVO userInfo) throws Exception
	{
		BoardPropertyVO boardInfo = new BoardPropertyVO();
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);             

		if (pBoardID == "")
		{
			boardInfo.setBoardName(egovMessageSource.getMessage("t229"));		
			return null;
		}

        //-- 조직도 Deptpath 역순으로 가져온것을 순방향으로 변환 2008.01.29 이성조
		String deptPath = userInfo.getDeptPathCode();
	    String deptPathOrgan="";
	    for(int ch=0; ch<deptPath.split(",").length; ch++)
	    {
	        if(ch==0)
	            deptPathOrgan+=deptPath.split(",")[ch].trim();
	        else
	            deptPathOrgan+=","+deptPath.split(",")[deptPath.split(",").length-(ch)].trim();
	    }
	    
//	    String userDeptPath = deptPathOrgan+",everyone";
	    
//		for (int i=0; i<userDeptPath.split(",").length; i++)
//		{
//			boardInfo = ezBoardAdminService.getACL(pBoardID, userDeptPath.split(",")[i].trim());
//			if(boardInfo == null)
//				break;
//		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
         if (pBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")	// 새 게시 게시판인 경우
		{
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}
		else if (userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1)
		{
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}
         else if (boardInfo.getBoardGroupAdmin_FG() == "OK")	// 게시판 그룹관리자는 하위게시판들에 대해 풀권한을 가짐
		{
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}
		else if (boardInfo.equals(null))
		{
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}

         BoardPropertyVO strProp = getBoardProperty(pBoardID);

         if(strProp != null){
        	 boardInfo.setExpireDays(strProp.getItemExpires());
        	 boardInfo.setAttachLimit(strProp.getAttachLimit());
        	 boardInfo.setBoardName1(strProp.getBoardName().replace("\"\"", "&quot"));
        	 boardInfo.setBoardName2(strProp.getBoardName2().replace("\"\"", "&quot"));
        	 
         if (userInfo.getPrimary() == "2" && boardInfo.getBoardName2() != "")
         {
             boardInfo.setBoardName(boardInfo.getBoardName2());
         }
         else
         {
             boardInfo.setBoardName(boardInfo.getBoardName1());
         }
			 boardInfo.setReplyNotify(strProp.getReplyNotify());
			 boardInfo.setGuBun(strProp.getGuBun());
			 boardInfo.setUrl(strProp.getUrl());
	         boardInfo.setApprMail_FG(strProp.getApprMailFlag());
	         boardInfo.setAttributeYN(strProp.getAttributeYN());
		}
         return boardInfo;
	}
    protected boolean CheckDBColum(String pProvValue) throws Exception
    {
        boolean bRet = false;
        // 사용자 속성명
        switch (pProvValue.toUpperCase())
        {
            case "CN":
                bRet = true;
                break;
            case "DISPLAYNAME":
                bRet = true;
                break;
            case "DISPLAYNAME1":
                bRet = true;
                break;
            case "DISPLAYNAME2":
                bRet = true;
                break;
            case "MAIL":
                bRet = true;
                break;
            case "MAILNICKNAME":
                bRet = true;
                break;
            case "UPNNAME":
                bRet = true;
                break;
            case "DEPARTMENT":
                bRet = true;
                break;
            case "DESCRIPTION":
                bRet = true;
                break;
            case "DESCRIPTION1":
                bRet = true;
                break;
            case "DESCRIPTION2":
                bRet = true;
                break;
            case "PHYSICALDELIVERYOFFICENAME":
                bRet = true;
                break;
            case "COMPANY":
                bRet = true;
                break;
            case "COMPANY1":
                bRet = true;
                break;
            case "COMPANY2":
                bRet = true;
                break;
            case "TITLE":
                bRet = true;
                break;
            case "TITLE1":
                bRet = true;
                break;
            case "TITLE2":
                bRet = true;
                break;
            case "TELEPHONENUMBER":
                bRet = true;
                break;
            case "HOMEPHONE":
                bRet = true;
                break;
            case "FACSIMILETELEPHONENUMBER":
                bRet = true;
                break;
            case "MOBILE":
                bRet = true;
                break;
            case "POSTALCODE":
                bRet = true;
                break;
            case "STREETADDRESS":
                bRet = true;
                break;
            case "INFO":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE1":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE2":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE3":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE4":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE5":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE6":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE7":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE8":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE9":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE10":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE101":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE102":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE11":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE12":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE13":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE14":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE15":
                bRet = true;
                break;
            case "ADSPATH":
                bRet = true;
                break;
            case "UPDATEDT":
                bRet = true;
                break;
            case "SIPURI":
                bRet = true;
                break;
            case "BIRTH":
                bRet = true;
                break;
            case "BIRTHTYPE":
                bRet = true;
                break;
        }

        // 부서명
        switch (pProvValue.toUpperCase())
        {
            case "CN":
                bRet = true;
                break;
            case "DISPLAYNAME":
                bRet = true;
                break;
            case "DISPLAYNAME1":
                bRet = true;
                break;
            case "DISPLAYNAME2":
                bRet = true;
                break;
            case "USEFLAG":
                bRet = true;
                break;
            case "COMPANY":
                bRet = true;
                break;
            case "COMPANY1":
                bRet = true;
                break;
            case "COMPANY2":
                bRet = true;
                break;
            case "DEPTLEVEL":
                bRet = true;
                break;
            case "DEPT_CD_PATH":
                bRet = true;
                break;
            case "DEPT_NM_PATH":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE1":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE2":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE3":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE4":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE5":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE6":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE7":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE8":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE9":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE10":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE11":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE12":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE13":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE14":
                bRet = true;
                break;
            case "EXTENSIONATTRIBUTE15":
                bRet = true;
                break;
            case "ADFLAG":
                bRet = true;
                break;
            case "ADSPATH":
                bRet = true;
                break;
            case "UPDATEDT":
                bRet = true;
                break;
        }
        return bRet;
    }
}
