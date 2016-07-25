package egovframework.ezEKP.ezPortal.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.w3c.dom.Document;

import egovframework.ezEKP.ezCommon.service.EzCommonService;
import egovframework.ezEKP.ezPortal.dao.EzPortalDAO;
import egovframework.ezEKP.ezPortal.service.EzPortalService;
import egovframework.ezEKP.ezPortal.vo.PortalGetMainMenuHtmlVO;
import egovframework.ezEKP.ezPortal.vo.PortalGetRenderedTopMenuInsertVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsImageVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsSVO;
import egovframework.ezEKP.ezPortal.vo.PortalMenuItemItemsMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLPortalPageGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLThemeGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuGeneralVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLTopMenuItemsVO;
import egovframework.ezEKP.ezPortal.vo.PortalTBLUserInfoVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopLoadGetParametersVO;
import egovframework.ezEKP.ezPortal.vo.PortalTopSearchTopMenu2VO;
import egovframework.let.user.login.vo.LoginVO;
import egovframework.let.utl.fcc.service.CommonUtil;

@Service("EzPortalService")
public class EzPortalServiceImpl implements EzPortalService {
	@Resource(name="EzPortalDAO")
	private EzPortalDAO ezPortalDAO;
	
	@Resource(name="EzCommonService")
	private EzCommonService ezCommonService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	private String gTheme = "BASIC";
	private String gSkinNum = "1";

	@Override
	public String getTopMenuConfigItem(String itemName, String uID) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pITEMNAME", itemName);
		map.put("v_pUID", uID);
	
