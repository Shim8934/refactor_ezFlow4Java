var emailCheckContext = (function() {
	var checkEventListener = null;
	var saveSuccessEventListener = null;
	var isSimpleMessage = false;
	
	var autoCheckDelay = 700;
	var autoCheckTime = null;
	var autoCheckId = null;
	
	var checked = false;
	var isPermit = false;
	var emailInput = document.getElementById("email-input");
	var checkMsgDiv = document.getElementById("checkmsg");
	var submitButton = document.getElementById("email-submit")
	var checkButton = document.getElementById("email-check");
	
	var permit = {
		color: "#006be4",
		msg: emailCheckLang.permit,
		simpleMsg: emailCheckLang.simplePermit
	};
	
	var reject = {
		color: "#c0392b",
		msg: emailCheckLang.reject,
		simpleMsg: emailCheckLang.simpleReject
	}

	function captureSelection(element) {
		element.previousSelection = {
			start: element.selectionStart,
			end: element.selectionEnd
		};
	}
	
	function captureValue(element) {
		element.previousValue = element.value;
	}
	
	function autoCheck() {
		cancelAsyncTask();
		autoCheckTime = new Date().getTime();
		autoCheckId = setTimeout(function() {
			$.ajax({
				url: "/ezPersonal/checkEmailId.do",
				type: "POST",
				dataType: "text",
				data: {
					emailId: emailInput.value
				},
				success: (function(time) {
					return function(res) {
						if (!autoCheckTime || autoCheckTime != time) {
							return;
						}
						
						autoCheckId = null;
						checked = true;
						isPermit = res == "OK";
						checkMsgDiv.innerHTML = getStateMessage();
						checkMsgDiv.style.color = getStateColor();
						checkMsgDiv.style.opacity = 1;
						
						// call listener
						if (checkEventListener) {
							checkEventListener(isPermit);
						}
					};
				})(autoCheckTime),
				error: function(error) {}
			});
		}, autoCheckDelay);
	}
	
	function cancelAsyncTask() {
		if (autoCheckId) {
			window.clearTimeout(autoCheckId);
			autoCheckId = null;
		}
	}
	
	function clearCheck() {
		checked = false;
		checkMsgDiv.style.color = "";
		checkMsgDiv.style.opacity = 0;
	}
	
	function getStateMessage() {
		var stateObj = getStateObj();
		
		if (isSimpleMessage) {
			return stateObj.simpleMsg;
		}
		
		return stateObj.msg;
	}
	
	function getStateColor() {
		return getStateObj().color;
	}
	
	function getStateObj() {
		return isPermit ? permit : reject;
	}
	
	function submit(successCallback) {
		if (!checked) {
			alert(emailCheckLang.requireCheck);
			return;
		}
		
		if (!isPermit) {
			alert(emailCheckLang.rejectFromSubmit);
			return;
		}
		
		$.ajax({
			url: "/ezPersonal/saveUserEmail.do",
			type: "POST",
			dataType: "text",
			data: {
				emailId: emailInput.value
			},
			async: false,
			success: function(res) {
				if (res == "OK") {
					if (successCallback) {
						successCallback();
					} else {
						document.cookie = "loginId=; path=/; expires=" + new Date(0).toGMTString();
						location.pathname = "/";
					}
				} else if (res == "OTHERUSER") {
					alert(emailCheckLang.rejectFromPost);
				} else if (res == "INVALIDFORMAT") {
					alert(emailCheckLang.rejectInvalidFromPost)
				} else {
					alert(emailCheckLang.errorFromPost);
				}
			},
			error: function(error) {
				alert(emailCheckLang.errorFromPost);
			}
		});
	}
	
	if (emailInput) {
		emailInput.addEventListener("change", function() {});
		
		emailInput.addEventListener("keydown", function(event) {
			captureSelection(emailInput);
			captureValue(emailInput);
		});
		
		emailInput.addEventListener("input", function() {
			var val = emailInput.value.toLowerCase();
			
			if (/^[.]|[.]$|[^a-z0-9-_.]/.test(val)) {
				emailInput.value = emailInput.previousValue;
				emailInput.setSelectionRange(emailInput.previousSelection.start, emailInput.previousSelection.end);
				return;
			}
			
			captureSelection(emailInput);
			emailInput.value = val;
			emailInput.setAttribute("title", val);
			emailInput.setSelectionRange(emailInput.previousSelection.start, emailInput.previousSelection.end);
			
			if (val.trim() === "") {
				cancelAsyncTask();
				clearCheck();
				return;
			}
			
			autoCheck();
			clearCheck();
		});
	}
	
	if (checkButton) {
		checkButton.addEventListener("click", function() {
			if (emailInput.value.trim() === "") {
				alert(emailCheckLang.requireInput);
				return;
			}
			
			cancelAsyncTask();
			clearCheck();
			$.ajax({
				url: "/ezPersonal/checkEmailId.do",
				type: "POST",
				dataType: "text",
				data: {
					emailId: emailInput.value
				},
				async: false,
				success: function(res) {
					checked = true;
					isPermit = res == "OK";
					checkMsgDiv.innerHTML = getStateMessage();
					checkMsgDiv.style.color = getStateColor();
					setTimeout(function() {
						checkMsgDiv.style.opacity = 1;
					}, 200);
					
					// call listener
					if (checkEventListener) {
						checkEventListener(isPermit);
					}
				},
				error: function(error) {}
			});
		});
	}
	
	if (submitButton) {
		submitButton.addEventListener("click", function() {
			submit();
		});
	}
	
	return {
		setOnCheckEventListener: function(listener) {
			checkEventListener = listener;
		},
		useSimpleMessage: function() {
			isSimpleMessage = true;
		},
		submit: submit
	};
}());