<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPMS/default/style.css')}" type="text/css" />
<link rel="stylesheet" href="${util.addVer('/css/ezPoll/vote.css')}" type="text/css" />

<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/common.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/ezPMS/jstree.js')}"></script>
<script>
	var CurrentHeight = document.documentElement.clientHeight - 100;

	//버튼 중복클릭 방지
	var doubleSubmitFlag = false;
	
	var contentCount = '<c:out value="${totalCount}"/>';
	var taskName = '<c:out value="${taskName}"/>';
	
	function addComment() {
		
		if (doubleSubmitFlag) {
    		return;
    	}
		
		doubleSubmitFlag = true;
		
		var commentContent = $("#comment_input").val().trim();
		
		if (commentContent == "") {
			alert("<spring:message code='ezPMS.t222' />");
			return;
		}
		
		var data = {
			groupId : groupId,
			taskId : taskId,
			commentContent : commentContent
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/addComment.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if(result.data == 'success') {
					doubleSubmitFlag = false;
					currentPage = 1;
					
					// 검색 후 새 글을 등록했을 때 검색 조건을 초기화한다.
					searchByUser = "";
					searchByStartDate = "";
					searchByEndDate = "";
					searchByContent = "";
					
					taskName = $("#taskNameArea").text();
					//taskName = taskName.substring(0, taskName.lastIndexOf('-'));
					
					if (taskName == "") {
						taskName = $("#taskName", parent.document).text();	
					}
					
					var logContent = "<spring:message code='ezPMS.t126' arguments='" + taskName.trim() + "," + commentContent.trim() + "'/>";
					addTaskLog(projectId, 1, groupId, taskId, logContent);

					if(typeof(getTaskTree) !== "undefined"){
						getTaskTree();
					} else {
						location.reload();
					}
				} else {
					alert("<spring:message code='ezPMS.t224' />");
					doubleSubmitFlag = false;
				}	
			},
			error : function() {
				alert("<spring:message code='ezPMS.t224' />");
				doubleSubmitFlag = false;
			}
		});
	}
	
	function deleteComment(elem) {
		if (confirm("<spring:message code='ezPMS.t107' />") == true) {
			var selectedTR = $(elem).parent().parent();
			var commentId = selectedTR.attr("data-commentId");
			var writerId = selectedTR.attr("data-writerId");
			
			var data = {
				commentId : commentId,
				projectId : projectId,
				writerId  : writerId
			}
			
			$.ajax({
				type : "DELETE",
				url : "/ezPMS/deleteComment.do",
				dataType : "json",
				contentType : "application/json; charset=UTF-8",
				data : JSON.stringify(data),
				success : function(result) {
					if (result.data == 'success') {
						
						var content = selectedTR.find("span.originalContent").text();
						var taskName = selectedTR.children("td.taskName").text();
						var groupId = selectedTR.attr("data-groupId");
						var taskId = selectedTR.attr("data-taskId");						
						var logContent = "<spring:message code='ezPMS.t225' arguments='" + taskName.trim() + "," + content.trim() + "'/>";
						
						addTaskLog(projectId, 3, groupId, taskId, logContent);

						if(typeof(getTaskTree) !== "undefined"){
							getTaskTree();
						} else {
							location.reload();
						}
					} else {
						alert("<spring:message code='ezPMS.t108' />");
					}	
				},
				error : function() {
					alert("<spring:message code='ezPMS.t213' />");
				}
			})
		}
	}
	
	function modifyComment(elem) {
		$(".originalContent").css("display", "");
		$(".modifiedContent").css("display", "none");
		$(".modifyBtn").css("display", "");
		
		var contentTD = $(elem).parent().siblings(".content");
		contentTD.children(".originalContent").css("display", "none");
		contentTD.children(".modifiedContent").css("display", "");
		$(elem).siblings(".saveBtn").css("display", "");
	}
	
	function cancelComment(elem) {
		$(".originalContent").css("display", "");
		$(".modifiedContent").css("display", "none");
	}
	
	function saveComment(elem) {
		var selectedTR = $(elem).parents("tr").eq(0);
		var commentId = selectedTR.attr("data-commentId");
		var writerId = selectedTR.attr("data-writerId");
		var commentContent = selectedTR.find(".commentContent").val();
		
		var data = {
			commentId : commentId,
			projectId : projectId,
			writerId  : writerId,
			commentContent : commentContent
		}
		
		$.ajax({
			type : "PUT",
			url : "/ezPMS/modifyComment.do",
			dataType : "json",
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				if (result.data == 'success') {
					
					var content = selectedTR.find("span.originalContent").text();
					var taskName = selectedTR.children("td.taskName").text();
					var groupId = selectedTR.attr("data-groupId");
					var taskId = selectedTR.attr("data-taskId");
					var logContent = "<spring:message code='ezPMS.t226' arguments='" + taskName.trim() + "," + content.trim() + "," + commentContent.trim() + "'/>";
					
					addTaskLog(projectId, 2, groupId, taskId, logContent);

					if(typeof(getTaskTree) !== "undefined"){
						getTaskTree();
					} else {
						location.reload();
					}
				} else {
					alert("<spring:message code='ezPMS.t128' />");
				}	
			},
			error : function() {
				alert("<spring:message code='ezPMS.t228' />");
			}
		})
	}
	
	function auto_grow(element) {
		if (element.value == "") {
			document.getElementById("sendBttn").style.backgroundColor = "#d0d0d0";
			document.getElementById("sendBttn").disabled = true;
		} else {
			document.getElementById("sendBttn").style.backgroundColor = "#0470e4";
			document.getElementById("sendBttn").disabled = false;
		}
	}
	
	function cmtKeyEvent(e) {
		if (e.keyCode == 13) {
			addComment();
		}
	}
	
	$(function() {
		if(typeof setContentTitle != 'undefined') {
			setContentTitle(taskName, contentCount);
		}
		
		document.getElementById("comment_input").focus();
	});
