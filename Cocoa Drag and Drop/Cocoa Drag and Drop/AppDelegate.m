//
//  AppDelegate.m
//  Cocoa Drag and Drop
//
//  Created by Nikola Grujic on 22/01/2020.
//  Copyright © 2020 Mac Developers. All rights reserved.
//

#import "AppDelegate.h"
#import "FootballClub.h"

@implementation AppDelegate

- (id)init
{
    self = [super init];
    
    if (self)
    {
        footballClubs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [self setTableViewDataSource];
    [self setTableViewDelegate];
    [self setColumnsIdentifiers];
    [self setColumnsSortDescriptors];
    [self registerForDragAndDrop];
    
    [self fillTestData];
}

#pragma mark Table view dataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return [footballClubs count];
}

- (id)tableView:(NSTableView *)tableView
objectValueForTableColumn:(NSTableColumn *)tableColumn
                      row:(NSInteger)row
{
    NSString *columnIdentifier = [tableColumn identifier];
    FootballClub *club = [footballClubs objectAtIndex:row];
    
    return [club valueForKey:columnIdentifier];
}

#pragma mark Additional methods

- (void)setTableViewDataSource
{
    [tableView setDataSource: (id)self];
}

- (void)setTableViewDelegate
{
    [tableView setDelegate:self];
}

- (void)setColumnsIdentifiers
{
    NSArray<NSTableColumn*> *columns = [tableView tableColumns];
    int firstColumn = 0;
    int secondColumn = 1;
    
    for (int i = 0; i < [columns count]; i++)
    {
        NSTableColumn *column = [columns objectAtIndex:i];
        
        if (i == firstColumn)
        {
            [column setIdentifier:@"name"];
        }
        else if (i == secondColumn)
        {
            [column setIdentifier:@"foundationYear"];
        }
    }
}

- (void)setColumnsSortDescriptors
{
    NSArray<NSTableColumn*> *columns = [tableView tableColumns];
    
    for (int i = 0; i < [columns count]; i++)
    {
        NSTableColumn *column = [columns objectAtIndex:i];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[column identifier]
                                                                         ascending:YES
                                                                          selector:@selector(caseInsensitiveCompare:)];
        [column setSortDescriptorPrototype:sortDescriptor];
    }
}

- (void)registerForDragAndDrop
{
    [tableView registerForDraggedTypes:[NSArray arrayWithObjects:@"NSMutableArray", nil]];
}

- (void)fillTestData
{
    FootballClub *club1 = [[FootballClub alloc] init];
    [club1 setName:@"Manchester United"];
    [club1 setFoundationYear:@"1878"];
    
    FootballClub *club2 = [[FootballClub alloc] init];
    [club2 setName:@"Liverpool"];
    [club2 setFoundationYear:@"1892"];
    
    FootballClub *club3 = [[FootballClub alloc] init];
    [club3 setName:@"Real Madrid"];
    [club3 setFoundationYear:@"1902"];
    
    FootballClub *club4 = [[FootballClub alloc] init];
    [club4 setName:@"Barcelona"];
    [club4 setFoundationYear:@"1899"];
    
    [footballClubs addObject:club1];
    [footballClubs addObject:club2];
    [footballClubs addObject:club3];
    [footballClubs addObject:club4];
}

#pragma mark Drag and drop methods

// Returns a Boolean value that indicates whether a drag operation is allowed.
- (BOOL)   tableView:(NSTableView *)tableView
writeRowsWithIndexes:(NSIndexSet *)rowIndexes
        toPasteboard:(NSPasteboard *)pboard
{
    // Copy row indexes to pasteboard
    NSError* error;
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes
                                         requiringSecureCoding:YES
                                                         error:&error];
    
    [pboard declareTypes:[NSArray arrayWithObject:@"NSMutableArray"] owner:self];
    [pboard setData:data forType:@"NSMutableArray"];
    
    return YES;
}

// Used by aTableView to determine a valid drop target.
- (NSDragOperation)tableView:(NSTableView *)tableView
                validateDrop:(id<NSDraggingInfo>)info
                 proposedRow:(NSInteger)row
       proposedDropOperation:(NSTableViewDropOperation)dropOperation
{
    if (row > [footballClubs count])
    {
        return NSDragOperationNone;
    }
    
    //Dragged from other operation
    if (nil == [info draggingSource])
    {
        return NSDragOperationNone;
    }
    
    [tableView setDropRow:row dropOperation:NSTableViewDropAbove];
    
    //Dragged from self
    if (self == [info draggingSource])
    {
        return NSDragOperationMove;
    }
    else //Dragged from other document
    {
        return NSDragOperationCopy;
    }
}

// Called by aTableView when the mouse button is released over a table view that previously decided to allow a drop.
- (BOOL)tableView:(NSTableView *)tableView
       acceptDrop:(id<NSDraggingInfo>)info
              row:(NSInteger)row
    dropOperation:(NSTableViewDropOperation)dropOperation
{
    NSPasteboard* pboard = [info draggingPasteboard];
    NSData* rowData = [pboard dataForType:@"NSMutableArray"];
    NSError* error;
    NSIndexSet* rowIndexes = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSIndexSet class]
                                                               fromData:rowData
                                                                  error:&error];
    NSInteger draggedRow = [rowIndexes firstIndex];
    
    [self moveObjectAtIndex:draggedRow toIndex:row array:footballClubs];
    
    return YES;
}

#pragma mark Helper method

- (void)moveObjectAtIndex:(NSUInteger)fromIndex
                  toIndex:(NSUInteger)toIndex
                    array:(NSMutableArray*)array
{
    if (toIndex >= [array count])
    {
        toIndex = [array count] - 1;
    }
    
    id object = [array objectAtIndex:fromIndex];
    [array removeObjectAtIndex:fromIndex];
    [array insertObject:object atIndex:toIndex];
}

@end
