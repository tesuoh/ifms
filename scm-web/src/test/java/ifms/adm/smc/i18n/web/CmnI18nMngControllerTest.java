package ifms.adm.smc.i18n.web;

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
import ifms.adm.bbs.faq.web.AdmFaqController;
import ifms.adm.smc.i18n.service.CmnI18nCodeService;
import ifms.adm.smc.i18n.service.CmnI18nMsgMngService;
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
public class CmnI18nMngControllerTest {
	
	private MockMvc mockMvc;

    @Mock
    private CmnI18nMsgMngService cmnI18nMsgMngServiceMock;
    
    @Mock
    private CmnI18nCodeService cmnI18nCodeServiceMock;

    @InjectMocks
    private CmnI18nMngController cmnI18nMngController;
    
    @Before
    public void setup() {
        MockitoAnnotations.openMocks(this);
        mockMvc = MockMvcBuilders.standaloneSetup(cmnI18nMngController).build();
    }
    
    @Test
    public void testCmnI18nMsg() throws Exception {
    	
    }
    
    @Test
    public void testCmnI18nMsgList() throws Exception {
	    Map<String, Object> requestMap = new HashMap<>();
	    requestMap.put("page", 1);
	    requestMap.put("listCount", 10);
	    
	    when(cmnI18nMsgMngServiceMock.selectI18nMsgListTotalCnt(any())).thenReturn(1);
	    
	    List<Map<String, Object>> dummyI18nList = new ArrayList<>();
	    Map<String, Object> item = new HashMap<>();
	    item.put("title", "샘플 I18N");
	    dummyI18nList.add(item);
	    
	    when(cmnI18nMsgMngServiceMock.selectI18nMsgList(any())).thenReturn(dummyI18nList);
	    
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
	    mockMvc.perform(post("/adm/smc/i18n/selectI18nMsgList.json")
	            .contentType(MediaType.APPLICATION_JSON)
	            .content(requestJson)
	            .principal(authentication))
	        .andExpect(status().isOk())
	        .andExpect(model().attributeExists("pagingVO"))
	        .andExpect(model().attributeExists("list"));
    }
    
    @Test
    public void testSelectI18nMsgDetail() throws Exception {
    	
    }
    
    @Test
    public void testGoI18nMsgCreate() throws Exception {
    	
    }
    
    @Test
    public void testInsertI18nMsg() throws Exception {
    	
    }
    
    @Test
    public void testDeleteI18nMsg() throws Exception {
    	
    }
    
    @Test
    public void testGoI18nMsgUpdate() throws Exception {
    	
    }
    
    @Test
    public void testUpdateI18nMsg() throws Exception {
    	
    }
   
    
    
    
    
    
    

}
