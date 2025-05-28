var g_fileList;
var g_progresswin;
var pAttachListXml="";
function replace(str,s,d)
{
	var i=0;
	i = str.indexOf(s);

	while(i > -1)
	{
		str = str.substr(0,i) + d + str.substr(i+s.length,str.length);
		i = str.indexOf(s);
	}
	return str;
}

function status_change(fileinfo){
	try {
		g_progresswin.document.Script.fileinfo_change(fileinfo);
	} catch(e) {console.log(e);}
}

function btn_ImgDel_onclick() {
    try {
        var j = 0;
        var multi_cnt = document.singlecheck.elements.length;
        for (var i = 0; i < multi_cnt; i++) {
            var ele = document.singlecheck.elements[i];
            if (ele.name == "fileImgSelect" && ele.checked)
                j++;
        }
        if (j) {
            var pInformationContent = "" + strLang14 + "";
            var Ans = confirm(pInformationContent);

            if (Ans) {
                var pAttachDelSN;
                var pAttachDelFileName;
                var is_newfile;
                var pNewNodeName = "";
                var Rtnval;
                for (var k = 0; k < multi_cnt; k++) {
                    var mod_ele = document.singlecheck.elements[k];

                    if (mod_ele.name == "fileImgSelect" && mod_ele.checked) {
                        pAttachDelFileName = mod_ele.value;
                        is_newfile = mod_ele.newfile;
                        pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";

                        Rtnval = "TRUE";
                    }
                }

                if (Rtnval == "TRUE") {

                    DelAttachFileAtList(pNewNodeName);
                    var Rtnxml = new ActiveXObject("Microsoft.XMLDOM");
                    Rtnxml.loadXML(pAttachImgListXml);
                    var objImgAttachNodes = Rtnxml.selectNodes("LISTVIEWDATA/ROWS/ROW");
                    var pTotalRowsLen = objImgAttachNodes.length;
                    if (pTotalRowsLen == 0) {
                        ImgAppendFileAttachInfo("");
                    }
                    else {
                        var pstrXML = APRAttachXMLParsing();
                        ImgAppendFileAttachInfo(pstrXML);
                    }
                }
                else {
                    var pAlertContent = "" + strLang16 + "";
                }
            }
        }
    } catch (ErrMsg) { alert(ErrMsg.description); }
}

function btn_AttachDel_onclick() {
    try {
        var multi_cnt = document.getElementsByName("fileSelect").length;
        var j = 0;
        for (var i = 0; i < multi_cnt; i++) {
            if (document.getElementsByName("fileSelect")[i].checked) {
                j++;
            }
        }
        if (j) {
            var pInformationContent = strLangLHM05;
            var Ans = confirm(pInformationContent);
            if (Ans) {
                var pAttachDelSN;
                var pAttachDelFileName;
                var is_newfile;
                var pNewNodeName = "";
                var Rtnval;
                for (var k = 0; k < multi_cnt; k++) {

                    if (document.getElementsByName("fileSelect")[k].checked) {
                        pAttachDelFileName = document.getElementsByName("fileSelect")[k].value;
                        is_newfile = GetAttribute(document.getElementsByName("fileSelect")[k], "newfile");
                        pNewNodeName = pNewNodeName + pAttachDelFileName + "*)[_-";
                        Rtnval = "TRUE";
                    }
                }
                if (Rtnval == "TRUE") {
                    DelAttachFileAtList(pNewNodeName);
                    AppendFileAttachInfo(pAttachListXml);
                }
                else {
                    var pAlertContent = "" + strLang16 + "";
                    alert(pAlertContent);
                }
            }
        }
    }
    catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function btn_AttachSaveSure_onclick() {
    try {
        window.close();
    } catch (ErrMsg) { alert(ErrMsg.description); }
}

function AttachFileInfo(resultXML) {
    var xml = loadXMLString(resultXML);
    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
    var i = 0;
    try {
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) == "Error") {
                var pAlertContent = "" + strLang18 + "";
                alert(pAlertContent);
                return;
            }
            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "FileOverFlowMsg") {
                //getNodeText(GetChildNodes(nodes[i])[2]) = "";
            	setNodeText(GetChildNodes(nodes[i])[2], "");
            }
        }
        AddAttachFileInfoXmlParsing(resultXML);

    }
    catch (ErrMsg) {
        alert(ErrMsg.description);
    }
}

