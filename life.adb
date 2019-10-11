with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
procedure Life is
   -- D: Die, S: Stay the same, G: Grow a new cell
   type Rules_Type is (D, S, G);
   type Rule_Set is array (Natural range 0 .. 8) of Rules_Type;
   type Grid_Type is array (Natural range <>, Natural range <>) of Boolean;
   type Points_Type is array(Natural range <>, Natural range <>) of Natural;
   type Life (Width  : Natural := 10;
              Height : Natural := 10) is
      record
         Generation : Natural  := 0;
         Rules      : Rule_Set := (D, D, S, G, D, D, D, D, D);
         Grid       : Grid_Type (1 .. Width, 1 .. Height) := (others => (others => false));
         Next_Grid  : Grid_Type (1 .. Width, 1 .. Height) := (others => (others => false));
      end record;

   function Get(Self : Life;
                X    : Natural;
                Y    : Natural) return Boolean is
      begin
         if X > 0 and X <= Self.Width and Y > 0 and Y <= Self.Height then 
            return Self.Grid (X, Y);
         end if;
         return false;
      end get;

   function Get_Neighbors(Self : Life;
                          X    : Natural;
                          Y    : Natural) return Natural is
      Neighbors: Natural;
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

   procedure Print_Grid(Self : Life) is
      begin
         Put ("Generation ");
         Put (Self.Generation);
         Put_Line("");
         Put ("+");
         for X in Self.Grid'Range (1) loop
            Put ("-");
         end loop;
         Put_Line ("+");
         for Y in Self.Grid'Range (2) loop
            Put ("|");
            for X in Self.Grid'Range (1) loop
               if Get(Self, X, Y) then
                  Put("0");
               else
                  Put(" ");
               end if;
            end loop;
            Put_Line ("|");
         end loop;
         Put ("+");
         for X in Self.Grid'Range (1) loop
           Put ("-");
         end loop;
         Put_Line ("+");
      end Print_Grid;

   procedure Next_Generation(Self : out Life) is
      Neighbors  : Natural;
      Next_State : Rules_Type;
      begin
         for X in Integer range 1 .. Self.Width loop
            for Y in Integer range 1 .. Self.Height loop
               Neighbors  := Get_Neighbors(Self, x, y);
               Next_State := Self.Rules (Neighbors);
               if Next_State = G then
                  Self.Next_Grid (X, Y) := TRUE;
               elsif Next_State = D then
                  Self.Next_Grid (X, Y) := FALSE;
               end if;
            end loop;
         end loop;
         Self.Generation := Self.Generation + 1;
         for X in Integer range 1 .. Self.Width loop
            for Y in Integer range 1 .. Self.Height loop
               Self.Grid (X, Y) := Self.Next_Grid(X, Y);
            end loop;
         end loop;
      end Next_Generation;

   procedure Add_Figure(Self   :    out Life;
                        X      : in     Natural;
                        Y      : in     Natural;
                        Points : in     Points_Type) is
     begin
        for I in points'Range loop
           Self.Grid(X+Points(I, 0), Y+Points(I, 1)) := TRUE;
           Self.Next_Grid(X+Points(I, 0), Y+Points(I, 1)) := TRUE;
        end loop;
     end Add_Figure;

   Rpentomino : Points_Type := ((1, 0), (2, 0), (0, 1), (1, 1), (1, 2));
   Block      : Points_Type := ((0, 0), (1, 0), (0, 1), (1, 1));
   Blinker    : Points_Type := ((1, 0), (1, 1), (1, 2));
   Beacon     : Points_Type := ((0, 0), (0, 1), (1, 0), (2, 3), (3, 2), (3, 3));
   Rules      : Rule_Set    := (D, D, S, G, D, D, D, D, D);
   Game       : Life(Width => 20, Height => 10);

   begin
      Add_Figure(Game, 15, 3, BEACON);
      Add_Figure(Game, 5, 5, Rpentomino);
      loop
         Print_Grid(Game);
         Next_Generation(Game);
         delay(1.0);
      end loop;
end Life;
