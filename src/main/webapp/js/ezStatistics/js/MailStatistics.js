
function GetElementsByTagName(pObjElm, pTagName)
{
    var idx = 0;
    var elements = new Array();

    if (window.ActiveXObject)
    {
        return pObjElm.getElementsByTagName(pTagName);
    }
    else if (window.DOMParser)
    {
        for (var i = 0; i < pObjElm.childNodes.length; i++)
        {
            if (pObjElm.childNodes[i].toString() == "[object Element]" && pObjElm.childNodes[i].tagName == pTagName)
            {
                elements[idx++] = pObjElm.childNodes[i];
            }
        }
    }

    return elements;
}

function SelectSingleNodeValue(pObjElm, pTagName)
{
    var strValue = "";

    if (window.ActiveXObject)
    {
        if (pObjElm.selectSingleNode(pTagName))
            return pObjElm.selectSingleNode(pTagName).text;
    }
    else if (window.DOMParser)
    {
        var objNode = pObjElm.firstChild;

        while (objNode)
        {
            if (objNode.toString() == "[object Element]" && objNode.tagName == pTagName)
            {
                if (objNode.firstChild != null && objNode.firstChild.nodeValue != null)
                {
                    strValue = objNode.firstChild.nodeValue;
                }

                break;
            }
            else
                objNode = objNode.nextSibling;
        }
    }

    return strValue;
}

function GetSizeFormat(val)
{
    if (isNaN(val) || parseInt(val) == 0 || val == '-' || val == null || val == '0' || val == "" || val == '')
        return val;
   
    var rtnVal = val + " byte";

    if (val > 1024)
    {
        val = val / 1024;
        rtnVal = Math.round(val) + " Kb";
    }

    if (val > 1024)
    {
        val = val / 1024;
        rtnVal = Math.round(val) + " Mb";
    }

    if (val > 1024)
    {
        val = val / 1024;
        rtnVal = Math.round(val) + " Gb";
    }

    return rtnVal;
}

function DateCalc(pInterval, pAddVal, pYyyymmdd, pDelimiter)
{
	var yyyy;
	var mm;
	var dd;
	var cDate;
	var oDate;
	var cYear, cMonth, cDay;

	if (pDelimiter != "")
	{
		pYyyymmdd = pYyyymmdd.replace(eval("/\\" + pDelimiter + "/g"), "");
	}

	yyyy = pYyyymmdd.substr(0, 4);
	mm  = pYyyymmdd.substr(4, 2);
	dd  = pYyyymmdd.substr(6, 2);

	if (pInterval.toUpperCase() == "Y")
	{
		yyyy = (yyyy * 1) + (pAddVal * 1);
	}
	else if (pInterval.toUpperCase() == "M")
	{
		mm  = (mm * 1) + (pAddVal * 1);
	}
	else if (pInterval.toUpperCase() == "D")
	{
		dd  = (dd * 1) + (pAddVal * 1);
	}

	cDate = new Date(yyyy, mm - 1, dd);
	cYear = cDate.getFullYear();
	cMonth = cDate.getMonth() + 1;
	cDay = cDate.getDate();

	cMonth = cMonth < 10 ? "0" + cMonth : cMonth;
	cDay = cDay < 10 ? "0" + cDay : cDay;

	if (pDelimiter != "")
	{
		return cYear + pDelimiter + cMonth + pDelimiter + cDay;
	}
	else
	{
		return cYear + cMonth + cDay;
	}
}

function Save_CSV()
{
    var Csv_Data
    Csv_Data = document.getElementById("csv_data").value;
    Csv_Data = Csv_Data.replace(new RegExp("<BR>", "gi"), "\r\n");

    if (Csv_Data.length > 0)
    {
        var objSave = new ActiveXObject("EzUtil.MiscFunc");
        var strFilter = objSave.OpenSaveDlg("CSV files (*.csv)\0*.csv\0All Files (*.*)\0*.*\0\0", "text");

        if (strFilter.length > 0)
        {
            var bResult = objSave.SaveTextToFile(strFilter, Csv_Data);

            if (bResult)
            {
                alert(strLang15);
            }
            else
            {
                alert(strLang16)
            }
        }
    }
}

