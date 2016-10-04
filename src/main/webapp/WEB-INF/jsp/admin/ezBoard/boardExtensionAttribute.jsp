<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t999029"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="<spring:message code='ezBoard.i1' />" type="text/css" />	        
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/ezBoard/ListView_list_admin.js"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>	    
		<script type="text/javascript" language="javascript">
			var pBoardID = "";
		    var pGubun = "";
		    var ChangedAdd = false;
		    var ChangedHeader = false;
		    var RetValue;
	    
			$(document).ready(function(){			
				try {
		            RetValue = parent.BoardExtension_dialogArguments[0];
		        } catch (e) {
		            try {
		                RetValue = opener.BoardExtension_dialogArguments[0];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }

		        pBoardID = RetValue[0];
		        pGubun = RetValue[1];

		        GetExtensionAttribute();

		        if (pGubun == "0" || pGubun == "1" || pGubun == "2" || pGubun == "5") {
		            GetBoardHeader(pBoardID);
		        } else {
		            document.getElementById("divListHeader").style.display = "none";
		            document.getElementById("btn_AddHeader").style.display = "none";
		        }
			});
			
			if(new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function() {
		            window.focus();
		        }
		    }
			
			function GetExtensionAttribute() {
		        $.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/admin/ezBoard/getAttribute.do",
		        	data : {boardID : pBoardID},
		        	success : function(result){
		        		if (document.getElementById("SelectList").innerHTML != "")
			                document.getElementById("SelectList").innerHTML = "";
		        		
		        		var headerData = createXmlDom();
			            headerData = loadXMLString(ExtensionList.innerHTML.toUpperCase());

			            if (result != "") {
			                if (CrossYN()) {			                	
			                    var xmlRtn = result.getElementsByTagName("ROWS")[0];
			                    var Node = headerData.importNode(xmlRtn, true);
			                    headerData.documentElement.appendChild(Node);
			                }
			                else {
			                    var xmlRtn = result.getElementsByTagName("ROWS")[0];       
			                    headerData.documentElement.appendChild(xmlRtn);
			                }
			            }

			            var pSelectList = new ListView();
			            pSelectList.SetID("lvSelectList");
			            pSelectList.SetMulSelectable(false);
			            pSelectList.SetHeightFree(true);
			            pSelectList.SetRowOnClick("OnSelChange_onclick");
			            pSelectList.SetSelectFlag(false);
			            pSelectList.DataSource(headerData);
			            pSelectList.DataBind("SelectList");
		        	}
		        });		      
		    }

		    function GetBoardHeader(boardid) {
		        $.ajax({
		        	type : "POST",
		        	dataType : "xml",
		        	url : "/admin/ezBoard/getBoardHeader.do",
		        	data : {colType : pGubun, boardID : boardid},
		        	success : function(result){
						if (document.getElementById("HeaderList").innerHTML != "")
						    document.getElementById("HeaderList").innerHTML = "";
						
						var headerData = createXmlDom();
						headerData = loadXMLString(XmlHeader.innerHTML.toUpperCase());
						
						if (result != "") {
						    if (CrossYN()) {
						        var xmlRtn = result.getElementsByTagName("ROWS")[0];
						        var Node = headerData.importNode(xmlRtn, true);
						        headerData.documentElement.appendChild(Node);
						    }
						    else {
						        var xmlRtn = result.getElementsByTagName("ROWS")[0];
						        headerData.documentElement.appendChild(xmlRtn);
						    }
						}
						
						var pSelectList = new ListView();
						pSelectList.SetID("lvXmlHeader");
						pSelectList.SetMulSelectable(false);
						pSelectList.SetHeightFree(true);
						pSelectList.SetRowOnClick("OnSelChange_onclick2");
						pSelectList.SetSelectFlag(false);
						pSelectList.DataSource(headerData);
						pSelectList.DataBind("HeaderList");	
		        	}
		        });
		    }

		    function OnSelChange_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("lvSelectList");

		        var tr = listview.GetSelectedRows();

		        if (tr.length != 0) {
		            if (CrossYN()) {
		                document.getElementById("txtNameKor").value = ConvMakeXMLString(tr[0].cells[0].textContent);
		                document.getElementById("txtNameEng").value = ConvMakeXMLString(tr[0].cells[1].textContent);

		                if (tr[0].cells[2].textContent == "Y")
		                    document.getElementById("chkRequired").checked = true;
		                else
		                    document.getElementById("chkRequired").checked = false;

		                radioType_onClick(tr[0].cells[3].textContent);
		                SetRadioVal("Type", tr[0].cells[3].textContent);
		                SetGubunList(tr[0].cells[4].textContent);
		            }
		            else {
		                document.getElementById("txtNameKor").value = ConvMakeXMLString(tr[0].cells[0].innerText);
		                document.getElementById("txtNameEng").value = ConvMakeXMLString(tr[0].cells[1].innerText);

		                if (tr[0].cells[2].innerText == "Y")
		                    document.getElementById("chkRequired").checked = true;
		                else
		                    document.getElementById("chkRequired").checked = false;

		                radioType_onClick(tr[0].cells[3].innerText);
		                SetRadioVal("Type", tr[0].cells[3].innerText);
		                SetGubunList(tr[0].cells[4].innerText);
		            }
		        }
		    }

		    function SetGubunList(pCassNo) {
		        document.getElementById("AddDel").style.display = "none";
		        document.getElementById("Gubun").innerHTML = "";

		        if (pCassNo.trim() != "") {
		            document.getElementById("Gubun").innerHTML = "<table style='width:400px' id='CAS_NO_LIST'><tr><td style='width:100%'><input type='text' id='cas_no1' name='cas_no1' style='width:90%' maxlength='50'>&nbsp;<input type='checkbox' id='DEL_FG1' name='DEL_FG1' /></td></tr></table>";
		            document.getElementById("AddDel").style.display = "";

		            for (var i = 1; i < (pCassNo.split("|").length + 1) ; i++) {
		                if (i > 1) {
		                    oRow = document.getElementById("CAS_NO_LIST").insertRow(-1);
		                    oRow.style.backgroundColor = "#FFFFFF";
		                    oCell01 = oRow.insertCell(-1);
		                    oCell01.align = "left";
		                    oCell01.valign = "middle";
		                    oCell01.innerHTML = "<input type=\"text\" id=\"cas_no" + i + "\" value= " + pCassNo.split("|")[(i - 1)] + " name=\"cas_no" + i + "\" style=\"width:90%\" maxlength=\"50\" />&nbsp;<input type=\"checkbox\" name=\"DEL_FG" + i + "\" id=\"DEL_FG" + i + "\" />"
		                }
		                else {
		                    document.getElementById("cas_no1").value = pCassNo.split("|")[(0)];
		                }
		            }
		            document.getElementById("cnt").value = pCassNo.split("|").length;
		        }
		    }

		    function OnSelChange_onclick2() {
		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetSelectedRows();

		        if (tr.length != 0) {
		            if (CrossYN()) {
		                document.getElementById("HeadName").innerHTML = tr[0].cells[0].textContent;
		                document.getElementById("HeadWidth").value = tr[0].cells[2].textContent;
		            }
		            else {
		                document.getElementById("HeadName").innerText = tr[0].cells[0].innerText;
		                document.getElementById("HeadWidth").value = tr[0].cells[2].innerText;
		            }
		        }
		    }

		    function radioType_onClick(pValue) {
		        if (pValue == "text") {
		            document.getElementById("AddDel").style.display = "none";
		            document.getElementById("Gubun").innerHTML = "";
		        }
		        else {
		            document.getElementById("Gubun").innerHTML = "<table style='width:400px' id='CAS_NO_LIST'><tr><td style='width:100%'><input type='text' id='cas_no1' name='cas_no1' style='width:90%' maxlength='50'>&nbsp;<input type='checkbox' id='DEL_FG1' name='DEL_FG1' /></td></tr></table>";
		            document.getElementById("AddDel").style.display = "";
		        }
		    }

		    function GetRadioVal(pObjectName) {
		        return document.getElementById(pObjectName).value;
		    }

		    function SetRadioVal(pObjectName, p_strVal) {
		        document.getElementById(pObjectName).value = p_strVal;
		    }

		    function InitInput() {
		        document.getElementById("txtNameKor").value = "";
		        document.getElementById("txtNameEng").value = "";
		        SetRadioVal("Type", "");
		        document.getElementById("chkRequired").checked = false;
		        document.getElementById("AddDel").style.display = "none";
		        document.getElementById("Gubun").innerHTML = "";
		    }

		    function CheckValidation() {
		        if (document.getElementById("txtNameKor").value == "") {
		            alert("<spring:message code='ezBoard.t999044'/>");
		            document.getElementById("txtNameKor").focus();
		            return false;
		        }
		        if (document.getElementById("txtNameEng").value == "") {
		            alert("<spring:message code='ezBoard.t999045'/>");
		            document.getElementById("txtNameEng").focus();
		            return false;
		        }
		        if (GetRadioVal("Type") == "") {
		            alert("<spring:message code='ezBoard.t999046'/>");
		            return false;
		        }
		        var txtType = getGubun()
		        if (GetRadioVal("Type") == "radio") {
		            if (txtType == "") {
		                alert("<spring:message code='ezBoard.t999047'/>");
		                return false;
		            }
		            else if (txtType == "false") {
		                alert("<spring:message code='ezBoard.t999048'/>");
		                return false;
		            }
		        }
		        else if (GetRadioVal("Type") == "check") {
		            if (txtType == "") {
		                alert("<spring:message code='ezBoard.t999049'/>");
		                return false;
		            }
		            else if (txtType == "false") {
		                alert("<spring:message code='ezBoard.t999048'/>");
		                return false;
		            }
		            else if (txtType.indexOf(",") > -1) {
		                alert("<spring:message code='ezBoard.t999051'/>");
		                return false;
		            }
		        }

		        return true;
		    }

		    function getGubun() {
		        var ret = "";
		        var cnt = document.getElementById("cnt").value;
		        for (var i = 1; i < (cnt + 1) ; i++) {
		            if (document.getElementById("cas_no" + i)) {
		                if (document.getElementById("cas_no" + i).value.trim() != "") {
		                    if (document.getElementById("cas_no" + i).value.indexOf("|") > -1) {
		                        ret = "false ";
		                        break;
		                    }
		                    ret += document.getElementById("cas_no" + i).value.trim() + "|";
		                }
		            }
		        }
		        if (ret != "")
		            ret = ret.substring(0, ret.length - 1);

		        return ret;
		    }

		    function btn_Delete() {
		        var listview = new ListView();
		        listview.LoadFromID("lvSelectList");

		        var tr = listview.GetSelectedRows();

		        if (tr.length == 0) {
		            alert("<spring:message code='ezBoard.t999052'/>");
		            return;
		        }
		        ChangedAdd = true;
		        RemoveHeader(tr[0].cells[0].innerHTML);
		        listview.DeleteRow(tr[0].id);
		        InitInput();
		    }

		    function btn_Update() {
		        var listview = new ListView();
		        listview.LoadFromID("lvSelectList");

		        var tr = listview.GetSelectedRows();

		        if (tr.length == 0) {
		            alert("<spring:message code='ezBoard.t999053'/>");
		            return;
		        }

		        if (!CheckValidation()) {
		            return;
		        }

		        var txtGubun = getGubun();

		        EditHeader(tr[0].cells[0].innerHTML);

		        if (CrossYN()) {
		            tr[0].cells[0].textContent = document.getElementById("txtNameKor").value;
		            tr[0].cells[1].textContent = document.getElementById("txtNameEng").value;

		            if (document.getElementById("chkRequired").checked == true)
		                tr[0].cells[2].textContent = "Y";
		            else
		                tr[0].cells[2].textContent = "N";

		            tr[0].cells[3].textContent = GetRadioVal("Type");
		            tr[0].cells[4].textContent = txtGubun;
		        }
		        else {
		            tr[0].cells[0].innerText = document.getElementById("txtNameKor").value;
		            tr[0].cells[1].innerText = document.getElementById("txtNameEng").value;

		            if (document.getElementById("chkRequired").checked == true)
		                tr[0].cells[2].innerText = "Y";
		            else
		                tr[0].cells[2].innerText = "N";

		            tr[0].cells[3].innerText = GetRadioVal("Type");
		            tr[0].cells[4].innerText = txtGubun;
		        }
		        ChangedAdd = true;
		        alert("<spring:message code='ezBoard.t999054'/>");
		    }

		    function btncancel_onclick() {
		        if (ChangedAdd == true || ChangedHeader == true) {
		            if (confirm("<spring:message code='ezBoard.t999055'/>")) {
		                window.close();
		            }
		        }
		        else {
		            window.close();
		        }
		    }

		    function btn_add() {

		        var listview = new ListView();
		        listview.LoadFromID("lvSelectList");
		        var tr = listview.GetSelectedRows();
		        var InitTr = listview.GetDataRows();

		        if (InitTr.length > 4) {
		            alert("<spring:message code='ezBoard.t999056'/>");
		            return;
		        }

		        if (!CheckValidation()) {
		            return;
		        }

		        if (CheckDuplication(document.getElementById("txtNameKor").value, "lvSelectList", 0) == false) {
		            alert("<spring:message code='ezBoard.t999057'/>");
		            return;
		        }

		        var isExist;
		        for (var i = 6; i < 11; i++) {
		            isExist = false;
		            for (var k = 0; k < InitTr.length; k++) {
		                if (InitTr[k].getAttribute("DATA1") == "extensionAttribute" + i.toString()) {
		                    isExist = true;
		                    break;
		                }
		            }
		            if (isExist == false) {
		                break;
		            }
		        }
		        pTableCol = "extensionAttribute" + i.toString();

		        //필수항목여부
		        var chkRequired = "N";
		        if (document.getElementById("chkRequired").checked == true)
		            chkRequired = "Y";

		        var txtGubun = getGubun();

		        var pparsingXML = "<LISTVIEWDATA><ROWS><ROW>";
		        pparsingXML += "<CELL><VALUE><![CDATA[" + document.getElementById("txtNameKor").value + "]]></VALUE><DATA1>" + pTableCol + "</DATA1></CELL>"; //항목명(한글)
		        pparsingXML += "<CELL><VALUE><![CDATA[" + document.getElementById("txtNameEng").value + "]]></VALUE></CELL>"; //항목명(영어)
		        pparsingXML += "<CELL><VALUE><![CDATA[" + chkRequired + "]]></VALUE></CELL>"; //필수항목여부
		        pparsingXML += "<CELL><VALUE><![CDATA[" + GetRadioVal("Type") + "]]></VALUE></CELL>"; //항목타입
		        pparsingXML += "<CELL><VALUE><![CDATA[" + txtGubun + "]]></VALUE></CELL>"; //항목타입명
		        pparsingXML += "</ROW></ROWS></LISTVIEWDATA>";

		        var Resultxml = loadXMLString(pparsingXML);

		        var MaxID = 0;
		        var MaxCntNum = 0;

		        for (var j = 0  ; j < InitTr.length  ; j++) {
		            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		            if (MaxID < curnum) {
		                MaxID = curnum;
		                MaxCntNum = j;
		            }
		        }

		        var objTr = listview.AddRow(InitTr.length);
		        if (MaxCntNum != 0)
		            MaxCntNum = MaxCntNum + 1;
		        SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
		        listview.AddDataRow(objTr, Resultxml);

		        ChangedAdd = true;
		        InitInput();
		    }

		    function btn_MoveUp() {
		        var pSelectList = new ListView();
		        pSelectList.SetID("lvXmlHeader");

		        if (pSelectList.GetSelectedRows().length > 0) {
		            ChangedHeader = true;
		            pSelectList.RowMoveUp();
		        }
		    }

		    function btn_MoveDown() {
		        var pSelectList = new ListView();
		        pSelectList.SetID("lvXmlHeader");
		        
		        if (pSelectList.GetSelectedRows().length > 0) {
		            ChangedHeader = true;
		            pSelectList.RowMoveDown();
		        }
		    }

		    function btn_Remove() {
		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetSelectedRows();

		        if (tr.length == 0) {
		            alert("<spring:message code='ezBoard.t999058'/>");
		            return;
		        }

		        for (var i = 0; i < tr.length; i++) {
		            ChangedHeader = true;
		            listview.DeleteRow(tr[i].id);
		        }
		    }

		    function RemoveHeader(pHeader) {
		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetDataRows();

		        for (var i = 0; i < tr.length; i++) {
		            if (tr[i].cells[0].innerHTML == pHeader) {
		                ChangedHeader = true;
		                listview.DeleteRow(tr[i].id);
		            }
		        }
		    }

		    function EditHeader(pHeader) {
		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetDataRows();

		        for (var i = 0; i < tr.length; i++) {
		            if (tr[i].cells[0].innerHTML == pHeader) {
		                ChangedHeader = true;
		                if (CrossYN()) {
		                    tr[i].cells[0].textContent = document.getElementById("txtNameKor").value;
		                    tr[i].cells[1].textContent = document.getElementById("txtNameEng").value;
		                }
		                else {
		                    tr[i].cells[0].innerText = document.getElementById("txtNameKor").value;
		                    tr[i].cells[1].innerText = document.getElementById("txtNameEng").value;
		                }
		            }
		        }
		    }

		    function btn_Init() {
		        GetExtensionAttribute();
		        InitInput();
		    }

		    function btn_InitHeader() {
		        ChangedHeader = true;
		        GetBoardHeader("reset");
		    }

		    function btn_EditWidth() {
		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetSelectedRows();

		        if (tr.length == 0) {
		            alert("<spring:message code='ezBoard.t999053'/>");
		            return;
		        }

		        if (document.getElementById("HeadWidth").value == "") {
		            alert("<spring:message code='ezBoard.t999059'/>");
		            document.getElementById("HeadWidth").focus();
		            return;
		        }

		        var intRegex = /[0-9 -()+]+$/;
		        if (intRegex.test(document.getElementById("HeadWidth").value) != true) {
		            alert("<spring:message code='ezBoard.t999060'/>");
		            document.getElementById("HeadWidth").focus();
		            return;
		        }

		        if (CrossYN()) {
		            tr[0].cells[2].textContent = document.getElementById("HeadWidth").value;
		        }
		        else {
		            tr[0].cells[2].innerText = document.getElementById("HeadWidth").value;
		        }

		        ChangedHeader = true;
		        alert("<spring:message code='ezBoard.t999054'/>");
		    }

		    function btn_AddHeader() {

		        var listview2 = new ListView();
		        listview2.LoadFromID("lvSelectList");

		        var tr2 = listview2.GetSelectedRows();

		        if (tr2.length == 0) {
		            alert("<spring:message code='ezBoard.t999061'/>");
		            return;
		        }

		        if (CheckDuplication(tr2[0].cells[0].innerHTML, "lvXmlHeader", 0) == false) {
		            alert("<spring:message code='ezBoard.t999057'/>");
		            return;
		        }

		        if (tr2[0].getAttribute("DATA1") == "") {
		            alert("<spring:message code='ezBoard.t999062'/>");
		            return
		        }

		        var pparsingXML = "<LISTVIEWDATA><ROWS><ROW>";
		        if (CrossYN()) {
		            pparsingXML += "<CELL><VALUE><![CDATA[" + tr2[0].cells[0].textContent + "]]></VALUE><DATA1>" + tr2[0].getAttribute("DATA1") + "</DATA1></CELL>"; //항목명(한글)
		            pparsingXML += "<CELL><VALUE><![CDATA[" + tr2[0].cells[1].textContent + "]]></VALUE></CELL>"; //항목명(영어)
		            pparsingXML += "<CELL><VALUE><![CDATA[80]]></VALUE></CELL>"; //기본 width 80
		        }
		        else {
		            pparsingXML += "<CELL><VALUE><![CDATA[" + tr2[0].cells[0].innerText + "]]></VALUE><DATA1>" + tr2[0].getAttribute("DATA1") + "</DATA1></CELL>"; //항목명(한글)
		            pparsingXML += "<CELL><VALUE><![CDATA[" + tr2[0].cells[1].innerText + "]]></VALUE></CELL>"; //항목명(영어)
		            pparsingXML += "<CELL><VALUE><![CDATA[80]]></VALUE></CELL>"; //기본 width 80
		        }
		        pparsingXML += "</ROW></ROWS></LISTVIEWDATA>";

		        var Resultxml = loadXMLString(pparsingXML);

		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");
		        var tr = listview.GetSelectedRows();
		        var InitTr = listview.GetDataRows();

		        var MaxID = 0;
		        var MaxCntNum = 0;

		        for (var j = 0  ; j < InitTr.length  ; j++) {
		            var curnum = Number(listview.GetSelectedRowID(j).substring(listview.GetSelectedRowID(j).lastIndexOf('_') + 1), listview.GetSelectedRowID(j).length);
		            if (MaxID < curnum) {
		                MaxID = curnum;
		                MaxCntNum = j;
		            }
		        }

		        var objTr = listview.AddRow(InitTr.length);
		        if (MaxCntNum != 0)
		            MaxCntNum = MaxCntNum + 1;
		        SetAttribute(objTr, "id", listview.GetSelectedRowID(MaxCntNum).substring(0, listview.GetSelectedRowID(MaxCntNum).lastIndexOf('_') + 1) + eval(MaxID + 1));
		        listview.AddDataRow(objTr, Resultxml);

		        ChangedHeader = true;
		        alert("<spring:message code='ezBoard.t999063'/>")
		    }

		    function CheckDuplication(pString, pID, pCell) {
		        var listview = new ListView();
		        listview.LoadFromID(pID);

		        var tr = listview.GetDataRows();

		        var ret = true;
		        for (var i = 0; i < tr.length; i++) {
		            if (tr[i].cells[pCell].innerHTML == pString) {
		                ret = false;
		                break;
		            }
		        }
		        return ret;
		    }

		    function MakeXMLString(pOrgString) {
		        return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
		    }

		    function btnOK_onclick() {
		        if (ChangedAdd) {
		            if (!CheckExtensionList()) {
		                alert("<spring:message code='ezBoard.t999062'/>");
		                return;
		            }

		            var listview = new ListView();
		            listview.LoadFromID("lvSelectList");
		            var tr = listview.GetDataRows();

		            var xmlpara = createXmlDom();
		            var xmlhttp = createXMLHttpRequest();

		            var objRoot;
		            objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
		            createNodeAndInsertText(xmlpara, objRoot, "BOARDID", pBoardID);

		            for (var i = 0; i < tr.length; i++) {
		                if (CrossYN()) {
		                    createNodeAndInsertText(xmlpara, objRoot, "COLNAME1", MakeXMLString(tr[i].cells[0].textContent));
		                    createNodeAndInsertText(xmlpara, objRoot, "COLNAME2", MakeXMLString(tr[i].cells[1].textContent));
		                    createNodeAndInsertText(xmlpara, objRoot, "VALUE", MakeXMLString(tr[i].cells[4].textContent));
		                    createNodeAndInsertText(xmlpara, objRoot, "COLTYPE", tr[i].cells[3].textContent);
		                    createNodeAndInsertText(xmlpara, objRoot, "MUST", tr[i].cells[2].textContent);
		                } else {
		                    createNodeAndInsertText(xmlpara, objRoot, "COLNAME1", MakeXMLString(tr[i].cells[0].innerText));
		                    createNodeAndInsertText(xmlpara, objRoot, "COLNAME2", MakeXMLString(tr[i].cells[1].innerText));
		                    createNodeAndInsertText(xmlpara, objRoot, "VALUE", MakeXMLString(tr[i].cells[4].innerText));
		                    createNodeAndInsertText(xmlpara, objRoot, "COLTYPE", tr[i].cells[3].innerText);
		                    createNodeAndInsertText(xmlpara, objRoot, "MUST", tr[i].cells[2].innerText);
		                }
		                createNodeAndInsertText(xmlpara, objRoot, "TABLECOL", tr[i].getAttribute("DATA1"));
		            }

		            xmlhttp.open("POST", "/admin/ezBoard/saveAttribute.do", false);
		            xmlhttp.send(xmlpara);

		            if (xmlhttp.responseText == "OK") {
		            	
		            } else {
		                alert("Error : " + xmlhttp.responseText);
		                return;
		            }
		        }

		        if (pGubun == "0" || pGubun == "1" || pGubun == "2" || pGubun == "5") {
		            if (ChangedHeader) {
		                if (SaveHeader() == "OK") {

		                } else {
		                    alert("Error : " + xmlhttp.responseText);
		                    return;
		                }
		            }
		        }

		        alert("<spring:message code='ezBoard.t79'/>")
		        window.close();
		    }

		    function SaveHeader() {
		        var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");
		        var tr = listview.GetDataRows();

		        var xmlpara = createXmlDom();
		        var xmlhttp = createXMLHttpRequest();

		        var objRoot;
		        objRoot = createNodeInsert(xmlpara, objRoot, "DATA");
		        createNodeAndInsertText(xmlpara, objRoot, "BOARDID", pBoardID);

		        //ITEMID는 필수.
		        createNodeAndInsertText(xmlpara, objRoot, "NAME1", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "NAME2", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "WIDTH", "20");
		        createNodeAndInsertText(xmlpara, objRoot, "COLNAME", "ITEMID");

		        for (var i = 0; i < tr.length; i++) {
		            if (CrossYN()) {
		                createNodeAndInsertText(xmlpara, objRoot, "NAME1", MakeXMLString(tr[i].cells[0].textContent));
		                createNodeAndInsertText(xmlpara, objRoot, "NAME2", MakeXMLString(tr[i].cells[1].textContent));
		                createNodeAndInsertText(xmlpara, objRoot, "WIDTH", MakeXMLString(tr[i].cells[2].textContent));
		            }
		            else {
		                createNodeAndInsertText(xmlpara, objRoot, "NAME1", MakeXMLString(tr[i].cells[0].innerText));
		                createNodeAndInsertText(xmlpara, objRoot, "NAME2", MakeXMLString(tr[i].cells[1].innerText));
		                createNodeAndInsertText(xmlpara, objRoot, "WIDTH", MakeXMLString(tr[i].cells[2].innerText));
		            }
		            createNodeAndInsertText(xmlpara, objRoot, "COLNAME", tr[i].getAttribute("DATA1"));
		        }

		        xmlhttp.open("POST", "/admin/ezBoard/saveHeader.do", false);
		        xmlhttp.send(xmlpara);

		        return xmlhttp.responseText;
		    }

		    function CheckExtensionList() {
		        var listview = new ListView();
		        listview.LoadFromID("lvSelectList");
		        var tr = listview.GetDataRows();

		        var TableCols = "";
		        var Retval = true;
		        for (var i = 0; i < tr.length; i++) {
		            if (tr[i].getAttribute("DATA1") == "") {
		                Retval = false
		                break;
		            }
		            if (TableCols.lastIndexOf > -1) {
		                Retval = false
		                break;
		            }
		            TableCols = tr[i].getAttribute("DATA1") + "|";
		        }
		        return Retval;
		    }

		    function ConvMakeXMLString(str) {
		        str = ReplaceText(str, "&amp;", "&");
		        str = ReplaceText(str, "&lt;", "<");
		        str = ReplaceText(str, "&gt;", ">");
		        str = ReplaceText(str, "&quot;", "\"");
		        str = ReplaceText(str, "&#39;", "'");
		        return str;
		    }

		    function add_row() {
		        var cnt = parseInt(document.getElementById("cnt").value, 10) + 1;
		        oRow = document.getElementById("CAS_NO_LIST").insertRow(-1);
		        oRow.style.backgroundColor = "#FFFFFF";
		        oCell01 = oRow.insertCell(-1);
		        oCell01.align = "left";
		        oCell01.valign = "middle";
		        oCell01.innerHTML = "<input tye=\"text\" id=\"cas_no" + cnt + "\" name=\"cas_no" + cnt + "\" style=\"width:90%\" maxlength=\"50\" />&nbsp;<input type=\"checkbox\" name=\"DEL_FG" + cnt + "\" id=\"DEL_FG" + cnt + "\" />"
		        document.getElementById("cnt").value = cnt;
		    }

		    function del_row() {
		        var chkTF = false;
		        var cnt = parseInt(document.getElementById("cnt").value, 10);
		        for (i = 1; i <= cnt; i++) {
		            if (document.getElementById("DEL_FG" + i)) {
		                t = document.getElementById("DEL_FG" + i);
		                if (t.checked == true)
		                    chkTF = true;
		            }
		        }

		        if (chkTF) {
		            if (confirm("<spring:message code='ezBoard.t999064'/>")) {
		                var t;
		                var cnt = parseInt(document.getElementById("cnt").value, 10);
		                for (i = 1; i <= cnt; i++) {
		                    if (document.getElementById("DEL_FG" + i)) {
		                        t = document.getElementById("DEL_FG" + i);
		                        if (t.checked == true)
		                            t.parentNode.parentNode.parentNode.removeChild(t.parentNode.parentNode);
		                    }
		                }
		            }
		        }
		        else {
		            alert("<spring:message code='ezBoard.t999065'/>");
		        }
		    }
	    </script>
	</head>
	<body class="popup" style="overflow-x:hidden">		
		<xml id="ExtensionList" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999031'/></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999032'/></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999037'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999038'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999039'/></NAME>
						<WIDTH>500</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="XmlHeader" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999031'/></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezBoard.t999032'/></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME>Width</NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezBoard.t999029'/></h1>
		
		<span style="font-weight:bold"><spring:message code='ezBoard.t999030'/></span>
		<table class="content" style="width:100%"> 
			<tr>
				<th style="width:15%"><spring:message code='ezBoard.t999031'/></th>
		        <td style="width:25%"><input id="txtNameKor" style="width:97%" maxlength="20"/></td>
		        <th style="width:15%"><spring:message code='ezBoard.t999032'/></th>
		        <td style="width:25%"><input id="txtNameEng"  style="width:97%" maxlength="20"/></td>
				<th style="width:10%"><spring:message code='ezBoard.t999033'/></th>
		        <td style="width:10%"><input id="chkRequired" type="checkbox" /></td>
		    </tr>
		    <tr>
		        <th style="width:15%"><spring:message code='ezBoard.t999034'/></th>
		        <td style="width:25%">
		            <select id="Type" onchange="radioType_onClick(this.value)" style="width:99%">
		                <option value=""><spring:message code='ezBoard.t74'/></option>
		                <option value="text">Text Box</option>
		                <option value="radio">Radio Button</option>
		                <option value="check">Check Box</option>
		            </select>
		        </td>
		        <td colspan="4">
		            <table>
		            	<tr>
		            		<td id="Gubun"></td>
		            	</tr>
		            </table>
				    <table style="width:400px;display:none;" id="AddDel">
		   		        <tr>
	                        <td style="width:100%">
	                            <input type="button" onclick="javascript: add_row()" value="<spring:message code='ezBoard.t602'/>" />&nbsp;
	                            <input type="button" onclick="javascript: del_row()" value="<spring:message code='ezBoard.t89'/>" />
	                            <input type="hidden" id="cnt" name="cnt" value="1" />
	                        </td>
	                    </tr>
			        </table>
		        </td>
		    </tr>
		</table>
		<table style="width:100%;margin-top:10px">
			<tr>
				<td style="width:100%;text-align:right">
		            <a class="imgbtn" onClick ="return btn_Init()" id="btn_Init"><span><spring:message code='ezBoard.t999035'/></span></a>
		            <a class="imgbtn" onClick ="return btn_add()" id="btn_add"><span><spring:message code='ezBoard.t602'/></span></a>
		            <a class="imgbtn" onClick ="return btn_Update()" id="btn_Update"><span><spring:message code='ezBoard.t316'/></span></a>
		            <a class="imgbtn" onClick ="return btn_Delete()" id="btn_Delete"><span><spring:message code='ezBoard.t89'/></span></a>
		            <a class="imgbtn" onClick ="return btn_AddHeader()" id="btn_AddHeader"><span><spring:message code='ezBoard.t999036'/></span></a>
				</td>
			</tr>
		</table>
		<div class="listview">
		    <div id="SelectList" style="border: 0px solid #B6B6B6; Width: 99%; Height: 150px; overflow: hidden; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
		</div>		
		<div id="divListHeader" style="padding-top:10px">
			<span style="font-weight:bold"><spring:message code='ezBoard.t999040'/></span>
			<table style="width:100%;margin-top:10px">
				<tr>
			        <td style="width:45%">
			        <table class="content" style="width:100%"> 
				        <tr>
					        <th style="width:25%"><spring:message code='ezBoard.t999031'/></th>
			                <td style="width:25%" id="HeadName"></td>
					        <th style="width:25%">WIDTH</th>
			                <td style="width:25%"><input id="HeadWidth" style="width:95%" /></td>
				        </tr>
			        </table>
			        </td>
					<td style="width:55%;text-align:right">
			            <a class="imgbtn" onClick ="return btn_EditWidth()" id="btn_EditWidth"><span><spring:message code='ezBoard.t999041'/></span></a>
			            <a class="imgbtn" onClick ="return btn_InitHeader()" id="btn_InitHeader"><span><spring:message code='ezBoard.t999042'/></span></a>
			            <a class="imgbtn" onClick ="return btn_Remove()" id="btn_Remove"><span><spring:message code='ezBoard.t999043'/></span></a>
			            <a class="imgbtn" onClick ="return btn_MoveUp()" id="btn_MoveUp"><span><spring:message code='ezBoard.t493'/></span></a>
			            <a class="imgbtn" onClick ="return btn_MoveDown()" id="btn_MoveDown"><span><spring:message code='ezBoard.t494'/></span></a>
					</td>
				</tr>
			</table>
			<div class="listview">
			    <div id="HeaderList" style="border: 0px solid #B6B6B6; Width: 99%; Height: 300px; overflow: hidden; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
			</div>
		</div>		
		<div class="btnposition">
		    <a class="imgbtn" onClick ="return btnOK_onclick()" id="btnOK"><span><spring:message code='ezBoard.t98'/></span></a>
		    <a class="imgbtn" onClick ="return btncancel_onclick()" id="btncancel"><span><spring:message code='ezBoard.t15'/></span></a>
		</div>
	</body>
</html>