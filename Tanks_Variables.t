% PROJECT NAME: Tanks
% WRITTEN BY: Isaac Giles
% DATE: 20/02/2019
% FILE NAME: Tanks_Variables
% TEACHER: Mr. Bonisteel
% DESCRIPTION: This holds all of the main variables for the game.


%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%

% GENERAL GAME VARIABLES
var TimeRunning : int := Time.Elapsed
var CharSpawned : boolean := false % SET BACK TO FALSE WHEN UI IS ADDED!!!
var GridX : int := 3000
var GridY : int := 3000
var GridGap : int := 50
var GridDisplacementX, GridDisplacementY : int := 0
var MouseX, MouseY, MouseButton : int

% Scoring
var GameScore : int := 0
var BestScores : array 1 .. 5 of int := init (0, 0, 0, 0, 0)


% START MENU VARIABLES
var GameLogo : int  := Pic.FileNew("images/GameLogo.bmp")
var BeginButton : int  := Pic.FileNew("images/Begin.bmp")
var CreditsButton : int  := Pic.FileNew("images/Credits.bmp")


% GENERAL CHARACTER/ENEMY VARIABLES
var SpriteLevels : array 1 .. 2 of int := init (
    1, % LEVEL REQUIREMENT FOR TIER 1 SPRITE
    3 % LEVEL REQUIREMENT FOR TIER 2 SPRITE
    )
var DmgAmounts : array 1 .. 2 of int := init (
    1, % LEVEL 1 DAMAGE
    3 % LEVEL 2 DAMAGE
    )
var MaxHealths : array 1 .. 2 of int := init (
    10, % LEVEL 1 HEALTH
    13 % LEVEL 2 HEALTH
    )
var SpeedValues : array 1 .. 2 of int := init (
    20, % LEVEL 1 SPEED
    22 % LEVEL 2 SPEED
    )

% CHARACTER VARIABLES
var CharCreated : boolean := false
var SelectedSprite : int := 1
var CharRadius : int := 50
var CharSprites : flexible array 1 .. 1 of int
CharSprites (1) := Pic.FileNew ("images/Level1Tank.bmp")       % level 1 sprite

var CharExpRequirements : array 0 .. 3 of int := init (
    0, % LEVEL 1 EXPERIENCE REQUIRED
    25, % LEVEL 2 EXPERIENCE REQUIRED
    50, % LEVEL 3 EXPERIENCE REQUIRED
    100 % LEVEL 4 EXPERIENCE REQUIRED
    )

var CharPosX : int := 0
var CharPosY : int := 0
var CharRotation : int := 0
var CharLvl : int := 1
var LvlCap : int := 2
var CharHealth : int := MaxHealths (CharLvl)
var CharExp : int := 0


% ENEMY VARIABLES
var EnemiesCreated : boolean := false
var EnemyCount : int := 7
var EnemyRadius : int := 50
var EnemyBaseValue : int := 10
var EnemySprites : flexible array 1 .. 1 of int
EnemySprites (1) := Pic.FileNew ("images/Enemy1Tank.bmp")       % level 1 enemy sprite
var EnemyDisplacementX : int := 0
var EnemyDisplacementY : int := 0


% BULLET VARIABLES
var CharProjectileImg : int := Pic.FileNew ("images/BulletBlue.bmp")
var EnemyProjectileImg : int := Pic.FileNew ("images/BulletRed.bmp")
var ProjectileRadius : int := 20
var SplitBulletSpeed : int := 1
var GlobalBulletDisplacementX : string := "none"
var GlobalBulletDisplacementY : string := "none"
var BulletSpeed : int := 35
var BulletRange : int := 500
var ReloadTime : int := 600


% FOOD VARIABLES
var FoodSpawned : boolean := false
var FoodSprites : flexible array 1 .. 1 of int
FoodSprites (1) := Pic.FileNew ("images/Food1.bmp")       % level 1 food

var FoodValues : flexible array 1 .. 2 of int
FoodValues (1) := 10     % experience awarded for destroying level 1 food
FoodValues (2) := 15     % experience awarded for destroying level 2 food

var FoodCount : int := 60
var FoodRadius : int := 25
var BaseFoodHealth : int := 5
var FoodHealth : array 1 .. FoodCount of int
var FoodLevels : array 1 .. FoodCount of int
var FoodPositionsX : array 1 .. FoodCount of int
var FoodPositionsY : array 1 .. FoodCount of int
var FoodDisplacementX, FoodDisplacementY : int := 0

%%%%%%%%%%%%% VARIABLES %%%%%%%%%%%%%
