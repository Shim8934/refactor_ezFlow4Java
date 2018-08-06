<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"        %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"      %>
<%@ taglib prefix="fn"     uri = "http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t138'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabDetail">
		<h1 id="fileFileH1"><spring:message code='ezCabinet.t108'/></h1>
		
		<div class="divInfo">
			<table class="tblBoardInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="fileCreator" class="cursor overfl"><c:out value="${item.creatorName}"/></td>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td><c:out value="${fn:substring(item.createdDate, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><c:out value="${optionWriter.columnName}"/></th>
					<td id="optionCreator" class="cursor overfl"></td>
					<th><c:out value="${optionTime.columnName}"/></th>
					<td><c:out value="${fn:substring(optionTime.columnValue, 0, 19)}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id="title" class="overfl" colspan="3"><c:out value="${item.title}"/></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td colspan="3"><div id="rlWrapDiv" class="rlFileDiv"><div id="fileListDiv" class="rlDocDiv"></div></div></td>
				</tr>
			</table>
		</div>
		
		<div class="boardContDiv"><iframe id="boardIframe" class="cabrlframe2"></iframe></div>
		
		<div class="cabBttnDiv" id="fileDivBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<div class="cabBttnDiv" id="fileModifyDivBttn" style="display: none;">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t14'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t15'/></span></a>
		</div>
		
		<script type="text/javascript" src="<spring:message code='ezCabinet.lang'/>"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript">
			var CabinetOptionFile = function() {
				var itemId       = null;
				
				function initEvents(itemID) {
					itemId                  = itemID;
					document.onselectstart  = function () { return false;}
					window.addEventListener("beforeunload", function(e) {closeAllPopups();}, false);
					var cabBttnElmt         = document.getElementById("fileDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {fileModify();};
					listBttns[1].onclick    = function(e) {fileDelete();};
					listBttns[2].onclick    = function(e) {filePrint();}
					listBttns[3].onclick    = function(e) {closeWindow();};
					
					document.getElementById("fileListDiv").onscroll = function(e) {scrollListOfItem(this);}
					
					var cabBttnElmt         = document.getElementById("fileModifyDivBttn");
					var listBttns           = cabBttnElmt.children;
					listBttns[0].onclick    = function(e) {saveItem();};
					listBttns[1].onclick    = function(e) {cancelChanges()};
					
					getFileDetail();
				}
				
				function scrollListOfItem(divElmt) {
					if (scrolled) {
						scrolled = false;
						var distance      = divElmt.scrollTop < lastScrollY ? -20 : 20;
						divElmt.scrollTop = lastScrollY + distance;
						setTimeout(function () {scrolled = true; lastScrollY = divElmt.scrollTop;}, 500);
					}
				}
				
				function getFileDetail() {
					$.ajax({
						type: "GET",
						url: "/ezCabinet/getFileDetail.do",
						data: {"itemId" : itemId},
						dataType: "JSON",
						async: false,
						success : function(data) {
							console.log(data);
							processFileDetail(data);},
						error : function(error) {alert(CabinetMessages.strError);}
					});
				}
				
				function processFileDetail(fileItem) {
					var result       = fileItem.fileDetail;
					var boardWriter  = fileItem.writerVO;
					var attachList   = fileItem.attachFileList;
					var relatedList  = fileItem.relatedFileList;
					
					//File Creator
					document.getElementById("fileCreator").onclick  = function(e) {showUserInfoFromId(result["creatorId"]);};
					
					//Board Creator
					var boardCreator         = document.getElementById("boardCreator");
					boardCreator.textContent = boardWriter["userName"];
					boardCreator.onclick     = function(e) {showUserInfoFromId(boardWriter["userId"]);};
					
					//Title
					var titleTd         = document.getElementById("title");
					titleTd.textContent = result["title"];
					titleTd.setAttribute("title", result["title"]);
					
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
					var iframeElmt       = document.getElementById("boardIframe");
					iframeElmt.src       = "/ezCabinet/getPreviewContent.do?module=board";
					boardContent         = {};
					boardContent.content = result["contentPath"];
					boardContent.size    = result["itemSize"];
					boardContent.attach  = attachList;
					
				}
			}();
		</script>
		
	</body>
</html>