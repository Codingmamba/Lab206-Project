<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Teccy Space | View Post</title>
		<link rel="stylesheet" href="/css/style.css">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
		<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
		<script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
		<script src="/js/script.js"></script>
		
		
		<!-- Auto-opens new post modal if user was creating post and had errors -->
		<c:if test="${posting == true}">
			<script type="text/javascript">
			    $(document).ready(function(){
			        $('#newPostModal').modal('show');
			    });
			</script>
		</c:if>
		<c:if test="${editing == true}">
			<script type="text/javascript">
			    $(document).ready(function(){
			        $('#settingsModal').modal('show');
			    });
			</script>
		</c:if>

	</head>
	<body>

		<c:if test="${logoutMessage != null}" >
			<c:out value="${logoutMessage}"></c:out>
		</c:if>
    <!-- Nav bar -->
		<nav class="navbar sticky-top shadow-small mb-3" id="navvy">
		<div class="dropdown">
			<button class="close" type="button" data-toggle="dropdown">
			<i class="fa fa-bars" aria-hidden="true"></i></button>
			<ul class="dropdown-menu test">
            <!-- Settings button -->
			    <li><a href="#settingsModal" data-toggle="modal" data-target="#settingsModal" aria-label="Settings">
					<i class="fa fa-cog nav-link" aria-hidden="true"></i>Settings</a>
				</li>
            <!-- Help button -->
			    <li><a href="#helpModal" data-toggle="modal" data-target="#helpModal" aria-label="Help">
					<i class="fa fa-question-circle nav-link" aria-hidden="true"></i>Help</a>
				</li>
            <!-- Feedback button -->
				<li><a href="#feedbackModal" data-toggle="modal" data-target="#feedbackModal" aria-label="Feedback">
					<i class="fa fa-comment nav-link" aria-hidden="true"></i>Feedback</a>
				</li>
				<li>
            <!-- Logout button -->
					<form id="logoutForm" method="POST" action="/logout">
						<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
						<button type="submit" class="text-button"><i class="fa fa-power-off nav-link" aria-hidden="true"></i>Logout</button>
					</form>
				</li>
			</ul>
		</div>			
			
		<a href="/dashboard"><img src="/img/logo.png" alt="Lab 206 Logo" id="logo"></a>
        	<!-- User profile image, show default if there is no image in the database -->
			<c:choose>
				<c:when test="${currentUser.file.getId() != null}">
					<a href="/profile/${currentUser.id}">
						<img class="avatar" src="/imageDisplay?id=${currentUser.id}" alt="User Avatar"/>
					</a>
				</c:when>
				<c:otherwise>
		        	<a href="/profile/${currentUser.id}">
		                <img src="https://www.in-depthoutdoors.com/wp-content/themes/ido/img/ido-avatar.png" alt="User Avatar" class="avatar">
		            </a>
				</c:otherwise>
            </c:choose>

			<ul class="navbar-nav mr-auto">
				<li class="nav-item">Name: <c:out value="${currentUser.firstName} ${currentUser.lastName}"/></li>
				<li class="nav-item">Points: <c:out value="${currentUser.points}"/></li>
			</ul>
			
			<!-- Search bar -->
			<form class="my-2 my-lg-0" id="searchy" action="/search">
				<div class="input-group">
					<input name="keyword" type="text" class="form-control" placeholder="Search query..." aria-label="Search query"/>
					<select name="category">
						<option>Posts</option>
						<option>Comments</option>
						<option>Users</option>
						<option>Tags</option>
					</select>
					<div class="input-group-append">
						<button class="btn bg-cosmic-cobalt text-white my-2 my-sm-0" type="submit">Search</button>
					</div>
				</div>
			</form>
		</nav>

		<div class="row" id="contentRow">
			<!-- Show post -->
			<div class="col-md-8">
				<div class="row">
					<div class="col-md-10 offset-md-1 rounded-top bg-gunmetal">
						<c:choose>
							<c:when test="${currentUser == post.author}">
								<a href="/post/<c:out value="${post.id}"/>/delete" class="text-gray-blue float-right post-header"><i class="far fa-trash-alt" aria-hidden="true"></i></a>
								<span class="float-right">&nbsp;&nbsp;</span>
								<a href="/post/<c:out value="${post.id}"/>/edit" data-toggle="modal" data-target="#editModal" id="editIdPost" class="edit text-gray-blue testingEdit float-right post-header"><i class="fa fa-edit" aria-hidden="true"></i></a>		
							</c:when>
							<c:otherwise>
								<c:choose>
									<c:when test="${currentUser.likedPosts.contains(post)}">
										<a href='/post/<c:out value="${post.id}"/>/unlike' class="liked post-header"><i class="fa fa-thumbs-up"></i></a>
									</c:when>
									<c:otherwise>
										<a href='/post/<c:out value="${post.id}"/>/like' class="like post-header"><i class="fa fa-thumbs-up"></i></a>
									</c:otherwise>
								</c:choose>
								<span class="float-right">&nbsp;&nbsp;</span>
								<span class="text-ghost-white small float-right post-header"><c:out value="${post.postLikes.size()}"/></span>
							</c:otherwise>
						</c:choose>
						<h1 class="text-ghost-white"><c:out value="${post.title}"/></h1>
						<c:forEach var="tag" items="${post.tags}">
							<li class="list-inline-item"><span class="badge badge-pill text-ghost-white <c:out value="${tag.color}"/> post-footer"><c:out value="${tag.subject}"/></span></li>
						</c:forEach>
					</div>
				</div>
				<div class="row">
					<div class="col-md-10 offset-md-1 rounded-top content-panel">
						<div class="row">
							<c:choose>
								<c:when test="${post.author.file.getId() != null}">
									<a href="/profile/${post.author.id}">
										<img class="avatar" src="/imageDisplay?id=${post.author.id}" width=100px alt="User Avatar"/>
									</a>
								</c:when>
								<c:otherwise>
									<a href="/profile/${post.author.id}">
										<img src="https://www.in-depthoutdoors.com/wp-content/themes/ido/img/ido-avatar.png" alt="User Avatar" class="avatar">
									</a>
								</c:otherwise>
							</c:choose>
							<div class="col-sm-3">
								<ul class="navbar-nav mr-auto">
									<li class="nav-item"><strong>Name:</strong> <c:out value="${post.author.firstName} ${post.author.lastName}"/></li>
									<li class="nav-item"><strong>Points:</strong> <c:out value="${currentUser.points}"/></li>
									<li class="nav-item"><strong>Badges:</strong> <c:out value="${currentUser.points}"/></li>
								</ul>
							</div>
							<div class="col-sm-7">
								<i class="far fa-folder-open"></i>
								<!-- Iterate through tags in each post -->
								<c:forEach var="file" items="${post.attachments}">
									(<a href='/showFile/<c:out value="${file.id}"/>' target="_blank"><c:out value="${file.fileName}"/></a>)&nbsp;
								</c:forEach>
							</div>
						</div>
						<hr>
						<div class="row mb-3">
							<div class="col-sm-12">
								<p class="line-breaks"><c:out value="${post.content}"/></p>
								<a href="" data-toggle="modal" data-target="#reportModal" class="report"><i class="fa fa-flag" aria-hidden="true"></i></a>
								<ul class="time-list">
									<li class="nav-item">Created At: <fmt:formatDate type="both" 
										dateStyle="short" timeStyle="short" value="${post.createdAt}"/></li>
									<c:if test="${post.updatedAt != null}">
										<li class="nav-item">Last Edit: <fmt:formatDate type="both" 
											dateStyle="short" timeStyle="short" value="${post.updatedAt}"/></li>
									</c:if>
								</ul>
							</div>
						</div>
						<div class="row mb-3">
							<!-- New Comment form -->
							<div class="col-sm-12" id="newComment">
								<form name="newCommentForm" id="newCommentForm" method="post">
									<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
									<input type="hidden" value="${post.id}" name="postId" id="commentPostId">
									<div class="input-group mb-3">
										<div class="input-group-prepend">
											<span class="input-group-text">Content</span>
										</div>
										<textarea id="newCommentContent" name="newCommentContent" placeholder="Enter comment here" class="form-control" aria-label="Comment text"></textarea>
									</div>
									<button type="submit" class="btn bg-cosmic-cobalt text-ghost-white float-right">Submit</button>
								</form>
							</div>
						</div>
						<!-- Show comments -->
						<div id="showComments">
							<c:if test="${post.answer != null}">
								<div class="row">
									<div class="col-sm-12 answered">
										<a href="" class="like"><i class="fas fa-thumbs-up"></i></a>
										<h5><c:out value="${post.answer.commenter.firstName}"/> replying to <c:out value="${post.author.firstName}"/></h5>
										<p class="line-breaks"><c:out value="${post.answer.content}"/></p>
										<ul class="time-list">
											<li>Created At: <fmt:formatDate type="both" 
												dateStyle="short" timeStyle="short" value="${post.answer.createdAt}"/></li>
											<c:if test="${post.answer.updatedAt != null}">
												<li>Last Edit: <fmt:formatDate type="both" 
													dateStyle="short" timeStyle="short" value="${post.answer.updatedAt}"/></li>
											</c:if>
										</ul>
									</div>
								</div>
								<hr>
							</c:if>
							<c:forEach var="comment" items="${post.comments}">
								<c:if test="${comment != post.answer}">
									<div class="row">
										<div class="col-sm-12">
											<c:if test="${currentUser == post.author && post.answer == null}">
												<a href="/post/<c:out value="${post.id}"/>/answer/<c:out value="${comment.id}"/>" class="answer"><i class="fas fa-check-circle"></i></a>
												<span class="float-right">&nbsp;&nbsp;</span>
											</c:if>
											<a href="" class="like"><i class="fas fa-thumbs-up"></i></a>
											<h5><c:out value="${comment.commenter.firstName}"/> replying to <c:out value="${post.author.firstName}"/></h5>
											<p class="line-breaks"><c:out value="${comment.content}"/></p>
											<ul class="time-list">
												<li>Created At: <fmt:formatDate type="both" 
													dateStyle="short" timeStyle="short" value="${comment.createdAt}"/></li>
												<c:if test="${comment.updatedAt != null}">
													<li>Last Edit: <fmt:formatDate type="both" 
														dateStyle="short" timeStyle="short" value="${comment.updatedAt}"/></li>
												</c:if>
											</ul>
										</div>
									</div>
									<hr>
								</c:if>
							</c:forEach>
						</div>
					</div>
				</div>
			</div>
			<!-- Announcements, leaderboards, quicklinks -->
			<div class="col-md-3">
				<div class="row">
					<div class="col-md-12 rounded-top bg-gunmetal">
						<h1 class="text-ghost-white">Announcements</h1>
					</div>
				</div>
				<div class="row">
					<!-- Announcements go here-->
					<div class="col-12 content-panel">
						<c:forEach var="announcement" items="${announcements}" varStatus="status"> 
								<c:if test="${status.count <= 5}">
									<h3>${announcement.subject}</h3>
									<p>${announcement.content}</p>
								</c:if>
						</c:forEach>
						<a href="/announcements">View all</a>
					</div>
				</div>
				<div class="row">
					<!-- Leaderboard header -->
					<div class="col-12 rounded-top text-ghost-white bg-gunmetal">
						<h1>Leaderboard</h1>
					</div>
				</div>
				<div class="row">
					<!-- Leaderboard content -->
					<div class="col-12 content-panel">
						<ol>
							<c:forEach var="user" items="${users}" varStatus="status"> 
								<c:if test="${status.count <= 5}">
									<li>
										<a target="_blank" href="/profile/${user.id}">
											<c:choose>
												<c:when test="${user.file != null}">
													<img class="avatar" src="/imageDisplay?id=${user.id}" alt="User Avatar"/>
												</c:when>
												<c:otherwise>
													<img class="avatar" src="https://www.in-depthoutdoors.com/wp-content/themes/ido/img/ido-avatar.png" alt="User Avatar"/>
												</c:otherwise>
											</c:choose>
										</a>
										<p>${user.firstName} ${user.lastName} | ${user.points} points</p>
									</li>
								</c:if>
							</c:forEach>
						</ol>
					</div>
				</div>
				<div class="row">
					<!-- Quicklink header -->
					<div class="col-12 rounded-top text-ghost-white bg-gunmetal">
							<h1>Quicklinks</h1>
					</div>
				</div>
				<div class="row">
					<!-- Quicklinks list; iterate through quicklinks -->
					<div class="col-12 content-panel">
						<form class="my-2 my-lg-0" method="post" id="quicklink" action="/quicklinks">
							<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
							<div class="input-group">
								<select name="language">
									<option>C++</option>
									<option>C#</option>
									<option>CSS</option>
									<option>HTML</option>
									<option>Java</option>
									<option>JavaScript</option>
									<option>Perl</option>
									<option>PHP</option>
									<option>Python</option>
									<option>Ruby</option>
								</select>
								<div class="input-group-append">
									<button class="btn bg-cosmic-cobalt text-white my-2 my-sm-0" type="submit">Filter</button>
								</div>
							</div>
						</form>
					</div>
						<ul>
						<c:forEach var="quicklink" items="${quicklinks}" varStatus="status">
							<c:if test="${status.count <= 10}">
								<li><a target="_blank" href="${quicklink.url}">${quicklink.name}</a></li>
							</c:if>
						</c:forEach>
						</ul>
					</div>
				</div>
			</div>
		</div>
		
		<!-- Edit modal -->
		<div id="editModal" class="modal fade" role="dialog">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<h2 class="modal-title">Edit Post</h2>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<form:form action="/post/${post.id}/edit" modelAttribute="post" method="post" enctype="multipart/form-data" id="editIdPost">
						<div class="row mb-3">
							<div class="col-6">
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text" id="courseRelated">Course Related</span>
									</div>
									<label class="switch">
										<c:set var="courserelated" value="false"/>
										<c:choose>
											<c:when test="${post.tags[0].subject == 'coursework'}">
												<c:set var="courserelated" value="true"/>
												<input type="checkbox" id="currentCourse" name="currentCourse" aria-describedby="courseRelated" checked="true">
											</c:when>
											<c:otherwise>
												<input type="checkbox" id="currentCourse" name="currentCourse" aria-describedby="courseRelated">
											</c:otherwise>
										</c:choose>
										<span class="slider round"></span>
									</label>
								</div>
							</div>
							<div class="col-6">
								<div class="input-group">
									<div class="input-group-prepend">
										<span class="input-group-text" id="newPostLanguage">Language</span>
									</div>
									<c:set var="language" value="1"/>
									<c:choose>
										<c:when test="${courserelated}">
											<c:set var="language" value="1"/>
										</c:when>
										<c:otherwise>
											<c:set var="language" value="0"/>
										</c:otherwise>
									</c:choose>
									<select class="form-control" id="currentLanguage" name="currentLanguage" aria-label="Language" aria-describedby="newPostLanguage">
										<c:forEach var="lang" items="${languages}">
											<c:choose>
												<c:when test="${post.tags[language].subject == lang.toLowerCase()}">
													<option selected="selected" value="<c:out value="${lang.toLowerCase()}"/>"><c:out value="${lang}"/></option>
												</c:when>
												<c:otherwise>
													<option value="<c:out value="${lang}"/>"><c:out value="${lang}"/></option>
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</select>
								</div>
							</div>
						</div>
			            <form:errors path="title"/>
							<div class="input-group mb-3">
								<div class="input-group-prepend">	
									<span class="input-group-text" id="newPost-title">Title</span>
								</div>
								<form:input path="title" name="title" id="currentTitle" class="form-control" aria-label="Title"/>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">Tags</span>
								</div>
								<c:set var="tagNum" value="1"/>
								<c:forEach var="tagIndex" begin="${language + 1}" end="${language + 3}">
									<c:choose>
										<c:when test="${post.tags[tagIndex] != null}">
											<input type="text" class="form-control" id="tag<c:out value="${tagNum}"/>" name="tag<c:out value="${tagNum}"/>" value="<c:out value="${post.tags[tagIndex].subject}"/>">
										</c:when>
										<c:otherwise>
											<input type="text" class="form-control" id="tag<c:out value="${tagNum}"/>" name="tag<c:out value="${tagNum}"/>">
										</c:otherwise>
									</c:choose>
									<c:set var="tagNum" value="${tagNum + 1}"/>
								</c:forEach>
							</div>
							<form:errors path="content"/>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">Content</span>
								</div>
								<form:textarea path="content" name="content" id="currentContent" class="form-control" aria-label="Content"/>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									
									<span class="input-group-text">File#1</span>
								</div>
								<div class="custom-file">
									<input type="file" name="file" class="custom-file-input" id="currentInputGroupFile01">
									<label class="custom-file-label" for="inputGroupFile01">Choose file</label>
								</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">File#2</span>
								</div>
								<div class="custom-file">
									<input type="file" name="file" class="custom-file-input" id="currentInputGroupFile02">
									<label class="custom-file-label" for="inputGroupFile02">Choose file</label>
								</div>	
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">File#3</span>
								</div>
								<div class="custom-file">
									<input type="file" name="file" class="custom-file-input" id="currentInputGroupFile03">
									<label class="custom-file-label" for="inputGroupFile03">Choose file</label>
								</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">File#4</span>
								</div>
								<div class="custom-file">
									<input type="file" name="file" class="custom-file-input" id="currentInputGroupFile04">
									<label class="custom-file-label" for="inputGroupFile04">Choose file</label>
								</div>
							</div>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">File#5</span>
								</div>
								<div class="custom-file">
									<input type="file" name="file" class="custom-file-input" id="currentInputGroupFile05">
									<label class="custom-file-label" for="inputGroupFile05">Choose file</label>
								</div>
							</div>
							<button type="submit" class="btn bg-cosmic-cobalt text-ghost-white float-right">Submit</button>
						</form:form>
			    	</div>
				</div>
			</div>
		</div>

		<!-- Settings Modal -->
		<div id="settingsModal" class="modal fade" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h2 class="modal-title">Settings</h2>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<form:form action="/user/edit" modelAttribute="user" method="post" enctype="multipart/form-data">
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">Avatar</span>
								</div>
								<div class="custom-file">
									<input type="file" name="avatar" class="custom-file-input" id="inputGroupFile01">
									<label class="custom-file-label" for="inputGroupFile01">Choose file</label>
								</div>
							</div>
							<form:errors path="firstName"/>
							<form:errors path="lastName"/>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">Name</span>
								</div>
								<input type="text" name="firstName" class="form-control" value="<c:out value="${currentUser.firstName}"/>">
								<input type="text" name="lastName" class="form-control" value="<c:out value="${currentUser.lastName}"/>">
							</div>
							<form:errors path="email"/>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text" id="basic-addon1">Email</span>
								</div>
								<input type="text" class="form-control" name="email" aria-label="Email" aria-describedby="basic-addon1" value="<c:out value="${currentUser.email}"/>">
							</div>
							<form:errors path="about"/>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">About Me<br>(Optional)</span>
								</div>
								<textarea name="about" placeholder='<c:out value="${currentUser.about}"/>'  class="form-control" aria-label="AboutMe"><c:out value="${currentUser.about}"/></textarea>
							</div>
							<form:errors path="passwordConfirmation"/>
							<div class="input-group mb-3">
								<div class="input-group-prepend">
									<span class="input-group-text">Password Confirmation</span>
								</div>
								<input type="password" name="passwordConfirmation" class="form-control" aria-label="PC"/>
							</div>
							<button type="submit" class="btn bg-cosmic-cobalt text-ghost-white float-right">Save</button>
						</form:form>
			    	</div>
				</div>
			</div>
		</div>
		
		<!-- Help Modal -->
		<div id="helpModal" class="modal fade" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h2 class="modal-title">Help</h2>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<h3>FAQ: Rules and Etiquette</h3>
						<ul>
							<li>Please be professional and respectful of others.</li>
							<li>Do not share exam codes. Plagiarism is not tolerated on this platform and will be reported.</li>
							<li>Do not share ANY Amazon related information and internal links.</li>
							<li>If you have any suggestion(s) or if something is not working, please submit your feedback on the top left menu and click on the <i class="fa fa-comment text-gunmetal" aria-hidden="true"></i>.</a></li>
							<li>If you would like to file a report, please click the <i class="fa fa-flag text-gunmetal" aria-hidden="true"></i> on a post located on the bottom right.</li>
							<li>Please mark comments wisely. Use "check" <i class="fas fa-check-circle text-gunmetal"></i> if it was helpful for you so other users are able to see correct solutions.</li>
						</ul>
					</div>
				</div>
			</div>
		</div>
			
		<!-- Report Modal -->
		<div id="reportModal" class="modal fade" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h2 class="modal-title">File a Report</h2>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="input-group mb-3">
							<div class="input-group-prepend">
							</div>
							<p>If this post or comment(s) related have abusive or unprofessional content, please submit your report. We will review the content and remove anything that does not follow our platform's Rules and Etiquette found on the help page.</p>
							<textarea class="form-control" aria-label="Content"></textarea>
						</div>
						
						<button type="button" class="btn bg-cosmic-cobalt text-ghost-white float-right">Submit</button>
			    	</div>
				</div>
			</div>
		</div>
		
		<!-- Feedback Modal -->
		<div id="feedbackModal" class="modal fade" role="dialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<h2 class="modal-title">Submit feedback</h2>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<div class="input-group mb-3">
							<div class="input-group-prepend">
							</div>
							<p>Please provide feedback on how we can improve Teccy Space or if something is not working.</p>
							<textarea class="form-control" aria-label="Content"></textarea>
						</div>
						
						<button type="button" class="btn bg-cosmic-cobalt text-ghost-white float-right">Submit</button>
			    	</div>
				</div>
			</div>
		</div>
		
	</body>
</html>