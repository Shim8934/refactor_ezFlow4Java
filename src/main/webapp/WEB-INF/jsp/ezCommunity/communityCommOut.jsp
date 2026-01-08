<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t714' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		
		<script type="text/javascript">
			function outok_onclick(code) {
				if( window.outreason.value == "" ){
					OpenAlertUI("<spring:message code='ezCommunity.t715'/>");
					return;
				}
				
			    var xmlHttp = createXMLHttpRequest();
			    var xmlDoc = createXmlDom();
			    var objRoot;
	
			    createNodeInsert(xmlDoc, objRoot, "PARAMETER");
			    createNodeAndInsertText(xmlDoc, objRoot, "CODE", code);
			    createNodeAndInsertText(xmlDoc, objRoot, "REASON", ConvMakeXMLString(window.outreason.value));
	
			    xmlHttp.open("POST","/ezCommunity/commOutOk.do",false);
			    xmlHttp.setRequestHeader("Content-Type", "text/xml;charset=UTF-8");
				xmlHttp.send(xmlDoc);
					
				var resultXML = loadXMLString(xmlHttp.responseText);

				rtnValue = SelectNodes(resultXML, "/RETURN/VALUE").item(0).textContent;

	
				if( rtnValue == "1" ) {
					OpenAlertUI("<spring:message code='ezCommunity.t716'/>",outcancel_onclick);
				} else {
					OpenAlertUI("<spring:message code='ezCommunity.t717'/>",outcancel_onclick);
				}
			}
			
			function ConvMakeXMLString(str) {
				str = ReplaceText(str, "&amp;","&");
				str = ReplaceText(str, "&lt;", "<");
				str = ReplaceText(str, "&gt;", ">");
				return str;
			}
	
			function outcancel_onclick() {
				window.self.close();
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezCommunity.t714'/></h1>
		<div id="close">
            <ul>
                <li><span name="Submit2" id="outcancel" onClick="return outcancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content" style="margin-bottom:10px" >
			<tr>
		    	<th><spring:message code='ezCommunity.t9991'/></th>
		        <td>${club.c_ClubName}</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezCommunity.t477'/></th>
		        <c:choose>
		        	<c:when test="${club.c_MemberCnt > 1}">
				        <td>${club.c_MemberCnt} <spring:message code='ezSurvey.t102'/></td>
			        </c:when>
			        <c:otherwise>
				        <td>${club.c_MemberCnt}<spring:message code='ezCommunity.t478'/></td>
			        </c:otherwise>
			    </c:choose>
		    </tr>
		    <tr>
		        <th><spring:message code='ezCommunity.t11'/></th>
		        <td>${str_category_print}</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezCommunity.t15'/></th>
		        <td>
		        	<c:choose>
		        		<c:when test="${club.c_ClubGubun == '2' }">
		        			<spring:message code='ezCommunity.t718'/>
		        		</c:when>
		        		<c:when test="${club.c_ClubGubun == '3' }">
		        			<spring:message code='ezCommunity.t17'/>
		        		</c:when>
		        	</c:choose>
		        </td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezCommunity.t9'/></th>
		        <td>${sysopName}</td>
		    </tr>
		</table>
		
		<textarea name="textarea" id="outreason" style="width: 97%;height:110px;resize:none" maxLength="200"></textarea>
		
		<div class="btnpositionNew">
			<a class="imgbtn" name="Submit" id="outok" onClick="return outok_onclick('${code}')"><span><spring:message code='ezCommunity.t719'/></span></a>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background:none rgba(0,0,0,0.5); display:none;" id="mailPanel"></div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute; display: none;" id="iFramePanel">
			<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>