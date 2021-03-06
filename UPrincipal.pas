unit UPrincipal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, XPMan,
  StdCtrls,
  jpeg,
  MPlayer,
  Buttons,
  ImgList,
  OleCtrls, SHDocVw,
  ToolWin, System.ImageList, VCLTee.TeCanvas, VCLTee.TeePenDlg,
  cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, cxTrackBar, XiTrackBar, cxProgressBar, XiProgressBar,
  Vcl.AppEvnts, System.Types, System.IOUtils, Vcl.Menus,
  Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnPopup;

  type
  TPrincipalFonePlayer = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Image3: TImage;
    MediaPlayer1: TMediaPlayer;
    OpenDialog1: TOpenDialog;
    Timer1: TTimer;
    ImageList1: TImageList;
    Image4: TImage;
    RichEdit1: TRichEdit;
    btnAdd: TSpeedButton;
    ProgressBar1: TProgressBar;
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    btnTocar: TSpeedButton;
    btnMoveCima: TSpeedButton;
    btnMoveBaixo: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    btnRemove: TSpeedButton;
    btnPlayPause: TSpeedButton;
    btnStop: TSpeedButton;
    chkRA: TCheckBox;
    btnPause: TSpeedButton;
    Panel1: TPanel;
    Image1: TImage;
    XPManifest1: TXPManifest;
    TrackBar1: TTrackBar;
    PopupActionBar1: TPopupActionBar;
    Manual: TMenuItem;
    procedure Panel4DblClick(Sender: TObject);
    procedure Panel10DblClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnTocarClick(Sender: TObject);
    procedure btnMoveCimaClick(Sender: TObject);
    procedure btnMoveBaixoClick(Sender: TObject);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListBox1Enter(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure btnPlayPauseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Panel3MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel4MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel7MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Panel10MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1DblClick(Sender: TObject);
    procedure SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ManualClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function GetEnvVarValue(const VarName: string): string;
    procedure RegisterFileType (prefixo: string; exe: string);

  end;

var
  PrincipalFonePlayer: TPrincipalFonePlayer;
  IndPlayList: Integer;
  posicaoPlayer : Integer;
  posicaoAux : Integer;
  status : Boolean;
  arquivo: TextFile;
  statusBtnPlayPause : Boolean;

implementation

{$R *.dfm}

uses FileCtrl, ShellAPI, registry, shlobj;

procedure TPrincipalFonePlayer.Panel4DblClick(Sender: TObject);
begin
  btnTocar.Caption := 'Tocar';
  MediaPlayer1.Close;
  //MediaPlayer2.Close;
  if OpenDialog1.Execute then
    begin
      MediaPlayer1.FileName := OpenDialog1.FileName;

      MediaPlayer1.Open;
      StatusBar1.Panels.Items[0].Text := 'AGORA:   ' + ExtractFileName(MediaPlayer1.FileName);

      ProgressBar1.Min := 0;
      trackBar1.Min := 0;

      ProgressBar1.Max := MediaPlayer1.Length;
      trackBar1.Max := MediaPlayer1.Length;

      ProgressBar1.Position := MediaPlayer1.Position;
      trackBar1.Position := MediaPlayer1.Position;

      Timer1.Enabled := true;
    end


end;
procedure TPrincipalFonePlayer.Panel10DblClick(Sender: TObject);
begin
{
  MediaPlayer1.Close;
  MediaPlayer2.Close;
  if OpenDialog1.Execute then
    begin
      MediaPlayer2.Display := Panel10;
      MediaPlayer2.DisplayRect := Panel10.ClientRect;
      MediaPlayer2.FileName := OpenDialog1.FileName;

      MediaPlayer2.Open;
      Timer1.Enabled := true;
    end
}
end;

procedure TPrincipalFonePlayer.Timer1Timer(Sender: TObject);
var
  i:Integer;
  StatusRemoverArquivo : integer;
begin
    if (ListBox1.Items.Count -1) > 0 then
    begin
        btnTocar.Enabled := true;
    end;

    if ((btnTocar.Caption = 'Parar Play List') and(status = true)) then
    for i := 0 to ListBox1.Count -1 do
    begin
      if ((ExtractFileName(RichEdit1.Lines[i]) = ListBox1.Items[IndPlayList])) then
      begin
        if(FileExists(RichEdit1.Lines[i]))then
        begin
        MediaPlayer1.FileName := RichEdit1.Lines[i];
        MediaPlayer1.Open;
        StatusBar1.Panels.Items[0].Text := 'AGORA:   ' + ExtractFileName(MediaPlayer1.FileName);

        ProgressBar1.Min := 0;
        trackBar1.Min := 0;
        ProgressBar1.Max := MediaPlayer1.Length;
        trackBar1.Max := MediaPlayer1.Length;

        MediaPlayer1.Position := posicaoPlayer;
        posicaoPlayer := 0;

        ProgressBar1.Position := MediaPlayer1.Position;
        trackBar1.Position := MediaPlayer1.Position;

        status := false;
        Timer1.Enabled := true;
        MediaPlayer1.Play;

        ListBox1.Selected[IndPlayList] := true;
        end else
        begin
          //nesse caso o arquivo esta na lista mais n�o existe mais
          StatusRemoverArquivo := Application.MessageBox('Arquivo n�o encontrado. Deseja remover-lo da playList?', 'Arquivo Inexistente', mb_iconinformation + MB_YESNO);
          if(StatusRemoverArquivo = 6)then
          begin
              //
              RichEdit1.Lines.Delete(i);
              RichEdit1.Lines.SaveToFile(extractFilepath(application.exename) + 'test.txt');
              ListBox1.Items.Delete(IndPlayList);
              IndPlayList := IndPlayList -1;
          end;
          MediaPlayer1.Next;
          StatusRemoverArquivo := 0;
        end;
      end;
      status := false;
    end;

    if Progressbar1.Max <> 0 then
    begin
      Progressbar1.Position := mediaplayer1.Position;
      //trackbar1.Position := mediaplayer1.Position;
    end;

    if (Progressbar1.Position = Progressbar1.Max) then
    begin
      if (btnTocar.Caption = 'Parar Play List') then
        begin
          if(IndPlayList = (ListBox1.Count-1)) then
            begin
              IndPlayList := 0;
              status := true;
              ListBox1.Selected[IndPlayList] := true
            end
          else
            begin
              IndPlayList := IndPlayList +1;
              status := true;
              ListBox1.Selected[IndPlayList] := true;
            end;
            if(chkRA.Checked = true) then
            begin
              Randomize;
              IndPlayList := Random(ListBox1.Items.Count -1);
            end;
        end
    end;

end;

procedure TPrincipalFonePlayer.TrackBar1Change(Sender: TObject);
begin
  MediaPlayer1.Position := TrackBar1.Position;
  MediaPlayer1.Play;
end;

procedure TPrincipalFonePlayer.btnPauseClick(Sender: TObject);
begin
  {PageControl1.ActivePageIndex := 0; }
  MediaPlayer1.Pause;
end;

procedure TPrincipalFonePlayer.FormResize(Sender: TObject);
begin
  //MediaPlayer2.DisplayRect := Panel10.ClientRect;
end;

procedure TPrincipalFonePlayer.FormShow(Sender: TObject);
begin

  // da System.IOUtils : Retonra caminho documents
  //ShowMessage(TPath.GetDocumentsPath);

  // Exibe a localiza��o do diret�rio do Windows
  //Pesquisar vari�veis de ambiente do windows: https://en.wikipedia.org/wiki/Environment_variable#Default_values
  //ShowMessage(GetEnvVarValue('USERPROFILE')+ '\FonePlayer'); //UserProfile � o caminho da pasta do usu�rios

  //Cria Pasta FonePlayer na pasta do usu�rio
  if NOT (DirectoryExists(GetEnvVarValue('USERPROFILE') + '\FonePlayer')) then
  begin
    ForceDirectories(GetEnvVarValue('USERPROFILE') + '\FonePlayer');
  end;

end;

function TPrincipalFonePlayer.GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;
begin
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName),
      PChar(Result), BufSize);
  end
  else
    Result := '';
