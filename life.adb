with Ada.Text_IO; use Ada.Text_IO;
procedure Life is
-- D: Die, S: Stay the same, G: Grow a new cell
type Rules_Types is (D, S, G);
type Rule_Set is array (Integer range <>) of RuleTypes;
type Number_Of_Neighbors is range 0 .. 8;
type Grid is array (Integer range <>, Integer range <>) of Boolean;
type Life (Rules : Rule_Set; width : Natural; height : Natural) is record
  generation : Natural;
  Rules      : Rule_Set;
  width      : Natural;
  height     : Natural;
  grid       : Grid;
end record;
type Points is array(Integer range <>, Natural range <>) of Natural;
  --  type Life (Rules : Rule_Set, Width : Natural, Height : Natural) is record
  --    Generation : Natural := 0;
  --    Rules : Rule_Set:= Rules;
  --    Width : Natural := Width;
  --    Height : Natural := Height;
  --    Grid : Grid := (others => (others => false));
  --  end record;

  function Get(Self : Life;
               X    : Natural;
               Y    : Natural) return Boolean is
  begin
    if X >= 0 and X < Self.Width and Y >= 0 and Y < Self.Height then 
      return grid (X, Y);
    end if;
    return false;
  end get;

  function Get_Neighbors(Self : Life;
                         X    : Natural;
                         Y    : Natural) return Natural is
    Neighbors: Number_Of_Neighbors;
  begin
    Neighbors := 0;
    for X_Offset in Integer range -1 .. 1 loop
      for Y_Offset in Integer range -1 .. 1 loop
        -- Don't count the offset 0, 0
        if X_Offset /= 0 or Y_Offset /= 0 then
          if get(Self, X+X_Offset, Y+Y_Offset) then
            Neighbors := Neighbors + 1;
          end if;
        end if;
      end loop;
    end loop;
    return Neighbors;
  end Get_Neighbors;

procedure Draw_Grid(grid : Grid) is
      X: Natural;
  begin
    Put ("Generation ");
    Put (Self.Generation);
    Put ("\n+");
    for X in grid'Range (1) loop
      Put ("-");
    end loop;
    Put_Line ("+");

    for Y in grid'Range (2) loop
      Put ("|");
      for X in grid'Range (1) loop
        if get(grid, X, Y) then
          Put("0");
        else
          Put(" ");
        end if;
      end loop;
      Put_Line ("|");
    end loop;

    Put ("+");
    for X in grid'Range (1) loop
      Put ("-");
    end loop;
    Put_Line ("+");
  end Draw_Grid;

  procedure Next_Generation(Self : Life) is
    Next_Grid  : Grid;
    X          : Integer;
    Y          : Integer;
    Neighbors  : Natural;
    Next_State : Natural;
  begin
      Next_Grid := (others => (others => false));
    for X in Integer range 0 .. Self.Width - 1 loop
      for Y in Integer range 0 .. Self.Height - 1 loop
        Neighbors  := Get_Neighbors(Self, x, y);
        Next_State := Self.Rules (Neighbors);
        if Next_State = G then
          Self.Next_Grid (X)(Y) := TRUE;
        elsif Next_State = D then
          Self.Next_Grid (X)(Y) := FALSE;
        end if;
      end loop;
    end loop;
    Self.Generation := Self.Generation + 1;
    for X in Integer range 0 .. Self.Width - 1 loop
      for Y in Integer range 0 .. Self.Height - 1 loop
        Self.Grid (X)(Y) := Self.nextGrid(X)(Y);
      end loop;
    end loop;
  end Next_Generation;

  procedure Add_Figure(Self   : Life;
                       X      : Natural;
                       Y      : Natural;
                       points : Points) is
  begin
    for I in points'Range (2) loop
      Self.Grid(X+Points(I)(1))(Y+Points(I)(2)) := TRUE;
      Self.Next_Grid(X+Points(I)(1))(Y+Points(I)(2)) := TRUE;
    end loop;
  end Add_Figure;

  RPENTOMINO : Points   := ((1, 0), (2, 0), (0, 1), (1, 1), (1, 2));
  BLOCK      : Points   := ((0, 0), (1, 0), (0, 1), (1, 1));
  BLINKER    : Points   := ((1, 0), (1, 1), (1, 2));
  BEACON     : Points   := ((0, 0), (0, 1), (1, 0), (2, 3), (3, 2), (3, 3));
  Rules      : Rule_Set := (D, D, S, G, D, D, D, D, D);
  WIDTH      : Integer  := 10; 
  HEIGHT     : Integer  := 10; 

begin

  -- Life game = {
  --   .generation = 0,
  --   .rules = rules,
  --   .width = WIDTH,
  --   .height = HEIGHT,
  --   .grid = grid,
  --   .nextGrid = nextGrid
  -- };
    
  Add_Figure(game, 0, 0, BEACON, 6);
  Add_Figure(game, 4, 4, RPENTOMINO, 5);

  loop
    Print_Grid(game);
    Next_Generation(game);
    sleep(1);
  end loop;
end Life;
