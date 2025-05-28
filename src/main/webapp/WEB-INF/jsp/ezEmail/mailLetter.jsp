<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezEmail.t824'/></title>
	    <link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
	    <link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />	
	    <link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	    <link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script src="${util.addVer('/js/dist/jstree.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterBoxTree.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterList.js')}"></script>
	    <style>
			.imgbtn {
			    vertical-align: middle;
			    height:22px
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
			    height: 32px;
			    background: #f8f8f8;
			    color: #333;
			    font-size: 12px;
			    line-height: 32px;
			    box-sizing: border-box;
			    padding: 0 4px;
			    text-align: center;
			    font-weight: normal
			}
			
			 .lmLetterBoxTitle>input {
			    width: 70%;
			    height: 24px;
			    color: #393939;
			    border: 1px solid #cbcbcb;
			} 
			
			#letterTable {
				height: 370px; 
				width: 550px; 
				margin: 7px 7px; 
				border: 1px solid #ddd;
			}
			
			input::-webkit-input-placeholder{
				text-align: center;
			}
			
			#span1 {
				margin-right: 10px;
			    display: inline-block;
			    overflow: hidden;
			    text-overflow: ellipsis;
			    white-space: nowrap;
			    float: left;
				width: 70%;
			    margin: 0px;
			    text-align: left;
			}
			
			#b1 {
			    width: 30%;
			    display: inline-block;
			    overflow: hidden;
			    text-overflow: ellipsis;
			    white-space: nowrap;
			    text-align: left;
			}
			
			.jstree-node, .jstree-children, .jstree-container-ul { 
				margin-top: 3px;
			}
			
		</style>
	
	</head>
	<body style="overflow:hidden;" class="popup">
		<h1><spring:message code='ezEmail.t824'/></h1>
		<div id="close">
            <ul>
                <li><span onclick="cancel()"></span></li>
            </ul>
        </div>
		<table border="1" id="letterTable" >
			<tr style="height:8%; border-bottom:none;">
				<th colspan="2" align="center" style="border:1px solid #ddd;padding:0px">
					<div class="lmtitle lmLetterBoxTitle" style="border-bottom:0px;">
						<input type="text" name="" id="lmSearchInput" class="searchInput" onkeydown="letterSearchEnter();" placeholder="<spring:message code="ezEmail.t10"/>" style="border-color:#ddd">
						<a id="lmSearch" class="imgbtn" style="margin-top: -3px;" onclick="letterSearch()"><span style="line-height:22px"><spring:message code='ezEmail.letter1'/></span></a>
						<a id="lmSearchReset" class="imgbtn" style="margin-top: -3px;" onclick="inputReset()"><span style="line-height:22px"><spring:message code='ezBoard.t999035'/></span></a>
					</div>	
				</th>
			</tr>
			<tr style="border-color:#ddd;">
				<td style="width:50%; vertical-align:top; border-right:1px solid #ddd">
					<div id="divTree" style="height: 340px; width: 268px; overflow: auto; "></div>
				</td>
				<td style="width:50%; vertical-align:top; ">
					<div class="lmLetterList boxNo" data-boxNo="" style="height:341px; width:278px; overflow: auto;">
						<ul class="lmLetterListUl" style="background: white;"></ul>
					</div>
				</td>
			</tr>
		</table>
		<div class="btnposition btnpositionNew" >
			<a class="imgbtn" onclick="letterPreview(this)"><span><spring:message code='ezEmail.t487'/></span></a>
			<a class="imgbtn" onclick="letterSelect()"><span><spring:message code='ezBoard.t47'/></span></a>
		</div>
		
		<script type="text/javascript">
		    var pageType = "${pageType}";
		    var returnCompany = '${companyId}';
		    var userLang = '${userLang}';
		    var isDivPopUp = false;
			var result = [];
		    var treeCollection = [];
		    var xmlhttp;
		    var responseResult;
		    var selectNode;
		    var searchTxt = "";

			var searchMsg = "<spring:message code='ezOrgan.t56'/>"; // 검색어를 입력해주세요.
			var letterNoMsg = "<spring:message code='ezEmail.letter16'/>"; // 존재하지 않는 편지지 입니다.
			var previewMsg = "<spring:message code='ezBoard.t431'/>"; // 미리보기 
			var dataNoMsg= "<spring:message code='main.t00026'/>"; // 데이터가 없습니다.
			var selectLetterMsg ="<spring:message code='ezEmail.letter5'/>"; // 편지지를 선택하세요!
			var letterListMsg = "<spring:message code='ezEmail.letter2'/>"; //편지지 목록
			var letterPathMsg = "<spring:message code='main.t4003'/>"; //경로
	    
			$(document).ready(function(){
				resultRead(); // 편지지함 목록
				isDivPopUp = true;
			});
			
			// 편지지 더블클릭 시 선택
			$(document).on("dblclick", ".lmLetterListUl li", function(){
				letterSelect();
			});
			
			// 편지지 미리보기
		    function letterPreview(btn){
				var letterNo = $(".lmLetterSelect").attr("data-letterno");
				
				if (letterNo !== undefined) {
		    		url = "/ezEmail/mailLetterPreview.do?" + "letterNo=" + letterNo;  
		    		window.open(url,"_blank","width=890, height=660");
		    	} else {
		    		alert(selectLetterMsg);
		    		return;
		    	}
		    }
			
			// 편지지 선택 (mailWirte.jsp에 들어가도록)
			function letterSelect() {
				var letterNo = $(".lmLetterSelect").attr("data-letterno");
				
				if (letterNo !== undefined) {
					$.ajax({
						type:"POST",
						data:{letterNo:letterNo,popUpType:"modify"},
						url:"/admin/ezEmail/readLetter",
						dataType:"json",
						success:function(data){
							if (data.filePath === 'ERROR') {
								alert(letterNoMsg);
								return;
							}
							
							var editorMailContent = parent.message.GetEditorContent();
							var letterHtml = data.letterHtml;
							
							parent.DivPopUpHidden();
							parent.message.SetEditorContent(letterHtml + editorMailContent);
						}
					});
		    	} else {
		    		alert(selectLetterMsg);
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
		</script>
	</body>
</html>



