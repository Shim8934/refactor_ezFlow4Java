<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:choose>
	<c:when test="${fn:length(shareList) > 0}">
		<c:forEach items="${shareList}" var="share" varStatus="status">
			<tr class="shareRow" shareId="${share.shareId}" shareType="${share.shareType}">
			<c:choose>
                <c:when test="${lang eq '1'}">
                    <td style="text-align: center;"><c:out value='${share.shareName }'/></td>
                </c:when>
                <c:otherwise>
                    <td style="text-align: center;"><c:out value='${share.shareName2 }'/></td>
                </c:otherwise>
            </c:choose>
				<td style="text-align: center;">
					<c:if test="${share.shareType eq 'U' }">
						<spring:message code='ezApprovalG.share04'/>
					</c:if>
					<c:if test="${share.shareType eq 'D' }">
						<spring:message code='ezApprovalG.share05'/>
					</c:if>
				</td>
			</tr>
		</c:forEach>
	</c:when>
	<c:otherwise>
		<tr>
			<td colspan="2" style="border-bottom:none;">
				<div id="preview_nodata" class="preview_nodata" style="margin-top: 70px;">
			          <dl class="nodata_sIcon">
			       <dt><img src="/images/kr/main/noData_sIcon.png"></dt>
			       <dd id="nodata_title" style="font-family: malgun gothic"><spring:message code='ezApprovalG.share12'/></dd>
			           </dl>
		         </div>
			</td>
		</tr>
	</c:otherwise>
</c:choose>
