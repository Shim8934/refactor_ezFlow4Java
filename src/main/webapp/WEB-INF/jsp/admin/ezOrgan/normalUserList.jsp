<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>    
<!DOCTYPE html>
<html>
<head>
	<title></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css"/>
	<link rel="stylesheet"  href="${util.addVer('main.default.css', 'msg')}" type="text/css">
	<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}" ></script>
	<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	<script type="text/javascript">
		var useIPAccess = "${useIPAccess}";
		var rollInfo = "${rollInfo}";
		var permission = true;
		var allIPList = "";
		var companyID = "";
		var CurPage = "";
		var totalPage = "";
		var totalCount = "";
		var BlockSize = 10;
		
		window.onload = function () {
			getCompanyId();
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
	    				'companyId' : companyIdChk
	    			   }    
	    		,success: function(res) {
	    			var html = "";

                    var lang = res.lang;
					var primary = res.primary;
   					if (res.itemCnt < 1) {
   						html += "<tr><td colspan=\"6\" style=\"text-align:center;\">" + "<spring:message code='ezOrgan.hdp25' />" + "</td></tr>";
  					} else {
   						var j = ((pageNum - 1) * 20) + 1 ;
   							
   						res.userList.forEach(function(user, v) {
   							var result;
   								
   							var cn = user.cn;
   							if(primary=="1"){
   							    var userName = user.displayName;
   							    var deptName = user.description;
   							    var companyName = user.company;
   							}else{
   							    var userName = user.displayName2;
                                var deptName = user.description2;
                                var companyName = user.company2;
   							}
  							var passwordUpdateDT = user.passwordUpdateDT;
  							var durationDays = 0;
  							
  							if(passwordUpdateDT) {
  								passwordUpdateDT = passwordUpdateDT.substr(0, 10);
  								durationDays = parseInt((new Date() - new Date(passwordUpdateDT)) / (1000 * 60 * 60 * 24))
  							} else {
  								passwordUpdateDT = "<spring:message code='ezOrgan.hdp13' />";
  								durationDays = "-";
  							}
  							
							html += "<tr>";
							html += "   <td style='width:22px;text-align:center;cursor:deafult;'>" +
									"		<input id='" + cn + "'type='checkbox' style='margin:0;padding:0;width:13px;height:13px;'/>" +
									"	</td>";
    						html += "   <td>" + j + "</td>";
    						html += "	<td title=\'" + userName + "(" + cn + ")'>" + userName + "(" + cn + ")" + "</td>";
    						html += "	<td>" + deptName + "</td>";
    						html += "	<td>" + companyName + "</td>";
    						html += "	<td>" + passwordUpdateDT + " (" + durationDays + ")" + "</td>";
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
	                strtext = "<span onclick='goToPageByNum(" + i + ")'>" + i + "</span>";
	                PagingHTML += strtext;
	            }
	        	
	        }
	        
	        if (totalPage > BlockSize) {
	           
	        	if (totalPage >= parseInt(((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1)) {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next' onclick='return selafterBlock()'></span>";
	                PagingHTML += strtext;
	            } else {
	                strtext = "";
	                strtext = strtext + "<span class='btnimg next disabled'></span>";
	                PagingHTML += strtext;
	            }
	        	
	        } else {
	            strtext = "";
	            strtext = strtext + "<span class='btnimg next disabled'></span>";
	            PagingHTML += strtext;
	        }
	        
	        if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
	            strtext = "<span class='btnimg last' onclick='return goToPageByNum(" + totalPage + ")'></span>";
	            PagingHTML += strtext;
	        } else {
	            strtext = "<span class='btnimg last disabled'></span>";
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
	        document.getElementById("HeaderAllCheckBox").checked = false;
			goToPage(CurPage);
	    }
		
		// 페이지네이션 클릭시
		function goToPage(page) {
			getUserList(page);
		}
		
		function selbeforeBlock() {
	        var pageNum = parseInt(CurPage);
	        pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
	        goToPageByNum(pageNum);    
	    }
	    
	    function selbeforeBlock_one() {
	        var pageNum = parseInt(CurPage);
	        
	        if (parseInt(pageNum - 1) > 0) {
	            goToPageByNum(parseInt(pageNum - 1));
	        } else {
	            return;
	        }
	    }
	    
	    function selafterBlock() {
	        var pageNum = parseInt(CurPage);
	        pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
	        goToPageByNum(pageNum);
	    }
	    
	    function selafterBlock_one() {
	        var pageNum = parseInt(CurPage);
	        
	        if( parseInt(pageNum + 1) <= totalPage) {
	            goToPageByNum(parseInt(pageNum + 1));
	        } else {
	            return;
	        }
	    }
		
		function event_HeaderCheckBoxClick(obj) {
			var checkboxList = document.querySelectorAll("#userListBody tr input");
			[].forEach.call(checkboxList, function(elem){
				elem.checked = obj.checked;
			});
		}
		
		function getCompanyId(){
			companyID = parent.companyId;
		}
	</script>
</head>
<body class="mainbody" style="overflow:hidden; margin:0" marginwidth="0" marginheight="0">
	<div id="contentHeader" style="width: 100%; overflow: auto;">
		<table class="mainlist" style="width:100%;">
			<thead>
				<tr>
					<th style="width: 22px; text-align: center;"><input type="checkbox" id="HeaderAllCheckBox" onclick="event_HeaderCheckBoxClick(this)" style="margin: 0px; padding: 0px; width: 13px; height: 13px;"></th>
					<th width="80px"><spring:message code="ezSystem.kyj1"></spring:message></th>
					<th width="20%"><spring:message code="ezEmail.lsd04"></spring:message></th>
					<th width="20%"><spring:message code="ezStatistics.t113"></spring:message></th>
					<th width="20%"><spring:message code="ezEmail.t712"></spring:message></th>
					<th width="25%"><spring:message code='ezOrgan.hdp10' />(<spring:message code='ezOrgan.hdp11' />)</th>
				</tr>
			</thead>
			<tbody id="userListBody" style="overflow: auto;"></tbody>
		</table>
	</div>
	
	<div id="tblPageRayer" style="width:100%;"></div>
</body>
</html>