</script>
<div id="divList" style="width: 100%;">
<div id="lvBoardList">
	<table cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" border="0" class="mainlist" style="overflow:hidden">
		<thead id="tableHeader">
			<tr style="height: 37px;" id="BoardList_TH">
				<th class="col1" onclick="setListOrder(this)" data-order='WRITER_NAME' style="text-align:left;"><spring:message code='ezPMS.t114' /></th>
				<th class="col2" style="text-align:left; cursor: default;"><spring:message code='ezPMS.t98' /></th>
				<%-- <th id="col2" onclick="setListOrder(this)" data-order='TASK_NAME' style="text-align:center;"><spring:message code='ezPMS.t98' /></th> --%>
				<th class="col3" onclick="setListOrder(this)" data-order='COMMENT_CONTENT'><spring:message code='ezPMS.t130' /></th>
				<th class="col4" onclick="setListOrder(this)" data-order='WRITE_DATE' style="text-align:left;"><spring:message code='ezPMS.t119' /></th>
				<th class="col5" style="cursor: default; text-align:left;"><spring:message code='ezPMS.t110' />/<spring:message code='ezPMS.t11' /></th>
			</tr>
		</thead>
	</table>
	</div>
	<div id="projectListBody" multiselectable="false" useocs="false" style="overflow:auto; min-width: 469px;">
		<table id="tableBody" cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" rowonclick="ItemPreviewRead_click" rowondblclick="ItemRead_onclick(this)"  width="100%" border="0" class="mainlist" style="">
			<tbody style="background-color: rgb(255, 255, 255);">
			<c:choose>
				<c:when test="${empty data}">
					<tr>
						<td colspan="5" style="text-align : center"> <spring:message code='ezPMS.t30' /> </td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${data}" var="commentVO">
						<tr data-commentId="${commentVO.commentId}" data-groupId="${commentVO.groupId}" 
							data-taskId="${commentVO.taskId}" data-writerId="${commentVO.writerId}">
							<td class="col1" style="text-align:left;">
								<c:out value="${commentVO.writerName}"/>
							</td>
							<td class="taskName col2" style="text-align:left;">
								<c:out value="${commentVO.taskName ne null ? commentVO.taskName : commentVO.groupName}"/>
							</td>
							<td class="content col3" style="text-align: left; line-height:1.5em;">
								<span class="originalContent"><c:out value="${commentVO.commentContent}"/></span>
								<div class="modifiedContent" style="display: none; width: 100%;">
									<textarea class="commentContent" style="resize: none; height: 45px;" maxlength="500"><c:out value="${commentVO.commentContent}"/></textarea>
									<div style="display: inline; float: right;">
										<a class="imgbtn" onclick="saveComment(this)" style="margin-left:2px; margin-top:9px;">
											<span><spring:message code='ezPMS.t265' /></span>
										</a>
										<a class="imgbtn" onclick="cancelComment(this)" style="margin-left:2px; margin-top:9px;">
											<span><spring:message code='ezPMS.t41' /></span>
										</a>
									</div>
								</div>
							</td>
							<td class="col4" style="text-align:left;"><c:out value="${fn:substring(commentVO.writeDate, 0, 16)}"/></td>
							<td class="col5" style="text-align:left;">
								<span onclick="modifyComment(this)" class="modifyBtn" style="cursor: pointer;"><img src="/images/ezPMS/icon_project_modify.png"/></span>&nbsp;&nbsp;&nbsp;
								<span onclick="deleteComment(this)" style="cursor: pointer;"><img src="/images/ezPMS/icon_project_eliminate.png"/></span>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>	
		</tbody>
	</table>	
