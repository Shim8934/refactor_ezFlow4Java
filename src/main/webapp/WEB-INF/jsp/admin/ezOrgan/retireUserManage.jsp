<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">		
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e2' />" type="text/css">
	    <link rel="stylesheet" href="<spring:message code='ezOrgan.e3' />" type="text/css">
	    <script type="text/javascript" src="/js/mouseeffect.js"></script>
	    <script type="text/javascript" src="/js/XmlHttpRequest.js"></script>
	    <script type="text/javascript" src="<spring:message code='ezOrgan.e1' />"></script>
	    <script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script type="text/javascript" language="javascript">
			var CurPage = "<c:out value='${pPage}'/>";
			var totalPage = "<c:out value='${totalPage}'/>";
			var totalCount = "<c:out value = '${totalCount}' />";
			var BlockSize = "<c:out value = '${pPageRow}' />";
			var useBizmekaSpambox = "${useBizmekaSpambox}";
			var strListInfo = "";
			var CheckBoxArr = new Array();
			var companyId = "${companyId}";
			
			document.onselectstart = function () {
		        if (event.srcElement.tagName != "INPUT" && event.srcElement.tagName != "TEXTAREA") {
		            return false;
		        } else {
		            return true;
				}
			};
	        
			/* 페이지네이션 변경으로 인한 주석처리
			function prevPage_onclick()	{
				newPage = parseInt(CurPage) - 1;
				if (newPage > 0) {
					window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + newPage.toString();
				}
			}

			function nextPage_onclick()	{
				newPage = parseInt(CurPage) + 1;
				if (newPage <= parseInt(totalPage)) {
					window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + newPage.toString();
				}
			}
			
			 function moveToPage() {
				if (window.event.keyCode == 13) {
					var newPage = txt_PageInputNum.value;	
					if (parseInt(newPage) > 0 && parseInt(newPage) <= parseInt(totalPage)) {
						window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + parseInt(newPage);
					}
				}
			} */
	       
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
				var tempCompanyId = document.getElementById("ListCompany").value;
				
				if (companyId != tempCompanyId) {
					window.location.href = "/admin/ezOrgan/retireUserManage.do?companyId=" + tempCompanyId;
		        }
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
                sCurPage = Value;
                makePageSelPage();
				moveToPage(sCurPage);
            }
            
            function selbeforeBlock() {
                var pageNum = parseInt(sCurPage);
                pageNum = ((parseInt(pageNum / BlockSize) - 1) * BlockSize) + 1;
                goToPageByNum(pageNum);    
            }
            
            function selbeforeBlock_one() {
                var pageNum = parseInt(sCurPage);
                
                if (parseInt(pageNum - 1) > 0) {
                    goToPageByNum(parseInt(pageNum - 1));
                } else {
                    return;
                }
            }
            
            function selafterBlock() {
                var pageNum = parseInt(sCurPage);
                pageNum = ((parseInt((pageNum - 1) / BlockSize) + 1) * BlockSize) + 1;
                goToPageByNum(pageNum);
            }
            
            function selafterBlock_one() {
                var pageNum = parseInt(sCurPage);
                
                if( parseInt(pageNum + 1) <= sTotalPage) {
                    goToPageByNum(parseInt(pageNum + 1));
                } else {
                    return;
                }
            }
            
            function moveToPage(sCurPage) {
				if (parseInt(sCurPage) > 0 && parseInt(sCurPage) <= parseInt(totalPage)) {
					window.location.href = "/admin/ezOrgan/retireUserManage.do?page=" + parseInt(sCurPage);
				}
			}
         </script>
	</head>
	<body class="mainbody" onload="makePageSelPage()">
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
		<script type="text/javascript">
			selToggleList(document.getElementById("mainmenu"), "ul", "li", "0");
		</script>
		<%-- <div class="page"> 페이지 네이션 변경으로 인한 주석처리
			<img src="/images/page_previous.gif" align="absmiddle" id=td_Previous onClick="prevPage_onclick()"/> <spring:message code='ezOrgan.t314'/>: <c:out value='${totalPage}'/>&nbsp;&nbsp; -
		  	<input name="txt_PageInputNum" type="text" value="<c:out value='${pPage}'/>" onKeyDown="moveToPage()"/>
		  	<img src="/images/page_next.gif" align="absmiddle" id="Img1" style="cursor:pointer;" onClick="nextPage_onclick()"/>
		</div> --%>
		<div style="width:100%; border-right:1px solid #eaeaea;border-left:1px solid #eaeaea;">
		<table class="mainlist" style="width:100%"> 
			<!-- <form name="frmOutbox" action="BoardItemList.aspx" method="post"></form> -->
		    	<tr>
		      		<th style="padding:0;width:20px;"><input type='checkbox' name="checkbox" onclick="funCheckBox('set','a')" /></th>
		      		<th style="width:150px;"><spring:message code='ezOrgan.t68'/></th>
		      		<th style="width:100px;"><spring:message code='ezOrgan.t67'/></th>
		      		<th style="width:100px;"><spring:message code='ezOrgan.t69'/></th>
		      		<th style="width:100px;"><spring:message code='ezOrgan.t1500'/></th>
		      		<th><spring:message code='ezOrgan.t313'/></th>
		   		</tr>
			   	<!-- list -->
				<c:forEach var="item" items="${list}">
					<tr>
						<td width="20" style="padding:0">
							<input type="checkbox" name="chk" id="chk" value="<c:out value='${item.cn}'/>" />
						</td>
						<c:if test="${lang == '' || lang == 1}">
							<td><c:out value='${item.description}'/></td>
							<td style="cursor:pointer" onclick="ShowUserInfo('<c:out value='${item.cn}'/>')"><c:out value='${item.displayName}'/></td>
							<td><c:out value='${item.title}'/></td>
							<td><c:out value='${item.extensionAttribute10}'/></td>
						</c:if>
						<c:if test="${lang != '' && lang != 1}">
							<td><c:out value='${item.description2}'/></td>
							<td style="cursor:pointer" onclick="ShowUserInfo('<c:out value='${item.cn}'/>')"><c:out value='${item.displayName2}'/></td>
							<td><c:out value='${item.title2}'/></td>
							<td><c:out value='${item.extensionAttribute102}'/></td>
						</c:if>
						<td><c:out value='${fn:substring(item.updateDT, 0, 4)}'/>-<c:out value='${fn:substring(item.updateDT, 4, 6)}'/>-<c:out value='${fn:substring(item.updateDT, 6, 8)}'/></td>
					</tr>	
				</c:forEach>	   
		</table>		
		</div>
     <div style="width:100%;height:100%;position:absolute;top:0;left:0;z-index:1000;background:none rgba(0,0,0,0.5);display:none;" id="progressPanel">&nbsp;</div>
     <span class="loading_layer" style="z-index:6000;position:absolute;top:350px;left:350px;display:none;" id="loadingLayer"><span class="right"><img src="/images/loading/loading.gif" width="24" height="24" ><spring:message code='ezEmail.t680' /></span></span>    
     <br/>
		<div id="tblPageRayer"></div>
	</body>
</html>