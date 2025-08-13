<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> 
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Invite Member</title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/community.css')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
		<style>
			.pagetd {
				padding-top:6px; 
			}
       		.pcol {
       			padding-top:6px;
       		}
        	.Right_Point01 {
	        	font:bold;
	        	color:#017bec;
	        }
	        .cmhomelist tr td {
	        	overflow:hidden;
	        	text-overflow:ellipsis;
	        	white-space:nowrap;
	        }
			#tblList2 tr td img {
				margin-top : 3px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezCommunity.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezCommunity/common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript">
			var code = "<c:out value='${fn:escapeXml(code)}'/>";
			var userLevel = "<c:out value='${fn:escapeXml(userLevel)}'/>";

			function on_keydown(e)
			{
				if (e.keyCode == "13")
					check_name();
			}

			var checkname_cross_dialogArguments = new Array();
			var i = 0;
			var namelength = 0;
			var checknametype = "";
			var checkNamePopup = "";
			function check_name(type) {
				if (type != undefined)
					checknametype = type;
				else
					checknametype = "";

				var name = document.getElementById("receiverinput").value;
				name = ReplaceText(name, ",", ";");

				var names = name.split(";");
				namelength = names.length;

				for (; i < names.length; i++) {
					names[i] = TrimText(names[i]);

					if (names[i] == "")
						continue;

					var adCount = 0;
					var xmlDOM = createXmlDom();

					$.ajax({
						type : "POST",
						dataType : "text",
						async : false,
						url : "/ezOrgan/getSearchList.do",
						data : {
							search : "displayName::" + names[i],
							cell   : "company;description;title;displayName;mail",
							prop   : "displayName;description",
							type   : "user"
						},
						success: function(xml){
							xmlDOM = loadXMLString(xml);
							adCount = xmlDOM.getElementsByTagName("ROW").length;
						}
					});

					if (adCount == 0) {
						alert("'" + names[i] + "'" + "<spring:message code='ezCommunity.lyj72' />");
						continue;
					} else if (adCount == 1) {
						if (g_invite == null)
							g_invite = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

						var userIds = [];

						<c:forEach items="${clubUserListVO}" var = "clubUser" >
							userIds.push("${clubUser.c_ID}");
						</c:forEach>

						if (!userIds.includes(getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]))) {
							var length = g_invite["name"].length;

							for (var j = 0; j < length; j++) {
								if (g_invite["id"][j] == getNodeText(xmlDOM.getElementsByTagName("DATA2")[0])) {
									alert("<spring:message code='ezCommunity.lyj73' />");
									//2018-08-10 김보미
									document.getElementById("receiverinput").value = "";
									return;
								}
							}
						} else {
							alert("<spring:message code='ezCommunity.lyj71' />");
							return;
						}

						g_invite["name"][length] = getNodeText(GetChildNodes(SelectNodes(xmlDOM, "LISTVIEWDATA/ROWS/ROW")[0])[3])
						g_invite["id"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA2")[0]);
						g_invite["deptname"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA7")[0]);
						g_invite["name1"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA5")[0]);
						g_invite["name2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA6")[0]);
						g_invite["deptname2"][length] = getNodeText(xmlDOM.getElementsByTagName("DATA8")[0]);

						if (length == 0)
							document.getElementById("receiverlist").innerHTML = g_invite["name"][length];
						else
							document.getElementById("receiverlist").innerHTML += ", " + g_invite["name"][length];
					} else {
						var rgParams = new Array();
						rgParams["addrBook"] = xmlDOM;
						rgParams["name"] = "";
						rgParams["id"] = "";
						rgParams["deptname"] = "";
						rgParams["name1"] = "";
						rgParams["name2"] = "";
						rgParams["deptname2"] = "";

						checkname_cross_dialogArguments[0] = rgParams;
						checkname_cross_dialogArguments[1] = check_name_Complete;
						checkNamePopup = GetOpenWindow("/ezCommunity/checkName.do", "checkName", 610, 353);
						i++;
						return;
					}
				}
				document.getElementById("receiverinput").value = "";
				i = 0;
				if (checknametype != "")
					invite_select_after();
			}

			function check_name_Complete(rgParams) {
				if (checkNamePopup && !checkNamePopup.closed) {
					checkNamePopup.close();
				}

				if (rgParams["name"] != "") {
					if (g_invite == null)
						g_invite = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array() };

					var userIds = [];

					<c:forEach items="${clubUserListVO}" var = "clubUser" >
						userIds.push("${clubUser.c_ID}");
					</c:forEach>

					if (!userIds.includes(rgParams["id"])) {
						var length = g_invite["name"].length;
						for (var j = 0; j < length; j++) {
							if (g_invite["id"][j] == rgParams["id"]) {
								alert("<spring:message code='ezCommunity.lyj73' />");
								//2018-08-10 김보미
								document.getElementById("receiverinput").value = "";
								document.getElementById("receiverinput").focus();
								return;
							}
						}
					} else {
						alert("<spring:message code='ezCommunity.lyj71' />");
						return;
					}

					var length = g_invite["name"].length;

					g_invite["name"][length] = rgParams["name"];
					g_invite["id"][length] = rgParams["id"];
					g_invite["deptname"][length] = rgParams["deptname"];
					g_invite["name1"][length] = rgParams["name1"];
					g_invite["name2"][length] = rgParams["name2"];
					g_invite["deptname2"][length] = rgParams["deptname2"];

					if (length == 0)
						document.getElementById("receiverlist").innerHTML = g_invite["name"][length];
					else
						document.getElementById("receiverlist").innerHTML += ", " + g_invite["name"][length];

					if (i != namelength)
						check_name();
				}
				if (i == namelength) {
					i = 0;
					document.getElementById("receiverinput").value = "";
				}
				if (checknametype != "")
					invite_select_after();
			}

			var g_invite = null;
			var community_select_invite_dialogArguments = new Array();
			function invite_select() {
				check_name("invite");
			}

			function invite_select_after() {
				community_select_invite_dialogArguments[0] = g_invite;
				community_select_invite_dialogArguments[1] = invite_select_Complete;

				GetOpenWindow("/ezCommunity/communitySelectMember.do?title=" + encodeURI("사용자 리스트") + "&code=" + encodeURI(code), "community_select_invite", 970, 655);
			}

			function invite_select_Complete(rtn) {
				if (typeof (rtn) != "undefined") {
					g_invite = { "id": new Array(), "name": new Array(), "deptname": new Array(), "name1": new Array(), "name2": new Array(), "deptname2": new Array(), "jikwe": new Array(), "phone": new Array() };
					document.getElementById("receiverlist").innerHTML = "";

					for (var i = 0; i < rtn["id"].length; i++) {
						if (i == 0)
							document.getElementById("receiverlist").innerHTML = rtn["name"][i];
						else
							document.getElementById("receiverlist").innerHTML += ", " + rtn["name"][i];

						g_invite["name"][i] = rtn["name"][i];
						g_invite["id"][i] = rtn["id"][i];
						g_invite["deptname"][i] = rtn["deptname"][i];
						g_invite["name1"][i] = rtn["name1"][i];
						g_invite["name2"][i] = rtn["name2"][i];
						g_invite["deptname2"][i] = rtn["deptname2"][i];
						g_invite["jikwe"][i] = rtn["jikwe"][i];
						g_invite["phone"][i] = rtn["phone"][i];

					}
				}
			}

			function TrimText( orgStr )
			{
				var copyStr = "";
				var strIndex;

				for ( strIndex = 0; strIndex < orgStr.length; strIndex ++ ) {
					if ( orgStr.charAt(strIndex) == ' ' ) continue;
					else {
						copyStr = orgStr.substr( strIndex );
						break;
					}
				}
				for ( strIndex = copyStr.length - 1; strIndex >= 0; strIndex -- ) {
					if ( copyStr.charAt(strIndex) == ' ' ) continue;
					else {
						copyStr = copyStr.substr( 0, strIndex + 1 );
						break;
					}
				}
				return copyStr;
			}

			function cancel() {
				window.location.reload();
			}

			function inviteSendAlarm() {
				if (g_invite == null || g_invite["id"].length == 0) {
					alert("사용자를 선택해주세요.");
					return;
				}

				$.ajax({
					type : "POST",
					dataType : "json",
					contentType: "application/json;charset=UTF-8",
					url : "/ezCommunity/communityInviteSend.do",
					async : false,
					data : JSON.stringify({
						code : code,
						inviteUserList : g_invite
					}),
					success : function(result) {
						alert("<spring:message code='ezCommunity.lyj84' />");
						window.location.reload();
					},
					error : function(e) {
						console.log("error");
					}
				});
			}
		</script>
	</head>
	<body class="cmhome_body">
		<h1 class="type1_h1"><spring:message code='ezCommunity.lyj68' /></h1>
		<span style="font-size: 13px;">▒ <spring:message code='ezCommunity.lyj69' /></span>
		<table class="content" style="margin-top: 10px;">
			<tbody>
				<tr id="receiverTr1">
					<th rowspan="2"><a id="imgbutton" class="imgbtn"><span id="clickbtn" onclick="invite_select()"><spring:message code='ezCommunity.lyj70' /></span></a></th>
					<td class="pos1">
						<input name="Input" id="receiverinput" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" onkeyup="return on_keydown(event)">
					</td>
				</tr>
				<tr id="receiverTr2">
					<td colspan="2">
						<div id="receiverlist" style="OVERFLOW-Y: auto; HEIGHT: 20px"></div>
					</td>
				</tr>
			</tbody>
		</table>
		<div style="text-align:center;" class="btnposition  btnpositionInvite">
			<a class="imgbtn"><span onclick="inviteSendAlarm()" ><spring:message code='ezCommunity.lyj68' /></span></a>
			<a class="imgbtn"><span onclick="cancel()" ><spring:message code = 'ezCommunity.t109' /></span></a>
		</div>
	</body>
</html>