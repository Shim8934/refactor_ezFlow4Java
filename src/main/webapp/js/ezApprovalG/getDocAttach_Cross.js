var bAttachProcess = false;
function AttachProcess() {
    bAttachProcess = true;
}


function DocFileAttach_Click(obj) {
    var regData = "";

    if (document.all)
        regData = navigator.systemLanguage;
    else if (document.layers)
        regData = navigator.systemLanguage;
    else if (document.getElementById) {
        if (navigator && navigator.systemLanguage)
            regData = navigator.systemLanguage.substr(0, 2)
        else {
            if (typeof clientInformation != 'undefined')
                regData = clientInformation.systemLanguage;
            else
                regData = "";
        }
    }
    else {
        if (typeof clientInformation != 'undefined') {
            if (clientInformation && clientInformation.systemLanguage)
                regData = clientInformation.systemLanguage;
        }
    }
    var filename = obj.getAttribute("AttachFilename");
    var filepath = obj.getAttribute("AttachFilepath");
    var openLocation = "/myoffice/Common/DownloadAttach.aspx?filename=" + filename + "&filepath=" + filepath + "&regData=" + regData;
    ifrmDownload.location.href = openLocation;
}

function trim(str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function setAttachInfo(tempDocID, INGFlag, attachTag) {
    attachTag.innerHTML = "";
    var xmlhttp = createXMLHttpRequest();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "NODE", tempDocID);
    createNodeAndInsertText(xmlpara, objNode, "NODE", INGFlag);

    xmlhttp.open("POST", "/myoffice/ezApprovalG/aspx/getTotalAttachInfo.aspx", false);
    xmlhttp.send(xmlpara);

    var xmlRtn = SelectNodes(xmlhttp.responseXML, "LISTVIEWDATA/ROWS/ROW");

    if (xmlRtn.length > 0) {
        var strAttach = " &nbsp ";
        var rep = /'/g
        for (i = 0; i < xmlRtn.length; i++) {
            var Row = xmlRtn[i];
            var Cell = GetChildNodes(Row);

            if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "File" || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "파일") {
                var IncodFileNM = encodeURIComponent(SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA1"));
                var filename = encodeURIComponent(getNodeText(GetChildNodes(xmlRtn[i])[1]));
                var filepath = IncodFileNM.replace(rep, "&#39;");

                var strTarget = "target='_blank'";
                var fileImage = "";
                var strFileExt = filename.substr(filename.lastIndexOf('.')).toLowerCase();

                if (strFileExt == ".xls" || strFileExt == ".doc" || strFileExt == ".ppt" ||
                   strFileExt == ".eml" || strFileExt == ".pdf" || strFileExt == ".hwp" ||
                   strFileExt == ".ppt" || strFileExt == ".docx" || strFileExt == ".pptx" ||
                   strFileExt == ".xlsx" || strFileExt == ".rtf") {
                    strTarget = "target=''";
                }

                if (strFileExt.indexOf(".jpg") != -1 || strFileExt.indexOf(".jpeg") != -1 || strFileExt.indexOf(".bmp") != -1 || strFileExt.indexOf(".gif") != -1 || strFileExt.indexOf(".png") != -1 || strFileExt.indexOf(".tif") != -1 || strFileExt.indexOf(".tiff") != -1)
                    fileImage = "/images/image.png";
                else if (strFileExt.indexOf(".doc") != -1 || strFileExt.indexOf(".docx") != -1)
                    fileImage = "/images/doc.png";
                else if (strFileExt.indexOf(".xls") != -1 || strFileExt.indexOf(".xlsx") != -1)
                    fileImage = "/images/xls.png";
                else if (strFileExt.indexOf(".ppt") != -1 || strFileExt.indexOf(".pptx") != -1 || strFileExt.indexOf(".pps") != -1 || strFileExt.indexOf(".ppsx") != -1)
                    fileImage = "/images/ppt.png";
                else if (strFileExt.indexOf(".txt") != -1)
                    fileImage = "/images/txt.png";
                else if (strFileExt.indexOf(".zip") != -1)
                    fileImage = "/images/zip.png";
                else if (strFileExt.indexOf(".pdf") != -1)
                    fileImage = "/images/pdf.png";
                else if (strFileExt.indexOf(".ecm") != -1)
                    fileImage = "/images/ecm.png";
                else
                    fileImage = "/images/attach-small.gif";

                if (CrossYN() || NonActiveX == "YES")
                    strTarget = "target=\''";

                var protocol = window.location.protocol;
                var serverName = window.location.hostname;

                strAttach = strAttach + "<a href='" + protocol + "//" + serverName + "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=APPROVALG&DOCID=" + tempDocID + "&DOCSTATUS=" + INGFlag + "&DOCATTACHSN=" + SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA2") + "&filepath=" + filepath + "'" + " onclick='AttachProcess()'>";
                //strAttach = strAttach + "<a href='/myoffice/Common/downloadattach.aspx?filename=" + filename + "&filepath=" + filepath + "' " + strTarget + "' onclick='AttachProcess()'>";

                strAttach = strAttach + "<IMG SRC='" + fileImage + "' border='0'>";
                strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; ";
            }
            else {
                var FilePath = trim_Cross(SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA1"));
                var FileExt = trim_Cross(FilePath.substr(FilePath.length - 3, FilePath.length).toLowerCase());
                var FileDocID = trim_Cross(FilePath.substr(FilePath.length - 24, 20).toLowerCase());
                var FileName = trim_Cross(getNodeText(GetChildNodes(xmlRtn[i])[1]));
                var OpenLocation = "";
                if (FileDocID == "" && FilePath == "") {
                    strAttach = strAttach + "<a style='cursor:pointer' onclick=\"OpenAttachAlertUI('" + strLang260 + "')\">";
                    strAttach = strAttach + "<IMG SRC='/Images/attach-small.gif' border='0'>";
                    strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; "
                }             
                else if (FileExt == "hwp") {
                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx?DocID=" + escapenew(FileDocID) +
						"&DocHref=" + escapenew(FilePath) + "&formID=&orgDocid=";
                    strAttach = strAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                    strAttach = strAttach + "<IMG SRC='/Images/attach-small.gif' border='0'>";
                    strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; "
                }
                else {
                    if (CrossYN() || NonActiveX == "YES") {
                        openLocation = "/myoffice/ezApprovalG/formContainer/contDocView_Cross.aspx";
                    }
                    else {
                        if (pUse_Editor == "") {
                            openLocation = "/myoffice/ezApprovalG/formContainer/contDocView.aspx";
                        }
                        else {
                            openLocation = "/myoffice/ezApprovalG/formContainer/contDocView.aspx";
                        }
                    }
                    openLocation = openLocation + "?DocID=" + escapenew(FileDocID) + "&DocHref=" + escapenew(FilePath) + "&formID=&orgDocid=";
                    strAttach = strAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                    strAttach = strAttach + "<IMG SRC='/Images/attach-small.gif' border='0'>";
                    strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; "
                }
            }

        }
        attachTag.innerHTML = strAttach + "<iframe frameborder=\"0\" id=\"ifrmDownload\" name=\"ifrmDownload\" src=\"about:blank\" width=\"0\" height=\"0\"></iframe>";
        try {
            pHasAttachYN = "Y";
        } catch (e) { }
    }
    else {
        try {
            pHasAttachYN = "N";
        } catch (e) { }
    }
}

function openAttachView(wfileLocation, wName, wWeigth, wHeigth) {
    try {
        var heigth = window.screen.availHeight;
        var width = window.screen.availWidth;
        var left = 0;
        var top = 0;

        if (window.screen.width > 800) {
            var pleftpos;
            pleftpos = parseInt(width) - wWeigth;
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - pleftpos;
            left = (pleftpos / 2) + 30;
            top = 30;
        }
        else {
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - 10;
        }
        window.open(wfileLocation, wName, "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
    } catch (e) {
        alert("openAttachView :: " + e.description);
    }
}

// START
var ezapralert_cross_dialogArguments = new Array();
function OpenAttachAlertUI(pAlertContent, CompleteFunction) {
    var parameter = pAlertContent;
    var url = "/ezApprovalG/ezAprAlert.do";

    if (CrossYN() || NonActiveX == "YES") {
        ezapralert_cross_dialogArguments[0] = parameter;
        if (CompleteFunction != undefined)
            ezapralert_cross_dialogArguments[1] = CompleteFunction;
        else
            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
        DivPopUpShow(330, 205, url);
    }
}
function OpenAlertUI_Complete() {
    DivPopUpHidden();
}
// END

