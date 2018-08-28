<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='main.t1006' /></title>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<style>
			.listtype_photo {
				margin : 0px;
				padding : 14px 0px 14px 0px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
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
	<!-- 2018-08-21 장진혁 포틀릿 변경으로 주석처리 -->
	<%-- <body class="body_bg1">
    	<article class="portletbox communitybox">
	        <div class="title">
    	        <span class="tl"></span>
        	    <span class="tr"></span>
            	<span class="title_txt"><spring:message code='main.t1006' /></span>
            	<span class="btn_more" onclick="Copmore_btnClick()">
                	<img src="/images/kr/main/btn_more02.gif" width="35" height="20" alt="<spring:message code='main.t1008' />" >
            	</span>
        	</div>
        	<div id="tblBest" class="communitycont" style="${strHTML != '' ? 'padding-top:0px' : ''}">
        		<c:if test="${strHTML != ''}">${strHTML}</c:if>
        		<c:if test="${strHTML == ''}">
        			<div class="nodata_portlet">
 						<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
						<p><spring:message code='main.t00026' /></p>
					</div>
        		</c:if>
        	</div>
        	<div class="guide"><span class="lb"></span><span class="rb"></span></div>
    	</article>
	</body>	 --%>
	<body>
		<article class="community box_shadow">
	        <dl class="portlet_title">
	            <dt class="portletText"><spring:message code='main.t1006' /></dt>
	            <dd class="portletPlus" onclick="Copmore_btnClick()"><img src="/images/kr/main/portlet_Plus.png"></dd>
	        </dl>
	        <div class="community_list">
	            <c:if test="${strHTML != ''}">${strHTML}</c:if>
        		<c:if test="${strHTML == ''}">
        			<div class="nodata_portlet">
 						<p><img width='92' height='84' src='/images/kr/main/nodata_plan.png' /></p>
						<p><spring:message code='main.t00026' /></p>
					</div>
        		</c:if>
	        </div>
	    </article>
	</body>
</html>