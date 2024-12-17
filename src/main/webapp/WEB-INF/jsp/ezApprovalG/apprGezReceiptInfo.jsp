<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1217'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript">
		    var pDocID = "<c:out value ='${docID}'/>";
		    var listview = new ListView();
		    var OrderCell = "";
		    var RtnVal = "";
		    var ext = "<c:out value ='${ext}'/>";
		    var mode = "<c:out value ='${mode}'/>";
		    window.onload = function () {
		        try {
		            $.ajax({
		        		type : "POST",
		        		dataType : "text",
		        		async : false,
		        		url : "/ezApprovalG/getReceiptinfo.do",
		        		data : {
		        				docID : pDocID,
		        				mode  : mode
		        				},
		        		success: function(xml){
		        			 RtnVal = loadXMLString(xml);
		        		}        			
		        	});
		            
		            listview.SetID("lvtAprLine");
		            listview.DataSource(RtnVal);
		            listview.DataBind("lvAprLine");
		        }
		        catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    };
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		    function window_close() {
		        if (CrossYN()) {
		            parent.DivPopUpHidden();
		        } else {
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t1217'/></h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window_close()"></span></li>
		  </ul>
		</div>
		<div class="listview">
		    <DIV id="lvAprLine" style="BORDER:0;WIDTH:auto; HEIGHT: 150px; overflow-x:hidden;overflow-y:auto"></DIV>
		</div>
	</body>
</html>
