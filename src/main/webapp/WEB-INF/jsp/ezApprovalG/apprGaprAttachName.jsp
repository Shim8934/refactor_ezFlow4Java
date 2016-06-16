<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezApprovalG.t286'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pUserID;
		    var pFormID;
		    var ConnectFlag = true;
		    var Resultxml = createXmlDom();
		    var ret = new Array();
		    var NonActiveX = "YES";
		    function btn_SaveAprDeptTempletName_onclick() {
		        var p_AprDeptTempletName = txtPageNum.value;
		        var p_DisplayName = txtDisplayName.value;
		        if (p_AprDeptTempletName.length > 0) {
		            var strMatch = p_AprDeptTempletName.match(/^[0-9]+$/);
		            if (!strMatch) {
		                var pAlertContent = "<spring:message code='ezApprovalG.t287'/>";
		                OpenAlertUI(pAlertContent);
		                txtPageNum.focus();
		                return;
		            }
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t288'/>";
		            OpenAlertUI(pAlertContent);
		            txtPageNum.focus();
		            return;
		        }
		        if (p_AprDeptTempletName.length > 3) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t289'/>";
		            OpenAlertUI(pAlertContent);
		            txtPageNum.focus();
		            return;
		        }
		        if (p_AprDeptTempletName == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t290'/>";
		            OpenAlertUI(pAlertContent);
		            txtPageNum.focus();
		            return;
		        }
		        if (p_DisplayName == "") {
		            var pAlertContent = "<spring:message code='ezApprovalG.t291'/>";
		            OpenAlertUI(pAlertContent);
		            txtDisplayName.focus();
		        }
		        ret[0] = "OK";
		        ret[1] = p_AprDeptTempletName;
		        ret[2] = p_DisplayName;
		
		        if (ReturnFunction != null) {
		            ReturnFunction(ret);
		        }
		        else {
		            window.returnValue = ret;
		            window.close();
		        }
		    }
		    function AttachCancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction(ret);
		        }
		        else {
		            window.returnValue = ret;
		            window.close();
		        }
		    }
		    function btn_CancelAprDeptTempletName_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction(ret);
		        }
		        else {
		            window.returnValue = ret;
		            window.close();
		        }
		    }
		    var RetValue;
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            RetValue = parent.aprattachname_cross_dialogArguments[0];
		            ReturnFunction = parent.aprattachname_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.aprattachname_cross_dialogArguments[0];
		                ReturnFunction = opener.aprattachname_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		
		        txtPageNum.value = RetValue[0];
		        txtDisplayName.value = RetValue[1];
		        ret[0] = "cancel";
		        ret[1] = txtPageNum.value;
		        ret[2] = txtDisplayName.value;
		
		        if (!CrossYN() || NonActiveX == "NO")
		            window.returnValue = ret;
		
		        txtPageNum.focus();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent, CompleteFunction) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		
		        if (CrossYN() || NonActiveX == "YES") {
		            ezapralert_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapralert_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
		<body class="popup">
		<h1><spring:message code='ezApprovalG.t286'/></h1>
		<h2><spring:message code='ezApprovalG.t292'/></h2>
		
		<table class="content">
		  <tr> 
		    <th> <spring:message code='ezApprovalG.t293'/></th>
		    <td style="width:100%"> 
		      <input type="text" name="textfield4" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" id="txtPageNum">    </td>
		  </tr>
		  <tr> 
		    <th><spring:message code='ezApprovalG.t294'/></th>
		    <td> 
		      <input type="text" name="textfield4" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" id="txtDisplayName">    </td>
		  </tr>
		</table>
		
		<div class="btnposition"> 
		<a class="imgbtn" id="btn_SaveAprDeptTempletName" onClick="return btn_SaveAprDeptTempletName_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
	</body>
</html>