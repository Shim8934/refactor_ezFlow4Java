<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
        <link href="/css/previewmail.css" rel="stylesheet" type="text/css">
        <script language="JScript" src="/js/ezEmail/lang/ezEmail_ko.js"></script>
        <script language="JavaScript" src="/js/ezEmailjs_cross/reademail.js"></script>
        <style type="text/css">PRE {font-size:x-small;font-family: 'dotum', 'arial', 'verdana';}</style>
    <script language="javascript" type="text/javascript" src="/js/XmlHttpRequest.js"></script>
    <script language="javascript" type="text/javascript">
    var g_rejectWord = "${_rejectKeyWord}";
    var g_paramURL = decodeURIComponent('${System.Web.HttpUtility.UrlEncode(url)}');
    var objLink = document.all("BigSizeFileLink");
	if( objLink != null )
	{
		if( typeof(objLink.length) == "undefined" )
		{
			objLink.target = "";
		}
		else
		{
			for( var n = 0 ; n < objLink.length ; n++ )
			{
				objLink(n).target = "";
			}
		}
	}
	
	function window_onload()
	{
	    if (window.parent.pContentClass == "IPM.Schedule.Meeting.Request") {
	        ContentClassbtn.style.display = "";
	    }
	    if (typeof(window.parent.g_rejectWord) == "string")
	    {
	        window.parent.g_rejectWord = g_rejectWord;
	    }
	}
	
	function btnPrint_onClick()
	{
        window.self.focus();	
        window.self.print();
	}
	window.onbeforeprint = function()
	{
	    printScreen.style.display = "";
	    normalScreen.style.display = "none";
	    if (window.parent.tb_PrevShow) {
	        printMsgFrom.innerHTML = window.parent.div_SndName.innerHTML;
	        printMsgTo.innerHTML = window.parent.div_RcvName.innerHTML;
	        printMsgCC.innerHTML = window.parent.div_Ref.innerHTML;
	        printSubject.innerHTML = window.parent.div_Subject.innerHTML;
	        printInsertFile.innerHTML = window.parent.div_Attachment.innerHTML;
		
	    } else {
	        printMsgFrom.innerHTML = window.parent.MsgToPut.innerHTML;
	        printMsgTo.innerHTML = window.parent.MsgToGot.innerHTML;
	        if (window.parent.MsgCCGot != null) {
	            printMsgCC.innerHTML = window.parent.MsgCCGot.innerHTML;
	        }
	        else {
	            document.getElementById('printMsgCC').parentNode.parentNode.style.display = "none"
	        }
	        printSubject.innerHTML = window.parent.mailSubject.innerHTML;
	        printDate.innerHTML = window.parent.g_date;
	        if (window.parent.attachedfileDIV != null) {
	            printInsertFile.innerHTML = window.parent.attachedfileDIV.innerHTML;
	        }
	        else {
	            document.getElementById('printInsertFile').parentNode.parentNode.style.display = "none"
	        }
	    }
	    printDocument.innerHTML = normalScreen.innerHTML;

	    var checks = printInsertFile.all.tags("input");
	    for (var i=0; i<checks.length; i++)
	        checks.item(i).style.display = "none";

	    var tableColl = printDocument.all.tags("TABLE");
	    for (var i=0; i<tableColl.length; i++)
	    {
	        if (String(tableColl.item(i).borderColorDark).toLowerCase() == "#ffffff")
	        {
	        	tableColl.item(i).style.borderCollapse = "collapse";
	            tableColl.item(i).borderColorDark = "black";
	        }
	    }
	}
	window.onafterprint = function()
	{
	    printScreen.style.display = "none";
	    normalScreen.style.display = "";
	}
    function AttachDetail_view(obj) {
        if (obj.className == "icon_graydown") {
            obj.className = "icon_grayup"
            document.getElementById("PreviewAttachList").style.display = "";
        }
        else {
            obj.className = "icon_graydown"
            document.getElementById("PreviewAttachList").style.display = "none";
        }
    }
    function DownloadAttach(DownloadUrl) {
        AttachDownFrame.location.href = DownloadUrl;
    }
    var suffix = 0;
    function AttachAllDownload() {
        if (suffix < document.getElementsByName("MailAttachDownloadItems").length)
            setTimeout(function () { FileDownload(document.getElementsByName("MailAttachDownloadItems").item(suffix++).getAttribute("_filehref")) }, 2000);
        else {
            suffix = 0;
            return;
        }
    }
    function FileDownload(pFileUrl) {
        if (pFileUrl != null) {
            location.href = pFileUrl;
            AttachAllDownload();
        }
        else {
            suffix = 0;
            return;
        }

    }
    function DownloadPC(obj) {
        var param = { "href": new Array(), "filesize": new Array(), "name": new Array(), "folderpath": new String() };
        var count = 0;
        param["href"][count] = "/"+obj.getAttribute("_filehref");
        param["filesize"][count] = obj.getAttribute("_filesize");
        param["name"][count] = obj.getAttribute("_filename");

        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
        ezUtil.UseUTF8 = true;
        var folderpath = ezUtil.BrowseFolder();
        if (folderpath != "") {
            param["folderpath"] = folderpath;
            var feature = "dialogWidth:430px; dialogHeight:150px; scroll:no; status:no; help:no; scroll:no; edge:sunken";
            feature = feature + GetShowModalPosition(430, 150);
            window.showModalDialog("htm/attachdownload.aspx", param, feature);
        }
    }
    function AttachFile_Delete(obj) {

        if (!confirm("<spring:message code='ezEmail.t99000005' />"))
            return;

        var count = 0;
        var param = new Array();
        var ArrayDel = new Array();

        var xml = "<FILE>";
        xml += "<ROW>";
        xml += "<NAME><![CDATA[" + obj.getAttribute("fileid") + "]]></NAME>";
        xml += "</ROW>";
        xml += "<ITEMID><![CDATA[" + g_paramURL + "]]></ITEMID></FILE>";

        var xmlHTTP = new XMLHttpRequest();
        xmlHTTP.open("POST", "/myoffice/ezEmail/remote/mail_del_interattach.aspx", false);
        xmlHTTP.send(xml);

        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
            var oRoot = xmlHTTP.responseXML.documentElement;
            var ret = oRoot.childNodes[0].nodeValue;

            if (ret != "FAIL") {
                obj.parentNode.outerHTML = "";
                if (document.getElementById("PreviewAttachList").childNodes.length == 0) {
                    document.getElementById("ifrmPreViewRayer").style.display = "none";
                }
            }
            else {
                alert(strLang183);
            }
        }
    }
        var nowZoom = 100;
        var maxZoom = 200;
        var minZoom = 80;

        var MozNowZoom = 1;
        var MozMaxZoom = 2;
        var MozMinZoom = 0.8;
        function Bigger() {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                if (MozNowZoom < MozMaxZoom) {
                    MozNowZoom += 0.1;
                } else {
                    return;
                }
                document.getElementById("normalScreen").style.MozTransform = "scale(" + MozNowZoom + ")";
                document.getElementById("normalScreen").style.MozTransformOrigin = "0 0";
            }
            else {
                if (nowZoom < maxZoom) {
                    nowZoom += 10;
                } else {
                    return;
                }
                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
            }
        }
        function Smaller() {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                if (MozNowZoom > MozMinZoom) {
                    MozNowZoom -= 0.1;
                } else {
                    return;
                }
                document.getElementById("normalScreen").style.MozTransform = "scale(" + MozNowZoom + ")";
                document.getElementById("normalScreen").style.MozTransformOrigin = "0 0";

            }
            else {
                if (nowZoom > minZoom) {
                    nowZoom -= 10;
                } else {
                    return;
                }
                document.getElementById("normalScreen").style.zoom = nowZoom + "%";
            }
        }
        function Schedule_btn(pGubun) {
            parent.mtg_onClick(pGubun);
        }
