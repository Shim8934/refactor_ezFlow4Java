/**
 * @file ①Browser engine or ②JavaScript or ③jQuery 재정의를 위한 file
 *
 * @author 솔루션1팀 김은실
 * @Date 2024-12-09
 */

/**
 * [이슈] 메일쓰기> sortable> helper 시 width를 반올림해서 문제 발생. 실수 반환 필요.
 * 		jQuery 1.x, 2.x: width() → 반올림된 정수 반환.
 * 		jQuery 3.x: width() → 실수 반환.
 * : jQuery 에서의 호출 관계 : width() → css() → (1.9.1) e.offsetWidth | (3.6.4) e.getBoundingClientRect().width
 *   offsetWidth을 → getBoundingClientRect().width 으로 변경하여 사이드이펙트를 최소화하고자 하였습니다.
 *
 * 만약, offsetWidth 재정의가 안먹힐시 아래 주석도 시도해보세요.
 * (function($) {
 * 		// 기존 width 메서드 백업
 * 		var originalWidth = $.fn.width;
 *
 * 		// width 메서드 재정의
 * 		$.fn.width = function(value) {
 * 			if (value === undefined) {
 * 				var width = window.getComputedStyle(this.get(0)).width;
 * 				console.debug("width: %s", width); // 개발자도구에서 Default levels → Vervose 변경하면 확인 가능.
 *
 * 				return parseFloat(width);
 * 			} else {
 * 				// 기존 메서드를 호출하여 값 설정
 * 				return originalWidth.call(this, value);
 * 			}
 * 		};
 * })(jQuery);
 */
/**
 * DOM 요소의 offsetWidth를 감싸는 프로퍼티 재정의
 * : offsetWidth 프로퍼티는 브라우저가 DOM 요소에 대해 계산한 너비 값으로, 자바스크립트 코드에서 직접 구현된 게 아닌 브라우저 엔진(예: Blink, Gecko, WebKit)에 내장된 속성입니다.
 */
Object.defineProperty(HTMLElement.prototype, 'offsetWidth', {
    get: function() {
        return this.getBoundingClientRect().width;
    }
});
