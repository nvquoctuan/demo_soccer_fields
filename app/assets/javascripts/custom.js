function dropdown() {
  $('.dropdown-menu-right').slideToggle();
}

function chose_star(clicked_id){
  star = document.getElementById(clicked_id);
  rating_star = document.getElementById("rating_star");
  if(typeof star == "undefined" || typeof rating_star == "undefined"){return;}
  num_star = clicked_id.substr(clicked_id.length - 1);
  parent = star.parentElement;
  status = star.value;
  if(status == 0){
    for(i = num_star; i >= 1; i--){
      button = create_button_star_chosed(i);
      document.getElementById("star_"+ i).remove();
      parent.prepend(button);
    }

  }
  else if(status == 1){
    n = parseInt(num_star) + 1;
    for(i = 5; i > num_star; i--){
      console.log(n);
      button = create_button_star_chose(n);
      console.log(button);
      document.getElementById("star_" + n).remove();
      parent.append(button);
      n++;
    }
  }
  rating_star.setAttribute("value", num_star);
}
function create_button_star_chosed(n){
  var button = document.createElement("button");
  button.className += "btn btn-warning btn-sm"
  button.innerHTML = '<span class="glyphicon glyphicon-star" aria-hidden="true"></span>';
  button.setAttribute("value", 1);
  button.onclick = function(){
    chose_star("star_" + n);
  }
  button.setAttribute("id", "star_" + n);
  button.setAttribute("style", "margin-right: 5px;");
  button.setAttribute("type", "button");
  button.setAttribute("aria-label", "Left Align");

  return button;
}

function create_button_star_chose(n){
  var button = document.createElement("button");
  button.className += "btn btn-default btn-grey btn-sm"
  button.innerHTML = '<span class="glyphicon glyphicon-star" aria-hidden="true"></span>';
  button.onclick = function(){
    chose_star("star_" + n);
  }
  button.setAttribute("value", 0);
  button.setAttribute("id", "star_" + n);
  button.setAttribute("style", "margin-right: 5px;");
  button.setAttribute("type", "button");
  button.setAttribute("aria-label", "Left Align");

  return button;
}
$(document).ready(function() {
  $("body").on("click", ".like_subpitch", function(e){
    e.preventDefault();
  });
});


$(document).ready(function(){
  $('#paginate_home a').attr('data-remote','true');
});
