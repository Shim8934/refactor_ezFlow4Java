package egovframework.ezEKP.ezSystem.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

import org.hyperic.sigar.CpuPerc;
import org.hyperic.sigar.FileSystem;
import org.hyperic.sigar.FileSystemUsage;
import org.hyperic.sigar.Mem;
import org.hyperic.sigar.Sigar;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import egovframework.ezEKP.ezSystem.service.impl.EzSystemAdminServiceImpl;
import egovframework.ezEKP.ezSystem.vo.FileSysInfoVO;
import egovframework.ezEKP.ezSystem.vo.SysMonitorVO;

/** 
 * @Description [Utility] 시스템 모니터링 관련 유틸
 * @author 오픈솔루션팀 박종균
 * 
 * @see
 */

public class EzSystemUtil {

	private static final Logger logger = LoggerFactory.getLogger(EzSystemAdminServiceImpl.class);
	/**
	 * CPU 관련 정보 
	 **/
	public static SysMonitorVO getCpuInfo(int tenantID) throws Exception {
		
		logger.debug("getCpuInfo started. : " + tenantID);
	
		SysMonitorVO sysMonitorVo = new SysMonitorVO();
		Sigar sigar = new Sigar();
		CpuPerc cpu = sigar.getCpuPerc();
		
		sysMonitorVo.setUserUsedCpu(cpu.getUser() * 100);     // 유저 사용량
		sysMonitorVo.setSysUsedCpu(cpu.getSys() * 100);       // 시스템 사용량
		sysMonitorVo.setFreeCpu(cpu.getIdle() * 100);         // 미사용량
		sysMonitorVo.setTotalUsedCpu(cpu.getCombined() * 100);// 총사용량
		
		logger.debug("getUserUsedCpu : " + sysMonitorVo.getUserUsedCpu());
		logger.debug("getSysUsedCpu : " + sysMonitorVo.getSysUsedCpu());
		logger.debug("getFreeCpu : " + sysMonitorVo.getFreeCpu());
		logger.debug("getTotalUsedCpu : " + sysMonitorVo.getTotalUsedCpu());

		logger.debug("getCpuInfo ended.");
		
		return sysMonitorVo;
	}
	
	/**
	 * 메모리 관련 정보
	 * */
	public static SysMonitorVO getMemoryInfo(int tenantID) throws Exception {
		
		logger.debug("getMemoryInfo started. : " + tenantID);
		
		SysMonitorVO sysMonitorVo = new SysMonitorVO();
		Sigar sigar = new Sigar();
		Mem mem = sigar.getMem();
		
		sysMonitorVo.setTotalMemory(mem.getTotal());                    // 전체 메모리
		sysMonitorVo.setUsedMemory(mem.getActualUsed());                // 사용중인 메모리
		sysMonitorVo.setUsedMemPer(mem.getUsedPercent());               // 사용중인 메모리(%)
		sysMonitorVo.setFreeMemory(mem.getActualFree());                // 미사용중인 메모리		
		sysMonitorVo.setFreeMemPer(mem.getFreePercent());               // 미사용중인 메모리(%)
		
		logger.debug("getTotalMemory : " + sysMonitorVo.getTotalMemory());
		logger.debug("getUsedMemory : " + sysMonitorVo.getUsedMemory());
		logger.debug("getUsedMemory : " + sysMonitorVo.getUsedMemory());
		logger.debug("getFreeMemory : " + sysMonitorVo.getFreeMemory());
		logger.debug("getFreeMemPer : " + sysMonitorVo.getFreeMemPer());		
		
		logger.debug("getMemoryInfo ended.");
		
		return sysMonitorVo;
	}
	
	/**
	 * 파일 시스템 정보 관련
	 * */
	public static List<FileSysInfoVO> getFileSysInfo(int tenantID) throws Exception {
		
		logger.debug("getFileSysInfo started. tenantID : " + tenantID);

		Sigar sigar = new Sigar();
		FileSystem[] fslist = sigar.getFileSystemList();
		
		List<FileSysInfoVO> list = new ArrayList<FileSysInfoVO>();		
		
		for (int i = 0; i < fslist.length; i++) {
			FileSysInfoVO fileSysInfoVO = new FileSysInfoVO();
			FileSystem fs = fslist[i];
			FileSystemUsage usage = sigar.getFileSystemUsage(fs.getDirName());			
			
			fileSysInfoVO.setDiskName(fs.getDevName());                    // 파일시스템 이름
			fileSysInfoVO.setTotalVolume(usage.getTotal());                // 총 용량
			fileSysInfoVO.setUsedVolume(usage.getUsed());                  // 사용중인 용량
			fileSysInfoVO.setFreeVolume(usage.getFree());                  // 남은 용량
			fileSysInfoVO.setAvailVolume(usage.getAvail());                // 사용가능 용량
			fileSysInfoVO.setUsedVolumePer(usage.getUsePercent() * 100);   // 사용중인 용량(%)
			
			logger.debug("getDiskName : " + fileSysInfoVO.getDiskName());
			logger.debug("getTotalVolume : " + fileSysInfoVO.getTotalVolume());
			logger.debug("getUsedVolume : " + fileSysInfoVO.getUsedVolume());
			logger.debug("getUsedVolumePer : " + fileSysInfoVO.getUsedVolumePer());
			
			list.add(fileSysInfoVO);
		}
		
		logger.debug("getFileSysInfo ended.");
		
		return list;		
	}		
	
	/**
	 * 디스크 I/O 관련 정보
	 * */
	@SuppressWarnings("unchecked")
	public static String getDiskioInfo(int tenantID) throws Exception {
		
		logger.debug("getDiskioInfo started. : " + tenantID);
		
		String command = "iostat";
		//String filePath = "D:/test/test.txt";
		//BufferedReader br = new BufferedReader(new FileReader(filePath));
		ProcessBuilder builder = new ProcessBuilder(command);
		Process process = builder.start();
		BufferedReader br = new BufferedReader( new InputStreamReader(process.getInputStream()) );
		JSONObject jObj = new JSONObject();
		JSONArray jArr = new JSONArray();
		int cnt = 0;
		String result ="";

		while (true) {
			String line = br.readLine();

			if (line == null) {
				break;
			} else if (cnt > 5) {                       // 처음 상위 5줄은 불필요
				JSONObject tmpObj = new JSONObject();
				String[] tmp = line.split("\\s+");
				
				if (!tmp[0].equalsIgnoreCase("")) {        // 마지막 줄은 공백이라 불필요					
					tmpObj.put("read_" + tmp[0], tmp[2]);
					tmpObj.put("write_"+ tmp[0], tmp[3]);					
					jArr.add(tmpObj);
				}
			}
			cnt ++;
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
	public static String getNetByteInfo(int tenantID) throws Exception {
		
		logger.debug("getNetPacketInfo started. : " + tenantID);
		
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
					tmpObj.put("interface", tmp[0]);
					tmpObj.put("rBytes", tmp[1].substring(0, tmp[1].length()-1));
					tmpObj.put("tBytes", tmp[8]);
					
					jArr.add(tmpObj);
				}
			}
			cnt ++;
		}
		br.close();
		
		jObj.put("getNetByteInfo", jArr);
		
		logger.debug(jObj.toString());
		
		logger.debug("getNetPacketInfo ended.");
		
		return jObj.toString();
	}
}
