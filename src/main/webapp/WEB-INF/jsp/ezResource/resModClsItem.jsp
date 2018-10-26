<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:95%;">
	<head>
		<title><spring:message code="ezResource.t142"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezResource.e2', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezResource.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezResource/functionLib_cross.js')}"></script>
		<script type="text/javascript">
			var strBrd_ID = "${strBrdID}";
			var strCompanyID = "${companyID}";
			var userID = "${userID}";
			var userName = "${userName}";
			var deptID = "${deptID}";
			var deptName = "${deptName}";
			var res_owner = { "flag" : new Array(), "ownerId": new Array(), "ownerDept" : new Array(), "ownerName" : new Array(), "ownerName1" : new Array(), "ownerDeptName" : new Array() };
			var ownerList = JSON.parse('${ownerList}');
			window.onload = function (){
				
				for(var i=0; i<ownerList.length; i++) {
					res_owner["ownerId"][i] = ownerList[i]["ownerId"];
					res_owner["ownerDept"][i] = ownerList[i]["ownerDept"];
					res_owner["ownerName"][i] = ownerList[i]["ownerName"];
					res_owner["ownerName1"][i] = ownerList[i]["ownerName1"];
					res_owner["ownerDeptName"][i] = ownerList[i]["ownerDeptName"];
				}
				document.getElementById("subOwner").innerHTML = "";
				var length = res_owner.ownerName.length;
				for(var i=1; i<length; i++) {
					if(length-1 != i) {
						document.getElementById("subOwner").innerHTML += res_owner["ownerName"][i] + "(" + res_owner["ownerName1"][i] + "), ";
					}
					else {
						document.getElementById("subOwner").innerHTML += res_owner["ownerName"][i] + "(" + res_owner["ownerName1"][i] + ")";
					}
				}
			}

			function btnSave_Click() {
				/* 2018-05-02 서주연 #12554 */
				var re = /[\\/:*?\"<>&|]/gi;
				if( re.test(document.getElementById("Brd_NM").value)){
					alert("<spring:message code='ezResource.kms1' />");
					return;
				}
				
				if (document.getElementById("Brd_NM").value.trim() == "") {
					alert("<spring:message code="ezResource.t145"/>");
					document.getElementById("Brd_NM").focus();
					return;
				}
				
				var ownerList2 = res_owner["ownerId"][0];
				for(var i=1; i<res_owner.ownerId.length; i++) {
					ownerList2 += "," + res_owner["ownerId"][i];
				}
				
				/* 2018-05-02 서주연 #12558 */
				// 2018-07-10 김민성 - 자원관리 글자수 체크 maxlength로 수정
				/* var brdNmTag = document.getElementById("Brd_NM");
				var brdNm2Tag = document.getElementById("Brd_NM2");
				var resLocTag = document.getElementById("ResLocation");
				
				if(CheckLenthForRes(brdNmTag, 50)){
					return;	
				};
				
				if(CheckLenthForRes(brdNm2Tag, 50)){
					return;
				};
				
				if(CheckLenthForRes(resLocTag , 50)){
					return;
				};	 */

				var xmlPara = createXmlDom();
				var xmlHttp = createXMLHttpRequest();

				var objNode;
				createNodeInsert(xmlPara, objNode, "PARADATA");
				createNodeAndInsertText(xmlPara, objNode, "DATA", strBrd_ID);
				
				createNodeAndInsertText(xmlPara, objNode, "DATA", res_owner["ownerDept"][0]);	// deptID
				createNodeAndInsertText(xmlPara, objNode, "DATA", res_owner["ownerDeptName"][0]);	// deptName
				
				createNodeAndInsertText(xmlPara, objNode, "DATA", ownerList2);	// userID
				createNodeAndInsertText(xmlPara, objNode, "DATA", res_owner["ownerName"][0]);	// userName
				
				/* if (document.getElementById("OwnDept").getAttribute("idVal", "0") == "") {
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
				} */
				//createNodeAndInsertText(xmlPara, objNode, "DATA", document.getElementById("Owner").getAttribute("position", "0"));
				createNodeAndInsertText(xmlPara, objNode, "DATA", "0");
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

				if (document.getElementById("Brd_NM2").value.trim() == "") {
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
			
			function btnTakeOwner_Click(val) {
				res_owner["flag"][0] = val;
				
				select_person_cross_dialogArguments[0] = res_owner;
				select_person_cross_dialogArguments[1] = btnTakeOwner_Click_Complete;
				var OpenWin = window.open("/ezResource/selectPerson.do", "selectPerson", GetOpenWindowfeature(1050, 550));
				try { 
					OpenWin.focus(); 
				} catch (e) {
					
				}
			}
			
			function btnTakeOwner_Click_Complete(retVal) {
				if (typeof (retVal) != "undefined") {
					document.getElementById("Owner").innerHTML = retVal["ownerName"][0] + "(" + retVal["ownerName1"][0] + ")";
					document.getElementById("subOwner").innerHTML = "";
					var length = retVal.ownerName.length;
					for(var i=1; i<length; i++) {
						if(length-1 != i) {
							document.getElementById("subOwner").innerHTML += retVal["ownerName"][i] + "(" + retVal["ownerName1"][i] + "), ";
						}
						else {
							document.getElementById("subOwner").innerHTML += retVal["ownerName"][i] + "(" + retVal["ownerName1"][i] + ")";
						}
					}
					res_owner = retVal;
					/* var strOwner = retVal;
					var arrOwner;

					arrOwner = strOwner.split(";");
					document.getElementById("Owner").value = arrOwner[0] + "(" + arrOwner[2] + ")";
					document.getElementById("Owner").setAttribute("NmVal", arrOwner[0]);
					document.getElementById("Owner").setAttribute("idVal", arrOwner[1]);
					document.getElementById("Owner").setAttribute("position", arrOwner[2]);
					document.getElementById("OwnDept").value = arrOwner[3];
					document.getElementById("OwnDept").setAttribute("idVal", arrOwner[4]);
					document.getElementById("OwnerCall").value = arrOwner[5]; */
				}
			}
		</script>
	</head>
	<body class="popup"  style="height:100%">
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
          					<li><span onClick="btnClose_Click()"></span></li>
        				</ul>
      				</div>
      				<script type="text/javascript">
						selToggleList(document.getElementById("menu"), "ul", "li", "0");
					</script>
      				<table class="content">
        				<tr>
          					<th> <spring:message code="ezResource.t153"/></th>
          					<td>	
	          					<a class="imgbtn imgbck"><span onClick="btnTakeOwner_Click('ListViewOwner');"><spring:message code="ezResource.t154"/></span></a>
	          					<div id="Owner" style="overflow-y:auto; line-height:25px; display:inline" ><c:out value='${ownerNm}' />(<c:out value='${ownerPosition}' />)</div>
	          						<%-- <input type="text" name="Owner" id="Owner" idval="${ownerID}" nmval="${ownerNm}" position="${ownerPosition}"
									value="${ownerNm}(${ownerPosition})" style="width: 200px" readonly> --%>
							</td>
          					<th> <spring:message code="ezResource.t155"/></th>
          					<td style="white-space:nowrap">
          						<input type="text" name="OwnerCall" id="OwnerCall" value="${ownerCall}" style="width: 150px" maxLength="20">
          					</td>
          					<%-- <th> <spring:message code="ezResource.t152"/></th>
          					<td id="MakeDate" nowrap style="width:120px;padding-right:15px"> ${makeDate} </td> --%>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.rkms01"/></th>
          					<td colspan="3">
          						<table style="width:100%;">
        							<tr>
										<th style="border:0px; padding:0px; padding-right:2px;"><a class="imgbtn imgbck"><span onClick="btnTakeOwner_Click('ListViewsubOwner');"><spring:message code="ezResource.t154"/></span></a>
            						</th>
										<td><div id="subOwner" style="overflow-y:auto; line-height:25px; height:25px;"></div></td>
        							</tr>
    							</table>
          					<%-- <a class="imgbtn imgbck"><span onClick="btnTakeOwner_Click('ListViewsubOwner');"><spring:message code="ezResource.t154"/></span></a>
          					<div id="subOwner" style="overflow-y:auto; line-height:25px; height:25px;">
							</div> --%>
          						<%-- <input type="text" name="Owner" id="Owner" idval="${ownerID}" nmval="${ownerNm}" position="${ownerPosition}"
								value="${ownerNm}(${ownerPosition})" style="width: 200px" readonly> --%>
          						<%-- <input type="text" name="OwnDept" id="OwnDept" idval="${ownDeptID}" value="${ownDeptNm}" style="width: 100%"> --%>
          					</td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t39"/></th>
          					<td colspan="3" style="padding:0">
          						<table style="width:100%">
              						<tr class="primary">
                						<th>${langPrimary}</th>
                						<td><input type="text" name="Brd_NM" id="Brd_NM" idval="${strBrdID}" value="<c:out value='${strBrdNm}' />" style="width: 100%" maxlength="500"></td>
              						</tr>
              						<tr class="secondary">
                						<th>${langSecondary}</th>
                						<td><input type="text" name="Brd_NM2" id="Brd_NM2" idval="${strBrdID}" value="<c:out value='${strBrdNm2}' />" style="width: 100%" maxlength="500"></td>
									</tr>
								</table>          
							</td>
        				</tr>
        				<tr>
          					<th> <spring:message code="ezResource.t148"/></th>
          					<td colspan="3"><input type="text" name="ResLocation" id="ResLocation" value="${resLocation}" style="width: 100%" maxlength="100"></td>
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
    			<td style="padding-bottom:1px; height:100%; padding-right:12px; padding-top:10px;">
        			<textarea name="Brd_Explain" id="Brd_Explain" style="width: 100%; height: 100%;resize:none" maxlength="2000"><c:out value='${brdExplain}' /></textarea>
    			</td>
  			</tr>
		</table>
	</body>
</html>