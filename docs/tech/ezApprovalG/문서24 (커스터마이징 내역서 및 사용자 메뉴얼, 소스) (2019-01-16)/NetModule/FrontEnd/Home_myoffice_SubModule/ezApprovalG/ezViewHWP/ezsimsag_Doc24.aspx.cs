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
using System.Xml;

namespace Kaoni.ezStandard
{
	
	
	public partial class ezSimsaG_Doc24 : ezApprovalGBase
	{
        public string _DocID = "";
        //public string _DocHref = "";
        //public string _OrgDocID = "";
        public string _DeptCode = string.Empty;
        public string _DeptName = string.Empty;
        public string _HwpToolbar = "";
        public string Use_Editor = "";
        
        
        public string Use_ImgTagTOAttah_body = "N";
        public string NoneActiveX = string.Empty;
        public string NoneActiveX_Cross = string.Empty; //소방 추가(2016110)
        public string SpanCode_ = ""; //소방기관코드(20170206)
        protected void Page_Load(object sender, System.EventArgs e)
		{
            try
            {
                NoneActiveX = GetSystemConfigValue("APR_NONEACTIVEX").ToString();
                NoneActiveX_Cross = GetSystemConfigValue("NONEACTIVEX").ToString(); //엑티브엑스 사용처리(201611010)
                _HwpToolbar = GetSystemConfigValue("UserInfo_HWPToolbar").ToString();
                SpanCode_ = GetSystemConfigValue("SpanCode").ToString(); //소방기관코드 (20170206)

                Use_Editor = GetSystemConfigValue("EDITOR").ToString();
                CreateAprUserInfo();

                //if (Request.QueryString["DocID"] != null)
                //    _DocID = ReplaceXSS(Request.QueryString["DocID"]);
                //if (Request.QueryString["DocHref"] != null)
                //    _DocHref = ReplaceXSS(Request.QueryString["DocHref"]);
                //if (Request.QueryString["orgDocid"] != null)
                //    _OrgDocID = ReplaceXSS(Request.QueryString["orgDocid"]);

                if (Request.QueryString["DeptCode"] != null)
                    _DeptCode = ReplaceXSS(Request.QueryString["DeptCode"]);

                if (Request.QueryString["DeptName"] != null)
                    _DeptName = ReplaceXSS(Request.QueryString["DeptName"]);

                //20190104 새로운 문서번호 채번
                ezApprovalG.ezDoc ezAPI = new ezApprovalG.ezDoc();
                _DocID = ezAPI.CreateNewDoc("2009000003", userinfo.CompanyID);
                ezAPI = null;

                //20190104 수신처 정보 Insert
                InsertReciptInfo(_DocID, _DeptCode, _DeptName);
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezSimsaG_HWP", "Page_Load()", Ex.ToString());
            }
            
        }
        #region  20190103 문서24 회신
        protected void InsertReciptInfo(string DocID, string DocDeptCode, string DocDeptName)
        {
            SqlCommand cmd = null;
            try
            {
                cmd = new SqlCommand("EZSP_DOC24_INSERTRECIPTINFO");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@DOCID", SqlDbType.Char, 20).Value = DocID;
                cmd.Parameters.Add("@DeptCode", SqlDbType.NVarChar, 60).Value = DocDeptCode;
                cmd.Parameters.Add("@DeptName", SqlDbType.NVarChar, 60).Value = DocDeptName;

                ExecuteSP(ref cmd, userinfo.CompanyID);

            }
            catch (Exception ex)
            {
                WriteTextLog("recevg", "InsertReciptInfo", ex.ToString());
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
