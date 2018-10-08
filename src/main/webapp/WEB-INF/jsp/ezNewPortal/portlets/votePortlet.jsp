<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Vote Portlet</title>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/string_component.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/functionLib.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPortal/showModalDialog.js')}" ></script>
<script type="text/javascript">
var pollAnswer = '${pollAnswer}';
var pollAnswerCount = "<c:out value='${pollAnswerCount}'/>";
var voteCount = "<c:out value='${voteCount}'/>";
var qstId = "<c:out value='${qstId}'/>";

$(function() {	
	if (voteCount !== "0") {
		pollAnswer = JSON.parse(pollAnswer);
		
		var answerLength = pollAnswer.length;
		
		if (answerLength > 4) {
			answerLength = 4;
		}

		$(".layDiv").append("<p class='voteTitle'>\"<c:out value="${title }"/>\"</p>");
		$(".layDiv").append("<p class='voteBtn'>참여</p>");
		
		$(".layDiv").append("<ul class='voteList'>");
		
		for (var i = 0; i < answerLength; i++) {
			var poll = pollAnswer[i];
			var answerPercent = 0;
			
			if (pollAnswerCount !== "0") {
				answerPercent = Math.round((poll.votesNumber / pollAnswerCount) * 100);
			}
			
			var strHTML = "";
			strHTML += "<li class='voteList_0" + (i + 1) + "'>";
			strHTML += "<div class='voteT'>";
			strHTML += "<span class='Vnum'>" + (i + 1) + "</span>";
			strHTML += "<span class='Vtext'>" + poll.content + "</span>";
			strHTML += "</div>";
			strHTML += "<div class='percent' id='percent" + (i + 1) + "'>"+ answerPercent + "%</div>";
			strHTML += "<div class='voteGraph' id='divGraph" + (i + 1) + "'>";
			strHTML += " <span id='graph" + (i + 1) + "' style='width :" + answerPercent  + "%'></span>";
			strHTML += "</div></li></ul>";
			
			$(".voteList").append(strHTML);
		}

		$(".layDiv").append("</ul>");
	} else {
		var strHTML = "";
		strHTML += "<ul class='portlet_list'>";
		strHTML += "<dl class='nodata'>";
		strHTML += "<dt><img src='/images/ezNewPortal/nodata.png'></dt>";
		strHTML += "<dd>\"<spring:message code='main.t00026' />\"</dd>";
		strHTML += "</dl></ul>";

		$(".layDiv").append(strHTML);
	}
	
	eventSetting();
});

function viewQstList() {
	window.open("/ezBoard/boardMain.do?func=3","main");		    	
}

function votePoll() {
	$.ajax({
		type : "POST",
		dataType : "text",
		async : true,
		url : "/ezPoll/checkPoll.do",
		data : {
			qstId : qstId
		},
		success: function(data) {		    			
			var result = JSON.parse(data).result;					
			
			if (result == "Normal") {
				window.open("/ezBoard/boardMain.do?func=3&qstId=" + qstId, "main");
			}
			else {
				alert("투표를 수정하고 있습니다.기다려주세요.");
				window.location.reload();
			}
        },
        error: function(error) {
        	alert(error);
        }
	});
    
}

function eventSetting() {
	$("#votePlus").on("click", viewQstList);
	$(".voteBtn").on("click", votePoll);
}
</script>
</head>
<body>
<div class="layDiv">
	<dl class="portlet_title">
		<dt class="portletText"><c:out value="${portletName }"/> (<c:out value='${voteCount }'/>)</dt>
		<dd class="portletPlus" id="votePlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
	</dl>
</div>
</body>
</html>