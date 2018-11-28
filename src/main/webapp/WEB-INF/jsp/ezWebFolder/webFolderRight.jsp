<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
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
	<!-- datepicker -->
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	<!-- module -->
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/buttons.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/share.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
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
		var folderId = "${folderId}";
		var folderType = "${folderType}";
		var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
		var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
		var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
		var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
		var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
		
		// fileList 브라우저 화면 크기 변했을때 유동적화면 변화
		window.onresize = function () {
			var reheight = document.documentElement.clientHeight - 240;
			document.getElementById("dragDropArea").style.height = reheight + "px";
			
			reheight = document.documentElement.clientHeight -90;
			document.getElementById("pageArea").style.height = reheight + "px";
			scroll();
		};
		
		document.onselectstart = function() {return false;};
		
		window.onbeforeunload = function() {
			closeAllPopup();
			searchOptionHidden();
		}
		
		window.onload = function() {
			closeAllPopup();
			$('#upload').css('display','none');
			getFileList(folderId);
			
			searchContext.setSearchStartEventHandler(function() {
				$("#idSelect").val("");
				onFileTypeChange("");
			});
			
			pagination.setPageChangeEventHandler(function() {
				getFileList(folderId);
			});
			
			window.onresize();
			
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
			parent.parent.document.getElementById("topFrame").contentWindow.document.addEventListener("mouseup", listOptionHidden, true);
			
			// listoption 클릭 이벤트
			document.getElementById("webfolderlistoptiondiv").addEventListener("click", function(event) {
				event.stopPropagation();
				optionView(event.target);
			});
			
			document.getElementById("listcount").addEventListener("change", function() {
				optionHidden();
				pagination.setListSize(this.value);
				refreshView();
			});
			
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
	    	showProgress();
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
					 "searchEndDate" 	: searchRequirement.endDate
					},
				dataType: "JSON",
				success : function (data) {
					hideProgress();
					successFile(data);
				},
				error : function(error) {
					hideProgress();
// 					alert(messages.strLang7 + error);
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
			
			if (folderUpp != 'root') {
				$('#upload').css('display','inline');
				dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
				dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
				dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
			} else {
				dragDropAreaElmt.ondragenter = null;
				dragDropAreaElmt.ondragover  = null;
				dragDropAreaElmt.ondragover  = null;
			}
			
			$('#tblFileList tr td').parent().remove();
			renderData(filelist);
			
			namePath(folderPath, originalPath);
			document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span style='color:#017BEC;'>" + fldCnt +" </span>"
			 + " / " + messages.strLang16 + " <span style='color:#017BEC;'> " 
				+ fileCnt +" </span>";
			$("#listcount").val(result.listCount).prop("selected", true);
			parent.frames["left"].drawVolume();
			scroll();
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
				
				if(length == 1) {
					/* detailName = document.createElement("div");
					/* 2018-05-07 장진혁 - 상단 폰트사이즈 15px로 조정 및 꺽새 추가 */
					//detailName.textContent =  " > " + messages.strLang17 + " "; // 모든파일
					//detailName.setAttribute("style", "font-size:15px;");
					//nameTag.appendChild(detailName);
					var divSeparator = document.createElement("div");
					divSeparator.setAttribute("class", "separator");
					divSeparator.textContent =  " > " + messages.strLang17 + " "; // 모든파일
					nameTag.appendChild(divSeparator);
				}
				
				/* 2018-05-07 장진혁 - 이미지 태그 안씀 */
				/* var imgElmt = document.createElement("img");
				imgElmt.setAttribute("style", "height: 14px; width: 14px; display: inline-block; margin: 0px 6px;");
				imgElmt.src = "/images/webfolder/arrow2.png"; */
				
				if (i != length - 1) {
/* 					detailName = document.createElement("span");
					detailName.textContent = " > ";
					nameTag.appendChild(detailName); */
					var divSeparator = document.createElement("div");
					divSeparator.textContent = " > ";
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
					var tdElmt2 = document.createElement("td");
					var tdElmt3 = document.createElement("td");
					var tdElmt4 = document.createElement("td");
					var tdElmt5 = document.createElement("td");
					var tdElmt6 = document.createElement("td");
					var tdElmt7 = document.createElement("td");	
					var tdElmt8 = document.createElement("td");	
					var tdElmt9 = document.createElement("td");
					var tdElmt10 = document.createElement("td");
					
					setStyles([tdElmt4, tdElmt5, tdElmt6, tdElmt7, tdElmt8, tdElmt9, tdElmt10], function(style) {
						style.overflow = "hidden";
						style.textOverflow = "ellipsis";
						style.whiteSpace = "nowrap";
						style.wordWrap = "normal";
					});
					
					setStyles([tdElmt2, tdElmt3, tdElmt5, tdElmt10], function(style) {
						style.textAlign = "center";
					});

					trElmt.setAttribute("class", "bnkWebFolder");
					trElmt.setAttribute("targetId", result[i]["fileId"]);
					trElmt.setAttribute("targetType", result[i]["fileTypeName"] == 'folder' ? 'D' : 'F');
					trElmt.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
					
					if (result[i]["fileTypeName"] != 'folder') {
						trElmt.addEventListener("dblclick", function(event) {
							downloadFileByDbClick(event);
							rowContext.setSelectState(this, true);
						});
					}
					
					var inputElmt = document.createElement("input");
					inputElmt.setAttribute("type", "checkbox");
					inputElmt.setAttribute("value", result[i]["fileId"]);
					inputElmt.setAttribute("class", "checkBnk");
					inputElmt.addEventListener("change", rowContext.onCheckboxChange);
					inputElmt.addEventListener("click", function(event) { event.stopPropagation(); });
					inputElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
					
					tdElmt1.appendChild(inputElmt);
					
					var faImgElmt = document.createElement("img");
					faImgElmt.setAttribute("class", "none-drag");
					faImgElmt.addEventListener("click", favoriteContext.onImageClick);
					faImgElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });
					
					if (result[i]["favouriteStatus"] == "0") {
						faImgElmt.src = "/images/ImgIcon/view-flag.gif";
					} else {
						faImgElmt.src = "/images/ImgIcon/icon-flag.gif";
						trElmt.setAttribute("favorite", "");
					}
					faImgElmt.style.height  = "14px";
					faImgElmt.style.width  	= "14px";
					
					tdElmt2.appendChild(faImgElmt);
					
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
// 					if (primary == "1") {
						tdElmt6.textContent = result[i]["createName1"];
