<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core"  %>

<div class="surveyCrtTt2">
	<!-- <div class="sryFirst2"></div> -->
	<div class="sryFirst2"></div>
	<span class="sryTxt"><c:out value="설문제목"></c:out> </span>
</div>

<div class="quesBacgr" style="height: 400px; border: 1px solid #d7d7d7;">
	<!-- 
	<div class="quesDiv">
		<input class="questnTitle">
		<img alt="파일첨부" src="/images/ezSurvey/attach.png" class="atchImg">
		<input type="file" class="attachFile" multiple="multiple">
		
		<select class="selectBox"></select>
		
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
	
	
	<div class="oneSelection" style="width:100%; height:50%;">
	
		<div class="optionPart" style="text-align: center;">
			<div class="option">
				<input class="textInput" type="text" style="width: 50%; height: 30px;"> 
				<img src="/images/ezSurvey/attach.png" style="width: 30px; height: 30px;"> 
				<input class="fileInput" type="file" multiple="multiple" style="width: 0px; opacity: 0"> 
				<button><img src="/images/ezSurvey/minus.jpg" style="width: 30px; height: 30px; "></button>
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
	<script type="text/javascript">
	
	var xhr 			  = new XMLHttpRequest();
	var optImgPrevArr 	  = [];
	var tempObj			  = "";
	
	
	// 셀렉트 박스에 들어갈 질문 유형 데이터 
	var optionData = 
		[ { text : "--질문 유형 선택--",	value: 0, selected: true, 	description:"--질문 유형 선택--"},
	      { text : "단일선택", 		value: 1, selected: false, 	description:"단일선택", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "다중선택", 		value: 2, selected: false, 	description:"다중선택", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "행렬(단일선택)", 	value: 3, selected: false, 	description:"행렬(단일선택)", 	imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "행렬(다중선택)",	value: 4, selected: false, 	description:"행렬(다중선택)", 	imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "단답형", 			value: 5, selected: false, 	description:"단답형", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "문장형", 			value: 6, selected: false, 	description:"문장형", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "슬라이드", 		value: 7, selected: false, 	description:"슬라이드", 		imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "순위", 			value: 8, selected: false, 	description:"순위", 			imageSrc: "/images/ezSurvey/radio.png" },
	      { text : "드롭다운", 		value: 9, selected: false, 	description:"드롭다운", 		imageSrc: "/images/ezSurvey/radio.png" },];
	
	// 질문 유형을 선택하는 셀렉트 박스 생성
	function createQuestionSelectBox() {
		
		$("#selectBox").ddslick({
			data :optionData,
			imagePosition: "left",
			selectText: "질문 유형 선택",
			onSelected: function(data) {

				var selectedEl = data.selectedItem;
				var grandParent = selectedEl.parent().parent().parent().parent();

				var questionType = data.selectedIndex;
				
				switch (questionType) {
					case 1:
						makeSelectQuestion(grandParent, questionType);
						break;
					case 2:
						
						break;
					case 3:
						
						break;
					case 4:
						
						break;
					case 5:
						
						break;
					case 6:
						
						break;
					case 7:
						
						break;
					case 8:
						
						break;
					case 9:
						
						break;
					
				}
			}
		});
	}
	
	// 질문 및 질문 유형 선택하는 부분 생성
	function createQuesDiv() {
		
		var html = "";
		
		html += "<div class='quesDiv'>";
		html += "<input class='questnTitle'>";
		html += "<img alt='파일첨부' src='/images/ezSurvey/attach.png' class='atchImg'>";
		html += "<input type='file' class='attachFile' multiple='multiple' >";
		html += "<div id='selectBox'></div>";
		html += "</div>";
		
		$(".quesBacgr").html(html);
		
		createQuestionSelectBox();
	}
	// 생성된 질문을 붙일 부분과 
	// 질문 유형을 파라미터로 받아 질문 영역 생성
	function makeSelectQuestion(grandParent, questionType) {
		
		var html = "";
		
			html += "<div class='selection' questionType='" + questionType + "'>";
		
			html += "<div class='optionPart'>";
			html += "<div class='option'>";
			html += "<input class='textInput' type='text'>";
			html += "<img src='/images/ezSurvey/attach.png' class='attachImg' onclick='optTrigger();'>";
			html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent(this);'>";
			html += "</div>";
			html += "<div>"
			html += "<input type='file' id='optionAttach' class='optionAttach' multiple='multiple' style='display: none;' onchange='optionFileUpload();'>"
			html += "</div>";
			html += "<div>"
			html += "<input type='text' id='imgName'>"
			html += "</div>";
			html += "</div>";
		
			html += "<div class='additionalPart'>";
		
			html += "<div class='addBtns'>";
			html += "<button class='addRow'>추가</button>";
			html += "<button class='addOther'>기타추가</button>";
			html += "</div>";
			
			html += "<div class='required'>";
			html += "<input type='checkbox' name='checkbox'>";
			html += "<strong>필수 답변</strong>";
			html += "</div>";
			
			html += "<div class='btns'>";
			html += "<button class='save'>저장</button>";
			html += "<button class='cancel'>취소</button>";
			html += "</div>";
			
			html += "</div>";
		
			html += "</div>";
			
		grandParent.append(html);
		
		addEvent();
	}
	
	function addEvent() {
		
		// 추가 버튼 클릭시 옵션 추가 이벤트
		$(".addRow").click(function(event) {
			
			var element = $(this).parent().parent().parent();
			
			var html = "";
			html += "<div class='option'>";
			html += "<input class='textInput' type='text'>";
			html += "<img src='/images/ezSurvey/attach.png' class='attachImg' onclick='optTrigger();'> ";
			html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent(this);'>";
			html += "</div>";
			
			element.find(".option").last().after(html);
			
		});
		
		// 삭제 버튼 클릭시 옵션 삭제 이벤트
		/* $(".deleteOption").click(function() {
			var element = $(this).parent().parent().parent();

			var option = element.find(".optionPart").find(".option");
			console.log("옵션 개수: " + option.length );
			
			if (option.length > 2) {
				var option = $(this).parent();
				option.remove();
			
			} else {
				alert("보기는 2개 이상 필요합니다.");
			}
		}); */
		
		// 기타 버튼 클릭시 기타 추가 이벤트
		$(".addOther").click(function() {
			
			var element = $(this).parent().parent().parent();

			var other = element.find(".optionPart").find(".other");
			
			if (other.length == 0) {
				
				var html = "";
				html += "<div class='other'>";
				html += "<input class='textInput' type='text' placeholder='기타'>";
				html += "<img src='/images/ezSurvey/attach.png' class='attachImg' onclick='optTrigger();'>";
				html += "<img src='/images/ezSurvey/minus.jpg' class='deleteOption' onclick='deleteEvent(this);'>";
				html += "</div>";
				
				element.find(".optionPart").append(html);
			} else {
				alert("기타는 하나만 추가 가능합니다.");
			}
		});
		
		// 질문과 보기의 모든 내용 임시 저장
		$(".save").click(function(event) {
			var questionType = parseInt($(this).parents(".selection").attr("questiontype"));
			
			if (questionType == 1) {
				var optionPart = $(this).parents(".optionPart").find(".option");
				console.log("콘솔");
				var additional = $(this).parents(".additionalPart");
				
				var requiedVal = additional.find("input[name=checkbox]").is(":checked")
				
				console.log(optionPart);
				var question = {};
				
				for (var i = 0; i < optionPart.length; i++) {
					var option = {};
					// 보기의 내용
					var contents = optionPart[i].childNodes[0].value;
					
					option['content'] = contents;
					
					question['option' + i] = option;
					question['questionType'] = questionType;
					
					if (requiedVal == true) {
						question['requied'] = "1";
						
					} else {
						question['requied'] = "0";
					}
				}
				console.log(question);
			}
		});
		
		// option의 attachFile 임시 저장
		/* $(".fileInput").change(function(e) {
			
			var target = "option";
			
			var attachFile = {};
			
			var fileLength = e.target.files.length;
			for (var i = 0; i < fileLength; i++ ) {
				
				var fileObj = {};
				var file = e.target.files[i];
				
				var fName = file.name;
				var fSize = file.size;
				var fType = file.type;
				
				fileObj["target"] = target;
				fileObj["name"] = fName;	
				fileObj["size"] = fSize;	
				fileObj["type"] = fType;
				
				attachFile["file" + i] = fileObj;
			}
			
			console.log(attachFile);
		}); */
		
		
		
		
		// question의 attachFile 임시 저장
		/* $(".attachFile").change(function(e) {
			
			var target = "question";
			
			console.log($(this)[0]);
			//var savePath = "C:\Temp\attachFile";

			var attachFile = {};
			
			var fileLength = e.target.files.length;
			for (var i = 0; i < fileLength; i++ ) {
				
				var file = e.target.files[i];
				
				var fName = file.name;
				var fSize = file.size;
				var fType = file.type;
				
				var fileObj = {};
				fileObj["target"] = target;
				fileObj["name"] = fName;	
				fileObj["size"] = fSize;	
				fileObj["type"] = fType;
				
				attachFile["file" + i] = fileObj;
			}
			
			console.log(attachFile);
			
		}); */
		
	}
	
	// option 첨부파일의 trigger
	function optTrigger() {
		$(".optionAttach").click();
	}
	
	
	// option 첨부파일
	function optionFileUpload(e){
		surveyFile.upload();
    }
	
	function deleteEvent() {
		// 삭제 버튼 클릭시 옵션 삭제 이벤트
		$(".deleteOption").click(function() {
			console.log($(this));
			var element = $(this).parent().parent().parent();
			
			var option = element.find(".optionPart").find(".option");
			console.log("옵션 개수: " + option.length );
			// 보기의 개수가 3개 이상일 때만 보기 삭제
			if (option.length > 2) {
				var option = $(this).parent();
				option.remove();
			
			} else {
				alert("보기는 2개 이상 필요합니다.");
			}
		});
	}
	
	var 
	</script>
</div>