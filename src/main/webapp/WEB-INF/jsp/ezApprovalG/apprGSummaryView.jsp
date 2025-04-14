<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/apprGSummary.js')}"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
            var pDocID = "<c:out value='${summary.docID}'/>";
            var orgCompanyID = "<c:out value='${summary.companyID}'/>";
            var summaryPath = "<c:out value='${summary.summaryPath}'/>";
            
            window.onload = function () {
                try {
                    var summaryContentHtml = ConvertMHTtoHTML(summaryPath);
                    var tempXML = loadXMLString(summaryContentHtml);
                    var XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                    var htmlData = getNodeText(XmlBodyDATA);
                    document.querySelector('#txtContent').innerHTML = replaceEntityCodeToStr(htmlData);
                } catch (e) {
                    console.log(e);
                    document.querySelector('#txtContent').innerHTML = "<p>" + strLangJIH_Summary04 + "</p>";
                }
            };
            
            function btn_SummaryCancel_onclick() {
                parent.DivPopUpHidden();
            }
        </script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t1203'/></h1>
	    <div id="close">
            <ul>
                <li><span class="icon16 popup_icon16_print summaryPrintBtn" onclick="return btnSummaryPrint_onclick()"></span></li>
                <li><span onclick="return btn_SummaryCancel_onclick()"></span></li>
            </ul>
        </div>
        <div id="txtContent" style="padding:0; height:495px; overflow:auto; border:1px solid #ddd;"></div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>