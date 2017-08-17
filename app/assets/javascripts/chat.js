$(document).ready(function () {

$("#submitmsg").click(function(){	

	var clientmsg = $("#usermsg").val();
	$('<p>' + gon.username + ":  " + clientmsg + '</p><br>').appendTo('#chatbox');	
	$("#usermsg").attr("value", "");
	$.ajax({
  		url: "/main_page/create", // a route in routes.rb for your controller
  		type: "POST",
  		data: {comment: clientmsg, username: gon.username}, // place to send data to your controller
  		dataType: "json",
  		success: function(data){
     	// data will be the response object(json)
     		$('<p>' + "ボット:  " + data['resp'] + '</p><br>').appendTo('#chatbox');
     		//$('<p>' + "ボット:  " + data + '</p><br>').appendTo('#chatbox');
     	// use data to create new chat object using a template of some sort
     		return true
  		}
	});
  });
})