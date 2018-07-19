<%@ page language="java"   contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t04"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
		<link rel="stylesheet" href="/css/Tab.css"                           type="text/css">
	</head>
	<body class="popup cabShareFile">
		<h1><spring:message code="ezCabinet.t04"/></h1>
		
		<table style="width:100%;">
			<tr>
				<td>
					<table id="TreeViewTD">
						<tr>
							<!-- left -->
							<td>
								<table class="cabShareInf">
									<tr>
										<th><spring:message code="ezCabinet.t95"/></th>
										<td><c:out value='${cabinet.cabinetName}'/></td>
									</tr>
								</table>
								
								<!-- 검색 -->
								<div class="cabShareSearPanel">
									<div class="cabShareSearPanelSub">
										<table class="cabShareSearTbl">
											<tr>
												<td>
													<div>
														<select id="searchType">
															<option selected value="displayname"              ><spring:message code="ezCabinet.t18" /></option>
															<option          value="cn"                       ><spring:message code="ezCabinet.t96" /></option>
															<option          value="description"              ><spring:message code="ezCabinet.t19" /></option>
															<option          value="title"                    ><spring:message code="ezCabinet.t97" /></option>
															<option          value="telephonenumber"          ><spring:message code="ezCabinet.t98" /></option>
															<option          value="mobile"                   ><spring:message code="ezCabinet.t99" /></option>
															<option          value="homePhone"                ><spring:message code="ezCabinet.t100"/></option>
															<option          value="facsimileTelephoneNumber" ><spring:message code="ezCabinet.t101"/></option>
															<option          value="mail"                     ><spring:message code="ezCabinet.t102"/></option>
															<option          value="streetAddress"            ><spring:message code="ezCabinet.t107"/></option>
														</select>
														<input type="text" id="keyword">
														<a class="imgbtn" id="searchBtn"><span><spring:message code='ezCabinet.t49'/></span></a>
													</div>
												</td>
												<td>
													<div>
														<a class="imgbtn" id="addDeptBttn"><span><spring:message code='ezCabinet.t128'/></span></a>
														<a class="imgbtn" id="userInfBttn"><span><spring:message code='ezCabinet.t129'/></span></a>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
									
								<!-- 조직도 -->
								<table class="cabOrganTbl">
									<tr>
										<td class="box">
											<div id="treeView" class="bnkOrgTree"></div>
										</td>
										<td class="listview" style="width: 440px" id="orglistView">
											<!-- 부서 정보 -->
											<table style="margin-top: -1px;" class="cabOrganDeptTbl">
												<tr>
													<th>
														<span class="selectDeptNm">
															<img src="/images/OrganTree_cross/ic-open.gif"><span id="searchResult"></span><span id="memberCount"></span>
														</span>
														<span>
															<span id="txtSpanView"><img ${listType == 'TXT' ? "src='/images/kr/cm/btn_onlist.gif' role='on'"    : "src='/images/kr/cm/btn_list.gif' role='off'"   } class="icon_btn" id="txtlist"></span>
															<span id="imgSpanView"><img ${listType == 'IMG' ? "src='/images/kr/cm/btn_onimglist.gif' role='on'" : "src='/images/kr/cm/btn_imglist.gif' role='off'"} class="icon_btn" id="imglist"></span>
														</span>
													</th>
												</tr>	
											</table>
											
											<div id="txtlist_Layer" class="cabOrganTextListDiv">
												<table id="shareTable" class="organCabTbl">
 													<tr class="trCabTxt">
														<td><spring:message code="ezCabinet.t18" /></td>
														<td><spring:message code="ezCabinet.t97" /></td>
														<td><spring:message code="ezCabinet.t98" /></td>
													</tr>
												</table>
											</div>
											<div id="tblPageRayer" class="cabOrganPageDiv"></div>
										</td>
									</tr>
								</table>
							</td>
								
							<!-- shareBttn -->
							<td class="cabShareBttn">
								<img id="addBttn"    src="/images/kr/cm/arr_right.gif">
								<img id="removeBttn" src="/images/kr/cm/arr_left.gif" >
							</td>
							
							<!-- right -->
							<td>
								<h2 class="receiver_tltype01">
									<span style="min-width: 45px;"><spring:message code="ezCabinet.t130" /></span>
								</h2>
								
								<div class="cabShareSearPanel">
									<div class="cabShareSearPanelSub">
										<table class="cabShareSearTbl">
											<tr>
												<td>
													<div>
														<select id="searchType2">
															<option selected value="displayname"              ><spring:message code="ezCabinet.t18" /></option>
															<option          value="cn"                       ><spring:message code="ezCabinet.t96" /></option>
															<option          value="description"              ><spring:message code="ezCabinet.t19" /></option>
															<option          value="title"                    ><spring:message code="ezCabinet.t97" /></option>
															<option          value="telephonenumber"          ><spring:message code="ezCabinet.t98" /></option>
															<option          value="mobile"                   ><spring:message code="ezCabinet.t99" /></option>
															<option          value="homePhone"                ><spring:message code="ezCabinet.t100"/></option>
															<option          value="facsimileTelephoneNumber" ><spring:message code="ezCabinet.t101"/></option>
															<option          value="mail"                     ><spring:message code="ezCabinet.t102"/></option>
															<option          value="streetAddress"            ><spring:message code="ezCabinet.t107"/></option>
														</select>
														<input type="text" id="keyword2">
														<a class="imgbtn" id="searchBtn2"><span><spring:message code='ezCabinet.t49'/></span></a>
													</div>
												</td>
											</tr>
										</table>
									</div>
								</div>
									
								<div class="cabShareListDiv">
									<div>
										<table id="sharedTable" class="mainlist">
											<tr>
												<td><spring:message code='ezCabinet.t103'/></td>
												<td><spring:message code='ezCabinet.t104'/></td>
												<td><spring:message code='ezCabinet.t105'/></td>
												<td><spring:message code='ezCabinet.t106'/></td>
											</tr>
										</table>
									</div>
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		
		<div class="btnposition" id="cabShareBttn">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTree.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetNavi.js"           ></script>
		<script type="text/javascript" src="/js/ezCabinet/cabinetTable.js"          ></script>
		<script type="text/javascript">
			var cabinetId  = "<c:out value='${cabinetId}'/>";
			
			(function() {
				var companyTree  = new CabinetTree();
				var searchOpt    = "";
				var searchValue  = "";
				var deptId       = "";
				var searchMode   = "normal";
				var cabinetNavi  = null;
				var searchOpt2   = "";
				var searchValue2 = "";
				var userPopup    = null;
				
				var userTable = new CabinetTable({
					normal   : "bnkCabNormal2",
					selected : "bnkCabSelect2",
					mode     : "normal",
					render   : processUserList
				});
				
				var selectedUsers = new CabinetTable({
					normal   : "bnkCabNormal",
					selected : "bnkCabSelect",
					mode     : "received",
					dblclick : removeUser
				});
				
				initEvents();
				
				function initEvents() {
					document.onselectstart  = function () { return false;};
					window.addEventListener("beforeunload", function(e) {closeAllPopUp();}, false);
					
					//Cabinet navigation
					var naviMessages = {
						next     : CabinetMessages.strNext,
						previous : CabinetMessages.strPrev,
						item     : CabinetMessages.strItem,
						total    : CabinetMessages.strTotal
					};
					
					cabinetNavi = new CabinetNavi({
						messages : naviMessages,
						divId    : "tblPageRayer",
						divClass : "cabpagenavi",
						callback : getUsers
					});
					
					var cabShareBttnElmt    = document.getElementById("cabShareBttn");
					var listBttns           = cabShareBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveShareUsers();};
					listBttns[1].onclick    = function(e) {closeWindow();};
					document.getElementById("txtSpanView").addEventListener("click", function(e) {changeListView('TXT');}, false);
					document.getElementById("imgSpanView").addEventListener("click", function(e) {changeListView('IMG');}, false);
					document.getElementById("addBttn").addEventListener("click", function(e) {addUsers();}, false);
					document.getElementById("removeBttn").addEventListener("click", function(e) {removeUsers();}, false);
					document.getElementById("searchBtn").addEventListener("click", function(e) {searchUserList();}, false);
					document.getElementById("addDeptBttn").addEventListener("click", function(e) {addDeptToShareList();}, false);
					document.getElementById("userInfBttn").addEventListener("click", function(e) {viewUserInfo();}, false);
					
					var sSearchInputElmt   = document.getElementById("keyword");
					sSearchInputElmt.addEventListener("keypress", function(e) {onStartSimpleSearch(e);}, false);
					sSearchInputElmt.addEventListener("mousedown", function(e) {clearKeyword(this);}, false);
					
					//Set Company Tree
					companyTree.setTreeInfo({
						treeId     : "treeView",
						treeType   : "organ",
						type       : "normal",
						initialUrl : "/ezCabinet/getCompanyTree.do",
						extendUrl  : "/ezCabinet/getSubNodes.do",
						click      : getSelectedList,
						dblClick   : null,
						companyId  : ""
					});
					
					companyTree.makeTree();
					
					//Set file tables 
					userTable.setTableType("files");
					userTable.setTableElement("shareTable", "id");
					
					//Set selected tables 
					selectedUsers.setTableElement("sharedTable", "id");
					
					getShareList();
				}
				
				function getSelectedList(node) {
					deptId     = node.getAttribute("role");
					document.getElementById("searchResult").textContent = node.textContent;
					searchMode = "normal";
					getUsers("1");
				}
				
				function getUsers(page) {
					var url  = "";
					var data = {};
					
					switch(searchMode) {
						case "normal" : url = "/ezCabinet/getDeptMembers.do";
									data = {deptId : deptId, currentPage : page};
									break;
						case "search" : url = "/ezCabinet/getSearchMember.do";
									data = {srchOption : searchOpt, srchValue : searchValue, currentPage : page};
									break;
					}
					
					$.ajax({
						type: "POST",
						url: url,
						data: data,
						dataType: "JSON",
						async: true,
						success : function(data) {
							var result = data.memberList;
							cabinetNavi.init(data.currentPage, data.memberCount, data.totalPages);
							document.getElementById("memberCount").innerHTML = " - [" + "<span class='cabColor'>" + data.memberCount + "명" + "</span>" + "]";
							userTable.setDataSource(result);
							userTable.renderTable();
						},
						error : function(error) {
						}
					});
				}
				
				function processUserList(result, unselectClass, tableList, clickRow) {
					var txtSpanView     = document.getElementById("txtlist").getAttribute("role");
					tableList.className = txtSpanView == "on" ? "mainlist" : "organCabTbl";
					
					if(result == null || result.length == 0) {
						var trElmt = document.createElement("tr");
						var tdElmt = document.createElement("td");
						
						trElmt.appendChild(tdElmt);
						tableList.appendChild(trElmt);
					}
					else {
						for(var i = 0, len = result.length; i < len ; i++) {
							var trElmt  = document.createElement("tr");
							var tdElmt1 = document.createElement("td");
							var tdElmt2 = document.createElement("td");
							var tdElmt3 = document.createElement("td");
							var tdElmt4 = document.createElement("td");
							
							tdElmt1.textContent = result[i]["userName"];
							tdElmt2.textContent = result[i]["position"];
							tdElmt3.textContent = result[i]["telNumber"];
							
							tdElmt1.className   = "txtCabTd";
							tdElmt2.className   = "txtCabTd";
							tdElmt3.className   = "txtCabTd";
							
							//Process td4
							var divElemt  = document.createElement("div");
							var divChild1 = document.createElement("div");
							var divChild2 = document.createElement("div");
							
							//Process divChild1
							var divInner = document.createElement("div");
							divInner.className = "pic";
							if (result[i]["userImg"]) {
								var imgElmt = document.createElement("img");
								imgElmt.src = result[i]["userImg"];
								divInner.appendChild(imgElmt);
							}
							
							divChild1.appendChild(divInner);
							
							//Process DivChild2
							var innerTable = document.createElement("table");
							innerTable.className = "organinfo";
							var innderTr1  = document.createElement("tr");
							var innderTr2  = document.createElement("tr");
							var innderTr3  = document.createElement("tr");
							var innderTr4  = document.createElement("tr");
							
							var innerTd1   = document.createElement("td");
							var innerTd2   = document.createElement("td");
							var innerTd3   = document.createElement("td");
							var innerTd4   = document.createElement("td");
							
							innerTd1.className = "name cUserInfor";
							innerTd2.className = "cUserInfor";
							innerTd3.className = "cUserInfor";
							innerTd4.className = "cUserInfor";
							
							innerTd1.textContent = result[i]["position"] ? result[i]["userName"] +  "[" + result[i]["position"] + "]" : result[i]["userName"];
							innerTd2.textContent = result[i]["deptName"];
							innerTd3.innerHTML   = "<img class='icon' src='/images/OrganTree/icon_hp.gif'>"   + result[i]["telNumber"];
							innerTd4.innerHTML   = "<img class='icon' src='/images/OrganTree/icon_mail.gif'>" + result[i]["mail"];
							
							innderTr1.appendChild(innerTd1);
							innderTr2.appendChild(innerTd2);
							innderTr3.appendChild(innerTd3);
							innderTr4.appendChild(innerTd4);
							innerTable.appendChild(innderTr1);
							innerTable.appendChild(innderTr2);
							innerTable.appendChild(innderTr3);
							innerTable.appendChild(innderTr4);
							divChild2.appendChild(innerTable);
							
							divElemt.appendChild(divChild1);
							divElemt.appendChild(divChild2);
							
							divElemt.className = "imgCabDivMain";
							tdElmt4.className  = "imgCabTd";
							tdElmt4.appendChild(divElemt);
							
							trElmt.appendChild(tdElmt1);
							trElmt.appendChild(tdElmt2);
							trElmt.appendChild(tdElmt3);
							trElmt.appendChild(tdElmt4);
							trElmt.className = unselectClass;
							trElmt.setAttribute("role", result[i]["userId"]);
							trElmt.setAttribute("deptId", result[i]["deptId"]);
							trElmt.setAttribute("deptName", result[i]["deptName"]);
							trElmt.setAttribute("userName", result[i]["userName"]);
							trElmt.addEventListener("click", function(e) {clickRow(e);}, false);
							trElmt.addEventListener("dblclick", function(e) {addUser(this, "one")}, false);
							
							tableList.appendChild(trElmt);
						}
					}
				}
				
				function changeListView(flag) {
					setUserListType(flag);
					var txtImgElmt = document.getElementById("txtlist");
					var imgImgElmt = document.getElementById("imglist");
					var tableList  = document.getElementById("shareTable");
					
					if (flag == 'TXT') {
						txtImgElmt.setAttribute("role", "on");
						imgImgElmt.setAttribute("role", "off");
						txtImgElmt.src      = "/images/kr/cm/btn_onlist.gif";
						imgImgElmt.src      = "/images/kr/cm/btn_imglist.gif";
						tableList.className = "mainlist";
					}
					else {
						txtImgElmt.setAttribute("role", "off");
						imgImgElmt.setAttribute("role", "on");
						txtImgElmt.src      = "/images/kr/cm/btn_list.gif";
						imgImgElmt.src      = "/images/kr/cm/btn_onimglist.gif";
						tableList.className = "organCabTbl";
					}
				}
				
				function addUser(trElmt, mode) {
					var selectedTable = document.getElementById("sharedTable");
					var userId        = trElmt.getAttribute("role");
					var checkElmt     = selectedTable.querySelector("tr[role='" + userId + "'][userType='user']");
					if (checkElmt) {if(mode) {alert(CabinetMessages.strExist);}; return;}
					
					var userName      = trElmt.getAttribute("userName");
					var deptName      = trElmt.getAttribute("deptName");
					addUserToShareList(userId, userName, "user", deptName, 0, 0);
				}
				
				function addUsers() {
					var listTableElmt  = document.getElementById("shareTable");
					var selectedTrList = listTableElmt.querySelectorAll("tr[class='bnkCabSelect2']");
					
					for (var i = 0, len = selectedTrList.length; i < len; i++) {
						addUser(selectedTrList[i]);
					}
				}
				
				function removeUser(trElmt) {
					var selectedTable = document.getElementById("sharedTable");
					selectedTable.removeChild(trElmt);
				}
				
				function removeUsers() {
					var selectedTblElmt = document.getElementById("sharedTable");
					var selectedTrList  = selectedTblElmt.querySelectorAll("tr[class='bnkCabSelect']");
					
					for (var i = 0, len = selectedTrList.length; i < len; i++) {
						removeUser(selectedTrList[i]);
					}
				}
				
				function addUserToShareList(userId, userName, userType, deptName, permission, subPermission) {
					var selectedTable       = document.getElementById("sharedTable");
					var newTrElmt           = document.createElement("tr");
					var newTdElmt1          = document.createElement("td");
					var newTdElmt2          = document.createElement("td");
					var newTdElmt3          = document.createElement("td");
					var newTdElmt4          = document.createElement("td");
					var selectPerm          = document.createElement("select");
					var selectSub           = document.createElement("select");
					var optionPerm1         = document.createElement("option");
					var optionPerm2         = document.createElement("option");
					var optionSub1          = document.createElement("option");
					var optionSub2          = document.createElement("option");
					optionPerm1.textContent = CabinetMessages.strRead;
					optionPerm2.textContent = CabinetMessages.strWrite;
					optionSub1.textContent  = CabinetMessages.strNoSub;
					optionSub2.textContent  = CabinetMessages.strSub;
					
					optionPerm1.setAttribute("value", "0");
					optionPerm2.setAttribute("value", "1");
					optionSub1.setAttribute("value",  "0");
					optionSub2.setAttribute("value",  "1");
					
					if (permission == 0) {
						optionPerm1.selected = 'selected';
					}
					else {
						optionPerm2.selected = 'selected';
					}
					
					if (subPermission == 0) {
						optionSub1.selected = 'selected';
					}
					else {
						optionSub2.selected = 'selected';
					}
					
					selectPerm.appendChild(optionPerm1);
					selectPerm.appendChild(optionPerm2);
					selectSub.appendChild(optionSub1);
					selectSub.appendChild(optionSub2);
					
					newTdElmt1.textContent = deptName;
					newTdElmt1.setAttribute("title", deptName);
					newTdElmt2.textContent = userName;
					newTdElmt2.setAttribute("title", userName);
					newTdElmt3.appendChild(selectPerm);
					newTdElmt4.appendChild(selectSub);
					
					newTrElmt.appendChild(newTdElmt1);
					newTrElmt.appendChild(newTdElmt2);
					newTrElmt.appendChild(newTdElmt3);
					newTrElmt.appendChild(newTdElmt4);
					
					newTrElmt.className = "bnkCabNormal";
					newTrElmt.setAttribute("role", userId);
					newTrElmt.setAttribute("deptName", deptName);
					newTrElmt.setAttribute("userName", userName);
					newTrElmt.setAttribute("userType", userType);
					
					selectedTable.appendChild(newTrElmt);
					selectedUsers.resetEvents();
				}
				
				function onStartSimpleSearch(event) {if(event.keyCode == "13") {searchUserList();}}
				function clearKeyword(inputElmt) {inputElmt.value = "";}
				function searchUserList() {
					searchValue = document.getElementById("keyword").value;
					if (!searchValue.replace(/\s/g,'')) {alert(CabinetMessages.strNoInput); return;}
					
					searchOpt  = document.getElementById("searchType").value;
					searchMode = "search";
					document.getElementById("searchResult").textContent = CabinetMessages.strResult;
					getUsers("1");
				}
				
				function setUserListType(pListType) {
					$.ajax({
						type: "POST",
						dataType: "text",
						url: "/ezOrgan/setListType.do",
						async: false,
						data: {listType : pListType},
						success: function(result) {
						}
					});
				}
				
				function getShareList() {
					$.ajax({
						type: "POST",
						url: "/ezCabinet/getShareUserList.do",
						data: {
							"cabinetId"   : cabinetId,
							"searchOpt"   : searchOpt2,
							"searchValue" : searchValue2
						},
						dataType: "JSON",
						async: false,
						success: function(data) {
							var code = data.code;
							switch(code) {
								case 0 : getDataSuccessfully(data)          ; break;
								case 1 : alert(CabinetMessages.strParamErr) ; break;
								case 2 : alert(CabinetMessages.strError)    ; break;
								case 3 : alert(CabinetMessages.strPerm)     ; break;
								default: alert(CabinetMessages.strError)    ; return;
							}
						},
						error: function(error) {
						}
					});
				}
				
				function getDataSuccessfully(data) {
					var listUser = data.shareList;
					if (!listUser || listUser.length == 0) {return;}
					
					for (var i = 0, len = listUser.length; i < len; i++) {
						var userId   = listUser[i]["userId"];
						var userName = listUser[i]["userName"];
						var deptName = listUser[i]["deptName"];
						var userType = listUser[i]["userType"];
						var permiss  = listUser[i]["permission"];
						var subPerm  = listUser[i]["subPermission"];
						var type     = "";
						
						console.log("Permission: " + permiss);
						console.log("SubPermission: " + subPerm);
						
						switch(userType) {
							case 0 : type = "comp"; break;
							case 1 : type = "dept"; break;
							case 2 : type = "user"; break;
						}
						
						addUserToShareList(userId, userName, type, deptName, permiss, subPerm);
					}
				}
				
				function viewUserInfo() {
					var userTable   = document.getElementById("shareTable");
					var selectUsers = userTable.querySelectorAll("tr[class='bnkCabSelect2']");
					
					if (!selectUsers || selectUsers.length == 0) {alert(CabinetMessages.strEmployee); return;}
					
					closeAllPopUp();
					
					var selectedTr   = selectUsers[selectUsers.length - 1];
					var width        = 420;
					var height       = 450;
					var leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
					var topPosition  = (window.screen.height / 2) - ((height / 2) + 50);
					var userId       = selectedTr.getAttribute("role");
					var deptId       = selectedTr.getAttribute("deptId");
					
					userPopup = window.open("/ezCommon/showPersonInfo.do?id=" + userId + "&dept=" + deptId, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
				}
				
				function addDeptToShareList() {
					var selectedTable = document.getElementById("sharedTable");
					var organTreeElmt = document.getElementById("treeView");
					var selectedNode  = organTreeElmt.querySelector("span[class='selectedNode']");
					if (!selectedNode) {alert(CabinetMessages.strError); return;}
					
					var deptName      = selectedNode.textContent;
					var deptId        = selectedNode.getAttribute("role");
					var deptLevel     = selectedNode.getAttribute("level");
					var userType      = deptLevel != "0" ? "dept" : "comp";
					var checkElmt     = selectedTable.querySelector("tr[role='" + deptId + "'][userType='"+ userType + "']");
					if (checkElmt) {alert(CabinetMessages.strExist); return;}
					
					addUserToShareList(deptId, deptName, userType, deptName, 0, 0);
				}
				
				function closeAllPopUp() {if (userPopup) {userPopup.close();}}
				
				function closeWindow() {window.close();}
				
				function saveShareUsers() {
					//*Note add function hee
					var selectedUsers = document.getElementById("sharedTable");
					var listTr        = selectedUsers.rows;
					var userList      = [];
					
					for (var i = 1, len = listTr.length; i < len; i++) {
						var userId   = listTr[i].getAttribute("role");
						var userType = listTr[i].getAttribute("userType");
						var perSlBox = listTr[i].children[2].firstElementChild;
						var subSlBox = listTr[i].children[3].firstElementChild;
						var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
						var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
						userList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm});
					}
					
					$.ajax({
						type: "POST",
						url: "/ezCabinet/saveShareUserList.do",
						data: {
							"cabinetId" : cabinetId,
							"userList"  : JSON.stringify(userList)
						},
						dataType: "JSON",
						async: false,
						success: function(data) {
							var code = data.code;
							switch(code) {
								case 0 : saveSuccessfully()                 ; break;
								case 1 : alert(CabinetMessages.strParamErr) ; break;
								case 2 : alert(CabinetMessages.strError)    ; break;
								case 3 : alert(CabinetMessages.strPerm)     ; break;
								case 4 : alert(CabinetMessages.strShareErr1); break;
								default: alert(CabinetMessages.strError)    ; return;
							}
						},
						error: function(error) {
						}
					});
				}
				
				function saveSuccessfully() {
					alert(CabinetMessages.strSave);
					closeWindow();
				}
			})();
			
		</script>
	</body>
</html>