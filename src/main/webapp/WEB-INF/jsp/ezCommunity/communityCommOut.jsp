<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title>Community <spring:message code='ezCommunity.t714' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			function outok_onclick(code) {
				if( window.outreason.value == "" ){
					alert("<spring:message code='ezCommunity.t715'/>");
					window.outreason.focus();
					
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
					alert("<spring:message code='ezCommunity.t716'/>");
					window.self.close();
				} else {
					alert("<spring:message code='ezCommunity.t717'/>");
					window.self.close();
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
		<h1>Community <spring:message code='ezCommunity.t714'/></h1>
		
		<table class="content" style="margin-bottom:10px" >
			<tr>
		    	<th>Community <spring:message code='ezCommunity.t10'/></th>
		        <td>${club.c_ClubName}</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezCommunity.t477'/></th>
		        <td>${club.c_MemberCnt}<spring:message code='ezCommunity.t478'/></td>
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
		
		<textarea name="textarea" id="outreason" style="width: 97%;height:110px" maxLength="200"></textarea>
		
		<div class="btnposition">
			<a class="imgbtn" name="Submit" id="outok" onClick="return outok_onclick('${code}')"><span><spring:message code='ezCommunity.t719'/></span></a>
			<a class="imgbtn"name="Submit2" id="outcancel" onClick="return outcancel_onclick()" ><span><spring:message code='ezCommunity.t246'/></span></a>
		</div>
	</body>
</html>