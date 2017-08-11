<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<HEAD>
		<title><spring:message code='ezTask.t206' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezTask.e1' />" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezTask.e2' />" type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
		<link rel="stylesheet" href="/js/jquery/dateControls/demos.css">
		<link rel="stylesheet" href="/js/jquery/timeControls/jquery.timepicker.css" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezTask/task_write.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script>
			var userid = "_userid";
			var username = "_username";
		    var username2 = "_username2";
		    var deptname = "userinfo.DeptName";
		    var deptname2 = "userinfo.DeptName2";
			var taskid = " _taskid";
			var taskstatus = "_taskstatus";
			var completerate = "_completerate";
			var startdate = "_startdate";
			var enddate = "_enddate";
			var content = "_content";
			var importance = "_importance";
		    var repetition = "_repetition";
		    var tasktype = "_tasktype";
			var repetitiondel = "_repetitiondel";
		    var TextCompleteDate1 = "_TextCompleteDate";
		    var creatorid = "_creatorid";
		    var _hasattach = "_hasattach";
		    var taskType = "";
		    var strLang_1 = "<spring:message code='ezTask.t22' />";
		    var hasshare = "_hasshare";
		    var personlist = "_personlist";
		    var sharelist = "_sharelist";
		    var g_person = null;
		    var g_share = null;
		    var shareid = "_shareid";
		    var sharename = "_sharename";
		    var sharename2 = "_sharename2";
		    var sharedept = "_sharedept";
		    var sharedept2 = "_sharedept2";
		    var sharemail = "_sharemail";
// 		    var objMHT = new ActiveXObject("MhtFormat.Convert");
		    var isreadpage = false;
		    var FormProcSpelling = "FormProcSpelling";
		    window.onload = function () {
		        window.onresize();
		        form1.EzHTTPTrans.SetBigLang = "${userinfo.lang}" == "1" ? 1 : 2;
		        document.getElementById("TextCompleteDate").value = "";
		//         if (_hasattach == "YES")
		<%--             ModifyAttachOCX("<%= _attachFileName %>"); --%>
		
		        if (taskid != "") {
		            document.getElementById("importantSelect").value = importance;
		            document.getElementById("taskstatusSelect").value = taskstatus;
		            document.getElementById("completerateSelect").value = completerate;
		            document.getElementById("TextCompleteDate").value = TextCompleteDate1;
		            if (repetition != "") {
		                show_repetition_info();            	
		            }
		        }
		
		        if (tasktype == "1") {
		            document.getElementById("P").click();
		        } else if (tasktype == "2") {
		            document.getElementById("I").click();
		        } else if (tasktype == "3") {
		            document.getElementById("C").click();
		        }
		
		        if (importance == "1") {
		            document.getElementById("important1").click();
		        } else if (importance == "2") {
		            document.getElementById("important2").click();
		        } else if (importance == "3") {
		            document.getElementById("important3").click();
		        }
		
		        if (personlist != "") {
		            document.getElementById("personlist").innerHTML = personlist;
		
		            g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
		
		<%--             g_person["name"][0] = "<%= _personname %>"; --%>
		<%--             g_person["id"][0] = "<%= _personid %>"; --%>
		<%--             g_person["deptname"][0] = "<%= _persondept %>"; --%>
		<%--             g_person["name1"][0] = "<%= _personname %>"; --%>
		<%--             g_person["name2"][0] = "<%= _personname2 %>"; --%>
		<%--             g_person["deptname2"][0] = "<%= _persondept2 %>"; --%>
		<%--             g_person["email"][0] = "<%= _personemail %>"; --%>
		        }
		        if (sharelist != "") {
		            document.getElementById("sharelist").innerHTML = sharelist;
		
		            g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
		
		            shareid = shareid.split(";");
		            sharename = sharename.split(";");
		            sharename2 = sharename2.split(";");
		            sharedept = sharedept.split(";");
		            sharedept2 = sharedept2.split(";");
		            sharemail = sharemail.split(";");
		
		            for (var i = 0; i < shareid.length; i++) {
		                g_share["name"][i] = sharename[i];
		                g_share["id"][i] = shareid[i];
		                g_share["deptname"][i] = sharedept[i];
		                g_share["name1"][i] = sharename[i];
		                g_share["name2"][i] = sharename2[i];
		                g_share["deptname2"][i] = sharedept2[i];
		                g_share["email"][i] = sharemail[i];
		            }
		        }
		    }
		
