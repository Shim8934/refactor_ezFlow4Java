<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.ezEKP.ezPersonal.vo.PersonalNotiDisableItemVO.Finder" %>
<%@ page import="javax.servlet.ServletRequest" %>
<%!// Finder를 따로 받는 이유는 thread-safe한 코드를 작성하기 위함임, jsp declaration에서 Finder를 멤버 변수로 선언 후 scriptlet에서 값을 넣어 사용하면 thread-safe 하지 않기 때문
private static String makeMasterCheckbox(Finder disableItemFinder, int mainType, int platform, int subTypeCount) {
	String id = "master_" + mainType + platform;
	java.lang.StringBuilder tagBuilder = new StringBuilder("<div><label for=\"").append(id).append("\"></label>")
			.append("<div class=\"custom_checkbox\"><input id=\"").append(id);

	int countWithoutSubType = disableItemFinder.getCountWithoutSubType(mainType, platform);

	if (countWithoutSubType < subTypeCount && countWithoutSubType > 0) {
		tagBuilder.append("\" class=\"master dashDiv\" type=\"checkbox\" data-main=\"");
	} else {
		tagBuilder.append("\" class=\"master\" type=\"checkbox\" data-main=\"");
	}
	
	tagBuilder.append(mainType).append("\" data-platform=\"").append(platform);
	
	if (countWithoutSubType < subTypeCount) {
		tagBuilder.append("\" checked=\" ");

		if (countWithoutSubType > 0) {
			tagBuilder.append("\" indeterminate=\" ");
		}
	}
	
	tagBuilder.append("\" />");
	
	if (countWithoutSubType < subTypeCount && countWithoutSubType > 0) {
		tagBuilder.append("<span class=\"dash\"></span>");
	}
	
	return tagBuilder.append("</div></div>").toString();
}

