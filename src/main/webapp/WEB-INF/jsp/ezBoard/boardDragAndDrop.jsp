<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge" /> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css">
		<style>
		#lstAttachLink {
		height: 117px;
		border: 1px solid #3C2F2E;
		}
		</style>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="<spring:message code='ezBoard.e1' />"></script>
		<script type="text/javascript">
		    var lstAttachLink = document.getElementById("lstAttachLink");
		    var isfileup = false;
		    function onDragEnter(evt) {
		        evt.dataTransfer.dropEffect = "copy";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
		    function onDragOver(evt) {
		        evt.dataTransfer.dropEffect = "copy";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }
		
		    var filesize = 0;
		    var file = new Array;
		    var xhr = new XMLHttpRequest();
		    function onDrop(evt) {
		        if (evt != undefined) {
		            evt.stopPropagation();
		            evt.preventDefault();
		        }
		        if (isfileup) {
		            alert("<spring:message code='ezBoard.t2000' />");
		            return;
		        }
		        var filelist;
		        if (evt == undefined) {
		            filelist = document.getElementById("file").files;
		        }
		        else {
		            filelist = evt.dataTransfer.files;
		        }
		        var tempfilesize = 0;
		        var filecnt = file.length;
		        for (var i = 0; i < filelist.length; i++) {
		            filesize = parseInt(filesize) + parseInt(filelist[i].size);
		            if (filesize / 1024 / 1024 > window.parent.AttachLimit) {
		                if ("${userInfo.lang}" == "2"){
		                    alert(strLang8 + window.parent.AttachLimit + strLang9);
		                }
		                else{
		                    alert(strLang8 + window.parent.AttachLimit + "MB" + strLang9);
		                }
		                if(tempfilesize == 0){
		                    filesize = parseInt(filesize) - parseInt(filelist[i].size);
		                }
		                else{
		                    filesize = parseInt(filesize) - tempfilesize;
		                }
		                return;
		            }
		            else {
		                file[filecnt + i] = filelist[i];
		                tempfilesize += filelist[i].size;
		            }
		        }
		        fileupload();
		    }
		    function uploadProgress(evt) {
		        if (evt.lengthComputable) {
		            var percentComplete = Math.round(evt.loaded * 100 / evt.total);
		            document.getElementById('prog_bar').style.width = percentComplete + "%";
		            document.getElementById('prog_num').innerHTML = percentComplete;
		        }
		    }
		
		    window.onload = function () {
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1 && ua.indexOf("Macintosh") == -1) {
		            document.getElementById("file").multiple = false;
		        }
		
		        var oTable = document.createElement("TABLE");
		        oTable.style.width = "100%";
		        oTable.id = "filelist";
		        oTable.className = "sublist";
		
		        var objTr = document.createElement("TR");
		
		        var objTh = document.createElement("TH");
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1 && ua.indexOf("Macintosh") == -1) {
		            objTh.style.width = "24px";
		        }else{
		            objTh.style.width = "15px";
		        }
		        var input = document.createElement("input");
		        input.type = "checkbox";
		        input.id = "checkboxall";
		        input.onclick = function () { checkall(); };
		        objTh.appendChild(input);
		        objTr.appendChild(objTh);
		
		        var objTh2 = document.createElement("TH");
		        objTh2.style.width = "87%";
		        objTh2.textContent = strLang1;
		        objTr.appendChild(objTh2);
		
		        var objTh3 = document.createElement("TH");
		        objTh3.textContent = strLang3;
		        objTh3.style.width = "13%";
		        objTr.appendChild(objTh3);
		
		        oTable.appendChild(objTr);
		        document.getElementById("lstAttachLink").appendChild(oTable);
		    };
		
		    function uploadComplete(evt) {
		        document.getElementById('prog_bar').style.width = "0%";
		        document.getElementById('prog_num').innerHTML = "0";
		        document.getElementById('progdiv').style.display = "none";
		        window.parent.returnvalue(xhr.responseText);
// 		        if (CrossYN()) {
// 		            document.getElementById("file").value = "";
// 		        }
// 		        else {
// 		            document.getElementById("file").type = "text";
// 		            document.getElementById("file").type = "file";
// 		        }
		        var strRet = "";
		        var pBoardID = window.parent.pBoardID;
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        
		        for (var i = 0; i < filecnt - 1; i++) {
		            var filepath = document.getElementById("filelist").childNodes[i + 1].getAttribute("DATA2");
		            if (filepath.indexOf(pBoardID) != -1) {
		                strRet += filepath + ";";
		            } else {
		                strRet += "tempUploadFile/" + filepath.replace(/;/gi, "%3b").replace(/\+/gi, "%2b") + ";";
		            }
		        }
		        window.parent.attachxml = strRet;
		        isfileup = false;
		    }
		
		    function uploadFailed(evt) {
		        alert("There was an error attempting to upload the file.");
		    }
		
		    function uploadCanceled(evt) {
		        alert("The upload has been canceled by the user or the browser dropped the connection.");
		    }
		
		    function btnfileup() {
		        document.getElementById("file").click();
		    }
		
		    function filechange(e) {
		        onDrop();
		    }
		
		    function btnfiledel() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        var pBoardID = window.parent.pBoardID;
		        var strRet = "";
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked == true) {
		                var pAttachDelSN;
		                var pAttachDelFileName;
		                var is_newfile;
		                var pNewNodeName = "";
		                var Rtnval;
		
		                pAttachDelFileName = document.getElementById("filelist").childNodes[i].getAttribute("DATA2");
		                is_newfile = document.getElementById("filelist").childNodes[i].getAttribute("NEWFILE");
		                pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";
		                window.parent.DelAttachFileAtList(pNewNodeName);
		
		                var delfilesize;
		                delfilesize = document.getElementById("filelist").childNodes[i].lastChild.textContent;
		                filesize -= delfilesize;
		                file.splice(i - 1, 1);
		                document.getElementById("filelist").removeChild(document.getElementById("filelist").childNodes[i]);
		                i--;
		                filecnt--;
		            }
		        }
		        filecnt = document.getElementById("filelist").childNodes.length;
		        for (var i = 1; i < filecnt; i++) {
		            var filepath = document.getElementById("filelist").childNodes[i].getAttribute("DATA2");
		            if (filepath.indexOf(pBoardID) != -1) {
		                strRet += filepath + ";";
		            }
		            else if (filepath.indexOf("tempUploadFile") != -1)
		            {
		                strRet += filepath + ";";
		            }
		            else {
		                strRet += pBoardID + "/uploadFile/" + filepath + ";";
		            }
		        }
		        window.parent.attachxml = strRet;
		    }
		
		    function checkall() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("checkboxall").checked == true) {
		                document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked = true;
		            }
		            else {
		                document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked = false;
		            }
		        }
		    }
		
		    function fileupload() {
		        var fd = new FormData();
		        for (var i = 0; i < file.length; i++) {
		            fd.append("fileToUpload", file[i]);
		        }
		        fd.append("boardID", window.parent.pBoardID);
		        fd.append("maxSize", window.parent.AttachLimit * 1024 * 1024);
		        fd.append("mode", "ATT");
		
		        isfileup = true;
		        xhr.upload.addEventListener("progress", uploadProgress, false);
		        xhr.addEventListener("load", uploadComplete, false);
		        xhr.addEventListener("error", uploadFailed, false);
		        xhr.addEventListener("abort", uploadCanceled, false);
		        xhr.open("POST", "/ezBoard/uploadItemAttach.do");
		        xhr.send(fd);
		        file = new Array;
		        document.getElementById('progdiv').style.display = "inline-block";
		    }
		
		</script>
	</head>  
    <body style ="width:100%;height:100%;overflow:hidden">   
        <div style="width:100%;white-space:nowrap;display:inline-block">
            <span style="float:left">
                <a class="imgbtn" onclick="btnfileup()"><span><spring:message code='ezBoard.t440' /></span></a>
                <a class="imgbtn" onclick="btnfiledel()"><span><spring:message code='ezBoard.t441' /></span></a>   
            </span>
            <div id="progdiv" class="progarea" style="display:none">
             	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
             </div>
        </div>
        <div id="lstAttachLink" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
        </div>
        <input id="file" type="file" onchange="filechange(event)" multiple style="width:1px;height:1px"/>
        <input type="hidden" value="upload" onclick ="fileupload()" />
  </body>
</html>