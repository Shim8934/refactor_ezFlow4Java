<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title>
			<c:choose>
				<c:when test="${docState == '015'}">
					<spring:message code='ezApprovalG.t1214'/>
				</c:when>
				<c:otherwise>
					<spring:message code='ezApprovalG.t1215'/>
				</c:otherwise>
			</c:choose>
		</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript">
		    var pDocID = "${docID}";
		    var pDeptID = "${deptID}";
		    var pDocState = "${docState}";
		    var ChildDocInfo = "${childDocInfo}";
		    var xmlhttp = createXMLHttpRequest();	
		    var FLAG;
		    var pDocInfoValue = "1";
		    var tempDocID;
		    var tempGDocID;
		    var OrderCell = "";
		    window.onload = function () {
		        try {
		            var xmlpara = createXmlDom();
		            xmlpara = loadXMLString(ChildDocInfo);
		
		            tempDocID = getNodeText(SelectSingleNode(xmlpara.documentElement, "DOCID"));
		            FLAG = getNodeText(SelectSingleNode(xmlpara.documentElement, "FLAG"));
		            tempGDocID = getNodeText(SelectSingleNode(xmlpara.documentElement, "GDOCID"));
		
		            if (FLAG == "END") {
		                getEndLine(tempDocID);
		            }
		            else if (FLAG == "APR") {
		                getAprLine(tempDocID);
		            }
		            else {
		                getAprLine("");
		                return;
		            }
		            if (pDocState == "011") {
		                document.getElementById("tdGongRam").style.display = "";
		            }
		        }
		        catch (e) {
		            alert("window_onload : " + e.description);
		        }
		    };
		    function OpenAlertUI(pAlertContent) {
		        var parameter = pAlertContent;
		        var url = "/ezApprovalG/ezAprAlert.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        feature = feature + GetShowModalPosition(330, 205);
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		    }
		    function getAprLine(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : true,
		    		url : "/ezApprovalG/getLineList.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "APR"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getEndLine(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : true,
		    		url : "/ezApprovalG/getLineList.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "END"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getAprOpinion(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : true,
		    		url : "/ezApprovalG/getOpinionInfo.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "APR"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getEndOpinion(tempDocID) {
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : true,
		    		url : "/ezApprovalG/getOpinionInfo.do",
		    		data : {
		    				docID : tempDocID,
		    				mode  : "END"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		    function getAprovSub_after(xml) {
		        try {
		            if (xml == "") return;
		
		            document.getElementById("lvAprLine").innerHTML = "";
		
		            var listview = new ListView();                          
		            listview.SetID("AprLine");                              
		            listview.SetMulSelectable(false);                       
		            listview.SetRowOnDblClick("lvAprLine_DBSelChange");
		            listview.DataSource(xml);                            
		            listview.DataBind("lvAprLine");                        
		
		            var tr = listview.GetDataRows();
		
		            var cnt = tr.length;
		            var i, j;
		            var chkVal;
		            if (cnt > 0 && tr[0].id != "AprLine_TR_noItems") {
		                for (i = 0; i < cnt; i++) {
		                    tr[i].cells[2].setAttribute("title", tr[i].cells[2].innerHTML);
		                }
		            }
		        }
		        catch (e) {
		            alert(e.description);
		        }
		    }
		    function lvAprLine_DBSelChange() {
		        if (pDocInfoValue == "1" || pDocInfoValue == "5")
		            openUserInfo();
		    }
		    function openUserInfo() {
		        var listview = new ListView();
		        listview.LoadFromID("AprLine");
		
		        var tr = listview.GetSelectedRows();
		        if (tr.length != 0) {
		            var pCheckval = tr[0].getAttribute("DATA5");
		            if (pCheckval == "Y") {
		                window.open("/ezApprovalG/ezLineInfo.do?docID=" + tr[0].getAttribute("DATA3") + "&deptID=" + tr[0].getAttribute("DATA4") + "&docState=012", "", "height=270px,width=600px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(600, 270));
		            }
		            else {
		                window.open("/ezCommon/showPersonInfo.do?id=" + tr[0].getAttribute("DATA4"), "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + GetOpenPosition(420, 438));
		            }
		        }
		    }
		    var g_tagSelectsub = "1";
		    function MM_swapImagesub(nSel) {
		        if (nSel != g_tagSelectsub) {
		            g_tagSelectsub = nSel;
		            if (g_tagSelectsub == "1") {
		                if (pDocState == "015") {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub5.gif\"";
		                    eval(str);
		                }
		                else {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub1.gif\"";
		                    eval(str);
		                }
		
		                var str2 = "tagsub4.src" + "=" + "\"/images/tab_appsub4a.gif\"";
		                eval(str2);
		                var str3 = "tagsub5.src" + "=" + "\"/images/tab_appsub5a.gif\"";
		                eval(str3);
		            }
		            else if (g_tagSelectsub == "4") {
		                if (pDocState == "015") {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub5a.gif\"";
		                    eval(str);
		                }
		                else {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub1a.gif\"";
		                    eval(str);
		                }
		
		                var str2 = "tagsub4.src" + "=" + "\"/images/tab_appsub4.gif\"";
		                eval(str2);
		                var str3 = "tagsub5.src" + "=" + "\"/images/tab_appsub5a.gif\"";
		                eval(str3);
		            }
		            else {
		                if (pDocState == "015") {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub5a.gif\"";
		                    eval(str);
		                }
		                else {
		                    var str = "tagsub1.src" + "=" + "\"/images/tab_appsub1a.gif\"";
		                    eval(str);
		                }
		
		                var str2 = "tagsub4.src" + "=" + "\"/images/tab_appsub4a.gif\"";
		                eval(str2);
		                var str3 = "tagsub5.src" + "=" + "\"/images/tab_appsub5.gif\"";
		                eval(str3);
		            }
		        }
		    }
		    function Approval_onclick() {
		        if (FLAG == "END") {
		            getEndLine(tempDocID);
		        }
		        else if (FLAG == "APR") {
		            getAprLine(tempDocID);
		        }
		        else
		            getAprLine("");
		    }
		    function Opinion_onclick() {
		        if (FLAG == "END") {
		            getEndOpinion(tempDocID);
		        }
		        else if (FLAG == "APR") {
		            getAprOpinion(tempDocID);
		        }
		        else
		            getAprOpinion("");
		    }
		    function GongRamInfo_onClick() {
		        $.ajax({
		    		type : "POST",
		    		dataType : "xml",
		    		async : true,
		    		url : "/ezApprovalG/getLineList.do",
		    		data : {
		    				docID : tempGDocID,
		    				mode  : "APR"
		    				},
		    		success: function(xml){
		    			getAprovSub_after(xml);
		    		}        			
		    	});
		    }
		</script>
	</head>
	<body class="popup">
		<h1>
			<c:choose>
				<c:when test="${docState == '015'}">
					<spring:message code='ezApprovalG.t1214'/>
				</c:when>
				<c:otherwise>
					<spring:message code='ezApprovalG.t1215'/>
				</c:otherwise>
			</c:choose>
		</h1>
		<div id="close">
		  <ul>
		    <li><span onclick="window.close()"><spring:message code='ezApprovalG.t64'/></span></li>
		  </ul>
		</div>
		
		<div id="tabnav" style="width:576px">
		  <ul>
		  	<c:choose>
				<c:when test="${docState == '015'}">
				    <li id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()" ><spring:message code='ezApprovalG.t946'/></span></li>
				</c:when>
				<c:otherwise>
				    <li id="tagsub1"><span onclick="pDocInfoValue='1';MM_swapImagesub('1');Approval_onclick()" ><spring:message code='ezApprovalG.t1769'/></span></li>
				</c:otherwise>
			</c:choose>
		    <li id="tagsub4"><span onclick="pDocInfoValue='4';MM_swapImagesub('4');Opinion_onclick()" ><spring:message code='ezApprovalG.t55'/></span></li>
		    <li id="tdGongRam" style="display:none"><span id="tagsub5" onclick="pDocInfoValue='5';MM_swapImagesub('5');GongRamInfo_onClick()" ><spring:message code='ezApprovalG.t946'/></span></li>
		  </ul>
		</div>
		<div class="listview" style="overflow-x:auto;WIDTH:574px;"><div id="lvAprLine" style="HEIGHT:120px;WIDTH:572px;margin:1px 1px 1px 1px; "></div></div>
		<script type="text/javascript" >
			selToggleList(document.getElementById("tabnav"), "ul", "li", "1");
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
	</body>
</html>