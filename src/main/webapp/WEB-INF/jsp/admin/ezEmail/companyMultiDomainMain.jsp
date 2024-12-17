<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezEmail.multiDomain.ksa02' /></title>
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
		<h1><spring:message code='ezEmail.multiDomain.ksa02' /></h1>
		<div id="mainmenu"> <!-- mainmenu -->    
   		   <span><b><spring:message code='ezOrgan.t00006' /> : </b>    		           
	        <select id="ListCompany" onchange="company_change()">
	        	<c:forEach var="item" items="${companylist}">
	        		<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
	        	</c:forEach>
	        </select>
	        </span>
   		</div>
	        
		<div style="width: 655px;">
			<table style="width: 100%; height: 400px;">
				<colgroup>
					<col width="310px">
					<col width="">
					<col width="310px">
				</colgroup>
				<tr style="height:100%;">
					<!-- 전체 도메인 -->
					<td>
						<div style="height: 100%; border:1px solid #dbdbda; height: 400px;">
							<div style="height: 8%; ">
								<table class="mainlist_free" cellspacing="0" cellpadding="0" width="100%" border="0">
									<thead>
										<tr>
											<th style="padding-left:10px;"><spring:message code='ezEmail.multiDomain.ksa13' /></th>
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
					</td>	
					<!-- 추가 삭제 화살표 아이콘 -->
					<td style="text-align: center;">
		                <img src="/images/kr/cm/arr_right.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="btn_Arrow('add')"><br>
		                <img src="/images/kr/cm/arr_left.gif" alt="" width="16" height="16" vspace="2" border="0" style="cursor: pointer;" onclick="btn_Arrow('del')">
					</td>
					<!-- 회사 도메인 -->
					<td>
						<div style="height: 100%; border:1px solid #dbdbda; height: 400px;">
							<div style="height: 8%; ">
								<table class="mainlist_free" cellspacing="0" cellpadding="0" width="100%" border="0">
									<thead>
										<tr>
											<th style="padding-left:10px;"><spring:message code='ezEmail.multiDomain.ksa14' /></th>
										</tr>
									</thead>
								</table>
							</div>
							<div style="height: 92%; overflow-y: auto;">
								<table class="mainlist" id="companyListTable" style="width:100%;">
									<tbody></tbody>
								</table>
							</div>
						</div>
					</td>		
				</tr>
			</table>
			
			<div class="btnpositionJsp">
			    <a href="#" class="imgbtn"><span onclick="btnPrimary()"><spring:message code='ezEmail.multiDomain.ksa07' /></span></a>
			    <a href="#" class="imgbtn"><span onclick="btnSave()"><spring:message code='ezEmail.multiDomain.ksa06' /></span></a>
		    </div>
		</div>
	</body>
	<script>
		var innerDomain;
		var companyInnerDomain;
		var oriPrimaryDomain;
		var saveParam = new Array();
		var companyId = "${companyId}";
		
		window.onload = function () {
			company_change();
	    }
		
		function company_change() {
			companyId = document.getElementById("ListCompany").value;
			
			get_domainList();
			get_Company_domainList();
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
						htmlList = "<tr class='noDataTR' style='text-align:center;cursor:default'><td><spring:message code='main.t00026' /></td></tr>";
					}
					
					$("#listTable tbody").html(htmlList);
				},
				error : function(e) {
					alert("<spring:message code='ezEmail.lhm14' />");
				}
			});
		}
		
		function get_Company_domainList() {
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/getCompanyMultiDomainList.do",
				data : {companyId:companyId},
				dataType : "json",
				success : function(data) {
					companyInnerDomain = data.innerDomain;
					oriPrimaryDomain = data.primaryDomain;
					var htmlSample = "<tr data-domain='{domainTxt}'><td>{domainTxt}</td></tr>";
					var htmlList = "";
					
					if (companyInnerDomain != "") {
						$.each(companyInnerDomain.split(";"), function(index, dd) {
							if (dd.trim() != "") {
								htmlList += htmlSample.replace(/{domainTxt}/gi, dd);							
							}
						});
					} else {
						htmlList = "<tr class='noDataTR' style='text-align:center;cursor:default'><td><spring:message code='main.t00026' /></td></tr>";
					}
					
					$("#companyListTable tbody").html(htmlList);
					setPrimary(oriPrimaryDomain);
				},
				error : function(e) {
					alert("<spring:message code='ezEmail.lhm14' />");
				}
			});
		}
	
		function save_company_domain() {
			var primaryDomain = saveParam[0];
			var saveDomainList = saveParam[1];
			
			$.ajax({
				type : "POST",
				url : "/admin/ezEmail/saveCompanyMultiDomain.do",
				data : {primaryDomain:primaryDomain, saveDomainList:saveDomainList, companyId:companyId},
				success : function(data) {
					if (data == 0) {
						alert("<spring:message code='ezEmail.multiDomain.ksa09' />");
						get_Company_domainList();
					} else {
						alert("<spring:message code='ezEmail.lhm14' />");
					}
				},
				error : function(e) {
					alert("<spring:message code='ezEmail.lhm14' />");
				}
			});
		}
		
		function addFunction(thisEle) {
			var selectTR = $(thisEle).clone(true);
			var thisDomainName = $(selectTR).attr("data-domain");
			var companyListTBODY = $("#companyListTable tbody");
			var companyListFind = companyListTBODY.find("tr[data-domain='" + thisDomainName + "']");
			
			if (!(companyListFind.length > 0)) {
				var printTR = $(selectTR).removeClass("trClick");
				companyListTBODY.find("tr[class='noDataTR']").remove();
				companyListTBODY.append(printTR);
				
				if (companyListTBODY.find("tr").size() == 1) {
					setPrimary(thisDomainName);
				}
			}
		}
		
		function delFunction(thisEle) {
			if ($(thisEle).attr("id") != "primary") {
				$(thisEle).remove();
				
				if ($("#companyListTable tbody").find("tr").length == 0) {
					var htmlList = "<tr class='noDataTR' style='text-align:center;cursor:default'><td><spring:message code='main.t00026' /></td></tr>";
					$("#companyListTable tbody").html(htmlList);
				}
			} else {
				alert("<spring:message code='ezEmail.multiDomain.ksa15' />");
			}
		}
		
		function btn_Arrow(type) {
			var listTable = type == "add" ? $("#listTable tr.trClick") : $("#companyListTable tr.trClick");
			
			if (listTable.length != 0) {
				if (type == "add") {
					addFunction(listTable[0]);
				} else if (type == "del") {
					delFunction(listTable[0]);
				}
			}
		}
		
		function setPrimary(setPrimaryDomain) {
			if (setPrimaryDomain == "") return;
			
			var selectTR = $("#companyListTable tr[data-domain='" + setPrimaryDomain + "']");
			
			if (selectTR.length > 0) {
				$("#companyListTable tbody").find("tr[id='primary'] b").remove();
				$("#companyListTable tbody").find("tr[id='primary']").removeAttr('id');
				
				selectTR.attr('id', 'primary');
				$(selectTR).find("td").append("<b>  (Primary)</b>");
			}
		}
		
		function btnPrimary() {
			var selectTR = $("#companyListTable tr.trClick");
			
			if (selectTR.length > 0) {
				setPrimary(selectTR.attr("data-domain"));
			} else {
				alert("<spring:message code='ezEmail.multiDomain.ksa16' />");
			}
		}
		
		function btnSave() {
			var primaryDomain = $("#companyListTable tr#primary").attr("data-domain");
			var saveDomainListObj = $("#companyListTable tr:not('.noDataTR')").get();
			var saveDomainArr = new Array();
			var saveDomainList = companyInnerDomain;
			
			if (saveDomainListObj.length > 0) {
				saveDomainListObj.forEach(function(e,i) {
					saveDomainArr.push(e.getAttribute('data-domain'));
				});
				
				saveDomainList = saveDomainArr.join(";");
				saveParam[0] = primaryDomain;
				saveParam[1] = saveDomainList;
				
				save_company_domain();
			} else {
				alert("<spring:message code='ezEmail.multiDomain.ksa11' />");
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
				var thisParent = $(this).parents("table")[0].id;

				$(this).removeClass("trHover");
				$(this).toggleClass("trClick");
				
				if (thisParent == "listTable") {
					$("#listTable tr.trClick").not($(this)).removeClass("trClick");
				} else if (thisParent == "companyListTable") {
					$("#companyListTable tr.trClick").not($(this)).removeClass("trClick");
				}
			},
			"dblclick" : function() {
				var thisContext = $(this).context;
				var thisParent = $(this).parents("table")[0].id;
				
				if (thisParent == "listTable") {
					addFunction(thisContext);
				} else if (thisParent == "companyListTable") {
					delFunction(thisContext);
				}
			}
		}, "#listTable tr:not(.noDataTR), #companyListTable tr:not(.noDataTR)");
	
	</script>
</html>



