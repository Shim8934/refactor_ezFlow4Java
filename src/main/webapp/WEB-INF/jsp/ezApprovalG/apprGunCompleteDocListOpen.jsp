<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/font-awesome-4.7.0/css/font-awesome.min.css')}" type="text/css"/>
	<style>
		.mainlist tr th {text-align:center;}
		.mainlist tr td {text-align:center;}
	</style>
<title>[ <c:out value ='${cabinetName}'/> ] <spring:message code='ezApprovalG.yjyg01' /></title>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenSelWin_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OrganTree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	   		var pCabinetID = "<c:out value ='${cabinetID}'/>";
	   		var OrderCell = "";
	   		var rtnVal = new Array();
	   		
	  		window.onload = function(){
	  			initUncompleteDocList(pCabinetID);
	  		}
	  		
	  		function initUncompleteDocList(pCabinetID){
	  			var resultXML = "";
	  			
	  			$.ajax({
	  				type : "GET",
	  				dataType : "text",
	  				async : false,
	  				url : "/ezApprovalG/getUncompleteDocList.do",
	  				data : {
	  					cabinetID : pCabinetID
	  				},
	  				success : function(xml) {
	  					initUncompleteDocList_after(loadXMLString(xml));
	  				}
	  			});
	  		}
	  		
	  		function initUncompleteDocList_after(xml) {
	  			var DocList = new ListView();
	  			DocList.SetID("DivLvDocList");
	  			DocList.SetMulSelectable(false);
	  			DocList.DataSource(xml);
	  			DocList.DataBind("lvDocList");
	  		}
	  		
	  		function btnCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        window.close();
		    }
  			
	  	</script>
</head>
<body class="popup">
	<h1>[ <c:out value ='${cabinetName}'/> ] <spring:message code='ezApprovalG.yjyg01' /> (* <spring:message code='ezApprovalG.apprCablist.mjs01' /> )</h1>
		<div id="close">
            <ul>
                <li><span id="btnCancel" onclick="return btnCancel_onclick()"></span></li>
            </ul>
        </div>
	   <div id="lvDocList" style="border: 0; width: auto; height: auto;"></div>
</body>
</html>