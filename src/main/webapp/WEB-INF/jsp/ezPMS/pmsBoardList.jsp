<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<style>
	.selectedTR {
		background-color: rgb(233, 241, 255);
	}
	
	tbody tr {
		cursor: pointer;
	}
	
	tr.noView td {
		font-weight: bold;
	}
	
	tr.emergency td {
		color: red;
	}
</style>
<div id="divList" style="width: 100%;">
	<div id="mainmenu">
		<ul class="on">
			<li class="off"><span onclick="goAddBoard()">등록</span></li>
			<li class="off"><span onclick="deleteBoards()">삭제</span></li>
			<li class="off"><span onclick="moveBoards()">이동</span></li>
			<li class="off"><span onclick="">새로고침</span></li>
			<li class="off"><span onclick="">검색</span></li>
		</ul>
	</div>
	<table class="mainlist" style="width: 100%;">
		<thead>
			<tr style="height: 37px;">
				<th class="checkboxHeader"><input type="checkbox" onchange="selectAllTR(this);"></th>
				<th>No</th>
				<th><img src="/images/newAttach.gif"></th>
				<th>제목</th>
				<th>작업이름</th>
				<th>부서</th>
				<th>게시자</th>
				<th>게시일</th>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${data}" var="projectBoardVO">
				<c:choose>
					<c:when test="${projectBoardVO.readOrNot eq false && (projectBoardVO.writeType == 1 || projectBoardVO.writeType == 3)}">
						<tr class="noView emergency" data-itemid="${projectBoardVO.itemId}">
					</c:when>
					<c:when test="${projectBoardVO.readOrNot eq true && (projectBoardVO.writeType == 1 || projectBoardVO.writeType == 3)}">
						<tr class="emergency" data-itemid="${projectBoardVO.itemId}">
					</c:when>
					<c:when test="${projectBoardVO.readOrNot eq false && (projectBoardVO.writeType != 1 && projectBoardVO.writeType != 3)}">
						<tr class="noView" data-itemid="${projectBoardVO.itemId}">
					</c:when>
					<c:otherwise>
						<tr data-itemid="${projectBoardVO.itemId}">
					</c:otherwise>
				</c:choose>
					<td class="checkbox"><input type="checkbox" name="boardCheckbox" onchange="selectTR(this);"></td>
					<td>
						<c:choose>
							<c:when test="${projectBoardVO.writeType == 1 || projectBoardVO.writeType == 2}">
								<img src="/images/i_notice.gif" alt="NOTICE" />
							</c:when>
							<c:otherwise>
								${projectBoardVO.itemId}
							</c:otherwise>
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
						<td>${projectBoardVO.title}</td>
					<c:choose>
						<c:when test="${projectBoardVO.taskName eq null}">
							<td>${projectBoardVO.groupName}</td>
						</c:when>
						<c:otherwise>
							<td>${projectBoardVO.taskName}</td>
						</c:otherwise>
					</c:choose>
					<td>${projectBoardVO.writerDeptName}</td>
					<td>${projectBoardVO.writerName}</td>
					<td>${fn:substring(projectBoardVO.writeDate, 0, 19)}</td>
					<td>${projectBoardVO.readCount}</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
</div>
<c:choose>
	<c:when test="${paging.endPage>0 }">
		<div style="width:470px; margin:6px auto; font-size:0">
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
		<div style="width:470px; margin:6px auto; font-size:0">
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
