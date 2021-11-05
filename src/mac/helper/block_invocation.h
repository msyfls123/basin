/* Copied from https://gist.github.com/alexdrone/2634534. */
@interface BlockInvocation : NSObject {
    void *block;
}

-(id)initWithBlock:(void *)aBlock;
+(BlockInvocation *)invocationWithBlock:(void *)aBlock;

-(void)perform;
-(void)performWithObject:(id)anObject;
-(void)performWithObject:(id)anObject object:(id)anotherObject;

@end
