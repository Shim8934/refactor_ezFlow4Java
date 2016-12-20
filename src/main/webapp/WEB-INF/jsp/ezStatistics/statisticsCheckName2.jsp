<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezStatistics.e2' />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
    	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezStatistics.e1' />"></script>
		<script type="text/javascript" src="/js/ezStatistics/control_Cross/ListView_list.js"></script>
		<script language="javascript" type="text/javascript">
		    var UserAgentState = navigator.userAgent.toLowerCase();
		    var browserIE = (UserAgentState.indexOf("msie") != -1) ? true : false;
		    window.onload = function () {
		        var listview = new ListView();
		        listview.SetID("ListView1");
		        listview.SetSelectFlag(false);
		        listview.SetMulSelectable(true);
		        listview.SetRowOnDblClick("change_onClick");
		        listview.DataSource(listviewheader);
		        listview.DataBind("ListViewItem");
		        listview.DataSource(dialogArguments["addrBook"]);
		        listview.RowDataBind();
		    }
		    function change_onClick() {
		        var listview = new ListView();
		        listview.LoadFromID("ListView1");
		        var count1;
		        var selecteditemcount = listview.GetSelectedRows().length;
		        var selrow;
		        if (selecteditemcount == 0) {
		            alert("<spring:message code='ezOrgan.t106' />");
		            return;
		        }
		        else if (selecteditemcount > 1) {
		            alert("<spring:message code='ezOrgan.t107' />");
		            return;
		        }
		        if (browserIE)
		            dialogArguments["deptid"] = dialogArguments["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].text;
		        else
		            dialogArguments["deptid"] = dialogArguments["addrBook"].getElementsByTagName("ROW")[listview.GetSelectedIndexes()].getElementsByTagName("DATA2")[0].textContent;
		        window.close();
		    }
		    function delete_onClick() {
		        dialogArguments["recipientTDData"] = "delete";
		        window.close();
		    }
		    function cancel_onClick() {
		        dialogArguments["recipientTDData"] = "dontprocess";
		        window.close();
		    }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style="display:none">
		  <LISTVIEWDATA>
		    <HEADERS>
		      <HEADER>
		        <NAME>회 사</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>이름</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		      <HEADER>
		        <NAME>부서장</NAME>
		        <WIDTH>100</WIDTH>
		      </HEADER>
		    </HEADERS>
		  </LISTVIEWDATA>
		</xml>
		<h1>이름확인</h1>
		<div id="close">
		  <ul>
		    <li><span onClick="delete_onClick()">닫기</span></li>
		  </ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<h2><spring:message code='ezStatistics.t11' /></h2>
		<div class="listview">
		  <div id="ListViewItem" style="Width:587px; Height:195px; border:0px;overflow:auto" ></div>
		</div>
		<div class="btnposition">
		    <a class="imgbtn" onClick="change_onClick()"><span>확인</span></a>
		    <a class="imgbtn" onClick="cancel_onClick()"><span>취소</span></a>
		</div>
	</body>
</html>