// 		    window.onresize = function () {
// 		        document.getElementById("tbContentElement").style.height = null;
// 		        document.getElementById("tbContentElement").height = document.documentElement.clientHeight - 300;
// 		    }
		    window.onresize = function () {
				document.getElementById("EdtorSize").style.height = document.body.clientHeight + "PX";
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
	
		//     $(function () {
		//         $.datepicker.regional['en'] = {
		//             dateFormat: 'yy-mm-dd',
		//             firstDay: 0,
		//             isRTL: false,
		//             duration: 200,
		//             showAnim: 'show',
		//             showMonthAfterYear: true
		//         };
		//         $.datepicker.setDefaults($.datepicker.regional['en']);
		//     });
		
		    window.onbeforeprint = function () {
		        document.all.printScreen.style.display = "block";
		        document.all.normalScreen.style.display = "none";
		
		        setNodeText(document.getElementById("printShare"), getNodeText(document.getElementById("sharelist")));
		        setNodeText(document.getElementById("printPerson"), getNodeText(document.getElementById("personlist")));
		        setNodeText(document.getElementById("printCompleteRate"), getNodeText(document.getElementById("completerateSelect").options[document.getElementById("completerateSelect").selectedIndex]));
		        setNodeText(document.getElementById("printStatus"), getNodeText(document.getElementById("taskstatusSelect").options[document.getElementById("taskstatusSelect").selectedIndex]));
		        setNodeText(document.getElementById("printImportance"), getNodeText(document.getElementById("importantSelect").options[document.getElementById("importantSelect").selectedIndex]));
		        setNodeText(document.getElementById("printRepetition"), getNodeText(document.getElementById("repeatinfo")));
		
		
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
		                tasktypename = "<spring:message code='ezTask.t2000' />";
		                break;
		            case "2":
		                tasktypename = "<spring:message code='ezTask.t2001' />";
		                break;
		            case "3":
		                tasktypename = "<spring:message code='ezTask.t2002' />";
		                break;
		        }
		        setNodeText(document.getElementById("printTasktype"), tasktypename);
		
		        if (repetition == "")
		            setNodeText(document.getElementById("printDate"), $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "<spring:message code='ezTask.t207' />");
		        else
		            setNodeText(document.getElementById("printDate"), "<spring:message code='ezTask.t208' />");
		
		        setNodeText(document.getElementById("printTitle"), document.getElementById("TextTitle").value);
		
		        var fileNameList = form1.EzHTTPTrans.FileListAll().split("\\");
		        var html = "";
		        for (var i = 0 ; i < fileNameList.length - 1 ; i++) {
		
		            var fileName = fileNameList[i];
		            html = html + "<span><input type='checkbox'><img src='/images/email/mail_006.gif'> " + fileName + "&nbsp;&nbsp;<br></span>";
		        }
		        document.getElementById("printAttach").innerHTML = html;
		        document.getElementById("printDocument").innerHTML = document.getElementById("tbContentElement").editor.DOM.body.innerHTML;
		    }
		
			window.onafterprint = function()
			{
				document.all.printScreen.style.display = "none";
				document.all.normalScreen.style.display = "block";
			}
		
			function changemenu(obj) {
			    if (obj.id == "P") {
			        taskType = obj.value;
			        document.getElementById("personinputtr").style.display = "none";
// 			        document.getElementById("trrepeatinfo").style.display = "";
			    }
			    else if (obj.id == "I") {
			        taskType = obj.value;
			        document.getElementById("personinputtr").style.display = "";
// 			        document.getElementById("trrepeatinfo").style.display = "none";
			        repetition = "";
			        document.getElementById("periodblock").style.display = "";
			        document.getElementById("repeatblock").style.display = "none";
			        document.getElementById("repeatinfo").innerHTML = "&nbsp;";
			    }
			    else if (obj.id == "C") {
			        taskType = obj.value;
			        document.getElementById("personinputtr").style.display = "";
// 			        document.getElementById("trrepeatinfo").style.display = "none";
			        repetition = "";
			        document.getElementById("periodblock").style.display = "";
			        document.getElementById("repeatblock").style.display = "none";
			        document.getElementById("repeatinfo").innerHTML = "&nbsp;";
			    }
			    else {
			        document.getElementById("importantSelect").value = obj.value;
			    }
			}
		</script>
		<script type="text/javascript" FOR="tbContentElement" EVENT="FieldsAvailable">
			pzFormProc_FieldsAvailable();
		</script>
		<script type="text/javascript" FOR="tbContentElement" EVENT="DocumentComplete">
		    pzFormProc_DocumentComplete();
		    SetFormProc_SetLineStyle(tbContentElement);
		    if (document.getElementById("TextTitle").value == "") {
		        document.getElementById("TextTitle").focus();		    	
		    }
		</script>				
		<script type="text/javascript" FOR="EzHTTPTrans" EVENT="AttachAddFile(filename)">
			attach_Add(filename);
		</script>
	</HEAD>
	<body class="popup">
		<form method="post" runat="server" id="form1">
			<div id="main_body">
				<table id="normalScreen" class="layout">
					<tr>
						<td height="20" id="menuTable">
							<div id="menu">
								<ul>
									<c:choose>
										<c:when test="${_taskid == ''}">
											<li><span onClick="save_task()"><spring:message code='ezTask.t96' /></span></li>
											<li><span onClick="window.print()"><spring:message code='ezTask.t153' /></span></li>
											<li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" align="absmiddle"><spring:message code='ezTask.t156' /></li>
										</c:when>
										<c:otherwise>
											<li><span onClick="save_task()"><spring:message code='ezTask.t96' /></span></li>
											<li><span onClick="window.print()"><spring:message code='ezTask.t153' /></span></li>
											<li class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" align="absmiddle"><spring:message code='ezTask.t156' /></li>
										</c:otherwise>
									</c:choose>
									
									<li class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
										<select id="importantSelect" name="importantSelect">
											<option value='1'><spring:message code='ezTask.t171' /></option>
											<option value='2' selected><spring:message code='ezTask.t172' /></option>
											<option value='3'><spring:message code='ezTask.t173' /></option>
										</select>
									</li>
	
									<li id="taskstatusname" class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" align="absmiddle"><spring:message code='ezTask.t210' /></li>
									<li id="taskstatus" class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
										<select id="taskstatusSelect" name="taskstatusSelect"  onChange="taskstatus_change()">
											<option value='1' selected><spring:message code='ezTask.t97' /></option>
											<option value='2'><spring:message code='ezTask.t98' /></option>
											<option value='3'><spring:message code='ezTask.t99' /></option>
											<option value='4'><spring:message code='ezTask.t100' /></option>
										</select>
									</li>
	
									<li id="completeratename" class="sel" style="background: none; border: 0; padding-left: 0; padding-right: 0; padding-top: 4px; color: #fff; cursor: default;display:none"> <img src="/images/pbar.gif" align="absmiddle"><spring:message code='ezTask.t120' /></li>
									<li id="completerate" class="sel" style="background: none; border: none; padding-top: 4px; padding-right: 4px;display:none">
										<select id="completerateSelect" name="completerateSelect"  onChange="rate_change()">
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
									<c:if test="${_repetition != '' }">
										<li><SPAN onClick="restore_deleted()"><spring:message code='ezTask.t211' /></SPAN></li>
									</c:if>
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
									<td colspan="3"><asp:TextBox ID="TextTitle" Runat="server" width="100%" maxlength=100></asp:TextBox></td>
								</tr>
								<tr>
									<th><spring:message code='ezTask.t2003' /></th>
									<td style="width:300px">
										<input type ="radio" id="P" name="tasktypesel" checked="checked" onclick="changemenu(this)" value ="1" />
										<label for ="P"><spring:message code='ezTask.t2000' /></label>
										<input type ="radio" id="I" name="tasktypesel" onclick="changemenu(this)" value ="2" />
										<label for ="I"><spring:message code='ezTask.t2001' /></label>
										<input type ="radio" id="C" name="tasktypesel" onclick="changemenu(this)" value ="3" />
										<label for ="C"><spring:message code='ezTask.t2002' /></label>
									</td>
									<th><spring:message code='ezTask.t2004' /></th>
									<td style="width:300px">
										<input type ="radio" id="important1" name="important" onclick="changemenu(this)" value ="1" />
										<label for ="important1"><spring:message code='ezTask.t171' /></label>
										<input type ="radio" id="important2" name="important" checked="checked"  onclick="changemenu(this)" value ="2" />
										<label for ="important2"><spring:message code='ezTask.t172' /></label>
										<input type ="radio" id="important3" name="important" onclick="changemenu(this)" value ="3" />
										<label for ="important3"><spring:message code='ezTask.t173' /></label>
									</td>
								</tr>
