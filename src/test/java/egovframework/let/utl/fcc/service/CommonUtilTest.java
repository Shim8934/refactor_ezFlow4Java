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
		
		String str4 = commonUtil.stripScriptTagsAndFunctions("this string includes window['location'] part.");		
		assertEquals("this string includes '] part.", str4);
		
		String str5 = commonUtil.stripScriptTagsAndFunctions("this string includes window.location='url' part.");		
		assertEquals("this string includes ='url' part.", str5);				
	}

}
