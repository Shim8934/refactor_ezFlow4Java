/**
 * 레이어팝업 띄우기
 * @param el
 */
function journal_layer_popup(el) {

	var $el = $(el); // 레이어의 id를 $el 변수에 저장

	$('.journal-layer').fadeIn()

	var $elWidth = ~~($el.outerWidth()), 
		$elHeight = ~~($el.outerHeight()), 
		docWidth = $(document).width(), 
		docHeight = $(document).height();

	console.log("elWidth=" + $elWidth + ", elHeight=" + $elHeight + ", docWidth=" + docWidth + ", docHeight=" + docHeight);
	
	
	// 화면의 중앙에 레이어를 띄운다.
	if ($elHeight < docHeight || $elWidth < docWidth) {
		$el.css({
			marginTop : -$elHeight / 2,
			marginLeft : -$elWidth / 2
		})
	} else {
		$el.css({
			top : 0,
			left : 0
		});
	}

	$('.journal-layer').find('.journal-layerClose').click(function() {
		$('.journal-layer').hide(); // 닫기 버튼을 클릭하면 레이어가
		sumSearchOptionHidden();							// 닫힌다.
		return false;
	});

	$('.journal-layer .dimBg').click(function() {
		$('.journal-layer').hide();
		sumSearchOptionHidden();
		return false;
	});

}
