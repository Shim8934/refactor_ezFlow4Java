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
		<style>
			<c:if test="${useJapanese != 'YES'}">.JPN { display: none; }</c:if>
			<c:if test="${useChinese != 'YES'}">.CHN { display: none; }</c:if>
			<c:if test="${useIndonesian != 'YES'}">.IDN { display: none; }</c:if>
		</style>
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
		    var useJapanese = "<c:out value='${useJapanese}'/>";
		    var useChinese = "<c:out value='${useChinese}'/>";
		    var useIndonesian = "<c:out value='${useIndonesian}'/>";
	    
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
	                	headerNmElem[2].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_tertiary}"/>)'
	                	headerNmElem[3].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_quaternary}"/>)'
	                	headerNmElem[4].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_Senary}"/>)'
	                	headerNmElem[5].textContent = '<spring:message code="ezBoard.t999037"/>'
	                	headerNmElem[6].textContent = '<spring:message code="ezBoard.t999038"/>'
	                	headerNmElem[7].textContent = '<spring:message code="ezBoard.t999039"/>'
		                
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
	                	headerNmElem[2].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_tertiary}"/>)'
	                	headerNmElem[3].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_quaternary}"/>)'
	                	headerNmElem[4].textContent = '<spring:message code="ezBoard.hsbEx01"/>(<c:out value="${lang_Senary}"/>)'
	                	headerNmElem[5].textContent = '<spring:message code="ezBoard.t5002"/>'
	                	
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
		    
		    }

		    function OnSelChange_onclick2() {
		    	var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetSelectedRows();

		        if (tr.length != 0) {
		            document.getElementById("HeadName").innerText = getNodeText(tr[0].cells[0]);
		            document.getElementById("HeadWidth").value = getNodeText(tr[0].cells[5]);
		        }
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
		    }

		    var updateTr = null;

		    function btnOpenUpdate() {
		    	var listview = new ListView();
		        listview.LoadFromID("lvSelectList");

		        updateTr = listview.GetSelectedRows();

		        if (!updateTr || updateTr.length == 0) {
		            alert("<spring:message code='ezBoard.t999053'/>");
		            return;
		        }
		        
		        setExtColPopup = GetOpenWindow('/admin/ezBoard/editExtensionAttribute.do', 'setExtCol', 500, 500);
		    }
		    
		    function receivedEditExtCol(column) {
		        if (updateTr.length == 0) {
		            alert("<spring:message code='ezBoard.t999053'/>");
		            return;
		        }

		        var tr = updateTr[0];
		        var korNameTd = updateTr[0].querySelector(".KOR");
		        var engNameTd = updateTr[0].querySelector(".ENG");
		        var jpnNameTd = updateTr[0].querySelector(".JPN");
		        var chnNameTd = updateTr[0].querySelector(".CHN");
		        var idnNameTd = updateTr[0].querySelector(".IDN");
		        var mustTd = updateTr[0].querySelector(".MUST");
		        var colTypeTd = updateTr[0].querySelector(".TYPE");
		        var valueTd = updateTr[0].querySelector(".VALUE");

				EditHeader(korNameTd.innerText, column);
		        
		        korNameTd ? korNameTd.innerText = column.txtNameKor : "";
		        engNameTd ? engNameTd.innerText = column.txtNameEng : "";
		        jpnNameTd ? jpnNameTd.innerText = column.txtNameJpn : "";
		        chnNameTd ? chnNameTd.innerText = column.txtNameChn : "";
		        idnNameTd ? idnNameTd.innerText = column.txtNameIdn : "";
		        mustTd ? mustTd.innerText = (column.must == true ? "Y" : "N") : "";
		        colTypeTd ? colTypeTd.innerText = column.colType : "";
		        valueTd ? valueTd.innerText = column.value : "";

		        ChangedAdd = true;
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

		    // 현재 창이 닫히면 팝업 창도 닫히도록 하기 위해 팝업창을 변수로 다룸.
		    var setExtColPopup = null;
		    
		    window.addEventListener('unload', function () {
		        if (setExtColPopup && !setExtColPopup.closed) {
		        	setExtColPopup.close();
		        }
		    });
		    
		    function btnOpenAdd() {
		    	// 현재의 설정된 확장컬럼의 수(=countExtAttr)를 확인하고
		    	var listview = new ListView();
		        listview.LoadFromID("lvSelectList");
		        var countExtAttr = listview.GetDataRows();
		    	
		    	if (countExtAttr > 4) {
			    	// countExtAttr이 5개 이상이면 alert
		            alert("<spring:message code='ezBoard.t999056'/>");
		            return;
		    	} else {
			    	// countExtAttr이 4개 이하이면 등록 가능
			    	setExtColPopup = GetOpenWindow('/admin/ezBoard/newExtensionAttribute.do', 'setExtCol', 500, 500);
		    	}
		    }

		    function receivedNewExtCol(column) {
		        var listview = new ListView();
		        listview.LoadFromID("lvSelectList");
		        var InitTr = listview.GetDataRows();
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
		    	
		    	var pparsingXML = "<LISTVIEWDATA><ROWS><ROW>";
		        pparsingXML += "<CELL><CLASSNAME>KOR</CLASSNAME><VALUE><![CDATA[" + column.txtNameKor + "]]></VALUE><DATA1>" + pTableCol + "</DATA1></CELL>"; //항목명(한국어)
		        pparsingXML += "<CELL><CLASSNAME>ENG</CLASSNAME><VALUE><![CDATA[" + column.txtNameEng + "]]></VALUE></CELL>"; //항목명(영어)
		        pparsingXML += "<CELL><CLASSNAME>JPN</CLASSNAME><VALUE><![CDATA[" + column.txtNameJpn + "]]></VALUE></CELL>"; //항목명(일본어)
		        pparsingXML += "<CELL><CLASSNAME>CHN</CLASSNAME><VALUE><![CDATA[" + column.txtNameChn + "]]></VALUE></CELL>"; //항목명(중국어)
		        pparsingXML += "<CELL><CLASSNAME>IDN</CLASSNAME><VALUE><![CDATA[" + column.txtNameIdn + "]]></VALUE></CELL>"; //항목명(인도네시아어)
		        pparsingXML += "<CELL><CLASSNAME>MUST</CLASSNAME><VALUE><![CDATA[" + (column.must == true ? "Y" : "N") + "]]></VALUE></CELL>"; //필수항목여부
		        pparsingXML += "<CELL><CLASSNAME>TYPE</CLASSNAME><VALUE><![CDATA[" + column.colType + "]]></VALUE></CELL>"; //항목타입
		        pparsingXML += "<CELL><CLASSNAME>VALUE</CLASSNAME><VALUE><![CDATA[" + column.value + "]]></VALUE></CELL>"; //항목타입명
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

		    function EditHeader(pHeader, column) {
		    	var listview = new ListView();
		        listview.LoadFromID("lvXmlHeader");

		        var tr = listview.GetDataRows();

		        for (var i = 0; i < tr.length; i++) {
		            if (tr[i].cells[0].innerHTML == pHeader) {
		                ChangedHeader = true;
		                setNodeText(tr[i].cells[0], column.txtNameKor);
		                setNodeText(tr[i].cells[1], column.txtNameEng);
		                setNodeText(tr[i].cells[2], column.txtNameJpn);
		                setNodeText(tr[i].cells[3], column.txtNameChn);
		                setNodeText(tr[i].cells[4], column.txtNameIdn);
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

		        setNodeText(tr[0].cells[5], document.getElementById("HeadWidth").value);

		        ChangedHeader = true;
		        alert("<spring:message code='ezBoard.t999054'/>");
		    }

		    function checkDuplicateTypeNames(chkTr) {
            	var rows = [].slice.call(document.querySelectorAll("#lvXmlHeader tbody tr"));
		    	
            	if (rows.length < 1) {
            		return false;
            	}
            	
		    	var chkVals = {};
		    	var langs = ["KOR"
			    				, "ENG"
			    				<c:if test="${useJapanese == 'YES'}"> , "JPN"</c:if>
			    				<c:if test="${useChinese == 'YES'}"> , "CHN"</c:if>
			    				<c:if test="${useIndonesian == 'YES'}"> , "IDN"</c:if>
		    				];
		    	
		    	for (var i = 0; i < langs.length; i++) {
		    		var langTd = chkTr.querySelector("." + langs[i]);
		    		chkVals[langs[i]] = langTd ? langTd.textContent.trim() : "";
		    	}
		    	
            	
            	for (var i = 0; i < rows.length; i++) {
            		for (var j = 0; j < langs.length; j++) {
            			var td = rows[i].querySelector("." + langs[j]);
            			var tdTxt = td ? td.textContent.trim() : "";
            			
            			if (chkVals[langs[j]] && chkVals[langs[j]] == tdTxt) {
            				return true;
            			}
            		}
            	}
    	    	
    			return false;
		    }
		    
		    function btn_AddHeader() {
		        var listview2 = new ListView();
		        listview2.LoadFromID("lvSelectList");

		        var tr2 = listview2.GetSelectedRows();
                var langTDName ="";

		        if (tr2.length == 0) {
		            alert("<spring:message code='ezBoard.t999061'/>");
		            return;
		        }

		        tr2 = tr2[0];
		        
		        if (checkDuplicateTypeNames(tr2)) {
		            alert("<spring:message code='ezBoard.t999057'/>");
		            return;
		        }

		        if (tr2.getAttribute("DATA1") == "") {
		            alert("<spring:message code='ezBoard.t999062'/>");
		            return
		        }

		        var pparsingXML = "<LISTVIEWDATA><ROWS><ROW>";
                pparsingXML += "<CELL><CLASSNAME>KOR</CLASSNAME><VALUE><![CDATA[" + tr2.querySelector(".KOR").innerText.trim() + "]]></VALUE><DATA1>" + GetAttribute(tr2,"DATA1") + "</DATA1></CELL>";
		        pparsingXML += "<CELL><CLASSNAME>ENG</CLASSNAME><VALUE><![CDATA[" + tr2.querySelector(".ENG").innerText.trim() + "]]></VALUE></CELL>";
		        pparsingXML += "<CELL><CLASSNAME>JPN</CLASSNAME><VALUE><![CDATA[" + tr2.querySelector(".JPN").innerText.trim() + "]]></VALUE></CELL>";
		        pparsingXML += "<CELL><CLASSNAME>CHN</CLASSNAME><VALUE><![CDATA[" + tr2.querySelector(".CHN").innerText.trim() + "]]></VALUE></CELL>";
		        pparsingXML += "<CELL><CLASSNAME>IDN</CLASSNAME><VALUE><![CDATA[" + tr2.querySelector(".IDN").innerText.trim() + "]]></VALUE></CELL>";
		        pparsingXML += "<CELL><CLASSNAME>WIDTH</CLASSNAME><VALUE><![CDATA[80]]></VALUE></CELL>";
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
		            	var korStr = tr[i].querySelector(".KOR").innerText.trim();
		            	var engStr = tr[i].querySelector(".ENG").innerText.trim();
		            	var jpnStr = tr[i].querySelector(".JPN").innerText.trim();
		            	var chnStr = tr[i].querySelector(".CHN").innerText.trim();
		            	var idnStr = tr[i].querySelector(".IDN").innerText.trim();
		            	
		            	createNodeAndInsertText(xmlpara, objRoot, "COLNAME1", MakeXMLString(korStr));
		            	createNodeAndInsertText(xmlpara, objRoot, "COLNAME2", MakeXMLString(engStr));
		            	createNodeAndInsertText(xmlpara, objRoot, "COLNAME3", MakeXMLString(jpnStr ? jpnStr : engStr));
		            	createNodeAndInsertText(xmlpara, objRoot, "COLNAME4", MakeXMLString(chnStr ? chnStr : engStr));
		            	createNodeAndInsertText(xmlpara, objRoot, "COLNAME6", MakeXMLString(idnStr ? idnStr : engStr));
		                createNodeAndInsertText(xmlpara, objRoot, "VALUE", MakeXMLString(tr[i].querySelector(".VALUE").innerText));
		                createNodeAndInsertText(xmlpara, objRoot, "COLTYPE", tr[i].querySelector(".TYPE").innerText);
		                createNodeAndInsertText(xmlpara, objRoot, "MUST", tr[i].querySelector(".MUST").innerText);
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
		        createNodeAndInsertText(xmlpara, objRoot, "NAME3", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "NAME4", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "NAME6", "CHECK");
		        createNodeAndInsertText(xmlpara, objRoot, "WIDTH", "20");
		        createNodeAndInsertText(xmlpara, objRoot, "COLNAME", "ITEMID");
		        
		        for (var i = 0; i < tr.length; i++) {
		        	var korStr = tr[i].querySelector(".KOR").innerText.trim();
	            	var engStr = tr[i].querySelector(".ENG").innerText.trim();
	            	var jpnStr = tr[i].querySelector(".JPN").innerText.trim();
	            	var chnStr = tr[i].querySelector(".CHN").innerText.trim();
	            	var idnStr = tr[i].querySelector(".IDN").innerText.trim();
	            	
		        	createNodeAndInsertText(xmlpara, objRoot, "NAME1", MakeXMLString(korStr));
		            createNodeAndInsertText(xmlpara, objRoot, "NAME2", MakeXMLString(engStr));
		            createNodeAndInsertText(xmlpara, objRoot, "NAME3", MakeXMLString(jpnStr ? jpnStr : engStr));
		            createNodeAndInsertText(xmlpara, objRoot, "NAME4", MakeXMLString(chnStr ? chnStr : engStr));
		            createNodeAndInsertText(xmlpara, objRoot, "NAME6", MakeXMLString(idnStr ? idnStr : engStr));
		            createNodeAndInsertText(xmlpara, objRoot, "WIDTH", MakeXMLString(tr[i].querySelector(".WIDTH").innerText));
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
		        oCell01.innerHTML = "<input type=\"text\" id=\"cas_no" + cnt + "\" name=\"cas_no" + cnt + "\" style=\"width:90%\" maxlength=\"50\" />&nbsp;<div class=\"custom_checkbox\"><input type=\"checkbox\" name=\"DEL_FG" + cnt + "\" id=\"DEL_FG" + cnt + "\" /></div>"
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
						<CLASSNAME>KOR</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>ENG</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>JPN</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>CHN</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>IDN</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>80</WIDTH>
						<CLASSNAME>MUST</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>50</WIDTH>
						<CLASSNAME>TYPE</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>500</WIDTH>
						<CLASSNAME>TYPENAME</CLASSNAME>
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
						<CLASSNAME>KOR</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>ENG</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>JPN</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>CHN</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>IDN</CLASSNAME>
					</HEADER>
					<HEADER>
						<NAME></NAME>
						<WIDTH>150</WIDTH>
						<CLASSNAME>WIDTH</CLASSNAME>
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
 		<div id="outerDiv" style="height:610px; overflow-y:auto;margin-top:-13px;margin-right:-10px;">
	 		<div id="innerDiv" style="padding-right:10px; padding-top:8px; padding-bottom:8px; overflow:hidden;" >
				<table style="width:100%;margin-top:10px; margin-bottom:5px">
					<tr>
						<td style="width:100%;text-align:right">
				            <a class="imgbtn imgbck" onClick ="return btnOpenAdd()" id="btn_add"><span><spring:message code='ezBoard.t602'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btnOpenUpdate()" id="btn_Update"><span><spring:message code='ezBoard.t316'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btn_Delete()" id="btn_Delete"><span><spring:message code='ezBoard.t89'/></span></a>
				            <a class="imgbtn imgbck" onClick ="return btn_AddHeader()" id="btn_AddHeader"><span><spring:message code='ezBoard.t999036'/></span></a>
						</td>
					</tr>
				</table>
				<div class="listview">
				    <div id="SelectList" style="border: 0px solid #ddd; Width: 100%; Height: 150px; BACKGROUND-COLOR: white; overflow:auto; "></div>
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
					    <div id="HeaderList" style="border: 0px solid #ddd; Width: 100%; Height: 290px; overflow: hidden; BACKGROUND-COLOR: white; overflow-y:auto; "></div>
					</div>
				</div>
			</div>
		</div>
		<div class="btnpositionNew">
		    <a class="imgbtn" onClick ="return btnOK_onclick()" id="btnOK"><span><spring:message code='ezBoard.t98'/></span></a>
		</div>
	</body>
</html>
