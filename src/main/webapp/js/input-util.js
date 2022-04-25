"use strict"
var inputUtil = (function() {

	function attachCaptureSelection(element) {
		if (!element.attachedCaptureSelection) {
			element.attachedCaptureSelection = true;
			element.addEventListener("keydown", function() {
				captureSelection(this);
			});
			captureSelection(element);
		}
	}

	// input selection 저장
	function captureSelection(element) {
		element.previousSelection = {
			start: element.selectionStart,
			end: element.selectionEnd
		};
	}

	function makeNotAllowTyping(inputElement, regexp) {
		attachCaptureSelection(inputElement);
		inputElement.addEventListener("input", function() {
			if (regexp.test(this.value)) {
				this.value = this.value.replace(regexp, '');
				this.setSelectionRange(this.previousSelection.start, this.previousSelection.end);
			}/* else {
				captureSelection(this);
			}*/
		});
		inputElement.addEventListener("keydown", function(event) {
			if (regexp.test(event.char)) {
				event.stopPropagation();
				event.preventDefault();
			}
		});
	}

	function makeReplaceTyping(inputElement, regexp, newChar) {
		inputElement.addEventListener("input", function() {
			if (regexp.test(this.value)) {
				var startPos = this.selectionStart;
				var endPos = this.selectionEnd;
				this.value = this.value.replace(regexp, newChar);
				this.setSelectionRange(startPos, endPos);
			}
		});
	}

	return {
		makeNotAllowTyping: makeNotAllowTyping,
		makeReplaceTyping: makeReplaceTyping
	};
})();