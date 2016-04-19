<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>comm_make</title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/css/email_tree.css" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezCommunity.i1' />" type="text/css">
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/ezCommunity/common.js"></script>
		<script type="text/javascript" src="<spring:message code='ezCommunity.e1' />"></script>
		
		<script type="text/javascript">
			document.onselectstart = function () { 
				return false;
				};
			
			window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
			
			function check() {
		        var newID = "{" + GetGUID().toUpperCase() + "}";
		        var new_subID = "{" + GetGUID().toUpperCase() + "}";

		        document.make.sNewID.value = newID;
		        document.make.sNew_subID.value = new_subID;

		        if (document.make.clubname.value == "") {
		            alert("<spring:message code='ezCommunity.t2' />");

	                document.make.clubname.focus();

	                return;
	            }

	            if (document.make.clubname.value.length > 50) {
	                alert("<spring:message code='ezCommunity.t3' />");

	                document.make.clubname.focus();

	                return;
	            }

	            if (document.make.clubname2.value.length > 50) {
	                alert("<spring:message code='ezCommunity.t3' />");

	                document.make.clubname2.focus();

	                return;
	            }

	            if (document.make.intro.value.length > 2000) {
	                alert("<spring:message code='ezCommunity.t1009' />");

	                document.make.intro.focus();

	                return;
	            }

	            selA = parseInt(document.make.c_cate_a[document.make.c_cate_a.selectedIndex].value);
	            selB = parseInt(document.make.c_cate_b[document.make.c_cate_b.selectedIndex].value);
	            selC = parseInt(document.make.c_cate_c[document.make.c_cate_c.selectedIndex].value);

	            if (selA == 0 && selB == 0 && selC == 0) {
	                alert("<spring:message code='ezCommunity.t4' />");
	                make.c_cate_a.focus();

	                return;
	            }

	            if (document.make.intro.value == "") {
	                alert("<spring:message code='ezCommunity.t1010' />");

	                document.make.intro.focus();

	                return;
	            }

	            document.make.hidden_clubname.value = document.make.clubname.value;

	            if (document.make.clubname2.value != "") {
	                document.make.hidden_clubname2.value = document.make.clubname2.value;
	            }

	            if (document.make.intro.value != "") {
	                document.make.hidden_intro.value = document.make.intro.value;
	            }

	            document.make.submit();
	        }
			
			function back() {
	            if ("${flag }" == "1"){
	                window.open("/ezCommunity/mainPage.do", "right");
	            }else{
	                history.back(-1);
	            }
	        }
			
	        function btn_AttachSelect_onclick(num) {
	            if (num == "1"){
	                document.getElementById("file1").click();
	            }else{
	                document.getElementById("file2").click();
	            }
	        }
	        
	        function btn_AttachAdd_onclick(file) {
	            var fileid = file.id;
	            var fileval = document.getElementById(fileid).value;
	            var printspanid = "";
	            if (fileid == "file1"){
	                printspanid = "filename";
	            }else{
	                printspanid = "filename2";
	            }
	            if (fileval != "") {
	                var filename = fileval.substring(fileval.lastIndexOf("\\") + 1, fileval.length);

	                var extension = fileval.split(".");
	                var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
	                var bool = false;
	                for (var i = 0; i < filterExtension.length; i++) {
	                    if (extension[1].toLowerCase() == filterExtension[i]) {
	                        bool = true;
	                        break;
	                    }
	                }
	                if (!bool) {
	                    alert(filename + strLang40);
	                    document.getElementById(fileid).value = "";
	                    return;
	                }
	                if (!window.ActiveXObject){
	                    document.getElementById(printspanid).textContent = filename;
	                }else{
	                    document.getElementById(printspanid).innerText = filename;
	                }
	            }else {
	                if (!window.ActiveXObject){
	                    document.getElementById(printspanid).textContent = "";
	                }else{
	                    document.getElementById(printspanid).innerText = "";
	                }
	            }
	        }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezCommunity.t1011' /></h1>

	    <div id="mainmenu">
	        <ul>
	            <li><span id="btnDraft" onclick="javascript:check();"><spring:message code='ezCommunity.t1011' /></span></li>
	            <li><span id="btnDraft" onclick="javascript:back();"><spring:message code='ezCommunity.t109' /></span></li>
	        </ul>
	    </div>
	
	    <table class="content">
	        <form method="post" name="make" action="commMakeOk.do" enctype="multipart/form-data">
	            <input type="hidden" name="makeid" value="${UserInfo_UserID }">
	            <input type="hidden" name="hidden_clubname">
	            <input type="hidden" name="hidden_clubname2">
	            <input type="hidden" name="hidden_intro">
	            <input type="hidden" name="sNewID">
	            <input type="hidden" name="sNew_subID">
	            <tr>
	                <th><spring:message code='ezCommunity.t1012' /></th>
	                <td colspan="2">
	                    <input type="text" name="userName" value="${UserInfo_DisplayName }" readonly="true" size="40"></td>
	            </tr>
	            <tr>
	                <th>Community <spring:message code='ezCommunity.t10' /></th>
	                <td colspan="2" style="padding: 0">
	                    <table style="width:100%">
	                        <tr class="primary">
	                            <th>${lang_Primary }</th>
	                            <td>
	                                <input type="text" name="clubname" size="80" style="width: 100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
	                        </tr>
	                        <tr class="secondary">
	                            <th>${lang_Secondary }</th>
	                            <td>
	                                <input type="text" name="clubname2" style="WIDTH: 100%;box-sizing:border-box;-moz-box-sizing:border-box;"></td>
	                        </tr>
	                    </table>
	                </td>
	            </tr>
	            <tr>
	                <th style="height:40px;"><spring:message code='ezCommunity.t11' /></th>
	                <td style="white-space:nowrap"><span id="idSpan">${idSpanValue }</span></td>
	                <td style="padding: 5px;white-space:nowrap">
	                	<span>
	                		<spring:message code='ezCommunity.t1013' /><br>
	                		<spring:message code='ezCommunity.t1014' />
	                	</span>
	                </td>
	            </tr>
	            <tr>
	                <th style="height:40px;"><spring:message code='ezCommunity.t12' /></th>
	                <td style="white-space:nowrap">
	                    <input type="radio" name="clubConfirmtype" value="2" checked><spring:message code='ezCommunity.t13' />
	                    <input type="radio" name="clubConfirmtype" value="3"><spring:message code='ezCommunity.t1015' />
	                </td>
	                <td style="padding: 5px;white-space:nowrap">
	                	<spring:message code='ezCommunity.t452' /><br>
	                    <spring:message code='ezCommunity.t1016' />
	                </td>
	            </tr>
	            <tr>
	                <th style="height:40px;"><spring:message code='ezCommunity.t15' /></th>
	                <td style="white-space:nowrap">
	                    <input type="radio" name="clubtype" value="2" checked><spring:message code='ezCommunity.t16' />
	                    <input type="radio" name="clubtype" value="3"><spring:message code='ezCommunity.t17' />
	                </td>
	                <td style="padding: 5px;white-space:nowrap">
	                	<spring:message code='ezCommunity.t1017' /><br>
	                    <spring:message code='ezCommunity.t1018' />
	                </td>
	            </tr>
	            <tr style="display: none">
	                <th style="height:40px;"><spring:message code='ezCommunity.t1019' /></th>
	                <td style="white-space:nowrap">
	                    <input type="radio" name="isIN" value="1"><spring:message code='ezCommunity.t1020' />
	                    <input type="radio" name="isIN" value="2" checked><spring:message code='ezCommunity.t1021' />
	                </td>
	                <td style="padding: 5px;white-space:nowrap">
	                	<spring:message code='ezCommunity.t459' /><br>
	                    <spring:message code='ezCommunity.t1022' />
	                </td>
	            </tr>
	            <tr>
	                <th><spring:message code='ezCommunity.t1023' /></th>
	                <td>
	                    <span style="vertical-align:middle">
	                        <a class="imgbtn"><span id="btn_AttachAdd_logo" onclick="return btn_AttachSelect_onclick(1)"><spring:message code='ezCommunity.t1177' /></span></a>
	                        <span id="filename" style="vertical-align:middle"></span>
	                        <input type="file" id="file1" name="logo" onchange="btn_AttachAdd_onclick(this)" style="width: 1px; height: 1px;">
	                    </span>
	                </td>
	                <td style="padding: 5px;white-space:nowrap"><spring:message code='ezCommunity.t1024' /></td>
	            </tr>
	            <tr style="display:none;">
	                <th><spring:message code='ezCommunity.t1025' /></th>
	                <td>
	                    <span style="vertical-align:middle">
	                        <a class="imgbtn"><span id="btn_AttachAdd_banner" onclick="return btn_AttachSelect_onclick(2)"><spring:message code='ezCommunity.t1177' /></span></a>
	                        <span id="filename2" style="vertical-align:middle"></span>
	                        <input type="file" id="file2" name="banner" onchange="btn_AttachAdd_onclick(this)" style="width: 1px; height: 1px;">
	                    </span>
	                </td>
	                <td style="padding: 5px;white-space:nowrap"><spring:message code='ezCommunity.t1026' /></td>
	            </tr>
	            <tr>
	                <th>Community<spring:message code='ezCommunity.t18' /></th>
	                <td colspan="2">
	                    <textarea name="intro" style="height: 120px; width: 100%;box-sizing:border-box;-moz-box-sizing:border-box;"></textarea></td>
	            </tr>
	        </form>
	    </table>
	    <br>
	    <div class="txt">
	    	<br>
	    </div>
	</body>
</html>