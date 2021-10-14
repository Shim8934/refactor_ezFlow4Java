using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

namespace ReceptDailyBatch
{
    class Common
    {

        public string _pAppvConStr = GetSystemConfigValue("ezApprovalG").ToString();
        
        #region WriteTextLog()
        protected static void WriteTextLog(string pFunction, string pMessage)
        {
            try
            {
                //if (GetSystemConfigValue("Log_Type") == "WEB")
                WriteTextLog_File(pFunction, pMessage);
                //else
                //    WriteTextLog_DB(pPage, pFunction, pMessage);
            }
            catch
            {
            }
        }

        protected static void WriteTextLog_File(string pFunction, string pMessage)
        {
            try
            {
                string folderpath = GetSystemConfigValue("ezCommon_RootLogPath");
                if (folderpath == "") return;
                string filepath = folderpath + "\\" + "ReceptDailyBatch";
                if (!Directory.Exists(filepath))
                    Directory.CreateDirectory(filepath);

                filepath += "\\LOG[" + DateTime.Now.ToLongDateString() + "].txt";
                //StreamWriter output = new StreamWriter(filepath, true, System.Text.Encoding.Unicode);
                ////output.WriteLine(System.Environment.MachineName.ToString() + "||");
                ////output.WriteLine(System.Environment.MachineName.ToString() + "||"+DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "||" + Guid.NewGuid().ToString() + "||");
                //output.WriteLine(System.Environment.MachineName.ToString() + "||" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "||" );
                //output.Write(pFunction + "||" + pMessage);
                ////output.WriteLine();
                //output.Write("|END|");
                //output.Close();


                StreamWriter output = new StreamWriter(filepath, true, System.Text.Encoding.Default);
                output.WriteLine("[" + DateTime.Now.ToLongTimeString() + "] " + pFunction.Trim());
                output.WriteLine(pMessage);
                output.WriteLine();
                output.Close();
                output = null;
            }
            catch
            { }
        }
        #endregion


        protected static string GetSystemConfigValue(string pKeyValue)
        {
            string pResult = string.Empty;
            try
            {
                string pKeyResult = "";
                pKeyResult = System.Configuration.ConfigurationManager.AppSettings[pKeyValue];
                if (pKeyResult == null)
                {
                    pKeyResult = ConfigurationManager.ConnectionStrings[pKeyValue].ConnectionString;
                }
                pResult = pKeyResult;
            }
            catch (Exception)
            {
                pResult = "Exception";
            }
            return pResult;
        }

        protected string ExecuteSP(ref SqlCommand cmd)
        {
            string rtnValue = string.Empty;

            using (SqlConnection con = new SqlConnection(_pAppvConStr))
            {
                try
                {
                    cmd.Connection = con;
                    con.Open();
                    cmd.ExecuteNonQuery();
                    rtnValue = "OK";
                }
                catch (Exception ex)
                {
                    WriteTextLog("ExecuteSP", ex.ToString());
                    rtnValue = "ERROR:" + ex.Message;
                }
                finally
                {
                    if (con.State != ConnectionState.Closed)
                        con.Close();
                }
            }
            return rtnValue;
        }
    }
}
