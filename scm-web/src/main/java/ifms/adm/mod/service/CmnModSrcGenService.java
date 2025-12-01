package ifms.adm.mod.service;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import ifms.adm.mod.mapper.CmnModSrcGenMapper;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.HashMap;
import java.util.Map;

@Service
public class CmnModSrcGenService {

    public final Log logger = LogFactory.getLog(this.getClass());


    @Autowired
    private CmnModSrcGenMapper cmnModSrcGenMapper;


    public Map<String, String> generateCode(String packagePath, String entityName, String comment, String tableName) {
        Map<String, String> result = new HashMap<>();

        String lowerEntity = Character.toLowerCase(entityName.charAt(0)) + entityName.substring(1);

        // 템플릿 파일 읽기 -> 실제로는 파일 IO나 ClassPathResource를 활용하거나, DB에서 템플릿 관리 가능.
        String controllerTemplate = loadTemplate("ControllerTemplate.txt");
        String serviceTemplate = loadTemplate("ServiceTemplate.txt");
        String mapperTemplate = loadTemplate("MapperTemplate.txt");
        String xmlTemplate = loadTemplate("XmlTemplate.txt");
        String jspListTemplate = loadTemplate("JspListTemplate.txt");

        // 변환 작업(간단한 String.replace, 혹은 정규식, 또는 템플릿 엔진 사용)
        String controllerCode = controllerTemplate
                .replace("${package}", packagePath)
                .replace("${entityName}", entityName)
                .replace("${lowerEntity}", lowerEntity)
                .replace("${comment}", comment)
                .replace("${tableName}", tableName);

        String serviceCode = serviceTemplate
                .replace("${package}", packagePath)
                .replace("${entityName}", entityName)
                .replace("${lowerEntity}", lowerEntity)
                .replace("${comment}", comment);

        String mapperCode = mapperTemplate
                .replace("${package}", packagePath)
                .replace("${entityName}", entityName)
                .replace("${comment}", comment);

        String xmlCode = xmlTemplate
                .replace("${package}", packagePath)
                .replace("${entityName}", entityName)
                .replace("${tableName}", tableName);

        String jspListCode = jspListTemplate
                .replace("${comment}", comment);

        // 결과 map에 담기
        result.put("controller", controllerCode);
        result.put("service", serviceCode);
        result.put("mapper", mapperCode);
        result.put("xml", xmlCode);
        result.put("jspList", jspListCode);

        return result;
    }

    private String loadTemplate(String templateName) {
        try {
            Resource resource = new ClassPathResource("ifms/codeTemplates/" + templateName);
            return new String(Files.readAllBytes(resource.getFile().toPath()), StandardCharsets.UTF_8);
        } catch (IOException e) {
            // 예외 처리 로직
            return "";
        }
    }



}
