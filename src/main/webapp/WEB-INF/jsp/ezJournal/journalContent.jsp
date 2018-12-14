<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${util.addVer('/css/previewmail.css')}" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
<style type="text/css">
	p {
		margin-top: 0px;
		margin-bottom: 0px;
	}
</style>
<script type="text/javascript">
	function AttachDetail_view(obj) {
	    if (obj.className == "attach_btn_down") {
	        obj.className = "attach_btn_up";
	        document.getElementById("PreviewAttachList").style.display = "";
	    }
	    else {
	        obj.className = "attach_btn_down";
	        document.getElementById("PreviewAttachList").style.display = "none";
	    }
	}
	
	function AttachAllDownload() {
		var url = "/ezJournal/journalAllAttachDown.do";
		
		var $frm = $("<form enctype='multipart/form-data' accept-charset='UTF-8'></form>");
		
		$frm.attr('action', url);
		$frm.attr('method', 'post');
		$frm.appendTo('body');
		
		var filePathS = "";
		var fileNameS = "";
		
		$(".attachFileRow").each(function (index){
			if(index > 0){
				filePathS += "|";
				fileNameS += "|";
			}
			filePathS += $(this).attr("filePath");
			fileNameS += $(this).attr("fileName");
		});
		$frm.append('<input type="hidden" value="' + filePathS + '" name="filePathS" />');
		$frm.append('<input type="hidden" value="' + fileNameS + '" name="fileNameS" />');
		$frm.append('<input type="hidden" value="${journal.journalId}" name="journalId" />');
		$frm.append('<input type="hidden" value="${journal.journalTitle }" name="journalTitle" />');
		
		$frm.submit();
	}
</script>
</head>
<body>
	<c:if test="${fn:length(journal.fileList) gt '0' and journalType eq 'p'}">
			<div class="attachedfile" id="ifrmPreViewRayer" style="margin-bottom:10px;font-family:<spring:message code='main.t246' />">
				<ul class="attachedfile_title">
					<li class="titleText">
						<span class="titleT">
							<spring:message code='ezEmail.t99000003' />
							<span>
								<span class='cblue'>${fn:length(journal.fileList)}</span> (${journal.fileTotalSize })
							</span>
						</span>
						<span class="attach_btn_up" id="BtnAttachDetail" onclick="AttachDetail_view(this);">
						</span>
					</li>
		    		<li class="titleSave">
		    			<span onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style='cursor:pointer' onclick="AttachAllDownload();">
		    				<spring:message code='ezEmail.t99000004' />
		    			</span>
		    		</li>
		    	</ul>
				<ul class="attachedfile_list" id="PreviewAttachList" style="text-align: left;">
	            	<c:forEach items="${journal.fileList }" var="file">
			            <li class="attachFileRow" filePath="<c:out value='${file.filePath }'/>" fileName="<c:out value='${file.fileName}'/>">
			            	<a href="/ezJournal/journalAttachDown.do?filePath=${file.filePath }&fileName=${file.fileName}&journalId=${journal.journalId}">
				            	<span style="cursor:pointer;">
				            		<img src="/images/icon_adddownload.gif" width="16" height="16" style="vertical-align:middle">
				            	</span> 
				            </a>
				            <a href="/ezJournal/journalAttachDown.do?filePath=${file.filePath }&fileName=${file.fileEncodeName}&journalId=${journal.journalId}">
				            	<span>
				            		<span class="attachFileName" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='black'" style="cursor: pointer; color: black;">
				            			<c:out value='${file.fileName }'/>&nbsp;(${file.fileTransSize })
				            		</span>
				            	</span> 
				            </a>
			            </li>
			    	</c:forEach>
				</ul>
			</div>	        
		</c:if>
	<div style="text-align: left;">
		<img onclick="parent.Smaller();" style="cursor: pointer; margin: 5px;" src="/images/minus.png"> 
		<img onclick="parent.Bigger();" style="cursor: pointer; margin: 5px; margin-left: -9px;" src="/images/plus.png">
	</div>
	<div id="journalContent" class="txtContent" style="width: 100%; height: 10px; display: inline-block;">
		${journalContent }
	</div>
</body>
</html>