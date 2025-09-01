<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t152'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}"   type="text/css">
		<link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
		<style type="text/css">
			#FormTreeView{
				padding-top: 5px;
			}
		</style>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/TreeViewFolder.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezApprovalG/getFormCont_Cross.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/showModalDialogCallee.js')}"></script>
		<script ID="clientEventHandlersJS" type="text/javascript">
		    var xmlhttp = createXMLHttpRequest();	
		    var xmldoc = createXmlDom();
		    var OrderCell = "";
		    var pDeptID;
		    var Rtnval = new Array();
		    var DocFileType = "<c:out value = '${docFileType}'/>";
		    var onlySihang = "<c:out value='${onlySihang}'/>";
		    var ext = "<c:out value='${ext}'/>";
		    var TreeIdx;
		    var ListIdx;
		    var RetValue;
		    var ReturnFunction;
		    var reuseFlag = "<c:out value='${reuseFlag}'/>";
			var resendFormYN = "<c:out value='${resendFormYN}'/>";
		    window.onload = function () {
				Get_Favoritelist();
		        DocFileType = DocFileType.toLowerCase();
		        Tree_setconfig();
		        
		        var pFormKind;
		        pDeptID = "<c:out value = '${deptID}'/>";
		
		        try {
		            if (isParentCommonArgsUsed()) {
						RetValue = opener == null ? parent.ezCommon_cross_dialogArguments[0] : opener.ezCommon_cross_dialogArguments[0];
						ReturnFunction = opener == null ? parent.ezCommon_cross_dialogArguments[1] : opener.ezCommon_cross_dialogArguments[1];
					} else {
						RetValue = parent.getformcont_cross_dialogArguments[0];
						ReturnFunction = parent.getformcont_cross_dialogArguments[1];
					}
		        } catch (e) {
		            try {
		                RetValue = opener.getformcont_cross_dialogArguments[0];
		                ReturnFunction = opener.getformcont_cross_dialogArguments[1];
		            } catch (e) {
		                RetValue = window.dialogArguments;
		            }
		        }

		        InitFormCont();
		
		        Rtnval[0] = "cancel";
		        Rtnval[1] = "cancel";
		        if (!CrossYN() || DocFileType == "hwp") {
		            window.returnValue = Rtnval;
		        }
		    };
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/organtree_config2.xml", false);
		        xmlHTTP.send();
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
		    function select_onchange() {
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        if (TreeIdx != "") {
	                var ID = treeNode.GetNodeData("DATA1");
	                var KIND = document.getElementById('FromList').value;
	                GetFormInfo(ID, KIND);
		        }
		    }
		    function TreeViewRequestData(pNodeID, pTreeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		
		        GetFormInfo(ID, KIND);
		
		        if (ID != "ROOT") {
		            GetFormContInfo(ID, DeptID, "REQUEST");
		        }
		    }
		
		    function TreeViewNodeClick(pNodeID) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		        GetFormInfo(ID, KIND);
		    }
		
		    function TreeViewNodeClick(pNodeID, pNodeNM) {
		        TreeIdx = pNodeID;
		        var treeNode = new TreeNode();
		        treeNode.LoadFromID(TreeIdx);
		        ID = treeNode.GetNodeData("DATA1");
		        DeptID = treeNode.GetNodeData("DATA2");
		        KIND = document.getElementById('FromList').value;
		        GetFormInfo(ID, KIND);
		    }
		
		    function lvtForm_onSel_Changed() {
		        var listview = new ListView();
						listview.LoadFromID("lvtForm");
				var oArrRows = listview.GetSelectedRows();
		        var tr = oArrRows[0];
		        if (tr) {
						document.getElementById('descrip').innerHTML = tr.getAttribute("DATA2");
		        }
		    }
		    function lvtForm_onSel_Click() {
		    }
		    function lvtForm_onSel_DBclick() {
		        btnOK_onclick();
		    }
		    function lvtForm_onclick() {
		    }
		    function btnOK_onclick() {
		        var URL;
		        var listview = new ListView();
		            listview.LoadFromID("lvtForm");
		        var oArrRows = listview.GetSelectedRows();
		        var selRow = oArrRows[0];
		        if (selRow) {
		            URL = selRow.getAttribute("DATA4");
		            if ((DocFileType == "") || (URL.substr(URL.length - 3, URL.length).toLowerCase() == DocFileType)) {
		            	if (onlySihang == "YES" && selRow.getAttribute("DATA3") != "004") {
		            		var pAlertContent = "<spring:message code='ezApprovalG.t191'/>";
		            		OpenAlertUI(pAlertContent);
		            		return;
		            	}else if(ext != "" && URL.indexOf(ext) == -1){
		            		var pAlertContent = ext + " <spring:message code='ezApprovalG.t1536'/>";
		            		OpenAlertUI(pAlertContent);
		            		return;
		            	}
		            	
		                Rtnval[0] = selRow.getAttribute("DATA4");
		                Rtnval[1] = selRow.getAttribute("DATA3");
		                Rtnval[2] = selRow.getAttribute("DATA1");
		                Rtnval[3] = selRow.childNodes[0].innerText;
		                <%-- 2021-01-21 심기영 오피스 결재 양식 추가 --%>
		                Rtnval[4] = selRow.getAttribute("DATA-OFFICEFLAG");
						Rtnval[5] = RetValue[2];

		                Rtnval["reformflag"] = selRow.getAttribute("reformflag");
		                
		                if (ReturnFunction != null) {
		                    ReturnFunction(Rtnval);
		                } else {
		                    window.returnValue = Rtnval;
		                }
		                
		                window.close();
		            } else {
		                if (DocFileType == "doc") {
		                    var pAlertContent = "<spring:message code='ezApprovalG.t1528'/>" + "<br>MHT, HWP " + "<spring:message code='ezApprovalG.t1529'/>";
		                } else if (DocFileType == "hwp") {
		                	if (reuseFlag != "Y") {
			                    var pAlertContent = "<spring:message code='ezApprovalG.t1530'/>" + "<br>MHT," + "<spring:message code='ezApprovalG.t1531'/>";
		                	} else {
		                		var pAlertContent = "HWP " + "<spring:message code='ezApprovalG.t1532'/>";
		                	}
		                } else {
		                    var pAlertContent = "MHT " + "<spring:message code='ezApprovalG.t1532'/>" + "<br>HWP, " + "<spring:message code='ezApprovalG.t1531'/>";
		                }
		                
		                OpenAlertUI(pAlertContent);
		            }
		        } else {
		            var pAlertContent = "<spring:message code='ezApprovalG.t1533'/>";
		            OpenAlertUI(pAlertContent);
		        }
		    }
		    function btncancel_onclick() {
		        if (ReturnFunction != null) {
		            ReturnFunction(Rtnval);
		        }
		        else {
		            window.returnValue = Rtnval;
		        }
		        window.close();
		    }
		    function Localload_onclick(pGubun) {
		        Rtnval[0] = "PC";
		        Rtnval[1] = "PC";
		        Rtnval[2] = pGubun;
		        if (ReturnFunction != null) {
		            ReturnFunction(Rtnval);
		        }
		        else {
		            window.returnValue = Rtnval;
		        }
		        window.close();
		    }
		
		    var Tab1_SelectID = "";
		    var Tab1_flag = true;
		    function Tab1_MouserOver(obj) {
		        obj.className = "tabover";
		    }
		    function Tab1_MouserOut(obj) {
		        if (Tab1_SelectID != obj.id)
		            obj.className = "";
		    }
		    function Tab1_MouseClick(obj) {
		        obj.className = "tabon";
		        if (obj.id != Tab1_SelectID) {
		            if (Tab1_SelectID != "" && document.getElementById(Tab1_SelectID) != null)
		                document.getElementById(Tab1_SelectID).className = "";
		            obj.className = "tabon";
		            Tab1_SelectID = obj.id;
		            ChangeTab(obj);

		        }
		    }
		    function Tab1_NewTabIni(pTabNodeID) {
		        for (var i = 0; i < document.getElementById(pTabNodeID).childNodes.length; i++) {
		            if (document.getElementById(pTabNodeID).childNodes[i].nodeName == "P") {
		                if (document.getElementById(pTabNodeID).childNodes[i].childNodes[0].nodeName == "SPAN") {
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseover = function () { Tab1_MouserOver(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onmouseout = function () { Tab1_MouserOut(this); };;
		                    document.getElementById(pTabNodeID).childNodes[i].childNodes[0].onclick = function () { Tab1_MouseClick(this); };;
		
		                    if (Tab1_flag) {
		                        document.getElementById(pTabNodeID).childNodes[i].childNodes[0].className = "tabon";
		                        Tab1_SelectID = document.getElementById(pTabNodeID).childNodes[i].childNodes[0].id;
		                        Tab1_flag = false;
		                    }
		                }
		            }
		        }
		    }
		
		    var pSelectTab = "";
		    var tempFromList = 0; //양식리스트
		    function ChangeTab(obj) {
	            document.getElementById("FromList").selectedIndex = tempFromList;
// 	            document.getElementById("favoritetable").style.display = "none";
// 	            document.getElementById("formtable").style.display = "";
		    }

			var favFirst = true;
		    function Get_Favoritelist(type) {
		    	var _searchType = "";
		    	var _searchName = "";
		    	var xmlRtn = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		dataType : "text",
		    		async : false,
		    		url : "/ezApprovalG/getForm.do", 
		    		data : {
		    				id : "ROOT",
		    				kind  : document.getElementById('FromList').value,
		    				searchType : _searchType,
		    				searchName : _searchName
		    				},
		    		success: function(xml){
		    			xmlRtn = loadXMLString(xml); 
		    		}        			
		    	});
		
		        document.getElementById('divlvtFavForm').innerHTML = "";  
		        document.getElementById('descrip2').innerHTML = ""; 
		
		        var listview = new ListView(); 
		        listview.SetID("lvtFavForm"); 
		        listview.SetMulSelectable(false); 
		        listview.SetRowOnClick("lvtForm_onSel_Changed"); 
		        listview.SetRowOnDblClick("lvtForm_onSel_DBclick"); 
		        listview.DataSource(xmlRtn); 
		        listview.DataBind("divlvtFavForm"); 
		
		        var selRow = listview.GetSelectedRows(); 
		        var tr = selRow[0]; 
		
		        if (tr) {
		            listview.SetSelectFlag(true); 
		            document.getElementById('descrip2').innerHTML = tr.getAttribute("DATA2");
		        } else if (favFirst) {
					favFirst = false;
					Tab1_MouseClick(document.querySelector('[divname=formlist]')); 
				}
		    }
		</script>
		<style type="text/css">
			.sub_iconLNB.tree_plus, .sub_iconLNB.tree_minus {
	    		margin-top : 0px !important;
	    	} 
		</style>
	</head>
	<body class="popup">
		<xml id='FORMLIST' style="Display:none">
		<LISTVIEWDATA>
			<HEADERS>
				<HEADER>
					<NAME><spring:message code='ezApprovalG.t1537'/></NAME>
					<WIDTH>215</WIDTH>
				</HEADER>
			</HEADERS>
		</LISTVIEWDATA>
		</xml>
		<xml id='FORMCONTAINER' style="Display:none">
		<TREEVIEWDATA>
			<NODE>
				<EXPANDED>TRUE</EXPANDED>
				<ISLEAF>FALSE</ISLEAF>
				<VALUE><spring:message code='ezApprovalG.t1539'/></VALUE>
			</NODE>
		</TREEVIEWDATA>
		</xml>
		<h1 style="margin-bottom:5px"><spring:message code='ezApprovalG.t152'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="return btncancel_onclick()"></span></li>
            </ul>
        </div>
        <div style="margin-bottom: 50px;">
				    	<select name="select" onChange="return select_onchange()" id="FromList" style="height:24px; display: none;">
						    ${docType}
					    </select>
		        <div class="portlet_tabpart01" style="margin-top: 12px; width: 465px;display: none;">
		        <div class="portlet_tabpart01_top" id="tab1" style="display: none;">
		            <p><span id="1tab1" style="display: none;" divname="favoritelist"><spring:message code='ezApprovalG.G0001'/></span></p>
		            <p><span id="1tab2" style="display: none;" divname="formlist"><spring:message code='ezApprovalG.t1537'/></span></p>
					<p><span id="1tab3" style="display: none;" divname="resendformlist"><spring:message code='ezApprovalG.resendKMH01'/></span></p>
		        </div>
		    </div>
		    <table id="favoritetable" style="margin-top: 5px; width: 465px; display: none;">
		        <tr>
		            <td style="vertical-align: top;">
		                <div class="border_gray" style="border-bottom: 0px">
		                    <div id="divlvtFavForm" style="border: 0; WIDTH: 100%; HEIGHT: 354px; overflow:auto; padding: 0px"></div>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td style="vertical-align: top;">
		                <table class="content">
		                    <tr>
		                        <th><spring:message code='ezApprovalG.t1543'/></th>
		                        <td id="descrip2" style="width: 95%">&nbsp;</td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		    <table id="formtable" style="margin-top: 5px;width: 465px;">
		        <tr>
		            <td rowspan="2" style="vertical-align: top;">
		                <div id="TreeView" style="height: 235px; width: 195px; overflow-x: auto; overflow-y: auto; BORDER: #ddd 1px solid; BACKGROUND-COLOR: #ffffff; padding: 4px,6px,6px,4px"></div>
		            </td> 
		            <td style="padding-left: 5px; vertical-align: top;">
		                <div class="border_gray" style="border-bottom: 0px; width:265px;"> 
		                    <!-- 기존 class="listview" -->
		                    <div id="divlvtForm" style="BORDER: 0; WIDTH: 260px; HEIGHT: 204px; margin:auto; overflow-y: auto; overflow-x: hidden;"></div>
		                </div>
		            </td>
		        </tr>
		        <tr>
		            <td style="padding-left: 5px; vertical-align: top;">
		                <table class="content" style="height: 29px;">
		                    <tr>
		                        <th><spring:message code='ezApprovalG.t1543'/></th>
		                        <td id="descrip" style="width: 95%;">&nbsp;</td>
		                    </tr>
		                </table>
		            </td>
		        </tr>
		    </table>
		</div>
		<div class="btnposition btnpositionNew" >
		  <a class="imgbtn"><span onClick="return btnOK_onclick()" ><spring:message code='ezApprovalG.t20'/></span></a>
		  <a class="imgbtn"><span onClick="return btncancel_onclick()" ><spring:message code='ezApprovalG.t119'/></span></a>
		</div>
		    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>	
			<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
				<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
			</div>
	    <script type="text/javascript">
		        Tab1_NewTabIni("tab1");
		</script> 
	</body>
</html>
