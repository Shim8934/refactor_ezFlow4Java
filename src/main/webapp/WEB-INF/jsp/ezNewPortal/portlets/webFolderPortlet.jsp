<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<article class="webFolder_portlet box_shadow">
    <div class="layDIV">
        <dl class="portlet_title">
            <dt class="portletText"><c:out value="">개인웹폴더</c:out></dt>
            <dd class="portletPlus">
            	<img src="/images/ezNewPortal/portlet_Plus.png">
            </dd>
            <dd class="mailGraph" id="mailGraph">
            	<p class="mGraph">
            		<span id="mGraphSpan" style="width: 5px;"></span>
            	</p>
           		<span class="mGraph_text" id="UseMailBox">2.0K
           			<span>/2G</span>
           		</span>
            </dd>
        </dl>
        <%-- 
        <c:choose>
        	<c:when test="">
        	
        	</c:when>
        	<c:otherwise>
        	
        	</c:otherwise>
        </c:choose>
         --%>
        <ul class="webFolder">
        	<dl class="nodata">
				<dt>
					<img src="/images/kr/main/noData_sIcon.png">
				</dt>
				<dd>"<spring:message code='ezNewPortal.t018' />"</dd>
			</dl>
        </ul>
    </div>    
</article>
<script type="text/javascript">
$(function() {
	
});
</script>
</body>
</html>