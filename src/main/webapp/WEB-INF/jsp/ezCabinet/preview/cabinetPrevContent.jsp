<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<c:if test="${module != 'jounl' && module != 'mjounl' && module !='apprv' && module !='mapprv' && module !='commu' && module !='mcommu'}">
			<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		</c:if>
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezCabinet/cabinet.css')               }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/previewmail.css')                     }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/css/ezTask/circularProgressBar.css')      }">
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<c:if test="${module == 'jounl' || module == 'mjounl' || module =='apprv' && module =='mapprv'}">
			<style type="text/css">p {margin-top: 0px; margin-bottom: 0px;}</style>
		</c:if>
		<c:if test="${module == 'option' || module == 'moption'}">
			<style type="text/css">p {font-size: 12px; color: #393939;}</style>
		</c:if>
	</head>
	<body style="padding: 8px; margin: 0px;">
		<div class="zoomDiv"><img src="/images/minus.png"><img src="/images/plus.png"></div>
		<iframe name="attachFrame" id="attachFrame" style="display: none;"></iframe>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')            }"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')  }"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezTask/circularProgressBar.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezCabinet.lang', 'msg')            }"></script>
		<script type="text/javascript">
			var CabinetContentPreview = function() {
				var currentZoom     = 100;
				var maxZoom         = 200;
				var minZoom         = 80;
				var mozCrrZoom      = 1;
				var mozMaxZoom      = 2;
				var mozMinZoom      = 0.8;
				var cabinetVar      = null;
				var documentContent = null;
				
				function initEvents(moduleName) {
					getContentFromModuleName(moduleName);
					document.onselectstart = function() {return false;};
					var previewZoomElmt    = document.querySelector("div[class='zoomDiv']");
					var imgList            = previewZoomElmt.children;
					imgList[0].onclick     = function() {zoomOut();};
					imgList[1].onclick     = function() {zoomIn();};
					
					var attachSize  = documentContent.size;
					var attachList  = documentContent.attach;
					var totalFiles  = attachList ? attachList.length : 0;
					var moduleType  = documentContent.type;
					
					if (totalFiles > 0) {
						var divElmt    = document.createElement("div");
						var pElmt      = document.createElement("p");
						var spanChild1 = document.createElement("span");
						var spanChild2 = document.createElement("span");
						var spanChild3 = document.createElement("span");
						var ulElmt     = document.createElement("ul");
						
						divElmt.className    = "previewmail_addfile cabattach";
						pElmt.className      = "title";
						pElmt.textContent    = CabinetMessages.strAttach3;
						spanChild1.innerHTML = " - <b>" + totalFiles + CabinetMessages.strItem + "</b>(" + getFileSize(attachSize) + ")";
						spanChild2.className = "icon_grayup";
						spanChild2.onclick   = function(e) {toggleAttachFileView(this);};
						spanChild3.className = "title_btn";
						spanChild3.textContent = CabinetMessages.strAttach4;
						spanChild3.onclick     = function(e) {downloadAllFiles(this);};
						
						pElmt.appendChild(spanChild1);
						pElmt.appendChild(spanChild2);
						pElmt.appendChild(spanChild3);
						divElmt.appendChild(pElmt);
						
						for (var i = 0, len = totalFiles; i < len; i++) {
							var liElmt             = document.createElement("li");
							var liSpanChild1       = document.createElement("span");
							var liSpanChild2       = document.createElement("span");
							var spanChild          = document.createElement("span");
							
							if ((moduleName == "apprv" || moduleName == "mapprv") && attachList[i]["filePath"].indexOf("openAttachView") != -1) {
								liElmt.setAttribute("onclick", attachList[i]["filePath"]);
								spanChild.textContent  = attachList[i]["fileName"];
							}
							else {
								liElmt.onclick = (function(name, path) {return function() {downloadFileAttach(name, path);}; })(attachList[i]["fileName"], attachList[i]["filePath"]);
								spanChild.textContent  = attachList[i]["fileName"] + " (" + getFileSize(attachList[i]["fileSize"]) + ")";
							}
							
							liSpanChild1.className = "cabSpanAttach";
							liSpanChild2.className = "cabSpanAttach";
							liSpanChild1.innerHTML = "<img src='/images/icon_adddownload.gif'>";
							liSpanChild2.appendChild(spanChild);
							liElmt.appendChild(liSpanChild1);
							liElmt.appendChild(liSpanChild2);
							ulElmt.appendChild(liElmt);
							divElmt.appendChild(ulElmt);
						}
						
						document.body.appendChild(divElmt);
					}
					
					var divMainElmt       = document.createElement("div");
					divMainElmt.id        = "txtField";
					divMainElmt.className = "cabrltxt";
					divMainElmt.innerHTML = documentContent.content;
					document.body.appendChild(divMainElmt);
				}
				
				function getContentFromModuleName(moduleName) {
					switch (moduleName) {
						case "mail"    : documentContent = parent.CabinetEmailFile.getContent()    ; break;
						case "apprv"   : documentContent = parent.CabinetApprovalFile.getContent() ; break;
						case "board"   : documentContent = parent.CabinetBoardFile.getContent()    ; break;
						case "option"  : documentContent = parent.CabinetOptionFile.getContent()   ; break;
						case "commu"   : documentContent = parent.CabinetCommunityFile.getContent(); break;
						case "resrc"   : documentContent = parent.CabinetResourceFile.getContent() ; break;
						case "schedl"  : documentContent = parent.CabinetScheduleFile.getContent() ; break;
						case "todo"    : documentContent = parent.CabinetTodoFile.getContent()     ; break;
						case "jounl"   : documentContent = parent.CabinetJournalFile.getContent()  ; break;
						case "mapprv"  : documentContent = parent.CabinetItem.getContent()         ; break;
						case "mjounl"  : documentContent = parent.CabinetItem.getContent()         ; break;
						case "mcommu"  : documentContent = parent.CabinetItem.getContent()         ; break;
						case "moption" : documentContent = parent.CabinetItem.getContent()         ; break;
						default       : if (parent.CabinetItem) {documentContent = parent.CabinetItem.getContent();}
					}
				}
				
				function downloadAllFiles(spanElmt) {
					var ulElmt  = spanElmt.parentElement.parentElement.lastElementChild;
					var counter = 0;
					downloadOneFile(ulElmt, 0);
				}
				
				function downloadFileAttach(fileName, filePath) {
					var downloadUrl = "/ezCabinet/downloadAttachFile?filePath=" + encodeURIComponent(filePath) + "&fileName=" + encodeURIComponent(fileName);
					var attachFrame = document.getElementById("attachFrame");
					attachFrame.src = downloadUrl;
				}
				
				function downloadOneFile(ulElmt, index) {
					var liList = ulElmt.children;
					if (index >= liList.length) {return;}
					ulElmt.children[index].click();
					setTimeout(function() {downloadOneFile(ulElmt, index + 1);}, 2000);
				}
				
				function toggleAttachFileView(spanObj) {
					var currentClass = spanObj.className;
					var ulElmt       = spanObj.parentElement.parentElement.lastElementChild;
					if (currentClass == "icon_graydown") {
						spanObj.className = "icon_grayup";
						ulElmt.className  = "";
					}
					else {
						spanObj.className = "icon_graydown";
						ulElmt.className  = "cabuloff";
					}
				}
				
				function getFileSize(fileSize) {
					var result = fileSize + "B";
					
					switch(true) {
						case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
						case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2)    + "MB"; break;
						case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2)       + "KB"; break;
					}
					return result;
				}
				
				function zoomIn() {
					var txtFieldElmt = document.getElementById("txtField");
					if (!txtFieldElmt) {return;}
					
					if (navigator.userAgent.indexOf('Firefox') != -1) {
						if (mozCrrZoom < mozMaxZoom) {mozCrrZoom += 0.1;} else {return;}
						txtFieldElmt.style.MozTransform = "scale(" + mozCrrZoom + ")";
						txtFieldElmt.style.MozTransformOrigin = "0 0";
					}
					else {
						if (currentZoom < maxZoom) {currentZoom += 10;} else {return;}
						txtFieldElmt.style.zoom = currentZoom + "%";
					}
				}
				
				function zoomOut() {
					var txtFieldElmt = document.getElementById("txtField");
					if (!txtFieldElmt) {return;}
					
					if (navigator.userAgent.indexOf('Firefox') != -1) {
						if (mozCrrZoom > mozMinZoom) {mozCrrZoom -= 0.1;} else {return;}
						txtFieldElmt.style.MozTransform = "scale(" + mozCrrZoom + ")";
						txtFieldElmt.style.MozTransformOrigin = "0 0";
					}
					else {
						if (currentZoom > minZoom) {currentZoom -= 10;} else {return;}
						txtFieldElmt.style.zoom = currentZoom + "%";
					}
				}
				
				return {init : initEvents};
			}();
			
			function openAttachView(wfileLocation, wName, wWeigth, wHeigth) {
				try {
					var heigth = window.screen.availHeight;
					var width  = window.screen.availWidth;
					var left   = 0;
					var top    = 0;
					
					if (window.screen.width > 800) {
						var pleftpos = parseInt(width) - wWeigth;
						heigth       = parseInt(heigth) - 30;
						width        = parseInt(width) - pleftpos;
						left         = (pleftpos / 2) + 30;
						top          = 30;
					}
					else {
						heigth = parseInt(heigth) - 30;
						width = parseInt(width) - 10;
					}
					
					window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
				}
				catch (e) {
					alert("openAttachView :: " + e.description);
				}
			}
			
			function Item_View(vItem, pCItemID, vWriter, pBrdid, vGbnBoard, pBrdnm, brd_Gubun) {
				var pcurpage = "1", pBrdMod = "WorkBoard", pDeptBoardYN = "N", pAdminFg = "0";
				var rep = new RegExp("&", "gi");
				Brdnm   = pBrdnm.replace(rep, "chr(38)");
				pURL    = "/Myoffice/ezboard/gwBoard_Get_View.aspx?BoardID=" + pBrdid + "&ItemID=" + vItem + "&GoTopage=" + pcurpage + "&Brd_mod=" + pBrdMod + "&Brdnm=" + Brdnm + "&CItemID=" + pCItemID;
				pURL    = pURL + "&WUserID=" + vWriter + "&DeptBoardYN=" + pDeptBoardYN + "&AdminFg=" + pAdminFg + "&pGbnBoard=" + vGbnBoard + "&pbrdGubun=" + brd_Gubun;
				
				var openLocation = pURL;
				openwindow(openLocation, "", 880, 550);
			}
			
			function Item_View_New(pBoardID, pItemID, pBoardType) {
				if (pBoardType == "3" || pBoardType == "4") {
					var pheight = window.screen.availHeight;
					var pwidth  = window.screen.availWidth;
					var pTop    = (pheight - 720) / 2;
					var pLeft   = (pwidth - 765) / 2;
					var xmlhttp = createXMLHttpRequest();
					xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
					xmlhttp.send();
					if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
						window.open("/myoffice/ezBoardSTD/BoardItemView_Photo.aspx?&ItemID=" + pItemID + "&BoardID=" + pBoardID + "&location=GENERAL", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=780,width=765,top=" + pTop + ",left=" + pLeft, "");
					}
					else {
						alert(CabinetMessages.strDelete2);
					}
				}
				else {
					var pheigth   = window.screen.availHeight;
					var pwidth    = window.screen.availWidth;
					pheigth       = parseInt(pheigth) / 2;
					pwidth        = parseInt(pwidth) / 2;
					pheigth       = pheigth - 284;
					pwidth        = pwidth - 359;
					var isDotNet  = false;
					var dotNetUrl = null;
					var xmlhttp   = createXMLHttpRequest();
					xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
					xmlhttp.send();
					
					// 반환값이 http로 시작하면 닷넷 게시판으로 연동하는 경우이다.
					if (xmlhttp.responseText.substring(0, 4) == "http") {
						isDotNet  = true;
						dotNetUrl = xmlhttp.responseText;
					}
					
					if (isDotNet) {
						xmlhttp.open("POST", dotNetUrl + "/myoffice/ezBoardSTD/interASP/GetItemViewNew.aspx?pBoardID=" + pBoardID + "&pItemID=" + pItemID, false);
						xmlhttp.withCredentials = true;
						xmlhttp.send();            
					} 
					
					if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
						if (isDotNet) {
							window.open(dotNetUrl + "/myoffice/ezBoardSTD/BoardItemView_Cross.aspx?ItemID=" + pItemID + "&BoardID=" + pBoardID, "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no,scrollbars=1, resizable=1, top=0, left=0", "");                
						}
						else {
							window.open("/ezBoard/boardItemView.do?itemID=" + pItemID + "&boardID=" + pBoardID, "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no,scrollbars=1, resizable=1, top=0, left=0", "");
						}
					}
					else {
						alert(CabinetMessages.strDelete2);
					}
				}
			}
			
			function Item_View_APPR(pBoardID, pItemID, pgubun) {
				var pheigth = window.screen.availHeight;
				var pwidth  = window.screen.availWidth;
				pheigth     = parseInt(pheigth) / 2;
				pwidth      = parseInt(pwidth) / 2;
				pheigth     = pheigth - 284;
				pwidth      = pwidth - 359;
				
				var xmlhttp = createXMLHttpRequest();
				xmlhttp.open("POST", "/ezBoard/getItemViewNew.do?boardID=" + pBoardID + "&itemID=" + pItemID, false);
				xmlhttp.send();
				
				if (getNodeText(xmlhttp.responseXML.documentElement) != "0") {
					if (pgubun == "3" || pgubun == "4") {
						window.open("/ezBoard/boardItemViewPhoto.do?itemID=" + pItemID + "&boardID=" + pBoardID + "&location=GENERAL", "", "height=793,width=790, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
					}
					else {
						window.open("/ezBoard/boardItemView.do?itemID=" + pItemID + "&boardID=" + pBoardID + "&location=GENERAL", "", "height=720,width=765, status = no, scrollbars=1, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
					}
				}
				else {
					alert(CabinetMessages.strDelete2);
				}
			}
			
			function item_View_New_Community(pBoardID, pItemID, pCommunityID) {
				var pheigth = window.screen.availHeight;
				var pwidth  = window.screen.availWidth;
				pheigth     = parseInt(pheigth) / 2;
				pwidth      = parseInt(pwidth) / 2;
				pheigth     = pheigth - 284;
				pwidth      = pwidth - 359;
				
				if (CrossYN())
					window.open("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pBoardID + "&code=" + pCommunityID, "", "height=720,width=765, status = no, toolbar=no, scrollbars=1, menubar=no, location=no, resizable=1, top=0, left=0", "");
				else
					window.open("/ezCommunity/boardItemView.do?itemID=" + pItemID + "&boardID=" + pBoardID + "&code=" + pCommunityID, "", "height=720,width=765, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=0, left=0", "");
			}
			
			// 결재 보기
			function ViewDoc(pDocID, pURL, pWhat, pOpinionFlag, pdocState, pListSusin, podoc) {
				if (typeof (pWhat) == "undefined" || podoc == "") {
					openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURIComponent(pDocID) + "&DocHref=" + encodeURIComponent(pURL);
					openwindow(openLocation, "", 880, 550);
				}
				else if (pWhat == "1") {
					openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURIComponent(pDocID) + "&DocHref=" + encodeURIComponent(pURL) + "&OpinionFlag=" + encodeURIComponent(pOpinionFlag) + "&docState=" + encodeURIComponent(pdocState) + "&ListSusin=" + encodeURIComponent(pListSusin) + "&odoc=" + encodeURIComponent(podoc);
					openwindow(openLocation, "", 880, 550);
				}
				else {
					openLocation = "/ezflow/AprDocView.asp?DocID=" + encodeURIComponent(pDocID) + "&DocHref=" + encodeURIComponent(pURL);
					openwindow(openLocation, "", 880, 550);
				}
			}
			
			function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
				try {
					var heigth = window.screen.availHeight;
					var width  = window.screen.availWidth;
					var left   = 0;
					var top    = 0;
					
					if (window.screen.width > 800) {
						var pleftpos;
						pleftpos = parseInt(width) - 700;
						heigth   = parseInt(heigth) - 176;
						width    = parseInt(width) - pleftpos;
						left     = pleftpos / 2;
					}
					else {
						heigth = parseInt(heigth) - 30;
						width  = parseInt(width) - 10;
					}
					
					if (wName == "")
						window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
					else
						window.open("", wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
				}
				catch (e) {}
			}
		</script>
		<script type="text/javascript">CabinetContentPreview.init("<c:out value='${module}'/>")</script>
	</body>
</html>