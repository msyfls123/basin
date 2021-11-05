/* Copied from https://gist.github.com/alexdrone/2634534. */
@implementation BlockInvocation

-(id)initWithBlock:(void *)aBlock {
    if (self = [self init]) {
        block = (void *)[(void (^)(void))aBlock copy];
    }

    return self;
}

+(BlockInvocation *)invocationWithBlock:(void *)aBlock {
    return [[[self alloc] initWithBlock:aBlock] autorelease];
}

-(void)perform {
    ((void (^)(void))block)();
}

-(void)performWithObject:(id)anObject {
    ((void (^)(id arg1))block)(anObject);
}

-(void)performWithObject:(id)anObject object:(id)anotherObject {
    ((void (^)(id arg1, id arg2))block)(anObject, anotherObject);
}

-(void)dealloc {
    [(void (^)(void))block release];
    [super dealloc];
}

@end
