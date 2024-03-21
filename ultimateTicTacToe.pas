uses GraphABC, ABCObjects;

var
  blueCl := RGB(127, 127, 255);
  redCl := RGB(255, 127, 127);
  yellowCl := RGB(255, 255, 127);
  lightblueCl := RGB(190, 190, 255);
  lightredCl := RGB(255, 190, 190);
  
  cursor, target, obj, winner: SquareABC;
  mapImg: PictureABC;
  
  map: array [0..8] of array [0..8] of byte; // 0 - free, 1 - blue, 2 - red;
  mapBig: array [0..2] of array [0..2] of byte; // 0 - free, 1 - blue, 2 - red, 3 - tie;
  tagger: boolean; // true - blue, false - red;
  elXNeed := -1; elYNeed := -1;

procedure setWindow;
begin
  SetWindowSize(360, 360);
  CenterWindow;
  SetWindowTitle('Ultimate Tic Tac Toe');
  SetWindowIsFixedSize(true);
  SetSmoothingOff;
  target := new SquareABC(360, 360, 90, yellowCl);
  target.Bordered := false;
  mapImg := new PictureABC(0, 0, 'images/map.png');
  cursor := new SquareABC(360, 360, 10, blueCl);
  cursor.Bordered := false;
  tagger := true;
  for var i := 0 to 8 do
    for var j := 0 to 8 do
      map[j][i] := 0;
  for var i := 0 to 2 do
    for var j := 0 to 2 do
      mapBig[j][i] := 0;
end;

procedure checkMapBig;
var
  winnerBool: byte; // 0 - not found, 1 - blue, 2 - red;
  lineBlueS := 0; // start
  lineRedS := 0; // start
  lineBlueN := 0; // new
  lineRedN := 0; // new
begin
  for var i := 0 to 2 do
  begin
    for var j := 0 to 2 do
    begin
      if mapBig[i][j] = 1 then lineBlueN += 1;
      if mapBig[i][j] = 2 then lineRedN += 1;
    end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
    lineBlueN := 0;
    lineRedN := 0;
  end;
  
  for var i := 0 to 2 do
  begin
    for var j := 0 to 2 do
    begin
      if mapBig[j][i] = 1 then lineBlueN += 1;
      if mapBig[j][i] = 2 then lineRedN += 1;
    end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
    lineBlueN := 0;
    lineRedN := 0;
  end;
  
  for var i := 0 to 2 do
  begin
    if mapBig[i][i] = 1 then lineBlueN += 1;
    if mapBig[i][i] = 2 then lineRedN += 1;
  end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
    lineBlueN := 0;
    lineRedN := 0;
  
  for var i := 0 to 2 do
  begin
    if mapBig[2 - i][i] = 1 then lineBlueN += 1;
    if mapBig[2 - i][i] = 2 then lineRedN += 1;
  end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
  
  if lineBlueS = 3 then
    new PictureABC(0, 0, 'images/popUpBlue.png');
  
  if lineRedS = 3 then
    new PictureABC(0, 0, 'images/popUpRed.png');
end;

procedure checkMap(elX, elY: byte);
var
  //winnerBool: byte; // 0 - not found, 1 - blue, 2 - red;
  lineBlueS := 0; // start
  lineRedS := 0; // start
  lineBlueN := 0; // new
  lineRedN := 0; // new
begin
  for var i := 0 to 2 do
  begin
    for var j := 0 to 2 do
    begin
      if map[elX + i][elY + j] = 1 then lineBlueN += 1;
      if map[elX + i][elY + j] = 2 then lineRedN += 1;
    end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
    lineBlueN := 0;
    lineRedN := 0;
  end;
  
  for var i := 0 to 2 do
  begin
    for var j := 0 to 2 do
    begin
      if map[elX + j][elY + i] = 1 then lineBlueN += 1;
      if map[elX + j][elY + i] = 2 then lineRedN += 1;
    end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
    lineBlueN := 0;
    lineRedN := 0;
  end;
  
  for var i := 0 to 2 do
  begin
    if map[elX + i][elY + i] = 1 then lineBlueN += 1;
    if map[elX + i][elY + i] = 2 then lineRedN += 1;
  end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
    lineBlueN := 0;
    lineRedN := 0;
  
  for var i := 0 to 2 do
  begin
    if map[elX + 2 - i][elY + i] = 1 then lineBlueN += 1;
    if map[elX + 2 - i][elY + i] = 2 then lineRedN += 1;
  end;
    lineBlueS := Max(lineBlueS, lineBlueN);
    lineRedS := Max(lineRedS, lineRedN);
  
  if lineBlueS = 3 then
  begin
    winner := new SquareABC(elX * 30 + 30 * (elX div 3), elY * 30 + 30 * (elY div 3), 120, lightblueCl);
    mapBig[elX div 3][elY div 3] := 1;
  end;
  
  if lineRedS = 3 then
  begin
    winner := new SquareABC(elX * 30 + 30 * (elX div 3), elY * 30 + 30 * (elY div 3), 120, lightRedCl);
    mapBig[elX div 3][elY div 3] := 2;
  end;
  
  if (lineBlueS = 3) or (lineRedS = 3) then
  begin
    winner.Bordered := false;
    winner.ToBack;
    checkMapBig;
  end;
end;

procedure MouseDown(x, y, mb: integer);
var
  posX, posY, divX, divY, modX, modY, elX, elY: integer;
  clr: Color;
begin
  divX := x div 120;
  divY := y div 120;
  modX := x mod 120;
  modY := y mod 120;
  elX := (divX) * 3 + (modX - 15) div 30;
  elY := (divY) * 3 + (modY - 15) div 30;
  if (modX > 15) and (modX < 105) and (modY > 15) and (modY < 105) and (map[elX][elY] = 0) then
    if ((elXNeed = -1) and (mapBig[elX div 3][elY div 3] = 0)) or ((elXNeed <> -1) and (elX div 3 = elXNeed) and (elY div 3 = elYNeed) and (mapBig[elX div 3][elY div 3] = 0)) then
    begin
      if tagger then
      begin
        clr := blueCl;
        map[elX][elY] := 1;
        cursor.Color := blueCl;
      end
      else
      begin
        clr := redCl;
        map[elX][elY] := 2;
        cursor.Color := redCl;
      end;
      posX := (modX - 15) div 30 * 30 + divX * 120;
      posY := (modY - 15) div 30 * 30 + divY * 120;
      obj := new SquareABC(PosX + 20, posY + 20, 20, clr);
      obj.Bordered := false;
      elXNeed := (modX - 15) div 30;
      elYNeed := (modY - 15) div 30;
      tagger := not tagger;
      if tagger then
        cursor.Color := blueCl
      else
        cursor.Color := redCl;
      cursor.ToFront;
      checkMap(elX div 3 * 3, elY div 3 * 3);
      if (mapBig[elXNeed][elYNeed] = 0) then
        target.Position := (elXNeed * 120 + 15, elYNeed * 120 + 15)
      else
      begin
        target.Position := (360, 360);
        elXNeed := -1;
      end;
    end;
end;

procedure MouseMove(x, y, mb: integer);
begin
  System.Windows.Forms.Cursor.Hide;
  cursor.Center := (x, y);
end;

begin
  setWindow;
  onMouseDown := mouseDown;
  onMouseMove := mouseMove;
  //SaveWindow('screen.png');
end.