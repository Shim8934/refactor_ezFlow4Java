<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>Insert title here</title>
		<!-- <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css"> -->	
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script src="/js/dist/jstree.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <link rel="stylesheet" href="/js/dist/themes/default/style.min.css" />
	</head>
	<body>
	<style>
		body {
			margin: 0;
		}
		#lmTop {
			width: 1200px;
			margin-top: 5px;
		}
		#lmTop > div {
			float: left;
			height:600px;
		}
		#lmTop button {
		    background: white;
		    border: 1px solid #c6c6c6;
		    border-radius: 3px;
		    font-size: 12px;
		    color: #393939;
		    cursor: pointer;
		    outline: none;
		    height: 20px;
   	 		line-height: 1;
		}
		#lmTop button:hover {
			color: #0B790E;
		}
		.lmtitle {
			height: 30px;
		    background: #f8f8f8;
		    border-bottom: 1px solid #cbcbcb;
		    font-weight: bold;
		    color: #777;
		    font-size: 12px;
		    line-height: 30px;
		    box-sizing: border-box;
		    padding: 0 4px;
	    }
		.lmleft {
			width: 360px;
			width: 30%;
			margin-right: 20px;
		}
		.lmLetterBox {
			height:32%;		
			border: #b6b6b6 1px solid;
		}
		.lmLetterBoxList {
			overflow: auto;
			font-size: 12px;
		    color: #5b5a5a;
		    box-sizing: border-box;
		    padding: 4px;
		    height: 160px;
		}
		.lmLetterBoxList i {
			background-position: center center;
		}
		.lmLetterBoxTitle > div{
			width: 70px;
	    	border-right: 1px solid #cbcbcb;
	    	display: inline-block;
		}
		.lmLetterBoxTitle > input {
			width: 170px; 
			color: #393939;
			border: 1px solid #cbcbcb;
		}
		.jstree-clicked {
			color : #0B790E !important;
		}
		.lmLetter {
			height:60%;		
			border: #b6b6b6 1px solid;
		}
		.lmBtns {
			height:5%;	
		}
		.lmleft > div:nth-child(2) {
			margin: 10px 0;
		}
		.lmright {
			width: 60%; 
			border: #b6b6b6 1px solid;
		}
		.lmLetterListUl {
			list-style: none;
		    padding: 0;
		    margin: 0;
		    font-size: 12px;
		    color: #5b5a5a;
		    text-align: left;
		}
		.lmNoData {
			text-align: center;
		}
		.lmLetterListUl li {
			height: 30px;
		    line-height: 30px;
		    box-sizing: border-box;
		    border-bottom: 1px solid #ebebed;
		    padding: 0 4px;
		}
		.lmLetterListUl li span { 
			width:250px;
			margin-right:10px;
		    display: inline-block;
		    cursor: pointer;
    		overflow: hidden;
    		text-overflow: ellipsis; 
    		white-space: nowrap;
    		float: left;
		}
		.lmLetterListUl li button {
			margin: 0 2px;
		}
		.lmBtns button {
			height: 25px !important;
		}
		.lmBtns div {
			float: right;
		}
		.lmBtns div button, img {
			float: left;
			margin: 0 3px;
		}
		.lmPreview {
			height: 100%;
		    overflow: auto;
		}
	</style>
		<div id="lmTop">
			
			<div class="lmleft">
				<!-- 편지지함 목록 -->
				<div class="lmLetterBox">
					<div class="lmtitle lmLetterBoxTitle">
						<div>편지지 검색</div>
						<input type="text" name="" id="lmSearchInput">
						<button id="lmSearch">검색</button>
						<button id="lmSearchReset">초기화</button>
					</div>	
					<div id="divTree" class="lmLetterBoxList"></div>
				</div>
				<!-- 편지지 목록 -->
				<div class="lmLetter">
					<div class="lmtitle lmLetterTitle">
						편지지 목록
					</div> 
					<div class="lmLetterList boxNo" data-boxNo=""> <!-- boxNo -->
						<ul class="lmLetterListUl"></ul>
					</div>
				</div>
				<!-- 버튼 -->
				<div class="lmBtns">
					<div class="boxNo" data-boxNo=""> <!-- boxNo -->
						<button onClick="letterEditPopUp(this, 'add')">편지지 추가</button>
						<button onClick="letterBoxMove(this)">편지지 이동</button>
						<img src="/images/i_bar.gif" alt="line">
						<button class="lmBtnPrev"><img src="/images/ImgIcon/prev.gif" alt="prev"></button>
						<button class="lmBtnNext"><img src="/images/ImgIcon/next.gif" alt="next"></button>
						<button>순서 저장</button>
					</div>
				</div>
			</div>
			
			<div class="lmright">
				<div class="lmPreview">
					
				</div>
			</div>			
		</div>
		
		<script type="text/javascript">
			var pageType = "${pageType}";
			var previewHtml = "<div style='text-align:center; position:relative; top:50%; tansform:translateY(-50%);'>미리보기</div>";
			
			$(document).ready(function(){
				
				resultRead();
				
				$(".lmPreview").html(previewHtml); //미리보기 text

				//검색 버튼 클릭
				$("#lmSearch").on("click",function(){
					if($("#lmSearchInput").val().trim() == "") {
						alert("검색어를 입력해주세요.");
						return;
					}
					//ajax
					
				});
				//검색어 초기화
				$("#lmSearchReset").on("click",function(){
					$("#lmSearchInput").val("");
				});
				
				//편지지 삭제
				$(document).on("click", ".lmLetterListUl .lmLetterDeleteBtn", function(){
					var deleteChk = confirm("정말로 삭제하시겠습니까?");
					
					if(deleteChk) {
						var letterBox = $(this).parents(".boxNo").attr("data-boxNo");
						var letterNo = $(this).parent("li").attr("data-letterNo");
						console.log(letterBox + " ==== " + letterNo);
						
						$.ajax({
							type:"POST",
							data:{letterNo:letterNo},
							url:"/admin/ezEmail/deleteLetter",
							success:function(){
								getLetterList(letterBox);
								alert("삭제하였습니다.");
							}
						});
					}
					
				});
				
				// 편지지 선택
				$(document).on("click", ".lmLetterListUl li span", function(){
					$(this).parent("li").css("background","#e9f1ff");
					$(this).parents("ul").find(".lmLetterSelect").css("background","none").removeClass("lmLetterSelect");
					$(this).parent("li").addClass("lmLetterSelect");
				});
				
				// 편지지 마우스 올릴때 
				$(document).on("mouseover", ".lmLetterListUl li:not('.lmLetterSelect') span", function(){
					$(this).parent("li").not(".lmLetterSelect").css("background","#f8f8f8");
				});
				
				// 편지지 마우스 땔때
				$(document).on("mouseleave", ".lmLetterListUl li:not('.lmLetterSelect') span",function(){
					$(this).parent("li").not(".lmLetterSelect").css("background","none");
				});
				
				
			}); // document on ready
			
			// 편지지 추가, 수정 클릭 시  || btn -> this, type -> 추가=add
			function letterEditPopUp(btn, type) {
				
				// 편지지함 no
				letterBoxNo = $(btn).parents(".boxNo").attr("data-boxNo");
				// 추가 or 수정 구분
				popUpType = type == "add" ? type : "modify";
				
				//url
				url = "/admin/ezEmail/letterEditPopUp.do?" + "letterBoxNo=" + letterBoxNo + "&type=" + popUpType;  
					
				window.open(url,"_blank","width=890, height=660");
			}
			
			
			// 편지지 목록 ===========================================================================================
			var result = [];
		    var letter_displayname;
		    var letter_displayname2;
		    var treeCollection = [];
		    var xmlhttp;
		    var responseResult;
		    var selectNode;
		    var addCheck = 0; // 0이면 추가 가능, -1이면 불가능
		    
			function resultRead() {
				$.ajax({
					type : "POST",
					url : "/admin/ezEmail/getLetterBox.do",
					datatype : 'json',
					error : function(data) {
						alert("error");
						console.log(data);
					},
					complete : function(data) {
				        result = data.responseJSON;
				        treeSet();
				    	treeView();
				    	treeInit();
				    }
				});
		    }
		    
		    function treeInit () {
		    	$("#divTree").on('ready.jstree', function (e, data) {
		    		selectNode = data;
		    		//$("#divTree").jstree('open_all');
		    		//data.instance.open_node(["1"]);
		    		data.instance.select_node(["1"]);
		    	});
		    }
		    
		    function treeOnclick() {
		    	var parent;
		    	
		    	$('#divTree').on('changed.jstree', function (e, data) {
		    		if (pageType === "letterBox") { // 편지지함 
			    		if (addCheck == -1) {
			    			//추가하면 다른 node 못누르게됨
			    			$("#divTree").jstree('select_node', "#temp");
			    			setDisplay("편지지함", "letterbox_temp");
			    			return;
			    		}
			    		
			    		
			    		selectNode = data;
			    		parent = selectNode.node.parent;
			    		
			    		if (parent == '#') {
			    			parent = '0';
			    		}
			    		
			    		document.getElementById("parent_letterbox_no").value = parent;
			    		document.getElementById("letterbox_no").value = selectNode.node.id; 
			    		//여기다가 비슷하게 회사 추가하기
			    		
			    		if (!(selectNode.node.id.indexOf('temp'))) {
			    			// 편지지함이 임시 추가라면
			    			setDisplay("편지지함", "letterbox_temp");
			    		} else { 
			    			selectBox(selectNode.node.id);
			    		}
		    		} else { // 편지지
		    			// letterBoxNo
		    			var letterBoxNo = data.node.id === "undefined" ? "1" : data.node.id;
		    			
		    			getLetterList(letterBoxNo); // 편지지 리스트
		    		}
		        });
		    	
		    }
		    
		    function selectBox(letterBoxNo) {
		    	var query = "/admin/ezEmail/readLetterBox.do?letterBoxNo=" + letterBoxNo;
		    	
		    	xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", query, true);
		        xmlhttp.responseType = 'text'; 
		        xmlhttp.onreadystatechange = readText;
		        xmlhttp.send();
		    }
		    
		    function deleteBox(letterBoxNo) {
		    	var query = "/admin/ezEmail/deleteLetterBox.do?letterbox_no=" + letterBoxNo;
		    	
		    	xmlhttp = createXMLHttpRequest();
		        xmlhttp.open("POST", query, true);
		        xmlhttp.responseType = 'json'; 
		        xmlhttp.onreadystatechange = deleteText;
		        xmlhttp.send();
		    }
		    
		    function deleteText() {
		    	if (xmlhttp == null || xmlhttp.readyState != 4) return;
		    	responseResult = xmlhttp.response;
		    	
		    	if (responseResult == "ERROR") {
		    		return;
		    	}
		    }
		    
		    function readText() { 
		    	if (xmlhttp == null || xmlhttp.readyState != 4) return;
		    	responseResult = xmlhttp.response;
		    	var displayname = 'displayname":"';
		    	var displayname2 = 'displayname2":"';
		    	var displayname_start = responseResult.indexOf(displayname) + displayname.length;
		    	var displayname2_start = responseResult.indexOf(displayname2) + displayname2.length;
		    	var displayname_end = responseResult.indexOf('","par');
		    	var displayname2_end = responseResult.indexOf('","com');
		    	
		    	letter_displayname = responseResult.substring(displayname_start, displayname_end);
		    	letter_displayname2 = responseResult.substring(displayname2_start, displayname2_end);
		    	
		    	setDisplay(letter_displayname, letter_displayname2);
		    }
		    
		    function setDisplay(letter_displayname, letter_displayname2) {
		    	document.getElementById("display").value = letter_displayname;
		    	document.getElementById("display2").value = letter_displayname2;
		    }
		    
		    function treeSet() {
		    	var parentArray = [];
		    	for(var i = 0; i < result.length; i++) {
		    		var treeId = result[i].letterbox_no; 
		    		var treeParent = result[i].parent_letterbox_no;
		    		var treeText = result[i].displayname;
		    		
		    		if (treeParent == '0') {
		    			treeParent = '#'; //root node
		    		}
		    		
		    		treeCollection.push({id:treeId, parent:treeParent, text:treeText}); // data 추가하기
		    	}
		    	
		    }
		    
		    function treeView() {
		    	$('#divTree').jstree({
		    		"plugins" : [ "changed", "wholerow", "types" ],
		    		'core' : {
		    			'data' : treeCollection,
		    			"check_callback": true
		    			},
		    			"types" : {
		                    "default" : {
		                        "icon" :"/images/OrganTree_cross/fldr.gif"
		                    }
 		                }
		    	});
		    	treeOnclick();
		    }
		    // ==========================================================================
		    	
			// 편지지 리스트
			function getLetterList(letterBoxNo) {
				$.ajax({
    				type:"POST",
    				data:{letterBoxNo:letterBoxNo},
    				url:"/admin/ezEmail/readLetterList",
    				dataType:"json",
    				success:function(data){
    					addLetterList(data); // 편지지 리스트 html
    					
    			    	$(".boxNo").attr("data-boxNo", letterBoxNo); // 편지지 리스트 div, 편지지 버튼 div => letterBoxNo
    				},
    				error:function(d){
    					console.log(d);
    				}
    			});
			}
		    
		    // 편지지 목록 추가 
		    function addLetterList(jsonArr) {
		    	var letterListHtml = "";
		    	var listCount = jsonArr.length;

		    	if (listCount != 0) {
		    		for (i = 0; i < listCount; i++) {
		    			letterListHtml += "<li data-letterNo='" + jsonArr[i].letterNo + "'>";
		    			letterListHtml += "<span>" + jsonArr[i].displayname + "</span>";
		    			letterListHtml += "<button class='lmLetterModifyBtn' onClick='letterEditPopUp()'>수정</button>";
		    			letterListHtml += "<button class='lmLetterDeleteBtn'>삭제</button>";
		    			letterListHtml += "</li>";
		    		}
		    	} else {
			    	letterListHtml = "<li class='lmNoData'>데이터가 없습니다.</li>";
		    	}
		    	
		    	$(".lmLetterListUl").html(letterListHtml);
		    }

		    // 편지지 이동
		    function letterBoxMove(btn){
				// 편지지함 no
				letterNo = $(".lmLetterSelect").attr("data-letterno");
				
				if (letterNo !== "undefined") {
					//url
					url = "/admin/ezEmail/letterBoxMovePopUp.do?" + "letterNo=" + letterNo;  
						
					window.open(url,"_blank","width=890, height=660");
				}
		    }
					
		</script>
	</body>
</html>