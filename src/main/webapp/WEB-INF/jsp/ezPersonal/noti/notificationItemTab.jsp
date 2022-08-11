<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.ezEKP.ezPersonal.vo.PersonalNotiDisableItemVO.Finder" %>
<%@ page import="javax.servlet.ServletRequest" %>
<%!// Finder를 따로 받는 이유는 thread-safe한 코드를 작성하기 위함임, jsp declaration에서 Finder를 멤버 변수로 선언 후 scriptlet에서 값을 넣어 사용하면 thread-safe 하지 않기 때문
private static String makeMasterCheckbox(Finder disableItemFinder, int mainType, int platform, int subTypeCount) {
	String id = "master_" + mainType + platform;
	java.lang.StringBuilder tagBuilder = new StringBuilder("<div><label for=\"").append(id).append("\"></label>")
			.append("<input id=\"").append(id).append("\" class=\"master\" type=\"checkbox\" data-main=\"").append(mainType).append("\" data-platform=\"").append(platform);

	int countWithoutSubType = disableItemFinder.getCountWithoutSubType(mainType, platform);

	if (countWithoutSubType < subTypeCount) {
		tagBuilder.append("\" checked=\" ");

		if (countWithoutSubType > 0) {
			tagBuilder.append("\" indeterminate=\" ");
		}
	}

	return tagBuilder.append("\" /></div>").toString();
}

