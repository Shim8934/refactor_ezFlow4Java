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
using System.Data.SqlClient;
using System.IO;
using System.Xml;

namespace Kaoni.ezStandard
{
	
	
	public partial class ezRecevG_Susin_HWP : ezApprovalGBase
	{
		public string _optSignDateFormat = "";
		public string _optisSplit = "";
		public string _optSplitKind = "";
		public string _sihangURL = "";

		public string _DocID = "";
		public string _orgDocID = "";
		public string _isReDraft = "";

		public string _HwpToolbar = "";

		
		public string _DraftFlag = "";

		
		public string _RetFlag = "";
        public string Use_Editor = "";
        public string NoneActiveX = string.Empty;
        public string _pPassAproveUseYN = "N"; //20161025 소방 기결재통과
        public string NoneActiveX_Cross = string.Empty; //소방 추가(2016110)
        //Connkey 추가(20161031)
        public string connkey = string.Empty;
        public string ImageInfo = "";     //소방 서명양식 사인 분기처리 (20161118)
        public string pDeptAuth = ""; //소방 비공개 정보 가져오기(20170711)

        public bool CheckbtnReqReSend = false; //2018.11.30 문서24
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
                ImageInfo = GetSystemConfigValue("ImageForm").ToString(); //소방 서명양식 사인 분기처리 (20161118)
                CreateAprUserInfo();

                if (Request.QueryString["DocID"] != null)
                    _DocID = ReplaceXSS(Request.QueryString["DocID"]);
                if (Request.QueryString["uorgID"] != null)
                    _orgDocID = ReplaceXSS(Request.QueryString["uorgID"]);
                if (Request.QueryString["isReDraft"] != null)
                    _isReDraft = ReplaceXSS(Request.QueryString["isReDraft"]);

                
                if (Request.QueryString["DraftFlag"] != null)
                    _DraftFlag = ReplaceXSS(Request.QueryString["DraftFlag"]);

                
                if (Request.QueryString["RetFlag"] != null)
                    _RetFlag = ReplaceXSS(Request.QueryString["RetFlag"]);


                if (_DraftFlag == "SUSIN") //소방 접수문서 비공개 문서 정보 가져옴 (전사공개/부서공개) 20170711
                {
                    SqlCommand cmd = new SqlCommand();
                    cmd = new SqlCommand("EZSP_SELOPENINFO");
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.Add("@DOCID", SqlDbType.Char, 20).Value = _DocID.Trim();
                    string docList = GetQueryResultSP(ref cmd, true, userinfo.CompanyID);
                    XmlDocument docXML = new XmlDocument();
                    docXML = GetXmlReaderString(docList);
                    if (docXML.GetElementsByTagName("TEMPATTRIBUTE")[0] != null)
                    {
                        pDeptAuth = docXML.GetElementsByTagName("TEMPATTRIBUTE")[0].InnerText;
                    }
                }

                ezApprovalG.ezDoc ezAPI = new ezApprovalG.ezDoc();
                _optSignDateFormat = ezAPI.getOptionInfo("A15", "002", userinfo.CompanyID, "CODE", userinfo.Lang);
                _optisSplit = ezAPI.getOptionInfo("A33", "001", userinfo.CompanyID, "CODE", userinfo.Lang);
                _optSplitKind = ezAPI.getOptionInfo("A33", "002", userinfo.CompanyID, "CODE", userinfo.Lang);
                _sihangURL = ezAPI.getOptionInfo("A36", "004", userinfo.CompanyID, "CODE", userinfo.Lang);
                if (_DraftFlag == "REDRAFT") //20161031 소방 기결재 통과
                    _pPassAproveUseYN = ezAPI.getOptionInfo("B01", "001", userinfo.CompanyID, "CODE", userinfo.Lang);

                ezAPI = null;

                string ConnXML = GetConnKey(_DocID);//연동문서 Connkey 가져온다(20161031)
                XmlDocument XMLConn = new XmlDocument();
                XMLConn.LoadXml(ConnXML);
                if (XMLConn.GetElementsByTagName("CONKEY")[0] != null)
                {
                    connkey = XMLConn.GetElementsByTagName("CONKEY")[0].InnerText;
                }
                
                string dirPath = Server.MapPath("/Upload_ApprovalG");
                if (dirPath.Substring(dirPath.Length - 1, 1) != "\\")
                    dirPath = dirPath + "\\";

                
                SqlCommand comd = new SqlCommand("EZSP_GETORGDOCINFO");
                comd.CommandType = CommandType.StoredProcedure;
                comd.Parameters.Add("@PDOCID", SqlDbType.Char, 20).Value = _DocID;

                string rtnval = GetQueryResultSP(ref comd, false, userinfo.CompanyID);
                XmlDocument xmldom = new XmlDocument();
                xmldom = GetXmlReaderString(rtnval);

                if (xmldom.GetElementsByTagName("ORGHREF").Count > 0)
                {
                    string OrgDocFile = xmldom.GetElementsByTagName("ORGHREF").Item(0).InnerText;
                    string DocFile = xmldom.GetElementsByTagName("HREF").Item(0).InnerText;
                    OrgDocFile = dirPath + OrgDocFile.Replace("/Upload_ApprovalG/", "/").Replace("/", "\\");
                    DocFile = dirPath + DocFile.Replace("/Upload_ApprovalG/", "/").Replace("/", "\\");

                    xmldom = null;

                    string Dir = DocFile.Substring(0, DocFile.LastIndexOf("\\") + 1);
                    if (!System.IO.Directory.Exists(Dir))
                        System.IO.Directory.CreateDirectory(Dir);


                    FileInfo f1 = new FileInfo(DocFile);
                    if (!f1.Exists)
                    {
                        FileInfo org = new FileInfo(OrgDocFile);

                        org.CopyTo(f1.FullName, false);

                    }
                }
                CheckbtnReSendDisplay(userinfo.CompanyID);
                GetDoc24Info(userinfo.CompanyID);
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezRecevG_Susin_HWP", "Page_Load()", Ex.ToString());
            }
			
		}

        private string GetConnKey(string pDocID)
        { //연동양식 정보를 가져온다.
            string XMLString = "";
            try
            {
                SqlCommand cmd = new SqlCommand();
                cmd = new SqlCommand("EZSP_GETCONNKEYINFO");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@PDOCID", SqlDbType.NVarChar).Value = pDocID.Trim();
                XMLString = GetQueryResultSP("ezConn", ref cmd, true);
                cmd.Dispose();
                cmd = null;
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezAproveUI_HWP.aspx", "GetConnKey", Ex.ToString());
            }
            return XMLString;
        }

        #region  2018.11.30 문서24
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
        #region Web Form 디자이너에서 생성한 코드
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
