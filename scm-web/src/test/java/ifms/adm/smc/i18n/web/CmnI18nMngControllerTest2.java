package ifms.adm.smc.i18n.web;

import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;

import java.util.HashMap;
import java.util.Map;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.common.test.SecurityTestUtils;

import org.springframework.http.MediaType;
import org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {
	    "classpath:ifms/spring/context-*.xml",
	    "file:src/main/webapp/WEB-INF/config/ifms/springmvc/dispatcher-servlet.xml"
})
public class CmnI18nMngControllerTest2 {
	
    @Autowired
    private WebApplicationContext wac;

    private MockMvc mockMvc;

    @Before
    public void setup() {
        this.mockMvc = MockMvcBuilders
                .webAppContextSetup(wac)
                .apply(SecurityMockMvcConfigurers.springSecurity())
                .build();
    }
    
    @Test
    public void testCmnI18nMsg() throws Exception {
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n/cmnI18nList.do")
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attributeExists("typCode"));
    }
    
    @Test
    public void testCmnI18nMsgList() throws Exception {
	    Map<String, Object> requestMap = new HashMap<>();
	    requestMap.put("page", 1);
	    requestMap.put("listCount", 10);
	    requestMap.put("code1", "");
	    requestMap.put("code2", "");
	    requestMap.put("code3", "");
	    requestMap.put("locale", "");
	    requestMap.put("message", "");
	    
	    // JSON 변환
	    ObjectMapper mapper = new ObjectMapper();
	    String requestJson = mapper.writeValueAsString(requestMap);
	    
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n/selectI18nMsgList.json")
	            .contentType(MediaType.APPLICATION_JSON)
	            .content(requestJson)
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attributeExists("pagingVO"))
            .andExpect(model().attributeExists("list"));
    }
    
    @Test
    public void testSelectI18nMsgDetail() throws Exception {
	    
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n//cmnI18nDetail.do")
	            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
	            .param("i18nSn", "255")
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attributeExists("typCode"));
    	
    }
    
    @Test
    public void testGoI18nMsgCreate() throws Exception {
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n/cmnI18nCreate.do")
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attributeExists("typCode"));
    }
    
    @Test
    @Transactional("txManagerTemp")
    public void testInsertI18nMsg() throws Exception {
    	Map<String, Object> requestMap = new HashMap<>();
    	requestMap.put("code1", "button");
    	requestMap.put("code2", "button");
    	requestMap.put("code2", "test");
    	requestMap.put("locale", "ko");
    	requestMap.put("message", "test");
    	requestMap.put("description", "test");
    	
	    // JSON 변환
	    ObjectMapper mapper = new ObjectMapper();
	    String requestJson = mapper.writeValueAsString(requestMap);
	    
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n/insertI18nMsg.json")
	            .contentType(MediaType.APPLICATION_JSON)
	            .content(requestJson)
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attribute("result", "success"));
    	
    }
    
    @Test
    @Transactional("txManagerTemp")
    public void testDeleteI18nMsg() throws Exception {
    	Map<String, Object> requestMap = new HashMap<>();
    	requestMap.put("i18nSn", 255);
    	
	    // JSON 변환
	    ObjectMapper mapper = new ObjectMapper();
	    String requestJson = mapper.writeValueAsString(requestMap);
	    
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n/deleteI18nMsg.json")
	            .contentType(MediaType.APPLICATION_JSON)
	            .content(requestJson)
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attribute("result", "success"));
    }
    
    @Test
    public void testGoI18nMsgUpdate() throws Exception {
	    mockMvc.perform(post("/adm/smc/i18n/cmnI18nUpdate.do")
	    		.contentType(MediaType.APPLICATION_FORM_URLENCODED)
	            .param("i18nSn", "279")
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk());
    }
    
    @Test
    @Transactional("txManagerTemp")
    public void testUpdateI18nMsg() throws Exception {
	    Map<String, Object> requestMap = new HashMap<>();
	    requestMap.put("i18nSn", 279);
	    requestMap.put("code1", "button");
	    requestMap.put("code2", "delete");
	    requestMap.put("code3", "ign");
	    requestMap.put("locale", "ko");
	    requestMap.put("message", "삭제");
	    requestMap.put("description", "데이터를 삭제합니다. xxx");
	    
	    // JSON 변환
	    ObjectMapper mapper = new ObjectMapper();
	    String requestJson = mapper.writeValueAsString(requestMap);
	    
	    // when & then
	    mockMvc.perform(post("/adm/smc/i18n/updateI18nMsg.json")
	            .contentType(MediaType.APPLICATION_JSON)
	            .content(requestJson)
	            .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))
        .andDo(print())
            .andExpect(status().isOk())
            .andExpect(model().attribute("success", true));
    }
}
