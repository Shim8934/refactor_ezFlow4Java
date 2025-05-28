<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="title" value="${popUpType eq 'approver' ? 'email.appr.approver.add' : 'email.appr.exception.add'}" />
<!DOCTYPE html>
<html>
<head>
    <title><spring:message code="${title}"/></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/js/ezEmail/Controls/ezSearchDatePicker.htc')}">
    <link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}"/>
    <link rel="stylesheet" href="${util.addVer('/css/jquery.ui.all.css')}"/>
    <link rel="stylesheet" href="${util.addVer('/js/jquery/timeControls/jquery.timepicker.css')}"/>
    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/demos.css')}">
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/css/organ_tree.css')}" type="text/css">
    <style>
    	.mainlist #MsgToList_THEAD #MsgToList_TH {
    		height: 0px;
    	}
    </style>
</head>
<body class="popup" style="overflow:hidden">
<xml id="listviewheader" style="display: none;">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezEmail.t586'/></NAME>
                <WIDTH>40</WIDTH>
            </HEADER>
            <HEADER>
                <NAME>EMAIL</NAME>
                <WIDTH>100</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</xml>
<xml id="listviewheader2" style="display: none;">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezEmail.t31'/></NAME>
                <WIDTH>60</WIDTH>
            </HEADER>
            <HEADER>
                <NAME></NAME>
                <WIDTH>70</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><spring:message code='ezEmail.t28'/></NAME>
                <WIDTH>50</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><spring:message code='ezEmail.t29'/></NAME>
                <WIDTH>70</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</xml>
<xml id="listviewheader3" style="display: none;">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezEmail.t57'/></NAME>
                <WIDTH>70</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</xml>
<xml id="listviewheader4" style="display: none;">
    <LISTVIEWDATA>
        <HEADERS>
            <HEADER>
                <NAME><spring:message code='ezEmail.t31'/></NAME>
                <WIDTH>60</WIDTH>
            </HEADER>
            <HEADER>
                <NAME><spring:message code='ezEmail.t712'/></NAME>
                <WIDTH>65</WIDTH>
            </HEADER>
            <HEADER>
                <NAME>Email</NAME>
                <WIDTH>100</WIDTH>
            </HEADER>
        </HEADERS>
    </LISTVIEWDATA>
</xml>

<div id="menu">
	<h1><spring:message code="${title}"/></h1>
</div>
<div id="close">
	<ul>
        <li><span onclick="window.close()"></span></li>
    </ul>
</div>

<div class="layout">
    <%-- 조직도 --%>
    <%-- 공용배포그룹 선택된 구성원 목록 --%>
    <jsp:include page="/WEB-INF/jsp/ezEmail/common/mailOrganSelector.jsp">
    	<jsp:param name="selectOnlyUser" value="true" />
    	<jsp:param name="useOrgListCheckBox" value="false" />
    	<jsp:param name="hideDlTab" value="true" />
        <jsp:param name="hideManualTab" value="true"/>
        <jsp:param name="hideContactTab" value="true"/>
        <jsp:param name="initialDeptId" value="${companyId}"/>
        <jsp:param name="topCompId" value="${companyId}"/>
        <jsp:param name="adminDist" value="true"/>
        <jsp:param name="additionalHeight" value="0"/>
        <jsp:param name="rightPage" value="/WEB-INF/jsp/ezEmail/common/addApprUserSettingSelector.jsp"/>
        <jsp:param name="rightPageType" value="${popUpType}" />
    </jsp:include>
</div>

<div class="btnposition btnpositionNew">
    <a class="imgbtn" onclick="save()"><span><spring:message code='common.save' /></span></a>
</div>

