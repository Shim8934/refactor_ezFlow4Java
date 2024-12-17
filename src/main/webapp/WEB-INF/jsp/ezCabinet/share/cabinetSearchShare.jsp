<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"      %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"    %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezCabinet.t136"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')}">
	</head>
	<body class="popup cabShareFile">
		<h1><spring:message code="ezCabinet.t136"/></h1>
		<div class="cabClose"><ul><li><span id="closeBttn"></span></li></ul></div>
		
		<div class="cabShareListDiv2">
			<div>
				<table id="sharedTable" class="mainlist">
					<tr>
						<td><spring:message code='ezCabinet.t103'/></td>
						<td><spring:message code='ezCabinet.t104'/></td>
						<td><spring:message code='ezCabinet.t105'/></td>
						<td><spring:message code='ezCabinet.t106'/></td>
					</tr>
					<c:choose>
						<c:when test="${fn:length(listUsers) gt 0}">
							<c:forEach items="${listUsers}" var="sharedUser">
								<tr class="bnkCabNormal" role="${sharedUser.userId}" deptname="${sharedUser.deptName}" usertype="${sharedUser.userType}">
									<td title="<c:out value='${sharedUser.deptName}'/>"><c:out value='${sharedUser.deptName}'/></td>
									<td title="<c:out value='${sharedUser.userName}'/>"><c:out value='${sharedUser.userName}'/></td>
									<td>
										<select>
											<option value="0" ${sharedUser.permission == 0 ? 'selected' : ''}><spring:message code='ezCabinet.t132'/></option>
											<option value="1" ${sharedUser.permission == 1 ? 'selected' : ''}><spring:message code='ezCabinet.t133'/></option>
										</select>
									</td>
									<td>
										<select>
											<option value="0" ${sharedUser.subPermission == 0 ? 'selected' : ''}><spring:message code='ezCabinet.t134'/></option>
											<option value="1" ${sharedUser.subPermission == 1 ? 'selected' : ''}><spring:message code='ezCabinet.t135'/></option>
										</select>
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td colspan="4" style="text-align: center;"><spring:message code='ezCabinet.t131'/></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</table>
			</div>
		</div>
		
		<div class="btnposition btnpositionNew" id="cabShareBttn">
			<a class="imgbtn"><span><spring:message code='ezCabinet.t79'/></span></a>
			<a class="imgbtn"><span><spring:message code='ezCabinet.t46'/></span></a>
		</div>
		
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')          }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCabinet/cabinetTable.js')  }"></script>
		<script type="text/javascript">
			var CabinetSearchShare = function() {
				var cabinetId     = null;
				var selectedUsers = new CabinetTable({
					normal   : "bnkCabNormal",
					selected : "bnkCabSelect",
					mode     : "received"
				});
				var status;
				var remainList;
				var beforeList;
				// 부모창에서 메세지 받아옴.
				window.addEventListener('message', function(event) {
					remainList = event.data[0]; // 검색결과 이외의 공유자 리스트
					beforeList = event.data[1]; // 이전 공유자 리스트
				});

				window.onbeforeunload = function() {
					// 버튼을 통해 창을 닫지 않는 경우 부모창으로 메세지 보냄.
					if (status == undefined) {
						window.opener.postMessage('closed', '*');
					}
				}

				function saveData(sendList) {
					$.ajax({
						type: "POST",
						url: "/ezCabinet/saveShareUserList.do",
						data: {
							"cabinetId" : cabinetId,
							"userList"  : JSON.stringify(sendList)
						},
						dataType: "JSON",
						async: false,
						success: function(data) {},
						error: function(error) {}
					});
				}

				function initEvents(cabId) {
					cabinetId               = cabId;
					document.onselectstart  = function () { return false;};
					document.getElementById("closeBttn").addEventListener("click", function(e) {closeWindow();}, false);
					
					var cabShareBttnElmt    = document.getElementById("cabShareBttn");
					var listBttns           = cabShareBttnElmt.children;
					listBttns[0].onclick    = function(e) {changeShareUsers();};
					listBttns[1].onclick    = function(e) {deleteShareUsers();};
					
					//Set selected tables
					selectedUsers.setTableElement("sharedTable", "id");
					selectedUsers.resetEvents();
				}
				
				function deleteShareUsers() {
					var shareTable = document.getElementById("sharedTable");
					var listSelTr  = shareTable.querySelectorAll("tr[class='bnkCabSelect']");
					var listTr     = shareTable.querySelectorAll("tr[class='bnkCabNormal']");
					if (!listSelTr || listSelTr.length == 0) {alert(CabinetMessages.strSelect2); return;}
						
					if (confirm(CabinetMessages.strDelete4)) {
						var userList = [];
						var otherList = [];

						// 검색결과 중 사용자가 선택한 삭제할 공유자 리스트
						for(var i = 0, len = listSelTr.length; i < len; i++) {
							var userId   = listSelTr[i].getAttribute("role");
							var userType = convertUserType(listSelTr[i].getAttribute("userType"));
							userList.push({userId: userId, userType : userType});
						}

						// 검색결과 중 삭제할 공유자를 제외한 나머지 공유자 리스트
						for (var i = 0, len = listTr.length; i < len; i++) {
							var userId   = listTr[i].getAttribute("role");
							var userType = convertUserType(listTr[i].getAttribute("userType"));
							var perSlBox = listTr[i].children[2].firstElementChild;
							var subSlBox = listTr[i].children[3].firstElementChild;
							var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
							var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
							otherList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm, searchFlag: 'N'});
						}
						// 검색결과 이외의 공유자와 함께 저장해줌.
						var allList = remainList.concat(otherList);
						saveData(allList);

						var url  = "/ezCabinet/modifyShareUserList.do";
						var data = {"cabinetId" : cabinetId, "mode" : "delete", "userList" : JSON.stringify(userList)};
						makeAjaxCall(data, "POST", url, handleModify, null, null, null);
						status = "delete";
					}
				}
				
				function handleModify(data) {
					var code = data.code;
					switch(code) {
						case 0 : afterModifySuccessfully()          ; break;
						case 1 : alert(CabinetMessages.strParamErr) ; break;
						case 2 : alert(CabinetMessages.strError)    ; break;
						case 3 : alert(CabinetMessages.strPerm)     ; break;
						default: alert(CabinetMessages.strError)    ; return;
					}
				}
				
				function afterModifySuccessfully() {
					var parentWd = window.opener;
					if (parentWd && parentWd.CabinetShareItem) {parentWd.CabinetShareItem.reloadList();}
					closeWindow();
				}
				
				function changeShareUsers() {
					var shareTable = document.getElementById("sharedTable");
					var listTr     = shareTable.rows;
					var userList   = [];
					if (listTr[1].textContent.includes(CabinetMessages.strNoData)) {
						alert("저장할 공유자가 없습니다.");
						return;
					} else {
						for (var i = 1, len = listTr.length; i < len; i++) {
							var userId   = listTr[i].getAttribute("role");
							var userType = convertUserType(listTr[i].getAttribute("userType"));
							var perSlBox = listTr[i].children[2].firstElementChild;
							var subSlBox = listTr[i].children[3].firstElementChild;
							var permiss  = perSlBox.options[perSlBox.selectedIndex].value;
							var subPerm  = subSlBox.options[subSlBox.selectedIndex].value;
							userList.push({userId: userId, userType : userType, permis: permiss, subPerm: subPerm, searchFlag: 'N'});
						}
						// 검색결과 이외의 공유자와 함께 저장해줌.
						var allList = remainList.concat(userList);
						saveData(allList);
						afterModifySuccessfully();

						/*var url  = "/ezCabinet/modifyShareUserList.do";
						var data = {"cabinetId" : cabinetId, "mode" : "change", "userList" : JSON.stringify(userList)};
						makeAjaxCall(data, "POST", url, afterModifySuccessfully, null, null, null);*/
						status = "change";
					}
				}
				
				function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, moreParam) {
					$.ajax({
						type: ajaxType,
						url: ajaxUrl,
						data: ajaxData,
						dataType: "JSON",
						async: asyncMode != false ? true : false,
						success : function(data) {
							handleSuccess(data, moreParam);
						},
						error : function(error) {
							if (handleError != null) {handleError();}
							
							alert(CabinetMessages.strError);
						}
					});
				}
				
				function convertUserType(userType) {
					var type = "";
					
					switch(parseInt(userType)) {
						case 0 : type = "comp"; break;
						case 1 : type = "dept"; break;
						case 2 : type = "user"; break;
					}
					
					return type;
				}
				
				function closeWindow() {window.close();}
				
				return {init: initEvents};
			}();
		</script>
		<script type="text/javascript">CabinetSearchShare.init("<c:out value='${cabinetId}'/>");</script>
	</body>
</html>