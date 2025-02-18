<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/js/jquery/jquery-ui.min.css')}"/>
		<style>
		.listview, .popuplist .listview table, .popuplist .listview th, .popuplist .listview td, .content .listview table, .content .listview th, .content .listview td {
			border: 0px;
        	border-bottom: 1px solid #ddd;
		}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.min.js')}"></script>
		
		<script type="text/javascript">
			var userLang = "<c:out value = '${strUserLang}' />";
	        var mode = "<c:out value = '${mode}' />";
	        var g_attendant = "";
	        var xmlhttp;
	        var xmlhttp2;
	        var guid = "{" + GetGUID() + "}";
	        var ArgQuickID;
	        var checkValue = "A";
	        var LinkTypeURL;
	        var primary = "<c:out value = '${primary}' />";
	        var ReturnFunction;
	        var RetValue;
	        var lang = "${lang}";
	        
	        $(function() {
	        	$(document).tooltip();
	        });
	        
	        $(document).ready(function () {
	            LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
	
	            try {
	                RetValue = parent.addquicklink_dialogArguments[0];
	                ReturnFunction = parent.addquicklink_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.addquicklink_dialogArguments[0];
	                    ReturnFunction = opener.addquicklink_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	
	            if (mode == "modify") {
	                document.getElementById("btn_OK").innerText = "<spring:message code = 'ezPersonal.t169' />";
	            }
	            
	            if (RetValue != "" && mode != "new") {
	                ArgQuickID = RetValue;
	                initQuickLink();
	                initQuickLinkACL();
	            }	
	        });
	
	        function KeEventControl(obj) {
	            useragt = navigator.userAgent.toUpperCase();
	            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) {
	                useragt = useragt.substring(useragt.indexOf("VERSION/") + 8, useragt.indexOf("VERSION/") + 9);
	                
	                if (parseInt(useragt) > 5) {
	                    return;
	                }
	            }
	
	            obj.onkeydown = function () {
	                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126) {
	                    return false;
	                }
	                
	                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
	                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
	                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
	                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
	                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32 || parseInt(window.event.keyCode) == 192) {
	                    return false;
	                }
	            };
	        }
	        
	        function initQuickLink() {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		url : "/admin/ezPersonal/getQuickLink.do",
	        		async : true,
	        		data : {pQuickLinkID : ArgQuickID},
	        		success : function(result) {
	        			if (result != null) {
	        				event_GetQuickLink(loadXMLString(result));
	        			}
	        		}
	        	});
	        }
	        
	        function event_GetQuickLink(result) {
				var xmldomNode = SelectNodes(result, "DATA/ROW");
				
				for (var i = 0; i < xmldomNode.length; i++) {
				    QuickLinkID = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKID");
				    var QuickLinkName = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKNAME");
				    var QuickLinkName2 = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKNAME2");
				    var QuickLinkName3 = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKNAME3");
				    var QuickLinkName4 = SelectSingleNodeValue(xmldomNode[i], "QUICKLINKNAME4");
				    var LinkType = SelectSingleNodeValue(xmldomNode[i], "LINKTYPE");
				    var URL = SelectSingleNodeValue(xmldomNode[i], "URL");
				    var SIZE = SelectSingleNodeValue(xmldomNode[i], "SIZE_");
				    var url  = SelectSingleNodeValue(xmldomNode[i], "LINKTYPEURL");
				    
				    if (SIZE == "FULL") {
				        eval("chk_Full").checked = true;
				        document.getElementById("txt_Width").value = "";
				        document.getElementById("txt_Height").value = "";
				    } else if (SIZE == "Null") {
				        eval("chk_Full").checked = true;
				        document.getElementById("txt_Width").value = "";
				        document.getElementById("txt_Height").value = "";
				    } else {
				        eval("chk_Size").checked = true;
				        document.getElementById("div_Size").style.display = "";
				        document.getElementById("txt_Width").value = SIZE.split(':')[0];
				        document.getElementById("txt_Height").value = SIZE.split(':')[1];
				    }
				
				    document.getElementById("Title1").value = QuickLinkName;
				    document.getElementById("Title2").value = QuickLinkName2;
				    document.getElementById("Title3").value = QuickLinkName3;
				    document.getElementById("Title4").value = QuickLinkName4;
				
				    checkValue = LinkType;
				    LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
				    
				    var cnt = document.getElementsByName("linktypeOption").length;
				    
				    for (var i = 0; i < cnt; i++) {
				        if (document.getElementsByName("linktypeOption")[i].value.trim() == checkValue.trim()) {
				            document.getElementsByName("linktypeOption")[i].checked = true;
				        }
				    }
				    
				    document.getElementById("txtURL").value = trim_Cross(URL);
				    
				    if (LinkType == "Z") {
                        document.getElementById("makeTypeTable").style.display = "";
                        document.getElementById("makeTypeImgTD").innerHTML = "";

                        var _img = document.createElement("IMG");
                        _img.src = url;

                        _img.id = "ZmakeTypeImg";
                        _img.onclick = function () { radioClick(this, 'img') };
                        _img.style.cursor = "pointer";
                        document.getElementById("makeTypeImgTD").appendChild(_img);

                        document.getElementById("Z").checked = true;
                        checkValue = "Z";
                        LinkTypeURL = url;
                    }
				}
	        }
	        
	        function initQuickLinkACL() {
	        	$.ajax({
	        		type : "POST",
	        		url : "/admin/ezPersonal/getQuickLinkACL.do",
	        		dataType : "text",
	        		data : {pQuickLinkID : ArgQuickID},
	        		success : function(result) {
	        			event_GetQuickLinkACL(loadXMLString(result));
	        		}
	        	});
	        }
	        
	        function event_GetQuickLinkACL(result) {
                makePermissionsList(result, true);
	        }
	
	        var selecttarget_dialogArguments = new Array();
	        function regit() {
	            if (CrossYN()) {
	                selecttarget_dialogArguments[0] = g_attendant;
	                selecttarget_dialogArguments[1] = regit_Complete;
	                
	                var SelectTarget = window.open("/admin/ezPersonal/selectTarget.do", "SelectTarget", GetOpenWindowfeature(840, 480));
	                
	                try { SelectTarget.focus(); } catch (e) {
	                }
	            } else {
	                var config = "status:false;dialogWidth:840px;dialogHeight:480px;scroll:no;status:no;edge:sunken" + GetShowModalPosition(840, 480);
	                var ret = window.showModalDialog("/admin/ezPersonal/selectTarget.do", g_attendant, config);
	
	                if (ret == undefined)
	                    return;
	
	                makePermissionsList(ret, false);
	            }
	        }
	
	        function regit_Complete(rtv) {
	            if (rtv == undefined) {
	                return;
	            }
	
	            makePermissionsList(rtv, false);
	        }
	
	        function makePermissionsList(value, xmlFalg) {
	            if (document.getElementById("AccessList").innerHTML != "") document.getElementById("AccessList").innerHTML = "";
	            g_attendant = { "DATA1": new Array(), "DATA2": new Array(), "DATA3": new Array(), "DATA5": new Array() };
	
	            if(xmlFalg) {
	                var xmldom = value;
	            } else {
	                var xmldom = loadXMLString(value);
	            }
	            
	            var listview = new ListView();
	            listview.SetID("AccessListView");
	            listview.SetSelectFlag(false);
	            listview.SetMulSelectable(true);
	            listview.DataSource(document.getElementById("listviewheader"));
	            listview.SetHeightFree(true);
	            listview.DataBind("AccessList");
	            var xmldomNode = SelectNodes(xmldom, "NODES/NODE");
	            
	            for (var i = 0; i < xmldomNode.length; i++) {
	                g_attendant["DATA1"][i] = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME");
	                g_attendant["DATA2"][i] = SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2");
	                g_attendant["DATA3"][i] = SelectSingleNodeValue(xmldomNode[i], "ACCESSID");
	                g_attendant["DATA5"][i] = SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS");
	
	                var listTR = listview.AddRow(listview.GetRowCount());
	                var listTD = document.createElement("TD");
	                listTD.style.paddingBottom = "0px";
	                listTD.style.paddingTop = "0px";
	                
	                if (userLang == "2" && SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2") != "") {
	                    if (SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS") == "N") {
	                        var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                    } else {
	                        var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                    }
	                } else {
	                    if (SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS") == "N") {
	                        var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                    } else {
	                        var listTDText = document.createTextNode(SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                    }
	                }
	                
	                listTD.setAttribute("DATA", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                listTD.setAttribute("DATA2", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                listTD.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "ACCESSID"));
	                listTD.setAttribute("DATA5", SelectSingleNodeValue(xmldomNode[i], "PERMISSIONS"));
	                listTD.appendChild(listTDText);
	                listTR.appendChild(listTD);
	            }
	            
	            xmldomNode = null;
	            xmldom = null;
	
	            var listview2 = new ListView();
	            listview2.LoadFromID("AccessListView");
	            var InitTr2 = listview2.GetDataRows();
	
	            for (var i = 0; i < InitTr2.length; i++) {
	                if (InitTr2[i].childNodes[0].getAttribute("data5") == "N") {
	                    InitTr2[i].childNodes[0].style.color = "red";
	                }
	            }
	        }
	        
	        function btn_cancel() {
	            if (ReturnFunction != null) {
	                ReturnFunction();
	            }
	            
	            window.close();
	        }
	        
	        function radioClick(obj, type) {
	            if (type == "img") {
	                var imgCnt = document.getElementsByName("linktypeOption").length;
	                
	                for (var i = 0; i < imgCnt; i++) {
	                    if (document.getElementsByName("linktypeOption")[i].value == obj.id) {
	                        document.getElementsByName("linktypeOption")[i].checked = true;
	                        checkValue = document.getElementsByName("linktypeOption")[i].value;
	                        LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
	                    }
	                }
	            } else {
	                checkValue = obj.value;
	                LinkTypeURL = document.getElementById(checkValue).getAttribute("src");
	            }
	            console.log(LinkTypeURL);
	        }
	        
	        function btn_ok() {
	        	if (specialChk(document.getElementById("Title1").value) || specialChk(document.getElementById("Title2").value) ||  specialChk(document.getElementById("Title3").value)) {
			    	alert("<spring:message code='ezResource.special' />");
			    	return;
			    }
	        	
	        	//2018-08-03 김보미 - 한국어가 아닌 다른 언어설정일 경우 해당 언어에 맞게 필수입력되게끔 수정
	            /*if (document.getElementById("Title1").value.trim() == "") {
	                document.getElementById("Title1").focus();
	                alert("<spring:message code = 'ezPersonal.t1027' />");
	                return;
	            }*/
				var mainTitle = "";
				
				if (lang == "1") {
					mainTitle = "Title1";
					subTitle1 = "Title2";
					subTitle2 = "Title3";
					subTitle3 = "Title4";
				} else if (lang == "2") {
					mainTitle = "Title2";
					subTitle1 = "Title1";
					subTitle2 = "Title3";
					subTitle3 = "Title4";
				} else {
					mainTitle = "Title3";
					subTitle1 = "Title1";
					subTitle2 = "Title2";
					subTitle3 = "Title4";
				}
				
	            if (document.getElementById(mainTitle).value.trim() == "") {
	                document.getElementById(mainTitle).focus();
	                alert("<spring:message code = 'ezPersonal.t1027' />");
	                return;
	            }

	
	            if (document.getElementById("txtURL").value.trim() == "") {
	                document.getElementById("txtURL").focus();
	                alert("<spring:message code = 'ezPersonal.t87' />");
	                return;
	            }
	
	            //2018-08-03 김보미 - 한국어가 아닌 다른 언어설정일 경우 해당 언어에 맞게 필수입력되게끔 수정
	            /*if (document.getElementById("Title2").value.trim() == "") {
	                document.getElementById("Title2").value = document.getElementById("Title1").value;
	            }
	            
	            if (document.getElementById("Title3").value.trim() == "") {
	                document.getElementById("Title3").value = document.getElementById("Title1").value;
	            }*/
	            if (document.getElementById(subTitle1).value.trim() == "") {
	                document.getElementById(subTitle1).value = document.getElementById(mainTitle).value;
	            }
	            
	            if (document.getElementById(subTitle2).value.trim() == "") {
	                document.getElementById(subTitle2).value = document.getElementById(mainTitle).value;
	            }
	
	            if (document.getElementById(subTitle3).value.trim() == "") {
	                document.getElementById(subTitle3).value = document.getElementById(mainTitle).value;
	            }

	            SaveQuickLink();
	        }
	        
	        function SaveQuickLink() {
	            var xmlpara = createXmlDom();
	            var objNode;
	            var objNode2;
	            var objNode3;
	            objNode = createNodeInsert(xmlpara, objNode, "parameter");
	            
	            if(mode == "new") {
	                createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", guid);
	            } else {
	                createNodeAndInsertText(xmlpara, objNode, "pQuickLinkID", ArgQuickID);
	            }
	            
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName", document.getElementById("Title1").value);
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName2", document.getElementById("Title2").value);
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName3", document.getElementById("Title3").value);
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName4", document.getElementById("Title4").value);
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName5", "");
	            createNodeAndInsertText(xmlpara, objNode, "pQuickLinkName6", "");
	            createNodeAndInsertText(xmlpara, objNode, "pLinkType", checkValue);
	            createNodeAndInsertText(xmlpara, objNode, "pLinkTypeURL", LinkTypeURL);
	            createNodeAndInsertText(xmlpara, objNode, "pMode", mode);
	            createNodeAndInsertText(xmlpara, objNode, "pURL", document.getElementById("txtURL").value);
	            createNodeAndInsertText(xmlpara, objNode, "companyID", document.getElementById("ListCompany").value);
	
	            if (eval("chk_Full").checked == true) {
	                createNodeAndInsertText(xmlpara, objNode, "pSize", "FULL");
	            } else {
	                createNodeAndInsertText(xmlpara, objNode, "pSize", document.getElementById("txt_Width").value + ":" + document.getElementById("txt_Height").value);
	            }
	            
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var listviewSelected = listview.GetDataRows();
	            
	            if (listviewSelected != undefined) {
	                for (var nCnt1 = 0; nCnt1 < listviewSelected.length; nCnt1++) {
	                    objNode2 = createNodeAndAppandNode(xmlpara, objNode, objNode2, "node");
	                    createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data", listviewSelected[nCnt1].childNodes[0].getAttribute("data"));
	                    createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data1", listviewSelected[nCnt1].childNodes[0].getAttribute("data1"));
	                    createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data2", listviewSelected[nCnt1].childNodes[0].getAttribute("data2"));
	                    createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data5", listviewSelected[nCnt1].childNodes[0].getAttribute("data5"));
	                    
	                    if (mode == "new") {
	                        createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data6", guid);
	                    } else {
	                        createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "data6", ArgQuickID);
	                    }
	                    
	                    createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "value", getNodeText(listviewSelected[nCnt1].childNodes[0]));
	                    createNodeAndAppandNodeText(xmlpara, objNode2, objNode3, "mode", mode);
	
	                }
	            }
	
	            xmlhttp = null;
	            xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST", "/admin/ezPersonal/saveQuickLink.do", false);
	            xmlhttp.send(xmlpara);
	
	            if (xmlhttp != null && xmlhttp.readyState == 4) {
	                if (xmlhttp.status == 200) {
	                    alert("<spring:message code = 'ezPersonal.s2' />");
	                    if (ReturnFunction != null)
	                        ReturnFunction();
	                    window.close();
	                }
	                else {
	                    alert("<spring:message code = 'ezPersonal.t108' />");
	                }
	            }
	        }
	        function S4() {
	            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
	        }
	        function GetGUID() {
	            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
	        }
	        function rad_Select(obj)
	        {
	            if (obj.id == "chk_Full")
	                document.getElementById("div_Size").style.display = "none";
	            else
	                document.getElementById("div_Size").style.display = "";
	        }
	        
	        var g_xmlhttp = createXMLHttpRequest();
	        function CreateType() {
	            if (CrossYN() || (pNoneActiveX == "YES")) {
	                document.getElementById('mode').value = "PHOTO";
	                document.form.file1.click();
	            }
	            else {
	                
	                var ezUtil = new ActiveXObject("ezUtil.MiscFunc");
	                var filepath = ezUtil.OpenLoadDlg("Image Files\0*.jpg;*.gif;*.bmp;*.jpe;*.png;*.emf;*.wmf;*.jpeg;*.jfif;*.dib;*.rle;*.bmz;*.gfa;*.emz;*.pcx;\0All Files (*.*)\0*.*\0\0", "");
	                if (filepath == "") return;

	                var strBase64 = ezUtil.DownloadToBase64(filepath);
	                ezUtil = null;

	                var ezUtil = new ActiveXObject("ezUtil.ImageFunc");
	                var temp = ezUtil.GetImageSize(filepath);
	                ezUtil = null;

	                imageWidth = temp.split("*")[0];
	                imageHeight = temp.split("*")[1];

	                var strXML = "<IMAGE><DATA>" + strBase64 + "</DATA></IMAGE>";

	                g_xmlhttp = createXMLHttpRequest();
<%-- 	                g_xmlhttp.open("POST", "/myoffice/ezPersonal/QuickLink/aspx/TypeImage_upload.aspx?ComId=<%= ComId%>&QId=<%=guid %>", true); --%>
	                g_xmlhttp.onreadystatechange = changeNormalImage_end;
	                g_xmlhttp.send(strXML);
	            }
	        }
	        
	        function changeNormalImage_end() {
	            if (g_xmlhttp.readyState != 4) return;
	            
	            document.getElementById("makeTypeTable").style.display = "";
	            document.getElementById("makeTypeImgTD").innerHTML = "";
	            
	            var _img = document.createElement("IMG");
	            _img.src = g_xmlhttp.responseText;
	            _img.id = "ZmakeTypeImg";
	            _img.onclick = function(){ radioClick(this,'img') };
	            _img.style.cursor = "pointer";

	            document.getElementById("makeTypeImgTD").appendChild(_img);

	            document.getElementById("Z").checked = true;
	            checkValue = "Z";
	            LinkTypeURL = g_xmlhttp.responseText;

	        }
	        
	        function btn_AttachAdd_onclick() {
	            if (document.form.file1.value != "") {
	                if (document.getElementById('mode').value == "PHOTO") {
	                    if (document.getElementById("form").file1.files.length < 2) {
	                    }
	                    else
	                        alert("");
	                }
	                document.getElementById("cnt").value = document.getElementById("form").file1.files.length;
	                var frm = document.getElementById('form');
	                frm.action = "/admin/ezPersonal/typeImageUpload.do?QId=" + guid;

	                frm.submit();
	                document.form.file1.value = "";
	            }
	        }
	            
	        function returnvalue(strXML) {
	            var xml = loadXMLString(strXML);
	            var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
	            for (i = 0; i < nodes.length; i++) {
	                if (getNodeText(GetChildNodes(nodes[i])[1]) == "true") {
	                    document.getElementById("makeTypeTable").style.display = "";

	                    var path = getNodeText(GetChildNodes(nodes[i])[4]);

	                    document.getElementById("makeTypeTable").style.display = "";
	                    document.getElementById("makeTypeImgTD").innerHTML = "";


	                    var _img = document.createElement("IMG");
	                    _img.src = path;
	                    _img.id = "ZmakeTypeImg";
	                    _img.onclick = function () { radioClick(this, 'img') };
	                    _img.style.cursor = "pointer";

	                    document.getElementById("makeTypeImgTD").appendChild(_img);

	                    document.getElementById("Z").checked = true;
	                    checkValue = "Z";
	                    LinkTypeURL = path;

	                }
	            }
	        }
		</script>
	</head>
	<body class="popup">
		<xml id="listviewheader" style ="display:none"></xml>
	    <h1>Quick Link <spring:message code = 'ezPersonal.t105' /><spring:message code = 'ezPersonal.t169' /></h1>
	    <div id="close">
            <ul>
                <li><span onclick="btn_cancel()"></span></li>
            </ul>
        </div>
	    <span style="color:red"><spring:message code = 'ezPersonal.t00008' /></span>
	    <table class="content" style="height:300px;width:100%;">
	        <tr>
	            <th style="text-align:center"><spring:message code = 'ezPersonal.jjs03' /><span style="color:red">*</span></th>
	            <td colspan="2">
	                <table width="100%">
	                	<c:choose>
	                		<c:when test="${lang == '1'}">
	                			 <tr class="primary">
			                        <th><spring:message code = 'ezPersonal.s81' /></th>
			                        <td>
			                            <input name="Input" id="Title1" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value="" maxLength="50"></td>
			                    </tr>
			                    <tr class="primary">
			                        <th><spring:message code = 'ezPersonal.s82' /></th>
			                        <td>
			                            <input type="text" id="Title2" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value=""  maxLength="50"></td>
			                    </tr>
			                    <tr class="secondary">
			                        <th><spring:message code = 'ezPersonal.s84' /></th>
			                        <td>
			                            <input type="text" id="Title3" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value=""  maxLength="50"></td>
			                    </tr>
	                		</c:when>
	                		<c:when test="${lang == '2'}">
			                    <tr class="primary">
			                        <th><spring:message code = 'ezPersonal.s82' /></th>
			                        <td>
			                            <input type="text" id="Title2" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value=""  maxLength="50"/></td>
			                    </tr>
	                			<tr class="primary">
			                        <th><spring:message code = 'ezPersonal.s81' /></th>
			                        <td>
			                            <input name="Input" id="Title1" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value="" maxLength="50"></td>
			                    </tr>
			                    <tr class="secondary">
			                        <th><spring:message code = 'ezPersonal.s84' /></th>
			                        <td>
			                            <input type="text" id="Title3" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value=""  maxLength="50"/></td>
			                    </tr>
	                		</c:when>
	                		<c:otherwise>
			                    <tr class="primary">
			                        <th><spring:message code = 'ezPersonal.s84' /></th>
			                        <td>
			                            <input type="text" id="Title3" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value=""  maxLength="50"/></td>
			                    </tr>
	                			 <tr class="primary">
			                        <th><spring:message code = 'ezPersonal.s81' /></th>
			                        <td>
			                            <input name="Input" id="Title1" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value="" maxLength="50"></td>
			                    </tr>
			                    <tr class="secondary">
			                        <th><spring:message code = 'ezPersonal.s82' /></th>
			                        <td>
			                            <input type="text" id="Title2" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value=""  maxLength="50"/></td>
			                    </tr>
	                		</c:otherwise>
	                	</c:choose>
	                </table>
	            </td>
	        </tr>
	        <tr>
	            <th style="text-align:center" rowspan="2"><spring:message code = 'ezPersonal.t1023' /> Type <span style="color:red">*</span></th>
	            <td colspan="2">
	                <div>
	                    <table style="width:280px;margin-top:10px;">
	                        <tr style="text-align:center;">
	                            <td style="width:25%">
	                            	<c:choose>
										<c:when test="${host == 'gw.freet.co.kr'}">
											<img src='/images/kr/main/quickmenu_icon01.png' id="A" onclick="radioClick(this,'img')" style="cursor:pointer">		
										</c:when>
										<c:otherwise>
											<img src='/images/kr/main/quickmenu_icon01.gif' id="A" onclick="radioClick(this,'img')" style="cursor:pointer">
										</c:otherwise>
									</c:choose>
	                            </td>
	                            <td style="width:25%">
	                                <img src='/images/kr/main/quickmenu_icon02.gif' id="B" onclick="radioClick(this,'img')" style="cursor:pointer">
	                            </td>
	                            <td style="width:25%">
	                                <c:choose>
										<c:when test="${host == 'gw.freet.co.kr'}">
											<img src='/images/kr/main/quickmenu_icon03.png' id="C" onclick="radioClick(this,'img')" style="cursor:pointer">		
										</c:when>
										<c:otherwise>
											<img src='/images/kr/main/quickmenu_icon03.gif' id="C" onclick="radioClick(this,'img')" style="cursor:pointer">
										</c:otherwise>
									</c:choose>
	                            </td>
	                            <td style="width:25%">
	                            	<img src='/images/kr/main/quickmenu_icon04.gif' id="D" onclick="radioClick(this,'img')" style="cursor:pointer">
	                            </td>
	                        </tr>
	                        <tr style="text-align:center;">
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="A" onclick="radioClick(this,'rad')" style="margin-top:-5px;" checked/>
	                            </td>
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="B" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="C" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="D" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                        </tr>
	                        <tr style="text-align:center;">
	                            <td style="width:25%">
	                                <img src='/images/kr/main/quickmenu_icon05.gif' id="E" onclick="radioClick(this,'img')" style="cursor:pointer">
	                            </td>
	                            <td style="width:25%">
	                                <img src='/images/kr/main/quickmenu_icon06.gif' id="F" onclick="radioClick(this,'img')" style="cursor:pointer">
	                            </td>
	                            <td style="width:25%">
	                            	<c:choose>
										<c:when test="${host == 'gw.freet.co.kr'}">
											<img src='/images/kr/main/quickmenu_icon07.png' id="G" onclick="radioClick(this,'img')" style="cursor:pointer">		
										</c:when>
										<c:otherwise>
											<img src='/images/kr/main/quickmenu_icon07.gif' id="G" onclick="radioClick(this,'img')" style="cursor:pointer">
										</c:otherwise>
									</c:choose>
	                            </td>
	                            <td style="width:25%">
	                                <img src='/images/kr/main/quickmenu_icon08.gif' id="H" onclick="radioClick(this,'img')" style="cursor:pointer">
	                            </td>
	                        </tr>
	                        <tr style="text-align:center;">
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="E" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="F" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="G" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                            <td style="text-align:center;width:25%">
	                                <input name="linktypeOption" type="radio" value="H" onclick="radioClick(this, 'rad')" style="margin-top:-5px;"/>
	                            </td>
	                        </tr>
	                    </table>
	                </div>
	            </td>
	        </tr>
	        
	        <tr>
            <td colspan="2">

                <table width="100%" border="0" cellspacing="0" cellpadding="0" style="height:80px;">
                    <tr>
                        <td>
                            <table style="margin-top: 10px; margin-left: 10px;display:none;" id="makeTypeTable">
                                <tr style="text-align: center;">
                                    <td id="makeTypeImgTD">
                                    </td>
                                </tr>
                                <tr style="text-align: center;">
                                    <td style="text-align: center;">
                                        <input name="linktypeOption" type="radio" value="Z" id="Z" onclick="radioClick(this, 'rad')" style="margin-top: -5px;" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="100%" align="center" nowrap>
                            <a class="imgbtn imgbck"><span onclick="CreateType()" title="40x39 (jpg,gif,png)">Type<spring:message code = 'ezPersonal.t105'/>
                            </span></a>
                        </td>
                    </tr>
                </table>

            </td>
        	</tr>
        
	        <tr>
	            <th style="text-align:center">URL <span style="color:red">*</span></th>
	            <td colspan="2">
	                <input type="text" id="txtURL" style="WIDTH: 100%;-moz-box-sizing:border-box;box-sizing:border-box;" value="" maxLength="512"/>
	            </td>
	        </tr>
	        <tr>
	            <th style="text-align:center">PopUp Size</th>
	            <td colspan="2" style="padding-top:5px;">
	                <input type="radio" id="chk_Full" name="radio" style="margin-top:-5px;" onclick="rad_Select(this)" checked/>FULL
	                <input type="radio" id="chk_Size" name="radio" style="margin-top:-5px;" onclick="rad_Select(this)" />SIZE &nbsp;&nbsp;&nbsp;&nbsp; 
	                <span id="div_Size" style="display:none">Width : <input type="text" id="txt_Width" style="width:30px;" />&nbsp; Height : <input type="text" id="txt_Height" style="width:30px;" /></span>
	            </td>
	        </tr>
	        <tr>
	            <th><a class="imgbtn"><span onclick="regit()"><spring:message code = 'ezPersonal.t1029' /></span></a></th>
	            <td colspan="2" style="padding:0px;">
	                <div class="listview" style="height:150px;overflow-y:auto;overflow-x:hidden;border-bottom:0px;" id="AccessList">
	                </div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	        <a class="imgbtn"><span id="btn_OK" onclick="btn_ok()"><spring:message code = 'ezPersonal.t105' /></span></a>	        
	    </div>
	    
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
    	<form method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezPersonal/typeImageUpload.do?guid=" target="ifrm" style ="display:none">
	        <input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px;" multiple="true" />
	        <input type="hidden" name="boardid" id="boardid" />
	        <input type="hidden" name="maxsize" id="maxsize" />
	        <input type="hidden" name="mode" id="mode" value="PHOTO"/>
	        <input type="hidden" name="cnt" id="cnt" />
	        <input type="hidden" name="guid" id="guid"  />
	        <input type="hidden" name="mailgubun" id="mailgubun" />
    	</form>
	</body>
</html>