<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t60" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js" ></script>
		<style type="text/css">
    		.warningbox01 { width:540px; margin:0 auto; border:1px solid #cccaca; background:#e8e8e8;font-family:Gulim, Dotum,Verdana, Arial, Helvetica, sans-serif;}
    		.warningbox02 { width:470px; margin:0 auto;  background:#ffffff; margin:10px; padding:15px 25px 20px 25px;}
    		.warnintxt01 { position:relative ;padding-bottom:10px;}
    		.warningimg { position:absolute; top:0px; left:0px;}
    		.warningdl { padding:10px 0px 5px 150px; margin:0px 0px 0px 0px;}
    		.warningdl dt { height:40px; margin-top:10px;text-align:left;}
    		.warningdl dd { padding:0px 0px 0px 5px; margin:0px; height:50px; font-weight:bold; font-size:14px; color:#333333;text-align:left;}
    		.warnintxt02 { font-size:12px; color:#666666; line-height:18px; margin:10px 10px 10px 10px; padding:0px;}
		</style>
		<script type="text/javascript" id="clientEventHandlersJS" >
			var pCompanyID	= "${selCompanyID}";
			var pResID		= "${brdID}";

			function cmdDel_onclick() {
				var rv = window.confirm("<spring:message code="ezResource.t61" />")
			
				if( rv == true ) {
					var xmlPara = "";
					var xmlHttp = "";

					if (CrossYN()) {
					    xmlPara = createXmlDom();
					    xmlHttp = createXMLHttpRequest();

					    var objNode;
				    	createNodeInsert(xmlPara, objNode, "PARADATA");
				    	createNodeAndInsertText(xmlPara, objNode, "DATA", pResID);
				    	createNodeAndInsertText(xmlPara, objNode, "DATA", pCompanyID);
					} else {
					    xmlPara = new ActiveXObject("Microsoft.XMLDOM");
				    	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");

				    	var objRootNode = xmlPara.createNode(1, "PARADATA", "");
				    	xmlPara.appendChild(objRootNode);

				    	var objNode = xmlPara.createNode(1, "DATA", "");
				    	objNode.text = pResID;
				    	objRootNode.appendChild(objNode);

				    	var objNode = xmlPara.createNode(1, "DATA", "");
				    	objNode.text = pCompanyID;
				    	objRootNode.appendChild(objNode);
					}

					xmlHttp.open("Post", "/admin/ezResource/callBrdDel.do", false);
					xmlHttp.send(xmlPara)
					if (xmlHttp.status != 200){
						alert("1. <spring:message code="ezResource.t63" />");
						return;
					}

					var rtnText = xmlHttp.responseText
					if (rtnText == "" || rtnText == "False"){
						alert("2. <spring:message code="ezResource.t63" />");
						return;
					}else{
						alert("<spring:message code="ezResource.t64" />");
						parent.window.location.reload();
					}
				}
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1><spring:message code="ezResource.t27" /></h1>
    	<br>
    	<br>
    	<table class="content">
        	<tr>
            	<th><spring:message code="ezResource.t44" /></th>
            	<td> ${upNm}<input type="hidden" id="UPPER_NM" name="UPPER_NM" value="${upNm}"></td>
        	</tr>
    	</table>
    	<br>

    	<div id="EmptyMsg">
    		<div class="warningbox01" style="margin-top:100px;">
        		<div class="warningbox02" style="height:130px;width:auto">
  	        		<div class="warnintxt01" style="text-align:left">
	        			<span class="warningimg"><img src="/images/notify/warning02_resorce.gif" width="136" height="112"></span>
	        			<dl class="warningdl">
	        				<dd> ${pWrnMsg}</dd>
	        			</dl>
	        		</div>
	    		</div>
    		</div>
		</div>
	    <br>
		<div class="btnposition">
			<c:if test="${blnChkDelBtn eq true}">
				<a class="imgbtn"><span onclick="cmdDel_onclick()" ><spring:message code="ezResource.t65" /></span></a>
			</c:if>
		</div>
			
    	<form name="brds">
        	<input type="hidden" id="proc" name="proc" value="DEL">
        	<input type="hidden" id="test" value="">
    	</form>
	</body>
</html>