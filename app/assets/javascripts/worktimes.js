
$(function(){
  $("#year").change(function(){
    let year = document.getElementById("year")[document.getElementById("year").selectedIndex].text;
    let month = document.getElementById("month")[document.getElementById("month").selectedIndex].text;
  
    let dt = new Date(year, month);

    let last_day = new Date(dt.getFullYear(), dt.getMonth(), 0);

    // 日付をリセット
    $("#day option").each( function(){
      $(this).remove();
    });

    // 日付を再作成
    let i = 1;
    while (i <= last_day.getDate()) {
      $("#day").append( function(){
        return $("<option>").val(('0' + i).slice(-2)).text(('0' + i).slice(-2));
      });
      i++;
    }
  });

  $("#month").change(function(){
    let year = document.getElementById("year")[document.getElementById("year").selectedIndex].text;
    let month = document.getElementById("month")[document.getElementById("month").selectedIndex].text;
  
    let dt = new Date(year, month);

    let last_day = new Date(dt.getFullYear(), dt.getMonth(), 0);

    // 日付をリセット
    $("#day option").each( function(){
      $(this).remove();
    });

    // 日付を再作成
    let i = 1;
    while (i <= last_day.getDate()) {
      $("#day").append( function(){
        return $("<option>").val(('0' + i).slice(-2)).text(('0' + i).slice(-2));
      });
      i++;
    }
  });
});
