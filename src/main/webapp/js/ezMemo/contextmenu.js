var content;
function copy() {
	selected = window.getSelection();
	content = selected.toString();
	var agent = navigator.userAgent.toLowerCase();
	
	if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
		content = content.replace(/\r\n\r\n/ig, '\n');
	} else { // 크롬 사파리 
		content = content.replace(/\n\n/ig, '\n');
	}
	
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

function copyToMemo(mode) {
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
			if(mode === "popup"){
				parent.opener.parent.parent.getMemoList();
			} else if (mode === "preview"){
				parent.parent.parent.parent.getMemoList();
			}
			
		}, error: function(err) {
			alert(strLangMemo3);
		}
	});		
}