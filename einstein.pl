:- use_module(library(lists)).  %% to load permutation/2

/*
Clues:
=======
1. the Brit lives in the red house
2. the Swede keeps dogs as pets
3. the Dane drinks tea
4. the green house is on the left of the white house
5. the green house’s owner drinks coffee
6. the house who smokes Pall Mall rears birds
7. the owner of the yellow house smokes Dunhill
8. the man living in the center house drinks milk
9. the Norwegian lives in the first house
10. the man who smokes blends lives next to the one who keeps cats .
11. the man who keeps horses lives next to the man who smokes Dunhill
12. the owner who smokes BlueMaster drinks beer
13. the German smokes Prince
14. the Norwegian lives next to the blue house .
15. the man who smokes blend has a neighbor who drinks water .
*/

/* layout of house data item */
house(house(House, Owner, Drink, Cigar, Pet, Location),
	House, Owner, Drink, Cigar, Pet, Location).
/* 
   field accessors/setters for house data item
   general form: house_<field name>(<house data item>, <field value>)
   these predicates can be used both for accessing and for setting the field values
 */
house_House(house(House, _Owner, _Drink, _Cigar, _Pet, _Location), House).
house_Owner(house(_House, Owner, _Drink, _Cigar, _Pet, _Location), Owner).
house_Drink(house(_House, _Owner, Drink, _Cigar, _Pet, _Location), Drink).
house_Cigar(house(_House, _Owner, _Drink, Cigar, _Pet, _Location), Cigar).
house_Pet(house(_House, _Owner, _Drink, _Cigar, Pet, _Location), Pet).
house_Location(house(_House, _Owner, _Drink, _Cigar, _Pet, Location), Location).
/*
    these are the domains (possible values) for the different fields, they were manually
    extracted from the puzzle descriptions
*/
%facts
houses([red, green, blue, white, yellow]).
owners([brit, swede, dane, norwegian, german]).
drinks([tea, coffee, milk, beer, water]).
cigars([pallMall, blends, blueMaster, dunhill, prince]).
pets([dogs, cats, horses, birds, fish]).
locations([1,2,3,4,5]).

/* location predicates */

nextTo(A,B):-
	left(A,B).
nextTo(A,B):-
	right(A,B).
left(A,B):-
	A is B-1.
right(A,B):- 
	A is B+1.


