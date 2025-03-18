<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
	<head>
		<title><spring:message code='ezApprovalG.t55'/></title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<link rel="stylesheet" href="${util.addVer('/css/default.css')}" type="text/css" />
		<link rel="stylesheet" href="${util.addVer('main.default.css', 'msg')}" type="text/css" />
		<script type="text/javascript" src="${util.addVer('ezApprovalG.e1', 'msg')}" ></script>
		<script type="text/javascript" src="${util.addVer('/js/jquery/jquery-1.11.3.min.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/XmlHttpRequest.js')}"></script>
		<script type="text/javascript" src="${util.addVer('/js/mouseeffect.js')}"></script>
		<script type="text/javascript">
            var returnFunction;
            var returnValue = new Object();
            var mode = "<c:out value='${mode}'/>"// new/edit
            var docID = "<c:out value='${summary.docID}'/>";
            var summaryPath = "<c:out value='${summary.summaryPath}'/>"; // 요약전 mht 파일 경로
            var summaryContent = ""; // 요약전 내용 텍스트
            var summaryContentMht = ""; // mht로 변환된 내용 텍스트
            
            window.onload = function () {
                returnFunction = parent.btnSummaryEdit_Complete;
                if (!returnFunction) {
                    returnFunction = opener.btnSummaryEdit_Complete;
                }
                
                if (!returnFunction) {
                    alert(strLangJIH_Summary03);
                    parent.DivPopUpHidden();
                }
                document.getElementById("txt_SummaryContent").focus();
            };
            
            function Editor_Complete() {
                if (mode == "edit") {
                    var htmlData = message.GetEditorContentURL(summaryPath);
		            message.SetEditorContent(htmlData);
                }
			}
            
            function btn_SummaryCancel_onclick() {
                returnValue.status = "cancel";
                returnFunction(returnValue);
            }
            
            function btn_SummarySave_onclick() {
                var status = saveSummaryFile();
                
                console.log("status: " + status);
                returnValue.status = status;
                returnValue.summary = summaryContent;
                returnValue.summaryPath = summaryPath;
                returnFunction(returnValue);
            }
            
            // 파일업로드 후 summary_complete 함수 호출
            function saveSummaryFile() {
                var ret;
                var convert = makeSummaryContentAndMHT();
                
                if (!summaryContent.trim()) {
                    return "noData";
                } else if (convert == "error") {
                    return "error"
                }
              
		        $.ajax({
		    		type : "POST",
		    		dataType : "json",
		    		async : false,
		    		url : "/ezApprovalG/saveApprGSummary.do",
		    		data : {
		    		    summaryMht: summaryContentMht,
		    		    summary: summaryContent,
		    		    docID: docID
		    		},
		    		success: function(result) {
		    			if (result.status === "success" && !!result.path) {
		    			    ret = "success";
		    			    summaryPath = result.path;
		    			} else {
		    			    console.log("saveSummaryFile no result.path error");
		    			    ret = "error";
		    			}
		    		},
		    		error: function(error) {
		    		    console.log(error);
		    		    ret = "error";
		    		}
		    	});
		    	return ret;
		    }
            
            // 작성한 요약전을 텍스트와 mht본문텍스트로 컨버팅하여, 성공 여부를 success/error 텍스트로 반환
            function makeSummaryContentAndMHT() {
                try {
                    summaryContent = message.GetEditorContent();        
                    summaryContentMht = summaryContent.replace(/&quot;/gi, "\'");
                    
                    //html 태그를 제거
                    summaryContent = summaryContent.replace(/(<([^>]+)>)/gi, "");
                    
                    if (summaryContentMht.indexOf("url(\'/") > -1) {
                        summaryContentMht = summaryContentMht.replace("url(\'/", "url(\'");
                    }
                    
                    /* 2019-04-01 홍승비 - MHT파일 변환 및 저장 시 예외처리 추가 */
                    summaryContentMht = ConvertHTMLtoMHT("<HTML>" + GetCKEditerHeader() + "<BODY>" + summaryContentMht + "</BODY>" + "</HTML>", "");
                    return "success";      
                } catch (e) {
                    console.log(e);
                    return "error";
                }
            }
		</script>
	</head>
	<body class="popup">
	    <h1><spring:message code='ezApprovalG.t1203'/></h1>
	    <div id="close">
            <ul><li><span onclick="return btn_SummaryCancel_onclick()"></span></li></ul>
        </div>
        
	    <iframe id="txt_SummaryContent" class="viewbox" name="message" src="/ezEditor/selectEditor.do" style="padding: 0; height: 450px; width: 100%; overflow: auto; margin-top:-1px"></iframe>
	    
	    <div class="btnposition btnpositionNew">
		    <a class="imgbtn" id="bbtn_SummarySave"><span id="btn_SummarySave" onClick="return btn_SummarySave_onclick()"><spring:message code='ezApprovalG.t1767'/></span></a>
	    </div>
	    
	    <div style="width: 100%; height: 100%; position: absolute; top: 0; left: 0; z-index: 1000; background: none rgba(0,0,0,0.5); display: none;" id="mailPanel">&nbsp;</div>
	    <div class="layerpopup"  style="z-index: 2000; position: absolute;display: none;" id="iFramePanel">
			<iframe src="<spring:message code='main.kms4' />" style="border:none;" id="iFrameLayer"></iframe>
		</div>
	</body>
</html>
