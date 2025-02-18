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
	   	<script type="text/javascript">
	   		function ChangeListView_onClick(flag) {
	   			if (flag == 'TXT') {
	   				$("#txtlist_Layer").css("display","");
	   				$("#DeptUserImgList").css("display","none");
	   				$("#txtlist").attr("src","/images/kr/cm/btn_onlist.gif");
	   				$("#imglist").attr("src","/images/kr/cm/btn_imglist.gif");
	   			} else {
	   				$("#DeptUserImgList").css("display","");
	   				$("#txtlist_Layer").css("display","none");
	   				$("#txtlist").attr("src","/images/kr/cm/btn_list.gif");
	   				$("#imglist").attr("src","/images/kr/cm/btn_onimglist.gif");
    			}
	   		}
	   		
		</script>
		<style>
		</style>
	</head>
		<table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
			<tbody>
				<tr>
			    	<th style="white-space:normal">
			    		<span id="selectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;" countinfo="1"><img src="/images/OrganTree_cross/ic-open.gif" style="vertical-align:middle;">${keyword }-[<span class="txt_color"><spring:message code='ezPMS.t44' arguments='${userCount}'/></span>]</span>
			    		<span style="float:right;">
                           <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_onlist.gif" class="icon_btn" id="txtlist"></span>
                           <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
                       </span>
			        </th>
			    </tr>
			</tbody>
		</table>
		<div style="vertical-align: top; height: 440px; overflow: auto; width: 100%;" id="txtlist_Layer">
			<table style="width:100%; border: 1px solid #B6B6B6;" class="mainlist">
				<tr>
					<td style="width: 30%; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
					<td style="width: 20%; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
					<td style="width: 50%; font-weight: bold;" class="td_gray"><spring:message code='main.t78'/></td>
		        </tr>
		        <c:forEach items="${userList}" var="user" varStatus="status">
			        <tr id="${user.userId }" name="${user.userName }"  dept="${user.deptName }" onclick="setUserAuthorDept(this);" data-rowidx="${status.index}" ondblclick="setAuthorViewUser(type, true);" style="cursor: pointer;" class="hover">
						<td><c:out value="${user.userName }" /></td>
						<td><c:out value="${user.jikwi }" /></td>
						<td><c:out value="${user.mail }" /></td>
					</tr>
		        </c:forEach>
		    </table>
		</div>
		<div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 100%;" id="DeptUserImgList">
			<c:forEach items="${userList}" var="user">
				<table class="organwrap" cellspacing="0" cellpadding="0" style="margin-top: 5px; margin-left: auto; margin-right: auto;">
			        <tr id="${user.userId }" name="${user.userName }" dept="${user.deptName }" onclick="setUserAuthorDept(this);" data-rowidx="${status.index}" ondblclick="setAuthorViewUser(type, true);" style="cursor: pointer;" class="hover">
						<td class="pictd"><div class="pic">
						<c:if test="${not empty user.userImg }">
						<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${user.userImg }" width="90px" height="90px">
						</c:if>
						</div></td>
						<td style="width: 75%;">
							<table class="organinfo">
								<tr>
									<td class="name" style="text-align: left;">${user.userName }</td>
								</tr>
								<tr>
									<td style="text-align: left;">${user.deptName }</td>
								</tr>
								<tr>
									<td style="text-align: left;"><img class="icon" src="/images/OrganTree/icon_mail.gif">${user.mail }</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</c:forEach>
		</div>
</html>

