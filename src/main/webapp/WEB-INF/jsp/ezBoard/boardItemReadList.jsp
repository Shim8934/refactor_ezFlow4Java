<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezBoard.t320'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<!-- 페이징 -->
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/lang/ezBoardSTD.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
		<script type="text/javascript">
		    var ReturnFunction;
		    //2018-02-06 김보미 - 페이징
		    var CurPage = "";
		    var pBoardID = "<c:out value='${boardID}'/>";
		    var itemID = "<c:out value='${itemID}'/>";
		    var perCount = 10;
		    
		    window.onload = function () {
		    	try {
		            getBoardList();
		            ReturnFunction = parent.item_readlist_cross_dialogArguments[1];
		        } catch (e) {
		        	
		        }
		    };
		    /* 2018-07-02 홍승비 - 조회자정보 클릭 시 겸직부서(겸직인 경우)로 사원정보 표출 */
		    function show_info(userID, deptID) {
		        var heigth = window.screen.availHeight;
		        var width = window.screen.availWidth;
		        var left = (width - 500) / 2;
		        var top = (heigth - 400) / 2;
		        window.open("/ezCommon/showPersonInfo.do?id=" + userID + "&dept=" + deptID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
		    }
		    function close_onclick() {
		        if (ReturnFunction != null)
		            ReturnFunction();
		        else
		            window.close();
		    }
		    //2018-02-05 김보미 - 페이징
		    var xmlhttp = createXMLHttpRequest();
		    function getBoardList() {
		        if (CurPage == "") {
		            CurPage = 1;
		        }
		        $.ajax({
					type : "POST",
					dataType : "text",
					async : true,
					url : "/ezBoard/itemReadPagingList.do",
					data : { 
							 boardID 	 : pBoardID,
							 itemID		 : itemID,
							 pageNum 	 : CurPage,
							 perCount	 : perCount
							},
					success: function(xml){
						getBoardList_after(loadXMLString(xml));
					}        			
				});	
		    }
		    var firstFlag = false;
		    function getBoardList_after(xml) {
		        try {
		            var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
		            var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
		            var pagenode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
		            var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
		
		            if (listNode == null) return;
          
		            var lstCnt = getNodeText(cntNode);//TOTALCNT
		            
		            if (lstCnt != 0) {		            
			            var pageCnt = getNodeText(pagenode);//PAGECNT
			            var perCnt = getNodeText(perNode);//PERSONALCNT
			            
			            totalPage = pageCnt;
			            
			            makePageSelPageReader();
			            var xmlDoc;
			            if (CrossYN()) {
			                var xmlLIST = createXmlDom();
			                var nodeToImport = xmlLIST.importNode(listNode, true);
			                xmlLIST.appendChild(nodeToImport);
			
			                xmlDoc = loadXMLString(GetSerializeXml(xmlLIST));
			            }
			            else {
			                xmlDoc = createXmlDom();
			                xmlDoc.appendChild(listNode);
			            }
			            if (document.getElementById("lvBoardList").innerHTML != "")
			                document.getElementById("lvBoardList").innerHTML = "";
			            
			            var DocList = new ListView();
			            DocList.SetID("lvBoardList");
			            DocList.SetMulSelectable(false);
			            DocList.SetTitleIdx(0);
			            DocList.SetSelectFlag(false);
			            DocList.DataSource(xmlDoc);
			            DocList.RowDataBind();
			            DocList = null;
			            
			            //td 너비 조정
			            var listTbl = document.getElementById("lvBoardList");
			            var listTd = listTbl.getElementsByTagName("td");
			            for(var i = 0; i < listTd.length; i++){
			            	if((i%4) == 0){
			            		listTd[i].style.width = "130px";
			            		listTd[i].style.textAlign = "center";
			            		listTd[i].style.cursor = "pointer";
			            	}
			            	if((i%4) == 1) {
			            		listTd[i].style.width = "120px";
			            		listTd[i].style.textAlign = "center";
			            		listTd[i].style.cursor = "pointer";
			            		listTd[i].innerHTML = listTd[i].textContent.split("(")[0];
			            	}
			            	if((i%4) == 2) {
			            		listTd[i].style.width = "80px";
			            		listTd[i].style.textAlign = "center";
			            		listTd[i].style.cursor = "pointer";
			            	}
			            	if((i%4) == 3){
			            		listTd[i].style.width = "150px";
			            		listTd[i].style.textAlign = "center";
			            		listTd[i].style.cursor = "pointer";
			            	}
			            }		            
			          
				        $("#lvBoardList tr").on("click", function () {
				        	// 이부분에서 userID 가져오고 있음.
				        	userID = $(this).closest("tr").attr("userid");
				        	deptID = $(this).closest("tr").attr("deptid");
				        	show_info(userID, deptID);
				        });
			            
			            $("#lvBoardList tbody tr:odd td").css("background-color", "#f8f8fa");
		            } else {
		            	var msg = "<spring:message code='ezBoard.kbm01'/>";
		            	var htmlContent = "<tr><td style='text-align:center'>" + msg +"</td></tr>";
		            	$("#lvBoardList").html(htmlContent);
		            	
		            	$("#lvBoardList").css("height", "305px");
		            }
		        }
		        catch (e) {
		            alert("getBoardList_after : " + e.description);
		        }
		    }
		    var BlockSize = 10;
		    function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPageReader();
		        movePage(CurPage);
		    }
		    function selbeforeBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selbeforeBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    function selafterBlock() {
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    function selafterBlock_one() {
		        var pageNum = parseInt(CurPage);
		        if (parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		    function movePage(newPage) {
		        if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		    function prevPage_onclick() {
		        newPage = parseInt(CurPage) - 1;
		        if (newPage > 0) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		    function nextPage_onclick() {
		        newPage = parseInt(CurPage) + 1;
		        if (newPage <= parseInt(totalPage)) {
		            CurPage = newPage;
		            getBoardList();
		        }
		    }
		    function SortPage(strHeaderName) {
		        if (strHeaderName != "CHECK") {
		            if (OrderCell == strHeaderName) {
		                if (OrderOption == "")
		                    OrderOption = "DESC";
		                else
		                    OrderOption = "";
		            }
		            else {
		                OrderCell = strHeaderName;
		                OrderOption = "";
		            }
		            getBoardList();
		        }
		    }
		  //board 페이징 중복 함수
		    function makePageSelPageReader() {
		    	var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        if (totalPage > 1 && pageNum != 1) {
		            strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>"
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg first disabled'></span>"
		            PagingHTML += strtext;
		        }
		        if (totalPage > BlockSize) {
		            if (pageNum > BlockSize) {
		                strtext = "<span class='btnimg prev' onclick= 'return selbeforeBlock()'></span>";
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
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if (totalPage >= (startNum + parseInt(BlockSize))) {
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        }
		        else {
		            MaxNum = totalPage;
		        }
		        for (i = startNum; i <= MaxNum; i++) {
		            if (i == pageNum) {
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		            else {
		                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if (totalPage > BlockSize) {
		            if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
		                strtext = "";
		                strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
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
		        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
		            strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
		            PagingHTML += strtext;
		        }
		        else {
		            strtext = "<span class='btnimg last disabled'></span>";
		            PagingHTML += strtext;
		        }
		        
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		</script>
	</head>
	<body class="popup">
		<form method="post" >
		  <h1><spring:message code='ezBoard.t320'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="close_onclick()"><span></span></li>
		    </ul>
		  </div>
		  <!-- 2018-02-05 김보미 - 페이징 -->
<%-- 		  <h2><spring:message code='ezBoard.t356'/></h2> --%>
		        <div style="width:100%; height:305px" id="divList">
		            <table id="lvBoardList" class="popuplist" style="width:100%"></table>
		        </div>
		        <div id='runtime' style="color:#666;padding-top:5px"></div>
		        <div id="tblPageRayer" style="text-align:center"></div>
<!-- 		  <div class="box" > -->
<!-- 		    <table style="width:100%" class="popuplist"> -->
<%-- 		    	<c:forEach var="list" items="${boardReadList}" varStatus="seq"> --%>
<!-- 		    		<tr> -->
<%-- 				        <td style="white-space:nowrap" id="readDate${seq.index}"></td> --%>
<%-- 				        <td style="cursor:pointer; white-space:nowrap" onClick="show_info('${list.userID}');"><b style="color:black"> ${list.userName} </b>( ${list.userID} )</td> --%>
<%-- 				        <td style="white-space:nowrap; color:#168501">${list.userDeptName}</td> --%>
<%-- 				        <td style="width:100%; white-space:nowrap; color:#737373"><c:out value="${list.userTitle}"/></td> --%>
<!-- 		    			<script type="text/javascript"> -->
<%--  		    				var seq = "${seq.index}"; --%>
<%--  		    				var readDate = GetLocalTime("${offset}", "${list.readDate}") --%>
<!--  		    				$("#readDate" + seq).html("[ " + readDate + " ]"); -->
<!-- 		    			</script> -->
<!-- 		      		</tr> -->
<%-- 		    	</c:forEach> --%>
<!-- 		    </table> -->
<!-- 		  </div> -->
		</form>
	</body>
</html>
