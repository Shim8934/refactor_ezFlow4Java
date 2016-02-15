package egovframework.ezEKP.ezBoard.web;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import egovframework.ezEKP.ezBoard.service.EzBoardAdminService;
import egovframework.ezEKP.ezBoard.service.EzBoardService;
import egovframework.ezEKP.ezBoard.vo.BoardTreeVO;
import egovframework.ezEKP.ezBoard.vo.EzBoardVO;

@Controller
public class EzBoardController {
 
	@Resource(name="EzBoardService")
	private EzBoardService ezBoardService;
	
	@Resource(name="EzBoardAdminService")
	private EzBoardAdminService ezBoardAdminService;
	
	@RequestMapping(value="/ezEKP/ezBoard/web/left_boardSTD.do")
	public String left_BoardSTD(HttpServletRequest request, ModelMap modelMap) throws Exception{
		String RedirectBoardID = "";
        String RedirectBoardGroupID = "";
        String _Func = "";
        String _subFunc = "";
        String _PhotoType = "";
        String _ApplyFlag = "";
        
        //유저정보 가져오기 아직 미구현이므로 고정값으로 테스트 @수정요망@
//        CreateUserInfo();
        String strLang = "1";
		String pUserID = "yoonz44";
		String pDeptID = "OPENSOL";
		String pCompanyID = "S907000";
		String pRollInfo = "c=1;k=1;g=1;a=1;i=1;n=1;l=1;w=1;m=1;";
		
		if(request.getParameter("PhotoType") != null){
			_PhotoType  = request.getParameter("PhotoType");
		}
		
		if(request.getParameter("BoardID") != null){
			RedirectBoardID  = request.getParameter("BoardID");
			
			List<EzBoardVO> leftBoardList = ezBoardService.getLeft_BoardSTD(RedirectBoardID);
			for(EzBoardVO i :  leftBoardList){
				RedirectBoardGroupID += i.getBoardGroupId()+",";
			}
			if(RedirectBoardGroupID.length() != 0)
				RedirectBoardGroupID = RedirectBoardGroupID.substring(0, RedirectBoardGroupID.length()-1);
		}
		
		if(request.getParameter("Func") != null){
			_Func = request.getParameter("Func");
		}
		
		if(request.getParameter("subFunc") != null){
			_subFunc = request.getParameter("subFunc");
		}
		
		String pRootBoardID = "top";
		String pSubFlag = "0";
        int pSelectBy = 0;
        String pExcludeBoardID = " ";
//        String BoardGroupAdmin_FG = ezBoardAdminService.checkIfBoardGroupAdmin(pRootBoardID,pUserID,pDeptID,pCompanyID);
        String BoardGroupAdmin_FG = "OK";
        List<EzBoardVO> ApplyUserList = ezBoardAdminService.checkApplyUser();
        
        for(EzBoardVO vo: ApplyUserList){
        	if(vo.getApprUserId().toLowerCase().indexOf(pUserID.toLowerCase()) > -1){
        		_ApplyFlag = "OK";
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
        
		return "ezBoard/left_BoardStd";
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
//        	map.addAttribute("retValue", retValue);
//            return "kaoni/left_boardSTD";
//        }
        String pAccessID = pUserID + "," + ezBoardAdminService.getDeptFullPath(pDeptID, "Top") + ",everyone";
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
            
            if (tempstr.indexOf(";") > -1)
            {
                for (int r = 0; r < tempstr.split(";").length - 1; r++)
                {
                   strForbiddenBoardIDList += tempstr.split(";")[r].trim() + ";";
                }
            }
            
//            if (pAccessID.split(";")[i].trim() != pUserID && pAccessID.split(";")[i].trim() != pCompanyID && pAccessID.split(";")[i].trim() != pDeptID)
//            {
//                for (int j = 0; j < brdBoardTreeList.size(); j++)
//                {
//                    if (pAccessID.split(",")[i].trim() != "top")
//                    {
//                    	if (brdBoardTreeList.get(j).getBOARDGROUPACL().toUpperCase() == "N")
//                        {
//                    		brdBoardTreeList.remove(j);
//                            j--;
//                        }
//                    }
//                }
//            }
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
	
	public String checkIfLeafBoard(String pBoardID){
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
}