<%-- 								<c:choose> --%>
<%-- 									<c:when test="${_creatorid == userinfo.UserID || _creatorid == ''}"> --%>
<!-- 										<TR id="personinputtr" style="display:none"> -->
<%-- 											<th ><a class="imgbtn"><span onClick="manage_share(1)"><spring:message code='ezTask.t2005' /></span></a></th> --%>
<!-- 											<TD colspan ="3"><DIV id="personlist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></DIV></TD> -->
<!-- 										</TR> -->
<%-- 									</c:when> --%>
<%-- 									<c:otherwise> --%>
<!-- 										<TR id="personinputtr" style="display:none"> -->
<%-- 											<th ><spring:message code='ezTask.t2005' /></th> --%>
<!-- 											<TD colspan ="3"><DIV id="personlist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></DIV></TD> -->
<!-- 										</TR>	            	 -->
<%-- 									</c:otherwise> --%>
<%-- 								</c:choose> --%>
								<TR id="shareinputtr">
									<th ><a class="imgbtn"><span onClick="manage_share(2)"><spring:message code='ezTask.t157' /></span></a></th>
									<TD colspan ="3"><DIV id="sharelist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></DIV></TD>
								</TR>
								<tr style="display:none">
									<th><spring:message code='ezTask.t212' /></th>
									<td colspan="3">
										<input type="text" id='TextCompleteDate' class='datepicker_date' name="txtPermanence" readonly ="true">
										<IMG width="19" height="15" align="absMiddle" border="0" popupLocation='topright' forceMarginLeft='-10' id="img1" src="/images/i_scheduler.gif" style="CURSOR: pointer; POSITION: relative">
									</td>
								</tr>
