<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
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
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/duplicate-file.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/row-selector.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/capacity.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/favorite.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/buttons.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/search.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/context/share.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/popup.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
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
		var allFileFlag = "<c:out value='${allFileFlag}'/>";
		var resultErr1 = "<spring:message code='ezWebFolder.t306'/>";
		var resultErr2 = "<spring:message code='ezWebFolder.t305'/>";
		var resultErr3 = "<spring:message code='ezWebFolder.t300'/>";
		var resultErr4 = "<spring:message code='ezWebFolder.t249'/>";
		var resultErr5 = "<spring:message code='ezWebFolder.t250'/>";
		var resultErr6 = "<spring:message code='ezWebFolder.kes014'/>";
		var functionType = "";
		var inputNameDlg_cross_dialogArguments = new Array();
		var parentId = "<c:out value='${parentId}'/>";
		var userId = "";
		var folderTypeCheck = "N";
		var _selectedCell = null;
		var _cellInfo        = {};
		var sortColumn = null;
		var sortType = null;
		var containsReplyFiles = [];
		var contextClickedTr = null;
		// 회사 폴더별 관리자 지원 기능 
		var firstLevelFolderId	= "";
		var userManager = {
				targetId: "",
				targetType: ""
		};
		var selectXhr         	= null;
		var authListUser		= [];
		var strictAuthList		= [];
		var addUser    			= [];
		var deleteUser    		= [];
		var subFolderType 		= "0";
		var uploadLimit = "<c:out value='${uploadLimit}' />";
		<c:if test="${ folderManager eq '1' }">
		// 담당자로 지정된 폴더들
		var managedFolderList = ${managedFolderList};
		</c:if>
		var uploadIng = false;
		var uploadIngStatusMessage = "<spring:message code='uploadIngStatusMessage'/>";
		
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
			if (allFileFlag == "all") {
				$('#upload').css('display','none');
				$('#newFolder').css('display','none');
				if (folderType == 'C') {
					$('#SearchOption').css('display','none');
				}
			}
			getFileList(folderId);
			
			searchContext.setSearchStartEventHandler(function() {
				$("#idSelect").val("");
				onFileTypeChange("");
			});
			
			pagination.setPageChangeEventHandler(function(currentPage, listSize, fldId) {
				var getFldId = (typeof fldId == "undefined") ? folderId : fldId;
				getFileList(getFldId);
			});
			
			capacity.setFolderIdProvider(function() {
				return folderId;
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
			
			var listHeader = document.getElementsByClassName("headListClick");
			for(var i = 0 ; i <listHeader.length; i++) {
				listHeader[i].addEventListener("click", function(event) {
					sortByHeader(this);
				});
			}
			
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
//	    	folderId = a;
	    	showProgress();
			$.ajax ({
				type:"POST",
				async: true,
				url : "/ezWebFolder/fileList.do",
				data : { 
//					 "folderId"   		: folderId,
					 "folderId"   		: a,
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
					hideProgress();
					successFile(data, a);
					if(folderType == 'C' && data.status != "error"){
						folderId = a;
						containsReplyFiles = data.data.containsReplyFiles;
						managedFolderList = data.data.managedFolderList;
						mailsendBtn(data.data.folderLevel);
						/* 
						document.getElementById("userManagerBtn").style.display =
							checkIsManager(folderId) ? "" : "none";
						 */
					}
				},
				error : function(error) {
					hideProgress();
				}
			});
		}
	    
	    function mailsendBtn(folderLevel) {
	    	if ($("#sendingMail").length > 0) {
	    		var displayVal = (isNaN(parseInt(folderLevel)) || folderLevel != 1 || !checkIsManager(folderId)) ? "none" : "block";
				$("#sendingMail").css("display", displayVal);	    		
	    	}
	    }
	    
		function successFile(data, fldId) {
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
			
			folderId = (typeof fldId == "undefined") ? folderId : fldId;
			
			userId = data.data.userId;
			var result = data.data;
			
			var fileCnt = result.fileCnt;
			var fldCnt = result.fldCnt;
			
			var folderPath = result.folderPath;
			if (folderType == 'C') {
				firstLevelFolderId = result.folderPath.split("|")[2];
			}
			var originalPath = result.originalPath;
			var folderUpp = result.folderUpp;
			var dragDropAreaElmt = document.getElementById("dragDropArea");
			filelist = result.fileList;
			
			pagination.setListSize(result.listCount);
			pagination.setAmount(result.totalRows);
			pagination.build();
			
			if (folderUpp == 'root' && folderType == 'C') {
				$('#upload').css('display','none');
				$('#newFolder').css('display','none');		
				$('#SearchOption').css('display','none');	
				$('#rename').css('display','none');
				$('#moveButton').css('display','none');
				$('#moveMenu').css('display','none');
				$('#delete').css('display','none');
				dragDropAreaElmt.ondragenter = function(e) {
					e.stopPropagation();e.preventDefault();
				};
				dragDropAreaElmt.ondragover  = function(e) {
					e.stopPropagation();e.preventDefault();
				};
				dragDropAreaElmt.ondrop      = function(e) {
					e.stopPropagation();e.preventDefault();
				};
			} else {
				$('#upload').css('display','inline');
				$('#newFolder').css('display','inline');	
				$('#rename').css('display','inline');
				$('#moveButton').css('display','inline');
				$('#moveMenu').css('display','');
				$('#delete').css('display','inline');
				if (folderType == 'C') {
					$('#SearchOption').css('display','inline');				
				}
				dragDropAreaElmt.ondragenter = function(e) {onDragEnter(e)};
				dragDropAreaElmt.ondragover  = function(e) {onDragOver(e)};
				dragDropAreaElmt.ondrop      = function(e) {onDrop(e)};
			}
			
			$('#tblFileList tr td').parent().remove();
			renderData(filelist);
			parentId = data.data.folderUpp;
			
			namePath(folderPath, originalPath);
			document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp; " + messages.strLang15 + " <span class='txt_color'>" + fldCnt +" </span>"
			 + " / " + messages.strLang16 + " <span class='txt_color'> " 
				+ fileCnt +" </span>";
			$("#listcount").val(result.listCount).prop("selected", true);
			capacity.load();
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
			// folderId = param;
			searchContext.clearRequirement();
			$("#idSelect").val("");
			onFileTypeChange("", param);
			selectLeftFolder(param);
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
					
					setStyles([tdElmt1, tdElmt2, tdElmt3, tdElmt5, tdElmt10], function(style) {
						style.textAlign = "center";
					});

					if (folderType == 'C') {
						// 2020.11.03 강승구 : '제목'컬럼 좌측정렬 추가
						setStyles([tdElmt4], function(style) {
							style.textAlign = "left";
						});

						var fileName = result[i]["fileName"];
						var depth = result[i]["depth"];
						var isExpired = result[i]["expired"];
						var encryptedFlag = result[i]["encryptedFlag"];
					}
					trElmt.setAttribute("class", "bnkWebFolder");
					trElmt.setAttribute("targetId", result[i]["fileId"]);
					trElmt.setAttribute("targetType", result[i]["fileTypeName"] == 'folder' ? 'D' : 'F');
					trElmt.setAttribute("targetCreater", result[i]["createId"]);
					trElmt.setAttribute("targetPath", result[i]["filePosition"]);
					if (folderType == 'C') {
						trElmt.setAttribute("encryptedFlag", encryptedFlag);
						trElmt.setAttribute("depth", depth);
						trElmt.setAttribute("expired", isExpired);
					}
					
					if (result[i]["targetType"]) {
						trElmt.setAttribute("targetFunction", resultJson["folderType"]);
					}
					
					var creator = ""
					if (!result[i]["creatorId"]) {
						trElmt.setAttribute("targetCreater", result[i]["createId"]);
					} else {
						trElmt.setAttribute("targetCreater", result[i]["creatorId"]);
					}
					trElmt.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
					trElmt.addEventListener("contextmenu", openContextMenu);
					
					if (result[i]["fileTypeName"] != 'folder') {
						trElmt.addEventListener("dblclick", function(event) {
							/* if (this.getAttribute("encryptedFlag") == "1") {
								unidocsWebViewer(event);
							} else {
							} */
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
					tdElmt1.addEventListener("click", function(event) { 
						this.firstChild.click();
						event.stopPropagation();
					});
					
					
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
					
					var fileExt = result[i]["fileExt"];
					if (fileExt) {
						tdElmt4.setAttribute("ext", fileExt);
					}
					
					if (folderType == 'C') {
						if (depth > 1) {
							var additional = "↪ ";
	
							for (var j = 0; j < depth - 1; j++) {
								additional = " " + additional;
							}
	
							tdElmt4.innerHTML = additional + tdElmt4.innerHTML;
						} else if (isExpired && (result[i]["folderPath"].match(/\|/g) || []).length  == 3) {
							// 회의실 만료된거임
							tdElmt4.innerHTML += "<span style='color:red;font-weight:bold;'>&nbsp;<spring:message code='webfolder.meeting.expired'/></span>";
						}
	
						if (encryptedFlag == 1) {
							tdElmt4.innerHTML = "<img src='/images/email/secureMail/security_icon.gif' width='12' /> " + tdElmt4.innerHTML;
						}
					}
					
					if(result[i]["typeId"] == "folder") {
						tdElmt5.textContent = ' - ';
					}else {
						tdElmt5.textContent = getFileSize(result[i]["fileSize"]);
					}
					
					tdElmt6.textContent = result[i]["createName1"];
					tdElmt6.setAttribute("value",result[i]["createId"]);
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
						//	if (folderType == 'C') {
								nameFileList(this.getAttribute("targetId"))
						//	} else {
						//		folderId = this.getAttribute("targetId");
						//		selectLeftFolder(this.getAttribute("targetId"));
						//		getFileList(this.getAttribute("targetId"));
						//	}
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
					if (folderType != 'C') {
						trElmt.appendChild(tdElmt10);
					}
					
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

		function refreshView() {
			getFileList(folderId);
		}
       
		function onFileTypeChange(value, fldId) {
			searchContext.setFileType(value);
			pagination.setPage(1, false, fldId);
		}
       
		function downloadFileByDbClick(event) {
			event.stopPropagation();
			event.preventDefault();
			var trElmt       = event.currentTarget;
			var fileFolderId = trElmt.getAttribute("targetId");
			var filesList    = [];
			filesList.push(fileFolderId);
			
			if (folderType == 'C') {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/selectedFolderCheckPermission.do",
					data: {
						"fileId" : fileFolderId.toString()
					},
					dataType: "JSON",
					async: true,
					success : function(data) {
						var result = data.status;
						
						if (result != "ok" && data.code == "3") {
							alert(messages.strLang25);
						} else if (data.code == "1") {
							alert(messages.strLang7);
						} else {
							var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
							AttachDownFrame.location.href = downloadUrl;
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			} else {
				var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + filesList.toString();
				AttachDownFrame.location.href = downloadUrl;
			}
			
		}
		
		function unidocsWebViewer(event){
			var trElmt = event.currentTarget;
			var targetCreator = trElmt.getAttribute("targetcreater");

			if (targetCreator === userId && !confirm(messages.webviewerConfirm)) {
				downloadFileByDbClick(event);
				return;
			}

			event.stopPropagation();
			event.preventDefault();
			var fileId = trElmt.getAttribute("targetId");
			
			unidocsWebViewerOpen(fileId);
		}
		
		function unidocsWebViewerOpen(fileId) {
			showLoading();

			$.ajax({
				type: "POST",
				async: true,
				url: "/ezWebFolder/webfolderFileDownForUnidocs.do",
				data: JSON.stringify({
					"folderId": folderId,
					"fileId": fileId
				}),
				contentType: "application/json; charset=UTF-8",
				dataType: "JSON",
				success: function(result) {
					if (result.status == "OK") {
						var unidocsUrl = result.url + result.encData;
						window.open(unidocsUrl, '_blank');
					} else if (result.code == -1) {
						alert("<spring:message code='webfolder.wfjob.notsupport' />");
					} else if (result.code == 3) {
						alert(messages.strLang25);
					} else {
						alert("<spring:message code='ezWebFolder.t305' />");
					}
				},
				error: function(error) {
					alert("<spring:message code='ezWebFolder.t305' />");
				},
				complete: function() {
					hideLoading();
				}
			});
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
			if (folderType == 'C') {
				listLoading(true);
			} else {
				var CurrentHeight = document.documentElement.clientHeight;
				var CurrenWidth = document.documentElement.clientWidth;
				document.getElementById("progressPanel").style.top = (CurrentHeight / 2) + "px";
				document.getElementById("progressPanel").style.left = (CurrenWidth / 2) - 100 + "px";
			    document.getElementById("progressPanel").style.display = "block";
			}
		}
        
        function hideProgress() {
			if (folderType == 'C') {
				listLoading(false);
			} else {
	        	document.getElementById("progressPanel").style.display = "none";
			}
        }
        
		function showLoading() {
			openLeftPanel();
			document.getElementById("webFolderRightPanel").style.display = "block";
			document.getElementById("webFolderRightPanel").style.background = "rgba(0,0,0,0.5)";
			showProgress();
		}

		function hideLoading() {
			hideProgress();
			document.getElementById("webFolderRightPanel").style.display = "none";
			closeLeftPanel();
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

		function hasContainsReplyFiles(fileIds) {
			if (!window.containsReplyFiles) {
				return false;
			}

			for (var i = 0; i < fileIds.length; i++) {
				for (var j = 0; j < containsReplyFiles.length; j++) {
					if (fileIds[i] == containsReplyFiles[j]) {
						return true;
					}
				}
			}

			return false;
		}

		// 2020-12-10 김은실 - (카이스트)회사 폴더별 관리자 지원 기능 
		function checkIsManager(folderId) {
			if (folderType != 'C' || !window.managedFolderList) {
				return false;
			}
			
			// 담당 1레벨 폴더 안으로 들어 왔으면 true
			if (managedFolderList.indexOf(firstLevelFolderId) > -1) {
				return true;
			}
			
			// 파라미터로 넘어온 폴더가 담당하는 폴더인 경우 true
			if (typeof(folderId) === "string") {
				// 문자열이면 바로 검사
				return managedFolderList.indexOf(folderId) > -1;
			} else if (typeof(folderId) === "object") {
				// 배열이면 반복문 검사
				for (var i = 0; i < folderId.length; i++) {
					if (managedFolderList.indexOf(folderId[i]) > -1) {
						return true;
					}
				}
			}
			
			return false;
		}
		
		function getUsersPage_manager() {
			authListUser = [];			
			addUser      = [];
			deleteUser   = [];
			var url 	 = "";
			if (selectXhr) {
				selectXhr.abort();
			}
			
			var selectedRows = rowContext.getSelectedRows();

			if (selectedRows.length < 1 || selectedRows.length > 1) {
				alert(messages.strLang39);
				return;
			}

			var targetRow = selectedRows[0];
			var targetId = targetRow.getAttribute("targetid");
			var targetType = targetRow.getAttribute("targettype");
			if (Number(targetRow.getAttribute("depth")) > 1) {
				alert("<spring:message code='ezWebFolder.kes019'/>");
				return;
			}
			if (!checkIsManager(targetId) && targetRow.getAttribute("targetcreater") != userId) {
				alert("<spring:message code='ezWebFolder.kes020' />");
				return;
			}

			if (targetType == "D"){
				url = "/admin/ezWebFolder/getFolderUsers.do"; 
			} else {
				url = "/admin/ezWebFolder/getFileUsers.do";
			}
			
			data = {
				"fileId"	: targetId,
				"folderId"	: targetId,
				"folderManager" : "${folderManager}"
			}

			// global
			userManager.targetId = targetId;
			userManager.targetType = targetType;

			selectXhr = $.ajax({
				type: "POST",
				url: url,
				data: data,
				dataType: "JSON",
				async: true,
				success : function(data) {
					var code = data.code;
					
					switch(code) {
						case 0:
							var folderUsers = data.folderUsers;
							if(folderUsers != null && folderUsers.length != 0) {
								for (var i = 0; i < folderUsers.length ; i++) {
									if(folderUsers[i]["folderManager"]) {
										continue;
									}
									var auth         		= {};
									auth["userId"]   		= folderUsers[i]["userId"];
									auth["userName"] 		= "<spring:message code='main.t0619' />" == "ko" ? folderUsers[i]["displayName1"] : folderUsers[i]["displayName2"];
									auth["userType"]   		= folderUsers[i]["userType"];
									auth["subdeptPermitted"]= folderUsers[i]["subdeptPermitted"];
									auth["sn"] 		 		= i;
									auth["folderManager"]	= folderUsers[i]["folderManager"];
									auth["displayDeptName"] = "<spring:message code='main.t0619' />" == "ko" ? folderUsers[i]["displayDeptName1"] : folderUsers[i]["displayDeptName2"];
									authListUser.push(auth);
								}
								strictAuthList 		= authListUser;
							}
							menu_SelectRange("${companyId}", 0);
							break;
						case 1:
							alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							alert("<spring:message code='ezWebFolder.t300' />");
							break;
					}
				},
				error : function(error) {
					if (error.statusText == "abort") {
						return;
					}
        
					alert("<spring:message code='ezWebFolder.t134'/>" + error);
				},
				complete: function() {
					selectXhr = null;
				}
			});
		}
		
		function saveChanges_manager(returnMsg) { // returnMsg == ture ? return message : alert message;
			if(addUser.length == 0 && deleteUser.length == 0) {
				return;
			}
			
			var strAuthListUser = (typeof authListUser == "string")? authListUser : JSON.stringify(authListUser);
			var ajaxData = {
					"currFolderId"  : folderId,
					"targetId"   	: userManager.targetId,
					"targetType" 	: userManager.targetType,
					"folderUsers" 	: strAuthListUser,
					"addUser" 		: convertJSONToJSONStr(addUser),
					"deleteUser" 	: convertJSONToJSONStr(deleteUser),
					"subFolderType"	: subFolderType,
					"folderManager" : "${folderManager}"
				};
	   		var reMsg = "";
			
			$.ajax({
				type: "POST",
				url: "/ezWebFolder/changeUserFileORFolder.do",
				data: ajaxData,
				dataType: "JSON",
				async: false,
				success: function(data) {
					var code = data.code;
					
					switch(parseInt(code)) {
						case 0: 
							reMsg = "<spring:message code='ezWebFolder.t182'/>";
							//alert("<spring:message code='ezWebFolder.t182'/>");
							break;
						case 1:
							reMsg = "<spring:message code='ezWebFolder.t306'/>";
							//alert("<spring:message code='ezWebFolder.t306'/>");
							break;
						case 2:
							reMsg = "<spring:message code='ezWebFolder.t305'/>";
							//alert("<spring:message code='ezWebFolder.t305'/>");
							break;
						case 3:
							reMsg = "<spring:message code='ezWebFolder.t300' />";
							//alert("<spring:message code='ezWebFolder.t300' />");
							break;
						case 8:
							reMsg = messages.resultErrDuplicateRename;
							//alert(messages.resultErrDuplicateRename);
							break;
					}
				},
				error: function (xhr, status, e){
					reMsg = "<spring:message code='ezWebFolder.t134'/>";
					//alert("<spring:message code='ezWebFolder.t134'/>");
				}
			});

			
			if (returnMsg) {
				return reMsg;
			} else {
				alert(reMsg);
			}
		}
		
		function convertJSONToJSONStr(obj) {
			var returnStr = obj;
			if (typeof returnStr != "string") {
				var tmp = obj.length == 0 ? [] : obj;
				returnStr = JSON.stringify(tmp);
			}
			
			return returnStr;
		}
    </script>
</head>
<body class="mainbody" style="padding-bottom:10px;">
	<h1>
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
				<li class="important"><span onclick="buttons.fileDownload()"><spring:message code='ezWebFolder.t161' /></span></li>
				<li class="important" id="upload"><span onclick="buttons.fileUpload()"><spring:message code='ezWebFolder.t160' /></span></li>
				<c:if test="${usePreview}">
					<li id="previewButton"><span onclick="buttons.filePreview()"><spring:message code='main.t4009' /></span></li>
				</c:if>
				<li id ="newFolder"><span onclick="buttons.newFolder()"><spring:message code='ezWebFolder.t255' /></span></li>
				<li id="rename"><span onclick="buttons.fileRename()"><spring:message code='ezWebFolder.t508' /></span></li>
		<c:choose>
			<c:when test="${folderType eq 'C'}">
				<li id="moveButton"><span onclick="buttons.fileMoveAndCopy()"><spring:message code='ezWebFolder.t251' /></span></li>
				<c:if test="${useVersionHistory}">
					<li><span onclick="buttons.openFileVersionHistory()"><spring:message code='webfolder.version.button' /></span></li>
				</c:if>
					<li id="userManagerBtn"><span onclick="getUsersPage_manager()"><spring:message code='ezWebFolder.kes013' /></span></li>
					<li><span class="icon16 icon16_star" onclick="favoriteContext.toggleAll()" title="<spring:message code='ezWebFolder.t216' />"></span></li>
				<li id="SearchOption" mode="off" onclick="doLayerPopup(this)"><span class="icon16 icon16_search" title="<spring:message code='ezWebFolder.t123' />"></span></li>
				<li id="delete"><span class="icon16 icon16_delete" onclick="buttons.fileDelete()" title="<spring:message code='ezWebFolder.t111' />"></span></li>
			</c:when>
			<c:otherwise>
				<li><span onclick="buttons.fileMoveAndCopy()"><spring:message code='ezWebFolder.t251' /></span></li>
				<c:if test="${useVersionHistory}">
					<li><span onclick="buttons.openFileVersionHistory()"><spring:message code='webfolder.version.button' /></span></li>
				</c:if>
				<li><span onclick="shareContext.addShareView()"><spring:message code='ezWebFolder.t254' /></span></li>			
				<!-- <li><img src="/images/i_bar.gif" /></li> -->
				<li><span class="icon16 icon16_star" onclick="favoriteContext.toggleAll()"></span></li>
			</c:otherwise>
		</c:choose>
		<c:if test="${folderType ne 'C'}">
				<li id="SearchOption" mode="off" onclick="doLayerPopup(this)"><span class="icon16 icon16_search"></span></li>
				<li><span class="icon16 icon16_delete" onclick="buttons.fileDelete()"></span></li>
				<!-- <li><img src="/images/i_bar.gif"></li> -->
		</c:if>
	<!-- 			<li id=""><a onClick="folder_Manage()"style="margin-top: 3px;"><span>폴더관리</span></a></li> -->
				<li><span class="icon16 icon16_refresh" onclick="refreshView()"></span></li>
				<!-- <li><img src="/images/i_bar.gif" /></li> -->
				<!-- <li style="float:right;border:0px;background-color: white"><img src ="/images/kr/cm/btn_arrow_down.gif" alt="" mode="off" id="webfolderlistoptiondiv" /></li> -->
				<div class="sub_frameIcon" style="float:right" id="wfOptionDiv">
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
	                        <col style="width: 100px;">
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
							<th class="wfFilecheck " style="text-align: center;" ><input type="checkbox" onchange="rowContext.selectAll(this.checked)" id="_checkAll"></th>
							<th class="wfFileFavorite 	headListClick" style="text-align: center;" headers="FAVORITE_STATUS"><img class="none-drag" src='/images/ImgIcon/icon-flag.gif'/></th><!-- 즐겨찾기 -->
							<th class="wfFileType 		headListClick" style="text-align: center;" headers="TYPE_ICON"><spring:message code='ezWebFolder.t188'/></th><!-- 유형 -->
							<th class="wfFileName 		headListClick" headers="FILE_NAME"><spring:message code='ezWebFolder.t156'/></th><!-- 이름 -->
							<th class="wfFileSize 		headListClick" style="text-align: center;" headers="FILE_SIZE"><spring:message code='ezWebFolder.t157'/></th><!-- 파일크기 -->
							<th class="wfFileCreator 	headListClick" headers="CREATE_NAME1"><spring:message code='ezWebFolder.t189'/></th><!-- 게시자 -->
							<th class="wfFileUploadDate headListClick" headers="CREATE_DATE"><spring:message code='ezWebFolder.t190'/></th><!-- 등록일 -->
							<th class="wfFileUpdateDate headListClick" headers="UPDATE_DATE"><spring:message code='ezWebFolder.t198'/></th><!-- 갱신일 -->
							<th class="wfFilePath 		" headers="FILE_PATH"><spring:message code='ezWebFolder.t199'/></th><!-- 위치 -->
						<c:if test="${folderType ne 'C'}">
							<th class="wfFileShare 		headListClick" style="text-align: center;" headers="FILESHARE_STATUS"><spring:message code='ezWebFolder.t278'/></th><!-- 공유상태 -->
						</c:if>
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
<c:if test="${folderType eq 'C'}">
	<%@ include file="/WEB-INF/jsp/ezWebFolder/component/downloadOptionPopup.jsp" %>
</c:if>
	<div style="width:200px;height:110px; border-radius:8px;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="progressPanel">
	    <img src="/images/email/progress_img.gif" style="padding-top:20px;"/>
	</div>
<c:if test="${folderType eq 'C'}">
	<div id="listload_div" class="loadingBox2" style="display:none; z-index:7500;">
		<div class="loader loader-3">
			<div class="dot dot1"></div>
			<div class="dot dot2"></div>
			<div class="dot dot3"></div>
			<div class="dot dot4"></div>
		</div>
	</div>
</c:if>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
<c:if test="${folderType eq 'C'}">
	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:5000;display:none;" id="webFolderRightPanel">&nbsp;</div>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/selectUsers.js')}"></script>
</c:if>
	<%@ include file="/WEB-INF/jsp/ezWebFolder/component/contextMenu.jsp" %>
	<%@ include file="/WEB-INF/jsp/ezWebFolder/webFolderApplyPopUp.jsp" %>
</body>
</html>
