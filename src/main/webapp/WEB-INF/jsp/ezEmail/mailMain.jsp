<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1">
		
		<script type="text/javascript">
		    var reloadRetryCount = 1;
		</script>
	</head>
	<frameset rows="0,*" frameborder="0" border="0">
		<frame src="about:blank" name="white" marginwidth="0" marginheight="0" scrolling="no" frameborder="0">
		    <frameset cols="200,*" frameborder="0" border="0">
	            
	            <c:choose>
	            	<c:when test="${funCode eq '2'}">
			    		<frame src="/ezEmail/mailLeft.do?funCode=2" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" resize>
			        	<frame name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
	            	</c:when>
	            	<c:otherwise>
			    		<frame src="/ezEmail/mailLeft.do?funCode=1" name="left" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0" resize>
			        	<frame src="/ezEmail/mailList.do" name="right" marginwidth="0" marginheight="0" scrolling="auto" frameborder="0">
	            	</c:otherwise>
	            </c:choose>
		    
		    </frameset>
    </frameset>
</html>