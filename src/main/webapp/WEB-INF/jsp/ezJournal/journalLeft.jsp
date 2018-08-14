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
	    <style>
	    	#left ul li.on{
				font-weight:bold;
				color:black;
			}
			 #left ul li.ing{
				font-weight:normal;
				color:#9b9b9b;
			}
	    </style>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript">
	  		document.onselectstart = function () { return false; };
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
						    <li listType='department' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><span style="width:100%;display:inline-block;">
		    				<c:choose>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t05'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon01.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t06'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon02.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t07'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon03.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t08'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon04.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t09'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon05.png"/>
		    					</c:when>
		    					<c:otherwise>
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon06.png"/>
		    					</c:otherwise>
		    				</c:choose>
		    				<span style="display:inline-block; padding-top: 4px; padding-bottom: 1px;"><spring:message code="${type.journaltypeId}"/></span></span></li>
		    			</c:forEach>
		    		</c:when>
		    	</c:choose>
		    </ul>
		    <h2><span listType='mine' onClick="goJournalList(this);" typeId='${typeList[0].journaltypeId }' style="width:100%; display:inline-block;"><spring:message code='ezJournal.t50'/></span></h2>
		    <ul id="iconul">
		    	<c:choose>
		    		<c:when test="${not empty typeList }">
		    			<c:forEach items="${typeList }" var="type">
						    <li listType='mine' typeId='${type.journaltypeId }' onClick="goJournalList(this);"><span style="width:100%; display:inline-block;">
						    <c:choose>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t05'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon01.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t06'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon02.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t07'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon03.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t08'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon04.png"/>
		    					</c:when>
		    					<c:when test="${type.journaltypeId eq 'ezJournal.t09'}">
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon05.png"/>
		    					</c:when>
		    					<c:otherwise>
		    						<img style="vertical-align:top;" class="icon" src="/images/ImgIcon/journal_icon06.png"/>
		    					</c:otherwise>
		    				</c:choose>
						    <span style="display:inline-block; padding-top: 4px; padding-bottom: 1px;"><spring:message code="${type.journaltypeId}"/></span></span></li>
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