//
//  AppDelegate.h
//  Cocoa Drag and Drop
//
//  Created by Nikola Grujic on 22/01/2020.
//  Copyright © 2020 Mac Developers. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDelegate>
{
    NSMutableArray *footballClubs;
    IBOutlet NSTableView *tableView;
}

@property (weak) IBOutlet NSWindow *window;

- (void)setTableViewDataSource;
- (void)setTableViewDelegate;
- (void)setColumnsIdentifiers;
- (void)setColumnsSortDescriptors;
- (void)registerForDragAndDrop;

- (void)fillTestData;

- (void)moveObjectAtIndex:(NSUInteger)fromIndex
                  toIndex:(NSUInteger)toIndex
                    array:(NSMutableArray*)array;

@end

