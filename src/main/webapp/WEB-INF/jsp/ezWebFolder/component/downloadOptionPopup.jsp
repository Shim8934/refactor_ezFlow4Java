<script>
function doLayerPopupDownloadOption(obj) {
	optionHidden();

	document.getElementById("noDownloadCheckbox").checked = false;

	var leftBody = parent.frames["left"].document.body;
	leftBody.style.overflow = "hidden";
	$("<div id='blockLeft' class='blockLeft' style='position: fixed;' onclick='parent.frames[\"right\"].downloadOptionHidden();'></div>").appendTo(leftBody);
	var popupX = parent.document.body.clientWidth / 2 - (400 / 2) - 220;

	$("#downloadOptionPopup").css("left", popupX);

	$("#downloadOptionPopup").modal();
	$("#downloadOptionPopup").off("modal:close").on("modal:close", function() {
		parent.frames["left"].document.body.style.overflow = "auto";
	});
}

function completeDownloadOptionConfirm() {
	uploadData.noDownloadChecked = document.getElementById("noDownloadCheckbox").checked;

	downloadOptionHidden();
	realUpload();
}

function downloadOptionHidden() {
	$.modal.close();
}
</script>
<div id="downloadOptionPopup" class="popupwrap3" style="display: none; margin-bottom: 70px; width: 400px;">
	<div class="popupJQLayer">
		<div class="title">
			<spring:message code='webfolder.downloadoption.confirm' />
		</div>
		<div id="close">
			<ul>
				<li><a rel="modal:close">
						<span onclick="downloadOptionHidden()"></span>
					</a></li>
			</ul>
		</div>
		<table class="content" style="margin-top: 10px; width: 100%; table-layout: fixed;">
			<tr>
				<th style="text-align: center; height: 60px;" colspan="2"><spring:message code='webfolder.downloadoption.content' /></th>
			</tr>
			<tr>
				<th style="text-align: center; width: 50%;"><spring:message code='webfolder.downloadoption.check' /></th>
				<td style="height: 100%; padding: 0;">
					<div style="position: relative; height: 30px;">
						<label style="display: block; top: 0; bottom: 0; right: 0; left: 0; position: absolute; text-align: center; vertical-align: middle;" for="noDownloadCheckbox"> <input id="noDownloadCheckbox" type="checkbox" style="height: 100%;" checked="">
						</label>
					</div>
				</td>
			</tr>
		</table>
		<table style="width: 100%">
			<tr>
				<td style="text-align: center;">
					<div class="btnpositionLayer">
						<a class="imgbtn">
							<span onClick="completeDownloadOptionConfirm()"><spring:message code="ezWebFolder.t116" /></span>
						</a>
					</div>
				</td>
			</tr>
		</table>
	</div>
</div>