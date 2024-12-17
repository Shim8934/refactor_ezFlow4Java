<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1027'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}" ></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    if(new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent))
		    {
		        window.onblur = function() {
		          window.focus();
		        };
		    }
		    var OrderCell = "";
		    var rtnVal = new Array();
		    var g_SepAttachLVXml="";
		    var g_CabinetID;
		    var g_InitFlag="";
		    var g_TaskCode;
		    var CompanyID = "<c:out value = '${userInfo.companyID}'/>";
		    var UserLang = "<c:out value = '${userInfo.lang}'/>";
		    var RetValue;
		    var ReturnFunction;
		    var ext = "";
		    var nonElecRec = "";
		    
		    window.onload = function () {
		        try {
		            RetValue = parent.inssepattach_cross_dialogArguments[0];
		            ReturnFunction = parent.inssepattach_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.inssepattach_cross_dialogArguments[0];
		                ReturnFunction = opener.inssepattach_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		        if (CrossYN()) {
		            document.getElementById("listviewdiv").style.height = "500px";
		            document.getElementById("lvList").style.height = "500px";
		        }
  	 			ext = RetValue[3];
		        g_SepAttachLVXml = RetValue[0];
		        g_CabinetID = RetValue[1];
		        nonElecRec = RetValue[4];
		        if (RetValue[2])
		            g_InitFlag = RetValue[2];
		        if (g_InitFlag == "1") {
					if (g_CabinetID != null) {
						document.getElementById("trChangeCabinet").style.display = "none";
						document.getElementById("trModify").style.display = "";
					} else {
						document.getElementById("trChangeCabinet").style.display = "";
						document.getElementById("trModify").style.display = "none";
					}
		
		            InitCabinetInfo(GetCabinetClassInfo(g_CabinetID));
		        } else if (g_InitFlag == "2") {
		        	document.getElementById("trChangeCabinet").style.display = "none";
		            document.getElementById("trModify").style.display = "none";
		            
		            InitCabinetInfo(GetCabinetClassInfo(g_CabinetID));
		        }
		        else {
		            document.getElementById("trModify").style.display = "";
		            document.getElementById("trChangeCabinet").style.display = "none";
		        }
		        InitListView(g_SepAttachLVXml);
		        if (!CrossYN()) {
		            rtnVal[0] = "FALSE";
		            window.dialogHeight = "380px";
		            window.returnValue = rtnVal;
		        }
		    };
		    function InitCabinetInfo(objCabInfoXml) {
		        g_TaskCode = SelectSingleNodeValue(objCabInfoXml.documentElement, "TASKCODE");
		    }
		    function InitListView(lvXml) {
		        if (lvXml == "") {
		            lvXml = GetLVHearderXml();
		        } else {
		        	lvXml = ReplaceText(ReplaceText(ReplaceText(ReplaceText(lvXml, "&nbsp;", " "), "&gt;", ">"), "&lt;", "<"), "&amp;", "&");
		        }
		        /* if (nonElecRec == "Y" && g_CabinetID != "") { // 기록물철명 자동세팅 주석
		        	var CabInfo = createXmlDom();
		        	CabInfo = GetCabinetClassInfo(g_CabinetID);
		        	lvXml = lvXml.replace(/nonElecRecTempCabinetName/gi, SelectSingleNodeValue(CabInfo.documentElement, "TITLE"));
		        }  */
		        oList = createXmlDom();
		        oList = loadXMLString(lvXml);
		        
		        var pLvList = new ListView();      
		        pLvList.SetID("pLvList");
		        pLvList.SetMulSelectable(false);    
		        pLvList.SetSelectFlag(false);
		        pLvList.DataSource(oList);      
		        pLvList.DataBind("lvList");      
		    }
		    function GetLVHearderXml() {
		        var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;
		
		        oList = createXmlDom();
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA"); 	
		
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t439'/>"); // 순번
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t106'/>"); // 제목
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "150");
		        createNodeAndAppandNodeText(oList, Header, node, "COLNAME", "TITLE");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t874'/>"); // 기록물철명
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "150");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");    
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t859'/>"); // 등록구분
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t979'/>"); // 쪽수
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t1028'/>"); // 시청각기록물 형태
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t1029'/>"); // 시청각기록물 내용요약
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "220");
		
		        Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
		
		        return getXmlString(oList);
		    }
		
		    var regsepattach_cross_dialogArguments = new Array();
		    function btnAddList_onclick() {
		        var para = new Array();
		        para[0] = "1";	
		        para[1] = "";	
		        para[2] = g_CabinetID;	
		        para[3] = "";
		        para[4] = g_CabinetID;	
		        para[5] = nonElecRec;	
		
		        var url = "/ezApprovalG/regSepAttach.do";
		
				// 한글기안이 아닌 경우, 추가/변경 > 철변경 시의 레이어 팝업 UI가 깨지지 않도록 높이 조절
		        if (CrossYN()) {
		            regsepattach_cross_dialogArguments[0] = para;
		            regsepattach_cross_dialogArguments[1] = btnAddList_onclick_Complete;
		            
		            DivPopUpShow(880, 615, url);
		        }
		        else {
		            var feature = "dialogWidth:830px;dialogHeight:500px;scroll:no;resizable:no;status:no; help:no;edge:sunken;";
		            //한글기안에서 분리첨부>추가창이 잘리는현상때문에 주석처리 2018-07-27 강민수92
// 		            feature = feature + GetShowModalPosition(410, 555);
					
		            if (url != "")
		                var rtn = window.showModalDialog(url, para, feature);
		
		            if (rtn[0] == "TRUE") {
		                InsertRowToLV(rtn[1]);
		            }
		        }
		    }
		
		    function btnAddList_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            InsertRowToLV(rtn[1]);
		        }
		    }
		    /**
		    * [분리첨부] -> [추가]
		    * 추가된 '분리첨부' 내용을 리스트에 출력
		    */
		    function InsertRowToLV(szInfoXml) {
		        var pSN;
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		        if (pLvList.GetDataRows().length > 0 && pLvList.GetDataRows()[0].id == "pLvList_TR_noItems") {
		            pLvList.DeleteRow("pLvList_TR_noItems");
		        }
		        var oRows = pLvList.GetDataRows();
		        if (!oRows)
		            pSN = 1;
		
		        if (oRows.length < 1)
		            pSN = 1;
		        else
		            pSN = parseInt(oRows[oRows.length - 1].cells[0].innerHTML) + 1;
		
		        var RowCount = pLvList.GetRowCount();
		        var cnTr = pLvList.GetDataRows();
		        var MaxID = 0;
		        for (var j = 0  ; j < cnTr.length  ; j++) {
		            var curnum = Number(pLvList.GetSelectedRowID(j).substring(pLvList.GetSelectedRowID(j).lastIndexOf('_') + 1), pLvList.GetSelectedRowID(j).length);
		            if (MaxID < curnum)
		                MaxID = curnum;
		        }
		        var objTr = pLvList.NewAddRow(RowCount, "pLvList" + "_TR_" + eval(MaxID + 1));
		
		        var oList, ListViewData, Headers, Header, HName, HWidth, Rows, Row, Cell, Value, Data, node;
		        oList = createXmlDom();
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
		
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t439'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");     
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t106'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "200");
		        createNodeAndAppandNodeText(oList, Header, node, "COLNAME", "TITLE");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");    
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t874'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "150");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");   
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t859'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");   
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t979'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");    
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t1028'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");    
		        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t1029'/>");
		        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "200");
		
		        Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
		        Row = createNodeAndAppandNode(oList, Rows, Row, "ROW");
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        createNodeAndAppandNodeText(oList, Cell, node, "DATA1", " ");
		        createNodeAndAppandNodeText(oList, Cell, node, "DATA2", " ");
		        createNodeAndAppandNodeText(oList, Cell, node, "DATA3", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL"); 
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");   
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");  
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        pLvList.AddDataRow(objTr, oList);
		        SetLVRowData(objTr, pSN, szInfoXml);
		    }
		    function SetLVRowData(objRow, pSN, szInfoXml) {
		        var InfoXml = createXmlDom();
		        InfoXml = loadXMLString(szInfoXml);
		
		        if (pSN.toString() != "") {
		            objRow.cells[0].innerHTML = pSN;  
		        }
		        SetAttribute(objRow, "DATA1", SelectSingleNodeValue(InfoXml.documentElement, "CABINETID"));  
		        SetAttribute(objRow, "DATA2", SelectSingleNodeValue(InfoXml.documentElement, "REGTYPE"));  
		        SetAttribute(objRow, "DATA3", SelectSingleNodeValue(InfoXml.documentElement, "AVTYPE"));  

		        objRow.cells[1].innerText = (SelectSingleNodeValue(InfoXml.documentElement, "TITLE"));
		        objRow.cells[1].title = (SelectSingleNodeValue(InfoXml.documentElement, "TITLE")); // 분리첨부 제목이 길어도 전체 확인이 가능하도록 타이틀(툴팁) 추가
		        objRow.cells[2].innerHTML = SelectSingleNodeValue(InfoXml.documentElement, "CABINETNAME");  
		        objRow.cells[3].innerHTML = SelectSingleNodeValue(InfoXml.documentElement, "REGTYPEDESC");
		        
		        var Data = SelectSingleNodeValue(InfoXml.documentElement, "NUMOFPAGE");
		        if (Data == "")
		            objRow.cells[4].innerHTML = "";
		        else
		            objRow.cells[4].innerHTML = Data;
		
		        var Data = SelectSingleNodeValue(InfoXml.documentElement, "AVTYPEDESC");
		        if (Data == "")
		            objRow.cells[5].innerHTML = " ";
		        else
		            objRow.cells[5].innerHTML = Data;
		
		        var Data = SelectSingleNodeValue(InfoXml.documentElement, "SUMMARY");
		        if (Data == "")
		            objRow.cells[6].innerHTML = " ";
		        else
		            objRow.cells[6].innerHTML = Data;
		    }
		    
		    function btnModList_onclick() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		
		        var selnode = pLvList.GetSelectedRows();
		
		        if (selnode != "") {
		            var para = new Array();
		            para[0] = "1";	
		            para[1] = "";	
		            para[2] = GetAttribute(selnode[0], "DATA1");	
		            para[3] = GetSelAttachInfoXml(selnode);
		            para[4] = g_CabinetID;	
		            para[5] = nonElecRec;
		
		            var url = "/ezApprovalG/regSepAttach.do";
		
		            // 한글기안이 아닌 경우, 추가/변경 > 철변경 시의 레이어 팝업 UI가 깨지지 않도록 높이 조절
		            if (CrossYN()) {
		                regsepattach_cross_dialogArguments[0] = para;
		                regsepattach_cross_dialogArguments[1] = btnModList_onclick_Complete;
		
		                DivPopUpShow(880, 615, url);
		            }
		            else {
		                var feature = "dialogWidth:840px;dialogHeight:500px;scroll:no;resizable:no;status:no; help:no ";
// 		                feature = feature + GetShowModalPosition(410, 555);
		
		                if (url != "")
		                    var rtn = window.showModalDialog(url, para, feature);
		
		                if (rtn[0] == "TRUE") {
		                    SetLVRowData(selnode[0], "", rtn[1]);
		                }
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1030'/>");
		        }
		    }
		    function btnModList_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            var pLvList = new ListView();
		            pLvList.LoadFromID("pLvList");
		            var selnode = pLvList.GetSelectedRows();
		
		            SetLVRowData(selnode[0], "", rtn[1]);
		        }
		    }
		    
		    var selectcabinetintask_cross_dialogArguments = new Array();
		    function btnSelectCabinet_onclick() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		
		        var selnode = pLvList.GetSelectedRows();
		        if (selnode.length > 0) {
		            var para = new Array();
		            para[0] = g_TaskCode;
		            para[1] = GetAttribute(selnode[0], "DATA1");
		            para[2] = RetValue[3];

		            var url = "/ezApprovalG/selectCabinetInTask.do";
		            var feature = "dialogWidth:800px;dialogHeight:550px;scroll:no;resizable:no;status:no; help:no;edge:sunken";
        			feature = feature + GetShowModalPosition(800, 550);
		            if (CrossYN()) {

		            	selectcabinetintask_cross_dialogArguments[0] = para;
		            	selectcabinetintask_cross_dialogArguments[1] = btnSelectCabinet_onclick_Complete;

		                 DivPopUpShow(800, 550, url);
		            }
		            else {

		            if (url != "")
		                var rtn = window.showModalDialog(url, para, feature);

		            if (rtn[0] == "TRUE") {
		                var CabXml = createXmlDom();
		                CabXml = loadXMLString(rtn[1]);
		
		                SetAttribute(selnode[0], "DATA1", SelectSingleNodeValueNew(CabXml, "DATA/CABINET/CABINETID"));
		                selnode[0].cells[2].innerHTML = SelectSingleNodeValueNew(CabXml, "DATA/CABINET/CABINETNAME");
		            }
		           }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1031'/>");
		        }
		    }
		    
		    function btnSelectCabinet_onclick_Complete (rtn) {
		    	 DivPopUpHidden();
		         if (rtn[0] == "TRUE") {
		                 var CabXml = createXmlDom();
		                 CabXml = loadXMLString(rtn[1]);
		                 var pLvList = new ListView();
		                 pLvList.LoadFromID("pLvList");

		                 var selnode = pLvList.GetSelectedRows();
		                 SetAttribute(selnode[0], "DATA1", SelectSingleNodeValueNew(CabXml, "DATA/CABINET/CABINETID"));
		                 selnode[0].cells[2].innerHTML = SelectSingleNodeValueNew(CabXml, "DATA/CABINET/CABINETNAME");
		         }
		    }
		    
		    function GetSelAttachInfoXml(selRow) {
		        var xmlpara = createXmlDom();
		        var objNode;
		        createNodeInsert(xmlpara, objNode, "PARAMETERS");
		        createNodeAndInsertText(xmlpara, objNode, "RECORDID", "");
		        createNodeAndInsertText(xmlpara, objNode, "CABINETID", GetAttribute(selRow[0], "DATA1"));
		        createNodeAndInsertText(xmlpara, objNode, "TITLE", selRow[0].cells[1].innerHTML);
		        createNodeAndInsertText(xmlpara, objNode, "NUMOFPAGE", selRow[0].cells[4].innerHTML);
		        createNodeAndInsertText(xmlpara, objNode, "REGTYPE", GetAttribute(selRow[0], "DATA2"));
		        createNodeAndInsertText(xmlpara, objNode, "SUMMARY", selRow[0].cells[6].innerHTML);
		        createNodeAndInsertText(xmlpara, objNode, "AVTYPE", GetAttribute(selRow[0], "DATA3"));
		        createNodeAndInsertText(xmlpara, objNode, "REGTYPEDESC", selRow[0].cells[3].innerHTML);
		        createNodeAndInsertText(xmlpara, objNode, "AVTYPEDESC", selRow[0].cells[5].innerHTML);
		        createNodeAndInsertText(xmlpara, objNode, "CABINETNAME", selRow[0].cells[2].innerHTML);
		        return getXmlString(xmlpara);
		    }
		    
		    /* 2022-02-09 홍승비 - 문서 내부의 sepattachlvxml 속성 KEYWORD 부여 시 XML 파싱이 제대로 되도록 CDATA 태그 추가함 */
		    function GetListXml() {
		        var InfoXml = loadXMLString(GetLVHearderXml());
		        var Rows = InfoXml.childNodes[0].childNodes[1];
		
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		
		        var totalRows = pLvList.GetDataRows();
		        var selRow, Row, Cell, Value, Data, node, i;
		        for (i = 0; i < totalRows.length; i++) {
		            selRow = totalRows[i];        
		            Row = createNodeAndAppandNode(InfoXml, Rows, Row, "ROW");
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            node = createNodeAndAppandNodeText(InfoXml, Cell, node, "VALUE", selRow.cells[0].innerHTML);
		
		            createNodeAndAppandNodeText(InfoXml, Cell, node, "DATA1", GetAttribute(selRow, "DATA1"));
		
		            createNodeAndAppandNodeText(InfoXml, Cell, node, "DATA2", GetAttribute(selRow, "DATA2"));
		
		            createNodeAndAppandNodeText(InfoXml, Cell, node, "DATA3", GetAttribute(selRow, "DATA3"));
		
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            createNodeAndAppandNodeCDataText(InfoXml, Cell, node, "VALUE", ReplaceText(selRow.cells[1].innerHTML, "&nbsp;", " "));
		
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            createNodeAndAppandNodeCDataText(InfoXml, Cell, node, "VALUE", selRow.cells[2].innerHTML);
		
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            createNodeAndAppandNodeCDataText(InfoXml, Cell, node, "VALUE", selRow.cells[3].innerHTML);
		
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            createNodeAndAppandNodeCDataText(InfoXml, Cell, node, "VALUE", selRow.cells[4].innerHTML);
		
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            createNodeAndAppandNodeCDataText(InfoXml, Cell, node, "VALUE", selRow.cells[5].innerHTML);
		
		            Cell = createNodeAndAppandNode(InfoXml, Row, Cell, "CELL");
		            createNodeAndAppandNodeCDataText(InfoXml, Cell, node, "VALUE", selRow.cells[6].innerHTML);
		        }
		        return getXmlString(InfoXml);
		    }
		    function btnDelList_onclick() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		
		        var selnode = pLvList.GetSelectedRows();
		        
		        if (selnode != "") {
			        DelListRow("pLvList");
			        OrderList();
		        } else {
		        	alert("<spring:message code='ezApprovalG.HSBSa01'/>");
		        }
		    }

		    /**
		    * [분리첨부] 에서 순번 재정렬
		    */
		    function OrderList() { 
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		
		        var totalRows = pLvList.GetDataRows();
		        var pAttachCurSel = pLvList.GetSelectedRows();
			    if (pAttachCurSel.length > 0) {
			        var i;
			        for (i = 0; i < totalRows.length; i++) {
			            totalRows[i].cells[0].innerHTML = i + 1;
			        }
			    } 
			    
			    /* 2018-10-11 김민성 - 데이터 없을 때 문구 뜨도록 수정 */
				if(totalRows.length == 0) {
					setDeleteRow("pLvList");
			    }  
		    }
		    
		    function btnOK_onclick() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pLvList");
		        
		        var totalRows = pLvList.GetDataRows();
		        
		        /* 2018-10-16 김민성 - 분리첨부 삭제 후 확인버튼 로직 수정 */
		         if (totalRows.length == 1 && totalRows[0].id.indexOf("noItems") > -1) {
		        	 pLvList.DeleteRow("pLvList_TR_noItems");
		        } 
		        if (nonElecRec == "Y" && g_CabinetID != "nonElecRecTempCabinet") {
			        if (!CheckSepAttParamXmlNull()) {
			            alert("<spring:message code='ezApprovalG.t1411'/>");
			            return;
		        	}
		        }
		        
		        rtnVal[0] = "TRUE";
		        rtnVal[1] = GetListXml();

		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		        }
		        else {
		        	window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function btnClose_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction("FALSE");
		        }
		        else {
		            rtnVal[0] = "FALSE";
		            window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    window.onbeforeunload = function () {
	            window.returnValue = rtnVal;
		    }
		    
		    function CheckSepAttParamXmlNull() {
		        var rtnVal = true;
		        var List = new ListView();
		    	List.LoadFromID("pLvList");
		    	
		    	var rows = List.GetDataRows();
		    	var i;
	    		for (i = 0; i < rows.length; i++) {
	    			if (GetAttribute(rows[i], "DATA1") == "" || GetAttribute(rows[i], "DATA1") == "nonElecRecTempCabinet") {
	    				rtnVal = false;
	    			}
	    		}
		    	
		        return rtnVal;
		    }
		</script>
		<style>
	    	.mainlist tr th {border-top:0px}
	    </style>
	</head>
	<body class="popup">
		<div id="menu">
	        <ul id="trModify" style="display:none">
	          <li id="btnAddList"><span style="padding-top:1px" onClick="return btnAddList_onclick()"><spring:message code='ezApprovalG.t268'/></span></li>
	          <li id="btnModList" ><span style="padding-top:1px" onClick="return btnModList_onclick()"><spring:message code='ezApprovalG.t1033'/></span></li>
			  <li id="btnDelList"><span style="padding-top:1px" onClick="return btnDelList_onclick()"><spring:message code='ezApprovalG.t266'/></span></li>
	        </ul>
			<ul id="trChangeCabinet" style="display:none">
	          <li id="btnSelectCabinet"><span onClick="return btnSelectCabinet_onclick()"><spring:message code='ezApprovalG.kmsg03'/></span></li>
	        </ul>
		</div>
		<div id="close">
            <ul>
                <li><span onclick="return btnClose_onclick()"></span></li>
            </ul>
        </div>
		
		<h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1034'/></h2>
		<div id="listviewdiv" class="listview" style="Width:100%; Height:225px;">
		    <div id= "lvList" style="overflow:auto;border:0;Width:100%; Height:225px; font-size:9pt;"></div>
		</div>
		
		<div class="btnposition btnpositionNew" >
			<a id="btnOK" class="imgbtn"><span onclick = "return btnOK_onclick()" ><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
