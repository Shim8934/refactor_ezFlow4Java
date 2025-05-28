<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/controls/TreeView.js')}" ></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls_cross/treeview_namespace.htc.js')}"></script>
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <title><spring:message code='main.t57' /></title>
	    <style>
	    	.DL_Table { width: 100%; text-align: center; }
	    	.DL_Table thead tr, tbody tr{ height:30px; }
	    	.DL_Table tbody tr{
	    		height:30px;
			    border-bottom: 1px solid #d2d2d2;
			    cursor: pointer;
	    	}
	    	.DL_Table tbody tr#noData{ cursor: default; }
	    	.DL_Table tr>*:nth-child(1) { width: 14%; }
	    	.DL_Table tr>*:nth-child(2) { width: 14%; }
	    	.DL_Table tr>*:nth-child(3) { width: 8%; }
	    	.DL_Table tr>*:nth-child(4) { }
	    	.DL_Table tr>*:nth-child(5) { width: 8%; }
	    	#DL_Head tr{ border: 1px solid #d2d2d2; }
	    	#DL_Head th{ border: none; }
	    	.DL_Body_div {
		    	width: 100%;
			    overflow-y: auto;
			    box-sizing: border-box;
		    }
		    .TRSelect { background: rgb(241, 248, 255); }
			.TRHover { background-color: rgb(244, 245, 245); }
	    </style>
	</head>
	<body class="mainbody">
		<div>
			<br>
			<div id="mainmenu">
				<ul class="mainMenuBtns">
					<li onClick="addUserDL()"><span><spring:message code='ezEmail.userDL01' /></span></li>
					<li onClick="delUserDL()"><span><spring:message code='ezEmail.userDL02' /></span></li>
				</ul>			
			</div>
			<div>
				<table id="DL_Head" class="DL_Table">
					<thead>
						<tr>
							<th><spring:message code='ezEmail.lhm09' /></th>
							<th><spring:message code='ezEmail.t710' /></th>
							<th><spring:message code='ezEmail.userDL03' /></th>
							<th><spring:message code='ezEmail.userDL04' /></th>
							<th><spring:message code='ezEmail.userDL05' /></th>
							<th width="1" id="forScroll"></th>
						</tr>					
					</thead>
				</table>
				<div class="DL_Body_div">
					<table id="DL_Body" class="DL_Table"></table>
				</div>
			</div>
			
		</div>
	</body>
	<script type = "text/javascript">
    	var Xmlhttp = null;
		var companyId = "${companyId}";
		var userId = "${userId}";
		
		window.onload = window_onload;
		window.onresize = window_resize;
		
		function window_onload() {
			window_resize();
			getDLList();
		}
	    
		function window_resize() {
			var ch = window.frameElement.offsetHeight - 100;
			if (ch < 60) {ch = 60; }
			
			$(".DL_Body_div").css({
				"height": ch + "px"
			});
	    }
		
		function getDLList() {
			$.ajax({
				type:"post",
				url:"/ezEmail/mailGetUserDistribution.do",
				data:{userId:userId, companyId:companyId, type:"owner"},
				success:function(data) {
					makeDlList(data);
				}, error:function(er) {
					alert("<spring:message code='ezEmail.t574' />" + er.status);
				}
			})
		}
		
		function makeDlList(data) {
			$("#DL_Body").html("");
			
			var listview = new ListView();
            listview.SetID("DL_Body");
            listview.SetSelectFlag(false);
            listview.SetMulSelectable(false);
            listview.SetAlignArr([1,1,1,1,1]);
            listview.SetRowOnDblClick("mod_dl");
            listview.DataSource(data);
            listview.RowDataBind();

			isScroll();
		}
		
	    var mail_add_distributionlist_cross_dialogArguments = new Array();
		function addUserDL() {
	        var popUrl = "/admin/ezEmail/mailAddDistributionList.do";
			var param = "?companyId=" + companyId + "&userDL=add";
			var popSizeW = 970;
			var popSizeH = 740;
			var feature = "dialogHeight:" + popSizeH + "px; dialogWidth:" + popSizeW + "px; scroll:no;status:no; help:no; edge:sunken";
	        feature = feature + GetShowModalPosition(popSizeW, popSizeH);
	        
	        if (CrossYN()) {
	            mail_add_distributionlist_cross_dialogArguments[0] = companyId;
	            mail_add_distributionlist_cross_dialogArguments[1] = getDLList;
	            var OpenWin = window.open(popUrl + param, "", GetOpenWindowfeature(popSizeW, popSizeH));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        else {
	            var rtnValue = window.showModalDialog(popUrl + param, companyId, feature);
	            if (typeof (rtnValue) != "undefined")
	            	getDLList();
	        }
		}
		
		function add_dl_Complete(rtnValue) {
	        if (typeof (rtnValue) != "undefined")
	        	getDLList();
	    }
		
		function mod_dl() {
			var listview = new ListView();
            listview.SetID("DL_Body");
            var selectNode = listview.GetSelectedRows()[0];

            var dlId = selectNode.getAttribute("data1");
			var dlName = selectNode.getAttribute("data2");
	        var popUrl = "/admin/ezEmail/mailAddDistributionList.do";
			var param = "?companyId=" + companyId + "&userDL=modify" + "&cn=" + dlId + "&name=" + encodeURIComponent(dlName);
			var popSizeW = 970;
			var popSizeH = 750;
			var feature = "dialogHeight:" + popSizeH + "px; dialogWidth:" + popSizeW + "px; scroll:no;status:no; help:no; edge:sunken";
	        feature = feature + GetShowModalPosition(popSizeW, popSizeH);
	        
	        if (CrossYN()) {
	            mail_add_distributionlist_cross_dialogArguments = new Array();
	            mail_add_distributionlist_cross_dialogArguments[0] = companyId;
	            mail_add_distributionlist_cross_dialogArguments[1] = getDLList;
	            var OpenWin = window.open(popUrl + param, "", GetOpenWindowfeature(popSizeW, popSizeH));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        else {
	            var rtnValue = window.showModalDialog(popUrl + param, companyId, feature);
	            if (typeof (rtnValue) != "undefined")
	            	getDLList();
	        }
	    }
		 
	    function mod_dl_Complete(rtnValue) {
	        if (typeof (rtnValue) != "undefined")
	        	getDLList();
	    }
		
		function delUserDL() {
			var listview = new ListView();
            listview.SetID("DL_Body");
            var selectNode = listview.GetSelectedRows();
			var selectedCount = selectNode.length;
			
	        if (selectedCount > 0) {
		        var ret = confirm("<spring:message code='ezEmail.0hun04' />");
	        	if (ret) {
		            var dlId = selectNode[0].getAttribute("data1");

		            var xmlDom = createXmlDom();
	    	        var xmlHTTP = createXMLHttpRequest();
	    	        var objNode = "";
	    	        createNodeInsert(xmlDom, objNode, "DATA");
	    	        
			        createNodeAndInsertText(xmlDom, objNode, "CN", dlId);
			        createNodeAndInsertText(xmlDom, objNode, "COMPID", companyId);
			        
			        xmlHTTP.open("POST", "/admin/ezEmail/mailDelDistributionList.do", false);
			        xmlHTTP.send(xmlDom);
			        
			        if (xmlHTTP.status != 200 || xmlHTTP.responseText != "OK") {
			            alert("<spring:message code='ezEmail.t53' />");
			            getDLList();
			            return;
			        }
			        
			        alert(selectedCount + "<spring:message code='ezEmail.t54' />");
			        getDLList();
		        }
	        } else {
	            alert("<spring:message code='ezEmail.t51' />");		            
	        }
	    }
		
		function isScroll(){
			var forScroll = $("#DL_Head #forScroll"); 
		
			if ($(".DL_Body_div").height() < $(".DL_Body_div table").height()) {
				forScroll.css("display", "");
			} else {
				forScroll.css("display", "none");
			}
		}
	</script>
</html>
