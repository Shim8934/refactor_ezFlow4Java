<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t10018'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/ezApprovalG/appandbody_Cross.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var eopinion = "${opinion}";
		    var eAttach = "${attach}";
		    var rvalue = new Array();
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        };
		    }
		    var ReturnFunction;
		    window.onload = function () {
		        try {
		            ReturnFunction = parent.ezprtquestion_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                ReturnFunction = opener.ezprtquestion_cross_dialogArguments[1];
		            } catch (e) {
		            }
		        }
		        if (eopinion != "true") {
		            opi.disabled = true;
		        }
		        if (eAttach != "true") {
		            att.disabled = true;
		        }
		    };
		
		    function all_click() {
		        if (eopinion == "true")
		            rvalue[0] = "Y";
		        else
		            rvalue[0] = "N";
		
		        if (eAttach == "true")
		            rvalue[1] = "Y";
		        else
		            rvalue[1] = "N";
		
		        rvalue[2] = "Y";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		        else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		
		    function select_click() {
		        if (eopinion == "true") {
		            if (opi.checked == true)
		                rvalue[0] = "Y";
		            else
		                rvalue[0] = "N";
		        }
		        else
		            rvalue[0] = "N";
		
		        if (eAttach == "true") {
		            if (att.checked == true)
		                rvalue[1] = "Y";
		        }
		        else
		            rvalue[1] = "N";
		
		        if (line.checked == true)
		            rvalue[2] = "Y";
		        else
		            rvalue[2] = "N";
		
		        if (opi.checked != true && att.checked != true && line.checked != true) {
		            if (CrossYN()) {
		                OpenInformationUI(strLang1001);
		                return;
		            }
		            else {
		                if (OpenInformationUI(strLang1001)) {
		                    window.returnValue = rvalue;
		                    window.close();
		                    return;
		                }
		                else {
		                    return;
		                }
		            }
		        }
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		        else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		
		    var ezapropinion_cross_dialogArguments = new Array();
		    function OpenInformationUI(pInformationContent, CompleteFunction) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		
		        if (CrossYN() || NonActiveX == "YES") {
		            ezapropinion_cross_dialogArguments[0] = parameter;
		            if (CompleteFunction != undefined)
		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
		            else
		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
		            DivPopUpShow(330, 205, url);
		        }
		        else {
		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		            feature = feature + GetShowModalPosition(330, 205);
		            var RtnVal = window.showModalDialog(url, parameter, feature);
		        }
		        return RtnVal;
		    }
		
		    function OpenInformationUI_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn) {
		            if (ReturnFunction != null) {
		                ReturnFunction(rvalue);
		            }
		        }
		        else {
		            return;
		        }
		    }
		
		    function only_click() {
		        rvalue[0] = "N";
		        rvalue[1] = "N";
		        rvalue[2] = "N";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		        else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		
		    function Cancel() {
		        rvalue[0] = "0";
		        rvalue[1] = "0";
		        rvalue[2] = "0";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		    }
		
		    window.onbeforeunload = function () {
		        if (rvalue[0] == null) {
		            rvalue[0] = "0";
		            rvalue[1] = "0";
		            rvalue[2] = "0";
		        }
		
		        if (!CrossYN()) {
		            window.returnValue = rvalue;
		            window.close();
		        }
		        
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.t10018'/></h1>
		<h2><spring:message code='ezApprovalG.t10019'/></h2>
		<span id=pMessageContent></span>
		<table class="content">
		<tr><th><input id='opi' name ='opi'  type='checkbox' ></th>
		<td><span id="ext1"><spring:message code='ezApprovalG.t10020'/></span></td></tr>
		<tr><th ><input id='att' name='att'  type='checkbox' ></th>
		<td><span id="ext2"><spring:message code='ezApprovalG.t10021'/></span></td> </tr>
		<tr><th ><input id='line' name='line' type='checkbox'></th>
		<td><span id="ext3"><spring:message code='ezApprovalG.t10022'/></span></td> </tr>
		</table>
		<div class="btnposition">
		    <a id="Submit1" class="imgbtn" onClick="return all_click()"><span><spring:message code='ezApprovalG.t10023'/></span></a>
		    <a id="Submit2" class="imgbtn" onClick="return select_click()" ><span><spring:message code='ezApprovalG.t10024'/></span></a>
		    <a id="Submit3" class="imgbtn" onClick="return only_click()" ><span><spring:message code='ezApprovalG.t10025'/></span></a>
		    <a id="Submit4" class="imgbtn" onClick="return Cancel()" ><span><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>