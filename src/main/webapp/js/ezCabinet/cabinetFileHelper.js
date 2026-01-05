var CabinetFileHelper = function() {
	var CabinetScroll = function() {
		return function(elementId) {
			var scrolled    = true;
			var lastScrollY = 0;
			var divElmt     = document.getElementById(elementId);
			
			if (!divElmt) {alert("Cannot find element with this id: " + elementId); return;}
			
			divElmt.onscroll = function(e) {scrollListOfItem(this);}
			
			function scrollListOfItem() {
				if (scrolled) {
					scrolled = false;
					var distance      = divElmt.scrollTop < lastScrollY ? -20 : 20;
					divElmt.scrollTop = lastScrollY + distance;
					setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
				}
			}
		}
	}();
	
	return function(data) {
		var rlWindow    = null;
		var userWindow  = null;
		var itemPopup   = null;
		var scrolled    = true;
		var lastScrollY = 0;
		var isphoto     = data.photo ? true : false;
		var itemId      = data.itemid;
		var genCallback = data.callback;
		var printCall   = data.print;
		var dloadCall   = data.download;
		var module      = data.module ? data.module : "";
		var iframeId    = data.iframe ? data.iframe : "";
		var viewType    = data.type   ? data.type   : "normal";
		var mailContent = null;
		var relatedArr  = [];
		
		function initHelper() {
			document.onselectstart  = function () { return false;}
			window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
			var cabBttnElmt         = document.getElementById("fileDivBttn");
			var cabBttnModify       = document.getElementById("fileModifyDivBttn");
			var listBttns           = cabBttnElmt.querySelectorAll('li');
			var totalBttn           = listBttns.length;
			var specialFunct        = isphoto ? fileDownloadAll : filePrint;
			
			if (cabBttnModify) {
				//Write privilege
				var listModifyBttns = cabBttnModify.querySelectorAll('li');
				
				if (totalBttn == 3) {
					listBttns[0].onclick = function(e) {fileModify()  ;};
					listBttns[1].onclick = function(e) {fileDelete()  ;};
					listBttns[2].onclick = function(e) {specialFunct();};
					//listBttns[3].onclick = function(e) {closeWindow() ;};
				}
				else if (totalBttn == 2) {
					//Community photo
					listBttns[0].onclick = function(e) {fileModify() ;};
					listBttns[1].onclick = function(e) {fileDelete() ;};
					//listBttns[2].onclick = function(e) {closeWindow();};
				}
				
				listModifyBttns[0].onclick = function(e) {saveItem()     ;};
				listModifyBttns[1].onclick = function(e) {cancelChanges();};
			}
			else {
				//Read privilege
				if (totalBttn == 1) {
					listBttns[0].onclick = function(e) {specialFunct();};
				}
				/*	listBttns[0].onclick = function(e) {specialFunct();};
					//listBttns[1].onclick = function(e) {closeWindow() ;};
				}
				else if (totalBttn == 1) {
					//Community photo
					//listBttns[0].onclick = function(e) {closeWindow();};
				}*/
			}
			
			document.getElementById("cabRlClose").onclick = function(e) {closeWindow();};
			
			getFileDetail();
		}
		
		function getFileDetail() {
			$.ajax({
				type: "GET",
				url: "/ezCabinet/getFileDetail.do",
				data: {"itemId" : itemId},
				dataType: "JSON",
				async: false,
				cache: false,
				success : function(data) {processFileDetail(data);},
				error : function(error) {alert(CabinetMessages.strError);}
			});
		}
		
		function processFileDetail(fileItem) {
			var result      = fileItem.fileDetail;
			var attachList  = fileItem.attachFileList;
			var relatedList = fileItem.relatedFileList;
			relatedArr      = [];
			
			var titleTd         = document.getElementById("title");
			titleTd.textContent = result["title"];
			titleTd.setAttribute("title", result["title"]);
			
			var summaryTd         = document.getElementById("summary");
			summaryTd.textContent = result["summary"];
			summaryTd.setAttribute("title", result["summary"]);
			
			//Related list
			var divElmt       = document.getElementById("fileListDiv");
			divElmt.innerHTML = "";
			var relDocDivElmt = divElmt.parentElement;
			while (relDocDivElmt.childElementCount > 1) {relDocDivElmt.removeChild(relDocDivElmt.lastElementChild);}
			
			if (relatedList && relatedList.length > 0) {
				var relatedScroll = new CabinetScroll("fileListDiv");
				setScrollElement(divElmt, relatedList, readRelatedItem, "relatedItemId", "title", "useStatus");
				
				for (var i = 0, len = relatedList.length; i < len; i++) {
					relatedArr.push({
						itemType  : relatedList[i]["itemType"],
						itemId    : relatedList[i]["relatedItemId"],
						itemTitle : relatedList[i]["title"]
					})
				}
			}
			
			//Attach List and content
			if (viewType == "content") {
				var iframeElmt      = document.getElementById(iframeId);
				var iframUrl        = isphoto ? "/ezCabinet/getPreviewPhoto.do" : "/ezCabinet/getPreviewContent.do?module=" + module;
				iframeElmt.src      = iframUrl;
				mailContent         = {};
				mailContent.content = result["contentPath"];
				mailContent.size    = result["itemSize"];
				mailContent.attach  = attachList;
			}
			
			genCallback(fileItem, displayUserInforPopup, showUserInfoFromId, showUserInfoFromEmail, genderScrollForElmt, mailContent);
			if (printCall) {addIframePrintScreen();}
		}
		
		function displayUserInforPopup(elementId, userId, displayFunct) {document.getElementById(elementId).onclick = function(e) {displayFunct(userId);};}
		
		function genderScrollForElmt(divElmentId, arrayList, callBackHandler, fieldId, fieldName, fieldStatus) {
			var divElement = document.getElementById(divElmentId);
			if (divElement && arrayList && arrayList.length > 0) {
				divElement.innerHTML = "";
				var elementScroll    = new CabinetScroll(divElmentId);
				setScrollElement(divElement, arrayList, callBackHandler, fieldId, fieldName, fieldStatus);
			}
		}
		
		function setScrollElement(divElmt, listObj, handlerCallBack, roleName, titleName, statusName) {
			for (var i = 0, len = listObj.length; i < len; i++) {
				var spanElmt = document.createElement("span");
				spanElmt.setAttribute("role", listObj[i][roleName]);
				spanElmt.textContent = listObj[i][titleName];
				spanElmt.className   = "rlSpanBnk";
				spanElmt.onclick = (function(itemId, status){return function() {handlerCallBack(itemId, status);}; })(listObj[i][roleName], listObj[i][statusName]);
				divElmt.appendChild(spanElmt);
				
				if (i != len - 1) {
					var divideEm         = document.createElement("em");
					divideEm.textContent = ";";
					divElmt.appendChild(divideEm);
				}
			}
		}
		
		function showUserInfoFromId(userId) {
			var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
			feature     = feature + getOpenWindowfeature(420, 450);
			userWindow  = window.open("/ezCommon/showPersonInfo.do?id=" + userId, "userInfo", feature);
		}
		
		function showUserInfoFromEmail(userMail) {
			var feature = "height=450px, width=420px, status=no, toolbar=no, menubar=no,location=no, resizable=1";
			feature     = feature + getOpenWindowfeature(420, 450);
			userWindow  = window.open("/ezCommon/showPersonInfo.do?email=" + encodeURIComponent(userMail), "userInfo", feature);
		}
		
		function getRelatedFiles() {return relatedArr;}
		function saveRelatedFiles(relatedFile) {relatedArr = JSON.parse(JSON.stringify(relatedFile)); showRelatedFiles();}
		
		function closeAllPopups() {
			if (rlWindow)  {rlWindow.close();}
			if(itemPopup)  {itemPopup.close();}
			if(userWindow) {userWindow.close();}
		}
		
		function showRelatedFiles() {
			var divElmt = document.getElementById("fileListDiv");
			while(divElmt.firstElementChild) {
				divElmt.removeChild(divElmt.firstElementChild);
			}
			
			for (var i = 0, len = relatedArr.length; i < len; i++) {
				var spanElmt = document.createElement("span");
				spanElmt.setAttribute("role", relatedArr[i]["itemId"]);
				spanElmt.textContent = relatedArr[i]["itemTitle"];
				spanElmt.className   = "rlSpanBnk";
				spanElmt.onclick = (function(itemId){return function() {readRelatedItem(itemId);}; })(relatedArr[i]["itemId"]);
				divElmt.appendChild(spanElmt);
				
				if (i != len - 1) {
					var divideEm         = document.createElement("em");
					divideEm.textContent = ";";
					divElmt.appendChild(divideEm);
				}
			}
		}
		
		function readRelatedItem(itemId, useStatus) {
			if(useStatus && useStatus == 0) {alert(CabinetMessages.strNoRelated); return;}
			
			if(itemPopup) {itemPopup.close();}
			itemPopup = window.open("/ezCabinet/cabinetFileDetail.do?itemId=" + itemId, "", getOpenWindowfeature(780, 750));
		}
		
		function getOpenWindowfeature(popUpW, popUpH) {
			var heigth   = window.screen.availHeight;
			var width    = window.screen.availWidth;
			var left     = 0;
			var top      = 0;
			var pleftpos = parseInt(width) - popUpW;
			heigth       = parseInt(heigth) - popUpH;
			left         = pleftpos / 2;
			top          = heigth / 2;
			var feature  = "height = " + popUpH + "px, width = " + popUpW + "px,left=" + left + ",top=" + top + ", status=no, toolbar=no, menubar=no,location=no, resizable=no, scrollbars=yes";
			return feature;
		}
		
		function fileDelete() {
			if (confirm(CabinetMessages.strDelete)) {
				var itemArr = [];
				itemArr.push(itemId);
				var data = {itemList : itemArr.toString()};
				$.ajax({
					type: "GET",
					url: "/ezCabinet/deleteItems.do",
					data: {itemList : itemArr.toString()},
					dataType: "JSON",
					async: false,
					cache: false,
					success : function(data) {
						var code = data.code;
						switch(code) {
							case 0 : afterDeleteSuccessfully()         ; break;
							case 1 : alert(CabinetMessages.strParamErr); break;
							case 2 : alert(CabinetMessages.strError)   ; break;
							case 3 : alert(CabinetMessages.strPerm)    ; break;
							default: alert(CabinetMessages.strError)   ; return; 
						}
					},
					error : function(error) {alert(CabinetMessages.strError);}
				});
			}
		}
		
		function fileModify() {
			//Set title
			//document.getElementById("fileFileH1").textContent = CabinetMessages.strFileMod;
			document.title = CabinetMessages.strFileMod;
			
			//Set button
			var fileDivBttn = document.getElementById("fileDivBttn");
			fileDivBttn.style.display = "none";
			
			var fileModifyDivBttn = document.getElementById("fileModifyDivBttn");
			fileModifyDivBttn.style.display = "";
			
			//Set TitleInputBox
			var titleTdElmt       = document.getElementById("title");
			var inputElmt1        = document.createElement("input"); 
			inputElmt1.value      = titleTdElmt.textContent;
			titleTdElmt.innerHTML = "";
			inputElmt1.className  = "tblFileInput";
			inputElmt1.setAttribute("id", "itemTtl");
			inputElmt1.setAttribute("maxlength", "150");
			titleTdElmt.appendChild(inputElmt1);
			
			//Set SummaryInputBox
			var summTdElmt        = document.getElementById("summary");
			var inputElmt2        = document.createElement("input"); 
			inputElmt2.value      = summTdElmt.textContent;
			summTdElmt.innerHTML  = "";
			inputElmt2.className  = "tblFileInput";
			inputElmt2.setAttribute("id", "itemSumm");
			inputElmt2.setAttribute("maxlength", "250");
			summTdElmt.appendChild(inputElmt2);
			
			//Set relatedBttn
			var relDocDivElmt         = document.getElementById("rlWrapDiv");
			var relatedBttn           = document.createElement("a");
			var relSpanElmt           = document.createElement("span");
			relatedBttn.className     = "imgbtn imgbck";
			relSpanElmt.textContent   = CabinetMessages.strSlTxt;
			relatedBttn.appendChild(relSpanElmt);
			relatedBttn.onclick       = function(e) {getRelatedPopUp();}; 
			relDocDivElmt.appendChild(relatedBttn);
		}
		
		function filePrint() {printCall(setAllScrollElmt, unsetAllScrollTd, displayIframePrintScreen, removeIframePrintScreen);}
		
		function addIframePrintScreen() {
			//Check if iframe exists
			if (viewType == "content") {
				var iframeElmt = document.getElementById(iframeId);
				iframeElmt.addEventListener("load", function(e) {cloneIframeContent();}, false);
			}
			
			var printWrapDiv = document.getElementById("cabwrapPrint");
			if (!printWrapDiv) {
				printWrapDiv = document.createElement("div");
				document.body.appendChild(printWrapDiv);
			}
			else {
				printWrapDiv.innerHTML = "";
			}
			
			var divInfo            = document.querySelector("div[class='divInfo']");
			var cloneDivInf        = divInfo.cloneNode(true);
			printWrapDiv.id        = "cabwrapPrint";
			printWrapDiv.className = "cabwrapPrintoff";
			
			printWrapDiv.appendChild(cloneDivInf);
		}
		
		function cloneIframeContent() {
			var printWrapDiv = document.getElementById("cabwrapPrint");
			var iframeElmt   = document.getElementById(iframeId);
			var iframeCont   = iframeElmt.contentWindow? iframeElmt.contentWindow: iframeElmt.contentDocument;
			var attachDiv    = iframeCont.document.getElementsByClassName("previewmail_addfile cabattach")[0];
			var divInfo      = printWrapDiv.querySelector("div[class='divInfo']");
			
			//Check if attach files exist
			if (attachDiv) {
				var ulElmt = attachDiv.lastElementChild;
				if (ulElmt.childElementCount > 0) {
					var cloneUlEmt     = ulElmt.cloneNode(true);
					var trElmt         = document.createElement("tr");
					var thElmt         = document.createElement("th");
					var tdElmt         = document.createElement("td");
					thElmt.textContent = CabinetMessages.strAttach5;
					tdElmt.setAttribute("colspan", 3);
					tdElmt.appendChild(cloneUlEmt);
					trElmt.appendChild(thElmt);
					trElmt.appendChild(tdElmt);
					divInfo.lastElementChild.appendChild(trElmt);
				}
			}
			
			var currentDiv     = printWrapDiv.querySelector("div[class='cabtxtPrint']");
			if (currentDiv) {printWrapDiv.removeChild(currentDiv);}
			
			var divText        = iframeCont.document.getElementById("txtField");
			var cloneDivText   = divText.cloneNode(true);
			var txtWrDiv       = document.createElement("div");
			
			txtWrDiv.className = "cabtxtPrint";
			txtWrDiv.appendChild(cloneDivText);
			printWrapDiv.appendChild(txtWrDiv);
		}
		
		function displayIframePrintScreen() {
			var printWrapDiv        = document.getElementById("cabwrapPrint");
			var iframeElmt          = document.getElementById(iframeId);
			var parentDiv           = iframeElmt.parentElement;
			var divInfo             = document.querySelector("div[class='divInfo']");
			parentDiv.style.display = "none";
			divInfo.style.display   = "none";
			printWrapDiv.className  = "cabwrapPrinton";
		}
		
		function removeIframePrintScreen() {
			var printWrapDiv       = document.getElementById("cabwrapPrint");
			var iframeElmt         = document.getElementById(iframeId);
			var parentDiv          = iframeElmt.parentElement;
			var divInfo            = document.querySelector("div[class='divInfo']");
			printWrapDiv.className = "cabwrapPrintoff";
			parentDiv.removeAttribute("style");
			divInfo.removeAttribute("style");
		}
		
		function displayPrintScreenForScrollTd(divElmtId) {
			var printWrapDiv = document.getElementById("cabwrapPrint");
			var divElmt      = printWrapDiv.querySelector("div[id='" + divElmtId + "']");
			
			if (divElmt) {divElmt.className = "scrollPrint";}
		}
		
		function setAllScrollElmt(arrIds) {
			for (var i = 0, len = arrIds.length; i < len; i++) {
				displayPrintScreenForScrollTd(arrIds[i]);
			}
		}
		
		function unsetAllScrollTd(arrIds) {
			for (var i = 0, len = arrIds.length; i < len; i++) {
				var divElmt = document.getElementById(arrIds[i]);
				if (divElmt) {var tdElmt = divElmt.parentElement; tdElmt.removeAttribute("style");}
			}
		}
		
		function fileDownloadAll() {dloadCall();}
		
		function saveItem() {
			var title   = document.getElementById("itemTtl").value;
			var summary = document.getElementById("itemSumm").value;
			
			if (!title.replace(/\s/g,'')) {
				alert(CabinetMessages.strNoTitle);
				var inputTtl   = document.getElementById("itemTtl");
				inputTtl.value = "";
				inputTtl.focus();
				return;
			}
			
			if (title.length > 150) {
				alert(CabinetMessages.strTitleLen);
				var inputTtl   = document.getElementById("itemTtl");
				inputTtl.value = "";
				inputTtl.focus();
				return;
			}
			
			if (summary.length > 250) {
				alert(CabinetMessages.strSummLen);
				var inputTt2   = document.getElementById("itemSumm");
				inputTt2.value = "";
				inputTt2.focus();
				return;
			}
			
			$.ajax({
				type: "POST",
				url: "/ezCabinet/modifyRelatedItem.do",
				data: {
					"itemId"      : itemId,
					"title"       : title,
					"summary"     : summary,
					"relatedList" : JSON.stringify(relatedArr)
				},
				dataType: "JSON",
				async: false,
				success : function(data) {
					var code = data.code;
					switch(code) {
						case 0 : afterChangeSuccessfully()         ; break;
						case 1 : alert(CabinetMessages.strParamErr); break;
						case 2 : alert(CabinetMessages.strError)   ; break;
						case 3 : alert(CabinetMessages.strPerm)    ; break;
						case 4 : alert(CabinetMessages.strType)    ; break;
						default: alert(CabinetMessages.strError)   ; return;
					}
				},
				error : function(error) {
					alert(CabinetMessages.strError);
				}
			});
		}
		
		function afterChangeSuccessfully() {
			alert(CabinetMessages.strModify);
			var parentWd = window.opener;
			if (parentWd) {
				var currentWd = window;
				while(!parentWd.CabinetItem) {currentWd = parentWd; parentWd = parentWd.opener;}
				parentWd.CabinetItem.reload();
				currentWd.close();
			}
			else {
				closeWindow();
			}
		}
		
		function afterDeleteSuccessfully() {
			alert(CabinetMessages.strDel);
			var parentWd = window.opener;
			if (parentWd) {
				var currentWd = window;
				while(!parentWd.CabinetItem) {currentWd = parentWd; parentWd = parentWd.opener;}
				parentWd.CabinetItem.reload();
				currentWd.close();
			}
			
			closeWindow();
		}
		
		function cancelChanges() {
			//document.getElementById("fileFileH1").textContent = CabinetMessages.strFileDet;
			document.title = CabinetMessages.strFileDet;
			
			document.getElementById("fileDivBttn").style.display       = "";
			document.getElementById("fileModifyDivBttn").style.display = "none";
			
			getFileDetail();
		}
		
		function getRelatedPopUp() {
			if (rlWindow) {rlWindow.close();}
			rlWindow = window.open("/ezCabinet/getRelatedFile.do?itemId=" + itemId + "&module=" + module, "", getOpenWindowfeature(800, 600));
		}
		
		function getIframeContent() {return mailContent;}
		function closeWindow()      {window.close();}
		
		return {
			start      : initHelper,
			get        : getRelatedFiles,
			save       : saveRelatedFiles,
			getContent : getIframeContent
		};
	}
}();