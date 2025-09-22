<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/util/attachUtil.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
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
				line-height: 55px;
			}
		</style>
		<script type="text/javascript">
		    var lstAttachLink = document.getElementById("lstAttachLink");
		    var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
		    var status = 0; // 일반-대용량 첨부파일 구분 상태값  
            const fileExtensions = '${useFileExtension}'.split(',');

            $(document).ready(function () {
                if ($("#lstAttachLink").length > 0) {
                    $("#lstAttachLink").on("change", "input[type='checkbox'][name='fileSelect']", function () {
                        if ($("#lstAttachLink input[name='fileSelect']:checked").length !== $("#lstAttachLink input[name='fileSelect']").length) {
                            document.getElementById("checkboxall").checked = false;
                        } else {
                            document.getElementById("checkboxall").checked = true;
                        }
                    });
                }
            });
            
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
		    var bigfilesize = 0;
		    var file = new Array;
		    var bigfile = new Array;
		    var xhr = new XMLHttpRequest();
		    var filelist;
		    var isfileup = false;
		    var isbigyn = "N";
			var alertCnt = 1;
			var currUid = 0;
		    var shareId = '<c:out value="${shareId}"/>';
            var zipPassword;
		    
		    function onDrop(evt) {
                
                if (checkZipFileEncryprUploadCheck()) {
                    if (evt != undefined) {
                        evt.stopPropagation();
                        evt.preventDefault();
                    
                        if (evt.dataTransfer.items == undefined || evt.dataTransfer.items == null) {
                            
                            if (evt.dataTransfer.files.length == 0) {
                                alert(strLangKMS08);
                                return;
                            }
                            
                        } else {
                            var length = evt.dataTransfer.items.length;
                            
                            for (var i = 0; i < length; i++) {
                                var entry = evt.dataTransfer.items[i].webkitGetAsEntry();
                                
                                if (entry.isFile) {
                                } else if (entry.isDirectory) {
                                    alert(strLangKMS08);
                                    return;
                                }
                            }
                        }
                    }				
                    
                    if (isfileup) {
                        alert(strLang86);
                        return;
                    }
            
                    if (evt == undefined) {
                        filelist = document.getElementById("file").files;
                    } else {
                        filelist = evt.dataTransfer.files;
                    }
                    
                    var tempfilesize = 0;
                    var tempbigfilesize = 0;
                    var filecnt = file.length;
                    var bigFileCheck = false;
                    var bodyTypeVal = window.parent.document.getElementById("bodyType").value; // 0:html, 1:plainText
                    var bodyTypeIsPlain = bodyTypeVal != 1 ? false : true;
                    var newBigAttachCount = 0;
                    
                    if (status == 1) {
                        isbigyn = "Y";
                        status = 0;
                    }

                    const fileListTemp = [];
                    const blockedExtList = [];

                    for (let f of filelist) {
                        const ext = f.name.substring(f.name.lastIndexOf('.') + 1).toLowerCase();
                        if (fileExtensions[0] !== '*' && fileExtensions.indexOf(ext) === -1) {
                            blockedExtList.push(f.name);
                        } else {
                            fileListTemp.push(f);
                        }
                    }

                    if (blockedExtList.length > 0 && status !== 1) {
                        alert(strLang323 + '\n' + blockedExtList.join('\n'));
                    }

                    if (fileListTemp.length <= 0) {
                        return;
                    }

                    filelist = fileListTemp;

                    for (var i = 0; i < filelist.length; i++) {
                        
                        // 2024.05.02 한슬기 : 파일명 글지수 체크 위치 변경
                        if (filelist[i].name.length > attachFileNameMaxLength) {
                            alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
                            isfileup = false;
                            return;
                        }
                    
                        if (filelist[i].size / 1024 / 1024 > window.parent.BigSizeAttachMBSize || isbigyn == "Y") {
                            filelist[i].isBig = "Y";
    
                            if (bodyTypeIsPlain){ 	continue; }
                            
                            bigFileCheck = true;
                            bigfile[filecnt + i] = filelist[i];
                            tempbigfilesize += filelist[i].size;
                            newBigAttachCount++;
                        } else {
                            file[filecnt + i] = filelist[i];
                            tempfilesize += filelist[i].size;
                        }
                    }
                    
                    if (isbigyn == "Y") {
                        bigFileCheck = true;
                    }
                    
                    if (bigFileCheck == true) {
                        if(!bigFileAttachCountCheck(newBigAttachCount)) {
                            return;
                        }
                    }
            
                    if (bigFileCheck == true && window.parent.FtotBigSizeAttachSize == 0) {
                        
                        if ("${ userInfo.lang }" == "2") {
                            alert(strLangKMS02 + window.parent.totSizeAttachMBSize + strLang76);
                        } else {
                            alert(strLangKMS02 + window.parent.totSizeAttachMBSize + "MB" + strLang76);
                        }
                        
                        file.splice(file.length - filelist.length, filelist.length);
                        return;
                    }
                    
                   // if (bigFileCheck && alertCnt < 2 && isbigyn == "N") {
                    if (bigFileCheck && isbigyn == "N") {
                        // 2018-10-05 재은수정: 일반첨부에서 대용량첨부로 전환될 때 취소 버튼 추가
                        var bigFileAttachChk = confirm(strLang77 +window.parent.BigSizeAttachMBSize + "MB" + strLang78 + window.parent._pBigAttachDownloadDay + strLang79);
                        
                        if (!bigFileAttachChk) {
                            return;
                        }
                        
                        //alertCnt++;
                    } else if ((filesize + tempfilesize) / 1024 / 1024 > window.parent.totSizeAttachMBSize && isbigyn == "N") {
    
                        /* 일반첨부파일용량 초과인경우 맨 마지막 파일을 대용량 첨부로 전환시킨다. 기존에는 return으로 종료했었음.
                        if (window.parent.FtotBigSizeAttachSize == 0) {
                            
                            if ("${ userInfo.lang }" == "2") {
                                alert(strLangKMS02 + window.parent.totSizeAttachMBSize + strLang76);
                            } else {
                                alert(strLangKMS02 + window.parent.totSizeAttachMBSize + "MB" + strLang76);
                            }
                            
                        } else if ("${ userInfo.lang }" == "2") {
                            alert(strLang75 + window.parent.totSizeAttachMBSize + strLang76);
                        } else {
                            alert(strLang75 + window.parent.totSizeAttachMBSize + "MB" + strLang76);
                        }
                        
                        file.splice(file.length - filelist.length, filelist.length);
                        */
                        var bigFileAttachChk = confirm(strLang75 +window.parent.BigSizeAttachMBSize + "MB" + strLang78 + window.parent._pBigAttachDownloadDay + strLang79);
    
                        if (!bigFileAttachChk) {
                            return;
                        }
    
                        status = 1;
                        //return status;
                        
                        // 2024.05.02 한슬기 : Drag&Drop으로 파일 첨부시 파일 첨부가 안되는 현상이 있어 수정
                        if (evt != undefined){
                            onDrop(evt);
                            return;
                        } else {
                            return status;
                        }
                    }
    
                    if ((bigfilesize + tempbigfilesize) / 1024 / 1024 > window.parent.totBigSizeAttachMBSize) {
                        
                        if ("${ userInfo.lang }" == "2") {
                            alert(strLang168 + window.parent.totBigSizeAttachMBSize + strLang169);
                        } else {
                            alert(strLang168 + window.parent.totBigSizeAttachMBSize + "MB" + strLang169);
                        }
                        
                        file.splice(file.length - filelist.length, filelist.length);
                        return;
                    }
            
                    filesize += tempfilesize;
                    bigfilesize += tempbigfilesize;
                    checkMailStatusAndFileUpload();
                    
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
                    isbigyn = "N";
                } else {
                    // 암호화가 안 되어 있으면 드래그&드롭 이벤트 막기
                    if (evt != undefined) {
                        evt.preventDefault();
                        evt.dataTransfer.dropEffect = "none";
                    } else {
                        event.preventDefault();
                        event.dataTransfer.dropEffect = "none";
                    }
                }
		    }
		    
		    function checkMailStatusAndFileUpload() {
		        console.log("MailStatus=" + window.parent.MailStatus);
		        
		        // 자동 저장 중이면 저장이 완료된 후 파일 첨부를 수행한다.
                if (window.parent.MailStatus == "NO") {             
                    fileupload();
                } else {
                    setTimeout(checkMailStatusAndFileUpload, 1000);
                }		        
		    }
		    
		    function uploadProgress(evt) {
		        
		    	if (evt.lengthComputable) {
		            var percentComplete = Math.round(evt.loaded * 100 / evt.total);
		            var ua = navigator.userAgent;
		            document.getElementById('prog_bar').style.width = percentComplete + "%";
		            document.getElementById('prog_num').innerHTML = percentComplete;
		        } else {
		            document.getElementById('prog').innerHTML = 'unable to compute';
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
		        
		        input.onclick = function () { 
		        	checkall(); 
		        };
		        
		        objTh.appendChild(input);
		        objTr.appendChild(objTh);
		
		        var objTh2 = document.createElement("TH");
		        objTh2.style.width = "calc(100% - 257px)";
		        setNodeText(objTh2, "<spring:message code='ezEmail.t725' />");
		        objTr.appendChild(objTh2);
		
		        var objTh3 = document.createElement("TH");
		        setNodeText(objTh3, "<spring:message code='ezEmail.t726' />");
		        objTh3.style.width = "118px";
		        objTr.appendChild(objTh3);
		        
		        if (window.parent.totBigSizeAttachMBSize > 0) {
		        	objTh2.style.width = "calc(100% - 387px)";
		        	
		        	var objTh4 = document.createElement("TH");
			        setNodeText(objTh4, "<spring:message code='ezEmail.sjw04' />");
			        objTh4.style.width = "230px";
			        objTr.appendChild(objTh4);
		        }
		        
		        oTable.appendChild(objTr);
		        document.getElementById("lstAttachLink").appendChild(oTable);
		        //파일 첨부 안내문구 추가. 2020-04-01 홍대표.
		        document.getElementById("lstAttachLink").appendChild(getAttachInnerNoticeObject());
		        parent.DragObjectComplet();
		        
		        if (window.parent.totBigSizeAttachMBSize == 0) {
					$("#btnBigFileUpload").css("display","none");
		        }
		        
		      	//첨부파일 드래그 기능 추가. 2020-03-17 홍대표.
		        setAttachSortable();

                $(document).mouseup(function(e) {
                    var element = parent.document.getElementById("layer_menu");
                    if (element) {
                        if (element.style.display !== 'none') {
                            parent.document.getElementById("view_more").classList.remove('on');
                            element.style.display = 'none';
                        }
                    }
                })

				// load attach files.
				fetchFiles();
		    }

			// 서버에 요청해서 가져다가 첨부하는 방식
			async function fetchFiles() {
				if (!parent.gg_url) return;
				if (!parent.writetype) return;
				if (!parent.writetype.isForwardAsAttach) return; // eml을 첨부하는 경우
				toggleDimOnAttach(true);

				// 서버에 요청할 url
				const sepLetter = (0 < parent.gg_url.indexOf("<sep>"))? "<sep>" : "&lt;sep&gt;";
				const requestUrls = parent.gg_url.split(sepLetter)
							.map(url => "/ezEmail/mailExport.do?url=" + url); // 이미 encodeURIComponent 되어 있음.

				// DataTransfer를 사용하여 <input type="file">에 파일 설정
				const dataTransfer = await getDataTransfer(requestUrls);
				document.getElementById("file").files = dataTransfer.files;

				// 첨부 로직 실행.
				filechange();
				document.getElementById('progdiv').style.display = "none"; // progress 대신 dim
				if (!isfileup) toggleDimOnAttach(false);
			}

			// dim / undim
			function toggleDimOnAttach(isDim) {
				if (parent.mailPanel) parent.mailPanel.style.display = isDim? "" : "none";
				if (parent.loadingLayer) parent.loadingLayer.style.display = isDim? "" : "none";
				if (parent.messageInSending) parent.messageInSending.style.display = isDim? "none" : "";
				if (parent.messageInAttaching) parent.messageInAttaching.style.display = isDim? "" : "none";
			}

		    var AttatchReturnValue;
		    function uploadComplete(evt) {
		        document.getElementById('prog_bar').style.width = "0%";
		        document.getElementById('prog_num').innerHTML = "0";
		        document.getElementById('progdiv').style.display = "none";
		        toggleDimOnAttach(false);
		        
		        if (xhr.responseText == "OVERFLOW") {
		            alert(strLang167);
		        } else if (xhr.responseText == "NODATA") {
		            alert(strLang223);
		        } else {
		            var tempxmldom = loadXMLString(xhr.responseText);
		            var filecnt = document.getElementById("filelist").childNodes.length;
		            var j = 0;
		            
		            for (var i = 0; i < filecnt - 1; i++) {
		                var filelistnode = document.getElementById("filelist").childNodes[i + 1];
		
		                if (GetAttribute(filelistnode, "VALUE") == "" || GetAttribute(filelistnode, "VALUE") == null) {
		                    var node = SelectNodes(tempxmldom, "ROOT/NODES/NODE")[j];
		                    filelistnode.setAttribute("VALUE", SelectSingleNodeValue(node, "PUPLOADSN"));
		                    filelistnode.setAttribute("NEWFILE", "Y");
		                    j++;
		                }
		            }

					var updateResultNodes = SelectNodes(tempxmldom, "ROOT/NODES/NODE");

					// 업로드 실패 시 size 변수에서 빼기
					for (var i = 0; i < updateResultNodes.length; i++) {
						var node = updateResultNodes[i];

						if ("true" != node.querySelector("RESULTUPLOADA").textContent) {
							var errorFileSize = Number(node.querySelector("FILESIZE").textContent);
							if ("Y" == node.querySelector("PBIGFILEUPLOAD").textContent) {
								bigfilesize -= errorFileSize;
							} else {
								filesize -= errorFileSize;
							}
						}
					}

		            AttatchReturnValue = null;
		            AttatchReturnValue = window.parent.FileUpdateAfter(xhr.responseText);
		            FileUpdataAfterComplete();
		        }
		        
		        isfileup = false;
		    }
		
		    function uploadComplete2(evt) {
		        document.getElementById('prog_bar').style.width = "0%";
		        document.getElementById('prog_num').innerHTML = "0";
		        document.getElementById('progdiv').style.display = "none";
		        toggleDimOnAttach(false);
		
		        if (xhr2.responseText == "OVERFLOW") {
		            alert(strLang167);
		        } else if (xhr2.responseText == "OVERSIZE") {
					
		        	if ("${ userInfo.lang }" == "2") {
		                alert(strLang168 + window.parent.totBigSizeAttachMBSize + strLang169);
					} else {
		                alert(strLang168 + window.parent.totBigSizeAttachMBSize + "MB" + strLang169);
					}
		        
		        } else if (xhr2.responseText == "NODATA") {
		            alert(strLang223);
		        } else {
		            var tempxmldom = loadXMLString(xhr2.responseText);
		            var filecnt = document.getElementById("filelist").childNodes.length;
		            var j = 0;
		          
		            for (var i = 0; i < filecnt - 1; i++) {
		                var filelistnode = document.getElementById("filelist").childNodes[i + 1];
		
		                if (GetAttribute(filelistnode, "VALUE") == "" || GetAttribute(filelistnode, "VALUE") == null) {
		                    var node = SelectNodes(tempxmldom, "ROOT/NODES/NODE")[j];
		                    filelistnode.setAttribute("VALUE", SelectSingleNodeValue(node, "PUPLOADSN"));
		                    filelistnode.setAttribute("NEWFILE", "Y");
		                    j++;
		                }
		            }
		            
		            AttatchReturnValue = null;
		            AttatchReturnValue = window.parent.FileUpdateAfter(xhr2.responseText);
		            FileUpdataAfterComplete();
		        }
		        
		        isfileup = false;
		    }
		    
		    function FileUpdataAfterComplete() {
		        var filelist = SelectNodes(AttatchReturnValue, "DATA/ROW");
		        
		        for (var i = 0; i < filelist.length; i++) {
		            var FilePath = SelectSingleNodeValue(filelist[i], "FILEPATH");
		            var FileURL = SelectSingleNodeValue(filelist[i], "URL");
		            var FileBIG = SelectSingleNodeValue(filelist[i], "BIG");
		            var FileITEMID = SelectSingleNodeValue(filelist[i], "ITEMID");
		            var g_url = SelectSingleNodeValue(filelist[i], "UID");
		            
		            SetAttachItemLink(FilePath, FileURL, FileBIG, FileITEMID, g_url);
		        }
		        
		        AttatchReturnValue = null;
		    }

		    /* 2018-04-25 김유진 - 첨부 파일 업로드 시 필요한 prop를 set해주는 메서드 수정 */
		    function SetAttachItemLink(filepath, url, big, itemid, g_url) {
		        var TRRows = document.getElementById("lstAttachLink").getElementsByTagName("TR");
		        
		        for (var i = 0; i < TRRows.length; i++) {
		            
		        	if (GetAttribute(TRRows.item(i), "value") != null && GetAttribute(TRRows.item(i), "value") != "") {
		               
		        		if (GetAttribute(TRRows.item(i), "value") == filepath) {
		                	var index = parseInt(TRRows.item(i).getAttribute("_fileindex"));
		                	
		                    currUid = g_url;
		                    TRRows.item(i).childNodes.item(1).setAttribute("_href", url);
		                    TRRows.item(i).setAttribute("_uid", g_url);
		                    TRRows.item(i).setAttribute("_big", big);
		                    TRRows.item(i).setAttribute("draggable", true);
		                    TRRows.item(i).setAttribute("_itemid", itemid);
		                    TRRows.item(i).childNodes.item(1).setAttribute("style", "cursor:pointer");
		                    
		                    TRRows.item(i).childNodes.item(1).onclick = function () { 
			                    var partIdx = $(this).closest('tr').attr('_fileindex');
		                    	var msgId = $(this).closest('tr').attr('_uid');
		                    	var isBig = $(this).closest('tr').attr('_big');
		                    	
		                    	FileDownload(this, parseInt(partIdx), parseInt(msgId), isBig); 
		                    };
		                }
		        		
		        		if (GetAttribute(TRRows.item(i), "_uid") < g_url) {
		        			TRRows.item(i).setAttribute("_uid", g_url);
		        		}
		            }
		        }
		        
		    }
		 	
		    /* 2018-04-25 김유진 - 첨부 파일삭제시 file 업로드 임시보관함 uid 업데이트 메서드 */
		    function updateItemUid() {
		    	var TRRows = document.getElementById("lstAttachLink").getElementsByTagName("TR");
		    	var nextUid = parseInt(currUid) + 1;
		    	
		    	for (var i = 0; i < TRRows.length; i++) {
		    		
		    		if (GetAttribute(TRRows.item(i), "value") != null && GetAttribute(TRRows.item(i), "value") != "") {
			    		
		    			if (GetAttribute(TRRows.item(i), "_uid") == currUid) {
		        			TRRows.item(i).setAttribute("_uid", nextUid);
		        		} 
		    		}
		    	}

		    	currUid = nextUid;
		    }
		    
		    /* 2018-04-25 김유진 - 일반첨부시 해당 index와 uid를 받아서 download href를 넘겨주는 메서드 */
		    function FileDownload(obj, partIdx, msgId, isBig) {
		    	
		    	if (isBig == "N") {
		    		var href = GetAttribute(obj, "_href");
		    		href = href + "&index=" + partIdx + "&uid=" + msgId;
		    		window.parent.DownloadAttach(href);
		    	} else {
			    	window.parent.DownloadAttach(GetAttribute(obj, "_href"));
		    	}
		    	
		    }
		    
		    function uploadFailed(evt) {
		        isfileup = false;
		        alert(strLangKMS06);
		    }
		
		    function uploadCanceled(evt) {
		        isfileup = false;
		        alert(strLangKMS07);
		    }
		
		    function defaultenter(evt) {
		        evt.dataTransfer.dropEffect = "none";
		        evt.stopPropagation();
		        evt.preventDefault();
		    }

            function inputZipFilePassword() {
                if (document.querySelectorAll('#filelist tr[newfile="Y"]').length > 0) {
                    alert("<spring:message code='ezEmail.zipEncryptedFile.007' />");
                    document.getElementById('ConfirmZipFilePassword').focus();
                    return;
                } else {
                    parent.DivPopUpShow(330, 170, "/ezEmail/inputZipFilePassword.do");
                }
            }

            function checkZipFileEncryprUploadCheck() {
                zipPassword = sessionStorage.getItem("zipPassword");
                
                if (!zipPassword && "${useAutoZipEnc}" == "YES") {
                    alert("<spring:message code='ezEmail.zipEncryptedFile.006' />"); 
                    inputZipFilePassword();
                    return false;
                }

                return true;
            }

		    function btnfileup() {
                if (checkZipFileEncryprUploadCheck()) {
                    isbigyn = "N";
                    document.getElementById("file").value = "";
                    document.getElementById("file").click();
                }
		    }
		
		    function btnfileup_big() {
                if (checkZipFileEncryprUploadCheck()) {
                    isbigyn = "Y";
                    document.getElementById("file").click();
                }
		    }
		
		    function filechange(e) {
		        var stt = onDrop();
		        
		        if (stt == 1) {
		        	onDrop();
		        }
		        
		    }
		    
		    function btnfiledel(type) {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        var isDeleted = false;
		        
		    	for (var i = 1; i < filecnt; i++) {
		    		var filelistTable = document.getElementById("filelist");
	                var elementTR = document.getElementById("filelist").childNodes[i];
		    		var elementTRIsChecked = elementTR.childNodes[0].childNodes[0].checked;
		    		var elementTrIsBig = GetAttribute(elementTR, "_big");
		    	
					if ((type=="big" && elementTrIsBig=="Y") || (type!="big" && elementTRIsChecked)) {
					    isDeleted = true;

			    		var pAttachDelSN;
		                var pAttachDelFileName;
		                var is_newfile;
		                var pNewNodeName = "";
		                var Rtnval;
		                var length = $('#filelist tr').length;
		                
		                window.parent.DelAttachFileAtList(elementTR);
		                
		                var delfilesize = GetAttribute(elementTR, "_filesize");
		               
		                if (delfilesize == "") {
		                    delfilesize = 0;
		                }
	 
		                if (elementTrIsBig == "Y") {
		                    bigfilesize -= delfilesize;
		                    bigfile.splice(i - 1, 1);
		                } else {
		                    filesize -= delfilesize;
		                    file.splice(i - 1, 1);
		                    
		                    for (var j = 0; j < length; j++) {
			                	
		                    	if (i <= j && $('#filelist tr:eq(' + j + ')').is('[_fileindex]'))  {
				                	$('#filelist tr:eq(' + j + ')').attr("_fileindex",$('#filelist tr:eq(' + j + ')').attr("_fileindex") - 1);
			                	}
			                } 
		                    
		                 	// 2018-04-25 김유진 - 첨부 파일에 클릭하면 다운로드 하는 기능 수정
			                updateItemUid();
		                }                
		                
		                document.getElementById("filelist").removeChild(elementTR);
		                i--;
		                filecnt--;
		            }
		        }

		        if (!isDeleted) {
		            alert(strLang90);
		        }
		        
		        showAttachInnerNotice();
                document.getElementById("checkboxall").checked = false;
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
		
		    function fileupload() {
		    	isfileup = true;
		    	
		        var fd = new FormData();
		        var fdSize = 0;
		        var plainText_BigAttChk = false;
		        var bodyTypeIsPlain = window.parent.document.getElementById("bodyType").value != "1" ? false : true;
		
		        for (var i = 0; i < filelist.length; i++) {
					var fnl = filelist[i].name.length;
					var fbig = filelist[i].isBig;
		        	// 2024.05.03 한슬기 : 글자수 제한으로 업로드에 실패해도 실패한 파일의 용량은 계산되는 문제로 인해 글자수 체크 위치 변경(onDrop() 내부로 위치 변경) 
// 		        	if (fnl > attachFileNameMaxLength) {	
// 		        		alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
// 		        		isfileup = false;
// 		        		return;
// 		        	} else if (bodyTypeIsPlain && fbig == "Y") {
// 		        		plainText_BigAttChk = true;
// 		        		continue;
// 		        	} else {
		        	if (bodyTypeIsPlain && fbig == "Y") {	
		        		plainText_BigAttChk = true;
		        		continue;
		        	} else {
		        		fdSize++;
		        		fd.append("fileToUpload", filelist[i]);
		        	}		            
		        }
		        
		        if (plainText_BigAttChk) {
		        	var msgTmp = "<spring:message code='ezEmail.ksa12' />"
		        	msgTmp = msgTmp.replace("%s", window.parent.BigSizeAttachMBSize);
		        	alert(msgTmp);
		        }
		
		        var newid = window.parent.g_newid;
		        fd.append("maxsize", window.parent.FtotSizeAttachSize);
		        //fd.append("cnt", filelist.length);
		        fd.append("cnt", fdSize);
		        fd.append("newid", newid);
		        fd.append("bigmaxsize", window.parent.FtotBigSizeAttachSize);
		        fd.append("changesize", window.parent.FBigSizeAttachSize);
		        fd.append("txtName", window.parent.filedate);
		        fd.append("endDay", window.parent.BigSizeMailAttachDelDay);
		        fd.append("zipPassword", sessionStorage.getItem("zipPassword"));

		        xhr.upload.addEventListener("progress", uploadProgress, false);
		        xhr.addEventListener("load", uploadComplete, false);
		        xhr.addEventListener("error", uploadFailed, false);
		        xhr.addEventListener("abort", uploadCanceled, false);
		        xhr.open("POST", "/ezEmail/mailInterUploadXCK.do?STATUS=" + window.parent.filedate + "&isbigyn=" + isbigyn);
		        xhr.send(fd);
		        document.getElementById('progdiv').style.display = "inline-block";
		    }
            
		    var xhr2 = new XMLHttpRequest();
		    function fileupload2(fileXml,purl) {
		    	isfileup = true;
				
		        if (!filesizecheck(fileXml)) {
		            isfileup = false;

		            return;
		        }
		        
		        var objNode;
		        
		        createNodeAndInsertText(fileXml, objNode, "MAXSIZE", window.parent.FtotSizeAttachSize);
		        createNodeAndInsertText(fileXml, objNode, "CNT", window.parent.bigtrue);
		        createNodeAndInsertText(fileXml, objNode, "NEWID", window.parent.g_newid);
		        createNodeAndInsertText(fileXml, objNode, "BIGMAXSIZE", window.parent.FtotBigSizeAttachSize);
		        createNodeAndInsertText(fileXml, objNode, "CHANGESIZE", window.parent.FBigSizeAttachSize);
		        createNodeAndInsertText(fileXml, objNode, "TXTNAME", window.parent.filedate);
		        createNodeAndInsertText(fileXml, objNode, "ENDDAY", window.parent.BigSizeMailAttachDelDay);
		        
		        var targetUrl_sb="";
		        if (purl) {
		        	targetUrl_sb=purl;
				} else {
					targetUrl_sb = "/ezEmail/mailInterUploadCopyXCK.do";
				}
		        xhr2.open("POST", targetUrl_sb+"?STATUS=" + window.parent.filedate + "&isbigyn=" + isbigyn, false);
		        xhr2.send(fileXml);
		        isbigyn = "N";
		        
		        if (xhr2.status >= 200 && xhr2.status < 300) {
		        	uploadComplete2();
		        } else {
		        	uploadFailed();
		        }
		    }
		    
		    function filesizecheck(fileXml) {
				var attachFileXml = fileXml;
		        var tempfilesize = 0;
		        var tempbigfilesize = 0;
		        var bigFileCheck = false;
		        var newBigAttachCount = 0;

		        for (var i = 0; i < attachFileXml.getElementsByTagName("ROW").length; i++) {
		            var filelistsize = Number(getNodeText(attachFileXml.getElementsByTagName("DATA6").item(i)));

		            if (filelistsize / 1024 / 1024 > window.parent.BigSizeAttachMBSize) {
		                bigFileCheck = true;
		                tempbigfilesize += filelistsize;
		            } else {
		                tempfilesize += filelistsize;
		            }
		            newBigAttachCount++;
		        }
		        
		        if (isbigyn == "Y") {
		            bigFileCheck = true;
		        }
		        
		        if (bigFileCheck == true && window.parent.FtotBigSizeAttachSize == 0) {
		        	
		        	if("${ userInfo.lang }" == "2") {
		                alert(strLangKMS02 + window.parent.totSizeAttachMBSize + strLang76);
		        	} else {
		                alert(strLangKMS02 + window.parent.totSizeAttachMBSize + "MB" + strLang76);
		        	}
		        	
		        	return false;
		        }
		        
		        if ((filesize + tempfilesize) / 1024 / 1024 > window.parent.totSizeAttachMBSize) {
		        	
		        	if (window.parent.FtotBigSizeAttachSize == 0) {
		        		
		        		if ("${ userInfo.lang }" == "2") {
			                alert(strLangKMS02 + window.parent.totSizeAttachMBSize + strLang76);
		        		} else {
			                alert(strLangKMS02 + window.parent.totSizeAttachMBSize + "MB" + strLang76);
		        		}
		        		return false;
		        	} else {
		                bigFileCheck = true;
		        	}
		        }

		        if ((bigfilesize + tempbigfilesize) / 1024 / 1024 > window.parent.totBigSizeAttachMBSize) {
		        	
		            if ("${ userInfo.lang }" == "2") {
		                alert(strLang168 + window.parent.totBigSizeAttachMBSize + strLang169);
		            } else {
		                alert(strLang168 + window.parent.totBigSizeAttachMBSize + "MB" + strLang169);
		            }

		            return false;
		        }

		        if (bigFileCheck) {
		        	if(!bigFileAttachCountCheck(newBigAttachCount)) {
		        		return;
		        	}
		        	var bigFileAttachChk = confirm(strLang77 +window.parent.BigSizeAttachMBSize + "MB" + strLang78 + window.parent._pBigAttachDownloadDay + strLang79);
		        	
		            if (!bigFileAttachChk) {
		                return false;
		            }
		            
		            isbigyn = "Y";
		        }
		        
		        filesize += tempfilesize;
		        bigfilesize += tempbigfilesize;

		        return true;
		    }
		    
			function setAttachSortable() {
				$("#lstAttachLink").multipleSortable({
	              items : "tr[value]",
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
			
			function moveAttachFileOrder(fileList) {
				var fileIdxArr = [].map.call(fileList, function(fileNode){
					return fileNode.getAttribute("_fileindex");
				});
				
				for (var i = 0; i < fileIdxArr.length; i++) {
				    // 첨부파일 순서가 변경된 경우에는 순서 변경하기 위한 컨트롤러 URL을 호출한다.
				    if (i != fileIdxArr[i]) {
						saveAttachFileOrder(fileIdxArr);
						break;
				    }
				}
			}
			
			function saveAttachFileOrder(fileIdxArr){
				 var itemid = window.parent.g_url;
				 $.ajax({
					type : 'post',
					url : "/ezEmail/saveAttachFileOrder.do",
					dataType : "json",
					async : false,
					data : {
						fileIdxArr : fileIdxArr,
						shareId : shareId,
						itemid : itemid
					},
					success : function (result){
// 						console.log("saveAttachFileOrder : " + result);
						window.parent.g_url = result;
						resetFileIdx();
					}
				 });
			}
			
			function resetFileIdx() {
				var fileList = document.querySelectorAll("#filelist tr[_fileindex]");
				for (var i = 0; i < fileList.length; i++) {
					fileList[i].setAttribute("_fileindex", i);
				}
			}
		    
			function arrayEqualCheck(arr1, arr2) {
				if(arr1.length != arr2.length) {
					return false;
				}
				
				for (var i = 0; i < arr1.length; i++) {
					if(arr1[i] != arr2[i]) {
						return false;
					}
				}
				return true;
			}
			
			function getAttachInnerNoticeObject() {
				var pElem = document.createElement("p");
				pElem.id = "attachInnerNotice";
				pElem.className = "attachInnerNotice_p_on";
				
				var spanElem = document.createElement("span");
				spanElem.innerText = strLangHDP04;
				spanElem.className = "attachInnerNotice_span";
				
				pElem.appendChild(spanElem);
				
				return pElem; 
			}
			
			function showAttachInnerNotice() {
		        var fileCnt = document.querySelectorAll("#filelist tr[value]").length;
                 if (fileCnt > 0) {
		        	 document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_off";
		        } else {
		        	 document.getElementById("attachInnerNotice").className = "attachInnerNotice_p_on";
		        }
			}
			
		    function bigFileAttachCountCheck(newBigAttachCount) {
		        var BigSizeAttachLimitCount = window.parent.BigSizeAttachLimitCount;
		        var curBigAttachCount = document.querySelectorAll("#filelist tr[_big='Y']").length;
		        if (BigSizeAttachLimitCount > 0 && curBigAttachCount + newBigAttachCount > BigSizeAttachLimitCount) {
		        	alert(strLangHDP03.replace("{0}", BigSizeAttachLimitCount));
		        	return false;
		        }
		        return true;
		    }
		
		    function filePicker() {
                if (checkZipFileEncryprUploadCheck()) {
                    isbigyn = (isbigyn === 'Y') ? 'N' : isbigyn;
                    window.parent.filePickerOpen();
                }
		    }

            window.addEventListener("beforeunload", () => {
                sessionStorage.removeItem("zipPassword");
            });
		</script>
	</head>  
    <body ondragover ="defaultenter(event)" ondragenter ="defaultenter(event)" style="overflow:hidden">   
        <div style="width:845px;white-space:nowrap;display:inline-block">
            <span style="float:left;">
                <a class="imgbtn imgbck" onclick="btnfileup()"><span><spring:message code='ezEmail.t677' /></span></a>
                <a class="imgbtn imgbck" id="btnBigFileUpload" onclick="btnfileup_big()"><span><spring:message code='ezEmail.t663' /></span></a>
                <a class="imgbtn imgbck" onclick="btnfiledel()"><span><spring:message code='ezEmail.t678' /></span></a>   
                <c:if test="${useWebfolder == 'YES'}">
                	<a class="imgbtn imgbck" onclick="filePicker()"><span><spring:message code='ezWebFolder.pyy02' /></span></a>
                </c:if>
                <c:if test="${'YES'.equalsIgnoreCase(useAutoZipEnc)}">
                    <a class="imgbtn imgbck" onclick="inputZipFilePassword()"><span><spring:message code='ezEmail.zipEncryptedFile.002' /></span></a>
                </c:if>
            </span>
            <div id="progdiv" class="progarea" style="display:none">
             	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
             </div>
        </div>
        <div id="lstAttachLink" class="ui-sortable" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
        </div>
        <input id="file" type="file" onchange="filechange(event);return false;" multiple="multiple" style="width:1px;height:1px;display:none;" />
        <input type="hidden" value="업로드" onclick ="fileupload()" />
  </body>
</html>
