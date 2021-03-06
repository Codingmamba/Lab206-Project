package com.lab206.controllers;

import java.security.Principal;
import java.util.List;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.lab206.models.Comment;
import com.lab206.models.Feedback;
import com.lab206.models.Post;
import com.lab206.models.Report;
import com.lab206.models.User;
import com.lab206.services.CommentService;
import com.lab206.services.FeedbackService;
import com.lab206.services.PostService;
import com.lab206.services.ReportService;
import com.lab206.services.UserService;

@RestController
@RequestMapping("/post")
public class PostRestController {
	
	private PostService ps;
	private CommentService cs;
	private UserService us;
	private FeedbackService fs;
	private ReportService rs;
	
	public PostRestController(PostService ps,
			CommentService cs,
			UserService us,
			FeedbackService fs,
			ReportService rs) {
		this.ps = ps;
		this.cs = cs;
		this.us = us;
		this.fs = fs;
		this.rs = rs;
	}
	
	// For confirming the removal of a user
	@RequestMapping("/remove/{id}")
	public User removingAUser(@PathVariable("id") Long id) {
		return us.findById(id);
	}

	@RequestMapping("/show/{id}")
	public Post showPost(@PathVariable("id") Long id) {
		return ps.findPostById(id);
	}
	
	
	// Displaying feedback in moderator dashboard
	@RequestMapping("/feedbacks/{id}")
	public Feedback showFeedback(@PathVariable("id") Long id) {
		return fs.findFeedbackById(id);
	}
	
	// Displaying reports in moderator dashboard
	@RequestMapping("/reports/{id}")
	public Report showReports(@PathVariable("id") Long id) {
		return rs.findReportById(id);
	}
	
	@RequestMapping("/{id}/comments")
	public List<Comment> getCommentsByPost(@PathVariable("id") Long id) {
		return cs.findByPostDesc(ps.findPostById(id));
	}
	
//	@RequestMapping("/{id}/like")
//	public void likePost(@PathVariable("id") Long id,
//			Principal principal) {
//		User currentUser = us.findByEmail(principal.getName());
//		Post post = ps.findPostById(id);
//		
//	}
}
