package egovframework.ezEKP.ezSystem.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.ezEKP.ezSystem.service.impl.EzSystemAdminServiceImpl;

/** 
 * @Description [Utility] 시스템 모니터링 관련 유틸
 * @author 오픈솔루션팀 박종균
 * 
 * @see
 */

public class EzSystemUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	
	/**
	 * 서버 및 OS 정보 
	 **/
	@SuppressWarnings("unchecked")
	public static String getSysInfo(int tenantID) throws Exception {
		
		logger.debug("getSysInfo started. : " + tenantID);
		
		String command = "uname";
		//String filePath = "D:/test/uname.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));		
		ProcessBuilder builder = new ProcessBuilder(command, "-nro");
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		
		while (true) {
			String line = br.readLine();
			
			if (line == null) {
				break;
			} else {
				JSONObject tmpObj = new JSONObject();
				String[] tmp = line.trim().split("\\s+");
				
				tmpObj.put("hostname", tmp[0]);
				tmpObj.put("version", tmp[1]);
				tmpObj.put("os", tmp[2]);
				
				jArr.add(tmpObj);
			}
		}
		br.close();
		
		jObj.put("getSysInfo", jArr);		
		
		logger.debug(jObj.toString());	
		
		logger.debug("getSysInfo ended");
		
		return jObj.toString();
	}
	
	/**
	 * CPU 관련 정보 
	 **/
	@SuppressWarnings("unchecked")
	public static String getCpuInfo(int tenantID) throws Exception {
		
		logger.debug("getCpuInfo started. : " + tenantID);
		
		String command = "iostat";
		//String filePath = "D:/test/iostat.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));
		ProcessBuilder builder = new ProcessBuilder(command, "1", "2");
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		int cnt = 0;
		int cpuCnt = 0;
		
		while (true) {
		String line = br.readLine();
		if (line == null) {
				break;
			} else {                          
				JSONObject tmpObj = new JSONObject();
				
				if (line.contains("avg")) {
					cpuCnt++;
				}
				
				if ( cpuCnt == 2 ) {	
					if ( cnt == 1 ) {
						logger.debug(line);
						String[] tmp = line.trim().split("\\s+");
						logger.debug("tmp[0] : " + tmp[0]);
						logger.debug("tmp[2] : " + tmp[2]);
						double usedPer = Double.parseDouble(tmp[0]) + Double.parseDouble(tmp[2]);
						tmpObj.put("user", tmp[0]);
						tmpObj.put("system", tmp[2]);
						tmpObj.put("iowait", tmp[3]);
						tmpObj.put("idle", tmp[5]);
						tmpObj.put("totalUsedPer", usedPer);        // 총사용량(%)
						
						jArr.add(tmpObj);
					}
					cnt ++;
				}
			}
		}		

		br.close();
		
		jObj.put("getCpuInfo", jArr);		
		
		logger.debug(jObj.toString());
		logger.debug("getCpuInfo ended.");
		
		return jObj.toString();
	}	

	/**
	 * 메모리 관련 정보
	 * */	
	@SuppressWarnings("unchecked")
	public static String getMemoryInfo(int tenantID) throws Exception {
		
		logger.debug("getMemoryInfo started. : " + tenantID);
		
		String command = "cat";
		//String filePath = "D:/test/meminfo.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));
		ProcessBuilder builder = new ProcessBuilder(command, "/proc/meminfo");
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		int cnt = 0;
		String result = "";

		while (true) {
			String line = br.readLine();
		
			if (line == null) {
				break;
			} else if (cnt < 5) {
				JSONObject tmpObj = new JSONObject();
				String[] tmp = line.trim().split("\\s+");
				
				tmpObj.put(tmp[0].toLowerCase().replaceAll(":", ""), tmp[1]);
			
				jArr.add(tmpObj);
			}
			cnt ++;
		}

		br.close();
		
		jObj.put("getMemoryInfo", jArr);	
		result = jObj.toString().replaceAll("\\},\\{", ",");
		
		logger.debug(result);
		logger.debug("getMemoryInfo ended.");
		
		return result;
	}
	
	/**
	 * 파일 시스템 정보 관련
	 * */
	@SuppressWarnings("unchecked")
	public static String getFileSysInfo(int tenantID) throws Exception {
		
		logger.debug("getFileSysInfo started. : " + tenantID);
		
		String command = "df";
		//String filePath = "D:/test/filesys.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));
		ProcessBuilder builder = new ProcessBuilder(command, "-h");
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		int cnt = 0;

		while (true) {
			String line = br.readLine();
			
			if (line == null){
				break;
			} else if (cnt > 0){
				JSONObject tmpObj = new JSONObject();
				String[] tmp = line.trim().split("\\s+");
				
				if (tmp[0].contains("/dev")){
					tmpObj.put("diskName", tmp[0]);
					tmpObj.put("total", tmp[1]);
					tmpObj.put("used", tmp[2]);
					tmpObj.put("avail", tmp[3]);
					tmpObj.put("usedPer", tmp[4]);
					
					jArr.add(tmpObj);
				}
			}
			cnt ++;
		}
		br.close();
		
		jObj.put("getFileSysInfo", jArr);	
		
		logger.debug(jObj.toString());
		logger.debug("getFileSysInfo ended.");
		
		return jObj.toString();
	}
	
	/**
	 * 디스크 I/O 관련 정보
	 * */
	@SuppressWarnings("unchecked")
	public static String getDiskioInfo(int tenantID) throws Exception {
		
		logger.debug("getDiskioInfo started. : " + tenantID);
		
		String command = "iostat";
		//String filePath = "D:/test/iostat.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));
		ProcessBuilder builder = new ProcessBuilder(command, "1", "2");
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		int cnt = 0;
		int cpuCnt = 0;
		String result ="";

		while (true) {
		String line = br.readLine();
		if (line == null) {
				break;
			} else {                          
				JSONObject tmpObj = new JSONObject();
				
				if (line.contains("avg")) {
					cpuCnt++;
				}
				
				if ( cpuCnt == 2 ) {	
					if ( cnt > 3 ) {
						logger.debug(line);
						String[] tmp = line.trim().split("\\s+");

						if (!tmp[0].equalsIgnoreCase("")) {        // 마지막 줄은 공백이라 불필요					
							tmpObj.put("read_" + tmp[0], tmp[2]);
							tmpObj.put("write_"+ tmp[0], tmp[3]);					
							jArr.add(tmpObj);	
						}
					}
					cnt ++;
				}
			}
		}			
		br.close();
		
		jObj.put("getDiskioInfo", jArr);		
		result = jObj.toString().replaceAll("\\},\\{", ",");
		
		logger.debug(result);		
		logger.debug("getDiskioInfo ended.");
		
		return result;
	}
	
	/**
	 *  네트워크 트래픽 정보
	 **/	
	@SuppressWarnings("unchecked")
	public static String getNetDataInfo(int tenantID) throws Exception {
		
		logger.debug("getNetDataInfo started. : " + tenantID);
		
		//String filePath = "D:/test/netInter.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));		
		ProcessBuilder builder = new ProcessBuilder("cat","/proc/net/dev");
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		int cnt = 0;		
		
		while (true) {
			String line = br.readLine();
			
			if (line == null) {
				break;
			} else if (cnt > 1) {
				JSONObject tmpObj = new JSONObject();
				String[] tmp = line.trim().split("\\s+");
				
				// 1. 마지막 라인 제거
				// 2. local 제거
				// 3. 사용하지 않는 인터페이스 제거
				if (!tmp[0].equalsIgnoreCase("") 
						&& !tmp[0].equalsIgnoreCase("lo:") 
						&& !tmp[1].equalsIgnoreCase("0")) {
					tmpObj.put("interface", tmp[0].substring(0, tmp[0].length()-1));
					tmpObj.put("rBytes", tmp[1]);
					tmpObj.put("tBytes", tmp[9]);
					
					jArr.add(tmpObj);
				}
			}
			cnt ++;
		}
		br.close();
		
		jObj.put("getNetDataInfo", jArr);
		
		logger.debug(jObj.toString());
		
		logger.debug("getNetDataInfo ended.");
		
		return jObj.toString();
	}
}
