<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <link rel="stylesheet" href="<spring:message code='ezCircular.c1' />" type="text/css">

	    <script type="text/javascript">
	        window.onload = function () {
	        	$(".department:first").click();
	        }
	        
	        function goJournalList(elem) {
				var url = "/ezJournal/journalListMain.do";
				
				var listType = $(elem).attr("class");
				url=url+"?listType="+listType;
				var typeId = $(elem).attr("typeId");
				if(typeId&&typeId!=undefined){
					url=url+"&typeId="+typeId;
				}
				window.open(url,"right");
			}

	    </script>
	</head>
	<body class="leftbody">
        <div class="left_pims" title="<spring:message code='ezJournal.t1'/>"></div>
	        
	    <div id="left">
		    <h2><span class='department' onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%;display:inline-block;"><spring:message code='ezJournal.t49'/></span></h2>
		    <ul>
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li><span class='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code="${type.journaltypeId}"/></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span class='mine' onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%;display:inline-block;"><spring:message code='ezJournal.t50'/></span></h2>
		    <ul>
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li><span class='mine' typeId='${type.journaltypeId }' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code="${type.journaltypeId}"/></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span class='recv' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t51'/>(${recvCount })</span></h2>
		    <ul>
		    </ul>
		    <h2><span class='temp' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t52'/></span></h2>
		    <ul>
		    </ul>
	        <h3><span class='journalEnv' onClick="" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t53'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    
	</body>
</html>