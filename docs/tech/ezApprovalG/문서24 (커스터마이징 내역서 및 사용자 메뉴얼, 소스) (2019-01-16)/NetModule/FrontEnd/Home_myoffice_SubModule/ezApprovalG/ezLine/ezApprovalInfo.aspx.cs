using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Data.SqlClient;
using System.Xml;
using System.Text;
using System.Configuration;

namespace Kaoni.ezStandard
{
    public partial class ezApprovalInfo : ezApprovalGBase
    {
        public StringBuilder _securitynode = new StringBuilder("");
        public StringBuilder _securitynode2 = new StringBuilder("");
        public StringBuilder _periodnode = new StringBuilder("");
        public StringBuilder _periodnode2 = new StringBuilder("");
        public string _pSusinAdmin = "";
        public string _USE_OCS = "";        
        public string _AprTypeXML = "";
        public string _optGamsabu = "";
        
        public string _InitFlag = "";
        public string pGubun = "1";
        public string startDateTime = "";
        public string endDateTime = "";
        public string _securitynode3 = "";
        public string NoneActiveX = string.Empty;
        public string pDocSn = "";
        public string SusinGroupUseFlag = string.Empty;
        public string UserTitle = string.Empty;
        public string UserDeptID = string.Empty;

        //2016.11.22 원문공개
        public string OpenFlag = string.Empty;
        public string Use_GovOpenDoc = string.Empty;
        public string _AuditUserID = string.Empty; // 20161220 소방 일상감사

        public string pAprState_ = string.Empty; //20161226 소방 기결재통과 임시저장 구분값(20161226)

        public string pGian = string.Empty; //20170104 소방 기안자가 결재선 수정

        public string _Doc24Code = string.Empty; //20190104 문서24 부서코드
        public string _Doc24Name = string.Empty; //20190104 문서24 부서이름
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CreateAprUserInfo();

                //2016.11.22 원문공개
                if (Request.QueryString["OpenFlag"] != null)
                {
                    OpenFlag = Request.QueryString["OpenFlag"];
                    OpenFlag = "N"; //소방 원문공개탭 안보이도록 임시처리(20161123)
                    Use_GovOpenDoc = "YES";
                }

                NoneActiveX = GetSystemConfigValue("APR_NONEACTIVEX").ToString();

                ezApprovalG.ezTemplete ezAPI3 = new ezApprovalG.ezTemplete();
                _securitynode3 = ezAPI3.GetSecurityType("", userinfo.CompanyID, userinfo.Lang);

                ezAPI3 = null;

                startDateTime = System.DateTime.Now.ToShortDateString();
                endDateTime = System.DateTime.Now.ToShortDateString();

                startDateTime = DateTime.Parse(startDateTime).ToString();
                endDateTime = DateTime.Parse(endDateTime).ToString();
                startDateTime = IsoUTFDate(startDateTime.ToString());
                endDateTime = IsoUTFDate(endDateTime.ToString());

                if (Request.QueryString["DocSN"] != null)
                    pDocSn = ReplaceXSS(Request.QueryString["DocSN"].ToString());

                if (userinfo.RollInfo.IndexOf("a=1") > -1)
                    _pSusinAdmin = "YES";
                else
                    _pSusinAdmin = "NO";
                _USE_OCS = GetSystemConfigValue("USE_OCS").ToString().ToUpper();                
                
                if (Request.QueryString["initFlag"] != null)
                    _InitFlag = ReplaceXSS(Request.QueryString["initFlag"]);
                if (_InitFlag.Trim() == "")
                    _InitFlag = "0";

                if (Request.QueryString["Gubun"] != null && Request.QueryString["Gubun"] != "")
                    pGubun = ReplaceXSS(Request.QueryString["Gubun"].ToString().Trim());

                if (Request.QueryString["UserTitle"] != null && Request.QueryString["UserTitle"] != "")
                    UserTitle = ReplaceXSS(Request.QueryString["UserTitle"].ToString().Trim());

                if (Request.QueryString["UserDeptID"] != null && Request.QueryString["UserDeptID"] != "")
                    UserDeptID = ReplaceXSS(Request.QueryString["UserDeptID"].ToString().Trim());

                if (Request.QueryString["pAprState"] != null && Request.QueryString["pAprState"] != "")
                    pAprState_ = ReplaceXSS(Request.QueryString["pAprState"].ToString().Trim());

                if (Request.QueryString["Gian"] != null && Request.QueryString["Gian"] != "")
                    pGian = ReplaceXSS(Request.QueryString["Gian"].ToString().Trim());

