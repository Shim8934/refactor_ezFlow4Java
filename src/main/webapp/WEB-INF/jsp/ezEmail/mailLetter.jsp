<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>편지지</title>
	    <link rel="stylesheet" href="/js/dist/themes/default/style.min.css" />
	    <link rel="stylesheet" href="/css/ezEmail/style.css" />	
	    <link rel="stylesheet" href="<spring:message code='ezEmail.c1' />" type="text/css">
		<link rel="stylesheet" href="/css/default_kr.css" type="text/css">
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script src="/js/dist/jstree.min.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterBoxTree.js"></script>
	    <script type="text/javascript" src="/js/ezEmail/js_cross/letterList.js"></script>
	   
		<script type="text/javascript">
	    var pageType = "${pageType}";
	    var returnCompany = '${companyId}';
	    var isDivPopUp = false;
	    
	 // 편지지 목록 ===========================================================================================
		var result = [];
	    var treeCollection = [];
	    var xmlhttp;
	    var responseResult;
	    var selectNode;
	    var pageType = '${pageType}';
	    
			$(document).ready(function(){
				resultRead(); // 편지지함 목록
				isDivPopUp = true;
				
			});
			
			// 편지지 미리보기
		    function letterPreview(btn){
				var letterNo = $(".lmLetterSelect").attr("data-letterno");
				
				if (letterNo !== "undefined") {
		    		url = "/ezEmail/mailLetterPreview.do?" + "letterNo=" + letterNo;  
		    		window.open(url,"_blank","width=890, height=660");
		    	}
		    }
			
			// 편지지 선택(mailWirte.jsp에 들어가도록)
			function letterSelect() {
				var letterNo = $(".lmLetterSelect").attr("data-letterno");
				var select = $('body').find('.lmLetterSelect');
				if (select.length != 0) {
					$.ajax({
						type:"POST",
						data:{letterNo:letterNo,popUpType:"modify"},
						url:"/admin/ezEmail/readLetter",
						dataType:"json",
						success:function(data){
							
							console.log(data);
							
							if (data.filePath == 'ERROR') {
								alert("존재하지 않는 편지지입니다.");
								return;
							}
							
							var editorMailContent = parent.message.GetEditorContent();
							var letterHtml = data.letterHtml;
							
							parent.DivPopUpHidden();
							parent.message.SetEditorContent(letterHtml + editorMailContent);
						}
					});
					
		    	} else {
		    		alert("편지지를 선택하세요.");
		    		return;
		    	}
		    }
		    
			// 닫기버튼
		    function cancel() {
	             if (!isDivPopUp){
	                window.close();
	            } else {
	            	parent.DivPopUpHidden();
	            }
		    }
		    
		    // 편지지 선택
		    $(document).on("click", ".lmLetterListUl li", function(){
		    	var letterNo = $(this).attr("data-letterno");
		    	
		    	$(this).css("background","#e9f1ff");
		    	$(this).parents("ul").find(".lmLetterSelect").css("background","none").removeClass("lmLetterSelect");
		    	$(this).addClass("lmLetterSelect");
		    	
		    	if (pageType != 'letter_user') {
		    		letterPreView(letterNo); // 편지지 미리보기
		    	}
		    });

		    // 편지지 마우스 올릴때 
		    $(document).on("mouseover", ".lmLetterListUl li:not('.lmLetterSelect')", function(){
		    	$(this).not(".lmLetterSelect").css("background","#f8f8f8");
		    });

		    // 편지지 마우스 땔때
		    $(document).on("mouseleave", ".lmLetterListUl li:not('.lmLetterSelect')",function(){
		    	$(this).not(".lmLetterSelect").css("background","none");
		    });
		    
		    
		</script>
		<style>
			.imgbtn {
			    vertical-align: middle;
			}
			
			#mainmenu {
				margin-bottom: 0;
			}
			
			#mainmenu li span, #mainmenu li span.off {
			    color: #FFFFFF;
			    margin-top: 4px;
			}
			
			#letterDiv {
				width: 500px;
			    height: 400px;
			    margin: 7px 7px;
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
			    text-align: center;
			}
			
			.lmLetterBoxTitle>input {
			    width: 68%;
			    height: 22px;
			    color: #393939;
			    border: 1px solid #cbcbcb;
			}
			
			#letterTable {
				height: 370px; 
				width: 550px; 
				margin: 7px 7px; 
				border: 1px solid #cbcbcb;
			}
			
			input::-webkit-input-placeholder{
				text-align: center;
			}
			
			span {
				clear: none;
			}
			
			.lmLetterListUl li {
			    height: 30px;
			    line-height: 30px;
			    box-sizing: border-box;
			    border-bottom: 1px solid #ebebed;
			    padding: 0 4px;
			    cursor: pointer;
			}
			
		</style>
	
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1>편지지</h1>
		
		<table border="1" id="letterTable">
			<tr style="height:8%;">
				<td colspan="2" align="center">
					<div class="lmtitle lmLetterBoxTitle">
						<input type="text" name="" id="lmSearchInput" class="searchInput" placeholder="검색어를 입력해주세요">
						<a id="lmSearch" class="imgbtn" onclick="letterSearch()"><span>편지지 검색</span></a>
						<a id="lmSearchReset" class="imgbtn" onclick="inputReset()"><span>초기화</span></a>
					</div>	
				</td>
			</tr>
			<tr>
				<td style="width:50%; vertical-align:top;">
					<div id="divTree" style="height: 350px; width: 273px; overflow: auto;"></div>
				</td>
				<td style="width:50%; vertical-align:top; ">
					<div class="lmtitle lmLetterTitle">
						편지지 목록
					</div> 
					<div class="lmLetterList boxNo" data-boxNo="" style="height:320px; width:273px; overflow: auto;">
						<ul class="lmLetterListUl"></ul>
					</div>
				</td>
			</tr>
		</table>
		<div class="btnposition btnpositionNew">
			<a class="imgbtn" onclick="letterPreview(this)"><span>미리보기</span></a>
			<a class="imgbtn" onclick="letterSelect()"><span>선택</span></a>
			<a class="imgbtn" onclick="cancel()"><span>닫기</span></a>
		</div>
		
				
	</body>
</html>



