<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
	    <title></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/ezPersonal/ListView_list.js')}"></script>
	    <script type="text/javascript">
	        var userid = "${userInfo.id}";
	        var SignImageSize = "${signImageSize}";
	        var SignPath = "${signPath}";
	        var pNoneActiveX = "YES";
	        var extension;
	        
	        window.onload = function () {
	            GetSignInfo();
	        };
	
	        function GetSignInfo() {
	        	$.ajax({
	        		type : "POST",
	        		dataType : "text",
	        		async : false,
	        		url : "/admin/ezOrgan/getEntryInfo.do",
	        		data : {
	        			cn 	  : userid,
	        			prop  : "extensionAttribute3"
	        		},
	        		success: function(xml){
	        			xmlDom = loadXMLString(xml);
		                var signinfo = SelectSingleNodeValueNew(xmlDom, "DATA/EXTENSIONATTRIBUTE3");
		                imagelist = signinfo.split(";");
		
		
		                document.getElementById("lvDocList").innerHTML = "";
						var getXml = "";
		                if (trim_Cross(signinfo) != "") {
		                    	getXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + "<spring:message code='ezPersonal.t3001'/>" + "</NAME><WIDTH>100</WIDTH></HEADER></HEADERS><ROWS>";
		                    for (var i = 0; i < imagelist.length; i++) {
		                        getXml += "<ROW><CELL>";
		                        getXml += "<VALUE>";
		                        getXml += "<spring:message code='ezPersonal.t3002'/>" +i;
		                        getXml += "</VALUE>";
		                        getXml += "<DATA1><![CDATA[";
		                        getXml += imagelist[i];
		                        getXml += "]]></DATA1>";
		                        getXml += "</CELL></ROW>";
		                    }
		                    getXml += "</ROWS></LISTVIEWDATA>";
		                }
		                else {
		                    getXml = "<LISTVIEWDATA><HEADERS><HEADER><NAME>" + "<spring:message code='ezPersonal.t3001'/>" + "</NAME><WIDTH>100</WIDTH></HEADER></HEADERS><ROWS></ROWS></LISTVIEWDATA>";
		                }
		                var ChangeXml = createXmlDom();
		                ChangeXml = loadXMLString(getXml);
		
		                var DocList = new ListView();
		                DocList.SetID("DocList");
		                DocList.SetMulSelectable(false);
		                DocList.SetSelectFlag(false);
		                DocList.SetRowOnClick("event_click");
		                DocList.DataSource(ChangeXml);
		                DocList.DataBind("lvDocList");
		                DocList = null;
	        		},
	        		error: function(){
	        			showAlert("<spring:message code='ezPersonal.t3003'/>");
	        		}
	        	});
	        }
	        var selData;
	        function event_click(obj) {
	            var fname = document.getElementById(obj).getAttribute("DATA1");	            
	            selData = fname;	            
	            
	            ContentDescription.innerHTML = "<img style='padding-top: 60px;' src=" + "/ezApprovalG/approvalGSign.do?type=" + SignPath + "&fileName=" + fname + " width=50 height=50>";
	        }
		
		    function trim(str) {
		        while (str && str.indexOf(" ") == 0)
		            str = str.substring(1);
		
		        while (str && str.lastIndexOf(" ") == str.length - 1)
		            str = str.substring(0, str.length - 1);
		
		        return str;
		    }
		
		    function del_sign() {
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		
		        if (DocList.GetSelectedRows().length == 0) {
		            showAlert("<spring:message code='ezPersonal.t3004'/>");
				    return;
		        }
		
		        var selName;
		        if (CrossYN())
		            selName = getNodeText(DocList.GetSelectedRows()[0]);
		        else
		            selName = DocList.GetSelectedRows()[0].innerText;
		
		        if (!confirm("'" + selName.replace( /(\s*)/g, "") + "'" + "<spring:message code='ezPersonal.t3005'/>"))
			        return;
		
			    var DocList = new ListView();
			    DocList.LoadFromID("DocList");
			    var Rowcnt = DocList.GetDataRows();
			    var curData = DocList.GetSelectedRows();
		
			    var imagelist = "";
			    for (var i = 0; i < Rowcnt.length; i++) {
			        if (Rowcnt[i].getAttribute("data1") != curData[0].getAttribute("data1")) {
			            if (imagelist != "")
			                imagelist += ";" + Rowcnt[i].getAttribute("data1");
			            else
			                imagelist = Rowcnt[i].getAttribute("data1");
			        }
			    }
			    
				$.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezApprovalG/saveSingInfo.do",
					data : {
							parentCn 	: "", 
							cn 			: userid, 
							prop 		: "", 
							extensionAttribute3 : imagelist
							},
					success : function(result){
						if(result != "OK"){
							showAlert("<spring:message code='ezPersonal.t3006' />");
						}else{
							showAlert("<spring:message code='ezPersonal.t3007' />");
							ContentDescription.innerHTML = '<div style="padding-top:80px;">' + "<spring:message code='ezPersonal.t3012'/>" + "</div>";
							GetSignInfo();
						}
					},
					error : function(){
						showAlert("<spring:message code='ezPersonal.t189' />");
					}
				});
		    }
		    
		    function btn_AttachAdd_onclick(obj) {
		        if (document.form.file1.value != "") {
		            var frm = new FormData();
		            
		            frm.append("file1", document.getElementById("form").file1.files[0]);
		            
		            extension = document.getElementById("file1").value.split('.');
				    var check = false;
				    check = compareExtension(check, extension[extension.length - 1]);
				    
				    if (!check || extension == null) {
		    		    showAlert("<spring:message code='ezPersonal.t206'/>" + " <spring:message code='ezPersonal.t200'/>");
		        		document.getElementById("file1").value = "";
		    		} else {
		            xhr = new XMLHttpRequest();
		            xhr.addEventListener("load", returnvalue, false);
		            
		            if (SignPath == "APPROVALGSIGN") {
		            	mode = "GLOGO";
		            } else {
		            	mode = "LOGO";
		            }
		            
		            xhr.open("POST", "/admin/ezOrgan/signImageUpload.do?mode="+mode+"&userID=" + userid);
		            xhr.send(frm);
		            
		            //2019-04-30 천성준 - 같은 이름의 파일이 첨부가 안되는현상 때문에 첨부완료후 파일첨부란 초기화 
		            document.form.file1.value = "";
		    		}
		        }
		    }
		
		    function add_sign(ocx_file) {
		        if (CrossYN() || pNoneActiveX == "YES") {
		            document.form.file1.click();
		        }
		    }

			function compareExtension(check, extension) {
	    		var filterExtension = new Array("jpe", "jpg", "jpeg", "gif", "png", "bmp", "ico", "svg", "svgz", "tif", "tiff", "ai", "drw", "pct", "psp", "xcf", "psd", "raw");
	    		for (var i = 0; i < filterExtension.length; i++) {
	    			if (extension != null) {
		        		if (extension.toLowerCase() == filterExtension[i]) {
		            		check = true;
		            		break;
		        		}
	    			}
	    		}
	    		return check;
			}
		
			/* 2021-12-08 홍승비 - 전자결재 서명 업로드 시 서버단에서도 이미지 확장자 체크 진행 */
		    function returnvalue() {
		    	if (xhr.responseText == "UPLOAD_ERROR") {
					showAlert(document.form.file1.value + " <spring:message code='ezPersonal.t3010'/>" + "\n\n");
					return;
		    	} else if (xhr.responseText == "UPLOAD_EXT_ERROR") {
		            showAlert("<spring:message code='ezAttitude.t260'/>");
		            return;
		    	} else {
					fileName = xhr.responseText;
		    	}
		        
		        var imagelist = "";
		        
		        var DocList = new ListView();
		        DocList.LoadFromID("DocList");
		        var Rowcnt = DocList.GetDataRows();
		        for (var i = 0; i < Rowcnt.length; i++) {
		            imagelist += Rowcnt[i].getAttribute("data1") + ";";
		        }

		        if (imagelist == "")
		            imagelist = fileName;
		        else
		            imagelist += fileName;
		
		        $.ajax({
					type : "POST",
					dataType : "text",
					url : "/ezApprovalG/saveSingInfo.do",
					data : {
							parentCn 	: "", 
							cn 			: userid, 
							prop 		: "", 
							extensionAttribute3 : imagelist
							},
					success : function(result){
						if(result != "OK"){
							showAlert(filename + "<spring:message code='ezPersonal.t3010' />");
						}else{
							showAlert("<spring:message code='ezPersonal.t281' />");
							GetSignInfo();
						}
					}
				});
		    }
		</script> 
	</head>
	<body> 
		<br/>
		<%-- <h2>▒&nbsp;<spring:message code='ezPersonal.t3011'/></h2> --%>
		<span class="txt">▒ <spring:message code='ezPersonal.t3011' /></span>
		<table style="width: 300px; height: 150px; margin-top:10px" border="0">
			<tr>
	            <td>
	                <div style="border: 1px solid #dbdbda; width: 200px; height: 200px; border-top: 0px; overflow: auto;">
	                    <div id="lvDocList"></div>
	                </div>
	            </td>
	            <td style="vertical-align: top">
	                <div style="border: 1px solid #dbdbda; width: 200px; height: 200px; overflow-y: auto; margin: 0px 5px 0px 5px;">
	                    <div id="ContentDescription" style="margin-top: 1px; margin: 5px 5px 5px 5px;vertical-align:middle;text-align:center;">
	                        <div style="padding-top:80px;"><spring:message code='ezPersonal.t3012'/></div>
	                    </div>
	                </div>
	            </td>
	        </tr>
	    </table>		
		<div class="btnpositionJsp" style="width:395px;">
		    <a class="imgbtn" onClick="add_sign()"><span><spring:message code='ezPersonal.t3013'/></span></a>
		    <a class="imgbtn" onClick="del_sign()"><span><spring:message code='ezPersonal.t3014'/></span></a>
		</div>
	    <iframe name="ifrm" src="about:blank" style="display: none"></iframe>
		<form method="post" id="form" name="form" enctype="multipart/form-data" target="ifrm">
			<input type="file" name="file1" id="file1" onchange="btn_AttachAdd_onclick()" style="width: 1px; height: 1px; display: none;" accept="image/*"/>
		</form>
		<div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
		<div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>