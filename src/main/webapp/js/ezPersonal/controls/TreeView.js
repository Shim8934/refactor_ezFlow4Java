

var TreeIcons       = new Array();
var TreeIconSizes   = new Array();
var TreeClasses     = new Array();
var TreeImages      = new Array();

var _depth = 0;



function TreeNode() {
    this.NodeID = "";
    this.NodeName = "";
    this.NodeLevel = 0;
    this.EndNode = "";

    this.LoadFromID = LoadFromID;
    this.CreateTreeNode = CreateTreeNode;
    this.GetNodeData = GetNodeData;
    this.SetNodeData = SetNodeData;
    this.SetNodeName = SetNodeName;
    this.DeleteNode = DeleteNode;


    var _nodeDIV = null;

    
    function LoadFromID(pNodeID) {
        _nodeDIV = document.getElementById(pNodeID);

        if (_nodeDIV) {
            this.NodeID = pNodeID;
            this.NodeName = GetAttribute(_nodeDIV, "NODENAME");
            this.NodeLevel = GetAttribute(_nodeDIV, "NODELEVEL");
            this.EndNode = GetAttribute(_nodeDIV, "ENDNODE");
            return true;
        }
        else {
            
            return false;
        }
    }

    
    function GetNodeData(pDataName) {
        return GetAttribute(_nodeDIV, pDataName);
    }

    
    function SetNodeData(pDataName, value) {
        return SetAttribute(_nodeDIV, pDataName, value);
    }

    
    function SetNodeName(value) {
        document.getElementById("spn_" + this.NodeID).innerHTML = value;
    }

    
    function DeleteNode(treeViewID) {
        document.getElementById(treeViewID).setAttribute("SELECTNODEID", "");
        _nodeDIV.parentNode.removeChild(_nodeDIV);
    }

    
    function CreateTreeNode(pNodeData, pEndNode, pParentNode, pUseAgency, pNodeClick, pNodeDblClick, pRequestHandler) {

        var color = "";
        
        var treeDiv = document.createElement("DIV");
        treeDiv.className = "node_div";
        treeDiv.style.whiteSpace = "nowrap";
        treeDiv.id = this.NodeID;

        treeDiv.setAttribute("NODENAME", this.NodeName);
        treeDiv.setAttribute("NODELEVEL", this.NodeLevel);
        treeDiv.setAttribute("ENDNODE", String(pEndNode));

        
        var arrNodeData = GetChildNodes(pNodeData);
        for (var i = 0; i < arrNodeData.length; i++) {
            var strDataName = arrNodeData[i].tagName.toUpperCase();
            var strDataValue = SelectSingleNodeValue(pNodeData, strDataName);
            treeDiv.setAttribute(strDataName, strDataValue);

            if (strDataName == "DATA4" && strDataValue != "")
                color = strDataValue;

        }

        
        var bExpanded = false;

        var strExpanded = GetAttribute(treeDiv, "EXPANDED") != null ? GetAttribute(treeDiv, "EXPANDED") : "";
        if (strExpanded.toUpperCase() == "TRUE")
            bExpanded = true;

        
        var arrParentDotImg = GetParentDotImg(pParentNode);
        for (var i = 0; i < arrParentDotImg.length - 1; i++) {
            var imgDot = arrParentDotImg[i].cloneNode(true);
            imgDot.border = "0";
            imgDot.style.width = TreeIconSizes["width"];
            imgDot.style.height = TreeIconSizes["height"];
            imgDot.className = "DOT";

            treeDiv.innerHTML += imgDot.outerHTML;
        }

        
        var bParentEndNode = false;
        if (GetAttribute(pParentNode, "ENDNODE") != null ? GetAttribute(pParentNode, "ENDNODE").toLowerCase() : "" == "true")
            bParentEndNode = true;

        
        
        var iParentImgCnt = arrParentDotImg.length - 1;
        if (iParentImgCnt <= 0)
            iParentImgCnt = _depth;

        
        for (var i = iParentImgCnt; i < this.NodeLevel; i++) {
            var imgDot = document.createElement("IMG");
            imgDot.border = "0";
            imgDot.style.width = TreeIconSizes["width"];
            imgDot.style.height = TreeIconSizes["height"];
            imgDot.className = "DOT";

            if (i < this.NodeLevel) {
                if (bParentEndNode)
                    imgDot.src = TreeIcons["node_space"];
                else
                    imgDot.src = TreeIcons["dot_normal"];
            }

            if (i == this.NodeLevel - 1 && pEndNode == false)
                imgDot.src = TreeIcons["dot_continue"];

            if (i == this.NodeLevel - 1 && pEndNode == true)
                imgDot.src = TreeIcons["dot_end"];


            treeDiv.innerHTML += imgDot.outerHTML;
        }

        
        var imgNode = document.createElement("IMG");
        imgNode.id = "imgNode_" + this.NodeID;
        imgNode.border = "0";
        imgNode.style.width = TreeIconSizes["width"];
        imgNode.style.height = TreeIconSizes["height"];

        
        var strIsLeaf = GetAttribute(treeDiv, "ISLEAF");

        
        if (pUseAgency) {
            var strIconByName = GetAttribute(treeDiv, "SETNODEICONBYNAME") != null ? GetAttribute(treeDiv, "SETNODEICONBYNAME") : "";
            if (strIconByName.toUpperCase() != "ICONCOMP")
                pUseAgency = false;
        }

        
        if (strIsLeaf == "TRUE")
            imgNode.src = TreeIcons["node_end"];
        else if (bExpanded)
            imgNode.src = TreeIcons["node_minus"];
        else
            imgNode.src = TreeIcons["node_plus"];

        var strTreeID = this.NodeID.substring(0, this.NodeID.indexOf("_"));

        
        if (pRequestHandler != "" && strIsLeaf.toUpperCase() == "FALSE") {
            imgNode.style.cursor = "pointer";
            imgNode.setAttribute("onClick", "treeicon_toggle(\"" + this.NodeID + "\", \"" + strTreeID + "\", " + pRequestHandler + ", \"" + imgNode.id + "\");");
        }

        treeDiv.innerHTML += imgNode.outerHTML;
        
        
        var subImgNode = document.createElement("IMG");
        subImgNode.id = "subImgNode_" + this.NodeID;
        subImgNode.border = "0";
        subImgNode.style.width = TreeIconSizes["width"];
        subImgNode.style.height = TreeIconSizes["height"];
        subImgNode.src = pUseAgency ? TreeImages["iconcomp"] : TreeImages["base"];
        treeDiv.innerHTML += subImgNode.outerHTML;
        

        
        var spnNode = document.createElement("SPAN");
        var nodeText = document.createTextNode(this.NodeName);
        spnNode.appendChild(nodeText);

        spnNode.id = "spn_" + this.NodeID;
        spnNode.name = "spn_" + strTreeID;
        spnNode.className = TreeClasses["normal"];

        if (color != "")
            spnNode.setAttribute("style", "color:" + color);


        if (typeof (document.body.onselectstart) != "undefined") 
            spnNode.onselectstart = function () { return false; }
        else if (typeof (document.body.style.MozUserSelect) != "undefined") 
            spnNode.style.MozUserSelect = "none";

        
        if (pNodeClick != "") {
            spnNode.style.cursor = "pointer";
            spnNode.setAttribute("onClick", "node_select(\"" + this.NodeID + "\", \"\", \"" + strTreeID + "\", " + pNodeClick + ");");
        }

        
        if (strIsLeaf == "FALSE") {
            var strTreeID = this.NodeID.substring(0, this.NodeID.indexOf("_"));
            spnNode.style.cursor = "pointer";

            if (pRequestHandler == "")
                pRequestHandler = "null";

            if (pNodeDblClick != "")
                spnNode.setAttribute("ondblclick", "pNodeDblClick(\"" + this.NodeID + "\", \"" + this.NodeName + "\"); treeicon_toggle(\"" + this.NodeID + "\", \"" + strTreeID + "\", " + pRequestHandler + ", \"" + imgNode.id + "\");");
            else
                spnNode.setAttribute("ondblclick", "treeicon_toggle(\"" + this.NodeID + "\", \"" + strTreeID + "\", " + pRequestHandler + ", \"" + imgNode.id + "\");");
        }

        treeDiv.innerHTML += spnNode.outerHTML;

        
        var subDiv = document.createElement("DIV");
        subDiv.id = this.NodeID + "_sub";

        if (bExpanded)
            subDiv.style.display = "";
        else
            subDiv.style.display = "none";

        treeDiv.innerHTML += subDiv.outerHTML;

        return treeDiv;
    }

    
    function GetParentDotImg(pParentNode) {
        var arrDotImg = new Array();
        var arrImg = GetChildImageNodes(pParentNode);

        var idx = 0;
        for (var i = 0; i < arrImg.length; i++) {
            if (arrImg[i].className == "DOT") {
                arrDotImg[idx++] = arrImg[i];
            }
        }

        return arrDotImg;
    }

    
    function GetChildImageNodes(pParentNode) {
        var elements = new Array();

        if (window.DOMParser) {
            objNode = pParentNode.firstChild;

            var idx = 0;
            while (objNode) {
                if (objNode.toString() == "[object HTMLImageElement]" && objNode.tagName.toUpperCase() == "IMG") {
                    elements[idx++] = objNode;
                }

                objNode = objNode.nextSibling;
            }
        }
        else if (window.ActiveXObject) {
            var idx = 0;
            for (var i = 0; i < GetChildNodes_Tree(pParentNode).length; i++) {
                if (GetChildNodes_Tree(pParentNode)[i].tagName.toUpperCase() == "IMG") {
                    elements[idx++] = GetChildNodes_Tree(pParentNode)[i];
                }
            }
        }

        return elements;
    }
    function GetChildNodes_Tree(node) {
        var elements = new Array();
        objNode = node.firstChild;

        var idx = 0;
        while (objNode) {
            if (objNode.nodeType == 1) {
                elements[idx++] = objNode;
            }

            objNode = objNode.nextSibling;
        }
        return elements;
    }

}





