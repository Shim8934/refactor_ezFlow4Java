<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html ondragover="bodydragover(event)">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			#lstAttachLink {
			height: 115px;
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
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezBoard.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
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
		            alert("<spring:message code='ezBoard.t2000'/>");
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
		        
		        /* 2023-08-16 홍승비 - 게시물에 첨부파일 추가 시, 파일 사이즈의 총합을 계산하는 첨부파일 크기제한 로직 수정 */
		        for (var i = 0; i < filelist.length; i++) {
					// 기존 첨부파일 사이즈 + 루프 내부에서 계산한 첨부파일 사이즈를 크기제한 사이즈와 비교 
		            if (((filesize + tempfilesize + parseInt(filelist[i].size)) / 1024 / 1024) > window.parent.AttachLimit) {
		                if ("${userInfo.lang}" == "2") {
		                    alert(strLang8 + window.parent.AttachLimit + strLang9);
		                } else {
		                    alert(strLang8 + window.parent.AttachLimit + "MB" + strLang9);
		                }
		                
		             	// 첨부파일 크기제한 초과 시, 첨부를 시도한 파일은 전부 초기화
		             	document.getElementById("file").value = "";
		                return;
		            } else {
		                file[filecnt + i] = filelist[i];
		                tempfilesize += filelist[i].size;
		            }
		        }
		        
		        filesize += tempfilesize;
		        
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
		        objTh.appendChild(input);
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
		        window.parent.returnvalue(xhr.responseText);
		        
		        var strRet = "";
		        var fileNamesStr = "";
		        var pBoardID = window.parent.pBoardID;
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        var tempxmldom = loadXMLString(xhr.responseText);
		        
		        /* 2021-04-29 홍승비 - 새로운 첨부파일 업로드 완료 후, 파일경로(DATA2) 속성을 갱신하도록 수정 */
		        for (var i = 0; i < filecnt - 1; i++) {
		            var filepath = document.getElementById("filelist").childNodes[i + 1].getAttribute("DATA2");
		            var realFileName = document.getElementById("filelist").childNodes[i + 1].getAttribute("REALFILENAME");
		            
		            if (filepath.indexOf(pBoardID) != -1) {
		                strRet += filepath + "|";
		                fileNamesStr += realFileName + "|";
		            } else {
                        var tempUploadFileStr = '';
                        if (filepath.split('/')[0]  != "tempUploadFile") {
                            tempUploadFileStr = 'tempUploadFile/';
                        }
		                strRet += tempUploadFileStr + filepath + "|";
		                fileNamesStr += realFileName + "|";
		                document.getElementById("filelist").childNodes[i + 1].setAttribute("DATA2", tempUploadFileStr + filepath);
		            }
		        }
		        window.parent.attachxml = strRet;
		        window.parent.realFileNames = fileNamesStr;
		        isfileup = false;
		        
		        if (CrossYN()) {
		            document.getElementById("file").value = "";
		        } else {
		            document.getElementById("file").type = "text";
		            document.getElementById("file").type = "file";
		        }
		    }
		
		    function uploadFailed(evt) {
		        alert("<spring:message code='ezBoard.hyj02'/>");
		    }
		
		    function uploadCanceled(evt) {
		        alert("<spring:message code='ezBoard.hyj03'/>");
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
                var fileNamesStr = "";
		        var checkedFileCnt = $("input[name='fileSelect']:checked").length; // 실제로 삭제하기 위해 체크된 파일 갯수
		        
		        if (checkedFileCnt <= 0) {
					alert("<spring:message code='ezJournal.t163'/>");
		        	return;
		        }
		        
		        for (var i = 1; i < filecnt; i++) {
		            if (document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked == true) {
		                var pAttachDelSN;
		                var pAttachDelFileName;
		                var is_newfile;
		                var pNewNodeName = "";
		                var Rtnval;
		                var delfilesize = 0;
		
		                pAttachDelFileName = document.getElementById("filelist").childNodes[i].getAttribute("DATA2");
		                is_newfile = document.getElementById("filelist").childNodes[i].getAttribute("NEWFILE");
		                pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";
		                delfilesize = parseInt(document.getElementById("filelist").childNodes[i].getAttribute("REALFILESIZE"));
		                window.parent.DelAttachFileAtList(pNewNodeName);
		                
		                filesize = parseInt(filesize) - delfilesize; // filesize는 계산 시 MB 단위가 아닌 byte 단위로 계산
		                file.splice(i - 1, 1);
		                document.getElementById("filelist").removeChild(document.getElementById("filelist").childNodes[i]);
		                i--;
		                filecnt--;
		            }
		        }
		        filecnt = document.getElementById("filelist").childNodes.length;
		        for (var i = 1; i < filecnt; i++) {
		            var filepath = document.getElementById("filelist").childNodes[i].getAttribute("DATA2");
		            var realFileName = document.getElementById("filelist").childNodes[i].getAttribute("REALFILENAME");
		            
		            if (filepath.indexOf(pBoardID) != -1) {
		                strRet += filepath + "|";
		                fileNamesStr += realFileName + "|";
		            }
		            else if (filepath.indexOf("tempUploadFile") != -1)
		            {
		                strRet += filepath + "|";
		                fileNamesStr += realFileName + "|";
		            }
		            else {
		                strRet += pBoardID + "/uploadFile/" + filepath + "|";
		                fileNamesStr += realFileName + "|";
		            }
		        }
		        window.parent.attachxml = strRet;
		        window.parent.realFileNames = fileNamesStr;
                showAttachInnerNotice();
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
                    var fnl = file[i].name.length;
                    if (file[i].name.lastIndexOf('.') != -1) { // 2024-02-13 확장자 제외 파일명 길이를 체크
                        fnl = file[i].name.lastIndexOf('.');
                    }
		        	
		        	if (fnl > attachFileNameMaxLength) {
		        		alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
		        		isfileup = false;
		        		document.getElementById("file").value = "";
		        		
		        		return;
		        	} else {
		            	fd.append("fileToUpload", file[i]);
		        	}
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
		        document.getElementById('progdiv').style.display = "inline-block";
		    }
		    
		    function bodydragover(evt) {
				evt.dataTransfer.dropEffect = "none";
				evt.stopPropagation();
				evt.preventDefault();
			}
		    
		    /* 2023-08-16 홍승비 - 현재 게시물의 첨부파일 사이즈 총합을 계산하여 filesize 변수에 설정하는 함수 */
		    function initAttachFileSize() {
		    	filesize = 0; // 첨부파일 사이즈 전역변수 초기화
		    	var attachListTR = $("#filelist tr");
		    	
		    	$.each(attachListTR, function(index, item) {
		    		var pRealFileSize = item.getAttribute("realfilesize");
		    		
		    		if (typeof(pRealFileSize) != "undefined" && pRealFileSize != null) {
		    			filesize += parseInt(item.getAttribute("realfilesize"));
		    		}
		    	});
		    }

            function defaultenter(evt) {
                evt.dataTransfer.dropEffect = "none";
                evt.stopPropagation();
                evt.preventDefault();
            }
            
            function setAttachSortable() {
                $("#lstAttachLink").multipleSortable({
                    items : "tr[data2]",
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

            function moveAttachFileOrder(fileList, attachxml) {
                var fileIdxArr = [].map.call(fileList, function(fileNode){
                    return fileNode.getAttribute("_fileindex");
                });

                for (var i = 0; i < fileIdxArr.length; i++) {
                    if (i != fileIdxArr[i]) {
                        saveAttachFileOrder();
                        break;
                    }
                }
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

            function saveAttachFileOrder(){
                var pBoardID = window.parent.pBoardID;
                var strRet = "";
                var filecnt = document.getElementById("filelist").childNodes.length;
                
                for (var i = 1; i < filecnt; i++) {
                    var filepath = document.getElementById("filelist").childNodes[i].getAttribute("DATA2");
                    if (filepath.indexOf(pBoardID) != -1) {
                        strRet += filepath + "|";
                    }
                    else if (filepath.indexOf("tempUploadFile") != -1)
                    {
                        strRet += filepath + "|";
                    }
                    else {
                        strRet += pBoardID + "/uploadFile/" + filepath + "|";
                    }
                }
                window.parent.attachxml = strRet;
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
	<body ondragover ="defaultenter(event)" ondragenter ="defaultenter(event)" style ="width:100%;height:100%;overflow:hidden">
        <div style="width:100%;white-space:nowrap;display:inline-block; height: 23px;">
            <div style="float:left">
                <a class="imgbtn imgbck" onclick="btnfileup()"><span><spring:message code='ezBoard.t440' /></span></a>
                <a class="imgbtn imgbck" onclick="btnfiledel()"><span><spring:message code='ezBoard.t441' /></span></a>   
            </div>
            <div id="progdiv" class="progarea" style="display:none">
             	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
             </div>
        </div>
        <div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
        </div>
        <input id="file" type="file" onchange="filechange(event)" multiple style="display:none"/>
        <input type="hidden" value="upload" onclick ="fileupload()" />
    </body>
</html>