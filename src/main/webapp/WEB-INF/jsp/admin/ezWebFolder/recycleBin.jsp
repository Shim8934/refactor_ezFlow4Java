<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<!-- date Picker -->
	<script type="text/javascript" src="/js/jquery/dateControls/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.core.js"></script>
	<script type="text/javascript" src="/js/jquery/dateControls/jquery.ui.datepicker.js"></script>
	<link rel="stylesheet" href="/js/jquery/dateControls/jquery.ui.all.css">
	<script type="text/javascript" src="/js/ezOrgan/ListView_list.js"></script>
	
	<!-- time picker-->
	<script type="text/javascript" src="<spring:message code='ezWebFolder.e1'/>"></script>
	<script type="text/javascript" src="/js/ezWebFolder/popup.js"               ></script>
	<script type="text/javascript" src="/js/ezWebFolder/pageNav.js"             ></script>
	<script type="text/javascript" src="/js/ezWebFolder/adminTable.js"          ></script>
	
	<script type="text/javascript">
		var lang      = ${lang};
		var strErr    = "<spring:message code = 'ezWebFolder.t107'/>";
		var strLang39 = "<spring:message code = 'ezWebFolder.t135'/>";
		var strLang40 = "<spring:message code = 'ezWebFolder.t136'/>";
		var strLang41 = "<spring:message code = 'ezWebFolder.t137'/>";
		var strLang42 = "<spring:message code = 'ezWebFolder.t138'/>";
		var strNoData = "<spring:message code='ezWebFolder.t144'/>";
		
		var currentPage      = "1";
		var totalPages       = 0 ;
		var totalRows        = 0 ;
		var blockSize        = 10;
		var pStart           = 0;
		var pEnd             = 10;
		var fileCnt          = 0;
		var folderCnt        = 0;
		var trashCanList     = [];
		var searchFileType   = "";
		var enrollStartDate  = "";
		var enrollEndDate    = "";
		var delStartDate     = "";
		var delEndDate       = "";
		var searchExt        = "";
		var searchFileName   = "";
		var searchCreateName = "";
		var tableView        = new TableView();
		
		window.onresize = function () {
			var divList          = document.getElementById("dragDropArea");
			var reheight         = document.documentElement.clientHeight - 160;
			divList.style.height = reheight + "px";
		};
		
		document.onselectstart = function() {return false;}
		
		window.onload = function () {
			closeAllPopup();
			tableView.setTableId("tblFileList");
			tableView.setTableType("deletedfile");
			tableView.setSelectedClass("bnkWebFolder2");
			tableView.setUnselectClass("bnkWebFolder");
			tableView.setCallBack(refreshView);
			
			renderFileList();
			window.onresize();
		}
		
		window.onbeforeunload = function() {
			closeAllPopup();
		}
		
		$(function () {
			$.datepicker.regional["<spring:message code='main.t0619' />"] = {
				closeText: "<spring:message code='main.t3' />",
				prevText: "<spring:message code='main.t0604' />",
				nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
				monthNames: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				             "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				             "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				             "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				monthNamesShort: ["<spring:message code='main.t0607' />", "<spring:message code='main.t0608' />", "<spring:message code='main.t0609' />", 
				                  "<spring:message code='main.t0610' />", "<spring:message code='main.t0611' />", "<spring:message code='main.t0612' />",
				                  "<spring:message code='main.t0613' />", "<spring:message code='main.t0614' />", "<spring:message code='main.t0615' />", 
				                  "<spring:message code='main.t0616' />", "<spring:message code='main.t0617' />", "<spring:message code='main.t0618' />"],
				dayNames: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				           "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />",
				           "<spring:message code='main.t0627' />"],
				dayNamesShort: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				                "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				                "<spring:message code='main.t0627' />"],
				dayNamesMin: ["<spring:message code='main.t0621' />", "<spring:message code='main.t0622' />", "<spring:message code='main.t0623' />", 
				              "<spring:message code='main.t0624' />", "<spring:message code='main.t0625' />", "<spring:message code='main.t0626' />", 
				              "<spring:message code='main.t0627' />"],
				weekHeader: "Wk",
				dateFormat: "yy-mm-dd",
				firstDay: 0,
				isRTL: false,
				duration: 200,
				showAnim: "show",
				showMonthAfterYear: true
			};
			
			$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
		});
		
		function keyPressPanel(e) {
			if (e.which == 27 && document.getElementById("mailPanel").style.display == "") {
				if (document.getElementById("iFramePanel").style.display == "none") {
					doLayerPopup();
				}
				else {
					closeAllPopup();
				}
			}
		}
		
		function changeValue(value) {
			searchFileType = value;
			
			if( value == "all" ) {
				searchFileType = "";
			}
			
			currentPage = 1;
			refreshView();
		}
		
		function renderFileList() {
			var orderInf = tableView.getOrderInfo();
			var listCnt  = document.getElementById("listCount").value;
			showProgress();
			
			$.ajax ({
				type: "POST",
				async: true,
				url : "/ezWebFolder/getTrashCanList.do",
				dataType: "json",
				data : {
					"currPage"         : currentPage,
					"searchExt"        : $('#searchExt').val(),
					"searchFileName"   : $('#searchFileName').val(),
					"searchCreateName" : $('#searchCreateName').val(),
					"enrollStartDate"  : $('#enrollStartDate').val(),
					"enrollEndDate"    : $('#enrollEndDate').val(),
					"delStartDate"     : $('#delStartDate').val(),
					"delEndDate"       : $('#delEndDate').val(),
					"searchFileType"   : searchFileType,
					"listCount"        : blockSize,
					"column"           : orderInf.col ? orderInf.col : "",
					"order"            : orderInf.ord ? orderInf.ord : "",
					"listCount"        : listCnt,
					"mode"             : "admin"
				},
				success : function (data) {
					hideProgress();
					result = data.data;
					
					trashCanList = result.trashCanList;
					fileCnt = result.fileCnt;
					folderCnt = result.folderCnt;
					currentPage = result.currPage;
					totalPages = result.totalPages;
					totalRows = result.totalRows;
					
					if (fileCnt == null) {
						fileCnt = 0;
					}
					
					if (folderCnt == null) {
						folderCnt = 0;
					}
					
					$('#tblFileList tr td').remove();
					renderFileListElement(trashCanList);
					makePageSelPage();
					document.getElementById("mailBoxInfo").innerHTML = " - [ 폴더 " + "<span style='color:#017BEC;'>" 
					+ folderCnt +" </span>"+ strLang42 +" / 파일 " + "<span style='color:#017BEC;'>" + fileCnt +" </span>" + strLang42 + "]";
				},
				error : function(error) {
					hideProgress();
// 					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				}
			})
			
		};
		
		function renderFileListElement(result) {
			tableView.setDataSource(result);
			tableView.renderTable();
		}
		
		$(function() {
		  $(".datepicker").datepicker({
	            changeMonth: true,
	            changeYear: true,
	            autoSize: true,
	            showOn: "both",
	            buttonImage: "/images/ImgIcon/calendar-month.gif",
	            buttonImageOnly: true
	        });
		
		    $(".datepicker").datepicker("option", "dateFormat", "yy-mm-dd");
	        $(".datepicker").datepicker('setDate', "");
		});
		
		function btn_PostDate_Clear() {
			$(".datepicker").datepicker('setDate', "");
		}
		
		function goToPageByNum(Value){
			currentPage = Value;
			pStart = (blockSize * (currentPage))- blockSize;
			pEnd = blockSize;
			renderFileList();
		}
		
		function search(type) {
			var createStartVal = $("#enrollStartDate").val();
			var createEndVal   = $("#enrollEndDate").val();
			var delStartVal    = $("#delStartDate").val();
			var delEndVal      = $("#delEndDate").val();
			
			console.log("createStartVal: " + createStartVal + " || createEndVal: " + createEndVal + " || delStartVal: " + delStartVal + " || delEndVal: " + delEndVal);
			
			if (type == "basic") {
				if ($("#searchExt").val() == "" && $("#searchFileName").val() == "" && $("#searchCreateName").val() == "" && createStartVal == "" 
					&& createEndVal == "" && $("#delStartDate").val() == ""  
					&& $("#delEndDate").val() == "") {
					alert("<spring:message code='ezWebFolder.t163' />");// 검색조건을 입력하세요 
					return;
				}
				if (createStartVal != "" && createEndVal == "") {
					alert("<spring:message code='ezWebFolder.t308' />");
					return;
				}
				if (createEndVal != "" && createStartVal == "") {
					alert("<spring:message code='ezWebFolder.t309' />");
					return;
				}
				if (delStartVal != "" && delEndVal == "") {
					alert("<spring:message code='ezWebFolder.t308' />");
					return;
				}
				if (delEndVal != "" && delStartVal == "") {
					alert("<spring:message code='ezWebFolder.t309' />");
					return;
				}
				if (createStartVal > createEndVal) {
					alert("<spring:message code='ezWebFolder.t164' />");
					return;
				}
				if (delStartVal > delEndVal) {
					alert("<spring:message code='ezWebFolder.t164' />");
					return;
				}
			}
			else if (type == "quick") {
				if (document.getElementById("txt_keyword").value == "") {
					alert("<spring:message code='ezWebFolder.t163' />");
					return;
				}
			}
			var searchPanel = document.getElementById("searchPanel");
			if (searchPanel.style.display != "none") {
				searchPanel.style.display = "none";
				closeAllPopup();
			}
			
			renderFileList();
		}
		
		function openLeftPanel() {
			var leftFrame = window.parent.frames["left"].document;
			var blockLeft = leftFrame.getElementById("bnkBlockLeft");
			var height    = Math.max(leftFrame.documentElement.clientHeight, leftFrame.documentElement.scrollHeight);
			leftFrame.body.style.overflow = "hidden";
			blockLeft.style.height        = height + "px";
			blockLeft.style.display       = "";
		}
		
		function doLayerPopup(obj) {
			btn_PostDate_Clear();
			$('#enrollStartDate').val(enrollStartDate);
			$('#enrollEndDate').val(enrollEndDate) ;
			$('#delStartDate').val(delStartDate);
			$('#delEndDate').val(delEndDate) ;
			$('#searchExt').val(searchExt);
			$('#searchFileName').val(searchFileName) ;
			$('#searchCreateName').val(searchCreateName);
			var searchPanel = document.getElementById("searchPanel");
			var fogPanel    = document.getElementById("mailPanel");
			if (searchPanel.style.display == "none") {
				openLeftPanel();
				fogPanel.style.display    = "";
				var position              = DivPopUpPosition(516, 247);
				searchPanel.style.top     = position[0] + "px";
				searchPanel.style.right   = position[1] + "px";
				searchPanel.style.display = "";
			}
			else {
				closeLeftPanel();
				fogPanel.style.display    = "none";
				searchPanel.style.display = "none";
			}
		}
		
		function closeLeftPanel() {
			var leftFrame = window.parent.frames["left"].document;
			var blockLeft = leftFrame.getElementById("bnkBlockLeft");
			leftFrame.body.style.overflow = "auto";
			blockLeft.style.height        = "100%";
			blockLeft.style.display       = "none";
		}
		
		function refreshView() {
			renderFileList();
		}
		
		function filePermanentDelete() {
			var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
			
			if (listOfChecked.length <= 0) {
				alert("<spring:message code = 'ezWebFolder.t295'/>");
				return;
			}
			
			var filesList  = [];
			var folderList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				}
				else {
					filesList.push(fileFolderId);
				}
			}
			
			openLeftPanel();
			DivPopUpShow(450, 250, "/ezWebFolder/permanentDeleteConfirm.do?fileList=" + filesList.toString() + "&folderList=" + folderList.toString());
		
			refreshView();
		}
		
		function hiddenPanel () {
			closeAllPopup();
		}
		
		function restoreTrashCan() {
			var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
			
			if (listOfChecked.length <= 0) {
				alert("<spring:message code = 'ezWebFolder.t295'/>");
				return;
			}
			
			var filesList  = [];
			var folderList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				}
				else {
					filesList.push(fileFolderId);
				}
			}
			
			$.ajax ({
				type: "POST",
				async: false,
				url : "/ezWebFolder/restoreTrashCan.do",
				dataType: "json",
				data : {
					"fileList"   : filesList.toString(),
					"folderList" : folderList.toString()
				},
				success : function (data) {
					if (data.code == "1") {
						alert("<spring:message code = 'ezWebFolder.t289'/>");
					} else if (data.code == "4") {
						alert("<spring:message code = 'ezWebFolder.t290'/>");
					}
				},
				error : function(error) {
						alert("<spring:message code = 'ezWebFolder.t292'/>");
				}
			})
			
			refreshView();
		}
		
		function moveTraschCan() {
			var listOfChecked = document.getElementsByClassName("bnkWebFolder2");
			
			if (listOfChecked.length <= 0) {
				alert("<spring:message code = 'ezWebFolder.t295'/>");
				return;
			}
			
			var filesList  = [];
			var folderList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				}
				else {
					filesList.push(fileFolderId);
				}
			}
			
			var OpenWin = window.open("/ezWebFolder/moveTrashCanManage.do?folderType=C&fileList=" + filesList.toString() + "&folderList=" + folderList.toString(), "", GetOpenWindowfeature(420, 490));
			try { OpenWin.focus(); } catch (e) { }
			
			refreshView();
		}
		
		function closeAllPopups() {
			closeLeftPanel();
			document.getElementById("mailPanel").style.display   = "none";
			document.getElementById("searchPanel").style.display = "none";
			document.getElementById("iFramePanel").style.display = "none";
			
			if (document.getElementById("ui-datepicker-div")) {
				document.getElementById("ui-datepicker-div").style.display = "none";
			}
		}
	</script>
