<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<HEAD>
		<title><spring:message code='ezTask.t206' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezTask.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/task_write_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachItem_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
		<script>
			var userid = "<c:out value='${userInfo.id }'/>";
			var username = "<c:out value='${userInfo.displayName1 }'/>";
			var username2 = "<c:out value='${userInfo.displayName2 }'/>";
			var deptname = "<c:out value='${userInfo.deptName1 }'/>";
			var deptname2 = "<c:out value='${userInfo.deptName2 }'/>";
			var useremail = "<c:out value='${userInfo.email }'/>";
			var taskid = "<c:out value='${taskInfoVO.taskID }'/>";
			var taskstatus = "<c:out value='${taskInfoVO.taskStatus }'/>";
			var completerate = "<c:out value='${taskInfoVO.completeRate }'/>";
			var startdate = "<c:out value='${taskInfoVO.startDate }'/>";
			var enddate = "<c:out value='${taskInfoVO.endDate }'/>";
			var importance = "<c:out value='${taskInfoVO.importance }'/>";
			var tasktype = "<c:out value='${taskInfoVO.taskType }'/>";
			var creatorid = "<c:out value='${taskInfoVO.creatorID }'/>";
			var hasattach = "<c:out value='${taskInfoVO.hasAttach }'/>";
			var hasshare = "<c:out value='${taskInfoVO.hasShare}'/>";
			var contentPath = "<c:out value='${taskInfoVO.contentPath}'/>";
			var sharelist = "";
			var g_person = null;
			var g_share = null;
			var sharelist = "${taskShareList }";
			var shareliststr = "${taskShareListStr }";
			var shareid = "";
			var sharename = "";
			var sharename2 = "";
			var sharedept = "";
			var sharedept2 = "";
			var sharemail = "";
