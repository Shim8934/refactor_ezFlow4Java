<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html style="height: 99%;">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
</head>
<body class="mainbody" style="height: 95%;">
<div>
	<h1><spring:message code='ezSystem.fido012' /></h1>
	<tr>
		<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
                    <span id="topmenu" style="width: 500px; display: block; margin-bottom: 10px;" >&nbsp;<spring:message code='ezStatistics.t195'/> :
                        <select style="width: 120px; height:24px" id="ListCompany" name="SCompID" onchange="selectCompanyID()">
                            <c:forEach var="item" items="${list}">
								<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
							</c:forEach>
                        </select>&nbsp;
                    </span>
		</td>
	</tr>
	<span class="txt">▒ <spring:message code='ezSystem.fido013'/></span><br><br>

	<table class="content" style="width:600px;">
		<tr>
			<th rowspan="2" style="width: 60px;"><spring:message code='ezSystem.jje4'/></th>
			<td>&nbsp;<label id="radioFalse"><input name="ipRadio" type="radio" id="ipRadio0"><span style="vertical-align:middle;">&nbsp;<spring:message code='ezEmail.t99000009'/></span></label></td>
		</tr>
		<tr>
			<td>&nbsp;<label id="radioTrue"><input name="ipRadio" type="radio" id="ipRadio1"><span style="vertical-align:middle;">&nbsp;<spring:message code='ezBoard.t162'/></span></label></td>
		</tr>
	</table>
	<div style="width:600px;">
		<div class="btnpositionJsp">
			<a id="btn1" class="imgbtn" onClick="saveBtn()"><span><spring:message code='main.sp09'/></span></a>
			<a id="btn2" class="imgbtn" onClick="cancleBtn()"><span><spring:message code='main.t135'/></span></a>
		</div>
	</div>

	<div class="portlet_tabpart01">
		<div class="portlet_tabpart01_top" id="tab1">
			<p><span id="tabsub1"><spring:message code='ezSystem.fido014' /></span></p>
		</div>
	</div>
</div>
<iframe id="fidoIpManager_ifrm" style="width: 100%; height:350px; max-height: 650px;" frameborder="0">
	
</iframe>
</body>
<script type="text/javascript">
	var Tab1_SelectID = "";
	var useFido = "";
	var companyID = "${companyId}";
	var adminChk = ${adminChk};

	window.onload = function () {
		getFidoUseConfig(companyID);	
		Tab1_NewTabIni("tab1"); // tab add event
		Tab_init_select("tabsub1");
	};

	function Tab_init_select(obj) {
		var selectObj = document.getElementById(obj);
		selectObj.setAttribute("class", "tabon");
		Tab1_SelectID = selectObj.id;
		ChangeTab(Tab1_SelectID);
	}

	function ChangeTab(obj) {
		var pSelectTab = Tab1_SelectID == "" ? obj : Tab1_SelectID;

		switch (pSelectTab) {
			case "tabsub1":
				document.getElementById("fidoIpManager_ifrm").src = "/ezSystem/systemFidoIPBand.do?companyId="+ encodeURIComponent(companyID);
				break;
		}
	}

	function Tab1_MouseClick_more(obj, displayFlag) {
		if (obj.className != "tabon") {

			obj.className = "tabon";
			var tabSelect = document.getElementById(Tab1_SelectID);
			if (obj.id != Tab1_SelectID) {
				if (Tab1_SelectID != "" && tabSelect != null) {
					tabSelect.className = "";
				}

				obj.className = "tabon";
				Tab1_SelectID = obj.id;
				selValue = obj.textContent;
				CurPage = 1;
			}

			var tabpartUL = document.getElementById("tabpart01UL").style.display;
			if (!displayFlag) {
				tabpartUL = "";
			} else {
				if (tabpartUL == "") {
					tabpartUL = "none";
				} else {
					tabpartUL = "";
				}
			}
		} else {
			if (tabpartUL == "") {
				tabpartUL = "none";
			} else {
				tabpartUL = "";
			}
		}
	}

	function tabAllWidth() {
		var allWidth = 0;
		var tabP = document.getElementById("tab1").getElementsByTagName("P");

		for (var i = 0; i < tabP.length; i++) {
			allWidth += tabP[i].offsetWidth;
		}
		return allWidth;
	}


	function Tab1_MouserOver(obj) {
		obj.className = "tabover";
	}

	function Tab1_MouserOut(obj) {
		if(Tab1_SelectID != obj.id) {
			obj.className = "";
		}
	}

	function Tab1_MouseClick(obj) {
		Tab_init_select(obj.id);
	}


	function Tab1_NewTabIni(pTabNodeID) {
		var tabNode = document.getElementById(pTabNodeID).childNodes;

		for (var i = 0; i < tabNode.length; i++) {
			var tabNodeChildItem = tabNode.item(i).childNodes.item(0);
			var tabNodeChild = tabNode[i].childNodes[0];

			if (tabNode.item(i).nodeName == "P") {
				if (tabNodeChildItem.nodeName == "SPAN") {
					tabNodeChildItem.onmouseover = function () { Tab1_MouserOver(this); };
					tabNodeChildItem.onmouseout = function () { Tab1_MouserOut(this); };

					if (tabNodeChild.id != "overSpan") {
						tabNodeChild.onclick = function () { Tab1_MouseClick(this); };
					} else {
						tabNodeChild.onclick = function () { Tab1_MouseClick_more(this, true); };
					}
				}
			}
		}
	}

	// 사용여부 저장 버튼 클릭
	function saveBtn() {
		var allowResult = "NO";
		if (!document.getElementById("ipRadio0").checked) {
			allowResult = "YES";
		}

		if (companyID != document.getElementById("ListCompany").value) {
			companyID = document.getElementById("ListCompany").value
		}
		
		$.ajax({
			type : "POST",
			url : "/ezSystem/setFidoUseConfig.do?propertyValue=" + allowResult,
			data : {companyID : companyID},
			cache : false,
			error : function(data) {
				alert("<spring:message code='ezCommunity.t283'/>");
			},
			success : function(data) {
				useFido = data;
				alert("<spring:message code='ezCommunity.t282'/>");
			}
		});
	}

	function cancleBtn() {
		if (useFido === "NO") {
			document.getElementById("ipRadio0").checked = true;
		} else {
			document.getElementById("ipRadio1").checked = true;
		}
	}

	function selectCompanyID() {
		if (companyID != document.getElementById("ListCompany").value) {
			companyID = document.getElementById("ListCompany").value
			getFidoUseConfig(companyID);
			Tab1_NewTabIni("tab1"); // tab add event
			Tab_init_select("tabsub1");
		}
	}
	
	function getFidoUseConfig(currentCompanyId) {
		$("input:radio[name='ipRadio']").prop('checked',false);
		$.ajax({
			type : "POST",
			url : "/ezSystem/getFidoUseConfig.do",
			data : {companyID : currentCompanyId},
			async : false,
			success : function(result) {
				useFido = result;
				if (result === "YES") {
					$("#ipRadio1").prop('checked',true);
				} else {
					$("#ipRadio0").prop('checked',true);
				}
			}, error : function(error){
				alert("Error : " + error);
			}
		})
	}
	
</script>
</html>
