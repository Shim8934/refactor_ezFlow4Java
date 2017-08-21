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
		<script type="text/javascript" src="<spring:message code='ezTask.e1'/>"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezTask/task_write.js"></script>
		<script type="text/javascript" src="/js/ezTask/task_write_Cross.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/jquery/timeControls/jquery.timepicker.js"></script>
		<script>
			var userid = "${userInfo.id}";
			var username = "${userInfo.displayName}";
		    var username2 = "${userInfo.displayName1}";
		    var deptname = "${userInfo.deptName}";
		    var deptname2 = "${userInfo.deptName1}";
			var taskid = " _taskid";
			var taskstatus = "_taskstatus";
			var completerate = "_completerate";
			var startdate = "_startdate";
			var enddate = "_enddate";
			var content = "${newGuid}";
			var importance = "";
// 		    var repetition = "_repetition";
		    var tasktype = "";
// 			var repetitiondel = "_repetitiondel";
		    var TextCompleteDate1 = "_TextCompleteDate";
		    var creatorid = "_creatorid";
		    var hasattach = "_hasattach";
		    var hasshare = "";
// 		    var personlist = "_personlist";
		    var sharelist = "";
		    var g_person = null;
		    var g_share = null;
		    var shareid = "_shareid";
		    var sharename = "_sharename";
		    var sharename2 = "_sharename2";
		    var sharedept = "_sharedept";
		    var sharedept2 = "_sharedept2";
		    var sharemail = "_sharemail";
		    var isreadpage = false;
		    var FormProcSpelling = "FormProcSpelling";
		    window.onload = function () {
		        window.onresize();
// 		        form1.EzHTTPTrans.SetBigLang = "${userinfo.lang}" == "1" ? 1 : 2;
// 		        document.getElementById("TextCompleteDate").value = "";
		//         if (_hasattach == "YES")
		<%--             ModifyAttachOCX("<%= _attachFileName %>"); --%>
		
// 		        if (taskid != "") {
// 		            document.getElementById("importantSelect").value = importance;
// 		            document.getElementById("taskstatusSelect").value = taskstatus;
// 		            document.getElementById("completerateSelect").value = completerate;
// 		            document.getElementById("TextCompleteDate").value = TextCompleteDate1;
// 		            if (repetition != "") {
// 		                show_repetition_info();            	
// 		            }
// 		        }
		
// 		        if (tasktype == "1") {
// 		            document.getElementById("P").click();
// 		        } else if (tasktype == "2") {
// 		            document.getElementById("I").click();
// 		        } else if (tasktype == "3") {
// 		            document.getElementById("C").click();
// 		        }
		
// 		        if (importance == "1") {
// 		            document.getElementById("important1").click();
// 		        } else if (importance == "2") {
// 		            document.getElementById("important2").click();
// 		        } else if (importance == "3") {
// 		            document.getElementById("important3").click();
// 		        }
		
// 		        if (personlist != "") {
// 		            document.getElementById("personlist").innerHTML = personlist;
		
// 		            g_person = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
		
		<%--             g_person["name"][0] = "<%= _personname %>"; --%>
		<%--             g_person["id"][0] = "<%= _personid %>"; --%>
		<%--             g_person["deptname"][0] = "<%= _persondept %>"; --%>
		<%--             g_person["name1"][0] = "<%= _personname %>"; --%>
		<%--             g_person["name2"][0] = "<%= _personname2 %>"; --%>
		<%--             g_person["deptname2"][0] = "<%= _persondept2 %>"; --%>
		<%--             g_person["email"][0] = "<%= _personemail %>"; --%>
// 		        }
// 		        if (sharelist != "") {
// 		            document.getElementById("shareList").innerHTML = sharelist;
		
// 		            g_share = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };
		
// 		            shareid = shareid.split(";");
// 		            sharename = sharename.split(";");
// 		            sharename2 = sharename2.split(";");
// 		            sharedept = sharedept.split(";");
// 		            sharedept2 = sharedept2.split(";");
// 		            sharemail = sharemail.split(";");
		
// 		            for (var i = 0; i < shareid.length; i++) {
// 		                g_share["name"][i] = sharename[i];
// 		                g_share["id"][i] = shareid[i];
// 		                g_share["deptname"][i] = sharedept[i];
// 		                g_share["name1"][i] = sharename[i];
// 		                g_share["name2"][i] = sharename2[i];
// 		                g_share["deptname2"][i] = sharedept2[i];
// 		                g_share["email"][i] = sharemail[i];
// 		            }
// 		        }
		    }
		
