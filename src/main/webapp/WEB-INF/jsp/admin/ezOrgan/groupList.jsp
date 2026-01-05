<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<!DOCTYPE html>
<html>
<head>
<title>mail_distributionlist</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}"
	type="text/css">
<style>
.mainlist_free tr th {
	border-top: 0px;
}

.mainlist_free tr td:first-child {
	padding-left: 10px;
}

.mainlist_free tr th:first-child {
	padding-left: 10px;
}

.selectedTR td:not (:first-child ), .unselectedTR td:not (:first-child )
	{
	overflow: hidden;
	white-space: nowrap;
	text-overflow: ellipsis;
}

.selectedTR {
	background-color: #f1f8ff;
	cursor: pointer;
}

.unselectedTR:hover {
	background-color: #f4f5f5;
	cursor: pointer;
}

.imgbtn{ 
	height:24px;
	margin-bottom:4px;
}
.imgbtn span{
	height:24px;
	line-height:24px;

}

</style>
<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
<script type="text/javascript"
	src="${util.addVer('/js/mouseeffect.js')}"></script>
<script type="text/javascript"
	src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script type="text/javascript"
	src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
<script type="text/javascript"
	src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script type="text/javascript">
	var companyId = "${userCompany}";
	var CurPage = 1;
	var totalPage = "${totalPage}";
	var totalCount = "${totalCount}";
	var BlockSize = 10;
	var lang = "${lang}";
	var CheckBoxArr = new Array();

	document.onselectstart = function() {
		if (event.srcElement.tagName != "INPUT"
				&& event.srcElement.tagName != "TEXTAREA")
			return false;
		else
			return true;
	};

	window.onload = function() {
		if (document.all("ListCompany") != null
				&& document.all("ListCompany").length == 0)
			alert("<spring:message code='ezEmail.t49' />");
		else {
			getPermissionGroupList();
		}
	}

	var xmlHTTP = createXMLHttpRequest();

	function show_member(obj) {
		var pheight = window.screen.availHeight;
		var pwidth = window.screen.availWidth;
		var pTop = (pheight - 450) / 2;
		var pLeft = (pwidth - 420) / 2;
		window
				.open(
						"/ezCommon/showPersonInfo.do?id=" + obj.id + "&dept=",
						"",
						"height=450px,width=420px, top="
								+ pTop.toString()
								+ ", left="
								+ pLeft.toString()
								+ ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
	}

	/* 2020-07-13 홍승비 - 권한그룹 삭제 시 다국어 추가, 잘못된 메세지 수정 */
	function del_dl() {
		funCheckBox('get');

		if (CheckBoxArr.length == 0) {
			alert("<spring:message code='ezOrgan.hsbPg01'/>");
			return;
		}
		var ret = confirm("<spring:message code='ezOrgan.hsbPg04' arguments='" + CheckBoxArr.length + "'/>");

		if (ret) {
			var data = "";
			for (var i = 0; i < CheckBoxArr.length; i++) {
				data += CheckBoxArr[i];

				if (i != CheckBoxArr.length - 1) {
					data = data + ",";
				}
			}

			$.ajax({
				type : "POST",
				dataType : "html",
				url : "/admin/ezOrgan/deletePermissionGroupList.do",
				async : true,
				data : {
					groupList : data,
					companyID : companyId
				},
				success : function(result) {
					setTimeout(function() {
						if (result == "OK") {
							alert(CheckBoxArr.length + "<spring:message code='ezOrgan.hsbPg03' />");
						} else {
							alert("<spring:message code='ezOrgan.hsbPg02' />")
						}

						getPermissionGroupList();
					}, 100);
				},
				error : function() {
					setTimeout(function() {
						alert("<spring:message code='ezOrgan.hsbPg02' />");

						getPermissionGroupList();
					}, 100);
				}
			});
		}
	}

	var mail_add_distributionlist_cross_dialogArguments = new Array();
	function add_dl() {
		companyId = $("#ListCompany option:selected").val();
		var feature = "dialogHeight:670px; dialogWidth:970px; scroll:no;status:no; help:no; edge:sunken";
		feature = feature + GetShowModalPosition(970, 670);
		if (CrossYN()) {
			mail_add_distributionlist_cross_dialogArguments[0] = companyId;
			mail_add_distributionlist_cross_dialogArguments[1] = add_dl_Complete;
			var OpenWin = window.open("/admin/ezOrgan/addGroup.do?companyId="
					+ companyId, "", GetOpenWindowfeature(970, 670));
			try {
				OpenWin.focus();
			} catch (e) {
			    console.log(e);
			}
		} else {
			var rtnValue = window.showModalDialog("/admin/ezOrgan/addGroup.do",
					companyId, feature);
			if (typeof (rtnValue) != "undefined")
				getPermissionGroupList();
		}
	}
	
	function add_dl2() {
		companyId = $("#ListCompany option:selected").val();
		var feature = "dialogHeight:670px; dialogWidth:970px; scroll:no;status:no; help:no; edge:sunken";
		feature = feature + GetShowModalPosition(970, 670);
		if (CrossYN()) {
			mail_add_distributionlist_cross_dialogArguments[0] = companyId;
			mail_add_distributionlist_cross_dialogArguments[1] = add_dl_Complete;
			var OpenWin = window.open("/admin/ezOrgan/addGroupForReference.do?companyId="
					+ companyId, "", GetOpenWindowfeature(970, 670));
			try {
				OpenWin.focus();
			} catch (e) {
			    console.log(e);
			}
		} else {
			var rtnValue = window.showModalDialog("/admin/ezOrgan/addGroupForReference.do",
					companyId, feature);
			if (typeof (rtnValue) != "undefined")
				getPermissionGroupList();
		}
	}

	function add_dl_Complete(rtnValue) {
		if (typeof (rtnValue) != "undefined")
			getPermissionGroupList();
	}

	/* 2020-07-13 홍승비 - 권한그룹 편집 시 다국어 추가, 잘못된 메세지 수정 */
	function mod_dl(groupID, groupName) {
		funCheckBox('get');
		var length = CheckBoxArr.length;

		if (length == 0) {
			alert("<spring:message code='ezOrgan.hsbPg05' />");
			return;
		} else if (length > 1) {
			alert("<spring:message code='ezOrgan.hsbPg06' />");
			return;
		}
		
		if (groupID == undefined || groupID == "") {
			groupID = CheckBoxArr;
		}
		
		if (groupName == undefined || groupName == "") {
			for (var i = 0; i < document.getElementsByName("chk").length; i++) {
				if (document.getElementsByName("chk").item(i).checked == true) {
					groupName = document.getElementsByName("chk").item(i).className;
				}
			}
		}
		
		var feature = "dialogHeight:670px; dialogWidth:970px; scroll:no;status:no; help:no; edge:sunken";
		feature = feature + GetShowModalPosition(970, 670);
		if (CrossYN()) {
			mail_add_distributionlist_cross_dialogArguments[0] = companyId;
			mail_add_distributionlist_cross_dialogArguments[1] = add_dl_Complete;
			var OpenWin = window.open("/admin/ezOrgan/addGroup.do?companyId="
					+ companyId + "&cn=" + groupID + "&name=" + encodeURI(encodeURIComponent(groupName)), "",
					GetOpenWindowfeature(970, 670));
			try {
				OpenWin.focus();
			} catch (e) {
			    console.log(e);
			}
		} else {
			var rtnValue = window.showModalDialog("/admin/ezOrgan/addGroup.do",
					companyId + "&cn=" + groupID + "&name=" + groupName,
					feature);
			if (typeof (rtnValue) != "undefined")
				getPermissionGroupList();
		}
	}

	function funCheckBox(mode) {
		CheckBoxArr = new Array();

		if (mode == 'get') {
			for (var i = 0; i < document.getElementsByName("chk").length; i++) {
				if (document.getElementsByName("chk").item(i).checked == true) {
					CheckBoxArr[CheckBoxArr.length] = document.getElementsByName("chk").item(i).value;
				}
			}
		}
		if (mode == 'set') {
			for (var i = 0; i < document.getElementsByName("chk").length; i++) {
				if (document.getElementsByName('checkbox').item(0).checked == true) {
					document.getElementsByName("chk").item(i).checked = true;
					document.getElementsByName("chk").item(i).closest('tr').className = "selectedTR";
				} else {
					document.getElementsByName("chk").item(i).checked = false;
					document.getElementsByName("chk").item(i).closest('tr').className = "unselectedTR";
				}
			}
		}
	}

	//검색 버튼 클릭시 이벤트
	function search() {
		CurPage = 1;

		getPermissionGroupList();
	}

	function getPermissionGroupList() {
		companyId = $("#ListCompany option:selected").val();

		$
				.ajax({
					type : "POST",
					async : false,
					dataType : "json",
					url : "/admin/ezOrgan/getPermissionGroupList.do",
					data : {
						"page" : CurPage,
						"searchKeycode" : $('#searchKeycode').val(),
						"searchKeyword" : $('#searchKeyword').val(),
						"searchCompanyID" : $("#ListCompany").val()
					},
					success : function(data) {
						CurPage = data.pPage;
						totalPage = data.totalPage;
						totalCount = data.totalCount;
						lang = data.lang;

						var html = "";

						if (totalCount < 1) {
							html = "";
							html += "<tr>";
							html += "    <td colspan='6' style='text-align:center' bgcolor='#FFFFFF'><spring:message code='ezOrgan.0hun07'/></td>";
							html += "</tr>";
							
							// 전체삭제 후 header checkbox 해제하기 위해 추가
						    if (document.getElementsByName('checkbox').item(0).checked == true) {
                                document.getElementsByName('checkbox').item(0).checked = false;
                            }
						} else {
							data.list
									.forEach(function(i, v) {
										html += "<tr class='unselectedTR' onclick='clickRow(event)' ondblclick=\"mod_dl('"
												+ i.groupID
												+ "', '"
												+ i.groupName + "')\">";
										html += "    <td style='width:30px;'>";
										html += "        <div class='custom_checkbox'><input type='checkbox' onclick='selectCheckBox()' id='chk' name='chk' value='"
												+ i.groupID + "' class='" + i.groupName + "'/></div>";
										html += "    </td>";
										html += "<td style='cursor:pointer; width: 20%;'>"
												+ i.groupName + "</td>";
										html += "<td style='width: 20%;'>"
												+ (i.createID != null ? i.createID
														: " ") + "</td>";
										html += "<td style='width: 20%;'>"
												+ (i.createDate != null ? i.createDate
														: " ") + "</td>";
										html += "<td style='width: 20%;'>"
												+ (i.updateID != null ? i.updateID
														: " ") + "</td>";
										html += "<td style='width: 20%;'>"
												+ (i.updateDate != null ? i.updateDate
														: " ") + "</td>";
										html += "</tr>";
									});
						}

						$("#mainListBody").empty().append(html);
						scroll();
					},
					error : function(error) {
						alert("<spring:message code='ezOrgan.0hun08' />");
					}
				})
		makePageSelPage();
	}

	//2018-08-06 김보미 - 페이지 위치 고정
	$(window).on("resize", function() {
		windowResize();
	});

	function windowResize() {
		/* var height = document.documentElement.clientHeight - 244;
		
		if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
			height = height - 30;
		}
		
		document.getElementById("contentlist").style.height = height + "px";
		 */
		document.getElementById("ListBody").style.height = (document.documentElement.clientHeight - 300)
				+ "px";
	}

	$(function() {
		windowResize();
	});

	function makePageSelPage() {
		var strtext;
		var PagingHTML = "";
		document.getElementById("tblPageRayer").innerHTML = "";
		document.getElementById("TitleInfo").innerHTML = "&nbsp;<span class='txt_color'>"
				+ totalCount + "</span>";
		strtext = "<div class='pagenavi'>";
		PagingHTML += strtext;
		var pageNum = CurPage;

		if (totalPage > 1 && pageNum != 1) {
			strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='btnimg first disabled'></span>";
			PagingHTML += strtext;
		}

		if (totalPage > BlockSize) {
			if (pageNum > BlockSize) {
				strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
				PagingHTML += strtext;
			} else {
				strtext = "<span class='btnimg prev disabled'></span>";
				PagingHTML += strtext;
			}
		} else {
			strtext = "<span class='btnimg prev disabled'></span>";
			PagingHTML += strtext;
		}

		var MaxNum;
		var i;
		var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;

		if (totalPage >= (startNum + parseInt(BlockSize))) {
			MaxNum = (startNum + parseInt(BlockSize)) - 1;
		} else {
			MaxNum = totalPage;
		}

		for (i = startNum; i <= MaxNum; i++) {
			if (i == pageNum) {
				strtext = "<span class='on'>" + i + "</span>";
				PagingHTML += strtext;
			} else {
				strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i
						+ "</span>";
				PagingHTML += strtext;
			}
		}

		if (MaxNum == 0) {
			PagingHTML += "<span class=\"on\">" + 1 + "</span>";
		}

		if (totalPage > BlockSize) {
			if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
				strtext = "";
				strtext = strtext
						+ "<span class='btnimg next' onclick='return selafterBlock()'></span>";
				PagingHTML += strtext;
			} else {
				strtext = "";
				strtext = strtext
						+ "<span class='btnimg next disabled'></span>";
				PagingHTML += strtext;
			}
		} else {
			strtext = "";
			strtext = strtext
					+ "<span class='btnimg next disabled'></span>";
			PagingHTML += strtext;
		}

		if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
			strtext = "<span class='btnimg last' onclick='return goToPageByNum("
					+ totalPage
					+ ")'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='btnimg last disabled'></span>";
			PagingHTML += strtext;
		}

		PagingHTML += "</div>";
		td_Create1(PagingHTML);
	}

	function td_Create1(strtext) {
		document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
	}

	function clickRow(event) {
		var currentRow = event.currentTarget;
		var crrClass = currentRow.className;

		var tableList = document.getElementById("mainListBody");
		var length = tableList.rows.length;

		for (var i = 0; i < length; i++) {
			tableList.rows[i].className = "unselectedTR";
			tableList.rows[i].querySelector('input[type="checkbox"]').checked = false;
		}

		currentRow.className = "selectedTR";
		currentRow.querySelector('input[type="checkbox"]').checked = true;
	}

	function selectCheckBox() {
		event.stopPropagation();

		var checkboxElmt = event.currentTarget;
		var currentRow = checkboxElmt.closest('tr');

		if (checkboxElmt.checked) {
			currentRow.className = "selectedTR";
		} else {
			currentRow.className = "unselectedTR";
		}
	}

	function goToPageByNum(Value) {
		document.getElementById("checkAll").checked = false;
		CurPage = Value;
		getPermissionGroupList();
	}

	function selbeforeBlock() {
		var pageNum = parseInt(CurPage);
		pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		goToPageByNum(pageNum);
	}

	function selbeforeBlock_one() {
		var pageNum = parseInt(CurPage);

		if (parseInt(pageNum - 1) > 0) {
			goToPageByNum(parseInt(pageNum - 1));
		} else {
			return;
		}
	}

	function selafterBlock() {
		var pageNum = parseInt(CurPage);
		pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		goToPageByNum(pageNum);
	}

	function selafterBlock_one() {
		var pageNum = parseInt(CurPage);

		if (parseInt(pageNum + 1) <= sTotalPage) {
			goToPageByNum(parseInt(pageNum + 1));
		} else {
			return;
		}
	}
