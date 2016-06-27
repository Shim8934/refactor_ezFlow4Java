<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<link rel="stylesheet" href="<spring:message code="ezResource.e2" />" type="text/css" />
		<script type="text/javascript" src="<spring:message code='ezResource.e1'/>"></script>
		<script type="text/javascript" src="/js/ezResource/datepicker.htc_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/composeappt_cross.js"></script>
		<script type="text/javascript" src="/js/ezResource/Schedule_cross.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" >
		 	var g_data = new Array();
		 	//writerID trim
	        var writerIDVal = '${writerID}';
	        var org_ownerNM = "${ownerNm}";
	        var org_deptNM = "${deptNm}";
	        var org_num = '${num}';
	        var org_ownerID = "${ownerID}";
	        var ss_companyID = '${userInfo.companyID}';
	        var org_companyID = ss_companyID;
	        var pAdminFg = "${adminFg}";
	        var s_userID = '${userInfo.id}';
	        var org_brdName = "${brdName}";
	        var iReFlag = "${reFlagVal}";
	        var pUse_Editor = "${useEditor}";
	        var pUse_IE11Browser = "${useIE11Browser}";
	        var typeVal = '${typeVal}';
	        var startDateVal = '${startDateVal}';
	        var endDateVal = '${endDateVal}';
	        var sDT = "${startDateTime}";
	        var eDT = "${endDateTime}";
	        var ApproveFlag = "${approveFlag}";
	        var SavedApproveFlag = "${saveApproveFlag}";
	        var reFlagVal = '${reFlag}';
	        var server_name = "${serverName}";
	        var pnumVal = '${pNum}';
	        var gFlagVal = '${gresFlag}';
	        var g_fromStr = '${fromStr}';
	        var allDayFlag = "${allDay}";
	        var ItemArray = new Array();
	        var sDT2 = "${startDateTime2}";
	        var eDT2 = "${endDateTime2}";
	        var pNoneActiveX = "${pNoneActiveX}";
	        
	        window.onload = function () {
	            document.getElementById("displayNM").innerHTML = "<a href=# onClick=MemberInfo_onClick('" + writerIDVal + "')>" + org_ownerNM + "</a> (" + org_deptNM + ")";

	            if ("${brdName}" != "" && "${resID}" != "") {
	                ItemArray[0] = Array("${resID}");
	                ItemArray[1] = Array("${brdName}");
	                //brdNm에 trim
	                //document.getElementById('itemList').innerHTML = encodeURIComponent("${brdName}");
	                document.getElementById('itemList').innerHTML = "${brdName}";
	            }
	            var xmlHttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "NUM", org_num);
	            createNodeAndInsertText(xmlpara, objNode, "OWNERID", org_ownerID);
	            createNodeAndInsertText(xmlpara, objNode, "GROUPID", "");
	            createNodeAndInsertText(xmlpara, objNode, "companyID", org_companyID);
	            if (reFlagVal == "1") {
	                if (org_num != "" && org_ownerID != "") {
	                    xmlHttp.open("POST", "/ezResource/scheduleRepetitionProc.do?cmd=get", false);
	                    xmlHttp.send(xmlpara);

	                    resultXML = xmlHttp.responseXML;
	                    if (resultXML.xml != "") {
	                        g_data["recurrence"] = getXmlString(resultXML);
	                    }
	                }
	                show_repetition_info2();
	            }
	            else {
	                document.getElementById("AllDayDisplay").innerHTML = sDT.substring(0, sDT.lastIndexOf(":")) + " ~ " + eDT.substring(0, eDT.lastIndexOf(":"));
	            }
	            
	            document.getElementById("divCross").innerHTML = sigBody.innerHTML
	            var Bodytd = document.getElementById("divCross").getElementsByTagName("TD");
	            for (var i = 0; i < Bodytd.length; i++) {
	                if (Bodytd[i].width != "") {
	                    Bodytd[i].style.width = Bodytd[i].width + "px";
	                }
	                if (Bodytd[i].height != "") {
	                    Bodytd[i].style.height = Bodytd[i].height + "px";
	                }
	            }
	        }

	    function show_repetition_info2() {
	        var repeatinfo = "" + strLang122 + "";
	        xmlinDoc = createXmlDom();
	        xmlinDoc.async = false;
	        xmlinDoc = loadXMLString(g_data["recurrence"]);
	        szType = getNodeText(SelectNodes(xmlinDoc, "recurrence/frequency")[0]);

	        switch (szType) {
	            case "4":
	                repeatinfo += "" + strLang123 + "";
	                break;
	            case "5":
	                repeatinfo += "" + strLang124 + "";
	                break;
	            case "6":
	                repeatinfo += "" + strLang97 + "";
	                break;
	            case "7":
	                repeatinfo += "" + strLang98 + "";
	                break;
	        }
	        repeatinfo += ", " + strLang125 + "";

	        if (allDayFlag != "1") {
	            var reStartDate = getNodeText(SelectNodes(xmlinDoc, "recurrence/startDateTime")[0]);
	            var reEndDate = getNodeText(SelectNodes(xmlinDoc, "recurrence/endDateTime")[0]);
	            var reStartHour = reStartDate.split(" ")[1].split(":")[0];
	            var reEndHour = reEndDate.split(" ")[1].split(":")[0];

	            var reStartMinute = reStartDate.split(" ")[1].split(":")[1];
	            var reEndMinute = reEndDate.split(" ")[1].split(":")[1];

	            if (Number(reStartHour) < 12) {
	                repeatinfo += "" + strLang246 + " ";

	                if (Number(reStartHour) == 0)
	                    reStartHour = 12;
	            }
	            else {
	                repeatinfo += "" + strLang247 + " ";

	                if (Number(reStartHour) > 12)
	                    reStartHour = Number(reStartHour) - 12;
	            }

	            repeatinfo += reStartHour + ":" + reStartMinute + "" + " ~ " + "";

	            if (Number(reEndHour) < 12) {
	                repeatinfo += "" + strLang246 + " ";

	                if (Number(reEndHour) == 0)
	                    reEndHour = 12;
	            }
	            else {
	                repeatinfo += "" + strLang247 + " ";

	                if (Number(reEndHour) > 12)
	                    reEndHour = Number(reEndHour) - 12;
	            }

	            repeatinfo += reEndHour + ":" + reEndMinute;
	        }
	        else
	            repeatinfo += strLang126;

	        document.getElementById("AllDayDisplay").innerHTML = repeatinfo;
	    }

	        function btn_modify() {
	            if (CrossYN() || pNoneActiveX == "YES") {
	                filename = "/ezResource/scheduleAdd.do";
	            }
	            else {
	                if (pUse_Editor == "" || pUse_Editor == "CK") {
	                    filename = "/ezResource/scheduleAdd.do";
	                }
	                else {
	                    filename = "/ezResource/scheduleAdd.do";
	                }
	            }

	            window.location.href = filename + "?cmd=mod&from=schedule&" + "num=" + org_num + "&ownerID=" + org_ownerID + "&type=" + typeVal + "&startDate=" + startDateVal + "&endDate=" + endDateVal + "&brdName=" + org_brdName;
	        }

	        function window_onUnload() {
	            if (window.dialogArguments == undefined) {
	                if (window.opener != null && g_fromStr == "schedule" && trim(s_userID) != "") {
	                    window.opener.btnRefresh_onclick();
	                }
	                else if (window.opener != null && g_fromStr == "schedule2" && trim(s_userID) != "") {
	                    window.opener.parent.main.document.location.reload();
	                }
	                else if (window.opener != null && g_fromStr == "frame" && trim(s_userID) != "") {
	                    window.opener.document.all.iframeWin2.document.location.reload();
	                }
	                else if (window.opener != null && g_fromStr == "frame2" && trim(s_userID) != "") {
	                    window.opener.document.all.iframeWin.document.location.reload();
	                }
	                else if (window.opener != null && g_fromStr == "todaySchedule" && trim(s_userID) != "") {
	                    window.opener.location.reload();
	                }
	            }
	        }
	        function print_onClick2(printTrueFalse) {
	            g_printTrueFalse = printTrueFalse;
	            
	            document.getElementById("printDocument").innerHTML = sigBody.innerHTML;
	            
	            onbeforeprint2();

	            var feature = GetOpenPosition(700, 700);
	            printWindow = window.open("", "mywindow", "width=700, height=700,location=0,status=0,scrollbars=1,resizable=1" + feature);
	            var strContent = "<html><head>";
	            strContent = strContent + "<title>Print Preview</title>";
	            strContent = strContent + "<link rel=\"stylesheet\" href=\"/css/Default_kr.css\" type=\"text/css\" />";
	            strContent = strContent + "</head><body  style='overflow:hidden;height:100px;'onload='window.print();window.close();' >";
	            strContent = strContent + "<div style='width:100%;text-align:right; margin-bottom:5px;'>";
	            strContent = strContent + "</div>";
	            strContent = strContent + "<div style='width:100%;margin-left:5px;'><table style='height:100px;' id='printScreen' class=\"layout\" width='100%' border='0' cellspacing='0' cellpadding='10'>";
	            strContent = strContent + document.getElementById("printScreen").innerHTML;
	            strContent = strContent + "</table></div>";
	            strContent = strContent + "</body>";
	            printWindow.document.write(strContent);
	            printWindow.document.close();
	            printWindow.focus();
	        }

	        function onbeforeprint2() {
	            document.getElementById("printOwner").textContent = document.getElementById("displayNM").textContent;
	            document.getElementById("printImportance").textContent = document.getElementById("importanceDIV").textContent
	            document.getElementById("printDate").textContent = document.getElementById("AllDayDisplay").textContent;
	            document.getElementById("printTitle").textContent = document.getElementById("titleDIV").textContent;
	        }

	        function SetApproval_onClick2(pCmd, pFlag) {
	            var msg = ""
	            if (pFlag == "1") {
	                msg = "" + strLang176 + "";
	            } else {
	                msg = "" + strLang177 + "";
	            }

	            var result = confirm(msg);
	            if (result) {
	                if (bDupCheck == true && pFlag == "1") {
	                    var STime = "";
	                    var ETime = "";

	                    var AllDayCheck;
	                    if (allDayFlag == "1") {
	                        STime = startDateVal + " 00:00:01";
	                        ETime = endDateVal + " 23:59:59";
	                        AllDayCheck = true;
	                    } else {
	                        AllDayCheck = false;
	                    }

	                    var bUsingResource = isUsingResource(ownerID.value, "${checkSDT}", "${checkEDT}", ss_companyID, num.value, pCmd, AllDayCheck);
	                    if (bUsingResource) {
	                        alert("" + strLang141 + "");
	                        return;
	                    }
	                }
	                
	                var xmlHTTP = createXMLHttpRequest();
	                var xmlDOM = createXmlDom();
	                var objNode;

	                createNodeInsert(xmlDOM, objNode, "DATA");
	                createNodeAndInsertText(xmlDOM, objNode, "COMPANYID", ss_companyID);
	                createNodeAndInsertText(xmlDOM, objNode, "RESID", document.getElementById("ownerID").value);
	                createNodeAndInsertText(xmlDOM, objNode, "NUM", document.getElementById("num").value);
	                createNodeAndInsertText(xmlDOM, objNode, "APPROVE", pFlag);

	                xmlHTTP.open("POST", "/ezResource/updateApprovalFlag.do", false);
	                xmlHTTP.send(xmlDOM);

	                var rtnValue = xmlHTTP.responseText;


	                xmlHTTP = null;

	                if (rtnValue == "True") {
	                    xmlHTTP = createXMLHttpRequest();
	                    xmlHTTP.open("POST", "/ezResource/sendmailToUser.do", false);
	                    xmlHTTP.send(xmlDOM);
	                    var ResponseXML = xmlHTTP.responseXML;
	                    xmlHTTP = createXMLHttpRequest();
	                    xmlHTTP.open("POST", "/ezEmail/remote/mailSendNoti.do", false);
	                    xmlHTTP.send(ResponseXML);
	                    xmlHTTP = null;
	                    alert("" + strLang33 + "");
	                } else {
	                    alert("" + strLang178 + "");
	                }

	                xmlDOM = null;
	                
	                if (window.opener != null) {
	                    window.opener.btnRefresh_onclick();
	                }
	                window.close();
	            }
	        }

	        function MemberInfo_onClick(pSelUserID) {
	            var c_Width = 420;
	            var c_Height = 438;

	            //스크린의 크기
	            var s_Width = screen.availWidth;
	            var s_Height = screen.availHeight;

	            //열 창의 포지션
	            var px = (s_Width - c_Width) / 2;
	            var py = (s_Height - c_Height) / 2;

	            if (pSelUserID != "") {
	                window.open("/ezCommon/showPersonInfo.do?id=" + pSelUserID, "", "left=" + px + ",top=" + py + ",height=" + c_Height + "px,width=" + c_Width + "px, status = no, toolbar=no, menubar=no,location=no, resizable=1");
	            }
	        }  
		</script>
	</head>
	<%-- <% 
    string strDspMod_1 = "";
    string strDspMod_2 = "";

    if (pnum == "" && gresFlag != "0")
    {
        strDspMod_1 = "";
        strDspMod_2 = "style='display:none'";
    }
    else
    {
        strDspMod_1 = "";
        strDspMod_2 = "style='display:none'";
    }
	%>
 --%>
 	<xmp id="sigBody" style="display: none;">${content}</xmp>
	<body id="mainbodytag" class="popup" style="height: 98%;">
    	<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	    <table id="normalScreen" class="layout">
    	    <tr>
        	    <td style="height: 20px">
            	    <div id="menu">
                	    <ul>
                        	<c:if test="${adminFg eq 'Y' || writerID eq userID}">
                        		<li id="btn_modify"><span onclick="btn_modify()"><spring:message code="ezResource.t54" /></span></li>
                        	</c:if>
	                        <li><span onclick="print_onClick2( false )"><spring:message code="ezResource.t186" /></span></li>
	                        <c:if test="${adminFg eq 'Y' || writerID eq userID}">
                        		<li id="deletebtbn"><span onclick="delSchedule_onClick('${num}','${ownerID}')"><spring:message code="ezResource.t65" /></span></li>
                        	</c:if>
							
							<c:if test = "${typeVal ne 'Readonly'}">
									<%-- cmdStr에 lowCase --%>
								<c:if test="${approveFlag eq '1' && adminFg eq 'Y' && cmdStr eq 'mod'}">
									<c:choose>
										<c:when test="${savedApproveFlag eq '1'}">
                                  			<li><span  onClick="SetApproval_onClick2('${cmdStr}', 0)"> <spring:message code='ezResource.t190' /></span></li>
										</c:when>
										<c:otherwise>
                                  			<li><span  onClick="SetApproval_onClick2('${cmdStr}', 1)"> <spring:message code='ezResource.t191' /></span></li>
										</c:otherwise>
									</c:choose>
								</c:if>
							</c:if>	                            
                    	</ul>
                	</div>
                	<div id="close">
	                    <ul>
    	                    <li><span onclick="window.close();"><spring:message code='ezResource.t150' /></span></li>
        	            </ul>
            	    </div>
					<table class="content" style="width: 100%">
	                    <tr>
    	                    <th><spring:message code='ezResource.t193' /></th>
        	                <td colspan="3" style="width: 100%">
            	                <div id="displayNM"></div>
                	        </td>
                    	</tr>
                    	<tr>
	                        <th><spring:message code='ezResource.t197' /></th>
    	                    <td colspan="3"><span id="AllDayDisplay"></span></td>
                    	</tr>
            		</td>
        		</tr>
        		<tr>
            		<th><spring:message code='ezResource.t213' /></th>
            		<td colspan="3" style="width: 100%">
                		<div id="importanceDIV">
                			<c:choose>
                				<c:when test="${importance eq '1'}">
                					<spring:message code='ezResource.t214' />;  
								</c:when>
                				<c:when test="${importance eq '2'}">
                					<spring:message code='ezResource.t215' />
                				</c:when>
                				<c:otherwise>
                					<spring:message code='ezResource.t216' />
                				</c:otherwise>
                			</c:choose>
                		</div>
            		</td>
        		</tr>
        		<tr>
            		<th><spring:message code='ezResource.t374' /></th>
            		<td colspan="7" id="itemList" style="padding-left: 4px;"></td>
        		</tr>
        		<tr>
            		<th><spring:message code='ezResource.t224' /></th>
            		<td colspan="3">
                		<div id="titleDIV"> ${title}</div>
            		</td>
        		</tr>
        			<tr style="height:100%">
            			<td colspan="4" style="height:100%;">
                 			<div id="divCross" style="height:460px;overflow:auto;margin:5px 0px 0px 5px;"></div>
            			</td>
        			</tr>
				</table>
    			<input type="hidden" id="iReFlag" value="${reFlagVal}" />
    			<input type="hidden" id="tmpReFlag" value="${tmpReFlag}" />
    			<input type="hidden" id="gresFlag" value="${gresFlag}" />
    			<input type="hidden" id="num" value="${num}" />
    			<input type="hidden" id="pnum" value="${pNum}" />
    			<input type="hidden" id="ownerID" value="${ownerID}" />
    			<input type="hidden" id="writerID" value="${writerID}" />
    
				<table id="printScreen" style="display: none; width:100%; border:0px; padding:10px;" class="layout">
  					<tr style="text-align:center">
    					<td style="vertical-align:top">
    						<table style="width:690px;border:0px; padding:1px; border-collapse:collapse; border-spacing:0px; " class="content2">
      							<tr style="height:25px"> 
        							<th style="padding-left:10px" width="80">"<spring:message code='ezResource.t193' />";</th> 
        							<td style="padding-left:10px"> <div id="printOwner" style="text-align:left;"></div></td> 
      							</tr> 
      							<tr style="height:25px"> 
        							<th style="padding-left:10px">"<spring:message code='ezResource.t213' />";</th> 
        							<td style="padding-left:10px"> <div id="printImportance" style="text-align:left;"></div></td> 
      							</tr> 
      							<tr style="height:25px"> 
        							<th style="padding-left:10px">"<spring:message code='ezResource.t197' />";</th> 
        							<td style="padding-left:10px"> <div id="printDate" style="text-align:left;"></div></td> 
      							</tr> 
      							<tr style="height:25px"> 
        							<th style="padding-left:10px">"<spring:message code='ezResource.t224' />";</th> 
        							<td style="padding-left:10px"> <div id="printTitle" style="text-align:left;"></div></td> 
      							</tr> 
      							<tr> 
        							<td colspan="2"> <div align="left" id="printDocument" style="PADDING-RIGHT: 5px; PADDING-LEFT: 5px; PADDING-BOTTOM: 5px; WIDTH: 100%; PADDING-TOP: 5px;"></div></td> 
      							</tr> 
   							</table>
   						</td>
  					</tr>
				</table>
	</body>
</html>