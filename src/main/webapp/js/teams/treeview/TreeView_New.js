/* =========================================================
 * bootstrap-treeview.js v1.2.0
 * =========================================================
 * Copyright 2013 Jonathan Miles
 * Project URL : http://www.jondmiles.com/bootstrap-treeview
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ========================================================= */

(function ($, window, document, undefined) {

	/*global jQuery, console*/

	'use strict';

	var pluginName = 'treeview';

	var _default = {};

	_default.settings = {

		injectStyle: false,

		levels: 2,

		expandIcon: 'i_arrow_up',
		collapseIcon: 'i_arrow_down',
		emptyIcon: 'glyphicon',
		nodeIcon: 'i_department',
		companyIcon: 'i_company',
		selectedIcon: 'active',
		checkedIcon: 'treeviewIcon tree_check',
		uncheckedIcon: 'treeviewIcon tree_unchecked',

		color: '#000000',
		backColor: '#FFFFFF',
		borderColor: '#dddddd',
		onhoverColor: '#F5F5F5',
		selectedColor: '#CAD1FB',
		selectedBackColor: '#f8f9ff',
		searchResultColor: '#D9534F',
		searchResultBackColor: undefined, //'#FFFFFF',

		enableLinks: false,
		highlightSelected: true,
		highlightSearchResults: true,
		showBorder: false,
		showIcon: true,
		showCheckbox: false,
		showTags: false,
		multiSelect: false,

		// Event handlers
		onNodeChecked: undefined,
		onNodeCollapsed: undefined,
		onNodeDisabled: undefined,
		onNodeEnabled: undefined,
		onNodeExpanded: undefined,
		onNodeSelected: undefined,
		onNodeUnchecked: undefined,
		onNodeUnselected: undefined,
		onSearchComplete: undefined,
		onSearchCleared: undefined,
		onClickChatIcon: undefined,
		onClickCallIcon: undefined,
		onClickUserImg: undefined,
		onClickDeleteImg: undefined,
		onClickKebabMenu: undefined,

		useDeptCheckbox: false,
		noUseStyle: true,
		showUser: false,
		showUserImg: true,
		showPresence: true,
		isSearchList: false,
		treeType: "organ",		// organ : 부서트리, user : 사용자 리스트, select : 선택한 사용자 리스트, searchDept,searchDeptM,searchUserM : 검색결과 리스트 (M은 모바일 화면)
		useCompanyList : true,
		noClickEventClass: ['droupdown_item', 'btn_company', 'i_close', 'btn_top_close', 'check-disabled'],
		useKebab: false
	};

	_default.options = {
		silent: false,
		useKebab: false
		//ignoreChildren: false,
		//useDeptCheckbox: false
	};

	_default.searchOptions = {
		ignoreCase: true,
		exactMatch: true,
		revealResults: true,
		noUseStyle: true
	};

	var Tree = function (element, options) {

		this.$element = $(element);
		this.elementId = element.id;
		this.styleId = this.elementId + '-style';

		this.init(options);

		return {

			// Options (public access)
			options: this.options,

			// Initialize / destroy methods
			init: $.proxy(this.init, this),
			remove: $.proxy(this.remove, this),

			// Get methods
			getNode: $.proxy(this.getNode, this),
			getParent: $.proxy(this.getParent, this),
			getSiblings: $.proxy(this.getSiblings, this),
			getSelected: $.proxy(this.getSelected, this),
			getUnselected: $.proxy(this.getUnselected, this),
			getExpanded: $.proxy(this.getExpanded, this),
			getCollapsed: $.proxy(this.getCollapsed, this),
			getChecked: $.proxy(this.getChecked, this),
			getUnchecked: $.proxy(this.getUnchecked, this),
			getDisabled: $.proxy(this.getDisabled, this),
			getEnabled: $.proxy(this.getEnabled, this),

			// Select methods
			selectNode: $.proxy(this.selectNode, this),
			unselectNode: $.proxy(this.unselectNode, this),
			toggleNodeSelected: $.proxy(this.toggleNodeSelected, this),

			// Expand / collapse methods
			collapseAll: $.proxy(this.collapseAll, this),
			collapseNode: $.proxy(this.collapseNode, this),
			expandAll: $.proxy(this.expandAll, this),
			expandNode: $.proxy(this.expandNode, this),
			toggleNodeExpanded: $.proxy(this.toggleNodeExpanded, this),
			revealNode: $.proxy(this.revealNode, this),

			// Expand / collapse methods
			checkAll: $.proxy(this.checkAll, this),
			checkNode: $.proxy(this.checkNode, this),
			uncheckAll: $.proxy(this.uncheckAll, this),
			uncheckNode: $.proxy(this.uncheckNode, this),
			toggleNodeChecked: $.proxy(this.toggleNodeChecked, this),

			// Disable / enable methods
			disableAll: $.proxy(this.disableAll, this),
			disableNode: $.proxy(this.disableNode, this),
			enableAll: $.proxy(this.enableAll, this),
			enableNode: $.proxy(this.enableNode, this),
			toggleNodeDisabled: $.proxy(this.toggleNodeDisabled, this),
			toggleSelectedState: $.proxy(this.toggleSelectedState, this),

			// Search methods
			search: $.proxy(this.search, this),
			clearSearch: $.proxy(this.clearSearch, this),
			findNodes: $.proxy(this.findNodes, this),
			// custom methods
			getCheckedNodes: $.proxy(this.getCheckedNodes, this),
			treeViewScrollTo : $.proxy(this.treeViewScrollTo, this),
			ExtUserAdd: $.proxy(this.ExtUserAdd, this),
			ExtUserDel: $.proxy(this.ExtUserDel, this),
			getNodeAll: $.proxy(this.getNodeAll, this)
		};
	};

	Tree.prototype.init = function (options) {
		this.tree = [];
		this.nodes = [];
		if (options.data) {
			if (typeof options.data === 'string') {
				options.data = $.parseJSON(options.data);
			}
			this.tree = $.extend(true, [], options.data);
			delete options.data;
		}
		this.options = $.extend({}, _default.settings, options);

		this.destroy();
		this.subscribeEvents();
		this.setInitialStates({ nodes: this.tree }, 0);
		this.render();
	};

	Tree.prototype.remove = function () {
		this.destroy();
		$.removeData(this, pluginName);
		$('#' + this.styleId).remove();
	};

	Tree.prototype.destroy = function () {

		if (!this.initialized) return;

		this.$wrapper.remove();
		this.$wrapper = null;

		// Switch off events
		this.unsubscribeEvents();

		// Reset this.initialized flag
		this.initialized = false;
	};

	Tree.prototype.unsubscribeEvents = function () {

		this.$element.off('click');
		this.$element.off('dblclick');
		this.$element.off('nodeChecked');
		this.$element.off('nodeCollapsed');
		this.$element.off('nodeDisabled');
		this.$element.off('nodeEnabled');
		this.$element.off('nodeExpanded');
		this.$element.off('nodeSelected');
		this.$element.off('nodeUnchecked');
		this.$element.off('nodeUnselected');
		this.$element.off('searchComplete');
		this.$element.off('searchCleared');
	};

	Tree.prototype.subscribeEvents = function () {
		this.unsubscribeEvents();

		this.$element.on('click', $.proxy(this.clickHandler, this));
		
		if (typeof (this.options.onNodeChecked) === 'function') {
			this.$element.off('nodeChecked').on('nodeChecked', this.options.onNodeChecked);
		}

		if (typeof (this.options.onNodeCollapsed) === 'function') {
			this.$element.off('nodeCollapsed').on('nodeCollapsed', this.options.onNodeCollapsed);
		}

		if (typeof (this.options.onNodeDisabled) === 'function') {
			this.$element.off('nodeDisabled').on('nodeDisabled', this.options.onNodeDisabled);
		}

		if (typeof (this.options.onNodeEnabled) === 'function') {
			this.$element.off('nodeEnabled').on('nodeEnabled', this.options.onNodeEnabled);
		}

		if (typeof (this.options.onNodeExpanded) === 'function') {
			this.$element.off('nodeExpanded').on('nodeExpanded', this.options.onNodeExpanded);
		}

		if (typeof (this.options.onNodeSelected) === 'function') {
			this.$element.off('nodeSelected').on('nodeSelected', this.options.onNodeSelected);
		}

		if (typeof (this.options.onNodeUnchecked) === 'function') {
			this.$element.off('nodeUnchecked').on('nodeUnchecked', this.options.onNodeUnchecked);
		}

		if (typeof (this.options.onNodeUnselected) === 'function') {
			this.$element.off('nodeUnselected').on('nodeUnselected', this.options.onNodeUnselected);
		}

		if (typeof (this.options.onSearchComplete) === 'function') {
			this.$element.off('searchComplete').on('searchComplete', this.options.onSearchComplete);
		}

		if (typeof (this.options.onSearchCleared) === 'function') {
			this.$element.off('searchCleared').on('searchCleared', this.options.onSearchCleared);
		}
		if (typeof (this.options.onClickChatIcon) === 'function') {
			this.$element.off('onClickChatIcon').on('onClickChatIcon', this.options.onClickChatIcon);
		}
		if (typeof (this.options.onClickUserImg) === 'function') {
			this.$element.off('onClickUserImg').on('onClickUserImg', this.options.onClickUserImg);
		}
		if (typeof (this.options.onClickCallIcon) === 'function') {
			this.$element.off('onClickCallIcon').on('onClickCallIcon', this.options.onClickCallIcon);
		}
		if (typeof (this.options.onClickDeleteImg) === 'function') {
			this.$element.off('onClickDeleteImg').on('onClickDeleteImg', this.options.onClickDeleteImg);
		}
		if (typeof (this.options.onClickKebabMenu) === 'function') {
			this.$element.off('onClickKebabMenu').on('onClickKebabMenu', this.options.onClickKebabMenu);
		}
	};

	/*
		Recurse the tree structure and ensure all nodes have
		valid initial states.  User defined states will be preserved.
		For performance we also take this opportunity to
		index nodes in a flattened structure
	*/
	Tree.prototype.setInitialStates = function (node, level) {
		if (!node.nodes) return;
		level += 1;
		var parent = node;
		var _this = this;
		$.each(node.nodes, function checkStates(index, node) {
			// nodeId : unique, incremental identifier
			node.nodeId = _this.nodes.length;
			node.nodeLevel = level;
			// parentId : transversing up the tree
			node.parentId = parent.nodeId;
			if (!parent.nodeId) {
				node.parentId = "0";
			}

			// if not provided set selectable default value
			if (!node.hasOwnProperty('selectable')) {
				node.selectable = true;
			}

			// where provided we should preserve states
			node.state = node.state || {};

			// set checked state; unless set always false
			if (!node.state.hasOwnProperty('checked')) {
				node.state.checked = false;
			}

			// set enabled state; unless set always false
			if (!node.state.hasOwnProperty('disabled')) {
				node.state.disabled = false;
			}
			// set expanded state; if not provided based on levels
			//if (node.state.expanded) {
			//	
			//}
			if (!node.state.hasOwnProperty('expanded')) {
				if (!node.state.disabled &&
					//(level < _this.options.levels) && ((node.nodes || (!node.nodes && node.isLeaf=="FALSE")) && node.nodes.length > 0)){
					(level < _this.options.levels) && (node.nodes && node.nodes.length > 0)) {	// 초기 확장되어 보이는 레벨
					node.state.expanded = true;
				}
				else {
					node.state.expanded = false;
				}
			} else {
				
				if (!node.state.disabled && (node.nodes && node.nodes.length > 0)) {
					node.state.expanded = true;
				}
			}

			// set selected state; unless set always false
			if (!node.state.hasOwnProperty('selected')) {
				node.state.selected = false;
			}

			// index nodes in a flattened structure for use later
			_this.nodes.push(node);

			// recurse child nodes and transverse the tree
			if (node.nodes) {
				_this.setInitialStates(node, level);
			}
		});
	};

	Tree.prototype.clickHandler = function (event) {
		if (!this.options.enableLinks) event.preventDefault();
		var target = $(event.target);

		var classList = target.attr('class') ? target.attr('class').split(' ') : [];
		var noClickEvent = this.options.noClickEventClass.filter(x => classList.includes(x));
		if (noClickEvent.length >0) return;	// 클릭이벤트 제외 클래스명 포함여부

		var node = this.findNode(target);
		if (!node || node.state.disabled) return;
		var classList = target.attr('class') ? target.attr('class').split(' ') : [];
		if (classList.indexOf('expand-icon') !== -1) {

			this.toggleExpandedState(node, _default.options);			
			this.buildTree(node, parseInt(node.nodeLevel), "SUB");
			// 부서 확장시 선택부서 상단에 위치하도록 스크롤 조정
			if (node.data1.toUpperCase() == "DEPT" && node.isLeaf.toUpperCase() == "FALSE" && node.state.expanded) {/*&& !(!isMobile() && node.hasDept.toUpperCase() == "FALSE")*/ 
				this.treeViewScrollTo();
			}
		}
		else if (classList.indexOf('check-icon') !== -1) {
			if (node.nodes && node.data1.toUpperCase() == "DEPT" && node.state.expanded == false) {
				this.toggleExpandedState(node, _default.options); // 클릭시 트리 확장 추가				
				this.buildTree(node, parseInt(node.nodeLevel), "SUB");
			} else if (!node.nodes && node.data1.toUpperCase() == "DEPT" && node.isLeaf.toUpperCase() == "FALSE" && node.state.expanded == false) {
				this.GetDeptSubTreeInfo(node);				
				this.toggleExpandedState(node, _default.options);
				this.buildTree(node, parseInt(node.nodeLevel), "SUB");
			}
			this.toggleCheckedState(node, _default.options);
		}
		else if (classList.indexOf('i_talk') !== -1) {
			this.$element.trigger('onClickChatIcon', $.extend(true, {}, node));
		} else if (classList.indexOf('userImg') !== -1) {
			this.toggleSelectedState(node, { silent: true });
			this.$element.trigger('onClickUserImg', $.extend(true, {}, node));
		}
		else if (classList.indexOf('i_phone') !== -1) {
			this.$element.trigger('onClickCallIcon', $.extend(true, {}, node));
		}
		else if (classList.indexOf('i_select_close') !== -1) {
			this.toggleCheckedState(node, _default.options);
			this.$element.trigger('onClickDeleteImg', $.extend(true, {}, node));
		}
		else if (classList.indexOf('i_kebob') !== -1) {
			this.$element.trigger('onClickKebabMenu', $.extend(true, {}, node));
		}
		else {
			if (node.selectable) {
				if (!(node.state.selected && node.data1.toUpperCase() == "DEPT") && !(this.options.treeType.toUpperCase() == "ORGAN" && node.data1.toUpperCase() == "USER" )) {
					this.toggleSelectedState(node, { silent: true });
				}
				if (node.nodes && node.data1.toUpperCase() == "DEPT" && node.nodeId != "0") {
					this.toggleExpandedState(node, _default.options); // 클릭시 트리 확장 추가								
					this.buildTree(node, parseInt(node.nodeLevel), "SUB");		
										
				} else if (!node.nodes && node.data1.toUpperCase() == "DEPT" && node.isLeaf && node.isLeaf.toUpperCase() == "FALSE" && node.nodeId != "0") {
					this.GetDeptSubTreeInfo(node);
					this.toggleExpandedState(node, _default.options);
					this.buildTree(node, parseInt(node.nodeLevel), "SUB");	
				}
				
			} else {
				this.toggleExpandedState(node, _default.options);
			}
			// 부서 확장시 선택부서 상단에 위치하도록 스크롤 조정
			if (node.data1.toUpperCase() == "DEPT" && node.isLeaf && node.isLeaf.toUpperCase() == "FALSE" && node.state.expanded) {/*&& !(!isMobile() && node.hasDept.toUpperCase() == "FALSE")*/
				this.treeViewScrollTo();
			}
			this.$element.trigger('nodeSelected', $.extend(true, {}, node));
		}
	};

	Tree.prototype.dblClickHandler = function (event) {

	}
	// Looks up the DOM for the closest parent list item to retrieve the
	// data attribute nodeid, which is used to lookup the node in the flattened structure.
	Tree.prototype.findNode = function (target) {

		var nodeId = target.closest('li.list-group-item').attr('data-nodeid');
		var node = this.nodes[nodeId];

		if (!node) {
			console.log('Error: node does not exist');
		}
		return node;
	};

	Tree.prototype.toggleExpandedState = function (node, options) {
		if (!node) return;
		this.setExpandedState(node, !node.state.expanded, options);		
	};

	Tree.prototype.setExpandedState = function (node, state, options) {
		if (this.options && (this.options.treeType === "searchDept" || this.options.treeType === "searchDeptM")) {
			return;
		}
		var target = this.$element[0].querySelectorAll("li[data-nodeid='" + node.nodeId + "']")[0];

		if (state === node.state.expanded) return;
		else if (node.data1.toUpperCase() == "USER") return;	// display:none 처리한 영역 클릭이벤트잡히는 현상 방지

		if (state && node.nodes) {

			// Expand a node
			node.state.expanded = true;

			if (target && (node.hasDept && node.hasDept.toUpperCase() == "TRUE" || node.hasDeptUser && node.hasDeptUser.toUpperCase() == "TRUE"))
				target.querySelector('.i_arrow_up').classList.replace('i_arrow_up', 'i_arrow_down');

			if (!options.silent) {
				this.$element.trigger('nodeExpanded', $.extend(true, {}, node));
			}
		}
		else if (state && !node.nodes) {
			node = this.GetDeptSubTreeInfo(node);
			this.setExpandedState(node, state, options);
		}
		else if (!state) {
			if (node.nodes) {
				$.each(node.nodes, $.proxy(function (index, node) {
					this.setExpandedState(node, false, options);
					this.buildTree(node, parseInt(node.nodeLevel), "SUB");
				}, this));
			}
			node.state.expanded = false;
			if (target && (node.hasDept.toUpperCase() == "TRUE" || node.hasDeptUser.toUpperCase() == "TRUE")) {
				target.querySelector('.i_arrow_down').classList.replace('i_arrow_down', 'i_arrow_up');
			}
			//}
			if (!options.silent) {
				this.$element.trigger('nodeCollapsed', $.extend(true, {}, node));
			}
		}		
	};

	Tree.prototype.toggleSelectedState = function (node, options) {
		if (!node) return;
		// this.setSelectedState(node, !node.state.selected, options);
		this.setSelectedState(node, !node.state.selected, options || { silent: false }); // 직원검색에서 엔터 시 안되는 오류 해결
	};

	Tree.prototype.setSelectedState = function (node, state, options) {

		var target = this.$element[0].querySelectorAll("li[data-nodeid='" + node.nodeId + "']")[0];
		if (state === node.state.selected) return;

		if (state) {

			// If multiSelect false, unselect previously selected
			if (!this.options.multiSelect) {
				$.each(this.findNodes('true', 'g', 'state.selected'), $.proxy(function (index, node) {
					this.setSelectedState(node, false, options);

				}, this));
			}

			// Continue selecting node
			node.state.selected = true;
			if (target) {
				$(target).toggleClass("node-selected").toggleClass('active').attr("style", this.buildStyleOverride(node));
			}

			if (!options.silent) {
				this.$element.trigger('nodeSelected', $.extend(true, {}, node));
			}
		}
		else {
			// Unselect node
			if (target) {
				$(target).toggleClass('node-selected').toggleClass('active').attr("style", this.buildStyleOverride(node));
			}
			node.state.selected = false;
			
			if (!options.silent) {
				this.$element.trigger('nodeUnselected', $.extend(true, {}, node));
			}
		}
		
	};

	Tree.prototype.toggleCheckedState = function (node, options) {
		if (!node) return;
		this.setCheckedState(node, !node.state.checked, options);
	};

	Tree.prototype.setCheckedState = function (node, state, options) {
		var target = this.$element[0].querySelector("li[data-nodeid='" + node.nodeId + "']");
		var targetFor;
		if (target) { // 트리뷰 확장 되어있는경우 체크박스 상태 변경
			if (target.disabled) {
				return;	// 체크박스 비활성화
			}
			targetFor = target.querySelector('input[type="checkBox"]');
			//eval(targetFor).checked = state;
			targetFor.checked = state;
		}	

		if (state === node.state.checked) return;

		if (state) {

			// Check node
			node.state.checked = true;

			if (!options.silent) {
				this.$element.trigger('nodeChecked', $.extend(true, {}, node));
			}
		}
		else {

			// Uncheck node
			node.state.checked = false;
			if (!options.silent) {
				this.$element.trigger('nodeUnchecked', $.extend(true, {}, node));
			}
		}
	};

	Tree.prototype.setDisabledState = function (node, state, options) {

		
		if (state === node.state.disabled) return;

		if (state) {

			// Disable node
			node.state.disabled = true;

			// Disable all other states
			this.setExpandedState(node, false, options);
			this.setSelectedState(node, false, options);
			this.setCheckedState(node, false, options);

			if (!options.silent) {
				this.$element.trigger('nodeDisabled', $.extend(true, {}, node));
			}
		}
		else {

			// Enabled node
			node.state.disabled = false;
			if (!options.silent) {
				this.$element.trigger('nodeEnabled', $.extend(true, {}, node));
			}
		}
	};

	Tree.prototype.render = function () {
		if (!this.initialized) {
			// Setup first time only components
			this.$element.addClass(pluginName);
			this.$wrapper = $(this.template.list);

			this.initialized = true;
		}
		this.$element.empty().append(this.$wrapper.empty());
		// Build tree
		this.buildTree(this.tree, 0,"ALL");
	};

	// Starting from the root node, and recursing down the
	// structure we build the tree one node at a time
	Tree.prototype.buildTree = function (node, level, pType) {
		var nodes;
		if (!node) return;
		level += 1;
		var _this = this;
		var target;
		
		if (pType == "SUB") {
			nodes = node.nodes;
			target = _this.$element[0].querySelectorAll("li[data-nodeid='" + node.nodeId + "']")[0];
		} else if (pType == "SEL" || pType=="DEL") {
			target = _this.$element[0].querySelector("ul");
			nodes = node;
		}
		else {
			nodes = node;
		}
		if (pType == "SUB" && !node.state.expanded) {
			$.each(nodes, function addNodes(id, node) {
				if (_this.$element[0].querySelector("li[data-nodeid='" + node.nodeId + "']"))
					_this.$element[0].querySelector("li[data-nodeid='" + node.nodeId + "']").remove();
			});
		} 
		else {
			$.each(nodes, function addNodes(id, node) {
				if (pType == "SEL" && (target.querySelectorAll("li[data2='" + node.data2 + "']").length > 0 || !node.state.checked)) {					
					return;
				}
				else if (pType == "DEL") {
					if (_this.$element[0].querySelector("li[data2='" + node.data2 + "']"))
						_this.$element[0].querySelector("li[data2='" + node.data2 + "']").remove();
				}
				else {
					var treeItem = $(_this.template.item)
						.addClass('node-' + _this.elementId)
						.addClass(node.state.checked ? 'node-checked' : '')
						.addClass(node.state.disabled ? 'node-disabled' : '')
						.addClass(node.state.selected ? 'node-selected' : '')
						.addClass(node.searchResult ? 'search-result' : '')
						.addClass(node.data1.toUpperCase() == "USER" ? 'node-user' : '')
						.addClass(_this.options.treeType.toUpperCase() == "SEARCH" ? 'search-group' : '')
						.attr('data-nodeid', node.nodeId)
						.attr('style', _this.buildStyleOverride(node));

					
					var nodeFlex = $(_this.template.spanFormat.formatTreeView("node_flex"));
					// Add indent/spacer to mimic tree structure
					for (var i = 0; i < (level - 1); i++) {
						nodeFlex.append(_this.template.spanFormat.formatTreeView("indent"));
					}
					// Add expand, collapse or empty spacer icons
					var classList = [];
					if (node.nodeId != "0" && (node.nodes || (!node.nodes && node.isLeaf == "FALSE")) && (node.hasDept && node.hasDept.toUpperCase() == "TRUE" || node.hasDeptUser && node.hasDeptUser.toUpperCase() == "TRUE")) {
						classList.push('expand-icon icon_organ');
						if (node.state.expanded) {
							classList.push(_this.options.collapseIcon);
						}
						else {
							classList.push(_this.options.expandIcon);
						}

						nodeFlex.append($(_this.template.spanFormat.formatTreeView("icon"))
							.addClass(classList.join(' '))
						);
						if (node.hasDept.toUpperCase() == "FALSE" && node.hasDeptUser.toUpperCase() == "TRUE") {
							treeItem.addClass("node-TreeNo");
						}

					}
					else if (node.data1.toUpperCase() == "DEPT" && node.nodeId != "0" && _this.options.treeType.toUpperCase() == "ORGAN") {

						nodeFlex.append(_this.template.spanFormat.formatTreeView("indent2"));
						//classList.push(_this.options.emptyIcon);
					} 					

					// Add node icon
					if (_this.options.showIcon && node.icon === "i_company") {
						var classList = ['node-icon', 'icon_organ', 'i_company'];
						nodeFlex.append($(_this.template.spanFormat.formatTreeView("icon")).addClass(classList.join(' '))
						);

					} else if (_this.options.showIcon && node.data1.toUpperCase() == "DEPT" && _this.options.treeType.toUpperCase() != "SEARCHDEPTM") {
						var classList = ['node-icon', 'icon_organ'];
						classList.push(node.icon || _this.options.nodeIcon);
						if (node.state.selected) {
							classList.pop();
							classList.push(_this.options.nodeIcon);
							classList.push(node.selectedIcon || _this.options.selectedIcon || node.icon);
						}
						nodeFlex.append($(_this.template.spanFormat.formatTreeView("icon"))
							.addClass(classList.join(' '))
						);
					} else if (_this.options.showIcon && node.data1.toUpperCase() == "DEPT" && _this.options.treeType == "searchDeptM"){
						var classList = ['i_department'];

						nodeFlex.append($(_this.template.deptImg.formatTreeView("/images/teams/department_photo.png")).addClass(classList.join(' '))
						);
					}

					// Add check / unchecked icon
					// 체크박스 사용시, 사용자만 활성화 옵션
					//if (_this.options.showCheckbox && ((_this.options.useDeptCheckbox && !(node.data1.toUpperCase() == "DEPT" && node.hasDeptUser.toUpperCase() == "FALSE")) || (!_this.options.useDeptCheckbox && node.data1.toUpperCase() == "USER"))) {
					// 체크박스 추가 START					
					if (_this.options.showCheckbox && node.data1.toUpperCase() == "USER") {
						var spanTemplate = $(_this.template.span);
						var chekTemplate = $(_this.template.check);
						var labelTemplate = $(_this.template.checkLabel);

						var classList = ['check-icon'];
						if (node.state.checked) {
							classList.push(_this.options.checkedIcon);
						}
						else {
							classList.push(_this.options.uncheckedIcon);
						}

						chekTemplate.attr("id", "listview_chk" + node.nodeId);
						labelTemplate.attr("for", "listview_chk" + node.nodeId);

						if (node.state.checked) {
							chekTemplate.attr("checked", true);
						}
						if (node.data1.toUpperCase() == "USER" && node.teamsId.trim() == "") {
							chekTemplate.attr("disabled", true);
						}
						if (node.teamsId.trim() != "") {
							chekTemplate.attr("data1", node.teamsId);
						}
						spanTemplate.append(chekTemplate);
						spanTemplate.append(labelTemplate);
						spanTemplate.addClass("listview-check checks");

						if (pType == "SEL") {
							node.state.checked = true;
							chekTemplate.attr("checked", true);
							spanTemplate.attr("style", "display : none;");
						}
						
						nodeFlex.append(spanTemplate);
						if (node.data1.toUpperCase() == "USER" && node.teamsId.trim() == "") {
							classList.push(" check-disabled ");
							treeItem.addClass(classList.join(" "));
						}

						

					}
					// 체크박스 추가 END

					// 프로필 추가 START
					if (node.data1.toUpperCase() == "USER") {
						
						var spanTemplate = $(_this.template.span);
						var classList = ['user_photo'];						
						spanTemplate.addClass(classList.join(' '))
							.attr("data1", node.data1)
							.attr("data2", node.data2)
							.attr("displayName", node.displayName)
							.attr("presence", node.presence)
							.attr("mail", node.mail);


						// PRESENCE 추가 START
						var presenceImg = "";
						var userImg = "";
					
						if (_this.options.showPresence) {						
							if (node.presence && node.presence != "") {
								switch (node.presence) {
									case "Available":
										presenceImg = "/images/Presence/Presence_Available.jpg";
										break;
									case "Busy":
										presenceImg = "/images/Presence/Presence_Busy.jpg";
										break;
									case "DoNotDisturb":
										presenceImg = "/images/Presence/Presence_DoNotDisturb.jpg";
										break;
									case "BeRightBack":
										presenceImg = "/images/Presence/Presence_Away.jpg";
										break;
									case "Away":
										presenceImg = "/images/Presence/Presence_Away.jpg";
										break;
									default:
										presenceImg = "/images/Presence/Presence_Default.jpg";
								}
								var presenceTemplate = $(_this.template.presence.formatTreeView(presenceImg));
								// spanTemplate.append(presenceTemplate);
							}
						}
						// PRESENCE 추가 END

						// 사용자 이미지 추가 START
						if (!node.extensionAttribute2 && node.data11) {
							node.extensionAttribute2 = node.data11;
						}
						try {
							var g_colPhoto = g_PhotoPath;
						} catch (e) { g_colPhoto = null; }
						if (node.extensionAttribute2 && node.extensionAttribute2.trim() != "" && (node.extensionAttribute2.toLowerCase().indexOf("jpg") > -1 || node.extensionAttribute2.toLowerCase().indexOf("bmp") > -1 || node.extensionAttribute2.toLowerCase().indexOf("gif") > -1 || node.extensionAttribute2.toLowerCase().indexOf("png") > -1 || node.extensionAttribute2.toLowerCase().indexOf("jpeg") > -1)) {
							userImg = "/admin/ezOrgan/getPersonalInfo.do?fileName=" + node.extensionAttribute2;
							// userImg = "getCoreAppPath()" + g_colPhoto + node.data11;
						} else {
							userImg = "/images/teams/NoPhoto.png";
						}
						var userImgTemplate = $(_this.template.userImg.formatTreeView(userImg));
						spanTemplate.append(userImgTemplate);
						// 사용자 이미지 추가 END
						spanTemplate.append(presenceTemplate);
						nodeFlex.append(spanTemplate);

					}
					// 프로필 추가 END

					// 사용자 정보 추가 START
					if (_this.options.enableLinks) {
						// Add hyperlink
						nodeFlex.append($(_this.template.link)
								.attr('href', node.href)
								.append(node.value)
							);
					}
					else {
						if (node.data1.toUpperCase() == "USER") {
							
							var userInfo = $(_this.template.span).addClass('user_list_info');
							var userInfo_nameBox = $(_this.template.spanFormat.formatTreeView("nameBox"));

							userInfo_nameBox.append($(_this.template.spanFormat.formatTreeView("name")).append(node.displayName || node.displayName || ""));
							
							if (node.addJob && node.addJob.trim() == "Y") {
								userInfo_nameBox.append($(_this.template.spanFormat.formatTreeView("concurrent")).append(strLang66));
							}
							userInfo.append(userInfo_nameBox);		

							if (pType != "SEL") {
								var userInfo_position = $(_this.template.spanFormat.formatTreeView("rank")).append((node.title || "").trim());
							}
							else {
								var userInfo_position = $(_this.template.spanFormat.formatTreeView("rank")).append(node.title.trim() + "/" + node.description);
								userInfo.append($(_this.template.delete));
							}

							var userInfo_mail = $(_this.template.spanFormat.formatTreeView("mail")).append((node.mail || node.upnName || "").trim());
							var userInfo_phone = $(_this.template.spanFormat.formatTreeView("phone")).append((node.mobile || "").trim());
							var userInfo_company_phone = $(_this.template.spanFormat.formatTreeView("company_phone")).append((node.telephoneNumber || "").trim());
							var userInfo_work = $(_this.template.spanFormat.formatTreeView("work")).append((node.chargeBusiness || "").trim());

							var userInfo_department = $(_this.template.spanFormat.formatTreeView("department")).append((node.description || "").trim());
							var userInfo_search = $(_this.template.spanFormat.formatTreeView("rank")).append((node.title || "").trim());
							if (_this.options.treeType.toUpperCase() == "SEARCH") {
								
								userInfo.append(userInfo_department);
								userInfo.append(userInfo_position);
								// userInfo.append(userInfo_mail);
								userInfo.append(userInfo_phone);
								userInfo.append(userInfo_company_phone);
								userInfo.append(userInfo_work);								
								
							} else {
								userInfo.append(userInfo_position);
								userInfo.append(userInfo_mail);
								userInfo.append(userInfo_phone);
								userInfo.append(userInfo_company_phone);
								userInfo.append(userInfo_work);
								userInfo.append(userInfo_department);
							}							
							
							if (_this.options.useKebab) {
								userInfo.append($(_this.template.kebob));
							} else {
								userInfo.append($(_this.template.call));
								userInfo.append($(_this.template.talk));
							}

							nodeFlex.append(userInfo);

							treeItem
								.attr('data1', node.data1)
								.attr('data2', node.data2)
								.attr('description', node.description);
							
							if (_this.options.propertyList) {
								var property = _this.options.propertyList.split(';');
								for (var i = 0; i < property.length; i++) {
									treeItem.attr("data" + (i + 3).toString(), _this.getNodeValue(node, "data" + (i + 3).toString()));
								}
							}
						} else {
							nodeFlex.append(node.value);
							treeItem
								.attr('data1', node.data1)
								.attr('data2', node.data2);
						
						}

					}
					// 사용자 정보 추가 END

					// Add tags as badges
					if (_this.options.showTags && node.tags) {
						$.each(node.tags, function addTag(id, tag) {
							nodeFlex
								.append($(_this.template.spanFormat.formatTreeView("badge"))
									.append(tag)
								);
						});
					}
					
					treeItem.append(nodeFlex);
					// 회사 선택 SELECTBOX 추가 START
					if (node.nodeId == "0" && _this.options.treeType.toUpperCase() == "ORGAN" && _this.options.useCompanyList) {
						var companyList = $("#ListCompany")[0];
						if (companyList.length > 1) {
							var selectCompanyTemplate = $(_this.template.btnFormat.formatTreeView("btn_company"));
							selectCompanyTemplate.append(strLang1 + strLang17);
							selectCompanyTemplate.attr("onclick", "onClickeDropdown()");

							var ulTemplate = $(_this.template.listFormat.formatTreeView("droupdown_menu"));
						
							for (var i = 0; i < companyList.length; i++) {
								var liTemplate = $(_this.template.item).addClass("droupdown_item");
								liTemplate.attr("id", i);
								liTemplate.attr("value", companyList.options[i].value);
								liTemplate.append(companyList.options[i].text);
								liTemplate.attr("onclick", "company_change(this)");
								ulTemplate.append(liTemplate);
							}

							var divTemplate = $(_this.template.divFormat.formatTreeView("organ_top"));

							var closeBtn = $(_this.template.btnFormat.formatTreeView("btn_top_close"));
							closeBtn.append($(_this.template.spanFormat.formatTreeView("icon_organ i_close")));
							closeBtn.attr("onclick", "onClickeDropdown()");
							divTemplate.append(closeBtn);
							divTemplate.append($(_this.template.spanFormat.formatTreeView("title_h2")).append(strLang1 + strLang17));

							treeItem.append(selectCompanyTemplate);
							treeItem.append(ulTemplate);
							treeItem.append(divTemplate);
						}

					}
					// 회사 선택 SELECTBOX 추가 END

					// Add item to the tree
					if (pType == "SUB") {
						target.after(treeItem[0]);
						target = treeItem;
					} else if (pType == "SEL") {
						target.append(treeItem[0]);
					}
					else {
						_this.$wrapper.append(treeItem);
					}

					// Recursively add child ndoes
					if (node.nodes && node.state.expanded && !node.state.disabled) {
						return _this.buildTree(node.nodes, level, pType);
					}
				}

			});
		}
	};

	// Define any node level style override for
	// 1. selectedNode
	// 2. node|data assigned color overrides
	Tree.prototype.buildStyleOverride = function (node) {
		//
		if (node.state.disabled) return '';
		
		var color = this.options.color;
		var backColor = this.options.backColor;

		if (this.options.highlightSelected && node.state.selected) {
			if (this.options.selectedColor) {
				color = this.options.selectedColor;
			}
			if (this.options.selectedBackColor) {
				backColor = this.options.selectedBackColor;
			}
		}

		if (this.options.highlightSearchResults && node.searchResult && !node.state.disabled) {
			if (this.options.searchResultColor) {
				color = this.options.searchResultColor;
			}
			if (this.options.searchResultBackColor) {
				backColor = this.options.searchResultBackColor;
			}
		}
		return ' ';
		//return 'color:' + color +
		//	';background-color:' + backColor + ';';
	};


	// Construct trees style based on user options
	Tree.prototype.buildStyle = function () {

		var style = '.node-' + this.elementId + '{';

		if (this.options.color) {
			style += 'color:' + this.options.color + ';';
		}

		if (this.options.backColor) {
			style += 'background-color:' + this.options.backColor + ';';
		}

		if (!this.options.showBorder) {
			style += 'border:none;';
		}
		else if (this.options.borderColor) {
			style += 'border:1px solid ' + this.options.borderColor + ';';
		}
		style += '}';

		if (this.options.onhoverColor) {
			style += '.node-' + this.elementId + ':not(.node-disabled):hover{' +
				'background-color:' + this.options.onhoverColor + ';' +
			'}';
		}

		return this.css + style;
	};

	Tree.prototype.template = {
		list: '<ul class="list-group" style="font-size:12px;"></ul>',
		item: '<li class="list-group-item"></li>',
		spanFormat: '<span class="{0}"></span>',
		listFormat: '<ul class="{0}"></ul>',
		divFormat: '<div class="{0}"></div>',
		btnFormat:'<button type="button" class="{0}"></button>',
		link: '<a href="#" style="color:inherit;"></a>',
		span: '<span></span>',
		check: '<input type="checkbox" name="popDelete1" value="checkbox">',
		checkLabel: '<label class="check-icon "></label>',		
		talk: '<span class= "talk"><button type="button" class="icon_organ i_talk"></button></span>',
		call: '<span class= "call"><button type="button" class="icon_organ i_phone"></button></span>',
		kebob: '<span class= "kebob"><button type="button" class="icon_organ i_kebob"></button></span>',
		delete: '<span class= "btn_close"><button type="button" class="icon_organ i_select_close"></button></span>',
		presence: '<img class="presenceState" src="{0}" />',
		userImg: '<img class="userImg" namecard="Y" src="{0}" />',
		deptImg: '<img class="deptImg" src="{0}" />',
		company: '<button type="button" class="btn_company">{0}</button>'
	};

	Tree.prototype.css = '.treeview .list-group-item{cursor:pointer}.treeview span.indent{margin-left:10px;margin-right:10px}.treeview span.icon{width:12px;margin-right:5px}.treeview .node-disabled{color:silver;cursor:not-allowed}'

	/**
		Returns a single node object that matches the given node id.
		@param {Number} nodeId - A node's unique identifier
		@return {Object} node - Matching node
	*/
	Tree.prototype.getNode = function (nodeId) {
		return this.nodes[nodeId];
	};

	/**
		Returns the parent node of a given node, if valid otherwise returns undefined.
		@param {Object|Number} identifier - A valid node or node id
		@returns {Object} node - The parent node
	*/
	Tree.prototype.getParent = function (identifier) {
		var node = this.identifyNode(identifier);
		return this.nodes[node.parentId];
	};

	/**
		Returns an array of sibling nodes for a given node, if valid otherwise returns undefined.
		@param {Object|Number} identifier - A valid node or node id
		@returns {Array} nodes - Sibling nodes
	*/
	Tree.prototype.getSiblings = function (identifier) {
		var node = this.identifyNode(identifier);
		var parent = this.getParent(node);
		var nodes = parent ? parent.nodes : this.tree;
		return nodes.filter(function (obj) {
				return obj.nodeId !== node.nodeId;
			});
	};

	/**
		Returns an array of selected nodes.
		@returns {Array} nodes - Selected nodes
	*/
	Tree.prototype.getSelected = function () {
		return this.findNodes('true', 'g', 'state.selected');
	};

	/**
		Returns an array of unselected nodes.
		@returns {Array} nodes - Unselected nodes
	*/
	Tree.prototype.getUnselected = function () {
		return this.findNodes('false', 'g', 'state.selected');
	};

	/**
		Returns an array of expanded nodes.
		@returns {Array} nodes - Expanded nodes
	*/
	Tree.prototype.getExpanded = function () {
		return this.findNodes('true', 'g', 'state.expanded');
	};

	/**
		Returns an array of collapsed nodes.
		@returns {Array} nodes - Collapsed nodes
	*/
	Tree.prototype.getCollapsed = function () {
		return this.findNodes('false', 'g', 'state.expanded');
	};

	/**
		Returns an array of checked nodes.
		@returns {Array} nodes - Checked nodes
	*/
	Tree.prototype.getChecked = function () {
		return this.findNodes('true', 'g', 'state.checked');
	};

	/**
		Returns an array of unchecked nodes.
		@returns {Array} nodes - Unchecked nodes
	*/
	Tree.prototype.getUnchecked = function () {
		return this.findNodes('false', 'g', 'state.checked');
	};

	/**
		Returns an array of disabled nodes.
		@returns {Array} nodes - Disabled nodes
	*/
	Tree.prototype.getDisabled = function () {
		return this.findNodes('true', 'g', 'state.disabled');
	};

	/**
		Returns an array of enabled nodes.
		@returns {Array} nodes - Enabled nodes
	*/
	Tree.prototype.getEnabled = function () {
		return this.findNodes('false', 'g', 'state.disabled');
	};


	/**
		Set a node state to selected
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.selectNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setSelectedState(node, true, options);
		}, this));

		this.render();
	};

	/**
		Set a node state to unselected
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.unselectNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setSelectedState(node, false, options);
		}, this));

		this.render();
	};

	/**
		Toggles a node selected state; selecting if unselected, unselecting if selected.
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.toggleNodeSelected = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.toggleSelectedState(node, options);
		}, this));

		this.render();
	};


	/**
		Collapse all tree nodes
		@param {optional Object} options
	*/
	Tree.prototype.collapseAll = function (options) {
		var identifiers = this.findNodes('true', 'g', 'state.expanded');
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setExpandedState(node, false, options);
		}, this));

		this.render();
	};

	/**
		Collapse a given tree node
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.collapseNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setExpandedState(node, false, options);
		}, this));

		this.render();
	};

	/**
		Expand all tree nodes
		@param {optional Object} options
	*/
	Tree.prototype.expandAll = function (options) {
		options = $.extend({}, _default.options, options);

		if (options && options.levels) {
			this.expandLevels(this.tree, options.levels, options);
		}
		else {
			var identifiers = this.findNodes('false', 'g', 'state.expanded');
			this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
				this.setExpandedState(node, true, options);
			}, this));
		}

		this.render();
	};

	/**
		Expand a given tree node
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.expandNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setExpandedState(node, true, options);
			if (node.nodes && (options && options.levels)) {
				this.expandLevels(node.nodes, options.levels-1, options);
			}
		}, this));

		this.render();
	};

	Tree.prototype.expandLevels = function (nodes, level, options) {
		options = $.extend({}, _default.options, options);

		$.each(nodes, $.proxy(function (index, node) {
			this.setExpandedState(node, (level > 0) ? true : false, options);
			if (node.nodes) {
				this.expandLevels(node.nodes, level-1, options);
			}
		}, this));
	};

	/**
		Reveals a given tree node, expanding the tree from node to root.
		@param {Object|Number|Array} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.revealNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			var parentNode = this.getParent(node);
			while (parentNode) {
				this.setExpandedState(parentNode, true, options);
				parentNode = this.getParent(parentNode);
			};
		}, this));

		this.render();
	};

	/**
		Toggles a nodes expanded state; collapsing if expanded, expanding if collapsed.
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.toggleNodeExpanded = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.toggleExpandedState(node, options);
		}, this));
		
		this.render();
	};


	/**
		Check all tree nodes
		@param {optional Object} options
	*/
	Tree.prototype.checkAll = function (options) {
		var identifiers = this.findNodes('false', 'g', 'state.checked');
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setCheckedState(node, true, options);
		}, this));

		this.render();
	};

	/**
		Check a given tree node
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.checkNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setCheckedState(node, true, options);
		}, this));
	};

	/**
		Uncheck all tree nodes
		@param {optional Object} options
	*/
	Tree.prototype.uncheckAll = function (options) {
		var identifiers = this.findNodes('true', 'g', 'state.checked');
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setCheckedState(node, false, options);
		}, this));
	};

	/**
		Uncheck a given tree node
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.uncheckNode = function (identifiers, options) {		//
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setCheckedState(node, false, options);
		}, this));
	};

	/**
		Toggles a nodes checked state; checking if unchecked, unchecking if checked.
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.toggleNodeChecked = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.toggleCheckedState(node, options);
		}, this));
	};


	/**
		Disable all tree nodes
		@param {optional Object} options
	*/
	Tree.prototype.disableAll = function (options) {
		var identifiers = this.findNodes('false', 'g', 'state.disabled');
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setDisabledState(node, true, options);
		}, this));

		this.render();
	};

	/**
		Disable a given tree node
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.disableNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setDisabledState(node, true, options);
		}, this));

		this.render();
	};

	/**
		Enable all tree nodes
		@param {optional Object} options
	*/
	Tree.prototype.enableAll = function (options) {
		var identifiers = this.findNodes('true', 'g', 'state.disabled');
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setDisabledState(node, false, options);
		}, this));

		this.render();
	};

	/**
		Enable a given tree node
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.enableNode = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setDisabledState(node, false, options);
		}, this));

		this.render();
	};

	/**
		Toggles a nodes disabled state; disabling is enabled, enabling if disabled.
		@param {Object|Number} identifiers - A valid node, node id or array of node identifiers
		@param {optional Object} options
	*/
	Tree.prototype.toggleNodeDisabled = function (identifiers, options) {
		this.forEachIdentifier(identifiers, options, $.proxy(function (node, options) {
			this.setDisabledState(node, !node.state.disabled, options);
		}, this));

		this.render();
	};


	/**
		Common code for processing multiple identifiers
	*/
	Tree.prototype.forEachIdentifier = function (identifiers, options, callback) {

		options = $.extend({}, _default.options, options);

		if (!(identifiers instanceof Array)) {
			identifiers = [identifiers];
		}

		$.each(identifiers, $.proxy(function (index, identifier) {
			callback(this.identifyNode(identifier), options);
		}, this));	
	};

	/*
		Identifies a node from either a node id or object
	*/
	Tree.prototype.identifyNode = function (identifier) {
		return ((typeof identifier) === 'number') ?
						this.nodes[identifier] :
						identifier;
	};

	/**
		Searches the tree for nodes (text) that match given criteria
		@param {String} pattern - A given string to match against
		@param {optional Object} options - Search criteria options
		@return {Array} nodes - Matching nodes
	*/
	Tree.prototype.search = function (pattern, options) {
		options = $.extend({}, _default.searchOptions, options);

		this.clearSearch({ render: false });

		var results = [];
		if (pattern && pattern.length > 0) {

			if (options.exactMatch) {
				pattern = '^' + pattern + '$';
			}

			var modifier = 'g';
			if (options.ignoreCase) {
				modifier += 'i';
			}

			results = this.findNodes(pattern, modifier);

			// Add searchResult property to all matching nodes
			// This will be used to apply custom styles
			// and when identifying result to be cleared
			$.each(results, function (index, node) {
				if (!options.noUseStyle)
					node.searchResult = true;
			})
		}
		else {
			this.collapseAll(options);
		}

		// If revealResults, then render is triggered from revealNode
		// otherwise we just call render.
		if (options.revealResults) {
			this.revealNode(results);
		}
		else {
			this.render();
		}

		this.$element.trigger('searchComplete', $.extend(true, {}, results));

		return results;
	};

	/**
		Clears previous search results
	*/
	Tree.prototype.clearSearch = function (options) {

		options = $.extend({}, { render: true }, options);

		var results = $.each(this.findNodes('true', 'g', 'searchResult'), function (index, node) {
			node.searchResult = false;
		});

		if (options.render) {
			this.render();	
		}
		
		this.$element.trigger('searchCleared', $.extend(true, {}, results));
	};

	/**
		Find nodes that match a given criteria
		@param {String} pattern - A given string to match against
		@param {optional String} modifier - Valid RegEx modifiers
		@param {optional String} attribute - Attribute to compare pattern against
		@return {Array} nodes - Nodes that match your criteria
	*/
	Tree.prototype.findNodes = function (pattern, modifier, attribute) {
		modifier = modifier || 'g';
		attribute = attribute || 'value'; // || 'CN';
		var _this = this;
		return $.grep(this.nodes, function (node) {
			var val = _this.getNodeValue(node, attribute);
			if (typeof val === 'string') {
				return val.match(new RegExp(pattern, modifier));
			}
		});
	};

	/**
		Recursive find for retrieving nested attributes values
		All values are return as strings, unless invalid
		@param {Object} obj - Typically a node, could be any object
		@param {String} attr - Identifies an object property using dot notation
		@return {String} value - Matching attributes string representation
	*/
	Tree.prototype.getNodeValue = function (obj, attr) {
		var index = attr.indexOf('.');
		if (index > 0) {
			var _obj = obj[attr.substring(0, index)];
			var _attr = attr.substring(index + 1, attr.length);
			return this.getNodeValue(_obj, _attr);
		}
		else {
			if (obj.hasOwnProperty(attr)) {
				return obj[attr].toString();
			}
			else {
				return undefined;
			}
		}
	};
	var logError = function (message) {
		if (window.console) {
			window.console.error(message);
		}
	};

	// Prevent against multiple instantiations,
	// handle updates and method calls
	$.fn[pluginName] = function (options, args) {
		var result;
		this.each(function () {
			var _this = $.data(this, pluginName);
			if (typeof options === 'string') {
				if (!_this) {
					logError('Not initialized, can not call method : ' + options);
				}
				else if (!$.isFunction(_this[options]) || options.charAt(0) === '_') {
					logError('No such method : ' + options);
				}
				else {
					if (!(args instanceof Array)) {
						args = [ args ];
					}
					result = _this[options].apply(_this, args);
				}
			}
			else if (typeof options === 'boolean') {
				result = _this;
			}
			else {
				$.data(this, pluginName, new Tree(this, $.extend(true, {}, options)));
			}
		});

		return result || this;
	};
	Tree.prototype.GetDeptSubTreeInfo = function (node) {
		console.log("GetDeptSubTreeInfo");
		var jsonParam = {
			deptid: node.data2,
			topid: node.data2,
			prop: property,
			type: "DEPT"
		};
		console.log("ajax param:", jsonParam);
		var rtnNode = node;
		$.ajax({
			url: "/ezOrgan/getTotalTreeInfo.do",
			method: "POST",
			data: JSON.stringify(jsonParam),
			contentType: "application/json; charset=UTF-8",
			dataType: "json",
			async: false,
			success: function (response) {
				if (response && response[0] && response[0].nodes) {
					rtnNode.nodes = response[0].nodes;
				} else {
					rtnNode.nodes = [];
				}
				if (typeof this.setInitialStates === "function")
					this.setInitialStates(rtnNode, rtnNode.nodeLevel);
			}.bind(this)
		});

		return rtnNode;
	};

	Tree.prototype.getCheckedNodes = function (options) {
		var nodes = this.findNodes('true', 'g', 'state.checked');
		return nodes;
	};
	Tree.prototype.treeViewScrollTo = function () {
		try {
			if ($('body')[0].offsetWidth < 759 || is_init) {	// 모바일화면, 웹 검색시 해당 부서트리로 스크롤 이동
				this.$element[0].parentElement.scrollTop = this.$element[0].querySelector(".node-selected").offsetTop - this.$element[0].offsetTop;
			}
			
		} catch (e) { }
	};

	Tree.prototype.ExtUserAdd = function (node) {
		if (!this.nodes) {
			this.nodes = [];
		}
		var addNodes = [];
		var addNode = clone(node);
		addNodes.nodes = [];
		addNodes.nodes.push(addNode);
		this.setInitialStates(addNodes);
		this.buildTree(this.nodes, 0, "SEL");

	};
	Tree.prototype.ExtUserDel = function (node) {		
		var _this = this;
		if (!_this.nodes) {
			_this.nodes = [];
		}
		var addNodes = [];
		var addNode = clone(node);
		addNodes.push(addNode);

		
		_this.buildTree(addNodes, 0, "DEL");
		 //선택 리스트 재정렬
		_this.nodes.splice(_this.findNodes(node.data2, 'g', 'data2')[0].nodeId, 1);
		$.each(_this.nodes, function initNodeId(index, node) {
			node.nodeId = index;
			$(_this.$element[0].querySelector("li[data2='" + node.data2 + "']")).attr("data-nodeid", index);			
		});
	};
	Tree.prototype.getNodeAll = function () {
		if (!this.nodes) {
			this.nodes = [];
		}
		return this.nodes;
	};

	String.prototype.formatTreeView = function () {
		var formatted = this;
		for (var arg in arguments) {
			formatted = formatted.replace("{" + arg + "}", arguments[arg]);
		}
		return formatted;
	};
})(jQuery, window, document);


