<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPMS.t167' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
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
	   		//오른쪽 리스트에서 선택된 유저
	   		var selMainListUserId="";
	   		var selMainListUserName="";
	   		
	   		var p_title = null;
	   		var p_selectedWindow = null;
	   		var authName = null;
	   		
	   		//키보드 이벤트 함수용
	   		var listContentArry = [];
	   		var selUserList = [];
	   		
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
	   			var tableId = $(elem).parent().parent().parent().attr("id");
	   			var rowId = elem.getAttribute("id");
	   			
	   			var listTable = document.getElementById(tableId);
	   			
	   			if(PressShiftKey){
	   				tr_selectBlock(rowId, tableId);
	   				return;
	   			}
	   			
	   			if(!PressCtrlKey){
	   				cancelSelectTr(elem);
	   			}
	   			
	   			$(elem).addClass("selectTR");
	   			selMainListUserId = $(elem).attr("id");
	   			selMainListUserName = $(elem).attr("name");
	   			selUserDept = $(elem).attr("dept");
	   			listTable.setAttribute("lastSelectedRowID", rowId);
	   		}
	   		
	   		// 리스트에서 클릭이벤트 적용
	   		function setUserAuthorDept(elem) {
	   			listEventFunc(elem);
	   			
	   			selUserList = elem.parentElement.querySelectorAll("tr.selectTR");
				if(selUserList.length === 1){
		   			selUserId = $(elem).attr("id");
		   			selUserName = $(elem).attr("name");
		   			selUserDept = $(elem).attr("dept");
		   			selUserList = [];
				}
	   		}
	   		
	   		// 선택한 사람을 권한 추가
	   		function setAuthorViewUser() {
	   			if(selUserList && selUserList.length === 1){
	   				receiverId = selUserList[0].userId;
	   				userName = selUserList[0].userName;
		   			userDept = selUserList[0].userDeptname;
	   				
	   				selUserId = selUserList[0].userId;
	   				selUserName = selUserList[0].userName;
	   				selUserDept = selUserList[0].userDeptname;
		   			
		   			if (selUserId != "" && selUserId != undefined) {
		   				var chkFlag = true;
		   				
			   			for (var i = 0; i < authList.length; i++) {
			   				if (authList[i].userId == receiverId) {
			   					chkFlag = false;
			   				}
			   			}
			   			
			   			addUserToList(chkFlag);
			   			
		   			} else {
		   				alert("<spring:message code='ezPMS.t164' />");
		   			}
	   			} else if (selUserList && selUserList.length > 1){
	   				for (var i = 0; i < selUserList.length; i++) {
	   					var chkFlag = true;
	   					
   						if(!selUserList[i].userId){
	   						receiverId = selUserList[i].getAttribute("id");
			   				userName = selUserList[i].getAttribute("name");
			   				userDept = selUserList[i].getAttribute("dept");
   						} else {
	   						receiverId = selUserList[i].userId;
			   				userName = selUserList[i].userName;
			 	  			userDept = selUserList[i].userDeptname;
   						}
		   				userIdType = "user";
	   					
		   				for(var j = 0; j < authList.length; j++) {
		   					if (authList[j].userId == receiverId) {
		   						chkFlag = false;
		   						break;
		   					}
		   				}
		   			
		   				addUserToList(chkFlag);
	   				}
	   					
	   			} else if(selUserId){
	   				var chkFlag = true;
	   				
	   				receiverId = selUserId;
		   			userName = selUserName;
		   			userDept = selUserDept;
		   			
		   			for(var i = 0; i < authList.length; i++) {
		   				if (authList[i].userId == receiverId) {
		   					chkFlag = false;
		   				}
		   			}
		   			
		   			addUserToList(chkFlag);
	   			}
	   			
	   			drawReceiverList(authName);
	   			selMainListUserId = "";
	   			
	   			function addUserToList(chkFlag){
	   				if (chkFlag) {
 		   				if (parent.originGroupId != undefined || parent.originGroupId != null) {
 		   					managerArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : type === "participants" ? 2 : 1, "userDeptname" : userDept, "pctinput" : 100, "userIdType" : "user", "groupId" : parent.originGroupId});
 		   				} else {
 		   					managerArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : type === "participants" ? 2 : 1, "userDeptname" : userDept, "pctinput" : 100, "userIdType" : "user"});
 		   				}
		   				
 		   				authList.push({"userName" : userName, "userId" : receiverId});
 		   			} /* else {
 		   				alert("<spring:message code='ezPMS.t163' />");
 		   			} */
	   			}
	   		}
	   		
	   		// 선택된 수신자배열에서 특정 사원 삭제
		    function deleteReceiver(elem) {
	   			var authName = "manager";
	   			var tableId = {
	   					"manager" : "managerList"
	   			}
	   			var tableObj = document.getElementById(tableId[authName]);
	   			var selectedList = tableObj.getElementsByClassName("selectTR");
	   			
	   			for(var i = 0; i < selectedList.length; i++){
	   				var elem = selectedList[i];
	   				var id = elem.getAttribute("id").replace(tableId[authName] + "_", "");
	   				removeUser(id);
	   			}
	   			
			    function removeUser(selectedUserId){
			    	for (var i = 0; i < authList.length; i++) {
				    	if (authList[i].userId === selectedUserId) {
				    		authList.splice(i, 1);
				    	}
		   			}
			    	
			    	if (authName == "manager") {
		   				for(var j = 0; j < managerArray.length; j++) {
				    		if (managerArray[j].userId === selectedUserId) {
				    			managerArray.splice(j, 1);
				    			selMainListUserId = "";
				    		}
				    	}
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
				    		strHTML += "<tr style='cursor:pointer;' id=managerList_" + managerArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(this)' data-rowidx=" + i +">";
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
				    		strHTML += "<tr style='cursor:pointer;' id=managerList_" + managerArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(this)' data-rowidx=" + i +">";
				    		strHTML += "<td style='width: 75%;'>";
				    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
				    		strHTML += managerArray[i].userName;
				    		strHTML += "(" + managerArray[i].userDeptname + ")";
				    		strHTML += "</td>";
				    		strHTML += "<td>";
				    		// 투입률 적용 후 display none해제 예정
				    	 	strHTML += "<input type='text' name='" + managerArray[i].userId + "' value='100' style='width:40px; text-align:center; display: none;'>";
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
// 	   				if (managerArray.length == 0) {
// 		   				alert("<spring:message code='ezPMS.t294' />");
// 		   				return;
// 		   			}
	   				
	   				parent.participantList = managerArray;
	   				parent.applyParticipantList();
	   				
	   			} else {
		   			if (managerArray.length == 0) {
		   				alert("<spring:message code='ezPMS.t169' />");
		   				return;
		   			}
		   			
		   			for (var i = 0; i < managerArray.length; i++) {
		   				managerArray[i].pctinput = $("input[name='"+managerArray[i].userId+"']").val();
		   			}
		   			
		   			parent.managerList = managerArray;
		   			parent.headManagerId = managerArray[0].userId;
		   			parent.applyList();
	   			}
	   			
	   			parent.DivPopUpHidden();
	   			
	   		}
	   		
// 	   		function selectHeadManager() {
// 	   			var feature = GetOpenPosition(150, 150);
	   		 
// 	   			DivPopUpShow(400, 300, "/ezPMS/selectHeadManager.do");
// 	   		};
	   		
	   		function authListInitData(){
	   			//중복 추가 방지를 위해 기존 managerList와 participantList에 등록된 사람을 authList에 추가해준다.
	   			if(type === "participants"){
	   				var tmpList = parent.managerList;
	   				if(tmpList){
	   					for(var i = 0; i < tmpList.length; i++){
	   						var manager = tmpList[i];
	   						if(manager.userId !== authList.userId){
			   					authList.push(manager);
			   				}
	   					}
	   				}
	   			} else {
	   				var tmpList = parent.participantList;
	   				
	   				if(tmpList){
	   					for(var i = 0; i < tmpList.length; i++){
	   						var participant = tmpList[i];
	   						if(participant.userId !== authList.userId){
			   					authList.push(participant);
			   				}
	   					}
	   				}
	   			}
	   		}
	   		
	   		//기존 담당자 또는 참여자를 초기값으로 넣어준다.
	   		function setPrevUser(){
	   			if(type === "participants" && parent.participantList.length > 0){
	   				selUserList = parent.participantList;
	   			} else if (type !== "participants" && parent.managerList.length > 0){
	   				selUserList = parent.managerList;
	   			}
	   			setAuthorViewUser()
	   			
	   			//포커스 제거.
	   			$("#txtlist_Layer .mainlist tr").removeClass("selectTR");
	   		}
	   		
	   		function listEventFunc(obj, event){
	   			var listEventCheckbox;
	   			if (!listEventCheckbox) {
		            if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
		                    
		                    if (p_ListOrderObject != null) {
		                    	cancelSelectTr(obj);
		                    }		
		                }
		                listContentArry = new Array();
		            }
		            if (PressShiftKey) {
		                var SelectedPreObj = null;
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
		                    if (Cnt == 0) {
		                        SelectedPreObj = p_ListOrderObject;
		                    }
		                    
		                    cancelSelectTr(obj);
		                }
		                listContentArry = new Array();
		                if (p_ListOrderObject == null)
		                    return;
		
		                var PrelistContent;
		                if (SelectedPreObj == null) {
		                    PrelistContent = p_ListOrderObject;
		                }
		                else {
		                    PrelistContent = SelectedPreObj;
		                }
		                p_ListOrderObject = obj;
		
		                var CurlistContent = obj;
		                var PrePoint = PrelistContent.getAttribute("data-rowidx") * 1;
		                var CurPoint = CurlistContent.getAttribute("data-rowidx") * 1;	
		                if (PrePoint < CurPoint) {
		
		                    for (var Cnt = PrePoint; Cnt <= CurPoint; Cnt++) {
		                        p_ListOrderObject = document.querySelector("tr[data-rowidx='" + Cnt + "']");
		                        $(p_ListOrderObject).addClass("selectTR");
		                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
		                    }
		
		                }
		                else if (PrePoint > CurPoint) {
		                    for (var Cnt = PrePoint; Cnt >= CurPoint; Cnt--) {
		                    	p_ListOrderObject = document.querySelector("tr[data-rowidx='" + Cnt + "']");
		                    	$(p_ListOrderObject).addClass("selectTR");
		                        listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
		                    }
		                }
		                else {
		                    return;
		                }
		
		            }
		            else {
						var insertFlag = true;
						p_ListOrderObject = obj;
						for (var i = 0; i < listContentArry.length; i++) {
		                    if (listContentArry[i] == p_ListOrderObject.getAttribute("id")) {
		                        insertFlag = false;
		                        if (PressCtrlKey) {
		                            listContentArry.splice(i, 1);
		                            $(obj).removeClass("selectTR");
		                            if (listContentArry.length == 0)
		                                p_ListOrderObject = "";
		                        }
		                    }
		                }
		                if (insertFlag) {
		                	if (!PressCtrlKey){
		                		cancelSelectTr(obj);
		                		listContentArray = [];
		                		selUserList = [];
		                	}
		                	
		                	$(obj).addClass("selectTR");
		                	selUserList[selUserList.length] = obj;
		                    listContentArry[listContentArry.length] = p_ListOrderObject.getAttribute("id");
		                }
						return;
		            }
		        }
		        else{
		            listEventCheckbox = false;
		        }
	   		}
	   		
	   		function cancelSelectTr(elem){
	   			var tableId = "";
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "managerList"){
		   			$("#managerList tr").removeClass("selectTR");
		   			tableId = "managerList";
	   			} else if ($(elem).parent().parent().parent().attr("id") === "participantList"){
		   			$("#participantList tr").removeClass("selectTR");
		   			tableId = "participantList";
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			}
	   			
	   			return tableId;
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
		<table style="width:100%;">
			<tr>
				<td><div class="btnpositionNew"><a class="imgbtn" id="submit" onclick="ok_Click()"><span><spring:message code='ezPMS.t265' /></span></a></div></td>
			</tr>
		</table>
        <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div> 
	</body>
</html>