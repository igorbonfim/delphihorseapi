unit Controller.Cliente;

interface

uses Horse, System.JSON, System.SysUtils, Model.Cliente,
     FireDAC.Comp.Client, Data.DB, DataSet.Serialize,
     Horse.GBSwagger.Register, Horse.GBSwagger.Controller;

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

procedure ListarClientesID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cli: TCliente;
  qry: TFDQuery;
  erro: string;
  objClientes: TJSONObject;
begin
  try
    cli := TCliente.Create;
    cli.ID_CLIENTE := Req.Params['id'].ToInteger;
  except
    Res.Send('Erro ao conectar com o  banco de dados').Status(500);
    exit;
  end;

  try
    qry := cli.ListarCliente('', erro);

    if qry.RecordCount > 0 then
    begin
      objClientes := qry.ToJSONObject;
      Res.Send<TJSONObject>(objClientes);
    end
    else
      Res.Send('Cliente n�o encontrado').Status(404);
  finally
    qry.Free;
    cli.Free;
  end;
end;

procedure AddCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cli: TCliente;
  erro: string;
  objClientes: TJSONObject;
  body: TJSONValue;
begin
  try
    cli := TCliente.Create;
  except
    Res.Send('Erro ao conectar com o banco de dados').Status(500);
    exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJSONValue;

      cli.NOME := body.GetValue<string>('NOME', '');
      cli.EMAIL := body.GetValue<string>('EMAIL', '');
      cli.FONE := body.GetValue<string>('FONE', '');
      cli.Inserir(erro);

      body.Free;

      if erro <> '' then
        raise Exception.Create(erro);
    except on ex:exception do
      begin
        Res.Send(ex.Message).Status(400);
        exit;
      end;
    end;
  finally

  end;
end;

procedure DeleteCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cli : TCliente;
  objCliente: TJSONObject;
  erro : string;
begin
  // Conexao com o banco...
  try
    cli := TCliente.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      cli.ID_CLIENTE := Req.Params['id'].ToInteger;

      if NOT cli.Excluir(erro) then
        raise Exception.Create(erro);

    except on ex:exception do
      begin
        res.Send(ex.Message).Status(400);
        exit;
      end;
    end;


    objCliente := TJSONObject.Create;
    objCliente.AddPair('id_cliente', cli.ID_CLIENTE.ToString);

    res.Send<TJSONObject>(objCliente);
  finally
    cli.Free;
  end;
end;

procedure EditarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  cli : TCliente;
  objCliente: TJSONObject;
  erro : string;
  body : TJsonValue;
begin  
  try
    cli := TCliente.Create;
  except
    res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

      cli.ID_CLIENTE := body.GetValue<integer>('id_cliente', 0);
      cli.NOME := body.GetValue<string>('nome', '');
      cli.EMAIL := body.GetValue<string>('email', '');
      cli.FONE := body.GetValue<string>('fone', '');
      cli.Editar(erro);

      body.Free;

      if erro <> '' then
          raise Exception.Create(erro);

    except on ex:exception do
      begin
          res.Send(ex.Message).Status(400);
          exit;
      end;
    end;


    objCliente := TJSONObject.Create;
    objCliente.AddPair('id_cliente', cli.ID_CLIENTE.ToString);

    res.Send<TJSONObject>(objCliente).Status(200);
  finally
    cli.Free;
  end;
end;

procedure Registry;
begin
  THorse.Group.Prefix('v1')
  .Get('/cliente', ListarClientes)
  .Get('/cliente/:id', ListarClientesID)
  .Post('/cliente', AddCliente)
  .Put('/cliente/:id', EditarCliente)
  .Delete('/cliente/:id', DeleteCliente);
end;

end.
