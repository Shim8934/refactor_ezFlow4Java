<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code = 'ezApprovalG.t799' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e2'/>" type="text/css">
		<link rel="stylesheet" href="<spring:message code='ezApprovalG.e3'/>" type="text/css">
		<link rel="stylesheet" href="/css/organ_tree.css" type="text/css">
		<script type="text/javascript" src="<spring:message code='ezApprovalG.e1'/>" ></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeView.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/ListView_list.js"></script>
		<script type="text/javascript" src="/js/ezApprovalG/TreeViewCtrl_Cross.js" ></script>
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		
		<script type="text/javascript">
			var OrderCell = "";;
		    var labelcolor = "c6c6c6";
		    var xmlhttp = createXMLHttpRequest();
		    var InitTreeVal = "";
		    var companyID;
		    var listview = new ListView();
		    var treeview = new TreeView();
		    var RetValue;
		    var ReturnFunction;
		    
		    $(document).ready(function(){
		        try {
		            try {
		                RetValue = parent.taskdeptinfomanage_cross_dialogArguments[0];
		                ReturnFunction = parent.taskdeptinfomanage_cross_dialogArguments[1];
		            } catch (e) {
		                try {
		                    RetValue = opener.taskdeptinfomanage_cross_dialogArguments[0];
		                    ReturnFunction = opener.taskdeptinfomanage_cross_dialogArguments[1];
		                } catch (e) {
		                    RetValue = window.dialogArguments;
		                }
		            }
		            
		            TaskCode = RetValue[1];
		            companyID = RetValue[2];
		            InitTreeVal = companyID;
		            Tree_setconfig();
		            TreeViewinitialize("", companyID, "extensionAttribute2;displayName2", "<c:out value='${serverName}'/>");
		            InitListView();
	
		            AprLineInit();
		        } catch (ErrMsg) {
		            alert(ErrMsg.description);
		        }
		    });
	
		    function Tree_setconfig() {
		        var xmlHTTP = createXMLHttpRequest();
		        xmlHTTP.open("GET", "/xml/ezApprovalG/conttree_config.xml", false);
		        xmlHTTP.send();
		        
		        if (xmlHTTP.readyState == 4 && xmlHTTP.status == 200) {
		            var treeView = new TreeView();
		            treeView.SetConfig(xmlHTTP.responseXML);
		        }
		    }
	
		    function InitListView() {
		        var xmlTree = createXmlDom();
		        xmlTree = loadXMLString("");
	
		        listview.SetID("lvtDocForm");
		        listview.SetMulSelectable(false);
		        listview.SetRowOnDblClick("btn_DeptDel_onclick");
		        listview.DataSource(xmlTree);
		        listview.DataBind("APRLINE1");
		    }
	
		    function AprLineInit() {
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/getTaskCodeDeptInfo.do",
		    		async : false,
		    		data : {taskCode : TaskCode, companyID : companyID},
		    		success : function(result) {
		    			document.getElementById("APRLINE1").innerHTML = "";
		    			listview.DataSource(loadXMLString(result));
				        listview.DataBind("APRLINE1");
		    		}
		    	});
		    }
		    
		    var ezapropinion_cross_dialogArguments = new Array();
		    function btn_DeptIns_onclick() {
		        treeview.LoadFromID("FromTreeView");
		        var nodedata = treeview.GetSelectNode();
		        var pDeptID = nodedata.GetNodeData("CN");
		        var pDeptName = nodedata.GetNodeData("VALUE");
		        var pDeptName2 = nodedata.GetNodeData("DISPLAYNAME2");
	
		        if (CrossYN()) {
		            ezapropinion_cross_dialogArguments[0] = "<spring:message code = 'ezApprovalG.t800' />";
		            ezapropinion_cross_dialogArguments[1] = btn_DeptIns_onclick_Complete;
	
		            DivPopUpShow(330, 205, "/ezApprovalG/ezAprOpinion.do", "ezAPROPINION");
		        } else {
		            if (OpenInformationUI("<spring:message code = 'ezApprovalG.t800' />")) {
		                btn_DeptIns_onclick_Complete(true);
		            } else {
		                btn_DeptIns_onclick_Complete(false);
		            }
		        }
		        //var ezAPROPINION_Cross = window.open("/myoffice/ezApprovalG/ezAPROPINION_Cross.aspx", "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		        //try { ezAPROPINION_Cross.focus(); } catch (e) {
		        //}
		    }
		    
		    function btn_DeptIns_onclick_Complete(rtv) {
		        DivPopUpHidden();
		        if (rtv) {
		            treeview.LoadFromID("FromTreeView");
		            var nodedata = treeview.GetSelectNode();
		            var pDeptID = nodedata.GetNodeData("CN");
		            var pDeptName = nodedata.GetNodeData("VALUE");
		            var pDeptName2 = nodedata.GetNodeData("DISPLAYNAME2");
	
		            if (InsertDeptInfo(pDeptID, pDeptName, pDeptName2) == "TRUE") {
		                OpenAlertUI("<spring:message code = 'ezApprovalG.t801' />");
		                AprLineInit();
		            } else {
		                OpenAlertUI("<spring:message code = 'ezApprovalG.t802' />");
		            }
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t28' />");
		        }
		    }
		    
		    var ezapropinion_cross_dialogArguments = new Array();
		    function btn_DeptDel_onclick() {
		        listview.LoadFromID("lvtDocForm");
		        var selRow = listview.GetSelectedRows();
		        
		        if (selRow) {
		            var pDeptID = selRow[0].cells[0].innerText;
		            var pDeptName = selRow[0].getAttribute("DATA1");
		            var pDeptName2 = selRow[0].getAttribute("DATA2");
		            
		            if (GetTaskCodeNodeExist(pDeptID) == "FALSE") {
		                if (CrossYN()) {
		                    ezapropinion_cross_dialogArguments[0] = "<spring:message code = 'ezApprovalG.t803' />";
		                    ezapropinion_cross_dialogArguments[1] = btn_DeptDel_onclick_Complete;
	
		                    DivPopUpShow(330, 205, "/ezApprovalG/ezAprOpinion.do", "ezAPROPINION");
		                } else {
		                    if (OpenInformationUI("<spring:message code = 'ezApprovalG.t803' />")) {
		                        btn_DeptDel_onclick_Complete(true);
		                    } else {
		                        btn_DeptDel_onclick_Complete(false);
		                    }
		                }
		                //var OpenWin = window.open("/myoffice/ezApprovalG/ezAPROPINION_Cross.aspx", "ezAPROPINION_Cross", GetOpenWindowfeature(330, 205));
		                //try { OpenWin.focus(); } catch (e) {
		                //}
		            } else {
		                OpenAlertUI("<spring:message code = 'ezApprovalG.t806' />");
		            }
		        }
		    }
	
		    function btn_DeptDel_onclick_Complete(rtv) {
		        DivPopUpHidden();
		        
		        if (rtv) {
		            listview.LoadFromID("lvtDocForm");
		            var selRow = listview.GetSelectedRows();
		            var pDeptID = selRow[0].cells[0].innerText;
		            var pDeptName = selRow[0].getAttribute("DATA1");
		            var pDeptName2 = selRow[0].getAttribute("DATA2");
	
		            if (RemoveDeptInfo(pDeptID, pDeptName, pDeptName2) == "TRUE") {
		                OpenAlertUI("<spring:message code = 'ezApprovalG.t804' />");
		                AprLineInit();
		            } else {
		                OpenAlertUI("<spring:message code = 'ezApprovalG.t805' />");
		            }
		        } else {
		            OpenAlertUI("<spring:message code = 'ezApprovalG.t28' />");
		        }
		    }
	
		    function GetTaskCodeNodeExist(pDeptID) {
		    	var retVal = "";
		    	
		    	$.ajax({
		    		type : "POST",
		        	url : "/admin/ezApprovalG/getTaskCodeNodeExist.do",
		        	async : false,
		        	data : {taskCode : TaskCode, deptID : pDeptID, companyID : companyID},
		        	success : function(result) {
		        		retVal = result;
		        	}
		    	});
		    	
		    	return retVal;
		    }
		    
		    function InsertDeptInfo(pDeptID, pDeptName, pDeptName2) {
		    	var tempRet = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/addTaskCodeDeptInfo.do",
		    		async : false,
		    		data : {taskCode : TaskCode, deptID: pDeptID, deptName : pDeptName, deptName2 : pDeptName2, companyID : companyID},
		    		success : function (result){
		    			tempRet = result;
		    		}
		    	});
		    	
		    	return tempRet;
		    }
		    
		    function RemoveDeptInfo(pDeptID, pDeptName, pDeptName2) {
				var tempRet = "";
		    	
		    	$.ajax({
		    		type : "POST",
		    		url : "/admin/ezApprovalG/removeTaskCodeDeptInfo.do",
		    		async : false,
		    		data : {taskCode : TaskCode, deptID: pDeptID, deptName : pDeptName, deptName2 : pDeptName2, companyID : companyID},
		    		success : function (result){
		    			tempRet = result;
		    		}
		    	});
		    	
		    	return tempRet;
		    }
		    
		    function OpenInformationUI(pInformationContent) {
		        var parameter = pInformationContent;
		        var url = "/ezApprovalG/ezAprOpinion.do";
		        var feature = "status:no;dialogWidth:330px;dialogHeight:205px;help:no;scroll:no;edge:sunken";
		        var RtnVal = window.showModalDialog(url, parameter, feature);
		        
		        return RtnVal;
		    }
		    
		    var ezapralert_cross_dialogArguments = new Array();
		    function OpenAlertUI(pAlertContent) {
		        ezapralert_cross_dialogArguments[0] = pAlertContent;
		        ezapralert_cross_dialogArguments[1] = OpenAlertUI_Complete;
		        var ezAPRALERT_Cross = window.open("/ezApprovalG/ezAprAlert.do", "ezAPRALERT", GetOpenWindowfeature(330, 205));
		        
		        try { ezAPRALERT_Cross.focus(); } catch (e) { }
		    }
		    function OpenAlertUI_Complete() {
		    }
		    function MM_swapImgRestore() {
		        var i, x, a = document.MM_sr; for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++) x.src = x.oSrc;
		    }
		    function MM_preloadImages() {
		        var d = document; if (d.images) {
		            if (!d.MM_p) d.MM_p = new Array();
		            var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
		                if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; }
		        }
		    }
		    function MM_findObj(n, d) {
		        var p, i, x; if (!d) d = document; if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
		            d = parent.frames[n.substring(p + 1)].document; n = n.substring(0, p);
		        }
		        if (!(x = d[n]) && d.all) x = d.all[n]; for (i = 0; !x && i < d.forms.length; i++) x = d.forms[i][n];
		        for (i = 0; !x && d.layers && i < d.layers.length; i++) x = MM_findObj(n, d.layers[i].document); return x;
		    }
		    function MM_swapImage() {
		        var i, j = 0, x, a = MM_swapImage.arguments; document.MM_sr = new Array; for (i = 0; i < (a.length - 2) ; i += 3)
		            if ((x = MM_findObj(a[i])) != null) { document.MM_sr[j++] = x; if (!x.oSrc) x.oSrc = x.src; x.src = a[i + 2]; }
		    }
		    var nodeIdx;
		    function TreeViewNodeClick() {
		        nodeIdx = TreeView.selectedIndex;
		    }
		</script>
	
	</head>
	<body class="popup">
		<h1><spring:message code = 'ezApprovalG.t799' /></h1>
		<div id="close">
			<ul>
		    	<li><span onClick="window.close()"><spring:message code = 'ezApprovalG.t64' /></span></li>
			</ul>
		</div>
		
		<table>
			<tr>
		    	<td style="vertical-align:top;"><h2><spring:message code = 'ezApprovalG.t232' /></h2>
		      		<div class="box" style="OVERFLOW:auto;width:210px; HEIGHT:245px" id="TreeView"></div>
		      	</td>
		
		    	<td style="width:25px;text-align:center;">
		    		<input type="image" name="Image10" id="AprlineAdd" style="border:0px;" src="/images/arr_right.gif"width="16" height="16" onClick="return btn_DeptIns_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image10','','/images/arr_right.gif',1)">
		      		<input type="image" name="Image11" id="AprlineDel" style="border:0px;"  src="/images/arr_left.gif" width="16" height="16" onClick="return btn_DeptDel_onclick()" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image11','','/images/arr_left.gif',1)">
		      	</td>
											
		    	<td style="vertical-align:top;">
		    		<h2><spring:message code = 'ezApprovalG.t432' /></h2>
		      		<div class="listview">
		        		<DIV id="APRLINE1" style="BORDER:0;WIDTH: 179px; HEIGHT: 245px;  OVERFLOW-Y:auto; OVERFLOW-X:auto;" ></DIV>
		      		</div>
		      	</td>
			</tr>
		</table>
		
		<div class="point"><spring:message code = 'ezApprovalG.t807' /></div>
		
		<script type="text/javascript">
			selToggleList(document.getElementById("close"), "ul", "li", "0");
		</script>
		
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.7); display: none;" id="mailPanel">&nbsp;</div>	
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="/blank.htm" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>