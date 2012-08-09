//
//  ParsingViewController.m
//  Performance
//
//  Created by Steve Madsen on 8/4/12.
//  Copyright (c) 2012 Steven Madsen. All rights reserved.
//

#import "ParsingViewController.h"
#import "Benchmark.h"

@implementation ParsingViewController
{
    NSMutableArray *objects;
    NSMutableDictionary *oneObject;
    NSMutableString *characters;
}

- (void) viewDidLoad
{
    [super viewDidLoad];

    self.xmlTimeLabel.text = @"";
    self.jsonTimeLabel.text = @"";
    self.plistTimeLabel.text = @"";

    [self parseXML];
    [self parseJSON];
    [self parsePlist];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) parseXML
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"batch" ofType:@"xml"];
    NSData *xml = [NSData dataWithContentsOfFile:path];
    double elapsed = [Benchmark block:^{
        NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xml];
        parser.delegate = self;
        [parser parse];
    }];

    self.xmlTimeLabel.text = [NSString stringWithFormat:@"%.3fms", elapsed * 1000];
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"objects"])
    {
        objects = [NSMutableArray array];
    }
    else if ([elementName isEqualToString:@"object"])
    {
        oneObject = [NSMutableDictionary dictionary];
    }
    else if ([elementName isEqualToString:@"string1"] ||
             [elementName isEqualToString:@"string2"] ||
             [elementName isEqualToString:@"number"])
    {
        characters = [NSMutableString string];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [characters appendString:string];
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"object"])
    {
        [objects addObject:oneObject];
        oneObject = nil;
    }
    else if ([elementName isEqualToString:@"string1"] ||
             [elementName isEqualToString:@"string2"])
    {
        [oneObject setValue:characters forKey:elementName];
        characters = nil;
    }
    else if ([elementName isEqualToString:@"number"])
    {
        [oneObject setValue:@([characters integerValue]) forKey:elementName];
        characters = nil;
    }
}

- (void) parseJSON
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"batch" ofType:@"json"];
    NSData *json = [NSData dataWithContentsOfFile:path];
    double elapsed = [Benchmark block:^{
        NSError *error;
        NSArray *object = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];

        NSArray *dirs = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                               inDomains:NSUserDomainMask];
        NSString *p = [[[dirs objectAtIndex:0] path] stringByAppendingPathComponent:@"batch.plist"];
        [object writeToFile:p atomically:NO];
    }];

    self.jsonTimeLabel.text = [NSString stringWithFormat:@"%.3fms", elapsed * 1000];
}

- (void) parsePlist
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"batch" ofType:@"plist"];
    NSData *plist = [NSData dataWithContentsOfFile:path];
    double elapsed = [Benchmark block:^{
        NSError *error;
        [NSPropertyListSerialization propertyListWithData:plist options:0 format:NULL error:&error];
    }];

    self.plistTimeLabel.text = [NSString stringWithFormat:@"%.3fms", elapsed * 1000];
}

@end
