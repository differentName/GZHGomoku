//
//  GZHGomokuGameEngine.m
//  GZHGomoku
//
//  Created by 高增洪 on 16-4-1.
//  Copyright (c) 2016年 高增洪. All rights reserved.
//

#import "GZHGomokuGameEngine.h"
#import "GZHGomokuChessboard.h"
#import "GZHGomokuActualStack.h"
#import "GZHGomokuEnvisionStack.h"
@interface GZHGomokuGameEngine ()
@property(nonatomic,strong)GZHGomokuActualStack * actualStack;

@property(nonatomic)NSInteger depth;
@end

@implementation GZHGomokuGameEngine

+(instancetype)game
{
    static GZHGomokuGameEngine * game=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        game=[[GZHGomokuGameEngine alloc]init];
    });
    return game;
}

-(instancetype)init
{
    self=[super init];
    if (self) {
        _chessBoard=[[GZHGomokuChessboard alloc]init];
        _actualStack=[[GZHGomokuActualStack alloc]init];
        _envisionStack=[[GZHGomokuEnvisionStack alloc]init];
        _maxDepth=2;
    }
    return self;
}
-(void)setPlayerFirst:(BOOL)playerFirst
{
    _playerFirst=playerFirst;
    _envisionStack.playerFirst=playerFirst;
}

-(void)playerChessDown:(NSInteger)row line:(NSInteger)line
{
    GZHGomokuChessPoint * point=[self.chessBoard pointAtRow:row line:line];
    if (point) {
        if (point.chess) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(game:error:)]) {
                [self.delegate game:self error:GZHGameErrorTypeChessAxist];
            }
        }else if(self.gameStatu==GZHGameStatuComputerChessing){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(game:error:)]) {
                [self.delegate game:self error:GZHGameErrorTypeComputerIsChessing];
            }
        }else if(self.gameStatu==GZHGameStatuPlayChessing){
            BOOL finish=NO;
            if (self.playerFirst) {
                finish=[self chessDown:point chessType:GZHGomokuChessTypeBlack];
            }else{
                finish=[self chessDown:point chessType:GZHGomokuChessTypeWhite];
            }
            if (!finish) {
                [self computerPrepareChess];
            }
        }
    }
}

-(BOOL)chessDown:(GZHGomokuChessPoint*)point chessType:(GZHGomokuChessType)chessType
{
    GZHGomokuChessElement * element=[GZHGomokuChessElement getChess:chessType];
    point.chess=element;
    [_actualStack push:point];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(game:updateSences:)]) {
        [self.delegate game:self updateSences:point];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(game:playSound:)]) {
        [self.delegate game:self playSound:GZHGameSoundTypeStep];
    }
    return [self determine];   //判断胜负
}

-(void)computerPrepareChess
{
    [self.envisionStack reuse];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
        [self.delegate game:self statuChange:GZHGameStatuComputerChessing];
    }
    self.gameStatu=GZHGameStatuComputerChessing;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        GZHGomokuChessPoint*point=[self computerCalculateBestStep];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gameStatu=GZHGameStatuPlayChessing;
            if (self.playerFirst) {
                [self chessDown:point chessType:GZHGomokuChessTypeWhite];
            }else{
                [self chessDown:point chessType:GZHGomokuChessTypeBlack];
            }
            if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
                [self.delegate game:self statuChange:GZHGameStatuPlayChessing];
            }
        });
    });
}
-(GZHGomokuChessPoint*)computerCalculateBestStep
{
    if ([self.actualStack depth]==1) {      //开局  电脑为白子（后手）
        return [self opening_depth_1];
    }else if([self.actualStack depth]==2){
        GZHGomokuChessPoint * point=[self opening_depth_2];
        if (point==nil) {
            return [self computerCalculateBestStepAuto];
        }else{
            return point;
        }
    }else{
        return [self computerCalculateBestStepAuto];
    }
}


