//Baonk 2018-06-14

function CabinetTree() {
	//private variables
	var _treeElmtId   = null;
	var _companyId    = null;
	var _initialUrl   = null;
	var _getSubUrl    = null;
	var _clickHandle  = null;
	var _dblClickHdl  = null;
	
	//set public functions
	this.makeTree     = getInitalData;
	this.setCompanyId = setCompanyId;
	this.setTreeInfo  = setTreeInfo;
	
	//privileged functions
	function setTreeInfo(data) {
		_treeElmtId  = data["treeId"];
		_initialUrl  = data["initialUrl"];
		_getSubUrl   = data["extendUrl"];
		_clickHandle = data["click"];
		_dblClickHdl = data["dblClick"];
		_companyId   = data["companyId"];
	}
	
	function setCompanyId(compId) {_companyId = compId;}
	
	function getInitalData() {
		var data = {companyId : _companyId};
		makeAjaxCall(data, "GET", _initialUrl, makeTree, null, true, null);
	}
	
	function makeTree(data) {
		var companyTree = data.tree;
		var currentNode = data.node;
		
		if (!companyTree) {alert(CabinetMessages.strTreeErr); return;}
		
		var divTree = document.getElementById(_treeElmtId);
		
		if (!divTree) {alert("Cannot find element with this id: " + _treeElmtId); return;}
		
		var divComp = document.createElement("div");
		
		while (divTree.hasChildNodes()) {divTree.removeChild(divTree.lastChild);}
		
		generateSubTree(divTree, divComp, companyTree);
		
		if (currentNode) {
			var spanElmt = document.getElementsByName(currentNode)[0];
			getSelected(spanElmt);
			if (_clickHandle != null) {_clickHandle(spanElmt);}
		}
	}
	
	function generateSubTree(divTree, divElmt, list) {
		var level = list["level"];
		
		if (level > 0) {
			for (var j = 0; j < level; j++) {
				var imgTag = document.createElement("img");
				imgTag.setAttribute("class", "cabinetImg");
				imgTag.src="/images/OrganTree_cross/dot_continue.gif";
				divElmt.appendChild(imgTag);
			}
		}
		
		var imgElmt = document.createElement("img");
		imgElmt.setAttribute("id" , list["deptId"]);
		imgElmt.setAttribute("level" , list["level"]);
		
		var imgElmt2 = document.createElement("img");
		imgElmt2.setAttribute("class", "cabinetImg");
		imgElmt2.src = level > 0 ? "/images/OrganTree_cross/ic-open.gif" : "/images/OrganTree_cross/ic-company.gif";
		
		var spanDeptName         = document.createElement("span");
		spanDeptName.textContent = list["deptName"];
		spanDeptName.setAttribute("class", "spanName");
		spanDeptName.setAttribute("name", list["deptId"]);
		spanDeptName.setAttribute("level", list["level"]);
		spanDeptName.addEventListener("click", function(e) {getSelected(this);}, false);
		if (_clickHandle != null) {spanDeptName.addEventListener("click", function(e) {_clickHandle(this);}, false);}
		if (_dblClickHdl != null) {spanDeptName.ondblclick = function() {_dblClickHdl(this)};}
		
		divElmt.appendChild(imgElmt);
		divElmt.appendChild(imgElmt2);
		divElmt.appendChild(spanDeptName);
		divTree.appendChild(divElmt);
		
		if (list["hasSub"] == "0") {
			imgElmt.src = "/images/OrganTree_cross/dot_continue.gif";
			imgElmt.setAttribute("class", "cabinetImg");
		}
		else {
			imgElmt.onclick = function() {getSubNodes(this);};
			
			if (list["subDepts"] == null) {
				imgElmt.src = "/images/OrganTree_cross/plus.gif";
				imgElmt.setAttribute("class", "cabinetPlus");
				return;
			}
			
			imgElmt.src = "/images/OrganTree_cross/minus.gif";
			imgElmt.setAttribute("class", "cabinetMinus");
			
			var len = list["subDepts"].length;
			
			var newDivElmt = document.createElement("div");
			divElmt.appendChild(newDivElmt);
			
			for (var i = 0; i < len; i++) {
				var subDivElmt = document.createElement("div");
				generateSubTree(newDivElmt, subDivElmt, list["subDepts"][i]);
			}
		}
	}
	
	function getSubNodes(obj) {
		var parentDiv   = obj.parentElement;
		var divChildren = parentDiv.getElementsByTagName("div").length;
		var deptId      = obj.getAttribute("id");
		var level       = obj.getAttribute("level");
		
		if (divChildren > 0) {
			var childElmt = obj.parentElement.lastElementChild;
			
			if (obj.className == "cabinetMinus") {
				obj.src= "/images/OrganTree_cross/plus.gif";
				obj.setAttribute("class", "cabinetPlus");
				childElmt.style.display = "none";
			}
			else {
				obj.src= "/images/OrganTree_cross/minus.gif";
				obj.setAttribute("class", "cabinetMinus");
				childElmt.style.display = "";
			}
		}
		else {
			obj.src = "/images/OrganTree_cross/minus.gif";
			obj.setAttribute("class", "cabinetMinus");
			var deptData = {"deptId" : deptId, "level"  : level};
			
			makeAjaxCall(deptData, "GET", _getSubUrl, makeSubTree, null, true, obj.parentElement);
		}
	}
	
	function makeSubTree(data, divElmt) {
		var resultData = data.subNodes;
		
		if (resultData["subDepts"] == null) {alert(CabinetMessages.strTreeErr); return;}
		
		var len        = resultData["subDepts"].length;
		var newDivElmt = document.createElement("div");
		divElmt.appendChild(newDivElmt);
		
		for (var i = 0; i < len; i++) {
			var subDiv = document.createElement("div");
			generateSubTree(newDivElmt, subDiv, resultData["subDepts"][i]);
		}
	}
	
	function getSelected(selectElmt) {
		var previousElmt = document.getElementsByClassName("selectedNode")[0];
		
		if (previousElmt != null) {
			if (previousElmt.getAttribute("name") != selectElmt.getAttribute("name")) {
				previousElmt.className = "spanName";
			}
			else {
				return;
			}
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
				if (handleError != null) {
					handleError();
				}
				
				alert(CabinetMessages.strError);
			}
		});
	}
}