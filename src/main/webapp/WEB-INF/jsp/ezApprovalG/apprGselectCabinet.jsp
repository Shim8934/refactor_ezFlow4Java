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
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabCategoryInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabinetInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/CabRoleInfo_Cross.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/MiscFunc_Cross.js')}"></script>
	    <script type="text/javascript" id="clientEventHandlersJS">
	        var OrderCell = "";
	        var g_InitFlag = "<c:out value='${initFlag}'/>";
	        var bDisplayFlag = "0";
	        var bSpecialFlag = "0";
	        var arrTask = new Array();
	        var rtnVal = new Array();
	        var g_SelCabID = "";
	        var AdminYN = "FALSE";
	        var szRoleInfo = "<c:out value='${userInfo.rollInfo}'/>";
	        var g_bRecAdmin = false;
	        var g_bDeptCharger = false;
	        var xmlhttp = createXMLHttpRequest();
	        var pUserID = "<c:out value='${userInfo.id}'/>";
	        var CompanyID = "<c:out value='${userInfo.companyID}'/>";
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "<c:out value='${userInfo.id}'/>";
	        arr_userinfo[2] = "<c:out value='${userInfo.displayName}'/>";
	        arr_userinfo[3] = "<c:out value='${userInfo.title}'/>";
	        arr_userinfo[4] = "<c:out value='${userInfo.deptID}'/>";
	        arr_userinfo[5] = "<c:out value='${userInfo.deptName}'/>";
	        arr_userinfo[6] = "<c:out value='${userInfo.jikChek}'/>";
	        arr_userinfo[8] = "<c:out value='${userInfo.email}'/>";
	        arr_userinfo[9] = CompanyID;
	        arr_userinfo[11] = "<c:out value='${userInfo.displayName1}'/>";
	        arr_userinfo[12] = "<c:out value='${userInfo.displayName2}'/>";
	        arr_userinfo[13] = "<c:out value='${userInfo.title1}'/>";
	        arr_userinfo[14] = "<c:out value='${userInfo.title2}'/>";
	        arr_userinfo[15] = "<c:out value='${userInfo.deptName1}'/>";
	        arr_userinfo[16] = "<c:out value='${userInfo.deptName2}'/>";
	        var UserLang = "<c:out value='${userInfo.lang}'/>";
	        var RetValue;
	        var ReturnFunction;
	        //반송,회송 대장등록시 기록물철 선택해주기 위해 추가
	        var hesongFlag = "<c:out value='${hesongFlag}'/>";
	        var regDocId = "<c:out value='${regDocId}'/>";
	        var receiptFlag = '';
	        
	        // 2023-08-29 조수빈 - 일괄접수자전결인 경우에만 opener가 있고 접수자전결은 없기 때문에 null로 인한 에러 처리를 위해 추가
	        if (opener) {
	        	receiptFlag = opener.receiptFlag;
	        }

			/* 2024-07-18 양지혜 - 상위부서문서함 관련 */
			var upperDeptCode = "<c:out value ='${upperDeptCode}'/>";

	        window.onload = function () {
	            try {
	                RetValue = parent.selectcabinet_cross_dialogArguments[0];
	                ReturnFunction = parent.selectcabinet_cross_dialogArguments[1];
	            } catch (e) {
	                try {
	                    RetValue = opener.selectcabinet_cross_dialogArguments[0];
	                    ReturnFunction = opener.selectcabinet_cross_dialogArguments[1];
	                } catch (e) {
	                    RetValue = window.dialogArguments;
	                }
	            }
	            g_SelCabID = RetValue[0];
	            rtnVal[0] = "FALSE";
	            initUserRoleinfo();
	            if (g_InitFlag == "1") {
	                if (g_bRecAdmin || AdminYN == "TRUE" || g_bDeptCharger) {
	                    document.getElementById("trCreateCab").style.display = "";
	                    document.getElementById("trCreateCabDummy").style.display = "none";
	                }
	                else {
	                    document.getElementById("trCreateCab").style.display = "none";
	                    document.getElementById("trCreateCabDummy").style.display = "";
	                }
	            }
	            g_DeptCode = arr_userinfo[4];
	            g_DeptName = arr_userinfo[5];
	            InitSelCabinetList();
	            if (typeof (g_SelCabID) != "undefined") {
	                if (g_SelCabID != "") {
	                    InitCabClassInfo(GetCabinetClassInfo(g_SelCabID));
	                }
	            }
	            var date = new Date();
	            var nowYear = date.getFullYear();
	            
	            //2018-05-18 강민수92 셀렉트 박스 추가
	            for (var i = nowYear; i >= nowYear - 7; i--) {
	            	$('#selYear').append("<option value='" + i + "'>" + i + "</option>")
	            }
				
	            $("#selYear").val(nowYear).prop("selected", true);
	            InitCategorySelection();
	            selTaskCategory_onchange();
	            
	            if (receiptFlag == 'J') {
	            	// 2024-05-21 조수빈 - 일괄접수 시 문서 정보가 유지됨을 안내하는 문구 추가
             		var h1_header = document.getElementById("h1Title");
             		h1_header.parentNode.style.display = 'flex';
	             	var newH2 = document.createElement('h1');
	             	var h2Text = document.createTextNode("<spring:message code='ezApprovalG.jsb01'/>");
	             	newH2.appendChild(h2Text);
	             	newH2.style.marginLeft = '10px';
	             	newH2.style.color = 'red';
	             	
	             	h1_header.parentNode.insertBefore(newH2, h1_header.nextSibling);
	            }
	        };
	        function KeEventControl(obj) {
	            useragt = navigator.userAgent.toUpperCase();
	            if (useragt.indexOf("SAFARI") > 0 && useragt.indexOf("CHROME") < 0) //사파리 브라우저일 경우
	            {
	                return;
	            }
	            obj.onkeydown = function () {
	                if (parseInt(window.event.keyCode) >= 48 && parseInt(window.event.keyCode) <= 126)
	                    return false;
	                if (parseInt(window.event.keyCode) == 189 || parseInt(window.event.keyCode) == 187 ||
	                        parseInt(window.event.keyCode) == 220 || parseInt(window.event.keyCode) == 219 ||
	                        parseInt(window.event.keyCode) == 221 || parseInt(window.event.keyCode) == 222 ||
	                        parseInt(window.event.keyCode) == 186 || parseInt(window.event.keyCode) == 188 ||
	                        parseInt(window.event.keyCode) == 190 || parseInt(window.event.keyCode) == 191 || parseInt(window.event.keyCode) == 32)
	                    return false;
	            };
	        }
	        function InitCabClassInfo(objCabInfoXml) {
	            g_arrInitValue[0] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "CATECODE"));
	            g_arrInitValue[1] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "MCATECODE"));
	            g_arrInitValue[2] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "SCATECODE"));
	            g_arrInitValue[3] = getNodeText(SelectSingleNode(objCabInfoXml.documentElement, "TASKCODE"));
	        }
	        function TaskList_rowclick() {
	            var listview = new ListView();
	            listview.LoadFromID("DivTaskList");
	            var selnode = listview.GetSelectedRows();
	            if (selnode.length != 0) {
	                arrTask[0] = selnode[0].getAttribute("DATA1");
	                arrTask[1] = selnode[0].cells[1].innerText;
	                arrTask[3] = selnode[0].getAttribute("DATA2");
	                bDisplayFlag = selnode[0].getAttribute("DATA4");
	                bSpecialFlag = selnode[0].getAttribute("DATA5");
	                GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], g_SelCabID, g_InitFlag, $('#selYear').val());
	                if (typeof (g_SelCabID) != "undefined") {
	                    if (g_SelCabID != "") {
	                        AddRowToCabList();
	                    }
	                }
	                g_SelCabID = "";
	            }
	            else {
	                GetCabinetSimpleList("", "", "__Dump__Year__", "", g_InitFlag, $('#selYear').val());
	            }
	        }
	        function SelCabinetList_rowdblclick() {
	            DelListRow(SelCabinetList);
	        }
	        function SelCabinetList_rowclick() {
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
	            var listview = new ListView();
	            listview.LoadFromID("DivCabinetList");
	            var length = listview.GetSelectedRows().length;
	            var SelCabRows;
	            if (length > 0) {
	                if (g_InitFlag == "1") {
	                    var SelCab = new ListView();
	                    SelCab.LoadFromID("DivDivCabinetList");
	                    SelCabRows = SelCab.GetDataRows();
	
	                    if (SelCabRows.length > 0) {
	                        var selIdx = SelCabRows[0].getAttribute("id");
	                        SelCab.DeleteRow(selIdx);
	                    }
	
	                    selRow = listview.GetSelectedRows()[0];
	                    AddRow(selRow);
	                }
	                else {
	                    for (count = 0; count < length; count++) {
	                        selRow = listview.GetSelectedRows()[count];
	                        var SelCab = new ListView();
	                        SelCab.LoadFromID("DivDivCabinetList");
	                        var totalRows = SelCab.GetDataRows();
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
	        }
	        function AddRow(selRow) {
	            var selCabList = new ListView();
	            selCabList.LoadFromID("DivDivCabinetList");
	            var row = "<ROW>";
	            row += "<CELL>"
	            row += "<VALUE><![CDATA["
	            row += getNodeText(selRow.cells[0]);
	            row += "]]></VALUE>"
	            row += "<DATA1><![CDATA["
	            row += GetAttribute(selRow, "DATA1");
	            row += "]]></DATA1>"
	            row += "<DATA2><![CDATA["
	            row += GetAttribute(selRow, "DATA2");
	            row += "]]></DATA2>"
	            row += "<DATA3><![CDATA["
	            row += GetAttribute(selRow, "DATA3");
	            row += "]]></DATA3>"
	            row += "<DATA4><![CDATA["
	            row += GetAttribute(selRow, "DATA4");
	            row += "]]></DATA4>"
	            row += "<DATA5><![CDATA["
	            row += GetAttribute(selRow, "DATA5");
	            row += "]]></DATA5>"
	            row += "<DATA6><![CDATA["
	            row += GetAttribute(selRow, "DATA6");
	            row += "]]></DATA6>"
	            row += "</CELL>"
	            row += "<CELL>";
	            row += "<VALUE><![CDATA[";
	            row += getNodeText(selRow.cells[4]);
	            row += "]]></VALUE>";
	            row += "</CELL>";
	            row += "<CELL>";
	            row += "<VALUE><![CDATA[";
	            row += getNodeText(selRow.cells[5]);
	            row += "]]></VALUE>";
	            row += "</CELL>";
	            row += "</ROW>";
	            var DeptAddIndex = selCabList.GetRowCount();
	            var tr = selCabList.GetSelectedRows();
	            var InitTr = selCabList.GetDataRows();
	            var MaxID = 0;
	            for (var j = 0  ; j < InitTr.length  ; j++) {
	                var curnum = Number(selCabList.GetSelectedRowID(j).substring(selCabList.GetSelectedRowID(j).lastIndexOf('_') + 1), selCabList.GetSelectedRowID(j).length);
	                if (MaxID < curnum)
	                    MaxID = curnum;
	            }
	            var rowXml = loadXMLString(row);
	            if (tr.length == 0) {
	                if (InitTr.length == 0) {
	                    var objTr = selCabList.AddRow(0);
	                    SetAttribute(objTr, "id", "DivDivCabinetList" + "_TR_" + eval(MaxID + 1));
	                    selCabList.AddDataRow(objTr, rowXml);
	                }
	                else {
	                    var objTr = selCabList.AddRow(DeptAddIndex - 1);
	                    SetAttribute(objTr, "id", "DivDivCabinetList" + "_TR_" + eval(MaxID + 1));
	                    selCabList.AddDataRow(objTr, rowXml);
	                }
	            }
	            else {
	                var objTr = selCabList.AddRow(DeptAddIndex - 1);
	                SetAttribute(objTr, "id", "DivDivCabinetList" + "_TR_" + eval(MaxID + 1));
	                selCabList.AddDataRow(objTr, rowXml);
	            }
	        }
	        function DelListRow(objListView) {
	            var selRow;
	            var count1, len;
	            var selRows;
	            var objList = new ListView();
	            objList.LoadFromID("DivDivCabinetList");
	            var selRows = objList.GetSelectedRows();
	            if (selRows.length > 0) {
	                len = selRows.length;
	                if (selRows) {
	                    if (typeof (selRows) != "undefined") {
	                        if (len > 0) {
	                            for (count1 = 0; count1 < len; count1++) {
	                                var selIdx = objList.GetSelectedRows()[len - count1 - 1].getAttribute("id");
	                                objList.DeleteRow(selIdx);
	                            }
	                        }
	                    }
	                }
	            }
	        }
	        function InitSelCabinetList() {
	            var oList, ListViewData, Headers, Header, HName, HWidth, Rows, node;
	            oList = createXmlDom();
	            ListViewData = createNodeInsert(oList, ListViewData, "LISTVIEWDATA");
	            Headers = createNodeAndAppandNode(oList, ListViewData, Headers, "HEADERS");
	            Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
	            createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t379'/>");
	        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "120");
	        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
	        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t572'/>");
	        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "50");
	        Header = createNodeAndAppandNode(oList, Headers, Header, "HEADER");
	        createNodeAndAppandNodeText(oList, Header, node, "NAME", "<spring:message code='ezApprovalG.t573'/>");
	        createNodeAndAppandNodeText(oList, Header, node, "WIDTH", "40");
	        Rows = createNodeAndAppandNode(oList, ListViewData, Rows, "ROWS");
	        var SelListView = new ListView();
	        SelListView.SetID("DivDivCabinetList");
	        SelListView.SetMulSelectable(false);
	        SelListView.SetRowOnDblClick("SelCabinetList_rowdblclick");
	        SelListView.SetRowOnClick("SelCabinetList_rowclick");
	        SelListView.DataSource(oList);
	        SelListView.DataBind("SelCabinetList");
	    }
	        
	    function cmdCancel_onclick() {
	        if (ReturnFunction != null) {
	        	if (regDocId != null && regDocId != undefined) {
		            parent.DivPopUpHidden();
		            window.close();
	        	} else {
		            ReturnFunction(rtnVal);
		            parent.DivPopUpHidden();
		            window.close();
	        	}
	        }
	        else {
	            rtnVal[0] = "FALSE";
	            window.close();
	        }
	    }
	    
	    function cmdConfirm_onclick() {
	        var List = new ListView();
	        List.LoadFromID("DivDivCabinetList");
	        var totalRows = List.GetDataRows();
	        if (totalRows.length > 0) {
	            rtnVal[0] = "TRUE";
	            rtnVal[1] = GetSelCabInfoXml();
	            
	            var xml = createXmlDom();
	            xml = loadXMLString(rtnVal[1]);
	            
	            var regCabinetId = getNodeText(SelectNodes(SelectNodes(xml, "CABINETINFO/CABINET")[0], "CABINETID")[0]);
	            var regTaskCode = getNodeText(SelectNodes(SelectNodes(xml, "CABINETINFO/CABINET")[0], "TASKCODE")[0]);
	            
	            if (g_InitFlag == "0") {
	                if (document.getElementById("chkTransfer").checked) {
	                    rtnVal[2] = "1";
	                }
	                else {
	                    rtnVal[2] = "0";
	                }
	            }
	            
	            //반송, 회송문서 대장등록시 철 변경
	            if (regDocId != null && regDocId != undefined && regDocId != "" && regCabinetId != null && regCabinetId != undefined && regCabinetId != "") {
		            	$.ajax({
	            		type : "POST",
			    		dataType : "text",
			    		async : false,
			    		url : "/ezApprovalG/setHesongBansongCabinetInfo.do",
			    		data : {
			    				docID  : regDocId,
			    				cabinetID : regCabinetId,
								taskCode : regTaskCode
			    				},
			    		success: function(xml) {
			    			if (hesongFlag == "Y") {
				    			ReturnFunction(regDocId, "Y");
			    			} else {
				    			ReturnFunction(regDocId, "");
			    			}
			    		},
			    		error : function(error) {
			    			alert("대장등록에 실패하였습니다.");
			    			window.close();
			    		}
	            	});
	            }
	         // 일괄접수, 일괄접수자전결일 경우에는 결재정보창 유지
                if (receiptFlag == '' || typeof receiptFlag == 'undefined') {
                	if (ReturnFunction != null && (regDocId == null || regDocId == undefined || regDocId == "")) {
    	                ReturnFunction(rtnVal);
    	                window.close();
    	            } else {
		                window.close();
    	            }
                } else if (receiptFlag == 'J') {
			    	showLoadingProgress();
                	ReturnFunction(rtnVal);
                	setTimeout(function() {
	                	var RtnVal = opener.receiptAll_btnSendDraft();
	                	hideLoadingProgress();
						var arrRtnVal = RtnVal.split("/");
	    		        
	     		        if (arrRtnVal[0] == "OK") {
	     		            pAlertContent = strLang933 + (Number(arrRtnVal[1])) + strLang934_1 + "<br/>";

	     		            if (arrRtnVal[2] != 0) {
		     		            pAlertContent += strLang935 + arrRtnVal[2] + strLang934_1;
							}
	     		            
	     		            if (arrRtnVal[3] != 0) {
	     		            	
	     		            	if (arrRtnVal[2] != 0) {
	     		            		pAlertContent += " / ";
	     		            	}
	     		                
	     		            	pAlertContent += strLang936 + arrRtnVal[3] + strLang934_1;
	     		            }

	     		            if (arrRtnVal[4] != 0) {
	     		            	
	     		            	if (arrRtnVal[2] != 0 || arrRtnVal[3] != 0) {
	     		            		pAlertContent += " / ";
	     		            	}
	     		                
	     		            	pAlertContent += strLang938 + arrRtnVal[4] + strLang934_1;
	     		            }
	     		            
	     		            if (receiptFlag == "R") {
	     			            pAlertContent += "<br/>" + strLangLGEAR01;
	     		            } else {
	     			            pAlertContent += "<br/>" + strLangLGEAR03;
	     		            }
	     		            
	     		        } else {
     			            pAlertContent = strLangLGEAR04;
	     		        }
	     		        
     		        	// 2023-08-22 조수빈 - 작업을 완료한 후에는 부서수신함을 리로딩
						if (window.opener && window.opener.pListTypeValue) {
							if (window.opener.pListTypeValue == "97") {
								window.opener.parent.frames[0].convMain('97', '');
							} else {
								window.opener.parent.frames[0].convMain('4', '');
							}
						}
	     		        OpenAlertUIDiv(pAlertContent, window.close);
	     		        
                	},0);
                }
	        }
	        else {
	            alert("<spring:message code='ezApprovalG.t1117'/>");
	        }
	    }
	
	    window.onbeforeunload = function () {
	        if (!CrossYN())
	            window.returnValue = rtnVal;
	    };
	    function GetSelCabInfoXml() {
	        var SelCabListview = new ListView();
	        SelCabListview.LoadFromID("DivDivCabinetList");
	        var totalRows = SelCabListview.GetDataRows();
	        var i;
	        var rtnXml = createXmlDom();
	        var Root, objItem, objData;
	        Root = createNodeInsert(rtnXml, Root, "CABINETINFO");
	        for (i = 0; i < totalRows.length; i++) {
	            objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "CABINET");
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETID", totalRows[i].getAttribute("DATA1"));
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETNAME", totalRows[i].cells[0].innerText);
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "RECTYPE", totalRows[i].getAttribute("DATA3"));
	            
	            try {
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETSN", totalRows[i].cells[1].innerText);
	            } catch (e) {
	            	OpenAlertUI("<spring:message code='ezApprovalG.t1081'/>");
	            	//임시로 다시 에러를 일으킴 2018-07-27 강민수92
		            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETSN", totalRows[i].cells[1].innerText);
	            }
	            
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "CABINETVOLNO", totalRows[i].cells[2].innerText);
	            createNodeAndAppandNodeText(rtnXml, objItem, objData, "TASKCODE", totalRows[i].getAttribute("DATA2"));
	        }
	        return getXmlString(rtnXml);
	    }
	    var createcabinet_cross_dialogArguments = new Array();
	    function btnCreateCab_onclick() {
	        var List = new ListView();
	        List.LoadFromID("DivTaskList");
	        var selnodes = List.GetSelectedRows();
	        if (selnodes.length > 0) {
	            var selnode = selnodes[0];
	            var para = new Array();
	            para[0] = GetAttribute(selnode, "DATA1");
	            para[1] = selnode.cells[1].innerHTML;
	            para[2] = GetAttribute(selnode, "DATA3");
	            para[3] = GetAttribute(selnode, "DATA2");
	            para[4] = GetAttribute(selnode, "DATA9");
	            para[5] = GetAttribute(selnode, "DATA10");
	            para[6] = GetAttribute(selnode, "DATA4");
	            para[7] = GetAttribute(selnode, "DATA5");
	            para[8] = GetAttribute(selnode, "DATA6");
	            para[9] = GetAttribute(selnode, "DATA7");
	            para[10] = GetAttribute(selnode, "DATA8");
	            para[11] = GetAttribute(selnode, "DATA11");
	            para[12] = GetAttribute(selnode, "DATA12");
	            var url = "/ezApprovalG/createCabinet.do";
	
	            createcabinet_cross_dialogArguments[0] = para;
	            createcabinet_cross_dialogArguments[1] = btnCreateCab_onclick_Complete;
	
	            if ("<c:out value='${userInfo.lang}'/>" == "2" || "<c:out value='${userInfo.lang}'/>" == "3") { 
	            	DivPopUpShow(440, 435, url);
	            } else { 
	            	DivPopUpShow(440, 435, url);
	            } 
	        }
	    }
	    function btnCreateCab_onclick_Complete(rtn) {
	        DivPopUpHidden();
	        if (rtn[0] == "TRUE") {
	            GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn[1], g_InitFlag, $('#selYear').val());
	        }
	    }
	    function btnNewVolume_onclick() {
	        var ListCab = new ListView();
	        ListCab.LoadFromID("DivCabinetList");
	        var selnodes = ListCab.GetSelectedRows();
	        if (selnodes.length > 0) {
	            var selnode = selnodes[0];
	            var rtn = NewVolume(trim(GetAttribute(selnode, "DATA1")), trim(GetAttribute(selnode, "DATA3")));
	            if (rtn != "FALSE") {
	                GetCabinetSimpleList(arr_userinfo[4], "", arrTask[0], rtn, g_InitFlag, $('#selYear').val());
	            }
	        }
	        else {
	            alert("<spring:message code='ezApprovalG.t99992'/>");
	        }
	    }
	    function CabinetSearch_Press(e) {
	        if (window.event) {
	            if (e.keyCode != 13)
	                return;
	        }
	        else {
	            if (e.which != 13)
	                return;
	        }
	        CabinetSearch_onclick();
	    }
	    function TaskList_rowdbclick() {
	    }
	    var searchcabinet_cross_dialogArguments = new Array();
	    function CabinetSearch_onclick() {
	        if (document.getElementById("Cabinetkeyword").value == "") {
	            alert("<spring:message code='ezApprovalG.t1160'/>");
	            document.getElementById("Cabinetkeyword").focus();
	            return;
	        }
	        var param = document.getElementById("Cabinetkeyword").value;
	
	        searchcabinet_cross_dialogArguments[0] = param;
	        searchcabinet_cross_dialogArguments[1] = CabinetSearch_onclick_Complete;
	
	        DivPopUpShow(980, 510, "/ezApprovalG/searchCabinet.do");
	    }
	        function CabinetSearch_onclick_Complete(rtn) {
	            DivPopUpHidden();
	        if (rtn[0] == "TRUE") {
	            var xmldom = createXmlDom();
	            xmldom = loadXMLString(rtn[1]);
	            var SelCabListView = new ListView();
	            SelCabListView.LoadFromID("DivDivCabinetList");
	            SelCabRows = SelCabListView.GetDataRows();
	            if (SelCabRows.length > 0) {
	                selRow = SelCabRows[0];
	                var totalRows = GetAttribute(selRow, "id");
	                SelCabListView.DeleteRow(totalRows);
	            }
	            var value = GetElementsByTagName(xmldom.documentElement, "VALUE");
	            var row = "<ROW>";
	            row += "<CELL>";
	            row += "<VALUE><![CDATA[";
	            row += getNodeText(value[0]);
	            row += "]]></VALUE>";
	            row += "<DATA1><![CDATA[";
	            row += SelectSingleNodeValueNew(xmldom, "ROW/CELL/DATA1");
	            row += "]]></DATA1>";
	            row += "<DATA2><![CDATA[";
	            row += SelectSingleNodeValueNew(xmldom, "ROW/CELL/DATA2");
	            row += "]]></DATA2>";
	            row += "<DATA3><![CDATA[";
	            row += SelectSingleNodeValueNew(xmldom, "ROW/CELL/DATA3");
	            row += "]]></DATA3>";
	            row += "</CELL>";
	            row += "<CELL>";
	            row += "<VALUE><![CDATA[";
	            row += getNodeText(value[1]);
	            row += "]]></VALUE>";
	            row += "</CELL>";
	            row += "<CELL>";
	            row += "<VALUE><![CDATA[";
	            row += getNodeText(value[2]);
	            row += "]]></VALUE>";
	            row += "</CELL>";
	            row += "</ROW>";
	            var rowXml = loadXMLString(row);
	            var tr = SelCabListView.AddRow(0);
	            SelCabListView.AddDataRow(tr, rowXml);
	        }
	    }
	    function trim(parm_str) {
	        return rtrim(ltrim(parm_str));
	    }
	    function ltrim(parm_str) {
	        str_temp = parm_str;
	        while (str_temp.length != 0) {
	            if (str_temp.substring(0, 1) == " ") {
	                str_temp = str_temp.substring(1, str_temp.length);
	            } else {
	                return str_temp;
	            }
	        }
	        return str_temp;
	    }
	    function rtrim(parm_str) {
	        str_temp = parm_str;
	        while (str_temp.length != 0) {
	            int_last_blnk_pos = str_temp.lastIndexOf(" ");
	            if ((str_temp.length - 1) == int_last_blnk_pos) {
	                str_temp = str_temp.substring(0, str_temp.length - 1);
	            } else {
	                return str_temp;
	            }
	        }
	        return str_temp;
	    }
	    
	    function btn_cancel() {
	    	window.close();
	    }
	    </script>
		<style>
	    	.mainlist tr th {border-top:0px}
	    </style>
	</head>
	<!-- <body class="popup" style="margin-left: 0px; margin-top: 0px"> -->
	<body class="popup">
		<div id="close">
            <ul>
                <li><span id="btn_CancelAprLineTempletName" name="btn_CancelAprLineTempletName" onclick="btn_cancel()"></span></li>
            </ul>
        </div>
		<%-- <h1 style="height: 30px;"><spring:message code='ezApprovalG.t711'/></h1> --%>
	    <div>
		    <h1 id="h1Title"><spring:message code='ezApprovalG.t711'/></h1>
	    </div>
	    <div id="close">
            <ul>
                <li><span onclick="return cmdCancel_onclick()"></span></li>
            </ul>
        </div>
        <%-- <div style="position: absolute;right: 10px;top: 320px;">
        	<h2 style="font-weight: normal;">
        		<span style="vertical-align: sub;"><spring:message code='ezApprovalG.t1090'/>&nbsp;:&nbsp;</span>
		        <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)" style="height: 22px;">
		        <a class="imgbtn imgbck" onclick="return CabinetSearch_onclick()" style="height: 21px;">
		        	<span style="line-height: 22px;"><spring:message code='ezApprovalG.t111'/></span>
		        </a>
        	</h2>
        </div> --%>
	    <table>
	    	<tr>
	    		<td style="padding-top: 3px;">
	    			<table style="width: 100%">
	    				<tr>
	    					<td>
	    						<h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1039'/></h2>
	    					</td>
	    					<td style="text-align: right;">
    							<select id="selYear" onchange="return TaskList_rowclick()"></select>
	    					</td>
	    				</tr>
	    			</table>
	                <table class="content" style="width: 100%;">
	                    <tr>
	                        <th><spring:message code='ezApprovalG.t592'/></th>
	                        <td style="width: 40%;">
	                            <select id="selTaskCategory" style="width: 100%;" onchange="return selTaskCategory_onchange()"></select>
	                        </td>
	                        <th><spring:message code='ezApprovalG.t593'/></th>
	                        <td style="width: 40%;">
	                            <select id="selTaskMCategory" style="width: 100%;" onchange="return selTaskMCategory_onchange()"></select>
	                        </td>
	                    </tr>
	                </table>
	                <div class="listview" style="border-top:0px;">
	                    <div id="TaskSCateList" style="border: 0; HEIGHT: 215px; WIDTH: 470px; overflow: auto;"></div>
	                </div>
	    		</td>
	    		<td>
	    		</td>
	    		<td style="padding-top: 3px;">
	    			<table style="width: 100%">
	    				<tr>
	    					<td>
	    						<h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1040'/></h2>
	    					</td>
	    					<td style="text-align: right;">
	    						<a class="imgbtn imgbck"><span onclick="return btnFindTask_onclick()"><spring:message code='ezApprovalG.t1041'/></span></a>
	    					</td>
	    				</tr>
	    			</table>
	                <table>
	                    <tr>
	                        <td>
	                            <div class="listview">
	                                <div id="TaskList" style="HEIGHT: 245px; WIDTH: 470px; overflow: auto;"></div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	    		</td>
	    	</tr>
	    	<tr>
	    		<td style="padding-top: 3px;">
	    			<table style="width: 100%">
	    				<tr>
	    					<td>
	    						<h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t711'/></h2>
	    					</td>
	    					<td style="text-align: right;">
	    						<c:if test="${initFlag == '1'}">
	    						<div id="trCreateCab" style="margin-left: 5px;">
	    							<a class="imgbtn imgbck"><span onclick="return btnCreateCab_onclick()"><spring:message code='ezApprovalG.t1118'/></span></a>
		                        	<a class="imgbtn imgbck" style="display : none;"><span onclick="return btnNewVolume_onclick()"><spring:message code='ezApprovalG.t894'/></span></a>
		    					</div>
		    					<div id="trCreateCabDummy" style="display: none"></div>
		    					</c:if>
	    					</td>
	    				</tr>
	    			</table>
	                <table>
	                    <tr>
	                        <td>
	                            <div class="listview">
	                            <c:if test="${initFlag == '1'}">
	                                <div id="CabinetList" style="border: 0; HEIGHT: 215px; WIDTH: 470px; overflow: auto;"></div>
	                            </c:if>
	                            <c:if test="${initFlag != '1'}">
	                            	<div id="CabinetList" style="border: 0; HEIGHT: 215px; WIDTH: 470px; overflow: auto;"></div>
	                            </c:if>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	    		</td>
	    		<td style="padding-top: 3px;">
	    			<div style="margin: 50px 10px 0px 10px;">
		    			<img id="RecvAdd" border="0" src="/images/arr_right.gif" width="16px" height="16px" onclick="return AddCabList_onclick()" style="cursor: pointer"><br>
		    			<img id="RecvDel" border="0" src="/images/arr_left.gif" width="16px" height="16px" onclick="return DelCabList_onclick()" style="cursor: pointer">
	    			</div>
	    		</td>
	    		<td style="padding-top: 3px;">
	    			<table style="width: 100%">
	    				<tr>
	    					<td>
				    			<h2 class="h2_dot" style="font-weight: normal;"><spring:message code='ezApprovalG.t1120'/></h2>
	    					</td>
	    					<td style="text-align: right;">
					        	<h2 style="font-weight: normal; margin-top: -5px;">
							        <input type="text" id="Cabinetkeyword" value="" onkeypress="CabinetSearch_Press(event)" style="height: 22px;">
							        <a class="imgbtn imgbck" onclick="return CabinetSearch_onclick()" style="height: 21px;">
							        	<span style="line-height: 22px;"><spring:message code='ezApprovalG.t111'/></span>
							        </a>
					        	</h2>
	    					</td>
	    				</tr>
	    			</table>
	                <table>
	                    <tr>
	                        <td colspan="2">
	                            <div class="listview">
	                                <div id="SelCabinetList" style="border: 0; HEIGHT: 215px; WIDTH: 470px; overflow: auto;"></div>
	                            </div>
	                        </td>
	                    </tr>
	                    <c:if test="${initFlag == '0'}">
		                    <tr style="display: none">
		                        <td>
	                            	<div class='custom_checkbox'><input type="checkbox" id="chkTransfer" name="chkTransfer" value="1"></div>
	                           		<spring:message code='ezApprovalG.t1121'/>
	                            </td>
		                    </tr>
	                    </c:if>
	                </table>
	    		</td>
	    	</tr>
	    </table>
	    <div class="btnposition btnpositionNew">
	        <h2 style="margin :-3px;">
	            <a class="imgbtn" style="vertical-align: middle;" onclick="return cmdConfirm_onclick()"><span><spring:message code='ezApprovalG.t20'/></span></a>
	        </h2>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<div style="width: 200px; height: 50px; border: 0px solid red; text-align: center; vertical-align: middle; display: none; z-index: 9000; position: absolute;" id="loadingLayer">
	        <img src="/images/email/progress_img.gif" style="vertical-align: middle;" />
	    </div>
	</body>
</html>
