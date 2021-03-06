package com.lab206.controllers;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lab206.models.Quicklink;
import com.lab206.models.Tag;
import com.lab206.models.User;
import com.lab206.services.AnnouncementService;
import com.lab206.services.PostService;
import com.lab206.services.QuicklinkService;
import com.lab206.services.TagService;
import com.lab206.services.UserService;


@Controller
public class QuicklinkController {
	@Autowired
	private PostService ps;
	private TagService ts;
	private UserService us;
	private AnnouncementService as;
	private QuicklinkService qs;
	
	public QuicklinkController(PostService ps,
			TagService ts,
			UserService us,
			AnnouncementService as,
			QuicklinkService qs) {
		this.ps = ps;
		this.ts = ts;
		this.us = us;
		this.as = as;
		this.qs = qs;
	}
	
	@PostMapping("/quicklinks")
	public String filter(Model model,
			Principal principal, 
			@RequestParam ("language") String tag) {
		Tag t = ts.findTagBySubject(tag.toLowerCase());
		List <Quicklink> quicklinks = qs.findByTag(t);
		User currentUser = us.findByEmail(principal.getName());
		model.addAttribute("posts", ps.allPostsNew());
		model.addAttribute("currentUser", currentUser);
		model.addAttribute("announcements", as.findAll());
		model.addAttribute("quicklinks", quicklinks);
		model.addAttribute("users", us.findByPoints());
		System.out.println(quicklinks);
		return "dashboard.jsp";
		
	}
	
	@PostMapping("/quicklink/create")
	public String createQuicklink(@Valid @ModelAttribute("quicklink") Quicklink quicklink,
			BindingResult result,
			@RequestParam("quicklinkLanguage") String language,
			Model model,
			Principal principal) {
		if (result.hasErrors()) {
			System.out.println(result);
			return "redirect:/dashboard";
		}
		Tag lang = ts.findTagBySubject(language.toLowerCase());
		List<Tag> tags = new ArrayList<Tag>();
		tags.add(lang);
		quicklink.setTags(tags);
		quicklink.setQuicklinkCreator(us.findByEmail(principal.getName()));
		qs.saveQuicklink(quicklink);
		return "redirect:/dashboard";
	}

}
