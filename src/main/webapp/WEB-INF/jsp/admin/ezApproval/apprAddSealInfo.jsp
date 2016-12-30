<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML>
<html>
	<head>
	    <title><spring:message code='ezApproval.t352'/></title>
	    <style>
	        DIV.IMAGEVIEW {
	            behavior: url("SealView.htc");
	        }
	    </style>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApproval.e2'/>" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <c:if test="${!isCrossBrowser}">
		    <script type="text/javascript" src="/js/Kaoni_ActiveX.js"></script>
	    </c:if>
	    <script type="text/javascript">
	        var pSealName = "";
	        var pSealPath = "";
	        var pSealWidth = "";
	        var pSealHeight = "";
	        var pRegUserID = "";
	        var pRegUserName = "";
	        var ret = new Array("");
	        var CompanyID = "";
	        var RetValue;
	        var ReturnFunction;
	        window.onload = function () {
	            try {
	                try {
	                    RetValue = parent.AddSealInfo_dialogArguments[0];
	                    ReturnFunction = parent.AddSealInfo_dialogArguments[1];
	                } catch (e) {
	                    try {
	                        RetValue = opener.AddSealInfo_dialogArguments[0];
	                        ReturnFunction = opener.AddSealInfo_dialogArguments[1];
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	
	                pRegUserID = RetValue[0];
	                pRegUserName = RetValue[1];
	                CompanyID = RetValue[2];
	
	                if (CrossYN())
	                    setNodeText(document.getElementById("tbRegUser") , pRegUserName);
	                else
	                    setNodeText(tbRegUser,pRegUserName);
	
	                ret[0] = "cancel";
	                ret[1] = "";
	                ret[2] = pSealName;
	                ret[3] = pSealPath;
	                ret[4] = pSealWidth;
	                ret[5] = pSealHeight;
	                try {
	                    window.returnValue = ret;
	                } catch (e) { }
	
	            } catch (e) {
	                alert("window_onload : " + e.description);
	            }
	        }
	
	        function btnOK_onclick() {
	            pSealName = document.getElementById("tbSealName").value;
	            if (pSealName == "") {
	                var pInformationString = "<spring:message code='ezApproval.t353'/>";
	                OpenAlertUI(pInformationString);
	                return;
	            }
	
	            if (pSealPath == "") {
	                var pInformationString = "<spring:message code='ezApproval.t354'/>";
	                OpenAlertUI(pInformationString);
	                return;
	            }
	
	            pSealWidth = document.getElementById("tbSealWidth").value;
	            if (pSealWidth == "") {
	                var pInformationString = "<spring:message code='ezApproval.t355'/>";
	                OpenAlertUI(pInformationString);
	                return;
	            }
	
	            pSealHeight = document.getElementById("tbSealHeight").value;
	            if (pSealHeight == "") {
	                var pInformationString = "<spring:message code='ezApproval.t356'/>";
	                OpenAlertUI(pInformationString);
	                return;
	            }
	
	            ret[0] = "OK";
	            ret[1] = "";
	            ret[2] = pSealName;
	            ret[3] = pSealPath;
	            ret[4] = pSealWidth;
	            ret[5] = pSealHeight;
	
	            if (ReturnFunction != null)
	                ReturnFunction(ret);
	            else
	                window.returnValue = ret;
	
	            window.close();
	        }
	
	        function btnCancel_onclick() {
	            window.close();
	        }
	
	        function btnFileUp_onclick() {
	            document.form.file1.click();
	        }
	        function btnDisplay_onclick() {
	            pSealWidth = document.getElementById("tbSealWidth").value;
	            pSealHeight = document.getElementById("tbSealHeight").value;
	
	            if (pSealWidth == "" || pSealHeight == "" || pSealPath == "") {
	                var pInformationString = "<spring:message code='ezApproval.t359'/>";
	                OpenAlertUI(pInformationString);
	                return;
	            }
	
                document.getElementById("SIGNVIEW").innerHTML = "";
                var Img = document.createElement("IMG");
                Img.style.width = pSealWidth + "mm";
                Img.style.height = pSealHeight + "mm";
                Img.src = pSealPath;
                SIGNVIEW.appendChild(Img);
	        }
	
	        var ezapralert_cross_dialogArgument = new Array();
	        function OpenAlertUI(pAlertContent) {
	            var parameter = pAlertContent;
	            var url = "";
	            url = "/admin/ezApproval/ezAprAlert.do?type=OPEN";
	
	            if (CrossYN()) {
	                ezapralert_cross_dialogArgument[0] = parameter;
	                ezapralert_cross_dialogArgument[1] = "OPEN";
	                var OpenWin = GetOpenWindow(url, "", 330, 205, "NO");
	            } else {
	                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	                feature = feature + GetShowModalPosition(330, 205);
	                var RtnVal = window.showModalDialog(url, parameter, feature);
	            }
	        }
	
	        window.onunload = function () {
	            if ((ret[0] == "cancel") && (pSealPath != "")) {
	                var xmlhttp = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "pSealNum");
	                createNodeAndInsertText(xmlpara, objNode, "pSealNum", pSealPath.replace("/${userInfo.tenantId}/files/upload_approval/sealImg/", ""));
	
	                xmlhttp.open("POST", "aspx/SealDelete.aspx", false);
	                xmlhttp.send(xmlpara);
	            }
	        }
	
	        function btn_AttachAdd_onclick(obj) {
	            if (document.form.file1.value != "") {
	                var frm = document.getElementById('form');
	                frm.action = "/admin/ezApproval/sealImageUpload.do?mode=SEND&companyID=" + CompanyID;
	                frm.submit();
	            }
	        }
	
	        function returnvalue(strXML) {
	            var xml = loadXMLString(strXML);
	            var nodes = SelectNodes(xml, "ROOT/NODES/NODE");
	            if (getNodeText(GetChildNodes(nodes[0])[1]) == "true") {
	                var fileinfo = document.getElementById("file1").value.substring(document.getElementById("file1").value.lastIndexOf("\\") + 1, document.getElementById("file1").value.length);
	                document.getElementById("filename").value = fileinfo;
	                fileName = getNodeText(GetChildNodes(nodes[0])[4]);
	            }
	            pSealPath = "/${userInfo.tenantId}/files/upload_approval/sealImg/" + fileName;
	        }
	        
	        function showKeyCode(event) {
				event = event || window.event;
				var keyID = (event.which) ? event.which : event.keyCode;
				//숫자패드 모두, 방향키, 백슬러쉬, 딜리트만 포함
				if( ( keyID >=48 && keyID <= 57 ) || ( keyID >=96 && keyID <= 105 ) || ( keyID >=37 && keyID <= 40 ) || keyID == 46 || keyID == 8) {
					return;
				} else {
					return false;
				}
			}
	    </script>
	</head>
	<body class="popup">
	    <div id="menu">
	        <ul>
	            <li><span onclick="return btnOK_onclick()"><spring:message code='ezApproval.t360'/></span></li>
	        </ul>
	    </div>
	    <div id="close">
	        <ul>
	            <li><span onclick="window.close()"><spring:message code='ezApproval.t70'/></span></li>
	        </ul>
	    </div>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	        selToggleList(document.getElementById("close"), "ul", "li", "0");
	    </script>
	
	    <table width="420" class="content">
	        <tr>
	            <th><spring:message code='ezApproval.t361'/></th>
	            <td id="SealName">
	                <input type="text" name="tbSealName" id="tbSealName" style="width: 110px">
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t00010'/></th>
	            <td style="vertical-align:middle;">
	                <input type="text" readonly id="filename" style="width:180px;">
	                <a class="imgbtn"><span onclick="btnFileUp_onclick()"><spring:message code='ezApproval.t362'/></span></a>
	                <a class="imgbtn"><span onclick="btnDisplay_onclick()"><spring:message code='ezApproval.t350'/></span></a>
	            </td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t363'/></th>
	            <td id="SealSize">
	                <input type="text" name="tbSealWidth" id="tbSealWidth" style="width: 40px" onkeydown="return showKeyCode(event)" maxlength="3">mm&nbsp;*
	        		<input type="text" name="tbSealHeight" id="tbSealHeight" style="width: 40px" onkeydown="return showKeyCode(event)" maxlength="3">
	                mm  &nbsp;&nbsp;&nbsp;&nbsp;(0 ~ 999)&nbsp;mm</td>
	        </tr>
	        <tr>
	            <th><spring:message code='ezApproval.t364'/></th>
	            <td id="tbRegUser">&nbsp;</td>
	        </tr>
	        <tr>
	            <td id="SIGNVIEW" colspan="2" style="text-align:center; padding-top:5px; padding-bottom:5px;"></td>
	        </tr>
	    </table>  
		<iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form style="display: none;" method="post" id="form" name="form" enctype="multipart/form-data" action="/admin/ezApproval/sealImageUpload.do" target="ifrm">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" accept="image/*">
			<input type="hidden" name="mode" id="mode" />
		</form>
	</body>
	<c:if test="${!isCrossBrowser}">
	    <script type="text/javascript">EzHTTPTrans_ActiveX("EzHTTPTrans");</script>
	</c:if>
</html>