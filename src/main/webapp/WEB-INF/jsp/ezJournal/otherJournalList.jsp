<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezJournal.t203'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<style type="text/css">
			#divList #otherJournalList tr:not(.selectTR):hover{
				background-color: rgb(244,245,245);
			}
			.selectTR{
				background-color: #f1f8ff;
			}
		</style>
		<script type="text/javascript">
			var journalId="";
		    function close_onclick() {
		    	parent.DivPopUpHidden();
		    }
		    
		    function bindOtherJournal(){
// 		    	var journalId = $("input[type='radio'][name='otherJournalRadio']:checked").val();
		    	if(journalId){
			    	parent.getOtherJournal(journalId);
		    	} else {
		    		alert("<spring:message code='ezJournal.t148'/>");
		    	}
		    }
		    
		    function selectedTR(elem){
		    	$("#otherJournalList tr").removeClass("selectTR");
	   			$(elem).addClass("selectTR");
	   			journalId = $(elem).attr("journalId");
		    }
		</script>
	</head>
	<body class="popup">
		<form method="post" >
		  <h1><spring:message code='ezJournal.t75'/></h1>
		  <div id="close">
		  	<ul>		      
		  		<li onClick="close_onclick()"><span></span></li>
		    </ul>
		  </div>
	      <div style="width:100%; height:290px; overflow: auto;" id="divList">
	            <table class="mainlist" id="otherJournalList" style="width: 100%; border: 1px solid #ddd !important; border-top: none;">
	            <c:choose>
		            <c:when test="${fn:length(journalList) ne 0 }">
			            <c:forEach items="${journalList }" var="journal" varStatus="status">
							<tr style="cursor:pointer;" journalId="${journal.journalId }" onclick="selectedTR(this);" ondblclick="bindOtherJournal();">
<!-- 								<td style="width:13px; text-align: center; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;"> -->
<%-- 								<input type="radio" value="${journal.journalId }" name="otherJournalRadio" style="width: 13px; height: 13px; padding : 0px; margin : 0px; vertical-align: middle"></td> --%>
								<td align="left" style="width: 300px; text-align: left;"><c:out value='${journal.journalTitle }'/></td>
<!-- 								<td align="left" -->
<%-- 									style="width: 130px; text-align: center; cursor: pointer;">${journal.formName }</td> --%>
								<td align="left" style="width: 130px; text-align: left;"><c:out value='${journal.journalDate }'/></td>
							</tr>
			            </c:forEach>
		            </c:when>
		            <c:otherwise>
		            	<tr style="background-color: rgb(255, 255, 255);">
							<td align="left" colspan="3" style="width: 130px; text-align: center;"><spring:message code='ezJournal.t147'/></td>
						</tr>
		            </c:otherwise>
	            </c:choose>
				</table>
	        </div>
	        <div class="btnpositionNew">
		        <a class="imgbtn"><span onclick="bindOtherJournal()"><spring:message code='ezJournal.t86' /> </span></a>
		    </div>
	        <!-- <div id='runtime' style="color:#666;padding-top:5px"></div> -->
		</form>
	</body>
</html>