-(GZHGomokuChessPoint*)opening_depth_1
{
    GZHGomokuChessPoint * point=[self.actualStack getTopElement];
    int x = arc4random() % 2;
    NSInteger row,line;
    if (x==0) {
        if (point.row>=5&&point.row<=11&&point.line>=5&&point.line<=11) {
            int y = arc4random() % 4;
            if (y==0) {
                row=point.row-1;
                line=point.line;
            }else if(y==1){
                row=point.row;
                line=point.line-1;
            }else if(y==2){
                row=point.row+1;
                line=point.line;
            }else{
                row=point.row;
                line=point.line+1;
            }
        }
        else if(point.row<5){
            if (point.line<5) {
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }else if(point.line>11){
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }else{
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }
        }
        else if(point.row>11){
            if (point.line<5) {
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row-1;
                    line=point.line;
                }
            }else if(point.line>11){
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else{
                    row=point.row-1;
                    line=point.line;
                }
                
            }else{
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row-1;
                    line=point.line;
                }
            }
        }
        else{
            if (point.line<5) {
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row-1;
                    line=point.line;
                }else if(y==1){
                    row=point.row;
                    line=point.line+1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }else{
                int y = arc4random() % 3;
                if (y==0) {
                    row=point.row-1;
                    line=point.line;
                }else if(y==1){
                    row=point.row;
                    line=point.line-1;
                }else{
                    row=point.row+1;
                    line=point.line;
                }
            }
        }
    }else{
        if (point.row>=5&&point.row<=11&&point.line>=5&&point.line<=11) {
            int y = arc4random() % 4;
            if (y==0) {
                row=point.row-1;
                line=point.line-1;
            }else if(y==1){
                row=point.row+1;
                line=point.line-1;
            }else if(y==2){
                row=point.row-1;
                line=point.line+1;
            }else{
                row=point.row+1;
                line=point.line+1;
            }
        }
        else if(point.row<5){
            if (point.line<5) {
                row=point.row+1;
                line=point.line+1;
            }else if(point.line>11){
                row=point.row+1;
                line=point.line-1;
            }else{
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row+1;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row+1;
                    line=point.line+1;
                }
            }
        }
        else if(point.row>11){
            if (point.line<5) {
                row=point.row-1;
                line=point.line+1;
            }else if(point.line>11){
                row=point.row-1;
                line=point.line-1;
            }else{
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row-1;
                    line=point.line+1;
                }else if(y==1){
                    row=point.row-1;
                    line=point.line-1;
                }
            }
        }
        else{
            if (point.line<5) {
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row-1;
                    line=point.line+1;
                }else if(y==1){
                    row=point.row+1;
                    line=point.line+1;
                }
            }else{
                int y = arc4random() % 2;
                if (y==0) {
                    row=point.row-1;
                    line=point.line-1;
                }else if(y==1){
                    row=point.row+1;
                    line=point.line-1;
                }
            }
        }
    }
    return[self.chessBoard pointAtRow:row line:line];
}

-(GZHGomokuChessPoint*)opening_depth_2
{
    return nil;
}

-(GZHGomokuChessPoint*)computerCalculateBestStepAuto
{
    if (_maxDepth==1) {
        [self calculateDepth1];
    }else if(_maxDepth==2){
        [self calculateDepth2];
    }else{
        [self calculateDepth3];
    }
    return self.envisionStack.maxPoint;
}


-(BOOL)determine
{
    NSInteger value=[self.chessBoard determine];
    if (value==1) { //黑棋胜利
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:finish:)]) {
            [self.delegate game:self finish:self.playerFirst];
        }
        self.gameStatu=GZHGameStatuFinished;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:self.gameStatu];
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:playSound:)]) {
            if (self.playerFirst) {
                [self.delegate game:self playSound:GZHGameSoundTypeVictory];
            }else{
                [self.delegate game:self  playSound:GZHGameSoundTypeFailed];
            }
        }
        return YES;
    }else if(value==2){ //白棋胜利
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:finish:)]) {
            [self.delegate game:self finish:!self.playerFirst];
        }
        self.gameStatu=GZHGameStatuFinished;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:self.gameStatu];
        }
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:playSound:)]) {
            if (!self.playerFirst) {
                [self.delegate game:self playSound:GZHGameSoundTypeVictory];
            }else{
                [self.delegate game:self  playSound:GZHGameSoundTypeFailed];
            }
        }
        return YES;
    }
    return NO;
}

-(void)begin
{
    if (self.playerFirst) {
        self.gameStatu=GZHGameStatuPlayChessing;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:GZHGameStatuPlayChessing];
        }
    }else{
        self.gameStatu=GZHGameStatuComputerChessing;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:GZHGameStatuComputerChessing];
        }
        GZHGomokuChessPoint* point=[self.chessBoard pointAtRow:CenterRow line:CenterRow];
        [self chessDown:point chessType:GZHGomokuChessTypeBlack];
        self.gameStatu=GZHGameStatuPlayChessing;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:statuChange:)]) {
            [self.delegate game:self statuChange:GZHGameStatuPlayChessing];
        }
    }
}

