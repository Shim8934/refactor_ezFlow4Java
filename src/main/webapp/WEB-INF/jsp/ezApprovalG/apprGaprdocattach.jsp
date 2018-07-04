<%@ page language="java" contentType="text/html; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t364'/></title>    
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/ezApprovalG/aprDocAttach_Cross.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/Pagenation_Cross.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var xmlhttp = createXMLHttpRequest();
	        var xmldoc = createXmlDom();
	        var approvalFlag = "${approvalFlag}";
	        var Check = false;
	        var NodeList, curpage, nowblock, totalPage, block, p_page, p_nowblock, NodeListLen, Init_Flag, pChackYN, subCondition;
	        var DocListType = "getDocList";
	        var NodeList2, PageSize, ListView, ScontID;
	        var pUserName, pUserJobTitle, pDeptID, pDeptName, pCompanyID, pDocID;
	        var arr_userinfo = new Array();
	        var OrderCell = "";
	        arr_userinfo[0] = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
	        arr_userinfo[7] = "N";
	        arr_userinfo[8]  = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11]  = "${userInfo.displayName1}";
		    arr_userinfo[12]  = "${userInfo.displayName2}";
		    arr_userinfo[13]  = "${userInfo.title1}";
		    arr_userinfo[14]  = "${userInfo.title2}";
		    arr_userinfo[15]  = "${userInfo.deptName1}";
		    arr_userinfo[16]  = "${userInfo.deptName2}";
		    var companyID = "${userInfo.companyID}";       
		 
	        subCondition = "";
	        
	        if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
	            window.onblur = function () {
	                window.focus();
	            }
	        }
	
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
	                return false;
	            else
	                return true;
	        };
	
	        var ReturnFunction;
	        window.onload = function () {
	            pUserID = arr_userinfo[1];
	            pUserName = arr_userinfo[2];
	            pUserJobTitle = arr_userinfo[3];
	            pDeptID = arr_userinfo[4];
	            pDeptName = arr_userinfo[5];
	
	            if (CrossYN() || pNoneActiveX == "YES") {
	                pDocID = parent.aprcabinetattach_cross_dialogArguments[0];
	                ReturnFunction = parent.aprcabinetattach_cross_dialogArguments[1];
	            }
	            else {
	                pDocID = window.dialogArguments;
	            }
	            pCompanyID = "${userInfo.companyID}";
	            getDocType();
	            PageSize = 10;
	            pChackYN = "FALSE";
	            getDocList();
	            AttachList();
	        }
	        function lvTDoc_onSel_Click() {
	            var listview = new ListView();
	            listview.LoadFromID("lvTDocList");
	            if (arr_userinfo[1] != trim_Cross(GetAttribute(listview.GetSelectedRows()[0], "userid")))
	                arrow_left.Enable = "false";
	            else
	                arrow_left.Enable = "true";
	        }
	        function bt_selSContName_onclick() {
	            ScontID = selSContName.value;
	            if (DocListType == "GetDocSearch") {
	                for (var i = 0; i < 14; i++) {
	                    condition[i] = "";
	                    MakeSubCondition();
	                }
	                GetDocSearch();
	            }
	            else
	                getDocList();
	        }
	        function btnIns_onclick() {
	            DocMove();
	        }
	        function btndel_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvTDocList");
	            var selRow;
	            var count1;
	            var plength = listview.GetSelectedRows().length;
	            var plength2 = listview.GetDataRows().length;
	            if (plength <= 0) {
	                alert("<spring:message code='ezApprovalG.t360'/>");
	            }
	            else if (arr_userinfo[1] != trim_Cross(GetAttribute(listview.GetSelectedRows()[0], "DATA4"))) {
	                alert("<spring:message code='ezApprovalG.t365'/>");
	                return;
	            }
	            else {
	                if (plength > 0 && plength2 > 0) {
	                    for (count1 = plength; count1 > 0; count1--) {
	                        selRow = listview.GetSelectedRows()[count1 - 1];
	                        listview.DeleteRow(GetAttribute(selRow, "id"));
	                    }
	                }
	                else
	                    alert("<spring:message code='ezApprovalG.t360'/>");
	            }
	        }
	        function bt_OK_onclick() {
	            var listview = new ListView();
	            listview.LoadFromID("lvTDocList");
	            var length = listview.GetDataRows().length;
	            if (length > 0) {
	                var tr = listview.GetDataRows();
	                if (tr[0].id.indexOf("noItems") > 0) {
	                    length = 0;
	                    window.close();
	                }
	
	                var AprDocAttachxml = DocMoveParser();
	                if (CrossYN() || pNoneActiveX == "YES") {
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
	                if (CrossYN() || pNoneActiveX == "YES") {
	                    ReturnFunction(AprDocAttachxml);
	                }
	                else {
	                    window.returnValue = AprDocAttachxml;
	                    window.close();
	                }
	            }
	        }
	        function bt_Cancel_onclick() {
	            if (CrossYN() || pNoneActiveX == "YES") {
	                ReturnFunction("cancel");
	            }
	            else {
	                window.returnValue = "cancel";
	                window.close();
	            }            
	        }
	
	        var condition = new Array();
	        var setsearchinfo_cross_dialogArguments = new Array();
	        function SearchCondi_onclick() {
	            var para;
	            var url = "/ezApprovalG/setSearchInfo.do";
	
	            if (CrossYN() || pNoneActiveX == "YES") {
	            	setsearchinfo_cross_dialogArguments[0] = "";
	            	setsearchinfo_cross_dialogArguments[1] = SearchCondi_Complete;
	                DivPopUpShow(510, 375, url);
	            }
	            else {
	                var feature = "dialogWidth:510px;dialogHeight:465px;status:no;scroll:no;edge:sunken"
	                feature = feature + GetShowModalPosition(510, 465);
	                condition = window.showModalDialog(url, para, feature);
	                if (condition) {
	                    MakeSubCondition();
	                    GetDocSearch();
	                }                
	            }
	        }
	        function SearchCondi_Complete(RtnVal)
	        {
	            if (RtnVal) {
	                condition = RtnVal;
	                MakeSubCondition();
	                GetDocSearch();
	            }            
	            DivPopUpHidden();
	        }
	    </script>
	    <style>
			.mainlist tr th {border-top:0px}
			#lvSDocList_TR_noItems td {
				text-align:left;
				padding-left:300px;
			}
		</style>
	</head>
	<body class="popup">
		<xml id='FORMLIST' style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<NAME><spring:message code='ezApprovalG.t362'/></NAME>
		        		<WIDTH>165</WIDTH>
		      		</HEADER>
		    	</HEADERS>
		  	</LISTVIEWDATA>
		</xml>
	    <h1><spring:message code='ezApprovalG.t364'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return bt_Cancel_onclick()"></span></li>
            </ul>
        </div>
	    <table>
	        <tr>
	            <td style="padding-bottom: 5px; width: 250px;">
	                <h2><spring:message code='ezApprovalG.t366'/>
	                    <select id="selSContName" name="selSContName" onchange="return bt_selSContName_onclick()" style="height:22px"></select>
	                    <a class="imgbtn"><span id="SearchCondi" onclick="return SearchCondi_onclick()" style="font-weight: normal"><spring:message code='ezApprovalG.t111'/></span></a>
					</h2>
	            </td>
	            <td style="text-align: right; white-space: nowrap; float: right; margin-top: 10px;">
	                <table style="border: 0; border-collapse: collapse; border-spacing: 0; padding: 0px; text-align: right;">
	                    <tr id="PageNum"></tr>
	                </table>
	            </td>
	            <td>&nbsp;</td>
	            <td>&nbsp;</td>
	        </tr>
	        <tr>
	            <td colspan="2" style="vertical-align: top;">
	                <div class="listview">
	                    <div id="lvSDoc" style="BORDER: 0; WIDTH: 690px; HEIGHT: 350px; overflow-x: hidden"></div>
	                </div>
	            </td>
	            <td style="width: 25px; text-align: center; margin-top: 3px;">
	                <img src="/images/arr_right.gif" style="cursor: pointer" width="16" height="16" id="arrow_right" onclick="return btnIns_onclick()"><img src="/images/arr_left.gif" style="cursor: pointer" width="16" height="16" id="arrow_left" onclick="return btndel_onclick()">
	            </td>
	            <td style="width: 310px; vertical-align: top;">
	                <div class="listview" style="WIDTH: 310px; HEIGHT: 350px">
	                    <div id="lvTDoc" style="BORDER: 0; WIDTH: 310px; HEIGHT: 350px; overflow: auto"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <a class="imgbtn" onclick="return bt_OK_onclick()"><span><spring:message code='ezApprovalG.t1760'/></span></a>
	    </div>
	
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
