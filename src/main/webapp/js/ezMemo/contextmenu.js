var content; 
function copy() { 
	var doc = window.document;
	var sel = window.getSelection();
	var agent = navigator.userAgent.toLowerCase(); 
	 
	if (sel.anchorNode.parentNode.id  !== "msgBody") { 
		var childrenArray; 
		var html = ""; 
		if (sel.rangeCount) { 
	        
			var container = doc.createElement("div"); 
			container.appendChild(sel.getRangeAt(i).cloneContents()); 
	        
			childrenArray = [].slice.call(container.children);
	        var len = childrenArray.length
	       
	        for(var i = 0; i < len; i++) { 
	        	if(childrenArray[i].innerText === "" || childrenArray[i].id === "ContentClassbtn" 
	        		|| childrenArray[i].id === "ifrmPreViewRayer" || childrenArray[i].id === "MailBigAttachRayer") {
	        		continue;
	        	}
	        	html += childrenArray[i].innerText + "\n"; 
	        } 
	    } 
		content = html; 
	} else { 
		content = sel.toString(); 
	} 
	 
	// 익스플로어
	if ((navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) { 
		content = content.replace(/\r\n\r\n/ig, '\n');
		if(sel.anchorNode.parentNode.id === "msgBody") {
			var html = ""; 
			var childrenArray; 
			var container = doc.createElement("div"); 
			container.appendChild(sel.getRangeAt(i).cloneContents()); 
			
			content = container.innerText; 
		}
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
	document.execCommand('copy', false, null); 
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