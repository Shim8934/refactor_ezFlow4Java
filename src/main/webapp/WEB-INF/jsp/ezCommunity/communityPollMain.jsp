<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>poll_main</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var code = "<c:out value = '${code}' />";
// 		var ch_CommunityAdmin = "${chCommunityAdmin}";
		    var UserLevel = "<c:out value ='${userLevel}' />";
		    var userID = "<c:out value ='${userInfo.id}' />";
		    
		    window.onload = function () {
				$("#tblList").html($("#tblList").html() + '${strXML}');
			}
		    
			function poll_edit(pClubNo, managerID) {
				window.location.href = "/ezCommunity/pollEdit.do?pClubNo=" + encodeURIComponent(pClubNo) + "&managerID=" + encodeURIComponent(managerID);
			}
			
			/* 2018-05-07 홍승비 - 체크박스를 사용하는 상단 삭제 버튼 기능 추가 */
			var pClubNo = "";
			var managerIDs = "";
			var delOK = "";
			function poll_BeforeDelete () {
				pClubNo = "";
				managerIDs = "";
				delOK = "";
				
				if ($("input:checkbox:checked").length == 0) {
					alert("<spring:message code='ezQuestion.t161' />");
					return;
				}
				if (UserLevel == "0" || UserLevel == "9") {
					alert("<spring:message code='ezCommunity.t431' />");
			     	return;
				}
				else {
					$("input:checkbox:checked[id != 'checkBoxHeader']").each(function () {
						/* 2018-05-10 삭제 권한 확인 .do에서 jsp로 옮김 */
						if (UserLevel != "4" && $(this).attr("pollRegID") != userID) {
							delOK = "no";
							alert("<spring:message code='ezCommunity.t431' />");
					     	return false;
						}

						if (pClubNo == "") {
							pClubNo = $(this).attr("clubNo");
						}
						managerIDs += $(this).attr("id");
					});
					
					if (delOK != "no") {
						poll_Delete(pClubNo, managerIDs);
					}
				}
			}

			/* 2018-05-07 홍승비 - 삭제 여부 확인창 추가 */
			function poll_Delete(pClubNo, managerID) {
				if (confirm("<spring:message code='ezCommunity.t426' />")) {
					window.location.href = "/ezCommunity/pollDelete.do?code=" + encodeURIComponent(pClubNo) + "&managerID=" + encodeURIComponent(managerID);			
				}
			}
			
			/* 2018-05-07 홍승비 - 설문추가 권한체크 html 분기(jstl)에서 스크립트 분기로 변경 */
			function poll_add() {
				if (UserLevel == "0" || UserLevel == "9") {
		            alert("<spring:message code='ezCommunity.t431' />");
		            return;
		        } else if ("${disable}" == true) {
		        	alert("<spring:message code = 'ezCommunity.t667' />");
		        	return;
		        } else {
		        	document.getElementById("code").value = code;
		        	document.getElementById("pollAdd").submit();
		        }
			}

		    function movepage(code, itemno, pollstate) {
		        if (UserLevel == "0" || UserLevel == "9") {
		            alert("<spring:message code='ezCommunity.t431' />");
		            return;
		        } 
		        window.location.href = "/ezCommunity/pollRes.do?code=" + code + "&pollManagerID=" + itemno + "&pollState=" + encodeURI(encodeURIComponent(pollstate));
		    }
		    
		    function checkAll(obj) {
		    	if (obj.checked) {
		    		$("input:checkbox").prop("checked", true);
		    	} else {
		    		$("input:checkbox").prop("checked", false);
		    	}    	
		    }
		    
		</script>
	</head>
	<body class ="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.t598' /></h1>
		<div id="mainmenu">
		<%-- 2018-05-07 홍승비 - 사용하지 않는 변수와 jstl 분기 제거 --%>
			<ul>
				<li class="important"><span  onClick="poll_add()"><spring:message code='ezCommunity.t671' /></span></li>
				<li onClick="poll_BeforeDelete()"><span class="icon16 icon16_delete"></span></li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
		<table id="tblList" class="cmhomelist" style="width:100%;margin-top:12px">
			<tr>
				<th style="width:27px;"><div class='custom_checkbox'><input id="checkBoxHeader" type="checkbox" onclick="checkAll(this)"/></div></th>
				<th><spring:message code='ezCommunity.t673' /></th>			
			    <th style="width:150px;"><spring:message code='ezCommunity.t672' /></th>
			    <th style="width:80px;"><spring:message code='ezCommunity.t674' /></th>
			    <th style="width:80px;"><spring:message code='ezCommunity.t675' /></th>
			    <th style="width:100px; padding-left: 15px;"><spring:message code='ezCommunity.t676' /></th>
			</tr>
				<c:if test="${strXML eq ''}" >
					<tr>
						<td align="center" colspan="6"><spring:message code='ezQuestion.t312'/></td>
					</tr>
				</c:if>
		</table>
		
		<form id="pollAdd" action="/ezCommunity/pollAdd.do" method="POST" >
			<input type="hidden" id="code" name="code">
		</form>
	</body>
</html>