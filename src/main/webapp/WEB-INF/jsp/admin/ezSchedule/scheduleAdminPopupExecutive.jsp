<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>		
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<style type="text/css">
			.ui-datepicker-month {
				padding-top: 1px; <%-- 2018-07-24 천성준 - (#13167) 월 표시 상단이 잘려보임 --%>
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>		
	    <title>
	    	<c:if test="${id == null}"><spring:message code='ezSchedule.lyj02' /></c:if>
		    <c:if test="${id != null}"><spring:message code='ezSchedule.t302' /></c:if>
	    </title>
	    <script type="text/javascript">
			var userid = "<c:out value='${cn}'/>";
			var username = "";
			var userdeptid = "";
			var usage = "<c:out value='${usage}'/>";
			var ReturnFunction = null;
			var companyID = "<c:out value='${companyID}'/>";
			var priority = "<c:out value='${priority}'/>";
			var schedule_select_secretary_cross_dialogArguments = new Array();
			var schedule_select_secretary_cross_dialogArguments = new Array();

			window.onload = function () {
				try {
					ReturnFunction = opener.schedule_admin_popup_executive_dialogArguments[1];
				} catch (e) { }

				username = opener.schedule_admin_popup_executive_dialogArguments[0];
				if (userid != "" && username != "") {
					document.getElementById("add").style.display = "none";
					document.getElementById("selectBtn").style.display = "none";
					document.getElementById("txtuser").value = username;
					document.getElementById("txtuser").readOnly = true;

					if (usage == "Y")
						document.getElementById("date").checked = true;
					else
						document.getElementById("date2").checked = true;

				}
				else
					document.getElementById("mod").style.display = "none";
			}
			
			function select_person() {
				if (CrossYN()) {
					schedule_select_secretary_cross_dialogArguments[1] = select_person_Complete;

					if (navigator.appName.indexOf("Microsoft") > -1) {
						var OpenWin = window.open("/ezSchedule/scheduleSelectSecretary.do", "scheduleSelectSecretary", GetOpenWindowfeature(1000, 580));
						try { OpenWin.focus(); } catch (e) { }
					} else {
						var OpenWin = window.open("/ezSchedule/scheduleSelectSecretary.do", "scheduleSelectSecretary", GetOpenWindowfeature(1000, 590));
						try { OpenWin.focus(); } catch (e) { }
					}
				} else {
					var rtnValue = "";
					var feature = GetShowModalPosition(735, 580);

					if (navigator.appName.indexOf("Microsoft") > -1) {
						rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectSecretary.do", "","dialogHeight:580px;dialogwidth:735px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
					} else {
						rtnValue = window.showModalDialog("/ezSchedule/scheduleSelectSecretary.do", "","dialogHeight:555px;dialogwidth:735px;status:no;toolbar:no;location:no;scroll:no;edge:sunken" + feature);
					}
					if (typeof (rtnValue) != "undefined") {
						userid = rtnValue.split(":")[0];
						document.getElementById("txtuser").value = rtnValue.split(":")[1];
						userdeptid = rtnValue.split(":")[2];
					}
				}
			}

			function select_person_Complete(retVal) {
				if (typeof (retVal) != "undefined") {
					userid = retVal.split(":")[0];
					document.getElementById("txtuser").value = retVal.split(":")[1];
					userdeptid = retVal.split(":")[2];
				}

				if (userid != "") {
					var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/admin/ezSchedule/getSecretary.do?cn=" + userid + "&companyId=" + companyID, false);
					xmlhttp.send();
					var XmlNode = loadXMLString(xmlhttp.responseText);
					var count = SelectNodes(XmlNode, "DATA/ROW").length;
					if (count > 0) {
						document.getElementById("ListSecretary").innerHTML = "";
						for (var i = 0; i < count; i++) {
							var newoption = new Option(getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "SECRETARYNAME")[0]),
									getNodeText(GetElementsByTagName(SelectNodes(XmlNode, "DATA/ROW")[i], "SECRETARYID")[0]));
							document.getElementById("ListSecretary").options[i] = newoption;
						}
					} else {
						document.getElementById("ListSecretary").innerHTML = "";
					}
				}
			}

			function save_settings(flag) {
				if (userid == "") {
					alert("<spring:message code='ezSchedule.lyj10' />");
					return;
				}
				
				var message = "";
				
				$.ajax({
					method : "GET",
					dataType : "text",
					async : false,
					url : "/admin/ezSchedule/scheduleGetExecutiveList.do",
					data : {
						userID : userid,
						companyID : companyID
					},
					success : function(text){
						if (flag == 1 && text.indexOf("CN") != -1) {
							message = "<spring:message code='ezSchedule.lyj15' />";
						}

						if (flag != 1 && text.indexOf("CN") == -1) {
							message = "<spring:message code='ezSchedule.lyj16' />";
						}
					},
					error : function(err){
						alert("<spring:message code='ezSchedule.lyj17' />");
					}
				});
				
				if (message != "") {
					alert(message);
					return;
				}

				var listSecretary = new Array();
				var count = 0;
				if (document.getElementById("ListSecretary").textContent != "") {
					for (var i = 0; i < document.getElementById("ListSecretary").length; i++) {
						var data = new Object();
						data.secretaryID = document.getElementById("ListSecretary").options[i].value;
						data.secretaryName = getNodeText(document.getElementById("ListSecretary").options[i]);

						listSecretary.push(data);
						count++;
					}
				}
				usage = document.getElementById("date").checked ? "Y" : "N";
				$.ajax({
					method : "POST",
					dataType : "text",
					async : false,
					url : "/admin/ezSchedule/scheduleSaveExecutive.do",
					data : {
						userID : userid,
						priority : priority,
						usage : usage,
						companyID : companyID,
						LISTSECRETARY : JSON.stringify(listSecretary),
						flag : flag
					},
					success : function(text){
						if (text == "success") {
							alert("<spring:message code='ezSchedule.t4012' />");

							if (ReturnFunction != null) {
								ReturnFunction("OK");
							} else {
								window.returnValue = "OK";
							}
							window.close();
						}
					},
					error : function(err){
						alert("<spring:message code='ezSchedule.lyj18' />");
					}
				});
			}

			var retData = "";
			function retFunction() {
				if (ReturnFunction != null)
					ReturnFunction("OK");
			}
			
			var schedule_select_attendant_dialogArguments = new Array();
			function ModifySecretary() {
				if (document.getElementById("txtuser").value == null || document.getElementById("txtuser").value == "") {
					alert("<spring:message code='ezSchedule.lyj10' />");
					return;
				}
				
				var secretary = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "email": new Array() };

				for (var i = 0; i < document.getElementById("ListSecretary").length; i++) {
					secretary["id"][i] = document.getElementById("ListSecretary").options[i].value;
					secretary["name"][i] = getNodeText(document.getElementById("ListSecretary").options[i]);
					secretary["name1"][i] = getNodeText(document.getElementById("ListSecretary").options[i]);
					secretary["name2"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "name2");
					secretary["deptname"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "deptname");
					secretary["deptname2"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "deptname");
					secretary["email"][i] = GetAttribute(document.getElementById("ListSecretary").options[i], "email");
				}
				schedule_select_attendant_dialogArguments[0] = secretary;
				schedule_select_attendant_dialogArguments[1] = ModifySecretary_Complete;

				var OpenWin = window.open("/ezSchedule/scheduleSelectAttendant.do?gubun=config&type=executive&cn=" + userid + "&title=" + encodeURI("비서 목록"), "schedule_group_write", GetOpenWindowfeature(980, 670));
				try { OpenWin.focus(); } catch (e) { }
			}

			function ModifySecretary_Complete(rtn) {
				if (typeof (rtn) != "undefined") {
					var length = document.getElementById("ListSecretary").length;
					for (var i = 0; i < length; i++)
						document.getElementById("ListSecretary").options[0] = null;

					for (var i = 0; i < rtn["id"].length; i++) {
						var lastindex = document.getElementById("ListSecretary").length;
						var newoption = new Option(rtn["name"][i], rtn["id"][i]);
						document.getElementById("ListSecretary").options[lastindex] = newoption;
					}
				}
			}
		</script>
	</head>
	<body class="popup" style="font-size:12px">
		<form id="Form1" method="post">
		    <h1>
		    	<c:if test="${cn == ''}"><spring:message code='ezSchedule.lyj02' /></c:if>
		    	<c:if test="${cn != ''}"><spring:message code='ezSchedule.t302' /></c:if>
		    </h1>
		    <div id="close">
	            <ul>
	                <li><span onclick="window.close()"></span></li>
	            </ul>
	        </div>
		    <table class="content">
		    	<tr>
					<th style="width: 80px; text-align:center"><spring:message code='ezSchedule.lyj09' /></th>
					<td>
						<div style="display: flex; align-items: center; width: 100%;">
							<input id="txtuser" type="text" style="flex: 1;margin-right:2px;" onfocus="this.blur();" readonly="readonly">
							<a class="imgbtn imgbck" id="selectBtn"><span onclick="select_person()"><spring:message code='ezSchedule.t1000' /></span></a>
						</div>
					</td>
		        </tr>
		        <tr>
		            <th style="width:200px; text-align:center">
		           		<spring:message code='ezSchedule.t402' />
		            </th>
		            <td>
						<div class='custom_radio'>
							<input id="date" type="radio" name="usage" value="Y" checked style="margin:0px 0px 1px 4px" onClick='showMainPattern(0);' />
							<label for="date"><spring:message code='ezSchedule.t403' /></label>
							<span id="lunarRadio" style="margin-left: 10px;">
								<input id="date2" type="radio" name="usage" value="N" style="margin:0px 0px 1px 4px" onClick='showMainPattern(1);'/>
									<label for="date2"><spring:message code='ezSchedule.t404' /></label>
							</span>
						</div>
		            </td>
		        </tr>
				<tr>
					<th style="width: 80px; text-align:center"><spring:message code='ezSchedule.t152' /></th>
					<td>
						<div style="display: flex; align-items: center; width: 100%;">
						<c:if test="${cn == ''}">
							<select name="ListSecretary" id="ListSecretary" style="flex: 1;margin-right:2px;"></select>
						</c:if>
						<c:if test="${cn != ''}">
							<select name="ListSecretary" id="ListSecretary" style="flex: 1;margin-right:2px;" <c:if test='${selectList eq null || selectList eq "[]"}'> disabled </c:if>>
								<c:forEach var="item" items="${selectList}">
									<option value="${item.cn}" name="${item.displayName}" name2="${item.displayName2}" deptname="${item.description}" deptname2="${item.description2}" email="${item.mail}">
										<c:if test="${lang == 1}">
											${item.displayName}
										</c:if>
										<c:if test="${lang != 1}">
											${item.displayName2}
										</c:if>
									</option>
								</c:forEach>
							</select>
						</c:if>
						<a class="imgbtn imgbck"><span onclick="ModifySecretary()"><spring:message code='ezSchedule.t1000' /></span></a>
						</div>
					</td>
				</tr>
		    </table>
		    <div class="btnpositionNew">
				<a class="imgbtn" id="add"><span onclick="save_settings(1)" ><spring:message code='ezSchedule.t157' /></span></a>
				<a class="imgbtn" id="mod"><span onclick="save_settings(2)" ><spring:message code='ezSchedule.t302' /></span></a>
		    </div>
		</form>
	</body>
</html>

