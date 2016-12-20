<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t359'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/aprCabinetAttach_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/getContainerInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/CabinetInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/CabRoleInfo_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ezCabinet_Cross.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var Check = false;
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, DocListType;
	        var NodeList2, PageSize, ListView, ScontID, jobState;
	        var pUserName, pUserJobTitle, pDeptID, pDeptName, pCompanyID, pDocID;
	        var pUserName2, pUserJobTitle2, pDeptName2;
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var DeptID, deptName, UserID, AdminYN, CompanyID, PageSize, Block_Size;
	        var deptName2;
	        var UserLang = "${userInfo.lang}";
	        var RetValue;
	        var ReturnFunction;
	        var NonActiveX = "YES";
	        var pDraftFlag = "${draftFlag}";
	        
	        window.onload = function () {
	            var ua = navigator.userAgent;
	            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                KeEventControl(document.getElementById("txt_PageInputNum"));
	            }
	            pUserID = "${userInfo.id}";
	            pUserName = arr_userinfo[2];
	            pUserJobTitle = arr_userinfo[3];
	            pDeptID = arr_userinfo[4];
	            pDeptName = arr_userinfo[5];
	
	            try {
	                RetValue = parent.aprcabinetattach_cross_dialogArguments[0];
	                ReturnFunction = parent.aprcabinetattach_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.aprcabinetattach_cross_dialogArguments[0];
	                    ReturnFunction = opener.aprcabinetattach_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	
	            pDocID = RetValue;
	            pCompanyID = "${userInfo.companyID}";
	            pUserName2 = arr_userinfo[11];
	            pUserJobTitle2 = arr_userinfo[12];
	            pDeptName2 = arr_userinfo[13];
	            DeptID = pDeptID;
	            UserID = pUserID;
	            deptName = pDeptName;
	            deptName2 = pDeptName2;
	            CompanyID = pCompanyID;
	            PageSize = 10;
	            Block_Size = 10;
	            InitGlobals("RECORD", "9", "1");
	            GetRecordList_lv();
	            AttachList();
	            if (!CrossYN())
	                window.returnValue = "cancel";
	        }
	
	        function lvSDocResize() {
	            lvSDoc.headers.headerTable.style.width = 350 - 14;
	            lvSDoc.rows.rowTable.style.width = 350 - 14;
	        }
	        function lvTDocResize() {
	            lvTDoc.headers.headerTable.style.width = 180 - 14;
	            lvTDoc.rows.rowTable.style.width = 180 - 14;
	        }
	        function InitSubMenu(MenuType) {
	        }
	        function lvtDoclist_onSel_Changed() {
	            return;
	        }
	        function lvtDoclist_onSel_Click() {
	            return;
	        }
	        function lvtDoclist_onSel_DBclick() {
	            btnIns_onclick();
	        }
	        function lvtDoclist_onclick() {
	            return;
	        }
	        function lvTDoc_onSel_Changed() {
	            return;
	        }
	        function lvTDoc_onSel_Click() {
	            var DocList = new ListView();
	            DocList.LoadFromID("lvTDocLV");
	            var pCurSel = DocList.GetSelectedRows();
	            if (arr_userinfo[1].toLowerCase() != GetAttribute(pCurSel[0], "DATA4").toLowerCase())
	                arrow_left.Enable = "false";
	            else
	                arrow_left.Enable = "true";
	        }
	        function lvTDoc_onSel_DBclick() {
	            btndel_onclick()
	        }
	
	        function lvTDoc_onclick() {
	            return;
	        }
	        function btnIns_onclick() {
	            DocMove();
	        }
	        function btndel_onclick() {
	            var selRow;
	            var count1;
	            var DocList = new ListView();
	            DocList.LoadFromID("lvTDocLV");
	            var pCurSel = DocList.GetSelectedRows();
	            var length = pCurSel.length;
	            if (length == 0) {
	                OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");
	            }
	            else if (arr_userinfo[1].toLowerCase() != GetAttribute(pCurSel[0], "DATA4").toLowerCase() && pDraftFlag != "REDRAFT") {
	                OpenAlertUI("<spring:message code='ezApprovalG.t361'/>");
	                return;
	            }
	            else {
	                if (length > 0) {
	                    for (count1 = length; count1 > 0; count1--) {
	                        DocList.DeleteRow(pCurSel[count1 - 1].id);
	                    }
	                }
	                else
	                    OpenAlertUI("<spring:message code='ezApprovalG.t360'/>");
	            }
	        }
			function bt_OK_onclick() {
			    var listview = new ListView();
			    listview.LoadFromID("lvTDocLV");
			    var TotalList = listview.GetDataRows();
			    var length = TotalList.length;
			    if (length > 0) {
			        var AprDocAttachxml = DocMoveParser();
			        if (ReturnFunction != null) {
			            ReturnFunction(AprDocAttachxml);
			        }
			        else {
			            window.returnValue = AprDocAttachxml;
			            window.close();
			        }
			    }
			    else {
			        delAttachDoc();
			        var AprDocAttachxml = DocMoveParser();
			        if (ReturnFunction != null) {
			            ReturnFunction(AprDocAttachxml);
			        }
			        else {
			            window.returnValue = AprDocAttachxml;
			            window.close();
			        }
			    }
			}
			function bt_Cancle_onclick() {
			    if (ReturnFunction != null) {
			        ReturnFunction("cancel");
			    }
			    else {
			        window.returnValue = "cancel";
			        window.close();
			    }
			}
			function btnSearch_onclick() {
			    btnSearchRec_onclick("1");
			}
	    </script>
	</head>
	<body class="popup">
	    <xml id='FORMLIST' style="display: none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezApprovalG.t362'/></NAME>
		        <WIDTH>165</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
	    <div id="menu">
	        <ul>
	            <li><span onclick="return btnSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></li>
	        </ul>
	    </div>
	    <table style="margin-top: -10px; width: 455px;">
	        <tr>
	            <td style="height: 25px; vertical-align: bottom;"><span class="point" id="listcount">&nbsp;</span></td>
	            <td>
	                <div class="page">
	                    <img src="/images/page_previous.gif" width="15" height="15" id="td_Previous" onclick="goToPage_lv('front')" style="vertical-align: middle;">
	                    <span style="color:white;"><spring:message code='ezApprovalG.t103'/></span><span id="td_pTotalCount" style="color:white;"></span>&nbsp;&nbsp;<span style="color:white;"><spring:message code='ezApprovalG.t363'/></span>
	                    <input id="txt_PageInputNum" onkeydown="goToPage_lv('page', event)" onselectstart="event.cancelBubble=true;event.returnValue=true">
	                    <img src="/images/page_next.gif" width="15" height="15" id="td_Next" onclick="goToPage_lv('next')" style="vertical-align: middle;">
	                </div>
	            </td>
	        </tr>
	    </table>
	
	    <table>
	        <tr>
	            <td style="vertical-align: top;">
	                <div class="listview">
	                    <div id="lvtDoclist" style="border: 0; width: 448px; height: 240px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                </div>
	            </td>
	            <td style="width: 25px; text-align: center;">
	                <img id="arrow_right" onclick="return btnIns_onclick()" src="/images/arr01.gif" width="16" height="16" style="cursor: pointer"><img id="arrow_left" onclick="return btndel_onclick()" src="/images/arr02.gif" width="16" height="16" style="cursor: pointer"></td>
	            <td>
	                <div class="listview">
	                    <div id="lvTDoc" style="border: 0; width: 300px; height: 240px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return bt_OK_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
	        <a class="imgbtn"><span onclick="return bt_Cancle_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    </script>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>