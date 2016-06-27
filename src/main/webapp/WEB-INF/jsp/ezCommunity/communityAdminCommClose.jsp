<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>Insert title here</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			function closeok_onclick( code ) {
				if( document.getElementById("closereason").value == "" ) {
					alert("<spring:message code = 'ezCommunity.t464' />");
				    document.getElementById("closereason").focus();
					
					return;
				}
				
			    if (document.getElementById("closereason").length > 2000) {
					alert("<spring:message code = 'ezCommunity.t465' />");
			        document.getElementById("closereason").focus();
					
					return;	
				}
			    
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommunity/adminCommCloseOk.do",
					data : {code	:	code,
							reason	:	ConvMakeXMLString(document.getElementById("closereason").value)
						   },
					success	:	function(result) {
						var resultXML = loadXMLString(result);
						
						if (CrossYN()) {
						    rtnValue = SelectNodes(resultXML, "/RETURN/VALUE").item(0).textContent;
						} else {
						    var commNodes = new ActiveXObject("Microsoft.XMLDOM");
						    commNodes = resultXML.documentElement.childNodes;
						    rtnValue = commNodes.item(0).text;
						}
						
						if( rtnValue == "SuccessApplication" ) {
							alert("<spring:message code = 'ezCommunity.t470' />");
							manager_onclick( code );
						} else if( rtnValue == "NotExistCompany" ) {
							alert("<spring:message code = 'ezCommunity.t471' />");
							manager_onclick( code );
						} else if( rtnValue == "NotExistCommunity" ) {
							alert("<spring:message code = 'ezCommunity.t472' />");
							manager_onclick( code );
						} else if( rtnValue == "ExistApplication" ) {
							alert("<spring:message code = 'ezCommunity.t473' />");
							manager_onclick( code );
						} else {
						    alert("<spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t474' />");
							manager_onclick( code );
						}
					}
						   
				});
			}
			
			function ConvMakeXMLString(str) {
				str = ReplaceText(str, "&amp;","&");
				str = ReplaceText(str, "&lt;", "<");
				str = ReplaceText(str, "&gt;", ">");
				return str;
			}
	
			function closecancel_onclick() {
			    document.getElementById("closereason").value = "";
			}
	
			function manager_onclick( code ) {
				window.document.location.href="/ezCommunity/adminCommClose.do?code=" + code;
			}
		</script>
	</head>
	<body>
		<h1><spring:message code = 'ezCommunity.t1529' /> <spring:message code = 'ezCommunity.t475' /></h1>
		<br>
		<br>
		<table class="content">
			<tr>
			    <th><spring:message code = 'ezCommunity.t9' /></th>
			    <td><c:out value = '${sysopName}' /></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezCommunity.t1529' /><spring:message code = 'ezCommunity.t476' /></th>
			    
			    <c:choose>
			    	<c:when test="${userInfo.lang == '2' }">
			    		<td><c:out value = '${club.c_ClubName2}' /></td>
			    	</c:when>
			    	
			    	<c:otherwise>
			    		<td><c:out value = '${club.c_ClubName}' /></td>
			    	</c:otherwise>
			    </c:choose>
			    
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezCommunity.t477' /></th>
			    <td><c:out value = '${club.c_MemberCnt}' /><spring:message code = 'ezCommunity.t478' /></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezCommunity.t11' /></th>
			    <td><c:out value = '${strCategoryPrint}' /></td>
		  	</tr>
		  	<tr>
			    <th><spring:message code = 'ezCommunity.t15' /></th>
			    <td>
				    <c:choose>
				    	<c:when test="${club.c_ClubGubun == '2' && club.c_ClubConfirmType == '2' }">
				    		<spring:message code = 'ezCommunity.t479' />
				    	</c:when>
				    	<c:when test="${club.c_ClubGubun == '2' && club.c_ClubConfirmType == '3' }">
				    		<spring:message code = 'ezCommunity.t480' />
				    	</c:when>
				    	<c:when test="${club.c_ClubGubun == '3' && club.c_ClubConfirmType == '2' }">
				    		<spring:message code = 'ezCommunity.t481' />
				    	</c:when>
				    	<c:when test="${club.c_ClubGubun == '3' && club.c_ClubConfirmType == '3' }">
				    		<spring:message code = 'ezCommunity.t482' />
				    	</c:when>
				    </c:choose>
		    	</td>
		  	</tr>
		  	<tr>
		    	<th colspan="2"><spring:message code = 'ezCommunity.t71' /></th>
		  	</tr>
		  	<tr>
		    	<td colspan="2"><textarea name="textarea" style="width: 100%;box-sizing:border-box;-moz-box-sizing:border-box;height:80px" id="closereason"></textarea>
		    	</td>
		  	</tr>
		</table>
		
		<div class="btnposition">
			<a class="imgbtn" name="Submit"  id="closeok" onClick="return closeok_onclick('${code}')"><span><spring:message code = 'ezCommunity.t245' /></span></a>
			<a class="imgbtn" name="Submit2" id="closecancel" onClick="return closecancel_onclick()" ><span><spring:message code = 'ezCommunity.t246' /></span></a>
			<a class="imgbtn" name="Submit3" onclick="parent.parent.window.close()"><span><spring:message code = 'ezCommunity.t21' /></span></a>
		</div>
	</body>
</html>