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
using System.Configuration;
using System.Xml;
using System.Data.SqlClient;

namespace Kaoni
{
	namespace ezStandard
	{
		
		
		public partial class ezViewEnd_HWP : ezApprovalGBase
		{
			public string _DocID="";
			public string _DocHref="";
			public string _DocType="";
			public string _orgDocID="";
			public string _formID="";
			public string _endDir="";
			public string _Doctitle="";
			public string _ListSusin="";
			public string _pSusinAdmin = "";
			public string _HwpToolbar = "";
			public string PASS = "";
            public string SignCheck = "N";
            public string NoneActiveX = string.Empty;
            public string NoneActiveX_Cross = string.Empty; //소방 추가(2016110)
            public string Use_Editor = "";
            public string pGovInfo = ""; //소방 고도화 추가(20170721)
            public string pPublicityCode_GOV = "";
            public bool CheckbtnReqReSend = false; //20190103 문서24 회신
            public string _Doc24Code = string.Empty; //20190104 문서24 부서코드
            public string _Doc24Name = string.Empty; //20190104 문서24 부서이름
            protected void Page_Load(object sender, System.EventArgs e)
			{
                try
                {
                    NoneActiveX = GetSystemConfigValue("APR_NONEACTIVEX").ToString();
                    NoneActiveX_Cross = GetSystemConfigValue("NONEACTIVEX").ToString(); //엑티브엑스 사용처리(201611010)
                    _HwpToolbar = GetSystemConfigValue("UserInfo_HWPToolbar").ToString();
                    Use_Editor = GetSystemConfigValue("EDITOR").ToString();
                    string GamsaDept_Sobang = GetSystemConfigValue("GamsaDept").ToString();

                    CreateAprUserInfo();
                    if (userinfo.RollInfo.IndexOf("a=1") > -1)
                        _pSusinAdmin = "YES";
                    else
                        _pSusinAdmin = "NO";

                    if (Request.QueryString["DocID"] != null)
                        _DocID = ReplaceXSS(Request.QueryString["DocID"]);
                    if (Request.QueryString["DocHref"] != null)
                        _DocHref = ReplaceXSS(Request.QueryString["DocHref"]);
                    if (Request.QueryString["ListSusin"] != null)
                        _ListSusin = ReplaceXSS(Request.QueryString["ListSusin"]);
                    if (Request.QueryString["orgDocid"] != null)
                        _orgDocID = ReplaceXSS(Request.QueryString["orgDocid"]);
                    if (Request.QueryString["formid"] != null)
                        _formID = ReplaceXSS(Request.QueryString["formid"]);
                    if (Request.QueryString["title"] != null)
                        _Doctitle = ReplaceXSS(Request.QueryString["title"]);
                    if (Request.QueryString["pGovInfo"] != null)
                        pGovInfo = ReplaceXSS(Request.QueryString["pGovInfo"]);

                    if (_orgDocID != "")
                        _endDir = Convert.ToString(long.Parse(_orgDocID) % 1000);

                    //소방 고도화 추가(20170721)
                    XmlDocument xmldom_Gov = new XmlDocument();
                    string Xml_Gov = GOVDOCINFO(_DocID, pGovInfo);
                    xmldom_Gov.LoadXml(Xml_Gov);
                    if (xmldom_Gov.GetElementsByTagName("PUBLICITYCODE")[0] !=null)
                    {
                        pPublicityCode_GOV = xmldom_Gov.GetElementsByTagName("PUBLICITYCODE")[0].InnerText;
                    }

                    string AccessInfo = GetSystemConfigValue("UserInfo_ApprovalG_VIEW").ToString();
                    ezApprovalG.ezDoc ezAPI3 = new ezApprovalG.ezDoc();
                    PASS = ezAPI3.GetAccessYNG(_DocID, userinfo.UserID, AccessInfo, userinfo.CompanyID, userinfo.Lang);
                    ezAPI3 = null;

                    if (userinfo.RollInfo.IndexOf("c=1") > -1) //소방전체 관리자는 비공개 문서 열람가능함(20170210)
                    {
                        PASS = "<RESULT>TRUE</RESULT>";
                    }

                    if (userinfo.DeptID == GamsaDept_Sobang) //감사실 부서사람들은 비공개문서 열람가능함(20170213)
                    {
                        PASS = "<RESULT>TRUE</RESULT>";
                    }

                    //소방 발송승인문서 비공개 문서일경우 시행문 문서는 열람가능하도록(20170215)
                    string AprStateCheck = "";
                    string pDOCSTATE = "";
                    string infoXML = "";
                    ezOrgan.OrganInfo _ezOrgan = new ezOrgan.OrganInfo();
                    infoXML = _ezOrgan.GetPropertyValue(userinfo.DeptID, "extensionAttribute4");
                    _ezOrgan = null;

                    string pAprState = SimSaDocCheck(_DocID);
                    XmlDocument xmldom_form = new XmlDocument();
                    xmldom_form.LoadXml(pAprState);
                    if (xmldom_form.GetElementsByTagName("APRSTATE")[0] != null)
                    {
                        AprStateCheck = xmldom_form.GetElementsByTagName("APRSTATE")[0].InnerText;
                        if ((AprStateCheck == "003" || AprStateCheck == "004") && (infoXML != "" ))
                        {
                            PASS = "<RESULT>TRUE</RESULT>";
                        }
                    }

                    if (xmldom_form.GetElementsByTagName("DOCSTATE")[0] != null)
                    {
                        pDOCSTATE = xmldom_form.GetElementsByTagName("DOCSTATE")[0].InnerText;
                        if ((pDOCSTATE == "014") && (infoXML != "" ))
                        {
                            PASS = "<RESULT>TRUE</RESULT>";
                        }
                    }


                    XmlDocument resultXML = new XmlDocument();
                    if (PASS == "<RESULT>TRUE</RESULT>")
                    {
                        
                        if (_DocHref.Trim() == "" || _DocHref.IndexOf("/1000/") >= 0)
                        {
                            ezApprovalG.ezDoc ezAPI = new ezApprovalG.ezDoc();
                            string strXML = ezAPI.GetDocInfo(_DocID, "END", "Href", userinfo.CompanyID);

                            ezAPI = null;

                            resultXML = GetXmlReaderString(strXML);
                            if (resultXML.GetElementsByTagName("HREF").Count > 0)
                                if (resultXML.GetElementsByTagName("HREF").Item(0).InnerText.Trim() != "")
                                    _DocHref = resultXML.DocumentElement.InnerText;

                        }

                        string ReadRecXML = "<PARAMETER><DOCID>" + MakeXMLString(_DocID) +
                            "</DOCID><USERID>" + MakeXMLString(userinfo.UserID) +
                            "</USERID><USERNAME>" + MakeXMLString(userinfo.DisplayName) +
                            "</USERNAME><USERTITLE>" + MakeXMLString(userinfo.Title) +
                            "</USERTITLE><DEPTCODE>" + MakeXMLString(userinfo.DeptID) +
                            "</DEPTCODE><DEPTNAME>" + MakeXMLString(userinfo.DeptName) +
                            "</DEPTNAME><COMPANYID>" + MakeXMLString(userinfo.CompanyID) +
                            "</COMPANYID></PARAMETER>";

                        
                        ezApprovalG.ezCabRecord ezAPI2 = new ezApprovalG.ezCabRecord();
                        string result = ezAPI2.SaveRecReadHist(ReadRecXML);
                        ezAPI2 = null;

                        
                        ezApprovalG.ezDoc ezAPI4 = new ezApprovalG.ezDoc();
                        string rtnXML = ezAPI4.GetDocInfo(_DocID, "END", "SignCheck", userinfo.CompanyID);  
                        ezAPI4 = null;

                        resultXML = GetXmlReaderString(rtnXML);

                        if (resultXML.GetElementsByTagName("SIGNCHECK").Count > 0)
                            SignCheck = resultXML.GetElementsByTagName("SIGNCHECK").Item(0).InnerText.Trim();
                    }

                    CheckbtnReSendDisplay(userinfo.CompanyID);
                    GetDoc24Info(userinfo.CompanyID);
                }
                catch (Exception Ex)
                {
                    WriteTextLog("ezViewEnd_HWP", "Page_Load()", Ex.ToString());
                }
			}

