<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t25004'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var pUserID;
		    var pFormID;
		    var ConnectFlag = true;
		    var approvalFlag = "<c:out value ='${approvalFlag}'/>";     //전자결재 일반/공공 여부 (G : 공공 , S : 일반)
		    var Resultxml = createXmlDom();
		    var ret = new Array();
		    //2018-08-24 배현상, 확장자 변경 문제
		    var storeExp;
			// 2024-02-19 양지혜 - 첨부파일명 최대 길이
			var attachFileNameMaxLength = Number("<c:out value ='${attachFileNameMaxLength}'/>");

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
		        if (!p_AprDeptTempletName) {
		            var pAlertContent = "<spring:message code='ezApprovalG.t290'/>";
		            OpenAlertUI(pAlertContent);
		            txtPageNum.focus();
		            return;
		        }

		        if (p_DisplayName.split(".")[0].trim() == '') {
		            var pAlertContent = "<spring:message code='ezApprovalG.t291'/>";
		            OpenAlertUI(pAlertContent);
		            txtDisplayName.focus();
		            return;
		        }

				if (p_DisplayName.length > attachFileNameMaxLength) {
					var pAlertContent = "<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />";
					OpenAlertUI(pAlertContent);
					txtPageNum.focus();
					return;
				}


		        ret[0] = "OK";
		        ret[1] = p_AprDeptTempletName;
		        ret[2] = p_DisplayName + storeExp;;
		
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
				
		        var displayNameExpPoint = ReplaceText(RetValue[1], "&amp;", "&").lastIndexOf(".");
		        txtPageNum.value = RetValue[0];
		        txtDisplayName.value = ReplaceText(RetValue[1], "&amp;", "&").substring(0,displayNameExpPoint);
		        storeExp = ReplaceText(RetValue[1], "&amp;", "&").substring(displayNameExpPoint);
		        ret[0] = "cancel";
		        ret[1] = txtPageNum.value;
		        ret[2] = txtDisplayName.value;
		
		        if (!CrossYN())
		            window.returnValue = ret;
		
		        txtPageNum.focus();
		    }
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		        
	            ezapralert_cross_dialogArguments[0] = parameter;
                ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
                
	            DivPopUpShow(315, 205, url);
		    }
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		</script>
	</head>
		<body class="popup">		
		<h1><spring:message code='ezApprovalG.t25004'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return AttachCancel_onclick()"></span></li>
            </ul>
        </div>		
		<span>▒ <spring:message code='ezApprovalG.t292'/></span>		
		<table class="content" style="margin-top: 15px">		  
			<tr style="display: none">
		    	<th> <spring:message code='ezApprovalG.t293'/></th>
		    	<td style="width:100%"> 
		      		<input type="hidden" name="textfield4" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" id="txtPageNum" value="1"/>
		      	</td>
		  	</tr>
		  	<tr> 
		    	<th><spring:message code='ezApprovalG.t294'/></th>
		    	<td> 
		      		<input type="text" name="textfield4" style="width:100%;box-sizing:border-box;-moz-box-sizing:border-box;" id="txtDisplayName" />    
		      	</td>
		  	</tr>
		</table>		
		<div class="btnposition btnpositionNew"> 
			<a class="imgbtn" id="btn_SaveAprDeptTempletName" onClick="return btn_SaveAprDeptTempletName_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
		</div>		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>