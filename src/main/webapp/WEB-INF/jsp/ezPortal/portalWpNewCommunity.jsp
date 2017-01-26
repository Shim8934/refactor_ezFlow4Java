<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='main.t1006' /></title>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<link href="/css/main.css" rel="stylesheet" type="text/css">
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
		 document.onselectstart = function () { return false; };
	        window.onload = function () {
	            if (navigator.userAgent.indexOf('Firefox') != -1) {
	                document.body.style.MozUserSelect = 'none';
	                document.body.style.WebkitUserSelect = 'none';
	                document.body.style.khtmlUserSelect = 'none';
	                document.body.style.oUserSelect = 'none';
	                document.body.style.UserSelect = 'none';
	            }
	            
	            try { top.onresize() } catch (e) { }
	        }
	        function Copmore_btnClick() {
	            window.open("/ezCommunity/communityMain.do?funCode=5", "main", "");
	        }
	        function go_best(idx, clubgubun) {
	         /*    var xmlhttp = createXMLHttpRequest();
	            var xmldom = createXmlDom();
	            var objNode;

	            createNodeInsert(xmldom, objNode, "DATA");
	            createNodeAndInsertText(xmldom, objNode, "CID", idx);
	            createNodeAndInsertText(xmldom, objNode, "UID", "${userInfo.id}");

	            xmlhttp.open("POST", "/ezCommunity/getACL.do", false);
	            xmlhttp.send(xmldom);

	            if (xmlhttp.responseText == "ERR" || clubgubun == "1") {
	                OpenAlertUI("<spring:message code='main.t1004' /><br><spring:message code='main.t1005' />", null, "wp_NewCommunity.aspx.OpenAlertUI");
	            } else {
	                var wWeight = "1300";
	                var wHeight = "900";

	                var heigth = window.screen.availHeight;
	                var width = window.screen.availWidth;

	                var left = (width - wWeight) / 2;
	                var top = (heigth - wHeight) / 2 - 30;

	                var ret = window.open("/myOffice/ezCommunity/Check_commhome.aspx?communityCD=" + idx + "&UserLevel=1", "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
	            }  */
	            
	        	$.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezCommunity/remote/getACL.do",
					data : { cID	:	idx,
							 uID	:	"${userInfo.id}"
					},
					success: function(result){
						if (result == "ERR" || clubgubun == "1") {
							OpenAlertUI("<spring:message code='main.t1004'/><br><spring:message code='main.t1005'/>", null, "/ezPortal/wpNewCommunity.do.OpenAlertUI");
						} else {
							var wWeight = "1300";
			                var wHeight = "900";

			                var heigth = window.screen.availHeight;
			                var width = window.screen.availWidth;

			                var left = (width - wWeight) / 2;
			                var top = (heigth - wHeight) / 2 - 30;

			                var ret = window.open("/ezCommunity/checkCommHome.do?communityCD=" + idx, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=0,resizable=1,height=" + wHeight + ",width=" + wWeight + ",top=" + top + ",left = " + left);
						}
					}
				});
	        }

	        var ezapralert_cross_dialogArguments = new Array();
	        function OpenAlertUI(NewWinContent, NewWinCallFunction, NewWinName) {
	            var parameter = NewWinContent;

	            if (CrossYN()) {
	                ezapralert_cross_dialogArguments[0] = parameter;

	                if (NewWinCallFunction != undefined || NewWinCallFunction != null)
	                    ezapralert_cross_dialogArguments[1] = CompleteFunction;
	                else
	                    ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;

	                var windowopenfeature = "height=205px,width=330px,status=no,toolbar=no,menubar=no,location=no,resizable=1";
	                windowopenfeature = windowopenfeature + GetOpenPosition(205, 330);

	                window.open("/ezCommunity/ezAprAlert.do", NewWinName, windowopenfeature);
	            } else {
	                var windowshomodalDialogfeature = "status:no;dialogWidth:330px;dialogHeight:207px;help:no;scroll:no;edge:sunken";
	                windowshomodalDialogfeature = windowshomodalDialogfeature + GetShowModalPosition(330, 205);
	                var RtnVal = window.showModalDialog("/ezCommunity/ezAprAlert.do", parameter, windowshomodalDialogfeature);
	            }
	        }

	        function OpenAlertUI_Complete() {
	            //Source Code...
	        }	
		</script>
	</head>
	<body class="body_bg1">
    	<article class="portletbox communitybox">
	        <div class="title">
    	        <span class="tl"></span>
        	    <span class="tr"></span>
            	<span class="title_txt"><spring:message code='main.t1006' /></span>
            	<span class="btn_more" onclick="Copmore_btnClick()">
                	<img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />" >
            	</span>
        	</div>
        	<div id="tblBest" class="communitycont" runat="server">${strHTML}</div>
        	<div class="guide"><span class="lb"></span><span class="rb"></span></div>
    	</article>
	</body>	
</html>