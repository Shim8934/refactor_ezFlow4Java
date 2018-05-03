<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html style="height:100%">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>"   type="text/css">
		<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css"            type="text/css">
		<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css" type="text/css"/>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"                ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"                             ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"        ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"      ></script>
		<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
		<script type="text/javascript" src="/js/ezWebFolder/adminTable.js"                  ></script>
		<script type="text/javascript" >
			var blockSize    = 10;
			var currentPage  = null;
			var totalRows    = null;
			var totalPages   = null;
			var primary      = "<c:out value='${primary}'/>";
			var strLang39    = "<spring:message code='ezWebFolder.t135'/>";
			var strLang40    = "<spring:message code='ezWebFolder.t136'/>";
			var strLang41    = "<spring:message code='ezWebFolder.t137'/>";
			var strLang42    = "<spring:message code='ezWebFolder.t138'/>";
			var strActType1  = "<spring:message code='ezWebFolder.t160'/>";
			var strActType2  = "<spring:message code='ezWebFolder.t161'/>";
			var strActType3  = "<spring:message code='ezWebFolder.t162'/>";
			var strActType4  = "<spring:message code='ezWebFolder.t111'/>";
			var strActType5  = "<spring:message code='ezWebFolder.t19' />";
			var strActType6  = "<spring:message code='ezWebFolder.t287'/>";
			var strNoData    = "<spring:message code='ezWebFolder.t144'/>";
			var startDateStr = "";
			var endDateStr   = "";
			var fileExtStr   = "";
			var fileNameStr  = "";
			var userNameStr  = "";
			
			window.onload = function () {
				$("#Sdatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				
				$("#Edatepicker").datepicker({
					changeMonth: true,
					changeYear: true,
					autoSize: true,
					showOn: "both",
					buttonImage: "/images/ImgIcon/calendar-month.gif",
					buttonImageOnly: true,
					dateFormat: "yy-mm-dd"
				});
				
				search_Set("1");
				preProcessing();
			}
			
			function preProcessing() {
				var divList          = document.getElementById("mainSetting");
				var reheight         = document.documentElement.clientHeight - 185;
				divList.style.height = reheight + "px";
			}
			
			function keyPressPanel(e) {
				if (e.which == 27 && document.getElementById("mailPanel").style.display == "") {openSearchPanel();}
			}
			
			function openSearchPanel() {
				var searchPanel = document.getElementById("searchPanel");
				if (searchPanel.style.display == "none") {
					window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "";
					document.getElementById("mailPanel").style.display                              = "";
					var position              = getPosition(516, 247);
					searchPanel.style.top     = position[0] + "px";
					searchPanel.style.right   = position[1] + "px";
					searchPanel.style.display = "";
				}
				else {
					window.parent.frames["left"].document.getElementById("bnkBlockLeft").style.display = "none";
					document.getElementById("mailPanel").style.display                              = "none";
					searchPanel.style.display = "none";
				}
				
				$("#Sdatepicker").datepicker('setDate', "");
				$("#Edatepicker").datepicker('setDate', "");
				document.getElementById("fileExtVal").value                = "";
				document.getElementById("fileNameVal").value               = "";
				document.getElementById("fileCreatorVal").value            = "";
				document.getElementById("fileTypeVal").options[0].selected = 'selected';
			}
			
			function search_Set(pPage) {
				$.ajax({
					type: "POST",
					url: "/admin/ezWebFolder/getFileLogs.do",
					data: {
						"currentPage" : pPage,
						"startDate"   : startDateStr,
						"endDate"     : endDateStr,
						"fileExt"     : fileExtStr,
						"fileName"    : fileNameStr,
						"userName"    : userNameStr,
						"fileType"    : document.getElementById("fileTypeSelect").value,
						"companyId"   : document.getElementById("companyList").value
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result  = data.fileLogList;
						totalRows   = data.totalRows;
						totalPages  = data.totalPages;
						currentPage = pPage;
						
						makePageSelPage();
						renderData(result);
					},
					error : function(error) {
						alert("<spring:message code='ezWebFolder.t134'/>" + error);
					}
				});
			}
			
			function renderData(result) {
				var tableView = new TableView();
				tableView.setTableId("tblFileHistory");
				tableView.setTableType("filelog");
				tableView.setSelectedClass("bnkWebFolder2");
				tableView.setUnselectClass("bnkWebFolder");
				tableView.setDataSource(result);
				tableView.renderTable();
			}
			
			function startSearch() {
				var sDateVal    = document.getElementById("Sdatepicker").value;
				var eDateVal    = document.getElementById("Edatepicker").value;
				var fileExtVal  = document.getElementById("fileExtVal").value;
				var fileNameVal = document.getElementById("fileNameVal").value;
				var userNameVal = document.getElementById("fileCreatorVal").value;
				var fileTypeIdx = document.getElementById("fileTypeVal").selectedIndex;
				document.getElementById("fileTypeSelect").selectedIndex = fileTypeIdx;
				
				if (!sDateVal && !eDateVal && !fileExtVal && !fileNameVal && !userNameVal) {
					alert("<spring:message code='ezWebFolder.t163'/>");
					return;
				}
				
				if ((!sDateVal && eDateVal) || (sDateVal && !eDateVal)) {
					alert("<spring:message code='ezWebFolder.t184'/>");
					return;
				}
				
				if (sDateVal && eDateVal) {
					if (sDateVal > eDateVal) {
						alert("<spring:message code='ezWebFolder.t164'/>");
						return;
					}
				}
				
				startDateStr = sDateVal;
				endDateStr   = eDateVal;
				fileExtStr   = fileExtVal;
				fileNameStr  = fileNameVal;
				userNameStr  = userNameVal;
				
				openSearchPanel();
				search_Set("1");
			}
			
			function change() {
				startDateStr = "";
				endDateStr   = "";
				fileExtStr   = "";
				fileNameStr  = "";
				userNameStr  = "";
				search_Set("1");
			}
			
			function getPosition(popUpW, popUpH) {
				var returnValue = new Array();
				var heigth      = window.parent.document.documentElement.clientHeight;
				if (heigth == 0) {heigth = window.parent.document.body.clientHeight;}
				
				var width = window.parent.document.documentElement.clientWidth;
				if (width == 0) {width = window.parent.document.body.clientWidth;}
				
				var pleftpos = parseInt(width) - popUpW;
				heigth       = parseInt(heigth) - popUpH;
				
				if (heigth < (popUpH + 50)) {
					returnValue[0] = (heigth / 2);
				}
				else {
					returnValue[0] = (heigth / 2) - 50;
				}
				
				returnValue[1] = pleftpos / 2;
				return returnValue;
			}
			
			function refreshView() {
				search_Set(currentPage);
			}
			
		</script>
	</head>
	<body class="mainbody" onresize="preProcessing();" onkeydown="keyPressPanel(event);">
		<h1>
			<spring:message code='ezWebFolder.t128'/>
			<span id="mailBoxInfo"></span>
		</h1>
		<div id="companySelect" style="margin: 10px 0px;">
			<span style="font-size: 12px; display: inline-block; vertical-align: middle;"><b><spring:message code='ezWebFolder.t129'/></b></span>
			<select id="companyList" style="font-size: 12px; height: 20px; display: inline-block;" onchange="change();">
				<c:forEach var="item" items="${list}">
					<option value="<c:out value='${item.cn}'/>" ${item.cn == userCompany ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
				</c:forEach>
			</select>
		</div>
		
		<div id="mainmenu2" style="position: relative;">
			<ul>
				<li id=""><a id="btnSearch"  style="margin-top: 3px;" onClick="openSearchPanel();"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
				<li id=""><a id="btnRefresh" style="margin-top: 3px;" onClick="refreshView();"><span><spring:message code='ezWebFolder.t139'/></span></a></li>
				<li id="">
					<select style="height: 29px; border-radius: 3px; padding: 0px; width: 85px;" id="fileTypeSelect" onchange="change();">
						<option value="1" selected><spring:message code='ezWebFolder.t191'/></option>
						<option value="2"         ><spring:message code='ezWebFolder.t192'/></option>
						<option value="3"         ><spring:message code='ezWebFolder.t193'/></option>
						<option value="4"         ><spring:message code='ezWebFolder.t194'/></option>
						<option value="5"         ><spring:message code='ezWebFolder.t195'/></option>
						<option value="6"         ><spring:message code='ezWebFolder.t196'/></option>
					</select>
				</li>
			</ul>
		</div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu2"), "ul", "li", "0");
		</script>
		
		<div id="searchPanel" style="z-index: 2000; position: fixed; height: auto; width: 514px; border: 1px solid #666666; background-color: #f2f2f2; display: none; border-radius: 8px; -webkit-box-shadow: 0 0 10px #000; -moz-box-shadow: 0 0 10px #000; -o-box-shadow: 0 0 10px #000; -ms-box-shadow: 0 0 10px #000; box-shadow: 0 0 10px #000;">
			<div style="margin: 10px;">
				<table class="content" style="border-collapse: collapse; width: 100%;">
					<tr>
						<th class="layerHeader" colspan="2"><img src="/images/webfolder/left_webfolder.png" style="vertical-align: middle;padding-bottom:1px">&nbsp;<spring:message code='ezWebFolder.t24'/></th>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t151'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input type="text" id="Sdatepicker" style="width:80px;text-align:center" readonly="readonly">
							~
							<input type="text" id="Edatepicker" style="width:80px;text-align:center" readonly="readonly">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t152'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileExtVal" type="text" style="height: 23px; width: 200px;">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t153'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileNameVal" type="text" style="height: 23px; width: 200px;">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t154'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<input id="fileCreatorVal" type="text" style="height: 23px; width: 200px;">
						</td>
					</tr>
					<tr>
						<th style="width: 100px; min-width: 100px; text-align: center;"><spring:message code='ezWebFolder.t188'/></th>
						<td style="border: 1px solid #b6b6b6; background-color: #fff; min-width: 367px; width: 367px;">
							<select style="height: 25px; padding: 0px; width: 85px;" id="fileTypeVal">
								<option value="1" selected><spring:message code='ezWebFolder.t191'/></option>
								<option value="2"         ><spring:message code='ezWebFolder.t192'/></option>
								<option value="3"         ><spring:message code='ezWebFolder.t193'/></option>
								<option value="4"         ><spring:message code='ezWebFolder.t194'/></option>
								<option value="5"         ><spring:message code='ezWebFolder.t195'/></option>
								<option value="6"         ><spring:message code='ezWebFolder.t196'/></option>
							</select>
						</td>
					</tr>
				</table>
				<div style="margin: 12px 0px; text-align: center;">
					<a class="webfolderBttn"><span onclick="startSearch();"    ><spring:message code='ezWebFolder.t123'/></span></a>
					<a class="webfolderBttn"><span onclick="openSearchPanel();"><spring:message code='ezWebFolder.t112'/></span></a>
				</div>
			</div>
			<span class="wfCloseBttn" onclick="openSearchPanel();"></span>
		</div>
		
		<div id="mainSetting" style="margin: 10px 0px; height:500px; overflow: auto;">
				<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileHistory">
				<tr>
					<th width="40px"  ><spring:message code='ezWebFolder.t155'/></th>
					<th width="220px" ><spring:message code='ezWebFolder.t156'/></th>
					<th width="60px"  ><spring:message code='ezWebFolder.t157'/></th>
					<th width="80px" ><spring:message code='ezWebFolder.t154'/></th>
					<th width="60px"  ><spring:message code='ezWebFolder.t158'/></th>
					<th width="120px" style="text-align: center;"><spring:message code='ezWebFolder.t159'/></th>
				</tr>
			</table>
		</div>
		
		<div id="tblPageRayer"></div>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
		<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"></script>
	</body>
</html>
