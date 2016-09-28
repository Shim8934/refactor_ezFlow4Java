<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezPersonal.t100002'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script src="/js/ezPersonal/ListView_list.js" type="text/javascript"></script>
		<script language="javascript" type="text/javascript">
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.checkname2_cross_dialogArguments[0];
		            ReturnFunction = parent.checkname2_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.checkname2_cross_dialogArguments[0];
		                ReturnFunction = opener.checkname2_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        var listview = new ListView();
		        listview.SetID("ListView1");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));
		        listview.DataBind("ListViewItem");
		        listview.DataSource(RetValue["addrBook"]);
		        listview.RowDataBind();
		    }
		    function change_onClick() {
		        
		        var listview = new ListView();
		        listview.LoadFromID("ListView1");
		        var count1;
		        var selecteditemcount = listview.GetSelectedRows().length;
		        var selrow;
		        if (selecteditemcount == 0) {
		            alert("<spring:message code='ezPersonal.t207'/>");
		            return;
		        }
		        else if (selecteditemcount > 1) {
		            alert("<spring:message code='ezPersonal.t208'/>");
		            return;
		        }
		        
		        if (ReturnFunction != null) {
		            if (window.ActiveXObject)
		                RetValue["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].text;
		            else
		                RetValue["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		            ReturnFunction(RetValue);
		        }
		        else {
		            dialogArguments["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].text;
		        }
		
		        window.close();
		    }
		
		    function delete_onClick() {
		        if (ReturnFunction != null) {
		            RetValue["recipientTDData"] = "delete";
		            ReturnFunction(RetValue);
		        }
		        else {
		            dialogArguments["recipientTDData"] = "delete";
		        }
		
		        window.close();
		    }
		    function cancel_onClick() {
		        if (ReturnFunction != null) {
		            RetValue["recipientTDData"] = "dontprocess";
		            ReturnFunction(RetValue);
		        }
		        else {
		            dialogArguments["recipientTDData"] = "dontprocess";
		        }
		
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t6'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t9'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t209'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<object style="display:none" classid="clsid:F8E93A35-2D04-4E2C-A04D-87947594C674" id="ListViewBehave" height="0px" width="0px" VIEWASTEXT>
		</object>
		<h1><spring:message code='ezPersonal.t100002'/></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="delete_onClick()"><spring:message code='ezPersonal.t10'/></span></li>
		  </ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<h2><spring:message code='ezPersonal.t100003'/></h2>
		<div class="listview" style="overflow:auto;">
		  <div id="ListViewItem" style="Width:587px; Height:195px; border:0px;overflow:auto;" ></div>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" onClick="change_onClick()"><span><spring:message code='ezPersonal.t12'/></span></a>
		    <a class="imgbtn" onClick="cancel_onClick()"><span><spring:message code='ezPersonal.t13'/></span></a>
		</div>
	</body>
</html>