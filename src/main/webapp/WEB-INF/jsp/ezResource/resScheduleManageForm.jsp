<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t377" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
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
	    
	    	function DocumentComplete() {
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
		        if (!retVal) {
		            DivPopUpHidden();
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
				
		        if(rtnVal=="OK"){
					alert("<spring:message code='ezResource.t56'/>");
				}else if(rtnVal=="FALSE"){
					alert("<spring:message code='ezResource.t42'/>");	
				}
		        
	    	    OpenAlertUI(strLang256);
	        	DivPopUpHidden();
	        	window.close();
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
	        		OpenAlertUI(strLang257);
	            	return;
	        	}

	        	var pAlertContent = strLang258;
	        	apropinion_cross_dialogArguments[0] = pAlertContent;
	        	apropinion_cross_dialogArguments[1] = idDelBtn_onclick_Complete

	        	DivPopUpShow(330, 205, "/ezResource/apropinion.do");
	        
	    	}
	    	function idDelBtn_onclick_Complete(retVal) {
		        if (!retVal)
		            return;

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
		            OpenAlertUI(strLang259);
		            window.close();
		            alert("<spring:message code='ezResource.t64'/>");
	        	}
	        	else
		            OpenAlertUI(strLang260);
		    }

	    	var apralert_cross_dialogArguments = new Array();
	    	function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        apralert_cross_dialogArguments[0] = parameter;
	    	    apralert_cross_dialogArguments[1] = OpenAlertUI_Complete;

	        	//DivPopUpShow_sub(330, 205, "../APRALERT_Cross.aspx");
	    	}
	    	function OpenAlertUI_Complete() {
	        
		    }

		</script>
	</head>
	<body class="popup">
		<h1 id="subtitle"><spring:message code="ezResource.t377" /></h1>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel_sub">&nbsp;</div>	
    	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel_sub">
			<iframe src="/blank.htm" style="border:none;" id="iFrame1"></iframe>
		</div>
 		<div id="close">
        	<ul>
          		<li id="idDocSaveBtn"><span onclick="return idDocSaveBtn_onclick()"><spring:message code="ezResource.t378" /></span></li>
          		<li id="idDelBtn"><span onclick="return idDelBtn_onclick()"><spring:message code="ezResource.t379" /></span></li>
          		<li><span onclick="window.close();"> <spring:message code="ezResource.t150" /></span></li>
        	</ul>
 		</div>
 			<c:choose>
 				<c:when test="${pNoneActiveX eq 'YES'}">
 					<div id="divCross" style="margin-top:10px;vertical-align:top;width:675px;height:620px;">
 				</c:when>
 				<c:otherwise>
 					<div id="divCross" style="margin-top:10px;vertical-align:top;width:675px;height:600px;">
 				</c:otherwise>
 			</c:choose>
 			
			<c:choose>
				<c:when test="${editor eq 'TAGFREE'}">
					<iframe id="message" class="viewbox"  name="message" src="/ezResource/tagFreeTFXEditor.do" style="padding:0; height:100%; width:100%; overflow:auto;" frameborder="0"></iframe>
				</c:when>
				<c:when test="${editor eq 'DEXT'}">
					<iframe id="message" class="viewbox"  name="message" src="/ezResource/dextEditor.do" style="padding:0; height:100%; width:100%; overflow:auto;" frameborder="0"></iframe>
				</c:when>
				<c:otherwise>
					<iframe id="message" class="viewbox"  name="message" src="/ezResource/ckEditor.do" style="padding:0; height:100%; width:100%; overflow:auto;" frameborder="0"></iframe>
				</c:otherwise>
			</c:choose>            
       </div>
	</body>
</html>