function TreeView() {
    this.SetID = SetID;
    this.GetID = GetID;
    this.SetConfig = SetConfig;
    this.SetNodeClick = SetNodeClick;
    this.SetNodeDblClick = SetNodeDblClick;
    this.SetRequestData = SetRequestData;
    this.SetUseAgency = SetUseAgency;

    this.GetSelectNode = GetSelectNode;
    this.GetSelectNodeID = GetSelectNodeID;
    this.SetSelectNode = SetSelectNode;
    this.DisplaySelectNode = DisplaySelectNode;

    this.DataSource = DataSource;
    this.DataBind = DataBind;

    this.LoadFromID = LoadFromID;
    this.AppendChildNodes = AppendChildNodes;

    this.toString = TreeView_ToString;
    this.SetDepth = SetDepth;
    var _dataSource = null;
    var _thisID = "";
    var _nodeClick = "";
    var _nodeDblClick = "";
    var _requestDataHandler = "";
    var _selectedNodeID = "";
    var _selectedNodeNM = "";
    var _useAgency = true;     



    
    function SetID(pObjID) {
        if (pObjID != "")
            _thisID = pObjID;
    }
    
    
    function GetID() {
        return _thisID;
    }

    
    function DataSource(pDataSource) {
        _dataSource = pDataSource;
    }

    
    function SetNodeClick(pNodeClick) {
        _nodeClick = pNodeClick;
    }

    
    function SetNodeDblClick(pNodeDblClick) {
        _nodeDblClick = pNodeDblClick;
    }

    
    function SetRequestData(pHandler) {
        _requestDataHandler = pHandler;
    }

    
    function SetUseAgency(pUseAgency) {
        _useAgency = pUseAgency;
    }

    
    function LoadFromID(pTreeID) {
        _thisID = pTreeID;

        var oTree = document.getElementById(pTreeID);
        _nodeClick = GetAttribute(oTree, "NODECLICK");
        _nodeDblClick = GetAttribute(oTree, "NODEDBLCLICK");
        _requestDataHandler = GetAttribute(oTree, "REQUESTDATA");
    }

    
    function SetDepth(pdepth) {
        _depth = pdepth;
    }

    
    function DataBind(pTagetID) {
        if (_thisID == "") {
            alert("트리뷰의 ID가 지정되지 않았습니다.");
            return;
        }

        if (_dataSource == null) {
            alert("데이터가 지정되지 않았습니다.");
            return;
        }

        var objElm = document.getElementById(pTagetID);
        if (objElm) {
            var treeDiv = document.createElement("DIV");
            treeDiv.id = _thisID;
            treeDiv.setAttribute("NODECLICK", _nodeClick);
            treeDiv.setAttribute("NODEDBLCLICK", _nodeDblClick);
            treeDiv.setAttribute("REQUESTDATA", _requestDataHandler);

            var iLevel = 0;

            AppendTreeNode(_dataSource.documentElement, treeDiv, iLevel);

            objElm.appendChild(treeDiv);

            
            if (_selectedNodeID != "") {
                treeDiv.setAttribute("SELECTNODEID", _selectedNodeID);

                this.DisplaySelectNode();





                var oFunc = new Function("node_select(\"" + _selectedNodeID + "\", \"\", \"" + _thisID + "\", " + _nodeClick + ");");
                oFunc.call();
            }
        }
    }

    
    function AppendChildNodes(pSubData, pNodeID) {
        var oNode = document.getElementById(pNodeID);
        var strLevel = GetAttribute(oNode, "NODELEVEL");

        AppendTreeNode(pSubData, oNode, parseInt(strLevel) + 1);
    }

    function AppendTreeNode(pElmData, pNode, pLevel) {
        var arrNodes = GetChildNodes(pElmData);

        for (var i = 0; i < arrNodes.length; i++) {
            
            
            if (arrNodes[i].nodeName.toUpperCase() == "NODE") {

                
                var bEndNode = false;
                if (i == arrNodes.length - 1)
                    bEndNode = true;

                
                var strNodeID = pNode.id + "_" + i;
                
                if(SelectSingleNodeValue(arrNodes[i], "VALUE").replace(/ /gi, "") != "\n")
                    var strNodeNM = SelectSingleNodeValue(arrNodes[i], "VALUE");
                else
                    var strNodeNM = "　　　";

                
                var organNode = new TreeNode();
                organNode.NodeID = strNodeID;
                organNode.NodeName = strNodeNM;
                organNode.NodeLevel = pLevel;

                
                if (SelectSingleNode(arrNodes[i], "SELECT") != null) {
                    _selectedNodeID = strNodeID;
                    _selectedNodeNM = strNodeNM;
                }

                
                var treeNode = organNode.CreateTreeNode(arrNodes[i], bEndNode, pNode, _useAgency, _nodeClick, _nodeDblClick, _requestDataHandler);

                if (pLevel == 0)
                
                    pNode.appendChild(treeNode);
                else {
                    
                    var subDiv = pNode.childNodes[pNode.childNodes.length - 1];
                    subDiv.appendChild(treeNode);
                }

                
                if (SelectSingleNode(arrNodes[i], "NODES") != null)
                    AppendTreeNode(SelectSingleNode(arrNodes[i], "NODES"), treeNode, pLevel + 1);
            }
        }
    }

    
    function GetSelectNodeID() {
        var treeDiv = document.getElementById(_thisID);

        return GetAttribute(treeDiv, "SELECTNODEID");
    }

    
    function GetSelectNode() {
        var selNodeID = GetSelectNodeID();
        var selNode = new TreeNode();
        if (selNode.LoadFromID(selNodeID))
            return selNode;
        else
            return null;
    }

    
    function SetSelectNode(preSelectID) {
        var treeDiv = document.getElementById(_thisID);

        
        if (_selectedNodeID != "") {
            treeDiv.setAttribute("SELECTNODEID", preSelectID);
            

            var oFunc = new Function("node_select(\"" + _selectedNodeID + "\", \"\", \"" + _thisID + "\", " + _nodeClick + ");");
            oFunc.call();
        }
    }

    
    function DisplaySelectNode() {
        var selectNodeID = GetSelectNodeID();
        if (selectNodeID == "") return;
        var selectNode = document.getElementById(selectNodeID);

        var treeView = document.getElementById(_thisID);
        var treeDiv = treeView.parentNode;

        var treeDivHeight = parseInt(treeDiv.style.height.replace("px", ""));

        var iHeight = GetobjHeight(selectNode);
        var iWidth = parseInt(GetAttribute(selectNode, "NODELEVEL")) - 1;
        iWidth = iWidth * parseInt(TreeIconSizes["width"]);

        if (treeDiv.scrollTop != null)
            treeDiv.scrollTop = iHeight - treeDivHeight / 2;

        if (treeDiv.scrollLeft != null)
            treeDiv.scrollLeft = iWidth;
    }

    
    function GetobjHeight(pObj) {
        var oTmp = pObj;
        var iHeight = 0;
        do {
            iHeight += oTmp.offsetTop;
            oTmp = oTmp.offsetParent;
        }
        while
		(oTmp.tagName != "BODY");

        return iHeight;
    }

    
    function SetConfig(pConfigData) {
        var arrNode = GetChildNodes(pConfigData.documentElement);

        for (var i = 0; i < arrNode.length; i++) {
            var arrSubNode = GetChildNodes(arrNode[i]);

            for (var j = 0; j < arrSubNode.length; j++) {
                if (arrSubNode[j].tagName.toLowerCase() == "iconsize") {
                    var strWidth = GetAttribute(arrSubNode[j], "width");
                    var strHeight = GetAttribute(arrSubNode[j], "height");

                    if (strWidth == "")
                        strWidth = "18";

                    if (strHeight == "")
                        strHeight = "18";

                    TreeIconSizes["width"] = strWidth;
                    TreeIconSizes["height"] = strHeight;
                    continue;
                }
                else if(arrSubNode[j].tagName.toLowerCase() == "baseimage" || arrSubNode[j].tagName.toLowerCase() == "baseclass" || arrSubNode[j].tagName.toLowerCase() == "images") {
                    var strValue = "";
                    var arrSubSubNode = GetChildNodes(arrSubNode[j]);
                    for (var k = 0; k < arrSubSubNode.length; k++) {
                        strValue = "";
                        strValue = GetAttribute(arrSubSubNode[k], "path");
                        
                        if(arrSubNode[j].tagName.toLowerCase() == "baseimage")
                            TreeIcons[arrSubSubNode[k].tagName] = strValue;
                        else if (arrSubNode[j].tagName.toLowerCase() == "baseclass")
                        {
                            strValue = GetAttribute(arrSubSubNode[k], "name");
                            TreeClasses[arrSubSubNode[k].tagName] = strValue;
                        }
                        else if (arrSubNode[j].tagName.toLowerCase() == "images")
                            TreeImages[arrSubSubNode[k].tagName] = strValue;
                    }
                }
            }
        }
    }

    function TreeView_ToString() {
        return "KAONI TreeView";
        
    }
}



