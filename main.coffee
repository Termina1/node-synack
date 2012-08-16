$ = require('NodObjC')

$.framework('Foundation')
pool = $.NSAutoreleasePool('alloc')('init')
center = $.NSUserNotificationCenter 'defaultUserNotificationCenter'
note = $.NSUserNotification 'new'
note.title = 'test this'
note.informativeText = 'ths text'
console.log center