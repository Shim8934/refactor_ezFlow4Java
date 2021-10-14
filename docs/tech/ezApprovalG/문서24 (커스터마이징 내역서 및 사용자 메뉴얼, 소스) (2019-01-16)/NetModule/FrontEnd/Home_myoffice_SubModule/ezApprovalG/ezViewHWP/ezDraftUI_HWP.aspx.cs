using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Xml;
using System.Configuration;
using System.Data.SqlClient;

namespace Kaoni
{
	namespace ezStandard
	{
		
		
		public partial class ezDraftUI_HWP : ezApprovalGBase
		{
			public string _pSusinAdmin = "";
			public string _formURL = "";
			public string _DraftFlag = "";
			public string _formDocType = "";
			public string _susinSN = "";
			public string _DocState = "";
			public string _ListType = "";
			public string _AprState = "";
			public string _isTmpDoc = "";
			public string _dirpath = "";

			public string _optSignDateFormat = "";
			public string _optisSplit = "";
			public string _optSplitKind = "";
			public string _sihangURL = "";
			public string _HwpToolbar = "";
            public string _DocSN = "";
            public string Use_Editor = "";
            public string NoneActiveX = string.Empty;
            public string _pPassAproveUseYN = "N"; //20161025 소방 기결재통과
            public string connkey = "";
            public string _conndims = ""; //위험물관리 연동키(20161108)
            public string _connsobang = ""; //소방 연동키(20161108)
            public string _title = ""; //소방연동 제목(20161109)
            public string OpenFlag = string.Empty; //원문공개 연동(20161110)
            public string ImageInfo = "";     //소방 서명양식 사인 분기처리 (20161118)
            public string _AuditDocID = string.Empty; //20161212 소방 일상감사
            public string _AuditAprType = string.Empty; //20161212 소방 일상감사
            public string Temp_FormInfo = string.Empty; //20161229 소방 임시저장 필요없는 양식
            public string _AuditDocIDAttach = string.Empty; //20170113 소방 일상감사 첨부정보
            public string GamsaFormID = string.Empty; //소방 일상감사의견서 formID 정보(20170216)
            public string pDeptAuth = ""; //소방 비공개 정보 가져오기(20170711)
            public string FormIDwith30Aggrement = ""; // 합의 30명 넘는경우 오류 수정(20170727)

