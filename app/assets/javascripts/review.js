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
  var ctx = this;

  e.preventDefault();
  ctx.timer.stop();
  ctx.timeInput.value = ctx.timer.getTime();

  $.post('/reviews', $('#' + this.formId ).serialize(), function( data ) {
    var flashType = Object.keys(data.message)[0];
    var flashMessage = data.message[flashType];

    ctx.appendFlash(flashType, flashMessage);
    ctx.getCard();
  }, 'json')
};

Review.prototype.getCard = function() {
  var ctx = this;

  $.getJSON('/reviews', function(card) {
    if (card.id) {
      var imageSrc = card.image.normal.url;

      if (imageSrc) {
        ctx.appendImage(imageSrc);
      } else {
        ctx.removeImage();
      }

      ctx.cardIdInput.value = card.id;
      ctx.translateField.innerHTML = card.translated_text;
      ctx.timer.start();
    } else {
      var div = document.createElement('div');
      var contentBlock = ctx.form.parentNode;

      div.innerHTML = card.review_done;
      contentBlock.removeChild(ctx.form);
      contentBlock.appendChild(div);
    }
  })
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
  }, timeout)
};