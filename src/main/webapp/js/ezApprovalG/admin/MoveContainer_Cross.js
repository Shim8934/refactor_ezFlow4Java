function getDocType(Flag) {
    try {
        var xmlRtn = createXmlDom();
        var Cnt, Cnt2, oOption
        var index, i, j;
        var contID = new Array();
        var name = new Array();
        var deptID = "";

        if (Flag == "SDeptName") {
        	deptID = document.getElementsByName('SDeptName')[0].id;
        } else {			// 2018-06-20. 황윤호 	관리자 > 전자결재 > 문서이동 변수 변경 TDeptName => drafetdept
        	deptID = document.getElementsByName('drafterdept')[0].id;
        }

        var result = "";
    	
    	$.ajax({
    		type : "POST",
    		dataType : "text",
    		async : false,
    		url : "/admin/ezApprovalG/apprGMgetContInfo.do",
    		data : {
    			deptID     : deptID,
    			comID  : pSourceCompanyID
    		},
    		success: function(text){
    			result = text;
    		},
    		error : function() {
    			result = "<LISTVIEWDATA><HEADERS><HEADERS><ROWS></ROWS></LISTVIEWDATA>";
    		}
    	});

        xmlRtn = loadXMLString(result);
        
        if (Flag == "SDeptName") {
            index = document.getElementsByName('selSContName')[0].length;

            if (index > 0) {
                for (i = index ; i > 0 ; i--)
                    document.getElementsByName('selSContName')[0].remove(i - 1);
            }
            
            for (Cnt = 0 ; Cnt < xmlRtn.getElementsByTagName("DATA1").length; Cnt++) {
                var nodevalue = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
                    contID[Cnt] = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                    name[Cnt] = xmlRtn.getElementsByTagName("DATA3")[Cnt].childNodes[0].nodeValue;
                    Add_ContType1(name[Cnt], contID[Cnt]);
                }        
            }            
        }
        else {
        	// 2018-06-20. 황윤호 	관리자 > 전자결재 > 문서이동  (drafterdept의 경우 문서함명을 사용 안하고 있음)
            /*index = document.getElementsByName('selTContName')[0].length;

            if (index > 0) {
                for (i = index ; i > 0 ; i--)
                    document.getElementsByName('selTContName')[0].remove(i - 1);
            }
            
            for (Cnt = 0 ; Cnt < xmlRtn.getElementsByTagName("DATA1").length; Cnt++) {
            	var nodevalue = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                if (nodevalue != null && nodevalue != "" && nodevalue && "undefine") {
                    contID[Cnt] = xmlRtn.getElementsByTagName("DATA1")[Cnt].childNodes[0].nodeValue;
                    name[Cnt] = xmlRtn.getElementsByTagName("DATA3")[Cnt].childNodes[0].nodeValue;
                    Add_ContType2(name[Cnt], contID[Cnt]);
                }
            }*/            
        }
    } catch (e) { alert("MoveContainer.js :: getDocType()"); }
}

function Add_ContType1(Name, ID) {
    var oOption = document.createElement("OPTION");
    setNodeText(oOption, Name);
    oOption.value = ID

    var sOption = document.getElementsByName("selSContName")[0];

    if (CrossYN())
        sOption.add(oOption, null);
    else
        sOption.add(oOption);

    oOption = null;
}

function Add_ContType2(Name, ID) {
    var oOption = document.createElement("OPTION");
    setNodeText(oOption, Name);
    oOption.value = ID

    var sOption = document.getElementsByName("selTContName")[0];
    if (CrossYN())
        sOption.add(oOption, null);
    else
        sOption.add(oOption);

    oOption = null;
}

