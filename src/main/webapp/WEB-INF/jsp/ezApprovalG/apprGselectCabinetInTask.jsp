<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t711'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<style type="text/css">
			.mainlist tr th {
				border-top :0px;
			}
		</style>
    	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
    	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var OrderCell = "";
		    var g_InitFlag = "1";
		    var arrTask = new Array();
		    var g_CodeInfoXml;
		    var rtnVal = new Array();
		    var AdminYN="FALSE";
		    var szRoleInfo="<c:out value='${userInfo.rollInfo}'/>";
		    var g_bRecAdmin=false;
		    var g_bDeptCharger=false;
		    var xmlhttp = createXmlDom();
		    var pUserID = "<c:out value='${userInfo.id}'/>";
		    var CompanyID = "<c:out value='${userInfo.companyID}'/>";
		    var arr_userinfo = new Array();
		    arr_userinfo[0]  = "user";								
		    arr_userinfo[1]  = "<c:out value='${userInfo.id}'/>";              
		    arr_userinfo[2]  = "<c:out value='${userInfo.displayName}'/>";         
		    arr_userinfo[3]  = "<c:out value='${userInfo.title}'/>";               
		    arr_userinfo[4]  = "<c:out value='${userInfo.deptID}'/>";              
		    arr_userinfo[5]  = "<c:out value='${userInfo.deptName}'/>";            
		    arr_userinfo[6]  = "<c:out value='${userInfo.jikChek}'/>";                         
		    arr_userinfo[8]  = "<c:out value='${userInfo.email}'/>";               
		    arr_userinfo[9]  = CompanyID;
		    arr_userinfo[11]  = "<c:out value='${userInfo.displayName1}'/>";		
		    arr_userinfo[12]  = "<c:out value='${userInfo.displayName2}'/>";		
		    arr_userinfo[13]  = "<c:out value='${userInfo.title1}'/>";				
		    arr_userinfo[14]  = "<c:out value='${userInfo.title2}'/>";				
		    arr_userinfo[15]  = "<c:out value='${userInfo.deptName1}'/>";			
		    arr_userinfo[16]  = "<c:out value='${userInfo.deptName2}'/>";			
		    var g_SelCabID="";
		    var UserLang = "<c:out value='${userInfo.lang}'/>";
		    var ReturnFunction;
		    var CancelFunction;
		    var openYear = "<c:out value='${openYear}'/>";
		    var currYear = "<c:out value='${currYear}'/>";
		    window.onload = function () {
		        var objWinDlgArgs;
		
		        try {
		            RetValue = parent.selectcabinetintask_cross_dialogArguments[0];
		            ReturnFunction = parent.selectcabinetintask_cross_dialogArguments[1];
		        } catch (e) {
		            try {
		                RetValue = opener.selectcabinetintask_cross_dialogArguments[0];
		                ReturnFunction = opener.selectcabinetintask_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }
		      
		        arrTask[0] = RetValue[0];
		        if (typeof (RetValue[1]) != "undefined")
		            g_SelCabID = RetValue[1];
		
		        InitSelCabinetList();
		        InitCode();
		
		        initUserRoleinfo();
		
		        if (g_InitFlag == "1")
		        {
		            if (g_bRecAdmin || AdminYN == "TRUE" || g_bDeptCharger) {
// 		                trCreateCab.style.display = "";
		                $('#trCreateCab').show();
		            }
		            else {
// 		                trCreateCab.style.display = "none";
		                $('#trCreateCab').hide();
		            }
		        }
		        if (typeof (g_SelCabID) != "undefined") {
		            if (g_SelCabID != "") {
		                InitCabClassInfo(GetCabinetClassInfo(g_SelCabID));
		            }
		        }
		        GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], "", "1");

		        var selectSYear = document.getElementById("selSYear");

                //전체목록 option 추가
                var selSYearOption = document.createElement("option");
                selSYearOption.value = '';
                selSYearOption.text = '전체';
                selectSYear.add(selSYearOption);

                //생산연도 별 option 추가
                for (var year = currYear; year >= openYear; year--) {
                    selSYearOption = document.createElement("option");
                    selSYearOption.value = year;
                    selSYearOption.text = year;
                    selectSYear.add(selSYearOption);
                }

		    };
		    function AddPreSelectedCabient(objCabInfoXml) {
		        var oList, ListViewData, Headers, Header, HName, HWidth, Rows, Row, Cell, Value, Data, node;
		        var pCbList = new ListView();
		        pCbList.LoadFromID("pSCLvList");
		
		        oList = createXmlDom();
		
		        var RowCount = pCbList.GetRowCount();
		        var cnTr = pCbList.GetDataRows();
		        var MaxID = 0;
		        for (var j = 0  ; j < cnTr.length  ; j++) {
		            var curnum = Number(pCbList.GetSelectedRowID(j).substring(pCbList.GetSelectedRowID(j).lastIndexOf('_') + 1), pCbList.GetSelectedRowID(j).length);
		            if (MaxID < curnum)
		                MaxID = curnum;
		        }
		        var row = pCbList.NewAddRow(RowCount, "pCbLvList" + "_TR_" + eval(MaxID + 1));
		
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t379'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t572'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "50");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t573'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "40");
		
		
		        Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
		        Row = createNodeAndAppandNode(oList, Rows, Row, "ROW");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        if (pCbList.GetDataRows()[0].id.indexOf("noItems") > -1) {
		            pCbList.DeleteRow(pCbList.GetDataRows()[0].id);
		        }
		
		        pCbList.AddDataRow(row, oList);
		
		        if("<c:out value='${userInfo.lang}'/>" == "1") { 
		        	row.cells[0].innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TITLE");
		        } else { 
		        	row.cells[0].innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TITLE2");
		        } 
		
		        SetAttribute(row.cells[0], "DATA1", g_SelCabID);
		        SetAttribute(row.cells[0], "DATA2", SelectSingleNodeValueNew(objCabInfoXml, "RESULT/TASKCODE"));
		        SetAttribute(row.cells[0], "DATA3", SelectSingleNodeValueNew(objCabInfoXml, "RESULT/RECTYPE"));
		
		        row.cells[1].innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/REGSN");
		        row.cells[2].innerHTML = SelectSingleNodeValueNew(objCabInfoXml, "RESULT/VOLNO");
		    }
		    function InitCabClassInfo(objCabInfoXml) {
		        AddPreSelectedCabient(objCabInfoXml);
		    }
		    function InitCode() {
		        var result = "";
		        
		        $.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getCodeList.do",
		    		data : {
		    			companyID : CompanyID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    			
		    			if (SelectSingleNodeValue(result, "RESULT") == "FALSE") {
				            alert("<spring:message code='ezApprovalG.t952'/>");
				        }
		    		},
		    		error : function() {
		    			alert("<spring:message code='ezApprovalG.t952'/>");
		    		}
		    	});
		
		        g_CodeInfoXml = result;
		    }
		    function SelCabinetList_rowdblclick() {
		        DelListRow(SelCabinetList);
		    }
		    function CabinetList_rowdblclick() {
		        AddRowToCabList();
		    }
		    function AddCabList_onclick() {
		        AddRowToCabList();
		    }
		    function DelCabList_onclick() {
		        DelListRow(SelCabinetList);
		    }
		    function AddRowToCabList() {
		        var IsValueInList = false;
		        var selRow;
		        var count;
		        var pLvList = new ListView();
		        pLvList.LoadFromID("DivCabinetList");
		        var length = pLvList.GetSelectedRows().length;
		
		        var pSCList = new ListView();
		        pSCList.LoadFromID("pSCLvList");
		
		        var SelCabRows;
		
		        if (g_InitFlag == "1")
		        {
		            SelCabRows = SelCabinetList.rows;
		            SelCabRows = pSCList.GetDataRows();
		            if (SelCabRows.length > 0) {
		                selRow = SelCabRows[0];
		                pSCList.DeleteRow(selRow.getAttribute("id"));
		            }
		
		            selRow = pLvList.GetSelectedRows();
		            AddRow(selRow);
		        }
		        else
		        {
		            for (count = 0; count < length; count++) {
		                selRow = pLvList.GetSelectedRows()[count];
		
		                var totalRows = pSCList.GetDataRows();
		
		                if (totalRows.length > 0) {
		                    var i;
		                    for (i = 0; i < totalRows.length; i++) {
		                        if (totalRows[i].cells[0].DATA1 == selRow[0].DATA1) {
		                            IsValueInList = true;
		                            break;
		                        }
		                    }
		                }
		                if (!IsValueInList) {
		                    AddRow(selRow);
		                }
		                IsValueInList = false;
		            }
		        }
		    }
		    function AddRow(selRow) {
		        var oList, ListViewData, Headers, Header, HName, HWidth, Rows, Row, Cell, Value, Data, node;
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pSCLvList");
		
		        var RowCount = pLvList.GetRowCount();
		        var cnTr = pLvList.GetDataRows();
		        var MaxID = 0;
		        for (var j = 0  ; j < cnTr.length  ; j++) {
		            var curnum = Number(pLvList.GetSelectedRowID(j).substring(pLvList.GetSelectedRowID(j).lastIndexOf('_') + 1), pLvList.GetSelectedRowID(j).length);
		            if (MaxID < curnum)
		                MaxID = curnum;
		        }
		        var row = pLvList.NewAddRow(RowCount, "pSCLvList" + "_TR_" + eval(MaxID + 1));
		
		        oList = createXmlDom();
		
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t379'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t572'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "50");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t573'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "40");
		
		        Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
		        Row = createNodeAndAppandNode(oList, Rows, Row, "ROW");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		
		        Cell = createNodeAndAppandNode(oList, Row, Cell, "CELL");
		        createNodeAndAppandNodeText(oList, Cell, node, "VALUE", " ");
		        pLvList.AddDataRow(row, oList);
		
		        row.cells[0].innerHTML = selRow[0].cells[0].innerHTML;
		
		        SetAttribute(row.cells[0], "DATA1", GetAttribute(selRow[0], "DATA1"));
		        SetAttribute(row.cells[0], "DATA2", GetAttribute(selRow[0], "DATA2"));
		        SetAttribute(row.cells[0], "DATA3", selRow[0].cells[1].innerHTML);
		
		        row.cells[1].innerHTML = selRow[0].cells[4].innerHTML;
		        row.cells[2].innerHTML = selRow[0].cells[5].innerHTML;
		    }
		    function DelListRow(objListView) {
		        var selRow;
		        var count1, len;
		        var selRows;
		
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pSCLvList");
		
		        if (pLvList.GetRowCount() > 0) {
		            selRows = pLvList.GetSelectedRows();
		            if (selRows) {
		                if (typeof (selRows) != "undefined") {
		                    len = selRows.length;
		
		                    if (len > 0) {
		                        for (count1 = 0; count1 < len; count1++) {
		                            selRow = selRows[len - count1 - 1];
		                            if (selRow)
		                                pLvList.DeleteRow(selRow.getAttribute("id"));
		                        }
		                    }
		                }
		            }
		        }
		    }
		    function InitSelCabinetList() {
		        var oList, ListViewData, Headers, Header, HName, HWidth, Rows;
		
		        oList = createXmlDom();
		
		        ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
		        Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t379'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "120");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t572'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "50");
		
		        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
		        HName = createNodeAndAppandNodeText(oList, Header, HName, "NAME", "<spring:message code='ezApprovalG.t573'/>");
		        HWidth = createNodeAndAppandNodeText(oList, Header, HWidth, "WIDTH", "40");
		
		        var pLvList = new ListView();
		        pLvList.SetID("pSCLvList");
		        pLvList.SetMulSelectable(false);
		        pLvList.SetSelectFlag(false);
		        pLvList.SetRowOnDblClick(SelCabinetList_rowdblclick);
		        pLvList.DataSource(oList);
		        pLvList.DataBind("SelCabinetList");
		    }
		    function cmdCancel_onclick() {
		        rtnVal[0] = "FALSE";
		        if (ReturnFunction != null) {
		            ReturnFunction(rtnVal);
		        }
		        else {
		        	window.returnValue = rtnVal;
		            window.close();
		        }
		    }
		    function cmdConfirm_onclick() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pSCLvList");
		        var totalRows = pLvList.GetDataRows();
		
		        if (totalRows.length > 0 && totalRows[0].id.indexOf("noItems") == -1) {
		            rtnVal[0] = "TRUE";
		            rtnVal[1] = GetSelCabInfoXml();
		            
		            if (ReturnFunction != null) {
		                ReturnFunction(rtnVal);

		            }
		            else {
		            	window.returnValue = rtnVal;
		                window.close();
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t1122'/>");
		        }
		    }
		    window.onbeforeunload = function () {
		    	try {
		            window.returnValue = rtnVal;
				} catch (e) {
				}
		    }
		    function GetSelCabInfoXml() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("pSCLvList");
		
		        var totalRows = pLvList.GetDataRows();
		        var i;
		        var Root, cabinet, cabid;
		
		        var rtnXml = createXmlDom();
		        Root = createNodeInsert(rtnXml, Root, "DATA");
		
		        for (i = 0; i < totalRows.length; i++) {
		            cabinet = createNodeAndAppandNode(rtnXml, Root, cabinet, "CABINET");
		            cabid = createNodeAndAppandNodeText(rtnXml, cabinet, cabid, "CABINETID", GetAttribute(totalRows[i].cells[0], "DATA1"));
		
		            cabid = createNodeAndAppandNodeText(rtnXml, cabinet, cabid, "CABINETNAME", totalRows[i].cells[0].innerHTML);
		            cabid = createNodeAndAppandNodeText(rtnXml, cabinet, cabid, "RECTYPE", GetAttribute(totalRows[i].cells[0], "DATA3"));
		            cabid = createNodeAndAppandNodeText(rtnXml, cabinet, cabid, "CABINETSN", totalRows[i].cells[1].innerHTML);
		            cabid = createNodeAndAppandNodeText(rtnXml, cabinet, cabid, "CABINETVOLNO", totalRows[i].cells[2].innerHTML);
		            cabid = createNodeAndAppandNodeText(rtnXml, cabinet, cabid, "TASKCODE", GetAttribute(totalRows[i].cells[0], "DATA2"));
		        }
		        return getXmlString(rtnXml);
		    }
		
		    var createcabinet_cross_dialogArguments = new Array();
		    function btnCreateCab_onclick() {
		        if (InitTaskInfo())
		        {
		            var para = new Array();
		            var i;
		
		            for (i = 0; i < arrTask.length; i++)
		                para[i] = arrTask[i];
		            var url = "/ezApprovalG/createCabinet.do";
		
		            if (CrossYN()) {
		                createcabinet_cross_dialogArguments[0] = para;
		                createcabinet_cross_dialogArguments[1] = btnCreateCab_onclick_Complete;
		
		                DivPopUpShow(400, 440, url);
		            }
		            else {
		                var feature = "dialogWidth:370px;dialogHeight:450px;scroll:no;resizable:yes;status:no; help:no";
		                feature = feature + GetShowModalPosition(350, 380);
		
		                if (url != "")
		                    var rtn = window.showModalDialog(url, para, feature);
		
		                if (rtn[0] == "TRUE") {
		                    GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn[1], "1");
		                }
		            }
		        }
		    }
		    function btnCreateCab_onclick_Complete(rtn) {
		        DivPopUpHidden();
		        if (rtn[0] == "TRUE") {
		            GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn[1], "1");
		        }
		    }
		    function InitTaskInfo() {
		        var TaskInfoXml = GetTaskInfo();
		        if (TaskInfoXml.text == "FALSE") {
		            alert("<spring:message code='ezApprovalG.t1123'/>");
		            return false;
		        }
		        else {
		            arrTask[1] = SelectSingleNodeValue(TaskInfoXml.documentElement, "TASKNAME");
		            arrTask[2] = SelectSingleNodeValue(TaskInfoXml.documentElement, "TEMPFLAG");
		            arrTask[3] = SelectSingleNodeValue(TaskInfoXml.documentElement, "KEEPINGPERIOD");
		            arrTask[4] = SelectSingleNodeValue(TaskInfoXml.documentElement, "KEEPINGMETHOD");
		            arrTask[5] = SelectSingleNodeValue(TaskInfoXml.documentElement, "KEEPINGPLACE");
		            arrTask[6] = SelectSingleNodeValue(TaskInfoXml.documentElement, "DISPLAYRECFLAG");
		            arrTask[7] = SelectSingleNodeValue(TaskInfoXml.documentElement, "SCFLAG");
		            arrTask[8] = SelectSingleNodeValue(TaskInfoXml.documentElement, "SCINFO/LIST1");
		            arrTask[9] = SelectSingleNodeValue(TaskInfoXml.documentElement, "SCINFO/LIST2");
		            arrTask[10] = SelectSingleNodeValue(TaskInfoXml.documentElement, "SCINFO/LIST3");
		            arrTask[11] = SelectSingleNodeValue(TaskInfoXml.documentElement, "TASKNAME");
		            arrTask[12] = SelectSingleNodeValue(TaskInfoXml.documentElement, "TASKNAME2");
		            return true;
		        }
		    }
		    function GetTaskInfo() {
				var tempRet = "";
				
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/admin/ezApprovalG/getTaskInfo.do",
					async : false,
					data : {
							taskCode : arrTask[0],
							deptCode : "",
							companyID : CompanyID
							},
					success : function (result) {
						tempRet = loadXMLString(result);
					},
					error : function() {
						tempRet = loadXMLString("<RESULT>FALSE</RESULT>");
					}
				});
		
		        return tempRet;
		    }
		    function btnNewVolume_onclick() {
		        var pLvList = new ListView();
		        pLvList.LoadFromID("DivCabinetList");
		
		        var selnode = pLvList.GetSelectedRows();
		        if (selnode != null) {
		            var rtn = NewVolume(GetAttribute(selnode[0], "DATA1"), GetAttribute(selnode[0], "DATA3"));
		            if (!CrossYN() && rtn != "FALSE") {
		                GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn, "1");
		            }
		        }
		        else {
		            alert("<spring:message code='ezApprovalG.t913'/>");
		        }
		    }
		    function MM_swapImgRestore() {
		        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
		    }
		
		    function MM_preloadimages() {
		        var d = document; if (d.images) {
		            if (!d.MM_p) d.MM_p = new Array();
		            var i, j = d.MM_p.length, a = MM_preloadimages.arguments; for (i = 0; i < a.length; i++)
		                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
		        }
		    }
		    function MM_findObj(n, d) {
		        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
		            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
		        }
		        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
		        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document); return x;
		    }
		    function MM_swapImage() {
		        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
		            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
		    }

		    function onChange_SYear(obj) {
            	GetCabinetSimpleList(arr_userinfo[4], document.getElementById("selSYear").value, arrTask[0], g_SelCabID, g_InitFlag);
            }
		</script>
	</head>
	<body class="popup" style="margin-left:10px;margin-top:8px">
		<%-- <h1><spring:message code='ezApprovalG.t711'/></h1> --%> <!-- 기록물철 선택 -->
		<div id="menu">
			<ul id="trCreateCab" style="display: none">
	          <li id="btnCreateCab"><span onClick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></li> <!-- 철생성 -->
	          <li id="btnNewVolume" style="display: none"><span onClick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></li> <!-- 권호수 추가 -->
	        </ul>
		</div>
		<div id="close">
            <ul>
                <li><span id="btnCancel" onclick="return cmdCancel_onclick()"></span></li>
            </ul>
        </div>
        <table>
        	<tr>
        		<td style="display: flex; align-items: center;">
        			<h2 class="h2_dot" style="font-weight: normal; margin: 0; display: flex; align-items: center; padding: 0; line-height: 1.2;">
        				<spring:message code='ezApprovalG.t711'/>
        				<span style="display: flex; align-items: center;">
        				    <select name="selSYear" id="selSYear" onchange="onChange_SYear(this)" style="width: 80px; margin-left: 5px; text-align: center;"></select>
        				</span>
