function selectSubTitles(pID)
{
	var parameter = "";
	var url = "/myoffice/ezApprovalG/ezDocInfo/ezSelectSubTitle.aspx?id="+escape(pID);
	var feature = "status:no;dialogWidth:270px;dialogHeight:230px;help:no;scroll:no;edge:sunken";
	feature =  feature + GetShowModalPosition(270, 230);
	var RtnVal = window.showModalDialog(url,parameter,feature);

	return RtnVal;
}