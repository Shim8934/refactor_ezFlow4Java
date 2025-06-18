<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.pjj03'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script id="clientEventHandlersJS" type="text/javascript">
            var docID = "<c:out value='${summary.docID}'/>";
            var docName = "<c:out value='${docName}'/>";
            var summaryPath = "<c:out value='${summary.summaryPath}'/>";
	        
	        /* 2020-07-01 홍승비 - 문서기안 및 보기 시 div_Content 하위 테이블에 word-break속성이 공통적으로 존재하므로, 인쇄 시에도 해당 스타일을 적용함 */
	        window.onload = function () {
	            try {
	                // docName 변환, 삽입
                    var DNtempXML = loadXMLString(replaceEntityCodeToStr(docName));
                    var DNXmlBodyDATA = GetElementsByTagName(DNtempXML, 'DOCTITLE')[0];
                    var DNhtmlText = getNodeText(DNXmlBodyDATA);
                    document.querySelector('#docNameContent').innerText = DNhtmlText;
	                
	                // summary 변환 삽입
                    var summaryContentHtml = ConvertMHTtoHTML(summaryPath);
                    var tempXML = loadXMLString(summaryContentHtml);
                    var XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
                    var htmlData = getNodeText(XmlBodyDATA);
                    document.querySelector('#summaryContent').innerHTML = htmlData;
                } catch(e) {
                    console.log(e);
                    document.querySelector('#summaryContent').innerHTML = "<p>" + strLangJIH_Summary04 + "</p>";
                }
	            myVar = setInterval(function() { summaryPrintComplate(); }, 2000);
	        }
	        function summaryPrintComplate() {
	            if (!CrossYN() && NoneActiveX == "NO") {
	                preview_print();
	            } else {
	                window.print();
	            }
	            clearInterval(myVar);
	        }
	
	        function preview_print() { //미리보기 기능 선언
	            var OLECMDID = 7; //7이 미리보기,6이 인쇄,8이 페이지설정
	            var PROMPT = 1;
	            var WebBrowser = '<OBJECT ID="WebBrowser1" WIDTH=0 HEIGHT=0 CLASSID="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2"></OBJECT>';
	            document.body.insertAdjacentHTML('beforeEnd', WebBrowser);
	            WebBrowser1.ExecWB(OLECMDID, PROMPT);
	            WebBrowser1.outerHTML = "";
	            return false;
	        }
	        
	        function close_Click() {
				parent.DivPopUpHidden();
			}
			
			window.addEventListener("load", function() {
				if (isTeamsDesktop()) {
					document.getElementById("close").style.display = "";
				}
			})
	    </script>
	    <style>
			#close ul {
				list-style: none; margin: 0; padding: 0;
			}
			#close ul li {
				text-align: right;
				margin-left: auto;
				margin-right: 0;
			}
			#close ul li span {
				display:inline-block;
				width:25px;
				height:28px;
				background-image: url('/images/close_xBtn.png');
				background-repeat: no-repeat;
				background-position: 4px 6px;
				text-align: right;
			}
		</style>
	</head>
	<body scroll="auto" style="background: #fff">
	    <div style="margin: 0px 15px;">
            <div class='summaryPrintTtl' colspan='7'><p>▶ <spring:message code='ezApprovalG.apprBlAudit.14'/></p></div>
            <div id="close" style="display: none"><ul><li><span onclick="return close_Click()"></span></li></ul></div>
            <div class='summaryPrintContent'><p id='docNameContent'></p></div>
            <div class='summaryPrintTtl'><p>▶ <spring:message code='ezApprovalG.summary01'/></p></div>
            <div class='summaryPrintContent' id='summaryContent'></div>
        <div>
	</body>
</html>