// 		    window.onresize = function () {
// 		        document.getElementById("tbContentElement").style.height = null;
// 		        document.getElementById("tbContentElement").height = document.documentElement.clientHeight - 300;
// 		    }
		    window.onresize = function () {
		    	document.getElementById("EdtorSize").style.height = document.body.clientHeight - 150 + "PX";
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
// 		        setNodeText(document.getElementById("printPerson"), getNodeText(document.getElementById("personlist")));
		        setNodeText(document.getElementById("printCompleteRate"), getNodeText(document.getElementById("completerateSelect").options[document.getElementById("completerateSelect").selectedIndex]));
		        setNodeText(document.getElementById("printStatus"), getNodeText(document.getElementById("taskstatusSelect").options[document.getElementById("taskstatusSelect").selectedIndex]));
		        setNodeText(document.getElementById("printImportance"), getNodeText(document.getElementById("importantSelect").options[document.getElementById("importantSelect").selectedIndex]));
// 		        setNodeText(document.getElementById("printRepetition"), getNodeText(document.getElementById("repeatinfo")));
		
		
		        tasktype = document.getElementsByName("tasktypesel");
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
		
// 		        if (repetition == "")
// 		            setNodeText(document.getElementById("printDate"), $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " ~ " + $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + "<spring:message code='ezTask.t207' />");
// 		        else
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
			    } else if (obj.id == "I") {
			        taskType = obj.value;
			        document.getElementById("personinputtr").style.display = "";
// 			        document.getElementById("trrepeatinfo").style.display = "none";
// 			        repetition = "";
			        document.getElementById("periodblock").style.display = "";
// 			        document.getElementById("repeatblock").style.display = "none";
// 			        document.getElementById("repeatinfo").innerHTML = "&nbsp;";
			    } else if (obj.id == "C") {
			        taskType = obj.value;
			        document.getElementById("personinputtr").style.display = "";
// 			        document.getElementById("trrepeatinfo").style.display = "none";
// 			        repetition = "";
			        document.getElementById("periodblock").style.display = "";
// 			        document.getElementById("repeatblock").style.display = "none";
// 			        document.getElementById("repeatinfo").innerHTML = "&nbsp;";
			    } else {
			        document.getElementById("importantSelect").value = obj.value;
			    }
			}
			
			function Editor_Complete() {
    	    	message.SetEditorContent(sigBody.innerHTML);
    	    }
			
			function save_task() {
			    if (document.getElementById("TextTitle").value == "") {
			        alert("업무명을 입력해주세요.");
			        document.getElementById("TextTitle").focus();
			        return;
			    }

			    var startdate = new Date($("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());
			    var enddate = new Date($("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val());

			    if (startdate > enddate) {
			        alert("<spring:message code='ezTask.t22' />");
			        return;
			    }

			    tasktype = $(":input:radio[name=tasktypesel]:checked").val();
			    importance = $(":input:radio[name=important]:checked").val();

			    var shareList = document.getElementById("shareList").innerHTML;
				var shareList2 = document.getElementById("shareList2").innerHTML;
				var shareID = document.getElementById("shareID").innerHTML;
				var shareDept = document.getElementById("shareDept").innerHTML;
				var shareDept2 = document.getElementById("shareDept2").innerHTML;
				
				var taskPersonList = document.getElementById("personList").innerHTML;
				var taskpersonList2 = document.getElementById("personList2").innerHTML;
				var taskpersonID = document.getElementById("personID").innerHTML;
				var taskpersonDept = document.getElementById("personDept").innerHTML;
				var taskpersonDept2 = document.getElementById("personDept2").innerHTML;

				if (shareList != "") {
					hasshare = "Y";
				} else {
					hasshare = "N";
				}

			    if (!check_length(document.getElementById("TextTitle").value, 100, "<spring:message code='ezTask.t996' />")) return;

			    var xmlDom = createXmlDom();
			    var xmlHTTP = createXMLHttpRequest();
			    var objRoot, objNode, attachnode, shobjnode;
			    objNode = createNodeInsert(xmlDom, objNode, "DATA");
			    createNodeAndInsertText(xmlDom, objNode, "TASKID", taskid);
			    createNodeAndInsertText(xmlDom, objNode, "OWNERID", userid);
			    createNodeAndInsertText(xmlDom, objNode, "CREATORID", userid);
			    createNodeAndInsertText(xmlDom, objNode, "CREATORNAME1", username);
			    createNodeAndInsertText(xmlDom, objNode, "CREATORNAME2", username2);
			    createNodeAndInsertText(xmlDom, objNode, "HASSHARE", hasshare);
			    createNodeAndInsertText(xmlDom, objNode, "TASKTYPE", tasktype);
			    createNodeAndInsertText(xmlDom, objNode, "TASKSTATUS", document.getElementById("taskstatusSelect").value);
			    createNodeAndInsertText(xmlDom, objNode, "COMPLETERATE", document.getElementById("completerateSelect").value);
			    createNodeAndInsertText(xmlDom, objNode, "IMPORTANCE", importance);
			    createNodeAndInsertText(xmlDom, objNode, "STARTDATE", $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 00:00:00");
			    createNodeAndInsertText(xmlDom, objNode, "ENDDATE", $("#Edatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val() + " 23:59:59");
			    createNodeAndInsertText(xmlDom, objNode, "TITLE", document.getElementById("TextTitle").value);

			    var Doc_ContentHtml = document.createElement("DIV");
			    var strBody = message.GetEditorContent();
			    Doc_ContentHtml.innerHTML = strBody;

			    strBody = ConvertHTMLtoMHT("<HTML>" + "<BODY>" + EmbedContentIntoXML(strBody) + "</BODY>" + "</HTML>");

			    createNodeAndInsertText(xmlDom, objNode, "CONTENT", strBody);
		        createNodeAndInsertText(xmlDom, objNode, "CONTENTPATH", content);			    	

			    var sharelist = createNodeAndAppandNode(xmlDom, objNode, sharelist, "SHARELIST");

			    if (hasshare == "Y") {
			    	for (var i = 0; i < g_share["id"].length; i++) {
			            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHAREID", g_share["id"][i]);
			            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARENAME1", g_share["name"][i]);
			            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHARENAME2", g_share["name1"][i]);
			            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHAREDEPTNAME1", g_share["deptname"][i]);
			            createNodeAndAppandNodeText(xmlDom, sharelist, shobjnode, "SHAREDEPTNAME2", g_share["deptname2"][i]);
			        }
			    }

			    var personlist = createNodeAndAppandNode(xmlDom, objNode, personlist, "PERSONLIST");
			    var taskpersonlist = createNodeAndAppandNode(xmlDom, objNode, taskpersonlist, "TASKPERSONLIST");

			    if (tasktype == 1) {
			        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONID", userid);
			        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME1", username);
			        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONNAME2", username2);
			        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME1", deptname);
			        createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "PERSONDEPTNAME2", deptname2);
			    } else {
			        if (taskpersonID != null) {			        	
			            for (var i = 0; i < g_person["id"].length; i++) {
			                createNodeAndAppandNodeText(xmlDom, taskpersonlist, shobjnode, "TASKPERSONID", g_person["id"][i]);
			                createNodeAndAppandNodeText(xmlDom, taskpersonlist, shobjnode, "TASKPERSONNAME1", g_person["name"][i]);
			                createNodeAndAppandNodeText(xmlDom, taskpersonlist, shobjnode, "TASKPERSONNAME2", g_person["name1"][i]);
			                createNodeAndAppandNodeText(xmlDom, taskpersonlist, shobjnode, "TASKPERSONDEPTNAME1", g_person["deptname"][i]);
			                createNodeAndAppandNodeText(xmlDom, taskpersonlist, shobjnode, "TASKPERSONDEPTNAME2", g_person["deptname2"][i]);							
						}
			        } else {
			        	alert("<spring:message code='ezTask.t996' />");
			        	return;
			        }
			    }

			    if (hasshare == "Y") {
					createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "SHARELENGTH", g_share["id"].length);			    	
			    } else {
			    	createNodeAndAppandNodeText(xmlDom, personlist, shobjnode, "SHARELENGTH", 0);
			    }
			    
			  //파일 첨부된 목록 가져오기
				var listtable = dadiframe.document.getElementById("filelist");
				var filelist = GetChildNodes(listtable);
				var fileList = "";

				for (var i = 0; i < filelist.length - 1; i++) {	    
					if (i == 0) {
						fileList = GetAttribute(filelist[i + 1], "data2");
					} else {
						fileList += "," + GetAttribute(filelist[i + 1], "data2");
            		}
				}

				if (fileList.length > 0) {
					createNodeAndInsertText(xmlDom, objNode, "HASATTACH", "Y");
				} else {
					createNodeAndInsertText(xmlDom, objNode, "HASATTACH", "N");
				}

			    createNodeAndInsertText(xmlDom, objNode, "TASKTYPE", tasktype);
			    
			    xmlHTTP.open("POST", "/ezTask/taskSave.do", false);
			    xmlHTTP.send(xmlDom);

			    if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
			        alert("업무를 저장하는 도중 오류 발생.");
			    } else {
			        alert("업부를 저장하였습니다.");

			        try { window.opener.RefreshView(); } catch (e) { }
			        window.close();
			    }
			}

		</script>
		<xmp id="sigBody" style="display: none;"></xmp>
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
<%-- 									<c:if test="${_repetition != '' }"> --%>
<%-- 										<li><SPAN onClick="restore_deleted()"><spring:message code='ezTask.t211' /></SPAN></li> --%>
<%-- 									</c:if> --%>
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
									<td colspan="3"><input type="text" id="TextTitle" style="width:100%"></td>
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
										<input type ="radio" id="important1" name="important" value ="1" />
										<label for ="important1"><spring:message code='ezTask.t171' /></label>
										<input type ="radio" id="important2" name="important" checked="checked" value ="2" />
										<label for ="important2"><spring:message code='ezTask.t172' /></label>
										<input type ="radio" id="important3" name="important" value ="3" />
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
								<tr id="personinputtr" style="display:none">
									<th ><a class="imgbtn"><span onClick="manage_attendant_after(2)"><spring:message code='ezTask.t2005' /></span></a></th>
									<td colspan ="3">
										<div id="personList" style="OVERFLOW-Y: auto; HEIGHT: 17px;display: inline;"></div>
										<div id="personList2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         					<div id="personID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         					<div id="personDept" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         					<div id="personDept2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
									</td>
								</tr>	            	
<%-- 									</c:otherwise> --%>
<%-- 								</c:choose> --%>
								<TR id="shareinputtr">
									<th ><a class="imgbtn"><span onClick="manage_attendant_after(1)"><spring:message code='ezTask.t157' /></span></a></th>
<!-- 									<TD colspan ="3"><DIV id="sharelist" style="OVERFLOW-Y: auto; HEIGHT: 17px"></DIV></TD> -->
			         				<td colspan="3" id ="itemList">
<!-- 			         					<input name="Input" id="shareInput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box; display:none;" onkeyup="return on_keydown(event)"> -->
			         					<div id="shareList" style="OVERFLOW-Y: auto; HEIGHT: 17px; display: inline;"></div>
			         					<div id="shareList2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         					<div id="shareID" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         					<div id="shareDept" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         					<div id="shareDept2" style="OVERFLOW-Y: auto; HEIGHT: 17px; display:none;"></div>
			         				</td>
								</TR>

<!-- 								<tr style="display:none"> -->
<%-- 									<th><spring:message code='ezTask.t212' /></th> --%>
<!-- 									<td colspan="3"> -->
<!-- 										<input type="text" id='TextCompleteDate' class='datepicker_date' name="txtPermanence" readonly ="true"> -->
<!-- 										<IMG width="19" height="15" align="absMiddle" border="0" popupLocation='topright' forceMarginLeft='-10' id="img1" src="/images/i_scheduler.gif" style="CURSOR: pointer; POSITION: relative"> -->
<!-- 									</td> -->
<!-- 								</tr> -->
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
		  				<td>
	       					<iframe id="dadiframe" name="dadiframe" style="width: 100%; height: 100%; border: 0px" src="/ezTask/dragAndDrop.do"></iframe>	
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
<!-- 					<tr> -->
<%-- 						<th><spring:message code='ezTask.t213' /></th> --%>
<!-- 						<td><div id="printRepetition"></div></td> -->
<!-- 					</tr> -->
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