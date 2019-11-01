/**
 * 전자결재 div_content HTML 공통 이벤트 
 */

function SelectOnchange() { 
	var options = event.target.options;
	var i, len;
	
	for (i = 0, len = options.length; i < len; i++) {
		if (options[i].selected) {
			options[i].setAttribute("selected", "selected");
		} else {
			options[i].removeAttribute("selected");
		}
	}
}
function CheckBoxOnclick() {
	var input = event.target;
	
	if(input.checked) {
		input.setAttribute("checked", "checked");
	} else {
		input.removeAttribute("checked");
	}
}
function CheckBoxOnDblclick() { // IE에서 더블클릭을 클릭으로 인식하는 이슈때문에 작성
	if(isIE()) {
		var input = event.target;
		
		if(input.checked) {
			input.removeAttribute("checked"); 
			input.checked = false;
		} else {
			input.setAttribute("checked", "checked"); 
			input.checked = true;
		}
	}
}
function RadioOnClick() {
	var radio = event.target;
	if(radio.name) {
		var radioObj = document.getElementsByName(radio.name);
		var i, len;
		
		for(i = 0, len = radioObj.length; i < len; i++) {
			if(radioObj[i].checked) {
				radioObj[i].setAttribute("checked", "checked");
			} else {
				radioObj[i].removeAttribute("checked");
			}
		}
	} else {
		radio.setAttribute("checked", "checked");
	}
}

function onInputTextarea() {
	var textarea = event.target;
	textarea.setAttribute("value", textarea.value);
	textarea.innerHTML = textarea.value;
	
	if (textarea.hasAttribute("auto-height")) {
		textarea.style.height = "0px";
		textarea.style.height = (10 + textarea.scrollHeight) + "px";
	}
}