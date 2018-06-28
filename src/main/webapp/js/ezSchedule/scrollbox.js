/**
 * CSS ScrollBox
 *
 * @author hooriza (Ajax UI team)
 */
var Scrollbox = Class({
	
	_initialized : false,
	_objects : null,
	_timer : null,
	_options : null,

	_draging : null,
	
	__init : function() {},
	
	touch : function(wrap, oOptions) {
		
		if (this._initialized) {
			this._resetBoxSize();
			return;
		}
		
		var oWrap = $B(wrap);
		if (!oWrap) return;
		
		this._initialized = true;
		
		this._options = JINDO.extend({
			overflowX : "auto",
			overflowY : "auto",
			minThumb : [ 0, 0 ],
			trackSize : [ 0, 0 ]
		}, oOptions || {});
			
		this._objects = { 'wrap' : oWrap };
		
		for (var oObj = Element.firstChild(this._objects.wrap); oObj; oObj = Element.nextSibling(oObj)) {
			if (Element.hasClass(oObj, 'content')) this._objects.content = oObj;
			if (Element.hasClass(oObj, 'scrollbar-v')) this._objects.sbarv = oObj;
			if (Element.hasClass(oObj, 'scrollbar-h')) this._objects.sbarh = oObj;
		}
		
		var oObjects = this._objects;
		var oTmp;
		
		oObjects.contentBody = oObjects.content.firstChild;
		for (; oObjects.contentBody.nodeType != 1; oObjects.contentBody = oObjects.contentBody.nextSibling);
		
		oObjects.contentBody.style.position = "relative";
		oObjects.content.style.overflow = "hidden";
		
		if (oTmp = oObjects.sbarv) { // 수직 스크롤바가 있으면
			
			var aObjs = oObjects.sbarv.all || oObjects.sbarv.getElementsByTagName("*");
			for (var i = 0, oObj; oObj = aObjs[i]; i++) {
				if (Element.hasClass(oObj, 'button-up')) this._objects.bup = oObj;
				if (Element.hasClass(oObj, 'thumb-v')) this._objects.thumbv = oObj;
				if (Element.hasClass(oObj, 'thumb-head')) this._objects.thumbvH = oObj;
				if (Element.hasClass(oObj, 'thumb-body')) this._objects.thumbvB = oObj;
				if (Element.hasClass(oObj, 'thumb-foot')) this._objects.thumbvF = oObj;
				if (Element.hasClass(oObj, 'button-down')) this._objects.bdn = oObj;
			}
			
		}
		
		if (oTmp = oObjects.sbarh) { // 수평 스크롤바가 있으면
			
			var aObjs = oObjects.sbarh.all || oObjects.sbarh.getElementsByTagName("*");
			for (var i = 0, oObj; oObj = aObjs[i]; i++) {
				if (Element.hasClass(oObj, 'button-left')) this._objects.blt = oObj;
				if (Element.hasClass(oObj, 'thumb-h')) this._objects.thumbh = oObj;
				if (Element.hasClass(oObj, 'thumb-head')) this._objects.thumbhH = oObj;
				if (Element.hasClass(oObj, 'thumb-body')) this._objects.thumbhB = oObj;
				if (Element.hasClass(oObj, 'thumb-foot')) this._objects.thumbhF = oObj;
				if (Element.hasClass(oObj, 'button-right')) this._objects.bgt = oObj;
			}
			
		}
		
		if (oObjects.thumbhB) this._options.minThumb[0] = parseInt(Element.getCSS(oObjects.thumbhB, "width")) || 0;
		if (oObjects.thumbvB) this._options.minThumb[1] = parseInt(Element.getCSS(oObjects.thumbvB, "height")) || 0;
		
		if (oObjects.sbarv) this._options.trackSize[0] = parseInt(Element.getCSS(oObjects.sbarv, "width")) || 0;
		if (oObjects.sbarh) this._options.trackSize[1] = parseInt(Element.getCSS(oObjects.sbarh, "height")) || 0;

		this._resetBoxSize();
		
		this._draging = [ null, null ];
		this._bindEvents();
		
		var oAgent = $Agent();
		var nPx;
		
		if (oObjects.bdn) {
			
			nPx = parseInt(Element.getCSS(oObjects.sbarv, "marginBottom")) || 0;
			if (!oAgent.IE) nPx += parseInt(Element.getCSS(oObjects.sbarv, "marginTop")) || 0;
			
			oObjects.bdn.style.bottom = nPx + "px";
			
		}
		
		if (oObjects.bgt) {
			
			nPx = parseInt(Element.getCSS(oObjects.sbarh, "marginRight")) || 0;
			if (!oAgent.IE) nPx += parseInt(Element.getCSS(oObjects.sbarh, "marginLeft")) || 0;
			
			oObjects.bgt.style.right = nPx + "px";
			
		}
		
		if (oAgent.IE6 || oAgent.IE55) { // IE6 이하 버그
			
			var nBothVisiblePx = oObjects.sbarv && Element.visible(oObjects.sbarv) && oObjects.sbarh && Element.visible(oObjects.sbarh) ? 1 : 0
			
			if (oObjects.sbarv && oObjects.bdn) oObjects.bdn.style.bottom = (parseInt(oObjects.bdn.currentStyle.bottom) || 0) - nBothVisiblePx + "px";
			if (oObjects.sbarh && oObjects.bgt) oObjects.bgt.style.right = (parseInt(oObjects.bgt.currentStyle.right) || 0) - nBothVisiblePx + "px";
			
		}
		
		if (oObjects.sbarv) oObjects.sbarv.style.visibility = "visible";
		if (oObjects.sbarh) oObjects.sbarh.style.visibility = "visible";
	},
	
	_tempValues : null,
	
	start : function(oOptions) {
		
	    var sRnd = "SB" + parseInt(Math.random((new Date).getMilliseconds()) * 1000000);

		this._tempValues = [ sRnd, JINDO.extend({}, oOptions || {}) ];
		
		var sCode = 
			'<div class="scrollbox" id="' + sRnd + '" style="width:' + oOptions.width + 'px; height:' + oOptions.height + 'px; overflow:hidden;">' +
				'<div class="content">';
				
		document.write(sCode);

	},
	
	end : function() {
		
		var sRnd = this._tempValues[0];
		var oOptions = this._tempValues[1];
		
		var sCode = '</div>';
				
		if (oOptions.overflowY != "hidden") {
			
			sCode +=
				'<div class="scrollbar-v">' +
					'<img src="' + oOptions.blankImage + '" class="button-up">' +
					'<div class="thumb-v">' +
						'<img src="' + oOptions.blankImage + '" class="thumb-head"><img src="' + oOptions.blankImage + '" class="thumb-body"><img src="' + oOptions.blankImage + '" class="thumb-foot">' +
					'</div>' +
					'<img src="' + oOptions.blankImage + '" class="button-down">' +
				'</div>';
			
		} else {

			oOptions.overflowY = "auto";

		}			
		
		if (oOptions.overflowX != "hidden") {
			
			sCode +=
				'<div class="scrollbar-h">' +
					'<img src="' + oOptions.blankImage + '" class="button-left">' +
					'<div class="thumb-h">' +
						'<img src="' + oOptions.blankImage + '" class="thumb-head"><img src="' + oOptions.blankImage + '" class="thumb-body"><img src="' + oOptions.blankImage + '" class="thumb-foot">' +
					'</div>' +
					'<img src="' + oOptions.blankImage + '" class="button-right">' +
				'</div>';
				
		} else {

			oOptions.overflowX = "auto";

		}		
	
		sCode += '</div>';
			
		document.write(sCode);
		
		this.touch(sRnd, oOptions);
		
	},
	
	visible : function() {
		return Element.visible(this._objects.wrap);
	},
	
	getObject : function() {
		return this._objects.wrap;
	},
	
	_getContent : function() {
		return this._objects.content.getElementsByTagName("UL")[0];
	},

	show : function(bFlag) {
		
		var sMethod = bFlag ? "show" : (bFlag === undefined ? "toggle" : "hide");
		Element[sMethod](this._objects.wrap);
		
		if (this.visible()) this.touch();
		
	},
	
	_getScrollBoxInnerSize : function() {
		
		var oObjects = this._objects;
		
		oObjects.wrap.style.overflow = "hidden"; // IE6 less 버그
		
		var aScrollBoxSize = [
			oObjects.wrap.offsetWidth || parseInt(Element.getCSS(oObjects.wrap, "width")) || 0,
			oObjects.wrap.offsetHeight || parseInt(Element.getCSS(oObjects.wrap, "height")) || 0
		];
		
		// alert(aScrollBoxSize);

		aScrollBoxSize[0] -= parseInt(Element.getCSS(oObjects.wrap, "borderLeftWidth")) || 0;
		aScrollBoxSize[0] -= parseInt(Element.getCSS(oObjects.wrap, "borderRightWidth")) || 0;
		
		aScrollBoxSize[1] -= parseInt(Element.getCSS(oObjects.wrap, "borderLeftWidth")) || 0;
		aScrollBoxSize[1] -= parseInt(Element.getCSS(oObjects.wrap, "borderRightWidth")) || 0;
		
		return aScrollBoxSize;
		
	},
	
	_resetBoxSize : function() {

		var oObjects = this._objects;
		var aScrollBoxSize = this._getScrollBoxInnerSize();
		
		var aTrackSize = this._options.trackSize;
		
		var aContentSize = [
			aScrollBoxSize[0] - aTrackSize[0],
			aScrollBoxSize[1] - aTrackSize[1]
		];
		
		Element.setCSS(oObjects.content, {
			width : aContentSize[0] + "px",
			height : aContentSize[1] + "px"
		});
		
		if (oObjects.sbarh) oObjects.sbarh.style.width = aContentSize[0] + "px";
		if (oObjects.sbarv) oObjects.sbarv.style.height = aContentSize[1] + "px";
		
		this._resetThumbPos();
	},

	_setTimer : function(func, interval) {
		this._clearTimer();
		this._timer = window.setInterval(func.owner(this), interval);
	},
	
	_clearTimer : function() {
		if (this._timer) window.clearInterval(this._timer);
		this._timer = null;
	},
	
	_showHThumb : function(bFlag) {
		
		var oObjects = this._objects;
		Element[bFlag ? "show" : "hide"](oObjects.thumbh);	
		Scrollbox[bFlag ? "_removeClass" : "_addClass"](oObjects.sbarh, "scrollbar-h-disabled");
	},
	
	_showVThumb : function(bFlag) {
		
		var oObjects = this._objects;
		Element[bFlag ? "show" : "hide"](oObjects.thumbv);
		Scrollbox[bFlag ? "_removeClass" : "_addClass"](oObjects.sbarv, "scrollbar-v-disabled");
	},
	
	_showHScrollbar : function(bFlag) {
		
		var oObjects = this._objects;
		if (!oObjects.sbarh) return;
		var aScrollBoxSize = this._getScrollBoxInnerSize();
	
		if (bFlag) {
			
			// 수평 스크롤바 보여주고
			Element.show(oObjects.sbarh);

			var sBarSize = oObjects.sbarh.offsetHeight;
			
			// 보여준만큼 본문영역 줄이고
			oObjects.content.style.height = aScrollBoxSize[1] - sBarSize + "px";
			oObjects.content.style.marginBottom = sBarSize + "px";
			
			// 수직 스크롤바 길이도 줄임
			if (oObjects.sbarv) oObjects.sbarv.style.height = aScrollBoxSize[1] - sBarSize + "px";

		} else {
			
			// 수평 스크롤바 숨기고
			Element.hide(oObjects.sbarh);

			// 숨긴만큼 본문영역 늘리고
			oObjects.content.style.height = aScrollBoxSize[1] + "px";
			oObjects.content.style.marginBottom = "0px";

			// 수직 스크롤바 길이도 늘임
	 		if (oObjects.sbarv) oObjects.sbarv.style.height = aScrollBoxSize[1] + "px";

		}

	},
	
	_showVScrollbar : function(bFlag) {
		
		var oObjects = this._objects;
		if (!oObjects.sbarv) return;

		var aScrollBoxSize = this._getScrollBoxInnerSize();
	
		if (bFlag) {
			
			// 수직 스크롤바 보여주고
			Element.show(oObjects.sbarv);

			var sBarSize = oObjects.sbarv.offsetWidth;

			// 보여준만큼 본문영역 줄이고
			oObjects.content.style.width = aScrollBoxSize[0] - sBarSize + "px";
			oObjects.content.style.marginRight = sBarSize + "px";
			
			// 수평 스크롤바 길이도 줄임
			if (oObjects.sbarh) oObjects.sbarh.style.width = aScrollBoxSize[0] - sBarSize + "px";

		} else {
			
			// 수직 스크롤바 숨기고			
			Element.hide(oObjects.sbarv);

			// 숨긴만큼 본문영역 늘리고
			oObjects.content.style.width = aScrollBoxSize[0] + "px";
			oObjects.content.style.marginRight = "0px";
			
			// 수평 스크롤바 길이도 늘임
			if (oObjects.sbarh) oObjects.sbarh.style.width = aScrollBoxSize[0] + "px";
			
		}
		
	},
	
	_setThumbLeft : function(nPx) {
		
		var oObjects = this._objects;
		if (!oObjects.sbarh) return;

		var aLimit = [ 0, this._getHTrackSize() - oObjects.thumbh.offsetWidth ];
		
		if (nPx < aLimit[0]) nPx = aLimit[0];
		if (nPx > aLimit[1]) nPx = aLimit[1];
		
		if (!isNaN(nPx)) oObjects.thumbh.style.left = oObjects.blt.offsetWidth + nPx + "px";
		
		return nPx;
		
	},

	_setThumbTop : function(nPx) {
		
		var oObjects = this._objects;
		if (!oObjects.sbarv) return;

		var aLimit = [ 0, this._getVTrackSize() - oObjects.thumbv.offsetHeight ];
		
		if (nPx < aLimit[0]) nPx = aLimit[0];
		if (nPx > aLimit[1]) nPx = aLimit[1];
		
		if (!isNaN(nPx)) oObjects.thumbv.style.top = this._getButtonSize("bup") + nPx + "px";
		
		return nPx;
		
	},

	getScrollSize : function() {

		var oObjects = this._objects;
		
		return [
			oObjects.contentBody.offsetWidth, 
			oObjects.contentBody.offsetHeight
		];

	},
	
	getClientSize : function() {
		
		var oObjects = this._objects;
		var aSize = [
			oObjects.content.offsetWidth,
			oObjects.content.offsetHeight
		];
		
		//if (oObjects.sbarv) aSize[0] -= oObjects.sbarv.offsetWidth;
		//if (oObjects.sbarh) aSize[1] -= oObjects.sbarh.offsetHeight;
		
		return aSize;
		
	},
	
	_getHTrackSize : function() {
		var oObjects = this._objects;
		if (!oObjects.sbarh) return;
		
		var size = oObjects.sbarh.offsetWidth;
		size -= this._getButtonSize("blt");
		size -= this._getButtonSize("bgt");
		
		size -= parseInt(Element.getCSS(oObjects.sbarh, "marginLeft")) || 0;
		size -= parseInt(Element.getCSS(oObjects.sbarh, "marginRight")) || 0;
		
		return size;
	},
	
	_getVTrackSize : function() {
		var oObjects = this._objects;
		if (!oObjects.sbarv) return;

		var size = oObjects.sbarv.offsetHeight;
		size -= this._getButtonSize("bup");
		size -= this._getButtonSize("bdn");
		
		size -= parseInt(Element.getCSS(oObjects.sbarv, "marginTop")) || 0;
		size -= parseInt(Element.getCSS(oObjects.sbarv, "marginBottom")) || 0;
		
		return size;
	},
	
	setScrollRelativePos : function(nX, nY, bNoResetFlag) {
	
		var aScrollPos = this.getScrollPos();
		this.setScrollPos(aScrollPos[0] + nX, aScrollPos[1] + nY, bNoResetFlag);

		var aNowScrollPos = this.getScrollPos();

		// 실제로 스크롤 된게 있으면 true 리턴
		return (aScrollPos[0] != aNowScrollPos[0] || aScrollPos[1] != aNowScrollPos[1]);
	
	},
	
	setScrollPos : function(nX, nY, bNoResetFlag) {
		this.setScrollLeft(nX);
		this.setScrollTop(nY, bNoResetFlag);
	},
	
	setScrollLeft : function(nX, bNoResetFlag) {

		var limit = [ 0, this.getScrollSize()[0] - this.getClientSize()[0] ];
		if (limit[1] < 0) limit[1] = 0;
		
		if (nX < limit[0]) nX = limit[0];
		if (nX > limit[1]) nX = limit[1];

		this._objects.contentBody.style.left = -nX + "px";
		if (!bNoResetFlag) this._resetThumbPos();
	},
	
	setScrollTop : function(nY, bNoResetFlag) {

		var limit = [ 0, this.getScrollSize()[1] - this.getClientSize()[1] ];
		if (limit[1] < 0) limit[1] = 0;
		
		if (nY < limit[0]) nY = limit[0];
		if (nY > limit[1]) nY = limit[1];

		this._objects.contentBody.style.top = -nY + "px";
		if (!bNoResetFlag) this._resetThumbPos();
	},
	
	getScrollPos : function() {
	
		return [
			-parseInt(Element.getCSS(this._objects.contentBody, "left")) || 0,
			-parseInt(Element.getCSS(this._objects.contentBody, "top")) || 0
		];
		
	},
	
	_resetThumbSize : function() {
		
		var oObjects = this._objects;
		if (!oObjects.thumbhH && !oObjects.thumbvH) return;
		
		var aScrollSize = this.getScrollSize();
		var aClientSize = this.getClientSize();
		
		var aThumbSize = [
			(this._getHTrackSize() * aClientSize[0]) / aScrollSize[0],
			(this._getVTrackSize() * aClientSize[1]) / aScrollSize[1]
		];
		
		if (oObjects.thumbhH) {
			aThumbSize[0] -= oObjects.thumbhH.offsetWidth + oObjects.thumbhF.offsetWidth;
			if (aThumbSize[0] < this._options.minThumb[0]) aThumbSize[0] = this._options.minThumb[0];
			try { oObjects.thumbhB.style.width = (aThumbSize[0] || 0) + "px"; } catch(e) {}
		}

		if (oObjects.thumbvH) {
			aThumbSize[1] -= oObjects.thumbvH.offsetHeight + oObjects.thumbvF.offsetHeight;
			if (aThumbSize[1] < this._options.minThumb[1]) aThumbSize[1] = this._options.minThumb[1];
			try { oObjects.thumbvB.style.height = (aThumbSize[1] || 0) + "px"; } catch(e) {}
		}

	},
	
	// 스크롤 위치를 기준으로 Thumb 의 위치를 반영시키기
	_resetThumbPos : function(bSkipH, bSkipV) {
		
		if (bSkipH && bSkipV) return;
		this._resetThumbSize();
		
		var oObjects = this._objects;

		var aThumbSize = [ oObjects.thumbh && oObjects.thumbh.offsetWidth, oObjects.thumbv && oObjects.thumbv.offsetHeight ];
		var aTrackSize = [ this._getHTrackSize(), this._getVTrackSize() ];

		//window.console.debug("aThumbSize : " + aThumbSize);
		//window.console.debug("aTrackSize : " + aTrackSize);
		
		var aScrollSize = this.getScrollSize();
		var aClientSize = this.getClientSize();
		
		//window.console.debug("aScrollSize : " + aScrollSize);
		//window.console.debug("aClientSize : " + aClientSize);
		
		// (nTrackSize - nThumbSize) : nThumbPos = (nScrollSize - nClientSize) : nScrollPos
		var aScrollPos = this.getScrollPos();
		
		if (!bSkipH) {
			this["_showH" + (this._options.overflowX == "auto" ? "Scrollbar" : "Thumb")](aScrollSize[0] > aClientSize[0]);
			this._resetThumbPos(true, bSkipV);
		} else if (!bSkipV) {

			//window.console.debug("overflowY : " + this._options.overflowY + "/" + (aScrollSize[1] > aClientSize[1]));

			this["_showV" + (this._options.overflowY == "auto" ? "Scrollbar" : "Thumb")](aScrollSize[1] > aClientSize[1]);
			this._resetThumbPos(bSkipH, true);
		}
		
		var aThumbPos = [
			(aTrackSize[0] - aThumbSize[0]) * aScrollPos[0] / (aScrollSize[0] - aClientSize[0]) || 0,
			(aTrackSize[1] - aThumbSize[1]) * aScrollPos[1] / (aScrollSize[1] - aClientSize[1]) || 0
		];
		
		this._setThumbLeft(aThumbPos[0]);
		this._setThumbTop(aThumbPos[1]);
		
	},
	
	// Thumb 의 위치를 기준으로 스크롤 위치 반영시키기
	_resetHScrollPos : function() {
		
		var oObjects = this._objects;

		var nThumbSize = oObjects.thumbh.offsetWidth;
		var nTrackSize = this._getHTrackSize();
		
		var nScrollSize = this.getScrollSize()[0];
		var nClientSize = this.getClientSize()[0];
		
		var nThumbPos = (parseInt(Element.getCSS(oObjects.thumbh, "left")) || 0) - this._getButtonSize("blt");
		
		// (nTrackSize - nThumbSize) : nThumbPos = (nScrollSize - nClientSize) : nScrollPos
		var nScrollPos = (nScrollSize - nClientSize) * nThumbPos / (nTrackSize - nThumbSize) || 0;
		
		this.setScrollLeft(nScrollPos);
	},
	
	// Thumb 의 위치를 기준으로 스크롤 위치 반영시키기
	_resetVScrollPos : function() {
		
		var oObjects = this._objects;

		var nThumbSize = oObjects.thumbv.offsetHeight;
		var nTrackSize = this._getVTrackSize();
		
		var nScrollSize = this.getScrollSize()[1];
		var nClientSize = this.getClientSize()[1];
		
		var nThumbPos = (parseInt(Element.getCSS(oObjects.thumbv, "top")) || 0) - this._getButtonSize("bup");
		
		// (nTrackSize - nThumbSize) : nThumbPos = (nScrollSize - nClientSize) : nScrollPos
		var nScrollPos = (nScrollSize - nClientSize) * nThumbPos / (nTrackSize - nThumbSize) || 0;
		
		this.setScrollTop(nScrollPos);
	},

	_bindButtonEvent : function(oObj, sPrefix, bOnlyOverDownFlag) {
		
		Event.register(oObj, "mouseover", function(oEvent, oObj) {

			var oObjects = this._objects;

			switch (sPrefix) {
			case "button-up":
			case "button-down":
				if (Element.hasClass(oObjects.sbarv, "scrollbar-v-disabled")) return;
				break;
				
			case "button-left":
			case "button-right":
				if (Element.hasClass(oObjects.sbarh, "scrollbar-h-disabled")) return;
				break;
			}

			if ($Agent().IE && (oEvent.of(this) || !Element.has(oObj, oEvent.element))) return;
			Scrollbox._addClass(oObj, sPrefix + "-over");
			
		}.bindForEvent(this, oObj));

		if (bOnlyOverDownFlag) return;

		Event.register(oObj, "mousedown", function(oObj) {
		
			var aBy = null;
			var oObjects = this._objects;

			switch (sPrefix) {
			case "button-up":
				if (Element.hasClass(oObjects.sbarv, "scrollbar-v-disabled")) return;
				aBy = [ 0, -20 ];
				break;
				
			case "button-down":
				if (Element.hasClass(oObjects.sbarv, "scrollbar-v-disabled")) return;
				aBy = [ 0, 20 ];
				break;
				
			case "button-left":
				if (Element.hasClass(oObjects.sbarh, "scrollbar-h-disabled")) return;
				aBy = [ -20, 0 ];
				break;
				
			case "button-right":
				if (Element.hasClass(oObjects.sbarh, "scrollbar-h-disabled")) return;
				aBy = [ 20, 0 ];
				break;
			}
				
			Scrollbox._addClass(oObj, sPrefix + "-down");
			
			this._setTimer(function() { this.setScrollRelativePos(aBy[0], aBy[1], true); }, 100);
			this.setScrollRelativePos(aBy[0], aBy[1]);
			
		}.bind(this, oObj));

		Event.register(oObj, "mouseout", function(oEvent, oObj) {
			if ($Agent().IE && oEvent.of(oObj)) return;
			Scrollbox._removeClass(oObj, sPrefix + "-over", sPrefix + "-down");
			this._clearTimer();
		}.bindForEvent(this, oObj));
		
		Event.register(oObj, "mouseup", function(oObj) {
			Scrollbox._removeClass(oObj, sPrefix + "-down");
			this._clearTimer();
		}.bind(this, oObj));
		
	},
	
	_bindOverDownEvents : function() {
		
		var oObjects = this._objects;
		
		if (oObjects.sbarh) {
			if (oObjects.blt) this._bindButtonEvent(oObjects.blt, "button-left"); // 좌로 버튼
			if (oObjects.bgt) this._bindButtonEvent(oObjects.bgt, "button-right"); // 우로 버튼
			this._bindButtonEvent(oObjects.thumbh, "thumb-h", true); // 수평 스크롤 Thumb
		}

		if (oObjects.sbarv) {
			if (oObjects.bup) this._bindButtonEvent(oObjects.bup, "button-up"); // 위로 버튼
			if (oObjects.bdn) this._bindButtonEvent(oObjects.bdn, "button-down"); // 아래로 버튼
			this._bindButtonEvent(oObjects.thumbv, "thumb-v", true); // 수직 스크롤 Thumb
		}

	},
	
	_bindEvents : function() {
	
		var oObjects = this._objects;
		
		this._bindOverDownEvents();
		this._bindDragEvents();
		
		// Rolling Wheel
		Event.register(oObjects.wrap, "mousewheel", function(oEvent) {

			var bScrolled = false;
			
			if (oObjects.sbarv)
				bScrolled = this.setScrollRelativePos(0, oEvent.delta * -10);
			else
				bScrolled = this.setScrollRelativePos(oEvent.delta * -10, 0);
				
			if (bScrolled) oEvent.stop();
		}.bindForEvent(this));

		// Vertical Track Event
		Event.register(oObjects.sbarv, "mousedown", function(oEvent) {

			var oObjects = this._objects;
			if (oEvent.of(oObjects.thumbv) || oEvent.of(oObjects.bup) ||oEvent.of(oObjects.bdn)) return;

			var nHeight = oObjects.thumbv.offsetHeight;

			var nTop = oEvent.layer_y - parseInt(nHeight / 2);
			var nBtm = nTop + nHeight;

			if (nBtm > this._getVTrackSize()) nTop -= nBtm - (this._getVTrackSize());
			if (nTop < 0) nTop = 0;

			this._setThumbTop(nTop);

			this._draging[1] = oEvent.page_y - parseInt(oObjects.thumbv.style.top) + this._getButtonSize("bup");
			Scrollbox._addClass(oObjects.thumbv, "thumb-v-down");

			this._resetVScrollPos();

			oEvent.stop();

		}.bindForEvent(this));
		
	},
	
	_getButtonSize : function(type) {
		
		var oButton = this._objects[type];
		if (!oButton) return 0;
		
		switch (type) {
		case "bup":
		case "bdn":
			return oButton.offsetHeight;
		
		case "blt":
		case "bgt":
			return oButton.offsetWidth;
		}
		
	},
	
	_bindDragEvents : function() {

		var oObjects = this._objects;
		
		if (oObjects.sbarh) {
		
			// Horizonal Thumb Drag Start
			Event.register(oObjects.thumbh, "mousedown", function(oEvent) {
				this._draging[0] = oEvent.page_x - parseInt(oObjects.thumbh.style.left) + this._getButtonSize("blt");
				Scrollbox._addClass(oObjects.thumbh, "thumb-h-down");
				oEvent.stop();
			}.bindForEvent(this));
	
			Event.register(oObjects.thumbh, "mouseout", function(oEvent) {
				if ($Agent().IE && oEvent.of(oObjects.thumbh)) return;
				Scrollbox._removeClass(oObjects.thumbh, "thumb-h-over");
			}.bindForEvent(this));
			
		}
		
		if (oObjects.sbarv) {
		
			// Vertical Thumb Drag Start
			Event.register(oObjects.thumbv, "mousedown", function(oEvent) {
				this._draging[1] = oEvent.page_y - parseInt(oObjects.thumbv.style.top) + this._getButtonSize("bup");
				Scrollbox._addClass(oObjects.thumbv, "thumb-v-down");
				oEvent.stop();
			}.bindForEvent(this));
			
			Event.register(oObjects.thumbv, "mouseout", function(oEvent) {
				if ($Agent().IE && oEvent.of(oObjects.thumbv)) return;
				Scrollbox._removeClass(oObjects.thumbv, "thumb-v-over");
			}.bindForEvent(this));
			
		}
		
		///////
		Event.register(document, "mousemove", function(oEvent) {
			
			if (this._draging[0] === null && this._draging[1] === null) return;
			
			var aScrollSize = this.getScrollSize();
			var aClientSize = this.getClientSize();
			var aTrackSize = [ this._getHTrackSize(), this._getVTrackSize() ];
			var aThumbSize = [ oObjects.sbarh && oObjects.thumbh.offsetWidth, oObjects.sbarv && oObjects.thumbv.offsetHeight ];

			if (this._draging[0] !== null) {
			
				this._setThumbLeft(oEvent.page_x - this._draging[0]);
				this._resetHScrollPos();
				
			} else if (this._draging[1] !== null) {
				
				this._setThumbTop(oEvent.page_y - this._draging[1]);
				this._resetVScrollPos();
				
			}
			
			oEvent.stop();
			
		}.bindForEvent(this));

		// Thumb Drag End
		Event.register(document, "mouseup", function() {

			if (this._draging[0]) Scrollbox._removeClass(oObjects.thumbh, "thumb-h-down");
			if (this._draging[1]) Scrollbox._removeClass(oObjects.thumbv, "thumb-v-down");
			
			this._draging = [ null, null ];
		}.bind(this));

	}

});

Scrollbox._addClass = function(obj, className) {
	Element.addClass(obj, className);
};

Scrollbox._removeClass = function(obj /* classNames */) {
	
	for (var i = 1, len = arguments.length; i < len; i++)
		if (Element.hasClass(obj, arguments[i]))
			return Element.removeClass.apply(Element, arguments);
};
