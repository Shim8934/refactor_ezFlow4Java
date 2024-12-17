<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t427'/></title>
	    <meta http-equiv="Content-Type" content="text/html;charset=utf-8;">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <link rel="stylesheet" type="text/css" href="${util.addVer('/css/Tab.css')}">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript">
	        var pDocID = "<c:out value ='${docId}'/>";
	        var pSN= "<c:out value ='${sn}'/>";
			var userLang = "<c:out value = '${userInfo.getLang()}' />";
			
	        window.onload = function () {
	            try {
					getDistributeInfo();

	                if (!CrossYN()) {
	                    window.returnValue = "cancel";
	                }
	            } catch (ErrMsg) {
	                alert(ErrMsg.description);
	            }
	        };

			function btnCancel_onclick() {
				if (typeof ReturnFunction != 'undefined' && ReturnFunction != null) {
					ReturnFunction("cancel");
					window.close();
				} else {
					window.returnValue = "cancel";
					window.close();
				}
			}

			function getDistributeInfo() {
				$.ajax({
					url : "/ezApprovalG/getDistributeInfo.do",
					type : 'POST',
					dataType : 'json',
					async : false,
					data : {
						docId : pDocID,
						sn : pSN
					},
					success : function(result) {
						var divStr = '';
						if (result != null && result.length > 0) {
							var sn = 1;
							var resultsn = -1;
							var organ, manageDept, chargeName;
							for (var i = 0; i < result.length; i++) {
								if (userLang == "1") {
									organ = result[i].organ;
									manageDept = result[i].manageDept;
									chargeName = result[i].chargeName;
									organUserName = result[i].organUserName;
								} else {
									organ = result[i].organ2;
									manageDept = result[i].manageDept2;
									chargeName = result[i].chargeName2;
									organUserName = result[i].organUserName2;
								}
								if (chargeName == null || chargeName == "") {
									chargeName = "";
								}
								organUserName = "(" + organUserName + ")";
								
								if (resultsn < result[i].sn) {
									if (i == 0) {
										divStr += '<div class="divStep" style="margin-top: 0px">* Step' + sn + '</div>';
									} else {
										divStr += '<div class="divStep">* Step' + sn + '</div>';
									}
									sn += 1;
								}
								resultsn = result[i].sn;
								divStr += '<table class="content"><tbody>';
								divStr += '<tr><th style="width: 120px;"><spring:message code='ezApprovalG.t99993'/></th><td>' + organ + organUserName + '</td>';
								divStr += '<th style="width: 120px;"><spring:message code='ezApprovalG.t1775'/></th><td>' + result[i].href + '</td></tr>';
								divStr += '<tr><th><spring:message code='ezApprovalG.t1105'/></th><td>' + manageDept + '</td>';
								divStr += '<th><spring:message code='ezApprovalG.t999931'/></th><td>' + chargeName + '</td></tr>';
								divStr += '</tbody></table>';
								
							}
						}
						$('#contentDiv').append(divStr);
					}
				});
			}
	    </script>
	    <style>
			.divStep {
				font-size: 12px;
				font-weight: bold;
				margin-top: 5px;
				margin-bottom: 5px;
			}
			.content {
				table-layout: fixed;
				width: 100%;
				margin-bottom: 5px;
			}
			#contentDiv {
				height: 270px;
				margin-top: 5px;
				overflow-y: auto;
			}
	    </style>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.LJEAppr09'/></h1>
	    <div id="close">
            <ul>
                <li><span onclick="return btnCancel_onclick()"></span></li>
            </ul>
        </div>
		<table class="content">
			<tbody>
				<tr>
					<th style="width: 120px;"><spring:message code='ezApprovalG.F0003'/></th>
					<td colspan="3">${docInfo.docTitle}</td>
				</tr>
				<tr>
					<th><spring:message code='ezApprovalG.F0005'/></th>
					<td colspan="3">${docInfo.docNumber}</td>
				</tr>
			</tbody>
		</table>
		<div id="contentDiv"></div>
	</body>
</html>