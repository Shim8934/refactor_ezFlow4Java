/*
	Selectbox Group Component
	@author hooriza
*/
var autoHide = {
	
	_objects : [],
	
	_childOf : function(el, wraps) {
		
		var wraps = $A(wraps);
		
		for (; el; el = el.parentNode)
			if (wraps.indexOf(el) > -1) return true;
			
		return false;
	},
	
	_onDocumentDown : function(e) {
		
		var objects = autoHide._objects;
		
		var areas, panels;
		var el = e.element;
		
		for (var i = 0, object; object = objects[i]; i++) {
			
			areas = object.areas;
			panels = object.panels;
			
			var oareas = [];
			
			for (var j = 0, area; area = areas[j]; j++)
			oareas.push($B(area));
			
			if (!autoHide._childOf(el, oareas)) {
				
				if (typeof panels == "function") {
					panels();
				} else {
					
					for (var j = 0, panel; panel = panels[j]; j++) {
						if ($B(panel)) Element.hide($B(panel));
					}

				}
					
			}
			
		}

	},
	
	addRule : function(areas, panels) {

		var rule = {
			'areas' : areas,
			'panels' : panels
		};
		
		autoHide._objects.push(rule);
		
	}
	
};

Event.register(document, "mousedown", autoHide._onDocumentDown.bindForEvent());

/**
 * CSS Selectbox Group Component
 *
 * @author hooriza (Ajax UI team)
 */
