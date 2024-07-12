program ServerHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.GBSwagger,
  Controller.Cliente in 'Controller\Controller.Cliente.pas',
  Model.Connection in 'Model\Model.Connection.pas',
  Model.Cliente in 'Model\Model.Cliente.pas';

begin
  THorse.Use(Jhonson());
  THorse.Use(HorseSwagger());
  Controller.Cliente.Registry;

  Swagger
    .Info
      .Title('Minha API - Clientes')
      .Description('Projeto API Delphi Horse com Swagger')
      .Contact
        .Name('Igor Bonfim')
      .&End
    .&End
    .BasePath('v1')
    .Path('cliente')
      .Tag('Clientes')
      .GET('Listar Clientes')
        .AddResponse(200, 'Lista de Clientes').Schema(TCliente).IsArray(True).&End
      .&End
      .POST('Criar um novo cliente')
        .AddParamBody('Dados do cliente').Required(True).Schema(TCliente).&End
        .AddResponse(201).Schema(TCliente).&End
        .AddResponse(400).&End
      .&End
    .&End
    .Path('cliente/id_cliente')
      .Tag('Clientes')
      .GET('Obter os dados de um cliente específico')
        .AddParamPath('id', 'Código').&End
        .AddResponse(200, 'Dados do cliente').Schema(TCliente).&End
        .AddResponse(404).&End
      .&End
      .PUT('Alterar os dados de um cliente específico')
        .AddParamPath('id', 'Código').&End
        .AddParamBody('Dados do cliente').Required(True).Schema(TCliente).&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
      .DELETE('Excluir cliente')
        .AddParamPath('id', 'Código').&End
        .AddResponse(204).&End
        .AddResponse(400).&End
        .AddResponse(404).&End
      .&End
    .&End
  .&End;

  THorse.Listen(9000);
end.
