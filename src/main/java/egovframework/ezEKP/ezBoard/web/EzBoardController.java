package egovframework.ezEKP.ezBoard.web;

import java.io.StringReader;
import java.io.StringWriter;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

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

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.filter.HTMLTagFilterRequestWrapper;
import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardConfigVO;
import egovframework.ezEKP.ezBoard.vo.BoardListHeaderVO;
import egovframework.ezEKP.ezBoard.vo.BoardListVO;
import egovframework.ezEKP.ezBoard.vo.BoardPropertyVO;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;
import egovframework.ezEKP.ezBoard.vo.MyFavoriteVO;
import egovframework.ezEKP.ezOrgan.service.EzOrganService;
import egovframework.let.user.login.service.LoginService;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;
import egovframework.let.utl.fcc.service.EgovDateUtil;
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
	
	private HTMLTagFilterRequestWrapper htmlTagFilter;
	
	@RequestMapping(value="/ezBoard/boardLeft.do")
	public String boardLeft(@CookieValue("userID") String userID, HttpServletRequest request, ModelMap modelMap, LoginVO loginVO, HttpServletResponse response) throws Exception{
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
		
		int pSelectBy = 0;
		String pRootBoardID = "top";
		String pSubFlag = "0";
        String pExcludeBoardID = " ";
        String BoardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID,pUserID,pDeptID,pCompanyID);
        
        List<EzBoardVO> ApplyUserList = ezBoardAdminService.checkApplyUser();
        
        for(EzBoardVO vo: ApplyUserList){
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
            List<EzBoardVO> boardTreeList = ezBoardAdminService.getBoardTree_Get2(pAccessID.split(",")[i].trim(),pRootBoardID);
            
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
	public void get_favoriteList(@CookieValue("userID") String userID, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception{
	
		loginVO = commonUtil.userInfo(userID);
		List<MyFavoriteVO> resultList = new ArrayList<MyFavoriteVO>();
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
	public String boardGeneral(@CookieValue("userID") String userID, LoginVO loginVO, Model model) throws Exception {
		loginVO.setId(userID);
		loginVO = commonUtil.userInfo(userID); 
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
	public @ResponseBody Map<String, Object>boardGeneralListSave(@CookieValue("userID") String userID, LoginVO loginVO,HttpServletRequest req) throws Exception {
		loginVO.setId(userID);
		loginVO = commonUtil.userInfo(userID);
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
	
	public String parentBoardName(List<MyFavoriteVO> resultList) throws Exception{
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
   public void getMyBoards_Config(HttpServletRequest req, @CookieValue("userID") String userID, LoginVO loginVO, HttpServletResponse res) throws Exception{
	   loginVO = commonUtil.userInfo(userID);
	   String lang = loginVO.getLang();
	   try{
           String pRootTreeID = "";
           String pCountFlag = "";
           
           if(req.getParameter("RootTreeID") != null)
               pRootTreeID = req.getParameter("RootTreeID");
           if(req.getParameter("COUNTFLAG") != null)
               pCountFlag = req.getParameter("COUNTFLAG");

           List<MyFavoriteVO> resultList = getMyBoardTreeConfig(loginVO.getId(), pRootTreeID, commonUtil.getMultiData(lang));
           
           if(config.getProperty("config.USE_BOARD_LEFTMENU_COUNT").toString() == "YES" && pCountFlag == "YES"){
               String strName = "";
               int intCount;
               
               MyFavoriteVO myFavoriteVO = new MyFavoriteVO();
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
	
	public List<MyFavoriteVO> getMyBoardTreeConfig(String userID,String pRootTreeID,String lang) throws Exception{
        List<MyFavoriteVO> resultList  = ezBoardAdminService.getMyBoardTree_get3(userID,pRootTreeID.trim());

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
	@RequestMapping(value="/ezBoard/boardItemList_new.do")
	public String boardItemList_new(HttpServletRequest request, HttpServletResponse response, LoginVO loginVO,BoardPropertyVO boardPropertyVO, @CookieValue("userID") String userID, Model model) throws Exception{
		String pBoardID = boardPropertyVO.getBoardID();
        String use_ocs = config.getProperty("config.USE_OCS"); 
        String use_Editor = config.getProperty("config.EDITOR"); 
        String use_IE11Browser = config.getProperty("config.IE11EDITOR");
        String use_oneLineCount = "";
        
        loginVO = commonUtil.userInfo(userID);
        if((request.getHeader("User-Agent").indexOf("rv:11") > 0 || request.getHeader("User-Agent").indexOf("Trident/7.0") > 0) && use_IE11Browser.equals("CK"))
            use_IE11Browser = "CK";
        
//            response.Buffer = true;
//            if(vpnLogin != null)
//                isVPN = vpnLogin;
        boardPropertyVO = getBoardInfo(pBoardID,loginVO);
        boardPropertyVO = getBoardProperty(pBoardID);
        if(boardPropertyVO != null)
            use_oneLineCount = "YES";
        else
            use_oneLineCount = "NO";
        
        if(boardPropertyVO.getListViewFG()== "true"){
            if(request.getParameter("page") == null)
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
    
    public BoardPropertyVO getBoardProperty(String pBoardID) throws Exception{
        BoardPropertyVO boardPropertyVO = ezBoardService.getBoardProperty(pBoardID);
        return boardPropertyVO;
    }
    
    // 게시판의 정보를 가져오는 함수
	public BoardPropertyVO getBoardInfo(String pBoardID, LoginVO userInfo) throws Exception{
		BoardPropertyVO boardInfo = new BoardPropertyVO();
		boardInfo.setSs_board_maxRows(20);
		boardInfo.setSs_searchBoard_maxRows(10);             

		if(pBoardID == ""){
			boardInfo.setBoardName(egovMessageSource.getMessage("t229"));		
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
	    
//	    String userDeptPath = deptPathOrgan+",everyone";
	    
//		for (int i=0; i<userDeptPath.split(",").length; i++)
//		{
//			boardInfo = ezBoardAdminService.getACL(pBoardID, userDeptPath.split(",")[i].trim());
//			if(boardInfo == null)
//				break;
//		}
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
		}else if(boardInfo.equals(null)){
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
	
    protected boolean CheckDBColum(String pProvValue) throws Exception{
        boolean bRet = false;
        // 사용자 속성명
        switch (pProvValue.toUpperCase()){
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
        switch (pProvValue.toUpperCase()){
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
    
    @RequestMapping(value = "/ezBoard/getBoardList.do")
    public void getBoardList(@CookieValue("userID") String userID, LoginVO userInfo, EzBoardVO ezBoardVO, HttpServletResponse res) throws Exception{
        String boardID = ezBoardVO.getBoardId();
        String boardType = ezBoardVO.getBoardType();
        String type = "1";
        String resultXML = "";
        
        userInfo = commonUtil.userInfo(userID);
        userInfo.setLang("1");
//        BoardPropertyVO boardInfo = getBoardInfo(boardID,userInfo);
        
        if(ezBoardVO.getOrderOption() != null)
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
//            	boardXml = getBoardListItem(ezBoardVO);
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

	public String getNewItemList(EzBoardVO ezBoardVO, LoginVO userInfo) throws Exception{
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
                if(fieldName.toUpperCase() == "WRITERNAME" || fieldName.toUpperCase() == "WRITERJOBTITLE" || fieldName.toUpperCase() == "WRITERDEPTNAME" || fieldName.toUpperCase() == "BOARDNAME"){
                    fieldName = fieldName + strMultiData;
                }
                if(fieldName.toUpperCase() == "WRITEDATE"){
                    Date dt = (Date) boardList.get(j).get(fieldName);
                    fieldValue = dt.toString();
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
	
	@RequestMapping(value = "/ezBoard/getSubBoards.do")
	public void getSubBoards(@CookieValue("userID") String userID, LoginVO userInfo, BoardPropertyVO boardInfo, HttpServletRequest req, HttpServletResponse res) throws Exception{
		userInfo = commonUtil.userInfo(userID);
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
            	
            	long time = System.currentTimeMillis(); 
            	SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
            	String dateTime = dayTime.format(new Date(time));
    			
            	MyFavoriteVO myFavoriteVO = new MyFavoriteVO();
            	int intCount = 0;
	            if(nList != null){
	            	for (int i = 0; i < nList.getLength(); i++){
	            		Node node = nList.item(i);
	            		
	            		myFavoriteVO.setBoardId(node.getChildNodes().item(2).getTextContent());
            			myFavoriteVO.setNowDate(dateTime);
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
	public @ResponseBody Map<String, Object> saveListOrder(@CookieValue("userID") String userID, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception {
		loginVO = commonUtil.userInfo(userID);
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
	public String set_TabUse(@CookieValue("userID") String userID, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception{
		loginVO = commonUtil.userInfo(userID);
		String pUserID = loginVO.getId();
		String pBoardList = request.getParameter("pBoardList");
		String tabUsed = request.getParameter("tabUsed");

		modelMap.addAttribute("pBoardList",pBoardList);
		modelMap.addAttribute("tabUsed",tabUsed);
        ezBoardService.setTabUsed(pUserID, pBoardList, tabUsed);
        return "json";
	}
}
