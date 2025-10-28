// 변수
		var file = new Array();
		var appType = "user";
		var filelist = [];
		var pEnd =10;
		var folderType = "C";
		var functionType = "";
		var inputNameDlg_cross_dialogArguments = new Array();
		var userId = "";
		var folderTypeCheck = "N";
		var _selectedCell = null;
		var _cellInfo = {};
		var sortColumn = null;
		var sortType = null;
		var filePickArr = new Array();
		var filePickObj = new Object();
		var jsonFolderInfo = JSON.parse(folderInfo);
		var selectFileList = new Array();
		var rootFolderId = "";
		// 오버로딩 목적으로 분리 함 : ~upload.js에서는 다른처리를 하려고.
		var displayBtnConfirm = null;
		var getFolderIdInConfirm = null;

		document.onselectstart = function() {return false;};

		window.onbeforeunload = function() {
			searchOptionHidden();
		}

		window.onload = function() {
// 			$("#dragDropArea").css("height",  window.innerHeight);

	        for (var i = 0; i < jsonFolderInfo.length; i++) {
				var option = "<option value='" + jsonFolderInfo[i].FOLDER_ID + "'>"
							+ jsonFolderInfo[i].FOLDER_NAME + "</option>";
				$('#taskRootFolder').append(option);
			}
			getFileList(folderId);

			searchContext.setSearchStartEventHandler(function() {
				$("#idSelect").val("");
				onFileTypeChange("");
			});

			pagination.setPageChangeEventHandler(function() {
				getFileList(folderId);
			});

			// 하나씩만 선택됨
// 			rowContext.setSingleMode();

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

	        var monthMsg = springMonthMsg;
			var monthStr = monthMsg.split(";");
			var dayMsg = springDayMsg;
			var dayStr = dayMsg.split(";");

	        $.datepicker.regional[springLang] = {
				closeText : springCloseText,
				prevText : springPrevText,
				nextText : springNextText,
				currentText : springCurrentText,
				monthNames : monthStr,
				monthNamesShort : monthStr,
				dayNames : dayStr,
				dayNamesShort : dayStr,
				dayNamesMin : dayStr,
				weekHeader : 'Wk',
				dateFormat : 'yy-mm-dd',
				firstDay : 0,
				isRTL : false,
				duration : 200,
				showAnim : 'show',
				showMonthAfterYear : true
	        };

	        $.datepicker.setDefaults($.datepicker.regional[springLang]);
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

	    function getFileList(newFolderId) {
			var oldFolderId = folderId;
			folderId = newFolderId;
			if (folderId == "") {
				alert(messages.strLang14);
				return;
			}

			// 공유받은폴더를 folderId가 없는 이름을 임의로 S라고 지정
			if (folderType == "S" && folderId == "S") {
				url = "/ezWebFolder/getSharedList.do";
			} else {
				url = "/ezWebFolder/fileList.do";
			}

			searchRequirement = searchContext.getCurrentRequirement();
			$.ajax ({
				type:"POST",
				async: true,
				url : url,
				data : {
					 "folderId"   		: newFolderId,
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
					successFile(data, newFolderId, oldFolderId);
					document.getElementById("countSpan").style.display = "none";
				},
				error : function(error) {
				}
			});
		}

		function successFile(data, newFolderId, oldFolderId) {
			if (data.status == "error") {
				if (data.code == 1) {
					console.log(springError1);
					return;
				} else if (data.code == 2) {
					alert(springError2);
					return;
				} else if (data.code == 3) {
					folderId = oldFolderId;
					alert(springError3);
					return;
				}
			}
			folderId = newFolderId;
			userId = data.data.userId;
			var result = data.data;

			var fileCnt = result.fileCnt;
			var fldCnt = result.fldCnt;

			var folderPath = result.folderPath;
			var originalPath = result.originalPath;
			var folderUpp = result.folderUpp;
			var dragDropAreaElmt = document.getElementById("dragDropArea");
			var filelist = [];
			if (folderType == "S" && folderId == "S") {
				filelist = result.list;
				pagination.setListSize(result.listCount);
				pagination.setAmount(result.totalCount);
			} else {
				filelist = result.fileList;
				pagination.setListSize(result.listCount);
				pagination.setAmount(result.totalRows);

			}

			pagination.build();

			$('#tblFileList tr td').parent().remove();
			renderData(filelist);
			parentId = data.data.folderUpp;

			namePath(folderPath, originalPath);

			if (displayBtnConfirm) {
				displayBtnConfirm();
			}

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
							lastTh.css("width", "15px");

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
			$('#originalPath').empty();

			// 공유받은 폴더는 폴더명이 없으므로 임의로 이름 생성
			if (folderType == "S") {
				orginalPathElmt.appendChild(nameTag);
				detailName  = document.createElement("div");
				var divName = document.createElement("div");

				detailName.id = "aName";
				detailName.className = "aName";
				detailName.onclick = function() {
					radioOnclick('S');
				};

				divName.textContent =springSharedMsg + " / " ;
				divName.setAttribute("title",  springSharedMsg );
				/* 2018-05-07 장진혁 - 상단 폰트사이즈 15px로 조정 */
				divName.setAttribute("style", "font-size:15px; padding-right:3px;");
				detailName.appendChild(divName);
				nameTag.appendChild(detailName);
			}

			if (folderPath) {
				folderPath = folderPath.substring(1, folderPath.length - 1);
				originPath = folderPath.split("|");
				path = originalPath.split("/");

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
					var parentId = ""
					if (i == 0) {
						parentId = "root";
						rootFolderId = originPath[i];
					} else {
						parentId = originPath[i - 1];
					}
					divName.setAttribute("parentId", parentId);
					detailName.appendChild(divName);
					nameTag.appendChild(detailName);

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
		}

		function nameFileList(param) {
			searchContext.clearRequirement();
			$("#idSelect").val("");
			getFileList(param);
			if (folderType == "C" && param == rootFolderId){
				$("#taskRootFolder").val(folderId).prop("selected",true);
			}
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

					var encryptedFlag = result[i]["encryptedFlag"];
					trElmt.setAttribute("encryptedFlag", encryptedFlag);

					if (result[i]["targetType"]) {
						trElmt.setAttribute("targetFunction", resultJson["folderType"]);
					}

					var creator = ""
					if (!result[i]["creatorId"]) {
						trElmt.setAttribute("targetCreater", result[i]["createId"]);
					} else {
						trElmt.setAttribute("targetCreater", result[i]["creatorId"]);
					}

					if (setInputElmt) {
						setInputElmt(result[i], trElmt, rowContext, folderId, filePickArr, tdElmt1);
					}

					var fileIconElmt = document.createElement("img");
					fileIconElmt.setAttribute("class", "webFolderImg");
					fileIconElmt.src = result[i]["fileIconUrl"];
					tdElmt3.appendChild(fileIconElmt);

					var fileName = result[i]["fileName"];
					tdElmt4.setAttribute("title", fileName);
					tdElmt4.textContent = fileName;

					if (encryptedFlag == 1) {
						tdElmt4.innerHTML = "<img src='/images/email/secureMail/security_icon.gif' width='12' /> " + tdElmt4.innerHTML;
					}

					if(result[i]["fileExt"] == "folder") {
						tdElmt5.textContent = ' - ';
					} else {
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

					if(result[i]["fileExt"] == "folder") {
						trElmt.ondblclick = function() {
							shareedFolderClick(this);
							nameFileList(this.getAttribute("targetId"));
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

		// 오버로딩 목적으로 분리 함 : ~upload.js에서는 다른처리를 하려고.
		function setInputElmt(elements, trElmt, rowContext, folderId, filePickArr, tdElmt1) {
			if(elements["fileExt"] != "folder") {
				trElmt.addEventListener("click", function(event) {rowContext.onRowClick(event, this);});
			}
			
			var divElmt = document.createElement("div");
			divElmt.setAttribute("class", "custom_checkbox");

			var inputElmt = document.createElement("input");
			inputElmt.setAttribute("type", "checkbox");
			inputElmt.setAttribute("value", elements["fileId"]);
			inputElmt.setAttribute("class", "checkBnk");
			inputElmt.addEventListener("change", rowContext.onCheckboxChange);
			inputElmt.addEventListener("click", function(event) { event.stopPropagation(); });
			inputElmt.addEventListener("dblclick", function(event) { event.stopPropagation(); });

			var selectedFileCheck = folderId + "/" + elements["fileId"];

			if (filePickArr.indexOf(selectedFileCheck) > -1){
				inputElmt.setAttribute("checked", true);
				trElmt.setAttribute("class", "bnkWebFolder2");
			}
			
			divElmt.appendChild(inputElmt);

			if (elements["fileExt"] != "folder") {
				tdElmt1.appendChild(divElmt);
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

	    function radioOnclick(obj) {
			folderType = obj;
			document.getElementById("searchFileName").value = "";
			$("#idSelect").val("").prop("selected", true);
			searchContext.clearRequirement();
			if (folderType == "S") {
				folderId = "S";
			}
			// folderType 별 최상위 폴더들 정보
			$.ajax({
				type: "GET",
				url: "/ezWebFolder/webfolderAuthFolderList.do",
				data: {
					"folderType" : obj,
					"allFileFlag" : "N",
					"parentId": ""
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
						jsonFolderInfo = data.folderInfo;
						$('#taskRootFolder').empty();
						if (jsonFolderInfo.length == 0) {
							$("#taskRootFolder").css("visibility", "hidden");
						} else {
							$("#taskRootFolder").css("visibility", "visible");
							if (folderType == "S") {
								var option = "<option value='S" + "'>"
										+ springSharedMsg + "</option>";
								$('#taskRootFolder').append(option);
							}
							for (var i = 0; i < jsonFolderInfo.length; i++) {
								var option = "<option value='"
										+ jsonFolderInfo[i].FOLDER_ID + "'>"
										+ jsonFolderInfo[i].FOLDER_NAME + "</option>";
								$('#taskRootFolder').append(option);
							}
						}

						if (folderType == "S") {
							getFileList("S");
						} else {
							getFileList(data.folderId);
						}
					}
				},
				error : function(error) {
					alert(messages.strLang7 + error);
				}
			});
		}
	    function shareedFolderClick(obj) {
			if ((folderType == "S" && folderId == "S") || (folderType == "C" && folderId == rootFolderId)) {
				$("#taskRootFolder").val(obj.getAttribute("targetid")).prop("selected", true);
			}
		}

		function enterkey(obj) {
			if (window.event.keyCode == 13) {
				search('basic');
			}
		}

		function cancel() {
			window.parent.fileListPick.event.cancel();
		}

		function confirm() {
			var trElmt = event.currentTarget;
			var filesList = [];

			if (checkBeforeConfirm(selectFileList, filesList, rowContext)) {
				return;

			} else {
				$.ajax({
					type: "POST",
					url: "/ezWebFolder/checkPermission_y.do",
					data: {
						"fileList" : filesList.toString(),
						"folderList" : (!getFolderIdInConfirm)? "" : getFolderIdInConfirm()
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
							finalConfirm();
						}
					},
					error : function(error) {
						alert(messages.strLang7 + error);
					}
				});
			}
	    }

		// 오버로딩 목적으로 분리 함 : ~upload.js에서는 다른처리를 하려고.
		function checkBeforeConfirm(selectFileList, filesList, rowContext) {
			var isReturn = false;

			if (selectFileList.length == 0) {
				alert(springConfirmError1NotFiles);
				isReturn = true;
			}

//			filesList.push(filePickArr);
			filesList.push(selectFileList);

			var selectedRows = rowContext.getSelectedRows();
			for (var i = 0; i < selectedRows.length; i++) {
				if (selectedRows[i].getAttribute("encryptedFlag") == 1) {
					alert(springConfirmError2Encrypted);
					isReturn = true;
				}
			}

			return isReturn;
        }

		function finalConfirm() {
			window.parent.fileListPick.event.confirm(mode, filePickArr);
		}

/**
 * 사용하지 않는 것으로 보임
 */
	    // 폴더관리
		function folder_Manage() {
			var OpenWin = window.open("/ezWebFolder/folderManage.do", "",
					GetOpenWindowfeature(500, 500));
			try { OpenWin.focus(); } catch (e) {}
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

		function selectLeftFolder(targetID) {
			window.parent.frames["left"].selectFolder(targetID);
		}

		function leftFolderUpdate(functionType, fileId, parentFolderId, targetId,
				folderName) {
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
				if (functionType == "mv") {
					window.parent.frames["left"].moveLeftFolder(folderList, toTargetId);
				} else if (functionType == "cp") {
					window.parent.frames["left"].copyLeftFolder(folderList, toTargetId, folderId);
				}
			}
		}