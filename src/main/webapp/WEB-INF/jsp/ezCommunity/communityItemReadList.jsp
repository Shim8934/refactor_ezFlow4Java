<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCommunity.t952' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="<spring:message code='ezCommunity.i1'/>">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		
		<script type="text/javascript">
			function show_info(userid) {
	            window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", GetOpenWindowfeature(438, 440));
	        }
		</script>
	</head>
	<body class = "popup">
		<form method="post">
			<h1><spring:message code='ezCommunity.t952' /></h1>
		    <div id="close">
		        <ul>
		            <li><span onclick="window.close()"><spring:message code='ezCommunity.t21' /></span></li>
		        </ul>
		    </div>
		    
	        <script type="text/javascript">
	            selToggleList(document.getElementById("close"), "ul", "li", "0");
	        </script>
	        
	        <h2><spring:message code='ezCommunity.t1053' /></h2>
	        
	        <div class="box" style="height: 290px; overflow: auto">
        	    <table style="width:100%" class="popuplist">
        	    	<c:forEach items="${readList}" var="item">
        	    		<c:choose>
        	    			<c:when test="${userInfo.primary=='1' }">
        	    				<tr>
			        	   			<td style="white-space:nowrap">[<c:out value = '${item.readDate}' />]</td>
				                    <td style="cursor: pointer;white-space:nowrap" onclick="show_info('${item.userID}');"><font color="black"><b><c:out value = '${item.userName}' /></b>(<c:out value = '${item.userID}' />)</font></td>
				                    <td style="white-space:nowrap"><font color="#168501"><c:out value = '${item.userDeptName}' /></font></td>
				                    <td style="width:100%;white-space:nowrap;"><font color="#737373"><c:out value = '${item.userTitle}' /></font></td>
				                </tr>
        	    			</c:when>
        	    			<c:otherwise>
        	    				<tr>
			        	   			<td style="white-space:nowrap">[<c:out value = '${item.readDate}' />]</td>
				                    <td style="cursor: pointer;white-space:nowrap" onclick="show_info('${item.userID}');"><font color="black"><b><c:out value = '${item.userName2}' /></b>(<c:out value = '${item.userID}' />)</font></td>
				                    <td style="white-space:nowrap"><font color="#168501"><c:out value = '${item.userDeptName2}' /></font></td>
				                    <td style="width:100%;white-space:nowrap;"><font color="#737373"><c:out value = '${item.userTitle2}' /></font></td>
				                </tr>
        	    			</c:otherwise>
        	    		</c:choose>
        	    	</c:forEach>

	            </table>
	        </div>
		</form>	
	</body>
</html>