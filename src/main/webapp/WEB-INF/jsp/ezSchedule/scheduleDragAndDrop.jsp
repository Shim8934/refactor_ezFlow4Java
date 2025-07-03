<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezSchedule.e1', 'msg')}"></script>		
		<style>
			#lstAttachLink {
				height: 117px;
				border: 1px solid #d2d2d2;
			}
            
            .attachInnerNotice_p_on {
                text-align: center;
                margin: 10px 0 0 0;
            }

            .attachInnerNotice_p_off {
                display: none;
            }

            .attachInnerNotice_span {
                line-height: 55px;.
            }
		</style>
		<script type="text/javascript">
			var lstAttachLink = document.getElementById("lstAttachLink");
		    var isfileup = false;
		    var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
		    
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
		        file = new Array;
		        if (evt != undefined) {
		            evt.stopPropagation();
		            evt.preventDefault();
		        }
		        if (isfileup) {
		            //alert(strLang258);
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
		            if (filelist[i].size / 1024 / 1024 > 5) {
		                alert(strLang25);
		                return;
		            }
		            else {
		                file[filecnt + i] = filelist[i];
		                tempfilesize += filelist[i].size;
		            }
		        }
		        filesize += tempfilesize;
	
/* 		        if (CrossYN()) {
		            document.getElementById("file").value = "";
		        }
		        else {
		            document.getElementById("file").type = "text";
		            document.getElementById("file").type = "file";
		        } */
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
		        var ua = navigator.userAgent;
		        if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1 && ua.indexOf("Macintosh") == -1) {
		            objTh.style.width = "24px";
		        }
		        else
		            objTh.style.width = "15px";
		        var input = document.createElement("input");
		        input.type = "checkbox";
		        input.id = "checkboxall";
		        input.onclick = function () { checkall(); };
		        var oDiv = document.createElement("div");
		        oDiv.className = "custom_checkbox";
		        oDiv.appendChild(input);
		        objTh.appendChild(oDiv);
		        objTr.appendChild(objTh);
	
		        var objTh2 = document.createElement("TH");
		        objTh2.style.width = "87%";
		        setNodeText(objTh2, strLang260);
		        objTr.appendChild(objTh2);
	
		        var objTh3 = document.createElement("TH");
		        setNodeText(objTh3, strLang259);
		        objTh3.style.width = "13%";
		        objTr.appendChild(objTh3);
	
		        oTable.appendChild(objTr);
		        document.getElementById("lstAttachLink").appendChild(oTable);
                document.getElementById("lstAttachLink").appendChild(getAttachInnerNoticeObject());
                
                setAttachSortable();
		    }
	
		    function uploadComplete(evt) {
		        document.getElementById('prog_bar').style.width = "0%";
		        document.getElementById('prog_num').innerHTML = "0";
		        document.getElementById('progdiv').style.display = "none";
		        window.parent.setAttachFileInfo(xhr.responseText);	        
		        
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
		        e.target.value = '';
		    }
	
		    function btnfiledel() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        var pBoardID = window.parent.pBoardID;
		        var strRet = "";
	
		        var isFileDelete = false;
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("filelist").childNodes[i].querySelector("input[type='checkbox']").checked == true) {
		                var pAttachDelSN;
		                var pAttachDelFileName;
		                var is_newfile;
		                var pNewNodeName = "";
		                var Rtnval;
	
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
		            alert(strLang271);
		        }
                showAttachInnerNotice();
		    }
	
		    function checkall() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
	
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("checkboxall").checked == true) {
		                document.getElementById("filelist").childNodes[i].querySelector("input[type='checkbox']").checked = true;
		            }
		            else {
		                document.getElementById("filelist").childNodes[i].querySelector("input[type='checkbox']").checked = false;
		            }
		        }
		    }
	
		    function fileupload() {
		        var fd = new FormData();

		        for (var i = 0; i < file.length; i++) {
                    var fnl = file[i].name.length;
                    if (file[i].name.lastIndexOf('.') != -1) { // 2024-02-13 확장자 제외 파일명 길이를 체크
                        fnl = file[i].name.lastIndexOf('.');
                    }
		        	
		        	if (fnl > attachFileNameMaxLength) {
		        		alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
		        		isfileup = false;		        		
		        		
		        		return;
		        	} else {
		        		fd.append("fileToUpload", file[i]);
		        	}		            
		        }
		        fd.append("boardid", window.parent.pBoardID);
		        fd.append("maxsize", window.parent.AttachLimit * 1024 * 1024);
		        fd.append("mode", "ATT");
	
		        isfileup = true;
		        xhr.upload.addEventListener("progress", uploadProgress, false);
		        xhr.addEventListener("load", uploadComplete, false);
		        xhr.addEventListener("error", uploadFailed, false);
		        xhr.addEventListener("abort", uploadCanceled, false);
		        xhr.open("POST", "/ezSchedule/uploadScheduleAttach.do");
		        xhr.send(fd);
		        document.getElementById('progdiv').style.display = "inline-block";
		    }
			
	        function bodydragover(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }

            function defaultenter(evt) {
                evt.dataTransfer.dropEffect = "none";
                evt.stopPropagation();
                evt.preventDefault();
            }

            function setAttachSortable() {
                $("#lstAttachLink").multipleSortable({
                    items : "tr[fileinfo]",
                    opacity: 0.3,
                    start : function(event, elem) {
                        $("#lstAttachLink tr").removeClass("multiple-sortable-selected");
                        $("#lstAttachLink tr").removeClass("ui-sortable-helper");
                    },
                    click : function(event) {
                        $("#lstAttachLink tr").removeClass("multiple-sortable-selected");
                        $("#lstAttachLink tr").removeClass("ui-sortable-helper");
                    },
                    stop : function(event, elem) {
                    }
                });
            }

            function getAttachInnerNoticeObject() {
                var pElem = document.createElement("p");
                pElem.id = "attachInnerNotice";
                pElem.className = "attachInnerNotice_p_on";

                var spanElem = document.createElement("span");
                spanElem.innerText = strLangMJS01;
                spanElem.className = "attachInnerNotice_span";

                pElem.appendChild(spanElem);

                return pElem;
            }
            
            function showAttachInnerNotice() {
                var fileCnt = document.querySelectorAll("#filelist tr[fileinfo]").length;
                if (fileCnt > 0) {
                    document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_off";
                } else {
                    document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_on";
                }
            }
            
		</script>
	</head>
    <body ondragover ="defaultenter(event)" ondragenter ="defaultenter(event)" style ="width:100%;height:100%;overflow:hidden">   
        <div style="width:100%;white-space:nowrap;display:inline-block;height:22px">
            <div style="float:left">
                <a class="imgbtn imgbck" onclick="btnfileup()"><span><spring:message code='ezSchedule.t370'/></span></a>
                <a class="imgbtn imgbck" onclick="btnfiledel()"><span><spring:message code='ezSchedule.t371'/></span></a>
            </div>
            <div id="progdiv" class="progarea" style="display:none">
             	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
            </div>
            <div style="clear:both"></div>
        </div>
        <div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
        </div>
        <input id="file" type="file" onchange="filechange(event)" multiple="multiple" style="width:1px;height:1px;margin-top: 10px;" />
        <input type="hidden" onclick ="fileupload()" />
  </body>
</html>