function getDocList() {
    if (CrossYN())
        document.getElementById("PageNum").innerHTML = "";
    else
        setNodeText(document.getElementById("PageNum"),"");
    document.getElementById('lvSDoc').innerHTML = "";
    document.getElementById('lvTDoc').innerHTML = "";

    if (pChackYN == "FALSE") {
        for (i = 0; i < 11; i++)
            SearchCond[i] = "";

        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }
    else if (pChackYN == "SEARCH") {
        curpage = 1;
        nowblock = 0;
        totalPage = 0;
    }

	var result = "";

	$.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApprovalG/getDocList.do",
		data : {
			contID     : ScontID,
			pageNum    : nowblock + 1,
			pageSize   : PageSize,
			companyID  : P_CompanyID,
			docNO      : SearchCond[0],
			docTitle   : SearchCond[1],
			drafter    : SearchCond[2],
			draftFrom  : SearchCond[3],
			draftTo    : SearchCond[4],
			aprFrom    : SearchCond[5],
			aprTo      : SearchCond[6],
			formID     : SearchCond[7],
			deptName   : SearchCond[9]
		},
		success: function(text){
			result = text;
		}
	});
	
    Resultxml = loadXMLString(result);

    if (Resultxml.xml != "") {
        ListView = SelectSingleNodeNew(Resultxml, "DOCLIST/LISTVIEWDATA");
        NodeList = SelectNodes(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW");
        CellList = SelectNodes(Resultxml, "DOCLIST/LISTVIEWDATA/ROWS/ROW/CELL");
        NodeList2 = SelectNodes(Resultxml, "DOCLIST/TOTALCNT");
        Haders = SelectNodes(Resultxml, "DOCLIST/LISTVIEWDATA/HEADERS/HEADER");
        NodeListLen = 0;

        if (NodeList2 != null) {
            if (SelectSingleNodeValueNew(Resultxml, "DOCLIST/TOTALCNT") != "") {
                NodeListLen = SelectSingleNodeValueNew(Resultxml, "DOCLIST/TOTALCNT");
            }
            else
                NodeListLen = 0;

        }
        xmlpara = reBuildXml();
        if (NodeListLen > 10) {        	
            paging(curpage, nowblock);
            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview2.DataBind("lvTDoc");
        }
        else {
            listview.DataSource(xmlpara);
            if (NodeListLen == 0)
                listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview.DataBind("lvSDoc");
            listview2.DataBind("lvTDoc");
            pagingCount(curpage, nowblock);
        }
    }
    else {
        if (listview.GetRowCount() > 0) {
            document.getElementById('lvSDoc').innerHTML = "";
            document.getElementById('lvTDoc').innerHTML = "";
            listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
            listview.DataBind("lvTDoc");
            listview2.DataBind("lvTDoc");
        }
    }
    pChackYN = "FALSE"
}


function DocMove() {
    var pparsingXML = "";
    var xmlRtn = createXmlDom();
    var selRow = listview.GetSelectedRows();
    var count1;
    var length;
    var objTr;
    var strXML = "";

    listview.LoadFromID("lvSDocForm");
    listview2.LoadFromID("lvTDocForm");

    var select = listview.GetSelectedIndexes();
    var length = listview.GetSelectedIndexes().split(",").length;
    var length2 = listview2.GetRowCount();

    if (select.length <= 0)
        alert(strLang801);
    else {
        lvTDocResize();

        if (length2 > 0)
            if (getNodeText(listview2.GetDataRows()[0].cells[0]) == strLang944)
                listview2.DeleteRow(GetAttribute(listview2.GetDataRows()[0], "id"));

        for (count1 = 0; count1 < length; count1++) {
            var length2 = listview2.GetRowCount();
            var DocID = GetAttribute(selRow[count1], "DATA1");
            var DocName = getNodeText(selRow[count1].cells[1]);
            var DocNum = getNodeText(selRow[count1].cells[0]);

            if (!listview2.ExistRow("DATA1", DocID)) {
                strXML = listAdd(DocNum, DocName, DocID)
                objTr = listview2.AddRow(length2);
                SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + length2);
                xmlRtn = loadXMLString(strXML);
                listview2.AddDataRow(objTr, xmlRtn);
            }
        }

    }
}

