package egovframework.ezEKP.ezSchedule.lib;

public interface EzScheduleBase {
	int GetQueryValue(String pSQL);
	String GetQueryResult(String pSQL, Boolean pIsMultiLine);
	String ExecuteSQL(String pSQL);
	void WriteTextLog(String pPage, String pFunction, String pMessage);
	void WriteTextLog_File(String pPage, String pFunction, String pMessage);
	void WriteTextLog_DB(String pPage, String pFunction, String pMessage);
	String MakeXMLString(String pOrgString);
	String MakeRightField(String pOrgStr);
	String LunarToSolar(int pYear, int pMonth, int pDay);
	void WriteInformLog(String pMethod, String pMessage);
	String EncryptString(String pOrgStr);
	String DecryptString(String pOrgStr);
	String GetSystemConfigValue(String pKeyValue);
	String EncryptString2048(String pOrgStr);
	String DecryptString2048(String pOrgStr);
}
