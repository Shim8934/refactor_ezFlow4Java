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
	    <link rel="stylesheet" href="${util.addVer('/css/Tab.css')}" type="text/css">
	    <title><spring:message code='main.t57' /></title>
	    <style>
	    	#mainmenu > div { display: inline-block; }
	    
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
	    	.DL_Table tr>*:nth-child(4) { width: 8%; }
	    	.DL_Table tr>*:nth-child(5) { }
	    	.DL_Table tr>*:nth-child(6) { width: 8%; }
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
			<div id="mainmenu" style="float:left; width:100%;">
				<div style="float:right; ">
					<input type="text" name="searchInput" class="searchInput" maxlength="30" />
					<a class="imgbtn" style="vertical-align:middle"><span onclick="search_click()"><spring:message code='ezEmail.t37' /></span></a>
				</div>
			</div>
			<div>
				<table id="DL_Head" class="DL_Table">
					<thead>
						<tr>
							<th><spring:message code='ezEmail.lhm09' /></th>
							<th><spring:message code='ezEmail.t710' /></th>
							<th><spring:message code='ezEmail.userDL25' /></th>
							<th><spring:message code='ezEmail.userDL03' /></th>
							<th><spring:message code='ezEmail.userDL04' /></th>
							<th><spring:message code='ezEmail.userDL05' /></th>
							<th width="4" id="forScroll"></th>
						</tr>					
					</thead>
				</table>
				<div class="DL_Body_div">
					<table id="DL_Body" class="DL_Table">
						<tbody>
							<tr id="noData"><td><spring:message code='ezEmail.userDL18' /></td></tr>
						</tbody>
					</table>
				</div>
			</div>
			
		</div>
	</body>
	<script type = "text/javascript">
    	var Xmlhttp = null;
		var companyId = "${companyId}";
		
		window.onload = window_onload;
		window.onresize = window_resize;
		
		function window_onload() {
			$(".searchInput").on({
				"keypress": function(event) {
					if (event.keyCode == 13) { return search_click(); }		
				}
			});
			
			window_resize();
			isScroll();
		}
	    
		function window_resize() {
			var ch = window.frameElement.offsetHeight - 150;
			if (ch < 60) {ch = 60; }
			
			$(".DL_Body_div").css({
				"height": ch + "px"
			});
	    }
		
		function makeDlList(data) {
			$("#DL_Body").html("");
			
			var listview = new ListView();
            listview.SetID("DL_Body");
            listview.SetSelectFlag(false);
            listview.SetMulSelectable(false);
            listview.SetAlignArr([1,1,1,1,1]);
            listview.SetRowOnDblClick("memberListPopUp");
            listview.DataSource(data);
            listview.RowDataBind();

			isScroll();
		}
		
		function memberListPopUp() {
        	var listview = new ListView();
            listview.SetID("DL_Body");
            selectNode = listview.GetSelectedRows()[0];

            var cn = selectNode.getAttribute("data1");
	        var popUrl = "/ezEmail/mailDistributionMemberListPop.do";
			var param = "?companyId=" + companyId + "&cn=" + cn + "&type=";
			var popSizeW = 750;
			var popSizeH = 560;
			var feature = "dialogHeight:" + popSizeH + "px; dialogWidth:" + popSizeW + "px; scroll:no;status:no; help:no; edge:sunken";
	        feature = feature + GetShowModalPosition(popSizeW, popSizeH);
	        
	        if (CrossYN()) {
	            var OpenWin = window.open(popUrl + param, "", GetOpenWindowfeature(popSizeW, popSizeH));
	            try { OpenWin.focus(); } catch (e) {console.log(e);}
	        }
	        else {
	            var rtnValue = window.showModalDialog(popUrl + param, companyId, feature);
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
		
		function search_click() {
			var searchVal = $(".searchInput").val().trim();
			if (searchVal == "") {
				alert("<spring:message code='ezEmail.t10' />");
				return;
			} 
			
			$.ajax({
				type:"post",
				url:"/ezEmail/searchUserDistribution.do",
				data:{
					searchValue:searchVal
				},
				success:function(data) {
					makeDlList(data);
					isScroll();
				}, error:function(er) {
					alert("<spring:message code='ezBoard.t19' /> " + er.status );
				}
			});
		}
		
		function getDLList() {
			
		}
	</script>
</html>
