$(document).ready(function()
{
	$('.card').click(function(e){
		$this = $(e.target);
		alert($this.text()+"-"+$(this).attr('class'));
	});
});
