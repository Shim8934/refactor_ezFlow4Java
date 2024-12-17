<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezApprovalG.KMHF07'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<style type="text/css">
			.ui-sortable > li { height: 40px; line-height: 40px; margin-bottom: 8px; border: 1px dashed #D6DBE4; border-radius: 3px; box-sizing: border-box; padding-left: 10px; cursor: move; padding-right: 30px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; }
			#sortables {padding-left: 0px;}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery-ui.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewFolder.js')}"></script>
<%-- 		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script> --%>
		<script type="text/javascript">
			var ContID = "";
		    var companyID = "";
		    var Rtnval = new Array();
		    
		    window.onload = function () {
				try {
					RetValue = parent.fContMainSN_dialogArguments[0];
					ReturnFunction = parent.fContMainSN_dialogArguments[1];
				} catch (e) {
				    try {
				        RetValue = opener.fContMainSN_dialogArguments[0];
				        ReturnFunction = opener.fContMainSN_dialogArguments[1];
				    } catch (e) {
				    	RetValue = window.dialogArguments;
				    }
				}
				
				ContID = RetValue[0];
				companyID = RetValue[1];

		        Rtnval[0] = "cancel";
		        Rtnval[1] = "cancel";
		    }
			$(document).ready(function() {
				$("#sortables").sortable();
			});


			function MoveContSN_onclick() {
				var li_element = document.querySelectorAll('#sortables > li');
				var strGroupList = "";
				if (li_element.length > 0) {
					for (var i = 0; i < li_element.length; i++) {
						strGroupList += GetAttribute(li_element.item(i), "FORMCONTID") + ";";
					}
				}else {
					window.close();
					return;
				}
				
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/admin/ezApprovalG/moveContSN.do",
					data : {
						CONTID : ContID,
						GROUPLIST : strGroupList,
						COMPANYID : companyID
					},
					success : function (result) {
						if (result == "OK") {
							if (ReturnFunction != null) {
								Rtnval[0] = "OK";
								ReturnFunction(Rtnval);
								window.close();
							}
						} else {
							alert(strLang131);
							window.close();
						}
					},
					error : function () {
						alert(strLang131);
						window.close();
					}
				})
			}
		</script>
	</head>
	<body class="popup">
		<h1><spring:message code='ezApprovalG.KMHF07'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="window.close()"></span></li>
            </ul>
        </div>
		<table style="margin-top: 5px;">
			<tr>
				<td style="width: 438px; vertical-align: top">
					<div id="divFromTreeView" style="vertical-align: top; padding-top: 5px; height: 480px; width: 438px; overflow-x: auto; overflow-y: auto; BACKGROUND-COLOR: #ffffff">
						<ul id="sortables" class="ui-sortable">
							<c:choose>
								<c:when test="${userInfo.primary == 1}">
									<c:forEach var="contList" items="${contList}">
										<li formcontid="${contList.formContID}" class="ui-sortable-handle">${contList.formContName}</li>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<c:forEach var="contList" items="${contList}">
										<li formcontid="${contList.formContID}" class="ui-sortable-handle">${contList.formContName2}</li>
									</c:forEach>
								</c:otherwise>
							</c:choose>
						</ul>
						<c:if test="${empty contList}">
								<div style="width: 100%; height: 40px; line-height: 40px; margin-bottom: 8px; border: 1px dashed #D6DBE4; border-radius: 3px; box-sizing: border-box; padding-left: 10px; cursor: move; padding-right: 30px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; ">
									<spring:message code='ezApprovalG.t1314'/>
								</div>
						</c:if>
					</div>
				</td>
			</tr>
			<tr>
				<td style="padding-left: 5px; padding-right: 5px; padding-top: 5px; vertical-align: top; text-align: center">
					<div class="btnpositionNew">
						<a class="imgbtn"><span onclick="return MoveContSN_onclick()"><spring:message code='ezApprovalG.t1767'/></span></a>
					</div>	
				</td>
			</tr>
		</table>
	</body>
</html>