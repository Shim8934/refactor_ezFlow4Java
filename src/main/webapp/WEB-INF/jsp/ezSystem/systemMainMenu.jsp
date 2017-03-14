<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/default_kr.css&#9;" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript">
	var list = [];
	window.onload = function() {
		get_Sys_Param();
	};

	function get_Sys_Param() {
		$.ajax({
			type : "POST",
			url : "/admin/Ezsystem/getSysParam.do",
			data : {

			},
			async: false,
			success : function(result) {
				$("table").append('<tr><th><spring:message code="main.kms3"/>'+
						'</th><th><spring:message code="main.kms4"/></th></tr>');
				list = result;
				for (var i = 0; i < list.length; i++) {
					if(list[i].name=="USE_AdditionalROle"){
						list[i].name="USE_AdditionalRole";
					}
					if(list[i].value != "YES" && list[i].value != "NO" ){
						$("table").append('<tr id=tr_'+i+'><th>'+list[i].name+'</th>'
						+'<td><input type="text" value='+list[i].value+'></td></tr>');
					}else if(list[i].value == "NO"){
						$("table").append('<tr id=tr_'+i+'><th>'+list[i].name+'</th>'
						+'<td><select><option value="YES">YES</option><option value="NO" selected="selected">NO</option>'
						+'</select></td></tr>');
					}else{
						$("table").append('<tr id=tr_'+i+'><th>'+list[i].name+'</th>'
						+'<td><select><option value="YES" selected="selected">YES</option><option value="NO">NO</option>'
						+'</select></td></tr>');
					}
				}
			},
			error : function(error) {
				alert("<spring:message code='main.kms2'/>" + error);
			}
		});

	}
	
	function update_Sys_Param() {
		var paramArray = new Array();
		
		for (var i = 0; i < list.length; i++) {
			if($("#tr_"+i+" input").val()==undefined){
				var value = $("#tr_"+i+" select").val();
			}else{
				value = $("#tr_"+i+" input").val();
			}
			if(value!=list[i].value){
				var paramInfo = new Object();
			
				paramInfo.name = $("#tr_"+i+" th").text();
				paramInfo.value = value;
			
				paramArray.push(paramInfo);
			}
		}
		
		var jsonStr = JSON.stringify(paramArray);

		$.ajax({
			type : "POST",
			url : "/admin/Ezsystem/updateSysParam.do",
			processData : true /*querySTring make false*/, 
			contentType : "application/json; charset=UTF-8", 
			data :jsonStr,
			success : function(result){
				alert(result);
			},
			complete : function(){
				$("table").children().remove();
				get_Sys_Param();
			},
			error : function(xhr, status, error) {
				alert(error);
			}
		});	
	}
</script>
<title><spring:message code='main.kms1'/></title>
</head>
<body class=mainbody>
<h1><spring:message code='main.kms1'/></h1>
	<form>
	<table>
	</table>
	<span style="text-align: center;">
	<input type="button" value="<spring:message code='main.sp09'/>" onclick="update_Sys_Param()">
	<input type="reset" value="<spring:message code='main.sp11'/>">
	</span>
	</form>
</body>
</html>