end;

procedure TPrincipalFonePlayer.btnTocarClick(Sender: TObject);
var
  WSidesOfScreenH, WSidesOfScreenV: Integer;
begin
{
  MediaPlayer2.Display := Panel5;
  MediaPlayer2.FileName := (extractFilepath(application.exename) + 'tp.mp4');
  MediaPlayer2.DisplayRect := Panel5.ClientRect;
  MediaPlayer2.Open;
  MediaPlayer2.Play;
  Timer1.Enabled := true;
  }
  {
  try
    // Altera o tamanho do panel com o mesmo tamano do v�deo:
    //Self.Panel4.Width := MediaPlayer2.DisplayRect.Width;
    //Self.Panel4.Height := MediaPlayer2.DisplayRect.Height;

    // Centraliza o panel:
    // Laterais do v�deo (altura da tela - altura do v�deo).
    WSidesOfScreenV := Screen.Height - Self.Height;
    Self.Panel4.Top := WSidesOfScreenV div 2;
    // Laterais do v�deo (largura da tela - largura do v�deo).
    WSidesOfScreenH := Screen.Width - Self.Panel4.Width;
    Self.Panel4.Left := WSidesOfScreenH div 2;
  except
    on E: Exception do
      ShowMessage('Ocorreu um erro ao redimensionar o v�deo na tela.' + #13 + E.Message);
  end;
end;

  }


  { Abrir prote��o de tela
  SendMessage(Application.Handle, WM_SYSCOMMAND, SC_SCREENSAVE, 0); }

  if( ListBox1.Count > 0)then
  begin
      if (btnTocar.Caption = 'Parar Play List') then
      begin
        btnTocar.Caption := 'Tocar';
        chkRA.Visible := false;
        MediaPlayer1.Stop;
        status := false; //D*
      end else
        begin
        btnTocar.Caption := 'Parar Play List';
        status := true;
        Timer1.Enabled := true;
        chkRA.Visible := true;
        chkRA.Checked:= false;
      end;
  end else
    ShowMessage('Adicione arquivos a PlayList');

end;

procedure TPrincipalFonePlayer.btnMoveCimaClick(Sender: TObject);
var
posicao: integer;
strAux: String;
i: integer;
begin
  posicao := ListBox1.ItemIndex;
  strAux := ListBox1.Items[posicao];

  listbox1.Items.Move(ListBox1.ItemIndex,ListBox1.ItemIndex - 1);
  RichEdit1.lines.Move(ListBox1.ItemIndex,ListBox1.ItemIndex - 1);
  if posicao <= 0 then
    posicao := ListBox1.Items.Count;
  ListBox1.ItemIndex := posicao - 1;

  for i := 0 to ListBox1.Items.Count-1 do
  begin
    if (ListBox1.Items[i] = strAux) then
      IndPlayList := i;
  end;
end;

procedure TPrincipalFonePlayer.btnMoveBaixoClick(Sender: TObject);
var
posicao: integer;
strAux: String;
i: integer;
begin
  posicao := ListBox1.ItemIndex;
  strAux := ListBox1.Items[posicao];

  if posicao >= ListBox1.Items.Count -1 then begin
  listbox1.Items.Move(ListBox1.ItemIndex,0);
  posicao := -1;
  end else
  listbox1.Items.Move(ListBox1.ItemIndex,ListBox1.ItemIndex + 1);
  ListBox1.ItemIndex := posicao + 1;

  for i := 0 to ListBox1.Items.Count-1 do
  begin
    if (ListBox1.Items[i] = strAux) then
      IndPlayList := i;
  end;

end;

procedure TPrincipalFonePlayer.ListBox1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  DropIndex: Integer;
begin
  DropIndex := TListBox(Sender).ItemAtPos(Point(X,Y),False);
  with TListBox(Source) do
  begin
    TListBox(Sender).Items.Insert(DropIndex, Items[ItemIndex]);
    Items.Delete(ItemIndex);
  end;
end;

procedure TPrincipalFonePlayer.ListBox1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  DropIndex: Integer;
  TempStr: string;
begin
  with TListBox(Sender) do
  begin
    DropIndex := ItemAtPos(Point(X,Y), True);
    if (DropIndex > -1) and (DropIndex <> ItemIndex) then
    begin
      TempStr := Items[DropIndex];
      Items[DropIndex] := Items[ItemIndex];
      Items[ItemIndex] := TempStr;
      ItemIndex := DropIndex;
    end;
  end;
end;

procedure TPrincipalFonePlayer.SpeedButton1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {se botao j� foi pressionado}
  if(TSpeedButton(Sender).Down)then
    exit  //sai da fun��o
  else
    {primeira vez que pressiona}
    ShowMessage('clicado'); //sua rotina
end;

procedure TPrincipalFonePlayer.SpeedButton5Click(Sender: TObject);
begin
if (btnTocar.Caption = 'Parar Play List') then
  begin
    if(IndPlayList = (ListBox1.Count-1)) then
    begin
      IndPlayList := 0;
      status := true
    end
    else
      begin
        IndPlayList := IndPlayList +1;
        status := true
      end;
      if(chkRA.Checked = true) then
      begin
          IndPlayList := Random(100) mod (ListBox1.Items.Count-1);
      end;
  end

end;

procedure TPrincipalFonePlayer.SpeedButton6Click(Sender: TObject);
begin
    if(IndPlayList = 0) then
    begin
      IndPlayList := ListBox1.Count-1;
      status := true
    end
    else
      begin
        IndPlayList := IndPlayList -1;
        status := true
      end;
     if(chkRA.Checked = true) then
      begin
          IndPlayList := Random(100) mod (ListBox1.Items.Count-1);
      end;

end;

procedure TPrincipalFonePlayer.btnAddClick(Sender: TObject);
begin

  //Verifica se pasta do FonePlayer existe na pasta do usu�rio
  if NOT (DirectoryExists(GetEnvVarValue('USERPROFILE') + '\FonePlayer')) then
  begin
    ForceDirectories(GetEnvVarValue('USERPROFILE') + '\FonePlayer');
  end;

  if OpenDialog1.Execute then
  begin
      RichEdit1.Lines.Add(OpenDialog1.FileName);
      //RichEdit1.Lines.SaveToFile(extractFilepath(application.exename) + 'test.txt');
      RichEdit1.Lines.SaveToFile(GetEnvVarValue('USERPROFILE') + '\FonePlayer\playList.txt');
      ListBox1.Items.Add(ExtractFileName(OpenDialog1.FileName));
      btnTocar.Enabled := true;
  end;
  OpenDialog1.FileName := '';
end;

procedure TPrincipalFonePlayer.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  iListB:integer;
  srtArq: string;
begin

  //Deleta IndPlayList.txt
  if (fileexists(GetEnvVarValue('USERPROFILE') + '\IndPlayList.txt')) then
  begin
      Windows.DeleteFile(PChar(GetEnvVarValue('USERPROFILE') + '\IndPlayList.txt'));
  end;


  if(MediaPlayer1.Position <> ProgressBar1.Max)then
  begin
    if(ListBox1.Count > 0)then
    begin

        AssignFile(arquivo, (GetEnvVarValue('USERPROFILE') + '\IndPlayList.txt') );
        rewrite(Arquivo);
        WriteLn(arquivo, ListBox1.Items[IndPlayList]);
        WriteLn(arquivo, MediaPlayer1.Position);
        CloseFile(Arquivo);

       {OBS: Melhorar Isso aqui, ta tenso!}
       AssignFile(arquivo, (GetEnvVarValue('USERPROFILE') + '\playList.txt') );
       Rewrite(arquivo);
       for iListB := 0 to ListBox1.Items.Count-1 do
       begin
          for i := 0 to RichEdit1.Lines.Count-1 do
          begin
            if ExtractFileName(RichEdit1.Lines[i]) = ListBox1.Items[iListB] then
                WriteLn(arquivo, RichEdit1.Lines[i]);
          end;
       end;
       CloseFile(Arquivo);

       RichEdit1.Lines.Clear;
       AssignFile(arquivo, (GetEnvVarValue('USERPROFILE') + '\playList.txt') );
       reset(arquivo);
       While Not (EOF(arquivo)) Do     //Enquanto n�o for o fim do arquivo fa�a
       begin
              Readln(arquivo, srtArq);
              RichEdit1.Lines.Add(srtArq);
       end;
       CloseFile(Arquivo);
       RichEdit1.Lines.SaveToFile(GetEnvVarValue('USERPROFILE') + '\playList.txt');
    end;
  end;
end;

procedure TPrincipalFonePlayer.FormCreate(Sender: TObject);
var
  i:integer;
  str:String;
begin

  //verifica se foi passado algum caminho de m�sica
  if (FileExists(ParamStr(1))) or (ParamStr(1) <> '') then
  begin
      MediaPlayer1.FileName := ParamStr(1);
      if(MediaPlayer1.FileName <> '')then
      begin
          //Se sim, verifica o formato e reproduz a m�sica
          if(extractfileext(ParamStr(1)) = '.mp3')then
          begin
              StatusBar1.Panels.Items[0].Text := 'AGORA:   ' + ExtractFileName(MediaPlayer1.FileName);
              ProgressBar1.Min := 0;
              trackBar1.Min := 0;
              MediaPlayer1.Open;
              ProgressBar1.Max := MediaPlayer1.Length;
              trackBar1.Max := MediaPlayer1.Length;
              ProgressBar1.Position := MediaPlayer1.Position;
              trackBar1.Position := MediaPlayer1.Position;
              Timer1.Enabled := true;
              MediaPlayer1.Play;
          end;
      end;
  end else
  begin

      //LEITURA DE ARQUIVOS
      //Se n�o foi passado nenhum caminho, tenta carregar Playlist;
      if (fileexists(GetEnvVarValue('USERPROFILE') + '\FonePlayer\playList.txt')) then
      begin
          RichEdit1.Lines.LoadFromFile(GetEnvVarValue('USERPROFILE') + '\FonePlayer\playList.txt');
          StatusBar1.Panels.Items[0].Text := 'Aguardando M�sica... ';// 'Arquivo playList.txt';
          btnTocar.Enabled := true;

          for i := 0 to RichEdit1.Lines.Count -1 do
          begin
            str := RichEdit1.Lines[i];
            ListBox1.Items.Add(ExtractFileName(str));

          end;
      end;



      //Se n�o foi passado nenhum caminho, tenta carregar musica que estava tocando da ultima vez;
      if (fileexists(GetEnvVarValue('USERPROFILE') + '\IndPlayList.txt')) then
      begin
          AssignFile(arquivo, (GetEnvVarValue('USERPROFILE') + '\IndPlayList.txt') );
          reset(arquivo);
          While Not (EOF(arquivo)) Do     //Enquanto n�o for o fim do arquivo fa�a
          begin
              Readln(arquivo, str);
              for i := 0 to ListBox1.Items.Count-1 do
              begin
                if (ListBox1.Items[i] = str) then
                  IndPlayList := i;
              end;

              Readln(arquivo, posicaoPlayer);
          end;
          {ListBox1.Selected[IndPlayList] := true; }
          CloseFile(Arquivo);
          status := false;
      end else
      begin
          IndPlayList := 0;
          posicaoPlayer := 0;
      end;

  end;

  //Registro
  //ShowMessage(Application.ExeName);
  //RegisterFileType('mp3', Application.ExeName);
end;

procedure TPrincipalFonePlayer.ListBox1Enter(Sender: TObject);
begin
  btnMoveCima.Enabled := true;
  btnMoveBaixo.Enabled := true;
  btnremove.Enabled := true;
  btnRemove.Enabled := true;
end;

procedure TPrincipalFonePlayer.ManualClick(Sender: TObject);
var
buffer: String;
begin
  buffer := 'http://github.com/ruannicolini/FonePlayer';
  ShellExecute(Application.Handle, nil, PChar(buffer), nil, nil, SW_SHOWNORMAL); // da ShellAPI
end;

procedure TPrincipalFonePlayer.btnRemoveClick(Sender: TObject);
var
  i:integer;
begin
  for i := 0 to RichEdit1.Lines.Count -1 do
  begin
      if ((ExtractFileName(RichEdit1.Lines[i]) = ListBox1.Items[ListBox1.ItemIndex])) then
      begin
        RichEdit1.Lines.Delete(i);
        RichEdit1.Lines.SaveToFile(GetEnvVarValue('USERPROFILE') + '\FonePlayer\playList.txt');
      end;
      status := false;
  end;

  if(ListBox1.Count -1 > 1)then
  begin
      if( ListBox1.ItemIndex = IndPlayList)then
      begin
        IndPlayList := IndPlayList -1;
        MediaPlayer1.Next;
      end;
  end else
  begin
      btnTocar.Caption := 'Tocar';
      chkRA.Visible := false;
      MediaPlayer1.Close;
      MediaPlayer1.Open;
      status := false; //D*
  end;
  ListBox1.DeleteSelected;

end;

procedure TPrincipalFonePlayer.btnPlayPauseClick(Sender: TObject);
begin
  if (MediaPlayer1.Mode = mpPlaying)then
  begin
    //ShowMessage('Tocando!');
  end;

  if(MediaPlayer1.FileName = '')then
  begin
    Image1DblClick(sender);
  end;

  if(MediaPlayer1.Mode = mpPaused)then
  begin
     //MP Pausado
     //ShowMessage('mpPaused');
     MediaPlayer1.Play;
  end;

  if(MediaPlayer1.Mode = mpStopped)then
  begin
     //MP Em Stop
     //ShowMessage('mpStopped');
     MediaPlayer1.Play;
  end;

end;

procedure TPrincipalFonePlayer.btnStopClick(Sender: TObject);
begin
  MediaPlayer1.Rewind;
  MediaPlayer1.Stop;
  btnTocar.Caption := 'Tocar';
  chkRA.Visible := false;
end;

procedure TPrincipalFonePlayer.Panel3MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Panel3.Visible := false;
end;

procedure TPrincipalFonePlayer.Panel4MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  panel3.Visible := true;
end;

procedure TPrincipalFonePlayer.Panel3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  panel3.Visible := false;
end;

procedure TPrincipalFonePlayer.Image3MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  panel3.Visible := false;
end;

procedure TPrincipalFonePlayer.Panel7MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  panel3.Visible := false;
end;

procedure TPrincipalFonePlayer.RegisterFileType(prefixo, exe: string);
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;
  //reg := TRegistry.Create(KEY_ALL_ACCESS);
  //reg := TRegistry.Create(KEY_READ);
  try
      reg.RootKey := HKEY_CLASSES_ROOT;
      reg.OpenKey ('.' + prefixo, True);
      try
        reg.Writestring('', prefixo + 'file');
      finally
        reg.CloseKey;
      end;

      reg.CreateKey (prefixo + 'file');
      reg.OpenKey (prefixo + 'file\DefaultIcon', True);
      try
        reg.Writestring('', exe + ',0');
      finally
        reg.CloseKey;
      end;

      reg.OpenKey(prefixo + 'file\shell\open\command', True);
      try
        reg.Writestring('', exe + ' "�1"');
      finally
        reg.CloseKey;
      end;
  finally
      reg.Free;
  end;
 SHChangeNotify (SHCNE_ASSOCCHANGED, SHCNF_IDLIST, nil, nil);
end;

procedure TPrincipalFonePlayer.ListBox1DblClick(Sender: TObject);
begin
  if(listbox1.itemindex <> -1) then
  begin
    IndPlayList := listbox1.itemindex;
    btnTocar.Caption := 'Parar Play List';
    status := true;
    Timer1.Enabled := true;
    chkRA.Visible := true;
    chkRA.Checked:= false;
  end;
end;

procedure TPrincipalFonePlayer.Panel10MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  panel3.Visible := true;
end;

procedure TPrincipalFonePlayer.Image1DblClick(Sender: TObject);
begin
  btnTocar.Caption := 'Tocar';

  if OpenDialog1.Execute then
  begin
      MediaPlayer1.FileName := OpenDialog1.FileName;
      if(MediaPlayer1.FileName <> '')then
      begin
        StatusBar1.Panels.Items[0].Text := 'AGORA:   ' + ExtractFileName(MediaPlayer1.FileName);
        ProgressBar1.Min := 0;
        trackBar1.Min := 0;

        MediaPlayer1.Open;
        ProgressBar1.Max := MediaPlayer1.Length;
        trackBar1.Max := MediaPlayer1.Length;
        ProgressBar1.Position := MediaPlayer1.Position;
        trackBar1.Position := MediaPlayer1.Position;
        Timer1.Enabled := true;
        MediaPlayer1.Play;
      end;
  end;
  OpenDialog1.FileName := '';


end;

end.


