package ifms.core.view;

import org.springframework.util.FileCopyUtils;
import org.springframework.web.servlet.view.AbstractView;
import ifms.common.file.vo.FileDownloadVO;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Map;

public class FileDownloadView extends AbstractView {

    @Override
    protected void renderMergedOutputModel(Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

        OutputStream out = response.getOutputStream();
        FileInputStream fis = null;

        try {

            FileDownloadVO fileDownloadVO = (FileDownloadVO) model.get("fileDownloadVO");

            response.setContentType(fileDownloadVO.getContentType());
            response.setContentLength((int) fileDownloadVO.getFileLength());
            response.setHeader("Content-Disposition", "attachment; filename=\""+fileDownloadVO.getDownloadFileNm()+"\";");

            fis = new FileInputStream(new File(fileDownloadVO.getFileFullPath()));
            FileCopyUtils.copy(fis, out);

        } catch(ClassCastException | NullPointerException | SecurityException | IOException e) {
            logger.error(e);

            response.sendRedirect(request.getContextPath()+"/common/error/view500.do");

        } finally {
            if(fis!=null) {
                fis.close();
            }
        }
        out.flush();
    }
}
