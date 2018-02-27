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
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        window.onload = function () {
	        	
	        }
	        
	        function goJournalList(elem) {
				var url = "";
				switch(idx) {
					case 1:
						url = "/admin/ezJournal/formType.do";
						break;
					
					case 2:
						url = "/admin/ezJournal/form.do";
						break;
						
					case 3:
						url = "/admin/ezJournal/author.do";
						break;
						
				}
				window.open(url,"right");
			}
	        
	        function writejournal() {
	        //	var feature = GetOpenWindowfeature(820, 880).replace("resizable=no","resizable=yes"); 
				var feature = GetOpenPosition(820, 850);
	        	var typeId = "ezJournal.t05";
	            var Openwin = window.open("/ezJournal/journalNewItem.do?typeId=" + typeId + "&mode=new", "", "width=820, height=850, status=no, toolbar=no, menubar=no, location=no, resizable=1" + feature);
	        	Openwin.focus();
	        }

	    </script>
	</head>
	<body class="leftbody">
        <div class="left_pims" title="<spring:message code='ezJournal.t1'/>"></div>
	        
	    <div id="left">
		    <h2><span class='department' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t49'/></span></h2>
		    <ul>
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li><span class='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code="${type.journaltypeId}"/></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span class='mine' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t50'/></span></h2>
		    <ul>
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li><span class='mine' typeId='${type.journaltypeId }' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code="${type.journaltypeId}"/></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span class='recive' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t51'/></span></h2>
		    <ul>
		    </ul>
		    <h2><span class='temp' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t52'/></span></h2>
		    <ul>
		    </ul>
		    <h2><span class='write' onClick="writejournal();" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t57'/></span></h2>
		    <ul>
		    </ul>
	        <h3><span class='recive'='journalEnv' onClick="" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t53'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
		    $(".on").attr("class", "off");
	    </script>
	    
	</body>
</html>