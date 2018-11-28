<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>

<div class="surveyCrtTt2">
	<!-- <div class="sryFirst2"></div> -->
	<div class="sryFirst2"></div>
	<span class="sryTxt"><c:out value="설문제목"></c:out> </span>
</div>

<div class="quesBacgr" style="height: 400px; border: 1px solid #d7d7d7;">
	<div>
	
	<!-- 질문 생성 -->
	<!-- 
	<div class="quesDiv">
	
		<input class="questnTitle">
		<img alt="파일첨부" src="/images/ezSurvey/attach.png" class="atchImg">
		
		<select class='selectBox'></select>
		<div class='optionBox'>
			<div class='option_wrap'>
				<ul class='select_op'>
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
		
		
		<div>
			<input type="file" class="questionFile" multiple="multiple">
			<div class="qstnFileInfo">
				<div>
					<ul></ul>
				</div>
			</div>
		</div>
		
	</div>
	
	
	<div class="oneSelection" style="width:100%; height:50%; padding-top: 15px;">
	
		<div class="optPart" style="text-align: center;">
		
			<div class="optRow" style="width: 60%; padding-left: 20%;">
				<div class="option">
					<input class="textInput" type="text" style="width: 85%;height: 30px;"> 
					<img src="/images/ezSurvey/attach.png" class="attImg" style="width: 30px; height: 30px; cursor: pointer; padding-left: 20px; padding-right: 10px; margin-bottom: -11px;"> 
					<input class="fileInput" type="file" multiple="multiple" style="width: 0px; opacity: 0;"> 
					<img src="/images/ezSurvey/minus.jpg" class="delImg" style="width: 30px; height: 30px; cursor: pointer; margin-bottom: -11px;">
				</div>
				
				<div class="fileInfo">
				<div class="optFileInfo">
					<div>
						<ul>파일 정보</ul>
					</div>
				</div>
			</div>
			
			<div class="optAtt">
				<input  type='file' class='optionFile' style='display: none;' />
			</div>
		</div>
		
		<div class="additionalPart" style="width: 60%; margin-left: 20%; margin-top: 10px;">
		
			<div class="addBtns" style="text-align: left;">
				<button class="addRow">추가</button>
				<button class="addOther">기타추가</button>
			</div>
			
			<div class="required" style="text-align: left; font-size: 13px;">
				<input type="checkbox">
				<strong>필수 답변</strong>
			</div>
			
			<div class="btns" style="text-align: right;">
				<button class="save">저장</button>
				<button class="cancel">취소</button>
			</div>
			
		</div>
		
	</div>
	  -->
	  
	  <!-- 만들어진 질문 -->
	  <!-- 
	  <div class='tempQstnWrapper'>
	  	
	  	<div class='mvBtnDiv'>
	  		<img class='mvBtn' alt="" src='/images/ezSurvey/move.png'>
	  	</div>
	  	
	  	<div class='fiCoDelBtns' style='float: right;'>
	  		<img alt='' src='/images/ezSurvey/correct.png' class='crtBtn'>
	  		<img alt='' src='/images/ezSurvey/copy.png' class='cpBtn'>
	  		<img alt='' src='/images/ezSurvey/trash.png' class='dltBtn'>
	  	</div>
	  	
	  	<strong class='qstnCtts'>질문 영역</strong>
	  	
	  	<div class='opts'>
	  		<div class='opt'>
		  		<input class='optRdo' type='radio' value='1'/>
		  		<span class='optSpan'>보기1</span>
	  			<img alt='' src='/images/ezSurvey/minus.jpg' class='optImg'>
	  		</div>
	  		<div class='opt'>
		  		<input class='optRdo' type='radio' value='1'/>
		  		<span class='optSpan'>기타</span>
	  			<img alt='' src='/images/ezSurvey/minus.jpg' class='optImg'>
		  		<input class='othInput' type='text'/>
	  		</div>
	  	</div>
	  	
	  </div>
	   -->
	  </div>
	 <script type="text/javascript" src="${util.addVer('/js/ezSurvey/questionFile.js')}"></script>
</div>