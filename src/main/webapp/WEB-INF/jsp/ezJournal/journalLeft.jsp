<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <link rel="stylesheet" href="<spring:message code='ezJournal.c1' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript">
	        window.onload = function () {
	        	$("#fmenu").click();
	        }
	        
	        function goJournalList(elem) {
				var url = "/ezJournal/journalListMain.do";
				
				var listType = $(elem).attr("listType");
				url = url + "?listType=" + listType;
				var typeId = $(elem).attr("typeId");
				if(typeId&&typeId!=undefined){
					url=url+"&typeId="+typeId;
				}
				window.open(url,"right");
				setRecvCount();
			}
	        
	        function setRecvCount() {
        		$.ajax({
	   				type:"post",
	   				url:"/ezJournal/leftRecvCount.do",
	   				success: function(data){
	   					if(data != 0){
		   					$("#recvCount").text("(" + data + ")");
	   					}else{
		   					$("#recvCount").text("");
	   					}
	   				}
	   			});
	        }
	        
	        function journalConfig() {
	        	window.parent.frames["right"].location.href = "/ezJournal/journalConfig.do";
	        	setRecvCount();
	        }
	        
	    </script>
	</head>
	<body class="leftbody">
	    <div id="left">
	        <div class="left_circular" title="<spring:message code='ezJournal.t1'/>">
	        	<span><spring:message code='ezJournal.t1'/></span>
	        </div>
		    <h2><span listType='department' id="fmenu" onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%;display:inline-block;"><spring:message code='ezJournal.t49'/></span></h2>
		    <ul id="iconul">
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li listType='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);" ><span style="width:100%;display:inline-block;"><img style="width:16px;height:16px;" class="icon" src="/images/ImgIcon/icon_partapproval.gif"/><spring:message code="${type.journaltypeId}"/></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span listType='mine' onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%; display:inline-block;"><spring:message code='ezJournal.t50'/></span></h2>
		    <ul id="iconul">
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li listType='mine' typeId='${type.journaltypeId }' onClick="goJournalList(this);" ><span style="width:100%; display:inline-block;"><img style="width:16px;height:16px;" class="icon" src="/images/ImgIcon/icon_partapproval.gif"/><spring:message code="${type.journaltypeId}"/></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span listType='recv' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t51'/><c:if test="${recvCount ne 0 }"><span id="recvCount">(${recvCount })</span></c:if></span></h2>
		    <ul>
		    </ul>
		    <h2><span listType='temp' onClick="goJournalList(this);" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t52'/></span></h2>
		    <ul>
		    </ul>
	        <h3><span listType='journalEnv' onClick="journalConfig()" style="width:100%;display:inline-block;"><spring:message code='ezJournal.t53'/></span></h3>
		</div>		
	    <script type="text/javascript">
		    initToggleList(document.getElementById("left"), "h2", "ul", "li");
	    </script>
	    
	</body>
</html>