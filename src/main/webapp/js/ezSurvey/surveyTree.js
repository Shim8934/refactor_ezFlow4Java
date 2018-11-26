//Baonk 2018-06-14

function CabinetTree() {
	//private variables
	var _treeElmtId   = null;
	var _genType      = "normal";
	var _companyId    = null;
	var _initialUrl   = null;
	var _getSubUrl    = null;
	var _clickHandle  = null;
	var _dblClickHdl  = null;
	var _treeType     = null;
	var _nodeName     = null;
	var _nodeId       = null;
	var _levelName    = null;
	var _nodeSub      = null;
	var _rootImg      = null;
	var _nodeImg      = null;
	var _transImg     = null;
	var _plusImg      = null;
	var _minusImg     = null;
	var _name1        = null;
	var _name2        = null;
	var _strErr       = null;
	var _paramErr     = null;
	var _treeErr      = null;
	var _imgClass     = null;
	var _plusClass    = null;
	var _minClass     = null;
	
	//set public functions
	this.makeTree     = getInitalData;
	this.setTreeInfo  = setTreeInfo;
	
	//privileged functions
	function setTreeInfo(data) {
		_treeElmtId    = data["treeId"];
		_treeType      = data["treeType"];
		_initialUrl    = data["initialUrl"];
		_getSubUrl     = data["extendUrl"];
		_clickHandle   = data["click"];
		_dblClickHdl   = data["dblClick"];
		_companyId     = data["companyId"];
		_genType       = data["type"]      ? data["type"]       : _genType;
		_transImg      = data["transImg"]  ? data["transImg"]   : "/images/OrganTree_cross/dot_continue.gif";
		_plusImg       = data["plus"]      ? data["plus"]       : "/images/OrganTree_cross/plus.gif";
		_minusImg      = data["minus"]     ? data["minus"]      : "/images/OrganTree_cross/minus.gif";
		_imgClass      = data["imgclass"]  ? data["imgclass"]   : "";
		_plusClass     = data["plusclass"] ? data["plusclass"]   : "";
		_minClass      = data["minclass"]  ? data["minclass"]   : "";
		_strErr        = data["messages"]  ? data["messages"]["errStr"]   : "";
		_paramErr      = data["messages"]  ? data["messages"]["paramErr"] : "";
		_treeErr       = data["messages"]  ? data["messages"]["treeErr"]  : "";
		
		
		switch(_treeType) {
			case "organ": 
				_nodeId    = "deptId";
				_nodeName  = "deptName";
				_levelName = "level";
				_nodeSub   = "subDepts";
				_rootImg   = "/images/OrganTree_cross/ic-company.gif";
				_nodeImg   = "/images/OrganTree_cross/ic-open.gif";
				_name1     = "";
				_name2     = "";
				break;
		}
	}
	
	function getInitalData(params) {
		if (params && _treeType == "organ") {params.companyId = _companyId}
		makeAjaxCall(params, "GET", _initialUrl, makeTree, null, true, null);
	}
	
	function makeTree(data) {
		var divTree = document.getElementById(_treeElmtId);
		while (divTree.hasChildNodes()) {divTree.removeChild(divTree.lastChild);}
		
		if (!divTree) {alert("Cannot find element with this id: " + _treeElmtId); return;}
		
		var code = data.code;
		switch(code) {
			case 1 : alert(_paramErr) ; return;
			case 2 : alert(_strErr)   ; return;
		}
		
		var nodesTree   = data.tree;
		var currentNode = data.node;
		
		switch(_genType) {
			case "normal":
				if (!nodesTree) {alert(_treeErr); return;}
				var divNode = document.createElement("div");
				generateSubTree(divTree, divNode, nodesTree);
				break;
		}
		
		if (currentNode) {document.getElementById(_treeElmtId).querySelector("span[role='" + currentNode +"']").click();}
	}
	
	function generateSubTree(divTree, divElmt, list, index) {
		var level = -1;
		if (index) {
			level = index;
		}
		else {
			var divId = divTree.getAttribute("id");
			if (divId == _treeElmtId) {
				level = 0;
			}
			else {
				var parentElmt = divTree.parentElement;
				var listOfImgElmt = [].filter.call(parentElmt.querySelectorAll("img"), function(element){return element.parentNode == parentElmt;});
				level = (!listOfImgElmt || listOfImgElmt.length == 0) ? 1 : listOfImgElmt.length - 1;
			}
		}
		
		if (level > 0) {
			for (var j = 0; j < level; j++) {
				var imgTag       = document.createElement("img");
				imgTag.src       = _transImg;
				imgTag.className = _imgClass;
				divElmt.appendChild(imgTag);
			}
		}
		
		var imgElmt = document.createElement("img");
		imgElmt.setAttribute("role", list[_nodeId]);
		imgElmt.setAttribute("level" , list[_levelName]);
		
		var imgElmt2       = document.createElement("img");
		imgElmt2.className = _imgClass;
		imgElmt2.src       = level > 0 ? _nodeImg : _rootImg;
		
		var spanDeptName         = document.createElement("span");
		spanDeptName.textContent = list[_nodeName];
		spanDeptName.className   = "spanName";
		spanDeptName.setAttribute("role", list[_nodeId]);
		
		if (list[_name1]) {spanDeptName.setAttribute("name1", list[_name1]); spanDeptName.setAttribute("name2", list[_name2]);}
		
		spanDeptName.setAttribute("level", list[_levelName]);
		spanDeptName.addEventListener("click", function(e) {getSelected(this);}, false);
		
		if (_clickHandle != null) {spanDeptName.addEventListener("click", function(e) {_clickHandle(this);}, false);}
		if (_dblClickHdl != null) {spanDeptName.ondblclick = function() {_dblClickHdl(this)};}
		
		divElmt.appendChild(imgElmt);
		divElmt.appendChild(imgElmt2);
		divElmt.appendChild(spanDeptName);
		divTree.appendChild(divElmt);
		
		if (list["hasSub"] == "0") {
			imgElmt.src       = _transImg;
			imgElmt.className = _imgClass;
		}
		else {
			imgElmt.onclick = function() {getSubNodes(this);};
			
			if (list[_nodeSub] == null) {
				imgElmt.src       = _plusImg;
				imgElmt.className = _plusClass;
				return;
			}
			
			imgElmt.src       = _minusImg;
			imgElmt.className = _minClass;
			
			var len = list[_nodeSub].length;
			
			var newDivElmt = document.createElement("div");
			divElmt.appendChild(newDivElmt);
			
			for (var i = 0; i < len; i++) {
				var subDivElmt = document.createElement("div");
				generateSubTree(newDivElmt, subDivElmt, list[_nodeSub][i]);
			}
		}
	}
	
	function getSubNodes(obj) {
		var parentDiv   = obj.parentElement;
		var divChildren = parentDiv.getElementsByTagName("div").length;
		var nodeId      = obj.getAttribute("role");
		var level       = obj.getAttribute("level");
		
		if (divChildren > 0) {
			var childElmt = parentDiv.lastElementChild;
			
			if (obj.className == _minClass) {
				obj.src                 = _plusImg;
				obj.className           = _plusClass;
				childElmt.style.display = "none";
			}
			else {
				obj.src                 = _minusImg;
				obj.className           = _minClass;
				childElmt.style.display = "";
			}
		}
		else {
			obj.src       = _minusImg;
			obj.className = _minClass;
			var deptData  = {"nodeId" : nodeId, "level" : level};
			
			makeAjaxCall(deptData, "GET", _getSubUrl, makeSubTree, null, true, parentDiv);
		}
	}
	
	function makeSubTree(data, divElmt) {
		var resultData = data.subNodes;
		
		if (resultData == null) {alert(_treeErr); return;}
		
		var len        = resultData.length;
		var newDivElmt = document.createElement("div");
		divElmt.appendChild(newDivElmt);
		
		for (var i = 0; i < len; i++) {
			var subDiv = document.createElement("div");
			generateSubTree(newDivElmt, subDiv, resultData[i]);
		}
	}
	
	function getSelected(selectElmt) {
		var divTree      = document.getElementById(_treeElmtId);
		var previousElmt = divTree.querySelector("span[class='selectedNode']");
		if (previousElmt != null) {previousElmt.className = "spanName";}
		selectElmt.className = "selectedNode";
	}
	
	function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, extenParam) {
		$.ajax({
			type: ajaxType,
			url: ajaxUrl,
			data: ajaxData,
			dataType: "JSON",
			async: asyncMode != false ? true : false,
			cache: false,
			success : function(data) {
				handleSuccess(data, extenParam);
			},
			error : function(error) {
				if (handleError != null) {handleError();}
				
				alert(_strErr);
			}
		});
	}
}