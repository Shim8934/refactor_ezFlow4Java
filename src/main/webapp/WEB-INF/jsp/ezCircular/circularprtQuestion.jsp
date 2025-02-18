<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCircular.t192'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCircular/ListView_list.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var attachList = "<c:out value='${attachList}'/>";
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
		        if (attachList != "true") {
		            att.disabled = true;
		        }
		    };
		
		    function all_click() {
	            rvalue[0] = "Y";
	            
				if (attachList == "true") {
					rvalue[1] = "Y";
				} else {
					rvalue[1] = "N";
				}
				
		        if (ReturnFunction != null) {
					ReturnFunction(rvalue);
		        } else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		
		    function select_click() {
	            if (opi.checked == true) {
	                rvalue[0] = "Y";
	            } else {
	                rvalue[0] = "N";
	            }
		
		        if (attachList == "true") {
		            if (att.checked == true) {
		                rvalue[1] = "Y";
		            } else {
		                rvalue[1] = "N";
					}
		        } else {
		            rvalue[1] = "N";
		        }

		        if (opi.checked != true && att.checked != true) {
					alert("<spring:message code='ezCircular.t193'/>");
					return;
		        }
		        
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        } else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		    
// 		    var ezapropinion_cross_dialogArguments = new Array();
// 		    function OpenInformationUI(pInformationContent, CompleteFunction) {
// 		        var parameter = pInformationContent;
// 		        var url = "/ezApprovalG/ezAprOpinion.do";
		
// 		        if (CrossYN()) {
// 		            ezapropinion_cross_dialogArguments[0] = parameter;
// 		            if (CompleteFunction != undefined)
// 		                ezapropinion_cross_dialogArguments[1] = CompleteFunction;
// 		            else
// 		                ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
// 		            DivPopUpShow(330, 205, url);
// 		        }
// 		        else {
// 		            var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
// 		            feature = feature + GetShowModalPosition(330, 205);
// 		            var RtnVal = window.showModalDialog(url, parameter, feature);
// 		        }
// 		        return RtnVal;
// 		    }
		
// 		    function OpenInformationUI_Complete(rtn) {
// 		        DivPopUpHidden();
// 		        if (rtn) {
// 		            if (ReturnFunction != null) {
// 		                ReturnFunction(rvalue);
// 		            }
// 		        }
// 		        else {
// 		            return;
// 		        }
// 		    }
		
		    function only_click() {
		        rvalue[0] = "N";
		        rvalue[1] = "N";
		
		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        } else {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		
		    function Cancel() {
		        rvalue[0] = "0";
		        rvalue[1] = "0";

		        if (ReturnFunction != null) {
		            ReturnFunction(rvalue);
		        }
		    }
		
		    window.onbeforeunload = function () {
		        if (rvalue[0] == null) {
		            rvalue[0] = "0";
		            rvalue[1] = "0";
		        }
		
		        if (!CrossYN()) {
		            window.returnValue = rvalue;
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezCircular.t113' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="return Cancel()"></span></li>
            </ul>
        </div>
		<span>▒ <spring:message code='ezCircular.t162' /></span>
		<span id=pMessageContent></span>
		<table class="content" style="margin-top:10px">
			<tr>
				<th><input id='opi' name ='opi'  type='checkbox' ></th>
				<td><span id="ext1">&nbsp;<spring:message code='ezCircular.t176' /></span></td>
			</tr>
			<tr>
				<th><input id='att' name='att'  type='checkbox' ></th>
				<td><span id="ext2">&nbsp;<spring:message code='ezCircular.t175' /></span></td>
			</tr>
		</table>
		<div class="btnposition btnpositionNew">
		    <a id="Submit1" class="imgbtn" onClick="return all_click()"><span><spring:message code='ezCircular.t177' /></span></a>
		    <a id="Submit2" class="imgbtn" onClick="return select_click()" ><span><spring:message code='ezCircular.t178' /></span></a>
		    <a id="Submit3" class="imgbtn" onClick="return only_click()" ><span><spring:message code='ezCircular.t179' /></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>