<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezResource.t55" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="/js/XmlHttpRequest.js" ></script>
		<script type="text/javascript" id="clientEventHandlersJS" >
			g_BrdID  = "${brdID}";
			g_UserID = "${userInfo.id}";
			g_UserNm = "<c:out value='${userInfo.displayName1}' />";

			var L_UpLevel	= "${upLevel}";
			var L_UpStep	= "${upStep}";
			var L_BrdGroup	= "${brdGroup}";
			var pCompanyID	= "${selCompanyID}";
			var sAdminfg	= "${adminFg}";

			document.onselectstart = function () {
				if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
					return false;
				else
					return true;
			};

			window.onload = function () {
				document.getElementById("Brd_NM").focus();
			}

			function cmdOK_onclick(){
		    	if (document.getElementById("Brd_NM").value == "") {
					alert("<spring:message code="ezResource.t31" />");
					return;
				}
			
				var pParentClsID = g_BrdID;
				var pMakerDeptID = "${userInfo.deptID}"; 
				var pMakerDeptNm = "<c:out value='${userInfo.deptName1}' />"
				var pMakerUserID = g_UserID;
				var pMakerUserNm = g_UserNm;
				var pMakerPosition = "<c:out value='${userInfo.title1}' />";
				var pMakerCall = "";
				var strCompanyID = pCompanyID;

				var xmlPara = "";
				var xmlHttp = "";

				if (CrossYN()) {
				    xmlPara = createXmlDom();
			    	xmlHttp = createXMLHttpRequest();

			    	var objNode;
			    	createNodeInsert(xmlPara, objNode, "PARADATA");
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pParentClsID);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerDeptID);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerDeptNm);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerUserID);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerUserNm);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerPosition);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", pMakerCall);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_NM").value);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_Explain").value);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_Access").value);
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", strCompanyID);
			    	if (document.getElementById("Brd_NM2").value == "") {
			        	document.getElementById("Brd_NM2").value = document.getElementById("Brd_NM").value;
			    	}
			    	createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_NM2").value);
				} else {
				    xmlPara = new ActiveXObject("Microsoft.XMLDOM");
			    	xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");

				    var objRootNode = xmlPara.createNode(1, "PARADATA", "");
				    xmlPara.appendChild(objRootNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pParentClsID;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerDeptID;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerDeptNm;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerUserID;
				    objRootNode.appendChild(objNode);

				    var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerUserNm;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerPosition;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = pMakerCall;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = document.getElementById("Brd_NM").value;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = document.getElementById("Brd_Explain").value;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = document.getElementById("Brd_Access").value;
			    	objRootNode.appendChild(objNode);

			    	var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = strCompanyID;
			    	objRootNode.appendChild(objNode);

				    if (document.getElementById("Brd_NM2").value == "") {
				        document.getElementById("Brd_NM2").value = document.getElementById("Brd_NM").value;
				    }
				    var objNode = xmlPara.createNode(1, "DATA", "");
			    	objNode.text = document.getElementById("Brd_NM2").value;
			    	objRootNode.appendChild(objNode);
				}

				xmlHttp.open("Post", "/admin/ezResource/callBrdNew.do", false);
				xmlHttp.send(xmlPara)
				if (xmlHttp.status != 200){
					alert("1. <spring:message code="ezResource.t42" />");
					return;
				}

				var rtnText = xmlHttp.responseText
				if (rtnText == "" || rtnText == "False"){
					alert("2. <spring:message code="ezResource.t42" />");
					return;
				}else{
					alert("<spring:message code="ezResource.t56" />");
					parent.window.location.reload();
				}
			}

			function InsertMenuNode(){
			    var objSelected = "";
			    if (CrossYN()) {
			        objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex();
			    } else {
		    	    objSelected = window.parent.frames["board_menu"].TreeView.selectedIndex;
		    	}
			}
		</script>
	</head>
	<body class="mainbody">	
		<h1>
		<spring:message code="ezResource.t23" />
		</h1>
		<table class="content">
			<tr>
				<th>
					<spring:message code="ezResource.t44" />
				</th>
				<td>
					<c:out value='${upNm}' />
					<input type="hidden" id="UPPER_NM" name="UPPER_NM" value="<c:out value='${upNm}' />">
				</td>
			</tr>
		</table>
		<br>
		<table class="content">
			<tr>
				<th>
					<spring:message code="ezResource.t57" />
				</th>
				<td style="padding: 0">
					<table width="100%">
						<tr class="primary">
							<th>${langPrimary}</th>
							<td>
								<input type="text" id="Brd_NM" name="Brd_NM" style="width: 99%"></td>
						</tr>
						<tr class="secondary">
							<th>${langSecondary}</th>
							<td>
								<input type="text" id="Brd_NM2" name="Brd_NM2" style="width: 99%">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<th>
					<spring:message code="ezResource.t47" />
				</th>
				<td>
					<textarea id="Brd_Explain" style="width: 98%" rows="3"><c:out value="${upExp}" /></textarea>
				</td>
			</tr>
			<tr style="display:none">
				<th>
					<spring:message code="ezResource.t53" />
				</th>
				<td>
					<textarea id="Brd_Access" style="width: 98%" rows="3"><spring:message code="ezResource.t58" /></textarea></td>
			</tr>
		</table>
		<div class="btnposition">
        	 <a class="imgbtn"><span onclick="cmdOK_onclick()" ><spring:message code="ezResource.t59" /></span></a>
		</div>
		<form name="brds">
			<input type="hidden" id="proc" name="proc" value="NEW">
			<input type="hidden" id="test" value="">
		</form>
	</body>
</html>