function treeicon_toggle(pNodeID, pTreeID, callbackFunc, pNodeIconID) {
    var objNodeIcon = document.getElementById(pNodeIconID);
    
    if (objNodeIcon) {
        if (objNodeIcon.src.indexOf(TreeIcons["node_plus"]) > 0)
            objNodeIcon.src = TreeIcons["node_minus"];
        else if (objNodeIcon.src.indexOf(TreeIcons["node_minus"]) > 0)
            objNodeIcon.src = TreeIcons["node_plus"];
    }


    var subDiv = document.getElementById(pNodeID + "_sub"); 
    if (subDiv.style.display == "none")
        subDiv.style.display = "";
    else
        subDiv.style.display = "none";

    
    var objNode = document.getElementById(pNodeID);
    if (objNode.childNodes[objNode.childNodes.length - 1].childNodes.length == 0)
        if (callbackFunc != null & typeof (callbackFunc) == "function")
        callbackFunc(pNodeID, pTreeID);
}

function node_select(pNodeID, pNodeNM, pTreeID, callbackFunc) {
    var treeDiv = document.getElementById(pTreeID);
    var preSelectID = GetAttribute(treeDiv, "SELECTNODEID");

    if (preSelectID != "" && preSelectID != "undefined") {
        var objSpan = document.getElementById("spn_" + preSelectID);
        objSpan.className = TreeClasses["normal"];
        objSpan.setAttribute("style", "color:" + GetAttribute(eval(preSelectID),"DATA4", "0"));
    }

    if (pNodeID != "" && pNodeID != "undefined") {
        var objSpan = document.getElementById("spn_" + pNodeID);
        objSpan.className = TreeClasses["selected"];

        if (GetAttribute(objSpan,"style", "") != "")
            objSpan.removeAttribute("style");

        treeDiv.setAttribute("SELECTNODEID", pNodeID);

        if (callbackFunc != null & typeof (callbackFunc) == "function")
            callbackFunc(pNodeID, pNodeNM);
    }
}