<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezJournal.c1' />" type="text/css" />
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	   	<script type="text/javascript">
	   		$(document).ready(function() {
	   			ChangeListView_onClick(getOrganListType());
	   		})
	   	
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
	   			
	   			setOrganListType(flag);
	   		}
	   		
	        function setOrganListType(pListType) {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/setListType.do",
	        		async : false,
	        		data : {
	        			listType : pListType
	        		},
	        		success : function(result) {
	        			
	        		}
	        	})
	        }
	        
	        function getOrganListType() {
	        	var organListType = "TXT";
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/ezOrgan/getListType.do",
	        		async : false,
	        		success : function(result) {
	        			organListType = result;
	        		}
	        	})
	        	return organListType;
	        }
		</script>
		<style>
		</style>
	</head>
		<table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
			<tbody>
				<tr>
			    	<th style="white-space:normal;background-color: white;border-top:0px solid #ddd;border-bottom:1px solid #eaeaea">
			    		<span id="selectDeptNM" style="font-weight: normal; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;" countinfo="1"><img src="/images/OrganTree_cross/ic-open.gif" style="vertical-align:middle;padding-right: 3px;"><c:out value='${keyword }'/>-[<span style="color:#017BEC;"><c:out value='${totalCount }'/><spring:message code='main.t20000'/></span>]</span>
			    		<c:choose>
			    			<c:when test="${listType eq 'TXT' }">
					    		<span style="float:right;">
		                           <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_onlist.gif" class="icon_btn" id="txtlist"></span>
		                           <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span>
		                       </span>
			    			</c:when>
			    			<c:otherwise>
					    		<span style="float:right;">
		                           <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span>
		                           <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_onimglist.gif" class="icon_btn" id="imglist"></span>
		                       </span>
			    			</c:otherwise>
			    		</c:choose>
			        </th>
			    </tr>
			</tbody>
		</table>
		<c:choose>
			<c:when test="${listType eq 'TXT' }">
				<div style="vertical-align: top; height: 400px; overflow: auto; width: 100%;" id="txtlist_Layer">
					<table style="width:100%; border: 1px solid #B6B6B6;" class="mainlist">
					<c:choose>
						<c:when test="${key eq 'DEPARTMENT' }">
							<tr>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
								<td style="width: 50%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='main.t78'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td><c:out value="${user.jikwi }" /></td>
									<td><c:out value="${user.mail }" /></td>
								</tr>
					        </c:forEach>
				        </c:when>
				        <c:otherwise>
				        	<tr>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t40'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='main.t78'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.deptName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.jikwi }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.mail }" /></td>
								</tr>
					        </c:forEach>
				        </c:otherwise>
					</c:choose>
				    </table>
				</div>
				<div style="vertical-align: top; text-align: center; height: 400px; overflow: auto; width: 100%; display: none;" id="DeptUserImgList">
					<c:forEach items="${userList}" var="user">
						<table class="organwrap" cellspacing="0" cellpadding="0" style="margin-top: 5px; margin-left: auto; margin-right: auto;">
					        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
								<td class="pictd"><div class="pic">
								<c:if test="${not empty user.userImg }">
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${user.userImg }" width="90px" height="90px">
								</c:if>
								</div></td>
								<td style="width: 75%;">
									<table class="organinfo">
										<tr>
											<td class="name" style="text-align: left;"><c:out value='${user.userName }'/></td>
										</tr>
										<tr>
											<td style="text-align: left;"><c:out value='${user.deptName }'/></td>
										</tr>
										<tr>
											<td style="text-align: left;"><img class="icon" src="/images/OrganTree/icon_mail.gif"><c:out value='${user.mail }'/></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</c:forEach>
				</div>
			</c:when>
			<c:otherwise>
				<div style="vertical-align: top; height: 400px; overflow: auto; width: 100%; display: none;" id="txtlist_Layer">
					<table style="width:100%; border: 1px solid #B6B6B6;" class="mainlist">
					<c:choose>
						<c:when test="${key eq 'DEPARTMENT' }">
							<tr>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
								<td style="width: 50%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='main.t78'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td><c:out value="${user.jikwi }" /></td>
									<td><c:out value="${user.mail }" /></td>
								</tr>
					        </c:forEach>
				        </c:when>
				        <c:otherwise>
				        	<tr>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t40'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t67'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezOrgan.t69'/></td>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='main.t78'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.deptName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.jikwi }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.mail }" /></td>
								</tr>
					        </c:forEach>
				        </c:otherwise>
					</c:choose>
				    </table>
				</div>
				<div style="vertical-align: top; text-align: center; height: 400px; overflow: auto; width: 100%;" id="DeptUserImgList">
					<c:forEach items="${userList}" var="user">
						<table class="organwrap" cellspacing="0" cellpadding="0" style="margin-top: 5px; margin-left: auto; margin-right: auto;">
					        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
								<td class="pictd"><div class="pic">
								<c:if test="${not empty user.userImg }">
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${user.userImg }" width="90px" height="90px">
								</c:if>
								</div></td>
								<td style="width: 75%;">
									<table class="organinfo">
										<tr>
											<td class="name" style="text-align: left;"><c:out value='${user.userName }'/></td>
										</tr>
										<tr>
											<td style="text-align: left;"><c:out value='${user.deptName }'/></td>
										</tr>
										<tr>
											<td style="text-align: left;"><img class="icon" src="/images/OrganTree/icon_mail.gif"><c:out value='${user.mail }'/></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</c:forEach>
				</div>
			</c:otherwise>
		</c:choose>
		<input type="hidden" id="totalCount" name="totalCount" value="${totalCount }" />
</html>

