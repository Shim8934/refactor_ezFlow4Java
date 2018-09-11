<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezSystem.x0021' /></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">	
		<link rel="stylesheet" href="${util.addVer('main.e15', 'msg')}" type="text/css">
		<link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" src="${util.addVer('ezEmail.e1', 'msg')}"></script>
		<script type="text/javascript">
			var strLang1 = "<spring:message code='ezSystem.x0030'/>";
			var strLang2 = "<spring:message code='ezSystem.x0031'/>";
			var strLang4 = "<spring:message code='ezSystem.x0034'/>";
			var strLang5 = "<spring:message code='ezSystem.x0035'/>";
			var strLang6 = "<spring:message code='ezSystem.x0036'/>";
			var strLang7 = "<spring:message code='main.t252'/>";
			var strLang8 = "<spring:message code='ezSystem.kyj2'/>";
			var CurPage = "";
			var totalPage = "";
			var totalCount = "";
			var BlockSize = 10;

			// 화면 호출시 실행 함수
			window.onload = function(){
				getUserList(1);
				makePageSelPage();
				windowResize();
			}
			
			// 검색값 입력 후 엔터키 입력 시 검색 호출
			function keyword_onkeydown(e) {
				
			    if (!window.ActiveXObject) {
			        var keyCode = e.keyCode;
			    } else {
			        var keyCode = event.keyCode;
			    }
			    
		        if (keyCode == 13) {
					search();
					return false;
				}
				
		        return true;
			}
		
			// 페이징처리
			function td_Create1(strtext) {
		        document.getElementById("tblPageRayer").innerHTML = strtext;
		    }
		    
		    function makePageSelPage() {
		        var strtext;
		        var PagingHTML = "";
		        document.getElementById("tblPageRayer").innerHTML = "";
		        document.getElementById("listInfo").innerHTML = " &nbsp;[" + strLang7 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang8 + "]";
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
		    }
		    
		    function goToPageByNum(Value) {
		        CurPage = Value;
		        makePageSelPage();
				goToPage(CurPage);
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
		
		    // 새로고침 클릭시 이벤트
		    function reload() {
		    	goToPage(CurPage);
		    }
		    
			// 검색 버튼 클릭시 이벤트
		    function search() {
				$(function() {
					
					if ($('#searchKeyword').val().trim() == "") {
						alert("<spring:message code='ezEmail.t349'></spring:message>");
					}
					
		        	getUserList(1);
				});
		    }
			
			// 초기화버튼
			function reset() {
				$(function() {
					$('#searchKeyword').val('');
				});
			}
		    
		    // 페이지네이션 클릭시
			function goToPage(page) {
				getUserList(page);
			}		
		    
		    function getUserList(pageNum){
		    	$(function() {
		    		
		    		var selectOption = document.getElementById("searchKeycode");
					var searchKeycode = selectOption.options[selectOption.selectedIndex].value;
					var searchKeyword = document.getElementById("searchKeyword").value;
					
					 if (pageNum == "-1") {
						var pageSize = "-1";
						var params = '&searchKeycode=' + searchKeycode + '&searchKeyword=' + searchKeyword;
							params += '&pageNum=' + pageNum + '&pageSize=' + pageSize;
						var pURL = "/admin/ezEmail/statisticsListExcelExport.do" + "?" + params;
		
						saveExcel.location.href = pURL;
					} else { 
			    		var pURL = "/admin/ezEmail/statistics_userList.do";
			    		 
			    		$.ajax({
			    			 url: pURL
			    			,type: "POST"
			    			,async: false
			    			,dataType: 'json'
			    			,data: {
			    					'searchKeycode' : searchKeycode,'searchKeyword' : searchKeyword,'pageNum' : pageNum 
			    				   }    
			    			,success: function(res) {
			    				var html = "";

		   						if (res.itemCnt < 1) {
		   							html += "<tr><td colspan=\"7\" style=\"text-align:center;\">" + strLang155 + "</td></tr>";
		   						} else {
		   							var j = ((pageNum - 1) * 20) + 1 ;
		   							
		   							res.userList.forEach(function(i, v) {
		   								var res1 = Number(i[3]);
		   								var res2 = Number(i[4]);
		   								var result;
				    					
		   								if (res1 >= res2) {
		   									result = 100;
		   								} else {
		   									var progress = res1 / res2 * 100;
			   								result = Math.floor(progress);
		   								}
		   								
	   									html += "<tr>";
			    						html += "   <td>" + j						   + "</td>";
			    						html += "	<td title=\'" + i[1] + "'>" + i[1] + "</td>";
			    						html += "	<td>" 		  + i[2] 			   + "</td>";
			    						html += "	<td>"         + Math.floor(i[3] / 1024) 			   + "</td>"; //사용량
			    						html += "	<td>"         + Math.floor(i[4] / 1024) 			   + "</td>"; //총용량 
			    						
			    						if (result >= 90) {				    							
			    							html += "<td><div id='myProgress'><div id='myBar_red' style='width:" + result + "%'></div></div><div id='percentage'>" + result + "%</div></td>";
			    						} else if (result >= 70) { 
			    							html += "<td><div id='myProgress'><div id='myBar_orange' style='width:" + result + "%'></div></div><div id='percentage'>" + result + "%</div></td>";
			    						} else if (result >= 60) {
			    							html += "<td><div id='myProgress'><div id='myBar_yellow' style='width:" + result + "%'></div></div><div id='percentage'>" + result + "%</div></td>";
			    						} else {
			    							html += "<td><div id='myProgress'><div id='myBar_green' style='width:" + result + "%'></div></div><div id='percentage'>" + result + "%</div></td>";
			    						}
			    						
			    						html += "<td><a class='imgbtn imgbck'><span onClick=mod_quota('" + i[0] + "')><spring:message code='ezEmail.t481'></spring:message></span></a></td>";
										html += "</tr>";
										j++;
									})
		   					    }
		   						
			    				$('#userListBody').empty().append(html);
			    				
			    				CurPage = res.currPage;
			    				totalPage = res.totalPage;
			    				totalCount = res.itemCnt;
			    				
			    				if (res.searchKeycode != null) {
			    					var idx = parseInt(searchKeycode) - 1;
				    				$('#searchKeycode option:eq(' + idx + ')').attr('selected','selected');
			    				}
			    				
			    				$('#searchKeyword').val(res.searchKeyword);
			    				
			    			}
			    			,error: function(err) {
			    				alert(err);
			    			}
			    		})
			    		
			    		makePageSelPage();
					 } 
					 
		    	});
		    } 

		  	// 엑셀내려받기 버튼 클릭시 이벤트 호출
		    function excelExport() {
				var pageNum = "-1";
				getUserList(pageNum);
		    }
		  	
		  	// 편지함 용량수정 이벤트 호출
		  	function mod_quota(res){
		  		var width=480, height=210;
		  		var left = (screen.availWidth - width) / 2;
		  		var top = (screen.availHeight - height) / 2;
		  		var specs = "width=" + width;
		  		
		  		specs += ",height=" + height;
		  		specs += ",left=" + left;
		  		specs += ",top=" + top;
		  		
			    window.open("/admin/ezOrgan/configUserQuota.do?id=" + res, "", specs);
		    }

            //2018-08-06 김보미 - 페이지 위치 고정
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 152;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		</script>
		<!-- 용량상태 Progress Bar -->
		<style type="text/css" >
			#myProgress {
			  width: 78%;
			  height:10px;
			  float:left;
			  background-color: #ddd;
			  overflow:hidden;
			}
			#percentage {
			  width: 18%;
			  float:right;
			  margin-left:2px;
			  color: #828282;
			  font-weight:bold;
			}
			#myBar_red{
			  height: 10px;
			  background-color: #ff1616;
			}
			#myBar_orange{
			  height: 10px;
			  background-color: #ff7f00;
			}
			#myBar_yellow{
			  height: 10px;
			  background-color: #ffb600;
			}
			#myBar_green{
			  height: 10px;
			  background-color: #4CAF50;
			}
		</style>
	</head>
	<body class="mainbody">
		<h1><spring:message code="ezEmail.lsd01" /><span id="listInfo"></span></h1>
		<div style="width:100%; padding-bottom:5px;">
		<table style="width: 100%; background-color: #f8f8fa; border: 1px solid #ddd;">
			<tr>
				<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
					<span id="topmenu" style="width: 500px"><spring:message code="ezStatistics.t1062"></spring:message>&nbsp; <!-- 검색조건 -->
						<select id="searchKeycode" style="height:22px;"> 
							<option value="userName"><spring:message code="ezStatistics.t1068"></spring:message></option> <!-- 이름 -->
							<option value="deptName"><spring:message code="ezStatistics.t113"></spring:message></option> <!-- 부서 -->
							<option value="userId"><spring:message code="ezOrgan.t218"></spring:message></option> <!-- cn -->
						</select>
						<input type="text" id="searchKeyword" style="width: 150px; height:22px;" onKeyDown="return keyword_onkeydown(event)"/>
						<a class="imgbtn" >
							<span onclick="javascript:search();"><spring:message code="ezStatistics.t36"></spring:message></span> <!-- 검색 -->
						</a>
						<a class="imgbtn" >
							<span onclick="javascript:reset();"><spring:message code="ezStatistics.t1059"></spring:message></span> <!-- 재입력 -->
						</a>
						<a class="imgbtn" >
							<span onclick="javascript:reload();"><spring:message code="ezStatistics.t1060"></spring:message></span> <!-- 새로고침 -->
						</a>
					</span> 
				</td>
				<td width="5%">
					<a class="imgbtn" style="margin-right:5px;">
						<span onclick="javascript:excelExport();"><spring:message code='ezStatistics.t1003'/></span>
					</a>
				</td>
			</tr>
		</table>
		</div>
		<div id="contentlist" style="width:100%; overflow: auto;">
			<div>
				<table class="mainlist" style="width:100%;">
					<thead style="">
						<tr>
							<th width="80px;"><spring:message code="ezSystem.kyj1"></spring:message></th>
							<th width="15%;"><spring:message code="ezEmail.lsd04"></spring:message></th>
							<th width="15%;"><spring:message code="ezStatistics.t113"></spring:message></th>
							<th width="15%;"><spring:message code="ezEmail.lsd02"></spring:message></th>
							<th width="15%;"><spring:message code="ezEmail.lsd03"></spring:message></th>
							<th><spring:message code="main.t00011"></spring:message></th>
							<th style="width:140px;"><spring:message code="ezOrgan.t92"></spring:message></th>
						</tr>
					</thead>
					<tbody id="userListBody" style="overflow: auto;"></tbody>
				</table>
			</div>
		</div>
		<div id="tblPageRayer" style="width:100%;"></div>
		<iframe id=saveExcel name=saveExcel style="display:none"></iframe>
	</body>
</html>