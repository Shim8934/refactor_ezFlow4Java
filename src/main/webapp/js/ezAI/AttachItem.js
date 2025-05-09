var SendData = {};
var MainAppPath = `${getCoreAppPath()}/ezAi/Main`;
var RemoteAppPath = `${getCoreAppPath()}/ezAi/Remote`;
var PopupAppPath = `${getCoreAppPath()}/ezAi/Popup`;
var AdminAppPath = `${getCoreAppPath()}/ezAi/Admin`;
var AdminRemoteAppPath = `${getCoreAppPath()}/ezAi/AdminRemote`;

var g_progresswin;
var g_fileList;
var pAttachListXml = "";

function replace(str, s, d) {
    var i = 0;
    i = str.indexOf(s);

    while (i > -1) {
        str = str.substr(0, i) + d + str.substr(i + s.length, str.length);
        i = str.indexOf(s);
    }
    return str;
}

function AttachFileInfo(resultXML) {
    var xml = loadXMLString(resultXML);
    var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
    var i = 0;
    try {
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) == "Error") {
                var pAlertContent = "" + "파일 업로드 중 오류가 발생했습니다." + "";  // 파일 업로드 중 오류가 발생했습니다.
                Alert_Message(pAlertContent, null, "");

                return;
            }
            else if (getNodeText(GetChildNodes(nodes[i])[1]) == "FileOverFlowMsg") {

                getNodeText(GetChildNodes(nodes[i])[2]) = "";
            }
        }
        AddAttachFileInfoXmlParsing(resultXML);
    }
    catch (ErrMsg) {
        Alert_Message(ErrMsg.description, null, "");
    }
}

function ReplaceEncodedFileName(str) {
    var result = "";

    if (str) {
        result = RevertFileName(str).replace(/&amp;lt;/gi, "<").replace(/&amp;gt;/gi, ">").replace(/&amp;/gi, "&");
    }

    return result;
}

//2020.12.28 yn :: 게시판 퍼블리쉬 적용 - 메일과 동일하게 소스 변경
function AppendFileAttachInfo(ret) {
    try {
        if (typeof (ret) == "string")
            pAttachListXml = loadXMLString(ret);
        else
            pAttachListXml = ret;

        var objAttachNodes = SelectNodes(pAttachListXml, "LISTVIEWDATA/ROWS/ROW");

        var strAttach = "";
        strPreViewAttach = "";
        rep = /'/g;

        var j = 690;
        dadiframe.document.getElementById("filelist").innerHTML = "";

        for (i = 0; i < objAttachNodes.length; i++) {
            var rownode = SelectSingleNode(objAttachNodes[i], "CELL");

            var fileNM = getNodeText(SelectSingleNode(rownode, "DATA1"));
            var ServerFilePath = getNodeText(SelectSingleNode(rownode, "DATA2"));
            var fileExt = getNodeText(SelectSingleNode(rownode, "DATA3"));
            var ServerFileName = ServerFilePath.replace(/^.*[\\/]/, '');
            var is_newfile = ServerFilePath !== ServerFileName ? "N" : "Y";
            var fileSize = getNodeText(SelectSingleNode(rownode, "DATA6"));
            ServerFileName = ReplaceText(ServerFileName, "'", "&apos;")

            if (is_newfile != "DEL") {
                var objTr = document.createElement("TR");
                objTr.setAttribute("DATA2", ServerFilePath);
                objTr.setAttribute("DATA1", fileNM);
                objTr.setAttribute("NEWFILE", is_newfile);
                
                var objTd = document.createElement("TD");
                objTd.setAttribute("align", "center");
                var attIcon = document.createElement("SPAN");
                // 확장자에 따라 class 아이콘 변경하는 부분 추가 필요
                attIcon.className = "fileIcon " + GetExtension(fileExt);

                objTd.appendChild(attIcon);
                objTr.appendChild(objTd);

                var objTd2 = document.createElement("TD");
                objTd2.style.cursor = "pointer";

                var displayFileNameSpan = document.createElement("SPAN");
                displayFileNameSpan.style.display = "block";
                displayFileNameSpan.style.textOverflow = "ellipsis";
                displayFileNameSpan.style.overflow = "hidden";

                var displayFileName = getNodeText(SelectSingleNode(rownode, "VALUE"));
                displayFileNameSpan.innerText = ReplaceEncodedFileName(displayFileName);
                objTd2.appendChild(displayFileNameSpan);

                objTr.appendChild(objTd2);

                var objTd3 = document.createElement("TD");
                objTd3.style.textAlign = "center";

                if (fileSize / 1024 / 1024 > 1) {
                    fileSize = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
                }
                else {
                    fileSize = (Math.floor(parseFloat(fileSize / 1024 * 10)) / 10).toFixed(1) + "KB";
                }

                objTd3.innerText = fileSize;
                objTr.appendChild(objTd3);

                var objTd4 = document.createElement("TD");
                objTd4.style.textAlign = "center";

                var attDel = document.createElement("SPAN");
                attDel.className = "newSubicon newSubicon015";
                objTd4.setAttribute("onclick", "btnfiledel(this);");

                objTd4.appendChild(attDel);
                objTr.appendChild(objTd4);

                // setNodeText(objTd3, fileSize);
                // objTr.appendChild(objTd3);

                dadiframe.document.getElementById("filelist").appendChild(objTr);
            }
        }

        if (dadiframe.document.getElementById("filelist").childNodes.length > 0)
            dadiframe.document.getElementById("nofile").style.display = "none";
    }
    catch (e) { console.error(e); Alert_Message("AppendFileAttachInfo :: " + e.description, null, ""); }
}

