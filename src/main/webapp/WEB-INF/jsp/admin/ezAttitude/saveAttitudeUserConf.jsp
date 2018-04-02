<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title>title</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <link rel="stylesheet" href="/css/jstree/style.css" type="text/css" />
	    <style>
	    	.box {
	    		border-right:0px;
	    	}
	    </style>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/jstree/jstree.js"></script>
		<script type="text/javascript" language="javascript">
		    var ReturnFunction;
		    var treeContent = ${deptList};
		    var companyId = '${companyId}';
		    var userList = ${userList};
		    var selectedUserId;
		    //회사 근무 시작/종료시간 - 기본설정적용시 필요
		    var comStartTime = '${workStartTime}';
		    var comEndTime = '${workEndTime}';
			
		    $(document).ready(function(){
		    	setDeptList();
		    	
		    	if (userList != null && userList != "null") {
		    		$.each(userList, function(idx, userInfo) {
	   					var html = "<tr id='" + userInfo.userId + "' class='hover'>";
	   					html += "<td style='cursor: pointer; padding-left:60px;'>" + userInfo.userName + "</td>";
	   					if(userInfo.workStartTime == null || userInfo.workStartTime == '' || userInfo.workEndTime == null || userInfo.workEndTime == '') {
	   						html += "<td></td>";
	   					} else {
		   					html += "<td>" + userInfo.workStartTime + " ~ " + userInfo.workEndTime + "</td>";
	   					}
	   					html += "</tr>";
	   					
	   					$(html).appendTo('#txtlist_table2');
					})
		    	}
// 		    	try {
// 	                ReturnFunction = opener.permissions_check_dialogArguments[1];
// 	            } catch (e) {}	        

// 		        try {
// 		            var ua = navigator.userAgent;
// 		            if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
// 		                var input = document.getElementsByTagName("input");
		                
// 		                for (var i = 0; i < input.length; i++) {
// 		                    if (input[i].getAttribute("type") == "text") {
// 		                        KeEventControl(input[i]);
// 		                    }
// 		                }
// 		            }
// 		        } catch (e) {}
		    })
		    //부서 리스트
	   		function setDeptList(){
				$('#treeView').on('changed.jstree', function (e, data) {
			     	var id = data.instance.get_node(data.selected).id;
					setUserList("DEPARTMENT",id);
				  })
				.jstree({ 
					'core' : {'data' : treeContent},
					'plugins': ["wholerow"],
					 'themes' : {'responsive' : true}
				});
	   		}
	   		//사원 리스트 뿌리기
	   		function setUserList(key,value){
// 	   			selectedUserId = "";
	   			$.ajax({
	   				type:"post",
	   				dataType:"html",
	   				url:"/admin/ezAttitude/deptUserList.do",
	   				data:{"key":key, "value":value},
	   				success: function(result){
	   					$("#orglistView").html(result);
	   				}
	   			});
	   		}
	   		//사원선택
	   		function setAuthorViewUser(){
	   			var userId = selectedUser;
				var url = "/admin/ezJournal/authorView.do";
				var companyId = opener.companyId;
				url+="?companyId="+companyId;
				if (userId) {
					url+="&userId="+userId+"&userName="+selectedUserName;
				} else {
					alert("<spring:message code='ezPortal.t85' />");
				}
				window.open(url, "authorView", "width=500, height=180");
				window.close();
	   		}