// 			var FormProcSpelling = "FormProcSpelling";
			var personid = "<c:out value='${taskInfoVO.personID }'/>";
			var personname = "<c:out value='${taskInfoVO.personName }'/>";
			var personname2 = "<c:out value='${taskInfoVO.personName2 }'/>";
			var persondept = "<c:out value='${taskInfoVO.personDeptName }'/>";
			var persondept2 = "<c:out value='${taskInfoVO.personDeptName2 }'/>";
			var personemail = "<c:out value='${taskInfoVO.personEmail }'/>";
			var useTodoMemo = "<c:out value='${useTodoMemo }'/>";
			var primary = "<c:out value='${userInfo.primary}'/>";
			var defaultFont = "<spring:message code='main.t246' />";
			var defaultFontAndSize = "style='font-size:13px;font-family:" + defaultFont + "'";
			var repetition = "<c:out value = '${taskInfoVO.repetition}' />";		
			var repetitiondel = "";
			var mode = "<c:out value = '${mode}' />";	
			/*2018-05-23 구해안 버그 수정을 위해 boolean 변수 2개 추가*/
			var timeCheck = false;
			var radioCheck = false;
			var flag = "<c:out value='${flag}'/>";
			var printTitle = "<spring:message code='ezApprovalG.pjj03'/>";
			var cssLang = "<spring:message code='main.default.css'/>";
			
			$(function () {
				 $("#Sdatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true,
					beforeShow: function (input) {
						var i_offset = $(input).offset();
						setTimeout(function () {
							//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
						})
					}
				});
	
				$("#Edatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true,
					beforeShow: function (input) {
						var i_offset = $(input).offset();
						setTimeout(function () {
							//$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
		     			})
		 			}
				});

				if (startdate == "") {
					startdate = "<c:out value='${startDate}'/>";
					enddate = "<c:out value='${endDate}'/>";
				}

				// IE계열 브라우저에서 메모가 100자 넘어가면 마우스 커서 default->text
				var agent = navigator.userAgent.toLowerCase(); 
				if (!CrossYN() || agent.search( "trident" ) > -1 ) {
					var cursorIe = document.getElementById("TextMemo");
					cursorIe.style.cursor = "text";			
				}
	
				// IE에서  new Date 값이 Invalid Date 나와서 수정
				var startYear = "";
				var startTime = "";
				var endYear = "";
				var endTime = "";
				if (startdate.indexOf(" ") != -1) {
					startYear = startdate.split(" ")[0];
					startTime = startdate.split(" ")[1];
					startdate = startYear + "T" + startTime;

					endYear = enddate.split(" ")[0];
					endTime = enddate.split(" ")[1];
					enddate = endYear + "T" + endTime;
				}

				var SDate = new Date(startdate);
				var EDate = new Date(enddate);

				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', SDate);
				
				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', EDate);
				
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

			$(window).load(function() {												
				if (taskid != "") {
					document.getElementById("importantSelect").value = importance;
					
					if (hasattach == "Y") {
			            setAttachFileInfo("${taskAttachList}");
			        }
					
					if (repetition) {
						show_repetition_info();
					}
					
					//baonk added
					var radioTasks = document.getElementsByName("tasktypesel");
					if (tasktype == "1" || tasktype == "4") {
						if (mode != "2") {
							document.getElementById("P").click();
						}
						
						for (var i = 0; i < radioTasks.length; i++) {
							if (radioTasks[i].getAttribute("id") != "P") {
								radioTasks[i].disabled = true;						
							}
						}
					}
					else {
						for (var i = 0; i < radioTasks.length; i++) {
							if (radioTasks[i].getAttribute("id") == "P") {
								radioTasks[i].disabled = true;
								break;
							}
						}
						if (mode != "2") {
							if (tasktype == "2" || tasktype == "5") {
								document.getElementById("I").click();
							}
							else {
								document.getElementById("C").click();
							}
						}
					}					
					
					//end
				}
	
				// 부서 특수문자가 c:out으로 한번 파싱되었으므로, 표출 시에는 다시 특수문자를 변환함
				if (personid != "" && personid != creatorid) {
					document.getElementById("personlist").innerHTML = personname + " (" + persondept + ")";

					g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

					g_person["name"][0] = personname;
					g_person["name1"][0] = personname;
					g_person["name2"][0] = personname2;
					g_person["id"][0] = personid;
					g_person["deptname"][0] = ConvMakeXMLString(persondept);
					g_person["deptname2"][0] = ConvMakeXMLString(persondept2);
					g_person["email"][0] = personemail;
				}

	            if (shareliststr != "") {
					sharename = shareliststr.split("||")[0];
					sharename1 = shareliststr.split("||")[1];
					sharename2 = shareliststr.split("||")[2];
					shareid = shareliststr.split("||")[3];
					sharedept = shareliststr.split("||")[4];
					sharedept2 = shareliststr.split("||")[5];
					sharemail = shareliststr.split("||")[6];
					
					g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
					
					shareid = shareid.split(";");
					sharename = sharename.split(";");
					sharename2 = sharename2.split(";");
					sharedept = sharedept.split(";");
					sharedept2 = sharedept2.split(";");
					sharemail = sharemail.split(";");
					
					for (var i = 0; i < shareid.length - 1; i++) {
						g_share["name"][i] = sharename[i];
						g_share["name1"][i] = sharename1[i];
						g_share["name2"][i] = sharename2[i];
						g_share["id"][i] = shareid[i];
						g_share["deptname"][i] = sharedept[i];
						g_share["deptname2"][i] = sharedept2[i];
						g_share["email"][i] = sharemail[i];
					}
				}
	            
				if (document.getElementById("TextTitle").value == "") {
					document.getElementById("TextTitle").focus();
				}	
				
			})
			window.onresize = function () {
				tasktype = $(":input:radio[name=tasktypesel]:checked").val();
				
				if (useTodoMemo == 'YES') {													
					if (tasktype == "1") {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					} else if (tasktype == "2") {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					} else if (tasktype == "3") {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					} else {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					}
				} else {
					if (tasktype == "1") {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX";
					} else if (tasktype == "2") {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX";
					} else if (tasktype == "3") {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX";
					} else {
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX";
					}
				}
				
				mobileDistinction();
			}
      
			function attach_Add() {
			    document.form.file1.click();
			}
			
			var AttachLimit = 1024;
			function btn_AttachAdd_onclick() {
			    if (document.form.file1.value != "") {
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
          
			function Editor_Complete() {
			    if (taskid != "") {
			        $.ajax({
				        type : "POST",
				        dataType : "text",
				        url : "/ezCommon/mhtToHTMLContent.do",
				        data : {
				              type : "TASKCONTENT",
				              itemID : contentPath
				        },
				        success: function(result){
							message.SetEditorContent(result);
				        }
			        });
			        
			        try {
			            var objTags = document.getElementById('message').getElementsByTagName("a");
			
			            for (var i = 0 ; i < objTags.length ; i++) {
			                if (objTags.item(i).href.indexOf("javascript:") == -1)
			                    objTags.item(i).target = "_blink";
			            }
			        }
			        catch (e) { }
			    } else {
			    	message.SetEditorContent("");
			    }
			}

			function changemenu(obj) {				
				if (useTodoMemo == 'YES') {
					if (obj.id == "P") {
						taskType = obj.value;
						document.getElementById("personinputtr").style.display = "none";
						document.getElementById("trrepeatinfo").style.display = "";
						
						if(repetition != null && repetition != "") {
							document.getElementById("periodblock").style.display = "none";
						}
						else {
							document.getElementById("periodblock").style.display = "";
						}
						
						if (mode == "") {
							$("#editorTitle").html("<spring:message code='ezTask.t2011' />");
						}
						
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					} else if (obj.id == "I") {
						taskType = obj.value;
						document.getElementById("personinputtr").style.display = "";
						
						if(repetition != null && repetition != "") {
							document.getElementById("periodblock").style.display = "none";
						}
						else {
							document.getElementById("periodblock").style.display = "";
						}
						
						if (mode == "") {
							$("#editorTitle").html("<spring:message code='ezTask.t2010' />");
						}
						
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 440 + "PX";
					} else if (obj.id == "C") {
						taskType = obj.value;
						document.getElementById("personinputtr").style.display = "";
						 
						if(repetition != null && repetition != "") {
							document.getElementById("periodblock").style.display = "none";
						}
						else {
							document.getElementById("periodblock").style.display = "";
						}
						
						if (mode == "") {
							$("#editorTitle").html("<spring:message code='ezTask.t2010' />");
						}
						
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 440 + "PX";
					}
				} else {				
					if (obj.id == "P") {
						taskType = obj.value;
						document.getElementById("personinputtr").style.display = "none";
						document.getElementById("trrepeatinfo").style.display = "";
						
						if(repetition != null && repetition != "") {
							document.getElementById("periodblock").style.display = "none";
						}
						else {
							document.getElementById("periodblock").style.display = "";
						}
						
						if (mode == "") {
							$("#editorTitle").html("<spring:message code='ezTask.t2011' />");
						}
						
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX";
					} else if (obj.id == "I") {
						taskType = obj.value;
						document.getElementById("personinputtr").style.display = "";
						
						if(repetition != null && repetition != "") {
							document.getElementById("periodblock").style.display = "none";
						}
						else {
							document.getElementById("periodblock").style.display = "";
						}
						
						if (mode == "") {
							$("#editorTitle").html("<spring:message code='ezTask.t2010' />");
						}
						
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					} else if (obj.id == "C") {
						taskType = obj.value;
						document.getElementById("personinputtr").style.display = "";
						
						if(repetition != null && repetition != "") {
							document.getElementById("periodblock").style.display = "none";
						}
						else {
							document.getElementById("periodblock").style.display = "";
						}
						
						if (mode == "") {
							$("#editorTitle").html("<spring:message code='ezTask.t2010' />");
						}
						
						document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX";
					}
				}
				
				
			}

			function beforeprint() {
				/* $(".popup").css('background-image', 'none');
	
				document.getElementById("main_body").style.display = "none";
				document.getElementById("printScreen").style.display = "";  */
				
				setNodeText(document.getElementById("printPerson"), getNodeText(document.getElementById("personlist")));
				setNodeText(document.getElementById("printShare"), getNodeText(document.getElementById("sharelist")));
				
				var tasktype = document.getElementsByName("tasktypesel");
				var tasktypename;
	
				for (var i = 0; i < tasktype.length; i++) {
					if (tasktype[i].checked) {
						tasktypename = tasktype[i].value;
						break;
					}
				}
				
				switch (tasktypename) {
					case "1":
						tasktypename = "<spring:message code = 'ezTask.t2000' />";
						break;
					case "2":
						tasktypename = "<spring:message code = 'ezTask.t2001' />";
						break;
					case "3":
						tasktypename = "<spring:message code = 'ezTask.t2002' />";
						break;
				}
				
				setNodeText(document.getElementById("printTasktype"), tasktypename);
				
				var important = document.getElementsByName("important");
				var importantname;
				
				for (var i = 0; i < important.length; i++) {
					if (important[i].checked) {
						importantname = important[i].value;
						break;
					}
				}
					
				switch (importantname) {
					case "1":
						importantname = "<spring:message code = 'ezTask.t171' />";
						break;
					case "2":
						importantname = "<spring:message code = 'ezTask.t172' />";
						break;
					case "3":
						importantname = "<spring:message code = 'ezTask.t173' />";
						break;
				}
	
				setNodeText(document.getElementById("printImportance"), importantname);
				
				var printdate;
				
				if (document.getElementById("periodblock").style.display == "")
					printdate = $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " (<spring:message code = 'ezTask.t207' />)";
				else
					printdate = getNodeText(document.getElementById("repeatblock"));
				
				setNodeText(document.getElementById("printDate"), printdate);
				setNodeText(document.getElementById("printTitle"), document.getElementById("TextTitle").value);
				
				var filehtml = "";
				var nodes;
				nodes = dadiframe.filelist.childNodes;
				for (i = 1; i < nodes.length; i++) {
					var fileName = getNodeText(nodes[i].childNodes[1]);
					var strFileExt = fileName.substr(fileName.lastIndexOf('.')).toLowerCase();
			        if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
			            strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
			            strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
			            strFileExt == ".xlsx" || strFileExt == ".rtf") {
			        }
					
			        var fileImage = "";
		            if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1) {
		                fileImage = "/images/image.png";
		            } else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1) {
		                fileImage = "/images/doc.png";
		            } else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1) {
		                fileImage = "/images/xls.png";
		            } else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1) {
		                fileImage = "/images/ppt.png";
		            } else if (strFileExt.indexOf(".txt") != -1) {
		                fileImage = "/images/txt.png";
		            } else if (strFileExt.indexOf(".zip") != -1) {
		                fileImage = "/images/zip.png";
		            } else if (strFileExt.indexOf(".pdf") != -1) {
		                fileImage = "/images/pdf.png";
		            } else if (strFileExt.indexOf(".ecm") != -1) {
		                fileImage = "/images/ecm.png";
		            } else {
		                fileImage = "/images/email/mail_006.gif";
		            }
		            
					filehtml = filehtml + "<span><img src='" + fileImage + "'> " + getNodeText(nodes[i].childNodes[1]) + "&nbsp;&nbsp;<br></span>";
				}
				
				document.getElementById("printAttach").innerHTML = filehtml;
				document.getElementById("printDocument").innerHTML = message.GetEditorContent();
				
				//window.print();
				
				var feature = GetOpenPosition(700, 700);
				printWindow = window.open("", "mywindow", "width=700, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
		        var strContent = "<html><head>"; // If you use this script inside <head> on the page, there might be error. So I am keeping inside body (becaue of <head>)        
		        strContent = strContent + "<title>" + printTitle + "</title>";      
		        strContent = strContent + "<link rel='stylesheet' href='/css/default.css' type='text/css' />";       
		        strContent = strContent + "<link rel='stylesheet' href='" + cssLang + "' type='text/css' />";       
		        strContent = strContent + "</head><body style='padding:10px;' onload='window.print();'>";   
		        strContent = strContent + "<div id='printScreen' style>";
		        strContent = strContent + document.getElementById("printScreen").innerHTML ;
		        strContent = strContent + "</div></body>"; 
		        printWindow.document.write(strContent);        
		        printWindow.document.close();        
		        printWindow.focus();  
				
				/* $(".popup").css("background-image", "url('/images/kr/cm/popup_bg.gif')");
				
				document.getElementById("main_body").style.display = "";
				document.getElementById("printScreen").style.display = "none"; */
			}
          
			function textLimit(obj, event, limit) {
				if (navigator.userAgent.indexOf('Firefox') != -1) {
					if (!event) event = window.event;
				}
					
				if (event.keyCode == 8 || event.keyCode == 46) {
					return true;
				}

				var textValue = new String(obj.value)
				var retText = "";
				var tcount = 0;
				for (k = 0; k < textValue.length; k++) {
					var onechar = textValue.charAt(k);
					tcount += escape(onechar).length > 4 ? 2 : 1
					retText += onechar;
					if (tcount >= limit) {
						obj.value = retText;
						return false;
					}
				}
			}

	        function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
	        
		    /* 2021-09-03 홍승비 - 부서명 특문처리 추가 */
		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&#039;", "'");
		        str = ReplaceText(str, "&#034;", "\"");
		  		str = ReplaceText(str, "&#92;", "\\");
		  	    str = ReplaceText(str, "&amp;", "&");
		        return str;
		    }
		    
			function mobileDistinction() {
   				var  userAgent = navigator.userAgent.toLowerCase();
				
				if (/iphone|ipod|ipad|android.*mobile/i.test(userAgent) || /tablet|ipad|android/i.test(userAgent) || navigator.maxTouchPoints > 4) {
					if (window.innerWidth > window.innerHeight) {
						document.getElementById("EdtorSize").style.height = 436 + "PX";
					}
				}
			}
		</script>
	</head>
	<body class="popup" style="overflow: hidden;">
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>   
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div id="main_body">
			<table id="normalScreen" class="layout">
				<tr>
					<td height="20" id="menuTable">
						<c:choose>
							<c:when test="${mode == ''}">
								<div class="new_popup_title_txt" id="taskChangeMode" style="display: none;"></div>
								<div id="menu">
									<ul>
				                        <c:choose>
				                           <c:when test="${taskID == ''}">				                              
				                              <li style="display:none"><span onClick="check_name()"><spring:message code='ezTask.t11' /></span></li>
											  <li><span onClick="save_task()"><spring:message code='ezTask.t96' /></span></li>
				                              <li><span class="icon16 popup_icon16_print" onClick="beforeprint()"></span></li>
				                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
				                           </c:when>
				                           <c:otherwise>				                              
				                              <%-- <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li> --%>
				                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
				                           </c:otherwise>
				                        </c:choose>
		                        
										<li class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
											<select id="importantSelect" name="importantSelect" style="vertical-align:top;">
												<option value='1'><spring:message code='ezTask.t171' /></option>
												<option value='2' selected><spring:message code='ezTask.t172' /></option>
												<option value='3'><spring:message code='ezTask.t173' /></option>
											</select>
										</li>
									</ul>
								</div>
								<div id="close">
									<ul>
										<li><span onClick="close_onclick()"></span></li>
									</ul>
								</div>
							</c:when>
														
							<c:otherwise> 
								<c:choose>
									<c:when test="${mode == '1'}">								
										<div class="new_popup_title_txt" id="taskChangeMode"><spring:message code='ezTask.t1512' /></div>
										<div id="menu" style="float: right; padding-right: 42px;">
											<ul>
						                        <c:choose>
						                           <c:when test="${taskID == ''}">						                              
						                              <li style="display:none"><span onClick="check_name()"><spring:message code='ezTask.t11' /></span></li>
						                              <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li>
						                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
						                           </c:when>
						                           <c:otherwise>
						                              <%-- <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li> --%>
						                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
						                           </c:otherwise>
						                        </c:choose>
				                        
												<li class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
													<select id="importantSelect" name="importantSelect" style="vertical-align:top;">
														<option value='1'><spring:message code='ezTask.t171' /></option>
														<option value='2' selected><spring:message code='ezTask.t172' /></option>
														<option value='3'><spring:message code='ezTask.t173' /></option>
													</select>
												</li>
											</ul>
										</div>
										<div id="close">
											<ul>
												<li><span onClick="close_onclick()"></span></li>
											</ul>
										</div>
										<div class="btnposition btnpositionNew">
										    <a class="imgbtn" onClick="save_task()" ><span><spring:message code='ezTask.t96' /></span></a>
										</div>
									 </c:when>
									 
									 <c:otherwise>
										<c:choose>
											<c:when test="${taskInfoVO.taskType == '1' || taskInfoVO.taskType == '4'}">
												<div class="new_popup_title_txt" id="taskChangeMode"><spring:message code='ezTask.t1511' /></div>
											</c:when>
											<c:otherwise>
												<div class="new_popup_title_txt" id="taskChangeMode"><spring:message code='ezTask.t1513' /></div>
											</c:otherwise>
										</c:choose>
									 	
										<div id="menu" style="float: right; padding-right: 42px;">
											<ul>
						                        <c:choose>
						                           <c:when test="${taskID == ''}">
						                              <li style="display:none"><span onClick="check_name()"><spring:message code='ezTask.t11' /></span></li>
						                              <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li>
						                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
						                           </c:when>
						                           <c:otherwise>
						                              <%-- <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li> --%>
						                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
						                           </c:otherwise>
						                        </c:choose>
				                        
												<li class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
													<select id="importantSelect" name="importantSelect" style="vertical-align:top;">
														<option value='1'><spring:message code='ezTask.t171' /></option>
														<option value='2' selected><spring:message code='ezTask.t172' /></option>
														<option value='3'><spring:message code='ezTask.t173' /></option>
													</select>
												</li>												
											</ul>
										</div>
										<div id="close">
											<ul>
												<li><span onClick="close_onclick()"></span></li>
											</ul>
										</div>
										<div class="btnposition btnpositionNew">
										    <a class="imgbtn" onClick="save_task()" ><span><spring:message code='ezTask.t96' /></span></a>
										</div>
									  </c:otherwise>
								 </c:choose>								
							</c:otherwise>
						</c:choose>					
						
						<script type="text/javascript">
							selToggleList(document.getElementById("menu"), "ul", "li", "0");
						</script>
					</td>
				</tr>
				
				<c:choose>
					<c:when test="${mode == '' || mode == '1'}">
					<tr>					
						<td height="20" id="menuTaskInf">
							<table class="content" id="tableInformation">
								<tr>
									<th><spring:message code='ezTask.t118' /></th>
									<td colspan="3"><input type="text" id="TextTitle" style="width:100%;" value = "<c:out value='${taskInfoVO.title}'/>"></td>
								</tr>
								<tr>
									<th><spring:message code='ezTask.t2003' /></th>
									<td style="width:300px">
										<c:choose>
											<c:when test="${taskInfoVO.taskType == '2' || taskInfoVO.taskType == '5'}">
												<div class="custom_radio"><input type ="radio" id="P" name="tasktypesel" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="P"><spring:message code='ezTask.t2000' /></label>
												<div class="custom_radio"><input type ="radio" id="I" name="tasktypesel" value ="2" checked="checked" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="I"><spring:message code='ezTask.t2001' /></label>
												<div class="custom_radio"><input type ="radio" id="C" name="tasktypesel" value ="3" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="C"><spring:message code='ezTask.t2002' /></label>
											</c:when>
											<c:when test="${taskInfoVO.taskType == '3' || taskInfoVO.taskType == '6'}">
												<div class="custom_radio"><input type ="radio" id="P" name="tasktypesel" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="P"><spring:message code='ezTask.t2000' /></label>
												<div class="custom_radio"><input type ="radio" id="I" name="tasktypesel" value ="2" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="I"><spring:message code='ezTask.t2001' /></label>
												<div class="custom_radio"><input type ="radio" id="C" name="tasktypesel" value ="3" checked="checked" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="C"><spring:message code='ezTask.t2002' /></label>
											</c:when>
											<c:otherwise>
												<div class="custom_radio"><input type ="radio" id="P" name="tasktypesel" checked="checked" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="P"><spring:message code='ezTask.t2000' /></label>
												<div class="custom_radio"><input type ="radio" id="I" name="tasktypesel" value ="2" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="I"><spring:message code='ezTask.t2001' /></label>
												<div class="custom_radio"><input type ="radio" id="C" name="tasktypesel" value ="3" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
												<label for ="C"><spring:message code='ezTask.t2002' /></label>
											</c:otherwise>
										</c:choose>
									</td>
									<th><spring:message code='ezTask.t2004' /></th>
									<td style="width:300px">
										<c:choose>
											<c:when test="${taskInfoVO.importance == '1' }">
												<div class="custom_radio"><input type ="radio" id="important1" name="important" value ="1" checked="checked" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important1"><spring:message code='ezTask.t171' /></label>
												<div class="custom_radio"><input type ="radio" id="important2" name="important" value ="2" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important2"><spring:message code='ezTask.t172' /></label>
												<div class="custom_radio"><input type ="radio" id="important3" name="important" value ="3" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important3"><spring:message code='ezTask.t173' /></label>
											</c:when>
											<c:when test="${taskInfoVO.importance == '3' }">
												<div class="custom_radio"><input type ="radio" id="important1" name="important" value ="1" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important1"><spring:message code='ezTask.t171' /></label>
												<div class="custom_radio"><input type ="radio" id="important2" name="important" value ="2" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important2"><spring:message code='ezTask.t172' /></label>
												<div class="custom_radio"><input type ="radio" id="important3" name="important" value ="3" checked="checked" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important3"><spring:message code='ezTask.t173' /></label>
											</c:when>
											<c:otherwise>
												<div class="custom_radio"><input type ="radio" id="important1" name="important" value ="1" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important1"><spring:message code='ezTask.t171' /></label>
												<div class="custom_radio"><input type ="radio" id="important2" name="important" value ="2" checked="checked" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important2"><spring:message code='ezTask.t172' /></label>
												<div class="custom_radio"><input type ="radio" id="important3" name="important" value ="3" style="margin:0px 0px 0px 3px" /></div>
												<label for ="important3"><spring:message code='ezTask.t173' /></label>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
								<tr id="personinputtr" style="display:none">
									<th><a class="imgbtn"><span onClick="manage_share(1)"><spring:message code='ezTask.t2005' /></span></a></th>
									<td colspan ="3" style="OVERFLOW-Y: auto;">
										<div id="personlist"></div>
										<div id="personList2" style="display:none;"></div>
										<div id="personID" style="display:none;"></div>
										<div id="personDept" style="display:none;"></div>
										<div id="personDept2" style="display:none;"></div>
									</td>
								</tr>
								<tr id="shareinputtr">
									<th><a class="imgbtn"><span onClick="manage_share(2)"><spring:message code='ezTask.t157' /></span></a></th>
									<td colspan ="3" style="OVERFLOW-Y: auto;">
										<div id="sharelist">
											<c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}">
												<c:out value = '${taskShareVO.sharerName }' />&nbsp;(<c:out value = '${taskShareVO.sharerDeptName }' />)
												<c:if test="${not status.last }">,&nbsp;</c:if>
											</c:forEach>
										</div>
										<div id="shareList2" style="display:none;"></div>
										<div id="shareID" style="display:none;"></div>
										<div id="shareDept" style="display:none;"></div>
										<div id="shareDept2" style="display:none;"></div>
									</td>
								</tr>
								<tr id="trrepeatinfo">
									<th><a class="imgbtn"><span onClick="config_repeat()"><spring:message code='ezTask.t213' /></span></a></th>
									<td class="pos1" colspan="3" style="OVERFLOW-Y: auto; "><div id="repeatinfo" style="width:100%;"></div></td>
								</tr>
								
								<c:if test="${mode == '' }">
									<tr>
				                        <th><spring:message code='ezTask.t158' /></th>
				                        <td colspan="3"><span id="periodblock">
					                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
					                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
				                        	</span> <span id="repeatblock" style="DISPLAY:none"><spring:message code='ezTask.t214' /></span>
										</td>
									</tr>
								</c:if>
								<!-- 메모  -->
								<c:if test="${useTodoMemo == 'YES' && mode == ''}">	
									<tr id="menuTaskMemo">
										<th><spring:message code='ezTask.t170' /></th>
										<td colspan="3" id ="memoTd" style="width:100%;">
											<input type="text" id="TextMemo" style="width:100%;height: 80%;" value = "<c:out value = '${taskInfoVO.memo }' />">
										</td>
									</tr>
								</c:if>
								<c:if test="${mode == '1' }">
									<tr>
				                        <th><spring:message code='ezTask.t158' /></th>
				                        <td colspan="3">
				                        	<c:if test="${taskInfoVO.taskType == '4' || taskInfoVO.taskType == '5' || taskInfoVO.taskType == '6' }">
					                        	<span id="periodblock" style="display: none;">				                        	
							                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
							                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
					                        	</span> 				                        	
					                        	<span id="repeatblock"><spring:message code='ezTask.t214' /></span>
					                        </c:if>
				                     		<c:if test="${taskInfoVO.taskType == '1' || taskInfoVO.taskType == '2' || taskInfoVO.taskType == '3' }">
				                     			<span id="periodblock">				                        	
							                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
							                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
					                        	</span> 
				                        		<span id="repeatblock" style="DISPLAY:none"><spring:message code='ezTask.t214' /></span>
					                        </c:if>
										</td>
									</tr>
								</c:if>
								
								<c:if test="${mode == '' }">
									<tr>
										<th id="editorTitle" colspan="4" style="text-align: center;"><spring:message code = 'ezTask.t2011' /></th>
									</tr>
								</c:if>
								<!-- 메모수정 -->
								<c:if test="${useTodoMemo == 'YES' && mode == '1' }">
									<tr>
										<th><spring:message code='ezTask.t1701' /></th>
										<td colspan="3">
											<input type="text" id="TextMemo" style="width:100%;height: 80%;" value = "<c:out value = '${taskInfoVO.memo }' />">
										</td>
									</tr>
								</c:if>
							</table>
						</td>
					</tr>
					</c:when>
					<c:otherwise>
						<tr>					
							<td height="20" id="menuTaskInf" style="display: none;">
								<table class="content" id="tableInformation">
									<tr>
										<th><spring:message code='ezTask.t118' /></th>
										<td colspan="3"><input type="text" id="TextTitle" style="width:100%;" value = "<c:out value='${taskInfoVO.title}'/>"></td>
									</tr>
									<tr>
										<th><spring:message code='ezTask.t2003' /></th>
										<td style="width:300px">
											<c:choose>
												<c:when test="${taskInfoVO.taskType == '2' || taskInfoVO.taskType == '5'}">
													<div class="custom_radio"><input type ="radio" id="P" name="tasktypesel" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="P"><spring:message code='ezTask.t2000' /></label>
													<div class="custom_radio"><input type ="radio" id="I" name="tasktypesel" value ="2" checked="checked" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="I"><spring:message code='ezTask.t2001' /></label>
													<div class="custom_radio"><input type ="radio" id="C" name="tasktypesel" value ="3" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="C"><spring:message code='ezTask.t2002' /></label>
												</c:when>
												<c:when test="${taskInfoVO.taskType == '3' || taskInfoVO.taskType == '6'}">
													<div class="custom_radio"><input type ="radio" id="P" name="tasktypesel" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="P"><spring:message code='ezTask.t2000' /></label>
													<div class="custom_radio"><input type ="radio" id="I" name="tasktypesel" value ="2" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="I"><spring:message code='ezTask.t2001' /></label>
													<div class="custom_radio"><input type ="radio" id="C" name="tasktypesel" value ="3" checked="checked" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="C"><spring:message code='ezTask.t2002' /></label>
												</c:when>
												<c:otherwise>
													<div class="custom_radio"><input type ="radio" id="P" name="tasktypesel" checked="checked" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="P"><spring:message code='ezTask.t2000' /></label>
													<div class="custom_radio"><input type ="radio" id="I" name="tasktypesel" value ="2" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="I"><spring:message code='ezTask.t2001' /></label>
													<div class="custom_radio"><input type ="radio" id="C" name="tasktypesel" value ="3" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" /></div>
													<label for ="C"><spring:message code='ezTask.t2002' /></label>
												</c:otherwise>
											</c:choose>
										</td>
										<th><spring:message code='ezTask.t2004' /></th>
										<td style="width:300px">
											<c:choose>
												<c:when test="${taskInfoVO.importance == '1' }">
													<div class="custom_radio"><input type ="radio" id="important1" name="important" value ="1" checked="checked" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important1"><spring:message code='ezTask.t171' /></label>
													<div class="custom_radio"><input type ="radio" id="important2" name="important" value ="2" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important2"><spring:message code='ezTask.t172' /></label>
													<div class="custom_radio"><input type ="radio" id="important3" name="important" value ="3" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important3"><spring:message code='ezTask.t173' /></label>
												</c:when>
												<c:when test="${taskInfoVO.importance == '3' }">
													<div class="custom_radio"><input type ="radio" id="important1" name="important" value ="1" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important1"><spring:message code='ezTask.t171' /></label>
													<div class="custom_radio"><input type ="radio" id="important2" name="important" value ="2" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important2"><spring:message code='ezTask.t172' /></label>
													<div class="custom_radio"><input type ="radio" id="important3" name="important" value ="3" checked="checked" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important3"><spring:message code='ezTask.t173' /></label>
												</c:when>
												<c:otherwise>
													<div class="custom_radio"><input type ="radio" id="important1" name="important" value ="1" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important1"><spring:message code='ezTask.t171' /></label>
													<div class="custom_radio"><input type ="radio" id="important2" name="important" value ="2" checked="checked" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important2"><spring:message code='ezTask.t172' /></label>
													<div class="custom_radio"><input type ="radio" id="important3" name="important" value ="3" style="margin:0px 0px 0px 3px" /></div>
													<label for ="important3"><spring:message code='ezTask.t173' /></label>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
									<tr id="personinputtr" style="display:none">
										<th><a class="imgbtn"><span onClick="manage_share(1)"><spring:message code='ezTask.t2005' /></span></a></th>
										<td colspan ="3" style="OVERFLOW-Y: auto;">
											<div id="personlist"></div>
											<div id="personList2" style="display:none;"></div>
											<div id="personID" style="display:none;"></div>
											<div id="personDept" style="display:none;"></div>
											<div id="personDept2" style="display:none;"></div>
										</td>
									</tr>
									<tr id="shareinputtr">
										<th><a class="imgbtn"><span onClick="manage_share(2)"><spring:message code='ezTask.t157' /></span></a></th>
										<td colspan ="3" style="OVERFLOW-Y: auto;">
											<div id="sharelist">
												<c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}">
													<c:out value = '${taskShareVO.sharerName }' />&nbsp;(<c:out value = '${taskShareVO.sharerDeptName }' />)
													<c:if test="${not status.last }">,&nbsp;</c:if>
												</c:forEach>
											</div>
											<div id="shareList2" style="display:none;"></div>
											<div id="shareID" style="display:none;"></div>
											<div id="shareDept" style="display:none;"></div>
											<div id="shareDept2" style="display:none;"></div>
										</td>
									</tr>
									<tr id="trrepeatinfo">
										<th><a class="imgbtn"><span onClick="config_repeat()"><spring:message code='ezTask.t213' /></span></a></th>
										<td class="pos1" colspan="3" style="OVERFLOW-Y: auto; "><div id="repeatinfo" style="width:100%;"></div></td>
									</tr>
									<tr>
				                        <th><spring:message code='ezTask.t158' /></th>
				                        <td colspan="3"><span id="periodblock">
					                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
					                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
				                        	</span> <span id="repeatblock" style="DISPLAY:none"><spring:message code='ezTask.t214' /></span>
										</td>
									</tr>

									<c:if test="${mode == '' }">
										<tr>
											<th id="editorTitle" colspan="4" style="text-align: center;"><spring:message code = 'ezTask.t2011' /></th>
										</tr>
									</c:if>
									<c:if test="${mode == '1' }">
										<tr>
											<th><spring:message code='ezTask.t1701' /></th>
											<td colspan="3">
												<input type="text" id="TextMemo" style="width:100%;height: 80%;" value = "<c:out value = '${taskInfoVO.memo }' />">
											</td>
										</tr>
									</c:if>
									<c:if test="${mode == '2' }">
										<tr>
											<th><spring:message code='ezTask.t1701' /></th>
											<td colspan="3">
												<input type="text" id="TextMemo" style="width:100%;height: 80%;" value = "<c:out value = '${taskInfoVO.memo }' />">
											</td>
										</tr>
									</c:if>
								</table>
							</td>
						</tr>
					</c:otherwise>
				</c:choose>
				
				<c:choose>
					<c:when test="${mode == ''}">
						<tr>
							<td id="EdtorSize">
								<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; margin-top: 2.3px; height: 100%; width: 99.7%; overflow: auto;"></iframe>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${ mode == '2'}">
								<tr>
									<td id="EdtorSize" style="height: 440px;">
										<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; margin-top: 2.3px; height: 100%; width: 99.7%; overflow: auto;"></iframe>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td id="EdtorSize" style="display:none;">
										<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; margin-top: 2.3px; height: 100%; width: 99.7%; overflow: auto;"></iframe>
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>			
								
				<c:choose>
					<c:when test="${mode == ''}">
						<tr>
							<td>
								<iframe id="dadiframe" name="dadiframe" style="width: 100%;margin-top:3px; height: 100%; border: 0px;" src="/ezTask/dragAndDrop.do"></iframe>
							</td>
						</tr>
					</c:when>
					<c:otherwise>
						<c:choose>
							<c:when test="${ mode == '2'}">
								<tr>
									<td>
										<iframe id="dadiframe" name="dadiframe" style="width: 100%;margin-top:3px; height: 160px; border: 0px;" src="/ezTask/dragAndDrop.do"></iframe>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td>
										<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 160px; border: 0px; display: none;" src="/ezTask/dragAndDrop.do"></iframe>
									</td>
								</tr>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>								
				
			</table>
		</div>
		<div id="printScreen" style="display: none">
			<table class="content">
				<tr>
					<th><spring:message code='ezTask.t2005' /></th>
					<td><div id="printPerson"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t157' /></th>
					<td><div id="printShare"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t2003' /></th>
					<td><div id="printTasktype"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t156' /></th>
					<td><div id="printImportance"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t218' /></th>
					<td><div id="printDate"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t118' /></th>
					<td><div id="printTitle"></div></td>
				</tr>
				<tr>
					<th><spring:message code='ezTask.t219' /></th>
					<td><div id="printAttach"></div></td>
				</tr>
				<tr style="width:100%;">
					<td colspan="2"><div id="printDocument" style="padding-right: 5px; padding-left: 5px; padding-bottom: 5px; width: 100%; padding-top: 5px"></div></td>
				</tr>
			</table>
 			<script>				
				if (mode == "") {					
					if (useTodoMemo == 'YES') { 
						if (tasktype == "1") { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX"; 
						} else if (tasktype == "2") { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX"; 
						} else if (tasktype == "3") { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX"; 
						} else { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 410 + "PX"; 
						} 
					} else { 
						if (tasktype == "1") { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX"; 
						} else if (tasktype == "2") { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX"; 
						} else if (tasktype == "3") { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX"; 
						} else { 
							document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 380 + "PX"; 
						} 
					}
				}
				
				mobileDistinction(); 
			</script>
		</div>
	</body>
</html>
