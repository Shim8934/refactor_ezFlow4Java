	function makePageSelPage(){
        var strtext;
        var PagingHTML = "";
        document.getElementById("tblPageRayer").innerHTML = "";
        document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalRows + " </span>" + strLang42 + "]";
        strtext = "<div class='pagenavi'>";
        PagingHTML += strtext;
        var pageNum = currentPage;
        
        if (totalPages > 1 && pageNum != 1) {
            strtext = "<span class='btnimg' onClick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        
        if (totalPages > blockSize) {
            if (pageNum > blockSize) {
                strtext = "<span class='btnimg' onClick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
                PagingHTML += strtext;
            }
            else {
                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
                PagingHTML += strtext;
            }
        }
        else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
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
				strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i + "</span>";
                PagingHTML += strtext;
            }
        }
        
        if (totalPages > blockSize) {
        	if (totalPages >= parseInt(((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1)) {
        	    strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + strLang40 + "</span>";
        	    strtext = strtext + "<span class='btnimg' onClick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
                PagingHTML += strtext;
        	}
        	else {
                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
                PagingHTML += strtext;
        	}
        }
        else {
            strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + strLang40 + "</span>";
            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        
        if (totalPages > 1 && totalPages != 1 && (totalPages != pageNum)) {
            strtext = "<span class='btnimg' onClick='return goToPageByNum(" + totalPages + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        else {
            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
            PagingHTML += strtext;
        }
        
        PagingHTML += "</div>";
        td_Create1(PagingHTML);
    }
    
    function td_Create1(strtext) {
        document.getElementById("tblPageRayer").innerHTML = strtext;
    }
    
    function goToPageByNum(Value){
    	currentPage = Value;
        makePageSelPage();
        search_Set(currentPage);
    }
    
    function selbeforeBlock(){
        var pageNum = parseInt(currentPage);
        pageNum = ((parseInt(pageNum / blockSize) - 1) * blockSize) + 1;
        goToPageByNum(pageNum);
    }
    
    function selbeforeBlock_one(){
        var pageNum = parseInt(currentPage);
        if(parseInt(pageNum - 1) > 0)
            goToPageByNum(parseInt(pageNum - 1));
        else
            return;
    }
    
    function selafterBlock(){
        var pageNum = parseInt(currentPage);
        pageNum = ((parseInt((pageNum - 1) / blockSize) + 1) * blockSize) + 1;
        goToPageByNum(pageNum);
    }
    
    function selafterBlock_one(){
        var pageNum = parseInt(currentPage);
        if(parseInt(pageNum + 1) <= totalPages)
            goToPageByNum(parseInt(pageNum + 1));
        else
            return;
    }
    
    function getFileSize(fileSize) {
		var fileSize_ = "";
		
        if (fileSize / 1024 / 1024 > 1) {
        	fileSize_ = (Math.floor(parseFloat(fileSize / 1024 / 1024 * 10)) / 10).toFixed(1) + "MB";
        }
        else if (fileSize / 1024 > 1) {
        	fileSize_ = parseInt(fileSize / 1024) + "KB";
        }
        else {
        	fileSize_ = fileSize + "B";
        }		
        
        return fileSize_;
	}