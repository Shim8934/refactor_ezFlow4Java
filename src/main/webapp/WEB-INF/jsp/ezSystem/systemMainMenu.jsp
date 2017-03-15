<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" href="/css/default_kr.css;" type="text/css">
<script type="text/javascript" src="/js/jquery/jquery.js"></script>
<script type="text/javascript">
	
	var list = [];
	var confirmChange = "";
	
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
				after_check_change_Param(result);
			},
			error : function(error) {
				alert("<spring:message code='main.kms2'/>" + error);
			}
		});

	}
	
	function after_check_change_Param(result) {
		$("table").children().remove();
		$("table").append('<tr><th><spring:message code="main.kms1"/>'+
				'</th><th><spring:message code="main.kms3"/></th></tr>');
		list = result;
		for (var i = 0; i < list.length; i++) {
			if(list[i].name=="USE_AdditionalROle"){
				list[i].name="USE_AdditionalRole";
			}
			if(list[i].value != "YES" && list[i].value != "NO" ){
				if(list[i].name != "PrimaryLang"){
					$("table").append('<tr id=tr_'+i+'><th>'+list[i].name+'</th>'
					+'<td><input type="text" value='+list[i].value+'></td></tr>');
				}else{
					if(list[i].value==3){
						$("table").append('<tr id=tr_'+i+'><th>'+list[i].name+'</th>'
						+'<td><select><option value="1">한국어</option><option value="3" selected="selected">일본어</option>'
						+'</select></td></tr>');
					}else{
						$("table").append('<tr id=tr_'+i+'><th>'+list[i].name+'</th>'
						+'<td><select><option value="1" selected="selected"><spring:message code="ezPersonal.s81"/></option>'
						+'<option value="3"><spring:message code="ezPersonal.s84"/></option>'
						+'</select></td></tr>');
					}
				}
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
		$("table").append('<tr><td colspan="2" style="text-align: center; padding-top:5px;">'
		+'<div class="imgbtn" style="padding-right: 3px;"><span onclick="check_change_Param()">'
		+'<spring:message code='main.sp09'/></span></div>'
		+'<div class="imgbtn"><span onclick=$("form")[0].reset()><spring:message code='main.sp11'/>'
		+'</span></div></td></tr>');
	}
	
	function check_change_Param() {

		var flag=false;
		confirmChange = "";
		
		for (var i = 0; i < list.length; i++) {
			if($("#tr_"+i+" input").val()==undefined){
			var value = $("#tr_"+i+" select").val();
			}else{
			value = $("#tr_"+i+" input").val();
			}
			if(value!=list[i].value){
				if(list[i].name != "PrimaryLang"){
			 		flag=true;
			 		confirmChange += $("#tr_"+i+" th").text()+ " : " + list[i].value+ " -> " +value +"\n";
				}else{
					flag=true;
					var oldLang = "";
					var newLang = "";
 					if(value==1){
 						newLang = "<spring:message code="ezPersonal.s81"/>";
 					}else if(value==3){
 						newLang = "<spring:message code="ezPersonal.s84"/>";
 					}
 					if(list[i].value==1){
 						oldLang = "<spring:message code="ezPersonal.s81"/>";
 					}else if(value==3){
 						oldLang = "<spring:message code="ezPersonal.s84"/>";
 					}
					confirmChange += $("#tr_"+i+" th").text()+ " : " + oldLang+ " -> " +newLang +"\n";
				}
			}
		}
		if(flag){
			if(confirm(confirmChange)){
			update_Sys_Param();
			}
		}
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
				if(list[i].name == "PrimaryLang"){
					change_PrimaryLang(paramArray,value);
				}
			}
		}
		
		var jsonStr = JSON.stringify(paramArray);

		$.ajax({
			type : "POST",
			url : "/admin/Ezsystem/updateSysParam.do",
			processData : true /*querySTring make false*/, 
			contentType : "application/json; charset=UTF-8", 
			data :jsonStr,
			success : function(data){
				if(data.msg=='success'){
					alert("<spring:message code='main.sp10'/>");
				}
				if(data.msg=='fail'){
					alert("<spring:message code='main.sp12'/>");
				}
			},
			complete : function(){
				get_Sys_Param();
			},
			error : function(e) {
				alert(e);
			}
		});	
	}
	
	function change_PrimaryLang(paramArray,value) {
		if(value == 1){
			
			var paramInfo1 = new Object();
			
			paramInfo1.name = "LangPrimary1";
			paramInfo1.value = "한글";
		
			paramArray.push(paramInfo1);
			
			var paramInfo2 = new Object();
			
			paramInfo2.name = "LangPrimary2";
			paramInfo2.value = "Korean";
		
			paramArray.push(paramInfo2);
			
			var paramInfo3 = new Object();
			
			paramInfo3.name = "LangPrimary3";
			paramInfo3.value = "韓国語";
		
			paramArray.push(paramInfo3);
			
			var paramInfo4 = new Object();
			
			paramInfo4.name = "LangPrimary4";
			paramInfo4.value = "韩国语";
		
			paramArray.push(paramInfo4);
			
		}else if(value == 3){
			
			var paramInfo1 = new Object();
			
			paramInfo1.name = "LangPrimary1";
			paramInfo1.value = "일본어";
		
			paramArray.push(paramInfo1);
			
			var paramInfo2 = new Object();
			
			paramInfo2.name = "LangPrimary2";
			paramInfo2.value = "Japanese";
		
			paramArray.push(paramInfo2);
			
			var paramInfo3 = new Object();
			
			paramInfo3.name = "LangPrimary3";
			paramInfo3.value = "日本語";
		
			paramArray.push(paramInfo3);
			
			var paramInfo4 = new Object();
			
			paramInfo4.name = "LangPrimary4";
			paramInfo4.value = "日本語";
		
			paramArray.push(paramInfo4);
		}
		
	}
</script>
<title><spring:message code='main.kms1'/></title>
</head>
<body class=mainbody>
<h1><spring:message code='main.kms1'/></h1>
	<form>
	<table>
	</table>
	</form>
</body>
</html>