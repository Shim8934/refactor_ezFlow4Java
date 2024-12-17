<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t9997'/></title>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
		    var cnt = "<c:out value ='${cnt}'/>";
		    var arr_userinfo = new Array();
		    arr_userinfo[0] = "user"; 							
		    arr_userinfo[1] = "<c:out value ='${userInfo.id}'/>";              
		    arr_userinfo[2] = "<c:out value ='${userInfo.displayName}'/>";         
		    arr_userinfo[3] = "<c:out value ='${userInfo.title}'/>";               
		    arr_userinfo[4] = "<c:out value ='${userInfo.deptID}'/>";              
		    arr_userinfo[5] = "<c:out value ='${userInfo.deptName}'/>";            
		    arr_userinfo[6] = "<c:out value ='${userInfo.jikChek}'/>";                         
		    arr_userinfo[7] = "N";
		    arr_userinfo[8] = "<c:out value ='${userInfo.email}'/>";               
		    arr_userinfo[9] = "";
		    arr_userinfo[10] = "";
		    var pCompanyID = "<c:out value ='${userInfo.companyID}'/>";
		    var ezchkpasswd_all_cross_dialogArguments = new Array();
		    function chk_Passwd(pPwd) {
		        var parameter = pPwd;
		
		        ezchkpasswd_all_cross_dialogArguments[0] = parameter;
		        ezchkpasswd_all_cross_dialogArguments[1] = chk_Passwd_Complete;
		
		        DivPopUpShow(330, 215, "/ezApprovalG/ezchkPasswdall.do");
		    }
		    function chk_Passwd_Complete(chkpass) {
		        if (chkpass == "FALSE") {
		            var pAlertContent = strLang581;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		        else if (chkpass == "cancel") {
		            var pAlertContent = strLang582;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		
		        setpause(500);
		        var pMode = "";
	      	    
		        var xmlpara = createXmlDom();
		        var objRoot, objNode, doc, objNode2, objNodes, objDocinfoNode;
		        objRoot = createNodeInsert(xmlpara, objRoot, "PARAMETER");
		        createNodeAndInsertText(xmlpara, objNode, "USERID", arr_userinfo[1]);
		        createNodeAndInsertText(xmlpara, objNode, "DISPLAYNAME", arr_userinfo[2]);
		        createNodeAndInsertText(xmlpara, objNode, "TITLE", arr_userinfo[3]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTID", arr_userinfo[4]);
		        createNodeAndInsertText(xmlpara, objNode, "DEPTNAME", arr_userinfo[5]);
		        createNodeAndInsertText(xmlpara, objNode, "JIKCHEK", arr_userinfo[6]);
		        createNodeAndInsertText(xmlpara, objNode, "COMPANYID", pCompanyID);
		        createNodeAndInsertText(xmlpara, objNode, "PASSWD", "");
		        createNodeAndInsertText(xmlpara, objNode, "LANGTYPE", "${userInfo.lang}");
		        var list = createNodeAndAppandNode(xmlpara, objRoot, list, "DOCIDS");
		        var orgCompanyID = "";
		        if (parseInt(cnt) > 1) {
		            for (var i = 0; i < parseInt(cnt) ; i++) {
		            	// 체크된 값의 정보만 xmlpara에 생성
		                if (eval(document.frm.chk[i]).checked) {
					        orgCompanyID = $(document.frm.chk[i]).attr("orgCompanyID");
		                    doc = createNodeAndAppandNode(xmlpara, list, doc, "DOC");
		                    $.ajax({
		    	      			type : "POST",
		    	      			dataType : "text",
		    	      			async : false,
		    	      			url : "/ezApprovalG/getLineMode.do",
		    	      			data : {
		    	      					docID : document.frm.chk[i].value.split("|")[0],
		    	      					orgCompanyID : orgCompanyID
		    	      					},
		    	      			success: function(xml){
		    	      				pMode = xml;
		    	      			}        			
		    	      		});
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCID", document.frm.chk[i].value.split("|")[0]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGAPRUSERID", document.frm.chk[i].value.split("|")[1]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FORMID", document.frm.chk[i].value.split("|")[2]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TYPE", document.frm.chk[i].value.split("|")[3]);
		                    createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCSTATE", document.frm.chk[i].value.split("|")[4]);
			                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "orgCompanyID", orgCompanyID);
			                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "APRMEMBERSN", document.frm.chk[i].value.split("|")[5]);
		        			createNodeAndInsertText(xmlpara, objNode, "MODE", pMode);
		                }
		            }
		        }
		        else {
		        	// 리스트의 값이 하나인 경우
		            if (eval(document.frm.chk).checked) {
		            	orgCompanyID = $(document.frm.chk).attr("orgCompanyID");
		            	$.ajax({
	    	      			type : "POST",
	    	      			dataType : "text",
	    	      			async : false,
	    	      			url : "/ezApprovalG/getLineMode.do",
	    	      			data : {
	    	      					docID : document.frm.chk.value.split("|")[0],
	    	      					orgCompanyID : orgCompanyID
	    	      					},
	    	      			success: function(xml){
	    	      				pMode = xml;
	    	      			}        			
	    	      		});
		                doc = createNodeAndAppandNode(xmlpara, list, doc, "DOC");
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCID", document.frm.chk.value.split("|")[0]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "ORGAPRUSERID", document.frm.chk.value.split("|")[1]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "FORMID", document.frm.chk.value.split("|")[2]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "TYPE", document.frm.chk.value.split("|")[3]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "DOCSTATE", document.frm.chk.value.split("|")[4]);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "orgCompanyID", orgCompanyID);
		                createNodeAndAppandNodeText(xmlpara, doc, objDocinfoNode, "APRMEMBERSN", document.frm.chk.value.split("|")[5]);
		        		createNodeAndInsertText(xmlpara, objNode, "MODE", pMode);
		            }
		        }
		        xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", "/ezApprovalG/doApprovAllG.do", false);
		        xmlhttp.send(xmlpara);
		        var RtnVal = xmlhttp.responseText;
		        var arrRtnVal = new Array();
		        arrRtnVal[0] = RtnVal.split("/")[0]; // OK or ERR
		        arrRtnVal[1] = RtnVal.split("/")[1]; // totalCount
		        arrRtnVal[2] = RtnVal.split("/")[2]; // trueCount
		        arrRtnVal[3] = RtnVal.split("/")[3]; // falseCount
		        if (arrRtnVal[0] == "OK") {
		            hideProgress();
		            pAlertContent = strLang933 + arrRtnVal[1] + strLang934;
		            pAlertContent += strLang935 + arrRtnVal[2] + strLang934;
		            if (arrRtnVal[3] != 0) {
		                pAlertContent += strLang936 + arrRtnVal[3] + strLang934;
		            }
		            pAlertContent += strLang931;
		            OpenAlertUI(pAlertContent, OpenAlertUI_Close);
		        } else {
		            hideProgress();
		            pAlertContent = strLang932;
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function OpenAlertUI_Close() {
		        btnClose_onclick();
		    }
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
		
		    function OpenAlertUI_Complete() {
		        DivPopUpHidden();
		    }
		    function checkAll(obj) {
		        if (document.getElementById(obj).checked) {
		            if (parseInt(cnt) > 1) {
		                for (var i = 0; i < parseInt(cnt) ; i++) {
		                    eval(document.frm.chk[i]).checked = true;
		                }
		            }
		            else if (parseInt(cnt) == 1) {
		                eval(document.frm.chk).checked = true;
		            }
		        }
		        else {
		            if (parseInt(cnt) > 1) {
		                for (var i = 0; i < parseInt(cnt) ; i++) {
		                    eval(document.frm.chk[i]).checked = false;
		                }
		            }
		            else if (parseInt(cnt) == 1) {
		                eval(document.frm.chk).checked = false;
		            }
		        }
		
		    }
		    function btnApprove_onclick() {
		    	// '일괄결재 대상 리스트'가 없는 경우
		        if (parseInt(cnt) == 0) {
		            var pAlertContent = strLang937;
		            OpenAlertUI(pAlertContent);
		            return;
		        }
		    	// '일괄결재 대상 리스트'가 있는 경우
		        else if (parseInt(cnt) > 1) {
		            var j = 0;
		            for (var i = 0; i < parseInt(cnt) ; i++) {
		                if (eval(document.frm.chk[i]).checked) {
		                    j++;
		                }
		            }
		            if (j == 0) { // 리스트에서 체크된 값이 없는 경우
		                var pAlertContent = strLang930;
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        else {
		            if (!document.frm.chk.checked) {
		                var pAlertContent = strLang930;
		                OpenAlertUI(pAlertContent);
		                return;
		            }
		        }
		        //if ("${approvalPWD}" != "N") {
		        if (CheckUsePassword()) {
		            chk_Passwd(arr_userinfo[1]);
		            return;
		        }
		        else {
		            chk_Passwd_Complete("TRUE");
		        }
		    }
		    function btnClose_onclick() {
		        window.close();
		    }
		    var g_progresswin = null;
		    function showProgress() {
		    }
		    function hideProgress() {
		        try {
		            if (g_progresswin)
		                g_progresswin.close();
		        }
		        catch (e) { }
		    }
		    function setpause(numberMillis) {
		        var now = new Date();
		        var exitTime = now.getTime() + numberMillis;
		        while (true) {
		            now = new Date();
		            if (now.getTime() > exitTime)
		                return;
		        }
		    }
		    window.onbeforeunload = function () {
		        try {
		            parent.ALLapproval_afterCall();
		        }
		        catch (e) {
		            opener.ALLapproval_afterCall();
		        }
		    }
		    
		    /* 2019-01-02 천성준 #14647
		            결재암호 사용유무 조회 (Y / N)
		    */
		    function CheckUsePassword() {
		    	var result = "";
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getApprovalPWD.do",
		    		success: function(text) {
		    			result = text;
		    		}        			
		    	});
		    	
		    	if (result != "N") {
		    		return true;
		    	} else {
		    		return false;
		    	}
		    }
		</script>
	</head>
	<body class="popup">
		<form name="frm">
		    <h1><spring:message code='ezApprovalG.t9997'/></h1>
		    <table >
		        <tr>
		            <td >                
		                <div id="close">
		                    <ul>
		                        <li id="btnClose" ><span onClick="return btnClose_onclick()"></span></li>
		                    </ul>
		                </div>
		            </td>
		        </tr>
		        <tr>
		        <c:if test="${approvalFlag == 'G'}"> 
		            <td style="height:20px;vertical-align:middle;">▒ <b><spring:message code='ezApprovalG.t26'/></b>,<spring:message code='ezApprovalG.t9998'/></td>
		        </c:if>
		        <c:if test="${approvalFlag == 'S'}">
		        	<td style="height:20px;vertical-align:middle;">▒ <spring:message code='ezApprovalG.t9998'/></td>
		        </c:if>
		        </tr>
		        <tr>
		            <td  style="text-align:center;">
		                <div style="overflow-y:auto;width:680px;HEIGHT:350px;">
		                    <table class="mainlist" >
		                        <tr >
		                            <th style="padding:0;text-align:center;width:20px;"><input type="checkbox" id="mainChk" onclick="checkAll(this.id)" /></th>
		                            <c:choose>
		                            	<c:when test="${viewCompany eq '1'}">
				                            <th style="width:280px;"><spring:message code='ezApprovalG.t106'/></th>  <%-- 제목 --%>
				                            <th style="width:100px;"><spring:message code='ezApprovalG.t1145'/></th> <%-- 회사 --%>
				                            <th style="width:100px;"><spring:message code='ezApprovalG.t1331'/></th> <%-- 기안부서 --%>
				                            <th style="width:80px;"><spring:message code='ezApprovalG.t445'/></th>   <%-- 기안자 --%>
				                            <th style="width:140px;"><spring:message code='ezApprovalG.t9996'/></th> <%-- 기안일시 --%>
		                            	</c:when>
		                            	<c:otherwise>
				                            <th style="width:290px;"><spring:message code='ezApprovalG.t106'/></th>  <%-- 제목 --%>
				                            <th style="width:110px;"><spring:message code='ezApprovalG.t1331'/></th> <%-- 기안부서 --%>
				                            <th style="width:80px;"><spring:message code='ezApprovalG.t445'/></th>   <%-- 기안자 --%>
				                            <th style="width:140px;"><spring:message code='ezApprovalG.t9996'/></th> <%-- 기안일시 --%>
		                            	</c:otherwise>
		                            </c:choose>
		                        </tr>
		                        ${sbStr}
		                    </table>
		                </div>
		            </td>
		        </tr>
		    </table>
		    <div class="btnpositionNew">
		        <a class="imgbtn"><span onclick="return btnApprove_onclick('003')" ><spring:message code='ezApprovalG.t1'/>/<spring:message code='ezApprovalG.t1760'/></span></a>
		    </div>
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
		</form>
	</body>
</html>