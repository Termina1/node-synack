pathto = __dirname + '/synack/bin/synack';
exec = require('child_process').exec;

tellError = function(error) {
  if(error) console.log(error);
}

module.exports = {
  init: function() {
    exec(pathto + ' -s', {}, tellError);
  },

  say: function(msg) {
    exec(pathto + ' ' + msg, {}, tellError);
  }
}