
function clear_prevShow() {
   
    div_PreView.innerHTML = "";
    div_Attachment.innerHTML = "";
    div_Attachment.style.height = "25";
    div_Attachment.style.overflowY = "visible";
    g_prevBoardID = "";
    g_prevItemID = "";
}
function prevShow() {
    if (!g_bPrevShow)
        return;

    try {
        var tr = lvDocList.getRowIndex();
        if (tr != null) {
            
            if (pListTypeValue == "4")
                SusinDocCopy(DocID);
            var FormProc = pzFormProc.object;

            if (pContentLoc.substr(pContentLoc.length - 3, pContentLoc.length).toLowerCase() == "mht") {
                var URL = document.location.protocol + "//" + document.location.hostname + "/myoffice/Common/DownloadAttach.aspx?filepath=" + escape(pContentLoc);  
                FormProc.LoadURL(URL);	
             }
            else {
                pzFormProc.Editor.Dom.body.innerHTML = " <br/> "+strLang510;
            }
      

            SetOpinionCnt(DocID);
            SetAttachmentInfo(DocID);
         }
        else {
            g_PreView.innerHTML = "";
            div_Opinion.innerHTML = "";
            div_Attachment.innerHTML = "";
        }

        
    } catch (e) { }
}
function event_prevShow() {
    if (g_prevHTTP != null && g_prevHTTP.readyState == 4) {
        var bunread = "0";
        if (g_prevHTTP.statusText == "OK") {
            
            if (pListTypeValue == "4")
                SusinDocCopy(getNodeText(xmlDoc.selectSingleNode("DATA/DOCID")));
            
            
            var xmlDoc = loadXMLString(g_prevHTTP.responseText);
            var pContentLoc = "";
            g_prevHTTP = null;

            pContentLoc = getNodeText(xmlDoc.selectSingleNode("DATA/HREF"));
            LoadpzFormDocInfo();

            var attachText = "";
            var pAttachfg = getNodeText(xmlDoc.selectSingleNode("DATA/HASATTACHYN"));

            if (pAttachfg == "Y") {
               SetAttachmentInfo(g_prevItemID);
            }
            else {
                div_Attachment.style.height = "25";
                div_Attachment.style.overflowY = "visible";
            }
            xmlDoc = null;
        }
        else
            g_prevHTTP = null;

        try {
            if (g_prevElem != null)
                g_ViewID.unboldRow(g_prevElem);
        } catch (e) { }
        g_prevElem = null;

        try {
            previewScroll.scrollIntoView(true);
            if (g_PreViewID.offsetHeight != g_PreviewTitle.offsetHeight + g_PreView.offsetHeight)
                g_PreViewID.style.height = (g_PreviewTitle.offsetHeight + g_PreView.offsetHeight).toString() + "px";

            alert(g_PreViewID.style.height);
        } catch (e) { }

        window.status = strLangAprState10;
    }
}
function prevShow_onclick() {
    try {
        prevShowFlagSet();        
        prevShow();
    } catch (e) { }
}
function prevShowFlagSet() {
    if (g_PreViewID.style.display == "none") {
        g_PreViewID.style.display = "block";
        g_bPrevShow = true;       
        ViewInfo.style.display = "none";
    }
    else {
        g_PreViewID.style.display = "none";
        g_bPrevShow = false;
        ViewInfo.style.display = "block";
    }
}
function down_preViewWindow() {
    try {
        var elem = window.event.srcElement;
        if (elem.tagName == "FONT") {
            if (window.event.button == 1) {
                var parentElem = elem.parentElement;
                parentElem.click();
            }
        }
    } catch (e) { }

    try {
        var titleY = g_PreviewTitle.offsetHeight;
        var clientY = get_clientY(window.event.offsetY, window.event.srcElement, g_PreViewID);
        if (window.event.button == 1) {
            if (clientY - titleY < 0) {
                g_moveStart = true;
                g_startPosition = clientY;
                g_PreViewID.setCapture(true);
            }
        }
    } catch (e) { }    
    
}


function up_preViewWindow() {
    g_moveStart = false;
    g_PreViewID.releaseCapture();       
}

