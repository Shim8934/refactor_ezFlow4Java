<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title></title>
		<link rel="stylesheet" href="${util.addVer('/js/dist/themes/default/style.min.css')}" />
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('/css/ezEmail/style.css')}" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script src="${util.addVer('/js/dist/jstree.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterBoxTree.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezEmail/js_cross/letterList.js')}"></script>
	</head>
	<style>
		.lmtitle {
			font-weight: normal;
		}
		.lmLetterModifyBtn, .lmLetterDeleteBtn {
			background-color: #e8e8ea !important;
		}
		.jstree-default .jstree-themeicon {
			width:0px !important;
			height:0px !important;
		}
		.jstree-default>.jstree-no-dots .jstree-closed>.jstree-ocl{
			background-image: url(/images/OrganTree_cross/plus.png) !important;
			background-position: center !important;
		}
		.jstree-default>.jstree-no-dots .jstree-open>.jstree-ocl {
			background-image: url(/images/OrganTree_cross/minus.png) !important;
	   		background-position: center !important;
		}
	</style>
	<body>
		<div id="lmTop">
			<div class="lmleft" style="height:100%">
				<!-- 편지지함 목록 -->
				<table >
					<tr>
						<td>
							<div class="lmLetterBox" style="width: 360px;" > 
								<div class="lmtitle lmLetterBoxTitle">
									<div style="border-top: 0px">
										<spring:message code='ezEmail.letter1' />
									</div>
									<input type="text" name="" id="lmSearchInput"
											class="searchInput" onkeydown="letterSearchEnter();" style="height:22px">
									<div class="lmLetterBoxTitSearch">
										<button id="lmSearch" onclick="letterSearch()">
											<spring:message code='ezBoard.t188' />
										</button>
										<button id="lmSearchReset" onclick="inputReset()">
											<spring:message code='ezBoard.t999035' />
										</button>
									</div>
								</div>
								<div id="divTree" class="lmLetterBoxList"></div>
							</div>
						</td>
					</tr>
				</table>
				<!-- 편지지 목록 -->
				<table style="margin-top:6px">
					<tr>
						<td>
							<div class="lmLetter">
								<div class="lmtitle lmLetterTitle">
									<spring:message code='ezEmail.letter2' />
								</div>
								<div class="lmLetterList boxNo" data-boxNo="" style="height: 220px; width: 360px; overflow: auto">
									<!-- boxNo -->
									<ul class="lmLetterListUl lmLetterListWrap"></ul>
								</div>
							</div>
						</td>
					</tr>
				</table>
				<!-- 버튼 -->
				<div style="width:950px">
					<div class="boxNo btnpositionJsp" data-boxNo="">
						<!-- boxNo -->
						<a class="imgbtn" onClick="letterEditPopUp(this, 'add')" ><span><spring:message code='ezEmail.letter3' /></span></a>
						<%-- <button onClick="letterEditPopUp(this, 'add')" class="searchDis">
							<spring:message code='ezEmail.letter3' />
						</button> --%>
						<a class="imgbtn" onClick="letterBoxMove(this)" ><span><spring:message code='ezEmail.letter4' /></span></a>
						<%-- <button onClick="letterBoxMove(this)">
							<spring:message code='ezEmail.letter4' />
						</button> --%>
						<!-- <img src="/images/i_bar.gif" alt="line"> -->
						<a class="imgbtn" onClick="orderSelect('prev')" ><span><img src="/images/ImgIcon/prev.gif" alt="prev"></span></a>
						<!-- <button class="lmBtnPrev searchDis" onclick="orderSelect('prev')">
							<img src="/images/ImgIcon/prev.gif" alt="prev">
						</button> -->
						<a class="imgbtn" onClick="orderSelect('next')" ><span><img src="/images/ImgIcon/next.gif" alt="next"></span></a>
						<!-- <button class="lmBtnNext searchDis" onclick="orderSelect('next')">
							<img src="/images/ImgIcon/next.gif" alt="next">
						</button> -->
						<a class="imgbtn" onClick="orderChange()" ><span><spring:message code='ezOrgan.t104' /></span></a>
						<%-- <button onclick="orderChange()" class="searchDis">
							<spring:message code='ezOrgan.t104' />
						</button> --%>
					</div>
				</div>
			</div>
			<table>
				<tr>
					<td>
						<div class="lmright" style="width: 578px; height: 448px">
							<div class="lmPreview">
								<div class="lmPreViewTxt"
									style='text-align: center; position: relative; top: 48%; transform: translateY(-50%); font-size:13px'>
									<spring:message code='ezBoard.t431' />
								</div>
								<iframe src="" class="lmPreViewIframe lmPre" id="lmPreViewIframe"
									onload="onloadPreview(this)" name="lmPreViewIframe"
									style="display: none; border: none; width: 100%; height: 100%;"></iframe>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	
		<script type="text/javascript">
			// resultRead() 사용 *
			var pageType = "${pageType}"; // letter
			var returnCompany = "<c:out value='${companyId}'/>"; // companyId
			var userLang = "${userLang}";
			var result = [];
			var treeCollection = [];
			var xmlhttp;
			var responseResult;
			var selectNode;
			var noResult = false;
			var moveChk = false;
			var searchTxt = ""; // 검색어
			var searchMsg = "<spring:message code='ezOrgan.t56'/>"; // 검색어를 입력해주세요.
			var specialMsg = "<spring:message code='ezEmail.kyj17'/>"; // 해당 특수문자는 입력할 수 없습니다.
			var lengthMsg = "<spring:message code='ezEmail.letter14'/>"; // 자 이하로 입력 가능합니다.
			var contentMsg = "<spring:message code='ezEmail.letter15'/>"; // 내용을 입력해주세요.
			var letterNoMsg = "<spring:message code='ezEmail.letter16'/>"; // 존재하지 않는 편지지 입니다.
			var previewMsg = "<spring:message code='ezBoard.t431'/>"; // 미리보기 
			var modifyMsg = "<spring:message code='ezBoard.t316'/>"; // 수정
			var deleteMsg = "<spring:message code='ezBoard.t89'/>"; // 삭제
			var dataNoMsg = "<spring:message code='main.t00026'/>"; // 데이터가 없습니다.
	
			$(document).ready(function() {
				resultRead(); // 편지지함 목록  (/js/ezEmail/js_cross/letterBoxTree.js)
			});
	
			// 위, 아래 버튼 클릭 시 실행
			// type: prev(위), next(아래)
			function orderSelect(type) {
	
				if (searchMode == true) {
					alert("<spring:message code='ezEmail.letter33'/>");
					return;
				}
	
				var select = $('body').find('.lmLetterSelect');
	
				if (select.length === 0) {
					alert("<spring:message code='ezEmail.letter5'/>");
					return;
				}
	
				if (type == 'prev') {
					select.prev().before(select);
				} else {
					select.next().after(select);
				}
				moveChk = true;
			}
	
			// 순서 저장 버튼 눌렀을때
			function orderChange() {
	
				if (searchMode == true) {
					alert("<spring:message code='ezEmail.letter33'/>");
					return;
				}
	
				var liArr = $('div.lmLetter').find('li');
	
				if ($(liArr).attr("class") == 'lmNoData' || moveChk == false) {
					alert("<spring:message code='ezEmail.letter34'/>");
					return;
				}
	
				for (var i = 0; i < liArr.length; i++) {
					var letterNo = $(liArr[i]).attr("data-letterno");
	
					$.ajax({
						type : "POST",
						url : "/admin/ezEmail/updateLetterOrder.do",
						dataType : "text",
						data : {"letterOrder" : (i + 1),
								"letterNo" : letterNo},
						error : function(data) {
							alert("error");
							return;
						}
					});
				}
	
				alert("<spring:message code='ezEmail.letter6'/>");
				getLetterList(selectNode.node.id);
	
				moveChk = false;
			}
	
			// 편지지 이동
			function letterBoxMove(btn) {
				var letterBox = "";
				var letterNo = $(".lmLetterSelect").attr("data-letterno");
				var letterId = $(".lmLetterSelect").attr("data-letterid");
	
				// 편지지 목록이 선택 되었을때
				if (letterNo !== undefined) {
					letterBox = selectNode.node.id;
	
					url = "/admin/ezEmail/letterBoxMovePopUp.do?letterBox="
							+ letterBox + "&letterNo=" + letterNo + "&letterId="
							+ letterId + "&companyId=" + returnCompany;
					var win = window.open(url, "_blank", GetOpenWindowfeature(550, 450));
	
					// 팝업이 끝나면 실행되는 부분
					var interval = window.setInterval(function() {
						try {
							if (win === null || win.closed) {
								if ($("#lmSearchInput").val().trim() !== "") {
									letterSearch();
								} else {
									getLetterList(selectNode.node.id);
								}
								window.clearInterval(interval);
								closeCallback(win);
							}
						} catch (e) {
						    console.log(e);
						}
					}, 1000);
	
				} else {
					alert("<spring:message code='ezEmail.letter7'/>");
					return;
				}
			}
	
			// 편지지 추가, 수정 btn 클릭     btn -> this, type -> 추가=add, modify일때 type 안받음
			function letterEditPopUp(btn, type) {
				var popUpType = "";
				var letterBoxNo = "";
				var letterNo = "";
	
				if (type === "add") {
					popUpType = "add";
					letterBoxNo = $(btn).parents(".boxNo").attr("data-boxNo");
					letterNo = -1;
	
					if (letterBoxNo == null || (typeof letterBoxNo == "undefined") || letterBoxNo == "") {
						alert("<spring:message code='ezEmail.letter39'/>");
						return;
					} else if (searchMode == true) {
						alert("<spring:message code='ezEmail.letter33'/>");
						return;
					}
				} else {
					popUpType = "modify";
					letterBoxNo = $(btn).parents("li").attr("data-letterboxno");
					letterNo = $(btn).parents("li").attr("data-letterno");
				}
				
				var url = "/admin/ezEmail/letterEditPopUp.do?" + "letterBoxNo="
						+ letterBoxNo + "&popUpType=" + popUpType + "&letterNo="
						+ letterNo;
				var letterPopUp = window.open(url, "letterPopUp", GetOpenWindowfeature(890, 660));
			}
	
			// 편지지 삭제
			function letterDelete(letterId, letterBoxNo, letterNo) {
				$.ajax({
					type : "POST",
					data : {
						letterNo : letterNo,
						letterBoxNo : letterBoxNo,
						letterId : letterId
					},
					url : "/admin/ezEmail/deleteLetter",
					success : function() {
						var lmPreIframe = $(".lmPreViewIframe");
	
						if ($("#lmSearchInput").val().trim() != "") {
							letterSearch(); // 검색된 편지지 목록
						} else {
							getLetterList(letterBoxNo);
						}
	
						if (lmPreIframe.attr("data-letterno") === letterNo) {
							lmPreviewChange();
						}
	
						alert("<spring:message code='ezEmail.letter30'/>");
					}
				});
			}
	
			// 편지지 삭제 버튼 클릭
			$(document)
					.on(
							"click",
							".lmLetterListUl .lmLetterDeleteBtn",
							function(event) {
								event.stopPropagation();
								var deleteChk = confirm("<spring:message code='ezResource.t61'/>");
	
								if (deleteChk) {
									var letterId = $(this).parents("li").attr("data-letterId");
									var letterBoxNo = $(this).parents("li").attr("data-letterboxno"); // 편지지함 no
									var letterNo = $(this).parents("li").attr("data-letterNo");
	
									letterDelete(letterId, letterBoxNo, letterNo);
								}
							});
	
			// 미리보기창에 마우스 올렸을떄 편지지 이름 보여주기
			$(document)
					.on(
							"mouseover",
							".lmPreview > .lmPreViewIframe",
							function() {
								var letterNameChk = $(".lmPreview > .preViewLetterName").length; // 0:없음
	
								if (letterNameChk == 0) {
									var letterName = $(this)
											.attr("data-letterName");
									var letterNameSpan = "<span class='preViewLetterName lmPre'>"
											+ letterName + "</span>";
	
									$(".lmPreview").prepend(letterNameSpan);
									$(".preViewLetterName").css({
										"padding" : "3px 10px",
										"color" : "white",
										"background" : "rgba(0,0,0,0.5)",
										"position" : "absolute",
										"right" : "5px",
										"top" : "5px",
										"font-size" : "14px"
									});
								}
							});
	
			// 미리보기창에 마우스 올렸을떄 편지지 이름 없애기
			$(document).on("mouseleave", ".lmPreview", function() {
				$(".lmPreview .preViewLetterName").remove();
			});
		</script>
	</body>
</html>