var Pulldown = Class({
	
	_type : "pulldown",
	_initialized : false,
	
	_objects : null,
	
	_highlighted : null,
	_selected : null,

	_options : null,

	__init : function() {},
	
	touch : function(wrap, oOptions) {
		
		if (this._initialized) {
			this.setDisable(this.getDisable());
			return;
		}
		
		this._options = JINDO.extend(this._options || {}, oOptions);

		var oWrap = $B(wrap);
		if (!oWrap) return;
		
		this._objects = {
			'wrap' : oWrap,
			'box' : $$B(".box", oWrap)[0],
			'button' : $$B(".button", oWrap)[0],
			'label' : $$B(".label", oWrap)[0],
			'list' : $$B(".list", oWrap)[0]
		};
		
		var oObjects = this._objects;

		if (Element.hasClass(oObjects.list, "scrollbox")) { // 리스트가 스크롤박스면
			
			var oListObject = oObjects.list;
			
			oObjects.list = new Scrollbox();
			oObjects.list.touch(oListObject, {});

		} else {
		
			this._bindListMethod();
		
		}

		oObjects.listwrap = oObjects.list._objects ? oObjects.list._objects.wrap : oObjects.list;
		this._margin = parseInt(Element.getCSS(oObjects.listwrap, "marginTop")) || 0;

		// bind Event		
		this._bindPulldownEvents();
		
		autoHide.addRule([ oObjects.box, oObjects.list.getObject() ], function() {
			this._showListRaw(false);
		}.owner(this));

		this.showList(oObjects.list.visible());
		
		this._initialized = true;
		
		this.setDisable(this.getDisable());
		
	},
	
	_bindListMethod : function() {
		
		var oList = this._objects.list;
		
		JINDO.extend(oList, {
			visible : function() {
				return Element.visible(this);	
			},
			
			getObject : function() {
				return this;
			},
			
			_getContent : function() {
				return this;
			},

			getScrollPos : function() {
				return [ this.scrollLeft, this.scrollTop ];
			},
			
			getClientSize : function() {
				return [ this.clientWidth, this.clientHeight ];
			},
			
			setScrollTop : function(nPx) {
				this.scrollTop = nPx;
			},
			
			setScrollLeft : function(nPx) {
				this.scrollLeft = nPx;
			},
			
			touch : function() {}
			
		});
		
	},
	
	setLabelHTML : function(sHtml, bHideList) {
		this._objects.label.innerHTML = sHtml;
		if (bHideList) this.showList(false);
	},
	
	_getItemByIndex : function(nIndex) {
		return this._objects.list._getContent().getElementsByTagName("li")[nIndex];
	},
	
	getDisable : function() {
		return Element.hasClass(this._objects.wrap, "sb-disabled");
	},
	
	setDisable : function(bFlag) {
		
		var oObjects = this._objects;

		if (bFlag === undefined) bFlag = !this.getDisable();
		
		var sMethod = bFlag ? "addClass" : "removeClass";
		Element[sMethod](oObjects.wrap, "sb-disabled");
		
		// oObjects.box.disabled = bFlag;
		
		if (bFlag) this._showListRaw(false);
		return bFlag;
		
	},
	
	_showListRaw : function(bFlag) {
		sMethod = bFlag ? "addClass" : "removeClass";
		Element[sMethod](this._objects.wrap, "sb-expanded");
		
		if (typeof this._objects.list.show == "function") {
			this._objects.list.show(bFlag);
		}
	},
	
	showList : function(bFlag) {
		
		var oObjects = this._objects;
		var sMethod;
		
		if (bFlag == undefined) bFlag = !Element.hasClass(oObjects.wrap, "sb-expanded");
		this._showListRaw(bFlag);

		if (bFlag) {

			var oListObj = oObjects.list.getObject();

			oListObj.style.height = "auto";
			if (oObjects.list._objects && oObjects.list._objects.content)
				oObjects.list._objects.content.style.height = "auto";

			if (this._options.height && oListObj.offsetHeight > this._options.height)
				oListObj.style.height = this._options.height + "px";

			oObjects.list.touch();

			if (oObjects.list._objects && oObjects.list._objects.sbarv && $Agent().IE) { // IE6 bug
				oObjects.list._objects.sbarv.style.position = "relative";
				oObjects.list._objects.sbarv.style.position = "absolute";
			}

			var bReverse = false;
			
			var nListHeight = oObjects.listwrap.offsetHeight + this._margin;
	
			var nScrRange = [ document.documentElement.scrollTop || document.body.scrollTop ];
			nScrRange[1] = nScrRange[0] + (window.innerHeight || document.documentElement.clientHeight || document.body.clientHeight);
			
			var nWrapRange = [ Element.realPos(oObjects.wrap).top ];
			nWrapRange[1] = nWrapRange[0] + oObjects.wrap.offsetHeight;
			
			bReverse = (nWrapRange[1] + nListHeight > nScrRange[1] && nWrapRange[0] - nListHeight > nScrRange[0]);
			oObjects.listwrap.style.marginTop = (bReverse ? -(nListHeight + oObjects.wrap.offsetHeight) : oObjects.listwrap.style.marginTop = this._margin) + "px";
			
			this._highlightItem(this._selected);
		}
		
		this._focus();

		return bFlag;
		
	},
	
	_bindPulldownEvents : function() {
		
		var oObjects = this._objects;
		
		Event.register(oObjects.box, "mousedown", function(oEvent) {
			if (this.getDisable()) return;
			if (this._textbox && oEvent.of(this._textbox)) return;	
			Element.addClass(this._objects.box, "box-down");
		}.bindForEvent(this));

		Event.register(oObjects.box, "mouseup", function(oEvent) {
			Element.removeClass(this._objects.box, "box-down");
		}.bindForEvent(this));

		Event.register(oObjects.box, "mouseover", function(oEvent) {
			if (this.getDisable()) return;
			if (oEvent.of(oObjects.box)) return;
			Element.addClass(this._objects.box, "box-over");
		}.bindForEvent(this));

		Event.register(oObjects.box, "mouseout", function(oEvent) {
			if (oEvent.of(this._objects.box)) return;
			Element.removeClass(this._objects.box, "box-over", "box-down");
		}.bindForEvent(this));
		
		//
		
		Event.register(oObjects.box, "click", function(oEvent) {
			
			if (this.getDisable()) return;
			if (this._textbox && oEvent.of(this._textbox)) return;	
			var bFlag = this.showList();
			
		}.bindForEvent(this));

		Event.register(oObjects.list._getContent(), "click", function() {
			
			if (this.getDisable()) return;
			if (this._type != "pulldown") return;
			
			var bFlag = this.showList();
			this._selected = this._highlighted;
			
		}.owner(this));

		Event.register(oObjects.list._getContent(), "mouseover", function(oEvent) {

			var oLi = this._findLi(oEvent.element, this._objects.list._getContent());
			if (oLi) this._highlightItem(oLi);
			
		}.bindForEvent(this));

		Event.register(oObjects.box, $Agent().IE ? "keydown" : "keypress", function(oEvent) {
			
			if (this.getDisable()) return;

			var oNext = null;

			if (!this._highlighted) oNext = this._getItemByIndex(0);
			
			switch (oEvent.keyCode) {
			case 38: // up
				if (!oNext)
					for (oNext = this._highlighted.previousSibling; oNext && oNext.nodeType != 1; oNext = oNext.previousSibling);
					
				if (oNext) this._highlightItem(oNext);
				break;
				
			case 40: // down
				if (!oNext)
					for (oNext = this._highlighted.nextSibling; oNext && oNext.nodeType != 1; oNext = oNext.nextSibling);
					
				if (oNext) this._highlightItem(oNext);
				break;
			
			case 13: // enter
				var bFlag = Element.hasClass(oObjects.wrap, "sb-expanded");

				if (bFlag && this._highlighted) {
					
					this._selected = this._highlighted;
					
					if (typeof this._selected.onclick == "function")
						this._selected.onclick();
					
				}
				
				this.showList();

				break;
				
			default:
				return;
			}
			
			oEvent.stop();
			
		}.bindForEvent(this));

	},

	_findLi : function(oLi, oUl) {
		for (; oLi && (oLi.nodeType != 1 || oLi.tagName.toUpperCase() != "LI"); oLi = oLi.parentNode);
		return oLi;
	},
		
	
	_highlightItem : function(oLi) {
		
		var oObjects = this._objects;
		
		if (this._highlighted) {
			Element.removeClass(this._highlighted, "item-selected");
			this._highlighted = null;
		}
			
		if (!oLi) return;
			
		Element.addClass(oLi, "item-selected");
		this._highlighted = oLi;
		
		this._showHighlightedItem();

	},
	
	_showHighlightedItem : function() {
		
		var oObjects = this._objects;
		
		var oLi = this._highlighted;
		if (!oLi) return;
		
		var aListScrollPos = oObjects.list.getScrollPos();
		var aListClientSize = oObjects.list.getClientSize();
		
		var itemrange = [ oLi.offsetTop, oLi.offsetTop + oLi.offsetHeight ];
		var listrange = [ aListScrollPos[1], aListScrollPos[1] + aListClientSize[1] ];
		
		if (itemrange[0] < listrange[0])
			oObjects.list.setScrollTop(itemrange[0]);
			
		if (itemrange[1] > listrange[1])
			oObjects.list.setScrollTop(itemrange[1] - aListClientSize[1]);
	},
	
	_focus : function() {
		try {
			this._objects.box.focus();
		} catch(e) { }
	}
	
});

