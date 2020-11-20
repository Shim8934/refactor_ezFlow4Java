<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title><spring:message code='ezWebFolder.t522' /></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('ezWebFolder.i1', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('ezWebFolder.e1', 'msg')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>	
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/pageNav.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/jquery.lineProgressbar.css')}" type="text/css" />
	<!-- datepicker -->
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	<!-- module -->
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/webfolderFilePick.js')}"></script>
	<style>
		.wfFileFavorite .wfFileCreator .wfFilePath .wfFileShare {
			display:none;
		}
	</style>	
	
    <script type="text/javascript">
		var file 		 = new Array();
		var strShared1	= messages.strLang2;
		var strShared2	= messages.strLang3;
		var strErr		= messages.strLang4;
		var appType     = "user";
		var userName = "${userInfo.userName}";
		var filelist = [];
		var strSuccess  = "<spring:message code='ezWebFolder.t27' />";
		var pEnd =10;
		var folderId = "<c:out value='${folderId}'/>";
		var folderType = "<c:out value='${folderType}'/>";
		var allFileFlag = "${allFileFlag}";
		var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
		var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
		var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
		var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
		var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
		var functionType = "";
		var inputNameDlg_cross_dialogArguments = new Array();
		var parentId = "${parentId}";
		var userId = "";
		var folderTypeCheck = "N";
		var _selectedCell = null;
		var _cellInfo        = {};
		var sortColumn = null;
		var sortType = null;
		var filePickArr = new Array();
		var filePickObj = new Object();
		
		document.onselectstart = function() {return false;};
		
		window.onbeforeunload = function() {
			searchOptionHidden();
		}
		
		window.onload = function() {
			getFileList(folderId);
			
			searchContext.setSearchStartEventHandler(function() {
				$("#idSelect").val("");
				onFileTypeChange("");
			});
			
			pagination.setPageChangeEventHandler(function() {
				getFileList(folderId);
			});
			
			var listHeader = document.getElementsByClassName("headListClick");
			for(var i = 0 ; i <listHeader.length; i++) {
				listHeader[i].addEventListener("click", function(event) {
					sortByHeader(this);
				});
			}
			
			// datepicker setup
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
	        
	        var monthMsg = "<spring:message code='ezSchedule.t110' />";
		    var monthStr = monthMsg.split(";");		    
		    var dayMsg = "<spring:message code='ezSchedule.t108' />";
		    var dayStr = dayMsg.split(";");
		    
	        $.datepicker.regional["<spring:message code='main.t0619' />"] = {
	        	closeText: "<spring:message code='main.t3' />",
	            prevText: "<spring:message code='main.t0604' />",
	            nextText: "<spring:message code='main.t0605' />",
				currentText: "<spring:message code='main.t0606' />",
	            monthNames: monthStr,
	            monthNamesShort: monthStr,
	            dayNames: dayStr,
	            dayNamesShort: dayStr,
	            dayNamesMin: dayStr,
	            weekHeader: 'Wk',
	            dateFormat: 'yy-mm-dd',
	            firstDay: 0,
	            isRTL: false,
	            duration: 200,
	            showAnim: 'show',
	            showMonthAfterYear: true
	        };
	        
	        $.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619' />"]);
	     }
		
		function sortByHeader(cell) {
			var column = cell.getAttribute("headers");
			
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
			this.sortType = order;
			this.sortColumn = column;
			getFileList(folderId);
		}
		
	    // 폴더관리
	    function folder_Manage() {
        	var OpenWin = window.open("/ezWebFolder/folderManage.do", "", GetOpenWindowfeature(500, 500));
            try { OpenWin.focus(); } catch (e) { }
        }
	    
	    function getFileList(a){
	    	if(folderId == "") {
	    		alert(messages.strLang14);
	    		return;
	    	}
	    	
	    	searchRequirement = searchContext.getCurrentRequirement();
	    	folderId = a;
			$.ajax ({
				type:"POST",
				async: true,
				url : "/ezWebFolder/fileList.do",
				data : { 
					 "folderId"   		: folderId,
					 "folderType" 		: folderType,
					 "currPage"   		: pagination.currentPage(),
					 "listCount"  		: pagination.listSize(),
					 "pStart" 			: pagination.startPosition(),
					 "searchExt" 		: searchRequirement.extension,
					 "searchFileName" 	: searchRequirement.name,
					 "searchCreateName" : searchRequirement.creatorName,
					 "searchFileType" 	: searchContext.getFileType(),
					 "searchStartDate" 	: searchRequirement.startDate,
					 "searchEndDate" 	: searchRequirement.endDate,
					 "allFileFlag"		: allFileFlag,
					 "sortType"			: sortType,
					 "sortColumn"		: sortColumn
					},
				dataType: "JSON",
				success : function (data) {
					successFile(data);
				},
				error : function(error) {
				}
			});
		}
	    
		function successFile(data) {
			if (data.status == "error") {
				if (data.code == 1) {
					console.log("<spring:message code='ezWebFolder.t306' />");
					return;
				} else if (data.code == 2) {
					alert("<spring:message code='ezWebFolder.t305' />");
					return;
				} else if (data.code == 3) {
					alert("<spring:message code='ezWebFolder.t300' />");
					return;
				}
			}
			userId = data.data.userId;
			var result = data.data;
			
			var fileCnt = result.fileCnt;
			var fldCnt = result.fldCnt;
			
			var folderPath = result.folderPath;
			var originalPath = result.originalPath;
			var folderUpp = result.folderUpp;
			var dragDropAreaElmt = document.getElementById("dragDropArea");
			filelist = result.fileList;
			
			pagination.setListSize(result.listCount);
			pagination.setAmount(result.totalRows);
			pagination.build();
			
			$('#tblFileList tr td').parent().remove();
			renderData(filelist);
			parentId = data.data.folderUpp;
			
			namePath(folderPath, originalPath);
			document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span style='color:#017BEC;'>" + fldCnt +" </span>"
			 + " / " + messages.strLang16 + " <span style='color:#017BEC;'> " 
				+ fileCnt +" </span>";
			$("#listcount").val(result.listCount).prop("selected", true);
			(function() {
				var webfolderList_BODYHeight = document.getElementById("dragDropArea").clientHeight;
				var webfolderDivHeight = document.getElementById("tblFileList").clientHeight;
				
				 if (webfolderList_BODYHeight > webfolderDivHeight) {
					if ($("#tblFileList1 tr th#forScroll").length > 0) {
						$("#tblFileList1 tr th#forScroll").remove();
					}
				} else {
					if ($("#tblFileList1 tr th#forScroll").length < 1) {
						$("#tblFileList1 tr th#forScroll").remove();
						$("#tblFileList1 tr").append("<th></th>");
						
							var lastTh = $("#tblFileList1 tr th").last();
							lastTh.attr("id", "forScroll");
							lastTh.css("width", "9px");
							
					}
				}
			})();
		} 
		
		// originalPath 는 한글 path
		// folderPath 는 숫자 
		function namePath(folderPath, originalPath) {
			var orginalPathElmt = document.getElementById("originalPath");
			var nameTag = document.createElement("div");
			nameTag.setAttribute("class", "mainPath");
			var originPath;
			
			// for statement using
			var detailName;
			var imgElmt;
			var length;
			
			folderPath = folderPath.substring(1, folderPath.length - 1);
			originPath = folderPath.split("|");
			path = originalPath.split("/");
			
			$('#originalPath').empty();
			orginalPathElmt.appendChild(nameTag);
			length = path.length - 1;
			
			for (var i = 0; i < length; i++) {
				detailName  = document.createElement("div");
				var divName = document.createElement("div");
				
				detailName.className = "aName";
				detailName.id = originPath[i];
				detailName.onclick = function() {
					nameFileList(this.id);
				};
				
				divName.textContent = path[i] ;
				divName.setAttribute("title", path[i]);
				/* 2018-05-07 장진혁 - 상단 폰트사이즈 15px로 조정 */
				divName.setAttribute("style", "font-size:15px; padding-right:3px;");
				detailName.appendChild(divName);
				nameTag.appendChild(detailName);
				
				/* root 폴더 업로드기능이 적용되지 않았을 시 name path 
				if(length == 1) {
					var divSeparator = document.createElement("div");
					divSeparator.setAttribute("class", "separator");
					divSeparator.textContent =  " > " + messages.strLang17 + " "; // 모든파일
					nameTag.appendChild(divSeparator);
				}
				
				if (i != length - 1) {
					var divSeparator = document.createElement("div");
					divSeparator.textContent = " > ";
					divSeparator.setAttribute("class", "separator");
					nameTag.appendChild(divSeparator);
				}
				*/
				
				if (allFileFlag == "all") {
					var divSeparator = document.createElement("div");
					divSeparator.setAttribute("class", "separator");
					divSeparator.textContent =  " > " + messages.strLang17 + " "; // 모든파일
					nameTag.appendChild(divSeparator);
				} else {
					var divSeparator = document.createElement("div");
					if (i != length - 1) {
						divSeparator.textContent = " > ";
					}
					divSeparator.setAttribute("class", "separator");
					nameTag.appendChild(divSeparator);
				}
			}
		}
		
		function nameFileList(param) {
			folderId = param;
			searchContext.clearRequirement();
			$("#idSelect").val("");
			onFileTypeChange("");
// 			selectLeftFolder(folderId);
		}
		
		function renderData(result) {
			var tableList = document.getElementById("tblFileList");
			document.getElementById("_checkAll").checked = false;
			
			while (tableList.rows.length > 1) {
				tableList.deleteRow(1);
			}
			
			if (result == null || result.length == 0) {
				var trElmt = document.createElement("tr");
				var tdElmt = document.createElement("td");
				tdElmt.setAttribute("colspan", "10");
				tdElmt.setAttribute("align", "center");
				tdElmt.setAttribute("bgcolor", "#FFFFFF");
				tdElmt.innerHTML = messages.strLang12;
				tdElmt.setAttribute("id", "nodataRow");
				
				trElmt.appendChild(tdElmt);
				tableList.appendChild(trElmt);
			} else {
				var len = result.length;
				
				for (var i = 0; i < len; i++) {
					var trElmt  = document.createElement("tr");
					var tdElmt1 = document.createElement("td");
					var tdElmt3 = document.createElement("td");
					var tdElmt4 = document.createElement("td");
					var tdElmt5 = document.createElement("td");
					var tdElmt8 = document.createElement("td");	
					
					setStyles([tdElmt4, tdElmt5, tdElmt8], function(style) {
						style.overflow = "hidden";
						style.textOverflow = "ellipsis";
						style.whiteSpace = "nowrap";
						style.wordWrap = "normal";
					});
					
					setStyles([tdElmt3, tdElmt5], function(style) {
						style.textAlign = "center";
					});

					trElmt.setAttribute("class", "bnkWebFolder");
					trElmt.setAttribute("targetId", result[i]["fileId"]);
					trElmt.setAttribute("targetType", result[i]["fileTypeName"] == 'folder' ? 'D' : 'F');
					trElmt.setAttribute("targetCreater", result[i]["createId"]);
					trElmt.setAttribute("targetPath", result[i]["filePosition"]);
					
					if (result[i]["targetType"]) {
						trElmt.setAttribute("targetFunction", resultJson["folderType"]);
					}
					
					var creator = ""
					if (!result[i]["creatorId"]) {
						trElmt.setAttribute("targetCreater", result[i]["createId"]);
					} else {
						trElmt.setAttribute("targetCreater", result[i]["creatorId"]);
					}
					if(result[i]["typeId"] != "folder") {
						trElmt.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
					}
					
					var inputElmt = document.createElement("input");
					inputElmt.setAttribute("type", "checkbox");
					inputElmt.setAttribute("value", result[i]["fileId"]);
					inputElmt.setAttribute("class", "checkBnk");
					inputElmt.addEventListener("change", rowContext.onCheckboxChange);
					inputElmt.addEventListener("click", function(event) { event.stopPropagation(); });
					inputElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
					
					var selectedFileCheck = folderId + "/" + result[i]["fileId"];
					if (filePickArr.indexOf(selectedFileCheck) > -1){
						inputElmt.setAttribute("checked", true);
						trElmt.setAttribute("class", "bnkWebFolder2");
					}
					
					if (result[i]["typeId"] != "folder") {
						tdElmt1.appendChild(inputElmt);
					}
					
					var fileIconElmt = document.createElement("img");
					fileIconElmt.setAttribute("class", "webFolderImg");
					fileIconElmt.src = result[i]["fileIconUrl"];
					tdElmt3.appendChild(fileIconElmt);
					
					tdElmt4.textContent = result[i]["fileName"];
					tdElmt4.setAttribute("title", result[i]["fileName"]);
					
					if(result[i]["typeId"] == "folder") {
						tdElmt5.textContent = ' - ';
					}else {
						tdElmt5.textContent = getFileSize(result[i]["fileSize"]);
					}
					
					tdElmt8.textContent = result[i]["updateDate"].substring(0, 10);
					
					tdElmt1.setAttribute("class", "wfFilecheck");
					tdElmt3.setAttribute("class", "wfFileType");
					tdElmt4.setAttribute("class", "wfFileName");
					tdElmt5.setAttribute("class", "wfFileSize");
					tdElmt8.setAttribute("class", "wfFileUpdateDate");
					
					if (result[i]["fileShareStatus"] == "Y") {
						var spanElmt = document.createElement("span");
						spanElmt.innerHTML = "<img src='/images/webfolder/sharing2.png' class='webFolderImg' />";
						spanElmt.addEventListener("click", function () {
							shareContext.showShareInfo(this);
						});
					} 
					
					if(result[i]["typeId"] == "folder") {
						trElmt.ondblclick = function() {
// 							selectLeftFolder(this.getAttribute("targetId"));
							getFileList(this.getAttribute("targetId"));
						};
					}
					
					trElmt.appendChild(tdElmt1);
					trElmt.appendChild(tdElmt3);
					trElmt.appendChild(tdElmt4);
					trElmt.appendChild(tdElmt5);
					trElmt.appendChild(tdElmt8);
					
					tableList.appendChild(trElmt);
				}
			} 
		}
		
		function setStyles(elements, excutor) {
			var length = elements.length;
			
			for (var i = 0; i < length; i++) {
				excutor(elements[i].style);
			}
		}
	    
	   	// TODO : 여기서부터 코드 정리하면서 내려가서 list 뿌리기 
		function search(type) {
			if (type == "basic") {
				requirement = {
					startDate: $("#Sdatepicker").datepicker({ dateFormat: 'yy-mm-dd' }).val(),
					endDate: $('#Edatepicker').datepicker({ dateFormat: 'yy-mm-dd' }).val(),
					name: $('#searchFileName').val(),
					creatorName: $('#searchCreateName').val(),
					extension: $('#searchExt').val()
				};
	        	
				if (requirement.extension == "" && requirement.name == "" && requirement.creatorName == "" 
						&& requirement.startDate == "" && requirement.endDate == "") {
					alert(messages.strLang20);
					return;
				}
	
				if (requirement.startDate != "" && requirement.endDate == "") {
					alert(messages.strLang21);
					return;
				}
	           
				if (requirement.startDate == "" && requirement.endDate != "") {
					alert(messages.strLang22);
					return;
				}
	
				if (new Date(requirement.startDate) > new Date(requirement.endDate)) {
					alert(messages.strLang19);
					return;
				}
           
				searchContext.search(requirement.startDate, requirement.endDate, requirement.name, requirement.creatorName, requirement.extension);
			} else if (type == "quick") {
				if (document.getElementById("txt_keyword").value == "") {
					alert(messages.strLang20);
					return;
				}
			}
			
			searchOptionHidden();
		}
		
		function doLayerPopup(obj) {
	        var searchRequirement = searchContext.getCurrentRequirement();
	        
	        // 검색 input 요소 초기화
	        $(".datepicker").datepicker('setDate', "");
	        $('#searchExt').val("");               
            $('#searchFileName').val("");
            $('#searchCreateName').val("");
            $('.datepicker').val("");
        	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
        	
        	$("#searchpopup").css("left", popupX);
        	
        	$("#searchpopup").modal();
	    }
		
	    function searchOptionHidden() {
	    	$.modal.close();
	    }

		function refreshView() {
			getFileList(folderId);
		}
       
		function onFileTypeChange(value) {
			searchContext.setFileType(value);
			pagination.setPage(1);
		}
       
        function selectLeftFolder(targetID) {
        	window.parent.frames["left"].selectFolder(targetID);
        }

        function leftFolderUpdate(functionType, fileId, parentFolderId, targetId, folderName) {
        	if (functionType == "insert" && fileId == 0) {
        		window.parent.frames["left"].insertLeftFolder(parentFolderId, targetId, folderName);
        	} else if (functionType == "update" && fileId == 0) {
        		window.parent.frames["left"].updateLeftFolder(parentFolderId, targetId, folderName);
        	}
        }
        
        function leftFolderDelete(folderList) {
        	window.parent.frames["left"].deleteLeftFolder(folderList);
        }
        
        function leftFolderCPMV(functionType, folderList, toTargetId) {
        	if (folderList != null || folderList != "") {
	        	if(functionType == "mv") {
	        		window.parent.frames["left"].moveLeftFolder(folderList, toTargetId);
	        	} else if (functionType == "cp") {
	        		window.parent.frames["left"].copyLeftFolder(folderList, toTargetId, folderId);
	        	}
        	}
        }
        function cancel() {
        	window.parent.fileListPick.event.cancel();
	    }
        function confirm() {
        	window.parent.fileListPick.event.confirm(filePickArr);
	    }
        
    </script>
</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezWebFolder.t522' /></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<h1 style="height:36px;">
		<c:choose>
			<c:when test="${folderType eq 'C'}">
				<spring:message code='ezWebFolder.t11' />
			</c:when>
			<c:when test="${folderType eq 'D'}">
				<spring:message code='ezWebFolder.t12' />
			</c:when>
			<c:when test="${folderType eq 'U'}">
				<spring:message code='ezWebFolder.t13' />
			</c:when>
		</c:choose>
		<span id="mailBoxInfo"></span>
		<div id="capacity-wrapper">
			<div class="progressbar">
				<div id="capacity-bar" class="proggress"></div>
			</div>
			<span id="capacity-percent"></span>
		</div>
	</h1>
	<div id="pageArea">
		<div style="height:40px;">
			<div style="font-size: 24px;font-weight: bold;font-weight: bold; padding: 8px 4px 0px;" id ="originalPath" ></div>
		</div>
		<div id="mainmenu">
			<ul>
				<input type="text" id="searchFileName" style="float:left;margin-right:3px;height:31px;" value="" name="searchFileName" placeholder="<spring:message code='ezWebFolder.t523' />">
<!-- 				<input type="text" id="searchFileName" style="float:left;margin-right:3px;height:31px;" value="" name="searchFileName" placeholder="파일명 검색"> -->
				<li id="SearchOption" mode="off" onclick="search('basic')"><span class="icon16 icon16_search"></span></li>
				<li><span class="icon16 icon16_refresh" onclick="refreshView()"></span></li>
				<li style="float:left;">
					<select class="select" id="idSelect" onchange="onFileTypeChange(this.value)">
						<option value=""><spring:message code='ezWebFolder.t191' /></option>
						<option value="document"><spring:message code='ezWebFolder.t192' /></option>
						<option value="music"><spring:message code='ezWebFolder.t193' /></option>
						<option value="video"><spring:message code='ezWebFolder.t194' /></option>ㅖㅖㅖ
						<option value="image"><spring:message code='ezWebFolder.t195' /></option>
						<option value="folder"><spring:message code='ezWebFolder.t213' /></option>
						<option value="zip"><spring:message code='ezWebFolder.t196' /></option>
						<option value="unknown"><spring:message code='ezWebFolder.t311'/></option>
					</select>
				</li>
			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		
	    <div id="progress-wrp" style="display: none;">
	    	<div class="progress-bar"></div ><div class="status">0%</div>
	    </div>
	 	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
	    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
		<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;" >
				<table class="mainlist" style="width:100%"  id="tblFileList1">
					<thead id ="BoardList_THEAD">
						<tr>
							<th class="wfFilecheck " style="text-align: center;" ><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></th>
							<th class="wfFileType 		headListClick" style="text-align: center;" headers="TYPE_ICON"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
							<th class="wfFileName 		headListClick" headers="FILE_NAME"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
							<th class="wfFileSize 		headListClick" style="text-align: center;" headers="FILE_SIZE"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
							<th class="wfFileUpdateDate headListClick" headers="UPDATE_DATE"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
						</tr>
					</thead>
				</table>
				<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;height:290px;">
					<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
				
					</table>
				</div>
			</div>
		</div>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <span id="mailBoxInfo"></span>
		<div id="tblPageRayer"></div>
    </div>
	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
	    <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
	<div class="btnposition btnpositionNew">
		<a class="imgbtn" onClick="confirm()" ><span><spring:message code='ezWebFolder.t116'/></span></a>
	</div>
	</body>
</html>