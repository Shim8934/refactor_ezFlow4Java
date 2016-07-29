<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code='ezAddress.t323' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezAddress.e2' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<style>.txtClass{box-sizing : border-box; -moz-box-sizing:border-box;}</style>
		<script type="text/javascript">
			var addressid = "${addressId}";
			var folderid = "${folderId}";
			var foldertype = "${folderType}";
			var ownerid = "${ownerId}";
			var changekey = "${changeKey}";
			var photourl = "${photoUrl}";
			var g_AddressAttachLimit= 20;
			var textEmail= "${textEmail}";
		    var usernm = "${userNM}";
		    var usernm2 = "${userNM2}";
		    var xmlHttpAddressTree;
		    window.onload = function () {
				if(addressid == "")
				{
					document.title = "<spring:message code='ezAddress.t324' />";
				}
				else
				{
					document.title = "<spring:message code='ezAddress.t325' />";
				}
		        if (folderid == "") {
		            document.getElementById("selectfolder").style.display = "";
		            changetype();
		        }
		    }
		    function change_photo() {
		        var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
		        var imgName = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx\0All Files (*.*)\0*.*\0\0", "")
		        var ezUtil = null;
		
		        if (imgName == "")
		            return;
		
		        var fileName = "";
		
		        try {
		            oPoster.Clear();
		            oPoster.UseUTF8 = true;
		            oPoster.AddFormData("mode", "send");
		            oPoster.AddFile("attachfile", imgName, 0);
		            oPoster.Host = document.location.hostname;
		            oPoster.PostURL = "/myoffice/ezAddress/RemoteEWS/address_uploadphoto.aspx";
		            oPoster.Post();
		            fileName = oPoster.Response;
		            if (fileName.length > 1000) {
		                alert(imgName + "<spring:message code='ezAddress.t326' />");
		                return;
		            }
		        }
		        catch (e) {
		            alert(imgName + "<spring:message code='ezAddress.t327' />" + "\n\n" + e.number + " - " + e.description);
		            return;
		        }
		        photourl = oPoster.Response;
		        document.getElementById("LiteralPhoto").innerHTML = "<IMG SRC='/myoffice/Common/DownloadAttach.aspx?filepath=" + escape("/Upload_Address/Photo/" + photourl) + "' width=119 height=128>";
		    }
		    function delete_photo() {
		        document.getElementById("LiteralPhoto").innerHTML = "<IMG <spring:message code='ezAddress.i1' />>";
		        photourl = "";
		    }
			var g_progresswin;
			var g_fileList;
			var g_fileNameList = new Array();
			var g_fileInfoList = new Array();
			function attach_Add() {
			    var ezUtil = new ActiveXObject("EzUtil.MiscFunc.1");
			    ezUtil.UseUTF8 = true;
			    var file = ezUtil.OpenLoadDlgMultiNew("All Files (*.*)\0*.*\0Microsoft Office Files\0*.doc;*.xls;*.ppt;*.pst;*.mdb;\0Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0Text Files\0*.txt;*.csv;\0Archive Files\0*.zip;*.rar;*.cab;*.alz;*.tar\0Executable Files\0*.exe;*.com;*.bat;\0\0", "")
		
			    if (!file)
			        return;
		
			    g_fileList = file.split("|");
			    var fileSize = 0;
		
			    for (var i = 0; i < g_fileList.length - 1; i++)
			        fileSize += ezUtil.GetFileSize(g_fileList[i]);
		
			    ezUtil = null;
		
			    if (fileSize > parseInt(g_AddressAttachLimit) * 1024 * 1024) {
			        alert("<spring:message code='ezAddress.t328' />" + g_AddressAttachLimit + "MB<spring:message code='ezAddress.t329' />");
			        return;
			    }
			    show_progress(g_fileList[0].substr(g_fileList[0].lastIndexOf("\\") + 1) + "<spring:message code='ezAddress.t330' />" + 1 + "/" + (g_fileList.length - 1));
			    var fileName = "";
			    for (var i = 0; i < g_fileList.length - 1; i++) {
			        try {
			            if (i > 0)
			                status_change(g_fileList[i].substr(g_fileList[i].lastIndexOf("\\") + 1) + "<spring:message code='ezAddress.t330' />" + (i + 1) + "/" + (g_fileList.length - 1));
		
			            oPoster.Clear();
			            oPoster.UseUTF8 = true;
			            oPoster.AddFormData("mode", "send");
			            oPoster.AddFile("attachfile", g_fileList[i], 0);
			            oPoster.Host = document.location.hostname;
			            oPoster.PostURL = "/myoffice/ezAddress/RemoteEWS/address_uploadfile.aspx";
		
			            if (window.location.protocol.toLowerCase() == "http:")
			                oPoster.Protocol = 0;
			            else
			                oPoster.Protocol = 1;
		
			            oPoster.Post();
		
			            fileName = oPoster.Response;
		
			            if (fileName.length > 1000) {
			                try {
			                    g_progresswin.close();
			                } catch (e) { }
		
			                alert(g_fileList[i] + " <spring:message code='ezAddress.t331' />");
			                return;
			            }
			            else {
			                g_fileInfoList[i] = fileName;
			                g_fileNameList[i] = fileName.split("/")[1];
			            }
			        }
			        catch (e) {
			            try {
			                g_progresswin.close();
			            } catch (e) { }
		
			            alert(g_fileList[i] + " <spring:message code='ezAddress.t332' />" + "\n\n" + e.number + " - " + e.description);
			            return;
			        }
			    }
		
			    try {
			        g_progresswin.close();
			    }
			    catch (e) { }
			    var attachText = "";
			    for (var i = 0; i < g_fileList.length - 1; i++) {
			        var param1 = "file://" + ReplaceText(g_fileList[i], "\\\\", "/");
			        var aItem = "<a href=\"" + param1 + "\" target='_blank'>" + g_fileNameList[i] + "</a>";
		
			        attachText = attachText + "<span align=\"left\"><input type='checkbox' fileinfo=\"" + ReplaceText(g_fileInfoList[i], "&", "&amp;") +
							"\"><img src='/images/email/mail_006.gif'> " + aItem + "&nbsp;&nbsp;<br></span>";
			    }
			    if (document.getElementById("attachedfileDIV").innerHTML == "&nbsp;" || document.getElementById("attachedfileDIV").innerHTML == "<DIV>&nbsp;</DIV>")
			        document.getElementById("attachedfileDIV").innerHTML = attachText;
			    else
			        document.getElementById("attachedfileDIV").innerHTML = document.getElementById("attachedfileDIV").innerHTML + attachText;
			}
		    function show_progress(fileinfo) {
		        g_progresswin = window.showModelessDialog("address_progress.aspx?fileinfo=" + escape(fileinfo), "", "dialogWidth=390px; dialogHeight:170px; center:yes; status:no; help:no; edge:sunken");
		    }
		
		    function status_change(fileinfo) {
		        try {
		            g_progresswin.document.Script.fileinfo_change(fileinfo);
		        }
		        catch (e) { }
		    }
		    function attach_Delete() {
		        var checks = document.getElementById("attachedfileDIV").getElementsByTagName("input");
		        for (var i = 0; i < checks.length; i++) {
		            if (checks.item(i).checked == true) {
		                if (checks.length == 1) {
		
		                    checks.item(i).parentElement.innerHTML = "&nbsp;";
		                }
		                else {
		                    checks.item(i).parentElement.parentElement.removeChild(checks.item(i).parentElement);
		                }
		                i--;
		            }
		        }
		    }
		    function insert_address() {
		        var pTextName = TrimText(document.getElementById("TextName").value);
		        if (pTextName == "") {
		            alert("<spring:message code='ezAddress.t220' />");
		
		            document.getElementById("TextName").value = "";
		            document.getElementById("TextName").focus();
		
		            return;
		        }
		        if (!check_length(pTextName, 50, "<spring:message code='ezAddress.t124' />")) return;
		        if (!check_length(document.getElementById("TextCompany").value, 50, "<spring:message code='ezAddress.t221' />")) return;
		        if (!check_length(document.getElementById("TextCompanyPhone").value, 20, "<spring:message code='ezAddress.t222' />")) return;
		        if (!check_length(document.getElementById("TextFax").value, 20, "<spring:message code='ezAddress.t333' />")) return;
		        if (!check_length(document.getElementById("TextMobile").value, 20, "<spring:message code='ezAddress.t223' />")) return;
		        if (!check_length(document.getElementById("TextDept").value, 50, "<spring:message code='ezAddress.t54' />")) return;
		        if (!check_length(document.getElementById("TextTitle").value, 50, "<spring:message code='ezAddress.t359' />")) return;
		        if (!check_length(document.getElementById("TextEmail").value, 250, "<spring:message code='ezAddress.t224' />")) return;
		        if (!check_length(document.getElementById("TextHomePage").value, 250, "<spring:message code='ezAddress.t293' />")) return;
		        if (!check_length(document.getElementById("TextComAddr").value, 250, "<spring:message code='ezAddress.t295' />")) return;
		        if (!check_length(document.getElementById("TextHomeAddr").value, 250, "<spring:message code='ezAddress.t296' />")) return;
		        if ((document.getElementById("TextEmail").value != "" && addressid == "") ||
				     (addressid != "" && document.getElementById("TextEmail").value != textEmail)) {
		            var AddressCnt = Get_SameAddressCnt();
		
		            if (parseInt(AddressCnt) > 0) {
		                alert("<spring:message code='ezAddress.t225' />");
		                return;
		            }
		        }
		
		        var regex = /^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
		        if (regex.test(document.getElementById("TextEmail").value) === false) {
		            alert("<spring:message code='ezAddress.t350' />");
		            document.getElementById("TextEmail").focus();
		            return;
		        }
		
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		        var objNode, objRow;
		        objNode = createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderid);
		        createNodeAndInsertText(xmlDom, objNode, "TYPE", foldertype);
		        createNodeAndInsertText(xmlDom, objNode, "OWNERID", ownerid);
		        createNodeAndInsertText(xmlDom, objNode, "ADDRESSID", addressid);
		        createNodeAndInsertText(xmlDom, objNode, "CHANGEKEY", changekey);
		        createNodeAndInsertText(xmlDom, objNode, "PHOTOPATH", photourl);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SNAME", pTextName);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SCOMPANY", document.getElementById("TextCompany").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SDEPT", document.getElementById("TextDept").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "STITLE", document.getElementById("TextTitle").value);
		        createNodeAndInsertText(xmlDom, objNode, "SCOMPANYPHONE", document.getElementById("TextCompanyPhone").value);
		        createNodeAndInsertText(xmlDom, objNode, "SMOBILE", document.getElementById("TextMobile").value);
		        createNodeAndInsertText(xmlDom, objNode, "SFAX", document.getElementById("TextFax").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SEMAIL", document.getElementById("TextEmail").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SHOMEPAGE", document.getElementById("TextHomePage").value);
		        createNodeAndInsertText(xmlDom, objNode, "SCOMPANYZIP", document.getElementById("TextComZip").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SCOMPANYADDR", document.getElementById("TextComAddr").value);
		        createNodeAndInsertText(xmlDom, objNode, "SHOMEZIP", document.getElementById("TextHomeZip").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SHOMEADDR", document.getElementById("TextHomeAddr").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SMEMO", document.getElementById("TextMemo").value);
		        createNodeAndInsertText(xmlDom, objNode, "STYPE", "P");
		        createNodeAndInsertCDataText(xmlDom, objNode, "USERNM", usernm);
		        createNodeAndInsertCDataText(xmlDom, objNode, "USERNM2", usernm2);
		        objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTACHLIST");
		        
		        /* if(foldertype=="P")
		            xmlHTTP.open("POST", "RemoteEWS/address_save.aspx", false);
		        else
		            xmlHTTP.open("POST", "Remote/address_save.aspx", false); */
		        xmlHTTP.open("POST", "/ezAddress/addressSave.do", false);
		            
		        xmlHTTP.send(xmlDom);
		        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
		            if (addressid == "") {
		                alert("<spring:message code='ezAddress.t226' />");
		            }
		            else {
		                alert("<spring:message code='ezAddress.t334' />");
		            }
		        }
		        else {
		            if (addressid == "") {
		                alert("<spring:message code='ezAddress.t335' />");
		            }
		            else {
		                alert("<spring:message code='ezAddress.t336' />");
		            }
		
		            try {
		                window.opener.Get_AddressList();
		            }
		
		            catch (e) { }
		
		            window.close();
		        }
		    }
		    function Get_SameAddressCnt() {
		        var xmlHTTP = createXMLHttpRequest();
		        var xmlDom = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlDom, objNode, "DATA");
		        createNodeAndInsertText(xmlDom, objNode, "IDLIST", ownerid);
		        createNodeAndInsertText(xmlDom, objNode, "FILTER", document.getElementById("TextEmail").value);
		        createNodeAndInsertText(xmlDom, objNode, "FOLDERTYPE", foldertype);
		        createNodeAndInsertText(xmlDom, objNode, "FOLDERID", folderid);
		        
		        /* if(foldertype == "P")
		            xmlHTTP.open("POST", "RemoteEWS/address_Get_SearchCnt.aspx", false);
		        else
		            xmlHTTP.open("POST", "Remote/address_Get_SearchCnt.aspx", false); */
		        xmlHTTP.open("POST", "/ezAddress/addressGetSearchCnt.do", false);
		            
		        xmlHTTP.send(xmlDom);
		        if (xmlHTTP.status != 200)
		            alert("<spring:message code='ezAddress.t230' />");
		        else
		            return xmlHTTP.responseText;
		    }
		    function close_onclick() {
		        if (checkblankbox()) {
		            window.close();
		        }
		        else {
		            if (!confirm("<spring:message code='ezAddress.t337' />"))
		                window.close();
		            else
		                insert_address();
		        }
		    }
		    function checkblankbox() {
		        if(document.getElementById("TextName").value != "") return false;
		        if(document.getElementById("TextCompany").value != "") return false;
		        if(document.getElementById("TextCompanyPhone").value != "") return false;
		        if(document.getElementById("TextFax").value != "") return false;
		        if(document.getElementById("TextMobile").value != "") return false;
		        if(document.getElementById("TextDept").value != "") return false;
		        if(document.getElementById("TextTitle").value != "") return false;
		        if(document.getElementById("TextEmail").value != "") return false;
		        if(document.getElementById("TextHomePage").value != "") return false;
		        if(document.getElementById("TextComAddr").value != "") return false;
		        if(document.getElementById("TextHomeAddr").value != "") return false;
		        if (document.getElementById("TextEmail").value != "") return false;
		        
		        return true;
		    }
		    var address_zip_select_dialogArguments = new Array();
		    function zip_find(whichto) {
		        address_zip_select_dialogArguments[1] = zip_find_Complete;
		        address_zip_select_dialogArguments[3] = whichto;
		        var OpenWin = window.open("/ezAddress/address_zip_select.do", "address_zip_select", GetOpenWindowfeature(655, 420));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function zip_find_Complete(Para) {
		        if (typeof (Para) != "undefined" && Para[0] != "cancel") {
		            if (address_zip_select_dialogArguments[3] == 0) {
		                document.getElementById("TextComZip").value = Para[0];
		                document.getElementById("TextComAddr").value = Para[1] + " " + Para[2] + " " + Para[3];
		                document.getElementById("TextComAddr").focus();
		            }
		
		            else {
		                document.getElementById("TextHomeZip").value = Para[0];
		                document.getElementById("TextHomeAddr").value = Para[1] + " " + Para[2] + " " + Para[3];
		                document.getElementById("TextHomeAddr").focus();
		            }
		        }
		    }
		    function ReplaceText(orgStr, findStr, replaceStr) {
		        var re = new RegExp(findStr, "gi");
		        return (orgStr.replace(re, replaceStr));
		    }
		    function check_length(chkstr, maxlength, fieldname) {
		        var length = 0;
		        var i;
		        length = chkstr.length;
		        if (length > maxlength) {
		            alert(fieldname + "<spring:message code='ezAddress.t227' />" + maxlength + "<spring:message code='ezAddress.t338' />");
		            return false
		        }
		        return true;
		    }
		    function TrimText(orgStr) {
		        var copyStr = "";
		        var strIndex;
		        for (strIndex = 0; strIndex < orgStr.length; strIndex++) {
		            if (orgStr.charAt(strIndex) == ' ') {
		                continue;
		            }
		            else {
		                copyStr = orgStr.substr(strIndex);
		                break;
		            }
		        }
		        for (strIndex = copyStr.length - 1; strIndex >= 0; strIndex--) {
		            if (copyStr.charAt(strIndex) == ' ') {
		                continue;
		            }
		            else {
		                copyStr = copyStr.substr(0, strIndex + 1);
		                break;
		            }
		        }
		
		        return copyStr;
		    }
			function changetype() {
			    var selectedindex = document.getElementById("selectfolder").options.selectedIndex;
			    foldertype = document.getElementById("selectfolder").options[selectedindex].id;
			    folderid = document.getElementById("selectfolder").options[selectedindex].value;
			    ownerid = document.getElementById("selectfolder").options[selectedindex].getAttribute("ownerid");
			}
		</script>
	</head>
	<body class="popup" style="overflow:hidden">
		<form method="post" runat="server">
		  <div id="menu">
		    <ul>
		      <li><span onClick="insert_address()"><spring:message code='ezAddress.t339' /></span></li>
		        <select id ="selectfolder" style="display:none;margin-left:4px;margin-top:2px" onchange ="changetype()">
		            ${rootAddressSelection}
		        </select>
		    </ul>
		  </div>
		  <div id="close">
		    <ul>
		      <li><span onClick="close_onclick()"><spring:message code='ezAddress.t5' /></span></li>
		    </ul>
		  </div>
		  <script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		  </script>
		  <table class="content">
		    <tr>
		      <!-- <th rowspan="4" align="center" ><span id="LiteralPhoto" width="119"></span></th> -->
		      <th><spring:message code='ezAddress.t124' /></th>
		      <td><input type="text" id="TextName" name="TextName" style="width:100%" maxlength="24" class="txtClass" value="${addressInfo.sName}"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t51' /></th>
		      <td><input type="text" id="TextCompany" name="TextCompany" style="width:100%" maxlength="24" class="txtClass" value="${addressInfo.sCompany}"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t54' /></th>
		      <td><input type="text" id="TextDept" name="TextDept" style="width:100%" maxlength="24" class="txtClass" value="${addressInfo.sDept}"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t359' /></th>
		      <td><input type="text" id="TextTitle" name="TextTitle" style="width:100%" maxlength="24" class="txtClass" value="${addressInfo.sTitle}"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t291' /></th>
		      <td><input type="text" id="TextEmail" name="TextEmail" style="width:100%" class="txtClass" value="${addressInfo.sEmail}"></td>
		    </tr>
		  </table>
		  <table class="popuplist" style="margin-top:10px;width:100%">
		    <tr>
		      <th style="white-space:nowrap"><spring:message code='ezAddress.t192' /></th>
		      <td style="width:185px"><input type="text" id="TextCompanyPhone" name="TextCompanyPhone" style="width:185px" class="txtClass" value="${addressInfo.sCompanyPhone}"></td>
		      <th style="white-space:nowrap"><spring:message code='ezAddress.t189' /></th>
		      <td style="width:100%"><input type="text" id="TextMobile" name="TextMobile" style="width:100%" class="txtClass" value="${addressInfo.sMobile}"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t292' /></th>
		      <td><input type="text" id="TextFax" name="TextFax" style="width:185px" class="txtClass" value="${addressInfo.sFax}"></td>
		      <th><spring:message code='ezAddress.t293' /></th>
		      <td><input type="text" id="TextHomePage" name="TextHomePage" style="width:100%" class="txtClass" value="${addressInfo.sHomePage}"></td>
		    </tr>
		    <tr>
		      <th rowSpan="2"><spring:message code='ezAddress.t295' /></th>
		      <td colSpan="3"><input type="text" id="TextComZip" name="TextComZip" style="width:70px" readonly="readonly" class="txtClass" style="margin-top:2px;" value="${addressInfo.sCompanyZip}">&nbsp;<a href="#" class="imgbtn" style="margin-top:2px;"><span  onClick="zip_find(0);" style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span></a></td>
		    </tr>
		    <tr>
		      <td colSpan="3"><input type="text" id="TextComAddr" name="TextComAddr" style="width:100%" class="txtClass" value="${addressInfo.sCompanyAddr}"></td>
		    </tr>
		    <tr>
		      <th rowSpan="2"><spring:message code='ezAddress.t296' /></th>
		      <td colSpan="3"><input type="text" id="TextHomeZip" name="TextHomeZip" style="width:70px" readonly="readonly" class="txtClass" style="margin-top:2px;" value="${addressInfo.sHomeZip}">&nbsp;<a href="#" class="imgbtn" style="margin-top:2px;"><span  onClick="zip_find(1);" style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span></a></td>
		    </tr>
		    <tr>
		      <td colSpan="3"><input type="text" id="TextHomeAddr" name="TextHomeAddr" style="width:100%" class="txtClass" value="${addressInfo.sHomeAddr}"></td>
		    </tr>
		    <tr style="height:74px;">
		      <th style="height:74px;"><spring:message code='ezAddress.t91' /></th>
		      <td colSpan="3" style="height:74px;"><textarea id="TextMemo" name="TextMemo" style="width:100%;height:69px;word-break:break-all;" class="txtClass">${addressInfo.sMemo}</textarea></td>
		    </tr>
		    <tr style="display:none;height:62px;">
		      <th><spring:message code='ezAddress.t298' /></th>
		      <td colSpan="3" style="background-color:#FFFFFF">
		        <table  class="file">
		          <tr>
		            <td class="pos1"><div id="attachedfileDIV" class="file2"></div></td>
		            <td class="pos2">
		                <a href="#" class="imgbtn"><span id="btn_AttachAdd" onClick="attach_Add()"><spring:message code='ezAddress.t342' /></span></a><br>
		                <a href="#" class="imgbtn"><span id="btn_AttachDel" onClick="attach_Delete()"><spring:message code='ezAddress.t343' /></span></a></td>
		          </tr>
		        </table>
		      </td>
		    </tr>
		  </table>
		</form>
	</body>
</html>
