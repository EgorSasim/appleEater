
program AplleEater;
Uses Crt;
Const 
	FIELD_WIDTH = 20;
	FIELD_HEIGHT = 20;
	UP_KEY = 'k';
	RIGHT_KEY = 'l';
	LEFT_KEY = 'h';
	DOWN_KEY = 'j';
Type 
	SubjectPos = record
		X, Y : integer;
	end;

	Player = record
		Name: string;
		Count: integer;
	end;
Var 
	heroPos: SubjectPos;
	applePos: SubjectPos;
	totalCount: integer;
	playerName: string;
	recordsFile: file of Player;

procedure writeField(width, height: integer);
var i, j : integer;
begin
	for i := 0 to width - 1 do
		write('#');
	writeln;
	for i := 0 to height - 3 do
	begin
		write('#');
		for j := 0 to width - 3 do
			write(' ');
		writeln('#');
	end;
	for i := 0 to width - 1 do
		write('#');
end;

procedure writeChar(x, y: integer; character: char; color: byte);
begin
	goToXY(x, y);
	textColor(color);
	write(character);
	textColor(White);
	goToXY(1, 1);
end;

procedure writeHero(x, y: integer);
begin
	writeChar(x, y, '@', LightGreen);
end;

procedure removeHero(x, y: integer);
begin
	writeChar(x, y, ' ', White);
end;

procedure writeAplle(x, y: integer);
begin
	writeChar(x, y, '*', LightRed);
end;

procedure generateAppleCoords;
begin
	applePos.x := Random(FIELD_WIDTH - 2) + 2;
	applePos.y := Random(FIELD_HEIGHT - 2) + 2;

end;

procedure writeTotalInfo;
begin
	textColor(LightCyan);
	gotoXY(3, FIELD_HEIGHT + 3);
	write('TOTAL COUNT: ', totalCount);
	gotoXY(3, FIELD_HEIGHT + 5);
	write('h - left');
	gotoXY(3, FIELD_HEIGHT + 6);
	write('j - bottom');
	gotoXY(3, FIELD_HEIGHT + 7);
	write('k - up');
	gotoXY(3, FIELD_HEIGHT + 8);
	write('l - right');
	gotoXY(3, FIELD_HEIGHT + 9);
	write('any other key to exit program');
	textColor(White);
	gotoXY(1, 1);
end;

procedure checkHeroCoords;
begin
	if (heroPos.x = applePos.x) and (heroPos.y = applePos.y) then
	begin
		totalCount += 1;
		generateAppleCoords;
		writeAplle(applePos.x, applePos.y);
	end;
	if (heroPos.x = 1) then
		heroPos.x := FIELD_WIDTH - 1;
	if (heroPos.x = FIELD_WIDTH) then
		heroPos.x := 2;
	if (heroPos.y = 1) then
		heroPos.y := FIELD_HEIGHT - 1;
	if (heroPos.y = FIELD_HEIGHT) then
		heroPos.y := 2;
end;

procedure writePlayerRecord;
Var plRecord: Player;
begin
	plRecord.name := playerName;
	plRecord.count := totalCount;

	if plRecord.count = 0 then 
		exit;

	assign(recordsFile, 'records.dat');
	{I-}
	Reset(recordsFile);

	if IOResult <> 0 then
		Rewrite(recordsFile);
	Seek(recordsFile, FileSize(recordsFile));
	write(recordsFile, plRecord);
	close(recordsFile);
end;

procedure exitGame;
begin
	clrscr;
	writePlayerRecord;
	Writeln('Thank you for playing!!!');
	writeln('You can check records in ''records.dat'' file');
	delay(3000);
	clrscr;
	halt;
end;

procedure handleHeroMovement;
var
	c: char;
	prevHeroPos: SubjectPos; 
begin
	while true do
	begin
		prevHeroPos := heroPos;
		c := readKey;
		case c of
			UP_KEY: 
				heroPos.y -= 1;
			DOWN_KEY:
				heroPos.y += 1;
			LEFT_KEY:
				heroPos.x -= 1;
			RIGHT_KEY:
				heroPos.x += 1;
		else 
			exitGame;
		end;
		removeHero(prevHeroPos.x, prevHeroPos.y);
		checkHeroCoords;
		writeHero(heroPos.x, heroPos.y);	
		writeTotalInfo;
	end;
end;


procedure setInitialData;
begin
	clrscr;
	heroPos.x := FIELD_WIDTH div 2;
	heroPos.y := FIELD_HEIGHT div 2;
	writeField(FIELD_WIDTH, FIELD_HEIGHT);
	writeHero(heroPos.x, heroPos.y);
	generateAppleCoords;
	writeAplle(applePos.x, applePos.y);
	totalCount := 0;
	writeTotalInfo;
end;

procedure writeTableOfRecords;
var 
	xPos, yPos: integer;
	playerRecords: Player;
begin
	xPos := FIELD_WIDTH + 10;
	yPos := 3;
	goToXY(xPos, yPos);
	textColor(LightCyan);
	write('###TABLE OF RECORDS###');
	yPos += 1;
	goToXY(xPos, yPos);
	write('----------------------');
	yPos := yPos + 1;
	{I-};
	assign(recordsFile, 'records.dat');
	reset(recordsFile);
	if IOResult <> 0 then
		exit;

	while not eof(recordsFile) do
	begin
		yPos += 1;
		goToXY(xPos, yPos);
		read(recordsFile, playerRecords);
		write(playerRecords.Name, ': ', playerRecords.count);
	end;
	yPos := yPos + 2;
	goToXY(xPos, yPos);
	write('----------------------');
	textColor(White);
	goToXY(1, 1);
end;

procedure readUserName;
begin
	write('Set player name: ');
	readln(playerName);
end;




Begin
	randomize;
	readUserName;
	setInitialData;
	writeTableOfRecords;
	handleHeroMovement;
	readln;	
	clrscr;
End.
