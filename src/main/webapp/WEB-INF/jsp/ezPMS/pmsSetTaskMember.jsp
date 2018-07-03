<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPMS.t167' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css" />
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
	   	<script type="text/javascript" charset="UTF-8">
	   	
	   		// 프로젝트 아이디
	   		var projectId = "<c:out value='${projectId}'/>";
	   		
	   		// 그룹 아이디
	   		var groupId = "<c:out value='${groupId}'/>";
	   		
	   		// 선택된 담당자 배열
	   		var managerArray = [];
	   		
	   		var authList = [];
	   		
	   		// 선택된 수신자 이름
	   		var userName = "";
	   		var userId = "";
	   		// 선택된 수신자 아이디
	   		var selUserId = "";
	   		// 선택된 수신자 이름
	   		var selUserName = "";
	   		var selUserDept = "";
	   		
	   		var type = "<c:out value='${type}'/>";
	   		//올른쪽 리스트에서 선택된 유저
	   		var selMainListUserId="";
	   		var selMainListUserName="";
	   		
	   		var p_title = null;
	   		var p_selectedWindow = null;
	   		var authName = null;
	   		
	   		function close_Click() {
	   			parent.DivPopUpHidden();
	   		}
	   		
	   		//프로젝트 멤버 리스트 뿌리기
	   		// 상위 그룹이 최상위 그룹(프로젝트)일 때는 프로젝트 담당자 및 참여자가 나오고
	   		// 그 외에는 상위 그룹의 담당자 및 참여자가 나온다
	   		//roleId: 5 => roleId 1 또는 2인 사람을 조회한다.
	   		function getProjectMemberList(projectId) {
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/ezPMS/getProjectMemberList.do",
	   				data:{"projectId" : projectId, "groupId" : groupId, "roleId" : 5},
	   				success: function (result) {
		   				$("#orglistView").html(result);
	   				},
	   				complete: function(){
	   					//기존유저 세팅
			   			setPrevUser();
	   				}
	   			});
	   		}
	   		
	   		//오른쪽 리스트에서 클릭이벤트 적용
	   		function setMainListUserAuthorDept(elem) {
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "managerList"){
		   			$("#managerList tr").removeClass("selectTR");
	   			}  else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			}
	   			
	   			$(elem).addClass("selectTR");
	   			selMainListUserId = $(elem).attr("id");
	   			selMainListUserName = $(elem).attr("name");
	   			selUserDept = $(elem).attr("dept");
	   			// console.log("selMainListUserId : " + selMainListUserId)
	   		}
	   		
	   		// 리스트에서 클릭이벤트 적용
	   		function setUserAuthorDept(elem) {
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "managerList"){
		   			$("#managerList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			}
	   			
	   			$(elem).addClass("selectTR");
	   			selUserId = $(elem).attr("id");
	   			selUserName = $(elem).attr("name");
	   			selUserDept = $(elem).attr("dept");
	   			// console.log("selUserId : " + selMainListUserId)
	   		}
	   		
	   		// 선택한 사람을 권한 추가
	   		function setAuthorViewUser() {
	   			if (selUserId != "" && selUserId != undefined) {
		   			var receiverId = selUserId;
		   			userName = selUserName;
		   			var chkFlag = true;
		   			userDept = selUserDept;
		   			
		   			for(var i = 0; i < authList.length; i++) {
		   				if (authList[i].userId == receiverId) {
		   					chkFlag = false;
		   				}
		   			}
		   			
		   			if (chkFlag) {
		   				if (parent.originGroupId != undefined || parent.originGroupId != null) {
		   					managerArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : type === "participants" ? 2 : 1, "userDeptname" : userDept, "pctinput" : 100, "userIdType" : "user", "groupId" : parent.originGroupId});
		   				} else {
		   					managerArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : type === "participants" ? 2 : 1, "userDeptname" : userDept, "pctinput" : 100, "userIdType" : "user"});
		   				}
		   				
		   				authList.push({"userName" : userName, "userId" : receiverId});
		   			} else {
		   				alert("<spring:message code='ezPMS.t163' />");
		   			}
		   			
		   			drawReceiverList();
		   			selMainListUserId = "";
	   			} else {
	   				alert("<spring:message code='ezPMS.t164' />");
	   			}
	   		}
	   		
	   		// 선택된 수신자배열에서 특정 사원 삭제
		    function deleteReceiver() {
	   			
	   			for (var i = 0; i < authList.length; i++) {
			    	if (authList[i].userId === selMainListUserId) {
			    		authList.splice(i, 1);
			    	}
	   			}
	  
	   			for(var j = 0; j < managerArray.length; j++) {
			    	if (managerArray[j].userId === selMainListUserId) {
			    		managerArray.splice(j, 1);
			    		selMainListUserId = "";
			    	}
			    } 
			     drawReceiverList();
		     	
		    }
	   		
	   		// 선택된 수신자 배열을 토대로 화면에 그리는 곳
	   		function drawReceiverList() {
		    	var strHTML = "";
		    		//담당자 지정할 때와 참여자 지정할 때를 구분하여 동작.
		    		if(type === "participants"){
		    			for (var i = 0; i < managerArray.length; i++) {
				    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
				    		strHTML += "<tr style='cursor:pointer;' id=" + managerArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver()'>";
				    		strHTML += "<td style='width: 75%;'>";
				    		strHTML += managerArray[i].userName;
				    		strHTML += "(" + managerArray[i].userDeptname + ")";
				    		strHTML += "</td>";
				    		strHTML += "</tr>";
				    		strHTML += "</table>";
				    	}
		    		} else {
			    		for (var i = 0; i < managerArray.length; i++) {
				    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
				    		strHTML += "<tr style='cursor:pointer;' id=" + managerArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver()'>";
				    		strHTML += "<td style='width: 75%;'>";
				    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
				    		strHTML += managerArray[i].userName;
				    		strHTML += "(" + managerArray[i].userDeptname + ")";
				    		strHTML += "</td>";
				    		strHTML += "<td>";
				    		strHTML += "<input type='text' name='" + managerArray[i].userId + "' value='100' style='width:40px;text-align:center'> %";
				    		strHTML += "</td>";
				    		strHTML += "</tr>";
				    		strHTML += "</table>";
				    	}
		    		}
		    		$("#managerList").html(strHTML);
		    }
	   		
	   		function applyReceiver() {
  				setAuthorViewUser();
	   		}
	   		
	   		$(document).ready(function() {
	   			getProjectMemberList(projectId);
	   			authListInitData();
	   			
	   			$(function () {
		   			$(document).on({
		   				"dblclick":function(){
		   					delTargetDept(this);
		   				},
		   				"click":function(){
		   					targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
		   			
		   			function ReplaceText(orgStr, findStr, replaceStr) {
				        var re = new RegExp(findStr, "gi");
				        return (orgStr.replace(re, replaceStr));
				    }
		   			
				    function replaceString(p_str) {
				        p_str = ReplaceText(p_str, "&amp;", "&");
				        p_str = ReplaceText(p_str, "&lt;", "<");
				        p_str = ReplaceText(p_str, "&gt;", ">");
				        return p_str;
				    }
		   			
		   			drawReceiverList("manager");
	   			});
	   			
   			});
	   		
	   		function ok_Click() {
	   			//담당자 지정할 때와 참여자 지정할 때를 구분하여 동작.
	   			if(type === "participants"){
	   				if (managerArray.length == 0) {
		   				alert("<spring:message code='ezPMS.t294' />");
		   				return;
		   			}
	   				
	   				parent.participantList = managerArray;
	   				parent.applyParticipantList();
	   				parent.DivPopUpHidden();
	   			} else {
		   			if (managerArray.length == 0) {
		   				alert("<spring:message code='ezPMS.t169' />");
		   				return;
		   			}
		   			
		   			for (var i = 0; i < managerArray.length; i++) {
		   				managerArray[i].pctinput = $("input[name='"+managerArray[i].userId+"']").val();
		   			}
		   			
		   			selectHeadManager();
	   			}
	   			
	   			//opener.selReceiver = JSON.stringify(receiverList);
	   			//opener.showReceiver();
	   			//window.close();
	   		}
	   		
	   		function selectHeadManager() {
	   			var feature = GetOpenPosition(150, 150);
	   		 
	   			DivPopUpShow(400, 300, "/ezPMS/selectHeadManager.do");
	   		};
	   		
	   		function authListInitData(){
	   			//중복 추가 방지를 위해 기존 managerList와 participantList에 등록된 사람을 authList에 추가해준다.
	   			if(type === "participants"){
	   				var tmpList = parent.managerList;
	   				if(tmpList){
	   					for(var elem in parent.managerList){
	   						if(!(elem in authList)){
			   					authList.push(elem);
			   				}
	   					}
	   				}
	   			} else {
	   				var tmpList = parent.participantList;
	   				if(tmpList){
	   					for(var elem in tmpList){
	   						if(!(elem in authList)){
			   					authList.push(elem);
			   				}
	   					}
	   				}
	   			}
	   		}
	   		
	   		//기존 담당자 또는 참여자를 초기값으로 넣어준다.
	   		function setPrevUser(){
	   			if(type === "participants" && parent.participantList.length > 0){
		   			for(var elem in parent.participantList){
		   				$('#' + elem.userId).click().dblclick();
		   			}
	   			} else if (type !== "participants" && parent.managerList.length > 0){
	   				for(var elem in parent.managerList){
		   				$('#' + elem.userId).click().dblclick();
		   			}
	   			}
	   		}
		</script>
		<style>
			tr.hover:not(.selectTR):hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: rgb(233, 241, 255);
			}
			#List_TBODY2 tr{
				cursor: pointer;
			}
			#List_TBODY tr{
				cursor: pointer;
			}
		</style>
	</head>
	<body class="popup" style="overflow: hidden;"> 
        <h1 style="height: 20px;">
        	<c:choose>
        		<c:when test="${type == 'managers'}">
		        	<spring:message code='ezPMS.t167' />
        		</c:when>
        		<c:otherwise>
		        	<spring:message code='ezPMS.t293' />
        		</c:otherwise>
        	</c:choose>
        </h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
            selToggleList(document.getElementById("close"), "ul", "li", "0");
        </script>
	    <table style="width:100%;margin-top: 27px;">
			<tr>
				<td>
					<table id="TreeViewTD">
					 	<tr>
				        	<td id="journalOrgan_content">
								<table style="margin-top: 3px;">
						            <tr>
						                <td></td>
						                <td class="listview" style="width: 400px" id="orglistView">
						                </td>    
						            </tr>
						        </table>
		                  	</td>   
		                  	
	                        <td style="width: 30px; text-align: center;">
	                        	<div>
	                            	<img src="/images/arr_r.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(manager)"><br>
	                            	<img src="/images/arr_l.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(manager)">
	                        	</div>                            
	                        </td>
	                        
	                        <td style="vertical-align: top;">
	                        	<div style="display: inline-flex; border-bottom: 1px solid #565b66; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="manager">
											<c:choose>
								        		<c:when test="${type == 'managers'}">
										        	<spring:message code='ezPMS.t63' />
								        		</c:when>
								        		<c:otherwise>
										        	<spring:message code='ezPMS.t64' />
								        		</c:otherwise>
								        	</c:choose>
										</span>
									</h2>
								</div>
								<div class="receiver_borderbox">
									<div id="managerList" style="width: 305px; Height: 286px; overflow-x: auto; overflow-y: auto; background-color: rgb(246, 246, 246); cursor: pointer;"></div>
								</div>
	                        </td>
	                    </tr>
	                </table>
	      		</td> 
			</tr>
        </table>
		<table style="margin-top : 5px; margin-left:auto; margin-right:auto; border-spacing:10px 0; border-collapse: separate;">
			<tr>
				<td><a class="imgbtn" id="submit" onclick="ok_Click()"><span><spring:message code='ezPMS.t265' /></span></a></td>
			</tr>
		</table>
        <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div> 
	</body>
</html>