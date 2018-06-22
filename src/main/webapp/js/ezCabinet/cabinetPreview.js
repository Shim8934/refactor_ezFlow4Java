//Baonk 2018-06-22

var CabinetPreview = function () {
	return function(generalInf) {
		//Set private variables
		var _percentInf   = generalInf["percent"];
		var _previewHId   = generalInf["prevDivH"];
		var _previewWId   = generalInf["prevDivW"];
		var _mainDivId    = generalInf["tableId"];
		var _wrapperDivId = generalInf["wraperId"];
		var _prevCntH     = generalInf["preContentH"];
		var _prevCntW     = generalInf["preContentW"];
		
		function setResizeableByHeight() {
			$('#' + _mainDivId).resizable({
				handles: 's',
				minHeight: getHeight("min"),
				maxHeight: getHeight("max"),
				resize: addPanel,
				stop: closePanel
			});
		}
		
		function setResizeableByWidth() {
			$('#' + _mainDivId).resizable({
				handles: 'e',
				minWidth: getWidth("min"),
				maxWidth: getWidth("max"),
				resize: addPanel,
				stop: closePanel
			});
		}
		
		function setDestroyResizeable() {
			$('#' + _mainDivId).resizable("destroy");
		}
		
		function getWidth(mode) {
			var result;
			var wraperDiv   = document.getElementById(_wrapperDivId);
			var parentWidth = wraperDiv.offsetWidth;
			
			switch (mode) {
				case "min": result = parentWidth * _percentInf["minWidth"]; break;
				case "max": result = parentWidth * _percentInf["maxWidth"]; break;
				default   : result = parentWidth * _percentInf["minWidth"];
			}
			
			return result / 100;
		}
		
		function getHeight(mode) {
			var result;
			var wraperDiv    = document.getElementById(_wrapperDivId);
			var parentHeight = wraperDiv.offsetHeight;
			
			switch (mode) {
				case "min": result = parentHeight * _percentInf["minHeight"]; break;
				case "max": result = parentHeight * _percentInf["maxHeight"]; break;
				default   : result = parentHeight * _percentInf["minHeight"];
			}
			
			return result / 100;
		}
		
		function addPanel(event, ui) {
			var previewHElmt   = document.getElementById(_previewHId);
			var prevContentId  = previewHElmt.style.display != 'none' ? _prevCntH : _prevCntW;
			var preContentElmt = document.getElementById(prevContentId);
			
			if (preContentElmt.lastElementChild.id != "fogPanel") {
				var fogPanel       = document.createElement("div");
				fogPanel.className = "cabPanel";
				fogPanel.id        = "fogPanel";
				preContentElmt.appendChild(fogPanel);
			}
		}
		
		function closePanel(event, ui) {
			var fogPanel = document.getElementById("fogPanel");
			if (fogPanel) {fogPanel.parentElement.removeChild(fogPanel);}
		}
		
		return {
			resizeByHeight : setResizeableByHeight,
			resizeByWidth  : setResizeableByWidth,
			resizeDestroy  : setDestroyResizeable
		};
	}
}();