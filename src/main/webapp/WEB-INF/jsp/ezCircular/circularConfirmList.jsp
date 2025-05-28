<!-- 2018-05-28 김민성 - 회람판 확인자 조회 -->

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title><spring:message code='ezCircular.kmsc01'/></title>
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
</head>
	<script type="text/javascript" src="${util.addVer('/js/ezCircular/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezBoard/ListView_list.js')}"></script>
	<script type="text/javascript" src="${util.addVer('ezCircular.e1', 'msg')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezCircular/circular.js')}"></script>
	<script type="text/javascript" src="${util.addVer('/js/ezCircular/PreviewItem.js')}"></script>
	
	<script>
	
		var CurPage = ""	;					// 현재 페이지			
		var circularID = "<c:out value='${circularID}'/>";	// 회람글 ID
	    var perCount = 10;					// 페이지당 확인자 수
	    var BlockSize = 10;					// 페이지 표시 갯수
	    var totalPage = "";					// 전체 페이지 수
    
		window.onload = function () {
	    	try {
	            getBoardList();
	        } catch (e) {
	        	
	        }
	    };
	
	 	function show_info(userid, deptid) {
	        var heigth = window.screen.availHeight;
	        var width = window.screen.availWidth;
	        var left = (width - 500) / 2;
	        var top = (heigth - 400) / 2;
	        window.open("/ezCommon/showPersonInfo.do?id=" + userid + "&dept=" + deptid, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	    }
	 	
	 	// 닫기 버튼 클릭 시
	    function close_onclick() {
	    	parent.DivPopUpHidden();
	    }
	    
	    function getBoardList() {
	        if (CurPage == "") {
	            CurPage = 1;
	        }
	        $.ajax({
				type : "POST",
				dataType : "text",
				async : true,
				url : "/ezCircular/circularConfirmPagingList.do",
				data : { 
						 circularID 	 : circularID,
						 pageNum 	 : CurPage,
						 perCount	 : perCount
						},
				success: function(xml){
					getBoardList_after(loadXMLString(xml));
				}        			
			});	
	    }
	    
	    function getBoardList_after(xml) {
	        try {
	            var cntNode = SelectSingleNodeNew(xml, "DOCLIST/TOTALCNT");
	            var perNode = SelectSingleNodeNew(xml, "DOCLIST/PERSONALCNT");
	            var pagenode = SelectSingleNodeNew(xml, "DOCLIST/PAGECNT");
	            var listNode = SelectSingleNodeNew(xml, "DOCLIST/LISTVIEWDATA");
	
	            if (listNode == null) return;
      
	            var lstCnt = getNodeText(cntNode);	//TOTALCNT
	            
	            if (lstCnt != 0) {		            
		            var pageCnt = getNodeText(pagenode);	//PAGECNT
		            var perCnt = getNodeText(perNode);		//PERSONALCNT
		            
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
			        	var userID = $(this).closest("tr").attr("userid");
			        	var deptID = $(this).closest("tr").attr("deptid");
			        	show_info(userID, deptID);
			        });
		            
		            $("#lvBoardList tbody tr:odd td").css("background-color", "#f8f8fa");
	            } else {
	            	var msg = "<spring:message code='ezCircular.kmsc02'/>";
	            	var htmlContent = "<tr><td style='text-align:center'>" + msg +"</td></tr>";
	            	$("#lvBoardList").html(htmlContent);
	            	
	            	$("#lvBoardList").css("height", "353px");
	            	$("#divList").css("height", "353px");
					$("#tblPageRayer").css("display", "none");
	            }
	        }
	        catch (e) {
	            alert("getBoardList_after : " + e.description);
	        }
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
	    
        function makePageSelPageReader() {
	    	var strtext;
	        var PagingHTML = "";
	        document.getElementById("tblPageRayer").innerHTML = "";
	        
	        strtext = "<div class='pagenavi'>";
	        PagingHTML += strtext;
	        var pageNum = CurPage;
	        if (totalPage > 1 && pageNum != 1) {
	            strtext = "<span class='btnimg first' onclick= 'return goToPageByNum(1)'></span>";
	            PagingHTML += strtext;
	        }
	        else {
	            strtext = "<span class='btnimg first disabled'></span>";
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
        
	    function td_Create1(strtext) {
	        document.getElementById("tblPageRayer").innerHTML = strtext;
	    }
        
     </script>

	<body class="popup">
		<form method="post" >
		  <h1><spring:message code='ezCircular.kmsc01'/></h1>
		  <div id="close">
		    <ul>
		      <li onClick="close_onclick()"><span></span></li>
		    </ul>
		  </div>
		        <div style="width:100%; height:305px" id="divList">
		            <table id="lvBoardList" class="popuplist" style="width:100%"></table>
		        </div>
		        <div id='runtime' style="color:#666;padding-top:5px"></div>
		        <div id="tblPageRayer" style="width:470px; height:24px; margin:6px auto; font-size:0"></div>
		</form>
	</body>
</html>