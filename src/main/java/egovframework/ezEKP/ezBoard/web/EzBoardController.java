package egovframework.ezEKP.ezBoard.web;

import java.io.StringReader;
import java.io.StringWriter;
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
import org.springframework.web.servlet.HandlerMapping;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import egovframework.com.cmm.EgovMessageSource;
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
	public void get_favoriteList(@CookieValue("loginCookie") String loginCookie, ModelMap modelMap,HttpServletRequest request,HttpServletResponse response,LoginVO loginVO) throws Exception{
	
		loginVO = commonUtil.userInfo(loginCookie);
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
    public void getBoardList(@CookieValue("loginCookie") String loginCookie, LoginVO userInfo, EzBoardVO ezBoardVO, HttpServletResponse res) throws Exception{
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
	public String getBoardListItem(EzBoardVO ezBoardVO, LoginVO userInfo, String type) throws Exception{
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
            	
            	MyFavoriteVO myFavoriteVO = new MyFavoriteVO();
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
	
	public String getItemXML(String boardID, String itemID, String multiData) throws Exception{
		List<BoardListVO> boardItemList = ezBoardService.getBrdGetItemInfo(boardID, itemID);
        StringBuilder sb = new StringBuilder();
//		sb.Append("<NODES>");
//    
//		for (int i=0; i<xmldoc.SelectNodes("DATA/ROW").Count; i++)
//		{
//			sb.Append("<NODE>");
//			sb.Append("<ItemID>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("ITEMID").InnerText.Trim() + "</ItemID>");
//			sb.Append("<WriterID>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("WRITERID").InnerText.Trim() + "</WriterID>");
//            sb.Append("<WriterName>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("WRITERNAME" + strLang).InnerText.Trim()) + "</WriterName>");
//            sb.Append("<WriterDeptName>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("WRITERDEPTNAME" + strLang).InnerText.Trim()) + "</WriterDeptName>");
//            sb.Append("<WriterCompanyName>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("WRITERCOMPANYNAME" + strLang).InnerText.Trim()) + "</WriterCompanyName>");
//			sb.Append("<WriteDate>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("WRITEDATE").InnerText.Trim() + "</WriteDate>");
//			sb.Append("<ParentWriteDate>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("PARENTWRITEDATE").InnerText.Trim() + "</ParentWriteDate>");
//			sb.Append("<Importance>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("IMPORTANCE").InnerText.Trim() + "</Importance>");
//			sb.Append("<Title>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("TITLE").InnerText.Trim()) + "</Title>");
//			sb.Append("<ContentLocation>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("CONTENTLOCATION").InnerText.Trim() + "</ContentLocation>");
//			sb.Append("<StartDate>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("STARTDATE").InnerText.Trim() + "</StartDate>");
//			sb.Append("<EndDate>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("ENDDATE").InnerText.Trim() + "</EndDate>");
//			sb.Append("<Abstract>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("ABSTRACT").InnerText.Trim()) + "</Abstract>");
//			sb.Append("<Attachments>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("ATTACHMENTS").InnerText.Trim()) + "</Attachments>");
//			sb.Append("<UpperItemIDTree>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("UPPERITEMIDTREE").InnerText.Trim() + "</UpperItemIDTree>");
//			sb.Append("<ItemLevel>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("ITEMLEVEL").InnerText.Trim() + "</ItemLevel>");
//			sb.Append("<copiedItem>" + xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("COPIEDITEM").InnerText.Trim() + "</copiedItem>");
//			sb.Append("<ExtensionAttribute1>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE1").InnerText.Trim()) + "</ExtensionAttribute1>");
//			sb.Append("<ExtensionAttribute2>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE2").InnerText.Trim()) + "</ExtensionAttribute2>");
//            sb.Append("<ExtensionAttribute3>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE3" + strLang).InnerText.Trim()) + "</ExtensionAttribute3>");
//			sb.Append("<ExtensionAttribute4>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE4").InnerText.Trim()) + "</ExtensionAttribute4>");
//			sb.Append("<ExtensionAttribute5>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE5").InnerText.Trim()) + "</ExtensionAttribute5>");
//            sb.Append("<MainContent>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("MAINCONTENT").InnerText.Trim()) + "</MainContent>");  //2013.04.08 Photo Album 
//            sb.Append("<APPRFLAG>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("APPRFLAG").InnerText.Trim()) + "</APPRFLAG>");
//            sb.Append("<GUBUN>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("GUBUN").InnerText.Trim()) + "</GUBUN>");
//            //확장값 추가
//            sb.Append("<ExtensionAttribute6>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE6").InnerText.Trim()) + "</ExtensionAttribute6>");
//            sb.Append("<ExtensionAttribute7>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE7").InnerText.Trim()) + "</ExtensionAttribute7>");
//            sb.Append("<ExtensionAttribute8>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE8").InnerText.Trim()) + "</ExtensionAttribute8>");
//            sb.Append("<ExtensionAttribute9>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE9").InnerText.Trim()) + "</ExtensionAttribute9>");
//            sb.Append("<ExtensionAttribute10>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("EXTENSIONATTRIBUTE10").InnerText.Trim()) + "</ExtensionAttribute10>");
//            sb.Append("<BoardID>" + MakeXMLString(xmldoc.SelectNodes("DATA/ROW").Item(i).SelectSingleNode("BOARDID").InnerText.Trim()) + "</BoardID>");
//			sb.Append("</NODE>");
//		}        
//
//		sb.Append("</NODES>");

		return sb.toString();
	}
	
	@RequestMapping(value = "/ezBoard/boardItemView.do")
	public String getBoardItemView(@CookieValue("loginCookie") String loginCookie, HttpServletRequest request, LoginVO userInfo) throws Exception{
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
        	return "warning";
        }
        BoardPropertyVO boardInfo = getBoardInfo(boardID, userInfo);
        String useEzKMS = config.getProperty("config.Use_ezKMS");

        if (boardInfo.getRead_FG().equals("true")){
        	return "warning";
        }
        String guBun = boardInfo.getGuBun();
        String boardName = boardInfo.getBoardName();

        //추가항목 잇을 경우 추가항목을 가져온다
        if (boardInfo.getAttributeYN().equals("Y")){
        	//어드민쪽 소스 수정없을때 구현요망(지금 당장 안쓰임)
        	//ezBoardAdminService.getBoardAttribute(boardID);
            if (!userInfo.getLang().equals("1"))
                extenLang = "2";
        }

        String ret = getItemXML(boardID, itemID, commonUtil.getMultiData(userInfo.getLang()));
//        objEzBoard.SetAsRead(userinfo.UserID, userinfo.DisplayName1, userinfo.DeptName1, userinfo.CompanyName1, userinfo.Title1, pBoardID, pItemID, userinfo.DisplayName2, userinfo.DeptName2, userinfo.CompanyName2, userinfo.Title2);
//        
//        xmldom = GetXmlReaderString(ret);
//
//        if (xmldom.GetElementsByTagName("WriterID").Count == 0)
//        {
//            Response.Redirect("/error.aspx");
//        }
//
//        strWriterName = xmldom.SelectSingleNode("NODES/NODE/WriterName").InnerText;
//        if (gubun != "2")
//        {
//            strWriterID = xmldom.SelectSingleNode("NODES/NODE/WriterID").InnerText;
//            strWriterDeptName = xmldom.SelectSingleNode("NODES/NODE/WriterDeptName").InnerText;
//            strWriterCompanyName = xmldom.SelectSingleNode("NODES/NODE/WriterCompanyName").InnerText;
//        }
//
//        strStartDate = GetLocalTime(xmldom.SelectSingleNode("NODES/NODE/StartDate").InnerText);
//        strWriteDate = GetLocalTime(xmldom.SelectSingleNode("NODES/NODE/WriteDate").InnerText);
//        strParentWriteDate = GetLocalTime(xmldom.SelectSingleNode("NODES/NODE/ParentWriteDate").InnerText);
//        strImportance = xmldom.SelectSingleNode("NODES/NODE/Importance").InnerText;
//        strTitle = Server.HtmlEncode(xmldom.SelectSingleNode("NODES/NODE/Title").InnerText);
//        strEndDate = GetLocalTime(xmldom.SelectSingleNode("NODES/NODE/EndDate").InnerText);
//        strAbstract = xmldom.SelectSingleNode("NODES/NODE/Abstract").InnerText;
//        strUpperItemIDTree = xmldom.SelectSingleNode("NODES/NODE/UpperItemIDTree").InnerText;
//        strAttachments = xmldom.SelectSingleNode("NODES/NODE/Attachments").InnerText;
//        strContentLocation = xmldom.SelectSingleNode("NODES/NODE/ContentLocation").InnerText;
//        CopiedFlag = xmldom.SelectSingleNode("NODES/NODE/copiedItem").InnerText;
//        ExtensionAttribute1 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute1").InnerText;
//        ExtensionAttribute2 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute2").InnerText;
//        ExtensionAttribute3 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute3").InnerText;
//        ExtensionAttribute4 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute4").InnerText;
//        ExtensionAttribute5 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute5").InnerText;
//        ApprFlag = xmldom.SelectSingleNode("NODES/NODE/APPRFLAG").InnerText;
//        //추가항목
//        ExtensionAttribute6 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute6").InnerText;
//        ExtensionAttribute7 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute7").InnerText;
//        ExtensionAttribute8 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute8").InnerText;
//        ExtensionAttribute9 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute9").InnerText;
//        ExtensionAttribute10 = xmldom.SelectSingleNode("NODES/NODE/ExtensionAttribute10").InnerText;
//        if (ApprFlag == "N")
//        {
//            OracleCommand cmd = new OracleCommand("EZSP_CHECKAPPRUSERLIST");
//            cmd.CommandType = CommandType.StoredProcedure;
//            cmd.Parameters.Add("v_PUSERID", OracleType.NVarChar, 50).Value = userinfo.UserID;
//            cmd.Parameters.Add("v_PITEMID", OracleType.NChar, 38).Value = pItemID;
//            cmd.Parameters.Add("v_pCount", OracleType.Number).Direction = ParameterDirection.Output;
//        string strXML = Convert.ToString(GetQueryValueSP(ref cmd));
//        cmd.Dispose();
//
//        XmlDocument xmldom2 = new XmlDocument();
//        xmldom2 = GetXmlReaderString(strXML);
//
//        string checkCnt = xmldom2.GetElementsByTagName("CNT").Item(0).InnerText;
//        if (checkCnt == "0")
//            ApprFlag = "W";
//        }
//        
//        ret = GetBoardProperty(pBoardID);
//        xmldom = GetXmlReaderString(ret);
//        OneLineReplyFlag = xmldom.SelectSingleNode("NODES/NODE/ONELINEREPLY").InnerText;
//        xmldom = null;
//
//        System.DateTime dt = System.DateTime.Now;
//        string nowTime = GetLocalTime(dt.ToString()).Replace(":", "").Replace(" ", "").Replace("-", "");
//        string parentTime = strParentWriteDate.Replace(":", "").Replace(" ", "").Replace("-", "");
//
//        if (long.Parse(parentTime) > long.Parse(nowTime))
//        {
//            pReservedItem = "true";
//        }
//        if (System.String.Compare(strParentWriteDate, strWriteDate, false) > 0)
//        {
//            strWriteDate = strParentWriteDate;
//        }
//
//        if (strEndDate.Substring(0, 4) == "9999")
//            strEndDate = RM.GetString("t287");
//
//        MenuCount = 0;
//
//        if (AdjacentItemsEnableFlag == "1" && ShowAdjacent == "1")
//        {
//            objEzBoard = new Kaoni.ezStandard.ezBoardSTD.ItemView();
//            if (strUpperItemIDTree == "" || strUpperItemIDTree == null)
//                strUpperItemIDTree = pItemID;
//
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
//        }
//
//        if (gubun == "3")
//        {
//            try
//            {
//                g_ImageUrl = ExtensionAttribute5;
//
//                if (g_ImageUrl.Length > 0)
//                {
//                    int idx = g_ImageUrl.LastIndexOf("/");
//
//                    g_ImageUrl = "/Upload_BoardSTD/" + g_ImageUrl.Substring(0, idx + 1) + g_ImageUrl.Substring(idx + 3);
//                    pFile_Path = Server.MapPath(g_ImageUrl);
//
//                    g_ImageUrl = "/Upload_BoardSTD/" + ExtensionAttribute5.Substring(0, idx + 1) + ExtensionAttribute5.Substring(idx + 3).Replace("+", "%20");
//
//                    g_ImageUrl = "/myoffice/Common/DownloadAttach.aspx?filepath=" + Server.UrlEncode(g_ImageUrl);
//
//                    if (File.Exists(pFile_Path))
//                    {
//                        System.Drawing.Image image = System.Drawing.Image.FromFile(pFile_Path);
//                        int nWidth = image.Width;
//                        int nHeight = image.Height;
//
//                        if (nWidth > 600)
//                        {
//                            g_Width = "600";
//                            nHeight = (nHeight * int.Parse(g_Width)) / nWidth;
//                            g_Height = nHeight.ToString();
//                        }
//                        else
//                        {
//                            g_Width = nWidth.ToString();
//                            g_Height = nHeight.ToString();
//                        }
//                    }
//                    else
//                    {
//                        g_Width = "600";
//                        g_Height = "450";
//                    }
//                }
//            }
//            catch (Exception ex)
//            {
//                WriteTextLog("BoardItemView", "Page_Load", ex.ToString());
//            }
//        }
        return "";
    }
	
	public String FileNameConvert(String name){
        return name.replace("\\", "").replace("/", "").replace(":", "").replace("*", "").replace("?", "")
            .replace("\"", "").replace("<", "").replace(">", "").replace("|", "")
            .replace("#", "").replace("!", "").replace(".", "");
    }
}