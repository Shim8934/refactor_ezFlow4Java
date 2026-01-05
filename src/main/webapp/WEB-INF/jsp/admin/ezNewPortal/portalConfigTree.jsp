<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='ezSystem.w019' /></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" type="text/css">

	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/TreeView.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>

	<script type="text/javascript" language="javascript">
		var pUse_Editor = "<c:out value='${use_editor}'/>";
		var totalCnt = 0;
		var CurPage = 1;
		var totalPage = 0;
		var pageSize = 15;
		var BlockSize = 10;
		var isAdmin = "";
		var companyID = "<c:out value='${companyId}'/>";

		var selectConfig = function (event) {

			checkItems();
			//rowList
			if (rowList.length == 0) {
				alert("<spring:message code='ezSystem.w005' />");
				return;
			}

			var configCode = rowList[0].getAttribute("id");
			var configDescription = rowList[0].getAttribute("data");
			var portletId = "<c:out value='${portletId}'/>";

			if (portletId == "null") {
				window.opener.document.getElementById("newPortletConnection").value = configDescription;
				window.opener.document.getElementById("newPortletConnection").setAttribute("value", configDescription);
				window.opener.document.getElementById("newPortletConnection").setAttribute("data1", configCode);
			} else {
				window.opener.document.getElementById("portletConnection" + portletId).value = configDescription;
				window.opener.document.getElementById("portletConnection" + portletId).setAttribute("value", configDescription);
				window.opener.document.getElementById("portletConnection" + portletId).setAttribute("data1", configCode);
			}

			window.close();
		}

		document.onselectstart = function () {
			if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
				return false;
			else
				return true;
		};

		var topid = "";
		var Tab1_flag = true;
		var DelType = "c";

		$(document).ready(function () {
			SystemConfig_List();
			//2018-08-06 김보미 - 페이지 위치 고정
			windowResize();
		});

		//2018-08-06 김보미 - 페이지 위치 고정
		$(window).on("resize", function () {
			windowResize();
		});

		function windowResize() {
			var height = document.documentElement.clientHeight - 130;
			if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
				height = height - 30;
			}
			document.getElementById("contentlist").style.height = height + "px";
			document.getElementById("contentlist").style.overflow = "auto";
		}

		function searchList() {
			CurPage = 1;
			SystemConfig_List();
		}

		function SystemConfig_List() {
			var typeCode = document.getElementById('typeSelect').value;
			
			$.ajax({
				type: "POST",
				dataType: "text",
				url: "/admin/ezSystem/getSystemConfigListPopup.do",
				data: { companyID: companyID, typeCode : typeCode, pageNum: CurPage, pageSize: pageSize, searchType: "displayname", searchValue: document.getElementById("searchValue").value },
				success: function (xml) {
					result = loadXMLString(xml);
					if (result.xml != "") {
						if (result.documentElement.getElementsByTagName("TOTALCNT")[0] != null) {
							totalCnt = getNodeText(result.documentElement.getElementsByTagName("TOTALCNT")[0]);
							totalPage = Math.ceil(new Number(totalCnt / pageSize));
						}
					} else {
						totalCnt = 0;
						totalPage = 0;
					}
					var xmldom = result;
					var headerData = createXmlDom();
					headerData = loadXMLString(listviewheader.innerHTML.toUpperCase());

					if (CrossYN()) {
						var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
						var Node = headerData.importNode(xmlRtn, true);
						headerData.documentElement.appendChild(Node);
					} else {
						var xmlRtn = xmldom.documentElement.getElementsByTagName("ROWS")[0];
						headerData.documentElement.appendChild(xmlRtn);
					}
					
					var adminListView = document.getElementById("AdminListView");
					while (adminListView.firstChild) {
						adminListView.removeChild(adminListView.firstChild);
					}

					var listview = new ListView();
					listview.SetID("lvConfigList");
					listview.SetMulSelectable(false);
					listview.SetRowOnClick("listViewClick");
					listview.SetRowOnDblClick("ListViewNodeDblClick");
					listview.SetHeightFree(true);
					listview.DataSource(headerData);
					listview.DataBind("AdminListView");
					checkbox_header();

					var a = document.getElementById("lvConfigList_TR_0");

					if (a == null || a == "") {

					} else {
						a.style.backgroundColor = "rgb(255, 255, 255)";
						a.setAttribute("selected", "false");
						$("#lvConfigList_TR_0").mouseout(function () {
							$("#lvConfigList_TR_0").css("background-color", "rgb(255, 255, 255)");
						});
					}
					rowListSelect();
					checkItems();
					makePageSelPage();
				},
				error: function (error) {
					alert("<spring:message code='ezSystem.w015' />" + error);
				}
			});
		}

		var cnt;
		function checkbox_header() {
			var doc = window.document;
			var th = doc.getElementById("lvConfigList_TH_0");
			var acList = doc.getElementById("lvConfigList");

			th.innerHTML = "<div class='custom_radio'><input type= 'radio' id = 'checkAll' onchange= 'checkboxHeaderClick()' style='display:none;'/></div>";

			cnt = acList.children[1].childElementCount;

			var noItemsChk = acList.children[1].children[0].getAttribute("id");

			if (cnt <= 1 && noItemsChk == "lvConfigList_TR_noItems") {
				return;
			}

			var i = 0;
			for (i; i < cnt; i++) {
				var seq = acList.children[1].children[i].children[0].innerHTML;

				acList.children[1].children[i].children[0].innerHTML = "<div class='custom_radio'><input type='radio' name='checks' class='checks' id='"
					+ seq
					+ "' value='"
					+ seq
					+ "' data='" + acList.children[1].children[i].children[3].innerHTML + "'/></div>"
			}
		}

		var checkFlag = false;
		function checkboxHeaderClick() {
			var doc = window.document;
			var acList = doc.getElementById("lvConfigList");
			// 데이터가 있을 경우에만
			if (acList.children[1].children[0].id !== 'lvConfigList_TR_noItems') {
				if (checkFlag) {
					checkFlag = false;
					$(".checks").prop("checked", false);
					$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
				} else {
					checkFlag = true;
					$(".checks").prop("checked", true);
					$("#contentlist tr td").css("background-color", "rgb(241, 248, 255)");
				}
				checkItems();
			}
		}

		//등록, 수정 , 삭제 후 rowSelect 선택 method
		function rowListSelect() {
			var len = rowList.length;
			for (var i = 0; i < len; i++) {
				var tempItemSeq = rowList.pop();
				if (document.getElementById(tempItemSeq) != null) {
					$("#" + tempItemSeq).prop("checked", true);
					var tempID = $("#" + tempItemSeq)[0].parentNode.parentNode.id;
					$("#" + tempID + " td").css("background-color",
						"rgb(241, 248, 255)");
				}
			}

			if (checkFlag) {
				$("#checkAll").prop("checked", true);
			} else {
				$("#checkAll").prop("checked", false);
			}
		}

		var rowList = new Array();
		function checkItems() {
			rowList = [];
			$("input:radio[name='checks']").each(function () {
				if ($(this).is(":checked")) {
					rowList.push(this);
				}
			});
		}

		var itemseq;

		function goToPageByNum(Value) {
			CurPage = Value;
			makePageSelPage();
			movePage(CurPage);
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
			if (parseInt(pageNum + 1) <= totalPage) {
				goToPageByNum(parseInt(pageNum + 1));
			} else {
				return;
			}
		}

		function movePage(newPage) {
			if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
				CurPage = newPage;
				SystemConfig_List();
			}
		}

		function makePageSelPage() {
			checkFlag = false;
			var strtext;
			var PagingHTML = "";
			document.getElementById("tblPageRayer").innerHTML = "";
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
					strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
					PagingHTML += strtext;
				}
			}

			if (i == 1) {
				strtext = "<span class='on'>" + i + "</span>";
				PagingHTML += strtext;
			}

			if (totalPage > BlockSize) {
				if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
					strtext = "";
					strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
					PagingHTML += strtext;
				} else {
					strtext = "";
					strtext = strtext + "<span class='btnimg next disabled'></span>";
					PagingHTML += strtext;
				}
			} else {
				strtext = "";
				strtext = strtext + "<span class='btnimg next disabled'></span>";
				PagingHTML += strtext;
			}

			if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
				strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
				PagingHTML += strtext;
			} else {
				strtext = "<span class='btnimg last disabled'></span>";
				PagingHTML += strtext;
			}

			PagingHTML += "</div>";
			
			var pageLayer = document.getElementById("tblPageRayer");
			while (pageLayer.firstChild) {
				pageLayer.removeChild(pageLayer.firstChild);
			}
			pageLayer.insertAdjacentHTML('beforeend', PagingHTML);
		}

		function listViewClick(obj) {
			var className = window.event.target.getAttribute('class');
			if (className === 'checks') {
				return;
			}

			var doc = window.document;
			itemseq = document.getElementById(obj).getAttribute("DATA1");
			if (itemseq == "0") {
				return;
			}

			itemNode = document.getElementById(obj).firstChild.firstChild;
			if (checkFlag) {
				if (itemNode.checked == true) {
					$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
					itemNode.checked = false;
				} else {
					$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
					itemNode.checked = true;
				}
			} else {
				$("#contentlist tr td").css("background-color", "rgb(255, 255, 255)");
				$(".checks").prop("checked", false);
				if (itemNode.checked == true) {
					$("#" + obj + " td").css("background-color", "rgb(255, 255, 255)");
					itemNode.checked = false;
				} else {
					$("#" + obj + " td").css("background-color", "rgb(241, 248, 255)");
					itemNode.checked = true;
				}
			}

			checkItems();
			
		}
		
		function ListViewNodeDblClick() {
			var listview = new ListView();
	        listview.LoadFromID("lvConfigList");
			var Params = new Array();
	        var tr = listview.GetSelectedRows();
	        if (tr.length != 0) {
	        	var pCode = tr[0].getAttribute("DATA1");
	        	if (pCode != "") {
		        	if (CrossYN()) {
		        		var OpenWin = window.open("/admin/ezSystem/addSystemConfig.do?CODE=" + pCode + "&companyID=" + companyID + "&mode=view", "Add_SystemConfig", GetOpenWindowfeature(700, 520));
			            try { OpenWin.focus(); } catch (e) { }
			        } else {
			        	window.showModalDialog("/admin/ezSystem/addSystemConfig.do?CODE=" + pCode + "&companyID=" + companyID + "&mode=view", Params, "dialogHeight:580px; dialogWidth:970px; status:no;scroll:no; help:no; edge:sunken; resizable:no" + GetShowModalPosition(1000, 620));
			        }
	        	}
	        }
		}
		
		function selectType() {
			clearSearchVal();
			SystemConfig_List();
		}
		
		function clearSearchVal() {
			document.getElementById('searchValue').value = "";
		}
		
	</script>
