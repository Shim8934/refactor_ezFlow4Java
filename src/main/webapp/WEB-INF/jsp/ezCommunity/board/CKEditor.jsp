<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<script  type="text/javascript" src="/js/jquery/jquery-1.11.3.min.js"></script>
		<script  type="text/javascript" src="/js/ckEditor/ckeditor.js"></script>
		<script  type="text/javascript" src="/js/XmlHttpRequest.js"  ></script>
		<script  type="text/javascript">
		
		    CKEDITOR.on( 'instanceReady', function( ev )
		    {
			    ExecuteCommand("maximize");
			    parent.DocumentComplete();
		    });
		    
		    // Setdata 후 실행 함수.
		    CKEDITOR.on( 'afterSetData', function( ev )
		    {
		    	parent.FieldsAvailable();
		    });
			
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL(url){
				var tempXML = createXmlDom();
			    var XmlBodyATT = createXmlDom();
			    var XmlBodyDATA = createXmlDom();
			    var tempStr = "";
			    tempStr = ConvertMHTtoHTML(url);
			    tempXML = loadXMLString(tempStr);

			    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
			    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
			    CKEDITOR.instances.editor1.setData(getNodeText(XmlBodyDATA));
			    for (var i = 0; i < GetChildNodes(XmlBodyATT).length; i++) {
			        BodySetAttribute(getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODENAME")), getNodeText(SelectSingleNode(GetChildNodes(XmlBodyATT)[i], "NODEVALUE")))
			    }
			}
			
			function BodySetAttribute(name, Value) {
			    CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
			}
		
			// 웹에디터에 내용 삽입(MHT 파일 url 받음)
			function SetEditorContentURL2(url) {
				var tempXML = createXmlDom();
			    var XmlBodyATT = createXmlDom();
			    var XmlBodyDATA = createXmlDom();
			    var tempStr = "";

			    tempStr = ConvertMHTtoHTML(url);
			    tempXML = loadXMLString(tempStr);

			    XmlBodyATT = GetElementsByTagName(tempXML, 'BODYATTS')[0];
			    XmlBodyDATA = GetElementsByTagName(tempXML, 'BODYDATA')[0];
			    return getNodeText(XmlBodyDATA);
			}
			
			function SetEditorContent(strHtml){
			    //CKEDITOR.instances.editor1.insertHtml(strHtml);
			    CKEDITOR.instances.editor1.setData(strHtml);
			}

			function GetEditorContent(){
			    return CKEDITOR.instances.editor1.getData();
			}
			
			// 에디터 커맨드 실행
		    function ExecuteCommand(commandName){
			    var oEditor = CKEDITOR.instances.editor1;
		     
			    if ( oEditor.mode == 'wysiwyg' )
			    {
				    oEditor.execCommand( commandName );
			    }
		    }
		    
		    function GetBODY(){
		        var BODYTag;
		        var count=0;
		        var i=0;
		    	
		        count = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*").length;		

		        for( i=0; i<count; i++){   
		            if(CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i].tagName == 'BODY'){
				        BODYTag = CKEDITOR.instances.editor1.document.$.getElementsByTagName("*")[i];
		    	    }
		        }
		        return BODYTag;
		    }
		     

		    function BodySetAttribute(name, Value){
		        CKEDITOR.instances.editor1.document.$.body.setAttribute(name, Value, 0);
		    }
		</script>
	</head>
	<body>
		<textarea cols="80" id="editor1" name="editor1" rows="10"></textarea>
		<script type="text/javascript">CKEDITOR.replace( 'editor1', {fullPage : false} );</script>
		<script type="text/javascript">
			if("${userInfo.lang}" == "1"){
				CKEDITOR.config.font_defaultLabel = '굴림';
			    CKEDITOR.config.font_names = '맑은 고딕; 돋움; 굴림; 궁서; 바탕;' + CKEDITOR.instances.editor1.config.font_names;
			    CKEDITOR.config.language = "ko";
			}else if("${userInfo.lang}" == "2"){
				CKEDITOR.config.font_defaultLabel = 'Gulim';
			    CKEDITOR.config.font_names = 'Malgun Gothic; Dotum; Gulim; Gungsuh; Batang;' + CKEDITOR.instances.editor1.config.font_names;
			    CKEDITOR.config.language = "en";
			}else if("${userInfo.lang}" == "3"){
				CKEDITOR.config.font_defaultLabel = 'Gulim';
			    CKEDITOR.config.font_names = 'Malgun Gothic; Dotum; Gulim; Gungsuh; Batang;' + CKEDITOR.instances.editor1.config.font_names;
			    CKEDITOR.config.language = "ja";
			}else{
				CKEDITOR.config.font_defaultLabel = 'Gulim';
			    CKEDITOR.config.font_names = 'Malgun Gothic; Dotum; Gulim; Gungsuh; Batang;' + CKEDITOR.instances.editor1.config.font_names;
			    CKEDITOR.config.language = "zh";
			}
		</script>
	</body>
</html>