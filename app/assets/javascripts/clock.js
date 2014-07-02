/*
  * Часы
*/
function setDateTime(forTime, interval){
  function runClock(){
    var date = new Date();
    var hours = ('0' + date.getHours()).slice(-2)
    var minutes = ('0' + date.getMinutes()).slice(-2)
    var seconds = ('0' + date.getSeconds()).slice(-2)
    var time = hours + ':' + minutes + ':' + seconds;
    $(forTime).html(time);
  }

  setInterval(runClock,interval);
}