function DelAttachFileAtList(pNewNodeName) {
    try {
        var Idoc;
        var Iform;
        var pDelAttachRow = pNewNodeName.split("*)[_-");
        var pDelCount = pDelAttachRow.length;
        var objXML = createXmlDom();
        objXML = pAttachListXml;
        var objAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW");
        var totalcnt = objAttachNodes.length;
        for (var i = 0; i < objAttachNodes.length; i++) {
            for (var k = 0; k < pDelCount - 1; k++) {
                var realFileNM = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[2]);
                var DelFileSize = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[6]);
                var objSelectedNode = objAttachNodes[i];
                var is_newfile = getNodeText(GetChildNodes(GetChildNodes(objAttachNodes[i])[0])[5]);

                var tempName = pDelAttachRow[k]
                tempName = ReplaceText(tempName, "&apos;", "'");

                if (tempName == realFileNM) {
                    GetChildNodes(GetChildNodes(objXML)[0])[1].removeChild(objSelectedNode);
                    pAttachListXml = objXML;
                }
            }
        }
    } catch (ErrMsg) {
        Alert_Message(ErrMsg.description, null, "");
    }
}

function AddAttachFileInfoXmlParsing(resultXML) {

    try {

        var xml = loadXMLString(resultXML);
        var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
        var pstrXML = "";
        var re = /&/g;
        var objXML = createXmlDom();
        var Rtnxml = createXmlDom();
        var filenm = "";

        pstrXML += "<LISTVIEWDATA><HEADERS>";
        pstrXML += "<HEADER><NAME>" + "첨부파일" + "명" + "</NAME><WIDTH>100</WIDTH></HEADER>";
        pstrXML += "<HEADER><NAME>" + "파일" + "크기" + "</NAME><WIDTH>50</WIDTH></HEADER>";
        pstrXML += "</HEADERS><ROWS>";
        
        for (i = 0; i < nodes.length; i++) {
            if (getNodeText(GetChildNodes(nodes[i])[1]) != "denied") {
                //pstrXML += "<ROW><CELL><VALUE><![CDATA[" + unescape(getNodeText(GetChildNodes(nodes[i])[2])) + "]]></VALUE>";
                //pstrXML += "<DATA1><![CDATA[" + unescape(getNodeText(GetChildNodes(nodes[i])[2])) + "]]></DATA1>";
                //pstrXML += "<DATA2><![CDATA[" + unescape(getNodeText(GetChildNodes(nodes[i])[0])) + "]]></DATA2>";
                //pstrXML += "<DATA3><![CDATA[" + unescape(getNodeText(GetChildNodes(nodes[i])[5])) + "]]></DATA3>";
                //pstrXML += "<DATA4><![CDATA[" + unescape(getNodeText(GetChildNodes(nodes[i])[4])) + "]]></DATA4>";
                //pstrXML += "<DATA5>Y</DATA5>";
                //pstrXML += "<DATA6><![CDATA[" + getNodeText(GetChildNodes(nodes[i])[3]) + "]]></DATA6>";

                pstrXML += "<ROW><CELL><VALUE><![CDATA[" + unescape(getNodeText(nodes[i].querySelector("PFILENAME"))) + "]]></VALUE>";
                pstrXML += "<DATA1><![CDATA[" + unescape(getNodeText(nodes[i].querySelector("PFILENAME"))) + "]]></DATA1>";
                pstrXML += "<DATA2><![CDATA[" + unescape(getNodeText(nodes[i].querySelector("PUPLOADSN"))) + "]]></DATA2>";
                pstrXML += "<DATA3><![CDATA[" + unescape(getNodeText(nodes[i].querySelector("EXTENSION"))) + "]]></DATA3>";
                pstrXML += "<DATA4><![CDATA[" + unescape(getNodeText(nodes[i].querySelector("FILELOCATION"))) + "]]></DATA4>";
                pstrXML += "<DATA5>Y</DATA5>";
                pstrXML += "<DATA6><![CDATA[" + unescape(getNodeText(nodes[i].querySelector("FILESIZE"))) + "]]></DATA6>";

                let attachID = nodes[i].querySelector('ATTACHID');
                pstrXML += "<ATTACHID><![CDATA[" + (attachID ? getNodeText(attachID) : '') + "]]></ATTACHID>";

                // 2023-03-22 BJH : GUID, FOLDERID 추가
                let guid = nodes[i].querySelector('GUID');
                pstrXML += "<GUID><![CDATA[" + (guid ? getNodeText(guid) : '') + "]]></GUID>";

                let folderid = nodes[i].querySelector('FOLDERID');
                pstrXML += "<FOLDERID><![CDATA[" + (folderid ? getNodeText(folderid) : '') + "]]></FOLDERID>";

                let folderName = nodes[i].querySelector('FOLDERNAME');
                pstrXML += "<FOLDERNAME><![CDATA[" + (folderName ? getNodeText(folderName) : '') + "]]></FOLDERNAME>";

                pstrXML += "</CELL><CELL>";
                pstrXML += "<VALUE><![CDATA[" + getNodeText(GetChildNodes(nodes[i])[3]) + " Bytes" + "]]></VALUE>";
                pstrXML += "</CELL></ROW>";
            }
        }
        pstrXML += "</ROWS></LISTVIEWDATA>";
        objXML = loadXMLString(pstrXML);
        
        if (document.getElementById('mode').value == "PHOTO") {
            pAttachListXml = objXML;
        }
        else {
            if (pAttachListXml == "") {
                pAttachListXml = objXML;
            }
            else {
                if (typeof (pAttachListXml) == "string")
                    Rtnxml = loadXMLString(pAttachListXml);
                else
                    Rtnxml = pAttachListXml;

                var ROwCnt = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW").length;
                for (var i = 0; i < ROwCnt; i++) {
                    var objNewAttachNodes = SelectNodes(objXML, "LISTVIEWDATA/ROWS/ROW")[0];
                    GetChildNodes(GetChildNodes(Rtnxml)[0])[1].appendChild(objNewAttachNodes);
                }

                pAttachListXml = Rtnxml;
            }
        }
        AppendFileAttachInfo(pAttachListXml);
        return;

    } catch (ErrMsg) {

        Alert_Message(ErrMsg.description, null, "");
    }
}
function DeleteFromFileList(pFailedFileInfo) {
    let tbody = dadiframe.document.querySelector("#filelist")
    let trElements = tbody.getElementsByTagName('tr');
    pFailedFileInfo.forEach(x => {
        const failAttachId = x.attachId + x.extension;

        // 모든 tr 요소를 순회하며, data2 attribute 값이 FAIL의 attachId와 일치하는 tr을 찾습니다.
        for (let tr of trElements) {
            const data2 = tr.getAttribute('data2');

            if (data2 === failAttachId) {
                // onclick 속성을 가진 요소를 찾습니다.
                const btnFileDel = Array.from(tr.getElementsByTagName('td')).find(td =>
                    td.getAttribute('onclick') && td.getAttribute('onclick').includes('btnfiledel')
                );
                

                // btnFileDel이 존재하면 클릭 이벤트를 실행합니다.
                if (btnFileDel) {
                    btnFileDel.click(); // 클릭을 실행합니다.
                }
            }
        }
    });
}

// 확장자에 맞는 클래스 이름을 반환
function GetExtension(fileExt) {
    switch (fileExt.toLowerCase().replace(".", "")) {
        case 'zip':
            return 'icon_zip';
        case 'pdf':
            return 'icon_pdf';
        case 'jpg':
        case 'jpeg':
            return 'icon_jpg';
        case 'txt':
            return 'icon_txt';
        case 'mht':
            return 'icon_mht';
        case 'doc':
        case 'docx':
            return 'icon_doc';
        case 'xls':
        case 'xlsx':
            return 'icon_xls';
        case 'eml':
            return 'icon_eml';
        case 'hwp':
            return 'icon_hwp';
        case 'ppt':
        case 'pptx':
            return 'icon_ppt';
        default:
            return 'icon_default'; // 기본 아이콘
    }
}