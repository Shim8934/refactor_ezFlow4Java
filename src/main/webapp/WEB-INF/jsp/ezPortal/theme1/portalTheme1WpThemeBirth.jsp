<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<link href="${util.addVer('/css/theme01.css')}" rel="stylesheet" type="text/css">
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript">
			var strLang1 = "<spring:message code='main.t00026' />";
	        window.onload = function () {
	            getbirthUserList();
	
	
	            try { top.onresize() } catch (e) { }
	        }
	
	        var month = "${curMon}";
	        var xmlBirthhttp = createXMLHttpRequest();
	        var totalCnt = 0;
	        var totalPage = 0;
	        var curPage = 0;
	        var EndCnt = 1;
	        var timer;
	        var PlusNumTwo = 0;
	        var ulang = "${userInfo.lang}";
	        function getbirthUserList() {
	        	 $.ajax({
	    	        	type : "POST",
	    	        	dataType : "text",
	    	        	url : "/ezPersonal/mainBirthUserList.do",
	    	        	data : {
	    	        		mon   : month, 
	    	        	},
	    	        	success : function(xml){		        		
	    	        		getbirthUserList_after(loadXMLString(xml));
	    	        	},
	    	        	error : function(error){
	    	        		console.log(error);	
	    	        	}
	    	    });
	        }
	        function getbirthUserList_after(xml) {
	        	if (xml == null) return;
	
	
	            if (SelectSingleNodeNew(xml, "DATA/ROW") != null) {
	                totalCnt = GetChildNodes(SelectSingleNodeNew(xml, "DATA")).length;
	                totalPage = Math.ceil(totalCnt / EndCnt);
	                for (var i = 0; i < totalCnt; i++) {
	                    var cn = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "CN");
	
	                    var birthType = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "BIRTHTYPE");
	
	                    var birthDate = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "BIRTH");
	
	                    var userName = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DISPLAYNAME");
	                    if (ulang != "1")
	                        userName = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DISPLAYNAME2");
	
	                    var userTitle = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "TITLE");
	                    if (ulang != "1")
	                        userTitle = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "TITLE2");
	
	                    var userDept = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DESCRIPTION");
	
	                    var userDept2 = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "DESCRIPTION2");
	
	                    var userimagesrc = SelectSingleNodeValue(SelectNodes(xml, "DATA/ROW")[i], "EXTENSIONATTRIBUTE2");
	
	
	                    var _dt = document.createElement("dt");
	                    _dt.className = "photo";
	
	                    var _img = document.createElement("img")
						var picNone = "/images/OrganTree/porson_noimg.gif";
						_img.src = (trim_Cross(userimagesrc) != "")? "/admin/ezOrgan/getPersonalInfo.do?fileName=" + userimagesrc : picNone;
						_img.setAttribute('onerror', "this.src='" + picNone + "'");
	                    _img.style.width = "83px";
	                    _img.style.height = "85px";
	
	                    _dt.appendChild(_img);
	
	                    var _dd = document.createElement("dd");
	                    _dd.style.cursor = "pointer";
	                    _dd.onclick = new Function("OpenUserInfo('" + cn + "')");
	                    _dd.className = "txt_name";
	                    _dd.innerHTML = userName + " " + userTitle;
	
	                    var _dd2 = document.createElement("dd");
	                    _dd2.className = "txt_part";
	                    _dd2.innerHTML = userDept;
	                    if (ulang != "1")
	                        _dd2.innerHTML = userDept2;
	
	                    document.getElementById("staff_list").appendChild(_dt);
	                    document.getElementById("staff_list").appendChild(_dd);
	                    document.getElementById("staff_list").appendChild(_dd2);
	
	                    PlusNumTwo = parseInt(PlusNumTwo + 1);
	                    if (i >= (curPage * 1) && i < (curPage + 1) * 1) {
	                        document.getElementById('staff_list').getElementsByTagName('dt')[i].style.display = 'block';
	                        document.getElementById('staff_list').getElementsByTagName('dd')[parseInt(PlusNumTwo - 1)].style.display = 'block';
	                        document.getElementById('staff_list').getElementsByTagName('dd')[PlusNumTwo].style.display = 'block';
	                    }
	                    else {
	                        document.getElementById('staff_list').getElementsByTagName('dt')[i].style.display = 'none';
	                        document.getElementById('staff_list').getElementsByTagName('dd')[parseInt(PlusNumTwo - 1)].style.display = 'none';
	                        document.getElementById('staff_list').getElementsByTagName('dd')[PlusNumTwo].style.display = 'none';
	                    }
	                    PlusNumTwo++;
	                }
	                curPage++;
	                if (curPage >= totalPage) {
	                    curPage = 0;
	                }
	                if (totalCnt > EndCnt) {
	                    timer = window.setInterval("intervalList()", 5000);
	                }
	            }
	            else {
	                var _div = document.createElement("DIV");
	                _div.className = "nodata_h";
	                _div.style.height = "120px"
	
	                var _p = document.createElement("p");
	                var _p2 = document.createElement("p");
	                _p2.innerHTML = strLang1;
	
	                var _image = document.createElement("img");
	                _image.src = "/images/kr/theme01/main/nodata_gray.png";
	                _p.appendChild(_image);
	
	                _div.appendChild(_p);
	                _div.appendChild(_p2);
	
	                document.getElementById("staff_list").appendChild(_div);
	            }
	        }
	        function intervalList() {
	            PlusNumTwo = 0;
	            for (var i = 0; i < totalCnt; i++) {
	                PlusNumTwo = parseInt(PlusNumTwo + 1);
	                if (i >= (curPage * 1) && i < (curPage + 1) * 1) {
	                    document.getElementById('staff_list').getElementsByTagName('dt')[i].style.display = 'block';
	                    document.getElementById('staff_list').getElementsByTagName('dd')[parseInt(PlusNumTwo - 1)].style.display = 'block';
	                    document.getElementById('staff_list').getElementsByTagName('dd')[PlusNumTwo].style.display = 'block';
	                }
	                else {
	                    document.getElementById('staff_list').getElementsByTagName('dt')[i].style.display = 'none';
	                    document.getElementById('staff_list').getElementsByTagName('dd')[parseInt(PlusNumTwo - 1)].style.display = 'none';
	                    document.getElementById('staff_list').getElementsByTagName('dd')[PlusNumTwo].style.display = 'none';
	                }
	                PlusNumTwo++;
	            }
	            curPage++;
	            if (curPage >= totalPage) {
	                curPage = 0;
	            }
	        }
	        function OpenUserInfo(pUserID) {
	            var heigth = window.screen.availHeight;
	            var width = window.screen.availWidth;
	            var left = (width - 500) / 2;
	            var top = (heigth - 400) / 2;
	            window.open("/ezCommon/showPersonInfo.do?id=" + pUserID, "", "height=450px,width=420px, status = no, toolbar=no, menubar=no,location=no, resizable=1,top=" + top + ",left = " + left);
	        }	
		</script>
	</head>
	<body>
		<div class="content_staff" id="content_staff">
			<dl class="content_title02">
    			<dt><spring:message code='main.t00046'/></dt>
    		</dl>
			<dl class="staff_list" id="staff_list"></dl>
		</div>
	</body>
</html>