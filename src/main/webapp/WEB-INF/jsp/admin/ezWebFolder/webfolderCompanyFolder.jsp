<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" >
			<c:set var="isMeeting" value="${subTypeC eq 'meeting'}" />
			<c:set var="isTask" value="${subTypeC eq 'task'}" />
			<c:set var="divHeight" value="${isMeeting or isTask ? 493 : 450}" />
			var arrSubFolder      = [];
			var selectedFolder    = "";
			var primary           = "<c:out value='${primary}'/>";
			var compFolderId      = null;
			var selectXhr         = null;
			/* 팝업공지 대상자 지정 */
			// 2020-12-04 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
			var authListUser			= [];
			var authListManager			= [];
			var selectedLevel    = 0;
			var addUser    = [];
			var deleteUser    = [];
			var addUserManager    = [];
			var deleteUserManager    = [];
			var subFolderType = "0";
			var strictAuthList 		= [];
			var strictAuthListMng 	= [];
			// 2020-12-17 김은실 - (카이스트) 하위권한 체크하는 창을 스킵할 flag.
			var isInsert 		= false;
			
			window.onload = function () {
				closeAllPopup();
				document.onselectstart = function() {return false;}
				getData();
				
				<c:if test="${isMeeting}">
				// datepicker setup ()
				$(".datepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.png",
					buttonImageOnly: true
				});

				$(".datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
				$(".datepicker").datepicker('setDate', "");

				var monthMsg = "<spring:message code='ezSchedule.t110' />";
				var monthStr = monthMsg.split(";");
				var dayMsg = "<spring:message code='ezSchedule.t108' />";
				var dayStr = dayMsg.split(";");

				$.datepicker.regional["<spring:message code='main.t0619' />"] = {
					closeText: "<spring:message code='main.t3' />",
					prevText: "<spring:message code='main.t0604' />",
					nextText: "<spring:message code='main.t0605' />",
					currentText: "<spring:message code='main.t0606' />",
					monthNames: monthStr,
					monthNamesShort: monthStr,
					dayNames: dayStr,
					dayNamesShort: dayStr,
					dayNamesMin: dayStr,
					weekHeader: 'Wk',
					dateFormat: 'yy-mm-dd',
					firstDay: 0,
					isRTL: false,
					duration: 200,
					showAnim: 'show',
					showMonthAfterYear: true
				};

				$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
				</c:if>
			}
			
			window.onbeforeunload = function() {
				closeAllPopup();
			}
			
			function getData() {
				 $.ajax({
					type: "GET",
					url: "/admin/ezWebFolder/getCompanyFolderTree.do",
					data: {
						"companyId" : document.getElementById("companyList").value,
						"folderId"  : selectedFolder,
						"subTypeC"  	: "${subTypeC}"
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								var result = data.companyTree;
								renderData(result);
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
						}
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function renderData(result) {
				var divTree = document.getElementById("folderTree");
				
				while (divTree.hasChildNodes()) {
					divTree.removeChild(divTree.lastChild);
				}
				
				if (!result) {
					//alert("<spring:message code='ezWebFolder.t134'/>");
					return;
				}
				
				var divComp           = document.createElement("div");
				compFolderId          = result["folderId"];
				
				displaySubFolder(divTree, divComp, result);
				
				if (selectedFolder) {
					cancelAdd();
				}
			}
			
			function displaySubFolder(divTree, divElmt, list) {
				var level = list["folderLevel"];
				
				if (level > 0) {
					for (var j = 0; j < level; j++) {
						var imgTag = document.createElement("img");
						imgTag.setAttribute("class", "webfolderImg");
						imgTag.src="/images/OrganTree_cross/dot_continue.gif";
						divElmt.appendChild(imgTag);
					}
				}
				
				var imgElmt = document.createElement("img");
				imgElmt.setAttribute("id" , list["folderId"]);
				
				var imgElmt2 = document.createElement("img");
				imgElmt2.setAttribute("class", "webfolderImg");
				imgElmt2.src = "/images/OrganTree_cross/fldr.gif";
				
				var spanFolderName = document.createElement("span");
				if (list["folderLevel"] == 0) {
					spanFolderName.textContent = primary == "1" ? list["folderName"]+"(" + list["ownerId"]+")" : list["folderName2"]+"(" + list["ownerId"]+")";
				} else {
					spanFolderName.textContent = primary == "1" ? list["folderName"] : list["folderName2"];
				}
				spanFolderName.setAttribute("class", "spanName");
				spanFolderName.setAttribute("name", list["folderId"]);
				spanFolderName.setAttribute("level", list["folderLevel"]);
				spanFolderName.setAttribute("fldName1", list["folderName"]);
				spanFolderName.setAttribute("fldName2", list["folderName2"]);
				spanFolderName.setAttribute("title", primary == "1" ? list["folderName"] : list["folderName2"]);
				spanFolderName.onclick = function() {getSelected(this);};
				
				divElmt.appendChild(imgElmt);
				divElmt.appendChild(imgElmt2);
				divElmt.appendChild(spanFolderName);
				divTree.appendChild(divElmt);
				
				if (list["hasSubFolder"] == "0") {
					imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
					imgElmt.setAttribute("class", "webfolderImg");
				}
				else {
					imgElmt.onclick = function() {getDetailTree(this);};
					
					if (list["listSubFolders"] == null) {
						imgElmt.src = "/images/OrganTree_cross/plus.gif";
						imgElmt.setAttribute("class", "webfolderPlus");
						return;
					}
					
					imgElmt.src = "/images/OrganTree_cross/minus.gif";
					imgElmt.setAttribute("class", "webfolderMinus");
					
					var len = list["listSubFolders"].length;
					arrSubFolder.push(list["folderId"]);
					
					var newDivElmt = document.createElement("div");
					divElmt.appendChild(newDivElmt);
					
					for (var i = 0; i < len; i++) {
						var subDivElmt = document.createElement("div");
						displaySubFolder(newDivElmt, subDivElmt, list["listSubFolders"][i]);
					}
				}
			}
			
			function getSelected(obj) {
				var previousElmt = document.getElementsByName(selectedFolder)[0];
				var level        = obj.getAttribute("level");
				arr = [];
				// 2020-11-24 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				selectedLevel = level;
				// 2020-12-17 김은실 - (카이스트) 하위권한 체크하는 창을 스킵할 flag.
				isInsert 		= false;
				
				if (previousElmt != null) {
					if (previousElmt.getAttribute("name") != obj.getAttribute("name")) {
						previousElmt.style.color      = "";
						previousElmt.style.fontWeight = "normal";
						document.getElementById("listBttn1").style.display = "";
						document.getElementById("listBttn2").style.display = "none";
					}
					else {
						return;
					}
				}
				
				selectedFolder       = obj.getAttribute("name");
				obj.style.color      = "#004a87";
				obj.style.fontWeight = "bold";
				
				if (selectXhr) {
					selectXhr.abort();
				}

				// 선택한 폴더가 최상위 폴더라면 값을 바로 세팅해주고 조기 반환한다.
				// 그래서 최상위폴더는 ajax를 안통하기 때문에 바로바로 반영됨
				// 반면 탑폴더부터는 ajax를 통해서 가져온 후 dom 업데이트를 하기 때문에 느림
				if (compFolderId == selectedFolder) {
					document.getElementById("fldName").readOnly = true;
					document.getElementById("fldName2").readOnly = true;
					document.getElementById("fldName").value  = obj.getAttribute("fldName1");
					document.getElementById("fldName2").value = obj.getAttribute("fldName2");
					document.getElementById("usersSelect").style.display  = "none";
					document.getElementById("displayUsers").style.display = "none";
					// 2020-11-24 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
					document.getElementById("usersSelectManager").style.display  = "none";
					document.getElementById("displayUsersManager").style.display = "none";
					// 회의실 사용 기간
					$(".datepicker").datepicker("disable").attr("disabled", true).val("");
					$("#expiredTip").css("display", "none");
					document.getElementById("rangeStr").value = "";
					updateTarget("");
					authListUser			= [];
					authListManager			= [];
					addUser    = [];
					deleteUser    = [];
					addUserManager    = [];
					deleteUserManager    = [];
					strictAuthList 			= [];
					strictAuthListMng 		= [];
					<c:if test="${isTask}">
					// 업무자료실 폴더 권한 비상속
					document.getElementById("noInherit").checked = false;
					document.getElementById("noInherit").disabled = true;
					</c:if>
					return;
				}
				
				document.getElementById("fldName").readOnly = false;
				document.getElementById("fldName2").readOnly = false;
				
				selectXhr = $.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFolderUsers.do",
					data: {
						"folderId" : selectedFolder,
						"mode"		:"n"
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var code = data.code;
						
						switch(code) {
							case 0:
								document.getElementById("usersSelect").style.display  = (level == 0) ? "none" : "inline-block";
								document.getElementById("displayUsers").style.display = (level == 0) ? "none" : "inline-block";
								document.getElementById("usersSelectManager").style.display  = (level != 1) ? "none" : "";
								document.getElementById("displayUsersManager").style.display = (level == 0) ? "none" : "inline-block";
								document.getElementById("newTargetDivManager").parentNode.style.background = (level > 1) ? "#f6f6f6" : "";
								<c:if test="${isMeeting}">
								// 회의실 사용기간
								if (level > 1) {
									$(".datepicker").datepicker("disable").attr("disabled", true);
								} else {
									$(".datepicker").datepicker("enable").removeAttr("disabled");
								}
								var startDate = new Date(data.meetingStartDate);
								var endDate = new Date(data.meetingEndDate);
								$("#date1").datepicker("setDate", startDate);
								$("#date2").datepicker("setDate", endDate);
								
								var isExpired = new Date().toISOString().substr(0, 10) > endDate.toISOString().substr(0, 10);
								document.getElementById("expiredTip").style.display = isExpired ? "" : "none";
								</c:if>
								<c:if test="${isTask}">
								// 업무자료실 폴더 권한 비상속
								document.getElementById("noInherit").checked = data.isNotInherit;
								document.getElementById("noInherit").disabled = level > 1;
								</c:if>
								processUsersList(data, obj.getAttribute("fldName1"), obj.getAttribute("fldName2"));
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
						}
					},
					error : function(error) {
						if (error.statusText == "abort") {
							return;
						}

						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					},
					complete: function() {
						selectXhr = null;
					}
				});
			}
			
			function processUsersList(result, folderName, folderName2) {
				document.getElementById("fldName").value  = folderName;
				document.getElementById("fldName2").value = folderName2;
				
				var folderUsers = result.folderUsers;
				// 2020-12-04 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				authListUser			= [];
				authListManager			= [];
				addUser    = [];
				deleteUser    = [];
				addUserManager    = [];
				deleteUserManager    = [];
				
				for (var i = 0; i < folderUsers.length ; i++) {
					var auth         		= {};
					auth["userId"]   		= folderUsers[i]["userId"];
					auth["userName"] 		= primary == '1' ? folderUsers[i]["displayName1"] : folderUsers[i]["displayName2"];
					auth["userType"]   		= folderUsers[i]["userType"];
					auth["subdeptPermitted"]= folderUsers[i]["subdeptPermitted"];
					auth["sn"] 		 		= i;
					auth["folderManager"]	= folderUsers[i]["folderManager"];
					auth["displayDeptName"] = primary == '1' ? folderUsers[i]["displayDeptName1"] : folderUsers[i]["displayDeptName2"];
					auth["folderManager"]? authListManager.push(auth) : authListUser.push(auth);
				}
				strictAuthList 		= authListUser;
				strictAuthListMng 	= authListManager;
				
				var target    = "";
				var targetManager = "";
				var jsonObj   = {};
				var deptArray = [];
				var userArray = [];
				var managerArray = [];
				
				for (var i = 0; i < folderUsers.length; i++) {
					// 2020-11-26 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
					var displayName 	= primary == '1' ? folderUsers[i]["displayName1"] 	  : folderUsers[i]["displayName2"];
					
					if (folderUsers[i]["userType"].toLowerCase() == "user") {
						var userJson         = {};
						userJson["userId"]   = folderUsers[i]["userId"];
						userJson["userName"] = displayName;
						folderUsers[i]["folderManager"]? managerArray.push(userJson) : userArray.push(userJson);
					//	var displayDeptName = primary == '1' ? folderUsers[i]["displayDeptName1"] : folderUsers[i]["displayDeptName2"];
					//	displayName = displayName + "(" + displayDeptName + ")";
					}
					else {
						var deptJson         = {};
						deptJson["deptId"]   = folderUsers[i]["userId"];
						deptJson["deptName"] = displayName;
						deptArray.push(deptJson);
					}
					
					folderUsers[i]["folderManager"]? targetManager = targetManager + displayName + "," 
													 : target	   = target 	   + displayName + ",";
				}
				
				jsonObj["manager"] = managerArray;
				jsonObj["user"] = userArray;
				jsonObj["dept"] = deptArray;
				
				updateTarget(targetManager.slice(0, -1), 1);
				updateTarget(target.slice(0, -1), 0);
				document.getElementById("rangeStr").value = JSON.stringify(jsonObj);
				
			}
			
			function getDetailTree(obj) {
				//Check if already in arrSubFolder
				var uniqueId = obj.getAttribute("id");
				
				if (arrSubFolder.indexOf(uniqueId) != -1) {
					var childElmt = obj.parentElement.lastElementChild;
					
					if (obj.className == "webfolderMinus") {
						obj.src= "/images/OrganTree_cross/plus.gif";
						obj.setAttribute("class", "webfolderPlus");
						childElmt.style.display = "none";
					}
					else {
						obj.src= "/images/OrganTree_cross/minus.gif";
						obj.setAttribute("class", "webfolderMinus");
						childElmt.style.display = "";
					}
				}
				else {
					obj.src = "/images/OrganTree_cross/minus.gif";
					obj.setAttribute("class", "webfolderMinus");
					
					$.ajax({
						type: "GET",
						url: "/admin/ezWebFolder/getSubFolderTree.do",
						data: {
							"folderId" : uniqueId,
							"adminCheck" : "admin"
						},
						dataType: "JSON",
						async: true,
						success: function(data) {
							var code = data.code;
							
							switch(code) {
								case 0: 
									var result = data.subTree;
									displaySubTree(result, obj.parentElement);
									arrSubFolder.push(uniqueId);
									break;
								case 1:
									alert("<spring:message code='ezWebFolder.t306'/>");
									break;
								case 2:
									alert("<spring:message code='ezWebFolder.t305'/>");
									break;
								case 3:
									alert("<spring:message code='ezWebFolder.t300' />");
									break;
							}
						},
						error: function (xhr, status, e){
							alert("<spring:message code='ezWebFolder.t134'/>");
						}
					});	
				}
			}
			
			function displaySubTree(result, divElmt) {
				if (result["listSubFolders"] == null) {
					alert("<spring:message code='ezWebFolder.t134'/>");
					return;
				}
				
				var len = result["listSubFolders"].length;
				var newDivElmt = document.createElement("div");
				divElmt.appendChild(newDivElmt);
				
				for (var i = 0; i < len; i++) {
					var subDiv = document.createElement("div");
					displaySubFolder(newDivElmt, subDiv, result["listSubFolders"][i]);
				}
			}
			
			function getUsersPage(folderManager) {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				// 2020-11-26 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				menu_SelectRange(document.getElementById("companyList").value, folderManager);
			}
			
			function newFolder() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				// 2020-11-26 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				document.getElementById("displayUsersManager").style.display = "inline-block";
 				document.getElementById("displayUsers").style.display = "inline-block";
				document.getElementById("usersSelectManager").style.display  = (compFolderId == selectedFolder) ? "inline-block"      : "none";
				document.getElementById("usersSelect").style.display  = "";
				document.getElementById("newTargetDivManager").parentNode.style.background = (compFolderId == selectedFolder) ? "" 	  : "#f6f6f6";

				document.getElementById("listBttn1").style.display    = "none";
				document.getElementById("listBttn2").style.display    = "";
				document.getElementById("fldName").value              = "";
				document.getElementById("fldName2").value             = "";
				document.getElementById("rangeStr").value             = "";
				document.getElementById("fldName").readOnly = false;
				document.getElementById("fldName2").readOnly = false;
				// 2020-12-07 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				selectedLevel = Number(selectedLevel) + 1;
				$("#expiredTip").css("display", "none");
				if (compFolderId == selectedFolder) {
					updateTarget("");
					$(".datepicker").datepicker("enable").removeAttr("disabled");
				} else {
					$(".datepicker").datepicker("disable").attr("disabled", true);
				}

				<c:if test="${isTask}">
				// 업무자료실 폴더 권한 비상속
				// document.getElementById("noInherit").checked = false;
				document.getElementById("noInherit").disabled = compFolderId != selectedFolder;
				</c:if>
				// 2020-12-17 김은실 - (카이스트) 하위권한 체크하는 창을 스킵할 flag.
				isInsert = true;
			}
			
			function cancelAdd() {
				refreshView();
				document.getElementById("listBttn1").style.display = "";
				document.getElementById("listBttn2").style.display = "none";
			}
			
			function saveNewFolder() {
				var folderName  = document.getElementById("fldName").value;
				var folderName2 = document.getElementById("fldName2").value;
				var folderUsers = getJsonData(document.getElementById("rangeStr").value);
				var target      = document.getElementById("newTargetDiv").innerHTML;
				
				if (!folderName.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName").value = "";
					document.getElementById("fldName").focus;
					return;
				}
				
				if (!folderName2.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName2").value = "";
					document.getElementById("fldName2").focus;
					return;
				}
				
				if (isValidName(folderName) || isValidName(folderName2)) {
					alert('<spring:message code="ezWebFolder.t211"/>');
					return;
				}
				
				if (compFolderId == selectedFolder && !target.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t202'/>");
					return;
				}

				<c:if test="${isMeeting}">
				// 중복코드입니다
				// 회의실 사용 기간
				function getDate(selector) {
					try {
						return $.datepicker.parseDate($(selector).datepicker('option', 'dateFormat'), $(selector).val()).getTime();
					} catch (ignore) {
						return false;
					}
				}
				
				var startTime = "", endTime = "";
				
				if (compFolderId == selectedFolder) {
					startTime = getDate("#date1");
					endTime = getDate("#date2");
					
					if (!startTime) {
						alert("<spring:message code='webfolder.meeting.period.err.start'/>");
						$("#date1").datepicker("show");
						return;
					}
					
					if (!endTime) {
						alert("<spring:message code='webfolder.meeting.period.err.end'/>");
						$("#date2").datepicker("show");
						return;
					}
					
					if (startTime > endTime) {
						alert("<spring:message code='webfolder.meeting.period.err.early'/>");
						$("#date1").datepicker("show");
						return;
					}
				}
				</c:if>
				// 2020-12-04 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				var strAuthListManager = (typeof authListManager == "string")? authListManager : JSON.stringify(authListManager);
				var strAuthListUser = (typeof authListUser == "string")? authListUser : JSON.stringify(authListUser);
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/addCompanyFolder.do",
					data: {
						"folderId"    : selectedFolder,
						"folderUsers" : selectedLevel == 1? strAuthListManager.substring(0,strAuthListManager.length-1) + "," + strAuthListUser.substring(1) : strAuthListUser,
						"folderName"  : folderName,
						"folderName2" : folderName2,
						"subTypeC" 	  : "${subTypeC}"
						<c:if test="${isTask}">
						// 업무자료실 폴더 권한 비상속
						,"noInherit" : document.getElementById("noInherit").checked
						</c:if>
						<c:if test="${isMeeting}">
						// 회의실 사용 기간
						,"startTime" : startTime
						,"endTime" : endTime
						</c:if>
					},
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								refreshView2();
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
							case 8:
								alert(messages.resultErrDuplicateCreate);
								break;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function isValidName(str) {
				var regex = /[*:"\\|<>\/?]/g;
				return regex.test(str);
			}
			
			function refreshView() {
				var spanElmt   = document.getElementsByName(selectedFolder)[0];
				selectedFolder = "";
				
				if (spanElmt) {
					getSelected(spanElmt);
				}
			}
			
			function refreshView2() {
				arrSubFolder = [];
				getData();
			}
			
			function refreshViewAfterUpdate() {
				change();
				document.getElementById("fldName").value  = "";
				document.getElementById("fldName2").value = "";
				document.getElementById("rangeStr").value = "";
				updateTarget("");
			}
			
			function saveChanges() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				if (compFolderId == selectedFolder) {
					alert("<spring:message code='ezWebFolder.t203'/>");
					return;
				}
				
				var folderName  = document.getElementById("fldName").value;
				var folderName2 = document.getElementById("fldName2").value;
				var folderUsers = getJsonData(document.getElementById("rangeStr").value);
				var target      = document.getElementById("newTargetDiv").innerHTML;
				
				if (isValidName(folderName) || isValidName(folderName2)) {
					alert('<spring:message code="ezWebFolder.t211"/>');
					return;
				}
				
				if (!folderName.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName").value = "";
					document.getElementById("fldName").focus;
					return;
				}
				
				if (!folderName2.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t201'/>");
					document.getElementById("fldName2").value = "";
					document.getElementById("fldName2").focus;
					return;
				}
				
				<c:if test="${isMeeting}">
				// 회의실 사용 기간
				function getDate(selector) {
					try {
						return $.datepicker.parseDate($(selector).datepicker('option', 'dateFormat'), $(selector).val()).getTime();
					} catch (ignore) {
						return false;
					}
				}
				
				var startTime = "", endTime = "";
				
				if (selectedLevel == 1) {
					startTime = getDate("#date1");
					endTime = getDate("#date2");
					
					if (!startTime) {
						alert("<spring:message code='webfolder.meeting.period.err.start'/>");
						$("#date1").datepicker("show");
						return;
					}
					
					if (!endTime) {
						alert("<spring:message code='webfolder.meeting.period.err.end'/>");
						$("#date2").datepicker("show");
						return;
					}
					
					if (startTime > endTime) {
						alert("<spring:message code='webfolder.meeting.period.err.early'/>");
						$("#date1").datepicker("show");
						return;
					}
				}
				</c:if>
				
				/* 조직도에 아무도 선택하지 않고 저장할 수 있도록 주석처리
				if (!target.replace(/\s/g,'')) {
					alert("<spring:message code='ezWebFolder.t202'/>");
					return;
				}
				*/

				// 2020-12-04 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
				var strAuthListManager = (typeof authListManager == "string")? authListManager : JSON.stringify(authListManager);
				var strAuthListUser = (typeof authListUser == "string")? authListUser : JSON.stringify(authListUser);
				var ajaxData = {
						"folderId"    : selectedFolder,
						"folderUsers" : selectedLevel == 1? strAuthListManager.substring(0,strAuthListManager.length-1) + "," + strAuthListUser.substring(1) : strAuthListUser,
						"folderName"  : folderName,
						"folderName2" : folderName2,
						"addUser" 		: convertJSONToJSONStr(addUser),
						"deleteUser" 	: convertJSONToJSONStr(deleteUser),
						"addUserManager" 		: convertJSONToJSONStr(addUserManager),
						"deleteUserManager" 	: convertJSONToJSONStr(deleteUserManager),
						"subFolderType"	: subFolderType
						<c:if test="${isTask}">
						// 업무자료실 폴더 권한 비상속
						,"noInherit" : document.getElementById("noInherit").checked
						</c:if>
						<c:if test="${isMeeting}">
						// 회의실 사용 기간
						,"startTime" : startTime
						,"endTime" : endTime
						</c:if>
					};

				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/changeCompanyFolder.do",
					data: ajaxData,
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								alert("<spring:message code='ezWebFolder.t182'/>");
								refreshView2();
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
							case 8:
								alert(messages.resultErrDuplicateRename);
								break;
							case 20001129:
								alert("<spring:message code='webfolder.meeting.period.err'/>");
								break;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function moveFolder() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				if (compFolderId == selectedFolder) {
					alert("<spring:message code='ezWebFolder.t203'/>");
					return;
				}
				
				leftPanelProcess();
				// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: isDean으로 구분 추가
				// 2020-11-25 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: subTypeC으로 구분 수정
				DivPopUpShow(450, 500, "/admin/ezWebFolder/folderMoveConfirm.do?folderId=" + selectedFolder + "&subTypeC=${subTypeC}");
			}
			
			function leftPanelProcess() {
				document.getElementById("folderTree").style.overflow = "hidden";
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "";
			}
			
			function deleteFolder() {
				if (!selectedFolder) {
					alert("<spring:message code='ezWebFolder.t181'/>");
					return;
				}
				
				if (compFolderId == selectedFolder) {
					alert("<spring:message code='ezWebFolder.t203'/>");
					return;
				}
				
				leftPanelProcess();
				// 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: isDean으로 구분 추가
				// 2020-11-25 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: subTypeC으로 구분 수정
				DivPopUpShow(450, 250, "/admin/ezWebFolder/deleteFolderConfirm.do?folderId=" + selectedFolder + "&subTypeC=${subTypeC}");
			}
			
			function change() {
				document.getElementById("listBttn1").style.display = "";
				document.getElementById("listBttn2").style.display = "none";
				selectedFolder = "";
				arrSubFolder   = [];
				getData();
			}
			
			function newCompanyFolder() {
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/makeCompanyFolder.do",
					data: {
						"companyId" : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: false,
					success: function(data) {
						var code = data.code;
						
						switch(code) {
							case 0: 
								refreshViewAfterUpdate();
								break;
							case 1:
								alert("<spring:message code='ezWebFolder.t306'/>");
								break;
							case 2:
								alert("<spring:message code='ezWebFolder.t305'/>");
								break;
							case 3:
								alert("<spring:message code='ezWebFolder.t300' />");
								break;
						}
					},
					error: function (xhr, status, e){
						alert("<spring:message code='ezWebFolder.t134'/>");
					}
				});
			}
			
			function closeAllPopup() {
				document.getElementById("folderTree").style.overflow = "auto";
				window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
				DivPopUpHidden();
			}
			
			function convertJSONToJSONStr(obj) {
				var returnStr = obj;
				if (typeof returnStr != "string") {
					var tmp = obj.length == 0 ? [] : obj;
					returnStr = JSON.stringify(tmp);
				}
				
				return returnStr;
			}
		</script>
	</head>
	<body class="mainbody">
		<%-- 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: isDean으로 구분 추가 --%>
		<%-- 2020-11-25 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: subTypeC으로 구분 수정 --%>
		<h1>
			<c:if test="${subTypeC eq 'task'}">
				<spring:message code='ezWebFolder.kes008' />
			</c:if>
			<c:if test="${subTypeC eq 'meeting'}">
				<spring:message code='ezWebFolder.t126' />
			</c:if>
			<c:if test="${subTypeC eq 'dean'}">
				<spring:message code='ezWebFolder.kes009' />
			</c:if>
		</h1>
		<div style="margin-left:5px">
			<div id="companySelect" style="margin: 10px 0px;">
				<span style="font-size: 12px; display: inline-block; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
				<select id="companyList" style="font-size: 12px; height: 20px; display:inline-block;" onchange="change();">
					<c:forEach var="item" items="${list}">
						<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
					</c:forEach>
				</select>
			</div>
			
			<div style="height: ${divHeight}px; width: 100%;">
				<table style="border-collapse: collapse; width: 100%;">
					<tr>
						<td style="width: 350px; min-width: 350px;">
							<div id="folderTree" style="width: 350px; height: ${divHeight}px; border: 1px solid #ddd; overflow: auto; white-space: nowrap; padding: 5px 0px 0px 5px;"></div>
						</td>
						<td>
							<div style="width: 500px; height: ${divHeight}px; border: 1px solid #ddd; margin-left: 10px; padding: 3px;">
								<table style="width: 100%;">
									<tr>
										<td>
											<div style="margin: 20px 20px 5px 20px;">
												<img src="/images/kr/left/left_dot02.gif" />
												<span class="wfAdmin_t1" style="display:inline-block;"><spring:message code='ezWebFolder.t226'/></span>
												<input id="fldName" type="text" maxlength="50" style="width: 210px; margin-left: 2px; padding-left: 5px;">
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="margin: 5px 20px 10px 20px;">
												<img src="/images/kr/left/left_dot02.gif" />
												<span class="wfAdmin_t1" style="display:inline-block;"><spring:message code='ezWebFolder.t227'/></span>
												<input id="fldName2" type="text" maxlength="50" style="width: 210px; margin-left: 2px; padding-left: 5px;">
											</div>
										</td>
									</tr>								
									<c:if test="${isTask}">
									<tr>
										<td>
											<div style="margin: 5px 20px 10px 20px;position:relative;">
												<img src="/images/kr/left/left_dot02.gif" />
												<span style="display:inline-block; width:110px;"><spring:message code='webfolder.admin.noinherit'/></span>
												<input id="noInherit" type="checkbox" style=" border: 1px solid #ddd; vertical-align: middle;">
												<span id="noInheritDescription" style="display:inline-block; color:grey"></span>
											</div>
										</td>
									</tr>
									</c:if>
									<c:if test="${isMeeting}">
									<tr>
										<td>
											<div style="margin: 5px 20px 10px 20px;position:relative;">
												<div style="display: inline-block;" id="displayPeriod">
													<img src="/images/kr/left/left_dot02.gif" />
													<span class="wfAdmin_t1" style="display:inline-block;"><spring:message code="webfolder.meeting.period" /></span>
													<input id="date1" class="datepicker" type="text" style="width: 80px;text-align:center;margin-left: 2px;" readonly>
													<span style="padding: 0px 5px;">~</span>
													<input id="date2" class="datepicker" type="text" style="width: 80px;text-align:center;" readonly>
													<span id="expiredTip" style="display:none;position:absolute;color:red;left:100px;top:28px;"><spring:message code="webfolder.meeting.expired.noti" /></span>
												</div>
											</div>
										</td>
									</tr>
									</c:if>
									<%-- 2020-11-24 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 --%>
									<tr>
										<td>
											<div style="margin: 20px 20px 5px; min-height: 36px;">
												<div class="wfAdmin_t2" style="display: inline-block;" id= "displayUsersManager">
													<img src="/images/kr/left/left_dot02.gif" />
													<span id=""><spring:message code="ezWebFolder.kes012" /></span>&nbsp;
												</div>
												<a class="webfolderBttn2"><span onclick="getUsersPage(1);" id="usersSelectManager"><spring:message code='ezWebFolder.t205'/></span></a>											
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="margin: 0px 20px; min-height: 10px; border:1px solid #ddd; padding:10px; border-radius:3px;" >
												<span id="newTargetDivManager"></span>
											</div>
										</td>
									</tr>
									<%-- (기존)구성원 영역 --%>
									<tr>
										<td>
											<div style="margin: 20px 20px 5px; min-height: 36px;">
												<div class="wfAdmin_t2" style="display: inline-block;" id= "displayUsers">
													<img src="/images/kr/left/left_dot02.gif" />
													<span id=""><spring:message code='ezWebFolder.t204'/></span>&nbsp;
												</div>
												<a class="webfolderBttn2"><span onclick="getUsersPage(0);" id="usersSelect"><spring:message code='ezWebFolder.t205'/></span></a>											
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div style="margin: 0px 20px 20px; min-height: 120px; border:1px solid #ddd; padding:10px; border-radius:3px" >
												<span id="newTargetDiv"></span>
											</div>
										</td>
									</tr>
									
									<tr>
										<td>
											<div style="text-align:center;" id="listBttn1">
												<a class="webfolderBttn"><span onclick="saveChanges();" ><spring:message code='ezWebFolder.t133'/></span></a>
												<a class="webfolderBttn"><span onclick="newFolder();"   ><spring:message code='ezWebFolder.t206'/></span></a>
												<%-- 2020-10-07 김은실 - (카이스트)커스터 마이징 메뉴: isDean으로 구분 추가 --%>
												<%-- 2020-11-25 김은실 - (카이스트)회사 폴더별 관리자 지원 기능: subTypeC으로 구분 수정 --%>
												<a class="webfolderBttn"><span onclick="moveFolder('${subTypeC}');"  ><spring:message code='ezWebFolder.t251'/></span></a>
												<a class="webfolderBttn"><span onclick="deleteFolder();"><spring:message code='ezWebFolder.t111'/></span></a>
											</div>
											<div style="text-align:center; display: none;" id="listBttn2">
												<a class="webfolderBttn"><span onclick="saveNewFolder();"><spring:message code='ezWebFolder.t133'/></span></a>
												<a class="webfolderBttn"><span onclick="cancelAdd();"    ><spring:message code='ezWebFolder.t112'/></span></a>
											</div>
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</table>
			</div>
		</div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		
		<input type="text" name="rangeStr" id="rangeStr" style="display:none">
		<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
	</body>
</html>
