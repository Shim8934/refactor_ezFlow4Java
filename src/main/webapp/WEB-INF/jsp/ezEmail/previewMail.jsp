<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %><html>
<head>
    <title><spring:message code="ezEmail.ksy01"/></title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <link rel="stylesheet" type="text/css" href="${util.addVer('/css/previewmail.css')}">
    <link href="${util.addVer('/js/jquery/jquery.modal.css')}" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="${util.addVer('/css/jquery-ui.css')}" type="text/css">
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/input-util.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery.modal.js')}"></script>
    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-ui.js')}"></script>
    <script type="text/javascript">
        
        let arguments = parent.previewMail_cross_dialogArguments[0]
        let _href = arguments.get('_href');
        let isSecureMail = arguments.get('isSecureMail') === '1' ? true : false;
        
        function windows_close() {
            parent.document.getElementById("iFramePanel_mail_preview").style.display = "none";
            parent.document.getElementById("mail_preview_Layer").src = "/blank.htm";
            parent.document.getElementById("iFramePanel_mail_preview").classList.remove("on");
            // window.close();
        }

        window.onload = function() {
            getPreviewMail();
        }
        
        function btn_ok_onclick () {
            
        }
        
        function getPreviewMail() {
            $.ajax({
                type	: "POST",
                contentType	: "application/json",
                data	: JSON.stringify({
                                _href: _href,
                                shareId: (parent.shareId)? parent.shareId : null
                            }),
                url		: "/ezEmail/getPreviewMail.do",
                async	: true,
                success	: function(data) {
                    
                    if ("OK" !== data.code) {
                        console.log(data.msg);
                    } else {
                        const result = data.result;
                        const textArea = document.querySelector("#text_area > p");
                        textArea.textContent = result.mailbody;
                        
                        const isAttach = result.isAttach;
                        if (isAttach === 'OK') {
                            document.getElementById('attach_area').style.display='block';
                            document.getElementById('pAttachListHtmlSub').innerHTML = result.pAttachListHtmlSub;
                            document.getElementById('PreviewAttachList').innerHTML = result.pAttachListHtml;
                            screenCalculation();
                        } else {
                            const contentHeight = document.getElementById('content').offsetHeight;
                            const btnAreaHeight = document.getElementById('btn_area').offsetHeight;
                            document.getElementById('text_area').style.maxHeight = contentHeight-btnAreaHeight + 'px';
                        }
                    }
                    
                },
                error	: function(error) {
                    //hideLoading();
                    console.log(error);
                    alert("<spring:message code='ezEmail.ls013' />");
                    
                }
            })
        }
        
        function screenCalculation() {
            const parentDiv = document.getElementById('content').offsetHeight;
            const btnAreaHeight = document.getElementById('btn_area').offsetHeight;
            const totalHeight = parentDiv - btnAreaHeight + 35;

            const heightDiv1 = (totalHeight * 2) / 3; // 2/3
            const heightDiv2 = (totalHeight * 1) / 3; // 1/3
            
            const attachAreaHeight = document.getElementById('attach_area').offsetHeight;
            if (attachAreaHeight < 90) {
                // 첨부파일 한개일때
                document.getElementById('text_area').style.height = heightDiv1 + 'px';
            } else {
                // 첨부파일 두개일때
                document.getElementById('text_area').style.maxHeight = '133px';
            }
            // document.getElementById('text_area').style.maxHeight = '130px';
            // document.getElementById('attach_list').style.maxHeight = heightDiv2 + 'px';
            document.getElementById('attach_list').style.maxHeight = '70px';
        }

        function AttachDetail_view(obj) {
            
            if (obj.className == "icon_graydown") {
                obj.className = "icon_grayup"
                document.getElementById("PreviewAttachList").style.display = "";
            } else {
                obj.className = "icon_graydown"
                document.getElementById("PreviewAttachList").style.display = "none";
            }
        }
        
        function DownloadAttach(DownloadUrl) {
            AttachDownFrame.location.href = DownloadUrl;
        }

        // 메일읽기창에서 "모두저장" 클릭시 압축파일로 내보내는 메서드
        var suffix = 0;
        function AttachAllDownload() {

            var url = "/ezEmail/downloadAttachAll.do";

            if (typeof(shareId) != "undefined" && shareId != "") {
                url += "?shareId=" + encodeURIComponent(shareId);
            }

            var fileLen = document.getElementsByName("MailAttachDownloadItems").length;
            var params = "";
            var folderPath = "";
            var uid = "";

            if (suffix < fileLen) {

                for (var i = 0; i < fileLen; i++) {
                    var fileHref = document.getElementsByName("MailAttachDownloadItems").item(suffix++).getAttribute("_filehref");
                    var strArr = fileHref.split('?');
                    strArr = strArr[1].split('&');

                    if (i < 1) {
                        var tmpStr = strArr[1].split('=');
                        folderPath = tmpStr[1];

                        tmpStr = strArr[2].split('=');
                        uid = tmpStr[1];

                        params = strArr[3] + "&" + strArr[4] + "&" + strArr[5] + "&" + strArr[6];
                    } else {
                        params += "&" + strArr[3] + "&" + strArr[4] + "&" + strArr[5] + "&" + strArr[6];
                    }

                }

            }

            suffix = 0;

            var $frm = $("<form></form>");
            $frm.attr('action', url);
            $frm.attr('method', 'post');
            $frm.appendTo('body');

            params = $('<input type="hidden" value="' + params + '" name="params" />');
            folderPath = $('<input type="hidden" value="' + decodeURIComponent(folderPath) + '" name="folderPath" />');
            uid = $('<input type="hidden" value="' + uid + '" name="uid" />');

            $frm.append(params).append(folderPath).append(uid);
            $frm.submit();
        }
        
        var g_deleteHttp = null;
        function delete_mail() {

            if (g_deleteHttp != null)
                return;
            try {
                //BDELETE 영구삭제
                //BMOVE 일반삭제
                var mailbox = parent.g_szRootFolderName;
                var cmdType =  mailbox.replace(' ', '') === strLang4 ? "BDELETE" : "BMOVE";

                if (isSecureMail) {
                    if (!confirm(strLangLHM19)) {
                        return;
                    }
                } else if (cmdType === 'BDELETE') {
                    if (!confirm(strLang58)) {
                        return;
                    }
                } else {
                    if (!confirm(strLang59)) {
                        return;
                    }
                } 

                g_deleteHttp = createXMLHttpRequest();
                var xmlDOM = createXmlDom();
                
                var objNode;
                createNodeInsert(xmlDOM, objNode, "DATA");
                createNodeAndInsertText(xmlDOM, objNode, "CMD", cmdType);
                createNodeAndInsertText(xmlDOM, objNode, "UNIQUEID", _href);
                createNodeAndInsertText(xmlDOM, objNode, "FOLDERID", "");

                var url = "/ezEmail/mailDelete.do?cmd="+cmdType;

                if (typeof(shareId) != "undefined" && shareId != "") {
                    url += "&shareId=" + encodeURIComponent(shareId);
                }

                g_deleteHttp.open("POST", url, true);
                g_deleteHttp.onreadystatechange = event_deletemail_end;
                g_deleteHttp.send(xmlDOM);

            }
            catch (e) {
                console.log(e);
            }

            
        }

        function event_deletemail_end() {
            if (g_deleteHttp != null && g_deleteHttp.readyState == 4) {
                if (g_deleteHttp.status < 200 || g_deleteHttp.status > 300) {
                    g_deleteHttp = null;
                    alert(strLang131);
                }
                else {
                    g_deleteHttp = null;
                    windows_close();
                    try {
                        parent.MailListRefresh();
                    } catch (e) {console.log(e);}
                }

            }
        }
        
        
        function moveHackingMail_previewMail () {
            
            parent.moveHackingMail(_href);
            
            windows_close();
        }
    </script>
