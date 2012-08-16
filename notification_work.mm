// % CXX=clang++ node-waf configure 
// % node-waf build
// % node
// var nc=require('./build/Release/notification_center.node').NotificationCenter; var n = new nc(); n.hello();
// => >_<
//
// notification code is derived from https://github.com/alloy/terminal-notifier
//
#include <v8.h>
#include <node.h>
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

using namespace node;
using namespace v8;

@interface MTNodeNotifier : NSObject
@property (assign) NSString *message;

- (id) initWithString:(NSString *)message;
- (void) post;

@end

@implementation MTNodeNotifier
@synthesize message;

- (id) initWithString:(NSString *)msg
{
    self = [super init];
    if (self) {
        self.message = message;
    }

    return self;
}

- (void) post
{
  NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
  NSUserNotification *userNotification = nil;
    
  // Now create and deliver the new notification
  userNotification = [NSUserNotification new];
  //userNotification.title = title;
  //userNotification.informativeText = message;
  //userNotification.userInfo = options;
  userNotification.title = @"Message !";
  userNotification.informativeText = @"hoge";

  //center.delegate = self;
  [center scheduleNotification:userNotification];
}

@end

// Original: https://github.com/pquerna/node-extension-examples
class NotificationCenter: ObjectWrap
{
public:

  static Persistent<FunctionTemplate> s_ct;
  static void Init(Handle<Object> target)
  {
    HandleScope scope;

    Local<FunctionTemplate> t = FunctionTemplate::New(New);

    s_ct = Persistent<FunctionTemplate>::New(t);
    s_ct->InstanceTemplate()->SetInternalFieldCount(1);
    s_ct->SetClassName(String::NewSymbol("NotificationCenter"));

    NODE_SET_PROTOTYPE_METHOD(s_ct, "hello", Hello);

    target->Set(String::NewSymbol("NotificationCenter"),
                s_ct->GetFunction());
  }

  NotificationCenter() : { }
  ~NotificationCenter() { }

  static Handle<Value> New(const Arguments& args)
  {
    HandleScope scope;
    NotificationCenter* hw = new NotificationCenter();
    hw->Wrap(args.This());
    return args.This();
  }

  static Handle<Value> Hello(const Arguments& args)
  {
    HandleScope scope;
    NotificationCenter* hw = ObjectWrap::Unwrap<NotificationCenter>(args.This());
    hw->m_count++;

    MTNodeNotifier *notifier = [[MTNodeNotifier alloc] init];
    NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
    NSUserNotificationCenter *aCenter = [[NSUserNotificationCenter alloc] init]; // SEGV here
    NSString *msg = [NSString stringWithFormat:@"aaaaaa: %p, %p, %p", notifier, center, aCenter];

    //Local<String> result = String::New("Hello World");
    Local<String> result = String::New([msg UTF8String]);
    return scope.Close(result);
  }

};

Persistent<FunctionTemplate> NotificationCenter::s_ct;

extern "C" {
  static void init (Handle<Object> target)
  {
    NotificationCenter::Init(target);
  }

  NODE_MODULE(notification_center, init);
}

// vim set:ft=objcpp: