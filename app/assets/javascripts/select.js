function select2() {
  $("#card_deck_name").select2({
    theme: "bootstrap",
    width: '100%',
    tags: true,
    allowClear: true,
    createTag: function (params) {
      return {
        id: params.term,
        text: params.term,
        newOption: true
      }
    }
  });
};