            public string _Doc24Code= string.Empty; //20190104 문서24 부서코드
            public string _Doc24Name = string.Empty; //20190104 문서24 부서이름
            protected void Page_Load(object sender, System.EventArgs e)
			{
                try
                {
                    NoneActiveX = GetSystemConfigValue("APR_NONEACTIVEX").ToString();
                    _HwpToolbar = GetSystemConfigValue("UserInfo_HWPToolbar").ToString();
                    Use_Editor = GetSystemConfigValue("EDITOR").ToString();
                    ImageInfo = GetSystemConfigValue("ImageForm").ToString(); //소방 서명양식 사인 분기처리 (20161118)
                    Temp_FormInfo = GetSystemConfigValue("Temp_Form").ToString(); //소방 임시저장 필요없는 양식 (20161229)
                    GamsaFormID = GetSystemConfigValue("GamsaFormID").ToString(); //소방 일상감사의견서 formID 정보(20170216)
                    FormIDwith30Aggrement = GetSystemConfigValue("FormIDwith30Aggrement").ToString(); // 합의 30명 넘는경우 오류 수정(20170727)

                    CreateAprUserInfo();
                    if (userinfo.RollInfo.IndexOf("a=1") > -1)
                        _pSusinAdmin = "YES";
                    else
                        _pSusinAdmin = "NO";

                    if (Request.QueryString["formURL"] != null)
                        _formURL = ReplaceXSS(Request.QueryString["formURL"]);
                    if (Request.QueryString["DraftFlag"] != null)
                        _DraftFlag = ReplaceXSS(Request.QueryString["DraftFlag"]);
                    if (Request.QueryString["formDocType"] != null)
                        _formDocType = ReplaceXSS(Request.QueryString["formDocType"]);
                    if (Request.QueryString["susinSN"] != null)
                        _susinSN = ReplaceXSS(Request.QueryString["susinSN"]);
                    if (Request.QueryString["DocState"] != null)
                        _DocState = ReplaceXSS(Request.QueryString["DocState"]);
                    if (Request.QueryString["ListType"] != null)
                        _ListType = ReplaceXSS(Request.QueryString["ListType"]);
                    if (Request.QueryString["AprState"] != null)
                        _AprState = ReplaceXSS(Request.QueryString["AprState"]);
                    if (Request.QueryString["isTmpDoc"] != null)
                        _isTmpDoc = ReplaceXSS(Request.QueryString["isTmpDoc"]);
                    if (_ListType == "21")
                    {
                        if (Request.QueryString["DocSN"] != null)
                            _DocSN = ReplaceXSS(Request.QueryString["DocSN"]);
                    }

                    //연동키값(20161028)
                    if (Request.QueryString["ConnKey"] != null)
                        connkey = ReplaceXSS(Request.QueryString["ConnKey"]);

                    if (Request.QueryString["conndims"] != null) //위험물 관리 연동키(20161108)
                        _conndims = ReplaceXSS(Request.QueryString["conndims"]);

                    if (Request.QueryString["connsobang"] != null) //소방연동키(20161108)
                    { 
                        _connsobang = ReplaceXSS(Request.QueryString["connsobang"]);
                        _conndims = _connsobang;
                    }

                    if (Request.QueryString["pTitle"] != null) //소방제목정보(20161108)
                        _title = ReplaceXSS(Request.QueryString["pTitle"]);

                    _title = "  " + _title; //소방제목공백처리(20180123)

                    if (Request.QueryString["OpenFlag"] != null) //원문공개 연동정보(2016110)
                        OpenFlag = ReplaceXSS(Request.QueryString["OpenFlag"]);
                    
                    if (Request.QueryString["AuditDocID"] != null) //20161212 소방 일상감사
                        _AuditDocID = ReplaceXSS(Request.QueryString["AuditDocID"]);
                    if (Request.QueryString["AuditAprType"] != null) //20161212 소방 일상감사
                        _AuditAprType = ReplaceXSS(Request.QueryString["AuditAprType"]);
                    if (Request.QueryString["AuditDocID"] != null) //20161212 소방 일상감사 첨부정보
                        _AuditDocIDAttach = ReplaceXSS(Request.QueryString["AuditDocID"]);
                    
                    if (Request.QueryString["DeptCode"] != null) //20190104 문서24 부서코드
                        _Doc24Code = ReplaceXSS(Request.QueryString["DeptCode"].ToString().Trim());
                    if (Request.QueryString["DeptName"] != null)  //20190104 문서24 부서이름
                        _Doc24Name = ReplaceXSS(Request.QueryString["DeptName"].ToString().Trim());

                    if (_DraftFlag == "REDRAFT" && (_AprState == "004" || _AprState=="006")) //소방 반송일경우 비공개 문서 정보 가져옴 (전사공개/부서공개) 20170711
                    {
                        SqlCommand cmd = new SqlCommand();
                        cmd = new SqlCommand("EZSP_SELOPENINFO");
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.Add("@DOCID", SqlDbType.Char, 20).Value = _isTmpDoc.Trim();
                        string docList = GetQueryResultSP(ref cmd, true, userinfo.CompanyID);
                        XmlDocument docXML = new XmlDocument();
                        docXML = GetXmlReaderString(docList);
                        if (docXML.GetElementsByTagName("TEMPATTRIBUTE")[0] !=null)
                        {
                            pDeptAuth = docXML.GetElementsByTagName("TEMPATTRIBUTE")[0].InnerText;
                        }
                    }



                    if (_AuditAprType == "END")
                    {
                        Kaoni.ezStandard.ezApprovalG.ezDoc ezAPI2 = new Kaoni.ezStandard.ezApprovalG.ezDoc();
                        string strXML = ezAPI2.GetDocInfo(_AuditDocID, _AuditAprType, "ORGDOCID", userinfo.CompanyID);
                        ezAPI2 = null;

                        XmlDocument resultXML = new XmlDocument();
                        resultXML = GetXmlReaderString(strXML);
                        if (resultXML.GetElementsByTagName("ORGDOCID").Count > 0)
                            if (resultXML.GetElementsByTagName("ORGDOCID").Item(0).InnerText.Trim() != "")
                                _AuditDocID = resultXML.DocumentElement.InnerText;
                    }

                    _dirpath = "/Upload_ApprovalG/" + userinfo.CompanyID + "/doc/" + DateTime.Now.Year.ToString() + "/";

                    ezApprovalG.ezDoc ezAPI = new ezApprovalG.ezDoc();
                    _optSignDateFormat = ezAPI.getOptionInfo("A15", "002", userinfo.CompanyID, "CODE", userinfo.Lang);
                    _optisSplit = ezAPI.getOptionInfo("A33", "001", userinfo.CompanyID, "CODE", userinfo.Lang);
                    _optSplitKind = ezAPI.getOptionInfo("A33", "002", userinfo.CompanyID, "CODE", userinfo.Lang);
                    _sihangURL = ezAPI.getOptionInfo("A36", "004", userinfo.CompanyID, "CODE", userinfo.Lang);
                    if (_DraftFlag == "REDRAFT" && _AprState=="004") //20161031 소방 기결재 통과 반송만 기결재통과
                        _pPassAproveUseYN = ezAPI.getOptionInfo("B01", "001", userinfo.CompanyID, "CODE", userinfo.Lang);
                    ezAPI = null;
                }
                catch (Exception Ex)
                {
                    WriteTextLog("ezDraftUI_HWP", "Page_Load()", Ex.ToString());
                }

				
			}

		#region Web Form Designer generated code
			override protected void OnInit(EventArgs e)
			{
				
				
				
				InitializeComponent();
				base.OnInit(e);
			}
		
			
			
			
			
			private void InitializeComponent()
			{    
			}
		#endregion
		}
	}
}
