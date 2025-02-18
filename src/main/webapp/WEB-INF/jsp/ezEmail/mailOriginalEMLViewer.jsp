<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
    <head>
        <title><spring:message code='ezEmail.t535' /></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
        <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
        <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    
        <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/email_tree.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview.htc.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/string_component_utf8.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/encode_component.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
        <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
        
        <script>
            var CancelFunction;
            
            function window_onload() {
                try {
                    CancelFunction = parent.mail_originalEML_cross_dialogArguments[1];
                } catch (e) {
                    try {
                        CancelFunction = opener.mail_originalEML_cross_dialogArguments[1];
                    } catch (e) { }
                }
            }
            
            function popup_close() {
                CancelFunction();
            }
            
        </script>
    
    </head>

    <body scroll="no" class="popup" onload="javascript:window_onload()">
        <h1 style="z-index: 2"><spring:message code='ezEmail.kdh03' /></h1>
        <div id="close">
            <ul>
                <li><span onclick="popup_close();"></span></li>
            </ul>
        </div>
        <div style="height:calc(100vh - 90px); overflow-y: auto; padding: 5px; border: 1px solid #ddd">
            <pre>${emlText}</pre>
        </div>
    </body>
</html>



