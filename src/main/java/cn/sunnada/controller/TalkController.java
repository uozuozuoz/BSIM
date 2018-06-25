package cn.sunnada.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/")
public class TalkController {
	
	@RequestMapping("talk")
	public String startTalk() {
		return "WEB-INF/jsp/index";
	}
	
	@RequestMapping("kefu")
	public String startKefu() {
		return "WEB-INF/jsp/kefu";
	}

}
