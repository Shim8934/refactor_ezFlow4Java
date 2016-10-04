<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title><spring:message code='ezApprovalG.t424'/></title>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
	    <link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js"></script>
	    <script type="text/javascript" src="/js/ezApprovalG/SelectSubTitles_Cross.js"></script>
	    <script id="clientEventHandlersJS" type="text/javascript">
	        var OrderCell = "";
	        var labelcolor = "c6c6c6"
	        var xmlhttp = createXMLHttpRequest();
	        var InitTreeVal = "";
	        var pDocID;
	        var pReceiveSN;
	        var CurSelNode;
	        var pAprSate;
	        var arr_userinfo = new Array();
	        arr_userinfo[0] = "user";
	        arr_userinfo[1] = "${userInfo.id}";
	        arr_userinfo[2] = "${userInfo.displayName}";
	        arr_userinfo[3] = "${userInfo.title}";
	        arr_userinfo[4] = "${userInfo.deptID}";
	        arr_userinfo[5] = "${userInfo.deptName}";
	        arr_userinfo[6] = "${userInfo.jikChek}";
	        arr_userinfo[8] = "${userInfo.email}";
	        arr_userinfo[9] = "";
	        arr_userinfo[10] = "${susinAdmin}";
	        arr_userinfo[11] = "${userInfo.displayName1}";
	        arr_userinfo[12] = "${userInfo.displayName2}";
	        arr_userinfo[13] = "${userInfo.title1}";
	        arr_userinfo[14] = "${userInfo.title2}";
	        arr_userinfo[15] = "${userInfo.deptName1}";
	        arr_userinfo[16] = "${userInfo.deptName2}";
	        var pUserID = arr_userinfo[1];
	        var RetValue;
	        var ReturnFunction;
	        var NonActiveX = "YES";
	        window.onload = function () {
	            try {
	                var ua = navigator.userAgent;
	                if (ua.indexOf("Safari") > 0 && ua.indexOf("Chrome") == -1) {
	                    KeEventControl(document.getElementById("textUser"));
	                }
	                try {
	                    RetValue = parent.ezreceiveassignui_cross_dialogArguments[0];
	                    ReturnFunction = parent.ezreceiveassignui_cross_dialogArguments[1];
	                } catch (e) {
	                    try {
	                        RetValue = opener.ezreceiveassignui_cross_dialogArguments[0];
	                        ReturnFunction = opener.ezreceiveassignui_cross_dialogArguments[1];
	                    } catch (e) {
	                        RetValue = window.dialogArguments;
	                    }
	                }
	
	                pDocID = RetValue[0];
	                pReceiveSN = RetValue[1];
	                pAprSate = RetValue[2];
	                if (pReceiveSN == "s")
	                    pReceiveSN = "1";
	                else
	                    pReceiveSN = pReceiveSN.replace("s", "");
	                InitTreeVal = arr_userinfo[4];
	                Tree_setconfig();
	                TreeViewinitialize(InitTreeVal, "${userInfo.companyID}", "", "${serverName}");
	
	                var listview = new ListView();
	                listview.SetID("OrganList");
	                listview.SetMulSelectable(false);
	                listview.SetRowOnDblClick("btnAssign_onclick");
	
	                if (CrossYN())
	                    listview.DataSource(listviewheader);
	                else {
	                    var objXML = createXmlDom();
	                    objXML = loadXMLString(listviewheader.xml);
	                    listview.DataSource(objXML);
	                }
	
	                listview.DataBind("OrganListView");
	
	                if (!CrossYN() && NonActiveX == "NO")
	                    window.returnValue = "cancel";
	
	            } catch (ErrMsg) {
	            alert("window_onload : " + ErrMsg.description);
	        }
	    };
	    function Tree_setconfig() {
	        var xmlHTTP = createXMLHttpRequest();
	        xmlHTTP.open("GET", "/xml/organtree_config.xml", false);
	        xmlHTTP.send();
	
	        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
	            var treeView = new TreeView();
	            treeView.SetConfig(xmlHTTP.responseXML);
	        }
	    }
	    function btnAssign_onclick() {
	        try {
	            var listview = new ListView();
	            listview.LoadFromID("OrganList");
	            var pCurSelRow = listview.GetSelectedRows();
	            if (pCurSelRow.length == 0) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t425'/>";
	                OpenAlertUI(pAlertContent);
	            }
	            else {
	                if (trim_Cross(pCurSelRow[0].getAttribute("DATA3")) == InitTreeVal) {
	                    var RtnVal = setReceiveAssign(pCurSelRow);
	                    if (RtnVal == "TRUE") {
	                        if (ReturnFunction != null) {
	                            ReturnFunction("OK");
	                        }
	                        else {
	                            window.returnValue = "OK";
	                            window.close();
	                        }
	                    } else {
	                        var pAlertContent = "<spring:message code='ezApprovalG.t426'/>";
	                        OpenAlertUI(pAlertContent);
	                    }
	                }
	                else {
	                    var pAlertContent = "<spring:message code='ezApprovalG.t225'/>";
	                    OpenAlertUI(pAlertContent);
	                    return;
	                }
	            }
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	    function btnCancel_onclick() {
	        if (ReturnFunction != null) {
	            ReturnFunction("cancel");
	        }
	        else {
	            window.returnValue = "cancel";
	            window.close();
	        }
	    }
	    function setReceiveAssign(pCurSelRow) {
	        try {
	        	var result = "";
	        	
	            $.ajax({
	        		type : "POST",
	        		dataType : "xml",
	        		async : false,
	        		url : "/ezApprovalG/setJijung.do",
	        		data : {
	        			docID : pDocID,
	        			receiveSN : pReceiveSN,
	        			processorID : trim_Cross(pCurSelRow[0].getAttribute("DATA2")),
	        			processorName : trim_Cross(pCurSelRow[0].getAttribute("DATA8")),
	        			processorJobTitle : trim_Cross(pCurSelRow[0].getAttribute("DATA10")),
	        			receivedDeptID : trim_Cross(pCurSelRow[0].getAttribute("DATA3")),
	        			receivedDeptName : trim_Cross(pCurSelRow[0].getAttribute("DATA12")),
	        			docState : pAprSate,
	        			processorName2 : trim_Cross(pCurSelRow[0].getAttribute("DATA9")),
	        			processorJobTitle2 : trim_Cross(pCurSelRow[0].getAttribute("DATA11")),
	        			receivedDeptName2 : trim_Cross(pCurSelRow[0].getAttribute("DATA13"))
	        		},
	        		success: function(xml){
	        			result = xml;
	        		}        			
	        	});
	            
	            return getNodeText(GetChildNodes(result)[0]);
	        } catch (ErrMsg) {
	            alert(ErrMsg.description);
	        }
	    }
	    function btn_searchUser_onclick() {
	        try {
	            var strSearch = document.getElementById("textUser").value + "";
	            if (textUser.value == "") {
	                var pAlertContent = "<spring:message code='ezApprovalG.t226'/>";
	                OpenAlertUI(pAlertContent);
	                TreeViewNodeClick();
	            }
	            else if (strSearch.length < 2) {
	                var pAlertContent = "<spring:message code='ezApprovalG.t227'/>";
	                OpenAlertUI(pAlertContent);
	                textUser.focus();
	            }
	            else {
                	$.ajax({
                		type : "POST",
                		dataType : "xml",
                		async : true,
                		url : "/ezOrgan/getSearchList.do",
                		data : {
                			search : "displayname::" + strSearch + ";;physicalDeliveryOfficeName::" + "${userInfo.companyID}",
                			cell   : "displayname;title;description;telephonenumber",
                			prop   : "department;extensionAttribute4;displayname;title;description",
                			type   : "user"
                		},
                		success: function(xml){
                			event_displayUserList(xml);
                		}        			
                	});
	            }
	    } catch (ErrMsg) {
	        alert(ErrMsg.description);
	    }
	}
	function textUser_onkeypress() {
	    if (window.event.keyCode == "13") {
	        btn_searchUser.focus();
	    }
	
	}
	var ezapralert_cross_dialogArguments = new Array();
	function OpenAlertUI(pAlertContent, CompleteFunction) {
	    var parameter = pAlertContent;
	    var url = "/ezApprovalG/ezAprAlert.do";
	
	    if (CrossYN() || NonActiveX == "YES") {
	        ezapralert_cross_dialogArguments[0] = parameter;
	        if (CompleteFunction != undefined)
	            ezapralert_cross_dialogArguments[1] = CompleteFunction;
	        else
	            ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
	        DivPopUpShow(330, 205, url);
	    }
	    else {
	        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
	        feature = feature + GetShowModalPosition(330, 205);
	        var RtnVal = window.showModalDialog(url, parameter, feature);
	    }
	}
	
	function OpenAlertUI_Complete() {
	    DivPopUpHidden();
	}
	function TreeViewNodeClick() {
	    var treeView = new TreeView();
	    treeView.LoadFromID("FromTreeView");
	    var nodeIdx = treeView.GetSelectNode();
	    displayUserList(nodeIdx.GetNodeData("CN"));
	}
	function displayUserList(DeptID) {
		$.ajax({
			type : "POST",
			dataType : "xml",
			async : true,
			url : "/ezOrgan/getDeptMemberList.do",
			data : {
					deptID   : DeptID, 
					cell 	 : "displayName;title;description;telephoneNumber",
					prop     : "department;extensionAttribute4;displayName;title;description",
					type 	 : "user"
					},
			success: function(xml){
				event_displayUserList(xml);
			}        			
		});
		
	}
	function event_displayUserList(xml) {
         if (SelectNodes(xml, "LISTVIEWDATA/ROWS/ROW").length > 0) {
             var listview = new ListView();
             listview.LoadFromID("OrganList");
             listview.DataSource(xml);
             listview.RowDataBind();
         }
         else {
             document.getElementById("OrganListView").innerHTML = "";
             var listview = new ListView();
             listview.SetID("OrganList");
             listview.SetMulSelectable(false);
             listview.SetRowOnDblClick("btnAssign_onclick");
             listview.DataSource(listviewheader);
             listview.DataBind("OrganListView");
         }

        textUser.focus();
	}
	function TreeViewNodeDbClick(pNodeID, pTreeID) {
	    var TreeIdx = pNodeID;
	
	    var treeNode = new TreeNode();
	    treeNode.LoadFromID(TreeIdx);
	
	    var deptID = treeNode.GetNodeData("CN");
	
	    GetDeptSubTreeInfo(deptID, TreeIdx);
	
	}
	</script>
	</head>
	<body class="popup">
	    <xml id="listviewheader" style="display: none">
			<LISTVIEWDATA>
				<HEADERS>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t229'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t230'/></NAME>
						<WIDTH>50</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t108'/></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
					<HEADER>
						<NAME><spring:message code='ezApprovalG.t231'/></NAME>
						<WIDTH>70</WIDTH>
					</HEADER>
				</HEADERS>
			</LISTVIEWDATA>
		</xml>
	    <h1><spring:message code='ezApprovalG.t424'/></h1>
	
	    <table style="margin-top: -15px;">
	        <tr>
	            <td style="vertical-align: top;">
	                <h2><spring:message code='ezApprovalG.t232'/></h2>
	                <div class="box" style="overflow: auto; height: 240px; width: 200px" id="TreeView"></div>
	            </td>
	            <td style="vertical-align: top;padding-left:10px;">
	                <h2><spring:message code='ezApprovalG.t233'/></h2>
	                <div class="listview">
	                    <div id="OrganListView" style="border: 0; Width: 225px; Height: 218px; overflow: auto; margin: 1px 1px 1px 1px;"></div>
	                </div>
	                <table style="width: 100%;">
	                    <tr>
	                        <td style="height: 30px; text-align: center;">
	                            <input type="text" id="textUser" name="textUser" style="width: 130px;" value="" onkeypress="return textUser_onkeypress()" tabindex="1"><a class="imgbtn" style="margin-left:5px;vertical-align:middle;"><span id="btn_searchUser" onkeypress="return btn_searchUser_onclick()" onclick="return btn_searchUser_onclick()"><spring:message code='ezApprovalG.t234'/></span></a></td>
	                    </tr>
	                </table>
	            </td>
	        </tr>
	    </table>
	    <div class="btnposition">
	        <a class="imgbtn"><span onclick="return btnAssign_onclick()"><spring:message code='ezApprovalG.t20'/></span></a>
	        <a class="imgbtn"><span onclick="return btnCancel_onclick()"><spring:message code='ezApprovalG.t119'/></span></a>
	    </div>
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>