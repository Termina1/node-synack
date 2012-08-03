pathto = './synack/bin/synack';

module.exports = {
  init: function() {
    exec(pathto + ' -s');
  },

  send: function(msg) {
    exec(pathto + ' ' + msg);
  }
}