<!-- 								<tr id="trrepeatinfo"> -->
<%-- 									<th><a class="imgbtn"><span onClick="config_repeat()"><spring:message code='ezTask.t213' /></span></a></th> --%>
<!-- 									<td class="pos1" colspan="3"><div id="repeatinfo" style="OVERFLOW-Y: auto; PADDING-TOP: 2px; width:100%; HEIGHT: 19px"></div></td> -->
<!-- 								</tr> -->
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
			  			<td id="EdtorSize" style="vertical-align:top;height:100%;">
				  			<iframe id="message" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 97%; width: 99.7%; overflow: auto;border-top:0px"></iframe>
		      			</td>
	  				</tr>
					<tr>
						<td height="20" style="padding-top:10px">
							<table id="attachTable" class="file">
								<tr>
									<th><spring:message code='ezTask.t160' /></th>
									<td class="pos1" style="height:60px">
<!-- 										<SCRIPT language='JavaScript'>EzHTTPTrans_ActiveX2("EzHTTPTrans");</SCRIPT> -->
									</td>
									<td class="pos2"><a class="imgbtn"><span id="btn_AttachAdd" onClick="attach_Add()"><spring:message code='ezTask.t215' /></span></a><br>
									<a class="imgbtn"><span id="btn_AttachDel" onClick="attach_Delete()"><spring:message code='ezTask.t216' /></span></a></td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<div id="printScreen" style="DISPLAY: none">
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
						<th><spring:message code='ezTask.t213' /></th>
						<td><div id="printRepetition"></div></td>
					</tr>
					<tr>
						<th><spring:message code='ezTask.t218' /></th>
						<td><div id="printDate"></div></td>
					</tr>
					<tr>
						<th><spring:message code='ezTask.t182' /></th>
						<td><div id="printTitle"></div></td>
					</tr>
					<tr>
						<th><spring:message code='ezTask.t219' /></th>
						<td><div id="printAttach"></div></td>
					</tr>
					<tr width="100%">
						<td colspan="2"><div align="left" id="printDocument" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; WIDTH: 100%; PADDING-TOP: 5px"></div></td>
					</tr>
				</table>
			</div>
		</form>
	</body>
</html>