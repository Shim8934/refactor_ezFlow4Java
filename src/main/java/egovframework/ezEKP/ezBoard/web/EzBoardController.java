package egovframework.ezEKP.ezBoard.web;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.net.URLEncoder;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardAttributeVO;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.BoardVO;
import egovframework.ezEKP.ezBoard.vo.BoardMyFavoriteVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
import egovframework.let.utl.sim.service.EgovFileScrty;

@Controller
public class EzBoardController extends EgovFileMngUtil{
	
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
	
	private static final Logger LOGGER = LoggerFactory.getLogger(EgovFileMngUtil.class);
	
	@RequestMapping(value="/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, ModelMap modelMap, LoginVO loginVO, HttpServletResponse response) throws Exception{
		String redirectBoardID = "";
        String redirectBoardGroupID = "";
        String func = "";
        String subFunc = "";
        String photoType = "";
        String applyFlag = "";
        //유저정보 가져오기 아직 미구현이므로 고정값으로 테스트 @수정요망@
        loginVO = commonUtil.userInfo(loginCookie);
        
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
			
			List<BoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(redirectBoardID);
			for(BoardVO i :  leftBoardList){
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
		
		int pSelectBy = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
        String pExcludeBoardID = " ";
        String BoardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID,pUserID,pDeptID,pCompanyID);
        
        List<BoardVO> ApplyUserList = ezBoardAdminService.checkApplyUser();
        
        for(BoardVO vo: ApplyUserList){
        	if(vo.getApprUserId().toLowerCase().indexOf(pUserID.toLowerCase()) > -1){
        		applyFlag = "OK";
        	}
        }
        int pMode = 0;
        if(BoardGroupAdmin_FG == "OK" || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("c=1") > -1 || pRollInfo.toLowerCase().indexOf("k=1") > -1 || pRollInfo.toLowerCase().indexOf("n=1") > -1){
        	pMode = 0;
        }else{
        	pMode = 1;
        }
        //Library 연결 부분 Method화
        String resultXML = getBoardTree(pRootBoardID,pUserID,pDeptID,pCompanyID,pMode,Integer.parseInt(pSubFlag),pSelectBy,pExcludeBoardID,commonUtil.getMultiData(strLang));
        
        modelMap.addAttribute("userInfo", loginVO);
        modelMap.addAttribute("resultXML", resultXML);
        modelMap.addAttribute("func",func);
        modelMap.addAttribute("subFunc",subFunc);
        modelMap.addAttribute("photoType",photoType);
        modelMap.addAttribute("applyFlag",applyFlag);
        
		return "ezBoard/boardLeft";
	}
	
	public String getBoardTree(String pRootBoardID, String pUserID, String pDeptID, String pCompanyID, int pMode, int pSubFlag, int pSelectBy, String pExcludeBoardID, String pStrLang) throws Exception{
		int count = 0;
        String strForbiddenBoardIDList = "";				
		StringBuilder strResult = new StringBuilder();
		/* EZSP_GETBOARDTREE_GET1 프로시져 */
        String retValue = ezBoardAdminService.getBoardTree_Get1(pStrLang,pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID);
        
        if(retValue != null && retValue.length() > 30){
    		return retValue;
        }
        
        String pAccessID = pUserID + "," + ezOrganService.getDeptFullPath(pDeptID) + ",everyone";
        String strRollInfo = ezOrganService.getPropertyValue(pUserID, "extensionattribute1");        
        List<BoardTreeVO> brdBoardTreeList = new ArrayList<BoardTreeVO>();
        
        for(int i = 0; i < pAccessID.split(",").length; i++){
            String boardID = "";
            
            brdBoardTreeList = ezBoardAdminService.brdBoardTree(pRootBoardID,pAccessID.split(",")[i].trim(),pMode,pSelectBy,pExcludeBoardID);            
            List<BoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(pAccessID.split(",")[i].trim(),pRootBoardID);
            
            if(boardTreeList.size() > 0){
                for(int r = 0; r < boardTreeList.size() - 1; r++){
                	boardID = boardTreeList.get(r).getBoardId();
                	
                    if(strResult.toString().indexOf(boardID.trim()) == -1) 
                        strForbiddenBoardIDList += boardID.trim();
                }
            }
            if(brdBoardTreeList.size() > 0){
            	if(brdBoardTreeList.get(0).getBoardGroupAcl() != null){
            		if(pAccessID.split(";")[i].trim() != pUserID && pAccessID.split(";")[i].trim() != pCompanyID && pAccessID.split(";")[i].trim() != pDeptID){
            			for (int j = 0; j < brdBoardTreeList.size(); j++){
            				if(pAccessID.split(",")[i].trim() != "top"){
            					if(brdBoardTreeList.get(j).getBoardGroupAcl().toUpperCase() == "N"){
            						brdBoardTreeList.remove(j);
            						j--;
            					}
            				}
            			}
            		}
            	}
            }
        }
        StringBuilder result = new StringBuilder();
        
        if(pSubFlag ==1){
        	result.append("<NODES>");
        }else{
        	result.append("<TREEVIEWDATA>");
        }
        
        for(int i = 0; i < brdBoardTreeList.size(); i++){
        	if(strRollInfo.toLowerCase().indexOf("c=1") == -1 && strRollInfo.toLowerCase().indexOf("k=1") == -1 && strRollInfo.toLowerCase().indexOf("n=1") == -1){
                if(strForbiddenBoardIDList.indexOf(brdBoardTreeList.get(i).getBoardId()) > -1) continue;
            }
        	result.append("<NODE>");
        	
        	if(pStrLang.equals("")){
        		result.append("<VALUE><![CDATA[" + brdBoardTreeList.get(i).getBoardName() + "]]></VALUE>");
        	}else{
        		result.append("<VALUE><![CDATA[" + brdBoardTreeList.get(i).getBoardName2() + "]]></VALUE>");
        	}        	
            result.append("<STYLE><![CDATA[]]></STYLE>");
            result.append("<DATA1>" + brdBoardTreeList.get(i).getBoardId() + "</DATA1>");
            
            if(pStrLang.equals("")){
            	result.append("<DATA2><![CDATA[" + brdBoardTreeList.get(i).getBoardName() + "]]></DATA2>");
            }else{
            	result.append("<DATA2><![CDATA[" + brdBoardTreeList.get(i).getBoardName2() + "]]></DATA2>");
            }            
            result.append("<DATA3>" + pRootBoardID + "</DATA3>");
            result.append("<DATA4>" + brdBoardTreeList.get(i).getBoardColor() + "</DATA4>");
            result.append("<DATA5>" + brdBoardTreeList.get(i).getGuBun() + "</DATA5>"); //20070228 포토게시판관련으로 추가함
            result.append("<EXPANDED>FALSE</EXPANDED>");
            result.append("<ISLEAF>" + checkIfLeafBoard(brdBoardTreeList.get(i).getBoardId()) + "</ISLEAF>");

            if(count == 0 && pSubFlag != 1)    //게시판그룹을 클릭했을 때 첫번째 게시판을 자동선택 되게함
                result.append("<SELECT>TRUE</SELECT>");

            result.append("</NODE>");
            count++;
        }
        
        if(pSubFlag == 1)
            result.append("</NODES>");
        else
            result.append("</TREEVIEWDATA>");
        
        ezBoardAdminService.getBoardTree_Set(pStrLang.trim(),pRootBoardID + "," + pUserID + "," + pDeptID + "," + pCompanyID + "," + pMode + "," + pSubFlag + "," + pSelectBy + "," + pExcludeBoardID, result.toString());

        return result.toString();
	}

	public String checkIfLeafBoard(String pBoardID) throws Exception{
		try{
	        int ret = ezBoardAdminService.checkIfLeafBoard(pBoardID);
	        if(ret > 0) 
	        	return "FALSE";
			else 
				return "TRUE";
		}catch(Exception ex){
			return "FALSE";
		}
	}
	
	@RequestMapping(value="/ezBoard/boardItemList_favorite.do")
	public String boardItemList_favorite() throws Exception{
    	return "ezBoard/boardItemList_favorite";
	}
	
