var pageNum = 1; // 페이지 ==> 초기값 설정
var pCurPage = ""; // 현재페이지 ==> 초기값 설정
var blockSize = 10; // 화면에 보여질 블록갯수
var totalPage = 34; // 게시판의 총 페이지갯수
var listSize = 10; // 게시판에 보여질 게시물갯수

//attitude 페이징 중복 함수
function makePageSelPageAtti(){
	var pagingHtml = "";
	
	pagingHtml = "<div class='pagenavi'>";
	if (totalPage > 1 && pageNum != 1) {
		pagingHtml += "<span class='btnimg' onclick='return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
	} else {
		pagingHtml += "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'/></span>";
	}
	
	if (pageNum / (blockSize + 1) >= 1) {
		pagingHtml += "<span class='btnimg' onclick=''><img src='/images/sub/btn_prev.gif' width='16' height='16'/></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>이전</span>";
	} else {
		pagingHtml += "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'/></span><span class='ptxt' onclick= 'return selbeforeBlock_one()'>이전</span>";
	}
	
	document.getElementById("tblPageRayer").innerHTML = pagingHtml;
}