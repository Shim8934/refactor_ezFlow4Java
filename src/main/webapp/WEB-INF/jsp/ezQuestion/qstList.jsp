<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title><spring:message code="ezQuestion.t270" /></title>		
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="<spring:message code='ezQuestion.i1' />" type="text/css">
		<script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
		<script type="text/javascript" src="/js/mouseeffect.js"></script>
		<script type="text/javascript" src="<spring:message code='ezQuestion.e1' />"></script>
		<script src="//code.jquery.com/jquery-1.12.0.min.js"></script>
		<style>
			.pagetd{padding-top:6px; }
			.pcol{padding-top:6px; }
			.Right_Point01 {
				font:bold;
				color:#017bec;
			}
		</style>
		<script language="JavaScript" type="text/javascript">
			var g_ezBoard = "/gwQuestion";
		    var g_BrdID = "${qstListVO.brdId}";
		    var szSelectedItemNo = "";
		    var szPubFlag = "";
		    var endPollYN, responseYN, resultOpenYN;
			var multiResYN, writeYN, adminYN;
			var TR_Contents_Start = 1;
			var CurPage = "${qstListVO.currPage}";
			var totalPage = "${qstListVO.totalPage}";
		    var totalCount = "${qstListVO.totalCnt}";
		    
			document.onselectstart = function(){ return false; };
			window.onload = function(){
				if (navigator.userAgent.indexOf('Firefox') != -1) {
			        document.body.style.MozUserSelect = 'none';
			        document.body.style.WebkitUserSelect = 'none';
			        document.body.style.khtmlUserSelect = 'none';
			        document.body.style.oUserSelect = 'none';
			        document.body.style.UserSelect = 'none';
			    }
				makePageSelPage();
			}
			
			function checkUserPollStatus(pItemNo, pflag){
				$.ajax({
					  type: "POST",
					  url: "/ezQuestion/qstCallUsersPollStatus.do",
					  data: "brd_id=" + g_BrdID + "&item_no=" + pItemNo,
					  dataType: "JSON",
					  success: function(map){
						  endPollYN = map.endPollYN;
						  responseYN = map.responseYN;
						  resultOpenYN = map.resultOpenYN;
						  multiResYN = map.multiResYN;
						  writeYN = map.writeYN;
						  adminYN = map.adminYN;
						  var rv;
					        switch (pflag) {
					            case "Response":
					                rv = Chk_Response();
					                break;
					            case "Result":
					                rv = Chk_Result();
					                break;
					            case "InfoModify":
					                rv = Chk_InfoModify();
					                break;
					            case "Delete":
					                rv = Chk_Delete();
					                break;
					            case "Analysis":
					                rv = Chk_Analysis();
					                break;
					            case "Save":
					                rv = Chk_Save();
					                break;
					            case "Reuse":
					                rv = Chk_Reuse();
					                break;
					        }
					        return rv;
					  },
					  error: function(xhr, status, e){
						 	alert(e.message);
						 	
						 	EndPollYN = "";
					        ResponseYN = "";
					        ResultOpenYN = "";
					        MultiResYN = "";
					        WriteYN = "N";
					        AdminYN = "N";
					        
						    return false;
					  }
				});
			}
			
			function Chk_Reuse(){
				if (WriteYN == "Y")
					return true;
				else{
					alert(strLang44);
				return false;
				}
			}
			
			function Chk_Save(){
			    if(WriteYN == "Y" || AdminYN == "Y")
			        return true;
			    else{
			        alert('<spring:message code="ezQuestion.t275" />');
			        return false;
			    }
			}
			
		    function Chk_Analysis(){
		        if(WriteYN == "Y" || AdminYN == "Y")
		            return true;
		        else{
		            alert('<spring:message code="ezQuestion.t276" />');
		            return false;
		        }
		    }
		    
		    function Chk_Delete(){
		        if(WriteYN == "Y" || AdminYN == "Y")
		            return true;
		        else{
		            alert('<spring:message code="ezQuestion.t278" />');
		            return false;
		        }
		    }
		    
		    function Chk_Response(){
		        if(EndPollYN == "N"){
	            	if(ResponseYN == "Y"){
	                	if(MultiResYN == "Y"){
	                	    return true;
	                	}else{
	                	    alert('<spring:message code="ezQuestion.t280" />');
	                	    return false;
	                	}
	            	}else{
	            	    return true;
	            	}
	        	}else{
	        	    alert('<spring:message code="ezQuestion.t281" />');
	        	    return false;
	        	}
    		}
		
	    	function Chk_Result(){
	    	    if(EndPollYN == "Y"){
	    	        if(ResultOpenYN == "Y"){
		                return true;
		            }else{
		                if(WriteYN == "Y" || AdminYN == "Y")
		                    return true;
	            	    else{
	            	        alert('<spring:message code="ezQuestion.t284" />');
	            	        return false;
	            	    }
	            	}
	        	}else{
	        	    if(ResultOpenYN == "Y"){
		                return true;
		            }else{
		                if(WriteYN == "Y" || AdminYN == "Y")
		                    return true;
		                else{
		                    alert('<spring:message code="ezQuestion.t284" />');
		                    return false;
		                }
		            }
		
		        }
		    }
		
		    function Chk_InfoModify(){
		        if (WriteYN == "Y" || AdminYN == "Y") {
		            return true;
		        }else{
		            alert('<spring:message code="ezQuestion.t285" />');
		            return false;
		        }
		    }
		    
		    function menu_NewQuestion(){
		        var szUrl = g_ezBoard + "/ezQuestion/qstStep1.do?brd_id=" + g_BrdID + "&brd_postterm=" + szPostterm;
		        window.location.href = szUrl;
		    }
		
		    function menu_Checking(){
				var szCheckCnt = 0;
	            var table = document.getElementById("QstList");
	            var szLen = table.rows.length;
	            szPubFlag = "";
	            for(var i = TR_Contents_Start; i < szLen; i++){
					var row = table.rows[i];
	                var chkboxCell = row.cells[0];
	                var InputTags = chkboxCell.getElementsByTagName("INPUT");
	                if(InputTags.length > 0){
	                    if(InputTags[0].type == "checkbox"){
	                        var chkbox = InputTags[0];
	                        if(chkbox.checked){
	                            szSelectedItemNo = chkbox.value;
	                            if(navigator.userAgent.indexOf("Firefox") > -1){
	                                var ret = row.cells[2].innerHTML;
	                                ret = ret.replace(/&nbsp;/ig, " ");
	                                ret = ret.replace(/<br>/ig, "\n");
	                                ret = ret.replace(/<br[^>]+>/ig, "\n");
	                                ret = ret.replace(/<[^>]+>/g, "");
	                                szPubFlag = ret;
	                            }else{
	                                szPubFlag = row.cells[2].innerText;
	                            }
	                            szCheckCnt = szCheckCnt + 1;
	                        }
	                    }
	                }
	            }
	            if(szPubFlag.indexOf('<spring:message code="ezQuestion.t239" />') > -1){
	                szPubFlag = "1";
	            }else{
	                szPubFlag = "0";
	            }
	            if (szCheckCnt == 1)
	            	return true;
	            else if(szCheckCnt == 0){
	                szSelectedItemNo = "";
	                alert('<spring:message code="ezQuestion.t289" />');
	                return false;
	            }else{
	                szSelectedItemNo = "";
	                alert('<spring:message code="ezQuestion.t290" />');
	                return false;
	            }
		    }
		    
		    function menu_Result(){
		        if(menu_Checking()){
		            if(checkUserPollStatus(szSelectedItemNo, "Result") == false)
		            	return;
		            var szUrl = "/ezQuestion/qstResult.do?" + receve + "&item_no=" + szSelectedItemNo;
		            window.location.href = szUrl;
		        }
		    }
		    
		    function menu_InfoModify(){
		        <%-- if(menu_Checking()){
		            if(checkUserPollStatus(szSelectedItemNo, "InfoModify") == false)
		            	return;
		            var szUrl = "/ezQuestion/qstChangePermission.do?" + receve + "&item_no=" + szSelectedItemNo;
		            window.location.href = szUrl;
		        } --%>
		    }
		    
		    function menu_Delete(){
		    	var qst_delete_itemmsg_dialogArguments = new Array();
		        var szCheckCnt = 0;
		        var table = document.getElementById("QstList");
		        var szLen = table.rows.length;
		        for(var i = TR_Contents_Start; i < szLen; i++){
		            var row = table.rows[i];
		            var chkboxCell = row.cells[0];
		            var InputTags = chkboxCell.getElementsByTagName("INPUT");
		            if(InputTags.length > 0){
		                if(InputTags[0].type == "checkbox"){
		                    var chkbox = InputTags[0];
		                    if(chkbox.checked){
		                        p_SelectedItemNo = chkbox.value;
		                        if(navigator.userAgent.indexOf("Firefox") > -1){
		                            var ret = row.cells[1].innerHTML;
		                            ret = ret.replace(/&nbsp;/ig, " ");
		                            ret = ret.replace(/<br>/ig, "\n");
		                            ret = ret.replace(/<br[^>]+>/ig, "\n");
		                            ret = ret.replace(/<[^>]+>/g, "");
		                            p_SelectedTitle = ret;
		                        }else{
		                            p_SelectedTitle = row.cells[1].innerText;
		                        }
		                        if(navigator.userAgent.indexOf("Firefox") > -1){
		                            var ret = row.cells[5].innerHTML;
		                            ret = ret.replace(/&nbsp;/ig, " ");
		                            ret = ret.replace(/<br>/ig, "\n");
		                            ret = ret.replace(/<br[^>]+>/ig, "\n");
		                            ret = ret.replace(/<[^>]+>/g, "");
		                            p_SelectedWriter = ret;
		                        }else{
		                            p_SelectedWriter = row.cells[5].innerText;
		                        }
		                        szCheckCnt = szCheckCnt + 1;
		                    }
		                }
		            }
		        }
		        if(szCheckCnt == 0){
		            alert('<spring:message code="ezQuestion.t294" />');
		            return;
		        }
		        if(szCheckCnt == 1){
		            if(checkUserPollStatus(p_SelectedItemNo, "Delete") == false)
		            	return;
		            var rgParams = new Array();
		            rgParams["TITLE"] = p_SelectedTitle;
		            rgParams["WRITER"] = p_SelectedWriter;

		            qst_delete_itemmsg_dialogArguments[0] = rgParams;
		            qst_delete_itemmsg_dialogArguments[1] = menu_Delete_Complete;

		            var Qst_Delete_ItemMsg = GetOpenWindow("Qst_Delete_ItemMsg.aspx?brd_id=" + g_BrdID + "&item_no=" + p_SelectedItemNo, "Qst_Delete_ItemMsg", 400, 230);
		            try{
		            	Qst_Delete_ItemMsg.focus(); 
		            }catch (e){
		            }
		        }else{
		            alert('<spring:message code="ezQuestion.t290" />');
		            return;
		        }
		    }
		    
		    function menu_Delete_Complete(){
		        window.location.reload(true);
		    }
		    
		    function menu_Analysis(){
		       if (menu_Checking()) {
		            if (checkUserPollStatus(szSelectedItemNo, "Analysis") == false) return;
		            var szUrl = "/ezQuestion/qstAnalysis.do?"+receve+"&item_no=" + szSelectedItemNo + "&pubflag=" + szPubFlag;
		            window.location.href = szUrl;
		        }
		    }
		    
		    function menu_Search(){
		        var szUrl = "/ezQuestion/qstSearch.do?brd_id=" + g_BrdID;
		        window.location.href = szUrl;
		    }
		
		    function menuQst_DetailUserInfo(pUserID){
		    	 var feature = GetOpenPosition(420, 438);
		         window.open("/myoffice/common/ShowPersonInfo_cross.aspx?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1" + feature);
		    }
		    
		    function search_Set(pPage){
				if(pPage != "" && pPage != "0" && parseInt(pPage) > 0 && parseInt(pPage) <= parseInt('${qstListVO.totalPage}')){
					var szUrl = "/ezQuestion/qstList.do?brdId=" + g_BrdID + "&currPage=" + pPage + "&title=" + "${qstListVO.title}" + "&responseRange=" + "${qstListVO.responseRange}" + "&postDate=" + "${qstListVO.postDate}" + "&pollEndDate=" + "${qstListVO.pollEndDate}";
					window.location.href = szUrl;
				}
			}
		    
		    function changePage(){
		        if(event.keyCode == 13){
		            var inputNum = txt_PageInputNum.value;
		            search_Set(inputNum);
		            return false;
		        }
		        return true;
		    }
		    
		    function title_OnClick(pReceve){
		        document.location.href = "/ezQuestion/pollOpen.do?" + pReceve;
		    }
		    
		    var BlockSize = 10;
		    
		    function td_Create1(strtext){
		        document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
		    }
		
		    function makePageSelPage(){
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("mailBoxInfo").innerHTML = " - [" + strLang41 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang42 + "]";
		        strtext = "<div class='pagenavi'>";
		        PagingHTML += strtext;
		        var pageNum = CurPage;
		        if(totalPage > 1 && pageNum != 1){
		            strtext = "<span class='btnimg' onClick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }else{
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' width='16' height='16'></span>"
		            PagingHTML += strtext;
		        }
		        if(totalPage > BlockSize){
		            if(pageNum > BlockSize){
		                strtext = "<span class='btnimg' onClick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }else{
		                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		                PagingHTML += strtext;
		            }
		        }else{
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' width='16' height='16'></span><span class='ptxt' onClick= 'return selbeforeBlock_one()'>" + strLang39 + "</span>";
		            PagingHTML += strtext;
		        }
		        var MaxNum;
		        var i;
		        var startNum = (parseInt((pageNum - 1) / BlockSize) * BlockSize) + 1;
		        if(totalPage >= (startNum + parseInt(BlockSize))){
		            MaxNum = (startNum + parseInt(BlockSize)) - 1;
		        }else{
		            MaxNum = totalPage;
		        }
		        for(i = startNum; i <= MaxNum; i++){
		            if(i == pageNum){
		                strtext = "<span class='on'>" + i + "</span>";
		                PagingHTML += strtext;
		            }else{
						strtext = "<span onClick='goToPageByNum(" + i + ")'>" + i + "</span>";
		                PagingHTML += strtext;
		            }
		        }
		        if(totalPage > BlockSize){
	            	if(totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)){
	            	    strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + strLang40 + "</span>";
	            	    strtext = strtext + "<span class='btnimg' onClick='return selafterBlock()'><img src='/images/sub/btn_next.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
	            	}else{
		                strtext = "<span class='ptxt' onclick='return selafterBlock_one()'>" + strLang40 + "</span>";
		                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		                PagingHTML += strtext;
	            	}
		        }else{
		            strtext = "<span class='ptxt' onClick='return selafterBlock_one()'>" + strLang40 + "</span>";
		            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        if(totalPage > 1 && totalPage != 1 && (totalPage != pageNum)){
		            strtext = "<span class='btnimg' onClick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }else{
		            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' width='16' height='16'></span>";
		            PagingHTML += strtext;
		        }
		        PagingHTML += "</div>";
		        td_Create1(PagingHTML);
		    }
		    
		    function goToPageByNum(Value){
		        CurPage = Value;
		        makePageSelPage();
		        search_Set(CurPage);
		    }
		    
		    function selbeforeBlock(){
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selbeforeBlock_one(){
		        var pageNum = parseInt(CurPage);
		        if(parseInt(pageNum - 1) > 0)
		            goToPageByNum(parseInt(pageNum - 1));
		        else
		            return;
		    }
		    
		    function selafterBlock(){
		        var pageNum = parseInt(CurPage);
		        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
		        goToPageByNum(pageNum);
		    }
		    
		    function selafterBlock_one(){
		        var pageNum = parseInt(CurPage);
		        if(parseInt(pageNum + 1) <= totalPage)
		            goToPageByNum(parseInt(pageNum + 1));
		        else
		            return;
		    }
		     
		    function menu_reuse(){
		        var szCheckCnt = 0;
		        var table = document.getElementById("QstList");
		        var szLen = table.rows.length;
		        for(var i = TR_Contents_Start; i < szLen; i++){
		            var row = table.rows[i];
		            var chkboxCell = row.cells[0];
		            var InputTags = chkboxCell.getElementsByTagName("INPUT");
		            if(InputTags.length > 0){
		                if(InputTags[0].type == "checkbox"){
		                    var chkbox = InputTags[0];
		                    if(chkbox.checked){
		                        p_SelectedItemNo = chkbox.value;
		                        if(navigator.userAgent.indexOf("Firefox") > -1){
		                            var ret = row.cells[1].innerHTML;
		                            ret = ret.replace(/&nbsp;/ig, " ");
		                            ret = ret.replace(/<br>/ig, "\n");
		                            ret = ret.replace(/<br[^>]+>/ig, "\n");
		                            ret = ret.replace(/<[^>]+>/g, "");
		                            p_SelectedTitle = ret;
		                        }else{
		                            p_SelectedTitle = row.cells[1].innerText;
		                        }
		                        if(navigator.userAgent.indexOf("Firefox") > -1){
		                            var ret = row.cells[5].innerHTML;
		                            ret = ret.replace(/&nbsp;/ig, " ");
		                            ret = ret.replace(/<br>/ig, "\n");
		                            ret = ret.replace(/<br[^>]+>/ig, "\n");
		                            ret = ret.replace(/<[^>]+>/g, "");
		                            p_SelectedWriter = ret;
		                        }else{
		                            p_SelectedWriter = row.cells[5].innerText;
		                        }
		                        szCheckCnt = szCheckCnt + 1;
		                    }
		                }
		            }
		        }
		        if(szCheckCnt == 0){
		            alert('<spring:message code="ezQuestion.t294" />');
		            return;
		        }
		        if (szCheckCnt == 1) {
		            if (checkUserPollStatus(p_SelectedItemNo, "Reuse") == false)
		            	return;
		            var szUrl = "/ezQuestion/qstStep1Reuse.do?brd_id=" + g_BrdID + "&item_id=" + p_SelectedItemNo;
		            window.location.href = szUrl;
		        }else{
		            alert('<spring:message code="ezQuestion.t290" />');
		            return;
		        }
		    }
		</script>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezQuestion.t300" /><span id="mailBoxInfo"></span></h1>
		<div id="mainmenu">
			<ul>
				<li><span onClick="menu_Result()"><spring:message code="ezQuestion.t303" /></span></li>
				<li><span onClick="menu_Analysis()"><spring:message code="ezQuestion.t304" /></span></li>
				<li id="tbar1" style="background:none; padding-right:2px;"><img src="/images/i_bar.gif" align="absmiddle"></li>
				<li><span onClick="menu_Search()"><spring:message code="ezQuestion.t34" /></span></li>
				<li><span onClick="menu_InfoModify()"><spring:message code="ezQuestion.t305" /></span></li>
				<li><span onClick="menu_Delete()"><spring:message code="ezQuestion.t177" /></span></li>
				<li><span onClick="menu_reuse()"><spring:message code="ezQuestion.t700" /></span></li>
			</ul>
		</div>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>		 
		<form method="post">
			<table id="QstList" class="mainlist" width="100%"> 
			    <tr> 
					<th width="30" align="center"> <spring:message code="ezQuestion.t306" /></th> 
					<th width="60%"><spring:message code="ezQuestion.t307" /></th> 
					<th width="60"><spring:message code="ezQuestion.t308" /></th> 
					<th width="80"><spring:message code="ezQuestion.t309" /></th> 
					<th width="60"><spring:message code="ezQuestion.t310" /></th> 
					<th width="90"><spring:message code="ezQuestion.t265" /></th> 
					<th width="65"><spring:message code="ezQuestion.t311" /></th> 
			    </tr>
			 	<c:forEach var="list" items="${list}"> 
			        <tr id="${list.itemNo}" class="white"> 
			        	<td style="padding:0"> <input type="checkbox" id="menuCheck+${list.itemNo}+" value="${list.itemNo}"></td> 
			          	<td style="overflow: hidden; cursor: pointer; text-overflow: ellipsis;" title="${list.title}" onClick="title_OnClick('${list.receve}&itemNo=${list.itemNo}')" ><nobr>${list.title}</nobr></td> 
			          	<c:if test="${list.publicFlg == 0}">
			          		<td> 기명 </td>	
			          	</c:if>
			          	<c:if test="${list.publicFlg == 1}">
			          		<td> 무기명 </td>	
			          	</c:if>
			          	<c:set var="pollEndDate" value="${list.pollEndDate}" />
			          	<td> ${fn:substring(pollEndDate,0,10) } </td>
			          	<c:if test="${list.responseRange == 0}">
			          		<td> 전체 </td>	
			          	</c:if>
			          	<c:if test="${list.responseRange == 1}">
			          		<td> 선정 </td>	
			          	</c:if>
			          	<td> <a style="cursor:pointer" onClick="menuQst_DetailUserInfo('${list.userId}')"> ${list.userNm} </a> </td> 
			          	<c:if test="${list.publicResultFlg == 0}">
			          		<td> 비공개 </td>	
			          	</c:if>
			          	<c:if test="${list.publicResultFlg == 1}">
			          		<td> 공개 </td>	
			          	</c:if>

			        </tr>
		        </c:forEach>
			    <c:if test="${qstListVO.totalCnt == 0}"> 
			        <tr> 
						<td colspan="13" align="center" height="30" bgcolor="#FFFFFF"> <spring:message code="ezQuestion.t312" /></td> 
		       		</tr> 
		        </c:if> 
			</table> 
		</form>
		 
		<div id="tblPageRayer"></div>
	</body>
</html>