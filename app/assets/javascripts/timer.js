function Timer() {
  var startTime;
  var endTime;

  this.start = function() {
    startTime = Date.now();
  };

  this.stop = function() {
    endTime = Date.now();
  };

  this.getTime = function() {
    return endTime - startTime;
  };
}