function listAdd(pDocNum, pDocName, pDocID) {
    pparsingXML = "<LISTVIEWDATA><HEADERS>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + text1 + "</NAME><WIDTH>150</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "<HEADER><NAME>" + text2 + "</NAME><WIDTH>300</WIDTH></HEADER>";
    pparsingXML = pparsingXML + "</HEADERS><ROWS><ROW><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDocNum) + "</VALUE>";
    pparsingXML = pparsingXML + "<STYLE>" + "overflow : hidden; white-space : nowrap; text-overflow : ellipsis;" + "</STYLE>";
    pparsingXML = pparsingXML + "<DATA1>" + pDocID + "</DATA1>";
    pparsingXML = pparsingXML + "</CELL><CELL>";
    pparsingXML = pparsingXML + "<VALUE>" + MakeXMLString(pDocName) + "</VALUE>";
    pparsingXML = pparsingXML + "<STYLE>" + "overflow : hidden; white-space : nowrap; text-overflow : ellipsis;" + "</STYLE>";
    pparsingXML = pparsingXML + "</CELL></ROW>";

    pparsingXML = pparsingXML + "</ROWS></LISTVIEWDATA>";

    return pparsingXML;
}
function MakeXMLString(pOrgString) {
    return ReplaceText(ReplaceText(ReplaceText(pOrgString, "&", "&amp;"), "<", "&lt;"), ">", "&gt;");
}
function ReplaceText(orgStr, findStr, replaceStr) {
    try {
        if (findStr == ".") {
            var a = 0;
            for (a = 0; a < 10; a++)
                orgStr = orgStr.replace(".", replaceStr);
            return orgStr;
        }
        else {
            var re = new RegExp(findStr, "gi");
            return (orgStr.replace(re, replaceStr));
        }
    } catch (e) {
        return orgStr
    }
}

function DocMoveParser() {
    listview2.LoadFromID("lvTDocForm");
    var x_ORGCONTID;
    var count1;
    var length;
    length = listview2.GetRowCount();
    var xmlRtn = createXmlDom();
    var xmlpara = createXmlDom();
    var objNode;
    createNodeInsert(xmlpara, objNode, "PARAMETER");
    createNodeAndInsertText(xmlpara, objNode, "ORGCONTID", document.getElementsByName("selSContName")[0].value);
    createNodeAndInsertText(xmlpara, objNode, "CONTID", document.getElementsByName("selTContName")[0].value);
    if (MoveALL.checked == true)
        createNodeAndInsertText(xmlpara, objNode, "MoveALL", "true");
    else
        createNodeAndInsertText(xmlpara, objNode, "MoveALL", "");

    for (count1 = 0; count1 < length; count1++) {
        createNodeAndInsertText(xmlpara, objNode, "DOCID", GetAttribute(listview2.GetDataRows()[count1], "DATA1"));
    }

    return xmlpara;
}

//function ContMove() {
//    Check = true;
//    listview2.LoadFromID("lvTDocForm");
//    var length2 = listview2.GetRowCount();
//    var count1, selRow;
//
//    var xmlpara = createXmlDom();
//    var xmlRtn = createXmlDom();
//    var strXML = DocMoveParser();
//
//    xmlpara = strXML;
//    xmlhttp.open("POST", "/admin/ezApprovalG/moveContainer.do", false);
//    xmlhttp.send(xmlpara);
//
//    xmlRtn = createXMLDomFromXmlString(xmlhttp.responseText);
//    Flag = xmlRtn.getElementsByTagName("RESULT")[0].childNodes[0].nodeValue;
//    
//    if (xmlhttp != null && xmlhttp.readyState == 4) {
//		if (xmlhttp.status == 200 && Flag == "TRUE") {
//			alert(strLang818);
//	        lvTDoc.DataSource = FORMLIST;
//		} else {
//			alert(strLang803);
//		}
//	} else {
//		alert(strLang803);
//	}
//
//    Check = false;
//}

function DocTotal() {
    listview.LoadFromID("lvSDocForm");
    listview2.LoadFromID("lvTDocForm");
    var count1;
    var length, length2;
    var strXML = "";
    var objTr;
    var pparsingXML = "";
    var xmlRtn = createXmlDom();

    length = listview.GetRowCount();
    length2 = listview2.GetRowCount();

    var rows = listview.GetDataRows();
    if (length <= 0) {
        alert(strLang804);
    }
    else {
        if (length2 > 0) {
            for (count1 = length2 - 1 ; count1 > -1 ; count1--) {
                listview2.DeleteRow(GetAttribute(listview2.GetDataRows()[count1], "id"));
            }
            for (count1 = 0; count1 < length; count1++) {
                var DocID = GetAttribute(rows[count1], "DATA1");
                var DocName = getNodeText(rows[count1].cells[1]);
                var DocNum = getNodeText(rows[count1].cells[0]);

                strXML = listAdd(DocNum, DocName, DocID)

                objTr = listview2.AddRow(count1);
                SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + count1);
                xmlRtn = loadXMLString(strXML);
                listview2.AddDataRow(objTr, xmlRtn);
            }
        }
        else {
            for (count1 = 0; count1 < length; count1++) {
                var DocID = GetAttribute(rows[count1], "DATA1");
                var DocName = getNodeText(rows[count1].cells[1]);
                var DocNum = getNodeText(rows[count1].cells[0]);

                strXML = listAdd(DocNum, DocName, DocID)

                objTr = listview2.AddRow(count1);
                SetAttribute(objTr, "id", "lvTDocForm" + "_TR_" + count1);
                xmlRtn = loadXMLString(strXML);
                listview2.AddDataRow(objTr, xmlRtn);
            }
        }
    }
}