function move_preViewWindow() {
    if (g_moveStart == false) return;

    try {
        var titleY = g_PreviewTitle.offsetHeight;
        var clientY = get_clientY(window.event.offsetY, window.event.srcElement, g_PreViewID);  
        var totalHeight;

        if (window.event.button == 1 && g_moveStart == true) {
            totalHeight = g_PreViewID.offsetHeight;
            totalHeight += (g_startPosition - clientY);

            if (totalHeight < g_PreviewTitle.offsetHeight)
                return;

            g_PreView.style.height = (totalHeight - g_PreviewTitle.offsetHeight) + "px";
            g_PreViewID.style.height = totalHeight.toString() + "px";
            
            

        } else
            g_moveStart = false;
    } catch (e) { }
}
function get_clientY(offsetY, currentElement, targetElement) {
    var retValue = offsetY;
    var tempElement = currentElement;

    while (tempElement != targetElement) {
        if (tempElement.tagName != "TD" && tempElement.tagName != "TBODY")
            retValue += tempElement.offsetTop;
        tempElement = tempElement.parentElement;
    }

    return retValue;
}
function preViewSizeSetting() {

    	var bodyY = document.body.offsetHeight;
	    var totalHeight = (bodyY / 2);
	    
	     if (totalHeight < g_PreviewTitle.offsetHeight)
            totalHeight = 40;
            
	    g_PreViewID.style.height = totalHeight.toString() + "px";  	    
	    if(typeof(theBody) != "undefined" && typeof(theBody) != "unknown")
	        {
		        theBody.load("valueStore");							
        		
		        if (GetAttribute(theBody, "preView") != "OFF")
		        {
				        g_PreViewID.style.display = "block";
				        g_bPrevShow = true;
				        ViewInfo.style.display = "none";
		        }
		        else
		        {
			        g_PreViewID.style.display = "none";	
			        ViewInfo.style.display = "block";
			        if (GetAttribute(theBody, "preView") != "OFF")
			        {
					        g_bPrevShow = true;
			        }
			        else
			        {
				        g_bPrevShow = false;	
			        }
		        }
	        }
}

function MhtConvert(pContent) {
    var fullPath, strhtml;

    if (pContent.substr(pContent.length - 3, pContent.length).toLowerCase() == "mht") {
        fullPath = document.location.protocol + "//" + document.location.hostname + pContent;
        objMHT.sync = true;

        var strMht = objMHT.DownloadURL(fullPath);
        objMHT.mhtData = strMht;
        objMHT.filterIn();
        strhtml = objMHT.htmlData;
        strhtml = ReplaceText(strhtml, "<a", "<a target='_blank'");
    }
    else {
        strhtml = "<br/>" + strLang510;
    }
    return strhtml;
}

function ReplaceText(orgStr, findStr, replaceStr) {
    var re = new RegExp(findStr, "gi");
    return (orgStr.replace(re, replaceStr));
}


function SetOpinionCnt(docid) {
    var type = "";
    if (docid == null) {
        div_Opinion.innerHTML = "";
        return;
    }

    var RtnVal = createXmlDom();
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");

    createNodeAndInsertText(xmlpara, objNode, "DocID", docid);
    if (pListTypeValue == "9")
        type = "TMP";
    else
        type = "APR";
    createNodeAndInsertText(xmlpara, objNode, "Flag", type);

    var xmlhttpOp = createXMLHttpRequest();
    xmlhttpOp.open("POST", "aspx/getOpinionInfo.aspx", false); 
    xmlhttpOp.send(xmlpara);


    RtnVal = loadXMLString(xmlhttpOp.responseText);

    var opcnt = RtnVal.selectNodes("LISTVIEWDATA/ROWS/ROW").length;

    if (opcnt != "0")
        div_Opinion.innerHTML = "<a href='#'  onClick='ViewOpinion(\"" + docid + "\")'><img src='/images/board_comment.gif' border=0>(" + opcnt + ")</a>";
    else
        div_Opinion.innerHTML = "";

   
}
var xmlhttpAtt = createXMLHttpRequest();
function SetAttachmentInfo(docid) {

    if (docid == null) {
        div_Attachment.innerHTML = "";
        return;
    }
    var xmlpara = createXmlDom();


    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", docid);

    if (pListTypeValue == "9")
        type = "TMP";
    else
        type = "APR";
    createNodeAndInsertText(xmlpara, objNode, "Flag", type);

    xmlhttpAtt = null;
    xmlhttpAtt = createXMLHttpRequest();
    xmlhttpAtt.open("POST", "aspx/getTotalAttachInfo.aspx", true);
    xmlhttpAtt.onreadystatechange = getdoclistSub_after;
    xmlhttpAtt.send(xmlpara);

}

