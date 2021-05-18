<div id="contextMenuDiv" style="position: absolute; z-index: 6000; display: none;">
	<table cellpadding="2" cellspacing="1" border="0" class="popuplist">
		<tbody>
			<c:if test="${usePreview}">
				<tr id="previewMenu">
					<td onclick="buttons.filePreview();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
						<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/icon_preview.png" align="absmiddle" hspace="5"> <spring:message code='main.t4009' /></span>
					</td>
				</tr>
			</c:if>
			<tr id="moveMenu">
				<td onclick="buttons.fileMoveAndCopy();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
					<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/move.gif" align="absmiddle" hspace="5"> <spring:message code='ezWebFolder.t251' /></span>
				</td>
			</tr>
			<tr>
				<td onclick="favoriteContext.toggleAll();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
					<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/icon-flag.gif" align="absmiddle" hspace="5"> <spring:message code='ezWebFolder.t216' /></span>
				</td>
			</tr>
			<c:if test="${useVersionHistory}">
				<tr>
					<td onclick="buttons.openFileVersionHistory();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
						<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/options.gif" align="absmiddle" hspace="5"> <spring:message code='webfolder.version.button' /></span>
					</td>
				</tr>
			</c:if>
			<%-- <tr>
					<td onclick="buttons.openReply();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
						<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/rul-sml.png" align="absmiddle" hspace="5"><spring:message code='webfolder.reply.title' /></span>
					</td>
				</tr> --%>
			<tr>
				<td onclick="refreshView();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
					<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/recur.gif" align="absmiddle" hspace="5"> <spring:message code='ezWebFolder.t139' /></span>
				</td>
			</tr>
			<tr id="folderManagerTR" style="display: none;">
				<td onclick="getUsersPage_manager();" onmouseover="javascript:this.style.backgroundColor='#f4f5f5'" onmouseout="javascript:this.style.backgroundColor='#ffffff'" style="cursor: pointer; background-color: rgb(255, 255, 255);">
					<span style="font-size: 12px; width: 100%; display: inline-block;"><img src="/images/ImgIcon/options.gif" align="absmiddle" hspace="5"> <spring:message code='ezWebFolder.kes013' /></span>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<script>
	(function() {
		var dragDropAreaElement = document.getElementById("dragDropArea");

		if (dragDropAreaElement) {
			dragDropAreaElement.addEventListener("scroll", hideContextMenuDelay);
		}

		document.body.addEventListener("click", hideContextMenuDelay, true);
	})();

	function openContextMenu(event) {
		if (document.getElementById("contextMenuDiv").style.display == "") {
			hideContextMenu();
		}

		if (!event) {
			event = window.event;
		}

		event.stopPropagation();
		event.preventDefault();
		contextClickedTr = event.currentTarget;

		var isFavoritePage = window.context && context.isFavoriteMode();
		var isCompanyFolder = isFavoritePage ? contextClickedTr.getAttribute("folderType") === "C" : folderType === "C";
		var targetFolderId = contextClickedTr.getAttribute("targetid");
		var targetDepth = contextClickedTr.getAttribute("depth");

		if (!(Number(targetDepth) > 1) && (window.checkIsManager && checkIsManager(targetFolderId) || contextClickedTr.getAttribute("targetcreater") == userId) && isCompanyFolder) {
			document.getElementById("folderManagerTR").style.display = "";
		} else {
			document.getElementById("folderManagerTR").style.display = "none";
		}

		<c:if test="${usePreview}">
		document.getElementById("previewMenu").style.display = rowContext.getRowInfo(contextClickedTr).type == "F" ? "" : "none";
		</c:if>

		var eventMouseX = event.clientX;
		var eventMouseY = event.clientY;

		var listsizeheight = document.documentElement.clientHeight;
		var listsizewidth = document.documentElement.clientWidth;

		var target = event.target ? event.target : event.srcElement;
		var targetTag = target.tagName;
		var eventDivSize = eventMouseY + $("#contextMenuDiv").height() + 70;

		if (listsizeheight < eventDivSize) {
			eventMouseY -= eventDivSize - listsizeheight;
		}

		eventDivSize = eventMouseX + 140;

		if (listsizewidth < eventDivSize) {
			eventMouseX -= eventDivSize - listsizewidth;
		}

		document.getElementById("contextMenuDiv").style.left = eventMouseX + "px";
		document.getElementById("contextMenuDiv").style.top = eventMouseY + "px";
		document.getElementById("contextMenuDiv").style.display = "";
	}

	function hideContextMenu() {
		document.getElementById("contextMenuDiv").style.display = "none";

		if (window.contextClickedTr) {
			contextClickedTr = null;
		}
	}

	function hideContextMenuDelay() {
		setTimeout(hideContextMenu, 0);
	}
</script>