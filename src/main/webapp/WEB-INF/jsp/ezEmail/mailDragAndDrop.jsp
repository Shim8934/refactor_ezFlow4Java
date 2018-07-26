 <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<style>
			#lstAttachLink {
				height: 117px;
				border: 1px solid #d2d2d2;
			}
		</style>
		<script type="text/javascript">
		    var lstAttachLink = document.getElementById("lstAttachLink");
		    var attachFileNameMaxLength = Number("${attachFileNameMaxLength}");
		    var status = 0; // 일반-대용량 첨부파일 구분 상태값  
		    
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
		    
		    function onDrop(evt) {
		       
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
		        
		        if (status == 1) {
		        	isbigyn = "Y";
		        	status = 0;
		        }
		        
		        for (var i = 0; i < filelist.length; i++) {
		            
		        	if (filelist[i].size / 1024 / 1024 > window.parent.BigSizeAttachMBSize || isbigyn == "Y") {
		                bigFileCheck = true;
		                bigfile[filecnt + i] = filelist[i];
		                tempbigfilesize += filelist[i].size;
		            } else {
		                file[filecnt + i] = filelist[i];
		                tempfilesize += filelist[i].size;
		            }
		        }
				
		        if (isbigyn == "Y") {
		            bigFileCheck = true;
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
		        
		        if (bigFileCheck && alertCnt < 2) {
		            alert(strLangKMS01+window.parent.BigSizeAttachMBSize + "MB" + strLang78 + window.parent._pBigAttachDownloadDay + strLang26 + strLang79);
		            alertCnt++;
		        }
		        
		        if ((filesize + tempfilesize) / 1024 / 1024 > window.parent.totSizeAttachMBSize && isbigyn == "N") {
		           
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
		            
		            status = 1;
		            return status;
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
		        objTh2.style.width = "67%";
		        setNodeText(objTh2, "<spring:message code='ezEmail.t725' />");
		        objTr.appendChild(objTh2);
		
		        var objTh3 = document.createElement("TH");
		        setNodeText(objTh3, "<spring:message code='ezEmail.t726' />");
		        objTh3.style.width = "13%";
		        objTr.appendChild(objTh3);
		        
		        var objTh4 = document.createElement("TH");
		        setNodeText(objTh4, "<spring:message code='ezEmail.sjw04' />");
		        objTh4.style.width = "20%";
		        objTr.appendChild(objTh4);
		
		        oTable.appendChild(objTr);
		        document.getElementById("lstAttachLink").appendChild(oTable);
		        parent.DragObjectComplet();
		        
		        if (window.parent.totBigSizeAttachMBSize == 0) {
					$("body div:first span:first a:nth-child(2)").css("display","none");
		        }
		        
		    }
		    
		    var AttatchReturnValue;
		    function uploadComplete(evt) {
		        document.getElementById('prog_bar').style.width = "0%";
		        document.getElementById('prog_num').innerHTML = "0";
		        document.getElementById('progdiv').style.display = "none";
		        
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
		                    TRRows.item(i).setAttribute("_itemid", itemid);
		                    TRRows.item(i).childNodes.item(1).setAttribute("style", "cursor:pointer");
		                    
		                    TRRows.item(i).childNodes.item(1).onclick = function () { 
			                    var partIdx = $(this).closest('tr').attr('_fileindex');
		                    	var msgId = $(this).closest('tr').attr('_uid');
		                    	var isBig = $(this).closest('tr').attr('_big');
		                    	
		                    	var firstIdx = window.parent.multipartFirstIdx;
		                    	partIdx = parseInt(partIdx) + parseInt(firstIdx);
	                    		
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
		
		    function btnfileup() {
		        isbigyn = "N";
		        document.getElementById("file").click();
		    }
		
		    function btnfileup_big() {
		        isbigyn = "Y";
		        document.getElementById("file").click();
		    }
		
		    function filechange(e) {
		        var stt = onDrop();
		        
		        if (stt == 1) {
		        	onDrop();
		        }
		        
		    }
		
		    function btnfiledel() {
		        var filecnt = document.getElementById("filelist").childNodes.length;
		        
		        for (var i = 1; i < filecnt; i++) {
		            
		        	if (document.getElementById("filelist").childNodes[i].childNodes[0].childNodes[0].checked == true) {
		            	var pAttachDelSN;
		                var pAttachDelFileName;
		                var is_newfile;
		                var pNewNodeName = "";
		                var Rtnval;
		                var length = $('#filelist tr').length;
		                
		                window.parent.DelAttachFileAtList(document.getElementById("filelist").childNodes[i]);
		                
		                var delfilesize = GetAttribute(document.getElementById("filelist").childNodes[i], "_filesize");
		               
		                if (delfilesize == "") {
		                    delfilesize = 0;
		                }

		                if (GetAttribute(document.getElementById("filelist").childNodes[i], "_big") == "Y") {
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
		                
		                document.getElementById("filelist").removeChild(document.getElementById("filelist").childNodes[i]);
		                i--;
		                filecnt--;
		            }
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
		
		    function fileupload() {
		    	isfileup = true;
		    	
		        var fd = new FormData();
		
		        for (var i = 0; i < filelist.length; i++) {
					var fnl = filelist[i].name.length;
		        	
		        	if (fnl > attachFileNameMaxLength) {
		        		alert("<spring:message code='main.jjh08' />" + attachFileNameMaxLength + "<spring:message code='main.lhm03' />");
		        		isfileup = false;
		        		return;
		        	} else {
		        		fd.append("fileToUpload", filelist[i]);
		        	}		            
		        }
		
		        var newid = window.parent.g_newid;
		        fd.append("maxsize", window.parent.FtotSizeAttachSize);
		        fd.append("cnt", filelist.length);
		        fd.append("newid", newid);
		        fd.append("bigmaxsize", window.parent.FtotBigSizeAttachSize);
		        fd.append("changesize", window.parent.FBigSizeAttachSize);
		        fd.append("txtName", window.parent.filedate);
		        fd.append("endDay", window.parent.BigSizeMailAttachDelDay);

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

		        for (var i = 0; i < attachFileXml.getElementsByTagName("ROW").length; i++) {
		            var filelistsize = Number(getNodeText(attachFileXml.getElementsByTagName("DATA6").item(i)));

		            if (filelistsize / 1024 / 1024 > window.parent.BigSizeAttachMBSize) {
		                bigFileCheck = true;
		                tempbigfilesize += filelistsize;
		            } else {
		                tempfilesize += filelistsize;
		            }
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

		        if (bigFileCheck) {
		            alert(window.parent.BigSizeAttachMBSize + "MB" + strLang78 + window.parent._pBigAttachDownloadDay + strLang26 + strLang79);
		        }
		        
		        if ((filesize + tempfilesize) / 1024 / 1024 > window.parent.totSizeAttachMBSize) {
		        	
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

		        	return false;
		        }

		        if ((bigfilesize + tempbigfilesize) / 1024 / 1024 > window.parent.totBigSizeAttachMBSize) {
		        	
		            if ("${ userInfo.lang }" == "2") {
		                alert(strLang168 + window.parent.totBigSizeAttachMBSize + strLang169);
		            } else {
		                alert(strLang168 + window.parent.totBigSizeAttachMBSize + "MB" + strLang169);
		            }

		            return false;
		        }

		        filesize += tempfilesize;
		        bigfilesize += tempbigfilesize;

		        return true;
		    }
		    
		</script>
	</head>  
    <body ondragover ="defaultenter(event)" ondragenter ="defaultenter(event)" style="overflow:hidden">   
        <div style="width:845px;white-space:nowrap;display:inline-block">
            <span style="float:left;">
                <a class="imgbtn imgbck" onclick="btnfileup()"><span><spring:message code='ezEmail.t677' /></span></a>
                <a class="imgbtn imgbck" onclick="btnfileup_big()"><span><spring:message code='ezEmail.t663' /></span></a>
                <a class="imgbtn imgbck" onclick="btnfiledel()"><span><spring:message code='ezEmail.t678' /></span></a>   
            </span>
            <div id="progdiv" class="progarea" style="display:none">
             	<P class="prog_bar"><span id="prog_bar" style="width:0%"></span></P> <span class="prog_num"><strong id ="prog_num">0</strong>%</span>
             </div>
        </div>
        <div id="lstAttachLink" ondragenter="onDragEnter(event)"  ondragover="onDragOver(event)" ondrop="onDrop(event)" style="overflow:auto;">
        </div>
        <input id="file" type="file" onchange="filechange(event)" multiple="multiple" style="width:1px;height:1px;display:none;" />
        <input type="hidden" value="업로드" onclick ="fileupload()" />
  </body>
</html>
