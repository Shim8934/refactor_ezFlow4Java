<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link href="${util.addVer('main.e6', 'msg')}" rel="stylesheet" type="text/css">
		<section  class="body_bg1">
			<article class="portletbox birthbox ">
				<div class="title">
					<span class="tl" ></span>
					<span class="tr"></span>
					<span class="title_txt">
						<img src="/images/kr/main/btn_calendar_prev.gif" class="btn_img" onclick="moveBirth('PREV')">
							<span id="kordisplay">
								<span id="curMon"></span><spring:message code='main.t1002' />
							</span>
							<span id="curMontxt"></span>
							<img src="/images/kr/main/btn_calendar_next.gif" class="btn_img" onclick="moveBirth('NEXT')">
							<%-- <span class="t11"><spring:message code='main.t1003' /></span> --%> 
					</span>
        		</div>
        		<div class="birthcont" id="birthcont">
            		<ul class="fl" id="userlist">
            		</ul>
        		</div>
        		<div class="birthcont" id="nodata_NewBirth" style="display:none;">
            		<div class="nodata_portlet">
                		<p>
                    		<img width="92" height="84" src="/images/kr/main/nodata_plan.png" />
                		</p>
                		<p>
                    		<spring:message code='main.t00026' />
                		</p>
            		</div>
        		</div>
        		<div class="guide"></div>
    		</article>
		</section>
		
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var month = "${curMon}";
	    	var totalCnt = 0;
	    	var totalPage = 0;
	    	var curPage = 0;
	    	var EndCnt = 10;
	    	var timer;
	    	var xmlhttp;
	    	var strLang1_NewBirth = "<spring:message code='main.t00026'/>";
	    	document.onselectstart = function () { return false; };
	    	
	    	function window_onload_NewBirth(){
		        if (navigator.userAgent.indexOf('Firefox') != -1) {
	            	document.body.style.MozUserSelect = 'none';
	            	document.body.style.WebkitUserSelect = 'none';
	            	document.body.style.khtmlUserSelect = 'none';
	            	document.body.style.oUserSelect = 'none';
	            	document.body.style.UserSelect = 'none';
	        	}
		        
		        if (month < 10 && String(month).length == 1)
		            month = "0" + month;
		        
		        if (CrossYN())
		            document.getElementById("curMon").textContent = month;
	    	    else
	        	    document.getElementById("curMon").innerText = month;

	        	try { top.onresize() } catch (e) { }
	        	
	        	getbirthUserList();
	    	}
	    	
	    	function getbirthUserList() {
	    		window.clearTimeout(timer);
	    		
	    		var request = new XMLHttpRequest();
				request.open('POST', '/ezPersonal/mainBirthUserList.do', true);
				request.setRequestHeader('content-type', 'application/json');
				
				request.onload = function() {
					getbirthUserList_after(JSON.parse(request.responseText));
				}
				
				var data = JSON.stringify({
					month : month
				});
				
				request.send(data);
	    	}
	    	
	    	var userPrimary = "${primary}";
	    	
	    	function getbirthUserList_after(result) {
		        if (result == null) {
		        	return;
		        }

		        if (document.getElementById("userlist").innerHTML != "") {
		        	document.getElementById("userlist").innerHTML = "";
		        }
		        
		        birthList = result.list;
		        
		        if (birthList.length != 0) {
			        totalCnt = birthList.length;
			        totalPage = Math.ceil(totalCnt / EndCnt);
			        
		        	document.getElementById("birthcont").style.display = "";
	            	document.getElementById("nodata_NewBirth").style.display = "none";
		        }
		        
		        birthList.forEach(function (item, index) {
		        	var cn = item.cn;
	                var birthType = item.birthType;
    	            var birthDate = item.birth.substr(5, 10);
        	        var userName = item.displayName;
                	var userTitle = item.title;
                    
	                var _li = document.createElement("li");
	                _li.style.display = "none";
    	            _li.style.cursor = "pointer";
        	        _li.onclick = new Function("OpenUserInfo('" + cn + "');");
        	        
            	    if (CrossYN())
                	    _li.textContent = "[" + birthDate + "]" + userName + " " + userTitle;
                	else
                    	_li.innerText = "[" + birthDate + "]" + userName + " " + userTitle;
            	    
                	document.getElementById("userlist").appendChild(_li);

                	if (index >= (curPage * 10) && index < (curPage + 1) * 10) {
	                    document.getElementById('userlist').getElementsByTagName('li')[index].style.display = 'block';
                	} else {
                    	document.getElementById('userlist').getElementsByTagName('li')[index].style.display = 'none';
                	}
		        });
		        
		        if (birthList.length != 0) {
					curPage++;
		            
	    	        if (curPage >= totalPage) {
	        	        curPage = 0;
	            	}
	    	        
	            	if (totalCnt > EndCnt) {
		                timer = window.setInterval("intervalList()", 5000);
		            }
		        } else {
		        	document.getElementById("birthcont").style.display = "none";
	            	document.getElementById("nodata_NewBirth").style.display = "";
		        }
		    }

		    function intervalList() {
	    	    for (var i = 0; i < totalCnt; i++) {
	        	    if (i >= (curPage * 10) && i < (curPage + 1) * 10) {
	            	    document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'block';
	            	} else {
	                	document.getElementById('userlist').getElementsByTagName('li')[i].style.display = 'none';
	            	}
	        	}
	    	    
	        	curPage++;
	        	
	        	if (curPage >= totalPage) {
		            curPage = 0;
		        }
	    	}

	    	function moveBirth(page) {
		        switch (page) {
		            case "PREV":
	    	            if (month != 1)
	        	            month = month - 1;
	            	    else
	                	    month = 12;
	                	break;
	            	case "NEXT":
		                if (month != 12)
		                    month = Number(month) + 1;
	    	            else
	        	            month = 1;
	            	    break;
	        	}
		        
	        	if (month < 10 && String(month).length == 1)
		            month = "0" + month;

	        	if(CrossYN())
		            document.getElementById("curMon").textContent = month;
	        	else
		            document.getElementById("curMon").innerText = month;
	        	
	        	curPage = 0;
	        	getbirthUserList();
	    	}
	    	
	    	function OpenUserInfo(pUserID) {
		        var heigth = window.screen.availHeight;
	        	var width = window.screen.availWidth;
	        	var left = (width - 500) / 2;
	        	var top = (heigth - 400) / 2;
	        	
	        	window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=438px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	    	}
	    	
	    	window_onload_NewBirth();
		</script>
	</head>
</html>