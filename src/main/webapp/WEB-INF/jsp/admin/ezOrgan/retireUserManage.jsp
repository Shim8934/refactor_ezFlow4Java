<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e2', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('ezOrgan.e3', 'msg')}" type="text/css">
	    <link rel="stylesheet" href="${util.addVer('/js/jquery/dateControls/jquery.ui.all.css')}">
	    <script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('ezOrgan.e1', 'msg')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.core.js')}"></script>
	    <script type="text/javascript" src="${util.addVer('/js/jquery/dateControls/jquery.ui.datepicker.js')}"></script>
		<script type="text/javascript" language="javascript">
			var CurPage = 1;
			var totalPage = "${totalPage}";
			var totalCount = "${totalCount}";
			var BlockSize = 10;
			var lang = "${lang}";
			var useBizmekaSpambox = "${useBizmekaSpambox}";
			var strListInfo = "";
			var CheckBoxArr = new Array();
			var companyId = "${companyId}";
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA")
		            return false;
		        else
		            return true;
		    }
			
			window.onload = function() {
				retireUserList();
				
				$(function() {
					$('#startDatepicker').datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.gif",
						buttonImageOnly: true,
						maxDate: 0,
						onSelect: function(selected) {
							$('#endDatepicker').datepicker("option", "minDate", selected);
						}
					});
					$('#endDatepicker').datepicker({
						changeMonth: true,
						changeYear: true,
						autoSize: true,
						showOn: "both",
						buttonImage: "/images/ImgIcon/calendar-month.gif",
						buttonImageOnly: true,
						maxDate: 0,
						onSelect: function(selected) {
							$('#startDatepicker').datepicker("option", "maxDate", selected)
						}
					});    	    	
				});
				
				
				var dayMsg = "<spring:message code='main.kyj1'/>";
				var dayStr = dayMsg.split(";");
				var monthMsg = "<spring:message code='main.kyj2'/>";
				var monthStr = monthMsg.split(";");
				
				$(function() {
					$.datepicker.regional["<spring:message code='main.t0619'/>"] = {
							closeText: "<spring:message code='main.t3'/>",
							prevText: "<spring:message code='main.t0604'/>",
							nextText: "<spring:message code='main.t0605'/>",
							currentText: "<spring:message code='main.t0606' />",
							monthNames: monthStr,
							monthNamesShort: monthStr,
							dayNames: dayStr,
							dayNamesShort: dayStr,
							dayNamesMin: dayStr,
							weekHeader: 'Wk',
							dateFormat: 'yy-mm-dd',
				   			firstDay:0,
							isRTL: false,
							duration: 200,
							showAnim: 'show',
							showMonthAfterYear: true
					};
					
					$.datepicker.setDefaults($.datepicker.regional["<spring:message code='main.t0619'/>"]);	
						
				});
			}
			
			function showProgress() {
			    document.getElementById("progressPanel").style.display = "";
			    document.getElementById("loadingLayer").style.display = "";
			    
			    parent.document.getElementById("lef").contentWindow.showProgress();
			}

			function hideProgress() {
			    document.getElementById("progressPanel").style.display = "none";
			    document.getElementById("loadingLayer").style.display = "none";
			    
			    parent.document.getElementById("lef").contentWindow.hideProgress();
			}
			
			function Delete_onclick() {
			    funCheckBox('get');
			    
			    if (CheckBoxArr.length == 0) {
			        alert("<spring:message code='ezOrgan.t28'/>"); 
			        return;
			    }			    
		        var ret = confirm(CheckBoxArr.length + strLang5);
		        
			    if (ret) {
			        var data = "";
			        for (var i = 0; i < CheckBoxArr.length; i++) {
		            	data += CheckBoxArr[i];
		            	
		            	if(i != CheckBoxArr.length-1){
		            		data = data + ",";
		            	}		                
		            }

		            if (useBizmekaSpambox == "YES") {
		            	showProgress();
		            }	            
			        
			        $.ajax({
		            	type : "POST",
		            	dataType : "html",
		            	url : "/admin/ezOrgan/delUser.do",
		            	async : true,
		            	data : {cn : data},
		            	success : function(result) {
		            	    if (useBizmekaSpambox == "YES") {
		            	    	hideProgress();
		            	    }
		            	    
		            	    setTimeout(function() {		   
		            	        if (result == "OK") {
		            				alert(CheckBoxArr.length + "<spring:message code='ezOrgan.t31' />");
		            	        } else {
		            	            alert("<spring:message code='ezOrgan.t30' />")
		            	        }
		            			
		    				    refresh_onclick();		            			
		            	    }, 100);
		            	},
		            	error : function() {
		            	    if (useBizmekaSpambox == "YES") {
		            	    	hideProgress();
		            	    }
		            	    
		            	    setTimeout(function() {
		            			alert("<spring:message code='ezOrgan.t30' />");
		            			
		    				    refresh_onclick();		            			
		            	    }, 100);
		            	}
		            });					
			    }
			}
			
			function funCheckBox(mode) {
			    CheckBoxArr = new Array();
			    
			    if (mode == 'get') {
			        for (var i = 0 ; i < document.getElementsByName("chk").length ; i++) {
			            if (document.getElementsByName("chk").item(i).checked == true) {
			                CheckBoxArr[CheckBoxArr.length] = document.getElementsByName("chk").item(i).value;
			            }
			        }
			    }
			    if (mode == 'set') {
			        for (var i = 0 ; i < document.getElementsByName("chk").length ; i++) {
			            if (document.getElementsByName('checkbox').item(0).checked == true) {
			                document.getElementsByName("chk").item(i).checked = true;
			            } else {
			                document.getElementsByName("chk").item(i).checked = false;
			            }
			        }
			    }
			}
			
			//2016-05-04일 까지 구현
			var selectdept_cross_dialogArguments = new Array();
			function Restore_onclick() {
			    funCheckBox('get');
			    
			    if (CheckBoxArr.length == 0) {
			        alert(strLang6); 
			        return;
			    }
			    var ret = confirm(CheckBoxArr.length + strLang7);
			    
				if (ret) {
				    //if (CrossYN()) {
			        selectdept_cross_dialogArguments[0] = strLang8;
			        selectdept_cross_dialogArguments[1] = Restore_onclick_Complete;
			        var OpenWin = window.open("/admin/ezOrgan/selectDept.do", "SelectDept_Cross", GetOpenWindowfeature(302, 390));
			        try { OpenWin.focus(); } catch (e) { }
				}
			}
			
			function Restore_onclick_Complete(rtnValue) {
			    if (typeof (rtnValue) != "undefined") {
			    	var data = "";
			    	
			        for (var i = 0 ; i < CheckBoxArr.length ; i++) {
			        	data += CheckBoxArr[i];
			        	
			        	if (i != CheckBoxArr.length-1) {
			        		data += ",";
			        	}
			        }

			        $.ajax({
			        	type : "POST",
			        	dataType : "html",
			        	url : "/admin/ezOrgan/restoreRetireUser.do",
			        	async : false,
			        	data : {deptID : rtnValue, cn : data},
			        	success : function(result) {			        	    
			        	    if (result == "OK") {
			        			alert(strLang9);
			        	    } else {
			        	        alert(strLang10);
			        	    }
			        	},
			        	error : function(){
			        		alert(strLang10);	
			        	}
			        });

			        refresh_onclick();
			    }
			}
			
			var inputpassword_dialogArguments = new Array();
			
			function mod_password() {
			    funCheckBox('get');
			    
			    if (CheckBoxArr.length == 0) {
			        alert("<spring:message code='ezOrgan.t39' />"); 
			        return;
			    }
			    
		        inputpassword_dialogArguments[1] = mod_password_Complete;
		        var OpenWin = window.open("/admin/ezOrgan/inputPassword.do", "InputPassword", GetOpenWindowfeature(330, 185));
		        try { OpenWin.focus(); } catch (e) { }			    
			}
			
		    function mod_password_Complete(rtnValue) {
		        if (typeof (rtnValue) != "undefined") {
		            var length = CheckBoxArr.length;
		            if (!confirm(length + "<spring:message code='ezOrgan.t40' />")){
			        	return;
		            }		            
		            
			    	var data = "";
			    	
			        for (var i = 0 ; i < length ; i++) {
			        	data += CheckBoxArr[i];
			        	
			        	if (i != length-1) {
			        		data += ",";
			        	}
			        }		            
		            
		            $.ajax({
		            	type : "POST",
		            	dataType : "xml",
		            	url : "/admin/ezOrgan/changePassword.do",
		            	async : false,
		            	data : {password : rtnValue, cn : data},
		            	success : function(result){
		            		alert(length + "<spring:message code='ezOrgan.t42' />");
		            	},
		            	error : function(){
		            		alert("<spring:message code='ezOrgan.t41' />");		            		
		            	}
		            });
	            }		        
		    }		    
		    
			function refresh_onclick() {
				window.location.reload(false);
			}
			
			function ShowUserInfo(UserID) {
			    window.open("/admin/ezOrgan/retireUserInfo.do?id=" + UserID, "", "height=800px,width=530px,status=no,toolbar=no,menubar=no,location=no,resizable=0"+GetOpenPosition(530, 800));
			}
			
			function selectCompanyID() {
				retireUserList();
// 				var tempCompanyId = document.getElementById("ListCompany").value;
				
// 				if (companyId != tempCompanyId) {
// 					window.location.href = "/admin/ezOrgan/retireUserManage.do?companyId=" + tempCompanyId;
// 		        }
			}
	  
			//2018-07-20 천성준 - 페이지 네이션 변경 
			function td_Create1(strtext) {
                document.getElementById("tblPageRayer").innerHTML = strtext; //document.all.tblPageNum1.innerHTML + strtext;
            }
            
            function makePageSelPage() {
                var strtext;
                var PagingHTML = "";
                document.getElementById("tblPageRayer").innerHTML = "";
                document.getElementById("TitleInfo").innerHTML = " &nbsp;[" + strLang23 + "<span style='color:#017BEC;'> " + totalCount + " </span>" + strLang24 + "]";
                strtext = "<div class='pagenavi'>";
                PagingHTML += strtext;
                var pageNum = CurPage;
                
                if (totalPage > 1 && pageNum != 1) {
                    strtext = "<span class='btnimg' onclick= 'return goToPageByNum(1)'><img src='/images/sub/btn_p_prev.gif'></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg'><img src='/images/sub/btn_p_prev01.gif' ></span>";
                    PagingHTML += strtext;
                }
                
                if (totalPage > BlockSize) {
                    if (pageNum > BlockSize) {
                        strtext = "<span class='btnimg' onclick= 'return selbeforeBlock()'><img src='/images/sub/btn_prev.gif' ></span>";
                        PagingHTML += strtext;
                    } else {
                        strtext = "<span class='btnimg'><img src='/images/sub/btn_prev01.gif' ></span>";
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

                if (MaxNum == 0) {
	            	PagingHTML += "<span class=\"on\">" + 1 + "</span>";
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
                    strtext = strtext + "<span class='btnimg'><img src='/images/sub/btn_next01.gif' ></span>";
                    PagingHTML += strtext;
                }
                
                if (totalPage > 1 && totalPage != 1 && (totalPage != pageNum)) {
                    strtext = "<span class='btnimg' onclick='return goToPageByNum(" + totalPage + ")'><img src='/images/sub/btn_n_next.gif' ></span>";
                    PagingHTML += strtext;
                } else {
                    strtext = "<span class='btnimg'><img src='/images/sub/btn_n_next01.gif'></span>";
                    PagingHTML += strtext;
                }
                
                PagingHTML += "</div>";
                td_Create1(PagingHTML);
            }
            
            function goToPageByNum(Value) {
            	CurPage = Value;
            	retireUserList();
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
                
                if( parseInt(pageNum + 1) <= sTotalPage) {
                    goToPageByNum(parseInt(pageNum + 1));
                } else {
                    return;
                }
            }
            
			//**/ 검색값 입력 후 엔터키 입력 시 검색 호출
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
			
			//검색 버튼 클릭시 이벤트
		    function search() {
				if ($('#startDatepicker').val() == "" && $('#endDatepicker').val() == "" && $('#searchKeyword').val() == "") {
 					alert("<spring:message code='ezOrgan.0hun04' />");
 					return ;
				}
				
				 if ($("#startDatepicker").val() != "" && $("#endDatepicker").val() == "") {
 				 	alert("<spring:message code='ezOrgan.0hun06' />");
				     return;
				 }
				 
				 if ($("#endDatepicker").val() != "" && $("#startDatepicker").val() == "") {
 				 	alert("<spring:message code='ezOrgan.0hun05' />");
				     return;
				 }
				 
				 retireUserList();
		    }
			
			//**/ 초기화버튼
			function reset() {
				$('#startDatepicker').val('');				
				$('#endDatepicker').val('');				
				$('#searchKeyword').val('');
			}
			
			 //**/ 새로고침 클릭시 이벤트
		    function reload() {
		    	retireUserList();
		    }
			 
			 //**/ 퇴직자 검색
			function retireUserList() {
				 $.ajax ({
					 type : "POST",
					 async : false,
					 dataType : "json",
					 url : "/admin/ezOrgan/getRetireUserList.do",
					 data : {
						 "page" : CurPage,						 
						 "searchStartDate" : $('#startDatepicker').val(),
						 "searchEndDate" : $('#endDatepicker').val(),
						 "searchKeycode" : $('#searchKeycode').val(),
						 "searchKeyword" : $('#searchKeyword').val(),
						 "searchCompanyID" : $("#ListCompany").val()
					 },
					 success : function(data) {
						 CurPage = data.pPage;
						 totalPage = data.totalPage;
						 totalCount = data.totalCount;
						 lang = data.lang;
						
						 var html = "";
						 
						 if (totalCount < 1) {
							 html = "";							 
							 html += "<tr>";
							 html += "    <td colspan='6' style='text-align:center' bgcolor='#FFFFFF'><spring:message code='ezOrgan.0hun07'/></td>" ;
							 html += "</tr>";
						 } else {
							 data.list.forEach(function(i,v){
								html += "<tr>";
								html += "    <td width='20' style='padding:0'>";
								html += "        <input type='checkbox' name='chk' id='chk' value='" + i.cn + "'/>";
								html += "    </td>";
								
								if (lang == '' || lang == 1) {
									html += "<td>" + (i.description != null ? i.description : " ") + "</td>";
									html += "<td style='cursor:pointer' onclick=ShowUserInfo('" + i.cn + "')>" + i.displayName + "</td>";
									html += "<td>" + (i.title  != null ? i.title : " ") + "</td>";
									html += "<td>" + (i.extensionAttribute10  != null ? i.extensionAttribute10 : " ")+ "</td>";
								} 
								
								else if (lang != '' || lang != 1) {
									html += "<td>" + (i.description2 != null ? i.description2 : " ") + "</td>";
									html += "<td style='cursor:pointer' onclick=ShowUserInfo('" + i.cn + "')>" + i.displayName2 + "</td>";
									html += "<td>" + (i.title2  != null ? i.title2 : " ") + "</td>";
									html += "<td>" + (i.extensionAttribute102  != null ? i.extensionAttribute102 : " ")+ "</td>";
								}
								
								html += "<td>" + i.updateDT + "</td>";
								html += "</tr>";
							 });
						 }
						 
	    				$("#mainListBody").empty().append(html);
					 },
					 error : function(error) {
						 alert("<spring:message code='ezOrgan.0hun08' />");
					 }
				 })
   				makePageSelPage();
			}
			 
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 192;
	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        }
		    
		   //2018-08-06 김보미 - 페이지 위치 고정
		    $(window).on("resize", function(){
	            windowResize();
	        });
		    
		    function windowResize() {
	        	var height = document.documentElement.clientHeight - 192;

	        	if (navigator.userAgent.toUpperCase().indexOf("CHROME") != -1) {
	        		height = height - 30;
	        	}
	        	document.getElementById("contentlist").style.height = height + "px";
	        	document.getElementById("contentlist").style.overflow = "auto";
	        }
		    
		    $(function(){
	    		windowResize();
		    });

	    </script>
	</head>
	<body class="mainbody">
		<h1><spring:message code='ezOrgan.t311'/><span id="TitleInfo" style="color:#666;font-weight:normal;"></span></h1>
		<div id="mainmenu"> <!-- mainmenu -->    
   		    <span><b><spring:message code = 'ezApprovalG.t1512' /></b> 
   			    <select id="ListCompany" onChange="selectCompanyID()">
   		        	<c:forEach var="item" items="${companylist}">
   	            		<option value="<c:out value='${item.cn}'/>" ${item.cn == companyId ? 'selected' : ''}><c:out value='${item.displayName}'/></option>
   	            	</c:forEach>
   			    </select><br /><br />
   		    </span>
   		</div>
		<div id="mainmenu">
			<ul>
				<c:if test="${dotNetIntegration != 'YES'}">
		    	<li><span onClick="Restore_onclick()"><spring:message code='ezOrgan.t312'/></span></li>
		    	</c:if>
		        <li><span onClick="Delete_onclick()"><spring:message code='ezOrgan.t142'/></span></li>
		        <c:if test="${dotNetIntegration != 'YES'}">
                <li><span onClick="mod_password()"><spring:message code='ezOrgan.t90'/></span></li>
                </c:if>
		  	</ul>
		</div>
		<table style="width: 100%; background-color: #f8f8f8; border: 1px solid #d3d2d2;">
		<tr>
			<td width="93%" style="margin-bottom: 10px; padding: 5px 5px;">
				<span id="topmenu" style="width: 500px"><spring:message code='ezOrgan.0hun01'/> : &nbsp;
					<input type="text" id="startDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" /> ~ 
					<input type="text" id="endDatepicker" class="hasDatapicker" style="width: 100px; text-align: center" readonly="readonly" />
				</span> 
				&nbsp;&nbsp;
				<span id="topmenu" style="width: 500px"><spring:message code='ezStatistics.t1062'/>: &nbsp;
					<select id="searchKeycode" style="height:24px"> 
						<option value="userName"><spring:message code='ezOrgan.t67'/></option>
						<option value="deptName"><spring:message code='ezOrgan.t68'/></option>
						<option value="userId"><spring:message code='ezOrgan.t218'/></option>
					</select>
					<input type="text" id="searchKeyword" style="width: 150px;" onKeyDown="return keyword_onkeydown(event)"/>
					<a class="imgbtn" style="height:22px">
						<span onclick="search();"><spring:message code='ezOrgan.t101'/></span>
					</a>
					<a class="imgbtn" style="height:22px">
						<span onclick="reset();"><spring:message code='ezOrgan.0hun02'/></span>
					</a>
					<a class="imgbtn" style="height:22px">
						<span onclick="reload();"><spring:message code='ezOrgan.0hun03'/></span>
					</a>
				</span> 
			</td>
		</tr>
		</table>
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<div id="contentlist" style="width:100%; height: 653px; overflow: auto;">
			<div>
				<table class="mainlist" style="width:100%">
					<thead style> 
				    	<tr>
				      		<th style="padding:0;width:20px;"><input type='checkbox' name="checkbox" onclick="funCheckBox('set','a')" /></th>
				      		<th style="width:150px;"><spring:message code='ezOrgan.t68'/></th>
				      		<th style="width:100px;"><spring:message code='ezOrgan.t67'/></th>
				      		<th style="width:100px;"><spring:message code='ezOrgan.t69'/></th>
				      		<th style="width:100px;"><spring:message code='ezOrgan.t1500'/></th>
				      		<th><spring:message code='ezOrgan.t313'/></th>
				   		</tr>
			   		</thead>
				   	<!-- list -->
			   		<tbody id="mainListBody" style="overflow: auto;"></tbody>
				</table>
			</div>		
		</div>
     	<div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
     	<span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>    
     	<br/>
		<div id="tblPageRayer"></div>
	</body>
</html>
