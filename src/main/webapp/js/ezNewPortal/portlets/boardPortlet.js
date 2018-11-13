/**
 * 
 */

$(function() {
	$(".customBoard").find(".portletPlus").on("click", Boardmore_NewBoardSTD_btnClick);
});

function openDoc_section4_Type(pItemID, pType, oBoardID) {
    var pheight = window.screen.availHeight;
    var pwidth = window.screen.availWidth;
    var pTop = (pheight - 720) / 2;
    var pLeft = (pwidth - 765) / 2;

    /* 2018-09-19 홍승비 - 포탈 포틀릿에서 포토/썸네일게시물 보기 시 창 크기 수정 */
    if (pType == "3" || pType == "4") {
    if (navigator.userAgent.toLowerCase().indexOf("chrome") != -1) {
		var height = 789;
	} else {
		var height = 785;
	}
		pTop = (pheight - 789) / 2;
		pLeft = (pwidth - 764) / 2;

       window.open("/ezBoard/boardItemViewPhoto.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
   } else if (pType == "7") {
	   var height = 679;
	   pTop = (pheight - 679) / 2;
	   pLeft = (pwidth - 764) / 2;

      window.open("/ezBoard/boardItemViewMovie.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=" + height + ",width=764,top=" + pTop + ",left=" + pLeft, "");
   } else {
       if (CrossYN()) {
           window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
       } else {
           window.open("/ezBoard/boardItemView.do?showAdjacent=&itemID=" + pItemID + "&boardID=" + oBoardID, "", "toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,height=720,width=765,top=" + pTop + ",left=" + pLeft, "");
       }
   }
}

function Boardmore_NewBoardSTD_btnClick() {
	console.log(this);
	var boardId = $(this).attr("data1");
    window.open("/ezBoard/boardMainRedirect.do?boardID=" + boardId, "main", "");
}