/*
	This is the actual encoding of the clues 
*/
solve(Solution) :-
    /*
      Solution is the variable containing the house data items for
      each house in the puzzle
      */
    Solution = [Red, Green, Blue, White, Yellow],

    /*
      setting up the values that we already know
    */
    house(Red, red,
	    RedOwner, RedDrink, RedCigar, RedPet, RedLocation),
    house(Green, green, GreenOwner, GreenDrink, GreenCigar,
	    GreenPet, GreenLocation), 
    house(Blue, blue, BlueOwner, BlueDrink, BlueCigar,
	    BluePet, BlueLocation), 
    house(White, white, WhiteOwner, WhiteDrink,
	    WhiteCigar, WhitePet, WhiteLocation),  
    house(Yellow, yellow, YellowOwner, YellowDrink,
	    YellowCigar, YellowPet, YellowLocation), 
    
	owners(Owners),
    drinks(Drinks),
    cigars(Cigars),
    pets(Pets),
	locations(Locations),
	
    %% POSITIVE CLUES
	%% clue 1 the Brit lives in the red house.
	house_Owner(Owners1, brit),
    member(Owners1, Solution),
    house_House(Owners1, red),
	%% clue	2 the Swede keeps dogs as pets
	house_Owner(Owners2, swede),
    member(Owners2, Solution),
    house_Pet(Owners2, dogs),
	%% clue 3 the Dane drinks tea
	house_Owner(Owners3, dane),
    member(Owners3, Solution),
    house_Drink(Owners3, tea),
	%% clue 4 the green house is on the left of the white house
	house_House(Green, green),
	member(Green, Solution),
	house_Location(Green, GreenLocation),
	member(WhiteLocation, Locations),
	left(GreenLocation, WhiteLocation),
    member(GreenLocation, Locations),
	
	%% clue 5 the green house’s owner drinks coffee
    house_Drink(Drinks1, coffee),
	member(Drinks1, Solution),
	house_House(Drinks1, green),
	%% clue 6 the house who smokes Pall Mall rears birds
	house_Cigar(Cigars1, pallMall),
	member(Cigars1, Solution),
	house_Pet(Cigars1, birds),
	%% clue 7 the owner of the yellow house smokes Dunhill
	house_Cigar(Cigars2, dunhill),
	member(Cigars2, Solution),
	house_House(Cigars2, yellow),
	%% clue 8 the man living in the center house drinks milk
	house_Drink(Drinks2, milk),
	member(Drinks2, Solution),
	house_Location(Drinks2, 3),
	%% clue 9 the Norwegian lives in the first house
	house_Owner(Owners4, norwegian),
	member(Owners4, Solution),
	house_Location(Owners4, 1),
	%% clue 10 the man who smokes blends lives next to the one who keeps cats
	house_Cigar(Cigars3, blends),
	member(Cigars3, Solution),
	house_Location(Cigars3, LocationA1), % location of blends smoker
	house_Pet(Pets1, cats),
    member(Pets1, Solution),
	house_Location(Pets1, LocationB1), % location of cat owner
	member(LocationB1, Locations),
	nextTo(LocationA1, LocationB1),
    member(LocationA1, Locations),
	%% clue 11 the man who keeps horses lives next to the man who smokes Dunhill
	house_Pet(Pets2, horses),
	member(Pets2, Solution),
	house_Location(Pets2, LocationA2),
	house_Cigar(Cigars2, dunhill),
    member(Cigars2, Solution),
	house_Location(Cigars2, LocationB2), % location of dunhill smoker
	member(LocationB2, Locations),
	nextTo(LocationA2, LocationB2),
    member(LocationA2, Locations),

	%% clue 12 the owner who smokes BlueMaster drinks beer
	house_Cigar(Cigars5, blueMaster),
	member(Cigars5, Solution),
	house_Drink(Cigars5, beer),
	%% clue 13 the German smokes Prince
	house_Owner(Owners5, german),
	member(Owners5, Solution),
	house_Cigar(Owners5, prince),
	%% clue 14 the Norwegian lives next to the blue house
	house_Owner(Owners4, norwegian),
	member(Owners4, Solution),
	house_Location(Owners4, LocationA3),
	house_House(House, blue),
    member(House, Solution),
	house_Location(House, LocationB3), 
	member(LocationB3, Locations),
    nextTo(LocationA3, LocationB3),
    member(LocationA3, Locations),
	
	%% clue 15 the man who smokes blend has a neighbor who drinks water
    house_Cigar(Cigars3, blends),
	member(Cigars3, Solution),
	house_Location(Cigars3, LocationA4),
	house_Drink(Drink, water),
    member(Drink, Solution),
	house_Location(Drink, LocationB4), 
	member(LocationB4, Locations),
    nextTo(LocationA4, LocationB4),
    member(LocationA4, Locations),
	
    %%% instantiate rest of solution structure
    permutation(Owners,
		[RedOwner, GreenOwner, BlueOwner, WhiteOwner, YellowOwner]),
    permutation(Drinks,
		[RedDrink, GreenDrink, BlueDrink, WhiteDrink, YellowDrink]),
    permutation(Cigars,
		[RedCigar, GreenCigar, BlueCigar, WhiteCigar, YellowCigar]),
    permutation(Pets,
		[RedPet, GreenPet, BluePet, WhitePet, YellowPet]),
	permutation(Locations,
		[RedLocation, GreenLocation, BlueLocation, WhiteLocation, YellowLocation]).
	
    %% NEGATIVE CLUES: No negative clues
    % predicates for output...
    solution(Persons):-
    	solve(Persons).
	ownerOfFish(Persons, Owner):-
    	solution(Persons),
    	house_Pet(Pet_fish, fish),
    	member(Pet_fish, Persons),
    	house_Owner(Pet_fish,Owner).
    	
    