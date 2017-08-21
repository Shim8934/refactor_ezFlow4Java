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
		<script type="text/javascript" src="<spring:message code='ezTask.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
        <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>

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
		    var admin = "${admin }";
			/* 담당자 인듯 이효진 */		    
// 		    var personlist = "${personList }";

		    var shareid = "${shareID }";
		    var tasktype = "${taskInfoVO.taskType }";
		    var content = "${contentPerson }";
		    var date = "${date }";
		    var type = "${type }";
		    var personid = "${taskInfoVO.personID }";
		    var attachFileInfo = "${attachFileInfo }";
		    var taskCommentListSize = "${taskCommentListSize }";
		    var tempbody = "";
		    var pUse_Editor = "${useEditor}";
		    var AttachLimit = 5;
		    
		    var folderPath = "${folderPath }";
		    
		    $(document).ready(function() {
		    	load_bodyhtml();
		    	load_bodyhtml2();
		    	
		        setTimeout(scrollTop, 1000);
		        
		        //담당자 지정하는부분인것 같음 이효진
		        /* if (personlist != "") {
		            document.getElementById("personlist").innerHTML = personlist;
		        } */

		        if (tasktype == "1") {
		            document.getElementById("MailEnv_sub2").style.display = "none";
		            document.getElementById("persontr").style.display = "none";
		            setNodeText(document.getElementById("1tab1"), "<spring:message code='ezTask.t2011' />");
		            document.getElementById("taskType").innerHTML = "<spring:message code='ezTask.t2000' />";
		            document.getElementById("message").style.height = "295px";
		        } else if (tasktype == "2") {
		            document.getElementById("taskType").innerHTML = "<spring:message code='ezTask.t2001' />";
		        } else {
		            document.getElementById("taskType").innerHTML = "<spring:message code='ezTask.t2002' />";
		        }

				/* 저장 수정버튼 숨김스크립트 */
		        if (ownerid == userid) {
// 		            document.getElementById("save").style.display = "none";
		        } else if (personid == userid) {
// 		            document.getElementById("edit").style.display = "none";
		            document.getElementById("delete").style.display = "none";
		            
		            if(attachFileInfo != "") {
		                AppendFileAttachInfo(attachFileInfo);
		            }
		            
		            tempbody = message2.GetEditorContent();
		        }

		        var taskcheckbox = document.getElementsByName("taskstatuscheckbox");
		        for (var i = 0; i < taskcheckbox.length; i++) {
		            if (taskcheckbox[i].value == taskstatus) {
		                taskcheckbox[i].checked = true;
		                break;
		            }
		        }

		        taskcheckbox = document.getElementsByName("completeracheckbox");
		        for (var i = 0; i < taskcheckbox.length; i++) {
		            if (taskcheckbox[i].value == completerate) {
		                taskcheckbox[i].checked = true;
		                break;
		            }
		        }
		        
				/* 의견카운트 */
		        if (taskCommentListSize == 0) {
		        	document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />";
		        } else { 
		        	document.getElementById("1tab3").innerHTML = "<spring:message code='ezTask.t2013' />" + "(" + taskCommentListSize + ")";
		        }
		        
				setTimeout(onloadchangtab, 100);
		    });
   
			function scrollTop() {
				try {
					window.scroll(0, 1);
				} catch (e) { }
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
			function load_bodyhtml2() {
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
						location.href = GetAttribute(checks.item(suffix++), "filehref");
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
							taskCommentList += "<span style='color: #2828A5;'> (" + vo.commentDate + ") : </span>";
							taskCommentList += "<span>";
							taskCommentList += vo.comment;
							taskCommentList += "<img src='/images/comment_delete.gif' title='asdf' onclick='delete_comment(" + deleteCommentParam + ")' style='cursor: pointer' width='11' height='11' />";
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
			
			function manage_share() {
				var id = taskid;
				
				if (parentid != "0") {
					id = parentid;
				}
	
				var feature = GetOpenPosition(432, 363);
				window.open("/myoffice/ezTask/task_manage_share_Cross.aspx?id=" + id + "&personid=" + personid, "", "height = 363px, width = 432px, status = no, toolbar=no, menubar=no,location=no, resizable=0" + feature);
			}
			
			var task_repetition_del_cross_dialogArguments = new Array();
			var deltaskid = "";
			function delete_task() {
				if (!confirm("<spring:message code='ezTask.t106' />")) {
					return;
				}
	
				var id = taskid;
				if (parentid != "0") {
					id = parentid;
				}
	
				deltaskid = id;
				
				/* 반복설정 이효진 */
				/* if (repeatcount != "0") {
					var rgParams = new Array();
					rgParams["CancelOpen"] = false;
					rgParams["InstanceType"] = "";
					
					task_repetition_del_cross_dialogArguments[0] = rgParams;
					task_repetition_del_cross_dialogArguments[1] = DeleteTask_Complete;
					
					DivPopUpShow(390, 235, "/myoffice/ezTask/htm/task_repetition_del_Cross.aspx");
					
					return;
				} */
	
// 				var xmlDom = createXmlDom();
// 				var xmlHTTP = createXMLHttpRequest();
// 				var objRoot;
	
// 				objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
// 				createNodeAndInsertText(xmlDom, objRoot, "DATA", deltaskid);
				
// 				xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_delete.aspx", false);
// 				xmlHTTP.send(xmlDom);
	
// 				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
// 					alert("<spring:message code='ezTask.t108' />");
// 				} else {
// 					try {
// 						window.opener.RefreshView()
// 					} catch (e) { }
					
// 					window.close();
// 				}

				$.ajax({
					type : "POST",
					url : "/ezTask/taskDelete.do",
					dataType : "json",
					data : {
						taskID : deltaskid
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
			
			/* 반복설정 이효진 */
			/* function DeleteTask_Complete(rgParams) {
				if (rgParams["InstanceType"] == "Instance") {
					var xmlDom = createXmlDom();
					var xmlHTTP = createXMLHttpRequest();
					var objRoot;
					var objNode;
					
					objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
					objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKID", deltaskid)
					objNode = createNodeAndInsertText(xmlDom, objNode, "REPEATCOUNT", repeatcount);
					
					xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_del_repeat_instance.aspx", false);
					xmlHTTP.send(xmlDom);
					
					if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
						alert("<spring:message code='ezTask.t107' />");
					} else {
						try {
							window.opener.RefreshView()
						} catch (e) { }
						
						window.close();
					}
	
					return;
				}
	
				var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				var objRoot;
	
				objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
				createNodeAndInsertText(xmlDom, objRoot, "DATA", deltaskid);
				
				xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_delete.aspx", false);
				xmlHTTP.send(xmlDom);
	
				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
					alert("<spring:message code='ezTask.t108' />");
				} else {
					try {
						window.opener.RefreshView()
					} catch (e) { }
					
					window.close();
				}
			} */
			
			/* 업무수정 */
			function edit_task() {
			    var id = taskid;
			    if (parentid != "0")
			        id = parentid;
			    var win;
			    
				/* 레이어팝업으로 taskWriteCross 호출 */
				/* 수현이 소스랑 겹쳐서 걍 새로짬 */
				var feature = GetOpenPosition(760, 750);
				DivPopUpShow($('body').prop('scrollWidth') * 0.9, $('body').prop('scrollHeight') * 0.92, "/ezTask/taskWrite2.do?taskID=" + id, "",
		                "height = 750px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
				
			    /* if (CrossYN()) {
			        var feature = GetOpenPosition(760, 750);
			        win = window.open("/ezTask/taskWrite2.do?taskID=" + id, "",
			                "height = 750px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			    } else {
			        if (pUse_Editor == "" || pUse_Editor == "CK") {
			            var feature = GetOpenPosition(760, 660);
			            win = window.open("/myoffice/ezTask/task_write.aspx?id=" + id, "",
			                "height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			        } else {
			            var feature = GetOpenPosition(760, 660);
			            win = window.open("/myoffice/ezTask/task_write_IE.aspx?id=" + id, "",
			               "height = 660px, width = 760px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
			        }
			    }
				
			    win.opener = window.opener;
			    window.close(); */
			}
			
			/* 의견삭제 */
			function delete_comment(commentorid, commentid) {
			    if (commentorid != userid) {
			        alert("<spring:message code='ezTask.t146' />");
				    return;
				}
			
				if (!confirm("<spring:message code='ezTask.t147' />"))
				    return;
				
				var id = taskid;
				if (parentid != "0")
				    id = parentid;
				
				/* var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				var objRoot;
				var objNode;
				
				objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
				objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKID", id);
				objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "COMMENTID", commentid);
				
				xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_del_memo.aspx", false);
				xmlHTTP.send(xmlDom);
				
				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
				    alert("<spring:message code='ezTask.t148' />");
				} else {
					window.location.href = "/ezTask/taskRead.do?taskID=" + taskid + "&repeatcount=" + repeatcount + "&date=" + date + "&type=2";
			        try { window.opener.location.reload(); } catch (e) { }
			    } */
			    
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
							taskCommentList += "<img src='/images/comment_delete.gif' title='asdf' onclick='delete_comment(" + deleteCommentParam + ")' style='cursor: pointer' width='11' height='11' />";
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
			
			function update_status() {
			    if (admin != "Y") {
			        alert("<spring:message code='ezTask.t149' />");
				    return;
				}
			
				var id = taskid;
				if (parentid != "0")
				    id = parentid;
				
				var xmlDom = createXmlDom();
				var xmlHTTP = createXMLHttpRequest();
				var objRoot;
				var objNode;
				
				objRoot = createNodeInsert(xmlDom, objRoot, "DATA");
				objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKID", id);
				objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "REPEATCOUNT", repeatcount);
				
				var tempcheckvalue = "";
				var taskcheckbox = document.getElementsByName("taskstatuscheckbox");
				for (var i = 0; i < taskcheckbox.length; i++) {
				    if (taskcheckbox[i].checked) {
				        tempcheckvalue = taskcheckbox[i].value;
				        break;
				    }
				}
			
				objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "TASKSTATUS", tempcheckvalue);
				
				taskcheckbox = document.getElementsByName("completeracheckbox");
				for (var i = 0; i < taskcheckbox.length; i++) {
				    if (taskcheckbox[i].checked) {
				        tempcheckvalue = taskcheckbox[i].value;
				        break;
				    }
				}
				
				objNode = createNodeAndAppandNodeText(xmlDom, objRoot, objNode, "COMPLETERATE", tempcheckvalue);
				
				xmlHTTP.open("POST", "/myoffice/ezTask/remote/task_update_instance.aspx", false);
				xmlHTTP.send(xmlDom);
				
				if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK")
				    alert("<spring:message code='ezTask.t102' />");
				else {
				    alert("<spring:message code='ezTask.t150' />");
					try { window.opener.RefreshView() } catch (e) { }
				}
			}
			
			/* 진행단계변경시 스크립트? 안쓰는거같음 이효진 */
			/* function status_change() {
			    var rate = document.getElementById("completerateSelect").value;
			    var status = document.getElementById("taskstatusSelect").value;
			
			    if (status == "3") {
			        document.getElementById("completerateSelect").value = "100";
			        return;
			    }
			
			    if (status == "1") {
			        document.getElementById("completerateSelect").value = "0";
			        return;
			    }
			
			    if (rate == "100") {
			        document.getElementById("completerateSelect").value = "10";
			        return;
			    }
			} */
			
			/* 완료율변경시 스크립트? 안쓰는거같음 이효진 */
			/* function rate_change() {
			    var rate = document.getElementById("completerateSelect").value;
			    var status = document.getElementById("taskstatusSelect").value;
			
			    if (rate == "100") {
			        document.getElementById("taskstatusSelect").value = "3";
			        return;
			    }
			
			    if (rate == "0") {
			        if (status == "3")
			            document.getElementById("taskstatusSelect").value = "1";
			        return;
			    }
			
			    if (status == "1" || status == "3")
			        document.getElementById("taskstatusSelect").value = "2";
			} */
			
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
			            break;
			        case "MailEnv_div2":
			            selecttab = "2";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "";
			            document.getElementById("tablecomment").style.display = "none";
			            try {
			                if (!CrossYN())
			                    document.getElementById("message2").style.height = (document.body.clientHeight - 220) + "px";
			            } catch (e) {}
			            break;
			        case "MailEnv_div3":
			            selecttab = "3";
			            document.getElementById("normalScreen").style.display = "none";
			            document.getElementById("tablework").style.display = "none";
			            document.getElementById("tablecomment").style.display = "";
			            break;
			    }
			}
			
			function comment_keydown() {
			    if (window.event.keyCode == "13")
			        add_comment();
			}
			
			function save_taskwrok() {
			    var xmlDom = createXmlDom();
			    var xmlHTTP = createXMLHttpRequest();
			
			    var objRoot, objNode, attachnode, shobjnode;
			    objNode = createNodeInsert(xmlDom, objNode, "DATA");
			    createNodeAndInsertText(xmlDom, objNode, "TASKID", taskid);
			
			    var taskcheckbox = document.getElementsByName("taskstatuscheckbox");
			    var taskvalue = "";
			    for (var i = 0; i < taskcheckbox.length; i++) {
			        if (taskcheckbox[i].checked == true) {
			            taskvalue = taskcheckbox[i].value;
			            break;
			        }
			    }
			
			    if (taskvalue == "3") {
			        if (message2.GetEditorContent() == tempbody) {
			            alert("<spring:message code='ezTask.t2014' />");
				        return;
				    }
				}
			
				createNodeAndInsertText(xmlDom, objNode, "TASKSTATUS", taskvalue);
				var taskcheckbox = document.getElementsByName("completeracheckbox");
				taskvalue = "";
				for (var i = 0; i < taskcheckbox.length; i++) {
				    if (taskcheckbox[i].checked == true) {
				        taskvalue = taskcheckbox[i].value;
				        break;
				    }
				}
				createNodeAndInsertText(xmlDom, objNode, "COMPLETERATE", taskvalue);
				
				var strBody = message2.GetEditorContent();
				
				var tempDiv = document.createElement("DIV");
				tempDiv.innerHTML = strBody;
				
				strBody = ConvertHTMLtoMHT(HTMLtoMHT_MakeTag(tempDiv));
				createNodeAndInsertText(xmlDom, objNode, "CONTENT", strBody);
				
				var list = createNodeAndAppandNode(xmlDom, objNode, list, "ATTACHLIST");
				if (pAttachListXml != "") {
				    var nodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");
				    for (var i = 0; i < nodes.length; i++) {
				        createNodeAndAppandNodeText(xmlDom, list, attachnode, "ATTACH", SelectSingleNodeValue(GetChildNodes(nodes[i])[0], "DATA2") + "/" + SelectSingleNodeValue(GetChildNodes(nodes[i])[0], "VALUE") + "/" + SelectSingleNodeValue(GetChildNodes(nodes[i])[0], "DATA6"));
				    }
				}
				
				if(content != "")
				    createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", content);
				else
				    createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", "");
				
				xmlHTTP.open("POST", "/myoffice/ezTask/remote/taskwrok_save.aspx", false);
				xmlHTTP.send(xmlDom);
				
				if (xmlHTTP.status == 200 || xmlHTTP.responseText == "OK") {
					alert("<spring:message code='ezTask.t2009' />");
					window.location.href = "/ezTask/taskRead.do?taskID=" + taskid + "&repeatcount=" + repeatcount + "&date=" + date + "&type=1";
				}
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
			
			function Editor_Complete() {
			    loadiframe();
			}
			
			function loadiframe() {
			    if (content != "") {
			        var fullPath = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(content);
			        message2.SetEditorContentURL(fullPath);
			    }
			    
			    try {
			        var objTags = document.getElementById('message2').getElementsByTagName("a");
			
			        for (var i = 0 ; i < objTags.length ; i++) {
			            if (objTags.item(i).href.indexOf("javascript:") == -1)
			                objTags.item(i).target = "_blink";
			        }
			    }
			    catch (e) { }
			}
			
			function attach_Add() {
			    document.form.file1.click();
			}
			
			function btn_AttachAdd_onclick() {
			    if (document.form.file1.value != "") {
			        var AttachLimit = 5;
			        document.getElementById("maxsize").value = parseInt(AttachLimit) * 1024 * 1024;
			        document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
			        var frm = document.getElementById('form');
			        frm.submit();
			    } else {
			        alert("<spring:message code='ezTask.t145' />");
			    }
			}
			
			function returnvalue(strXML) {
			    var ndx = strXML.indexOf("</ROOT>");
			    strXML = strXML.substr(0, ndx + 7);
			    pAttachXml = loadXMLString(strXML);
			    var nodes = SelectNodes(pAttachXml, "ROOT/NODES/NODE");
			    var extFlag = false;
			
			    for (i = 0; i < nodes.length; i++) {
			        if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
			            if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
			                alert(strLang51);
			                return;
			            }
			        } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
			            extFlag = true;
			        } else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
			            alert(strLang52 + AttachLimit + "MB" + strLang53);
			            return;
			        } else {
			            alert(strLang24);
			        }
			    }
			    
				if (extFlag) {
					alert(strLang58);
			    }
			
			    AttachFileInfo(strXML);
			}
		
			function beforeprint() {
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
			
			    /* setNodeText(document.getElementById("printCreator"), '${taskInfoVO.creatorName }');
			    setNodeText(document.getElementById("printCreateDate"), '${taskInfoVO.createDate }');
			    setNodeText(document.getElementById("printStatus"), status);
			    setNodeText(document.getElementById("printImportance"), '${taskInfoVO.importance }');
			    setNodeText(document.getElementById("printShare"), getNodeText(document.getElementById("LabelShare")));
			    setNodeText(document.getElementById("printDate"), '${taskInfoVO.completeDate }');
			    setNodeText(document.getElementById("printTitle"), '${taskInfoVO.title }'); */
			    $("#printComment").html($("#taskCommentList").html());
			    $("#printComment img").remove();
			    
			    document.getElementById("printAttach").innerHTML = document.getElementById("attachedfileDIV").innerHTML;
			    document.getElementById("printDocument").innerHTML = message.document.body.innerHTML;
			
			    /* if (tasktype == "1") {
			        document.getElementById("progresstr").style.display = "none";
			        document.getElementById("printProgress").style.display = "none";
			        document.getElementById("printattachViewProgress").style.display = "none";
			    } */
			
			    if (personid == userid && shareid.indexOf(userid) == -1) {
			        document.getElementById("printAttach2").innerHTML == "";
			        var table;
			        if (navigator.userAgent.indexOf('Firefox') > -1)
			            table = dadiframe.contentWindow.document.getElementById("filelist");
			        else
			            table = dadiframe.document.getElementById("filelist");
			
			        for (var i = 1; i < table.childNodes.length; i++) {
			            var checkbox = document.createElement("INPUT");
			            checkbox.type = "checkbox";
			            checkbox.style.verticalAlign = "middle";
			
			            var img = document.createElement("IMG");
			            img.style.verticalAlign = "middle";
			            img.src = "/images/email/mail_006.gif";
			
			            var a = document.createElement("A");
			            a.style.verticalAlign = "middle";
			            a.innerHTML = getNodeText(table.childNodes[i].childNodes[1]) + " ( " + getNodeText(table.childNodes[i].childNodes[2]) + ")";
			
			            document.getElementById("printAttach2").appendChild(checkbox);
			            document.getElementById("printAttach2").appendChild(img);
			            document.getElementById("printAttach2").appendChild(a);
			            if (i + 1 != table.childNodes.length) {
			                var br = document.createElement("BR");
			                document.getElementById("printAttach2").appendChild(br);
			            }
			        }
			        document.getElementById("printDocument2").innerHTML = message2.GetEditorContent();
			    }
			    else if (personid == userid && shareid.indexOf(userid) > -1) {
			        document.getElementById("printAttach2").innerHTML = document.getElementById("attachedfileDIV").innerHTML;
			        document.getElementById("printDocument2").innerHTML = message2.GetEditorContent();
			    }
			    else if (tasktype != "1") {
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
			    }
			    else {
			        document.getElementById("printCommentView").style.display = "none";
			        document.getElementById("optiontr").style.display = "none";
			    }
			
			    if (document.getElementById("attachedfileDIV").innerHTML.trim() != "")
			        printattachView.style.display = "";
			
			    if (tasktype != "1" && document.getElementById("printAttach2").innerHTML.trim() != "")
			        printattachViewProgress.style.display = "";
			
			    window.print();
			
			    document.getElementById("printScreen").style.display = "none";
			    document.getElementById("menu").style.display = "";
			    document.getElementById("close").style.display = "";
			    document.getElementById("tabpart").style.display = "";
			
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
		</script>
	</head>
	
	<body class="popup" style="overflow:hidden; height:99%">
		<div id="menu">
			<ul>
<%-- 				<li id="edit"><SPAN onClick="edit_task()"><spring:message code='ezTask.t151' /></SPAN></li> 지시사항 수정화면호출--%>
<%-- 				<li id="save"><SPAN onClick="save_taskwrok()"><spring:message code='ezTask.t96' /></SPAN></li> 진행사항 저장--%>
				<li id="delete"><SPAN onClick="delete_task()"><spring:message code='ezTask.t115' /></SPAN></li>
				<li id="share" style="display:none"><SPAN onClick="manage_share()"><spring:message code='ezTask.t152' /></SPAN></li>
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
		
		<table id="taskProgress" class="layout content">
			<tr>
				<td>
					progressBar
				</td>
			</tr>
		</table>
		<br/>
		 
		 <table id="taskInfo" class="layout">
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
							<td style="padding-right:15px;white-space:nowrap">${fn:substring(taskInfoVO.createDate, 0, 16) }</td>
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
<!-- 							담당자부분인것같음 이효진 -->
<!-- 								<div id="personlist" style="overflow-Y: auto; padding-top:2px"> -->
<!-- 								</div> -->
								<div style="CURSOR:pointer; " onClick="show_personinfo('${taskInfoVO.personID }')" onMouseOver="this.style.color='#006BB6'" onMouseOut="this.style.color='#393939'">
									<c:out value = '${taskInfoVO.personName }' />
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
									<c:out value = '${fn:substring(taskInfoVO.startDate, 0, 16) }' />
								</div>
							</td>
							<th><spring:message code='ezTask.t122' /></th>
							<td>
								<div>
									<c:out value = '${fn:substring(taskInfoVO.endDate, 0, 16) }' />
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
	
						<%-- <c:if test="${taskType == '1' }">
							<tr>
								<th><spring:message code='ezTask.t119' /></th>
								<td colspan="3">
									<div style="padding-top:4px">
										<input type ="radio" id="taskstatus" name ="taskstatuscheckbox" value="1" onclick ="changestatus(this)" style="margin-top:0px"/>
										<label for ="taskstatus"><spring:message code='ezTask.t97' /></label>
										<input type ="radio" id="taskstatus2" name ="taskstatuscheckbox" value="2" onclick ="changestatus(this)" style="margin-top:0px"/>
										<label for ="taskstatus2"><spring:message code='ezTask.t98' /></label>
										<input type ="radio" id="taskstatus3" name ="taskstatuscheckbox" value="3" onclick ="changestatus(this)" style="margin-top:0px"/>
										<label for ="taskstatus3"><spring:message code='ezTask.t99' /></label>
										<input type ="radio" id="taskstatus4" name ="taskstatuscheckbox" value="4" onclick ="changestatus(this)" style="margin-top:0px"/>
										<label for ="taskstatus4"><spring:message code='ezTask.t100' /></label>
									</div>
									<div>
										<input type ="radio" id="completera" name ="completeracheckbox" value="0" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera">0%</label>
										<input type ="radio" id="completera2" name ="completeracheckbox" value="10" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera2">10%</label>
										<input type ="radio" id="completera3" name ="completeracheckbox" value="20" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera3">20%</label>
										<input type ="radio" id="completera4" name ="completeracheckbox" value="30" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera4">30%</label>
										<input type ="radio" id="completera5" name ="completeracheckbox" value="40" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera5">40%</label>
										<input type ="radio" id="completera6" name ="completeracheckbox" value="50" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera6">50%</label>
										<input type ="radio" id="completera7" name ="completeracheckbox" value="60" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera7">60%</label>
										<input type ="radio" id="completera8" name ="completeracheckbox" value="70" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera8">70%</label>
										<input type ="radio" id="completera9" name ="completeracheckbox" value="80" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera9">80%</label>
										<input type ="radio" id="completera10" name ="completeracheckbox" value="90" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera10">90%</label>
										<input type ="radio" id="completera11" name ="completeracheckbox" value="100" onclick ="changecomplete(this)" style="margin-top:0px"/>
										<label for ="completera11">100%</label>
										<a class="imgbtn" style="vertical-align:middle"><span id ="statusbtn" onClick="update_status()"><spring:message code='ezTask.t96' /></span></a>
									</div>
								</td>
							</tr>
						</c:if> --%>
					</table>
				</td>
			</tr>
		</table>
		<br />
		<div id="tabpart" class="portlet_tabpart03">
			<div class="portlet_tabpart03_top" id="tab1">
				<p id = "MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezTask.t2010' /></span></p>
				<p id = "MailEnv_sub2"><span divname="MailEnv_div2" id="1tab2"><spring:message code='ezTask.t2011' /></span></p>
				<p id = "MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezTask.t2013' /></span></p>
				<!-- 이효진 저장버튼추가필요 -->
				
				<div id="close">
					<ul>
						<!-- 지시사항 수정화면호출 -->
						<li id="edit"><span onClick="edit_task()"><spring:message code='ezTask.t151' /></span></li>
						<!-- 진행사항 저장 -->
						<li id="save"><span onClick="save_taskwrok()"><spring:message code='ezTask.t96' /></span></li>
					</ul>
				</div>
			</div>
		</div> 
		
<%-- 		<%if(_type != "2"){ %> --%>
		<table id="normalScreen" class="layout" style="height:100%">
<%-- 		<%}else{ %> --%>
<!-- 		<table id="normalScreen" class="layout" style="height:560px;display:none;"> -->
<%-- 		<%}%> --%>
			<tr>
				<td style="padding-bottom:4px;height: 520px;">
					<iframe id="message" class="viewbox" name="message" style="padding:0; height:100%; width:99.8%; overflow:auto;"></iframe>
				</td>
			</tr>
			<tr>
				<td style="padding-top:4px;height:20px"  class="pad1">
					<table class="file">
						<tr>
							<th><spring:message code='ezTask.t160' /></th>
							<td class="pos1"><div id="attachedfileDIV" style="overflow:auto;height:50px;background-color:white;text-align:left"><asp:Literal ID="LiteralAttach" Runat="server"></asp:Literal></div></td>
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
	
		
		<table id="tablework" class="layout" style="height: 560px;display:none;" >
		<%-- <tr>
			<td style="height:20px">
				<table class="content">
					<c:if test="${taskType != '1' }">
						<tr>
							<th><spring:message code='ezTask.t119' /></th>
							<td style="height:30px">
								<div style="padding-top:4px">
									<input type ="radio" id="taskstatus" name ="taskstatuscheckbox" value="1" onclick ="changestatus(this)" style="margin-top:0px"/>
									<label for ="taskstatus" style="vertical-align:middle"><spring:message code='ezTask.t97' /></label>
									<input type ="radio" id="taskstatus2" name ="taskstatuscheckbox" value="2" onclick ="changestatus(this)"style="margin-top:0px"/>
									<label for ="taskstatus2" style="vertical-align:middle"><spring:message code='ezTask.t98' /></label>
									<input type ="radio" id="taskstatus3" name ="taskstatuscheckbox" value="3" onclick ="changestatus(this)"style="margin-top:0px"/>
									<label for ="taskstatus3" style="vertical-align:middle"><spring:message code='ezTask.t99' /></label>
									<input type ="radio" id="taskstatus4" name ="taskstatuscheckbox" value="4" onclick ="changestatus(this)"style="margin-top:0px"/>
									<label for ="taskstatus4" style="vertical-align:middle"><spring:message code='ezTask.t100' /></label>
								</div>
								<div style="padding-bottom:4px;padding-top:4px">
									<input type ="radio" id="completera" name ="completeracheckbox" value="0" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera" style="vertical-align:middle">0%</label>
									<input type ="radio" id="completera2" name ="completeracheckbox" value="10" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera2" style="vertical-align:middle">10%</label>
									<input type ="radio" id="completera3" name ="completeracheckbox" value="20" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera3" style="vertical-align:middle">20%</label>
									<input type ="radio" id="completera4" name ="completeracheckbox" value="30" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera4" style="vertical-align:middle">30%</label>
									<input type ="radio" id="completera5" name ="completeracheckbox" value="40" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera5" style="vertical-align:middle">40%</label>
									<input type ="radio" id="completera6" name ="completeracheckbox" value="50" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera6" style="vertical-align:middle">50%</label>
									<input type ="radio" id="completera7" name ="completeracheckbox" value="60" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera7" style="vertical-align:middle">60%</label>
									<input type ="radio" id="completera8" name ="completeracheckbox" value="70" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera8" style="vertical-align:middle">70%</label>
									<input type ="radio" id="completera9" name ="completeracheckbox" value="80" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera9" style="vertical-align:middle">80%</label>
									<input type ="radio" id="completera10" name ="completeracheckbox" value="90" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera10" style="vertical-align:middle">90%</label>
									<input type ="radio" id="completera11" name ="completeracheckbox" value="100" onclick ="changecomplete(this)"style="margin-top:0px"/>
									<label for ="completera11" style="vertical-align:middle">100%</label>
								</div>
							</td>
						</tr>
					</c:if>
				</table>
			</td>
		</tr> --%>
		
<%-- 		<c:choose> --%>
			<%-- <c:when test="${userInfo.id == personID }"> 이부분이 레이어팝업으로 들어가야함
				<tr>
					<td style="height:100%">            
						<iframe id="message2" class="viewbox" src="/myoffice/ezEditor/Select_Editor.aspx?type=TASK" name="message2" style="padding:0; height:100%; width:100%; overflow:auto;" onload ="loadiframe()"></iframe>            
					</td>
				</tr>
				<tr>
					<td>
						<br />
						<iframe id="dadiframe" name="dadiframe" style="width:100%;height:100%;border:0px" src="/myoffice/ezTask/DragandDropiframe.aspx"></iframe>
					</td>
				</tr>
			</c:when> --%>
<%-- 			<c:otherwise> --%>
				<tr style="vertical-align:top">
					<td colspan="3" style="padding-bottom:4px; height:520px;">
						<iframe id="message2" class="viewbox" name="message2" style="padding:0; height:100%; width:99.8%; overflow:auto;"></iframe>
					</td>
				</tr>
				<tr style="vertical-align:top">
					<td style="padding-top:4px" colspan="3">
						<table class="file">
							<tr>
								<th><spring:message code='ezTask.t160' /></th>
								<td class="pos1">
									<div id="attachedfileDIV2" style="overflow: auto;height: 50px;background-color:white;text-align:left">
										<asp:Literal ID="Literal1" Runat="server"></asp:Literal>
									</div>
								</td>
								<td class="pos2"><a class="imgbtn">
									<span  onClick="attach_SelectAll('2')" style="width: 50px;"><spring:message code='ezTask.t161' /></span></a><br>
									<a class="imgbtn"><span onClick="attach_Download('2')" style="width: 50px;"><spring:message code='ezTask.t96' /></span></a>
								</td>
							</tr>
						</table>
					</td>
				</tr>
<%-- 			</c:otherwise> --%>
<%-- 		</c:choose> --%>
		
		</table>
		
		<table id="tablecomment" class="layout" style="display:none;height:580px">
			<tr>
				<td style="height:20px" colspan="3">
					<table class ="content" style="width:100%">
						<tr>
							<td style="vertical-align:top">
								<div id="taskCommentList" style="overflow: auto; width:100%; height: 540px; background-color: white; padding-top:3px;">
									<c:forEach var="taskCommentVO" varStatus="status" items="${taskCommentList}">
										<span style="cursor:pointer;color: #2828A5;" onclick="show_personinfo('${taskCommentVO.commentorID }')" ><c:out value = '${taskCommentVO.commentorName }' /></span>
										<span style="color: #2828A5;">(<c:out value = '${fn:substring(taskCommentVO.commentDate, 0, 16) }' />) : </span>
										<span><c:out value='${taskCommentVO.comment}'/><img src="/images/comment_delete.gif" title="<spring:message code='ezTask.t159' />" onclick="delete_comment('${taskCommentVO.commentorID }', '${taskCommentVO.commentID }')" style="cursor: pointer" width="11" height="11" /></span>
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
		<div id="printScreen" style="display: none; padding-top:50px;">
			<table class="layout" >
				<%-- <tr>
					<td style="height:20px">
						<table class="content">
							<tr>
								<th><spring:message code='ezTask.t162' /></th>
								<td style="width:330px;white-space:nowrap"><div id="printCreator"></div></td>
								<th><spring:message code='ezTask.t163' /></th>
								<td style="width:150px;white-space:nowrap;padding-right:15px"><div id="printCreateDate"></div></td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t164' /></th>
								<td><div id="printStatus"></div></td>
								<th><spring:message code='ezTask.t165' /></th>
								<td ><div id="printImportance"></div></td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t166' /></th>
								<td colspan="3" style="width:100%"><div id="printShare"></div></td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t167' /></th>
								<td colspan="3"><div id="printDate"></div></td>
							</tr>
							<tr>
								<th><spring:message code='ezTask.t168' /></th>
						    <td colspan="3"><div id="printTitle"></div></td>
							</tr>
						</table>
					</td>
				</tr> --%>
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
				<tr id ="progresstr" style="height:20px">
					<td><spring:message code='ezTask.t2011' /></td>
				</tr>
				<tr id ="printProgress">
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

		<iframe name="ifrm" src="about:blank" style="display:none"></iframe>

		<form method="post" id="form" name="form" enctype="multipart/form-data" action="/myoffice/ezTask/interASP/upload.aspx" target="ifrm" style="visibility:hidden;" >
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width:1px; height:1px;"/>
			<input type="hidden" name="maxsize" id="maxsize" />
			<input type="hidden" name="cnt" id="cnt" />
		</form>

		<form method="post" id="nameValue" name="nameValue" enctype="multipart/form-data" action="#" target="child" style="display:none;" >
			<input type="hidden" name="addrBook" id="addrBook" />
			<input type="hidden" name="name" id="name" />
			<input type="hidden" name="id" id="id" />
			<input type="hidden" name="deptname" id="deptname" />
			<input type="hidden" name="name1" id="name1" />
			<input type="hidden" name="name2" id="name2" />
			<input type="hidden" name="deptname2" id="deptname2" />
			<input type="hidden" name="recipientTDData" id="recipientTDData" value="" />
			<input type="hidden" name="email" id="email" value="" />
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>
			
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
	
	<script type="text/javascript">
    	Tab1_NewTabIni("tab1");
	</script>
</html>