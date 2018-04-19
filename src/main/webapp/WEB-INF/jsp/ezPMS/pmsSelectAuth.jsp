<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title>담당자, 참여자, 조회자 추가</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezPMS.e1' />" type="text/css" />
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/jstree/jstree.js"></script>
	   	<script type="text/javascript">
	   		//트리조직도 JSON
	   		var treeContent;
	   		// 선택된 수신자 배열
	   		var receiverList = [];
	   		
	   		var managerArray = [];
	   		var participantArray = [];
	   		var viewerArray = [];
	   		
	   		// 선택된 수신자 이름
	   		var userName = "";
	   		// 선택된 수신자 아이디
	   		var selUserId = "";
	   		// 선택된 수신자 이름
	   		var selUserName = "";
	   		// 현재 로그인된 사용자 아이디
	   		var userId = "<c:out value='${userId}'/>";
	   		// 즐겨찾기 아이디
	   		var favoriteId = "";
	   		
	   		var type = "<c:out value='${type}'/>";
	   		//올른쪽 리스트에서 선택된 유저
	   		var selMainListUserId="";
	   		var selMainListUserName="";
	   		
	   		var p_title = null;
	   		var p_selectedWindow = null;
	   		var authName = null;
	   		
	   		$(function() {
	   			if (type == "managers") {
	   				SelectReceiverWindow(manager, managerList);
	   			} else if (type == "participants") {
	   				SelectReceiverWindow(participant, participantList);
	   			} else {
	   				SelectReceiverWindow(viewer, viewerList);
	   			}
	   		});
	   		
	   		function close_Click(){
	   			window.close();
	   		}
	   		
	   		//조직도 뿌리는 펑션
	   		function setDeptList(){
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
					var offset = $(".jstree-clicked").offset();
		   	        $('#treeview').animate({scrollTop : offset.top}, 0);
			    });
	   		}
	   		
	   		//사원 리스트 뿌리기
	   		function setUserList(key, value,deptName){
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/ezPMS/userList.do",
	   				data:{"key" : key, "value" : value,"deptName":deptName},
	   				success: function(result){
	   					var picList = $(result).find(".organwrap");
	   					if(picList.length==0 && key!="DEPARTMENT"){
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
	   			if(value){
		   			setUserList(key, value);
	   			} else {
	   				alert("<spring:message code='ezSchedule.t8'/>")
	   			}
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
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "managerList"){
		   			$("#managerList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "participantList"){
		   			$("#participantList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "viewerList"){
		   			$("#viewerList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			}
	   			$(elem).addClass("selectTR");
	   			selMainListUserId = $(elem).attr("id");
	   			selMainListUserName = $(elem).attr("name");
	   			// console.log("selMainListUserId : " + selMainListUserId)
	   		}
	   		
	   		// 리스트에서 클릭이벤트 적용
	   		function setUserAuthorDept(elem) {
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "managerList"){
		   			$("#managerList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "participantList"){
		   			$("#participantList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "viewerList"){
		   			$("#viewerList tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			}
	   			$(elem).addClass("selectTR");
	   			selUserId = $(elem).attr("id");
	   			selUserName = $(elem).attr("name");
	   			// console.log("selUserId : " + selMainListUserId)
	   		}
	   		
	   		// 선택한 사람을 권한 추가
	   		function setAuthorViewUser(authName) {
	   			if (selUserId != "" && selUserId != undefined) {
		   			var receiverId = selUserId;
		   			userName = selUserName;
		   			var chkFlag = true;
		   			
		   			if (authName == "manager") {
			   			for(var i = 0; i < managerArray.length; i++) {
			   				if (managerArray[i].userId == receiverId) {
			   					chkFlag = false;
			   				}
			   			}
			   			
			   			if (chkFlag) {
			   				managerArray.push({"userName" : userName, "userId" : receiverId});
			   			} else {
				   			alert("선택된 항목입니다.");
			   			}
			   			
			   			drawReceiverList(authName);
			   			selMainListUserId = "";
		   			} else if (authName == "participant") {
		   				for(var i = 0; i < participantArray.length; i++) {
			   				if (participantArray[i].userId == receiverId) {
			   					chkFlag = false;
			   				}
			   			}
			   			
			   			if (chkFlag) {
			   				participantArray.push({"userName" : userName, "userId" : receiverId});
			   			} else {
				   			alert("선택된 항목입니다.");
			   			}
			   			drawReceiverList(authName);
		   			} else {
		   				for(var i = 0; i < viewerArray.length; i++) {
			   				if (viewerArray[i].userId == receiverId) {
			   					chkFlag = false;
			   				}
			   			}
			   			
			   			if (chkFlag) {
			   				viewerArray.push({"userName" : userName, "userId" : receiverId});
			   			} else {
				   			alert("선택된 항목입니다.");
			   			}
			   			drawReceiverList(authName);
		   			}
		   			
	   			} else {
	   				alert("수신자를 선택해 주십시오.");
	   			}
	   			
	   		}
	   		
	   		// 선택된 수신자배열에서 특정 사원 삭제
		    function deleteReceiver(typeName) {
	   			var authName = typeName.id;
	   			
	   			if (authName == "manager") {
	   				for(var j = 0; j < managerArray.length; j++) {
			    		if (managerArray[j].userId === selMainListUserId) {
			    			managerArray.splice(j, 1);
			    			selMainListUserId = "";
			    		}
			    	} 
			     	drawReceiverList(authName);
	   			} else if (authName == "participant") {
	   				for(var j = 0; j < participantArray.length; j++) {
			    		if (participantArray[j].userId === selMainListUserId) {
			    			participantArray.splice(j, 1);
			    			selMainListUserId = "";
			    		}
			    	} 
			     	drawReceiverList(authName);
	   			} else {
	   				for(var j = 0; j < viewerArray.length; j++) {
			    		if (viewerArray[j].userId === selMainListUserId) {
			    			viewerArray.splice(j, 1);
			    			selMainListUserId = "";
			    		}
			    	} 
			     	drawReceiverList(authName);
	   			}
		     	
		    }
	   		
	   		// 선택된 수신자 배열을 토대로 화면에 그리는 곳
	   		function drawReceiverList(authName) {
		    	var strHTML = "";
		    	
		    	if (authName == "manager") {
		    		for (var i = 0; i < managerArray.length; i++) {
			    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
			    		strHTML += "<tr style='cursor:pointer;' id=" + managerArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(manager)'>";
			    		strHTML += "<td>";
			    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
			    		strHTML += managerArray[i].userName;
			    		strHTML += "</td>";
			    		strHTML += "</tr>";
			    		strHTML += "</table>";
			    	}
		    		$("#managerList").html(strHTML);
		    	} else if (authName == "participant") {
		    		for (var i = 0; i < participantArray.length; i++) {
			    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
			    		strHTML += "<tr style='cursor:pointer;' id=" + participantArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(participant)'>";
			    		strHTML += "<td>";
			    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
			    		strHTML += participantArray[i].userName;
			    		strHTML += "</td>";
			    		strHTML += "</tr>";
			    		strHTML += "</table>";
			    	}
			    	$("#participantList").html(strHTML);
		    	} else {
		    		for (var i = 0; i < viewerArray.length; i++) {
			    		strHTML += "<table style='width: 100%; border: 0; padding: 0;' class='mainlist_free'>";
			    		strHTML += "<tr style='cursor:pointer;' id=" + viewerArray[i].userId + " class='hover' onclick='setMainListUserAuthorDept(this)' ondblclick='deleteReceiver(viewer)'>";
			    		strHTML += "<td>";
			    	//	strHTML += receiverList[i].userName.replace(/<(\/)?([a-zA-Z]*)(\s[a-zA-Z]*=[^>]*)?(\s)*(\/)?>/ig, "");
			    		strHTML += viewerArray[i].userName;
			    		strHTML += "</td>";
			    		strHTML += "</tr>";
			    		strHTML += "</table>";
			    	}
			    	$("#viewerList").html(strHTML);
		    	}
		    	
		    }
	   		
	   		function applyReceiver(authName) {
  				setAuthorViewUser(authName.id);
	   		}
	   		
	   		$(document).ready(function() {
	   			treeContent = ${deptList};
	   			$("#1tab1").click();
	            ChangeTab(document.getElementById("1tab1"));
		   		setDeptList();
	   			if ($(opener.selReceiver).length > 0) {
	   				receiverList = opener.selReceiver;
	   				drawReceiverList();
	   			}
		   		
	   			$(function () {
		   			$(document).on({
		   				"dblclick":function(){delTargetDept(this);},
		   				"click":function(){targetDept = this;
			   				$("*").removeClass("selectTR");
				   			$(this).addClass("selectTR");
		   				}
	   				},"#lplistView tr");
	   			});
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
	   			opener.selReceiver = JSON.stringify(receiverList);
	   			opener.showReceiver();
	   			window.close();
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
        <h1 style="height: 20px;">수신자 선택</h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="ok_Click()">확인</span></li>
	            <li><span onclick="close_Click()">취소</span></li>
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
					            	<p><span id="1tab1" tdname="journalOrgan" style="min-width: 45px; cursor:pointer" onclick="Tab1_MouseClick(this)">조직도</span></p>
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
								                            <option value="mail"><spring:message code='ezOrgan.t99'/></option>
								                            <option value="streetAddress"><spring:message code='ezOrgan.t100'/></option>
				                                        </select>
				                                        <input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){search_click(); return false;}" value="" style="width: 130px; margin: 0px;" />
				                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101'/></span></a>
				                                    </div>
				                                </td>
				                                <td>
				                                    <div style="float: right; margin-right: 5px; position: relative;">
				                                       
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
	                            	<img src="/images/arr_r.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(manager)"><br>
	                            	<img src="/images/arr_l.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(manager)">
	                        	</div>                            
	                            <div style="margin-top:100px;">
	                            	<img src="/images/arr_r.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(participant)"><br>
	                            	<img src="/images/arr_l.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(participant)">
	                        	</div>
	                        	<div style="margin-top:100px;">
	                            	<img src="/images/arr_r.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer; margin-top: 10px;" onclick="applyReceiver(viewer)"><br>
	                            	<img src="/images/arr_l.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="deleteReceiver(viewer)">
	                        	</div>
	                        </td>
	                        
	                        <td style="vertical-align: top;">
	                        	<div style="display: inline-flex; border-bottom: 1px solid #565b66; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="manager" onclick="SelectReceiverWindow(manager,managerList)">담당자 </span>
									</h2>
								</div>
								<div class="receiver_borderbox">
									<div id="managerList" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto; background-color: rgb(246, 246, 246); cursor: pointer;" onclick="SelectReceiverWindow(manager,managerList)"></div>
								</div>
								
								<div style="display: inline-flex; border-bottom: 1px solid #565b66; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="participant" onclick="SelectReceiverWindow(participant,participantList)">참여자 </span>
									</h2>
								</div>
								<div class="receiver_borderbox">
									<div id="participantList" style="width: 250px; Height: 134px; overflow-x: auto; overflow-y: auto; background-color: rgb(246, 246, 246); cursor: pointer;" onclick="SelectReceiverWindow(participant,participantList)"></div>
								</div>
								
								<div style="display: inline-flex; border-bottom: 1px solid #565b66; width: 100%;">
		                            <h2 class="receiver_tltype01" style="margin-top:4px;">
										<span style="min-width: 45px; font-weight: normal; cursor: pointer;" id="viewer" onclick="SelectReceiverWindow(viewer,viewerList)">조회자 </span>
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
        <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank_kr.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div> 
	</body>
</html>

