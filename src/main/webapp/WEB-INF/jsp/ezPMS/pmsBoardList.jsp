<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<script>
	var boardDetail;
	var CurrentHeight = document.documentElement.clientHeight - 100;
	
	var contentCount = '<c:out value="${boardCount}"/>';
	taskName = '<c:out value="${taskName}"/>';
	
	$(function() {
		viewSetting();
		
		$(".mainlist tbody tr td:not(.checkbox)").on("click", function(evt) {
			var checkbox = $(this).parent().children("td:eq(0)").children();
			$('input:checkbox[name="boardCheckbox"]').each(function() {
				$(this).removeProp("checked","true");
				$(this).parent().parent().removeClass("selectedTR");
			});
			
			checkbox.prop("checked", "true");
			selectTR(checkbox);
		});
		
		$(".mainlist tbody tr").on("dblclick", function() {
			goBoardDetail(this);
		});
		
		$("tr[data-writetype=1], tr[data-writetype=3]").addClass("emergency");
		$("tr[data-readornot='false']").addClass("noView");
		
		if(typeof setContentTitle != 'undefined') {
			setContentTitle(taskName, contentCount);
		}	
	})
	
	// 체크박스 전체선택 혹은 해제
	function selectAllTR(elem) {
		if($(elem).is(":checked")) {
			 $('input:checkbox[name="boardCheckbox"]').each(function() {
				 $(this).prop("checked","true");
				 $(this).parent().parent().addClass("selectedTR");
			 });
		} else {
			 $('input:checkbox[name="boardCheckbox"]').each(function() {
				 $(this).removeProp("checked","true");
				 $(this).parent().parent().removeClass("selectedTR");
			 });
		}
	}
	
	function selectTR(elem) {
		if($(elem).is(":checked")) {
			$(elem).parent().parent().addClass("selectedTR");
		} else {
			$(elem).parent().parent().removeClass("selectedTR");
		}
	}
	
	// 게시판 상세 화면
	function goBoardDetail(elem) {
		var itemId = $(elem).attr("data-itemId");
		
		// 공지사항이 아닐 때만 볼드가 없어진다
		if($(elem).attr("data-noticeornot") == 'false') {
			$(elem).removeClass("noView");
		}
		
		var feature = GetOpenPosition(790, 800);
		boardDetail = window.open("/ezPMS/getBoardDetail.do?projectId=" + projectId + "&itemId=" + itemId, "", 
								  "width=790, height=800, resizable=no, scrollbars=no, status=no" + feature);
	}
	
	function deleteBoards() {
		var checkBoxes = $('input:checked[name="boardCheckbox"]');
		if(!checkBoxes.length) {
			alert("<spring:message code='ezPMS.t217' />");
			return;
		}
		
		itemIds = new Array();
		checkBoxes.each(function() {
			var itemId = $(this).parents("tr").eq(0).attr("data-itemid");
			itemIds.push(itemId);		
		});
		
		if(checkIfHasReplies(itemIds) == true) {
			alert("<spring:message code='ezPMS.t296' />");	
			return;
		}
		
		if(confirm("<spring:message code='ezPMS.t107' />") == true) {
			deleteBoardsAction(itemIds);
		}	
	}
	
	function goMoveBoards() {
		var checkBoxes = $('input:checked[name="boardCheckbox"]');
		if(!checkBoxes.length) {
			alert("<spring:message code='ezPMS.t218' />");
			return;
		}
	
		itemIds = new Array();
		checkBoxes.each(function() {
			var itemId = $(this).parents("tr").eq(0).attr("data-itemid");
			itemIds.push(itemId);	
		});
		
		if(checkIfHasReplies(itemIds) == true) {
			alert("<spring:message code='ezPMS.t292' />");	
			return;
		}
		
		DivPopUpShow(320, 320, "/ezPMS/goMoveBoards.do?projectId=" + projectId + "&onlyGroup=false");
	}
	
	function checkIfHasReplies(itemIds) {
		
		var check;
		
		data = {
			itemIds : itemIds
		}
		
		$.ajax({
			type : "POST",
			url : "/ezPMS/checkIfBoardHasReplies.do",
			dataType : "json",
			async : false,
			contentType : "application/json; charset=UTF-8",
			data : JSON.stringify(data),
			success : function(result) {
				check = result.data;
			}
		})
		
		return check;
	}
	
	function searchBoard() {
		searchByTaskName = $("#searchByTaskName").val();
		searchByUser = $("#searchByUser").val();
		searchByStartDate = $("#Sdatepicker").val();
		searchByEndDate = $("#Edatepicker").val();
		searchByTitle = $("#searchByTitle").val();
		searchByOverview = $("#searchByOverview").val();
		searchByContent = $("#searchByContent").val();
		searchOrNot = "true";
		
		/* // 검색 시에는 tree 클릭을 통해 설정되었던 taskId와 groupId를 초기화 한다.
		$("li[role='treeitem'][aria-level='1']").last().children("a").click(); */
		
		getBoardList();
	}
