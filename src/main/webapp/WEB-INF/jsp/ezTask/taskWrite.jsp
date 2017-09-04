<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<HEAD>
		<title><spring:message code='ezTask.t206' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezTask.e1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezTask/task_write_Cross.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachItem_CK.js"></script>
		<script type="text/javascript" src="/js/ezTask/AttachMain_CK.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script>
			var userid = "${userInfo.id }";
			var username = "${userInfo.displayName }";
			var username2 = "${userInfo.displayName2 }";
			var deptname = "${userInfo.deptName }";
			var deptname2 = "${userInfo.deptName2 }";
			var taskid = "${taskInfoVO.taskID }";
			var taskstatus = "${taskInfoVO.taskStatus }";
			var completerate = "${taskInfoVO.completeRate }";
			var startdate = "${taskInfoVO.startDate }";
			var enddate = "${taskInfoVO.endDate }";
			var importance = "${taskInfoVO.importance }";
			var tasktype = "${taskInfoVO.taskType }";
			var creatorid = "${taskInfoVO.creatorID }";
			var hasattach = "${taskInfoVO.hasAttach }";
			var hasshare = "${taskInfoVO.hasShare}";
			var contentPath = "${taskInfoVO.contentPath }";
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
			var isreadpage = false;
			var FormProcSpelling = "FormProcSpelling";
			var personid = "${taskInfoVO.personID }";
			var personname = "${taskInfoVO.personName }";
			var personname2 = "${taskInfoVO.personName2 }";
			var persondept = "${taskInfoVO.personDeptName }";
			var persondept2 = "${taskInfoVO.personDeptName2 }";
			var personemail = "${taskInfoVO.personEmail }";
			var useTodoMemo = "${useTodoMemo }";
          
			window.onload = function () {
				if (taskid != "") {
					document.getElementById("importantSelect").value = importance;
					document.getElementById("taskstatusSelect").value = taskstatus;
					document.getElementById("completerateSelect").value = completerate;
					
					if (hasattach == "Y") {
			            setAttachFileInfo("${taskAttachList}");
			        }
					
					Editor_Complete();
				}
	
				if (tasktype == "1") {
					document.getElementById("P").click();
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 375 + "PX";
				} else if (tasktype == "2") {
					document.getElementById("I").click();
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 405 + "PX";
				} else if (tasktype == "3") {
					document.getElementById("C").click();
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 405 + "PX";
				} else {
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 375 + "PX";
				}
	
				if (personid != "" && personid != creatorid) {
					document.getElementById("personlist").innerHTML = personid;
	                 
					g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
	
					g_person["name"][0] = personname;
					g_person["name1"][0] = personname;
					g_person["name2"][0] = personname2;
					g_person["id"][0] = personid;
					g_person["deptname"][0] = persondept;
					g_person["deptname2"][0] = persondept2;
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
			}

			window.onresize = function () {
				if (useTodoMemo == 'YES') {
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 405 + "PX";
				} else {
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
				}
			}
			
			$(function () {
				$("#Sdatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					beforeShow: function (input) {
						var i_offset = $(input).offset();
						setTimeout(function () {
							$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
						})
					}
				});
	
				$("#Edatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					beforeShow: function (input) {
						var i_offset = $(input).offset();
						setTimeout(function () {
							$('#ui-datepicker-div').css({ 'top': i_offset.top, 'bottom': '', 'top': '0px' });
		     			})
		 			}
				});

				var SDate = new Date(startdate);
				var EDate = new Date(enddate);
				$("#Sdatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Sdatepicker").datepicker('setDate', SDate);
				
				$("#Edatepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$("#Edatepicker").datepicker('setDate', EDate);
			});
      
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
      
			function attach_Add() {
			    document.form.file1.click();
			}
			var AttachLimit = 5;
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
			        async : false,
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
			    }
			}

			function changemenu(obj) {
				if (obj.id == "P") {
					taskType = obj.value;
					document.getElementById("personinputtr").style.display = "none";
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 375 + "PX";
				} else if (obj.id == "I") {
					taskType = obj.value;
					document.getElementById("personinputtr").style.display = "";
					document.getElementById("periodblock").style.display = "";
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 405 + "PX";
					$("#personlist").html("");
				} else if (obj.id == "C") {
					taskType = obj.value;
					document.getElementById("personinputtr").style.display = "";
					document.getElementById("periodblock").style.display = "";
					document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 405 + "PX";
					$("#personlist").html("");
				}
			}

			function beforeprint() {
				$(".popup").css('background-image', 'none');
	
				document.getElementById("main_body").style.display = "none";
				document.getElementById("printScreen").style.display = "";
				
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
				setNodeText(document.getElementById("printCompleteRate"), document.getElementById("completerateSelect").value + "%");
				
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
	
				var taskstatus = document.getElementById("taskstatusSelect").value;

				switch (taskstatus) {
					case "1":
						taskstatus = "<spring:message code = 'ezTask.t97' />";
						break;
					case "2":
						taskstatus = "<spring:message code = 'ezTask.t98' />";
						break;
					case "3":
						taskstatus = "<spring:message code = 'ezTask.t99' />";
						break;
					case "4":
						taskstatus = "<spring:message code = 'ezTask.t100' />";
						break;
				}

				setNodeText(document.getElementById("printStatus"), taskstatus);
				
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
					filehtml = filehtml + "<span><input type='checkbox'><img src='/images/email/mail_006.gif'> " + getNodeText(nodes[i].childNodes[1]) + "&nbsp;&nbsp;<br></span>";
				}
				
				document.getElementById("printAttach").innerHTML = filehtml;
				document.getElementById("printDocument").innerHTML = message.GetEditorContent();
				
				window.print();
				
				$(".popup").css("background-image", "url('/images/kr/cm/popup_bg.gif')");
				
				document.getElementById("main_body").style.display = "";
				document.getElementById("printScreen").style.display = "none";
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
                  <div id="menu">
                     <ul>
                        <c:choose>
                           <c:when test="${taskID == ''}">
                              <li><span onClick="save_task()"><spring:message code='ezTask.t96' /></span></li>
                              <li style="display:none"><span onClick="check_name()"><spring:message code='ezTask.t11' /></span></li>
                              <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li>
                              <li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle" ><spring:message code='ezTask.t156' /></li>
                           </c:when>
                           <c:otherwise>
                              <li><span onClick="save_task()"><spring:message code='ezTask.t96' /></span></li>
                              <li><span onClick="beforeprint()"><spring:message code='ezTask.t153' /></span></li>
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
                        
                        <li id="taskstatusname" class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle"><spring:message code='ezTask.t210' /></li>
                        <li id="taskstatus" class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
                           <select name="taskstatusSelect" id="taskstatusSelect" onChange="taskstatus_change()" style="vertical-align:top;" >
                              <option value='1' selected><spring:message code='ezTask.t97' /></option>
                              <option value='2'><spring:message code='ezTask.t98' /></option>
                              <option value='3'><spring:message code='ezTask.t99' /></option>
                              <option value='4'><spring:message code='ezTask.t100' /></option>
                           </select>
                        </li>
                        
                        <li id="completeratename" class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" style="vertical-align:middle"><spring:message code='ezTask.t120' /></li>
                        <li id="completerate" class="sel"style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
                           <select name="completerateSelect" id="completerateSelect"  onChange="rate_change()" style="vertical-align:top;" >
                              <option value='0' selected>0%</option>
                              <option value='10'>10%</option>
                              <option value='20'>20%</option>
                              <option value='30'>30%</option>
                              <option value='40'>40%</option>
                              <option value='50'>50%</option>
                              <option value='60'>60%</option>
                              <option value='70'>70%</option>
                              <option value='80'>80%</option>
                              <option value='90'>90%</option>
                              <option value='100'>100%</option>
                           </select>
                        </li>
                     </ul>
                  </div>
                  <div id="close">
                     <ul>
                        <li><span onClick="close_onclick()"><spring:message code='ezTask.t9' /></span></li>
                     </ul>
                  </div>
                  <script type="text/javascript">
                     selToggleList(document.getElementById("menu"), "ul", "li", "0");
                     selToggleList(document.getElementById("close"), "ul", "li", "0");
                  </script>
               </td>
            </tr>

            <tr>
               <td height="20">
                  <table class="content">
                     <tr>
                        <th><spring:message code='ezTask.t118' /></th>
                        <td colspan="3"><input type="text" id="TextTitle" style="width:100%; maxlength:100;" value = "<c:out value = '${taskInfoVO.title }' />"></td>
                     </tr>
                     <tr>
                        <th><spring:message code='ezTask.t2003' /></th>
                        <td style="width:300px">
                           <c:choose>
                              <c:when test="${taskInfoVO.taskType == '2'}">
                                 <input type ="radio" id="P" name="tasktypesel" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="P"><spring:message code='ezTask.t2000' /></label>
                                 <input type ="radio" id="I" name="tasktypesel" value ="2" checked="checked" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="I"><spring:message code='ezTask.t2001' /></label>
                                 <input type ="radio" id="C" name="tasktypesel" value ="3" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="C"><spring:message code='ezTask.t2002' /></label>
                              </c:when>
                              <c:when test="${taskInfoVO.taskType == '3'}">
                                 <input type ="radio" id="P" name="tasktypesel" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="P"><spring:message code='ezTask.t2000' /></label>
                                 <input type ="radio" id="I" name="tasktypesel" value ="2" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="I"><spring:message code='ezTask.t2001' /></label>
                                 <input type ="radio" id="C" name="tasktypesel" value ="3" checked="checked" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="C"><spring:message code='ezTask.t2002' /></label>
                              </c:when>
                              <c:otherwise>
                                 <input type ="radio" id="P" name="tasktypesel" checked="checked" value ="1" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="P"><spring:message code='ezTask.t2000' /></label>
                                 <input type ="radio" id="I" name="tasktypesel" value ="2" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="I"><spring:message code='ezTask.t2001' /></label>
                                 <input type ="radio" id="C" name="tasktypesel" value ="3" onclick="changemenu(this)" style="margin:0px 0px 0px 3px" />
                                 <label for ="C"><spring:message code='ezTask.t2002' /></label>
                              </c:otherwise>
                           </c:choose>
                        </td>
                        <th><spring:message code='ezTask.t2004' /></th>
                        <td style="width:300px">
                           <c:choose>
                              <c:when test="${taskInfoVO.importance == '1' }">
                                 <input type ="radio" id="important1" name="important" value ="1" checked="checked" style="margin:0px 0px 0px 3px" />
                                 <label for ="important1"><spring:message code='ezTask.t171' /></label>
                                 <input type ="radio" id="important2" name="important" value ="2" style="margin:0px 0px 0px 3px" />
                                 <label for ="important2"><spring:message code='ezTask.t172' /></label>
                                 <input type ="radio" id="important3" name="important" value ="3" style="margin:0px 0px 0px 3px" />
                                 <label for ="important3"><spring:message code='ezTask.t173' /></label>
                              </c:when>
                              <c:when test="${taskInfoVO.importance == '3' }">
                                 <input type ="radio" id="important1" name="important" value ="1" style="margin:0px 0px 0px 3px" />
                                 <label for ="important1"><spring:message code='ezTask.t171' /></label>
                                 <input type ="radio" id="important2" name="important" value ="2" style="margin:0px 0px 0px 3px" />
                                 <label for ="important2"><spring:message code='ezTask.t172' /></label>
                                 <input type ="radio" id="important3" name="important" value ="3" checked="checked" style="margin:0px 0px 0px 3px" />
                                 <label for ="important3"><spring:message code='ezTask.t173' /></label>
                              </c:when>
                              <c:otherwise>
                                 <input type ="radio" id="important1" name="important" value ="1" style="margin:0px 0px 0px 3px" />
                                 <label for ="important1"><spring:message code='ezTask.t171' /></label>
                                 <input type ="radio" id="important2" name="important" value ="2" checked="checked" style="margin:0px 0px 0px 3px" />
                                 <label for ="important2"><spring:message code='ezTask.t172' /></label>
                                 <input type ="radio" id="important3" name="important" value ="3" style="margin:0px 0px 0px 3px" />
                                 <label for ="important3"><spring:message code='ezTask.t173' /></label>
                              </c:otherwise>
                           </c:choose>
                        </td>
                     </tr>
