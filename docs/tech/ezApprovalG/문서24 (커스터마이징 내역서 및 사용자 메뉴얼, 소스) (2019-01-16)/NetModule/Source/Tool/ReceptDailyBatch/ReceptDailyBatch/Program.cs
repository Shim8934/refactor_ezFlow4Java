using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;

namespace ReceptDailyBatch
{
    class Program : Common
    {
        static void Main(string[] args)
        {
            Program p = new Program();
            p.Start();
        }

        protected void Start()
        {
            string dateString = DateTime.Now.ToString("yyyyMMdd");
            WriteTextLog("********************   수신처 데이터 가져오기 작업 시작 ********************", "");
            string jsonData = string.Empty;
            if (GetSystemConfigValue("Type").ToString().Equals("SAMPLE"))
                jsonData = GetSampleRecData();
            else
                jsonData = GetRecData(dateString);
            if (!string.IsNullOrWhiteSpace(jsonData))
            {
                dynamic dynObj = JsonConvert.DeserializeObject(jsonData);

                if (dynObj["header"].code.ToString().Equals("LNK000000"))
                {
                    foreach (var data in dynObj.result)
                    {
                        bool InsertFlag = false;
                        if (GetSystemConfigValue("SETTYPE").Equals("YES"))
                        {
                            InsertFlag = SetRecInfo(data.ToString());
                        }
                        else
                        {
                            InsertFlag = SetRecParameterInfo(data.orgCd.ToString(), data.cmpnyNm.ToString(), data.senderNm.ToString(), data.bizrno.ToString(),  data.adres.ToString(), data.deleteFlag.ToString(), data.updateDe.ToString(), data.deleteDe.ToString());
                        }
                        if (InsertFlag)
                        {
                            WriteTextLog("수신처 DB 성공  - 수신처 코드 : " + data.orgCd + ", 사업장명 : " + data.cmpnyNm, "");
                        }
                        else
                        {
                            WriteTextLog("수신처 DB 실패  - 수신처 코드 : " + data.orgCd + ", 사업장명 : " + data.cmpnyNm, "");
                        }
                    }
                   
                }
                else
                {
                    WriteTextLog("********************  수신처 데이터 가져오기 작업 실패 ********************", dynObj["header"].code.ToString());
                }
            }
            else
            {
                WriteTextLog("********************  수신처 데이터 가져오기 작업 실패 ********************", "");
            }
            WriteTextLog("********************  수신처 데이터 가져오기 작업 종료 ********************", "");
        }

        #region 수신처 정보 추출
        protected string GetRecData(string CurDate)
        {
            string resultPost = string.Empty;
            try
            {
                StringBuilder postParams = new StringBuilder();
                //postParams.Append("orgCd=" + "M999999");
                postParams.Append("batchDay=" + CurDate);
                postParams.Append("&deleteFlag = Y");

                Encoding encoding = Encoding.UTF8;
                byte[] result = encoding.GetBytes(postParams.ToString());

                // 타겟이 되는 웹페이지 URL
                string Url = GetSystemConfigValue("REQURL");

                HttpWebRequest wReqFirst = (HttpWebRequest)WebRequest.Create(Url);
                // HttpWebRequest 오브젝트 설정

                wReqFirst.Method = "POST";
                wReqFirst.ContentType = "application/x-www-form-urlencoded";
                wReqFirst.ContentLength = result.Length;
                wReqFirst.Headers.Add("API_KEY", GetSystemConfigValue("API_KEY"));

                Stream postDataStream = wReqFirst.GetRequestStream();
                postDataStream.Write(result, 0, result.Length);
                postDataStream.Close();

                HttpWebResponse wRespFirst = (HttpWebResponse)wReqFirst.GetResponse();
                // Response의 결과를 스트림을 생성합니다.
                Stream respPostStream = wRespFirst.GetResponseStream();
                StreamReader readerPost = new StreamReader(respPostStream, Encoding.UTF8);

                // 생성한 스트림으로부터 string으로 변환합니다.
                resultPost = readerPost.ReadToEnd();
            }
            catch (Exception ex)
            {
                WriteTextLog("GetRecData", ex.ToString());
                resultPost = string.Empty;
            }

            return resultPost;
        }

        protected string GetSampleRecData()
        {

            //JObject o1 = JObject.Parse(File.ReadAllText(@"c:\videogames.json"));

            // read JSON directly from a file
            using (StreamReader file = File.OpenText(@"D:\NetModule\Source\Tool\ReceptDailyBatch\ReceptDailyBatch\json1.json"))
            using (JsonTextReader reader = new JsonTextReader(file))
            {
                JObject o2 = (JObject)JToken.ReadFrom(reader);
                return o2.Root.ToString();
            }

            
        }
        #endregion

        #region 수신처 정보 추출
        protected bool SetRecInfo(string JsonString)
        {
            bool retCheck = false;
            SqlCommand cmd = null;
            try
            {
                cmd = new SqlCommand("EZSP_DOC24_SETRECINFO");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@jsonVariable", SqlDbType.NVarChar).Value = JsonString;
                string rtn = ExecuteSP(ref cmd);

                if (rtn.ToUpper().Equals("OK"))
                    retCheck = true;
                else
                    retCheck = false;

            }
            catch (Exception ex)
            {
                WriteTextLog("SetRecInfo", ex.ToString());
                retCheck = false;
            }

            return retCheck;
        }


        protected bool SetRecParameterInfo(string orgCd, string cmpnyNm, string senderNm, string bizrno, string adres, string deleteFlag, string updateDe, string deleteDe)
        {
            bool retCheck = false;
            SqlCommand cmd = null;
            try
            {
                cmd = new SqlCommand("EZSP_DOC24_SETRECPARAMETERINFO");
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@orgCd", SqlDbType.NVarChar, 7).Value = orgCd;
                cmd.Parameters.Add("@cmpnyNm", SqlDbType.NVarChar, 120).Value = cmpnyNm;
                cmd.Parameters.Add("@senderNm", SqlDbType.NVarChar, 200).Value = senderNm;
                cmd.Parameters.Add("@bizrno", SqlDbType.NVarChar, 20).Value = bizrno;
                cmd.Parameters.Add("@adres", SqlDbType.NVarChar, 200).Value = adres;
                cmd.Parameters.Add("@deleteFlag", SqlDbType.Char, 1).Value = deleteFlag;
                cmd.Parameters.Add("@updateDe", SqlDbType.VarChar, 8).Value = updateDe;
                cmd.Parameters.Add("@deleteDe", SqlDbType.VarChar, 8).Value = deleteDe;
                string rtn = ExecuteSP(ref cmd);

                if (rtn.ToUpper().Equals("OK"))
                    retCheck = true;
                else
                    retCheck = false;

            }
            catch (Exception ex)
            {
                WriteTextLog("SetRecParameterInfo", "orgCd"+orgCd + ", cmpnyNm :" + cmpnyNm+ ", senderNm :" + senderNm+ ", bizrno :" + bizrno+ ", adres :" + adres+ ", deleteFlag :" + deleteFlag+ ", updateDe :" + updateDe+ ", deleteDe :" + deleteDe +"\n"+ex.ToString());
                retCheck = false;
            }

            return retCheck;
        }

        #endregion


    }
}
