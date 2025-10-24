<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style>
			#lstAttachLink {
			height: 105px;
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
                line-height: 55px;
            }
            
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
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
		    	file = new Array;
		    	
		        if (evt != undefined) {
		            evt.stopPropagation();
		            evt.preventDefault();
		        }
		        if (isfileup) {
		            alert("<spring:message code='ezTask.jsh03' />");
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

		        for (var i = 0; i < filelist.length; i++) {
		            filesize = parseInt(filesize) + parseInt(filelist[i].size);
		            if (filesize / 1024 / 1024 > window.parent.AttachLimit) {
		                if ("<c:out value='${userInfo.lang}'/>" == "2") {
		                    alert(strLang8 + window.parent.AttachLimit + strLang9);
		                } else {
		                    alert(strLang8 + window.parent.AttachLimit + "MB" + strLang9);
		                }
		                if (tempfilesize == 0) {
		                    filesize = parseInt(filesize) - parseInt(filelist[i].size);
		                } else {
		                    filesize = parseInt(filesize) - tempfilesize;
		                }
		                return;
		            } else {
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
		        } else {
		            objTh.style.width = "15px";
		        }
		        
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
		        setNodeText(objTh2, strLang1);
		        objTr.appendChild(objTh2);
		
		        var objTh3 = document.createElement("TH");
		        setNodeText(objTh3, strLang3);
		        objTh3.style.width = "13%";
		        objTr.appendChild(objTh3);
		
		        oTable.appendChild(objTr);
		        document.getElementById("lstAttachLink").appendChild(oTable);
                document.getElementById("lstAttachLink").appendChild(getAttachInnerNoticeObject());

                setAttachSortable();
		    };
		
		    function uploadComplete(evt) {
		        document.getElementById('prog_bar').style.width = "0%";
		        document.getElementById('prog_num').innerHTML = "0";
		        document.getElementById('progdiv').style.display = "none";
		        window.parent.setAttachFileInfo(xhr.responseText);	

		        isfileup = false;
		        
		        if (CrossYN()) {
		            document.getElementById("file").value = "";
		        } else {
		            document.getElementById("file").type = "text";
		            document.getElementById("file").type = "file";
		        }
		    }
		
		    function uploadFailed(evt) {
		        alert("<spring:message code='ezTask.jsh04' />");
		    }
		
		    function uploadCanceled(evt) {
		        alert("<spring:message code='ezTask.jsh05' />");
		    }
		
		    function btnfileup() {
		        document.getElementById("file").click();
		    }
		
		    function filechange(e) {
		    	if (!document.getElementById("file").value == "") {
			        onDrop();
		    	}
		    }
		
		    function btnfiledel() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        var pBoardID = window.parent.pBoardID;
		        var strRet = "";
		        var fileList = "";
                var isFileDelete = false;
                
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].childNodes[0].checked == true) {
		                var pAttachDelSN;
		                var pAttachDelFileName;
		                var is_newfile;
		                var Rtnval;

		                pAttachDelFileName = document.getElementById("filelist").childNodes[i].getAttribute("DATA");

						if (fileList == "") {
							fileList = pAttachDelFileName;
						} else {
							fileList += "," + pAttachDelFileName;
						}

		                var delfilesize;
		                delfilesize = document.getElementById("filelist").childNodes[i].lastChild.textContent;
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
                showAttachInnerNotice();
                
		        url = "/ezTask/tempUploadFileDelete.do";

		        // upload된 파일 tempUploadFile에서 삭제
		        $.ajax({
					async : false,
					url : url,
	                type : 'POST',
	                dataType : 'json',
	                data : {
	                	fileList : fileList
	                },
	                success: function() {
	                	$("#checkboxall").prop("checked", false);
	                },
	                error: function() {
	                	alert("<spring:message code='ezTask.t992' />");	
	                }
				});
		    }
		
		    function checkall() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("checkboxall").checked == true) {
		                document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].childNodes[0].checked = true;
		            }
		            else {
		                document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].childNodes[0].checked = false;
		            }
		        }
		    }
		
		    function fileupload() {
		        var fd = new FormData();
		        var url = "";

		        for (var i = 0; i < file.length; i++) {
		            fd.append("fileToUpload", file[i]);
		        }

		        fd.append("maxSize", window.parent.AttachLimit * 1024 * 1024);

		        isfileup = true;
		        xhr.upload.addEventListener("progress", uploadProgress, false);
		        xhr.addEventListener("load", uploadComplete, false);
		        xhr.addEventListener("error", uploadFailed, false);
		        xhr.addEventListener("abort", uploadCanceled, false);
		        
		        url = "/ezTask/uploadItemAttach.do";

		        xhr.open("POST", url);
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
                    items : "tr[data]",
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
                var fileCnt = document.querySelectorAll("#filelist tr[data2]").length;
                if (fileCnt > 0) {
                    document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_off";
                } else {
                    document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_on";
                }
            }
		</script>
	</head>  
	<body style ="width:100%;height:100%;overflow:hidden">   
        <div style="width:100%;white-space:nowrap;display:inline-block; height: 25px;">
            <div style="float:left">
                <a class="imgbtn imgbck" onclick="btnfileup()"><span><spring:message code='ezTask.t215' /></span></a>
                <a class="imgbtn imgbck" onclick="btnfiledel()"><span><spring:message code='ezTask.t216' /></span></a>   
            </div>
            <div id="progdiv" class="progarea" style="display:none">
             	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
             </div>
        </div>
        <div id="lstAttachLink" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
        </div>
        <input id="file" type="file" onchange="filechange(event)" multiple style="width:1px;height:1px;display:none;"/>
        <input type="hidden" value="upload" onclick ="fileupload()" />
    </body>
</html>