// 	   		//선택된 사원
	   		function setUserAuthorDept(elem){
	   			selectedUserId = $(elem).attr("id");
	   			$("*").removeClass("selectTR");
	   			$(elem).addClass("selectTR");
	   		}
	   		// [->] 클릭시
	   		function InsertReceiver() {
	   			var trIdx = $('#txtlist_table2').find('tr').length;
	   			for (var i = 0; i < trIdx; i++) {
	   				if ($('#txtlist_table2 tr').eq(i).attr('id') == selectedUserId) {
	   					alert('이미 선택되었습니다');
	   					return;
	   				}
	   			}
	   			
	   			if(selectedUserId != ""){
		   			$.ajax({
		   				type:"post",
		   				dataType:"json",
		   				url:"/admin/ezAttitude/selectUserInfo.do",
		   				data:{
		   					"userId" : selectedUserId,
		   					"companyId" : companyId
		   				},
		   				success: function(result){
		   					for (var i = 0; i < result.length; i++) {
			   					var html = "<tr id='" + result[i].userId + "' class='hover'>";
			   					html += "<td style='cursor: pointer; padding-left:60px;'>" + result[i].userName + "</td>";
			   					if(result[i].workStartTime == null || result[i].workStartTime == '' || result[i].workEndTime == null || result[i].workEndTime == '') {
			   						html += "<td></td>";
			   					} else {
				   					html += "<td>" + result[i].workStartTime + " ~ " + result[i].workEndTime + "</td>";
			   					}
			   					html += "</tr>";
			   					$(html).appendTo('#txtlist_table2');
		   					}
		   				}
		   			});
	   			}
	   		}
			// 시간바꾸는 리스트에서 사원 클릭시 tr배경색 변경
	   		$(document).on('click', '#txtlist_table2 tr' ,function() {
	   			$("*").removeClass("selectTR");
	   			$(this).addClass("selectTR");
	   		})
	   		// [<-] 클릭시
	   		function DeleteReceiver() {
		   		$('#txtlist_table2 tr[class*=selectTR]').remove();
	   		}
	   		//설정시간적용
	   		function userTimeApply(type) {
	   			var trIdx = $('#txtlist_table2').find('tr').length;
	   			if(trIdx == 0) {
	   				alert('사원을 선택해 주세요');
	   				return;
	   			}
	   			
	   			if(type == 'modify') {
	   				if($('#startHrs').val() == "" || $('#startHrs').val() == null){
	   					alert('시간을 입력해주세요');
	   					return;
	   				}
	   				if($('#startMin').val() == "" || $('#startMin').val() == null){
	   					alert('시간을 입력해주세요');
	   					return;
	   				}
	   				if($('#endHrs').val() == "" || $('#endHrs').val() == null){
	   					alert('시간을 입력해주세요');
	   					return;
	   				}
	   				if($('#endMin').val() == "" || $('#endMin').val() == null){
	   					alert('시간을 입력해주세요');
	   					return;
	   				}
	   			} else {
	   				$('#startHrs').val(comStartTime.split(':')[0]);
	   				$('#startMin').val(comStartTime.split(':')[1]);
	   				$('#endHrs').val(comEndTime.split(':')[0]);
	   				$('#endMin').val(comEndTime.split(':')[1]);
	   			}
	   			
	   			var trIdx = $('#txtlist_table2').find('tr').length;
	   			for (var i = 0; i < trIdx; i++) {
		   			var timeStr = "";
	   				if(type == 'default') {
	   					timeStr = comStartTime + " ~ " + comEndTime;
	   				} else {
	   					timeStr += addZero($('#startHrs').val()) + ":";
	   					timeStr += addZero($('#startMin').val()) + " ~ "; 
	   					timeStr += addZero($('#endHrs').val()) + ":";
	   					timeStr += addZero($('#endMin').val());
	   				}
	   				$('#txtlist_table2 tr').eq(i).children("td").eq(1).text(timeStr);
	   			}
	   		}
	   		//시간/분 입력시 3이면 03 이렇게 되도록. 
	   		function addZero(time) {
	   			var resStr = "";
	   			if(time.length == 1) {
	   				resStr = "0" + time;
	   			} else {
	   				resStr = time;
	   			}
	   			return resStr;
	   		}
	   		//저장
	   		function OK_Click() {
	   			var trIdx = $('#txtlist_table2').find('tr').length;
	   			var userConfInfo = "";
	   			for (var i = 0; i < trIdx; i++) {
	   				var userConfTime = $('#txtlist_table2 tr').eq(i).children("td").eq(1).text().split('~');
	   				if (userConfTime == "") {
	   					alert('시간을 설정해 주세요');
	   					return;
	   				}
	   				userConfInfo += $('#txtlist_table2 tr').eq(i).attr('id') + ",";
	   				userConfInfo += userConfTime[0].trim() + ",";
	   				userConfInfo += userConfTime[1].trim() + ";";
	   			}
				//마지막 ';' 제거
	   			userConfInfo = userConfInfo.slice(0, -1);
	   			
	            $.ajax({
	            	type : "POST",
	            	url : "/admin/ezAttitude/attitudeUserConfSave.do",
	            	data : { "userConfInfoList" : userConfInfo },
	            	success : function() {
	            		alert('시간이 변경되었습니다');
	            		window.opener.company_change();
	            		window.close();
	            	},
	            	error : function() {
	            	}
	            });
	   		}
		    
	        function close_Click() {
	            if (ReturnFunction != null) {
	                ReturnFunction();
	            }
	            window.close();
	        }
	    </script>
	    <style>
			tr.hover:hover{background:#eee; color:#fff;}
			
			.selectTR{
				background-color: rgb(233, 241, 255);
			}
		</style>
	</head>
	<body class="popup">
	    <div id="menu">
	        <ul>
	            <li><span onclick="OK_Click()"><spring:message code='ezAttitude.t38' /></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()">닫기</span></li>
	        </ul>
	    </div>
	    <table id="TreeViewTD">
	        <tr>
	        	<td style="width: 650px;">
	                <div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
	                    <div class="portlet_tabpart03_top" id="tab1" style="border: 1px solid #d3d2d2; padding: 2px;">
	                        <table style="margin-top: 3px; width: 100%;">
	                            <tr>
	                                <td>
	                                	<div style="padding-left:50px">
	                                    	<input type="text" name="Input" id="deptkeyword" style="WIDTH: 110px; margin: 0px;" onkeypress="deptsearch_press()" />
	                                        <a class="imgbtn"><span onclick="deptsearch_click()">부서검색</span></a>
	                                	</div>
	                                </td>
	                                <td>
	                                    <div style="float:right">
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
	                                        <input type="text" id="keyword" value="" onkeyup="search_press(event)" onmousedown="keyword_Clear();" style="width: 130px; margin: 0px;" />
	                                        <a class="imgbtn"><span onclick="search_click()">검색</span></a>
	                                    </div>
	                                </td>    
<!-- 	                          삭제?      <td></td> -->
	                            </tr>
	                        </table>
	                    </div>
	                </div>
	                <table style="margin-top: 3px;">
	                    <tr>
	                        <td class="box">
	                            <div style="width: 240px; height: 470px; overflow-x: auto; overflow-y: auto;" id="treeView"></div>
	                        </td>
	                        <td class="listview" style="width: 426px" id="orglistView">
<!-- 	                            <table style="width: 100%; margin-top: -1px;" class="popup_mainlist"> -->
<!-- 	                                <tr> -->
<!-- 	                                    <th style="white-space:normal"> -->
<!-- 	                                        <span id="SelectDeptNM" style="font-weight: bold; width: 300px; text-overflow: ellipsis; white-space: nowrap; overflow: hidden; display: inline-block; vertical-align: bottom;"></span> -->
<!-- 	                                        <span style="float:right;"> -->
<!-- 	                                            <span onclick="ChangeListView_onClick('TXT');"><img src="/images/kr/cm/btn_list.gif" class="icon_btn" id="txtlist"></span> -->
<!-- 	                                            <span onclick="ChangeListView_onClick('IMG');"><img src="/images/kr/cm/btn_imglist.gif" class="icon_btn" id="imglist"></span> -->
<!-- 	                                        </span> -->
<!-- 	                                    </th> -->
<!-- 	                                </tr> -->
<!-- 	                            </table> -->
<!-- 	                            <div style="vertical-align: top; height: 440px; overflow: auto; width: 100%;" id="txtlist_Layer"> -->
<!-- 	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="txtlist_table" class="mainlist"> -->
<!-- 	                                    <tr> -->
<%-- 	                                        <th style="width: 100px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t67'/></th> --%>
<%-- 	                                        <th style="width: 80px; font-weight: bold;" class="td_gray"><spring:message code='ezOrgan.t69'/></th> --%>
<%-- 	                                        <th class="td_gray" style="width: 220px;font-weight: bold;"><spring:message code='ezOrgan.t97'/></th> --%>
<!-- 	                                    </tr> -->
<!-- 	                                </table> -->
<!-- 	                                <table style="width:100%; border: 1px solid #ddd; display: none;" id="Search_txtlist_table" class="mainlist"> -->
<!-- 	                                    <tr> -->
<!-- 	                                    </tr> -->
<!-- 	                                </table> -->
<!-- 	                            </div> -->
<!-- 	                            <div style="vertical-align: top; text-align: center; height: 440px; overflow: auto; display: none; width: 440px;" id="DeptUserImgList"></div> -->
	                        </td>    
	                    </tr>
	                </table>
	            </td>  
	            <!-- 위에까지 조직도 -->
	            <td style=" width:20px; text-align:center; padding:1px;">
	            	<img src="../../../images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="InsertReceiver()" />
	                            <img src="../../../images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="DeleteReceiver()" />
	            </td>
	            <!-- 위에까지 화살표 -->     
	            <td style="width:450px; height:480px; vertical-align: top;">
	            	<div class="portlet_tabpart03" style="background-color: #f8f8f8; margin-top: 4px;">
	                    <div class="portlet_tabpart03_top" id="tab2" style="border: 1px solid #d3d2d2; text-align:center;">
	                        <table style="margin-top: 3px; width: 100%;">
	                        	<tr>
	                        		<h2>사용자별 설정시간</h2>
	                        	</tr>
	                        	<tr>
	                        		근무시간 : 
	                        		<input type="text" id="startHrs" style="width:50px;"/>시
	                        		<input type="text" id="startMin" style="width:50px;"/>분
	                        		~
	                        		<input type="text" id="endHrs" style="width:50px;"/>시
	                        		<input type="text" id="endMin" style="width:50px;"/>분
	                        	</tr>
	                        </table>
	                	</div>
	                </div>
	                <div>
		                <table style="margin-top: 3px;">
		                    <tr>
		                        <td></td>
		                        <td class="listview" style="width: 100%; height: 446px;" id="orglistView2">
		                            <table style="width: 100%; margin-top: -1px;" class="popup_mainlist">
		                                <tr>
		                                    <th style="white-space:normal; padding-left:60px;">
		                                    	이름
		                                    </th>
		                                    <th style="white-space:normal">
		                                    	근무시간
		                                    </th>
		                                </tr>
		                            </table>
		                            <div style="vertical-align: top; overflow: auto; width: 100%;  height: 422px;" id="txtlist_Layer2">
		                                <table style="width:100%; border: 1px solid #ddd;" id="txtlist_table2" class="mainlist">
		                                </table>
		                            </div>
		                        </td>    
		                    </tr>
		                </table>
	                </div>
	            </td>
	        </tr>
	        <tr>
		        <td></td>
		        <td></td>
		        <td>
					<div class="btnposition" style="margin: 0px;">
					    <a class="imgbtn"><span onclick="userTimeApply('default')">기본설정적용</span></a>
					    <a class="imgbtn"><span onclick="userTimeApply('modify')">변경시간적용</span></a>
					</div>
		        </td>
	        </tr>
	    </table>
	</body>	
</html>