function reBuildXml() {
    var xmlpara = createXmlDom();
    var objNode, objRoot, subNode, CellNode, RowsHeader, RowHeader, headerNode;
    objNode = createNodeInsert(xmlpara, objRoot, "LISTVIEWDATA");
    var headersNode = createNodeAndAppandNode(xmlpara, objNode, subNode, "HEADERS");

    for (h = 0; h <= Haders.length - 1; h++) {
        headerNode = createNodeAndAppandNode(xmlpara, headersNode, subNode, "HEADER");

        createNodeAndAppandNodeText(xmlpara, headerNode, subNode, "NAME", SelectSingleNodeValue(Haders[h], "NAME"));
        createNodeAndAppandNodeText(xmlpara, headerNode, subNode, "WIDTH", SelectSingleNodeValue(Haders[h], "WIDTH"));
    }

    RowsHeader = createNodeAndAppandNode(xmlpara, objNode, subNode, "ROWS");

    for (i = 1; i <= NodeListLen; i++) {
        RowHeader = createNodeAndAppandNode(xmlpara, RowsHeader, subNode, "ROW");
        CellNode = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "VALUE", SelectSingleNodeValue(SelectSingleNode(NodeList[i - 1], "CELL"), "VALUE"));
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA1", SelectSingleNodeValue(SelectSingleNode(NodeList[i - 1], "CELL"), "DATA1"));
        createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA2", SelectSingleNodeValue(SelectSingleNode(NodeList[i - 1], "CELL"), "DATA2"));

        if (!CrossYN()) {
            var count = 3;
            for (k = 7; k < NodeList[i - 1].childNodes[1].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[1].childNodes[k].childNodes.length > 0)
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + count, NodeList[i - 1].childNodes[1].childNodes[k].childNodes[0].nodeValue);
                else
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + count, "");

                k++;
                count++;
            }
        }
        else {
            for (k = 3; k < NodeList[i - 1].childNodes[0].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[0].childNodes[k].childNodes.length > 0)
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + k, NodeList[i - 1].childNodes[0].childNodes[k].childNodes[0].nodeValue);
                else
                    createNodeAndAppandNodeText(xmlpara, CellNode, subNode, "DATA" + k, "");
            }
        }

        var CellNodeSub = new Array();

        if (!CrossYN()) {  	
            for (k = 3; k < NodeList[i - 1].childNodes.length; k++) {	
                if (NodeList[i - 1].childNodes[k].childNodes[1].childNodes.length > 0) {

                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    var a = SelectSingleNode(NodeList[i - 1], "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", NodeList[i - 1].childNodes[k].childNodes[1].childNodes[0].nodeValue);
                }
                else {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", "");
                }
                k++;
            }
        }
        else {
            for (k = 1; k < NodeList[i - 1].childNodes.length; k++) {
                if (NodeList[i - 1].childNodes[k].childNodes[0].childNodes.length > 0) {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    var a = SelectSingleNode(NodeList[i - 1], "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", NodeList[i - 1].childNodes[k].childNodes[0].childNodes[0].nodeValue);
                }
                else {
                    CellNodeSub[k] = createNodeAndAppandNode(xmlpara, RowHeader, subNode, "CELL");
                    createNodeAndAppandNodeText(xmlpara, CellNodeSub[k], subNode, "VALUE", "");
                }
            }
        }
    }
    return xmlpara;
}

