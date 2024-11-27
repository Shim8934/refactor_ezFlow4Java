using System;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using System.IO;

public partial class _Default : System.Web.UI.Page 
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string strUploadedPath, strContentType, strToday, strDir, strAbsolutePath, strExtension, strFileName;

        string strDialogType = "";

        int index;
        bool validation;
        HttpPostedFile file;

        strContentType = Request.Form["content_type"];        //이전 페이지에서 image인지 flash인지 받아옴

        strDialogType = Request.Form["dialog_type"];

        validation = false;
        strToday = DateTime.Now.ToString("yyyyMMdd");                //현재날짜를 yyyyMMdd 형식으로 저장
        strDir = Server.MapPath(".");//현재 asp.net은 upload폴더내에 uploaddot폴더에 존재하므로 부모폴더인 upload폴더로 가기위해 getParent
        strDir = strDir + @"\" + strToday;                           //upload/20130116 과 같이 저장하기위해 절대 경로를 설정하고
        
        if (!Directory.Exists(strDir)) {

            Directory.CreateDirectory(strDir);//없으면 해당 경로를 만든다
        }

        file = Request.Files["FILE_PATH"];//input type="file" mutlipart~형식으로 넘어온 파일정보를 받아옴
        strFileName = file.FileName;

        /*         
         * 파일의 확장자 구하기.
         */
        strExtension = strFileName.Split('.')[strFileName.Split('.').Length-1];
       
        //유효성검사시작
        //ContentType이 플래쉬이면서 확장자가 swf인 파일 이거나 image이면서 확장자가 jpg || jpeg || gif || png 일경우
        if ((string.Compare(strContentType, "flash") == 0) || (string.Compare(strContentType, "image") == 0)) {

            if ((string.Compare(strContentType, "flash") == 0)) {

                if ((string.Compare(strExtension, "swf", true) == 0)) {

                    validation = true;
                }
            }

            if ((string.Compare(strContentType, "image") == 0)) {

                if ((string.Compare(strExtension, "jpg", true) == 0)) {

                    validation = true;
                }

                if ((string.Compare(strExtension, "jpeg", true) == 0)) {

                    validation = true;
                }

                if ((string.Compare(strExtension, "gif", true) == 0)) {

                    validation = true;
                }

                if ((string.Compare(strExtension, "png", true) == 0)) {

                    validation = true;
                }

				if ((string.Compare(strExtension, "bmp", true) == 0)) {

                    validation = true;
                }
            }
        }

        if (validation == true) {

            if ((string.Compare(strContentType, "flash") == 0)) {

                strFileName = "FLA_" + DateTime.Now.ToString("HHmmss");

            } else {

                strFileName = "IMG_" + DateTime.Now.ToString("HHmmss");
            }

            strUploadedPath = @"\" + strFileName;   //상대경로에 오늘의 날짜\파일이름.확장자로 저장
            strAbsolutePath = strDir;
            strDir = strAbsolutePath + strUploadedPath + "." + strExtension;  //절대경로에 상대경로를 이어붙여 저장

            //동일파일(같은시각에 파일을 올릴경우 동일이름의 파일이 생기게됨)을 막기위해 파일이름끝에_index를 붙여주는 작업
            index = 1;

            while (File.Exists(strDir)) {

                strFileName = DateTime.Now.ToString("HHmmss") + "_" + index;
                strDir = strAbsolutePath + @"\" + strFileName + "." + strExtension;
                index++;
            }
            
            file.SaveAs(strDir);//경로/파일명 으로 저장
            
            //html에 패스를 넘겨주기 위한 작업
            strFileName = strFileName + "." + strExtension;
            strUploadedPath = strToday + "/" + strFileName;
            
            //html에 값을 넘겨줌
            divContentType.Value = strContentType;
            divImagePath.Value = strUploadedPath;

            dialogType.Value = strDialogType;
        
        } else {

            //유효성검사 에러메세지 출력
        }
    }
}
