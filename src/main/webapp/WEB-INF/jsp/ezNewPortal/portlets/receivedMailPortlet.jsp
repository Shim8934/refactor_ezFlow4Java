<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
	<head>
	</head>
<body>
	<input type="hidden" id="mailPercent" value="${mailPercent}">
	<div class="layDIV">
        <dl class="portlet_title sortablePortlet">
            <dt class="portletText"><spring:message code='main.t00038' /></dt>
            <dd class="portletPlus" onclick="Mailmore_btnClick()"><img src="/images/kr/main/portlet_Plus.png"></dd>
            <dd class="mailGraph">
                <p class="mGraph"><span id="mGraphSpan"></span></p>
                <span class="mGraph_text" id="UseMailBox">
                ${mailboxDetail }
                <span>${mailboxQuotaStr }</span>
                </span>
            </dd>
        </dl>
		<ul id="MailList" class="portlet_list">
		  <c:choose>
		  	<c:when test="${empty mailList }">
				<dl class='nodata'>
			  	<dt><img src='/images/kr/main/nodata.png'></dt>
			  	<dd>데이터 없음</dd>
				</dl>
		  	</c:when>
			<c:otherwise>
				<c:forEach var="mail" begin="0" end="4" items="${mailList}" varStatus="i">
					<li class="${mail.readClass}" onclick="open_mail('${mail.href}')">
						<span class='txt'><c:out value="${mail.subject }" escapeXml="true"/></span>
						<span class='date'><c:out value="${mail.receivedDateStr }" escapeXml="true"/></span>
						<span class='name'><c:out value="${mail.sender }" escapeXml="true"/></span>
					</li>
				</c:forEach>
			</c:otherwise>
		</c:choose>	     
		</ul>
     </div>
</body>
</html>
