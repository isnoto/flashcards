function init() {
  function changeClassCurrentDeck() {
    var decksWrap = document.querySelector('.decks');
    if (!decksWrap) {
      return;
    }

    var decks = decksWrap.querySelectorAll('.decks__item');

    for(var i = 0; i < decks.length; i++) {
      var deck = decks[i];
      var currentDeck = deck.querySelector('.decks__current');

      if (currentDeck) {
        deck.classList.remove('bs-callout-default');
        deck.classList.add('bs-callout-success');
      }
    }
  }

  function insertCurrentDeckAtTheTop() {
    var decksWrap = document.querySelector('.decks');
    if (!decksWrap) {
      return;
    }

    var decks = decksWrap.querySelectorAll('.decks__item');

    for(var i = 0; i < decks.length; i++) {
      var deck = decks[i];
      var currentDeck = deck.querySelector('.decks__current');

      if (currentDeck) {
        var tmp = deck.cloneNode(true);
        decksWrap.removeChild(deck);
        decksWrap.insertBefore(tmp, decksWrap.firstElementChild);
      }
    }
  }

  changeClassCurrentDeck();
  insertCurrentDeckAtTheTop();
}

window.addEventListener('load', init);