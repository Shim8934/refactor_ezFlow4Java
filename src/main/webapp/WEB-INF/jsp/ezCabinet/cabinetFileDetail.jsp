<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"   %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezCabinet.t138'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezCabinet.css'/>" type="text/css">
		<link rel="stylesheet" href="/css/ezCabinet/cabinet.css"             type="text/css">
	</head>
	<body class="popup cabDetail">
		<h1><spring:message code='ezCabinet.t108'/></h1>
		
		<div class="divInfo">
			<table class="tblFileInf">
				<tr>
					<th><spring:message code='ezCabinet.t109'/></th>
					<td id="creator"></td>
				<tr>
				<tr>
					<th><spring:message code='ezCabinet.t110'/></th>
					<td id="createdDate"></td>
				<tr>
				<tr>
					<th><spring:message code='ezCabinet.t51'/></th>
					<td id ="title"></td>
				<tr>
					<th><spring:message code='ezCabinet.t52'/></th>
					<td id="summary"></td>
				</tr>
				<tr>
					<th><spring:message code='ezCabinet.t94'/></th>
					<td>
						<div class="rlFileDiv">
							<div id="fileListDiv" class="rlDocDiv"></div>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
		<!-- <div class="htmlDiv">
		</div> -->
		
		<div class="fileDetailDiv" id="fileDiv">
			<div class="fileList">
				<ul class="ulFiles"></ul>
			</div>
			
			<div class="divInform">
			</div>
		</div>
		
		<div>
			<span id="">총용량 : 100KB</span>
		</div>
		
		<div class="cabBttnDiv" id="fileDivBttn">
			<a class="cabBttn"><span><spring:message code='ezCabinet.t78'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t46'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t111'/></span></a>
			<a class="cabBttn"><span><spring:message code='ezCabinet.t66'/></span></a>
		</div>
		
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"        ></script>
		<script type="text/javascript">
		var itemId = "<c:out value='${itemId}'/>";
		var checkFileCreator  = "<c:out value='${checkFileCreator}'/>";
		console.log(checkFileCreator);
		
		initEvents();
		
		function initEvents() {
			document.onselectstart  = function () { return false;}
			
			var cabBttnElmt         = document.getElementById("fileDivBttn");
			var listBttns           = cabBttnElmt.children;
			listBttns[0].onclick    = function(e) {fileModify();};
			listBttns[1].onclick    = function(e) {fileDelete();};
			listBttns[2].onclick    = function(e) {filePrint();}
			listBttns[3].onclick    = function(e) {closeWindow();};
		
			getFileDetail();
		}
		
		function getFileDetail() {
			console.log("getFileDetail(실행)");
			$.ajax({
				type: "POST",
				url: "/ezCabinet/getFileDetail.do",
				data: {"itemId" : itemId},
				dataType: "JSON",
				async: false,
				success : function(data) {
					console.log(data);
					processFileDetail(data);
				},
				error : function(error) {
				}
			});
		}
		
		function processFileDetail(fileItem) {
			
			//파일상세내용
			var result      = fileItem.fileDetail;
			var attachFile  = fileItem.attachFileList;
			var relatedFile = fileItem.relatedFileList;
			
			var creator     = document.getElementById("creator");
			var createdDate = document.getElementById("createdDate");
			var title       = document.getElementById("title");
			var summary     = document.getElementById("summary");
			
			creator.textContent     = result["creatorName"];
			createdDate.textContent = result["createdDate"].substring(0, 19);
			title.textContent       = result["title"];
			summary.textContent     = result["summary"];
			
			//첨부파일리스트
			var fileDivElmt     = document.getElementById("fileDiv");
			var divInformElmt   = fileDivElmt.querySelector("div[class='divInform']");
			
			if(attachFile == null || attachFile.length == 0) {
				var spanElmt      = document.createElement("span");
				spanElmt.textContent = "<spring:message code='ezCabinet.t139'/>";
				divInformElmt.appendChild(spanElmt);
			}else{
				if (divInformElmt) {fileDivElmt.removeChild(divInformElmt);}
				
				var divfileListElmt = fileDivElmt.firstElementChild;
				var ulElmt          = divfileListElmt.firstElementChild;
				
				for (var i = 0, len = attachFile.length; i < len; i++) {
					var liElmt        = document.createElement("li");
					var divMainElmt   = document.createElement("div");
					var divChildElmt1 = document.createElement("div");
					var divChildElmt2 = document.createElement("div");
					var spanChild1    = document.createElement("span");
					var spanChild2    = document.createElement("span");
					var imgElmt       = document.createElement("img");
					
					divChildElmt1.className = "cabImgAva";
					imgElmt.setAttribute("src", attachFile[i]["filePath"]);
					divChildElmt1.appendChild(imgElmt);
					
					spanChild1.textContent  = attachFile[i]["fileName"];
					spanChild2.textContent  = getFileSize(attachFile[i]["fileSize"]);
					divChildElmt2.className = "cabFileInf";
					divChildElmt2.appendChild(spanChild1);
					divChildElmt2.appendChild(spanChild2);
					
					divMainElmt.className = "cabDivFile";
					divMainElmt.appendChild(divChildElmt1);
					divMainElmt.appendChild(divChildElmt2);
					liElmt.appendChild(divMainElmt);
					ulElmt.appendChild(liElmt);
				}	
			}
			
			//연관문서
			var divElmt = document.getElementById("fileListDiv");
			
			for (var i = 0, len = relatedFile.length; i < len; i++) {
				var spanElmt = document.createElement("span");
				spanElmt.setAttribute("role", relatedFile[i]["relatedItemId"]);
				spanElmt.textContent = relatedFile[i]["title"];
				spanElmt.className   = "rlSpanBnk";
				spanElmt.addEventListener("click", function(e) {readRelatedItem(this);}, false);
				divElmt.appendChild(spanElmt);
			}
			
			function readRelatedItem() {
				var itemId = spanElmt.getAttribute("role");
					//Add read item here
				console.log(itemId);
			}
		}
		
		function getFileSize(fileSize) {
			var result = fileSize + "B";
			
			switch(true) {
				case fileSize > 1073741824 : result = parseFloat(fileSize / 1073741824).toFixed(2) + "GB"; break;
				case fileSize > 1048576    : result = parseFloat(fileSize / 1048576).toFixed(2) + "MB"   ; break;
				case fileSize > 1024       : result = parseFloat(fileSize / 1024).toFixed(2) + "KB"      ; break;
			}
			return result;
		}
		
		function fileModify() {
			var cabId    = "";
			window.location.href = "/ezCabinet/addCabinetFile.do?cabId=" + cabId;
			window.resizeTo(600, 540);
		}
		
		function fileDelete() {
			
		}
		
		function filePrint() {
			
		}
		
		function closeWindow() {window.close();}
		</script>
	</body>
</html>