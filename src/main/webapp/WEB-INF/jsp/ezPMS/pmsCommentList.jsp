<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script>
	//버튼 중복클릭 방지
	var doubleSubmitFlag = false;
	
	function addComment() {
		
		if (doubleSubmitFlag){
    		return;
    	}
		doubleSubmitFlag = true;
		
		var commentContent = $("#commentContent").val().trim();
		
		if(commentContent == "") {
			alert("내용을 입력해주세요.");
			return;
		}
		
		data = {
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
					alert("성공");
					doubleSubmitFlag = false;
					currentPage = 1;
					
					// 검색 후 새 글을 등록했을 때 검색 조건을 초기화한다.
					searchByUser = "";
					searchByStartDate = "";
					searchByEndDate = "";
					searchByContent = "";
					
					addTaskLog(projectId, 1, groupId, taskId, "[" + taskName + "](으)로 의견이 등록되었습니다.");
					getCommentList();
				} else {
					alert("실패");
					doubleSubmitFlag = false;
				}	
			},
			error : function() {
				alert("실패");
				doubleSubmitFlag = false;
			}
		});
	}
</script>

<div id="divList" style="width: 100%;">
	<table cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" border="0" class="mainlist" style="overflow:hidden">
		<thead id="tableHeader">
			<tr style="height: 37px;" id="BoardList_TH">
				<th onclick="setListOrder(this)" data-order='WRITER_NAME' width="7%">작성자</th>
				<th onclick="setListOrder(this)" data-order='TASK_NAME' width="10%">작업이름</th>
				<th onclick="setListOrder(this)" data-order='CONTENT'>내용</th>
				<th onclick="setListOrder(this)" data-order='WRITE_DATE' width="15%">작성일시</th>
				<th width="15%">수정/삭제</th>
			</tr>
		</thead>
		<tbody id="tableBody" style="background-color: rgb(255, 255, 255);">
			<c:forEach items="${data}" var="commentVO">
				<tr data-commentId="${commentVO.commentId}" data-groupId="${commentVO.groupId}" data-taskId="${commentVO.taskId}">
					<td>${commentVO.writerName}</td>
					<td>${commentVO.taskName ne null ? commentVO.taskName : commentVO.groupName}</td>
					<td style="text-align: left;">${commentVO.commentContent}</td>
					<td>${commentVO.writeDate}</td>
					<td>
						<span><img src="/images/ezLadder/icon_game03_no.png" height="25"/></span>
						<span><img src="/images/ezLadder/icon_imposDelete_thirty.png" height="25"/></span>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>	
</div>

<div style="margin-top: 20px;">
	<table>
		<tr>
			<th>의견등록</th>
			<td>
				<textarea id="commentContent" rows="" cols="" style="resize: none;"></textarea>
			</td>
			<td>
				<a class="imgbtn" onclick="addComment()"><span>저장</span></a>
			</td>
		</tr>
	</table>	
</div>
<c:choose>
	<c:when test="${paging.endPage>0 }">
		<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
			<div class="pagenavi">
				<c:choose>
					<c:when test="${paging.currentPage gt 1}">
						<span onclick="goToPageByNum(1)" class="btnimg"><img src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
					</c:when>
					<c:otherwise>
						<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>            
					</c:otherwise>   
				</c:choose>
				<c:choose>
					<c:when test="${paging.startPage gt 1}">
						<span onclick="goToPageByNum(${paging.startPage-1})" class="btnimg"><img src="/images/sub/btn_prev.gif" width="16" height="16"></span>              
					</c:when>
					<c:otherwise>
						<span class="btnimg"><img src="/images/sub/btn_prev01.gif" width="16" height="16"></span>              
					</c:otherwise>                                                                    
				</c:choose>
				<span class="ptxt" onclick="<c:if test="${paging.currentPage gt 1 }">goToPageByNum(${paging.currentPage-1})</c:if>"><spring:message code='ezApproval.t931'/></span>
				<c:forEach begin="0" end="${paging.endPage-paging.startPage }" varStatus="status">
					<c:choose>
						<c:when test="${paging.startPage+status.index eq paging.currentPage}">
							<span class="on">${paging.currentPage }</span>
						</c:when>
						<c:otherwise>
							<span onclick="goToPageByNum(${paging.startPage+status.index})">${paging.startPage+status.index}</span>
						</c:otherwise>
					</c:choose>
				</c:forEach>
				<span class="ptxt" onclick="<c:if test="${paging.totalPage gt paging.currentPage }">goToPageByNum(${paging.currentPage+1})</c:if>"><spring:message code='ezApproval.t932'/></span>
				<c:choose>
					<c:when test="${paging.totalPage gt paging.endPage }">
						<span class="btnimg" onclick="goToPageByNum(${paging.endPage+1})"><img src="/images/sub/btn_next.gif" width="16" height="16"></span>
					</c:when>
					<c:otherwise>
						<span class="btnimg"><img src="/images/sub/btn_next01.gif" width="16" height="16"></span>
					</c:otherwise>
				</c:choose>
				<c:choose>
					<c:when test="${paging.totalPage gt paging.currentPage }">
						<span class="btnimg" onclick="goToPageByNum(${paging.totalPage})"><img src="/images/sub/btn_n_next.gif" width="16" height="16"></span>
					</c:when>
					<c:otherwise>
						<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</c:when>
	<c:otherwise>
		<div id="tblPageRayer" style="width:470px; margin:6px auto; font-size:0">
			<div class="pagenavi">  
				<span class="btnimg"><img src="/images/sub/btn_p_prev01.gif" width="16" height="16"></span>
				<span class="btnimg"><img src="/images/sub/btn_prev01.gif" width="16" height="16"></span>
				<span class="ptxt"> <spring:message code='ezApproval.t931'/></span>  
				<span class="on">1</span> 
				<span class="ptxt"><spring:message code='ezApproval.t932'/></span>
				<span class="btnimg"><img src="/images/sub/btn_next01.gif" width="16" height="16"></span>
				<span class="btnimg"><img src="/images/sub/btn_n_next01.gif" width="16" height="16"></span>
			</div>
		</div>
	</c:otherwise>
</c:choose>