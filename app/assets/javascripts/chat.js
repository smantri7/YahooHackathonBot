//If user submits the form
console.log("RANNING")
$("#submitmsg").click(function(){	
	var clientmsg = $("#usermsg").val();
	$('<p>' + clientmsg + '</p><br>').appendTo('#chatbox');	
	$("#usermsg").attr("value", "");			
	return false;
});


$(document).ready(function () {
$("#submitmsg").click(function(){	
	var clientmsg = $("#usermsg").val();
	$('<p>' + clientmsg + '</p><br>').appendTo('#chatbox');	
	$("#usermsg").attr("value", "");
	//send a post
	$.ajax({
      type: "POST",
      url: "/chat",
      data: clientmsg
      success:(data) ->
        alert data.id
        return false
      error:(data) ->
        return false
    })			
	return false;
});
});