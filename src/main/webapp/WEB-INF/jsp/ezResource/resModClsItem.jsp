<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:95%;">
	<head>
		<title><spring:message code="ezResource.t142"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code="ezResource.e2"/>" type="text/css" />
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code="ezResource.e1"/>"></script>
		<script type="text/javascript" src="/js/ezResource/functionLib.js"></script>
		<script type="text/javascript">
			var strBrd_ID = "${strBrdID}";
			var strCompanyID = "${companyID}";
			var userID = "${userID}";
			var userName = "${userName}";
			var deptID = "${deptID}";
			var deptName = "${deptName}";
			
			window.onload = function (){
			}

			function btnSave_Click() {

				if (document.getElementById("Brd_NM").value == "") {
					alert("<spring:message code="ezResource.t145"/>");
					document.getElementById("Brd_NM").focus();
					return;
				}

				var xmlPara = createXmlDom();
				var xmlHttp = createXMLHttpRequest();

				var objNode;
				createNodeInsert(xmlPara, objNode, "PARADATA");
				createNodeAndInsertText(xmlPara, objNode, "DATA", strBrd_ID);
				
				if (document.getElementById("OwnDept").getAttribute("idVal", "0") == "") {
				    createNodeAndInsertText(xmlPara, objNode, "DATA", deptID);
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("OwnDept").getAttribute("idVal", "0"));
			    }
			            
				if (document.getElementById("OwnDept").value == "") {
					createNodeAndInsertText(xmlPara, objNode, "DATA", deptName);
				} else {
			        createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("OwnDept").value);
				}

				if (document.getElementById("Owner").getAttribute("idVal", "0") == "") {
			       	createNodeAndInsertText(xmlPara, objNode, "DATA", userID);
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("idVal", "0"));
				}

				if (document.getElementById("Owner").getAttribute("NmVal", "0") == "") {
					createNodeAndInsertText(xmlPara, objNode, "DATA", userName);
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("NmVal", "0"));
				}
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("position", "0"));
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("OwnerCall").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_NM").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("ResLocation").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_Explain").value);
				createNodeAndInsertText(xmlPara, objNode, "DATA", strCompanyID);

				if (document.getElementById("approve1").checked == true) {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "1");
				} else {
					createNodeAndInsertText(xmlPara, objNode, "DATA", "0");
				}

				if (document.getElementById("Brd_NM2").value == "") {
					document.getElementById("Brd_NM2").value = document.getElementById("Brd_NM").value;
				}
				
				createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Brd_NM2").value);

				xmlHttp.open("Post", "/ezResource/callModClsItem.do", false);
				xmlHttp.send(xmlPara)
				
				if (xmlHttp.status != 200) {
					alert("<spring:message code="ezResource.t42"/>");
					return;
				}

				var rtnXML = xmlHttp.responseXML;
				var dataNodes = GetChildNodes(xmlHttp.responseXML);
				var strRtnVal = getNodeText(dataNodes[0]);

				if (strRtnVal == "False") {
					alert("<spring:message code="ezResource.t42"/>");
				} else {
					alert("<spring:message code="ezResource.t56"/>");
					window.opener.RefreshPageDoc();
					window.close();
				}
			}

			function btnCancel_Click(){
				window.close();
			}

			function btnClose_Click(){
				window.close();
			}

			var select_person_cross_dialogArguments = new Array();
			
			function btnTakeOwner_Click() {
				select_person_cross_dialogArguments[1] = btnTakeOwner_Click_Complete;
				var OpenWin = window.open("/ezResource/selectPerson.do", "selectPerson", GetOpenWindowfeature(750, 550));
				try { 
					OpenWin.focus(); 
				} catch (e) {
					
				}
			}
			
			function btnTakeOwner_Click_Complete(retVal) {
				if (typeof (retVal) != "undefined") {
					var strOwner = retVal;
					var arrOwner;

					arrOwner = strOwner.split(";");
					document.getElementById("Owner").value = arrOwner[0] + "(" + arrOwner[2] + ")";
					document.getElementById("Owner").setAttribute("NmVal", arrOwner[0]);
					document.getElementById("Owner").setAttribute("idVal", arrOwner[1]);
					document.getElementById("Owner").setAttribute("position", arrOwner[2]);
					document.getElementById("OwnDept").value = arrOwner[3];
					document.getElementById("OwnDept").setAttribute("idVal", arrOwner[4]);
					document.getElementById("OwnerCall").value = arrOwner[5];
				}
			}
		</script>
	</head>
	<body class="popup"  style="height:95%">
		<table class="layout">
  			<tr>
				<td style="height:20px">
    				<div id="menu">
        				<ul>
          					<li><span onClick="btnSave_Click()"><spring:message code="ezResource.t114"/></span></li>
        				</ul>
      				</div>
      				<div id="close">
        				<ul>
          					<li><span onClick="btnClose_Click()"><spring:message code="ezResource.t150"/></span></li>
        				</ul>
      				</div>
      				<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
						selToggleList(document.getElementById("close"), "ul", "li", "0");
					</script>
      				<table class="content">
        				<tr>
          					<th> <spring:message code="ezResource.t151"/></th>
          					<td><input type="text" name="OwnDept" id="OwnDept" idval="${ownDeptID}" value="${ownDeptNm}" style="width: 150px"></td>
          					<th> <spring:message code="ezResource.t152"/></th>
          					<td id="MakeDate" nowrap style="width:120px;padding-right:15px"> ${makeDate} </td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t153"/></th>
          					<td><input type="text" name="Owner" id="Owner" idval="${ownerID}" nmval="${ownerNm}" position="${ownerPosition}"
								value="${ownerNm}(${ownerPosition})" style="width: 150" readonly>
								<a class="imgbtn"><span onClick="btnTakeOwner_Click();"><spring:message code="ezResource.t154"/></span></a>
							</td>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td style="width:120px;padding-right:15px; white-space:nowrap"><input type="text" name="OwnerCall" id="OwnerCall" value="${ownerCall}" style="width: 100%"></td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t39"/></th>
          					<td colspan="3" style="padding:0">
          						<table style="width:100%">
              						<tr class="primary">
                						<th>${langPrimary}</th>
                						<td><input type="text" name="Brd_NM" id="Brd_NM" idval="${brdID}" value="${brdNm}" style="width: 98%" onBlur="CheckLen(this, 50)"></td>
              						</tr>
              						<tr class="secondary">
                						<th>${langSecondary}</th>
                						<td><input type="text" name="Brd_NM2" id="Brd_NM2" idval="${brdID}" value="${brdNm2}" style="width: 98%" onBlur="CheckLen(this, 50)"></td>
									</tr>
								</table>          
							</td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t148"/></th>
          					<td colspan="3"><input type="text" name="ResLocation" id="ResLocation" value="${resLocation}" style="width: 98%" onblur="CheckLen(this, 50)"></td>
        				</tr>
        				<tr>
							<th> <spring:message code="ezResource.t149"/></th>
							<td colspan="3">
								<c:if test="${approveFlag eq 1}">
									<input type="radio" name="approve" id="approve1" value="1"  checked/>
									<spring:message code="ezResource.t156"/>
									<input type="radio" name="approve" id="approve0" value="0" />
									<spring:message code="ezResource.t157"/>
								</c:if>
								<c:if test="${approveFlag eq 0}">
									<input type="radio" name="approve" id="approve1" value="1"/>
									<spring:message code="ezResource.t156"/>
									<input type="radio" name="approve" id="approve0" value="0"  checked/>
									<spring:message code="ezResource.t157"/>
								</c:if>
							</td>
						</tr>
      				</table>
      				<br>
					<h2><spring:message code="ezResource.t158"/></h2>
				</td>
  			</tr>
  			<tr>
    			<td style="padding-bottom:1px; height:100%; padding-right:12px">
        			<textarea name="Brd_Explain" id="Brd_Explain" style="width: 100%; height: 100%;resize:none"> ${brdExplain}</textarea>
    			</td>
  			</tr>
		</table>
	</body>
</html>