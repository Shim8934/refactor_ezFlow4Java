<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('/css/ezWebFolder/webfolder.css')}" type="text/css">
	<script src="${util.addVer('/js/jquery/jquery.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezWebFolder/fileFolderDrop.js')}"></script>	
    <script type="text/javascript">   	   
   	   var file 		= new Array();
   	   var primary      = "<c:out value='${primary}'/>";
   	   var currFolderId = "opensol"; //Just for test
   	   var strShared1	= "<spring:message code = 'ezWebFolder.t105'/>";
   	   var strShared2	= "<spring:message code = 'ezWebFolder.t106'/>";
   	   var strErr		= "<spring:message code = 'ezWebFolder.t107'/>";
   	   var checkedArr	= [];
   	   
       function fileDownload() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	    	var checkedList = checkedArr[0];
	    	
    		for (var i = 1; i < checkedArr.length; i++) {
    			checkedList = checkedList + "," + checkedArr[i];	    			
    		}
    		
    		var downloadUrl = "/ezWebFolder/downloadAttach.do?fileList=" + checkedList;
        	        	
            AttachDownFrame.location.href = downloadUrl;
    	   
       }
       
       function fileUpload() {
    	   document.getElementById("file").click();
       }
       
       function fileDelete() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
	       var checkedList = checkedArr[0];
	    	
    	   for (var i = 1; i < checkedArr.length; i++) {
    	   	   checkedList = checkedList + "," + checkedArr[i];	    			
    	   }
    	   
    	   DivPopUpShow(450, 150, "/ezWebFolder/deleteConfirm.do?fileList=" + checkedList);
       }
       
       function fileRename() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
    	   if (checkedArr.length > 1) {
    		   alert("<spring:message code = 'ezWebFolder.t115'/>");
    		   return;
    	   }
    	   
	       var fileId = checkedArr[0];
    	   
    	   DivPopUpShow(450, 180, "/ezWebFolder/fileRenameConfirm.do?fileId=" + fileId);
       }
       
       function fileMove() {
    	   if (checkedArr.length <= 0) {
    		   alert("<spring:message code = 'ezWebFolder.t108'/>");
    		   return;
    	   }
    	   
    	   if (checkedArr.length > 1) {
    		   alert("<spring:message code = 'ezWebFolder.t115'/>");
    		   return;
    	   }
    	   
	       var fileId = checkedArr[0];
    	   
    	   DivPopUpShow(450, 480, "/ezWebFolder/fileMoveConfirm.do?fileId=" + fileId);
       }
       
       function getChecked(obj) {
    	   var id = obj.getAttribute("value");
    	   if (obj.checked == true) {
    		   checkedArr.push(id);
    	   }
    	   else {
    		   var pos = checkedArr.indexOf(id);
	    		
    		   if (pos != -1) {
    			   checkedArr.splice(pos, 1);
    		   }
    	   }
       }
       
       function getCheckAll(obj) {
    	   var listInputs = document.getElementsByClassName("checkBnk");
    	   
    	   checkedArr = [];
    	   if (obj.checked == true) {
    		   for (var i = 0; i < listInputs.length; i++) {
	    			listInputs[i].checked = true;
	    			checkedArr.push(listInputs[i].value);	    		
	    		}		    	
    	   }
    	   else {
    		   for (var i = 0; i < listInputs.length; i++) {
	    			listInputs[i].checked = false;	    				    		
	    		}
    	   }
       }
       
       function refreshView() {
    	   
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
	
<!-- 	<div id="progdiv" class="progarea" style="display:none">
    	<p class="prog_bar"><span id="prog_bar" style="width:0%"></span></p> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
    </div> -->
    
    <div id="progress-wrp" style="display: none;">
    	<div class="progress-bar"></div ><div class="status">0%</div>
    </div>
    
	<div id="dragDropArea" ondragenter="onDragEnter(event)" ondragover="onDragOver(event)" ondrop="onDrop(event)">
		<table class="mainlist" style="width: 100%;" id="tblFileList">
			<tr>				
				<th width="10px"><input type="checkbox" onchange="getCheckAll(this);"></th>
				<th width="25px">츨겨찾기</th>
				<th width="25px">유형</th>
				<th width="160px">이름</th>
				<th width="40px">파일크기</th>
				<th width="80px">게시자</th>
				<th width="80px">등록일</th>
				<th width="60px">공유여부</th>				
			</tr>
			<tr class="bnkWebFolder">
				<td><input type="checkbox" onchange="getChecked(this);" value="0" class="checkBnk"></td>
				<td><img src="/images/webfolder/favourite.png" class="webFolderImg" /></td>
				<td><img src="/images/webfolder/pdf.png" class="webFolderImg" /></td>
				<td>Nghinlemotdem.pdf</td>
				<td>75MB</td>
				<td>응웬바오</td>
				<td>2018-01-15</td>
				<td>일반</td>		
			</tr>
		</table>
	</div>
	<input id="file" type="file" onchange="onDrop()" multiple="multiple" style="width: 1px; height: 1px; display:none" /> 
	<input type="hidden" onclick="fileupload()"/>
	<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
    </div>
</body>
</html>