-(void)reStart
{
    if (self.gameStatu!=GZHGameStatuComputerChessing) {
        _chessBoard=[[GZHGomokuChessboard alloc]init];
        _actualStack=[[GZHGomokuActualStack alloc]init];
        _envisionStack=[[GZHGomokuEnvisionStack alloc]init];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(gameRestart:)]) {
            [self.delegate gameRestart:self];
        }
        [self begin];
    }
}

-(BOOL)undo
{
    if (self.gameStatu!=GZHGameStatuFinished&&self.gameStatu!=GZHGameStatuComputerChessing) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(game:undo:)]) {
            GZHGomokuChessPoint*point=[self.actualStack pop];
            [self.delegate game:self undo:point];
            
            point=[self.actualStack pop];
            [self.delegate game:self undo:point];
            return YES;
        }
    }
    return NO;
}

-(BOOL)calculateDepth1
{
    __block BOOL pruning=NO;
    [self.chessBoard enumerateFrom:[self getLastChessPoint] callback:^(GZHGomokuChessPoint *point) {
        if ([self.chessBoard couldChessDowm:point]){
            NSInteger depth=[self.envisionStack depth];
            if (depth%2==0) {
                if (self.playerFirst) {
                    [self.envisionStack push:point type:GZHGomokuChessTypeWhite];
                }else{
                    [self.envisionStack push:point type:GZHGomokuChessTypeBlack];
                }
            }else{
                if (self.playerFirst) {
                    [self.envisionStack push:point type:GZHGomokuChessTypeBlack];
                }else{
                    [self.envisionStack push:point type:GZHGomokuChessTypeWhite];
                }
            }
            NSInteger score=[self.chessBoard calculate];
            [self.envisionStack pushLeafValue:score];
            [self.envisionStack pop];
            if ([self.envisionStack pruning]) {
                pruning=YES;
                return YES;
            }
        }
        return  NO; 
    }];
    return pruning;
}

-(BOOL)calculateDepth2
{
    __block BOOL pruning=NO;
    [self.chessBoard enumerateFrom:[self getLastChessPoint] callback:^(GZHGomokuChessPoint *point) {
        if ([self.chessBoard couldChessDowm:point]){
            NSInteger depth=[self.envisionStack depth];
            if (depth%2==0) {
                if (self.playerFirst) {
                    [self.envisionStack push:point type:GZHGomokuChessTypeWhite];
                }else{
                    [self.envisionStack push:point type:GZHGomokuChessTypeBlack];
                }
            }else{
                if (self.playerFirst) {
                    [self.envisionStack push:point type:GZHGomokuChessTypeBlack];
                }else{
                    [self.envisionStack push:point type:GZHGomokuChessTypeWhite];
                }
            }
         //   NSLog(@"\n\n\n\n");
         //   NSLog(@"Row_1 :%d  Line_1:%d",point.row,point.line);
            if ([self calculateDepth1]) {
                [self.envisionStack onlyPop];
            }else{
                [self.envisionStack pop];
            }
            if ([self.envisionStack pruning]) {
                pruning=YES;
                return YES;
            }
        }
        return NO;
    }];
    return pruning;
}

-(void)calculateDepth3
{
    [self.chessBoard enumerateFrom:[self getLastChessPoint] callback:^(GZHGomokuChessPoint *point) {
        if ([self.chessBoard couldChessDowm:point]){
            NSInteger depth=[self.envisionStack depth];
            if (depth%2==0) {
                if (self.playerFirst) {
                    [self.envisionStack push:point type:GZHGomokuChessTypeWhite];
                }else{
                    [self.envisionStack push:point type:GZHGomokuChessTypeBlack];
                }
            }else{
                if (self.playerFirst) {
                    [self.envisionStack push:point type:GZHGomokuChessTypeBlack];
                }else{
                    [self.envisionStack push:point type:GZHGomokuChessTypeWhite];
                }
            }
            if ([self calculateDepth2]) {
                [self.envisionStack onlyPop];
            }else{
                [self.envisionStack pop];
            }
            if ([self.envisionStack pruning]) {
                return YES;
            }
        }
        return NO;
    }];
}

-(GZHGomokuChessPoint*)getLastChessPoint
{
    GZHGomokuChessPoint * point=[self.envisionStack getTopElement];
    if (point==nil) {
        point=[self.actualStack getTopElement];
    }
    return point;
}




@end
