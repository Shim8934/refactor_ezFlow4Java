<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="width:100%;">
	<head>
		<title><spring:message code="ezQuestion.t270" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<link rel="stylesheet" href="/css/ezPoll/sort.css" type="text/css">	
		
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezPoll/stomp.min.js"></script>
		<script type="text/javascript" src="/js/ezPoll/sockjs.min.js"></script>
		<script type="text/javascript" src="<spring:message code='ezQuestion.e1' />"></script>
		<script type="text/javascript" src="/js/ezPoll/page_render.js"></script>	
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<style>
			#QstList{
				padding : 5px;
			}
		</style>
		
		<script type="text/javascript">		 	
			var currentPage		  = ${currPage};  		
			var totalPages 		  = ${totalPages}; 		
		    var totalQuestions 	  = ${totalQuestions};  
		    var blockSize 		  = 10;
		    var status_processing = "<spring:message code = 'ezPoll.t101' />";
		    var status_finish 	  = "<spring:message code = 'ezPoll.t102' />";		   
			var brdID			  = ${brdID};	
			var searchParam	  	  = "<c:out value='${strSearch}'/>";
			var userID 			  = "<c:out value='${userID}'/>";
			var seeCheck 		  = "<c:out value='${seeCheck}'/>";	
			var deleteBttn 		  = "<c:out value='${deleteBttn}'/>";
			var hideBttn 		  = "<c:out value='${hideBttn}'/>";
			var checkedArr		  = [];					
			var chkDelete		  = 0;
			var tenantId		  =  "<c:out value='${tenantID}'/>";
			var admin 			  = "<c:out value='${adminPrivilege}'/>";	
			var stompClient 	  = null;
		    
		    window.onunload = function() {
    		    if (stompClient !== null) {
    		        stompClient.disconnect();
    		    }
        	}; 
		   
			window.onload = function() {				
				preProcessing();				
				makePageSelPage(currentPage, totalPages, totalQuestions, blockSize);
				getConnect();
			}		
			
			function getConnect() {
			    var socket = new SockJS('/ezFlow/hello');
			    stompClient = Stomp.over(socket);
			    stompClient.connect({}, function (frame) {
			        stompClient.subscribe('/reply/qstDeleteForTenant' + tenantId, function (updatedInfo) {			       
			        	var ret = JSON.parse(updatedInfo.body).result;	
						if (ret == "DELETED"){
							//reload page
							document.location.href = "/ezPoll/pollList.do?brdID=6";
						}
				    });
			    });
			}
			
			function preProcessing() {
				//Uncheck all checkboxes after reload for firefox
		    	$(':checkbox:checked').removeAttr('checked');    	
				
				if (seeCheck == 1) {
					$('#seeAll').prop('checked', true);
				}
				if (deleteBttn == 1 || admin == 1) {
					$('#btnDel').show();
				}
				else {
					$('#btnDel').hide();
				}
				if (hideBttn == 1) {
					$('#btnHid').show();
				}
				else {
					$('#btnHid').hide();
				}
				
				document.getElementById("searchInput").value = searchParam;
			}
		    
		    function menuQst_DetailUserInfo(pUserID) {
		    	 var feature = GetOpenPosition(420, 438);
		         window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }	
		    
		    function menu_Search() {
		    	var checkSeeAll = 0;
		    	var search_str = "";
		    	
		    	if ($('#seeAll').is(':checked')) {
		    		checkSeeAll = 1;
		    	}	
		    	
		    	if (document.getElementById("searchInput").value != null) {
		    		search_str = document.getElementById("searchInput").value;
		    	}
		    	
		        var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + "&search=" + search_str + "&see=" + checkSeeAll;
		        window.location.href = szUrl;
		    }
		    
		    function getChecked(t) {			    	
		    	if ($(t).is(':checked')) {    				    		
		    		checkedArr.push($(t).val());
		    		var creator = "creator" + $(t).val();
		    		
					if (document.getElementById(creator).value != userID && admin == 0) {
						chkDelete = 1;
					}		    		
		    	}
		    	else {
		    		var test = checkedArr.indexOf($(t).val());
		    		
		    		if (test != -1) {
		    			checkedArr.splice(test, 1);
		    		}
		    	}
		    }
		    
		    function menu_Hide() {
		    	if (checkedArr.length == 0) {
		            alert('<spring:message code="ezQuestion.t294" />');
		            return;
		    	}
		    	
		    	var checkedList = checkedArr[0];
		    	
	    		for (var i = 1; i < checkedArr.length; i++) {
	    			checkedList = checkedList + "," + checkedArr[i];	    			
	    		}
	    		
	    		var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + "&hide=" + checkedList;   		
	    		window.location.href = szUrl;
		    }
		    
		    function menu_Show() {
		    	var checkSeeAll = 0;
		    	
		    	if ($('#seeAll').is(':checked')) {
		    		checkSeeAll = 1;
		    	}
		    	
		    	var szUrl = "/ezPoll/pollList.do?brdID=" + brdID + "&see=" + checkSeeAll;
		    	window.location.href = szUrl;
		    }
		    
		    function menu_Delete() {
		    	if (checkedArr.length == 0) {
		            alert('<spring:message code="ezQuestion.t294"/>');
		            return;
		    	}
		    	
		    	if (chkDelete == 1) {
		            alert('<spring:message code="ezPoll.t141"/>');
		            return;
		    	}	
		    	
	    		var feature = GetOpenPosition(420, 438);
		    	var checkedList = checkedArr[0];
		    	var id = "tlt" + checkedArr[0];		
		    	var qstTitleList = document.getElementById(id).innerHTML;
		    	
	    		for (var i = 1; i < checkedArr.length; i++) {	    			
	    			checkedList = checkedList + "," + checkedArr[i];
	    			qstTitleList = qstTitleList + "," + document.getElementById("tlt" + checkedArr[i]).innerHTML;
	    		}
		    	
		    	//Checking if some one is modifying this vote
		    	var listModifyingQst = ${listOfModifyingQst};
		    	
		    	if (listModifyingQst.length > 0) {
		    		var flag = 0;
		    		
		    		for (var j = 0; j < checkedArr.length; j++) {
				    	for (var i = 0; i < listModifyingQst.length; i++) {
				    		if (listModifyingQst[i] == checkedArr[j]) {
								flag = 1;
								break;
				    		}
				    	}
		    		}
		    		
			    	if (flag == 1) {
			    		alert('<spring:message code="ezPoll.t142"/>');
			    		document.location.href = "/ezPoll/pollList.do?brdID=6";			    		
			    	}    
			    	else {
				        var w = window.open("/ezPoll/confirmDeleteQuestion.do?brdID=" + brdID + "&listQst=" + checkedList + "&listQstContent=" + qstTitleList, "", "height=300px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				        w.focus();
			    	}
		    	}	
		    	else {
			        var w = window.open("/ezPoll/confirmDeleteQuestion.do?brdID=" + brdID + "&listQst=" + checkedList + "&listQstContent=" + qstTitleList, "", "height=300px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			        w.focus();
		    	}
		    }
		    
		    function popupClosing() {    	
		    	document.location.href = "/ezPoll/pollList.do?brdID=6";
		    }
		    
		    function title_OnClick(pReceve) {
		    	var listModifyingQst = ${listOfModifyingQst};
		    	
		    	if (listModifyingQst.length > 0) {
		    		var flag = 0;
		    		
			    	for (var i = 0; i < listModifyingQst.length; i++) {
			    		if (listModifyingQst[i] == pReceve) {
							flag = 1;
							break;
			    		}
			    	}
			    	
			    	if (flag == 1) {
			    		alert('<spring:message code="ezPoll.t143"/>');
			    		document.location.href = "/ezPoll/pollList.do?brdID=6";		    		
			    	}
			    	else {
			    		document.location.href = "/ezPoll/pollVote.do?qstId=" + pReceve;
			    	}	    						    			   			
		    	}
		    	else {
		    		document.location.href = "/ezPoll/pollVote.do?qstId=" + pReceve;
		    	}		    			    		        
		    }
		    
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezPoll.t103"/><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu1">
			<ul>
				<li>
					<input type="text" name="searchInput" id="searchInput" placeholder="<spring:message code="ezPoll.t144"/>" >
					<a class="imgbtn" onClick="menu_Search()" style="margin-top: 3px;"><span><spring:message code="ezQuestion.t34"/></span></a>
				</li>
				<li id="btnDel"><a class="imgbtn" onClick="menu_Delete()" style="margin-top: 3px;"><span ><spring:message code="ezPoll.t202"/></span></a></li>
				<li id="btnHid"><a class="imgbtn" onClick="menu_Hide()"   style="margin-top: 3px;"><span ><spring:message code="ezPoll.t203"/></span></a></li>
				<li><a class="imgbtn" onClick="menu_Show()"   style="margin-top: 3px;"><span ><spring:message code="ezPoll.t204"/></span></a></li>				
				<li><input id="seeAll" type="checkbox" style="float:left;"><span><spring:message code="ezPoll.t205" /></span></li>
			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu1"), "ul", "li", "0");
		</script>	
			 
		<form method="post">
			<table id="QstList" class="mainlist1" style="width:100%"> 
			    <tr> 
					<th width="30px" align="center"> <spring:message code="ezPoll.t105"/></th> 
					<th><spring:message code="ezPoll.t106"/></th> 
					<th width="60px"><spring:message code="ezPoll.t104"/></th> 
					<th width="90px"><spring:message code="ezPoll.t107"/></th> 
					<th width="60px"><spring:message code="ezPoll.t108"/></th>
					<th width="80px"><spring:message code="ezPoll.t201"/></th> 
					<th width="60px"><spring:message code="ezPoll.t109"/></th>			
			    </tr>
			 	<c:forEach var="list" items="${list}"> 
			        <tr id="${list.qstId}" class="white">

			        	<td style="padding:0"> <input type="checkbox" id="qstCheck+<c:out value ="${list.qstId}" />+" value=<c:out value="${list.qstId}"/>  onchange="javascript:getChecked(this)"></td> 
			          	<td id="tlt<c:out value ="${list.qstId}" />" style="overflow: hidden; cursor: pointer; text-overflow: ellipsis;" title=<c:out value ="${list.title}"/> onClick="title_OnClick('<c:out value ="${list.qstId}"/>')" ><c:out value ="${list.title}"/></td>
			          	
			          	<%-- Question status --%>
						<c:if test="${list.status == 0}">
							<td><spring:message code="ezPoll.t145"/></td>
						</c:if>
						<c:if test="${list.status != 0}">
							<td><spring:message code="ezPoll.t146"/></td>
						</c:if>
						
			          	<%-- Creator --%>
			          	<td> <a id="test<c:out value ="${list.qstId}" />" style="cursor:pointer" onClick="menuQst_DetailUserInfo('${list.creator}')"> ${list.creatorName} </a> </td>
			          	
			          	<%-- CreatorID --%>
			          	<td style="display:none"><input type="text" id="creator<c:out value ="${list.qstId}" />" value=<c:out value="${list.creator}"/> style="display:none"> </td>
			          	
			          	<%-- Target --%>
			          	<c:if test="${list.target == 0}">
			          		<td><spring:message code = 'ezQuestion.t251'/></td>	
			          	</c:if>
			          	<c:if test="${list.target == 1}">
			          		<td><spring:message code = 'ezQuestion.t252'/></td>	
			          	</c:if> 
			          	
			          	<%-- End date--%>
			          	<c:set var="pollEndDate" value="${list.endDate}"/>
			          	<td> ${fn:substring(pollEndDate,0,10) } </td>			          	
			          	
			          	<%-- Secret setting --%>
			          	<c:if test="${list.secretVote == 0}">
			          		<td><spring:message code = 'ezQuestion.t238'/></td>	
			          	</c:if>
			          	<c:if test="${list.secretVote == 1}">
			          		<td><spring:message code = 'ezQuestion.t239'/></td>	
			          	</c:if>
			          	
			          	<c:choose>
							<c:when test="${list.isHidden == 1}">
							    	<script>
										var id = ${list.qstId};
										var id2 = "test" + ${list.qstId};										
										document.getElementById(id2).style.color="red";
										document.getElementById(id).style.color="red";
									</script>
							</c:when>
							<c:otherwise>
							    <c:if test="${list.status == 0}">
									<script>
										var id = ${list.qstId};
										var id2 = "test" + ${list.qstId};										
										document.getElementById(id2).style.color="blue";
										document.getElementById(id).style.color="blue";
									</script>
								</c:if>
							</c:otherwise>
						</c:choose>
			        </tr>
		        </c:forEach>
		        
			    <c:if test="${list.size() == 0}"> 
			        <tr> 
						<td colspan="7" align="center" height="30" bgcolor="#FFFFFF"> <spring:message code="ezQuestion.t312" /></td> 
		       		</tr> 
		        </c:if> 
			</table> 
			<div style="display:none">
				<input type="text" name="hiddenSeeAll" id="hiddenSeeAll" value="" style="display:none">
			</div>
		</form>
		 
		<div id="tblPageRayer"></div>
	</body>
</html>