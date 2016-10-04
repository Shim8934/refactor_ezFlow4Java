<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t9995'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/MiscFunc_Cross.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var OrderCell = "";
		    var arrTask = new Array();
		    var rtnVal = new Array();
		    var g_SearchKeyword="";
		    var AdminYN = "FALSE";
		    var szRoleInfo = "${userInfo.rollInfo}";
		    var g_bRecAdmin = false;
		    var g_bDeptCharger = false;
		    var xmlhttp = createXMLHttpRequest();
		    var pUserID = "${userInfo.id}";
		    var CompanyID = "${userInfo.companyID}";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";
		    arr_userinfo[1]  = "${userInfo.id}";
		    arr_userinfo[2]  = "${userInfo.displayName}";
		    arr_userinfo[3]  = "${userInfo.title}";
		    arr_userinfo[4]  = "${userInfo.deptID}";
		    arr_userinfo[5]  = "${userInfo.deptName}";
		    arr_userinfo[6]  = "${userInfo.jikChek}";
		    arr_userinfo[8]  = "${userInfo.email}";
		    arr_userinfo[9] = CompanyID;
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
		            KeEventControl(document.getElementById("Cabinetkeyword"));
		        }
		
		        try {
		            RetValue = parent.searchcabinet_cross_dialogArguments[0];
		            ReturnFunction = parent.searchcabinet_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.searchcabinet_cross_dialogArguments[0];
		                ReturnFunction = opener.searchcabinet_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        g_SearchKeyword = RetValue;
		        rtnVal[0] = "FALSE";
		        document.getElementById("Cabinetkeyword").value = g_SearchKeyword;
		        g_DeptCode = arr_userinfo[4];
		        g_DeptName = arr_userinfo[5];
		        InitSelCabinetList();
		        CabinetSearch_onclick();
		    };
		    function InitSelCabinetList() {
		        var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;
		        oList = createXmlDom();
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t691'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "70");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t692'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "70");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t693'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "70");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t577'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "70");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t379'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t572'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "50");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t573'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
		        createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
		        var SelListView = new ListView();
		        SelListView.SetID("DivSelCabinetList");
		        SelListView.SetMulSelectable(false);
		        SelListView.SetRowOnDblClick("cmdConfirm_onclick");
		        SelListView.DataSource(oList);
		        SelListView.DataBind("SelCabinetList");
		    }
		    function CabinetSearch_Press(e) {
		        if (window.event) {
		            if (e.keyCode != 13)
		                return;
		        }
		        else {
		            if (e.which != 13)
		                return;
		        }
		        CabinetSearch_onclick();
		    }
		    function CabinetSearch_onclick() {
		        if (document.getElementById("Cabinetkeyword").value == "") {
		            alert("<spring:message code='ezApprovalG.t1160'/>");
		            document.getElementById("Cabinetkeyword").focus();
		            return;
		        }
		        
		        var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : false,
		    		url : "/ezApprovalG/getCabinetSearch.do",
		    		data : {
		    			companyID : CompanyID,
		    			processDeptCode : arr_userinfo[4],
		    			productionYear  : "",
		    			searchKeyword   : document.getElementById("Cabinetkeyword").value,
		    			flag : "1",
		    			langType : "${userInfo.lang}"
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
		        
		        var rtnXml = result;
		        var iSeledtedIdx = 0;
		        if (SelectSingleNodeValue(rtnXml, "RESULT") == "FALSE") {
		            alert("<spring:message code='ezApprovalG.t2102'/>");
		        }
		        else {
		            if (document.getElementById("SelCabinetList").innerHTML != "") document.getElementById("SelCabinetList").innerHTML = "";
		
		            var SelListView = new ListView();
		            SelListView.SetID("DivSelCabinetList");
		            SelListView.SetMulSelectable(false);
		            SelListView.SetRowOnDblClick("cmdConfirm_onclick");
		            SelListView.DataSource(rtnXml);
		            SelListView.DataBind("SelCabinetList");
		        }
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		        }
		        else {
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function cmdConfirm_onclick() {
		        var List = new ListView();
		        List.LoadFromID("DivSelCabinetList");
		        var totalRows = List.GetSelectedRows();
		        if (totalRows.length > 0) {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = GetSelCabInfoXml();
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);
		            }
		            else {
		                window.returnValue = rtnVal;
		                window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t2103'/>");
		        }
		    }
		    function GetSelCabInfoXml() {
		        var List = new ListView();
		        List.LoadFromID("DivSelCabinetList");
		        var totalRows = List.GetSelectedRows();
		        var i;
		        var rtnXml = createXmlDom();
		        var Root, cabinet, node;
		        Root = createNodeInsert(rtnXml, Root, "ROW");
		        cabinet = createNodeAndAppandNode(rtnXml, Root, cabinet, "CELL");
		        createNodeAndAppandNodeText(rtnXml, cabinet, node, "VALUE", totalRows[0].cells[4].innerText);
		        createNodeAndAppandNodeText(rtnXml, cabinet, node, "DATA1", totalRows[0].getAttribute("DATA1"));
		        createNodeAndAppandNodeText(rtnXml, cabinet, node, "DATA2", totalRows[0].getAttribute("DATA2"));
		        createNodeAndAppandNodeText(rtnXml, cabinet, node, "DATA3", totalRows[0].cells[5].innerText);
		        cabinet = createNodeAndAppandNode(rtnXml, Root, cabinet, "CELL");
		        createNodeAndAppandNodeText(rtnXml, cabinet, node, "VALUE", totalRows[0].cells[6].innerText);
		        cabinet = createNodeAndAppandNode(rtnXml, Root, cabinet, "CELL");
		        createNodeAndAppandNodeText(rtnXml, cabinet, node, "VALUE", totalRows[0].cells[7].innerText);
		        return getXmlString(rtnXml);
		    }
		    window.onbeforeunload = function () {
		        if (!CrossYN())
		            window.returnVlue = rtnVal;
		    }
		</script>
	</head>
	<body class="popup" style="margin-left:0px;margin-top:0px;overflow:hidden">
		<h1><spring:message code='ezApprovalG.t9995'/></h1>
		<table>
		  <tr>
		    <td style="width:400px;vertical-align:top"><h2><spring:message code='ezApprovalG.t1090'/></h2>
			<table style="width:100%">
			    <tr>
			        <td>
			        	<input type="text" id="Cabinetkeyword" name="Cabinetkeyword" style="width:200px" onKeyPress="CabinetSearch_Press(event)">
		      			<a class="imgbtn" style="vertical-align:middle"><span onClick="return CabinetSearch_onclick()"><spring:message code='ezApprovalG.t111'/></span></a>
		      		</td>
			    </tr>
		        <tr>
		            <td>
						<div class="listview">
						    <div id="SelCabinetList" style="border:0;HEIGHT:250px;WIDTH: 580px;overflow:auto;"></div>
						</div>
				    </td>
		        </tr>
		      </table></td>
		  </tr>
		</table>
		<div class="btnposition">
		    <a class="imgbtn" onClick="return cmdConfirm_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
		    <a class="imgbtn" onClick="return cmdCancel_onclick()"><span><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
	</body>
</html>