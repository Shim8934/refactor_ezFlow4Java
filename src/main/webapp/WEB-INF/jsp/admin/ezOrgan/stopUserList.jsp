<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet"  href="${util.addVer('main.e15', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var useIPAccess = "${useIPAccess}";
		var rollInfo = "${rollInfo}";
		var permission = true;
		var allIPList = "";
		var companyID = "${companyId}";
		var CurPage = "";
		var totalPage = "";
		var totalCount = "";
		var BlockSize = 10;
		var stopFlag = "Y";
		
		window.onload = function () {
			getUserList(1);
			makePageSelPage();
	    }
		
		function getUserList(pageNum){
    		var selectOption = parent.document.getElementById("searchKeycode");
			var searchKeycode = selectOption.options[selectOption.selectedIndex].value;
			var searchKeyword = parent.document.getElementById("searchKeyword").value;
			var companyIdChk = companyID;
				
	    	var pURL = "/admin/ezOrgan/getLoginStopUserList.do";
	    		 
	    	$.ajax({
	    		 url: pURL
	    		,type: "POST"
	    		,async: false
	    		,dataType: 'json'
	    		,data: {
	    				'searchKeycode' : searchKeycode,
	    				'searchKeyword' : searchKeyword,
	    				'pageNum' : pageNum,
	    				'stopFlag' : stopFlag,
	    				'companyId' : companyIdChk
	    			   }    
	    		,success: function(res) {
	    			var html = "";

   					if (res.itemCnt < 1) {
   						html += "<tr><td colspan=\"7\" style=\"text-align:center;\">" + "검색된 결과가 없습니다." + "</td></tr>";
  					} else {
   						var j = ((pageNum - 1) * 20) + 1 ;
   							
   						res.userList.forEach(function(user, v) {
   							var result;
   								
   							var cn = user.cn;
   							var userName = user.displayName;
  							var deptName = user.description;
  							var companyName = user.company;
  							var passwordUpdateDT = user.passwordUpdateDT;
  							var durationDays = 0;
  							var loginStopDT = user.loginStopDT;
  							
  							if(passwordUpdateDT) {
  								passwordUpdateDT = passwordUpdateDT.substr(0, 10);
  								durationDays = parseInt((new Date() - new Date(passwordUpdateDT)) / (1000 * 60 * 60 * 24))
  							} else {
  								passwordUpdateDT = "없음";
  								durationDays = "-";
  							}
							loginStopDT = loginStopDT.substr(0, 10);
								
							html += "<tr>";
							html += "   <td style='width:22px;text-align:center;cursor:deafult;'>" +
									"		<input id='" + cn + "'type='checkbox' style='margin:0;padding:0;width:13px;height:13px;cursor=pointer;'/>" +
									"	</td>";
    						html += "   <td>" + j + "</td>";
    						html += "	<td title=\'" + userName + "(" + cn + ")'>" + userName + "(" + cn + ")" + "</td>";
    						html += "	<td>" + deptName + "</td>";
    						html += "	<td>" + companyName + "</td>";
    						html += "	<td>" + passwordUpdateDT + " (" + durationDays + ")" + "</td>";
    						html += "	<td>" + loginStopDT + "</td>";
							html += "</tr>";
							j++;
						})
 					}
  						
    				document.getElementById("userListBody").innerHTML = html;
    				
    				CurPage = res.currPage;
    				totalPage = res.totalPage;
    				totalCount = res.itemCnt;
    			}
    			,error: function(err) {
    				alert(strLang321);
    			}
    		})
	    		
    		makePageSelPage();
	    }
		
		function makePageSelPage() {
	        var strtext;
	        var PagingHTML = "";
	        document.getElementById("tblPageRayer").innerHTML = "";
	        strtext = "<div class='pagenavi'>";
	        PagingHTML += strtext;
	        var pageNum = CurPage;
	        
	        if (totalPage > 1 && pageNum != 1) {
	            strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif'></span>"
	            PagingHTML += strtext;
	        } else {
	            strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif'></span>"
	            PagingHTML += strtext;
	        }
	        
	        if (totalPage > BlockSize) {
	            
	        	if (pageNum > BlockSize) {
	                strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif'></span>";
	                PagingHTML += strtext;
	            }
	        	
	        } else {
	            strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
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
	                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	        	
	        }
	        
	        if (totalPage > BlockSize) {
	           
	        	if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg' onclick='return selafterBlock()'><img src='/images/sub/btn_next.gif'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
	                PagingHTML += strtext;
	            }
	        	
	        } else {
	            strtext = "";
	            strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif'></span>";
	            PagingHTML += strtext;
	        }
	        
	        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
	            PagingHTML += strtext;
	        } else {
	            strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif' ></span>";
	            PagingHTML += strtext;
	        }
	        
	        PagingHTML += "</div>";
	        td_Create1(PagingHTML);
	        
	    	// 페이징처리
			function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
	    }
		
		function goToPageByNum(Value) {
	        CurPage = Value;
	        makePageSelPage();
			goToPage(CurPage);
	    }
		
		// 페이지네이션 클릭시
		function goToPage(page) {
			getUserList(page);
		}	
		
		function event_HeaderCheckBoxClick(obj) {
			var checkboxList = document.querySelectorAll("#userListBody tr input");
			[].forEach.call(checkboxList, function(elem){
				elem.checked = obj.checked;
			});
		}
	</script>
</head>
<body class="mainbody" style="overflow:hidden; margin:0" marginwidth="0" marginheight="0">
	<div id="contentHeader" style="width: 100%; overflow: auto;">
		<table class="mainlist" style="width:100%;">
			<thead style="">
				<tr>
					<th style="width: 22px; text-align: center;"><input type="checkbox" id="HeaderAllCheckBox" onclick="event_HeaderCheckBoxClick(this)" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
					<th width="80px;"><spring:message code="ezSystem.kyj1"></spring:message></th>
					<th width="15%;"><spring:message code="ezEmail.lsd04"></spring:message></th>
					<th width="15%;"><spring:message code="ezStatistics.t113"></spring:message></th>
					<th width="15%;"><spring:message code="ezEmail.t712"></spring:message></th>
					<th width="15%;">암호 최종변경일자(경과일)</th>
					<th width="15%;">정지일자</th>
				</tr>
			</thead>
			<tbody id="userListBody" style="overflow: auto;"></tbody>
		</table>
	</div>
	
	<div id="tblPageRayer" style="width:100%;"></div>
</body>
</html>