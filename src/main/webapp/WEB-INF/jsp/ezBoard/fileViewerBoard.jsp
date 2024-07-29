<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<c:if test="${!isCrossBrowser}">
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Kaoni_ActiveX.js')}"></script>
	</c:if>
	<c:if test="${isCrossBrowser}">
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachMain_CK.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/AttachItem_CK.js')}"></script>
	</c:if>
	<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezBoard/PreviewItem.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
	<!-- data picker-->
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
	<!-- time picker-->
	<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/timeControls/jquery.timepicker.js')}"></script>
	<!-- layer popup -->
	<link rel="stylesheet"  href="${util.addVer('/js/jquery/jquery.modal.css')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
	<style>
		.mainbody {
			margin : 15px 0 0 15px;
		}
	</style>
	<script>
		var boardItemInfo = "${ boardItemInfo }";
		var pBoardID = "${ boardID }";
		var itemID = "${ boardItemInfo.itemID }"
		var flag = false;
		var boardInfo = "${ boardInfo }";
		var satCallURL = "${ boardItemInfo.satCallURL }";
		var boardItemHref = "${ boardHref }";
		var pMode = "${ mode }";
		var pModeOld = "";
		var pcheckForm = "false";
		var pBoardName = "${ boardName }";
		var AttachLimit;
		var ExpireDays;
		var gubun;
		var pcheckForm;
		var pUseBackGround;
		var strNow = "${ strNow }";
		var autoFlag = "N";
		var NewGuid = "${ newGuid }";
		var orgMode = "${ mode }";
		<%--var autoSaveTime = "${ boardConfig.autoSaveTime }";--%>
		var autoSaveTime = 0;
		var SSUserID = "${ userInfo.id }";
		var SSUserID = "${userInfo.id}";
		var SSUserName = "${userInfo.displayName1}";
		var SSUserName2 = "${userInfo.displayName2}";
		var SSDeptID = "${userInfo.deptID}";
		var SSDeptName = "${userInfo.deptName1}";
		var SSDeptName2 = "${userInfo.deptName2}";
		var SSCompanyID = "${userInfo.companyID}";
		var SSCompanyName = "${userInfo.companyName1}";
		var SSCompanyName2 = "${ userInfo.companyName2 }";
		var pReservedItem = "${ reservedItem }";
		var pUrl = '';
		var attachxml = '';
		var pUploadFilePath = "${ uploadFilePath }";
		var strUserRank = "${ userInfo.title1 }";
		var strUserRank2 = "${ userInfo.title2 }";
		var strUserPhone = "${ userInfo.phone }";
		var pDocID = "";
		var strItemID = "${ itemID }";
		var isAllGroupBoard = "${boardInfo.isAllGroupBoard}";
		var viewContentFlag = false;
		var viewAttachFlag = false;
		var strWriterID = "${boardItem.writerID}";
		var useVersion = "${ useVersion }";

		window.onload = () => {
			if (boardItemInfo == null) {
				Tab1_NewTabIni("tab1");
			} else if (boardItemInfo != "" && pMode != "modify") {
				SetAttachmentInfo();
			}

			leftCountRf(pBoardID);
			GetBoardInfo();
		}

		function getBoardContent() {
			// boardContentArea
			$.ajax({
				type : "POST",
				dataType : "text",
				url : "/ezCommon/mhtToHTMLContent.do",
				async : false,
				data : {
					type : "BOARDCONTENT",
					href : boardItemHref,
					itemID : strItemID
				},
				success : (res) => {
					document.getElementById("boardContentArea").insertAdjacentHTML("beforeend", res);
				}
			});
		}

		function GetBoardInfo() {
			var xmlhttp_boardinfo = createXMLHttpRequest();
			xmlhttp_boardinfo.open("POST", "/ezBoard/getBoardInfo.do?boardID=" + encodeURIComponent(pBoardID), false);
			xmlhttp_boardinfo.send();

			if (xmlhttp_boardinfo.status == 200) {
				pBoardName = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BOARDNAME")[0]);
				AttachLimit = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "ATTACHLIMIT")[0]);
				ExpireDays = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "EXPIREDAYS")[0]);
				gubun = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "GUBUN")[0]);
				pcheckForm = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "FORM")[0]);
				pUseBackGround = getNodeText(SelectNodes(loadXMLString(xmlhttp_boardinfo.responseText), "BACKIMAGE")[0]);
			}

			xmlhttp_boardinfo = null;
		}

		var firstnode = true;
		function Tab1_NewTabIni(pTabNodeID) {
			for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
				if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
					if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {

						document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); };;
						document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); };;
						document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); };;
						if (firstnode) {
							document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).className = "tabon";
							Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).id;
							pSelectTab = document.getElementById(Tab1_SelectID).getAttribute("divname"); // 초기에 선택된 탭의 divname을 설정
							firstnode = false;
						}
					}
				}
			}
		}

		function Tab1_MouserOver(obj) {
			obj.className = "tabover";
		}
		function Tab1_MouserOut(obj) {
			if (Tab1_SelectID != obj.id)
				obj.className = "";
		}
		function Tab1_MouseClick(obj) {
			obj.className = "tabon";
			if (obj.id != Tab1_SelectID) {
				if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
					document.getElementById(Tab1_SelectID).className = "";

				obj.className = "tabon";
				Tab1_SelectID = obj.id;
				ChangeTab(obj);
			}
		}

		function ChangeTab(obj) {
			pSelectTab = obj.getAttribute("divname");
			switch (pSelectTab) {
				case "MailEnv_div1":
					document.getElementById("tab01").style.display = "";
					document.getElementById("tab02").style.display = "none";

					break;
				case "MailEnv_div3": {
					document.getElementById("tab01").style.display = "none";
					document.getElementById("tab02").style.display = "";

					break;
				}

				default : {}
			}

			var editorW = (document.documentElement.clientWidth - 20) + "PX";
			document.getElementById("tab02").style.width = editorW;
			document.getElementById("message").style.width = editorW;
			//iframe 내부 에디터의 body width 조절
			$("iframe").ready(function(){ $("iframe[name='message']").contents().find("body").css("width" , editorW); });
		}

		function Editor_Complete() {
			if (flag == false) {
				flag = true;
				if ((typeof pMode !== "undefined" && typeof pModeOld !== "undefined") && (pMode == "new" || pModeOld == "loadpc" || pMode == "boardAttach")) {
					if (pcheckForm.toUpperCase() == "TRUE") {
						var fullPath = "";
						$.ajax({
							type : "POST",
							dataType : "text",
							async : false,
							url : "/ezBoard/getContentInfo.do",
							data : { type : "BOARDFORM",
								docID: pBoardID
							},
							success: function(result){
								fullPath = result;
							}
						});
						var htmlData = message.GetEditorContentURL(fullPath);
						message.SetEditorContent(htmlData);
					} else {
						document.getElementById("txtTitle").focus();
						message.SetEditorContent("");
					}
				} else {
					if (pUrl == "") {
						var fullPath = strContentLocation;
						if (pMode == "reply") {
							var htmlData = message.GetEditorContentURL(fullPath);
							htmlData = ReplaceText(htmlData, "class=&quot;FIELD&quot;", "");
							htmlData = ReplaceText(htmlData, "class=FIELD", "");
							/* 2020-11-30 홍승비 - 본문의 내용 내부 특수문자 치환할 필요 없으므로 주석처리, 이스케이프 문자 처리 추가 */
							/* 		                        htmlData = ReplaceText(htmlData, "&amp;", "&");
                                                            htmlData = ReplaceText(htmlData, "&lt;", "<");
                                                            htmlData = ReplaceText(htmlData, "&gt;", ">"); */
							htmlData = "<body free>" + htmlData + "</body>";

							if (gubun != "2") {
								var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
								replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;원문&nbsp;&nbsp;내용&nbsp;]</B>-----</p>";
								replyHeader += "<p " + defaultFontAndSize + "><B>게시일자 :</B>" + strWriteDate + "</p>";
								replyHeader += "<p " + defaultFontAndSize + "><B>게시자 :</B>" + strWriterName + "(" + strWriterTitle + "," + strWriterDeptName + "," + strWriterCompanyName + ")</p>";
								replyHeader += "<p " + defaultFontAndSize + "><B>제목 :</B>" + ReplaceText("", "&amp;#92;", "\\") + "</p>";
								replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
								htmlData = replyHeader + htmlData;
							} else {
								var replyHeader = "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
								replyHeader += "<p " + defaultFontAndSize + ">-----<B>[&nbsp;원문&nbsp;&nbsp;내용&nbsp;]</B>-----</p>";
								replyHeader += "<p " + defaultFontAndSize + "><B>게시일자 :</B>" + strWriteDate + "</p>";
								replyHeader += "<p " + defaultFontAndSize + "><B>게시자 :</B>" + strWriterFakeName + "</p>";
								replyHeader += "<p " + defaultFontAndSize + "><B>제목 :</B>" + ReplaceText("", "&amp;#92;", "\\") + "</p>";
								replyHeader += "<p " + defaultFontAndSize + ">&nbsp;</p><p " + defaultFontAndSize + ">&nbsp;</p>";
								htmlData = replyHeader + htmlData;
							}
							message.SetEditorContent(htmlData);
						}else {
							message.SetEditorContentURL(fullPath);
						}
					} else {
						if (pDocID == "" && (scheduleId == "" || scheduleId == null)) {
							if (InsertMailInfo() == -1) window.close();
						} else if (scheduleId != "" && scheduleId != null) {
							if (InsertScheduleInfo() == -1) window.close();
						} else {
							if (InsertDocInfo() == -1) window.close();
						}
					}
				}
				MHTLoadComplete = "true";
			}
		}

		var fileSize = 0;
		function returnvalue(strXML) {
			var xml = loadXMLString(strXML);
			var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
			var extFlag = false;

			for (var i = 0; i < nodes.length; i++) {
				if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
					if (getNodeText(GetChildNodes(nodes[i])[3]) == 0) {
						alert(strLang6);
						return;
					}
					if (document.getElementById('mode').value == "PHOTO")
						document.getElementById('txtPhotoFile').value = getNodeText(GetChildNodes(nodes[i])[2]);
				}
				else if (getNodeText(GetChildNodes(nodes[i])[1]) == "denied") {
					extFlag = true;
				} else if (getNodeText(GetChildNodes(nodes[i])[1]) == "overflow") {
					alert(strLang8 + AttachLimit + "MB" + strLang9);
					return;
				}
				else {
					alert("을 업로드 중 에러가 발생했습니다." + "\n\n" + result);
				}
			}

			if (extFlag) {
				alert(strLang54);
			}

			if (dadiframe.document.getElementById("lstAttachLink") == null) {
				setTimeout(function () { AttachFileInfo(strXML); }, 500);
			} else {
				AttachFileInfo(strXML);
			}
		}

		function GetStartDate() {
			var pReservationTime = "";
			if ($('#Sdatepicker').val() && document.getElementById("chk_reservation").checked) {
				if ($('#Stimepicker').val()) {
					pReservationTime = $('#Sdatepicker').val() + " " + $('#Stimepicker').val() + ":00";
				}
				else {
					pReservationTime = $('#Sdatepicker').val() + " 00:00:00";
				}
			}
			return pReservationTime;
		}

		function GetEndDate() {
			var pEndDateTime;
			if (document.getElementById("ChkPermanence").checked) {
				pEndDateTime = "9999-12-30 23:59:59";
			} else {
				if ((pMode == "modify" || pMode == "temp") && $('#Sdatepicker2').val().substring(0, 4) != "9999") {
					//만료일자가 오늘 23:59:59 이전까지 포함할수있게 수정
					//pEndDateTime = $('#Sdatepicker2').val() + strEndDate.substring(10, 19);
					pEndDateTime = $('#Sdatepicker2').val() + " 23:59:59";
				}
				else {
					//만료일자가 오늘 23:59:59 이전까지 포함할수있게 수정
					//pEndDateTime = $('#Sdatepicker2').val() + strNow.substring(10, 19);
					pEndDateTime = $('#Sdatepicker2').val() + " 23:59:59";
				}
			}
			return pEndDateTime;
		}

		function JSleep() {
			return;
		}

		function sendBoardAlertMail(pMode, pBoardID, pItemID, pIsAllGroupBoard) {
			$.ajax({
				type : "POST",
				dataType : "text",
				async : true,
				url : "/ezBoard/sendBoardAlertMail.do",
				data : {
					mode : pMode,
					boardID : pBoardID,
					itemID : pItemID,
					isAllGroupBoard : pIsAllGroupBoard
				}
			});
		}

		function deleteItem() {
			if (!confirm("<spring:message code='ezBoard.t197'/>")) {
				return;
			}

			$.ajax({
				type : "POST",
				dataType : "text",
				async : false,
				url : "/ezBoard/deleteItem.do",
				data : {
					mode : gubun,
					boardID : pBoardID,
					itemList : (itemID + ";")
				},
				success : function (res) {
					if (res === "OK") {
						alert("<spring:message code = 'ezBoard.t54' />");
						location.href = "/ezBoard/fileViewerBoard.do?boardID=" + encodeURIComponent(pBoardID);
					} else {
						alert("<spring:message code = 'ezCabinet.err2' />");
					}
				}
			});
		}

		function editItem() {
			location.href = "/ezBoard/fileViewerBoard.do?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(itemID) + "&mode=modify";
		}

		function viewContent() {
			viewContentFlag = !viewContentFlag;
			document.getElementById("boardContentArea").style.display = viewContentFlag ? "" : "none";
			document.getElementById("viewContentBtn").innerHTML = viewContentFlag ? "<spring:message code = 'ezBoard.fileViewerBoard.noViewContent' />" : "<spring:message code = 'ezBoard.fileViewerBoard.viewContent' />";
		}

		function SetAttachmentInfo() {
			var xmlhttp = createXMLHttpRequest();
			var xmldom = createXmlDom();
			xmlhttp.open("POST", "/ezBoard/getItemAttachments.do?itemID=" + encodeURIComponent(itemID), false);
			xmlhttp.send();
			xmldom = loadXMLString(xmlhttp.responseText);

			var i = 0;
			var pos = 0;
			var filenameOrg = "";
			var filenameView = "";
			var filepath = "";
			var strAttach = "";
			var fileImage = "";
			var xmldomNodes = SelectNodes(xmldom, "NODES/NODE");
			var regData = GetbrowserLanguage();
			for (var i = 0; i < xmldomNodes.length; i++) {
				filepath = getNodeText(SelectSingleNode(xmldomNodes[i], "FilePath"));
				/* 2018-04-27 홍승비 - 화면에 표시되는 파일명 특문처리 수정 */
				filenameOrg = getNodeText(SelectSingleNode(xmldomNodes[i], "FileName"));
				filenameView = MakeXMLString(filenameOrg);
				filesize = getNodeText(SelectSingleNode(xmldomNodes[i], "FileSize"));

				var strTarget = "target=''";
				var strFileExt = filepath.substr(filepath.lastIndexOf('.')).toLowerCase();
				if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
						strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
						strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
						strFileExt == ".xlsx" || strFileExt == ".rtf") {
					strTarget = "target=''";
				}

				if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
					fileImage = "/images/image.png";
				else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
					fileImage = "/images/doc.png";
				else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
					fileImage = "/images/xls.png";
				else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
					fileImage = "/images/ppt.png";
				else if (strFileExt.indexOf(".txt") != -1)
					fileImage = "/images/txt.png";
				else if (strFileExt.indexOf(".zip") != -1)
					fileImage = "/images/zip.png";
				else if (strFileExt.indexOf(".pdf") != -1)
					fileImage = "/images/pdf.png";
				else if (strFileExt.indexOf(".ecm") != -1)
					fileImage = "/images/ecm.png";
				else
					fileImage = "/images/email/mail_006.gif";

				var protocol = window.location.protocol;
				var serverName = window.location.hostname;

				/* 2020-01-30 홍승비 - 모두저장 기능을 위해 속성 추가 */
				strAttach += "<input type='checkbox' name='fileSelect' value='" + filenameView + "' filePath='" + MakeXMLString(filepath) + "'>";
				strAttach += "<img src='" + fileImage + "'> <a href='/ezBoard/boardAttachDown.do?filePath=" + javaURLEncode(filepath) + "&fileName=" + javaURLEncode(filenameOrg) + "'\">";
				strAttach += filenameView + "&nbsp;(" + filesize + ")</a>";
				// 2023-05-25 조수빈 - 게시판 첨부파일 미리보기 아이콘 추가
				if (typeof useBoardFilePrvw !== 'undefined' && useBoardFilePrvw == "1") {
					strAttach += "<span class='icon_rbtn2' style='margin-left : 10px;' title='미리보기' onclick=\"attachFile_Preview('" + javaURLEncode(filepath) + "', '" + javaURLEncode(filenameOrg) + "');\"><img src='/images/icon_preview.png' width='16' height='16' style='vertical-align:middle; cursor:pointer;'></span>";
				}
				strAttach += "<br>";
			}
			document.getElementById('lstAttachLink').innerHTML = strAttach;
		}

		function viewAttachBtn() {
			viewAttachFlag = !viewAttachFlag;

			var msg = viewAttachFlag ? "<spring:message code = 'ezBoard.fileViewerBoard.noViewAttach' />" : "<spring:message code = 'ezBoard.fileViewerBoard.viewAttach' />";

			document.getElementById("attachTable").style.display = viewAttachFlag ? "" : "none";
			document.getElementById("viewAttachMsg").innerHTML = msg;
		}

		function attach_SelectAll() {
			var checks = document.getElementById('lstAttachLink').getElementsByTagName("input");
			for (var i = 0; i < checks.length; i++)
				checks.item(i).checked = true;
		}

		/* 2020-01-30 홍승비 - 체크한 파일이 1개 이상인 경우, zip 파일로 다운받도록 수정 */
		function attach_Download() {
			var checks = document.getElementById('lstAttachLink');
			//downloadAll(checks);
			AttachAllDownload(checks);
		}

		/* 2020-01-30 홍승비 - 체크한 파일이 1개 이상인 경우, zip 파일로 다운받는 함수 */
		function AttachAllDownload(checks) {
			var checkedFiles = $("#lstAttachLink").find("input:checkbox[name='fileSelect']:checked");
			var checkedFilesLength = checkedFiles.length;
			var filePath = ""; // 전체파일경로
			var filePathTemp = "";
			var fileNames = ""; // 파일이름
			var fileNamesUID = ""; // 파일이름(UID 포함)

			if (checkedFilesLength == 1) { // 하나만 저장
				downloadAll(checks);
			}
			else if (checkedFilesLength > 1) { // 여러개는 zip으로 저장
				filePath = GetAttribute(checkedFiles.get(0), "filepath");
				filePath = filePath.substr(0, filePath.lastIndexOf("/") + 1);

				for (var i = 0; i < checkedFilesLength; i++) {
					filePathTemp = GetAttribute(checkedFiles.get(i), "filepath"); // 각 파일의 풀경로
					fileNames += MakeXMLString(checkedFiles.get(i).value) + ":"; // 각 파일의 이름을 :로 이어붙인 것
					fileNamesUID += MakeXMLString(filePathTemp.substr(filePathTemp.lastIndexOf("/"), filePathTemp.length)) + ":"; // 각 파일의 이름+UID를 :로 이어붙인 것
				}

				var $frm = $("<form></form>");
				$frm.attr('action', "/ezBoard/downloadAttachAll.do");
				$frm.attr('method', 'post');
				$frm.appendTo('body');

				param1 = $('<input type="hidden" value="' + filePath + '" name="filePath" />');
				param2 = $("<input type='hidden' value='" + fileNames + "' name='fileNames' />");
				param3 = $("<input type='hidden' value='" + fileNamesUID + "' name='fileNamesUID' />");

				$frm.append(param1).append(param2).append(param3);
				$frm.submit();
			}
			else { // 체크된 파일 없음
				return;
			}
		}

		var suffix = 0;
		function downloadAll(checks) {
			if (checks.getElementsByTagName("input").item(suffix)) {
				if (checks.getElementsByTagName("input").item(suffix).checked) {
					location.href = GetAttribute(checks.getElementsByTagName("a").item(suffix++), "href");
					setTimeout(function () { downloadAll(checks) }, 1000);
				}
				else {
					suffix++;
					downloadAll(checks);
				}
			}
			else
				suffix = 0;
		}

		/* 2018-06-29 홍승비 - 사원정보 확인 시 겸직부서인 상태로 정보 보여주도록 수정 */
		function OpenUserInfo(pUserID, pDeptID) {
			var result = GetOpenWindow("/ezCommon/showPersonInfo.do?id=" + pUserID + "&dept=" + pDeptID, "UserInfo", 420, 450, "NO");
		}

		function viewModifyHistory() {
			var heigth = window.screen.availHeight;
			var width = window.screen.availWidth;
			var left = (width - 620) / 2;
			var top = (heigth - 425) / 2;
			var href = "/ezBoard/modifyHistory?boardID=" + encodeURIComponent(pBoardID) + "&itemID=" + encodeURIComponent(itemID);
			var strFeature = "status:no;dialogHeight: 425px;dialogWidth: 620px;help: no;resizable:yes";

			DivPopUpShow(620, 425, href);
		}
	</script>