function getdoclistSub_after()
{
    if (xmlhttpAtt == null || xmlhttpAtt.readyState != 4) return;

	try {
	    var xmldom = loadXMLString(xmlhttpAtt.responseText);

	    var strAttach = "";
	    var xmlRtn = xmldom.selectNodes("LISTVIEWDATA/ROWS/ROW");

	    if (xmlRtn.length > 0) {
	        fileArray = null;
	        fileNameArray = null;
	        fileCount = 0;

	        fileArray = new Array();
	        fileNameArray = new Array();

	        var strAttach = "";
	        var rep = /'/g
	        for (i = 0; i < xmlRtn.length; i++) {
	             
	            if (getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA4")) == "file") {
	                var IncodFileNM = encodeURIComponent(getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA1")));
	                var filename = encodeURIComponent(getNodeText(xmlRtn.item(i).childNodes(1).childNodes(0)));
	                var filepath = IncodFileNM.replace(rep, "&#39;");

	                var strTarget = "target='_blank'";
	                var strFileExt = filename.substr(filename.lastIndexOf('.')).toLowerCase();
	                var fileImage = "";

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
	                else if (strFileExt.indexOf(".hwp") != -1)
	                    fileImage = "/images/hwp.png";
	                else
	                    fileImage = "/Images/attach-small.gif";

	                var regData = clientInformation.systemLanguage;

	                strAttach = strAttach + "<a href=\"/myoffice/Common/downloadattach.aspx?filename=" + filename + "&filepath=" + filepath + "&regData=" + regData + "\" " + strTarget + "' >";
	                strAttach = strAttach + "<IMG SRC='" + fileImage + "' border='0'>";
	                strAttach = strAttach + getNodeText(xmlRtn.item(i).childNodes(1).childNodes(0)) + "</a><br/> ";
	                fileArray[fileCount] = "/myoffice/Common/downloadattach.aspx?filename=" + filename + "&filepath=" + filepath;
	                fileNameArray[fileCount] = getNodeText(xmlRtn.item(i).childNodes(1).childNodes(0));
	                fileCount++;
	            }
	            else {
	                var FilePath = getNodeText(xmlRtn.item(i).selectSingleNode("CELL/DATA1"));
	                var FileExt = FilePath.substr(FilePath.length - 3, FilePath.length).toLowerCase();
	                var FileDocID = FilePath.substr(FilePath.length - 24, 20).toLowerCase();
	                var FileName = getNodeText(xmlRtn.item(i).childNodes(1).childNodes(0));
	                var openLocation = "";

	                if (FileExt == "hwp") {
	                    openLocation = "/myoffice/ezApproval/ezViewHWP/ezViewEnd_HWP.aspx";
	                }
	                else {
	                    if (CrossYN() || pNoneActiveX == "YES") {
	                        openLocation = "/myoffice/ezApproval/formContainer/contDocView_Cross.aspx";
	                    }
	                    else {
	                        if (pUse_Editor == "")
	                            openLocation = "/myoffice/ezApproval/formContainer/contDocView.aspx";
	                        else
	                            openLocation = "/myoffice/ezApproval/formContainer/contDocView_IE.aspx";
	                    }
	                }
	                openLocation = openLocation + "?DocID=" + escape(FileDocID) + "&DocHref=" + escape(FilePath) + "&formID=&orgDocid=&attachFlag=Y";
	                strAttach = strAttach + "<a style='cursor:pointer' onclick=\"openAttachView('" + openLocation + "', '', 890, 620)\">";
	                strAttach = strAttach + "<IMG SRC='/Images/attach-small.gif' border='0'>";
	                strAttach = strAttach + getNodeText(xmlRtn.item(i).childNodes(1).childNodes(0)) + "</a><br/>  "
	            }
	        }

	    }

	    if (xmlRtn.length > 2) {
	        div_Attachment.style.height = "42";
	        div_Attachment.style.overflowY = "auto";
	        title_preview.style.height = "53";
	    }
	    else {
	        div_Attachment.style.height = "15";
	        div_Attachment.style.overflowY = "auto";
	        title_preview.style.height = "40";
	    }


	    div_Attachment.innerHTML = strAttach;
	}
	catch (e) {
	    alert("getdoclistSub_after : " + e.description);
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
            pleftpos = parseInt(width) - 770;
            heigth = parseInt(heigth) - 30;
            width = parseInt(width) - pleftpos;
            left = pleftpos / 2;
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


function ViewOpinion(docid) {

    if (docid == "") return;

    if (pListTypeValue == "9")
        type = "TMP";
    else
        type = "APR";
    var openLocation = "/myoffice/ezApproval/ezAPROPINION/ViewOpinion.aspx?docid=" + docid + "&type=" + type;
    var result = GetOpenWindow(openLocation, "Opinion", 810, 280, "NO");
}

function SusinDocCopy(docid) {
    var xmlpara = createXmlDom();

    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "DocID", docid);

    var xmlhttpdoc = createXMLHttpRequest();
    xmlhttpdoc.open("POST", "aspx/SusinDocCopyFile.aspx", false);
    xmlhttpdoc.send(xmlpara);
}