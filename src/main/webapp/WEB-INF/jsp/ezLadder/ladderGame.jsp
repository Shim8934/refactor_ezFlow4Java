<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<link rel="stylesheet" href="/css/ezLadder/ladder_CSS.css">
	<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
	
	<script type="text/javascript">
	
		var id = "${id}";
		var searchSelect = "${searchSelect}";
		var searchInput =  "${searchInput}";
		var mode = "${mode}";
		var currPage = "${currPage}";
		var back = "back";
		var allData = [];
		var size = "${ fn:length(list)}";
		var lineCnt = "${vo.lineCnt}"

		/** 180320 추가 : 사다리 재사용 */
		$(function() {
			$("#usePreladder").on("click", function() {
				window.location.href = "/ezLadder/setLadder.do?ladderId=" + ${vo.ladderId};
			});
		});
		
		function deleteLadder(idx) {
		
			allData = [idx, searchSelect, searchInput, mode, currPage, back ];	
		
			if (confirm('삭제 하시겠습니까?')) {
				window.location.href= '/ezLadder/deleteLadder.do?allData=' + allData;
			} 
		}
		
		/* function reuse(idx) {
			if (confirm('재사용하시겠습니까?')) {
				window.location.href= '/ezLadder/setLadder.do?type=reuse&ladderId=' + idx;
			}
		}
		
		function start(idx) {
			allData = [idx, searchSelect, searchInput, mode, currPage, size, lineCnt ];	
			if (confirm('시작하시겠습니까?')) {
				window.location.href= '/ezladder/setLadderStart.do?allData=' + allData;
			}
		} */
	</script>
	<style type="text/css">
		ul {
		    list-style:none;
		    margin:0;
		    padding:0;
		}
		
		li {
		    margin: 0 0 0 0;
		    padding: 0 0 0 0;
		    border : 0;
		    float: left;
		    text-align: center;
		}
		
		.blackBox {
			width:100%;height:500px;
			border:30px solid transparent; 
			color:black;
			background: #010;
			border-color:#010;
		}
	</style>
</head>
	<body class="mainbody">
		<div id="ladderInfo" style="margin-top: 50px; margin-left: 50px; margin-right: 50px;">
			<h2>${vo.title }
				<span style="float: right; font-weight:normal;color:black;">
					종류 : ${vo.type }, 상태 : ${vo.status }, 공개 : ${vo.secretFlag } | 작성자 ${vo.writerName }, 부서 ${vo.deptName }, 
					<div id="usePreladder" style="display: inline-block; cursor: pointer;">
						<img src ='/images/ezLadder/reuse.png' width='30' height ='30'/>
					</div>,
					<c:choose>
						<c:when test="${id eq vo.writerId }">
							<a href="#" onclick="deleteLadder(${vo.ladderId})"><img src ='/images/ezLadder/trash.png' width='30' height ='30'/></a><br>
						</c:when>
						<c:otherwise>
							<img src ='/images/ezLadder/trash.png' width='30' height ='30'/><br>
						</c:otherwise>
					</c:choose>
				</span> 
			</h2>
		</div>
		<div class="fullwidth">
			<table class="setTable">
				<tr>
					<td style="width: 5000px;"></td><td></td>
				</tr>
				
				
				<tr>
					<td colspan="4" style="height: 700px; padding: 10px 0px;">
						<div class="wrap center" style="height: 100%; width: 100%;">
							<div id="ladderLineBox" style="height: 100%; width: 100%; border: 1px solid gray">
								<c:choose>
									<c:when test="${vo.status eq 0 }">
										<%@ include file="include/ladderWait.jsp"%> 
									</c:when>
									<c:otherwise>
										<%@ include file="include/ladderComplete.jsp"%> 
									</c:otherwise>
								</c:choose>
								<br><br><br><br>
							</div>
						</div>
					</td>
				</tr>
			</table>
			
			
		</div>
		

		<div id="ladderGame" align="center" >
			<br><br><br><br>
			상태가 대기이면 ladderWait.jsp 호출<br>
			상태가 완료이면 ladderComplete.jsp 호출<br><br><br>
			
			<br><br><br><br><br><br><br><br><br><br><br><br><br>
		</div>
		
		
		<div id="chat" align="center">
			<%@ include file="include/ladderChat.jsp"%> 
		</div>
	<h3>
		* 프론트 꾸며야 됨.<br>
		* 웹소켓 - 참여자 바꾸기, 채팅
		</h3>
	
	</body>
</html>