<%--                         <c:choose> --%>
<%--                            <c:when test="${taskInfoVO.creatorID == userInfo.id || taskInfoVO.creatorID== ''}"> --%>
<!--                               <tr id="personinputtr" style="display:none"> -->
<%--                                  <th ><a class="imgbtn"><span onClick="manage_share(1)"><spring:message code='ezTask.t2005' /></span></a></th> --%>
<!--                                  <td colspan ="3"><div id="personlist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></div></td> -->
<!--                               </tr> -->
<%--                            </c:when> --%>
<%--                            <c:otherwise> --%>
                              <tr id="personinputtr" style="display:none">
                                 <th><a class="imgbtn"><span onClick="manage_share(1)"><spring:message code='ezTask.t2005' /></span></a></th>
                                 <td colspan ="3">
                                 	<div id="personlist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></div>
                                 	<div id="personList2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
		         					<div id="personID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
		         					<div id="personDept" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
		         					<div id="personDept2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
                                 </td>
                              </tr>
<%--                            </c:otherwise> --%>
<%--                         </c:choose> --%>

                     <tr id="shareinputtr">
                        <th><a class="imgbtn"><span onClick="manage_share(2)"><spring:message code='ezTask.t157' /></span></a></th>
                           <td colspan ="3">
                           		<div id="sharelist" style="OVERFLOW-Y: auto; HEIGHT: 17px"><c:forEach var="taskShareVO" varStatus="status" items="${taskShareList}"><c:out value = '${taskShareVO.sharerName }' /><c:if test="${not status.last }">,&nbsp;</c:if></c:forEach></div>
                           		<div id="shareList2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         					<div id="shareID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         					<div id="shareDept" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
	         					<div id="shareDept2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
                           </td>
                           <!-- <td colspan="3" id ="itemList">
                              <input name="Input" id="shareInput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)">
                              <div id="shareList" style="OVERFLOW-Y: auto; HEIGHT: 28px; display: inline;"></div>
                              <div id="shareList2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
                              <div id="shareID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
                              <div id="shareDept" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
                              <div id="shareDept2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
                           </td> -->
                     </tr>

