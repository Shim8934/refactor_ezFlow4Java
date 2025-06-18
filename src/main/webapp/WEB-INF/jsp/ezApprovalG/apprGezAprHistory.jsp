<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t373'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/escapenew.js')}"></script>
		<script type="text/javascript" ID="clientEventHandlersJS">
		    var pDocID = "<c:out value ='${docID}'/>";
		    var OrderCell = "";
		    var orgCompanyID = parent.orgCompanyID;
		    var ext = "<c:out value ='${ext}'/>";
		    var selSpan = "";
		    
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
		        selSpan = "orgSpan3";
		    };
		    function lvDocList_DBSelChange() {
		        var Arguments = new Array();
		        var listview = new ListView();
		        listview.LoadFromID("lvDocList");
		        var oArrRows = listview.GetSelectedRows();
		        pUrl = oArrRows[0].getAttribute("DATA2");
		        Arguments[0] = oArrRows[0].getAttribute("DATA2");
		        var fileExt = getOriginalFileExtension(pUrl.toLowerCase());
		        
		        if (fileExt == "doc") {
		            pUrl = "DocViewerWord.aspx?DocHref=" + escapenew(Arguments[0]);
		        }
		        else if (fileExt == "hwp") {
		        	/* 2023-02-08 홍승비 - WHWP 결재문서 편집모드 적용 후 수정이력 비교화면 구현, 기존 코드 분기처리 */
		        	// hwp사용안함 (docViewerHWP.do > 내부적으로 WHWP 문서보기 팝업으로 연결됨)
		            if (CrossYN()) {
		            	var beforeDocUrl = oArrRows[0].getAttribute("BEFOREDOCURL");
		            	if (beforeDocUrl != null && beforeDocUrl != "") {
		                	pUrl = "/ezApprovalG/docViewerWHWPCompare.do?docHrefAfter=" + encodeURI(Arguments[0]) + "&docHrefBefore=" + encodeURI(beforeDocUrl);
		                	openwindow2(pUrl);
		                	return;
		            	} else {
		            		pUrl = "/ezApprovalG/docViewerHWP.do?docHref=" + encodeURI(Arguments[0]);
		            	}
		            }
		            else {
		                pUrl = "/ezApprovalG/docViewerHWP.do?docHref=" + encodeURI(Arguments[0]);
		            }
		        }
		        else {
		        	/* 2020-02-25 홍승비 - 결재문서 수정이력 비교화면 구현, 개선작업 이전의 기존 수정이력화면 분기처리 */
		            if (CrossYN()) {
		            	var beforeDocUrl = oArrRows[0].getAttribute("BEFOREDOCURL");
		            	if (beforeDocUrl != null && beforeDocUrl != "") {
		                	pUrl = "/ezApprovalG/docViewerCompare.do?docHrefAfter=" + encodeURI(Arguments[0]) + "&docHrefBefore=" + encodeURI(beforeDocUrl);
		                	openwindow2(pUrl);
		                	return;
		            	} else {
		                	pUrl = "/ezApprovalG/docViewerCK.do?docHref=" + encodeURI(Arguments[0]);
		            	}
		            }
		            else {
		                pUrl = "DocViewer.aspx?DocHref=" + escapenew(Arguments[0]);
		            }
		        }
		        openwindow(pUrl, "", 800, 550);
		    }
		    
		    function getOriginalFileExtension(filePath) {
		    	var pathLength = filePath.length;
		    	var lastIndexOfDot = filePath.lastIndexOf(".");

		    	if (lastIndexOfDot < 0) {
		    		return "";
		    	}

		    	var ext = trim_Cross(filePath.substr(lastIndexOfDot + 1, filePath.length).toLowerCase());

		    	if (ext === "ezd") {
		    		return getOriginalFileExtension(filePath.substr(0, lastIndexOfDot));
		    	}

		    	return ext;
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
		            // window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
					showPopup(wfileLocation, width, heigth, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left, hidePopup);
		        } catch (e) {
		            alert("openwindow :: " + e.description);
		        }
		    }
		    /* 2020-02-25 홍승비 - 수정화면 비교용 팝업창 열기 함수 추가 (전체 화면 크기에 가깝게 열림) */
		    function openwindow2(wfileLocation) {
		        try {
		            var heigth = window.screen.availHeight;
		            var width = window.screen.availWidth;
		            var left = 0;
		            var top = 0;
	                var pleftpos;
	                
	                heigth = parseInt(heigth) - 70;
	                width = parseInt(width) - 20;
	                
		            // window.open(wfileLocation, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left);
					showPopup(wfileLocation, width, heigth, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left, hidePopup);
		        } catch (e) {
		            alert("openwindow :: " + e.description);
		        }
		    }
		    
		    function lvAttachList_DBSelChange() {
		        var listview = new ListView();
		        listview.LoadFromID("lvAttachList");

		        var oSelRow = listview.GetSelectedRows();
		        if (oSelRow.length > 0) {
		        	var pFileModifyFlag = oSelRow[0].getAttribute("DATA7");	//001(ADD), 002(DELETE), 003(MODIFY), 004(ADD_CONTENT)
		        	if (pFileModifyFlag == strModifyFlag2) {
			            OpenAlertUI(strLang167);
			            return;
		        	} else {
		        		var oRows = listview.GetDataRows();
		        		for (var i = 0; i < oRows.length; i++) {
		        			if (oRows[i].getAttribute("DATA9") == oSelRow[0].getAttribute("DATA9") && oRows[i].getAttribute("DATA7") == strModifyFlag2) {
					            OpenAlertUI(strLang167);
					            return;
		        			}
		        		}
		        		
			        	var pFileName = oSelRow[0].getAttribute("DATA3");
			        	var pFilePath = oSelRow[0].getAttribute("DATA4");
			        	var href = "/ezApprovalG/downloadAttach.do?fileName=" + encodeURIComponent(pFileName) + "&filePath=" + encodeURIComponent(pFilePath);
			        	
			        	document.getElementById("filedown").src = href;
		        	}
		        }
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
		    			docID : pDocID,
		    			orgCompanyID : orgCompanyID
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
		    			docID : pDocID,
		    			orgCompanyID : orgCompanyID
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
		    			docID : pDocID,
		    			orgCompanyID : orgCompanyID
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
		    			changeSN : pChangeSN,
		    			orgCompanyID : orgCompanyID
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
		            	selSpan = "orgSpan1";
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
		            	selSpan = "orgSpan2";
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
		            	selSpan = "orgSpan3";
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
		                // window.open("/ezApprovalG/ezLineInfo.do?docID=" + tempDocID + "&deptID=" + tempUserDeptID + "&docState=012", "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1155, 460));
						showPopup("/ezApprovalG/ezLineInfo.do?docID=" + tempDocID + "&deptID=" + tempUserDeptID + "&docState=012", 1155, 460, "", "height=460px,width=1155px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(1155, 460), hidePopup);
		            } else {
		                // window.open("/ezCommon/showPersonInfo.do?id=" + tempUserID, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1");
						showPopup("/ezCommon/showPersonInfo.do?id=" + tempUserID, width, height, "", "height=" + height + ",width=" + width + ", left=" + leftPosition + ",top=" + topPosition + ",screenX=" + leftPosition + ",screenY=" + topPosition + ", status = no, toolbar=no, menubar=no,location=no, resizable=1", hidePopup);
		            }
		        }
		        else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t374'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		
		    function close_Click() {
		        if (CrossYN() && ext != "ezd") {
		            parent.DivPopUpHidden();
		        } else {
		            window.close();
		        }
		    }
		    
		    /* 2018-09-04 홍승비 - 탭메뉴 마우스오버 시 하이라이트 설정 */
	        function tabover(tabObj) {
	        	tabObj.setAttribute("class", "tabon");
	        }
	        function tabout(tabObj) {
	        	if (tabObj.id != selSpan) {
	        		tabObj.setAttribute("class", "");
	        	}
	        }
	        
	        /*
	         * Layer Alert
	         * parameter : String, function
	         */
	        var ezapralert_cross_dialogArguments = new Array();
	        function OpenAlertUI(pAlertContent, CompleteFunction) {
	            var parameter = pAlertContent;
	            var url = "/ezApprovalG/ezAprAlert.do";

	            if (CrossYN()) {
	                ezapralert_cross_dialogArguments[0] = parameter;
	                if (CompleteFunction != undefined)
	                    ezapralert_cross_dialogArguments[1] = CompleteFunction;
	                else
	                    ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
	                DivPopUpShow(330, 205, url);
	            }
	            else {
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                feature = feature + GetShowModalPosition(330, 205);
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	            }
	        }
	        /*
	         * Layer Alert Complete
	         */
	        function OpenAlertUI_Complete() {
	            DivPopUpHidden();
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
       			<p id="orgTabButton3"><span id="orgSpan3" onclick="BtnChange('3')" class="tabon" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezApprovalG.t375'/></span></p>
       			<p id="orgTabButton2"><span id="orgSpan2" onclick="BtnChange('2')" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezApprovalG.t376'/></span></p>
       			<p id="orgTabButton1"><span id="orgSpan1" onclick="BtnChange('1')" onmouseover="tabover(this)" onmouseout="tabout(this)"><spring:message code='ezApprovalG.t377'/></span></p>
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
			  	<div class="listview" style="margin-top:5px;width:718px;">
			  		<div id=divAprLineInfo style="border:0; width:716px; Height:165px;margin:1px 1px 1px 1px; overflow:auto;"></div>
			  	</div>
			</td>
		  </tr>
		</table>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
		<iframe id="filedown" style="display:none"></iframe>
	</body>
</html>
