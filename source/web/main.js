
function loadPage()
{
	$.ajax({url: "api/user", success: (result) => $("#username").html(JSON.parse(result).response)});

	fetchMessages();
}

function postMessage()
{
	let msgText = $("input[name='message']")[0].value

	if (msgText==null || msgText=="")
		return;

	$.ajax("api/message", {
		data: JSON.stringify({"Text": msgText}),
		contentType: "application/json",
		type: "POST"
	});

	fetchMessages(); 

	return false; // don't POST request anywhere
}

function fetchMessages()
{
	$.ajax({url: "api/messages/100", success: (result) => {
   	let messages = JSON.parse(result);

   	$("#messages").html("");
   	messages.forEach((msg) => 
   		$("#messages").append("<div class='message'><span class='user'>"+msg.name+"</span><span class='time'>"+formatTime(msg.time)+"</span><span class='text'>"+msg.text+"</span></div>")
   	);
  }});
}

function formatTime(time)
{
	return time.split(' ')[1];
}
