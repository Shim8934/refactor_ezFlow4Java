<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t367'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezApprovalG/appandbody_Cross.js')}"></script>
	    <script type="text/javascript">
	        var pDocHref = "<c:out value ='${docID}'/>";
	        
	        var flag = false;
	        window.onload = function () {
	        }
	        function DocumentComplete() {
	            if (flag == false) {
	                flag = true;
	
	                if (pDocHref != "") {
	                    message.Set_EditorContentURL(pDocHref);
	                }
	            }
	        }
	        function FieldsAvailable() {
	            message.SetEditable(false);
	        }
	        function btnPrint_onclick() {
	
	            PrintClick("Cross", pDocHref, "");
	
	        }
	
	        function pzFormProc_InvalidDocument() {
	        }
	        function btnClose_onclick() {
	            window.close();
	        }
	        function btnSave_onclick() {
	            var pDocID = "", pDocTitle = "";
	            try {
	                var pPos1 = pDocHref.lastIndexOf("/");
	                pDocID = pDocHref.substring(pPos1 + 1).split("-")[0];
	                pDocTitle = getNodeText(message.document.getElementById("doctitle")).trim();
	            } catch (e) {
	                pDocTitle = "No Title";
	                pDocID = "No DocID";
	            }
	            var rtnVal = SavePCFile(pDocID, pDocTitle);

	            //activeX 일단 제외
	            if (window.ActiveXObject) {
	                rtnVal = rtnVal.replace("/Upload_Common/", "/myoffice/common/downloadattach.aspx?filepath=/Upload_Common/");
	                var filename = rtnVal.split("/")[rtnVal.split("/").length - 1];
	                rtnVal = rtnVal + "&filename=" + filename;
	                rtnVal = ReplaceText(rtnVal, filename, encodeURIComponent(filename));
	                AttachDownFrame.location.href = rtnVal;
	            } else {
	            	/*  2018-09-19 홍승비 - 기존  ezCommon/downloadAttach.do 사용하던 부분 수정 */
	                AttachDownFrame.location.href = "/ezApprovalG/downloadAttach.do?filePath=" + encodeURIComponent(rtnVal);
	            }
	        }
	
	        function SavePCFile(DocID, pDocTitle) {
				var result = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/savePCTmpFile.do",
		    		data : {
		    			docID     : DocID,
		    			docTitle  : pDocTitle,
		    			docHref   : pDocHref
		    		},
		    		success: function(xml){
		    			result = xml;
		    		}        			
		    	});
	
	            return result;
	        }
	
	    </script>
	</head>
	<body class="popup">
	    <table class="layout">
	        <tr>
	            <td height="20">
	                <div id="menu">
	                    <ul>
	                        <li><span onclick="return btnSave_onclick()"><spring:message code='ezApprovalG.t59'/></span></li>
	                        <li><span onclick="return btnPrint_onclick()"><spring:message code='ezApprovalG.t60'/></span> </li>
	                    </ul>
	                </div>
	                <div id="close">
	                    <ul>
	                        <li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
	                    </ul>
	                </div>
	            </td>
	        </tr>
	        <tr>
	            <td style="padding-bottom: 10px">
	                <iframe id="message" class="withoutThisTableTheImageInTheLeftColumnDoesNotRepeatInFirefox" src="/ezApprovalG/aprDocViewContent.do" name="message" frameborder="0" style="padding: 0; height: 100%; width: 100%; overflow: auto;"></iframe>
	            </td>
	        </tr>
	    </table>
	    <script type="text/javascript">
	        selToggleList(document.getElementById("menu"), "ul", "li", "0");
	    </script>
	    <iframe name="AttachDownFrame" id="AttachDownFrame" src="about:blank" width="0" height="0" frameborder="0" marginheight="0" marginwidth="0" scrolling="no" style="display: none"></iframe>
	</body>
</html>