</head>
<body>
    <div class="preview_mail_wrap" >
        <div class="preview_mail_cont" id="content">
            <div id="text_area" class="preview_mail_text">
                <p></p>
            </div>
            <div class="previewmail_addfile" id="attach_area" style="display: none">
                <div class="title">
                    <p>
                        <spring:message code='ezEmail.t99000003' />
                        <span id="pAttachListHtmlSub"></span>
<%--                        <span class="icon_grayup" id="BtnAttachDetail" onclick="AttachDetail_view(this);"></span>--%>
                        <span class="title_btn" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload(this);">
                        <spring:message code='ezEmail.t99000004' /></span>
                    </p>
                </div>
                <div class="preview_mail_attach" id="attach_list">
                    <ul class="list" id="PreviewAttachList"></ul>
                </div>
            </div>

        </div>
        <div class="btnposition btnpositionNew" id="btn_area">
            <a class="imgbtn" onclick="return delete_mail()"><span><spring:message code="ezPoll.t202" /></span></a>
            <a class="imgbtn" onclick="return moveHackingMail_previewMail()"><span><spring:message code="ezEmail.zno002" /></span></a>
            <a class="imgbtn" onclick="windows_close()"><span><spring:message code="main.t3" /></span></a>
        </div>
    </div>
    <iframe name="AttachDownFrame" id="AttachDownFrame" width=0 height=0 frameborder=0 marginheight=0 marginwidth=0 scrolling=no style="display:none"></iframe>
</body>
</html>