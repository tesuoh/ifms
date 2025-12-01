package ifms.adm.bbs.faq.web;

import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.user;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;

import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

import ifms.common.test.SecurityTestUtils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.test.web.servlet.setup.SecurityMockMvcConfigurers;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {
    "classpath:ifms/spring/context-*.xml",
    "file:src/main/webapp/WEB-INF/config/ifms/springmvc/dispatcher-servlet.xml"
})
public class AdmFaqControllerTest2 {

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
    public void testSelectAdmFaqListJson() throws Exception {
        Map<String, Object> requestMap = new HashMap<>();
        requestMap.put("page", 1);
        requestMap.put("listCount", 10);

        ObjectMapper mapper = new ObjectMapper();
        String requestJson = mapper.writeValueAsString(requestMap);

       mockMvc.perform(post("/adm/bbs/faq/selectFaqList.json")
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
    @Transactional
    public void testCreateFaq() throws Exception {
        Map<String, Object> faqData = new HashMap<>();
        faqData.put("title", "테스트 제목");
        faqData.put("contents", "내용입니다");
        faqData.put("category", "공지");

        ObjectMapper objectMapper = new ObjectMapper();
        String requestJson = objectMapper.writeValueAsString(faqData);

        mockMvc.perform(post("/adm/bbs/faq/createFaq.json")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson)
                .with(SecurityTestUtils.customAuthUser("szmsadm123", "1234"))
                .with(csrf()))       
            .andExpect(status().isOk())
            .andExpect(model().attribute("result", "success"));
    }

    @Test
    @Transactional
    public void testGoFaqUpdate() throws Exception {
        mockMvc.perform(post("/adm/bbs/faq/admFaqUpdate.do")
                .contentType(MediaType.APPLICATION_FORM_URLENCODED)
                .param("faqId", "FAQ001")
                .with(user("szmsadm123").roles("ADMIN"))
                .with(csrf()))
                .andExpect(status().isOk())
                .andExpect(model().attributeExists("faqCategory"));
//                .andExpect(model().attributeExists("detail"));
    }
}