////2018-03-13 김은석 추가
function getDocListjson(pageNum) {
	//2018-10-16 김보미 - 프로그레스바
	ShowMailProgress();
	
	var docnumber = $("#DocNumber").val();
	var doctitle = $("#DocTitle").val();
	var drafter = $("#drafter").val();
	var drafterdept = document.getElementsByName("drafterdept")[0].id;
	console.log("drafterdept :: "+drafterdept);
	if (!$("#usedate").prop("checked")) {
		searchStartTime = "";
		searchEndTime = "";
	} else {
		searchStartTime = $('#startDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
		searchEndTime = $('#endDatepicker').datepicker({dateFormat : 'yyyymmdd'}).val();
	}
	var pURL = "/admin/ezApprovalG/getDocListjson.do";
		
	if (ScontID != null && ScontID !="") {
		
			$.ajax({
				url : pURL,
				type : "POST",
				async : false,
				dataType : 'json',
				data : {
					contID     : ScontID,
					pageNum    : pageNum,
					companyID  : pSourceCompanyID, // 실제로 선택한 보낼부서의 회사ID
					docNO  	   : docnumber,//문서번호
					docTitle   : doctitle,//문서제목
					drafter    : drafter,//기안자
					aprFrom    : searchStartTime,//완료일자
					aprTo      : searchEndTime,//완료일자
					drafterdept   : drafterdept,//기안부서
					pSelectTab : pSelectTab//탭구분	
				},
				success : function(res) {
					
					var html = "";
					if (res.totalcnt < 1) {
						//html += "<tr><td colspan='11' style='text-align:center;'>"+text1+"</td></tr>";
						html += "<tr><td colspan='10' style='text-align:center;'>"+text1+"</td></tr>";
					} else {
			
							res.DocDeleteHistList.forEach(function(i, v) {
								html += "<tr class='row_body' onclick='select_row(this)' ondblclick='openDoc(this)' docid='docID_" + i.docID + "' id='" + i.docID + "' writerName='" + i.writerName + "' " 
									 + "DocTitle='" + i.docTitle + "' DocNo='" + i.docNo + "' DeptName='" + i.writerDeptName + "' style='cursor: pointer; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;'"
									 + "formid='"+i.formID+"' dochref='"+i.href+"' orgdocid='"+i.orgDocID+"' >";
								html += "   <td><div class='custom_checkbox'><input type ='checkbox' name='myCheckbox' id='" + i.docID + "' onclick='chk_onselect(this)' writerName='" 
									 + i.writerName + "' DocTitle='" + i.docTitle + "' DocNo='" + i.docNo + "' DeptName='" + i.writerDeptName + "'></div></td>";
								html += "	<td title=\'" + i.docNo + "'>"	+ i.docNo	+ "</td>";
								if (i.hasAttachYn != "N") {
									html += '<td><img src="\/images\/newAttach.gif"></td>';
								} else {
									html += "<td>"  +   		 " "   	 				+ "</td>";
								}
								html += "	<td>"	+ i.docTitle						+ "</td>";
								html += "	<td>"	+ i.formName						+ "</td>";
								html += "	<td>"	+ i.writerDeptName					+ "</td>";
								html += "	<td>"	+ i.writerName						+ "</td>";
								html += "	<td>"	+ i.docstateName					+ "</td>";
								//html += "	<td>"	+ i.sendFlag						+ "</td>";
								html += "	<td>"	+ i.endDate					        + "</td>";
								html += "	<td>"	+ i.isPublic						+ "</td>";
								html += "</tr>";
							});
					}
				
						$('#DocCompleteListBody').empty().append(html);
					
					
					CurPage = res.currPage;
					totalPage = res.totalPage;
					totalCount = res.totalcnt;
					if(totalCount === 0 && totalPage === 0) {
						totalPage = 1;
					}					
					searchStartTime = res.startdate;
					searchEndTime = res.endDate;
					
				},
				error : function(err) {
					//alert(err);
				},
				complete: function() {
			        //2018-10-16 김보미 - 프로그레스바
			        endTime = new Date();//프로그래스바 종료시간
					var timeDiff = endTime - startTime;
					timeDiff /= 1000;
					var seconds = (timeDiff % 60).toFixed(1);
					
					if (seconds <= 0.3) { //0.3초보다 적으면
						seconds = 300 - (timeDiff * 1000);
						setTimeout(function() {
							HiddenMailProgress();
						}, seconds);
					} else {
				        HiddenMailProgress();
					}
				}
			});
		makePageSelPage();
		} else {
			alert(text2);
			HiddenMailProgress();				// 2019-01-02 김민성 - 검색결과 없을시 프로그레스바 계속 나타나는 현상 수정
		}
}


function makePageSelPage() {
	var strtext;
	var PagingHTML = "";
	$("#tblpageRayer").html("");
	$("#listInfo").html(" &nbsp;[<spring:message code='main.t252'/><span class='txt_color'> "
			+ totalCount + " </span><spring:message code='ezSystem.kyj2'/>]")
	strtext = "<div class='pagenavi'>";
	PagingHTML += strtext;
	var pageNum = CurPage;

	if (totalPage > 1 && pageNum != 1) {
		strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg first disabled'></span>"
		PagingHTML += strtext;
	}

	if (totalPage > BlockSize) {
		if (pageNum > BlockSize) {
			strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span class='btnimg prev disabled'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "<span class='btnimg prev disabled'></span>";
		PagingHTML += strtext;
	}

	var MaxNum;
	var i;
	var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;

	if (totalPage >= (startNum + parseInt(BlockSize))) {
		MaxNum = (startNum + parseInt(BlockSize)) - 1;
	} else {
		MaxNum = totalPage;
	}

	for (i = startNum; i <= MaxNum; i++) {
		if (i == pageNum) {
			strtext = "<span class='on'>" + i + "</span>";
			PagingHTML += strtext;
		} else {
			strtext = "<span onclick='goToPageByNum(" + i + ")'>"
					+ i + "</span>";
			PagingHTML += strtext;
		}
	}

	if (totalPage > BlockSize) {
		if (totalPage >= parseInt(((parseInt((pageNum - 1)
				/ BlockSize) + 1) * BlockSize) + 1)) {
			strtext = "";
			strtext = strtext
					+ "<span class='btnimg next' onclick='return selafterBlock()'></span>";
			PagingHTML += strtext;
		} else {
			strtext = "";
			strtext = strtext
					+ "<span class='btnimg next disabled'></span>";
			PagingHTML += strtext;
		}
	} else {
		strtext = "";
		strtext = strtext
				+ "<span class='btnimg next disabled'></span>";
		PagingHTML += strtext;
	}

	if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		strtext = "<span class='btnimg last' onclick='return goToPageByNum("
				+ totalPage
				+ ")'></span>";
		PagingHTML += strtext;
	} else {
		strtext = "<span class='btnimg last disabled'></span>";
		PagingHTML += strtext;
	}

	PagingHTML += "</div>";
	td_Create1(PagingHTML);
}

function ContMove() {
 
	var selSContName = $("select[name=selSContName]").val();
	var selTContName = popupselTContName;
   
    $.ajax({
		type : "POST",
		dataType : "text",
		async : false,
		url : "/admin/ezApprovalG/moveContainer.do",
		data : {
			strMoveListIDInfo : strMoveListIDInfo,
			SourceContID      : selSContName,
			TargetContID  	  : selTContName,
			chkAll			  : check,
			SourceCompanyID : pSourceCompanyID
		},
		success: function(text){
			result = text;
		},
		error : function() {
			
		}
	});

    Check = false;
    popupselTContName = "";
}

function changeCompID() {				
    if (P_CompanyID != document.getElementById("ListCompany").value) {
        P_CompanyID = document.getElementById("ListCompany").value;

        lvSDoc.DataSource = FORMLIST;
        lvTDoc.DataSource = FORMLIST;

		document.getElementsByName('SDeptName')[0].value = "";
		document.getElementsByName("TDeptName")[0].value = "";
		
		document.getElementById('lvSDoc').innerHTML = "";
        document.getElementById('lvTDoc').innerHTML = "";
        
        listview.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));                           
        listview.DataBind("lvSDoc");
        listview2.DataSource(loadXMLString(document.getElementById("FORMLIST").innerHTML.toUpperCase()));
        listview2.DataBind("lvTDoc");
        
        document.getElementsByName("selSContName")[0].innerHTML = "";
        document.getElementsByName("selTContName")[0].innerHTML = "";
        
        document.getElementsByName("MoveALL")[0].querySelector('input').checked = false;
        document.getElementById("PageNum").innerHTML = "";
    }
}

