package ifms.adm.bbs.qna.web;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.databind.ObjectMapper;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {
	    "classpath:ifms/spring/context-root.xml", // ApplicationContext 설정
	    "file:src/main/webapp/WEB-INF/config/ifms/springmvc/dispatcher-servlet.xml" // DispatcherServlet 설정
})
public class AdmQnaControllerTest {
	
    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Autowired
    // private ObjectMapper objectMapper; // JSON 변환기 (bean 등록 안 되어 있으면 new ObjectMapper()로 사용)

    @Before
    public void setup() {
        this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
    }

	@Test
	public void testSelectAdmQnaList() {
		fail("Not yet implemented");
	}
	
	@Test
	public void testAdmQnaDetail() {
		fail("Not yet implemented");
	}
	
	@Test
	public void testQnaAnsCnInsert() {
		fail("Not yet implemented");
	}
	
	@Test
	public void testQnaQstnDelete() {
		fail("Not yet implemented");
	}
}