<!--                         <tr style="display:none"> -->
<%--                            <th><spring:message code='ezTask.t212' /></th> --%>
<!--                            <td colspan="3"> -->
<!--                               <input type="text" id='TextCompleteDate' class='datepicker_date' name="txtPermanence" readonly ="true"> -->
<!--                               <img id="TextCompleteDate_img" src="/images/i_scheduler.gif" style="CURSOR:pointer;POSITION:relative;vertical-align:middle;width:19px;height:15px" popuplocation='bottomright' tabindex="0" popupLocation='topright' /> -->
<!--                            </td> -->
<!--                         </tr> -->
<!--                         <tr id="trrepeatinfo"> -->
<%--                            <th><a class="imgbtn"><span onClick="config_repeat()"><spring:message code='ezTask.t213' /></span></a></th> --%>
<!--                            <td class="pos1" colspan="3"><div id="repeatinfo" style="overflow-Y: auto; padding-top: 2px; width:100%; height: 19px"></div></td> -->
<!--                         </tr> -->
                     <tr>
                        <th><spring:message code='ezTask.t158' /></th>
                        <td colspan="3"><span id="periodblock">
                        <input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly"> ~
                        <input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
                        </span> <span id="repeatblock" style="DISPLAY:none"><spring:message code='ezTask.t214' /></span> </td>
                     </tr>
                  </table>
               </td>
            </tr>
            <tr>
                <td id="EdtorSize" style="height:100%;">
                     <iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;"></iframe>
                </td>
            </tr>
            <!-- 메모  -->
            <c:if test="${useTodoMemo == 'YES' }">
	            <tr>
	            	<td>
	            		<table class="content">
	            			<tr>
	            				<th><spring:message code='ezTask.t170' /></th>
				            	<td colspan="3" style="width:100%;">