// 					}
// 					else {
// 						tdElmt6.textContent = result[i]["createName2"];
// 					}
					
					tdElmt7.textContent = result[i]["createDate"].substring(0, 10);
					tdElmt8.textContent = result[i]["updateDate"].substring(0, 10);
					tdElmt9.textContent = result[i]["filePosition"];
					tdElmt9.setAttribute("title", result[i]["filePosition"]);
					
					tdElmt1.setAttribute("class", "wfFilecheck");
					tdElmt2.setAttribute("class", "wfFileFavorite");
					tdElmt3.setAttribute("class", "wfFileType");
					tdElmt4.setAttribute("class", "wfFileName");
					tdElmt5.setAttribute("class", "wfFileSize");
					tdElmt6.setAttribute("class", "wfFileCreator");
					tdElmt7.setAttribute("class", "wfFileUploadDate");
					tdElmt8.setAttribute("class", "wfFileUpdateDate");
					tdElmt9.setAttribute("class", "wfFilePath");
					tdElmt10.setAttribute("class", "wfFileShare");
					
					if (result[i]["fileShareStatus"] == "Y") {
						var spanElmt = document.createElement("span");
						spanElmt.innerHTML = "<img src='/images/webfolder/sharing2.png' class='webFolderImg' />";
						spanElmt.addEventListener("click", function () {
							shareContext.showShareInfo(this);
						});
						tdElmt10.appendChild(spanElmt);
					} else {
						tdElmt10.textContent = "";
					}
					
					if(result[i]["typeId"] == "folder") {
						trElmt.ondblclick = function() {
							getFileList(this.getAttribute("targetId"));
						};
					}
					
					trElmt.appendChild(tdElmt1);
					trElmt.appendChild(tdElmt2);
					trElmt.appendChild(tdElmt3);
					trElmt.appendChild(tdElmt4);
					trElmt.appendChild(tdElmt5);
					trElmt.appendChild(tdElmt6);
					trElmt.appendChild(tdElmt7);
					trElmt.appendChild(tdElmt8);
					trElmt.appendChild(tdElmt9);
					trElmt.appendChild(tdElmt10);
					
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
	        	
				if (requirement.extension == "" && requirement.name == "" && requirement.creatorName == "" && requirement.startDate == "") {
					alert(messages.strLang20);// 검색조건을 입력하세요 
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
	        optionHidden();
	        
	        // 검색 input 요소 초기화
	        $(".datepicker").datepicker('setDate', "");
	        $('#searchExt').val("");               
            $('#searchFileName').val("");
            $('#searchCreateName').val("");
            $('.datepicker').val("");
	    
	        /* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
	        var leftBody = parent.frames["left"].document.body;
	        leftBody.style.overflow = "hidden";
        	$("<div id='blockLeft' class='blockLeft' style='position: fixed;' onclick='parent.frames[\"right\"].searchOptionHidden();'></div>").appendTo(leftBody);        	
        	var popupX = parent.document.body.clientWidth / 2 - (500 / 2) - 220;
        	
        	$("#searchpopup").css("left", popupX);
        	/* 2018-02-23 장진혁 레이어팝업 왼쪽메뉴영역까지 덮기 */
        	
        	$("#searchpopup").modal();
        	$("#searchpopup").off("modal:close").on("modal:close", function() {
        		parent.frames["left"].document.body.style.overflow = "auto";
        	});
	    }
		
	    function searchOptionHidden() {
	    	$.modal.close();
	    }
   	   
	    function optionView(obj) {
	   		 if (obj.getAttribute("mode") == "off") {
	   	        document.getElementById("layer_Viewpopup").style.left = document.documentElement.clientWidth - 260 + "px";
//	    	        if(pAdminType == "y")
	   	            document.getElementById("layer_Viewpopup").style.top = "130px";
//	    	        else
//	    	            document.getElementById("layer_Viewpopup").style.top = "100px";
	   	        document.getElementById("layer_Viewpopup").style.display = "";
	   	        obj.setAttribute("src", "/images/kr/cm/btn_arrow_up.gif");
	   	        obj.setAttribute("mode", "on");
	   	    } else {
	   	        optionHidden();
	   	    }
	   	}
   	   
	 	function optionHidden() {
	 	    document.getElementById("layer_Viewpopup").style.display = "none";
	 	    document.getElementById("webfolderlistoptiondiv").setAttribute("mode", "off");
	 	    document.getElementById("webfolderlistoptiondiv").setAttribute("src", "/images/kr/cm/btn_arrow_down.gif");
	 	}
	 	
		function refreshView() {
			getFileList(folderId);
		}
       
		function onFileTypeChange(value) {
			searchContext.setFileType(value);
			pagination.setPage(1);
		}
       
		function downloadFileByDbClick(event) {
			event.stopPropagation();
			event.preventDefault();
			var trElmt       = event.currentTarget;
			var fileFolderId = trElmt.getAttribute("targetId");
			var filesList    = [];
			filesList.push(fileFolderId);
			
			var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
			AttachDownFrame.location.href = downloadUrl;
		}
		
		function openLeftPanel() {
			var leftFrame = window.parent.frames["left"].document;
			var blockLeft = leftFrame.getElementById("bnkBlockLeft");
			var height    = Math.max(leftFrame.documentElement.clientHeight, leftFrame.documentElement.scrollHeight);
			leftFrame.body.style.overflow = "hidden";
			blockLeft.style.height        = height + "px";
			blockLeft.style.display       = "";
		}

		function closeLeftPanel() {
			var leftFrame = window.parent.frames["left"].document;
			var blockLeft = leftFrame.getElementById("bnkBlockLeft");
			leftFrame.body.style.overflow = "auto";
			blockLeft.style.height        = "100%";
			blockLeft.style.display       = "none";
		}
		
		function showProgress() {
			var CurrentHeight = document.documentElement.clientHeight;
			var CurrenWidth = document.documentElement.clientWidth;
			document.getElementById("progressPanel").style.top = (CurrentHeight / 2) + "px";
			document.getElementById("progressPanel").style.left = (CurrenWidth / 2) - 100 + "px";
		    document.getElementById("progressPanel").style.display = "block";
		}
        
        function hideProgress() {
        	document.getElementById("progressPanel").style.display = "none";
        }
    </script>
