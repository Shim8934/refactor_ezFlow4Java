<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<!-- date Picker -->
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/ezOrgan/ListView_list.js')}"></script>
	<!-- time picker-->
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/adminTable.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/duplicate-file.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
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
		var _selectedCell = null;
    	var _cellInfo        = {};
    	var sortColumn = null;
    	var sortType = null;
		
		window.onresize = function () {
			var divList          = document.getElementById("dragDropArea");
			var reheight         = document.documentElement.clientHeight - 210;
			divList.style.height = reheight + "px";
			scroll();
		};
		
		document.onselectstart = function() {return false;}
		
		window.onload = function () {
			closeAllPopup();
			tableView.setTableId("tblFileList");
			tableView.setTabledHeader("tblFileList1");
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
			

			// listoption 다른 곳 클릭시 숨김 처리
			var listOptionHidden = function(event) {
				if (document.getElementById("webfolderlistoptiondiv").getAttribute('mode') == "on"
						&& !document.getElementById("layer_Viewpopup").contains(event.target)
						&& event.target.id !== "webfolderlistoptiondiv") {
					optionHidden();
				}
			};
			document.addEventListener("mouseup", listOptionHidden, true);
			parent.frames["left"].document.addEventListener("mouseup", listOptionHidden, true);
			
			var listHeader = document.getElementsByClassName("headListClick");
			for(var i = 0 ; i <listHeader.length; i++) {
				listHeader[i].addEventListener("click", function(event) {
					sortByHeader(this);
				});
			}
			
			// listoption 클릭 이벤트
			document.getElementById("webfolderlistoptiondiv").addEventListener("click", function(event) {
				event.stopPropagation();
				optionView(event.target);
			});
			
			document.getElementById("listCount").addEventListener("change", function() {
				optionHidden();
				pagination.setListSize(this.value);
				refreshView();
			});
			
		});
		
		function sortByHeader(cell) {
			var column = cell.getAttribute("data-column");
			
			if (!column) {return;}
			
			if (_selectedCell != null) {
				var orderOption = cell.getAttribute("orderoption") == "DESC" ? "ASC" : "DESC";
				cell.setAttribute("orderoption", orderOption);
				
				if (cell.cellIndex != _selectedCell) {
					var lastSelectedCell = document.getElementById("BoardList_THEAD").rows[0].cells[_selectedCell];
					lastSelectedCell.removeChild(lastSelectedCell.lastElementChild);
					var spanElmt = document.createElement("span");
					cell.appendChild(spanElmt);
				}
				
				var spanImg       = cell.lastElementChild;
				spanImg.className = orderOption == "DESC" ? "spanDown" : "spanUp";
			} else {
				cell.setAttribute("orderoption", "DESC");
				var spanElmt       = document.createElement("span");
				spanElmt.className = "spanDown";
				cell.appendChild(spanElmt);
			}
			
			_selectedCell = cell.cellIndex;
			
			var order     = cell.getAttribute("orderoption");
			sortType = order;
			sortColumn = column;
			renderFileList();
		}
		
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
					"mode"             : "admin",
					"sortType"		   : sortType,
					"sortColumn"	   : sortColumn
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
					
					document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span class='txt_color'>" + folderCnt +" </span>"
					+ " / " + messages.strLang16 + " <span class='txt_color'> " 
					+ fileCnt +" </span>";
					
				},
				error : function(error) {
					hideProgress();
				}
			})
			scroll();
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
	            buttonImage: "/images/ImgIcon/calendar-month.png",
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
			var versionList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				var version = listOfChecked[i].getAttribute("version");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				} else if (version == "0") {
					filesList.push(fileFolderId);
				} else {
					// 버전 속성이 1 이상이면 버전관리 파일이다.
					versionList.push(fileFolderId + ":" + version);
				}
			}
			
			openLeftPanel();
			
			var param = "?fileList=" + filesList.toString() + "&folderList=" + folderList.toString() 
					+ "&versionList=" + versionList.toString();
			DivPopUpShow(450, 200, "/ezWebFolder/permanentDeleteConfirm.do" + param);
		
			//refreshView();
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
			var versionList = [];
			
			for (var i = 0; i < listOfChecked.length; i++) {
				var fileFolderId = listOfChecked[i].getAttribute("targetid");
				var version = listOfChecked[i].getAttribute("version");
				
				if (listOfChecked[i].getAttribute("ext") == 'folder') {
					folderList.push(fileFolderId);
				} else if (version == "0") {
					filesList.push(fileFolderId);
				} else {
					versionList.push(fileFolderId + ":" + version);
				}
			}
			
			$.ajax ({
				type: "POST",
				async: false,
				url : "/ezWebFolder/restoreTrashCan.do",
				dataType: "json",
				data : {
					"fileList"   : filesList.toString(),
					"folderList" : folderList.toString(),
					"versionList":  versionList.toString()
				},
				success : function (data) {
					// 버전 복원이 실패했다면 알림
					var successRestoredVersions = data.errorVersions && data.errorVersions.length == 0;
					
					if (data.code == 0 && successRestoredVersions) {
						alert("<spring:message code = 'ezWebFolder.t289'/>");
					} else if (data.code == 2) {
					   alert("<spring:message code = 'ezWebFolder.t292'/>");
					} else if (data.code == 3) {
						alert("<spring:message code = 'ezWebFolder.t28'/>");
					} else {
						if (data.code == 4) {
							alert("<spring:message code = 'ezWebFolder.t290'/>");
						}
						
						// 중복된 정보가 존재한다면 알림
						if (data.duplicateInfoArray && data.duplicateInfoArray.length > 0) {
							alert("<spring:message code = 'webfolder.duplicate.restore.error'/>");
						}
						
						if (data.hasExceededCapacities) {
							alert("<spring:message code = 'webfolder.trash.restore.error.capacity'/>");
						}
						
						if (!data.hasAllParentFile) {
							alert("<spring:message code = 'webfolder.trash.restore.error.reply'/>");
						}
					}
					
					if (!successRestoredVersions) {
						alert("<spring:message code = 'webfolder.version.trash.restore.error'/>");
					}
					
					/* if (data.code == "1") {
						alert("<spring:message code = 'ezWebFolder.t289'/>");
					} else if (data.code == "4") {
						alert("<spring:message code = 'ezWebFolder.t290'/>");
					} else if (data.code == "8") {
						alert("<spring:message code = 'webfolder.duplicate.restore.error'/>");
					} */
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
			
			var OpenWin = window.open("/ezWebFolder/moveTrashCanManage.do?isAdmin=true&folderType=C&fileList=" + filesList.toString() + "&folderList=" + folderList.toString(), "", GetOpenWindowfeature(460, 490));
			try { OpenWin.focus(); } catch (e) { }
			
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
		
		function optionView(obj) {
			if (obj.getAttribute("mode") == "off") {
				var a_left = $("#wfOptionDiv").offset().left - ($("#layer_Viewpopup").width() - $("#wfOptionDiv").width());
				var a_top = $("#wfOptionDiv").offset().top + $("#wfOptionDiv").height() + 2;
				document.getElementById("layer_Viewpopup").style.display = "";
				obj.setAttribute("class", "icon16 btn_onarrow_down");
				obj.setAttribute("mode", "on");
				$("#layer_Viewpopup").css({"left":a_left, "top":a_top});
			} else {
				optionHidden();
			}
		}

		function optionHidden() {
			document.getElementById("layer_Viewpopup").style.display = "none";
			document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
			document.getElementById("webfolderlistoptiondiv").setAttribute("class", "icon16 btn_arrow_down");
		}
		
		function scroll() {
			var BoardList_BODYHeight = document.getElementById("dragDropArea").clientHeight;
			var BoardListDivHeight = document.getElementById("tblFileList").clientHeight;
			
			 if (BoardList_BODYHeight > BoardListDivHeight) {
				if ($("#tblFileList1 tr th#forScroll").length > 0) {
					$("#tblFileList1 tr th#forScroll").remove();
				}
			} else {
				if ($("#tblFileList1 tr th#forScroll").length < 1) {
					$("#tblFileList1 tr th#forScroll").remove();
					$("#tblFileList1 tr").append("<th></th>");
					
						var lastTh = $("#tblFileList1 tr th").last();
						lastTh.attr("id", "forScroll");
						lastTh.css("width", "15px");
						
				}
			}
			 
			/*var lastTh = $("#BoardList_TH th").last();
			if (lastTh.attr("id") == null) {
				lastTh.css("display", "none");
			}*/
		}
		
	</script>
</head>
<body class="mainbody" onkeydown="keyPressPanel(event);">
    <h1><spring:message code='ezWebFolder.t269'/><span id="mailBoxInfo"></span></h1>
	<div id="mainmenu" style="margin-left: 5px;">
		<ul>
			<li id=""><a onClick="restoreTrashCan()" style=" margin-top: 3px;"><span><spring:message code='ezWebFolder.t287'/></span></a></li>
			<li id=""><a onClick="moveTraschCan()" style=" margin-top: 3px;"><span><spring:message code='ezWebFolder.t282'/></span></a></li>
			<li id=""><a onClick="filePermanentDelete()"   style=" margin-top: 3px;"><span><spring:message code='ezWebFolder.t19'/></span></a></li>
			<li id="SearchOption" mode="off" onclick="doLayerPopup(this)" class="off"><span class="icon16 icon16_search"></span></li>
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
			<div class="sub_frameIcon" style="float:right" id="wfOptionDiv">
				<div class="sub_frameIconUL02">
				  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv"></span></p>  
				</div>
			</div>
		</ul>
	</div>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
	<!-- 파일 리스트 10~ 50 선택 -->
    <div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
        <div class="popupwrap1">	
            <div class="popupwrap2">
                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
                    <caption></caption>
                    <colgroup>
                        <col style="width: 120px;">
                        <col>
                    </colgroup>
                    <tr>
                        <th><spring:message code='ezBoard.t10021' /></th>
                        <td>
                            <select id="listCount" class="wfListCnt">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                                <option value="50">50</option>
                            </select>    
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="shadow">
        </div>
 	</div>
	<div id="progress-wrp" style="display: none;">
		<div class="progress-bar"></div ><div class="status">0%</div>
	</div>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
	<div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	<div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
	
	<div style="width:100%;"id ="tblFileList1_div">
		<div style="margin:0px 0px 0px !important;min-width: 700px;" >
			<table class="mainlist" style="width:100%"  id="tblFileList1">
				<thead id ="BoardList_THEAD">
					<tr>
						<th class = "wfFilecheck"><input type="checkbox"></th>
						<th headers="ft" class = "wfFileType		 headListClick" data-column="TRASHCAN_ICON_URL" style="text-align: center; "><spring:message code='ezWebFolder.t188'/></th>
						<th headers="fn" class = "wfFileName		 headListClick" data-column="TRASHCAN_NAME" ><spring:message code='ezWebFolder.t156'/></th>
						<th headers="fs" class = "wfFileSize		 headListClick" data-column="TRASHCAN_SIZE" style="overflow: hidden;text-overflow: ellipsis;white-space: nowrap; text-align: center; word-wrap: normal;" ><spring:message code='ezWebFolder.t157'/></th>
						<th headers="un" class = "wfFileCreator		 headListClick" data-column="CREATE_NAME1" ><spring:message code='ezWebFolder.t189'/></th>
						<th headers="cd" class = "wfFileFavoriteDate headListClick" data-column="CREATE_DATE" ><spring:message code='ezWebFolder.t190'/></th>
						<th headers="dd" class = "wfFileFavoriteDate headListClick" data-column="UPDATE_DATE" ><spring:message code='ezWebFolder.t288'/></th>
						<th              class = "wfFilePath		 " data-column="TRASHCAN_PATH"><spring:message code='ezWebFolder.t199'/></th>
					</tr>  
				</thead>
			</table>
			<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)">
				<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
			
				</table>
			</div>
		</div>
	</div>

	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe style="border:none;" id="iFrameLayer"></iframe>
    </div>

	<div id="searchPanel" class="wfSearchPanel popupwrap3 modal" style="margin-bottom: 70px; display: none; width:537px;">
		<div class="popupJQLayer" >
		<div class="title"><spring:message code='ezWebFolder.kje01'/></div>
		<div class="wfClose" onclick="doLayerPopup();"><ul><li><span></span></li></ul></div>
			<table class="content wftable">
				<tr>
					<th class="wfSearchTh"><spring:message code='ezWebFolder.t190' /></th>
					<td>
						<input type="text" class="datepicker" id="enrollStartDate" style="width:80px;text-align:center" readonly="readonly">
						&nbsp;~&nbsp;
						<input type="text" class="datepicker" id="enrollEndDate" style="width:80px;text-align:center" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th class="wfSearchTh"><spring:message code='ezWebFolder.t288' /></th>
					<td>
						<input type="text" class="datepicker" id="delStartDate" style="width:80px;text-align:center" readonly="readonly">
						&nbsp;~&nbsp;
						<input type="text" class="datepicker" id="delEndDate" style="width:80px;text-align:center" readonly="readonly">
					</td>
				</tr>
				<tr>
					<th class="wfSearchTh"><spring:message code='ezWebFolder.t152' /></th><!-- 확장자 -->
					<td class="wfSearchTd"><input type="text" id="searchExt" value="" name="searchExt"></td>
				</tr>
				<tr>
					<th class="wfSearchTh"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
					<td class="wfSearchTd"><input type="text" id="searchFileName" value="" name="searchFileName"></td>
				</tr>
				<tr>
					<th class="wfSearchTh"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
					<td class="wfSearchTd"><input type="text" id="searchCreateName" value="" name="searchCreateName"></td>
				</tr>
			</table>
		<div class="wfdivBttn">
			<a class="webfolderBttn"><span onclick="search('basic');"><spring:message code='ezWebFolder.t123'/></span></a>
			<a class="webfolderBttn" style="display:none"><span onclick="doLayerPopup();" ><spring:message code='ezWebFolder.t112'/></span></a>
		</div>
	</div>
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
