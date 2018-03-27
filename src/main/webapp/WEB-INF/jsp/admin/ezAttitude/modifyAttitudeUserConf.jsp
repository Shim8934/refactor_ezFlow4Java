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
		    var companyId = '${companyId}';
		    var selectedUserId;
		    //회사 근무 시작/종료시간 - 기본설정적용시 필요
		    var comStartTime = '${workStartTime}';
		    var comEndTime = '${workEndTime}';
			
		    $(document).ready(function(){
		    	
		    })
		    
	   		//선택된 사원
// 	   		function setUserAuthorDept(elem){
// 	   			selectedUserId = $(elem).attr("id");
// 	   			$("*").removeClass("selectTR");
// 	   			$(elem).addClass("selectTR");
// 	   		}

	   		$(document).on('click', '#txtlist_table2 tr' ,function() {
	   			$("*").removeClass("selectTR");
	   			$(this).addClass("selectTR");
	   		})
	   		
	   		function userTimeApply(type) {
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
	   			}
	   			
	   			var trIdx = $('#txtlist_table2').find('tr').length;
	   			var timeStr = "";
	   			for (var i = 0; i < trIdx; i++) {
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
	   		
	   		function addZero(time) {
	   			var resStr = "";
	   			if(time.length == 1) {
	   				resStr = "0" + time;
	   			} else {
	   				resStr = time;
	   			}
	   			return resStr;
	   		}
	   		
// 	   		function OK_Click() {
// 	   			var trIdx = $('#txtlist_table2').find('tr').length;
// 	   			var userConfInfo = "";
// 	   			for (var i = 0; i < trIdx; i++) {
// 	   				var userConfTime = $('#txtlist_table2 tr').eq(i).children("td").eq(1).text().split('~');
// 	   				userConfInfo += $('#txtlist_table2 tr').eq(i).attr('id') + ",";
// 	   				userConfInfo += userConfTime[0].trim() + ",";
// 	   				userConfInfo += userConfTime[1].trim() + ";";
// 	   			}
// 	   			userConfInfo.slice(0, -1);
	   			
// 	            $.ajax({
// 	            	type : "POST",
// 	            	url : "/admin/ezAttitude/attitudeUserConfSave.do",
// 	            	data : { "userConfInfoList" : userConfInfo },
// 	            	success : function() {
// 	            		alert('성공');
// 	            	},
// 	            	error : function() {
// 	            	}
// 	            });
// 	   		}
		    
	        function close_Click() {
	            if (ReturnFunction!=null) {
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
	            <li><span onclick="OK_Click()">저장</span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="close_Click()">닫기</span></li>
	        </ul>
	    </div>
	    <table id="TreeViewTD">
	        <tr>
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