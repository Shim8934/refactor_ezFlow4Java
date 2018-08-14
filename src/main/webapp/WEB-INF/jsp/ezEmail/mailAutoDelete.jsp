<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="egovframework.let.utl.fcc.service.CommonUtil" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>mail_autodelete</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/XmlHttpRequest.js")%>"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/mouseeffect.js")%>"></script>
		<script type="text/javascript" src="<spring:message code='ezEmail.e1' />"></script>
		<script type="text/javascript" src="<%=CommonUtil.addVer(application, "/js/ezEmail/js_cross/encode_component.js")%>"></script>
		<script  type="text/javascript">
		    document.onselectstart = function () { return false; };
		    window.onload = function () {
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
		            document.body.style.MozUserSelect = 'none';
		            document.body.style.WebkitUserSelect = 'none';
		            document.body.style.khtmlUserSelect = 'none';
		            document.body.style.oUserSelect = 'none';
		            document.body.style.UserSelect = 'none';
		        }
		    }
		    function delete_condition(seqno, path) {
		        if (!confirm("<spring:message code='ezEmail.t113' />"))
		            return;
		
		        window.location.href = "/ezEmail/mailAutoDeleteDelete.do?itemseq=" + encodeURIComponent(seqno) + "&folderPath=" + encodeURIComponent(path);
		    }

		    function add_condition() {
			var addedFolders = new Array();
			<c:forEach var="item" items="${list}">
				addedFolders.push("${item.path}"); 
			</c:forEach>
			    
			for (var i = 0; i < addedFolders.length; i++){

				if (document.getElementById("folderpath").lealfolderPath == addedFolders[i]) {
					alert("<spring:message code='ezQuestion.t18' />");
				    return;
				}
			        
			}
		 
		    if (document.getElementById("folderpath").value == "") {
		            alert("<spring:message code='ezEmail.t114' />");
		            return;
		        }
		        if (document.getElementById("expiretime").value == "") {
		            alert("<spring:message code='ezEmail.t115' />");
		            return;
		        }
		        if (parseInt(document.getElementById("expiretime").value) != document.getElementById("expiretime").value || parseInt(document.getElementById("expiretime").value) < 1) {
		            alert("<spring:message code='ezEmail.t116' />");
		            return;
		        }
		        if (document.getElementById("deleteunread").checked == true)
		            window.location.href = "/ezEmail/mailAutoDeleteAdd.do?path=" + encodeURIComponent(document.getElementById("folderpath").lealfolderPath) + "&expiretime=" + encodeURIComponent(document.getElementById("expiretime").value) + "&unread=1" + "&foldername=" + encodeURIComponent(document.getElementById("folderpath").value);
		        else
		            window.location.href = "/ezEmail/mailAutoDeleteAdd.do?path=" + encodeURIComponent(document.getElementById("folderpath").lealfolderPath) + "&expiretime=" + encodeURIComponent(document.getElementById("expiretime").value) + "&unread=0" + "&foldername=" + encodeURIComponent(document.getElementById("folderpath").value);
		    }
		    var mail_selectfolder_cross_dialogArguments = new Array();
		    function getFolder() {
		        mail_selectfolder_cross_dialogArguments[1] = getFolder_Complete;
		        var OpenWin = window.open("/ezEmail/mailSelectFolder.do", "mail_selectfolder_Cross", GetOpenWindowfeature(400, 355));
		        try { OpenWin.focus(); } catch (e) { }
		    }
		    function getFolder_Complete(mailBoxInfo) {
		        if (typeof (mailBoxInfo) == "undefined")
		            return;
				
		        if (mailBoxInfo["isFolderChanged"]) {
	        		try {
	        			parent.parent.frames["left"].mailbox_treeview_reload();
	        		} catch (e) {
	        		}
	        	}
		        
		        if (typeof (mailBoxInfo["name"]) == "undefined" || typeof (mailBoxInfo["url"]) == "undefined") {
		        	return;
		        }
		        
	        	document.getElementById("folderpath").value = mailBoxInfo["name"];
	        	document.getElementById("folderpath").lealfolderPath = mailBoxInfo["url"];
		    }
		</script>
	</head>
	<body style="margin-left:10px;margin-right:10px;"> 
		<form method="post"> 
		<br>
			<span>▒ <spring:message code='ezEmail.t118' /></span>
			<table class="content" style="width:750px;margin-top:5px;">
				<tr>
					<th><spring:message code='ezEmail.t119' /></th>
					<td>
						<div style="margin:1px 0px 0px 0px;">
							&nbsp;<input id="folderpath" lealfolderPath="" readonly="true" type="text" style="WIDTH:190px;margin:0px 1px 0px 0px;" name="text">&nbsp;<a class="imgbtn imgbck" style="height:22px"><span style="line-height:22px" onClick="getFolder()"><spring:message code='ezEmail.t120' /></span></a>
						</div>
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezEmail.t121' /></th>
					<td>
						&nbsp;<input id="expiretime" type="text" style="WIDTH:40px" name="text2" maxlength="5">
						<spring:message code='ezEmail.t122' />
					</td>
				</tr>
				<tr>
					<th><spring:message code='ezEmail.t123' /></th>
					<td><input id="deleteunread" type="checkbox" name="checkbox"></td>
				</tr>
			</table>
			<div style="width:750px;text-align:center;">
				<div class="btnpositionJsp">
					<a class="imgbtn" name="Submit" onClick="add_condition()"><span><spring:message code='ezEmail.t124' /></span></a>
				</div>	
			</div>
			<br>
			<table class="popuplist" style="width:750px;">
				<tr> 
				<th style="width:450px;" width="450px"><spring:message code='ezEmail.t125' /></th> 
				<th style="width:100px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code='ezEmail.t121' /></th> 
				<th style="width:120px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code='ezEmail.t123' /></th> 
				<th style="width:80px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;"><spring:message code='ezEmail.t95' /></th>  
				</tr> 
				
				<c:forEach var="item" items="${list}">
					<tr> 
						<td>&nbsp;&nbsp;${item.folderName}</td> 
						<td style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;">${item.expireTime} <spring:message code='ezEmail.t127' /></td> 
						<td style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;padding:0px;" ><input type="checkbox" disabled ${item.deleteUnread} name="checkbox2"></td> 
						<td style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;text-align:center;padding:0px;">
							<a class="imgbtn"><span onClick="delete_condition('${item.itemSeq}', '${item.path}')"><spring:message code='ezEmail.t95' /></span></a>
						</td>
					</tr>
				</c:forEach>
			</table>
		</form>
	</body>
</html>



