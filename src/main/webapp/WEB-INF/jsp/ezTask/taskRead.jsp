<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezTask.t143' /></title>
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/css/Tab.css" type="text/css">
		<link rel="stylesheet" href="/css/jquery.lineProgressbar.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezTask.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/ezTask/jquery.lineProgressbar.js"></script>
		
		<script type="text/javascript">
			var userid = "${userInfo.id }";
			var taskid = "${taskInfoVO.taskID }";
			var contentpath = "${taskInfoVO.contentPath }";
			var personContentpath = "${taskInfoVO.personContentPath }";
			var ownerid = "${taskInfoVO.ownerID }";
			var creatorid = "${taskInfoVO.creatorID }";
			var parentid = "${taskInfoVO.parentID }";
			var taskstatus = "${taskInfoVO.taskStatus }";
			var completerate = "${taskInfoVO.completeRate }";
			var duration = 500;
			var delayColor = "${delayColor }";
			var completeColor = "${completeColor }";
		    var tasktype = "${taskInfoVO.taskType }";
		    var content = "${contentPerson }";
		    var date = "${date }";
		    var type = "${type }";
		    var personid = "${taskInfoVO.personID }";
		    var taskCommentListSize = "${taskCommentListSize }";
		    var tempbody = "";
		    var pUse_Editor = "${useEditor}";
		    var AttachLimit = 5;
		    var hasTaskAttach = "${taskInfoVO.hasAttach}";
		    var taskAttachList = "${taskAttachList }";
		    var hasTaskWorkAttach = "${taskInfoVO.personAttach}";
		    var taskWorkAttachList = "${taskWorkAttachList }";
		    var useTodoMemo = "${useTodoMemo }";
		    
		    $(document).ready(function() {
				load_bodyhtml();
				if (hasTaskAttach == 'Y') {
					document.getElementById('attachedfileDIV').innerHTML = taskAttachList;
		    	}
				
				load_bodyhtml2(personContentpath);
				if (hasTaskWorkAttach == 'Y') {
					document.getElementById('attachedfileDIV2').innerHTML = taskWorkAttachList
		    	}
		    	
		        setTimeout(scrollTop, 1000);
		        
		        if (useTodoMemo == 'YES') {
		    		$("#message").closest("td").height(document.documentElement.clientHeight - 490 + "PX");
			    	$("#message2").closest("td").height(document.documentElement.clientHeight - 490 + "PX");
			    	$("#taskCommentList").height(document.documentElement.clientHeight - 470 + "PX");
		    	} else {
		    		$("#message").closest("td").height(document.documentElement.clientHeight - 450 + "PX");
			    	$("#message2").closest("td").height(document.documentElement.clientHeight - 450 + "PX");
			    	$("#taskCommentList").height(document.documentElement.clientHeight - 430 + "PX");
		    	}

		        if (tasktype == "1") {
		            document.getElementById("MailEnv_sub2").style.display = "none";
		            setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />");
		            setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />");
		            document.getElementById("taskType").innerHTML = "<spring:message code='ezTask.t2000' />";
		        } else if (tasktype == "2") {
		            document.getElementById("taskType").innerHTML = "<spring:message code='ezTask.t2001' />";
		        } else {
		            document.getElementById("taskType").innerHTML = "<spring:message code='ezTask.t2002' />";
		        }

				/* 의견카운트 */
		        if (taskCommentListSize == 0) {
		        	document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />";
		        } else { 
		        	document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />" + "(" + taskCommentListSize + ")";
		        }
		        
				setTimeout(onloadchangtab, 100);
				
				initProgressBar(taskstatus, completerate);
		    });
		    
		    window.onresize = function () {
		    	if (useTodoMemo == 'YES') {
		    		$("#message").closest("td").height(document.documentElement.clientHeight - 490 + "PX");
			    	$("#message2").closest("td").height(document.documentElement.clientHeight - 490 + "PX");
			    	$("#taskCommentList").height(document.documentElement.clientHeight - 470 + "PX");
		    	} else {
		    		$("#message").closest("td").height(document.documentElement.clientHeight - 450 + "PX");
			    	$("#message2").closest("td").height(document.documentElement.clientHeight - 450 + "PX");
			    	$("#taskCommentList").height(document.documentElement.clientHeight - 430 + "PX");
		    	}
		    	
	         }
		    
			function scrollTop() {
				try {
					window.scroll(0, 1);
				} catch (e) { }
			}

			/* progressBar 조회 */
			function initProgressBar(taskstatus, completerate) {
				if (completerate == '0') {
					duration = 0;
				} else {
					duration = 500;
				}
				
				if (taskstatus == '4') {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: delayColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%',
						duration : duration
					});
				} else if (taskstatus == '3') {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: completeColor,
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%',
						duration : duration
					});
				} else {
					$('#taskProgressBar').LineProgressbar({
						percentage: completerate,
						fillBackgroundColor: '#3498db',
						backgroundColor: '#EEEEEE',
						radius: '10px',
						height: '10px',
						width: '100%',
						duration : duration
					});
				}
			}
			
			/* 초기 탭선택스크립트 */
			function onloadchangtab() {
				if (type == "1" && (tasktype != "1" && ownerid == userid)) {
					Tab1_MouseClick(document.getElementById("1tab2"));
				} else if (type == "2") {
					Tab1_MouseClick(document.getElementById("1tab3"));
				} else {
					Tab1_MouseClick(document.getElementById("1tab1"));
				}
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
						doc.write(html);
						doc.close();
				        
						$("#message").contents().find("body").css("word-wrap", "break-word");
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
							doc.write(html);
							doc.close();
					        
							$("#message2").contents().find("body").css("word-wrap", "break-word");
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
					
				var heigth = window.screen.availHeight;
				var width = window.screen.availWidth;
				var left = (width - 420) / 2;
				var top = (heigth - 450) / 2;
				window.open("/ezCommon/showPersonInfo.do?id=" + userid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
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
						location.href = "/ezTask/downloadAttach.do?filePath=" + GetAttribute(checks.item(suffix), "filePath") + "&fileName=" + encodeURIComponent(GetAttribute(checks.item(suffix++), "fileName"));
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
				var id = taskid;
				if (parentid != "0") {
					id = parentid;
				}
	
				if (document.getElementById("TextComment").value == "") {
					alert("<spring:message code='ezTask.t241' />");
					return;
				}
				
				$.ajax({
					type : "POST",
					dataType : "json",
					async : false,
					url : "/ezTask/taskSaveComment.do",
					data : {
							taskID : id,
							textComment : $("#TextComment").val()
					},
					success: function(result){
						/* alert("<spring:message code='ezTask.t222' />"); */
						
						var list = result.taskCommentList;
						taskCommentListSize = list.length;
						
						/* 탭의견 카운트 */
						if (taskCommentListSize == 0) {
							document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />";
						} else { 
							document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />" + "(" + taskCommentListSize + ")";
						}
						
						/* commentList */
						taskCommentList = "";
						list.forEach(function(vo, index) {
							commentorID = "\"" + vo.commentorID + "\"";
							deleteCommentParam =  "\"" + vo.commentorID + "\", \"" + vo.commentID + "\"";
							taskCommentList += "<span style='cursor:pointer;color: #2828A5;' onclick='show_personinfo(" + commentorID + ")'>" + vo.commentorName + "</span>";
							taskCommentList += "<span style='color: #2828A5;'> (" + vo.commentDate.substring(0, 16) + ") : </span>";
							taskCommentList += "<span>";
							taskCommentList += vo.comment;
							taskCommentList += "&nbsp;<img src='/images/comment_delete.gif' title='" + "<spring:message code='ezTask.t159' />" + "' onclick='delete_comment(" + deleteCommentParam + ")' style='cursor: pointer' width='11' height='11' />";
							taskCommentList += "</span>";
							taskCommentList += "<br/>";
						});
						
						console.log(taskCommentList);
						$("#taskCommentList").html(taskCommentList);
						$("#TextComment").val("");
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			
			var deltaskid = "";
			function delete_task() {
				if (!confirm("<spring:message code='ezTask.t106' />")) {
					return;
				}
	
				var id = taskid;
				if (parentid != "0") {
					id = parentid;
				}
	
				deltaskid = id + ";";
				
				$.ajax({
					type : "POST",
					url : "/ezTask/taskDelete.do",
					dataType : "json",
					data : {
						taskIDList : deltaskid
					},
					success : function(result) {
						window.opener.RefreshView()
					},
					error : function(jqXHR, textStatus, errorThrown) {
						alert("<spring:message code='ezTask.t108' />")
					},
					complete : function() {
						window.close();
					}
				});
			}
			
			/* 업무수정 */
			function edit_task() {
			    var id = taskid;
			    if (parentid != "0") {
			    	id = parentid;
			    }
			    
			    var win;
			    
				/* 레이어팝업으로 taskWrite 호출 */
				if (useTodoMemo == 'YES') {
					var feature = GetOpenPosition(760, 700);
		        	
					DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.92, "/ezTask/taskWrite.do?taskID=" + id, "",
			                "height = 700px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
		        } else {
					var feature = GetOpenPosition(760, 645);
		        	
					DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.92, "/ezTask/taskWrite.do?taskID=" + id, "",
			                "height = 645px, width = 760px, status = no, toolbar=no, menubar=no,location=no, scrollbars=no, resizable=1" + feature);
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
				
				var id = taskid;
				if (parentid != "0") {
				    id = parentid;
				}
				
			    $.ajax({
					type : "POST",
					url : "/ezTask/taskDeleteComment.do",
					dataType : "json",
					data : {
						taskID : id,
						commentID : commentid
					},
					success : function(result) {
						/* alert("<spring:message code='ezTask.t148' />"); */
						
						var list = result.taskCommentList;
						taskCommentListSize = list.length;
						
						/* 탭의견 카운트 */
						if (taskCommentListSize == 0) {
							document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />";
						} else { 
							document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />" + "(" + taskCommentListSize + ")";
						}
						
						/* commentList */
						taskCommentList = "";
						list.forEach(function(vo, index) {
							commentorID = "\"" + vo.commentorID + "\"";
							deleteCommentParam =  "\"" + vo.commentorID + "\", \"" + vo.commentID + "\"";
							taskCommentList += "<span style='cursor:pointer;color: #2828A5;' onclick='show_personinfo(" + commentorID + ")'>" + vo.commentorName + "</span>";
							taskCommentList += "<span style='color: #2828A5;'> (" + vo.commentDate.substring(0, 16) + ") : </span>";
							taskCommentList += "<span>";
							taskCommentList += vo.comment;
							taskCommentList += "&nbsp;<img src='/images/comment_delete.gif' onclick='delete_comment(" + deleteCommentParam + ")' style='cursor: pointer' width='11' height='11' />";
							taskCommentList += "</span>";
							taskCommentList += "<br/>";
						});
						
						console.log(taskCommentList);
						$("#taskCommentList").html(taskCommentList);
					},
					error : function(jqXHR, textStatus, errorThrown) {
						
					}
				});
			}
			
			/* 진행상태 수정 */
			function update_status() {
				if (personid != userid) {
					alert("<spring:message code='ezTask.t149' />");
					return;
				}
				
				DivPopUpShow(200, 150, "/ezTask/taskStatus.do?taskID=" + taskid);
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
			}
			
			var selecttab = "1";
			function ChangeTab(obj) {
			    var pSelectTab = GetAttribute(obj,"divname");
			    switch (pSelectTab) {
			        case "MailEnv_div1":
			            selecttab = "1";
			            document.getElementById("normalScreen").style.display = "";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "none";
			            
			            if (ownerid == userid) {
				        	document.getElementById("editTask").style.display = "";
				        	document.getElementById("editTaskWork").style.display = "none";
				        } else if (personid == userid) {
				        	document.getElementById("editTask").style.display = "none";
				        	document.getElementById("editTaskWork").style.display = "none";
				        }
			            
			            break;
			        case "MailEnv_div2":
			            selecttab = "2";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "";
			            document.getElementById("tablecomment").style.display = "none";
			            
			            if (ownerid == userid) {
				        	document.getElementById("editTask").style.display = "none";
				        	document.getElementById("editTaskWork").style.display = "none";
				        } else if (personid == userid) {
				        	document.getElementById("editTask").style.display = "none";
				        	document.getElementById("editTaskWork").style.display = "";
				        }
			            
			            break;
			        case "MailEnv_div3":
			            selecttab = "3";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "";
			            
			        	document.getElementById("editTask").style.display = "none";
			        	document.getElementById("editTaskWork").style.display = "none";
			            
			            break;
			    }
			}
			
			function comment_keydown() {
			    if (window.event.keyCode == "13")
			        add_comment();
			}
			
			/* 진행사항 수정 스크립트 */
			function edit_taskwrok() {
				var id = taskid;
			    if (parentid != "0")
			        id = parentid;
			    var win;
			    
				/* 레이어팝업으로 taskWorkWriteCross 호출 */
				var feature = GetOpenPosition(760, 700);
				DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.92, "/ezTask/taskWorkWrite.do?taskID=" + id, "",
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
			
			function beforeprint() {
				$(".popup").css('background-image', 'none');
				
			    document.getElementById("printScreen").style.display = "block";
			    document.getElementById("normalScreen").style.display = "none";
			    document.getElementById("menu").style.display = "none";
			    document.getElementById("close").style.display = "none";
			    document.getElementById("tabpart").style.display = "none";
			    document.getElementById("tablework").style.display = "none";
			    document.getElementById("tablecomment").style.display = "none";
			
			    var status = "";
				switch (taskstatus) {
					case "1":
			            status = "<spring:message code='ezTask.t97' />";
						break;
					case "2":
						status = "<spring:message code='ezTask.t98' />";
						break;
					case "3":
						status = "<spring:message code='ezTask.t99' />";
						break;
					case "4":
						status = "<spring:message code='ezTask.t100' />";
						break;
				}
			
				status += ", <spring:message code='ezTask.t144' />" + completerate + "%";
			
			    $("#printComment").html($("#taskCommentList").html());
			    $("#printComment img").remove();
			    
			    document.getElementById("printDocument").innerHTML = message.document.body.innerHTML;
			    document.getElementById("printAttach").innerHTML = document.getElementById("attachedfileDIV").innerHTML;
			
			    if (tasktype != "1") {
			    	$("#printTaskWork").show();
			    	$("#printTaskWorkContent").show();
			        document.getElementById("printDocument2").innerHTML = message2.document.body.innerHTML;
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
			    
			    if ($("#taskCommentList").html().trim() != "") {
			        document.getElementById("printCommentView").style.display = "";
			        document.getElementById("optiontr").style.display = "";
			    } else {
			        document.getElementById("printCommentView").style.display = "none";
			        document.getElementById("optiontr").style.display = "none";
			    }
			
			    if (document.getElementById("attachedfileDIV").innerHTML.trim() != "")
			        printattachView.style.display = "";
			
			    if (tasktype != "1" && document.getElementById("printAttach2").innerHTML.trim() != "")
			    	printattachViewProgress.style.display = "";
			
			    window.print();
			    
			    $(".popup").css("background-image", "url('/images/kr/cm/popup_bg.gif')");
			    
			    document.getElementById("printScreen").style.display = "none";
			    document.getElementById("normalScreen").style.display = "";
			    document.getElementById("menu").style.display = "";
			    document.getElementById("close").style.display = "";
			    document.getElementById("tabpart").style.display = "";
			    document.getElementById("tablework").style.display = "";
			    document.getElementById("tablecomment").style.display = "";
			
			    if (selecttab == "1") {
			        document.getElementById("normalScreen").style.display = "";
			        document.getElementById("tablework").style.display = "none";
			        document.getElementById("tablecomment").style.display = "none";
			    }
			    else if (selecttab == "2") {
			        document.getElementById("normalScreen").style.display = "none";
			        document.getElementById("tablework").style.display = "";
			        document.getElementById("tablecomment").style.display = "none";
			    }
			    else if (selecttab == "3") {
			        document.getElementById("normalScreen").style.display = "none";
			        document.getElementById("tablework").style.display = "none";
			        document.getElementById("tablecomment").style.display = "";
			    }
			}

			window.onunload = function () {
			    try {window.opener.RefreshView();} catch (e) {}
			}

			function messageload() {
			    document.getElementById("printDocument").innerHTML = message.document.body.innerHTML;
			}
			
			function getTaskWorkAttachList() {
				$.ajax({
					type : "POST",
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
		</script>
	</head>
	
	<body class="popup" style="overflow:hidden; height:99%">
		<div id="menu">
			<ul>
				<c:if test="${userInfo.id == taskInfoVO.creatorID }">
					<li id="delete"><SPAN onClick="delete_task()"><spring:message code='ezTask.t115' /></SPAN></li>
				</c:if>
				<li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li>
			</ul>
		</div>
		<div id="close">
			<ul>
				<li><span onClick="window.close()"><spring:message code='ezTask.t9' /></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<!-- 이쪽에 진행단계 -->
		<table id="taskProgress" class="layout">
			<tr>
				<td>
					<spring:message code='ezTask.t119' />
				</td>
			<tr>
			<tr>
				<td>
					<table style = "border: 1px solid #b6b6b6;margin: 0; width: 100%;">
						<colgroup><col width="80%" /><col width="20%" /></colgroup>
						<tr>
							<td style = "padding: 0px 2px 0px 2px; background: #FFF; border: 1px solid #b6b6b6;">
								<div id="taskProgressBar" style="-webkit-print-color-adjust:exact;print-color-adjust: exact;"></div>
							</td>
							<td style = "padding: 0px 2px 0px 2px; background: #FFF; border: 1px solid #b6b6b6;">
								<div style="text-align:center; vertical-align: middle;">
									<a id="updateStatus" class="imgbtn"><span onclick="return update_status()"><spring:message code='ezTask.lhj01' /></span></a>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
		<!-- 이쪽에 업무정보 -->
		 
		<table id="taskInfo" class="layout">
			<tr>
				<td>
					<spring:message code='ezTask.lhj02' />
				</td>
			<tr>
			
		 	<tr>
				<td style="height:20px">
					<table class="content">
						<tr>
							<th><spring:message code='ezTask.t117' /></th>
							<td style="white-space:nowrap">
								<div style="CURSOR:pointer; " onClick="show_personinfo('0')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
									<c:out value = '${taskInfoVO.creatorName }' />
								</div>
							</td>
							<th><spring:message code='ezTask.t155' /></th>
							<td style="padding-right:15px;white-space:nowrap">${fn:substring(taskInfoVO.createDate, 0, 10) }</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t2003' /></th>
							<td style="width:100%">
								<div>
									<span id="taskType"></span>
								</div>
							</td>
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
								<div style="cursor:pointer; " onClick="show_personinfo('${taskInfoVO.taskPersonID }')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
									<c:out value = '${taskInfoVO.taskPersonName }' />
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t157' /></th>
							<td colspan="3" style="width:100%">
								<div id="taskShareList" style="overflow-Y: auto; height: 20px; line-height: 1.5em;">
									<c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}">
										<span style="cursor:pointer;margin-top: 0px;margin-bottom: 0px;" onclick="show_personinfo('${taskShareVO.sharerID }')" >
											<c:out value = '${taskShareVO.sharerName }' /> (<c:out value = '${taskShareVO.sharerDeptName }' />)
										</span>
										<c:if test="${not status.last }">,&nbsp;</c:if>
									</c:forEach>
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t121' /></th>
							<td>
								<div>
									<c:out value = '${fn:substring(taskInfoVO.startDate, 0, 10) }' />
								</div>
							</td>
							<th><spring:message code='ezTask.t122' /></th>
							<td>
								<div>
									<c:out value = '${fn:substring(taskInfoVO.endDate, 0, 10) }' />
								</div>
							</td>
						</tr>
						<tr>
							<th><spring:message code='ezTask.t118' /></th>
							<td colspan="3">
								<div style="overflow-y:auto;padding-top:2px">
									<c:out value = '${taskInfoVO.title }' />
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
		</table>
		
		<div id="tabpart" class="portlet_tabpart03" style="margin-top: 3px; margin-bottom: 3px;">
			<div class="portlet_tabpart03_top" id="tab1">
				<p id = "MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezTask.t2010' /></span></p>
				<p id = "MailEnv_sub2"><span divname="MailEnv_div2" id="1tab2"><spring:message code='ezTask.t2011' /></span></p>
				<p id = "MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezTask.t2013' /></span></p>
				
				<!-- 지시사항 수정, 진행사항 수정 레이어팝업호출-->
				<div style="float: right; margin-top: 3px;">
					<a id="editTask" class="imgbtn" style="display:none; "><span onclick="return edit_task()"><spring:message code='ezTask.t151' /></span></span></a>
					<a id="editTaskWork" class="imgbtn" style="display:none; "><span onclick="return edit_taskwrok()"><spring:message code='ezTask.t151' /></span></a>
				</div>
			</div>
		</div> 
		
		<table id="normalScreen" class="layout" style="height:100%">
			<tr>
				<c:choose>
					<c:when test="${useTodoMemo == 'YES' }">
						<td style="padding-bottom:4px;height: 440px;">
							<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:99.8%; overflow:auto;"></iframe>
						</td>
					</c:when>
					<c:otherwise>
						<td style="padding-bottom:4px;height: 495px;">
							<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:99.8%; overflow:auto;"></iframe>
						</td>
					</c:otherwise>
				</c:choose>
			</tr>
			
			<tr>
				<td style="padding-top:4px;height:20px" class="pad1">
					<table class="file">
						<tr>
							<th><spring:message code='ezTask.t160' /></th>
							<td class="pos1">
								<div id="attachedfileDIV" style="overflow:auto;height:50px;background-color:white;text-align:left"></div>
							</td>
							<td class="pos2">
								<a class="imgbtn"><span onClick="attach_SelectAll('1')" style="width: 50px;"><spring:message code='ezTask.t161' /></span></a><br>
								<a class="imgbtn"><span onClick="attach_Download('1')" style="width: 50px;"><spring:message code='ezTask.t96' /></span></a>
							</td>
							<td id="Td2" style="display:none"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<table id="tablework" class="layout" style="height:100%; display:none;" >
			<tr style="vertical-align:top">
				<c:choose>
					<c:when test="${useTodoMemo == 'YES' }">
						<td colspan="3" style="padding-bottom:4px; height:440px;">
							<iframe id="message2" class="viewbox" name="message2" style="padding:0; height:100%; width:99.8%; overflow:auto;"></iframe>
						</td>
					</c:when>
					<c:otherwise>
						<td colspan="3" style="padding-bottom:4px; height:495px;">
							<iframe id="message2" class="viewbox" name="message2" style="padding:0; height:100%; width:99.8%; overflow:auto;"></iframe>
						</td>
					</c:otherwise>
				</c:choose>
			</tr>
			<tr style="vertical-align:top">
				<td style="padding-top:4px" colspan="3">
					<table class="file">
						<tr>
							<th><spring:message code='ezTask.t160' /></th>
							<td class="pos1">
								<div id="attachedfileDIV2" style="overflow: auto;height: 50px;background-color:white;text-align:left"></div>
							</td>
							<td class="pos2"><a class="imgbtn">
								<span  onClick="attach_SelectAll('2')" style="width: 50px;"><spring:message code='ezTask.t161' /></span></a><br>
								<a class="imgbtn"><span onClick="attach_Download('2')" style="width: 50px;"><spring:message code='ezTask.t96' /></span></a>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<table id="tablecomment" class="layout" style="height:100%; display:none;">
			<tr>
				<td style="height:20px" colspan="3">
					<table class ="content" style="width:100%">
						<tr>
							<td style="vertical-align:top">
								<div id="taskCommentList" style="overflow: auto; width:100%; height: 460px; background-color: white; padding-top:3px;">
									<c:forEach var="taskCommentVO" varStatus="status" items="${taskCommentList}">
										<span style="cursor:pointer;color: #2828A5;" onclick="show_personinfo('${taskCommentVO.commentorID }')" ><c:out value = '${taskCommentVO.commentorName }' /></span>
										<span style="color: #2828A5;">(<c:out value = '${fn:substring(taskCommentVO.commentDate, 0, 16) }' />) : </span>
										<span><c:out value='${taskCommentVO.comment}'/>&nbsp;<img src="/images/comment_delete.gif" title="<spring:message code='ezTask.t159' />" onclick="delete_comment('${taskCommentVO.commentorID }', '${taskCommentVO.commentID }')" style="cursor: pointer" width="11" height="11" /></span>
										<br/>
									</c:forEach>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td style="padding-top:10px">
					<table class="content">
						<tr style="padding-top:10px;padding-bottom:4px;height:30px">
							<th><spring:message code='ezTask.t2012' /></th>
							<td class="pos1"><input id="TextComment" style="WIDTH: 99%" type="text" maxLength="100" onKeyDown="comment_keydown()"></td>
							<td class="pos2"><a class="imgbtn"><span onClick="add_comment()"><spring:message code='ezTask.t96' /></span></a></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<div id="printScreen" style="display: none;">
			<table class="layout" >
				<tr>
					<td>
						<c:if test="${taskInfoVO.taskType == '1'}">
							<spring:message code='ezTask.t2011' />
						</c:if>
						<c:if test="${taskInfoVO.taskType != '1'}">
							<spring:message code='ezTask.t2010' />
						</c:if>
						
					</td>
				</tr>
				<tr>
					<td style="padding-top:10px;padding-bottom:4px"><div class='margin' id="printDocument" style="padding:10px;BORDER: #b6b6b6 1px solid;height:100%;background-color: white"></div></td>
				</tr>
				<tr id="printattachView" style="display:none">
					<td style="height:20px" class="pad1">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t169' /></th>
								<td style="width:100%"><div id="printAttach" style="margin-top:0px;padding-top:0px;overflow:visible; height: auto; background-color:white;text-align:left;"></div></td>
							</tr>
						</table>
					</td>
				</tr>
				
				<!-- 진행사항 -->
				<tr id="printTaskWork" style="display:none;">
					<td><spring:message code='ezTask.t2011' /></td>
				</tr>
				<tr id="printTaskWorkContent" style="display:none;">
					<td style="padding-top:10px;padding-bottom:4px"><div class='margin' id="printDocument2" style="padding:10px;BORDER: #b6b6b6 1px solid;height:100%;background-color: white"></div></td>
				</tr>
				<tr id="printattachViewProgress" style="display:none">
					<td style="height:20px" class="pad1">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t169' /></th>
								<td style="width:100%"><div id="printAttach2" style="margin-top:0px;padding-top:0px;overflow:visible; height: auto; background-color:white;text-align:left"></div></td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- 의견 -->
				<tr id ="optiontr" style="height:20px">
					<td><spring:message code='ezTask.t2013' /></td>
				</tr>
				<tr id="printCommentView" style="display:none">
					<td style="height:20px">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t2013' /></th>
								<td style="width:90%;height:20px;vertical-align:top"><div id="printComment" style="overflow:visible; height: auto; background-color:white;text-align:left"></div></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</div>

		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
	
	<script type="text/javascript">
    	Tab1_NewTabIni("tab1");
	</script>
</html>