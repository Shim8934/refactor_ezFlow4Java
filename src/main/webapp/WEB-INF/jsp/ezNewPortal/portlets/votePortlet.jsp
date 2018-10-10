<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="layDiv">
	<dl class="portlet_title">
		<dt class="portletText"><c:out value="${portletName }"/> (<c:out value='${voteCount }'/>)</dt>
		<dd class="portletPlus" id="votePlus"><img src="/images/ezNewPortal/portlet_Plus.png"></dd>
	</dl>
	<c:choose>
	<c:when test="${voteCount ne 0 }">
	<p class="voteTitle">"<c:out value="${title }"/>"</p>
	<p class="voteBtn" id="V<c:out value='${qstId }'/>">참여</p>
	<ul class="voteList">
		<c:forEach items="${pollAnswer }" var="poll" varStatus="status">
		<li class="voteList_0${status.index + 1 }">
			<div class="voteT">
				<span class="Vnum">${status.index + 1 }</span>
				<span class="Vtext">${poll.content}</span>
			</div>
			<div class="percent" id="percent${status.index + 1 }"><fmt:parseNumber value="${(poll.votesNumber / pollAnswerCount) * 100}" integerOnly="true"/>%</div>
			<div class="voteGraph" id="divGraph${status.index + 1 }">
				<span id="graph${status.index + 1 }" style="width : ${(poll.votesNumber / pollAnswerCount) * 100}%"></span>
			</div>
		</li>
		</c:forEach>
	</ul>
	</c:when>
	<c:otherwise>
	<ul class="portlet_list">
		<dl class="nodata">
			<dt><img src="/images/ezNewPortal/nodata.png"></dt>
			<dd><spring:message code='main.t00026'/></dd>
		</dl>
	</ul>
	</c:otherwise>
	</c:choose>
</div>