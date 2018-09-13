var content;
function copy() {
	selected = window.getSelection();
	content = selected.toString();
}

function copyToClip() {
	if(content === "") {
		alert(strLangMemo1);
		return;
	}
	var tempTextArea = document.createElement('textarea');
	tempTextArea.value = content;
	document.body.appendChild(tempTextArea);
	tempTextArea.select();
	document.execCommand('copy');
	document.body.removeChild(tempTextArea);
}

function copyToMemo() {
	if(content === "") {
		alert(strLangMemo1);
		return;
	}

	$.ajax({
		type : "POST",
		dataType : "json",
		async : false,
		url : "/ezMemo/otherModuleCopy.do",
		data : {
			"contents" : content
		}, success: function() {
			alert(strLangMemo2);
			parent.opener.parent.parent.getMemoList();
		}, error: function(err) {
			alert(strLangMemo3);
		}
	});		
}