var Selectbox = Class.extend(Pulldown, {
	
	_type : "selectbox",
	_related : null,
	_oldvalue : null,
	
	touch : function(oWrap, oRelated, oOptions) {
		
		if (this._initialized) {
			this.setDisable(this.getDisable());
			this._resetList();
			return;
		}
		
		this._related = $B(oRelated);
		this._oldvalue = this._related.value;
		this._options = JINDO.extend(this._options || {}, oOptions);

		Pulldown.prototype.touch.call(this, oWrap, oOptions);
		
		this._bindSelectboxEvents();
		this._resetList();
		
	},
	
	transform : function(oRelated, oOptions) {
		
		if (oRelated = $B(oRelated)) {
			
			oOptions = oOptions || {};
			
			Element.hide(oRelated);
			
			var sStyle = "";
			if (oOptions.width) sStyle += "width:" + oOptions.width + "px;";

			var sCode = 
				'<a href="#" onclick="return false;" class="box" style="' + sStyle + '">' +
					'<div class="button">&nbsp;</div>' +
					'<div class="label">&nbsp;</div>' +
				'</a>';
				
			if (oOptions.height) sStyle += "height:" + oOptions.height + "px;";

			if (oOptions.cssScrollBox && typeof Scrollbox != "undefined") {
				
				sCode +=
				'<div class="list scrollbox" id="scrbox" style="' + sStyle + 'overflow:hidden;">' +
					'<div class="content">' +
						'<ul style="margin:0; padding:0; item-style:none; position:relative;"></ul>' +
					'</div>' +
					'<div class="scrollbar-v">' +
						'<img src="' + oOptions.cssScrollBox.blankImage + '" class="button-up">' +
						'<div class="thumb-v">' +
							'<img src="' + oOptions.cssScrollBox.blankImage + '" class="thumb-head"><img src="' + oOptions.cssScrollBox.blankImage + '" class="thumb-body"><img src="' + oOptions.cssScrollBox.blankImage + '" class="thumb-foot">' +
						'</div>' +
						'<img src="' + oOptions.cssScrollBox.blankImage + '" class="button-down">' +
					'</div>' +
					'<div class="scrollbar-h">' +
						'<img src="' + oOptions.cssScrollBox.blankImage + '" class="button-left">' +
						'<div class="thumb-h">' +
							'<img src="' + oOptions.cssScrollBox.blankImage + '" class="thumb-head"><img src="' + oOptions.cssScrollBox.blankImage + '" class="thumb-body"><img src="' + oOptions.cssScrollBox.blankImage + '" class="thumb-foot">' +
						'</div>' +
						'<img src="' + oOptions.cssScrollBox.blankImage + '" class="button-right">' +
					'</div>' +
				'</div>';
				
			} else {
				
				sCode += '<ul class="list" style="' + sStyle + '"></ul>';
				
			}
				
			var oWrap = $C("div");
			oWrap.className = "selectbox";
			oWrap.innerHTML = sCode;
			
			oRelated.parentNode.insertBefore(oWrap, oRelated);
			
			this.touch(oWrap, oRelated, oOptions);
			
		}
		
	},

	getDisable : function() {
		
		return (
			// Element.hasClass(this._objects.wrap, "sb-disabled") ||
			this._related.disabled
		);
	},
	
	setDisable : function(bFlag) {
		
		var bFlag = Pulldown.prototype.setDisable.apply(this, arguments);
		this._related.disabled = bFlag;
		
		return bFlag;
		
	},
	
	showList : function(bFlag) {
		
		var bFlag = Pulldown.prototype.showList.apply(this, arguments);
		if (bFlag) this._resetList();
		
		return bFlag;
	},
	
	setLabelHTML : null,

	_resetList : function() {
		
		var oObjects = this._objects;
		var aOptions = this._related.options;
		var sCode = "", sHtml = "";

		for (var i = this._options.skipFirstItem ? 1 : 0, oOption; oOption = aOptions[i]; i++) {
			sHtml = oOption.innerHTML.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">");
			sCode += '<li nodeIndex="' + i + '">' + sHtml + '</li>';
		}
		
		oObjects.list._getContent().innerHTML = sCode;
		oObjects.list.touch();
		
		this._resetLabel();
		this._resetSelectedIndex();
	},
	
	_getText : function(nIndex) {
		
		if (nIndex === undefined) nIndex = this._related.selectedIndex;
		
		var oOption = this._related.options[nIndex];
		return oOption.innerHTML.replace(/&amp;/g, "&").replace(/&lt;/g, "<").replace(/&gt;/g, ">");
		
	},
	
	_getValue : function(nIndex) {
		
		if (nIndex === undefined) nIndex = this._related.selectedIndex;
		
		return this._related.options[nIndex].value;
		
	},
	
	_resetLabel : function(bHideList) {
	
		Pulldown.prototype.setLabelHTML.call(this, this._getText(), bHideList);

	},
	
	_resetSelectedIndex : function() {
		
		var nIndex = this._related.selectedIndex;
		this._highlightItem(this._getItemByIndex(nIndex));
		
	},
	
	_selectItem : function(oLi) {

		if (!oLi) return;
			
		var nIndex = oLi.getAttribute("nodeIndex");
		this._related.selectedIndex = nIndex;
		
		this._highlightItem(oLi);
		this._resetLabel(true);
		
		;
		
		if (typeof this._related.onchange == "function" && this._oldvalue != this._related.value) {
			this._related.onchange.call(this._related);
			this._oldvalue = this._related.value;
		}
		
		this._focus();
		
	},
	
	_bindSelectboxEvents : function() {
		
		var oObjects = this._objects;
		
		Event.register(oObjects.list._getContent(), "click", function(oEvent) {
			
			if (this.getDisable()) return;

			var oLi = this._findLi(oEvent.element, this._objects.list);
			this._selectItem(oLi);
			
		}.bindForEvent(this));

		Event.register(oObjects.box, $Agent().IE ? "keydown" : "keypress", function(oEvent) {
			
			switch (oEvent.keyCode) {
			case 38: // up
				this._selectItem(this._highlighted.previousSibling);
				break;
				
			case 40: // down
				this._selectItem(this._highlighted.nextSibling);
				break;
				
			default:
				return;
			}
			
			oEvent.stop();
			
		}.bindForEvent(this));
		
	}
	
	
});

