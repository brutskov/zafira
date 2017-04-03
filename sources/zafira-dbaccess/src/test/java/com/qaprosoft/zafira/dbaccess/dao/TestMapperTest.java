package com.qaprosoft.zafira.dbaccess.dao;

import static org.testng.Assert.assertEquals;
import static org.testng.Assert.assertNotEquals;
import static org.testng.Assert.assertNull;

import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.testng.AbstractTestNGSpringContextTests;
import org.testng.Assert;

import com.qaprosoft.zafira.dbaccess.dao.mysql.TestMapper;
import com.qaprosoft.zafira.dbaccess.dao.mysql.search.TestSearchCriteria;
import com.qaprosoft.zafira.models.db.Status;
import com.qaprosoft.zafira.models.db.Test;
import com.qaprosoft.zafira.models.db.TestConfig;

@org.testng.annotations.Test
@ContextConfiguration("classpath:com/qaprosoft/zafira/dbaccess/dbaccess-test.xml")
public class TestMapperTest extends AbstractTestNGSpringContextTests
{
	/**
	 * Turn this on to enable this test
	 */
	private static final boolean ENABLED = false;
	
	private static final Test TEST = new Test()
	{
		private static final long serialVersionUID = 1L;
		{
			TestConfig testConfig = new TestConfig();
			testConfig.setId(1L);
			testConfig.setUrl("http://localhost:8080");
			testConfig.setEnv("QA");
			testConfig.setPlatform("iOS");
			testConfig.setPlatformVersion("9.1");
			testConfig.setBrowser("chrome");
			testConfig.setBrowserVersion("43");
			testConfig.setAppVersion("1.1");
			testConfig.setLocale("en");
			testConfig.setLanguage("GB");
			testConfig.setDevice("Samsung Galaxy S3");
			
			setName("MyTest");
			setStatus(Status.PASSED);
			setTestArgs("<xml>");
			setTestCaseId(1L);
			setTestRunId(3L);
			setTestGroup("g1");
			setMessage("Hm....");
			setStartTime(new Date());
			setFinishTime(new Date());
			setLogURL("http://1");
			setDemoURL("http://1");
			setTestConfig(testConfig);
			setKnownIssue(true);
			setBlocker(true);
			setDependsOnMethods("testLogin");
		}
	};

	@Autowired
	private TestMapper testMapper;

	@org.testng.annotations.Test(enabled = ENABLED)
	public void createTest()
	{
		testMapper.createTest(TEST);

		assertNotEquals(TEST.getId(), 0, "Test ID must be set up by autogenerated keys");
	}

	@org.testng.annotations.Test(enabled = ENABLED)
	public void searchTests()
	{
		TestSearchCriteria sc = new TestSearchCriteria();
		sc.setTestRunIds(Arrays.asList(TEST.getTestRunId()));
		sc.setPageSize(Integer.MAX_VALUE);
		List<Test> tests = testMapper.searchTests(sc);
		int count = testMapper.getTestsSearchCount(sc);
		Assert.assertEquals(tests.size(), count);
	}
	
	@org.testng.annotations.Test(enabled = ENABLED, dependsOnMethods =
	{ "createTest" })
	public void getTestById()
	{
		checkTest(testMapper.getTestById(TEST.getId()));
	}

	@org.testng.annotations.Test(enabled = ENABLED, dependsOnMethods =
	{ "createTest" })
	public void updateTest()
	{
		TEST.setName("MyTest2");
		TEST.setStatus(Status.FAILED);
		TEST.setTestArgs("<xml/>");
		TEST.setTestCaseId(2L);
		TEST.setTestRunId(11L);
		TEST.setTestGroup("g2");
		TEST.setMessage("Aha!");
		TEST.setLogURL("http://2");
		TEST.setDemoURL("http://2");
		TEST.setTestConfig(new TestConfig(2L));
		TEST.setKnownIssue(false);
		TEST.setBlocker(false);
		TEST.setDependsOnMethods("testLogout");
		
		testMapper.updateTest(TEST);

		checkTest(testMapper.getTestById(TEST.getId()));
	}

	/**
	 * Turn this in to delete test after all tests
	 */
	private static final boolean DELETE_ENABLED = true;

	/**
	 * If true, then <code>deleteTest</code> will be used to delete test after all tests, otherwise -
	 * <code>deleteTestById</code>
	 */
	private static final boolean DELETE_BY_TEST = false;

	@org.testng.annotations.Test(enabled = ENABLED && DELETE_ENABLED && DELETE_BY_TEST, dependsOnMethods =
	{ "createTest", "getTestById", "updateTest" })
	public void deleteTest()
	{
		testMapper.deleteTest(TEST);

		assertNull(testMapper.getTestById(TEST.getId()));
	}

	@org.testng.annotations.Test(enabled = ENABLED && DELETE_ENABLED && !DELETE_BY_TEST, dependsOnMethods =
	{ "createTest", "getTestById", "updateTest", "searchTests" })
	public void deleteTestById()
	{
		testMapper.deleteTestById((TEST.getId()));

		assertNull(testMapper.getTestById(TEST.getId()));
	}
	
	@org.testng.annotations.Test(enabled = ENABLED && DELETE_ENABLED && !DELETE_BY_TEST, dependsOnMethods =
	{ "createTest", "getTestById", "updateTest", "searchTests" })
	public void deleteTestByTestRunIdAndTestCaseIdAndTestLogURL()
	{
		testMapper.deleteTestByTestRunIdAndTestCaseIdAndLogURL(3, 1, "http://localhost:8080/lc/log");

		assertNull(testMapper.getTestById(TEST.getId()));
	}

	private void checkTest(Test test)
	{
		assertEquals(test.getName(), TEST.getName(), "Name must match");
		assertEquals(test.getStatus(), TEST.getStatus(), "Status must match");
		assertEquals(test.getTestArgs(), TEST.getTestArgs(), "Test args must match");
		assertEquals(test.getTestCaseId(), TEST.getTestCaseId(), "Test case ID must match");
		assertEquals(test.getTestGroup(), TEST.getTestGroup(), "Test group must match");
		assertEquals(test.getTestRunId(), TEST.getTestRunId(), "Test run ID must match");
		assertEquals(test.getMessage(), TEST.getMessage(), "Message must match");
		assertEquals(test.getLogURL(), TEST.getLogURL(), "Log URL must match");
		assertEquals(test.getDemoURL(), TEST.getDemoURL(), "Demo URL must match");
		assertEquals(test.isKnownIssue(), TEST.isKnownIssue(), "Known issue must match");
		assertEquals(test.isBlocker(), TEST.isBlocker(), "Known issue must match");
		assertEquals(test.getDependsOnMethods(), TEST.getDependsOnMethods(), "Depends on methods must match");
		assertEquals(test.getTestConfig().getId(), TEST.getTestConfig().getId(), "Config ID must match");
	}
}
