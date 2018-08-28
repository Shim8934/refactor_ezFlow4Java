//Baonk 2018-06-14

function CabinetTree() {
	//private variables
	var _treeElmtId   = null;
	var _genType      = "normal";
	var _companyId    = null;
	var _initialUrl   = null;
	var _getSubUrl    = null;
	var _shareUrl     = null;
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
	var _userIcon     = null;
	
	//set public functions
	this.makeTree     = getInitalData;
	this.setTreeInfo  = setTreeInfo;
	
	//privileged functions
	function setTreeInfo(data) {
		_treeElmtId  = data["treeId"];
		_treeType    = data["treeType"];
		_initialUrl  = data["initialUrl"];
		_getSubUrl   = data["extendUrl"];
		_shareUrl    = data["shareUrl"];
		_clickHandle = data["click"];
		_dblClickHdl = data["dblClick"];
		_companyId   = data["companyId"];
		_genType     = data["type"]     ? data["type"]     : _genType;
		_transImg    = data["transImg"] ? data["transImg"] : "/images/OrganTree_cross/dot_continue.gif";
		_plusImg     = data["plus"]     ? data["plus"]     : "/images/OrganTree_cross/plus.gif";
		_minusImg    = data["minus"]    ? data["minus"]    : "/images/OrganTree_cross/minus.gif";
		_userIcon    = "/images/OrganTree_cross/ic-open.gif";
		
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
			case "cabinet":
				_nodeId    = "cabinetId";
				_nodeName  = "cabinetName";
				_levelName = "cabinetLevel";
				_nodeSub   = "subList";
				_rootImg   = "/images/webfolder/fldr.png";
				_nodeImg   = "/images/webfolder/fldr.png";
				_name1     = "cabinetName1";
				_name2     = "cabinetName2";
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
			case 1 : alert(CabinetMessages.strParamErr) ; return;
			case 2 : alert(CabinetMessages.strError)    ; return;
			case 4 : while (divTree.hasChildNodes()) {divTree.removeChild(divTree.lastChild);}
					 alert(CabinetMessages.strTreeErr2) ; return;
			case 5 : alert(CabinetMessages.strShareErr2); return;
		}
		
		var nodesTree   = data.tree;
		var currentNode = data.node;
		if (!nodesTree) {alert(CabinetMessages.strTreeErr); return;}
		
		switch(_genType) {
			case "normal":
				var divNode = document.createElement("div");
				generateSubTree(divTree, divNode, nodesTree);
				break;
			case "list":
			case "listshare":
				var len = nodesTree.length;
				
				if (len == 0 && _genType == "listshare") {alert(CabinetMessages.strTreeErr);}
				
				for (var i = 0; i < len; i++) {
					var divChildNode  = document.createElement("div");
					generateSubTree(divTree, divChildNode, nodesTree[i]);
				}
				break;
			case "share":
				var userLen  = nodesTree.length;
				
				for (var i = 0; i < userLen; i++) {
					var userDivNode  = document.createElement("div");
					generateShareList(divTree, userDivNode, nodesTree[i]);
				}
				
				var listElmts = divTree.firstElementChild.lastElementChild.firstElementChild.children;
				
				for (var i = 0, len = listElmts.length; i < len; i++) {
					if (listElmts[i].tagName.toLowerCase() == "span") {listElmts[i].click(); break;}
				}
				
				break;
		}
		
		if (currentNode) {document.getElementById(_treeElmtId).querySelector("span[role='" + currentNode +"']").click();}
	}
	
	function generateSubTree(divTree, divElmt, list) {
		var level         = -1;
		var divId = divTree.getAttribute("id");
		if (divId == _treeElmtId) {
			level = 0;
		}
		else {
			var parentElmt = divTree.parentElement;
			var listOfImgElmt = [].filter.call(parentElmt.querySelectorAll("img"), function(element){return element.parentNode == parentElmt;});
			level = (!listOfImgElmt || listOfImgElmt.length == 0) ? 1 : listOfImgElmt.length - 1;
		}
		
		if (level > 0) {
			for (var j = 0; j < level; j++) {
				var imgTag       = document.createElement("img");
				imgTag.src       = _transImg;
				imgTag.className = "cabinetImg";
				divElmt.appendChild(imgTag);
			}
		}
		
		var imgElmt = document.createElement("img");
		imgElmt.setAttribute("role", list[_nodeId]);
		imgElmt.setAttribute("level" , list[_levelName]);
		
		var imgElmt2       = document.createElement("img");
		imgElmt2.className = "cabinetImg";
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
			imgElmt.className = "cabinetImg";
		}
		else {
			imgElmt.onclick = function() {getSubNodes(this);};
			
			if (list[_nodeSub] == null) {
				imgElmt.src       = _plusImg;
				imgElmt.className = "cabinetPlus";
				return;
			}
			
			imgElmt.src       = _minusImg;
			imgElmt.className = "cabinetMinus";
			
			var len = list[_nodeSub].length;
			
			var newDivElmt = document.createElement("div");
			divElmt.appendChild(newDivElmt);
			
			for (var i = 0; i < len; i++) {
				var subDivElmt = document.createElement("div");
				generateSubTree(newDivElmt, subDivElmt, list[_nodeSub][i]);
			}
		}
	}
	
	function generateShareList(divTree, divElmt, list) {
		var imgElmt       = document.createElement("img");
		imgElmt.className = "cabinetPlus";
		imgElmt.setAttribute("role", list["userId"]);
		imgElmt.onclick = function() {getUserSharedCabinet(this);};
		
		var imgElmt2       = document.createElement("img");
		imgElmt2.className = "cabinetImg";
		imgElmt2.src       = _userIcon;
		
		var spanDeptName         = document.createElement("span");
		spanDeptName.textContent = list["userName"];
		spanDeptName.setAttribute("title", list["userName"] + "[" + list["deptName"] + "]");
		spanDeptName.className   = "spanName";
		spanDeptName.setAttribute("role", list["userId"]);
		spanDeptName.addEventListener("click", function(e) {getUserSelected(this);}, false);
		
		divElmt.appendChild(imgElmt);
		divElmt.appendChild(imgElmt2);
		divElmt.appendChild(spanDeptName);
		divTree.appendChild(divElmt);
		
		if (list["sharedCabinet"] && list["sharedCabinet"].length > 0) {
			imgElmt.className = "cabinetMinus";
			imgElmt.src       = _minusImg;
			var newDivElmt    = document.createElement("div");
			divElmt.appendChild(newDivElmt);
			
			for (var j = 0, len = list["sharedCabinet"].length; j < len; j++) {
				var subDiv = document.createElement("div");
				generateSubTree(newDivElmt, subDiv, list["sharedCabinet"][j]);
			}
		}
		else {
			imgElmt.className = "cabinetPlus";
			imgElmt.src       = _plusImg;
		}
	}
	
	function getUserSharedCabinet(obj) {
		var parentDiv   = obj.parentElement;
		var divChildren = parentDiv.getElementsByTagName("div").length;
		
		if (divChildren > 0) {
			var childElmt = parentDiv.lastElementChild;
			
			if (obj.className == "cabinetMinus") {
				obj.src                 = _plusImg;
				obj.className           = "cabinetPlus";
				childElmt.style.display = "none";
			}
			else {
				obj.src                 = _minusImg;
				obj.className           = "cabinetMinus";
				childElmt.style.display = "";
			}
		}
		else {
			obj.src       = _minusImg;
			obj.className = "cabinetMinus";
			var userId    = obj.getAttribute("role");
			var dataInf   = {"shareId" : userId};
			
			makeAjaxCall(dataInf, "GET", _shareUrl, makeSubTree, null, true, parentDiv);
		}
	}
	
	function getUserSelected(spanObj) {
		var imgElmt = spanObj.parentElement.firstElementChild;
		imgElmt.click();
	}
	
	function getSubNodes(obj) {
		var parentDiv   = obj.parentElement;
		var divChildren = parentDiv.getElementsByTagName("div").length;
		var nodeId      = obj.getAttribute("role");
		var level       = obj.getAttribute("level");
		
		if (divChildren > 0) {
			var childElmt = parentDiv.lastElementChild;
			
			if (obj.className == "cabinetMinus") {
				obj.src                 = _plusImg;
				obj.className           = "cabinetPlus";
				childElmt.style.display = "none";
			}
			else {
				obj.src                 = _minusImg;
				obj.className           = "cabinetMinus";
				childElmt.style.display = "";
			}
		}
		else {
			obj.src       = _minusImg;
			obj.className = "cabinetMinus";
			var deptData  = {"nodeId" : nodeId, "level" : level};
			
			makeAjaxCall(deptData, "GET", _getSubUrl, makeSubTree, null, true, parentDiv);
		}
	}
	
	function makeSubTree(data, divElmt) {
		var resultData = data.subNodes;
		
		if (resultData == null) {alert(CabinetMessages.strTreeErr); return;}
		
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
		
		if (previousElmt != null) {
			previousElmt.className = "spanName";
			
			/*if (previousElmt.getAttribute("role") != selectElmt.getAttribute("role")) {
				previousElmt.className = "spanName";
			}
			else {
				return;
			}*/
		}
		
		selectElmt.className = "selectedNode";
	}
	
	function makeAjaxCall(ajaxData, ajaxType, ajaxUrl, handleSuccess, handleError, asyncMode, extenParam) {
		$.ajax({
			type: ajaxType,
			url: ajaxUrl,
			data: ajaxData,
			dataType: "JSON",
			async: asyncMode != false ? true : false,
			success : function(data) {
				handleSuccess(data, extenParam);
			},
			error : function(error) {
				if (handleError != null) {handleError();}
				
				alert(CabinetMessages.strError);
			}
		});
	}
}