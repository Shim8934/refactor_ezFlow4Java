<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><spring:message code='ezPortal.t147'/></title>
		<link rel="stylesheet"  href="<spring:message code='ezPortal.e2'/>" type="text/css">
		<script type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script src="/js/XmlHttpRequest.js" type="text/javascript" ></script>
		<script type="text/javascript">
		var htmlData = "${htmlData}";
		function MhtConvertCross() {
		    //var fullPath = document.location.protocol + "//" + document.location.hostname + "/ezCommon/downloadAttach.do?filePath=" + "${htmlData}";
		    var fullPath = "${htmlData}";
		    //document.getElementById('message').src = "/ezCommon/mhtToHTMLContent.do?href=" + fullPath;
		    
	   	    try {
	   	    	var html = "";
				$.ajax({
					type : "POST",
					dataType : "text",
					async : false,
					url : "/ezCommon/mhtToHTMLContent.do",
					data : { type	:	"HTMLPORTLET", 
							  href	:	fullPath
						   },
					success: function(result){
						html = result;
					}
				});

				var doc = document.getElementById('message').contentWindow.document;
				doc.open();
				doc.write(html);
				doc.close();
				var message = $('message'); 
				message.html(html);
	   	    } catch (e) {
	   	        alert(e.description);
	   	    }
		   
		}
		
		//2007.06.21 SSL 적용후 본문에 이미지가 들어간 mht로드시 보안 경고창 뜨는 오류 수정함.
	    function ImageUrl(pUrl, cnt) {
	        var link = "/myoffice/Common/ImgFileRead.asp?PUrl=" + pUrl+"&Cnt="+cnt;
    		
		    return link;
	    }
		
		function window_onload() {
		    //DocSummary.innerHTML = "<table><tr><td class='normaltd'>" + MhtConvert() + "</td></tr></table>";	
		    if (CrossYN()) {
		        document.getElementById("DocSummary").style.display = "none";
		        MhtConvertCross();
		        AddLinkTarget();
		    } else {
		        document.getElementById("message").style.display = "none";
		        DocSummary.innerHTML = "<table><tr><td class='normaltd'>" + MhtConvert() + "</td></tr></table>";	
			    var linkColl = document.all.tags("A");
			    for (var i=0; i<linkColl.length; i++) 
			    linkColl.item(i).target = "_blank"; 
		    }
		}
		
		function MhtConvert() {
			var fullPath = document.location.protocol+"//" + document.location.hostname + "${htmlData}";

			objMHT.sync = true;
			var strMht = objMHT.DownloadURL(fullPath);

			objMHT.mhtData = strMht;
			objMHT.filterIn();
            
            var ret = objMHT.htmlData;	
            
            //2007.06.21 SSL 적용후 본문에 이미지가 들어간 mht로드시 보안 경고창 뜨는 오류 수정함.
		    if(window.location.protocol.toLowerCase() == "https:") {
		        var idx = 0; var start = 0;
		        while (ret.indexOf("src=\"", start) > 0 ) {
		            start = ret.indexOf("src=\"", start);
		            var end = ret.indexOf("\"", start+5);
		            var link = ImageUrl("${htmlData}", idx);
		            ret = ret.substring(0, start+5) + link + ret.substring(end);
    			    
		            idx = idx + 1;
		            start = end;			    
		        }
		    }
            
			return ret;
		}
		
		function AddLinkTarget() {
		    try {
		        var objTags = document.getElementById('message').getElementsByTagName("a");
		        for (var i = 0 ; i < objTags.length ; i++) {
		            if (objTags.item(i).href.indexOf("javascript:") == -1)
		                objTags.item(i).target = "_blink";
		        }
		    }
		    catch (e) { }
		}
		</script>
	</head>
	<body onload="javascript:window_onload()">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" height="100%">
			<tr>
				<td width="5"></td>
				<td valign="top">
                        <div id="DocSummary" style="PADDING-TOP:3px"></div>
                        <iframe id="message" class="viewbox" name="message" frameborder="0" style="padding:0; height:100%; width:100%; overflow:auto;"></iframe>
				</td>
			</tr>
		</table>
	</body>
</html>