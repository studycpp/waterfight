program waterfight;

 {
Written by Xu Ganquan
gqxunet@163.com
http://www.AdvNetsoft.com
2002.12.16
modify2004-3-15

}
uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
