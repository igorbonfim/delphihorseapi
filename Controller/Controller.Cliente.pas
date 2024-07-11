unit Controller.Cliente;

interface

uses Horse, System.JSON, System.SysUtils, Model.Cliente,
     FireDAC.Comp.Client, Data.DB, DataSet.Serialize;

procedure Registry;

implementation

procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cli: TCliente;
  qry: TFDQuery;
  erro: string;
  arrayClientes: TJSONArray;
begin
  try
    cli := TCliente.Create;
  except
    Res.Send('Erro ao conectar no banco de dados').Status(500);
    exit;
  end;

  try
    qry := cli.ListarCliente('', erro);
    arrayClientes := qry.ToJSONArray();
    Res.Send<TJSONArray>(arrayClientes);
  finally
    qry.Free;
    cli.Free;
  end;
end;

procedure AddCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Cadastrar clientes...');
end;

procedure DeleteCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  Res.Send('Deletar clientes...');
end;

procedure Registry;
begin
  THorse.Get('/cliente', ListarClientes);
  THorse.Post('/cliente', AddCliente);
  THorse.Delete('/cliente', DeleteCliente);
end;

end.
