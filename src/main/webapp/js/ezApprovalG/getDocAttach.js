var bAttachProcess = false;
function AttachProcess() {
    bAttachProcess = true;
}

function DocFileAttach_Click(docid, flag, sn, filename) {
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
    var openLocation = "/myoffice/Common/ezCommon_InterFace.aspx?TYPE=APPROVALG&DOCID=" + docid + "&DOCSTATUS=" + flag + "&DOCATTACHSN=" + sn;
    ifrmDownload.location.href = openLocation;
}

function trim(str) {
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function setAttachInfo(tempDocID, INGFlag, attachTag) {
    attachTag.innerHTML = "";
    var result = "";
	
	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/ezApprovalG/getTotalAttachInfo.do",
		data : {
			docID : tempDocID,
			mode : INGFlag
		},
		success: function(xml){
			result = xml;
		}        			
	});
    var xmldom = createXmlDom();

    xmldom =loadXMLString(result);
    var xmlRtn = SelectNodes(xmldom, "LISTVIEWDATA/ROWS/ROW");
    if (xmlRtn.length > 0) {
        var strAttach = " &nbsp ";
        var rep = /'/g;
        for (i = 0; i < xmlRtn.length; i++) {
            var Row = xmlRtn[i];
            var Cell = GetChildNodes(Row);

            if (SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == "File" || SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA4") == strLang1136) {
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

                if (CrossYN())
                    strTarget = "target=\''";

                var protocol = window.location.protocol;
                var serverName = window.location.hostname;

                strAttach = strAttach + "<a href= /ezApprovalG/downloadAttach.do?fileName=" + filename + "&docID=" + tempDocID + "&docStatus=" + INGFlag + "&docAttachSN=" + SelectSingleNodeValue(GetChildNodes(xmlRtn[i])[0], "DATA2") + "&filePath=" + filepath + " onclick='AttachProcess()'>";
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
                    strAttach = strAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                    strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; ";
                }             
                else if (FileExt == "hwp") {
                    openLocation = "/myoffice/ezApprovalG/ezViewHWP/ezViewEnd_HWP_Cross.aspx?DocID=" + escapenew(FileDocID) +
						"&DocHref=" + escapenew(FilePath) + "&formID=&orgDocid=";
                    strAttach = strAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                    strAttach = strAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                    strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; ";
                }
                else {
                    openLocation = "/ezApprovalG/contDocView.do";
                    openLocation = openLocation + "?docID=" + escapenew(FileDocID) + "&docHref=" + escapenew(FilePath) + "&formID=&orgDocID=";
                    strAttach = strAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 973, 570)\">";
                    strAttach = strAttach + "<IMG SRC='/images/attach-small.gif' border='0'>";
                    strAttach = strAttach + getNodeText(GetChildNodes(xmlRtn[i])[1]) + "</a> &nbsp; ";
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

function OpenAttachAlertUI(pAlertContent) {
    var parameter = pAlertContent;
    var url = "/myoffice/ezApprovalG/ezAPRALERT.aspx";
    var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
    var RtnVal = window.showModalDialog(url, parameter, feature);
}

