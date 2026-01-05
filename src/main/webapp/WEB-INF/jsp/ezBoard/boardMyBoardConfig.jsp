<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
	    <title><spring:message code='ezBoard.t10044'/></title>
		<link rel="stylesheet" href="${util.addVer('main.lhm02', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/TreeView.js')}"></script>
	    <script type="text/javascript">
	        var treeView = new TreeView();
	        var pType = "<c:out value='${type}'/>";
	        var pBoardID = "<c:out value='${boardID}'/>";
	        var isChanged = "";
	
	        /* 2018-11-28 홍승비 - 마이게시판 관리 시 변화가 없다면 좌측 마이게시판 확장하지 않음 */
			window.onbeforeunload = function () {
				if (isChanged == "Y") {
	            	try {
	            		window.opener.configmyboard_dialogArguments[0] = "Y";
	            	} catch (e) {}
				}
	        };
	
	        window.onload = function () {
	            SetTreeConfig();
	            makeTreeList();
	        };
	            
	        /* 2019-01-31 홍승비 - 세로방향 리사이즈 시 내부 테이블 높이도 리사이즈 */
	        window.onresize = function () {    	
	        	document.getElementById("TreeCtrl_MyBoardTree").style.height = (document.documentElement.clientHeight - 141) + "px";
	        }
	        
	        function makeTreeList() {
	            document.getElementById("TreeCtrl_MyBoardTree").innerHTML = "";
	            treeView.SetID("FromTreeView");
	            treeView.SetNodeClick("TreeCtrl_onNodeClick");
	            treeView.SetRequestData("TreeCtrl_onNodeExpanded");
	            treeView.DataSource(GetMyBoardItem("0"));
	            treeView.DataBind("TreeCtrl_MyBoardTree");
	        }
	        function GetMyBoardItem(pRootTreeID) {
	            var xmlhttp4 = createXMLHttpRequest();
	            xmlhttp4.open("POST", "/ezBoard/getMyBoardsConfig.do?rootTreeID=" + encodeURIComponent(pRootTreeID), false);
	            xmlhttp4.send();
	            var ret = xmlhttp4.responseXML;
	            xmlhttp4 = null;
	
	            return ret;
	        }
	        function SetTreeConfig() {
	            var xmlHTTP = createXMLHttpRequest();
	            xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
	            xmlHTTP.send();
	
	            if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	                var treeView = new TreeView();
	                treeView.SetConfig(xmlHTTP.responseXML);
	            }
	        }
	        var SelectedBoardID = "";
	        var SelectedBoardName = "";
	        var selectedBoardtype = "";
	        var selectedNodeID = "";
	        var selNewBoard = false;
	        function TreeCtrl_onNodeClick(pNodeID, pTreeID) {
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(pNodeID);
	            SelectedBoardID = treeNode.GetNodeData("DATA1");
	            selectedBoardtype = treeNode.GetNodeData("DATA4");
	            SelectedBoardName = treeNode.GetNodeData("VALUE");
	            selectedNodeID = treeNode.GetNodeData("id");
	            if (treeNode.GetNodeData("DATA3") == '{FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF}')
	                selNewBoard = true;
	        }
	        function TreeCtrl_onNodeExpanded(pNodeID, pTreeID) {
	            var xmlRtn = createXmlDom();
	            var TreeIdx = pNodeID;
	            var treeNode = new TreeNode();
	            treeNode.LoadFromID(TreeIdx);
	            xmlRtn = GetMyBoardItem(treeNode.GetNodeData("DATA1"));
	            if (SelectNodes(xmlRtn, "TREEVIEWDATA/NODE/VALUE").length > 0) {
	                if (CrossYN()) {
	                    xmlRtn.getElementsByTagName("TREEVIEWDATA")[0].getElementsByTagName("NODE")[0].appendChild(xmlRtn.getElementsByTagName("TREEVIEWDATA")[0].getElementsByTagName("NODE")[0].getElementsByTagName("VALUE")[0]);
	                }
	                else {
	                    xmlRtn.selectNodes("TREEVIEWDATA/NODE")[0].appendChild(xmlRtn.selectNodes("TREEVIEWDATA/NODE/VALUE")[0]);
	                }
	            }
	            var treeView = new TreeView();
	            treeView.LoadFromID(pTreeID);
	            treeView.AppendChildNodes(xmlRtn.documentElement, TreeIdx);
	        }
	
	        var Addxmlhttp = createXMLHttpRequest();
	        var inputnamedlg_dialogArguments = new Array();
	        var typeArg = "";
	        function add_onclick(type) {
	            typeArg = type;
	            if (type == "C") {
	                if (SelectedBoardID == "") {
	                    alert("<spring:message code='ezBoard.t10035'/>");
	                    return;
	                }
	
	                if (selectedBoardtype == "BOARD") {
	                    alert("<spring:message code='ezBoard.t10036'/>");
	                    return;
	                }
	            }
	            if (CrossYN()) {
	                inputnamedlg_dialogArguments[0] = "";
	                inputnamedlg_dialogArguments[1] = add_onclick_Complete;
	                DivPopUpShow(310, 200, "/ezBoard/inputNameDlg.do");
	            }
	            else {
	                var feature = "dialogHeight:200px; dialogwidth:330px; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(330, 200);
	                var TreeName = window.showModalDialog("/ezBoard/inputNameDlg.do", "", feature);
	                if (TreeName == undefined)
	                    return;
	
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                var newID = "{" + GetGUID() + "}";
	
	                createNodeAndInsertText(xmlpara, objNode, "PTREEID", newID);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", TreeName);
	                if (type == "U")
	                    createNodeAndInsertText(xmlpara, objNode, "PUPPERID", "0");
	                else if (type == "C")
	                    createNodeAndInsertText(xmlpara, objNode, "PUPPERID", SelectedBoardID);
	                createNodeAndInsertText(xmlpara, objNode, "PMODE", "NEW");
	                createNodeAndInsertText(xmlpara, objNode, "PBOARDID", "");
	
	                Addxmlhttp.open("POST", "/ezBoard/setMyBoardsConfig.do", false);
	                Addxmlhttp.send(xmlpara);
	
	                if (Addxmlhttp.readyState == 4 && Addxmlhttp.status == 200) {
	                    if (getNodeText(GetChildNodes(Addxmlhttp.responseXML)[0]) == "OK") {
	                        alert("<spring:message code='ezBoard.t10048'/>");
	                        isChanged = "Y";
	                        makeTreeList();
	                        SelectedBoardID = "";
	                        SelectedBoardName = "";
	                        selectedBoardtype = "";
	                        selectedNodeID = "";
	                    }
	                }
	            }
	        }
	
	        function add_onclick_Complete(TreeName) {
	            DivPopUpHidden();
	
	            if (TreeName == undefined)
	                return;
	
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            var newID = "{" + GetGUID() + "}";
	
	            createNodeAndInsertText(xmlpara, objNode, "PTREEID", newID);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", TreeName);
	            if (typeArg == "U")
	                createNodeAndInsertText(xmlpara, objNode, "PUPPERID", "0");
	            else if (typeArg == "C")
	                createNodeAndInsertText(xmlpara, objNode, "PUPPERID", SelectedBoardID);
	            createNodeAndInsertText(xmlpara, objNode, "PMODE", "NEW");
	            createNodeAndInsertText(xmlpara, objNode, "PBOARDID", "");
	
	            Addxmlhttp.open("POST", "/ezBoard/setMyBoardsConfig.do", false);
	            Addxmlhttp.send(xmlpara);
	
	            if (Addxmlhttp.readyState == 4 && Addxmlhttp.status == 200) {
	                if (getNodeText(GetChildNodes(Addxmlhttp.responseXML)[0]) == "OK") {
	                    alert("<spring:message code='ezBoard.t10048'/>");
	                    isChanged = "Y";
	                    makeTreeList();
	                    SelectedBoardID = "";
	                    SelectedBoardName = "";
	                    selectedBoardtype = "";
	                    selectedNodeID = "";
	                }
	            }
	        }
	
	
	        function modify_onclick() {
	            if (SelectedBoardID == "") {
	                alert("<spring:message code='ezBoard.t10037'/>");
	                return;
	            }
	
	            if (selectedBoardtype == "BOARD") {
	                alert("<spring:message code='ezBoard.t10038'/>");
	                return;
	            }
	
	            if (CrossYN()) {
	                inputnamedlg_dialogArguments = new Array();
	                inputnamedlg_dialogArguments[0] = SelectedBoardName;
	                inputnamedlg_dialogArguments[1] = modify_onclick_Complete;
	                DivPopUpShow(310, 200, "/ezBoard/inputNameDlg.do");
	
	            }
	            else {
	                var feature = "dialogHeight:200px; dialogwidth:330px; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(330, 200);
	                var TreeName = window.showModalDialog("/ezBoard/inputNameDlg.do", SelectedBoardName, feature);
	                if (TreeName == undefined)
	                    return;
	
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                createNodeAndInsertText(xmlpara, objNode, "PTREEID", "");
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", TreeName);
	                createNodeAndInsertText(xmlpara, objNode, "PUPPERID", SelectedBoardID);
	                createNodeAndInsertText(xmlpara, objNode, "PMODE", "MOD");
	                createNodeAndInsertText(xmlpara, objNode, "PBOARDID", "");
	
	                Addxmlhttp.open("POST", "/ezBoard/setMyBoardsConfig.do", false);
	                Addxmlhttp.send(xmlpara);
	
	                if (Addxmlhttp.readyState == 4 && Addxmlhttp.status == 200) {
	                    if (getNodeText(GetChildNodes(Addxmlhttp.responseXML)[0]) == "OK") {
	                        alert("<spring:message code='ezBoard.t999054'/>");
	                        isChanged = "Y";
	                        makeTreeList();
	                        SelectedBoardID = "";
	                        SelectedBoardName = "";
	                        selectedBoardtype = "";
	                        selectedNodeID = "";
	                    }
	                }
	            }
	
	        }
	        function modify_onclick_Complete(TreeName) {
	            DivPopUpHidden();
	
	            if (TreeName == undefined)
	                return;
	
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "PTREEID", "");
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", TreeName);
	            createNodeAndInsertText(xmlpara, objNode, "PUPPERID", SelectedBoardID);
	            createNodeAndInsertText(xmlpara, objNode, "PMODE", "MOD");
	            createNodeAndInsertText(xmlpara, objNode, "PBOARDID", "");
	
	            Addxmlhttp.open("POST", "/ezBoard/setMyBoardsConfig.do", false);
	            Addxmlhttp.send(xmlpara);
	
	            if (Addxmlhttp.readyState == 4 && Addxmlhttp.status == 200) {
	                if (getNodeText(GetChildNodes(Addxmlhttp.responseXML)[0]) == "OK") {
	                    alert("<spring:message code='ezBoard.t999054'/>");
	                    isChanged = "Y";
	                    makeTreeList();
	                    SelectedBoardID = "";
	                    SelectedBoardName = "";
	                    selectedBoardtype = "";
	                    selectedNodeID = "";
	                }
	            }
	        }
	        /* 2018-07-11 홍승비 - 마이게시판 삭제 시 메세지 나타나는 순서 변경 */
	        function delete_onclick() {
	            if (SelectedBoardID == "") {
	                alert("<spring:message code='ezBoard.t10039'/>");
	                return;
	            }
	            
	            if (selNewBoard) {
	                return;
	            }
	
	            if (!confirm("<spring:message code='ezBoard.t197'/>"))
	                return;
	
	            var xmlhttp = createXMLHttpRequest();
	            var xmlpara = createXmlDom();
	            var objNode;
	            createNodeInsert(xmlpara, objNode, "PARAMETER");
	            createNodeAndInsertText(xmlpara, objNode, "PTREEID", SelectedBoardID);
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME", "");
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", "");
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", "");
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", "");
	            createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", "");
	            createNodeAndInsertText(xmlpara, objNode, "PUPPERID", "");
	            createNodeAndInsertText(xmlpara, objNode, "PMODE", "DEL");
	            createNodeAndInsertText(xmlpara, objNode, "PBOARDID", "");
	
	            xmlhttp.open("POST", "/ezBoard/setMyBoardsConfig.do", false);
	            xmlhttp.send(xmlpara);
	
	            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
	            	if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "EXIST") {
	                    alert("<spring:message code='ezBoard.hyj04'/>");
	                }
	                if (getNodeText(GetChildNodes(loadXMLString(xmlhttp.responseText))[0]) == "OK") {
	                    alert("<spring:message code='ezBoard.t268'/>");
	                    isChanged = "Y";
	                    makeTreeList();
	                }
	                SelectedBoardID = "";
                    SelectedBoardName = "";
                    selectedBoardtype = "";
                    selectedNodeID = "";
	            }
	        }
	        
	        function add_MyBoard() {
	            if (SelectedBoardID == "") {
	                alert("<spring:message code='ezBoard.t10040'/>");
	                return;
	            }
	
	            if (selectedBoardtype == "BOARD") {
	                alert("<spring:message code='ezBoard.t10041'/>");
	                return;
	            }
	            
	            if (pBoardID != "") {
	            	
		            /* 2020-07-14 홍승비 - 동일한 마이게시판 분류에 동일 게시판 중복등록 방지 */
		            if (checkMyBoardExist(SelectedBoardID, pBoardID) == "Y") {
		                alert("<spring:message code='ezBoard.hsbMB01'/>");
		                return;
		            }
	            	
	                var xmlhttp = createXMLHttpRequest();
	                var xmlpara = createXmlDom();
	                var objNode;
	                createNodeInsert(xmlpara, objNode, "PARAMETER");
	                var newID = "{" + GetGUID() + "}";
	
	                createNodeAndInsertText(xmlpara, objNode, "PTREEID", newID);
	                createNodeAndInsertText(xmlpara, objNode, "PTREENAME", "${boardInfo.boardName}");
	                
	                if ("${boardInfo.boardName2}" != null && "${boardInfo.boardName2}" != "") {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", "${boardInfo.boardName2}");
	                } else {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME2", "${boardInfo.boardName}");
	                }
	                
	                if ("${boardInfo.boardName3}" != null && "${boardInfo.boardName3}" != "") {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", "${boardInfo.boardName3}");
	                } else {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME3", "${boardInfo.boardName}");
	                }
	                
	                if ("${boardInfo.boardName4}" != null && "${boardInfo.boardName4}" != "") {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", "${boardInfo.boardName4}");
	                } else {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME4", "${boardInfo.boardName}");
	                }
	                
	                if ("${boardInfo.boardName6}" != null && "${boardInfo.boardName6}" != "") {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", "${boardInfo.boardName6}");
	                } else {
		                createNodeAndInsertText(xmlpara, objNode, "PTREENAME6", "${boardInfo.boardName}");
	                }
	                
	                createNodeAndInsertText(xmlpara, objNode, "PUPPERID", SelectedBoardID);
	                createNodeAndInsertText(xmlpara, objNode, "PMODE", "NEW");
	                createNodeAndInsertText(xmlpara, objNode, "PBOARDID", pBoardID);
	
	                xmlhttp.open("POST", "/ezBoard/setMyBoardsConfig.do", false);
	                xmlhttp.send(xmlpara);
	
	                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
	                    if (getNodeText(GetChildNodes(xmlhttp.responseXML)[0]) == "OK") {
	                        alert("<spring:message code='ezBoard.t10042'/>");
	                        isChanged = "Y";
	                        makeTreeList();
	                        SelectedBoardID = ""; // 추가 이후 기존에 선택했던 트리(분류)ID 초기화
	                    }
	                }
	            }
	        }
	        
	        var myboard_movecopy_dialogArguments = new Array();
	        function move_onclick() {
	            if (SelectedBoardID == "") {
	                alert("<spring:message code='ezBoard.t10043'/>");
	                return;
	            }
	            /* 2019-11-15 홍승비 - 마이게시판 이동 시 게시판 또는 하위분류 타입 파라미터 전달 */
	            if (CrossYN()) {
	                myboard_movecopy_dialogArguments[0] = "";
	                myboard_movecopy_dialogArguments[1] = move_onclick_Complete;
	                DivPopUpShow(320, 375, "/ezBoard/myBoardmovecopy.do?selID=" + encodeURIComponent(SelectedBoardID) + "&nodeID=" + encodeURIComponent(selectedNodeID) + "&selectedBoardtype=" + encodeURIComponent(selectedBoardtype));
	            }
	            else {
	                var feature = "dialogWidth:320px; dialogHeight:375px; status:no; help:no; scroll:no; edge:sunken";
	                feature = feature + GetShowModalPosition(320, 375);
	                var moveUrl = window.showModalDialog("/ezBoard/myBoardmovecopy.do?selID=" + encodeURIComponent(SelectedBoardID), null, feature);
	                if (moveUrl == undefined)
	                    return;
	
					if (moveUrl == "TRUE") {
						isChanged = "Y";
						makeTreeList();
					}
				}
	        }
	        function move_onclick_Complete(moveUrl) {
	            DivPopUpHidden();
	            if (moveUrl == undefined)
	                return;
	
	            if (moveUrl == "TRUE") {
	            	isChanged = "Y";
	            	makeTreeList();
	            }
	        }
	        function S4() {
	            return ((CustomRandom() * 0x10000) | 0).toString(16).substring(1);
	        }
	
	        function GetGUID() {
	            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
	        }
	
	        function CustomRandom() {
	            var now = new Date();
	            var seed = now.getMilliseconds();
	            return Math.random(seed) + 1;
	        }
	        
			var agent = navigator.userAgent.toLowerCase(); 
			if (!CrossYN() || agent.search( "trident" ) > -1 ) {
				$("body").ready(function(){
					$(".imgbtn").css("padding-left" , "13px");
					$(".imgbtn span").css("padding-right", "13px");
				});
			}
			
			/* 2020-07-14 홍승비 - 선택한 마이게시판 분류 하위에 해당 게시판이 존재하는지 확인하는 함수 */
			function checkMyBoardExist(pTreeID, pBoardID) {
				var pResult = "";
				
            	$.ajax({
  					url : "/ezBoard/checkMyBoardExist.do",
  					method : "GET",
  					dataType : "text",
  					async : false,
  					cache : false,
  					data : {
      					treeID : pTreeID ,
      					boardID :  pBoardID
  					},
      				success : function(result) {
      					pResult = result;
  					},
  					error : function(jqXHR, textStatus, errorThrown) {
             	    	alert('Error : ' + jqXHR.status + ", " + textStatus);
             	    	return;
  					}
  				});
            	
            	return pResult;
			}
			
	    </script>
	</head>
	<body class="popup">
	    <h1 style="margin-bottom: 0px;"><spring:message code='ezBoard.t10044'/></h1>
	    <div id="close">
	        <ul>
	            <li><span onclick="window.close()"></span></li>
	        </ul>
	    </div>
	    <table class="popuplist" style="width: 100%;margin-top:5px">
	        <tr>
	            <td>
	                <div class="tree" style='width: auto; overflow-x: auto; overflow-y: auto; margin-left: 5px; height: 280px;' id='TreeCtrl_MyBoardTree'></div>
	            </td>
	        </tr>
	    </table>
	    <div class="btnpositionNew">
	        <a  class="imgbtn"><span onClick="add_onclick('U')"><spring:message code='ezBoard.t10045'/></span></a>
	        <a  class="imgbtn"><span onClick="add_onclick('C')"><spring:message code='ezBoard.t10046'/></span></a>
	        <a  class="imgbtn"><span onClick="modify_onclick()"><spring:message code='ezBoard.t316'/></span></a>
	        <a  class="imgbtn"><span onClick="move_onclick()"><spring:message code='ezBoard.t134'/></span></a>
	        <a  class="imgbtn"><span onClick="delete_onclick()"><spring:message code='ezBoard.t89'/></span></a>
	        <c:if test="${type == 'ADD'}">
	            <a  class="imgbtn"><span onClick="add_MyBoard()"><spring:message code='ezBoard.t275'/></span></a>
	        </c:if>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
	        <iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
	    </div>
	</body>
</html>