private static String makeCheckbox(Finder disableItemFinder, int mainType, int subType, int platform) {
	String id = "" + mainType + subType + platform;
	java.lang.StringBuilder tagBuilder = new StringBuilder("<div><label for=\"").append(id).append("\"></label>")
			.append("<div class=\"custom_checkbox\"><input id=\"").append(id)
			.append("\" type=\"checkbox\" data-main=\"").append(mainType)
			.append("\" data-sub=\"").append(subType)
			.append("\" data-platform=\"").append(platform);

	if (!disableItemFinder.find(mainType, subType, platform)) {
		tagBuilder.append("\" checked=\" ");
	}

	return tagBuilder.append("\" /></div></div>").toString();
}%>
<% Finder disableItemFinder = (Finder) request.getAttribute("disableItemFinder"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
td:nth-child(3), th:nth-child(3), col:nth-child(3), td:nth-child(4), th:nth-child(4), col:nth-child(4) { display: none; }
</c:if>
<c:if test="${not useMail or useExternalMailServer}">
<%-- 메일을 사용하지 않는다면 메일 tr을 숨김 --%>
tr.mail { display: none; }
</c:if>
<c:if test="${not useApproval}">
<%-- 결재를 사용하지 않는다면 결재 tr을 숨김 --%>
tr[data-target='.approval'], tr.approval { display: none; }
</c:if>
<c:if test="${not usePassAprLine}">
<%-- 기결재통과를 사용하지 않는다면 결재통과알림 tr을 숨김 --%>
tr.approval.passAprLine { display: none; }
</c:if>
<c:if test="${not useBallotSystem}">
<%-- 투표를 사용하지 않는다면 투표 tr을 숨김 --%>
tr[data-target='.poll'], tr.poll { display: none; }
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
			<col style="width: 100px;">
		</colgroup>
		<tr>
			<th><spring:message code='ezPersonal.noti.item.td1' /></th>
			<th><spring:message code='ezPersonal.noti.item.td2' /></th>
			<th><spring:message code='ezPersonal.noti.item.td3' /></th>
			<th><spring:message code='ezPersonal.noti.item.td4' /></th>
			<th><spring:message code='ezPersonal.noti.item.td5' /></th>
		</tr>
		<tr class="mail">
			<th><spring:message code='ezPersonal.noti.item.mail' /></th>
			<th></th>
			<th><%=makeCheckbox(disableItemFinder, 1, 0, 2)%></th>
			<th><%=makeCheckbox(disableItemFinder, 1, 0, 3)%></th>
			<th><%=makeCheckbox(disableItemFinder, 1, 0, 4)%></th>
		</tr>
		<c:if test="${packageType ne 'mail'}">
		<tr class="collapsible" data-target=".approval">
			<th><spring:message code='ezPersonal.noti.item.approval' /></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 1, 6)%></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 2, 6)%></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 3, 6)%></th>
			<th><%=makeMasterCheckbox(disableItemFinder, 2, 4, 6)%></th>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.1' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 3)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 1, 4)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.2' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 3)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 2, 4)%></td>
			
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.3' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 3)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 3, 4)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.4' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 3)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 4, 4)%></td>
		</tr>
		<tr class="collapse approval">
			<td><spring:message code='ezPersonal.noti.item.approval.5' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 3)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 5, 4)%></td>
		</tr>
		<tr class="collapse approval passAprLine">
			<td><spring:message code='ezPersonal.noti.item.approval.6' /></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 1)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 2)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 3)%></td>
			<td><%=makeCheckbox(disableItemFinder, 2, 6, 4)%></td>
		</tr>
		<%-- 2023-08-03 조수빈 - 게시판 알림 설정 --%>
		<tr class="collapsible" data-target=".board">
	        <th><spring:message code='ezBoard.t0006' /></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 3, 1, 5)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 3, 3, 5)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 3, 4, 5)%></th>
		</tr>
		<tr class="collapse board">
	        <td><spring:message code='ezNotification.hth39' /></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 1, 4)%></td>
		</tr>
		<tr class="collapse board">
	        <td><spring:message code='ezNotification.hth40' /></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 2, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 2, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 2, 4)%></td>
		</tr>
		<tr class="collapse board">
	        <td><spring:message code='ezBoard.HSBMail03' /></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 3, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 3, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 3, 4)%></td>
		</tr>
		<tr class="collapse board">
	        <td><spring:message code='ezBoard.HSBMail04' /></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 4, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 4, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 4, 4)%></td>
		</tr>
		<tr class="collapse board">
	        <td><spring:message code='ezNotification.hth56' /></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 5, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 5, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 3, 5, 4)%></td>
		</tr>
		<%-- 2023-08-03 조수빈 - 일정관리 알림 설정 --%>
		<tr class="collapsible" data-target=".schedule">
	        <th><spring:message code='ezSchedule.t1010'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 4, 1, 6)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 4, 3, 6)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 4, 4, 6)%></th>
		</tr>
		<tr class="collapse schedule">
	        <td><spring:message code='ezSchedule.kmss09'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 1, 4)%></td>
		</tr>
		<tr class="collapse schedule">
	        <td><spring:message code='ezSchedule.kmss10'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 2, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 2, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 2, 4)%></td>
		</tr>
		<tr class="collapse schedule">
	        <td><spring:message code='ezSchedule.kmss11'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 3, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 3, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 3, 4)%></td>
		</tr>
		<tr class="collapse schedule">
	        <td><spring:message code='ezSchedule.kmss12'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 4, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 4, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 4, 4)%></td>
		</tr>
		<tr class="collapse schedule">
	        <td><spring:message code='ezSchedule.cofig.hth01'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 5, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 5, 3)%></td>
   	        <td><%=makeCheckbox(disableItemFinder, 4, 5, 4)%></td>
		</tr>
		<tr class="collapse schedule">
	        <td><spring:message code='ezSchedule.cofig.hth02'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 6, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 4, 6, 3)%></td>
   	        <td><%=makeCheckbox(disableItemFinder, 4, 6, 4)%></td>
		</tr>
		
		<%-- 2024-04-30 한태훈 - 자원관리 알림 설정 --%>
		<tr class="collapsible" data-target=".resource">
	        <th><spring:message code='ezResource.t17'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 5, 1, 3)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 5, 3, 3)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 5, 4, 3)%></th>
		</tr>
		<tr class="collapse resource">
	        <td><spring:message code='ezNotification.hth41'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 1, 4)%></td>
		</tr>
		<tr class="collapse resource">
	        <td><spring:message code='ezNotification.hth42'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 2, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 2, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 2, 4)%></td>
		</tr>
		<tr class="collapse resource">
	        <td><spring:message code='ezNotification.hth43'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 3, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 3, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 5, 3, 4)%></td>
		</tr>
		
		<%-- 2024-04-30 한태훈 - 전자설문 알림 설정 --%>
		<tr class="collapsible" data-target=".survey">
	        <th><spring:message code='ezQuestion.t300'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 6, 1, 2)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 6, 3, 2)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 6, 4, 2)%></th>
		</tr>
		<tr class="collapse survey">
	        <td><spring:message code='ezNotification.hth44'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 6, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 6, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 6, 1, 4)%></td>
		</tr>
		
		<%-- 2024-04-30 한태훈 - 투표 알림 설정 --%>
		<tr class="collapsible" data-target=".poll">
	        <th><spring:message code='ezPoll.t103'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 7, 1, 1)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 7, 3, 1)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 7, 4, 1)%></th>
		</tr>
		<tr class="collapse poll">
	        <td><spring:message code='ezNotification.hth46'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 7, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 7, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 7, 1, 4)%></td>
		</tr>
		
		<%-- 2024-04-30 한태훈 - 커뮤니티 알림 설정 --%>
		<tr class="collapsible" data-target=".community">
	        <th><spring:message code='ezCommunity.t1529'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 8, 1, 7)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 8, 3, 7)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 8, 4, 7)%></th>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth47'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 1, 4)%></td>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth48'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 2, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 2, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 2, 4)%></td>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth49'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 3, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 3, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 3, 4)%></td>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth50'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 4, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 4, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 4, 4)%></td>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth51'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 5, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 5, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 5, 4)%></td>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth52'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 6, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 6, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 6, 4)%></td>
		</tr>
		<tr class="collapse community">
	        <td><spring:message code='ezNotification.hth53'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 7, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 7, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 8, 7, 4)%></td>
		</tr>
		
		<%-- 2024-04-30 한태훈 - 웹폴더 알림 설정 --%>
		<tr class="collapsible" data-target=".webfolder">
	        <th><spring:message code='ezWebFolder.t10'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 9, 1, 2)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 9, 3, 2)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 9, 4, 2)%></th>
		</tr>
		<tr class="collapse webfolder">
	        <td><spring:message code='ezNotification.hth54'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 9, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 9, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 9, 1, 4)%></td>
		</tr>
		<tr class="collapse webfolder">
	        <td><spring:message code='ezNotification.hth55'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 9, 2, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 9, 2, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 9, 2, 4)%></td>
		</tr>
		
		<%-- 2024-06-28 한태훈 - 업무일지 알림 설정 --%>
		<tr class="collapsible" data-target=".journal">
	        <th><spring:message code='ezJournal.t1'/></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 10, 1, 2)%></th>
	        <th></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 10, 3, 2)%></th>
	        <th><%=makeMasterCheckbox(disableItemFinder, 10, 4, 2)%></th>
		</tr>
		<tr class="collapse journal">
	        <td><spring:message code='ezJournal.t122'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 10, 1, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 10, 1, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 10, 1, 4)%></td>
		</tr>
		<tr class="collapse journal">
	        <td><spring:message code='ezJournal.t123'/></td>
	        <td><%=makeCheckbox(disableItemFinder, 10, 2, 1)%></td>
	        <td></td>
	        <td><%=makeCheckbox(disableItemFinder, 10, 2, 3)%></td>
	        <td><%=makeCheckbox(disableItemFinder, 10, 2, 4)%></td>
		</tr>
		</c:if>
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

		// 2023-08-03 조수빈 - 이전의 선택한 요소들을 저장하기 위한 변수
		var beforeTarget;
		var beforeThis;
		// 하위 항목 숨기기/보이기 처리
		document.querySelectorAll(".collapsible").forEach(function(el) {
			var clickableElement = el.querySelector(":first-child");
			var collapseElements = document.querySelectorAll(el.getAttribute("data-target"));
			clickableElement.innerHTML += "<span class='spanUp'></span>";
			clickableElement.addEventListener("click", function() {
				
				// 2023-08-03 조수빈 - 기존 열려있는 구분 탭을 닫고 선택한 구분 탭을 열기
				if (beforeTarget !== event.currentTarget.parentNode.getAttribute("data-target")) {
					var beforeTrs = document.querySelectorAll('.show');
					
					if (beforeTrs.length > 0) {
						
						beforeTrs.forEach(function(before) {
					    	before.classList.toggle("show");
					    });
						
					    beforeThis.firstElementChild.classList.toggle("spanUp");
					    beforeThis.firstElementChild.classList.toggle("spanDown");
					}
				}
					
				collapseElements.forEach(function(el) {
				    el.classList.toggle("show");
				});
				
				this.firstElementChild.classList.toggle("spanUp");
				this.firstElementChild.classList.toggle("spanDown");
				beforeTarget = event.currentTarget.parentNode.getAttribute("data-target");
				beforeThis = this;
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
				if (masterCheckbox.checked && checkedCount < childCount) {
					if (masterCheckbox.closest("div").querySelector(".dash") == null) {
						var dashSpan = document.createElement("span");
						dashSpan.classList.add("dash");
						masterCheckbox.closest("div").appendChild(dashSpan);
						masterCheckbox.classList.add("dashDiv");
					}
				} else {
					masterCheckbox.classList.remove("dashDiv");
					masterCheckbox.closest("div").querySelector(".dash").remove();
				}
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
				masterCheckbox.addEventListener("change", function(event) {
					if (masterCheckbox.closest("div").querySelector(".dash") != null) {
						masterCheckbox.classList.remove("dashDiv");
						masterCheckbox.closest("div").querySelector(".dash").remove();
					}
					childCheckboxes.forEach(function(el) {
						el.checked = masterCheckbox.checked; 
					}); 
				});
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