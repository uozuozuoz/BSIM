package cn.sunnada.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/")
public class TalkController {

	@RequestMapping("talk")
	public ModelAndView startTalk(HttpServletRequest request) {

		ModelMap map = new ModelMap();
//		String kehuid = request.getParameter("kehu");
//
//		map.put("kehu", kehuid);

		return new ModelAndView("WEB-INF/jsp/index", map);
	}

	@RequestMapping("kefu")
	public String startKefu() {
		return "WEB-INF/jsp/kefu";
	}

}
