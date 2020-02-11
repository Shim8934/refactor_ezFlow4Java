<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	    <link rel="stylesheet" href="${util.addVer('ezEmail.c1', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
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
					<li onClick="secessionUserDL()"><span><spring:message code='ezEmail.userDL09' /></span></li>
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
							<th width="4" id="forScroll"></th>
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
			// getDLList();
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
				url:"",
				dataType:"json",
				data:{},
				success:function(data) {
					makeDlList(data);
					isScroll();
				}
			})
		}
		
		function makeDlList(data) {
			var showItem = ["id", "name", "policy", "memo", "endDate"];
			var $DL_Tbody = $("<tbody></tbody>");
			var $DLTable = $("#DL_Body");
			if (data.length > 1) {
				for (var i in data) {
					var $TR_Temp = $("<tr></tr>");
					
					$.each(data[i], function(key, value){
						$TR_Temp.attr("data-" + key, value);
						
						if (showItem.indexOf(key) > -1) {
							var $TD_Temp = $("<td>" + value + "</td>");
							$TR_Temp.append($TD_Temp);
						}
					});
					
					$DL_Tbody.append($TR_Temp);
				}
			} else {
				var $TR_Temp = $("<tr id='noData'><td><spring:message code='ezEmail.userDL06' /></td></tr>");
				$DL_Tbody.append($TR_Temp);
			}				
			
			$DLTable.html($DL_Tbody);
			DLListSetEvent();
			isScroll();
		}
		
		function DLListSetEvent() {
			$("#DL_Body tr:not(#noData)").on({
				click : function() { TR_MouseClick(this);},
				dblclick : function() { TR_MouseDBClick(this);},
				mouseover : function() { TR_MouserOver(this);},
				mouseleave : function() { TR_MouserOut(this);}
			});
		}
		
		function TR_MouseClick(obj) {
			$(obj).parent("tbody").find("tr").not(obj).removeClass("TRSelect");
			$(obj).parent("tbody").find(obj).removeClass("TRHover");
			$(obj).toggleClass("TRSelect");
			/* 
			다중선택
			if ($(obj).hasClass("TRHover")){
				$(obj).removeClass("TRHover");
			}
			$(obj).toggleClass("TRSelect"); */
		}
		
		function TR_MouseDBClick(obj) {
			$(obj).toggleClass("TRSelect");
			memberListPopUp(obj);
		}

		function TR_MouserOver(obj) {
			if (!$(obj).hasClass("TRSelect")){
				$(obj).addClass("TRHover");
			}
        }
		
        function TR_MouserOut(obj) {
        	$(obj).removeClass("TRHover");
        }
        
        function memberListPopUp(obj) {
			var cn = $(obj).data("id");
			var name = $(obj).data("name");
	        var popUrl = "/ezEmail/mailDistributionMemberListPop.do";
			var param = "?companyId=" + companyId + "&cn=" + cn + "&name=" + encodeURIComponent(name);
			var popSizeW = 750;
			var popSizeH = 560;
			var feature = "dialogHeight:" + popSizeH + "px; dialogWidth:" + popSizeW + "px; scroll:no;status:no; help:no; edge:sunken";
	        feature = feature + GetShowModalPosition(popSizeW, popSizeH);
	        
	        if (CrossYN()) {
	            var OpenWin = window.open(popUrl + param, "", GetOpenWindowfeature(popSizeW, popSizeH));
	            try { OpenWin.focus(); } catch (e) { }
	        }
	        else {
	            var rtnValue = window.showModalDialog(popUrl + param, companyId, feature);
	        }
	    }

		function secessionUserDL() {
			var trSelectLen = $(".TRSelect").length;
			if (trSelectLen < 1) {
				alert("<spring:message code='ezEmail.t580' />");
				return;
			}
			
			var ret = confirm("<spring:message code='ezEmail.userDL13' />");
        	if (ret) {
				$.ajax({
					type:"post",
					url:"",
					data:{},
					success:function(e) {
						alert("<spring:message code='ezEmail.userDL08' />");
						getDLList();
					}, error:function(er) {
						alert("<spring:message code='ezEmail.t53' />");
					}
				});
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
