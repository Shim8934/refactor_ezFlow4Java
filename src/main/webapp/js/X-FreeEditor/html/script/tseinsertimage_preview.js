	var tseName = parent.document.getElementById("iframe_name").value;
	var oFrame = parent.document.getElementById(tseName);	
	var oRng;
	
	var Array_img = new Array(5);
	var Array_url = new Array();
	var CurrentObj;
	var CurrentObjIndex;
	var oImgWidth = 0;
	var oImgHeight = 0;
	
	var oImage = null;	
	
	if (window.getSelection)	{
		var oSelect = oFrame.contentWindow.window.getSelection();		
		if( parent.select_imageElement != false && parent.select_imageElement != undefined)
			oImage = parent.select_imageElement;				
	}	else if (document.getSelection)	{
		var oSelect = oFrame.contentWindow.document.getSelection();		
		if( parent.select_imageElement != false && parent.select_imageElement != undefined)		
			oImage = parent.select_imageElement;		
	}	else if (document.selection)	{
		var selected_obj = oFrame.contentWindow.document.selection;
		if(selected_obj.type == "Control"){
			var strTagName = selected_obj.createRange().item(0).tagName;
			if(strTagName.toLowerCase() == "img")
				oImage = selected_obj.createRange().item(0);
			else
				oImage = null;
		}	
	}	
	
	function TabKeyDown()
	{
		if(event.keyCode == 9)
		{
			document.getElementById("url").focus();
			 if (event.preventDefault){ 
              event.preventDefault(); 
        } else { 
        event.returnValue = false; 
        } 
		}
	};
	
	function getSelectRng()	{
		if (parent.tseBrowserKind == "msie"){
			try{
				if(parent.m_ClickRag != undefined ){
					if(parent.m_ClickRag.htmlText == undefined){
						oRng = parent.document.getElementById(tseName).contentWindow.document.selection.createRange();
					}else{
						oRng = parent.m_ClickRag;
					}
				}	else	{
					parent.document.getElementById(tseName).contentWindow.document.body.focus();
					oRng = parent.document.getElementById(tseName).contentWindow.document.selection.createRange();
				}
			}catch(e){
				oRng = parent.document.getElementById(tseName).contentWindow.document.selection.createRange();
			}
		}
		
		if(!parent.enterFlag)
		{
			document.getElementById("url").focus();
		}
	};
	
	var pImgObject = function(url, nIndex, strFileName){

		this.url = url;
		this.nIndex = nIndex;
		this.strFileName = strFileName;
	};

	pImgObject.prototype.setUrl = function(url){
		this.url = url;
	};
	pImgObject.prototype.setIndex = function(nIndex){
		this.nIndex = nIndex;
	};
	pImgObject.prototype.setAlt = function(strAlt){
		this.strAlt = strAlt;
	};

	pImgObject.prototype.setValue = function(newUrl, newIndex, nBorder, nWidth, nHeight, nHspace, nVspace, strAlign, strAlt){
		this.url = newUrl;
		this.nIndex = newIndex;
		this.nBorder = nBorder;
		this.nWidth = nWidth;
		this.nHeight = nHeight;
		this.nHspace = nHspace;
		this.nVspace = nVspace;
		this.strAlign = strAlign;
		this.strAlt = strAlt;
	};
	
	pImgObject.prototype.getUrl = function(){
		return this.url;
	};
	pImgObject.prototype.getIndex = function(){
		return this.nIndex;
	};
	pImgObject.prototype.getBorder = function(){
		return this.nBorder;
	};
	pImgObject.prototype.getWidth = function(){
		return this.nWidth;
	};
	pImgObject.prototype.getHeight = function(){
		return this.nHeight;
	};
	pImgObject.prototype.getHspace = function(){
		return this.nHspace;
	};
	pImgObject.prototype.getVspace = function(){
		return this.nVspace;
	};
	pImgObject.prototype.getAlign = function(){
		return this.strAlign;
	};
	pImgObject.prototype.getAlt = function(){
		return this.strAlt;
	};

	pImgObject.prototype.getStyle = function()
	{
		var strStyle = 'style="';
			//html += '<img src="' + document.getElementById("url").value + '"';
			if(this.strAlign != "none")
			{
				strStyle += 'float:'+ this.strAlign +';';
			}

			
			if (this.nWidth != "0" && this.nWidth != "" && this.nWidth != "undefined") {
				strStyle += ' width:' + this.nWidth + 'px;';
			}
			if (this.nHeight != "0" && this.nHeight != "" && this.nHeight != "undefined") {
				strStyle += ' height:' + this.nHeight + 'px;';
			}

			strStyle += '"';
			if (this.strAlt != "" && this.strAlt != "undefined") {
				strStyle += ' alt="' + this.strAlt + '"';
				strStyle += ' title="' + this.strAlt + '"';
			} else {
				var strFileName = document.getElementById("url").value;
				var tmpIndex = strFileName.lastIndexOf("\\");
				if (tmpIndex > 0)
					strFileName = strFileName.substring(tmpIndex + 1, strFileName.length);
				strStyle += ' alt="' + strFileName + '"';
			}

		return strStyle;
	};

	pImgObject.prototype.getHtml = function(){
		var html = '';
		html += '<img src="' + this.url + '" ' +  this.getStyle() + '/>';
		return html;
	};

	

	function AddImage()
	{	
			
		if(document.getElementById("url").value.indexOf("http://") > -1 || document.getElementById("url").value.indexOf("https://") > -1){	// 이미지 경로 체크.
			alert("Url 경로의 이미지는 업로드 할 수 없습니다.");
			return;
		}
		
		if (parent.tseUploadAction() != undefined && parent.tseUploadAction() != "")
		{
			//document.forms[0].action = parent.tseUploadAction();
		
			// iframe 으로 target 설정.
			document.forms[0].target = "UploadFrame";
			document.forms[0].action = parent.tseUploadAction();
			//document.forms[0].submit();


		}
		else
		    document.forms[0].action = "../upload/upload.asp"; //default는 asp로..

		if (document.getElementById("url").value != "")
		{
			if (document.getElementById('FILE_PATH').files)
			{
				//firefox, safari, chrome
				fileSize = document.getElementById('FILE_PATH').files.item(0).fileSize;
				if (fileSize > parent.tseMaxUploadFileSize) {
					alert(parent.sprintf(parent.getString("STRID_TOO_BIG_TO_BE_UPLOADED"), fileSize/1048576, parent.tseMaxUploadFileSize/1048576));
					return;
				}
			}
			else if (parent.tseBrowserKind == "msie")
			{
				//msie
				if (parent.tseBrowserVersion == "6")
				{

				}
				else
				{
					//TODO:size check
				}
			}
			else if (parent.tseBrowserKind == "opera")
			{
				//opera
				//TODO:size check
			}

			var html = 'style="';
			//html += '<img src="' + document.getElementById("url").value + '"';
			
			if (document.getElementById("width").value != "0" && document.getElementById("width").value != "") {
				html += ' width:' + document.getElementById("width").value + 'px;';
			}
			if (document.getElementById("height").value != "0" && document.getElementById("height").value != "") {
				html += ' height:' + document.getElementById("height").value + 'px;';
			}
			
			/*			
			if (document.getElementById("align").value != "" && document.getElementById("align").value != "Default" ) {
				html += ' vertical-align:' + document.getElementById("align").value + ';';
			}	else	{
				html += ' vertical-align:auto;';
			}
			*/
			
			html += '"';
			if (document.getElementById("alt").value != "") {
				html += ' alt="' + document.getElementById("alt").value + '"';
				html += ' title="' + document.getElementById("alt").value + '"';
			} else {
				var strFileName = document.getElementById("url").value;
				var tmpIndex = strFileName.lastIndexOf("\\");
				if (tmpIndex > 0)
					strFileName = strFileName.substring(tmpIndex+1, strFileName.length);
				html += ' alt="' + strFileName + '"';
			}

		
			if (parent.tseBrowserKind == "msie") {
				//oRng.pasteHTML('<span id="xfe_insertImage"></span>');
			}
			document.getElementById("html_holder").value = html;
			parent.tseSetTempAttrs(html);
			parent.setImgRag(oRng);
			document.forms[0].submit();
			document.getElementById("progress_img").src = "images/progress.gif";
			document.getElementById("progress_div").style.display = "";
			//parent.tseInsertHTML(html, oRng);
			//parent.document.getElementById("pop_Frame").src = "";
			//parent.document.getElementById("pop_layer").style.visibility = "hidden";
		} else {
			alert(parent.getString("STRID_IMAGE_NEEDED_SELECTED"));
			return false;
		}
	};

	function FileCheck()
	{
	   var chk = true;
		var str = document.getElementById('FILE_PATH').value;
		var ext = str.substring(str.lastIndexOf(".")+1, str.length);
		var file_Name = str.substring(str.lastIndexOf("\\")+1, str.length);

		if (ext.toLowerCase() == "jpg" || ext.toLowerCase() == "jpeg" ||
		    ext.toLowerCase() == "gif" || ext.toLowerCase() == "png")
		{
			document.getElementById('url').value = str;
			chk = true;
		}
		else
		{
			alert(parent.getString("STRID_UPLOAD_NOT_SUPPORTED_IMAGE"));
			chk = false;
		}
		return chk;
	};

	function onCancel()
	{
		parent.document.getElementById("pop_Frame").src = "";
		parent.document.getElementById("pop_layer").style.visibility = "hidden";
	};

	function tseSpinUp(strName) {
		document.getElementById(strName).value++;
	};

	function tseSpinDown(strName) {
		var minValue = 0;
		if (document.getElementById(strName).value > minValue)
			document.getElementById(strName).value--;
	};
	function getSkinPath(strName)
	{
		return parent.tseDlgSkinPath + strName;
	};

	function setInnerTextProperty() {
		if(typeof HTMLElement != "undefined" && typeof HTMLElement.prototype.__defineGetter__ != "undefined") {
			HTMLElement.prototype.__defineGetter__("innerText",function() {
				if(this.textContent) {
					return(this.textContent)
				} 
				else {
					var r = this.ownerDocument.createRange();
					r.selectNodeContents(this);
					return r.toString();
				}
			});
			
			HTMLElement.prototype.__defineSetter__("innerText",function(sText) {
				this.innerHTML = sText
			});
		}
	};

	function tseInsertThum(strUrl)
	{
		for(var i=0; i< 1; i++)
		{

			var strId = "thumnail_" + i;
			var strHTML = document.getElementById(strId).innerHTML;
		
			strHTML = strHTML.toLowerCase();
			
			//if(strHTML.indexOf("img") < 0)
			//{
				SetBeforeObject();
				InitObject();
				CurrentObjeIndex = i;
				var fileId = "fileName_" + i;
				var str = document.getElementById('FILE_PATH').value;
				var thumnail_Id = "thumnail_image_" + i;
				var file_Name = str.substring(str.lastIndexOf("\\")+1, str.length);
				var strName = file_Name.substring(0, file_Name.lastIndexOf("."));

				//var oImg = '<img src="' + strUrl + '" style="width:130px;height:155px;" id="thumnail_image_' + i + '" alt="' + strName + '">';
				var oImg = '<img src="' + strUrl + '" style="width:100%;height:100%;" alt="' + strName + '">';
	
				document.getElementById(strId).innerHTML = oImg;
				document.getElementById(strId).style.border = "1px solid #fa8072";
				//document.getElementById(fileId).innerHTML = strChk;
				//document.getElementById(fileId).style.border = "1px solid #fa8072";
				//document.getElementById("Display_FileName").innerHTML = file_Name;
				CurrentObj = document.getElementById(thumnail_Id);
				setImageSize();						
				SetImageObject(strUrl, i, file_Name);
//				document.getElementById('FILE_PATH').value = "";
//				document.getElementById('url').value = "";
				break;
			//}

		}

		
		document.getElementById("progress_img").src = "";
		document.getElementById("progress_div").style.display = "none";


	};

	function InitObject()
	{
//		document.getElementById("border").value = 0;
		document.getElementById("width").value  = "";
		document.getElementById("height").value = "";
//		document.getElementById("hspace").value = 0;
//		document.getElementById("vspace").value = 0;
//		document.getElementById("align").selectedIndex = 0;
		document.getElementById("alt").value = "";
	};

	function SetBeforeObject()
	{
		//var strFile = document.getElementById("Display_FileName").innerHTML;
		return;
		if(strFile != "" && strFile != undefined && strFile != null && strFile != " ") {
			var nIndex = 0;			
			var oImg = Array_img[nIndex];

			if(oImg != false){
				oImg = SetImgStyle(oImg);
				Array_img[nIndex] = oImg;
			} else {
				var oMsg = "oImg is null.";
				alert(oMsg);
			}
	
			document.getElementById('thumnail_'+nIndex).style.border = "1px solid #c2c2c2";
			//document.getElementById('fileName_'+nIndex).style.border = "1px solid #c2c2c2";

		}

	};

	function SetImageObject(strUrl, nIndex, strFileName)
	{

		var oImg = new pImgObject(strUrl, nIndex, strFileName);

		oImg = SetImgStyle(oImg);

		Array_img[nIndex] = oImg;

		return oImg;
		

	};

	function SetImgStyle(oImg)
	{		
		if(oImg == null || oImg == false) return false;


		var nBorder = "";
		var nWidth = "";
		var nHeight = "";
		var nHspace = "";
		var nVspace = "";
		var strAlign ="";
		var strAlt = "";


		// Width
		if (document.getElementById("width").value != "0" && document.getElementById("width").value != "") {
			nWidth = document.getElementById("width").value;
		}


		// Height
		if (document.getElementById("height").value != "0" && document.getElementById("height").value != "") {
			nHeight = document.getElementById("height").value;
		}
		
		if(document.getElementById("align_left").checked)
			strAlign = "left";
		else if(document.getElementById("align_right").checked)
			strAlign = "right";
		else
			strAlign = "none";		

/*
		// Align
		if (document.getElementById("align").value != "" && document.getElementById("align").value != "Default" ) {
			strAlign = document.getElementById("align").value;
		}	else	{
			strAlign = "auto";
		}
*/
		if (document.getElementById("alt").value != "") {
				strAlt = document.getElementById("alt").value;
			} else {
				var strFileName = oImg.getUrl();
				var tmpIndex = strFileName.lastIndexOf("/");
				if (tmpIndex > 0)
					strFileName = strFileName.substring(tmpIndex+1, strFileName.length);
				strAlt = strFileName;
			}


		oImg.setValue(oImg.getUrl(), oImg.getIndex(), nBorder, nWidth, nHeight, nHspace, nVspace, strAlign, strAlt);

		return oImg;

	};

	function SetImgInfo(nIndex)
	{
		
		var oImg = Array_img[nIndex];

		if(oImg == null || oImg == false) return false;

		var nBorder = oImg.getBorder();
		var nWidth = oImg.getWidth();
		var nHeight = oImg.getHeight();
		var nHspace = oImg.getHspace();
		var nVspace = oImg.getVspace();
		var strAlign = oImg.getAlign();
		var strAlt = oImg.getAlt();

		// Border
		if (nBorder != "" && nBorder != "undefined") {
			document.getElementById("border").value = nBorder;
		}

		// Width
		if (nWidth != "0" && nWidth != "" && nWidth != "undefined") {
			document.getElementById("width").value = nWidth;
		}


		// Height
		if (nHeight != "0" && nHeight != "" && nHeight != "undefined") {
			document.getElementById("height").value = nHeight;
		}


		// HSpace
		if (nHspace != "" && nHspace != "undefined") {
			document.getElementById("hspace").value = nHspace;
		}

		// VSpace
		if (nVspace != "" && nVspace != "undefined") {
			document.getElementById("vspace").value = nVspace;
		}

		// Align	- top, middle, bottom
		if (strAlign != "" && strAlign != "undefined" ) {
			
			if(strAlign == "left")
				document.getElementById("align_left").checked;
			else if (strAlign == "right")
				document.getElementById("align_rignt").checked;
			else
				document.getElementById("align_none").checked;
			
		}

		if (strAlt != "" && strAlt != "undefined") {
				document.getElementById("alt").value = strAlt;
			} else {
				var strFileName = oImg.getUrl();
				var tmpIndex = strFileName.lastIndexOf("/");
				if (tmpIndex > 0)
					strFileName = strFileName.substring(tmpIndex+1, strFileName.length);
				document.getElementById("alt").value = strFileName;
			}


		//oImg.setValue(oImg.getUrl(), oImg.getIndex(), nBorder, nWidth, nHeight, nHspace, nVspace, strAlign, strAlt);

		//return oImg;

	};


	function setImageSize()
	{			
		document.getElementById("width").value = oImgWidth;
		document.getElementById("height").value = oImgHeight;

	};

	function btnOK()
	{
		if(parent.select_imageElement == false || parent.select_imageElement == undefined)
		{ 
			var html = "";
			if(Array_img[0] == undefined) {
				parent.document.getElementById("pop_Frame").src = "";
				parent.document.getElementById("pop_layer").style.visibility = "hidden";
				return;
			}
			//var strFile = document.getElementById("Display_FileName").innerHTML;
			var nIndex = 0;			
			var oImg = Array_img[nIndex];
			if(oImg != false){
				oImg = SetImgStyle(oImg);
				Array_img[nIndex] = oImg;
			}
	
			
			oImg = Array_img[0];
			html += oImg.getHtml();
			
			
	
			document.getElementById("html_holder").value = html;
			parent.tseSetTempAttrs(html);
			parent.setImgRag(oRng);
	
			parent.tseInsertImageAux_Wiki(html);			
			
		}
		else	// 이미지 수정 할 경우.
		{
			
			if(document.getElementById("height").value != "")
				parent.select_imageElement.style.height = document.getElementById("height").value + "px";
				
			
			if(document.getElementById("width").value != "")
				parent.select_imageElement.style.width = document.getElementById("width").value + "px";						
			
			if(document.getElementById("align_left").checked)
				parent.select_imageElement.style.styleFloat = "left";			
			else if(document.getElementById("align_right").checked)			
				parent.select_imageElement.style.styleFloat = "right";			
			else							
				parent.select_imageElement.style.styleFloat = "";			
			
			parent.select_imageElement.alt = document.getElementById("alt").value;
			
		}
		
		parent.document.getElementById("pop_Frame").src = "";
		parent.document.getElementById("pop_layer").style.visibility = "hidden";
	
		//parent.MM_ShowLayers('pop_layer', parent.tseHTMLPathInsertImage(), 'hide');

	};

	// 이미지 클릭
	function ImgInfo(strId)
	{		
		return;
		var strValue = document.getElementById('thumnail_'+strId).innerHTML;
		strValue = strValue.toLowerCase();
		if(strValue.indexOf("img") < 0) return;
		
		setInnerTextProperty();
		//var strFile = document.getElementById("Display_FileName").innerText;
		//var nIndex = 0;
	
		//if(strFile != "" && strFile != undefined && strFile != " " && strFile != null) 
		//	nIndex = 0;
		
		//var oImg = SetImgStyle(Array_img[nIndex]);
		//Array_img[nIndex] = oImg;

//		document.getElementById('fileName_' + nIndex).style.border = "1px solid #c2c2c2";
		document.getElementById('thumnail_' + nIndex).style.border = "1px solid #c2c2c2";
//		document.getElementById('fileName_' + strId).style.border = "1px solid #fa8072";
		document.getElementById('thumnail_' + strId).style.border = "1px solid #fa8072";

//		document.getElementById("Display_FileName").innerHTML = strId + " : " + document.getElementById('fileName_' + strId).innerText;

		SetImgInfo(strId);

	};

		
	function btnOpt(str)
	{	
		
		if(str == "left")
		{
			document.getElementById("align_left").checked = true;
			document.getElementById("align_none").checked = false;
			document.getElementById("align_right").checked = false;			
		}
		else if(str == "right")
		{			
			document.getElementById("align_left").checked = false;
			document.getElementById("align_none").checked = false;
			document.getElementById("align_right").checked = true;			
		}
		else
		{
			document.getElementById("align_left").checked = false;
			document.getElementById("align_none").checked = true;
			document.getElementById("align_right").checked = false;			
		}	
		
	};
	function tseImagePreview(strUrl){
			var strId = "thumnail_0";
			var strHTML = document.getElementById(strId).innerHTML;			
		
			strHTML = strHTML.toLowerCase();
			
			if(strHTML.indexOf("img") < 0)
			{
				//SetBeforeObject();
				//InitObject();
				//CurrentObjeIndex = 0;
								
				var str = document.getElementById('url').value;
				var thumnail_Id = "thumnail_image_0";
				var file_Name = str.substring(str.lastIndexOf("/")+1, str.length);
				var strName = file_Name.substring(0, file_Name.lastIndexOf("."));

				var oImg = '<img src="' + strUrl + '" style="width:100%;height:100%;" alt="' + parent.select_imageElement.alt + '">';
	
				document.getElementById(strId).innerHTML = oImg;
				document.getElementById(strId).style.border = "1px solid #fa8072";			
				
			}			
			
			
	};
	
	function setImgAttribute(oImage){	
		var str = "";		
	
		if(parent.select_imageElement.src != "")	{
			document.getElementById("url").value = parent.select_imageElement.src;
			tseImagePreview(parent.select_imageElement.src);
		}
		
		if(parent.select_imageElement.style.height != "")	{
			str = parent.select_imageElement.style.height;
			document.getElementById("height").value = str.substring(0, str.lastIndexOf('p'));
		}
		
		if(parent.select_imageElement.style.width != ""){
			str = parent.select_imageElement.style.width;
			document.getElementById("width").value = str.substring(0, str.lastIndexOf('p'));
		}
		
		btnOpt(parent.select_imageElement.style.styleFloat);	// 이미지 정렬 값 체크.		
		
		if(parent.select_imageElement.alt != "")	{
			document.getElementById("alt").value = parent.select_imageElement.alt;
		}		
		
	};
	
	
	
	
	