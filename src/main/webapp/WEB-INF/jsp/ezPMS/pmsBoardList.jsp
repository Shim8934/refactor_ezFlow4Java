<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div id="divList" style="width: 1200px;">
	<table class="mainlist" width="100%">
		<thead>
			<tr>
				<th><input type="checkbox"></th>
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
				<tr>
					<td><input type="checkbox"></td>
					<td>${projectBoardVO.itemId}</td>
					<td>파일</td>
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
					<td>${projectBoardVO.writeDate}</td>
					<td>${projectBoardVO.readCount}</td>
				</tr>
			</c:forEach>
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