<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezBoard.t75" /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href='<spring:message code="ezBoard.i1" />' type="text/css" />
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>    
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">
			var pBoardID = "${boardID}";
	        var pParentBoardID = "${parentBoardID}";
	        var strList = "${strList}";
	        var userLang = "${strUserLang}";
	        var pBoardName = "${pBoardName}";
	        var pType = "${pType}";
	        var pParentNeed = "${pParentNeed}";
	        var selectedTargetID = "";
	        var selectedTargetName = "";
	        var selectedTargetName2 = "";
	        var selectTargetListXML = "";
	        
	        document.onselectstart = function () {
	            if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA"){
	                return false;
	            }else{
	                return true;
	            }
	        };
	        
			$(document).ready(function(){			
				FillAccessList();	
			});
			
			function FillAccessList() {            
	            var xmldom = loadXMLString(strList);
	            var listTR, listTD, listTDText;
	            var listview = new ListView();
	            listview.SetID("AccessListView");
	            listview.SetMulSelectable(true);
	            listview.SetRowOnClick("AccessList_onDblclick");
	            
	            if (CrossYN()){
	                listview.DataSource(document.getElementById("listviewheader"));
	            }else{
	                listview.DataSource(loadXMLString(document.getElementById("listviewheader").xml.trim()));
	            }
	            listview.DataBind("AccessList");
	            var xmldomNode = SelectNodes(xmldom, "DATA/ROW")

	            if (userLang == "2") {
	                for (i = 0; i < xmldomNode.length; i++) {
	                    listTR = listview.AddRow(listview.GetRowCount());
	                    
	                    for (j = 4; j < SelectNodes(xmldom, "DATA/ROW")[i].childNodes.length; j++) {
	                        listTD = document.createElement("TD");
	                        
	                        if (getNodeText(xmldomNode[i].childNodes[j]) == "true"){
	                            listTDText = document.createTextNode("●");
	                        }else if (getNodeText(xmldomNode[i].childNodes[j]) == "false"){
	                            listTDText = document.createTextNode("");
	                        }else if (getNodeText(xmldomNode[i].childNodes[j]) == "" || getNodeText(xmldomNode[i].childNodes[j]) == null){
	                            listTDText = document.createTextNode("");
	                        }else {
	                            if (getNodeText(xmldomNode[i].childNodes[j]) == "1"){
	                                listTDText = document.createTextNode("●");
	                            }else if (getNodeText(xmldomNode[i].childNodes[j]) == "0"){
	                                listTDText = document.createTextNode("");
	                            }else{
	                                listTDText = document.createTextNode(getNodeText(xmldomNode[i].childNodes[j]));
	                            }
	                        }
	                        if (j == 7){
	                            j = 12;
	                        }
	                        if (j >= 13){
	                            listTD.setAttribute("style", "text-align:center;");
	                        }	                        
	                        listTD.appendChild(listTDText);
	                        listTR.appendChild(listTD);
	                        listTD = null;
	                        listTDText = null;
	                    }
	                    listTR.setAttribute("DATA", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                    listTR.setAttribute("DATA2", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                    listTR.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "ACCESSID"));
	                    listTR.setAttribute("DATA3", SelectSingleNodeValue(xmldomNode[i], "BOARDGROUPACL"));
	                    listTR = null;
	                }
	            }else{  	
	                for (i = 0; i < xmldomNode.length; i++) {
	                    listTR = listview.AddRow(listview.GetRowCount());                    
	                    for (j = 0; j < SelectNodes(xmldom, "DATA/ROW")[i].childNodes.length; j++) {
	                        listTD = document.createElement("TD");

	                        if (getNodeText(xmldomNode[i].childNodes[j]) == "true"){
	                            listTDText = document.createTextNode("●");
	                        }else if (getNodeText(xmldomNode[i].childNodes[j]) == "false"){
	                            listTDText = document.createTextNode("");
	                        }else if (getNodeText(xmldomNode[i].childNodes[j]) == "" || getNodeText(xmldomNode[i].childNodes[j]) == null){
	                            listTDText = document.createTextNode("");
	                        }else {
	                            if (getNodeText(xmldomNode[i].childNodes[j]) == "1"){
	                                listTDText = document.createTextNode("●");
	                            }else if (getNodeText(xmldomNode[i].childNodes[j]) == "0"){
	                                listTDText = document.createTextNode("");
	                            }else{
	                                listTDText = document.createTextNode(getNodeText(xmldomNode[i].childNodes[j]));
	                            }
	                        }
	                        if (j == 3){
	                            j = 11;
	                        }
	                        if (j >= 12){
	                            listTD.setAttribute("style", "text-align:center;");
	                        }
	                        listTD.appendChild(listTDText);
	                        listTR.appendChild(listTD);
	                        listTD = null;
	                        listTDText = null;
	                    }	           
	                    
	                    listTR.setAttribute("DATA", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME"));
	                    listTR.setAttribute("DATA2", SelectSingleNodeValue(xmldomNode[i], "ACCESSNAME2"));
	                    listTR.setAttribute("DATA1", SelectSingleNodeValue(xmldomNode[i], "ACCESSID"));
	                    listTR.setAttribute("DATA3", SelectSingleNodeValue(xmldomNode[i], "BOARDGROUPACL"));
	                    listTR = null;
	                }
	            }
	            xmldomNode = null;
	            xmldom = null;
	        }			
			var _type;
	        function AccessList_onDblclick(para) {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");

	            var selnode = listview.GetSelectedRows();
	            _type = true;
	            if (selnode != null) {
	                selectTargetListXML = "<DATA>";

	                if (selnode.length == 1) {
	                    if (CrossYN()){
	                        selectedTarget.textContent = selnode[0].cells[2].textContent;
	                    }else{
	                        selectedTarget.innerText = selnode[0].cells[2].innerText;
	                    }
	                    selectedTargetID = selnode[0].getAttribute("data1")
	                    selectedTargetName = selnode[0].getAttribute("data")
	                    selectedTargetName2 = selnode[0].getAttribute("data2")
	                    selectedTargetGroup = selnode[0].getAttribute("data3")
	                    
	                    if (para != "false") {
	                        FillACLTable();
	                    }
	                    selectTargetListXML += "<CN>" + selectedTargetID + "</CN>";
	                    selectTargetListXML += "<NAME><![CDATA[" + selectedTargetName + "]]></NAME>";
	                    selectTargetListXML += "<NAME2><![CDATA[" + selectedTargetName2 + "]]></NAME2>";
	                    selectTargetListXML += "<GROUP><![CDATA[" + selectedTargetGroup + "]]></GROUP>";
	                    
	                    if (selnode[0].cells[0].innerHTML == "" || selnode[0].cells[0].innerHTML == null){
	                        selectTargetListXML += "<DEPT><![CDATA[DEPT]]></DEPT>";
	                    }else{
	                        selectTargetListXML += "<DEPT><![CDATA[PERSON]]></DEPT>";
	                    }
	                }else{
	                    selectedTarget.innerText = "";

	                    for (var i = 0; i < selnode.length; i++) {
	                        if (CrossYN()) {
	                            if (i == 0) selectedTarget.textContent += selnode[i].cells[2].textContent;
	                            else selectedTarget.textContent += ", " + selnode[i].cells[2].textContent;
	                        }
	                        else {
	                            if (i == 0) selectedTarget.innerText += selnode[i].cells[2].innerText;
	                            else selectedTarget.innerText += ", " + selnode[i].cells[2].innerText;
	                        }
	                        selectedTargetID = selnode[i].getAttribute("data1")
	                        selectedTargetName = selnode[i].getAttribute("data")
	                        selectedTargetName2 = selnode[i].getAttribute("data2")
	                        selectedTargetGroup = selnode[i].getAttribute("data3")

	                        selectTargetListXML += "<CN>" + selectedTargetID + "</CN>";
	                        selectTargetListXML += "<NAME><![CDATA[" + selectedTargetName + "]]></NAME>";
	                        selectTargetListXML += "<NAME2><![CDATA[" + selectedTargetName2 + "]]></NAME2>";
	                        selectTargetListXML += "<GROUP><![CDATA[" + selectedTargetGroup + "]]></GROUP>";
	                        
	                        if (selnode[i].cells[0].innerHTML == "" || selnode[i].cells[0].innerHTML == null){
	                            selectTargetListXML += "<DEPT><![CDATA[DEPT]]></DEPT>";
	                        }else{
	                            selectTargetListXML += "<DEPT><![CDATA[PERSON]]></DEPT>";
	                        }
	                    }
	                }
	                selectTargetListXML += "</DATA>";
	            }
	        }	        
	        function FillACLTable() {
	            CheckBoxInit();

	            var xmlhttp = createXMLHttpRequest();
	            xmlhttp.open("POST","/admin/ezBoard/getACL.do?boardID=" + pBoardID + "&accessID=" + selectedTargetID, false);
	            xmlhttp.send();

	            var xmldom = createXmlDom();
	            xmldom.async = false;
	            xmldom.preserveWhiteSpace = true;

	            xmldom = loadXMLString(getXmlString(xmlhttp.responseXML));
	            xmlhttp = null;

	            if (CrossYN()) {
	                if (SelectNodes(xmldom, "NODES/NODE/ACCESS")[0].textContent == "1") {
	                    access_OK.checked = true;
	                } else {
	                    access_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/BOARDADMIN")[0].textContent == "true") {
	                    admin_OK.checked = true;
	                    PostSpan.style.display = "";
	                    PostNotice.checked = false;
	                } else {
	                    admin_NO.checked = true;
	                    PostSpan.style.display = "none";
	                    PostNotice.checked = false;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/LIST")[0].textContent == "true") {
	                    list_OK.checked = true;
	                } else {
	                    list_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/READ")[0].textContent == "true") {
	                    read_OK.checked = true;
	                } else {
	                    read_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/WRITE")[0].textContent == "true") {
	                    write_OK.checked = true;
	                } else {
	                    write_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/REPLY")[0].textContent == "true") {
	                    reply_OK.checked = true;
	                } else {
	                    reply_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/DELETE")[0].textContent == "true") {
	                    delete_OK.checked = true;
	                } else {
	                    delete_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/INHERIT")[0].textContent == "true") {
	                    inherit_OK.checked = true;
	                } else {
	                    inherit_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/POSTNOTICE")[0].textContent == "true") {
	                    PostNotice.checked = true;
	                } else {
	                    PostNotice.checked = false;
	                }
	            }else {
	                if (SelectNodes(xmldom, "NODES/NODE/ACCESS")[0].text == "1") {
	                    access_OK.checked = true;
	                } else {
	                    access_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/BOARDADMIN")[0].text == "true") {
	                    admin_OK.checked = true;
	                    PostSpan.style.display = "";
	                    PostNotice.checked = false;
	                } else {
	                    admin_NO.checked = true;
	                    PostSpan.style.display = "none";
	                    PostNotice.checked = false;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/LIST")[0].text == "true") {
	                    list_OK.checked = true;
	                } else {
	                    list_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/READ")[0].text == "true") {
	                    read_OK.checked = true;
	                } else {
	                    read_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/WRITE")[0].text == "true") {
	                    write_OK.checked = true;
	                } else {
	                    write_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/REPLY")[0].text == "true") {
	                    reply_OK.checked = true;
	                } else {
	                    reply_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/DELETE")[0].text == "true") {
	                    delete_OK.checked = true;
	                } else {
	                    delete_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/INHERIT")[0].text == "true") {
	                    inherit_OK.checked = true;
	                } else {
	                    inherit_NO.checked = true;
	                }
	                if (SelectNodes(xmldom, "NODES/NODE/POSTNOTICE")[0].text == "true") {
	                    PostNotice.checked = true;
	                } else {
	                    PostNotice.checked = false;
	                }
	            }
	            xmldom = null;

	            if (pParentBoardID == "top") {
	                list_OK.checked = false;
	                list_NO.checked = true;
	                read_OK.checked = false
	                read_NO.checked = true;
	                write_OK.checked = false;
	                write_NO.checked = true;
	                reply_OK.checked = false;
	                reply_NO.checked = true;
	                delete_OK.checked = false;
	                delete_NO.checked = true;
	                PostNotice.checked = false;
	            }
	        }	        
	        function CheckBoxInit() {
	            admin_OK.checked = false;
	            access_OK.checked = false;
	            list_OK.checked = false;
	            read_OK.checked = false;
	            write_OK.checked = false;
	            reply_OK.checked = false;
	            delete_OK.checked = false;
	            inherit_OK.checked = false;
	            PostSpan.style.display = "none";
	            PostNotice.checked = false;
	            admin_NO.checked = false;
	            access_NO.checked = false;
	            list_NO.checked = false;
	            read_NO.checked = false;
	            write_NO.checked = false;
	            reply_NO.checked = false;
	            delete_NO.checked = false;
	            inherit_NO.checked = false;
	        }
	        function CheckBoxInit2() {
	            admin_OK.checked = false;
	            access_OK.checked = false;
	            list_OK.checked = false;
	            read_OK.checked = false;
	            write_OK.checked = false;
	            reply_OK.checked = false;
	            delete_OK.checked = false;
	            inherit_OK.checked = false;
	            PostSpan.style.display = "none";
	            PostNotice.checked = false;
	            admin_NO.checked = true;
	            access_NO.checked = true;
	            list_NO.checked = true;
	            read_NO.checked = true;
	            write_NO.checked = true;
	            reply_NO.checked = true;
	            delete_NO.checked = true;
	            inherit_NO.checked = true;
	        }
	        function checkbox_onclick(e) {
	            srcElementID = e.target.id;	            
	            toggle(srcElementID);
	            
	            if (srcElementID == "admin_OK" && admin_OK.checked) {
	            	PostSpan.style.display = "";
	                access_OK.checked = true;
	                list_OK.checked = true;
	                read_OK.checked = true;
	                write_OK.checked = true;
	                reply_OK.checked = true;
	                delete_OK.checked = true;                
	                access_NO.checked = false;
	                list_NO.checked = false;
	                read_NO.checked = false;
	                write_NO.checked = false;
	                reply_NO.checked = false;
	                delete_NO.checked = false;

	                if (pParentBoardID == "top") {
	                    list_OK.checked = false;
	                    list_NO.checked = true;
	                    read_OK.checked = false
	                    read_NO.checked = true;
	                    write_OK.checked = false;
	                    write_NO.checked = true;
	                    reply_OK.checked = false;
	                    reply_NO.checked = true;
	                    delete_OK.checked = false;
	                    delete_NO.checked = true;
	                    PostNotice.checked = false;
	                }
	                return;
	            }
	        }
	        function toggle(pSrcElementID) {
	            if (pSrcElementID == "inherit_OK" && inherit_OK.checked) inherit_NO.checked = false;
	            if (pSrcElementID == "inherit_OK" && inherit_OK.checked == false) inherit_NO.checked = true;
	            if (pSrcElementID == "admin_OK" && admin_OK.checked) admin_NO.checked = false;
	            if (pSrcElementID == "admin_OK" && admin_OK.checked == false) admin_NO.checked = true;
	            if (pSrcElementID == "access_OK" && access_OK.checked) access_NO.checked = false;
	            if (pSrcElementID == "access_OK" && access_OK.checked == false) access_NO.checked = true;
	            if (pSrcElementID == "list_OK" && list_OK.checked) list_NO.checked = false;
	            if (pSrcElementID == "list_OK" && list_OK.checked == false) list_NO.checked = true;
	            if (pSrcElementID == "read_OK" && read_OK.checked) read_NO.checked = false;
	            if (pSrcElementID == "read_OK" && read_OK.checked == false) read_NO.checked = true;
	            if (pSrcElementID == "write_OK" && write_OK.checked) write_NO.checked = false;
	            if (pSrcElementID == "write_OK" && write_OK.checked == false) write_NO.checked = true;
	            if (pSrcElementID == "reply_OK" && reply_OK.checked) reply_NO.checked = false;
	            if (pSrcElementID == "reply_OK" && reply_OK.checked == false) reply_NO.checked = true;
	            if (pSrcElementID == "delete_OK" && delete_OK.checked) delete_NO.checked = false;
	            if (pSrcElementID == "delete_OK" && delete_OK.checked == false) delete_NO.checked = true;
	            if (pSrcElementID == "inherit_NO" && inherit_NO.checked) inherit_OK.checked = false;
	            if (pSrcElementID == "inherit_NO" && inherit_NO.checked == false) inherit_OK.checked = true;
	            if (pSrcElementID == "admin_NO" && admin_NO.checked) {
	                admin_OK.checked = false;
	                PostSpan.style.display = "none";
	                PostNotice.checked = false;
	            }
	            if (pSrcElementID == "admin_NO" && admin_NO.checked == false) {
	                admin_OK.checked = true;
	                PostSpan.style.display = "";
	                PostNotice.checked = false;
	            }
	            if (pSrcElementID == "access_NO" && access_NO.checked) access_OK.checked = false;
	            if (pSrcElementID == "access_NO" && access_NO.checked == false) access_OK.checked = true;
	            if (pSrcElementID == "list_NO" && list_NO.checked) list_OK.checked = false;
	            if (pSrcElementID == "list_NO" && list_NO.checked == false) list_OK.checked = true;
	            if (pSrcElementID == "read_NO" && read_NO.checked) read_OK.checked = false;
	            if (pSrcElementID == "read_NO" && read_NO.checked == false) read_OK.checked = true;
	            if (pSrcElementID == "write_NO" && write_NO.checked) write_OK.checked = false;
	            if (pSrcElementID == "write_NO" && write_NO.checked == false) write_OK.checked = true;
	            if (pSrcElementID == "reply_NO" && reply_NO.checked) reply_OK.checked = false;
	            if (pSrcElementID == "reply_NO" && reply_NO.checked == false) reply_OK.checked = true;
	            if (pSrcElementID == "delete_NO" && delete_NO.checked) delete_OK.checked = false;
	            if (pSrcElementID == "delete_NO" && delete_NO.checked == false) delete_OK.checked = true;
	            if (pParentBoardID == "top") {
	                list_OK.checked = false;
	                list_NO.checked = true;
	                read_OK.checked = false
	                read_NO.checked = true;
	                write_OK.checked = false;
	                write_NO.checked = true;
	                reply_OK.checked = false;
	                reply_NO.checked = true;
	                delete_OK.checked = false;
	                delete_NO.checked = true;
	                PostNotice.checked = false;
	            }
	            if (access_NO.checked) {
	                read_OK.checked = false;
	                list_OK.checked = false;
	                access_OK.checked = false;
	                reply_OK.checked = false;
	                write_OK.checked = false;
	                delete_OK.checked = false;
	                read_NO.checked = true;
	                list_NO.checked = true;
	                access_NO.checked = true;
	                reply_NO.checked = true;
	                write_NO.checked = true;
	                delete_NO.checked = true;
	            }
	            if (reply_OK.checked) {
	                read_OK.checked = true;
	                list_OK.checked = true;
	                access_OK.checked = true;
	                read_NO.checked = false;
	                list_NO.checked = false;
	                access_NO.checked = false;
	            }
	            if (read_OK.checked) {
	                list_OK.checked = true;
	                access_OK.checked = true;
	                list_NO.checked = false;
	                access_NO.checked = false;
	            }
	            if (write_OK.checked) {
	                list_OK.checked = true;
	                access_OK.checked = true;
	                list_NO.checked = false;
	                access_NO.checked = false;
	            }
	        }
	        var selecttarget_cross_dialogArguments = new Array();
	        function SelectTarget() {
	            var receiverData = new Array();
	            receiverData["window"] = this;
	            receiverData["selectTargetListXML"] = selectTargetListXML;
	            
	            if (CrossYN()) {
	                selecttarget_cross_dialogArguments[0] = receiverData;
	                selecttarget_cross_dialogArguments[1] = SelectTarget_Complete;
	                var SelectTarget_Cross = window.open("/admin/ezBoard/selectTarget.do", "SelectTarget_Cross", GetOpenWindowfeature(800, 520));
	                try { SelectTarget_Cross.focus(); } catch (e) {}
	            }else{
	                var config = "status:false;dialogWidth:800px;dialogHeight:520px;scroll:no;status:no;edge:sunken"
	                config = config + GetShowModalPosition(800, 520);
	                var ret = window.showModalDialog("/admin/ezBoard/selectTarget.do", receiverData, config);
	                _type = false;
	                
	                if (typeof (ret) != "undefined") {
	                    selectTargetListXML = ret;
	                    if (admin_OK.checked == false && admin_NO.checked == false) {
	                        CheckBoxInit2();
	                    }
	                }
	                if (selectTargetListXML == "" || selectTargetListXML == "<DATA></DATA>") {
	                    CheckBoxInit();
	                }
	            }
	        }
	        function SelectTarget_Complete(ret) {
	            _type = false;
	            if (typeof (ret) != "undefined") {
	                selectTargetListXML = ret;
	                if (admin_OK.checked == false && admin_NO.checked == false) {
	                    CheckBoxInit2();
	                }
	            }
	            if (selectTargetListXML == "" || selectTargetListXML == "<DATA></DATA>") {
	                CheckBoxInit();
	            }
	        }
	        function SaveACL() {
	            if (selectTargetListXML == "") {
	                alert("<spring:message code='ezBoard.t600'/>")
	                return;
	            }
	            if (_type){
	                AccessList_onDblclick("false");
	            }	            
	            var xmldom2 = loadXMLString(selectTargetListXML);
	            var xmlhttp = createXMLHttpRequest();
	            for (var i = 0; i < xmldom2.getElementsByTagName("CN").length; i++) {
	                var strXML = "";
	                strXML += "<NODES>";
	                strXML += "<NODE>";
	                if (CrossYN()) {
	                    strXML += "<TARGETID>" + xmldom2.getElementsByTagName("CN")[i].textContent + "</TARGETID>";
	                    strXML += "<TARGETNAME>" + MakeXMLString(xmldom2.getElementsByTagName("NAME")[i].textContent) + "</TARGETNAME>";
	                    strXML += "<TARGETNAME2>" + MakeXMLString(xmldom2.getElementsByTagName("NAME2")[i].textContent) + "</TARGETNAME2>";
	                    strXML += "<TARGETGROUP>" + MakeXMLString(xmldom2.getElementsByTagName("GROUP")[i].textContent) + "</TARGETGROUP>";
	                }else{
	                    strXML += "<TARGETID>" + xmldom2.getElementsByTagName("CN").item(i).text + "</TARGETID>";
	                    strXML += "<TARGETNAME>" + MakeXMLString(xmldom2.getElementsByTagName("NAME").item(i).text) + "</TARGETNAME>";
	                    strXML += "<TARGETNAME2>" + MakeXMLString(xmldom2.getElementsByTagName("NAME2").item(i).text) + "</TARGETNAME2>";
	                    strXML += "<TARGETGROUP>" + MakeXMLString(xmldom2.getElementsByTagName("GROUP").item(i).text) + "</TARGETGROUP>";
	                }
	                strXML += "<BOARDID>" + pBoardID + "</BOARDID>";
	                strXML += "<PARENTBOARDID>" + pParentBoardID + "</PARENTBOARDID>";
	                strXML += "<INHERIT>" + inherit_OK.checked + "</INHERIT>";
	                strXML += "<ADMIN>" + admin_OK.checked + "</ADMIN>";
	                strXML += "<ACCESSLEVEL>" + "${pAccessLevel}" + "</ACCESSLEVEL>";
	                strXML += "<ACCESS>" + access_OK.checked + "</ACCESS>";
	                strXML += "<LIST>" + list_OK.checked + "</LIST>";
	                strXML += "<READ>" + read_OK.checked + "</READ>";
	                strXML += "<WRITE>" + write_OK.checked + "</WRITE>";
	                strXML += "<REPLY>" + reply_OK.checked + "</REPLY>";
	                strXML += "<DELETE>" + delete_OK.checked + "</DELETE>";
	                strXML += "<POSTNOTICE>" + PostNotice.checked + "</POSTNOTICE>";
	                strXML += "</NODE>";
	                strXML += "</NODES>";
	                xmldom = loadXMLString(strXML);

	                xmlhttp.open("POST", "/admin/ezBoard/saveACL.do", false);
	                xmlhttp.send(xmldom);
	            }
	            if (xmlhttp.responseText.indexOf("OK") > -1) {
	                alert("<spring:message code='ezBoard.t79'/>");
	            } else {
	                alert("<spring:message code='ezBoard.t80'/>");
	            }
	            xmldom = null;
	            xmlhttp = null;
	            window.location.reload();
	        }
	        function DeleteACL(type) {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var selnode = listview.GetSelectedRows();
	            
	            if (type == "one"){
	                selnode = listview.GetSelectedRows();
	            }else{
	                selnode = listview.GetDataRows();
	            }
	            if (selnode.length == 0 && type == "one") {
	                alert("<spring:message code='ezBoard.t601'/>");
	                return;
	            }
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objRoot, objRow, objNode;

	            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
	            for (var i = 0 ; i < selnode.length; i++) {
	                objRow = createNodeAndAppandNode(xmlpara, objRoot, objRow, "ROW");
	                objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "BOARDID", pBoardID);
	                objNode = createNodeAndAppandNodeText(xmlpara, objRow, objNode, "TARGETID", selnode[i].getAttribute("data1"));
	            }

	            xmlhttp.open("POST", "/admin/ezBoard/deleteACL.do", false);
	            xmlhttp.send(xmlpara);

	            if (xmlhttp.status == 200 && xmlhttp.responseText == "OK") {
	                alert("<spring:message code='ezBoard.t54'/>");
	            }
	            window.location.reload();
	        }
			function UnderBoardCopy() {
			    var listview = new ListView();
			    listview.LoadFromID("AccessListView");
			    var selnode = listview.GetSelectedRows();
			    
			    if (selnode.length == 0) {
			        alert("<spring:message code='ezBoard.t600'/>");
			        return;
			    }
			    var pheigth = window.screen.availHeight;
			    var pwidth = window.screen.availWidth;
			    pheigth = parseInt(pheigth) / 2;
			    pwidth = parseInt(pwidth) / 2;
			    pheigth = pheigth - 192;
			    pwidth = pwidth - 260;
			    window.open("/admin/ezBoard/boardUnderGroupCopy.do?boardID=" + pBoardID + "&parentBoardID=" + pParentBoardID, "", "height=170,width=350px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth, "");
			}
			function AclCopy() {
	            var listview = new ListView();
	            listview.LoadFromID("AccessListView");
	            var selnode = listview.GetSelectedRows();
	            
	            if (selnode.length == 0) {
	                alert('<spring:message code="ezBoard.t600"/>');
	                return;
	            }
	            var pheigth = window.screen.availHeight;
	            var pwidth = window.screen.availWidth;
	            pheigth = parseInt(pheigth) / 2;
	            pwidth = parseInt(pwidth) / 2;
	            pheigth = pheigth - 192;
	            pwidth = pwidth - 260;
	            window.open("/admin/ezBoard/boardAclList.do?boardID=" + pBoardID + "&parentBoardID=" + pParentBoardID, "", "height=655,width=700px, status = no, toolbar=no, menubar=no, location=no, resizable=1, top=" + pheigth + ",left = " + pwidth, "");
	        }
	    </script>
	</head>
	<c:if test="${pParentNeed == 'Y'}">
		<body class="mainbody">
	</c:if>
	<c:if test="${pParentNeed != 'Y'}">
		<body>
	</c:if>
		<xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
		    	<HEADERS>
		      		<HEADER>
		        		<TYPE>NONE</TYPE>
		        		<NAME><spring:message code='ezBoard.t39'/></NAME>
		        		<WIDTH>35</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>353</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
		        		<TYPE>NONE</TYPE>
		        		<NAME><spring:message code='ezBoard.t9'/></NAME>
		        		<WIDTH>35</WIDTH>
		        		<SORTABLE>TRUE</SORTABLE>
		        		<RESIZIBLE>TRUE</RESIZIBLE>
		        		<MINSIZE>10</MINSIZE>
		        		<MAXSIZE>353</MAXSIZE>
		        		<NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t11'/></NAME>
				        <WIDTH>35</WIDTH>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>353</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		      		<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t37'/></NAME>
				        <WIDTH>35</WIDTH>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>353</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t84'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t83'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t102'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t86'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t87'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t88'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t00051'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		        	<HEADER>
				        <TYPE>NONE</TYPE>
				        <NAME><spring:message code='ezBoard.t00052'/></NAME>
				        <WIDTH>20</WIDTH>
				        <STYLE>text-align:center</STYLE>
				        <SORTABLE>TRUE</SORTABLE>
				        <RESIZIBLE>TRUE</RESIZIBLE>
				        <MINSIZE>10</MINSIZE>
				        <MAXSIZE>190</MAXSIZE>
				        <NOWRAP>TRUE</NOWRAP>
		      		</HEADER>
		    	</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<c:if test="${pParentNeed == 'Y'}">	
	        <h1><spring:message code='ezBoard.t63'/></h1>
		</c:if>
		<c:if test="${pParentNeed != 'Y'}">
			<br />
		</c:if>
		<c:if test="${adminType == 'y'}">
			<div id="mainmenu">
	            <ul>
	                <li><span onclick="goBoardList()"><spring:message code='ezBoard.t72'/></span></li>
	            </ul>
	        </div>
		</c:if>
	    <script type="text/javascript">
		    try{
		        parent.document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t63'/>";
		    }catch(e){
		        document.getElementsByTagName("h1")[0].innerHTML = "<spring:message code='ezBoard.t63'/>";
		    }
		</script>   
		<table class="content">
			<tr>
		    	<th><spring:message code='ezBoard.t92'/></th>
		        <td class="point"><c:out value='${boardName}' /></td>
			</tr>
		</table>
		<br/>
		<div class="listview">
		    <div id="AccessList" style="BORDER: 0; HEIGHT: 250px; WIDTH: 100%; overflow:auto;"></div>
		</div>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="SelectTarget()"><spring:message code='ezBoard.t602'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="SaveACL()"><spring:message code='ezBoard.t98'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="DeleteACL('one')"><spring:message code='ezBoard.t89'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="DeleteACL('type')"><spring:message code='ezBoard.t603'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="AclCopy()"><spring:message code='ezBoard.t604'/></span></a>
		<a class="imgbtn" style="margin-top:5px;margin-bottom:5px;"><span onclick="UnderBoardCopy()"><spring:message code='ezBoard.t605'/></span></a>
		<br/>
		<table class="content" style="width:100%;">
			<tr style="display: none">
		        <th>
		        	<spring:message code='ezBoard.t93'/><br/>(<spring:message code='ezBoard.t94'/>)
		        </th>
		        <td>
		            <input type="checkbox" id="inherit_OK" onclick="checkbox_onclick(event)" />
		            <spring:message code='ezBoard.t95'/>
		            <input type="checkbox" id="inherit_NO" onclick="checkbox_onclick(event)" />
		            <spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th style="">
		            <spring:message code='ezBoard.t606'/>
		        </th>
		        <td style="vertical-align: middle;">
		            <span id="selectedTarget" style="vertical-align: middle;"></span>&nbsp;
		        </td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t84'/></th>
		        <td>
		            <input type="checkbox" id="admin_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="admin_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t100'/>
		            <span id="PostSpan">
		            	<input type="checkbox" id="PostNotice" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t101'/>
		            </span>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t83'/></th>
		        <td>
		            <input type="checkbox" id="access_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="access_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t102'/></th>
		        <td>
		            <input type="checkbox" id="list_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="list_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t86'/></th>
		        <td>
		            <input type="checkbox" id="read_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>
		            <input type="checkbox" id="read_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t87'/></th>
		        <td>
		            <input type="checkbox" id="write_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="write_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr id="replyTR">
		        <th><spring:message code='ezBoard.t88'/></th>
		        <td>
		            <input type="checkbox" id="reply_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="reply_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		    <tr>
		        <th><spring:message code='ezBoard.t103'/></th>
		        <td>
		            <input type="checkbox" id="delete_OK" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t99'/>	            
		            <input type="checkbox" id="delete_NO" onclick="checkbox_onclick(event)" />&nbsp;<spring:message code='ezBoard.t96'/>
				</td>
		    </tr>
		</table>
		<br/>
	</body>        
</html>