</script>

<style>
	.selectedTR {
		background-color: rgb(233, 241, 255);
	}

	tr.noView td {
		font-weight: bold;
	}
	
	tr.emergency td {
		color: red;
	}
	
	table.mainlist th, table.mainlist td {
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		cursor: pointer;
		text-align: center;
	}
</style>
<div id="divList" style="width: 100%;">
	<table cellspacing="0" cellpadding="0" multiselectable="false" useocs="false" width="100%" border="0" class="mainlist" style="overflow:hidden">
		<thead id="tableHeader">
			<tr style="height: 37px;" id="BoardList_TH">
				<th class="checkboxHeader" width="3%"><input type="checkbox" onchange="selectAllTR(this);"></th>
				<th onclick="setListOrder(this)" data-order='ITEM_ID' width="5%"><spring:message code='ezPMS.t268' /></th>
				<th onclick="setListOrder(this)" data-order='FILE' width="3%"><img src="/images/newAttach.gif"></th>
				<th onclick="setListOrder(this)" data-order='TITLE'><spring:message code='ezPMS.t118' /></th>
				<th onclick="setListOrder(this)" data-order='TASK_NAME' width="10%"><spring:message code='ezPMS.t98' /></th>
				<th onclick="setListOrder(this)" data-order='DEPT_NAME' width="7%"><spring:message code='ezPMS.t115' /></th>
				<th onclick="setListOrder(this)" data-order='WRITER_NAME' width="7%"><spring:message code='ezPMS.t114' /></th>
				<th onclick="setListOrder(this)" data-order='WRITE_DATE' width="18%"><spring:message code='ezPMS.t119' /></th>
				<th onclick="setListOrder(this)" data-order='READ_COUNT' width="7%"><spring:message code='ezPMS.t122' /></th>
			</tr>
		</thead>
		<tbody id="tableBody" style="background-color: rgb(255, 255, 255);">
			<c:choose>
				<c:when test="${empty data}">
					<tr>
						<td colspan="9" style="text-align : center"> <spring:message code='ezPMS.t30' /> </td>
					</tr>
				</c:when>
				<c:otherwise>
					<c:forEach items="${data}" var="projectBoardVO">
						<tr data-itemid="${projectBoardVO.itemId}" data-groupId="${projectBoardVO.groupId}" data-taskid="${projectBoardVO.taskId}" 
							data-writetype="${projectBoardVO.writeType}" data-readornot="${projectBoardVO.readOrNot}" data-noticeornot="${projectBoardVO.notice}">
							<td class="checkbox"><input type="checkbox" name="boardCheckbox" onchange="selectTR(this);"></td>
							<td>
								<c:choose>
									<c:when test="${projectBoardVO.notice}">
										<img src="/images/i_notice.gif" alt="NOTICE" />
									</c:when>
									<c:otherwise><c:out value="${projectBoardVO.docNo}"/></c:otherwise>
								</c:choose>
							</td>
							<c:choose>
								<c:when test="${projectBoardVO.fileCNT eq 0}">
									<td></td>
								</c:when>
								<c:otherwise>
									<td><img src="/images/newAttach.gif"></td>
								</c:otherwise>
							</c:choose>	
								<td class="boardTitle" style="text-align: left;">
									<c:forEach begin='0' end="${projectBoardVO.itemLevel}">&nbsp;&nbsp;&nbsp;</c:forEach>
									<c:if test="${projectBoardVO.itemLevel ne 0}"><img src="/images/i_rep.gif"/></c:if> 
									<c:if test="${projectBoardVO.writeDate > yesterday}"><img src="/images/i_new.gif"/></c:if>
									<c:out value="${projectBoardVO.title}"/> 
								</td>
							<c:choose>
								<c:when test="${projectBoardVO.taskName eq null}">
									<td class="taskName">
										<c:out value="${projectBoardVO.groupName}"/>
									</td>
								</c:when>
								<c:otherwise>
									<td class="taskName">
										<c:out value="${projectBoardVO.taskName}"/>
									</td>
								</c:otherwise>
							</c:choose>
							<td>
								<c:out value="${projectBoardVO.writerDeptName}"/>
							</td>
							<td>
								<c:out value="${projectBoardVO.writerName}"/>
							</td>
							<td class="writeDate">
								<c:out value="${fn:substring(projectBoardVO.writeDate, 0, 16)}"/>
							</td>
							<td>
								<c:out value="${projectBoardVO.readCount}"/>
							</td>
						</tr>
					</c:forEach>
				</c:otherwise>
			</c:choose>
		</tbody>
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
<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.4); display: none;" id="mailPanel">&nbsp;</div>
<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
</div>
