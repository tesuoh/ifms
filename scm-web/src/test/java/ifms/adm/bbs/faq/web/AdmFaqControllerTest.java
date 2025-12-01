package ifms.adm.bbs.faq.web;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.http.MediaType;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.adm.bbs.faq.service.AdmFaqService;
import ifms.core.security.service.AuthUser;
import ifms.core.security.vo.SessionVO;

import org.springframework.security.core.Authentication;
import org.springframework.ui.ModelMap;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {
	    "classpath:ifms/spring/context-*.xml",
	    "file:src/main/webapp/WEB-INF/config/ifms/springmvc/dispatcher-servlet.xml"
})
public class AdmFaqControllerTest{
	
    private MockMvc mockMvc;

    @Mock
    private AdmFaqService admFaqServiceMock;

    @InjectMocks
    private AdmFaqController admFaqController;
    
    @Before
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(admFaqController).build();
    }
    
    @Test
    public void testSelectAdmFaqList() throws Exception {
    	
    }
	
	@Test
	public void testSelectAdmFaqListJson() throws Exception {
	    // given
	    Map<String, Object> requestMap = new HashMap<>();
	    requestMap.put("page", 1);
	    requestMap.put("listCount", 10);

	    // 페이징 관련 반환값
	    when(admFaqServiceMock.selectFaqListTotalCnt(any())).thenReturn(1);

	    List<Map<String, Object>> dummyFaqList = new ArrayList<>();
	    Map<String, Object> item = new HashMap<>();
	    item.put("title", "샘플 FAQ");
	    dummyFaqList.add(item);

	    when(admFaqServiceMock.selectFaqList(any())).thenReturn(dummyFaqList);

	    // mock 인증 객체 설정
	    SessionVO sessionVO = new SessionVO();
	    sessionVO.setUserId("szmsadm123");

	    AuthUser authUser = mock(AuthUser.class);
	    when(authUser.getSessionVO()).thenReturn(sessionVO);

	    Authentication authentication = mock(Authentication.class);
	    when(authentication.getPrincipal()).thenReturn(authUser);

	    // JSON 변환
	    ObjectMapper mapper = new ObjectMapper();
	    String requestJson = mapper.writeValueAsString(requestMap);

	    // when & then
	    mockMvc.perform(post("/adm/bbs/faq/selectFaqList.json")
	            .contentType(MediaType.APPLICATION_JSON)
	            .content(requestJson)
	            .principal(authentication))
	        .andExpect(status().isOk())
	        .andExpect(model().attributeExists("pagingVO"))
	        .andExpect(model().attributeExists("list"));
	}
	
	@Test
	public void testGoCreateFaq() throws Exception {
		
	}

    @Test
    public void testCreateFaq() throws Exception {
        Map<String, Object> faqData = new HashMap<>();
        faqData.put("title", "테스트 제목");
        faqData.put("contents", "내용입니다");
        faqData.put("category", "공지");

        SessionVO sessionVO = new SessionVO();
        sessionVO.setUserId("szmsadm123");

        AuthUser authUser = mock(AuthUser.class);
        when(authUser.getSessionVO()).thenReturn(sessionVO);

        Authentication authentication = mock(Authentication.class);
        when(authentication.getPrincipal()).thenReturn(authUser);

        when(admFaqServiceMock.insertFaq(any())).thenReturn(1);

        ObjectMapper objectMapper = new ObjectMapper();
        String requestJson = objectMapper.writeValueAsString(faqData);

        mockMvc.perform(post("/adm/bbs/faq/createFaq.json")
                .principal(authentication)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isOk())
                .andExpect(model().attribute("result", "success"));
        
    }
	
	@Test
	public void testDeleteFaq() throws Exception {
		
	}
	
	@Test
	public void testGoFaqUpdate() throws Exception {
	    // given
	    Map<String, Object> requestMap = new HashMap<>();
	    requestMap.put("faqId", "FAQ001");

	    List<Map<String, Object>> dummyCategory = new ArrayList<>();
	    Map<String, Object> category = new HashMap<>();
	    category.put("code", "CAT001");
	    category.put("name", "공지");
	    dummyCategory.add(category);

	    Map<String, Object> dummyDetail = new HashMap<>();
	    dummyDetail.put("title", "수정할 FAQ");
	    
        SessionVO sessionVO = new SessionVO();
        sessionVO.setUserId("szmsadm123");

        AuthUser authUser = mock(AuthUser.class);
        when(authUser.getSessionVO()).thenReturn(sessionVO);

        Authentication authentication = mock(Authentication.class);
        when(authentication.getPrincipal()).thenReturn(authUser);

	    when(admFaqServiceMock.selectFaqCategory()).thenReturn(dummyCategory);
	    when(admFaqServiceMock.selectFaqDetail(any())).thenReturn(dummyDetail);

	    // when & then
	    mockMvc.perform(post("/adm/bbs/faq/admFaqUpdate.do")
	    		.principal(authentication)
	            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
	            .param("faqId", "FAQ001"))
		        .andExpect(status().isOk())
		        .andExpect(model().attribute("faqCategory", dummyCategory))
		        .andExpect(model().attribute("detail", dummyDetail));
	    
	}
	
	@Test
	public void testUpdateFaq() throws Exception {
		
	}

}
