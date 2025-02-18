<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t377" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript" >
			var flag = false;
	    	var FormText;
	    	var g_toggleFlag = false;
	    	var pAdminFg   = "${adminFg}";
	    	var pCompanyID = "${userInfo.companyID}";
	    	var pResID = "${resID}";
	    	var pbrdName = "${brdName}";
	    	var result;
	    	var rtnVal;
	    	
	    	/* 2019-10-29 홍승비 - 에디터 영역 > personalizedPortal 스타일에 맞게 좌우폭 수정 */
	    	window.onload = function () {
	        	document.getElementById("divCross").style.width = document.getElementById("mainbodytag").offsetWidth + "px";
	        	document.getElementById("divCross").style.height = window.innerHeight - 111 + "px";
	        }
	    	
	    	window.onresize = function () {
	        	document.getElementById("divCross").style.width = document.getElementById("mainbodytag").offsetWidth + "px";
	        	document.getElementById("divCross").style.height = window.innerHeight - 111 + "px";
	        }
	    	
	    	function Editor_Complete() {
	        	var isComplete = false;
	        	if (!isComplete) {
	            	document.getElementById("subtitle").innerText = "[" + pbrdName + "]" + document.getElementById("subtitle").innerText;
	            	var xmlHttp = createXMLHttpRequest();
	            	var xmlDoc = createXmlDom();
	            	var objNode;

	            	createNodeInsert(xmlDoc, objNode, "PARAMETER");
	            	createNodeAndInsertText(xmlDoc, objNode, "RESID", pResID);

	            	xmlHttp.open("POST", "/ezResource/scheduleGetForm.do", false);
	            	xmlHttp.send(xmlDoc);

	            	result = xmlHttp.responseText;

	            	if (result != "FALSE") {
	                	var msgRtn = result; //"<div id=msgbody><div>" +result + "</div></div>";
	                	message.SetEditorContent(msgRtn);
	            	} else {
	            		message.SetEditorContent('');	
	            	}
	            	isComplete = true;
	    	    }
	    	}

	    	function FieldsAvailable() {
	    	}

	    	var apropinion_cross_dialogArguments = new Array();
	    	function idDocSaveBtn_onclick() {
		        FormText = message.GetEditorContent();

		        var pAlertContent = strLang255;
	    	    apropinion_cross_dialogArguments[0] = pAlertContent;
	        	apropinion_cross_dialogArguments[1] = idDocSaveBtn_onclick_Complete

		        DivPopUpShow(330, 205, "/ezResource/apropinion.do");
	        
		    }
	    	function idDocSaveBtn_onclick_Complete(retVal) {
	    		DivPopUpHidden();
	    		
	    		if (!retVal) {
	    	        return;
	        	}

	        	var xmlHttp = createXMLHttpRequest();
	        	var xmlDoc = createXmlDom();
	        	var resultXML = createXmlDom();
	        	var objNode;

		        createNodeInsert(xmlDoc, objNode, "PARAMETER");
		        createNodeAndInsertText(xmlDoc, objNode, "RESID", pResID);
	    	    createNodeAndInsertText(xmlDoc, objNode, "BRDNM", pbrdName);
	        	createNodeAndInsertText(xmlDoc, objNode, "FORMTEXT", FormText);

		        xmlHttp.open("POST", "/ezResource/scheduleSaveForm.do", false);
		        xmlHttp.send(xmlDoc);
	
		        rtnVal = xmlHttp.responseText;
				
		        if (rtnVal == "OK") {
					alert(strLang256);
		        	window.close();
				} else if (rtnVal == "FALSE") {
					alert("<spring:message code='ezResource.t42'/>");
				}
		        
	    	}

	    	function idDelBtn_onclick() {

	        	var DomHttp = createXMLHttpRequest();
	        	var Dom = createXmlDom();
	        	var valFlag;
	        	var objNode;

	        	createNodeInsert(Dom, objNode, "PARAMETER");
	        	createNodeAndInsertText(Dom, objNode, "RESID", pResID);

	        	DomHttp.open("POST", "/ezResource/scheduleGetForm.do", false);
	        	DomHttp.send(Dom);

	        	valFlag = DomHttp.responseText;
	        	if (valFlag == "FALSE") {
	        		alert(strLang257);
	            	return;
	        	}

	        	var pAlertContent = strLang258;
	        	apropinion_cross_dialogArguments[0] = pAlertContent;
	        	apropinion_cross_dialogArguments[1] = idDelBtn_onclick_Complete

	        	DivPopUpShow(330, 205, "/ezResource/apropinion.do");
	        
	    	}
	    	function idDelBtn_onclick_Complete(retVal) {
		        DivPopUpHidden();
		        
		        if (!retVal) {
		            return;
		        }

	        	var xmlHttp = createXMLHttpRequest();
	        	var xmlDoc = createXmlDom();
	        	var reVal;
	        	var node;

	        	createNodeInsert(xmlDoc, node, "PARAMETER");
	        	createNodeAndInsertText(xmlDoc, node, "RESID", pResID);

	        	xmlHttp.open("POST", "/ezResource/scheduleDelForm.do", false);
	        	xmlHttp.send(xmlDoc);

	        	reVal = xmlHttp.responseText;

	        	if (reVal == "OK") {
	        		alert(strLang259);
	        	}
	        	else {
	        		alert(strLang260);
	        	}
	        	
	        	window.location.reload();
		    }
	    	
	    	//2017-03-13 이효민 : 구현이 되다만 함수인듯해서 사용하지 않도록 수정함
//	    	var apralert_cross_dialogArguments = new Array();
//	    	function OpenAlertUI(pAlertContent) {
//		        var parameter = pAlertContent;
//		        apralert_cross_dialogArguments[0] = parameter;
//	    	    apralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
//
//	        	//DivPopUpShow_sub(330, 205, "../APRALERT_Cross.aspx");
//	    	}
//	    	function OpenAlertUI_Complete() {
//	        
//		    }

		</script>
	</head>
	<body class="popup" id="mainbodytag">
		<h1 id="subtitle"><spring:message code="ezResource.t377" /></h1>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel_sub">&nbsp;</div>	
    	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel_sub">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrame1"></iframe>
		</div>
		
 		<div id="close">
        	<ul>
          		<li><span onclick="window.close();"></span></li>
        	</ul>
 		</div>
 		<div id="divCross" style="margin-top:10px;vertical-align:top;height:535px">
			<iframe id="message" class="viewbox"  name="message" src="/ezEditor/selectEditor.do?type=RESOURCE" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
       	</div>
       	<div class="btnpositionNew">
       		<a class="imgbtn" onClick="return idDocSaveBtn_onclick()" id="idDocSaveBtn"><span><spring:message code="ezResource.t378" /></span></a>
		    <a class="imgbtn" onClick="return idDelBtn_onclick()" id="idDelBtn"><span><spring:message code="ezResource.t379" /></span></a>
		</div>
	</body>
</html>