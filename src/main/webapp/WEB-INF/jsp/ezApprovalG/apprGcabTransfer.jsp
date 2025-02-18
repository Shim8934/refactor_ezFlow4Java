<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t560'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <style>
	    	.mainlist tr th {border-top:0px}
	    </style>
	    <script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OpenSelWin_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/OrganTree_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var xmlhttp = createXMLHttpRequest();
	        var g_STaskCode = "";
	        var g_DDeptCode = "";
	        var g_DDeptName = "";
	        var g_DTaskCode = "";
	        var g_DTaskName = "";
	        var g_SDeptCode = "<c:out value ='${userInfo.deptID}'/>";
	    	var g_SDeptName = "<c:out value ='${userInfo.deptName}' escapeXml='false'/>";
	        var CompanyID = "<c:out value ='${userInfo.companyID}'/>";
	        var UserLang = "<c:out value ='${userInfo.lang}'/>";
	        var date = new Date();
            var nowYear = date.getFullYear();
            var adminFlag = "<c:out value ='${adminFlag}'/>"; // 2024-06-12 전인하 - 관리자 여부 판별 플래그
            var listHeaderString = "${listHeaderString}"; // 2024-06-12 전인하 - 리스트헤더 정보
			var deptCabFlag = "N";
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>"; // 2024-07-18 양지혜 - 상위부서문서함 사용 관련
			
	        document.onselectstart = function () { return false; };
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            document.getElementById("tdSDeptName").innerText = g_SDeptName;
	            InitSelCabinetList();
	            
	            //2018-05-18 강민수92 셀렉트 박스 추가
	            for (var i = nowYear; i >= nowYear - 5; i--) {
	            	$('#selYear').append("<option value='" + i + "'>" + i + "</option>")
	            }
				
	            $("#selYear").val(nowYear).prop("selected", true);
				$("#selYear2").text($("#selYear").val());
	        };
	
	        function bt_OK_onclick() {
	        	/*
	        		기록물철 인계할 때 인계부서 단위업무 체크 로직 추가
	        	*/
	        	/*var isEmptyCode = $("#tdSTaskCode").text().trim();
        	
	        	if(isEmptyCode === "" || isEmptyCode === null) {
	        		alert("<spring:message code='ezApprovalG.pjg05'/>");
	        		return;
	        	}*/
	        	
	            var SelCabinetList = new ListView();
	            SelCabinetList.LoadFromID("DivSelCabinetList");
	            var length = SelCabinetList.GetRowCount();
	            if (length > 0 && SelCabinetList.GetDataRows()[0].id.indexOf("noItems") == -1) {
					if (g_DDeptCode == "") {
					    alert("<spring:message code='ezApprovalG.t561'/>");
					}
					else if (g_DTaskCode == "") {
					    alert("<spring:message code='ezApprovalG.t562'/>");
					}
					else {
					    if (TransferCabinet()) {
					        alert("<spring:message code='ezApprovalG.t563'/>");
							if(deptCabFlag == "Y"){
								GetCabinetSimpleList(g_SDeptCode, "", "", "", "2", $('#selYear').val());
							}else{
								GetCabinetSimpleList(g_SDeptCode, "", g_STaskCode, "", "2", $('#selYear').val());
							}
					        DelAllRowOfLV("DivSelCabinetList");
					    }
					}
			    } else {
		        	alert("<spring:message code='ezApprovalG.t566'/>");
		        }
	    	}
	
	    function GetDeptRecAdminInfo() {
	        var pSearchList = "extensionAttribute1::m=1;;EXACT_Department::" + g_DDeptCode;
	        var pCellList = "CN;displayname;";
	        var pPropList = "displayname";
	        var pClass = "user";
	        var arrUserInfo = new Array();
	        arrUserInfo[0] = "";
	        arrUserInfo[1] = "";
	        arrUserInfo[2] = "";
	        var rtnXml = OrganSearch(pSearchList, pCellList, pPropList, pClass);
	        var nlRow = SelectNodes(rtnXml, "LISTVIEWDATA/ROWS/ROW/CELL");
	        if (nlRow.length > 0) {
	            arrUserInfo[0] = SelectSingleNodeValue(nlRow[0], "VALUE");
	            arrUserInfo[1] = SelectSingleNodeValue(nlRow[0], "DATA4");
	            arrUserInfo[2] = SelectSingleNodeValue(nlRow[0], "DATA5");
	        }
	        return arrUserInfo;
	    }
	
	    function TransferCabinet() {
	        var arrDeptAdmInfo = GetDeptRecAdminInfo();
	        var XmlHttp = createXMLHttpRequest();
	        var xmlpara = createXmlDom();
	        var objNode;
	        createNodeInsert(xmlpara, objNode, "PARAMETERS");
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTCODE", g_DDeptCode);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTNAME", g_DDeptName);
	        createNodeAndInsertText(xmlpara, objNode, "DTASKCODE", g_DTaskCode);
	        createNodeAndInsertText(xmlpara, objNode, "DTASKNAME", g_DTaskName);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTMID", arrDeptAdmInfo[0]);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTMNAME", arrDeptAdmInfo[1]);
	        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", CompanyID);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTNAME2", g_DDeptName);
	        createNodeAndInsertText(xmlpara, objNode, "DTASKNAME2", g_DTaskName);
	        createNodeAndInsertText(xmlpara, objNode, "DDEPTMNAME2", arrDeptAdmInfo[2]);
	        var objCabXml = GetSelCabInfo();
	        var xmlDoc;
	        if (CrossYN()) {
	            var nodeToImport = xmlpara.importNode(objCabXml.documentElement, true);
	            xmlpara.documentElement.appendChild(nodeToImport);
	        }
	        else {
	            xmlpara.documentElement.appendChild(objCabXml.documentElement);
	        }
	        XmlHttp.open("POST", "/ezApprovalG/transferCab.do", false);
	        XmlHttp.send(xmlpara);

	        if (XmlHttp != null && XmlHttp.readyState == 4) {
	        	 if (XmlHttp.status == 200) {
	        		 var rtnVal = getNodeText(XmlHttp.responseXML.documentElement);
	        		  if (rtnVal == "NODEPTADMIN") {
	      	            alert("<spring:message code='ezApprovalG.t567'/>");
	      	            return false;
	      	        } else {
	      	        	return true;
	      	        }
	        	 } else {
	        		 alert("<spring:message code='ezApprovalG.t568'/>");
		             return false;
	        	 }
	        } 
	    }
	
	    function GetSelCabInfo() {
	        var oXml = createXmlDom();
	        var objNode;
	        createNodeInsert(oXml, objNode, "CABINETLIST");
	        var CabList = new ListView();
	        CabList.LoadFromID("DivSelCabinetList");
	        var len = CabList.GetRowCount();
	        var Rows = CabList.GetDataRows();
	        var i;
	        if (len > 0) {
	            for (i = 0; i < len; i++) {
	                createNodeAndInsertText(oXml, objNode, "ID", Rows[i].getAttribute("DATA1"));
	                createNodeAndInsertText(oXml, objNode, "PRODUCTIONYEAR", Rows[i].getAttribute("DATA7"));
	            }
	        }
	        return oXml;
	    }
	
	    function bt_Cancle_onclick() {
	        window.close();
	    }
	
	    function btnChangeDDept_onclick() {
	        SelectDept("OPEN", btnChangeDDept_onclick_Complete);
	    }
	
	    function btnChangeDDept_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE") {
	            if (g_SDeptCode == rtn[1]) {
	                alert("<spring:message code='ezApprovalG.t569'/>");
	                return;
	            }
	            if (g_DDeptCode != rtn[1]) {
	                g_DTaskCode = "";
	                g_DTaskName = "";
	                document.getElementById("tdDTaskCode").innerText = " ";
	                document.getElementById("tdDTaskName").innerText = " ";
	            }
	            g_DDeptCode = rtn[1];
	            g_DDeptName = rtn[2];
	            document.getElementById("tdDDeptName").innerText = g_DDeptName;
	        }
	    }
	    
	    // 2024-06-12 전인하 - 인계부서 선택 버튼 동작 메서드 
        function btnChangeSDept_onclick() {
            SelectDept("OPEN", btnChangeSDept_onclick_Complete);
        }
    
        function btnChangeSDept_onclick_Complete(rtn) {
            if (rtn[0] == "TRUE") {
                if (g_DDeptCode == rtn[1]) {
                    alert("<spring:message code='ezApprovalG.t569'/>");
                    return;
                }
                if (g_SDeptCode != rtn[1]) {
                    g_STaskCode = "";
                    g_STaskName = "";
                    document.getElementById("tdSTaskCode").innerText = " ";
                    document.getElementById("tdSTaskName").innerText = " ";
                }
                g_SDeptCode = rtn[1];
                g_SDeptName = rtn[2];
                document.getElementById("tdSDeptName").innerText = g_SDeptName;
            }
        }
	
	    function btnChangeSTask_onclick() {
	       SelectTask(g_SDeptCode, g_SDeptName, "0", "0", "OPEN", btnChangeSTask_onclick_Complete);
			deptCabFlag = "N";
	    }
	
	    function btnChangeSTask_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE")
	            GetSelSTaskInfo(rtn[1]);
	    }
	
	    function btnChangeDTask_onclick() {
	        if (g_SDeptCode == "") {
	            alert("<spring:message code='ezApprovalG.t561'/>");
	        }
	        else {
	            SelectTask(g_DDeptCode, g_DDeptName, "1", "0", "OPEN", btnChangeDTask_onclick_onclick_Complete);
	        }
	    }
	
	    function btnChangeDTask_onclick_onclick_Complete(rtn) {
	        if (rtn[0] == "TRUE")
	            GetSelDTaskInfo(rtn[1]);
	    }
	
	    function GetSelSTaskInfo(szTaskXml) {
	        var oXml = loadXMLString(szTaskXml);
	        g_STaskCode = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/CODE")[0]);
	        document.getElementById("tdSTaskCode").innerText = g_STaskCode;
	        document.getElementById("tdSTaskName").innerText = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/NAME")[0]);
	        
	        var selYear = $('#selYear').val();
	        
	        GetCabinetSimpleList(g_SDeptCode, "", g_STaskCode, "", "2", selYear);
	    }
	
	    function GetSelDTaskInfo(szTaskXml) {
	        var oXml = loadXMLString(szTaskXml);
	        g_DTaskCode = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/CODE")[0]);;
	        g_DTaskName = getNodeText(SelectNodes(oXml, "/TASKINFO/TASK/NAME")[0]);;
	        document.getElementById("tdDTaskCode").innerText = g_DTaskCode;
	        document.getElementById("tdDTaskName").innerText = g_DTaskName;
	    }
	
	    function SelCabinetList_rowdblclick() {
	        DelListRow("DivSelCabinetList");
	        setDeleteRow("DivSelCabinetList");
	    }
	
	    function CabinetList_rowdblclick() {
	        AddRowToCabList();
	    }
	
	    function AddCabList_onclick() {
	        AddRowToCabList();
	    }
	
	    function DelCabList_onclick() {
	        DelListRow("DivSelCabinetList");
	    }
	
	    function btnAddAll_onclick() {
	        AddAllRowToCabList();
	    }
	
	    function AddRowToCabList() {
	        var IsValueInList = false;
	        var selRow;
	        var count;
	        var CabList = new ListView();
	        CabList.LoadFromID("DivCabinetList");
	        var selRows = CabList.GetSelectedRows();
	        var length = selRows.length;;
	        if (length > 0) {
	            for (count = 0; count < length; count++) {
	                selRow = selRows[count];
	
	                var SelListView = new ListView();
	                SelListView.LoadFromID("DivSelCabinetList");
	                var totalRows = SelListView.GetDataRows();
	
	                if (totalRows.length > 0) {
	                    var i;
	                    for (i = 0; i < totalRows.length; i++) {
	                        if (totalRows[i].getAttribute("DATA1") == selRow.getAttribute("DATA1")) {
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
	
	    function AddAllRowToCabList() {
	        var IsValueInList = false;
	        var count;
	        var CabListView = new ListView();
	        CabListView.LoadFromID("DivCabinetList");
	        var selRows = CabListView.GetDataRows();
	        var length = selRows.length;
	        if (length > 0) {
	            for (count = 0; count < length; count++) {
	                selRow = selRows[count];
	                var SelListView = new ListView();
	                SelListView.LoadFromID("DivSelCabinetList");
	                var totalRows = SelListView.GetDataRows();
	                if (totalRows.length > 0) {
	                    var i;
	                    for (i = 0; i < totalRows.length; i++) {
	                        if (totalRows[i].getAttribute("DATA1") == selRow.getAttribute("DATA1")) {
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
	        var Cnt002 = GetUncompleteDocCount(selRow.getAttribute("DATA1"));
	        var cabID = selRow.getAttribute("DATA1");
	        var cabName = selRow.getAttribute("DATA5");
	        if (Cnt002 > 0) {
	            alert(selRow.cells[0].innerText + "<spring:message code='ezApprovalG.t570'/>" + Cnt002 + "<spring:message code='ezApprovalG.t571'/>");
	            window.open("/ezApprovalG/getUncompleteDocListOpen.do?cabinetID=" + cabID + "&cabinetName=" + cabName, "getUncompleteDocListOpen", GetOpenWindowfeature(860,300));
	            return;
	        }
	        var SelListView = new ListView();
	        SelListView.LoadFromID("DivSelCabinetList");
	        
	        var Listlen = SelListView.GetDataRows();
	        var count = Listlen.length;
	        
	        if(count > 0) {
				if (Listlen[0].textContent == strLang944) {
					count = 0;
				}
	        }
	        
	        var row = "<ROW>";
	        for (let i=0; i<selRow.cells.length; i++) {
                row += "<CELL>";
                row += "<VALUE><![CDATA[" + selRow.cells[i].innerText +  "]]></VALUE>";
                if (i == 0) {
                    row += "<DATA1><![CDATA[" + selRow.getAttribute("DATA1") + "]]></DATA1>";
                    row += "<DATA2><![CDATA[" + selRow.getAttribute("DATA2") + "]]></DATA2>";
                    row += "<DATA3><![CDATA[" + selRow.getAttribute("DATA3") + "]]></DATA3>";
                    row += "<DATA4><![CDATA[" + selRow.getAttribute("DATA4") + "]]></DATA4>";
                    row += "<DATA5><![CDATA[" + selRow.getAttribute("DATA5") + "]]></DATA5>";
                    row += "<DATA6><![CDATA[" + selRow.getAttribute("DATA6") + "]]></DATA6>";
                    row += "<DATA7><![CDATA[" + selRow.getAttribute("DATA7") + "]]></DATA7>";                    
                }
                row += "</CELL>";
	        }
            row += "</ROW>";
            
	        var rowXml = loadXMLString(row);
	        var tr = SelListView.AddRow(count);
	        	SelListView.AddDataRow(tr, rowXml);
	    }
	
	    function GetUncompleteDocCount(pCabinetID) {
	    	var result = "";
	    	
	        $.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/ezApprovalG/getUncompleteDocCount.do",
	    		data : {
	    				deptCode : g_DDeptCode,
	    				companyID : CompanyID,
	    				cabinetID : pCabinetID
	    				},
	    		success: function(xml){
	    			result = loadXMLString(xml);
	    		}        			
	    	});

	        return getNodeText(result.documentElement);
	    }
	    
	    // 2024-06-12 전인하 - 하드코딩 제거, 기록물철리스트 리스트헤더 초기값 추가
	    function InitSelCabinetList() {
	        var ListViewData = loadXMLString(listHeaderString);
	        
	        var SelListView = new ListView();
	        SelListView.SetID("DivSelCabinetList");
	        SelListView.SetMulSelectable(false);
	        SelListView.SetRowOnDblClick("SelCabinetList_rowdblclick");
	        SelListView.DataSource(ListViewData);
	        SelListView.DataBind("SelCabinetList");
	        
            var SelListView2 = new ListView();
            SelListView2.SetID("CabinetList");
            SelListView2.SetMulSelectable(false);
            SelListView2.SetRowOnDblClick("CabinetList_rowdblclick");
            SelListView2.DataSource(ListViewData);
            SelListView2.DataBind("CabinetList");
	    }
	    
	    function selYear_onChange() {
	    	console.log(g_SDeptCode == "")
	    	console.log(g_STaskCode == "")
			$("#selYear2").text($("#selYear").val());
	    	if (g_SDeptCode != "" && g_STaskCode != "") {
	    		var selYear = $('#selYear').val();
	    		GetCabinetSimpleList(g_SDeptCode, "", g_STaskCode, "", "2", selYear);
	    	}
	    }
		
		function btnViewDeptCab_onclick(){
			if(g_SDeptCode == ""){
				alert("<spring:message code='ezApprovalG.lms01'/>")
				return;
			}
			GetCabinetSimpleList(g_SDeptCode, "", "", "", "2", $('#selYear').val());
			deptCabFlag = "Y";
		}
	
	    </script>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezApprovalG.t560'/></h1>
	    <div id="mainmenu">
	        <ul>
	            <li class="important"><span onclick="return bt_OK_onclick()"><spring:message code='ezApprovalG.t574'/></span></li>
	        </ul>
	    </div>
	    <table>
	        <tr>
	            <td style="width:49%">
	                <table class="content" style="width: 100%">
						<tr>
							<th><spring:message code='ezApprovalG.KMHG01'/></th>
							<td>
								<table style="border: 0px; width: 100%">
									<tbody>
									<tr>
										<td><select id="selYear" style="width: 55px;" onchange="selYear_onChange()"></select></td>
									</tr>
									</tbody>
								</table>
							</td>
						</tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t575'/></th>
	                        <%-- 2024-06-12 전인하 - 인계부서 선택 버튼 추가, 권한이 있을 때에만 표출함 --%>
	                        <td>
                                <table style="border: 0px; width: 100%">
                                    <tbody>
                                        <tr>
                                            <td id="tdSDeptName">&nbsp;</td>
                                            <c:if test="${adminFlag eq 'YES'}">
                                                <td style="width: 45px;">
                                                    <a class="imgbtn imgbck"><span onclick="return btnChangeSDept_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
                                                 </td>
                                            </c:if>
                                        </tr>
                                    </tbody>
                                </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t576'/></th>
	                        <td>
	                            <table style="border: 0px; width: 100%">
	                                <tr>
	                                    <td id="tdSTaskCode">&nbsp;</td>
	                                    <td style="width: 45px;">
	                                        <a class="imgbtn imgbck"><span onclick="return btnChangeSTask_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t577'/></th>
	                        <td id="tdSTaskName">&nbsp;</td>
	                    </tr>
	                </table>
	                <br>
					<h2 class="h2_dot" style="font-weight: normal;margin-bottom:10px;"><spring:message code='ezApprovalG.t578'/><span onclick="btnViewDeptCab_onclick()" class="imgbtn imgbck" style="float:right; height: 25px; text-align: center; cursor: pointer; color:#393939; border: 1px solid #CECECE; border-radius: 3px; padding-left: 12px; padding-right: 12px;"><spring:message code='ezApprovalG.KMHG02'/></span></h2>
	                
	                <div style="WIDTH: 100%; HEIGHT: 500px; OVERFLOW-Y: AUTO;" class="listview">
	                    <div id="CabinetList"></div>
	                </div>
	            </td>
	            <td style="text-align: center; width: 2%">
	                <img src="/images/arr_right.gif" name="Image191" onclick="return AddCabList_onclick()" style="cursor: pointer;margin-top:100px">
	                <img src="/images/arr_left.gif" name="Image201" onclick="return DelCabList_onclick()" style="padding-top: 5px; cursor: pointer;">
	                <img name="Image1911" src="/images/arr01a.gif" onclick="return btnAddAll_onclick()" style="padding-top: 20px;  cursor: pointer">
	            </td>
	            <td style="vertical-align: top; width:49%">
	                <table class="content" style="width: 100%">
						<tr>
							<th><spring:message code='ezApprovalG.KMHG01'/></th>
							<td>
								<table style="border: 0px; width: 100%">
									<tr>
										<td id="selYear2"></td>
									</tr>
								</table>
							</td>
						</tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t579'/></th>
	                        <td>
	                            <table style="width: 100%; border: 0px">
	                                <tr>
	                                    <td id="tdDDeptName">&nbsp;</td>
	                                    <td style="width: 45px;">
	                                        <a class="imgbtn imgbck"><span onclick="return btnChangeDDept_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t576'/></th>
	                        <td>
	                            <table style="width: 100%; border: 0px;">
	                                <tr>
	                                    <td id="tdDTaskCode">&nbsp;</td>
	                                    <td style="width: 45px;">
	                                        <a class="imgbtn imgbck"><span onclick="return btnChangeDTask_onclick()" style="width: 40px; text-align: center;"><spring:message code='ezApprovalG.t105'/></span></a>
	                                    </td>
	                                </tr>
	                            </table>
	                        </td>
	                    </tr>
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t577'/></th>
	                        <td id="tdDTaskName">&nbsp;</td>
	                    </tr>
	                </table>
	                <br>
	                <h2 class="h2_dot" style="font-weight: normal; margin-bottom:10px;"><spring:message code='ezApprovalG.t580'/></h2>
	                <div style="WIDTH: 100%; HEIGHT: 500px; OVERFLOW-Y: AUTO;" class="listview">
	                    <div id="SelCabinetList"></div>
	                </div>
	            </td>
	        </tr>
	    </table>
	</body>
</html>