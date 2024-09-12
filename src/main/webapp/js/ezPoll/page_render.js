	function makePageSelPage(currentPage, totalPages, totalQuestions, blockSize){
        var strtext;
        var PagingHTML = "";
        document.getElementById("tblPageRayer").innerHTML = "";
        document.getElementById("mailBoxInfo").innerHTML = "&nbsp;&nbsp;<span class='txt_color'>" + totalQuestions + "</span>";
        strtext = "<div class='pagenavi'>";
        PagingHTML += strtext;
        var pageNum = currentPage;
        
        if (totalPages > 1 && pageNum != 1) {
            strtext = "<span class='btnimg first' onClick= 'return goToPageByNum(1," + totalPages + "," + totalQuestions + "," + blockSize + ")'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg first disabled'></span>";
            PagingHTML += strtext;
        }
        
        if (totalPages > blockSize) {
            if (pageNum > blockSize) {
                strtext = "<span class='btnimg prev' onClick= 'return selbeforeBlock(" + currentPage + "," + totalPages + "," + totalQuestions + "," + blockSize + ")'></span>";
                PagingHTML += strtext;
            }
            else {
                strtext = "<span class='btnimg prev disabled'></span>";
                PagingHTML += strtext;
            }
        }
        else {
            strtext = "<span class='btnimg prev disabled'></span>";
            PagingHTML += strtext;
        }
        
        var MaxNum;
        var i;
        var startNum = (parseInt((pageNum - 1) / blockSize) * blockSize) + 1;
        
        if (totalPages >= (startNum + parseInt(blockSize))) {
            MaxNum = (startNum + parseInt(blockSize)) - 1;
        }
        else {
            MaxNum = totalPages;
        }
        
        for (i = startNum; i <= MaxNum; i++) {
            if (i == pageNum) {
                strtext = "<span class='on'>" + i + "</span>";
                PagingHTML += strtext;
            }
            else {
				strtext = "<span onClick='goToPageByNum(" + i + "," + totalPages + "," + totalQuestions + "," + blockSize + ")'>" + i + "</span>";
                PagingHTML += strtext;
            }
        }
        
        if (totalPages > blockSize) {
        	if (totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
        	    strtext = "";
        	    strtext = strtext + "<span class='btnimg next' onClick='return selafterBlock(" + currentPage + "," + totalPages + "," + totalQuestions + "," + blockSize + ")'></span>";
                PagingHTML += strtext;
        	}
        	else {
                strtext = "";
                strtext = strtext + "<span class='btnimg next disabled'></span>";
                PagingHTML += strtext;
        	}
        }
        else {
            strtext = "";
            strtext = strtext + "<span class='btnimg next disabled'></span>";
            PagingHTML += strtext;
        }
        
        if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
            strtext = "<span class='btnimg last' onClick='return goToPageByNum(" + totalPages + "," + totalPages + "," + totalQuestions + "," + blockSize + ")'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg last disabled'></span>";
            PagingHTML += strtext;
        }
        
        PagingHTML += "</div>";
        td_Create1(PagingHTML);
    }
    
    function td_Create1(strtext) {
        document.getElementById("tblPageRayer").innerHTML = strtext;
    }
    
    function selafterBlock_one(currentPage, totalPages, totalQuestions, blockSize) {
        var pageNum = parseInt(currentPage);
        
        if (parseInt(pageNum + 1) <= totalPages) {
            goToPageByNum(parseInt(pageNum + 1), totalPages, totalQuestions, blockSize);
        }
        else {
            return;
        }
    }
    
    function selbeforeBlock_one(currentPage, totalPages, totalQuestions, blockSize) {
        var pageNum = parseInt(currentPage);
        
        if (parseInt(pageNum - 1) > 0) {
            goToPageByNum(parseInt(pageNum - 1), totalPages, totalQuestions, blockSize);
        }
        else {
            return;
        }
    }
	
    function goToPageByNum(Value, totalPages, totalQuestions, blockSize) {    	
        makePageSelPage(Value, totalPages, totalQuestions, blockSize);
        search_Set(Value, totalPages);
    }
    
    function selbeforeBlock(currentPage, totalPages, totalQuestions, blockSize) {
        var pageNum = parseInt(currentPage);
        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
        goToPageByNum(pageNum, totalPages, totalQuestions, blockSize);
    }
    
    function selafterBlock(currentPage, totalPages, totalQuestions, blockSize) {
        var pageNum = parseInt(currentPage);
        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
        goToPageByNum(pageNum, totalPages, totalQuestions, blockSize);
    }
    
    function search_Set(pPage, totalPages) {
    	var g_BrdID = "6";
    	
		if (pPage != "" && pPage != "0" && parseInt(pPage) > 0 && parseInt(pPage) <= parseInt(totalPages)) {
			var szUrl = "";
			szUrl = "/ezPoll/pollList.do?brdID=" + g_BrdID + "&currPage=" + pPage;			
			window.location.href = szUrl;
		}
	}