<!--         				<span id="trCreateCab"> -->
<%-- 	        				<a class="imgbtn imgbck" style="margin:-4px 0px 0px 228px;"><span onClick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></a> --%>
<%-- 					  		<a class="imgbtn imgbck" style="display:none;"><span onClick="return btnNewVolume_onclick()" ><spring:message code='ezApprovalG.t894'/></span></a> --%>
<!--         				</span> -->
        			</h2>
        		</td>
        		<td></td>
        		<td><h2 class="h2_dot" style="font-weight: normal"><spring:message code='ezApprovalG.t1120'/></h2></td>
        	</tr>
        	<tr>
        		<td>
					<div class="listview">
						<div id="CabinetList" style="border:0;HEIGHT: 410px; WIDTH: 380px;overflow:auto;"></div>
					</div>
        		</td>
        		<td>
					<a onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image93','','/images/arr_right.gif',1)" style="margin: 4px; cursor: pointer;"> 
						<img id="RecvAdd" border="0" src="/images/arr_right.gif" width="16" height="16" onClick="return AddCabList_onclick()">
					</a><br>
					<a onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image103','','/images/arr_left.gif',1)" style="margin: 4px; cursor: pointer;"> 
						<img id="RecvDel" border="0" src="/images/arr_left.gif" width="16" height="16"onClick="return DelCabList_onclick()">
					</a>
        		</td>
        		<td>
					<div class="listview">
						<div id="SelCabinetList" style="border:0; HEIGHT: 410px; WIDTH: 372px;overflow:auto;"></div>
					</div>
        		</td>
        	</tr>
        </table>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn"><span id="btnOK" onclick="return cmdConfirm_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
		</div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