            private string SimSaDocCheck(string pDocID_SImsa)
            { 
                string XMLString = "";
                try
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd = new SqlCommand("EZSP_SIMSADOCCHECK");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@PDOCID", SqlDbType.NVarChar).Value = pDocID_SImsa.Trim();
                    XMLString = GetQueryResultSP(ref cmd, true, userinfo.CompanyID);
                    cmd.Dispose();
                    cmd = null;
                }
                catch (Exception Ex)
                {
                    WriteTextLog("ezViewEnd_HWP.aspx", "SimSaDocCheck", Ex.ToString());
                }
                return XMLString;
            }

            private string GOVDOCINFO(string pDocID, string pFlag)
            {
                string XMLString = "";
                try
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd = new SqlCommand("EZSP_ENDDOCGOVOPENINFO");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@PDOCID", SqlDbType.NVarChar).Value = pDocID.Trim();
                    cmd.Parameters.Add("@PFLAG", SqlDbType.NVarChar).Value = pFlag.Trim();
                    XMLString = GetQueryResultSP(ref cmd, true, userinfo.CompanyID);
                    cmd.Dispose();
                    cmd = null;
                }
                catch (Exception Ex)
                {
                    WriteTextLog("ezViewEnd_HWP.aspx", "GOVDOCINFO", Ex.ToString());
                }
                return XMLString;
            }

            #region  20190103 문서24 회신
            protected void CheckbtnReSendDisplay(string pCompID)
            {
                SqlCommand cmd = null;
                try
                {
                    cmd = new SqlCommand("EZSP_DOC24_GETREQRESENDYN");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@DOCID", SqlDbType.Char, 20).Value = _DocID;

                    string Checktmp = GetSingleQueryResultSP(ref cmd, pCompID);
                    if (Checktmp.ToUpper().Equals("Y"))
                        CheckbtnReqReSend = true;
                    else
                        CheckbtnReqReSend = false;

                }
                catch (Exception ex)
                {
                    WriteTextLog("recevg", "CheckbtnReSendDisplay", ex.ToString());
                    CheckbtnReqReSend = false;
                }
            }
            #endregion
            #region  20190103 문서24 수신정보
            protected void GetDoc24Info(string pCompID)
            {
                SqlCommand cmd = null;
                try
                {
                    cmd = new SqlCommand("EZSP_DOC24_GETRELAYINFO");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@DOCID", SqlDbType.Char, 20).Value = _DocID;

                    string rtnval = GetQueryResultSP(ref cmd, false, userinfo.CompanyID);

                    XmlDocument xmldom = new XmlDocument();
                    xmldom = GetXmlReaderString(rtnval);

                    if (xmldom.GetElementsByTagName("DEPTCODE").Count > 0)
                    {
                        _Doc24Code = xmldom.GetElementsByTagName("DEPTCODE").Item(0).InnerText;
                        _Doc24Name = xmldom.GetElementsByTagName("DEPTNAME").Item(0).InnerText;

                    }
                }
                catch (Exception ex)
                {
                    WriteTextLog("recevg", "GetDoc24Info", ex.ToString());
                    CheckbtnReqReSend = false;
                }
            }
            #endregion

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
