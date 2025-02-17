<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<title>::: ezFlow Java :::</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />				
		<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width" />
		<link rel="stylesheet" type="text/css" href="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.css')}" />
    	<link rel="stylesheet" type="text/css" href="${util.addVer('/css/mobile/mobile.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery.mobile/jquery.mobile-1.4.5.min.js')}"></script>
			<script type="text/javascript" src="${util.addVer('/js/mobile/mOption.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mobile/mobile.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/jsbn.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rsa.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/prng4.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/rsa/rng.js')}"></script>	
		
		<script>
		 $(document).on("pagecreate",function(event){
			 $('#plus').closest('.ui-btn').hide();
			});
		
		 $( document ).ready(function() {
			 console.log('document ready!!');
			 searchOptionAjax();
			});
		</script>	
	</head>
	<body class="loginbody">
		<section id="sampleList" data-role="page">
			<!-- header import -->
     		<c:import url="/WEB-INF/jsp/mobile/ezOption/mOptionTop.jsp" />
     		<!-- header import -->
     		
     		<!-- body start -->
			<div class="content" data-role="content">
					<div class="ui-corner-all custom-corners">
					  <div class="ui-bar ui-bar-a">
					    <h3>언어 설정</h3>
					  </div>
					  <div class="ui-body ui-body-a">
					    <div data-role="fieldcontain">
						<p>언어 설정</p>
						<fieldset data-role="controlgroup" data-type="horizontal">
						<input type="radio" name="radio-view" id="radio-view-a" value ='1' />
						<label for="radio-view-a">한글</label>
						<input type="radio" name="radio-view" id="radio-view-b" value ='2' />
						<label for="radio-view-b">일어</label>
						<input type="radio" name="radio-view" id="radio-view-c" value ='3' />
						<label for="radio-view-c">영어</label>
						</fieldset>
						</div>
						<div>
						     <label class="select" for="select-choice-mini">타임존</label>
						          <select name="select-custom-1" id="select-custom-1" data-native-menu="false">
						            <option value="000|-12:00">(UTC-12:00) <spring:message code='ezPersonal.s5'/></option>
		          					<option value="001|-11:00">(UTC-11:00) <spring:message code='ezPersonal.s6'/></option>
		          					<option value="002|-10:00">(UTC-10:00) <spring:message code='ezPersonal.s7'/></option>
		          					<option value="003|-09:00">(UTC-09:00) <spring:message code='ezPersonal.s8'/></option>
		          					<option value="004|-08:00">(UTC-08:00) <spring:message code='ezPersonal.s9'/></option>
		          					<option value="015|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s12'/></option>
		          					<option value="013|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s11'/></option>
		          					<option value="010|-07:00">(UTC-07:00) <spring:message code='ezPersonal.s10'/></option>
		          					<option value="030|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s15'/></option>
		          					<option value="033|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s16'/></option>
		          					<option value="025|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s14'/></option>
		          					<option value="020|-06:00">(UTC-06:00) <spring:message code='ezPersonal.s13'/></option>
		          					<option value="040|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s18'/></option>
		          					<option value="035|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s17'/></option>
		          					<option value="045|-05:00">(UTC-05:00) <spring:message code='ezPersonal.s19'/></option>
		          					<option value="055|-04:30">(UTC-04:30) <spring:message code='ezPersonal.s21'/></option>
		          					<option value="050|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s20'/></option>
		          					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s22'/></option>
		          					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s905'/></option>
		          					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s906'/></option>
		          					<option value="056|-04:00">(UTC-04:00) <spring:message code='ezPersonal.s907'/></option>
		          					<option value="060|-03:30">(UTC-03:30) <spring:message code='ezPersonal.s23'/></option>
		          					<option value="070|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s25'/></option>
		          					<option value="056|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s908'/></option>
		          					<option value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s26'/></option>
		          					<option value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s909'/></option>
		          					<option value="073|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s910'/></option>
		          					<option value="065|-03:00">(UTC-03:00) <spring:message code='ezPersonal.s24'/></option>
		          					<option value="075|-02:00">(UTC-02:00) <spring:message code='ezPersonal.s27'/></option>
							        <option value="080|-01:00">(UTC-01:00) <spring:message code='ezPersonal.s28'/></option>
							        <option value="083|-01:00">(UTC-01:00) <spring:message code='ezPersonal.s29'/></option>
							        <option value="090|+00:00">(UTC) <spring:message code='ezPersonal.s31'/></option >
							        <option value="090|+00:00">(UTC) <spring:message code='ezPersonal.s911'/></option >
							        <option value="085|+00:00">(UTC) <spring:message code='ezPersonal.s30'/></option >
							        <option value="100|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s33'/></option >
							        <option value="105|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s34'/></option >
							        <option value="105|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s912'/></option >
							        <option value="110|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s35'/></option >
							        <option value="113|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s36'/></option >
							        <option value="095|+01:00">(UTC+01:00) <spring:message code='ezPersonal.s32'/></option >
							        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s913'/></option >
							        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s914'/></option >
							        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s915'/></option >
							        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s37'/></option >
							        <option value="140|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s42'/></option >
							        <option value="120|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s38'/></option >
							        <option value="125|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s39'/></option >
							        <option value="115|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s916'/></option >
							        <option value="130|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s40'/></option >
							        <option value="135|+02:00">(UTC+02:00) <spring:message code='ezPersonal.s41'/></option >
							        <option value="158|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s46'/></option >
							        <option value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s43'/></option >
							        <option value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s917'/></option >
							        <option value="145|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s918'/></option >
							        <option value="150|+03:00">(UTC+03:00) <spring:message code='ezPersonal.s44'/></option >
							        <option value="160|+03:30">(UTC+03:30) <spring:message code='ezPersonal.s47'/></option >
							        <option value="155|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s45'/></option >
							        <option value="170|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s49'/></option >
							        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s48'/></option >
							        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s919'/></option >
							        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s920'/></option >
							        <option value="165|+04:00">(UTC+04:00) <spring:message code='ezPersonal.s921'/></option >
							        <option value="175|+04:30">(UTC+04:30) <spring:message code='ezPersonal.s50'/></option >
							        <option value="180|+05:00">(UTC+05:00) <spring:message code='ezPersonal.s51'/></option >
							        <option value="185|+05:00">(UTC+05:00) <spring:message code='ezPersonal.s52'/></option >
							        <option value="190|+05:30">(UTC+05:30) <spring:message code='ezPersonal.s53'/></option >
							        <option value="190|+05:30">(UTC+05:30) <spring:message code='ezPersonal.s922'/></option >
							        <option value="193|+05:45">(UTC+05:45) <spring:message code='ezPersonal.s54'/></option >
							        <option value="195|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s55'/></option >
							        <option value="200|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s56'/></option >
							        <option value="201|+06:00">(UTC+06:00) <spring:message code='ezPersonal.s57'/></option >
							        <option value="203|+06:30">(UTC+06:30) <spring:message code='ezPersonal.s58'/></option >
							        <option value="207|+07:00">(UTC+07:00) <spring:message code='ezPersonal.s60'/></option >
							        <option value="205|+07:00">(UTC+07:00) <spring:message code='ezPersonal.s59'/></option >
							        <option value="210|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s61'/></option >
							        <option value="215|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s62'/></option >
							        <option value="225|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s64'/></option >
							        <option value="225|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s923'/></option >
							        <option value="227|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s65'/></option >
							        <option value="220|+08:00">(UTC+08:00) <spring:message code='ezPersonal.s63'/></option >
							        <option value="235|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s67'/></option >
							        <option value="230|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s66'/></option >
							        <option value="240|+09:00">(UTC+09:00) <spring:message code='ezPersonal.s68'/></option >
							        <option value="250|+09:30">(UTC+09:30) <spring:message code='ezPersonal.s70'/></option >
							        <option value="245|+09:30">(UTC+09:30) <spring:message code='ezPersonal.s69'/></option >
							        <option value="265|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s73'/></option >
							        <option value="255|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s71'/></option >
							        <option value="255|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s924'/></option >
							        <option value="260|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s72'/></option >
							        <option value="270|+10:00">(UTC+10:00) <spring:message code='ezPersonal.s74'/></option >
							        <option value="275|+11:00">(UTC+11:00) <spring:message code='ezPersonal.s75'/></option >
							        <option value="280|+11:00">(UTC+11:00) <spring:message code='ezPersonal.s76'/></option >
							        <option value="281|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s900'/></option >
							        <option value="285|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s77'/></option >
							        <option value="290|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s78'/></option >
							        <option value="290|+12:00">(UTC+12:00) <spring:message code='ezPersonal.s925'/></option >
							        <option value="300|+13:00">(UTC+13:00) <spring:message code='ezPersonal.s79'/></option >
							        <option value="300|+13:00">(UTC+13:00) <spring:message code='ezPersonal.s926'/></option >
						        </select>
						</div>
					  </div>
						
					<div class="ui-corner-all custom-corners" data-position="fixed" >
					  <div class="ui-bar ui-bar-a" >
						<div class="searchArea" id="searchArea">
							<h3>메인화면 게시물 표시</h3>
							<a href="#popupInfo" data-rel="popup" data-transition="pop" class=" ui-btn-right  ui-icon-info ui-shadow ui-corner-all ui-btn-icon-notext" title="Learn more">Learn more</a>														
						</div> 
							<div data-role="popup" id="popupInfo" class="ui-content" data-theme="a" style="max-width:350px;">
	  							<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>	
								<p>게시판의 갯수를 몇개 보여줄지 정함</p>
							</div>
					  </div>
					  <div class="ui-body ui-body-a" data-position="fixed">
		    				<input type="range" name="slider-2" id="slider-2" data-highlight="true" min="0" max="100" value="10" >
						</div>
					</div>
					 </div>
					<div class="ui-corner-all custom-corners">
					  <div class="ui-bar ui-bar-a">
						<div class="searchArea">
							<h3>메인화면직원검색 설정</h3>
							<a href="#popupInfo3" data-rel="popup" data-transition="pop" class=" ui-btn-right  ui-icon-info ui-shadow ui-corner-all ui-btn-icon-notext" title="Learn more">Learn more</a>														
						</div>    
					  </div>
					<div data-role="popup" id="popupInfo3" class="ui-content" data-theme="a" style="max-width:350px;">
	  							<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>	
								<p>메인화면에서 직원검색 기능의 사용여부 선택</p>
					</div>
					<div class="ui-body ui-body-a">
						<fieldset class="ui-grid-a"> 
							<div class="ui-block-a">
								<fieldset data-role="controlgroup" data-type="horizontal">
									<input type="radio" name="radio-view3" id="radio-view-a3" value="Y"  onclick="javascript:addPlus('1');"/>
									<label for="radio-view-a3">사용</label>
									<input type="radio" name="radio-view2" id="radio-view-b3" value="N" onclick="javascript:addPlus('2');" />
									<label for="radio-view-b3">안함</label>
								</fieldset>
							</div> 
						</fieldset>
					 </div>
					 </div> 
					<div class="ui-corner-all custom-corners">
					  <div class="ui-bar ui-bar-a">
						<div class="searchArea">
							<h3>전자결재보안모드 설정</h3>
							<a href="#popupInfo4" data-rel="popup" data-transition="pop" class=" ui-btn-right  ui-icon-info ui-shadow ui-corner-all ui-btn-icon-notext" title="Learn more">Learn more</a>														
						</div>    
					  </div>
					<div data-role="popup" id="popupInfo4" class="ui-content" data-theme="a" style="max-width:350px;">
	  							<a href="#" data-rel="back" class="ui-btn ui-corner-all ui-shadow ui-btn-a ui-icon-delete ui-btn-icon-notext ui-btn-right">Close</a>	
								<p>전자결재시 보안기능의 사용여부 선택</p>
					</div>
					<div class="ui-body ui-body-a">
						<fieldset class="ui-grid-a"> 
							<div class="ui-block-a">
								<fieldset data-role="controlgroup" data-type="horizontal">
									<input type="radio" name="radio-view4" id="radio-view-a4" value="Y"  onclick="javascript:addPlus('1');"/>
									<label for="radio-view-a4">사용</label>
									<input type="radio" name="radio-view2" id="radio-view-b4" value="N" onclick="javascript:addPlus('2');" />
									<label for="radio-view-b4">안함</label>
								</fieldset>
							</div> 
						</fieldset>
					 </div>
					 </div>  
					<div>
					<p align="center">
					<button class="show-page-loading-msg" data-textonly="false" data-textvisible="true" data-inline="true" onclick="javascript:saveOptionButton()">적용하기</button>
					</p>
					</div>
     		</div>    		
	<!-- body end -->

     		<!-- footer import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/sampleFooter.jsp" />
     		<!-- footer import -->
     		
     		<!-- layer Popup import -->
     		<c:import url="/WEB-INF/jsp/mobile/sample/samplePopup.jsp" />
     		<!-- layer Popup import -->
     		
     		<div id="test" class="ui-content" style="min-width: 255px; max-width: 285px; text-align:center" data-role="popup" data-overlay-theme="b" data-transition="slidedown">
		    <a href="#" data-rel="back" data-role="button" data-theme="b" data-icon="delete" data-iconpos="notext" class="ui-btn-right">Close</a>
		    <div>		    	
				<input name="search-1" id="search-1" type="search" placeholder="search mail..">
				<a class="ui-btn" href="#">검 색</a>
			</div>			
		</div>
     	</section>
	</body>	
</html>