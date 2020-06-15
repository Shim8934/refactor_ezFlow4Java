package egovframework.ezEKP;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.junit.Assert;
import org.junit.Test;

public class MessagePropertyTest {

	private static final String CURR_DIR = System.getProperty("user.dir");
	
	// 한글 메세지 프로퍼티 파일명
	private static final String MSG_FILE_NM_KO = "message-common_ko.properties";
		
	// 테스트에서 제외할 프로퍼티 파일명
	private static List<String> exceptionList = Arrays.asList("message-common.properties");
	
	// 메세지 파일내의 중복된 프로퍼티들에 대한 정보
	private static StringBuffer duplicatedStr = new StringBuffer();
	
	// 메세지 파일내의 빈 값을 가진 프로퍼티들에 대한 정보
	private static StringBuffer emptyStr = new StringBuffer();
	
	// 다국어 메세지 프로퍼티에서 아직 번역되지 않은 프로퍼티들에 대한 정보
	private static StringBuffer untranslatedStr = new StringBuffer();
	
	/**
	 * 1. message-common_ko.properties와 다른 언어 메세지 프로퍼티를 비교해서 다른 점을 찾는다.
	 * 2. 메세지 프로퍼티 내의 중복된 프로퍼티를 찾는다.
	 * 3. 메세지 프로퍼티 내의 빈 값을 가진 프로퍼티를 찾는다.
	 * 4. 번역되지 않은 다국어 메세지 프로퍼티를 찾는다.
	 * @throws Exception 
	 */
	@Test
	public void messagePropertyTest() throws Exception {
		boolean testSuccess = true;
		
		String msgFilePath = CURR_DIR + File.separator + "src" + File.separator + "main" + File.separator 
							  + "resources" + File.separator + "egovframework" + File.separator + "message" + File.separator + "com";
		
		// message-common_ko.properties 파일
		File msg_ko = new File(msgFilePath + File.separator + MSG_FILE_NM_KO);
		
		File msgFileDir = new File(msgFilePath);
		
		// message-common.properties, message-common_ko.properties 와 exceptionList에 포함된 파일을 제외한 메세지 파일들
		List<File> msgFiles = Arrays.stream(msgFileDir.listFiles())
				.filter(elem -> !MSG_FILE_NM_KO.equals(elem.getName()) && !exceptionList.contains(elem.getName()))
				.collect(Collectors.toList());
		
		List<String> msgProperties_ko = extractProperties(msg_ko);
		
		int size_ko = msgProperties_ko.size();
		
		for(File msgFile : msgFiles) {
			String msgFileNm = msgFile.getName();
			
			List<String> msgProperties = extractProperties(msgFile);
			
			int size = msgProperties.size();
			
			int koIdx = 0;
			int idx = 0;
			
			List<String> onlyKo = new ArrayList<String>();
			List<String> onlyOther = new ArrayList<String>();
			
			while(koIdx < size_ko && idx < size) {
				String property_ko = msgProperties_ko.get(koIdx);
				String property = msgProperties.get(idx);
				
				if(property_ko.equals(property)) {
					koIdx++;
					idx++;
				} else {
					int n = property_ko.compareTo(property);
					
					if(n < 0) {
						onlyKo.add(property_ko);
						koIdx++;
					} else {
						onlyOther.add(property);
						idx++;
					}
				}
			}
			
			if(koIdx < size_ko) {
				for(int i = koIdx; i < size_ko; i++) {
					onlyKo.add(msgProperties_ko.get(i));
				}
			}
			
			if(idx < size) {
				for(int i = idx; i < size; i++) {
					onlyOther.add(msgProperties.get(i));
				}
			}
			
			if(!onlyKo.isEmpty()) {
				System.out.println("== Properties in message-common_ko.properties, not in " + msgFileNm + " ==");
				System.out.println(onlyKo);
				System.out.println();
				testSuccess = false;
			}
			
			if(!onlyOther.isEmpty()) {
				System.out.println("== Properties in " + msgFileNm + ", not in message-common_ko.properties ==");
				System.out.println(onlyOther);
				System.out.println();
				testSuccess = false;
			}
		}
		
		if(duplicatedStr.length() > 0) {
//			testSuccess = false;
			duplicatedStr.insert(0, "== Duplicated Properties ==\n");
			System.out.println(duplicatedStr);
		}
		
		if(emptyStr.length() > 0) {
//			testSuccess = false;
			emptyStr.insert(0, "== Empty Properties == \n");
			System.out.println(emptyStr);
		}
		
		if(untranslatedStr.length() > 0) {
//			testSuccess = false;
			untranslatedStr.insert(0, "== Untranslated Properties == \n");
			System.out.println(untranslatedStr);
		}
		
		if(!testSuccess) {
			Assert.fail();
		}
	}
	
