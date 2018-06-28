//조직도 Initial Display
function TreeViewinitialize(targetDeptID, TopDeptID, tProperty, ServerName)
{
	try
	{
		var xmlpara = createXmlDom();
		var xmlTree = createXmlDom();
		var xmlHTTP = createXMLHttpRequest();
		var objNode;		
	    createNodeInsert(xmlpara, objNode, "DATA"); 
	    createNodeAndInsertText(xmlpara, objNode, "DEPTID", targetDeptID);
	    createNodeAndInsertText(xmlpara, objNode, "TOPID", TopDeptID);
	    createNodeAndInsertText(xmlpara, objNode, "PROP",  tProperty);		

		xmlHTTP.open("POST", "/ezOrgan/getDeptTreeInfo.do", false);
		xmlHTTP.send(xmlpara);
//alert("1::"+xmlHTTP.responseText);
		xmlTree = loadXMLString(xmlHTTP.responseText);
		//alert("2::"+xmlTree.xml);
	    //alert(xmlTree.childNodes.length);
	    if(xmlTree.childNodes.length > 0)
	    {
		    if(CrossYN())
	        {
                var xmlRtn = xmlHTTP.responseXML.documentElement;
                var Node = xmlTree.importNode(xmlRtn, true);
                xmlTree.documentElement.getElementsByTagName("NODE")[0].appendChild(Node);
	        }
	        else
	        {
                var xmlRtn = xmlHTTP.responseXML.documentElement;
                xmlTree.childNodes[0].childNodes[0].appendChild(xmlRtn);
            }
	    }

	    document.getElementById('TreeView').innerHTML = "";
	    var treeView = new TreeView();
        treeView.SetID("FromTreeView");
        treeView.SetUseAgency(true);
        treeView.SetRequestData("TreeViewRequestData");
        treeView.SetNodeClick("TreeViewNodeClick");
        treeView.SetNodeDblClick("TreeViewNodeDbClick");
	    treeView.DataSource(xmlTree);
	    treeView.DataBind("TreeView");
	}
	catch(ErrMsg)
	{
		alert(" TreeViewinitialize : " + ErrMsg.description);
	}
}

function TreeViewRequestData(pNodeID,pTreeID) 
{
    var TreeIdx = pNodeID;
	//var nodeIdx = window.event.nodeIdx;
	
	var treeNode = new TreeNode();
    treeNode.LoadFromID(TreeIdx);

    var deptID = treeNode.GetNodeData("CN");
    //alert("리퀘pTreeID"+ pTreeID);
    //alert("리퀘ID"+ deptID);
    //alert("treeidx" + TreeIdx);
    GetDeptSubTreeInfo(deptID, TreeIdx);	
}


function GetDeptSubTreeInfo(deptID, TreeIdx)
{
    var xmlHTTP = createXMLHttpRequest();
	var xmlRtn = createXmlDom();
	var xmlpara = createXmlDom();
	
	var objNode;		
	    createNodeInsert(xmlpara, objNode, "DATA"); 
	    createNodeAndInsertText(xmlpara, objNode, "DEPTID", deptID);
	    createNodeAndInsertText(xmlpara, objNode, "PROP",  "extensionAttribute2;extensionAttribute3;extensionAttribute9;displayName");	
    // 수정(2007.06.18) : multidata 기능 추가
	//var strQuery = "<DATA><DEPTID>" + deptID + "</DEPTID><PROP>extensionAttribute2;extensionAttribute3;extensionAttribute9;DisplayName</PROP></DATA>";
	
	
	xmlHTTP.open("POST", "/ezOrgan/getDeptSubTreeInfo.do", false);
	xmlHTTP.send(xmlpara);
	
	//alert("1xmlpara::"+xmlpara.xml);
	
	xmlRtn = loadXMLString(xmlHTTP.responseText);
	//alert("리턴값1:::"+xmlHTTP.responseText);
	//alert("리턴값2:::"+loadXMLString(xmlHTTP.responseText).xml);
	//alert(xmlRtn.childNodes.length);
	if(SelectNodes(xmlRtn, "NODES/NODE/VALUE").length > 0)
	{
	    //alert("이프문안!!");
	    if(CrossYN())
	    {//documentElement.getElementsByTagName("NODE")[0].appendChild(Node);
		    xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("NODES")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
		}
		else
		{
		    xmlRtn.selectNodes("NODES/NODE")[0].appendChild(xmlRtn.selectNodes("NODES/NODE/VALUE")[0]);
		}
	}
		
	//TreeView.putchildxml(pNodeIdx, xmlRtn.xml);
	
	var treeView = new TreeView();      //미리 생성된 TreeView의 ID로 TreeView 개체 생성
    treeView.LoadFromID("FromTreeView");
    //alert("마지막"+xmlRtn.documentElement);
	treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx)
	//TreeView.putchildxml(nodeIdx, xmlHTTP.responseXML);
}