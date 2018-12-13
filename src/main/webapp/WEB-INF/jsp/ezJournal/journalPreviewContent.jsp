<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
	    <style type="text/css">
	    	.attachedfile {
			    margin: 0;
			}
	    </style>
	    <script type="text/javascript">
	        var nowZoom = 100;
	        var maxZoom = 200;
	        var minZoom = 80;
	        
	        function Bigger() {
                if (nowZoom < maxZoom) {
                    nowZoom += 10;
                } else {
                    return;
                }
                $('.journalPreviewContentIframe').contents().find('.txtContent').css("zoom",nowZoom + "%");
	        }
	
	        function Smaller() {
                if (nowZoom > minZoom) {
                    nowZoom -= 10;
                } else {
                    return;
                }
                $('.journalPreviewContentIframe').contents().find('.txtContent').css("zoom",nowZoom + "%");
	        }
	        
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
		    	
		    	$("#Preview_Content"+pPreviewShow_HOW+" .attachFileRow").each(function (index){
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
		<div class="previewmail">
			<div class="previewmail_info" style="border: none; display: block; width: 100%;">
				<dl class="previewmailDL" id="Preview_HeaderH">
					<dt class="prepic">
						<c:choose>
							<c:when test="${not empty journal.userImage }">
								<img src="/admin/ezOrgan/getPersonalInfo.do?fileName=${journal.userImage }" width="55px" height="55px">
							</c:when>
							<c:otherwise>
								<img src="/images/kr/main/bestEmployee_pic_none.png" width="55px" height="55px">
							</c:otherwise>
						</c:choose>
					</dt>
					<dd class="pretext">
						<ul class="pretextUL">
							<li class="preSubject"><span class="popup_open" id="${journal.journalId}" onclick="goJournalDetail(this);"><img src="/images/kr/cm/btn_newpopup.gif" alt="<spring:message code="ezEmail.t99000001" />"></span><span class="subjectText" id="PreH_subject"><span class="subjectText" id="PreH_sub_subject" title="<c:out value='${journal.journalTitle }'/>"><c:out value='${journal.journalTitle }' /></span></span></li>
							<li class="preT_list"><span class="t_left"><span class="cblack"><spring:message code="ezJournal.t34" /></span> : <span id="PreH_MailReceiver" onmouseover="this.style.color='#164aad'" onmouseout="this.style.color='#666'" style="cursor:pointer" onclick="OpenUserInfo('${journal.writerId}');"><c:out value='${journal.writerName }'/></span></span><span class="t_right"><span class="cblack"><spring:message code="ezJournal.t35" /> : </span><span id="PreH_date"><c:out value='${fn:substring(journal.journalDate, 0, 16) }'/></span></span></li>
							
						</ul>
					</dd>
				</dl>
	        </div>
		</div>
		<c:if test="${fn:length(journal.fileList) gt '0'}">
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
		<iframe src="" class="journalPreviewContentIframe" style="text-align:center; padding:0; width:100%; height:100%; overflow:auto; border:none;"></iframe>
	</body>
</html>