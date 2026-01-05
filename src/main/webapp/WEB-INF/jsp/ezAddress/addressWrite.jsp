<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezAddress.t323' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<style>.txtClass{box-sizing : border-box; -moz-box-sizing:border-box;}</style>
		<script type="text/javascript">
			var addressid = "<c:out value='${addressId}'/>";
			var folderid = "<c:out value='${folderId}'/>";
			var foldertype = "<c:out value='${folderType}'/>";
			var ownerid = "<c:out value='${ownerId}'/>";
			var changekey = "<c:out value='${changeKey}'/>";
			var photourl = "<c:out value='${photoUrl}'/>";
			var g_AddressAttachLimit= 20;
			var textEmail= "<c:out value='${textEmail}'/>";
		    var usernm = "<c:out value='${userNM}'/>";
		    var usernm2 = "<c:out value='${userNM2}'/>";
		    var useAddressOpenAPI = "<c:out value='${useAddressOpenAPI}'/>";
		    var deptAdmin = "${deptAdmin}";
		    var compAdmin = "${compAdmin}";
		    var xmlHttpAddressTree;
		    var closeAlertMsg = "<spring:message code='ezAddress.t337' />";
		    var useAnyoneEdit = "<c:out value='${useAnyoneEdit}'/>";
		    window.onload = function () {
				if(addressid == "")
				{
					document.title = "<spring:message code='ezAddress.t324' />";
					closeAlertMsg = "<spring:message code='ezEmail.t667' />";
				}
				else
				{
					document.title = "<spring:message code='ezAddress.t325' />";
				}
		        if (folderid == "") {
		            document.getElementById("selectfolder").style.display = "";
		            changetype();
		        }
		        
		        var name = '<c:out value="${addressInfo.sName}"/>'
		        name = replaceEntityCodeToStr(name);
		        document.getElementById("TextName").value = name;
		        
		        /* 
		        var getMemo = document.getElementById("TextMemo").value;
		        getMemo = getMemo.replace(/\\\\/gi, "\\");
		        document.getElementById("TextMemo").innerText = "";
		        document.getElementById("TextMemo").innerText = getMemo;
		         */
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
		        document.getElementById("LiteralPhoto").innerHTML = "<IMG SRC='/myoffice/Common/DownloadAttach.aspx?filepath=" + encodeURIComponent("/Upload_Address/Photo/" + photourl) + "' width=119 height=128>";
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
			                } catch (e) {console.log(e);}
		
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
			            } catch (e) {console.log(e);}
		
			            alert(g_fileList[i] + " <spring:message code='ezAddress.t332' />" + "\n\n" + e.number + " - " + e.description);
			            return;
			        }
			    }
		
			    try {
			        g_progresswin.close();
			    }
			    catch (e) {console.log(e);}
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
		        g_progresswin = window.showModelessDialog("address_progress.aspx?fileinfo=" + encodeURIComponent(fileinfo), "", "dialogWidth=390px; dialogHeight:170px; center:yes; status:no; help:no; edge:sunken");
		    }
		
		    function status_change(fileinfo) {
		        try {
		            g_progresswin.document.Script.fileinfo_change(fileinfo);
		        }
		        catch (e) {console.log(e);}
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
				
		        if (pTextName.indexOf("&") > -1 || pTextName.indexOf("<") > -1 || pTextName.indexOf(">") > -1 
		        		 || pTextName.indexOf("\"") > -1 || pTextName.indexOf("'") > -1 || pTextName.indexOf(';') != -1) {
	           		alert("<spring:message code='ezEmail.psb17' /> [ & < > \" ' ; ]");
	           		document.getElementById("TextName").focus();
		            return;
		        }
		        
		        if (useAnyoneEdit != "YES") {
		        	if (foldertype == "D" && deptAdmin != "Y") {
			        	alert("<spring:message code='ezAddress.t999900003' />");
			        	return;
			        } else if (foldertype == "C" && compAdmin != "Y") {
			        	alert("<spring:message code='ezAddress.t999900004' />");
			        	return;
			        }	
		        }
		        
		        if (!check_length(document.getElementById("TextCompanyPhone").value, 20, "<spring:message code='ezAddress.t222' />")) return;
		        if (!check_length(document.getElementById("TextMobile").value, 20, "<spring:message code='ezAddress.t223' />")) return;
		        if (!check_length(document.getElementById("TextFax").value, 20, "<spring:message code='ezAddress.t333' />")) return;
		        if (!check_length(document.getElementById("TextHomePage").value, 200, "<spring:message code='ezAddress.t293' />")) return;
		        if (!check_length(document.getElementById("TextComAddr").value, 200, "<spring:message code='ezAddress.t295' />")) return;
		        if (!check_length(document.getElementById("TextHomeAddr").value, 200, "<spring:message code='ezAddress.t296' />")) return;
		        if (!check_length(document.getElementById("TextMemo").value, 20000, "<spring:message code='ezAddress.t91' />")) return;
		        
		        if ((document.getElementById("TextEmail").value != "" && addressid == "") ||
					     (document.getElementById("TextEmail").value != "" && addressid != "" && document.getElementById("TextEmail").value != textEmail)) {
		        	var AddressCnt = Get_SameAddressCnt();
					
		            if (parseInt(AddressCnt) > 0) {
 		                alert("<spring:message code='ezAddress.t225' />");
 		                return;
		            }
		        }
				
		        var pTextEmail = TrimText(document.getElementById("TextEmail").value);
		        var regex = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
		        if (pTextEmail != "" && regex.test(pTextEmail) === false) {
		            alert("<spring:message code='ezAddress.t1100' />");
		            document.getElementById("TextEmail").value = pTextEmail;
		            document.getElementById("TextEmail").focus();
		            return;
		        }

		        // 번호 입력 시에는 숫자 [+ -] 만 입력 가능
		        var textCompanyPhone = document.getElementById("TextCompanyPhone").value;
		        var textMobile = document.getElementById("TextMobile").value;
		        var textFax = document.getElementById("TextFax").value;

		        var checkNumberArr = [textCompanyPhone, textMobile, textFax];
		        var regex2 = /^[0-9+\- ]+$/;
				for (var checkItem of checkNumberArr) {
					if ("" != checkItem && !regex2.test(checkItem)) {
						alert("<spring:message code='ezOrgan.ls009' />");
						return false;
					}
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
		        createNodeAndInsertCDataText(xmlDom, objNode, "SEMAIL", pTextEmail);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SHOMEPAGE", document.getElementById("TextHomePage").value);
		        createNodeAndInsertText(xmlDom, objNode, "SCOMPANYZIP", document.getElementById("TextComZip").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SCOMPANYADDR", document.getElementById("TextComAddr").value);
		        createNodeAndInsertText(xmlDom, objNode, "SHOMEZIP", document.getElementById("TextHomeZip").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SHOMEADDR", document.getElementById("TextHomeAddr").value);
		        createNodeAndInsertCDataText(xmlDom, objNode, "SMEMO", document.getElementById("TextMemo").value);
		        createNodeAndInsertText(xmlDom, objNode, "STYPE", "P");
		        createNodeAndInsertCDataText(xmlDom, objNode, "USERNM", usernm);
		        createNodeAndInsertCDataText(xmlDom, objNode, "USERNM2", usernm2);
		        createNodeAndInsertCDataText(xmlDom, objNode, "FURIGANA", document.getElementById("TextFurigana").value);
		        objRow = createNodeAndAppandNode(xmlDom, objNode, objRow, "ATTACHLIST");
		        
		        /* if(foldertype=="P")
		            xmlHTTP.open("POST", "RemoteEWS/address_save.aspx", false);
		        else
		            xmlHTTP.open("POST", "Remote/address_save.aspx", false); */
		        xmlHTTP.open("POST", "/ezAddress/addressSave.do", false);
		            
		        xmlHTTP.send(xmlDom);
		        
		        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
		            if (xmlHTTP.status != 200) {
		            	alert("<spring:message code='ezAddress.t181' />");
		            }
		            else if (xmlHTTP.responseText == "PRE") {
		            	alert("<spring:message code='ezAddress.t225' />");
		            }		            
		            else if (xmlHTTP.responseText == "NO_AUTHORITY_D") {
		            	alert("<spring:message code='ezAddress.t999900003' />");
		            }
		            else if (xmlHTTP.responseText == "NO_AUTHORITY_C") {
		            	alert("<spring:message code='ezAddress.t999900004' />");
		            }
		            else {
		            	if (addressid == "") {
			                alert("<spring:message code='ezAddress.t226' />");
			            }
			            else {
			                alert("<spring:message code='ezAddress.t334' />");
			            }
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
		            	var windowOpen = window.opener;
		            	var open_searchFlag = windowOpen.searchFlag;
		            	if (open_searchFlag) {
		            		windowOpen.search_start();            		
		            	} else if ("left" == windowOpen.frames.name.toLowerCase()) {
		            		windowOpen.parent.frames["right"].Get_AddressList();
		            	} else {
		            		windowOpen.Get_AddressList();
		            	}
		            }
		            catch (e) {console.log(e);}
		
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
		            if (!confirm(closeAlertMsg))
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
		        if (document.getElementById("TextFurigana").value != "") return false;
		        
		        return true;
		    }
		    var address_zip_select_dialogArguments = new Array();
		    function zip_find(whichto) {
		    	if (whichto == "0") {
		            IsComZip = true;
		    	} else {
		            IsComZip = false;
		    	}
		        
		        var OpenWin;
		    	if (useAddressOpenAPI == "YES") {
		    		address_zip_select_dialogArguments[1] = jusoCallBack;
		    		OpenWin = GetOpenWindow("/ezAddress/addressZipCodePopUpOpen.do","address_zip_select", 570, 420, "YES");
		    	} else {
		        	address_zip_select_dialogArguments[1] = zip_find_Complete;
			        OpenWin = GetOpenWindow("/ezAddress/addressZipCodePopUp.do", "address_zip_select", 655, 620, "YES");
		    	}
		    }
		    function zip_find_Complete(Para) {
		        if ((typeof (Para) != "undefined" || Para == "") && Para != "cancel") {
		            if (IsComZip) {
		                document.getElementById("TextComZip").value = Para[0];
		                document.getElementById("TextComAddr").value = Para[1];
		                document.getElementById("TextComAddr").focus();
		            }
		            else {
		                document.getElementById("TextHomeZip").value = Para[0];
		                document.getElementById("TextHomeAddr").value = Para[1];
		                document.getElementById("TextHomeAddr").focus();
		            }
		        }
		    }
		    function jusoCallBack(roadFullAddr, roadAddrPart1, addrDetail, roadAddrPart2, engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn){
		    	if (IsComZip) {
	                document.getElementById("TextComZip").value = zipNo;
	                document.getElementById("TextComAddr").value = roadFullAddr;
	                document.getElementById("TextComAddr").focus();
	            }
	            else {
	                document.getElementById("TextHomeZip").value = zipNo;
	                document.getElementById("TextHomeAddr").value = roadFullAddr;
	                document.getElementById("TextHomeAddr").focus();
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
			// 모바일과 함께 적용되어있는 사항 때문에  XmlHttpRequest.js와 다르게 &#34 형태로 적용
			function replaceEntityCodeToStr(str) {
				return str.replace(/&amp;/g, "&")
						  .replace(/&lt;/g, "<")
						  .replace(/&gt;/g, ">")
						  .replace(/&quot;/g, '\"')
						  .replace(/&#40;/g, "\(")
						  .replace(/&#41;/g, "\)")
						  .replace(/&#39;/g, "'")
						  .replace(/&#34;/g, '\"')
						  .replace(/&amp;/g, "&");
			}
		</script>
	</head>
	<body class="popup" style="overflow: auto; min-width: 500px;">
		<form method="post" style="position: relative;">
		  <div id="menu" style="margin-bottom:19px;">
		    <ul>
		      <!-- 2018-05-30 구해안 그룹웨어 모듈 '등록','저장후닫기' => '저장'으로 통일  ezAddress.t339 => t300 -->
		      <li><span onClick="insert_address()"><spring:message code='ezAddress.t300' /></span></li>
		        <select id ="selectfolder" style="display:none;margin-left:4px;" onchange ="changetype()">
		            ${rootAddressSelection}
		        </select>
		    </ul>
		  </div>
		  <div id="close" style="top: 2px;">
		    <ul>
		      <li><span onClick="close_onclick()"></span></li>
		    </ul>
		  </div>
		  <script type="text/javascript">
			selToggleList(document.getElementById("menu"), "ul", "li", "0");
		  </script>
		  <table class="content">
		  	<tr style=<c:out value="${primaryLang eq '3' ? 'display:table-row' : 'display:none' }"/>>
	        	<th style="width: 71px;"><spring:message code='main.ksa01' /></th>
	            <td style="width: 240px"><input id="TextFurigana" style="width: 100%;" maxlength="20" value="<c:out value='${addressInfo.sFurigana}' />"></td>
	        </tr>
		    <tr>
		      <!-- <th rowspan="4" align="center" ><span id="LiteralPhoto" width="119"></span></th> -->
		      <th><spring:message code='ezAddress.t124' /></th>
		      <td><input type="text" id="TextName" name="TextName" style="width:100%" maxlength="24" class="txtClass"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t51' /></th>
		      <td><input type="text" id="TextCompany" name="TextCompany" style="width:100%" maxlength="24" class="txtClass" value="<c:out value="${addressInfo.sCompany}"/>"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t54' /></th>
		      <td><input type="text" id="TextDept" name="TextDept" style="width:100%" maxlength="50" class="txtClass" value="<c:out value="${addressInfo.sDept}"/>"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t359' /></th>
		      <td><input type="text" id="TextTitle" name="TextTitle" style="width:100%" maxlength="50" class="txtClass" value="<c:out value="${addressInfo.sTitle}"/>"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t291' /></th>
		      <td><input type="text" id="TextEmail" name="TextEmail" style="width:100%" maxlength="100" class="txtClass" value="<c:out value="${addressInfo.sEmail}"/>"></td>
		    </tr>
		  </table>
		  <table class="popuplist" style="margin-top:10px;width:100%">
		    <tr>
		      <th style="white-space:nowrap"><spring:message code='ezAddress.t192' /></th>
		      <td style="width:185px"><input type="text" id="TextCompanyPhone" name="TextCompanyPhone" style="width:185px" class="txtClass" value="<c:out value="${addressInfo.sCompanyPhone}"/>"></td>
		      <th style="white-space:nowrap"><spring:message code='ezAddress.t189' /></th>
		      <td style="width:100%"><input type="text" id="TextMobile" name="TextMobile" style="width:100%" class="txtClass" value="<c:out value="${addressInfo.sMobile}"/>"></td>
		    </tr>
		    <tr>
		      <th><spring:message code='ezAddress.t292' /></th>
		      <td><input type="text" id="TextFax" name="TextFax" style="width:185px" class="txtClass" value="<c:out value="${addressInfo.sFax}"/>"></td>
		      <th><spring:message code='ezAddress.t293' /></th>
		      <td><input type="text" id="TextHomePage" name="TextHomePage" style="width:100%" class="txtClass" value="<c:out value="${addressInfo.sHomePage}"/>"></td>
		    </tr>
		    <tr>
		      <th rowSpan="2"><spring:message code='ezAddress.t295' /></th>
		      <td colSpan="3">
              <c:if test="${primaryLang == '1' && userLang == '1'}">
              	<c:if test="${useZipCodeSearch == 'YES' && not useOnlyInnerMail}">
              	<input type="text" id="TextComZip" name="TextComZip" style="width:70px" readonly="readonly" class="txtClass" style="margin-top:2px;" value="<c:out value="${addressInfo.sCompanyZip}"/>">
              	<a class="imgbtn imgbck" style="margin-top:1px"><span  onClick="zip_find(0);" style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span></a>
              	</c:if>
              	<c:if test="${useZipCodeSearch == 'NO' || useOnlyInnerMail}">
              		<input type="text" id="TextComZip" name="TextComZip" style="width:70px" class="txtClass" style="margin-top:2px;" value="<c:out value="${addressInfo.sCompanyZip}"/>">&nbsp;
              		<span style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span>
              	</c:if>
              </c:if>
              <c:if test="${primaryLang != '1' || userLang != '1'}">
              		<input type="text" id="TextComZip" name="TextComZip" style="width:70px" class="txtClass" style="margin-top:2px;" value="<c:out value="${addressInfo.sCompanyZip}"/>">&nbsp;<span style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span>
              </c:if>
              </td>
		    </tr>
		    <tr>
		      <td colSpan="3"><input type="text" id="TextComAddr" name="TextComAddr" style="width:100%" class="txtClass" value="<c:out value="${addressInfo.sCompanyAddr}"/>"></td>
		    </tr>
		    <tr>
		      <th rowSpan="2"><spring:message code='ezAddress.t296' /></th>
		      <td colSpan="3">
              <c:if test="${primaryLang == '1' && userLang == '1'}">
              	<c:if test="${useZipCodeSearch == 'YES' && not useOnlyInnerMail}">
              		<input type="text" id="TextHomeZip" name="TextHomeZip" style="width:70px" readonly="readonly" class="txtClass" style="margin-top:2px;" value="<c:out value="${addressInfo.sHomeZip}"/>">
              		<a class="imgbtn imgbck" style="margin-top:1px"><span  onClick="zip_find(1);" style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span></a>
              	</c:if>
              	<c:if test="${useZipCodeSearch == 'NO' || useOnlyInnerMail}">
              		<input type="text" id="TextHomeZip" name="TextHomeZip" style="width:70px" class="txtClass" style="margin-top:2px;" value="<c:out value="${addressInfo.sHomeZip}"/>">&nbsp;
              		<span style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span>
              	</c:if>
              </c:if>
              <c:if test="${primaryLang != '1' || userLang != '1'}">
              <input type="text" id="TextHomeZip" name="TextHomeZip" style="width:70px" class="txtClass" style="margin-top:2px;" value="<c:out value="${addressInfo.sHomeZip}"/>">&nbsp;<span style="vertical-align:middle;"><spring:message code='ezAddress.t26' /></span>
              </c:if>
              </td>
		    </tr>
		    <tr>
		      <td colSpan="3"><input type="text" id="TextHomeAddr" name="TextHomeAddr" style="width:100%" class="txtClass" value="<c:out value="${addressInfo.sHomeAddr}"/>"></td>
		    </tr>
		    <tr style="height:74px;">
		      <th style="height:74px;"><spring:message code='ezAddress.t91' /></th>
		      <td colSpan="3" style="height:74px;"><textarea id="TextMemo" name="TextMemo" style="width:100%;height:69px;word-break:break-all;resize: none;" class="txtClass"><c:out value="${addressInfo.sMemo}"></c:out></textarea></td>
		    </tr>
		    <tr style="display:none;height:62px;">
		      <th><spring:message code='ezAddress.t298' /></th>
		      <td colSpan="3" style="background-color:#FFFFFF">
		        <table  class="file">
		          <tr>
		            <td class="pos1"><div id="attachedfileDIV" class="file2"></div></td>
		            <td class="pos2">
		                <a class="imgbtn"><span id="btn_AttachAdd" onClick="attach_Add()"><spring:message code='ezAddress.t342' /></span></a><br>
		                <a class="imgbtn"><span id="btn_AttachDel" onClick="attach_Delete()"><spring:message code='ezAddress.t343' /></span></a></td>
		          </tr>
		        </table>
		      </td>
		    </tr>
		  </table>
		</form>
	</body>
</html>