function clone(obj) {
	if (obj === null || typeof obj !== 'object') {
		return obj;
	}

	const result = Array.isArray(obj) ? [] : {};

	for (let key of Object.keys(obj)) {
		result[key] = clone(obj[key])
	}

	return result;
}
function hpFormatHiddenByRegx(hp) {
	var pattern = /^(\d{3})-?(\d{1,2})\d{3}-?(\d{1,2})(\d{3})$/;
	var result = "";
	if (!hp) return result;

	if (pattern.test(hp)) {
		result = hp.replace(pattern, '$1-$2***-***$3');
	} else {
		result = hp;
	}
	return result;
}


function makeJsonData(pElmData, nodeLevel) {
	var data = [];

	make(pElmData, data, nodeLevel);

	return data;
}
function make(nodes, data, nodeLevel) {
	nodeLevel += 1;
	var arrNodes = GetChildNodes(nodes);
	for (var i = 0; i < arrNodes.length; i++) {
		if (arrNodes[i].nodeName.toUpperCase() == "NODE") {
			if (SelectSingleNodeValue(arrNodes[i], "VALUE").replace(/ /gi, "") != "\n")
				var strNodeNM = SelectSingleNodeValue(arrNodes[i], "VALUE");
			else
				var strNodeNM = "　　　";
			var obj = {
				cn: SelectSingleNodeValue(arrNodes[i], "CN"),
				value: strNodeNM,
				nodeLevel: nodeLevel,
				isLeaf: SelectSingleNodeValue(arrNodes[i], "ISLEAF") // 하위부서 여부 판단 TRUE : 하위부서 없음 / FALSE : 하위부서 있음
			};
			if (SelectSingleNode(arrNodes[i], "NODES") != null) {   // 하위부서가 있는경우
				obj.nodes = [];
				make(SelectSingleNode(arrNodes[i], "NODES"), obj.nodes, nodeLevel);
			}
		}
		data.push(obj);
	}
}