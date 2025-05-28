<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title>address_search</title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script>
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
		    function Change_Click()
			{	   		
				var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				var objRoot;
				createNodeInsert(xmlDom, objRoot, "DATA");
				createNodeAndInsertText(xmlDom, objRoot, "USERID", "${userInfo.id}");
		        createNodeAndInsertText(xmlDom, objRoot, "LISTCNT", document.getElementById("listcount").value);
		        createNodeAndInsertText(xmlDom, objRoot, "LISTTYPE", document.getElementById("listtype").value);
				xmlHTTP.open("POST", "/ezAddress/addressSaveConfig.do", false);
				xmlHTTP.send(xmlDom);
		
				if (xmlHTTP.status == 200) 
					alert("<spring:message code='ezEmail.t42' />");
				else
					alert("<spring:message code='ezAddress.t34' /> -" + xmlHTTP.status);
						
				window.location.reload(true);
			}
		
			function Cancel_Click()
			{
				window.location.reload(true);
			}
		
		</script>
	</head>
	<body style="margin-left:10px">
	    <br />
	    <span>▒ <spring:message code='ezAddress.t385' /></span>
		<form id="Form1" method="post">
			<table class="content" style="width:450px;margin-top:5px">
			  <tr>
			    <th><spring:message code='ezAddress.t2004' /></th>
			    <td>
			        <select id="listtype" style="WIDTH:110px">
			            <option value="card" <c:if test="${pListType == 'card'}"> selected</c:if>><spring:message code='ezAddress.t2000' /></option>
			            <option value="list" <c:if test="${pListType == 'list'}"> selected</c:if>><spring:message code='ezAddress.t2001' /></option>
			        </select>
			    </td>
			  </tr>
			  <tr>
			    <th><spring:message code='ezAddress.t999900001' /></th>
			    <td>
			        <select id="listcount" style="WIDTH:110px">
			            <option value=10 <c:if test="${listCount == '10'}"> selected</c:if>>10</option>
			            <option value=15 <c:if test="${listCount == '15'}"> selected</c:if>>15</option>
			            <option value=20 <c:if test="${listCount == '20'}"> selected</c:if>>20</option>
			            <option value=25 <c:if test="${listCount == '25'}"> selected</c:if>>25</option>
			            <option value=30 <c:if test="${listCount == '30'}"> selected</c:if>>30</option>
			            <option value=35 <c:if test="${listCount == '35'}"> selected</c:if>>35</option>
			            <option value=50 <c:if test="${listCount == '50'}"> selected</c:if>>50</option>
			        </select>
			      	<spring:message code='ezAddress.t233' />
			  	</td>
			  </tr>
			</table>
			<div align="center" style="width:450px;">
				<div class="btnpositionJsp" style="padding: 0px;">
					<a class="imgbtn" onClick="Change_Click()"><span><spring:message code='ezAddress.t300' /></span></a>
					<a class="imgbtn" onClick="Cancel_Click()"><span><spring:message code='ezAddress.t11' /></span></a>
				</div>	
			</div>
		</form>
	</body>
</html>
