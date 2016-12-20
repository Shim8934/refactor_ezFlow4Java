<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1217'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script language="JavaScript">
		    var pDocID = "${docID}";
		    var pDeptID = "${deptID}";
		    window.onload = function () {
		        try {
		            var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
		            var RtnVal = new ActiveXObject("Microsoft.XMLDOM");
		
		            var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
		            var objRoot = xmlpara.createNode(1, "ASSIGN", "");
		            xmlpara.appendChild(objRoot);
		
		            var objNode = xmlpara.createNode(1, "pDocID", "");
		            objNode.text = pDocID;
		            xmlpara.documentElement.appendChild(objNode);
		
		            var objNode = xmlpara.createNode(1, "pDeptID", "");
		            objNode.text = pDeptID;
		            xmlpara.documentElement.appendChild(objNode);
		
		            xmlhttp.open("POST", "../ezAPRHISTORY/aspx/getDeptHistory.aspx", false);
		            xmlhttp.send(xmlpara);
		
		            RtnVal = xmlhttp.responseXML;
		            lvAprLine.dataSource = RtnVal;
		        } catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    };
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "../ezAPRALERT.aspx";
		        var feature = "status:no;dialogWidth:300px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		    function lvAprLine_DBSelChange() {
		    }
		    function lvAprLine_SelChange() {
		    }
		</script>
	</head>
	<body class="popup">
		<OBJECT classid=clsid:F8E93A35-2D04-4E2C-A04D-87947594C674 height=0 id=behave1 width=0 style="DISPLAY: none"></OBJECT> 
		<h1><spring:message code='ezApprovalG.t1217'/></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.close()"><spring:message code='ezApprovalG.t64'/></span></li>
		  </ul>
		</div>
		
		<div class="listview"><div ID="lvAprLine" 
						 STYLE="BEHAVIOR:url('#behave1#ListView'); border:0;
						 HEIGHT: 120px; WIDTH: 517px" 
						 onRowDblClick="return lvAprLine_DBSelChange()" 
						 OnSelChanged="return lvAprLine_SelChange()">      
					</div></div>
					
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>