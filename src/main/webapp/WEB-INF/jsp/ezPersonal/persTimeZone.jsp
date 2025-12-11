<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title>TimeZone</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/style.css')}" type="text/css">
		<style>
			.country1{content:url(/images/lang/icon_flag_kr.gif); cursor:pointer; vertical-align: middle;}
			.country2{content:url(/images/lang/icon_flag_us.gif); cursor:pointer; vertical-align: middle;}
			.country3{content:url(/images/lang/icon_flag_jp.gif); cursor:pointer; vertical-align: middle;}
			.country4{content:url(/images/lang/icon_flag_cn.gif); cursor:pointer; vertical-align: middle;}
			.country5{content:url(/images/lang/icon_flag_vi.gif); cursor:pointer; vertical-align: middle;}
			.country6{content:url(/images/lang/icon_flag_id.gif); cursor:pointer; vertical-align: middle;}
		</style>

		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery-1.9.1.js')}"></script>
	    <script type="text/javascript">
	    var TimeZone = "${strTimeZone}";
        var usePrimaryLangOnly = "${usePrimaryLangOnly}";
        var primaryLang = "${primaryLang}";
        var flagValue = "${strLang}";

		var useJapanese = "${useJapanese}"
		var useChinese = "${useChinese}"
		var useVietnamese = "${useVietnamese}"
		var useIndonesian = "${useIndonesian}"
		
		window.onload = window_onload;
		function window_onload() {
			if (TimeZone != "") {
			    document.getElementById("TimeZone").value = TimeZone;
			}

			language_form();

			if ('YES' == usePrimaryLangOnly.toUpperCase()) {
				flagValue = primaryLang;

				$('.languageTd *').css('display', 'none'); // js : .style.display | jQuery : css()
				//$("#" + flagValue + ", .languageTd img[name=" + flagValue + "]").css('display', '');
				$('#' + flagValue +  ',.languageTd label[for="' + flagValue + '"], .languageTd img[name="' + flagValue + '"]').css('display', '');
				$("input:radio[id=" + flagValue + "]").prop('checked', true);
			} else {
				$("input:radio[id=" + flagValue + "]").prop('checked', true);
			}
			$("#" + flagValue).checked = true;
		}
		
		function language_form(){
			var languageTd = document.getElementById("languageTd");

			var html = "<div class='custom_radio'>";

			html += "<input type='radio' id='" + primaryLang + "' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
			html += "<label for='" + primaryLang + "'><img name='"+ primaryLang + "' class='country" + primaryLang + "' onclick='flag_onClick(this, \"img\");' /></label>";
			
			if (primaryLang != 2) {
				html += "<input type='radio' id='2' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
				html += "<label for='2'><img name='2' class='country2' onclick='flag_onClick(this, \"img\");' /></label>";
			}
			if (primaryLang != 1) {
				html += "<input type='radio' id='1' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
				html += "<label for='1'><img name='1' class='country1' onclick='flag_onClick(this, \"img\");' /></label>";
			}
			if (primaryLang != 3 && useJapanese === 'YES') {
				html += "<input type='radio' id='3' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
				html += "<label for='3'><img name='3' class='country3' onclick='flag_onClick(this, \"img\");' /></label>";
			}
			if (primaryLang != 4 && useChinese === 'YES') {
				html += "<input type='radio' id='4' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
				html += "<label for='4'><img name='4' class='country4' onclick='flag_onClick(this, \"img\");' /></label>";
			}
			if (primaryLang != 5 && useVietnamese === 'YES') {
				html += "<input type='radio' id='5' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
				html += "<label for='5'><img name='5' class='country5' onclick='flag_onClick(this, \"img\");' /></label>";
			}
			if (primaryLang != 6 && useIndonesian === 'YES') {
				html += "<input type='radio' id='6' name='rad_flag' onclick='flag_onClick(this, \"rad\");' />";
				html += "<label for='6'><img name='6' class='country6' onclick='flag_onClick(this, \"img\");' /></label>";
			}
			
			html += "</div>";
			
			languageTd.innerHTML += html;
			
			document.getElementsByClassName("country1")[0] && document.getElementsByClassName("country1")[0].setAttribute("title", "<spring:message code='ezPersonal.s81'/>");
			document.getElementsByClassName("country2")[0] && document.getElementsByClassName("country2")[0].setAttribute("title", "<spring:message code='ezPersonal.s82'/>");
			document.getElementsByClassName("country3")[0] && document.getElementsByClassName("country3")[0].setAttribute("title", "<spring:message code='ezPersonal.s84'/>");
			document.getElementsByClassName("country4")[0] && document.getElementsByClassName("country4")[0].setAttribute("title", "<spring:message code='ezPersonal.s85'/>");
			document.getElementsByClassName("country5")[0] && document.getElementsByClassName("country5")[0].setAttribute("title", "<spring:message code='ezPersonal.s86'/>");
			document.getElementsByClassName("country6")[0] && document.getElementsByClassName("country6")[0].setAttribute("title", "<spring:message code='ezPersonal.s87'/>");
			
		}

		function save_onclick() {
			$.ajax({
				type: "POST",
				dataType: "html",
				url: "/ezPersonal/saveUserTimeZone.do",
				async: false,
				data: {
					timeZone: document.getElementById("TimeZone").value,
	    			lang : flagValue
	    		},
	    		success : function(result) {   			
	    			 if (result == "OK") {
	    				 updateWeatherUser(flagValue); //언어 변경에 따른 사용자별 날씨 포틀릿 변경
	    				 
	    				 alert("<spring:message code='ezPersonal.t191'/>");
	    				 window.parent.parent.location = window.parent.parent.location.href;
	    			} 
				},
	    		error : function() {
	    			alert("<spring:message code='ezPersonal.s1'/>");
	    			
	    		}
	    	});
			
		}            
        function flag_onClick(obj, type) {
            if (type == "img") {
            	$("input:radio[id=" + obj.name + "]").prop('checked', true);
                flagValue = obj.name;
            }
            else {
                for (var radFlag of document.getElementsByName('rad_flag')) {
                    if (radFlag.checked) {
                        flagValue = radFlag.id;
                        break;
                    }
                }
            }
        }
        
        function updateWeatherUser(countryCode) {
        	$.ajax({
	    		type : "GET",
	    		url : "/ezNewPortal/weatherPortletChange.do",
	    		async : false,
	    		data : {
	    			cityCode : "none",
	    			countryCode : countryCode
	    		}
	    	});
        }

		</script> 
	</head>
	<body class="mainbody" onload="javascript:window_onload()">
		<form id="Form1" method="post">
  			<h1><spring:message code='ezPersonal.s3'/></h1>
  			<table class="popuplist">
				<tr>
      				<th><spring:message code='ezPersonal.s83'/></th>
      				<td class="languageTd" id="languageTd" style="height:40px;"> </td>
    			</tr>
    			<tr>
      				<th><spring:message code='ezPersonal.s4'/></th>
      				<td>
      					<SELECT NAME="TimeZone" id="TimeZone" style="height:23px;">
          					<OPTION value="000|-12:00">(UTC-12:00) <spring:message code='ezPersonal.s5'/></OPTION>
          					<OPTION value="001|-11:00">(UTC-11:00) <spring:message code='ezPersonal.s6'/></OPTION>
          					<OPTION value="002|-10:00">(UTC-10:00) <spring:message code='ezPersonal.s7'/></OPTION>
          					<OPTION value="003|-09:00">(UTC-09:00) <spring:message code='ezPersonal.s8'/></OPTION>
          					<OPTION value="004|-08:00">(UTC-08:00) <spring:message code='ezPersonal.s9'/></OPTION>
          					<OPTION value="015|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s12'/></OPTION>
          					<OPTION value="013|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s11'/></OPTION>
          					<OPTION value="010|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s10'/></OPTION>
          					<OPTION value="030|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s15'/></OPTION>
          					<OPTION value="033|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s16'/></OPTION>
          					<OPTION value="025|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s14'/></OPTION>
          					<OPTION value="020|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s13'/></OPTION>
          					<OPTION value="040|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s18'/></OPTION>
          					<OPTION value="035|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s17'/></OPTION>
          					<OPTION value="045|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s19'/></OPTION>
          					<OPTION value="055|-04:30">(UTC-04:30) <spring:message code='ezPersonal.s21'/></OPTION>
          					<OPTION value="050|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s20'/></OPTION>
          					<OPTION value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s22'/></OPTION>
          					<OPTION value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s905'/></OPTION>
          					<OPTION value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s906'/></OPTION>
          					<OPTION value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s907'/></OPTION>
          					<OPTION value="060|-03:30">(UTC-03:30) <spring:message code='ezPersonal.s23'/></OPTION>
          					<OPTION value="070|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s25'/></OPTION>
          					<OPTION value="056|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s908'/></OPTION>
          					<OPTION value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s26'/></OPTION>
          					<OPTION value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s909'/></OPTION>
          					<OPTION value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s910'/></OPTION>
          					<OPTION value="065|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s24'/></OPTION>
          					<OPTION value="075|-02:00">(UTC-02:00) <spring:message code='ezPersonal.s27'/></OPTION>
					        <OPTION value="080|-01:00">(UTC-01:00) <spring:message code='ezPersonal.s28'/></OPTION>
					        <OPTION value="083|-01:00">(UTC-01:00) <spring:message code='ezPersonal.s29'/></OPTION>
					        <OPTION value="090|+00:00">(UTC) <spring:message code='ezPersonal.s31'/></OPTION>
					        <OPTION value="090|+00:00">(UTC) <spring:message code='ezPersonal.s911'/></OPTION>
					        <OPTION value="085|+00:00">(UTC) <spring:message code='ezPersonal.s30'/></OPTION>
					        <OPTION value="100|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s33'/></OPTION>
					        <OPTION value="105|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s34'/></OPTION>
					        <OPTION value="105|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s912'/></OPTION>
					        <OPTION value="110|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s35'/></OPTION>
					        <OPTION value="113|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s36'/></OPTION>
					        <OPTION value="095|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s32'/></OPTION>
					        <OPTION value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s913'/></OPTION>
					        <OPTION value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s914'/></OPTION>
					        <OPTION value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s915'/></OPTION>
					        <OPTION value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s37'/></OPTION>
					        <OPTION value="140|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s42'/></OPTION>
					        <OPTION value="120|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s38'/></OPTION>
					        <OPTION value="125|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s39'/></OPTION>
					        <OPTION value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s916'/></OPTION>
					        <OPTION value="130|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s40'/></OPTION>
					        <OPTION value="135|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s41'/></OPTION>
					        <OPTION value="158|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s46'/></OPTION>
					        <OPTION value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s43'/></OPTION>
					        <OPTION value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s917'/></OPTION>
					        <OPTION value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s918'/></OPTION>
					        <OPTION value="150|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s44'/></OPTION>
					        <OPTION value="160|+03:30">(UTC+03:30) <spring:message code='ezPersonal.s47'/></OPTION>
					        <OPTION value="155|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s45'/></OPTION>
					        <OPTION value="170|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s49'/></OPTION>
					        <OPTION value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s48'/></OPTION>
					        <OPTION value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s919'/></OPTION>
					        <OPTION value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s920'/></OPTION>
					        <OPTION value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s921'/></OPTION>
					        <OPTION value="175|+04:30">(UTC+04:30) <spring:message code='ezPersonal.s50'/></OPTION>
					        <OPTION value="180|+05:00">(UTC+05:00) <spring:message code='ezPersonal.s51'/></OPTION>
					        <OPTION value="185|+05:00">(UTC+05:00) <spring:message code='ezPersonal.s52'/></OPTION>
					        <OPTION value="190|+05:30">(UTC+05:30) <spring:message code='ezPersonal.s53'/></OPTION>
					        <OPTION value="190|+05:30">(UTC+05:30) <spring:message code='ezPersonal.s922'/></OPTION>
					        <OPTION value="193|+05:45">(UTC+05:45) <spring:message code='ezPersonal.s54'/></OPTION>
					        <OPTION value="195|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s55'/></OPTION>
					        <OPTION value="200|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s56'/></OPTION>
					        <OPTION value="201|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s57'/></OPTION>
					        <OPTION value="203|+06:30">(UTC+06:30) <spring:message code='ezPersonal.s58'/></OPTION>
					        <OPTION value="207|+07:00">(UTC+07:00) <spring:message code='ezPersonal.s60'/></OPTION>
					        <OPTION value="205|+07:00">(UTC+07:00) <spring:message code='ezPersonal.s59'/></OPTION>
					        <OPTION value="210|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s61'/></OPTION>
					        <OPTION value="215|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s62'/></OPTION>
					        <OPTION value="225|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s64'/></OPTION>
					        <OPTION value="225|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s923'/></OPTION>
					        <OPTION value="227|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s65'/></OPTION>
					        <OPTION value="220|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s63'/></OPTION>
					        <OPTION value="235|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s67'/></OPTION>
					        <OPTION value="230|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s66'/></OPTION>
					        <OPTION value="240|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s68'/></OPTION>
					        <OPTION value="250|+09:30">(UTC+09:30) <spring:message code='ezPersonal.s70'/></OPTION>
					        <OPTION value="245|+09:30">(UTC+10:30) <spring:message code='ezPersonal.s69'/></OPTION>
					        <OPTION value="265|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s73'/></OPTION>
					        <OPTION value="255|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s71'/></OPTION>
					        <OPTION value="255|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s924'/></OPTION>
					        <OPTION value="260|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s72'/></OPTION>
					        <OPTION value="270|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s74'/></OPTION>
					        <OPTION value="275|+11:00">(UTC+11:00) <spring:message code='ezPersonal.s75'/></OPTION>
					        <OPTION value="280|+11:00">(UTC+11:00) <spring:message code='ezPersonal.s76'/></OPTION>
					        <OPTION value="281|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s900'/></OPTION>
					        <OPTION value="285|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s77'/></OPTION>
					        <OPTION value="290|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s78'/></OPTION>
					        <OPTION value="290|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s925'/></OPTION>
					        <OPTION value="300|+13:00">(UTC+13:00) <spring:message code='ezPersonal.s79'/></OPTION>
					        <OPTION value="300|+13:00">(UTC+13:00) <spring:message code='ezPersonal.s926'/></OPTION>
        				</SELECT>
					</td>
    			</tr>
    			<tr>
    				<td colspan="2" style="text-align: center;border:0px">
    					<div class="btnpositionJsp">
    						<a class="imgbtn" onclick="save_onclick()"><span id="ButtonChangePassword"><spring:message code='ezPersonal.t34'/></span></a>
    					</div>	
    				</td>
    			</tr>
  			</table>
		</form>
	</body>
</html>
