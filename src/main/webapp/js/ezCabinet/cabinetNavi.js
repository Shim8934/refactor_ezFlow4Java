//Baonk 2018-06-25
var CabinetNavi = function() {
	return function(data) {
		var _blockSize      = 10;
		var _currentPage    = 0;
		var _totalRows      = 0;
		var _totalPages     = 0;
		var _behindDivId    = data.divId    ? data.divId    : "tblPageRayer";
		var _divClass       = data.divClass ? data.divClass : "pagenavi";
		var _spanClass      = "ptxt";
		var _imgClass       = "btnimg";
		var _selectedClass  = "on";
		var _headerId       = data.headerId ? data.headerId : "";
		var _searchCallBack = data.callback ? data.callback : null;
		var _messages       = data.messages ? data.messages : {
			next     : "Next",
			previous : "Previous",
			item     : "Items",
			total    : "Total"
		};
		
		//define private method
		function setBlockSize(blockSizeValue) {_blockSize = blockSizeValue;}
		function setDivInfo(behindDivId) {_behindDivId = behindDivId;}
		
		function getCurrentInfo() {
			var infor = {};
			infor.currentPage = _currentPage;
			infor.blockSize   = _blockSize;
			infor.totalRows   = _totalRows;
			infor.totalPages  = _totalPages;
			return infor;
		}
		
		function makePage() {
			if (_searchCallBack == null) {alert("Please provide search function!"); return;}
			
			var behindDiv = document.getElementById(_behindDivId);
			if (!behindDiv) {alert("Cannot found element with this id: " + _behindDivId); return;}
			
			behindDiv.innerHTML = "";
			setPageNavForElmt(behindDiv);
		}
		
		function setPageNavForElmt(targetDivElmt) {
			//Set element
			var divElmt       = document.createElement("div");
			_currentPage      = _currentPage == 0 ? 1 : _currentPage;
			var pageNum       = _currentPage;
			divElmt.className = _divClass;
			var spanElmt1     = document.createElement("span");
			var spanElmt2     = document.createElement("span");
			var spanElmt3     = document.createElement("span");
			var spanElmt4     = document.createElement("span");
			var prevClass = " prev";
			var nextClass = " next";
			var firstClass = " first";
			var lastClass = " last";
            
			spanElmt1.className = _imgClass + firstClass ;
			spanElmt2.className = _imgClass + prevClass;
			spanElmt3.className = _imgClass + nextClass;
			spanElmt4.className = _imgClass + lastClass;
			
			spanElmt1.onclick = function(e) {goToPageByNum(1);};
			spanElmt2.onclick = function(e) {selbeforeBlock();}
			spanElmt3.onclick = function(e) {selafterBlock();}
			spanElmt4.onclick = function(e) {goToPageByNum(_totalPages);};
            
			if (_totalPages > _blockSize) {
                if (pageNum <= _blockSize) {
                    spanElmt2.classList.add("disabled");
                }

                if ((_totalPages < parseInt(((parseInt((pageNum - 1) / _blockSize) + 1) * _blockSize) + 1))) {
                    spanElmt3.classList.add("disabled");
                }
			}
			else {
                spanElmt2.classList.add("disabled");
                spanElmt3.classList.add("disabled");
			}
			
			if (_totalPages > 1) {
                if (pageNum == 1) {
                    spanElmt1.classList.add("disabled");
                }
                
                if (_totalPages == pageNum) {
                    spanElmt4.classList.add("disabled");
                }
			}
			else {
                spanElmt1.classList.add("disabled");
                spanElmt4.classList.add("disabled");
			}
			
			divElmt.appendChild(spanElmt1);
			divElmt.appendChild(spanElmt2);
			
			var startNum = (parseInt((pageNum - 1) / _blockSize) * _blockSize) + 1;
			var maxNum   = (_totalPages >= (startNum + parseInt(_blockSize))) ? (startNum + parseInt(_blockSize)) - 1 : _totalPages;
			maxNum       = maxNum == 0 ? 1 : maxNum;
			
			for (var i = startNum; i <= maxNum; i++) {
				var spanElmt         = document.createElement("span");
				spanElmt.textContent = i;
				
				if (i == pageNum) {spanElmt.className = _selectedClass;}
				spanElmt.onclick = function(e) {goToPageByNum(this.textContent);}
				divElmt.appendChild(spanElmt);
			}
			
			divElmt.appendChild(spanElmt3);
			divElmt.appendChild(spanElmt4);
			targetDivElmt.appendChild(divElmt);
		}
		
		function goToPageByNum(pageValue) {
			if (pageValue == _currentPage || _totalPages == 0) {return;}
			
			_currentPage = pageValue;
			makePage();
			_searchCallBack(_currentPage);
		}
		
		function selbeforeBlock() {
			if (_currentPage < _blockSize || _totalPages == 0) {return;}
			
			var pageNum = parseInt(_currentPage);
			pageNum     = parseInt((pageNum - 1)/ _blockSize) * _blockSize;
			goToPageByNum(pageNum);
		}
		
		function selbeforeBlock_one(){
			var pageNum = parseInt(_currentPage);
			if (pageNum <= 1) {return;}
			
			goToPageByNum(pageNum - 1);
		}
		
		function selafterBlock(){
			var pageNum = parseInt(_currentPage);
			pageNum     = ((parseInt((pageNum - 1) / _blockSize) + 1) * _blockSize) + 1;
			
			if (pageNum > _totalPages || _totalPages == 0) {return;}
			
			goToPageByNum(pageNum);
		}
		
		function selafterBlock_one(){
			var pageNum = parseInt(_currentPage);
			if(pageNum + 1 > _totalPages || _totalPages == 0) {return;}
			
			goToPageByNum(pageNum + 1);
		}
		
		function renderPageWithInfo(currentPageVal, totalRowsVal, totalPagesVal) {
			_currentPage = currentPageVal;
			_totalRows   = totalRowsVal;
			_totalPages  = totalPagesVal;
			setHeaderInfo();
			makePage();
		}
		
		function setHeaderInfo() {
			var headerElmt = document.getElementById(_headerId);
			if (headerElmt) {headerElmt.innerHTML = "<span> " + _totalRows + " </span>";}
		}
		
		function setSearchCallBack(functionName) {_searchCallBack = functionName;}
		
		//Set public api
		return {
			init     : renderPageWithInfo,
			header   : setHeaderInfo,
			search   : setSearchCallBack,
			get      : getCurrentInfo,
			setBlock : setBlockSize,
			setDivs  : setDivInfo,
			load     : makePage
		};
	}
}();