</head>
<body class="popup">
	<xml id="listviewheader" style="display:none">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<WIDTH>24</WIDTH>
					<STYLE>
						border-top:0px;
					</STYLE>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezSystem.w001' /></NAME>
					<WIDTH>24%</WIDTH>
					<STYLE>
						border-top:0px;
					</STYLE>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezSystem.w002' /></NAME>
					<WIDTH>37%</WIDTH>
					<STYLE>
						border-top:0px;
					</STYLE>
				</HEADER>
				<HEADER>
					<NAME><spring:message code='ezSystem.w003' /></NAME>
					<WIDTH>37%</WIDTH>
					<STYLE>
						border-top:0px;
					</STYLE>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
	</xml>
	<h1><spring:message code='ezSystem.w019' />
		<span class="title_bar"><img src="/images/name_bar.gif"></span>
		<select id = "typeSelect" onchange="selectType()">
			<option value="ALL"><spring:message code='ezSystem.config.hth01' /></option>
			<c:forEach var="configType" items="${configTypeList}">
				<c:choose>
					<c:when test="${configType.typeCode eq typeCode}">
						<option value="${configType.typeCode}" selected>${configType.typeName}</option>
					</c:when>
					<c:otherwise>
						<option value="${configType.typeCode}">${configType.typeName}</option>
					</c:otherwise>
				</c:choose>
			</c:forEach>
		</select>
		<span class="searchForm">
			<input id="searchValue" class="searchinputBox" onkeypress="if(event.keyCode==13) {searchList(); return false;}" onfocus="clearSearchVal();" style="ime-mode: active;height: 27px;border: 1px solid #cbcbcb;">
			<a class="searchBtn nofilter"><img src="/images/bsearch_new2.png" border="0" onclick="searchList()"></a>
		</span>
	</h1>
	
	<div id="contentlist" style="border:1px solid #ddd;">
        <div class="listview" style="border:0px">
            <div id="AdminListView" style="BORDER: 0;"></div>
        </div>
    </div>
    <div id="tblPageRayer" style="Width:100%;text-align:center;"></div>
	<div id="tblPageRayer" style="Width:100%;text-align:center;"></div>
	<div id="selConfig" class="btnposition btnpositionNew"><a class="imgbtn" onclick="selectConfig()"><span><spring:message code='ezNewPortal.t049' /></span></a></div>
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup" style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>