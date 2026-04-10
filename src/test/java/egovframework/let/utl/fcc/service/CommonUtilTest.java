package egovframework.let.utl.fcc.service;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

public class CommonUtilTest {

	private static CommonUtil commonUtil;
	
	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		commonUtil = new CommonUtil();
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
	}

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testStripScriptTagsAndFunctions() {
		String str1 = commonUtil.stripScriptTagsAndFunctions("this string includes an alert('test')hello('world') part.");		
		assertEquals("this string includes an hello('world') part.", str1);

		String str2 = commonUtil.stripScriptTagsAndFunctions("this string includes an confirm('test')hello('world') part.");		
		assertEquals("this string includes an hello('world') part.", str2);

		String str3 = commonUtil.stripScriptTagsAndFunctions("this string includes an prompt('test')hello('world') part.");		
		assertEquals("this string includes an hello('world') part.", str3);
		
//		String str4 = commonUtil.stripScriptTagsAndFunctions("this string includes window['location'] part.");
//		assertEquals("this string includes '] part.", str4);
//
//		String str5 = commonUtil.stripScriptTagsAndFunctions("this string includes window.location='url' part.");
//		assertEquals("this string includes ='url' part.", str5);
	}

    @Test
    public void testChunk() {
        // 1. 정상 작동 테스트: 배열이 균등하게 나뉠 때
        String[] input1 = {"a", "b", "c", "d", "e", "f"};
        String[][] expected1 = {
            {"a", "b"},
            {"c", "d"},
            {"e", "f"}
        };
        String[][] result1 = commonUtil.chunk(input1, 2);
        assertArrayEquals("배열이 2개씩 균등하게 나누어져야 합니다.", expected1, result1);

        // 2. 정상 작동 테스트: 배열이 불균등하게 나뉠 때
        String[] input2 = {"a", "b", "c", "d", "e"};
        String[][] expected2 = {
            {"a", "b", "c"},
            {"d", "e"}
        };
        String[][] result2 = commonUtil.chunk(input2, 3);
        assertArrayEquals("마지막 청크는 남은 요소를 포함해야 합니다.", expected2, result2);

        // 3. 경계값 테스트: 청크 크기가 배열 길이보다 클 때
        String[] input3 = {"a", "b", "c"};
        String[][] expected3 = {
            {"a", "b", "c"}
        };
        String[][] result3 = commonUtil.chunk(input3, 10);
        assertArrayEquals("크기가 길이보다 크면 전체 배열을 하나의 청크로 반환해야 합니다.", expected3, result3);

        // 4. 경계값 테스트: 빈 배열 입력
        String[] input4 = {};
        String[][] expected4 = {};
        String[][] result4 = commonUtil.chunk(input4, 3);
        assertArrayEquals("빈 배열을 입력하면 빈 2차원 배열을 반환해야 합니다.", expected4, result4);

        // 5. 예외 테스트: 청크 크기가 1 미만일 때 (예외 발생을 테스트하는 JUnit 4의 표준 방식)
        try {
            commonUtil.chunk(input3, 0);
            // 예외가 발생하지 않았다면 테스트 실패
            fail("청크 크기가 1 미만이면 IllegalArgumentException이 발생해야 합니다.");
        } catch (IllegalArgumentException e) {
            // IllegalArgumentException이 발생했으므로 테스트 성공
            assertTrue(true);
        } catch (Exception e) {
            // 다른 종류의 예외가 발생하면 테스트 실패
            fail("IllegalArgumentException이 아닌 다른 예외가 발생했습니다: " + e.getClass().getSimpleName());
        }

        // 6. Null 입력 테스트: Commons Lang은 null 입력 시 null을 반환합니다.
        assertNull("Null 입력 시 null을 반환해야 합니다.", commonUtil.chunk(null, 2));
    }

}
