function Review(opts) {
  this.form = document.getElementById(opts.form);
  this.formId = opts.form;
  this.cardIdInput = this.form.querySelector('#card_id');
  this.translateField = this.form.querySelector('.card__translate');
  this.timeInput = this.form.querySelector('#' + opts.timeInput);
  this.submitButton = this.form.querySelector( opts.submitButton);
  this.imageContainer = this.form.querySelector('.card__image');
  this.timer = new Timer();
  this.timeout = null; // timeout for removeFlash

  this.init();
}

Review.prototype.init = function() {
  this.timer.start();
  this.submitButton.addEventListener('click', this.checkAnswer.bind(this));
};

Review.prototype.checkAnswer = function(e) {
  var self = this;

  e.preventDefault();
  self.timer.stop();
  self.timeInput.value = self.timer.getTime();

  $.post('/dashboard/reviews', $('#' + this.formId ).serialize(), function( data ) {
    var flashType = Object.keys(data.message)[0];
    var flashMessage = data.message[flashType];

    self.appendFlash(flashType, flashMessage);
    self.getCard();
  }, 'json');
};

Review.prototype.getCard = function() {
  var self = this;

  $.getJSON('/dashboard/reviews', function(card) {
    if (card.id) {
      var imageSrc = card.image.normal.url;

      if (imageSrc) {
        self.appendImage(imageSrc);
      } else {
        self.removeImage();
      }

      self.cardIdInput.value = card.id;
      self.translateField.innerHTML = card.translated_text;
      self.timer.start();
    } else {
      var div = document.createElement('div');
      var contentBlock = self.form.parentNode;

      div.innerHTML = card.review_done;
      contentBlock.removeChild(self.form);
      contentBlock.appendChild(div);
    }
  });
};

Review.prototype.appendImage = function(src) {
  if (this.getExistenceImage()) {
    var currentImage = this.imageContainer.querySelector('img');
    currentImage.setAttribute('src', src); // update image src if image exist
  } else {
    var img = document.createElement('img');
    img.setAttribute('src', src);
    this.imageContainer.appendChild(img);
  }
};

Review.prototype.removeImage = function() {
  var img = this.getExistenceImage();

  if (img) {
    this.imageContainer.removeChild(img);
  }
};

Review.prototype.getExistenceImage = function() {
  return this.imageContainer.firstElementChild;
};

Review.prototype.appendFlash = function(type, message) {
  var flash = $('.flash');

  if (flash) {
    flash.remove();
    clearTimeout(this.timeout); // reset "removeFlash" timeout if exist
  }

  $('<div>', {
    class: 'flash flash--' + type,
    text: message
  }).appendTo('.flash-container');

  this.removeFlash(3000);
};

Review.prototype.removeFlash = function(timeout) {
  this.timeout = setTimeout(function(){
    $('.flash').fadeOut(300, function(){ $(this).remove();});
  }, timeout);
};