<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPMS.t330' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/jstree/style.css')}" type="text/css" />

		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jstree/jstree.js')}"></script>
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
	   		
	   		// 리스트에서 클릭이벤트 적용
	   		function setUserAuthorDept(elem) {
	   			if ($(elem).parent().attr("id") === "List_TBODY2") {
	   				$("#List_TBODY2 tr").removeClass("selectTR");
	   			} else if ($(elem).parent().parent().parent().attr("id") === "txtlist_Layer") {
		   			$("#txtlist_Layer tr").removeClass("selectTR");
	   			} else if (document.getElementById("DeptUserImgList")){
	   				$("#DeptUserImgList tr").removeClass("selectTR");
	   			}
	   			
	   			$(elem).addClass("selectTR");
	   			selUserId = $(elem).attr("id");
	   			selUserName = $(elem).attr("name");
	   			selUserDept = $(elem).attr("dept");
	   			// console.log("selUserId : " + selMainListUserId)
	   		}
	   		
	   		// 선택한 사람을 권한 추가
	   		function setAuthorViewUser(authName, isUser) {
	   			ok_Click();
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
		   		
// 	   			if ($(opener.managerList).length > 0 || $(opener.participantList).length > 0 ||  $(opener.viewerList).length > 0) {
// 		   			managerArray = opener.managerList;
// 		   			participantArray = opener.participantList;
// 		   			viewerArray = opener.viewerList;
		   			
// 		   			authList = authList.concat(managerArray);
// 		   			authList = authList.concat(participantArray);
// 		   			authList = authList.concat(viewerArray);
		   			
// 	   			} else {
// 		   			authList.push({"userName" : userName, "userId" : userId, "memberRoleId" : 1, "userDeptname" : replaceString(userDept)});
// 		   			managerArray.push({"userName" : userName, "userId" : userId, "memberRoleId" : 1, "userDeptname" : replaceString(userDept), "userIdType" : "user"});
// 	   			}
	   			authList.push({"userName" : userName, "userId" : userId, "memberRoleId" : 1, "userDeptname" : replaceString(userDept)});
// 	   			managerArray.push({"userName" : userName, "userId" : userId, "memberRoleId" : 1, "userDeptname" : replaceString(userDept), "userIdType" : "user"});
		   		
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
	   		
	   		function ok_Click() {
	   			if(!validChkFunc()){
	   				alert("<spring:message code='ezPMS.t163' />");
	   				return;
	   			}
	   			
	   			if (!(selUserId  || parent.opener.headManagerId)) {
	   				alert("<spring:message code='ezPMS.t333'/>");
	   				return;
	   			}
	   			
	   			if(parent.opener.headManagerObj && selUserId){
		   			parent.opener.headManagerId = selUserId;
		   			parent.opener.headManagerName = selUserName;
		   			parent.opener.headManagerDept = selUserDept;
		   			
		   			parent.opener.headManagerObj.userId = selUserId;
		   			parent.opener.headManagerObj.userName = selUserName;
		   			parent.opener.headManagerObj.userDept = selUserDept;
		   			
		   			parent.opener.applyHeadManager();
	   			}
	   			
	   			window.close();
	   		}
	   		
	   		function validChkFunc(){
	   			var ml = parent.opener.managerList;
	   			var pl = parent.opener.participantList;
	   			var vl = parent.opener.viewerList;
	   			var flag = true;
	   			
	   			Array.prototype.concat(ml, pl, vl).forEach(function(elem){
	   				if(elem.userId === selUserId){
	   					flag = false;
	   				}
	   			});
	   			
	   			return flag;
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
        <h1 style="height: 20px;"><spring:message code='ezPMS.t330' /></h1>
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
					            	<p><span id="1tab1" tdname="journalOrgan" style="min-width: 45px; cursor:pointer"><spring:message code='ezPMS.t165' /></span></p>
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
								                            <option value="streetAddress" style="display:none"><spring:message code='ezOrgan.t100'/></option>
				                                        </select>
				                                        <input id="keyword" onfocus="journalKeywordClear(this);" onkeypress="if(event.keyCode==13){search_click(); return false;}" value="" style="width: 130px; margin: 0px;" />
				                                        <a class="imgbtn"><span onclick="search_click()"><spring:message code='ezOrgan.t101'/></span></a>
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

