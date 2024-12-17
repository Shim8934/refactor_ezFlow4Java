<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<style>
		#lstAttachLink {
			height: 117px;
			border: 1px solid #3C2F2E;
			margin-top: 5px;
			overflow: auto;
		}
	</style>
	<script type="text/javascript">
		var lstAttachLink = document.getElementById("lstAttachLink");
	    var isfileup = false;
	    var mode = "${mode}";
	    var projectId = "${projectId}";
	    var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");	
	    var filesize = 0;
	    var file = new Array;
	    var xhr = new XMLHttpRequest();
	    
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
	
	    function btnfileup() {
	        document.getElementById("file").click();
	    }

	    function filechange(evt) {
	        onDrop();
	    }
	    
	    function onDrop(evt) {
	        file = new Array;
	        
	        if (evt != undefined) {
	            evt.stopPropagation();
	            evt.preventDefault();
	        }
	        
	        if (isfileup) {
	            alert("<spring:message code='ezCircular.t93'/>");
	            return;
	        }
	        
	        var filelist;
	        
	        if (evt == undefined) {
	            filelist = document.getElementById("file").files;
	        } else {
	            filelist = evt.dataTransfer.files;
	        }
	
	        var tempfilesize = 0;
	        var filecnt = file.length;
	        var filelistCount = filelist.length;
	        
	        for (var i = 0; i < filelistCount; i++) {
	            if (filelist[i].size / 1024 / 1024 > window.parent.AttachLimit) {
	                alert("<spring:message code='ezPMS.t229' arguments='" + window.parent.AttachLimit + "'/>");
	                return;
	            } else {
	                file[filecnt + i] = filelist[i];
	                tempfilesize += filelist[i].size;
	            }
	        }
	        
	        filesize += tempfilesize;
		    fileupload();
	    }
	    
	    function fileupload() {
	        var fd = new FormData();
	        var url = "";
			var fileCount = file.length;
			
	        for (var i = 0; i < fileCount; i++) {
				var fnl = file[i].name.length;
	        	
	        	if (fnl > attachFileNameMaxLength) {
	        		alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
	        		isfileup = false;		        			
	        		return;
	        	} else {
	        		fd.append("fileToUpload", file[i]);
	        	}		            
	        }
	        
	        fd.append("maxSize", window.parent.AttachLimit * 1024 * 1024);

	        isfileup = true;
	        xhr.upload.addEventListener("progress", uploadProgress, false);
	        xhr.addEventListener("load", uploadComplete, false);
	        xhr.addEventListener("error", uploadFailed, false);
	        xhr.addEventListener("abort", uploadCanceled, false);
	        
	        url = "/ezPMS/uploadProjectAttach.do?mode=" + mode + "&projectId=" + projectId;
	        
	        xhr.open("POST", url);
	        xhr.send(fd);
	        document.getElementById('progdiv').style.display = "inline-block";
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
	        } else{
	            objTh.style.width = "15px";
	        }
	        
	        var input = document.createElement("input");
	        input.type = "checkbox";
	        input.id = "checkboxall";
	        input.onclick = function () { 
	        	checkall(); 
	        };
	        
	        objTh.appendChild(input);
	        objTr.appendChild(objTh);

	        var objTh2 = document.createElement("TH");
	        objTh2.style.width = "87%";
	        setNodeText(objTh2, "<spring:message code='ezBoard.t5008'/>");
	        objTr.appendChild(objTh2);

	        var objTh3 = document.createElement("TH");
	        setNodeText(objTh3, "<spring:message code='ezJournal.t85'/>");
	        objTh3.style.width = "13%";
	        objTr.appendChild(objTh3);

	        oTable.appendChild(objTr);
	        document.getElementById("lstAttachLink").appendChild(oTable);
	    }
	    
	    function btnfiledel() {
	        var filecnt = document.getElementById("filelist").childNodes.length;
	        var strRet = "";
	        var fileList = "";
	        var isFileDelete = false;
	        
	        for (var i = 1; i < filecnt; i++) {
	            if (document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked == true) {
	                var pAttachDelSN;
	                var pAttachDelFileName;
	                var is_newfile;
	                var pNewNodeName = "";
	                var Rtnval;

	                pAttachDelFileName = document.getElementById("filelist").childNodes[i].getAttribute("fileInfo");
	                
	                if (fileList == "") {
						fileList = pAttachDelFileName;
					} else {
						fileList += "/" + pAttachDelFileName;
					}
	                
	                var delfilesize;
	                delfilesize = getNodeText(document.getElementById("filelist").childNodes[i].lastChild);
	                filesize -= delfilesize;
	                file.splice(i - 1, 1);
	                document.getElementById("filelist").removeChild(document.getElementById("filelist").childNodes[i]);
	                i--;
	                filecnt--;

	                isFileDelete = true;
	            }
	        }

	        if (!isFileDelete) {
	            alert("<spring:message code='ezPMS.t133' />");
	        }
	        
	        $.ajax({
				async : false,
				url : "/ezPMS/uploadFileDelete.do",
                type : 'POST',
                dataType : 'text',
                data : {
                	fileList : fileList
                },
                success: function() {
                },
                error: function() {
                	alert("error");	
                }
			});
	    }
	    
	    function uploadProgress(evt) {
	        if (evt.lengthComputable) {
	            var percentComplete = Math.round(evt.loaded * 100 / evt.total);
	            document.getElementById('prog_bar').style.width = percentComplete + "%";
	            document.getElementById('prog_num').innerHTML = percentComplete;
	        }
	    }
	
	    function uploadComplete(evt) {
	        document.getElementById('prog_bar').style.width = "0%";
	        document.getElementById('prog_num').innerHTML = "0";
	        document.getElementById('progdiv').style.display = "none";
	        console.log(xhr.responseText);
	        setAttachFileInfo(xhr.responseText);	        
        
	        isfileup = false;
	    }
	
	    function uploadFailed(evt) {
	        alert("There was an error attempting to upload the file.");
	    }

	    function uploadCanceled(evt) {
	        alert("The upload has been canceled by the user or the browser dropped the connection.");
	    }
	
	    function setAttachFileInfo(str) {
	        var filelist = JSON.parse(str);
	        
	        try {
	            var listtable;
	            var extCheck = false; 
				var filelistCount = filelist.length;
				
	            listtable = document.getElementById("filelist");
	            document.getElementById("lstAttachLink").appendChild(listtable);

	            for (i = 0; i < filelistCount; i++) {
	                var newFileName = filelist[i].pUploadSN;
	                var pFileName = filelist[i].pFileName;
	                var fileSize = filelist[i].fileSize;

	                if (filelist[i].resultUpload == "true") {
	                    objTr = document.createElement("TR");
	                    objTr.setAttribute("fileInfo", newFileName + ":" + pFileName + ":" + fileSize);

	                    var objTd = document.createElement("TD");
	                    objTd.style.textAlign = "center";

	                    var input = document.createElement("input");
	                    input.type = "checkbox";
	                    input.name = "fileSelect";

	                    objTd.appendChild(input);
	                    objTr.appendChild(objTd);

	                    var objTd2 = document.createElement("TD");

	                    objTd2.setAttribute("NAME", "fileName");
	                    objTd2.innerText = pFileName;
	                    objTd2.style.wordWrap = "break-word";
	                    objTr.appendChild(objTd2);

	                    var fileSize = parseInt(fileSize);

	                    if (fileSize / 1024 / 1024 > 1) {
	                        fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
	                    } else if (fileSize / 1024 > 1) {
	                        fileSize = parseInt(fileSize / 1024) + "KB";
	                    } else {
	                        fileSize = fileSize + "B";
	                    }

	                    var objTd3 = document.createElement("TD");
	                    setNodeText(objTd3, fileSize);
	                    objTr.appendChild(objTd3);

	                    document.getElementById("filelist").appendChild(objTr);
	                } else {
	                    extCheck = true;
	                }
	            }
	            
	            if (extCheck) {
	                alert("<spring:message code='main.sp12'/>");
	            }
	        } catch (e) { 
	        	alert("returnvalue :: " + e.description); 
	        }
	    }
		    
	    function checkall() {
	        var filecnt = document.getElementById("filelist").childNodes.length;

	        for (var i = 1; i < filecnt; i++) {
	            if (document.getElementById("checkboxall").checked == true) {
	                document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked = true;
	            } else {
	                document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked = false;
	            }
	        }
	    }
	</script>
</head>
<body style ="width:100%; height:100%; overflow:hidden;">
	<div style="width:100%; white-space:nowrap; display:inline-block; height:22px">
	    <div style="float:left">
	        <a class="imgbtn" onclick="btnfileup()"><span><spring:message code='ezSchedule.t370'/></span></a>
	        <a class="imgbtn" onclick="btnfiledel()"><span><spring:message code='ezSchedule.t371'/></span></a>
	    </div>
	    <div id="progdiv" class="progarea" style="display:none">
	     	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
	    </div>
	    <div style="clear:both"></div>
	</div>
	<div id="lstAttachLink" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)">
	</div>
	<input id="file" type="file" onchange="filechange(event)" multiple="multiple" style="width:1px; height:1px; display:none;" />
</body>
</html>