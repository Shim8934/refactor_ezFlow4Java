<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html style="height:97%">
	<head>
		<title><spring:message code='ezApprovalG.t200'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<style>
			.mainlist_free tr th { border-top:0px }
		</style>
		<script type="text/javascript" ID="clientEventHandlersJS">
		var RetValue;
		var ReturnFunction;
		var OrderCell = "";
		
		window.onload = function () {
			try {
			    RetValue = parent.enforceSihang_cross_dialogArguments[0];
			    ReturnFunction = parent.enforceSihang_cross_dialogArguments[1];
			    
			    if (typeof(RetValue) == "undefined") {
			    	RetValue = opener.enforceSihang_cross_dialogArguments[0];
                    ReturnFunction = opener.enforceSihang_cross_dialogArguments[1];
			    }
			} catch (e) {
			    try {
			        RetValue = opener.enforceSihang_cross_dialogArguments[0];
			        ReturnFunction = opener.enforceSihang_cross_dialogArguments[1];
			    } catch (e) {
			        RetValue = window.dialogArguments;
			    }
			}
			
			GetSealInfo();
		};
		
		function btnClose_onclick() {
			if (ReturnFunction != null) {
				ReturnFunction("cancel");
			} else {
				window.returnValue = "cancel";
			}
		}
		
		function GetSealInfo() {
			var rtnXml = createXmlDom();
			var Root, objItem, objData, Rows, Row, Cell;
			var result = "";
	    	
    		$.ajax({
	    		type : "POST",
	    		dataType : "text",
	    		async : false,
	    		url : "/admin/ezApprovalG/getSealList.do",
	    		data : {
	    			flag : "LIST"
	    		},
	    		success: function(xml){
	    			result = loadXMLString(xml);
	    		}
	    	});
    		
    		Root = createNodeInsert(rtnXml, Root, "LISTVIEWDATA");
    		objItem = createNodeAndAppandNode(rtnXml, Root, objItem, "HEADERS");
    		objItem = createNodeAndAppandNode(rtnXml, objItem, objItem, "HEADER");
    		createNodeAndAppandNodeText(rtnXml, objItem, objData, "NAME", "<spring:message code = 'ezApproval.t361' />");
    		createNodeAndAppandNodeText(rtnXml, objItem, objData, "WIDTH", "100");
    		
    		Rows = createNodeAndAppandNode(rtnXml, Root, Rows, "ROWS");
    		if (SelectNodes(result, "ROWS/ROW").length > 0) {
    			var oRow = SelectNodes(result, "ROWS/ROW");
    			for (var i = 0; i < oRow.length; i++) {
    				Row = createNodeAndAppandNode(rtnXml, Rows, Row, "ROW");
    				Cell = createNodeAndAppandNode(rtnXml, Row, Cell, "CELL");
    				createNodeAndAppandNodeText(rtnXml, Cell, objData, "VALUE", SelectSingleNodeValue(GetChildNodes(oRow[i])[0], "VALUE"));
    				createNodeAndAppandNodeText(rtnXml, Cell, objData, "DATA1", SelectSingleNodeValue(GetChildNodes(oRow[i])[0], "DATA1"));
    				createNodeAndAppandNodeText(rtnXml, Cell, objData, "DATA2", SelectSingleNodeValue(GetChildNodes(oRow[i])[0], "DATA2"));
    				createNodeAndAppandNodeText(rtnXml, Cell, objData, "DATA3", SelectSingleNodeValue(GetChildNodes(oRow[i])[0], "DATA3"));
    				createNodeAndAppandNodeText(rtnXml, Cell, objData, "DATA4", SelectSingleNodeValue(GetChildNodes(oRow[i])[1], "VALUE"));
    				createNodeAndAppandNodeText(rtnXml, Cell, objData, "DATA5", SelectSingleNodeValue(GetChildNodes(oRow[i])[2], "VALUE"));
    			}
    		}
    		
    		var sealList = new ListView();
			sealList.SetID("pSealList");
			sealList.SetRowOnClick("sealList_onclick");
			sealList.SetRowOnDblClick("btnOk_onclick");
			sealList.SetSelectFlag(true);
			sealList.SetHeightFree(true);
			sealList.DataSource(rtnXml);
			sealList.DataBind("lvSeal");
			sealList_onclick();
	    }
		
		function sealList_onclick() {
			var pSealList = new ListView();
			pSealList.LoadFromID("pSealList");
			
			var oSelRow = pSealList.GetSelectedRows();
			if (oSelRow.length > 0) {
				var pImgUrl = GetAttribute(oSelRow[0], "DATA2");
				var img = document.createElement("IMG");
				img.src = pImgUrl;
				img.style.height = "105px";
				img.style.width = "105px";
				
				document.getElementById("sealImgView").innerHTML = "";
				document.getElementById("sealImgView").appendChild(img);
			}
		}
		
		function btnOk_onclick() {
			var pSealList = new ListView();
			pSealList.LoadFromID("pSealList");
			
			var oSelRow = pSealList.GetSelectedRows();
			if (oSelRow.length > 0) {
				var RetArray = new Array();
				RetArray[0] = GetAttribute(oSelRow[0], "DATA2");
				RetArray[1] = GetAttribute(oSelRow[0], "DATA4");
				RetArray[2] = GetAttribute(oSelRow[0], "DATA5");
				
				if (ReturnFunction != null) {
					ReturnFunction(RetArray);
				}
			}
		}
		</script>
	</head>
	<body class="popup" style="OVERFLOW:hidden;height:100%">
		<h1><spring:message code='ezApproval.t369'/></h1>
		
		<div id="close">
			<ul>
				<li id="btnClose"><span onclick="return btnClose_onclick()"></span></li>
			</ul>
		</div>
		
		<table>
			<tr>
				<td>
					<div id="sealImgView" style="border: 1px solid #ddd; width:165px; height:190px; padding-top: 75px; padding-left: 65px;"></div>
				</td>
				<td>
					<div class="listview" style="width:250px; height:265px; overflow-y:auto; overflow-x:hidden; margin-left: 6px;">
						<div id=lvSeal class="text" style="OVERFLOW-Y:auto; overflow-x:auto; border:0; width:250px; height:265px;"></div>
					</div>
				</td>
			</tr>
		</table>
		
		<div class="btnposition btnpositionNew">
		    <a class="imgbtn"><span id="btnOk" onClick="return btnOk_onclick()"><spring:message code='ezApprovalG.t436'/></span></a>
	    </div>
		
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
