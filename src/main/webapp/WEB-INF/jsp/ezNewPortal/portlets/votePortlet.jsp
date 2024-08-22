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
<script type="text/javascript">
	$(function() {
		var portletName = "<c:out value='${portletName }'/>";
		ellipsisTitle(portletName, 4);
		var portletText = $("#4Portlet .portletText");
		portletText.append(' (');
		var spanElement = $('<span>').attr('id', 'voteCount');
		var voteCnt = "<c:out value='${voteCount }'/>";
		spanElement.append(voteCnt);
		portletText.append(spanElement);
		portletText.append(')');
	});
</script>
<body>
	<article class="vote box_shadow">
		<div id="voteDiv" class="layDiv voteLay">
			<dl class="portlet_title sortablePortlet">
				<dt class="portletText">
				</dt>
				<dd class="portletPlus plus" id="votePlus"></dd>
			</dl>
			<c:choose>
				<c:when test="${voteCount ne 0 }">
					<div id="voteList" class="vote_contents">
					<div class="voteTitle_all">
                        <p class="voteTitle"><c:out value="${title}"/></p>
                        <p class="voteBtn votePortlet" id="V<c:out value='${qstId}'/>"><spring:message code="main.t2001"/></p>
                    </div>
					<ul class="portlet_list voteList">
						<c:forEach items="${pollAnswer }" var="poll" varStatus="status">
<%--							<c:if test="${status.index lt 4 }">--%>
								<li class="voteList_0${status.index + 1 }">
									<div class="voteT">
										<span class="Vnum">${status.index + 1 }</span> <span class="Vtext"><c:out value='${poll.content}'/></span>
									</div>
									<div class="percent" id="percent${status.index + 1 }">
										<c:choose>
										<c:when test="${pollAnswerCount eq 0 }">
											<c:out value='0%'/>
										</c:when>
										<c:otherwise>
											<fmt:parseNumber value="${(poll.votesNumber / pollAnswerCount) * 100}" integerOnly="true" />%
										</c:otherwise>
										</c:choose>
									</div>
									<div class="voteGraph" id="divGraph${status.index + 1 }">
										<c:choose>
										<c:when test="${pollAnswerCount eq 0 }">
											<span id="graph${status.index + 1 }" style="width : 0%"></span>
										</c:when>
										<c:otherwise>
											<span id="graph${status.index + 1 }" style="width : ${(poll.votesNumber / pollAnswerCount) * 100}%"></span>
										</c:otherwise>
										</c:choose>
									</div>
								</li>
<%--							</c:if>--%>
						</c:forEach>
					</ul>
					</div>
				</c:when>
				<c:otherwise>
					<ul id="noDataUL" class="portlet_list">
						<dl class="nodata">
							<dt>
								<img src="/images/kr/main/noData_sIcon.png">
							</dt>
							<dd>
								<spring:message code='ezNewPortal.t018' />
							</dd>
						</dl>
					</ul>
				</c:otherwise>
			</c:choose>
		</div>
	</article>
</body>
<script>

var colors = ["#e04343", "#f79f3f", "#a9cd40", "#00b4c8", "#898cff", "#ff89b5", "#ffdc89",
				"#90d4f7", "#71e096", "#f5a26f", "#668de5", "#ed6d79", "#5ad0e5", "#da97e0",
				"#cff381", "#ff96e3", "#bb96ff", "#67eebd", "#fa9928", "#ef3924", "#d41e47",
				"#4c64ae", "#01539c", "#f05f7c", "#00b3ca", "#bd8139", "#d9c622", "#4a2431",
				"#d41e47", "#eb148d"];

var voteNodeList = document.querySelectorAll('[class^="voteList_0"]');
var voteElemList = Array.prototype.slice.call(voteNodeList);

// 선택된 요소들을 순회합니다.
for (var i = 0; i < voteElemList.length; i++) {
    var element = voteElemList[i];
    var aaElements = element.getElementsByClassName("Vtext")[0];
	aaElements.style.color = colors[i % 30];
}

</script>
</html>