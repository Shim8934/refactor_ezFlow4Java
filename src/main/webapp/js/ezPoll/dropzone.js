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

function onDrop(evt) {	
    file = new Array;
    
    if (evt != undefined) {    	
        evt.stopPropagation();
        evt.preventDefault();
    }   
    
    if (isfileup) {    	
        alert(strLang258);
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
            alert(messageCode3);
            return;
        }
        else {
            file[filecnt + i] = filelist[i];
            tempfilesize += filelist[i].size;
        }
    }    
    
    filesize += tempfilesize;
    fileupload();
    
    //같은 파일을 업로드 할 때, onchange 이벤트가 발생하지 않아 아래부분 추가. 2018-12-19 홍대표
    if (CrossYN()) {
    	
    	if (navigator.userAgent.search('Trident') != -1) { //IE 11
    		document.getElementById("file").type = "text";
            document.getElementById("file").type = "file";
    	} else {
        	document.getElementById("file").value = "";
    	}
        
    } else {
        document.getElementById("file").type = "text";
        document.getElementById("file").type = "file";
    }
}

function fileUploadStart() {
    var ua = navigator.userAgent;
    
    if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1 && ua.indexOf("Macintosh") == -1) {
        document.getElementById("file").multiple = false;
    }
    
	var oTable = document.getElementById("filelist");
	
	if (oTable == null) {
		oTable = document.createElement("TABLE");
	    oTable.style.width = "100%";
	    oTable.id = "filelist";
	    oTable.className = "sublist";
	}
	
    document.getElementById("lstAttachLink").appendChild(oTable); 
}

function uploadProgress(evt) {
    if (evt.lengthComputable) {
        var percentComplete = Math.round(evt.loaded * 100 / evt.total);
        document.getElementById('prog_bar').style.width = percentComplete + "%";
        document.getElementById('prog_num').innerHTML = percentComplete;
    }
}

function uploadComplete(evt) {
	xhr.removeEventListener("load", uploadComplete);
    document.getElementById('prog_bar').style.width = "0%";
    document.getElementById('prog_num').innerHTML = "0";
    document.getElementById('progdiv').style.display = "none";   
    setAttachFileInfo1(xhr.responseText);
    isfileup = false;    
}

function uploadFailed(evt) {
    alert(messageCode1);
}

function uploadCanceled(evt) {
    alert(messageCode2);
}

function filedelete(r) {
    var filecnt = document.getElementById("filelist").childNodes.length;
    var pBoardID = window.parent.pBoardID;
    var strRet = "";
    var fileinfo = r.getAttribute("_path");    
    var isFileDelete = false;    
    var i = r.parentNode.parentNode.rowIndex;
    document.getElementById("filelist").deleteRow(i);
    
    //Send delete file request to server
    var fd = new FormData();
    fd.append("fileToDelete", fileinfo);
    xhr.open("POST", "/ezPoll/deleteFile.do");
    xhr.send(fd);
    showAttachInnerNotice();
}

function fileupload() {	
    var fd = new FormData();

    for (var i = 0; i < file.length; i++) {
        fd.append("fileToUpload", file[i]);
    }
    
    fd.append("boardid", window.parent.pBoardID);
    fd.append("maxsize", window.parent.AttachLimit * 1024 * 1024);
    fd.append("mode", "ATT");   
    isfileup = true;
    xhr.upload.addEventListener("progress", uploadProgress, false);
    xhr.addEventListener("load", uploadComplete, false);
    xhr.addEventListener("error", uploadFailed, false);
    xhr.addEventListener("abort", uploadCanceled, false);
    xhr.open("POST", "/ezPoll/uploadFile.do");
    xhr.send(fd);    
    document.getElementById('progdiv').style.display = "inline-block";
}

function setAttachFileInfo1(strXML) {	
    if (strXML == "ERROR") {    	
        alert(strLang28);
        return;
    }     
    
    var xml = loadXMLString(strXML);  
    
    try {    	
        var listtable;    
        listtable = document.getElementById("filelist");
        var lstAttachLink = document.getElementById("lstAttachLink");
        /*lstAttachLink.insertBefore(listtable, lstAttachLink.firstChild);*/
        document.getElementById("lstAttachLink").appendChild(listtable);
        document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_off";
        var extCheck = false;
        
        for (i = 0; i < SelectNodes(xml, "ROOT/NODES/DATA").length; i++) {
            var fileinfo = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA")[i]);
            var attid = getNodeText(SelectNodes(xml, "ROOT/NODES/DATA2")[i]);

            if (getNodeText(SelectNodes(xml, "ROOT/NODES/DATA3")[i]) == "OK") {            	
            	fileinfoArr = fileinfo.split("|");
            	for(var j = 0; j < fileinfoArr.length; j++){
            		fileinfo = fileinfoArr[j];
            		objTr = document.createElement("TR");
            		objTr.setAttribute("fileinfo", fileinfo);
            		objTr.setAttribute("attid", attid);
            		
            		var objTd = document.createElement("TD");                
            		objTd.style.paddingLeft  = "10px";
            		objTd.style.paddingRight = "0px";
            		objTd.style.paddingBottom = "0px";
            		objTd.style.paddingTop = "0px";
            		objTd.style.width = "24px";
            		objTd.style.height = "24px";
            		
            		var image_tag = document.createElement("img");
            		image_tag.setAttribute("_path", fileinfo);
            		image_tag.src = "/images/poll/pollAddFile_Delicon.png";
            		image_tag.setAttribute("height", "24");
            		image_tag.setAttribute("width", "20");
            		image_tag.setAttribute("style", "vertical-align: middle; cursor: pointer;");                
            		image_tag.onclick = function () { filedelete(this); };
            		objTd.appendChild(image_tag);
            		objTr.appendChild(objTd);
            		
            		var objTd2 = document.createElement("TD");
            		objTd2.style.paddingBottom = "0px";
            		objTd2.style.paddingTop = "0px";
            		
            		var fileSize = parseInt(fileinfo.split("/")[2]);
            		
            		/* 2020-02-07 홍승비 - personalizedPortal에서 등록, 수정 시 첨부파일의 크기를 상세보기 시와 동일하게 수정 */
            		if (fileSize / 1024 / 1024 > 1) {
            			fileSize = ((parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(2) + "MB";
            		}
            		else if (fileSize / 1024 > 1) {
            			fileSize = parseFloat(fileSize / 1024).toFixed(2) + "KB";
            		}
            		else {
            			fileSize = fileSize + "B";
            		}
            		
            		var strFileSize = fileinfo.split("/")[1] + "(" + fileSize + ")";
            		//objTd2.innerHTML = strFileSize;
            		objTd2.textContent = strFileSize;
            		objTr.appendChild(objTd2);
            		document.getElementById("filelist").appendChild(objTr);
            	}
            }
            else
                extCheck = true;          
        }
        
        if (extCheck) {
            alert(strLang267);
        }
    }
    catch (e) { 
    	alert("returnvalue :: " + e.description); 
    }
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
