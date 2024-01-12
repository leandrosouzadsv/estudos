unit Struct.Pair;

interface

type

  TPair = record
    Name: string;
    Value: string;
    constructor Create(const AName, AValue: string);
  end;

  TPairArray = TArray<TPair>;

implementation

{ TPair }

constructor TPair.Create(const AName, AValue: string);
begin
  Name := AName;
  Value := AValue;
end;

end.
