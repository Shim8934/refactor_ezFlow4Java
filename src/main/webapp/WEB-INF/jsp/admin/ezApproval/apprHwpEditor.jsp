<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<html>
	<head>
		<title><spring:message code='ezApproval.t518'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApproval/admin/conn_HWP.js"></script>
		<script type="text/javascript">
		    var pDocID;      
		    var pDocHref;    
		    var pFormID;     
		    var pOpinionFlag;
		    var pListTypeValue;
		    var flag = false;
		    var FormText;
		    var g_toggleFlag = false;
		
		    window.onload = function () {
		        HwpCtrl.SetImgReg();
		        HwpCtrl.ezSetRegisterModule("HwpCtrlPathCheckModule");
		        HwpCtrl.SetSaveMode(1);
		    }
		
		    function HWP_LoadFile(formURL) {
		        HwpCtrl.LoadFile(formURL, false);
		    }
		
		    function HWP_GetCloneData() {
		        return HwpCtrl.GetCloneData("", "HWP");
		    }
		
		    function HWP_GetDocumentElement() {
		        return GetDocumentElement(HwpCtrl, "CONNROOT");
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
		            <SCRIPT type="text/javascript">ezHwpCtrl_ActiveX2("HwpCtrl", "1", "1", "111111", "", 1030, 760);</SCRIPT>
		        </td> 
		    </tr> 
		</table> 
	</body>
</html>