		return ezPortalDAO.getTopMenuConfigItem(map);
	}

	@Override
	public void deleteCacheValue(String uID, String accessListID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID);
		map.put("v_pACCESSLISTID", accessListID);
		ezPortalDAO.deleteCacheValue(map);
	}
	
	@Override
	public String checkCacheValue(String portalPageID, String accessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PORTALPAGEID", portalPageID);
		map.put("v_ACCESSIDLIST", accessIDList);
		return ezPortalDAO.checkCacheValue(map);
	}
	
	
	@Override
	public String topGetTopParentPageID(String uID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			String temp = uID;
			String parentTopMenuID = "";
			int count = 0;
			while (count < 10) {
				map.put("v_pUID", temp);
				parentTopMenuID = ezPortalDAO.topGetTopParentPageID(map);
				
				if (parentTopMenuID.toLowerCase().trim().equals("top")) {
					break;
				}
				temp = parentTopMenuID;
				count ++;
			}
			return temp;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	@Override
	public PortalGetRenderedTopMenuInsertVO getRenderedTopMenuInsert(String uID) throws Exception {
		
		return ezPortalDAO.getRenderedTopMenuInsert(uID);
	}

	@Override
	public List<PortalTBLTopMenuItemsVO> getTBLTopMenuItems(String strSQL) throws Exception {
		
		
		return ezPortalDAO.getTBLTopMenuItems(strSQL);
	}

	@Override
	public String getParentUID(String parentTopMenuID) throws Exception {
		return ezPortalDAO.getParentUID(parentTopMenuID);
	}
	
	@Override
	public void getUserInfo3(String parentUID, String userFlag, String userID, String gubunFlag, String newPageID, String userName,
			String accessID, String accessName, int viewRight, int editRight, int depth, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", parentUID);
		map.put("v_pUSERFLAG", userFlag);
		map.put("v_pUSERID", userID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("v_pNEWPAGEID", newPageID);
		map.put("v_pUSERNAME", userName);
		map.put("v_pACCESSID", accessID);
		map.put("v_pACCESSNAME", accessName);
		map.put("v_pVIEW_RIGHT", viewRight);
		map.put("v_pEDIT_RIGHT", editRight);
		map.put("v_pDEPTH", depth);
		map.put("v_pCOMPANYID", companyID);
		ezPortalDAO.getUserInfo3(map);
	}
	
	@Override
	public int getUserInfo4(String companyID, String creatorID, String gubunFlag, String useFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pCREATORID", creatorID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		map.put("v_pUSEFLAG", useFlag);
		return ezPortalDAO.getUserInfo4(map);
	}
	
	@Override
	public PortalTBLPortalPageGeneralVO getUserInfo5(int pCount, String useFlag, String companyID, String parentUID, String userID, String gubunFlag) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pCOUNT", pCount);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pPARENTUID", parentUID);
		map.put("v_pUSERID", userID);
		map.put("v_pGUBUNFLAG", gubunFlag);
		return ezPortalDAO.getUserInfo5(map);
				
	}
	
	@Override
	public int checkEditRight(String uID, String accessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSIDLIST", accessIDList);
		return ezPortalDAO.checkEditRight(map);
	}
	

	@Override
	public List<PortalTBLPortalPageGeneralVO> searchMyPortalPage2( String pAccessIDList, String pGubunFlag, String pStrRight, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pACCESSIDLIST", pAccessIDList);
		map.put("v_pGUBUNFLAG", pGubunFlag);
		map.put("v_pSTRRIGHT", pStrRight);
		map.put("v_pCOMPANYID", pCompanyID);
		return ezPortalDAO.searchMyPortalPage2(map);
	}
	
	@Override
	public int checkViewRight(String uID, String accessIDList) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_UID", uID);
		map.put("v_ACCESSIDLIST", accessIDList);
		return ezPortalDAO.checkViewRight(map);
	}
	
	@Override
	public List<PortalTBLTopMenuGeneralVO> topSearchTopMenu3(int endRow, String displayName, String useFlag, String companyID, String lang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", endRow);
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		map.put("v_pLANG", lang);
		return ezPortalDAO.topSearchTopMenu3(map);
	}
	
	@Override
	public PortalTBLUserInfoVO topGetUserInfo2(String pUserID, String pLang) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pLANG", pLang);
		return ezPortalDAO.topGetUserInfo2(map);
	}
	
	@Override
	public PortalTBLUserInfoVO topGetUserInfo(String pUserID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		return ezPortalDAO.topGetUserInfo(map);
	}
	
	@Override
	public List<PortalTopSearchTopMenu2VO> topSearchTopMenu2(int endRow, String displayName, String useFlag, String companyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pENDROW", endRow);
		map.put("v_pDISPLAYNAME", displayName);
		map.put("v_pUSEFLAG", useFlag);
		map.put("v_pCOMPANYID", companyID);
		return ezPortalDAO.topSearchTopMenu2(map);
	}
	
	@Override
	public PortalTBLThemeGeneralVO getThemeInfo(String pUID, String pGubun) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_PUID", pUID);
		map.put("v_PGUBUN", pGubun); 
		return ezPortalDAO.getThemeInfo(map);
	}
	
	@Override
	public String useStartPageChack(String pUserID, String pCompanyID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID); 
		return ezPortalDAO.useStartPageChack(map);
	}
	
	@Override
	public String useStartPageChack2(String pUserID, String pCompanyID, String pParentUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUSERID", pUserID);
		map.put("v_pCOMPANYID", pCompanyID);
		map.put("v_pPARENTUID", pParentUID);
		return ezPortalDAO.useStartPageChack2(map);
	}

	@Override
	public int getMenuItemHtml(String uID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", uID); 
		return ezPortalDAO.getMenuItemHtml(map);
	}
	
	@Override
	public String getMenuItemConfigItem(String itemName, String uID)throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pITEMNAME", itemName); 
		map.put("v_pUID", uID); 
		return ezPortalDAO.getMenuItemConfigItem(map);
	}
	
	@Override
	public String getLogoHtml(String pOwnerPageID, String pAccessID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID); 
		map.put("v_pACCESSID", pAccessID);  
		return ezPortalDAO.getLogoHtml(map);
	}
	
	@Override
	public PortalMenuItemItemsImageVO getImageHtml(String pUID, String pParentUID, int pSkinNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID); 
		map.put("v_pPARENTUID", pParentUID);
		map.put("v_pSKINNUM", pSkinNum);  
		return ezPortalDAO.getImageHtml(map);
	}
	
	@Override
	public List<PortalTopLoadGetParametersVO> topLoadGetParameters(String pUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pUID", pUID);  
		return ezPortalDAO.topLoadGetParameters(map);
	}
	
	@Override
	public List<PortalMenuItemItemsMenuItemsVO> getUtilMenuHtml(String pParentUID, String pOwnerPageID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID); 
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		return ezPortalDAO.getUtilMenuHtml(map);
	}
	
	@Override
	public List<PortalGetMainMenuHtmlVO> getMainMenuHtml(String pParentUID, String pOwnerPageID, int pSkinNum) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID); 
		map.put("v_pOWNERPAGEID", pOwnerPageID);
		map.put("v_pSKINNUM", pSkinNum);
		return ezPortalDAO.getMainMenuHtml(map);
	}

	@Override
	public List<PortalMenuItemItemsMenuItemsVO> getSubMenuHtml(String pOwnerPageID, String pParentUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pOWNERPAGEID", pOwnerPageID); 
		map.put("v_pPARENTUID", pParentUID);
		return ezPortalDAO.getSubMenuHtml(map);
	}

	@Override
	public List<PortalMenuItemItemsMenuItemsSVO> getSubMenuHtml2( String pParentUID) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("v_pPARENTUID", pParentUID);
		return ezPortalDAO.getSubMenuHtml2(map);
	}

	public String getAccessList(LoginVO userInfo) {
		try {
			String pDeptPathCode = userInfo.getDeptPathCode();
			String ret = "";
			String pIDUser = "";
			String pIDTop = "";
			String pIDCompany = "";
			String pIDDept = "";
			//부서가 있으면 부서를 먼저 체크하도록 배열 변경
			if (pDeptPathCode.split(",").length == 4) {
				pIDUser = pDeptPathCode.split("\\,")[0].trim();
				pIDTop = pDeptPathCode.split("\\,")[1].trim();
				pIDCompany = pDeptPathCode.split("\\,")[2].trim();
				pIDDept = pDeptPathCode.split("\\,")[3].trim();
				pDeptPathCode = pIDUser + "," + pIDTop + "," + pIDDept + "," + pIDCompany;
			}
			
			if (pDeptPathCode.toLowerCase().indexOf(",everyone") == -1) {
				ret = pDeptPathCode + ",everyone";
			} else {
				ret = pDeptPathCode;
			}
System.out.println("ret:"+ret);
			return ret;
		} catch (Exception e) {
			e.printStackTrace();
			return ",";
		}
	}
	
	public String getDefaultTopMenu() {
		try {
			StringBuilder sb = new StringBuilder();
			 sb.append("<table id='main_table' border=1 cellpadding=0 cellspacing=0 width=100% height=200px style='table-layout:fixed;boarder-collapse:collapse'>\n");
             sb.append("<tr id='main_row'>\n");
             sb.append("<td id='td0' valign=top onclick='selectcell(event)'><table border=1 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
             sb.append("<TBODY>");
             sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
             sb.append("</TBODY></table></td>");
             sb.append("</tr></table>");
			
             String strPage = sb.toString();
             
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuHTML (String topMenuID, String accessIDList, String mode, String skinNum, LoginVO userInfo, String theme) {
		try {
			if (mode.equals("view")) {
				String cacheValue = checkCacheValue(topMenuID, getAccessList(userInfo));
				if (cacheValue != null) {
					return cacheValue;
				}
			}
			
			if (!skinNum.equals("")) {
				this.gSkinNum = skinNum;
			}
			
			if (!theme.equals("")) {
				this.gTheme = theme;
			}
			
			StringBuilder sb = new StringBuilder();
			String strXML = "";
			String pageUID = "";
			String pageParentUID = "";
			String pageDisplayName = "";
			String pageWidth = "";
			String pageHeight = "";
			String pageRowLength = "";
			String pageColumnLength = "";
			String pageRowSplit = "";
			String pageColumnSplit = "";
			String rootParentUID = topGetTopParentPageID(topMenuID); // 최상위 페이지 ID
			String boarderValue = "0";
			int i = 0;
			
			StringBuilder dsb = new StringBuilder();
			if (mode.equals("edit")) {
				boarderValue = "1";
				  dsb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
                  dsb.append("<tr id='main_row'>\n");
                  dsb.append("<td id='td0' valign=top onclick='selectcell(event)'><table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                  dsb.append("<TBODY>");
                  dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
                  dsb.append("</TBODY></table></td>");
                  dsb.append("</tr></table>");
			}
			String defaultValue = dsb.toString();
			
			PortalGetRenderedTopMenuInsertVO result = getRenderedTopMenuInsert(topMenuID);
			
			if (result == null) {
				return defaultValue;
			}
			pageUID = result.getuID();
			pageParentUID = result.getParentUID();
			pageDisplayName = result.getDisplayName();
			pageWidth = getTopMenuConfigItem("WIDTH",rootParentUID);
			pageHeight = getTopMenuConfigItem("HEIGHT",rootParentUID);
			pageRowLength = getTopMenuConfigItem("ROWLENGTH",rootParentUID);
			pageColumnLength = getTopMenuConfigItem("COLUMNLENGTH",rootParentUID);
			pageRowSplit = getTopMenuConfigItem("ROWSPLIT",rootParentUID);
			pageColumnSplit = getTopMenuConfigItem("COLUMNSPLIT",rootParentUID);
			
			if (mode.equals("edit")) {
				sb.append("<table id='main_table' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
                if (!pageWidth.equals("-1") && !pageWidth.equals("0") &&  !pageWidth.toLowerCase().equals("")) {
                	sb.append("width=" + pageWidth + "px ");
                } else {
                	sb.append("width=100% ");
                }
                if (!pageHeight.equals("-1") && !pageHeight.equals("0") &&  !pageHeight.toLowerCase().equals("")) {
                	sb.append("height=" + pageHeight + "px ");
                } else {
                	sb.append("height=100% ");
                }
                sb.append("style='table-layout:fixed;'>\n");
                sb.append("<tr id='main_row'>\n");
			}
			
			for (int j=0; j<Integer.parseInt(pageColumnLength); j++) {
				if (mode.equals("edit")) {
					String columnWidth = "*";
					if (j == Integer.parseInt(pageColumnLength) - 1) {
						sb.append("<TD id=td0 vAlign=top>\n");
					} else {
						sb.append("<td id='td" + String.valueOf((i + 1)) + "' valign=top");
						if (!pageColumnSplit.equals("")) {
							if (!pageColumnSplit.split(";")[j].equals("") && pageColumnSplit.split(";")[j].equals("*")) {
								columnWidth = pageColumnSplit.split(";")[j] + "px";
								sb.append(" style='width:" + columnWidth + "'>\n");
							}
						} else {
							sb.append(">\n");
						}
					}
					sb.append("<table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                    sb.append("<TBODY>\n");
                    sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>" + columnWidth + "</td></TR>\n");
                    sb.append(getRenderedTopMenuColumn(topMenuID, accessIDList, i + 1, mode, userInfo));   // 각 컬럼의 메뉴를 랜더링
                    sb.append("</tbody>\n</table>\n</td>\n");
					} else {
System.out.println("topMeunu:"+getRenderedTopMenuColumn(topMenuID, accessIDList, i + 1, mode, userInfo));
						sb.append("<div id= 'top'>\n");
						sb.append("<header>\n");
						sb.append(getRenderedTopMenuColumn(topMenuID, accessIDList, i + 1, mode, userInfo));   // 각 컬럼의 메뉴를 랜더링
						if(theme != "BASIC") {
	                	  sb.append("</header>\n");
						}
					}
				}
			 if (mode.equals("edit")) {
				 sb.append("</tr>\n</table>\n");
			 } else {
				 sb.append("</div>\n"); 
             }
             
			 String strPage = sb.toString();
			 sb = null;
			 if (mode.equals("view")) {
				 //updateCacheValue
			 }
			 return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuColumn (String pTopMenuID, String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) {
		try {
			
			StringBuilder sb = new StringBuilder();
			String strSQL = "";
			String pSQL = "";
			String strXML = "";
			String parentTopMenuID = pTopMenuID; // 자신의 상위페이지 ID
			
			int count = 0;
			
			strSQL = "SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + pTopMenuID + "' AND ColumnPos = " + pColumnIndex;
			
			while (count < 10) {
				
				parentTopMenuID = getParentUID(parentTopMenuID);
				
				if (parentTopMenuID.toLowerCase().trim().equals("top")) {
					break;
				}
				String param = String.valueOf(count);
				strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + param + "' AND ColumnPos = " + parentTopMenuID;
				count ++;
			}
System.out.println("strSQL:"+strSQL);			

			List<PortalTBLTopMenuItemsVO> result = getTBLTopMenuItems(strSQL);
			
			if (result == null) {
				return "";
			}
			
			for (int i=0; i<result.size(); i++) {
				String menuItemMenuItemType = result.get(i).getMenuItemType();
				String menuItemUID = result.get(i).getuID();
				String menuItemPageUID = result.get(i).getPageUID();
				String menuItemParentPageUID = result.get(i).getParentPageUID();
				String menuItemDisplayName = result.get(i).getDisplayName();
				String menuItemWidth = result.get(i).getWidth();
				String menuItemHeight = result.get(i).getHeight();
				String menuItemRowPos = result.get(i).getRowPos();
				String menuItemColumnPos = result.get(i).getColumnPos();
				String menuItemCanRemove = result.get(i).getCanRemove();
				String menuItemCanResize = result.get(i).getCanResize();
				String menuItemCanReplace = result.get(i).getCanReplace();
				String menuItemAlign = result.get(i).getAlign();
				String menuItemValign = result.get(i).getValign();
				String menuItemPaddingLeft = result.get(i).getLeftMargin();
				String menuItemPaddingRight = result.get(i).getRightMargin();
				String menuItemPaddingTop = result.get(i).getTopMargin();
				String menuItemPaddingBottom = result.get(i).getBottomMargin();
				
				if (pMode.equals("edit")) {
					if (!menuItemHeight.toLowerCase().equals(""))	{
						sb.append("<TR style='WIDTH: 100%; HEIGHT: " + menuItemHeight + "px'>\n");
					} else  {
						sb.append("<TR style='WIDTH: 100%; HEIGHT: 100px'>\n");
					}
					if (menuItemMenuItemType.equals("0")) {
						sb.append("<TD id=subtd" + String.valueOf(pColumnIndex*100+i+1) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'><B>" + menuItemDisplayName + "</B></TD>\n");
					} else {
						sb.append("<TD id=subtd" + String.valueOf(pColumnIndex*100+i+1) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'>" + getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "edit", userInfo) + "</TD>\n");
					}
                    sb.append("</TR>\n");
				} else {  // 보기모드 : HTML로 렌더링
					sb.append(getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "view", userInfo));
				}
			}
			String strPage = sb.toString();
			
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getRenderedTopMenuColumnInsert (String pCallingMenuID, String pTopMenuID , String pAccessIDList, int pColumnIndex, String pMode, LoginVO userInfo) {
		try {
			
			StringBuilder sb = new StringBuilder();
			String strSQL = "";
			String pSQL = "";
			String strXML = "";
			String parentTopMenuID = pTopMenuID; // 자신의 상위페이지 ID
			
			int count = 0;
			
			strSQL = "SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + pTopMenuID + "' AND ColumnPos = " + pColumnIndex;
			
			while (count < 10) {
				parentTopMenuID = ezPortalDAO.getParentUID(parentTopMenuID);
				
				if (parentTopMenuID.toLowerCase().trim().equals("top")) {
					break;
				}
				String param = String.valueOf(count);
				strSQL += " UNION ALL SELECT * FROM ezPortal.TBL_TopMenu_Items  WHERE PageUID = '" + param + "' AND ColumnPos = " + parentTopMenuID;
				count ++;
			}

System.out.println("strSQL:"+strSQL);
			
			List<PortalTBLTopMenuItemsVO> result = getTBLTopMenuItems(strSQL);
			
			if (result == null) {
				return "";
			}
			
			for (int i=0; i<result.size(); i++) {
				String menuItemMenuItemType = result.get(i).getMenuItemType();
				String menuItemUID = result.get(i).getuID();
				String menuItemPageUID = result.get(i).getPageUID();
				String menuItemParentPageUID = result.get(i).getParentPageUID();
				String menuItemDisplayName = result.get(i).getDisplayName();
				String menuItemWidth = result.get(i).getWidth();
				String menuItemHeight = result.get(i).getHeight();
				String menuItemRowPos = result.get(i).getRowPos();
				String menuItemColumnPos = result.get(i).getColumnPos();
				String menuItemCanRemove = result.get(i).getCanRemove();
				String menuItemCanResize = result.get(i).getCanResize();
				String menuItemCanReplace = result.get(i).getCanReplace();
				String menuItemAlign = result.get(i).getAlign();
				String menuItemValign = result.get(i).getValign();
				String menuItemPaddingLeft = result.get(i).getLeftMargin();
				String menuItemPaddingRight = result.get(i).getRightMargin();
				String menuItemPaddingTop = result.get(i).getTopMargin();
				String menuItemPaddingBottom = result.get(i).getBottomMargin();
				
				if (pMode.equals("edit")) {
					if (!menuItemHeight.toLowerCase().equals(""))	{
						sb.append("<TR style='WIDTH: 100%; HEIGHT: " + menuItemHeight + "px'>\n");
					} else  {
						sb.append("<TR style='WIDTH: 100%; HEIGHT: 100px'>\n");
					}
					if (menuItemMenuItemType.equals("0")) {
						sb.append("<TD id=subtd" + UUID.randomUUID().toString().subSequence(0, 4) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'><B>" + menuItemDisplayName + "</B></TD>\n");
					} else {
						sb.append("<TD id=subtd" + UUID.randomUUID().toString().subSequence(0, 4) + " style='WIDTH: 100%' align=middle uid='" + menuItemUID + "' pageuid='" + menuItemPageUID + "' canremove='" + menuItemCanRemove + "' canresize='" + menuItemCanResize + "' canreplace='" + menuItemCanReplace + "'>" + getRenderedTopMenuHTMLInsert(pTopMenuID, menuItemUID, "", "edit", userInfo) + "</TD>\n");
					}
                    sb.append("</TR>\n");
				} else { 
					if (menuItemMenuItemType.equals("0")) {
System.out.println("11111");
						sb.append(getMenuItemHTML(pCallingMenuID, menuItemUID, userInfo));
						//sb.append(g)
					} else {
System.out.println("22222");
						sb.append(getRenderedTopMenuHTMLInsert(pCallingMenuID, menuItemUID, "", "view", userInfo));
					}
				}
			}
			String strPage = sb.toString();
			
			return strPage;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	
	public String getRenderedTopMenuHTMLInsert (String pCallingMenuID, String pTopMenuID, String pAccessIDList, String pMode, LoginVO userInfo) {
		try {
			StringBuilder sb = new StringBuilder();
			String strXML = "";
			String rootParentUID = topGetTopParentPageID(pTopMenuID);
			String boarderValue = "0";
			
			if (pMode.equals("edit")) {
				boarderValue = "1";
			}
			
			StringBuilder dsb = new StringBuilder();
			if (pMode.equals("edit")) {
				dsb.append("<table id='main_table_" + UUID.randomUUID().toString().substring(0, 4) + "' border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% height=100% style='table-layout:fixed;boarder-collapse:collapse'>\n");
                dsb.append("<tr id='main_row'>\n");
                dsb.append("<td id='td" + UUID.randomUUID().toString().substring(0, 4) + "' valign=top onclick='selectcell(event)'><table border=0 cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                dsb.append("<TBODY>");
                dsb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>*</td></TR>");
                dsb.append("</TBODY></table></td>");
                dsb.append("</tr></table>");
			}
			
			String defaultValue = dsb.toString();
			dsb = null;
			
			PortalGetRenderedTopMenuInsertVO result = getRenderedTopMenuInsert(pTopMenuID);
			
			if (result == null) {
				return defaultValue;
			}
			
			String pageUID = result.getuID();
			String pageParentUID = result.getParentUID();
			String pageDisplayName = result.getDisplayName();
			String pageWidth = getTopMenuConfigItem("WIDTH",rootParentUID);
			String pageHeight = getTopMenuConfigItem("HEIGHT",rootParentUID);
			String pageRowLength = getTopMenuConfigItem("ROWLENGTH",rootParentUID);
			String pageColumnLength = getTopMenuConfigItem("COLUMNLENGTH",rootParentUID);
			String pageRowSplit = getTopMenuConfigItem("ROWSPLIT",rootParentUID);
			String pageColumnSplit = getTopMenuConfigItem("COLUMNSPLIT",rootParentUID);
			
			if (pMode.equals("edit")) {
				dsb.append("<table id='main_table_" + UUID.randomUUID().toString().substring(0, 4) + "' border=" + boarderValue + " cellpadding=0 cellspacing=0 ");
				if (!pageWidth.equals("0") && !pageWidth.equals("-1") && !pageWidth.equals("")) {
					sb.append("width=" + pageWidth + "px ");
				} else {
					sb.append("width=100% ");
				}
				if (!pageHeight.equals("0") && !pageHeight.equals("-1") && !pageHeight.equals("")) {
					sb.append("height=" + pageHeight + "px ");
				} else {
					sb.append("height=100% ");
				}
				sb.append("style='table-layout:fixed;'>\n");
                sb.append("<tr id='main_row'>\n");
			}
			
			for (int i=0; i<Integer.parseInt(pageColumnLength); i++) {
				if (pMode.equals("edit")) {
					String columnWidth = "*";
					if (i == Integer.parseInt(pageColumnLength) - 1) {
						sb.append("<TD id='td0" + UUID.randomUUID().toString().substring(0, 4) + "' vAlign=top>\n");
					} else {
						sb.append("<td id='td" + UUID.randomUUID().toString().substring(0, 4) + "' valign=top");
						if (!pageColumnSplit.equals("")) {
							if (!pageColumnSplit.split(";")[i].equals("") && !pageColumnSplit.split(";")[i].equals("*")) {
								columnWidth = pageColumnSplit.split(";")[i] + "px";
								sb.append(" style='width:" + columnWidth + "'>\n");
							}
						} else {
							sb.append(">\n");
						}
					}
					sb.append("<table border=" + boarderValue + " cellpadding=0 cellspacing=0 width=100% valign=top>\n");
                    sb.append("<TBODY>\n");
                    if (pMode == "edit") {
                    	sb.append("<TR style='WIDTH: 100%; HEIGHT: 10px' onclick='selectcellTitle(event)'><td align=center>" + columnWidth + "</td></TR>\n");
                    }
                    sb.append(getRenderedTopMenuColumnInsert(pCallingMenuID, pTopMenuID, pAccessIDList, i + 1, pMode, userInfo));
                    sb.append("</tbody>\n</table>\n</td>\n");
				} else {
					sb.append(getRenderedTopMenuColumnInsert(pCallingMenuID, pTopMenuID, pAccessIDList, i + 1, pMode, userInfo));
					}
				}
				if (pMode.equals("edit")) {
					sb.append("</tr>\n</table>\n");
				}
				String strPage = sb.toString();
				sb = null;
				
				return strPage;
			
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
		
	public boolean checkEditRightBln (String pUID, String pAccessIDList) {
		try {
			for (int i=0; i<pAccessIDList.split(",").length; i++) {
				int right = checkEditRight(pUID, pAccessIDList.split(",")[i].trim());
				if (right == 2) {
					return true;
				}
				if (right == 1) {
					return false;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean checkViewRightBln (String pUID, String pAccessIDList) {
		try {
System.out.println("acceessIDList:"+pAccessIDList);
System.out.println("length:"+pAccessIDList.split("\\,").length);
			for (int i=0; i<pAccessIDList.split("\\,").length; i++) {
				int right = checkViewRight(pUID, pAccessIDList.split(",")[i].trim());
System.out.println("[i]:"+i);
System.out.println("temp:"+pAccessIDList.split(",")[i].trim());
System.out.println("right:"+right);
				if (right == 2) {
					return true;
				}
				if (right == 1) {
					return false;
				}
			}
			return false;
		} catch (Exception e) {
			e.printStackTrace();
System.out.println("?????");
			return true;
		}
	}
	
	
	public String getUserInfo(String pUserID, String pUserName, String parentUID, String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) {
		try {
			if (pMode.equals("edit")) {
				//checkEditRight
				if (checkEditRightBln(parentUID, getAccessList(userInfo)) == true) {
					String newPageID = UUID.randomUUID().toString();
					getUserInfo3(parentUID, "Y", pUserID, pGubunFlag, newPageID, pUserName, "everyone", "최상위회사", 2, 2, 2, pCompanyID);
				}
			}
			
			int resultNumber = getUserInfo4(pCompanyID, pUserID, pGubunFlag, "Y");
			
			PortalTBLPortalPageGeneralVO resultXML = getUserInfo5(resultNumber, "Y", pCompanyID, parentUID, pUserID, pGubunFlag);
			
			String result = "";
			result += "<DATA>";
			result += commonUtil.getQueryResult(resultXML); 
			result += "</DATA>";
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String searchMyPortalPage (String pGubunFlag, String pMode, LoginVO userInfo, String pCompanyID) {
		try {
			List<PortalTBLPortalPageGeneralVO> result = new ArrayList<PortalTBLPortalPageGeneralVO>();
			String strRight = "";
			if (pMode.equals("view")) {
				strRight = "B.View_Right=2";
			} else {
				strRight = "B.Edit_Right=2";
			}
			String strXML = "<DATA />";
			boolean bExist = false;
			String pAccessIDList = getAccessList(userInfo);
			
			for (int i=0; i<pAccessIDList.split(",").length; i++) {
				result = searchMyPortalPage2(pAccessIDList.split(",")[i].trim(), pGubunFlag, strRight, pCompanyID);
				if (result.size() > 0) {
					bExist = true;
				}
				
				if (bExist == true) {
					break;
				}
			}
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			for (int i=0; i<result.size(); i++) {
				if (pMode.equals("view")) {
					if (checkViewRightBln(result.get(i).getuID().trim(), pAccessIDList) == true) {
						sb.append("<ROW>");
						sb.append("<UID_>" + result.get(i).getuID() + "</UID_>");
                        sb.append("<DISPLAYNAME>" + result.get(i).getDisplayName() + "</DISPLAYNAME>");
                        sb.append("<DEPTH>" + result.get(i).getDepth() + "</DEPTH>");
                        sb.append("<CREATEDATE>" + result.get(i).getCreateDate() + "</CREATEDATE>");
                        sb.append("<GUBUNFLAG>" + result.get(i).getGubunFlag() + "</GUBUNFLAG>");
                        sb.append("<USEFLAG>" + result.get(i).getUseFlag() + "</USEFLAG>");
                        sb.append("<DEFAULTPAGE>" + result.get(i).getDefaultPage() + "</DEFAULTPAGE>");
                        sb.append("<THEMEUID>" + result.get(i).getThemeUID() + "</THEMEUID>");
                        sb.append("</ROW>");
					}
				} else {
					if (checkEditRightBln(result.get(i).getuID().trim(), pAccessIDList) == true) {
						sb.append("<ROW>");
						sb.append("<UID_>" + result.get(i).getuID() + "</UID_>");
                        sb.append("<DISPLAYNAME>" + result.get(i).getDisplayName() + "</DISPLAYNAME>");
                        sb.append("<DEPTH>" + result.get(i).getDepth() + "</DEPTH>");
                        sb.append("<CREATEDATE>" + result.get(i).getCreateDate() + "</CREATEDATE>");
                        sb.append("<GUBUNFLAG>" + result.get(i).getGubunFlag() + "</GUBUNFLAG>");
                        sb.append("<USEFLAG>" + result.get(i).getUseFlag() + "</USEFLAG>");
                        sb.append("<DEFAULTPAGE>" + result.get(i).getDefaultPage() + "</DEFAULTPAGE>");
                        sb.append("<THEMEUID>" + result.get(i).getThemeUID() + "</THEMEUID>");
                        sb.append("</ROW>");
					}
				}
			}
			sb.append("</DATA>");
			
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String langStr, String pCompanyID) {
		try {
			List<PortalTBLTopMenuGeneralVO> resultList = topSearchTopMenu3(pEndRow, pDisplayName, pUseFlag, pCompanyID, langStr);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<resultList.size(); i++) {
				if (i >= pStartRow - 1) {
					sb.append("<ROW>");
					sb.append("<UID_>" + resultList.get(i).getuID() + "</UID_>");
					sb.append("<DISPLAYNAME>" + resultList.get(i).getDisplayName() + "</DISPLAYNAME>");
                    sb.append("<DISPLAYNAME2>" + resultList.get(i).getDisplayName2() + "</DISPLAYNAME2>");
					sb.append("<USEFLAG>" + resultList.get(i).getUseFlag() + "</USEFLAG>");
					sb.append("<LANG>" + resultList.get(i).getLang() + "</LANG>");
                    sb.append("<THEMEUID>" + resultList.get(i).getThemeUID() + "</THEMEUID>");
					sb.append("</ROW>");
				}
			}
			sb.append("</DATA>");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String searchTopMenu (String pDisplayName, String pUseFlag, int pStartRow, int pEndRow, String pAccessIDList, String pCompanyID) {
		try {
			List<PortalTopSearchTopMenu2VO> resultList = topSearchTopMenu2(pEndRow, pDisplayName, pUseFlag, pCompanyID);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<DATA>");
			
			for (int i=0; i<resultList.size(); i++) {
				if (i >= pStartRow - 1) {
					sb.append("<ROW>");
					sb.append("<UID_>" + resultList.get(i).getuID() + "</UID_>");
					sb.append("<DISPLAYNAME>" + resultList.get(i).getDisplayName() + "</DISPLAYNAME>");
                    sb.append("<DISPLAYNAME2>" + resultList.get(i).getDisplayName2() + "</DISPLAYNAME2>");
					sb.append("<USEFLAG>" + resultList.get(i).getUseFlag() + "</USEFLAG>");
					sb.append("<LANG>" + resultList.get(i).getLang() + "</LANG>");
					sb.append("<THEMENM>" + resultList.get(i).getThemeNm() + "</THEMENM>");
					sb.append("<THEMENM2>" + resultList.get(i).getThemeNm2() + "</THEMENM2>");
					sb.append("<THEMENM3>" + resultList.get(i).getThemeNm3() + "</THEMENM3>");
					sb.append("<THEMENM4>" + resultList.get(i).getThemeNm4() + "</THEMENM4>");
					sb.append("</ROW>");
				}
			}
			sb.append("</DATA>");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String getUserInfo (String pUserID, String langStr) {
		try {
			PortalTBLUserInfoVO result = topGetUserInfo2(pUserID, langStr);
System.out.println("result1:"+result.toString());
			String resultXML = commonUtil.getQueryResult(result);
System.out.println("resultXML:"+resultXML);
			if (resultXML.equals("<DATA></DATA>")) {
				resultXML = getUserInfo(pUserID);
			}
			return resultXML;	
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
		
	public String getUserInfo (String pUserID) {
		try {
			PortalTBLUserInfoVO result = topGetUserInfo(pUserID);
				
			String resultXML = commonUtil.getQueryResult(result);
				
			return resultXML;	
		} catch (Exception e) {
			e.printStackTrace();
			return "<DATA/>";
		}
	}
	
	public String getThemeInfoStr (String pThemeUID, String pGubun) {
		try {
			PortalTBLThemeGeneralVO result = getThemeInfo(pThemeUID, pGubun); 
			return commonUtil.getQueryResult(result);
		} catch (Exception e) {
			e.printStackTrace();
			return "ERROR";
		}
	}
	
	public String getMenuItemHTML (String pCallingMenuID, String pUID, LoginVO userInfo) throws Exception {
		try {
			String strHTML = "<iframe width=100% height=100% border=0 src='" + getMenuItemConfigItem(pUID, "URL") + "' frameborder=0 scrolling=no></iframe>";
			
			int result = getMenuItemHtml(pUID);
			
			switch (result) {
			case 1:
				 strHTML = "<div class='logo'>";
				 strHTML += getLogoHTML(pCallingMenuID, pUID, userInfo);
                 strHTML += "</div>";
				break;
			case 2:
				strHTML = getUtilMenuHTML(pCallingMenuID, pUID, userInfo);
				break;
			case 3:
				strHTML = getMainMenuHTML(pCallingMenuID, pUID, userInfo);
				break;
			case 4:
				strHTML = getSubMenuHTML(pCallingMenuID, pUID, userInfo);
				break;
			case 5:
				strHTML = getSearchHTML(pCallingMenuID, pUID);
				break;
			case 7:
				strHTML = getUserInfoHTML(pCallingMenuID, pUID);
				break;
			default:
				break;
			}
			
			return strHTML;
		} catch (Exception e) {
			e.printStackTrace();
			return "<iframe width=100% height=100% border=0 src='" + getMenuItemConfigItem(pUID, "URL") + "' frameborder=0 scrolling=no></iframe>";
		}
	}
	
	public String getLogoHTML (String pCallingMenuID, String pContentsUID, LoginVO userInfo) {
		try {
			String pUID = "";
			String pAccessIDList = getAccessList(userInfo);
			
			for (int i=0; i<pAccessIDList.split(",").length; i++) {
				pUID = getLogoHtml(pCallingMenuID, pAccessIDList.split(",")[i].trim());
				
				if (pUID != null) {
					break;
				}
			}
			return getImageHTML(pCallingMenuID, pUID, false, pContentsUID, userInfo);
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getImageHTML (String pCallingMenuID, String pUID, boolean pIncludeTD, String pContentsUID, LoginVO userInfo) {
		try {
			String pSkinNum = "";
			String strHTML = "";
			if (pContentsUID.equals("203")) {
				pSkinNum = this.gSkinNum;
			} else {
				pSkinNum = "1";
			}
			
			StringBuilder sb = new StringBuilder();
			PortalMenuItemItemsImageVO result = getImageHtml(pUID, pCallingMenuID, Integer.parseInt(pSkinNum));

			if (result != null) {
				String imageDisplayName = result.getDisplayName();
				String imageImageType = result.getImageType();
				String imageNormalImagePath = result.getNormalImagePath();
				String imageOverImagePath = result.getOverImagePath();
				int imageImageWidth = result.getImageWidth();
				int imageImageHeight = result.getImageHeight();
				String imageLinkURL = result.getLinkURL();
				String imageLinkLocation = result.getLinkLocation();
				String imageWindowOption = result.getWindowOption();
				
				if (imageNormalImagePath != null) {
System.out.println("222222");
					sb.append("<img src='" + imageNormalImagePath + "'");
					if (imageOverImagePath != null) {
System.out.println("333333");
System.out.println("이건:"+imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1));
						sb.append(" id=\"" + imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1).split("\\.")[0] + "\" onmouseover=\"img_onMouseOver('" + imageOverImagePath + "', this);\" onmouseout=\"img_onMouseOut(this);\"" + " name=\'" + pContentsUID + "'");
System.out.println("???:"+imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1).split("\\.")[0]);

					}
					if (imageLinkURL != null) {
						sb.append(" style='cursor:pointer'");
						sb.append(" onclick='OpenWindow(event, \"" + imageLinkURL + loadGetParameters(imageLinkURL, pUID, userInfo) + "\"");
						sb.append(", \"" + imageLinkLocation + "\"");
						sb.append(", \"" + imageWindowOption + "\")'");
					
					}
					if (imageImageWidth != 0 && "BASIC".equals(gTheme)) sb.append(" width='" + imageImageWidth + "'");
                    if (imageImageHeight != 0 && "BASIC".equals(gTheme)) sb.append(" height='" + imageImageHeight + "'");
					sb.append(">");
					strHTML = sb.toString();
					sb.delete(0, sb.length());
					
					if (pIncludeTD) {
						if (imageImageWidth != 0) {
							sb.append("<td width=\"" + imageImageWidth + "\">" + strHTML + "</td>");
						} else {
							sb.append("<td>" + strHTML + "</td>");
						}
					} else {
						sb.append(strHTML);
					}
				}
				
			}
System.out.println("sb:"+sb.toString());
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String loadGetParameters (String pURL, String pMenuItemID, LoginVO userInfo) {
		try {
			List<PortalTopLoadGetParametersVO> result = topLoadGetParameters(pMenuItemID);
			
			String userInfoXML = "<DATA>"+commonUtil.getQueryResult(userInfo)+"</DATA>";
			Document xmlDomUserInfo = commonUtil.convertStringToDocument(userInfoXML);
			String strParam = "";
			
			for (int i=0; i<result.size(); i++) {
				if (pURL.indexOf("?") == -1) {
					if (strParam == null) {
						strParam += "?";
					} else {
						strParam += "&";
					}
				} else {
					strParam += "&";
				}
				
				if (result.get(i).getParamType() == 0) {
					strParam += result.get(i).getParamInfo() + "=" + result.get(i).getParamValue();
				} else {
					strParam += result.get(i).getParamInfo() + "=" + xmlDomUserInfo.getElementsByTagName(result.get(i).getParamInfo());
				}
				
			}
			
			return strParam;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUtilMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) {
		try {
			List<PortalMenuItemItemsMenuItemsVO> result = getUtilMenuHtml(pUID, pCallingMenuID);
			
			StringBuilder sb = new StringBuilder();
			sb.append("<article class='utmenu'>\n");
			sb.append("<ul>\n");
			
			String lastLogout = "";
System.out.println("resultSize:"+result.size());
			for (int i=0; i<result.size(); i++) {
				if (!checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo))) {
					continue;
				}
				
				String menuitemDisplayName = result.get(i).getDisplayName();
				String menuitemImageUID = result.get(i).getImageUId();
				String menuitemLinkURL = result.get(i).getLinkURL();
				String menuitemLinkLocation = result.get(i).getLinkLocation();
				String menuitemWindowOption = result.get(i).getWindowOption();
				
				if (i == result.size() - 1) {
					lastLogout = "class='btn_logout'";
				}
				
				if (!(menuitemImageUID.trim()).equals("")) {
					sb.append(getUtilImageHTML(menuitemDisplayName, pCallingMenuID, menuitemImageUID, lastLogout, pUID, userInfo) + "\n");
				} else {
					if (!(menuitemLinkURL.trim()).equals("")) {
						if (i == result.size() - 1) {
							sb.append("<li " + lastLogout + "><span style='cursor:pointer' onclick='top.location.href = \"" + menuitemLinkURL + "\"'>" + menuitemDisplayName +"</span></li>\n");
						} else {
							sb.append("<li " + lastLogout + "><span style='cursor:pointer' onclick='OpenWindow(event, \"" + menuitemLinkURL + loadGetParameters(menuitemLinkURL, result.get(i).getuID(), userInfo) + "\"");
							sb.append(", \"" + menuitemLinkLocation + "\"");
	                        sb.append(", \"" + menuitemWindowOption + "\")'>" + menuitemDisplayName + "</span></li>\n");
						}
                          
					} else {
						sb.append("<li " + lastLogout + ">" + menuitemDisplayName + "</li>\n");
					}
				}
			}
			sb.append("</ul></article>\n");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getMainMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) {
		try {
			List<PortalGetMainMenuHtmlVO> result = getMainMenuHtml(pUID, pCallingMenuID, Integer.parseInt(gSkinNum));
			

			StringBuilder sb = new StringBuilder();
            if (gTheme.equals("BASIC")) {
            	sb.append("</header>\n");
            }
			sb.append("<nav>\n");
            sb.append("<ul class='topmenu'>");
            
            for (int i=0; i<result.size(); i++) {
System.out.println("boolean:"+!checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo)));
System.out.println("boolean1:"+checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo)));
				if (!checkViewRightBln(result.get(i).getuID(), getAccessList(userInfo))) {
					continue;
				}
				
				String menuitemUID = result.get(i).getuID();
				String menuitemDisplayName = result.get(i).getDisplayName();
				String menuitemImageUID = result.get(i).getImageUId();
				String menuitemLinkURL = result.get(i).getLinkURL();
				String menuitemLinkLocation = result.get(i).getLinkLocation();
				String menuitemWindowOption = result.get(i).getWindowOption();
				String menuitemNormalImagePath = result.get(i).getNormalImagePath();
System.out.println("menuitemImageUID:"+menuitemImageUID);
System.out.println("menuitemNormalImagePath:"+menuitemNormalImagePath);
System.out.println("menuitemLinkURL:"+menuitemLinkURL);
				if (menuitemImageUID != null && menuitemNormalImagePath != null) {
					sb.append("<li>" + getImageHTML(pCallingMenuID, menuitemImageUID, false, menuitemUID, userInfo) + "</li>");
System.out.println("111");
				} else {
System.out.println("222");
					sb.append("<li ");
					
					if (menuitemLinkURL != "") {
System.out.println("333");
                        sb.append(" onclick='OpenWindow(event, \"" + menuitemLinkURL + loadGetParameters(menuitemLinkURL, result.get(i).getuID(), userInfo) + "\"");
						sb.append(", \"" + menuitemLinkLocation + "\"");
						sb.append(", \"" + menuitemWindowOption + "\")'");
					}
					
					sb.append(">" + menuitemDisplayName + "</li>");
				}
            }
            
            sb.append("</ul></nav>");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getSubMenuHTML (String pCallingMenuID, String pUID, LoginVO userInfo) {
		try {
			List<PortalMenuItemItemsMenuItemsVO> result = getSubMenuHtml(pCallingMenuID, pUID);
			
			StringBuilder sb = new StringBuilder();
			sb.append(" <div class=\"topSubMenu\">");
			
			for (int i=0; i<result.size(); i++) {
				String leftMargin = result.get(i).getLeftMargin();
				List<PortalMenuItemItemsMenuItemsSVO> result2 = getSubMenuHtml2(result.get(i).getParentMenuID());
				
				if (result2.size() == 0) {
					 sb.append("<ul id=\"menu" + result.get(i).getParentMenuID() + "\" id=\"menu01_sub\" style=\"DISPLAY:none;top:0px;left:" + leftMargin + "px\"></ul>");
					continue;
				}
				String parentMenuID = result2.get(0).getParentMenuID();
				sb.append("<ul id=\"menu_" + parentMenuID + "\" id=\"menu01_sub\" style=\"DISPLAY:none;top:0px;left:" + leftMargin + "px\" onmouseover=\"submenuover()\" onmouseout=\"submenuout()\"><li class=\"left\">");
				for (int j=0; j<result2.size(); j++) {
					if (!checkViewRightBln(result2.get(j).getuID(), getAccessList(userInfo))) {
						continue;
					}
					String menuitemDisplayName = result2.get(j).getDisplayName();
					String menuitemImageUID = result2.get(j).getImageUId();
					String menuitemLinkURL = result2.get(j).getLinkURL();
					String menuitemLinkLocation = result2.get(j).getLinkLocation();
					String menuitemWindowOption = result2.get(j).getWindowOption();
					
					if (menuitemImageUID != null) {
						sb.append("<li class=\"subtd\">" + getImageHTML(pCallingMenuID, menuitemImageUID, false, pUID, userInfo) + "</li>\n");
					} else {
						sb.append("<li onclick=\"javascript:submenuclick('" + result2.get(j).getuID() + "');OpenWindow(event, '" + menuitemLinkURL + loadGetParameters(menuitemLinkURL, result2.get(j).getuID(), userInfo) + "', '" + menuitemLinkLocation + "', '" + menuitemWindowOption + "')\">" + menuitemDisplayName + "</li>\n");
					}
				}
				sb.append("<li class=\"right\"></ul>");
			}
			sb.append("</div>\n");
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getSearchHTML (String pCallingMenuID, String pUID) {
		try {
			  StringBuilder searchHTML = new StringBuilder();
              searchHTML.append("<div class='top_search'>\n");
              searchHTML.append("<input id='input_search' class='input_text' type='text' onfocus=\"this.className='input_text focus'; \" onblur='input_Onblur(this)' onkeyup='Key_event(event);' onmousedown='keyword_Clear(this);' />");
              searchHTML.append("<input type='image' src='/images/kr/cm/top_search_btn.gif' alt='' class='topsearch_btn' onclick='Emp_Search()'>");
              searchHTML.append("</div>");
			return searchHTML.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUserInfoHTML (String pCallingMenuID, String pUID) {
		try {
			 StringBuilder searchHTML = new StringBuilder();
             searchHTML.append("<div class='top_search'>\n");
             searchHTML.append("<input id='input_search' class='input_text' type='text'  onfocus=\"this.className='input_text focus'; \" onblur='input_Onblur(this)' onkeyup='Key_event(event);' onmousedown='keyword_Clear(this);'/>");
             searchHTML.append("<input type='image' src='/images/kr/cm/top_search_btn.gif' alt=''  class='topsearch_btn ' onclick='Emp_Search()'>");
             searchHTML.append("</div>");
			return searchHTML.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
	
	public String getUtilImageHTML (String menuItemDisplayName, String pCallingMenuID, String pUID, String logoutclass, String pContentsUID, LoginVO userInfo) {
		try {
			String pSkinNum = "";
			String strHTML = "";
			if (pContentsUID.equals("203")) {
				pSkinNum = this.gSkinNum;
			} else {
				pSkinNum = "1";
			}
			
			StringBuilder sb = new StringBuilder();
			
			PortalMenuItemItemsImageVO result = getImageHtml(pUID, pCallingMenuID, Integer.parseInt(pSkinNum));
System.out.println("noramalImage:"+result.getNormalImagePath());
System.out.println("ㅡㅡ0");			
			if (result != null) {
System.out.println("ㅡㅡ1");
				String imageDisplayName = result.getDisplayName();
                String imageImageType = result.getImageType();
                String imageNormalImagePath = result.getNormalImagePath();
                String imageOverImagePath = result.getOverImagePath();
                int imageImageWidth = result.getImageWidth();
                int imageImageHeight = result.getImageHeight();
                String imageLinkURL = result.getLinkURL();
                String imageLinkLocation = result.getLinkLocation();
                String imageWindowOption = result.getWindowOption();
                
                if (imageNormalImagePath != null) {
System.out.println("ㅡㅡ2");
                	sb.append("<li><img src='" + imageNormalImagePath + "'");
                    if (imageOverImagePath != "") {
System.out.println("ㅡㅡ3");
                    	sb.append(" id=\"" + imageNormalImagePath.substring(imageNormalImagePath.lastIndexOf("/") + 1).split("\\.")[0] + "\" onmouseover=\"img_onMouseOver('" + imageOverImagePath + "', this);\" onmouseout=\"img_onMouseOut(this);\"");
                    }
                    if (imageLinkURL != "") {
System.out.println("ㅡㅡ4");
                        sb.append(" style='cursor:pointer'");
                        sb.append(" onclick='OpenWindow(event, \"" + imageLinkURL + loadGetParameters(imageLinkURL, pUID, userInfo) + "\"");
                        sb.append(", \"" + imageLinkLocation + "\"");
                        sb.append(", \"" + imageWindowOption + "\")'");
                    }
                    if (imageImageWidth != 0 && gTheme.equals("BASIC")) {
                    	sb.append(" width='" + imageImageWidth + "'");
                    }
                    if (imageImageHeight != 0 && gTheme.equals("BASIC")) {
                    	sb.append(" height='" + imageImageHeight + "'");
                    }
                    sb.append("></li>\n");
                    strHTML = sb.toString();
System.out.println("sb1:"+sb.toString());
                    sb.delete(0, sb.length());
                    sb.append(strHTML);
System.out.println("sb2:"+sb.toString());
                }
			}
			
			return sb.toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}
}

