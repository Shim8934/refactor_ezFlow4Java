<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezTask.t143' /></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezTask/circularProgressBar.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css" >
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}" type="text/css" >
		<script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/jquery.lineProgressbar.js')}"></script>
		
		<style type="text/css">
			   .ui-datepicker { font-size:9.5pt !important;}
			   .ui-widget-content {border:0px; border-left: 1px solid #eee; border-bottom: 1px solid #eee;}
			   .ui-state-default, .ui-widget-content .ui-state-default, .ui-widget-header .ui-state-default {border-color:#dedede; text-align: center; font-size:11px;}
			   .ui-widget-header { border:0px; }
			   .ui-datepicker td span, .ui-datepicker td a { padding-top:4px;}
			   
			   .css-class-to-highlight a{
			   		color: black !important;
			   		font-weight: bold !important;
			   }
			   
			   u {
				 	text-decoration: underline;
			   }
			   u:hover {
			   		color: blue;
			   		cursor: pointer;
			   }	   		
			   .percentCount {
			   		width: 40px;
    				padding-right: 5px;
			   }   
			   
			   table.content tr td, table.content tr th, table.content tr {
			        page-break-inside: avoid;
			   }
			   
			   .content2 {
				    border: 1px solid #ddd;
				    margin: 0;
				    width: 100%;
			   }
				
			   .content2 td {
				    padding: 0px 2px 0px 2px;
				    background: #FFF;
				    border: 1px solid #ddd;
				    height: 29px;
				    word-break: break-all;
			   }	  
			   
			   #printDocument p, #printDocument2 p {
			   		MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; line-height: 1.6;
			   }
			   
			   #printDocument div, #printDocument2 div {
			   		MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;
		       }
		</style>
		
		<script type="text/javascript">
			var userid = "<c:out value='${userInfo.id }'/>";
			var taskid = "<c:out value='${taskInfoVO.taskID }'/>";
			var contentpath = "${taskInfoVO.contentPath }";
			var personContentpath = "${taskInfoVO.personContentPath }";
			var creatorid = "<c:out value='${taskInfoVO.creatorID }'/>";
			var taskstatus = "<c:out value='${taskInfoVO.taskStatus }'/>";
			var completerate = "<c:out value='${taskInfoVO.completeRate }'/>";
			var duration = 500;
			var delayColor = "<c:out value='${delayColor }'/>";
			var completeColor = "<c:out value='${completeColor }'/>";
		    var tasktype = "<c:out value='${taskInfoVO.taskType }'/>";
		    var content = "${contentPerson }";
		    var date = "<c:out value='${date}'/>";
		    var type = "<c:out value='${type}'/>";
		    var personid = "<c:out value='${taskInfoVO.personID }'/>";
		    var taskCommentListSize = "<c:out value='${taskCommentListSize }'/>";
		    var tempbody = "";
		    var pUse_Editor = "<c:out value='${useEditor}'/>";
		    var AttachLimit = 5;
		    var hasTaskAttach = "<c:out value='${taskInfoVO.hasAttach}'/>";
		    var taskAttachList = "${taskAttachList }";
		    var hasTaskWorkAttach = "<c:out value='${taskInfoVO.personAttach}'/>";
		    var taskWorkAttachList = "${taskWorkAttachList }";
		    var useTodoMemo = "<c:out value='${useTodoMemo }'/>";
		    var startdate = "<c:out value='${taskInfoVO.startDate}'/>";
		    var repeatCount = "<c:out value='${repeatCount}'/>";
		    var createDate = "<c:out value='${taskInfoVO.createDate}'/>";
		    var repetition = "<c:out value='${repetition}'/>";
		    var endDate = "<c:out value='${taskInfoVO.endDate}'/>";
		    var dateList = "${dateList}";
		    var completeRateList = "${completeRateList}";
		    var statusList = "${statusList}";
		    var repeatCntList = "${repeatCntList}";
		    var dateArray = null;
		    var completeRateArray = null;
		    var statusArray = null;
		    var repeatCntArray = null;
		    //var backupCount = "${repeatCount}";
		    var selecttab = "<c:out value='${tab}'/>";
		    /*2018-05-17 구해안 userInfoID 추가*/
		    var userInfoID = "<c:out value='${userInfo.id}'/>";
		    var companyID = "<c:out value='${taskInfoVO.companyID }'/>";
		    
