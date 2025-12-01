package ifms.core.i18n.web;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.LocaleResolver;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;

@RestController
@RequestMapping("/api/locale")
public class LocaleController {

    private final LocaleResolver localeResolver;

    public LocaleController(LocaleResolver localeResolver) {
        this.localeResolver = localeResolver;
    }

    @PostMapping("/change.json")
    public String changeLocale(@RequestParam("lang") String lang,
                               HttpServletRequest request,
                               HttpServletResponse response) {
        Locale locale = new Locale(lang);
        localeResolver.setLocale(request, response, locale);
        return "Locale changed to " + lang;
    }
}