</head>
<body class="mainbody" onkeydown="keyPressPanel(event);">
    <h1><spring:message code='ezWebFolder.t269'/><span id="mailBoxInfo"></span></h1>
	<div id="mainmenu2" style="margin-left: 5px;">
		<ul>
			<li id=""><a onClick="restoreTrashCan()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t287'/></span></a></li>
			<li id=""><a onClick="moveTraschCan()" style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t282'/></span></a></li>
			<li id=""><a onClick="filePermanentDelete()"   style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t19'/></span></a></li>
			<li id="SearchOption" mode="off" onClick="doLayerPopup(this)"><a style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t123'/></span></a></li>
			<li style="float:left;">
				<select class="select" id="idSelect" onchange="changeValue(this.value);" style="height: 29px; border-radius: 3px; padding: 0px; width: 85px;">
					<option value="all" selected><spring:message code='ezWebFolder.t191'/></option>
					<option value="document"><spring:message code='ezWebFolder.t192'/></option>
					<option value="music"><spring:message code='ezWebFolder.t193'/></option>
					<option value="video"><spring:message code='ezWebFolder.t194'/></option>
					<option value="image"><spring:message code='ezWebFolder.t195'/></option>
					<option value="folder"><spring:message code='ezWebFolder.t213'/></option>
					<option value="zip"><spring:message code='ezWebFolder.t196'/></option>
					<option value="unknown"><spring:message code='ezWebFolder.t311'/></option>
				</select>
			</li>
			<li id="right">
				<span><spring:message code='ezWebFolder.t29'/></span>
				<select id="listCount" class="wfListCnt" onchange="renderFileList();">
					<option selected="selected">10</option>
					<option>20</option>
					<option>30</option>
					<option>40</option>
					<option>50</option>
				</select>
			</li>
		</ul>
	</div>
	
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu2"), "ul", "li", "0");
	</script>
	
	<div id="progress-wrp" style="display: none;">
		<div class="progress-bar"></div ><div class="status">0%</div>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
	<div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	<div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
	<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)" style="margin: 10px 0px 10px 5px;overflow:auto;">
		<table class="mainlist" style="width: 100%; text-algin: center;" id="tblFileList">
			<tr>
				<th width="20px" ><input type="checkbox"></th>
				<th headers="ft" style="text-align: center; width: 20px;"><spring:message code='ezWebFolder.t188'/></th>
				<th headers="fn" style="width: 30%;"><spring:message code='ezWebFolder.t156'/></th>
				<th headers="fs" style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap; text-align: center; word-wrap: normal; width :6%;" ><spring:message code='ezWebFolder.t157'/></th>
				<th headers="un" style="width: 7%"><spring:message code='ezWebFolder.t189'/></th>
				<th headers="cd" style="width: 10%"><spring:message code='ezWebFolder.t190'/></th>
				<th headers="dd" style="width: 10%"><spring:message code='ezWebFolder.t288'/></th>
				<th              style="width: 25%"><spring:message code='ezWebFolder.t199'/></th>
			</tr>
		</table>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe style="border:none;" id="iFrameLayer"></iframe>
    </div>
	<div id="searchPanel"class="wfSearchPanel" style="display:none;">
		<div style="margin: 20px;">
			<table class="content" style="margin-top:10px;">  
				<tr>
					<th class="layerHeader" colspan="2"><img src="/images/webfolder/left_webfolder.png" style="vertical-align: middle;padding-bottom:1px" width="16px"/>&nbsp;<spring:message code='ezWebFolder.t10' /></th>
				</tr>
				<tr>
					<td class="wfSearchTh2" colspan="2"></td>
				</tr>
				<tr>
					<th style="text-align:center"><spring:message code='ezWebFolder.t190' /></th>
					<td>
						<input type="text" class="datepicker" id="enrollStartDate" style="width:80px;text-align:center" readonly="readonly">
						&nbsp;~&nbsp;
						<input type="text" class="datepicker" id="enrollEndDate" style="width:80px;text-align:center" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th style="text-align:center"><spring:message code='ezWebFolder.t288' /></th>
					<td>
						<input type="text" class="datepicker" id="delStartDate" style="width:80px;text-align:center" readonly="readonly">
						&nbsp;~&nbsp;
						<input type="text" class="datepicker" id="delEndDate" style="width:80px;text-align:center" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th style="text-align:center"><spring:message code='ezWebFolder.t152' /></th><!-- 확장자 -->
					<td><input type="text" id="searchExt" style="width:98%" value="" name="searchExt"></td>
				</tr>
				<tr>
					<th style="text-align:center"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
					<td><input type="text" id="searchFileName" style="width:98%" value="" name="searchFileName"></td>
				</tr>
				<tr>
					<th style="text-align:center"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
					<td><input type="text" id="searchCreateName" style="width:98%" value="" name="searchCreateName"></td>
				</tr>
			</table>
			<br/>
			<table style="width:100%">
				<tr>
					<td style="text-align:center;">
						<a class="webfolderBttn"><span onclick="search('basic');"><spring:message code='ezWebFolder.t123'/></span></a>
						<a class="webfolderBttn"><span onclick="doLayerPopup();" ><spring:message code='ezWebFolder.t112'/></span></a>
					</td>
				</tr>
			</table>
		</div>
		<span class="wfCloseBttn" onClick="doLayerPopup();"></span>
	</div>	
	
	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
		<img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
	
	<div id="tblPageRayer"></div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel" onclick="closeAllPopups();">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="<spring:message code='main.kms4'/>" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>