/* 			function taskReadJson() {
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezTask/taskReadJson.do",
					data : {							
							taskID : taskid,
							repeatCount: backupCount,
							date : date
					},
					success: function(result){
						
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
				
			} */
		    
		    $(document).ready(function() {	
		    	preStepForRepeatTask();
		    	
				load_bodyhtml();
				if (hasTaskAttach == 'Y') {
					document.getElementById('attachedfileDIV').innerHTML = taskAttachList;
		    	}
				
				load_bodyhtml2(personContentpath);
				if (hasTaskWorkAttach == 'Y') {
					document.getElementById('attachedfileDIV2').innerHTML = taskWorkAttachList
		    	}
		    	
		        setTimeout(scrollTop, 1000);
		        
	    		$("#message").closest("td").height(document.documentElement.clientHeight - 421 + "PX");
		    	$("#message2").closest("td").height(document.documentElement.clientHeight - 420 + "PX");
		    	$("#taskCommentList").height(document.documentElement.clientHeight - 420 + "PX");
		    	$("#new_div_body").height(document.documentElement.clientHeight - 360 + "PX");

		        if (tasktype == "1" || tasktype == "4") {
		            //document.getElementById("MailEnv_sub2").style.display = "none";
		            //document.getElementById("chisiButton").innerHTML = "<spring:message code='ezTask.t1511' />";
		            //setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />");
		            //setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />");
		            $(".taskType").html("<spring:message code='ezTask.t2000' />");
		        } else if (tasktype == "2" || tasktype == "5") {
		        	$(".taskType").html("<spring:message code='ezTask.t2001' />");
		        } else {
		        	$(".taskType").html("<spring:message code='ezTask.t2002' />");
		        }
		        
		        if (dateArray != null) {
		        	renderTable();
		        }

				/* 의견카운트 */
				getCommentList();			
				
				setTimeout(onloadchangtab, 100);		
				
				/* 2018-08-10 김민성 - 반복일정 progressbar 설정 추가 */
				if(taskstatus == 0) {
					dayOnMouseClick(date);
				}
				
				initProgressBar(taskstatus, completerate);
				
				var agent = navigator.userAgent.toLowerCase(); 
				if(window.screen.height < 910 && agent.indexOf("chrome") == -1) {
					$("#tablecomment2Div").height(375);
				}
		    });
		    
		    window.onresize = function () {
	    		$("#message").closest("td").height(document.documentElement.clientHeight - 421 + "PX");
		    	$("#message2").closest("td").height(document.documentElement.clientHeight - 420 + "PX");
		    	$("#taskCommentList").height(document.documentElement.clientHeight - 420 + "PX");
		    	$("#new_div_body").height(document.documentElement.clientHeight - 360 + "PX");
	         }
		    
		    function preStepForRepeatTask() {
		    	if (dateList !== "") {
		    		dateArray = dateList.split(",");
		    	}
		    	
		    	if (completeRateList !== "") {
		    		completeRateArray = completeRateList.split(",");
		    	}
		    	
		    	if (statusList !== "") {
		    		statusArray = statusList.split(",");
		    	}
		    	
		    	if (repeatCntList !== "") {
		    		repeatCntArray = repeatCntList.split(",");
		    	}    			    	    	
		    }
		    
		    function updateStatusOnce(newStatus, realDate) {
/* 		    	var date = new Date();
		    	var year = date.getFullYear();
		    	var month = date.getMonth() + 1;		    	
		    	var firstDayOfMonth = year + "-" + ("0" + month).slice(-2) + "-15"; */
		    	
		    	var year = realDate.split("-")[0];
		    	var month = realDate.split("-")[1];
		    	var firstDayOfMonth = year + "-" + month + "-15";
		    	updateData(firstDayOfMonth);
		    }
		    
			function scrollTop() {
				try {
					window.scroll(0, 1);
				} catch (e) { }
			}

			/* progressBar 조회 */
			/* 2018-04-24 김민성 - 업무 완료율 100%시 색상 조정 */
			function initProgressBar(taskstatus, completerate) {
				if (taskstatus == '4') {
					$('.progress_graph').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: delayColor},
						size: 135
					}).on('circle-animation-progress', function(event, progress) {
						$(this).find('strong').html(completerate + '%');
						if (completerate == 0) {
							$(this).find('strong').css("color", delayColor);
						} else {
							$(this).find('strong').css("color", "");
						}
					});
				} else if (taskstatus == '3' || completerate == '100') {	
					$('.progress_graph').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: completeColor},
						size: 135
					}).on('circle-animation-progress', function(event, progress) {
						$(this).find('strong').html(completerate + '%');
						$(this).find('strong').css("color", "");
					});
				} else {
					$('.progress_graph').circleProgress({
						value: ((completerate*1) / 100),
						fill: {color: '#3498db'},
						size: 135
					}).on('circle-animation-progress', function(event, progress) {
						$(this).find('strong').html(completerate + '%');
						$(this).find('strong').css("color", "");
					});
				}
			}
			
			/* 초기 탭선택스크립트 */
			function onloadchangtab() {
		    	Tab1_MouseClick(document.getElementById("1tab0"));		
			}

			/* 지시사항 본문 */
			function load_bodyhtml() {
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : {
							type : "TASKCONTENT",
							itemID : contentpath
					},
					success: function(result){
						html = result;
						var doc = document.getElementById('message').contentWindow.document;
						doc.open();
						doc.write('<div>' + html + '</div>');
						doc.close();

						$("#message").contents().find("body").css("word-wrap", "break-word");
						$("#message").contents().find("style").html("P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; line-height: 1.6;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} ");
					}
				});
			}
			
			/* 진행사항 본문 */
			function load_bodyhtml2(personContentpath) {
				if (personContentpath != "") {
					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezCommon/mhtToHTMLContent.do",
						data : {
								type : "TASKCONTENT2",
								itemID : personContentpath
						},
						success: function(result){
							html = result;
							
							var doc = document.getElementById('message2').contentWindow.document;
							doc.open();
							if(html != null || html != ""){
								doc.write('<div>' + html + '</div>');
								}else{
									doc.write(" ");
								}
								
								doc.close();
					
							$("#message2").contents().find("body").css("word-wrap", "break-word");
							$("#message2").contents().find("style").html("P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; line-height: 1.6;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} ");
						}
					});
					
					try {
						var objTags = document.getElementById('message2').getElementsByTagName("a");
	
						for (var i = 0 ; i < objTags.length ; i++) {
							if (objTags.item(i).href.indexOf("javascript:") == -1) {
								objTags.item(i).target = "_blink";
							}
						}
					} catch (e) { }
				}
			}
			
			function ImageUrl(pUrl, cnt) {
				var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl + "&Cnt=" + cnt;
	
				return link;
			}
			
			function trim(val) {
				s = val.split(" ", val.length)
				return s.join("")
			}
			
			function show_personinfo(userid) {
				if (userid == "0") {
					userid = creatorid;
				}
				
				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezSchedule/scheduleGetCumDeptID.do",
					data : { 						
						userID : userid,
						companyID : companyID
					},
					success: function(result){
						deptID = result;
					}
				});
					
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = (width - 420) / 2;
				var top = (heigth - 450) / 2;
				window.open("/ezCommon/showPersonInfo.do?id=" + userid+"&dept="+deptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
			}
			
			function attach_SelectAll(type) {
				var checks;
				if (type == "1") {
					checks = document.getElementById("attachedfileDIV").getElementsByTagName("input");
				} else {
					checks = document.getElementById("attachedfileDIV2").getElementsByTagName("input");
				}
	       
				for (var i = 0; i < checks.length; i++) {
					checks.item(i).checked = true;
				}
			}
			
			function attach_Download(type) {
				var checks;
				
				if (type == "1") {
					checks = attachedfileDIV.getElementsByTagName("input");
				} else {
					checks = attachedfileDIV2.getElementsByTagName("input");
				}
	
				downloadAll(checks)
			}
			
			var suffix = 0;
	
			function downloadAll(checks) {
				if (checks.item(suffix)) {
					if (checks.item(suffix).checked) {
						location.href = "/ezTask/downloadAttach.do?filePath=" + encodeURIComponent(GetAttribute(checks.item(suffix), "filePath")) + "&fileName=" + encodeURIComponent(GetAttribute(checks.item(suffix++), "fileName"));
						setTimeout(function () { downloadAll(checks) }, 1000);
					} else {
						suffix++;
						downloadAll(checks);
					}
				} else {
					suffix = 0;
				}
			}
			
			/* 의견작성 */
			function add_comment() {
				var taskComment = ConvertCharToEntityReference($("#TextComment").val());

				if (taskComment == "" || $.trim(taskComment) == "") {
					alert("<spring:message code='ezTask.t241' />");
					return;
				}

				taskComment = $.trim(taskComment);

				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezTask/taskSaveComment.do",
					data : {
							taskID : taskid,							
							textComment : taskComment
					},
					success: function(result){
						/* alert("<spring:message code='ezTask.t222' />"); */
						
						getCommentList();
						$("#TextComment").val("");
						RefreshView();
						
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			
			function check_delete() {
				if (tasktype == "4") {	
					repetition_Delete();
				} 
				else {
					if (confirm("<spring:message code='ezTask.t106' />")) {
						delete_task();
					}
				}
			}
			
			var deltaskid = "";
			function delete_task() {
				/* if (confirm("<spring:message code='ezTask.t106' />")) {
					return;
				} */	
				
				deltaskid = taskid + ";";
				
				$.ajax({
					type : "POST",
					url : "/ezTask/taskDelete.do",
					dataType : "json",
					data : {
						taskIDList : deltaskid
					},
					success : function(result) {
						window.opener.RefreshView();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezTask.t108' />");
					},
					complete : function() {
						window.close();
					}
				});				
			}

			var task_delete_confirm_cross_dialogArguments = new Array();
			function repetition_Delete() {
				task_delete_confirm_cross_dialogArguments[0] = "";
	        	task_delete_confirm_cross_dialogArguments[1] = deleteTask_Complete;
	            GetOpenWindow("/ezTask/taskDeleteConfirm.do", "task_delete_confirm_Cross", 500, 170);				
			}

			function deleteTask_Complete(ret) {				
				if (ret == "0") {
					once_Delete_Task();
				} else if (ret == "1") {
					delete_task();
				}								
			}

			function once_Delete_Task() {
	            $.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezTask/taskOnceDelete.do",
					data : { 
						taskID : taskid,
						repeatCount : repeatCount,
						taskStatus : taskstatus,
						completeRate : completerate,
						selectDate : date,
						startDate : startdate						
					},
					success: function() {
		                try { RefreshView(); } catch (e) { }
						
/* 		                if (window.opener.reload != undefined) {
		                	window.opener.reload();
		                }	 */	                    
		                window.close();
					}
				});
	        }

			/* 업무수정 */
			function edit_task() {
			    var win;
			    
				/* 레이어팝업으로 taskWrite 호출 */
				if (useTodoMemo == 'YES') {
					var feature = GetOpenPosition(760, 700);
		        	
					DivPopUpShow($('body').prop('scrollWidth') * 0.9, 700, "/ezTask/taskWrite.do?taskID=" + taskid + "&mode=2", "",
			                "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
		        } else {
					var feature = GetOpenPosition(760, 700);
		        	
					DivPopUpShow($('body').prop('scrollWidth') * 0.9, 700, "/ezTask/taskWrite.do?taskID=" + taskid + "&mode=2", "",
			                "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
		        }
				
			}			
			
			function edit_taskInfo() {
				var win;
				
				/* 레이어팝업으로 taskWrite 호출 */
				if (useTodoMemo == 'YES') {
					var feature = GetOpenPosition(760, 700);
		        	
					DivPopUpShow($('body').prop('scrollWidth') * 0.9, 435, "/ezTask/taskWrite.do?taskID=" + taskid + "&mode=1", "",
			                "height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
		        } else {
					var feature = GetOpenPosition(760, 645);
		        	
					DivPopUpShow($('body').prop('scrollWidth') * 0.9, 435, "/ezTask/taskWrite.do?taskID=" + taskid + "&mode=1", "",
			                "height = 435px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
		        }
			}
			
			/* 의견삭제 */
			function delete_comment(commentorid, commentid) {
			    if (commentorid != userid) {
			        alert("<spring:message code='ezTask.t146' />");
				    return;
				}
			
				if (!confirm("<spring:message code='ezTask.t147' />")) {
				    return;
				}
				
			    $.ajax({
					type : "POST",
					url : "/ezTask/taskDeleteComment.do",
					dataType : "json",
					data : {
						taskID : taskid,
						commentID : commentid
					},
					success : function(result) {
						/* alert("<spring:message code='ezTask.t148' />"); */
						
						getCommentList();
						RefreshView();
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			/*2018-05-17  구해안 의견 UI 수정*/
			function getCommentList() {
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezTask/getTaskCommentList.do",
					data : {							
							taskID : taskid
					},
					success: function(result){
						var list = result.taskCommentList;
						taskCommentListSize = list.length;
						
						/* 탭의견 카운트 */
						if (taskCommentListSize == 0) {
							document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />";
						} else { 
							document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />" + "(" + taskCommentListSize + ")";
						}
						
						/* commentList */
						/*2018-05-17 구해안 의견 UI 수정*/
						var commentBgColor = 1;
						var taskCommentList = "<tr>"
							taskCommentList += "<td colspan='3'>"
							taskCommentList += "<div id='tablecomment2Div' style='width: 100%; overflow:auto; height:398px;border:1px solid rgb(225,225,225);'>";
							taskCommentList += "<table id='tablecomment2' class='layout' style='border: 0px;width:100%;height:0%;'>"
						taskCommentList += "<colgroup><col width='20%' /><col width='62%' /><col width='18%' /></colgroup>";
						list.forEach(function(vo, index) {
							commentorID = "\"" + vo.commentorID + "\"";
							deleteCommentParam =  "\"" + vo.commentorID + "\", \"" + vo.commentID + "\"";
							if (commentBgColor === 1) {
								taskCommentList += "<tr class='taskCommentTr' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#white; border-left: 0px; border-top: 0px; border-right: 0px;'>";
							} else {
								taskCommentList += "<tr class='taskCommentTr' style='height:40px;text-align:left;border:1px solid #e2e2e2; background-color:#fafafa; border-left: 0px; border-top: 0px; border-right: 0px;'>";
							}
							commentBgColor = commentBgColor * (-1);
							
							taskCommentList += "<td onclick='show_personinfo(" + commentorID + ")' style='padding-left:3px;'>&nbsp;<span style='cursor:pointer'>" + vo.commentorName + "</span></td>";	
							
							taskCommentList += "</td>";
							taskCommentList += "<td style='white-space: pre-wrap;text-align:left;vertical-align:middle;padding:10px;word-wrap:break-word;line-height:1.5'>"
												+ vo.comment + "&nbsp;&nbsp;";
								
							if ( typeof userInfoID == "undefined") {
								userInfoID = "";    	
							}
							if (vo.commentorID == userInfoID) {
								taskCommentList += "<img src='/images/ImgIcon/comment_del.gif' style='cursor:pointer;vertical-align:middle;inline-block;' onclick='delete_comment(" + deleteCommentParam + ")'/>";
							} else {
								;
							}
							taskCommentList += "</td>";
							taskCommentList += "<td style='text-align:right;padding-right:8px'>" + vo.commentDate.substring(0, 16) + "</td>";
							taskCommentList += "</tr>";
							taskCommentList += "</div>";
						
						}); 	
						
						taskCommentList += "</table>"
						taskCommentList += "</td>"
						taskCommentList += "</tr>" 
						taskCommentList += "<tr>";
						taskCommentList += "<td colspan='3'>";
						taskCommentList += "<table class='content' style='width:100%;margin-top:8px'>";
						taskCommentList += "<colgroup><col width='7%' /><col width='35%' /><col width='57%' /></colgroup>";
						taskCommentList += "<tr style='height:58px'>";
						taskCommentList += "<th style='font-weight: bold;'><spring:message code='ezTask.t2012' /></th>";
						taskCommentList += "<td class='pos1' style='border:0px;padding-left:5px;padding-right:5px;padding-top:4px;padding-bottom:4px;width: 84%;border-bottom:0px;'><textarea id='TextComment' maxlength='500' style='width:98%;resize:none;overflow:auto;padding:7px;'></textarea></td>";
						taskCommentList += "<td style='border:0px;text-align:center;'><a class='imgbtn imgbck' style='vertical-align: middle; height:44px;'><span onClick='add_comment()' style='height:100%; line-height:40px;'><spring:message code='ezBoard.t321' /></span></a>";
						taskCommentList += "</td></tr>";
						taskCommentList += "</table>";
						taskCommentList += "</td>";
						taskCommentList += "</tr>";	
						
						$("#tablecomment").html(taskCommentList);
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			
			/* 진행상태 수정 */
			function update_status() {
				if (personid == userid || creatorid == userid) {
					//Baonk added				
					//var selctDate = new Date(date + " 00:00:00");
					//var curDate = new Date();

					var newDate = new Date();
					
					var year = newDate.getFullYear();
					var month = newDate.getMonth() + 1;
					var day = newDate.getDate();
					
					if (month < 10) {
						month = "0" + month;
					}
					
					if (day < 10) {
						day = "0" + day;
					}
					
					var curDate = year + '-' + month + '-' + day;
					var pStartdate = "";
					
					/* 2023-02-16 홍승비 - 진행상태 변경 > 시작일과 오늘 날짜의 비교 시 갱신된 시작일(또는 선택된 반복일정의 날짜)을 사용하도록 수정 */
					// 반복일정이 아닌 개인(1) / 지시(2) / 협조(3) 일정
					if (tasktype == 1 || tasktype == 2 ||  tasktype == 3) {
						pStartdate = startdate.substr(0, 10); // 업무정보 수정 등으로 실시간 갱신된 시작일
					}
					// 반복일정인 개인(4) / 지시(5) / 협조(6) 일정
					else if (tasktype == 4 || tasktype == 5 ||  tasktype == 6) {
						pStartdate = document.getElementById("prog1").innerText;
					}
					
					// 현재 시간과 비교하여 같거나 더 작은(이전) 시작일의 진행상태만 변경 가능 (startdate는 서버단에서 시간대 부분만 사용하도록 substring(10, 19) 처리되므로 그대로 유지)
					if (new Date(pStartdate) <= new Date(curDate)) {
						DivPopUpShow(410, 450, "/ezTask/taskStatus.do?taskID=" + taskid + "&repeatCount=" + repeatCount + "&date=" + pStartdate + "&startDate=" + startdate);
						// 레이어팝업 높이 수정 (430 -> 45) : 430의 경우 영어에서 잘림
					}
					else {
						alert("<spring:message code='ezTask.t200911' />");
						return;
					}					
					//end								
				} else {
					alert("<spring:message code='ezTask.t149' />");
				}
			}
			
			
			function Tab1_NewTabIni(pTabNodeID) {						
			    for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
			        if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
			            if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
			                document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
			                document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
			                document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
			
			                if (i == 0) {
			                    document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
			                    Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
			                } 
			
			            }
			        }
			    }
			}
			
			var Tab1_SelectID = "";
			function Tab1_MouserOver(obj) {
			    obj.className = "tabover";
			}
			
			function Tab1_MouserOut(obj) {
			    if (Tab1_SelectID != obj.id)
			        obj.className = "";
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
			    else {
			    	ChangeTab(obj);
			    }
			}			
			/*2018-05-17 구해안 지시자만 업무정보탭에서 업무정보 수정할수 있게 수정*/
			function ChangeTab(obj) {
			    var pSelectTab = GetAttribute(obj,"divname");			    
			    
			    switch (pSelectTab) {
				    case "MailEnv_div0":
			            selecttab = "0";
			            if(creatorid == userid || ((personid == userid) && (tasktype == "1")) || ((personid == userid) && (tasktype == "4"))){			            	
				            document.getElementById("editTaskInfo").style.display = "";
			            }else{
			            	document.getElementById("editTaskInfo").style.display = "none";
			            }
			            document.getElementById("taskInfo").style.display = "";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "none";
			            document.getElementById("taskRep").style.display = "none";
			            document.getElementById("taskDescription").style.display = "";			            
			            
			            
			            // if (creatorid == userid) {
			            /* if (personid == userid) {
			            	document.getElementById("editTaskInfo").style.display = "";
			            }  */
/* 			            else{
			            	document.getElementById("editTaskInfo").style.display = "none";
			            } */
			        	
			        	document.getElementById("editTaskWork").style.display = "none";
			        	document.getElementById("editTaskChisi").style.display = "none";
			            
			            break;
			        case "MailEnv_div1":
			            selecttab = "1";
			            document.getElementById("editTaskInfo").style.display = "none";
			            document.getElementById("taskInfo").style.display = "none";
			            document.getElementById("normalScreen").style.display = "";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "none";
			            document.getElementById("taskRep").style.display = "none";
			            document.getElementById("taskDescription").style.display = "none";			            
			            document.getElementById("editTaskWork").style.display = "none";
			            
			            if (creatorid == userid) {				        	
				        	document.getElementById("editTaskChisi").style.display = "";	
				        	//document.getElementById("editTaskInfo").style.display = "none";
				        } else {
				        	document.getElementById("editTaskChisi").style.display = "none";				        	
				        }
			            
			            break;
			        case "MailEnv_div2":
			            selecttab = "2";
			            document.getElementById("taskInfo").style.display = "none";
			            document.getElementById("editTaskInfo").style.display = "none";
			            
			            if (tasktype == "1" || tasktype == "4") {
			            	document.getElementById("normalScreen").style.display = "";
			            	document.getElementById("tablework").style.display = "none";
			            }
			            else {
			            	document.getElementById("normalScreen").style.display = "none";
			            	document.getElementById("tablework").style.display = "";
			            }	            
			            		            
			            document.getElementById("tablecomment").style.display = "none";
			            document.getElementById("taskRep").style.display = "none";
			            document.getElementById("taskDescription").style.display = "none";		            		            
			            document.getElementById("editTaskChisi").style.display = "none";
			            
			            if (personid == userid) {			            	
			            	if (tasktype == "1" || tasktype == "4") {	
			            		//document.getElementById("editTaskInfo").style.display = "none";
		            			document.getElementById("editTaskWork").style.display = "none";
		            			document.getElementById("chisiButton").innerHTML = "<spring:message code='ezTask.t1511' />";
		            			document.getElementById("editTaskChisi").style.display = "";			            					            			
		            		}
		            		else {
		            			document.getElementById("editTaskWork").style.display = "";
		            		}		
				        } 
			            else {
			            	if(creatorid != userid) {
			            		if (tasktype == "1" || tasktype == "4") {	
			            			document.getElementById("editTaskWork").style.display = "none";
			            			document.getElementById("chisiButton").innerHTML = "<spring:message code='ezTask.jjh02' />";
			            			document.getElementById("editTaskChisi").style.display = "none";			            					            			
			            		}
			            		else {
			            			document.getElementById("editTaskWork").style.display = "none";
			            		}			            		
			            	}
			            	else {
			            		document.getElementById("editTaskWork").style.display = "none";
			            		//document.getElementById("editTaskInfo").style.display = "none";
			            	}				        	
				        }
			            
			            break;
			        case "MailEnv_div3":
			            selecttab = "3";
			            document.getElementById("taskInfo").style.display = "none";
			            document.getElementById("editTaskInfo").style.display = "none";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "";
			            document.getElementById("taskRep").style.display = "none";
			            document.getElementById("taskDescription").style.display = "none";
			            /* if (creatorid == userid) {
			            	document.getElementById("editTaskInfo").style.display = "none";
			            } */
			        	//document.getElementById("editTaskInfo").style.display = "none";
			        	document.getElementById("editTaskWork").style.display = "none";
			        	document.getElementById("editTaskChisi").style.display = "none";
			            
			            break;
			        case "MailEnv_div4":
			            selecttab = "4";
			            
/* 			            $.ajax({
							type : "GET",
							dataType : "text",
							async : false,
							url : "/ezTask/taskRepGetList.do",
							data : {
								currentDate : date												
							},
							success : function(xml) {
								renderTable(xml);
							},
							error : function() {
								alert("<spring:message code='ezTask.t992' />");
							}
						});	 */	            		            			            
			            
			            document.getElementById("taskInfo").style.display = "none";
						document.getElementById("editTaskInfo").style.display = "none";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "none";
			            document.getElementById("taskRep").style.display = "";
			            document.getElementById("taskDescription").style.display = "none";
			            
			           /*  if (creatorid == userid) {
			            	document.getElementById("editTaskInfo").style.display = "none";
			            } */
			        	//document.getElementById("editTaskInfo").style.display = "none";
			        	document.getElementById("editTaskWork").style.display = "none";	
			        	document.getElementById("editTaskChisi").style.display = "none";
			            
			            break;
			    }
			}
			
			function showEmptyTable() {
				
				$("#new_list_body").empty();
				
				var noDataTag = "<tr >";
				noDataTag += "<th style='width:  100px; text-align: center;'><spring:message code='ezTask.t1221' /></th>"
				noDataTag += "<th style='width: 320px; text-align: center;'><spring:message code='ezTask.t200914' /></th>"
				noDataTag += "<th style='width: 320px; text-align: center;'><spring:message code='ezTask.t120' /></th>"
				noDataTag += "</tr>"	
				noDataTag += "<tr class='new_row_body' id='new_row_body' style='display:none;' repeatcount='0' startdate='' >"
				noDataTag += "<td class='tr_Read' style='white-space:nowrap; width: 100px;' ></td>"
				noDataTag += "<td class='tr_Read' style='white-space:nowrap; width: 320px;' ></td>"
				noDataTag += "<td class='tr_Read' style='white-space:nowrap; width: 320px;' ></td>"
				noDataTag += "</tr>"
				noDataTag += "<tr id='noDataTag'><td colspan='3' style='text-align: center;'><spring:message code='ezTask.t200912' /></td></tr>";
				
				$("#new_list_body").append(noDataTag);
			}
			
			function renderTable() {
								 
				$("#new_list_body").empty();
				
				var defaultTag = "<tr >";
				defaultTag += "<th style='width:  100px; text-align: center;'><spring:message code='ezTask.t1221' /></th>"
				defaultTag += "<th style='width: 320px; text-align: center;'><spring:message code='ezTask.t200914' /></th>"
				defaultTag += "<th style='width: 320px; text-align: center;'><spring:message code='ezTask.t120' /></th>"
				defaultTag += "</tr>"	
				defaultTag += "<tr class='new_row_body' id='new_row_body' style='display:none;' repeatcount='0' startdate='' >"
				defaultTag += "<td class='tr_Read' style='white-space:nowrap; width: 100px;' ></td>"
				defaultTag += "<td class='tr_Read' style='white-space:nowrap; width: 320px;' ></td>"
				defaultTag += "<td class='tr_Read' style='white-space:nowrap; width: 320px;' ></td>"
				defaultTag += "</tr>"
				
				$("#new_list_body").append(defaultTag);				
				
				var new_list_body = document.getElementById("new_list_body");						
				
				for (var i = 0; i < completeRateArray.length; i++) {					
					tr = new_row_body.cloneNode(true);				    

				    tr.style.display = "";
			        tr.id = "taskID_" + i;

			        tr.setAttribute("taskid", taskid);			        

			        var startdate = dateArray[i];
			        var enddate = startdate;
			        var span = document.createElement("SPAN");
			        
			        span.innerHTML += parseInt(repeatCntArray[i] + "");
			        tr.cells[0].appendChild(span);

			        tr.setAttribute("startdate", startdate);			        
			        tr.cells[1].innerHTML = "<u>" + startdate + "</u>";
			        (function(sd) { tr.cells[1].onclick = function () {rowClicked(sd);}})(startdate);		        			        			        	
			        
			        //Process complete rate
			        var taskstatus = parseInt(statusArray[i] + "");			        
			        var completerate = parseInt(completeRateArray[i] + "");
			        var span = document.createElement("SPAN");
			        span.className = "workProgressBar";
			        span.innerHTML += "<span class='bar' taskID='taskProgressBar" + i + "'></span>&nbsp;"

					var span2 = document.createElement("SPAN");
			        span2.style.display = "inline-block";

			        span.appendChild(span2);

			        tr.cells[2].appendChild(span);
			        new_list_body.appendChild(tr);
			        
			        initProgressBar2("taskProgressBar" + i, taskstatus, completerate);			        
				}
				
				$(".progressbar").css("display", "inline-table");
				$(".progressbar").css("margin-left", "15px");
				
			}
			
			/* 2021-10-29 홍승비 - 반복업무현황 > 업무일 클릭 시 진행상태변경 동작하지 않고 날짜만 변경하도록 수정 */
			function rowClicked(day) {
				showResult(day);
				//update_status();
			}
			
			/* progressBar 조회 */
			function initProgressBar2(barID, taskstatus, completerate) {
				if (completerate == '0') {
					duration = 0;
				} else {
					duration = 500;
				}

				if (taskstatus == '4') {
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else if (taskstatus == '3' || completerate == '100') {
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: completeColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				} else {
					$(".bar[taskid='" + barID + "']").LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '70%',
						duration : duration
					});
				}
			}
			
			
			function comment_keydown() {
			    if (window.event.keyCode == "13")
			        add_comment();
			}
			
			/* 진행사항 수정 스크립트 */
			function edit_taskwrok() {
			    var win;
			    
				/* 레이어팝업으로 taskWorkWriteCross 호출 */
				var feature = GetOpenPosition(760, 700);
				DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.92, "/ezTask/taskWorkWrite.do?taskID=" + taskid, "",
		                "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
			}
			
			/* 진행상태변경시 스크립트 */
			function changestatus(obj) {
			    if (obj.id == "taskstatus")
			        document.getElementById("completera").checked = true;
			    else if (obj.id == "taskstatus2") {
			        if (document.getElementById("completera").checked || document.getElementById("completera11").checked)
			            document.getElementById("completera2").checked = true;
			    }
			    else if (obj.id == "taskstatus3")
			        document.getElementById("completera11").checked = true;
			    else if (obj.id == "taskstatus4")
			        if (document.getElementById("completera11").checked)
			            document.getElementById("completera2").checked = true;
			}
			
			/* 완료율변경시 스크립트 */
			function changecomplete(obj) {
			    if (obj.id == "completera")
			        document.getElementById("taskstatus").checked = true;
			    else if (obj.id == "completera11")
			        document.getElementById("taskstatus3").checked = true;
			    else
			        if (document.getElementById("taskstatus").checked || document.getElementById("taskstatus3").checked)
			            document.getElementById("taskstatus2").checked = true;
			}
			 
			//2018-08-16 김보미 - 인쇄시 미리보기 화면으로 이동하게 변경
			function beforeprint2() {
				$(".popup").css('background-image', 'none');
				
			    document.getElementById("printScreen").style.display = "block";
			    document.getElementById("taskInfo").style.display = "none";
			    document.getElementById("taskDescription").style.display = "none";
			    document.getElementById("normalScreen").style.display = "none";
			    document.getElementById("menu").style.display = "none";
			    document.getElementById("close").style.display = "none";
			    document.getElementById("tabpart").style.display = "none";
			    document.getElementById("tablework").style.display = "none";
			    document.getElementById("tablecomment").style.display = "none";
			    document.getElementById("taskRep").style.display = "none";
			    
			    if(tasktype == 4 || tasktype == 5 ||  tasktype == 6) {
				    document.getElementById("reptr").style.display = "block";
				  	//$("#printTable").append(repData);	
				    
				  	//baonk added
				    document.getElementById("taskRep").style.display = "";				    
				    var height = $("#new_list_body")[0].clientHeight;
				    document.getElementById("new_div_body").style.height = (height + 30) + "px";				    
				    
				    var repData = $("#taskRep").html();
				    
				    $("#repTable").html(repData);				   
				    document.getElementById("new_div_body").style.height = "450px";
				    document.getElementById("taskRep").style.display = "none";
				    //end			    	
			    }
			    
			    $("#updateStatus").hide();
			
			    var status = "";
				switch (taskstatus) {
					case "1":
			            status = "<spring:message code='ezTask.t97' />";
						break;
					case "2":
						status = "<spring:message code='ezTask.t98' />";
						break;
					case "3":
						status = "<spring:message code='ezTask.t9001' />";
						break;
					case "4":
						status = "<spring:message code='ezTask.t100' />";
						break;
				}
			
				status += ", <spring:message code='ezTask.t144' />" + completerate + "%";
			
			    //$("#printComment").html($("#taskCommentList").html());
			    //$("#printComment img").remove();
			    
			    //baonk added
			    var content1 = message.document.body.innerHTML;
			    content1 = content1.replace(/P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; line-height: 1.6;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} /g, "");
			    document.getElementById("printDocument").innerHTML = content1;
			    //end
			    
			    //document.getElementById("printDocument").innerHTML = message.document.body.innerHTML;
			    document.getElementById("printAttach").innerHTML = document.getElementById("attachedfileDIV").innerHTML;
			
			    if (tasktype != "1" && tasktype != "4") {
			    	$("#printTaskWork").show();
			    	$("#printTaskWorkContent").show();
			    	
					//baonk added
				    var content2 = message2.document.body.innerHTML;
				    content2 = content2.replace(/P { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm; line-height: 1.6;} DIV { MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm;line-height:20px;font-size:10pt;} /g, "");
				    document.getElementById("printDocument2").innerHTML = content2;
				    //end
			    	
			        //document.getElementById("printDocument2").innerHTML = message2.document.body.innerHTML;
			        document.getElementById("printAttach2").innerHTML = document.getElementById("attachedfileDIV2").innerHTML;
			    }
			
			    var checks = document.getElementById("printAttach").childNodes;
			    for (var i = 0; i < checks.length; i++) {
			        if (checks[i].type == "checkbox")
			            checks[i].style.display = "none";
			    }
			
			    checks = document.getElementById("printAttach2").childNodes;
			    for (var i = 0; i < checks.length; i++) {
			        if (checks[i].type == "checkbox")
			            checks[i].style.display = "none";
			    }
			    
			  //2018-07-10 구해안 #12746
			    var tableOption = document.createElement("TABLE");
		    	tableOption.setAttribute("class", "content2");
			    var userName = "";
	    		var content  = "";
	    		var dateTime = "";
	    		var trElmt  = document.createElement("TR");
	    		var tdElmt1 = document.createElement("TD");
	    		var tdElmt2 = document.createElement("TD");
	    		var tdElmt3 = document.createElement("TD");
			     
			    if($('#tablecomment2 > tbody > tr').length == 0 || $('#tablecomment2 > tbody > tr').length < 0 || !$('#tablecomment2 > tbody > tr').length){
			    	console.log('진입!!! : ' + $('#tablecomment2'));
			    	
			    	var printCommentView = document.getElementById("printCommentView");
			    	
			    	tdElmt1.innerHTML = userName;
		    		tdElmt2.innerHTML = content;
		    		tdElmt3.innerHTML = dateTime;
		    		
		    		tdElmt1.setAttribute("style", "min-width: 120px; width: 120px; text-align: center; white-space:nowrap; vertical-align: middle; padding: 0px 10px;");
		    		tdElmt2.setAttribute("style", "vertical-align: middle; padding: 0px 10px;");
		    		tdElmt3.setAttribute("style", "min-width: 120px; width: 120px; text-align: center; white-space:nowrap; vertical-align: middle; padding: 0px 10px;");
		    		
		    		trElmt.appendChild(tdElmt1);
		    		trElmt.appendChild(tdElmt2);
		    		trElmt.appendChild(tdElmt3);
		    		tableOption.appendChild(trElmt);
			    	
			    	printCommentView.appendChild(tableOption);			    	
			    	printCommentView.style.display = "";
			    	
			    }else{			    	
			    
			    if ($("#tablecomment2 > tbody  > tr").html().trim() != "") {
			    	//baonk added
			    	var printCommentView = document.getElementById("printCommentView");
					while (printCommentView.firstChild) {
						printCommentView.removeChild(printCommentView.firstChild);
					}
			    	
			    	var tableOption = document.createElement("TABLE");
			    	tableOption.setAttribute("class", "content2");			    	
			    	$('#tablecomment2 > tbody  > tr').each(function (i) {
			    		userName = $(this).children().eq(0).text();
			    		content  = $(this).children().eq(1).text();
			    		dateTime = $(this).children().eq(2).text();		
			    		
			    		tdElmt1.innerHTML = userName;
			    		tdElmt2.innerHTML = content;
			    		tdElmt3.innerHTML = dateTime;
			    		
			    		tdElmt1.setAttribute("style", "min-width: 120px; width: 120px; text-align: center; white-space:nowrap; vertical-align: middle; padding: 0px 10px;");
			    		tdElmt2.setAttribute("style", "vertical-align: middle; padding: 0px 10px;");
			    		tdElmt3.setAttribute("style", "min-width: 120px; width: 120px; text-align: center; white-space:nowrap; vertical-align: middle; padding: 0px 10px;");
			    		
			    		trElmt.appendChild(tdElmt1);
			    		trElmt.appendChild(tdElmt2);
			    		trElmt.appendChild(tdElmt3);
			    		tableOption.appendChild(trElmt);
			    	});
			    	
			    	printCommentView.appendChild(tableOption);			    	
			    	printCommentView.style.display = "";
			    	//end
			    	
			        //document.getElementById("printCommentView").style.display = "";
			        document.getElementById("optiontr").style.display = "";
			    } else {
			        document.getElementById("printCommentView").style.display = "none";
			        document.getElementById("optiontr").style.display = "none";
			    }
			    }
			
			    if (document.getElementById("attachedfileDIV").innerHTML.trim() != "")
			        printattachView.style.display = "";
			
			    if (tasktype != "1" && document.getElementById("printAttach2").innerHTML.trim() != "")
			    	printattachViewProgress.style.display = "";
			   
			    window.print();
			    
			    $(".popup").css("background-image", "url('/images/kr/cm/popup_bg.gif')");
			    
			    document.getElementById("printScreen").style.display = "none";
			    document.getElementById("taskInfo").style.display = "";
			    document.getElementById("normalScreen").style.display = "";
			    document.getElementById("menu").style.display = "";
			    document.getElementById("close").style.display = "";
			    document.getElementById("tabpart").style.display = "";
			    document.getElementById("tablework").style.display = "";
			    document.getElementById("tablecomment2").style.display = "";
			    $("#updateStatus").show();
			
/* 			    if (selecttab == "0") {
			    	document.getElementById("taskInfo").style.display = "";
			    	document.getElementById("taskDescription").style.display = "";
			    	document.getElementById("normalScreen").style.display = "none";
			        document.getElementById("tablework").style.display = "none";
			        document.getElementById("tablecomment").style.display = "none";
			    } else if (selecttab == "1") {
			    	document.getElementById("taskInfo").style.display = "none";
			        document.getElementById("normalScreen").style.display = "";
			        document.getElementById("tablework").style.display = "none";
			        document.getElementById("tablecomment").style.display = "none";
			    } else if (selecttab == "2") {
			    	document.getElementById("taskInfo").style.display = "none";
			        document.getElementById("normalScreen").style.display = "none";
			        document.getElementById("tablework").style.display = "";
			        document.getElementById("tablecomment").style.display = "none";
			    } else if (selecttab == "3") {
			    	document.getElementById("taskInfo").style.display = "none";
			        document.getElementById("normalScreen").style.display = "none";
			        document.getElementById("tablework").style.display = "none";
			        document.getElementById("tablecomment").style.display = "";
			    } */
			    
			    //baonk added
			    if (selecttab == "0") {
		            document.getElementById("taskInfo").style.display = "";
		            document.getElementById("normalScreen").style.display = "none";
		            document.getElementById("tablework").style.display = "none";
		            document.getElementById("tablecomment").style.display = "none";
		            document.getElementById("taskRep").style.display = "none";
		            document.getElementById("taskDescription").style.display = "";			            
		            
		            
		            /* if (creatorid == userid) {
		            	document.getElementById("editTaskInfo").style.display = "";
		            } */
		        	
		        	document.getElementById("editTaskWork").style.display = "none";
		        	document.getElementById("editTaskChisi").style.display = "none";
			    } else if (selecttab == "1") {
			    	document.getElementById("taskInfo").style.display = "none";
		            document.getElementById("normalScreen").style.display = "";
		            document.getElementById("tablework").style.display = "none";
		            document.getElementById("tablecomment").style.display = "none";
		            document.getElementById("taskRep").style.display = "none";
		            document.getElementById("taskDescription").style.display = "none";			            
		            document.getElementById("editTaskWork").style.display = "none";
		            
		            if (creatorid == userid) {				        	
			        	document.getElementById("editTaskChisi").style.display = "";	
			        	//document.getElementById("editTaskInfo").style.display = "none";
			        } else {
			        	document.getElementById("editTaskChisi").style.display = "none";				        	
			        }
			    } else if (selecttab == "2") {
			    	document.getElementById("taskInfo").style.display = "none";
		            
		            if (tasktype == "1" || tasktype == "4") {
		            	document.getElementById("normalScreen").style.display = "";
		            	document.getElementById("tablework").style.display = "none";
		            }
		            else {
		            	document.getElementById("normalScreen").style.display = "none";
		            	document.getElementById("tablework").style.display = "";
		            }	            
		            		            
		            document.getElementById("tablecomment").style.display = "none";
		            document.getElementById("taskRep").style.display = "none";
		            document.getElementById("taskDescription").style.display = "none";		            		            
		            document.getElementById("editTaskChisi").style.display = "none";
		            
		            if (personid == userid) {			            	
		            	if (tasktype == "1" || tasktype == "4") {	
		            		//document.getElementById("editTaskInfo").style.display = "none";
	            			document.getElementById("editTaskWork").style.display = "none";
	            			document.getElementById("chisiButton").innerHTML = "<spring:message code='ezTask.t1511' />";
	            			document.getElementById("editTaskChisi").style.display = "";			            					            			
	            		}
	            		else {
	            			document.getElementById("editTaskWork").style.display = "";
	            		}		
			        } 
		            else {
		            	if(creatorid != userid) {
		            		if (tasktype == "1" || tasktype == "4") {	
		            			document.getElementById("editTaskWork").style.display = "none";
		            			document.getElementById("chisiButton").innerHTML = "<spring:message code='ezTask.jjh02' />";
		            			document.getElementById("editTaskChisi").style.display = "";			            					            			
		            		}
		            		else {
		            			document.getElementById("editTaskWork").style.display = "";
		            		}			            		
		            	}
		            	else {
		            		document.getElementById("editTaskWork").style.display = "none";
		            		//document.getElementById("editTaskInfo").style.display = "none";
		            	}				        	
			        }
			    } else if (selecttab == "3") {
			    	document.getElementById("taskInfo").style.display = "none";
		            document.getElementById("normalScreen").style.display = "none";
		            document.getElementById("tablework").style.display = "none";
		            document.getElementById("tablecomment").style.display = "";
		            document.getElementById("taskRep").style.display = "none";
		            document.getElementById("taskDescription").style.display = "none";
		            /* if (creatorid == userid) {
		            	document.getElementById("editTaskInfo").style.display = "none";
		            } */
		        	
		        	document.getElementById("editTaskWork").style.display = "none";
		        	document.getElementById("editTaskChisi").style.display = "none";
			    }
			    else if (selecttab == "4") {
			    	document.getElementById("taskInfo").style.display = "none";
		            document.getElementById("normalScreen").style.display = "none";
		            document.getElementById("tablework").style.display = "none";
		            document.getElementById("tablecomment").style.display = "none";
		            document.getElementById("taskRep").style.display = "";
		            document.getElementById("taskDescription").style.display = "none";
		            
		            /* if (creatorid == userid) {
		            	document.getElementById("editTaskInfo").style.display = "none";
		            } */
		        	
		        	document.getElementById("editTaskWork").style.display = "none";	
		        	document.getElementById("editTaskChisi").style.display = "none";
			    }
			    //end
			    
			    //clean the place
		    	$("#repTable").html("");
			}
			//2018-08-16 김보미 - 인쇄시 미리보기 화면으로 이동하게 변경
			function beforeprint() {
	            var url = "/ezTask/taskReadPrint.do";
		        var feature = "";
		        var calDate = $(".ui-datepicker-year").val() + "-" + (parseInt($(".ui-datepicker-month").val()) + 1) + "-01";
		        
	        	feature = GetOpenPosition(790, 810);
                window.open("/ezTask/taskReadPrint.do?taskID=" + taskid + "&repeatCount=" + repeatCount + "&date=" + date + "&calDate=" + calDate, "", "height = 820px, width = 790px, scrollbars=1, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
                
			}

			window.onunload = function (e) {
		    	try {
// 		    		window.opener.RefreshView();
// 			    	window.close();
		    	} catch (e) {}
			}

			function messageload() {
			    document.getElementById("printDocument").innerHTML = message.document.body.innerHTML;
			}
			
			function RefreshView() {
				window.opener.RefreshView();
			}
			
			function getTaskAttachList() {
				$.ajax({
					type : "GET",
					url : "/ezTask/getTaskAttachList.do",
					dataType : "json",
					data : {
							taskID : taskid,
					},
					success : function(result) {
						hasTaskAttach = result.hasTaskAttach;
						taskAttachList = result.taskAttachList;
						
						if (hasTaskAttach == 'Y') {
							document.getElementById('attachedfileDIV').innerHTML = taskAttachList
				    	} else {
				    		document.getElementById('attachedfileDIV').innerHTML = "";
				    	}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				})
			}

			function getTaskWorkAttachList() {
				$.ajax({
					type : "GET",
					url : "/ezTask/getTaskWorkAttachList.do",
					dataType : "json",
					data : {
							taskID : taskid,
					},
					success : function(result) {
						hasTaskWorkAttach = result.hasTaskWorkAttach;
						taskWorkAttachList = result.taskWorkAttachList;
						
						if (hasTaskWorkAttach == 'Y') {
							document.getElementById('attachedfileDIV2').innerHTML = taskWorkAttachList
				    	}
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				})
			}
			
			function updateData(firstDayOfMonth) {
				//Get new data from server			            		
				$.ajax({
					type : "GET",
					dataType : "json",
					async : false,
					url : "/ezTask/getRepTaskDateList.do",
					data : {
							taskID 		: taskid,
							currentDate : firstDayOfMonth
					},
					success: function(result) {
						var list = result.dateList;
						var rList = result.rateList;
						var sList = result.statusList;
						var repList = result.repeatCntList;
						
						if (list.length != 0) {							
    						dateArray = [];
    						completeRateArray = [];
    						statusArray = [];
    						repeatCntArray = []; 
    						
    						list.forEach(function(strDate, index) {
    							dateArray.push(strDate);			    							
    						});
    						
    						rList.forEach(function(strRate, index) {
    							completeRateArray.push(strRate);			    							
    						});		
    						
    						sList.forEach(function(strStatus, index) {
    							statusArray.push(strStatus);			    							
    						});	
    						
    						repList.forEach(function(strRepeatCnt, index) {
    							repeatCntArray.push(strRepeatCnt);			    							
    						});	
    						
    						//showResult(dateText, repeatCount);
    						renderTable();
						}
						else {
							showEmptyTable();
						}
						
					},
					afterShow: function() {
						console.log('afterShow');
						$(".css-class-to-highlight").css("background-color","red");
					}
					,
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezTask.t200913' />");
					}
    			});		       
			}

			$(function () {
		    	$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
					                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
					                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
					                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
					dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
					           "<spring:message code='main.t0627' />"],
					dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					                "<spring:message code='main.t0627' />"],
					dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
					              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
					              "<spring:message code='main.t0627' />"],
					weekHeader: "Wk",
					dateFormat: "yy-mm-dd",
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: "show",
					showMonthAfterYear: true
				};
				
				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		    });
			
			$(function () {
				if (tasktype == "4" || tasktype == "5" || tasktype == "6" ) {
					$("#Sdatepicker").datepicker({
			            changeMonth: true,
			            changeYear: true,
			            autoSize: true,
			            format: 'yyyy-mm-dd',
			            beforeShowDay: function(date) {	
			            	if (dateArray != null) {
				                var m = date.getMonth() + 1;
				                var d = date.getDate();
				                var y = date.getFullYear();		                
				                
				                var test = y + "-" + ("0" + m).slice(-2) + "-" + ("0" + d).slice(-2);		                
				                
				                for (i = 0; i < dateArray.length; i++) {		                	
				                    if($.inArray(test, dateArray) != -1) {		                        
				                        return [true, 'css-class-to-highlight'];
				                    }
				                }
				                return [true];
			            	}	            	
			            },
			            onSelect: function(dateText, inst) {
			            	showResult(dateText);
			            },
			            onChangeMonthYear: function (year, month, inst) {		            	
			            	var firstDayOfMonth = year + "-" + ("0" + month).slice(-2) + "-15";							            	
							updateData(firstDayOfMonth);	
			            }
			        });

			        var SDate;

			        if (date != "") {
			            SDate = new Date(date);
			        } else {
			            SDate = new Date();
			        }
			        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
			        $("#Sdatepicker").datepicker('setDate', SDate);
				}		        
		    });
						
			function dayOnMouseClick(changeDate) {								
				//var feature = GetOpenPosition(750, 740);
				//window.open("/ezTask/taskRead.do?taskID=" + taskid + "&repeatCount=" + repeatCount + "&date=" + changeDate, "", "height = 810px, width = 750px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				//window.close();
				$.ajax({
					type : "GET",
					dataType : "text",
					async : false,
					url : "/ezTask/taskRepGetList.do",
					data : {
						taskID	    : taskid,
						currentDate : changeDate												
					},
					success : function(xml) {				
						//repeatCount = backupCount;
						date = changeDate;
						renderPage(xml);
					},
					error : function() {
						alert("<spring:message code='ezTask.t992' />");
					}
				});
				
			}
			
			function renderPage(xml) {
				listdom = loadXMLString(xml);
				var node = GetChildNodesByNodeName(listdom.documentElement, "ROW")[0];
				contentpath = SelectSingleNodeValue(node, "CONTENTPATH");
				personContentpath = SelectSingleNodeValue(node, "PERSONALCONTENTPATH");
				completerate = SelectSingleNodeValue(node, "COMPLETERATE");
				taskstatus = SelectSingleNodeValue(node, "TASKSTATUS");	
				repeatCount = SelectSingleNodeValue(node, "REPEATCOUNT");
				
				document.getElementById("prog1").innerHTML = date;
				document.getElementById("repCount").innerHTML = repeatCount;
				//document.getElementById("prog3").innerHTML = date;
				
				/*****************************/
/* 				if (dateList !== "") {
		    		dateArray = dateList.split(",");
		    	}
		    	
		    	if (completeRateList !== "") {
		    		completeRateArray = completeRateList.split(",");
		    	} */
		    	
				load_bodyhtml();
				if (hasTaskAttach == 'Y') {
					document.getElementById('attachedfileDIV').innerHTML = taskAttachList;
		    	}
				
				load_bodyhtml2(personContentpath);
				if (hasTaskWorkAttach == 'Y') {
					document.getElementById('attachedfileDIV2').innerHTML = taskWorkAttachList
		    	}
		    	
		        setTimeout(scrollTop, 1000);
		        
	    		$("#message").closest("td").height(document.documentElement.clientHeight - 421 + "PX");
		    	$("#message2").closest("td").height(document.documentElement.clientHeight - 420 + "PX");
		    	$("#taskComment").height(document.documentElement.clientHeight - 420 + "PX");
		    	$("#new_div_body").height(document.documentElement.clientHeight - 360 + "PX");
		    	

		        if (tasktype == "1" || tasktype == "4") {
/* 		            document.getElementById("MailEnv_sub2").style.display = "none";
		            setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />");
		            setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />"); */
		            $(".taskType").html("<spring:message code='ezTask.t2000' />");
		        } else if (tasktype == "2" || tasktype == "5") {
		        	$(".taskType").html("<spring:message code='ezTask.t2001' />");
		        } else {
		        	$(".taskType").html("<spring:message code='ezTask.t2002' />");
		        }		        
		        
		        //renderTable();		        

				/* 의견카운트 */
				getCommentList();

				//setTimeout(onloadchangtab, 100);
				
				initProgressBar(taskstatus, completerate);
				
				/****************************/						
				
			}
			
			function showResult(dateText) {
		        var SDate;

		        if (dateText != "") {
		            SDate = new Date(dateText);
		        } else {
		            SDate = new Date();
		        }
		        $("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
		        $("#Sdatepicker").datepicker('setDate', SDate);
				
				
				
        		var test = 0;
        		
				for (var i = 0; i < dateArray.length; i++) {					
					if (dateArray[i] ==  dateText) {
						test = 1;
						//repeatCount = parseInt(repeatCount, 10) + i;						
						break;
					}
				}						
				
				if (test == 0) {
					//dateArray = dateList.split(",");
					//repeatCount = backupCount;
					alert("<spring:message code='ezTask.t200912' />");
					$("#Sdatepicker").datepicker("setDate", date);
				}
				else {
					dayOnMouseClick(dateText);
				}				
			}
		</script>
	</head>
	
	<body class="popup" style="overflow:auto; height:99%" scroll="auto">
		<div id="menu" style="margin-bottom:10px;">
			<ul>
				<c:if test="${userInfo.id == taskInfoVO.creatorID }">
					<li id="delete"><SPAN class="icon16 popup_icon16_delete" onClick="check_delete()"></SPAN></li>
				</c:if>
				<li><span class="icon16 popup_icon16_print" onClick="beforeprint()"></span></li>
			</ul>
		</div>
		<div id="close">
			<ul>
				<li><span onClick="window.close()"></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		</script>
		
		<div class="wrap_progress" style="height:245px;margin-top:14px">
			<h4 style="-webkit-print-color-adjust:exact;print-color-adjust: exact;" title="<c:out value='${taskInfoVO.title }'/>"><c:out value='${taskInfoVO.title}'/></h4>
			<div style="">
				<div class="circle progress_graph" style="width:30%; margin: 10px 20px; top:15px;">
					<strong></strong>
				</div>
				<div class="progress_txt" style="magin-left:20px;margin-top:40px;">
					<ul>
						<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 5 || taskInfoVO.taskType == 6}">
							<!-- <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly" > -->
							<li><span class="txt_title"><spring:message code='ezTask.t200914' /></span><span class="txt_content" id="prog1"><c:out value = '${date}' /></span></li>
							<li><span class="txt_title"><spring:message code='ezTask.t1221' /></span><span class="txt_content" id="repCount"><c:out value = '${repeatCount}' /></span></li>
						
						</c:if>
						<c:if test="${taskInfoVO.taskType == 1 || taskInfoVO.taskType == 2 || taskInfoVO.taskType == 3}">
							<li><span class="txt_title"><spring:message code='ezTask.t121' /></span><span class="txt_content"><c:out value = '${fn:substring(taskInfoVO.startDate, 0, 10) }' /></span></li>
							<li><span class="txt_title"><spring:message code='ezTask.t9002' /></span><span class="txt_content"><c:out value = '${fn:substring(taskInfoVO.endDate, 0, 10) }' /></span></li>
						</c:if>
					</ul>
					<!-- 18-05-04 김민성 - 담당자만 업무 정보 수정 가능 하도록 수정 -->
					<!-- 18-05-16 구해안 - 지시자만 업무 정보 수정 가능 하도록 수정, 담당자만 업무 내용 수정 가능하도록 수정 -->
					<a id="updateStatus" class="imgbtn imgbck"><span onclick="return update_status()"><spring:message code='ezTask.lhj01' /></span></a>
				</div>
				<div id="Sdatepicker" style="float:right;"></div>
			</div>
		</div>
		
		
		 
		<div id="tabpart" class="portlet_tabpart03" style="margin-bottom: 3px; border-top: 0px; padding:0px;">
			<div class="portlet_tabpart03_top" id="tab1">			
				<p id = "MailEnv_sub0"><span divname="MailEnv_div0" id="1tab0" class="tabon"><spring:message code='ezTask.lhj02' /></span></p>					
				<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}">
					<p id = "MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezTask.t2010' /></span></p>					
				</c:if>
				<p id = "MailEnv_sub2"><span divname="MailEnv_div2" id="1tab2">
					<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}"><spring:message code='ezTask.jjh01' /></c:if>
					<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 1}"><spring:message code='ezTask.t2011' /></c:if></span>
				</p>											
				<p id = "MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezTask.t2013' /></span></p>
				<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 5 || taskInfoVO.taskType == 6}">
				<p id = "MailEnv_sub4"><span divname="MailEnv_div4" id="1tab4"><spring:message code='ezTask.t200904' /></span></p>
				</c:if>
				<!-- 지시사항 수정, 진행사항 수정 레이어팝업호출-->
				<div style="float: right; margin-top: 3px;">
				<!-- 18-05-04 김민성 - 담당자만 업무 정보 수정 가능 하도록 수정 -->
				<!-- 18-05-16 구해안 - 지시자만 업무 정보 수정 가능 하도록 수정, 담당자만 업무 내용 수정 가능하도록 수정 -->
					<a id="editTaskInfo" class="imgbtn imgbck" style="display:none;"><span onclick="return edit_taskInfo()"><spring:message code='ezTask.t1512' /></span></a>
					<a id="editTaskWork" class="imgbtn imgbck" style="display:none; "><span onclick="return edit_taskwrok()">
						<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}"><spring:message code='ezTask.jjh02' /></c:if>
						<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 1}"><spring:message code='ezTask.t1511' /></c:if></span>
					</a>
					<a id="editTaskChisi" class="imgbtn imgbck" style="display:none; "><span onclick="return edit_task()" id= "chisiButton"><spring:message code='ezTask.t1513' /></span></a>
				</div>
			</div>
		</div> 		
		<table id="taskInfo" class="layout">
		 	<tr>
				<td style="height:20px">
					<table class="content" style="margin-top:3px">
						<tr>
							<th><spring:message code='ezTask.t117' /></th>
							<td style="white-space:nowrap">
								<div style="CURSOR:pointer; " onClick="show_personinfo('0')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
									<c:out value = '${taskInfoVO.creatorName }' />&nbsp;(<c:out value = '${taskInfoVO.creatorDeptName }' />)
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t155' /></th>
							<td style="padding-right:15px;white-space:nowrap">${fn:substring(taskInfoVO.createDate, 0, 10) }</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t2003' /></th>
							<td style="width:100%">
								<div>
									<span class="taskType"></span>
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t156' /></th>
							<td>
								<div>
									<c:choose>
										<c:when test="${taskInfoVO.importance == '1' }">
											<spring:message code = 'ezTask.t171' />
										</c:when>
										<c:when test="${taskInfoVO.importance == '2' }">
											<spring:message code = 'ezTask.t172' />
										</c:when>
										<c:otherwise>
											<spring:message code = 'ezTask.t173' />
										</c:otherwise>
									</c:choose>
								</div>
							</td>
						</tr>
						<tr id ="persontr">
							<th><spring:message code='ezTask.t2005' /></th>
							<td colspan="3" width="100%">
								<div style="cursor:pointer; " onClick="show_personinfo('${taskInfoVO.personID }')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
									<c:out value = '${taskInfoVO.personName }' />&nbsp;(<c:out value = '${taskInfoVO.personDeptName }' />)
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t157' /></th>
							<td colspan="3" style="width:100%; height: 40px;">
								<div id="taskShareList" style="overflow-Y: auto; line-height: 1.5em;">
									<c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}">
										<span style="cursor:pointer;margin-top: 0px;margin-bottom: 0px;" onclick="show_personinfo('${taskShareVO.sharerID }')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
											<c:out value = '${taskShareVO.sharerName }' />&nbsp;(<c:out value = '${taskShareVO.sharerDeptName }' />)
										</span>
										<c:if test="${not status.last }">,&nbsp;</c:if>
									</c:forEach>
								</div>
							</td>
						</tr>
						
						<c:if test="${useTodoMemo == 'YES'}">
							<tr>
				            	<th><spring:message code='ezTask.t170' /></th>
				            	<td id="TextMemo" colspan="3" style="height: 40px;">
				            		<div style="overflow-y:auto;padding-top:2px;">
				            			<c:out value = '${taskInfoVO.memo }' />
				            		</div>
				            	</td>
							</tr>
						</c:if>
					</table>
				</td>
			</tr>
			
		</table>
		
		<table id="normalScreen" class="layout" style="height:100%; display:none;">
			<tr>
				<td style="height: 399px;">
					<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:99.7%; overflow:auto; border: 1px solid #e2e2e2; margin-top: 3px;"></iframe>
				</td>
			</tr>
			
			<tr>
				<td style="padding-top:4px;">
					<table class="file">
						<tr>
							<th><spring:message code='ezTask.t160' /></th>
							<td class="pos1">
								<div id="attachedfileDIV" style="overflow:auto;height:57px;background-color:white;text-align:left"></div>
							</td>
							<td class="pos2">
								<a class="imgbtn imgbck"><span onClick="attach_SelectAll('1')" style="width: 50px;"><spring:message code='ezTask.t161' /></span></a><br />
								<a class="imgbtn imgbck"><span onClick="attach_Download('1')" style="width: 50px;"><spring:message code='ezTask.t96' /></span></a>
							</td>
							<td id="Td2" style="display:none"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<table id="tablework" class="layout" style="height:100%; display:none;">
			<tr style="vertical-align:top">
				<td colspan="3" style="padding-bottom:4px; height:440px;">
					<iframe id="message2" class="viewbox" name="message2" style="padding:0; height:100%; width:99.7%; overflow:auto; border: 1px solid #e2e2e2; margin-top: 3px;"></iframe>
				</td>
			</tr>
			<tr style="vertical-align:top">
				<td style="padding-top:0px">
					<table class="file">
						<tr>
							<th><spring:message code='ezTask.t160' /></th>
							<td class="pos1">
								<div id="attachedfileDIV2" style="overflow: auto;height: 57px;background-color:white;text-align:left"></div>
							</td>
							<td class="pos2"><a class="imgbtn imgbck">
								<span  onClick="attach_SelectAll('2')" style="width: 50px;"><spring:message code='ezTask.t161' /></span></a><br />
								<a class="imgbtn imgbck"><span onClick="attach_Download('2')" style="width: 50px;"><spring:message code='ezTask.t96' /></span></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<!-- 2018-05-17 구해안 -->
		<table id="tablecomment" class="layout" style="height:0%;width:100%;table-layout: fixed; overflow:auto;margin-top:6px;display:none;">
		
		</table>
		
		<table id="taskRep" class="layout" style="display:none;">
		 	<tr>
				<td>
					<div id="new_div_body" style="height: 450px; overflow-y: auto;">
						<table class="content" id="new_list_body" style="text-align: center; margin-top:3px">
							<tr >
								<th style="width:  100px; text-align: center;"><spring:message code='ezTask.t1221' /></th>
								<th style="width: 320px; text-align: center;"><spring:message code='ezTask.t200914' /></th>
								<th style="width: 320px; text-align: center;"><spring:message code='ezTask.t120' /></th>
							</tr>	
							<tr class="new_row_body" id="new_row_body" style="display:none;" repeatcount="0" startdate="" >
								<td class="tr_Read" style="white-space:nowrap; width: 100px;" ></td>
								<td class="tr_Read" style="white-space:nowrap; width: 320px;" ></td>
								<td class="tr_Read" style="white-space:nowrap; width: 320px;" ></td>
							</tr>
							<tr id="noDataTag"><td colspan='3' style='text-align: center;'><spring:message code='ezTask.t200912' /></td></tr>					
						</table>
					</div>
				</td>
			</tr>		
		</table>
		
		<div id="taskDescription" style="padding-top: 20px;">
			<ul style="padding-left: 0px; list-style:none;">
				<li style="padding-top: 10px; font-size:12px;"> ▒ <spring:message code='ezTask.t200906' /></li>
				<li style="padding-top: 10px; font-size:12px;"> ▒ <spring:message code='ezTask.t200907' /></li>
				<li style="padding-top: 10px; font-size:12px;"> ▒
					<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}"><spring:message code='ezTask.jjh03' /></c:if>
					<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 1}"><spring:message code='ezTask.t200908' /></c:if> 
				</li>
				<li style="padding-top: 10px; font-size:12px;"> ▒ <spring:message code='ezTask.t200909' /></li>				
				<li style="padding-top: 10px; font-size:12px;"> ▒ <spring:message code='ezTask.t200910' /></li>				
			</ul>
		</div>
	<!-- 보미 - 인쇄미리보기 화면으로 이동.주석처리	
		<div id="printScreen" style="display: none;">
			<table id="printTable" class="layout" >
				<tr>
					<td class="popup_title_txt" style="padding-top: 10px;"><img src="/images/popup_title_icon.gif" class="popup_title_img">
						<spring:message code='ezTask.lhj02' />
					</td>
				</tr>
				<tr>
					<td>
						<table class="content">
							<tr>
								<th><spring:message code='ezTask.t117' /></th>
								<td style="white-space:nowrap">
									<div style="CURSOR:pointer; " onClick="show_personinfo('0')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
										<c:out value = '${taskInfoVO.creatorName }' />&nbsp;(<c:out value = '${taskInfoVO.creatorDeptName }' />)
									</div>
								</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t155' /></th>
								<td style="padding-right:15px;white-space:nowrap">${fn:substring(taskInfoVO.createDate, 0, 10) }</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t2003' /></th>
								<td style="width:100%">
									<div>
										<span class="taskType"></span>
									</div>
								</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t156' /></th>
								<td>
									<div>
										<c:choose>
											<c:when test="${taskInfoVO.importance == '1' }">
												<spring:message code = 'ezTask.t171' />
											</c:when>
											<c:when test="${taskInfoVO.importance == '2' }">
												<spring:message code = 'ezTask.t172' />
											</c:when>
											<c:otherwise>
												<spring:message code = 'ezTask.t173' />
											</c:otherwise>
										</c:choose>
									</div>
								</td>
							</tr>
							<tr id ="persontr">
								<th><spring:message code='ezTask.t2005' /></th>
								<td colspan="3" width="100%">
									<div style="cursor:pointer; " onClick="show_personinfo('${taskInfoVO.personID }')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
										<c:out value = '${taskInfoVO.personName }' />&nbsp;(<c:out value = '${taskInfoVO.personDeptName }' />)
									</div>
								</td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t157' /></th>
								<td colspan="3" style="width:100%">
									<div id="taskShareList" style="overflow-Y: auto; line-height: 1.5em;">
										<c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}">
											<span style="cursor:pointer;margin-top: 0px;margin-bottom: 0px;" onclick="show_personinfo('${taskShareVO.sharerID }')" >
												<c:out value = '${taskShareVO.sharerName }' />&nbsp;(<c:out value = '${taskShareVO.sharerDeptName }' />)
											</span>
											<c:if test="${not status.last }">,&nbsp;</c:if>
										</c:forEach>
									</div>
								</td>
							</tr>
							
							<c:if test="${useTodoMemo == 'YES'}">
								<tr>
					            	<th><spring:message code='ezTask.t170' /></th>
					            	<td id="TextMemo" colspan="3">
					            		<div style="overflow-y:auto;padding-top:2px;">
					            			<c:out value = '${taskInfoVO.memo }' />
					            		</div>
					            	</td>
								</tr>
							</c:if>
						</table>
					</td>
				</tr>				
				-- 주석 --
				<tr>
					<td>
						<div style="padding-bottom: 10px;">
							<ul style="padding-left: 0px; list-style:none;">
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200906' /></li>
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200907' /></li>
								<li style="padding-top: 10px; font-size:11px;"> ▒
									<c:if test="${taskInfoVO.taskType != 4 && taskInfoVO.taskType != 1}"><spring:message code='ezTask.jjh03' /></c:if>
									<c:if test="${taskInfoVO.taskType == 4 || taskInfoVO.taskType == 1}"><spring:message code='ezTask.t200908' /></c:if> 
								</li>
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200909' /></li>				
								<li style="padding-top: 10px; font-size:11px;"> ▒ <spring:message code='ezTask.t200910' /></li>				
							</ul>
						</div>
					</td>
				</tr>
				<tr style="height:20px;">
					<td class="popup_title_txt" style="padding-top: 10px;"><img src="/images/popup_title_icon.gif" class="popup_title_img">
						<c:choose>
							<c:when test="${taskInfoVO.taskType == '1' || taskInfoVO.taskType == '4'}">
								<spring:message code='ezTask.t2011' />
							</c:when>
							<c:otherwise>
								<spring:message code='ezTask.t2010' />
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td><div class='margin' id="printDocument" style="padding:10px;BORDER: #ddd 1px solid;height:100%;background-color: white"></div></td>
				</tr>
				<tr id="printattachView" style="display:none;">
					<td style="height:20px; padding-top:10px;">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t160' /></th>
								<td style="width:100%"><div id="printAttach" style="margin-top:0px;padding-top:0px;overflow:visible; height: auto; background-color:white;text-align:left;"></div></td>
							</tr>
						</table>
					</td>
				</tr>
				
				-- 진행사항 --
				<tr id="printTaskWork" style="display:none; height:20px;">
					<td class="popup_title_txt" style="padding-top: 10px;"><img src="/images/popup_title_icon.gif" class="popup_title_img">
						<spring:message code='ezTask.t2011' />
					</td>
				</tr>
				<tr id="printTaskWorkContent" style="display:none;">
					<td><div class='margin' id="printDocument2" style="padding:10px;BORDER: #ddd 1px solid;height:100%;background-color: white"></div></td>
				</tr>
				<tr id="printattachViewProgress" style="display:none;">
					<td style="height:20px; padding-top:10px;">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t160' /></th>
								<td style="width:100%"><div id="printAttach2" style="margin-top:0px;padding-top:0px;overflow:visible; height: auto; background-color:white;text-align:left"></div></td>
							</tr>
						</table>
					</td>
				</tr>
				-- 의견 --
				<tr id ="optiontr" style="height:20px">
					<td class="popup_title_txt" style="padding-top: 10px;"><img src="/images/popup_title_icon.gif" class="popup_title_img">
						<spring:message code='ezTask.t2013' />
					</td>
				</tr>
				
				<tr id="printCommentView" style="display:none">
-- 					<td style="height:20px">
						<table class="file">
							<tr>
								<td colspan='2' style="width:90%;height:20px;vertical-align:top"><div id="printComment" style="overflow:visible; height: auto; background-color:white;text-align:left"></div></td>
							</tr>
						</table>
					</td> --
				</tr>				
				-- 반복업무현황 --
				<tr id ="reptr" style="height:20px;padding-bottom:20px;display:none;">
					<td class="popup_title_txt" style="padding-top: 10px;"><img src="/images/popup_title_icon.gif" class="popup_title_img">
						<spring:message code='ezTask.t200904' />
					</td>
				</tr>
				
				<tr id="repTable">
				</tr>			
			</table>
		</div>
		-->

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<script type="text/javascript">
    		Tab1_NewTabIni("tab1");
		</script>
	</body>

</html>