Selectbox.setInnerHTML = function(oEl, sHtml) {
	
	if ($Agent().IE && oEl.tagName == "SELECT") {
		
		var oDummy = $C("div");
		oDummy.innerHTML = "<select>" + sHtml + "</select>";
		
		var oDummySelect = oDummy.firstChild;
		var oOptions = $A(oDummySelect.childNodes);
		
		oEl.innerHTML = '';
		
		for (var i = 0; i < oOptions.length; i++)
			oEl.appendChild(oOptions[i]);
			
		oDummySelect = null;
		oDummy = null;

	} else {
	
		oEl.innerHTML = sHtml;
	
	}
	
}

var Combobox = Class.extend(Selectbox, {

	_type : "combobox",
	_textbox : null,
	
	touch : function(wrap, related) {
		
		if (this._initialized) {
			this.setDisable(this.getDisable());
			this._resetList();
			return;
		}

		this._textbox = $$B("input", $B(wrap))[0];

		Selectbox.prototype.touch.apply(this, arguments);
		
		this._bindComboboxEvents();
		this._resetLabel();
	},
	
	getDisable : function() {
		return (
			// Element.hasClass(this._objects.wrap, "sb-disabled") ||
			this._related.disabled ||
			this._textbox.disabled
		);
	},
	
	setDisable : function(bFlag) {
		
		var bFlag = Selectbox.prototype.setDisable.apply(this, arguments);
		this._textbox.disabled = bFlag;
		
		return bFlag;
		
	},
	
	setLabelHTML : null,

	_bindComboboxEvents : function() {
		
		if (this.getDisable()) return;

		var oObjects = this._objects;

		Event.register(this._textbox, "keydown", function(oEvent) {
			
			var oLi = this._highlighted;
			
			switch (oEvent.keyCode) {
			case 38: // up
				this._selectItem(oLi ? oLi.previousSibling : this._getItemByIndex(0));
				break;
				
			case 40: // down
				this._selectItem(oLi ? oLi.nextSibling : this._getItemByIndex(0));
				break;
				
			default:

				if (this._highlighted)
					Element.removeClass(this._highlighted, "item-selected");
					
				this._highlighted = null;
				
				return;
			}
			
			oEvent.stop();
			
		}.bindForEvent(this));
		
	},
	
	_resetLabel : function(bHideList) {
		
		if (!this._textbox) return;
		
		this._textbox.value = this._getValue();
		if (bHideList) this.showList(false);

	},

	_focus : function() {

		try {
			this._textbox.focus();
			this._textbox.select();
		} catch(e) { }
		
	}
	
});

