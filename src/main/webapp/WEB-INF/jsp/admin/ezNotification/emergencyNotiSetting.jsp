<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	<title><spring:message code="ezNotification.hth21" /></title>
</head>
<body class="mainbody" style="overflow:hidden;">
	<xml id="listviewheader" style="display:none">
		<LISTVIEWDATA>
	    	<HEADERS>
	    		<HEADER>
	        		<NAME><spring:message code="ezNotification.hth72"/></NAME>
	        		<WIDTH>25%</WIDTH>
	        		<STYLE>border-top:0px;</STYLE>
	      		</HEADER>
	      		<HEADER>
	        		<NAME><spring:message code="ezNotification.hth73"/></NAME>
	        		<WIDTH>25%</WIDTH>
	        		<STYLE>border-top:0px;</STYLE>
	      		</HEADER>
	      		<HEADER>
	        		<NAME><spring:message code="ezNotification.hth74"/></NAME>
	        		<WIDTH>25%</WIDTH>
	        		<STYLE>border-top:0px;</STYLE>
	      		</HEADER>
	      		<HEADER>
					<NAME><spring:message code="ezNotification.hth75"/></NAME>
					<WIDTH>25%</WIDTH>
					<STYLE>border-top:0px;</STYLE>
				</HEADER>
				<HEADER>
					<NAME><spring:message code="ezNotification.hth76"/></NAME>
					<WIDTH>25%</WIDTH>
					<STYLE>border-top:0px;</STYLE>
				</HEADER>
    		</HEADERS>
	  	</LISTVIEWDATA>
	</xml>

	<h1><spring:message code="ezNotification.hth77"/>
	<jsp:include page="/WEB-INF/jsp/admin/companySelect.jsp"/>
	</h1>
	<h2>▒ <spring:message code="ezNotification.hth78"/></h2>
	<div style="width:600px;">
		<div style="padding : 10px 0px 10px 0px;">
			<a id="btn_save" class="imgbtn"><span><spring:message code="ezNotification.hth22" /></span></a>
			<a id="btn_cancle" class="imgbtn"><span><spring:message code="ezNotification.hth23" /></span></a>
		</div>
	</div>
	<table class="content" style="width:600px;">
		<colgroup>
			<col style="width: 60px;"/>
			<col />
		</colgroup>
		<tr>
			<th><spring:message code="ezNotification.hth59"/></th>
			<td style="padding:5px;"><input id="emergencyNotiContent" style="width : 100%;" type="text"/></td>
		</tr>
	</table>
	<br/>
	<br/>
	<h2>▒ <spring:message code="ezNotification.hth79"/></h2>
	<div style="width:600px;">
		<div style="padding : 10px 0px 10px 0px;">
			<a id="btn_add_permission" class="imgbtn"><span><spring:message code="ezNotification.hth80"/></span></a>
			<a id="btn_delete_permission" class="imgbtn"><span><spring:message code="ezNotification.hth81"/></span></a>
		</div>
	</div>
	<div id="contentlist" style="width:90%; overflow: auto;">
	    <div class="listview" style="border-left:0px;border-right:0px;border-bottom:1px">
	        <div id="AdminListView" style="border: 0px solid #ddd; Width: 99.75%; Height:540px; /* overflow-x: auto; */ BACKGROUND-COLOR: white; /* overflow-y:auto; */"></div>
	    </div>
	</div>
	
	<script type="text/javascript">
	var selectTargetListXML = "";
	
	window.onload = function () {
		getNotiEmergencyContent();
		getEmergencyNotiPermissions();
		setEventPermission();
	}
	
	function setEventPermission() {
		var btn_save = document.getElementById("btn_save");
		var btn_calcle = document.getElementById("btn_cancle");
		var btn_add_permission = document.getElementById("btn_add_permission");
		var btn_delete_permission = document.getElementById("btn_delete_permission");
		btn_save.addEventListener('click', function() {
			addNotiEmergencyContent();	
		});
		
		btn_calcle.addEventListener('click', function() {
			getNotiEmergencyContent();	
		});
		
		btn_add_permission.addEventListener('click', function() {
			addPermission();	
		});
		
		btn_delete_permission.addEventListener('click', function() {
			deletePermission();
		});
	}
	
	var selecttargetNew_dialogArguments = new Array();
	function addPermission() {
		var receiverData = new Array();
        receiverData["window"] = this;
        receiverData["selectTargetListXML"] = selectTargetListXML;
		var SelectTarget = window.open("/admin/ezNotification/selectTargetGroup.do?companyId=" + companySelectID , "SelectTargetNew", GetOpenWindowfeature(1070, 645));
		selecttargetNew_dialogArguments[0] = receiverData;
        selecttargetNew_dialogArguments[1] = getEmergencyNotiPermissions;
	}
	
	function deletePermission() {
		if (!confirm("<spring:message code = 'ezNotification.hth17' />")) {
			return;
		};
		var DocList = new ListView();
		DocList.LoadFromID("lvEmergencyPermissionList");
		var selRows = DocList.GetSelectedRows();
		if (selRows.length == 0) {
			alert("<spring:message code = 'ezSystem.config.hth23' />");
			return;
		}
		
		var paramObj = [];
		
		for (var i = 0; i < selRows.length; i++) {
			var dataObj = {}
			var permissionCode = selRows[i].getAttribute("data1");
			dataObj.permissionCode = permissionCode;
			paramObj.push(dataObj);
		}
		
		$.ajax({
			type : "POST",
        	url : "/admin/ezNotification/deleteEmergencyPermission.do?companyId=" + companySelectID,
        	data : JSON.stringify(paramObj),
        	contentType:"application/json; charset=utf-8",
        	success : function(result) {
        		getEmergencyNotiPermissions();
        		alert("<spring:message code = 'ezMain.delete.hth01' />");
        	},
        	error : function(error) {
        		alert("<spring:message code='ezNotification.hth34' />");
        	}
		});
	}
	
	function getNotiEmergencyContent() {
		$.ajax({
			type : "GET",
        	url : "/admin/ezNotification/getEmergencyContent.do",
        	dataType: "text",
        	data : {
        		companyId : companySelectID
        	},
        	success : function(result) {
        		var emergencyContent = result;
        		document.getElementById('emergencyNotiContent').value = emergencyContent;
        	},
        	error : function(error) {
        		alert("<spring:message code='ezNotification.hth34' />");
        	}
		});
	}
	
	function addNotiEmergencyContent() {
		var emergencyContent = document.getElementById('emergencyNotiContent').value.trim();
		if (emergencyContent.length > 40) {
			alert("<spring:message code='ezNotification.hth82' />");
			return;
		}
		
		$.ajax({
			type : "POST",
        	url : "/admin/ezNotification/addEmergencyCompanyContent.do",
        	dataType: "text",
        	data : {
        		companyId : companySelectID,
        		emergencyContent : emergencyContent
        	},
        	success : function(result) {
        		alert("<spring:message code='ezNotification.hth28' />");
        	},
        	error : function(error) {
        		alert("<spring:message code='ezNotification.hth34' />");
        	}
		});
		
	}
	
	function getEmergencyNotiPermissions() {
        $.ajax({
        	type : "GET",
        	dataType : "text",
        	url : "/admin/ezNotification/getEmergencyNotiPermissions.do",		        	
        	data : {companyId : companySelectID},
        	success : function(result) {
        		var xmldom = loadXMLString(result);
                var headerData = createXmlDom();
                headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());
                
                if (CrossYN()) {
                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
                    var Node = headerData.importNode(xmlRtn, true);
                    headerData.documentElement.appendChild(Node);
                } else {
                    var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
                    headerData.documentElement.appendChild(xmlRtn);
                }

                document.getElementById("AdminListView").innerHTML = "";

                var listview = new ListView();
                listview.SetID("lvEmergencyPermissionList");
                listview.SetMulSelectable(true);
                listview.SetHeightFree(true);
                listview.DataSource(headerData);
                listview.DataBind("AdminListView");
        	},
        	error : function(error){
        	    alert("<spring:message code='ezNotification.hth34' />");
        	}
        });		        
    }
	
	function changeCompany() {
		getNotiEmergencyContent();
		getEmergencyNotiPermissions();
	}
	</script>
</body>
</html>