function ATTACHonSelChange_onclick() {
    try {
    } catch (ErrMsg) { alert(ErrMsg.description); }
}

function chkFileNMFilter(cur_ExtName) {
    var SpeCha = new Array(".", "" + strLang19 + "", ",", "&");
    var StrSpeCha = "";
    var plength = SpeCha.length;
    var i;
    var chkflag = true;

    for (i = 0; i < plength; i++) {
        StrSpeCha = StrSpeCha + SpeCha[i] + " ";
    }
    StrSpeCha = StrSpeCha + "\\ / : *  ?  \" <> ";

    var s = cur_ExtName.lastIndexOf("\\");
    var e = cur_ExtName.lastIndexOf(".");

    if (s == -1)
        cur_ExtName = ""
    else
        cur_ExtName = cur_ExtName.substring(s + 1, e)

    for (i = 0; i < plength; i++) {
        alert(cur_ExtName.indexOf(SpeCha[i]));

        if (cur_ExtName.indexOf(SpeCha[i]) > 0) {
            chkflag = false;
            break;
        }
    }
    if (!chkflag) {
        alert("" + strLang20 + "" + StrSpeCha);
    }
    return chkflag;
}

function AppendFileAttachInfo(ret, reuseAttach) {
    try {
        if (typeof (ret) == "string")
            pAttachListXml = loadXMLString(ret);
        else
            pAttachListXml = loadXMLString(getXmlString(ret));

        var objAttachNodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");
        var strAttach = "";
        strPreViewAttach = "";
        rep = /'/g;
        var fileIndex = $("#dadiframe").contents().find('#filelist tr[_big=N]').length;
        
        for (i = 0; i < objAttachNodes.length; i++) {
            var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[1]);
            var ServerFile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);
            var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);
            var fileSize = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]);
            var is_big = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[7]);
            realFileNM = ReplaceText(realFileNM, "'", "&apos;")
            
            if (is_newfile != "DEL") {
                
            	if (AttachFlag) {
                    
            		if (CrossYN()) {
                        objTr = document.createElement("TR");
                        objTr.setAttribute("VALUE", ServerFile);
                        objTr.setAttribute("NEWFILE", getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]));
                        objTr.setAttribute("_big", is_big);
                        objTr.setAttribute("_itemid", ServerFile);
                        objTr.setAttribute("_filesize", fileSize);
                        
                        if (is_big == "N") {
                        	objTr.setAttribute("_fileIndex", fileIndex);
                        	fileIndex++;
                        }
                        
                        var objTd = document.createElement("TD");
                        objTd.style.textAlign = "center";

                        var input = document.createElement("input");
                        input.type = "checkbox";
                        input.name = "fileSelect";

                        objTd.appendChild(input);
                        objTr.appendChild(objTd);

                        var objTd2 = document.createElement("TD");
                        
                        if(is_big == "Y") {
                        	objTd2.innerHTML = replaceAll(getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]), "&", "&amp;");
                        	objTd2.innerHTML += "&nbsp;" + "<font style='color:blue'>[" + strLangLHM10 + "]</font>";
                        } else {
                        	objTd2.innerHTML = replaceAll(getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]), "&", "&amp;");
                        	console.log("AppendFileAttachInfo CrossYN true.");
                        	
                        	/* 20180510 김윤진 - 수정창에서 파일클릭시 다운로드링크 적용 */
                        	objTd2.onclick = function () { 
                        		var partIdx = $(this).closest('tr').attr('_fileindex');
                        		var filename = $(this).closest('tr').attr('_itemid');
                        		var isBig = $(this).closest('tr').attr('_big');
                        		var msgId = g_url;
                        		var reqUrl = "/ezEmail/downloadAttachInWriter.do?" 
		                            			+ "mode=Attach"
		                            			+ "&folderPath=" + encodeURIComponent(folderPath)
		                            			+ "&filename=" + encodeURIComponent(filename);
                        		
                        		if (typeof(shareId) != "undefined" && shareId != "") {
                        			reqUrl += "&shareId=" + encodeURIComponent(shareId);
						    	}
                        		
                        		$(this).attr('_href', reqUrl);
	                    	
 		                    	dadiframe.FileDownload(this, parseInt(partIdx), parseInt(msgId), isBig); 
 		                    };
                        	
                        }
                        
                        objTr.appendChild(objTd2);

                        if (fileSize != strLang116) {
                            if (reuseAttach == true) {
                                dadiframe.filesize += parseInt(parseFloat(fileSize));
                            }
                            
                        	if (fileSize / 1024 / 1024 > 1) {
                                fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                            }
                            else if (fileSize / 1024 > 1) {
                                fileSize = parseInt(fileSize / 1024) + "KB";
                            }
                            else if (fileSize.indexOf("B") > -1) {
                                fileSize = parseInt(fileSize);
                            }
                            else {
                                fileSize = parseInt(fileSize) + "B";
                            }
                        }

                        var objTd3 = document.createElement("TD");
                        
                        if (CrossYN()) {
                        	objTd3.textContent = fileSize;
                        } else {
                        	objTd3.innerText = fileSize;
                        }
                        
                        objTr.appendChild(objTd3);
                        
                        if (totBigSizeAttachMBSize > 0) {
                        	// 대용량 다운로드 기한 표시
                            var objTd4 = document.createElement("TD");
                            
                            if(is_big == "Y") {
                            	if(CrossYN()) {
                            		objTd4.textContent = _pBigAttachDownloadPeriod;
                            	} else {
                            		objTd4.innerText = _pBigAttachDownloadPeriod;
                            	}
                            }

                            appendAttachChangeButton(objTd4, is_big === "Y");
                            
                            objTr.appendChild(objTd4);
                        }

                        dadiframe.document.getElementById("filelist").appendChild(objTr);
                    } else {
                        EzHTTPTrans.InsertFileList(ServerFile, ServerFile, "N", ServerFile, fileSize);
                    }
                
            	} else {
                    
                	if (getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]) == "Y") {
                        
                		if (CrossYN()) {
                            objTr = document.createElement("TR");
                            objTr.setAttribute("VALUE", ServerFile);
                            objTr.setAttribute("NEWFILE", getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]));
                            objTr.setAttribute("_big", is_big);
                            objTr.setAttribute("_itemid", ServerFile);
                            objTr.setAttribute("_filesize", fileSize);
                            
                            if (is_big == "N") {
                            	objTr.setAttribute("_fileIndex", fileIndex);
                            	fileIndex++;
                            }
                            
                            var objTd = document.createElement("TD");
                            objTd.style.textAlign = "center";

                            var input = document.createElement("input");
                            input.type = "checkbox";
                            input.name = "fileSelect";

                            objTd.appendChild(input);
                            objTr.appendChild(objTd);

                            var objTd2 = document.createElement("TD");
                            
                            objTd2.setAttribute('style', 'cursor:pointer');
                            objTd2.setAttribute("_href", "");

                            
                            if(is_big == "Y") {
                            	objTd2.innerHTML = "<span style='display:block; text-overflow:ellipsis; overflow:hidden;'>" + replaceAll(getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]), "&", "&amp;") + "&nbsp; <font style='color:blue'>[" + strLangLHM10 + "]</font></span>";
                            } else {
                            	objTd2.innerHTML = "<span style='display:block; text-overflow:ellipsis; overflow:hidden;'>" + replaceAll(getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[0]), "&", "&amp;") + "</span>";
                            	
                            	/* 20180510 김윤진 - 수정창에서 파일클릭시 다운로드링크 적용 */
                            	objTd2.onclick = function () { 
                            		var partIdx = $(this).closest('tr').attr('_fileindex');
                            		var filename = $(this).closest('tr').attr('_itemid');
                            		var isBig = $(this).closest('tr').attr('_big');
                            		var msgId = g_url;
                            		var reqUrl = "/ezEmail/downloadAttachInWriter.do?" 
			                            			+ "mode=Attach"
			                            			+ "&folderPath=" + encodeURIComponent(folderPath)
			                            			+ "&filename=" + encodeURIComponent(filename);
                            		
                            		if (typeof(shareId) != "undefined" && shareId != "") {
                            			reqUrl += "&shareId=" + encodeURIComponent(shareId);
    						    	}
                            		
                            		$(this).attr('_href', reqUrl);
                            		
     		                    	dadiframe.FileDownload(this, parseInt(partIdx), parseInt(msgId), isBig); 
     		                    };
     		                    
                            }
                            
                            objTr.appendChild(objTd2);

                            if (fileSize != strLang116) {
                                if (reuseAttach == true) {
                                    dadiframe.filesize += parseInt(parseFloat(fileSize));
                                }    
                                
                            	if (fileSize / 1024 / 1024 > 1) {
                                    fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                                }
                                else if (fileSize / 1024 > 1) {
                                    fileSize = parseInt(fileSize / 1024) + "KB";
                                }
                                else if (fileSize.indexOf("B") > -1) {
                                    fileSize = parseInt(fileSize);
                                }
                                else {
                                    fileSize = parseInt(fileSize) + "B";
                                }
                            }

                            var objTd3 = document.createElement("TD");
                            
                            if (CrossYN()) {
                            	objTd3.textContent = fileSize;
                            } else {
                            	objTd3.innerText = fileSize;
                            }
                            
                            objTr.appendChild(objTd3);
                            
                            if (totBigSizeAttachMBSize > 0) {
                            	// 대용량 다운로드 기한 표시
                                var objTd4 = document.createElement("TD");
                                
                                if(is_big == "Y") {
                                	if(CrossYN()) {
                                		objTd4.textContent = _pBigAttachDownloadPeriod;
                                	} else {
                                		objTd4.innerText = _pBigAttachDownloadPeriod;
                                	}
                                }

                                appendAttachChangeButton(objTd4, is_big === "Y");

                                objTr.appendChild(objTd4);
                            }

                            dadiframe.document.getElementById("filelist").appendChild(objTr);
                        } else {
                            EzHTTPTrans.InsertFileList(ServerFile, ServerFile, "N", ServerFile, fileSize);
                        }
                    }
                }
            }
        }
        
        AttachFlag = false;
        dadiframe.window.showAttachInnerNotice();
    }
    catch (e) { alert("AppendFileAttachInfo :: " + e.description); }
}