</div>
</div>

<c:if test="${userRole ne 3}">
	<div id="sendComment" class="voteComment" style="width:100%; border-bottom: 1px solid #dddddd; border-left: none; border-right: none; margin-top: 10px;">
		<div class="sendComment_layout">
			<div class="comment_input_layout" style="border: none; width: 86%;">
				<input id="comment_input" type="text" oninput="auto_grow(this)" maxlength="500" onkeydown="cmtKeyEvent(event)" style="width: 100%;"></input>
			</div>
			<div class="commentBtn">
				<button id="sendBttn" onclick="addComment()" disabled="disabled" style="display:inline-block; width: 96px; cursor:pointer; height:45px; border:none; border-radius:5px; background:#d0d0d0; color:#FFF; margin:0px; padding:0px; text-align: center; vertical-align: middle;"><spring:message code='ezPMS.t40' /></button>						
			</div>
		</div>
	</div>
</c:if>


<c:choose>
<c:when test="${paging.endPage>0 }">
<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
	<div class="pagenavi">   
		<c:choose>
				<c:when test="${paging.currentPage gt 1}">   
					<span onclick="goToPageByNum(1)" class="btnimg first"></span>            
				</c:when>
				<c:otherwise>
					<span class="btnimg first disabled"></span>            
				</c:otherwise>         
		</c:choose>
		<c:choose>
			<c:when test="${paging.startPage gt 1}">
				<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg prev"></span>              
			</c:when>
			<c:otherwise>
				<span class="btnimg prev disabled"></span>              
			</c:otherwise>                                                                    
		</c:choose>
		<%-- <span class="ptxt" onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span> --%>                                   
		<c:forEach begin="0" end="${paging.endPage-paging.startPage }" varStatus="status">
			<c:choose>
				<c:when test="${paging.startPage+status.index eq  paging.currentPage}">
					<span class="on">${paging.currentPage }</span>
				</c:when>
				<c:otherwise>
					<span onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		<%-- <span class="ptxt" onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span> --%>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.endPage }">
				<span class="btnimg next" onclick="goToPageByNum(${paging.endPage+1})"></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg next disabled"></span>
			</c:otherwise>
		</c:choose>
		<c:choose>
			<c:when test="${paging.totalPage gt paging.currentPage }">
				<span class="btnimg last" onclick="goToPageByNum(${paging.totalPage})"></span>
			</c:when>
			<c:otherwise>
				<span class="btnimg last disabled"></span>
			</c:otherwise>
		</c:choose>
	</div>
</div>
</c:when>
<c:otherwise>
<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
	<div class="pagenavi">  
		<span class="btnimg first disabled"></span>
		<span class="btnimg prev disabled"></span>
		<%-- <span class="ptxt"> <spring:message code='ezApproval.t931'/></span> --%>  
		<span class="on">1</span> 
		<%-- <span class="ptxt"><spring:message code='ezApproval.t932'/></span> --%>
		<span class="btnimg next disabled"></span>
		<span class="btnimg last disabled"></span>
	</div>
</div>
</c:otherwise>
</c:choose>