	/**
	 * 메세지 파일 내의 모든 프로퍼티명을 반환. 중복이거나 빈 값을 가졌거나 아직 번역되지 않은 프로퍼티에 대한 검사도 시행한다.
	 * @param file
	 * @return 모든 프로퍼티명을 가진 List. 투포인터 알고리즘 사용을 위해 반드시 정렬된 상태로 반환되야함
	 * @throws Exception
	 */
	private List<String> extractProperties(File file) throws Exception {
		List<String> result = new ArrayList<String>();
		Map<String, Integer> duplicatedMap = new HashMap<String, Integer>();
		List<String> emptyList = new ArrayList<String>();
		List<String> untranslatedList = new ArrayList<String>();
		
		boolean isMsgKo = MSG_FILE_NM_KO.equals(file.getName());
		
		BufferedReader br = new BufferedReader(new FileReader(file));
		
		String line;
		
		while((line = br.readLine()) != null) {
			if(isPropertyLine(line)) {
				String propertyNm = line.split("=")[0].trim();
				String value = convertString(line.split("=")[1].trim());
				
				if(duplicatedMap.containsKey(propertyNm)) {
					duplicatedMap.put(propertyNm, duplicatedMap.get(propertyNm) + 1);
				} else {
					duplicatedMap.put(propertyNm, 1);
					result.add(propertyNm);
				}
				
				if(value.length() == 0) {
					emptyList.add(propertyNm);
				}
				
				// 한글 메세지 프로퍼티가 아닐 때만 시행
				if(!isMsgKo) {
					for(int i = 0; i < value.length(); i++) {
						
						if(isKorean(value.charAt(i))) {
							untranslatedList.add(propertyNm);
							break;
						}
					}
				}
			}
		}
		
		br.close();
		
		List<String> duplicatedList = duplicatedMap.entrySet().stream().filter(elem -> elem.getValue() > 1)
										.map(elem -> elem.getKey() + " (" + elem.getValue() + " times)").sorted().collect(Collectors.toList());
		
		if(!duplicatedList.isEmpty()) {
			duplicatedStr.append(file.getName() + " : ");
			duplicatedStr.append(String.join(", ", duplicatedList) + "\n");
		}
		
		if(!emptyList.isEmpty()) {
			emptyStr.append(file.getName() + " : ");
			emptyStr.append(String.join(", ", emptyList) + "\n");
		}
		
		if(!untranslatedList.isEmpty()) {
			untranslatedStr.append(file.getName() + " : ");
			untranslatedStr.append(String.join(", ", untranslatedList) + "\n");
		}
		
		Collections.sort(result);
		
		return result;
	}
	
	private boolean isPropertyLine(String line) {
		boolean ret = false;
		
		String x = line.trim();
		
		if(x.contains("=")) {
			int hashIdx = x.indexOf("#");
			int equalIdx = x.indexOf("=");
			
			if(hashIdx == -1 || hashIdx > equalIdx) {
				ret = true;
			}
		}
		
		return ret;
	}

	/**
	 * 유니코드에서 String으로 변환
	 * 출처: https://nowonbun.tistory.com/686
	 * @param val
	 * @return
	 */
	private static String convertString(String val) {
		StringBuffer sb = new StringBuffer();
		
		for (int i = 0; i < val.length(); i++) {
			if ('\\' == val.charAt(i) && i + 1 < val.length() && 'u' == val.charAt(i + 1)) {
				Character r = (char) Integer.parseInt(val.substring(i + 2, i + 6), 16);
				sb.append(r);
				i += 5;
			} else {
				sb.append(val.charAt(i));
			}
		}
		
		return sb.toString();
	}
	
	private static boolean isKorean(char val) {
		return val >= 44032 && val <= 55203;
	}
}
