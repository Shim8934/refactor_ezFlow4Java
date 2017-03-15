<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE HTML>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t1187'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script> 
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/ezApprovalG/selectContainer_Cross.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
			var OrderCell = "";
		    var labelcolor = "gray";
		    var xmlhttp = createXMLHttpRequest();	
		    var xmldoc = createXmlDom();		
		    var pDeptID ;
		    if (new RegExp(/Chrome/).test(navigator.userAgent) || new RegExp(/Safari/).test(navigator.userAgent)) {
		        window.onblur = function () {
		            window.focus();
		        }
		    }
		
		    var ReturnFunction;
		    window.onload = function () {
		        pDeptID = "${userInfo.deptID}";
		
		        if (CrossYN() || opener.SelCont_dialogArgument != undefined)
		        {
		            ReturnFunction = opener.SelCont_dialogArgument[1];
		        }
		        else
		            window.returnValue = "";
		
		        listHeader();
		        Init();
		    }
		
		    function listHeader() {
		        xmldoc = loadXMLString(DEPTLIST.innerHTML.toUpperCase());
		        var listview = new ListView();
		        listview.SetID("lvtDept");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnClick("lvtDept_SelChange");
		        listview.DataSource(xmldoc);
		        listview.DataBind("divlvtDept");
		        xmldoc = loadXMLString(CONTLIST.innerHTML.toUpperCase());
		        
		        var listview = new ListView();
		        listview.SetID("lvtCont");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("lvtCont_rowdblclick");
		        listview.DataSource(xmldoc);
		        listview.DataBind("divlvtCont");
		        xmldoc = loadXMLString(SELCONTLIST.innerHTML.toUpperCase());
		
		        var listview = new ListView();
		        listview.SetID("lvtdepCont");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("lvtdepCont_rowdblclick");
		        listview.DataSource(xmldoc);
		        listview.DataBind("divlvtdepCont");
		        
		    }
		
		    function lvtDept_SelChange() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtDept");
		        var oArrRows = listview.GetSelectedRows();
		        var selRow = oArrRows[0];
		
		        if (selRow != "") {
		            DeptID = GetAttribute(selRow, "DATA1");
		            isOwnflag = GetAttribute(selRow, "DATA2");
		
		            getUseContainer(DeptID, isOwnflag);
		        }
		    }
		
		   
		    function deleteCont_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("lvtdepCont");
		        oArrRows = listview.GetSelectedRows();
		        var selRow = oArrRows[0];
		        if (selRow) {
		            listview.DeleteRow(GetAttribute(selRow, "id"));
		        }
		    }
		
		    function lvtCont_rowdblclick() {
		        insertCont_onclick();
		    }
		
		    function lvtdepCont_rowdblclick() {
		        deleteCont_onclick();
		    }
		
		    function cmdOK_onclick() {
		
		        var RtnVal = new Array()
		        var i
		
		        var listview = new ListView();
		        listview.LoadFromID("lvtdepCont");
		        oArrRows = listview.GetDataRows();
		
		        for (i = 0 ; i < oArrRows.length ; i++) {
		            var Rows = oArrRows[i];
		            RtnVal[i] = GetAttribute(Rows, "DATA2");
		        }
		
		        if (CrossYN() || opener.SelCont_dialogArgument != undefined )
		        {
		            ReturnFunction(RtnVal);
		        }
		        else
		        {
		            window.returnValue = RtnVal;         
		        }
		        window.close();
		    }
		    
		    function insertCont_onclick() {
		        var DeptName, DeptID, ContName, ContID, i, flag;
		        var listview = new ListView();
		        listview.LoadFromID("lvtCont");
		        var oArrRows = listview.GetSelectedRows();
		        var selRow = oArrRows[0];

		        if (selRow) {
		            ContName = getNodeText(selRow.childNodes[0]);
		            ContID = GetAttribute(selRow, "DATA1");
		        }

		        listview = new ListView();
		        listview.LoadFromID("lvtDept");
		        oArrRows = listview.GetSelectedRows();
		        selRow = oArrRows[0];

		        if (selRow) {
		            DeptName = getNodeText(selRow.childNodes[0]);
		            DeptID = GetAttribute(selRow, "DATA1");
		        }


		        listview = new ListView();
		        listview.LoadFromID("lvtdepCont");

		        if (listview.GetDataRows().length == 1 && listview.GetDataRows()[0].id == "lvtdepCont_TR_noItems") {
		            listview.DeleteRow(listview.GetDataRows()[0].id);
		        }

		        oArrRows = listview.GetDataRows();

		        flag = true;
		        for (i = 0 ; i < oArrRows.length ; i++) {
		            var Row = oArrRows[i];
		            if ((GetAttribute(Row, "DATA1") == DeptID) && (GetAttribute(Row, "DATA2") == ContID)) {
		                flag = false
		                break;
		            }
		        }

		        if (flag) {

		            listview = new ListView();
		            listview.LoadFromID("lvtdepCont");
		            oArrRows = listview.GetDataRows();
		            var lastRowIdx = oArrRows.length
		            var xmlRtn = createXmlDom();

		            var strXML = listAdd(DeptName, ContName, DeptID, ContID, lastRowIdx)

		            xmlRtn = loadXMLString(strXML);

		            if (lastRowIdx < 1) {
		                document.getElementById('divlvtdepCont').innerHTML = "";
		                var listview = new ListView();
		                listview.SetID("lvtdepCont");
		                listview.SetMulSelectable(false);
		                listview.SetRowOnDblClick("lvtdepCont_rowdblclick");
		                listview.DataSource(xmlRtn);
		                listview.DataBind("divlvtdepCont");
		            }
		            else {
		                var objTr = listview.AddRow(lastRowIdx);
		                SetAttribute(objTr, "id", "lvtdepCont" + "_TR_" + lastRowIdx);
		                listview.AddDataRow(objTr, xmlRtn);
		            }
		        }

		        listview.SetSelectFlag(true);
		    }
		    
		    function cmdcancel_onclick() {
		        if (CrossYN() || opener.SelCont_dialogArgument != undefined) {
		            ReturnFunction("");
		        }
		        else {
		            window.returnValue = "";
		        }
		        window.close();
		    }
		
		    function MM_swapImgRestore() {
		        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
		    }
		
		    function MM_preloadImages() {
		        var d = document; if (d.images) {
		            if (!d.MM_p) d.MM_p = new Array();
		            var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
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
	</script>
	</head>

<body class="popup"> 
<XML id="DEPTLIST" style="display:none">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezApprovalG.t1221'/></NAME>
                <WIDTH>90</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</XML>
<XML id="CONTLIST" style="display:none">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezApprovalG.t1548'/></NAME>
                <WIDTH>90</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</XML>
<XML id="SELCONTLIST" style="display:none">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezApprovalG.t687'/></NAME>
                <WIDTH>50</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><spring:message code='ezApprovalG.t1549'/></NAME>
                <WIDTH>50</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</XML> 
<h1><spring:message code='ezApprovalG.t1187'/></h1>
<table> 
  <tr> 
    <td>
        <h2><spring:message code='ezApprovalG.t1124'/></h2>
	    <div class="listview">
	        <div id="divlvtDept" style="border:0; Width:260px; Height:300px; font-size:9pt" > </div>
	    </div>
	</td> 
    <td style="padding-left:12px;padding-right:2px" >
        <h2><spring:message code='ezApprovalG.t1550'/></h2> 
	    <div class="listview">
	        <div id="divlvtCont" style="border:0; Width:260px; Height:300px; font-size:9pt" > </div>
	    </div>
	</td> 
    <td style="width:30px">
        <img src="/images/arr_right.gif" style="cursor:pointer" width="16" height="16" onClick="return insertCont_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image191','','images/arrow_add1.gif',1)" />
	    <img src="/images/arr_left.gif"style="cursor:pointer"  width="16" height="16" onClick="return deleteCont_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image201','','images/arrow_delete1.gif',1)" />
	</td> 
    <td style="padding-left:2px">
        <h2><spring:message code='ezApprovalG.t1551'/></h2>
	    <div class="listview">
	        <div id="divlvtdepCont" style="Width:370px; Height:300px;" ></div>
	    </div>
	</td> 
  </tr> 
</table> 
<div class="btnposition">
    <a class="imgbtn" onClick="return cmdOK_onclick()" ><span><spring:message code='ezApprovalG.t1760'/></span></a>
    <a class="imgbtn" onClick="return cmdcancel_onclick()" ><span><spring:message code='ezApprovalG.t1761'/></span></a>
</div>
</body>
</html>
