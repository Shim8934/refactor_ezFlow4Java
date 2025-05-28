<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<title>문서편집</title>
	<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
	<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ezForm_Cross.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/admin/ModApprovalDoc.js')}"></script>
	<script type="text/javascript">
	var companyID = "<c:out value='${companyID}'/>";
	var filePath = "<c:out value='${url}'/>";
	var docID = "<c:out value='${docID}'/>";
	var htmlData = "";
    var WorkData = "";
    var useEditor = "<c:out value='${useEditor}'/>";
    var formHTML = "";
	
	$(document).ready(function() {
        
        var tempStr = ConvertMHTtoHTML(filePath);
        var tempXML = createXmlDom();
        var XmlBodyDATA = createXmlDom();
        
        tempXML.async = "false";
        tempXML = loadXMLString(tempStr);
        
        XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];        
        
        var doc_ContentHtml = document.createElement("DIV");
        doc_ContentHtml.innerHTML = getNodeText(XmlBodyDATA);
        
        htmlData = doc_ContentHtml.outerHTML;
	});
	
    function Editor_Complete() {        
        message.SetEditorContent(htmlData);
    }	
	
	function btn_save() {
		saveEditApprDoc();				
	}
	
	function btn_close() {
		window.close();
	}
	
	</script>
</head>
    <body class="popup">
    <input type="hidden" name="txt_OpinionContent" id="txt_OpinionContent" value="" />
    <input type="hidden" name="txt_OpinionContent1" id="txt_OpinionContent1" value="" />
    <input type="hidden" name="txt_OpinionContent2" id="txt_OpinionContent2" value="" />
        <div id="menu">
            <ul>
                <li><span id="btnSave" onClick="return btn_save()"><spring:message code='ezApprovalG.t1767' /></span></li>
            </ul>
        </div>
        <div id="close">
            <ul>
                <li><span id="btnClose" onClick="return btn_close()"></span></li>
            </ul>
        </div>		
        <div id="ApvForm_content2" style="width:100%; padding-top:10px;">
			<div id="editor_content" style="padding-top:5px;">
				<table id="TForm" style="height:770px; width:100%;">
					<tbody>
						<tr>
							<td style="height:770px; vertical-align:top">
								<iframe id="message" class="viewbox" src="/admin/ezEditor/selectApprovalEditor.do?type=ADMIN&height=770&formID=<c:out value='${docID}'/>" name="message" frameborder="0" style="padding:0; height:99%; width:800px; overflow:auto;"></iframe>
							</td>
							<td id="rootTD" name="rootTD" style="width:100%; vertical-align:top; text-align:left; padding-left:10px; display:none"></td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>        		
	</body>
</html>