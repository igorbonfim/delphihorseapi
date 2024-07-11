unit Model.Cliente;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.Connection;

type
  TCliente = class

  private
    FID_CLIENTE: integer;
    FNOME: string;
    FEMAIL: string;
    FFONE: string;
  public
    constructor Create;
    destructor Destroy; override;
    property ID_CLIENTE: Integer read FID_CLIENTE write FID_CLIENTE;
    property NOME: string read FNOME write FNOME;
    property EMAIL: string read FEMAIL write FEMAIL;
    property FONE: string read FFONE write FFONE;

    function ListarCliente(order_by: string; out erro: string): TFDQuery;
    function Inserir(out erro: string): Boolean;
    function Excluir(out erro: string): Boolean;
end;

implementation

{ TCliente }

constructor TCliente.Create;
begin
  Model.Connection.Connect;
end;

destructor TCliente.Destroy;
begin
  Model.Connection.Disconect;
end;

function TCliente.Excluir(out erro: string): Boolean;
begin

end;

function TCliente.Inserir(out erro: string): Boolean;
begin

end;

function TCliente.ListarCliente(order_by: string; out erro: string): TFDQuery;
var
  qry: TFDQuery;
begin
  try
    qry := TFDQuery.Create(nil);
    qry.Connection := Model.Connection.FConnection;

    with qry do
    begin
      Active := false;
      Sql.Clear;
      Sql.Add('SELECT * FROM TAB_CLIENTE WHERE 1 = 1');

      if ID_CLIENTE = 0 then
      begin
        Sql.Add(' AND ID_CLIENTE = :ID_CLIENTE');
        ParamByName('ID_CLIENTE').Value := ID_CLIENTE;
      end;

      if order_by = '' then
        Sql.Add('ORDER BY NOME')
      else
        Sql.Add('ORDER BY ' +order_by);

      Active := true;
    end;

    erro := '';
    Result := qry;
  except on ex:exception do
    begin
      erro := 'Erro ao consultar clientes: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

end.
