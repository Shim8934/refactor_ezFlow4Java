

function trim(parm_str){
  return rtrim(ltrim(parm_str));
}

function ltrim(parm_str) {
  str_temp = parm_str ;
  while (str_temp.length != 0) {
    if (str_temp.substring(0,1) == " ") {
      str_temp = str_temp.substring(1, str_temp.length) ;
    } else {
      return str_temp ;
    }
  }
  return str_temp ;
}

function rtrim(parm_str) {
  str_temp = parm_str ;
  while (str_temp.length != 0) {
    int_last_blnk_pos = str_temp.lastIndexOf(" ");
    if ((str_temp.length - 1) == int_last_blnk_pos) {
      str_temp = str_temp.substring(0, str_temp.length - 1);
    } else {
      return str_temp;
    }
  }
  return str_temp;
}

function IndexDemo(vdata)//" + strLang1 + "
{
   var s = vdata.indexOf(";");
   return(s);
}



function SpecialReplace(value)
{
   //&lt; , &gt;, &amp; 아니면 리플레이스
   var r, re;                    //Declare variables.
   
   re=/&/g;
   r=value.replace(re, "+");
  
   return(r)
}
function Replace(value)
{
   var r, re;                    //Declare variables.
   
   re=/&/g;
   r=value.replace(re, "&amp;");
   
   re = /</g;					 //Create regular expression pattern.
   r = value.replace(re, "&lt;");   //Replace "A" with "The".
   re=/>/g;
   r= r.replace(re,"&gt;");
  
   return(r);                   //Return string with replacement made.


}
function RReplace(value)
{
   var r, re;                    //Declare variables.
   
 
   re = /&lt;/g;					 //Create regular expression pattern.
   r = value.replace(re, "<");   //Replace "A" with "The".
  
   re=/&gt;/g;
   r= r.replace(re,">");
  
   
   return(r);                   //Return string with replacement made.


}


