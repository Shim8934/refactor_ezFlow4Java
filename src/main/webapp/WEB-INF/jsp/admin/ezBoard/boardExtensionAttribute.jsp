<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code="ezBoard.t999029"/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />	        
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list_admin.js')}"></script>
		<script type="text/javascript" language="javascript">
			var pBoardID = "";
		    var pGubun = "";
		    var ChangedAdd = false;
		    var ChangedHeader = false;
		    var RetValue;
		    var lang_primary = "<c:out value='${lang_primary}'/>";
		    var lang_secondary = "<c:out value='${lang_secondary}'/>";
	    
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
		        
		        /* 2018-07-17 홍승비 - 확장컬럼 설정창 스크롤 발생 수정 */
		       if (navigator.userAgent.toLowerCase().indexOf("chrome") == -1) {
	    	    	document.getElementById("outerDiv").style.height = "667px";
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
		        	dataType : "text",
		        	url : "/admin/ezBoard/getAttribute.do",
		        	data : {boardID : pBoardID},
		        	success : function(result){
		        		if (document.getElementById("SelectList").innerHTML != "")
		                    document.getElementById("SelectList").innerHTML = "";

		                var headerData = createXmlDom();
		                headerData = loadXMLString(ExtensionList.innerHTML.toUpperCase());
		                var headerNmElem = headerData.getElementsByTagName("NAME");
	                	headerNmElem[0].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_primary}"/>)'
	                	headerNmElem[1].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_secondary}"/>)'
	                	headerNmElem[2].textContent = '<spring:message code="ezBoard.t999037"/>'
	                	headerNmElem[3].textContent = '<spring:message code="ezBoard.t999038"/>'
	                	headerNmElem[4].textContent = '<spring:message code="ezBoard.t999039"/>'
		                
		                if (result != "") {
		                    var xmlRtn = loadXMLString(result).getElementsByTagName("ROWS")[0];
		                    /* 2018.02.12 김기하 */
		                    var temp = xmlRtn.getElementsByTagName("VALUE");
		                	for (i = 0; i < temp.length ; i++) {
		                		temp[i].innerHTML = "<![CDATA[" + temp[i].innerHTML + "]]>";
		                	}
		                    headerData.documentElement.appendChild(xmlRtn);
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
		        	dataType : "text",
		        	url : "/admin/ezBoard/getBoardHeader.do",
		        	data : {colType : pGubun, boardID : boardid},
		        	success : function(result){
		        		if (document.getElementById("HeaderList").innerHTML != "")
		                    document.getElementById("HeaderList").innerHTML = "";

		                var headerData = createXmlDom();
		                headerData = loadXMLString(XmlHeader.innerHTML.toUpperCase());
		                
		                var headerNmElem = headerData.getElementsByTagName("NAME");
	                	headerNmElem[0].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_primary}"/>)'
	                	headerNmElem[1].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_secondary}"/>)'
	                	headerNmElem[2].textContent = '<spring:message code="ezBoard.t5002"/>'
	                	
		                if (result != "") {
		                    var xmlRtn = loadXMLString(result).getElementsByTagName("ROWS")[0];
		                    /* 2018.02.12 김기하 */
		                    var temp = xmlRtn.getElementsByTagName("VALUE");
		                	for(i = 0; i < temp.length ; i++){
		                		temp[i].innerHTML = "<![CDATA[" + temp[i].innerHTML + "]]>";
		                	}
		                    headerData.documentElement.appendChild(xmlRtn);
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
		            document.getElementById("txtNameKor").value = getNodeText(tr[0].cells[0]);
		            document.getElementById("txtNameEng").value = getNodeText(tr[0].cells[1]);

		            if (getNodeText(tr[0].cells[2]) == "Y")
		                document.getElementById("chkRequired").checked = true;
		            else
		                document.getElementById("chkRequired").checked = false;

		            radioType_onClick(getNodeText(tr[0].cells[3]));
		            SetRadioVal("Type", getNodeText(tr[0].cells[3]));
		            SetGubunList(getNodeText(tr[0].cells[4]));
		        }
		    }

		    function SetGubunList(pCassNo) {
		    	document.getElementById("AddDel").style.display = "none";
		        document.getElementById("Gubun").innerHTML = "";

		        if (pCassNo.trim() != "") {
		            document.getElementById("Gubun").innerHTML = "<table style='width:400px' id='CAS_NO_LIST'><tr><td style='width:100%'><input type='text' id='cas_no1' name='cas_no1' style='width:90%' maxlength='50'>&nbsp;<div class='custom_checkbox'><input type='checkbox' id='DEL_FG1' name='DEL_FG1' /></div></td></tr></table>";
		            document.getElementById("AddDel").style.display = "";

		            /* 2021-04-26 홍승비 - 라디오버튼, 체크박스의 각 항목 첫번째 타입명만 ', " 문자를 제대로 표출하는 부분 수정 */
		            for (var i = 1; i < (pCassNo.split("|").length + 1) ; i++) {
		                if (i > 1) {
		                    oRow = document.getElementById("CAS_NO_LIST").insertRow(-1);
		                    oRow.style.backgroundColor = "#FFFFFF";
		                    oCell01 = oRow.insertCell(-1);
		                    oCell01.align = "left";
		                    oCell01.valign = "middle";
		                    oCell01.innerHTML = "<input type=\"text\" id=\"cas_no" + i + "\" name=\"cas_no" + i + "\" style=\"width:90%\" maxlength=\"50\" />&nbsp;<div class=\"custom_checkbox\"><input type=\"checkbox\" name=\"DEL_FG" + i + "\" id=\"DEL_FG" + i + "\" /></div>";
		                    document.getElementById("cas_no" + i).value = pCassNo.split("|")[(i - 1)];
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
		            document.getElementById("HeadName").innerText = getNodeText(tr[0].cells[0]);
		            document.getElementById("HeadWidth").value = getNodeText(tr[0].cells[2]);
		        }
		    }

		    /* 2018-11-30 홍승비 - 확장칼럼 항목타입 초기 옵션 value 분기 수정 */
		    function radioType_onClick(pValue) {
		        var noAttrFlag = ["text", "cal", "textArea", "people", "", null];
		    	if (noAttrFlag.includes(pValue)) {
		            document.getElementById("AddDel").style.display = "none";
		            document.getElementById("Gubun").innerHTML = "";
		        }
		        else {
		            document.getElementById("Gubun").innerHTML = "<table style='width:400px' id='CAS_NO_LIST'><tr><td style='width:100%'><input type='text' id='cas_no1' name='cas_no1' style='width:90%' maxlength='50'>&nbsp;<div class='custom_checkbox'><input type='checkbox' id='DEL_FG1' name='DEL_FG1' /></div></td></tr></table>";
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

		    /* 2020-02-14  홍승비 - 게시판 확장칼럼 다국어 대응 수정 (경고 메세지에서 특정 다국어 용어 제거) */
		    function CheckValidation() {
		        if (document.getElementById("txtNameKor").value == "") {
		            //alert("<spring:message code='ezBoard.t999044'/>");
		            alert("<spring:message code='ezBoard.hsbEx02'/>");
		            document.getElementById("txtNameKor").focus();
		            return false;
		        }
		        if (document.getElementById("txtNameEng").value == "") {
		            //alert("<spring:message code='ezBoard.t999045'/>");
		            alert("<spring:message code='ezBoard.hsbEx02'/>");
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
		        else if (GetRadioVal("Type") == "select") {
                	if (txtType == "") {
                		alert("<spring:message code='ezBoard.lhr01'/>");
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

		        setNodeText(tr[0].cells[0], document.getElementById("txtNameKor").value);
		        setNodeText(tr[0].cells[1], document.getElementById("txtNameEng").value);

		        if (document.getElementById("chkRequired").checked == true)
		            setNodeText(tr[0].cells[2], "Y");
		        else
		            setNodeText(tr[0].cells[2], "N");

		        setNodeText(tr[0].cells[3], GetRadioVal("Type"));
		        setNodeText(tr[0].cells[4], txtGubun);

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
		                setNodeText(tr[i].cells[0], document.getElementById("txtNameKor").value);
		                setNodeText(tr[i].cells[1], document.getElementById("txtNameEng").value);
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

		        setNodeText(tr[0].cells[2], document.getElementById("HeadWidth").value);

		        ChangedHeader = true;
		        alert("<spring:message code='ezBoard.t999054'/>");
		    }

		    function btn_AddHeader() {
		        var listview2 = new ListView();
		        listview2.LoadFromID("lvSelectList");

		        var tr2 = listview2.GetSelectedRows();
                var langTDName ="";

                if (${lang_user} == 1 || ${lang_user} == 3 || ${lang_user} == 4 ) {
                    langTDName = getNodeText(tr2[0].cells[0]);
                } else if (${lang_user} == 2 ) {
                    langTDName = getNodeText(tr2[0].cells[1])
                }

		        if (tr2.length == 0) {
		            alert("<spring:message code='ezBoard.t999061'/>");
		            return;
		        }

		        if (CheckDuplication(langTDName, "lvXmlHeader", 0) == false) {
		            alert("<spring:message code='ezBoard.t999057'/>");
		            return;
		        }

		        if (tr2[0].getAttribute("DATA1") == "") {
		            alert("<spring:message code='ezBoard.t999062'/>");
		            return
		        }

		        var pparsingXML = "<LISTVIEWDATA><ROWS><ROW>";
                pparsingXML += "<CELL><VALUE><![CDATA[" + langTDName + "]]></VALUE><DATA1>" + GetAttribute(tr2[0],"DATA1") + "</DATA1></CELL>";
		        pparsingXML += "<CELL><VALUE><![CDATA[" + getNodeText(tr2[0].cells[1]) + "]]></VALUE></CELL>";
		        pparsingXML += "<CELL><VALUE><![CDATA[80]]></VALUE></CELL>"; 
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
		        alert("<spring:message code='ezBoard.t999063'/>");
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
		            	createNodeAndInsertText(xmlpara, objRoot, "COLNAME1", MakeXMLString(getNodeText(tr[i].cells[0])));
		                createNodeAndInsertText(xmlpara, objRoot, "COLNAME2", MakeXMLString(getNodeText(tr[i].cells[1])));
		                createNodeAndInsertText(xmlpara, objRoot, "VALUE", MakeXMLString(getNodeText(tr[i].cells[4])));
		                createNodeAndInsertText(xmlpara, objRoot, "COLTYPE", getNodeText(tr[i].cells[3]));
		                createNodeAndInsertText(xmlpara, objRoot, "MUST", getNodeText(tr[i].cells[2]));
		                createNodeAndInsertText(xmlpara, objRoot, "TABLECOL", GetAttribute(tr[i],"DATA1"));
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

		        createNodeAndInsertText(xmlpara, objRoot, "NAME1", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "NAME2", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "WIDTH", "20");
		        createNodeAndInsertText(xmlpara, objRoot, "COLNAME", "ITEMID");
		        
		        for (var i = 0; i < tr.length; i++) {
		        	createNodeAndInsertText(xmlpara, objRoot, "NAME1", MakeXMLString(getNodeText(tr[i].cells[0])));
		            createNodeAndInsertText(xmlpara, objRoot, "NAME2", MakeXMLString(getNodeText(tr[i].cells[1])));
		            createNodeAndInsertText(xmlpara, objRoot, "WIDTH", MakeXMLString(getNodeText(tr[i].cells[2])));
		            createNodeAndInsertText(xmlpara, objRoot, "COLNAME", GetAttribute(tr[i],"DATA1"));
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
		            if (GetAttribute(tr[i],"DATA1") == "") {
		                Retval = false
		                break;
		            }
		            if (TableCols.lastIndexOf > -1) {
		                Retval = false
		                break;
		            }
		            TableCols = GetAttribute(tr[i],"DATA1") + "|";
		        }
		        return Retval;
		    }

		    function ConvMakeXMLString(str) {
		        /* 2018.02.12 김기하 */
		    	var strTemp = str;
		        while((str = ReplaceText(str, "&amp;", "&")) != strTemp){
		        	strTemp = str;
		        }
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
	    <style>
	    	.mainlist_free tr th { border-top:0px }
	    </style>
	</head>
	<body class="popup" style="overflow-x:hidden;">		
		<xml id="ExtensionList" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>80</WIDTH>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>500</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<xml id="XmlHeader" style="display:none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
		<h1><spring:message code='ezBoard.t999029'/></h1>
		<div id="close">
            <ul>
                <li><span id="btncancel" onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
 		<div id="outerDiv" style="height:663px; overflow-y:auto;margin-top:-13px;margin-right:-10px;">
	 		<div id="innerDiv" style="padding-right:10px; padding-top:8px; padding-bottom:8px; overflow:hidden;" >
				<span style="font-weight:bold"><spring:message code='ezBoard.t999030'/></span>
				<table class="content" style="width:100%;margin-top:5px">
					<tr>
<%-- 						<th style="width:15%"><spring:message code='ezBoard.t999031'/></th> --%>
						<th style="width:15%"><spring:message code='ezBoard.hsbEx01'/></th>
				        <td style="width:25%"><input id="txtNameKor" style="width:97%" maxlength="20"/></td>
<%-- 				        <th style="width:15%"><spring:message code='ezBoard.t999032'/></th> --%>
				        <th style="width:15%"><spring:message code='ezBoard.hsbEx01'/>(<c:out value="${lang_secondary}"/>)</th>
				        <td style="width:25%"><input id="txtNameEng"  style="width:97%" maxlength="20"/></td>
						<th style="width:10%"><spring:message code='ezBoard.t999033'/></th>
				        <td style="width:10%"><div class="custom_checkbox"><input id="chkRequired" type="checkbox" /></div></td>
				    </tr>
				    <tr>
				        <th style="width:15%"><spring:message code='ezBoard.t999034'/></th>
				        <td style="width:25%">
				            <select id="Type" onchange="radioType_onClick(this.value)" style="width:99%">
				                <option value=""><spring:message code='ezBoard.t74'/></option>
				                <option value="text"><spring:message code='ezBoard.hyj06'/></option>
				                <option value="radio"><spring:message code='ezBoard.hyj07'/></option>
				                <option value="check"><spring:message code='ezBoard.hyj08'/></option>
								<option value="cal"><spring:message code='ezBoard.MJSBC01'/></option>
								<option value="select"><spring:message code='ezBoard.MJSBC02'/></option>
								<option value="people"><spring:message code='ezBoard.extensionAttr.JIH01'/></option>
								<option value="textArea"><spring:message code='ezBoard.extensionAttr.JIH02'/></option>
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
				            <a class="imgbtn imgbck" onClick ="return btn_Init()" id="btn_Init"><span><spring:message code='ezBoard.t999035'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btn_add()" id="btn_add"><span><spring:message code='ezBoard.t602'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btn_Update()" id="btn_Update"><span><spring:message code='ezBoard.t316'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btn_Delete()" id="btn_Delete"><span><spring:message code='ezBoard.t89'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btn_AddHeader()" id="btn_AddHeader"><span><spring:message code='ezBoard.t999036'/></span></a>
						</td>
					</tr>
				</table>
				<div class="listview">
				    <div id="SelectList" style="border: 0px solid #ddd; Width: 100%; Height: 150px; overflow: hidden; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
				</div>
				<div id="divListHeader" style="padding-top:10px">
					<span style="font-weight:bold"><spring:message code='ezBoard.t999040'/></span>
					<table style="width:100%;margin-top:10px">
						<tr>
					        <td style="width:45%">
					        <table class="content" style="width:100%"> 
						        <tr>
							        <th style="width:25%"><spring:message code='ezBoard.hsbEx01'/></th>
					                <td style="width:25%" id="HeadName"></td>
							        <th style="width:25%"><spring:message code='ezBoard.t5002'/></th>
					                <td style="width:25%"><input id="HeadWidth" style="width:99%" /></td>
						        </tr>
					        </table>
					        </td>
							<td style="width:55%;text-align:right">
					            <a class="imgbtn imgbck" onClick ="return btn_EditWidth()" id="btn_EditWidth"><span><spring:message code='ezBoard.t999041'/></span></a>
					            <a class="imgbtn imgbck" onClick ="return btn_InitHeader()" id="btn_InitHeader"><span><spring:message code='ezBoard.t999042'/></span></a>
					            <a class="imgbtn imgbck" onClick ="return btn_Remove()" id="btn_Remove"><span><spring:message code='ezBoard.t999043'/></span></a>
					            <a class="imgbtn imgbck" onClick ="return btn_MoveUp()" id="btn_MoveUp"><span><spring:message code='ezBoard.t493'/></span></a>
					            <a class="imgbtn imgbck" onClick ="return btn_MoveDown()" id="btn_MoveDown"><span><spring:message code='ezBoard.t494'/></span></a>
							</td>
						</tr>
					</table>
					<div class="listview">
					    <div id="HeaderList" style="border: 0px solid #ddd; Width: 100%; Height: 300px; overflow: hidden; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
					</div>
				</div>
			</div>
		</div>
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick ="return btnOK_onclick()" id="btnOK"><span><spring:message code='ezBoard.t98'/></span></a>
		</div>
	</body>
</html>