private static String makeCheckbox(Finder disableItemFinder, int mainType, int subType, int platform) {
	String id = "" + mainType + subType + platform;
	java.lang.StringBuilder tagBuilder = new StringBuilder("<div><label for=\"").append(id).append("\"></label>")
			.append("<input id=\"").append(id)
			.append("\" type=\"checkbox\" data-main=\"").append(mainType)
			.append("\" data-sub=\"").append(subType)
			.append("\" data-platform=\"").append(platform);

	if (!disableItemFinder.find(mainType, subType, platform)) {
		tagBuilder.append("\" checked=\" ");
	}

	return tagBuilder.append("\" /></div>").toString();
}%>
<% Finder disableItemFinder = (Finder) request.getAttribute("disableItemFinder"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="${util.addVer('ezSchedule.e3', 'msg')}" type="text/css" />
<style>
body { margin: 0; }
label { position:absolute; top: 0; right: 0; bottom: 0; left: 0;}
input.time { width: 53px; margin: 0 5px; text-align: center; }
tr:first-child th { background: #f3f3f3; }
.content th { height: 29px; padding: 0px 10px; background: #fafafa; }
.content td { padding-left: 15px; }
.collapse:not(.show) { display: none; }
.content { width: 100%; table-layout: fixed; }
th:nth-child(n+2), td:nth-child(n+2) { padding: 0px; text-align: center; }
th:nth-child(n+2) > div, td:nth-child(n+2) > div { width: 100px; height: 100%; position: relative; display: table-cell; }
<c:if test="${not useEzTalkNotification}">
<%-- 톡 서버를 사용하지 않더라도 체크박스는 다 만들고나서 display: none으로 웹 렌더링 시에 숨기도록 개발함 --%>
td:nth-child(n+3), th:nth-child(n+3), col:nth-child(n+3) { display: none; }
</c:if>
<c:if test="${not useMail or not useEzTalkNotification or useExternalMailServer}">
<%-- 메일을 사용하지 않거나 톡 푸시를 사용하지 않는다면 메일 tr을 숨김 --%>
tr.mail { display: none; }
</c:if>
<c:if test="${not useApproval}">
<%-- 결재를 사용하지 않는다면 결재 tr을 숨김 --%>
tr[data-target='.approval'], tr.approval { display: none; }
</c:if>
</style>
<title></title>
</head>
<body>
	<table class="content">
		<colgroup>
			<col>
			<col style="width: 100px;">
			<col style="width: 100px;">
			<col style="width: 100px;">
		</colgroup>
		<tr>
			<th><spring:message code='ezPersonal.noti.item.td1' /></th>
			<th><spring:message code='ezPersonal.noti.item.td2' /></th>
			<th><spring:message code='ezPersonal.noti.item.td3' /></th>
			<th><spring:message code='ezPersonal.noti.item.td4' /></th>
		</tr>
		<tr class="mail">
			<th><spring:message code='ezPersonal.noti.item.mail' /></th>
			<th></th>
			<th><%=makeCheckbox(disableItemFinder, 1, 0, 2)%></th>
			<th><%=makeCheckbox(disableItemFinder, 1, 0, 3)%></th>
		</tr>
		<tr class="collapsible" data-target=".approval">
			<th><spring:message code='ezPersonal.noti.item.approval' /></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 1, 6)%></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 2, 6)%></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 3, 6)%></th>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.1' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 3)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.2' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 3)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.3' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 3)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.4' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 3)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.5' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 3)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.6' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 3)%></td>
		</tr>
	</table>
	<div class="btnpositionJsp">
		<a class="imgbtn" id="save"><span><spring:message code='ezPersonal.t34' /></span></a>
		<a class="imgbtn" id="cancel"><span><spring:message code='ezPersonal.t13' /></span></a>
	</div>
	<script>
		var primitiveQuerySelectorAll = Document.prototype.querySelectorAll.bind(document);
		Document.prototype.querySelectorAll = function(selector) { return Array.prototype.slice.call(primitiveQuerySelectorAll(selector)); };

		// 마스터 체크박스 indeterminate 속성 초기화
		document.querySelectorAll("[indeterminate]").forEach(function(el) { el.indeterminate = true; el.removeAttribute("indeterminate"); });

		// 하위 항목 숨기기/보이기 처리
		document.querySelectorAll(".collapsible").forEach(function(el) {
			var clickableElement = el.querySelector(":first-child");
			var collapseElements = document.querySelectorAll(el.getAttribute("data-target"));
			clickableElement.innerHTML += "<span class='spanUp'></span>";
			clickableElement.addEventListener("click", function() {
				collapseElements.forEach(function(el) { el.classList.toggle("show"); });
				this.firstElementChild.classList.toggle("spanUp");
				this.firstElementChild.classList.toggle("spanDown");
			});
		});

		// 전체선택 체크박스 처리
		var isIE = !Array.prototype.find;
		document.querySelectorAll("input.master").forEach(function(masterCheckbox) {
			var mainType = masterCheckbox.getAttribute("data-main");
			var platform = masterCheckbox.getAttribute("data-platform");
			var childAllSelector = "input[data-main='" + mainType + "'][data-platform='" + platform + "'][data-sub]";
			var childChckedSelector = childAllSelector + ":checked";
			var childCheckboxes = document.querySelectorAll(childAllSelector);
			var childCount = childCheckboxes.length;

			var childChangeListener = function() {
				var checkedCount = document.querySelectorAll(childChckedSelector).length;
				masterCheckbox.checked = checkedCount > 0;
				masterCheckbox.indeterminate = masterCheckbox.checked && checkedCount < childCount;
			};

			childCheckboxes.forEach(function(el) { el.addEventListener("change", childChangeListener); });

			if (isIE) {
				// IE는 indeterminate일 때에 무조건 checked가 되며 change 이벤트가 호출되지 않는 문제가 있음
				// 따라서 click 이벤트로 감지를 해서 강제로 checked 상태를 변경해줘야만 함
				masterCheckbox.addEventListener("click", function() {
					var check = document.querySelectorAll(childChckedSelector).length == 0;
					childCheckboxes.forEach(function(el) { el.checked = check; });
					setTimeout(function() {
						masterCheckbox.indeterminate = false;
						masterCheckbox.checked = check;
					}, 0);
				});
			} else {
				masterCheckbox.addEventListener("change", function(event) { childCheckboxes.forEach(function(el) { el.checked = masterCheckbox.checked; }); });
			}

		});

		document.getElementById("save").addEventListener("click", function() {
			var disabledItems = document.querySelectorAll("[data-sub]:not(:checked)").map(function(el) {
				return {
					mainType: Number(el.getAttribute("data-main")),
					subType: Number(el.getAttribute("data-sub")),
					platform: Number(el.getAttribute("data-platform"))
				};
			});

			$.ajax({
				method: "post",
				url: "/ezPersonal/saveNotificationDisableItems.do",
				data: JSON.stringify(disabledItems),
				contentType: "application/json; charset=utf-8",
				success: function(result) {
					if (result.status == "ok") {
						alert("<spring:message code='ezPersonal.noti.saved' />");
					} else {
						alert("<spring:message code='ezPersonal.noti.saveerr' />");
					}
				},
				error: function(err) {
					alert("<spring:message code='ezPersonal.noti.saveerr' />");
				}
			});
		});
		document.getElementById("cancel").addEventListener("click", function() { location.reload(); });
	</script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
</body>
</html>