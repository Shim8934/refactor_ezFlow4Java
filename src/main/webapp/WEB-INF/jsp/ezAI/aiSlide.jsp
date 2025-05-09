<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery-ui/jquery.multipleSortable.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezAI/ezAISlideCommon.js')}"></script>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/ai.css')}" type="text/css">
		<style>
			#aiView {
                cursor: default;
                user-select: none;
            }
		</style>
		<script type="text/javascript">
            var aiAttachMBSize = parseInt("${aiAttachMBSize}", 10) || 0;;
            var msgEdit = "<spring:message code="ai.chat.button.edit" />";
            var msgComplete = "<spring:message code="ai.chat.button.complete" />";
            var msgCopy = "<spring:message code="ai.chat.button.copy" />";
            var msgCopySucc = "<spring:message code="ai.chat.button.copy.sussess" />";
            var msgCopyFail = "<spring:message code="ai.chat.button.copy.fail" />";
            var msgErrData = "<spring:message code="ai.chat.err.data" />";
            var msgErrRes = "<spring:message code="ai.chat.err.response" />";
            var msgErrShow = "<spring:message code="ai.chat.err.show" />";
            var msgErrExtract = "<spring:message code="ai.chat.err.extract" />";
            var msgErrUpload = "<spring:message code="ai.chat.err.fileupload" />";
            var attachFileNameMaxLength = ${attachFileNameMaxLength};
        </script>
    </head>
    <body> 
        <div class="ds_lay_viewOpenAI" id="simpleAi" style="" data-type="email" data-subtype="read" data-data="" data-call="false">
            <p id="aiView" class="rightDocinfoBtn" onclick="fn_showViewoption()">
                <span class="appr_info_btn rightAiBtn"><span class="docinfotoggleimg on"></span></span>
            </p>
            <p class="ai_explain"><spring:message code="ai.slide.explain" /></p>
            <div class="ds_settings_section_body">
                <div class="wrapAI chatUI">
                    <!-- 20250402 header 추가 -->
                    <div class="headerAI">
                        <p class="btn_function">
                            <button type="button" onclick="fn_showViewoption()" class="btn_close"></button>
                        </p>
                    </div>
                    <!-- //20250402 header 추가 -->
                    <div class="container_main_simple">
                        <%-- chat talk --%>
                        <div class="chatTalk">
                            <div id= "chatContent" class="ai_cont">
                                <!-- 초기화면 -->
                                <div name="chatText" class="ai_text">
                                    <span class="icon_ai"></span>
                                    <span class="ai_text_title"><spring:message code="ai.chat.title" /></span>
                                    <span class="ai_text_detail"><spring:message code="ai.chat.detail" /></span>
                                </div>
                                <div name="chatText" class="ai_text_question">
                                    <span id="simpleSummary" onclick="simplePrompt(this)" class="ai_text_list" data-simpletype="1" data-comment="내용을 요약해 주세요.">
                                        <a style="cursor: pointer;"><spring:message code="ai.chat.simple.request.sum" /></a>
                                    </span>
                                    <span id="simpleReply" onclick="simplePrompt(this)" class="ai_text_list" data-simpletype="2" data-comment="회신 내용을 작성해 주세요.">
                                        <a style="cursor: pointer;"><spring:message code="ai.chat.simple.request.reply" /></a>
                                    </span>
                                    <span id="simpleTranslate" onclick="simplePrompt(this)" class="ai_text_list" data-simpletype="3" data-comment="영어로 번역해 주세요.">
                                        <a style="cursor: pointer;"><spring:message code="ai.chat.simple.request.Translate" /></a>
                                    </span>
                                </div>
                                <%-- 예시 화면
                                <div class="user_text" id="{de558682-96ba-4693-ab76-fa54f29bf8b8}">내용요약</div>
                                <div class="ai_text">
                                    <span class="icon_ai"></span>
                                        <span class="ai_text_detail" id="0307e663-841b-997f-d36a-8c49b9aec636">
                                            <p>출장비 규정은 임직원이 회사의 업무를 수행하기 위해 국내외에 출장을 갈 때 지급되는 여비에 대한 기준과 절차를 정한 것입니다. 주요 내용은 다음과 같습니다:</p>
                                            <h3>1. 목적</h3>
                                            <ul>
                                                <li>출장비 지급 규정은 임직원이 출장 시 여비 지급에 관한 기준과 절차를 정하는 것을 목적으로 합니다.</li>
                                            </ul>
                                            <p>이 외에도 구체적인 지급 기준이나 절차에 대한 내용이 포함되어 있습니다. 더 궁금한 사항이 있으면 말씀해 주세요! </p>
                                            <p>출처: 출장여비지급규정-20201231.pdf</p>
                                        </span>
                                        <button type="button" data-mode="EDIT">편집</button>
                                        <button type="button">복사</button>
                                    </div>
        
                                    ai 로딩 
                                    <div class="ai_text al_loading">
                                        <span class="icon_ai"></span>
                                        <span class="loading_icon"></span>
                                    </div> 
                                </div> --%>
                            </div>
                        </div>
                    </div>
                    <%-- //chat talk--%>

                    <%-- 입력box --%>
                    <div class="textarea_value_position">
                        <%-- (tag 사용안하기로 함) 
                        <ul class="ai_tag">
                            <li onclick="executeOpenAI(this)" data-simpletype="1" data-comment="내용을 요약해 주세요.">#내용요약</li>
                            <li onclick="executeOpenAI(this)" data-simpletype="2" data-comment="회신 내용을 작성해 주세요.">#회신내용작성</li>
                            <li onclick="executeOpenAI(this)" data-simpletype="3" data-comment="영어로 번역해 주세요.">#번역(영어)</li>
                        </ul>--%>
                        <div class="textarea_value" id="dropZone">
                            <textarea id="chatInput" rows="2" placeholder="<spring:message code='ai.chat.plceholder' />" onkeyup=""></textarea>
                            <div class="refDocuments">
                                <div class="upload_file">
                                    <%--<button type="button" style="" class="btn_upload_drop">4개</button>
                                    <span id="f12d9212-aa4f-4b10-b2dd-c4ecfb88a58c" data-filepath="/Upload_Common/2025/04/09/ezAI/f12d9212-aa4f-4b10-b2dd-c4ecfb88a58c.pdf" data-filename="전자계약시스템_사용자 매뉴얼.pdf" data-file-size="3091151" data-file-ext="">전자계약시스템_사용자 매뉴얼.pdf<button type="button" class="btn_close"></button></span><span id="8ea131d3-060b-4c0d-88de-90ac26bb7540" data-filepath="/Upload_Common/2025/04/09/ezAI/8ea131d3-060b-4c0d-88de-90ac26bb7540.jpeg" data-filename="AdobeStock_1079135365 (1).jpeg" data-file-size="3686856" data-file-ext="">AdobeStock_1079135365 (1).jpeg<button type="button" class="btn_close"></button></span><span id="16598385-ab7a-4bea-b896-b6f7d8c371bb" data-filepath="/Upload_Common/2025/04/09/ezAI/16598385-ab7a-4bea-b896-b6f7d8c371bb.jpeg" data-filename="AdobeStock_1079135365 (2).jpeg" data-file-size="3686856" data-file-ext="">AdobeStock_1079135365 (2).jpeg<button type="button" class="btn_close"></button></span><span id="fddca0be-8fc0-46e5-b771-09290c9fef0e" data-filepath="/Upload_Common/2025/04/09/ezAI/fddca0be-8fc0-46e5-b771-09290c9fef0e.jpeg" data-filename="AdobeStock_1175719583.jpeg" data-file-size="2942271" data-file-ext="">AdobeStock_1175719583.jpeg<button type="button" class="btn_close"></button></span>--%>
                                </div>
                                <button type="button" class="btn_value_file" onclick="btnfileup()"></button>
                                <button id="sendChatModelBtn" type="button" class="btn_value_send" onclick="userInput()"></button>
                            </div>
                        </div>
                    </div>
                    <%-- //입력box --%>
                    <input id="file" type="file" onchange="filechange(event);return false;" multiple="multiple" style="width:1px;height:1px;display:none;" />
                    <input type="hidden" value="업로드" onclick ="fileupload()" />
                </div>
            </div>
        </div>
    </body>
</html>