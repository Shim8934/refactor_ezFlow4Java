function UserDocCount() {
    curpage = 1;
    nowblock = 0;
    totalPage = 0;
    
    $.ajax({
    	type : "POST",
    	url : "/admin/ezApprovalG/getUserDocCount.do",
    	async : false,
    	data : {sYear : document.getElementById("SYear").value,
				sMonth : document.getElementById("SMonth").value,
				eYear : document.getElementById("EYear").value,
				eMonth : document.getElementById("EMonth").value,
				userFlag : pUserFlag,
				companyID : pCompanyID },
		success : function (result) {
			resultXML = loadXMLString(result);
			if (resultXML != "") {
		        StatistList = resultXML;
		        NodeList = SelectNodes(resultXML, "LISTVIEWDATA/ROWS/ROW");
		        Headers = SelectNodes(resultXML, "LISTVIEWDATA/HEADERS/HEADER");

		        NodeListLen = 0;

		        if (NodeList != null) {
		            NodeListLen = NodeList.length;
		        }

		        //if (NodeListLen > 15) {
		        //    //lvtlist.rows.dataSource = null;
		        //    paging(curpage, nowblock);
		        //}
		        //else {
		        //    document.getElementById("PageNum").innerHTML = "";
		            var listview = new ListView();
		            document.getElementById("lvSDoc").innerHTML = "";
		            listview.SetID("lvSDocForm");
		            listview.SetMulSelectable(false);
		            listview.DataSource(resultXML);
		            listview.DataBind("lvSDoc");
		        //}
		    }
		}
    });
}

function DeptDocCount(pMode) {
	currpage = 1;
	nowblock = 0;
	totalPage = 0;
	
	$.ajax({
		type : "POST",
		url : "/admin/ezApprovalG/getDeptTranSendDocCount.do",
		async : false,
		data : {sYear : document.getElementById("SYear").value,
				sMonth : document.getElementById("SMonth").value,
				eYear : document.getElementById("EYear").value,
				eMonth : document.getElementById("EMonth").value,
				pMode : pMode,
				companyID : pCompanyID },
		success : function (result) {
			resultXML = loadXMLString(result);
			StatistList = resultXML;
	        NodeList = SelectNodes(resultXML, "LISTVIEWDATA/ROWS/ROW");
	        Headers = SelectNodes(resultXML, "LISTVIEWDATA/HEADERS/HEADER");

	        NodeListLen = 0;

	        if (NodeList != null) {
	            NodeListLen = NodeList.length;
	        }

	        //if (NodeListLen > 15) {
	        //    lvtlist.rows.dataSource = null;
	        //    paging(curpage, nowblock);
	        //}
	        //else {
	        //    document.getElementById("PageNum").innerHTML = "";
	            var listview = new ListView();
	            document.getElementById("lvSDoc").innerHTML = "";
	            listview.SetID("lvSDocForm");
	            listview.SetMulSelectable(false);
	            listview.DataSource(resultXML);
	            listview.DataBind("lvSDoc");
	        //}
		}
	});
}

//function paging(p_page, p_nowblock) {
//    var h, j, x_NAME, x_WIDTH, x_HEADER, x_CELL2, x_VALUE2, count, x_CELL3, x_CELL4;

//    count = NodeList.item(0).childNodes.length;

//    var s_page = 15 * p_page - 14;
//    var e_page = 15 * p_page;

//    if (totalPage == p_page) {
//        if (NodeListLen % 15 != 0) {
//            e_page = s_page + (NodeListLen % 15) - 1;
//        }
//    }

//    var xmlpara = new ActiveXObject("Microsoft.XMLDOM");
//    var objRoot = xmlpara.createNode(1, "LISTVIEWDATA", "");
//    xmlpara.appendChild(objRoot);

//    var x_HEADERS = xmlpara.createElement("HEADERS")
//    objRoot.appendChild(x_HEADERS)

//    for (h = 0; h <= Haders.length - 1; h++) {
//        x_HEADER = xmlpara.createElement("HEADER");
//        x_HEADERS.appendChild(x_HEADER);

//        x_NAME = xmlpara.createElement("NAME");
//        x_HEADER.appendChild(x_NAME);
//        x_NAME.text = Haders.item(h).childNodes(0).childNodes(0).text;

//        x_WIDTH = xmlpara.createElement("WIDTH");
//        x_HEADER.appendChild(x_WIDTH);
//        x_WIDTH.text = Haders.item(h).childNodes(1).childNodes(0).text;
//    }

//    var x_ROWS = xmlpara.createNode(1, "ROWS", "");
//    objRoot.appendChild(x_ROWS);

//    for (i = s_page; i <= e_page; i++) {
//        var x_ROW = xmlpara.createNode(1, "ROW", "");
//        x_ROWS.appendChild(x_ROW);

//        var x_CELL = xmlpara.createElement("CELL")
//        x_ROW.appendChild(x_CELL)
//        var x_VALUE = xmlpara.createElement("VALUE")
//        x_CELL.appendChild(x_VALUE)
//        x_VALUE.text = NodeList.item(i - 1).childNodes(0).childNodes(0).text;

//        if (!condition[1].checked) {
//            var x_DATA1 = xmlpara.createElement("DATA1")
//            x_CELL.appendChild(x_DATA1)
//            x_DATA1.text = NodeList.item(i - 1).childNodes(0).childNodes(1).text;

//            var x_DATA2 = xmlpara.createElement("DATA2")
//            x_CELL.appendChild(x_DATA2)
//            x_DATA2.text = NodeList.item(i - 1).childNodes(0).childNodes(2).text;
//        }

