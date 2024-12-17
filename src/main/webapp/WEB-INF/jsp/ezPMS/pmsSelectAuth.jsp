<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPMS.t162' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />
			
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPMS/ListView_list.js')}"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   		// 선택된 수신자 배열
	   		var receiverList = [];
	   		
	   		var managerArray = [];
	   		var participantArray = [];
	   		var viewerArray = [];
	   		var authList = [];
	   		
	   		// 선택된 수신자 이름
	   		var userName = "";
	   		// 선택된 수신자 아이디
	   		var selUserId = "";
	   		// 선택된 수신자 이름
	   		var selUserName = "";
	   		var selUserDept = "";
	   		
	   		// 현재 로그인된 사용자 아이디
	   		var userId = "<c:out value='${userId}'/>";
	   		var userName = "<c:out value='${userName}'/>";
	   		var userDept = "<c:out value='${userDept}'/>";
	   		
	   		// 즐겨찾기 아이디
	   		var favoriteId = "";
	   		
	   		var type = "<c:out value='${type}'/>";
	   		//올른쪽 리스트에서 선택된 유저
	   		var selMainListUserId="";
	   		var selMainListUserName="";
	   		
	   		var p_title = null;
	   		var p_selectedWindow = null;
	   		var authName = null;
	   		
	   		//키보드 이벤트 함수용
	   		var listContentArry = [];
	   		var selUserList = [];
	   		
	   		function close_Click(){
	   			window.close();
	   		}
	   		
	   		//조직도 뿌리는 펑션
	   		function setDeptList() {
				$('#treeview').on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
			     	var deptName = $("#"+id+" a:first").text();
					setUserList("DEPARTMENT", id,deptName);
					selMainListUserId = "";
					selUserId = "";
				  })
				.jstree({ 
					'core'   : {'data' : treeContent, 'multiple' : false},
					'plugins': ["wholerow"],
					'themes' : {'responsive' : true}
				}).on('ready.jstree', function(e, data) {
					var offset = $(".jstree-wholerow-clicked").offset();
					var jstree = document.getElementById("treeview");
					$('#treeview').animate({scrollTop : offset.top - jstree.offsetHeight / 2}, 40);
				});
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key, value,deptName) {
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/ezPMS/userList.do",
	   				data:{"key" : key, "value" : value,"deptName":deptName},
	   				success: function(result){
	   					var picList = $(result).find(".organwrap");
	   					
	   					if (picList.length==0 && key!="DEPARTMENT") {
	   						alert("<spring:message code='ezCommunity.t1379'/>");
	   					} else {
		   					$("#orglistView").html(result);
	   					}
	   				}
	   			});
	   		}
	   		
	   		//검색
	   		function search_click() {
	   			var key = $("#search_type").val();
	   			var value = $("#keyword").val().trim();
	   			
	   			if (value) {
		   			setUserList(key, value);
	   			} else {
	   				alert("<spring:message code='ezSchedule.t8'/>")
	   			}
		     	// 2021-04-09 김은실 - 검색 시 PressShiftKey = true 되는 현상(commit 6c23f8716 참조): 모든 search_click()에 적용. 
	            PressShiftKey = false;
	   		}
	   		
	   		//eunjeong
	   		function SelectReceiverWindow(title, selectedWindow) {
	   			if (p_title != null && p_selectedWindow != null) {
	   				p_title.style.fontWeight = "normal";
	   				p_selectedWindow.style.backgroundColor = "rgb(246, 246, 246)";
	   			}
	   			
	   			title.style.fontWeight = "bold";
	   			selectedWindow.style.backgroundColor = "white";
	   			
	   			p_title = title;
   				p_selectedWindow = selectedWindow;
   				type = title.id;
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
	   			selMainListUserId = $(elem).attr("id").replace(tableId + "_", "");
	   			selMainListUserName = $(elem).attr("name").replace(tableId + "_", "");
	   			selUserDept = $(elem).attr("dept").replace(tableId + "_", "");
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
	   		function setAuthorViewUser(authName, isUser) {
   				var receiverId = "";
   				selUserList = document.querySelectorAll("#orglistView tr.selectTR");
   				if(!isUser){
   					selUserList = getSelUserInfo(isUser);
   				}
	   			if((selUserList && selUserList.length === 1) || isUser == false){
		   			if ((selUserId != "" && selUserId != undefined) || isUser == false) {
		   				var chkFlag = true;
		   				getSelUserInfo(isUser);
		   				
			   			var headManagerId = parent.opener.headManagerId;
			   			if(receiverId === headManagerId){
			   				chkFlag = false;
			   			}
			   			
			   			for(var i = 0; i < authList.length; i++) {
			   				if (authList[i].userId == receiverId) {
			   					chkFlag = false;
			   				}
			   			}
			   			
			   			userAddToList(chkFlag);
			   			
			   			drawReceiverList(authName);
			   			selMainListUserId = "";
		   			} else {
		   				alert("<spring:message code='ezPMS.t164' />");
		   			}
	   			} else if (selUserList && selUserList.length > 1){
	   				
	   				for(var i = 0; i < selUserList.length; i++) {
	   					var chkFlag = true;
	   					receiverId = selUserList[i].getAttribute("id");
			   			userName = selUserList[i].getAttribute("name");
			   			userDept = selUserList[i].getAttribute("dept");
			   			userIdType = "user";
			   			
			   			var headManagerId = parent.opener.headManagerId;
			   			if(receiverId === headManagerId){
			   				chkFlag = false;
			   			}
			   			
			   			for(var j = 0; j < authList.length; j++) {
			   				if (authList[j].userId == receiverId) {
			   					chkFlag = false;
			   					break;
			   				}
			   			}
			   			
			   			if(chkFlag){
				   			userAddToList(chkFlag);
			   			}
	   				}
	   					
		   			drawReceiverList(authName);
		   			selMainListUserId = "";
	   			}
	   			
				setMemberCNT();
  				
				scrollToBottom(authName);
				
				if (authName == "manager") {
	   				SelectReceiverWindow(manager, managerList);
	   			} else if (authName == "participant") {
	   				SelectReceiverWindow(participant, participantList);
	   			} else {
	   				SelectReceiverWindow(viewer, viewerList);
	   			}
				
				function userAddToList(chkFlag){
					if (chkFlag) {
		   				if (authName == "manager") {
		   					managerArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : 1, "userDeptname" : userDept, "userIdType" : userIdType});
		   					authList.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : 1, "userDeptname" : userDept});
		   				} else if (authName == "participant") {
		   					participantArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : 2, "userDeptname" : userDept, "userIdType" : userIdType});
		   					authList.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : 2, "userDeptname" : userDept});
		   				} else {
		   					viewerArray.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : 3, "userDeptname" : userDept, "userIdType" : userIdType});
		   					authList.push({"userName" : userName, "userId" : receiverId, "memberRoleId" : 3, "userDeptname" : userDept});
		   				}
		   			} else {
		   				alert("<spring:message code='ezPMS.t163' />");
		   			}
				}
				
				function getSelUserInfo(isUser){
					if (isUser == false) {
		   				var deptId = $(".jstree-clicked").attr('id');
		   				var regExp2 = deptId.lastIndexOf("_");
		   				deptId = deptId.substring(0,regExp2);
		   				receiverId = deptId;
		   				
			   			var str = $(".jstree-clicked").text();
		   				userDept = str;
		   				userName = str;
		   				
		   				userIdType = "dept";
		   			} else {
		   				receiverId = selUserId;
			   			userName = selUserName;
			   			userDept = selUserDept;
			   			userIdType = "user";
		   			}
				}
	   		}
	   		
	   		// 선택된 수신자배열에서 특정 사원 삭제
		    function deleteReceiver(typeName) {
	   			var authName = typeName.id;
	   			var tableId = {
	   					"manager" : "managerList",
	   					"participant" : "participantList",
	   					"viewer" : "viewerList"
	   			}
	   			var tableObj = document.getElementById(tableId[authName]);
	   			var selectedList = tableObj.getElementsByClassName("selectTR");
	   			
	   			for(var i = 0; i < selectedList.length; i++){
	   				var elem = selectedList[i];
	   				var id = elem.getAttribute("id").replace(tableId[authName] + "_", "")
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
		   			} else if (authName == "participant") {
		   				for(var j = 0; j < participantArray.length; j++) {
				    		if (participantArray[j].userId === selectedUserId) {
				    			participantArray.splice(j, 1);
				    			selMainListUserId = "";
				    		}
				    	} 
		   			} else {
		   				for(var j = 0; j < viewerArray.length; j++) {
				    		if (viewerArray[j].userId === selectedUserId) {
				    			viewerArray.splice(j, 1);
				    			selMainListUserId = "";
				    		}
		   				} 
		   			}
	   			}
	   			
		     	
		     	drawReceiverList(authName);
	   			setMemberCNT();
		    }
	   		
	   		// 선택된 수신자 배열을 토대로 화면에 그리는 곳
	   		function drawReceiverList(authName) {
		    	var strHTML = "";
		    	
		    	if (authName == "manager") {
		    		for (var i = 0; i < managerArray.length; i++) {
		    			if(managerArray[i].userId != parent.opener.headManagerId){
				    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
				    		strHTML += "<tr style='cursor:pointer;' id='managerList_" + managerArray[i].userId + "' class='hover' name='" + managerArray[i].userName + "' dept='" + managerArray[i].userDeptname + "' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(manager)' data-rowidx=" + i +">";
				    		strHTML += "<td>";
				    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
				    		strHTML += managerArray[i].userName;
				    		strHTML += "(" + managerArray[i].userDeptname + ")";
				    		strHTML += "</td>";
				    		strHTML += "</tr>";
				    		strHTML += "</table>";
		    			}
			    	}
		    		$("#managerList").html(strHTML);
		    	} else if (authName == "participant") {
		    		for (var i = 0; i < participantArray.length; i++) {
			    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
			    		strHTML += "<tr style='cursor:pointer;' id='participantList_" + participantArray[i].userId + "' class='hover' name='" + participantArray[i].userName + "' dept='" + participantArray[i].userDeptname + "' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(participant)' data-rowidx=" + i +">";
			    		strHTML += "<td>";
			    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
			    		strHTML += participantArray[i].userName;
			    		strHTML += "(" + participantArray[i].userDeptname + ")";
			    		strHTML += "</td>";
			    		strHTML += "</tr>";
			    		strHTML += "</table>";
			    	}
			    	$("#participantList").html(strHTML);
		    	} else {
		    		for (var i = 0; i < viewerArray.length; i++) {
			    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
			    		strHTML += "<tr style='cursor:pointer;' id='viewerList_" + viewerArray[i].userId + "' class='hover' name='" + viewerArray[i].userName + "' dept='" + viewerArray[i].userDeptname + "' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(viewer)' data-rowidx=" + i +">";
			    		strHTML += "<td>";
			    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
			    		strHTML += viewerArray[i].userName;
			    		strHTML += "(" + viewerArray[i].userDeptname + ")";
			    		strHTML += "</td>";
			    		strHTML += "</tr>";
			    		strHTML += "</table>";
			    	}
			    	$("#viewerList").html(strHTML);
		    	}
		    	
		    }
	   		
	   		function applyReceiver(authName) {
  				setAuthorViewUser(authName.id, true);
	   		}
	   		
	   		$(document).ready(function() {
	   			
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
			    
	   			treeContent = ${deptList};
	   			$("#1tab1").click();
	            ChangeTab(document.getElementById("1tab1"));
		   		setDeptList();
		   		
	   			if ($(opener.managerList).length > 0 || $(opener.participantList).length > 0 ||  $(opener.viewerList).length > 0) {
		   			managerArray = opener.managerList;
		   			participantArray = opener.participantList;
		   			viewerArray = opener.viewerList;
		   			
		   			authList = authList.concat(managerArray);
		   			authList = authList.concat(participantArray);
		   			authList = authList.concat(viewerArray);
		   			
	   				drawReceiverList("manager");
	   				drawReceiverList("participant");
	   				drawReceiverList("viewer");
	   			} /* else {
		   			authList.push({"userName" : userName, "userId" : userId, "memberRoleId" : 1, "userDeptname" : replaceString(userDept)});
		   			managerArray.push({"userName" : userName, "userId" : userId, "memberRoleId" : 1, "userDeptname" : replaceString(userDept), "userIdType" : "user"});
		   			drawReceiverList("manager");
	   			} */
		   		
	   			$(function () {
		   			$(document).on({
		   				"dblclick" : function() {
		   					delTargetDept(this);
		   				},
		   				"click" : function() {
		   					targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
		   			
		   			if (type == "managers") {
		   				SelectReceiverWindow(manager, managerList);
		   			} else if (type == "participants") {
		   				SelectReceiverWindow(participant, participantList);
		   			} else {
		   				SelectReceiverWindow(viewer, viewerList);
		   			}
	   			});
	   			
	   			setMemberCNT();
	   			add_key_event();
	   			disable_browser_selection();
   			});
	   		
	   		var Tab1_SelectID = "1tab1";
		    function ChangeTab(obj) {
		    	var pSelectTab = GetAttribute(obj, "tdname");

		        switch (pSelectTab) {
		            case "journalOrgan":
		                if (document.getElementById("journalOrgan_content").style.display == "none") {
		                    document.getElementById("journalOrgan_content").style.display = "";
		                   	$("#List_TBODY tr").css("backgroundColor", "#ffffff"); // 탭 바꾸면 즐겨찾기에 선택되어있던 것 해제
		                    $("#dblarrow").css("display", "none");
		                }
		                
		                break;
		    	}
		        
		        selMainListUserId = "";
				selUserId = "";
		    }
	   		
	   		function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            
	            if (obj.id != Tab1_SelectID) {
	                if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";

	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	   		
	   		function ok_Click() {	   			
	   			parent.opener.managerList = JSON.stringify(managerArray);
		   		parent.opener.participantList = JSON.stringify(participantArray);
		   		parent.opener.viewerList = JSON.stringify(viewerArray);
		   		parent.opener.applyList();
		   		
		   		window.close();
	   			
// 	   			selectHeadManager();
	   			//opener.selReceiver = JSON.stringify(receiverList);
	   			//opener.showReceiver();
	   			//window.close();
	   		}
	   		
// 	   		function selectHeadManager() {
// 	   			var feature = GetOpenPosition(150, 150);
// 	   			DivPopUpShow(400, 300, "/ezPMS/selectHeadManager.do");
// 	   		}
	   		
	   		function deptSelect() {
	   			setAuthorViewUser(type, false);
	   		}
	   		
	   		// 담당자, 참여자, 조회자 인원을 표시
	   		function setMemberCNT() {	   			
	   			$("#managerCNT").text("<spring:message code='ezPMS.t44' arguments='" + managerArray.length + "'/>");
	   			$("#participantCNT").text("<spring:message code='ezPMS.t44' arguments='" + participantArray.length + "'/>");
	   			$("#viewerCNT").text("<spring:message code='ezPMS.t44' arguments='" + viewerArray.length + "'/>");
	   		}
	   		
	   		// 담당자, 참여자, 조회자 추가 시 스크롤바를 밑으로 내려줌
	   		function scrollToBottom(authName) {
	   			switch (authName) {
				case "manager":
					$("#managerList").animate({
	  					scrollTop : $("#managerList").prop("scrollHeight")
	  				});
					break;
				case "participant":
					$("#participantList").animate({
	  					scrollTop : $("#participantList").prop("scrollHeight")
	  				});
					break;
				case "viewer":
					$("#viewerList").animate({
	  					scrollTop : $("#viewerList").prop("scrollHeight")
	  				});
					break;
	   			}
	   		}
	   		
	   		function listEventFunc(obj, event){
	   			var listEventCheckbox;
	   			if (!listEventCheckbox) {
		            if (!PressShiftKey && !PressCtrlKey && listContentArry.length > 0) {
		                for (var Cnt = 0 ; Cnt < listContentArry.length; Cnt++) {
		                    p_ListOrderObject = document.getElementById(listContentArry[Cnt]);
		                    
		                    if (p_ListOrderObject != null) {
		                    	cancelSelectTr(obj);
// 			                    for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
// 			                        p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorDefault;
// 			                    }
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
// 		                        for (var RowCnt = 0; RowCnt < p_ListOrderObject.childNodes.length; RowCnt++) {
// 		                            p_ListOrderObject.childNodes.item(RowCnt).style.backgroundColor = m_strColorSelect;
// 		                        }
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
	   			} else if ($(elem).parent().parent().parent().attr("id") === "viewerList"){
		   			$("#viewerList tr").removeClass("selectTR");
		   			tableId = "viewerList";
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			} else if (document.getElementById("DeptUserImgList")){
	   				$("#DeptUserImgList tr").removeClass("selectTR");
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
        <h1 style="height: 20px;"><spring:message code='ezPMS.t162' /></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()"></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
            selToggleList(document.getElementById("close"), "ul", "li", "0");
        </script>
	    <table style="width:100%">
			<tr>
				<td>
					<table id="TreeViewTD">
					 	<tr>
			                <div class="portlet_tabpart01">
			                	<div class="portlet_tabpart01_top" id="tab1">
					            	<p><span id="1tab1" tdname="journalOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)"><spring:message code='ezPMS.t165' /></span></p>
					        	</div>
					        </div>
				        	<td id="journalOrgan_content" style="display: none;">
				        		<div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px; padding:0px; border-top: none;">
				                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2;">
				                        <table style="margin-top: 3px; width: 100%;">
				                            <tr>
				                                <td>
				                                    <div style="float: left; margin-left: 5px;">
				                                        <select id="search_type">
				                                            <option selected value="displayname"><spring:message code='ezOrgan.t67'/></option>
								                            <option value="cn"><spring:message code='ezOrgan.t94'/></option>
								                            <option value="description"><spring:message code='ezOrgan.t68'/></option>
								                            <option value="title"><spring:message code='ezOrgan.t69'/></option>
								                            <option value="telephonenumber"><spring:message code='ezOrgan.t95'/></option>
								                            <option value="mobile"><spring:message code='ezOrgan.t96'/></option>
								                            <option value="HomePhone"><spring:message code='ezOrgan.t97'/></option>
								                            <option value="facsimileTelephoneNumber"><spring:message code='ezOrgan.t98'/></option>
								                            <c:if test="${primaryLang eq '3' }">
		                                                    <option value="extensionPhone" usedefault="0"><spring:message code='main.ksa02' /></option>
		                                                    <option value="officeMobile" usedefault="0"><spring:message code='main.ksa03' /></option>
		                                                    </c:if>
								                            <option value="mail"><spring:message code='ezOrgan.t99'/></option>
								                            <option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100'/></option>
				                                        </select>
				                                        <input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){search_click(); return false;}" value="" style="width: 130px; margin: 0px;" />
				                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101'/></span></a>
				                                    </div>
				                                </td>
				                                <td>
				                                    <div style="float: right; margin-right: 5px; position: relative;">
				                                       <a class="imgbtn"><span onclick="deptSelect()"><spring:message code='ezPMS.t166' /></span></a>
				                                    </div>
				                                </td> 
				                                <td></td>   
				                            </tr>
				                        </table>
				                    </div>
			                  	</div>
								<table style="margin-top: 3px;">
						            <tr>
						                <td class="box" style="border-right: 0px; height: 465px;">
						                    <div style="width: 250px; height: 470px; overflow-x: auto; overflow-y: auto;" id="treeview"></div>
						                </td>
						                <td></td>
						                <td class="listview" style="width: 426px" id="orglistView">
						                </td>    
						            </tr>
						        </table>
		                  	</td>   
		                  	
	                        <td style="width: 30px; text-align: center;">
	                        	<div>
	                            	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(manager)"><br>
	                            	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(manager)">
	                        	</div>                            
	                            <div style="margin-top:100px;">
	                            	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(participant)"><br>
	                            	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(participant)">
	                        	</div>
	                        	<div style="margin-top:100px;">
	                            	<img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(viewer)"><br>
	                            	<img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(viewer)">
	                        	</div>
	                        </td>
	                        
	                        <td style="vertical-align: top;">
	                        	<div style="display: inline-flex; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="manager" onclick="SelectReceiverWindow(manager,managerList)">
											<spring:message code='ezPMS.t63' /> (<span id="managerCNT" style="padding: 0px; color: #017BEC;"></span>)
										</span>
									</h2>
								</div>
								<div class="receiver_borderbox">
									<div id="managerList" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto; background-color: rgb(246, 246, 246); cursor: pointer;" onclick="SelectReceiverWindow(manager,managerList)"></div>
								</div>
								
								<div style="display: inline-flex; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="participant" onclick="SelectReceiverWindow(participant,participantList)">
											<spring:message code='ezPMS.t64' /> (<span id="participantCNT" style="padding: 0px; color: #017BEC;"></span>)
										</span>
									</h2>
								</div>
								<div class="receiver_borderbox">
									<div id="participantList" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto; background-color: rgb(246, 246, 246); cursor: pointer;" onclick="SelectReceiverWindow(participant,participantList)"></div>
								</div>
								
								<div style="display: inline-flex; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="viewer" onclick="SelectReceiverWindow(viewer,viewerList)">
											<spring:message code='ezPMS.t65' /> (<span id="viewerCNT" style="padding: 0px; color: #017BEC;"></span>)
										</span>
									</h2>
								</div>
								<div class="receiver_borderbox">
									<div id="viewerList" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto; background-color: rgb(246, 246, 246); cursor: pointer;" onclick="SelectReceiverWindow(viewer,viewerList)"></div>
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

