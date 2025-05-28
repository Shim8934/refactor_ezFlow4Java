<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/ListView_list.js')}"></script>
		<script>
			add_key_event();
			disable_browser_selection();
		</script>
		<style>
			#selectDeptNM {font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;	}
			#txtlist_Layer {vertical-align: top; height: 278px; overflow: auto; width: 100%;}
			table.mainlist{width:100%; border: 1px solid #B6B6B6;}
		</style>
	</head>
		<table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
			<tbody>
				<tr>
			    	<th style="white-space:normal">
			    		<span id="selectDeptNM" countinfo="1"><img src="/images/OrganTree_cross/ic-open.gif" style="vertical-align:middle;">[<span class="txt_color">${memberList.size()}</span>명]</span>
			    		<span style="float:right;">
                       </span>
			        </th>
			    </tr>
			</tbody>
		</table>
		<div id="txtlist_Layer">
			<table class="mainlist">
				<tr>
					<td style="width: 40%; font-weight: bold;" class="td_gray"><spring:message code='ezPMS.t264' /></td>
					<td style="width: 60%; font-weight: bold;" class="td_gray"><spring:message code='ezPMS.t115' /></td>
		        </tr>
		        <c:forEach items="${memberList}" var="member" varStatus="status">
			        <tr id="${member.userId }" name="${member.userName }"  dept="${member.userDeptname }" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover" data-rowidx="${status.index}">
						<td><c:out value="${member.userName }" /></td>
						<td><c:out value="${member.userDeptname }" /></td>
					</tr>
		        </c:forEach>
		    </table>
		</div>
</html>

