<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t1279' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			.mainlist_free tr th { border-top:0px }
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript">
		var pUserID = "<c:out value='${userInfo.id}'/>";
		var pUserName = "<c:out value='${userInfo.displayName}'/>";
		var pUserName1 = "<c:out value='${userInfo.displayName1}'/>";
		var pUserName2 = "<c:out value='${userInfo.displayName2}'/>";
		var pCompanyID = "<c:out value='${userInfo.companyID}'/>";
		var OrderCell = "";
		
		$(document).ready(function() {
			pCompanyID = document.getElementById("ListCompany").value;
			
			getSealListInfo();
		});
		
		function getSealListInfo() {
			var rtnXml = createXmlDom();
			
			$.ajax({
				type : "POST",
				async : false,
				url : "/admin/ezApprovalG/getSealList.do",
				data : {
					listFlag : "ADMIN",
					companyID : pCompanyID
				},
				success : function(xml) {
					rtnXml = loadXMLString(xml);
				},
				error : function(e) {
				}
			});
			
			if (document.getElementById("lvSeal").innerHTML != "") {
				document.getElementById("lvSeal").innerHTML = "";
			}
			
			var headerData = createXmlDom();
			headerData = loadXMLString(LISTHEADER.innerHTML.toUpperCase());
			
			var sealList = new ListView();
			sealList.SetID("pSealList");
			sealList.SetRowOnDblClick("btnInfo_onclick");
			sealList.SetSelectFlag(false);
			sealList.SetHeightFree(true);
			sealList.DataSource(headerData);
			sealList.DataBind("lvSeal");
			
			if (typeof (SelectNodes(rtnXml, "ROW")[0]) != "undefined") {
				sealList.DataSource(rtnXml);
				sealList.RowDataBind("lvSeal");
			}
		}
		
		function selectCompanyID() {
			pCompanyID = document.getElementById("ListCompany").value;
			
			getSealListInfo();
		}
		
		var AddSealInfo_dialogArguments = new Array();
		function btnAdd_onclick() {
			var parameter = new Array();
			parameter[0] = pUserID;
			parameter[1] = pUserName;
			parameter[2] = pCompanyID;
			
			AddSealInfo_dialogArguments[0] = parameter;
			AddSealInfo_dialogArguments[1] = btnAdd_onclick_complete;
			
			var url = "/admin/ezApprovalG/addSealInfo.do";
			var ezSealInfo = window.open(url, "", GetOpenWindowfeature(430, 350));
			try { ezSealInfo.focus(); } catch (e) {}
		}
		
		function btnAdd_onclick_complete(ret) {
			if (ret[0] == "OK") {
				var pSealNum = ret[1];
				var pSealName = ret[2];
				var pSealPath = ret[3];
				var pSealWidth = ret[4];
				var pSealHeight = ret[5];
				
				var result = insertSealInfo(pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight);
				if (result == "FALSE") {
					alert("<spring:message code='ezApprovalG.t1282'/>");
				} else {
					alert("<spring:message code='ezApprovalG.t1281'/>");
				}
				
				getSealListInfo();
			}
		}
		
		function insertSealInfo(pSealNum, pSealName, pSealPath, pSealWidth, pSealHeight) {
			var tempRet = "";
			
			$.ajax({
				type : "POST",
				url : "/admin/ezApprovalG/insertSealInfo.do",
				async : false,
				data : {
					pSealNum : pSealNum, 
					pSealName : pSealName,
					pSealPath : pSealPath,
					pSealWidth : pSealWidth,
					pSealHeight : pSealHeight,
					pRegUserID : pUserID,
					pRegUserName : pUserName1,
					pRegUserName2 : pUserName2,
					companyID : pCompanyID
	    		},
	    		success : function (result) {
	    			tempRet = result;
	    		},
	    		error : function() {
	    			tempRet = "FALSE";
	    		}
	    	});
	    	
	    	return tempRet;
	    }
		
		var ezsealinfo_dialogArguments = new Array();
		function btnInfo_onclick() {
			var pSealList = new ListView();
			pSealList.LoadFromID("pSealList");
			
			var oSelRow = pSealList.GetSelectedRows();
			if (oSelRow.length > 0) {
				var parameter = new Array();
				parameter[0] = GetAttribute(oSelRow[0], "DATA1");
				parameter[1] = getNodeText(oSelRow[0].cells[0]);
				parameter[2] = escape(GetAttribute(oSelRow[0], "DATA2"));
				parameter[3] = getNodeText(oSelRow[0].cells[1]);
				parameter[4] = getNodeText(oSelRow[0].cells[2]);
				parameter[5] = getNodeText(oSelRow[0].cells[3]);
				parameter[6] = getNodeText(oSelRow[0].cells[4]);
				parameter[7] = GetAttribute(oSelRow[0], "DATA3")
				parameter[8] = getNodeText(oSelRow[0].cells[5]);
				parameter[9] = "";  // 현재 선택된 부서ID (부서직인 관리 시에만 사용되므로, 공백으로 넘김)
                parameter[10] = pCompanyID;  // 현재 선택된 회사ID
				
				ezsealinfo_dialogArguments[0] = parameter;
				ezsealinfo_dialogArguments[1] = btnInfo_onclick_complete;
				ezsealinfo_dialogArguments[2] = btnInfo_onDelete_Complete; // 관인삭제 후 동작
				
				var ezSealInfo = window.open("/admin/ezApprovalG/sealInfo.do", "ezSealInfo", GetOpenWindowfeature(510, 470));
				try { ezSealInfo.focus(); } catch (e) {}
			} else {
				alert("<spring:message code='ezApprovalG.t1280'/>");
			}
		}
		
		function btnInfo_onDelete_Complete() {
	    	getSealListInfo();
	    }
		
		function btnInfo_onclick_complete() {
			
		}
		
		function btnDel_onclick() {
			var pSealList = new ListView();
			pSealList.LoadFromID("pSealList");
			
			var oSelRow = pSealList.GetSelectedRows();
			if (oSelRow.length > 0) {
				if (oSelRow[0].childNodes[4].innerHTML.trim() == "") {
					if (confirm("<spring:message code='ezApprovalG.t999933'/>")) {
						var pSealNum = GetAttribute(oSelRow[0], "DATA1");
						var rtnVal = "";
						
						$.ajax({
							type : "POST",
							url : "/admin/ezApprovalG/deleteSealInfo.do",
							async : false,
							data : {
								pSealNum : pSealNum, 
								companyID : pCompanyID
							},
							success : function (result) {
								rtnVal = result;
							},
							error : function() {
								rtnVal = "FALSE";
							}
						});
						
						if (rtnVal == "FALSE") {
							alert("<spring:message code='ezBoard.t1020'/>");
						} else {
							alert("<spring:message code='ezBoard.t268'/>");
						}
						
						getSealListInfo();
					}
				} else {
					alert("<spring:message code='ezAttitude.t99'/>");
				}
			}
		}
		</script>
	</head>

	<body  class="mainbody">
		<h1>
			<spring:message code = 'ezApprovalG.t1283' />
			<select id="ListCompany" name="SCompID" class="companySelect" onChange="selectCompanyID()">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userInfo.companyID ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</h1>
		
		<div id="mainmenu">
			<ul>
				<li><span onClick="return btnAdd_onclick()" ><spring:message code = 'ezApprovalG.t1261' /></span></li>
				<li><span onClick="return btnInfo_onclick()"><spring:message code = 'ezApprovalG.t1284' /></span></li>
				<li><span class="icon16 icon16_delete" onClick="return btnDel_onclick()"></span></li>
			</ul>
		</div>

		<div class="listview" style="width:790px; height:550px; overflow-y:auto; overflow-x:hidden" >
			<div id=lvSeal class="text" style="OVERFLOW-Y:auto; overflow-x:auto; border:0; width:790px; height:550px;"></div>
		</div>

		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
	</body>
	
	<xml id='LISTHEADER' style="display:none">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1271' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1272' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1273' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t831' /></NAME>
					<WIDTH>120</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1265' /></NAME>
					<WIDTH>120</WIDTH>
				</HEADER>
				<HEADER>
					<NAME><spring:message code = 'ezApprovalG.t1274' /></NAME>
					<WIDTH>100</WIDTH>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
	</xml>
</html>