<!-- 				            	<td colspan="3" style="width:100%;"> -->
<!-- 				            		<input type="text" id="TextMemo" style="width:100%;"> -->
									<%-- <textarea id="TextMemo" style="width:99.6%; height:55px; padding-bottom:5px; padding-left:5px; padding-right:0px; padding-top:5px; border:0px solid rgb(222, 222, 222); border-image: none; resize:none; overflow-y:auto" onkeyup="return textLimit(this, event, 200)">${taskInfoVO.memo }</textarea> --%>
									<input type="text" id="TextMemo" style="width:100%; maxlength:100;" value = "<c:out value = '${taskInfoVO.memo }' />">
				            	</td>
	            			</tr>
	            		</table>
	            	</td>
	            </tr>
            </c:if>
            
            <tr>
                <td>
                     <br/> 
                     <iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezTask/dragAndDrop.do"></iframe>
                </td>
            </tr>
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
               <th><spring:message code='ezTask.t217' /></th>
               <td><div id="printStatus"></div></td>
            </tr>
            <tr>
               <th><spring:message code='ezTask.t120' /></th>
               <td><div id="printCompleteRate"></div></td>
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
      </div>
      <script>
		if (useTodoMemo == 'YES') {
			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 405 + "PX";
		} else {
			document.getElementById("EdtorSize").style.height = document.documentElement.clientHeight - 350 + "PX";
		}
      </script>
   </body>
</html>