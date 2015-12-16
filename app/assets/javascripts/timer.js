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

function initReviewTimer() {
  var form = document.getElementById('review-form');
  var timeInput = form.querySelector('#review-time');
  var submitButton = form.querySelector('input[type="submit"]');
  var timer = new Timer();

  timer.start();

  submitButton.addEventListener('click', function() {
    timer.stop();
    timeInput.value = timer.getTime();
  });
}

window.onload = function() {
  if (document.getElementById('review-form')) {
    initReviewTimer();
  }
};
