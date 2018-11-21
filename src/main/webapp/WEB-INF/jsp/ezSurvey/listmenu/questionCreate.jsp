<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>

<div class="surveyCrtTt2">
	<!-- <div class="sryFirst2"></div> -->
	<div class="sryFirst2"></div>
	<span class="sryTxt"><c:out value="설문제목"></c:out> </span>
</div>

<div class="quesBacgr" style="height: 400px; /* box-shadow: rgba(0, 0, 0, 0.69) 0px 1px 5px 0px; */ border: 1px solid #d7d7d7;">
	<div class="quesDiv">
		<input class="questnTitle">
		<img alt="파일첨부" src="/images/ezSurvey/attach.png" class="atchImg">
		<input type="file" class="attachFile" multiple="multiple">
		
		<select class="quesTypeSelect"></select>
		<div class="optionBox">
			<div class="option_wrap">
				<ul class="select_op">
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">단일선택</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">다중선택</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">행렬(단일선택)</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">행렬(단일선택)</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">단답형</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">문장형</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">슬라이드</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">순위</a></li>
					<li><a href="#"><img alt="" src="/images/ezSurvey/radio.png">드롭다운</a></li>
				</ul>					
			</div>
		</div>
		
	</div>
</div>