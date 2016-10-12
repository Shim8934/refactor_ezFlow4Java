<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t373'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/escapenew.js"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var pDocID = "${docID}";
		    var OrderCell = "";
		    var NonActiveX = "YES";
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
		        var pUrl;
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
		                pUrl = "DocViewerHWP_Cross.aspx?DocHref=" + escapenew(Arguments[0]);
		            }
		            else {
		                pUrl = "DocViewerHWP.aspx?DocHref=" + escapenew(Arguments[0]);
		            }
		        }
		        else {
		            if (CrossYN()) {
		                pUrl = "DocViewer_CK.aspx?DocHref=" + escapenew(Arguments[0]);
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
		        href = "/myoffice/Common/downloadattach.aspx?filename=" + escapenew(listview.GetSelectedRows()[0].getAttribute("DATA3")) + "&filepath=" + escapenew(listview.GetSelectedRows()[0].getAttribute("DATA4")).replace(rep, "&#39;");
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
		                window.open("/ezApprovalG/ezLineInfo.do?docID=" + tempDocID + "&deptID=" + tempUserDeptID + "&docState=012", "", "height=270px,width=600px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(600, 270));
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
		        if (CrossYN()) {
		            parent.DivPopUpHidden();
		        }
		        else {
		            window.close();
		        }
		    }
		</script>
	</head>
	<body class="popup" style="overflow:hidden;">
		<h1><spring:message code='ezApprovalG.t373'/></h1>
		<div id="close"><ul><li id="Table1" ><span onClick="close_Click()"><spring:message code='ezApprovalG.t64'/></span></li></ul></div>
		 
		<div id="tabnav" style="width:700px;margin-top:-10px;" >
		  <ul>
		    <li id="orgTabButton3"><span onClick="BtnChange('3')" ><spring:message code='ezApprovalG.t375'/></span></li>
		    <li id="orgTabButton2"><span onClick="BtnChange('2')" ><spring:message code='ezApprovalG.t376'/></span></li>
		    <li id="orgTabButton1"><span onClick="BtnChange('1')" ><spring:message code='ezApprovalG.t377'/></span></li>
		  </ul>
		</div>
		<table> 
		   <tr id="HisDoc"> 
		    <td><div class="listview" style="overflow:auto;">
		      <div ID="divlvDocList" style="border:0; width:700px; Height:335px;margin:1px 1px 1px 1px;"></div>
		      </div>
		    </td>
		  </tr>
		  <tr  id="HisAttach" > 
		    <td><div class="listview" style="overflow:auto;">
		      <div ID="divlvAttachList" style="border:0; width:700px; Height:335px;margin:1px 1px 1px 1px;"></div>
		      </div>
		    </td>
		  </tr>
		  <tr id="HisLine"> 
		    <td><div class="listview" style="overflow:auto;"> 
		      <div id=divAprLine style="border:0; width:700px; Height:165px;margin:1px 1px 1px 1px;"></div>
		      </div>
			  <div class="listview" style="margin-top:5px;overflow:auto;" >
			  <div id=divAprLineInfo style="border:0; width:700px; Height:165px;margin:1px 1px 1px 1px;"></div>
			  </div>
			</td>
		  </tr>
		</table>
		    <iframe id="filedown" style="display:none"></iframe>
		<script type="text/javascript" >
			selToggleList(document.getElementById("close"), "ul", "li", "0");
			selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
		</script>
	</body>
</html>