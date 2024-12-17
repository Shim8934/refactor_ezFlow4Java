<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	<title>Insert title here</title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css" />
    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
    <script type="text/javascript">
        var pUse_Editor = "";
        var pNoneActiveX = "";
        window.onload = window_onload;
        document.onselectstart = function () { return false; };
        function window_onload() {
            if (navigator.userAgent.indexOf('Firefox') != -1) {
                document.body.style.MozUserSelect = 'none';
                document.body.style.WebkitUserSelect = 'none';
                document.body.style.khtmlUserSelect = 'none';
                document.body.style.oUserSelect = 'none';
                document.body.style.UserSelect = 'none';
            }
            document.getElementById("BoardEnv_ifrm").src = "/ezBoard/boardPollSetting.do";
            window_resize();
        }
        window.onresize = window_resize;
        function window_resize() {
            document.getElementById("BoardEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "PX";
        }
    </script>
</head>
<body class="mainbody">
    <h1><spring:message code='ezPoll.hdp20'/></h1>
    <div class="portlet_tabpart01">
        <div class="portlet_tabpart01_top" id="tab1">
            <p id="BoardEnv_sub3" style="display: block"><span divname="BoardEnv_div3" id="1tab3" class="tabover"><spring:message code="ezPoll.hsbCf01" /></span></p>
        </div>
    </div>
    <iframe id="BoardEnv_ifrm" style="width: 100%; height: 100%;" frameborder="0" ></iframe>
</body>
</html>