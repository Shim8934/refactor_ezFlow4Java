/* 2023-10-05 황인경 - 디자인 개선 > 전자결재 관련 Folder TreeView */
/*트리의 설정값을 가지고 있는 변수*/
var TreeIcons       = new Array();
var TreeIconSizes   = new Array();
var TreeClasses     = new Array();
var TreeImages      = new Array();

var _depth = 0;

//###########################################################################################
// TreeNode 클래스 시작
function TreeNode() {
    /* Public Member 선언 시작 */
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
    
    /* Public Member 선언 끝 */

    /* Private Member 선언 시작 */
    var _nodeDIV = null;
    /* Private Member 선언 끝 */

    //노드 ID를 이용하여 트리노드 불러오기
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

    //트리노드의 CN, EXTENSIONATTRIBUTE 등과 같은 값을 가지고 온다.
    function GetNodeData(pDataName) {
        return GetAttribute(_nodeDIV, pDataName);
    }
    
    //트리노드의 CN, EXTENSIONATTRIBUTE 등과 같은 값을 설정 한다.
    function SetNodeData(pDataName, value) {
        return SetAttribute(_nodeDIV, pDataName, value);
    }
    
    //트리노드의 이름을 설정 한다.
    function SetNodeName(value) {
        document.getElementById("spn_" + this.NodeID).innerHTML = value;
    }

    //트리노드의 Element를 삭제 한다.
    function DeleteNode(treeViewID) {
        document.getElementById(treeViewID).setAttribute("SELECTNODEID", "");
        _nodeDIV.parentNode.removeChild(_nodeDIV);
    }

    //트리 노드 만들기
    function CreateTreeNode(pNodeData, pEndNode, pParentNode, pUseAgency, pUseSusinColor, pNodeClick, pNodeDblClick, pRequestHandler) {
        //한 노드의 전체적인 DIV를 만든다.
        var treeDiv = document.createElement("DIV");
        treeDiv.className = "node_div";
        treeDiv.style.whiteSpace = "nowrap";
        treeDiv.id = this.NodeID;

        treeDiv.setAttribute("NODENAME", this.NodeName);
        treeDiv.setAttribute("NODELEVEL", this.NodeLevel);
        treeDiv.setAttribute("ENDNODE", String(pEndNode));

        //노드 DIV에 노드 데이터 세팅.
        var arrNodeData = GetChildNodes(pNodeData);
        for (var i = 0; i < arrNodeData.length; i++) {
            var strDataName = arrNodeData[i].tagName.toUpperCase();
            var strDataValue = SelectSingleNodeValue(pNodeData, strDataName);

            treeDiv.setAttribute(strDataName, strDataValue);
        }

        //확장하는 노드인지 체크
        var bExpanded = false;

        var strExpanded = GetAttribute(treeDiv, "EXPANDED");
        if (strExpanded != null && strExpanded.toUpperCase() == "TRUE")
            bExpanded = true;

        //부모노드의 점선 이미지와 동일하게 세팅한다.
        var arrParentDotImg = GetParentDotImg(pParentNode);
        for (var i = 0; i < arrParentDotImg.length - 1; i++) {
            var imgDot = arrParentDotImg[i].cloneNode(true);
            imgDot.border = "0";
            imgDot.style.width = TreeIconSizes["width"];
            imgDot.style.height = TreeIconSizes["height"];
            imgDot.className = "DOT";

            treeDiv.innerHTML += imgDot.outerHTML;
        }

        //부모노드가 마지막 노드인지 확인한다.
        var bParentEndNode = false;
        if (GetAttribute(pParentNode, "ENDNODE") != null) {
            if (GetAttribute(pParentNode, "ENDNODE").toLowerCase() == "true")
                bParentEndNode = true;
        }

        //부모노드의 점선 아이콘의 개수가 0보다 작거나 같은 경우
        //iParentImgCnt의 값을 0으로 주어 자신의 점선 아이콘을 생성할 개수의 기준으로 잡는다.
        var iParentImgCnt = arrParentDotImg.length - 1;
        if (iParentImgCnt <= 0)
            iParentImgCnt = _depth;

        //자신의 노드 레벨에 맞게 점선 삽입		
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

        //노드 아이콘 생성
        var imgNode = document.createElement("I");
        imgNode.id = "imgNode_" + this.NodeID;
        imgNode.border = "0";
        imgNode.style.width = TreeIconSizes["width"];
        imgNode.style.height = TreeIconSizes["height"];

        //자식 노드를 가지고 있는 노드인지 체크
        var strIsLeaf = GetAttribute(treeDiv, "ISLEAF");

        //기관표시 사용 여부가 true 체크
        if (pUseAgency) {
            var strIconByName = GetAttribute(treeDiv, "SETNODEICONBYNAME");
            if (strIconByName != null) {
                if (strIconByName.toUpperCase() != "ICONCOMP")
                    pUseAgency = false;
            }
            else {
                pUseAgency = false;
            }
        }
        if (strIsLeaf == "TRUE") {
			imgNode.style.paddingLeft = "18px";
		} else if (bExpanded) {
			imgNode.classList.remove("sub_iconLNB", "tree_plus");
			imgNode.classList.add("sub_iconLNB", "tree_minus");
		} else {
			imgNode.classList.remove("sub_iconLNB", "tree_minus");
			imgNode.classList.add("sub_iconLNB", "tree_plus");
		}
            
        var strTreeID = this.NodeID.substring(0, this.NodeID.indexOf("_"));

        //노드 Request Data 이벤트 Attach
        if (pRequestHandler != "" && strIsLeaf.toUpperCase() == "FALSE") {
            imgNode.style.cursor = "pointer";
            imgNode.setAttribute("onClick", "treeicon_toggle(\"" + this.NodeID + "\", \"" + strTreeID + "\", " + pRequestHandler + ", \"" + imgNode.id + "\");");
        }

        treeDiv.innerHTML += imgNode.outerHTML;
        //
        //노드 아이콘 생성
        var subImgNode = document.createElement("IMG");
        subImgNode.id = "subImgNode_" + this.NodeID;
        subImgNode.border = "0";
        // subImgNode.style.width = TreeIconSizes["width"];
        // subImgNode.style.height = TreeIconSizes["height"];
        // subImgNode.src = pUseAgency ? TreeImages["iconcomp"] : TreeImages["base"];
        treeDiv.innerHTML += subImgNode.outerHTML;
        //

        //노드 이름 SPAN 생성
        var spnNode = document.createElement("SPAN");
        var nodeText = document.createTextNode(this.NodeName);
        spnNode.appendChild(nodeText);

        spnNode.id = "spn_" + this.NodeID;
        spnNode.name = "spn_" + strTreeID;
        spnNode.className = TreeClasses["normal"];

        if (SelectSingleNode(pNodeData, "SETTEXTCOLORBYNAME") != null && ($("#1tab1").attr("class") != "tabon" || pRequestHandler == "RequestDataG")) {
        	if (pUseSusinColor) {
        		spnNode.style.color = "#bbbbbb";
        	}
        }

        if (typeof (document.body.onselectstart) != "undefined") //IE route
            spnNode.onselectstart = function() { return false; }
        else if (typeof (document.body.style.MozUserSelect) != "undefined") //Firefox route
            spnNode.style.MozUserSelect = "none";

        //노드 클릭 이벤트 Attach
        if (pNodeClick != "") {
            spnNode.style.cursor = "pointer";
            this.NodeName = this.NodeName.replace(/"/g, '\\"');
            spnNode.setAttribute("onClick", "node_select(\"" + this.NodeID + "\", \"\", \"" + strTreeID + "\", " + pNodeClick + ");");
        }

        //노드 더블클릭 이벤트 Attach
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

        //하위 노드용 DIV 생성
        var subDiv = document.createElement("DIV");
        subDiv.id = this.NodeID + "_sub";

        if (bExpanded)
            subDiv.style.display = "";
        else
            subDiv.style.display = "none";

        treeDiv.innerHTML += subDiv.outerHTML;

        return treeDiv;
    }

    //부모노드의 점선 이미지 가져오기
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

    //부모 노드의 모든 이미지 가져오기
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
// TreeNode 클래스 끝
//###########################################################################################

//###########################################################################################
// TreeView 클래스 시작
function TreeView() {
    /* Public Member 선언 시작 */
    this.SetID = SetID;
    this.GetID = GetID;
    this.SetConfig = SetConfig;
    this.SetNodeClick = SetNodeClick;
    this.SetNodeDblClick = SetNodeDblClick;
    this.SetRequestData = SetRequestData;
    this.SetUseAgency = SetUseAgency;
    this.SetUseSusinColor4AprG = SetUseSusinColor4AprG;

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
    /* Public Member 선언 끝 */

    /* Private Member 선언 시작 */
    var _dataSource = null;
    var _thisID = "";
    var _nodeClick = "";
    var _nodeDblClick = "";
    var _requestDataHandler = "";
    var _selectedNodeID = "";
    var _selectedNodeNM = "";
    var _useAgency = true;     // 하위노드 추가시 따로 셋팅하지 않은 페이지들이 많아 true로 변경 처리함. 2010.05.07
    var _useSusinColor4AprG = false; //2018-08-22 천성준 - 전자결재G 부서 트리뷰 결재문서(수신[흑색]/미수신[회색]) 색 표시여부 (default : false)

    /* Private Member 선언 끝 */


    //트리뷰의 ID 지정
    function SetID(pObjID) {
        if (pObjID != "")
            _thisID = pObjID;
    }
    
    //트리뷰의 ID 반환
    function GetID() {
        return _thisID;
    }

    //트리뷰의 DATA 지정 (XML 타입)
    function DataSource(pDataSource) {
        _dataSource = pDataSource;
    }

    //트리노드 클릭이벤트 핸들러 지정
    function SetNodeClick(pNodeClick) {
        _nodeClick = pNodeClick;
    }

    //트리노드 더블클릭이벤트 핸들러 지정
    function SetNodeDblClick(pNodeDblClick) {
        _nodeDblClick = pNodeDblClick;
    }

    //트리노드 Request Data 이벤트 핸들러 지정
    function SetRequestData(pHandler) {
        _requestDataHandler = pHandler;
    }

    //기관 표시유무 설정
    function SetUseAgency(pUseAgency) {
        _useAgency = pUseAgency;
    }
    
    //전자결재G 결재문서 수신/미수신 표시유무
    function SetUseSusinColor4AprG(pUseSusinColor) {
    	_useSusinColor4AprG = pUseSusinColor;
    }

    //이미 만들어진 트리뷰 ID를 이용하여 트리뷰 객체 생성	
    function LoadFromID(pTreeID) {
        _thisID = pTreeID;

        var oTree = document.getElementById(pTreeID);
        _nodeClick = GetAttribute(oTree, "NODECLICK");
        _nodeDblClick = GetAttribute(oTree, "NODEDBLCLICK");
        _requestDataHandler = GetAttribute(oTree, "REQUESTDATA");
    }

    //기관 표시유무 설정
    function SetDepth(pdepth) {
        _depth = pdepth;
    }

    //트리뷰 바인딩
    function DataBind(pTagetID) {
        if (_dataSource == null) {
            alert(strLang1127);
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

            //선택된 노드가 있는 경우 node_select 함수를 호출한다.
            if (_selectedNodeID != "") {
                treeDiv.setAttribute("SELECTNODEID", _selectedNodeID);

                //this.DisplaySelectNode();
                
                var oFunc = new Function("node_select(\"" + _selectedNodeID + "\", \"" + _selectedNodeNM + "\", \"" + _thisID + "\", " + _nodeClick + ");");
                oFunc.call();
            }
        }
    }

    //자식노드 데이터를 이용하여 자식노드를 붙인다.	
    function AppendChildNodes(pSubData, pNodeID) {
        var oNode = document.getElementById(pNodeID);
        var strLevel = GetAttribute(oNode, "NODELEVEL");

        AppendTreeNode(pSubData, oNode, parseInt(strLevel) + 1);
    }

    function AppendTreeNode(pElmData, pNode, pLevel) {
        var arrNodes = GetChildNodes(pElmData);
        if(arrNodes == undefined)
            arrNodes = GetChildNodes(loadXMLString(pElmData));

        for (var i = 0; i < arrNodes.length; i++) {
            //오간에 NODEICONIMAGE노드가 붙어오므로 제거함.  2010.04.07
            if (arrNodes[i].nodeName.toUpperCase() == "NODE") {

                //형제 노드들 중 마지막 노드인지 확인
                var bEndNode = false;
                if (i == arrNodes.length - 1)
                    bEndNode = true;

                //노드ID 및 노드 이름 지정						
                var strNodeID = pNode.id + "_" + i;
                //값이 없을경우 트리뷰 에러나는 것을 막음
                //TODO 2016-09-07 이효진 다국어 처리 관련 소스 추가  로 되어 있지만
                // EzOrganDAO.getTBLDeptMaster > CASE #v_LANGDATA# WHEN '1' THEN DISPLAYNAME ELSE DISPLAYNAME2 END DEPTNM 이고,
                // ezOrgan.service.impl.EzOrganServiceImpl > getTreeNodeInfo() > "<VALUE>" + commonUtil.cleanValue(vo.getDeptNM()) + "</VALUE>" 이고,
                // (Commit a929ffab5) Hyojin Lee <hyojin0414@kaoni.com> on 16. 12. 19 오전 10:38 이때를 보면 VALUE2는 없음.
                // [카이스트]는 apprGezApprovalInfo.jsp에서 primary를 삭제해서 에러가 안남. 왜 삭제했는지는 commit을 찾기 힘듦.
                
                if (typeof(langType) != 'undefined' && langType != '1') {
                	if(SelectSingleNodeValue(arrNodes[i], "VALUE2").replace(/ /gi, "") != "\n")
                        var strNodeNM = SelectSingleNodeValue(arrNodes[i], "VALUE2");
                    else
                        var strNodeNM = "　　　";
                } else {          
                	if(SelectSingleNodeValue(arrNodes[i], "VALUE").replace(/ /gi, "") != "\n")
                        var strNodeNM = SelectSingleNodeValue(arrNodes[i], "VALUE");
                    else
                        var strNodeNM = "　　　";
                }
                

                //TreeNode 객체 생성하여 프로퍼티 지정
                var organNode = new TreeNode();
                organNode.NodeID = strNodeID;
                organNode.NodeName = strNodeNM;
                organNode.NodeLevel = pLevel;

                //선택된 노드 알아내기
                if (SelectSingleNode(arrNodes[i], "SELECT") != null) {
                    _selectedNodeID = strNodeID;
                    _selectedNodeNM = strNodeNM;
                }

                //트리노드 생성
                var treeNode = organNode.CreateTreeNode(arrNodes[i], bEndNode, pNode, _useAgency, _useSusinColor4AprG, _nodeClick, _nodeDblClick, _requestDataHandler);

                if (pLevel == 0)
                //Level이 0인 노드(회사)는 트리 DIV에 append
                    pNode.appendChild(treeNode);
                else {
                    //Level이 1 이상인 노드는 하위 노드용 DIV에 append
                    var subDiv = pNode.childNodes[pNode.childNodes.length - 1];
                    subDiv.appendChild(treeNode);
                }

                //자식 노드 Recursion
                if (SelectSingleNode(arrNodes[i], "NODES") != null)
                    AppendTreeNode(SelectSingleNode(arrNodes[i], "NODES"), treeNode, pLevel + 1);
            }
        }
    }

    //선택된 노드 ID 가져오기
    function GetSelectNodeID() {
        var treeDiv = document.getElementById(_thisID);

        return GetAttribute(treeDiv, "SELECTNODEID");
    }

    //선택된 노드 가져오기
    function GetSelectNode() {
        var selNodeID = GetSelectNodeID();
        var selNode = new TreeNode();
        if (selNode.LoadFromID(selNodeID))
            return selNode;
        else
            return null;
    }

    //_selectedNodeID값으로 노드 선택하기
    function SetSelectNode(preSelectID) {
        var treeDiv = document.getElementById(_thisID);

        //선택된 노드가 있는 경우 node_select 함수를 호출한다.
        if (_selectedNodeID != "") {
            treeDiv.setAttribute("SELECTNODEID", preSelectID);

            var oFunc = new Function("node_select(\"" + _selectedNodeID + "\", \"" + _selectedNodeNM + "\", \"" + _thisID + "\", " + _nodeClick + ");");
            oFunc.call();
        }
    }

    //현재 선택된 노드가 표시 되도록 스크롤을 조절한다.
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

    //선택한 노드 까지의 높이를 계산한다.
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

    //트리 설정값 세팅하기
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
// TreeView 클래스 끝
//###########################################################################################

function treeicon_toggle(pNodeID, pTreeID, callbackFunc, pNodeIconID) {
	var objNodeIcon = document.getElementById(pNodeIconID);
	//puls 로 통일  2010.04.07
	if (objNodeIcon) {
		if (objNodeIcon.classList.contains("tree_plus") > 0) {
			objNodeIcon.classList.remove("sub_iconLNB", "tree_plus");
			objNodeIcon.classList.add("sub_iconLNB", "tree_minus");
		} else if (objNodeIcon.classList.contains("tree_minus") > 0) {
			objNodeIcon.classList.remove("sub_iconLNB", "tree_minus");
			objNodeIcon.classList.add("sub_iconLNB", "tree_plus");
		}
	}


    var subDiv = document.getElementById(pNodeID + "_sub");
    if (subDiv.style.display == "none")
        subDiv.style.display = "";
    else
        subDiv.style.display = "none";

    //자식노드가 존재하지 않으면 RequestData 호출
    var objNode = document.getElementById(pNodeID);
    if (objNode.childNodes[objNode.childNodes.length - 1].childNodes.length == 0)
        if (callbackFunc != null & typeof (callbackFunc) == "function")
        callbackFunc(pNodeID, pTreeID);
}

function node_select(pNodeID, pNodeNM, pTreeID, callbackFunc) {
    var treeDiv = document.getElementById(pTreeID);
    var preSelectID = GetAttribute(treeDiv, "SELECTNODEID");
    
    if (document.getElementById("descript") != null) {
    	document.getElementById("descript").innerHTML = "";
    }
    
    // 2018-10-05 김민성 - 양식함 양식 선택시 양식설명 초기화
    if (document.getElementById("descrip") != null) {
    	document.getElementById("descrip").innerHTML = "";
    }
    
    if (preSelectID != "" && preSelectID != "undefined" && preSelectID!= null) {
        var objSpan = document.getElementById("spn_" + preSelectID);
        objSpan.className = TreeClasses["normal"];
    }
    if (pNodeID != "" && pNodeID != "undefined") {
        var objSpan = document.getElementById("spn_" + pNodeID);
        objSpan.className = TreeClasses["selected"];

        treeDiv.setAttribute("SELECTNODEID", pNodeID);

        if (callbackFunc != null & typeof (callbackFunc) == "function")
            callbackFunc(pNodeID, pNodeNM);
    }
    var el = document.querySelector("li.on");
    if (el) {
        el.className = "";
    }
}