function appendAttachChangeButton(parentElement, isBig) {
    const changeButton = parentElement.appendChild(document.createElement("a"));
    changeButton.classList.add("imgbtn", "imgbck", "changebtn");
    changeButton.style.verticalAlign = "middle";
    if (isBig) {
        changeButton.style.setProperty("margin", "-2px 0px 0px 10px", "important");
    }
    const changeButtonText = changeButton.appendChild(document.createElement("span"));
    changeButtonText.textContent = strLangChangeButton;
    // 드래그 무력화
    changeButton.addEventListener("mousedown", e => {
        e.preventDefault();
        e.stopPropagation();
    });
    changeButton.addEventListener("click", event => {
        const attachDocument = event.currentTarget.ownerDocument;
        const tr = event.composedPath().filter(elem => elem.tagName === "TR" && elem.hasAttribute("value"))[0];
        const bigFlag = tr.getAttribute("_big");
        const fileSize = Number(tr.getAttribute("_filesize"));
        const itemUid = tr.getAttribute("value");
        const normalAttachTrArray = Array.from(attachDocument.querySelectorAll("#filelist tr[_big='N']"));

        // 일반 첨부에서 대용량으로 전환
        if (bigFlag === "N") {
            const bigAttachTrArray = Array.from(attachDocument.querySelectorAll("#filelist tr[_big='Y']"));

            // 대용량 첨부 제한 개수 넘는지 확인
            if (BigSizeAttachLimitCount > 0 && BigSizeAttachLimitCount <= bigAttachTrArray.length) {
                alert(strLangHDP03.replace("{0}", BigSizeAttachLimitCount));
                return;
            }

            const totalBigBytes = bigAttachTrArray.map(el => Number(el.getAttribute("_filesize")))
                .reduce((a, b) => a + b, 0);

            // 대용량 첨부 용량 넘는지 확인
            if (totBigSizeAttachMBSize < (totalBigBytes + fileSize) / 1024 / 1024) {
                alert(strLangChangeLimit);
                return;
            }

            $.ajax({
                type: "POST",
                url: "/ezEmail/convertAttachNormalToBig.do",
                contentType: "application/json",
                dataType: "json",
                async: false,
                data: JSON.stringify({
                    statusUid: filedate,
                    itemUid: itemUid,
                    shareId: shareId,
                    mailUid: g_url,
                    fileName: tr.getAttribute("_itemid"),
                    fileIndex: tr.getAttribute("_fileindex")
                }),
                success: function (result) {
                    if (result.status === "error") {
                        alert(strLang217 + "\n" + JSON.stringify(result));
                        return;
                    }

                    bigtrue = bigtrue + 1;

                    let scheme = attachDocument.location.protocol + "//" + attachDocument.location.hostname;

                    if (attachDocument.location.port !== "80") {
                        scheme += ":" + attachDocument.location.port;
                    }

                    const newItemId = result.data.itemUid;
                    tr.setAttribute("value", newItemId);

                    const downloadUrl = scheme + "/ezEmail/downloadAttachCommon.do?"
                        + "fileid=" + encodeURIComponent(newItemId)
                        + "&filedate=" + encodeURIComponent(result.data.bigDateDir)
                        + "&tid=" + tid;
                    const itemId = result.data.bigDateDir + "/" + newItemId;

                    dadiframe.SetAttachItemLink(newItemId, downloadUrl, "Y", itemId, result.data.uid);

                    const fileNameSpan = tr.querySelector("td:nth-child(2) > span") || tr.querySelector("td:nth-child(2)");
                    const downloadPeriodTd = tr.querySelector("td:nth-child(4)");

                    tr.setAttribute("_big", "Y");
                    const deleteFileIndex = Number(tr.getAttribute("_fileindex"));
                    normalAttachTrArray.forEach(tr => {
                        const trFileIndex = Number(tr.getAttribute("_fileindex"));
                        if (trFileIndex > deleteFileIndex) {
                            tr.setAttribute("_fileindex", trFileIndex - 1);
                        }
                    });
                    tr.removeAttribute("_fileindex");
                    fileNameSpan.innerHTML = fileNameSpan.textContent.trim() + "&nbsp;&nbsp;";
                    const fontElem = fileNameSpan.appendChild(attachDocument.createElement("font"));
                    fontElem.style.color = "blue";
                    fontElem.innerHTML = `[${strLangLHM10}]`;
                    const changeButton = downloadPeriodTd.removeChild(downloadPeriodTd.querySelector("a"));
                    downloadPeriodTd.textContent = _pBigAttachDownloadPeriod;
                    downloadPeriodTd.appendChild(changeButton);
                    changeButton.style.setProperty("margin", "-2px 0px 0px 10px", "important");

                    const fileSize = Number(tr.getAttribute("_filesize"));
                    dadiframe.bigfilesize += fileSize;
                    dadiframe.filesize -= fileSize;

                    g_url = result.data.uid;
                },
                error: function (e) {
                    alert(strLang217 + "\n" + e.description);
                }
            });
        } else {
            // 대용량 첨부에서 일반 첨부로 전환
            const totalNormalBytes = normalAttachTrArray
                .map(el => Number(el.getAttribute("_filesize")))
                .reduce((a, b) => a + b, 0);

            // 일반 첨부 용량 넘는지 확인
            if (BigSizeAttachMBSize < (totalNormalBytes + fileSize) / 1024 / 1024) {
                alert(strLangChangeLimit);
                return;
            }

            $.ajax({
                type: "POST",
                url: "/ezEmail/convertAttachBigToNormal.do",
                contentType: "application/json",
                dataType: "json",
                async: false,
                data: JSON.stringify({
                    statusUid: filedate,
                    itemUid: itemUid,
                    shareId: shareId,
                    mailUid: g_url,
                    itemId: tr.getAttribute("_itemid")
                }),
                success: function (result) {
                    if (result.status === "error") {
                        alert(strLang217 + "\n" + JSON.stringify(result));
                        return;
                    }

                    // 일반파일 첨부시
                    let downloadUrl = "/ezEmail/downloadAttachInWriter.do?"
                        + "mode=Attach"
                        + "&folderPath=" + encodeURIComponent(folderPath)
                        + "&filename=" + encodeURIComponent(result.data.fileName);
                    const itemId = result.data.fileName;

                    if (shareId) {
                        downloadUrl += "&shareId=" + encodeURIComponent(shareId);
                    }

                    dadiframe.SetAttachItemLink(itemUid, downloadUrl, "N", itemId, result.data.uid);

                    const fileNameSpan = tr.querySelector("td:nth-child(2) > span") || tr.querySelector("td:nth-child(2)");
                    const downloadPeriodTd = tr.querySelector("td:nth-child(4)");

                    tr.setAttribute("_big", "N");
                    fileNameSpan.removeChild(fileNameSpan.querySelector("font"));
                    const changeButton = downloadPeriodTd.removeChild(downloadPeriodTd.querySelector("a"));
                    downloadPeriodTd.textContent = "";
                    downloadPeriodTd.appendChild(changeButton);
                    changeButton.style.margin = "";

                    // API 에서 맨 마지막에 추가하니까 제일 마지막 index로 설정
                    tr.setAttribute("_fileindex", normalAttachTrArray.length);

                    const fileSize = Number(tr.getAttribute("_filesize"));
                    dadiframe.bigfilesize -= fileSize;
                    dadiframe.filesize += fileSize;

                    g_url = result.data.uid;
                },
                error: function () {
                    alert(strLang217 + "\n" + e.description);
                }
            });
        }
    });
}

