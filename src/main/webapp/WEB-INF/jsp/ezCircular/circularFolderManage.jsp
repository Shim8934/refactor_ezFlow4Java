<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>회람문서함 관리</title>
        <meta http-equiv='Content-Type' content='text/html; charset=utf-8' />
		<link rel="stylesheet" href="<spring:message code='main.lhm02' />" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="/js/ezEmail/<spring:message code='ezEmail.c1' />"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript">
			var inputNameDlg_cross_dialogArguments = new Array();
			
			function add_onclick() {
// 			    if (PostTreeView.selectedIndex() == -1) {
// 			        alert("<spring:message code='ezEmail.t158' />");
// 			        return;
// 			    }
			    
			    inputNameDlg_cross_dialogArguments[0] = "";
			    inputNameDlg_cross_dialogArguments[1] = add_onclick_Complete;
			    inputNameDlg_cross_dialogArguments[2] = DivPopUpHidden;
			    DivPopUpShow(330, 150, "/ezCircular/circularInputName.do");
			}
			
		    function add_onclick_Complete(szName) {
		        DivPopUpHidden();
		        if (typeof (szName) == "undefined" || szName.trim() == "") {
		            return;
		        }
		        else if (checkBadFolderName(szName)) {
		            return;
		        }
		        
		        var szURL = PostTreeView.getvalue(PostTreeView.selectedIndex(), "href");
		        var result = mail_make_folder("NEW", szURL, "", szName);
		        if (result != "OK") {
		            if (result == "ALREADY_EXISTS") {
		                alert("<spring:message code='ezEmail.t456' />");
		            } else {
		                alert("<spring:message code='ezEmail.t457' />");
		            }
		            return;
		        }
		        
		        var childxml = get_childXML(PostTreeView.getvalue(PostTreeView.selectedIndex(), "href"), false, false);
             	PostTreeView.putchildxml(PostTreeView.selectedIndex(), childxml);
             
		        EventCheck = true;
		     }
        </script>
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1 style="margin-bottom:0px;">회람문서함 관리</h1>
		<div id="close">
		  <ul>
		    <li><span onClick="window.close()">닫기</span></li>
		  </ul>
		</div>
		<div style="margin-bottom:5px;">
		    <a class="imgbtn"><span onClick="add_onclick()" style="text-align:center;">추가</span></a>
		    <a class="imgbtn"><span onClick="modify_onclick()" style="text-align:center;">수정</span></a>
		    <a class="imgbtn"><span onClick="delete_onclick()" style="text-align:center;">삭제</span></a>
		</div>
		<table class="popuplist" style="width:100%">
		  <tr>
		    <td>
		        <div style="height:400px;width:100%;overflow-x:auto;overflow-y:auto;background-color:#FFFFFF;padding-left:2px;padding-top:5px;" id="PostTreeView">
				</div>
		    </td>
		  </tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
		<div style="width:200px;height:50px;border:0px solid red;text-align:center;vertical-align:middle;display:none;z-index:9000;position:absolute;" id="MailProgress">
		    <img src="/images/email/progress_img.gif" style="vertical-align:middle;"/>
		</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
		    <iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>