//        var x_CELL2 = xmlpara.createElement("CELL");
//        x_ROW.appendChild(x_CELL2);
//        var x_VALUE2 = xmlpara.createElement("VALUE");
//        x_CELL2.appendChild(x_VALUE2);
//        x_VALUE2.text = NodeList.item(i - 1).childNodes(1).text;

//        var x_CELL3 = xmlpara.createElement("CELL")
//        x_ROW.appendChild(x_CELL3)
//        var x_VALUE3 = xmlpara.createElement("VALUE")
//        x_CELL3.appendChild(x_VALUE3)
//        x_VALUE3.text = NodeList.item(i - 1).childNodes(2).childNodes(0).text;

//        if (condition[0].checked == true) {
//            var x_CELL4 = xmlpara.createElement("CELL");
//            x_ROW.appendChild(x_CELL4);
//            var x_VALUE4 = xmlpara.createElement("VALUE");
//            x_CELL4.appendChild(x_VALUE4);
//            x_VALUE4.text = NodeList.item(i - 1).childNodes(3).text;
//        }
//    }
//    lvtlist.dataSource = xmlpara;
//    pagingCount(p_page, p_nowblock);
//}


//function pagingCount(p_page, p_nowblock) {
//    var td;

//    PageNum.innerText = "";

//    curpage = p_page;

//    nowblock = p_nowblock;

//    var Gopage;
//    var comNoPerPage = 15;

//    var nextPage, mychoice, prevPage, total_block;

//    totalPage = parseInt(NodeListLen / comNoPerPage);

//    var strtext = "";

//    if (((totalPage * comNoPerPage) != NodeListLen) && ((NodeListLen % comNoPerPage) != 0)) {
//        totalPage = totalPage + 1;
//    }

//    if (curpage < totalPage)
//        nextPage = parseInt(curpage) + 1;
//    else
//        nextPage = totalPage;

//    if (curpage > 1)
//        prevPage = parseInt(curpage) - 1;
//    else
//        prevPage = 1;

//    mychoice = 15;

//    total_block = parseInt(totalPage / mychoice);
//    if (totalPage % mychoice == 0)
//        total_block = total_block - 1;

//    if (totalPage > 1) {
//        if (nowblock > 0) {
//            strtext = "<div onclick= 'return paging(" + ((nowblock - 1) * mychoice + 1) + "," + (nowblock - 1) + ")' style='cursor:pointer'>";
//            strtext = strtext + "<img src='/images/page_previous.gif' width='14' height='10'  border='0'></div>";
//            td_Create(strtext);
//        }

//        if (curpage != 1 && NodeListLen != 0) {
//            if (((curpage - 1) % mychoice) == 0) {
//                block = nowblock - 1;
//            }
//            else {
//                block = nowblock;
//            }
//            strtext = "<div onclick= 'return paging(" + prevPage + "," + block + ")' style='cursor:pointer'>";
//            strtext = strtext + "<img src='/images/page_previous.gif' width='7' height='10'  border='0'></div>";
//            td_Create(strtext);
//        }

//        if (total_block != nowblock) {
//            for (Gopage = 1; Gopage <= mychoice; Gopage++) {
//                if (curpage != nowblock * mychoice + Gopage) {
//                    strtext = "<div onclick='return paging(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer' onmouseover='this.style.color=\"blue\"'  onmouseout='this.style.color=\"#333300\"'>";
//                    strtext = strtext + "[" + ((nowblock * mychoice) + Gopage) + "]</div>";
//                    td_Create(strtext);
//                }
//                else 
//                {
//                    strtext = "<font color='blue'> [" + ((nowblock * mychoice) + Gopage) + "] </font>";
//                    td_Create(strtext);
//                }
//            }
//        }
//        else {
//            for (Gopage = 1; Gopage <= totalPage - mychoice * nowblock; Gopage++) {
//                if (curpage != nowblock * mychoice + Gopage) {
//                    strtext = "<div onclick='return paging(" + ((nowblock * mychoice) + Gopage) + "," + nowblock + ")' style='cursor:pointer' onmouseover='this.style.color=\"blue\"'  onmouseout='this.style.color=\"#333300\"'>";
//                    strtext = strtext + "[" + ((nowblock * mychoice) + Gopage) + "]</div>";
//                    td_Create(strtext);
//                }
//                else
//                {
//                    strtext = "<font color='blue'> [" + ((nowblock * mychoice) + Gopage) + "] </font>";
//                    td_Create(strtext);
//                }
//            }
//        }

//        if ((curpage != totalPage) && (NodeListLen != 0)) {
//            if ((curpage % mychoice) == 0) {
//                block = (nowblock + 1);
//            }
//            else {
//                block = nowblock;
//            }

//            strtext = "<div onclick='return paging(" + nextPage + "," + block + ")' style='cursor:pointer' >";
//            strtext = strtext + "<img src='/images/page_next.gif' width='7' height='10' border='0'></div>";
//            td_Create(strtext);
//        }

//        if ((total_block > 0) && (nowblock < total_block)) {
//            strtext = "<div onclick='return paging(" + ((nowblock + 1) * mychoice + 1) + "," + (nowblock + 1) + ")' style='cursor:pointer'>";
//            strtext = strtext + "<img src='/images/page_next.gif' width='14' height='10' border='0'></div>";
//            td_Create(strtext);
//        }
//    }
//}f

//function td_Create(strtext) {
//    td = PageNum.insertCell();
//    td.width = "17px";
//    td.height = "17px";
//    td.align = "center";
//    td.valign = "center";
//    td.innerHTML = strtext;
//}
