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
		
		// child가 null로 잡힌 영역을 원 selection 영역으로 넣어줌
		if(content === "") {
			content = sel.toString();
		}
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
	
	// 글자 작게, 크게  selection 되는 부분 잘라내기
	var searchTerm = 'P {MARGIN-TOP: 0mm; MARGIN-BOTTOM: 0mm}';
	var indexOfFirst = content.indexOf(searchTerm);
	if(indexOfFirst>-1) {
		var startIndex = indexOfFirst + 40;
		content = content.substring(startIndex);
	}
	
	// 폰트 스타일 주석 삭제
	var pattern = /<!--([\s\S]+)-->/;
	content = content.replace(pattern, "").trim();
} 
 
/**
 * 컨텍스트메뉴 클립보드 복사
 */
function copyToClip() { 
	if(content === "") { 
		alert(strLangMemo1); 
		return; 
	} 
	var tempTextArea = document.createElement('textarea'); 
	tempTextArea.value = content;
	tempTextArea.setAttribute('readonly', '');                // Make it readonly to be tamper-proof
	tempTextArea.style.position = 'absolute';                 
	tempTextArea.style.left = '-9999px';  
	tempTextArea.style.top = mouseTop;  
	document.body.appendChild(tempTextArea); 
	
	const selected =            
	document.getSelection().rangeCount > 0        // Check if there is any content selected previously
	      ? document.getSelection().getRangeAt(0)     // Store selection if found
	      : false;                              
	tempTextArea.select(); 
	document.execCommand('copy', false, null); 
	document.body.removeChild(tempTextArea); 
	alert(strLangMemo19);
} 
 

/**
 * 컨텍스트메뉴 메모 추가
 */
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

/**
 * 컨텍스트메뉴 인쇄
 */
function btnPrint() {
    var pheight = window.screen.availHeight;
    var conHeight = pheight * 0.8;
    var pwidth = window.screen.availWidth;
    var conWidth = pwidth * 0.8;
    if (conWidth > 890)
        conWidth = 890;
    var pTop = (pheight - conHeight) / 2;
    var pLeft = (pwidth - 890) / 2;

    window.open("/ezEmail/mailPrint.do?URL=" + encodeURIComponent(g_paramURL), "", "top=" + pTop.toString() + ", left=" + pLeft.toString() + ", height = " + conHeight + "px, width = " + conWidth + "px, status = no, toolbar=no, menubar=no,location=no,resizable=1, scrollbars=1");
}