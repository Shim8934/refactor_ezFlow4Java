<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t373'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('ezApprovalG.e2', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var pDocID = "${docID}";
		    var OrderCell = "";
		    var ext = "${ext}";
		    window.onload = function () {
		        var rtnVal = new Array();
		        getDocHistory();
		        getLineHistory();
		        getLineHistoryInfo("0");
		        getAttachHistory();
		        rtnVal[0] = "cancel";
		        HisLine.style.display = "";
		        HisDoc.style.display = "none";
		        HisAttach.style.display = "none";
		        window.returnValue = rtnVal;
		    };
		    function lvDocList_DBSelChange() {
		        var Arguments = new Array();
		        var listview = new ListView();
		        listview.LoadFromID("lvDocList");
		        var oArrRows = listview.GetSelectedRows();
		        pUrl = oArrRows[0].getAttribute("DATA2");
		        Arguments[0] = oArrRows[0].getAttribute("DATA2");
		        if (pUrl.substr(pUrl.length - 3, pUrl.length).toLowerCase() == "doc") {
		            pUrl = "DocViewerWord.aspx?DocHref=" + escapenew(Arguments[0]);
		        }
		        else if (pUrl.substr(pUrl.length - 3, pUrl.length).toLowerCase() == "hwp") {
		        	//hwp사용안함
		            if (CrossYN()) {
// 		                pUrl = "DocViewerHWP_Cross.aspx?DocHref=" + escapenew(Arguments[0]);
		            	pUrl = "/ezApprovalG/docViewerHWP.do?docHref=" + encodeURI(Arguments[0]);
		            }
		            else {
		                pUrl = "/ezApprovalG/docViewerHWP.do?docHref=" + encodeURI(Arguments[0]);
		            }
		        }
		        else {
		            if (CrossYN()) {
		                pUrl = "/ezApprovalG/docViewerCK.do?docHref=" + encodeURI(Arguments[0]);
		            }
		            else {
		                pUrl = "DocViewer.aspx?DocHref=" + escapenew(Arguments[0]);
		            }
		        }
		        openwindow(pUrl, "", 800, 550);
		    }
		    function openwindow(wfileLocation, wName, wWeigth, wHeigth) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = 0;
		            var top = 0;
		            if (window.screen.width > 800) {
		                var pleftpos;
		
		                pleftpos = parseInt(width) - 1150;
		                heigth = parseInt(heigth) - 70;
		                width = parseInt(width) - pleftpos;
		
		                left = pleftpos / 2;
		            }
		            else {
		                heigth = parseInt(heigth) - 70;
		                width = parseInt(width) - 10;
		            }
		            window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
		
		        } catch (e) {
		            alert("openwindow :: " + e.description);
		        }
		    }
		    function lvAttachList_DBSelChange() {
		        var listview = new ListView();
		        listview.LoadFromID("lvAttachList");
		        var href = listview.GetSelectedRows()[0].getAttribute("DATA1");
		        var rep = /'/g;
		        href = "/ezApprovalG/downloadAttach.do?fileName=" + encodeURI(listview.GetSelectedRows()[0].getAttribute("DATA3")) + "&filePath=" + encodeURI(listview.GetSelectedRows()[0].getAttribute("DATA4"));
		        document.getElementById("filedown").src = href;
		    }
		    function btnrecovery_onclick() {
		        var rtnVal = new Array();
		        rtnVal[0] = lvDocList.GetSelectedRows()[0].getAttribute("DATA2");
		        window.returnValue = rtnVal;
		        window.close();
		    }
		    function btn_OpinionOK_onclick() {
		        var rtnVal = new Array();
		        rtnVal[0] = "cancel";
		        window.returnValue = rtnVal;
		        window.close();
		    }
		    function getDocHistory() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getDocHistory.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		    	
		        var listview = new ListView();
		        listview.SetID("lvDocList");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("lvDocList_DBSelChange");
		        listview.DataSource(result);
		        listview.DataBind("divlvDocList");
		    }
		    function getLineHistory() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getLineHistory.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		    	
		        var listview = new ListView();
		        listview.SetID("AprLine");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnClick("AprLineonSelChange_onclick");
		        listview.SetSelectFlag(false);
		        listview.DataSource(result);
		        listview.DataBind("divAprLine");
		        
		    }
		    function getAttachHistory() {
		    	var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getAttachHistory.do",
		    		data : {
		    			docID : pDocID
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		    	
		        var listview = new ListView();
		        listview.SetID("lvAttachList");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("lvAttachList_DBSelChange");
		        listview.SetSelectFlag(false);
		        listview.DataSource(result);
		        listview.DataBind("divlvAttachList");
		    }
		    function getLineHistoryInfo(pChangeSN) {
				var result = "";
				
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getLineHistoryDetail.do",
		    		data : {
		    			docID : pDocID,
		    			changeSN : pChangeSN
		    		},
		    		success: function(xml){
		    			result = loadXMLString(xml);
		    		}        			
		    	});
		    	
		        document.getElementById("divAprLineInfo").innerHTML = "";
		        var listview = new ListView();
		        listview.SetID("AprLineInfo");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("AprLineInfo_DBSelChange");
		        listview.SetSelectFlag(false);
		        listview.DataSource(result);
		        listview.DataBind("divAprLineInfo");
		    }
		    function AprLineonSelChange_onclick() {
		        var listview = new ListView();
		        listview.LoadFromID("AprLine");
		        if (listview.GetSelectedRows().length > 0) {
		            var pAttachSN = listview.GetSelectedRows()[0].getAttribute("DATA2");
		            getLineHistoryInfo(pAttachSN);
		        }
		    }
		    function BtnChange(TabButton) {
		        switch (TabButton) {
		            case "1":
		                HisDoc.style.display = "";
		                HisAttach.style.display = "none";
		                HisLine.style.display = "none";
		                orgTabButton1.src = "/images/tab_h01.gif";
		                orgTabButton2.src = "/images/tab_h02o.gif";
		                orgTabButton3.src = "/images/tab_h03o.gif";
		                orgTabButton1.height = "23";
		                orgTabButton2.height = "23";
		                orgTabButton3.height = "23";
		                document.getElementById("orgTabButton1").children[0].className = "tabon";
		                document.getElementById("orgTabButton2").children[0].className = "";
		                document.getElementById("orgTabButton3").children[0].className = "";
		                break;
		            case "2":
		                HisDoc.style.display = "none";
		                HisAttach.style.display = "";
		                HisLine.style.display = "none";
		                orgTabButton1.src = "/images/tab_h01o.gif";
		                orgTabButton2.src = "/images/tab_h02.gif";
		                orgTabButton3.src = "/images/tab_h03o.gif";
		                orgTabButton1.height = "23";
		                orgTabButton2.height = "23";
		                orgTabButton3.height = "23";
		                document.getElementById("orgTabButton1").children[0].className = "";
		                document.getElementById("orgTabButton2").children[0].className = "tabon";
		                document.getElementById("orgTabButton3").children[0].className = "";
		                break;
		            case "3":
		                HisDoc.style.display = "none";
		                HisAttach.style.display = "none";
		                HisLine.style.display = "";
		                orgTabButton1.src = "/images/tab_h01o.gif";
		                orgTabButton2.src = "/images/tab_h02o.gif";
		                orgTabButton3.src = "/images/tab_h03.gif";
		                orgTabButton1.height = "23";
		                orgTabButton2.height = "23";
		                orgTabButton3.height = "23";
		                document.getElementById("orgTabButton1").children[0].className = "";
		                document.getElementById("orgTabButton2").children[0].className = "";
		                document.getElementById("orgTabButton3").children[0].className = "tabon";
		                break;
		        }
		    }
		    function AprLineInfo_DBSelChange() {
		        var listview = new ListView();
		        listview.SetID("AprLineInfo");
		        var tr = listview.GetSelectedRows();
		        if (tr.length != 0) {
		            var tempDocID = GetAttribute(tr[0], "DATA1");
		            var tempUserID = GetAttribute(tr[0], "DATA3");
		            var tempUserDeptID = GetAttribute(tr[0], "DATA4");
		
		            var width = 420, height = 450;
		            var leftPosition, topPosition;
		            leftPosition = (window.screen.width / 2) - ((width / 2) + 10);
		            topPosition = (window.screen.height / 2) - ((height / 2) + 50);
		
		            if (tempUserID == tempUserDeptID) {
		                window.open("/ezApprovalG/ezLineInfo.do?docID=" + tempDocID + "&deptID=" + tempUserDeptID + "&docState=012", "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1155, 460));
		            } else {
		                window.open("/ezCommon/showPersonInfo.do?id=" + tempUserID, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
		            }
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t374'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    function close_Click() {
		        if (CrossYN() && ext != "hwp" && ext != "ezd") {
		            parent.DivPopUpHidden();
		        } else {
		            window.close();
		        }
		    }
		</script>
		<style>
			.mainlist tr th {border-top:0px}
		</style>
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1><spring:message code='ezApprovalG.t373'/></h1>
		<div id="close"><ul><li id="Table1" ><span onClick="close_Click()"></span></li></ul></div>
		<div class="portlet_tabpart01" style="margin:0px;">
       		<div class="portlet_tabpart01_top" id="tab1" style="border-bottom:0px;">
       			<p id="orgTabButton3"><span onclick="BtnChange('3')" class="tabon"><spring:message code='ezApprovalG.t375'/></span></p>
       			<p id="orgTabButton2"><span onclick="BtnChange('2')"><spring:message code='ezApprovalG.t376'/></span></p>
       			<p id="orgTabButton1"><span onclick="BtnChange('1')"><spring:message code='ezApprovalG.t377'/></span></p>
       		</div>
       	</div>
		<table> 
		   <tr id="HisDoc"> 
		    <td>
		    	<div class="listview" style="overflow-y:auto;overflow-x:hidden">
		      		<div ID="divlvDocList" style="border:0; width:716px; Height:330px;margin:1px 1px 1px 1px;"></div>
		      	</div>
		    </td>
		  </tr>
		  <tr  id="HisAttach" > 
		    <td>
		    	<div class="listview" style="overflow-y:auto;overflow-x:hidden">
		      		<div ID="divlvAttachList" style="border:0; width:716px; Height:330px;margin:1px 1px 1px 1px;"></div>
		      	</div>
		    </td>
		  </tr>
		  <tr id="HisLine"> 
		    <td>
		    	<div class="listview" style="overflow-x:hidden;width:718px;">
		      		<div id=divAprLine style="border:0; width:716px; Height:165px;margin:1px 1px 1px 1px;"></div>
		      	</div>
			  	<div class="listview" style="margin-top:5px;overflow-y:auto;overflow-x:hidden;width:718px;">
			  		<div id=divAprLineInfo style="border:0; width:716px; Height:165px;margin:1px 1px 1px 1px;"></div>
			  	</div>
			</td>
		  </tr>
		</table>
		<iframe id="filedown" style="display:none"></iframe>
	</body>
</html>
