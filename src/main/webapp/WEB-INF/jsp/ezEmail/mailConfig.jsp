<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <link rel="stylesheet" href="/css/Tab.css" type="text/css">
	    <script type = "text/javascript">
	        var pUse_Editor = "${useEditor}";
	        var p_Use_IE11Browser = "${useIE11Browser}";
	        var pNoneActiveX = "${noneActiveX}";
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
	            document.getElementById("1tab1").setAttribute("class", "tabon");
	            Tab1_SelectID = "1tab1";
	            ChangeTab(document.getElementById("1tab1"));
	            window_resize();
	
	            // 수신거부 : web.config 설정에 따라 출력
	            var DenyType = "${blockedSenders}";
	            if (DenyType == "YES")
	                document.getElementById("1tab9").style.display = "";
	        }
	        window.onresize = window_resize;
	        function window_resize() {
	            document.getElementById("MailEnv_ifrm").style.height = (document.documentElement.clientHeight - 120) + "PX";
	        }
	        function ChangeTab(obj) {
	            var pSelectTab = obj.getAttribute("divname");
	            switch (pSelectTab) {
	                case "MailEnv_div1":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailGeneral.do";
	                    break;
	                case "MailEnv_div2":
	                        document.getElementById("MailEnv_ifrm").src = "/myoffice/ezAddress/address_config.aspx";
	                    break;
	                case "MailEnv_div3":
	                    if (CrossYN() || (pNoneActiveX == "YES"))
	                        document.getElementById("MailEnv_ifrm").src = "mail_pop3_cross.aspx";
	                    else
	                        document.getElementById("MailEnv_ifrm").src = "mail_pop3.aspx";
	                    break;
	                case "MailEnv_div4":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailAutoForward.do";
	                    break;
	                case "MailEnv_div5":
	                    if (CrossYN())
	                        document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailInboxRule.do";
	                    else
	                        document.getElementById("MailEnv_ifrm").src = "mail_InboxRule.aspx";
	                    break;
	                case "MailEnv_div6":
	                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailAutoDelete.do";
	                    break;
	                case "MailEnv_div7":
	                    if (CrossYN()) {
	                        if (pUse_Editor == "TAGFREE")
	                            document.getElementById("MailEnv_ifrm").src = "mail_signature_TFX.aspx";
	                        else
	                            document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailSignatureCK.do";
	                    }
	                    else {
	                        if (pNoneActiveX == "YES")
	                            document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailSignatureCK.do";
	                        else {
	                            if (pUse_Editor == "TAGFREE")
	                                document.getElementById("MailEnv_ifrm").src = "mail_signature_TFI.aspx";
	                            else {
	                                if (p_Use_IE11Browser == "CK")
	                                    document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailSignatureCK.do";
	                                else
	                                    document.getElementById("MailEnv_ifrm").src = "mail_signature.aspx";
	                            }
	                        }
	                    }
	                    break;
	                case "MailEnv_div8":
	                    if (CrossYN()) {
	                        if (pUse_Editor == "TAGFREE")
	                            document.getElementById("MailEnv_ifrm").src = "mail_outofoffice_TFX.aspx";
	                        else
	                            document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailOutOfOfficeCK.do";
	                    }
	                    else {
	                        if (pUse_Editor == "TAGFREE")
	                            document.getElementById("MailEnv_ifrm").src = "mail_outofoffice_TFX.aspx";
	                        else
	                            document.getElementById("MailEnv_ifrm").src = "/ezEmail/mailOutOfOfficeCK.do";
	                    }
	                    break;
	                case "MailEnv_div9":
	                    document.getElementById("MailEnv_ifrm").src = "mail_ReceiveDeny.aspx";
	                    break;
	            }
	        }
	        var Tab1_SelectID = "";
	        function Tab1_MouserOver(obj) {
	            obj.className = "tabover";
	        }
	        function Tab1_MouserOut(obj) {
	            if(Tab1_SelectID != obj.id)
	                obj.className = "";
	        }
	        function Tab1_MouseClick(obj) {
	            obj.className = "tabon";
	            if (obj.id != Tab1_SelectID) {
	                if(Tab1_SelectID!="" && document.getElementById(Tab1_SelectID) != null)
	                    document.getElementById(Tab1_SelectID).className = "";
	
	                obj.className = "tabon";
	                Tab1_SelectID = obj.id;
	                ChangeTab(obj);
	            }
	        }
	        function Tab1_NewTabIni(pTabNodeID) {
	            for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
	                if (document.getElementById(pTabNodeID).childNodes.item(i).nodeName == "P") {
	                    if (document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).nodeName == "SPAN") {
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseover = function () { Tab1_MouserOver(this); }; ;
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onmouseout = function () { Tab1_MouserOut(this); }; ;
	                        document.getElementById(pTabNodeID).childNodes.item(i).childNodes.item(0).onclick = function () { Tab1_MouseClick(this); }; ;
	
	                        if (i == 0) {
	                            document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).className = "tabon";
	                            Tab1_SelectID = document.getElementById(pTabNodeID).childNodes.item(0).childNodes.item(0).id;
	                        }
	
	                    }
	                }
	            }
	        }
	        
	    </script>
	    <title><spring:message code='ezEmail.t904' /></title>
	</head>
	<body class="mainbody">
	    <h1><spring:message code='ezEmail.t10010' /></h1>
	        <div class="portlet_tabpart01">
		        <div class="portlet_tabpart01_top" id="tab1">
	                    <p id = "MailEnv_sub1"><span divname="MailEnv_div1" id="1tab1"><spring:message code='ezEmail.t177' /></span></p>
	                    <p id = "MailEnv_sub2"><span divname="MailEnv_div2" id="1tab2"><spring:message code='ezEmail.t99000041' /></span></p>
	                    <p id = "MailEnv_sub3"><span divname="MailEnv_div3" id="1tab3"><spring:message code='ezEmail.t238' /></span></p>
	                    <p id = "MailEnv_sub4"><span divname="MailEnv_div4" id="1tab4"><spring:message code='ezEmail.t137' /></span></p>
	                    <p id = "MailEnv_sub5"><span divname="MailEnv_div5" id="1tab5"><spring:message code='ezEmail.t146' /></span></p>
	                    <p id = "MailEnv_sub6"><span divname="MailEnv_div6" id="1tab6"><spring:message code='ezEmail.t117' /></span></p>
	                    <p id = "MailEnv_sub7"><span divname="MailEnv_div7" id="1tab7"><spring:message code='ezEmail.t283' /></span></p>
	                    <p id = "MailEnv_sub8"><span divname="MailEnv_div8" id="1tab8"><spring:message code='ezEmail.t203' /></span></p>
		                <%--<p id = "MailEnv_sub9"><span divname="MailEnv_div9" id="1tab9" style="display:none;"><%=RM.GetString("t270")%></span></p>--%>
	            </div>
	        </div>
	        <iframe id = "MailEnv_ifrm" style ="width:100%;height:100%;" frameborder="0" ></iframe>
	</body>
	<script type="text/javascript">
	    Tab1_NewTabIni("tab1");
	</script>
</html>