</head>
<body class="mainbody" style="padding-bottom:10px;">
    <h1><spring:message code='ezWebFolder.t10' /><span id="mailBoxInfo"></span></h1>
    <div id="pageArea">
		<div style="height:40px;">
			<div style="font-size: 24px;font-weight: bold;font-weight: bold; padding: 8px 4px 0px;" id ="originalPath" ></div>
		</div>
		<div id="mainmenu">
			<ul>
				<li class="important"><span onclick="buttons.fileDownload()"><spring:message code='ezWebFolder.t186' /></span></li>
				<li class="important" id="upload"><span onclick="buttons.fileUpload()"><spring:message code='ezWebFolder.t187' /></span></li>
				<li><span onclick="buttons.fileRename()"><spring:message code='ezWebFolder.t273' /></span></li>
				<li><span onclick="buttons.fileMoveAndCopy()"><spring:message code='ezWebFolder.t275' /></span></li>
				<li><span onclick="shareContext.addShareView()"><spring:message code='ezWebFolder.t254' /></span></li>			
				<!-- <li><img src="/images/i_bar.gif" /></li> -->
				<li><span class="icon16 icon16_star" onclick="favoriteContext.toggleAll()"></span></li>
	<%-- 			<li id=""><a onClick=""     style="margin-top: 3px;"><span><spring:message code='ezWebFolder.t272'/></span></a></li> --%>
				<!-- <li><img src="/images/i_bar.gif"></li> -->
				<li id="SearchOption" mode="off" onclick="doLayerPopup(this)"><span class="icon16 icon16_search"></span></li>
				<li><span class="icon16 icon16_delete" onclick="buttons.fileDelete()"></span></li>
				<!-- <li><img src="/images/i_bar.gif"></li> -->
	<!-- 			<li id=""><a onClick="folder_Manage()"style="margin-top: 3px;"><span>폴더관리</span></a></li> -->
				<li><span class="icon16 icon16_refresh" onclick="refreshView()"></span></li>
				<!-- <li><img src="/images/i_bar.gif" /></li> -->
				<!-- <li style="float:right;border:0px;background-color: white"><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv" /></li> -->
				<div class="sub_frameIcon" style="float:right">
					<div class="sub_frameIconUL02">
					  	<p class="frameIconLI"><span mode="off" class="icon16 btn_arrow_down" id="webfolderlistoptiondiv"></span></p>  
					</div>
				</div>
				<li style="float:left;">
					<select class="select" id="idSelect" onchange="onFileTypeChange(this.value)">
						<option value=""><spring:message code='ezWebFolder.t191' /></option>
						<option value="document"><spring:message code='ezWebFolder.t192' /></option>
						<option value="music"><spring:message code='ezWebFolder.t193' /></option>
						<option value="video"><spring:message code='ezWebFolder.t194' /></option>
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
	    <!-- 파일 리스트 10~ 50 선택 -->
	    <div id="layer_Viewpopup" style="width: 250px; position: absolute; left: 0px; top: 0px; background-color: #ffffff; display: none;">
	        <div class="popupwrap1">	
	            <div class="popupwrap2">
	                <table style="width: 100%; border-spacing: 0px; border-collapse: collapse; border: none;" class="list_element">
	                    <caption></caption>
	                    <colgroup>
	                        <col style="width: 80px;">
	                        <col>
	                    </colgroup>
	                    <tr>
	                        <th><spring:message code='ezBoard.t10021' /></th>
	                        <td>
	                            <select id="listcount" style="width: 40px; height: 20px;">
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
	 	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; display: none; z-index: 5000;" id=""></div>
	    <div style="width: 8px; height: 100%; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarH"></div>
	    <div style="width: 100%; height: 8px; background-color: #808080; position: absolute; z-index: 10000; display: none;" id="ResizeBarW"></div>
		<div style="width:100%;"id ="tblFileList1_div">
			<div style="margin:0px 0px 0px !important;min-width: 700px;" >
				<table class="mainlist" style="width:100%"  id="tblFileList1">
					<thead id ="BoardList_THEAD">
						<tr>
							<th class="wfFilecheck" style="text-align: center;"><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></th>
							<th class="wfFileFavorite" style="text-align: center;"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
							<th class="wfFileType" style="text-align: center;"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
							<th class="wfFileName"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
							<th class="wfFileSize" style="text-align: center;"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
							<th class="wfFileCreator"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
							<th class="wfFileUploadDate"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
							<th class="wfFileUpdateDate"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
							<th class="wfFilePath"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
							<th class="wfFileShare"style="text-align: center;"><spring:message code='ezWebFolder.t278'/></th><!-- 공유상태 -->
						</tr>
					</thead>
				</table>
				<div id="dragDropArea"  style="overflow-y:auto;white-space:nowrap;">
					<table class="mainlist" style="width: 100%;margin:0px 0px 0px !important; white-space:nowrap;" id="tblFileList">
				
					</table>
				</div>
			</div>
		</div>
		<input id="file" type="file" onchange="onDrop()" onclick="this.value = null;" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
		<input type="hidden" onclick="fileupload()"/>
		<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	    <span id="mailBoxInfo"></span>
		<div id="tblPageRayer"></div>
    </div>
	<div id="searchpopup" class="popupwrap3" style="display:none;margin-bottom:70px">
		<div class="popupJQLayer" style="padding-top:6px">
			<div class="title"><spring:message code='ezWebFolder.t10' /><spring:message code='ezWebFolder.t123' /></div>
			<div id="close">
	            <ul>
	                <li><a rel="modal:close"><span onclick="searchOptionHidden()"></span></a></li>
	            </ul>
	        </div>
			<table class="content" style="margin-top:10px;">
				<tr>
		           <th style="text-align:center"><spring:message code='ezBoard.t210' /></th>
		           <td>
		               <input type="text" id="Sdatepicker" class="datepicker" style="width:80px;text-align:center" readonly="readonly">
		                ~
		               <input type="text" id="Edatepicker" class="datepicker" style="width:80px;text-align:center" readonly="readonly">
		           </td>
				</tr>
		        <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t152' /></th><!-- 확장자 -->
		            <td><input type="text" id="searchExt" style="width:99%" value="" name="searchExt"></td>
		        </tr>
		        <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t153' /></th><!-- 파일명 -->
		            <td><input type="text" id="searchFileName" style="width:99%" value="" name="searchFileName"></td>
		        </tr>  
		         <tr>
		            <th style="text-align:center"><spring:message code='ezWebFolder.t154' /></th><!-- 작성자 -->
		            <td><input type="text" id="searchCreateName" style="width:99%" value="" name="searchCreateName"></td>
		        </tr>    
			</table>
			<table style="width:100%">
				<tr>
					<td style="text-align:center;">
						<div class="btnpositionLayer">
							<a class="imgbtn"><span onClick="search('basic')"><spring:message code='ezAddress.t142' /></span></a>
						</div>	
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
	    <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>
