<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="<spring:message code='ezWebFolder.i1'/>" type="text/css">
	<link rel="stylesheet" href="/css/ezWebFolder/webfolder.css" type="text/css">
	<script type="text/javascript" src="/js/mouseeffect.js"></script>
	<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	<script type="text/javascript" src="/js/ezWebFolder/fileFolderDrop.js"></script>	
    <script type="text/javascript">
   	   var xhr  		= new XMLHttpRequest();
   	   var file 		= new Array();
   	   var currFolderId = "opensol"; //Just for test
   	   
       function fileDownload() {
    	   
       }
       
       function fileUpload() {
    	   document.getElementById("file").click();
       }
       
       function fileDelete() {
    	   
       }
       
       function fileRename() {
    	   
       }
       
       function fileMove() {
    	   
       }
    </script>
</head>
<body class="mainbody">
    <h1>부서 폴더</h1>
	<div style="margin-bottom: 15px;">
		<span style="font-size: 24px;font-weight: bold;font-weight: bold; display: block; float: left;">오픈슬루션팀</span>
		<img style="height: 25px; width: 25px; display: inline-block; margin-left: 20px;" src="/images/webfolder/favourite.png">
		<img style="height: 25px; width: 25px; display: inline-block;" src="/images/webfolder/arrow.png">
	</div>
	<div id="mainmenu">
		<ul>
			<li id=""><a onClick="fileDownload()" style="margin-top: 3px;"><span>파일다운로드</span></a></li>
			<li id=""><a onClick="fileUpload()"   style="margin-top: 3px;"><span>파일업로드</span></a></li>
			<li id=""><a onClick="fileDelete()"   style="margin-top: 3px;"><span>파일삭제</span></a></li>
			<li id=""><a onClick="fileRename()"   style="margin-top: 3px;"><span>파일명변경</span></a></li>
			<li id=""><a onClick="fileMove()"     style="margin-top: 3px;"><span>파일이동/복사</span></a></li>
		</ul>
	</div>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
	
	<div id="progdiv" class="progarea" style="display:none">
    	<p class="prog_bar"><span id="prog_bar" style="width:0%"></span></p> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
    </div>
	<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)">
		<table class="mainlist" style="width: 100%;" id="tblFileList">
			<tr>				
				<th><input type="checkbox"></th>
				<th>츨겨찾기</th>
				<th>유형</th>
				<th>이름</th>
				<th>파일크기</th>
				<th>게시자</th>
				<th>등록일</th>
				<th>공유여부</th>				
			</tr>
			<tr class="bnkWebFolder">
				<td><input type="checkbox"></td>
				<td><img src="/images/webfolder/favourite.png" class="webFolderImg" /></td>
				<td><img src="/images/webfolder/pdf.png" class="webFolderImg" /></td>
				<td>Nghinlemotdem.pdf</td>
				<td>75MB</td>
				<td>응웬바오</td>
				<td>2018/01/15</td>
				<td>일반</td>		
			</tr>
		</table>
	</div>
	<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
	<input type="hidden" onclick="fileupload()"/>

</body>
</html>