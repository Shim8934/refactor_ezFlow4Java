<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezPersonal.t4465'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/conn_Cross.js')}"></script>
		<script type="text/javascript">
        
        function requestDraft(event) {
            event.preventDefault();
            
            var bodyHtml = document.getElementById('bodyHtml');
            bodyHtml.value = "";
            
            var userId = document.getElementById("userId").value;
            var deptId = document.getElementById("deptId").value;
            var keyId = document.getElementById("keyId").value;
            var formCode = document.getElementById("formCode").value;
            var title = document.getElementById("title").value;
            
            var messageStr = "";
            if (userId == "") {
                messageStr = "<spring:message code='ezApprovalG.connTest02'/>";
            } else if (deptId == "") {
                messageStr = "<spring:message code='ezOrgan.pyy1'/>";
            } else if (keyId == "") {
                messageStr = "<spring:message code='ezApprovalG.connTest03'/>";
            } else if (formCode == "") {
                messageStr = "<spring:message code='ezApprovalG.connTest04'/>";
            } else if (title == "") {
                messageStr = "<spring:message code='ezApprovalG.t1330'/>";
            }
            if (messageStr != "") {
                messageStr += "<spring:message code='ezApprovalG.connTest13'/>";
                alert(messageStr);
                return;
            }
            
            var editorContent = message.GetEditorContent();
            bodyHtml.value = editorContent;
            
            var infoMsg = "<spring:message code='ezApprovalG.connTest14'/>";
            OpenInformationUI(infoMsg, draftSubmit_Complete);
        }
        
        function draftSubmit_Complete(ans) {
            DivPopUpHidden();
            
            var formData = new FormData();
            
            var draftField = document.querySelectorAll(".draftField");
            draftField.forEach(function(input) {
                formData.append(input.name, input.value);
            });
        
            // 파일을 FormData 객체에 추가
            var files = $('#files')[0].files;
            for (var i = 0; i < files.length; i++) {
                formData.append('files', files[i]);
            }
            
            if (ans) {
                $.ajax({
                    type : "POST",
                    dataType : "text",
                    url : "/admin/ezApprovalG/insertApprGate.do",
                    data: formData,
                    contentType: false,
                    processData: false,
                    success: function(result){
                        openDraftWindow(result)
                    },
                    error: function() {
                        alert("<spring:message code='ezApprovalG.connTest15'/>");
                    }
                });
            } else {
                return false;
            }
        }
        function openAddModal() {
            $("<div id='blockLeft' class='blockLeft' style='width:100%;height:100%' onclick='parent.frames[\"right\"]'></div>").appendTo(parent.frames["left"].document.body);
            var popupX = parent.document.body.clientWidth/2 - (500/2) - 220;
            $("#addpopup").css("left", popupX);
            
            add_close();
            
            $("#addpopup").modal();
        }
        
        function add_close(){
            document.getElementById("param_ko").value = "";
            document.getElementById("param_en").value = "";
        }
        
        function addParameter() {
            var paramKo = document.getElementById('param_ko').value;
            var paramEn = document.getElementById('param_en').value;
            
            if (!paramKo || !paramEn) {
                alert();
                return;
            }
            
            var newRow = document.createElement("tr");
            var newTh = document.createElement("th");
            newTh.textContent = paramKo;
            newRow.appendChild(newTh);
            var newTd = document.createElement("td");
            newTd.colSpan = 3;
            var newInput = document.createElement("input");
            newInput.type= "text";
            newInput.name = paramEn;
            newInput.className = "draftField";
            newInput.id = paramEn;
            newInput.style.width = "100%";
            newTd.appendChild(newInput);
            newRow.appendChild(newTd);
            
            var bodyHtmlArea = document.getElementById("bodyHtmlArea");
            bodyHtmlArea.parentNode.insertBefore(newRow, bodyHtmlArea);
            
            modalCloseBtn.click();
            
        }
        
        function Editor_Complete() {
        }
        
        function resetFields() {
            var textInputs = document.querySelectorAll('.draftField, input[type="file"]');
            textInputs.forEach(function(input) {
                if (input.type === "text") {
                    input.value = '';
                } else if (input.type === "file") {
                    input.value = null;
                }
            });
            message.SetEditorContent("");
        }
        
        function alterCookie(pUserId) {
            var result = "";
            $.ajax({
                type : "POST",
                dataType : "text",
                async : false,
                url : "/admin/ezApprovalG/alterCookie.do",
                data : {userId : pUserId},
                success: function(text){
                }
            });
        }
        
        var ezapropinion_cross_dialogArguments = new Array();
        function OpenInformationUI(pInformationContent, CompleteFunction) {
            var parameter = pInformationContent;
            var url = "/ezApprovalG/ezAprOpinion.do";
        
            if (CrossYN()) {
                ezapropinion_cross_dialogArguments[0] = parameter;
                if (CompleteFunction != undefined)
                    ezapropinion_cross_dialogArguments[1] = CompleteFunction;
                else
                    ezapropinion_cross_dialogArguments[1] = OpenInformationUI_Complete;
                DivPopUpShow(330, 205, url);
            }
            else {
                var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
                feature = feature + GetShowModalPosition(330, 205);
                var RtnVal = window.showModalDialog(url, parameter, feature);
            }
            return RtnVal;
        }
        
        function OpenInformationUI_Complete() {
            DivPopUpHidden();
        }
        
        function openDraftWindow(redUrl) {
            var heigth = window.screen.availHeight; 
            var width = window.screen.availWidth;
            
            var left = 0; 
            var top = 0; 
 
            if (window.screen.width > 800) { 
                var pleftpos; 
 
                pleftpos = parseInt(width) - 1150; 
                heigth = parseInt(heigth) - 25; 
 
                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) 
                    heigth = parseInt(heigth) - 40; 
 
                width = parseInt(width) - pleftpos; 
 
                left = pleftpos / 2; 
            } 
            else { 
 
                heigth = parseInt(heigth) - 25; 
 
                if (navigator.userAgent.indexOf("Safari") > -1 && navigator.userAgent.indexOf("Chrome") == -1) 
                    heigth = parseInt(heigth) - 40; 
 
                width = parseInt(width) - 10; 
            } 
            var newWindow = window.open(redUrl, "_blank", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + heigth + ",width=" + width + ",top=" + top + ",left = " + left); 
            
            var checkWindowClosed = setInterval(function() {
                if (newWindow.closed) {
                    clearInterval(checkWindowClosed);
                    
                    var userIdVal = $('#userId').val();
                    var adminUserIdVal = $('#adminUserId').val();
                    
                    if (userIdVal != adminUserIdVal)
                        alterCookie(adminUserIdVal);
                }
            }, 1000);
        }
		</script>
	</head>
	<body class="mainbody" marginwidth="0" marginheight="0">
		<h1><spring:message code='ezApprovalG.connTest01'/></h1>
		<div id="mainmenu">
            <ul>
                <li class="important"><span onclick="openAddModal()"><spring:message code='ezApprovalG.connTest07'/></span></li>
                <li><a href="/files/ezApprovalConnTest_Guide.docx" download="<spring:message code='ezApprovalG.connTest01'/> <spring:message code='ezApprovalG.connTest16'/>"><span><spring:message code='ezApprovalG.connTest16'/></span></a></li>
            </ul>
        </div>
        <div id="contentList">
        <table class="content" style="width:800px;margin-top:20px">
            <tr>
                <th><spring:message code='ezApprovalG.connTest02'/></th>
                <td style="width:50%;">
                    <input type="text" class="draftField" name="userId" id="userId" value="" style="width:100%;"/>
                </td>
                <th><spring:message code='ezOrgan.pyy1'/></th>
                <td style="width:50%;">
                    <input type="text" class="draftField" name="deptId" id="deptId" value="" style="width:100%;"/>
                </td>
            </tr>
            <tr>
                <th><spring:message code='ezApprovalG.connTest03'/></th>
                <td style="width:50%;">
                    <input type="text" class="draftField" name="keyId" id="keyId" value="" style="width:100%;"/>
                </td>
                <th><spring:message code='ezApprovalG.connTest04'/></th>
                <td style="width:50%;">
                    <input type="text" class="draftField" name="formCode" id="formCode" value="" style="width:100%;"/>
                </td>
            </tr>
            <tr> 
                <th><spring:message code='ezApprovalG.t1330'/></th>
                <td style="width:50%;">
                    <input type="text" class="draftField" name="title" id="title" value="" style="width:100%;"/>
                </td>
                <th><spring:message code='ezApprovalG.t65'/></th>
                <td style="width:50%;">
                    <input type="file" name="files" id="files" style="width:100%;" multiple>
                </td>
            </tr>
            <tr id="bodyHtmlArea"> 
                <th><spring:message code='ezApprovalG.connTest05'/></th>
                <td colspan="3">
                    <iframe id="conn_html" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; width:100%; height: 400px; overflow: auto; margin-top:-1px"></iframe>
                </td>
            </tr>
        </table>
        <input type="hidden" class="draftField" name="bodyHtml" id="bodyHtml" value="" />            
        <input type="hidden" name="adminUserId" id="adminUserId" value="${userInfo.id}" />            
        </div>
    <div style="width:800px;text-align:center;margin-top:15px;">
        <div class="btnpositionJsp">
            <a class="imgbtn" onClick="requestDraft(event)"><span><spring:message code='ezApprovalG.connTest06'/></span></a>
            <a class="imgbtn" onClick="resetFields()"><span><spring:message code='ezApprovalG.t1301'/></span></a>
        </div>
    </div>
    
    <!-- 파라미터 추가 화면 -->
    <div id="addpopup" class="popupwrap1" style="display:none;margin-bottom:60px;">
        <div class="popupJQLayer">
            <div class="title"><spring:message code='ezApprovalG.connTest07'/></div>
            <div id="close">
                <ul>
                    <li><a id="modalCloseBtn" rel="modal:close"><span onclick="add_close()"></span></a></li>
                </ul>
            </div>
            <div>
            <span>* <spring:message code='ezApprovalG.connTest10'/></span><br>
            <span>* <spring:message code='ezApprovalG.connTest11'/></span>
            </div>
            <table class="popuplist" id="addpopup_list" style="width:478px;margin:10px 0px 0px 1px;">
                <tr>
                    <th style="width:90px;height:30px"><spring:message code='ezApprovalG.connTest09'/></th>
                    <td><input type="text" id="param_ko" name="param_ko" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="50"></td>
                </tr>
                <tr>
                    <th style="width:90px;height:30px"><spring:message code='ezApprovalG.connTest08'/></th>
                    <td><input type="text" id="param_en" name="param_en" class="textarea" style="width:98%;box-sizing:border-box;-moz-box-sizing:border-box;margin-left:3px" maxlength="50"></td>
                </tr>
            </table>
            <div class="btnpositionLayer">
                <a class="imgbtn"><span onclick="addParameter()"><spring:message code='ezApprovalG.t268'/></span></a>
            </div>
        </div>
    </div>
    
    <!-- ALERT 화면 -->
    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
    </div>
    
	</body>
</html>