 var tseName = parent.document.getElementById("iframe_name").value;
var oRng;

function getSelectRng()
{
	if (parent.tseBrowserKind == "msie")
	{
    parent.document.getElementById(tseName).contentWindow.document.body.focus();
    oRng = parent.document.getElementById(tseName).contentWindow.document.selection.createRange();
  }
};

function AddEmbedObject()
{
    if (parent.tseUploadAction() != undefined && parent.tseUploadAction() != "")
        document.forms[0].action = parent.tseUploadAction();
    else
        document.forms[0].action = "../upload/upload.asp"; //default는 asp로..

    if (document.getElementById("url").value != "")
    {
	if (document.getElementById('FILE_PATH').files)
	{
		//firefox, safari, chrome
		fileSize = document.getElementById('FILE_PATH').files.item(0).fileSize;
		if (fileSize > parent.tseMaxUploadFileSize) {
			alert(parent.getString("STRID_TOO_BIG_TO_BE_UPLOADED", fileSize/1048576, parent.tseMaxUploadFileSize/1048576));
			return;
		}
	}
	else if (parent.tseBrowserKind == "msie")
	{
		//msie
		if (parent.tseBrowserVersion == "6")
		{
			//msie 6 (dynsrc 속성 사용 가능함)
			image = new Image();
			image.dynsrc = document.getElementById("url").value;
			fileSize = image.fileSize;
			if (fileSize > parent.tseMaxUploadFileSize) {
				alert(parent.getString("STRID_TOO_BIG_TO_BE_UPLOADED", fileSize/1048576, parent.tseMaxUploadFileSize/1048576));
				return;
			}
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

        var html = "";
        //html += '<img src="' + document.getElementById("url").value + '"';
        if (document.getElementById("border").value != "") {
            html += ' border="' + document.getElementById("border").value + '"';
        }
        if (document.getElementById("width").value != "0" && document.getElementById("width").value != "") {
            html += ' width="' + document.getElementById("width").value + '"';
        }
        if (document.getElementById("height").value != "0" && document.getElementById("height").value != "") {
            html += ' height="' + document.getElementById("height").value + '"';
        }
        if (document.getElementById("hspace").value != "") {
            html += ' hspace="' + document.getElementById("hspace").value + '"';
        }
        if (document.getElementById("vspace").value != "") {
            html += ' vspace="' + document.getElementById("vspace").value + '"';
        }
        if (document.getElementById("align").value != "" && document.getElementById("align").value != "Default") {
            html += ' align="' + document.getElementById("align").value + '"';
        }
        //html += ' />';

        document.getElementById("html_holder").value = html;
        parent.tseSetTempAttrs(html);
        document.forms[0].submit();
        document.getElementById("progress_img").src = "images/progress.gif";
        document.getElementById("progress_div").style.display = "";
        //parent.tseInsertHTML(html, oRng);
        //parent.document.getElementById("pop_Frame").src = "";
        //parent.document.getElementById("pop_layer").style.visibility = "hidden";

    } else {
        alert(parent.getString("STRID_FLASH_NEEDED_SELECTED"));
    }
};

function FileCheck()
{
var chk = true;
var str = document.getElementById('FILE_PATH').value;
var ext = str.substring(str.lastIndexOf(".") + 1, str.length);
var file_Name = str.substring(str.lastIndexOf("\\") + 1, str.length);

if (ext.toLowerCase() == "swf") {
    document.getElementById('url').value = str;
    chk = true;
}
else
{
	alert(parent.getString("STRID_NOT_FLASH_MOVIE"));
	chk = false;
}
return chk;
};

function onCancel()
{
  var layer = parent.document.getElementById("pop_layer");
  var frame = parent.document.getElementById("pop_Frame");

  layer.removeChild(frame);
  layer.style.visibility = "hidden";
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