	@RequestMapping(value="/ezBoard/get_favoriteList.do")
	public void get_favoriteList(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception{
	
		loginVO = commonUtil.userInfo(loginCookie);
		List<BoardMyFavoriteVO> resultList = new ArrayList<BoardMyFavoriteVO>();
        String pMode = request.getParameter("MODE");
        String pUserID = loginVO.getId();
        //즐겨찾기 리스트
        resultList = ezBoardService.get_favoriteList(pUserID,pMode);
        String parentName = parentBoardName(resultList);
        StringBuffer xmlStr = new StringBuffer();
        
        if(resultList.size() > 0 ) {        	
        	xmlStr.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
        	xmlStr.append("<ROOT>");
        	xmlStr.append("<DATA>");
        	for(int i=0; i<resultList.size(); i++) {        		
        	xmlStr.append("<ROW>");
        	xmlStr.append("<BOARDID>"+resultList.get(i).getBoardId()+"</BOARDID>");
        	xmlStr.append("<BOARDNAME>"+resultList.get(i).getBoardName()+"</BOARDNAME>");    	
        	xmlStr.append("<BOARDNAME2>"+resultList.get(i).getBoardName2()+"</BOARDNAME2>");
        	xmlStr.append("<TABUSED>"+resultList.get(i).getTabUsed()+"</TABUSED>");
        	xmlStr.append("</ROW>");
        	}      	
        	xmlStr.append("</DATA>");
        	xmlStr.append("<DATA>");
        	xmlStr.append("<TOPBOARDLIST>"+parentName+"</TOPBOARDLIST>");
        	xmlStr.append("</DATA>");
        	xmlStr.append("</ROOT>");
        	
        	response.setContentType("text/xml"); 
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Cache-Control", "no-cache");
            response.getWriter().write(xmlStr.toString());
        }
        
        modelMap.addAttribute("parentName", parentName);
        modelMap.addAttribute("resultList", resultList);
        		
	}
	
	
	@RequestMapping(value="/ezBoard/boardConfig.do")
	public String boardConfig() throws Exception{		
		return "ezBoard/boardConfig";
	}
	
	@SuppressWarnings("null")
	@RequestMapping(value="/ezBoard/boardGeneral.do")
	public String boardGeneral(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO, Model model) throws Exception {
		loginVO = commonUtil.userInfo(loginCookie); 
		String pUserID = loginVO.getId();
		
		BoardConfigVO boardListConfig = ezBoardService.getBoardList_Config(pUserID);
		if(boardListConfig == null) {
			boardListConfig.setListCount(20);
			boardListConfig.setPreview("OFF");
			boardListConfig.setPreviewHList(50);
			boardListConfig.setPreviewHContent(50);
			boardListConfig.setPreviewWList(50);
			boardListConfig.setPreviewWContent(50);
		}
		model.addAttribute("boardListConfig", boardListConfig);
			
		return "ezBoard/boardGeneral";
	}
	
	@RequestMapping(value="/ezBoard/board_generallist_save.do", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object>boardGeneralListSave(@CookieValue("loginCookie") String loginCookie, LoginVO loginVO,HttpServletRequest req) throws Exception {
		loginVO = commonUtil.userInfo(loginCookie);
		String pUserID = loginVO.getId();
		String pPreview = req.getParameter("pPreview");
		int pListCount = Integer.parseInt(req.getParameter("pListCount"));
		int pPreviewWList = Integer.parseInt(req.getParameter("pPreviewWList"));
		int pPreviewWContent = Integer.parseInt(req.getParameter("pPreviewWContent"));
		int pPreviewHList = Integer.parseInt(req.getParameter("pPreviewHList"));
		int pPreviewHContent = Integer.parseInt(req.getParameter("pPreviewHContent"));

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pListCount", pListCount);
		map.put("pPreview", pPreview);
		map.put("pPreviewWList", pPreviewWList);
		map.put("pPreviewWContent", pPreviewWContent);
		map.put("pPreviewHList", pPreviewHList);
		map.put("pPreviewHContent", pPreviewHContent);	

		ezBoardService.setBoardList_Config(pUserID, map);
		return map;
	}
	
	@RequestMapping(value="/ezBoard/boardFavorite.do")
	public String boardFavorite() throws Exception {
		return "ezBoard/boardFavorite";
	}
	
	public String parentBoardName(List<BoardMyFavoriteVO> resultList) throws Exception{
        String rtv = "";
        String BoardIdList = "";
        int BoardIdListCount = 0;
        for(int i = 0; i < resultList.size(); i++){
            BoardIdList += resultList.get(i).getBoardId().trim();
            if(i != resultList.size() - 1)
                BoardIdList += ";";            
        }
        BoardIdListCount = BoardIdList.split(";").length - 1;
        rtv = ezBoardService.get_parentBoardName(BoardIdList.trim(),BoardIdListCount);
        
        return rtv;
    }
	
   @RequestMapping(value="/ezBoard/getMyBoards_Config.do")
   public void getMyBoards_Config(HttpServletRequest req, @CookieValue("loginCookie") String loginCookie, LoginVO loginVO, HttpServletResponse res) throws Exception{
	   loginVO = commonUtil.userInfo(loginCookie);
	   String lang = loginVO.getLang();
	   try{
           String pRootTreeID = "";
           String pCountFlag = "";
           
           if(req.getParameter("RootTreeID") != null)
               pRootTreeID = req.getParameter("RootTreeID");
           if(req.getParameter("COUNTFLAG") != null)
               pCountFlag = req.getParameter("COUNTFLAG");

           List<BoardMyFavoriteVO> resultList = getMyBoardTreeConfig(loginVO.getId(), pRootTreeID, commonUtil.getMultiData(lang));
           
           if(config.getProperty("config.USE_BOARD_LEFTMENU_COUNT").toString() == "YES" && pCountFlag == "YES"){
               String strName = "";
               int intCount;
               
               BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
               myFavoriteVO.setUserId(loginVO.getId());
               myFavoriteVO.setNowDate(EgovDateUtil.getToday());
               myFavoriteVO.setFromNow(EgovDateUtil.addDay(EgovDateUtil.getToday(), -5));
               
               for(int i = 0; i < resultList.size(); i++){
                   if(resultList.get(i).getTreeBoardId() == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}"){
                	   intCount = ezBoardService.getBrdNewItemCount(myFavoriteVO);

                       if(intCount != 0)
                           strName = "(" + intCount + ")";
                       if(lang == "1"){
                    	   resultList.get(i).setTreeName(resultList.get(i).getTreeName() + strName);
                       }else{
                    	   resultList.get(i).setTreeName2(resultList.get(i).getTreeName2() + strName);
                       }

                   }else{
                       if(resultList.get(i).getData4() == "BOARD"){
                    	   BoardPropertyVO boardInfo = getBoardInfo(resultList.get(i).getBoardId(),loginVO);
                    	   
                    	   myFavoriteVO.setBoardId(resultList.get(i).getBoardId());
                    	   myFavoriteVO.setType("1");
                    	   
                           if(boardInfo.getGuBun() == "4"){
                        	   intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
                           }
                           else{
                        	   intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
                           }
                           strName = "";
                           if(intCount != 0)
                               strName = "(" + intCount + ")";
                           if(lang == "1"){
                        	   resultList.get(i).setTreeName(resultList.get(i).getTreeName() + strName);
                           }else{
                        	   resultList.get(i).setTreeName2(resultList.get(i).getTreeName2() + strName);
                           }
                       }
                   }
               }
           }           
           StringBuilder sb = new StringBuilder();

           sb.append("<TREEVIEWDATA>");

           for(int i = 0; i < resultList.size(); i++){
               sb.append("<NODE>");
               if(lang =="1"){
            	   sb.append("<VALUE><![CDATA[" + resultList.get(i).getTreeName() + "]]></VALUE>");
               }else{
            	   sb.append("<VALUE><![CDATA[" + resultList.get(i).getTreeName2() + "]]></VALUE>");
               }
               sb.append("<STYLE><![CDATA[]]></STYLE>");
               sb.append("<DATA1>" + resultList.get(i).getTreeId() + "</DATA1>");
               if(lang =="1"){
            	   sb.append("<DATA2><![CDATA[" + resultList.get(i).getTreeName() + "]]></DATA2>");
               }else{
            	   sb.append("<DATA2><![CDATA[" + resultList.get(i).getTreeName2() + "]]></DATA2>");
               }
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

               if(resultList.get(i).getTreeBoardId() == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")	//새 게시판 자동선택
                   sb.append("<SELECT>TRUE</SELECT>");
               sb.append("</NODE>");
           }
           sb.append("</TREEVIEWDATA>");

           res.setContentType("text/xml"); 
           res.setCharacterEncoding("UTF-8");
           res.setHeader("Cache-Control", "no-cache");
           res.getWriter().write(sb.toString());
       }
       catch (Exception ex){
    	   ex.printStackTrace();
       }
   }
	
	public List<BoardMyFavoriteVO> getMyBoardTreeConfig(String userID,String pRootTreeID,String lang) throws Exception{
        List<BoardMyFavoriteVO> resultList  = ezBoardAdminService.getMyBoardTree_get3(userID,pRootTreeID.trim());

        for(int i = 0; i < resultList.size(); i++){
        	if(resultList.get(i).getTreeBoardId() == "")
        		resultList.get(i).setData4("TREE");
            else
            	resultList.get(i).setData4("BOARD");

            resultList.get(i).setExpended("FALSE");

            if(resultList.get(i).getChildCnt() > 0)
                resultList.get(i).setIsLeaf("FALSE");
            else
            	resultList.get(i).setIsLeaf("TRUE");

            if(resultList.get(i).getTreeBoardId() == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")	//새 게시판 자동선택
            	resultList.get(i).setSelect("TRUE");
        }
        return resultList;
	}
	@RequestMapping(value= {"/ezBoard/boardItemList_new.do","/ezBoard/boardItemList.do"})
	public String boardItemList(HttpServletRequest request, LoginVO loginVO,BoardPropertyVO boardInfoVO, @CookieValue("loginCookie") String loginCookie, Model model) throws Exception{
		//request line 가져오기 
		String requestURL = (String) request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
		//뷰만 다르고 cs가 같은 경우여서 requestURL 사용해서 다이나믹뷰
		requestURL = requestURL.substring(1, requestURL.length()-3);
		
		String pBoardID = boardInfoVO.getBoardID();
		if(boardInfoVO.getAdminType() == null)
			boardInfoVO.setAdminType("");
		if(boardInfoVO.getButtonHidden() == null)
			boardInfoVO.setButtonHidden("N");
        String use_ocs = config.getProperty("config.USE_OCS"); 
        String use_Editor = config.getProperty("config.EDITOR"); 
        String use_IE11Browser = config.getProperty("config.IE11EDITOR");
        String use_oneLineCount = "";
        
        loginVO = commonUtil.userInfo(loginCookie);
        if((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && use_IE11Browser.equals("CK"))
            use_IE11Browser = "CK";
        
//            if(vpnLogin != null)
//                isVPN = vpnLogin;
        boardInfoVO = getBoardInfo(boardInfoVO,pBoardID,loginVO);
        BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(pBoardID);
        if(boardPropertyVO.getOneLineReply() == "1")
            use_oneLineCount = "YES";
        else
            use_oneLineCount = "NO";
        if(boardInfoVO.getListView_FG() == "true"){
            if(request.getParameter("page") == null || request.getParameter("page").equals(""))
            	boardInfoVO.setPage(1);
        }
        model.addAttribute("boardInfo", boardInfoVO);
        model.addAttribute("userInfo", loginVO);
        model.addAttribute("use_ocs", use_ocs);
        model.addAttribute("use_Editor", use_Editor);
        model.addAttribute("use_IE11Browser", use_IE11Browser);
        model.addAttribute("use_oneLineCount", use_oneLineCount);
        
        return requestURL;
	}

	// OCS Presence
    public String getEmail(String userid) throws Exception{
        String email = "";
        
        email = ezOrganService.getPropertyValue(userid, "mail");
        return email;
    }

    // OCS Presence
    public String getSIPListByCNList(String[] pCNList) throws Exception{
        String strRet = "";
        
        if(pCNList == null || pCNList.length == 0){
            return null;
        }
        strRet = ezOrganService.getSIPUriList(StringUtils.join(pCNList, ";"), "");

        return strRet;
    }
    
    // 게시판의 정보를 가져오는 함수
	public BoardPropertyVO getBoardInfo(String pBoardID, LoginVO userInfo) throws Exception{
		BoardPropertyVO boardInfo = new BoardPropertyVO();
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);             

		if(pBoardID == ""){
			boardInfo.setBoardName(egovMessageSource.getMessage("ezBoard.t229"));		
			return null;
		}

        //-- 조직도 Deptpath 역순으로 가져온것을 순방향으로 변환 2008.01.29 이성조
		String deptPath = userInfo.getDeptPathCode();
	    String deptPathOrgan="";
	    for(int ch=0; ch<deptPath.split(",").length; ch++){
	        if(ch==0)
	            deptPathOrgan+=deptPath.split(",")[ch].trim();
	        else
	            deptPathOrgan+=","+deptPath.split(",")[deptPath.split(",").length-(ch)].trim();
	    }
	    
	    String userDeptPath = deptPathOrgan+",everyone";
	    
		for (int i=0; i<userDeptPath.split(",").length; i++)
		{
			BoardPropertyVO boardInfoTemp = ezBoardAdminService.getACL(pBoardID, userDeptPath.split(",")[i].trim());
			if(boardInfoTemp == null){
				break;
			}else{
				boardInfo = boardInfoTemp;
			}
		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
	    if(pBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}"){
	    	boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}else if(userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1){
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}else if(boardInfo.getBoardGroupAdmin_FG() == "OK"){	// 게시판 그룹관리자는 하위게시판들에 대해 풀권한을 가짐
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}else if(boardInfo.getAccess_FG().equals(null)){
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}
	
	    BoardPropertyVO strProp = ezBoardService.getBoardProperty(pBoardID);
	
	    if(strProp != null){
	    	boardInfo.setExpireDays(strProp.getItemExpires());
	    	boardInfo.setAttachLimit(strProp.getAttachLimit());
	    	boardInfo.setBoardName1(strProp.getBoardName().replace("\"\"", "&quot"));
	    	boardInfo.setBoardName2(strProp.getBoardName2().replace("\"\"", "&quot"));
	    	 
		    if(userInfo.getPrimary() == "2" && boardInfo.getBoardName2() != ""){
		    	boardInfo.setBoardName(boardInfo.getBoardName2());
		    }else{
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
	
	public BoardPropertyVO getBoardInfo(BoardPropertyVO boardInfo, String pBoardID, LoginVO userInfo) throws Exception{
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);             

		if(pBoardID == ""){
			boardInfo.setBoardName(egovMessageSource.getMessage("ezBoard.t229"));		
			return null;
		}

        //-- 조직도 Deptpath 역순으로 가져온것을 순방향으로 변환 2008.01.29 이성조
		String deptPath = userInfo.getDeptPathCode();
	    String deptPathOrgan="";
	    for(int ch=0; ch<deptPath.split(",").length; ch++){
	        if(ch==0)
	            deptPathOrgan+=deptPath.split(",")[ch].trim();
	        else
	            deptPathOrgan+=","+deptPath.split(",")[deptPath.split(",").length-(ch)].trim();
	    }
	    
	    String userDeptPath = deptPathOrgan+",everyone";
	    
		for (int i=0; i<userDeptPath.split(",").length; i++)
		{
			BoardPropertyVO boardInfoTemp = ezBoardAdminService.getACL(pBoardID, userDeptPath.split(",")[i].trim());
			if(boardInfoTemp == null){
				break;
			}else{
				boardInfo = boardInfoTemp;
			}
		}
		
		String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
		boardInfo.setBoardGroupAdmin_FG(boardGroupAdmin_FG);
	    if(pBoardID == "{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}"){
	    	boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}else if(userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1){
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}else if(boardInfo.getBoardGroupAdmin_FG() == "OK"){	// 게시판 그룹관리자는 하위게시판들에 대해 풀권한을 가짐
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("true");
			boardInfo.setListView_FG("true");
			boardInfo.setRead_FG("true");
			boardInfo.setWrite_FG("true");
			boardInfo.setReply_FG("true");
			boardInfo.setDelete_FG("true");
		}else if(boardInfo.getAccess_FG().equals(null)){
			boardInfo.setAccess_FG("1");
			boardInfo.setBoardAdmin_FG("false");
			boardInfo.setListView_FG("false");
			boardInfo.setRead_FG("false");
			boardInfo.setWrite_FG("false");
			boardInfo.setReply_FG("false");
			boardInfo.setDelete_FG("false");
		}
	
	    BoardPropertyVO strProp = ezBoardService.getBoardProperty(pBoardID);
	
	    if(strProp != null){
	    	boardInfo.setExpireDays(strProp.getItemExpires());
	    	boardInfo.setAttachLimit(strProp.getAttachLimit());
	    	boardInfo.setBoardName1(strProp.getBoardName().replace("\"\"", "&quot"));
	    	boardInfo.setBoardName2(strProp.getBoardName2().replace("\"\"", "&quot"));
	    	 
		    if(userInfo.getPrimary() == "2" && boardInfo.getBoardName2() != ""){
		    	boardInfo.setBoardName(boardInfo.getBoardName2());
		    }else{
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
	
    
    @RequestMapping(value = "/ezBoard/getBoardList.do")
    public void getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardVO ezBoardVO, HttpServletResponse res) throws Exception{
        String boardID = ezBoardVO.getBoardId();
        String boardType = ezBoardVO.getBoardType();
        String type = "1";
        String resultXML = "";
        
        userInfo = commonUtil.userInfo(loginCookie);
        userInfo.setLang("1");
//        BoardPropertyVO boardInfo = getBoardInfo(boardID,userInfo);
        
        if(!ezBoardVO.getOrderOption().equals(""))
            type = ezBoardVO.getOrderOption();
        ezBoardVO.setLang(userInfo.getLang());
        if(boardType == "4"){ // 썸네일 
//            boardXml = getThumbList(ezBoardVO);
        }else if(boardType == "5"){ //Q&A
//            boardXml = getQnAListItem(ezBoardVO);
        }else{
            if(boardID.equals("{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}")){
            	ezBoardVO.setBoardType("N");
            	resultXML = getNewItemList(ezBoardVO,userInfo);
            }else{
            	resultXML = getBoardListItem(ezBoardVO,userInfo,type);
            }
        }

//        int writedateSN = -1;
//        int titleSN = -1;
//        if(boardListMap.size() > 0 && boardListMap.get(0).get("WRITEDATENUM") != "")
//        {
//            writedateSN = (int) (boardListMap.get(0).get("WRITEDATENUM"));
//        }
//        if(boardListMap.size() > 0 && boardListMap.get(0).get("TITLENUM") != "")
//        {
//            titleSN = (int) boardListMap.get(0).get("TITLENUM");
//        }

//        if(boardListMap != null)
//        {
//            for (int i = 0; i < boardListMap.size(); i++)
//            {
//                if(writedateSN > -1)
//                {
//                    if(boardListMap.Item(i).ChildNodes.Item(writedateSN).ChildNodes.Item(0).InnerText.Trim() != "")
//                    {
//                        docListNode.Item(i).ChildNodes.Item(writedateSN).ChildNodes.Item(0).InnerText = GetLocalTime(docListNode.Item(i).ChildNodes.Item(writedateSN).ChildNodes.Item(0).InnerText.Trim());
//                    }
//                }
//                if(titleSN > -1)
//                {
//                    docListNode.Item(i).ChildNodes.Item(titleSN).ChildNodes.Item(0).InnerText = Server.HtmlEncode(docListNode.Item(i).ChildNodes.Item(titleSN).ChildNodes.Item(0).InnerText.Trim());
//                }
//            }
//        }
        res.setContentType("text/xml"); 
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Cache-Control", "no-cache");
        res.getWriter().write(resultXML.toString());
        
    }

	public String getNewItemList(BoardVO ezBoardVO, LoginVO userInfo) throws Exception{
        String orderOption1 = "";
        String orderOption2 = "";
        // 수정(2007.06.18) : multidata 기능추가 
        String strMultiData = commonUtil.getMultiData(ezBoardVO.getLang());
        
        BoardListVO boardListVO = new BoardListVO();
        // 표준모듈 (2007.05.07) : 다국어
        List<BoardListHeaderVO> headerList = ezBoardService.getListHeader(ezBoardVO);
        
        int i = 0;
        int hlength = headerList.size();
        for(i = 0; i < hlength; i++){
            if(ezBoardVO.getOrderCell() != "" && ezBoardVO.getOrderCell() == headerList.get(i).getName()){
                if(ezBoardVO.getOrderCell() == ""){                            
                    if(headerList.get(i).getName().indexOf("BOARDNAME") > -1)
                        orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " ";
                    else
                        orderOption1 = headerList.get(i).getColName() + " ";
                }else{
                    if(headerList.get(i).getColName().indexOf("BOARDNAME") > -1)
                        orderOption1 = headerList.get(i).getColName().replace("BOARDNAME", "B.BOARDNAME") + " DESC ";
                    else
                        orderOption1 = headerList.get(i).getColName() + " DESC ";
                }
            }
        }
        
        String nowDate = EgovDateUtil.getToday();
        String fieldName = "";
        String fieldValue = "";
        
        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo.getId());
        
        int boardCount = ezBoardService.getNewItemListCount(userInfo.getId(),nowDate,EgovDateUtil.addDay(nowDate, -5));
        int startRow = 1;
        int endRow = 0;
        int personalCount_ = boardConfigVO.getListCount();
        
        boardConfigVO.setPageCnt(boardCount);
        boardConfigVO.setTotalCnt(boardCount);
        
        startRow = (personalCount_ * (ezBoardVO.getPageNum() - 1)) + 1;
        endRow = (personalCount_ * ezBoardVO.getPageNum());
        
        boardListVO.setUserID(userInfo.getId());
        boardListVO.setStartRow(startRow);
        boardListVO.setEndRow(endRow);
        boardListVO.setTotalCount(boardCount);
        boardListVO.setOrderBySub(orderOption1);
        boardListVO.setOrderByMain(orderOption2);
        
        List<HashMap<String, Object>> boardList = ezBoardService.getNewItemList(boardListVO);
        
        int dlength = boardList.size();
        //XML 생성 수정요망
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");
        resultXML.append("<TOTALCNT>"+boardConfigVO.getTotalCnt()+"</TOTALCNT>");
        resultXML.append("<PAGECNT>"+boardConfigVO.getPageCnt()+"</PAGECNT>");
        resultXML.append("<PERSONALCNT>"+boardConfigVO.getTotalCnt()+"</PERSONALCNT>");
        resultXML.append("<PREVIEWTYPE>"+boardConfigVO.getPreview()+"</PREVIEWTYPE>");
        resultXML.append("<PREVIEWWLIST>"+boardConfigVO.getPreviewWList()+"</PREVIEWWLIST>");
        resultXML.append("<PREVIEWWCONTENT>"+boardConfigVO.getPreviewWContent()+"</PREVIEWWCONTENT>");
        resultXML.append("<PREVIEWHLIST>"+boardConfigVO.getPreviewHList()+"</PREVIEWHLIST>");
        resultXML.append("<PREVIEWHCONTENT>"+boardConfigVO.getPreviewHContent()+"</PREVIEWHCONTENT>");
        resultXML.append("<LISTVIEWDATA>");
        resultXML.append("<HEADERS>");
        
        for(BoardListHeaderVO vo:headerList){
        	resultXML.append("<HEADER>");
    		resultXML.append("<NAME>"+vo.getName()+"</NAME>");
        	resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
        	resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
        	resultXML.append("</HEADER>");
        }
        resultXML.append("</HEADERS>");
        resultXML.append("<ROWS>");
        
        for(int j = 0; j < dlength; j++){
        	resultXML.append("<ROW>");
            for(i = 0; i < hlength; i++){
            	resultXML.append("<CELL>");
            	fieldName = headerList.get(i).getColName().toUpperCase();

            	// 수정(2007.06.18) : multidata 기능 추가
                if(fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME") || fieldName.equals("BOARDNAME")){
                    fieldName = fieldName + strMultiData;
                }
                if(fieldName.equals("WRITEDATE")){
                	fieldValue =(String)boardList.get(j).get(fieldName);
                }else
                    fieldValue = (String) boardList.get(j).get(fieldName);
                
                resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
                
                if(i == 0){
                	resultXML.append("<DATA1>"+boardList.get(j).get("BOARDID")+"</DATA1>");
                	resultXML.append("<DATA2>"+boardList.get(j).get("ITEMID")+"</DATA2>");
        			resultXML.append("<DATA3>"+boardList.get(j).get("WRITERID")+"</DATA3>");
					resultXML.append("<DATA4>"+boardList.get(j).get("IMPORTANCE")+"</DATA4>");
					resultXML.append("<DATA5>1</DATA5>");
					resultXML.append("<DATA6>"+boardList.get(j).get("ABSTRACT")+"</DATA6>");
					resultXML.append("<DATA7>N</DATA7>");
					resultXML.append("<DATA8>"+boardList.get(j).get("ITEMLEVEL")+"</DATA8>");
					resultXML.append("<DATA9>"+boardList.get(j).get("NOTICE")+"</DATA9>");
					resultXML.append("<DATA10>"+boardList.get(j).get("GUBUN")+"</DATA10>");
					resultXML.append("<DATA11>"+boardList.get(j).get("ONELINECNT")+"</DATA11>");
					resultXML.append("<DATA12>"+boardList.get(j).get("MAINCONTENT")+"</DATA12>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
		return resultXML.toString();
	}
	public String getBoardListItem(BoardVO ezBoardVO, LoginVO userInfo, String type) throws Exception{
        String orderOption1 = "";
        String orderOption2 = "";
        // 수정(2007.06.18) : multidata 기능추가 
        String strMultiData = commonUtil.getMultiData(ezBoardVO.getLang());

        // 표준모듈 (2007.05.07) : 다국어
        List<BoardListHeaderVO> headerList = ezBoardService.getListHeaderBoardID(ezBoardVO);

        // 헤더 정보를 세팅한다.
        int i = 0;
        int hlength = headerList.size();
        int writeDateSN = 0;    //작성일 순번
        int titleSN = 0;            //제목 순번

        for (i = 0; i < hlength; i++){
            if (ezBoardVO.getOrderCell() != "" && ezBoardVO.getOrderCell() == headerList.get(i).getName()){
                if (ezBoardVO.getOrderCell() == ""){
                    orderOption1 = headerList.get(i).getColName() + " ";
                    orderOption2 = headerList.get(i).getColName() + " DESC ";
                }
                else{
                    orderOption1 = headerList.get(i).getColName() + " DESC ";
                    orderOption2 = headerList.get(i).getColName() + " ";
                }
            }
            if (headerList.get(i).getColName().toUpperCase().equals("WRITEDATE")){
                writeDateSN = i;
            }
            if (headerList.get(i).getColName().toUpperCase().equals("TITLE")){
                titleSN = i;
            }
        }
        int noticeCount = 0;
        if (type == "1"){
        	noticeCount = ezBoardService.getNoticePostItemCount(ezBoardVO.getBoardId());
        }
        int boardCount = ezBoardService.getBoardTotalItemCount(ezBoardVO.getBoardId(), userInfo.getId(), type);
   
        int startRow = 1;
        int endRow = 0;

        BoardConfigVO boardConfigVO = ezBoardService.getPersonalCount(userInfo.getId());
        
        int personalCount = boardConfigVO.getListCount();
        String previewtype = boardConfigVO.getPreview();
        String fieldName = "";
        String fieldValue = "";
        StringBuffer resultXML = new StringBuffer();
        
        resultXML.append("<DOCLIST>");

        if (noticeCount > 0 && type == "1"){
            endRow = (personalCount * ezBoardVO.getPageNum()) - noticeCount;

            List<HashMap<String, Object>> noticeList = ezBoardService.getNoticePostItem(ezBoardVO, personalCount);

            int k = 0;
            int nlength = noticeList.size();
            
            resultXML.append("<TOTALCNT>"+boardCount+"</TOTALCNT>");
            resultXML.append("<PAGECNT>"+((int)noticeCount + (int)boardCount)+"</PAGECNT>");
            resultXML.append("<PERSONALCNT>"+personalCount+"</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>"+previewtype+"</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>"+boardConfigVO.getPreviewWList()+"</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>"+boardConfigVO.getPreviewWContent()+"</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>"+boardConfigVO.getPreviewHList()+"</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>"+boardConfigVO.getPreviewHContent()+"</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>"+writeDateSN+"</WRITEDATENUM>");
            resultXML.append("<TITLENUM>"+titleSN+"</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for(BoardListHeaderVO vo:headerList){
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>"+vo.getName()+"</NAME>");
            	resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
            	resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
            
            for (k=0; k < nlength; k++){
            	resultXML.append("<ROW>");
                for (i = 0; i < hlength; i++){
                	resultXML.append("<CELL>");
                    fieldName = headerList.get(i).getColName().toUpperCase();
                    // 수정(2007.06.18) : multidata 기능 추가
                    if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")){
                        fieldName = fieldName + strMultiData;
                    }
                    if (fieldName.equals("WRITEDATE")){
                    	fieldValue = (String) noticeList.get(k).get(fieldName);
                    }else{
                    	fieldValue = String.valueOf(noticeList.get(k).get(fieldName));
                    }
                    
                    resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
                    
                    if(i == 0){
                    	resultXML.append("<DATA1>"+noticeList.get(k).get("BOARDID")+"</DATA1>");
                    	resultXML.append("<DATA2>"+noticeList.get(k).get("ITEMID")+"</DATA2>");
            			resultXML.append("<DATA3>"+noticeList.get(k).get("WRITERID")+"</DATA3>");
    					resultXML.append("<DATA4>"+noticeList.get(k).get("IMPORTANCE")+"</DATA4>");
    					resultXML.append("<DATA5>"+noticeList.get(k).get("READFLAG")+"</DATA5>");
    					resultXML.append("<DATA6>"+noticeList.get(k).get("ABSTRACT")+"</DATA6>");
    					if(EgovDateUtil.getDaysDiff(noticeList.get(k).get("WRITEDATE").toString().substring(0, 10), EgovDateUtil.getToday()) < 0){
    						resultXML.append("<DATA7>Y</DATA7>");
    					}else{
    						resultXML.append("<DATA7>N</DATA7>");
    					}
    					resultXML.append("<DATA8>"+noticeList.get(k).get("ITEMLEVEL")+"</DATA8>");
    					resultXML.append("<DATA9>"+noticeList.get(k).get("NOTICE")+"</DATA9>");
    					resultXML.append("<DATA10></DATA10>");
    					resultXML.append("<DATA11>"+noticeList.get(k).get("ONELINECNT")+"</DATA11>");
    					resultXML.append("<DATA12>"+noticeList.get(k).get("MAINCONTENT")+"</DATA12>");
    					resultXML.append("<TITLE>"+noticeList.get(k).get("TITLE")+"</TITLE>");
    					if(ezBoardVO.getLang() == "1"){
    						resultXML.append("<WRITERNAME>"+noticeList.get(k).get("WRITERNAME")+"</WRITERNAME>");
    						resultXML.append("<WRITERDEPTNAME>"+noticeList.get(k).get("WRITERDEPTNAME")+"</WRITERDEPTNAME>");
    					}else{
    						resultXML.append("<WRITERNAME>"+noticeList.get(k).get("WRITERNAME2")+"</WRITERNAME>");
    						resultXML.append("<WRITERDEPTNAME>"+noticeList.get(k).get("WRITERDEPTNAME2")+"</WRITERDEPTNAME>");
    					}
    					resultXML.append("<WRITEDATE>"+noticeList.get(k).get("WRITEDATE")+"</WRITEDATE>");
    					resultXML.append("<ATTACHMENTS>"+noticeList.get(k).get("ATTACHMENTS")+"</ATTACHMENTS>");
                    }
                    resultXML.append("</CELL>");
                }
                resultXML.append("</ROW>");
            }
        }
        else{
            startRow = ((personalCount * (ezBoardVO.getPageNum() - 1))) + 1;
            endRow = (personalCount * ezBoardVO.getPageNum());

            resultXML.append("<TOTALCNT>"+boardCount+"</TOTALCNT>");
            resultXML.append("<PAGECNT>"+boardCount+"</PAGECNT>");
            resultXML.append("<PERSONALCNT>"+personalCount+"</PERSONALCNT>");
            resultXML.append("<PREVIEWTYPE>"+previewtype+"</PREVIEWTYPE>");
            resultXML.append("<PREVIEWWLIST>"+boardConfigVO.getPreviewWList()+"</PREVIEWWLIST>");
            resultXML.append("<PREVIEWWCONTENT>"+boardConfigVO.getPreviewWContent()+"</PREVIEWWCONTENT>");
            resultXML.append("<PREVIEWHLIST>"+boardConfigVO.getPreviewHList()+"</PREVIEWHLIST>");
            resultXML.append("<PREVIEWHCONTENT>"+boardConfigVO.getPreviewHContent()+"</PREVIEWHCONTENT>");
            resultXML.append("<WRITEDATENUM>"+writeDateSN+"</WRITEDATENUM>");
            resultXML.append("<TITLENUM>"+titleSN+"</TITLENUM>");
            resultXML.append("<LISTVIEWDATA>");
            resultXML.append("<HEADERS>");
            
            for(BoardListHeaderVO vo:headerList){
            	resultXML.append("<HEADER>");
        		resultXML.append("<NAME>"+vo.getName()+"</NAME>");
            	resultXML.append("<WIDTH>"+vo.getWidth()+"</WIDTH>");
            	resultXML.append("<COLNAME>"+vo.getColName()+"</COLNAME>");
            	resultXML.append("</HEADER>");
            }
            resultXML.append("</HEADERS>");
            resultXML.append("<ROWS>");
            
        }
        if (ezBoardVO.getPageNum() != 1){
            startRow = ((personalCount * (ezBoardVO.getPageNum() - 1)) - noticeCount) + 1;
            endRow = (personalCount * ezBoardVO.getPageNum()) - noticeCount;
        }
        List<HashMap<String, Object>> boardListItem = ezBoardService.getBoardListItem(ezBoardVO.getBoardId(),userInfo.getId(), startRow, endRow, boardCount, orderOption1, orderOption2, type);

        int dlength = boardListItem.size();
        
        for (int j = 0; j < dlength; j++){
        	resultXML.append("<ROW>");
            for (i = 0; i < hlength; i++){
            	resultXML.append("<CELL>");
                fieldName = headerList.get(i).getColName().toUpperCase();

                // 수정(2007.06.18) : multidata 기능 추가
                if (fieldName.equals("WRITERNAME") || fieldName.equals("WRITERJOBTITLE") || fieldName.equals("WRITERDEPTNAME")){
                    fieldName = fieldName + strMultiData;
                }

                if (fieldName.equals("WRITEDATE")){
                	fieldValue = (String) boardListItem.get(j).get(fieldName);
                }
                else{
                    fieldValue = String.valueOf(boardListItem.get(j).get(fieldName));
                }

                resultXML.append("<VALUE>"+fieldValue+"</VALUE>");
                if (i == 0){
                	resultXML.append("<DATA1>"+boardListItem.get(j).get("BOARDID")+"</DATA1>");
                	resultXML.append("<DATA2>"+boardListItem.get(j).get("ITEMID")+"</DATA2>");
        			resultXML.append("<DATA3>"+boardListItem.get(j).get("WRITERID")+"</DATA3>");
					resultXML.append("<DATA4>"+boardListItem.get(j).get("IMPORTANCE")+"</DATA4>");
					resultXML.append("<DATA5>"+boardListItem.get(j).get("READFLAG")+"</DATA5>");
					resultXML.append("<DATA6>"+boardListItem.get(j).get("ABSTRACT")+"</DATA6>");
					if(EgovDateUtil.getDaysDiff(boardListItem.get(j).get("WRITEDATE").toString().substring(0, 10), EgovDateUtil.getToday()) < 0){
						resultXML.append("<DATA7>Y</DATA7>");
					}else{
						resultXML.append("<DATA7>N</DATA7>");
					}
					resultXML.append("<DATA8>"+boardListItem.get(j).get("ITEMLEVEL")+"</DATA8>");
					resultXML.append("<DATA9>"+boardListItem.get(j).get("NOTICE")+"</DATA9>");
					resultXML.append("<DATA10></DATA10>");
					resultXML.append("<DATA11>"+boardListItem.get(j).get("ONELINECNT")+"</DATA11>");
					resultXML.append("<DATA12>"+boardListItem.get(j).get("MAINCONTENT")+"</DATA12>");
					resultXML.append("<TITLE>"+boardListItem.get(j).get("TITLE")+"</TITLE>");
					resultXML.append("<WRITERNAME>"+boardListItem.get(j).get("WRITERNAME")+"</WRITERNAME>");
					resultXML.append("<WRITERNAME2>"+boardListItem.get(j).get("WRITERNAME2")+"</WRITERNAME2>");
					resultXML.append("<WRITERDEPTNAME>"+boardListItem.get(j).get("WRITERDEPTNAME")+"</WRITERDEPTNAME>");
					resultXML.append("<WRITERDEPTNAME2>"+boardListItem.get(j).get("WRITERDEPTNAME2")+"</WRITERDEPTNAME2>");
					resultXML.append("<WRITEDATE>"+boardListItem.get(j).get("WRITEDATE")+"</WRITEDATE>");
					resultXML.append("<ATTACHMENTS>"+boardListItem.get(j).get("ATTACHMENTS")+"</ATTACHMENTS>");
                }
                resultXML.append("</CELL>");
            }
            resultXML.append("</ROW>");
        }
        resultXML.append("</ROWS>");
        resultXML.append("</LISTVIEWDATA>");
        resultXML.append("</DOCLIST>");
        
        return resultXML.toString();
    }
	
	@RequestMapping(value = "/ezBoard/getSubBoards.do")
	public void getSubBoards(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, BoardPropertyVO boardInfo, HttpServletRequest req, HttpServletResponse res) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
	    String pRootBoardID = "";
	    String pSubFlag = "";
	    int pSelectBy = 0;
	    String pExcludeBoardID = " ";
	    if(req.getParameter("rootBoardID") != null){
	    	pRootBoardID = req.getParameter("rootBoardID");
	    }
	    if(req.getParameter("subFlag") != null){
	    	pSubFlag = req.getParameter("subFlag");
	    }
	    if(req.getParameter("selectFlag") != null){
	    	pSelectBy = Integer.parseInt(req.getParameter("selectFlag"));
	    }
	    if(req.getParameter("pExcludeBoardID") != null){
	    	pExcludeBoardID = req.getParameter("pExcludeBoardID");
	    }
	
	    String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
	    int pMode = 0;
	
	    if(boardGroupAdmin_FG == "OK" || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1)
	        pMode = 0;
	    else
	        pMode = 1;
	
	    String strXML = getBoardTree(pRootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID(), pMode, Integer.parseInt(pSubFlag), pSelectBy, pExcludeBoardID, commonUtil.getMultiData(userInfo.getLang()));
	    
	    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	    DocumentBuilder builder = factory.newDocumentBuilder();
	    Document doc = builder.parse(new InputSource(new StringReader(strXML)));
	    NodeList nList = doc.getElementsByTagName("NODE");
	    
	    if (strXML.substring(0, 5).toUpperCase() != "ERROR"){
	        if (config.getProperty("config.USE_BOARD_LEFTMENU_COUNT").toString().equals("YES")){
            	
            	BoardMyFavoriteVO myFavoriteVO = new BoardMyFavoriteVO();
            	int intCount = 0;
	            if(nList != null){
	            	for (int i = 0; i < nList.getLength(); i++){
	            		Node node = nList.item(i);
	            		
	            		myFavoriteVO.setBoardId(node.getChildNodes().item(2).getTextContent());
            			myFavoriteVO.setNowDate(EgovDateUtil.getToday());
            			myFavoriteVO.setUserId(userInfo.getId());
            			myFavoriteVO.setType("1");
            			
	            		if(node.getChildNodes().item(6).getTextContent().equals("4")){
	            			intCount = ezBoardService.getThumbNailCount(myFavoriteVO);
	            		}else if(node.getChildNodes().item(6).getTextContent().equals("5")){
	            			boardInfo = getBoardInfo(node.getChildNodes().item(2).getTextContent(), userInfo);
	            			myFavoriteVO.setBoardAdmin_FG(boardInfo.getBoardAdmin_FG());
	            			intCount = ezBoardService.getQNABrdTotalItemCount(myFavoriteVO);
	            		}else{
	            			intCount = ezBoardService.getBrdTotalItemCount(myFavoriteVO);
	            		}
	            		String strName = "";
	            		if (intCount != 0)
	            			strName = "(" + intCount + ")";
	            		node.getChildNodes().item(0).setTextContent(node.getChildNodes().item(0).getTextContent() + strName);
	            	}
	            }
	        }
	    }
	    else{
	    	doc = builder.parse(new InputSource(new StringReader("<RESULT>ERROR</RESULT>")));
	    }
	    
	    TransformerFactory tf = TransformerFactory.newInstance();
	    Transformer transformer = tf.newTransformer();
	    transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
	    StringWriter writer = new StringWriter();
	    transformer.transform(new DOMSource(doc), new StreamResult(writer));
	    String output = writer.getBuffer().toString();

	    res.setContentType("text/xml"); 
        res.setCharacterEncoding("UTF-8");
        res.setHeader("Cache-Control", "no-cache");
        res.getWriter().write(output);

	}
	
	@RequestMapping(value="/ezBoard/saveListOrder.do", method = RequestMethod.POST)
	public @ResponseBody Map<String, Object> saveListOrder(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception {
		loginVO = commonUtil.userInfo(loginCookie);
        String pUserID = loginVO.getId();
        String pBoardList = request.getParameter("pBoardList");
        String pDelBoardList = request.getParameter("pDelboardList");
        int pBoardListCount = pBoardList.split(";").length-1;
        int pDelBoardListCount = pDelBoardList.split(";").length-1;
 
 		Map<String, Object> map = new HashMap<String, Object>();
        map.put("pBoardList",pBoardList);
        map.put("pDelBoardList",pDelBoardList);
        map.put("pBoardListCount",pBoardListCount);
        map.put("pBoardList",pBoardList);
        map.put("pDelBoardListCount",pDelBoardListCount);
        ezBoardService.setListOrder(pUserID, map);
		return map;
	}
	
	@RequestMapping(value="/ezBoard/set_TabUse.do")
	public String set_TabUse(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception{
		loginVO = commonUtil.userInfo(loginCookie);
		String pUserID = loginVO.getId();
		String pBoardList = request.getParameter("pBoardList");
		String tabUsed = request.getParameter("tabUsed");

		modelMap.addAttribute("pBoardList",pBoardList);
		modelMap.addAttribute("tabUsed",tabUsed);
        ezBoardService.setTabUsed(pUserID, pBoardList, tabUsed);
        return "json";
	}
	
	public boolean accessCheck(String itemID, String boardType, LoginVO userInfo) throws Exception{
        String rootBoardID = "top";
        String boardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(rootBoardID, userInfo.getId(), userInfo.getDeptID(), userInfo.getCompanyID());
        
        if (boardGroupAdmin_FG.equals("OK") || userInfo.getRollInfo().toLowerCase().indexOf("c=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("k=1") > -1 || userInfo.getRollInfo().toLowerCase().indexOf("n=1") > -1){
            return true;
        }
        else{
            int result = 0;
            boolean rtv = false;

            String deptPath = userInfo.getDeptPathCode();
            String deptPathOrgan = "";
            for (int ch = 0; ch < deptPath.split(",").length; ch++){
                if (ch == 0){
                	deptPathOrgan += deptPath.split(",")[ch].trim();
                }
                else{
                	deptPathOrgan += "," + deptPath.split(",")[deptPath.split(",").length - (ch)].trim();
                }
            }
            String userDeptPath = deptPathOrgan + ",everyone";

            if(boardType.toUpperCase() == "" || boardType == null){
            	boardType = "GENERAL";
            }
            for (int i = 0; i < userDeptPath.split(",").length; i++){
            	result = ezBoardService.getCheckItemID(itemID, boardType, userDeptPath.split(",")[i].trim());
            	
                if (boardType.toUpperCase() == "GENERAL"){
                    if (result > 0){
                        rtv = false;
                        break;
                    }
                    else{
                        rtv = true;
                    }
                }else{
                    if (result > 0){
                        rtv = true;
                        break;
                    }
                    else{
                        rtv = false;
                        break;
                    }
                }
            }
            return rtv;
        }
    }
	
	@RequestMapping(value = "/ezBoard/boardItemView.do")
	public String getBoardItemView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, Model model) throws Exception{
        String apprFlag = "Y";
        String extenLang = "1";
        String location = "";
        String useOcs = config.getProperty("config.USE_OCS");
        String useEditor = config.getProperty("config.EDITOR");
        String useIE11Browser = "";
        
        if((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && useIE11Browser.equals("CK")){
        	useIE11Browser = "CK";
        }

        String adjacentItemsEnableFlag = config.getProperty("config.ADJACENT_ITEMS_ENABLE");
        String showAdjacent = request.getParameter("showAdjacent");
        String boardID = request.getParameter("boardID");
        String itemID = request.getParameter("itemID");
        String pReservedItem = request.getParameter("pReservedItem");
        location = request.getParameter("location");
        userInfo = commonUtil.userInfo(loginCookie);
        if (!accessCheck(itemID, location, userInfo)){
        	return "main/warning";
        }
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
        String useEzKMS = config.getProperty("config.Use_ezKMS");
        if (!boardInfo.getRead_FG().equals("true")){
        	return "main/warning";
        }
        String guBun = boardInfo.getGuBun();
        //추가항목 잇을 경우 추가항목을 가져온다
        if (boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")){
        	//어드민쪽 소스 수정없을때 구현요망(지금 당장 안쓰임)
        	//ezBoardAdminService.getBoardAttribute(boardID);
            if (!userInfo.getLang().equals("1"))
                extenLang = "2";
        }
        BoardListVO boardItem = ezBoardService.getBrdGetItemInfo(boardID, itemID);
        ezBoardService.setAsRead(userInfo, boardID, itemID);
        
        if (boardItem.getApprFlag() != null && boardItem.getApprFlag().equals("N")){
		    int checkCnt = ezBoardService.getCheckApprUserList(userInfo.getId(), itemID);
		    if (checkCnt == 0){
		    	boardItem.setApprFlag("W");
		    }
        }
        BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(boardID);

        String nowTime = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
        String parentTime = boardItem.getParentWriteDate().toString();

        if (EgovDateUtil.getDaysDiff(parentTime.substring(0,10), nowTime.substring(0,10)) < 0){
            pReservedItem = "true";
        }
        if (EgovDateUtil.getDaysDiff(boardItem.getParentWriteDate().substring(0,10), boardItem.getWriteDate().substring(0,10)) < 0){
            boardItem.setWriteDate(boardItem.getParentWriteDate());
        }

        if (boardItem.getEndDate() != null && boardItem.getEndDate().substring(0, 4) == "9999"){
        	boardItem.setEndDate(egovMessageSource.getMessage("ezBoard.t287"));
        }
        if (adjacentItemsEnableFlag.equals("1") && showAdjacent.equals("1")){
            if (boardItem.getUpperItemIDTree() == null || boardItem.getUpperItemIDTree().equals("") ){
            	boardItem.setUpperItemIDTree(itemID);
            }
//            string strXML = "";
//            if (gubun != "3")
//                strXML = objEzBoard.GetAdjacentItems(pItemID, pBoardID, strUpperItemIDTree, GetDBTime(strParentWriteDate));
//            else
//                strXML = objEzBoard.GetAdjacentItems_PHOTO(pItemID, pBoardID, strUpperItemIDTree, GetDBTime(strParentWriteDate));
//
//            objEzBoard = null;
//
//            xmldom = new XmlDocument();
//            xmldom = GetXmlReaderString(strXML);
//            PreviousItemID = xmldom.GetElementsByTagName("PREVIOUSITEMID").Item(0).InnerText.Trim();
//            PreviousTitle = xmldom.GetElementsByTagName("PREVIOUSTITLE").Item(0).InnerText.Trim();
//            NextItemID = xmldom.GetElementsByTagName("NEXTITEMID").Item(0).InnerText.Trim();
//            NextTitle = xmldom.GetElementsByTagName("NEXTTITLE").Item(0).InnerText.Trim();
//
//            if (PreviousTitle == "") PreviousTitle = RM.GetString("t330");
//            if (NextTitle == "") NextTitle = RM.GetString("t331");
//
//            xmldom = null;
        }
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("boardItem", boardItem);
        model.addAttribute("boardPropertyVO", boardPropertyVO);
        model.addAttribute("apprFlag", apprFlag);
        model.addAttribute("extenLang", extenLang);
        model.addAttribute("location", location);
        model.addAttribute("useOcs", useOcs);
        model.addAttribute("useEditor", useEditor);
        model.addAttribute("useIE11Browser", useIE11Browser);
        model.addAttribute("adjacentItemsEnableFlag", adjacentItemsEnableFlag);
        model.addAttribute("showAdjacent", showAdjacent);
        model.addAttribute("boardID", boardID);
        model.addAttribute("itemID", itemID);
        model.addAttribute("pReservedItem", pReservedItem);
        model.addAttribute("useEzKMS", useEzKMS);
        model.addAttribute("guBun", guBun);
        
        return "ezBoard/boardItemView";
    }
	
	@RequestMapping(value="/ezBoard/setRead.do")
	public void setAsRead(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String pBoardID = "";
        String pItemIDList = "";
        if(request.getParameter("boardID") != null){
        	pBoardID = request.getParameter("boardID");
        }
        if(request.getParameter("itemIDList") != null){
        	pItemIDList = request.getParameter("itemIDList");
        }
        ezBoardService.setAsReads(userInfo, pBoardID, pItemIDList);
	}
	
	@RequestMapping(value = "/ezBoard/newBoardItem.do")
	public String newBoardItem(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo, BoardListVO boardListVO, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
        String extenLang = "1";
        String editor = config.getProperty("config.EDITOR");
        String uploadFilePath = config.getProperty("upload_board.ROOT");
        String mode = "";
        String boardID = "";
        String itemID = "";
        String url = "";
        String hasAttach = "";
        String strWriterFakeName = "";
        String reservedItem = "";
        String checkForm = "";
        String useBackGround = "";
        String docID = "";
        String boardType = "";
        
        if(request.getParameter("mode") != null){
        	mode = request.getParameter("mode");
        }
        if(boardListVO.getBoardID() != null){
        	boardID = boardListVO.getBoardID();
        }
        if(boardListVO.getItemID() != null){
        	itemID = boardListVO.getItemID();
        }
        if(request.getParameter("url") != null){
        	url = request.getParameter("url");
        }
        if(request.getParameter("BTYPE") != null){
        	boardType = request.getParameter("BTYPE");
        }
        if(request.getParameter("docid") != null){
        	docID = request.getParameter("docid");
        }
        if(request.getParameter("ReservedItem") != null){
        	reservedItem = request.getParameter("ReservedItem");
        }
        String newGuid = UUID.randomUUID().toString();
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
        if(boardInfo.getWrite_FG() != null && boardInfo.getWrite_FG().equals("false")){
        	return "main/warning";
        }
        //추가 항목 가져오는 소스 사용안하는듯
        List<BoardAttributeVO> boardAttributeListVO = new ArrayList<BoardAttributeVO>();
        if(boardInfo.getAttributeYN() != null && boardInfo.getAttributeYN().equals("Y")){
        	boardAttributeListVO = ezBoardAdminService.getBoardAttribute(boardID);
        	if(userInfo.getLang().equals("1")){
        		extenLang = "2";
        	}
        }
        String strNow = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "");
        String startDateTime = "";
        String endDateTime = "";
        String expireDays = "";
        String expireItem = "";
        String strTitle = "";
        
        if(!url.equals("")){
        	startDateTime = EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", "").split(" ")[0];
        	endDateTime = EgovDateUtil.addDay(startDateTime, 30);
        	expireDays = "-1";
        }else{
        	expireDays = boardInfo.getExpireDays();
        	if(!mode.equals("new")){
        		if(!mode.equals("temp")){
        			boardListVO = ezBoardService.getBrdGetItemInfo(boardID, itemID);
        		}else{
        			//temp는 나중에 개발
//        			boardListVO = ezBoardService.getBrdGetItemInfoTemp();
        		}
        		if(mode.equals("reply")){
        			boardListVO.setItemLevel(boardListVO.getItemLevel()+1);
        			boardListVO.setABSTRACT("");
        		}
        		strTitle = boardListVO.getTitle();
        		boardListVO.setTitle(URLEncoder.encode(boardListVO.getTitle(),"UTF-8"));
        		strTitle = URLEncoder.encode(strTitle, "UTF-8");
        		boardListVO.setABSTRACT(URLEncoder.encode(boardListVO.getABSTRACT(), "UTF-8"));
        		
        		if(Integer.parseInt(boardListVO.getAttachments()) > 0){
        			hasAttach = "YES";
        		}
        	}
        	startDateTime = egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString();
        	
        	if(mode.equals("modify") || mode.equals("temp")){
        		if(boardListVO.getEndDate().substring(0, 4).equals("9999")){
        			expireItem = "YES";
        			if(expireDays.equals("-1")){
        				endDateTime = EgovDateUtil.addDay(EgovDateUtil.getToday(), 30);
        			}else{
        				endDateTime = EgovDateUtil.addDay(EgovDateUtil.getToday(), Integer.parseInt(expireDays));
        			}
        		}else{
        			boardListVO.setEndDate(boardListVO.getEndDate().split(" ")[0]);
        		}
        		startDateTime = boardListVO.getStartDate();
        	}else{
        		if(expireDays.equals("-1")){
        			endDateTime = EgovDateUtil.addDay(EgovDateUtil.getToday(), 30);
    			}else{
    				endDateTime = EgovDateUtil.addDay(EgovDateUtil.getToday(), Integer.parseInt(expireDays));
    			}
        	}
        	if(boardInfo.getGuBun().equals("2")){
        		if(commonUtil.getMultiData(userInfo.getLang()).equals("")){
        			strWriterFakeName = boardListVO.getWriterName();
        			boardListVO.setWriterName("");
        		}else{
        			strWriterFakeName = boardListVO.getWriterName2();
        			boardListVO.setWriterName2("");
        		}
        	}
        }
        Calendar strDate = Calendar.getInstance();
        if(strDate.get(Calendar.MINUTE) > 30){
        	strDate.add(Calendar.HOUR, 1);
        	strDate.add(Calendar.MINUTE, -strDate.get(Calendar.MINUTE));
        	strDate.add(Calendar.SECOND, -strDate.get(Calendar.SECOND));
        }else{
        	strDate.add(Calendar.MINUTE, -strDate.get(Calendar.MINUTE));
        	strDate.add(Calendar.MINUTE, 30);
        	strDate.add(Calendar.SECOND, -strDate.get(Calendar.SECOND));
        }
        startDateTime = strDate.get(Calendar.YEAR)+ "-"+ (strDate.get(Calendar.MONTH)+1)+"-"+strDate.get(Calendar.DATE)+" "+strDate.get(Calendar.HOUR)+":"+strDate.get(Calendar.MINUTE)+":"+strDate.get(Calendar.SECOND);
        endDateTime = EgovDateUtil.convertDate(endDateTime,"0000","yyyy-MM-dd");
        if(reservedItem.equals("true")){
        	startDateTime = boardListVO.getStartDate();
        }
        
        checkForm = ezBoardService.checkForm(boardID, "Y");
        useBackGround = ezBoardService.checkBackGroundImage(boardID);
        
        model.addAttribute("boardInfo", boardInfo);
        model.addAttribute("boardListVO", boardListVO);
        model.addAttribute("boardAttributeListVO", boardAttributeListVO);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("extenLang", extenLang);
        model.addAttribute("editor", editor);
        model.addAttribute("uploadFilePath", uploadFilePath);
        model.addAttribute("mode", mode);
        model.addAttribute("boardID", boardID);
        model.addAttribute("itemID", itemID);
        model.addAttribute("url", url);
        model.addAttribute("hasAttach", hasAttach);
        model.addAttribute("strWriterFakeName", strWriterFakeName);
        model.addAttribute("reservedItem", reservedItem);
        model.addAttribute("checkForm", checkForm);
        model.addAttribute("useBackGround", useBackGround);
        model.addAttribute("strNow", strNow);
        model.addAttribute("startDateTime", startDateTime);
        model.addAttribute("endDateTime", endDateTime);
        model.addAttribute("expireDays", expireDays);
        model.addAttribute("expireItem", expireItem);
        model.addAttribute("strTitle", strTitle);
        model.addAttribute("newGuid", newGuid);
        model.addAttribute("docID", docID);
        model.addAttribute("boardType", boardType);
        
		return "ezBoard/boardNewItem";
	}
	
	public String isoUTFDate(String dateTimeStr) throws Exception{
        String timeSetStr = "";
        String resultStr = "";

        if (dateTimeStr.trim() != ""){
            if (dateTimeStr.indexOf(" ") != -1){
                if ((dateTimeStr.split(" ")[1] == "오후" || dateTimeStr.split(" ")[1] == egovMessageSource.getMessage("ezBoard.t213")) && Integer.parseInt(dateTimeStr.split(" ")[2].split(":")[0]) < 12){
                    timeSetStr = (dateTimeStr.split(" ")[2].split(":")[0]) + 12;
                    timeSetStr += ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                }
                else if (dateTimeStr.split(" ")[1] == "오전" || dateTimeStr.split(" ")[1] == egovMessageSource.getMessage("ezBoard.t212")){
                    if (dateTimeStr.split(" ")[2].split(":")[0].trim().length() <= 1){
                        timeSetStr = "0" + dateTimeStr.split(" ")[2].split(":")[0] + ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                    }
                    else if (Integer.parseInt(dateTimeStr.split(" ")[2].split(":")[0]) == 12){
                        timeSetStr = "00" + ":" + dateTimeStr.split(" ")[2].split(":")[1] + ":" + dateTimeStr.split(" ")[2].split(":")[2];
                    }
                    else{
                        timeSetStr = dateTimeStr.split(" ")[2];
                    }
                }
                else{
                    timeSetStr = dateTimeStr.split(" ")[2];
                }
                resultStr = dateTimeStr.split(" ")[0] + "T" + timeSetStr + ".000Z";
            }
            else{
                resultStr = dateTimeStr + "T00:00:00.000Z";
            }
        }
        else{
            resultStr = "";
        }
        return resultStr;
    }
	
	@RequestMapping(value = "/ezBoard/ckEditor.do")
	public String ckEditor(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);

		model.addAttribute("userInfo",userInfo);
		
		return "ezBoard/boardCKEditor";
	}
	
	@RequestMapping(value = "/ezBoard/dragAndDrop.do")
	public String dragAndDrop(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, Model model) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		
		model.addAttribute("userInfo",userInfo);
		
		return "ezBoard/boardDragAndDrop";
	}
	
	@RequestMapping(value = "/ezBoard/saveItem.do", produces = "text/xml; charset=utf-8")
	@ResponseBody
	public String saveItem(@CookieValue("loginCookie") String loginCookie,@RequestBody String xmlData, LoginVO userInfo, HttpServletRequest request) throws Exception{
		userInfo = commonUtil.userInfo(loginCookie);
		String pMode = "";
        String gubun = "";
        String realPath = request.getServletContext().getRealPath("");
        
        if (request.getParameter("mode") != null){
        	pMode = request.getParameter("mode");
        }
        if (request.getParameter("guBun") != null){
        	gubun = request.getParameter("guBun");
        }
        Document doc = commonUtil.convertStringToDocument(xmlData.toString());
        String attachList = "";
        String smallName = "";
        String title = "";
        String itemID = "";
        String[] attchArray = null;
        String[] smallArray = null;
        String[] itemid = null;

        BoardPropertyVO boardInfo = getBoardInfo(doc.getElementsByTagName("BOARDID").item(0).getTextContent(), userInfo);
        doc.getElementsByTagName("CONTENT").item(0).setTextContent(doc.getElementsByTagName("CONTENT").item(0).getTextContent().replace("\n", "\r\n"));;

        if (boardInfo.getWrite_FG().equals("false")){
            return "<RESULT>INACCESSIBLE</RESULT>";
        }
        if (gubun == "3"){
            attachList = doc.getElementsByTagName("ATTACHMENTS").item(0).getTextContent();
            smallName = doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent();
            title = doc.getElementsByTagName("TITLE").item(0).getTextContent();
            itemID = doc.getElementsByTagName("ITEMID").item(0).getTextContent();
            attchArray = attachList.split(";");
            smallArray = smallName.split(";");
            itemid = itemID.split(";");
        }                

        String ret = "";

        if (gubun == "3"){
            if (attchArray.length == smallArray.length){
                for (int i = 0; i < attchArray.length - 1; i++){
                    doc.getElementsByTagName("ATTACHMENTS").item(0).setTextContent(attchArray[i] + ";");
                    doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).setTextContent(smallArray[i]);
                    doc.getElementsByTagName("ITEMID").item(0).setTextContent(itemid[i]);
                    doc.getElementsByTagName("UPPERITEMIDTREE").item(0).setTextContent(itemid[i]);
                    if (attchArray.length > 2){
                    	doc.getElementsByTagName("TITLE").item(0).setTextContent(title + "_" + (i + 1));
                    }
                    if (i > 0){
                        pMode = "New";
                        doc.getElementsByTagName("STARTDATE").item(0).setTextContent(EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", ""));
                    }
                    ret = insertNewItem(doc, pMode, realPath);
                }
            }
        }else{
            ret = insertNewItem(doc, pMode, realPath);
        }

        return "<RESULT>" + ret + "</RESULT>";
	}

	private String insertNewItem(Document doc, String pMode, String realPath) throws Exception{
		BoardListVO boardListVO = new BoardListVO();

		boolean saveMHTResult = false;
		
		
		boardListVO.setFilePath(doc.getElementsByTagName("FILEPATH").item(0).getTextContent());
		boardListVO.setItemID(doc.getElementsByTagName("ITEMID").item(0).getTextContent());
		boardListVO.setBoardID(doc.getElementsByTagName("BOARDID").item(0).getTextContent());
		boardListVO.setWriterID(doc.getElementsByTagName("WRITERID").item(0).getTextContent());
		boardListVO.setTopWriterID(doc.getElementsByTagName("TOPWRITERID").item(0).getTextContent());
		boardListVO.setWriterName(doc.getElementsByTagName("WRITERNAME").item(0).getTextContent());
		boardListVO.setWriterName2(doc.getElementsByTagName("WRITERNAME2").item(0).getTextContent());
		boardListVO.setWriterDeptID(doc.getElementsByTagName("DEPTID").item(0).getTextContent());
		boardListVO.setWriterDeptName(doc.getElementsByTagName("DEPTNAME").item(0).getTextContent());
		boardListVO.setWriterDeptName2(doc.getElementsByTagName("DEPTNAME2").item(0).getTextContent());
		boardListVO.setWriterCompanyID(doc.getElementsByTagName("COMPANYID").item(0).getTextContent());
		boardListVO.setWriterCompanyName(doc.getElementsByTagName("COMPANYNAME").item(0).getTextContent());
		boardListVO.setWriterCompanyName2(doc.getElementsByTagName("COMPANYNAME2").item(0).getTextContent());
		boardListVO.setWriteDate(EgovDateUtil.convertDate(egovframework.rte.fdl.string.EgovDateUtil.getCurrentDateTimeAsString(), "", "", ""));
		boardListVO.setImportance(doc.getElementsByTagName("IMPORTANCE").item(0).getTextContent());
		boardListVO.setTitle(doc.getElementsByTagName("TITLE").item(0).getTextContent());
		if(pMode.equals("copy")){
			boardListVO.setContentLocation(doc.getElementsByTagName("CONTENTLOCATION").item(0).getTextContent());
		}else{
			boardListVO.setContentLocation(config.getProperty("upload_board.ROOT")+"/" + boardListVO.getBoardID() + "/doc/" + boardListVO.getItemID() + ".mht");
		}
		if(doc.getElementsByTagName("STARTDATE").item(0).getTextContent() != null && !doc.getElementsByTagName("STARTDATE").item(0).getTextContent().equals("")){
			boardListVO.setStartDate(doc.getElementsByTagName("STARTDATE").item(0).getTextContent());
		}else{
			boardListVO.setStartDate(boardListVO.getWriteDate());
		}
		boardListVO.setEndDate(doc.getElementsByTagName("ENDDATE").item(0).getTextContent());
		boardListVO.setABSTRACT(doc.getElementsByTagName("ABSTRACT").item(0).getTextContent());
		boardListVO.setAttachments(doc.getElementsByTagName("ATTACHMENTS").item(0).getTextContent());
		boardListVO.setUpperItemIDTree(doc.getElementsByTagName("UPPERITEMIDTREE").item(0).getTextContent());
		
		//답변의 경우 최근에 답변 달은 것이 최상위로 와야함(by design)
		if(pMode.equals("reply")){
			boardListVO.setUpperItemIDTree(boardListVO.getUpperItemIDTree() + getReverseDateNow() + boardListVO.getItemID());
		}
		boardListVO.setItemLevel(doc.getElementsByTagName("ITEMLEVEL").item(0).getTextContent());
		if(!pMode.equals("copy")){
			boardListVO.setMainContent(doc.getElementsByTagName("CONTENT").item(0).getTextContent());
			boardListVO.setParentWriteDate(doc.getElementsByTagName("PARENTWRITEDATE").item(0).getTextContent());
		}else{
			boardListVO.setParentWriteDate(boardListVO.getWriteDate());
		}
		
		if(boardListVO.getParentWriteDate().equals("")){
			boardListVO.setParentWriteDate(boardListVO.getStartDate());
		}

		//확장 필드, Ext1, Ext2는 integer 값을 가짐
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent().equals("")){
			boardListVO.setExtensionAttribute1("0");
		}else{
			boardListVO.setExtensionAttribute1(doc.getElementsByTagName("EXTENSIONATTRIBUTE1").item(0).getTextContent());
		}
		
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent() == null || doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent().equals("")){
			boardListVO.setExtensionAttribute2("0");
		}else{
			boardListVO.setExtensionAttribute2(doc.getElementsByTagName("EXTENSIONATTRIBUTE2").item(0).getTextContent());
		}
		
		boardListVO.setExtensionAttribute3(doc.getElementsByTagName("EXTENSIONATTRIBUTE3").item(0).getTextContent());
		boardListVO.setExtensionAttribute32(doc.getElementsByTagName("EXTENSIONATTRIBUTE32").item(0).getTextContent());
		boardListVO.setExtensionAttribute4(doc.getElementsByTagName("EXTENSIONATTRIBUTE4").item(0).getTextContent());
		boardListVO.setExtensionAttribute5(doc.getElementsByTagName("EXTENSIONATTRIBUTE5").item(0).getTextContent());
		boardListVO.setDocPassword(doc.getElementsByTagName("DOCPASSWORD").item(0).getTextContent());
		boardListVO.setReadFlag(doc.getElementsByTagName("READCOUNTFLAG").item(0).getTextContent());
		
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE6").item(0) != null){
			boardListVO.setExtensionAttribute6(doc.getElementsByTagName("EXTENSIONATTRIBUTE6").item(0).getTextContent());
		}else{
			boardListVO.setExtensionAttribute6("");
		}
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0) != null){
			boardListVO.setExtensionAttribute7(doc.getElementsByTagName("EXTENSIONATTRIBUTE7").item(0).getTextContent());
		}else{
			boardListVO.setExtensionAttribute7("");
		}
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE8").item(0) != null){
			boardListVO.setExtensionAttribute8(doc.getElementsByTagName("EXTENSIONATTRIBUTE8").item(0).getTextContent());
		}else{
			boardListVO.setExtensionAttribute8("");
		}
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE9").item(0) != null){
			boardListVO.setExtensionAttribute9(doc.getElementsByTagName("EXTENSIONATTRIBUTE9").item(0).getTextContent());
		}else{
			boardListVO.setExtensionAttribute9("");
		}
		if(doc.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0) != null){
			boardListVO.setExtensionAttribute10(doc.getElementsByTagName("EXTENSIONATTRIBUTE10").item(0).getTextContent());
		}else{
			boardListVO.setExtensionAttribute10("");
		}
		
		if(!pMode.equals("copy")){
			saveMHTResult = saveMHT(boardListVO.getMainContent(), boardListVO.getItemID(), boardListVO.getBoardID(), realPath + boardListVO.getFilePath(), "BOARD");
			if(saveMHTResult == false){
				return "ERROR:MHT 파일을 저장하는데 실패하였습니다.";
			}
		}
	
		if(boardListVO.getAttachments() != null || boardListVO.getAttachments().equals("")){
			boardListVO.setHasAttach("1");
		}else{
			boardListVO.setHasAttach("0");
		}
		
		if(boardListVO.getItemLevel() == null || boardListVO.getItemLevel().equals("")){
			boardListVO.setItemLevel("0");
		}

		if(pMode.equals("modify")){
//			ezBoardService.brdUpdateItem(boardListVO);
		}else if(pMode.equals("temp")){
//			ezBoardService.brdNewItemTemp(boardListVO);
		}else{
			ezBoardService.brdNewItem(boardListVO);
		}
		if(boardListVO.getAttachments() != null && !boardListVO.getAttachments().equals("")){
			if(!saveAttachmentsInfo(boardListVO.getAttachments(), boardListVO.getItemID(), boardListVO.getBoardID(), realPath + boardListVO.getFilePath(), "BOARD")){
				return "ERROR:첨부 파일 정보를 저장하는데 실패하였습니다.";
			}
			boardListVO.setHasAttach("1");
		}else{
			boardListVO.setHasAttach("0");
		}

		//통계 남기는 부분
		return "OK";
	}

	public boolean saveMHT(String strHTML, String strMHTFilename, String strBoardID, String strFilePath, String strType) {
		String docPath = "";
		String mhtFilePath = "";
		
        if (strType == "BOARD"){
            strHTML = strHTML.replace("'", "''");
        }
		docPath = strFilePath +"/"+ strBoardID;
		docPath = docPath.replace('\\','/');
		mhtFilePath = strMHTFilename + ".mht";
		InputStream stream = null;
		OutputStream bos = null;
		String stordFilePathReal = docPath + "/doc";
		try {
		    stream = new ByteArrayInputStream(strHTML.getBytes("UTF-8"));
		    File cFile = new File(docPath);
	
		    if (!cFile.isDirectory()) {
				boolean _flag = cFile.mkdir();
				cFile = new File(stordFilePathReal);
				cFile.mkdir();
				if (!_flag) {
				    throw new IOException("Directory creation Failed ");
				}
		    }
	
		    bos = new FileOutputStream(stordFilePathReal + File.separator + mhtFilePath);
	
		    int bytesRead = 0;
		    byte[] buffer = new byte[BUFF_SIZE];
	
		    while ((bytesRead = stream.read(buffer, 0, BUFF_SIZE)) != -1) {
		    	bos.write(buffer, 0, bytesRead);
		    }
		} catch (FileNotFoundException fnfe) {
			LOGGER.debug("fnfe: {}", fnfe);
			return false;
		} catch (IOException ioe) {
			LOGGER.debug("ioe: {}", ioe);
			return false;
		} catch (Exception e) {
			LOGGER.debug("e: {}", e);
			return false;
		} finally {
		    if (bos != null) {
				try {
				    bos.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		    if (stream != null) {
				try {
				    stream.close();
				} catch (Exception ignore) {
					LOGGER.debug("IGNORED: {}", ignore.getMessage());
				}
		    }
		}
		return true;
	}

	public String getReverseDateNow() {
		StringBuilder reverseDate = new StringBuilder();
		Calendar cal = Calendar.getInstance();
		
		reverseDate.append(9999 - cal.get(Calendar.YEAR));
		reverseDate.append(21 - cal.get(Calendar.MONTH));
		reverseDate.append(41 - cal.get(Calendar.DATE));
		reverseDate.append(33 - cal.get(Calendar.HOUR));
		reverseDate.append(69 - cal.get(Calendar.MINUTE));
		reverseDate.append(69 - cal.get(Calendar.SECOND));
		
		return reverseDate.toString();
	}
	
	public boolean saveAttachmentsInfo(String strAttachments, String strItemID, String strBoardID, String strFilePath, String strType){
        long fileSize = 0;
        String filepath = "";
        String filename = "";
        String[] temp = null;
        if (strAttachments.substring(strAttachments.length() - 1) != ";"){
        	strAttachments += ";";
        }
        
//        for (int i = 0; i < strAttachments.split(";").length - 1; i++){
//            if (strType.equals("BOARD")){
//                File file = new File(strFilePath + "\\" + strAttachments.split(";")[i].replace("/", "\\"));
//                fileSize = file.length();
//                if (strAttachments.split(";")[i].indexOf("tempUploadFile") > -1){
//                    filepath = strFilePath + "\\" + strBoardID + "\\uploadFile" + strAttachments.split(";")[i].replace("/", "\\").replace("tempUploadFile", "");
//                    File fileinfo = new File(filepath);
//                    if (!fileinfo.exists()){
//                    	FileUtils.moveDirectoryToDirectory(src, destDir, createDestDir);
//                    }
//                }
//                else
//                {
//                    filepath = strFilePath + "\\" + strAttachments.Split(';')[i].Replace("/", "\\");
//                }
//                file = null;
//            }
//            else
//            {
//                FileInfo file = new FileInfo(strFilePath + "\\" + "tempUploadFile\\" + strAttachments.Split(';')[i].Split('/')[2]);
//                fileSize = file.Length.ToString();
//                filepath = strFilePath + "\\" + strBoardID + "\\uploadFile\\" + strAttachments.Split(';')[i].Split('/')[2];
//
//                FileInfo fileinfo = new FileInfo(filepath);
//                if (!fileinfo.Exists)
//                    file.MoveTo(filepath);
//                file = null;
//            }
//            temp = strAttachments.Split(';')[i].Split('_');
//            for (int j = 1; j < temp.Length; j++)
//            {
//                if (j == 1)
//                    filename += temp[j];
//                else
//                    filename += "_" + temp[j];
//            }
//            cmd = new OracleCommand("EZSP_SAVEATTACHMENTSINFO");
//            cmd.CommandType = CommandType.StoredProcedure;
//            cmd.Parameters.Add("v_STRITEMID", OracleType.NChar, 38).Value = strItemID;
//            cmd.Parameters.Add("v_STRATTACHMENTS", OracleType.NVarChar, 200).Value = filepath.Replace(strFilePath + "\\", "").Replace("\\", "/");
//            cmd.Parameters.Add("v_FILESIZE", OracleType.NVarChar, 50).Value = fileSize;
//            cmd.Parameters.Add("v_FILENAME", OracleType.NVarChar, 50).Value = filename;
//
//            ExecuteSP(ref cmd);
//            filename = null;
//            temp = null;
//        }
        return true;
	}
	
}