</head>
<body class="mainbody">
	<c:if test="${ boardItemInfo == null }">
		<div>
			<iframe id = "newItemArea" style = "width : 99%; height : 600px; border : 1px solid gray;"></iframe>

			<script>
				document.getElementById("newItemArea").src = "/ezBoard/boardNewItem.do?boardID=" + encodeURI(pBoardID) + "&mode=new";
			</script>
		</div>
	</c:if>

	<c:if test = "${ boardItemInfo != null }">
		<c:choose>
			<c:when test = "${ mode != 'modify' }">
				<div id = "mainmenu" class = "mainMenu">
					<ul>
						<li class="important" onclick = "editItem()">
							<span><spring:message code='ezBoard.t316' /></span>
						</li>

						<li class = "important" onclick = "viewAttachBtn()">
							<span id = "viewAttachMsg"><spring:message code = 'ezBoard.fileViewerBoard.viewAttach' /></span>
						</li>

						<li class = "important" onclick = "viewContent()">
							<span id = "viewContentBtn"><spring:message code = 'ezBoard.fileViewerBoard.viewContent' /></span>
						</li>

						<c:if test = "${ useVersion eq 'Y' }">
							<li class = "important" onclick = "viewModifyHistory()">
								<span id = "viewModifyHistoryByn"><spring:message code = 'ezBoard.versionManage.msg2' /></span>
							</li>
						</c:if>

						<li class onclick = "deleteItem()">
							<span class = "icon16 icon16_delete"></span>
						</li>
					</ul>
				</div>

				<table class="content2" style="width:100%;">
					<!-- 게시자  -->
					<tr>
						<th style="width:10%;"><spring:message code='ezBoard.t223' /></th>
						<c:choose>
							<c:when test="${guBun != '2'}">
								<td id="WriteUserNM" style="width:40%;">
									<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;cursor:pointer" onclick='OpenUserInfo("${bi.writerID}", "${bi.writerDeptID} ")'>
										<c:out value="${bi.writerName}"/>
									</div>
								</td>
							</c:when>
							<c:otherwise>
								<td id="WriteUserNM" style="width:40%; white-space:nowrap">
									<div style="vertical-align:middle;width:100%;height:16px;overflow-y:auto;">
										<c:out value="${bi.writerName}"/>
									</div>
								</td>
							</c:otherwise>
						</c:choose>
						<!-- 게시자 end -->
						<c:choose>
						<c:when test="${guBun != '2'}">
						<!-- 부서 -->
						<th style="width:10%;"><spring:message code='ezBoard.t322' /></th>
						<c:choose>
							<c:when test="${guBun != '2'}">
								<td id="User_DeptNM" style="width:40%; white-space:nowrap"><span>${bi.writerDeptName}</span></td>
							</c:when>
							<c:otherwise>
								<td id="User_DeptNM" style="width:40%; white-space:nowrap"><span>&nbsp;</span> </td>
							</c:otherwise>
						</c:choose>
					</tr>
					<!-- 부서 end -->
					<!-- 직위 -->
					<tr>
						<th><spring:message code='ezBoard.t290' /></th>
						<c:choose>
							<c:when test="${guBun != '2'}">
								<td id="User_JobTitle"><span>${bi.extensionAttribute3}</span> </td>
							</c:when>
							<c:otherwise>
								<th id="User_JobTitle"><span>&nbsp; </span> </th>
							</c:otherwise>
						</c:choose>
						<!-- 직위 end -->
						<!-- 사내전화 -->
						<th><spring:message code='ezPersonal.t177' /></th>
						<c:choose>
							<c:when test="${guBun != '2'}">
								<td id="Telephone"><span>${bi.extensionAttribute4} </span> </td>
							</c:when>
							<c:otherwise>
								<td id="Telephone"><span>&nbsp; </span> </td>
							</c:otherwise>
						</c:choose>
					</tr>
					<!-- 전화번호 end -->
					<!-- 게시일 -->
					<tr>
						<th><spring:message code='ezBoard.t224' /></th>
						<td id="PostDate" style = "white-space:nowrap; padding-right:5px">
							<div style="vertical-align:middle;width:100%;height:16px;">${bi.writeDate.substring(0, 16)}</div>
						</td>
						<!-- 게시일 end -->
						<!-- 게시 종료일 -->
						<th><spring:message code='ezBoard.t288' /></th>
						<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
						<c:choose>
							<c:when test="${bi.endDate.substring(0,4) == '9999'}">
								<td id="EndDate" style="padding-right:5px;">
									<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;"><spring:message code='ezBoard.t287' /></div>
								</td>
							</c:when>
							<c:otherwise>
								<td id="EndDate" style="padding-right:15px;">
									<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;">${bi.endDate.split(' ')[0]}</div>
								</td>
							</c:otherwise>
						</c:choose>
					</tr>
					<!-- 게시 종료일 end -->
					</c:when>
					<c:otherwise>
						<th style="width:10%"><spring:message code='ezBoard.t224' /></th>
						<td id="PostDate" style="width:120px; white-space:nowrap; padding-right:5px">
							<div style="vertical-align:middle;width:100%;height:16px;">${bi.writeDate}</div>
						</td>
						<!-- 게시일 end -->
						</tr>
						<!-- 게시 종료일 -->
						<tr>
							<th><spring:message code='ezBoard.t288' /></th>
							<c:set var="code287" value="<spring:message code='ezBoard.t287' />"/>
							<c:choose>
								<c:when test="${bi.endDate.substring(0,4) == '9999'}">
									<td colspan="3" id="EndDate" style="padding-right:5px;">
										<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;"><spring:message code='ezBoard.t287' /></div>
									</td>
								</c:when>
								<c:otherwise>
									<td colspan="3" id="EndDate" style="padding-right:15px;">
										<div style="vertical-align:middle;overflow-y:auto; display:ruby-text-container;">${bi.endDate.split(' ')[0]}</div>
									</td>
								</c:otherwise>
							</c:choose>
						</tr>
						<!-- 게시 종료일 end -->
					</c:otherwise>
					</c:choose>


					<c:if test="${boardAttrCount > 0}">
						<c:forEach var="boardAttr" items="${boardAttr}">
							<tr>
								<c:choose>
									<c:when test="${extenLang == '1'}">
										<th>${boardAttr.colName1}</th>
									</c:when>
									<c:otherwise>
										<th>${boardAttr.colName2}</th>
									</c:otherwise>
								</c:choose>
								<td colspan="5">
									<c:choose>
										<c:when test="${boardAttr.tableCol == 'extensionAttribute6'}">
											<c:out value="${bi.extensionAttribute6}"/>
										</c:when>
										<c:when test="${boardAttr.tableCol == 'extensionAttribute7'}">
											<c:out value="${bi.extensionAttribute7}"/>
										</c:when>
										<c:when test="${boardAttr.tableCol == 'extensionAttribute8'}">
											<c:out value="${bi.extensionAttribute8}"/>
										</c:when>
										<c:when test="${boardAttr.tableCol == 'extensionAttribute9'}">
											<c:out value="${bi.extensionAttribute9}"/>
										</c:when>
										<c:when test="${boardAttr.tableCol == 'extensionAttribute10'}">
											<c:out value="${bi.extensionAttribute10}"/>
										</c:when>
										<c:otherwise></c:otherwise>
									</c:choose>
								</td>
							</tr>
						</c:forEach>
					</c:if>
					<!-- 제목 -->
					<tr>
						<th><spring:message code='ezBoard.t323' /></th>
						<td width="100%" id="cTitle" style="WORD-WRAP: break-word;word-break:break-all; line-height:16px;" colspan=5>
							<div style="WIDTH: 100%; vertical-align: middle"><c:out value="${bi.title}"/></div>
						</td>
					</tr>
					<!-- 제목 end -->
				</table>

				<table id = "attachTable" class="file" style = "display : none; width : 100%; margin-top : 5px;">
					<tr>
						<th><spring:message code='ezBoard.t10025' /></th>
						<td>
							<div style="text-align:left; OVERFLOW: auto; HEIGHT: 76px; background-color:white" id="lstAttachLink" ></div>
						</td>
						<td class="pos2">
							<a class="imgbtn imgbck" style="width:60px; margin-bottom: 3px !important;"><span onClick="attach_SelectAll()"><spring:message code='ezBoard.t325' /></span></a><br/>
							<a class="imgbtn imgbck" style="width:60px; text-align: center;"><span onClick="attach_Download()"><spring:message code='ezBoard.t98' /></span></a>
						</td>
						<td id="ItemLevel" style="display:none"></td>
					</tr>
				</table>

				<div id = "boardContentArea" style = "display : none;">
					<script>
						getBoardContent();
					</script>
				</div>

				<div id = "viewer" style = "margin-top : 5px;">
					<iframe src = "${ boardItemInfo.satCallURL }" style = "width : 99%; height : 500px;"></iframe>
				</div>
			</c:when>

			<c:otherwise>
				<div>
					<iframe id = "editContentArea" style = "width : 99%; height : 600px; border : 1px solid gray;"></iframe>

					<script>
						document.getElementById("editContentArea").src = "/ezBoard/boardNewItem.do?boardID=" + encodeURI(pBoardID) + "&itemID=" + encodeURI(itemID) + "&mode=modify&reservedItem=&portletId=";
					</script>
				</div>
			</c:otherwise>
		</c:choose>
	</c:if>

	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		<iframe src="" style="border:none;" id="iFrameLayer"></iframe>
	</div>
</body>
</html>