</script> 
</head>
<body style="margin-left:10px;margin-top:10px" onload="javascript:window_onload()">
<img src='/images/minus.png' title="<spring:message code='ezEmail.t99000065' />" onclick='Smaller()' style='cursor: pointer;' />
<img src='/images/plus.png' title='<spring:message code='ezEmail.t99000064' />' onclick='Bigger()' style='cursor: pointer; margin-left: -4px;' />
<span id="ContentClassbtn" style="float:right;display:none;" >
<img src='/images/mtgrsp-accept.gif' width="20" height="20" title="<spring:message code='ezEmail.t901' />" onclick="Schedule_btn('ACCEPT');" style='cursor:pointer;' />
<img src='/images/mtgrsp-tent.gif' width="20" height="20" title="<spring:message code='ezEmail.t903' />" onclick="Schedule_btn('TENT');" style='cursor:pointer;' />
<img src='/images/mtgrsp-decline.gif' width="20" height="20" title="<spring:message code='ezEmail.t902' />" onclick="Schedule_btn('DECLINE');" style='cursor:pointer;' />
</span>
<div class="previewmail_addfile" id="ifrmPreViewRayer" style="display:none;margin-bottom:10px;">
<p class="title"><spring:message code='ezEmail.t99000003' /><span>${ pAttachListHtml_sub}</span><span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);"></span>
<span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload();"><spring:message code='ezEmail.t99000004' /></span></p>
	<ul class="list" id="PreviewAttachList">
        ${pAttachListHtml}
	</ul>
</div>
<div id="MailBigAttachRayer" class="previewmail_addfile">
</div>
<div class='margin' id="normalScreen" style="margin-top:5px;"> 
${_htmlbody}
</div>
<iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>  
</body>
<script language="javascript" type="text/javascript">
    try {
        var pisAttach = "${ isAttach }";
        if (pisAttach == "OK")
            document.getElementById("ifrmPreViewRayer").style.display = "";
        else
            document.getElementById("ifrmPreViewRayer").style.display = "none";
    } catch (e) { }
</script>
</html>