function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
}

function AttachFileList() {
    try {
        var strRet = "";
        var filepath = "";
        if (getXmlString(pAttachListXml) == "") {
            return "";
        }

        var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");
        for (i = 0; i < xmldomNodes.length; i++) {
            filepath = getNodeText(xmldomNodes[i]);
            if (filepath.indexOf(pBoardID) != -1) {
                strRet += filepath + ";";
            } else {
                strRet += pBoardID + "/UploadFile/" + getNodeText(xmldomNodes[i]) + ";"
            }
        }
    }
    catch (e) {
        console.log(e);
    }
    xmldom_attachlist = null;
    return strRet;
}

function btn_PhotoAttachAdd_onclick() {
    document.getElementById('mode').value = "PHOTO";
    document.form.file1.click();
}


function show_progress_photo(fileinfo) {
    beginAttachAdd_Photo();
}


function beginAttachAdd_Photo() {
    document.all.EzHTTPTrans.AddUploadFile("", "");
    for (var i = 0; i < g_fileList.length - 1; i++) {
        try {
            document.all.EzHTTPTrans.AddFilename(encodeURIComponent(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1)));
            document.all.EzHTTPTrans.AddUploadFile(g_fileList[i], "N");
        }
        catch (e) {
            if (e.number == -2147352567)
                alert("" + strLang12 + "");
            else
                alert(g_fileList[i] + " " + strLang13 + "" + "\n\n" + e.number + " - " + e.description);

            return;
        }
    }

    var RemotePath = document.location.protocol + "//" + document.location.hostname + "/myoffice/ezBoardSTD/interASP/Item_AttachFile_Photo.aspx";
    var nCount = document.all.EzHTTPTrans.StartUpload(RemotePath, "/Upload_BoardSTD", pBoardID, "", "");
    for (var i = 0; i < nCount; i++) {
        var attachFileResult = document.all.EzHTTPTrans.GetReturn(i);
        var attachFilePath = attachFileResult.substr(0, attachFileResult.indexOf("/"));
        var attachFilename = attachFileResult.substr(attachFileResult.indexOf("/") + 1);
        attachFilename = attachFilename.substr(0, attachFilename.lastIndexOf("/"));

        if (attachFilename.substr(0, 2) != "OK") {
            try {
                txtPhotoFile.value = "";
            }
            catch (e) {
                console.log(e);
            }

            alert(g_fileList[i] + " " + strLang24 + "");
            txtPhotoFile.value = "";
            return;
        }
        else {
            var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
            ezUtil.UseUTF8 = true;
            fileSize = ezUtil.GetFileSize(g_fileList[i]);
            txtPhotoFile.value = ezUtil.ExtractFileName(g_fileList[i]);	//2006.10.20 " + strLang25 + "
            ezUtil = null;

            var Result = attachFilename.substr(3, attachFilename.length - 3)

            AttachFileInfo(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1), Result.substr(Result.lastIndexOf("/") + 1), fileSize + "Bytes", Result, fileSize, attachFilePath)
        }
    }
}

function AttachFileList_Photo() {
    var strRet = "";
    var filepath = "";
    if (typeof (pAttachListXml) == "string")
        pAttachListXml = loadXMLString(pAttachListXml);
    else
        pAttachListXml = loadXMLString(getXmlString(pAttachListXml));

    if (getXmlString(pAttachListXml) == "") {
        return "";
    }
    var xmldomNodes = GetElementsByTagName(pAttachListXml, "DATA2");

    for (i = 0; i < xmldomNodes.length; i++) {
        filepath = getNodeText(xmldomNodes[i]);
        if (filepath.indexOf(pBoardID) != -1) {
            strRet += filepath + ";";
        } else {
            strRet += pBoardID + "/UploadFile/" + getNodeText(xmldomNodes[i]) + ";";
        }
    }
    return strRet;
}

function replaceAll(str, searchStr, replaceStr) {
	return str.split(searchStr).join(replaceStr);
}