<script src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
<script src="${util.addVer('ezEmail.e1', 'msg')}"></script>
<script src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}"></script>
<script src="${util.addVer('/js/ezEmail/js_cross/ListView_list.js')}"></script>
<script src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<script src="${util.addVer('/js/mouseeffect.js')}"></script>
<script src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
<script src="${util.addVer('/js/ezAddress/address_tree_Cross.js')}"></script>
<script src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
<script src="${util.addVer('/js/ezEmail/Controls_cross/datepicker.htc.js')}"></script>
<script src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
<script src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
<script src="${util.addVer('/js/ezEmail/js/email.pagination.js')}"></script>
<script src="${util.addVer('/js/input-util.js')}"></script>
<script src="${util.addVer('/js/ezEmail/js_cross/Newemail.js')}"></script>
<script src="${util.addVer('/js/ezEmail/js/email.organ.js')}"></script>
<script>
function addRow({type, id, name, email}) {
    const listView = new ListView();
    listView.LoadFromID("MsgToList");
    let rowXmlStr = "<LISTVIEWDATA2><ROWS><ROW><CELL>";

    switch (type) {
        case OrganSelectType.USER:
            if (listView.ExistRow("data1", id)) {
                return;
            }

            rowXmlStr += `<DATA1>\${id}</DATA1><DATA4>ORGAN</DATA4><VALUE>\${name}</VALUE>`;
            break;
        default: return;
    }

    rowXmlStr += "</CELL></ROW></ROWS></LISTVIEWDATA2>";

    // set ID
    const xml = loadXMLString(rowXmlStr);

    let maxId = 0;
    let initTr = listView.GetDataRows();
    let maxCntNum = 0;

    for (var j = 0; j < initTr.length; j++) {
        const id = listView.GetSelectedRowID(j);
        var curnum = Number(id.substring(id.lastIndexOf('_') + 1), id.length);
        if (maxId < curnum) {
            maxId = curnum;
            maxCntNum = j;
        }
    }

    const objTr = listView.AddRow(initTr.length);
    if (maxCntNum !== 0) {
        maxCntNum = maxCntNum + 1;
    }

    const maxNumId = listView.GetSelectedRowID(maxCntNum);
    objTr.id = maxNumId.substring(0, maxNumId.lastIndexOf('_') + 1) + (maxId + 1);
    listView.AddDataRow(objTr, xml);
	 // set ID END
	 
    applyListCountText();
}

function applyListCountText() {
    const count = document.querySelectorAll("#MsgToList > tbody > tr").length;
    document.getElementById("selected-count").textContent = count;
}

function DeleteReceiver(pListView) {
    var listid = "MsgToList";
    var selList = new ListView();
    selList.LoadFromID(listid);

    var arrRows = selList.GetSelectedRows();
    var strName = "";

    for (var i = 0; i < arrRows.length; i++) {
		selList.DeleteRow(arrRows[i].id);
    }

    applyListCountText();
}

function addByArrow() {
    getOrganSelectedRows()?.forEach(addRow);
}

function deleteByArrow() {
    DeleteReceiver();
}

async function save() {
	let userList = new Array();
	
	const listView = new ListView();
    listView.LoadFromID("MsgToList");

    let initTr = listView.GetDataRows();
    for (var j = 0; j < initTr.length; j++) {
    	userList.push(initTr[j].getAttribute("data1"));
    }

    const state = await window.opener.addUser_arg.save(userList);
	switch(state) {
		case "OK" :
			alert("<spring:message code='common.success.msg.save'/>");
			window.opener.addUser_arg.ok();
			window.close();
			break;
		case "ERROR" :
			alert("<spring:message code='common.error.msg'/>");
			break;
	}
}

// 조직도 선택 이벤트
addOnOrganSelectEvent(addRow);

window.addEventListener("load", async () => {
    // 사용자 목록 세팅
	const list = await (window.opener == null ? [] : window.opener.addUser_arg.getUserList());
	
    var pparsingXML = "";
	list.forEach(function(e, i) {
		var userName = MakeXMLString(e.userName);
		var userId = MakeXMLString(e.userId);
		pparsingXML = pparsingXML + "<ROW><CELL><DATA1>" + userId + "</DATA1><VALUE>" + userName + "</VALUE></CELL></ROW>";
    });
    pparsingXML = "<LISTVIEWDATA2><ROWS>" + pparsingXML + "</ROWS></LISTVIEWDATA2>";
    var resultxml = loadXMLString(pparsingXML);
    
	var listview = new ListView();
    listview.SetID("MsgToList");
    listview.SetSelectFlag(false);
    listview.SetMulSelectable(false);
    listview.SetRowOnDblClick("DeleteReceiver");
    listview.DataSource(resultxml);
    listview.DataBind("ListViewMsgTo");
    listview.RowDataBind();

    applyListCountText();
});

</script>
</body>
</html>
