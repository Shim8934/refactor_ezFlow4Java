<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t518' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_HWP.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var pDocID;
		    var pDocHref;
		    var pFormID;
		    var pOpinionFlag;
		    var pListTypeValue;
		    var flag = false;
		    var FormText;
		    var g_toggleFlag = false;
	
		    /* $(document).ready(function() {
		        HwpCtrl.SetImgReg();
		        HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
		        HwpCtrl.SetSaveMode(1);
		    }); */
		    
		    window.onload = function () {
		    	HwpCtrl.SetImgReg();
		        HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
		        HwpCtrl.SetSaveMode(1);
		    }
	
		    function HWP_LoadFile(formURL) {
		    	var URL = document.location.protocol + "//" + document.location.hostname + ":" + location.port + "/ezCommon/downloadAttach.do?filePath=" + escape(formURL);
		        HwpCtrl.LoadFile(URL, false);
		    }
	
		    function HWP_GetCloneData() {
		        return HwpCtrl.GetCloneData("", "HWP");
		    }
	
		    function HWP_GetDocumentElement() {
		        return GetDocumentElement(HwpCtrl, "CONNROOT", true);
		    }
	
		    function HWP_SetDocumentElement(ConnValue) {
		        SetDocumentElement(HwpCtrl, "CONNROOT", ConnValue);
		    }
	
		    function SetAttribute(Value) {
		        HwpCtrl.OpenCellFieldDialog(Value);
		    }
		</script>
	</head>
	<body>
		<table>
			<tr>
				<td style="vertical-align:top">
					<script type="text/javascript">ezHwpCtrl_ActiveX2("HwpCtrl", "1", "1", "111111", "", 1030, 760);</script>
				</td>
			</tr>
			
		</table>
	</body>
</html>
