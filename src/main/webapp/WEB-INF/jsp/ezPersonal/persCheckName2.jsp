<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezPersonal.t3'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezPersonal.e3'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script src="/js/ezPersonal/ListView_list.js" type="text/javascript"></script>
		<script type="text/javascript">
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    var ReturnFunction;
		    var RetValue;
		    window.onload = function () {
		        
		            try {
		                ReturnFunction = opener.checkname2_cross_dialogArguments[1];
		                RetValue = opener.checkname2_cross_dialogArguments[0];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        
		
		        var listview = new ListView();
		        listview.SetID("ListView1");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(loadXMLString(listviewheader.innerHTML.toUpperCase()));
		        listview.DataBind("ListView");
		        listview.DataSource(RetValue["addrBook"]);
		        listview.RowDataBind();
		    };
		    function change_onClick() {
		        var count1;
		        var selectedItemCount;
		        var selRow;
		
		        var listview = new ListView();
		        listview.LoadFromID("ListView1");
		        selectedItemCount = listview.GetSelectedRows().length;
		        if (selectedItemCount == 0) {
		            alert("<spring:message code='ezPersonal.t4'/>");
		            return;
		        }
		        else if (selectedItemCount > 1) {
		            alert("<spring:message code='ezPersonal.t5'/>");
		            return;
		        }
		        if (browserIE)
		            RetValue["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].text;
		        else
		            RetValue["deptid"] = RetValue["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		
		        if (CrossYN())
		            ReturnFunction();
		
		        window.close();
		    }
		    function delete_onClick() {
		        RetValue["recipientTDData"] = "delete";
		        if (CrossYN())
		            ReturnFunction();
		
		        window.close();
		    }
		    function cancel_onClick() {
		        RetValue["recipientTDData"] = "dontprocess";
		        if (CrossYN())
		            ReturnFunction();
		
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none;">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <TYPE>NONE</TYPE>
		        <NAME><spring:message code='ezPersonal.t6'/></NAME>
		        <WIDTH>100</WIDTH>
		        <SORTABLE>TRUE</SORTABLE>
		        <RESIZIBLE>FALSE</RESIZIBLE>
		        <MINSIZE>10</MINSIZE>
		        <MAXSIZE>200</MAXSIZE>
		        <NOWRAP>TRUE</NOWRAP>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t304'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME><spring:message code='ezPersonal.t209'/></NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezPersonal.t3'/></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="delete_onClick()"><spring:message code='ezPersonal.t10'/></span></li>
		  </ul>
		</div>
		<h2><spring:message code='ezPersonal.t11'/></h2>
		<div class="listview">
		  <div id="ListView" STYLE="Height:195px; border:0px;overflow-y:auto" ></div>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" onClick="change_onClick()" ><span><spring:message code='ezPersonal.t12'/></span></a>
		    <a class="imgbtn" onClick="cancel_onClick()" ><span><spring:message code='ezPersonal.t13'/></span></a>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>