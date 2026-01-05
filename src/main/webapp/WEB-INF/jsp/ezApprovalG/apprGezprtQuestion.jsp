<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t10018'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var eopinion = "<c:out value ='${opinion}'/>";
		    var eAttach = "<c:out value ='${attach}'/>";
		    var rvalue = new Array();
			var messageFrame = "";
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
				if (parent.draftAllFlag != "undefined" && parent.draftAllFlag == "Y") {
					messageFrame = parent.document.getElementById("ifrm" + parent.currentTabIdx);
				} else {
					messageFrame = parent.document.getElementById("message");
				}
				var pages;
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					pages = messageFrame.contentWindow.document.getElementById("div_Content").getElementsByClassName("divImg").length;
				} else {
					pages = messageFrame.contentWindow.document.getElementById("body").getElementsByClassName("divImg").length;
				}
				
		        if(pages <= 0){
		        	$("#Submit4").css("display", "none");
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
		        rvalue[3] = "Y";
		
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
		            
                if (summary.checked == true)
		            rvalue[3] = "Y";
		        else
		            rvalue[3] = "N";
		
		        if (opi.checked != true && att.checked != true && line.checked != true && summary.checked != true) {
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
		
		        if (CrossYN()) {
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
				var imgDiv;
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					imgDiv = messageFrame.contentWindow.document.getElementById("div_Content").getElementsByClassName("divImg").length;
				} else {
					imgDiv = messageFrame.contentWindow.document.getElementById("body").getElementsByClassName("divImg").length;
				}
				
		    	var imgDiv2 = $(imgDiv).nextAll();
				var imgDiv3 = $(imgDiv).prevAll();
				$(imgDiv2).css("display", "");
				$(imgDiv3).css("display", "");
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
			
		    function all_pages() {
				var imgDiv;
				if (navigator.maxTouchPoints > 4 || isTeamsDesktop()) {
					imgDiv = messageFrame.contentWindow.document.getElementById("div_Content").getElementsByClassName("divImg").length;
				} else {
					imgDiv = messageFrame.contentWindow.document.getElementById("body").getElementsByClassName("divImg").length;
				}
				
		    	var imgDiv2 = $(imgDiv).nextAll();
				var imgDiv3 = $(imgDiv).prevAll();
				$(imgDiv2).css("display", "");
				$(imgDiv3).css("display", "");
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
		        $(imgDiv2).css("display", "none");
				$(imgDiv3).css("display", "none");
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
		<div id="close">
            <ul>
                <li><span onclick="return Cancel()"></span></li>
            </ul>
        </div>
		<span>▒ <spring:message code='ezApprovalG.t10019'/></span>
		<span id=pMessageContent></span>
		<table class="content" style="margin-top:10px">
			<tr><th><div class='custom_checkbox'><input id='opi' name ='opi'  type='checkbox' ></div></th>
			<td><span id="ext1"><spring:message code='ezApprovalG.t10020'/></span></td></tr>
			<tr><th ><div class='custom_checkbox'><input id='att' name='att'  type='checkbox' ></div></th>
			<td><span id="ext2"><spring:message code='ezApprovalG.t10021'/></span></td> </tr>
			<tr><th ><div class='custom_checkbox'><input id='line' name='line' type='checkbox'></div></th>
			<td><span id="ext3"><spring:message code='ezApprovalG.t10022'/></span></td> </tr>
			<tr><th ><div class='custom_checkbox'><input id='summary' name='summary' type='checkbox'></div></th>
			<td><span id="ext3"><spring:message code='ezApprovalG.summary01'/></span></td> </tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a id="Submit1" class="imgbtn" onClick="return all_click()"><span><spring:message code='ezApprovalG.t10023'/></span></a>
		    <a id="Submit2" class="imgbtn" onClick="return select_click()" ><span><spring:message code='ezApprovalG.t10024'/></span></a>
		    <a id="Submit3" class="imgbtn" onClick="return only_click()" ><span><spring:message code='ezApprovalG.t10025'/></span></a>
		    <a id="Submit4" class="imgbtn" onClick="return all_pages()" ><span>전체페이지인쇄</span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>