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
      tmp.classList.remove('bs-callout-default');
      tmp.classList.add('bs-callout-success');
      decksWrap.removeChild(deck);
      decksWrap.insertBefore(tmp, decksWrap.firstElementChild);
    }
  }
}