                if (Request.QueryString["DeptCode"] != null) //20190104 문서24 부서코드
                    _Doc24Code = ReplaceXSS(Request.QueryString["DeptCode"].ToString().Trim());
                if (Request.QueryString["DeptName"] != null)  //20190104 문서24 부서이름
                    _Doc24Name = ReplaceXSS(Request.QueryString["DeptName"].ToString().Trim());

                ezApprovalG.ezTemplete ezAPI2 = new ezApprovalG.ezTemplete();
                _AprTypeXML = ezAPI2.GetAprType(userinfo.CompanyID, userinfo.Lang);

                
                XmlDocument xmlResult = new XmlDocument();
                xmlResult = GetXmlReaderString(_AprTypeXML); 

                _AprTypeXML = xmlResult.OuterXml;

                ezAPI2 = null;

                ezApprovalG.ezDoc ezAPI = new ezApprovalG.ezDoc();
                _optGamsabu = ezAPI.getOptionInfo("A40", "001", userinfo.CompanyID, "CODE", userinfo.Lang);
                ezAPI = null;

                SusinGroupUseFlag = getCode2Name("A53", "002", userinfo.CompanyID, userinfo.Lang);

                _AuditUserID = getCode2Name("A70", "002", userinfo.CompanyID, userinfo.Lang);
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezApprovalInfo", "Page_Load()", Ex.ToString());
            }
        }
        private void GetSecurityType(string strLang, string CompanyID)
        {
            SqlCommand cmd = null;
            try
            {
                cmd = new SqlCommand("EZSP_GETSECURITYTYPE");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PSTRLANG", strLang.Trim());
                string docList = GetQueryResultSP(ref cmd, true, CompanyID);
                XmlDocument docXML = new XmlDocument();
                docXML = GetXmlReaderString(docList);

                XmlNodeList doclist = docXML.SelectNodes("DATA/ROW");
                for (int i = 0; i < doclist.Count; i++)
                {
                    string[] colOption = doclist.Item(i).SelectSingleNode("NAME").InnerText.Split(';');
                    if (i % 2 == 0)
                        _securitynode.Append("<input type='radio' id='RSecurity' name='RSecurity' value='" + colOption[2] + "' value2='"+colOption[1]+"' >" + colOption[1] + "<br/>");
                    else
                        _securitynode2.Append("<input type='radio' id='RSecurity' name='RSecurity' value='" + colOption[2] + "' value2='" + colOption[1] + "'>" + colOption[1] + "<br/>");
                }
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezApprovalInfo", "GetSecurityType()", Ex.ToString());
            }
            finally
            {
                cmd.Dispose();
                cmd = null;
            }
        }

        public string IsoUTFDate(string dateTimeStr)
        {
            string resultStr = "";
            try
            {
                if (dateTimeStr != "")
                    dateTimeStr = DateTime.Parse(dateTimeStr).AddHours(-9).ToString("yyyy-MM-dd HH:mm:ss");
                if (dateTimeStr.Trim() != "")
                {
                    if (dateTimeStr.IndexOf(" ") != -1)
                    {
                        resultStr = dateTimeStr.Split(' ')[0] + "T" + dateTimeStr.Split(' ')[1] + ".000Z";
                    }
                    else
                    {
                        resultStr = dateTimeStr + "T00:00:00.000Z";
                    }
                }
                else
                {
                    resultStr = "";
                }
                return resultStr;
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezApprovalInfo", "IsoUTFDate()", Ex.ToString());
                return null;
            }
        }

        private void GetKeepType(string strLang, string CompanyID)
        {
            SqlCommand cmd = null;
            try
            {
                cmd = new SqlCommand("EZSP_GETKEEPTYPE");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@PSTRLANG", strLang.Trim());
                string docList = GetQueryResultSP(ref cmd, true, CompanyID);
                XmlDocument docXML = new XmlDocument();
                docXML = GetXmlReaderString(docList);

                XmlNodeList doclist = docXML.SelectNodes("DATA/ROW");
                for (int i = 0; i < doclist.Count; i++)
                {
                    string[] colOption = doclist.Item(i).SelectSingleNode("NAME").InnerText.Split(';');
                    if (i % 2 == 0)
                        _periodnode.Append("<input type='radio' id='RKeeptype' name='RKeeptype' value='" + colOption[2] + "' value2='" + colOption[1] + "' >" + colOption[1] + "<br/>");
                    else
                        _periodnode2.Append("<input type='radio' id='RKeeptype' name='RKeeptype' value='" + colOption[2] + "' value2='" + colOption[1] + "' >" + colOption[1] + "<br/>");
                }
            }
            catch (Exception Ex)
            {
                WriteTextLog("ezApprovalInfo", "GetKeepType()", Ex.ToString());
            }
            finally
            {
                cmd.Dispose();
                cmd = null;
            }
        }
    }
}