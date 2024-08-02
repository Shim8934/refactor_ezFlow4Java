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

	/** 이전 value를 저장한다.
	 * @param {HTMLInputElement} element */
	function attachCaptureValue(element) {
		if (!element.attachedCaptureValue) {
			element.attachedCaptureValue = true;
			element.addEventListener("keydown", function() {
				captureValue(this);
			});
			captureValue(element);
		}
	}
	// input selection 저장
	function captureSelection(element) {
		element.previousSelection = {
			start: element.selectionStart,
			end: element.selectionEnd
		};
	}

	// input value 저장
	function captureValue(element) {
		element.previousValue = element.value;
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
		inputElement.addEventListener("keydown", function(/** @type {KeyboardEvent} */event) {
			if (!event.ctrlKey && !event.metaKey && event.key && event.key.length === 1 && regexp.test(event.key)) {
				event.stopPropagation();
				event.preventDefault();
			}
		});
	}

	/** input에서 특정 문자열을 입력 즉시 치환 하도록 만듦
	 * @param {HTMLInputElement} inputElement
	 * @param {RegExp} regexp
	 * @param {string} newChar */
	function makeReplaceTyping(inputElement, regexp, newChar) {
		inputElement.addEventListener("input", function() {
			if (regexp.test(this.value)) {
				const startPos = this.selectionStart;
				const endPos = this.selectionEnd;
				this.value = this.value.replace(regexp, newChar);
				this.setSelectionRange(startPos, endPos);
			}
		});
	}

	/** input에서 숫자(float)만을 입력받을 수 있게 하며 천 단위 표시되도록 만들어줌
	 * @param {HTMLInputElement} inputElement
	 * @param {NumberFormatOptions} options */
	function makeNumberTyping(inputElement, options) {
		// 포커스할 때 숫자만으로 세팅
		inputElement.addEventListener("focus", event => {
			const currentValue = event.currentTarget.value;
			const currentElement = event.currentTarget;
			setTimeout(() => {
				const selectionStart = currentElement.selectionStart;
				const textBeforeCursor = currentValue.substr(0, selectionStart);
				const pos = selectionStart - (textBeforeCursor.match(/,/g)?.length || 0);
				// 콤마 빼서 값 세팅
				currentElement.value = getFloatValue(currentValue);
				// 커서 위치 콤마 개수만큼 빼기
				currentElement.setSelectionRange(pos, pos);
			}, 0);
		});

		// 포커스 해제 시 천 단위 콤마 및 소숫점 옵션 처리
		inputElement.addEventListener("blur", event => {
			const number = getFloatValue(event.currentTarget.value);
			event.currentTarget.value = number.toLocaleString("en", options);
		});

		// 숫자, comma, dot 외 입력 금지
		makeNotAllowTyping(inputElement, /[^\d,.]/g);
	}

	/** 콤마로 표시된 문자열을 소수로 반환
	 * @param {string} text */
	function getFloatValue(text) {
		// 콤마 삭제 후 검증
		const withoutCommaText = text.replace(/,/g, '');

		if (isNaN(withoutCommaText)) {
			throw new Error(`${text} is not a number`);
		}

		// 값이 비어 있으면 0 리턴
		return withoutCommaText.trim() === "" ? 0 : parseFloat(withoutCommaText);
	}

	/** Enter 키 누를 시 콜백 호출
	 * @param {HTMLInputElement} inputElement
	 * @param {Function<KeyboardEvent>} func */
	function addOnEnterEvent(inputElement, func) {
		inputElement.addEventListener("keydown", event => {
			if (event.key === "Enter" && !event.repeat) {
				event.preventDefault();
				func(event);
			}
		});
	}

	return {
		makeNotAllowTyping: makeNotAllowTyping,
		makeReplaceTyping: makeReplaceTyping,
		makeNumberTyping: makeNumberTyping,
		addOnEnterEvent: addOnEnterEvent,
		getFloatValue: getFloatValue
	};
})();