package com.qaprosoft.zafira.dbaccess.dao.mysql;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.qaprosoft.zafira.dbaccess.model.TestRun;
import com.qaprosoft.zafira.dbaccess.model.config.Argument;


public interface TestRunMapper
{
	void createTestRun(TestRun testRun);

	TestRun getTestRunById(long id);
	
	TestRun getTestRunByIdFull(long id);
	
	List<TestRun> getTestRunsForRerun(@Param("testSuiteId") long testSuiteId, @Param("jobId") long jobId, @Param("upstreamJobId") long upstreamJobId, @Param("upstreamBuildNumber") long upstreamBuildNumber, @Param("uniqueArgs") List<Argument> uniqueArgs);
	
	void updateTestRun(TestRun testRun);

	void deleteTestRunById(long id);

	void deleteTestRun(TestRun testRun);
}
