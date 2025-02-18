<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.multiDomain.ksa01' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<style>
			.mainlist tr {
				cursor: pointer; 
				background-color: rgb(255, 255, 255);
			}
			.mainlist tr > td{
				padding-left: 10px;
			}
			.mainlist tr.trClick {
				background-color: rgb(237, 244, 253);
			}
			.mainlist tr.trHover {
				background-color: rgb(244, 245, 245);
			}
		</style>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/Controls/ListView_list.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/Common.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	</head>
	<style>
	</style>
	<body class="mainbody" id="mainBody">
		<h1><spring:message code='ezEmail.multiDomain.ksa01' /></h1>
		<div id="mainmenu">
			<ul>
				<li><span onClick="btnAdd()"><spring:message code='ezEmail.multiDomain.ksa03' /></span></li>
		      	<li><span onClick="btnDel()"><spring:message code='ezEmail.multiDomain.ksa04' /></span></li>
		    </ul>
		</div>	  

		<div style="width:310px; height:400px; border:1px solid #dbdbda;">
			<div style="height: 8%; ">
				<table class="mainlist_free" cellspacing="0" cellpadding="0" width="100%" border="0">
					<thead>
						<tr>
							<th style="padding-left:10px; border-top:0;"><spring:message code='ezEmail.multiDomain.ksa05' /></th>
						</tr>
					</thead>
				</table>
			</div>
			<div style="height: 92%; overflow-y: auto;">
				<table class="mainlist" id="listTable" style="width:100%;">
					<tbody></tbody>
				</table>
			</div>
		</div>
	</body>
	<script type="text/javascript">
		selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
	</script>
	<script>
		var innerDomain;
		var delParam = new Array();
		
		window.onload = function () {
			get_domainList();
	    }
		
		function get_domainList() {
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/getMultiDomainList.do",
				dataType : "json",
				success : function(data) {
					innerDomain = data.innerDomain;
					var tt = data.tenantDomain;
					var htmlSample = "<tr data-domain='{domainTxt}' type='{type}'><td>{domainTxt}</td></tr>";
					var htmlList = "";
					
					if (innerDomain != "") {
						$.each(innerDomain.split(";"), function(index, dd) {
							if (dd.trim() != "") {
								var domainType = dd == tt ? '1' : '0';
								htmlList += htmlSample.replace(/{domainTxt}/gi, dd).replace(/{type}/gi, domainType);	
							}
						});
					} else {
						htmlList = "<tr id='noDataTR' style='text-align:center;cursor:default'><td><spring:message code='main.t00026' /></td></tr>";
					}
					
					$("#listTable tbody").html(htmlList);
				},
				error : function(e) {
					alert("<spring:message code='ezEmail.lhm14' />");
				}
			});
		}

		function del_domain() {
			var delDomain = delParam[0];
			var saveDomainList = delParam[1];
			
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/delMultiDomain.do",
				data : {delDomain:delDomain, saveDomainList:saveDomainList},
				success : function(data) {
					var reasonCode = data.reasonCode;
					var resultData = data.result;
					
					if (reasonCode == 0) {
						alert("<spring:message code='ezEmail.multiDomain.ksa12' />");
						get_domainList();
					} else if (reasonCode == 1){
						alert("<spring:message code='ezEmail.multiDomain.ksa26' />\n" + resultData);
					} else {
						alert("<spring:message code='ezEmail.lhm14' />");
					}
				},
				error : function(e) {
					alert("<spring:message code='ezEmail.lhm14' />");
				}
			});
		}
		
		function btnAdd() {
			var pheight = window.screen.availHeight;
	        var pwidth = window.screen.availWidth;
	        var pTop = (pheight - 460) / 2;
	        var pLeft = (pwidth - 420) / 2;
			var url = "/admin/ezEmail/addMultiDomainPopUp.do?";
			
	        var popup = window.open(url, "popup", "height=150px,width=500px, top=" + pTop.toString() + ", left=" + pLeft.toString());
		}
		
		function btnDel() {
			var clickTR = $("#listTable tr.trClick");
			if (!(clickTR.length > 0)) {
				alert("<spring:message code='ezEmail.multiDomain.ksa24' />");
				return;
			} else if (clickTR.attr("type") == "1") {
				alert("<spring:message code='ezOrgan.lhm1' />");
				return;
			}
			
			var delChk = confirm("<spring:message code='ezEmail.multiDomain.ksa08' />");
			if (delChk) {
				var delDomainListObj = $("#listTable tr:not(.trClick)").get();
				var delDomain = clickTR.attr("data-domain");
				var saveDomainArr = new Array();
				var saveDomainList = innerDomain;
				
				if (delDomainListObj.length > 0) {
					delDomainListObj.forEach(function(e,i) {
						saveDomainArr.push(e.getAttribute('data-domain'));
					});
					
					saveDomainList = saveDomainArr.join(";");
					delParam[0] = delDomain;
					delParam[1] = saveDomainList;
					
					del_domain();
				} else {
					alert("<spring:message code='ezEmail.multiDomain.ksa11' />");
					return;
				}
			}
		}
		
		$(document).on({
			"mouseover" : function() {
				if (!$(this).hasClass("trClick")){
					$(this).addClass("trHover");
				}
			},
			"mouseleave" : function() {
				$(this).removeClass("trHover");
			},
			"click" : function() {
				$(this).removeClass("trHover");
				$(this).toggleClass("trClick");
				
				$("#listTable tr.trClick").not($(this)).removeClass("trClick")
			}
		}, "#listTable tr:not(#noDataTR)");

	</script>
</html>



