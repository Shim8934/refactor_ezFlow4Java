<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	   	<script type="text/javascript">
	   		var containLow = "${containLow}";
	   		var totalCount = "<c:out value='${totalCount }'/>";
	   		var totalCount2 = "<c:out value='${totalCount2 }'/>";
	   		var keyword = "<c:out value='${keyword }'/>";
	   		var imgFlag = "";
	   		$(document).ready(function() {
	   			ChangeListView_onClick(getOrganListType());
	   			memberCountInfo();
	   		})
	   	
	   		function ChangeListView_onClick(flag) {
	   			if (flag == 'TXT') {
	   				$("#txtlist_Layer").css("display","");
	   				$("#DeptUserImgList").css("display","none");
	   				$("#txtlist").attr("src","/images/kr/cm/btn_onlist.gif");
	   				$("#imglist").attr("src","/images/kr/cm/btn_imglist.gif");
					imgFlag = "TXT";
	   			} else {
	   				$("#DeptUserImgList").css("display","");
	   				$("#txtlist_Layer").css("display","none");
	   				$("#txtlist").attr("src","/images/kr/cm/btn_list.gif");
	   				$("#imglist").attr("src","/images/kr/cm/btn_onimglist.gif");
					imgFlag = "IMG";
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
	        
	        //부서별 사원 수 출력
	        function memberCountInfo() {
	        	var html = "<img src='/images/OrganTree_cross/ic-open.gif' style='vertical-align:middle;padding-right: 3px;'>";
	        	html += "<span id='spn_deptName'>" + keyword + "</span>";
				if (containLow == "YES") {
					var expanded = $("li[aria-selected=true]").eq(0).attr("aria-expanded");

					if (expanded != null && expanded != "") { //하위가 있으면
						html += "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span> / <span class='txt_color'>" + totalCount2 + "</span>";
	        		} else { //하위가 없으면
	        			html += "&nbsp;&nbsp;<span class='txt_color'>" + totalCount +"</span>";
	        		}
				} else {
					html += "&nbsp;&nbsp;<span class='txt_color'>" + totalCount + "</span>";
				}
				$("#selectDeptNM").html(html);
	        }
		</script>
		<style>
		</style>
	</head>
		<table style="width: 100%; margin-top: -1px; height:35px" class="popup_mainlist">
			<tbody>
				<tr>
			    	<th style="white-space:normal;background-color: white;border-top:0px solid #ddd;border-bottom:1px solid #eaeaea">
			    		<span id="selectDeptNM" style="font-weight: normal; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;" countinfo="1">
<!-- 			    			<img src="/images/OrganTree_cross/ic-open.gif" style="vertical-align:middle;padding-right: 3px;"> -->
<%-- 			    			<c:out value='${keyword }'/>-[ --%>
<!-- 			    				<span class='txt_color'> -->
<%-- 				    				<c:choose> --%>
<%-- 				    					<c:when test="${containLow eq 'NO' }"> --%>
<%-- 				    						<c:out value='${totalCount }'/> --%>
<%-- 				    					</c:when> --%>
<%-- 				    					<c:otherwise> --%>
<%-- 				    						<c:out value='${totalCount }'/><spring:message code='main.t20000'/></span>/<span class='txt_color'><c:out value='${totalCount2 }'/> --%>
<%-- 				    					</c:otherwise> --%>
<%-- 				    				</c:choose> --%>
<%-- 				    				<spring:message code='main.t20000'/> --%>
<!-- 		    					</span>] -->
			    			</span>
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
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t38'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t39'/></td>
								<td style="width: 50%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t214'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td><c:if test="${user.userType eq 'addJob'}"><spring:message code='ezOrgan.psb03'/> </c:if><c:out value="${user.jikwi }" /></td>
									<td><c:out value="${user.mail }" /></td>
								</tr>
					        </c:forEach>
				        </c:when>
				        <c:otherwise>
				        	<tr>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t40'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t38'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t39'/></td>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t214'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.deptName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:if test="${user.userType eq 'addJob'}"><spring:message code='ezOrgan.psb03'/> </c:if><c:out value="${user.jikwi }" /></td>
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
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${user.userImg }" onerror="this.style.display='none'" width="90px" height="90px">
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
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t38'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t39'/></td>
								<td style="width: 50%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t214'/></td>
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td><c:if test="${user.userType eq 'addJob'}"><spring:message code='ezOrgan.psb03'/> </c:if><c:out value="${user.jikwi }" /></td>
									<td><c:out value="${user.mail }" /></td>
								</tr>
					        </c:forEach>
				        </c:when>
				        <c:otherwise>
				        	<tr>
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t40'/></td>
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t38'/></td>      
								<td style="width: 20%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t39'/></td>      
								<td style="width: 30%; color:#333;background-color: #f8f8fa" class="td_gray"><spring:message code='ezJournal.t214'/></td>     
					        </tr>
					        <c:forEach items="${userList}" var="user">
						        <tr id="${user.userId }" name="${user.userName }" deptId="${user.deptId}" onclick="setUserAuthorDept(this);" ondblclick="setAuthorViewUser();" style="cursor: pointer;" class="hover">
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.deptName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:out value="${user.userName }" /></td>
									<td style="overflow:hidden; text-overflow:ellipsis; white-space:nowrap;"><c:if test="${user.userType eq 'addJob'}"><spring:message code='ezOrgan.psb03'/> </c:if><c:out value="${user.jikwi }" /></td>
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
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${user.userImg }" onerror="this.style.display='none'" width="90px" height="90px">
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