</script>
</head>
<body class="mainbody chk_lower_4">
	<form id="Form1" method="post">
		<h1>
			<spring:message code='ezOrgan.zNo004' /><span id="TitleInfo"></span> <span class="title_bar"><img
				src="/images/name_bar.gif"></span> <select name="ListCompany"
				id="ListCompany" onchange="getPermissionGroupList()"
				style="margin-bottom: 10px;">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>"
						${item.cn == userCompany ? 'selected' : ''}><c:out
							value='${item.displayName}' /></option>
				</c:forEach>
			</select>
		</h1>
		<div id="mainmenu">
			<ul>
				<li class="important"><span onClick="add_dl()"><spring:message code='ezOrgan.zNo005' /></span></li>
				<li><span onClick="mod_dl()"><spring:message code='ezOrgan.zNo006' /></span></li>
				<!-- <li><span onClick="add_dl2()">권한등록창(예시)</span></li> --> 
				<li><span class="icon16 icon16_delete" onClick="del_dl()"></span></li>
			</ul>
		</div>
		<div style="WIDTH: 100%; box-sizing: border-box;">
			<div id="userSearchRayer"
				style="float: right; display: inline-block; margin-right: 2px;">
				<select id="searchKeycode" style="height: 26px; width: 120px;">
					<option value="GROUPNAME"><spring:message code='ezEmail.t710' /></option>
					<!-- 그룹이름 -->
					<option value="CREATEID"><spring:message code='ezOrgan.zNo007' /></option>
					<!-- 그룹아이디 -->
				</select> <input id="searchKeyword"
					onkeypress="if(event.keyCode==13) {search(); return false;}"
					autocomplete="off"
					style="height: 26px; border: 1px solid #cbcbcb; margin-top: 2px;">
				<a class="imgbtn" style="vertical-align: middle"><span
					onclick="search()"><spring:message code="ezStatistics.t36" /></span></a>
			</div>
		</div>


		<div>
			<!-- 검색 -->

			<script type="text/javascript">
				selToggleList(document.getElementById("mainmenu"), "ul", "li",
						"0");
			</script>

			<div id="contentlist"
				style="width: 100%; margin-top: 5px; overflow: hidden;">
				<div id="ListHeader">
					<table id="mainListHeader" class="mainlist" style="width: 100%">
						<thead>
							<tr id="mainListHeaderTr">
								<th style="width: 30px;">
								    <div class="custom_checkbox">
								        <input type='checkbox' name="checkbox" id="checkAll" onclick="funCheckBox('set','a')" />
                                    </div>
                                </th>
								<th style="width: 20%;"><spring:message code="ezEmail.t710" /></th>
								<th style="width: 20%;"><spring:message code="ezOrgan.zNo007" /></th>
								<th style="width: 20%;"><spring:message code="ezOrgan.zNo009" /></th>
								<th style="width: 20%;"><spring:message code="ezAttitude.t62" /></th>
								<th style="width: 20%;"><spring:message code="ezAttitude.t63" /></th>
							</tr>
						</thead>
					</table>
				</div>

				<div id="ListBody" style="height: 600px; overflow-y: auto;">
					<table id="mainListBody" class="mainlist" style="width: 100%;"></table>
				</div>
			</div>

			<div
				style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0, 0, 0, 0.5); display: none;"
				id="progressPanel">&nbsp;</div>
			<span class="loading_layer"
				style="z-index: 6000; position: absolute; top: 350px; left: 350px; display: none;"
				id="loadingLayer"><span class="right"><img
					src="/images/loading/loading.gif" width="24" height="24">
				<spring:message code='ezEmail.t680' /></span></span>
			<!--      	<br/> -->
			<div id="tblPageRayer"></div>
		</div>
	</form>
</body>
</html>



